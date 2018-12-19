/**
 *
 */
public class Directory {
    private static int maxChars = 30; // the max characters of each file name

    private int fsizes[]; // the actual size of each file name
    private char fnames[][]; // file names in characters

    /**
     *
     * @param maxInumber The maximum number of files this system can have.
     */
    public Directory(int maxInumber) {
        fsizes = new int[maxInumber]; // maxInumber = max files
        for (int i = 0; i < maxInumber; i++) // all file sizes set to 0
            fsizes[i] = 0;
        fnames = new char[maxInumber][maxChars];

        String root = "/"; // entry(inode) 0 is "/"
        fsizes[0] = root.length();
        root.getChars(0, fsizes[0], fnames[0], 0);
    }

    /**
     * Turns byte data into a directory object
     * @param data The byte data
     */
    public void bytes2directory(byte data[]) {
        // assumes data[] contains directory information retrieved from disk
        // initialize the directory fsizes[] and fnames[] with this data[]
        int offset = 0;
        for (int i = 0; i < fsizes.length; i++, offset += 4)
            fsizes[i] = SysLib.bytes2int(data, offset);

        for (int i = 0; i < fnames.length; i++, offset += maxChars * 2) {
            String fname = new String(data, offset, maxChars * 2);
            fname.getChars(0, fsizes[i], fnames[i], 0);
        }
    }

    /**
     * Turns the directory data in to byte data
     * @return The directory data as a narray of bytes
     */
    public byte[] directory2bytes() {
        // converts and return directory information into a plain byte array
        // this byte array will be written back to disk
        byte[] data = new byte[fsizes.length * 4 + fnames.length * maxChars * 2];
        int offset = 0;
        for (int i = 0; i < fsizes.length; i++, offset += 4)
            SysLib.int2bytes(fsizes[i], data, offset);

        for (int i = 0; i < fnames.length; i++, offset += maxChars * 2) {
            String tableEntry = new String(fnames[i], 0, fsizes[i]);
            byte[] bytes = tableEntry.getBytes();
            System.arraycopy(bytes, 0, data, offset, bytes.length);
        }
        return data;
    }

    /**
     * Allocates an new inode for a file.
     * @param filename The name of th file
     * @return the inode number for the file, or -1 if unsucsesful
     */
    public short ialloc(String filename) {
        // filename is the name of a file to be created.
        // allocates a new inode number for this filename.
        short i;
        // i = 0 is already used for "/"
        for (i = 1; i < fsizes.length; i++) {
            if (fsizes[i] == 0) {
                fsizes[i] = Math.min(filename.length(), maxChars);
                filename.getChars(0, fsizes[i], fnames[i], 0);
                return i;
            }
        }
        return -1;
    }

    /**
     * Dellocated the inode associated with the given numver
     * @param iNumber The number of the inode
     * @return True if succsesful
     */
    public boolean ifree(short iNumber) {
        // deallocates this inumber (inode number).
        // the corresponding file will be deleted.
        if (fsizes[iNumber] > 0) {
            fsizes[iNumber] = 0;
            return true;
        } else {
            return false;
        }
    }

    /**
     *
     * @param filename Name of a file
     * @return The number of the inode that coresponds with the file name.
     */
    public short namei(String filename) {
        // returns the inumber corresponding to this filename
        short i;
        for (i = 0; i < fsizes.length; i++) {
            if (fsizes[i] == filename.length()) {
                String tableEntry = new String(fnames[i], 0, fsizes[i]);
                if (filename.compareTo(tableEntry) == 0)
                    return i;
            }
        }
        return -1;
    }
}
