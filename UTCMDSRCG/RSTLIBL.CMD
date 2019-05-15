/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0042)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RSTLIBL)    HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Restore saved library list')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       RSTLIBL - Restore Saved Library List                        */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 23Apr04              */
/*                      CSC017  *CREATE    Date 19Feb03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSC017 - Change to 250 library list.                        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Restore Saved Library List')
 
             PARM       KWD(SAVEDLIBL) TYPE(QUAL1) MIN(1) +
                          PROMPT('Saved data queue name')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
 
             QUAL       TYPE(*NAME) LEN(10) DFT(QTEMP) +
                          SPCVAL((*CURLIB)) PROMPT('Library name')
