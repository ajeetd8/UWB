**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM
*this is a sample code to disassemble.


        ror.b           d0,d2
        rol.b           D0,d2

        lsr.b           d0,d3
        lsr.b           d1,d5

        asr.b           d0,d3
        asr.b           d1,d5

        ror.w           #7,d2
        rol.w           #7,d2

        lsl.l           #1,d2
        lsl.w           #2,d1

        asr.l           #1,d0
        asr.b           #1,d6
        
HERE
 
        SIMHALT

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
