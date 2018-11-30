import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.nio.ByteBuffer;

public class FileSystem {
    private Superblock superblock = new Superblock(10);


    public FileSystem() {

        byte[] buffer = new byte[512];
        SysLib.int2bytes(superblock.totalBlocks, buffer, 0);
        SysLib.int2bytes(superblock.totalInodes, buffer, 4);
        SysLib.int2bytes(superblock.freeList, buffer, 8);

        Kernel.interupt(Kernel.INTERUPT_SOFTWARE, Kernel.RAWWRITE, 0, buffer);
    }

    public int format(int files) {
        if(files <= 0) {
            return -1;
        }
        superblock.totalInodes = files;
        return 0;
    }

    public FileSystem ( ) {

    }
    
    public int format( int files );  {
    }

    public int open( String fileName, String mode ) {

    }

    public int read( int fd, byte buffer[] ) {

    }

    public int write( int fd, byte buffer[] ) {

    }

    public int seek( int fd, int offset, int whence ) {

    }

    public int close( int fd ) {

    }

    public int delete( String fileName ) {

    }

    public int fsize( int fd ) {

    }
}