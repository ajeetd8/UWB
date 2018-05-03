*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    lea         $10000,a7


    movea.l      #$0012F23F,a0
    
    move.l      a0,d5
    
    move.l      #$12341234,d0
    clr         d0

LOOP_1
    cmp.b       #$08,d0
    bge         EXIT_1
    addi.b      #$01,d0
    
    move.b      d5,d4
    bclr        #4,d4
    bclr        #5,d4
    bclr        #6,d4
    bclr        #7,d4
    
    ror.l       #4,d5
    
    movem.w     d4,-(sp)
    
    
    bra         LOOP_1
EXIT_1  
    
    clr         d7
LOOP_2
    cmp.b       #$08,d7
    bge         EXIT_2
    addi.b      #$01,d7
    clr.l       d0
    movem.w     (sp)+,d4
    move.b      d4,d1
    addi.b      #$30,d1
    
    cmp.b       #$3a,d1
    blo         OUT
    addi.b      #7,d1
    
OUT    
    move.b      #6,d0
    trap        #15

    
    bra         LOOP_2
    
EXIT_2
    SIMHALT
    
    
    
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
