/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PB RPSETTRG validity checking program')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Replication Module                                  */
/*                                                                   */
/*       RPC1318_V - Command RPSETTRG validity checking program.     */
/*                                                                   */
/*       Function : this CLP program performs user-defined validity  */
/*                  checking on the parameters in command RPSETTRG.  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CPB002  *CREATE    Date 02Mar01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC017 - Change to 250 library list.                        */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&DtaAraLib &JobD &JobQ &Exist &Dmlib)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&DtaAraLib)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobD)       TYPE(*CHAR) LEN(20)
             DCL        VAR(&JobQ)       TYPE(*CHAR) LEN(20)
             DCL        VAR(&Exist)      TYPE(*LGL)  LEN(1)
             DCL        VAR(&ParmExist)  TYPE(*LGL)  LEN(1)
             DCL        VAR(&Dmlib)      TYPE(*CHAR) LEN(10)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Sbs)        TYPE(*CHAR) LEN(2)
/************DCL        VAR(&UsrLibl)    TYPE(*CHAR) LEN(275)                          */ /*CSC017*/
             DCL        VAR(&UsrLibl)    TYPE(*CHAR) LEN(2750)                            /*CSC017*/
             DCL        VAR(&Index)      TYPE(*DEC)  LEN(2)
             DCL        VAR(&Pos)        TYPE(*DEC)  LEN(3)
             DCL        VAR(&JobDescr)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobDLib)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobQueue)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JobQLib)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&Type)       TYPE(*CHAR) LEN(1)
/************DCL        VAR(&Command)    TYPE(*CHAR) LEN(256)                          */ /*CSC017*/
/************DCL        VAR(&Length)     TYPE(*DEC)  LEN(15 5) VALUE(256)              */ /*CSC017*/
             DCL        VAR(&Msgdta)     TYPE(*CHAR) LEN(128)
             DCL        VAR(&Msg)        TYPE(*CHAR) LEN(128)
             DCL        VAR(&Error)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&Exist)      TYPE(*LGL)  LEN(1)
 
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
/*  Get Midas system identifier.                                     */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&Sbs)
             CHGVAR  VAR(&Dmlib) VALUE(&Sbs *CAT 'DMLIB')
 
/*-------------------------------------------------------------------*/
/*  Retrieve user portion of the thread's library list.              */
/*-------------------------------------------------------------------*/
 
             RTVJOBA    USRLIBL(&UsrLibl)
 
/*-------------------------------------------------------------------*/
/*  At first, check if trigger control data area already exists.     */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&EXIST) VALUE('1')
             CHKOBJ     OBJ(&Dmlib/RPTRG) OBJTYPE(*DTAARA) AUT(*USE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CHGVAR     VAR(&EXIST) VALUE('0')
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Data Area Library was input.                            */
/*-------------------------------------------------------------------*/
 
             IF COND(&DtaAraLib = ' ') THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Data Area Library required.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(JOBD)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Data Area Library exists.                               */
/*-------------------------------------------------------------------*/
 
             CHKOBJ     OBJ(QSYS/&DtaAraLib) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810) EXEC(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Data Area Library' *BCAT &DtaAraLib  +
                                              *BCAT 'doesn''t exist or you +
                                             don''t have sufficient authority.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(JOBD)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Data Area Library exists in library list.               */
/*-------------------------------------------------------------------*/
 
             Chgvar     VAR(&Index) Value(0)
CHKLIB1:     Chgvar     VAR(&Pos) Value((&index * 11) + 1)
/************If         Cond(&Index < 25) THEN(DO)                                     */ /*CSC017*/
             If         Cond(&Index < 250) THEN(DO)                                       /*CSC017*/
                If Cond(%SST(&UsrLibl &Pos 11) = &DtaAraLib) Then(Goto Cmdlbl(JOBD))
                Chgvar     VAR(&Index) Value(&Index + 1)
                Goto       Cmdlbl(CHKLIB1)
             Enddo
             CHGVAR  VAR(&Msgdta) VALUE('0000Data Area Library' *BCAT &DtaAraLib  +
                                        *BCAT 'doesn''t exist in library list.')
             SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                         MSGDTA(&Msgdta) MSGTYPE(*DIAG)
             CHGVAR     VAR(&Error) VALUE('Y')
 
/*-------------------------------------------------------------------*/
/*  Check if Job Description Library was input.                      */
/*-------------------------------------------------------------------*/
 
JOBD:        CHGVAR     VAR(&ParmExist) VALUE('0')
             CHGVAR     VAR(&JobDLib)  VALUE(%SST(&JobD 11 10))
             IF COND(&JobDLib = ' ') THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Job Description Library required.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(JOBDESC)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Library exists.                                         */
/*-------------------------------------------------------------------*/
 
             CHKOBJ     OBJ(QSYS/&JobDLib) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810) EXEC(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Job Description Library' *BCAT &JobDLib  +
                                              *BCAT 'doesn''t exist or you +
                                             don''t have sufficient authority.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(JOBDESC)
             ENDDO
             CHGVAR     VAR(&ParmExist) VALUE('1')
 
/*------------------------------------------------------------------*/
/*  Check if Job Description Library exists in library list.        */
/*------------------------------------------------------------------*/
 
             Chgvar     VAR(&Index) Value(0)
CHKLIB2:     Chgvar     VAR(&Pos) Value((&index * 11) + 1)
/************If         Cond(&Index < 25) THEN(DO)                                     */ /*CSC017*/
             If         Cond(&Index < 250) THEN(DO)                                       /*CSC017*/
                If Cond(%SST(&UsrLibl &Pos 11) = &JobDLib) Then(Goto Cmdlbl(JOBDESC))
                Chgvar     VAR(&Index) Value(&Index + 1)
                Goto       Cmdlbl(CHKLIB2)
             Enddo
             CHGVAR  VAR(&Msgdta) VALUE('0000Job Description Library' *BCAT &JobDLib  +
                                        *BCAT 'doesn''t exist in library list.')
             SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                         MSGDTA(&Msgdta) MSGTYPE(*DIAG)
             CHGVAR     VAR(&Error) VALUE('Y')
 
/*-------------------------------------------------------------------*/
/*  Check if Job Description was input.                              */
/*-------------------------------------------------------------------*/
 
JOBDESC:     CHGVAR     VAR(&JobDescr)  VALUE(%SST(&JobD 01 10))
             IF COND(&JobDescr = ' ') THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Job description required.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(JOBQ)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Job Description exists in library.                      */
/*-------------------------------------------------------------------*/
 
             IF COND(&ParmExist = '1') THEN(DO)
                CHKOBJ     OBJ(&JobDLib/&JobDescr) OBJTYPE(*JOBD) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                      CHGVAR     VAR(&Msgdta) +
                                   VALUE('0000Job Description' *BCAT &JobDescr *TCAT +
                                         ' in library' *BCAT &JobDLib *TCAT ' was not +
                                         found or you don''t have sufficient +
                                         authority to the object.')
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                   MSGTYPE(*DIAG)
                      CHGVAR     VAR(&Error) VALUE('Y')
                ENDDO
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Job Queue Library was input.                            */
/*-------------------------------------------------------------------*/
 
JOBQ:        CHGVAR     VAR(&ParmExist) VALUE('0')
             CHGVAR     VAR(&JobQLib)  VALUE(%SST(&JobQ 11 10))
             IF COND(&JobDLib = ' ') THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Job Queue Library required.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(JOBQUEUE)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Job Queue Library exists.                               */
/*-------------------------------------------------------------------*/
 
             CHKOBJ     OBJ(QSYS/&JobQLib) OBJTYPE(*LIB) AUT(*USE)
             MONMSG     MSGID(CPF9801 CPF9802 CPF9810) EXEC(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Job Queue Library' *BCAT &JobQLib  +
                                              *BCAT 'doesn''t exist or you +
                                             don''t have sufficient authority.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(JOBQUEUE)
             ENDDO
             CHGVAR     VAR(&ParmExist) VALUE('1')
 
/*-------------------------------------------------------------------*/
/*  Check if Job Queue Library exists in library list.               */
/*-------------------------------------------------------------------*/
 
             Chgvar     VAR(&Index) Value(0)
CHKLIB3:     Chgvar     VAR(&Pos) Value((&index * 11) + 1)
/************If         Cond(&Index < 25) THEN(DO)                                     */ /*CSC017*/
             If         Cond(&Index < 250) THEN(DO)                                       /*CSC017*/
                If Cond(%SST(&UsrLibl &Pos 11) = &JobQLib) Then(Goto Cmdlbl(JOBQUEUE))
                Chgvar     VAR(&Index) Value(&Index + 1)
                Goto       Cmdlbl(CHKLIB3)
             Enddo
             CHGVAR  VAR(&Msgdta) VALUE('0000Job Queue Library' *BCAT &JobQLib  +
                                        *BCAT 'doesn''t exist in library list.')
             SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                         MSGDTA(&Msgdta) MSGTYPE(*DIAG)
             CHGVAR     VAR(&Error) VALUE('Y')
 
/*-------------------------------------------------------------------*/
/*  Check if Job Queue was input.                                    */
/*-------------------------------------------------------------------*/
 
JOBQUEUE:    CHGVAR     VAR(&JobQueue)  VALUE(%SST(&JobQ 01 10))
             IF COND(&JobQueue = ' ') THEN(DO)
                   CHGVAR  VAR(&Msgdta) VALUE('0000Job queue required.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&Msgdta) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&Error) VALUE('Y')
                   GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if Job Queue exists in library.                            */
/*-------------------------------------------------------------------*/
 
             IF COND(&ParmExist = '1') THEN(DO)
                CHKOBJ     OBJ(&JobQLib/&JobQueue) OBJTYPE(*JOBQ) AUT(*USE)
                MONMSG     MSGID(CPF9801 CPF9802) EXEC(DO)
                      CHGVAR     VAR(&Msgdta) +
                                   VALUE('0000Job Queue' *BCAT &JobQueue *TCAT +
                                         ' in library' *BCAT &JobQLib *TCAT ' was not +
                                         found or you don''t have sufficient +
                                         authority to the object.')
                      SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                   MSGTYPE(*DIAG)
                      CHGVAR     VAR(&Error) VALUE('Y')
                ENDDO
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
                                VALUE('RPC1318_V - Command RPSETTRG validity checking +
                                       program - ended abnormally. See job log')
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                                TOMSGQ(MOPERQ)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             ELSE       CMD(DO)
                   CHGVAR     VAR(&MSGDTA) +
                                VALUE('0000Validity checking program RPC1318_V +
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
