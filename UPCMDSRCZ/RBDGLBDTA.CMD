/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC003002) VLDCKR(UPC3002_VC) MSGF(QCPFMSG)            */
/*EXI *  TEXT('Midas UP Rebuild global data from zone')              */
/*********************************************************************/
/*                                                                   */
/*  Midas Plus - Bridge                                              */
/*                                                                   */
/*  RBDGLBDTA - Rebuild global data for a zone                       */
/*                                                                   */
/*       (c) Finastra International Limited 2007                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. CSC033  *CREATE    Date 01May07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC033 - Include global libraries in backups                */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Rebuild global data from zone')
 
             PARM       KWD(ZONEID) TYPE(*CHAR) LEN(2) RSTD(*NO) +
                          DFT(*ALL) MIN(0) FULL(*YES) PROMPT('Zone +
                          prefix')
             PARM       KWD(GLOBID) TYPE(*CHAR) LEN(2) RSTD(*NO) +
                          DFT(*ALL) MIN(0) FULL(*YES) +
                          PROMPT('Global prefix')
