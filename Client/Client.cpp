#include "TcpClientSocket.h"

using namespace std;

int main() {
    TcpClientSocket client(5000);
    char destAddr[] = "127.0.0.1";
    client.connectTo(destAddr);
    char message[] = "Hello";
    client.sendTo(message, 5);

    char answer[10];
    while (client.recvFrom(answer, 10) <= 0);
    printf("%s", answer);


    return 0;
}