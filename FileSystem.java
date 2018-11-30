public class FileSystem {
    private Superblock superblock = new Superblock(10);
    private List<Inode> inodes = new ArrayList<>();

    public FileSystem() {

    }

    public int format(int files) {
        if(files <= 0) {
            return -1;
        }
        superblock.totalInodes = files;
        return 0;
    }

}