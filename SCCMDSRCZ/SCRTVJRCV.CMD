/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(SC002475)                                               */
/*EXI    HLPPNLGRP(SCRTVJRCV)     HLPID(*CMD)                        */
/*EXI *  TEXT('Midas SC Get receiver created by a component')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*      SCRTVJRCV - Retrieve the name of a journal receiver attached */
/*              during a CoB component for a particular run date     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC020  *CREATE    Date 31Mar04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC020 - Journaling changes for MidasPlus                   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Get journal receiver name')
 
             PARM       KWD(RUNDAY) TYPE(*DEC) LEN(5) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Midas run day number:')
 
             PARM       KWD(COMP) TYPE(*NAME) LEN(10) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Close of business +
                          component:')
 
             PARM       KWD(CSEQ) TYPE(*DEC) LEN(5) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Component sequence:')
 
             PARM       KWD(RECEIVER) TYPE(*CHAR) LEN(10) +
                          RTNVAL(*YES) MIN(0) CASE(*MIXED) +
                          PROMPT('Journal receiver:')
 
             PARM       KWD(SEQ) TYPE(*DEC) LEN(10) RTNVAL(*YES) +
                          MAX(1) PROMPT('Journal sequence number:')
