/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ Add message to program subfile msgq')        */
/*********************************************************************/
/*                                                                   */
/*   Midas - MidasQ MODULE                                   */
/*                                                                   */
/*   MQC0060 - SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES             */
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
/*   PREV AMEND NO. S01182                 DATE 01MAY90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   S01182  -  NEW PROGRAM INTRODUCED FOR MIS                       */
/*                                                                   */
/*********************************************************************/
/**/
         PGM        PARM(&@MSGID &@MSDTA)
/**/
         DCL        VAR(&@MSGID) TYPE(*CHAR) LEN(10)
         DCL        VAR(&@MSDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/**SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES**/
         SNDPGMMSG  MSGID(&@MSGID) MSGF(MQERRORMSG) MSGDTA(&@MSDTA)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
