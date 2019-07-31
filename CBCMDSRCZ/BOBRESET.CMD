/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CBC0071) VLDCKR(*NONE) MSGF(QCPFMSG)                    */
/*EXI    HLPPNLGRP(BOBRESET) HLPID(*CMD)                             */
/*EXI *  TEXT('Midas CB Reset COB to run from NDSU BOB save')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Module                            */
/*                                                                   */
/*       BOBRESET - Reset COB Data to Rerun from BOB Save.           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 097895  *CREATE    Date 02Jan96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       097895 - New command to reset the COB data for a BOB save   */
/*                rerun.                                             */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Reset COB Data for BOB Save')
 
             PARM       KWD(MODE) TYPE(*CHAR) LEN(1) CONSTANT(R)
 
             PARM       KWD(RETURN) TYPE(*CHAR) LEN(10) CONSTANT(' ')
 
/*/COPY WNCPYSRC,BOBRESET01                                          */
