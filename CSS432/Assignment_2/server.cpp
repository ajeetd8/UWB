#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <unistd.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <pthread.h>

// Setting the bufsize.
#define BUF_SIZE 1024
#define SMALL_BUF 100

// Handling function to handle the file request.
void * request_handler(void * arg);

// Function to send file
void send_data(FILE * fp, char * ct, char * file_name);

// Sedning right content depending on the file.
char* content_type(char* file);

// Sending Error to file file decryptor.
void send_error(FILE* fp);

// Calculating file size.
long int fileSize(char * file_name);

int main(int argc, char * argv[]) {

    int serv_sock, clnt_sock;
    struct sockaddr_in serv_adr, clnt_adr;
    socklen_t clnt_adr_size;
    char buf[BUF_SIZE];
    pthread_t t_id;

    // Check the number of arguement.
    if(argc != 2) {
        std::cout<<"Usage : " << argv[0] << " <port>" << std::endl;
        return -1;
    }

    serv_sock = socket(PF_INET, SOCK_STREAM, 0);

    bzero((char*)&serv_adr, sizeof(serv_adr));
    serv_adr.sin_family = AF_INET;
    serv_adr.sin_addr.s_addr=htonl(INADDR_ANY);
    serv_adr.sin_port = htons(atoi(argv[1]));

	// make it so that we can keep reusing this socket without waiting for the OS to clean up
	const int on = 1;
	setsockopt(serv_sock, SOL_SOCKET, SO_REUSEADDR, (char *)&on, sizeof(int));

    if(bind(serv_sock, (struct sockaddr*)&serv_adr, sizeof(serv_adr)) == -1)
        std::cerr << "bind() error" << std::endl;
    if(listen(serv_sock, 20) == -1)
        std::cerr << "listen() error" << std::endl;

    // Now server is ready to run, and run    
    while(1) {
        clnt_adr_size = sizeof(clnt_adr);
        clnt_sock=accept(serv_sock, (struct sockaddr*)&clnt_adr, &clnt_adr_size);
        std::cout << "Connection Request : " << inet_ntoa(clnt_adr.sin_addr)
            << ntohs(clnt_adr.sin_port) << std::endl;

        pthread_create(&t_id, NULL, request_handler, &clnt_sock);
		pthread_detach(t_id);
    }
    close(serv_sock);
	close(clnt_sock);
    return 0;
}

void * request_handler(void * arg) {
    int clnt_sock=*((int*)arg);
	char req_line[SMALL_BUF];
	FILE * clnt_read;
	FILE * clnt_write;
	
	char method[10];
	char ct[15];
	char file_name[30];

    clnt_read=fdopen(clnt_sock, "rb");
	clnt_write=fdopen(dup(clnt_sock), "wb");
	fgets(req_line, SMALL_BUF, clnt_read);	
	if(strstr(req_line, "HTTP/")==NULL) {
		// Send Error
        send_error(clnt_write);
		fclose(clnt_read);
		fclose(clnt_write);
		return nullptr;
	}

    strcpy(method, strtok(req_line, " /")); // Getting the method
	strcpy(file_name, strtok(NULL, " /"));  // Getting filename

    if(strcmp(method, "GET")!=0) {
        // When method call is wrong.
		send_error(clnt_write);
		fclose(clnt_read);
		fclose(clnt_write);
		return nullptr;
	}
    if(!strcmp(file_name, "HTTP")) {
        // When the specific file is not requested.
        strcpy(file_name, "index.html");
    }
    
	strcpy(ct, content_type(file_name));

    fclose(clnt_read);

	send_data(clnt_write, ct, file_name); 
}

void send_data(FILE* fp, char* ct, char* file_name) {
	// Opening the file to send.
	FILE* send_file=fopen(file_name, "rb");

	// Cehck whether file exist or not.
	if(send_file==NULL) {
		// Return error, since file does not exist.
		send_error(fp);
		fflush(fp);
		fclose(fp);
		return;
	}

	// Basic Setting for header.
	char protocol[]="HTTP/1.1 200 OK\r\n";
	char server[]="Server:Linux Web Server \r\n";
	char cnt_len[BUF_SIZE];
	char cnt_type[SMALL_BUF];
	char buf[BUF_SIZE];

	// Fillout the information.
	sprintf(cnt_type, "Content-type:%s\r\n\r\n", ct);
	sprintf(cnt_len, "Content-length:%ld\r\n", fileSize(file_name));

    // Sending header info
    fputs(protocol, fp);
	fputs(server, fp);
	fputs(cnt_len, fp);
	fputs(cnt_type, fp);

	size_t n, m;
	do {
		if(n = fread(buf, 1, sizeof(buf), send_file)) {
			m = fwrite(buf, 1, n, fp);
			fflush(fp);
		}
		else
			m = 0;
	} while( (n > 0) && (n = m) );
	
	// // Sending requested data (Content)
    // while(fgets(buf, BUF_SIZE, send_file)!=NULL) 
	// {
	// 	fputs(buf, fp);
	// 	fflush(fp);
	// }

	fflush(fp);
	fclose(fp);
	fclose(send_file);
}

char* content_type(char* file)
{
	char extension[SMALL_BUF];
	char file_name[SMALL_BUF];
	strcpy(file_name, file);
	strtok(file_name, ".");

	// If the file has extension.
	if(strcmp(file, file_name))
		strcpy(extension, strtok(NULL, "."));
	
	if(!strcmp(extension, "html")||!strcmp(extension, "htm")) 
		return "text/html";
	else if (!strcmp(extension, "jpg"))
		return "imgage/jpeg";
	else
		return "text/plain";
}

void send_error(FILE* fp)
{	
	char protocol[]="HTTP/1.1 400 Bad Request\r\n";
	char server[]="Server:Linux Web Server \r\n";
	char cnt_len[]="Content-length:2048\r\n";
	char cnt_type[]="Content-type:text/html\r\n\r\n";
	char content[]="<html><head><title>NETWORK</title></head>"
	       "<body><font size=+5><br>Your request is bad"
		   "</font></body></html>";

    // Putting the information out.
	fputs(protocol, fp);
	fputs(server, fp);
	fputs(cnt_len, fp);
	fputs(cnt_type, fp);
    fputs(content, fp);
	fflush(fp);
}

// Calculating the file size.
long int fileSize(char * file_name) {
	
	FILE * fp = fopen(file_name, "r");
	
	fseek(fp, 0L, SEEK_END);
	long int size = ftell(fp);

	fflush(fp);
	fclose(fp);

	return size;
}

