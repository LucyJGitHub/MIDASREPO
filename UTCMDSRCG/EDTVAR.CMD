/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(UTC0240)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(EDTVAR)     HLPID(*CMD)                           */
/*EXI *  TEXT('Midas UT Edit variable command')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       EDTVAR (Edit variabel) command                              */
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
/*       Prev Amend No. CAA002 *CREATE     Date 31OCT95              */
/*                      nnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
/*  The EDTVAR command edits a decimal variable into a 22 byte      */
/*    character variable with edit codes and an optional leading    */
/*    currency symbol.                                              */
/*                                                                  */
/*  The CPP is UTC0240.                                             */
/*                                                                  */
             CMD        PROMPT('Edit Variable')
             PARM       KWD(CHROUT) TYPE(*CHAR) LEN(22) +
                          RTNVAL(*YES) MIN(1) +
                          PROMPT('Character return var      (22)')
             PARM       KWD(NUMINP) TYPE(*DEC) LEN(15 0) MIN(1) +
                          PROMPT('Dec input (up to 15 digits)')
             PARM       KWD(NBRDEC) TYPE(*DEC) LEN(1 0) RANGE(0 9) +
                          DFT(0) PROMPT('Number of decimals')
             PARM       KWD(EDTCDE) TYPE(*CHAR) LEN(1) DFT(J) +
                          RSTD(*YES) VALUES(J K L M W Y Z) +
                          PROMPT('Edit code')
             PARM       KWD(LDGSYM) TYPE(*CHAR) LEN(4) DFT(*NO) +
                          VALUES('*YES' '*NO') RSTD(*YES) +
                          PROMPT('Leading currency symbol')
