**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        * addi.b permutations
        addi.b          #20,d1
        sub.b           #20,d0

        addi.w          #$8000,d3

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
        move.w          d0,d0
        move.w          a5,d0
        move.w          (a5),d0
        move.w          (a5)+,d0
        move.w          -(a5),d0
        move.w          $7ffe,d0
        move.w          $ffff7ffe,d0
        move.w          #$ffff,d0

        move.w          d0,(a5)
        move.w          a5,(a5)
        move.w          (a5),(a5)
        move.w          (a3)+,(a5)
        move.w          -(a3),(a5)
        move.w          $7ffe,(a5)
        move.w          $ffff7ffe,(a5)
        move.w          #$ffff,(a5)

        move.w          d0,(a5)+
        move.w          a5,(a5)+
        move.w          (a5),(a5)+
        move.w          (a3)+,(a5)+
        move.w          -(a3),(a5)+
        move.w          $7ffe,(a5)+
        move.w          $ffff7ffe,(a5)+
        move.w          #$ffff,(a5)+

        move.w          d0,-(a5)
        move.w          a5,-(a5)
        move.w          (a5),-(a5)
        move.w          (a3)+,-(a5)
        move.w          -(a3),-(a5)
        move.w          $7ffe,-(a5)
        move.w          $ffff7ffe,-(a5)
        move.w          #$ffff,-(a5)

        move.w          d0,$7ffe
        move.w          a5,$7ffe
        move.w          (a5),$7ffe
        move.w          (a3)+,$7ffe
        move.w          -(a3),$7ffe
        move.w          $7ffe,$7ffe
        move.w          $ffff7ffe,$7ffe
        move.w          #$ffff,$7ffe

        move.w          d0,$ffff7ffe
        move.w          a5,$ffff7ffe
        move.w          (a5),$ffff7ffe
        move.w          (a3)+,$ffff7ffe
        move.w          -(a3),$ffff7ffe
        move.w          $7ffe,$ffff7ffe
        move.w          $ffff7ffe,$ffff7ffe
        move.w          #$ffff,$ffff7ffe

        * move.w permutations
        move.l          d0,d0
        move.l          a5,d0
        move.l          (a5),d0
        move.l          (a5)+,d0
        move.l          -(a5),d0
        move.l          $7ffe,d0
        move.l          $ffff7ffe,d0
        move.l          #$ffff7ffe,d0

        move.l          d0,(a5)
        move.l          a5,(a5)
        move.l          (a5),(a5)
        move.l          (a3)+,(a5)
        move.l          -(a3),(a5)
        move.l          $7ffe,(a5)
        move.l          $ffff7ffe,(a5)
        move.l          #$ffff7ffe,(a5)

        move.l          d0,(a5)+
        move.l          a5,(a5)+
        move.l          (a5),(a5)+
        move.l          (a3)+,(a5)+
        move.l          -(a3),(a5)+
        move.l          $7ffe,(a5)+
        move.l          $ffff7ffe,(a5)+
        move.l          #$ffff7ffe,(a5)+

        move.l          d0,-(a5)
        move.l          a5,-(a5)
        move.l          (a5),-(a5)
        move.l          (a3)+,-(a5)
        move.l          -(a3),-(a5)
        move.l          $7ffe,-(a5)
        move.l          $ffff7ffe,-(a5)
        move.l          #$ffff7ffe,-(a5)

        move.l          d0,$7ffe
        move.l          a5,$7ffe
        move.l          (a5),$7ffe
        move.l          (a3)+,$7ffe
        move.l          -(a3),$7ffe
        move.l          $7ffe,$7ffe
        move.l          $ffff7ffe,$7ffe
        move.l          #$ffff7ffe,$7ffe

        move.l          d0,$ffff7ffe
        move.l          a5,$ffff7ffe
        move.l          (a5),$ffff7ffe
        move.l          (a3)+,$ffff7ffe
        move.l          -(a3),$ffff7ffe
        move.l          $7ffe,$ffff7ffe
        move.l          $ffff7ffe,$ffff7ffe
        move.l          #$ffff7ffe,$ffff7ffe

        * movea.w permutations
        movea.w          $7fff,a0

        * movea.l permutations
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

        lea             $7000,a0

        divu            $8000,d0

        muls            $8000,d0

        mulu            $8000,d0

HERE
 
        SIMHALT
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
