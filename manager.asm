;Author name: Julian Matuszewski
;Author email: julianmatuszewski@csu.fullerton.edu
;Class: CPSC 240-7
;File Name: manager.asm
;File Information: This module manager.asm will take inputs for current and resistance of a 3-way parallel circuit and spit out the
;                   relevant electrical quantities as well as benchmark its own performance.

;external C/C++ library functions
extern printf
extern scanf
extern atof         ;this library function converts strings into doubles
extern atoi         ;this library function converts strings into long ints
extern getfreq      ;this is the function inside getfrequency.asm that will give the CPU clckspd

global manager

;declare initialized arrays (cstrings)
segment .data
    prompt_current: db "Please enter the current: ", 0
    prompt_resistance1: db "Please enter the resistance on circuit 1: ", 0
    prompt_resistance2: db "Please enter the resistance on circuit 2: ", 0
    prompt_resistance3: db "Please enter the resistance on circuit 3: ", 0
    total_resistance: db "The total resistance is R = %1.8f", 10, 0
    total_voltage: db "The voltage is V = %1.8f", 10, 0
    cpu_frequency: db "The frequency of this processor is %llu tics/second.", 10, 0
    info_result: db "The computations were performed in %llu tics, which equals %1.8f seconds.", 10, 10, 0
    frequency_prompt: db "Unable to retrieve CPU frequency! Please enter processor frequency in MHz as a whole number: ", 0

    ;additional strings
    format: db "%s", 0
    format_float: db "%f", 0
    format_int: db "%d", 0

    ;additional data
    one: dq 1.0
    one_million: dq 1000000


;declare uninitialized arrays
segment .bss
    


;instructions including functions
segment .text
    manager:
        ;Prolog ===== Insurance for any caller of this assembly module ========================================================
        ;Any future program calling this module that the data in the caller's GPRs will not be modified.
        push rbp
        mov  rbp,rsp
        push rdi                                                    ;Backup rdi
        push rsi                                                    ;Backup rsi
        push rdx                                                    ;Backup rdx
        push rcx                                                    ;Backup rcx
        push r8                                                     ;Backup r8
        push r9                                                     ;Backup r9
        push r10                                                    ;Backup r10
        push r11                                                    ;Backup r11
        push r12                                                    ;Backup r12
        push r13                                                    ;Backup r13
        push r14                                                    ;Backup r14
        push r15                                                    ;Backup r15
        push rbx                                                    ;Backup rbx
        pushf                                                       ;Backup rflags

        ;Operation Blocks:

        ;Align the stack
        push qword 0

        ;=================== Prompt User for Circuit Information ===========================================================

        ;Prompt Current
        push qword 0
        lea rdi, [prompt_current]
        xor rax, rax
        call printf                 ;print prompt
        lea rdi, [format]
        lea rsi, [rsp]              ;write onto the stop of the stack
        call scanf                  ;call scanf
        mov rdi, rsp
        call atof                   ;convert string input into a float
        movsd xmm12, xmm0           ;current is in xmm12
        pop rax

        ;Prompt resistance for circuit 1
        push qword 0
        lea rdi, [prompt_resistance1]
        xor rax, rax
        call printf                 ;print prompt
        lea rdi, [format]
        lea rsi, [rsp]              ;write onto the stop of the stack
        call scanf                  ;call scanf
        mov rdi, rsp
        call atof                   ;convert string input into a float
        movsd xmm13, xmm0           ;resistance 1 is in xmm13
        pop rax

        ;Prompt resistance for circuit 2
        push qword 0
        lea rdi, [prompt_resistance2]
        xor rax, rax
        call printf                 ;print prompt
        lea rdi, [format]
        lea rsi, [rsp]              ;write onto the stop of the stack
        call scanf                  ;call scanf
        mov rdi, rsp
        call atof                   ;convert string input into a float
        movsd xmm14, xmm0           ;resistance 2 is in xmm14
        pop rax

        ;Prompt resistance for circuit 3
        push qword 0
        lea rdi, [prompt_resistance3]
        xor rax, rax
        call printf                 ;print prompt
        lea rdi, [format]
        lea rsi, [rsp]              ;write onto the stop of the stack
        call scanf                  ;call scanf
        mov rdi, rsp
        call atof                   ;convert string input into a float
        movsd xmm15, xmm0           ;resistance 3 is in xmm15
        pop rax

        ;=================== Find the number of CPU tics before the calculation =======================================
        xor rdx, rdx	;zero out both registers
        xor rax, rax
        cpuid
        rdtsc			;puts clock tics into the rdx and rax registers in the first halves (edx and eax)
        shl rdx, 32		;moves the edx part to the front half
        add rdx, rax	;puts the full tic number into the rdx register
                        ;# of tics since the CPU was powered on
        mov r14, rdx	;CPU tics before benchmark in r14

        ;================== Calculate the total resistance ============================================================
        ;In this case (1/R) = (1/r1) + (1/r2) + (1/r3)
        ;We must first invert the resistance values in xmm13-15 and add them
        ;The resulting total resistance will be stored in xmm13

        ;Find the inverse of r1 (xmm13)
        movsd xmm0, [one]       ;move 1.00 into xmm0
        divpd xmm0, xmm13
        movsd xmm8, xmm0

        ;Find the inverse of r2 and add to the result
        movsd xmm0, [one]
        divpd xmm0, xmm14
        addsd xmm8, xmm0

        ;Find the invese of r3 and add to the result
        movsd xmm0, [one]
        divpd xmm0, xmm15
        addsd xmm8, xmm0

        ;Find the inverse of r8 and put into r13
        movsd xmm0, [one]
        divpd xmm0, xmm8
        movsd xmm13, xmm0

        ;Print the result
        push qword 0
        lea rdi, [total_resistance]
        movsd xmm0, xmm13
        mov rax, 1
        call printf
        pop rax

        ;================== Find the voltage ==========================================================================
        ;The calculate of voltage is: V = IR, I = current (in xmm12)
        ;We will store the voltage in xmm12
        mulsd xmm12, xmm13

        ;Print the voltage
        push qword 0
        lea rdi, [total_voltage]
        movsd xmm0, xmm12
        mov rax, 1
        call printf
        pop rax

        ;================== Find the number of CPU tics after the calculation =========================================
        xor rdx, rdx	;zero out both registers
        xor rax, rax
        cpuid
        rdtsc			;puts clock tics into the rdx and rax registers in the first halves (edx and eax)
        shl rdx, 32		;moves the edx part to the front half
        add rdx, rax	;puts the full tic number into the rdx register
                        ;# of tics since the CPU was powered on
        mov r15, rdx	;CPU tics before benchmark in r15

        ;================= Find the elapsed tics and time for the calculation ========================================
        ;Calculate the difference in CPU tics
        sub r15, r14				;r15 now stores elapsed time in tics

        ;Find the frequency of the processor using the getfreq function and store into xmm14
        push qword 0
        call getfreq
        movsd xmm14, xmm0       ;xmm14 is in MHz
        pop rax
        movsd xmm0, qword [one_million]
        mulsd xmm14, xmm0           ;multiply the MHz value by 10^6 to get Hz which equals tics/second
        cvtsd2si r12, xmm14         ;tics/seconds is now in r12

        ;In the case that this fails, prompt the user for their CPU frequency in MHz    
        cmp r12, 0                          ;if r12 = 0, the CPU frequency was not found
        jne display_processor_frequency

        push qword 0
        lea rdi, [frequency_prompt]
        xor rax, rax
        call printf                 ;print prompt
        lea rdi, [format]
        lea rsi, [rsp]              ;write onto the stop of the stack
        call scanf                  ;call scanf
        mov rdi, rsp
        call atoi                   ;convert string input into an int
        mov r12, rax                ;frequency is in r12
        pop rax
        mov rax, 1000000
        imul r12, rax           ;multiply the MHz value by 10^6 to get Hz which equals tics/second

        ;Display the processor frequency
        display_processor_frequency:        ;entry point if CPU frequency is found using getfreq
        push qword 0
        lea rdi, [cpu_frequency]
        mov rsi, r12
        xor rax, rax
        call printf
        pop rax

        ;Calculate the number of seconds required to for the computations
        ;Divide the tics elapsed by the number of tics per second and that should get the number of seconds elapsed
        ;Before we do any calculations, we will have to convert both numbers into floats using SSE registers
        cvtsi2sd xmm0, r15      ;xmm0 stores tics elapsed
        cvtsi2sd xmm1, r12      ;xmm1 stores tics/sec
        divpd xmm0, xmm1        ;xmm0 now stores seconds elapsed
        movsd xmm15, xmm0       ;xmm15 now stores seconds elapsed

        ;Print tics elapsed and seconds elapsed
        push qword 0
        lea rdi, [info_result]
        mov rsi, r15            ;r15 stores tics elapsed
        movsd xmm0, xmm15       ;xmm15 stores seconds elapsed
        mov rax, 1
        call printf
        pop rax
        
        ;Realign the stack
        pop rax

        ;Move calculated voltage into return register
        movsd xmm0, xmm12

        ;===== Restore original values to integer registers ===================================================================
        popf                                                        ;Restore rflags
        pop rbx                                                     ;Restore rbx
        pop r15                                                     ;Restore r15
        pop r14                                                     ;Restore r14
        pop r13                                                     ;Restore r13
        pop r12                                                     ;Restore r12
        pop r11                                                     ;Restore r11
        pop r10                                                     ;Restore r10
        pop r9                                                      ;Restore r9
        pop r8                                                      ;Restore r8
        pop rcx                                                     ;Restore rcx
        pop rdx                                                     ;Restore rdx
        pop rsi                                                     ;Restore rsi
        pop rdi                                                     ;Restore rdi
        pop rbp                                                     ;Restore rbp
ret