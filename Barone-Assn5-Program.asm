TITLE Integer base conversion (Barone-Assn5-Program.asm)
; This program allows a user to chose any base number
; in the range 2-16, and then converts a 32 bit integer
; from the selected base into base 2, 8, 10, and 16

; Author: Mark Barone
; Last update: 2/19/2016

INCLUDE Irvine32.inc

.data
prompt1 BYTE "Enter base value (2 thru 16 or 0 to exit): ", 0
prompt2 BYTE "Enter a number in your chosen base: ", 0
base2 BYTE  "Base 2:   ", 0
base8 BYTE  "Base 8:   ", 0
base10 BYTE "Base 10:  ", 0
base16 BYTE "Base 16:  ", 0
eMessage1 BYTE "Error: base value must be (2 - 16), try again: ", 0
eMessage2 BYTE "Error: no integer input, try again: ", 0

.code

main PROC
; Main procedure loops prompting user to input base number
; and integer, then displays valid entries as base 2,8,10,16
; Program exits when '0' is selected as a base number
; Calls: WriteString, ReadInteger, DisplayIntegers

     mov  eax, 0
     mov  ebx, 0
     mov  edx, 0
     mov ecx, 0
     mov  esi, 0

     mov eax, 4
     mov ebx, 2

     call Binomial

     call WriteInt












    


getBase:
     mov       bl, 10                   ; read base input as decimal
     mov       edx, OFFSET prompt1      ; prompt user for base
     call      WriteString
     call      ReadInteger              ; get base number
     cmp       eax, 0                   ; check for exit
     je        Return                   ; exit if base == 0
     cmp       eax, 1                   ; If base 2-16
     je        Error1                   ; Else display error
     cmp       eax, 16                  
     ja        Error1
     mov       bl, al                   ; save base for calculation
     
getNum:
     mov       edx, OFFSET prompt2      ; prompt user for integer
     call      WriteString
     call      ReadInteger              ; get integer from user
     cmp       eax, 0                   ; If (eax == 0)
     je        error2                   ; display error
     call      Crlf
     call      DisplayIntegers          ; display base conversions
     jmp       getBase                  ; loop to read another number 

Error1:
     mov       edx, OFFSET eMessage1    ; base entered was not in valid 
     call      Crlf                     ; range
     call      WriteString
     call      Crlf
     jmp       getBase                  ; read a new number

Error2:
     mov       edx, OFFSET eMessage2    ; integer conversion was not
     call      Crlf                     ; valid for base selected
     call      WriteString
     call      Crlf
     jmp       getBase                  ; read a new number

Return:
  
     exit    
main ENDP


;=======================================================================

Binomial PROC

;Binomial Coefficient

;Parameters:

;   AX - n

;   BX - k

;Result:

;   DX - Coefficient

    mov dx,1

 

    cmp bx,0    ;if(k==0)

    je  mex

     

    cmp ax,bx   ;if(n==k)

    je  mex

 

    push    ax

 

    dec ax

    call    BinomialC   ;binomial(n-1,k)

    push    dx



    push    bx

    dec bx

    call    BinomialC   ;binomial(n-1,k-1)

 

    pop bx

 

    mov ax,dx

    pop dx

    add dx,ax

 

    pop ax

 

mex:

    ret
     Binomial ENDP
;=======================================================================






;--------------------------------------------------------------------------
ReadInteger PROC
;
; Reads characters from keyboard one at a time, and only displays
; valid characters for current base. Converts valid characters read
; into an integer value in current base notation. Procedure reads character
; until the user presses the Return Key. 
; Recieves: BL = number base to read
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
; Recieves: DL = Ascii Character
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
; Recieves: DL == Ascii Char
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
DisplayIntegers PROC
;
; Calls WriteInteger procedure to convert number stored as base 10
; into base 2, 8, 10, 16 and displays converted numbers as Ascii character
; Recieves: EAX = number to convert
; Calls:    WriteString, WriteInteger
;--------------------------------------------------------------------------

     push      eax                 ; save result for next conversion
     mov       ebx, 0              ; clear register
     mov       ebx, 2              ; convert to base 2
     mov       edx, OFFSET base2   ; display base number
     call      WriteString         
     call      WriteInteger        ; perform division to get base 2 integer
     pop       eax                 ; retrieve original number
     push      eax                 ; save result for next conversion

     mov       ebx, 0              ; clear register
     mov       ebx, 8              ; convert to base 8
     mov       edx, OFFSET base8   ; display base number
     call      WriteString    
     call      WriteInteger        ; perform division to get base 8 integer
     pop       eax                 ; retrieve original number
     push      eax                 ; save result for next conversion

     mov       ebx, 0              ; clear register
     mov       ebx, 10             ; convert base 10 to Ascii string
     mov       edx, OFFSET base10  ; display base number
     call      WriteString
     call      WriteInteger
     pop       eax                 ; retrieve result for next conversion

     mov       ebx, 0              ; clear register
     mov       ebx, 16             ; convert to base 16
     mov       edx, OFFSET base16  ; display base number
     call      WriteString
     call      WriteInteger        ; perform division to get base 16 integer

     ret
     DisplayIntegers ENDP




;--------------------------------------------------------------------------
WriteInteger PROC
;
; Converts an integer in base 10 into another base using division,
; and displays the converted integer 
; Recieves: EAX = number to convert, BL = base to conver to
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
     call      Crlf

NotValid:
 
 call Crlf    

     ret
     WriteInteger ENDP


;--------------------------------------------------------------------------
DigitToAscii PROC
;
; Reads digits and verifies they are in the range 0-15
; converts valid digits to Ascii values
; Recieves:  AL = digit to convert
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

END main