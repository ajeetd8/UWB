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
        * Collects user input from console
ASK     bsr             prompt_user

        * Collects string and stores value in string and length in str_length
        bsr             collect
        
        * Convert string to hex, result in d3 and hex variable
        bsr             str_to_hex
        
        * Bounds checking
        bsr             check_bounds
        
        * If input error detected
        if.b d5 <EQ> #$01 then.s                
                bra     ask
        endi
        * Else address is valid        
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
CLEAR_D: * Clears data registers d0-d5
        clr.l           d0
        clr.l           d1
        clr.l           d2
        clr.l           d3
        clr.l           d4
        clr.l           d5
        rts

COLLECT: * Collects string and stores value in string and length in str_length
        lea             string,a1
        move.w          #2,d0
        trap            #15
        move.w          d1,str_length
        rts

CHECK_BOUNDS:
        * Branch if str_length is greater than 8
        cmp.w           #$08,str_length
        bgt             .error_1

        * Branch if hex is less than #$
.if1    cmp.w           #$04,str_length
        ble             .else1
        cmp.l           #$00005000,hex
        blt             .error_2
        bra             .if2
.ELSE1
        cmp.l           #$5000,hex
        blt             .error_2
        
        * Branch if hex is less than #$
.if2    cmp.w           #$04,str_length
        ble             .else2
        cmp.l           #$00007000,hex
        bgt             .error_2
        bra             .end
.ELSE2  
        cmp.l           #$7000,hex
        bgt             .error_2
        bra             .end

.ERROR_1 * "INVALID INPUT: too long, try again"
        lea             error_1,a1
        move.w          #13,d0
        trap            #15
        bra             .set_flag

.ERROR_2 * "INVALID INPUT: not within range"
        lea             error_2,a1
        move.w          #13,d0
        trap            #15

.SET_FLAG        
        move.b          #$01,d5

.END
        rts

FREE_REG: * Empties registers a0-a5 and d0-d7 and puts them on the stack
        * Move all data onto stack
        *movem.l a0-a5/d0-d7,-(sp)
        rts

PROMPT_USER: * Collects user input from console
        * "Enter starting address with all letters. Range=[,]"
        lea             prompt_1,a1
        move.w          #13,d0
        trap            #15  
        
        * "$"_
        lea             prompt_2,a1
        move.w          #14,d0
        trap            #15
        rts

REPL_REG: * Retrieves memory to replace the registers a0-a5 and d0-d7 with their old data
        * Put all data back into registers
        *movem.l a0-a5/d0-d7,(sp)+
        rts

STR_TO_HEX: * Converts string to hexadecimal stored in variable hex and register d3
        clr     d0
        for.b d0 = #1 to d1 do.s                For 0 to str_length do:
                move.b          (a1)+,d2        Move BYTE from data at a1 into d2 then increment
                if.b d2 <LT> #$40 then.s        If BYTE data in d2 is LT #$40 then:
                        sub.b           #$30,d2 Subtract #$30 from BYTE data in d2
                endi
                if.b d2 <GT> #$40 then.s        If BYTE data in d2 is GT #$40 then:
                        sub.b           #$37,d2 Subtract #$37 from BYTE data in d2
                endi
                add.b           d2,d3           Add BYTE data in d2 to d3
                cmp.b           d0,d1           Compare BYTE data at d1 to d0
                beq             .skip_last      Branch if d0 = d1 
                lsl.l           #$04,d3         Else logical shift left 4 bytes in d3
.SKIP_LAST
        endf
        move.l          d3,hex                  Move LONG data from d3 into variable hex
        bsr             clear_d                   Clear data registers
        rts

* Constants - Alphabetical
ERROR_1                 dc.b    'INVALID INPUT: too long',0
ERROR_2                 dc.b    'INVALID INPUT: not within range',0
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
