/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Prepare FTP work files')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3703  -  CM Create / Override FTP Work Files             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CCG015  *CREATE    DATE 06Mar02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCG015 - Correspondence Manager (Phase 1)                   */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&ACTION &RTNCODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL  VAR(&ACTION)  TYPE(*CHAR) LEN(10)
             DCL  VAR(&RTNCODE) TYPE(*CHAR) LEN(10)
/**/
/* Global Monitor Message */
/**/
       MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
       CHGJOB  SWS(XXXXX000)
 
/*---------------------------------------------------------------*/
/* a) Create backup copy of FTP input and output file into QTEMP */
/*---------------------------------------------------------------*/
 
       IF         COND(&ACTION *EQ '*CREATE   ') THEN(DO)
 
       CLRPFM     FILE(*LIBL/CGFTPCPD)
       CLRPFM     FILE(*LIBL/CGFTPLPD)
 
       CHKOBJ     OBJ(QTEMP/CGFTPCPD) OBJTYPE(*FILE)
       MONMSG     MSGID(CPF9801) EXEC(DO)
       CPYF       FROMFILE(CGFTPCPD) TOFILE(QTEMP/CGFTPCPD) +
                     CRTFILE(*YES)
       ENDDO
 
       CHKOBJ     OBJ(QTEMP/CGFTPLPD) OBJTYPE(*FILE)
       MONMSG     MSGID(CPF9801) EXEC(DO)
       CPYF       FROMFILE(CGFTPLPD) TOFILE(QTEMP/CGFTPLPD) +
                      CRTFILE(*YES)
       ENDDO
 
       ENDDO
 
/*---------------------------------------------------------------*/
/* b) Clear FTP work files                                       */
/*---------------------------------------------------------------*/
 
       IF         COND(&ACTION *EQ '*CLEAR    ') THEN(DO)
       CLRPFM     FILE(QTEMP/CGFTPCPD)
       CLRPFM     FILE(QTEMP/CGFTPLPD)
       ENDDO
 
/*---------------------------------------------------------------*/
/* c) Override FTP work files in QTEMP library                   */
/*---------------------------------------------------------------*/
 
       IF         COND(&ACTION *EQ '*OVERRIDE ') THEN(DO)
 
       OVRDBF     FILE(CGFTPCPD) TOFILE(QTEMP/CGFTPCPD) +
                    MBR(CGFTPCPD) OVRSCOPE(*JOB)
 
       OVRDBF     FILE(CGFTPLPD) TOFILE(QTEMP/CGFTPLPD) +
                    MBR(CGFTPLPD) OVRSCOPE(*JOB)
 
       ENDDO
 
/*---------------------------------------------------------------*/
/* d) Delete the override on FTP work files                      */
/*---------------------------------------------------------------*/
 
       IF         COND(&ACTION *EQ '*DLTOVR   ') THEN(DO)
 
             DLTOVR     FILE(CGFTPCPD) LVL(*JOB)
             DLTOVR     FILE(CGFTPLPD) LVL(*JOB)
 
       ENDDO
 
       GOTO  CMDLBL(ENDCLPGM)
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
 
             SNDPGMMSG  MSG('Program CGC3703 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
