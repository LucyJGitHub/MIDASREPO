/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Notepad Maintenance')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0601  - PM NOTEPAD MAINTENANCE (NON GROUP JOB)           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486             DATE 12JUL94              */
/*       PREV AMEND NO. 049421             DATE 18JAN93              */
/*                      049467             DATE 18JAN93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       049467  -  RECOMPILED FOR RELEASE 3 PTF 02                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETC &CUST &PTFR)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&RETC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PTFR) TYPE(*CHAR) LEN(4)
/**/
/* PERFORM FILE OVERRIDES                                            */
/*********** OVRDBF     FILE(PMPORXXX) TOFILE(PMPORTPP) SHARE(*NO)      S01486*/
             OVRDBF     FILE(PMPORXXX) TOFILE(PMPORTPD) SHARE(*NO)    /*S01486*/
/**/
             CALL       PGM(PM0601) PARM(&RETC &CUST &PTFR)
/**/
             DLTOVR     FILE(PMPORXXX)
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
