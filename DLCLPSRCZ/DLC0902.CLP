/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Interim brokerage report')                   */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0902 - INTERIM BROKERAGE REPORT                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 048654             DATE 31DEC92             */
/*       PREV AMEND NO. AUS007             DATE 13JUL92             */
/*                      E27942             DATE 03SEP91             */
/*                      S01194             DATE 22/09/89            */
/*                      S01117             DATE 22/09/89            */
/*                      E10505             DATE  30/03/87           */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       048654 - AUS007 APPLIED INCORRECTLY                        *  *048654*/
/*       AUS007 - AUSTRALIAN BROKERAGE.                             *  *AUS007*/
/*       E27942  -  FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A    */
/*                  LEVEL OF BLANKS                                 */
/*       S01194  -  NEW STANDING DATA (REMOVAL OF TABLE FILES)      */
/*       S01117  -  MULTIBRANCHING/RELEASE 10 CHANGES               */
/*       E10505 - ON REQUEST BROKERAGE REPORT IS NOT RUNNING THE    *  *E10505*/
/*                REPORT IN INTERIM MODE.                           *  *E10505*/
/*                                                                  */
/********************************************************************/
/************PGM                                                      /*S01117*/
 
             PGM PARM(&RSEQ &RLEV &RENT)                              /*S01117*/
 
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*AUS007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*AUS007*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*AUS007*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*AUS007*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) +
                          VALUE('Job terminated - database in error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) VALUE('File +
                          controls out of balance')
/**/
             SNDMSG     MSG('Interim brokerage report') +
                          TOMSGQ(MRUNQ)
/**/
/************CHGVAR     VAR(&SWS) VALUE('0XXXXX00')******************  *E10505*/
             CHGJOB     SWS(00000000)                                 /*E10505*/
             SNDMSG     MSG('Brokerage extract - Interim') +
                          TOMSGQ(MRUNQ)
/**/
             CLRPFM     FILE(BROKXHH)
             CLRPFM     FILE(BROKXBD)
             CLRPFM     FILE(BROKXTT)
/*********   OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                   /*S01194*/
/*********   OVRDBF     FILE(TABLED) TOFILE(TABDLEE)                  /*S01194*/
             OVRDBF     FILE(DEALRD) TOFILE(DEALS) SHARE(*NO)
/**/
             CALL       PGM(DL1200)
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
                                                                      /*S01117*/
/* MUST COPE WITH NON MULTIBRANCHED SYSTEM WHEN LEVEL SENT AS 'S' */  /*S01117*/
/************IF         COND(&RLEV *EQ 'S') THEN(CHGVAR VAR(&RENT) +
/************             VALUE('ALL'))                       *S01117* *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CHGVAR VAR(&RENT) VALUE('ALL'))        /*E27942*/
                                                                      /*S01117*/
                SNDMSG     MSG('Brokerage report - Interim') TOMSGQ(MRUNQ)
                CHGVAR     VAR(&SWS) VALUE('00000000')
/***********    OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                /*S01194*/
/***********    OVRDBF     FILE(TABD) TOFILE(TABDLEI)                 /*S01194*/
/*************  CALL       PGM(DL1220)                                /*S01117*/
                CALL       PGM(DL1220) PARM(&RSEQ &RENT)              /*S01117*/
                RTVJOBA    SWS(&SWS)
/***********    DLTOVR    FILE(TABD)                                  /*S01194*/
/**/
             ENDDO
/**/
/*********** DLTOVR     FILE(TABLE TABLED)                            /*S01194*/
/**/                                                                  /*AUS007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*AUS007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*AUS007*/
             CHGVAR     VAR(&SAR) VALUE('AUS007')                     /*AUS007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*AUS007*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*AUS007*/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)  /*AUS007*/
                CHGVAR     VAR(&SWS) VALUE('00000000')                /*AUS007*/
/**********     CALL       PGM(DLC8102) PARM(&RSEQ &RLEV &RENT) *AUS007 048654*/
                CALL       PGM(DLC8102) PARM(&RSEQ &RENT)             /*048654*/
             ENDDO                                                    /*AUS007*/
             ENDDO                                                    /*AUS007*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG(&MSG2) TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
