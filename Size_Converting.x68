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


* Size converting type two
SIZE_CONVERT_TYPE_TWO
**** Putting size into the destined size

        ** Byte case %000, %100
        cmp.b   #0,SIZE
        beq     SCTT_BYTE
        cmp.b   #4,SIZE
        beq     SCTT_BYTE

        ** Word case %001, %101
        cmp.b   #1,SIZE
        beq     SCTT_WORD
        cmp.b   #5,SIZE
        beq     SCTT_WORD

        ** Long case %010, %110
        cmp.b   #2,SIZE
        beq     SCTT_LONG
        cmp.b   #6,SIZE
        beq     SCTT_LONG

** Set size byte
SCTT_BYTE
        bsr     SIZE_BYTE
        rts
** Set size word
SCTT_WORD
        bsr     SIZE_WORD
        rts
** Set size long
SCTT_LONG
        bsr     SIZE_LONG
        rts
** Invalid case
SCTT_INVALID
        bra     INVALID_S
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