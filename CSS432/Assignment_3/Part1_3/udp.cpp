// Copyright 2018 Haram Kwon

/**
 * This is part of course work to simulate the TCP by using udp protocol.
 * In this assignment, there are three different style.
 * Native UDP (unreliable)
 * stop and wait (reliable)
 * commulative (fast and reliable)
 */

#include "UdpSocket.h"
#include "Timer.h"
#include <vector>

// client stop wait protocal.
//
// @param sock : udp sock
// @param max : the total number of sending
// @message[] : the message to send message[0] would be empty for sequence #
int clientStopWait(UdpSocket &sock, const int max, int message[]) {
    Timer timer;            // define a timer
    int retransmits = 0;    // # retransmissions
    int ack = -1;           // currentack

    cerr << "client: stop and wait test:" << endl;

    // transfer message[] max times
    for (int i = 0; i < max;) {
        // message[0] has a sequence #
        // udp message send
        message[0] = i;
        sock.sendTo(reinterpret_cast<char *>(message), MSGSIZE);

        // if there is a message to get (ACK).
        while (sock.pollRecvFrom() > 0) {
            // Getting the message from the server.
            sock.recvFrom(reinterpret_cast<char*>(&ack), sizeof(ack));
            if (i <= ack) {
                i = (++ack);
            }
        }

        // Waiting ACK
        timer.start();
        while (sock.pollRecvFrom() == 0) {
            if (timer.lap() >= 1500) {
                ++retransmits;  // Time to retransmit
                break;
            }
        }

        // if there is a message to get (ACK).
        while (sock.pollRecvFrom() > 0) {
            // Getting the message from the server.
            sock.recvFrom(reinterpret_cast<char*>(&ack), sizeof(ack));
            if (i <= ack) {
                ++i;
            }
        }

        cerr << "Message #" << message[0] << " sent." << endl;
    }

    // Return the number of retransmit.
    return retransmits;
}

// the server reliable for stop and wait
//
// @param sock : udp sock
// @param max : the total number of sending
// @message[] : the message to send message[0] would be empty for sequence #
void serverReliable(UdpSocket &sock, const int max, int message[]) {
    int ack;
    cerr << "server reliable test:" << endl;

    // receive message[] max times
    for ( int i=0; i< max; ) {
        while (sock.pollRecvFrom() > 0) {
            // udp message receive
            sock.recvFrom(reinterpret_cast<char *>(message), MSGSIZE);
            if (message[0] >= i) {
                ack = i++;
                sock.ackTo(reinterpret_cast<char*> (&ack), sizeof(ack));
            } else {
                sock.ackTo(reinterpret_cast<char*> (&ack), sizeof(ack));
                continue;
            }

            // Print out the message
            cerr << "Message #" << message[0] << " received." << endl;
        }
    }
}

// the client reliable with commulative approach.
//
// @param sock  : udp sock
// @param max   : the total number of sending
// @message[]   : the message to send message[0] would be empty for sequence #
// @windowSize  : the window size for the commulative message.
int clientSlidingWindow(UdpSocket &sock,
                        const int max, int message[], int windowSize) {
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

// the server reliable with commulative approach.
//
// @param sock  : udp sock
// @param max   : the total number of sending
// @message[]   : the message to send message[0] would be empty for sequence #
// @windowSize  : the window size for the commulative message.
void serverEarlyRetrans(UdpSocket &sock,
                        const int max, int message[], int windowSize) {
    vector<bool> array(max, false);
    int lastFrameReceived = 0;
    int lastAcknowledgedFrame = 0;
    int ack = -1;

    do {
        // Wait until the first data arrives (from client)
        if (sock.pollRecvFrom() > 0) {
            sock.recvFrom(reinterpret_cast<char*>(message), MSGSIZE);
            lastFrameReceived = message[0];

            if (lastFrameReceived - lastAcknowledgedFrame > windowSize) {
                continue;   // drop frame
            } else if (lastFrameReceived > lastAcknowledgedFrame) {
                // case where we need to update received
                array[lastFrameReceived] = true;

                while (array[lastAcknowledgedFrame]) {
                    ack = lastAcknowledgedFrame++;
                    cerr << "Message #" << ack << "received: " << endl;
                }
            } else {
                // Acknowledge the last frame received.
                array[lastFrameReceived] = true;
                ack = lastAcknowledgedFrame;
            }

            // ack to the client.
            sock.ackTo(reinterpret_cast<char *>(&ack),
                       sizeof(ack));
        }
    } while (lastAcknowledgedFrame < max);
}
