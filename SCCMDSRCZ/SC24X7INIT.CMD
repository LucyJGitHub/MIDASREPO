/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SCC0415) MSGF(UTMSGF)                                   */
/*EXI    HLPPNLGRP(SC24X7INIT)   HLPID(*CMD)                         */
/*EXI *  TEXT('Midas SC 24x7 file initialisation')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SC24X7INIT - 24x7 File Initialisation                       */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CSC011  *CREATE    Date 19Apr02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC011 - New command for 24x7 file initialisation.          */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('24x7 File Initialisation')
 
             PARM       KWD(SUPPID) TYPE(*CHAR) LEN(2) MIN(1) +
                          FULL(*YES) CASE(*MONO) CHOICE('Midas +
                          support system prefix') CHOICEPGM(*NONE) +
                          PROMPT('Support System Id:')
