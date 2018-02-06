/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG FTP Feedback Command Generator')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC3704  -  Midas CG FTP Feedback Command Generator         */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CCG015  *CREATE    Date 06Mar02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCG015 - Correspondence Manager (Phase 1)                   */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&ACTPARM &JOBPARM &HSTPARM &FRQPARM +
                          &RTNCODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
       DCL  VAR(&RTNCODE) TYPE(*CHAR) LEN(10)
 
       DCL  VAR(&ACTPARM) TYPE(*CHAR) LEN(10)
       DCL  VAR(&JOBPARM) TYPE(*CHAR) LEN(30)
       DCL  VAR(&HSTPARM) TYPE(*CHAR) LEN(30)
       DCL  VAR(&FRQPARM) TYPE(*DEC)  LEN(5 0)
       DCL  VAR(&RTNPARM) TYPE(*CHAR) LEN(10)
/**/
/* Global Monitor Message */
/**/
       MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
       CHGJOB  SWS(XXXXX000)
/**/
/* Set parameters for CG3704 */
/**/
       CHGVAR     VAR(&HSTPARM) VALUE(' ')
       CHGVAR     VAR(&FRQPARM) VALUE(0)
       CHGVAR     VAR(&RTNPARM) VALUE(' ')
/**/
/* Generate FTP commands. */
/**/
       CALL       PGM(CG3704) PARM(&ACTPARM &JOBPARM &HSTPARM +
                                   &FRQPARM &RTNPARM)
 
       IF         COND(&RTNPARM = '*ERROR    ') THEN(DO)
                  GOTO CMDLBL(ABNORMAL)
       ENDDO
 
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
 
             SNDPGMMSG  MSG('Program CGC3704 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
