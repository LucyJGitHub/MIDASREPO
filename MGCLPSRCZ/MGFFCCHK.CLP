/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Obtain F/F conf flag from SDMGMEPD')            */
/*********************************************************************/
/*                                                                   */
/*   Midas    MESSAGE GENERATION                             */
/*                                                                   */
/*   MGFICHK - Check SDMGMEPD for free-format confs flag             */
/*   Called by DLC04                                                 */
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
 
PGM          PARM(&AFIELD)
 
             DCL        VAR(&AFIELD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(SDMGMEPD)
 
/* Program reads SDMGMEPD and returns F/F conf flag in 1A parm */
             RCVF
             CHGVAR     VAR(&AFIELD) VALUE(&ENFFCR)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
