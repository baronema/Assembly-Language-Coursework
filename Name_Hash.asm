TITLE Barone-Assn2-Program2.asm
; This program accepts a person's name,
; and calculates a hash value by performing
; an XOR operation on each character of the name
; Author: Mark Barone
; Last Update: 1/23/16

INCLUDE Irvine32.inc

.data
person BYTE "Mark Barone"        ;string to check characters

                                                                                
.code

main PROC
; main program control procedure

     mov     al,0                  ;clear register to store results
     mov     ecx,LENGTHOF person   ;set loop index to length of string
     mov     ebx, OFFSET person    ;set register to point to addr of string

ChkChar:
      
     mov     dl, [ebx]             ;copy current character into register                                                                                                                                                                                                                                                                   
     xor     al,dl                 ;compare previous result with current char
     inc     ebx                   ;point to next byte in string
     loop    ChkChar               ;continue xor until all char's compared

     
     call    DumpRegs              ;display results


	Invoke ExitProcess,0
main endp
end main

