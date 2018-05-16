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
        cmp.l           #$FFFFFFFF,d7           Terminal condition check
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

        * Show Initial Instruction
        *bsr             TAB
        *move.w          INITIAL_INSTRUCTION,WORD_OUT
        *bsr             WORD_OUT_S

        * Save Initial instruction to d7 register
        move.w          INITIAL_INSTRUCTION,d7
        
        *-------------------
        * addi, subi
        cmp.w           #$1000,D7
        blo             MC_ADDI_SUBI

        * move.b
        cmp.w           #$2000,D7
        blo             MC_MOVE_B

        * move.l, movea.l
        cmp.w           #$3000,D7
        blo             MC_MOVE_L_MOVEA_L

        * move.w, movea.w
        cmp.w           #$4000,D7
        blo             MC_MOVE_W_MOVEA_W

        * clr, nop, rts, jsr, movem, lea
        cmp.w           #$5000,D7
        blo             MC_CLR_LEA

        * addq      
        cmp.w           #$6000,D7
        blo             MC_ADDQ

        * bcc
        cmp.w           #$7000,D7
        blo             MC_BCC

        * moveq
        cmp.w           #$8000,D7
        blo             MC_MOVEQ

        * or, divu
        cmp.w           #$9000,D7
        blo             MC_OR_DIVU

        * sub
        cmp.w           #$a000,D7
        blo             MC_SUB

        * Invalid input, show message
        cmp.w          #$b000,d7
        blo             INVALID_S             

        * cmp
        cmp.w           #$c000,D7
        blo             MC_COMP
        
        * and, muls, mulu
        cmp.w           #$d000,D7
        blo             MC_AND_MULU

        * add, adda
        cmp.w           #$e000,D7
        blo             MC_ADD_ADDA

        * asr, asl, lsr, lsl, ror, rol
        cmp.w           #$f000,D7
        blo             MC_ASR_ROL
        
        
        bra             MAIN_LOOP

* Iteration end here
*******************************************************************************************


        INCLUDE         'Halt_Continue_Message.x68',0


*******************************************************************************************
* Mnemonic disassmbly start here

* Addi Subi
MC_ADDI_SUBI
        bsr             TAB
        bsr             ADDI_S
        bsr             NEWLINE

        bra             MAIN_LOOP

*Mnemonic: move.b
MC_MOVE_B
        bsr SIZE_BYTE
        bsr INITIAL_FOUR_EA_LOAD
        bsr ADDRESS_OPERAND_DESTINATION_OUT

        bsr             TAB
        bsr             MOVE_B_S                Print out the instruction.
        bsr             NEWLINE                 Newline
        *bsr             DEST_SRC_MD             Anaylize and print.
        *bsr             D_ZERO
        *bsr             NEWLINE
        bra             MAIN_LOOP

* Mnemonic: move.l, movea.l
MC_MOVE_L_MOVEA_L
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: move.w
MC_MOVE_W_MOVEA_W
        *move.b          #$11,d7                 mark 11 for byte operation.
        
        bsr             TAB
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
        bne             NOT_CLR
        bsr             INITIAL_TWO_EA_LOAD_SIZE
        bsr             SIZE_CONVERT_TYPE_ONE
        bsr             ADDRESS_OPERAND_DESTINATION_OUT
        bsr             TAB
        bsr             CLR_S
        bsr             SIZE_TAG_S
        bsr             TAB

        bsr             NEWLINE
        bra             MAIN_LOOP
        ** todo: work here
NOT_CLR
        * Check 'JSR' instruction
NOT_JSR
        * Check 'movem' instruction
NOT_MOVEM
        * Check 'LEA' instruction
NOT_LEA
        * Show error

* Mnemonic: addq
MC_ADDQ
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: bcc, bgt, ble
MC_BCC
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: moveq, or
MC_MOVEQ
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: or, divu
MC_OR_DIVU
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: sub
MC_SUB
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: cmp
MC_COMP
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: and
MC_AND_MULU
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: add, adda
MC_ADD_ADDA
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: asr, asl, lsr, lsl, ror, rol
MC_ASR_ROL
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

** ----------------------------------------
** Sub-functions for Mnemonics

*** Clear unnecessary bit --------------------------
**** Left only three bit ****
THREE_BIT_ONLY
                movem.l         d7,-(sp)
                move.b          CONVERSOIN_RESERVED,d7
                bclr            #$07,d7
                bclr            #$06,d7
                bclr            #$05,d7
                bclr            #$04,d7
                bclr            #$03,d7
                move.b          d7,CONVERSOIN_RESERVED
                movem.l         (sp)+,d7
                rts

**** Left only two bit ****
TWO_BIT_ONLY
                movem.l         d7,-(sp)
                move.b          CONVERSOIN_RESERVED,d7
                bclr            #$07,d7
                bclr            #$06,d7
                bclr            #$05,d7
                bclr            #$04,d7
                bclr            #$03,d7
                bclr            #$02,d7
                move.b          d7,CONVERSOIN_RESERVED
                movem.l         (sp)+,d7
                rts

**** Left only One bit ****
ONE_BIT_ONLY
                movem.l         d7,-(sp)
                move.b          CONVERSOIN_RESERVED,d7
                bclr            #$07,d7
                bclr            #$06,d7
                bclr            #$05,d7
                bclr            #$04,d7
                bclr            #$03,d7
                bclr            #$02,d7
                bclr            #$01,d7
                move.b          d7,CONVERSOIN_RESERVED
                movem.l         (sp)+,d7
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
    clr         d0
    movea.w     WORD_OUT,a5
    move.l      a5,d5
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
    rts



* a5 word size out end
* -------------------------------------------------------------------

* Mnemonic disassembly end here
*******************************************************************************************

*For the instruction 


******************************************************************************
* This is to minimize the typing
* Pre-defined string instructions
****************************************************************************


        INCLUDE 'Opcode_print.x68',0

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

ADDRESS_OPERAND_DESTINATION_OUT
AODO_Source
        cmp.b   #7,SRC_MODE
        bne     AODO_DST     * No source Data memory value
AODO_SOURCE_WORD
        * Word compare
        cmp.b   #0,SRC_REGISTER
        bne     AODO_SOURCE_LONG        * not word size
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST
AODO_SOURCE_LONG                        * down here, check long size
        cmp.b   #1,SRC_REGISTER
        bne     AODO_SOURCE_DATA        * not Long size
        move.l  (a6), SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST

***DATA check
AODO_SOURCE_DATA                        * down here, check #<data>
        cmp.b   #4,SRC_REGISTER
        bne     INVALID_S               * Here is the code we don't need to disassemble

AODO_SOURCE_DATA_BYTE
        * byte compare
        cmp.b   #BYTE,SIZE
        bne     AODO_SOURCE_DATA_WORD
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST

AODO_SOURCE_DATA_WORD
        cmp.b   #WORD,SIZE
        bne     AODO_SOURCE_DATA_LONG
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST

AODO_SOURCE_DATA_LONG
        cmp.b   #LONG,SIZE
        bne     INVALID_S
        move.l  (a6), SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST 


AODO_DST                 * Address extension for source is not required
        cmp.b   #7,DEST_MODE
        bne     AODO_FINAL_RTS

AODO_DST_WORD
        * Word compare
        cmp.b   #0,DEST_REGISTER
        bne     AODO_DST_LONG        * not word size
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS
AODO_DST_LONG                        * down here, check long size
        cmp.b   #1,DEST_REGISTER
        bne     AODO_DST_DATA        * not Long size
        move.l  (a6), DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS

***DATA check
AODO_DST_DATA                        * down here, check #<data>
        cmp.b   #4,DEST_REGISTER
        bne     INVALID_S               * Here is the code we don't need to disassemble

AODO_DST_DATA_BYTE
        * byte compare
        cmp.b   #BYTE,SIZE
        bne     AODO_DST_DATA_WORD
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS

AODO_DST_DATA_WORD
        cmp.b   #WORD,SIZE
        bne     AODO_DST_DATA_LONG
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS

AODO_DST_DATA_LONG
        cmp.b   #LONG,SIZE
        bne     INVALID_S
        move.l  (a6), DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS 
* Address extension is not required
AODO_FINAL_RTS
        rts

* -----------------------------------------------
***************************************************

        INCLUDE 'Instruction_OPCODE_DECODE.x68',0

***************************************************************
* Load instruction to print out

**> Loaed instruction to print out
***************************************************************

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

* Clear 3 bit instructoins
CLEAR_THREE_BIT_S
        clr.b   EA_MODE
        *clr.b   OP_MODE
        *clr.b   EA_REGISTER
        clr.b   DEST_REGISTER
        clr.b   DEST_MODE
        clr.b   SRC_MODE
        clr.b   SRC_REGISTER
        clr.b   REGISTER
        clr.b   COUNT_REGISTER
        rts

* Clear 2 bit instruction
CLEAR_TWO_BIT_S
        clr.b   SIZE
        rts

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
