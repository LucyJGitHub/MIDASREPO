/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0041)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(SAVLIBL)    HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Save current library list')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       SAVLIBL - Save Current Library List                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 23Apr04              */
/*       Prev Amend No. CSC017  *CREATE    Date 19Feb03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSC017 - Change to 250 library list.                        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Save Current Library List')
 
             PARM       KWD(SAVDTL) TYPE(QUAL1) MIN(1) +
                          PROMPT('Data queue name')
 
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(50) +
                          PMTCTL(*PMTRQS) PROMPT('Data queue +
                          description')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
 
             QUAL       TYPE(*NAME) LEN(10) DFT(QTEMP) +
                        PROMPT('Library name')
