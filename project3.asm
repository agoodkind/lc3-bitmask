; Alexander Goodkind 
; 11/12/17
; CSC-240
; Professor Dr. Mink
;
; This program counts the number of 1s in the value stored in R0 and stores the result in R1. 
; For example, if R0 contains 0001001101110000 (x1370), then after the program executes, 
; the value stored in R1 would be 0000000000000110 (decimal 6). 
; this program also solicits a 2-digit input from the user that is used for the binary 1 count
;

.ORIG x3000

	; zero out registers that we will be using
	AND R0, R0, #0 	; r0 will be what holds the value
	AND R1, R1, #0 	; the result
	AND R2, R2, #0 	; acts as a counter
	AND R3, R3, #0 	; pointer to the bitmask array
	AND R4, R4, #0 	; stores the temporary bit that will be compared to r0
	AND R5, R5, #0 	; helps store the bitmask length
	AND R6, R6, #0 	; counter for multiplication

	JSR getInput 	; subroutine to get the input

	LD R5, CounterLength ; load the counter length since its bigger than 15 we have to use LD
	ADD R2, R2, R5	; set out counter, limited because of imm5
 
	LEA R3, BitMask	; load the bitmask array start
	LDR R4, R3, #0	; load the initial bitmask array value

; the loop
MskLoop AND R4, R0, R4	; compare the mask

	BRz NxtLoop	; goto the next iteration if we dont get a bitmask
	ADD R1, R1, #1	; only increment the result if we have a positive bitmask

NxtLoop	ADD R3, R3, #1	; increment array position
	LDR R4, R3, #0	; load the next array value
	ADD R2, R2, #-1	; decrement counter
	BRp MskLoop

; end of program
Done	HALT


; sub routine to get input from user
getInput

	ST R0, tempR0
	ST R1, tempR1
	ST R2, tempR2
	ST R3, tempR3
	ST R4, tempR4
	ST R7, tempR7

	; prompt the user
	LEA R0, userPrompt
	PUTS

	; input two numbers

	GETC	; input an integer character (this is the 10s place)
	PUTC	; echo
	ST R0, inputValue1 ; store the integer

	GETC	; input an integer character (this is the 1s place)
	PUTC	; echo
	ST R0, inputValue2 ; store the integer
	
	; print a new line
	LD R0, newLine
	PUTC

	LD R0, inputValue1	; load the int into a register
	LD R1, inputValue2	; load the int into a register
	LD R2, asciiHex   	; load the ascii offset

	ADD R0, R0, R2		; convert both to decimal
	ADD R1, R1, R2
	ADD R4, R4, R0 		; copy r0 to r4


	;PUTC

	ADD R3, R3, #9 ; counter for multiply
	
	; multiplication logic
	MULTIPLY: 
  		ADD R0, R0, R4 ; add to sum (turning r0 into 10s place)
  		ADD R3, R3, #-1 ; decrement our counter 
	BRp MULTIPLY

	ADD R0, R1, R0 		; get our final answer

	; return all of our old values before we RET
	; we don't clear r0 because that's what we are looking through

	LD R1, tempR1
	LD R2, tempR2
	LD R3, tempR3
	LD R4, tempR4
	LD R7, tempR7

RET

; the counterlength
CounterLength .Fill #16

; the bitmask array
BitMask	.FILL   b1000000000000000
        .FILL   b0100000000000000
        .FILL   b0010000000000000
        .FILL   b0001000000000000
        .FILL   b0000100000000000
        .FILL   b0000010000000000
        .FILL   b0000001000000000
        .FILL   b0000000100000000
        .FILL   b0000000010000000
        .FILL   b0000000001000000
        .FILL   b0000000000100000
        .FILL   b0000000000010000
        .FILL   b0000000000001000
        .FILL   b0000000000000100
        .FILL   b0000000000000010
        .FILL   b0000000000000001

; the user prompt
userPrompt 	.STRINGZ "Please type a two digit number: "
newLine		.fill xA

; our input variables
inputValue1 	.fill x0
inputValue2 	.fill x0
inputEnd 	.fill x0
asciiHex 	.fill #-48

tempR0 .fill x0
tempR1 .fill x0
tempR2 .fill x0
tempR3 .fill x0
tempR4 .fill x0
tempR7 .fill x0

.END