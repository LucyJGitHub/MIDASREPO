/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM LDA SET UP FOR EMC0202')                     */
/********************************************************************/
/*                                                                  */
/*          Midas     EXPOSURE MANAGEMENT MODULE                */
/*                                                                  */
/*          EMC02 - LDA SET-UP FOR EMC0202                          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*          LAST AMEND NO. E80880             DATE 29/05/86         */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*          E80880  -  RECREATE PROGRAM USING LATEST SOURCE         */
/*                                                                  */
/********************************************************************/
/**/
/* THIS CREATES LDA FOR THE BATCH RUNNING OF EM0100 */
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             CALL EMC0202
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
