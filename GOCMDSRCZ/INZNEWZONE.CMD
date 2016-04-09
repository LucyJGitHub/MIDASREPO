/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(GOC000020)  VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(INZNEWZONE) HLPID(*CMD)                           */
/*EXI *  TEXT('Midas GO Create new zone')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing                                   */
/*                                                                   */
/*       INZNEWZONE - Create new zone for Global Processing          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CUP025  *CREATE    Date 02Dec03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP025 - MidasPlus Bridge changes.                          */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create new zone')
 
             PARM       KWD(ZONE) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Name of zone')
 
             PARM       KWD(ZONECODE) TYPE(*NAME) LEN(4) MIN(1) +
                          FULL(*YES) PROMPT('Zone shortcode')
 
             PARM       KWD(ZONEDESC) TYPE(*CHAR) LEN(50) MIN(1) +
                          CASE(*MIXED) PROMPT('Zone description')
 
             PARM       KWD(ACMVRCVDAY) TYPE(*DEC) LEN(3) MIN(1) +
                          PROMPT('Account movement recovery days')
 
