/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Notify Management Limits in CoB')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0120 - MIDAS GO NOTIFY MANAGEMENT LIMITS IN COB          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG4136            Date 02SEP04              */
/*       Prev Amend No. BUG3672 *CREATE    Date 16Jul04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG4136- Initialise the reply dataq to ensure the reply     */
/*                 message is for today COB                          */
/*       BUG3672- Notify Management Limits during COB                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
             DCL        VAR(&MLSTAT) TYPE(*CHAR) LEN(128)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                                /*BUG4136*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10) VALUE('  +
                          DPLIB')                                                        /*BUG4136*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                   /*BUG4136*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0120 - NOTIFY MANAGEMENT LIMITS +
                          IN COB') TOMSGQ(MRUNQ)
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                                   /*BUG4136*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                              /*BUG4136*/
             CHGVAR     VAR(%SUBSTRING(&LIB 1 2)) VALUE(&SYSID)                          /*BUG4136*/
             RTVDTAARA  DTAARA(MLSTAT) RTNVAR(&MLSTAT)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/* If it is restart and message already received by ML, then wait */
/* then wait for finished message from ML */
             IF         COND(%SST(&MLSTAT 1 1) *EQ 'Y') THEN(GOTO +
                          CMDLBL(CHKSTS))
                                                                                         /*BUG4136*/
             CALL       PGM(QCLRDTAQ) PARM('GOMLCOBRSP' &LIB)                            /*BUG4136*/
 
             CALL       PGM(GO000120)
/* error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOC0120 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             CHGDTAARA  DTAARA(MLSTAT (1 1)) VALUE('Y')
 CHKSTS:     CALL       PGM(GO000121)
/* error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOC0120 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(END)
             ENDDO
 
/* If no error then reset MLSTAT */
             CHGDTAARA  DTAARA(MLSTAT (1 1)) VALUE(' ')
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
