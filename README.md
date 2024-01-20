# Frequency Calculator

## Description
This program was created for the final of CPSC 240-07, Computer Architecture and Assembly Programming, which was taught by Floyd Holliday in Spring of 2023. It calculates the total resistance of a parallel circuit with three subcircuits and provides the voltage given a current. It was also designed to output the time elapsed for the calculation, but due to a technical issue at the time, that part of the program is incomplete.

The program is mostly written in x86-64 assembly with driver code written in C and uses a module called getfrequency.asm which is desiged to return the CPU's clockspeed frequency but is inoperable. It also uses a basic batch file, *r.sh*, to compile and run the program. It is designed to be as simple as possible, so there is no GUI--the entire program is ran via the console.

## Problem
There is an electric circuit with three subcircuits wired in parallel. Electricity flows from the generator source in a clockwise route and back to the source. Along the route the electrons may choose one of three paths to complete the circuit.

Diagram: ![Image](https://www.allaboutcircuits.com/uploads/thumbnails/Thumbnail-Parallel_Circuit.jpg)

## Running Frequency Calculator
The program is ran by executing r.sh on a Linux OS with a native installation of Virtual Machine (it was designed and tested using Windows Subsytem for Linux).

If you are already are on Linux, open the console in the local repository and type the following commands:
> ./r.sh

If you are on a Windows PC, open the console in the local repository and type the follwing commands:
> wsl
> ./r.sh

## Credits
Julian Matuszewski
Email: julianmatuszewski@csu.fullerton.edu

## Copyright
This work is covered by the GNU General Public License 3, see **LICENSE** for full Copyright statement.