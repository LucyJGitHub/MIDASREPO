/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Build log file for scan parms')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0550  - BUILD LOG FILE FOR SCAN PGMS                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 083166             DATE  3APR95              */
/*       PREV AMEND NO. S01379             DATE 18SEP92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       083166 - Unable to determine the effect of using scan       */
/*                conditions on report and on screen.                */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
/*********** PGM                                                   */ /*083166*/
             PGM        PARM(&ITEM)                                   /*083166*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)               /*083166*/
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)                  /*083166*/
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(10)                /*083166*/
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */                                                                 /*083166*/
/* Get library ID and build the HFLIB variable */                     /*083166*/
/* */                                                                 /*083166*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)             /*083166*/
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')          /*083166*/
                                                                      /*083166*/
/* */
/* Delete work files from QTEMP if they are there */
/* */
             DLTF       FILE(QTEMP/HFSCANL0)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/HFSCANL1)
             MONMSG     MSGID(CPF0000)
 
/* */
/* Copy from HFSCANL1 to the src file JRNDUMMY to create src for */
/* HFSCANL0 */
/* */
/*********** CPYF       FROMFILE(QTEMP/JRNDUMMY) +                 */ /*083166*/
/***********              TOFILE(QTEMP/JRNDUMMY) FROMMBR(HFSCANL1) +/ /*083166*/
/***********              TOMBR(JRNDUMMY) MBROPT(*REPLACE)         */ /*083166*/
             CPYF       FROMFILE(&HFLIB/JRNDDS) +
                          TOFILE(QTEMP/JRNDUMMY) FROMMBR(&ITEM) +
                          TOMBR(JRNDUMMY) MBROPT(*REPLACE)            /*083166*/
 
 
/* */
/* Now can create the file HFSCANL0 */
/* */
             CRTLF      FILE(QTEMP/HFSCANL0) SRCFILE(QTEMP/JRNDUMMY) +
                          SRCMBR(JRNDUMMY) DTAMBRS((QTEMP/HFSCANPD +
                          (HFSCANPD))) OPTION(*NOSOURCE *NOLIST) +
                          LVLCHK(*NO)
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0550 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
