/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Start Midas/TOF MQseries Trig Server')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1314 - Start Midas/TOF MQseries Trigger Server.          */
/*                                                                   */
/*       Function : this CLP program allows to start a Trigger Server*/
/*                  to monitor a specific Initiation Queue.          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&InitQueue &CommitCtl)
 
/*-------------------------------------------------------------------*/
/*  Paramaters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&InitQueue) TYPE(*CHAR) LEN(48)
                 /* Initiation Queue the Trigger Server program serves. */
             DCL        VAR(&CommitCtl)  TYPE(*CHAR) LEN(1)
                 /* Commitment Control Indicator. */
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&DtaAraLib)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&Jobd)          TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobdLib)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&Jobq)          TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobqLib)       TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&SeqNumber) TYPE(*CHAR) LEN(2) +
                 /* Sequence Number of Trigger Server. */
             DCL        VAR(&NumDtaara) TYPE(*DEC)  LEN(2 0) +
                 /* Trigger Server Data Area Number. */
 
             DCL        VAR(&Dtaara)        TYPE(*CHAR) LEN(10) +
                 /* Name of Trigger Data Area. */
             DCL        VAR(&Text)          TYPE(*CHAR) LEN(50) +
                 /* Trigger Data Area Text Description. */
 
             DCL        VAR(&JobName)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&Rqsdta)        TYPE(*CHAR) LEN(128) +
                 /* Work field used to define command to be submitted.  */
             DCL        VAR(&Msgdta)    TYPE(*CHAR) LEN(256) +
                 /* Message text sent to MRUNQ MOPERQ.  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Set up common parameters, from values stored in Meridian         */
/*  Triggering Data Area RPTRG.                                      */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(RPTRG (1 10))  RTNVAR(&DtaAraLib)
             RTVDTAARA  DTAARA(RPTRG (11 10)) RTNVAR(&Jobd)
             RTVDTAARA  DTAARA(RPTRG (21 10)) RTNVAR(&JobdLib)
             RTVDTAARA  DTAARA(RPTRG (31 10)) RTNVAR(&Jobq)
             RTVDTAARA  DTAARA(RPTRG (41 10)) RTNVAR(&JobqLib)
 
/*-------------------------------------------------------------------*/
/*  Get next available Data Area Sequence Number.                    */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&SeqNumber) VALUE(' ')
             CHGVAR     VAR(&NumDtaara) VALUE(0)
 
 CHKDTAARA:  CHGVAR     VAR(&NumDtaAra) VALUE(&NumDtaara + 1)
             CHGVAR     VAR(&SeqNumber) VALUE(&NumDtaara)
             CHGVAR     VAR(&Dtaara)    VALUE('RPTRG' *CAT &SeqNumber)
 
/*-------------------------------------------------------------------*/
/*  Check the existence of the data area.                            */
/*-------------------------------------------------------------------*/
 
CHKOBJ:      CHKOBJ     OBJ(&DTAARA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                   CHGVAR     VAR(&Text)      VALUE('Midas PB Meridian Trigger +
                                                     Server' *BCAT &SeqNumber +
                                                     *TCAT ' Data Area.')
                   CRTDTAARA  DTAARA(&DtaAraLib/&Dtaara) TYPE(*CHAR) LEN(49) +
                                VALUE(&InitQueue *CAT &CommitCtl) TEXT(&Text)
                   GOTO       CMDLBL(JOBNAME)
             ENDDO
             GOTO       CMDLBL(CHKDTAARA)
 
/*-------------------------------------------------------------------*/
/*  Set up parameters for SBMJOB command.                            */
/*-------------------------------------------------------------------*/
 
JOBNAME:     CHGVAR     VAR(&Jobname)   VALUE('RPTRGSRV' *CAT &SeqNumber)
             CHGVAR     VAR(&RQSDTA) VALUE('RPTRGSRV  INITQUEUE(' *CAT +
                                            &InitQueue *CAT ') COMMITCTL(' +
                                            *CAT &CommitCtl *CAT ')')
/*-------------------------------------------------------------------*/
/*  Submit the Trigger Server.                                       */
/*-------------------------------------------------------------------*/
 
/************SBMJOB     JOB(&JobName) JOBD(&JobdLib/&Jobd) +                              /*CSC023*/
/************             JOBQ(&JobqLib/&Jobq) USER(*JOBD) +                              /*CSC023*/
/************             RQSDTA(&Rqsdta)                                                 /*CSC023*/
 
             SBMJOB     JOB(&JobName) JOBD(&JobdLib/&Jobd) +
                          JOBQ(&JobqLib/&Jobq) USER(*JOBD) +
                          RQSDTA(&Rqsdta) OUTQ(*JOBD)                                     /*CSC023*/
 
             GOTO       CMDLBL(ENDPGM)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             DLTDTAARA  DTAARA(&Dtaara)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPC1314 - Start Midas/TOF MQSeries Trigger +
                                 Server - ended abnormally. See job log')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
