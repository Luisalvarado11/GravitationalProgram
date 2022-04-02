#!/bin/bash

#Auth Luis Alvarado
#Program name: Gravitational

#clear any previously complied outputs
#rm *.o
#rm *.out

echo "Assemble asm file"
#compiles the assembely code
nasm -f elf64 -l compute_free_fall_time.lis -o compute_free_fall_time.o compute_free_fall_time.asm

echo "Assemble c++ file driver file"
#compiles the c++ code
g++ -c -m64 -Wall -o gravity.o gravity.cpp -fno-pie -no-pie -std=c++17

echo "Assemble c++ file for isFloat"
g++ -c -m64 -Wall -o isFloat.o isFloat.cpp -fno-pie -no-pie -std=c++17

echo "Link the two .o files"
#Link the o files together
g++ -m64 -o final.out gravity.o compute_free_fall_time.o isFloat.o -fno-pie -no-pie -std=c++17

echo "Run the Gravitational Program"
./final.out

echo "The bash script file is now closing"
