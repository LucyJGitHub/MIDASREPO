/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SE0031)  ALLOW(*IPGM *IREXX *IMOD)                      */
/*EXI    HLPPNLGRP(CSE031ON)     HLPID(*CMD )                        */
/*EXI *  TEXT('Midas SE Switch on feature CSE031')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading module                           */
/*                                                                   */
/*       CSE031ON - Switch on feature CSE031                         */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CSE031  *CREATE    Date 05Apr02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE031 - Coupon Fixing for Floating Rate Notes              */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Switch on feature CSE031')
 
             PARM       KWD(MODE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          VALUES(*OFF *ON) MIN(1) PROMPT('Switching +
                          feature on or off?')
 
             PARM       KWD(AUTOFIX) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          VALUES(*YES *NO) MIN(1) PROMPT('Auto fix')
 
             PARM       KWD(BDC) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          VALUES(C F M N) MIN(1) PROMPT('Business +
                          day convention')
 
/*/COPY WNCPYSRC,CSE031ON01                                          */
