//****************************************************************************************************************************
//Author Information:                                                                                                       *
//Author: Luis alvarado                                                                                                     *
//Email: luisalvarado@csu,fullerton.edu                                                                                     *
//Section: CPSC 240-07                                                                                                      *
//                                                                                                                          *
//Program Information:                                                                                                      *
//Program Name: Gravitational                                                                                               *
//Language: C++                                                                                                             *
//Files: Driver,cpp, compute_free_fall_time.asm, isFloat.cpp, run.sh                                                        *
//This File: gravity.cpp                                                                                                    *
//Purpose: 1) Validating float inputs 2) Store constant onto program 3) how to                                              *
//             multiply and divide float number stored in xmm register.                                                     *
//                                                                                                                          *
//Copyright(c) 2022 Luis Alvarado                                                                                           *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License *
//version 3 as published by the Free Software Foundation.                                                                   *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied        *
//Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.    *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                          *
//To run program, use : "./run.sh"                                                                                          *
//***************************************************************************************************************************



#include <stdio.h>

extern "C" double height();

int main() {
  //welcome statement
  double height_ = 0.0;

  printf("Welcome to Gravitational Attraction maintained by Luis Alvarado. \n");
  printf("This project was last updated on Febraury 24, 2022 \n");

  height_ = height();

  printf("The main driver recieved this number %lf and will simply keep it. \n", height_);

  return 0;
}
