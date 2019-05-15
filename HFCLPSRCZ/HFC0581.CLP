/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Delete reporting group files')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0581  - DELETE HF REPORTING GROUP FILES                  */
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
/*       Prev Amend No. S01379             Date 18Sep92              */
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
 
             PGM        PARM(&ITEMA &JFILE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&ITEMA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FFILE) TYPE(*CHAR) LEN(10)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Get the library group and build HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIB)
             CHGVAR     VAR(&HFLIB) VALUE(&LIB *CAT 'HFLIB')
 
/* */
/* Delete reporting group files */
/* HFRGRPxxx */
/* */
             CHGVAR     VAR(&FILE) VALUE('HFRGBAT' *CAT &ITEMA)
             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF0000)
/* */
/* HFRGRPPxxx */
/* */
             CHGVAR     VAR(&FILE) VALUE('HFRGRPP' *CAT &ITEMA)
             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF0000)
/* */
/* Item 'J' file */
/* */
             DLTF       FILE(&JFILE)
             MONMSG     MSGID(CPF0000)
/* */
/* Item 'J' file */
/* */
             CHGVAR     VAR(&FFILE) VALUE('F' *CAT %SST(&JFILE 2 9))
             DLTF       FILE(&FFILE)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0581 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
