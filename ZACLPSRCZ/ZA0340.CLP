/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Add message to pgm subfile message queue')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     UTILITY                                       */
/*                                                                   */
/*       ZA0340 - SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES          */
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
/*       PREV AMEND NO. A46001 *CREATE     DATE 06MAY92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       AMENDMENT HISTORY                                           */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       A46001 - INTRODUCTION OF CUSTOMER ANALYSIS CODE.            * *A46001*/
/*                BNZ SAR (CX00009)                                  * *A46001*/
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&MSGFL &MSGID)
/**/
/** DECLARE ALL VARIABLES USED.                                      */
             DCL        VAR(&MSGFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/** SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES                        */
             SNDPGMMSG  MSGF(&MSGFL) MSGID(&MSGID)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
