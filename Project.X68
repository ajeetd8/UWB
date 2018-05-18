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
DISASSEMBLE_FROM        equ         $6000
CR                      equ         $0d
LF                      equ         $0a  

START:  org             $1000
        * Setting the stack address.
        lea             stack,sp 
        lea             disassemble_from,a6     move value of DISASSEMLE_FROM into a6
        * Optional, include welcom message here
* Prompt for user to enter data        
PROMPT_START
        * Prompt user with message start address
        bsr             prompt_start_address
        * Collect user input and store value in string and length in str_length
        bsr             collect     
        * Convert string to hex and store result in swap_hex variable
        bsr             str_to_hex  
        * Bounds checking for valid start address
        bsr             check_start_bounds     
        * If input error detected branch to prompt_start
        cmp.b           #$01,d5
        beq             prompt_start
PROMPT_END
        * Prompt user with message for end address
        bsr             prompt_end_address
        * Collect user input and store value in string and length in str_length
        bsr             collect
        * Convert string to hex and store result in swap_hex variable
        bsr             str_to_hex
        * Bounds checking for valid end address
        bsr             check_end_bounds
        * If input error detected branch to prompt_end
        cmp.b           #$01,d5
        beq             prompt_end
        * Else if address is valid load into a6 
        lea             start_hex,a0
        move.l          (a0),a6
        * Clear data registers
        bsr             clear_data

* From here we need to write our disassembly code
LOOP    
        * When counter is 20 branch to pause
        if.b d4 <EQ> #20 then.s
                bsr             pause
        endi
        * Counter
        addi.b          #$01,d4
        * Read word by word.
        move.w          (a6)+,d5 

* Instruction for terminating the program
DONE
        * Reprompt for another reading or end program
        bsr             reprompt
        * Collects user input and stores value in string variable and length in str_length
        bsr             collect
        * React to user
        bsr             check_response     
        * If flag at three branch to the_end
        cmp.b           #$03,d5
        beq             the_end
        * If flag at two branch to prompt_start
        cmp.b           #$02,d5
        beq             prompt_start
        * If flag detected branch to done
        cmp.b           #$01,d5
        beq             done

CHECK_BOUNDS: * Checks bounds of user input stored in swap_hex variable.
* Clear data registers
        bsr             clear_data
        * Branch if str_length is greater than 8
        cmpi.w          #$08,str_length
        bgt             cb_error_1
        * Move value into memory into register to compare byte only and faster access
        move.l          swap_hex,d2
CB_IF_LOWER_BOUND
        * Branch if d2 is less than #$
        cmpi.w          #$04,str_length
        ble             cb_else_lower_bound
        cmpi.l          #$00005000,d2
        blt             cb_error_2
        bra             cb_if_upper_bound
CB_ELSE_LOWER_BOUND
        * Else compare to word and branch if less than #$
        cmpi.w          #$5000,d2
        blt             cb_error_2   
CB_IF_UPPER_BOUND
        * Branch if d2 is less than #$
        cmpi.w          #$04,str_length
        ble             cb_else_upper_bound
        cmpi.l          #$00007000,d2
        bgt             cb_error_2
        bra             cb_end
CB_ELSE_UPPER_BOUND
        * Else compare to word and branch if less than #$
        cmpi.w          #$7000,d2
        bgt             cb_error_2
        bra             cb_end
CB_ERROR_1 
        * "INVALID INPUT: too long"
        lea             error_1,a1
        move.w          #13,d0
        trap            #15
        bra             cb_set_flag
CB_ERROR_2 
        * "INVALID INPUT: not within range"
        lea             error_2,a1
        move.w          #13,d0
        trap            #15
CB_SET_FLAG        
        move.b          #$01,d5
CB_END
        rts

CHECK_END_BOUNDS: * Bounds checking for end address range
        * Check general bounds
        bsr             check_bounds
        * Check for invalid input
        cmp.b           #$01,d5
        beq             ceb_end
        * If no error with swap_hex
        lea             swap_hex,a0
        move.l        (a0),end_hex
        * Then check that start < end
        move.l          (a0),d1
        move.l          start_hex,d0
        if.l d1 <LE> d0 then.s
                move.b #$01,d5
                lea             error_4,a1
                move.w          #13,d0
                trap            #15
        endi
CEB_END       
        rts

CHECK_START_BOUNDS: * Bounds checking for start address range
        * Check general bounds
        bsr             check_bounds
        * Check for invalid input
        cmp.b           #$01,d5
        beq             csb_end
        * If no error with swap_hex
        lea             swap_hex,a0
        move.l          (a0),start_hex
CSB_END     
        rts

CHECK_RESPONSE: * Checks response to user reprompt
        * Clear data registers
        bsr             clear_data
        * Branch if str_length is greater than 8
        cmpi.w          #$01,str_length
        bgt             cr_error_1
        * Move value in memory into register to compare byte only and faster acess
        move.b          string,d2
        * Branch to the_end if input is 'n' or 'N'
        if.b d2 <EQ> #$4e or.b d2 <EQ> #$6e then.s
                * Set d5 to 3 and end
                move.b          #$03,d5
                bra             cr_end
        endi
        * Branch to user_input if input is 'y' or 'Y'
        if.b d2 <EQ> #$59 or.b d2 <EQ> #$79 then.s
                * Set d5 to 2 and end
                move.b          #$02,d5
                bra             cr_end
        endi
        * Else branch to .error_2
        bra             cr_error_2
CR_ERROR_1 
        * "INVALID INPUT: too long"
        lea             error_1,a1
        move.w          #13,d0
        trap            #15
        bra             cr_set_flag
CR_ERROR_2 
        * "INVALID INPUT: not recognized"
        lea             error_3,a1
        move.w          #13,d0
        trap            #15
CR_SET_FLAG        
        move.b          #$01,d5
CR_END        
        rts

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
        * Load address of string into a1
        lea             string,a1   
        * Clear long value at a1
        move.l          #$00,(a1)
        * Collect console input
        move.w          #2,d0
        trap            #15
        move.w          d1,str_length
        rts

PAUSE:
        * Reset counter to 0
        clr             d4
        lea             prompt_6,a1
        move.w          #13,d0
        trap            #15
        * Collect enter
        bsr             collect
        rts

PROMPT_END_ADDRESS: * Collects end address from console
        * "Enter ending address with all letters. Range=[,]"
        lea             prompt_7,a1
        move.w          #13,d0
        trap            #15   
        * "$"_
        lea             prompt_2,a1
        move.w          #14,d0
        trap            #15
        rts

PROMPT_START_ADDRESS: * Collects start address from console
        * "Enter starting address with all letters. Range=[,]"
        lea             prompt_1,a1
        move.w          #13,d0
        trap            #15   
        * "$"_
        lea             prompt_2,a1
        move.w          #14,d0
        trap            #15
        rts

REPROMPT: * Reprompt for another reading or ending of program
        * "Would you like to disassemble again? (Y/N)"
        lea             prompt_4,a1
        move.w          #13,d0
        trap            #15     
        * ">"_
        lea             prompt_5,a1
        move.w          #14,d0
        trap            #15
        rts

STR_TO_HEX: * Converts string to hexadecimal
        * Clear data registers
        lea             string,a1
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
                beq             sth_skip_subi
                * If BYTE in d2 is less than #$40 then subtract #$30
                if.b d2 <LT> #$40 then.s
                        subi.b          #$30,d2
                endi
                * If BYTE in d2 is greater than #$40 then subtract #$37
                if.b d2 <GT> #$40 then.s
                        subi.b          #$37,d2
                endi
STH_SKIP_SUBI
                * Add BYTE to d3 and lsl
                add.b           d2,d3
                *  skip lsl when str_length and d0 are equal
                cmp.w           str_length,d0
                beq             sth_skip_shift
                lsl.l           #$04,d3
STH_SKIP_SHIFT
        endf
        * Move LONG data from d3 into variable swap_hex
        move.l          d3,swap_hex                  
        rts

* Constants - Alphabetical
ERROR_1                 dc.b    'INVALID INPUT: too long',0
ERROR_2                 dc.b    'INVALID INPUT: not within range',0
ERROR_3                 dc.b    'INVALID INPUT: not recognized',0
ERROR_4                 dc.b    'INVALID INPUT: less than start address',0
NEW_LINE                dc.b    ' ',0,CR,LF
PROMPT_1                dc.b    'Enter starting address. Range=[,]',0
PROMPT_2                dc.b    '$',0
PROMPT_3                dc.b    'Press ENTER to continue...',0
PROMPT_4                dc.b    'Would you like to disassemble again? (Y/N)',0
PROMPT_5                dc.b    '>',0
PROMPT_6                dc.b    'Press ENTER to continue...',0
PROMPT_7                dc.b    'Enter ending address. Range=[,]',0

* Variables - Alphabetical
END_HEX                 ds.l    1
FLAG                    ds.b    1
START_HEX               ds.l    1
STRING                  ds.b    8
SWAP_HEX                ds.l    1
STR_LENGTH              ds.w    1

********************************************************************************
        * From here, the code we are going to disassemble.
********************************************************************************

THE_END
        END         start

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
