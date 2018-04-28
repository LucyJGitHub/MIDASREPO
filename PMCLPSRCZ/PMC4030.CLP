/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM PM/SE Position reconciliation')              */
/********************************************************************/
/*                                                                  */
/*      Midas PORTFOLIO MANAGEMENT MODULE                       */
/*                                                                  */
/*      PMC4030 RECONCILE PM AGAINST SE POSITIONS                   */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486            DATE 05DEC94              */
/*       PREV AMEND NO. 53103             DATE 25NOV93              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       S01486 - Portfolio Management Upgrade to R10               */
/*       53103  - ONLY RECONCILE PM & SE POSITIONS DAILY. ANY       */
/*                INCORRECT ACTIONS WILL CAUSE ERROR ON THESE       */
/*                REPORTS (SAVES COB RUN TIME)                      */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC4030 - PM Reconciliation Reporting') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* RESET SWITCHES                                              */
             CHGJOB     SWS(00000000)
/**/
                                                    /* BEGIN S01486*/
/**RECONCILE*PORTFOLIO*POSITIONS*ON*PMCPOSPP*AGAINST*ACTIONS*ON*CAPRHD */
/* RECONCILE PORTFOLIO POSITIONS ON PMCPOSPD AGAINST ACTIONS ON CAPRHD */
                                                    /* END   S01486*/
             OVRDBF     FILE(PMAPOSLX) TOFILE(PMAPOSLL) SHARE(*NO)
             CALL       PGM(PM4030)
/**/
/* RECONCILE SE POSITIONS AGAINST PM POSITIONS */
             CALL       PGM(PM4040)
/**/
/********    ENDPGM                                                  */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
