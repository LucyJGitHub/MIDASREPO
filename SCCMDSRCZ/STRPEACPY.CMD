/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SCC000112) MSGF(UTMSGF)                                 */
/*EXI    TEXT('Midas SC PEA Start Restore (Copy Data)')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       STRPEACPY - PEA Start Restore (Copy Data)                   */
/*                                                                   */
/*       (c) Finastra International Limited 2012                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC054  *CREATE    Date 23Feb12              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC054 - Period End Adjustments                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Start PEA Restore (Copy Data)')
 
             PARM       KWD(KCMD) TYPE(*CHAR) LEN(7) +
                          CONSTANT('*COPYDB')
