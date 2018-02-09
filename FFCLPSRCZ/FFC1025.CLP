/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF O/S Posn in Spot Mth (EOC)')                 */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/****FFC1025**-**OUTSTANDING*POSITION*IN*SPOT*MONTH*CONTROL*(EOC)***** *FO0035*/
/*   FFC1025  -  OUTSTANDING POSITIONS ENTERING SPOT MONTH TODAY     * *FO0035*/
/*                -  (EOC)                                           * *FO0035*/
/*                                                                   * *FO0035*/
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
/*                  S01117             DATE 21JUN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   E27473  -  Delete WPOSTN from qtemp before end of program       */
/*              because it can cause abnormal termination.           */
/*   RT0117  -  CHANGE DLIB TO DPLIB                                 */
/*   FO0035  -  COMPONENT NAME AMENDED                               */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
/*                                                                  */
/* DECLARE VARIABLES                                                */
/*                                                                  */
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
             DCL        VAR(&FRONT) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&LIB) TYPE(*CHAR) LEN(6)               */ /*RT0117*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)                  /*RT0117*/
/*********** DCL        VAR(&BACK) TYPE(*CHAR) LEN(4) VALUE('DLIB')*/ /*RT0117*/
             DCL        VAR(&BACK) TYPE(*CHAR) LEN(5) VALUE('DPLIB')  /*RT0117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                  */
/* Global monitor message                                           */
/*                                                                  */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                  */
/* SET OFF U1, U7 AND U8                                            */
/*                                                                  */
             CHGJOB SWS(0XXXXX00)
/*                                                                  */
/* CREATE TEMP EXTRACT FILE, PF/WPOSTN, IN QTEMP                    */
/*                                                                  */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&FRONT)
             CHGVAR VAR(&LIB) VALUE(&FRONT *CAT &BACK)
/*                                                                  */
             CRTDUPOBJ  OBJ(WPOSTN) FROMLIB(&LIB)  OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             OVRDBF FILE(WPOSTN) TOFILE(QTEMP/WPOSTN)
/*                                                                  */
/* OVERRIDE FILES POSTN3 AND PRICS TO MEMBER FOR MARKET             */
/*                                                                  */
             OVRDBF FILE(POSTN3) TOFILE(POSTN3) MBR(&PARM)
             OVRDBF FILE(PRICS) TOFILE(PRICS) MBR(&PARM)
/*                                                                  */
/* CALL OUTSTANDING POSITION BY SPOT MONTH EXTRACT PROGRAM          */
/*                                                                  */
             CALL       PGM(FF1220) PARM(&PARM)
/*                                                                  */
/* DATABASE ERROR?                                                  */
/*                                                                  */
             IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                                                                  */
/* CALL OUTSTANDING POSITION BY SPOT MONTH REPORT PROGRAM           */
/*                                                                  */
/*********** CALL       PGM(FF1230) PARM(&PARM)                    */ /*S01117*/
             CALL       PGM(FF1230) PARM(&PARM '     ')               /*S01117*/
/*                                                                  */
/* DATABASE ERROR?                                                  */
/*                                                                  */
             IF  COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/*                                                                  */
             GOTO END
/*                                                                  */
/*     Database error processing. Send message to MOPERQ            */
/*                                                                  */
DBERR:
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1025')
             CALL       FF0473 PARM(&PARM &ACT &MSG)
             GOTO END
/*                                                                  */
/*     Abnormal error processing. Message to MOPERQ                 */
/*                                                                  */
 ABNOR:      CHGJOB SWS(XXXXXX1X)
/*                                                                  */
 END:        DLTF       FILE(QTEMP/WPOSTN)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POSTN3)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRICS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTF       FILE(QTEMP/WPOSTN)                            /*E27473*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E27473*/
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
 
