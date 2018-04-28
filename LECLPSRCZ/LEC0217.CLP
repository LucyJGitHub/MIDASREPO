/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Rollover Input Repair')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lendiing Module                            */
/*                                                                   */
/*       LEC0217  - Rollover Input Repair                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE034             Date 05May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CAP062  *CREATE    Date 06Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE034 - Lending Enhancements.                              */
/*       CAP062 - Lending API enhancements - Rollover Input          */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&TSTMP) TYPE(*CHAR) LEN(26)                                   /*CLE034*/
 
             OVRDBF     FILE(LEIROLLX) TOFILE(LEIROLL2) SHARE(*NO)
 
             CALL       PGM(LE2070) PARM('F' 'ROLL' ' ' ' ' &TSTMP)                       /*CLE034*/
/*********** CALL       PGM(LE2070) PARM('F' 'ROLL' ' ' ' ')                              /*CLE034*/
             DLTOVR     FILE(*ALL)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
