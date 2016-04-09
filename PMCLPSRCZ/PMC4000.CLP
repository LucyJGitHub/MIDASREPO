/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM SE Reconciliation Programs')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC4000 - Control Running of Reconciliation Programs        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486             DATE 18JAN93              */
/*       PREV AMEND NO. 049421             DATE 18JAN93              */
/*                      42215              DATE 03JUL92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01486  -  Portfolio Management Upgrade to Release 10.      */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       42215   -  CHNGED TO ALLOW FOR HISTORIC TRADES              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* RECONCILE CAPRHD AGAINST TRADSD AND DPTMVD */
             CALL       PGM(PM4000)
/**/
             OVRDBF     FILE(TRADH2) TOFILE(TRADHS) SHARE(*NO)        /*42215 */
             CALL       PGM(PM4010)
/**/
             CALL       PGM(PM4020)
/**/
/* RECONCILE PORTFOLIO POSITIONS ON PMCPOSPP AGAINST ACTIONS ON CAPRHD */
             OVRDBF     FILE(PMAPOSLX) TOFILE(PMAPOSLL) SHARE(*NO)
             CALL       PGM(PM4030)
/**/
/* RECONCILE SE POSITIONS AGAINST PM POSITIONS */
             CALL       PGM(PM4040)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
