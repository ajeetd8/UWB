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
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <pthread.h>
#include <fstream>
#include <fcntl.h>
#include <unistd.h>

#define BUF_SIZE 1024
#define SMALL_BUF 300

void send_request(FILE* fp, const char * file_name, const char * server_name);
const char * get_File(const char * host_name, char * server_name, char * file_name, int * port);

void getImage(const char * server_name, const char * file_name, int port);
void getScript(const char * server_name, const char * file_name, int port);

int main(int argc, char * argv[]) {
    // Checking the number of the argument
    if (argc != 2) {
        std::cout<< "Usage : "<< argv[0] << " <host_name>";
        return -1;
    }

    char server_name[BUF_SIZE] = {0};
    char file_name[BUF_SIZE] = {0};
    int port;

    // Get file.
    if(!get_File(argv[1], server_name, file_name, &port)) {
        // Exit the program whern there is error
        return -1;
    }
    getImage(server_name, file_name, port);
    getScript(server_name, file_name, port);

    return 0;
}

// It will get the host_name as paramter in the format of
// (localhost:5511/index.html), and will donwload file for your
// param host_name: host name in the format of (localhost:5511/index.html)
const char * get_File(const char * host_name, char * server_name, char * file_name, int * port) {
    // Saving arguement to variable
    *port                        = 80; // default port for HTTP

    // Copying entire name
    strcpy(server_name, host_name);

    atoi(strtok(server_name, ":"));

    // If port number exist, update port number
    if(strchr(host_name, (int)':')) {
        *port        = atoi(strtok(nullptr, "/"));
        char * fName = strtok(nullptr, "\"");
        if(fName != nullptr)
            strcpy(file_name, fName);
    }

    strtok(server_name, "/");

    if(char * fName = strtok(nullptr, "")) {
        strcpy(file_name, fName);
    }

    //Get Hostent structure to communicate to server.
    struct hostent *host = gethostbyname(server_name);
    if (host == NULL) {
        std::cerr << "Error: Could not find hostname." << std::endl;
        return nullptr;
    }
    // Build the sending socket, address of client
    // with server setting
    sockaddr_in sendSocketAddr;
    bzero((char*)&sendSocketAddr, sizeof(sendSocketAddr));

    // Filling the struct.
    sendSocketAddr.sin_family = AF_INET;
    sendSocketAddr.sin_addr.s_addr 
        = inet_addr(inet_ntoa(*(struct in_addr*) (*host->h_addr_list)));
    sendSocketAddr.sin_port = htons(*port);

    // Setting the server decreptor from client
    int server_sock = socket(AF_INET, SOCK_STREAM, 0);
    if (server_sock < 0) {
        std::cerr << "socket() error" << std::endl;
        close(server_sock);
        return nullptr;
    }

    //Connect this TCP socket with the server
    int connetStat = connect(server_sock, (sockaddr *)&sendSocketAddr, sizeof(sendSocketAddr));
    if (connetStat < 0) {
        //negative connetStat indicates failure
        std::cerr << "connect() error!" << std::endl;
        close(server_sock);
        return nullptr;
    }

    // Now the connection has been established.
    // We are going to send request info.
    FILE * server_read  = fdopen(server_sock, "r");
    FILE * server_write = fdopen(dup(server_sock), "w");

    // Sending server a requesst.
    send_request(server_write, file_name, server_name);

    // Save it to the file
    if(!strcmp(file_name, "")) {
        strcpy(file_name, "index.html");
    }

    char new_fName[BUF_SIZE];
    strcpy(new_fName, file_name);

    if(strcmp(strtok(new_fName, "/"), file_name) != 0) {
        int i=1;    
        char * tempName = nullptr;

        do {
            if(tempName) {
                strcpy(new_fName, tempName);
            }
        } while (tempName = strtok(NULL, "/"));
    }
    
    char buf[BUF_SIZE];
    char * start;

        FILE * outFile = fopen(new_fName, "wb");
        
        bool contentMet = false;
        size_t n, m;
        do {
            if(n = fread(buf, 1, sizeof(buf)-1, server_read)) { 

                if(contentMet) {
                    m = fwrite(buf, 1, n, outFile);
                    fflush(outFile);
                }
                else if(start = strstr(buf, "\r\n\r\n")) {

                    char * temp = (start+4);
                    fwrite(temp, 1, n-(temp-buf), outFile);
                    m=n;
                    contentMet = true;
                }
            }
            else
                m = 0;

        } while ( (n > 0) && (n = m) );

        // Flushing in case buffer remains
        fflush(outFile);
        fclose(outFile); 

    close(server_sock);
    return file_name;
}

// Client request data from server.
void send_request(FILE* fp, const char * file_name, const char * server_name) {
    // Buffer space for request line and Header line
    char request[SMALL_BUF];
    char header[SMALL_BUF];

    // Setting the request line, and header line.
    sprintf(request, "GET /%s HTTP/1.1\r\n", file_name);
    sprintf(header, "Host: %s\r\n\r\n", server_name);

    // Sending header info
    fputs(request, fp);
    fputs(header, fp);

    // Flushing the buffer, and close.
	fflush(fp);
	fclose(fp);
}

// This is where I handle the file to get image tag
void getImage(const char * server_name, const char * file_name, int port) {
    // Token to
    const char * srcToken   = "src=";
    const char * imgToken   = "<img";
    
    char imgFile[BUF_SIZE] = {0};
    char imageName[BUF_SIZE];
    char imgServer[BUF_SIZE];

    char buf[SMALL_BUF];

    FILE * fp = fopen(file_name, "r");

    char * src = 0;
    while(fgets(buf, sizeof(buf), fp)) {
        if(src = strstr(buf, "<img")) {
            src=strstr(src, "src");
            src=strchr(src, '=');
            src=strchr(src, '\"');
            src=strtok(src, "\"");

            sprintf(imgFile, "%s%c%d%c%s", server_name, ':', port, '/', src);

            get_File(imgFile, imageName, imgServer, &port);
        }
    }

    fclose(fp);
}

void getScript(const char * server_name, const char * file_name, int port) {
    const char * srcToken = "src=";
    const char * jsToken  = "<script";

    char imgFile[BUF_SIZE] = {0};
    char imageName[BUF_SIZE];
    char imgServer[BUF_SIZE];

    char buf[SMALL_BUF];

    FILE * fp = fopen(file_name, "r");

    char * src = 0;
    while(fgets(buf, sizeof(buf), fp)) {
        if(src = strstr(buf, "<script")) {
            src=strstr(src, "src");
            src=strchr(src, '=');
            src=strchr(src, '\"');
            src=strtok(src, "\"");

            sprintf(imgFile, "%s%c%d%c%s", server_name, ':', port, '/', src);

            get_File(imgFile, imageName, imgServer, &port);
        }
    }

    fclose(fp);
}