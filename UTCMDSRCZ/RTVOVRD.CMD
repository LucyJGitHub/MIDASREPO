/*STD    CMDBASE                                                     */
/*EXI    PGM(RTVOVRD)                                                */
/*EXI    TEXT('Retrieve Override Description')                       */
/*===================================================================*/
/*                                                                   */
/*       Midas Utilities                                             */
/*                                                                   */
/*       RTVOVRD - Retrieve Override Description Validation          */
/*                                                                   */
/*       (c) Finastra International Limited 2012                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134  *CREATE    Date 01Aug12              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing                      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Retrieve Override Description')
 
             PARM       KWD(FILE) TYPE(*CHAR) LEN(10) MIN(1) MAX(1) +
                          PROMPT('File' 1)
 
             PARM       KWD(TOFILE) TYPE(*CHAR) LEN(10) +
                          PASSATR(*YES) PROMPT('To File' 2)
             PARM       KWD(TOLIB)  TYPE(*CHAR) LEN(10) +
                          PASSATR(*YES) PROMPT('To Library' 3)
             PARM       KWD(MBR)    TYPE(*CHAR) LEN(10)  +
                          PROMPT('To Member' 4)
 
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(10) +
                          PASSATR(*YES) PROMPT('Override Type' 5)
 
             PARM       KWD(STATUS) TYPE(*CHAR) LEN(1) +
                          PASSATR(*YES) PROMPT('Status' 6)
/*===================================================================*/
