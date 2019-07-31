/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SCC002471)                                              */
/*EXI    HLPPNLGRP(SCWRTJREG)     HLPID(*CMD)                        */
/*EXI *  TEXT('Midas SC Command to write journal sequence')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCWRTJREG - Write journal sequence number of an event       */
/*                  to file SCJSEQPD.                                */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC020  *CREATE    Date 31Mar04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC020 - Journaling changes for MidasPlus                   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Write journal sequence number')
 
             PARM       KWD(EVENT) TYPE(*NAME) LEN(20) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Standard event +
                          description:')
 
             PARM       KWD(COMP) TYPE(*CHAR) LEN(10) MIN(0) +
                          PROMPT('CoB component:')
 
             PARM       KWD(CMPSEQ) TYPE(*DEC) LEN(5) PROMPT('CoB +
                          component sequence')
 
             PARM       KWD(FLAG) TYPE(*CHAR) LEN(1) MIN(0) +
                          CASE(*MIXED) PROMPT('Event flag')
 
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(50) MIN(0) +
                          FULL(*NO) PROMPT('Event text')
