/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0030)     VLDCKR(UTC0030_V)      MSGF(UTMSGF)        */
/*EXI    HLPPNLGRP(CLRDBLIB)     HLPID(*CMD)                         */
/*EXI *  TEXT('Midas UT Clear database library')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CLRDBLIB - Clear database library                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 31Mar04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Prev Amend No. CSM002 *CREATE     Date 22Nov02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSM002 - Refresh options from the Bridge.                   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Clear database library')
 
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library')
 
