/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0210)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CPYFRMOUTQ) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Copy from output queue command')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       CPYFRMOUTQ (Copy from output queue) command                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CAA002 *CREATE     Date 31OCT95              */
/*       Prev Amend No. nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
/* The Copy From Output Queue command takes the spooled files       */
/*   in a single output queue and copies them to data base          */
/*   members of a specific file. The file can then be saved.        */
/*   The companion command CPYTOOUTQ can be used to reprint the     */
/*   files. The support is limited to DP output only (eg no         */
/*   graphics or special print functions).                          */
/*                                                                  */
/* The CPP is UTC0210.                                             */
/*                                                                  */
             CMD        PROMPT('Copy from OUTQ')
             PARM       KWD(OUTQ) TYPE(QUAL1) MIN(1) +
                          PROMPT('Output queue')
             PARM       KWD(OUTFILE) TYPE(QUAL2) MIN(1) +
                          PROMPT('Output file')
             PARM       KWD(DLTSPLF) TYPE(*CHAR) LEN(4) DFT(*NO) +
                          RSTD(*YES) VALUES('*YES' '*NO') +
                          PROMPT('DLTSPLF option')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) SPCVAL(*LIBL) +
                          EXPR(*YES) PROMPT('Library name')
 QUAL2:      QUAL       TYPE(*NAME) LEN(10) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*CURLIB) +
                          SPCVAL(*CURLIB) +
                          EXPR(*YES) PROMPT('Library name')
