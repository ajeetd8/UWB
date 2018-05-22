ADDRESS_READ_DECISION_LOAD
ARDL_Source
        cmp.b   #7,SRC_MODE
        bne     ARDL_DST     * No source Data memory value
ARDL_SOURCE_WORD
        * Word compare
        cmp.b   #0,SRC_REGISTER
        bne     ARDL_SOURCE_LONG        * not word size
        move.w  (a6)+,SRC_NUMBER_DATA
        *move.w  (a6),WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST
ARDL_SOURCE_LONG                        * down here, check long size
        cmp.b   #1,SRC_REGISTER
        bne     ARDL_SOURCE_DATA        * not Long size
        move.l  (a6), SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST

***DATA check
ARDL_SOURCE_DATA                        * down here, check #<data>
        cmp.b   #4,SRC_REGISTER
        bne     INVALID_S               * Here is the code we don't need to disassemble

ARDL_SOURCE_DATA_BYTE
        * byte compare
        cmp.b   #BYTE,SIZE
        bne     ARDL_SOURCE_DATA_WORD
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST

ARDL_SOURCE_DATA_WORD
        cmp.b   #WORD,SIZE
        bne     ARDL_SOURCE_DATA_LONG
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST

ARDL_SOURCE_DATA_LONG
        cmp.b   #LONG,SIZE
        bne     INVALID_S
        move.l  (a6), SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_DST 


ARDL_DST                 * Address extension for source is not required
        cmp.b   #7,DEST_MODE
        bne     ARDL_FINAL_RTS

ARDL_DST_WORD
        * Word compare
        cmp.b   #0,DEST_REGISTER
        bne     ARDL_DST_LONG        * not word size
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS
ARDL_DST_LONG                        * down here, check long size
        cmp.b   #1,DEST_REGISTER
        bne     ARDL_DST_DATA        * not Long size
        move.l  (a6), DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS

***DATA check
ARDL_DST_DATA                        * down here, check #<data>
        cmp.b   #4,DEST_REGISTER
        bne     INVALID_S               * Here is the code we don't need to disassemble

ARDL_DST_DATA_BYTE
        * byte compare
        cmp.b   #BYTE,SIZE
        bne     ARDL_DST_DATA_WORD
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS

ARDL_DST_DATA_WORD
        cmp.b   #WORD,SIZE
        bne     ARDL_DST_DATA_LONG
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS

ARDL_DST_DATA_LONG
        cmp.b   #LONG,SIZE
        bne     INVALID_S
        move.l  (a6), DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     ARDL_FINAL_RTS 
* Address extension is not required
ARDL_FINAL_RTS
        rts

* -----------------------------------------------
***************************************************

***************************************************
* -----------------------------------------------
* Condition address decision load
* BCC BGT BLE
** Using DATA_EIGHT_BIT, SRC_NUMBER_DATA
CONDIITON_DECISION_LOAD
        cmp.b           #$00,DATA_EIGHT_BIT
        beq             CDL_16
        cmp.b           #$FF,DATA_EIGHT_BIT
        beq             CDL_32

        rts
CDL_16
        ** 16 bit displacement
        move.w          (a6)+,SRC_NUMBER_DATA
        rts
CDL_32
        ** 32 bit displacement
        move.l          (a6)+,SRC_NUMBER_DATA
        rts

* -----------------------------------------------
***************************************************