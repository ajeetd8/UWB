import java.util.*;

public class Cache {
    private int blockSize;
    private Vector pages;
    private int victim;

    private class Entry {
	public static final int INVALID = -1;
	public boolean reference;
	public boolean dirty;
	public int frame;
	public Entry( ) {
	    reference = false;
	    dirty = false;
	    frame = INVALID;
	}
    }

    private Entry[] pageTable = null;

    private int findFreePage( ) {
	for ( int i = 0; i < pageTable.length; i++ ) {
	    if ( pageTable[i].frame == Entry.INVALID )
		return i;
	}
	return -1;
    }

    private int nextVictim( ) {
	while ( true ) {
	    victim = ( victim + 1 ) % pageTable.length;
	    if ( pageTable[victim].reference == false )
		return victim;
	    pageTable[victim].reference = false;
	}
    }

    private void writeBack( int victimEntry ) {
	//System.out.println( "writeBack: " + victimEntry );
	if ( pageTable[victimEntry].frame != Entry.INVALID && 
	     pageTable[victimEntry].dirty == true ) {
	    byte[] p = (byte[])pages.elementAt( victimEntry );
	    SysLib.rawwrite( pageTable[victimEntry].frame, p );
	    pageTable[victimEntry].dirty = false;
	}
    }

    public Cache( int blockSize, int cacheBlocks ) {
	this.blockSize = blockSize;
	pages = new Vector( );
	for ( int i = 0; i < cacheBlocks; i++ ) {
	    byte[] p = new byte[blockSize];
	    pages.addElement( p );
	}
	victim = cacheBlocks - 1; // set the last frame as a previous victim
	pageTable = new Entry[ cacheBlocks ];
	for ( int i = 0; i < cacheBlocks; i++ )
	    pageTable[i] = new Entry( );
    }

    public synchronized boolean read( int blockId, byte buffer[] ) {
	if ( blockId < 0 ) {
	    SysLib.cerr( "threadOS: a wrong blockId for cread\n" );
	    return false;
	}

	// locate a valid page
	for ( int i = 0; i < pageTable.length; i++ ) {
	    if ( pageTable[i].frame == blockId ) {
		byte[] p = (byte[])pages.elementAt( i );
		System.arraycopy( p, 0, buffer, 0, blockSize );
		pageTable[i].reference = true;
		return true;
	    }
	}

	// page miss
        // find an invalid page
        int victimEntry;
	if ( ( victimEntry = findFreePage( ) ) == -1 ) {
	    // all pages are full.
	    // seek for a victim
	    victimEntry = nextVictim( );
	}

	// write back a dirty copy
	writeBack( victimEntry );

	// read a requested block from disk
	SysLib.rawread( blockId, buffer );

	// cache it
	byte[] p = new byte[blockSize];
	System.arraycopy( buffer, 0, p, 0, blockSize );
	pages.set( victimEntry, p );
	pageTable[victimEntry].frame = blockId;
	pageTable[victimEntry].reference = true;
	return true;
    }

    public synchronized boolean write( int blockId, byte buffer[] ) {
	if ( blockId < 0 ) {
	    SysLib.cerr( "threadOS: a wrong blockId for cwrite\n" );
	    return false;
	}

	// locate a valid page
	for ( int i = 0; i < pageTable.length; i++ ) {
	    if ( pageTable[i].frame == blockId ) {
		byte[] p = new byte[blockSize];
		System.arraycopy( buffer, 0, p, 0, blockSize );
		pages.set( i, p );
		pageTable[i].reference = true;
		pageTable[i].dirty = true;
		return true;
	    }
	}

	// page miss
        // find an invalid page
        int victimEntry;
	if ( ( victimEntry = findFreePage( ) ) == -1 ) {
	    // all pages are full.
	    // seek for a victim
	    victimEntry = nextVictim( );
	}

	// write back a dirty copy
	writeBack( victimEntry );

	// cache it but not write through.
	byte[] p = new byte[blockSize];
	System.arraycopy( buffer, 0, p, 0, blockSize );
	pages.set( victimEntry, p );
	pageTable[victimEntry].frame = blockId;
	pageTable[victimEntry].reference = true;
	pageTable[victimEntry].dirty = true;
	return true;
    }

    public synchronized void sync( ) {
	for ( int i = 0; i < pageTable.length; i++ )
	    writeBack( i );
	SysLib.sync( );
    }

    public synchronized void flush( ) {
	for ( int i = 0; i < pageTable.length; i++ ) {
	    writeBack( i );
	    pageTable[i].reference = false;
	    pageTable[i].frame = Entry.INVALID;
	}
	SysLib.sync( );
    }
}
