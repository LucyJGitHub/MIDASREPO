/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Send prompt to TELLER Control')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC0524  - Send Prompt to CG PrtGen Job                     */
/*                                                                   */
/*  (C) COPYRIGHT FINASTRA INTERNATIONAL LIMITED 1997.               */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCG016 *CREATE     Date 21FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCG016 - Correspondence Manager for Retail Teller System    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &MSG_REF &MSG_PRTY)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT FINASTRA +
                          INTERNATIONAL LIMITED 1997')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSG_REF) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_PRTY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEY_LEN) TYPE(*DEC) LEN(3 0) VALUE(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&OUTQ    )    TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQLIB )    TYPE(*CHAR) LEN(10)
DCL &RTVDEVD *CHAR 857
DCL &RTVDEVDLEN *CHAR 4 X'00000359'
DCL &FMT *CHAR 8 'DEVD0600'
DCL &DEV *CHAR 10
DCL &ERR *CHAR 8    X'0000000000000000'
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&MKICPY) VALUE('COPYRIGHT FINASTRA +
                          INTERNATIONAL LIMITED 1997.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC0524 - Send Prompt to CG PrtGen +
                          Control') TOMSGQ(MRUNQ)
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/* Check if data queue exists */
/**/
             CALL       PGM(CGC0525)
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
             ALCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *EXCL)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(SEND)
             ENDDO
/**/
/* Start process */
/**/
             CALL       PGM(CGC0523) PARM(&RTN_CODE)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* Deallocate */
/**/
             DLCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *EXCL))
/**/
/* Send data queue entry to prompt process */
/**/
 SEND:       CHGVAR     VAR(&DATA) VALUE(' ')
/**/
/* Get outq and outqlib of user */
/**/
             RTVUSRPRF  OUTQ(&OUTQ) OUTQLIB(&OUTQLIB)
             IF (&OUTQ *EQ '*WRKSTN') THEN(DO)
RTVJOBA    JOB(&DEV)
CALL QDCRDEVD (&RTVDEVD &RTVDEVDLEN &FMT &DEV &ERR)
MONMSG CPF0000 EXEC(DO)
DMPCLPGM
CHGVAR %SST(&RTVDEVD 335 10) 'MPRINT     '
CHGVAR %SST(&RTVDEVD 345 10) '*LIBL      '
ENDDO
CHGVAR     VAR(&OUTQ) VALUE(%SST(&RTVDEVD 335 10))
CHGVAR     VAR(&OUTQLIB) VALUE(%SST(&RTVDEVD 345 10))
IF (&OUTQ *EQ '*DEV') THEN(DO)
CHGVAR     VAR(&OUTQ) VALUE(%SST(&RTVDEVD 245 10))
CHGVAR     VAR(&OUTQLIB) VALUE('*LIBL     ')
ENDDO
IF (&OUTQ *EQ '*SYSVAL') THEN(DO)
RTVSYSVAL  SYSVAL(QPRTDEV) RTNVAR(&OUTQ)
CHGVAR     VAR(&OUTQLIB) VALUE('*LIBL     ')
ENDDO
 
             ENDDO
             IF (&OUTQ *EQ '*DEV') THEN(DO)
             CHGVAR     VAR(&OUTQ) VALUE('MPRINT')
             CHGVAR     VAR(&OUTQLIB) VALUE('*LIBL')
             ENDDO
             CHGVAR     VAR(&DATA) VALUE(&MSG_REF)
             CHGVAR     VAR(%SST(&DATA 31 10)) VALUE(&OUTQ)
             CHGVAR     VAR(%SST(&DATA 41 10)) VALUE(&OUTQLIB)
             CALL       PGM(QSNDDTAQ) PARM('CGTELLER' &DILIB &FLDLEN +
                          &DATA &KEY_LEN &MSG_PRTY)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC0524 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0524 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
