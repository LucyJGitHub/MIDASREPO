/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Send prompt to CG PrtGenbk control')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGC5284  - Send Prompt to CG PrtGenbk Job                   */
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
/*       Prev Amend No. S01522             Date 28APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - R4.01 Packaging:                                   */
/*                - DTAQ CGPRTGENBK is now a permanent object in the */
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
             DCL        VAR(&NBR_BULKS) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&NBR_BULKA) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OFF_SET) TYPE(*DEC) LEN(5 0)
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
             SNDPGMMSG  MSG('CGC5284 - Send Prompt to CG PrtGenbk +
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
/*********   CALL       PGM(CGC5285) */                                                   /*CPK015*/
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
/**********  ALCOBJ     OBJ((&DILIB/CGPRTGENBK *DTAQ *EXCL)) WAIT(0) */                   /*CPK015*/
             ALCOBJ     OBJ((CGPRTGENBK *DTAQ *EXCL)) WAIT(0)                             /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(SEND)
             ENDDO
/**/
/* Start process */
/**/
/**/
/* Get number of Bulk processes */
/**/
             RTVDTAARA  DTAARA(CGDTA (192 2)) RTNVAR(&NBR_BULKA)
             CHGVAR     VAR(&NBR_BULKS) VALUE(&NBR_BULKA)
/**/
/* Start Bulk job 1 */
/**/
             IF         COND(&NBR_BULKS *GE 1) THEN(DO)
             CHGVAR     VAR(&OFF_SET) VALUE(201)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK1' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Start Bulk job 2 */
/**/
             IF         COND(&NBR_BULKS *GE 2) THEN(DO)
             CHGVAR     VAR(&OFF_SET) VALUE(227)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK2' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Start Bulk job 3 */
/**/
             IF         COND(&NBR_BULKS *GE 3) THEN(DO)
             CHGVAR     VAR(&OFF_SET) VALUE(253)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK3' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Start Bulk job 4 */
/**/
             IF         COND(&NBR_BULKS *GE 4) THEN(DO)
             CHGVAR     VAR(&OFF_SET) VALUE(279)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK4' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Start Bulk job 5 */
/**/
             IF         COND(&NBR_BULKS *GE 5) THEN(DO)
             CHGVAR     VAR(&OFF_SET) VALUE(305)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK5' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Start Bulk job 6 */
/**/
             IF         COND(&NBR_BULKS *GE 6) THEN(DO)
             CHGVAR     VAR(&OFF_SET) VALUE(331)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK6' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Deallocate */
/**/
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGENBK *DTAQ *EXCL)) */                           /*CPK015*/
             DLCOBJ     OBJ((CGPRTGENBK *DTAQ *EXCL))                                     /*CPK015*/
/**/
/* Send data queue entry to prompt process */
/**/
 SEND:       CHGVAR     VAR(&DATA) VALUE(' ')
             CHGVAR     VAR(&DATA) VALUE(&MSG_REF)
/**********  CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' &DILIB + */                       /*CPK015*/
/**********               &FLDLEN &DATA &KEY_LEN &MSG_PRTY)      */                       /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('CGPRTGENBK' '*LIBL' +
                          &FLDLEN &DATA &KEY_LEN &MSG_PRTY)                               /*CPK015*/
/**/
/* Check that processes are active                       */
/**/
             CALL       PGM(CGC5286)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGENBK *DTAQ *EXCL)) */                           /*CPK015*/
             DLCOBJ     OBJ((CGPRTGENBK *DTAQ *EXCL))                                     /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5284 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5284 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
