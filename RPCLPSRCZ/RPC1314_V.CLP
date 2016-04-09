/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RPSTRSRV   validity checking program.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1314_V - Command RPSTRSRV validity checking program.     */
/*                                                                   */
/*       Function : this CLP program perform user-defined validity   */
/*                  checking on the parameters in command RPSTRSRV.  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 26May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amend non-standard codes.                         */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&InitQueue &CommitCtl)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&InitQueue) TYPE(*CHAR) LEN(48)
             DCL        VAR(&CommitCtl) TYPE(*CHAR) LEN(1)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Type)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&Sbs)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&User)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgid)     TYPE(*CHAR) LEN(256)
 
             DCL        VAR(&Rtcd)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&Optn)      TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&Iniq)      TYPE(*CHAR) LEN(48)
 
             DCL        VAR(&SrvQueue)  TYPE(*CHAR) LEN(48)
             DCL        VAR(&Error)     TYPE(*CHAR) LEN(1)    VALUE('N')
 
             DCL        VAR(&Msgdta)    TYPE(*CHAR) LEN(128) +
                 /* Message text sent to MRUNQ MOPERQ.  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Trigger Server Data Area File.                                   */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(QSYS/QADSPOBJ)
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Retrieve type of job environment:                                */
/*       - 0 indicates that the job is running as a batch job.       */
/*       - 1 indicates an interactive job.                           */
/*-------------------------------------------------------------------*/
 
             RTVJOBA    TYPE(&Type)
 
/*-------------------------------------------------------------------*/
/*  Set switches U7 and U8 off.                                      */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------------------------------------------*/
/*  Check that user is authorized to user profile MDBA associated    */
/*  with Replication job description.                                */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(KMDICI) PARM('SBSNAME' &Sbs)
             RTVJOBD    JOBD(&Sbs/&Sbs) USER(&User)
             RTVUSRPRF  USRPRF(&USER) RTNUSRPRF(&USER)
             MONMSG     MSGID(CPF2217) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*NO) MSG(&Msgdta)
                   CHGVAR  VAR(&Msgdta) VALUE('0000' *CAT &Msgdta)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Initiation Queue definition exists.                     */
/*-------------------------------------------------------------------*/
 
             DSPMQMQ    QNAME(&INITQUEUE) OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*DIAG) RMV(*NO) MSG(&Msgdta) +
                                MSGID(&Msgid)
                   IF COND(&Msgid = 'AMQ8147') THEN(DO)
                         CHGVAR  VAR(&Msgdta) VALUE('0000MQM object' *BCAT +
                                                    &InitQueue *TCAT ' does not exist.')
                         SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                      MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                   ENDDO
                   ELSE       CMD(DO)
                         SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                      MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                   ENDDO
                   CHGVAR     VAR(&Error) VALUE('Y')
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Initiation Queue has been defined in Control File.      */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Rtcd) VALUE(' ')
             CHGVAR     VAR(&Iniq) VALUE(&InitQueue)
             CALL       RP1331 (&Rtcd &Optn &Iniq)
/**********  IF         COND(&Rtcd *= ' ') THEN(DO)                   */ /*BG18886*/
             IF         COND(&Rtcd *NE ' ') THEN(DO)                     /*BG18886*/
                   IF         COND(&Error *EQ 'N') THEN(DO)
                         CHGVAR  VAR(&Msgdta) VALUE('0000Initiation Queue' *BCAT +
                                                    &InitQueue *TCAT ' does not exist +
                                                    in Control File RPINIQPD with +
                                                    Triggering Type "Q" (Queue)')
                         SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                     MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                         CHGVAR     VAR(&Error) VALUE('Y')
                   ENDDO
                   GOTO       CMDLBL(COMMITCTL)
             ENDDO
             IF         COND(&Error *NE 'N') THEN(DO)
                   CHGVAR     VAR(&Msgdta) VALUE('0000Unknown Initiation Queue' +
                                *BCAT &InitQueue *TCAT ' exists +
                                in Control File RPINIQPD')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(COMMITCTL)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Initiation Queue is being served by a Trigger Server.   */
/*-------------------------------------------------------------------*/
 
             IF         COND(&Type = '1') THEN(DO) +
                                                  /* Interactive job */
 
                   /*  Retrieve existing Trigger Server Data Areas.  */
                   DSPOBJD    OBJ(RPTRG*) OBJTYPE(*DTAARA) +
                                OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPOBJD)
                   MONMSG     MSGID(CPF2123) EXEC(GOTO CMDLBL(COMMITCTL))
 
                   OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/DSPOBJD)
 
 RCVF:             RCVF
                   MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(COMMITCTL))
 
                   IF         COND(&ODOBNM *EQ 'RPTRG ') THEN(GOTO CMDLBL(RCVF))
                   RTVDTAARA  DTAARA(&ODOBNM (1 48)) RTNVAR(&SrvQueue)
                   IF         COND(&SrvQueue *NE &InitQueue) THEN(GOTO CMDLBL(RCVF))
 
                   ALCOBJ     OBJ((&ODOBNM *DTAARA *EXCLRD)) WAIT(5)
                   MONMSG     MSGID(CPF1002 CPF1063) EXEC(DO)
                        CHGVAR     VAR(&Msgdta) VALUE('0000Initiation Queue' *BCAT +
                                     &InitQueue *TCAT ' is being served by +
                                     Trigger Server RPTRGSRV' *CAT %SST(&ODOBNM 6 2))
                        SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                     MSGTYPE(*DIAG)
                        CHGVAR     VAR(&Error) VALUE('Y')
                   ENDDO
                   DLCOBJ     OBJ((&ODOBNM *DTAARA *EXCLRD))
                   MONMSG     MSGID(CPF0000)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Commitment Indicator value is correct.                  */
/*-------------------------------------------------------------------*/
 
COMMITCTL:   IF         COND((&CommitCtl *NE 'N') +
                        *AND (&CommitCtl *NE 'Y')) THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Valid values for Commitment +
                                              Indicator are ''N'' and ''Y''.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/*--------------------------------------------------------------------*/
/*  Abnormal Termination.                                             */
/*--------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(&Type = '0') THEN(DO)
                   CHGVAR     VAR(&MSGDTA) +
                                VALUE('RPC1314_V - Command RPENDSRV validity checking +
                                       program - ended abnormally. See job log')
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             ELSE       CMD(DO)
                   CHGVAR     VAR(&MSGDTA) +
                                VALUE('0000Validity checking program +
                                       - ended abnormally. See job log.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                 MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             DLTOVR     FILE(QADSPOBJ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND((&ERROR = 'Y') *OR %SWITCH(XXXXXX11)) THEN(DO)
                   SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
