/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF I/C Cust. Trading Stmts - Prompt')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0323P -  CUSTOMER TRADING STATEMENTS ( INTERIM ) - PROMPT    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. FO0046             DATE 02APR91                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   FO0046  -  New Prompt Program for I/C Customer Trading Statmnts */
/*              Report - required because of R10 RCF changes.        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
/**/
/*  DECLARE VARIABLES                                               */
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CFERUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/*  IF CUSTOMER TRADING STATEMENTS REPORT BEING RUN BY ANOTHER      */
/*     USER, SET ON U2                                              */
/**/
             RTVDTAARA  DTAARA(FFSTAT (36 1)) RTNVAR(&CFERUN)
             IF         COND(&CFERUN *EQ 'Y') THEN(DO)
              CHGJOB     SWS(01000000)
              ENDDO
             ELSE       CMD(DO)
              CHGDTAARA  DTAARA(FFSTAT (36 1)) VALUE('Y')
              CHGJOB     SWS(00000000)
             ENDDO
/**/
             OVRDBF     FILE(TSCCYX) TOFILE(TSCCY) SHARE(*NO)
/**/
/*  CALL REPORT PROMPT PROGRAM                                      */
/**/
             CALL       PGM(FF1270) PARM(&RENT &RCMD)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ.                                               */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING                                               */
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC0323P - CUSTOMER TRADING STATEMENTS +
                          (INTERIM) PROMPT - ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*   If Customer trading statements report active flag was not      */
/*   previously 'Y' reset the flag to 'N'                           */
/**/
             IF         COND(%SWITCH(X0XXXXXX)) THEN(DO)
                  CHGDTAARA  DTAARA(FFSTAT (36 1)) VALUE('N')
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/**/
             ENDPGM
