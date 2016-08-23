/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RPSTRCHL   validity checking program.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1308_V - Command RPSTRCHL validity checking program.     */
/*                                                                   */
/*       Function : this CLP program perform user-defined validity   */
/*                  checking on the parameters in command RPSTRCHL.  */
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
/*       CPB002 - Meridian DBA Middleware Replication Customisation. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&QueueMgr &Channel)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&QueueMgr)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&Channel)   TYPE(*CHAR) LEN(20)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Type)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&Qryslt)    TYPE(*CHAR) LEN(128)
             DCL        VAR(&Exist)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&Activ)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&Msgdta)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&Error)     TYPE(*CHAR) LEN(1)    VALUE('N')
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Midas/TOF Channels File declaration.                             */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(RPCHNLL1) RCDFMT(RPCHNLD0)
 
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
/*  Check if selection criteria are valid.                           */
/*-------------------------------------------------------------------*/
 
             IF         COND((&QueueMgr = '*ALL') *AND (&Channel = '*ALL')) +
                   THEN(GOTO CMDLBL(RCVF))
 
             IF         COND(&QueueMgr = '*ALL') THEN(DO)
                   CHGVAR     VAR(&Qryslt) VALUE('CHCHLN *EQ %WLDCRD(''' *CAT +
                                                  &Channel *TCAT ''')')
                   GOTO       CMDLBL(OPNQRYF)
             ENDDO
 
             IF         COND(&Channel = '*ALL') THEN(DO)
                   CHGVAR     VAR(&Qryslt) VALUE('CHQMNM *EQ %WLDCRD(''' *CAT +
                                                  &QueueMgr *TCAT ''')')
                   GOTO       CMDLBL(OPNQRYF)
             ENDDO
 
             CHGVAR     VAR(&Qryslt) VALUE('(CHQMNM *EQ %WLDCRD(''' *CAT &QueueMgr +
                                            *TCAT ''')) *AND (CHCHLN *EQ %WLDCRD(''' +
                                            *CAT &Channel *TCAT '''))')
OPNQRYF:
             OPNQRYF    FILE((RPCHNLL1)) QRYSLT(&Qryslt)
 
RCVF:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EXIST))
 
             CHGVAR     VAR(&Exist) VALUE('Y')
             IF         COND(&CHACTI *EQ 'Y') THEN(DO)
                   CHGVAR     VAR(&Activ) VALUE('Y')
             ENDDO
 
             GOTO       CMDLBL(RCVF)
 
/*-------------------------------------------------------------------*/
/*  Check if channel(s) has(have) been registered.                   */
/*-------------------------------------------------------------------*/
 
EXIST:
             IF         COND(&Exist *NE 'Y') THEN(DO)
                   CHGVAR  VAR(&MSGDTA) VALUE('0000No channel has been registered for +
                                               required selection.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check if channel(s) definition(s) is(are) active.                */
/*-------------------------------------------------------------------*/
 
/**********  IF         COND(&Activ *= 'Y') THEN(DO)                  */ /*BG18886*/
             IF         COND(&Activ *NE 'Y') THEN(DO)                    /*BG18886*/
                   CHGVAR  VAR(&MSGDTA) VALUE('0000No channel definition is active +
                                               for required selection.')
                   SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                               MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERROR) VALUE('Y')
                   GOTO       CMDLBL(ENDPGM)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/*--------------------------------------------------------------------*/
/*  Abnormal Termination.                                             */
/*--------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(&Type = '0') THEN(DO)
                   CHGVAR     VAR(&MSGDTA) +
                                VALUE('RPC1308_V - Command RPSTRCHL validity checking +
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
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             CLOF       OPNID(RPCHNLL1)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND((&ERROR = 'Y') +
                         *OR (%SWITCH(XXXXXX11) *AND (&Type = '1'))) THEN(DO)
                   SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             ENDPGM
 
