/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Deleted Customer Selection')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0625  - DELETED CUSTOMER SELECTION                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 092963             DATE 18SEP95              */
/*       PREV AMEND NO. S01486             DATE 12JUL94              */
/*                      038430             DATE 03AUG93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       092963 - Clear *LDA after enquiry                           */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*  CREATED FOR 038430  ENHANCEMENTS TO CUSTOMER INSERTION/DELETION  */
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
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
/**/
/**CHANGE*JOB*ATTRIBUTES*TO*BECOME*GROUP*JOB                          /*S01486*/
/*********** CHGGRPA    GRPJOB(CUSTOMER) TEXT('Group job for customer +
                          choice')                                      S01486*/
/**/
/* PERFORM FILE OVERRIDES                                            */
/*********** OVRDBF     FILE(PMCSNPXX) TOFILE(PMCSNPPP) SHARE(*NO)      S01486*/
/*********** OVRDBF     FILE(PMPTNPXX) TOFILE(PMPTNPPP) SHARE(*NO)      S01486*/
             OVRDBF     FILE(PMCSNPXX) TOFILE(PMCSNPPD) SHARE(*NO)    /*S01486*/
             OVRDBF     FILE(PMPTNPXX) TOFILE(PMPTNPPD) SHARE(*NO)    /*S01486*/
/**/
/* RECEIVE NAME OF USER CURRENTLY SIGNED ON  */
             RTVJOBA    USER(&USER)
/**/
             CALL       PGM(PM0625) PARM(&USER) /* Call PM0625 to +
                          allow customer selection */
                                                                      /*092963*/
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')                       /*092963*/
/**/
/** DATABASE ERROR REPORTING                                        **/
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Program PMC0625 ended abnormally - job +
                          cancelled') TOMSGQ(MOPERQ)
                ENDDO
/*********** CHGGRPA    GRPJOB(*NONE)                                   S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
