/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Autoclosure (EOC)')                          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1004  -  AUTOCLOSURE (EOC)                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. S01117             DATE 15MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
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
             PGM        PARM(&MKT)
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
 
/**/
/*  OVERRIDE TO CORRECT MARKET          - INPUT                     */
/**/
             OVRDBF     FILE(TRANS5) MBR(&MKT)
/**/
/*                                         OUTPUT                    */
/**/
             OVRDBF     FILE(WTRNSD) MBR(&MKT) SEQONLY(*YES 100)
/**/
             CLRPFM     FILE(WTRNSD) MBR(&MKT)
/**/
/*     CALL EXTRACT PROGRAM                                          */
/**/
             CALL       PGM(FF0325) PARM(&MKT)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
/*     INPUT                                                         */
/**/
             OVRDBF     FILE(WTRNSLP) MBR(&MKT)
             OVRDBF     FILE(WTRNSFP) MBR(&MKT)
             OVRDBF     FILE(WTRNSLS) MBR(&MKT)
             OVRDBF     FILE(WTRNSFS) MBR(&MKT)
/**/
/*                                         OUTPUT                    */
/**/
             OVRDBF     FILE(CLOSTT) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(CLOSTD) MBR(&MKT) SEQONLY(*YES 100)
/**/
/*     CALL CLOSE OUT SET CREATION PROGRAM                           */
/**/
             CALL       PGM(FF0330) PARM(&MKT)
 
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
/*     INPUT                                                         */
/**/
             OVRDBF     FILE(WTRNS1) MBR(&MKT)
/**/
/*     OUTPUT                                                        */
/**/
             OVRDBF     FILE(TRANS) MBR(&MKT)
/**/
/*     CALL TRANSACTIONS UPDATE PROGRAM                              */
/**/
             CALL       PGM(FF0335)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             GOTO       CMDLBL(END)
/**/
DBERR:
             RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1004')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
/*                                                                   */
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX1X)
/**/
END:
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(TRANS5)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSLP)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSLS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSFP)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSFS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNS1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(CLOSTD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(CLOSTT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
