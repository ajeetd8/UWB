***************************************************************
* -> Initial two ea out mode
INITIAL_TWO_EA_LOAD_OUT
ITELO_Dn
    cmp.b       #0,SRC_MODE
    bne         ITELO_AN

    *** compare to d0 ~ d7
ITELO_D0
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_D1
    bsr         D_ZERO_S
    bra         ITELO_FINAL
ITELO_D1
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_D2
    bsr         D_ONE_S
    bra         ITELO_FINAL
ITELO_D2
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_D3
    bsr         D_TWO_S
    bra         ITELO_FINAL
ITELO_D3
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_D4
    bsr         D_THREE_S
    bra         ITELO_FINAL
ITELO_D4
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_D5
    bsr         D_FOUR_S
    bra         ITELO_FINAL
ITELO_D5
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_D6
    bsr         D_FIVE_S
    bra         ITELO_FINAL
ITELO_D6
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_D7
    bsr         D_SIX_S
    bra         ITELO_FINAL
ITELO_D7
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         D_SEVEN_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

ITELO_AN
    cmp.b       #1,SRC_MODE
    bne         ITELO_AN_P

    *** compare to a0 ~ a7
ITELO_A0
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_A1
    bsr         A_ZERO_S
    bra         ITELO_FINAL
ITELO_A1
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_A2
    bsr         A_ONE_S
    bra         ITELO_FINAL
ITELO_A2
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_A3
    bsr         A_TWO_S
    bra         ITELO_FINAL
ITELO_A3
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_A4
    bsr         A_THREE_S
    bra         ITELO_FINAL
ITELO_A4
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_A5
    bsr         A_FOUR_S
    bra         ITELO_FINAL
ITELO_A5
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_A6
    bsr         A_FIVE_S
    bra         ITELO_FINAL
ITELO_A6
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_A7
    bsr         A_SIX_S
    bra         ITELO_FINAL
ITELO_A7
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         A_SEVEN_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

ITELO_AN_P
    cmp.b       #2,SRC_MODE
    bne         ITELO_AN_P_P

    *** compare to a0 ~ a7
ITELO_A0_P
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_A1_P
    bsr         A_ZERO_P_S
    bra         ITELO_FINAL
ITELO_A1_P
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_A2_P
    bsr         A_ONE_P_S
    bra         ITELO_FINAL
ITELO_A2_P
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_A3_P
    bsr         A_TWO_P_S
    bra         ITELO_FINAL
ITELO_A3_P
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_A4_P
    bsr         A_THREE_P_S
    bra         ITELO_FINAL
ITELO_A4_P
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_A5_P
    bsr         A_FOUR_P_S
    bra         ITELO_FINAL
ITELO_A5_P
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_A6_P
    bsr         A_FIVE_P_S
    bra         ITELO_FINAL
ITELO_A6_P
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_A7_P
    bsr         A_SIX_P_S
    bra         ITELO_FINAL
ITELO_A7_P
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         A_SEVEN_P_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

ITELO_AN_P_P
    cmp.b       #3,SRC_MODE
    bne         ITELO_AN_P_M

    *** compare to a0 ~ a7
ITELO_A0_P_P
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_A1_P_P
    bsr         A_ZERO_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A1_P_P
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_A2_P_P
    bsr         A_ONE_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A2_P_P
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_A3_P_P
    bsr         A_TWO_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A3_P_P
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_A4_P_P
    bsr         A_THREE_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A4_P_P
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_A5_P_P
    bsr         A_FOUR_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A5_P_P
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_A6_P_P
    bsr         A_FIVE_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A6_P_P
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_A7_P_P
    bsr         A_SIX_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
ITELO_A7_P_P
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         A_SEVEN_P_S
    bsr         PLUS_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

ITELO_AN_P_M
    cmp.b       #4,SRC_MODE
    bne         ITELO_ADR_WLD

    *** compare to a0 ~ a7
ITELO_A0_P_M
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_A1_P_M
    bsr         MINUS_S
    bsr         A_ZERO_P_S
    bra         ITELO_FINAL
ITELO_A1_P_M
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_A2_P_M
    bsr         MINUS_S
    bsr         A_ONE_P_S
    bra         ITELO_FINAL
ITELO_A2_P_M
    cmp.b       #2,SRC_REGISTER
    bne         ITELO_A3_P_M
    bsr         MINUS_S
    bsr         A_TWO_P_S
    bra         ITELO_FINAL
ITELO_A3_P_M
    cmp.b       #3,SRC_REGISTER
    bne         ITELO_A4_P_M
    bsr         MINUS_S
    bsr         A_THREE_P_S
    bra         ITELO_FINAL
ITELO_A4_P_M
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_A5_P_M
    bsr         MINUS_S
    bsr         A_FOUR_P_S
    bra         ITELO_FINAL
ITELO_A5_P_M
    cmp.b       #5,SRC_REGISTER
    bne         ITELO_A6_P_M
    bsr         MINUS_S
    bsr         A_FIVE_P_S
    bra         ITELO_FINAL
ITELO_A6_P_M
    cmp.b       #6,SRC_REGISTER
    bne         ITELO_A7_P_M
    bsr         MINUS_S
    bsr         A_SIX_P_S
    bra         ITELO_FINAL
ITELO_A7_P_M
    cmp.b       #7,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         MINUS_S
    bsr         A_SEVEN_P_S
    bra         ITELO_FINAL
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
* WORD, LONG, DATA, (XXX).W (XXX).L #<data>
ITELO_ADR_WLD
    cmp.b       #7,SRC_MODE
    bne         ITELO_INVALID
ITELO_ADR_WLD_WORD
    cmp.b       #0,SRC_REGISTER
    bne         ITELO_ADR_WLD_LONG
    bsr         DOLLAR_S

    cmp.w       #$8000,SRC_NUMBER_DATA
    bcs         ITELO_AWW_OUT
ITELO_AWW_FFFF
    move.w      #$ffff,WORD_OUT
    bsr         WORD_OUT_S
ITELO_AWW_OUT
    move.w      SRC_NUMBER_DATA,WORD_OUT
    bsr         WORD_OUT_S

    bra         ITELO_FINAL


ITELO_ADR_WLD_LONG
    cmp.b       #1,SRC_REGISTER
    bne         ITELO_ADR_WLD_DATA
    bsr         DOLLAR_S

    movem.l     d0,-(sp)

    cmp.w       #$0000,SRC_NUMBER_DATA
    beq         ITELO_ADR_WLD_L_NPRCD
ITELO_ADR_WLD_L_PRCD
    move.w      SRC_NUMBER_DATA,WORD_OUT
    bsr         WORD_OUT_S
ITELO_ADR_WLD_L_NPRCD
    move.l      SRC_NUMBER_DATA,d0
    move.w      d0,WORD_OUT
    bsr         WORD_OUT_S

    movem.l     (sp)+,d0

    bra         ITELO_FINAL
ITELO_ADR_WLD_DATA
    cmp.b       #4,SRC_REGISTER
    bne         ITELO_INVALID
    bsr         HASH_S
    bsr         DOLLAR_S

ITELO_AWD_WORD
    ** WORD SIZE
    cmp.b       #WORD,SIZE
    bne         ITELO_AWD_LONG
    move.w      SRC_NUMBER_DATA,WORD_OUT
    bsr         WORD_OUT_S
    bra         ITELO_FINAL
ITELO_AWD_LONG
    ** LONG SIZE
    cmp.b       #LONG,SIZE
    bne         ITELO_AWD_BYTE

    movem.l     d0,-(sp)

    move.w      SRC_NUMBER_DATA,WORD_OUT
    bsr         WORD_OUT_S
    move.l      SRC_NUMBER_DATA,d0
    move.w      d0,WORD_OUT
    bsr         WORD_OUT_S

    movem.l     (sp)+,d0

    bra         ITELO_FINAL

ITELO_AWD_BYTE
    ** BYTE SIZE
    cmp.b       #BYTE,SIZE
    bne         ITELO_INVALID

    movem.w     d0,-(sp)

    move.w      SRC_NUMBER_DATA,d0
    move.b      d0,BYTE_OUT
    bsr         BYTE_OUT_S

    movem.w     (sp)+,d0

    bra         ITELO_FINAL

ITELO_INVALID
    bra         INVALID_S
ITELO_FINAL
    rts

* -> Initial two ea out mode
***************************************************************

***************************************************************
* -> Initial four ea out mode
INITIAL_FOUR_EA_LOAD_OUT
    movem.l     d0-d2,-(sp)

    move.b      DEST_REGISTER,d0
    move.b      DEST_MODE,d1
    move.l      DST_NUMBER_DATA,d2

    bsr         INITIAL_TWO_EA_LOAD_OUT             * Source out

    bsr         COMMA_S

    move.b      DEST_REGISTER,SRC_REGISTER          * Destination out
    move.b      DEST_MODE,SRC_MODE
    move.l      DST_NUMBER_DATA,SRC_NUMBER_DATA
    movem.l     (sp)+,d0-d2
    bsr         INITIAL_TWO_EA_LOAD_OUT

    *move.b      d0,DEST_REGISTER
    *move.b      d1,DEST_MODE
    *move.l      d2,DST_NUMBER_DATA
    *movem.l     (sp)+,d0-d2

    rts

* -> Initial four ea out mode
***************************************************************