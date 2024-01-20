#!/bin/bash
#Program: Sine Benchmarks
#Author: Julian Matuszewski
#Email: julianmatuszewski@csu.fullerton.edu
#Course: CPSC 240-7
#Date: May 14, 2023
#File Name: r.sh

#Clear any previously compiled outputs
rm *.o
rm *.out

echo "Assemble manager.asm"
nasm -f elf64 -o manager.o manager.asm

echo "Assemble getfrequency.asm"
nasm -f elf64 -o getfreq.o getfrequency.asm

echo "Compile main.c"
gcc -c -Wall -no-pie -m64 -std=c2x -o main.o main.c

echo "Link object files"
g++ -m64 -no-pie -o     circuits.out main.o manager.o getfreq.o -std=c2x

echo "Run the program:"
./circuits.out

# For cleaner working directory, you can:
rm *.o
rm *.out

echo "Script file terminated."