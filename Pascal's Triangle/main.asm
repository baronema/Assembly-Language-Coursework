TITLE Integer base conversion (Barone-Assn6-Program.asm)
; This program calculates the binomial coefficients of two
; numbers in order to display a portion of Pascal's Triangle
; up to a size determined by the user.

; Author: Mark Barone
; Last update: 3/5/2016

INCLUDE Irvine32.inc

EXTERN Binomial: PROTO
EXTERN ReadInteger: PROTO
EXTERN WriteInteger: PROTO

.data
SPACE BYTE 20h,0                   ; for displaying blank space char
BASE = 10                          ; integer base notation
MAX_SIZE = 10                      ; maximum size of Pascals's triangle


tSize BYTE ?                       ; User selected size of triangle
varN BYTE ?                        ; Variable for N
varK BYTE ?                        ; Variable for K

msg1 BYTE "Enter an integer (1 thru 10 or 0 to exit): ",0
errMsg BYTE "Integer chosen not in range, choose again:",13,10,0

.code

main PROC
; Main procedure loops prompting user to choose size of triangle
; to display until user selects 0 to exit. Calls Binomial to
; calculate the coefficient for current row position, and displays
; coefficient per formatting requirements.
; Calls: WriteString, Crlf, Binomial, ReadInteger, WriteInteger

Start:
     mov       edx, OFFSET msg1      ; prompt user for size
     call      WriteString
     mov       bl, BASE              ; pass base to ReadInteger   
     call      ReadInteger           ; Read triangle size
     cmp       al, MAX_SIZE          ; if(size > MAX)   
     jg        Error                 ; display error message
     cmp       al, 0                 ; if (input == 0)   
     je        Ex                    ; exit program   

     mov       tSize, al             ; save triangle size
     mov       varN, 0               ; begin at n = 0
     mov       varK, 0               ; begin at k = 0
     mov       cl, 0                 ; for indenting row

SetTab:
     cmp       tSize, cl             ; if(count == tSize)    
     je        CalcC                 ; calculate coefficient   
     mov       edx, OFFSET space     ; else (indent)
     call      WriteString
     inc       cl                    ; count spaces indented   
     jmp       SetTab                ; check formatting
     
CalcC:
     mov       bl, varN              ; pass current value
     push      ebx                   ; of n as parameter
     mov       bl, varK              ; pass current value
     push      ebx                   ; of k as parameter   
     mov       eax, 0                ; clear return value
     call      Binomial              ; determine coefficient
     mov       bl, BASE              ; pass Base# parameter
     call      WriteInteger          ; display coefficient
     mov       edx, OFFSET space     ; add a space
     call      WriteString

     inc       varK                  ; calc next coefficient in row
     mov       al, varN              ; get current value for N
     mov       bl, varK              ; get current value for K
     cmp       al, bl                ; if (n > k)   
     jge       CalcC                 ; find next coefficient
     inc       varN                  ; else begin at next row
     mov       varK, 0               ; start at first position in row
     call      Crlf 

     mov       cl, varN              ; get current value for N
     cmp       cl, tSize             ; if (n < tSize)
     jl        SetTab                ; more rows to calculate   
     call      Crlf                  ; else    
     jmp       Start                 ; current triangle finished
             
Error:
     call      Crlf
     mov       edx, OFFSET errMsg    ; triangle size out of range
     call      WriteString
     call      Crlf
     jmp       Start                 ; reprompt user for size

Ex:
     call      Crlf
     exit

main ENDP

END Main


