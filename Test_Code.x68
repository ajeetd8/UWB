**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM
*this is a sample code to disassemble.

        * OPCODE TEST EXAMPLE

        move.b          $FFFFA340,d3

        move.b          $0000a340,d3
        move.b          $a340,d3
        


        *andi	        #$643,d0
        rol             $1234
        ror             $4321
        moveq           #$12,d6
        addq            #8,d5
        addq            #8,$12345678
        move.w          $7fff,d0
        move.b          #$77,d0
        move.w          $8000,d0
        move.w          $00007fff,d0
        move.w          $00008000,d0
        move.w          $ffff7fff,d0
        move.w          $ffff8000,d0
        
        * add.b permutations
        add.b           d0,d0
        add.b           (a5),d0
        add.b           (a5)+,d0
        add.b           -(a5),d0
        add.b           $7ffe,d0
        add.b           $ffff7ffe,d0

        add.b           d0,(a5)
        add.b           d0,(a5)+
        add.b           d0,-(a5)
        add.b           d0,$7ffe
        add.b           d0,$ffff7ffe

        * add.w permutations
        add.w           d0,d0
        add.w           (a5),d0
        add.w           (a5)+,d0
        add.w           -(a5),d0
        add.w           $7ffe,d0
        add.w           $ffff7ffe,d0

        add.w           d0,(a5)
        add.w           d0,(a5)+
        add.w           d0,-(a5)
        add.w           d0,$7ffe
        add.w           d0,$ffff7ffe

        * add.l permutations
        add.l           d0,d0
        add.l           (a5),d0
        add.l           (a5)+,d0
        add.l           -(a5),d0
        add.l           $7ffe,d0
        add.l           $ffff7ffe,d0

        add.l           d0,(a5)
        add.l           d0,(a5)+
        add.l           d0,-(a5)
        add.l           d0,$7ffe
        add.l           d0,$ffff7ffe

        * adda.w permutations
        adda.w          d2,a2
        adda.w          a2,a2
        adda.w          (a2),a2
        adda.w          (a2)+,a2
        adda.w          -(a3),a3
        adda.w          $7ffe,a3
        adda.w          $ffff7ffe,a4

        * adda.l permutations
        adda.l          d2,a2
        adda.l          a2,a2
        adda.l          (a2),a2
        adda.l          (a2)+,a2
        adda.l          -(a3),a3
        adda.l          $7ffe,a3
        adda.l          $ffff7ffe,a4

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

        * addq.b permutations
        * addq.w permutations
        * addq.l permutations

        * and.b permutations
        and.b           d0,d0
        and.b           (a5),d0
        and.b           (a5)+,d0
        and.b           -(a5),d0
        and.b           $7ffe,d0
        and.b           $ffff7ffe,d0
        and.b           #$ff,d0

        and.b           d0,(a5)
        and.b           d0,(a5)+
        and.b           d0,-(a5)
        and.b           d0,$7ffe
        and.b           d0,$ffff7ffe

        * and.w permutations
        and.w           d0,d0
        and.w           (a5),d0
        and.w           (a5)+,d0
        and.w           -(a5),d0
        and.w           $7ffe,d0
        and.w           $ffff7ffe,d0
        and.w           #$7ffe,d0

        and.w           d0,(a5)
        and.w           d0,(a5)+
        and.w           d0,-(a5)
        and.w           d0,$7ffe
        and.w           d0,$ffff7ffe

        * and.l permutations
        and.l           d0,d0
        and.l           (a5),d0
        and.l           (a5)+,d0
        and.l           -(a5),d0
        and.l           $7ffe,d0
        and.l           $ffff7ffe,d0
        and.l           #$ffff7ffe,d0

        and.l           d0,(a5)
        and.l           d0,(a5)+
        and.l           d0,-(a5)
        and.l           d0,$7ffe
        and.l           d0,$ffff7ffe

        * bcc perumtations
        bcc             here
        bgt             here
        ble             here

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

        * cmp.b permutations
        cmp.b           d3,d3
        cmp.b           (a3),d3
        cmp.b           (a3)+,d3
        cmp.b           -(a3),d3
        cmp.b           $7ffe,d3
        cmp.b           $ffff7ffe,d3
        cmp.b           #$ff,d3

        * cmp.w permutations
        cmp.w           d3,d3
        cmp.w           (a3),d3
        cmp.w           (a3)+,d3
        cmp.w           -(a3),d3
        cmp.w           $7ffe,d3
        cmp.w           $ffff7ffe,d3
        cmp.w           #$7ffe,d3

        * cmp.l permutations
        cmp.l           d3,d3
        cmp.l           (a3),d3
        cmp.l           (a3)+,d3
        cmp.l           -(a3),d3
        cmp.l           $7ffe,d3
        cmp.l           $ffff7ffe,d3
        cmp.l           #$ffff7ffe,d3

        * divu.w permutations
        divu.w          d0,d0
        divu.w          (a0),d0
        divu.w          (a0)+,d0
        divu.w          -(a0),d0
        divu.w          $7ffe,d0
        divu.w          $ffff7ffe,d0
        divu.w          #$7ffe,d0

        * jsr permutations
        jsr             (a5)
        jsr             $7ffe
        jsr             $ffff7ffe

        * lea.l permutations
        lea.l           (a5),a0
        lea.l           $7ffe,a0
        lea.l           $ffff7ffe,a0

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

        * muls.w permutations
        muls.w          d0,d0
        muls.w          (a0),d0
        muls.w          (a0)+,d0
        muls.w          -(a0),d0
        muls.w          $7ffe,d0
        muls.w          $ffff7ffe,d0
        muls.w          #$7ffe,d0
        
        * mulu.w permutations
        mulu.w          d0,d0
        mulu.w          (a0),d0
        mulu.w          (a0)+,d0
        mulu.w          -(a0),d0
        mulu.w          $7ffe,d0
        mulu.w          $ffff7ffe,d0
        mulu.w          #$7ffe,d0

        * nop permutations
        nop
        
        * or.b permutations
        or.b            d0,d0
        or.b            (a5),d0
        or.b            (a5)+,d0
        or.b            -(a5),d0
        or.b            $7ffe,d0
        or.b            $ffff7ffe,d0
        or.b            #$ff,d0

        or.b            d0,(a5)
        or.b            d0,(a5)+
        or.b            d0,-(a5)
        or.b            d0,$7ffe
        or.b            d0,$ffff7ffe

        * or.w permutations
        or.w            d0,d0
        or.w            (a5),d0
        or.w            (a5)+,d0
        or.w            -(a5),d0
        or.w            $7ffe,d0
        or.w            $ffff7ffe,d0
        or.w            #$7ffe,d0

        or.w            d0,(a5)
        or.w            d0,(a5)+
        or.w            d0,-(a5)
        or.w            d0,$7ffe
        or.w            d0,$ffff7ffe

        * or.l permutations
        or.l            d0,d0
        or.l            (a5),d0
        or.l            (a5)+,d0
        or.l            -(a5),d0
        or.l            $7ffe,d0
        or.l            $ffff7ffe,d0
        or.l            #$ffff7ffe,d0

        or.l            d0,(a5)
        or.l            d0,(a5)+
        or.l            d0,-(a5)
        or.l            d0,$7ffe
        or.l            d0,$ffff7ffe
        
        * rts permutations
        rts
        
        * sub.b permutations
        sub.b           d0,d0
        sub.b           (a5),d0
        sub.b           (a5)+,d0
        sub.b           -(a5),d0
        sub.b           $7ffe,d0
        sub.b           $ffff7ffe,d0

        sub.b           d0,(a5)
        sub.b           d0,(a5)+
        sub.b           d0,-(a5)
        sub.b           d0,$7ffe
        sub.b           d0,$ffff7ffe

        * sub.w permutations
        sub.w           d0,d0
        sub.w           (a5),d0
        sub.w           (a5)+,d0
        sub.w           -(a5),d0
        sub.w           $7ffe,d0
        sub.w           $ffff7ffe,d0

        sub.w           d0,(a5)
        sub.w           d0,(a5)+
        sub.w           d0,-(a5)
        sub.w           d0,$7ffe
        sub.w           d0,$ffff7ffe

        * sub.l permutations
        sub.l           d0,d0
        sub.l           (a5),d0
        sub.l           (a5)+,d0
        sub.l           -(a5),d0
        sub.l           $7ffe,d0
        sub.l           $ffff7ffe,d0

        sub.l           d0,(a5)
        sub.l           d0,(a5)+
        sub.l           d0,-(a5)
        sub.l           d0,$7ffe
        sub.l           d0,$ffff7ffe

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

        asr             $1234
        lsl             $321

        asr.w           #8,d0

        
HERE
 
        SIMHALT

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~