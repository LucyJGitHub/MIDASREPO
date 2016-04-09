/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Update *GDA with Job Text')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas     STANDING DATA MODULE                          */
/*                                                                   */
/*       SFC4462 - UPDATE *GDA WITH JOB TEXT                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01405             DATE 03DEC92              */
/*       PREV AMEND NO. AUS025             DATE  13FEB91             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01405 - Release 10 Upgrade                                 */
/*       AUS025 - AUSTRALIAN PRODUCT - SESSION MANAGER           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TEXT)
 
             DCL        VAR(&TEXT)      TYPE(*CHAR) LEN(45)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**********  CHGDTAARA  DTAARA(*GDA (11 45)) VALUE(&TEXT)             /*S01405*/
             CHGDTAARA  DTAARA(*GDA (311 45)) VALUE(&TEXT)            /*S01405*/
 
/* */                                                                 /*S01405*/
/** Change value of &BISCPY to avoid error of its declaration.     */ /*S01405*/
/* */                                                                 /*S01405*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */                                                                 /*S01405*/
ENDPGM:      ENDPGM
