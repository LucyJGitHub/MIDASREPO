/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Clear pgm subfile message queue')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control module                       */
/*                                                                   */
/*       SCC0250 -  Clear program message queue.                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01379             DATE 21SEP92              */
/*       PREV AMEND NO.                    DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      S01379 - Common application for message handling.            */
/*               Written as part of HAF development, but not         */
/*               specific to HAF.                                    */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* */
/** GLOBAL MONITOR MESSAGE */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RMVMSG     PGMQ(*PRV) CLEAR(*ALL)
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SCC0250 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
