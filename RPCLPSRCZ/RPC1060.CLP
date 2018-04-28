/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Start replication channels')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication                                         */
/*                                                                   */
/*       RPC1060 - Start Midas-Plato Replication Channels.           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. CPL004  *CREATE    Date 08Nov00              */
/*       Prev Amend No. ______             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPL004 - Midas-Plato Interface.                             */
/*                Enhancements for Plato v4.80.                      */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*173248*/
             DCL        VAR(&UNIT) TYPE(*CHAR) LEN(3)                                     /*173248*/
             DCL        VAR(&MQCN) TYPE(*CHAR) LEN(20)                                    /*173248*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(X4PF)
 
/* Global Monitor Message                                        **/
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000) EXEC(GOTO +
                          CMDLBL(TAG998))
 
             SNDPGMMSG  MSG('RPC1060 Replication - Start Midas-Plato +
                          Replication Channels') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
             CHGJOB     SWS(XXXXXX00)
 
/*  Get Midas system prefix and construct the name of the         **/         /*173248*/
/*    Replication Unit.                                           **/         /*173248*/
                                                                              /*173248*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                    /*173248*/
             CHGVAR     VAR(&UNIT) VALUE(&PRFX *TCAT '1')                     /*173248*/
                                                                              /*173248*/
/* Process each valid Replication Sub-System                     **/
 
TAG001:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(TAG002))
             IF         COND((&X4PRDN *NE 'PLATO') *OR (&X4UNIT *NE +
                          &UNIT)) THEN(GOTO CMDLBL(TAG001))
 
/* Construct the name of the MQ Channel.                         **/
 
             CHGVAR     VAR(&MQCN) VALUE('REP.' *CAT &X4PRDN *TCAT +
                          '.' *CAT &X4DSMN)
 
/* Attempt to start the Channel.                                 **/
             STRMQMCHL  CHLNAME(&MQCN)
             MONMSG     MSGID(CPF0001)                           /* Error on Command  */
 
             GOTO       CMDLBL(TAG001)
 
TAG002:
             GOTO       CMDLBL(TAG999)
 
/* Error Processing:                                               */
/* Dump the program if error occurred in this program              */
 
TAG998:
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             SNDMSG     MSG('Job terminated - RPC1060 Replication - +
                          Start Midas-Plato Replication Channel - +
                          Ended in Error') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
 
/* End of Program:                                                 */
TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
