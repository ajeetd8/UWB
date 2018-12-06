public class Inode {
    public final static int iNodeSize = 32;  // fixed to 32 bytes
    public final static int directSize = 11; // # direct pointers

    public final static int NoError = 0;
    public final static int ErrorBlockRegistered = -1;
    public final static int ErrorPreBlockUnused = -2;
    public final static int ErrorIndirectNull = -3;

    public int length;                 // file size in bytes
    public short count;                // # file-table entries pointing to this
    public short flag;       // 0 = unused, 1 = used(r), 2 = used(!r),
    // 3=unused(wreg), 4=used(r,wreq), 5= used(!r,wreg)
    public short direct[] = new short[directSize]; // directo pointers
    public short indirect;                         // an indirect pointer

    private static int numberOfINodePerBlock;

    /**
     * The default constructor for INode.
     * Only one INode exist.
     */
    Inode() {
        length = 0;
        count = 0;
        flag = 1;
        for (int i = 0; i < directSize; ++i)
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
        SysLib.rawread(blockNumber, data);

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
    }

    /**
     *
     * @param iNumber
     * @return
     */
    int toDisk(short iNumber) {                 // saving this inode to disk
        byte[] iData = new byte[iNodeSize];
        int offset = 0;

        SysLib.int2bytes(length, iData, offset); // save all data members in
        offset += 4;                               // iData
        SysLib.short2bytes(count, iData, offset);
        offset += 2;
        SysLib.short2bytes(flag, iData, offset);
        offset += 2;
        for (int i = 0; i < directSize; i++) {
            SysLib.short2bytes(direct[i], iData, offset);
            offset += 2;
        }
        SysLib.short2bytes(indirect, iData, offset);

        int blkNumber = 1 + iNumber / 16;          // inodes start from block#1
        byte[] blkData = new byte[Disk.blockSize];
        SysLib.rawread(blkNumber, blkData);      // get the inode block
        offset = (iNumber % 16) * iNodeSize;     // locate the inode top

        // reflect the inode data to the block, and then write back to the disk
        System.arraycopy(iData, 0, blkData, offset, iNodeSize);
        SysLib.rawwrite(blkNumber, blkData);

        return 0;
    }

    /**
     *
     * @param indexBlockNumber
     * @return
     */
    boolean registerIndexBlock(short indexBlockNumber) {
        for (int i = 0; i < directSize; i++)    // check if all direct ptrs
            if (direct[i] == -1)                // have a block number
                return false;
        if (indirect != -1)                     // check if the indirect has
            return false;                         // not yet had a block number
        indirect = indexBlockNumber;              // register it
        byte[] indexBlock = new byte[Disk.blockSize];
        for (int i = 0; i < Disk.blockSize / 2; i++)
            SysLib.short2bytes((short) -1, indexBlock, i * 2);
        SysLib.rawwrite(indexBlockNumber, indexBlock);

        return true;
    }

    /**
     *
     * @param offset
     * @return
     */
    int findTargetBlock(int offset) {     // find the block# including offset
        int directNumber = offset / Disk.blockSize;
        if (directNumber < directSize)    // target is in direct pointers
            return direct[directNumber];
        else {                              // target is in indiret pointer
            if (indirect < 0)             // indirect is null
                return -1;
            else {
                byte[] indexBlock = new byte[Disk.blockSize];
                SysLib.rawread(indirect, indexBlock); // read the index block
                int indirectNumber = directNumber - directSize;
                return SysLib.bytes2short(indexBlock, indirectNumber * 2);
            }
        }
    }

    /**
     *
     * @param offset
     * @param targetBlockNumber
     * @return
     */
    int registerTargetBlock(int offset, short targetBlockNumber) {
        int directNumber = offset / Disk.blockSize;
        if (directNumber < directSize) {      // target is in direct pointers
            if (direct[directNumber] >= 0)    // already registered!
                return ErrorBlockRegistered;
            if (directNumber > 0 && direct[directNumber - 1] == -1)
                return ErrorPreBlockUnused;         // preceding block unused!
            direct[directNumber] = targetBlockNumber; // register it in success
            return NoError;
        } else {                                  // target is in indiret pointer
            if (indirect < 0)                 // indirect is null
                return ErrorIndirectNull;
            else {
                byte[] indexBlock = new byte[Disk.blockSize];
                SysLib.rawread(indirect, indexBlock); // read the index block
                int indirectNumber = directNumber - directSize;
                if (SysLib.bytes2short(indexBlock, indirectNumber * 2) > 0) {
                    SysLib.cerr("indexBlock, indirectNumber = " +
                            indirectNumber + " contents = " +
                            SysLib.bytes2short(indexBlock,
                                    indirectNumber * 2) + "\n");
                    return ErrorBlockRegistered;
                }
                SysLib.short2bytes(targetBlockNumber,
                        indexBlock, indirectNumber * 2);
                SysLib.rawwrite(indirect, indexBlock); //write back the index
                return NoError;
            }
        }
    }

    /**
     * 
     * @return
     */
    byte[] unregisterIndexBlock() {
        if (indirect >= 0) {
            byte[] indexBlock = new byte[Disk.blockSize];
            SysLib.rawread(indirect, indexBlock);
            indirect = -1;
            return indexBlock;
        } else
            return null;
    }
}

