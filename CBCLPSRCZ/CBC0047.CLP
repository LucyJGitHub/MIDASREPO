/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB Halt modules maint calling program')     */
/*********************************************************************/
/*                                                                   */
/*        Midas - Close of Business Processing                       */
/*                                                                   */
/*       CBC0047 - Close of Business Halt for Modules Maintenance.   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 108076 *CREATE     DATE 18SEP96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       108076 - New program for this fix.                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMNAM &COMNUM &MODE &RTNCDE)
 
/*/COPY WNCPYSRC,CBC0047INT                                          */
 
             DCL        VAR(&COMNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,CBC0047MPS                                          */
 
/* Call halt request program */
 
             CALL       PGM(CB0047) PARM(&COMNAM &COMNUM &MODE &RTNCDE)
 
/*/COPY WNCPYSRC,CBC0047MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,CBC0047ERR                                          */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CBC0047 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 END:
/*/COPY WNCPYSRC,CBC0047END                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
