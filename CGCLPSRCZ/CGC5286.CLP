/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Check bulk job status')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5286  - Check Bulk job status                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015             Date 18Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01522             DATE 01May95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - 4.01 packaging.  Use DPLIB instead of DILIB.       */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
/************DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)                                */ /*CPK015*/
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&KEY_LEN) TYPE(*DEC) LEN(3 0) VALUE(10)
             DCL        VAR(&NBR_BULKS) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&NBR_BULKA) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OFF_SET) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
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
/**/
/**Construct*DILIB**/ /*                                                               */ /*CPK015*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)                         */ /*CPK015*/
/************CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')                      */ /*CPK015*/
             CHGJOB     SWS(XXXXX000)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC5286 - Check Bulk job status') +
                          TOMSGQ(MRUNQ)
/* */
             RTVDTAARA  DTAARA(CGDTA (192 2)) RTNVAR(&NBR_BULKA)
             CHGVAR     VAR(&NBR_BULKS) VALUE(&NBR_BULKA)
/**/
/* Bulk Data Area 1 */
/**/
             IF         COND(&NBR_BULKS *GE 1) THEN(DO)
/************ALCOBJ     OBJ((&DILIB/UDC_PRTBK1 *DTAARA *EXCL)) WAIT(0)                 */ /*CPK015*/
             ALCOBJ     OBJ((UDC_PRTBK1 *DTAARA *EXCL)) WAIT(0)                           /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(ALC2)
             ENDDO
             CHGVAR     VAR(&OFF_SET) VALUE(201)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK1' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Bulk Data Area 2 */
/**/
 ALC2:       IF         COND(&NBR_BULKS *GE 2) THEN(DO)
/************ALCOBJ     OBJ((&DILIB/UDC_PRTBK2 *DTAARA *EXCL)) WAIT(0)                 */ /*CPK015*/
             ALCOBJ     OBJ((UDC_PRTBK2 *DTAARA *EXCL)) WAIT(0)                           /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(ALC3)
             ENDDO
             CHGVAR     VAR(&OFF_SET) VALUE(227)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK2' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Bulk Data Area 3 */
/**/
 ALC3:       IF         COND(&NBR_BULKS *GE 3) THEN(DO)
/************ALCOBJ     OBJ((&DILIB/UDC_PRTBK3 *DTAARA *EXCL)) WAIT(0)                 */ /*CPK015*/
             ALCOBJ     OBJ((UDC_PRTBK3 *DTAARA *EXCL)) WAIT(0)                           /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(ALC4)
             ENDDO
             CHGVAR     VAR(&OFF_SET) VALUE(253)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK3' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Bulk Data Area 4 */
/**/
 ALC4:       IF         COND(&NBR_BULKS *GE 4) THEN(DO)
/************ALCOBJ     OBJ((&DILIB/UDC_PRTBK4 *DTAARA *EXCL)) WAIT(0)                 */ /*CPK015*/
             ALCOBJ     OBJ((UDC_PRTBK4 *DTAARA *EXCL)) WAIT(0)                           /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(ALC5)
             ENDDO
             CHGVAR     VAR(&OFF_SET) VALUE(279)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK4' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Bulk Data Area 5 */
/**/
 ALC5:       IF         COND(&NBR_BULKS *GE 5) THEN(DO)
/************ALCOBJ     OBJ((&DILIB/UDC_PRTBK5 *DTAARA *EXCL)) WAIT(0)                 */ /*CPK015*/
             ALCOBJ     OBJ((UDC_PRTBK5 *DTAARA *EXCL)) WAIT(0)                           /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(ALC6)
             ENDDO
             CHGVAR     VAR(&OFF_SET) VALUE(305)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK5' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
/* Bulk Data Area 6 */
/**/
 ALC6:       IF         COND(&NBR_BULKS *GE 6) THEN(DO)
/************ALCOBJ     OBJ((&DILIB/UDC_PRTBK6 *DTAARA *EXCL)) WAIT(0)                 */ /*CPK015*/
             ALCOBJ     OBJ((UDC_PRTBK6 *DTAARA *EXCL)) WAIT(0)                           /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(END)
             ENDDO
             CHGVAR     VAR(&OFF_SET) VALUE(331)
             CALL       PGM(CGC5283) PARM(&RTN_CODE 'UDC_PRTBK6' +
                          &OFF_SET)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             ENDDO
/**/
 END:
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5286 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5286 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((UDC_PRTBK1 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((UDC_PRTBK2 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((UDC_PRTBK3 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((UDC_PRTBK4 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((UDC_PRTBK5 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((UDC_PRTBK6 *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
