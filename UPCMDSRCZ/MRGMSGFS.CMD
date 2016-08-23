/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC2090)    VLDCKR(*NONE)      MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(MRGMSGFS)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Merge all message files from prompted lib')  */
/*********************************************************************/
/*                                                                   */
/*       Midas Upgrade Module                                        */
/*                                                                   */
/*       MRGMSGFS - Merge all message files from prompted library    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP001 *CREATE     DATE 11Sep98              */
/*       Prev Amend No. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Merge all message files')
 
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(0) +
                          PROMPT('Library containing msg. files' 1)
 
