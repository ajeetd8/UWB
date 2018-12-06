import java.util.*;

public class QueueNode {
    private Vector pidQueue;

    public QueueNode( ) {
	pidQueue = new Vector( );
	pidQueue.clear( );
    }

    public synchronized int sleep( ) {
	if ( pidQueue.size( ) == 0 ) {
	    try {
		wait( );
	    } catch ( InterruptedException e ) {
	    }
	}
	Integer pid = ( Integer )pidQueue.remove( 0 );
	return pid.intValue( );
    }

    public synchronized void wakeup( int pid ) {
	pidQueue.add( new Integer( pid ) );
	notify( );
    }
}
