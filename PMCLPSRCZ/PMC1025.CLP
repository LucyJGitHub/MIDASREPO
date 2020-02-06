/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Process Portfolio position transfer')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1025 - PM PROCESS PORTFOLIO POSITION TRANSFER            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CSE017             Date 20Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 11May95              */
/*                      S01486             Date 28Sep94              */
/*                      S01189             DATE 27OCT93              */
/*                      056555             DATE 08JUL93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*       S01408 - Addition of core hook PMC1025MP1                   */
/*       S01486 - PRIVATE BANKING UPGRADE                            */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       056555 - TRANSFER OF POSITION                               */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*>>S01189>>*/
/************PGM*/
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
/*********   DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                   S01189*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DAPTLR) TYPE(*CHAR) LEN(5)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')           *S01486*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1025MP1                                          */
                                                                      /*S01408*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1025  - PM Process Portfolio +
                          Position Transfer ') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* RETRIEVE DATE POSITION TRANSFER LAST RUN                                  */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAT)
             RTVDTAARA  DTAARA(PMSTAT (42 5)) RTNVAR(&DAPTLR)
 
/* IF DATE POSTION TRANSFER LAST RUN *NE RUNDATE ,                           */
 
             IF         COND(&DAPTLR *LT &DAT) THEN(DO)
 
             CPYF       FROMFILE(DPTMVD) TOFILE(&TOLIB/XDPTMVD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XDPTMVD))
             CPYF       FROMFILE(DPTMVA) TOFILE(&TOLIB/XDPTMVA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XDPTMVA))
 
/* CALL PROCESS PORTFOLIO TRANSFER PROGRAM */
             OVRDBF     FILE(DPTMVX) TOFILE(DPTMV) SHARE(*NO)
             CALL       PGM(PM1025)
 
             ENDDO
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DPTMVD))
             CPYF       FROMFILE(XDPTMVA) TOFILE(DPTMVA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DPTMVA))
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/***************             TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             DLTOVR     FILE(DPTMVX)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XDPTMVD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(XDPTMVA)
             MONMSG     MSGID(CPF2105)
             CHGDTAARA  DTAARA(PMSTAT (42 5)) VALUE(&DAT)
             ENDDO
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
