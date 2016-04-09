/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Stop Meridian Trigger Server.')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1302 - Stop Meridian Trigger Server                      */
/*                                                                   */
/*       Function : this CLP program puts a "SHUTDOWN" message on    */
/*                  the Initiation Queue, by using SNDMSGMQQ         */
/*                  command, to stop the Trigger Server.             */
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
             PGM        PARM(&InitQueue)
 
/*-------------------------------------------------------------------*/
/*  Paramaters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&InitQueue) TYPE(*CHAR) LEN(48)
                 /* Initiatiuon Queue the Trigger Server program serves.  */
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Type)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&JobName)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SeqNumber) TYPE(*CHAR) LEN(2) +
                 /* Sequence Number of Trigger Server. */
             DCL        VAR(&Dtaara)    TYPE(*CHAR) LEN(10) +
                 /* Trigger Server Data Area.  */
             DCL        VAR(&Sbs)       TYPE(*CHAR) LEN(2)
             DCL        VAR(&Dplib)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&Text)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&Msgdta)    TYPE(*CHAR) LEN(128) +
                 /* Message text sent to MRUNQ MOPERQ.  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*-------------------------------------------------------------------*/
/*  Send running program message.                                    */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Msgdta) VALUE('RPC1302 - Stop Trigger Server +
                          program that serves Initiation Queue' *BCAT &InitQueue)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ)
 
 
/*-------------------------------------------------------------------*/
/*  Retrieve type of job environment:                                */
/*       - 0 indicates that the job is running as a batch job.       */
/*       - 1 indicates an interactive job.                           */
/*-------------------------------------------------------------------*/
 
             RTVJOBA    TYPE(&Type)
 
/*-------------------------------------------------------------------*/
/*  Get number of Trigger Server to stop by retrieving value in      */
/*  End of Triggering Data Area (Interactive job) or by retrieving   */
/*  number of job name (Batch job).                                  */
/*-------------------------------------------------------------------*/
 
             IF         COND(&TYPE = '1') THEN(DO)
                   RTVDTAARA  DTAARA(RPENDTRG) RTNVAR(&SeqNumber)
                   DLCOBJ     OBJ((RPENDTRG *DTAARA *EXCLRD))
                   DLTDTAARA  DTAARA(*LIBL/RPENDTRG)
             ENDDO
             ELSE       CMD(DO)
                   RTVJOBA    JOB(&JobName)
                   CHGVAR     VAR(&SeqNumber) VALUE(%SST(&JobName 9 2))
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Create and allocate End of Trigger Server Data Area to avoid     */
/*  more than one "SHUTDOWN" message being put on the initiation     */
/*  queue.                                                           */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Dtaara) VALUE('RPENDTRG' *CAT &SeqNumber)
             CHGVAR     VAR(&Text) VALUE('Midas PB End of Trigger Server' +
                          *BCAT &SeqNumber *TCAT ' Data Area.')
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
             CHGVAR     VAR(&Dplib) VALUE(&Sbs *TCAT 'DPLIB')
             CRTDTAARA  DTAARA(&Dplib/&Dtaara) TYPE(*CHAR) LEN(1) +
                          TEXT(&TEXT)
             MONMSG     MSGID(CPF1023)
             ALCOBJ     OBJ((&Dtaara *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002 CPF1085) EXEC(GOTO CMDLBL(ENDPGM))
 
/*-------------------------------------------------------------------*/
/*  Put a "SHUTDOWN" message on the Initiation Queue.                */
/*-------------------------------------------------------------------*/
 
             SNDMSGMQQ  QUEUE(&INITQUEUE)
 
/*-------------------------------------------------------------------*/
/*  Delete Dummy Data Area.                                          */
/*-------------------------------------------------------------------*/
 
             DLTDTAARA  DTAARA(&Dtaara)
 
             GOTO       CMDLBL(ENDPGM)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) VALUE('RPC1302 - Stop Trigger +
                          Server program that serves Initiation Queue' +
                          *BCAT &InitQueue *TCAT ' - ended abnormally. +
                          See job log')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
