*-----------------------------------------------------------
* Title      :  Project.x68
* Written by :  Byunggeun Park, Erik J. Maldonado, Haram Kwon
* Date       :  April.23.2018 ~ May..2018
* Description:  CSS 422 Group Project
*               1. The prgram start at 1000.
*               2. The program start to read memory from $7000 and disassemble.
*               3. The program will print out to console the disassembled output.
*-----------------------------------------------------------

STACK                   equ         $100000
DISASSEMBLE_FROM        equ         $7000
CR                      equ         $0d
LF                      equ         $0a  

START:  org             $1000
        * Setting the stack address.
        lea             STACK,sp 
        lea             DISASSEMBLE_FROM,a6     move value of DISASSEMLE_FROM
        * Optional, include welcom message here

* Prompt
USER_INTERFACE         
        * "Enter starting address with all letters. Range=[,]"
        lea             prompt_1,a1
        move.w          #13,d0
        trap            #15  
        * "$"_
        lea             prompt_2,a1
        move.w          #14,d0
        trap            #15
        * Collect string
        lea             string,a1
        move.w          #2,d0
        trap            #15
        * Convert string to hex
        * bsr             str_to_hex
        * Move address into desassemble_from
        * lea             a2,disassemble_from

* From here, he need to write our disassembly code
LOOP    
        * Read word by words.
        move.w          (a6)+,d5
        addi.l         #1,d4
                       
        * Every loop is incrementing by word
        * We have to find pattern bit by bits, and
        * Do additional bit increment here (a6)
        
        * Console out each loop.
        
        **************************************************************************************************
        * Terminal Condition
        **************************************************************************************************
        
        * Check whether current reading is odd or not
        move.l          a6,d6
        divu            #$02,d6
        swap            d6
        cmp.b           #$00,d6
        bne             LOOP                    Current reading is not odd, continue the loop.
        
        * If the current reading is odd, check whether there is more reading or not
        move.l          (a6),d7
        cmp.l           #$FFFFFFFF,d7
        beq             DONE                    Terminating the program.
        bra             LOOP

        bsr             DONE                    Terminating the program
*Instruction for terminating the program
DONE
        SIMHALT

* Subroutines - Alphabetical
STR_TO_HEX: * Converts string in a1 to hexadecimal and stores it in 
        rts

FREE_REG: * Empties registers a0-a5 and d0-d7 and puts them on the stack
        *movem.l a0-a5/d0-d7,-(sp)
        rts

REPL_REG: * Retrieves memory to replace the registers a0-a5 and d0-d7 with their old data
        *movem.l a0-a5/d0-d7,(sp)+
        rts

* Constants - Alphabetical
ERROR_1                 dc.b    'INVALID INPUT, try again',0,LF,CR
NEW_LINE                dc.b    ' ',0,CR,LF
PROMPT_1                dc.b    'Enter starting address with all letters in capital. Range=[,]',0
PROMPT_2                dc.b    '$',0
PROMPT_3                dc.b    'Press ENTER to continue...',0,CR,LF
PROMPT_4                dc.b    'Would you like to disassemble again? (Y/N)',0,CR,LF
PROMPT_5                dc.b    '>',0,CR,LF


* Variables - Alphabetical
ADDRESS                 ds.b    8
HEX                     ds.b    80
OPCODE                  ds.b    8
STRING                  ds.b    8

**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        MOVE.W      D0,D1

        END         START




*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
