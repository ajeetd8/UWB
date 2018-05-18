**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        * addi.b permutations
        addi.b          #$01,d0

        * move.b permutations 
        move.b          d0,d0
        move.b          (a5),d0
        move.b          (a5)+,d0
        move.b          -(a5),d0
        move.b          $7ffe,d0
        move.b          $ffff7ffe,d0
        move.b          #$ff,d0

        move.b          d0,(a5)
        move.b          (a5),(a5)
        move.b          (a3)+,(a5)
        move.b          -(a3),(a5)
        move.b          $7ffe,(a5)
        move.b          $ffff7ffe,(a5)
        move.b          #$ff,(a5)

        move.b          d0,(a5)+
        move.b          (a5),(a5)+
        move.b          (a3)+,(a5)+
        move.b          -(a3),(a5)+
        move.b          $7ffe,(a5)+
        move.b          $ffff7ffe,(a5)+
        move.b          #$ff,(a5)+

        move.b          d0,-(a5)
        move.b          (a5),-(a5)
        move.b          (a3)+,-(a5)
        move.b          -(a3),-(a5)
        move.b          $7ffe,-(a5)
        move.b          $ffff7ffe,-(a5)
        move.b          #$ff,-(a5)

        move.b          d0,$7ffe
        move.b          (a5),$7ffe
        move.b          (a3)+,$7ffe
        move.b          -(a3),$7ffe
        move.b          $7ffe,$7ffe
        move.b          $ffff7ffe,$7ffe
        move.b          #$ff,$7ffe

        move.b          d0,$ffff7ffe
        move.b          (a5),$ffff7ffe
        move.b          (a3)+,$ffff7ffe
        move.b          -(a3),$ffff7ffe
        move.b          $7ffe,$ffff7ffe
        move.b          $ffff7ffe,$ffff7ffe
        move.b          #$ff,$ffff7ffe

        * move.w permutations
        movea.w          $7fff,a0

        * move.l permutations
        movea.l          $8000,a0

        * clr permutations
        clr             $7fff
        clr             $10000

        * clr.b permutations

        * clr.w permutations
        clr.w           $8000
        clr.w           -(A5)

        * clr permutations
        clr.l           -(a7)

        * jsr permutations
        jsr             $7044

        *bra             HERE

HERE
 
        SIMHALT
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
