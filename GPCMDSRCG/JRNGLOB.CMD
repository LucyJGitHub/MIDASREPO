/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(GPBEGINJRN) VLDCKR(GPBEGINJ_V) MSGF(UTMSGF)             */
/*EXI    HLPPNLGRP(JRNGLOB)        HLPID(*CMD)                       */
/*EXI *  TEXT('Midas GP Journaling maintenance')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing                                   */
/*                                                                   */
/*       JRNGLOB - Journaling maintenance                            */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. BUG27134 *CREATE   Date 08Oct08              */
/*                      xxxxxx             Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG27134- Command to start, reset or end journaling.        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Journaling maintenance')
 
             PARM       KWD(PFX) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('System prefix' 1)
 
             PARM       KWD(ACTION) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          VALUES(*START *RESET *END) MIN(1) +
                          PROMPT('Journaling action' 2)
 
