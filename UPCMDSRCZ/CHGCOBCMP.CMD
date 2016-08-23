/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0028)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CHGCOBCMP)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Change CoB components')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Utility                                     */
/*                                                                   */
/*       CHGCOBCMP - Change CoB components                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. CUP014 *CREATE     Date 17Apr01              */
/*       Prev Amend No. nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP014 - Creation of utility to changerun  priority and/or  */
/*                 execution priority.                               */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Change CoB component')
 
             PARM       KWD(EXEPTY) TYPE(*CHAR) LEN(5) RSTD(*NO) +
                          DFT(*SAME) RANGE(1 99) SPCVAL(('*SAME')) +
                          MIN(0) PROMPT('Execution priority' 1)
 
             PARM       KWD(TIMESLICE) TYPE(*CHAR) LEN(8) RSTD(*NO) +
                          DFT(*SAME) RANGE(1 99999999) +
                          SPCVAL(('*SAME')) MIN(0) +
                          PROMPT('Timeslice' 2)
