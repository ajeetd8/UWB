*-----------------------------------------------------------
* Title      :  Project.x68
* Written by :  Byunggeun Park, Erik J. Maldonado, Haram Kwon
* Date       :  April.23.2018 ~ May.
* Description:  CSS 422 Group Project
*               1. The prgram start at 1000.
*               2. The program start to read memory from $7000 and disassemble.
*               3. The program will console out the disassembled output.
*-----------------------------------------------------------
    
START:                 ORG              $1000
* From here, he need to write our disassembly code

        bra             done        Terminating the program
*Instruction for terminating the program
DONE
        move.b          #9,d0
        trap            #15



* From here, the code we are going to disassemble.
DISASSEMBLE:                    ORG         $7000

** this is a sample to disassemble.

        move.l      #$c198f382,d0
        add.w       d0,d1
        asl.b       #3,d0
        asl.l       #4,d0
        lsr.b       #7,d0
        rol.w       #2,d0
        ror.l       #7,d0

        END     DISASSEMBLE
        END         START






*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
