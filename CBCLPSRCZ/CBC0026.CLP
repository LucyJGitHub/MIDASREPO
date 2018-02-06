/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB monitor menu calling program')           */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0026 - CLOSE OF BUSINESS MONITOR CALLING                 */
/*                 COMPONENT AND ERROR CHECK COMPONENT               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO.                    DATE 00/00/00             */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&PROG &ERROR)
/**/
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* RESET ERROR FIELD TO 'N' AND SET OFF JOB SWITCHES */
/**/
             CHGVAR     VAR(&ERROR) VALUE('N')
             CHGJOB     SWS(00000000)
/**/
/* CALL PROGRAM */
/**/
             CALL       PGM(&PROG)
/**/
/* IF CALLED PROGRAM TIMED OUT SET ERROR PARAMETER TO 'T' */
/**/
             IF         COND(%SWITCH(1XXXXXXX)) THEN(CHGVAR +
                          VAR(&ERROR) VALUE('T'))
/**/
/* IF CALLED PROGRAM ENDED IN ERROR SET ERROR PARAMETER TO 'Y' */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(CHGVAR +
                          VAR(&ERROR) VALUE('Y'))
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
/* ABNORNAL TERMINATION PROCESSING */
/**/
 ABNOR:      SNDPGMMSG  MSG('CLOSE OF BUSINESS MONITOR MENU PROGRAM +
                          TERMINATED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
 ENDPGM:     ENDPGM
