/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0050)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(UTRMVEMBR)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Remove empty members from a source')         */
/*********************************************************************/
/*                                                                   */
/*       Midas Utilities Module                                      */
/*                                                                   */
/*       UTRMVEMBR - Remove Empty Members from a Source File         */
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
/*       Prev Amend No. S01516  *CREATE    Date 31Aug95              */
/*                      000000             Date 00Xxx00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01516 - New command for this change.                       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Remove Empty Members from Src')
 
             PARM       KWD(SRCFILE) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Source File:')
 
             PARM       KWD(SRCLIB) TYPE(*NAME) MIN(1) +
                          PROMPT('Source Library')
 
             PARM       KWD(UPDATE) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          VALUES(N Y) MIN(1) PROMPT('Update +
                          Existing File')
