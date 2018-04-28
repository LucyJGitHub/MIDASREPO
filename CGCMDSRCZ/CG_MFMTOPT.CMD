/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CGC7990)                                                */
/*EXI *  TEXT('Midas CG Create multi-language format options')       */
/*********************************************************************/
/*                                                                   */
/*  Midas - User Defined Correspondence                              */
/*                                                                   */
/*  CG_MFMTOPT - Create Multi-Language Format Options                */
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
             CMD        PROMPT('Create Multi-Lang Fmt Options')
 
             PARM       KWD(FORMAT_OPT) TYPE(*CHAR) LEN(10) +
                          DFT(*ALL) SPCVAL((*ALL '          ')) +
                          PROMPT('Format Option')                     /*096647*/
 
             PARM       KWD(LANG) TYPE(*CHAR) LEN(2) RSTD(*NO) +
                          PROMPT('Language Code')
 
             PARM       KWD(OVER_WRITE) TYPE(*CHAR) LEN(1) +
                          RSTD(*YES) DFT(N) SPCVAL((N) (Y)) +
                          PROMPT('Over-write')                        /*096647*/
