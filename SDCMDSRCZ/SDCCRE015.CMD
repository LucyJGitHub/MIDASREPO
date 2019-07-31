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
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CRE015 *CREATE     Date 18Dec09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE015 - Retail Term & Notice Accounts                      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Initialise CRE015')
 
             PARM       KWD(INITAL) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Clear +
                          files & initialise data?')
 
