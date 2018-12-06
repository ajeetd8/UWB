/**
 *
 */
public class FileTableEntry {
    public final Inode inode; // a reference to an inode
    public final short iNumber;// this inode number
    public final String mode; // "r", "w", "w+", or "a"
    public int seekPtr; // a file seek pointer
    public int count; // a count to maintain #threads sharing this

    /**
     *
     * @param i
     * @param inumber
     * @param message
     */
    FileTableEntry(Inode i, short inumber, String message) {
        seekPtr = 0; // the seek pointer is set to the file top.
        inode = i;
        iNumber = inumber;
        count = 1; // at least one thread is using this entry.
        mode = message; // once file access mode is set, it never changes.

        if (mode.compareTo("a") == 0)
            seekPtr = inode.length;
    }
}
