/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0230)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CVTOUTQ)    HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Convert WRKOUTQ to a DB file command')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       CVTOUTQ (Convert out put queue) command                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 23Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAA002 *C *CREATE  Date 31Oct95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
/* The CVTOUTQ command converts the WRKOUTQ listing to a data base  */
/*   file with one record per spooled file. The command is release  */
/*   dependent: it was developed at OS/400 V3R1M0.                  */
/*   The output file is called OUTQP.                               */
/*                                                                  */
/* The CPP is the CL program UTC0230 which calls the RPG            */
/*   program UT0030. The physical file is CVOQPD.                   */
/*                                                                  */
             CMD        PROMPT('Convert Output Queue')
             PARM       KWD(OUTQ) TYPE(QUAL1) MIN(1) +
                          SNGVAL((*NONE)) PROMPT('Output queue')
             PARM       KWD(OUTLIB) TYPE(*NAME) EXPR(*YES) +
                          DFT(*LIBL) SPCVAL(*LIBL) +
                          PROMPT('Library for OUTQP file')
             PARM       KWD(OUTMBR) TYPE(*NAME) LEN(10) DFT(OUTQP) +
                          EXPR(*YES) PROMPT('Member to receive output')
             PARM       KWD(REPLACE) TYPE(*CHAR) LEN(4) DFT(*YES) +
                          RSTD(*YES) VALUES(*YES *NO) +
                          PROMPT('Replace data in member')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) EXPR(*YES) +
                          PROMPT('Library name')
