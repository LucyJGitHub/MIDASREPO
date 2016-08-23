/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB Start Midas/TOF MQSeries channels')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1308 - Start Midas/TOF Interface MQSeries Channels       */
/*                                                                   */
/*       Function: this CLP program starts MQM channels between      */
/*                 Midas and TOF, that satisfy required selection    */
/*                 queue manager name/channel name.                  */
/*                 It first verifies the TCP/IP connection between   */
/*                 the AS/400 and the remote system.                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 204726             Date 09Jul02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       204726 - Manage Remote MQM <> Remote Machine name           */
/*                Workaround = supress test / remote MQ Manager      */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QueueMgr &Channel)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&QueueMgr)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&Channel)    TYPE(*CHAR) LEN(20)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Qryslt)     TYPE(*CHAR) LEN(128)
             DCL        VAR(&Qmgr)       TYPE(*CHAR) LEN(20)
             DCL        VAR(&Connect)    TYPE(*CHAR) LEN(1)
 
/**********  DCL        VAR(&NbrConnVer) TYPE(*DEC)  LEN(7 0)                          */ /*204726*/
             DCL        VAR(&Msgid)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&Msgf)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128)
             DCL        VAR(&Msgkey)     TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Midas/TOF Channels File declaration.                             */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(RPCHNLL2) RCDFMT(RPCHNLD0)
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Select channels that satisfy required selection.                 */
/*-------------------------------------------------------------------*/
 
             IF         COND((&QueueMgr = '*ALL') *AND (&Channel = '*ALL')) +
                   THEN(GOTO CMDLBL(RCVF))
 
             IF         COND(&QueueMgr = '*ALL') THEN(DO)
                   CHGVAR     VAR(&Qryslt) VALUE('CHCHLN *EQ %WLDCRD(''' *CAT +
                                                  &Channel *TCAT ''')')
                   GOTO       CMDLBL(OPNQRYF)
             ENDDO
 
             IF         COND(&Channel = '*ALL') THEN(DO)
                   CHGVAR     VAR(&Qryslt) VALUE('CHQMGR *EQ %WLDCRD(''' *CAT +
                                                  &QueueMgr *TCAT ''')')
                   GOTO       CMDLBL(OPNQRYF)
             ENDDO
 
             CHGVAR     VAR(&Qryslt) VALUE('(CHQMGR *EQ %WLDCRD(''' *CAT &QueueMgr +
                                            *TCAT ''')) *AND (CHCHLN *EQ %WLDCRD(''' +
                                            *CAT &Channel *TCAT '''))')
OPNQRYF:
             OPNQRYF    FILE((RPCHNLL2)) QRYSLT(&Qryslt)
 
/*-------------------------------------------------------------------*/
/*  Process selected channels.                                       */
/*-------------------------------------------------------------------*/
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
/*-------------------------------------------------------------------*/
/*  Check host connections.                                          */
/*-------------------------------------------------------------------*/
 
/**********  IF COND((&CHQMGR *EQ &Qmgr) *AND (&Connect = 'N')) THEN(GOTO CMDLBL(RCVF))*/ /*204726*/
/**********                                                                            */ /*204726*/
/**********  IF COND(&CHQMGR *NE &Qmgr) THEN(DO)                                       */ /*204726*/
/**********        CHGVAR     VAR(&Connect) VALUE('Y')                                 */ /*204726*/
/**********        CHGVAR     VAR(&Qmgr)   VALUE(&CHQMGR)                              */ /*204726*/
/**********        VFYTCPCNN  RMTSYS(&CHQMGR)                                          */ /*204726*/
/**********        MONMSG     MSGID(TCP0000)                                           */ /*204726*/
/**********        RCVMSG     MSGTYPE(*LAST) RMV(*YES) MSGDTA(&Msgdta) +               */ /*204726*/
/**********                     MSGID(&Msgid) MSGF(&Msgf)                              */ /*204726*/
/**********        IF COND(&Msgid = 'TCP3210') THEN(DO)                                */ /*204726*/
/**********           CHGVAR     VAR(&NbrConnVer) +                                    */ /*204726*/
/**********                      VALUE(%BINARY(&Msgdta 1 4))                           */ /*204726*/
/**********           IF COND(&NbrConnVer ¬= 5) THEN(DO)                               */ /*204726*/
/**********              CHGVAR     VAR(&Msgdta) VALUE('The remote host system' *BCAT +*/ /*204726*/
/**********                          &Qmgr *TCAT ' did not respond before the request +*/ /*204726*/
/**********                          time-out ended')                                  */ /*204726*/
/**********              SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +     */ /*204726*/
/**********                           TOMSGQ(MOPERQ)                                   */ /*204726*/
/**********              CHGVAR     VAR(&Connect)  VALUE('N')                          */ /*204726*/
/**********              GOTO       CMDLBL(RCVF)                                       */ /*204726*/
/**********           ENDDO                                                            */ /*204726*/
/**********           ELSE (DO)                                                        */ /*204726*/
/**********              SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +        */ /*204726*/
/**********                           TOMSGQ(MOPERQ)                                   */ /*204726*/
/**********           ENDDO                                                            */ /*204726*/
/**********        ENDDO                                                               */ /*204726*/
/**********        IF COND(&Msgid ¬= 'TCP3210') THEN(DO)                               */ /*204726*/
/**********              SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +        */ /*204726*/
/**********                           TOMSGQ(MOPERQ)                                   */ /*204726*/
/**********              CHGVAR     VAR(&Connect)  VALUE('N')                          */ /*204726*/
/**********              GOTO       CMDLBL(RCVF)                                       */ /*204726*/
/**********        ENDDO                                                               */ /*204726*/
/**********  ENDDO                                                                     */ /*204726*/
 
/*-------------------------------------------------------------------*/
/*  Test the channel by sending data, as a special message, to       */
/*  the remote message queue manager, only for sender or server      */
/*  channel types.                                                   */
/*-------------------------------------------------------------------*/
 
             IF COND((&CHCHLT = '*SDR') *OR (&CHCHLT = '*SVR')) THEN(DO)
             PNGMQMCHL  CHLNAME(&CHCHLN)
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*NO) KEYVAR(&Msgkey)
                   RCVMSG     MSGTYPE(*PRV) MSGKEY(&Msgkey) RMV(*NO) +
                                KEYVAR(&Msgkey) MSGDTA(&Msgdta) +
                                MSGID(&Msgid) MSGF(&Msgf)
 
/*-------------------------------------------------------------------*/
/*  The channel is currently active.                                 */
/*-------------------------------------------------------------------*/
 
                   IF  COND(&Msgid = 'AMQ9514') THEN(GOTO CMDLBL(RCVF))
 
/*-------------------------------------------------------------------*/
/*  The listening program is not running at host.                    */
/*-------------------------------------------------------------------*/
 
                   IF  COND(&Msgid = 'AMQ9202') THEN(DO)
                         CHGVAR     VAR(&Msgdta) VALUE('Connection with host' +
                                      *BCAT &Qmgr *TCAT ' was established, but +
                                      listening program at host was not running')
                         SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                      TOMSGQ(MOPERQ)
                         CHGVAR     VAR(&Connect)  VALUE('N')
                         GOTO       CMDLBL(RCVF)
                   ENDDO
 
/*-------------------------------------------------------------------*/
/*  An error occurred while testing the channel.                     */
/*-------------------------------------------------------------------*/
 
                   RMVMSG     MSGKEY(&Msgkey)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(RCVF)
             ENDDO
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Start channel.                                                   */
/*-------------------------------------------------------------------*/
 
             STRMQMCHL  CHLNAME(&CHCHLN)
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*NO) KEYVAR(&Msgkey)
                   RCVMSG     MSGTYPE(*PRV) MSGKEY(&Msgkey) RMV(*NO) +
                                KEYVAR(&Msgkey) MSGDTA(&Msgdta) +
                                MSGID(&Msgid) MSGF(&Msgf)
 
/*-------------------------------------------------------------------*/
/*  The channel is currently active.                                 */
/*-------------------------------------------------------------------*/
 
                   IF  COND(&Msgid = 'AMQ9514') THEN(GOTO CMDLBL(RCVF))
 
/*-------------------------------------------------------------------*/
/*  An error occurred while starting the channel.                    */
/*-------------------------------------------------------------------*/
 
                   RMVMSG     MSGKEY(&Msgkey)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(RCVF)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Start MQM channel has been accepted.                             */
/*-------------------------------------------------------------------*/
 
             RCVMSG     MSGTYPE(*LAST) RMV(*NO) MSGID(&Msgid)
             IF         COND(&Msgid = 'AMQ8018') THEN(DO)
                   CHGVAR     VAR(&Msgdta) VALUE('Start channel function +
                                has been initiated for channel' *BCAT +
                                &CHCHLN)
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                TOMSGQ(MRUNQ)
                   GOTO       CMDLBL(RCVF)
             ENDDO
 
             GOTO       CMDLBL(RCVF)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&MSGDTA) +
                          VALUE('RPC1308 - Start Midas/TOF Interface MQSeries +
                                 Channels - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             CLOF       OPNID(RPCHNLL2)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
