/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI *  TEXT('Midas UP Copy /COPY sources to specified lib')        */
/*E*I****PGM(UPC2035)****VLDCKR(UPC2035_VC)*MSGF(QCPFMSG)*************/                   /*CPK016*/
/*EXI    PGM(UPC0035)    VLDCKR(UPC2035_VC) MSGF(QCPFMSG)            */                   /*CPK016*/
/*EXI    HLPPNLGRP(CPYCPYSRC)      HLPID(*CMD)                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       CPYCPYSRC - Copy /COPYs to specified location               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018             Date 03Mar04              */
/*       Prev Amend No. CPK016             Date 16Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP002 *CREATE     Date 16Apr99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Handle Global layer.         */
/*       CPK016 - Release 5 packaging.  Make command more generic.   */
/*       CUP002 - Introduction of BRIDGE utility                     */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Copy /COPY to Specified locn')
 
             PARM       KWD(FROMLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library to copy from')                                  /*CPK016*/
 
             PARM       KWD(TOLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library to copy to')
 
             PARM       KWD(LAYER) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          VALUES(*GLOBAL *ZONE) MIN(1) PROMPT('Layer')                    /*CPK018*/
