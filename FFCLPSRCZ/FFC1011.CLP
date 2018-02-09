/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Close Out Set A/C Key Gen (EOC)')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1011  -  CLOSE OUT SET A/C KEY GENERATION (EOC)              */
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
/*       Prev Amend No. S01117             Date 10/04/90             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   S01117 - MULTIBRANCHING                                         */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MKT)
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &MKT          TYPE(*CHAR)  LEN(2)
             DCL        &ACT          TYPE(*CHAR)  LEN(1)
             DCL        &MSG          TYPE(*CHAR)  LEN(70)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
/**/
/*   OVERRIDE MULTIMEMBER FILES TO MEMBER 'MARKET'                  */
/**/
             OVRDBF     FILE(CLOST1) TOFILE(CLOST1) MBR(&MKT)
             OVRDBF     FILE(CLOST4) TOFILE(CLOST4) MBR(&MKT)
             OVRDBF     FILE(CLOST5) TOFILE(CLOST5) MBR(&MKT)
             OVRDBF     FILE(FOKEYD) TOFILE(FOKEYD) MBR(&MKT) +
                         SEQONLY(*YES 100)
             OVRDBF     FILE(FOKEYA) TOFILE(FOKEYA) MBR(&MKT)
             OVRDBF     FILE(TRANS) TOFILE(TRANS) MBR(&MKT)
             OVRDBF     FILE(TRSET) TOFILE(TRSET) MBR(&MKT)
             OVRDBF     FILE(POCHGCC) TOFILE(POCHGCC) MBR(&MKT) +
                         SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGCK) TOFILE(POCHGCK) MBR(&MKT) +
                         SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTC) TOFILE(POCHGTC) MBR(&MKT) +
                         SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTK) TOFILE(POCHGTK) MBR(&MKT) +
                         SEQONLY(*YES 100)
/**/
/*   CALL PROGRAM                                                  */
/**/
             CALL       PGM(FF0410) PARM(&MKT)
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ.                                               */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE('I')
                 CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1011')
                 CALL       FF0473 PARM(&MKT &ACT &MSG)
             ENDDO
/*                                                                   */
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX1X)
/**/
END:
             DLTOVR     FILE(CLOST1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(CLOST4)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(CLOST5)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRSET)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(FOKEYD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(FOKEYA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POCHGCC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POCHGCK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POCHGTC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POCHGTK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
