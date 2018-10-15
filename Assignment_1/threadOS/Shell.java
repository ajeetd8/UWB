
// Copyright 2018 Haram Kwon

/**
 * The is the Shell class for ThreadOS. This shell only hsa '&' operatoin and 
 * '|' operation.
 * With '&'' operation, the shell will make concurrent thread
 * to handle the program.
 * With '&' opeation, the shell will handle each process sequentially.
 * 
 * @author Haram_Kwon
 * @version 1.0
 */
public class Shell extends Thread {

    // Class static variable for states.
    static final int ok = 0;
    static final int ERROR = -1;
    
    /**
     * The default constructor for the application.
     */
    public Shell() {
    }

    /**
     * The constructor with some arguement.
     */
    public Shell(String args[]) {
    }

    public void run() {
        // Command line to get input from user.
        String cmdLine = "";

        // 
        for (int i = 1; true; i++) {
            // Print out intro. 'Shell[i]' and getting input
            do {
                StringBuffer inputBuf = new StringBuffer();
                SysLib.cerr("shell[" + i + "]%");
                SysLib.cin(inputBuf);
                cmdLine = inputBuf.toString();
            } while (cmdLine.length() == 0);

            // When exit called, break the loop
            if (cmdLine.equals("exit")) {
                break;
            }

            // Handling & (Amp) and ; (semi)
            int semi = 0, amp = 0;
            String[] a = cmdLine.split(";");
            for (semi = 0; semi < a.length; semi++) {
                String[] b = a[semi].split("&");
                for (amp = 0; amp < b.length; amp++) {
                    String[] c = SysLib.stringToArgs(b[amp]);
                    SysLib.cout(c[0] + '\n');
                    if ( SysLib.exec(c) == ERROR ) {
		                break;
                    }
                }
                
                // Joining the processes (Thread).
                for (int j = 0; j < amp; j++) {
                    SysLib.join();
                }
            }
        }

        // Exiting the thread.
        SysLib.exit();
    }
}
