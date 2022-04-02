;****************************************************************************************************************************
;Author Information:                                                                                                        *
; Author: Luis alvarado                                                                                                     *
; Email: luisalvarado@csu,fullerton.edu                                                                                     *
; Section: CPSC 240-07                                                                                                      *
;                                                                                                                           *
;Program Information:                                                                                                       *
; Program Name: Gravitational
; Language: x86 Assembly                                                                                            *
; Files: Driver,cpp, compute_free_fall_time.asm, isFloat.cpp, run.sh                                                        *
; This File: Gravitational                                                                                                  *
; Purpose: 1) Validating float inputs 2) Store constant onto program 3) how to                                              *
;             multiply and divide float number stored in xmm register.                                                      *
;                                                                                                                           *
;Copyright(c) 2022 Luis Alvarado                                                                                            *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
;Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;To run program, use : "./run.sh"                                                                                           *
;****************************************************************************************************************************
extern printf
extern scanf
extern fgets
extern stdin
extern strlen
extern isFloat
extern atof

INPUT_LEN equ 256                         ; max of bytes for name, job, and user

global height                             ;Global Scope

segment .data                             ; where we declare our variables / text (Initialized data)
value: dq 0x402399999999999A              ; declaring 9.8 in hex

welcome db "If errors are discovered please report them to Luis at luis.alvarado@csu.fullerton.edu for a rapid "
        db "update. At Columbia, inc, the customer comes first.",10, 0

name_last db "Please enter your first and last names: ",0

name_last_input db "%s", 0

job_title db "Please enter your job title(Nurse, Programmer, Teacher, Carpenter, Mechanic, Bus Driver,"
          db "Barista, Hair Dresser, Acrobat, Senator, Sales Clerk, etc: ",0

job_title_input db "%s", 0

thanks db "Thank you %s. We appreciate your business." ,10,0

vantage db "We understand that you plan to drop a marbel from a high vantage point." ,10,0

height_text db "Please enter the height of the marbel above the ground surface in meters: ",0

height_input db "%s", 0

;VALID FLOAT
drop db "The marbel you drop from that height will reach earth after %lf seconds.",10,0

finished db "Thank you %s for your participation. May you always reach great heights.", 10,0

;INVALID FLOAT
error db "An error was detected in the input area. You may run this program again.",10,0

goodbye db "Thank you %s for your participation. May you never lose sight of the goal.", 10,0

segment .bss
;reserves 256 bytes for each name, title, and drop input
title: resb INPUT_LEN
name: resb INPUT_LEN
user_input: resb 32
drops: resq 1

segment .text ; where we put code
height:       ; Enters Program

push    rbp

mov     rbp,rsp
push    rbx
push    rcx
push    rdx
push    rsi
push    rdi
push    r8
push    r9
push    r10
push    r11
push    r12
push    r13
push    r14
push    r15
pushf

;==========================Displays db welcome=================================
push qword 0
mov rax, 0
mov rdi, welcome
call printf
pop rax

;==========================isplays db name_last================================
push qword 0
mov rax, 0 ; indicate we have no floating point argument to pass external funct
mov rdi, name_last_input  ; move first argument into register rdi
mov rsi, name_last        ; moves db name_last onto rsi
call printf               ; call external function printf
pop rax

;=========================Displays db input=====================================
push qword 0
mov rax, 0
mov rdi, name             ; insert name and last
mov rsi, INPUT_LEN        ; allows more space (256)
mov rdx, [stdin]          ; move contents onto [stdin]
call fgets                ; call fgets
pop rax

;=========================Remove new line======================================
push qword 0
mov rax, 0
mov rdi, name             ; moves name onto rdi
call strlen               ; calls external function strlen and returns the input legnth of the string
sub rax,1                 ; subtracts 1 from the string '\n'
mov byte[name + rax], 0   ; replaces byte "\n"
pop rax

;===========================thanks user========================================
push qword 0
mov rax, 0
mov rdi, thanks
mov rsi, name
call printf
pop rax

;==========================display job title===================================
push qword 0
mov rax, 0
mov rdi, job_title_input  ;moves job input onto rdi
mov rsi, job_title        ;moves db job_title onto rsi
call printf               ;call extern function printf
pop rax

;=========================display job title input==============================
push qword 0
mov rax, 0
mov rdi, title            ;moves title onto rdi
mov rsi, INPUT_LEN        ;moves 256 bytes onto rsi
mov rdx, [stdin]          ;dereferrences stdin
call fgets                ;call external function fgets
pop rax

;=========================remove newline=======================================
push qword 0
mov rax, 0
mov rdi, title            ;moves title onto rsi
call strlen               ;call external function strlen and return the string length
sub rax, 1                ;subtract 1 from string '\n'
mov byte[title + rax], 0  ;replaces the byte with \0
pop rax

;==========================Display thanks======================================
push qword 0
mov rax, 0
mov rdi, thanks           ;moves thanks onto rdi
mov rsi, title            ;move the job title stored in title onto rsi
call printf               ;call external function printf
pop rax

;==========================Display vantage=====================================
push qword 0
mov rax, 0
mov rdi, vantage          ;moves db vantage onto rdi
call printf               ;call printf
pop rax

;==========================Display height_input================================
push qword 0
mov rax, 0
mov rdi, height_text      ;move db height_text onto rdi
call printf               ;call printf
pop rax

;==========================height input========================================
push qword 0
push qword 0
mov rax, 0
mov rdi, height_input
mov rsi, user_input
call scanf
pop rax
pop rax

;==========================Checks for invalid input===========================
mov rax, 0
mov rdi, user_input       ;stores rsi onto user_input
call isFloat              ;moves the user_input onto isFloat

;==========================Validates input through isFloat====================
cmp rax, 0
je invalid_input

mov rax, 1                ;the use of xmm0
mov rdi, user_input       ;moves height into rdi
call atof                 ;Convert string to float
movsd xmm15, xmm0         ;height is stored into xmm0

;================================MATH==========================================
movsd xmm13, [value]      ;stores value into xmm13
movsd xmm12, xmm15        ;register xmm15 had the height
divsd xmm12, xmm13        ;divides height / value
sqrtsd xmm12, xmm12       ;sqrt(height / 9.8)
movsd [drops], xmm12

;=============================Display drop=====================================
push qword 0
push qword 0
mov rax, 1
mov rdi, drop
movsd xmm0, [drops]
call printf
pop rax
pop rax

;===============================finished=======================================
push qword 0
mov rax, 0
mov rdi, finished
mov rsi, name
call printf
pop rax

movsd xmm0, [drops]

jmp end_file
;================================bad_input======================================
invalid_input:

;Displays Error message
push qword 0
mov rax, 0
mov rdi, error
call printf
pop rax

;=============================Displays goodbye=================================
push qword 0
mov rax, 0
mov rdi, goodbye
mov rsi, name
call printf
pop rax

;===============================return -1=======================================
mov rax, 1
neg rax
cvtsi2sd xmm0, rax

jmp end_file

end_file:
;===================Restore the original values to the GPRs=====================
popf                                                        ;Restore rflags
pop        r15                                              ;Restore r15
pop        r14                                              ;Restore r14
pop        r13                                              ;Restore r13
pop        r12                                              ;Restore r12
pop        r11                                              ;Restore r11
pop        r10                                              ;Restore r10
pop        r9                                               ;Restore r9
pop        r8                                               ;Restore r8
pop        rdi                                              ;Restore rdi
pop        rsi                                              ;Restore rsi
pop        rdx                                              ;Restore rdx
pop        rcx                                              ;Restore rcx
pop        rbx                                              ;Restore rbx
pop        rbp                                              ;Restore rbp
ret
