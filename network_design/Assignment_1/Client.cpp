// Copyright 2018 Haram Kwon

/**
 * This is clinet program designed to communicate with server. This program
 * invokes the socket programming and will try to sned different size of data
 * to the server multiple times.
 * 
 * how to run
 * Usage : ./Client.out <server_port> <repetition> <nbufs> <bufsize> <serverIp> <type>
 * 
 * The program will connect to the server, and will send <nbufs>*<bufsize> size
 * data to the server for <repetition> times. As a feedback, the server will
 * return the number of read call from the socket to the client. It will
 * measur ethe total microsecond takes for communicatoin between server and
 * client.
 */

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <netdb.h>
#include <netinet/tcp.h>
#include <sys/uio.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>

#define BUFFSIZE 1500

int main(int argc, char *argv[])
{
    // Checking the number of the argument
    if (argc != 7)
    {
        printf("Usage : %s <server_port> <repetition> <nbufs> ", argv[0]);
        printf("<bufsize> <serverIp> <type> \n");
        return -1;
    }

    // Checking valid ports
    if (atoi(argv[1]) < 1023 || atoi(argv[1]) > 65536)
    {
        std::cerr << "valid server_port range is 1024 to 65536." << std::endl;
        return -1;
    }

    // Checkig valid repetition(s)
    if (atoi(argv[2]) < 0)
    {
        std::cerr << "repetitions must be a positive integer." << std::endl;
        return -1;
    }

    // checking buf size
    if (atoi(argv[3]) * atoi(argv[4]) != BUFFSIZE)
    {
        std::cerr << "nbufs * bufsize must equal 1500." << std::endl;
        return -1;
    }

    // checking server_port number
    if (atoi(argv[6]) > 3 || atoi(argv[6]) < 1)
    {
        std::cerr << "valid types are 1, 2, or 3." << std::endl;
        return -1;
    }

    // Saving argument to variable
    const int server_port = atoi(argv[1]);
    const int repetition = atoi(argv[2]);
    const int nbufs = atoi(argv[3]);
    const int bufsize = atoi(argv[4]);
    char *server = argv[5];
    const int type = atoi(argv[6]);

    //Get Hostent structure to communicate to server.
    struct hostent *host = gethostbyname(server);
    if (host == NULL)
    {
        std::cerr << "Error:  Could not find hostname." << std::endl;
        return -1;
    }

    // Build the sending socket address of client
    // Setting the server setting
    sockaddr_in sendSocketAddress;
    bzero((char *)&sendSocketAddress, sizeof(sendSocketAddress));
    sendSocketAddress.sin_family = AF_INET; // Address Family:  Internet
    sendSocketAddress.sin_addr.s_addr = inet_addr(inet_ntoa(*(struct in_addr *)(*host->h_addr_list)));
    sendSocketAddress.sin_port = htons(server_port);

    // Setting the server decreptor from client
    int clientSD = socket(AF_INET, SOCK_STREAM, 0);
    if (clientSD < 0)
    {
        std::cerr << "socket() error" << std::endl;
        close(clientSD);
        return -1;
    }

    //Connect this TCP socket with the server
    int connetStat = connect(clientSD, (sockaddr *)&sendSocketAddress, sizeof(sendSocketAddress));
    if (connetStat < 0)
    {
        //negative connetStat indicates failure
        std::cerr << "connect() error!" << std::endl;
        close(clientSD);
        return -1;
    }

    if (connect(clientSD, (sockaddr *)&sendSocketAddress, sizeof(sendSocketAddress)) == -1)
    {
        // Error handling
    }

    //Allocate the databuffer.
    char databuf[nbufs][bufsize];

    //Use timeval structs for gettimeofday to track total usage time.
    struct timeval start, lap, stop;

    //Record start time.
    gettimeofday(&start, NULL);

    // With different case, send different form of data
    for (int i = 0; i < repetition; i++)
    {
        // Based on the type, do some task.
        if (type == 1)
        {
            for (int j = 0; j < nbufs; j++)
                write(clientSD, databuf[j], bufsize); // sd: socket descriptor
        }
        else if (type == 2)
        {
            struct iovec vector[nbufs];
            for (int j = 0; j < nbufs; j++)
            {
                vector[j].iov_base = databuf[j];
                vector[j].iov_len = bufsize;
            }
            writev(clientSD, vector, nbufs); // sd: socket descriptor
        }
        else
        {
            write(clientSD, databuf, nbufs * bufsize); // sd: socket descriptor
        }
    }

    //Record write end time.
    gettimeofday(&lap, NULL);

    //Receive from the server an integer acknowledgment that shows how many
    //times the server called read().
    int count; //read from the server.
    read(clientSD, &count, sizeof(count));

    //Record total round-trip end time.
    gettimeofday(&stop, NULL);

    // Commulating time
    long lapTime = (lap.tv_sec - start.tv_sec) * 1000000 + (lap.tv_usec - start.tv_usec);
    long endTime = (stop.tv_sec - start.tv_sec) * 1000000 + (stop.tv_usec - start.tv_usec);

    // Printing out statistics.
    std::cout << "Test 1"
              << ": data-sending time = "
              << lapTime << " usec, "
              << "round-trip time = " << endTime
              << " usec, #reads = " << count << std::endl;

    //End this session.
    close(clientSD);
    return 0;
}
