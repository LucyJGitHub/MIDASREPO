/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA 'Rework in Progress' Msg DL1904')        */
/*********************************************************************/
/*                                                                   */
/* Midas - FRA/IRS Module                                    */
/*                                                                   */
/* DLC1904 - SEND USER STATUS MESSAGE INFORMING OF REWORK            */
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
/* PREV AMEND NO. S01157                  DATE 14/06/88              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   S01157  -  NEW PROGRAM WRITTEN FOR FRA/IRS                      */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             SNDPGMMSG  MSGID(FIS0011) MSGF(DRSMM) TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
             RETURN
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
