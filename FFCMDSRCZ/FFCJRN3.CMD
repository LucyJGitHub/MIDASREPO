/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(FFCJRN3X)                                               */
/*EXI *  TEXT('Midas FF Final Journal for Sub Component')            */
/*********************************************************************/
/*                                                                  */
/*         Midas     FUTURES AND OPTIONS MODULE                     */
/*                                                                  */
/*         FFCJRN3 - FINAL JOURNAL PROCESSING FOR SUB-COMPONENT     */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*         LAST AMEND NO. E21869          DATE  06MAY90             */
/*         PREV AMEND NO. E20430          DATE  29NOV89             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*    E21869 - FURTHER FIX TO FIX E20430.                           */
/*    E20430 - CREATION PARAMETERS REARRANGED/AMENDED TO ENABLE     */
/*             THE CMD TO BE CREATED USING CRTOBJ.                  */
/*           - S/38 PARAMETER ENTRY REMOVED FROM CREATION PARMS.    */
/*                                                                  */
/********************************************************************/
             CMD        PROMPT('End Journalling For FF Files')
             PARM       KWD(FILES) TYPE(*CHAR) LEN(10) MIN(1) MAX(25) +
                          PROMPT('Files being journalled:')
