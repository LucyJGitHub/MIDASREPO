/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Check of pgm-name for pgm-text')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0151  - RETRIEVE PROGRAM DESCRIPTION                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01379             DATE 17SEP92              */
/*       PREV AMEND NO.                    DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&PGMN &PGMTXT &PGMOK)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGMTXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PGMOK) TYPE(*CHAR) LEN(1)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Use RTVOBJD to get program name   */
/* */
             RTVOBJD    OBJ(&PGMN) OBJTYPE(*PGM) TEXT(&PGMTXT)
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* */
/* Pgm does not exist so exit */
/* */
             GOTO       CMDLBL(END)
             ENDDO
 
/* */
/* Pgm found so set return flag */
/* */
             CHGVAR     VAR(&PGMOK) VALUE('Y')
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0151 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
