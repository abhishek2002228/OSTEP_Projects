
//This is user cat command which prints the number of reads and writes at the start and the end of the execution. This is to test the getreadcount syscall.
#include "types.h"
#include "stat.h"
#include "user.h"

char buf[512];

void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
    printf(1, "cat: read error\n");
    exit();
  }
}

int
main(int argc, char *argv[])
{
  int fd, i;
  int readcount_start_proc = getreadcount(0);
  int readcount_start_global = getreadcount(1);
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
    close(fd);
  }

  int readcount_end_proc = getreadcount(0);
  int readcount_end_global = getreadcount(1);

  printf(1, "proc:\n");
  printf(1, "Number of reads at the start: %d\n", readcount_start_proc);
  printf(1, "Number of reads at the end: %d\n", readcount_end_proc);

  printf(1, "global:\n");
  printf(1, "Number of reads at the start: %d\n", readcount_start_global);
  printf(1, "Number of reads at the end: %d\n", readcount_end_global);
  exit();
}
