/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FUTURE DEAL AMENDMENTS REPORT')              */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                            */
/*                                                                  */
/*       DLC0807 - OUTSTANDING DEAL AMENDMENTS                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E27942            DATE 03SEP91              */
/*       PREV AMEND NO. E255/S01117       DATE  7MAR90              */
/*                      E255/S01194       DATE  7MAR90              */
/*                                                                  */
/* E27942 - FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A            */
/*          LEVEL OF BLANKS                                         */
/* E255 - MUST PROCESS FOR REQUEST BY DIFFERENT ENTITIES            */
/* S01117 - MULTIBRANCHING CHANGES                                  */
/* S01194 - ADDITION OF NEW STANDING DATA FILES                     */
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
             SNDMSG     MSG('OUTSTANDING DEAL AMENDMENTS') +
                        TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
             SNDMSG     MSG('FUTURE DEALS AMENDMENTS REPORT') +
                        TOMSGQ(MRUNQ)
/*********** OVRDBF     FILE(TABLED)  TOFILE(TABDLEE)                 /*S01194*/
/*********** CALL       PGM(DL0830)                                   /*S01117*/
 
/* REPORT BY SYSTEM   */
/***************IF   COND(&RLEV *EQ 'S') THEN(CALL PGM(DL0830) +
/***************                  PARM(&RSEQ))               /*S01117* *E27942*/
                IF   COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CALL PGM(DL0830) PARM(&RSEQ))          /*E27942*/
 
/* REPORT BY BRANCH   */
                IF   COND(&RLEV *EQ 'B') THEN(CALL PGM(DL0831) +
                                  PARM(&RSEQ &RENT))                  /*S01117*/
 
/* REPORT BY COMPANY  */
                IF   COND(&RLEV *EQ 'C') THEN(CALL PGM(DL0832) +
                                  PARM(&RSEQ &RENT))                  /*S01117*/
 
             RTVJOBA    SWS(&SWS)
/**********  DLTOVR     FILE(TABLED)                                  /*S01194*/
/**/
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
