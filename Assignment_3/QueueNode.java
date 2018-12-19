import java.util.*;

/**
 * QueueNode is where we save the process block (theoretically).
 * 
 * @author Haram_Kwon
 *
 */
public class QueueNode {
    private Vector pidQueue;

    /**
     * The constructor, to initialize the QueueNode within the pidQueue vector.
     */
    public QueueNode( ) {
	    pidQueue = new Vector( );
	    pidQueue.clear( );
    }

    /**
     * Make our Process node to sleep.
     * @return process id
     */
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

    /**
     * The process ID, we are waking up.
     * @param pid process ID
     */
    public synchronized void wakeup( int pid ) {
        pidQueue.add( new Integer( pid ) );
        notify( );
    }
}
