/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0098)    VLDCKR(UPC0098_VC) MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(MRGDLVLST)      HLPID(*CMD)                       */
/*EXI *  TEXT('Midas UP Merge driving files')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       MRGDLVLST - Merge two driving files                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CUP005 *CREATE     Date 29Oct99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP005 - Changes for DBA R3.02                              */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Merge two driving files')
 
             PARM       KWD(BASELIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Base lib. containing dlv. list')
 
             PARM       KWD(MRGLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Mrg. lib. containing dlv. list')
 
             PARM       KWD(TGTLIB) TYPE(*CHAR) LEN(10) +
                          DFT(*BASELIB) MIN(0) PROMPT('Target lib. +
                          for dlv. list')
