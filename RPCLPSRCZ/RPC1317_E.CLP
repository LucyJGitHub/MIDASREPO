/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP PB RPDSPMSGF choice program.')               */
/*OVR    OVRDBF FILE(DSPFD) TOFILE(QSYS/QAFDMBR)                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1317_V  - Command RPDSPMSGF choice program.              */
/*                                                                   */
/*       Function : this CLP program is called during the prompting  */
/*                  to fill in the possible choice text.             */
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
             PGM        PARM(&Input &Output)
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Input)  TYPE(*CHAR) LEN(21)
             DCL        VAR(&Output) TYPE(*CHAR) LEN(30)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Msgdta)    TYPE(*CHAR) LEN(128) +
                 /* Message text sent to MRUNQ MOPERQ.  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*-------------------------------------------------------------------*/
/*  Additional Replication processing message formats file members.  */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(DSPFD)
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Set switches U7 and U8 off.                                      */
/*-------------------------------------------------------------------*/
 
             CHGJOB     SWS(XXXXXX00)
 
/*-------------------------------*/
/*  Create LDA, if not present.  */
/*-------------------------------*/
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                   CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                                AUT(*EXCLUDE)
             ENDDO
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/*-------------------------------------------------------------------*/
/*  Get all existing additional message formats file members.        */
/*-------------------------------------------------------------------*/
 
             DSPFD      FILE(RPMSGFPD) TYPE(*MBR) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/DSPFD)
             OVRDBF     FILE(DSPFD) TOFILE(QTEMP/DSPFD)
 
/*-------------------------------------------------------------------*/
/*  Call program to set output parameter.                            */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(RP1317_E) PARM(&Input &output)
 
/*-------------------------------------------------------------------*/
/*  If error occured while processing output parameter.              */
/*-------------------------------------------------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ABNOR))
 
             GOTO       CMDLBL(ENDPGM)
 
/*--------------------------------------------------------------------*/
/*  Abnormal Termination.                                             */
/*--------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
 
             CHGVAR     VAR(&MSGDTA) +
                          VALUE('0000RPDSPMSGF Exit program ended abnormally. +
                                 See job log.')
             SNDPGMMSG  MSGID(CPD0006) MSGF(QCPFMSG) +
                           MSGDTA(&Msgdta) MSGTYPE(*DIAG)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
