/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0220)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CRTUSRSPC)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Create user space command')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       CRTUSRSPC (Create user space) command                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAA002 *CREATE     Date 31OCT95              */
/*                      nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
/*                                                                 */
/* The Create User Space command is a front end to the QUSCRTUS    */
/*   CL program provided by OS/400. This allows a simple entry     */
/*   from a CL program to create a space.                          */
/*                                                                 */
/* The CPP is UTC0220.                                             */
/*                                                                 */
             CMD        PROMPT('Create User Space')
             PARM       KWD(USRSPC) TYPE(QUAL1) MIN(1) +
                          PROMPT('User space name')
             PARM       KWD(EXTATR) TYPE(*NAME) LEN(10) EXPR(*YES) +
                          DFT(*NONE) SPCVAL(*NONE) +
                          PROMPT('Extended attribute')
             PARM       KWD(INLSIZE) TYPE(*DEC) LEN(9 0) +
                          DFT(2000) RANGE(1 16776704) +
                          PROMPT('Initial size in bytes')
             PARM       KWD(INLVALUE) TYPE(*CHAR) LEN(1) DFT(' ') +
                          PROMPT('Initial value')
             PARM       KWD(AUT) TYPE(*CHAR) LEN(10) DFT(*CHANGE) +
                          RSTD(*YES) VALUES('*CHANGE' '*ALL' '*USE' +
                          '*EXCLUDE') +
                          PROMPT('Authority')
             PARM       KWD(DELETE) TYPE(*CHAR) LEN(4) DFT(*NO) +
                          RSTD(*YES) VALUES('*YES' '*NO') +
                          PROMPT('Delete if it exists')
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(50) EXPR(*YES) +
                          DFT(*BLANK) +
                          PROMPT('Text ''description'' ')
QUAL1:       QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*CURLIB) +
                          SPCVAL(*CURLIB) +
                          PROMPT('Library name')
