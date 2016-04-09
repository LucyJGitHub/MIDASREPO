/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Update Base Rates facility')                 */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0602B - BASE RATES UPDATE (FCLTY)                       */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01194 *CREATE     Date 08Feb90              */
/*                                                                  */
/********************************************************************/
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             CHGVAR     VAR(&MSG) VALUE('BASE RATES UPDATE - FCLTY')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
             OVRDBF     FILE(PHASD) TOFILE(PHASA)
/**/
                CALL PGM(LE0363)
/**/
             DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
