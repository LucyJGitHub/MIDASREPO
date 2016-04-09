/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Charges Accruals')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1200 - PM Charges Accruals                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 195518             Date 22Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPM005             DATE 05AUG96              */
/*                      S01408             DATE 11MAY95              */
/*                      081340             DATE 13DEC94              */
/*                      S01486             DATE 11AUG94              */
/*                      049421             DATE 18JAN93              */
/*                      S01189     GB      DATE 25MAR92              */
/*                      S01313             DATE 16JUN92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       195518 - Nothing reported although Last Accrual Date updated*/
/*                in PF/PMCHRGPD. Fix is to do another OVRDBF to     */
/*                PF/GEPM2PD if parm &POST is equal to '5'.          */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       S01408 - Addition of core hook PMC1200MP1                   */
/*       081340 - Temporary Library is xxDPLIB for R10.              */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       S01313 - PROGRAM RENAMED FOR PERFORMANCE                    */
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
/*********** PGM        PARM(&CNAM &CSEQ)                             /*CPM005*/
             PGM        PARM(&CNAM &CSEQ &POST)                       /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)                 /*CPM005*/
/*<<S01189<<*/
/* DECLARE VARIABLES */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
/*********   DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)              S01189   **/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ECD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*********** CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB') ****/    /*081340*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*081340*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1200MP1                                          */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1200 - Portfolio Management Charge +
                          Accruals') TOMSGQ(MRUNQ)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CLEAR ALL TEMPORARY FILES */
             IF         COND(&POST *EQ '1') THEN(DO)                  /*CPM005*/
             CLRPFM     FILE(GEPMPD)
/*********** CLRPFM     FILE(GEPMZZ)                               */ /*S01486*/
             CLRPFM     FILE(GEPMPA)                                  /*S01486*/
             ENDDO                                                    /*CPM005*/
/**/                                                                  /*CPM005*/
             CLRPFM     FILE(GEPM2PD)                                 /*CPM005*/
             CLRPFM     FILE(GEPM2PA)                                 /*CPM005*/
 
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
/*********** OVRDBF     FILE(XPMCHRGPP) SEQONLY(*YES 100)          */ /*S01486*/
/*********** CPYF       FROMFILE(XPMCHRGPP) TOFILE(PMCHRGPP) +     */ /*S01486*/
/***********              MBROPT(*REPLACE) FMTOPT(*NONE)           */ /*S01486*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM+*/ /*S01486*/
/***********              FILE(PMCHRGPP))                          */ /*S01486*/
             OVRDBF     FILE(XPMCHRGPD) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMCHRGPD) TOFILE(PMCHRGPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM FILE(PMCHRGPD))                 /*S01486*/
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
/*********** IF         COND(&BUSY = 'OLD') THEN(DO)                  */
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
/*********** OVRDBF     FILE(PMCHRGPP) SEQONLY(*YES 100)           */ /*S01486*/
/*********** CPYF       FROMFILE(PMCHRGPP) TOFILE(&TOLIB/XPMCHRGPP) + /*S01486*/
/***********              MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)/*S01486*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM+*/ /*S01486*/
/***********              FILE(XPMCHRGPP))                         */ /*S01486*/
             OVRDBF     FILE(PMCHRGPD) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMCHRGPD) TOFILE(&TOLIB/XPMCHRGPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM FILE(XPMCHRGPD))                /*S01486*/
             CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')
             ENDDO
 
/* RETRIEVE EVENT CONTROL DATE AND OPEN QUERY FILE */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&ECD)
 
/*********** OVRDBF     FILE(PMCHRGPP) SHARE(*YES)                 */ /*S01486*/
/*********** OPNQRYF    FILE((PMCHRGPP)) OPTION(*ALL) QRYSLT('PORECI +/*S01486*/
/***********              *EQ "C" *OR PORECI *EQ "D" *AND POCGND *GT +/*S01486*/
/***********              0 *AND POCGND *LE ' *CAT &ECD *CAT ' *OR +  /*S01486*/
/***********              PORECI *EQ "D" *AND POCSND *GT 0 *AND +  */ /*S01486*/
/***********              POCSND *LE ' *CAT &ECD *CAT ' ') +       */ /*S01486*/
/***********              IGNDECERR(*YES)                          */ /*S01486*/
             OVRDBF     FILE(PMCHRGPD) SHARE(*YES)                    /*S01486*/
             OPNQRYF    FILE((PMCHRGPD)) OPTION(*ALL) QRYSLT('PORECI +
                          *EQ "C" *OR PORECI *EQ "D" *AND POCGND +
                          *GT 0 *AND POCGND *LE ' *CAT &ECD *CAT ' +
                          *OR PORECI *EQ "D" *AND POCSND *GT 0 +
                          *AND POCSND *LE ' *CAT &ECD *CAT ' ') +
                          IGNDECERR(*YES)                             /*S01486*/
/**/                                                                  /*CPM005*/
             IF         COND(&POST *EQ '5') THEN(DO)                  /*CPM005*/
                OVRDBF     FILE(GEPMPD) TOFILE(GEPM2PD)               /*CPM005*/
                OVRDBF     FILE(GEPMPA) TOFILE(GEPM2PA)               /*CPM005*/
             ENDDO                                                    /*CPM005*/
 
/* CALL RPG PROGRAM */
             CALL       PGM(PM1200)
/*********** CLOF       OPNID(PMCHRGPP)                            */ /*S01486*/
             CLOF       OPNID(PMCHRGPD)                               /*S01486*/
 
/* DELETE FILE OVERRIDES */
             DLTOVR     FILE(*ALL)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
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
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF         COND(&POST *EQ '5') THEN(DO)                                      /*195518*/
                OVRDBF     FILE(PMGEPML1) TOFILE(PMGEPM2L1)                               /*195518*/
                OVRDBF     FILE(GEPMPA) TOFILE(GEPM2PA)                                   /*195518*/
             ENDDO                                                                        /*195518*/
                                                                                          /*195518*/
/* CALL RPG PROGRAM */
             CALL       PGM(PM1210)
 
/* Delete file overrides */                                                               /*195518*/
             IF         COND(&POST *EQ '5') THEN(DO)                                      /*195518*/
                DLTOVR     FILE(*ALL)                                                     /*195518*/
             ENDDO                                                                        /*195518*/
                                                                                          /*195518*/
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
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
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)/*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) +
                             MSGDTA(&DATA) TOMSGQ(MOPERQ MRUNQ)       /*S01486*/
/*                                                                    /*R00300*/
             ENDDO
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*>>S01189>>*/
/*********** CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')      **/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/*********** DLTF       FILE(XPMCHRGPP)                            */ /*S01486*/
             DLTF       FILE(XPMCHRGPD)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
             ENDDO
ABNOR:
/***ENDPGM                                                         */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
