/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RPRTVMSGP  validity checking program.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1305_V - Command RPRTVMSGP validity checking program.    */
/*                                                                   */
/*       Function : this CLP program perform user-defined validity   */
/*                  checking on the parameters in command RPRTVMSGP. */
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
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&ScriptName &ImageName &FieldName &FieldType +
                          &TransData &FieldPos &FieldValue &ReturnCode)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&ScriptName) TYPE(*CHAR) LEN(10) +
                          /* Script name. */
             DCL        VAR(&ImageName)  TYPE(*CHAR) LEN(32) +
                          /* Image name. */
             DCL        VAR(&TransData)  TYPE(*CHAR) LEN(4000) +
                          /* Meridian message data. */
             DCL        VAR(&FieldName)  TYPE(*CHAR) LEN(10) +
                          /* Field Name. */
             DCL        VAR(&FieldType)  TYPE(*CHAR) LEN(1) +
                          /* Field Type. */
             DCL        VAR(&FieldValue) TYPE(*CHAR) LEN(9999) +
                          /* Field value. */
             DCL        VAR(&FieldPos)   TYPE(*CHAR) LEN(7) +
                          /* Field position. */
             DCL        VAR(&ReturnCode) TYPE(*CHAR) LEN(10) +
                          /* Return code. */
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Type)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&Sbs)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&TiLib)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msgdta)   TYPE(*CHAR) LEN(128)
             DCL        VAR(&Msg)      TYPE(*CHAR) LEN(128)
             DCL        VAR(&Error)    TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
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
/*  Check if script member exists in file xxTILIB/MDBASCRIPT.        */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
             CHGVAR     VAR(&Tilib)  VALUE(&Sbs *CAT 'TILIB')
 
             CHKOBJ     OBJ(&TILIB/MDBASCRIPT) OBJTYPE(*FILE) +
                          MBR(&ScriptName) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810 CPF9815) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) RMV(*NO) MSG(&Msg)
                   CHGVAR  VAR(&Msgdta) VALUE('0000' *CAT &Msg)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/*--------------------------------------------------------------------*/
/* Abnormal Termination.                                              */
/*--------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(&Type = '0') THEN(DO)
                   CHGVAR     VAR(&Msgdta) +
                                VALUE('RPC1305_V - Command RPRTVMSGP validity checking +
                                       program - ended abnormally. See job log')
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             ELSE       CMD(DO)
                   CHGVAR     VAR(&Msgdta) +
                                VALUE('0000Validity checking program RPC1305_V +
                                       - ended abnormally. See job log.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                 MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
ENDPGM:
             IF         COND((&Error = 'Y') +
                         *OR (%SWITCH(XXXXXX11) *AND (&Type = '1'))) THEN(DO)
                   SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
