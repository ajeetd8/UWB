**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        move.l          #$8000,d0
        move.w          $8000,d0
        *bra             HERE

HERE
 
        SIMHALT
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
