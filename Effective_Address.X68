*-----------------------------------------------------------
* Title      : Effective_Address with opcode
* Written by : Haram, Byeonggeun, Erik
* Date       : 
* Description: this code will traverse memory. This code is
* expected to merge to Project.X68
*-----------------------------------------------------------

        *INCLUDE         'Const_Variable_Setting.x68',0

START:  org             $1000
        INCLUDE         'Const_Variable_Setting.x68',0
                * Setting the stack address.
                lea             STACK,sp 
                lea             DISASSEMBLE_FROM,a6     move value of DISASSEMLE_FROM
* From here, he need to write our disassembly code
*****************************************************************************************
* Loop 20 times, and get the user enter.
        move.b          #$00,MAIN_LOOP_COUNT
* Iteration loop start from here
MAIN_LOOP
        * Clear three bit instructions
        bsr             CLEAR_THREE_BIT_S
        bsr             CLEAR_TWO_BIT_S

        * Check for the terminal Condition.
        move.l          (a6),d7
        cmp.l           #$FFFFFFFF,d7           Terminal condition check (It will be changed later)
        beq             EXIT_PROGRAM            Terminating the program.


        * Check cycle(20) condition.
        cmp.b           #20,MAIN_LOOP_COUNT
        bge             HALT

        ** Add 1 to the cycle
        move.b          MAIN_LOOP_COUNT,d7
        addi.b          #1,d7
        move.b          d7,MAIN_LOOP_COUNT

        *TODO: DELETE THIS LATER
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


        INCLUDE         'Halt_Continue_Message.x68',0


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
        bsr             TAB
        
        cmp.b           #$00,DATA_EIGHT_BIT
        beq             MC_BCGL_FINAL_16
        cmp.b           #$FF,DATA_EIGHT_BIT
        beq             MC_BCGL_FINAL_32
        
        clr.w           d7
        move.b          DATA_EIGHT_BIT,d7
        move.w          d7,SRC_NUMBER_DATA
        add.w           d6,SRC_NUMBER_DATA

        * Deceiving Assembler
        move.b          #7,SRC_MODE
        move.b          #0,SRC_REGISTER

        bsr             INITIAL_TWO_EA_LOAD_OUT

        bra             MC_BCGL_FINAL_LAST
        
MC_BCGL_FINAL_16
        * 16 bit displacement
        ** Deceiving Assembler
        move.b          #7,SRC_MODE
        move.b          #0,SRC_REGISTER

        add.w           d6,SRC_NUMBER_DATA
        bsr             INITIAL_TWO_EA_LOAD_OUT

        bra             MC_BCGL_FINAL_LAST
MC_BCGL_FINAL_32
        * 16 bit displacement
        ** Deceiving Assembler
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
        beq             MAR_TO_ADDRESS

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
        bsr             ADDRESS_READ_DECISION_LOAD * maybe not required
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
        bsr             LSR_S
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
        btst            #8,d7
        beq             MAR_TA_ASR
MAR_TA_ASL
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID
        bsr             TAB
        bsr             ASL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE
        bra             MC_ASR_ROL_FINAL
MAR_TA_ASR
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID
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
        btst            #8,d7
        beq             MAR_TA_LSR

MAR_TA_LSL
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID
        bsr             TAB
        bsr             LSL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL
MAR_TA_LSR
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID
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
        btst            #8,d7
        beq             MAR_TA_ROR
MAR_TA_ROL
        bsr             ADDRESS_READ_DECISION_LOAD
        *bsr             IS_VALID
        bsr             TAB
        bsr             ROL_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             INITIAL_TWO_EA_LOAD_OUT
        bsr             NEWLINE

        bra             MC_ASR_ROL_FINAL
MAR_TA_ROR
        bsr             ADDRESS_READ_DECISION_LOAD
        bsr             IS_VALID
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
** Sub-functions for Mnemonics
** ----------------------------------------


* -------------------------------------------------------------------
* Address out instruction
*********************************************
* Read 8 character from the address.
* for(int i =0; i<8; i++), and i = d0
ADDRESS_OUT
    clr         d0
    move.l      a6,d5
ADDRESS_OUT_LOOP_1
    cmp.b       #$08,d0                 i=8 Break statement
    bge         ADDRESS_OUT_EXIT_1
    addi.b      #$01,d0                 i++
    
    * Getting only one character
    move.b      d5,d4
    bclr        #4,d4
    bclr        #5,d4
    bclr        #6,d4
    bclr        #7,d4
    
    * Getting next character
    ror.l       #4,d5
    
    * Save the Character at stack
    movem.w     d4,-(sp)
    
    bra         ADDRESS_OUT_LOOP_1
*********************************************
ADDRESS_OUT_EXIT_1  
    
    clr         d7
ADDRESS_OUT_LOOP_2
    cmp.b       #$08,d7
    bge         ADDRESS_OUT_EXIT_2
    addi.b      #$01,d7
    clr.l       d0
    movem.w     (sp)+,d4
    move.b      d4,d1
    addi.b      #$30,d1
    
    cmp.b       #$3a,d1
    blo         ADDRESS_OUT_OUT
    addi.b      #7,d1
    
ADDRESS_OUT_OUT    
    move.b      #6,d0
    trap        #15

    
    bra         ADDRESS_OUT_LOOP_2
    
ADDRESS_OUT_EXIT_2
    rts

* Address out instruction end


* -------------------------------------------------------------------
* a5 word size out
* Read 4 character from the address.
* for(int i =0; i<4; i++), and i = d0
WORD_OUT_S
        movem.w         d6-d7,-(sp)
        clr             d7
WOS_LOOP
        move.w          WORD_OUT,d6

        move.b          WORD_OUT,BYTE_OUT
        bsr             BYTE_OUT_S

        move.b          D6,BYTE_OUT
        bsr             BYTE_OUT_S
        

WOS_FINAL
        movem.w         (sp)+,d6-d7
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
        movem.w     d0-d7/a0-a5,-(sp)
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
        movem.w     (sp)+,d0-d7/a0-a5           Move back the stack
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
        INCLUDE         'Opcode_print.x68',
        

        ** Read Opcode from Initial Instruction.
        INCLUDE         'Instruction_OPCODE_DECODE.x68',0

        ** Decide whether to read more address or not.
        INCLUDE         'Address_Read_Decision_Load.x68',0

        ** Based on mode setting, print out the instruction.
        INCLUDE         'Instruction_Operation_Out.x68',0

***************************************************************
* Load instruction to print out

**> Loaed instruction to print out
***************************************************************

        INCLUDE 'Size_Converting.x68',0

*EXIT
EXIT_PROGRAM
        SIMHALT


        INCLUDE 'Variable.x68',0

        *TODO: Delete this later
        INCLUDE 'Test_Code.x68',0


    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
