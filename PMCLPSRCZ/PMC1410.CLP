/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Create Consolidated Cashflows Functn')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1410 - PM Create Consolidated Cashflows Function         */
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
/*       Prev Amend No. CPM005             Date 10Jul96              */
/*                      099814             Date 14Feb96              */
/*                      S01486             DATE 11AUG94              */
/*                      SA9108             DATE  05NOV91             */
/*                      R00300             DATE  28AUG90             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                ALTER MESSAGE TO BE RECOGNISABLE                   */
/*       099814 - Pool Trades should use CQQ001 feature              */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*       SA9108 - POOL TRANSACTIONS SAR                              */
/*       R00300 - Message file changes.                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* DECLARE VARIABLES */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
/*********** DCL        VAR(&POOL) TYPE(*CHAR) LEN(1)       */ /*SA9108 S01486*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*099814*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*099814*/
 
/* SEND PROGRAM MESSAGE */
/*********** SNDPGMMSG  MSG('Create Consolidated Cashflows - +        /*CPM005*/
/************************ PMC1410') TOMSGQ(MRUNQ)                     /*CPM005*/
             SNDPGMMSG  MSG('PMC1410 - Create Consolidated +
                          Cashflows') TOMSGQ(MRUNQ)                   /*CPM005*/
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CLEAR ALL TEMPORARY FILES */
/*********** CLRPFM     FILE(PMCFDYPP)                             */ /*S01486*/
/*********** CLRPFM     FILE(PMCFMYPP)                             */ /*S01486*/
/*********** CLRPFM     FILE(PMCFDYZZ)                             */ /*S01486*/
/*********** CLRPFM     FILE(PMCFMYZZ)                             */ /*S01486*/
             CLRPFM     FILE(PMCFDYPD)                                /*S01486*/
             CLRPFM     FILE(PMCFMYPD)                                /*S01486*/
             CLRPFM     FILE(PMCFDYPA)                                /*S01486*/
             CLRPFM     FILE(PMCFMYPA)                                /*S01486*/
 
/* CALL RPG PROGRAM */
             CALL       PGM(PM1460)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +         */ /*S01486*/
/***********                 MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)    */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) +         */ /*S01486*/
/***********                 MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)    */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL RPG PROGRAM */
             CALL       PGM(PM1465)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +         */ /*S01486*/
/***********                 MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)    */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) +         */ /*S01486*/
/***********                 MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)    */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
             ENDDO
/*                                                                    /*R00300*/
/**IF*POOL*PORTFOLIOS*REQUIRED*CALCULATE*CONSOLIDATED*POOL*CASHFLOWS* /*S01486*/
/*********** RTVDTAARA  DTAARA(LZSTAT (33 1)) RTNVAR(&POOL) */ /*SA9108 S01486*/
 
/*********** IF         COND(&POOL *EQ 'Y') THEN(DO)        */ /*SA9108 S01486*/
/************CALL       PGM(PMC1411)                        */ /*SA9108 099814*/
/************ENDDO                                          */ /*SA9108 S01486*/
/*                                                                    /*099814*/
/* If Pool Trades Optional Feature present Consolidate Pool Cashflows /*099814*/
/*                                                                    /*099814*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CQQ001' +
                          &FMT)                                       /*099814*/
             IF         COND(&RTCD *EQ '       ') THEN( +
                          CALL  PGM(PMC1411))                         /*099814*/
/*                                                                    /*099814*/
ABNOR:
/*ENDPGM                                                           */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
