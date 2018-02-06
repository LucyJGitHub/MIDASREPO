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
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 096647             Date 30Nov95              */
/*                      CCG009             Date 01Jun95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
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
