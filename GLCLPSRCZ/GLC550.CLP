/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Spread Profile Maintenance')                    */
/*********************************************************************/
/*                                                                   */
/*  Midas - General Ledger Module                            */
/*                                                                   */
/*  GLC550   - SPREAD PROFILE MAINTENANCE                            */
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
/*  Prev Amend No. XXXXX             Date xxXXXxx                    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  MD046248 - Finastra Rebranding                                   */
/*  XXXXX - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX       */
/*                                                                   */
/*********************************************************************/
      PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             OVRDBF     FILE(SDFCTLL0) TOFILE(GLFCTLL0) SHARE(*NO)
/**/
             CALL       PGM(GL5500D) PARM(' ' 'M')
/**/
             DLTOVR     FILE(SDFCTLL0)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
      ENDPGM
