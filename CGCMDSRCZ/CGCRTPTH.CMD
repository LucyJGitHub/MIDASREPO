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
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 155016             Date 07Feb99              */
/*                      S01522             Date 17Aug95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       155016 - Allow lower case                                   */
/*       S01522 - Created for User Defined Correspondence            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create UDC Paths')
 
/************PARM       KWD(GRP_SET) TYPE(*CHAR) LEN(6) MIN(1) +******/                   /*155016*/
/************             PROMPT('Top Group Set')               ******/                   /*155016*/
             PARM       KWD(GRP_SET) TYPE(*CHAR) LEN(6) MIN(1) +
                          CASE(*MIXED) PROMPT('Top Group Set')                            /*155016*/
 
