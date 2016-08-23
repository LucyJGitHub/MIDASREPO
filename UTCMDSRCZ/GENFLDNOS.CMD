/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC9004) VLDCKR(UTC9004_VC)                             */
/*EXI    HLPPNLGRP(GENFLDNOS) HLPID(GENFLDNOS)                       */
/*EXI *  TEXT('Midas UT Generate field numbers from field names')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       GENFLDNOS - Generate field numbers from field names         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/*       Last Amend No. CUP021  *RE-WRITE  Date 12Jan03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP021 - Re-write of GENFLDNOS, to make it file driven.     */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Generate field nos from names')
 
             PARM       KWD(APINAME) TYPE(*CHAR) LEN(4) +
                          SPCVAL((*ALL)) MIN(1) FULL(*YES) +
                          PROMPT('API name' 1)
 
             PARM       KWD(SUBM) TYPE(*NAME) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) MIN(0) PROMPT('Submit +
                          to batch')
 
             PARM       KWD(JOBQ) TYPE(QUAL1) MIN(0) EXPR(*NO) +
                          PMTCTL(PMT) PROMPT('Batch job queue to use')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) DFT(QBATCH)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Object Library')
 
 PMT:        PMTCTL     CTL(SUBM) COND((*EQ Y))
             DEP        CTL(&SUBM *EQ 'Y') PARM((&JOBQ *NE +
                          '          '))
 
