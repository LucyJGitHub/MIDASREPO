/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(MSC3300)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(WRKMAIF)    HLPID(*CMD)                           */
/*EXI *  TEXT('Midas MS Work with Midas-Alliance interface')         */
/*********************************************************************/
/*                                                                   */
/*       Midas SWIFT Direct Link                                     */
/*                                                                   */
/*       WRKMAIF - Work with Midas-SWIFT Alliance Automated File     */
/*                 Transfer interface                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSW009 *CREATE     Date 25FEB97              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*       CSW009 - Midas-SWIFT Alliance Automated File Transfer       */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Work Midas-Alliance interface')
 
             PARM       KWD(OPERATION) TYPE(*CHAR) LEN(10) +
                          RSTD(*YES) VALUES(*STARTUP *SHUTDOWN +
                          *PROMPT *CHECK) MIN(1) PROMPT('Operation')
 
