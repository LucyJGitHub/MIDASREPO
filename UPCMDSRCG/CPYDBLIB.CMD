/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0259)    VLDCKR(UPC0259_VC) MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(CPYDBLIB)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Copy from one database library to another')  */
/*********************************************************************/
/*                                                                   */
/*       Midas Upgrade Module                                        */
/*                                                                   */
/*       CPYDBLIB - Copy from one database library to another        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK024             Date 13Feb06              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 13Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CPK009 *CREATE     DATE 08Jul99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK024 - Moved source from UPPNLSRCZ for MP1.2.1 release    */
/*                packaging.                                         */
/*       CPK015 - 4.01 packaging.  Improvements to CPYDBLIB.         */
/*       CPK009 - Installation of DBA3.00                            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Copy data between libraries')
 
             PARM       KWD(FROMLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Library to copy data from')
             PARM       KWD(TOLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Library to copy data to')
/************PARM       KWD(CRTFILE) TYPE(*CHAR) LEN(4) RSTD(*YES) +                   */ /*CPK015*/
/************             DFT(*NO) VALUES(*NO *YES) PROMPT('Create +                   */ /*CPK015*/
/************             file if not there?')                                         */ /*CPK015*/
             PARM       KWD(CRTITEM) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Create +
                          item if not there?')                                            /*CPK015*/
             PARM       KWD(RERUN) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Re-run +
                          of copy?')                                                      /*CPK015*/
             PARM       KWD(SYSPFX) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*NO *YES) PROMPT('Change +
                          system prefix?')
 
             PARM       KWD(EXCEPTION) TYPE(QUAL1) MIN(0) MAX(20) +
                          PROMPT('Exceptions during copying')                             /*CPK015*/
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(0)                                        /*CPK015*/
             QUAL       TYPE(*CHAR) LEN(8) RSTD(*YES) DFT(*FILE) +
                          VALUES(*FILE *DTAARA *DTAQ) +
                          PROMPT('Object type')                                           /*CPK015*/
 
             PARM       KWD(EXCPTACT) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*SKIP) VALUES(*SKIP *SUBMIT) +
                          PROMPT('Exception action')                                      /*CPK015*/
             PARM       KWD(JOBQ) TYPE(QUAL2) MIN(0) +
                          PMTCTL(PMTCTL01) PROMPT('Job queue')                            /*CPK015*/
QUAL2:       QUAL       TYPE(*NAME) LEN(10) MIN(0)                                        /*CPK015*/
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) DFT(*LIBL) +
                          SPCVAL((*LIBL)) MIN(0) PROMPT('Library')
PMTCTL01:    PMTCTL     CTL(EXCPTACT) COND((*EQ '*SUBMIT'))                               /*CPK015*/
 
             PARM       KWD(THRESHOLD) TYPE(*DEC) LEN(2) DFT(95) +
                          RANGE(01 99) PMTCTL(*PMTRQS) PROMPT('End +
                          copy at system storage %')
 
             PARM       KWD(JUMP) TYPE(*DEC) LEN(2) DFT(1) RANGE(1 +
                          10) PMTCTL(*PMTRQS) PROMPT('End copy if +
                          storage jumps %')
