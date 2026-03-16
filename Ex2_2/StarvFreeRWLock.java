package counters.Ex2_2;

public class StarvFreeRWLock {
    private int nbOfActiveReaders = 0;
    private int nbOfActiveWriters = 0;
    private int nbOfWaitingWriters = 0;

    //acwuire lock for reading
    public synchronized void lockRead() throws InterruptedException{
        // give writers priority when waiting
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
            nbOfWaitingWriters--;
        }
        nbOfActiveWriters++;
    }

    public synchronized void unlockWrite(){
        nbOfActiveWriters--;
        notifyAll();
    }
}
