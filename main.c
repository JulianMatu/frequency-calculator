//Author name: Julian Matuszewski
//Author email: julianmatuszewski@csu.fullerton.edu
//Class: CPSC 240-7
//File Name: main.c
//File Information: This module main.c contains the driver code in the main() function that runs the circuit program

#include <stdio.h>
#include <stdlib.h>

//import x86 main function
extern double manager();

int main () {
    
    //Introduction message
    printf("Welcome to Electric Circuits programmed by Julian Matuszewski.\n\n");

    //call the manager() function from the executive x86 source file
    double output = manager();
    
    //Outro message
    printf("The main function received %1.8f and will keep it for future reference.\n", output);
    printf("The main function will return a zero to the operating system\n");

    return 0;
}

//============================ end of code =========================================================================