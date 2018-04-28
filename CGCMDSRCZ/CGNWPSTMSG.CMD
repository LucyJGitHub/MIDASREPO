/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(CGADDMSG)                                               */
/*EXI *  TEXT('Midas CG New Posting Message')                        */
/*********************************************************************/
/*                                                                   */
/*  Midas - User Defined Correspondence                              */
/*                                                                   */
/*  CGNWPSTMSG - New Posting Message                                 */
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
             CMD        PROMPT('New Posting Message')
 
             PARM       KWD(LANGUAGE) TYPE(*CHAR) LEN(2) MIN(1) +
                          PROMPT('Language code')
 
             PARM       KWD(CODE) TYPE(*CHAR) LEN(5) MIN(1) +
                          PROMPT('Narrative code and Sequence')
 
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(132) MIN(1) +
                          PROMPT('Message Text')
