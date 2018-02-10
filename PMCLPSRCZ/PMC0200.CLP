/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Non-standing data audit lists')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC0200 - PM NON STANDING DATA AUDIT LISTS                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 06Sep01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPM005             Date 20Jun96              */
/*                      090135           DATE 06JUL95                */
/*                      S01408             DATE 05MAY95              */
/*                      085849           DATE  13MAR95               */
/*                      083645           DATE  21FEB95               */
/*                      053103           DATE  10NOV93               */
/*                      S01486           DATE  07OCT94               */
/*                      SA9108 TL        DATE  21OCT93               */
/*                      049421           DATE  18JAN93               */
/*                      S01355           DATE  29OCT92               */
/*                      S01189           DATE  27AUG90               */
/*                      R00300           DATE  27AUG90               */
/*                      B4850            DATE  06AUG90               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Release 4 Packaging:                               */
/*                - Change &DATA string to 50 characters             */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                PBFG/1 - CHANGE CUSTOMER/PORTFOLIO BASE CCY        */
/*                PBFG/2 - CALCULATE & REPORT PERF FOR ALL CUST PORT */
/*       090135  -  Multilanguage is always on                       */
/*       S01408  -  Addition of core hook PMC0200MP1                 */
/*       085849  -  PMC5030 IS NOT CONDITIONED BY POOL PORTFOLIO     */
/*       083645  -  PARAMETER LIST MISMATCH WITH PMC4220             */
/*       053103  -  Call to PMC4220 & PMC4230 added.                 */
/*       S01486  -  Portfolio Management Upgrade to R10              */
/*       SA9108  -  POOL SECURITIES TRANSACTIONS                     */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       S01355  -  AVOID ERROR IF THE FILE IS EMPTY                 */
/*       S01189  -  COB RECOVERY PROCESSING                          */
/*       R00300  -  Message file changes.                            */
/*       B4850   -  INCORRECT CALL TO PMC0290 (SHOULD BE PMC0291)    */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*>>S01189>>*/
/**********  PGM                                                     */
/**********  PGM        PARM(&CNAM &CSEQ)                             /*S01486*/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLVL &RENT)           /*S01486*/
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*********** DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                /*S01486*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWMTL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&VAL) TYPE(*CHAR) LEN(100)                /*S01486*/
/*** BEGIN SA9108 ***/
             DCL        VAR(&PPT) TYPE(*CHAR) LEN(1)
/*** END SA9108 ***/
             DCL VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')            /*085849*/
             DCL VAR(&CQQ001) TYPE(*CHAR) LEN(1) VALUE(' ')           /*085849*/
 
/* SET UP COB PARAMETER  */
             CHGVAR     VAR(&PARM) VALUE(1)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC0200 - Portfolio Management Audit +
                          Reports') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')          /*S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0200MP1                                          */
                                                                      /*S01408*/
 
/* CHECK FOR COMPONENT RESTART */
/*>>S01189>>*/
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/* IF RESTART AFTER ANY ERROR */
/*>>S01189>>*/
             IF         COND(&BUSY = 'Y') THEN(DO)
/************OVRDBF     FILE(XPMTRSFPP) SEQONLY(*YES 100)             /*S01486*/
/************CPYF       FROMFILE(XPMTRSFPP) TOFILE(PMTRSFPP) +        /*S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*S01486*/
/************             FILE(PMTRSFPP))                             /*S01486*/
/************CPYF       FROMFILE(XPMTRSFZZ) TOFILE(PMTRSFZZ) +        /*S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*S01486*/
/************             FILE(PMCPOSZZ))                             /*S01486*/
             OVRDBF     FILE(XPMTRSFPD) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMTRSFPD) TOFILE(PMTRSFPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMTRSFPD))                             /*S01486*/
             CPYF       FROMFILE(XPMTRSFPA) TOFILE(PMTRSFPA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMCPOSPA))                             /*S01486*/
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
/************                                                         /*S01486*/
/************OVRDBF     FILE(PMTRSFPP) SEQONLY(*YES 100)              /*S01486*/
/************CPYF       FROMFILE(PMTRSFPP) TOFILE(&TOLIB/XPMTRSFPP) + /*S01486*/
/************    MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)         /*S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*S01486*/
/************             FILE(XPMTRSFPP))                            /*S01486*/
/************CPYF       FROMFILE(PMTRSFZZ) TOFILE(&TOLIB/XPMTRSFZZ) + /*S01486*/
/************   MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)          /*S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +  /*S01486*/
/************             FILE(XPMTRSFZZ))                            /*S01486*/
             OVRDBF     FILE(PMTRSFPD) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMTRSFPD) TOFILE(&TOLIB/XPMTRSFPD) +
                 MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)         /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMTRSFPD))                            /*S01486*/
             CPYF       FROMFILE(PMTRSFPA) TOFILE(&TOLIB/XPMTRSFPA) +
                MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)          /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMTRSFPA))                            /*S01486*/
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')     **/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0210) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0210) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/**CHECK*WHETHER*MULTI*LANGUAGE*PRESENT******************************* *090135*/
/*********** RTVDTAARA  DTAARA(MMOD (17 1)) RTNVAR(&WWMTL)           * *090135*/
/**/
/*********** IF         COND(&WWMTL *EQ 'Y') THEN(DO)                * *090135*/
             CHGJOB     SWS(XXX1XXXX)
/*********** ENDDO                                                   * *090135*/
/**/
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0220) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0220) PARM(&PARM &RSEQ)                 /*S01486*/
             CHGJOB     SWS(XXX0XXXX)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0230) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0230) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0240) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0240) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0250) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0250) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0260) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0260) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0270) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0270) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0280) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0280) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL RPG PROGRAM */  /*B4850 */
/*********** CALL       PGM(PMC0290) PARM('*ALL' '*ALL' '*ALL' 'F')  */
/*********** CALL       PGM(PMC0291)                                  /*S01486*/
             CALL       PGM(PMC0290) PARM(&PARM &RSEQ &RLVL &RENT +
                        '*ALL  *ALL')                                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA) */                          /*CPK014*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)                             /*CPK014*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) + ***/       /*CPM005*/
/*************************** MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ) ***/  /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM005*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0300) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0300) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* CALL RPG PROGRAM */
/*********** CALL       PGM(PM0310) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0310) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0320) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0320) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*************  RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0330) PARM(&PARM)                       /*S01486*/
             CALL       PGM(PM0330) PARM(&PARM &RSEQ)                 /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL CL PROGRAM */
/************CALL       PGM(PMC0341) PARM(&PARM)   *********/         /*S01486*/
             CHGVAR     VAR(%SST(&VAL 1 13)) VALUE('   *ALL  *ALL')
          CALL       PGM(PMC0340) PARM(&PARM &RSEQ &RLVL &RENT &VAL)  /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/**************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) /*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/* CALL RPG PROGRAM */
/************CALL       PGM(PM0350) PARM(&PARM)                       /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/                                                                  /*CPM005*/
/** Call PMC6300 */                                                   /*CPM005*/
             CALL       PGM(PMC6300) PARM(&RSEQ &RLVL &RENT)          /*CPM005*/
/**/                                                                  /*CPM005*/
/** Process any database errors */                                    /*CPM005*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM005*/
                GOTO       CMDLBL(ABNOR)                              /*CPM005*/
             ENDDO                                                    /*CPM005*/
/**/                                                                  /*CPM005*/
/** Call PMC6320 */                                                   /*CPM005*/
             CALL       PGM(PMC6320) PARM(&RSEQ &RLVL &RENT)          /*CPM005*/
/**/                                                                  /*CPM005*/
/** Process any database errors */                                    /*CPM005*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*CPM005*/
                GOTO       CMDLBL(ABNOR)                              /*CPM005*/
             ENDDO                                                    /*CPM005*/
 
/*** BEGIN SA9108 ***/
/*********** RTVDTAARA  DTAARA(LZSTAT (33 1)) RTNVAR(&PPT) *********/ /*S01486*/
 
/************IF         COND(&PPT='Y') THEN(DO)*********************/ /*S01486*/
 
/************CALL       PGM(PM5030) PARM(&PARM) ********************/ /*S01486*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CQQ001' ' ')      /*085849*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CQQ001) VALUE('Y'))        /*085849*/
             IF (&CQQ001 *EQ 'Y') THEN(DO)                            /*085849*/
             CALL       PGM(PMC5030) PARM(&PARM &RSEQ &RLVL &RENT)    /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/****************************TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO                                                    /*085849*/
 
/**********  ENDDO  ************************************************/ /*S01486*/
/*** END SA9108 ***/
                                                                      /*053103*/
/************CALL       PGM(PMC4220)                       /*053103*/ /*083645*/
             CALL       PGM(PMC4220) PARM(&RSEQ &RLVL &RENT)          /*083645*/
                                                                      /*053103*/
/* PROCESS ANY DATA BASE ERROR */                                     /*053103*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*053103*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*053103*/
                                                                      /*053103*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*053103*/
                                                                      /*053103*/
             GOTO       CMDLBL(ABNOR)                                 /*053103*/
             ENDDO                                                    /*053103*/
                                                                      /*053103*/
                                                                      /*053103*/
/*******     CALL       PGM(PMC4230)                        */ /*053103 S01486*/
             CALL       PGM(PMC4230)  PARM(&RSEQ &RLVL &RENT)         /*S01486*/
                                                                      /*053103*/
/* PROCESS ANY DATA BASE ERROR */                                     /*053103*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*053103*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*053103*/
                                                                      /*053103*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*053103*/
                                                                      /*053103*/
             GOTO       CMDLBL(ABNOR)                                 /*053103*/
             ENDDO                                                    /*053103*/
                                                                      /*053103*/
 
/* IF JOB ENDED NORMALLY */
/*<<S01189<<*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/************DLTF       FILE(XPMTRSFPP)                               /*S01486*/
             DLTF       FILE(XPMTRSFPD)                               /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*S01355*/
/************DLTF       FILE(XPMTRSFZZ)                               /*S01486*/
             DLTF       FILE(XPMTRSFPA)                               /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*S01355*/
             ENDDO
 
ABNOR:
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
