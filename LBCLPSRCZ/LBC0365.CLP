/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Commitment Lines exceeded by % rpt (EOD)')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0365 - Commitment Lines Exceeded by % (EOD)              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01498             DATE 11AUG94              */
/*       PREV AMEND NO. 35723              DATE 11FEB92              */
/*                      S01189             DATE 11AUG92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*                COB recovery processing removed                    */
/*       35723  - LB PROGRAM CANNOT BE RESTARTABLE                   */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       R00300 - Message file changes                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*>>S01189>>*/
/**********  PGM                                                    **/
/*********** PGM        PARM(&CNAM &CSEQ)                          */ /*S01498*/
             PGM        PARM(&RTYP &RSEQ &RLEV &RENT &RPARM)          /*S01498*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTYP) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01498*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01498*/
/*********** DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)             */ /*S01498*/
/*********** DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)               */ /*S01498*/
/*********** DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)              */ /*S01498*/
/*<<S01189<<*/
 
/* DECLARE VARIABLES */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('LBC0365 - Commitment Lines exceeded by +
                          %') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
/*>>S01189>>*/
/***********       CHGVAR     VAR(&BUSY) VALUE(' ')                   /*S01498*/
/***********       CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)          /*S01498*/
/***********       CHGVAR     VAR(&BUSY) VALUE('Y')                   /*S01498*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)          /*S01498*/
/*<<S01189<<*/
 
/* CALL PROGRAM */
/*********** CALL       PGM(*LIBL/LB0365) PARM('0' 0)              */ /*S01498*/
             CALL       PGM(*LIBL/LB0365) PARM(&RTYP &RSEQ &RLEV +
                           &RENT &RPARM)                              /*S01498*/
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
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) + /*S01498*/
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
/*********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) + /*S01498*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01498*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
                                                                      /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
/*>>S01189>>*/
/***********       CHGVAR     VAR(&BUSY) VALUE('N')                */ /*S01498*/
/***********       CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)       */ /*S01498*/
/*<<S01189<<*/
 
/***ABNOR:******ENDPGM                                             */ /*S01498*/
ABNOR:                                                                /*S01498*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01498*/
