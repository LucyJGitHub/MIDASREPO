/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Generate Portfolio Cashflow Events')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1400 - PM Generate Positions and Trade Events            */
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
/*                      S71062             Date 19Dec95              */
/*                      S01408             DATE 01APR96              */
/*                      CPM004             DATE 07FEB96              */
/*                      S01408             DATE 11MAY95              */
/*                      S01486             DATE 11AUG94              */
/*                      058887             DATE 27JUL93              */
/*                      049421             DATE 18JAN93              */
/*                      S01189     GB      DATE 25MAR92              */
/*                      B08268             DATE 22OCT91              */
/*                      R0571      LC      DATE 18OCT90              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - POSITION SPLIT BY CURRENCY                */
/*       S71062 - PM FF EVENTS EXTRACTS                              */
/*       S01408 - Addition of core hook PMC1400001                   */
/*       CPM004 - Bank Portfolios                                    */
/*       S01408 - Addition of core hook PMC1400MP1                   */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*       058887 - CORRECTION TO CALCULATION OF FORWARD EVENTS        */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       B08268 - SUNDRY FIXES TO SPEED UP COB                       */
/*       R0571  - Change call from PM1470 to PMC1470                 */
/*       R00300 - Message file changes.                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*>>S01189>>*/
/**********  PGM                                                     */
             PGM        PARM(&CNAM &CSEQ)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
/* DECLARE VARIABLES */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
/*********   DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)              S01189   **/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MDID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPM004*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPM004*/
             DCL        VAR(&SDPORT) TYPE(*CHAR) LEN(200)             /*CPM004*/
             DCL        VAR(&FCPORS) TYPE(*CHAR) LEN(1)               /*CPM004*/
                                                                      /*CPM004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CPM004*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPM004*/
             CALL       PGM(AOPORTR0) PARM(&RTCD &OPTN &SDPORT)       /*CPM004*/
                                                                      /*CPM004*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CPM004*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&DATA)         /*CPM004*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM004*/
                CHGJOB SWS(XXXXXX11)                                  /*CPM004*/
             GOTO       CMDLBL(ABNOR)                                 /*CPM004*/
             ENDDO                                                    /*CPM004*/
                                                                      /*CPM004*/
             CHGVAR     VAR(&FCPORS) VALUE(%SST(&SDPORT 112 1))       /*CPM004*/
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1400MP1                                          */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1400 - Generate Portfolio Cashflow +
                          Events') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RETRIEVE DTAARA MMOD TO CHECK MODULES PRESENT */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CHECK FOR COMPONENT RESTART */
/*>>S01189>>*/
/**********  RTVDTAARA  DTAARA(PMSTAT (16 3)) RTNVAR(&BUSY)            */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
 
/* IF RESTART AFTER ANY ERROR */
/*>>S01189>>*/
/*********** IF         COND(&BUSY = 'NEW') THEN(DO)                  */
             IF         COND(&BUSY = 'Y') THEN(DO)
/*<<S01189<<*/
             OVRDBF     FILE(XLVENTEL) SEQONLY(*YES 100)
             CPYF       FROMFILE(XLVENTEL) TOFILE(LVENTEL) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LVENTEL))
             CPYF       FROMFILE(XLVNTXZZ) TOFILE(LVNTXZZ) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LVNTXZZ))
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
/*********** IF         COND(&BUSY = 'OLD') THEN(DO)                  */
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
             OVRDBF     FILE(LVENTEL) SEQONLY(*YES 100)
             CPYF       FROMFILE(LVENTEL) TOFILE(&TOLIB/XLVENTEL) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLVENTEL))
             CPYF       FROMFILE(LVNTXZZ) TOFILE(&TOLIB/XLVNTXZZ) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XLVNTXZZ))
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')     **/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* REMOVE ALL LOGICAL FILE MEMBERS TO SPEED UP PROCESSING */
             RMVM       FILE(PMEVICLL) MBR(PMEVICLL)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVIPLL) MBR(PMEVIPLL)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVNTLL) MBR(PMEVNTLL)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVNTL1) MBR(PMEVNTL1)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVNTL2) MBR(PMEVNTL2)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVNTL3) MBR(PMEVNTL3)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVSCLL) MBR(PMEVSCLL)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVSPLL) MBR(PMEVSPLL)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVTCLL) MBR(PMEVTCLL)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVTPLL) MBR(PMEVTPLL)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
             RMVM       FILE(PMEVN1LL) MBR(PMEVN1LL)         /*B08268*/
             MONMSG     MSGID(CPF5815 CPF7310)               /*B08268*/
 
/* CLEAR ALL OUTPUT FILES */
/************CLRPFM     FILE(PMFPOSPP)                             */ /*S01486*/
             CLRPFM     FILE(PMFPOSPD)                                /*S01486*/
/************CLRPFM     FILE(PMFPOSZZ)                             */ /*S01486*/
             CLRPFM     FILE(PMFPOSPA)                                /*S01486*/
/************CLRPFM     FILE(PMEVNTPP)                             */ /*S01486*/
             CLRPFM     FILE(PMEVNTPD)                                /*S01486*/
/************CLRPFM     FILE(PMEVNTZZ)                             */ /*S01486*/
             CLRPFM     FILE(PMEVNTPA)                                /*S01486*/
/************CLRPFM     FILE(PMEVN1PP)                      */ /*B08268 S01486*/
             CLRPFM     FILE(PMEVN1PD)                                /*S01486*/
             CLRPFM     FILE(PMEVCYPD)                                /*CPM005*/
                                                                      /*CPM005*/
/* Call PM1380 only if value date positions is 'V' */                 /*CPM005*/
             IF         COND(%SST(&SDPORT 13 1) *EQ 'V') THEN(DO)     /*CPM005*/
             CALL       PGM(PM1380)                                   /*CPM005*/
                                                                      /*CPM005*/
/* Process any data base error */                                     /*CPM005*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM005*/
                GOTO       CMDLBL(ABNOR)                              /*CPM005*/
             ENDDO                                                    /*CPM005*/
                                                                      /*CPM005*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*CPM005*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM005*/
                GOTO       CMDLBL(ABNOR)                              /*CPM005*/
             ENDDO                                                    /*CPM005*/
             ENDDO                                                    /*CPM005*/
                                                                      /*S71062*/
/* IF FF PRESENT CREATE EXTRACT EVENTS */                             /*S71062*/
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 50 1))            /*S71062*/
             IF         COND(&MDID = 'Y') THEN(DO)                    /*S71062*/
/* If Bank Portfolios are supported, treat as if FF off               /*CPM003*/
             IF         COND(&FCPORS *NE 'B') THEN(DO)                /*CPM003*/
                                                                      /*S71062*/
/* CALL PM1422 */                                                     /*S71062*/
             CALL       PGM(PM1422)                                   /*S71062*/
                                                                      /*S71062*/
/* PROCESS ANY DATA BASE ERROR */                                     /*S71062*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S71062*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S71062*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S71062*/
                GOTO       CMDLBL(ABNOR)                              /*S71062*/
             ENDDO                                                    /*S71062*/
                                                                      /*S71062*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*S71062*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*S71062*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S71062*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S71062*/
                GOTO       CMDLBL(ABNOR)                              /*S71062*/
             ENDDO                                                    /*S71062*/
             ENDDO                                                    /*CPM003*/
             ENDDO                                                    /*S71062*/
 
/* IF SE PRESENT CREATE FORWARD PORTFOLIO POSITIONS */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 21 1))
/*********** IF ********COND(&MDID = 'Y') THEN(DO)                    /*CPM004*/
             IF         COND(&MDID = 'Y' *AND &FCPORS *NE 'B') +
             THEN(DO)                                                 /*CPM004*/
                                                                      /*B08268*/
/* CALL PM1390 TO RESET NEXT POSITION DATE ON PMCPOSPP */             /*B08268*/
             CALL       PGM(PM1390)                                   /*B08268*/
                                                                      /*B08268*/
/* PROCESS ANY DATA BASE ERROR */                                     /*B08268*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*B08268*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*B08268*/
/************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)           */ /*B08268 S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                GOTO       CMDLBL(ABNOR)                              /*B08268*/
             ENDDO                                                    /*B08268*/
                                                                      /*B08268*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*B08268*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*B08268*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*B08268*/
/************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)           */ /*B08268 S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                GOTO       CMDLBL(ABNOR)                              /*B08268*/
             ENDDO                                                    /*B08268*/
                                                                      /*B08268*/
/* IF SE PRESENT CALL PM1400 CREATE FORWARD PORTFOLIO POSITIONS */    /*B08268*/
             CALL       PGM(PM1400)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CALL PM1410 CREATE SECURITY EVENTS */
             OVRDBF     FILE(SEEVNT) TOFILE(SECED) SHARE(*NO)
/************OVRDBF     FILE(PMEVN1PP) SEQONLY(*YES 100)    */ /*B08040 S01486*/
             OVRDBF     FILE(PMEVN1PD) SEQONLY(*YES 100)              /*S01486*/
             OVRDBF     FILE(SECET1) TOFILE(SECET) SHARE(*NO)         /*058887*/
             CALL       PGM(PM1410)
             DLTOVR     FILE(*ALL)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* PERFORM PROGRAM TO WRITE RECORDS TO PMEVNTPP */
             ADDLFM     FILE(PMEVN1LL) MBR(PMEVN1LL)         /*B08268*/
/************OVRDBF     FILE(PMEVNTPP) SEQONLY(*YES 100)    */ /*B08040 S01486*/
             OVRDBF     FILE(PMEVNTPD) SEQONLY(*YES 100)              /*S01486*/
             OVRDBF     FILE(PMEVN1LL) SEQONLY(*YES 100)     /*B08040*/
             CALL       PGM(PM1415)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/* IF SE PRESENT - DO BANK PORTFOLIOS EVENTS EXTRACT */               /*CPM004*/
             IF         COND(&MDID = 'Y' *AND &FCPORS *EQ 'B') +
             THEN(DO)                                                 /*CPM004*/
                                                                      /*CPM004*/
             CALL PGM(PM1405)                                         /*CPM004*/
                                                                      /*CPM004*/
/* PROCESS ANY DATA BASE ERROR */                                     /*CPM004*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CPM004*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*CPM004*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM004*/
                GOTO       CMDLBL(ABNOR)                              /*CPM004*/
             ENDDO                                                    /*CPM004*/
                                                                      /*CPM004*/
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */            /*CPM004*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*CPM004*/
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*CPM004*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*CPM004*/
                GOTO       CMDLBL(ABNOR)                              /*CPM004*/
             ENDDO                                                    /*CPM004*/
                                                                      /*CPM004*/
             ENDDO                                                    /*CPM004*/
 
/* IF DL PRESENT CALL PM1420 EXTRACT DEALING EVENTS */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 2 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PM1420)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* IF LE PRESENT CALL PM1430 EXTRACT LENDING EVENTS */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 10 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PM1430)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* IF RE PRESENT CALL PM1440 EXTRACT RETAIL EVENTS */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 16 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PM1440)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/* IF FT PRESENT CALL PM1450 TO EXTRACT FUNDS TRANSFER EVENTS */
             CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 57 1))
             IF         COND(&MDID = 'Y') THEN(DO)
             CALL       PGM(PM1450)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
/**IF*FI*PRESENT*CALL*PM1470*EXTRACT*FIDUCIARY*DEPOSIT*EVENTS*******/ /*S01486*/
/************CHGVAR     VAR(&MDID) VALUE(%SST(&MMOD 81 1))         */ /*S01486*/
/************IF         COND(&MDID = 'Y') THEN(DO)                 */ /*S01486*/
/************CALL       PGM(PM1470)                                     *R0571*/
/************CALL       PGM(PMC1470)                        */  /*R0571 S01486*/
 
/**PROCESS*ANY*DATA*BASE*ERROR**************************************/ /*S01486*/
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*S01486*/
/************   RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)      */ /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/*                                                                    /*R00300*/
/************   GOTO       CMDLBL(ABNOR)                           */ /*S01486*/
/************ENDDO                                                 */ /*S01486*/
 
/**CHECK*FOR*FILE*CONTROL*ERRORS*TRAPPED*BY*THE*PROGRAM*************/ /*S01486*/
/************IF         COND(%SWITCH(XXXXXX01)) THEN(DO)           */ /*S01486*/
/************   RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)      */ /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/************SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
/*                                                                    /*R00300*/
/************   GOTO       CMDLBL(ABNOR)                           */ /*S01486*/
/************ENDDO                                                 */ /*S01486*/
/************ENDDO                                                 */ /*S01486*/
 
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1400001                                          */
                                                                      /*S01408*/
/* RESTORE LF MEMBERS */
             ADDLFM     FILE(PMEVICLL) MBR(PMEVICLL)         /*B08268*/
             ADDLFM     FILE(PMEVIPLL) MBR(PMEVIPLL)         /*B08268*/
             ADDLFM     FILE(PMEVNTLL) MBR(PMEVNTLL)         /*B08268*/
             ADDLFM     FILE(PMEVNTL1) MBR(PMEVNTL1)         /*B08268*/
             ADDLFM     FILE(PMEVNTL2) MBR(PMEVNTL2)         /*B08268*/
             ADDLFM     FILE(PMEVNTL3) MBR(PMEVNTL3)         /*B08268*/
             ADDLFM     FILE(PMEVSCLL) MBR(PMEVSCLL)         /*B08268*/
             ADDLFM     FILE(PMEVSPLL) MBR(PMEVSPLL)         /*B08268*/
             ADDLFM     FILE(PMEVTCLL) MBR(PMEVTCLL)         /*B08268*/
             ADDLFM     FILE(PMEVTPLL) MBR(PMEVTPLL)         /*B08268*/
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*>>S01189>>*/
/*********** CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')      **/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             DLTF       FILE(XLVNTXZZ)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(XLVENTEL)
             MONMSG     MSGID(CPF2105)
             ENDDO
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
