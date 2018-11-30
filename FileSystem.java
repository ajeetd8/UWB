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

}