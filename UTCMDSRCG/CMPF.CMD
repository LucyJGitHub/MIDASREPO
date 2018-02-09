/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000003)    VLDCKR(UTC000003V)    MSGF(QCPFMSG)       */
/*EXI    HLPPNLGRP(CMPF)         HLPID(*CMD )                        */
/*EXI    TEXT('Midas UT Compare two database files')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities                                           */
/*                                                                   */
/*       CMPF - Compare two database files                           */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021155           Date 03Jun13              */
/*                      A1076141           Date 11Jan13              */
/*                      BUG27790  *CREATE  Date 17Jun10              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - Allow compare where there is no unique key.      */
/*       A1076141 - Parameters rearranged to make entry mandatory.   */
/*       BUG27790 - New utility                                      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Compare two database files')
 
             PARM       KWD(FILE1) TYPE(Q1) MIN(1) PROMPT('First +
                          file' 1)
             PARM       KWD(FILE2) TYPE(Q1) MIN(1) PROMPT('Second +
                          file' 3)
 
             PARM       KWD(TFILE) TYPE(Q1) MIN(1) PROMPT('File name +
                          for field template' 5)
 
/**********  PARM       KWD(KEYFLD) TYPE(*CHAR) LEN(5) RSTD(*YES) +                  */ /*MD021155*/
/**********               VALUES(*FILE *FLD *RRN) MIN(1) +                           */ /*MD021155*/
/**********               PROMPT('Key fields for comparison' 7)             */ /*A1076141 MD021155*/
             PARM       KWD(KEYFLD) TYPE(*CHAR) LEN(5) RSTD(*YES) +
                          VALUES(*FILE *FLD *RRN *NONE) MIN(1) +
                          PROMPT('Key fields for comparison' 7)                         /*MD021155*/
 
             PARM       KWD(MBROVR) TYPE(*NAME) LEN(10) DFT(*CURUSR) +
                          SPCVAL((*CURUSR)) PROMPT('Member name +
                          used for override' 6)
 
/**********  PARM       KWD(KEYFLD) TYPE(*CHAR) LEN(5) RSTD(*YES) +                  */ /*A1076141*/
/**********               VALUES(*FILE *FLD *RRN) MIN(1) +                           */ /*A1076141*/
/**********               PROMPT('Key fields for comparison' 7)                      */ /*A1076141*/
 
             PARM       KWD(MBR1) TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST)) MIN(0) PROMPT('Member' 2)
             PARM       KWD(MBR2) TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST)) MIN(0) PROMPT('Member' 4)
 
             PARM       KWD(IGNMTCH) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) PROMPT('Ignore +
                          matching records ?' 8)
 
             PARM       KWD(DSPNODIF) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) PROMPT('Display +
                          if no differences ?' 9)
 
             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*) VALUES(* *PRINT *OUTFILE) +
                          PROMPT('Output' 10)
 
             PARM       KWD(RPTFLDNO) TYPE(*CHAR) LEN(1) DFT(0) +
                          RANGE(0 9) SPCVAL((*ALL A)) +
                          PROMPT('Report field numbers' 11)
 
             PARM       KWD(KEYF) TYPE(Q1) PMTCTL(PMTCTL1) +
                          PROMPT('Keyed file' 12)
 
 Q1:         QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')
 
             PARM       KWD(FLD) TYPE(*NAME) LEN(10) MIN(0) MAX(12) +
                          PMTCTL(PMTCTL2) PROMPT('Fields for key' 13)
 
             PARM       KWD(OUTFILE) TYPE(Q2) MIN(0) PMTCTL(PMTCTL3) +
                          PROMPT('File to receive output' 14)
             PARM       KWD(OUTMBR) TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST)) MIN(0) PMTCTL(PMTCTL3) +
                          PROMPT('Member to receive output' 15)
 
 Q2:         QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) SPCVAL((*LIBL)) +
                          PROMPT('Library')
 
 PMTCTL1:    PMTCTL     CTL(KEYFLD) COND((*EQ '*FILE'))
 PMTCTL2:    PMTCTL     CTL(KEYFLD) COND((*EQ '*FLD'))
 
 PMTCTL3:    PMTCTL     CTL(OUTPUT) COND((*EQ '*OUTFILE'))
 
