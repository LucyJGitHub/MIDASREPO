/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000021) VLDCKR(UTC000021V) MSGF(UTMSGF)              */
/*EXI    HLPPNLGRP(MDSPSRVPGM) HLPID(*CMD)                           */
/*EXI    TEXT('Midas UT Display service program info. to file')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       MDSPSRVPGM - Display service program info to file           */
/*                                                                   */
/*       (c) Finastra International Limited 2011                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUT013  *CREATE    Date 18May11              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUT013 - New utility to display service program information */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Display SRVPGM info. to file')
 
             PARM       KWD(SRVPGM) TYPE(QUAL1) MIN(1) +
                          PROMPT('Service program' 1)
 
             PARM       KWD(DETAIL) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES(*MODULE *SRVPGM *PROCEXP *DTAEXP +
                          *ACTGRPEXP *ACTGRPIMP *SIGNATURE +
                          *COPYRIGHT) MIN(1) PROMPT('Detail' 3)
 
             PARM       KWD(OUTFILE) TYPE(QUAL2) MIN(1) PROMPT('File +
                          to receive output' 4)
             PARM       KWD(OUTMBR) TYPE(ELEM1) PROMPT('Output +
                          member options' 5)
 
             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*OUTFILE) VALUES(*OUTFILE) +
                          PROMPT('Output' 2)
 
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*CURLIB) (*ALL) (*ALLUSR) +
                          (*USRLIBL)) MIN(0) PROMPT('Library')
 
 QUAL2:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*CURLIB)) MIN(0) +
                          PROMPT('Library')
 
 ELEM1:      ELEM       TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST)) PROMPT('Member to +
                          receive output')
             ELEM       TYPE(*CHAR) LEN(8) RSTD(*YES) DFT(*REPLACE) +
                          VALUES(*REPLACE *ADD) PROMPT('Replace or +
                          add records')
 
