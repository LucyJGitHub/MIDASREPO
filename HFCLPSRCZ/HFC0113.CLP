/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Check object in library')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0113  - CHECK FOR OBJECT EXISTANCE                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01379             DATE 15SEP92              */
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
 
             PGM        PARM(&FOBJ &FLIB &FTYP &FOK)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&FOBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FTYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FOK) TYPE(*CHAR) LEN(1)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Use CHKOBJ on received parms */
/* */
             CHKOBJ     OBJ(&FLIB/&FOBJ) OBJTYPE(&FTYP)
 
/* */
/* Not found so set return flag */
/* */
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CHGVAR     VAR(&FOK) VALUE('N')
             ENDDO
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0113 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
