/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM End of Month Drop')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC2500 - PM End of Month Security Position Drop            */
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
/*       PREV AMEND NO. 072670             DATE 24NOV94             */
/*                      S01486             DATE 11AUG94              */
/*                      049421             DATE 18JAN93              */
/*                      48219              DATE 19OCT92              */
/*                      S01189             DATE 25MAR92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01408 - Addition of core hook PMC2500MP1                   */
/*       072670  -  Add new program to drop matured flat positions   */
/*       S01486  -  Portfolio Management Upgrade to Release 10.      */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       48219   -  CHANGE TO SAVE PM POSITIONS TO TRADE RETENTION DT*/
/*       S01189  -  COB RECOVERY PROCESSING                          */
/*       R00300  -  Message file changes.                            */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
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
/*********   DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)              S01189   **/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*********** CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC2500MP1                                          */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC2500 - End of Month Security Position +
                          Drop') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
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
/*********** OVRDBF     FILE(XPMCPOSPP) SEQONLY(*YES 100)          */ /*S01486*/
/*********** CPYF       FROMFILE(XPMCPOSPP) TOFILE(PMCPOSPP) +     */ /*S01486*/
/***********              MBROPT(*REPLACE) FMTOPT(*NONE)           */ /*S01486*/
/*********** MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +*/ /*S01486*/
/***********              FILE(PMCPOSPP))                          */ /*S01486*/
             OVRDBF     FILE(XPMCPOSPD) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMCPOSPD) TOFILE(PMCPOSPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMCPOSPD))                             /*S01486*/
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
/*********** IF         COND(&BUSY = 'OLD') THEN(DO)                  */
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
/*********** OVRDBF     FILE(PMCPOSPP) SEQONLY(*YES 100)           */ /*S01486*/
/*********** CPYF      FROMFILE(PMCPOSPP) TOFILE(&TOLIB/XPMCPOSPP)+*/ /*S01486*/
/***********           MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)*/ /*S01486*/
/*********** MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM+*/ /*S01486*/
/***********              FILE(XPMCPOSPP))                         */ /*S01486*/
             OVRDBF     FILE(PMCPOSPD) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMCPOSPD) TOFILE(&TOLIB/XPMCPOSPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMCPOSPD))                            /*S01486*/
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')     **/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* CALL RPG PROGRAM TO DROP FLAT MATURED POSITIONS  */
             CALL       PGM(PM2510)                                  /*72670 */
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             /*72670 */
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        /*72670 */
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                    /*72670 */
                GOTO       CMDLBL(ENDDRP)                            /*72670 */
             ENDDO                                                   /*72670 */
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)             /*72670 */
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)        /*72670 */
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                    /*72670 */
                GOTO       CMDLBL(ENDDRP)                            /*72670 */
             ENDDO                                                   /*72670 */
 
/* CALL RPG PROGRAM */
             OVRDBF     FILE(PMHPOSXX) TOFILE(PMHPOSLL) SHARE(*NO)     /*48219*/
             CALL       PGM(PM2500)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0002) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***********SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
             SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             ENDDO
 
/* IF JOB ENDED NORMALLY */
ENDDRP:      IF         COND(%SWITCH(XXXXXX00)) THEN(DO)             /*072670*/
/*********** IF         COND(%SWITCH(XXXXXX00)) THEN(DO)             /*072670*/
/*  S01189>>*/
/*********** CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')      **/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/*********** DLTF       FILE(XPMCPOSPP)                            */ /*S01486*/
             DLTF       FILE(XPMCPOSPD)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
