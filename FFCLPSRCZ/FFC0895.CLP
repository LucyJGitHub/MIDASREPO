/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF O/S Posn in Spot Month (COB)')               */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/****FFC0895**-**OUTSTANDING*POSITIONS*IN*SPOT*MONTH*(EOC*IN*COB)***** *FO0035*/
/*   FFC0895  -  OUTSTANDING POSITIONS ENTERING SPOT MONTH TODAY     * *FO0035*/
/*                 -  (COB)                                          * *FO0035*/
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
/*       Prev Amend No. 079666             Date 01Dec94              */
/*                      E27473             Date 16Aug91              */
/*                  RT0117             DATE 22MAY91                  */
/*                  FO0035             DATE 29APR91                  */
/*                  S01117             DATE 21MAY90                  */
/*                                                                   */
/*-----------------`-------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  079666 - Add global monitor message processing                   */
/*   E27473  -  Delete WPOSTN from qtemp before end of program       */
/*              because it can cause abnormal termination.           */
/*   RT0117  -  CHANGE DLIB TO DPLIB                                 */
/*   FO0035  -  REL 10 RCF CHANGES                                   */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)
/*********** DCL        VAR(&LIB) TYPE(*CHAR) LEN(6)        */ /*FO0035*RT0117*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)                  /*RT0117*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)               /*FO0035*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
                                                                      /*079666*/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0895 - Outstanding Positions +
                          Entering Spot Month Today Report') +
                          TOMSGQ(MRUNQ)                               /*FO0035*/
/************SNDPGMMSG  MSG('FFC0895 - +                           */ /*FO0035*/
/************Outstanding Positions in Spot Month Report') TOMSGQ(MRUNQ)*FO0035*/
/**/
/* CREATE TEMP EXTRACT FILE, PF/WPOSTN, IN QTEMP                    */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/*********** CHGVAR VAR(&LIB) VALUE(&PREFIX *CAT 'DLIB')           */ /*RT0117*/
             CHGVAR VAR(&LIB) VALUE(&PREFIX *CAT 'DPLIB')             /*RT0117*/
/**/
             CRTDUPOBJ  OBJ(WPOSTN) FROMLIB(&LIB)  OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF FILE(WPOSTN) TOFILE(QTEMP/WPOSTN)
/**/                                                                  /*FO0035*/
/**/
/**CLEAR*PF/WPOSTN****                                             */ /*FO0035*/
/************CLRPFM     FILE(WPOSTN)                               */ /*FO0035*/
/**/
/*  OVERRIDE LF/POSTN3 AND LF/PRICS                                 */
/**/
             OVRDBF     FILE(POSTN3) MBR(OTC)
             OVRDBF     FILE(PRICS) MBR(OTC)
/**/
             CHGJOB     SWS(0XXXXX00)
/**/
/*   CALL FF1220 - OUTSTANDING POSITIONS IN SPOT MONTH EXTRACT      */
/**/
             CALL       PGM(FF1220)  PARM('  ')
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*   CALL FF1230 - OUTSTANDING POSITIONS IN SPOT MONTH REPORT       */
/**/
/*********** CALL       PGM(FF1230)  PARM('  ')                    */ /*S01117*/
             CALL       PGM(FF1230)  PARM('  ' '     ')               /*S01117*/
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*******DELETE*ALL*OVERRIDES***                                    */ /*FO0035*/
/************DLTOVR     FILE(*ALL)                                 */ /*FO0035*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */ /*FO0035*/
/**/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC     */
/**/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
/**/
 LOOP:       CHGJOB     SWS(0XXXXX00)
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/**/
/* CLEAR PF/WPOSTN                                                */
/**/
             CLRPFM     FILE(QTEMP/WPOSTN)                            /*FO0035*/
/************CLRPFM     FILE(WPOSTN)                               */ /*FO0035*/
/**/
/*  OVERRIDE LF/POSTN3 AND LF/PRICS                                 */
/**/
             OVRDBF     FILE(POSTN3) MBR(&MKT)
             OVRDBF     FILE(PRICS) MBR(&MKT)
/**/
/*   CALL FF1220 - OUTSTANDING POSITIONS IN SPOT MONTH EXTRACT      */
/**/
             CALL       PGM(FF1220)  PARM(&MKT)
/*                                                                  */
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*   CALL FF1230 - OUTSTANDING POSITIONS IN SPOT MONTH REPORT       */
/**/
/*********** CALL       PGM(FF1230)  PARM(&MKT)                    */ /*S01117*/
             CALL       PGM(FF1230)  PARM(&MKT '     ')               /*S01117*/
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(LOOP)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
/*DBERR:     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
DBERR:       RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ MRUNQ)
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC0895 - O/S Positions Entering Spot +
                          Month Today Report Ended Abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)                        /*FO0035*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0035*/
             CHGJOB     SWS(XXXXXX11)                                 /*FO0035*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0035*/
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
END:         DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTF       FILE(QTEMP/WPOSTN)                            /*E27473*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E27473*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
