/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB set up sys date/time for COB calc')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing               */
/*                                                                   */
/*       CBTIME - SET UP SYSTEM TIME AND DATE FOR CLOSE OF           */
/*                BUSINESS ELAPSED TIME CALCULATIONS                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. XXXXXX             DATE 00XXX00              */
/*       PREV AMEND NO. XXXXXX             DATE 00XXX00              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DAYNOA &STIME &DFMT)
/**/
             DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FROMFMT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE) TYPE(*DEC) LEN(6)
             DCL        VAR(&DFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RFMT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYNO) TYPE(*DEC) LEN(5)
             DCL        VAR(&DAYNOA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* GLOBAL ERROR TRAP */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* SET UP START TIME AND DATE USING SYSTEM TIME, DATE AND */
/* DATE FORMAT TO SET UP VARIABLES FOR STANDARD PROGRAM ZA0270 */
/**/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)
             RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&DATFMT)
/**/
/* HANDLE EACH TYPE OF DATE FORMAT PROVIDED BY IBM */
/* CONVERT TO 'D' FOR PROGRAM PURPOSES IF NOT 'D' OR 'M' */
/**/
             IF         COND(&DATFMT *EQ 'DMY') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('D'))
             IF         COND(&DATFMT *EQ 'MDY') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('M'))
             IF         COND((&DATFMT *EQ 'YMD') *OR (&DATFMT *EQ +
                          'JUL')) THEN(DO)
                        CHGVAR   VAR(&FROMFMT) VALUE('*' *CAT &DATFMT)
                        CVTDAT   DATE(&SDATE) TOVAR(&SDATE) +
                           FROMFMT(&FROMFMT) TOFMT(*DMY) TOSEP(*NONE)
                        CHGVAR   VAR(&DFMT) VALUE('D')
             ENDDO
             CHGVAR     VAR(&DATE) VALUE(&SDATE)
             CALL       PGM(ZA0270) PARM(&DATE &DFMT &RFMT &DAYNO)
             IF         COND(&RFMT *EQ '1') THEN(GOTO CMDLBL(ABNORMAL))
             CHGVAR     VAR(&DAYNOA) VALUE(&DAYNO)
             GOTO       CMDLBL(END)
/**/
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSG('PROGRAM CBTIME ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
