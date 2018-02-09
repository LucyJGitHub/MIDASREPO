/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF FO Account Keys Maintenance')                */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0208  -  FO ACCOUNT KEYS MAINTENANCE                         */
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
/*   PREV AMEND NO. N00000             DATE DDMMMYY                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CHANGE DESCRIPTIONS                                           */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   OVERRIDE FILE AND CALL PROGRAM                                */
/**/
             OVRDBF     FILE(FACKYX) TOFILE(FACKY) SHARE(*NO)
             CALL       PGM(FF0180)
/**/
 ENDCLPGM:   DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
