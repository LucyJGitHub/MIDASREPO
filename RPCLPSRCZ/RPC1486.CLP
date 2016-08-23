/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Return Midas Run Date from SDBANKPD')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPC1486 - Return Midas Run Date from SDBANKPD               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPB010  *CREATE    Date 16Jan03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPB010 - Avoid DB Error by write message in Trace File      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BJRDNB)
 
             DCL        VAR(&CPYFLD)   TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             DCLF       FILE(SDBANKPD)
 
             RCVF
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
