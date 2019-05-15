/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000012)    VLDCKR(UTC000012V)    MSGF(UTMSGF)        */
/*EXI    HLPPNLGRP(RMVSRCHEX)    HLPID(*CMD)                         */
/*EXI    TEXT('Midas UT Remove invalid hex values from source')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       RMVSRCHEX - Remove invalid hex from source                  */
/*                                                                   */
/*       (c) Finastra International Limited 2007                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUT015  *CREATE    Date 13Jun07              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUT015 - New utility.  Part of take on of ClearCase.        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Remove invalid hex from source')
 
             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) +
                          PROMPT('File(s)' 1)
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) MIN(1) +
                          PROMPT('Library')
 
             PARM       KWD(MBR) TYPE(*GENERIC) LEN(10) +
                          SPCVAL((*ALL)) MIN(1) PROMPT('Member(s)' 2)
 
             PARM       KWD(CHGINPLC) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*NO *YES) MIN(0) +
                          PROMPT('Change in place ?')
 
             PARM       KWD(REPORT) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*NO *YES) MIN(0) +
                          PROMPT('Report changes ?')
 
             PARM       KWD(NEWLIB) TYPE(*CHAR) LEN(10) MIN(0) +
                          PMTCTL(PMTCTL1) PROMPT('New library for +
                          changed source')
 
             DEP        CTL(&CHGINPLC *EQ '*NO') PARM((&NEWLIB *NE ' +
                          ')) MSGID(PTF0008)
 
 PMTCTL1:    PMTCTL     CTL(CHGINPLC) COND((*EQ '*NO'))
 
