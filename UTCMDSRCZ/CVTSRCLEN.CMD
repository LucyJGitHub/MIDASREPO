/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0080)    VLDCKR(UTC0080_VC) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CVTSRCLEN)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Convert source length')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CVTSRCLEN - Command to convert source file length from one  */
/*                    value to another                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP001 *CREATE     Date 21Dec98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Convert Source File Length')
 
             PARM       KWD(SRCFILE) TYPE(QUAL1) MIN(0) MAX(1) +
                          PROMPT('Source file:')
             PARM       KWD(LENGTH) TYPE(*DEC) LEN(3 0) DFT(112) +
                          RANGE(92 132) PROMPT('Length:')
             PARM       KWD(NEWLIB) TYPE(*NAME) LEN(10) DFT(*SRCLIB) +
                          SPCVAL((*SRCLIB)) MIN(0) MAX(1) +
                          PROMPT('To library:')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) DFT(*ALL) SPCVAL((*ALL)) +
                          MIN(0)
             QUAL       TYPE(*NAME) LEN(10) MIN(1) PROMPT('From +
                          library:')
