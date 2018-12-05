import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.nio.ByteBuffer;

public class FileSystem {
    
    private SuperBlock superblock;
    private Directory directory;
    private FileTable filetable;

    public FileSystem(int diskBlock ) {
        // create superblock, and format disk with 64 inodes in default
        superblock = new SuperBlock( diskBlock );

        // create directory, and register "/" in directory entry 0
        directory = new Directory( superblock.inodeBlocks );

        // file table is created, and store directory in the file table
        filetable = new FileTable( directory );

        byte[] buffer = new byte[512];
        SysLib.int2bytes(superblock.totalBlocks, buffer, 0);
        SysLib.int2bytes(superblock.inodeBlocks, buffer, 4);
        SysLib.int2bytes(superblock.freeList, buffer, 8);

        Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.RAWWRITE, 0, buffer);
    }

    public int format(int files) {
        if(files <= 0) {
            return -1;
        }
        superblock.format(files);
        directory = new Directory( superblock.inodeBlocks );
        filetable = new FileTable(directory);

        return 0;
    }

    public int open( String fileName, String mode ) {
        // Error detected
        return -1;
    }

    public int read( int fd, byte buffer[] ) {
        // Error detected
        return -1;
    }

    public int write( int fd, byte buffer[] ) {
        // Error detected
        return -1;
    }

    public int seek( int fd, int offset, int whence ) {
        // Error detected
        return -1;
    }

    public int close( int fd ) {
        // Error detected
        return -1;
    }

    public int delete( String fileName ) {
        // Error detected
        return -1;
    }

    public int fsize( int fd ) {
        // Error detected
        return -1;
    }
}