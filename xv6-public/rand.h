#ifndef _RAND_H_
#define _RAND_H_

#define RANDOM_MAX ((1u << 31u) - 1u)

unsigned lcg_parkmiller(unsigned *state);
unsigned next_random();


#endif //_RAND_H_
