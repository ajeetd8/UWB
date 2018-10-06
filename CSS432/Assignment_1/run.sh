#!/bin/sh

echo "Compiling..."
g++ -o Server.out Server.cpp -lpthread -D_REENTRANT && g++ -o Client.out Client.cpp -lpthread -D_REENTRANT
