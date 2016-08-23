/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Send program message for M.subfiles')           */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Common processing                          */
/*                                                                   */
/*          ZM1001 - SEND PROGRAM MESSAGE FOR MESSAGE SUBFILES       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*          LAST AMEND NO. 067383    DATE   17OCT95                  */
/*                                                                   */
/********************************************************************/
/*                                                                   */
/*     067383 - ZM1001 FALLS OVER BECAUSE MSGF MEMSG IS NOT FOUND.   */
/*              MUST USE GBMEMSG INSTEAD TO MEMSG.                   */
/*                                                                   */
/********************************************************************/
 
             PGM        PARM(&@MSGID &@MSDTA)
 
             DCL        VAR(&@MSGID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@MSDTA) TYPE(*CHAR) LEN(78)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             IF         COND(&@MSGID *NE ' ') THEN( +
             SNDPGMMSG  MSGID(&@MSGID) MSGF(GBMEMSG))                 /*067383*/
/************SNDPGMMSG  MSGID(&@MSGID) MSGF(MEMSG)) */                /*067383*/
             ELSE       CMD(SNDPGMMSG MSG(&@MSDTA))
 
 GOTO END
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
