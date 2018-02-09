/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF O/S Postn in Spot Mth Rpt(COB)')             */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/****FFC0625**-**OUTSTANDING*POSITIONS*IN*SPOT*MONTH*(COB*ON*REQUEST)* *FO0035*/
/*   FFC0625  -  OUTSTANDING POSITIONS IN SPOT MONTH REPORT          * *FO0035*/
/*               - COMPLETE LIST, ALL MARKETS (ONREQ, I/C AND COB)   * *FO0035*/
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
/*   PREV AMEND NO. E27473             DATE 16AUG91                  */
/*                  RT0117             DATE 22MAY91                  */
/*                  FO0035             DATE 29APR91                  */
/*                  FO0075             DATE 17APR91                  */
/*                  FO0074             DATE 16APR91                  */
/*                  S01117             DATE 21MAY90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   E27473  -  Delete WPOSTN from qtemp before end of program       */
/*              because it can cause abnormal termination.           */
/*   RT0117  -  CHANGE DLIB TO DPLIB                                 */
/*   FO0035  -  REL 10 RCF CHANGES                                   */
/*   FO0075  -  MOVE COPYRIGHT STATEMENT                            */
/*   FO0074  -  ADD ABNOR PROCESSING                                 */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
/*   DECLARE FILE AND VARIABLES                                    */
/**/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
/*********** DCL        VAR(&LIB) TYPE(*CHAR) LEN(6)           /*FO0035*RT0117*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)                  /*RT0117*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)               /*FO0035*/
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)             /*S01117*/
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)             /*S01117*/
             DCL        &RENT         TYPE(*CHAR)  LEN(3)             /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(MKCTL)
/**/                                                                  /*FO0074*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                        EXEC(GOTO ABNOR)                              /*FO0074*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*FO0035*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0035*/
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0625 - +
             Outstanding Positions in Spot Month Report') TOMSGQ(MRUNQ)
/**/
/* CREATE TEMP EXTRACT FILE, PF/WPOSTN, IN QTEMP                   */ /*FO0035*/
/**/                                                                  /*FO0035*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)          /*FO0035*/
/*********** CHGVAR VAR(&LIB) VALUE(&PREFIX *CAT 'DLIB')    */ /*FO0035*RT0117*/
             CHGVAR VAR(&LIB) VALUE(&PREFIX *CAT 'DPLIB')             /*RT0117*/
/**/                                                                  /*FO0035*/
             CRTDUPOBJ  OBJ(WPOSTN) FROMLIB(&LIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*NO)                      /*FO0035*/
             OVRDBF FILE(WPOSTN) TOFILE(QTEMP/WPOSTN)                 /*FO0035*/
/**/                                                                  /*FO0035*/
/**CLEAR*PF/WPOSTN**************************************************/ /*FO0035*/
/************CLRPFM     FILE(WPOSTN)                               */ /*FO0035*/
/**/
/*  OVERRIDE LF/POSTN3 AND LF/PRICS                                 */
/**/
             OVRDBF     FILE(POSTN3) MBR(OTC)
             OVRDBF     FILE(PRICS) MBR(OTC)
/**/
             CHGJOB     SWS(1XXXXX00)
/**/
/*   CALL FF1220 - OUTSTANDING POSITIONS IN SPOT MONTH EXTRACT      */
/**/
             CALL       PGM(FF1220)  PARM('  ')
/*                                                                  */
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*   CALL FF1230 - OUTSTANDING POSITIONS IN SPOT MONTH REPORT       */
/**/
/*********** CALL       PGM(FF1230)  PARM('  ')                    */ /*S01117*/
             CALL       PGM(FF1230)  PARM('  ' &RSEQ)                 /*S01117*/
/*                                                                  */
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*******DELETE*ALL*OVERRIDES***                                    */ /*FO0035*/
/************DLTOVR     FILE(*ALL)                                    /*FO0035*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0035*/
/**/
/* LOOP TO PROCESS ALL LIVE MARKET CENTRES ON MKCTL          */
/**/
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             CHGJOB     SWS(1XXXXX00)
/**/
             IF         COND(&MKCI *EQ 'S')  +
                           THEN(GOTO CMDLBL(LOOP))
/**/
/* CLEAR PF/WPOSTN                                                 */
/**/
             CLRPFM     FILE(QTEMP/WPOSTN)                            /*FO0035*/
/************CLRPFM     FILE(WPOSTN)                               */ /*FO0035*/
/**/
/*  OVERRIDE LF/POSTN3 AND LF/PRICS                                 */
/**/
             OVRDBF     FILE(POSTN3) MBR(&MRKT)
             OVRDBF     FILE(PRICS) MBR(&MRKT)
/**/
/*   CALL FF1220 - OUTSTANDING POSITIONS IN SPOT MONTH EXTRACT      */
/**/
             CALL       PGM(FF1220)  PARM(&MRKT)
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*   CALL FF1230 - OUTSTANDING POSITIONS IN SPOT MONTH REPORT       */
/**/
/*********** CALL       PGM(FF1230)  PARM(&MRKT)                   */ /*S01117*/
             CALL       PGM(FF1230)  PARM(&MRKT &RSEQ)                /*S01117*/
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
             GOTO       CMDLBL(LOOP)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
/*DBERR:**** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
 DBERR:      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ MRUNQ)
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC0625 - O/S Positions in Spot Month +
                          Report Ended Abnormally') TOMSGQ(MRUNQ +
                          MOPERQ)                                     /*FO0074*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0074*/
             CHGJOB     SWS(XXXXXX11)                                 /*FO0074*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0074*/
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
END:         DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*********** CHGVAR     VAR(&BISCPY) VALUE('COPYRIGHT MKI')        */ /*FO0075*/
/**/
             DLTF       FILE(QTEMP/WPOSTN)                            /*E27473*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E27473*/
             ENDPGM
