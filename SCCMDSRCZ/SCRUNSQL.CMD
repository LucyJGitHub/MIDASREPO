/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SCRUNSQL)                                               */
/*EXI    TEXT('SC Run Dynamic SQL Statement')                        */
/*********************************************************************/
/*                                                                   */
/*  Midas - System Control Module                                    */
/*                                                                   */
/*  SCRUNSQL - Run dynamic SQL statement                             */
/*                                                                   */
/*       (c) Finastra International Limited 2012                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CGL127  *CREATE    Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  CGL127 - General Ledger  Module optimisation - Phase 1           */
/*                                                                   */
/*********************************************************************/
            CMD        PROMPT('Run Dynamic SQL Statement')
 
             PARM       KWD(SQL) TYPE(*CHAR) LEN(5000) MIN(1) +
                          EXPR(*YES) VARY(*YES *INT2) CASE(*MIXED) +
                          PROMPT('SQL Statement to execute')
