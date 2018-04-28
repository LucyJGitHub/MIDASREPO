/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Reset COB DQ Messages Status Data Area')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0122A - MIDAS GO RESET COB DQ MESSAGES STATUS DATA AREA  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9647 *CREATE    Date 19Dec05              */
/*       Prev Amend No. XXXXXX             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG9647- Syndications Manager Correspondence does not       */
/*                generate any correspondence during COB             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&EVENTTYPE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&EVENTTYPE) TYPE(*CHAR) LEN(24)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0122A - RESET COB DATA QUEUE MESSAGES +
                          FOR EVENT TYPE ' *CAT &EVENTTYPE) TOMSGQ(MRUNQ)
 
             CHGJOB SWS(00000000)
 
             CHGDTAARA  DTAARA(DQSTAT (1 1)) VALUE(' ')
             GOTO       CMDLBL(END)
 
/* error */
 ABNOR:      CHGJOB   SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOC0122A ' *CAT &EVENTTYPE +
                          *CAT ' ended abnormally - see job log') +
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
