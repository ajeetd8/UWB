**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        *clr             $10000
        *move.b          #$12,$123456
        clr.w           $8000
        clr.l           -(a7)
        clr.w           -(A5)
 
        SIMHALT