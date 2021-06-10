ORG 40H
N1: DB "23" ;40H=0x32H, 41H=0x33H
DB 0
N2: DB "58" ;43H=0x35H, 44H=0x38H
DB 0
; N1: DB "143" ;40H=0x31H, 41H=0x34H, 42H=0x33H
; DB 0
; N2: DB "234" ;44H=0x32H, 45H=0x33H, 46H=0x34H
; DB 0

; This is the beginning of the main program
ORG 0H
MOV 50H, #100 ;Factor for highest order digit
MOV 51H, #10 ;Factor for the middle digit
MOV 52H, #1 ;Factor for lowest order digit
MOV R0, #52H ;Use R0 to keep track of the factors
MOV R1, #5FH ;Use R1 to keep the location where the decimal version of N1 and N2 will be stored
MOV R3, #02H ;Use R3 to determine when both N1 and N2 are finished converted to decimal

; This section converts string N1 to a decimal number
MOV DPTR, #N1 ; Load data address into DPTR
ST: INC R1 ;
; This section finds the # of digits in N1
L1: INC R2 ; Use R2 to keep track of the number of digits
INC DPL ; Move DPTR to the next position
CLR A
MOVC A, @A+DPTR
CJNE A, #0H, L1 ; Repeat until the last digit
DEC DPL ; Move DPTR to the lowest order digit of N1
RPT1: CLR A ; Clear the accumulator for the next digit
MOVC A, @A+DPTR ;Move the digit into A
SUBB A, #30H
MOV B, @R0 ;Move the factor into B
MUL AB ;Multiply the digit by the factor
ADD A, @R1 ;Sum the current digit and the result of the previous digit
MOV @R1, A ;Save the result in location indicated by R1
DEC DPL ;Move DPTR to the next digit
DEC R0 ;Move R0 to the next factor
DJNZ R2, RPT1 ;Repeat until all digits are calculated

; This section converts string N2 to a decimal number
MOV DPTR, #N2
MOV R0, #52H
DJNZ R3, ST ;When both N1 and N2 finishes conversion move to calculation

Cal: MOV A, @R1 ;Copy the first number into A
DEC R1 ;Move R1 to the second number
MOV B, @R1 ;Copy the second number into B
MUL AB ;Multiply AB to get the result
MOV 40H, B ;Store the upper bits into 40H
MOV 41H, A ;Store the lower bits into 41H

HERE: SJMP HERE

END ;End of Code
