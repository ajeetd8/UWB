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
        lea             stack,sp 
        lea             disassemble_from,a6     move value of DISASSEMLE_FROM into a6
        * Optional, include welcom message here
* Initial prompt for user to enter data
INITIAL_PROMPT        
        * Prompt user with message for input
        bsr             prompt_user

        * Collects user input and stores value in string variable and length in str_length
        bsr             collect
        
        * Convert string to hex, result in d3 and hex variable
        bsr             str_to_hex
        
        * Bounds checking for valid input
        bsr             check_bounds
        
        * If input error detected branch to initial_prompt
        cmp.b           #$01,d5
        beq             initial_prompt
        
        * Else if address is valid load into a6
        lea             hex,a6

* From here we need to write our disassembly code
LOOP    
        * Read word by words.
        move.w          (a6)+,d5
        addi.l          #1,d4
                       
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
        bne             loop                    Current reading is not odd, continue the loop.
        
        * If the current reading is even, check whether there is more reading or not
        move.l          (a6),d7
        cmp.l           #$FFFFFFFF,d7
        beq             done                    Terminating the program.
        bra             loop

        bsr             done                    Terminating the program

* Instruction for terminating the program
DONE
        * Reprompt for another reading or end program
        bsr             reprompt

        * Collects user input and stores value in string variable and length in str_length
        bsr             collect

        * React to user
        bsr             check_response

        * If input error detected branch to initial_prompt
        cmp.b           #$01,d5
        beq             done
        SIMHALT

* Subroutines - Alphabetical
CLEAR_DATA: * Clears data registers d0-d5
        clr.l           d0
        clr.l           d1
        clr.l           d2
        clr.l           d3
        clr.l           d4
        clr.l           d5
        rts

COLLECT: * Collects user input and stores value in string variable and length in str_length
        move.l          #$00,(a1)
        lea             string,a1
        move.w          #2,d0
        trap            #15
        move.w          d1,str_length
        rts

CHECK_BOUNDS: * Bounds checking for valid input
        * Clear data registers
        bsr             clear_data

        * Branch if str_length is greater than 8
        cmpi.w          #$08,str_length
        bgt             .error_1
        * Move value into memory into register to compare byte only and faster access
        move.l          hex,d2
.IF_LOWER_BOUND        
        * Branch if d2 is less than #$
        cmpi.w          #$04,str_length
        ble             .else_lower_bound
        cmpi.l          #$00005000,d2
        blt             .error_2
        bra             .if_upper_bound
.ELSE_LOWER_BOUND
        * Else compare to word and branch if less than #$
        cmpi.w          #$5000,d2
        blt             .error_2   
.IF_UPPER_BOUND
        * Branch if d2 is less than #$
        cmpi.w          #$04,str_length
        ble             .else_upper_bound
        cmpi.l          #$00007000,d2
        bgt             .error_2
        bra             .end
.ELSE_UPPER_BOUND
        * Else compare to word and branch if less than #$
        cmpi.w          #$7000,d2
        bgt             .error_2
        bra             .end
.ERROR_1 
        * "INVALID INPUT: too long"
        lea             error_1,a1
        move.w          #13,d0
        trap            #15
        bra             .set_flag
.ERROR_2 
        * "INVALID INPUT: not within range"
        lea             error_2,a1
        move.w          #13,d0
        trap            #15
.SET_FLAG        
        move.b          #$01,d5
.END
        rts

CHECK_RESPONSE:
        * Clear data registers
        bsr             clear_data

        * Branch if str_length is greater than 8
        cmpi.w          #$01,str_length
        bgt             .error_1

        * Move value in memory into register to compare byte only and faster acess
        move.b          string,d2

        * Branch to user_input if input is 'y' or 'Y'
        cmpi.b          #$59,d2
        beq             initial_prompt
        cmpi.b          #$79,d2
        beq             initial_prompt

        * Branch to the_end if input is 'n' or 'N'
        cmpi.b          #$4e,d2
        beq             the_end
        cmpi.b          #$6e,d2
        beq             the_end

        * Else branch to .error_2
        bra             .error_2
.ERROR_1 
        * "INVALID INPUT: too long"
        lea             error_1,a1
        move.w          #13,d0
        trap            #15
        bra             .set_flag
.ERROR_2 
        * "INVALID INPUT: not recognized"
        lea             error_3,a1
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

REPROMPT: * Reprompt for another reading or end program
        * "Would you like to disassemble again? (Y/N)"
        lea             prompt_4,a1
        move.w          #13,d0
        trap            #15
        
        * ">"_
        lea             prompt_5,a1
        move.w          #14,d0
        trap            #15
        rts

STR_TO_HEX: * Converts string to hexadecimal stored in variable hex and register d3
        * Clear data registers
        bsr             clear_data

        * For 1 to str_length do the following
        for.w d0 = #1 to str_length do.s
                * Clear d5 to reset flag
                clr             d5

                * Move BYTE from address containing string data into d2
                move.b          (a1)+,d2

                * If BYTE in d2 is greater than #$60 then subtract #$57
                if.b d2 <GT> #$60 then.s
                        subi.b          #$57,d2
                        move.b          #$01,d5
                endi

                * Branch if already subtracted
                cmpi.b          #$01,d5
                beq             skip_subi

                * If BYTE in d2 is greater than #$40 then subtract #$37
                if.b d2 <GT> #$40 then.s
                        subi.b          #$37,d2
                endi

                * If BYTE in d2 is less than #$40 then subract #$30
                if.b d2 <LT> #$40 then.s
                        subi.b          #$30,d2
                endi
SKIP_SUBI
                * Add BYTE to d3 and lsl, skip lsl when str_length and d0 are equal     
                add.b           d2,d3
                cmp.w           str_length,d0
                beq             .skip_shift
                lsl.l           #$04,d3
.SKIP_SHIFT
        endf
        move.l          d3,hex                  Move LONG data from d3 into variable hex
        rts

* Constants - Alphabetical
ERROR_1                 dc.b    'INVALID INPUT: too long',0
ERROR_2                 dc.b    'INVALID INPUT: not within range',0
ERROR_3                 dc.b    'INVALID INPUT: not recognized',0
NEW_LINE                dc.b    ' ',0,CR,LF
PROMPT_1                dc.b    'Enter starting address. Range=[,]',0
PROMPT_2                dc.b    '$',0
PROMPT_3                dc.b    'Press ENTER to continue...',0
PROMPT_4                dc.b    'Would you like to disassemble again? (Y/N)',0
PROMPT_5                dc.b    '>',0

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
THE_END
        END         start

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
