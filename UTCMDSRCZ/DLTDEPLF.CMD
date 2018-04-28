/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0103)                                                */
/*EXI *  TEXT('Midas UT Delete dependent logical files')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       DLTDEPLF - Delete Dependent Logical Files                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. S01526             Date 13NOV95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01526 - Created for the Midas Upgrade Utility              */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Delete Dependent Logical Files')
 
             PARM       KWD(PFILE) TYPE(QUAL1) PROMPT('Physical file +
                          name')
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library name')
