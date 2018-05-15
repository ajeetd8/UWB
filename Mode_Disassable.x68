*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: This is disassemble code to analyze addressing mode, and register mode
*-----------------------------------------------------------
    
START:                 ORG    $1000


    simhalt
    
    
    org $7000
    
    move.b      #$01,d0

    END    START        ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
