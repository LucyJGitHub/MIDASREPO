/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000015)  VLDCKR(UTC0030_V)  MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(RMVALLTRG)      HLPID(*CMD)                       */
/*EXI *  TEXT('Midas UT remove all triggers from a library')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities                                           */
/*                                                                   */
/*       RMVALLTRG - Removes all triggers from a library             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK020  *CREATE    Date 18Aug04              */
/*       Prev Amend No. xxxxxx             Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK020 - New command to clear down all triggers.  Note that */
/*                this uses the validity checker for CLRDBLIB.       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Remove all triggers')
 
             PARM       KWD(LIBRARY) TYPE(*NAME) LEN(10) MIN(1) +
                          FULL(*NO) PROMPT('Library name')
 
