/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC00090)                                               */
/*EXI    TEXT('Midas UT BankFusion Data Migration Command')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       BFDATAMG - BankFusion Data Migration Command                */
/*                                                                   */
/*       (c) Finastra International Limited 2011                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CBF011  *CREATE    Date 04Jul11              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CBF011 - BF Infrastructure: Error Message Handling          */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('BF Data Migration Utility')
 
             PARM       KWD(OPTION) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES(CORE CLIENT) MIN(1) PROMPT('Data +
                          Migration for')
 
             PARM       KWD(OVRIDE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) +
                          PROMPT('Process Overridable Errors?')
