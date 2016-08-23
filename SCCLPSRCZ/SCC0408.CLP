/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Change Journal Receivers')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SCC0408 - Change Journal Receivers                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01495 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       S01495 - COB Enhancements.                                  */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('Change Journal Receivers') TOMSGQ(MOPERQ)
/**/
/*  Call SCC1716 to change journal receivers                       */
/**/
/************CALL*******PGM(SCC1716) PARM(0)************************************************CSC020*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
             GOTO       CMDLBL(END)
/**/
/** Global error processing                                        */
/**/
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Call to SCC1716 to change journal +
                          receivers  ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
