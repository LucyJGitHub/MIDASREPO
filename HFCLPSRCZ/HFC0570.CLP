/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Ovrparms for on request print')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0570  - OVERRIDE PARMS FOR ON REQUEST PRINT              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01379             DATE 18SEP92              */
/*       PREV AMEND NO.                    DATE                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
 
/*********************************************************************/
 
             PGM        PARM(&STRING)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&OUTQN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&COPI) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(200)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AUD) TYPE(*CHAR) LEN(27)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Retrieve variables from JRN2 */
/* */
             RTVDTAARA  DTAARA(JRN2 (54 10)) RTNVAR(&OUTQN)
             RTVDTAARA  DTAARA(JRN2 (64 10)) RTNVAR(&OUTQL)
             RTVDTAARA  DTAARA(JRN2 (76 4)) RTNVAR(&HOLD)
             RTVDTAARA  DTAARA(JRN2 (80 4)) RTNVAR(&SAVE)
             RTVDTAARA  DTAARA(JRN2 (74 2)) RTNVAR(&COPI)
 
/* */
/* Get user name */
/* */
             RTVJOBA    USER(&USER)
 
 
             CHGVAR     VAR(&AUD) VALUE('Audit Requested by:' *CAT +
                          &USER)
 
/* */
/* Build command string */
/* */
             CHGVAR     VAR(&STRING) VALUE(' OVRPRTF    +
                          FILE(HF0310P1) OUTQ(' *CAT &OUTQL *TCAT +
                          '/' *CAT &OUTQN *TCAT ') COPIES(' *CAT +
                          &COPI *TCAT ') HOLD(' *CAT &HOLD *TCAT ') +
                          SAVE(' *CAT &SAVE *TCAT ')  SECURE(*YES) +
                          PRTTXT(''' *CAT &AUD *TCAT ''') USRDTA(' +
                          *CAT &USER *TCAT ')')
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0570 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
