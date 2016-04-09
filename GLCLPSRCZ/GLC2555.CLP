/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Set off beginning of month indicator')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     GENERAL LEDGER MODULE                             */
/*                                                                   */
/*       GLC2555 - BEGINNING OF MONTH FLAG SETOFF COMPONENT          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. E21858             DATE 03MAY90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   E21858  -  NEW COB COMPONENT TO SETOFF BEGINNING OF MONTH       */
/*              INDICATOR AFTER SUCCESSFUL POSTINGS DROP AND PURGE.  */
/*                                                                   */
/*********************************************************************/
          PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             SNDPGMMSG  MSG('GLC2555 - Setoff Beginning of Month +
                          Indicator') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
/**/
             CHGDTAARA  DTAARA(GLSTAT (67 1)) VALUE(N)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
          ENDPGM
