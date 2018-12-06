import java.util.Date;

class Test3 extends Thread {

    private int pairs;

    public Test3 ( String args[] ) {
        pairs = Integer.parseInt( args[0] );
    }

    public void run( ) {
	String[] args1 = SysLib.stringToArgs( "TestThread3 comp" ); // computation intensive
	String[] args2 = SysLib.stringToArgs( "TestThread3 disk" ); // disk intensive

	long startTime = (new Date( ) ).getTime( );
	for ( int i = 0; i < pairs; i++ ) {
	    SysLib.exec( args1 );
	    SysLib.exec( args2 );
	}
	for (int i = 0; i < pairs * 2; i++ )
	    SysLib.join( );
	long endTime = (new Date( ) ).getTime( );

	SysLib.cout( "elapsed time = " + ( endTime - startTime ) + " msec.\n" );
	SysLib.exit( );
    }
}
