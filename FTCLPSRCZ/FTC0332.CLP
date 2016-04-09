/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Determine from data queue MEFTCOMM')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                       */
/*                                                                   */
/*       FTC0332  - Determine Action from data queue MEFTCOMM        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01435             DATE 18OCT93              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &DSPACT)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(1536)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(1536)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DSPACT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG_REF) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG_PART) TYPE(*CHAR) LEN(3)
             DCL        VAR(&S1DATA) TYPE(*CHAR) LEN(512)
             DCL        VAR(&S4DATA) TYPE(*CHAR) LEN(512)
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
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGJOB     SWS(XXXXX000)
/**/
/*           Read data queue for ever                                */
/**/
             CHGVAR     VAR(&WAIT) VALUE(-1)
 RDTAQ:      CALL       PGM(QRCVDTAQ) PARM('MEFTCOMM' &DILIB &FLDLEN +
                          &DATA &WAIT)
/**/
/*           If *DSPF then return to calling process                 */
/**/
             IF         COND(%SST(&DATA 1 10) *EQ '*DSPF     ') +
                          THEN(DO)
             CHGVAR     VAR(&DSPACT) VALUE(%SST(&DATA 1 10))
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/*           Call Prompt screen                                     */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE(%SST(&DATA 1 7))
             CHGVAR     VAR(&ACTION) VALUE(%SST(&DATA 8 8))
             CHGVAR     VAR(&MSG_REF) VALUE(%SST(&DATA 16 8))
             CHGVAR     VAR(&MSG_PART) VALUE(%SST(&DATA 24 3))
             CHGVAR     VAR(&S1DATA) VALUE(%SST(&DATA 27 512))
             CHGVAR     VAR(&S4DATA) VALUE(%SST(&DATA 539 512))
/**/
             CALL       PGM(FT0330) PARM(&RTN_CODE &ACTION &MSG_REF +
                          &MSG_PART &S1DATA &S4DATA)
/**/
/*           Send data to Batch process                             */
/**/
             CHGVAR     VAR(&DATA) VALUE(&RTN_CODE *CAT &ACTION *CAT +
                          &MSG_REF *CAT &MSG_PART *CAT &S1DATA *CAT +
                          &S4DATA)
/**/
             CALL       PGM(QSNDDTAQ) PARM('MEFTCOMM' &DILIB +
                          &FLDLEN &DATA)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program FTC0332 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FTC0332 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
