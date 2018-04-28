/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0090)    VLDCKR(UPC0091)   MSGF(QCPFMSG)             */
/*EXI    HLPPNLGRP(CRTDLVLST)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Create deliverables list')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       CRTDLVLST - Create Deliverables List                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK020             Date 28Jul04              */
/*       Prev Amend No. CPK018             Date 16Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 29Dec98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK020 - Handle deliverable data.                           */
/*       CPK018 - MidasPlus packaging.  Take out '*NONE' option.     */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create Deliverables List')
 
             PARM       KWD(SRC) TYPE(QUAL1) MIN(1) MAX(10) +
                          PROMPT('Source file')
/*QUAL1:***  QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL) +                         */ /*CPK018*/
/**********               (*NONE)) MIN(1)                                              */ /*CPK018*/
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(1)                      /*CPK018*/
             QUAL       TYPE(*NAME) LEN(10) MIN(1) PROMPT('Library')
 
             PARM       KWD(DLVLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Deliverables library')
 
/**********  PARM       KWD(DFTLIB) TYPE(*CHAR) LEN(8) RSTD(*YES) +                    */ /*CPK020*/
/**********               VALUES('*MPLIB' '*MTLIB' '*CPLIB' +                          */ /*CPK020*/
/**********               '*CTLIB' '*UPLIB' '*UCLIB' '*UTLIB') +                       */ /*CPK020*/
/**********               SPCVAL((*MPLIB MPLIB) (*MTLIB MTLIB) +                       */ /*CPK020*/
/**********               (*CPLIB CPLIB) (*CTLIB CTLIB) (*CPLIB +                      */ /*CPK020*/
/**********               CPLIB) (*CTLIB CTLIB) (*UTLIB UTLIB)) +                      */ /*CPK020*/
/**********               MIN(0) PROMPT('Default program library')                     */ /*CPK020*/
 
             PARM       KWD(DTA) TYPE(*CHAR) LEN(10) DFT(*NONE) +
                          MAX(1) PROMPT('Deliverable data library')                       /*CPK020*/
 
             PARM       KWD(CRTOPT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*ADD) SPCVAL((*ADD) (*REPLACE)) +
                          MIN(0) PROMPT('Create option')
 
             PARM       KWD(PROJECT) TYPE(*CHAR) LEN(10) MIN(0) +
                          PROMPT('Project')
