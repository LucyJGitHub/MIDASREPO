/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Commitment Lines awaiting Auth Rep (EOD)')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0350  Total Commitment Lines Awaiting Authorisation (EOD)*/
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 093978             DATE 09OCT95              */
/*       PREV AMEND NO. S01498             DATE 11AUG94              */
/*                      35723              DATE 11FEB92              */
/*                      S01189             DATE 11AUG92              */
/*                      S01355             DATE 10JUL92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       093978 - Wrong name for message file LBUSRMSG               */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*                (also remove COB recovery processing)              */
/*       35723  - LB PROGRAM CANNOT BE RESTARTABLE                   */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       S01355 - RELEASE 3 INCORPORATION                            */
/*       R00300 - Message file changes                               */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
/*>>S01189>>*/
/**********  PGM                                                    **/
/*********** PGM        PARM(&CNAM &CSEQ)                          */ /*S01498*/
/*********** PGM        PARM(&RSEQ &RLVL &RENT &RPARM)      ************S01498*/
             PGM        PARM(&RTYP &RSEQ &RLVL &RENT &RPARM)          /*S01498*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RTYP) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01498*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01498*/
/**/                                                                  /*S01498*/
/*********** DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)             */ /*S01498*/
/*********** DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)               */ /*S01498*/
/*********** DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)              */ /*S01498*/
/*<<S01189<<*/
 
/* DECLARE VARIABLES */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
 
/* SEND PROGRAM MESSAGE */
/*>>>> S01355 >>>>                                                            */
/*           SNDPGMMSG  MSG('Lombard Total Commitment Lines Awaiting +       */
/*                        Authorisation Report - LBC0350') +                 */
/*                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)                       */
             SNDPGMMSG  MSG('Portfolio Lending Total Commitment Lines +
                          Awaiting Authorisation Report - LBC0350') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/*>>>> S01355 >>>>                                                            */
 
/* CREATE LDA IF NOT PRESENT */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
/*>>S01189>>*/
/***********       CHGVAR     VAR(&BUSY) VALUE(' ')                */ /*S01498*/
/***********       CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/***********       CHGVAR     VAR(&BUSY) VALUE('Y')                */ /*S01498*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/*<<S01189<<*/
 
/* CALL PROGRAM */
/*********** CALL       PGM(*LIBL/LB0350) PARM('0')                */ /*S01498*/
/*********** CALL       PGM(*LIBL/LB0350) PARM('0' &RSEQ +       **/ /*S01498*/
             CALL       PGM(*LIBL/LB0350) PARM(&RTYP &RSEQ +
                           &RLVL &RENT &RPARM)                        /*S01498*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)       /*35723*/
                   CHGJOB  SWS(XXXXXX11)                              /*35723*/
                   GOTO    CMDLBL(ABNOR)                              /*35723*/
             ENDDO                                                    /*35723*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
                                                                      /*R00300*/
/************SNDPGMMSG  MSGID(LBM9001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRSMG) MSGDTA(&DATA) +
 ***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01498*/
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRSMG) MSGDTA(&DATA) +   093978*/
/***********              TOMSGQ(MOPERQ MRUNQ)              *S01498*    093978*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*093978*/
                                                                      /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
                                                                      /*R00300*/
/************SNDPGMMSG  MSGID(LBM9002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
 ***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01498*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
                                                                      /*R00300*/
             ENDDO
/*>>S01189>>*/
/***********       CHGVAR     VAR(&BUSY) VALUE('N')                */ /*S01498*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/*<<S01189<<*/
 
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
