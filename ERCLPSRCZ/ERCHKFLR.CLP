/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ER CH IRIS Check Folder')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module                           */
/*                                                                   */
/*       ERCHKFLR - Check Folder                                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX040             Date 19Feb01              */
/*                      ULX008             Date 23Feb00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX040 - FIRE - RT30 Generation in Midas                    */
/*                Re-use it                                          */
/*       ULX008 - CSSF Statutory Reporting : Commissariat aux Bourses*/
/*                                                                   */
/*********************************************************************/
 
  START:     PGM        PARM(&FOLDER &PATH &RETURNCODE)
 
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PATH)   TYPE(*CHAR) LEN(51)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
 
/***  Check folder existance.  ***/
 
             CHKDLO     DLO(&FOLDER) FLR(&PATH) OBJTYPE(*FLR) -
                        AUT(*CHANGE)
 
/***  Folder does not exist.  ***/
 
             MONMSG     MSGID(CPF8A77) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPF8A77'))
 
/***  User not authorized to use folder.  ***/
 
             MONMSG     MSGID(CPF8A75) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPD8A75'))
 
/* List argument not valid*/
 
             MONMSG     MSGID(CPD0047) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPD0047'))
 
/* Name not valid          */
 
             MONMSG     MSGID(CPF0001) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPD8A97'))
 
/***  Command failed.   ***/
 
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR +
                          VAR(&RETURNCODE) VALUE('OTHER  '))
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
 
             ENDPGM
