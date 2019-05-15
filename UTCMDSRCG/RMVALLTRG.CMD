/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000015)  VLDCKR(UTC0030_V)  MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(RMVALLTRG)      HLPID(*CMD)                       */
/*EXI *  TEXT('Midas UT remove all triggers from a library')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities                                           */
/*                                                                   */
/*       RMVALLTRG - Removes all triggers from a library             */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK020  *CREATE    Date 18Aug04              */
/*                      XXXXXX             Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK020 - New command to clear down all triggers.  Note that */
/*                this uses the validity checker for CLRDBLIB.       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Remove all triggers')
 
             PARM       KWD(LIBRARY) TYPE(*NAME) LEN(10) MIN(1) +
                          FULL(*NO) PROMPT('Library name')
 
