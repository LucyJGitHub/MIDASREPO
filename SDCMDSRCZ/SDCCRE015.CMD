/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SDCCRE015A)                                             */
/*EXI *  TEXT('Initialise Midas Retail Term & Notice Feature')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDCCRE015 - Initialise CRE015 Retail Term & Notice          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CRE015 *CREATE     Date 18Dec09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE015 - Retail Term & Notice Accounts                      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Initialise CRE015')
 
             PARM       KWD(INITAL) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Clear +
                          files & initialise data?')
 
