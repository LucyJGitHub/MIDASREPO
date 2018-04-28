/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1313)    VLDCKR(RPC1313_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPSETFFD)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas RP PB Output File Field Desc in RPMSGFPD.')     */
/*********************************************************************/
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPSETFFD - Prepare Meridian script importation.             */
/*                                                                   */
/*       Function: this command allows to output, in database file   */
/*                 RPMSGFPD, field-level information for a file to   */
/*                 be available for entire file formatting routine.  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Ouput File Field Description')
 
             PARM       KWD(INTERFACE) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Interface control member')
 
             PARM       KWD(FILE) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('File Name')
 
             PARM       KWD(REPLACE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Replace +
                          previous definition')
