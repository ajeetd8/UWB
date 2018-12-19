public class SuperBlock {
    private final int defaultInodeBlocks = 64;
    public int totalBlocks;
    public int inodeBlocks;
    public int freeList;

    /**
     *
     * @param diskSize The amount of inodes that can be stored on this disk.
     */
    public SuperBlock(int diskSize) {
        // read the superblock from disk
        byte[] superBlock = new byte[Disk.blockSize];
        SysLib.rawread(0, superBlock);
        totalBlocks = SysLib.bytes2int(superBlock, 0);
        inodeBlocks = SysLib.bytes2int(superBlock, 4);
        freeList = SysLib.bytes2int(superBlock, 8);

        // Test printout
        // Todo: Remove this when you are done.
//        System.out.println("total block: " + totalBlocks);
//        System.out.println("inodeblock: " + inodeBlocks);
//        System.out.println("free list: " + freeList);

        if (totalBlocks == diskSize && inodeBlocks > 0 && freeList >= 2) {
            // disk contents are valid
            System.out.println("The disk size is valid");
            return;
        } else {
            System.out.println("the file size is invalid or not intialized");
            totalBlocks = diskSize;
            SysLib.cerr("default format( " + defaultInodeBlocks + " )\n");
            format(defaultInodeBlocks);
        }
    }

    /**
     * Saves superblock to disk
     */
    void sync() {
        byte[] superBlock = new byte[Disk.blockSize];
        SysLib.int2bytes(totalBlocks, superBlock, 0);
        SysLib.int2bytes(inodeBlocks, superBlock, 4);
        SysLib.int2bytes(freeList, superBlock, 8);
        SysLib.rawwrite(0, superBlock);
        SysLib.cerr("Superblock synchronized\n");
    }

    /**
     * Formats disk
     * @param files Number of inode blocks the disk can support
     */
    void format(int files) {
        // initialize the superblock
        inodeBlocks = files;

        // initialize each inode and immediately write it back to disk
        for (short i = 0; i < inodeBlocks; i++) {
            Inode inode = new Inode();
            inode.flag = 0;
            inode.toDisk(i);
        }

        // superblock: starts from #0
        // inode: starts from #1
        // freelist: starts from at least #2
        freeList = 2 + (inodeBlocks * Inode.iNodeSize) / Disk.blockSize;

        // initialize each free block
        for (int i = freeList; i < totalBlocks; i++) {
            byte[] data = new byte[Disk.blockSize];
            for (int j = 0; j < Disk.blockSize; j++)
                data[j] = 0; // zero initialization
            SysLib.int2bytes(i + 1, data, 0); // let it point to the next blk
            SysLib.rawwrite(i, data); // write it back to disk
        }
        sync();
    }

    /**
     *
     * @return The value of the free block
     */
    public int getFreeBlock() {
        // get a new free block from the freelist
        int freeBlockNumber = freeList;

        // if it is not empty, freelist must point to the second free block
        if (freeBlockNumber != -1) {
            byte[] newBlock = new byte[Disk.blockSize];
            // System.out.println( "SuperBlock: getFreeBlcok=" + freeBlockNumber);
            SysLib.rawread(freeBlockNumber, newBlock);
            freeList = SysLib.bytes2int(newBlock, 0);
            // System.out.println( "SuperBlock: next freeList = " + freeList);
            SysLib.int2bytes(0, newBlock, 0);
            SysLib.rawwrite(freeBlockNumber, newBlock);
        }
        return freeBlockNumber;
    }

    /**
     * Deallocates a block
     * @param oldBlockNumber The block number to be deallocated
     * @return true if succsesful, false if not
     */
    public boolean returnBlock(int oldBlockNumber) {
        // return this old block
        if (oldBlockNumber >= 0) {
            byte[] oldBlock = new byte[Disk.blockSize];
            // zero initialization
            for (int j = 0; j < Disk.blockSize; j++)
                oldBlock[j] = 0;
            SysLib.int2bytes(freeList, oldBlock, 0); // point to the former top
            SysLib.rawwrite(oldBlockNumber, oldBlock); // write it back to disk
            freeList = oldBlockNumber; // it is now the top of the free list.
            return true;
        } else
            return false;
    }
}
