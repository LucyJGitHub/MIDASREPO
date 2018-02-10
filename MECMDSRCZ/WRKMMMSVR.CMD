/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(ME2100)    VLDCKR(*NONE)       MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(WRKMMMSVR)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas ME Work with Midas Message Manager Server')     */
/*********************************************************************/
/*                                                                   */
/*       Midas Message Management                                    */
/*                                                                   */
/*       WRKMMMSVR - Work with Midas Message Manager Server          */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 236309             Date 03Nov05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025  *CREATE    Date 15Apr02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       236309 - Add ACTION value '*MIDASCOB'.                      */
/*       CSW025 - Midas Message Manager                              */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Work Midas Message Mgr Server')
 
/*********** PARM       KWD(ACTION) TYPE(*CHAR) LEN(9) RSTD(*YES) +  */                   /*236309*/
/************************ VALUES(*STARTUP *SHUTDOWN) MIN(1)          */                   /*236309*/
/************************ PROMPT('Required action')                  */                   /*236309*/
                                                                                          /*236309*/
             PARM       KWD(ACTION) TYPE(*CHAR) LEN(9) RSTD(*YES) +
                          VALUES(*STARTUP *SHUTDOWN *MIDASCOB) +
                          MIN(1) PROMPT('Required action')                                /*236309*/
 
