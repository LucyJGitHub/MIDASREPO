/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CGTSTCTL)                                               */
/*EXI *  TEXT('Midas CG Test posting narratives')                    */
/*********************************************************************/
/*                                                                   */
/*  Midas - User Defined Correspondence                              */
/*                                                                   */
/*  CGTSTMSG - Test Posting Narratives                               */
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
/*       Prev Amend No. S01522             Date 22Aug95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01522 - Created for User Defined Correspondence            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Test Posting Narratives')
 
             PARM       KWD(CUSTOMER) TYPE(*CHAR) LEN(6) MIN(1) +
                          PROMPT('Customer Number')
 
             PARM       KWD(BRANCH) TYPE(*CHAR) LEN(3) MIN(1) +
                          PROMPT('Branch code')
