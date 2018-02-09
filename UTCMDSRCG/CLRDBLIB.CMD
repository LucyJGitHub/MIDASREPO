/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0030)     VLDCKR(UTC0030_V)      MSGF(UTMSGF)        */
/*EXI    HLPPNLGRP(CLRDBLIB)     HLPID(*CMD)                         */
/*EXI *  TEXT('Midas UT Clear database library')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CLRDBLIB - Clear database library                           */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 31Mar04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      CSM002 *C *CREATE  Date 22Nov02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSM002 - Refresh options from the Bridge.                   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Clear database library')
 
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library')
 
