/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CGC7991)                                                */
/*EXI *  TEXT('Midas CG Create format option codes')                 */
/*********************************************************************/
/*                                                                   */
/*  Midas - User Defined Correspondence                              */
/*                                                                   */
/*  CG_FMTOPT - Create Format Option Codes                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. 096647             DATE 30NOV95                   */
/*  PREV AMEND NO. CCG009             DATE 01JUN95                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       096647 - Add new paramters                                  */
/*       CCG009 - Private Banking UDC                                */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create Format Option Codes')
 
             PARM       KWD(CURRENCY) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) SPCVAL((N) (Y)) PROMPT('Currency +
                          code (CURRENCY)')                           /*096647*/
 
             PARM       KWD(COUNTRY) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) SPCVAL((N) (Y)) PROMPT('Country +
                          codes (COUNTRY)')                           /*096647*/
 
             PARM       KWD(INDUSTRY) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) SPCVAL((N) (Y)) PROMPT('Industry +
                          (INDUSTRY)')                                /*096647*/
 
             PARM       KWD(PB_INVEST) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) SPCVAL((N) (Y)) PROMPT('PB +
                          Investment types')                          /*096647*/
 
             PARM       KWD(PB_VGROUP) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) SPCVAL((N) (Y)) PROMPT('PB +
                          Valuation Groups')                          /*096647*/
 
             PARM       KWD(OVER_WRITE) TYPE(*CHAR) LEN(1) +
                          RSTD(*YES) DFT(N) SPCVAL((N) (Y)) +
                          PROMPT('Over-write')                        /*096647*/
