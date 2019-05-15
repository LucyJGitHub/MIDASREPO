/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000001)    VLDCKR(UTC000001V)    MSGF(UTMSGF)        */
/*EXI    HLPPNLGRP(CMPSRC)       HLPID(*CMD)                         */
/*EXI *  TEXT('Midas UT Compare source file members to print')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CMPSRC - Compare source file members                        */
/*                                                                   */
/*       (c) Finastra International Limited 2007                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. BUG27884 *CREATE   Date 08Jul10              */
/*                      CUT010             Date 10May07              */
/*                      xxxxxx             Date ddMmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27884 - Applied CUT010                                   */
/*       CUT010 - New utility.                                       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Compare source file member')
 
             PARM       KWD(REFSRCF) TYPE(ELEM1) MIN(1) +
                          PROMPT('Reference source file(s)' 1)
 ELEM1:      ELEM       TYPE(QUAL1) MIN(1) PROMPT('File(s)')
             ELEM       TYPE(*CHAR) LEN(10) DFT(*ALL) +
                          SPCVAL(('*ALL')) PROMPT('Member(s)')
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) DFT(*ALL) +
                          SPCVAL((*ALL)) MIN(0)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) DFT(*LIBL) +
                          SPCVAL((*LIBL)) MIN(0) PROMPT('Library')
 
             PARM       KWD(CMPSRCF) TYPE(ELEM2) MIN(0) +
                          PROMPT('Comparison source file(s)' 2)
 ELEM2:      ELEM       TYPE(QUAL2) MIN(0) PROMPT('File(s)')
             ELEM       TYPE(*CHAR) LEN(10) DFT(*REF) SPCVAL((*ALL) +
                          (*REF)) PROMPT('Member(s)')
 QUAL2:      QUAL       TYPE(*GENERIC) LEN(10) DFT(*REF) +
                          SPCVAL((*REF) (*ALL)) MIN(0)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) DFT(*LIBL) +
                          SPCVAL((*LIBL)) MIN(0) PROMPT('Library')
 
             PARM       KWD(MOVEDLINES) TYPE(*CHAR) LEN(4) DFT(*YES) +
                          SPCVAL((*YES) (*NO)) MIN(0) +
                          PROMPT('Display moved lines ?' 5)
 
             PARM       KWD(CMPBLNK) TYPE(*CHAR) LEN(4) DFT(*NO) +
                          SPCVAL((*YES) (*NO)) MIN(0) +
                          PROMPT('Compare blank lines ?' 6)
 
             PARM       KWD(NOOFLINES) TYPE(*DEC) LEN(4) DFT(5) +
                          RANGE(0 9999) MIN(0) PROMPT('Matching +
                          lines to display' 7)
 
