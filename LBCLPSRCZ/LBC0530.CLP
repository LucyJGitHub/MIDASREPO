/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Guarantees/Pledges signed/unsigned (COB)')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0530 - Guarantees/Pledges signed/unsigned Report.        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01498             DATE 06JUL94              */
/*       PREV AMEND NO. R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01498 - Portfolio Management Upgrade to Release 10.        */
/*                Copyright Statement and Standard Header Box.       */
/*                Creation Parameters. Message Files.                */
/*       R00300 - Message file changes                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*S01498*/
             PGM PARM(&RSEQ &RLVL &RENT &RPARM)                       /*S01498*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1) /* RCF level +
                          flag (S/C/B)                                /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity +
                          code (all/comp/bch)                         /*S01498*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01498*/
 
/* DECLARE VARIABLES */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&PARM2) TYPE(*DEC) LEN(3 0)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('LBC0530 - Guarantees/Pledges +
                          signed/unsigned report') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CALL PROGRAM */
/*           CALL       PGM(*LIBL/LB0530) PARM('0')                   /*S01498*/
             CALL    PGM(LB0530) PARM(&RSEQ &RLVL &RENT &RPARM)       /*S01498*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
                                                                      /*R00300*/
/************SNDPGMMSG  MSGID(LBM9001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
 ***********              TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
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
/*           SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
                                                                      /*R00300*/
             ENDDO
 
 ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
