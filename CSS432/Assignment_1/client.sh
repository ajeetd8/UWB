#! /bin/bash
echo "Running the 9 different cases ..."

# Setting the port number my S_ID=1775511
PORT=5511
REPETITION=20000

echo "client output"
for NBUF in 15 30 60
do
    BUFSIZE=$((1500 / $NBUF))
    
    for TYPE in 1 2 3
    do
        echo "./Client.out" $PORT $REPETITION $NBUF $BUFSIZE "localhost" $TYPE
        ./Client.out $PORT $REPETITION $NBUF $BUFSIZE localhost $TYPE
    done
done
