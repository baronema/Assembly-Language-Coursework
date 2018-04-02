TITLE Integer base conversion (IntegerIO.asm)
; Author: Mark Barone
; Last update: 3/1/2016

INCLUDE Irvine32.inc

.code

;--------------------------------------------------------------------------
ReadInteger PROC
;
; Reads characters from keyboard one at a time, and only displays
; valid characters for current base. Converts valid characters read
; into an integer value in current base notation. Procedure reads character
; until the user presses the Return Key. 
; Receives: BL = number base to read
; Returns:  EAX = integer result in current base
; Calls:    ReadChar, IsLegal, WriteChar
;--------------------------------------------------------------------------

     mov       eax, 0                   ; set result == 0 
     push      eax                      ; move running value to stack

GetChar:
     call      ReadChar                 ; get character input
     cmp       al, 13                   ; return key entered
     je        return                   ; user finished entering input
     mov       dl, al                   ; copy char to convert
     call      IsLegal                  ; determine that input is valid
     cmp       cl, 0                    ; If (cl == 0) char not valid
     je        GetChar                  ; get next character
     call      WriteChar                ; display valid input
     mov       eax, 0                   ; clear before moving running total
     pop       eax                      ; move running value to EAX
     push      dx                       ; protect current char against overflow
     mov       edx, 0                   ; clear register
     movzx     ebx, bl                  ; zero extend base number for multiplication
     mul       ebx                      ; running value multiplied by base
     pop       dx                       ; return current character for conversion
     add       al, dl                   ; add next digit to running value
     push      eax                      ; store running value
     mov       eax, 0                   ; clear register
     jmp       GetChar                  ; get next character

return:
     pop       eax                      ; return result
     call      Crlf
     
     ret
     ReadInteger ENDP

;--------------------------------------------------------------------------
IsLegal PROC
;
; Compares character input to a current base notation to determine
; if the selected character is valid 
; Receives: DL = Ascii Character
; Returns:  CL = 1 if valid, 0 if not valid
; Calls:    AsciiToDigit
;--------------------------------------------------------------------------

     call      AsciiToDigit             ; convert char to decimal
     cmp       dl, -1                   ; If (dl == -1) not a valid char
     jnge      Return
     cmp       dl, bl                   ; determine if input is valid for base
     jb        valid                    ; valid character < Base Value
     mov       cl, 0                    ; return 0 for non valid input
     jmp       Return

valid:
     mov       cl, 1                    ; return 1 for valid input

Return:
     ret
     IsLegal ENDP


;--------------------------------------------------------------------------
AsciiToDigit PROC
;
; Converts an Ascii character to its numeric value, (0-9 | A-F | a-f)
; Receives: DL == Ascii Char
; Returns:  DL == Char in numeric value, or -1 for invalid char  
;--------------------------------------------------------------------------

     cmp    dl, 30h     ; compares input to ASCII code for 0
      jl    error       ; if input is less than 0 return, not valid
     cmp    dl, 39h     ; compares input to ASCII code for 9
     jle    convert1    ; convert char '0' - '9' to decimal
     cmp    dl, 41h     ; compares input to ASCII code for 'A'
      jl    error       ; if input is less than 'A', not valid
     cmp    dl, 46h     ; compares input to ASCII code for 'F'
     jle    convert2    ; if input is less than or equal to 'F' jump to convert2
     cmp    dl, 61h     ; compares input to ASCII code for 'a'
      jl    error       ; if input is less than 'a', not valid
     cmp    dl, 66h     ; compares input to ASCII code for 'f'
     jle    convert3    ; if input is less than or equal to 'f' jump to convert3
error:
     mov    dl, -1      ; invalid character entered
     jmp    return      ; if input is greater than 'f', not valid

convert1:

     sub    dl, 30h     ; convert char '0' - '9' to decimal
     jmp    return      ; return converted value

convert2:
     sub    dl, 37h     ; convert char 'A' - 'F' to decimal
     jmp    return      ; return converted value

convert3:
     sub    dl, 57h     ; convert char 'a' - 'f' to decimal    

return:
     
     ret
     AsciiToDigit ENDP

;--------------------------------------------------------------------------
WriteInteger PROC
;
; Converts an integer in base 10 into another base using division,
; and displays the converted integer 
; Receives: EAX = number to convert, BL = base to conver to
; Calls:    DigitToAscii           
;--------------------------------------------------------------------------

     mov       ecx, 0              ; set count to zero
     cmp       bl, 16              ; convert to base 16
     je        B16
     cmp       bl, 10              ; convert to Ascii string
     je        B10                 
     cmp       bl, 8               ; convert to base 8
     je        B8
          
B2:
     mov       edx, eax            ; copy value to get remainder
     and       dl, 0001b           ; get remainder
     shr       eax, 1              ; divide by 2
     push      dx                  ; store remainder
     inc       ecx                 ; increment count == number of char's
     cmp       eax, 0              ; done if quotient is zero
     jg        B2                  ; continue if quotient > zero
     jmp       PrintStack          ; print string 

B8:
     mov       edx, eax            ; copy value to get remainder
     and       dl, 0111b           ; get remainder
     shr       eax, 3              ; divide by 8
     push      dx                  ; store remainder
     inc       ecx                 ; increment count == number of char's
     cmp       eax, 0              ; done if quotient is zero
     jg        B8                  ; continue if quotient > zero
     jmp       PrintStack          ; print string 

B10:
     mov       edx, 0              ; clear upper dividend
     div       ebx                 ; divide by 10
     push      dx                  ; store remainder
     inc       ecx                 ; increment count of char's
     cmp       eax, 0              ; done if quotient == 0
     jg        B10                 ; continue if quotient > 0
     jmp       PrintStack          ; print string 

B16:
     mov       edx, eax            ; copy value to get remainder
     and       dl, 1111b           ; get remainder
     shr       eax, 4              ; divide by 16
     push      dx                  ; store remainder
     inc       ecx                 ; increment count == number of char's
     cmp       eax, 0              ; done if quotient is zero
     jg        B16                 ; continue if quotient > zero
     jmp       PrintStack          ; print string 

PrintStack:
     mov       eax, 0              ; clear register
     pop       ax                  ; pop first digit to print
     call      DigitToAscii        ; convert digit to Ascii value
     cmp       al, 0               ; check that value is valid
     jl        NotValid            
     call      WriteChar           ; Print Ascii
     Loop      PrintStack          ; Continue if digits remain in stack

NotValid:  

     ret
     WriteInteger ENDP


;--------------------------------------------------------------------------
DigitToAscii PROC
;
; Reads digits and verifies they are in the range 0-15
; converts valid digits to Ascii values
; Receives:  AL = digit to convert
; Returns:   AL = digit as Ascii value
;--------------------------------------------------------------------------

     cmp       al, 15         ; digits > 15 are not valid
     jg        error          
     cmp       al, 9          ; digits 10-15 == 'A'-'F''
     jg        character
     add       al, 30h        ; digit == '0'-'9''
     jmp       return

character:
     add       al, 37h        ; convert to 'A'-'F'
     jmp       return

error:
     mov       al, -1         ; invalid character input

return:

     ret
     DigitToAscii ENDP

END ReadInteger