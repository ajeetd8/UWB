*-----------------------------------------------------------
* Title      : Effective_Address with opcode
* Written by : Haram, Byeonggeun, Erik
* Date       : 
* Description: this code will traverse memory. This code is
* expected to merge to Project.X68
*-----------------------------------------------------------

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
LONG                    equ             $11
WORD                    equ             $10
BYTE                    equ             $01

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
        * Check for the terminal Condition.
        move.l          (a6),d7
        cmp.l           #$FFFFFFFF,d7           Terminal condition check
        beq             DONE                    Terminating the program.


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

        * Show Initial Instruction
        bsr             TAB
        move.w          INITIAL_INSTRUCTION,WORD_OUT
        bsr             WORD_OUT_S

        * Save Initial instruction to d7 register
        move.w          INITIAL_INSTRUCTION,d7
        
        *-------------------
        * addi, subi
        cmp.w           #$1000,(a6)
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

        * Invalid input, show message
        bsr             INVALID_S
        
        
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
* Instruction read finished, show continue message?








* Instruction read finished, show continue message?
*******************************************************************************************


*******************************************************************************************
* Mnemonic disassmbly start here

* Addi Subi
MC_ADDI_SUBI

        bra             MAIN_LOOP

*Mnemonic: move.b
MC_MOVE_B
        move.b          #$01,d7                 mark 01 for byte operation.
        
        bsr             TAB
        bsr             MOVE_B_S                Print out the instruction.
        bsr             NEWLINE                 Newline
        *bsr             DEST_SRC_MD             Anaylize and print.
        *bsr             D_ZERO
        *bsr             NEWLINE
        bra             MAIN_LOOP

* Mnemonic: move.l, movea.l
MC_MOVE_L_MOVEA_L
        move.b          #$10,d7                 mark 10 for long operation.
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: move.w
MC_MOVE_W_MOVEA_W
        move.b          #$11,d7                 mark 11 for byte operation.
        
        bsr             TAB
        bsr             NEWLINE                 Newline
        bra             MAIN_LOOP

* Mnemonic: clr, nop, rts, jsr, movem, lea
MC_CLR_LEA
        * Check for 'NOP' instruction.
        cmp.w           #$4e71,INITIAL_INSTRUCTION
        bne             NOT_NOP
        bsr             TAB
        bsr             NOP_S
        bsr             NEWLINE
        bra             MAIN_LOOP
NOT_NOP
        * Check 'RTS' instruction.
        cmp.w           #$4e75,INITIAL_INSTRUCTION
        bne             NOT_RTS
        bsr             TAB
        bsr             RTS_S
        bsr             NEWLINE
        bra             MAIN_LOOP
NOT_RTS
        * Check 'CLR' instruction
        cmp.b           #$42,INITIAL_INSTRUCTION
        bne             NOT_CLR
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

* ----------------------------------------
** Sub-functions for Mnemonics


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
LONGWORD_S  LEA     LONG_MESSAGE,A1     * loads Message into address
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
D_ZERO          LEA     D_ZERO_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_ONE           LEA     D_ONE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_TWO           LEA     D_TWO_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_THREE         LEA     D_THREE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_FOUR          LEA     D_FOUR_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_FIVE          LEA     D_FIVE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_SIX           LEA     D_SIX_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
D_SEVEN         LEA     D_SEVEN_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS

* Address Register.
A_ZERO          LEA     A_ZERO_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_ONE           LEA     A_ONE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_TWO           LEA     A_TWO_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_THREE         LEA     A_THREE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_FOUR          LEA     A_FOUR_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_FIVE          LEA     A_FIVE_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_SIX           LEA     A_SIX_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
A_SEVEN         LEA     A_SEVEN_MESSAGE,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS

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

* INVALID MESSAGE
INVALID_S       lea     INVALID_INSTRUCTION_MESSAGE,a1
                move.b  #14,d0
                trap    #15
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
LONG_MESSAGE            DC.B    '.L',0
WORD_MESSAGE            DC.B    '.W',0
BYTE_MESSAGE            DC.B    '.B',0

* Invalid Insturction.
INVALID_INSTRUCTION_MESSAGE     DC.B    'Invalid Instruction!!!',CR,LF,0

* Press Enter continue
PRESS_ENTER_MESSAGE             DC.B    'Press Enter to Continue',0

* New Line, and tab, Space
CRLF                    dc.b    CR,LF,0
TAB_SPACE               dc.b    HT,0
SPACE                   dc.b    ' ',0


**************************************************************************************************
* Global Variable
WORD_OUT                ds.w            $1      Word out reserved variable
READ_FROM               ds.l            $1      Variable to save read From
READ_TO                 ds.l            $1      Varaible to save read To
Current_Read            ds.l            $1      Varaible to save current read

** 3 bit instruction saving place
EA_MODE                 ds.b            $1
OP_MODE                 ds.b            $1
EA_REGISTER             ds.b            $1
DEST_REGISTER           ds.b            $1
DEST_MODE               ds.b            $1
SRC_MODE                ds.b            $1
SRC_REGISTER            ds.b            $1
REGISTER                ds.b            $1
COUNT_REGISTER          ds.b            $1

** 2 bit instructoin savin place
SIZE                    ds.b            $1


* Local variable invoked
* Local variable which will be invoked
INITIAL_INSTRUCTION     ds.w            $1      Initial instruction variable
MAIN_LOOP_COUNT         ds.b            $1      Loop count variable for main function

**************************************************************************************************

**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        rts
        nop
        rts
        nop
        rts
        nop
        rts
        nop
        rts
        nop
        rts
        nop
        rts
        nop
        rts
        nop
        rts
        nop
        rts
        nop
        clr.b           d0
        clr.w           d0
        clr.l           d0
        clr             d0
        clr             $00008000
        rts
        nop
        rts
        nop
 
*Instruction for terminating the program
DONE
        SIMHALT
    END    START        ; last line of source













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
