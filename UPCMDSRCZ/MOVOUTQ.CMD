/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0248)    VLDCKR(UPC0248_VC) MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(MOVOUTQ)    HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UP Move contents of one OUTQ to another')       */
/*********************************************************************/
/*                                                                   */
/*       Midas Upgrade Module                                        */
/*                                                                   */
/*       MOVOUTQ - Move contents of one output queue to another      */
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
/*       Prev Amend No. CUP001 *CREATE     DATE 15Sep98              */
/*                      Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Move contents of OUTQ')
 
             PARM       KWD(FMOUTQ) TYPE(QUAL1) MIN(1) PROMPT('OUTQ +
                          with spool files')
             PARM       KWD(TOOUTQ) TYPE(QUAL1) MIN(1) PROMPT('Where +
                          output is to be moved to')
 
             PARM       KWD(CLROUTQ) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*NO *YES) MIN(0) +
                          PROMPT('Clear "to" output queue')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library name')
