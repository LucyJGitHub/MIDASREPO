/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0060)    VLDCKR(UTC0061)    MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(FINDHOOK)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Identify hooks in source member')            */
/*********************************************************************/
/*                                                                   */
/*       Midas Utilities Module                                      */
/*                                                                   */
/*       FINDHOOK - IDENTIFY HOOKS IN SOURCE MEMBER                  */
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
/*       PREV AMEND NO. Xnnnnn *CREATE     DATE ddmmmyy              */
/*                      Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
             CMD        PROMPT('Identify all hooks in member')
 
             PARM       KWD(SRCMBR) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Source Member:' 1)
 
             PARM       KWD(SRCFILE) TYPE(QUAL1) MIN(1) +
                          PROMPT('Source File' 2)
 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library Name:')
             PARM       KWD(RPTTYPE) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          DFT(*LIST) VALUES(*LIST *PLACE *BOTH) +
                          MIN(0) PROMPT('Type of report:' 3)
             PARM       KWD(CPYTYPE) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          DFT(*HOOKS) VALUES(*HOOKS *ALL) MIN(0) +
                          PROMPT('Hooks or all /COPYs?' 4)
             PARM       KWD(SUBM) TYPE(*NAME) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) MIN(0) PROMPT('Submit +
                          to Batch?' 5)
             PARM       KWD(NOOFLINES) TYPE(*DEC) LEN(2) DFT(5) +
                          RANGE(1 25) MIN(0) EXPR(*NO) PMTCTL(PMT1) +
                          PROMPT('No. of lines to display:' 6)
             PARM       KWD(JOBQ) TYPE(*NAME) LEN(10) DFT(QBATCH) +
                          MIN(0) EXPR(*NO) PMTCTL(PMT2) +
                          PROMPT('Batch Job Queue to Use:' 7)
 PMT1:       PMTCTL     CTL(RPTTYPE) COND((*EQ '*PLACE') (*EQ +
                          '*BOTH')) NBRTRUE(*EQ 1)
 
 PMT2:       PMTCTL     CTL(SUBM) COND((*EQ Y))
             DEP        CTL(&SUBM *EQ 'Y') PARM((&JOBQ *NE +
                          '          '))
 
