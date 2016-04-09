/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Restart COB after halt & signoff')           */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0075  RESTART COB AFTER HALT & SIGNOFF HAS OCCURED       */
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
             PGM        PARM(&STREAM)
/**/
             DCL        VAR(&DUMMY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STREAM) TYPE(*DEC) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* RESET JOB SWITCHES BEFORE CALL */
/**/
             CHGJOB SWS(XXXXXX00)
/**/
/* CALL CB0070 */
/**/
             CALL CB0070
/**/
/* CALL CBC0085 PARAMETER 'Y' TO RESET CBDTQB. */
/*              PARAMETER &DUMMY - NOT USED IN THIS PROGRAM */
/**/
             CALL       PGM(CBC0085) PARM('Y' &STREAM &DUMMY)
/**/
/* GOTO ENDPGM IF CBC0085 TERMINATED NORMALLY */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO ENDPGM)
/**/
/* ABNORMAL PROCESSING */
/**/
ABNOR:       SNDPGMMSG  MSG('CBC0075 - RESTART OF COB +
             AFTER HALT TERMINATED ABNORMALLY') +
             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      ENDPGM
