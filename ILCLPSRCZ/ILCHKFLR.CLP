/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IBLC 2002 Check Folder')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - IBLC 2002 Module                                    */
/*                                                                   */
/*       ILCHKFLR - Check Folder                                     */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      ULX043             Date 23Jul01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       ULX043 - IBLC 2002 Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FOLDER &PATH &RETURNCODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2005')
 
/***  Declare variables.  ***/
 
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PATH)   TYPE(*CHAR) LEN(51)
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(7)
 
/***  Check folder existance.  ***/
 
             CHKDLO     DLO(&FOLDER) FLR(&PATH) OBJTYPE(*FLR) -
                        AUT(*CHANGE)
 
/***  Folder does not exist.  ***/
 
             MONMSG     MSGID(CPF8A77) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPF8A77'))
 
/***  User not authorized to use folder.  ***/
 
             MONMSG     MSGID(CPF8A75) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPF8A75'))
 
/* List argument not valid*/
 
             MONMSG     MSGID(CPD0047) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPD0047'))
 
/* Name not valid          */
 
             MONMSG     MSGID(CPF0001) EXEC(CHGVAR VAR(&RETURNCODE) +
                          VALUE('CPD8A97'))
 
/***  Command failed.   ***/
 
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR +
                          VAR(&RETURNCODE) VALUE('OTHER  '))
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2005')
             MONMSG     MSGID(CPF0000)
             ENDPGM
