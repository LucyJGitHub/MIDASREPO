/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SMC001000) HLPPNLGRP(CONSQLD) MSGF(UTMSGF)              */
/*EXI    HLPID(*CMD)    VLDCKR(SMC001003)                            */
/*EXI    TEXT('Midas SM Consolidate SQL file deliveries')            */
/*********************************************************************/
/*                                                                   */
/*       Midas SM Utilities Menu Command                             */
/*                                                                   */
/*       CONSQLD -  Consolidate SQL Scripts                          */
/*                                                                   */
/*       (c) Finastra International Limited 2013                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1076132 *CREATE  Date 18Feb13              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1076132 - Automate SQL delivery deployment                */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Consolidate SQL Scripts')
 
             PARM       KWD(SQLFS) TYPE(*CHAR) LEN(10) MAX(25) +
                          MIN(1) PROMPT('Process SQL Files')
 
             PARM       KWD(GLZN) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*GLOBAL) VALUES(*GLOBAL *ZONE) +
                          PROMPT('For Layer')
 
/*********************************************************************/
