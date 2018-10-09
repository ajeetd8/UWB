// 
#include <cstdio>
#include <iostream>
#include <unistd.h>
#include <sys/wait.h>

enum {FD_READ, FD_WRITE};

int main(int argc, char* argv[])
{
    pid_t wc_pid, grep_pid, ps_pid;
    int fd_read[2], fd_write[2];
    int status;

    // Requesting pipe to Operating System.
    pipe(fd_read), pipe(fd_write);

    // make child to handle 'wc -l' command.
    wc_pid = fork();
    if(wc_pid == 0) {
        close(fd_write[FD_WRITE]);
        close(fd_read[FD_WRITE]);
        dup2(fd_write[FD_READ], 0);
        execlp("/usr/bin/wc", "wc", "-l", 0);
    }
    else {
        // make child to handle 'grep `argv[1]`' command.
        grep_pid = fork();
        if(grep_pid == 0) {
            // wait(&status);
            // dup2(fd_read[FD_READ], 0);
            // close(fd_read[FD_WRITE]);=
                close(fd_read[FD_WRITE]);
                dup2(fd_read[FD_READ], 0);
                dup2(fd_write[FD_WRITE], 1);
                execlp("/bin/grep", "grep", argv[1], 0);
        }
        else {
            // make child to handle 'ps -A' command.
            ps_pid = fork();
            if(ps_pid == 0) {
                // close(fd_read[FD_WRITE]);
                close(fd_read[FD_READ]);
                close(fd_write[FD_WRITE]);
                close(fd_read[FD_READ]);
                dup2(fd_read[FD_WRITE], 1);     // stdout to pipe_read
                execlp("/bin/ps", "ps", "-A", 0);
            }
            else {
                wait(&status);
                
            }
        }
        
    }

    return 0;
}