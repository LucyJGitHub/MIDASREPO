/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE LOAN AMENDS INPUT TODAY')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*       LEC0601C - LOAN AMENDMENTS, REPAYS AND MANUAL REPAYS       */
/*                                                      INPUT TODAY */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01194            DATE  08FEB90             */
/*                                                                  */
/********************************************************************/
/*       S01194 - NEW STANDING DATA                                 */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                          VALUE('LOAN AMENDMENTS AND REPAYMENTS +
                          INPUT TODAY REPORT')
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
             OVRDBF     FILE(LOAMST) TOFILE(LOAMS) SHARE(*NO)
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
/**/
             CALL       PGM(LE0320)
/**/
             DLTOVR     FILE(*ALL)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
