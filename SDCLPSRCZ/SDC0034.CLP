/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Select Account Codes different from TF')              */
/*********************************************************************/
/*                                                                   */
/*       Midas EXPOSURE MANAGEMENT MODULE                            */
/*                                                                   */
/*       CTI002  - MIDAS OVERRIDE DATABASE FILE FOR SDACODL1         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CTI002             Date 01Sep98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       CTI002 - EXPOSURE MANAGEMENT PHASE II                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CDE &ACC_CDE)
 
             DCL        VAR(&RTN_CDE) TYPE(*CHAR) LEN(7)
/**********  DCL        VAR(&ACC_CDE) TYPE(*CHAR) LEN(4)             */                   /*CGL029*/
             DCL        VAR(&ACC_CDE) TYPE(*CHAR) LEN(10)                                 /*CGL029*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             OVRDBF     FILE(SDACODL1) TOFILE(SDACODL6)
 
             CALL       PGM(SD0033S) PARM(&RTN_CDE &ACC_CDE)
 
             DLTOVR     FILE(SDACODL1)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
