#!/bin/bash -e
#SBATCH -t 3:00 -n 16 --mem=100M

mpirun primes
