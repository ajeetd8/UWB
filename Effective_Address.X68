*-----------------------------------------------------------
* Title      : Effective_Address with opcode
* Written by : Haram, Byeonggeun, Erik
* Date       : 
* Description: this code will traverse memory. This code is
* expected to merge to Project.X68
*-----------------------------------------------------------

        INCLUDE         'Const_Variable_Setting.x68',0

START:  org             $1000
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
        * addi, subi
        cmp.w           #$1000,INITIAL_INSTRUCTION
        blo             MC_ADDI_SUBI

        * move.b
        cmp.w           #$2000,INITIAL_INSTRUCTION
        blo             MC_MOVE_B

        * move.l, movea.l
        cmp.w           #$3000,INITIAL_INSTRUCTION
        blo             MC_MOVE_L_MOVEA_L

        * move.w, movea.w
        cmp.w           #$4000,INITIAL_INSTRUCTION
        blo             MC_MOVE_W_MOVEA_W

        * clr, nop, rts, jsr, movem, lea
        cmp.w           #$5000,INITIAL_INSTRUCTION
        blo             MC_CLR_LEA

        * addq      
        cmp.w           #$6000,INITIAL_INSTRUCTION
        blo             MC_ADDQ

        * bcc
        cmp.w           #$7000,INITIAL_INSTRUCTION
        blo             MC_BCC

        * moveq
        cmp.w           #$8000,INITIAL_INSTRUCTION
        blo             MC_MOVEQ

        * or, divu
        cmp.w           #$9000,INITIAL_INSTRUCTION
        blo             MC_OR_DIVU

        * sub
        cmp.w           #$a000,INITIAL_INSTRUCTION
        blo             MC_SUB

        * Invalid input, show message
        cmp.w          #$b000,INITIAL_INSTRUCTION
        blo             INVALID_S             

        * cmp
        cmp.w           #$c000,INITIAL_INSTRUCTION
        blo             MC_COMP
        
        * and, muls, mulu
        cmp.w           #$d000,INITIAL_INSTRUCTION
        blo             MC_AND_MULU

        * add, adda
        cmp.w           #$e000,INITIAL_INSTRUCTION
        blo             MC_ADD_ADDA

        * asr, asl, lsr, lsl, ror, rol
        cmp.w           #$f000,INITIAL_INSTRUCTION
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
        bsr             TAB

MMLML_MOVEA_OUT
        cmp.b           #1,DEST_MODE
        bne             MMLML_MOVE_OUT
        bsr             MOVEA_S
        bra             MMLML_MOVE_OPERAND
MMLML_MOVE_OUT
        bsr             MOVE_S
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
        
        bsr             TAB
        bsr             LEA_S
        bsr             TAB

        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE
        bra             MAIN_LOOP

MCL_MOVEM
MCL_INVALID
        bra             INVALID_S

        * Check 'movem' instruction
        * Show error

* Mnemonic: addq
MC_ADDQ
        
        bsr             TAB
        bsr             NEWLINE                 Newline
MCAQ_INVALID
        bra             INVALID_S

* Mnemonic: bcc, bgt, ble
MC_BCC
        
        bsr             TAB
        bsr             NEWLINE                 Newline
MCBC_INVALID
        bra             INVALID_S

* Mnemonic: moveq
MC_MOVEQ
        bra             MCMQ_INVALID
        bsr             TAB
        bsr             NEWLINE                 Newline
MCMQ_INVALID
        bra             INVALID_S

* Mnemonic: or, divu
MC_OR_DIVU
MCOD_DIVU
        * Check for DIVU instruction
        bsr             INITIAL_FOUR_EA_LOAD
        cmp.b           #3,DEST_MODE
        bne             MCOD_INVALID
        bsr             SIZE_WORD
        move.b          #$00,DEST_MODE
        bsr             ADDRESS_READ_DECISION_LOAD

        bsr             TAB
        bsr             DIVU_S
        bsr             SIZE_TAG_S

        bsr             TAB
        bsr             INITIAL_FOUR_EA_LOAD_OUT

        bsr             NEWLINE
        bra             MAIN_LOOP

MCOD_OR         * need to work on decode
        * Check for OR instruction
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP
MCOD_INVALID
        bra             INVALID_S

* Mnemonic: sub
MC_SUB
        bra             INVALID_S
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: cmp
MC_COMP
        bra             INVALID_S
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: and, muls, mulu
MC_AND_MULU
MAM_MULS
        * Check for MULS
        bsr             INITIAL_FOUR_EA_LOAD
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
        bsr             CLEAR_THREE_BIT_S
        bsr             INITIAL_FOUR_EA_LOAD
        cmp.b           #3,DEST_MODE
        bne             MAM_INVALID
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
        bra             MAIN_LOOP
MAM_INVALID
        bra             INVALID_S

* Mnemonic: add, adda
MC_ADD_ADDA
        bra             INVALID_S
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: asr, asl, lsr, lsl, ror, rol
MC_ASR_ROL
        bra             INVALID_S
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

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
    movem.w     d0-d7/a0-a5,-(sp)
    clr         d0
    move.w     WORD_OUT,D5
WORD_OUT_LOOP_1
    cmp.b       #$04,d0                 i=8 Break statement
    bge         WORD_OUT_EXIT_1
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
    
    bra         WORD_OUT_LOOP_1
*********************************************
WORD_OUT_EXIT_1  
    clr         d7
WORD_OUT_LOOP_2
    cmp.b       #$04,d7
    bge         WORD_OUT_EXIT_2
    addi.b      #$01,d7
    clr.l       d0
    movem.w     (sp)+,d4
    move.b      d4,d1
    addi.b      #$30,d1
    
    cmp.b       #$3a,d1
    blo         WORD_OUT_OUT
    addi.b      #7,d1
    
WORD_OUT_OUT    
    move.b      #6,d0
    trap        #15

    
    bra         WORD_OUT_LOOP_2
    
WORD_OUT_EXIT_2
        movem.w     (sp)+,d0-d7/a0-a5
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
    clr         d0
    move.b     BYTE_OUT,d5
BYTE_OUT_LOOP_1
    cmp.b       #$02,d0
    bge         BYTE_OUT_EXIT_1
    addi.b      #$01,d0

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

    bra         BYTE_OUT_LOOP_1
*  - - - - - - - - - - - - - - - - -
BYTE_OUT_EXIT_1
    clr         d7
BYTE_OUT_LOOP_2
    cmp.b       #$02,d7
    bge         BYTE_OUT_EXIT_2
    addi.b      #$01,d7
    clr.l       d0
    movem.w     (sp)+,d4
    move.b      d4,d1
    addi.b      #$30,d1
    
    cmp.b       #$3a,d1
    blo         BYTE_OUT_OUT
    addi.b      #7,d1

BYTE_OUT_OUT
    move.b      #6,d0
    trap        #15

    bra         BYTE_OUT_LOOP_2

BYTE_OUT_EXIT_2
        movem.w     (sp)+,d0-d7/a0-a5
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
