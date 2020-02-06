/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(SC002473)                                               */
/*EXI    HLPPNLGRP(SCRTVJCMP)     HLPID(*CMD)                        */
/*EXI *  TEXT('Midas SC Get jrnl sequence of component event')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*      SCRTVJCMP - Retrieve the journal sequence number of a close  */
/*                  of business component event                      */
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
             CMD        PROMPT('Get journal sequence number')
 
             PARM       KWD(COMP) TYPE(*NAME) LEN(10) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Close of business +
                          component:')
 
             PARM       KWD(CSEQ) TYPE(*DEC) LEN(5) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Component sequence:')
 
             PARM       KWD(FLAG) TYPE(*CHAR) LEN(1) MIN(0) +
                          CASE(*MIXED) PROMPT('Event flag:')
 
             PARM       KWD(JOB) TYPE(*NAME) LEN(10) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Job name:')
 
             PARM       KWD(USER) TYPE(*NAME) LEN(10) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Job user:')
 
             PARM       KWD(NUMBER) TYPE(*CHAR) LEN(6) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Job number:')
 
             PARM       KWD(RECEIVER) TYPE(*CHAR) LEN(10) MIN(0) +
                          CASE(*MIXED) PROMPT('Journal receiver:')
 
             PARM       KWD(SEQ) TYPE(*DEC) LEN(10) RTNVAL(*YES) +
                          MAX(1) PROMPT('Journal sequence number:')
