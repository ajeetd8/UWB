// Copyright 2018 Haram Kwon

#include <cstdio>
#include <iostream>
#include <unistd.h>
#include <sys/wait.h>

// File decryptor for reading and writing
enum {FD_READ, FD_WRITE};

// Main function to handle
int main(int argc, char* argv[])
{
    // Error Check for more than 2 arguement passed
    if (argc >= 3) {
        std::cerr<<"more than 2 arguement is not allowed"<<std::endl;
        return -1;
    }
    
    // craete wc, grep, and ps pid.
    // create two pipes.
    // Make status variable to get return code from child process.
    pid_t wc_pid, grep_pid, ps_pid;
    int pipe1[2], pipe2[2];
    int status;

    // Requesting pipe to Operating System.
    pipe(pipe1), pipe(pipe2);

    // make child to handle 'wc -l' command.
    wc_pid = fork();
    if(wc_pid == 0) {
        // read from pipe2 as if stdin.
        close(pipe2[FD_WRITE]);
        close(pipe1[FD_WRITE]);
        close(pipe1[FD_READ]);
        dup2(pipe2[FD_READ], 0);
        execlp("/usr/bin/wc", "wc", "-l", NULL);
    }
    else {
        // make child to handle 'grep `argv[1]`' command.
        grep_pid = fork();
        if(grep_pid == 0) {
            // It's going to get string from pipe 1 as if stdin.
            // grep command with arguement.
            // write string to pipe 2 as if stdout.
            close(pipe1[FD_WRITE]);
            close(pipe2[FD_READ]);
            dup2(pipe1[FD_READ], 0);
            dup2(pipe2[FD_WRITE], 1);
            execlp("/bin/grep", "grep", argv[1], NULL);
        }
        else {
            // make child to handle 'ps -A' command.
            ps_pid = fork();
            if(ps_pid == 0) {
                // use pipe 1 as if stdin.
                close(pipe1[FD_READ]);
                close(pipe2[FD_READ]);
                close(pipe2[FD_WRITE]);
                dup2(pipe1[FD_WRITE], 1);     // stdout to pipe_read
                execlp("/bin/ps", "ps", "-A", NULL);
            }
            else {
                wait(&status);
            }
        }
        
    }

    return 0;
}