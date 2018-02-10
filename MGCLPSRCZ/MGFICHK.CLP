/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Obtain FRA/IRS module flag')                    */
/*********************************************************************/
/*                                                                   */
/*   Midas    MESSAGE GENERATION                             */
/*                                                                   */
/*   MGFICHK - Check SDMMODPD for FRA/IRS module flag                */
/*   Called by DLC0604                                               */
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
/*   PREV AMEND NO.  00000            DATE 00XXX00                   */
/*                   00000            DATE 00XXX00                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/********************************************************************/
 
PGM          PARM(&FION)
 
             DCL        VAR(&FION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(SDMMODPD)
 
/* Program reads SDMMODPD and returns FRA/IRS module flag in 1A parm */
             RCVF
             CHGVAR     VAR(&FION) VALUE(&BGFIIN)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
