**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        * addi.b permutations
        addi.b          #$ff,d1
        addi.b          #$ff,(a5)
        addi.b          #$ff,(a5)+
        addi.b          #$ff,-(a5)
        addi.b          #$ff,$7ffe
        addi.b          #$ff,$ffff7ffe

        * addi.w permutations
        addi.w          #$7ffe,d1
        addi.w          #$7ffe,(a5)
        addi.w          #$7ffe,(a5)+
        addi.w          #$7ffe,-(a5)
        addi.w          #$7ffe,$7ffe
        addi.w          #$7ffe,$ffff7ffe

        * addi.l permutations
        addi.l          #$ffff7ffe,d1
        addi.l          #$ffff7ffe,(a5)
        addi.l          #$ffff7ffe,(a5)+
        addi.l          #$ffff7ffe,-(a5)
        addi.l          #$ffff7ffe,$7ffe
        addi.l          #$ffff7ffe,$ffff7ffe
  
        * subi.b permutations
        subi.b          #$ff,d1
        subi.b          #$ff,(a5)
        subi.b          #$ff,(a5)+
        subi.b          #$ff,-(a5)
        subi.b          #$ff,$7ffe
        subi.b          #$ff,$ffff7ffe

        * subi.w permutations
        subi.w          #$7ffe,d1
        subi.w          #$7ffe,(a5)
        subi.w          #$7ffe,(a5)+
        subi.w          #$7ffe,-(a5)
        subi.w          #$7ffe,$7ffe
        subi.w          #$7ffe,$ffff7ffe

        * subi.l permutations
        subi.l          #$ffff7ffe,d1
        subi.l          #$ffff7ffe,(a5)
        subi.l          #$ffff7ffe,(a5)+
        subi.l          #$ffff7ffe,-(a5)
        subi.l          #$ffff7ffe,$7ffe
        subi.l          #$ffff7ffe,$ffff7ffe

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
        move.w          #$7ffe,d0

        move.w          d0,(a5)
        move.w          a5,(a5)
        move.w          (a5),(a5)
        move.w          (a3)+,(a5)
        move.w          -(a3),(a5)
        move.w          $7ffe,(a5)
        move.w          $ffff7ffe,(a5)
        move.w          #$7ffe,(a5)

        move.w          d0,(a5)+
        move.w          a5,(a5)+
        move.w          (a5),(a5)+
        move.w          (a3)+,(a5)+
        move.w          -(a3),(a5)+
        move.w          $7ffe,(a5)+
        move.w          $ffff7ffe,(a5)+
        move.w          #$7ffe,(a5)+

        move.w          d0,-(a5)
        move.w          a5,-(a5)
        move.w          (a5),-(a5)
        move.w          (a3)+,-(a5)
        move.w          -(a3),-(a5)
        move.w          $7ffe,-(a5)
        move.w          $ffff7ffe,-(a5)
        move.w          #$7ffe,-(a5)

        move.w          d0,$7ffe
        move.w          a5,$7ffe
        move.w          (a5),$7ffe
        move.w          (a3)+,$7ffe
        move.w          -(a3),$7ffe
        move.w          $7ffe,$7ffe
        move.w          $ffff7ffe,$7ffe
        move.w          #$7ffe,$7ffe

        move.w          d0,$ffff7ffe
        move.w          a5,$ffff7ffe
        move.w          (a5),$ffff7ffe
        move.w          (a3)+,$ffff7ffe
        move.w          -(a3),$ffff7ffe
        move.w          $7ffe,$ffff7ffe
        move.w          $ffff7ffe,$ffff7ffe
        move.w          #$7ffe,$ffff7ffe

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
        movea.w         d0,a5
        movea.w         a5,a5
        movea.w         (a5),a5
        movea.w         (a5)+,a5
        movea.w         -(a5),a5
        movea.w         $7ffe,a5
        movea.w         $ffff7ffe,a5
        movea.w         #$7ffe,a5

        * movea.l permutations
        movea.l         d0,a5
        movea.l         a5,a5
        movea.l         (a5),a5
        movea.l         (a5)+,a5
        movea.l         -(a5),a5
        movea.l         $7ffe,a5
        movea.l         $ffff7ffe,a5
        movea.l         #$ffff7ffe,a5
        
        * clr.b permutations
        clr.b           d0
        clr.b           (a5)
        clr.b           (a5)+
        clr.b           -(a5)
        clr.b           $7ffe
        clr.b           $ffff7ffe

        * clr.w permutations
        clr.w           d0
        clr.w           (a5)
        clr.w           (a5)+
        clr.w           -(a5)
        clr.w           $7ffe
        clr.w           $ffff7ffe

        * clr.l permutations
        clr.l           d0
        clr.l           (a5)
        clr.l           (a5)+
        clr.l           -(a5)
        clr.l           $7ffe
        clr.l           $ffff7ffe

        *   various EA modes
        MOVEM       D0-D7,-(A7)                     ;test1
        MOVEM       (A7)+,D0-D7                     ;test2

        MOVEM       A0-A6,-(A7)                     ;test3
        MOVEM       (A7)+,A0-A6                     ;test4
  
        MOVEM       A0-A6/D0-D7,-(A7)               ;test5
        MOVEM       (A7)+,A0-A6/D0-D7               ;test6
 
        MOVEM       D0-D7/A0-A6,$2468               ;test7
        MOVEM       D0-D7/A0-A6,$2468               ;test8

*   test different sizes        
        MOVEM       (A1)+,D0-D7                     ;test9
        MOVEM.W     (A1)+,D0-D7                     ;test10
        MOVEM.L     (A1)+,D0-D7                     ;test11
        MOVEM.L     D0-D7/A0-A6,$1234               ;test12

        MOVEM.L     (A5),D0-D2/D5-D7/A0-A3/A6       ;test13
        MOVEM.W     D0-D5/D7/A0-A6,-(A7)            ;test14
        MOVEM.W     (A7)+,D0-D5/D7/A0-A6            ;test15

        MOVEM.L     A0/A1/A2/D5/D6/D7,$3A(A6,D4.L)  ;test16
        MOVEM.L     (A0)+,D0/D1/D2/A4/A3/A0/A1      ;test17

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
