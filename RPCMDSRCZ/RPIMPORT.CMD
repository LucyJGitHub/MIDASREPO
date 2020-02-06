/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(RPC1304)    VLDCKR(RPC1304_V)  MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(RPIMPORT) HLPID(*CMD)                             */
/*EXI *  TEXT('Midas RP PB Prepare Meridian script importation.')    */
/*********************************************************************/
/*********************************************************************/
/*                                                                   */
/*       Midas - Private Banking Module                              */
/*                                                                   */
/*       RPIMPORT - Prepare Meridian script importation.             */
/*                                                                   */
/*       Function: this command allows to copy script data in PC     */
/*                 document to database file in QGPL.                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CPB002  *CREATE    Date 01Jun99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Prepare script importation')
 
             PARM       KWD(FOLDER) TYPE(*CHAR) LEN(63) +
                          DFT(MERIDIAN) PROMPT('From folder')
 
             PARM       KWD(FROMDOC) TYPE(*NAME) LEN(12) +
                          DFT(XXXXXXXX.TXT) PROMPT('From document')
 
             PARM       KWD(TOFILE) TYPE(TOFILE) PROMPT('To File')
 
             PARM       KWD(REPLACE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Replace +
                          script')
 
 TOFILE:     QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) RSTD(*YES) DFT(QGPL) +
                          VALUES(QGPL) PROMPT('Library')
 
