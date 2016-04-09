/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC003006) VLDCKR(UPC3006_VC) MSGF(QCPFMSG)             */
/*EXI *  TEXT('Midas UP Update global data for a zone')              */
/*********************************************************************/
/*                                                                   */
/*  Midas Plus - Bridge                                              */
/*                                                                   */
/*  UPDGLBDTA - Replace global data with data from restored          */
/*                library                                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2007           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CSC033  *CREATE    Date 01May07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC033 - Include global libraries in backups                */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Replace global data for zone')
 
             PARM       KWD(ZONEID) TYPE(*CHAR) LEN(2) RSTD(*NO) +
                          DFT(*ALL) MIN(0) FULL(*YES) PROMPT('Zone +
                          prefix')
             PARM       KWD(RSTGMLIB) TYPE(*CHAR) LEN(10) RSTD(*NO) +
                          DFT(*ALL) MIN(0) PROMPT('Library with +
                          restored GMLIB')
