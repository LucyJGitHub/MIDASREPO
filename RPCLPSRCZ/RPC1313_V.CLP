/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RPSETFFD   validity checking program.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1313_V - Command RPSETFFD validity checking program.     */
/*                                                                   */
/*       Function : this CLP program performs user-defined validity  */
/*                  checking on the parameters in command RPSETFFD.  */
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
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&Interface &File &Replace)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Interface)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&File)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&Replace)    TYPE(*CHAR) LEN(4)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&RepSbsLib)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&Type)       TYPE(*CHAR) LEN(1)
             DCL        VAR(&Command)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&Length)     TYPE(*DEC)  LEN(15 5) VALUE(256)
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128)
             DCL        VAR(&Msg)        TYPE(*CHAR) LEN(128)
             DCL        VAR(&Error)      TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Repn. Addn. Processing Message Formats                           */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(RPMSGFPD)
 
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
/*  Get Replication Subsystem library.                               */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(KMDSBS) RTNVAR(&RepSbsLib)
 
/*-------------------------------------------------------------------*/
/*  Check if RPMSGFPD interface member exists.                       */
/*-------------------------------------------------------------------*/
 
             CHKOBJ     OBJ(RPMSGFPD) OBJTYPE(*FILE) +
                          MBR(&Interface) AUT(*CHANGE)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                   RCVMSG     MSGTYPE(*LAST) MSG(&Msgdta)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA('0000' *CAT &Msgdta) +
                                MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if file exists.                                            */
/*-------------------------------------------------------------------*/
 
             CHKOBJ     OBJ(*LIBL/&File) OBJTYPE(*FILE) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                   CHGVAR     VAR(&Msgdta) +
                                VALUE('0000The object' *BCAT &File *TCAT +
                                      ' in library *LIBL type *FILE was not +
                                      found or you don''t have sufficient +
                                      authority to the object.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if file field description already exists.                  */
/*-------------------------------------------------------------------*/
 
             OVRDBF     FILE(RPMSGFPD) TOFILE(*FILE) +
                          MBR(&Interface) SHARE(*YES)
             CHGVAR VAR(&Command) +
                      VALUE('OPNQRYF FILE((RPMSGFPD ' *CAT &Interface *TCAT +
                                     ')) +
                                      QRYSLT(''WHFILE = ''''' *CAT &File *TCAT ''''''')')
 
             CALL       PGM(QCMDEXC) PARM(&Command &Length)
 
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO ENDPGM)
             IF         COND(&Replace *EQ '*NO') THEN(DO)
                   CHGVAR  VAR(&Msg) VALUE('0000Description already exists in member' +
                                            *BCAT &Interface *TCAT ' for Midas file' +
                                            *BCAT &File *TCAT '.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msg) MSGTYPE(*DIAG)
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
                                VALUE('RPC1313_V - Command RPSETFFD validity checking +
                                       program - ended abnormally. See job log')
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             ELSE       CMD(DO)
                   CHGVAR     VAR(&MSGDTA) +
                                VALUE('0000Validity checking program RPC1313_V +
                                       - ended abnormally. See job log.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                 MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
ENDPGM:
             DLTOVR     FILE(RPMSGFPD)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CLOF       OPNID(RPMSGFPD)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND((&Error = 'Y') +
                         *OR (%SWITCH(XXXXXX11) *AND (&Type = '1'))) THEN(DO)
                   SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
