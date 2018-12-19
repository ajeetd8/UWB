import java.util.Date;

class TestThread3a extends Thread {

    public void run( ) {
	    double ans = 0;
	    for ( int i = 0; i < Integer.MAX_VALUE / 10; i++ )
		ans = Math.pow( Math.sqrt( Math.sqrt( i ) * Math.sqrt( i ) ), 2.0 );


        SysLib.cout("comp finished...\n" );
        SysLib.exit( );
    }
}
