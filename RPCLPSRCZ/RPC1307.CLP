/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Start Midas/TOF Background Jobs.')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1307 - Start Midas/TOF interface background jobs.        */
/*                                                                   */
/*       Function:  This program starts the various background jobs  */
/*                  required by Midas/TOF interface.                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&MrdRepSbs)  TYPE(*CHAR) LEN(10) +
                 /* Replication Subsystem Name. */
             DCL        VAR(&Msgid)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&Msg)        TYPE(*CHAR) LEN(256)
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128)
             DCL        VAR(&MSGKEY)     TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Start Midas/TOF Interface MQSeries Channels.                     */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(RPC1308) PARM('*ALL' '*ALL')
 
/*-------------------------------------------------------------------*/
/*  Start Midas/TOF interface MQSeries Channel Initiators.           */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(RPC1315) PARM('*ALL')
 
/*-------------------------------------------------------------------*/
/*  Start Midas/TOF interface MQSeries Triggering.                   */
/*-------------------------------------------------------------------*/
 
             RPSTRTRG
             MONMSG     MSGID(CPF0001) EXEC(DO) +
                          /* Error found on RPSTRTRG command. */
 
                   RCVMSG     MSGTYPE(*LAST) RMV(*NO) KEYVAR(&Msgkey)
                   RCVMSG     MSGTYPE(*PRV) MSGKEY(&Msgkey) RMV(*YES) +
                                MSG(&Msg)
                   CHGVAR     VAR(&Msgdta) VALUE('Midas/TOF interface MQSeries +
                                                 Triggering start failed. +
                                                 Reason was "' *CAT &MSG *TCAT '"')
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                                TOMSGQ(MOPERQ)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Start Midas/TOF Interface Replication Subsystem.                 */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(KMDSBS) RTNVAR(&MrdRepSbs)
             STRSBS     SBSD(&MrdRepSbs)
             MONMSG     MSGID(CPF1010) EXEC(GOTO CMDLBL(ENDPGM))  +
                          /* Subsystem already active. */
 
             RCVMSG     MSGTYPE(*LAST) RMV(*NO) MSGDTA(&Msgdta) +
                          MSGID(&Msgid)
 
             /*  Replication Subsystem being started.                */
             IF  COND(&Msgid = 'CPF0902') THEN(DO)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                TOMSGQ(MRUNQ)
             ENDDO
             ELSE       CMD(DO)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&MSGDTA) +
                          VALUE('RPC1307 - Start Midas/TOF interface Backgroung Jobs +
                                 - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
 
