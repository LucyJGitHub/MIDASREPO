/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SCC3011) VLDCKR(SCC3011VC)                              */
/*EXI    HLPPNLGRP(SCSFEATMNT) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas SC Call specific switchable feature maint')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCSFEATMNT - Command to Allow Users to Call the Various     */
/*                    Switchable Feature Maintanance Functions       */
/*                    Directly.                                      */
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
/*       Prev Amend No. CSC007  *CREATE    Date 01Oct98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC007 - Allow switchable features to be maintained         */
/*                whether on or off                                  */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Switchable Feature Maintenance')
 
             PARM       KWD(SARD) TYPE(*CHAR) LEN(50) MIN(0) +
                          CASE(*MIXED) PROMPT('Feature')
 
             PARM       KWD(SARN) TYPE(*NAME) LEN(6) MIN(1) +
                          FULL(*NO) PROMPT('Switchable Feature ID:')
 
             PARM       KWD(CORE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          VALUES('C' 'N') MIN(1)  PROMPT('Core or Non-Core')
 
 PMT0:       PMTCTL     CTL(SARN) COND((*EQ 000000))
             PARM       KWD(PGM) TYPE(*NAME) LEN(10) MIN(0) +
                          FULL(*NO) DSPINPUT(*YES) PMTCTL(PMT0) +
                          PROMPT('Program to Run:')
