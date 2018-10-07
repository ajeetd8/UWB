#! /bin/bash
echo "Running the 9 different cases ..."

PORT=9190
REPETITION=20000
SERVER=$1

for NBUF in 15 30 60
do
    BUFSIZE=$((1500 / $NBUF))
    
    for TYPE in 1 2 3
    do
        echo "./Client.out" $PORT $REPETITION $NBUF $BUFSIZE $SERVER $TYPE
        ./Client.out $PORT $REPETITION $NBUF $BUFSIZE $SERVER $TYPE
    done
done