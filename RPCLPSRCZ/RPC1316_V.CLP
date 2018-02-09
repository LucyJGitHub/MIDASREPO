/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RPDSPSCRPT validity checking program.')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1316_V  - Command RPDSPSCRPT validity checking program.  */
/*                                                                   */
/*       Function : this CLP program perform user-defined validity   */
/*                  checking on the parameters in command RPDSPSCRPT.*/
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
/*       Prev Amend No. CPB002  *CREATE    Date 20Jul99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SystemName)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&SystemName) TYPE(*CHAR) LEN(8)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Type)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&Command)   TYPE(*CHAR) LEN(128)
             DCL        VAR(&Length)    TYPE(*DEC)  LEN(15 5) VALUE(128)
             DCL        VAR(&Member)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&Msg)       TYPE(*CHAR) LEN(128)
             DCL        VAR(&Error)     TYPE(*CHAR) LEN(1)    VALUE('N')
 
             DCL        VAR(&Msgdta)    TYPE(*CHAR) LEN(128) +
                 /* Message text sent to MRUNQ MOPERQ.  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(X110LF) RCDFMT(X1PFR)
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
/*  Check if System exists in Meridian Products file.                */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Command) +
                         VALUE('OVRDBF FILE(X110LF) MBR(X110LF) +
                                       POSITION(*KEY 1 X1PFR ''' *CAT +
                                                &SystemName *CAT ''')')
             CALL       PGM(QCMDEXC) PARM(&Command &Length)
             RCVF       DEV(*file) RCDFMT(X1PFR)
              MONMSG     MSGID(CPF4137) EXEC(DO)
                    CHGVAR  VAR(&Msg) VALUE('0000System Name' *BCAT +
                                            &SystemName *TCAT ' does not exist +
                                            in Meridian Products File X1PF. Enter +
                                            one of the values that is defined for +
                                            the parameter.')
                    SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA(&Msg) MSGTYPE(*DIAG)
                    CHGVAR     VAR(&Error) VALUE('Y')
                    GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*-------------------------------------------------------------------*/
/*  Check that script source member has been defined.                */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&Member) VALUE('RP' *CAT &SystemName)
             CHKOBJ     OBJ(MDBASCRIPT) OBJTYPE(*FILE) +
                          MBR(&Member) AUT(*USE)
              MONMSG     MSGID(CPF9815) EXEC(DO)
                    CHGVAR  VAR(&Msg) VALUE('0000Script member source ' *CAT +
                                            &Member *TCAT ' does not exist +
                                            in file MDBASCRIPT.')
                    SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                                MSGDTA(&Msg) MSGTYPE(*DIAG)
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
                                VALUE('RPC1316_V - Command RPDSPSCRPT validity checking +
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
 
             IF         COND((&ERROR = 'Y') *OR %SWITCH(XXXXXX11)) THEN(DO)
                   SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
                   MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
