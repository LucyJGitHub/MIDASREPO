/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Determine Performance Periods')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1610 - PM Determine Performance Periods                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CPM004             DATE 07FEB96              */
/*       PREV AMEND NO. S01408             DATE 05MAY95              */
/*                      S01486             DATE 11AUG94              */
/*                      049421             DATE 18JAN93              */
/*                      S01313             DATE 07APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM004 - Bank Portfolios                                    */
/*       S01408 - Addition of core hook PMC1610MPS               */
/*       S01486  -  Portfolio Management Upgrade to Release 10.      */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       S01313  -  WRITTEN FOR PORTFOLIO PERFORMANCE                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* DECLARE VARIABLES */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FMLIB) TYPE(*CHAR) LEN(10)
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*********** CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1610MPS                                          */
                                                                      /*S01408*/
 
/*********** OVRDBF     FILE(PMUNQVPP) SHARE(*YES)                 */ /*S01486*/
             OVRDBF     FILE(PMUNQVPD) SHARE(*YES)                    /*S01486*/
             MONMSG     MSGID(CPF0000)
 
/*********** OPNQRYF    FILE((PMUNQVPP)) QRYSLT('QNPFMR *EQ "Y"')  */ /*S01486*/
             OPNQRYF    FILE((PMUNQVPD)) QRYSLT('GHPFMR *EQ "Y"')     /*S01486*/
 
/**COPY*EMPTY*FILES TO LIB/QTEMP */                                   /*CPM004*/
/*********** CPYF       FROMFILE(&FMLIB/PMPFMRPP) +                */ /*S01486*/
/***********              TOFILE(QTEMP/PMPFMRPP) MBROPT(*REPLACE) +*/ /*S01486*/
/***********              CRTFILE(*YES)                            */ /*S01486*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPFMRPP)) */ /*S01486*/
 
/*********** CPYF       FROMFILE(&FMLIB/PMFPPSPP) +                */ /*S01486*/
/***********              TOFILE(QTEMP/PMFPPSPP) MBROPT(*REPLACE) +*/ /*S01486*/
/***********              CRTFILE(*YES)                            */ /*S01486*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMFPPSPP)) */ /*S01486*/
                                                                      /*S01486*/
/*********** CPYF       FROMFILE(&FMLIB/PMPFMRPD) +                   /*CPM004*/
/***********              TOFILE(QTEMP/PMPFMRPD) MBROPT(*REPLACE) +   /*CPM004*/
/***********              CRTFILE(*YES)                       S01486  /*CPM004*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPFMRS01486  /*CPM004*/
/***********                                                  S01486  /*CPM004*/
/*********** CPYF       FROMFILE(&FMLIB/PMFPPSQ0) +                   /*CPM004*/
/***********              TOFILE(QTEMP/PMFPPSQ0) MBROPT(*REPLA        /*CPM004*/
/***********              CRTFILE(*YES)                       S01486  /*CPM004*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMFPPSS01486  /*CPM004*/
/* */                                                                 /*CPM004*/
/* CLEAR WORKFILES */                                                 /*CPM004*/
/* */                                                                 /*CPM004*/
             CLRPFM     FILE(PMPFMRPD)                                /*CPM004*/
             CLRPFM     FILE(PMFPPSQ0)                                /*CPM004*/
 
             CALL       PGM(PM1610)
 
/*********** CLOF       OPNID(PMUNQVPP)                            */ /*S01486*/
             CLOF       OPNID(PMUNQVPD)                               /*S01486*/
 
/*********** DLTOVR     FILE(PMUNQVPP)                             */ /*S01486*/
             DLTOVR     FILE(PMUNQVPD)                                /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/*********** SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/*                                                                    /*R00300*/
/*********** SNDPGMMSG MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/***********                 TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
/*                                                                    /*R00300*/
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* IF JOB ENDED NORMALLY */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             ENDDO
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
