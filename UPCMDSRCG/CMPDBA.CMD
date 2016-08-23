/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UPC000005)   VLDCKR(UPC000005V)  MSGF(UTMSGF)           */
/*EXI    HLPPNLGRP(CMPDBA)      HLPID(*CMD)                          */
/*EXI *  TEXT('Midas UP Compare database attributes')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       CMPDBA - Compare database attributes                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2006           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK025 *CREATE     Date 25Jan06              */
/*       Prev Amend No. xxxxxx             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPK025 - New utility (replacement for CMPDBATR).            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Compare database attributes')
 
             PARM       KWD(BASEFILE) TYPE(QUAL1) MIN(1) +
                          PROMPT('Base file(s)' 1)
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL))
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library Name:')
 
             PARM       KWD(COMPFILE) TYPE(QUAL2) MIN(0) +
                          PROMPT('Comparison file(s)' 2)
 QUAL2:      QUAL       TYPE(*NAME) LEN(10) DFT(*BASEFILE) +
                          SPCVAL((*BASEFILE))
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*BASEFILE) (*LIBL)) +
                          PROMPT('Library Name:')
 
             PARM       KWD(CMPTYPE) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*ALL) VALUES(*ALL *ACCPTH *DBR +
                          *FLDATR *FLDTXT *JOIN *MBR *SELECT *TRG) +
                          MIN(0) MAX(8) PROMPT('Type of comparison')
 
             PARM       KWD(MISSFILE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) MIN(0) MAX(1) +
                          PROMPT('List missing files?')
 
