public class Inode {
    public final static int iNodeSize = 32;
    private final static int directSize = 11; // # direct pointers
    private static int numberOfINodePerBlock;

    public int length; // file size in bytes
    public short count; // # file-table entries pointing to this
    public short flag; // 0 = unused, 1 = used, ...
    public short direct[] = new short[directSize]; // direct pointers
    public short indirect; // a indirect pointer

    /**
     * The default constructor for INode.
     * Only one INode exist.
     */
    Inode() {
        length = 0;
        count = 0;
        flag = 1;
        for (int i = 0; i < directSize; i++)
            direct[i] = -1;     // Initialize direct.
        indirect = -1;          // Initialize indirect.
    }

    /**
     * 
     * @param iNumber
     */
    Inode(short iNumber) {
        // Setting number of Inode per block.
        numberOfINodePerBlock = Disk.blockSize/iNodeSize;

        // retrieving inode from disk (Inode always start from '1')
        int blockNumber = (iNumber/( numberOfINodePerBlock )) + 1;
        int offset = (iNumber%numberOfINodePerBlock) * iNodeSize;
        byte[] data = new byte[Disk.blockSize];

        length = SysLib.bytes2int(data, offset); // retrieve all data members
		offset += 4; // from data
		count = SysLib.bytes2short(data, offset);
		offset += 2;
		flag = SysLib.bytes2short(data, offset);
		offset += 2;
		for (int i = 0; i < directSize; i++) {
			direct[i] = SysLib.bytes2short(data, offset);
			offset += 2;
		}
		indirect = SysLib.bytes2short(data, offset);
		offset += 2;
    }


    // Todo: change it to int later.
    /**
     * 
     * @param iNumber
     * @return
     */
    void toDisk(short iNumber) {
        byte[] iData = new byte[iNodeSize];
		int offset = 0;

		SysLib.int2bytes(length, iData, offset); // save all data members in
		offset += 4; // iData
		SysLib.short2bytes(count, iData, offset);
		offset += 2;
		SysLib.short2bytes(flag, iData, offset);
		offset += 2;
		SysLib.short2bytes(indirect, iData, offset);
		offset += 2;

		int blkNumber = 1 + iNumber / 16; // inodes start from block#1
		byte[] blkData = new byte[Disk.blockSize];
		SysLib.rawread(blkNumber, blkData); // get the inode block
		offset = (iNumber % 16) * iNodeSize; // locate the inode top

		// reflect the inode data to the block, and then write back to the disk
		System.arraycopy(iData, 0, blkData, offset, iNodeSize);
		SysLib.rawwrite(blkNumber, blkData);

		// return 0;
    }
}