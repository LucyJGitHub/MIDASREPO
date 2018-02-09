/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Margin Calculation (EOC)')                   */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1015  -  MARGIN CALCULATION (EOC)                            */
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
/*       Prev Amend No. S04662             Date 20Jul93              */
/*   LAST AMEND NO. S01117             DATE 21JUN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   S04662 - Switchable Feature for Init Margins for Futures;       */
/*            Deposit and Spread Margin Rate added to DEFLTD.        */
/*            FF0440 has been rewritten and enhanced by FF0445.      */
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
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
/**/
/*  OVERRIDE TO CORRECT MARKET          - INPUT                     */
/**/
             OVRDBF     FILE(POSTNC4) MBR(&MKT)
             OVRDBF     FILE(TSMKT) MBR(&MKT)
/**/
/*                                      - OUTPUT                     */
/**/
             OVRDBF     FILE(TSMKTD) MBR(&MKT)
/**/
/****CALL*FF0440 - MARGIN CALCULATION               ********************S04662*/
/************                                       ********************S04662*/
/************CALL       PGM(FF0440)  PARM(&MKT)     ********************S04662*/
/*   CALL FF0445 - MARGIN CALCULATION                                 /*S04662*/
/**/                                                                  /*S04662*/
             CALL       PGM(FF0445)  PARM(&MKT)                       /*S04662*/
/**/
/*     DATABASE ERROR?  IF SO SEND MESSAGE TO MOPERQ AND CALL FF0473 */
/*     - THE ERROR MONITORING PROGRAM                                */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1015')
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
/*      DELETE ALL OVERRIDES                                        */
/**/
END:         DLTOVR     FILE(POSTNC4)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TSMKT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TSMKTD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
