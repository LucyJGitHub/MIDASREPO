/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Start Meridian Channel Initiators.')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPCSTRCHLI - Start Midas/TOF MQSeries Channel Initiators.   */
/*                                                                   */
/*       Function : this CLP program starts a channel initiator      */
/*                  process (Job AMQRIMNA user QMQM program          */
/*                  AMQRIMNA) for each Initiation Queue that         */
/*                  satisfies the required selection and that was    */
/*                  defined with Triggering Type "C" (Channel        */
/*                  Triggering). Initiation Queues should have       */
/*                  been specified in the definition of the          */
/*                  transmission queues associated with channels.    */
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
 
             DCL        VAR(&InitQueue)  TYPE(*CHAR) LEN(20)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Qryslt)     TYPE(*CHAR) LEN(128)
 
             DCL        VAR(&Msgid)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&Msgf)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128)
             DCL        VAR(&Msgkey)     TYPE(*CHAR) LEN(4)
 
             DCL        VAR(&ReasonCode) TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&Sbs)           TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(48)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*---------------------------------------*/
/*  Initiation Queues File declaration.  */
/*---------------------------------------*/
 
             DCLF       FILE(RPINIQL3) RCDFMT(RPINIQD0)
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Retrieve Midas System Id.                                        */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
 
/*-------------------------------------------------------------------*/
/*  Select initiation queues that satisfy required selection.        */
/*-------------------------------------------------------------------*/
 
             IF         COND(&InitQueue = '*ALL')  THEN(GOTO CMDLBL(RCVF))
 
             CHGVAR     VAR(&Qryslt) VALUE('ININIQ *EQ %WLDCRD(''' *CAT +
                                            &InitQueue *TCAT ''')')
             OPNQRYF    FILE((RPINIQL3)) QRYSLT(&Qryslt)
 
/*-------------------------------------------------------------------*/
/*  Process selected initiation queues.                              */
/*-------------------------------------------------------------------*/
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
             CHGVAR     VAR(&STRING)  VALUE(&ININIQ)
             CHGVAR     VAR(&STRLEN) VALUE(48)
             CHGVAR     VAR(&STRPOS) VALUE(1)
             CHGVAR     VAR(&PATTERN) VALUE('XX')
             CHGVAR     VAR(&PATLEN) VALUE(2)
             CHGVAR     VAR(&RESULT) VALUE(0)
 
             CALL       PGM(QCLSCAN) PARM(&STRING &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
 
                   /* Replace xx system name by Midas system name */
             IF         COND(&RESULT > 1) THEN(DO)
                   CHGVAR     VAR(%SST(&ININIQ &RESULT 2)) VALUE(&SBS)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Start MQM Channel Initiator.                                     */
/*-------------------------------------------------------------------*/
 
             STRMQMCHLI QNAME(&ININIQ)
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*NO) KEYVAR(&Msgkey)
                   RCVMSG     MSGTYPE(*PRV) MSGKEY(&Msgkey) RMV(*NO) +
                                KEYVAR(&Msgkey) MSGDTA(&Msgdta) +
                                MSGID(&Msgid) MSGF(&Msgf)
 
                   CHGVAR     VAR(&ReasonCode) +
                                VALUE(%BINARY(&Msgdta 1 4))
 
/*-------------------------------------------------------------------*/
/*  Initiation Queue is already in use.                              */
/*-------------------------------------------------------------------*/
 
                   IF         COND(&Msgid = 'AMQ9509' *AND &ReasonCode = 2042) +
                                THEN(GOTO CMDLBL(RCVF))
 
/*-------------------------------------------------------------------*/
/*  An error occurred while starting channel initiator.              */
/*-------------------------------------------------------------------*/
 
                   RMVMSG     MSGKEY(&Msgkey)
                   SNDPGMMSG  MSGID(&Msgid) MSGF(&Msgf) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(RCVF)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  MQM channel initiator has been started.                          */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Msgdta) VALUE(' The channel initiator +
                          for MQM queue' *BCAT &ININIQ *TCAT ' has been started')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ)
 
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
                          VALUE('RPCSTRCHLI - Start Meridian MQM Channel Initiators +
                                 - ended abnormally. See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&MSGDTA) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             DLTOVR     FILE(RPINIQL3)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CLOF       OPNID(RPINIQL3)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
