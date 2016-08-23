/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB start replication feeder job Mxx1FEED1')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1309 - Start Replication Feeder job(s) Mxx1FEEDn.        */
/*                                                                   */
/*       Function:    This CLP program will start Feeder job(s)      */
/*                 Mxx1FEEDn that runs in Replication subsystem and  */
/*                 extracts data from the journal to place complete  */
/*                 record images onto appropriate MQSeries queue.    */
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
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Sbs)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&RepSbsLib) TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgdta)   TYPE(*CHAR) LEN(128)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Send Notify Message to Message Queue MRUNQ.                      */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPC1309 - Start Replication Feeder job M' +
                                *CAT &Sbs *CAT '1FEED1')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Set off Job Switches.                                            */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------------------------------------------*/
/*  Start Feeder job.                                                */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(KMDJBC)
 
             RTVDTAARA  DTAARA(KMDSBS) RTNVAR(&RepSbsLib)
             ADDLIBLE   LIB(&REPSBSLIB) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(ENDPGM)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) VALUE('RPC1309 - Start Replication +
                            Feeder job M' *CAT &Sbs *CAT '1FEED1 ended +
                          abnormally. See job log')
 
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
