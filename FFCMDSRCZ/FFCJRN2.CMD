/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(FFCJRN2X)                                               */
/*EXI *  TEXT('Midas FF Start Journal for Sub Component')            */
/*********************************************************************/
/*                                                                  */
/*         Midas     FUTURES AND OPTIONS MODULE                     */
/*                                                                  */
/*         FFCJRN2 - START JOURNAL PROCESSING FOR SUB-COMPONENT     */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E21868             Date 06May90              */
/*                      E20430             Date 29Nov89              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*    E21868 - FURTHER FIX TO FIX E20430.                           */
/*    E20430 - CREATION PARAMETERS REARRANGED TO ENABLE THE CMD     */
/*             TO BE CREATED USING CRTOBJ.                          */
/*                                                                  */
/********************************************************************/
             CMD        PROMPT('Start Journalling For FF Files')
             PARM       KWD(FILES) TYPE(*CHAR) LEN(10) MIN(1) MAX(25) +
                          PROMPT('Files to be journalled:')
