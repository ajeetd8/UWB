class Superblock {
	public int totalBlocks; // the number of disk blocks
	public int totalInodes; // the number of inodes
	public int freeList; // the block number of the free list's head

	private int defaultTotalInodes;
	private final int defaultINodeBlock = 64;


	public Superblock(int diskSize) {
		// this.totalInodes = diskSize;
		byte[] superBlock = new byte[Disk.blockSize];

		// Read from the disk file first.
		SysLib.rawread(0, superBlock);
		totalBlocks = SysLib.bytes2int(superBlock, 0);
		totalInodes = SysLib.bytes2int(superBlock, 4);
		freeList = SysLib.bytes2int(superBlock, 8);

		// Test printout
		// Todo: Remove this when you are done.
		System.out.println("total block: " + totalBlocks);
		System.out.println("inodeblock: " + totalInodes);
		System.out.println("free list: " + freeList);

		if (totalBlocks == diskSize && totalInodes > 0 && freeList >= 2)
			// disk contents are valid
			return;
		else {
			// disk contents are invalid
			totalBlocks = diskSize;
			SysLib.cerr("default format( " + defaultTotalInodes + " )\n");
			format(defaultINodeBlock);
		}
	}

	public void format(int file) {
		// initialize the superblock
		totalInodes = files;

		// initialize each inode and immediately write it back to disk
		for (short i = 0; i < totalBlocks; ++i) {
			Inode inode = new Inode();
			inode.flag = 0;
			inode.toDisk(i);
		}

		// superblock: starts from #0
		// inode: starts from #1
		// freelist: starts from at least #2
		freeList = 2 + (totalBlocks * Inode.iNodeSize) / Disk.blockSize;

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
}