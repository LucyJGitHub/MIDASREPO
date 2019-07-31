/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(GOBSANEXC)  VLDCKR(GOBSPLPVC)                           */
/*EXI *  TEXT('Midas GO BSPL Analysis Prompt')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOBSANPMT - BSPL Analysis Prompt                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGP010  *CREATE    Date 17Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGP010 - Global BSPL                                        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('BSPL Analysis Prompt')
 
             PARM       KWD(RQTYP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(I) VALUES(I) PROMPT('Request Type')
 
             PARM       KWD(RQID) TYPE(*CHAR) LEN(15) +
                          PROMPT('Request ID')
 
             PARM       KWD(RRQID) TYPE(*CHAR) LEN(15) +
                          PROMPT('Related Request ID')
 
             PARM       KWD(ZNGL) TYPE(*CHAR) LEN(1) +
                          PROMPT('Zone or Global')
 
             PARM       KWD(BRC) TYPE(*CHAR) LEN(3) +
                          PROMPT('Branch Code')
             PARM       KWD(BRGRP) TYPE(*CHAR) LEN(15) PROMPT('Branch +
                          Group')
             PARM       KWD(BRCON) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Branch +
                          Consolidation')
 
             PARM       KWD(RPSET) TYPE(*CHAR) LEN(15) +
                          PROMPT('BSPL Report Set')
             PARM       KWD(HDPTH) TYPE(*CHAR) LEN(2) DFT(99) +
                          PROMPT('Hierarchy Depth')
             PARM       KWD(CHART) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Chart of +
                          Accounts')
 
             PARM       KWD(RELPN) TYPE(*CHAR) LEN(3) PROMPT('Relative Period Number')
             PARM       KWD(CYR)  TYPE(*CHAR) LEN(2) PROMPT('Calendar Year')
             PARM       KWD(CMTH) TYPE(*CHAR) LEN(2) PROMPT('Calendar Month')
 
             PARM       KWD(RPTYP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(B) VALUES(B M) PROMPT('Report Type')
             PARM       KWD(RMDUR) TYPE(*CHAR) LEN(1) PROMPT('Report Movements Duration')
 
             PARM       KWD(INTCDT) TYPE(INTC) PROMPT('INTERIM +
                          Currency Type')
 
             PARM       KWD(REPCDT) TYPE(REPC) PROMPT('REPORT +
                          Currency Type')
 
             PARM       KWD(ACDBD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Account Code +
                          Breakdown')
             PARM       KWD(PRTZB) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Print Zero +
                          Balances')
             PARM       KWD(ROUND) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(U) VALUES(N U T) PROMPT('Rounding')
 
             PARM       KWD(IFCTFR) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Include For. +
                          Currency Transfer')
             PARM       KWD(IBCTFR) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Include Base +
                          Currency Transfer')
 
             PARM       KWD(INSID) TYPE(*CHAR) LEN(10) +
                          PROMPT('Instruction ID')
 
             PARM       KWD(DESC) TYPE(*CHAR) LEN(50) +
                          PROMPT('Description')
 
             PARM       KWD(EXPRT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Export')
 
             PARM       KWD(SUBMIT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Submit')
 
             PARM       KWD(NEXTSEQ) TYPE(*CHAR) LEN(5) PROMPT('Next +
                          Sequence')
 
 INTC:       QUAL       TYPE(*NAME) LEN(1) RSTD(*YES) VALUES(N B D)
             QUAL       TYPE(*CHAR) LEN(3)  PROMPT('Currency')
             QUAL       TYPE(*CHAR) LEN(1)  PROMPT('Currency Conversion Method:')
             QUAL       TYPE(*CHAR) LEN(10) PROMPT('Currency Nominated Zone:')
 REPC:       QUAL       TYPE(*NAME) LEN(1) RSTD(*YES) VALUES(A B H D)
             QUAL       TYPE(*CHAR) LEN(3)  PROMPT('Currency')
             QUAL       TYPE(*CHAR) LEN(1)  PROMPT('Currency Conversion Method:')
             QUAL       TYPE(*CHAR) LEN(10) PROMPT('Currency Nominated Zone:')
