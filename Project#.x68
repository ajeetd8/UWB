*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

START   ORG     $1000                 ; first instruction of program

* Data register.
D_ZERO      LEA     D_Zero_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
D_ONE       LEA     D_Zero_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
D_TWO       LEA     D_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
           
D_THREE     LEA     D_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
 
D_FOUR      LEA     D_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
D_FIVE      LEA     D_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
D_SIX       LEA     D_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
D_SEVEN     LEA     D_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
* Address register
A_ZERO      LEA     A_Zero_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
A_ONE       LEA     A_Zero_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
A_TWO       LEA     A_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
           
A_THREE     LEA     A_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
 
A_FOUR      LEA     A_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
A_FIVE      LEA     A_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
A_SIX       LEA     A_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
            
A_SEVEN     LEA     A_ZERO_MESSAGE,A0
            MOVE.B  #14,D0
            TRAP    #15
            RTS
    SIMHALT             ; halt simulator

* Put variables and constants here

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


    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
