/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC002030)   VLDCKR(UPC002030V)  MSGF(UTMSGF)           */
/*EXI    HLPPNLGRP(CVTSRCNAM)   HLPID(CVTSRCNAM)                     */
/*EXI *  TEXT('Midas UP Convert source name for MidasPlus')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       CVTSRCNAM - Convert source name for MidasPlus               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *CREATE    Date 07Jun04              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  New utility.                 */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Convert src. name - MidasPlus')
 
             PARM       KWD(FROMLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('From library:' 1)
 
             PARM       KWD(TOLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('To library:' 2)
