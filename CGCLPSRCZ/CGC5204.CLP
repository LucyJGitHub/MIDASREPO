/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Send prompt to CG PrtGen control')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5204  - Send Prompt to CG PrtGen Job                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015             Date 29May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01522             Date 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - R4.01 Packaging:                                   */
/*                - DTAQ CGPRTGEN is now a permanent object in the   */
/*                  DPLIB.                                           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &MSG_REF &MSG_PRTY)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
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
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC5204 - Send Prompt to CG PrtGen +
                          Control') TOMSGQ(MRUNQ)
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/**Check*if*data*queue*exists**/                                                          /*CPK015*/
/**/
/**********  CALL       PGM(CGC5205) */                                                   /*CPK015*/
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
/**********  ALCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *EXCL)) WAIT(0) */                     /*CPK015*/
             ALCOBJ     OBJ((CGPRTGEN *DTAQ *EXCL)) WAIT(0)                               /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(SEND)
             ENDDO
/**/
/* Start process */
/**/
             CALL       PGM(CGC5203) PARM(&RTN_CODE)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* Deallocate */
/**/
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *EXCL)) */                             /*CPK015*/
             DLCOBJ     OBJ((CGPRTGEN *DTAQ *EXCL))                                       /*CPK015*/
/**/
/* Send data queue entry to prompt process */
/**/
 SEND:       CHGVAR     VAR(&DATA) VALUE(' ')
             CHGVAR     VAR(&DATA) VALUE(&MSG_REF)
/**********  CALL       PGM(QSNDDTAQ) PARM('CGPRTGEN' &DILIB &FLDLEN + */                 /*CPK015*/
/**********               &DATA &KEY_LEN &MSG_PRTY)                    */                 /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('CGPRTGEN' '*LIBL' &FLDLEN +
                          &DATA &KEY_LEN &MSG_PRTY)                                       /*CPK015*/
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *EXCL)) */                             /*CPK015*/
             DLCOBJ     OBJ((CGPRTGEN *DTAQ *EXCL))                                       /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5204 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5204 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
