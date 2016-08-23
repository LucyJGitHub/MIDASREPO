/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Add message to pgm subfile MSGQ')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control module                       */
/*                                                                   */
/*       SCC0240 - Send program message for message subfiles.        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01379        DATE 21SEP92                   */
/*       PREV AMEND NO.               DATE ddmmmyy                   */
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
             PGM        PARM(&@MSGID &@MSGFL)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&@MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&@MSGFL) TYPE(*CHAR) LEN(10)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSGID(&@MSGID) MSGF(&@MSGFL)
 
             MONMSG     MSGID(CPF2469) EXEC(SNDPGMMSG MSGID(CPF9898) +
                          MSGF(QCPFMSG) MSGDTA('Unable to send +
                          message' *BCAT &@MSGID))
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SCC0240 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
