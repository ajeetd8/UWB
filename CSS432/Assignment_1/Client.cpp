// Copyright 2018 Haram Kwon

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <strings.h>
#include <netinet/tcp.h>
#include <sys/uio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <cstdio>
#include <string>
#include <iostream>

// Error handling function.
void error_handling(const std::string &message);

// Setting the client and server variable.
int nbufs;
int bufsize;

int main(int argc, char *argv[]) {
    // Checking the number of argument
    if (argc != 7) {
        printf("Usage : %s <port> <repetition> <nbufs> ", argv[0]);
        printf("<bufsize> <serverIp> <type> \n");
        exit(1);
    }

    // Setting the client and server variable.
    const int server_port = atoi(argv[1]);
    const int repetition = atoi(argv[2]);
    int nbufs = atoi(argv[3]);
    int bufsize = atoi(argv[4]);
    char *server_name = argv[5];
    const int type = atoi(argv[6]);

    // Allocating databuf.
    char databuf[nbufs][bufsize];

    // Checking the precondition nbufs*bufsize <= 1500
    if (nbufs * bufsize > 1500)
        error_handling("nbufs*bufsize should be less than 1500");

    // Type restriction (type is 1, 2, or 3)
    if (1 > type || type > 3)
        error_handling("type should be 1, 2, or 3");

    int serverD;
    struct sockaddr_in sendSockAddr;
    struct hostent *host = gethostbyname(server_name);

    // Setting the server setting
    bzero(reinterpret_cast<char *>(&sendSockAddr), sizeof(sendSockAddr));
    sendSockAddr.sin_family = AF_INET;  // IPv4
    sendSockAddr.sin_addr.s_addr = inet_addr(server_name);
    sendSockAddr.sin_addr.s_addr =
        inet_addr(inet_ntoa(*(struct in_addr *)*host->h_addr_list));
    sendSockAddr.sin_port = htons(server_port);

    // Time variable for statistics
    timeval startTime, endTime, lapTime;

    for (int i = 0; i < repetition; i++) {
        // counting start.
        gettimeofday(&startTime, NULL);

        // Setting the server decreptor
        serverD = socket(PF_INET, SOCK_STREAM, 0);
        if (serverD == -1)
            error_handling("socket() error");

        // make it so that we can keep reusing this socket without waiting
        // for the OS to clean up
        const int on = 1;
        setsockopt(serverD, SOL_SOCKET, SO_REUSEADDR, (char *)&on, sizeof(int));

        // Connect to the server
        if (connect(serverD, (struct sockaddr *)&sendSockAddr,
        sizeof(sendSockAddr)) == -1)
            error_handling("connect() error!");

        // Based on the type, do some task.
        if (type == 1) {
            for (int j = 0; j < nbufs; j++)
                write(serverD, databuf[j], bufsize);  // sd: socket descriptor
        } else if (type == 2) {
            struct iovec vector[nbufs];
            for (int j = 0; j < nbufs; j++) {
                vector[j].iov_base = databuf[j];
                vector[j].iov_len = bufsize;
            }
            writev(serverD, vector, nbufs);  // sd: socket descriptor
        } else if (type == 3) {
            write(serverD, databuf, nbufs * bufsize);  // sd: socket descriptor
        } else {
            // Error handling for wrong type
            error_handling("Type Error");
        }

        gettimeofday(&lapTime, NULL);

        // Getting the read count from the server
        int receivedCount;
        int str_len = read(serverD, &receivedCount, sizeof(receivedCount));
        if (str_len == -1)
            error_handling("read() error!");

        // Getting the round-trip time
        gettimeofday(&endTime, NULL);

        // Converting Big-endian to little-endian
        receivedCount = ntohl(receivedCount);

        // Commulating time
        __suseconds_t dataSend = lapTime.tv_usec - startTime.tv_usec;
        __suseconds_t dataRound = endTime.tv_usec - startTime.tv_usec;

        // Printing out statistics.
        std::cout << "Test " << i + 1 << ": data-sending time = "
        << dataSend << " usec, " << "round-trip time = " << dataRound
        << " usec, #reads = " << receivedCount << std::endl;

        close(serverD);
    }

    close(serverD);
    return 0;
}

// Error handling function.
void error_handling(const std::string &message) {
    std::cerr << message << std::endl;
    exit(1);
}
