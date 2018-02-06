/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Feedback Initiation and Termination')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3701  -  CM Feedback Initiation and Termination          */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015  *CREATE    Date 13Feb02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CCG015 - Correspondence Manager (Phase 1)                   */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RTNCODE &ACTION)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
/* */
/* Declare variables */
/* */
 
/* Parameter passed */
             DCL  VAR(&RTNCODE) TYPE(*CHAR) LEN(10)
             DCL  VAR(&ACTION)  TYPE(*CHAR) LEN(10)
 
/* Dataqueue */
             DCL  VAR(&DTAQ)    TYPE(*CHAR) LEN(10)  VALUE('CGFEEDQ')
             DCL  VAR(&LIB)     TYPE(*CHAR) LEN(10)  VALUE('*LIBL')
             DCL  VAR(&LENGTH)  TYPE(*DEC)  LEN(5 0) VALUE(10)
             DCL  VAR(&DATA)    TYPE(*CHAR) LEN(10)
 
/* for Feedback job */
             DCL  VAR(&DTAARA)  TYPE(*CHAR) LEN(10)  VALUE('CGFEED')
             DCL  VAR(&STATUS)  TYPE(*CHAR) LEN(1)
             DCL  VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL  VAR(&PARM1)   TYPE(*CHAR) LEN(200)
             DCL  VAR(&PARM2)   TYPE(*CHAR) LEN(200)
             DCL  VAR(&PARM3)   TYPE(*CHAR) LEN(200)
             DCL  VAR(&PARM4)   TYPE(*CHAR) LEN(200)
             DCL  VAR(&PARM5)   TYPE(*CHAR) LEN(200)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
             CHGJOB     SWS(XXXXX000)
 
/*-------------------------------------------------------------------*/
/* Request to initiate CM Feedback job                               */
/*-------------------------------------------------------------------*/
 
             IF         COND(&ACTION = '*START    ') THEN(DO)
/* */
/* Check whether Feedback job is already running before initiating   */
/* it. If so, end program with return code '*NOSUBMIT' code as only  */
/* one instance of this job is allowed to run                        */
/* */
             RTVDTAARA  DTAARA(&DTAARA) RTNVAR(&STATUS)
 
             IF         COND(&STATUS = 'Y') THEN(DO)
             CHGVAR     VAR(&RTNCODE) VALUE(*NOSUBMIT)
             GOTO ENDCLPGM
             ENDDO
 
             ELSE       CMD(DO)
             ALCOBJ     OBJ((&DTAARA *DTAARA *EXCLRD)) WAIT(30)
 
             MONMSG     MSGID(CPF1002) EXEC(DO)
             CHGVAR     VAR(&RTNCODE) VALUE(*NOSUBMIT)
             GOTO ENDCLPGM
             ENDDO
 
             ENDDO
 
             CHGDTAARA  DTAARA(&DTAARA) VALUE('Y')
             DLCOBJ     OBJ((&DTAARA *DTAARA *EXCLRD))
/* */
/* Submit CM Feedback job */
/* */
             CHGVAR     VAR(&PROGRAM) VALUE('CGC3702')
 
/************SBMJOB     CMD(CALL PGM(MLC0000) PARM(&PROGRAM &PARM1 +                      /*CSC023*/
/************             &PARM2 &PARM3 &PARM4 &PARM5)) +                                 /*CSC023*/
/************             JOB(CM_FEED) JOBD(CGJOBD) USER(*JOBD)                           /*CSC023*/
             SBMJOB     CMD(CALL PGM(MLC0000) PARM(&PROGRAM &PARM1 +
                          &PARM2 &PARM3 &PARM4 &PARM5)) +
                          JOB(CM_FEED) JOBD(CGJOBD) USER(*JOBD) OUTQ(*JOBD)               /*CSC023*/
             ENDDO
/*-------------------------------------------------------------------*/
/* Request to terminate CM Feedback job                              */
/*-------------------------------------------------------------------*/
 
             IF         COND(&ACTION = '*END      ') THEN(DO)
 
/* */
/* Check if CM Feedback job is running */
/* */
             RTVDTAARA  DTAARA(&DTAARA) RTNVAR(&STATUS)
/* */
/* If Feedback job not running, end pgm with return code '*NOTEND' */
/* */
             IF         COND(&STATUS = ' ') THEN(DO)
             CHGVAR     VAR(&RTNCODE) VALUE(*NOTEND)
             GOTO ENDCLPGM
             ENDDO
/* */
/* If Feedback job is running, send entry *END to data queue so the  */
/* feedback job receives this and terminate the job */
/* */
             ELSE       CMD(DO)
             CHGVAR     VAR(&DATA) VALUE(*END)
             CALL       PGM(QSNDDTAQ) PARM(&DTAQ &LIB &LENGTH &DATA)
             ENDDO
 
             ENDDO
 
             GOTO ENDCLPGM
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC3701 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DTAARA *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
ENDCLPGM:
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
             ENDPGM
