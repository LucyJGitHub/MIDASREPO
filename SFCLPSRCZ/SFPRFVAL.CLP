/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('User Profile Validation Program')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Security Profile Facility                           */
/*                                                                   */
/*       CLLE/SFPRFVAL - This program validates whether the User     */
/*                       Profile is a valid user or not              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2007           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BUG13780*Create    Date 23Apr07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG13780 - User Profile has no *USE authority to other      */
/*                 profiles                                          */
/*                                                                   */
/*********************************************************************/
/**/
 START:      PGM        PARM(&USRPRF &ERRMSG)
 
/* Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2007')
/**/
/* Initial Processing */
/**/
             DCL        VAR(&USRPRF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERRMSG) TYPE(*CHAR) LEN(200)
/**/
/* Global Monitor Message  */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))
 
             CHGVAR     VAR(&ERRMSG) VALUE(' ')
/**/
/* Check whether the User Profile is valid or not    */
 
             CHKOBJ     OBJ(&USRPRF) OBJTYPE(*USRPRF)
             MONMSG     MSGID(CPF0000 CPF9999) EXEC(GOTO CMDLBL(ERR))
/**/
/* If the User Profile is not valid print the error message and the job log */
/* and terminate the job */
 
             GOTO       CMDLBL(END)
 
 ERR:
             CHGVAR     VAR(&ERRMSG) VALUE('User Profile does not exists  +
                                            Ask the Security Officer to   +
                                            create the User Profile')
             SNDPGMMSG  MSG('User Profile does not exist. Ask the +
                          Security Officer to create the User +
                          Profile') TOMSGQ(MOPERQ)
             DSPJOBLOG  OUTPUT(*PRINT)
 
 END:        ENDPGM
