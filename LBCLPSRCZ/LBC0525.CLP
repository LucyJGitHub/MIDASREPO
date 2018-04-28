/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Unattached Instrument report.')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0505 - LB Not Attached Instruments Report.               */
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
/*       LAST AMEND NO. S01408             DATE 05MAY95              */
/*       PREV AMEND NO. S01498             DATE 07JUL94              */
/*                      35723              DATE 27JAN93              */
/*                      S01189             DATE 11AUG92              */
/*                      S01355             DATE 10JUL92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01408 - Addition of core hook LBC0525MP1                   */
/*       S01498 - Portfolio Management Upgrade to Release 10.        */
/*                Copyright Statement and Standard Header Box.       */
/*                Creation Parameters. Message Files.                */
/*                COB processing removed.                            */
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
/**********  PGM                                                    **/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)               /*S01498*/
             DCL        VAR(&SAVLIB) TYPE(*CHAR) LEN(7)               /*S01498*/
/*<<S01189<<*/
 
/* DECLARE VARIABLES */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
 
/* SEND PROGRAM MESSAGE */
/* >>>>> S01355 >>>>> */
/*           SNDPGMMSG  MSG('Lombard not attached Instruments Report +       */
/*                        - LBC0525') TOMSGQ(MRUNQ) MSGTYPE(*INFO)           */
             SNDPGMMSG  MSG('Portfolio not attached Instruments Report +
                          - LBC0525') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
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
/**/                                                                  /*S01498*/
/* Retrieve the System prefix to get the save library 'xxDPLIB'       /*S01498*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)          /*S01498*/
             CHGVAR     VAR(&SAVLIB) VALUE(&PREFIX *CAT 'DPLIB')      /*S01498*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LBC0525MP1                                          */
                                                                      /*S01408*/
/**/                                                                  /*S01498*/
              IF        COND(&BUSY *EQ 'N') THEN(DO)                  /*S01498*/
/**/                                                                  /*S01498*/
/**  This is not a restart - copy master to back up file */           /*S01498*/
/**/                                                                  /*S01498*/
             CPYF       FROMFILE(SDPLINPD) TOFILE(&SAVLIB/XSDPLINPD) +
                          CRTFILE(*YES)                               /*S01498*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
                   ENDDO                                              /*S01498*/
/*<<S01189<<*/
              ELSE CMD(DO)                                            /*S01498*/
/**/                                                                  /*S01498*/
/**  This is a restart - copy back up file to master file */          /*S01498*/
/**/                                                                  /*S01498*/
             CPYF       FROMFILE(&SAVLIB/XSDPLINPD) TOFILE(SDPLINPD) +
                          MBROPT(*REPLACE)                            /*S01498*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                EXEC(CLRPFM FILE(SDPLINPD))           /*S01498*/
              ENDDO                                                   /*S01498*/
 
/* CALL PROGRAM */
             CALL       PGM(*LIBL/LB0525)
 
/* >>> 35723 >>> */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)       /*35723*/
                   CHGJOB  SWS(XXXXXX11)                              /*35723*/
                   GOTO    CMDLBL(ABNOR)                              /*35723*/
             ENDDO                                                    /*35723*/
/* <<< 35723 <<< */
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
                                                                      /*R00300*/
/************SNDPGMMSG  MSGID(LBM9001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
**************************TOMSGQ(MOPERQ MRUNQ)                       */
/*********** SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
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
/*********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
 ***********              TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(LBUSRMSG) MSGDTA(&DATA) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
                                                                      /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/**/                                                                  /*S01498*/
/**  Delete dummy files */                                            /*S01498*/
/**/                                                                  /*S01498*/
             DLTF       FILE(&SAVLIB/XSDPLINPD)                       /*S01498*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01498*/
/*<<S01189<<*/
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
