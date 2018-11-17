#include "UdpSocket.h"
#include "Timer.h"
#include <deque>
#include <algorithm>
#include <vector>

int clientStopWait(UdpSocket &sock, const int max, int message[])
{
    Timer timer;         // define a timer
    int retransmits = 0; // # retransmissions
    int ack = 0;

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
            if(i <= ack) {
                i=(++ack);
            }
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
            sock.ackTo((char*)&ack, sizeof(ack));
        } else {
            sock.ackTo((char*)&ack, sizeof(ack));
            continue;
        }

        // cerr << message[0] << endl;                 // print out message
        cerr << i << endl;
    }
}

int clientSlidingWindow(UdpSocket &sock, const int max, int message[], int windowSize) {
    Timer timer;
    int retransmits = 0;
    int sequence = 0;
    int ackSequence = 0;
    int ack = -1;

    cerr << "server window test:" << endl;

    // Loop until all frames are sent and acknowledged.
    while(sequence < max || ackSequence < max) {
        if( (ackSequence + windowSize) > sequence && sequence < max) {
            message[0] = sequence;
            sock.sendTo((char*)message, MSGSIZE);
            ++sequence;
            cout << "Message #" << message[0] << " sent." << endl;
        }
    }

    if(sock.pollRecvFrom() > 0) {
        // If there is data to read

        sock.recvFrom((char*)&ack, sizeof(ack));

        if(ack == ackSequence) {
            ++ackSequence;
        }
    } else {
        // If there is no data to read

        // Start the timer
        timer.start();

        while(sock.pollRecvFrom() < 1) {
            if(timer.lap() < 1500) {
                // Calculating retransmit number.
                retransmits = retransmits + (sequence - ackSequence);

                if(ack >= ackSequence && ack <= sequence) {
                    ackSequence = ack+1;
                } else {
                    sequence = ackSequence;
                }
                break;
            }
        }


    }

    return retransmits;
}
void serverEarlyRetrans(UdpSocket &sock, const int max, int message[], int windowSize)
{
    int lastFrameReceived = 0;
    int lastAcknowledgedFrame = 0;
    int lastSequence = -1;

    vector<bool> array(max, false);

    do {
        // Wait until the first data arrives (from client)
        if(sock.pollRecvFrom() > 0) {
            sock.recvFrom((char*)message, MSGSIZE);
            lastFrameReceived = message[0];

            if(lastFrameReceived - lastAcknowledgedFrame > windowSize) {
                continue;   // drop frame
            } else if (lastFrameReceived > lastAcknowledgedFrame) {
                // case where we need to update received
                array[lastFrameReceived] = true;

                while(array[lastAcknowledgedFrame]) {
                    lastSequence = lastAcknowledgedFrame;
                    lastAcknowledgedFrame++;
                }
            } else {
                // Acknowledge the last frame received.
                array[lastFrameReceived] = true;
                lastSequence = lastAcknowledgedFrame;
            }
            cout<<lastAcknowledgedFrame<<endl;
            sock.ackTo((char*)&lastSequence, sizeof(lastSequence));
        }
    } while (lastAcknowledgedFrame < max);
}


