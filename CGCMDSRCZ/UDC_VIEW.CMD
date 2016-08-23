/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CGC99Z1)                                                */
/*EXI *  TEXT('Midas CG View Correspondent Data')                    */
/*********************************************************************/
/*                                                                   */
/*  Midas - User Defined Correspondence                              */
/*                                                                   */
/*  UDC_VIEW  - View correspondence data                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. S01522             DATE 14JUL95                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - Created for User Defined Correspondence            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('View Correspondence data')
 
             PARM       KWD(MODE) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*CURRENT) VALUES(*CURRENT *ARCHIVE) +
                          SPCVAL((*CURRENT '') (*ARCHIVE ARCHIVE)) +
                          PROMPT('Current or Archive')
