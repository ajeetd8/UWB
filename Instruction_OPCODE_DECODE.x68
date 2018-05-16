*******************************************************
* Description: Odcode reading
*1)
** INITIAL_FOUR_EA_LOAD
*** ???? | DST Register(3) | Dest Mode(3) | Src Mode(3) | Src Register(3)

*2) INITIAL_TWO_EA_LOAD
** ???? | ??? | ??? | Src Mode(3) | Src Register(3)

*3) INITIAL_TWO_EA_LOAD_SIZE
** ???? | ???? | size(2) | Src Mode(3) | Src Register(3)
*
*
* Description: 


*******************************************************
* Effective address part
* Load four EA (last four) from Initial instruction.
INITIAL_FOUR_EA_LOAD
        movem.w         d7,-(sp)

        bsr             INITIAL_TWO_EA_LOAD             *Load last two

        ror.w           #6,d7
        move.b          d7,CONVERSOIN_RESERVED
        bsr             THREE_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,DEST_MODE

        ror.w           #3,d7
        move.b          d7,CONVERSOIN_RESERVED
        bsr             THREE_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,DEST_REGISTER

        movem.w         (sp)+,d7

        rts

INITIAL_TWO_EA_LOAD_SIZE

        movem.w         d7,-(sp)

        bsr             INITIAL_TWO_EA_LOAD
        move.w          INITIAL_INSTRUCTION,d7
        ror.b           #6,d7
        move.b          d7,CONVERSOIN_RESERVED
        bsr             TWO_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,SIZE

        movem.w         (sp)+,d7       

        rts

* Load two Ea(last two) from Initial instruction
INITIAL_TWO_EA_LOAD
        movem.w         d7,-(sp)

        move.w          INITIAL_INSTRUCTION,d7
        move.b          d7,CONVERSOIN_RESERVED
        bsr             THREE_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,SRC_REGISTER

        ror.w           #3,d7
        move.b          76,CONVERSOIN_RESERVED
        bsr             THREE_BIT_ONLY
        move.b          CONVERSOIN_RESERVED,SRC_MODE

        movem.w         (sp)+,d7          

        rts
* Effective address load end here
***************************************************************