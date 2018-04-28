/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC01000)                                               */
/*EXI    TEXT('Midas UT Error Messages Reference Stack Generation')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       GENEMSTK - Error Messages References Stack Generation       */
/*                  Launcher                                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CBF011  *CREATE    Date 04Jul11              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CBF011 - BF Infrastructure: Error Message Handling          */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Stack Generation Launcher')
 
             PARM       KWD(LIBLST) TYPE(*CHAR) LEN(10) MAX(250) +
                          MIN(1) PROMPT('Source Libraries to be added')
 
             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('System Prefix')
 
             PARM       KWD(OBJNAM) TYPE(*CHAR) LEN(10) DFT(*ALL) +
                          SPCVAL(*ALL) PROMPT('Object Name')
 
