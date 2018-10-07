#! /bin/bash
echo "Running the 9 different cases ..."

echo "Compiling..."
g++ -o Server.out Server.cpp -lpthread -D_REENTRANT && g++ -o Client.out Client.cpp -lpthread -D_REENTRANT

# Setting the port number my S_ID=1775511
PORT=5511
REPETITION=20000

echo "Running the server"
./Server.out $PORT $REPETITION > serverout.txt 2>&1 &

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

echo "server output"
serverout.txt > 1

rm serverout.txt