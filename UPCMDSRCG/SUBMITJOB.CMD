/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0012) MSGF(UTMSGF) ALLOW(*IPGM *IREXX *IMOD)         */
/*EXI    HLPPNLGRP(SUBMITJOB)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Submit job (Y or N)')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       SUBMITJOB - Submit job?                                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015 *CREATE     Date 23Mar02              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK015 - 4.01 packaging.                                    */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Submit Job?')
 
             PARM       KWD(SUBMITJOB) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          VALUES(*NO *YES) MIN(1) PROMPT('Submit +
                          job?' 1)
