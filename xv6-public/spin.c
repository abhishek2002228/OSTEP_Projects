#include "types.h"
#include "user.h"


int main(int argc, char *argv[]){
  int x = 0;
  for(int i = 0; i < atoi(argv[1]); i++){
    x = x + 1;
  }

  exit(); 
  return x;
}

