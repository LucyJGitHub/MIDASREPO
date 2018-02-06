/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(AAC0100)                                                */
/*EXI *  TEXT('Midas AA Analysis of a/c postings profit centre')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Analytical Accounting Module                        */
/*                                                                   */
/*       PRFCANL - Analysis of Account Postings Profit Centre        */
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
/*       Prev Amend No. CAC001 *CREATE     Date 01FEB96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAC001 - Profit Centre Accounting Development:              */
/*                New CMD.                                           */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Analysis of A/C Postings PC')
 
             PARM       KWD(SELPC) TYPE(*CHAR) LEN(4) DFT(*ALL) +
                          PGM(*YES) PROMPT('Select Profit Centre')
 
             PARM       KWD(OMTPC) TYPE(*CHAR) LEN(4)          +
                          PGM(*YES) PROMPT('Omit Profit Centre')
 
             PARM       KWD(SHWON) TYPE(*CHAR) LEN(1) DFT(N) +
                          PGM(*YES) PROMPT('Show only non zero A/C +
                          bals')
 
             PARM       KWD(INCRN) TYPE(*CHAR) LEN(1) DFT(N) +
                          PGM(*YES) PROMPT('Include Retail & Nostro +
                          A/Cs')
