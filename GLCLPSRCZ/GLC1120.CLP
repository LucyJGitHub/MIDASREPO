/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Amount Accrual Input')                       */
/********************************************************************/
/*                                                                  */
/*        Midas     - General Ledger Module                     */
/*                                                                  */
/*       GLC1120 - AMOUNT ACCRUAL INPUT                             */
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
/*       Prev Amend No. S01194             Date 16/03/89             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01194 - NEW STANDING DATA                                 */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL      VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL      VAR(&JOB) TYPE(*CHAR) LEN(10)
/**/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/**/
             CHGJOB   SWS(00000000)
/**/
             CHGVAR   VAR(%SUBSTRING(&LDA 1 8)) VALUE('GL1120  ')
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(&LDA)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                   /*S01194*/
/**/
             CALL   PGM(GLC1120A)
/**/
             RCLRSC
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
