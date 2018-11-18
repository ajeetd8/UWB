// Copyright 2018 Haram Kwon

/**
 * This is part of course work to simulate the TCP by using udp protocol.
 * In this assignment, there are three different style.
 * Native UDP (unreliable)
 * stop and wait (reliable)
 * commulative (fast and reliable)
 */

#define TIME_OUT 100

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

        // Waiting ACK
        timer.start();
        while (sock.pollRecvFrom() <= 0) {
            if (timer.lap() >= TIME_OUT) {
                ++retransmits;  // Time to retransmit
                break;
            }
        }

        // if there is a message to get (ACK).
        while (sock.pollRecvFrom() > 0) {
            // Getting the message from the server.
            sock.recvFrom(reinterpret_cast<char*>(&ack), sizeof(ack));
            if (i <= ack) {
                i = (++ack);
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

    int lastAcknowledged = 0;
    int lastReceived = 0;

    do {
        // If there is message to read
        if (sock.pollRecvFrom() > 0) {
            sock.recvFrom(reinterpret_cast<char*>(message), MSGSIZE);
            lastReceived = message[0];

           if (lastReceived > lastAcknowledged) {
            ack = lastReceived;
            lastAcknowledged = lastReceived;
            // ack to the client.
            cerr << "Message #" << message[0] << " received." << endl;
        }
        sock.ackTo(reinterpret_cast<char *>(&ack),
                       sizeof(ack));
        }
    } while ((lastAcknowledged+1) < max);
}

// the client reliable with commulative approach.
//
// @param sock  : udp sock
// @param max   : the total number of sending
// @message[]   : the message to send message[0] would be empty for sequence #
// @windowSize  : the window size for the commulative message.
int clientSlidingWindow(UdpSocket &sock,
                        const int max, int message[], int windowSize) {
    Timer timer;
    int retransmits = 0;
    int sequence = 0;
    int ackSequence = 0;
    int ack = -1;

    cerr << "server window test:" << endl;

    // Loop until all frames are sent and acknowledged.
    while ( (ack+1) < max) {
        if ( ((ackSequence + windowSize) > sequence) && (sequence < max) ) {
            message[0] = sequence;
            sock.sendTo(reinterpret_cast<char*>(message), MSGSIZE);
            ++sequence;
            cerr << "Message #" << message[0] << " sent." << endl;
        }

        if (sock.pollRecvFrom() > 0) {
            // If there is data to read

            sock.recvFrom(reinterpret_cast<char*>(&ack), sizeof(ack));

            if (ack == ackSequence) {
                ++ackSequence;
            }
        } else {
            // If there is no data to read

            // Start the timer
            timer.start();

            while (sock.pollRecvFrom() < 1) {
                if (timer.lap() > TIME_OUT) {
                    // Calculating retransmit number.
                    retransmits = retransmits + (sequence - ack);

                    if (ack >= ackSequence && ack <= sequence) {
                        ackSequence = ack+1;
                    } else {
                        sequence = ackSequence;
                    }
                    break;
                }
            }
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
                // case client send more than windows size.
                continue;   // drop frame
            } else if (lastFrameReceived > lastAcknowledgedFrame) {
                // case where we need to update received
                array[lastFrameReceived] = true;

                while (array[lastAcknowledgedFrame]) {
                    ack = lastAcknowledgedFrame;
                    ++lastAcknowledgedFrame;
                    cerr << "received: " << ack << endl;
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
