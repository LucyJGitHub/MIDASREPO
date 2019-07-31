/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000018) VLDCKR(UTC000018V) MSGF(UTMSGF)              */
/*EXI    HLPPNLGRP(SNDSPLF) HLPID(*CMD)                              */
/*EXI    TEXT('Midas UT Send spool file to e-mail')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       SNDSPLF - Send spool file to e-mail                         */
/*                                                                   */
/*       (c) Finastra International Limited 2010                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP039  *CREATE    Date 15Nov10              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP039 - New utility.                                       */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Send spool file to e-mail')
 
             PARM       KWD(FILE) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Spooled file name' 1)
 
             PARM       KWD(TOINTNET) TYPE(*CHAR) LEN(64) MIN(1) +
                          MAX(10) CASE(*MIXED) PROMPT('Internet +
                          recipient' 4)
 
             PARM       KWD(JOB) TYPE(QUAL1) DFT(*) SNGVAL((*)) +
                          MIN(0) PROMPT('Job name' 2)
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(0)
             QUAL       TYPE(*NAME) LEN(10) MIN(0) PROMPT('User')
             QUAL       TYPE(*CHAR) LEN(6) RANGE(000000 999999) +
                          MIN(0) PROMPT('Number')
 
             PARM       KWD(SPLNBR) TYPE(*CHAR) LEN(6) DFT(*ONLY) +
                          RANGE(1 99999) SPCVAL((*ONLY) (*LAST)) +
                          MIN(0) PROMPT('Spooled file number' 3)
 
