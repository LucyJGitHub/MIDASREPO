/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UT9005) VLDCKR(UTC9005) PMTOVRPGM(UT9006)               */
/*EXI    HLPPNLGRP(UPDGENFLD) HLPID(*CMD)                            */
/*EXI *  TEXT('Midas UT Update GENFLDNOS driving file')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       GENFLDNOS - Update GENFLDNOS driving file                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/*       Last Amend No. CUP021  *CREATE    Date 12Jan03              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP021 - Re-write of GENFLDNOS, to make it file driven.     */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Update GENFLDNOS driving file')
 
             PARM       KWD(APINAME) TYPE(*CHAR) LEN(4) MIN(1) +
                          KEYPARM(*YES) PROMPT('API name' 1)
 
             PARM       KWD(DETAIL) TYPE(DETAIL) MIN(1) MAX(20) +
                          PROMPT('Detail files' 3)
 
             PARM       KWD(HEADERFILE) TYPE(HEADER) PROMPT('Header +
                          file' 2)
 
 HEADER:     QUAL       TYPE(*NAME) LEN(10) DFT(APHEADPD) +
                          SPCVAL((*EXTEND))
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*CURLIB)) +
                          PROMPT('Library')
 
 DETAIL:     QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*CURLIB)) +
                          PROMPT('Library')
 
