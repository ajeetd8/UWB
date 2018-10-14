*-----------------------------------------------------------
* Title      : Final submission file. (Main executable)
* Written by : Haram, Byeonggeun, Erik
* Date       : June 2 2018
* Description: The code will disassemble from loaded memory
*-----------------------------------------------------------

START:  org             $1000
                * Setting the stack address.
                lea             STACK,sp 
                lea             DISASSEMBLE_FROM,a6     move value of DISASSEMLE_FROM

* Prompt for user to enter data        
PROMPT_START
        * Prompt user with message start address
        bsr             PROMPT_START_ADDRESS
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

        bra             MAIN_LOOP


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
        cmpi.l          #LOWER_BOUND,d2
        blo             cb_error_2
        bra             cb_if_upper_bound
CB_ELSE_LOWER_BOUND
        * Else compare to word and branch if less than #$
        cmpi.w          #LOWER_BOUND,d2
        blo             cb_error_2   
CB_IF_UPPER_BOUND
        * Branch if d2 is less than #$
        cmpi.w          #$04,str_length
        blo             cb_else_upper_bound
        cmpi.l          #UPPER_BOUND,d2
        bhi             cb_error_2
        bra             cb_end
CB_ELSE_UPPER_BOUND
        * Else compare to word and branch if less than #$
        *cmpi.w          #$7000,d2
        *bgt             cb_error_2
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
        beq             EXIT_PROGRAM
        * If flag at two branch to prompt_start
        cmp.b           #$02,d5
        beq             prompt_start
        * If flag detected branch to done
        cmp.b           #$01,d5
        beq             done

* From here, he need to write our disassembly code
*****************************************************************************************
* Loop 20 times, and get the user enter.
        move.b          #$00,MAIN_LOOP_COUNT
* Iteration loop start from here
MAIN_LOOP
        * Clear three bit instructions
        bsr             CLEAR_ALL_BIT_S

        * Check for the terminal Condition.
        move.l          a6,d7
        cmp.l           END_HEX,d7           Terminal condition check (It will be changed later)
        bhi             DONE            Terminating the program.


        * Check cycle(20) condition.
        cmp.b           #20,MAIN_LOOP_COUNT
        bge             HALT

        ** Add 1 to the cycle
        move.b          MAIN_LOOP_COUNT,d7
        addi.b          #1,d7
        move.b          d7,MAIN_LOOP_COUNT

        * Show current pc
        bsr             ADDRESS_OUT

        * Load initial instruction
        move.w          (a6)+,INITIAL_INSTRUCTION

        * Save Initial instruction to d7 register
        *move.w          INITIAL_INSTRUCTION,d7
        
        *-------------------
        * case 1 addi, subi
        cmp.b           #$10,INITIAL_INSTRUCTION
        blo             MC_ADDI_SUBI

        * case 2 move.b
        cmp.b           #$20,INITIAL_INSTRUCTION
        blo             MC_MOVE_B

        * case 3 move.l, movea.l
        cmp.b           #$30,INITIAL_INSTRUCTION
        blo             MC_MOVE_L_MOVEA_L

        * case 4 move.w, movea.w
        cmp.b           #$40,INITIAL_INSTRUCTION
        blo             MC_MOVE_W_MOVEA_W

        * case 5 clr, nop, rts, jsr, movem, lea
        cmp.b           #$50,INITIAL_INSTRUCTION
        blo             MC_CLR_LEA

        * case 6 addq      
        cmp.b           #$60,INITIAL_INSTRUCTION
        blo             MC_ADDQ

        * case 7 bcc, bgt, ble
        cmp.b           #$70,INITIAL_INSTRUCTION
        blo             MC_BCGL

        * case 8 moveq
        cmp.b           #$80,INITIAL_INSTRUCTION
        blo             MC_MOVEQ

        * case 9 or, divu
        cmp.b           #$90,INITIAL_INSTRUCTION
        blo             MC_OR_DIVU

        * case 10 sub
        cmp.b           #$a0,INITIAL_INSTRUCTION
        blo             MC_SUB

        * Invalid input, show message
        cmp.b          #$b0,INITIAL_INSTRUCTION
        blo             INVALID_S             

        * case 11 cmp
        cmp.b           #$c0,INITIAL_INSTRUCTION
        blo             MC_CMP
        
        * case 12 and, muls, mulu
        cmp.b           #$d0,INITIAL_INSTRUCTION
        blo             MC_AND_MULU

        * case 13 add, adda
        cmp.b           #$e0,INITIAL_INSTRUCTION
        blo             MC_ADD_ADDA

        * case 14 asr, asl, lsr, lsl, ror, rol
        cmp.b           #$f0,INITIAL_INSTRUCTION
        blo             MC_ASR_ROL
        
        bra             INVALID_S
        
        bra             MAIN_LOOP

* Iteration end here
*******************************************************************************************


*******************************************************************************************
* Halting the simulator
HALT
        move.b          #$00,MAIN_LOOP_COUNT         Clear the Loop count
        
        * Getting the 'Enter' Key from the user
        * Once you get the enter, clear the screen
        * go back to the routine

        bsr             PRESS_ENTER_S
        bsr             WAIT_ENTER

        bsr             CLEAR_SCREEN
        bra             MAIN_LOOP

* ----------------------------------
WAIT_ENTER
        move.b          #5,d0
        trap            #15


        
        cmp.b           #$0d,d1
        bne             WAIT_ENTER
        rts
* ----------------------------------
*******************************************************************************************


*******************************************************************************************
* Mnemonic disassmbly start here

* Addi Subi
MC_ADDI_SUBI
MAS_SUBI
        cmp.b           #4,INITIAL_INSTRUCTION
        bne             MAS_ADDI

        bsr             INITIAL_TWO_EA_LOAD_SIZE
        bsr             SIZE_CONVERT_TYPE_ONE
        bsr             MC_ADDI_SUBI_INST_CONVERTOR
        bsr             ADDRESS_READ_DECISION_LOAD
        
        bsr             IS_VALID
        bsr             TAB
        bsr             SUBI_S
        bra             MAS_OPERAND
MAS_ADDI
        cmp.b           #6,INITIAL_INSTRUCTION
        bne             MAS_INVALID
        
        bsr             INITIAL_TWO_EA_LOAD_SIZE
        bsr             SIZE_CONVERT_TYPE_ONE
        bsr             MC_ADDI_SUBI_INST_CONVERTOR
        bsr             ADDRESS_READ_DECISION_LOAD

        bsr             IS_VALID
        bsr             TAB
        bsr             ADDI_S
        bra             MAS_OPERAND
MAS_INVALID
        bra             INVALID_S
MAS_OPERAND
        bsr             SIZE_TAG_S
        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE
        bra             MAIN_LOOP

MC_ADDI_SUBI_INST_CONVERTOR
        * It will convert addi instruction to have similar property with move function, so that
        * I can invoke the existing function such as
        * ADDRESS_READ_DECISION_LOAD
        * INITIAL_FOUR_EA_LOAD_OUT

        move.b          SRC_MODE,DEST_MODE
        move.b          SRC_REGISTER,DEST_REGISTER
        move.b          #7,SRC_MODE
        move.b          #4,SRC_REGISTER

        rts

*Mnemonic: move.b
MC_MOVE_B
        bsr             SIZE_BYTE
        bsr             INITIAL_FOUR_EA_LOAD
        bsr             ADDRESS_READ_DECISION_LOAD

        bsr             IS_VALID
        bsr             TAB
        bsr             MOVE_S                Print out the instruction.
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: move.l, movea.l
MC_MOVE_L_MOVEA_L
        bsr             SIZE_LONG
        bsr             INITIAL_FOUR_EA_LOAD
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID
        bsr             TAB

MMLML_MOVEA_OUT
        cmp.b           #1,DEST_MODE
        bne             MMLML_MOVE_OUT
        bsr             MOVEA_S
        bra             MMLML_MOVE_OPERAND
MMLML_MOVE_OUT
        bsr             MOVE_S
        bra             MMLML_MOVE_OPERAND
MMLML_MOVE_OPERAND
        bsr             SIZE_TAG_S
        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP


* Mnemonic: move.w
MC_MOVE_W_MOVEA_W
        bsr             SIZE_WORD
        bsr             INITIAL_FOUR_EA_LOAD
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID
        bsr             TAB

MMLMW_MOVEA_OUT
        cmp.b           #1,DEST_MODE
        bne             MMLMW_MOVE_OUT
        bsr             MOVEA_S
        bra             MMLMW_MOVE_OPERAND
MMLMW_MOVE_OUT
        bsr             MOVE_S
MMLMW_MOVE_OPERAND
        bsr             SIZE_TAG_S
        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP        

* Mnemonic: clr, nop, rts, jsr, movem, lea
MC_CLR_LEA
MCL_NOP
        * Check for 'NOP' instruction.
        cmp.w           #$4e71,INITIAL_INSTRUCTION
        bne             MCL_RTS
        bsr             TAB
        bsr             NOP_S
        bsr             NEWLINE
        bra             MAIN_LOOP
MCL_RTS
        * Check 'RTS' instruction.
        cmp.w           #$4e75,INITIAL_INSTRUCTION
        bne             MCL_CLR
        bsr             TAB
        bsr             RTS_S
        bsr             NEWLINE
        bra             MAIN_LOOP
MCL_CLR
        * Check 'CLR' instruction
        cmp.b           #$42,INITIAL_INSTRUCTION
        bne             MCL_JSR
        bsr             INITIAL_TWO_EA_LOAD_SIZE
        bsr             SIZE_CONVERT_TYPE_ONE
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID
        bsr             TAB
        bsr             CLR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE
        bra             MAIN_LOOP
        ** todo: work here
MCL_JSR
        * Check 'JSR' instruction
        cmp.b           #$4e,INITIAL_INSTRUCTION
        bne             MCL_LEA
        bsr             INITIAL_TWO_EA_LOAD_SIZE
        cmp.b           #2,SIZE
        bne             INVALID_S

        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID

        bsr             TAB
        bsr             JSR_S

        bsr             TAB
        bsr             INITIAL_TWO_EA_LOAD_OUT

        bsr             NEWLINE

        bra             MAIN_LOOP
MCL_LEA
        * Check 'lea' instruction
        bsr             INITIAL_FOUR_EA_LOAD
        cmp.b           #7,DEST_MODE
        bne             MCL_MOVEM
        bsr             SIZE_LONG
        move.b          #1,DEST_MODE
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID
        
        bsr             TAB
        bsr             LEA_S
        bsr             TAB

        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE
        bra             MAIN_LOOP

MCL_MOVEM
        * Check whether it correct movem or not
        move.w          INITIAL_INSTRUCTION,d7
        btst            #11,d7
        beq             MCL_INVALID
        btst            #9,d7
        bne             MCL_INVALID
        btst            #8,d7
        bne             MCL_INVALID
        btst            #7,d7
        beq             MCL_INVALID

        * Now its valid instruction
        ** load and checking Register list mask
        bsr             MCL_MM_LOAD_REGISTER_MASK       * Register List load
        bsr             INITIAL_TWO_EA_LOAD             * mode and register load
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID

        * Settign the size of the instruction.
MCL_MM_WORD
        btst            #6,d7
        bne             MCL_MM_LONG
        bsr             SIZE_WORD
        bra             MCL_MM_OUT
MCL_MM_LONG
        bsr             SIZE_LONG
        bra             MCL_MM_OUT
MCL_MM_OUT
        bsr             TAB
        bsr             MOVEM_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             MCL_MM_OPERAND
        bsr             NEWLINE

        bra             MAIN_LOOP
        

MCL_MM_LOAD_REGISTER_MASK
        ** Load register list mask
        move.w          (a6)+,REGISTER_LIST_MASK
        cmp.w           #0,REGISTER_LIST_MASK
        beq             MCL_INVALID
        rts


MCL_MM_OPERAND
        clr.w           d5                      * boolean register, saving more than one or not?
        clr.w           d4                      * Instructoin order
        
        * Validatoin check for REGISTER_LIST_MASK
        cmp.w           #0,REGISTER_LIST_MASK
        beq             INVALID_S

        move.w          REGISTER_LIST_MASK,d4
        btst            #10,d7
        bne             MCL_MM_ORD_MEM_REG
MCL_MM_ORD_REG_MEM
        * -------------------------------
        * Printing List
MCL_MM_ORD_REG_MEM_D0
        btst            #15,d4
        beq             MCL_MM_ORD_REG_MEM_D1
        bsr             D_ZERO_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_D1
        btst            #14,d4
        beq             MCL_MM_ORD_REG_MEM_D2
        bsr             MCL_MM_ORD_SLASH
        bsr             D_ONE_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_D2
        btst            #13,d4
        beq             MCL_MM_ORD_REG_MEM_D3
        bsr             MCL_MM_ORD_SLASH
        bsr             D_TWO_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_D3
        btst            #12,d4
        beq             MCL_MM_ORD_REG_MEM_D4
        bsr             MCL_MM_ORD_SLASH
        bsr             D_THREE_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_D4
        btst            #11,d4
        beq             MCL_MM_ORD_REG_MEM_D5
        bsr             MCL_MM_ORD_SLASH
        bsr             D_FOUR_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_D5
        btst            #10,d4
        beq             MCL_MM_ORD_REG_MEM_D6
        bsr             MCL_MM_ORD_SLASH
        bsr             D_FIVE_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_D6
        btst            #9,d4
        beq             MCL_MM_ORD_REG_MEM_D7
        bsr             MCL_MM_ORD_SLASH
        bsr             D_SIX_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_D7
        btst            #8,d4
        beq             MCL_MM_ORD_REG_MEM_A0
        bsr             MCL_MM_ORD_SLASH
        bsr             D_SEVEN_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_A0
        btst            #7,d4
        beq             MCL_MM_ORD_REG_MEM_A1
        bsr             MCL_MM_ORD_SLASH
        bsr             A_ZERO_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_A1
        btst            #6,d4
        beq             MCL_MM_ORD_REG_MEM_A2
        bsr             MCL_MM_ORD_SLASH
        bsr             A_ONE_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_A2
        btst            #5,d4
        beq             MCL_MM_ORD_REG_MEM_A3
        bsr             MCL_MM_ORD_SLASH
        bsr             A_TWO_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_A3
        btst            #4,d4
        beq             MCL_MM_ORD_REG_MEM_A4
        bsr             MCL_MM_ORD_SLASH
        bsr             A_THREE_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_A4
        btst            #3,d4
        beq             MCL_MM_ORD_REG_MEM_A5
        bsr             MCL_MM_ORD_SLASH
        bsr             A_FOUR_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_A5
        btst            #2,d4
        beq             MCL_MM_ORD_REG_MEM_A6
        bsr             MCL_MM_ORD_SLASH
        bsr             A_FIVE_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_A6
        btst            #1,d4
        beq             MCL_MM_ORD_REG_MEM_A7
        bsr             MCL_MM_ORD_SLASH
        bsr             A_SIX_S
        move.b          #1,d5
MCL_MM_ORD_REG_MEM_A7
        btst            #0,d4
        beq             MCL_MM_ORD_REG_MEM_LAST
        bsr             MCL_MM_ORD_SLASH
        bsr             A_SEVEN_S
        move.b          #1,d5
        * -------------------------------
MCL_MM_ORD_REG_MEM_LAST
        bsr             COMMA_S
        bsr             INITIAL_TWO_EA_LOAD_OUT

        rts

        
MCL_MM_ORD_MEM_REG
        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             COMMA_S
        * -------------------------------
        * Printing List
MCL_MM_ORD_MEM_REG_D0
        btst            #0,d4
        beq             MCL_MM_ORD_MEM_REG_D1
        bsr             D_ZERO_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_D1
        btst            #1,d4
        beq             MCL_MM_ORD_MEM_REG_D2
        bsr             MCL_MM_ORD_SLASH
        bsr             D_ONE_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_D2
        btst            #2,d4
        beq             MCL_MM_ORD_MEM_REG_D3
        bsr             MCL_MM_ORD_SLASH
        bsr             D_TWO_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_D3
        btst            #3,d4
        beq             MCL_MM_ORD_MEM_REG_D4
        bsr             MCL_MM_ORD_SLASH
        bsr             D_THREE_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_D4
        btst            #4,d4
        beq             MCL_MM_ORD_MEM_REG_D5
        bsr             MCL_MM_ORD_SLASH
        bsr             D_FOUR_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_D5
        btst            #5,d4
        beq             MCL_MM_ORD_MEM_REG_D6
        bsr             MCL_MM_ORD_SLASH
        bsr             D_FIVE_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_D6
        btst            #6,d4
        beq             MCL_MM_ORD_MEM_REG_D7
        bsr             MCL_MM_ORD_SLASH
        bsr             D_SIX_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_D7
        btst            #7,d4
        beq             MCL_MM_ORD_MEM_REG_A0
        bsr             MCL_MM_ORD_SLASH
        bsr             D_SEVEN_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_A0
        btst            #8,d4
        beq             MCL_MM_ORD_MEM_REG_A1
        bsr             MCL_MM_ORD_SLASH
        bsr             A_ZERO_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_A1
        btst            #9,d4
        beq             MCL_MM_ORD_MEM_REG_A2
        bsr             MCL_MM_ORD_SLASH
        bsr             A_ONE_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_A2
        btst            #10,d4
        beq             MCL_MM_ORD_MEM_REG_A3
        bsr             MCL_MM_ORD_SLASH
        bsr             A_TWO_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_A3
        btst            #11,d4
        beq             MCL_MM_ORD_MEM_REG_A4
        bsr             MCL_MM_ORD_SLASH
        bsr             A_THREE_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_A4
        btst            #12,d4
        beq             MCL_MM_ORD_MEM_REG_A5
        bsr             MCL_MM_ORD_SLASH
        bsr             A_FOUR_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_A5
        btst            #13,d4
        beq             MCL_MM_ORD_MEM_REG_A6
        bsr             MCL_MM_ORD_SLASH
        bsr             A_FIVE_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_A6
        btst            #14,d4
        beq             MCL_MM_ORD_MEM_REG_A7
        bsr             MCL_MM_ORD_SLASH
        bsr             A_SIX_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_A7
        btst            #15,d4
        beq             MCL_MM_ORD_MEM_REG_LAST
        bsr             MCL_MM_ORD_SLASH
        bsr             A_SEVEN_S
        move.b          #1,d5
MCL_MM_ORD_MEM_REG_LAST
        rts
        * -------------------------------

MCL_MM_ORD_SLASH
        cmp.w           #1,d5
        bne             MCL_MM_ORD_SLASH_NOT
        bsr             SLASH_S   
MCL_MM_ORD_SLASH_NOT
        rts

MCL_INVALID
        bsr             CLEAR_ALL_BIT_S
        bra             INVALID_S

        * Check 'movem' instruction
        * Show error

* Mnemonic: addq
MC_ADDQ
        * Valid check (Check whether 8th bit is one or not, '1' is invalid)
        clr.w          d7
        move.b          INITIAL_INSTRUCTION,D7
        btst            #8,d7
        bne             MCAQ_INVALID
        * InInitiating EA_MODE, EA_Register, SIZE
        bsr             INITIAL_TWO_EA_LOAD_SIZE
        bsr             SIZE_CONVERT_TYPE_ONE           * Converting size instruction.
        bsr             ADDRESS_READ_DECISION_LOAD      * Check for memory load
        BSR             IS_VALID                        * Validation check
        
        * Load 'Data' into 'DEST_REGISTER variable' - DEST_MODE get garbage.
        bsr             INITIAL_FOUR_EA_LOAD

        * Save data into register, and if 'DATA' is #0, change it into '8'
        clr             d7
        move.b          DEST_REGISTER,d7
        cmp.b           #8,d7
        beq             MC_ADDQ_FINAL
        move.b          #8,d7

MC_ADDQ_FINAL
        * Check whether the destination <ea> or not, and if the destination is ea, set DEST_NUMBER_DATA.
        cmp.b           #7,SRC_MODE
        bne             MC_ADDQ_FINAL_DONE
        move.l          SRC_NUMBER_DATA,DST_NUMBER_DATA
MC_ADDQ_FINAL_DONE       
        *deceiving assembler
        move.w          d7,SRC_NUMBER_DATA
        move.b          SRC_MODE,DEST_MODE
        move.b          SRC_REGISTER,DEST_REGISTER
        move.b          #7,SRC_MODE
        move.b          #4,SRC_REGISTER
        bsr             IS_VALID

        bsr             TAB
        bsr             ADDQ_S
        bsr             SIZE_TAG_S
        bsr             TAB
        bsr             SIZE_BYTE
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE                 Newline

        bra             MAIN_LOOP
MCAQ_INVALID
        bra             INVALID_S

* Mnemonic: bcc, bgt, ble
MC_BCGL
        movem.l         d6/d7,-(sp)
        move.l          a6,d6
        cmp.b           #$64,INITIAL_INSTRUCTION
        beq             MCBL_BCC
        cmp.b           #$6E,INITIAL_INSTRUCTION
        beq             MCBL_BGT
        cmp.b           #$6F,INITIAL_INSTRUCTION
        beq             MCBL_BLE

        bra             MCBC_INVALID
MCBL_BCC
        bsr             INITIAL_DATA_EIGHT_LOAD
        bsr             CONDIITON_DECISION_LOAD
        bsr             TAB
        bsr             BCC_S
        bra             MC_BCGL_FINAL
MCBL_BGT
        bsr             INITIAL_DATA_EIGHT_LOAD
        bsr             CONDIITON_DECISION_LOAD
        bsr             TAB
        bsr             BGT_S
        bra             MC_BCGL_FINAL
MCBL_BLE
        bsr             INITIAL_DATA_EIGHT_LOAD
        bsr             CONDIITON_DECISION_LOAD
        bsr             TAB
        bsr             BLE_S
        bra             MC_BCGL_FINAL

MC_BCGL_FINAL
        clr.w           d7

        cmp.b           #$00,DATA_EIGHT_BIT
        beq             MC_BCGL_FINAL_16
        cmp.b           #$FF,DATA_EIGHT_BIT
        beq             MC_BCGL_FINAL_32
        
        move.b          DATA_EIGHT_BIT,d7
        clr.l           d5
        move.b          #24,d5
        asl.l           d5,d7
        asr.l           d5,d7

        move.l          d7,SRC_NUMBER_DATA
        add.l           d6,SRC_NUMBER_DATA

        * Deceiving Assembler
        bsr             SIZE_BYTE
        bsr             SIZE_TAG_S
        bsr             TAB
        move.b          #7,SRC_MODE
        move.b          #1,SRC_REGISTER

        bsr             INITIAL_TWO_EA_LOAD_OUT

        bra             MC_BCGL_FINAL_LAST
        
MC_BCGL_FINAL_16
        * 16 bit displacement
        ** Deceiving Assembler
        bsr             SIZE_WORD
        bsr             SIZE_TAG_S
        bsr             TAB
        move.b          #7,SRC_MODE
        move.b          #1,SRC_REGISTER

        move.w          SRC_NUMBER_DATA,d7
        clr.l           d5
        move.b          #16,d5
        asl.l           d5,d7
        asr.l           d5,d7
        move.l          d7,SRC_NUMBER_DATA

        add.l           d6,SRC_NUMBER_DATA
        bsr             INITIAL_TWO_EA_LOAD_OUT

        bra             MC_BCGL_FINAL_LAST
MC_BCGL_FINAL_32
        * 32 bit displacement
        ** Deceiving Assembler
        bsr             SIZE_LONG
        bsr             SIZE_TAG_S
        bsr             TAB
        move.b          #7,SRC_MODE
        move.b          #1,SRC_REGISTER
        add.l           d6,SRC_NUMBER_DATA
        bsr             INITIAL_TWO_EA_LOAD_OUT

        bra             MC_BCGL_FINAL_LAST
MC_BCGL_FINAL_LAST
        movem.l         (sp)+,d6-d7
        bsr             NEWLINE
        bra             MAIN_LOOP
MCBC_INVALID
        movem.l         (sp)+,d6-d7
        bra             INVALID_S

* Mnemonic: moveq
MC_MOVEQ
        move.w          INITIAL_INSTRUCTION,d7
        btst            #8,d7
        bne             MCMQ_INVALID

        * The instruction is valid
        bsr             INITIAL_DATA_EIGHT_LOAD
        bsr             INITIAL_FOUR_EA_LOAD

        * Deceiving Assembler
        move.b          #0,DEST_MODE
        move.b          #7,SRC_MODE
        move.b          #4,SRC_REGISTER
        clr.w           d6
        move.b          DATA_EIGHT_BIT,d6
        move.w          d6,SRC_NUMBER_DATA
        bsr             SIZE_BYTE
        bsr             TAB
        
        bsr             MOVEQ_S
        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE                 Newline
        bra             MC_MOVEQ_FINAL
MC_MOVEQ_FINAL
        bra             MAIN_LOOP
MCMQ_INVALID
        bra             INVALID_S

* Mnemonic: or, divu
MC_OR_DIVU
        bsr             INITIAL_FOUR_EA_LOAD
MCOD_DIVU
        * Check for DIVU instruction
        cmp.b           #3,DEST_MODE
        bne             MCOD_OR
        bsr             SIZE_WORD
        move.b          #$00,DEST_MODE
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID

        bsr             TAB
        bsr             DIVU_S
        bsr             SIZE_TAG_S

        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE
        bra             MAIN_LOOP

MCOD_OR
        * OR valid case
        cmp.b           #7,DEST_MODE
        beq             MCOD_INVALID

        * Invalid common operation
        ** Setting the size
        move.b          DEST_MODE,SIZE
        bsr             SIZE_CONVERT_TYPE_TWO

        * This is valid OR so printout OR.
        bsr             TAB
        bsr             OR_S
        bsr             SIZE_TAG_S
MCOD_OR_DN
        * Check for OR instruction <ea> V Dn -> Dn format
        cmp.b           #4,DEST_MODE
        bcc             MCOD_OR_EA

        * Set dest mode as register (Deception!!)
        move.b          #$00,DEST_MODE

        * Based on deception, load memory
        bsr             ADDRESS_READ_DECISION_LOAD

        * Print out
        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE
        bra             MAIN_LOOP
MCOD_OR_EA
        * OR instruction and Dn V <ea> -> <ea> format

        * back up the Dest_register
        move.b          DEST_REGISTER,d7
        move.b          SRC_MODE,DEST_MODE
        move.b          SRC_REGISTER,DEST_REGISTER

        move.b          #$00,SRC_MODE
        move.b          d7,SRC_REGISTER

        * Based on deception, load memory
        bsr             ADDRESS_READ_DECISION_LOAD

        * Print out
        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE

        bra             MAIN_LOOP
MCOD_INVALID
        bra             INVALID_S


* Mnemonic: sub
MC_SUB
        bsr             INITIAL_FOUR_EA_LOAD

        * sub invalid cases #7, #3
        cmp.b           #7,DEST_MODE
        beq             MCSB_INVALID
        cmp.b           #3,DEST_MODE
        beq             MCSB_INVALID

        * This is valid OR so printout OR.
        bsr             TAB
        bsr             SUB_S

        * Predefine code to print size tag, and two operands
        bsr             FOUR_OPCODE_LOAD_OUT

        bra             MAIN_LOOP

MCSB_INVALID
        bra             INVALID_S


* Mnemonic: cmp
MC_CMP
        ** Load initial four instruction.
        bsr             INITIAL_FOUR_EA_LOAD

        * cmp valid cases bigger or equal to #3
        cmp.b           #3,DEST_MODE
        bcc             MCCP_INVALID

        * Invalid common operation

        * This is valid OR so printout OR.
        bsr             TAB
        bsr             CMP_S

        * Predefine code to print size tag, and two operands
        bsr             FOUR_OPCODE_LOAD_OUT

        bra             MAIN_LOOP

MCCP_INVALID
        bra             INVALID_S


* Mnemonic: and, muls, mulu
MC_AND_MULU
        bsr             INITIAL_FOUR_EA_LOAD
MAM_MULS
        * Check for MULS
        cmp.b           #7,DEST_MODE
        bne             MAM_MULU
        bsr             SIZE_WORD
        move.b          #$00,DEST_MODE
        bsr             ADDRESS_READ_DECISION_LOAD

        bsr             TAB
        bsr             MULS_S
        bsr             SIZE_TAG_S

        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE
        bra             MAIN_LOOP
MAM_MULU
        * Check for MULS
        cmp.b           #3,DEST_MODE
        bne             MAM_AND
        bsr             SIZE_WORD
        move.b          #$00,DEST_MODE
        bsr             ADDRESS_READ_DECISION_LOAD

        bsr             TAB
        bsr             MULU_S
        bsr             SIZE_TAG_S

        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE
        bra             MAIN_LOOP
MAM_AND
        * Invalid common operation
        ** Setting the size

        * This is valid AND so printout AND.
        bsr             TAB
        bsr             AND_S

        * Predefine code to print size tag, and two operands
        bsr             FOUR_OPCODE_LOAD_OUT

        bra             MAIN_LOOP

MAM_INVALID
        bra             INVALID_S

* Mnemonic: add, adda
MC_ADD_ADDA
        bsr             INITIAL_FOUR_EA_LOAD
MCADDDA_ADD
        *Add cases check

        ** ADDA cases are #7 #3
        cmp.b           #7,DEST_MODE
        beq             MCADDDA_ADDA
        cmp.b           #3,DEST_MODE
        beq             MCADDDA_ADDA
        * -----------------------------

        * It's not ADDA, so its ADD
        bsr             TAB
        bsr             ADD_S

        * Predefine code to print size tag, and two operands
        bsr             FOUR_OPCODE_LOAD_OUT

        bra             MAIN_LOOP

MCADDDA_ADDA
        * It's ADDA.
        * converting manually.
        bsr             TAB
        bsr             ADDA_S

*Size operation
MCADDDA_ADDA_WORD
        cmp.b           #3,DEST_MODE
        bne             MCADDDA_ADDA_LONG
        bsr             SIZE_WORD
        bra             MCADDDA_ADDA_OUT
MCADDDA_ADDA_LONG
        cmp.b           #7,DEST_MODE
        bne             MCADDDA_INVALID
        bsr             SIZE_LONG
MCADDDA_ADDA_OUT
        * This is valid OR so printout OR.
        bsr             SIZE_TAG_S
MCADDDA_ADDA_OUT_AN
        * Set dest mode as register (Deception!!)
        move.b          #$01,DEST_MODE

        * Based on deception, load memory
        bsr             ADDRESS_READ_DECISION_LOAD

        * Print out
        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE
        
        bra             MAIN_LOOP

MCADDDA_INVALID
        bra             INVALID_S

* Mnemonic: asr, asl, lsr, lsl, ror, rol
MC_ASR_ROL
        * shift and rotation common operation.
        * Load the data, and set to
        * SRC_MODE
        * DST_MODE
        * SRC_REGISTER
        * DST_REGISTER
        move.w          INITIAL_INSTRUCTION,d7
        bsr             INITIAL_TWO_EA_LOAD_SIZE
        bsr             INITIAL_FOUR_EA_LOAD

        cmp.b           #3,SIZE
        beq             MAR_TO_ADDRESS          * It has very different instruction set

MAR_TO_REGISTER
        bsr             SIZE_CONVERT_TYPE_TWO
        btst            #5,d7
        bne             MTR_DXDY
        btst            #5,d7
        beq             MTR_EADY
* CASE 1, DX,DY
MTR_DXDY
        * Common operation
        move.b          #0,SRC_MODE
        move.b          #0,DEST_MODE
        move.b          SRC_REGISTER,d6
        move.b          DEST_REGISTER,SRC_REGISTER
        move.b          d6,DEST_REGISTER

        * branching
        btst            #4,d7
        bne             MTR_DXDY_ROd
        btst            #3,d7
        bne             MTR_DXDY_LSd
        btst            #3,d7
        beq             MTR_DXDY_ASd

MTR_DXDY_ASd
        * Now it is valid
        btst            #8,d7
        beq             MTR_DXDY_ASR
        btst            #8,d7
        bne             MTR_DXDY_ASL
MTR_DXDY_ASR
        bsr             IS_VALID
        bsr             TAB
        bsr             ASR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL 
MTR_DXDY_ASL
        bsr             IS_VALID
        bsr             TAB
        bsr             ASL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL 


MTR_DXDY_LSd
        * Now it is valid
        btst            #8,d7
        beq             MTR_DXDY_LSR
        btst            #8,d7
        bne             MTR_DXDY_LSL
MTR_DXDY_LSR
        bsr             IS_VALID
        bsr             TAB
        bsr             LSR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL  

MTR_DXDY_LSL
        bsr             IS_VALID
        bsr             TAB
        bsr             LSL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL  

MTR_DXDY_ROd
        * invalid check
        btst            #3,d7
        beq             MC_ASR_ROL_INVALID

        * Now it is valid
        btst            #8,d7
        beq             MTR_DXDY_ROR
        btst            #8,d7
        bne             MTR_DXDY_ROL

MTR_DXDY_ROR
        bsr             IS_VALID
        bsr             TAB
        bsr             ROR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL  
MTR_DXDY_ROL
        bsr             IS_VALID
        bsr             TAB
        bsr             ROL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL  



*CASE 2 <EA>,DY
MTR_EADY
        *common for eady
        move.b          #7,SRC_MODE
        move.b          #0,DEST_MODE
        clr.w           d6
        move.b          DEST_REGISTER,d6
        move.w          d6,SRC_NUMBER_DATA
        move.b          SRC_REGISTER,DEST_REGISTER
        move.b          #4,SRC_REGISTER

        cmp.w           #0,SRC_NUMBER_DATA
        bne             MTR_EADY_DECISION
        move.w          #8,SRC_NUMBER_DATA
MTR_EADY_DECISION
        btst            #4,d7
        bne             MTR_EADY_ROd
        btst            #3,d7
        bne             MTR_EADY_LSd
        btst            #3,d7
        beq             MTR_EADY_ASd


MTR_EADY_ASd
        * Now it is valid
        btst            #8,d7
        beq             MTR_EADY_ASR
        btst            #8,d7
        bne             MTR_EADY_ASL
MTR_EADY_ASR
        bsr             IS_VALID
        bsr             TAB
        bsr             ASR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             SIZE_BYTE
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL 
MTR_EADY_ASL
        bsr             IS_VALID
        bsr             TAB
        bsr             ASL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             SIZE_BYTE
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL 


MTR_EADY_LSd
        * Now it is valid
        btst            #8,d7
        beq             MTR_EADY_LSR
        btst            #8,d7
        bne             MTR_EADY_LSL
MTR_EADY_LSR
        bsr             IS_VALID
        bsr             TAB
        bsr             LSR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             SIZE_BYTE
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL 
MTR_EADY_LSL
        bsr             IS_VALID
        bsr             TAB
        bsr             LSL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             SIZE_BYTE
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL 

MTR_EADY_ROd
        * invalid check
        btst            #3,d7
        beq             MC_ASR_ROL_INVALID

        * Now it is valid
        btst            #8,d7
        beq             MTR_EADY_ROR
        btst            #8,d7
        bne             MTR_EADY_ROL
MTR_EADY_ROR
        bsr             IS_VALID
        bsr             TAB
        bsr             ROR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             SIZE_BYTE
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL 

MTR_EADY_ROL
        bsr             IS_VALID
        bsr             TAB
        bsr             ROL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             SIZE_BYTE
        bsr             INITIAL_FOUR_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL 




MAR_TO_ADDRESS
        * Only one Effective address and parameter
        bsr             SIZE_WORD       * Commonly size word

        cmp.b           #0,DEST_REGISTER
        beq             MAR_TA_ASd
        cmp.b           #1,DEST_REGISTER
        beq             MAR_TA_LSd
        cmp.b           #3,DEST_REGISTER
        beq             MAR_TA_ROd

        bra             MC_ASR_ROL_INVALID

MAR_TA_ASd
        move.b          #0,DEST_MODE
        move.b          #0,DEST_REGISTER

        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID

        btst            #8,d7
        beq             MAR_TA_ASR
MAR_TA_ASL
        bsr             TAB
        bsr             ASL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE
        bra             MC_ASR_ROL_FINAL
MAR_TA_ASR
        bsr             TAB
        bsr             ASR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL

MAR_TA_LSd
        move.b          #0,DEST_MODE
        move.b          #0,DEST_REGISTER

        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID

        btst            #8,d7
        beq             MAR_TA_LSR

MAR_TA_LSL
        bsr             TAB
        bsr             LSL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL
MAR_TA_LSR
        bsr             TAB
        bsr             LSR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL



MAR_TA_ROd
        move.b          #0,DEST_MODE
        move.b          #0,DEST_REGISTER

        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID

        btst            #8,d7
        beq             MAR_TA_ROR
MAR_TA_ROL
        bsr             TAB
        bsr             ROL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL
MAR_TA_ROR
        bsr             TAB
        bsr             ROR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL
MC_ASR_ROL_FINAL
        bra             MAIN_LOOP
MC_ASR_ROL_INVALID
        bra             INVALID_S

** ----------------------------------------
** Sub-functions for Mnemonics

*** Clear unnecessary bit --------------------------
**** Left only three bit ****
THREE_BIT_ONLY
                movem.l         d7,-(sp)        Saving D7 to stack

                move.b          CONVERSOIN_RESERVED,d7
                bclr            #$07,d7
                bclr            #$06,d7
                bclr            #$05,d7
                bclr            #$04,d7
                bclr            #$03,d7
                move.b          d7,CONVERSOIN_RESERVED

                movem.l         (sp)+,d7        Load d7 from stack
                rts

**** Left only two bit ****
TWO_BIT_ONLY
                movem.l         d7,-(sp)                Saving d7 to stack

                move.b          CONVERSOIN_RESERVED,d7
                bclr            #$07,d7
                bclr            #$06,d7
                bclr            #$05,d7
                bclr            #$04,d7
                bclr            #$03,d7
                bclr            #$02,d7
                move.b          d7,CONVERSOIN_RESERVED

                movem.l         (sp)+,d7                Load d7 from the stack
                rts

**** Left only One bit ****
ONE_BIT_ONLY
                movem.l         d7,-(sp)                        Saving d7 to stack
                move.b          CONVERSOIN_RESERVED,d7
                bclr            #$07,d7
                bclr            #$06,d7
                bclr            #$05,d7
                bclr            #$04,d7
                bclr            #$03,d7
                bclr            #$02,d7
                bclr            #$01,d7
                move.b          d7,CONVERSOIN_RESERVED
                movem.l         (sp)+,d7                        Load d7 from the stack
                rts

INVALID_S       bsr     TAB
                lea     STACK,sp
                lea     INVALID_INSTRUCTION_MESSAGE,a1
                move.b  #14,d0
                trap    #15

                bsr     TAB
                move.w  INITIAL_INSTRUCTION,WORD_OUT
                bsr     WORD_OUT_S

                bsr     NEWLINE

                bra     MAIN_LOOP               * To ignore the invalid insructoin, proceed to the next loop.
** Sub-functions for Mnemonics
** ----------------------------------------


**********************************************************
* Based on the given size data, it will printout 
* '.b' '.w' '.l'
*--Size tag instructoin
SIZE_TAG_S

STS_DOT_BYTE_OUT
        cmp.b           #BYTE,SIZE
        bne             STS_DOT_WORD_OUT
        bsr             BYTE_S
        rts
STS_DOT_WORD_OUT
        cmp.b           #WORD,SIZE
        bne             STS_DOT_LONG_OUT
        bsr             WORD_S
        rts
STS_DOT_LONG_OUT
        cmp.b           #LONG,SIZE
        bne             STS_INVALID_SIZE
        bsr             LONG_S
        rts
STS_INVALID_SIZE
        bra             INVALID_S
*--> Size tag instruction end
***************************************************************


* -------------------------------------------------------------------
* Address out instruction
*********************************************
* Read 8 character from the address.
ADDRESS_OUT
        movem.l         d6-d7,-(sp)
        
        move.l          #16,d6

        move.l          a6,d7
        lsl.l           d6,d7
        move.w          d7,WORD_OUT
        bsr             WORD_OUT_S

        lsr.l           d6,d7
        move.w          d7,WORD_OUT
        bsr             WORD_OUT_S

        movem.l         (sp)+,d6-d7
        rts

* Address out instruction end


* -------------------------------------------------------------------
* a5 word size out
* Read 4 character from the address.
* for(int i =0; i<4; i++), and i = d0
WORD_OUT_S
        movem.l         d6-d7,-(sp)
        clr             d7
WOS_LOOP
        move.w          WORD_OUT,d6

        move.b          WORD_OUT,BYTE_OUT
        bsr             BYTE_OUT_S

        move.b          D6,BYTE_OUT
        bsr             BYTE_OUT_S
        

WOS_FINAL
        movem.l         (sp)+,d6-d7
        rts
* > word size out end
* -------------------------------------------------------------------

*********************************************************************
* > Byte size out instructoin
* -------------------------------------------------------------------
* a5 word size out
* Read 2 character from the address.
* for(int i =0; i<2; i++), and i = d0
BYTE_OUT_S
        movem.l     d0-d7/a0-a5,-(sp)
        clr         d7
        move.b     BYTE_OUT,d5
BO_LOOP_GET_TWO
        cmp.b       #$02,d7                 i=8 Break statement
        bge         BO_PRINT
        addi.b      #$01,d7                 i++
        
        * Getting only one character (from ?? to ?)
        move.b      d5,d4
        bclr        #4,d4
        bclr        #5,d4
        bclr        #6,d4
        bclr        #7,d4
        
        * Getting next character
        ror.l       #4,d5
        
        * Save the Character at stack
        movem.w     d4,-(sp)
        
        bra         BO_LOOP_GET_TWO
*********************************************
BO_PRINT
        clr         d7
BO_PRINT_LOOP
        *for(inti=0;i<2;i++)
        cmp.b       #$02,d7
        bge         BO_FINAL
        addi.b      #$01,d7
        clr.l       d0
        movem.w     (sp)+,d4
        move.b      d4,d1

        * Trap15 #6 will print value in d1
BOP_0_TO_9
        cmp.b           #9,d1
        bhi             BOP_A_TO_F
        addi.b          #$30,d1
        bra             BOP_PRINT 
BOP_A_TO_F
        addi.b          #$37,d1
        bra             BOP_PRINT 
BOP_PRINT 
        move.b          #6,d0
        trap            #15
        bra             BO_PRINT_LOOP

BO_FINAL
        movem.l     (sp)+,d0-d7/a0-a5           Move back to the stack
        rts
        
* > Byte size out instructoin
*********************************************************************





* Mnemonic disassembly end here
*******************************************************************************************

*For the instruction 


******************************************************************************
* This is to minimize the typing
* Pre-defined string instructions
****************************************************************************

        **Printing save instructoin with bsr
* Assembly instruction.     
ADDI_S      LEA     ADDI_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

SUBI_S      LEA     SUBI_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

MOVE_S    LEA     MOVE_MESSAGE,A1 * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS
            
MOVEA_S     LEA     MOVEA_MESSAGE,A1 * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS
        
CLR_S       LEA     CLR_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

NOP_S       LEA     NOP_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

RTS_S       LEA     RTS_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

JSR_S       LEA     JSR_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

MOVEM_S     LEA     MOVEM_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

LEA_S       LEA     LEA_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

ADDQ_S      LEA     ADDQ_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

BCC_S       LEA     BCC_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

BGT_S       LEA     BGT_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

BLE_S       LEA     BLE_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

MOVEQ_S     LEA     MOVEQ_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0            * Moves the number 14 into data register D0
            TRAP    #15               * Displays meessage
            RTS
 
OR_S        LEA     OR_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

DIVU_S      LEA     DIVU_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

SUB_S       LEA     SUB_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

CMP_S       LEA     CMP_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

AND_S       LEA     AND_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

MULS_S      LEA     MULS_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

MULU_S      LEA     MULU_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

ADD_S       LEA     ADD_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

ADDA_S      LEA     ADDA_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

ASR_S       LEA     ASR_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

ASL_S       LEA     ASL_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

LSR_S       LEA     LSR_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

LSL_S       LEA     LSL_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

ROR_S       LEA     ROR_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

ROL_S       LEA     ROL_MESSAGE,A1   * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

* Size instruction.
LONG_S  LEA     LONG_MESSAGE,A1     * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

WORD_S      LEA     WORD_MESSAGE,A1          * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

BYTE_S      LEA     BYTE_MESSAGE,A1          * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

* Data register.
D_ZERO_S        LEA     D_ZERO_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_ONE_S         LEA     D_ONE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_TWO_S         LEA     D_TWO_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_THREE_S       LEA     D_THREE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_FOUR_S        LEA     D_FOUR_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_FIVE_S        LEA     D_FIVE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_SIX_S         LEA     D_SIX_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_SEVEN_S       LEA     D_SEVEN_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS

* Address Register.
A_ZERO_S        LEA     A_ZERO_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_ONE_S         LEA     A_ONE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_TWO_S         LEA     A_TWO_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_THREE_S       LEA     A_THREE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_FOUR_S        LEA     A_FOUR_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_FIVE_S        LEA     A_FIVE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_SIX_S         LEA     A_SIX_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_SEVEN_S       LEA     A_SEVEN_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS

* Address Register with paranthesis.
A_ZERO_P_S      LEA     A_ZERO_P_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_ONE_P_S       LEA     A_ONE_P_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_TWO_P_S       LEA     A_TWO_P_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_THREE_P_S     LEA     A_THREE_P_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_FOUR_P_S      LEA     A_FOUR_P_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_FIVE_P_S      LEA     A_FIVE_P_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_SIX_P_S       LEA     A_SIX_P_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_SEVEN_P_S     LEA     A_SEVEN_P_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
PLUS_S          LEA     PLUS_MESSAGE,a1
                move.b  #14,d0
                trap    #15
                rts
MINUS_S         LEA     MINUS_MESSAGE,a1
                move.b  #14,d0
                trap    #15
                rts

DOLLAR_S        LEA     DOLLAR_MESSAGE,a1
                move.b  #14,d0
                trap    #15
                rts

HASH_S          LEA     HASH_MESSAGE,a1
                move.b  #14,d0
                trap    #15
                rts

COMMA_S         LEA     COMMA_MESSAGE,a1
                move.b  #14,d0
                trap    #15
                rts

SLASH_S         LEA     SLASH_MESSAGE,a1
                move.b  #14,d0
                trap    #15
                rts

* NewLine
NEWLINE         lea             CRLF,A1
                move.b          #14,d0
                trap            #15
                rts

* Tab
TAB             lea             TAB_SPACE,a1
                move.b          #14,d0
                trap            #15
                rts

* Space
SPACE_S         lea            SPACE,a1
                move.b          #14,d0
                trap            #15
                rts

* Press Enter Message
PRESS_ENTER_S
                lea     PRESS_ENTER_MESSAGE,a1
                move.b  #14,d0
                trap    #15
                rts


* Clear the screen
CLEAR_SCREEN
                move.w  #$ff00,d1
                move.b  #11,d0
                trap    #15
                rts




ADDI_MESSAGE            DC.B    'ADDI',0
SUBI_MESSAGE            DC.B    'SUBI',0
MOVE_MESSAGE            DC.B    'MOVE',0
MOVEA_MESSAGE           DC.B    'MOVEA',0
CLR_MESSAGE             DC.B    'CLR',0
NOP_MESSAGE             DC.B    'NOP',0
RTS_MESSAGE             DC.B    'RTS',0
JSR_MESSAGE             DC.B    'JSR',0
MOVEM_MESSAGE           DC.B    'MOVEM',0
LEA_MESSAGE             DC.B    'LEA',0
ADDQ_MESSAGE            DC.B    'ADDQ',0
BCC_MESSAGE             DC.B    'BCC',0
BGT_MESSAGE             DC.B    'BGT',0
BLE_MESSAGE             DC.B    'BLE',0
MOVEQ_MESSAGE           DC.B    'MOVEQ',0
OR_MESSAGE              DC.B    'OR',0
DIVU_MESSAGE            DC.B    'DIVU',0
SUB_MESSAGE             DC.B    'SUB',0
CMP_MESSAGE             DC.B    'CMP',0
AND_MESSAGE             DC.B    'AND',0
MULS_MESSAGE            DC.B    'MULS',0
MULU_MESSAGE            DC.B    'MULU',0
ADD_MESSAGE             DC.B    'ADD',0
ADDA_MESSAGE            DC.B    'ADDA',0
ASR_MESSAGE             DC.B    'ASR',0
ASL_MESSAGE             DC.B    'ASL',0
LSR_MESSAGE             DC.B    'LSR',0
LSL_MESSAGE             DC.B    'LSL',0
ROR_MESSAGE             DC.B    'ROR',0
ROL_MESSAGE             DC.B    'ROL',0

* Data Register
D_ZERO_MESSAGE          DC.B    'D0',0
D_ONE_MESSAGE           DC.B    'D1',0
D_TWO_MESSAGE           DC.B    'D2',0
D_THREE_MESSAGE         DC.B    'D3',0
D_FOUR_MESSAGE          DC.B    'D4',0
D_FIVE_MESSAGE          DC.B    'D5',0
D_SIX_MESSAGE           DC.B    'D6',0
D_SEVEN_MESSAGE         DC.B    'D7',0

* Address Register
A_ZERO_MESSAGE          DC.B    'A0',0
A_ONE_MESSAGE           DC.B    'A1',0
A_TWO_MESSAGE           DC.B    'A2',0
A_THREE_MESSAGE         DC.B    'A3',0
A_FOUR_MESSAGE          DC.B    'A4',0
A_FIVE_MESSAGE          DC.B    'A5',0
A_SIX_MESSAGE           DC.B    'A6',0
A_SEVEN_MESSAGE         DC.B    'A7',0

* Address with Paranthesis Register
A_ZERO_P_MESSAGE          DC.B    '(A0)',0
A_ONE_P_MESSAGE           DC.B    '(A1)',0
A_TWO_P_MESSAGE           DC.B    '(A2)',0
A_THREE_P_MESSAGE         DC.B    '(A3)',0
A_FOUR_P_MESSAGE          DC.B    '(A4)',0
A_FIVE_P_MESSAGE          DC.B    '(A5)',0
A_SIX_P_MESSAGE           DC.B    '(A6)',0
A_SEVEN_P_MESSAGE         DC.B    '(A7)',0

* Plus and minus sign
PLUS_MESSAGE            dc.b    '+',0
MINUS_MESSAGE           dc.b    '-',0

* Size instruction.
LONG_MESSAGE            DC.B    '.L',0
WORD_MESSAGE            DC.B    '.W',0
BYTE_MESSAGE            DC.B    '.B',0

* Special character
DOLLAR_MESSAGE          DC.B    '$',0
HASH_MESSAGE            DC.B    '#',0
COMMA_MESSAGE           DC.B    ',',0
SLASH_MESSAGE           DC.B    '/',0

* Invalid Insturction.
INVALID_INSTRUCTION_MESSAGE     DC.B    'Invalid Instruction!!!',0

* Press Enter continue
PRESS_ENTER_MESSAGE             DC.B    'Press Enter to Continue',0

* New Line, and tab, Space
CRLF                    dc.b    CR,LF,0
TAB_SPACE               dc.b    HT,0
SPACE                   dc.b    ' ',0

* Constants - Alphabetical
ERROR_1                 dc.b    'INVALID INPUT: too long',0
ERROR_2                 dc.b    'INVALID INPUT: not within range',0
ERROR_3                 dc.b    'INVALID INPUT: not recognized',0
ERROR_4                 dc.b    'INVALID INPUT: less than start address',0
NEW_LINE                dc.b    ' ',0,CR,LF
PROMPT_1                dc.b    'Enter starting address. Range=[$3500,$9fff]',0
PROMPT_2                dc.b    '$',0
PROMPT_3                dc.b    'Press ENTER to continue...',0
PROMPT_4                dc.b    'Would you like to disassemble again? (Y/N)',0
PROMPT_5                dc.b    '>',0
PROMPT_6                dc.b    'Press ENTER to continue...',0
PROMPT_7                dc.b    'Enter ending address. Range=[$3500,$9fff]',0

* Const variable we need to invoke
STACK                   equ             $100000
DISASSEMBLE_FROM        equ             $7000
BS                      equ             $08         Backspace
HT                      equ             $09         Tab (horizontal 5 characters)
LF                      equ             $0A         New line (line feed)
VT                      equ             $0B         Vertical tab (4 lines)
FF                      equ             $0C         Form Feed (Always end printing with a Form Feed.)
CR                      equ             $0D         Carriage Return

** Size variable for size.
LONG                    equ             $10
WORD                    equ             $11
BYTE                    equ             $01

** Lower and Upper bound
LOWER_BOUND             equ             $3500
UPPER_BOUND             equ             $9fff
        

*******************************************************
* Description: Odcode reading
*1)
** INITIAL_FOUR_EA_LOAD
*** ???? | DST Register(3) | Dest Mode(3) | Src Mode(3) | Src Register(3)

*2) INITIAL_TWO_EA_LOAD
** ???? | ??? | ??? | Src Mode(3) | Src Register(3)

*3) INITIAL_TWO_EA_LOAD_SIZE
** ???? | ???? | size(2) | Src Mode(3) | Src Register(3)
*
*
* Description: Bit clear instructions
* 1) CLEAR_THREE_BIT_S
* 2) CLEAR_TWO_BIT_S


*******************************************************
* Effective address part
* Load four EA (last four) from Initial instruction.
INITIAL_FOUR_EA_LOAD
        movem.w         d7,-(sp)

        bsr             INITIAL_TWO_EA_LOAD             *Load last two
        move.w          INITIAL_INSTRUCTION,d7
        ror.w           #6,d7
        move.b          d7,CONVERSOIN_RESERVED
        bsr             THREE_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,DEST_MODE

        ror.w           #3,d7
        move.b          d7,CONVERSOIN_RESERVED
        bsr             THREE_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,DEST_REGISTER

        movem.w         (sp)+,d7

        rts

INITIAL_TWO_EA_LOAD_SIZE

        movem.w         d7,-(sp)

        bsr             INITIAL_TWO_EA_LOAD
        move.w          INITIAL_INSTRUCTION,d7
        ror.b           #6,d7
        move.b          d7,CONVERSOIN_RESERVED
        bsr             TWO_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,SIZE

        movem.w         (sp)+,d7       

        rts

* Load two Ea(last two) from Initial instruction
INITIAL_TWO_EA_LOAD
        movem.w         d7,-(sp)

        move.w          INITIAL_INSTRUCTION,d7
        move.b          d7,CONVERSOIN_RESERVED
        bsr             THREE_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,SRC_REGISTER

        ror.w           #3,d7
        move.b          d7,CONVERSOIN_RESERVED
        bsr             THREE_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,SRC_MODE

        movem.w         (sp)+,d7          

        rts

** Expected to use with BGT, BLE, BCC
INITIAL_DATA_EIGHT_LOAD
        movem.l         d7,-(sp)

        move.w          INITIAL_INSTRUCTION,d7
        move.b          d7,DATA_EIGHT_BIT

        movem.l         (sp)+,d7     

        rts

***************************************************************
* Clear 3 bit instructoins
*-> BIT CLEAR START HERE
CLEAR_ALL_BIT_S
    bsr         CLEAR_THREE_BIT_S
    bsr         CLEAR_TWO_BIT_S
    clr.w       REGISTER_LIST_MASK
    rts

CLEAR_THREE_BIT_S
        *clr.b   EA_MODE
        *clr.b   OP_MODE
        *clr.b   EA_REGISTER
        clr.b   DEST_REGISTER
        clr.b   DEST_MODE
        clr.b   SRC_MODE
        clr.b   SRC_REGISTER
        *clr.b   REGISTER
        *clr.b   COUNT_REGISTER
        rts

* Clear 2 bit instruction
CLEAR_TWO_BIT_S
        clr.b   SIZE
        rts
*-> BIT CLEAR END HERE
***************************************************************


        ** Decide whether to read more address or not.
ADDRESS_READ_DECISION_LOAD
ARDL_Source
        cmp.b   #7,SRC_MODE
        bne     ARDL_DST     * No source Data memory value
ARDL_SOURCE_WORD
        * Word compare
        cmp.b   #0,SRC_REGISTER
        bne     ARDL_SOURCE_LONG        * not word size
        move.w  (a6)+,SRC_NUMBER_DATA
        *move.w  (a6),WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST
ARDL_SOURCE_LONG                        * down here, check long size
        cmp.b   #1,SRC_REGISTER
        bne     ARDL_SOURCE_DATA        * not Long size
        move.l  (a6), SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST

***DATA check
ARDL_SOURCE_DATA                        * down here, check #<data>
        cmp.b   #4,SRC_REGISTER
        bne     INVALID_S               * Here is the code we don't need to disassemble

ARDL_SOURCE_DATA_BYTE
        * byte compare
        cmp.b   #BYTE,SIZE
        bne     ARDL_SOURCE_DATA_WORD
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST

ARDL_SOURCE_DATA_WORD
        cmp.b   #WORD,SIZE
        bne     ARDL_SOURCE_DATA_LONG
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST

ARDL_SOURCE_DATA_LONG
        cmp.b   #LONG,SIZE
        bne     INVALID_S
        move.l  (a6), SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST 


ARDL_DST                 * Address extension for source is not required
        cmp.b   #7,DEST_MODE
        bne     ARDL_FINAL_RTS

ARDL_DST_WORD
        * Word compare
        cmp.b   #0,DEST_REGISTER
        bne     ARDL_DST_LONG        * not word size
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS
ARDL_DST_LONG                        * down here, check long size
        cmp.b   #1,DEST_REGISTER
        bne     ARDL_DST_DATA        * not Long size
        move.l  (a6), DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS

***DATA check
ARDL_DST_DATA                        * down here, check #<data>
        cmp.b   #4,DEST_REGISTER
        bne     INVALID_S               * Here is the code we don't need to disassemble

ARDL_DST_DATA_BYTE
        * byte compare
        cmp.b   #BYTE,SIZE
        bne     ARDL_DST_DATA_WORD
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS

ARDL_DST_DATA_WORD
        cmp.b   #WORD,SIZE
        bne     ARDL_DST_DATA_LONG
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS

ARDL_DST_DATA_LONG
        cmp.b   #LONG,SIZE
        bne     INVALID_S
        move.l  (a6), DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS 
* Address extension is not required
ARDL_FINAL_RTS
        rts

* -----------------------------------------------
***************************************************

***************************************************
* -----------------------------------------------
* Condition address decision load
* BCC BGT BLE
** Using DATA_EIGHT_BIT, SRC_NUMBER_DATA
CONDIITON_DECISION_LOAD
        cmp.b           #$00,DATA_EIGHT_BIT
        beq             CDL_16
        cmp.b           #$FF,DATA_EIGHT_BIT
        beq             CDL_32

        rts
CDL_16
        ** 16 bit displacement
        move.w          (a6)+,SRC_NUMBER_DATA
        rts
CDL_32
        ** 32 bit displacement
        move.l          (a6)+,SRC_NUMBER_DATA
        rts

* -----------------------------------------------
***************************************************

        ** Based on mode setting, print out the instruction.
***************************************************************
* -> Initial two ea out mode
INITIAL_TWO_EA_LOAD_OUT
ITELO_Dn
    cmp.b       #0,SRC_MODE
    bne         ITELO_AN

    *** compare to d0 ~ d7
ITELO_D0
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_D1
    bsr         D_ZERO_S
    bra         ITELO_FINAL
ITELO_D1
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_D2
    bsr         D_ONE_S
    bra         ITELO_FINAL
ITELO_D2
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_D3
    bsr         D_TWO_S
    bra         ITELO_FINAL
ITELO_D3
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_D4
    bsr         D_THREE_S
    bra         ITELO_FINAL
ITELO_D4
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_D5
    bsr         D_FOUR_S
    bra         ITELO_FINAL
ITELO_D5
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_D6
    bsr         D_FIVE_S
    bra         ITELO_FINAL
ITELO_D6
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_D7
    bsr         D_SIX_S
    bra         ITELO_FINAL
ITELO_D7
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         D_SEVEN_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

ITELO_AN
    cmp.b       #1,SRC_MODE
    bne         ITELO_AN_P

    *** compare to a0 ~ a7
ITELO_A0
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_A1
    bsr         A_ZERO_S
    bra         ITELO_FINAL
ITELO_A1
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_A2
    bsr         A_ONE_S
    bra         ITELO_FINAL
ITELO_A2
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_A3
    bsr         A_TWO_S
    bra         ITELO_FINAL
ITELO_A3
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_A4
    bsr         A_THREE_S
    bra         ITELO_FINAL
ITELO_A4
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_A5
    bsr         A_FOUR_S
    bra         ITELO_FINAL
ITELO_A5
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_A6
    bsr         A_FIVE_S
    bra         ITELO_FINAL
ITELO_A6
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_A7
    bsr         A_SIX_S
    bra         ITELO_FINAL
ITELO_A7
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         A_SEVEN_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

ITELO_AN_P
    cmp.b       #2,SRC_MODE
    bne         ITELO_AN_P_P

    *** compare to a0 ~ a7
ITELO_A0_P
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_A1_P
    bsr         A_ZERO_P_S
    bra         ITELO_FINAL
ITELO_A1_P
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_A2_P
    bsr         A_ONE_P_S
    bra         ITELO_FINAL
ITELO_A2_P
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_A3_P
    bsr         A_TWO_P_S
    bra         ITELO_FINAL
ITELO_A3_P
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_A4_P
    bsr         A_THREE_P_S
    bra         ITELO_FINAL
ITELO_A4_P
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_A5_P
    bsr         A_FOUR_P_S
    bra         ITELO_FINAL
ITELO_A5_P
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_A6_P
    bsr         A_FIVE_P_S
    bra         ITELO_FINAL
ITELO_A6_P
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_A7_P
    bsr         A_SIX_P_S
    bra         ITELO_FINAL
ITELO_A7_P
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         A_SEVEN_P_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

ITELO_AN_P_P
    cmp.b       #3,SRC_MODE
    bne         ITELO_AN_P_M

    *** compare to a0 ~ a7
ITELO_A0_P_P
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_A1_P_P
    bsr         A_ZERO_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A1_P_P
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_A2_P_P
    bsr         A_ONE_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A2_P_P
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_A3_P_P
    bsr         A_TWO_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A3_P_P
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_A4_P_P
    bsr         A_THREE_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A4_P_P
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_A5_P_P
    bsr         A_FOUR_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A5_P_P
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_A6_P_P
    bsr         A_FIVE_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A6_P_P
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_A7_P_P
    bsr         A_SIX_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A7_P_P
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         A_SEVEN_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

ITELO_AN_P_M
    cmp.b       #4,SRC_MODE
    bne         ITELO_ADR_WLD

    *** compare to a0 ~ a7
ITELO_A0_P_M
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_A1_P_M
    bsr         MINUS_S
    bsr         A_ZERO_P_S
    bra         ITELO_FINAL
ITELO_A1_P_M
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_A2_P_M
    bsr         MINUS_S
    bsr         A_ONE_P_S
    bra         ITELO_FINAL
ITELO_A2_P_M
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_A3_P_M
    bsr         MINUS_S
    bsr         A_TWO_P_S
    bra         ITELO_FINAL
ITELO_A3_P_M
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_A4_P_M
    bsr         MINUS_S
    bsr         A_THREE_P_S
    bra         ITELO_FINAL
ITELO_A4_P_M
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_A5_P_M
    bsr         MINUS_S
    bsr         A_FOUR_P_S
    bra         ITELO_FINAL
ITELO_A5_P_M
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_A6_P_M
    bsr         MINUS_S
    bsr         A_FIVE_P_S
    bra         ITELO_FINAL
ITELO_A6_P_M
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_A7_P_M
    bsr         MINUS_S
    bsr         A_SIX_P_S
    bra         ITELO_FINAL
ITELO_A7_P_M
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         MINUS_S
    bsr         A_SEVEN_P_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
* WORD, LONG, DATA, (XXX).W (XXX).L #<data>
ITELO_ADR_WLD
    cmp.b       #7,SRC_MODE
    bne         ITELO_INVALID
ITELO_ADR_WLD_WORD
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_ADR_WLD_LONG
    bsr         DOLLAR_S

    cmp.w       #$8000,SRC_NUMBER_DATA
    bcs         ITELO_AWW_OUT
ITELO_AWW_FFFF
    move.w      #$ffff,WORD_OUT
    bsr         WORD_OUT_S
ITELO_AWW_OUT
    move.w      SRC_NUMBER_DATA,WORD_OUT
    bsr         WORD_OUT_S

    bra         ITELO_FINAL


ITELO_ADR_WLD_LONG
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_ADR_WLD_DATA
    bsr         DOLLAR_S

    movem.l     d0,-(sp)

    cmp.w       #$0000,SRC_NUMBER_DATA
    beq         ITELO_ADR_WLD_L_NPRCD
ITELO_ADR_WLD_L_PRCD
    move.w      SRC_NUMBER_DATA,WORD_OUT
    bsr         WORD_OUT_S
ITELO_ADR_WLD_L_NPRCD
    move.l      SRC_NUMBER_DATA,d0
    move.w      d0,WORD_OUT
    bsr         WORD_OUT_S

    movem.l     (sp)+,d0

    bra         ITELO_FINAL
ITELO_ADR_WLD_DATA
    ** Immediate data compare
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         HASH_S
    bsr         DOLLAR_S

ITELO_AWD_WORD
    ** WORD SIZE
    cmp.b       #WORD,SIZE
    bne         ITELO_AWD_LONG
    move.w      SRC_NUMBER_DATA,WORD_OUT
    bsr         WORD_OUT_S
    bra         ITELO_FINAL
ITELO_AWD_LONG
    ** LONG SIZE
    cmp.b       #LONG,SIZE
    bne         ITELO_AWD_BYTE

    movem.l     d0,-(sp)

    move.w      SRC_NUMBER_DATA,WORD_OUT
    bsr         WORD_OUT_S
    move.l      SRC_NUMBER_DATA,d0
    move.w      d0,WORD_OUT
    bsr         WORD_OUT_S

    movem.l     (sp)+,d0

    bra         ITELO_FINAL

ITELO_AWD_BYTE
    ** BYTE SIZE
    cmp.b       #BYTE,SIZE
    bne         ITELO_INVALID

    movem.w     d0,-(sp)

    move.w      SRC_NUMBER_DATA,d0
    move.b      d0,BYTE_OUT
    bsr         BYTE_OUT_S

    movem.w     (sp)+,d0

    bra         ITELO_FINAL

ITELO_INVALID
    bra         INVALID_S
ITELO_FINAL
    rts

* -> Initial two ea out mode
***************************************************************

***************************************************************
* -> Initial four ea out mode
INITIAL_FOUR_EA_LOAD_OUT
    movem.l     d0-d2,-(sp)

    bsr         INITIAL_TWO_EA_LOAD_OUT             * Source out

    bsr         COMMA_S

    move.b      DEST_REGISTER,d0
    move.b      DEST_MODE,d1
    move.l      DST_NUMBER_DATA,d2

    move.b      DEST_REGISTER,SRC_REGISTER          * Destination out
    move.b      DEST_MODE,SRC_MODE
    move.l      DST_NUMBER_DATA,SRC_NUMBER_DATA
    movem.l     (sp)+,d0-d2
    bsr         INITIAL_TWO_EA_LOAD_OUT

    rts

* -> Initial four ea out mode
***************************************************************


***************************************************************
* -> Memory structure | Register | Opmode | EA Mode | EA register |
FOUR_OPCODE_LOAD_OUT
        * Invalid common operation
        ** Setting the size
        move.b          DEST_MODE,SIZE
        bsr             SIZE_CONVERT_TYPE_TWO

        * This is valid OR so printout OR.
        bsr             SIZE_TAG_S
FOLO_DN

        * Check for OR instruction <ea> V Dn -> Dn format
        cmp.b           #4,DEST_MODE
        bcc             FOLO_EA

        * Set dest mode as register (Deception!!)
        move.b          #$00,DEST_MODE

        * Based on deception, load memory
        bsr             ADDRESS_READ_DECISION_LOAD

        * Print out
        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE
        rts
FOLO_EA
        * OR instruction and Dn V <ea> -> <ea> format

        * back up the Dest_register
        move.b          DEST_REGISTER,d7
        move.b          SRC_MODE,DEST_MODE
        move.b          SRC_REGISTER,DEST_REGISTER

        move.b          #$00,SRC_MODE
        move.b          d7,SRC_REGISTER

        * Based on deception, load memory
        bsr             ADDRESS_READ_DECISION_LOAD

        * Print out
        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE

        rts
FOLO_INVALID
        bra             INVALID_S

* -> Memory structure | Register | Opmode | EA Mode | EA register |
*******************************************************************


*******************************************************************
* Check whether current instruction is valid or not
IS_VALID

IV_SRC
    cmp.b               #5,SRC_MODE
    beq                 IV_INVALID
    cmp.b               #6,SRC_MODE
    beq                 IV_INVALID

    cmp.b               #4,SRC_MODE
    bls                 IV_SRC_REG_CK1
    cmp.b               #7,SRC_MODE
    beq                 IV_SRC_REG_CK2             

IV_SRC_REG_CK1
    cmp.b               #7,SRC_REGISTER
    bls                 IV_DST
    bra                 IV_INVALID
IV_SRC_REG_CK2
    cmp.b               #2,SRC_REGISTER
    beq                 IV_INVALID
    cmp.b               #3,SRC_REGISTER
    beq                 IV_INVALID

    bra                 IV_DST

IV_DST * Destination check
    cmp.b               #5,DEST_MODE
    beq                 IV_INVALID
    cmp.b               #6,DEST_MODE
    beq                 IV_INVALID

    cmp.b               #4,DEST_MODE
    bls                 IV_DST_REG_CK1
    cmp.b               #7,DEST_MODE
    beq                 IV_DST_REG_CK2   

IV_DST_REG_CK1
    cmp.b               #7,DEST_REGISTER
    bls                 IV_FINAL
    bra                 IV_INVALID
IV_DST_REG_CK2
    cmp.b               #2,DEST_REGISTER
    beq                 IV_INVALID
    cmp.b               #3,DEST_REGISTER
    beq                 IV_INVALID

    bra                 IV_FINAL
IV_FINAL
        rts
IV_INVALID
    bra                 INVALID_S

* Check whether current instruction is valid or not
*******************************************************************


***************************************************************
* Load instruction to print out

**> Loaed instruction to print out
***************************************************************

** Reference Size 'Converting Table.txt'
*

* SIZE_CONVERT_TYPE_ONE
* Size converting operation
SIZE_CONVERT_TYPE_ONE
****Putting size into the destined size
SCTO_BYTE
        cmp.b           #0,SIZE
        bne             SCTO_WORD
        bsr             SIZE_BYTE
        rts
SCTO_WORD
        cmp.b           #1,SIZE
        bne             SCTO_LONG
        bsr             SIZE_WORD
        rts
SCTO_LONG
        cmp.b           #2,SIZE
        bne             SCTO_INVALID
        bsr             SIZE_LONG
        rts
SCTO_INVALID                           ** Invalid size instruction.
        bra             INVALID_S
        rts


* Size converting type two
SIZE_CONVERT_TYPE_TWO
**** Putting size into the destined size

        ** Byte case %000, %100
        cmp.b   #0,SIZE
        beq     SCTT_BYTE
        cmp.b   #4,SIZE
        beq     SCTT_BYTE

        ** Word case %001, %101
        cmp.b   #1,SIZE
        beq     SCTT_WORD
        cmp.b   #5,SIZE
        beq     SCTT_WORD

        ** Long case %010, %110
        cmp.b   #2,SIZE
        beq     SCTT_LONG
        cmp.b   #6,SIZE
        beq     SCTT_LONG

** Set size byte
SCTT_BYTE
        bsr     SIZE_BYTE
        rts
** Set size word
SCTT_WORD
        bsr     SIZE_WORD
        rts
** Set size long
SCTT_LONG
        bsr     SIZE_LONG
        rts
** Invalid case
SCTT_INVALID
        bra     INVALID_S
        rts

* Set 'SIZE'
SIZE_BYTE
        move.b          #BYTE,SIZE
        rts
SIZE_WORD
        move.b          #WORD,SIZE
        rts
SIZE_LONG
        move.b          #LONG,SIZE
        rts

*EXIT
EXIT_PROGRAM
        SIMHALT


**************************************************************************************************
* Global Variable
BYTE_OUT                ds.b            $1      Byte out reserved variable
WORD_OUT                ds.w            $1      Word out reserved variable
READ_FROM               ds.l            $1      Variable to save read From (Inclusive)
READ_TO                 ds.l            $1      Varaible to save read To (Inclusive)
Current_Read            ds.l            $1      Varaible to save current read

* Variable specific for movem
REGISTER_LIST_MASK      ds.w            $1      Register list Mask Variable for MOVEM

* Bit Conversion reserved Area
CONVERSOIN_RESERVED     ds.b            $1

** 8 bit instruction saving place
DATA_EIGHT_BIT          ds.b            $1

** 3 bit instruction saving place
DEST_REGISTER           ds.b            $1
DEST_MODE               ds.b            $1
SRC_MODE                ds.b            $1
SRC_REGISTER            ds.b            $1

*REGISTER                ds.b            $1
*COUNT_REGISTER          ds.b            $1

* Long data saving place for src and dst
SRC_NUMBER_DATA         ds.l            $1
DST_NUMBER_DATA         ds.l            $1

** 2 bit instructoin savin place
*** 01 -- BYTE operation
*** 11 -- word operation
*** 10 -- long operation
SIZE                    ds.b            $1


* Local variable invoked
* Local variable which will be invoked
INITIAL_INSTRUCTION     ds.w            $1      Initial instruction variable
MAIN_LOOP_COUNT         ds.b            $1      Loop count variable for main function

* Variables - Alphabetical
END_HEX                 ds.l        $1
FLAG                    ds.b        $1
START_HEX               ds.l        $1
STRING                  ds.b        $8
SWAP_HEX                ds.l        $1
STR_LENGTH              ds.w        $1

**************************************************************************************************



    END    START        ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
