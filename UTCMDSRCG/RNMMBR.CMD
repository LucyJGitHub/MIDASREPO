/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0011)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RNMMBR)     HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Rename member command')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       RNMMBR - Command to Rename Members                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 084651  *CREATE    Date 13Mar95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK018   MidasPlus packaging.  Moved to global layer.       */
/*       084651 - Command to rename members.                         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Rename Source/Datafile Members')
 
             PARM       KWD(OLDFILE) TYPE(QUAL) MIN(1) PROMPT('File +
                          Name of Old Member')
 QUAL:       QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library Name')
             PARM       KWD(MBR) TYPE(*NAME) MIN(1) PROMPT('Name of +
                        Old Member')
             PARM       KWD(NEWMBR) TYPE(*NAME) LEN(10) DFT(*MBR) +
                          SPCVAL((*MBR)) MIN(0) PROMPT('Name of New +
                          Member')
             PARM       KWD(NEWFILE) TYPE(QUAL1) PROMPT('File +
                          Name of New Member')
QUAL1:       QUAL       TYPE(*NAME) LEN(10) SPCVAL((*OLDFILE)) DFT(*OLDFILE)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library Name')
             PARM       KWD(DELETE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          VALUES(*YES *NO) DFT(*NO) PROMPT('Delete +
                          Old Member ?')
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(50) +
                          PROMPT('''Description'' of New Member')
