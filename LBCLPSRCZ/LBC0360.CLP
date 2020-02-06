/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Portfolio Lending Report (EOD).')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Lending Module                        */
/*                                                                   */
/*       LBC0360 - Portfolio Lending Report (EOD)                    */
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
/*       Prev Amend No. S01408             Date 04May95              */
/*                      S01498             Date 11Aug94              */
/*                      35723              DATE 11FEB92              */
/*                      S01189             DATE 11AUG92              */
/*                      S01355             DATE 10JUL92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Addition of core hook LBC0360MP1                   */
/*       S01498 - Portfolio Lending Upgrade to Release 10            */
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
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT &RPARM)    /*S01498*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
 
/* SEND PROGRAM MESSAGE */
/* >>>>> S01355 >>>>> */
/*           SNDPGMMSG  MSG('LBC0360 - Lombard Credit Report') +             */
/*                        TOMSGQ(MRUNQ) MSGTYPE(*INFO)                       */
             SNDPGMMSG  MSG('LBC0360 - Portfolio Lending Report') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/* <<<<< S01355 >>>>> */
 
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
/* Retrieve the System prefix to get the save library 'xxDPLIB'       /*S01498*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)          /*S01498*/
             CHGVAR     VAR(&SAVLIB) VALUE(&PREFIX *CAT 'DPLIB')      /*S01498*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LBC0360MP1                                          */
                                                                      /*S01408*/
/**/                                                                  /*S01498*/
              IF        COND(&BUSY *EQ 'N') THEN(DO)                  /*S01498*/
/**/                                                                  /*S01498*/
/**  This is not a restart - copy master to back up file */           /*S01498*/
/**/                                                                  /*S01498*/
             CPYF       FROMFILE(SDLBCSPD) TOFILE(&SAVLIB/XSDLBCSPD) +
                          CRTFILE(*YES)                               /*S01498*/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
                   ENDDO                                              /*S01498*/
              ELSE CMD(DO)                                            /*S01498*/
/**/                                                                  /*S01498*/
/**  This is a restart - copy back up file to master file */          /*S01498*/
/**/                                                                  /*S01498*/
             CPYF       FROMFILE(&SAVLIB/XSDLBCSPD) TOFILE(SDLBCSPD) +
                          MBROPT(*REPLACE)                            /*S01498*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                EXEC(CLRPFM FILE(SDLBCSPD))           /*S01498*/
              ENDDO                                                   /*S01498*/
/*<<S01189<<*/
/* CALL PROGRAM */
/*********** CALL       PGM(*LIBL/LB0360) PARM('0')                */ /*S01498*/
             CALL       PGM(*LIBL/LB0360) PARM('0' &RSEQ &RLEV +
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
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01498*/
                                                                      /*R00300*/
             ENDDO
 
/*>>S01189>>*/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/**/                                                                  /*S01498*/
/**  Delete dummy files */                                            /*S01498*/
/**/                                                                  /*S01498*/
             DLTF       FILE(&SAVLIB/XSDLBCSPD)                       /*S01498*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*S01498*/
/*<<S01189<<*/
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
