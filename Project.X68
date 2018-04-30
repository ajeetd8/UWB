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
        bsr             collect
        * Convert string to hex, result in d3 and hex variable
        bsr             str_to_hex
        * Bounds checking here

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
        
        * If the current reading is even, check whether there is more reading or not
        move.l          (a6),d7
        cmp.l           #$FFFFFFFF,d7
        beq             DONE                    Terminating the program.
        bra             LOOP

        bsr             DONE                    Terminating the program
*Instruction for terminating the program
DONE
        SIMHALT

* Subroutines - Alphabetical
COLLECT: * Collects string from console, stores value in string and length in str_length
        lea             string,a1
        move.w          #2,d0
        trap            #15
        move.l          d1,str_length
        rts

FREE_REG: * Empties registers a0-a5 and d0-d7 and puts them on the stack
        *movem.l a0-a5/d0-d7,-(sp)
        rts

REPL_REG: * Retrieves memory to replace the registers a0-a5 and d0-d7 with their old data
        *movem.l a0-a5/d0-d7,(sp)+
        rts

STR_TO_HEX: * Converts string to hexadecimal stored in variable hex and register d3
        clr     d0
        for.b d0 = #1 to d1 do.s                For 0 to str_length do:
                move.b  (a1)+,d2                Move BYTE from data at a1 into d2 then increment
                if.b d2 <LT> #$40 then.s        If BYTE data in d2 is LT #$40 then:
                        sub.b   #$30,d2         Subtract #$30 from BYTE data in d2
                endi
                if.b d2 <GT> #$40 then.s        If BYTE data in d2 is GT #$40 then:
                        sub.b   #$37,d2         Subtract #$37 from BYTE data in d2
                endi
                add.b   d2,d3                   Add BYTE data in d2 to d3
                cmp.b   d0,d1                   Compare BYTE data at d1 to d0
                beq     .skip_last              Branch if d0 = d1 
                lsl.l   #$04,d3                 Else logical shift left 4 bytes in d3
.SKIP_LAST
        endf
        move.l  d3,hex                          Move LONG data from d3 into variable hex
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
HEX                     ds.l    1
STRING                  ds.b    8
STR_LENGTH              ds.w    1

**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        move.w      d0,d1
        END         start

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
