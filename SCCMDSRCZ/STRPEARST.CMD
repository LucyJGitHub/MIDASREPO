/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SCC000112) MSGF(UTMSGF)                                 */
/*EXI    TEXT('Midas SC PEA Start Full Restore')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       STRPEACPY - Start PEA Full Restore                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2012           */
/*                                                                   */
/*       Last Amend No. CSC054   *CREATE    Date 23Feb12             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC054 - Period End Adjustments                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Start PEA Full Restore')
 
             PARM       KWD(KCMD) TYPE(*CHAR) LEN(7) +
                          CONSTANT('       ')
