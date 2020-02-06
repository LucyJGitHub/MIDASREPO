/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RPSETMQMO  validity checking program.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1306_V - Command RPSETMQMO validity checking program.    */
/*                                                                   */
/*       Function : this CLP program performs additional validity    */
/*                  checking on the parameters in command RPSETMQMO. */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PC_Id &Replace)
 
/*-------------------------------------------------------------------*/
/*  Paramaters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&PC_Id)    TYPE(*CHAR) LEN(4)
                 /* PC Identification Code.  */
             DCL        VAR(&Replace)  TYPE(*CHAR) LEN(4)
                 /* Replace MQM objects.  */
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Keyvar)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&key)      TYPE(*dec)  LEN(5 0)
             DCL        VAR(&Msgkey)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&Msgid)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&Msgf)     TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&Qryslt)   TYPE(*CHAR) LEN(128)
             DCL        VAR(&Exist)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&Activ)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&Msgdta)   TYPE(*CHAR) LEN(128) +
                 /* Message text sent to MRUNQ MOPERQ.  */
             DCL        VAR(&Error)    TYPE(*CHAR) LEN(1) +
                 /* Error indicator. */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  AS/400-PCs connection file.                                      */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(RPCONNL1) RCDFMT(RPCONND0)
 
/*-------------------------------------------------------------------*/
/*  Global monitor message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Set switches U7 and U8 off.                                      */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------------------------------------------*/
/*  Verify that user is authorized to perform requested operation,   */
/*  by running command that has restricted usage.                    */
/*-------------------------------------------------------------------*/
 
             STRMQM
 
/*-------------------------------------------------------------------*/
/*  Error found on STRMQM command.                                   */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*No) KEYVAR(&Keyvar)
                   CHGVAR     VAR(&Key) VALUE(%BINARY(&Keyvar))
                   CHGVAR     VAR(&Key) VALUE(&Key - 1)
                   CHGVAR     VAR(%BIN(&msgkey)) VALUE(&Key)
                   RCVMSG     MSGTYPE(*ANY) MSGKEY(&Msgkey) RMV(*NO) +
                                MSGDTA(&Msgdta) MSGID(&Msgid) MSGF(&Msgf)
 
/*-------------------------------------------------------------------*/
/*  User is not authorized to create MQM objects.                    */
/*-------------------------------------------------------------------*/
 
                   IF         COND(&Msgid = 'CPD0032') THEN(DO)
                         CHGVAR     VAR(&Msgdta) VALUE('0000You are not authorized to +
                                      create MQM objects.')
                         SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                     MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                         CHGVAR     VAR(&Error) VALUE('Y')
                         GOTO       CMDLBL(ERROR)
                   ENDDO
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Verify that PC Id. is no more than 2 characters.                 */
/*-------------------------------------------------------------------*/
 
CHKPCID:     IF COND(&PC_Id = '*ALL') THEN(GOTO CMDLBL(RCVF))
             IF COND(%SST(&PC_Id 3 2) *NE ' ') THEN(DO)
                   CHGVAR  VAR(&MSGDTA) VALUE('0000PC Id. must be only 2 characters.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ERROR)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Verify that connection between AS/400 and PC has been defined.   */
/*-------------------------------------------------------------------*/
 
             IF COND(%SST(&PC_Id 2 1) *EQ '*') THEN(DO)
                   CHGVAR     VAR(&Qryslt) VALUE('CNHSTI *EQ %WLDCRD(''' *CAT +
                                                  %SST(&PC_Id 1 1) *CAT '_'')')
             ENDDO
             ELSE       CMD(DO)
                   CHGVAR     VAR(&Qryslt) VALUE('(CNHSTI *EQ ''' *CAT +
                                                  &PC_id *CAT ''')')
             ENDDO
             OPNQRYF FILE((RPCONNL1)) QRYSLT(&qryslt)
 
             CHGVAR     VAR(&Exist) VALUE('N')
             CHGVAR     VAR(&Activ) VALUE('N')
 
RCVF:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(SNDMSG))
 
             CHGVAR     VAR(&EXIST) VALUE('Y')
             IF         COND(&CNACTI *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&ACTIV) VALUE('Y')
             ENDDO
 
             GOTO       CMDLBL(RCVF)
 
SNDMSG:
             IF         COND(&EXIST *NE 'Y') THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000No Connection definition exists +
                                               for remote system "' *CAT &PC_Id *TCAT '".')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ERROR)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Verify that connection definition is active.                     */
/*-------------------------------------------------------------------*/
 
             IF         COND(&ACTIV *NE 'Y') THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000No Connection definition for remote +
                                               system "' *CAT &PC_Id *TCAT '" is active.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
             ENDDO
 
ERROR:
             GOTO       CMDLBL(ENDPGM)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) +
                          VALUE('RPKSETMQMO - Command RPSETMQMO validity checking +
                                 program ended abnormally - See job log')
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CLOF       OPNID(RPCONNL1)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             IF         COND((&ERROR = 'Y') *OR %SWITCH(XXXXXX11)) THEN(DO)
                   SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             ENDPGM
