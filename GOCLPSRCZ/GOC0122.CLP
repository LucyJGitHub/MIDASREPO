/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Process Data Queue messages in COB')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0122 - MIDAS GO PROCESS DATA QUEUE MESSAGES IN COB       */
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
 
             DCL        VAR(&CPYFLD)    TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&EVENTTYPE) TYPE(*CHAR) LEN(24)
             DCL        VAR(&DQSTAT)    TYPE(*CHAR) LEN(128)
             DCL        VAR(&SDSTAT)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&LIB)       TYPE(*CHAR) LEN(10) VALUE('  +
                          DPLIB')
             DCL        VAR(&SYSID)     TYPE(*CHAR) LEN(2)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0122 - PROCESS DATA QUEUE MESSAGES +
                          FOR EVENT TYPE ' *CAT &EVENTTYPE) TOMSGQ(MRUNQ)
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&LIB 1 2)) VALUE(&SYSID)
             RTVDTAARA  DTAARA(DQSTAT) RTNVAR(&DQSTAT)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(00000000)
 
/* If it is a restart and message already received, */
/* then wait for finished message */
             IF         COND(%SST(&DQSTAT 1 1) *EQ 'Y') THEN(GOTO +
                          CMDLBL(CHKSTS))
 
             CALL       PGM(QCLRDTAQ) PARM('GOMLCOBRSP' &LIB)
 
             CALL       PGM(GO000122) PARM(&EVENTTYPE)
/* error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                               GOC0120 ' *CAT &EVENTTYPE +
                               *CAT ' ended abnormally - see job log') +
                               TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
             ENDDO
 
             CHGDTAARA  DTAARA(DQSTAT (1 1)) VALUE('Y')
 
 CHKSTS:     CALL       PGM(GO000123)
/* error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                               GOC0120 ' *CAT &EVENTTYPE +
                               *CAT ' ended abnormally - see job log') +
                               TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
             ENDDO
 
/* If no error then reset DQSTAT */
             CHGDTAARA  DTAARA(DQSTAT (1 1)) VALUE(' ')
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd.')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
