/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Customer Loans Repair')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lendiing Module                            */
/*                                                                   */
/*       LEC0214  - Customer Loans Repair                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CLE034             Date 05May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CAP053  *CREATE    Date 12Mar01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE034 - Lending Enhancements.                              */
/*       CAP053 - Lending API enhancements - Loans Input             */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&TSTMP) TYPE(*CHAR) LEN(26)                                   /*CLE034*/
 
             OVRDBF     FILE(LEILONLX) TOFILE(LEILONL2) SHARE(*NO)
 
/*********** CALL       PGM(LE2030) PARM('F' 'LOAN' ' ' ' ')                              /*CLE034*/
             CALL       PGM(LE2030) PARM('F' 'LOAN' ' ' ' ' &TSTMP)                       /*CLE034*/
             DLTOVR     FILE(*ALL)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
