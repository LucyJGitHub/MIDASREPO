/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Retrv. Text for multilanguage  MSGID')          */
/*********************************************************************/
/*                                                                   */
/*  Midas - Multiple Language Support Module                 */
/*                                                                   */
/*  SDRTVTXT - RETRIEVE TEXT FOR MULTILANGUAGE                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO.  E29436                    DATE 11OCT91           */
/*  PREV AMEND NO.  S01253                    DATE 09FEB90           */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  E29436  -  MOVED TO SOURCE FILE SCCLSRC FROM SDCLSRC.            */
/*  S01253  -  MULTILANGUAGE INCORPORATION                           */
/*                                                                   */
/*********************************************************************/
     PGM PARM(&MSGDNB &MSGNM &MSGTXT)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
     DCL VAR(&MSGDNB) TYPE(*CHAR) LEN(7)
     DCL VAR(&MSGNM) TYPE(*CHAR) LEN(10)
     DCL VAR(&MSGTXT) TYPE(*CHAR) LEN(80)
     RTVMSG MSGID(&MSGDNB) MSGF(&MSGNM) MSG(&MSGTXT)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
     ENDPGM
