set terminal postscript landscape
set nolabel
set xlabel "Error_Rate"
set xrange [0:10]
set ylabel "usec"
set yrange [0:10000000]
set output "udp.ps"
plot "1gbps_window=1.dat" title "1gbps slinding window=1" with linespoints, "1gbps_window=30.dat" title "1gbps slinding window=30" with linespoints,3229459 title "1gbps stopNwait" with line
