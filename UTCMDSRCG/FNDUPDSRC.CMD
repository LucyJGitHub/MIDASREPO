/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000050)    VLDCKR(UTC000050V)    MSGF(UTMSGF)        */
/*EXI    HLPPNLGRP(FNDUPDSRC)    HLPID(*CMD)                         */
/*EXI    TEXT('Midas UT Find and update multiple source')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       FNDUPDSRC - Scan and replace source                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2012           */
/*                                                                   */
/*       Last Amend No. CUT015 *CREATE     Date 03Jan12              */
/*       Prev Amend No. xxxxxx             Date ddMmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUT015 - New utility to replace UPDSRC.                     */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Find and update multiple src.')
 
             PARM       KWD(MODE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          VALUES(*FND *AMD *UPD) MIN(1) +
                          PROMPT('Mode' 1)
 
             PARM       KWD(WRKLIB) TYPE(*NAME) LEN(10) RSTD(*NO) +
                          MIN(1) PROMPT('Work library' 2)
 
             PARM       KWD(FILE) TYPE(QUAL1) MIN(0) PMTCTL(PMTCTL1) +
                          PROMPT('File(s)')
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*NO) MIN(1) +
                          PROMPT('Library')
 
             PARM       KWD(STR) TYPE(*CHAR) LEN(100) MIN(0) +
                          PMTCTL(PMTCTL1) PROMPT('String to find')
 
             PARM       KWD(CASE) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*MATCH) VALUES(*MATCH *IGNORE) MIN(0) +
                          PMTCTL(PMTCTL1) PROMPT('Kind of match')
 
             PARM       KWD(STRLEN) TYPE(*DEC) LEN(3) DFT(0) +
                          PMTCTL(PMTCTL1) PROMPT('String length')
 
             DEP        CTL(&MODE *EQ '*FND') PARM((&FILE *NE ' ') +
                          (&STR *NE ' ')) MSGID(FUS0001)
 
 PMTCTL1:    PMTCTL     CTL(MODE) COND((*EQ '*FND'))
