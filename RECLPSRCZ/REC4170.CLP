/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Val User profile on supervisor override')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4170 - Midas RE Val User profile on supervisor override  */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRT026  *CREATE    Date 4OCt05               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRT026 - Retail Teller Password Change                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&USER &PWORD &ERRC)
 
/** Declare variables */
 
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PWORD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HNDL) TYPE(*CHAR) LEN(12)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&ERRC) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSIZ) TYPE(*UINT) LEN(4)
             DCL        VAR(&CCS) TYPE(*DEC) LEN(5)
             DCL        VAR(&CCSID) TYPE(*UINT) LEN(4)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&HNDL) VALUE(*BLANKS)
             CHGVAR     VAR(&RTCD) VALUE(*BLANKS)
             CHGVAR     VAR(&PSIZ) VALUE(10)
             RTVJOBA    CCSID(&CCS)
             CHGVAR     VAR(&CCSID) VALUE(&CCS)
 
/**/
/* CHECK IF PASSWORD CORRECT */
/**/
             CALL       PGM(QSYGETPH) PARM(&USER &PWORD &HNDL &RTCD +
                          &PSIZ &CCSID)
             CHGVAR     VAR(&ERRC) VALUE(%SUBSTRING(&RTCD 9 7))
 ABNOR:
/**/
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
