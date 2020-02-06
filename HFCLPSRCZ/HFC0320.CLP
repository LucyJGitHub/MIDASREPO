/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Check authority on outqueue')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0320  - CHECK EXISTANCE OF OUTQ                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01379             Date 17Sep92              */
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&OUTQN &OUTQL &OK)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&OUTQN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OK) TYPE(*CHAR) LEN(1)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Set up Default return code of OK */
/* */
             CHGVAR     VAR(&OK) VALUE('Y')
 
/* */
/* Check existance of OUTQ and authorities     */
/* */
             CHKOBJ     OBJ(&OUTQL/&OUTQN) OBJTYPE(*OUTQ) AUT(*READ +
                          *ADD *UPD)
 
/* */
/* If not found or not authorised set return code to not OK    */
/* */
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&OK) VALUE('N'))
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0320 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
