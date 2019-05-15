/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Notepad Maintenance')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0600  - PM NOTEPAD MAINTENANCE                           */
/*                                                                   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPM005             Date 02Jul96              */
/*                      S01486             Date 12Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*                PBFG/6 - ADDITIONAL CUSTOMER DETAILS. THIS CL      */
/*                NOW CALLS CUSTOMER SUMMARY DETAILS ENQUIRY AND     */
/*                IT IS CL/PMC0602 WHICH CALLS NOW PM NOTEPAD        */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*CPM005*/
             PGM        PARM(&PGMNAME)                                /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PGMNAME) TYPE(*CHAR) LEN(10)             /*CPM005*/
/**/
/* PERFORM FILE OVERRIDES                                            */
/*********** OVRDBF     FILE(PMCSNPXX) TOFILE(PMCSNPPP) SHARE(*NO)      S01486*/
/*********** OVRDBF     FILE(PMPTNPXX) TOFILE(PMPTNPPP) SHARE(*NO)      S01486*/
/*********** OVRDBF FILE(PMCSNPXX) TOFILE(PMCSNPPD) SHARE(*NO) /*S01486 CPM005*/
/*********** OVRDBF FILE(PMPTNPXX) TOFILE(PMPTNPPD) SHARE(*NO) /*S01486 CPM005*/
/**/
/*********** CALL       PGM(PM0600)                                   /*CPM005*/
/**/
/*********** DLTOVR     FILE(*ALL)                                    /*CPM005*/
/**/                                                                  /*CPM005*/
             CALL       PGM(PM0740) PARM(&PGMNAME)                    /*CPM005*/
/**/                                                                  /*CPM005*/
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
