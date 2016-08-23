/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL MDDR usage prompt')                          */
/********************************************************************/
/*                                                                  */
/*       Midas        Dealing Module                            */
/*                                                                  */
/*       DLC764P - MDDR USAGE 70/100% REPORT - PROMPT               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E38654                  DATE  23APR92       */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*            E38654 - PROMPT PGM SHOULD ALLOW FOR F12 AND F10      */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
/**/
             DCLF       FILE(DLC764DF) RCDFMT(DLC764)
/**/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SRUNA)
             RTVJOBA    JOB(&SWSID)
/**/                                                                  /*E38654*/
/* RETRIEVE PROMPT VALUES TO BE DISPLAYED ON AMEND, ENQUIRY OR DELETE /*E38654*/
             IF         COND(&RACT *EQ 'A' *OR &RACT *EQ 'E' *OR +
                          &RACT *EQ 'D') THEN(DO)                     /*E38654*/
             IF         COND(&RPARM *EQ '070') THEN(CHGVAR +
                          VAR(&SEVNTY) VALUE('Y'))                    /*E38654*/
             IF         COND(&RPARM *EQ '100') THEN(CHGVAR +
                          VAR(&HUNDRD) VALUE('Y'))                    /*E38654*/
             ENDDO                                                    /*E38654*/
             ELSE       CMD(DO)                                       /*E38654*/
             CHGVAR     VAR(&SEVNTY) VALUE(' ')                       /*E38654*/
             CHGVAR     VAR(&HUNDRD) VALUE(' ')                       /*E38654*/
             ENDDO                                                    /*E38654*/
             IF         COND(&RACT *EQ 'D') THEN(CHGVAR VAR(&IN03) +
                          VALUE('1'))                                 /*E38654*/
/**/
 ERROR:      SNDRCVF    RCDFMT(DLC764)
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
/**/
/* IF F3, RETURN TO RCF WITH ACTION CODE = END  */
             IF         COND(&IN01 *EQ '1') THEN(DO)
             CHGVAR     VAR(&RCMD) VALUE('E')
             GOTO       CMDLBL(ENDLBL)
             ENDDO
/* IF F12, RETURN TO RCF WITH ACTION CODE = PREVIOUS  */              /*E38654*/
             IF         COND(&IN02 *EQ '1') THEN(DO)                  /*E38654*/
             CHGVAR     VAR(&RCMD) VALUE('F')                         /*E38654*/
             GOTO       CMDLBL(ENDLBL)                                /*E38654*/
             ENDDO                                                    /*E38654*/
/* IF F10, RETURN TO RCF WITH ACTION CODE = DELETE  */                /*E38654*/
             IF         COND(&IN13 *EQ '1') THEN(DO)                  /*E38654*/
             CHGVAR     VAR(&RCMD) VALUE('D')                         /*E38654*/
             GOTO       CMDLBL(ENDLBL)                                /*E38654*/
             ENDDO                                                    /*E38654*/
/* CHECK INPUTS */
             IF         COND(&SEVNTY *EQ 'Y') THEN(DO)
                IF         COND(&HUNDRD *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('     Cannot Enter Both +
                          Options')
                CHGVAR     VAR(&IN10) VALUE('1')
                GOTO       CMDLBL(ERROR)
                ENDDO
                IF         COND(&HUNDRD *NE ' ') THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('     Invalid Entry')
                CHGVAR     VAR(&IN11) VALUE('1')
                CHGVAR     VAR(&IN10) VALUE('1')
                GOTO       CMDLBL(ERROR)
                ENDDO
             CHGVAR     VAR(%SUBSTRING(&RPARM 1 3)) +
                        VALUE('070')
             GOTO       CMDLBL(ENDLBL)
             ENDDO
/**/
             IF         COND(&HUNDRD *EQ 'Y') THEN(DO)
                IF         COND(&SEVNTY *NE ' ') THEN(DO)
                CHGVAR     VAR(&MSG) VALUE('     Invalid Entry')
                CHGVAR     VAR(&IN11) VALUE('1')
                CHGVAR     VAR(&IN10) VALUE('1')
                GOTO       CMDLBL(ERROR)
                ENDDO
             CHGVAR     VAR(%SUBSTRING(&RPARM 1 3)) +
                        VALUE('100')
             GOTO       CMDLBL(ENDLBL)
             ENDDO
/**/
/**/
     IF         COND(&SEVNTY *EQ ' ') THEN(DO)
             IF         COND(&HUNDRD *EQ ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('     Must Enter One Option')
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&IN11) VALUE('1')
               CHGVAR     VAR(&IN12) VALUE('1')
               ENDDO
/**/
               IF         COND(&HUNDRD *NE ' ') THEN(DO)
               CHGVAR     VAR(&IN12) VALUE('1')
               CHGVAR     VAR(&IN10) VALUE('1')
               CHGVAR     VAR(&MSG) VALUE('     Invalid Entry')
               ENDDO
     ENDDO
/**/
     IF         COND(&SEVNTY *NE ' ') THEN(DO)
     CHGVAR     VAR(&MSG) VALUE('     Invalid Entry')
     CHGVAR     VAR(&IN11) VALUE('1')
     CHGVAR     VAR(&IN10) VALUE('1')
     ENDDO
             GOTO       CMDLBL(ERROR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDLBL:     ENDPGM
