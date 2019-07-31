/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RP Clear Trace outgoing messages')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1485 - Clear Trace outgoing messages.                    */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPB010  *CREATE    Date 16Jan03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB010 - Avoid DB Error by write message in Trace File      */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*-------------------------------------------------------------------*/
/*  Parameters declaration.                                          */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&DELETE)   TYPE(*DEC)  LEN(5 0)    VALUE(0)
             DCL        VAR(&RUNDATE)  TYPE(*DEC)  LEN(5 0)    VALUE(0)
             DCL        VAR(&DELDATE)  TYPE(*CHAR) LEN(5)
 
/*-------------------------------------------------------------------*/
/*  Variables declaration.                                           */
/*-------------------------------------------------------------------*/
 
             DCL        VAR(&Switches) TYPE(*CHAR) LEN(8)
             DCL        VAR(&Msgdta)   TYPE(*CHAR) LEN(128)
             DCL        VAR(&SBS)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)    TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&Cpyfld)   TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/*-------------------------------------------------------------------*/
/*  C.O.B. files replication file declaration.                       */
/*-------------------------------------------------------------------*/
 
             DCLF       FILE(RPTRAQL1) RCDFMT(RPTRAQD0)
 
/*-------------------------------------------------------------------*/
/*  Global Monitor Message.                                          */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-------------------------------------------------------------------*/
/*  Send Notify Message to Message Queue MRUNQ.                      */
/*-------------------------------------------------------------------*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SBS)
 
             CHGVAR     VAR(&TOLIB) VALUE(&SBS *TCAT 'DPLIB')
 
             CHGVAR     VAR(&Msgdta) +
                           VALUE('RPC1485 - Clear outgoing messages')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ)
 
/*-------------------------------------------------------------------*/
/*  Retrieve the retention period.                                   */
/*-------------------------------------------------------------------*/
 
             CALL       PGM(RPC1486) PARM(&RUNDATE)
 
             DLTF       FILE(&TOLIB/XRPTRACPD)
             MONMSG     MSGID(CPF0000)
 
/*-------------------------------------------------------------------*/
/*  Process all Messages                                             */
/*-------------------------------------------------------------------*/
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPROC))
 
             CHGVAR     VAR(&DELETE) VALUE(&Rundate - &RPREPD)
             CHGVAR     VAR(&DELDATE) VALUE(&DELETE)
 
             CPYF       FROMFILE(RPTRACPD) TOFILE(&TOLIB/XRPTRACPD) +
                          MBROPT(*ADD) CRTFILE(*YES) INCREL((*IF +
                          RPDATE *GT &DELDATE) (*AND RPTYPE *EQ +
                          &RPTRAF))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
/*-------------------------------------------------------------------*/
/*  Database error processing.                                       */
/*-------------------------------------------------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(RCVF)
 
/*-------------------------------------------------------------------*/
/*  End of process                                                   */
/*-------------------------------------------------------------------*/
 
 ENDPROC:
 
             CPYF       FROMFILE(&TOLIB/XRPTRACPD) TOFILE(RPTRACPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(RPTRACPD))
 
             DLTF       FILE(&TOLIB/XRPTRACPD)
             MONMSG     MSGID(CPF0000)
 
             RGZPFM     FILE(RPTRACPD)
             MONMSG     MSGID(CPF0000)
 
             RGZPFM     FILE(RPREPAPD)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(ENDPGM)
 
/*-------------------------------------------------------------------*/
/*  Abnormal Termination.                                            */
/*-------------------------------------------------------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&Msgdta) VALUE('RPC1485 - Clear +
                          outgoing trace messages -  ended abnormally. See job log')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(&Msgdta) +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/*-------------------------------------------------------------------*/
/*  End processing.                                                  */
/*-------------------------------------------------------------------*/
 
 ENDPGM:
             CHGVAR     VAR(&Cpyfld) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
