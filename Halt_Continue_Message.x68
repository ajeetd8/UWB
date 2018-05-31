*******************************************************************************************
* Halting the simulator
HALT
        move.b          #$00,MAIN_LOOP_COUNT         Clear the Loop count
        
        * Getting the 'Enter' Key from the user
        * Once you get the enter, clear the screen
        * go back to the routine

        bsr             PRESS_ENTER_S
        bsr             WAIT_ENTER

        bsr             CLEAR_SCREEN
        bra             MAIN_LOOP

* ----------------------------------
WAIT_ENTER
        move.b          #5,d0
        trap            #15


        
        cmp.b           #$0d,d1
        bne             WAIT_ENTER
        rts
* ----------------------------------
*******************************************************************************************