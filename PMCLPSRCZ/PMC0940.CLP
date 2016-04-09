/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Update Historic Turnover')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0940 - PM Update Historic Turnover                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 11MAY95              */
/*       PREV AMEND NO. 080737             DATE 22DEC94              */
/*                      S01486             DATE 06DEC94              */
/*                      049421             DATE 18JAN93              */
/*                      S01189             DATE 25MAR92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01408 - Addition of core hook PMC0940MP1                   */
/*       080737 - Wrong file used                                    */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01189 - COB RECOVERY PROCESSING                            */
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
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/*<<S01189<<*/
/* DECLARE VARIABLES */
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
/*********** DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 S01189*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
/*********   DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)            S01189 */
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*********** CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC0940MP1                                          */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC0940 - Update Historic Turnover') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
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
/*********** OVRDBF     FILE(XPMHITVPP) SEQONLY(*YES 100)          */ /*S01486*/
/*********** CPYF       FROMFILE(XPMHITVPP) TOFILE(PMHITVPP) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)           */ /*S01486*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMHITVPP))                          */ /*S01486*/
             OVRDBF     FILE(XPMHITVPD) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMHITVPD) TOFILE(PMHITVPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMHITVPD))                             /*S01486*/
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
/**********  IF         COND(&BUSY = 'OLD') THEN(DO)                **/
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
/*********** OVRDBF     FILE(PMHITVPP) SEQONLY(*YES 100)           */ /*S01486*/
/*********** CPYF       FROMFILE(PMHITVPP) TOFILE(&TOLIB/XPMHITVPP) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*N */ /*S01486*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMHITVPP))                         */ /*S01486*/
             OVRDBF     FILE(PMHITVPD) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMHITVPD) TOFILE(&TOLIB/XPMHITVPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMHITVPD))                            /*S01486*/
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')     **/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* CALL RPG PROGRAM */
             CALL       PGM(PM0940)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********    SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             ENDDO
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*>>S01189>>*/
/*********** CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')      **/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/*********** DLTF       FILE(XPMHITVPP)                            */ /*S01486*/
             DLTF       FILE(XPMHITVPD)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
/*********** CLRPFM     FILE(PMCHTVPP)                                  080737*/
             CLRPFM     FILE(PMCHTVPD)                                /*080737*/
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
