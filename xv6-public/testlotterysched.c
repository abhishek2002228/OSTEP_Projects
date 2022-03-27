#include "types.h"
#include "stat.h"
#include "user.h"
#include "pstat.h"
#include "fcntl.h"

void spin() {
    unsigned x = 0;
    unsigned y = 0;

    while (x < 100000) {
        y = 0;
        while (y < (10000)) {
            y++;
        }
        x++;
    }
}

void printpinfo(int pid, int fd)
{
	struct pstat pi = {0};
	getpinfo(&pi);
	int i;
    for (i = 0; i < NPROC; i++) {
        if(pi.pid[i] == pid) {
		printf(fd, "Number of tickets that PID %d has: %d\n", pid, pi.tickets[i]);
	        printf(fd, "Number of ticks that PID %d has: %d\n", pid, pi.ticks[i]);
	        printf(fd, "Is the process with PID %d in use? (0 or 1): %d\n", pid, pi.inuse[i]);
        }
    }
}

int
main(int argc, char *argv[])
{
    int pid1, pid2, pid3;
    int fd1 = open("f1", O_CREATE|O_RDWR);
    int fd2 = open("f2", O_CREATE|O_RDWR);
    int fd3 = open("f3", O_CREATE|O_RDWR);
      
    if ((pid1 = fork()) == 0) {
        int pp1 = getpid();
        settickets(10);
        spin();
	printpinfo(pp1, fd1);
        exit(); 
    }
    else if ((pid2 = fork()) == 0) {
        int pp2 = getpid();
        settickets(20);
        spin();
	printpinfo(pp2, fd2);
        exit();
    }
    else if ((pid3 = fork()) == 0) {
        int pp3 = getpid();
        settickets(100);
        spin();
	printpinfo(pp3, fd3);
        exit();
    }
    wait();
    wait();
    wait();
    close(fd1);
    close(fd2);
    close(fd3);
    exit();
}
