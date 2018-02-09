/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0400)    VLDCKR(UPC0400_VC) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CMPOUTQ)    HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Compare output queues')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Utility                                     */
/*                                                                   */
/*       CMPOUTQ - Compare contents of two ouput queues              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CUP009 *CREATE     Date 07Aug00              */
/*                      nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP009 - Creation of CMPOUTQ command.  This is a re-write   */
/*                 of CMPCOB.                                        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Compare Output Queues')
 
             PARM       KWD(OUTQ1) TYPE(QUAL1) MIN(1) PROMPT('First +
                          output queue' 1)
 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library Name:')
 
             PARM       KWD(OUTQ2) TYPE(QUAL2) MIN(1) PROMPT('Second +
                          output queue' 2)
 QUAL2:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library Name:')
 
             PARM       KWD(NOTRPTLIN) TYPE(*DEC) LEN(1) DFT(3) +
                          RANGE(0 9) MAX(1) PROMPT('Supress first +
                          lines in report?')
 
             PARM       KWD(RPTCOLDIF) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) MAX(1) +
                          PROMPT('Report column differences?')
 
             PARM       KWD(RPTMOVLIN) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) MAX(1) +
                          PROMPT('Report moved lines?')
