#include "TcpClientSocket.h"
using namespace std;

TcpClientSocket::TcpClientSocket(int port): destPort(port), sd(NULL_SD) {
    this->sd = socket(AF_INET, SOCK_STREAM, 0);
}

TcpClientSocket::~TcpClientSocket() {
    // close the socket being used
    if (this->sd != NULL_SD) {
        close(sd);
    }
}

int TcpClientSocket::recvFrom(char *message, int size) {
    return read(this->sd, message, size);
}


// for client socket
int TcpClientSocket::connectTo(char *ipName) {
    struct hostent *host = gethostbyname(ipName);
    if (host == nullptr) {
        cerr << "Cannot find host name" << endl;
        return false;
    }

    bzero((char *)& this->destAddr, sizeof(this->destAddr));
    this->destAddr.sin_family = AF_INET;
    this->destAddr.sin_addr.s_addr =
        inet_addr(inet_ntoa(*(struct in_addr*)*host->h_addr_list));
    this->destAddr.sin_port = htons(this->destPort);
    return connect(this->sd, (sockaddr *) &this->destAddr, sizeof(this->destAddr));
}

int TcpClientSocket::sendTo(char *message, int size) {
    return write(this->sd, message, size);
}
