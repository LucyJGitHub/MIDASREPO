/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retrieve Message Text from Message File')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4160 - Retrieves the Message from a Specified Message    */
/*                 File, Message Id and Supplied Message Data        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CRT002  *CREATE    DATE  1DEC95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRT002- Retail Branch Access.                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGID &MSGFL &MSGDT &MSGTX)
/**/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGTX) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LDA)   TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             RTVMSG     MSGID(&MSGID) MSGF(&MSGFL) MSGDTA(&MSGDT) +
                          MSG(&MSGTX)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             RTVMSG     MSGID(USR0600) MSGF(&MSGFL) MSGDTA(&MSGID) +
                          MSG(&MSGTX)
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             CHGVAR     VAR(&MSGTX) VALUE('Message ' *CAT &MSGID *CAT +
                          ' or message file ' *CAT &MSGFL *CAT +
                          ' not found')
             ENDDO
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
