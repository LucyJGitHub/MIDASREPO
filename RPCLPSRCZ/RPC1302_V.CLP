/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RPENDSRV   validity checking program.')   */
/*OVR    OVRDBF FILE(DSPOBJD) TOFILE(QSYS/QADSPOBJ)                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1302_V  - Command RPENDSRV validity checking program.    */
/*                                                                   */
/*       Function : this CLP program perform user-defined validity   */
/*                  checking on the parameters in command RPENDSRV.  */
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
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&InitQueue) TYPE(*CHAR) LEN(48)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Type)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&Msg)       TYPE(*CHAR) LEN(128)
             DCL        VAR(&Msgid)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&Qryslt)    TYPE(*CHAR) LEN(128)
             DCL        VAR(&Dtaara)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SrvQueue)  TYPE(*CHAR) LEN(48)
             DCL        VAR(&Error)     TYPE(*CHAR) LEN(1)    VALUE('N')
             DCL        VAR(&Sbs)       TYPE(*CHAR) LEN(2)
             DCL        VAR(&Dplib)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&Text)      TYPE(*CHAR) LEN(50)
 
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
/*  Check if Initiation Queue definition exists.                     */
/*-------------------------------------------------------------------*/
 
             DSPMQMQ    QNAME(&InitQueue) OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*DIAG) RMV(*NO) MSG(&MSG) +
                               MSGID(&MSGID)
                   IF COND(&Msgid = 'AMQ8147') THEN(DO)
                         CHGVAR  VAR(&Msg) VALUE('0000MQM object' *BCAT +
                                                    &InitQueue *TCAT ' does not exist.')
                         SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                      MSGDTA(&Msg) MSGTYPE(*DIAG)
                   ENDDO
                   ELSE       CMD(DO)
                         IF COND(&Msgid = 'AMQ8135') THEN(DO)
                               CHGVAR  VAR(&Msg) VALUE('0000You are not authorized to the +
                                                       MQM object' *BCAT &InitQueue *TCAT '.')
                               SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                            MSGDTA(&Msg) MSGTYPE(*DIAG)
                         ENDDO
                         ELSE       CMD(DO)
                               SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                      MSGDTA('0000' *CAT &Msg) MSGTYPE(*DIAG)
                         ENDDO
                   ENDDO
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Initiation Queue has been defined in Control File.      */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Qryslt) VALUE('(ININIQ *EQ ''' *CAT +
                                            &INITQUEUE *CAT ''')')
             OPNQRYF    FILE((RPINIQL2)) QRYSLT(&Qryslt)
             RCVMSG     MSGTYPE(*LAST) MSGID(&Msgid)
             IF         COND(&Msgid = 'CPC2957') THEN(DO)
                   IF         COND(&Error *EQ 'N') THEN(DO)
                         CHGVAR  VAR(&Msg) VALUE('0000Initiation Queue' *BCAT +
                                                  &InitQueue *TCAT ' does not exist +
                                                  in Control File RPINIQPD')
                         SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                     MSGDTA(&Msg) MSGTYPE(*DIAG)
                         CHGVAR     VAR(&Error) VALUE('Y')
                   ENDDO
                   GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Initiation Queue is being served by a Trigger Server.   */
/*-------------------------------------------------------------------*/
 
             IF         COND(&Type = '1') THEN(DO) +
                                                  /* Interactive job */
 
                   /*  Retrieve existing Trigger Server Data Areas.  */
                   DSPOBJD    OBJ(RPTRG*) OBJTYPE(*DTAARA) +
                                OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPOBJD)
                   OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/DSPOBJD)
 
 RCVF:             RCVF
                   MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(NOTSERVED))
 
                   IF         COND(&ODOBNM *EQ 'RPTRG ') THEN(GOTO CMDLBL(RCVF))
                   RTVDTAARA  DTAARA(&ODOBNM (1 48)) RTNVAR(&SrvQueue)
                   IF         COND(&SrvQueue *NE &InitQueue) THEN(GOTO CMDLBL(RCVF))
 
                   ALCOBJ     OBJ((&ODOBNM *DTAARA *EXCLRD)) WAIT(5)
                   MONMSG     MSGID(CPF1002 CPF1063) EXEC(DO)
 
                        /* Create End of Trigger Server Data Area if it does */
                        /* not already exists.                               */
                        CHGVAR     VAR(&Dtaara) VALUE('RPENDTRG')
                        CHGVAR     VAR(&Text)   VALUE('Midas PB End of Meridian +
                                                      Triggering Data Area.')
                        RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
                        CHGVAR     VAR(&DpLib)     VALUE(&SBS *TCAT 'DPLIB')
                        CRTDTAARA  DTAARA(&Dplib/&Dtaara) TYPE(*CHAR) LEN(2) +
                                     VALUE(%SST(&ODOBNM 6 2)) TEXT(&TEXT)
                        MONMSG     MSGID(CPF1023)
ALCOBJ:                 ALCOBJ     OBJ((&DTAARA *DTAARA *EXCLRD)) WAIT(10)
                        MONMSG     MSGID(CPF1002 CPF1063) EXEC(GOTO CMDLBL(ALCOBJ))
                        CHGDTAARA  DTAARA(&Dplib/&Dtaara) VALUE(%SST(&ODOBNM 6 2))
                        GOTO       CMDLBL(ENDPGM)
                   ENDDO
 
                   DLCOBJ     OBJ((&ODOBNM *DTAARA *EXCLRD))
NOTSERVED:         CHGVAR     VAR(&Msgdta) VALUE('0000Initiation Queue' *BCAT +
                                &InitQueue *TCAT ' is not being served by a +
                                Trigger Server program.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                MSGTYPE(*DIAG)
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
                                VALUE('RPC1302_V - Command RPENDSRV validity checking +
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
 
             CLOF       OPNID(RPINIQL2)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DLTSPLF    FILE(QSYSPRT) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3303 CPF3309)
 
             IF         COND((&ERROR = 'Y') *OR %SWITCH(XXXXXX11)) THEN(DO)
                   SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
