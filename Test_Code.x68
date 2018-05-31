**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
start:        org             $9000        Code after this starts at DISASSEMBLE_FROM
*this is a sample code to disassemble.

        * OPCODE TEST EXAMPLE


        asl.w           $1234
        asl.l           #3,d0

        bcc             $9000
        bcc             $10000
        
        movem.w    d0,-(a7)
        movem.w    d0,-(a6)
        movem.w    d0,-(a5)
        movem.w    d0,-(a4)
        movem.w    d0,(a3)
        movem.w    d0,-(a2)
        movem.w    d0,-(a1)

        movem.w     d0,$12345678
        
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
        addq.b          #$08,d1
        addq.b          #$08,(a5)
        addq.b          #$08,(a5)+
        addq.b          #$08,-(a5)
        addq.b          #$08,$7ffe
        addq.b          #$08,$ffff7ffe

        * addq.w permutations
        addq.w          #$08,d1
        addq.w          #$08,a1
        addq.w          #$08,(a5)
        addq.w          #$08,(a5)+
        addq.w          #$08,-(a5)
        addq.w          #$08,$7ffe
        addq.w          #$08,$ffff7ffe

        * addq.l permutations
        addq.l          #$08,d1
        addq.l          #$08,a1
        addq.l          #$08,(a5)
        addq.l          #$08,(a5)+
        addq.l          #$08,-(a5)
        addq.l          #$08,$7ffe
        addq.l          #$08,$ffff7ffe

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

        * asl.b permutations
        asl.b           d0,d0
        asl.b           #$08,d0

        * asl.w permutations
        asl.w           d0,d0
        asl.w           #$08,d0
        asl.w           (a4)
        asl.w           (a4)+
        asl.w           -(a4)
        asl.w           $7ffe
        asl.w           $ffff7ffe

        * asl.l permutations
        asl.l           d0,d0
        asl.l           #$08,d0
        
        * asr.b permutations
        asr.b           d0,d0
        asr.b           #$08,d0
        
        * asr.w permutations
        asr.w           d0,d0
        asr.w           #$08,d0
        asr.w           (a4)
        asr.w           (a4)+
        asr.w           -(a4)
        asr.w           $7ffe
        asr.w           $ffff7ffe

        * asr.l permutations
        asr.l           d0,d0
        asr.l           #$08,d0

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

        * lsl.b permutations
        lsl.b           d0,d0
        lsl.b           #$08,d0
        
        * lsl.w permutations
        lsl.w           d0,d0
        lsl.w           #$08,d0
        lsl.w           (a4)
        lsl.w           (a4)+
        lsl.w           -(a4)
        lsl.w           $7ffe
        lsl.w           $ffff7ffe

        * lsl.l permutations
        lsl.l           d0,d0
        lsl.l           #$08,d0

        * lsr.b permutations
        lsr.b           d0,d0
        lsr.b           #$08,d0
        
        * lsr.w permutations
        lsr.w           d0,d0
        lsr.w           #$08,d0
        lsr.w           (a4)
        lsr.w           (a4)+
        lsr.w           -(a4)
        lsr.w           $7ffe
        lsr.w           $ffff7ffe

        * lsr.l permutations
        lsr.l           d0,d0
        lsr.l           #$08,d0

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

        * movem.w permutations
        movem.w         d0-d7/a0-a7, (a4)
        movem.w         d0-d7/a0-a7, -(a1)
        movem.w         d0-d7/a0-a7, $7ffe
        movem.w         d0-d7/a0-a7, $ffff7ffe

        movem.w         (a4), d0-d7/a0-a7
        movem.w         (a3)+, d0-d7/a0-a7
        movem.w         $7ffe, d0-d7/a0-a7
        movem.w         $ffff7ffe, d0-d7/a0-a7

        * movem.l permutations
        movem.l         d0-d7/a0-a7, (a4)
        movem.l         d0-d7/a0-a7, -(a1)
        movem.l         d0-d7/a0-a7, $7ffe
        movem.l         d0-d7/a0-a7, $ffff7ffe

        movem.l         (a4), d0-d7/a0-a7
        movem.l         (a3)+, d0-d7/a0-a7
        movem.l         $7ffe, d0-d7/a0-a7
        movem.l         $ffff7ffe, d0-d7/a0-a7
        
        * moveq.l permutations
        moveq           #$08,d4

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
        
        * rol.b permutations
        rol.b           d0,d0
        rol.b           #$08,d0
        
        * rol.w permutations
        rol.w           d0,d0
        rol.w           #$08,d0
        rol.w           (a4)
        rol.w           (a4)+
        rol.w           -(a4)
        rol.w           $7ffe
        rol.w           $ffff7ffe

        * rol.l permutations
        rol.l           d0,d0
        rol.l           #$08,d0

        * ror.b permutations
        ror.b           d0,d0
        ror.b           #$08,d0
        
        * ror.w permutations
        ror.w           d0,d0
        ror.w           #$08,d0
        ror.w           (a4)
        ror.w           (a4)+
        ror.w           -(a4)
        ror.w           $7ffe
        ror.w           $ffff7ffe

        * ror.l permutations
        ror.l           d0,d0
        ror.l           #$08,d0

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
    end start



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
