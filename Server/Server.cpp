#include "TcpServerSocket.h"
#include <iostream>
#include <string>
#include <vector>
using namespace std;

const int SERVER_PORT = 4798;
void interpretMessage(string input);

int main() {
    TcpServerSocket server(SERVER_PORT);
    while (true) {
        char message[10];
        int newSd = server.acceptFrom();
        cout << "recevied connection" << endl;
        server.recvFrom(newSd, message, 10);
        string answer(message);
        cout << answer << endl;
        server.sendTo(newSd, message, 10);
        close(newSd);
    }

    return 0;
}

void interpretMessage(string input) {
    //parsing input message with ' '
    vector<string> message;
    string temp = "";
    int size = input.size();
    for (int i = 0; i < size; i++) {
        char current = input[i];
        if (current != ' ') {
            temp += current;
        } else {
            message.push_back(temp);
            temp = "";
        }
    }

    string request = message[0];

    if (request == "REGISTRATION") {

    } else if (request == "LIST") {

    } else if (request == "CREATE") {

    } else if (request == "JOIN") {

    } else if (request = "EXIT") {

    }
}