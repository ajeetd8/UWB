** Reference Size 'Converting Table.txt'
*
* SIZE_CONVERT_TYPE_ONE

* Size converting operation
SIZE_CONVERT_TYPE_ONE
****Putting size into the destined size
SCTO_BYTE
        cmp.b           #0,SIZE
        bne             SCTO_WORD
        bsr             SIZE_BYTE
        rts
SCTO_WORD
        cmp.b           #1,SIZE
        bne             SCTO_LONG
        bsr             SIZE_WORD
        rts
SCTO_LONG
        cmp.b           #2,SIZE
        bne             SCTO_INVALID
        bsr             SIZE_LONG
        rts
SCTO_INVALID                           ** Invalid size instruction.
        bra             INVALID_S
        rts

* Set 'SIZE'
SIZE_BYTE
        move.b          #BYTE,SIZE
        rts
SIZE_WORD
        move.b          #WORD,SIZE
        rts
SIZE_LONG
        move.b          #LONG,SIZE
        rts