#include "TcpServerSocket.h"
#include "AdminManager.h"
#include "GameManager.h"
#include <iostream>
#include <string>
#include <vector>
using namespace std;

const int SERVER_PORT = 4798;
void interpretMessage(TcpServerSocket *server, AdminManager *admin,
                    GameManager *gameMan, int sd, string input);
void parseMessage(vector<string> &result, string input);
void sendRegisterACK(TcpServerSocket *server, int sd, string id);
void sendRegisterNAK(TcpServerSocket *server, int sd, string id);

int main() {
    // Load Server, Admin, and Game Manager
    TcpServerSocket *server = new TcpServerSocket(SERVER_PORT);
    AdminManager *admin = new AdminManager();

    while (true) {
        char message[10];
        int newSd = server->acceptFrom();
        cerr << "recevied connection" << endl;
        server->recvFrom(newSd, message, 10);
        string answer(message);
        cout << answer << endl;
        server->sendTo(newSd, message, 10);
        // close(newSd);
    }

    return 0;
}

void interpretMessage(TcpServerSocket *server, AdminManager *admin,
                    GameManager *gameMan, int sd, string input) {
    //parsing input message with ' '
    vector<string> message;
    parseMessage(message, input);
    if (message.size() == 0) {
        cerr << "Empty message" << endl;
        return;
    }

    string request = message[0];

    if (request == "REGISTER") {
        string id = message[1];
        if (admin->isRegistered(id)) {
            sendRegisterNAK(server, sd, id);
        } else {
            admin->registerUser(id);
            sendRegisterACK(server, sd, id);
        }
    } else if (request == "LIST") {
        
    } else if (request == "CREATE") {

    } else if (request == "JOIN") {

    } else if (request == "EXIT") {

    } else if (request == "DEREGISTER") {

    } else if (request == "RANKREQ") {

    }
}

void parseMessage(vector<string> &result, string input) {
    //parsing input message with ' '
    string temp = "";
    int size = input.size();
    for (int i = 0; i < size; i++) {
        char current = input[i];
        if (current != ' ') {
            temp += current;
        } else {
            result.push_back(temp);
            temp = "";
        }
    }
}

void sendRegisterACK(TcpServerSocket *server, int sd, string id) {
    // form ack message
    string ackForm = "REGISTER ACK " + id + " \r\n";

    // convert ack message into char[]
    int size = ackForm.size();
    char ackMessage[size + 1];
    strcpy(ackMessage, ackForm.c_str());
    server->sendTo(sd, ackMessage, size + 1);

    // close socket
    close(sd);
}

void sendRegisterNAK(TcpServerSocket *server, int sd, string id) {
    // form ack message
    string ackForm = "REGISTER NAK " + id + " \r\n";

    // convert ack message into char[]
    int size = ackForm.size();
    char ackMessage[size + 1];
    strcpy(ackMessage, ackForm.c_str());
    server->sendTo(sd, ackMessage, size + 1);

    // close socket
    close(sd);
}