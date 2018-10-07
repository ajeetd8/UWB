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

void *your_function(void *sock);
void error_handling(const std::string &message);

// Locking global variable
pthread_mutex_t mutex;

int main(int argc, char *argv[]) {
    // Checking the number of argument
    if (argc != 3) {
        printf("Usage : %s <port> <repetition>\n", argv[0]);
        exit(1);
    }

    int serv_sock, clnt_sock;
    struct sockaddr_in serv_adr, clnt_adr;
    socklen_t clnt_adr_sz;
    const int nThread = atoi(argv[2]);
    pthread_t t_id;

    serv_sock = socket(PF_INET, SOCK_STREAM, 0);
    if (serv_sock == -1)
        error_handling("socket() error");

    memset(&serv_adr, 0, sizeof(serv_adr));
    serv_adr.sin_family = AF_INET;
    serv_adr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_adr.sin_port = htons(atoi(argv[1]));

    // Set the port reusable
    const int on = 1;
    setsockopt(serv_sock, SOL_SOCKET, SO_REUSEADDR, (char *)&on, sizeof(int));

    if (bind(serv_sock, (struct sockaddr *)&serv_adr, sizeof(serv_adr)) == -1)
        error_handling("bind() error");
    if (listen(serv_sock, 5) == -1)
        error_handling("listen() error");
    
    clnt_adr_sz = sizeof(clnt_adr);

    // Server never turned off
    for (unsigned int i=0; true; i++ ) {
        clnt_sock = accept(serv_sock,
        (struct sockaddr *)&clnt_adr, &clnt_adr_sz);

        // Check for the accept error
        if (clnt_sock == -1)
            continue;
        else  // no accept error, make new thread
            pthread_create(&t_id, NULL, your_function,
            reinterpret_cast<void *>(&clnt_sock));
            pthread_detach(t_id);
    }

    close(serv_sock);
    return 0;
}

void *your_function(void *sock) {
    int count = 1;
    int sd = *((int *)sock);
    __suseconds_t duration;

    char buf[BUFSIZ];

    // Begin to measur the time
    timeval startTime, endTime;
    gettimeofday(&startTime, NULL);

    for(int i=0; i<20000; i++) {
        // Read everything.
        for (int nRead = 0;
            ((nRead += read(sd, buf, BUFSIZE - nRead))) < BUFSIZE;
            ++count) {}
    }

    // Stop measuring time
    gettimeofday(&endTime, NULL);
    duration = endTime.tv_usec - startTime.tv_usec;

    // Convert the number to Big-Endian
    int convertedNumber = htonl(count);
    write(sd, &convertedNumber, sizeof(convertedNumber));

    // Lock in order to printout completely
    pthread_mutex_lock(&mutex);
    std::cout << "data-receiving time = " << duration << " usec" << std::endl;
    pthread_mutex_unlock(&mutex);

    close(sd);
}

// Error Handling function.
void error_handling(const std::string &message) {
    std::cerr << message << std::endl;
    exit(1);
}
