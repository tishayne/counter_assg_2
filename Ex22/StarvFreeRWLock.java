package counters.Ex22;

public class StarvFreeRWLock {
    private int nbOfActiveReaders = 0;
    private int nbOfActiveWriters = 0;
    private int nbOfWaitingWriters = 0;

    //acwuire lock for reading
    public synchronized void lockRead() throws InterruptedException{
        // give writers priority when waiting
        // to avoid starvation of writers,
        // check if there are waiting writers before allowing new readers to acquire the lock
        while (nbOfActiveWriters > 0 || nbOfWaitingWriters > 0){
            wait();
        }
        nbOfActiveReaders++;
    }

    //Release the read lock
    public synchronized void unlockRead(){
        nbOfActiveReaders--;
        if (nbOfActiveReaders == 0){
            notifyAll();
        }
    }

    public synchronized void lockWrite() throws InterruptedException{
        nbOfWaitingWriters++;
        try {
            while(nbOfActiveWriters > 0 || nbOfActiveReaders > 0) {
                wait();
            }
        } finally {
            // Decrement the count of waiting writers in the finally block to ensure readers are not blocked even if an exception occurs.
            nbOfWaitingWriters--;
        }
        nbOfActiveWriters++;
    }

    public synchronized void unlockWrite(){
        nbOfActiveWriters--;
        notifyAll();
    }
}
