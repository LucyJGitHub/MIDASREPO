/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Commitment Lines Exceeding Borr. Power')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0380 - Total Commitment Lines Exceeding Borrowing Power  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01498             Date 11Aug94              */
/*                      053924             Date 16Apr93              */
/*                      035723             DATE 11FEB92              */
/*                      S01189     GB      DATE 11AUG92              */
/*                      S01355             DATE 10JUL92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*                COB recovery processing removed                    */
/*       053924 - BYPASS COB RECOVERY PROCESSING IF PGM IS           */
/*                CALLED FROM IC MENU                                */
/*       035723 - LB PROGRAM CANNOT BE RESTARTABLE                   */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       S01355 - RELEASE 3 INCORPORATION                            */
/*       R00300 - Message file changes                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01498*/
/*>>S01189>>*/
/**********  PGM                                                    **/
/*********** PGM        PARM(&CNAM &CSEQ)                          */ /*S01498*/
/*********** DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)             */ /*S01498*/
/*********** DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)               */ /*S01498*/
/*********** DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)              */ /*S01498*/
/*<<S01189<<*/
 
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01498*/
/* >>> 053924 >>> */
/*********** DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)             */ /*S01498*/
/* <<< 053924 <<< */
 
/* SEND PROGRAM MESSAGE */
/* >>>>> S01355 >>>>> */
/*           SNDPGMMSG  MSG('Lombard Commitment Lines Exceeding +            */
/*                        Borrowing Power Report - LBC0380') +               */
/*                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)                       */
             SNDPGMMSG  MSG('Portfolio Lending Commitment Lines Exceeding +
                          Borrowing Power Report - LBC0380') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/* <<<<< S01355 <<<<< */
 
/* CREATE LDA IF NOT PRESENT */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* >>> 053924 >>> */
/**BYPASS*COB*RECOVERY*IF*PGM*IS*CALLED*FROM*IC*MENU****************/ /*S01498*/
/*******************************************************************/ /*S01498*/
/*********** RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)         */ /*S01498*/
/*********** IF         COND(&MPHAS *NE 'A') THEN(DO)              */ /*S01498*/
/* <<< 053924 <<< */
/*>>S01189>>*/
/***********       CHGVAR     VAR(&BUSY) VALUE(' ')                */ /*S01498*/
/***********       CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/***********       CHGVAR     VAR(&BUSY) VALUE('Y')                */ /*S01498*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/*<<S01189<<*/
/* >>> 053924 >>> */
/*********** ENDDO                                                 */ /*S01498*/
/* <<< 053924 <<< */
 
/* CALL PROGRAM */
/*********** CALL       PGM(*LIBL/LB0380)                          */ /*S01498*/
             CALL       PGM(LB0380) PARM(&RSEQ &RENT)                 /*S01498*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)       /*035723*/
             CHGJOB     SWS(XXXXXX11)                                 /*035723*/
             GOTO       CMDLBL(ABNOR)                                 /*035723*/
             ENDDO                                                    /*035723*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
                                                                      /*R00300*/
/************SNDPGMMSG  MSGID(LBM9001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*********** SNDPGMMSG MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01498*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01498*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
                                                                      /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
                                                                      /*R00300*/
/************SNDPGMMSG  MSGID(LBM9002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*********** SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01498*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01498*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
                                                                      /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* >>> 053924 >>> */
/*********** IF         COND(&MPHAS *NE 'A') THEN(DO)              */ /*S01498*/
/* <<< 053924 <<< */
/*>>S01189>>*/
/***********       CHGVAR     VAR(&BUSY) VALUE('N')                */ /*S01498*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/*<<S01189<<*/
/* >>> 053924 >>> */
/*********** ENDDO                                                 */ /*S01498*/
/* <<< 053924 <<< */
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
