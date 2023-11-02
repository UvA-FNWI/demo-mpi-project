EXECUTABLES=primes

EXPENSIVE_JUNK += $(EXECUTABLES)

SRC = primes.c

JUNK +=

CFLAGS += -O3 -Wall -W --std=c11 -lm
CXXFLAGS += -O3 -Wall -W --std=c++11 -lm -Wno-cast-function-type
OMP_CFLAGS = $(CFLAGS) -fopenmp
MPI_CFLAGS = $(CXXFLAGS) -lmpi

help:
	@echo "help\tShow this help text"
	@echo "all\tMake all executables"
	@echo "clean\tThrow away all files that are easy to produce again"
	@echo "empty\tThrow away all files that can be produced again"

all: $(EXECUTABLES)

clean:
	rm -rf $(JUNK)

empty:
	rm -rf $(JUNK) $(EXPENSIVE_JUNK)

primes: primes.c
	mpiCC $(MPI_CFLAGS) -o primes primes.c

