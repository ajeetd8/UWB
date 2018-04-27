*-----------------------------------------------------------
* Title      : Effective_Address with opcode
* Written by : Haram, Byeonggeun, Erikc
* Date       : 
* Description: this code will traverse memory. This code is
* expected to merge to Project.X68
*-----------------------------------------------------------

STACK                   equ         $100000
DISASSEMBLE_FROM        equ         $7000
CR                      equ         $0d
LF                      equ         $0a  

START:  org             $1000
        * Setting the stack address.
        lea             STACK,sp 
        lea             DISASSEMBLE_FROM,a6     move value of DISASSEMLE_FROM
* From here, he need to write our disassembly code
LOOP
        move.l          (a6),d7
        cmp.l           #$FFFFFFFF,d7
        beq             DONE                    Terminating the program.
        
        * Read word by words.
        move.w          (a6)+,d5
        addi.l         #1,d4
        
        * Every loop is incrementing by word
        * We have to find pattern, bit by bits, and
        * Do additional bit increment here (a6)
        
        bra             LOOP

**************************************************************************************************
        * From here, the code we are going to disassemble.
**************************************************************************************************
        org             DISASSEMBLE_FROM        Code after this starts at DISASSEMBLE_FROM

*this is a sample code to disassemble.

        MOVE.W      D0,D1
   
*Instruction for terminating the program
DONE
        SIMHALT
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
