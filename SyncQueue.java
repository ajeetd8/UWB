public class SyncQueue {
    private QueueNode queue[] = null;
    private final int COND_MAX = 10;
    private final int NO_PID = -1;
    
    private void initQueue( int condMax ) {
	queue = new QueueNode[ condMax ];
	for ( int i = 0; i < condMax; i++ )
	    queue[i] = new QueueNode( );
    }

    public SyncQueue( ) {
	initQueue( COND_MAX );
    }

    public SyncQueue( int condMax ) {
	initQueue( condMax );
    }

    int enqueueAndSleep( int condition ) {
	if ( condition >= 0 && condition < queue.length )
	    return queue[ condition ].sleep( );
	else
	    return NO_PID;
    }

    void dequeueAndWakeup( int condition, int pid ) {
	if ( condition >= 0 && condition < queue.length )
	    queue[ condition ].wakeup( pid );
    }

    void dequeueAndWakeup( int condition ) {
	dequeueAndWakeup( condition, 0 );
    }
}
