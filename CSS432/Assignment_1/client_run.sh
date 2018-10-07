#!/bin/bash
echo "Running the 9 different cases ..."
"case 1: 20000 15*100 type:1" > result.txt
./Client.out 5511 20000 15 100 uw1-320-01.uwb.edu 1  > result.txt

"case 2 20000 15*100 type:2"
./Client.out 5511 20000 15 100 uw1-320-01.uwb.edu 1  >> result.txt

"case 3 20000 15*100 type:3"
./Client.out 5511 20000 15 100 uw1-320-01.uwb.edu 1  >> result.txt

"case 4 20000 30*50 type:1"
./Client.out 5511 20000 30 50 uw1-320-01.uwb.edu 1   >> result.txt

"case 5 20000 30*50 type 2"
./Client.out 5511 20000 30 50 uw1-320-01.uwb.edu 1   >> result.txt

"case 6 20000 30*50 type 3"
./Client.out 5511 20000 30 50 uw1-320-01.uwb.edu 1   >> result.txt

"case 7 20000 60*25 type 1"
./Client.out 5511 20000 60 25 uw1-320-01.uwb.edu 1   >> result.txt

"case 8 20000 60*25 type 2"
./Client.out 5511 20000 60 25 uw1-320-01.uwb.edu 1   >> result.txt

"case 9 20000 60*25 type 3"
./Client.out 5511 20000 60 25 uw1-320-01.uwb.edu 1   >> result.txt