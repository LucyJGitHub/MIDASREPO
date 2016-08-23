/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL AVERAGE RATES')                              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0802D - AVERAGE RATES                                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E27942            DATE  03SEP91             */
/*       PREV AMEND NO. S01194            DATE  17/07/89            */
/*                      S01117            DATE  17/07/89            */
/*                      S01179            DATE  12/09/88            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       E27942  -  FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A    */
/*                  LEVEL OF BLANKS                                 */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  STANDING DATA CHANGES                           */
/*       S01179  -  AS400 CONVERSION                                */
/********************************************************************/
/*********** PGM                                                      /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/**/
/*********** DCLDTAARA  DTAARA(MMOD)                                    S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
/**/
/*********** RCVDTAARA  DTAARA(MMOD)                                    S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/**/
             CHGJOB     SWS(00000000)
/**/
             IF         COND(%SUBSTRING(&MMOD 4 1) = 'Y') +
                        THEN(CHGJOB   SWS(X1XXXXXX))
/**/
             SNDMSG     MSG('AVERAGE RATES BY CURRENCY REPORT') +
                           TOMSGQ(MRUNQ)
/*********** OVRDBF     FILE(TABLE)   TOFILE(TABDLEE)                 /*S01194*/
/*********** CALL       PGM(DL0600)                                   /*S01117*/
 
/* REPORT BY SYSTEM   */
/************IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL0600) +
/************             PARM(&RSEQ))                       /*S01117* *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL0600) PARM(&RSEQ))          /*E27942*/
 
/* REPORT BY BRANCH   */
                IF   COND(&RLEV *EQ 'B') THEN(CALL PGM(DL0601) +
                                  PARM(&RSEQ &RENT))                  /*S01117*/
 
/* REPORT BY COMPANY  */
                IF   COND(&RLEV *EQ 'C') THEN(CALL PGM(DL0602) +
                                  PARM(&RSEQ &RENT))                  /*S01117*/
             RTVJOBA    SWS(&SWS)
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/
/*/COPY WNCPYSRC,DLC0802D01                                          */
             IF         COND(%SUBSTRING(&SWS 7 2) = '11') THEN(SNDMSG +
                        MSG('Job terminated - database in error') +
                        TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) = '01') THEN(SNDMSG +
                        MSG('File controls out of balance') +
                        TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
