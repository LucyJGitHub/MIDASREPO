/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0045)      VLDCKR(UTC0045_V)     MSGF(UTMSGF)        */
/*EXI    HLPPNLGRP(RSTJRNENV)    HLPID(*CMD)                         */
/*EXI    TEXT('Midas UT Reset journaling environment')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0045 - Reset journaling environment                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CUP002  *MOVED     Date 25Aug10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/*       Prev Amend No. CUP021  *CREATE    Date 10Jan03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP002 - Moved to global layer.                             */
/*       CUP021 - Automation of system refresh                       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Reset journaling environment')
 
             PARM       KWD(MIDASSYSID) TYPE(*CHAR) LEN(2) MIN(0) +
                          PROMPT('Midas system ID')
 
