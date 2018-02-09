/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Add msg to Pgm Subfile Msg queue')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     Standard Program                              */
/*                                                                   */
/*       ZA0350 - Add msg to Pgm Msg Subfile - with variables.       */
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
/*       Prev Amend No. S01401             Date 03Jun93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01401 - SWIFT Messages MT5xxs - New Program.               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&MSGFL &MSGID &MSGDAT)
/**/
/** DECLARE ALL VARIABLES USED.                                      */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MSGFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDAT) TYPE(*CHAR) LEN(45)
/**/
/** SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES                        */
             SNDPGMMSG  MSGF(&MSGFL) MSGID(&MSGID) MSGDTA(&MSGDAT)
             MONMSG     MSGID(CPF2469) EXEC(SNDPGMMSG MSGID(CPF9898) +
                          MSGF(QCPFMSG) MSGDTA('Unable to send +
                          message' *BCAT &MSGID))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
