/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB Run Command.')                            */
/*OVR    OVRDBF FILE(DSPOBJD) TOFILE(QSYS/QADSPOBJ)                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1312 - Execute command passed as parameter.              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 26May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&ReturnCode &Command &LengthAlp +
                             &Msgid &Msgdta &Msgf &Msgflib)
 
/*-------------------------------------------------------------------*/
/* Declaration of parameters.                                        */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&ReturnCode) TYPE(*CHAR) LEN(2)
             DCL        VAR(&Command)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&LengthAlp)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&Msgid)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&RtnType)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&Msgf)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgflib)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SavMsgid)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&SavMsgf)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SavMsgdta)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&SavMsgflib) TYPE(*CHAR) LEN(10)
 
/*-------------------------------------------------------------------*/
/* Declaration of variables.                                         */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Type)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&Length)  TYPE(*DEC)  LEN(15 5)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Ouput file used to get message file library.                     */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(DSPOBJD)
 
/*-------------------------------------------------------------------*/
/* Global monitor message.                                           */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Retrieve type of job environment:                                */
/*       - 0 indicates that the job is running as a batch job.       */
/*       - 1 indicates an interactive job.                           */
/*-------------------------------------------------------------------*/
 
             RTVJOBA    TYPE(&Type)
 
/*-------------------------------------------------------------------*/
/* Reset Job Switches.                                               */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------------------------------------------*/
/*  Run command passed as parameter, by using program QCMDEXC.       */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Length) VALUE(&LengthAlp)
             CALL       PGM(QCMDEXC) PARM(&Command &Length)
             MONMSG     MSGID(CPF0000)
 
/*-------------------------------------------------------------------*/
/*  Retrieve last diagnostic message if any error occurred.          */
/*-------------------------------------------------------------------*/
 
RCVMSG:            RCVMSG     PGMQ(*SAME) MSGQ(*PGMQ) MSGTYPE(*LAST) +
                                MSGDTA(&Msgdta) MSGID(&Msgid) RTNTYPE(&RtnType) +
                                MSGF(&Msgf) MSGFLIB(&Msgflib)
/**********        IF         COND(&Msgid *= ' ') THEN(DO)             */ /*BG18886*/
                   IF         COND(&Msgid *NE ' ') THEN(DO)               /*BG18886*/
                        CHGVAR     VAR(&SavMsgid)   VALUE(&Msgid)
                        CHGVAR     VAR(&SavMsgf)    VALUE(&Msgf)
                        CHGVAR     VAR(&SavMsgdta)  VALUE(&MsgDta)
                        CHGVAR     VAR(&SavMsgflib) VALUE(&Msgflib)
                        GOTO CMDLBL(RCVMSG)
                   ENDDO
                   CHGVAR     VAR(&Msgid)   VALUE(&SavMsgid)
                   CHGVAR     VAR(&Msgf)    VALUE(&SavMsgf)
                   CHGVAR     VAR(&Msgdta)  VALUE(&SavMsgdta)
                   CHGVAR     VAR(&Msgflib) VALUE(&SavMsgflib)
                   IF         COND(&Msgid = ' ') THEN(DO)
                        GOTO       CMDLBL(ENDPGM)
                   ENDDO
 
                   RTVMSG     MSGID(&Msgid) MSGF(&Msgf)
                   MONMSG     MSGID(CPF2407) EXEC(DO)
                         IF         COND(&Msgflib = '*LIBL') THEN(DO)
                               DSPOBJD    OBJ(*ALL/&Msgf) OBJTYPE(*MSGF) +
                                            OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPOBJ)
                               OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/DSPOBJD) +
                                            LVLCHK(*NO)
                               RCVF
                               CHGVAR     VAR(&Msgflib) VALUE(&ODLBNM)
                         ENDDO
                         ADDLIBLE   LIB(&Msgflib) POSITION(*LAST)
                   ENDDO
             IF         COND(&Type = '0') THEN(DO)
 
                   SNDPGMMSG  MSGID(&Msgid) MSGF(&MsgfLib/&Msgf) +
                                MSGDTA(&Msgdta) TOMSGQ(MRUNQ MOPERQ)
 
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/*----------------------*/
/* Abnormal Termination */
/*----------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&ReturnCode) VALUE('AbnormlEnd')
 
/*---------------------------------*/
/*   E N D   P R O C E S S I N G   */
/*---------------------------------*/
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RETURN
