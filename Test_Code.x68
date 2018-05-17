**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        clr             $10000
        move.b          #$12,$123456
        move.b          $8000,$ffff8000
        clr.w           $8000
        clr             $7fff
        clr.l           -(a7)
        clr.w           -(A5)

        move.b          #$01,d0
        move.b          #$23,d5
        move.b          #$11,(a5)
        move.b          $7fff,-(a3)

        movea.l          $8000,a0
        movea.w          $7fff,a0

        addi.b          #$01,d0

        JSR             $7044

        *bra             HERE

HERE
 
        SIMHALT
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
