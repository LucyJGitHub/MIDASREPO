/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Reset Management Limits Data Area')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0120A - MIDAS GO RESET MANAGEMENT LIMITS DATAARA         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG4074 *CREATE    Date 24AUG04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG4074 - GOC0120 not run correctly after Bypassed          */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0120A - RESET MANAGEMENT LIMITS +
                          DTAARA') TOMSGQ(MRUNQ)
 
             CHGJOB SWS(00000000)
 
             CHGDTAARA  DTAARA(MLSTAT (1 1)) VALUE(' ')
             GOTO       CMDLBL(END)
 
/* error */
 ABNOR:      CHGJOB   SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOC0120A ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
