/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CGCLABEL)                                               */
/*EXI *  TEXT('Midas CG Set up label stationery')                    */
/*********************************************************************/
/*                                                                   */
/*  Midas - User Defined Correspondence                              */
/*                                                                   */
/*  CGLABEL - Set up description of stanard label stationery         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. S01522             DATE 14JLY95                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - Created for User Defined Correspondence            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Set up UDC label stationery')
 
             PARM       KWD(PWIDTH) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*NO) DFT(00132) RANGE(00001 99999) +
                          PROMPT('Page width (characters)')
             PARM       KWD(PLENGTH) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*NO) DFT(00066) RANGE(00001 99999) +
                          PROMPT('Page length (lines)')
             PARM       KWD(XLABELS) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*NO) DFT(00003) RANGE(00001 99999) +
                          PROMPT('Number of labels across')
             PARM       KWD(YLABELS) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*NO) DFT(00003) RANGE(00001 99999) +
                          PROMPT('Number of labels down')
             PARM       KWD(LWMARGIN) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*NO) DFT(00010) RANGE(00001 99999) +
                          PROMPT('Left/Right margin')
             PARM       KWD(TBMARGIN) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*NO) DFT(00010) RANGE(00001 99999) +
                          PROMPT('Top/Bottom margin')
             PARM       KWD(LWIDTH) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*NO) DFT(00020) RANGE(00001 99999) +
                          PROMPT('Width of label (characters)')
             PARM       KWD(LLENGTH) TYPE(*CHAR) LEN(5) RTNVAL(*NO) +
                          RSTD(*NO) DFT(00010) RANGE(00001 99999) +
                          PROMPT('Length of label (lines)')
