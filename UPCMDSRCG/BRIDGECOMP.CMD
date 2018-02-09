/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC000110)  VLDCKR(UPC000110V) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(BRIDGECOMP) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP On-screen source compare')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       BRIDGECOMP - On-screen source compare                       */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSM005  *CREATE    Date 07Sep05              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSM005 - New command to control Bridge on-screen compares.  */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Gen. on-screen Bridge compares')
 
             PARM       KWD(GLOBPFX) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('Global prefix')
 
             PARM       KWD(BASLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Base library for comparison')
 
             PARM       KWD(CMPLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Comparison library')
 
             PARM       KWD(MRGLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Library for merged source')
 
             PARM       KWD(WRKLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Work library')
 
             PARM       KWD(JOBD) TYPE(QUAL1) MIN(1) PROMPT('Job +
                          description')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')
