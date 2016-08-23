/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Investment Policy Details - File Update')    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0445  - CALCULATE INVESTMENT POLICY EXCEPTIONS           */
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
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       049467 - RECOMPILED FOR RELEASE 3 PTF 02                    */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
PGM
/**/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC0445 - Calculate Exceptions to +
                          Investment Policies') TOMSGQ(MRUNQ)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* CLEAR ALL TEMPORARY FILES */
/*********** CLRPFM     FILE(PMIVPEPP)                                  S01486*/
             CLRPFM     FILE(PMIVPEPD)                                /*S01486*/
/**/
/*  SELECT LIVE PORTFOLIOS WITH INVESTMENT POLICIES ATTACHED */
/*********** OVRDBF     FILE(PMPORTPP) SHARE(*YES)                      S01486*/
             OVRDBF     FILE(PMPORTPD) SHARE(*YES)                    /*S01486*/
 
/*********** OPNQRYF    FILE((PMPORTPP)) OPTION(*ALL) QRYSLT('PNRECI +
                          *EQ "D" *AND (PNPOLC *NE "  " *OR PNIPIN +
                          *EQ "Y" *OR PNCYIN *EQ "Y" *OR PNYPIN *EQ +
                          "Y" *OR PNNPIN *EQ "Y")') KEYFLD((PNCNUM) +
                          (PNPTFR) (PNPOLC))                            S01486*/
             OPNQRYF    FILE((PMPORTPD)) OPTION(*ALL) QRYSLT('PNRECI +
                          *EQ "D" *AND (PNPOLC *NE "  " *OR PNIPIN +
                          *EQ "Y" *OR PNCYIN *EQ "Y" *OR PNYPIN *EQ +
                          "Y" *OR PNNPIN *EQ "Y")') KEYFLD((PNCNUM) +
                          (PNPTFR) (PNPOLC))                          /*S01486*/
/**/
/**  CALL PROGRAM RPG/PM0445 */
             CALL       PGM(PM0445)
/**/
/*********** CLOF       OPNID(PMPORTPP)                                 S01486*/
             CLOF       OPNID(PMPORTPD)                               /*S01486*/
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                       S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/************** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                       S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
