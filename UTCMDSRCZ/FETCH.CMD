/*********************************************************************/
/*S*D****FETCH********************************************************/                   /*CPK010*/
/*STD    CMDBASE                                                     */                   /*CPK010*/
/*EXI    PGM(UTC0013) VLDCKR(*NONE) MSGF(QCPFMSG)                    */                   /*CPK010*/
/*EXI    HLPPNLGRP(FETCH) HLPID(*CMD)                                */                   /*CPK010*/
/*EXI *  TEXT('Midas UT Fetch latest source from signoff libs')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       FETCH - Fetch latest source member                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Last Amend No. CPK010             Date 08Nov99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01516             DATE 02NOV94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK010 - MDB3 Alpha site enhancements                       */
/*                - Standardisation of creation parameters           */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Fetch Source')
 
             PARM       KWD(MBR) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Source Member')
             PARM       KWD(MOD) TYPE(*NAME) LEN(2) CHOICE('Module +
                          prefix') PROMPT('Module')
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(3) RSTD(*YES) +
                          VALUES(DDS RPG CL CMD DTA) PROMPT('Source +
                          Type')
             PARM       KWD(WRKMBR) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) PROMPT('Work +
                          with Source Member')
             PARM       KWD(DEVSUPP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(S) VALUES(D S) +
                          PROMPT('Development/Support Libraries')
 
             PARM       KWD(TOSRCF) TYPE(QUAL1) PMTCTL(PROMPT1) +
                          PROMPT('To source file')
             PARM       KWD(TOMBR) TYPE(*NAME) LEN(10) DFT(*MBR) +
                          SPCVAL((*MBR)) PMTCTL(PROMPT1) +
                          PROMPT('To Source Member')
             PARM       KWD(OVERWRITE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PMTCTL(PROMPT1) +
                          PROMPT('Overwrite Existing Member')
 
 PROMPT1:    PMTCTL     CTL(WRKMBR) COND((*EQ *YES))
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) DFT(*MBR) SPCVAL((*MBR))
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*CURLIB) (*LIBL)) MIN(0) +
                          PROMPT('Library')
