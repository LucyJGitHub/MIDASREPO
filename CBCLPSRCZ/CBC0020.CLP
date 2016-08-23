/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB monitor menu calling program')           */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0020 - CLOSE OF BUSINESS CALL HALT REQUEST PROGRAM       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.                    DATE 00/00/00             */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&ERROR)
/**/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* RESET ERROR FIELD TO 'N' AND SET OFF JOB SWITCHES */
/**/
             CHGVAR     VAR(&ERROR) VALUE('N')
             CHGJOB     SWS(00000000)
/**/
/* CALL HALT REQUEST PROGRAM */
/**/
             CALL       PGM(CB0020)
/**/
/* IF CALLED PROGRAM TIMED OUT SET ERROR PARAMETER TO 'T' */
/**/
             IF         COND(%SWITCH(1XXXXXXX)) THEN(CHGVAR +
                          VAR(&ERROR) VALUE('T'))
/**/
/* IF CALLED PROGRAM ENDED IN ERROR SET ERROR PARAMETER TO 'Y' */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
                     CHGVAR     VAR(&ERROR) VALUE('Y')
                     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                     SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                MSGDTA(&MEM) TOMSGQ(MOPERQ)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/* ABNORNAL TERMINATION PROCESSING */
/**/
 ABNOR:      SNDPGMMSG  MSG('CLOSE OF BUSINESS REQUEST HALT PROGRAM +
                          TERMINATED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGVAR     VAR(&ERROR) VALUE('Y')
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
 ENDPGM:     ENDPGM
