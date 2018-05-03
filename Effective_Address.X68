*-----------------------------------------------------------
* Title      : Effective_Address with opcode
* Written by : Haram, Byeonggeun, Erik
* Date       : 
* Description: this code will traverse memory. This code is
* expected to merge to Project.X68
*-----------------------------------------------------------

STACK                   equ         $100000
DISASSEMBLE_FROM        equ         $7000
CR                      equ         $0d
LF                      equ         $0a  

START:  org             $1000
        * Setting the stack address.
        lea             STACK,sp 
        lea             DISASSEMBLE_FROM,a6     move value of DISASSEMLE_FROM
* From here, he need to write our disassembly code

*****************************************************************************************
* Iteration loop start from here
LOOP
        * Check for the terminal Condition.
        move.l          (a6),d7
        cmp.l           #$FFFFFFFF,d7           Terminal condition check
        beq             DONE                    Terminating the program.
        
        * If this is not terminal condition.
        * Read word from current memory
        move.w          (a6)+,d6
        
        *-------------------
        * addi, subi
        * 
        *cmp.w           #$1000,d6
        *blo

        * move.b
        cmp.w           #$2000,d6
        blo             MC_MOVE_B

        cmp.w           #$3000,d6
        cmp.w           #$4000,d6
        cmp.w           #$5000,d6
        blo             MC_CLR_LEA            
        cmp.w           #$6000,d6
        cmp.w           #$7000,d6
        cmp.w           #$8000,d6
        cmp.w           #$9000,d6
        cmp.w           #$a000,d6
        
        cmp.w           #$d000,d6
        cmp.w           #$e000,d6
        cmp.w           #$f000,d6
        
        * Read word by words.
        * Every loop is incrementing by word
        
        
        bra             LOOP

* Iteration end here
*******************************************************************************************

*******************************************************************************************
* Mnemonic disassmbly start here

*Mnemonic: move.b
MC_MOVE_B
        move.b          #$01,d7                 mark 01 for byte operation.
        bsr             MOVE_B_S                Print out the instruction.
        bsr             TAB
        bsr             DEST_SRC_MD             Anaylize and print.
        bsr             D_ZERO
        bsr             NEWLINE
        
        
        
        SIMHALT
        bra             LOOP

* Mnemonic: move.l
MC_MOVE_L
        move.b          #$10,d7                 mark 10 for long operation.
        SIMHALT

* Mnemonic: movea.l
MC_MOVEA_L
        SIMHALT

* Mnemonic: move.w
MC_MOVE_W
        move.b          #$11,d7                 mark 11 for byte operation.
        SIMHALT

* Mnemonic: movea.w
MC_MOVA_W
        SIMHALT

* Mnemonic: clr, nop, rts, jsr, movem, lea
MC_CLR_LEA
        bsr             RTS_S                           * This is test code to see whether this is working or not!!!
        SIMHALT

* Mnemonic: addq
MC_ADDQ
        SIMHALT

* Mnemonic: bcc, bgt, ble
MC_BCC
        SIMHALT

* Mnemonic: moveq, or
MC_MOVEQ
        SIMHALT

* Mnemonic: or, divu
MC_OR_DIVU
        SIMHALT

* Mnemonic: sub
MC_SUB
        SIMHALT

* Mnemonic: cmp
MC_COMP
        SIMHALT

* Mnemonic: and
MC_AND_MULU
        SIMHALT

* Mnemonic: add, adda
MC_ADD_ADDA
        SIMHALT

* Mnemonic: asr, asl, lsr, lsl, ror, rol
MC_ASR_ROL
        SIMHALT

* ----------------------------------------
** Sub-functions for Mnemonics

*** subfunction for move.b, move.l, move.w
DEST_SRC_MD                                     * Dest to source & mode
        * d0 : Destination Value 
        * d1 : Source Value
        * d2 : Dest Register
        * d3 : Dest Mode
        * d4 : Src Mode
        * d5 : Src Register

***********************************************
* initialize d2 ~ d5        
        move.b          d6,d5
        bclr            #3,d5
        bclr            #4,d5
        bclr            #5,d5
        bclr            #6,d5
        bclr            #7,d5
        ror.w           #3,d6
        
        move.b          d6,d4
        bclr            #3,d4
        bclr            #4,d4
        bclr            #5,d4
        bclr            #6,d4
        bclr            #7,d4
        ror.w           #3,d6

        move.b          d6,d3
        bclr            #3,d3
        bclr            #4,d3
        bclr            #5,d3
        bclr            #6,d3
        bclr            #7,d3
        ror.w           #3,d6

        move.b          d6,d2
        bclr            #3,d2
        bclr            #4,d2
        bclr            #5,d2
        bclr            #6,d2
        bclr            #7,d2
        ror.w           #3,d6
        ror.w           #4,d6
**********************************************

***********************************************
* Check Whether there is following memory address or not. (Source)
        cmp.b           #%0111,d4
        bne             DSM_SRC_N_SRC_FOLLOW         No following instruction for source

        * check whether following is word size
        cmp.b           #%0000,d5               (xxx).W
        beq             DSM_SRC_LOAD_WORD
        cmp.b           #$0001,d5               (xxx).L
        beq             DSM_SRC_LOAD_LONG
        cmp.b           #%0100,d5               #<data>
        bne             DSM_SRC_N_SRC_FOLLOW    No following instruction.
        cmp.b           #$01,d7                 #<data>.b
        beq             DSM_SRC_LOAD_WORD
        cmp.b           #$11,d7                 #<data>.w
        beq             DSM_SRC_LOAD_WORD
        cmp.b           #$10,d7                 #<data>.l
        beq             DSM_SRC_LOAD_LONG

        bra            DSM_SRC_N_LONG          DEST_SRC_MD, NOT WORD

DSM_SRC_LOAD_WORD
        ** Load word size to d1
        move.w          (a6)+,d1
        bra             DSM_SRC_N_SRC_FOLLOW    Destination Trace

DSM_SRC_LOAD_LONG
        ** Load long size to d1
        move.l          (a6)+,d1
        bra             DSM_SRC_N_SRC_FOLLOW    Destination Trace

DSM_SRC_N_LONG
        * Error message
        
DSM_SRC_N_SRC_FOLLOW      * No following instruction for source (Check destination.)

***********************************************
* Check Whether there is following memory address or not. (Destination)
        cmp.b           #%0111,d3
        bne             DSM_DST_NE      DEST_SRC_MD, NOT EQUAL, DESTINATION

        cmp.b           #%0000,d2
        beq             DSM_DST_LOAD_WORD
        cmp.b           #%0001,d2
        beq             DSM_DST_LOAD_LONG

DSM_DST_LOAD_WORD
        move.w          (a6)+,d0
        bra             DSM_DST_LOAD_LONG

DSM_DST_LOAD_LONG
        move.l          (a6)+,d0
        bra             DSM_DST_NE

DSM_DST_NE     * No following instruction for destination.
        rts

** Sub_function end here
* ---------------------------------------


* Mnemonic disassembly end here
*******************************************************************************************

*For the instruction 


******************************************************************************
* This is to minimize the typing
* Predefined strin instructions
****************************************************************************
            BSR    ADDI_S
            BSR    SUBI_S
            BSR    MOVE_B_S
            BSR    MOVE_L_S
            BSR    MOVEA_L_S
            BSR    MOVE_W_S
            BSR    MOVEA_W_S
            BSR    CLR_S
            BSR    NOP_S
            BSR    RTS_S
            BSR    JSR_S
            BSR    MOVEM_S
            BSR    LEA_S           
            BSR    ADDQ_S
            BSR    BCC_S
            BSR    BGT_S
            BSR    BLE_S          
            BSR    MOVEQ_S        
            BSR    OR_S
            BSR    DIVU_S           
            BSR    SUB_S 
            BSR    CMP_S    
            BSR    AND_S

            BSR    MULS_S           
            BSR    MULU_S            
            BSR    ADD_S
            BSR    ADDA_S
            BSR    ASR_S
            BSR    ASL_S
            BSR    LSR_S
            BSR    LSL_S
            BSR    ROR_S
            BSR    ROL_S 
          SIMHALT             ; halt simulator

* Assembly instruction.     
ADDI_S      LEA     ADDI_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

SUBI_S      LEA     SUBI_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

MOVE_B_S    LEA     MOVE_B_MESSAGE,A1 * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

MOVE_L_S    LEA     MOVE_L_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS
            
MOVEA_L_S   LEA     MOVEA_L_MESSAGE,A1 * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS
            
MOVE_W_S    LEA     MOVE_W_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

MOVEA_W_S   LEA     MOVEA_W_MESSAGE,A1  * loads Message into address
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
LONGWORD_S  LEA     LONG_WORD,A1     * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

WORD_S      LEA     WORD,A1          * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

BYTE_S      LEA     BYTE,A1          * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
            RTS

* Data register.
D_ZERO      LEA     D_Zero_MESSAGE,A1
            MOVE.B  #14,D0
            TRAP    #15
            RTS
D_ONE
D_TWO
D_THREE
D_FOUR
D_FIVE
D_SIX
D_SEVEN

* Address Register.
A_ZERO
A_ONE
A_TWO
A_THREE
A_FOUR
A_FIVE
A_SIX
A_SEVEN

* NewLine
NEWLINE     lea         CRLF,A1
            move.b      #14,d0
            trap        #15
            rts

* Tab
TAB         lea         TAB_SPACE,a1
            move.b      #14,d0
            trap        #15
            rts

ADDI_MESSAGE            DC.B    'ADDI',0
SUBI_MESSAGE            DC.B    'SUBI',0
MOVE_B_MESSAGE          DC.B    'MOVE.B',0
MOVE_L_MESSAGE          DC.B    'MOVE.L',0
MOVEA_L_MESSAGE         DC.B    'MOVEA.L',0
MOVE_W_MESSAGE          DC.B    'MOVE.W',0
MOVEA_W_MESSAGE         DC.B    'MOVEA.W',0
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

* Size instruction.
LONG_WORD               DC.B    '.L',0
WORD                    DC.B    '.W',0
BYTE                    DC.B    '.B',0


* New Line
CRLF                    dc.b    CR,LF,0
TAB_SPACE               dc.b    '    ',0


**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        move.b          d1,d1
        rts
   
*Instruction for terminating the program
DONE
        SIMHALT
    END    START        ; last line of source











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
