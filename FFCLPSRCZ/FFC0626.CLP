/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF O/S Posns Ent Spot Mth (Onreq)')             */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0626  -  OUTSTANDING POSITIONS ENTERING SPOT MONTH TODAY     */
/*                -  ALL MARKETS   (I/C ON REQUEST)                  */
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
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   E27473  -  Delete WPOSTN from qtemp before end of program       */
/*              because it can cause abnormal termination.           */
/*   RT0117  -  CHANGE DLIB TO DPLIB                                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
/*   DECLARE FILE AND VARIABLES                                    */
/**/
             DCL        &RSEQ        TYPE(*CHAR)  LEN(5)
             DCL        &RLEV        TYPE(*CHAR)  LEN(1)
             DCL        &RENT        TYPE(*CHAR)  LEN(3)
             DCL        &MEM         TYPE(*CHAR)  LEN(50)
/*********** DCL        &LIB         TYPE(*CHAR)  LEN(6)           */ /*RT0117*/
             DCL        &LIB         TYPE(*CHAR)  LEN(7)              /*RT0117*/
             DCL        &PREFIX      TYPE(*CHAR)  LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(MKCTL)
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                        EXEC(GOTO ABNOR)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0626 - Outstanding Positions +
                          Entering Spot Month Today Report') +
                          TOMSGQ(MRUNQ)
/**/
/* CREATE TEMP EXTRACT FILE, PF/WPOSTN, IN QTEMP                   */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/*********** CHGVAR VAR(&LIB) VALUE(&PREFIX *CAT 'DLIB')           */ /*RT0117*/
             CHGVAR VAR(&LIB) VALUE(&PREFIX *CAT 'DPLIB')             /*RT0117*/
/**/
             CRTDUPOBJ  OBJ(WPOSTN) FROMLIB(&LIB)  OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF FILE(WPOSTN) TOFILE(QTEMP/WPOSTN)
/**/
/*  OVERRIDE LF/POSTN3 AND LF/PRICS                                */
/**/
             OVRDBF     FILE(POSTN3) MBR(OTC)
             OVRDBF     FILE(PRICS) MBR(OTC)
/**/
             CHGJOB     SWS(0XXXXX00)
/**/
/*   CALL FF1220 - OUTSTANDING POSITIONS IN SPOT MONTH EXTRACT     */
/**/
             CALL       PGM(FF1220)  PARM('  ')
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                             */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*   CALL FF1230 - OUTSTANDING POSITIONS IN SPOT MONTH REPORT      */
/**/
             CALL       PGM(FF1230)  PARM('  ' &RSEQ)
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                             */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/* LOOP TO PROCESS ALL LIVE MARKET CENTRES ON MKCTL                */
/**/
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
             CHGJOB     SWS(0XXXXX00)
/**/
             IF         COND(&MKCI *EQ 'S')  +
                           THEN(GOTO CMDLBL(LOOP))
/**/
/* CLEAR EXTRACT FILE                                              */
/**/
             CLRPFM     FILE(QTEMP/WPOSTN)
/**/
/*  OVERRIDE LF/POSTN3 AND LF/PRICS                                */
/**/
             OVRDBF     FILE(POSTN3) MBR(&MRKT)
             OVRDBF     FILE(PRICS) MBR(&MRKT)
/**/
/*   CALL FF1220 - OUTSTANDING POSITIONS IN SPOT MONTH EXTRACT     */
/**/
             CALL       PGM(FF1220)  PARM(&MRKT)
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                             */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*   CALL FF1230 - OUTSTANDING POSITIONS IN SPOT MONTH REPORT      */
/**/
             CALL       PGM(FF1230)  PARM(&MRKT &RSEQ)
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                             */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
             GOTO       CMDLBL(LOOP)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND     */
/* MESSAGE TO MOPERQ AND MRUNQ.                                    */
/**/
 DBERR:      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ MRUNQ)
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC0626 - O/S Positions Entering Spot +
                          Month Today Report Ended Abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*      DELETE ALL OVERRIDES                                       */
/**/
 END:        DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTF       FILE(QTEMP/WPOSTN)                            /*E27473*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E27473*/
/**/
             ENDPGM
