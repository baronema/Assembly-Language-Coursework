TITLE Barone-Assn2-Prog1.asm
; This program accepts a positive integer and
; calculates the sum of all of the integers between
; the number 1, and the chosen integer.
; Author: Mark Barone
; Last Update: 1/22/16

INCLUDE Irvine32.inc

.data
count DWORD 1000              ;last number in sequence
index DWORD 1                 ;for walking sequence

.code

main PROC
;main program control procedure

     mov     eax,0            ;clear register for running sum
     mov     ecx,count        ;set loop index

SumNext:
     
     add     eax,index        ;add next value to sum
     inc     index            ;set next integer to add to sum
     loop    SumNext          ;loop until all integers are added

     call    DumpRegs         ;display results

	Invoke ExitProcess,0
main ENDP
END main
