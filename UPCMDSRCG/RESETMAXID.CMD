/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC000003)    VLDCKR(UPC000003V) MSGF(QCPFMSG)          */
/*EXI    HLPPNLGRP(RESETMAXID)   HLPID(*CMD)                         */
/*EXI *  TEXT('Midas UP Reset values for auto-generated fields')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       RESETMAXID - Reset values for auto-generated fields         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP030  *CREATE    Date 16Dec04              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP030 - New utility for MidasPlus                          */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Reset vals. for auto-gen. flds')
 
             PARM       KWD(FILE) TYPE(QUAL) MIN(1) PROMPT('File')
 
             PARM       KWD(RSTOPT) TYPE(*CHAR) LEN(7) DFT(*RSTMAX) +
                          RANGE(1 9999999) SPCVAL((*RSTALL) +
                          (*RSTMAX)) MIN(0) PROMPT('Reset options')
 
 QUAL:       QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')
 
