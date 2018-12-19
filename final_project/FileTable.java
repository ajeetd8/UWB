import java.util.Vector;

/**
 * A Table of Files and there Inodes
 */
public class FileTable {

    private Vector table; // the actual entity of this file table
    private Directory dir; // the root directory

    /**
     *
     * @param directory The directory object of this File System
     */
    public FileTable(Directory directory) {
        table = new Vector(); // instantiate a file (structure) table
        dir = directory; // receive a reference to the Director
    } // from the file system

    /**
     * Get a FileTableEntry
     * @param filename The filename to be opened
     * @param mode Read or write
     * @return The FileTableEntry for that file or null if file not able to be opened.
     */
    public synchronized FileTableEntry falloc(String filename, String mode) {
        // allocate a new file (structure) table entry for this file name
        // allocate/retrieve and register the corresponding inode using dir
        // increment this inode's count
        // immediately write back this inode to the disk
        // return a reference to this file (structure) table entry

        short iNumber;
        Inode inode = null;
        while (true) {
            if (filename.equals("/"))
                iNumber = 0; // the root directory's inode is 0
            else
                iNumber = dir.namei(filename);

            if (iNumber >= 0) { // file exists
                inode = new Inode(iNumber); // retrieve inode from disk
                if (mode.compareTo("r") == 0) {
                    if (inode.flag == 0 || inode.flag == 1) {
                        inode.flag = 1;
                        break;
                    }
                } else {
                    if (inode.flag == 0 || inode.flag == 3) {
                        inode.flag = 2;
                        break;
                    }
                    if (inode.flag == 1 || inode.flag == 2) {
                        inode.flag += 3;
                        inode.toDisk(iNumber);
                    }
                }
            } else {
                if (mode.compareTo("r") != 0) {
                    iNumber = dir.ialloc(filename); // a new file
                    inode = new Inode(); // create a new inode
                    inode.flag = 2;
                } else
                    return null;
                break;
            }
        }
        inode.count++; // a new FileTableEntry points to it
        inode.toDisk(iNumber); // reflect this inode to disk
        FileTableEntry e = new FileTableEntry(inode, iNumber, mode);
        table.addElement(e);
        return e; // return this new file table entry
    }

    /**
     * Frees a file
     * @param e The FileTableEntry refering to the file
     * @return True if file is found and freed
     */
    public synchronized boolean ffree(FileTableEntry e) {
        // receive a file table entry reference
        // save the corresponding inode to the disk
        // free this file table entry.
        // return true if this file table entry found in my table
        if (table.removeElement(e) == true) {
            // find this file table entry
            e.inode.count--; // this entry no longer points to this inode
            switch (e.inode.flag) {
            case 1:
                e.inode.flag = 0;
                break;
            case 2:
                e.inode.flag = 0;
                break;
            case 4:
                e.inode.flag = 3;
                break;
            case 5:
                e.inode.flag = 3;
                break;
            }
            e.inode.toDisk(e.iNumber); // reflect this inode to disk
            e = null; // this file table entry is erased.
            return true;
        } else
            return false;
    }
}