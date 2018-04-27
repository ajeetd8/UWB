*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
START       ORG    $1000 ; first instruction of program

* Put program code here
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

BLE_S       LEA     BLE_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

MOVEQ_S     LEA     MOVEQ_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

OR_S        LEA     OR_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

DIVU_S      LEA     DIVU_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

SUB_S       LEA     SUB_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

CMP_S       LEA     CMP_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

AND_S       LEA     AND_MESSAGE,A1  * loads Message into address
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

ADD_S       LEA     ADD_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

ADDA_S      LEA     ADDA_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

ASR_S       LEA     ASR_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

ASL_S       LEA     ASL_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

LSR_S       LEA     LSR_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

LSL_S       LEA     LSL_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

ROR_S       LEA     ROR_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS

ROL_S       LEA     ROL_MESSAGE,A1  * loads Message into address
            MOVE.B  #14,D0           * Moves the number 14 into data register D0
            TRAP    #15              * Displays meessage
        
            RTS


   
    
    

* Put variables and constants here
CR      EQU    $0D              * ASCII code for Carriage Return
LF      EQU    $0A              * ASCII code for Line Feed

ADDI_MESSAGE            DC.B    'ADDI',CR,LF,0
SUBI_MESSAGE            DC.B    'SUBI',CR,LF,0
MOVE_B_MESSAGE          DC.B    'MOVE.B',CR,LF,0
MOVE_L_MESSAGE          DC.B    'MOVE.L',CR,LF,0
MOVEA_L_MESSAGE         DC.B    'MOVEA.L',CR,LF,0
MOVE_W_MESSAGE          DC.B    'MOVE.W',CR,LF,0
MOVEA_W_MESSAGE         DC.B    'MOVEA.W',CR,LF,0
CLR_MESSAGE             DC.B    'CLR',CR,LF,0
NOP_MESSAGE             DC.B    'NOP',CR,LF,0
RTS_MESSAGE             DC.B    'RTS',CR,LF,0
JSR_MESSAGE             DC.B    'JSR',CR,LF,0
MOVEM_MESSAGE           DC.B    'MOVEM',CR,LF,0
LEA_MESSAGE             DC.B    'LEA',CR,LF,0
ADDQ_MESSAGE            DC.B    'ADDQ',CR,LF,0
BCC_MESSAGE             DC.B    'BCC',CR,LF,0
BGT_MESSAGE             DC.B    'BGT',CR,LF,0
BLE_MESSAGE             DC.B    'BLE',CR,LF,0
MOVEQ_MESSAGE           DC.B    'MOVEQ',CR,LF,0
OR_MESSAGE              DC.B    'OR',CR,LF,0
DIVU_MESSAGE            DC.B    'DIVU',CR,LF,0
SUB_MESSAGE             DC.B    'SUB',CR,LF,0
CMP_MESSAGE             DC.B    'CMP',CR,LF,0
AND_MESSAGE             DC.B    'AND',CR,LF,0
MULS_MESSAGE            DC.B    'MULS',CR,LF,0
MULU_MESSAGE            DC.B    'MULU',CR,LF,0
ADD_MESSAGE             DC.B    'ADD',CR,LF,0
ADDA_MESSAGE            DC.B    'ADDA',CR,LF,0
ASR_MESSAGE             DC.B    'ASR',CR,LF,0
ASL_MESSAGE             DC.B    'ASL',CR,LF,0
LSR_MESSAGE             DC.B    'LSR',CR,LF,0
LSL_MESSAGE             DC.B    'LSL',CR,LF,0
ROR_MESSAGE             DC.B    'ROR',CR,LF,0
ROL_MESSAGE             DC.B    'ROL',CR,LF,0
    END    START        ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
