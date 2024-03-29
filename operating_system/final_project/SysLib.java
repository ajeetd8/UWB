import java.util.*;

public class SysLib {
    public static int exec(String args[]) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.EXEC, 0, args);
    }

    public static int join() {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.WAIT, 0, null);
    }

    public static int boot() {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.BOOT, 0, null);
    }

    public static int exit() {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.EXIT, 0, null);
    }

    public static int sleep(int milliseconds) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.SLEEP, milliseconds, null);
    }

    public static int disk() {
        return Kernel.interrupt(Kernel.INTERRUPT_DISK, 0, 0, null);
    }

    public static int cin(StringBuffer s) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.READ, 0, s);
    }

    public static int cout(String s) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.WRITE, 1, s);
    }

    public static int cerr(String s) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.WRITE, 2, s);
    }

    public static int rawread(int blkNumber, byte[] b) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.RAWREAD, blkNumber, b);
    }

    public static int rawwrite(int blkNumber, byte[] b) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.RAWWRITE, blkNumber, b);
    }

    public static int sync() {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.SYNC, 0, null);
    }

    public static int cread(int blkNumber, byte[] b) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.CREAD, blkNumber, b);
    }

    public static int cwrite(int blkNumber, byte[] b) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.CWRITE, blkNumber, b);
    }

    public static int flush() {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.CFLUSH, 0, null);
    }

    public static int csync() {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.CSYNC, 0, null);
    }

    /**
     * Formats the disk (Disk.java's data contents). The parameter files specifies
     * the maximum number of files to be created (the number of inodes to be
     * allocated) in your file system. The return value is 0 on success, otherwise
     * -1.
     *
     * @param files
     * @return
     */
    public static int format(int files) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.FORMAT, files, null);
    }

    /**
     * Opens the file specified by the fileName string in the given mode (where "r"
     * = ready only, "w" = write only, "w+" = read/write, "a" = append). The call
     * allocates a new file descriptor, fd to this file. The file is created if it
     * does not exist in the mode "w", "w+" or "a". SysLib.open must return a
     * negative number as an error value if the file does not exist in the mode "r".
     * Note that the file descriptors 0, 1, and 2 are reserved as the standard
     * input, output, and error, and therefore a newly opened file must receive a
     * new descriptor numbered in the range between 3 and 31. If the calling
     * thread's user file descriptor table is full, SysLib.open should return an
     * error value. The seek pointer is initialized to zero in the mode "r", "w",
     * and "w+", whereas initialized at the end of the file in the mode "a".
     *
     * @param fileName
     * @param mode
     * @return
     */
    public static int open(String fileName, String mode) {
        String[] args = new String[2];
        args[0] = fileName;
        args[1] = mode;
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.OPEN, 0, args);
    }

    /**
     * Writes the contents of buffer to the file indicated by fd, starting at the
     * position indicated by the seek pointer. The operation may overwrite existing
     * data in the file and/or append to the end of the file. SysLib.write
     * increments the seek pointer by the number of bytes to have been written. The
     * return value is the number of bytes that have been written, or a negative
     * value upon an error.
     *
     * @param fd
     * @param buffer
     * @return
     */
    public static int write(int fd, byte buffer[]) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.WRITE, fd, buffer);
    }

    /**
     * Updates the seek pointer corresponding to fd as follows: If whence is
     * SEEK_SET (= 0), the file's seek pointer is set to offset bytes from the
     * beginning of the file If whence is SEEK_CUR (= 1), the file's seek pointer is
     * set to its current value plus the offset. The offset can be positive or
     * negative. If whence is SEEK_END (= 2), the file's seek pointer is set to the
     * size of the file plus the offset. The offset can be positive or negative. If
     * the user attempts to set the seek pointer to a negative number you must clamp
     * it to zero. If the user attempts to set the pointer to beyond the file size,
     * you must set the seek pointer to the end of the file. The offset loction of
     * the seek pointer in the file is returned from the call to seek.
     * 
     * @param fd
     * @param offset
     * @param whence
     * @return
     */
    public static int seek(int fd, int offset, int whence) {
        int[] args = new int[2];
        args[0] = offset;
        args[1] = whence;
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.SEEK, fd, args);
    }

    /**
     * Closes the file corresponding to fd, commits all file transactions on this
     * file, and unregisters fd from the user file descriptor table of the calling
     * thread's TCB. The return value is 0 in success, otherwise -1.
     *
     * @param fd
     * @return
     */
    public static int close(int fd) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.CLOSE, fd, null);
    }

    /**
     * Deletes the file specified by fileName. All blocks used by file are freed. If
     * the file is currently open, it is not deleted and the operation returns a -1.
     * If successfully deleted a 0 is returned.
     *
     * @param fileName
     * @return
     */
    public static int delete(String fileName) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.DELETE, 0, fileName);
    }

    /**
     * Returns the size in bytes of the file indicated by fd.
     * 
     * @param fd
     * @return
     */
    public static int fsize(int fd) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.SIZE, fd, null);
    }

    public static String[] stringToArgs(String s) {
        StringTokenizer token = new StringTokenizer(s, " ");
        String[] progArgs = new String[token.countTokens()];
        for (int i = 0; token.hasMoreTokens(); i++) {
            progArgs[i] = token.nextToken();
        }
        return progArgs;
    }

    public static void short2bytes(short s, byte[] b, int offset) {
        b[offset] = (byte) (s >> 8);
        b[offset + 1] = (byte) s;
    }

    public static short bytes2short(byte[] b, int offset) {
        short s = 0;
        s += b[offset] & 0xff;
        s <<= 8;
        s += b[offset + 1] & 0xff;
        return s;
    }

    public static void int2bytes(int i, byte[] b, int offset) {
        b[offset] = (byte) (i >> 24);
        b[offset + 1] = (byte) (i >> 16);
        b[offset + 2] = (byte) (i >> 8);
        b[offset + 3] = (byte) i;
    }

    public static int bytes2int(byte[] b, int offset) {
        int n = ((b[offset] & 0xff) << 24) + ((b[offset + 1] & 0xff) << 16) + ((b[offset + 2] & 0xff) << 8)
                + (b[offset + 3] & 0xff);
        return n;
    }

    /**
     *
     * @param fd     file decryptor
     * @param buffer byte buffer
     * @return Error or OK of the read result.
     */
    public static int read(int fd, byte[] buffer) {
        return Kernel.interrupt(Kernel.INTERRUPT_SOFTWARE, Kernel.READ, fd, buffer);
    }

}
