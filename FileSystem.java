public class FileSystem {
    private final int SEEK_SET = 0;
    private final int SEEK_CUR = 1;
    private final int SEEK_END = 2;
    private SuperBlock superblock;
    private Directory directory;
    private FileTable filetable;

    public FileSystem(int diskBlocks) {
        // create superblock, and format disk with 64 inodes in default
        superblock = new SuperBlock(diskBlocks);

        // create directory, and register "/" in directory entry 0
        directory = new Directory(superblock.inodeBlocks);

        // file table is created, and store directory in the file table
        filetable = new FileTable(directory);

        // directory reconstruction
        FileTableEntry dirEnt = open("/", "r");
        int dirSize = fsize(dirEnt);
        if (dirSize > 0) {
            byte[] dirData = new byte[dirSize];
            read(dirEnt, dirData);
            directory.bytes2directory(dirData);
        }
        close(dirEnt);
    }

    int format(int files) {
        if (files <= 0) {
            return -1;
        }

        superblock.format(files);
        directory = new Directory(superblock.inodeBlocks);
        filetable = new FileTable(directory);

        return 0;
    }

    FileTableEntry open(String filename, String mode) {
        // filetable entry is allocated
        FileTableEntry ftEnt = filetable.falloc(filename, mode);
        if (mode == "w") // all blocks belonging to this file is
            if (deallocAllBlocks(ftEnt) == false) // released
                return null;
        return ftEnt;
    }

    boolean close(FileTableEntry ftEnt) {
        // filetable entry is freed
        synchronized (ftEnt) {
            // JFM added 2012-12-01
            // need to decrement count; also: changing > 1 to > 0 below
            ftEnt.count--;
            if (ftEnt.count > 0) // my children or parent are(is) using it
                return true;
        }
        return filetable.ffree(ftEnt);
    }

    int fsize(FileTableEntry ftEnt) {
        synchronized (ftEnt) {
            return ftEnt.inode.length;
        }
    }

    int read(FileTableEntry ftEnt, byte[] buffer) {
        if (ftEnt.mode == "w" || ftEnt.mode == "a")
            return -1;

        int offset = 0; // buffer offset
        int left = buffer.length; // the remaining data of this buffer

        synchronized (ftEnt) {
            while (left > 0 && ftEnt.seekPtr < fsize(ftEnt)) {
                // repeat reading until no more data or reaching EOF

                // get the block pointed to by the seekPtr
                int targetBlock = ftEnt.inode.findTargetBlock(ftEnt.seekPtr);
                if (targetBlock == -1)
                    break;
                // System.out.println( "read( ) targetBlock=" + targetBlock );
                byte[] data = new byte[Disk.blockSize];
                SysLib.rawread(targetBlock, data);

                // find the offset in the current block to read
                int offsetInBlock = ftEnt.seekPtr % Disk.blockSize;

                // compute the bytes to read
                int blkLeft = Disk.blockSize - offsetInBlock;
                int fileLeft = fsize(ftEnt) - ftEnt.seekPtr;
                int smallest = Math.min(Math.min(blkLeft, left), fileLeft);

                System.arraycopy(data, offsetInBlock, buffer, offset, smallest);

                // update the seek pointer, offset and left in buffer
                ftEnt.seekPtr += smallest;
                offset += smallest;
                left -= smallest;
            }
            return offset;
        }
    }

    int write(FileTableEntry ftEnt, byte[] buffer) {
        // at this point, ftEnt is only the one to modify the inode
        if (ftEnt.mode == "r")
            return -1;

        synchronized (ftEnt) {
            int offset = 0; // buffer offset
            int left = buffer.length; // the remaining data of this buffer

            while (left > 0) {
                // System.out.println( "write( ): left = " + left );
                int targetBlock = ftEnt.inode.findTargetBlock(ftEnt.seekPtr);
                if (targetBlock == -1) { // block not assigned
                    short newBlock = (short) superblock.getFreeBlock();
                    switch (ftEnt.inode.registerTargetBlock(ftEnt.seekPtr, newBlock)) {
                    case Inode.NoError:
                        break;
                    case Inode.ErrorBlockRegistered:
                    case Inode.ErrorPreBlockUnused:
                        SysLib.cerr("ThreadOS: filesystem panic on write\n");
                        return -1;
                    case Inode.ErrorIndirectNull:
                        short indirectBlock = (short) superblock.getFreeBlock();
                        if (ftEnt.inode.registerIndexBlock(indirectBlock) == false) {
                            SysLib.cerr("ThreadOS: panic on write\n");
                            return -1;
                        }
                        if (ftEnt.inode.registerTargetBlock(ftEnt.seekPtr, newBlock) != Inode.NoError) {
                            SysLib.cerr("ThreadOS: panic on write\n");
                            return -1;
                        }
                    }
                    targetBlock = newBlock;
                }

                byte[] data = new byte[Disk.blockSize];
                // System.out.println("write() read from targetBlock" +
                // targetBlock );
                if (SysLib.rawread(targetBlock, data) == -1)
                    System.exit(2);

                int offsetInBlock = ftEnt.seekPtr % Disk.blockSize;
                int blkLeft = Disk.blockSize - offsetInBlock;
                int smallest = Math.min(blkLeft, left);

                System.arraycopy(buffer, offset, data, offsetInBlock, smallest);
                // System.out.println( "write( ) write on targetBlock " +
                // targetBlock );
                SysLib.rawwrite(targetBlock, data);

                ftEnt.seekPtr += smallest;
                offset += smallest;
                left -= smallest;

                // outdate the file length
                if (ftEnt.seekPtr > ftEnt.inode.length)
                    ftEnt.inode.length = ftEnt.seekPtr;
            }
            ftEnt.inode.toDisk(ftEnt.iNumber); // write back the inode to disk
            return offset;
        }
    }

    private boolean deallocAllBlocks(FileTableEntry ftEnt) {
        // busy wait until there are no threads accessing this inode
        if (ftEnt.inode.count != 1) // there is only one writer
            return false;

        byte[] indexBlock = ftEnt.inode.unregisterIndexBlock();
        if (indexBlock != null) {
            int offset = 0;
            short blockNumber;
            while ((blockNumber = SysLib.bytes2short(indexBlock, offset)) != -1) {
                superblock.returnBlock((int) blockNumber);
            }
        }
        for (int i = 0; i < Inode.directSize; i++)
            if (ftEnt.inode.direct[i] != -1) {
                superblock.returnBlock(ftEnt.inode.direct[i]);
                ftEnt.inode.direct[i] = -1;
            }
        ftEnt.inode.toDisk(ftEnt.iNumber);
        return true;
    }

    boolean delete(String filename) {
        FileTableEntry ftEnt = open(filename, "w");
        short iNumber = ftEnt.iNumber;
        return close(ftEnt) && directory.ifree(iNumber);
    }

    int seek(FileTableEntry ftEnt, int offset, int whence) {
        synchronized (ftEnt) {
            switch (whence) {
            case SEEK_SET:
                if (offset >= 0 && offset <= fsize(ftEnt))
                    ftEnt.seekPtr = offset;
                else
                    return -1;
                break;
            case SEEK_CUR:
                if (ftEnt.seekPtr + offset >= 0 && ftEnt.seekPtr + offset <= fsize(ftEnt))
                    ftEnt.seekPtr += offset;
                else
                    return -1;
                break;
            case SEEK_END:
                if (fsize(ftEnt) + offset >= 0 && fsize(ftEnt) + offset <= fsize(ftEnt))
                    ftEnt.seekPtr = fsize(ftEnt) + offset;
                else
                    return -1;
                break;
            }
            return ftEnt.seekPtr;
        }
    }

    void sync() {
        // directory synchronizatioin
        FileTableEntry dirEntery = open("/", "w");
        byte[] dirData = directory.directory2bytes();
        write(dirEntery, dirData);
        close(dirEntery);

        // superblock synchronization
        superblock.sync();
    }
}
