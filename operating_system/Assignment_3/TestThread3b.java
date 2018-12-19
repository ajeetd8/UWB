import java.util.Date;

class TestThread3b extends Thread {

    public void run( ) {
	    byte[] buffer = new byte[512];
	    for ( int i = 0; i < 1000; i++ )
		SysLib.rawread( i, buffer );

        SysLib.cout( "disk finished...\n" );
        SysLib.exit( );
    }
}
