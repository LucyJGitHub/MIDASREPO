/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM New Notepad Maintenance')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC0602 - PM New Notepad Maintenance                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CPM005             DATE 02JUL96              */
/*       PREV AMEND NO. S01124             DATE 16JUN94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*       S01124  -  PBFG/6 - ADDITIONAL CUSTOMER DETAILS             */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* PERFORM FILE OVERRIDES                                            */
/*********** OVRDBF     FILE(PMCSNPXX) TOFILE(PMCSNPPP) SHARE(*NO)    /*CPM005*/
/*********** OVRDBF     FILE(PMPTNPXX) TOFILE(PMPTNPPP) SHARE(*NO)    /*CPM005*/
             OVRDBF     FILE(PMCSNPXX) TOFILE(PMCSNPPD) SHARE(*NO)    /*CPM005*/
             OVRDBF     FILE(PMPTNPXX) TOFILE(PMPTNPPD) SHARE(*NO)    /*CPM005*/
/**/
             CALL       PGM(PM0600)
/**/
             DLTOVR     FILE(*ALL)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
