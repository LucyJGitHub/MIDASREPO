/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC000135)  VLDCKR(UPC000135V) MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(MODPGMXCHK)     HLPID(*CMD)                       */
/*EXI *  TEXT('Midas UP Cross check module and program sources')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       MODPGMXCHK - Cross check module and program sources         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP029 *CREATE     Date 21Sep04              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP029 - Utility to cross check module and program sources  */
/*                in a library.                                      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('X-Check Modules and Programs')
 
             PARM       KWD(SRCLIB)   TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library containing sources')
 
             PARM       KWD(LAYER)    TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          VALUES(*BOTH *GLOBAL *ZONE *NONE) MIN(1) +
                          PROMPT('Layer')
 
             PARM       KWD(FULLDELV) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          VALUES(*YES *NO) MIN(1)  +
                          PROMPT('Full delivery?')
