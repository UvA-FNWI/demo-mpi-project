# parallel-demo
A simple demo program for the MPI message passing library for high-performance computers. This
serves a similar role as 'Hello world' programs for sequential computing, and LED blinking programs
for embedded systems.

## Required modules
It may be necessary to load one or two modules to be able to compile this software.
Typically, you have to do something like:
```shell
module spider MPI
```
to search for the available MPI versions, and then do something like:
```shell
module load OpenMPI/4.1.4-GCC-11.3.0
```
to load the exact module that you want. (On your system the exact name will be almost certainly
be different.) The MPI variant you choose can have a significant performance impact, but for this
demonstration project the differences are not relevant.

## Usage

To compile the program, simply do
```shell
make all
```
and then do
```shell
sbatch primes-batch.sh
```
to submit it to the Slurm queuing system.


## Files

| File             | Description                                                    |
|------------------|----------------------------------------------------------------|
| Makefile         | Build instructions for the program. Do `make help` for details |
| primes.c         | Count primes, parallelized with MPI                 |
| primes-sbatch.sh | Slurm batch submission file                                    |
| .gitignore  | A list of file patterns to ignore as candidates for GIT file management |

# Message Passing Interface (MPI)

A quick reference of the Message Passing Interface (MPI) constructs that are relevant for this program.

## Basics

A program using MPI code has to add a line
```c
#include <mpi.h>
```
to the top of the source file, and add `-lmpi` to the compiler flags.

## Communicators, rank

Every MPI process belongs to one or more communication groups. The default communication group, called
`MPI_COMM_WORLD` contains all processes that participate in the computation. The communication group is passed
to almost all MPI functions.

Each group has a size (the total number of processors in the group), and all processors in the group

The following code can be used to get the rank and size:
```c
int rank, size;
MPI_Comm_rank(MPI_COMM_WORLD, &rank);
MPI_Comm_size(MPI_COMM_WORLD, &size);
```

## Send and receive

```c
double vector[SZ];
MPI_Status status;
MPI_Send(vector, SZ, MPI_DOUBLE, 2, 0, MPI_COMM_WORLD);
MPI_Recv(vector, SZ, MPI_DOUBLE, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, &status);
```

The `MPI_Send()` and `MPI_Recv()` functions are used to send and receive data.
For `MPI_Recv()` the sending rank may be `MPI_ANY_SOURCE`, which indicates data from any
sender will be accepted. The actual sender is put in a field in `&status`.
Similarly, receiver may specify `MPI_ANY_TAG`, and the actual tag is put in a field in status.

For small messages `MPI_Send()` will return immediately, for large messages an `MPI_Recv()` is needed to accept the
data before `MPI_Send()` returns. This is a potential source of deadlocks.

## Combined Send/Receive

```c
double vector1[SZ], vector2[SZ];
MPI_Status status;
MPI_Sendrecv(vector1, SZ, MPI_DOUBLE, 2, 0,
             vector2, SZ, MPI_DOUBLE, 2, 0, MPI_COMM_WORLD, &status);
```

Here the send and receive are combined in one call.
The ordering of the operations is left to the implementation. This may avoid deadlock!
Send and receive buffers cannot overlap.
Source and destination may be different, also size and even data type.

## Collective communication patterns

The combined send/receive operation is the first *collective* communication function. There are more:
- Reduction: apply a reduction operator such as addition or max() to an array of data distributed over the members of a group.
- Broadcast: send the same data from one member to all members of a group
- Scatter: send a different piece of data from one member to all members of a group
- Gather: collect on one member all the different pieces of data that members of the group have
- AllGather: collect on all members all the different piece of data that all members of a group have


## Running an MPI program

To run an MPI program in SLURM or similar batch systems, it is best to just use the special helper program `mpirun`.
When you load a MPI module, see above, you usually also get a `mpirun`
For example:
```shell script
#!/bin/bash -e
#SBATCH -t 10:00 -N 1 --mem=100M

mpirun ./primes-mpi
```

## Further reading

There are two main MPI implementations:

- Open MPI, see [https://open-mpi.org]
- MPICH, see [https://mpich.org]

See their websites for the official reference documentation of the MPI library.