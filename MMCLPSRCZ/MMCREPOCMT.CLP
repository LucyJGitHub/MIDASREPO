/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Add message to pgm subfile message queue')   */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Common processing                          */
/*                                                                   */
/*          MMCREPOCMT - COMMIT CHANGES TO FILES FOR ALL             */
/*                       ACTIVATION GROUPS                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*          LAST AMEND NO. CSE006    DATE   18AUG99                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*      CSE006 - REPURCHASE AGREEMENT ENHANCEMENTS                   */
/*               TO AVOID PROGRAM CRASH IN PROGRAM USING ZA0240      */
/*                                                                   */
/*********************************************************************/
/**/
PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
       COMMIT
 
GOTO ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM: ENDPGM
