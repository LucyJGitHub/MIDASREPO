/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0015)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(EXPSRC)     HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Expand source')                              */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       EXPSRC - Expand Source Command                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01516             Date 18Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Expand Source')
 
             PARM       KWD(SRCMBR) TYPE(*GENERIC) LEN(10) +
                          SPCVAL((*ALL)) MIN(1) PROMPT('Source +
                          Member')
 
             PARM       KWD(SRCFILE) TYPE(QUAL1) MIN(1) PROMPT('File +
                          Name')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library Name')
 
             PARM       KWD(SUBM) TYPE(*NAME) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Submit to +
                          Batch')
 
             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          DFT(*) VALUES(* *PRINT) PMTCTL(*PMTRQS) +
                          PROMPT('Output')
 
             PARM       KWD(JOBQ) TYPE(*NAME) LEN(10) DFT(QBATCH) +
                          MIN(0) EXPR(*NO) PMTCTL(PMT1) +
                          PROMPT('Batch Job Queue to Use')
 
 PMT1:       PMTCTL     CTL(SUBM) COND((*EQ Y))
             DEP        CTL(&SUBM *EQ 'Y') PARM((&JOBQ *NE +
                          '          '))
 
