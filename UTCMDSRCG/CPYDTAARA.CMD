/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0072)    VLDCKR(UTC0072_VC) MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(CPYDTAARA)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Copy one data area to another')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CPYDTAARA - Copy one data area to another                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP001 *CREATE     DATE 11Sep98              */
/*       Prev Amend No. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Copy one data area to another')
 
             PARM       KWD(FMDTAARA) TYPE(QUAL1) MIN(1) +
                          PROMPT('Data area to be copied')
             PARM       KWD(TODTAARA) TYPE(QUAL1) MIN(1) +
                          PROMPT('Data area to receive data')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library name')
