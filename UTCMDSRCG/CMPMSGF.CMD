/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0026) VLDCKR(UTC0026_VC) MSGF(QCPFMSG)               */
/*EXI    HLPPNLGRP(CMPMSGF) HLPID(*CMD)                              */
/*EXI *  TEXT('Midas UT Compare message files')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CMPMSGF - Compare message files                             */
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
/*                      CUP002 *C *CREATE  Date 08Apr99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CUP002 - Message files utility.                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Compare message files')
 
             PARM       KWD(MSGF) TYPE(QUAL1) MIN(1) +
                          PROMPT('Base Message file(s)')
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(0)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) DFT(*LIBL) +
                          SPCVAL((*LIBL)) MIN(0) PROMPT('Library')
 
             PARM       KWD(MSGF2) TYPE(QUAL2) MIN(0) +
                          PROMPT('Compare Message file(s)')
 QUAL2:      QUAL       TYPE(*GENERIC) LEN(10) DFT(*BASEMSGF) +
                          SPCVAL((*BASEMSGF) (*ALL)) MIN(0)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) DFT(*LIBL) +
                          SPCVAL((*LIBL)) MIN(0) PROMPT('Library')
 
             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*PRINT) VALUES(*PRINT *OUTFILE) +
                          MIN(0) PROMPT('Output')
 
             PARM       KWD(OUTFILE) TYPE(QUAL3) PMTCTL(PMTCTL1) +
                          PROMPT('File to receive output')
 QUAL3:      QUAL       TYPE(*NAME) LEN(10) MIN(0)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) DFT(*LIBL) +
                          SPCVAL((*LIBL)) MIN(0) PROMPT('Library')
 
             PARM       KWD(OUTMBR) TYPE(ELEM1) PMTCTL(PMTCTL1) +
                          PROMPT('Output member options')
 ELEM1:      ELEM       TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST)) PROMPT('Member to +
                          receive output')
             ELEM       TYPE(*CHAR) LEN(8) RSTD(*YES) DFT(*REPLACE) +
                          VALUES(*REPLACE *ADD) PROMPT('Replace or +
                          add records')
 
 PMTCTL1:    PMTCTL     CTL(OUTPUT) COND((*EQ '*OUTFILE'))
