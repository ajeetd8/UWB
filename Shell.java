import java.io.*;
import java.util.*;

class Shell extends Thread
{
    public Shell( ) {
    }

    public void run( ) {
        for ( int line = 1; ; line++ ) {
            String cmdLine = "";
            do {
                StringBuffer inputBuf = new StringBuffer( );
                SysLib.cerr( "shell[" + line + "]% " );
                SysLib.cin( inputBuf );
                cmdLine = inputBuf.toString( );
            } while ( cmdLine.length( ) == 0 );
            String[] args = SysLib.stringToArgs( cmdLine );
            int first = 0;
            for ( int i = 0; i < args.length; i++ ) {
                if ( args[i].equals( ";" ) || args[i].equals( "&" )
                     || i == args.length - 1 ) {
                    String[] command = generateCmd( args, first, 
                                                    ( i==args.length - 1 ) ? 
                                                    i+1 : i );
                    if ( command != null ) {
                        SysLib.cerr( command[0] + "\n" );
                        if ( command[0].equals( "exit" ) ) {
                            SysLib.exit( );
                            return;
                        }
                        int tid = SysLib.exec( command );
                        if ( tid != -1 ) {
                            if ( !args[i].equals( "&" ) ) {
                                while ( SysLib.join( ) != tid );
                            }
                        }
                    }
                    first = i + 1;
                }
            }
        }
    }

    private String[] generateCmd( String args[], int first, int last ) {
        if ( (args[last-1].equals(";")) || (args[last-1].equals("&")) )
            last = last -1;

        if ( last - first <= 0 )
            return null;
        String[] command = new String[ last - first ];
        for ( int i = first ; i < last; i++ ) 
              command[i - first] = args[i];
        return command;
    }
}
