/**
 * This java implement the Sync and Queue. In order to implement it, we've invoked QueueNode
 * class and we've limited the number of maximum queue as 10, and when there is no Process id
 * then -1 as NO_PID.
 * 
 * @author Haram_Kwon
 *
 */
public class SyncQueue {
    private QueueNode[] queue = null;
    private int COND_MAX = 10;
    private int NO_PID = -1;

    /**
     * Initialized the SyncQueue with condMax number
     * @param condMax The size of Queue to initialize.
     */
    private void initQueue(int condMax) {
        this.queue = new QueueNode[condMax];

        for(int i = 0; i < condMax; ++i) {
            this.queue[i] = new QueueNode();
        }

    }

    /**
     * Default constructor of SyncQueue. The queue size will be maxed.
     */
    public SyncQueue() {
        this.initQueue(this.COND_MAX);
    }

    /**
     * Initialize the Queue with the max size.
     * 
     * @param condMax The max size of the queue passed as a paramter.
     */
    public SyncQueue(int condMax) {
        this.initQueue(condMax);
    }

    /**
     * Enqueue the process, and make it sleep.
     * 
     * @param condition condition which make it to sleep.
     * @return
     */
    int enqueueAndSleep(int condition) {
        if ( condition >= 0 && condition < queue.length )
	        return queue[ condition ].sleep( );
	    else
	        return NO_PID;
    }

    /**
     * Dequeue the process, and wake up with thread.
     * 
     * @param condition condition where dequeue.
     * @param tid thread ID
     */
    void dequeueAndWakeup(int condition, int tid) {
        if (condition >= 0 && condition < this.queue.length) {
            this.queue[condition].wakeup(tid);
        }

    }

    /**
     * Dequeue the process, and wake up
     * 
     * @param condition process where dequeue.
     */
    void dequeueAndWakeup(int condition) {
        this.dequeueAndWakeup(condition, 0);
    }
}