#include "types.h"
#include "user.h"
#include "pstat.h"
#include "param.h"

int main(int argc, char *argv[]){
  struct pstat procstat;
  int spin = atoi(argv[1]);
  int x = 0;
  for(int i = 0; i < spin; i++){
	  x++;
  }

  getpinfo(&procstat);
  for(int i = 0; i < NPROC; i++){
    printf(1, "procnum %d [tickets %d][pid %d][ticks %d]\n", i, procstat.tickets[i], procstat.pid[i], procstat.ticks[i]);
  }  
  exit();
}
