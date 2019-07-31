/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MT Telex departmental re-routing')              */
/********************************************************************/
/*                                                                   */
/*     Midas - Midas Telex.                                      */
/*                                                                   */
/*     MTC5010 - Departmental Rerouting                              */
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
/*       Prev Amend No. 081507  *CREATE    Date 20Jan95              */
/*                      XXXXXX             Date XXAaaXX              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     081507 - ORION UPGRADE.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&USERID &DTEFMT &JOB &ROPTION)
 
             DCL        VAR(&DTEFMT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USERID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DEPT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ROPTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DCF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* CALL PROGRAM TO FIND OUT WHICH DEPARTMENT &USERID IS ASSIGNED TO */
             CALL       PGM(MT5030) PARM(&USERID &DEPT)
 
/* IF USER NOT DEFINED AS REROUTE OPERATOR THEN END */
             IF         COND(&DEPT *EQ '   *NOTRRO') THEN(DO)
               SNDBRKMSG  MSG('User not defined as a Reroute Operator +
                            in Midas Telex.') TOMSGQ(&JOB)
               GOTO       CMDLBL(END)
             ENDDO
 
/* IF ERROR READING USER FILE THEN END */
             IF         COND(&DEPT *EQ '    *ERROR') THEN(DO)
               SNDBRKMSG  MSG('Program ended abnormally. Program: +
                            MT5030  File: N#UP.') TOMSGQ(&JOB)
               GOTO       CMDLBL(END)
             ENDDO
 
/* CHECK FOR DECODING FLAG */
             IF         COND(&ROPTION *EQ 'D') THEN(DO)
               RTVDTAARA  DTAARA(N#ZC (377 1)) RTNVAR(&DCF)
               IF         COND(&DCF  *NE '1') THEN(DO)
                SNDBRKMSG  MSG('Decoding enhancement not switched on. +
                             Contact your nearest office for +
                             further information.') TOMSGQ(&JOB)
                GOTO       CMDLBL(END)
               ENDDO
             ENDDO
 
/* CALL ITEMS AWAITING REROUTING OR DECODING WITH DEPARTMENT */
             CALL       PGM(CC3047) PARM(&USERID &DTEFMT &DEPT +
                          &ROPTION)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
