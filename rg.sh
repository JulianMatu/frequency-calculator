#!/bin/bash
#Debug File

#Clear any previously compiled outputs
rm *.o
rm *.out

echo "Assemble manager.asm"
nasm -f elf64 -o manager.o manager.asm -g -gdwarf

echo "Assemble getfrequency.asm"
nasm -f elf64 -o getfreq.o getfrequency.asm -g -gdwarf

echo "Compile main.c"
gcc -c -Wall -no-pie -m64 -std=c2x -o main.o main.c -g

echo "Link object files"
g++ -m64 -no-pie -o debug.out main.o manager.o getfreq.o -std=c2x -g

echo "Run the program:"
gdb ./debug.out

# For cleaner working directory, you can:
rm *.o
rm *.out

echo "Script file terminated."