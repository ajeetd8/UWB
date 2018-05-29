 **
   * SIZE_TAG_S
   * Assembler Code
   * ADDI_S
   * SUBI_S
   * MOVE
   *
   *


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
INVALID_INSTRUCTION_MESSAGE     DC.B    'Invalid Instruction!!!',CR,LF,0

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
PROMPT_1                dc.b    'Enter starting address. Range=[$3500,$9999]',0
PROMPT_2                dc.b    '$',0
PROMPT_3                dc.b    'Press ENTER to continue...',0
PROMPT_4                dc.b    'Would you like to disassemble again? (Y/N)',0
PROMPT_5                dc.b    '>',0
PROMPT_6                dc.b    'Press ENTER to continue...',0
PROMPT_7                dc.b    'Enter ending address. Range=[$3500,$9999]',0

        include 'Const_Variable_Setting.x68',0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
