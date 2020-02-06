/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CI Transaction Analysis Report')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4475 - Transaction Analysis Report.                      */
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
/*       Prev Amend No. CRT003  *CREATE    Date 22Jul96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRT003 - Cashier Interface.                                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RMSG &RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&LDA)    TYPE(*CHAR)  LEN(256) VALUE(' ')
             DCL        VAR(&MSGDTA) TYPE(*CHAR)  LEN(50)
             DCL        VAR(&RMSG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ROPT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(3)
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('REC4475 - Transaction Analysis Report') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB SWS(00000000)
/**/
/* INITIALIZE DB AREA OF LDA AND CALL THE PROGRAM */
/**/
             CHGVAR     VAR(&ROPT) VALUE(%SST(&RPARM 1 1))
 
             IF         COND(&ROPT = '1') THEN(OVRDBF FILE(REPLOGPD) +
                          TOFILE(REPLOGL1))
             IF         COND(&ROPT = '2') THEN(OVRDBF FILE(REPLOGPD) +
                          TOFILE(REPLOGL2))
             IF         COND(&ROPT = '3') THEN(OVRDBF FILE(REPLOGPD) +
                          TOFILE(REPLOGL3))
             IF         COND(&ROPT = '4') THEN(OVRDBF FILE(REPLOGPD) +
                          TOFILE(REPLOGL4))
             IF         COND(&ROPT = '5') THEN(OVRDBF FILE(REPLOGPD) +
                          TOFILE(REPLOGL5))
             IF         COND(&ROPT = '6') THEN(OVRDBF FILE(REPLOGPD) +
                          TOFILE(REPLOGL6))
             IF         COND(&ROPT = '7') THEN(OVRDBF FILE(REPLOGPD) +
                          TOFILE(REPLOGL7))
 
/**/
/* RETRIEVE SYSTEM VALUE DATE FORMAT */
/**/
             RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&DATFMT)
             CALL       PGM(RE4475) PARM(&RSEQ &RLEV &RENT &RMSG +
                          &ROPT &DATFMT)
 
             DLTOVR     FILE(REPLOGPD)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
ERROR:       IF         COND(%SWITCH(00000001)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR  VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             CHGJOB     SWS(00000011)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4475 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
 
