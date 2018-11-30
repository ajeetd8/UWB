class Superblock {
    public int totalBlocks; // the number of disk blocks
    public int totalInodes; // the number of inodes
    public int freeList;    // the block number of the free list's head

    // Boo!
    public Superblock( int diskSize ) {
        this.totalInodes = diskSize;
    }


}