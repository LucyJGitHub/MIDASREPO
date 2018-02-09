/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RPIMPORT   validity checking program.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1304_V - Command RPIMPORT validity checking program.     */
/*                                                                   */
/*       Function:    this CLP program perform user-defined validity */
/*                 checking on the parameters in command RPIMPORT.   */
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
 
             PGM        PARM(&Folder &Fromdoc &Tofile &Replace)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Folder)   TYPE(*CHAR) LEN(63)
             DCL        VAR(&Fromdoc)  TYPE(*CHAR) LEN(12)
             DCL        VAR(&Tofile)   TYPE(*CHAR) LEN(20)
             DCL        VAR(&Replace)  TYPE(*CHAR) LEN(4)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Type)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&Msgdta)   TYPE(*CHAR) LEN(128)
             DCL        VAR(&Msg)      TYPE(*CHAR) LEN(128)
             DCL        VAR(&Error)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&File)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&Lib)      TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
/*  Check if folder exists.                                          */
/*-------------------------------------------------------------------*/
 
             CHKDLO     DLO(&Folder)
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*DIAG) RMV(*NO) MSG(&Msg)
                   CHGVAR     VAR(&Msgdta)   VALUE('0000' *CAT &MSG *CAT '.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(TOFILE)
             ENDDO
             MONMSG     MSGID(CPF8A77) EXEC(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Folder' *BCAT &Folder *TCAT +
                                              ' not found.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(TOFILE)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if document exists.                                        */
/*-------------------------------------------------------------------*/
 
             CHKDLO     DLO(&Fromdoc) FLR(&Folder)
             MONMSG     MSGID(CPF0001) EXEC(DO)
                   RCVMSG     MSGTYPE(*DIAG) RMV(*NO) MSG(&Msg)
                   CHGVAR     VAR(&Msgdta)   VALUE('0000' *CAT &Msg *CAT '.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
             ENDDO
             MONMSG     MSGID(CPF8A82) EXEC(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Document' *BCAT &Fromdoc *TCAT ' not found +
                                               in folder' *BCAT &Folder *TCAT '.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if To file was input.                                      */
/*-------------------------------------------------------------------*/
 
TOFILE:      CHGVAR     VAR(&File)  VALUE(%SST(&Tofile 1 10))
 
             IF COND(&File = ' ') THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Parameter TOFILE required.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Library was input.                                      */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Lib)  VALUE(%SST(&TOFILE 11 10))
 
             IF COND(&Lib = ' ') THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Library required.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ERROR)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Library exists.                                         */
/*-------------------------------------------------------------------*/
 
             CHKOBJ     OBJ(QSYS/&Lib) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810) EXEC(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Library' *BCAT &Lib  +
                                              *BCAT 'doesn''t exist or you +
                                             don''t have sufficient authority.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ERROR)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if file already exists.                                    */
/*-------------------------------------------------------------------*/
 
             IF         COND(&Error = 'Y') THEN(GOTO CMDLBL(ERROR))
             CHKOBJ     OBJ(&Lib/&File) OBJTYPE(*FILE) AUT(*USE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO ERROR)
             MONMSG     MSGID(CPF9802) EXEC(DO)
                   CHGVAR     VAR(&Msgdta) VALUE('0000You don''t have +
                                sufficient authority to file' *BCAT &File *TCAT +
                                ' in library' *BCAT &Lib)
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ERROR)
             ENDDO
             IF         COND(&Replace = '*NO ') THEN(DO)
                   CHGVAR     VAR(&Msgdta) VALUE('0000File' *BCAT &File *TCAT +
                                ' already exists in library' *BCAT &Lib *TCAT '.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ERROR)
             ENDDO
 
ERROR:       IF         COND(&Error = 'Y') THEN(+
                   SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
 
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
                                VALUE('RPC1304_V - Command RPIMPORT validity checking +
                                       program - ended abnormally. See job log')
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             ELSE       CMD(DO)
                   CHGVAR     VAR(&MSGDTA) +
                                VALUE('0000Validity checking program RPC1304_V +
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
                          Finastra International Limited')
 
             ENDPGM
