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
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. S01522             DATE 22AUG95                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - Created for User Defined Correspondence            */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Test Posting Narratives')
 
             PARM       KWD(CUSTOMER) TYPE(*CHAR) LEN(6) MIN(1) +
                          PROMPT('Customer Number')
 
             PARM       KWD(BRANCH) TYPE(*CHAR) LEN(3) MIN(1) +
                          PROMPT('Branch code')
