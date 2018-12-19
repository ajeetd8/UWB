# Making the directory for server, and client.
echo making 'server' and 'client' directory
mkdir client server

# Compile the code, and save them accordingly.
echo Compiling
g++ -std=c++17 -o ./server/server.out ./server.cpp -lpthread -D_REENTRANT 2> /dev/null & g++ -std=c++17 -o ./client/client.out ./client.cpp -lpthread -D_REENTRANT 2> /dev/null

# Getting Example file
echo Getting example file
wget -q students.washington.edu/kharam/Desktop.tar.gz
mv ./Desktop.tar.gz ./server
tar xf ./server/Desktop.tar.gz

# Running Server
cd ./server/
./server.out 5512 1>server.log&
cd ..

cd ./client/
./client.out localhost:5512 1>client.log


echo please go to clinet/index.html whether retrieving is successful or not.