/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(SC002472)                                               */
/*EXI    HLPPNLGRP(SCRTVJEVT)     HLPID(*CMD)                        */
/*EXI *  TEXT('Midas SC Get journal sequence of event')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCRTVJEVT - Retrieve the journal sequence number of an event*/
/*                  today.                                           */
/*                                                                   */
/*  **************************************************************   */
/*  * If this command is to be changed then the Replication team *   */
/*  * must be informed as they also use it.                      *   */
/*  **************************************************************   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG7286            Date 23May05              */
/*       Prev Amend No. CSC020  *CREATE    Date 31MAR04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG7286 - Receiver name should be a return variable         */
/*       CSC020 - Journaling changes for MidasPlus                   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Get journal sequence number')
 
             PARM       KWD(EVENT) TYPE(*NAME) LEN(20) MIN(0) MAX(1) +
                          FULL(*NO) PROMPT('Standard event +
                          description:')
 
             PARM       KWD(FLAG) TYPE(*CHAR) LEN(1) MIN(0) +
                          CASE(*MIXED) PROMPT('Event flag:')
 
/*********** PARM       KWD(RECEIVER) TYPE(*CHAR) LEN(10) MIN(0) +
                          CASE(*MIXED) PROMPT('Journal receiver:')                         BUG7286*/
             PARM       KWD(RECEIVER) TYPE(*CHAR) LEN(10) +
                          RTNVAL(*YES) MIN(0) CASE(*MIXED) +
                          PROMPT('Journal receiver:')                                    /*BUG7286*/
 
             PARM       KWD(SEQ) TYPE(*DEC) LEN(10) RTNVAL(*YES) +
                          MAX(1) PROMPT('Journal sequence number:')
