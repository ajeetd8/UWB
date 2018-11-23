#include "TcpServerSocket.h"
#include <iostream>
using namespace std;

int main() {
    TcpServerSocket server(5000);
    while (true) {
        char message[10];
        int newSd = server.acceptFrom();
        cout << "recevied connection" << endl;
        while (server.recvFrom(newSd, message, 10) < 0);
        string answer(message);
        cout << answer << endl;
        server.sendTo(newSd, message, 10);
    }

    return 0;
}