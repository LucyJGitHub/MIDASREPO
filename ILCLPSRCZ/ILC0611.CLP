/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Print Tables')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILC0611 - IBLC 2002 - Table of Printing                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX043             Date 28Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&FILE &PROG &FAIL)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MOD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FAIL) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/***  Reset switches and LDA.  ***/
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/***  Set to status indicator to 'failed' (1) ***/
 
             CHGVAR     VAR(&FAIL) VALUE('1')
 
/***  Call program.  ***/
/***    For list of routing key  define the type of routing key ***/
 
             IF         COND((&PROG) *EQ IL0340) THEN(DO)
             CHGVAR     VAR(&MOD) VALUE(%SST(&FILE 5 2))
             CALL       PGM(&PROG) PARM(&MOD 'A' '     ' 'B')
             ENDDO
 
/***    For list for specific files ***/
 
             ELSE   CMD(CALL PGM(&PROG) PARM('A' '     ' 'B'))
 
/***  Monitor for Database Errors (U7 and U8 on).  ***/
/***  Retrieve Error information and set Message data.  ***/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                         RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                         SNDPGMMSG  MSGID(DBE0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                    TOMSGQ(MRUNQ MOPERQ)
                         GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*** Process terminated successfully ***/
 
             CHGVAR     VAR(&FAIL) VALUE('0')
             GOTO       CMDLBL(ENDPGM)
 
/*** Process terminated abnormally ***/
 
 ABNOR:      SNDPGMMSG  MSG('ILC0611 - IBLC 2002 - Print Amended +
                          details program ended Abnormally.') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
 
 ENDPGM:     CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
