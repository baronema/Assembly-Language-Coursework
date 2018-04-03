TITLE Combination Lock (Barone-Assn4-Program.asm)
; This program accepts and validates simulated button presses
; input from user, integer values 1-4, in order
; to simulate a combination lock. Buttons pressed
; in the correct sequence will open the lock

INCLUDE Irvine32.inc

.data
stateCond BYTE "The lock 2s count = ", 0
buttonPrompt BYTE "Please press a button (1,2, 3, or 4): ", 0
finalState BYTE "the lock is open!", 0

.code

main PROC
; Main program control procedure.
; Button (1) will decrement state
; (2) will increment x1, (3) opens lock in second state only,
; otherwise sets state to zero, 4 will increment x2
; Calls: GetButtonPress, DisplayMessage
 
        
State0:
     mov       al, 0               ;set state to 0
     call      DisplayMessage      ;display current state
     call      GetButtonPress      ;prompt user input
     cmp       al, 2               ;user selected increment 
     je        State1   
     cmp       al, 4               ;user selected increment x2
     je        State2
     jmp       State0              ;user pressed 1 or 3

State1:
     mov       al, 1               ;set state to 1
     call      DisplayMessage      ;display current state
     call      GetButtonPress      ;prompt user input
     cmp       al, 2               ;user selected increment
     je        State2   
     cmp       al, 4               ;user selected increment x2
     je        State3
     jmp       State0              ;user pressed 1 or 3

State2:
     mov       al, 2               ;set state to 2
     call      DisplayMessage      ;display current state
     call      GetButtonPress      ;prompt user input
     cmp       al, 1               ;user selected decrement
     je        State1   
     cmp       al, 3               ;user opened lock
     je        Final
     jmp       State3              ;user pressed 2 or 4

State3:
     mov       al, 3               ;set state to 3
     call      DisplayMessage      ;display current state
     call      GetButtonPress      ;prompt user input
     cmp       al, 1               ;user selected decrement
     je        State2   
     cmp       al, 3               ;user selected open
     je        State0              
     jmp       State3              ;tried to increment max state

Final:   
     mov       edx, OFFSET finalState   ;display lock open
     call      WriteString 
     call      Crlf
     call      Crlf
  
     exit    
main ENDP

;--------------------------------------------------------------------------
GetButtonPress PROC
;
; Prompts user to enter integer, and validates integer is between 1-4
; Continues to wait for valid integer until one is entered
; Returns: AL = 
;--------------------------------------------------------------------------

     mov       edx, OFFSET buttonPrompt  ;display state condition prompt
     call      WriteString 
     
ValidInt:
     call      ReadChar                 ;read button press
     cmp       al, '4'                  ;valid selection must-
     jg        ValidInt                 ;be a choice between-
     cmp       al, '0'                  ;1 and 4
     jl        ValidInt                 ;read new char if not valid
     call      WriteChar                ;display valid choice
     call      Crlf      
     sub       al, 48                   ;set char value to decimal

     ret
     GetButtonPress ENDP

;--------------------------------------------------------------------------
DisplayMessage PROC
;
; Displays a message about the state of the combination lock
; Receives: AL = current state
;--------------------------------------------------------------------------
     
     
     mov       edx, OFFSET stateCond    ;display state condition prompt
     call      WriteString  
     push      ax                       ;save current state
     add       al, 48                   ;convert to ascii value
     call      WriteChar                ;display current state
     pop       ax                       ;restore current state in decimal
     call      Crlf

     ret
     DisplayMessage ENDP

END main
