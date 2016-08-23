/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CGC4998)                                                */
/*EXI *  TEXT('Midas CG Create new paths')                           */
/*********************************************************************/
/*                                                                   */
/*  Midas - User Defined Correspondence                              */
/*                                                                   */
/*  CGCRTPTH - Create new paths                                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  Last Amend No. 155016             DATE 07FEB99                   */
/*  Prev Amend No. S01522             DATE 17AUG95                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       155016 - Allow lower case                                   */
/*       S01522 - Created for User Defined Correspondence            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create UDC Paths')
 
/************PARM       KWD(GRP_SET) TYPE(*CHAR) LEN(6) MIN(1) +******/                   /*155016*/
/************             PROMPT('Top Group Set')               ******/                   /*155016*/
             PARM       KWD(GRP_SET) TYPE(*CHAR) LEN(6) MIN(1) +
                          CASE(*MIXED) PROMPT('Top Group Set')                            /*155016*/
 
