/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FF File Rebuilds')                              */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0110  -  FILE REBUILDS DURING CLOSE OF BUSINESS              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*   Last Amend No. MD046248           Date 27Oct17                  */
/*   Prev Amend No. BUG28116           Date 08Sep10                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                  BG18886            DATE 28May08                  */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  RT0117             DATE 22MAY91                  */
/*                  S01117             DATE 21JUN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   BUG28116 - The market centre entered is not currently available */
/*              for transaction maintenance                          */
/*   RT0117  -  CHANGE DLIB TO DPLIB                                 */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*   CREATION REQUIREMENTS                                           */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* DECLARE DATABASE FILE LF/MKCTL                                   */
/**/
             DCLF       FILE(MKCTL)
/**/
/* Declare variables                                               */
/**/
             DCL        VAR(&UPDATE) TYPE(*CHAR) LEN(1) VALUE('N')
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&IND) TYPE(*CHAR) LEN(1) VALUE('N')
/*********** DCL        VAR(&LIB) TYPE(*CHAR) LEN(6)               */ /*RT0117*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)                  /*RT0117*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0110 - Futures and Options File +
                         Rebuilds') TOMSGQ(MRUNQ)
/**/
/*      SET UP NAME OF LIBRARY TO CONTAIN DATA AREAS               */
/**/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**********  CHGVAR     VAR(&LIB) VALUE(%SST(&SDSTAT 6 2)****'DPLIB') */ /*RT0117*/ /*BG18886*/
/**********  CHGVAR     VAR(&LIB) VALUE(%SST(&SDSTAT 6 2) *CAT 'DPLIB')  /*RT0117 BG18886 BUG28116*/
             CHGVAR     VAR(&LIB) VALUE(%SST(&SDSTAT 6 2) *CAT 'DMLIB')                 /*BUG28116*/
/*********** CHGVAR     VAR(&LIB) VALUE(%SST(&SDSTAT 6 2)****'DLIB')   *RT0117*/
/**/
/* OVERRIDE DATABASE FILE LF/MKCTL TO ALLOW UPDATE IN FF0003        */
/**/
             OVRDBF     FILE(MKCTL) SHARE(*NO)
/**/
 READ:          RCVF
/**/
/* IF EOF GOTO NEXT SECTION                                         */
/**/
             MONMSG     MSGID(CPF0864) EXEC(GOTO NEXT)
/**/
/* IF MARKET STATUS INDICATOR IS 'S' AND RECI IS 'D' DO             */
/**/
             IF  COND((&MKCI *EQ 'S') *AND (&RECI *EQ 'D')) THEN(DO)
/**/
/* CREATE MARKET CENTRE DATA AREA FOR RELEVANT MARKET               */
/**/
/********** CRTDTAARA  DTAARA(&LIB/&MRKT) TYPE(*CHAR) LEN(2) AUT(*EXCLUDE) */           /*BUG28116*/
CRTDTAARA  DTAARA(&LIB/&MRKT) TYPE(*CHAR) LEN(2) AUT(*LIBCRTAUT)                        /*BUG28116*/
             MONMSG     MSGID(CPF1023)
/**/
/* CALL FFC0120 - MARKET CENTRE AS PARAMETER                        */
/**/
             CALL       PGM(FFC0120) PARM(&MRKT &IND)
/**/
/* IF PROGRAM FAILED INDICATOR IS 'Y' END                           */
/**/
             IF  COND(&IND *EQ 'Y') THEN(GOTO END)
/**/
/* CALL FFC0130 - MARKET CENTRE AS PARAMETER                        */
/**/
             CALL       PGM(FFC0130) PARM(&MRKT &IND)
/**/
/* IF PROGRAM FAILED INDICATOR IS 'Y' END                           */
/**/
             IF  COND(&IND *EQ 'Y') THEN(GOTO END)
/**/
/* CALL FF0003 - UPDATE MARKET STATUS INDICATOR ON LF/MKCTL TO 'C'  */
/*               MARKET CENTRE AS PARAMETER                         */
/**/
             CALL       PGM(FF0003) PARM(&MRKT)
/**/
/* Check that no database error occured on previous program         */
/**/
             IF  (%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
             CHGVAR VAR(&UPDATE) VALUE('Y')
/**/
             ENDDO
/**/
             GOTO READ
/**/
/* IF FILE HAS BEEN UPDATED                                          */
/**/
 NEXT:       IF  COND(&UPDATE *EQ 'Y') THEN(DO)
/**/
/* CALL FFC0140 - RECREATE LOGICAL FILES OVER ALL MARKET CENTRE     */
/*                MEMBERS IN THE PHYSICAL FILES                     */
/**/
             CALL       PGM(FFC0140) PARM(&IND)
/**/
/* IF PROGRAM FAILED INDICATOR IS 'Y' END                           */
/**/
             IF  COND(&IND *EQ 'Y') THEN(GOTO END)
/**/
             ENDDO
/**/
             GOTO END
/**/
/*     Database error processing. Send message to MOPERQ & MRUNQ    */
/**/
 DBERR:
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
/*                                                                  */
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
/*                                                                  */
