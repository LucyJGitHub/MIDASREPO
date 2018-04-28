/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Run Midas/TOF MQseries Trigger Server.')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1311 - Run Midas/TOF MQseries Trigger Server.            */
/*                                                                   */
/*       Function : this CLP program calls Meridian standard trigger */
/*                  server RPTRGMON that will serve initiation queue */
/*                  passed as parameter. That means it will retrieve */
/*                  all messages from the initiation queue and start */
/*                  up the application program that was specified in */
/*                  the trigger message. The application ID is       */
/*                  defined by a MQM process which has been          */
/*                  specified in the transmission queue definition.  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 212012             Date 12Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       212012 - Complete Nostro Correspondent details              */
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
 
             DCL        VAR(&JobName)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&Sbs)       TYPE(*CHAR) LEN(2)
             DCL        VAR(&Dtaara)    TYPE(*CHAR) LEN(10) +
                 /* Trigger Server Data Area.  */
 
             DCL        VAR(&Group)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&User)      TYPE(*CHAR) LEN(25)
             DCL        VAR(&Slevel)    TYPE(*DEC)  LEN(4)
             DCL        VAR(&Timeo)     TYPE(*DEC)  LEN(5)
             DCL        VAR(&Mult)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&Errorc)    TYPE(*DEC)  LEN(1)  VALUE(0)
 
             DCL        VAR(&Miusrmsg)  TYPE(*CHAR) LEN(10)
                 /* Message file for errors in Access Objects.  */
             DCL        VAR(&Ftusrmsg)  TYPE(*CHAR) LEN(10)                         /* 212012 */
                 /* Message file for errors in Access Objects.  */                  /* 212012 */
             DCL        VAR(&Midas)     TYPE(*CHAR) LEN(10)
                 /* Midas SD General Midas messages.  */
             DCL        VAR(&Pbusrmsg)  TYPE(*CHAR) LEN(10)
                 /* Midas PB User Messages.  */
 
             DCL        VAR(&DtaaraLib) TYPE(*CHAR) LEN(10) +
                 /* Trigger Server Data Area Library Name.  */
 
             DCL        VAR(&Msgdta)    TYPE(*CHAR) LEN(256) +
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
/*  Retrieve Job Name.                                               */
/*-------------------------------------------------------------------*/
 
             RTVJOBA    JOB(&JobName)
 
/*-------------------------------------------------------------------*/
/*  Retrieve Midas System Id.                                        */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
 
/*-------------------------------------------------------------------*/
/*  Allocate Data Area to show that the Trigger Server is active.    */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Dtaara) VALUE('RPTRG' *CAT %SST(&JobName 9 2))
             ALCOBJ     OBJ((&Dtaara *DTAARA *EXCLRD)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ENDPGM))
 
/*-------------------------------------------------------------------*/
/*  Send running program message.                                    */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Msgdta) VALUE(&JobName *TCAT '- Start Trigger Server +
                          program that serves Initiation Queue' *BCAT &InitQueue)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Initial processing for user defined language.                    */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)
 
             IF         COND(&MULT *EQ '  ') THEN(DO)
                   CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Override Message Files.                                          */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Miusrmsg) VALUE(&Mult *CAT 'MIUSRMSG  ')
             CHGVAR     VAR(&Midas)    VALUE(&Mult *CAT 'MIDAS     ')
             CHGVAR     VAR(&Pbusrmsg) VALUE(&Mult *CAT 'PBUSRMSG  ')
             CHGVAR     VAR(&Ftusrmsg) VALUE(&Mult *CAT 'FTUSRMSG  ')               /* 212012 */
             OVRMSGF    MSGF(Miusrmsg) TOMSGF(&Miusrmsg)
             OVRMSGF    MSGF(Midas)    TOMSGF(&Midas)
             OVRMSGF    MSGF(Pbusrmsg) TOMSGF(&Pbusrmsg)
             OVRMSGF    MSGF(Ftusrmsg) TOMSGF(&Ftusrmsg)                            /* 212012 */
 
/*-------------------------------------------------------------------*/
/*  Start the Trigger Server.                                        */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&DtaaraLib) VALUE('*LIBL')
             CALL       PGM(RPTRGMON) PARM(&DtaaraLib &Dtaara)
 
/*-------------------------------------------------------------------*/
/*  Deallocate Data Area to show that the Trigger Server is no       */
/*  longer active.                                                   */
/*-------------------------------------------------------------------*/
 
             DLCOBJ     OBJ((&Dtaara *DTAARA *EXCLRD))
 
/*-------------------------------------------------------------------*/
/*  Delete Trigger Data Area.                                        */
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
 
             CHGVAR     VAR(&Msgdta) VALUE(&JobName *TCAT ' - Run Trigger +
                          Server program that serves Initiation Queue' +
                          *BCAT &InitQueue *TCAT ' - ended abnormally. +
                          See job log')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
