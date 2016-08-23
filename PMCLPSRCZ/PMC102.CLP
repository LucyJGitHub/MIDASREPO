/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Portfolio transfer update')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC102 - PM PORTFOLIO TRANSFER UPDATE                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. 143756             Date 29Sep98              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S71062             Date 29Feb96              */
/*                      S01408             Date 11May95              */
/*                      S01486             DATE 27SEP94              */
/*                      049421             DATE 18JAN93              */
/*                      S01189     GB      DATE 25MAR92              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       143756  -  Monitor message for copy file XTRANSD when all   */
/*                  members are empty                                */
/*       S71062  -  FF/PM interface                                  */
/*       S01408  -  Addition of core hook PMC102MP1                 */
/*       S01486  -  PRIVATE BANKING UPGRADE                          */
/*       049421  -  HEADER BOX STANDARDISATION                       */
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
/*********   DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                S01189*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(5)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')           *S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC102MP1                                           */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC102  - PM Portfolio Transfer Update') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* RETRIEVE TODAYS DATE */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAT)
 
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
 
/************OVRDBF     FILE(XPMCPOSPP) SEQONLY(*YES 100)              *S01486*/
/************CPYF       FROMFILE(XPMCPOSPP) TOFILE(PMCPOSPP) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMCPOSPP))                              *S01486*/
/************                                                          *S01486*/
/************OVRDBF     FILE(XPMCPOSZZ) SEQONLY(*YES 100)              *S01486*/
/************CPYF       FROMFILE(XPMCPOSZZ) TOFILE(PMCPOSZZ) +         *S01486*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)               *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(PMCPOSZZ))                              *S01486*/
             OVRDBF     FILE(XPMCPOSPD) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMCPOSPD) TOFILE(PMCPOSPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMCPOSPD))                             /*S01486*/
                                                                      /*S01486*/
             OVRDBF     FILE(XPMCPOSPA) SEQONLY(*YES 100)             /*S01486*/
             CPYF       FROMFILE(XPMCPOSPA) TOFILE(PMCPOSPA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMCPOSPA))                             /*S01486*/
                                                                      /*S71062*/
             OVRDBF     FILE(XTRANSD) SEQONLY(*YES 100)               /*S71062*/
             CPYF       FROMFILE(XTRANSD) TOFILE(TRANSD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*S71062*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*S71062*/
             MONMSG     MSGID(CPF0000)                                /*143756*/
             ENDDO
 
/* IF FIRST RUN */
/*>>S01189>>*/
/**********  IF         COND(&BUSY = 'OLD') THEN(DO)                **/
             IF         COND(&BUSY = 'N') THEN(DO)
/*<<S01189<<*/
 
/************OVRDBF     FILE(PMCPOSPP) SEQONLY(*YES 100)               *S01486*/
/************CPYF       FROMFILE(PMCPOSPP) TOFILE(&TOLIB/XPMCPOSPP) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMCPOSPP))                             *S01486*/
/************                                                          *S01486*/
/************OVRDBF     FILE(PMCPOSZZ) SEQONLY(*YES 100)               *S01486*/
/************CPYF       FROMFILE(PMCPOSZZ) TOFILE(&TOLIB/XPMCPOSZZ) +  *S01486*/
/************             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) *S01486*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +   *S01486*/
/************             FILE(XPMCPOSZZ))                             *S01486*/
             OVRDBF     FILE(PMCPOSPD) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMCPOSPD) TOFILE(&TOLIB/XPMCPOSPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMCPOSPD))                            /*S01486*/
                                                                      /*S01486*/
             OVRDBF     FILE(PMCPOSPA) SEQONLY(*YES 100)              /*S01486*/
             CPYF       FROMFILE(PMCPOSPA) TOFILE(&TOLIB/XPMCPOSPA) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S01486*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPMCPOSPA))                            /*S01486*/
                                                                      /*S71062*/
             OVRDBF     FILE(TRANSD) SEQONLY(*YES 100)                /*S71062*/
             CPYF       FROMFILE(TRANSD) TOFILE(&TOLIB/XTRANSD) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) /*S71062*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*S71062*/
 
/*>>S01189>>*/
/*********   CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('NEW')     **/
                   CHGVAR     VAR(&BUSY) VALUE('Y')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
             ENDDO
 
/* OVERRIDE WORK FILES */
             OVRDBF     FILE(PMHPOSXX) TOFILE(PMHPOSLL) SHARE(*NO)
 
/* CALL PORTFOLIO TRANSFER PROGRAM */
             CALL       PGM(PM1020)
/* DELETE FILE OVERRIDES */
             DLTOVR     FILE(*ALL)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&DATA) +
*****************************TOMSGQ(MOPERQ MRUNQ)                    */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
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
/***************SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*>>S01189>>*/
/*********** CHGDTAARA  DTAARA(PMSTAT (16 3)) VALUE('OLD')      **/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/*<<S01189<<*/
/************DLTF       FILE(XPMCPOSPP)                                *S01486*/
             DLTF       FILE(XPMCPOSPD)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
/************DLTF       FILE(XPMCPOSZZ)                                *S01486*/
             DLTF       FILE(XPMCPOSPA)                               /*S01486*/
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(XTRANSD)                                 /*S71062*/
             MONMSG     MSGID(CPF2105)                                /*S71062*/
/************CLRPFM PMTRSFPP                                           *S01486*/
             CLRPFM PMTRSFPD                                          /*S01486*/
             ENDDO
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
