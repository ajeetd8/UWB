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
        move.w          (a6)+,d5
        
        *-------------------
        * addi, subi
        * 
        *cmp.w           #$1000,d5
        *blo

        * move.b
        cmp.w           #$2000,d5
        blo             MC_MOVE_B

        cmp.w           #$3000,d5
        cmp.w           #$4000,d5
        cmp.w           #$5000,d5
        cmp.w           #$6000,d5
        cmp.w           #$7000,d5
        cmp.w           #$8000,d5
        cmp.w           #$9000,d5
        cmp.w           #$a000,d5
        
        cmp.w           #$d000,d5
        cmp.w           #$e000,d5
        cmp.w           #$f000,d5
        
        * Read word by words.
        * Every loop is incrementing by word
        
        
        bra             LOOP

* Iteration end here
*******************************************************************************************

*******************************************************************************************
* Mnemonic disassmbly start here

*Mnemonic: move.b
MC_MOVE_B
        bsr             MOVE_B_S                Print out the instruction.
        bsr             TAB
        bsr             DEST_SRC_MD             Anaylize and print.
        bsr             D_ZERO
        
        
        
        SIMHALT
        bra             LOOP
* ----------------------------------------
** Sub-functions for Mnemonics

DEST_SRC_MD
        * d1 : Dest Register
        * d2 : Dest Mode
        * d3 : Src Mode
        * d4 : Src Register
        move.b          d5,d4
        bclr            #3,d4
        bclr            #4,d4
        bclr            #5,d4
        bclr            #6,d4
        bclr            #7,d4
        ror.w           #3,d5

        move.b          d5,d3
        bclr            #3,d3
        bclr            #4,d3
        bclr            #5,d3
        bclr            #6,d3
        bclr            #7,d3
        ror.w           #3,d5

        move.b          d5,d2
        bclr            #3,d2
        bclr            #4,d2
        bclr            #5,d2
        bclr            #6,d2
        bclr            #7,d2
        ror.w           #3,d5

        move.b          d5,d1
        bclr            #3,d1
        bclr            #4,d1
        bclr            #5,d1
        bclr            #6,d1
        bclr            #7,d1
        ror.w           #3,d5
        ror.w           #4,d5

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
D_Zero_MESSAGE          DC.B    'D0',0

* Address Register

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
   
*Instruction for terminating the program
DONE
        SIMHALT
    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
