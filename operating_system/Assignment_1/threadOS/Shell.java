
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

            // Handling & (Amp) and ; (sequential)
            int sequential = 0, concurrent = 0;
            String[] semi = cmdLine.split(";");
            for (sequential = 0; sequential < semi.length; sequential++) {
                String[] amp = semi[sequential].split("&");
                for (concurrent = 0; concurrent < amp.length; concurrent++) {
                    String[] c = SysLib.stringToArgs(amp[concurrent]);
                    SysLib.cout(c[0] + '\n');
                    if ( SysLib.exec(c) == ERROR ) {
		                break;
                    }
                }
                
                // Joining the processes (Thread).
                for (int j = 0; j < concurrent; j++) {
                    SysLib.join();
                }
            }
        }

        // Exiting the thread.
        SysLib.exit();
    }
}
