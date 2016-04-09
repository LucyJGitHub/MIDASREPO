/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0350)    VLDCKR(UTC0351)    MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(CHGCCSIDS)  HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Change the CCSIDs of selected objects')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilites                                            */
/*                                                                   */
/*       CHGCCSIDS - Change CCSIDs command                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CAA005 *CREATE     Date 02AUG96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CAA005 - This command changes the CCSID of one or more      */
/*                files in a specified library.                      */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Change CCSIDs for a library')
 
             PARM       KWD(LIBRARY) TYPE(*NAME) MIN(1) +
                          PROMPT('Library name')
 
             PARM       KWD(FILE) TYPE(*GENERIC) LEN(10) DFT(*ALL) +
                          SPCVAL((*ALL)) PROMPT('Files to change')
 
             PARM       KWD(NEWCCSID) TYPE(*DEC) LEN(5) DFT(*HEX) +
                          RANGE(1 65535) SPCVAL((*HEX 65535)) +
                          PROMPT('New CCSID')
