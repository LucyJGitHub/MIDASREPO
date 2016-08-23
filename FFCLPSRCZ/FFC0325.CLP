/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Pos. Profit ctr. report')                    */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0325  -  Position Profit Centre List                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. E00000             DATE ddmmmyy                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   E00000  -                                                       */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGJOB     SWS(00000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/**/
/*   OVERRIDE POSITION PROFIT CENTRE FILES TO BRANCH OF REQUEST    */
/**/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)
/**/
 
             OVRDBF     FILE(FOPCLCD) MBR(*FIRST) POSITION(*KEY 1 +
                          FOPCCDF &RENT)
/**/
             OVRDBF     FILE(FOPKLCD) MBR(*FIRST) POSITION(*KEY 1 +
                          FOPCKDF &RENT)
/**/
             OPNDBF     FILE(FOPCLCD) OPTION(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(DLTOVR FILE(FOPCLCD))
/**/
             OPNDBF     FILE(FOPKLCD) OPTION(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(DLTOVR FILE(FOPKLCD))
/**/
             ENDDO
/**/
/*   CALL PROGRAM                                                  */
/**/
             CALL       PGM(FF1190)   PARM(&RSEQ &RENT &MODE)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND     */
/* MESSAGE TO MRUNQ AND MOPERQ.                                    */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC0325 - Position Profit Centre Report +
                          terminated abnormally') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        ENDPGM
