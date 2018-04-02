TITLE ADD/MULT/PWR Calculator (Barone-Assn3-Program.asm)
; This program accepts two positive integers from user
; and calcualtes a sum, product, and power from the integer inputs

INCLUDE Irvine32.inc

.data
inputPrompt BYTE "Enter a positive integer: ", 0
showSum BYTE 'The sum is: ', 0
showProduct BYTE 0dh, 0ah, 'The product is: ', 0
showPower BYTE 0dh, 0ah, 'The power result is: ', 0
newLine BYTE 0Dh, 0Ah, 0
intVal1 SDWORD ?
intVal2 SDWORD ?

.code

main PROC
; Main program control procedure.
; Calls: GetInteger, AddNumbers, MultiplyNumbers,
;         CalculatePower
     
     call      GetInteger               ;1st int   
     mov       intVal1, eax             ;input by user
     call      GetInteger               ;2nd integer
     mov       intVal2, eax             ;input by user

     mov       eax, intVal1             ;store numbers to
     mov       ebx, intVal2             ;be summed in proc
     call      AddNumbers               

     mov       edx, OFFSET showSum      ;display result of
     call      WriteString              ;addition to screen
     mov       edx, eax
     call      WriteInt

     mov       eax, 0                   ;product of sums begins at 0
     mov       ebx, intVal1             ;number to be multiplied
     mov       ecx, intVal2             ;# of times Val1 is multiplied
     call      MultiplyNumbers

     mov       edx, OFFSET showProduct  ;display multiplication prompt
     call      WriteString              ;and result of multiplication
     mov       edx, eax                 ;to the screen
     call      WriteInt

     mov       eax, intVal1             ;represents base number
     mov       ebx, 0                   ;will be added to base #
     mov       ecx, intVal2             ;loop index set to value of power
     call      CalculatePower           

     mov       edx, OFFSET showPower    ;display power prompt
     call      WriteString              ;and results of power equation
     mov       edx, eax                 ;to the screen
     call      WriteInt

     mov       edx, OFFSET newLine      ;for formatting output
     call      WriteString
     
     exit    
main ENDP

;--------------------------------------------------------------------------
GetInteger PROC
;
; Prompts user to enter a positive integer, and returns value to main
; Returns: User entered input is stored in EAX
;--------------------------------------------------------------------------

     mov       edx, OFFSET inputPrompt
     call      WriteString
     call      ReadInt

     ret
     GetInteger ENDP

;--------------------------------------------------------------------------
AddNumbers PROC
;
; Calculates the sum of two 32-bit integers
; Receives: EAX = integer 1, EBX = integer 2
; Returns: EAX = sum of integers 1 and 2
;--------------------------------------------------------------------------
     
     add       eax, ebx                 ;perform addition of numbers
     ret
     AddNumbers ENDP

;--------------------------------------------------------------------------
MultiplyNumbers PROC
;
; Receives two integers in EAX and EBX, and multiplies the
; EAX number EBX times by calling AddNumbers in a loop.
; Receives: EAX = 0, EBX = number to be multiplied, ECX = number of times
;          to multiply EBX
; Returns: EAX = the sum of the first number and itself, performed as many
;               times as the second number 
; Calls:  AddNumbers
;-------------------------------------------------------------------------- 
 
MultLoop:

     call      AddNumbers               ;performed to calculate product
     loop      MultLoop                 ;index set to val of 2nd integer

     ret
     MultiplyNumbers ENDP

;--------------------------------------------------------------------------
CalculatePower PROC
;
; Calls the MultiplyNumbers procedure in order to determined the calculation
; of the first integer value to the power of the second integer value.
; Receives: EAX = first integer (base), EBX = 0 to account for multiplying by 1
;           ECX = second integer (power)
; Returns:  EAX = result of power calculation
; Calls:    MultiplyNumbers
;---------------------------------------------------------------------------

PowerLoop:
     push      ecx                          ;save index representing power
     mov       ecx, intVal1                 ;set times by for MultiplyNumbers
     call      MultiplyNumbers              ;will call AddNumbers for first product 
     mov       ebx, eax                     ;set number to multiply equal to new sum
     mov       eax, 0                       ;to represent multiplication by 1 
     pop       ecx                          ;store power index for loop command
     loop      PowerLoop

     mov       eax, ebx                     ;move final sum to return to main

     ret
     CalculatePower ENDP


END main