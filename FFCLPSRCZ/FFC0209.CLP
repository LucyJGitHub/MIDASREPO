/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Position Profit Centres Maint.')             */
/*********************************************************************/
/*                                                                   */
/*   Midas - Futures and Options Module                      */
/*                                                                   */
/*   FFC0209  -  POSITION PROFIT CENTRES MAINTAINANCE                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.01 Patch E -------------------------------------------*/
/*   LAST AMEND NO. 170520             DATE 25NOV99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   PAST AMEND NO. E27208             DATE 15AUG91                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*   170520  - TRANS11 OVERRIDDEN AS PART OF Y2K SORT ORDER PROBLEM  */
/*   E27208  - NEW PROGRAMME FOR PROFIT CENTRE MAINTAINANCE          */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*   OVERRIDE FILE AND CALL PROGRAM                                */
/**/
             OVRDBF     FILE(FOPCCX) TOFILE(FOPCC) SHARE(*NO)
             OVRDBF     FILE(FOPCKX) TOFILE(FOPCK) SHARE(*NO)
             OVRDBF     FILE(TRANS11X) TOFILE(TRANS11) SHARE(*NO)     /*170520*/
/**/
             CALL       PGM(FF0190)
/**/
             DLTOVR     FILE(FOPCCX)
             DLTOVR     FILE(FOPCKX)
             DLTOVR     FILE(TRANS11X)                                /*170520*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             ENDPGM
