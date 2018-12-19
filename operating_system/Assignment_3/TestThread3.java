import java.util.Date;

class TestThread3 extends Thread {
    private String name;

    public TestThread3 ( String args[] ) {
	name = args[0];
    }

    public void run( ) {
	if ( name.equals( "comp" ) ) {
	    double ans = 0;
	    for ( int i = 0; i < Integer.MAX_VALUE / 10; i++ )
		ans = Math.pow( Math.sqrt( Math.sqrt( i ) * Math.sqrt( i ) ), 2.0 );
	}
	else if ( name.equals( "disk" ) ) {
	    byte[] buffer = new byte[512];
	    for ( int i = 0; i < 1000; i++ )
		SysLib.rawread( i, buffer );
	}

	SysLib.cout( name + " finished...\n" );
	SysLib.exit( );
    }
}
