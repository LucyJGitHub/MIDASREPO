/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME BIC Excluded phrases maintenance')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management                                  */
/*                                                                   */
/*       MEC1630 - MIDAS OVERRIDE DATABASE FILE FOR MEXPHRL0         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. CFT007  *CREATE    Date 27Oct99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CFT007 - BIC Database Plus Integration                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             OVRDBF     FILE(MEXPHRLR) TOFILE(MEXPHRL0) SHARE(*NO)
 
             CALL       PGM(ME1630)
 
             DLTOVR     FILE(MEXPHRLR)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
