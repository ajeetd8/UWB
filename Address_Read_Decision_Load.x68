ADDRESS_OPERAND_DESTINATION_OUT
AODO_Source
        cmp.b   #7,SRC_MODE
        bne     AODO_DST     * No source Data memory value
AODO_SOURCE_WORD
        * Word compare
        cmp.b   #0,SRC_REGISTER
        bne     AODO_SOURCE_LONG        * not word size
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST
AODO_SOURCE_LONG                        * down here, check long size
        cmp.b   #1,SRC_REGISTER
        bne     AODO_SOURCE_DATA        * not Long size
        move.l  (a6), SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST

***DATA check
AODO_SOURCE_DATA                        * down here, check #<data>
        cmp.b   #4,SRC_REGISTER
        bne     INVALID_S               * Here is the code we don't need to disassemble

AODO_SOURCE_DATA_BYTE
        * byte compare
        cmp.b   #BYTE,SIZE
        bne     AODO_SOURCE_DATA_WORD
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        * TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST

AODO_SOURCE_DATA_WORD
        cmp.b   #WORD,SIZE
        bne     AODO_SOURCE_DATA_LONG
        move.w  (a6),SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST

AODO_SOURCE_DATA_LONG
        cmp.b   #LONG,SIZE
        bne     INVALID_S
        move.l  (a6), SRC_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_DST 


AODO_DST                 * Address extension for source is not required
        cmp.b   #7,DEST_MODE
        bne     AODO_FINAL_RTS

AODO_DST_WORD
        * Word compare
        cmp.b   #0,DEST_REGISTER
        bne     AODO_DST_LONG        * not word size
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS
AODO_DST_LONG                        * down here, check long size
        cmp.b   #1,DEST_REGISTER
        bne     AODO_DST_DATA        * not Long size
        move.l  (a6), DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS

***DATA check
AODO_DST_DATA                        * down here, check #<data>
        cmp.b   #4,DEST_REGISTER
        bne     INVALID_S               * Here is the code we don't need to disassemble

AODO_DST_DATA_BYTE
        * byte compare
        cmp.b   #BYTE,SIZE
        bne     AODO_DST_DATA_WORD
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS

AODO_DST_DATA_WORD
        cmp.b   #WORD,SIZE
        bne     AODO_DST_DATA_LONG
        move.w  (a6),DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS

AODO_DST_DATA_LONG
        cmp.b   #LONG,SIZE
        bne     INVALID_S
        move.l  (a6), DST_NUMBER_DATA
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        move.w  (a6)+,WORD_OUT
        *TODO: DELETE THIS
        *bsr     WORD_OUT_S
        bra     AODO_FINAL_RTS 
* Address extension is not required
AODO_FINAL_RTS
        rts

* -----------------------------------------------
***************************************************