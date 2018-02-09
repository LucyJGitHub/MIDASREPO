/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0010)   VLDCKR(UTC0010_VC) MSGF(QCPFMSG)             */
/*EXI    HLPPNLGRP(CHGOBJ)     HLPID(*CMD)                           */
/*EXI    TEXT('Midas UT Change object description')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       CHGOBJ - Change object description                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUT008  *REWRITE   Date 18Jan11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 23Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK008             Date 04JUL97              */
/*                      074291             DATE 08AUG94              */
/*                      S01516             DATE 18JUL94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUT008   CRTOBJ rewrite.                                    */
/*                Allow change of source member name to an object.   */
/*                Source file, library need not to be specified.     */
/*       CPK018   MidasPlus packaging.  Moved to global layer.       */
/*       CPK014   Release 4 Packaging                                */
/*                Allow all object types to be changed + add         */
/*                validity checker                                   */
/*       CPK008   DBA R2 Packaging                                   */
/*                Allow ILE object types                             */
/*       074291   Further enhancements to CRTOBJ                     */
/*       S01516   Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Change Object Source File')
 
             PARM       KWD(OBJ) TYPE(QUAL1) MIN(1) PROMPT('Object')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Object Library')
             PARM       KWD(OBJTYP) TYPE(*CHAR) LEN(7) MIN(1) +
                          PROMPT('Object Type')
             PARM       KWD(NEWFIL) TYPE(*NAME) LEN(10) DFT(*SAME) +
                          SPCVAL((*SAME)) PROMPT('New Source File')
             PARM       KWD(NEWLIB) TYPE(*NAME) LEN(10) DFT(*SAME) +
                          SPCVAL((*SAME)) PROMPT('New Source +
                          Library')
             PARM       KWD(NEWMBR) TYPE(*NAME) LEN(10) DFT(*SAME) +
                          SPCVAL((*SAME)) MIN(0) PROMPT('New Source +
                          Member')
             PARM       KWD(SRCLSTCHG) TYPE(*CHAR) LEN(13) +
                          PMTCTL(*PMTRQS) PROMPT('Source +
                          Change,CYYMMDDHHMMSS')
