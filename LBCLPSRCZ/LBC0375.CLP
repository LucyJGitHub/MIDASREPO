/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Commitment Lines Expiring/Review Report.')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0375 - Total Commitment Lines Expiring/Review Report     */
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
/*       PREV AMEND NO. S01408             DATE 05MAY95              */
/*                      S01498             DATE 11AUG94              */
/*                      35723              DATE 11FEB92              */
/*                      S01189             DATE 11AUG92              */
/*                      S01355             DATE 10JUL92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       093978 - Wrong message id used                              */
/*       S01408 - Addition of core hook LBC0375MP1                   */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
/*       35723  - LB PROGRAM CANNOT BE RESTARTABLE                   */
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
 
/*>>S01189>>*/
/**********  PGM        PARM(&CLPARM1)                ***/
/*********** PGM        PARM(&CNAM &CSEQ &CLPARM1)                 */ /*S01498*/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT &RPARM)    /*S01498*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01498*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01498*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01498*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01498*/
/**/                                                                  /*S01498*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)               /*S01498*/
             DCL        VAR(&SAVLIB) TYPE(*CHAR) LEN(7)               /*S01498*/
/*<<S01189<<*/
 
/* DECLARE VARIABLES */
/*********** DCL        VAR(&CLPARM1) TYPE(*CHAR) LEN(1)           */ /*S01498*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
/*********** DCL        VAR(&RPGPARM1) TYPE(*CHAR) LEN(1)          */ /*S01498*/
/*********** DCL        VAR(&RPGPARM2) TYPE(*DEC) LEN(3 0) VALUE(0)*/ /*S01498*/
 
/* SEND PROGRAM MESSAGE */
/* >>>>> S01355 >>>>> */
/*           SNDPGMMSG  MSG('Lombard Total Commitment Lines +                */
/*                        Expiring/Review Report - LBC0375') +               */
/*                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)                       */
             SNDPGMMSG  MSG('Portfolio Lending Total Commitment Lines +
                          Expiring/Review Report - LBC0375') +
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
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE(' ')
                   CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/*                                                                    /*S01498*/
/* Retrieve system prefix to get save library 'xxDPLIB'               /*S01498*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)          /*S01498*/
             CHGVAR     VAR(&SAVLIB) VALUE(&PREFIX *CAT 'DPLIB')      /*S01498*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LBC0375MP1                                          */
                                                                      /*S01408*/
/**/                                                                  /*S01498*/
              IF        COND(&BUSY *EQ 'N') THEN(DO)                  /*S01498*/
/**/                                                                  /*S01498*/
/**  This is not a restart - copy master to back up file */           /*S01498*/
/**/                                                                  /*S01498*/
             CPYF       FROMFILE(LBTRAIPD) TOFILE(&SAVLIB/XLBTRAIPD) +
                          CRTFILE(*YES)                               /*S01498*/
             CPYF       FROMFILE(LBCOMAPD) TOFILE(&SAVLIB/XLBCOMAPD) +
                          CRTFILE(*YES)                               /*S01498*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
                   ENDDO                                              /*S01498*/
              ELSE CMD(DO)                                            /*S01498*/
/**/                                                                  /*S01498*/
/**  This is a restart - copy back up file to master file */          /*S01498*/
/**/                                                                  /*S01498*/
             CPYF       FROMFILE(&SAVLIB/XLBTRAIPD) TOFILE(LBTRAIPD) +
                          MBROPT(*REPLACE)                            /*S01498*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                EXEC(CLRPFM FILE(LBTRAIPD))           /*S01498*/
             CPYF       FROMFILE(&SAVLIB/XLBCOMAPD) TOFILE(LBCOMAPD) +
                          MBROPT(*REPLACE)                            /*S01498*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                EXEC(CLRPFM FILE(LBCOMAPD))           /*S01498*/
              ENDDO                                                   /*S01498*/
/*<<S01189<<*/
 
/* CALL PROGRAM */
/*********** CHGVAR     VAR(&RPGPARM1) VALUE(&CLPARM1)             */ /*s01498*/
/*********** IF         COND(&CLPARM1 *EQ '0') THEN(DO)            */ /*S01498*/
/*********** CALL       PGM(*LIBL/LB0375) PARM(&RPGPARM1 &RPGPARM2)*/ /*s01498*/
             CALL       PGM(*LIBL/LB0375) PARM('0' &RSEQ &RLEV +
                           &RENT &RPARM)                              /*S01498*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)       /*35723*/
                   CHGJOB  SWS(XXXXXX11)                              /*35723*/
                   GOTO    CMDLBL(ABNOR)                              /*35723*/
             ENDDO                                                    /*35723*/
/*********** ENDDO                                                 */ /*S01498*/
/*********** ELSE       CMD(DO)                                    */ /*S01498*/
/*********** CALL       PGM(*LIBL/LB0376)                          */ /*S01498*/
/*********** MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EX   */ /*35723  S01498*/
/***********       CHGJOB  SWS(XXXXXX11)                    */ /*35723  S01498*/
/***********       GOTO    CMDLBL(ABNOR)                    */ /*35723  S01498*/
/*********** ENDDO                                          */ /*35723  S01498*/
/*********** ENDDO                                                 */ /*S01498*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
                                                                      /*R00300*/
/************SNDPGMMSG  MSGID(LBM9001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*********** SNDPGMMSG  MSGID(DBM9001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01498*/
/*********** SNDPGMMSG  MSGID(DBM9001) MSGF(LBUSRMSG) MSGDTA(&DATA) +   093978*/
/***********              TOMSGQ(MOPERQ MRUNQ)                          093978*/
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
                          TOMSGQ(MOPERQ MRUNQ)                     */ /*S01498*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)
                                                                      /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/**/                                                                  /*S01498*/
/**  Delete dummy files */                                            /*S01498*/
/**/                                                                  /*S01498*/
             DLTF       FILE(&SAVLIB/XLBTRAIPD)                       /*S01498*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01498*/
             DLTF       FILE(&SAVLIB/XLBCOMAPD)                       /*S01498*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01498*/
/*<<S01189<<*/
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
