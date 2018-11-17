#include "UdpSocket.h"
#include "Timer.h"
#include <vector>
#include <algorithm>

int clientStopWait(UdpSocket &sock, const int max, int message[])
{
    Timer timer;         // define a timer
    int retransmits = 0; // # retransmissions
    int ack;

    cerr << "client: stop and wait test:" << endl;

    // transfer message[] max times
    for (int i = 0; i < max;)
    {
        message[0] = i;                        // message[0] has a sequence #
        sock.sendTo((char *)message, MSGSIZE); // udp message send

        // Waiting ACK
        timer.start( );
        while(sock.pollRecvFrom() <= 0) {
            if(timer.lap() >= 1500) {
                // Time to retransmit
                ++retransmits;
                break;
            }
        }

        // If there is a message to get (ACK).
        if(sock.pollRecvFrom() > 0) {
            // Getting the message from the server.
            sock.recvFrom((char*)&ack, sizeof(ack));
            if(i == ack)
                ++i;
        }

        cerr << "message = " << message[0] << endl;
    }

    return retransmits;
}
void serverReliable(UdpSocket &sock, const int max, int message[])
{
    int ack;
    cerr << "server reliable test:" << endl;

    // receive message[] max times
    for ( int i=0; i< max; ) {
        sock.recvFrom((char *)message, MSGSIZE);    // udp message receive
        if(message[0] == i) {
            ack = i++;
            sock.ackTo((char*)&ack, sizeof(i));
        } else {
            sock.ackTo((char*)&ack, sizeof(i));
            continue;
        }

        cerr << message[0] << endl;                 // print out message
    }
}

int clientSlidingWindow(UdpSocket &sock, const int max, int message[], int windowSize)
{
    Timer timer;         // define a timer
    int retransmits = 0; // # retransmissions
    int ack;

    cerr << "client: sliding window:" << endl;

    int unacknowledged=0;

    // transfer message[] max times
    for ( int i = 0; i < max; ) {

        // Sending window chunk.
        for( ;unacknowledged<windowSize && i < max; ) {
            message[0] = i++;                           // message[0] has a sequence #
            sock.sendTo( ( char * )message, MSGSIZE );  // udp message send
            ++unacknowledged;
        }

        // If there is a message to get (ACK).
        if(sock.pollRecvFrom() > 0) {
            // exhaust them. (we are not interested value)
            sock.recvFrom((char*)&ack, sizeof(ack));
            --unacknowledged;
        } else {
            // windowSize is full witl unacknowledged.
            timer.start();          // Start the timer.
            while(sock.pollRecvFrom() <= 0) {
                if(timer.lap() >= 1500) {
                    // Time up without ack.
                    break;
                }
            }

            // No ack, so go minimum sequence number
            retransmits += (i-ack);
            i = ack;
        }
    }

    return retransmits;
}
void serverEarlyRetrans(UdpSocket &sock, const int max, int message[], int windowSize)
{
    int ack = -1;
    std:vector<bool> buffer();

    cerr << "server sliding window:" << endl;

    // receive message[] max times
    for ( int i=0; i< max; ) {
        sock.recvFrom((char *)message, MSGSIZE);    // udp message receive
        (ack+1) <= message ? 

        if(message[0] == i) {
            ack = i++;
            sock.ackTo((char*)&ack, sizeof(i));
        } else {
            sock.ackTo((char*)&ack, sizeof(i));
            continue;
        }

        // cerr << message[0] << endl;                 // print out message
        cerr << i << endl;
    }
}

