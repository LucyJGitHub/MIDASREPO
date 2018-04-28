/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Stop Meridian Triggering.')               */
/*OVR    OVRDBF FILE(DSPOBJD) TOFILE(QSYS/QADSPOBJ)                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1303 - Stop Meridian Triggering                          */
/*                                                                   */
/*       Function : this CLP program submits putting of "SHUTDOWN"   */
/*                  message on Initiation Queues so that Trigger     */
/*                  Servers that serve them would end.               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Sbs)       TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&DtaAraLib) TYPE(*CHAR) LEN(10)
             DCL        VAR(&Jobd)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobdLib)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&Jobq)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobqLib)   TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&Jobname)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&InitQueue) TYPE(*CHAR) LEN(48)
             DCL        VAR(&Dtaara)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&Text)      TYPE(*CHAR) LEN(50)
             DCL        VAR(&Rqsdta)    TYPE(*CHAR) LEN(128) +
                 /* CL program to be run.  */
 
             DCL        VAR(&Msgdta)    TYPE(*CHAR) LEN(128) +
                 /* Message text sent to MRUNQ MOPERQ.  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Trigger Server Data Area File.                                   */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(DSPOBJD)
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Allocate General Trigger Data Area to avoid more than one        */
/*  program running at the same time.                                */
/*-------------------------------------------------------------------*/
 
             ALCOBJ     OBJ((RPTRG *DTAARA *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ENDPGM))
 
/*-------------------------------------------------------------------*/
/*  Retrieve Midas System Id.                                        */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
 
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
/*  Retrieve existing Trigger Server Data Area.                      */
/*-------------------------------------------------------------------*/
 
             DSPOBJD    OBJ(RPTRG*) OBJTYPE(*DTAARA) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPOBJD)
             OVRDBF     FILE(DSPOBJD) TOFILE(QTEMP/DSPOBJD)
 
/*-------------------------------------------------------------------*/
/*  Only process Data Area being served by a Trigger Server program. */
/*-------------------------------------------------------------------*/
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
 
             /* Allocate the Trigger Server data area to determine   */
             /* if the Trigger Server is still active.               */
 
             ALCOBJ     OBJ((&ODOBNM *DTAARA *EXCLRD)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(DO)
 
                  /* Set up parameters for SBMJOB command.           */
                  CHGVAR     VAR(&JobName) VALUE('RPENDSRV' *CAT %SST(&ODOBNM 6 2))
                  RTVDTAARA  DTAARA(&ODOBNM (1 48)) RTNVAR(&InitQueue)
                  CHGVAR     VAR(&Rqsdta) VALUE('RPENDSRV INITQUEUE(' +
                                *CAT &InitQueue *CAT ')')
 
                  /* Submit end of Trigger Server.                   */
/************     SBMJOB     JOB(&JobName) JOBD(&Jobd) +                                  /*CSC023*/
/************                  JOBQ(&JobqLib/&Jobq) USER(*JOBD) +                         /*CSC023*/
/************                  RQSDTA(&Rqsdta) INLLIBL(*JOBD)                             /*CSC023*/
                  SBMJOB     JOB(&JobName) JOBD(&Jobd) +
                               JOBQ(&JobqLib/&Jobq) USER(*JOBD) +
                               RQSDTA(&Rqsdta) INLLIBL(*JOBD) OUTQ(*JOBD)                 /*CSC023*/
                  GOTO       CMDLBL(RCVF)
 
             ENDDO
 
             DLCOBJ     OBJ((&ODOBNM *DTAARA *EXCLRD))
             GOTO       CMDLBL(RCVF)
 
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPC1303 - Stop Meridian Triggering +
                                 - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             DLCOBJ     OBJ((RPTRG *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
