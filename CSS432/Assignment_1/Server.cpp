// Copyright 2018 Haram Kwon

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <pthread.h>
#include <iostream>
#include <string>

#define BUFSIZE 1500

void * handler(void *sock);

// Locking global variable
pthread_mutex_t mutex;

// Global variable to share
int repetition;

int main(int argc, char *argv[]) {
    // Checking the number of argument
    if (argc != 3) {
        printf("Usage : %s <port> <repetition>\n", argv[0]);
        return -1;
    }

    int serv_sock, clnt_sock;
    struct sockaddr_in serv_adr, clnt_adr;
    socklen_t clnt_adr_sz = sizeof(clnt_adr);
    pthread_t t_id;
    ::repetition = atoi(argv[2]);

    serv_sock = socket(PF_INET, SOCK_STREAM, 0);
    if (serv_sock == -1) {
        std::cerr<<"socket() error"<<std::endl;
        return -1;
    }
    bzero((char*)&serv_adr, sizeof(serv_adr));
    serv_adr.sin_family = AF_INET;
    serv_adr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_adr.sin_port = htons(atoi(argv[1]));

    // Set the port reusable
    const int on = 1;
    setsockopt(serv_sock, SOL_SOCKET, SO_REUSEADDR, (char *)&on, sizeof(int));

    if (bind(serv_sock, (struct sockaddr *)&serv_adr, sizeof(serv_adr)) == -1) {
        std::cerr<<"bind() error"<<std::endl;
        return -1;
    }
    if (listen(serv_sock, 5) == -1) {
        std::cerr<<"listen() error"<<std::endl;
    }

    // Server never turned off
    while (true) {
        clnt_sock = accept(serv_sock,
        (struct sockaddr *)&clnt_adr, &clnt_adr_sz);

        // Check for the accept error
        if (clnt_sock == -1)
            continue;
        else  // no accept error, make new thread
            pthread_create(&t_id, NULL, handler,
            reinterpret_cast<void *>(&clnt_sock));
            pthread_detach(t_id);
    }

    close(serv_sock);
    return 0;
}

void * handler(void *sock) {
    // Begin to measur the time
    timeval startTime, endTime;
    gettimeofday(&startTime, NULL);
    
    // Allocate databuffer
    char buf[BUFSIZ];

    int count = 0;
    int sd = *((int *)sock);
    __suseconds_t duration;

    for(int i=0; i<(::repetition); i++) {
        // Read everything.
        for (int nRead = 0;
            ((nRead += read(sd, buf, BUFSIZE - nRead))) < BUFSIZE;
            ++count) {}
    }

    // Stop measuring time
    gettimeofday(&endTime, NULL);
    duration = (endTime.tv_sec-startTime.tv_sec)*1000000
        +(endTime.tv_usec-startTime.tv_usec);
    
    std::cout << "data-receiving time = " << duration << " usec" << std::endl;

    // Convert the number to Big-Endian
    int convertedNumber = htonl(count);
    write(sd, &count, count);

    close(sd);
}
