/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000013)    VLDCKR(UTC000013V)    MSGF(UTMSGF)        */
/*EXI    HLPPNLGRP(CHKSRCHEX)    HLPID(*CMD)                         */
/*EXI    TEXT('Midas UT Check results of RMVSRCHEX')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CHKSRCHEX - Check results of RMVSRCHEX                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/*       Last Amend No. CUT015  *CREATE    Date 15Sep09              */
/*       Prev Amend No. xxxxxx             Date ddMmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUT015 - New utility.                                       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Check results of RMVSRCHEX')
 
             PARM       KWD(OLDLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library before conversion')
 
             PARM       KWD(NEWLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Library after conversion')
 
