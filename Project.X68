*-----------------------------------------------------------
* Title      :  Project.x68
* Written by :  Byunggeun Park, Erik J. Maldonado, Haram Kwon
* Date       :  April.23.2018 ~ May.
* Description:  CSS 422 Group Project
*               1. 
*-----------------------------------------------------------
    
START:                 ORG    $1000
* From here, he need to write our disassembly code

        bra             done        Terminating the program
*Instruction for terminating the program
DONE
        move.b          #9,d0
        trap            #15



* From here, the code we are going to disassemble.
DISASSEMBLE:                    ORG         $7000

        move.l          #$4000,D0

    END     DISASSEMBLE
        END         START



*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
