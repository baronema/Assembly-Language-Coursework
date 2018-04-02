TITLE Binomial (Binomial.asm)

; Author: Mark Barone
; Last update: 3/2/2016

INCLUDE Irvine32.inc

.data

N_param EQU DWORD PTR [ebp+12]
K_param EQU DWORD PTR [ebp+8]

.code
;---------------------------------------------------------
Binomial PROC 
;
; Binomial(int n, int k)
;
; Calculates binomial coefficient of two parameters 
; (nCk) passed on the stack, using recursion. 
; Receives: Parameter n = row number of coefficient
;           Parameter k = column number of coefficient
; Returns:  EAX = coefficient
;---------------------------------------------------------

     push      ebp                 ; save base pointer
     mov       ebp,esp             ; base of stack frame
          
     mov       edx, N_param        ; N     
     mov       ebx, K_param        ; K

     cmp       bx,0                ;if(k==0)   
     jle       Base                ; return base case
     cmp       dl,bl               ;if(n==k)
     jle       Base                ; return base case

     dec       edx                 ; (n-1)
     push      edx                 ; save return parameter
     push      ebx                 ; save return parameter
     call      Binomial            ; Binomial (n-1, k)
     push      edx                 ; save return parameter
     dec       bl                  ; (k-1)
     push      ebx                 ; save return parameter
     call      Binomial            ; Binomial (n-1, k-1)

     mov       edx, N_Param        ; return with callers 
     mov       ebx, K_Param        ; N & K parameters 
     jmp       Return              ; ((n-1, k) + (n-1, k-1))

Base:
     inc       eax                 ; Return 1

Return:    
     pop       ebp                 ; restore base pointer
     ret       8                   ; clean up stack

     Binomial ENDP

END Binomial