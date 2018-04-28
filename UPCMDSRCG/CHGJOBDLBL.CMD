/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC0126)    VLDCKR(UPC0126VC)  MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(CHGJOBDLBL) HLPID(*CMD)                           */
/*EXI    ALLOW(*IPGM *IMOD *INTERACT)                                */
/*EXI *  TEXT('Midas UP Change JOBDs' library lists')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       CHGJOBDLBL - Change job descriptions' library lists         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC017  *CREATE    Date 25Feb03              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       CSC017 - changes to handle library lists of 250.            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Change JOBDs'' library lists')
 
             PARM       KWD(SYSPREFIX) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('System prefix')
 
             PARM       KWD(MODE) TYPE(*NAME) LEN(10) DFT(*CORE) +
                          SPCVAL((*CORE) (*ALL) (*ONEBYONE)) MIN(0) +
                          PROMPT('Change which job descriptions?')
 
