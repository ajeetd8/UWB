#removing unnecessary files
echo "Removing uncessary files"
rm -rf ./server
rm -rf ./client

# Making the directory for server, and client.
echo making 'server' and 'client' directory
mkdir client server

# Compile the code, and save them accordingly.
echo Compiling
g++ -std=c++17 -o ./client/client.out ./client.cpp -lpthread -D_REENTRANT 2> /dev/null

# Running client
echo "Running the client, it takes a while"
cd ./client/
./client.out daggerfs.com 1>client.log 2>/dev/null


echo please go to clinet/folder, there should be bnuch of script and image file downloaded.