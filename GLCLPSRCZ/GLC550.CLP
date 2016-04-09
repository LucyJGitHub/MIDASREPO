/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Spread Profile Maintenance')                    */
/*********************************************************************/
/*                                                                   */
/*  Midas - General Ledger Module                            */
/*                                                                   */
/*  GLC550   - SPREAD PROFILE MAINTENANCE                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  Last Amend No. XXXXX             Date xxXXXxx                    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  XXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       */
/*                                                                   */
/*********************************************************************/
      PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             OVRDBF     FILE(SDFCTLL0) TOFILE(GLFCTLL0) SHARE(*NO)
/**/
             CALL       PGM(GL5500D) PARM(' ' 'M')
/**/
             DLTOVR     FILE(SDFCTLL0)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
      ENDPGM
