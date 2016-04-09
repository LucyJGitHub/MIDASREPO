/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Initiate FTP Session')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3705  -  Initiate FTP Session                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9463            DATE 01Dec05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CCG015  *CREATE    DATE 06Mar02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG9463- Rename log spool file, send to CMOUTQ              */
/*       CCG015 - Correspondence Manager (Phase 1)                   */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&HSTPARM &RTNCODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
       DCL  VAR(&HSTPARM) TYPE(*CHAR) LEN(30)
       DCL  VAR(&RTNCODE) TYPE(*CHAR) LEN(10)
/*/COPY WNCPYSRC,CGH00014                                            */
/**/
/* Global Monitor Message */
/**/
       MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
       CHGJOB  SWS(XXXXX000)
/**/
/* Override FTP files */
/**/
             CLRPFM     FILE(QTEMP/CGFTPLPD)
 
             OVRDBF     FILE(INPUT) TOFILE(QTEMP/CGFTPCPD) +
                          MBR(CGFTPCPD) OVRSCOPE(*JOB)
 
             OVRDBF     FILE(OUTPUT) TOFILE(QTEMP/CGFTPLPD) +
                          MBR(CGFTPLPD) OVRSCOPE(*JOB)
 
/**/
/* Initiate FTP session */
/**/
/*/COPY WNCPYSRC,CGH00015                                            */
             FTP        RMTSYS(&HSTPARM)
/*/COPY WNCPYSRC,CGH00016                                            */
/**/
/* Delete overrides  */
/**/
             DLTOVR     FILE(INPUT) LVL(*JOB)
             DLTOVR     FILE(OUTPUT) LVL(*JOB)
 
             OVRPRTF    FILE(QSYSPRT) OUTQ(*LIBL/CMOUTQ) +
                          SPLFNAME(CMFTPLOG)                                /*BUG9463*/
             CPYF       FROMFILE(QTEMP/CGFTPLPD) TOFILE(*PRINT)
             DLTOVR     FILE(QSYSPRT)                                       /*BUG9463*/
 
       GOTO  CMDLBL(END)
/**/
/* Abnormal termination processing */
/**/
ABNORMAL:
 
             CHGVAR     VAR(&RTNCODE) VALUE('*ERROR    ')
 
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program CGC3705 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
