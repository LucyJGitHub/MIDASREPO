/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas PM Calc figures reqd on statement due')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1160 - PM Calculate Figures Required On Statements Due   */
/*                    Today                                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR796218           Date 28Jun11              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG23967           Date 15May09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CPB001             Date 12Jul99              */
/*                      138237             Date 18Jul96              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPM005             Date 18Jul96              */
/*                      CCG009             Date 01Jun95              */
/*                      S01408             DATE 05MAY95              */
/*                      081508             DATE 28NOV94              */
/*                      73300              DATE 28NOV94              */
/*                      53103              DATE 28NOV94              */
/*                      S01486             DATE 11AUG94              */
/*                      049421             DATE 18JAN93              */
/*                      S01313             DATE 18JAN93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR796218 - Local Industry Code error in COB                 */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23967 - Add Local Industry Code Field.                   */
/*       CPB001 - 'Private Banking' Module                           */
/*       138237 - Update of next valuation date not done in PM1170   */
/*                due to CPM005 not correctly incorporated.          */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                PBFG/1 - CHANGE CUSTOMER/PORTFOLIO BASE CCY        */
/*       CCG009 - Private Banking UDC                                */
/*       S01408 - Addition of core hook PMC1160MP1                   */
/*       081508 - WRONG PARAMETER PASSED                             */
/*       73300  - Pass additional parameters 'PERFORMANCE REQD'      */
/*       53103  - Pass additional parameters CUSTOMER, PORTFOLIO     */
/*                from PMC095X to PMC1160                            */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - PROGRAM WRITTEN FOR PORTFOLIO PERFORMANCE          */
/*                                                                   */
/*********************************************************************/
/*********** PGM      PARM(&WWDPCD &WWACOC &WWPMNG &WWMODE &WWTNLA)*/ /*S01486*/
/*********** PGM        PARM(&WWDPCD &WWACOC &WWPMNG &WWMODE &WWTNLA +
                          &RSEQ)                            /*S01486    73300*/
             PGM        PARM(&WWDPCD &WWACOC &WWPMNG &WWMODE &WWTNLA +
                          &WWCNUM &WWPTFR &WWPFMR &RSEQ)              /*73300*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&WWDPCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWACOC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWPMNG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWTNLA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WWSCBR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWPFMR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&WWCNUM) TYPE(*DEC) LEN(6 0)              /* 53103*/
             DCL        VAR(&WWPTFR) TYPE(*CHAR) LEN(4)               /* 53103*/
             DCL        VAR(&FLIB) TYPE(*CHAR) LEN(10)                /*CPM005*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*CPB001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPB001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPB001*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1160 - PM Calculate Figures for +
                          Statements Due Today') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
                                                                      /*CPB001*/
/* CHECK IF PB MODULE IS ON */                                        /*CPB001*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPB001*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*CPB001*/
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/**********  CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DLIB')          /*S01486*/
             CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
             CHGVAR     VAR(&FLIB) VALUE(&PRE *TCAT 'DMLIB')          /*CPM005*/
                                                                      /*S01408*/
/**********  CPYF       FROMFILE(&FLIB/PMPORTPD) +               CPM005 138237*/
/**********             TOFILE(&FMLIB/PMMERGPD) MBROPT(*REPLACE) CPM005 138237*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)           CPM005 138237*/
/**********                                                      CPM005 138237*/
/**********  CPYF       FROMFILE(&FLIB/PMCNSDPD) +               CPM005 138237*/
/**********               TOFILE(&FMLIB/PMMERGPD) MBROPT(*ADD) + CPM005 138237*/
/**********               FMTOPT(*MAP *DROP)                     CPM005 138237*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)           CPM005 138237*/
/**********                                                      CPM005 138237*/
/**********  OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)          CPM005 138237*/
/**********  OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)          CPM005 138237*/
/**********                                                      CPM005 138237*/
/*/COPY WNCPYSRC,PMC1160MP1                                          */
                                                                      /*S01408*/
 
/* CALL PMC1170 TO DETERMINE PORTFOLIOS DUE STATEMENT */
/************CALL       PGM(PMC1170) PARM(&WWDPCD &WWACOC &WWPMNG +
                          &WWMODE &WWTNLA &WWSCBR &WWPFMR) ********   /*53103*/
             CALL       PGM(PMC1170) PARM(&WWDPCD &WWACOC &WWPMNG +
                    &WWMODE &WWTNLA &WWSCBR &WWPFMR &WWCNUM &WWPTFR)  /*53103*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
                                                                      /*138237*/
             CPYF       FROMFILE(&FLIB/PMPORTPD) +
                          TOFILE(&FMLIB/PMMERGPD) MBROPT(*REPLACE)    /*138237*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*138237*/
                                                                      /*138237*/
             CPYF       FROMFILE(&FLIB/PMCNSDPD) +
                          TOFILE(&FMLIB/PMMERGPD) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)                          /*138237*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*138237*/
/**/                                                                  /*138237*/
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD)               /*138237*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*138237*/
                                                                      /*138237*/
 
/* IF SECTOR BREAKDOWNS ARE REQUIRED CALCULATE CURRENCY, COUNTRY AND */
/* INDUSTRY TOTALS                                                   */
             IF         COND(&WWSCBR *EQ 'Y') THEN(DO)
 
/**********  CLRPFM     FILE(&FMLIB/PMHOLDX2)                      */ /*S01486*/
/**********  CLRPFM     FILE(&FMLIB/PMHOLDQ2)                  S01486 /*CCG009*/
/**********  CLRPFM     FILE(&FMLIB/PMHOLDX3)                      */ /*S01486*/
/**********  CLRPFM     FILE(&FMLIB/PMHOLDQ3)                  S01486 /*CCG009*/
                                                                      /*CCG009*/
             CLRPFM     FILE(PMHOLDQ2)                                /*CCG009*/
             CLRPFM     FILE(PMHOLDQ3)                                /*CCG009*/
 
/* SELECT RECORDS FOR WHICH SECTOR TOTALS ARE REQUIRED FROM */
/**PMUNQVPP*********************************************************/ /*S01486*/
/* PMUNQVPD */                                                        /*S01486*/
/**********  CPYF       FROMFILE(QTEMP/PMUNQVPP) +                 */ /*S01486*/
/**********               TOFILE(QTEMP/PMUNQVP1) MBROPT(*REPLACE) +*/ /*S01486*/
/**********              CRTFILE(*YES) INCREL((*IF QNSCTT *EQ 'Y'))*/ /*S01486*/
/**********  CPYF       FROMFILE(QTEMP/PMUNQVPD) +
/**********               TOFILE(QTEMP/PMUNQVP1) MBROPT(*REPLACE) +   /*CCG009*/
/**********      CRTFILE(*YES) INCREL((*IF QNSCTT *EQ'*S01486 081508* /*CCG009*/
/**********  CPYF       FROMFILE(QTEMP/PMUNQVPD) +                    /*CCG009*/
/**********               TOFILE(QTEMP/PMUNQVP1) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES) INCREL((*IF GHSCTT *EQ 081508 /*CCG009*/
 
             CPYF       FROMFILE(PMUNQVPD) +
                          TOFILE(QTEMP/PMUNQVP1) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF GHSCTT *EQ 'Y'))  /*CCG009*/
                                                                      /*CCG009*/
/**********  CPYF       FROMFILE(&FMLIB/PMHOLDX2) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMHOLDX2) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMHOLDQ2) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMHOLDQ2) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMHOLDX1)     /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMHOLDQS01486 /*CCG009*/
/**********  CPYF       FROMFILE(&FMLIB/PMHOLDX3) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMHOLDX3) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMHOLDQ3) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMHOLDQ3) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMHOLDX3)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMHOLDQS01486 /*CCG009*/
 
/**CALL*PM1180*TO*COPY*RECORDS*USED*IN*TOTALLING*FROM*PF/PMHOLDX0***/ /*S01486*/
/**AND*PF/PMHOLDX1*TO*PF/PMHOLDX2*AND*PF/PMHOLDX3*RESPECTIVELY******/ /*S01486*/
/* CALL PM1180 TO COPY RECORDS USED IN TOTALLING FROM PF/PMHOLDQ0  */ /*S01486*/
/* AND PF/PMHOLDQ1 TO PF/PMHOLDQ2 AND PF/PMHOLDQ3 RESPECTIVELY     */ /*S01486*/
             CALL       PGM(PM1180)
 
/* SET UP FILES USED IN SECTOR TOTALLING PROCESSING */
/**********  IF         COND(&WWMODE *NE 'C') THEN(DO)             */ /*CCG009*/
/**********  CPYF       FROMFILE(&FMLIB/PMCCYTPP) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMCCYTPP) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMCCYTPD) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMCCYTPD) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCCYTPP)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCCYTPS01486 /*CCG009*/
/**********  CPYF       FROMFILE(&FMLIB/PMCCYTX0) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMCCYTX0) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMCCYWPD) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMCCYWPD) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCCYTX0)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCCYWPS01486 /*CCG009*/
/**********  CPYF       FROMFILE(&FMLIB/PMCNTTPP) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMCNTTPP) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMCNTTPD) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMCNTTPD) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCNTTPP)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCNTTPS01486 /*CCG009*/
/**********  CPYF       FROMFILE(&FMLIB/PMCNTTX0) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMCNTTX0) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMCNTWPD) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMCNTWPD) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCNTTX0)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCNTWPS01486 /*CCG009*/
/**********  CPYF       FROMFILE(&FMLIB/PMINDTPP) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMINDTPP) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMINDTPD) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMINDTPD) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMINDTPP)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMINDTPS01486 /*CCG009*/
/**********  CPYF       FROMFILE(&FMLIB/PMINDTX0) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMINDTX0) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMINDWPD) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMINDWPD) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMINDTX0)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMINDWPS01486 /*CCG009*/
/**********  ENDDO                                                */  /*CCG009*/
 
/**IN*COB*MODE*CLEAR TOTALLING FILES */                               /*CCG009*/
/**/                                                                  /*CCG009*/
/*  CLEAR SECTOR TOTAL FILES */                                       /*CCG009*/
/**/                                                                  /*CCG009*/
/**********  IF         COND(&WWMODE *EQ 'C') THEN(DO)             */ /*CCG009*/
/**********  CLRPFM     FILE(PMCCYTPP)                             */ /*S01486*/
/*********** CLRPFM     FILE(PMCCYTPD)                         /*S01486 CPM005*/
/**********  CLRPFM     FILE(PMCCYTX0)                             */ /*S01486*/
/*********** CLRPFM     FILE(PMCCYWPD)                         /*S01486 CPM005*/
/**********  CLRPFM     FILE(PMCNTTPP)                             */ /*S01486*/
             CLRPFM     FILE(PMCNTTPD)                                /*S01486*/
/**********  CLRPFM     FILE(PMCNTTX0)                             */ /*S01486*/
             CLRPFM     FILE(PMCNTWPD)                                /*S01486*/
/**********  CLRPFM     FILE(PMINDTPP)                             */ /*S01486*/
             CLRPFM     FILE(PMINDTPD)                                /*S01486*/
/**********  CLRPFM     FILE(PMINDTX0)                             */ /*S01486*/
             CLRPFM     FILE(PMINDWPD)                                /*S01486*/
/*********** ENDDO                                                 */ /*CCG009*/
 
/* OVERRIDE FILES TO SPEED UP FILE GENERATION */
/**********     OVRDBF     FILE(PMCCYTPP) SEQONLY(*YES 100)        */ /*S01486*/
/************** OVRDBF     FILE(PMCCYTPD) SEQONLY(*YES 100)    /*S01486 CPM005*/
/**********     OVRDBF     FILE(PMCNTTPP) SEQONLY(*YES 100)        */ /*S01486*/
                OVRDBF     FILE(PMCNTTPD) SEQONLY(*YES 100)           /*S01486*/
/**********     OVRDBF     FILE(PMINDTPP) SEQONLY(*YES 100)        */ /*S01486*/
                OVRDBF     FILE(PMINDTPD) SEQONLY(*YES 100)           /*S01486*/
/**********     OVRDBF     FILE(PMCCYTX0) SEQONLY(*YES 100)        */ /*S01486*/
/************** OVRDBF     FILE(PMCCYWPD) SEQONLY(*YES 100)    /*S01486 CPM005*/
/**********     OVRDBF     FILE(PMCNTTX0) SEQONLY(*YES 100)        */ /*S01486*/
                OVRDBF     FILE(PMCNTWPD) SEQONLY(*YES 100)           /*S01486*/
/**********     OVRDBF     FILE(PMINDTX0) SEQONLY(*YES 100)        */ /*S01486*/
                OVRDBF     FILE(PMINDWPD) SEQONLY(*YES 100)           /*S01486*/
 
/* CREATE CURRENCY TOTALS FOR ALL DEFINED PORTFOLIOS & 9997 PORTFOLIO  */
/**********  OPNQRYF    FILE((PMHOLDX2)) FORMAT(PMCCYTX0) +        */ /*S01486*/
/**********               GRPFLD(QFCNUM QFPTFR QFCCY) +            */ /*S01486*/
/**********               MAPFLD((WGCNUM QFCNUM) (WGPTFR QFPTFR) + */ /*S01486*/
/**********               (WGCCY QFCCY) (WGPTPA '%SUM(QFPTPA)') +  */ /*S01486*/
/**********               (WGPTNA '%SUM(QFPTNA)') (WGPTMV +        */ /*S01486*/
/**********               '%SUM(QFPTMV)') (WGPVPA '%SUM(QFPVPA)') +*/ /*S01486*/
/**********               (WGPVNA '%SUM(QFPVNA)') (WGPVMV +        */ /*S01486*/
/**********               '%SUM(QFPVMV)') (WGPTAI '%SUM(QFPTAI)')) */ /*S01486*/
/*********** OPNQRYF    FILE((PMHOLDQ2)) FORMAT(PMCCYWPD) +           /*CCG009*/
/***********              GRPFLD(QFCNUM QFPTFR QFCCY) +               /*CCG009*/
/***********              MAPFLD((WGCNUM QFCNUM) (WGPTFR QFPTFR) +    /*CCG009*/
/***********              (WGCCY QFCCY) (WGPTPA '%SUM(QFPTPA)') +     /*CCG009*/
/***********              (WGPTNA '%SUM(QFPTNA)') (WGPTMV +           /*CCG009*/
/***********              '%SUM(QFPTMV)') (WGPVPA '%SUM(QFPVPA)') +   /*CCG009*/
/***********              (WGPVNA '%SUM(QFPVNA)') (WGPVMV +           /*CCG009*/
/***********              '%SUM(QFPVMV)') (WGPTAI '%SUM(QFPT/*S01486* /*CCG009*/
/*********** OPNQRYF    FILE((PMHOLDQ2)) FORMAT(PMCCYWPD) +           /*CPM005*/
/************************ GRPFLD(QFCNUM QFPTFR QFCCY) +               /*CPM005*/
/************************ MAPFLD((WGCNUM QFCNUM) (WGPTFR QFPTFR) +    /*CPM005*/
/************************ (WGCCY QFCCY) (WGPTPA '%SUM(QFPTPA)') +     /*CPM005*/
/************************ (WGPTNA '%SUM(QFPTNA)') (WGPTMV +           /*CPM005*/
/************************ '%SUM(QFPTMV)') (WGPVPA '%SUM(QFPVPA)') +   /*CPM005*/
/************************ (WGPVNA '%SUM(QFPVNA)') (WGPVMV +           /*CPM005*/
/************************ '%SUM(QFPVMV)') (WGPTAI '%SUM(QFPTAI)') +   /*CPM005*/
/************************ (WGPTNI '%SUM(QFPTNI)'))             /*CCG009 CPM005*/
/**********  CPYFRMQRYF FROMOPNID(PMHOLDX2) TOFILE(PMCCYTX0) +     */ /*S01486*/
/**********               MBROPT(*REPLACE) FMTOPT(*NOCHK)          */ /*S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMHOLDQ2) TOFILE(PMCCYWPD) +        /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)      /*S01486 CPM005*/
/**********  CLOF       OPNID(PMHOLDX2)                            */ /*S01486*/
/*********** CLOF       OPNID(PMHOLDQ2)                        /*S01486 CPM005*/
/***********                                                          /*CPM005*/
/**COPY*TOTALS*FROM*PMCCYTX0*TO*CURRENCY*TOTALS*FILE****************/ /*S01486*/
/**COPY*TOTALS*FROM*PMCCYWPD*TO*CURRENCY*TOTALS*FILE**/        /*S01486 CPM005*/
/**********  CPYF       FROMFILE(PMCCYTX0) TOFILE(PMCCYTPP) +      */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
/*********** CPYF       FROMFILE(PMCCYWPD) TOFILE(PMCCYTPD) +         /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)          /*S01486 CPM005*/
/***********                                                          /*CPM005*/
/**CREATE*TOTALS*FILE*FOR*9998*AND*9999*PORTFOLIOS*WHERE*THE**/       /*CPM005*/
/**CUSTOMER*ONLY*HAS*PORTFOLIOS*IN*BASE*CURRENCY**/                   /*CPM005*/
/**********  OPNQRYF    FILE((PMCCYTX0)) FORMAT(PMCCYTPP) +        */ /*S01486*/
/**********             QRYSLT('WGPTFR *NE "9997"') GRPFLD(WGCNUM +*/ /*S01486*/
/**********               WGCCY) MAPFLD((QGCNUM WGCNUM) (QGPTFR +  */ /*S01486*/
/**********               "9998") (QGCCY WGCCY) (QGPTPA +          */ /*S01486*/
/**********               '%SUM(WGPTPA)') (QGPTNA '%SUM(WGPTNA)') +*/ /*S01486*/
/**********               (QGPTMV '%SUM(WGPTMV)') (QGPVPA +        */ /*S01486*/
/**********               '%SUM(WGPVPA)') (QGPVNA '%SUM(WGPVNA)') +*/ /*S01486*/
/**********               (QGPVMV '%SUM(WGPVMV)') (QGPTAI +        */ /*S01486*/
/**********               '%SUM(WGPTAI)'))                         */ /*S01486*/
/*********** OPNQRYF    FILE((PMCCYWPD)) FORMAT(PMCCYTPD) +           /*CCG009*/
/***********              QRYSLT('WGPTFR *NE "9997"') GRPFLD(WGCNUM + /*CCG009*/
/***********              WGCCY) MAPFLD((QGCNUM WGCNUM) (QGPTFR +     /*CCG009*/
/***********              "9998") (QGCCY WGCCY) (QGPTPA +             /*CCG009*/
/***********              '%SUM(WGPTPA)') (QGPTNA '%SUM(WGPTNA)') +   /*CCG009*/
/***********              (QGPTMV '%SUM(WGPTMV)') (QGPVPA +           /*CCG009*/
/***********              '%SUM(WGPVPA)') (QGPVNA '%SUM(WGPVNA)') +   /*CCG009*/
/***********              (QGPVMV '%SUM(WGPVMV)') (QGPTAI +           /*CCG009*/
/***********              '%SUM(WGPTAI)'))                  /*S01486* /*CCG009*/
/*********** OPNQRYF    FILE((PMCCYWPD)) FORMAT(PMCCYTPD) +           /*CPM005*/
/************************ QRYSLT('WGPTFR *NE "9997"') GRPFLD(WGCNUM + /*CPM005*/
/************************ WGCCY) MAPFLD((QGCNUM WGCNUM) (QGPTFR +     /*CPM005*/
/************************ "9998") (QGCCY WGCCY) (QGPTPA +             /*CPM005*/
/************************ '%SUM(WGPTPA)') (QGPTNA '%SUM(WGPTNA)') +   /*CPM005*/
/************************ (QGPTMV '%SUM(WGPTMV)') (QGPVPA +           /*CPM005*/
/************************ '%SUM(WGPVPA)') (QGPVNA '%SUM(WGPVNA)') +   /*CPM005*/
/************************ (QGPVMV '%SUM(WGPVMV)') (QGPTAI +           /*CPM005*/
/*******************'%SUM(WGPTAI)') (QGPTNI '%SUM(WGPTNI)'))   /*CCG009 CPM005*/
/***********                                                   /*CCG009 CPM005*/
/**********  CPYFRMQRYF FROMOPNID(PMCCYTX0) TOFILE(PMCCYTPP) +     */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMCCYWPD) TOFILE(PMCCYTPD) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)          /*S01486 CPM005*/
/**********  CLOF       OPNID(PMCCYTX0)                            */ /*S01486*/
/*********** CLOF       OPNID(PMCCYWPD)                        /*S01486 CPM005*/
/***********                                                          /*CPM005*/
/**********  OPNQRYF    FILE((PMCCYTX0)) FORMAT(PMCCYTPP) +        */ /*S01486*/
/**********               GRPFLD(WGCNUM WGCCY) MAPFLD((QGCNUM +    */ /*S01486*/
/**********               WGCNUM) (QGPTFR "9999") (QGCCY WGCCY) +  */ /*S01486*/
/**********               (QGPTPA '%SUM(WGPTPA)') (QGPTNA +        */ /*S01486*/
/**********               '%SUM(WGPTNA)') (QGPTMV '%SUM(WGPTMV)') +*/ /*S01486*/
/**********               (QGPVPA '%SUM(WGPVPA)') (QGPVNA +        */ /*S01486*/
/**********               '%SUM(WGPVNA)') (QGPVMV '%SUM(WGPVMV)') +*/ /*S01486*/
/**********               (QGPTAI '%SUM(WGPTAI)'))                 */ /*S01486*/
/*********** OPNQRYF    FILE((PMCCYWPD)) FORMAT(PMCCYTPD) +           /*CCG009*/
/***********              GRPFLD(WGCNUM WGCCY) MAPFLD((QGCNUM +       /*CCG009*/
/***********              WGCNUM) (QGPTFR "9999") (QGCCY WGCCY) +     /*CCG009*/
/***********              (QGPTPA '%SUM(WGPTPA)') (QGPTNA +           /*CCG009*/
/***********              '%SUM(WGPTNA)') (QGPTMV '%SUM(WGPTMV)') +   /*CCG009*/
/***********              (QGPVPA '%SUM(WGPVPA)') (QGPVNA +           /*CCG009*/
/***********              '%SUM(WGPVNA)') (QGPVMV '%SUM(WGPVMV)') +   /*CCG009*/
/***********              (QGPTAI '%SUM(WGPTAI)'))         /*S01486*/ /*CCG009*/
/*********** OPNQRYF    FILE((PMCCYWPD)) FORMAT(PMCCYTPD) +           /*CPM005*/
/************************ GRPFLD(WGCNUM WGCCY) MAPFLD((QGCNUM +       /*CPM005*/
/************************ WGCNUM) (QGPTFR "9999") (QGCCY WGCCY) +     /*CPM005*/
/************************ (QGPTPA '%SUM(WGPTPA)') (QGPTNA +           /*CPM005*/
/************************ '%SUM(WGPTNA)') (QGPTMV '%SUM(WGPTMV)') +   /*CPM005*/
/************************ (QGPVPA '%SUM(WGPVPA)') (QGPVNA +           /*CPM005*/
/************************ '%SUM(WGPVNA)') (QGPVMV '%SUM(WGPVMV)') +   /*CPM005*/
/************************ (QGPTAI '%SUM(WGPTAI)') (QGPTNI +           /*CPM005*/
/************************ '%SUM(WGPTNI)'))                     /*CCG009 CPM005*/
/**********  CPYFRMQRYF FROMOPNID(PMCCYTX0) TOFILE(PMCCYTPP) +     */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMCCYWPD) TOFILE(PMCCYTPD) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)          /*S01486 CPM005*/
/**********  CLOF       OPNID(PMCCYTX0)                            */ /*S01486*/
/*********** CLOF       OPNID(PMCCYWPD)                        /*S01486 CPM005*/
/***********                                                          /*CPM005*/
/**CREATE*TOTALS*FILE*FOR*ALL*PORTFOLIOS*FOR*CUSTOMERS*WITH**/        /*CPM005*/
/**PORTFOLIOS*NOT*IN*CUSTOMER*BASE*CURRENCY**/                        /*CPM005*/
/**********  OPNQRYF    FILE((PMHOLDX3)) FORMAT(PMCCYTPP) +        */ /*S01486*/
/**********               GRPFLD(QFCNUM QFPTFR QFCCY) +            */ /*S01486*/
/**********               MAPFLD((QGCNUM QFCNUM) (QGPTFR QFPTFR) + */ /*S01486*/
/**********               (QGCCY QFCCY) (QGPTPA '%SUM(QFPTPA)') +  */ /*S01486*/
/**********               (QGPTNA '%SUM(QFPTNA)') (QGPTMV +        */ /*S01486*/
/**********               '%SUM(QFPTMV)') (QGPVPA '%SUM(QFPVPA)') +*/ /*S01486*/
/**********               (QGPVNA '%SUM(QFPVNA)') (QGPVMV +        */ /*S01486*/
/**********               '%SUM(QFPVMV)') (QGPTAI '%SUM(QFPTAI)')) */ /*S01486*/
/*********** OPNQRYF    FILE((PMHOLDQ3)) FORMAT(PMCCYTPD) +           /*CCG009*/
/***********              GRPFLD(QFCNUM QFPTFR QFCCY) +               /*CCG009*/
/***********              MAPFLD((QGCNUM QFCNUM) (QGPTFR QFPTFR) +    /*CCG009*/
/***********              (QGCCY QFCCY) (QGPTPA '%SUM(QFPTPA)') +     /*CCG009*/
/***********              (QGPTNA '%SUM(QFPTNA)') (QGPTMV +           /*CCG009*/
/***********              '%SUM(QFPTMV)') (QGPVPA '%SUM(QFPVPA)') +   /*CCG009*/
/***********              (QGPVNA '%SUM(QFPVNA)') (QGPVMV +           /*CCG009*/
/***********              '%SUM(QFPVMV)') (QGPTAI '%SUM(QFPTAI*S01486 /*CCG009*/
/*********** OPNQRYF    FILE((PMHOLDQ3)) FORMAT(PMCCYTPD) +           /*CPM005*/
/************************ GRPFLD(QFCNUM QFPTFR QFCCY) +               /*CPM005*/
/************************ MAPFLD((QGCNUM QFCNUM) (QGPTFR QFPTFR) +    /*CPM005*/
/************************ (QGCCY QFCCY) (QGPTPA '%SUM(QFPTPA)') +     /*CPM005*/
/************************ (QGPTNA '%SUM(QFPTNA)') (QGPTMV +           /*CPM005*/
/************************ '%SUM(QFPTMV)') (QGPVPA '%SUM(QFPVPA)') +   /*CPM005*/
/************************ (QGPVNA '%SUM(QFPVNA)') (QGPVMV +           /*CPM005*/
/************************ '%SUM(QFPVMV)') (QGPTAI '%SUM(QFPTAI)') +   /*CPM005*/
/************************ (QGPTNI '%SUM(QFPTNI)'))             /*CCG009 CPM005*/
/**********  CPYFRMQRYF FROMOPNID(PMHOLDX3) TOFILE(PMCCYTPP) +     */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMHOLDQ3) TOFILE(PMCCYTPD) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)          /*S01486 CPM005*/
/**********  CLOF       OPNID(PMHOLDX3)                            */ /*S01486*/
/*********** CLOF       OPNID(PMHOLDQ3)                        /*S01486 CPM005*/
 
/* CREATE COUNTRY TOTALS FOR ALL DEFINED PORTFOLIOS & 9997 PORTFOLIO   */
/**********  OPNQRYF    FILE((PMHOLDX2)) FORMAT(PMCNTTX0) +        */ /*S01486*/
/**********               GRPFLD(QFCNUM QFPTFR QFCNTR) +           */ /*S01486*/
/**********               MAPFLD((WHCNUM QFCNUM) (WHPTFR QFPTFR) + */ /*S01486*/
/**********               (WHCNTR QFCNTR) (WHPTPA '%SUM(QFPTPA)') +*/ /*S01486*/
/**********               (WHPTNA '%SUM(QFPTNA)') (WHPTMV +        */ /*S01486*/
/**********               '%SUM(QFPTMV)') (WHPVPA '%SUM(QFPVPA)') +*/ /*S01486*/
/**********               (WHPVNA '%SUM(QFPVNA)') (WHPVMV +        */ /*S01486*/
/**********               '%SUM(QFPVMV)') (WHPTAI '%SUM(QFPTAI)')) */ /*S01486*/
/*********** OPNQRYF    FILE((PMHOLDQ2)) FORMAT(PMCNTWPD) +           /*CCG009*/
/***********              GRPFLD(QFCNUM QFPTFR QFCNTR) +              /*CCG009*/
/***********              MAPFLD((WHCNUM QFCNUM) (WHPTFR QFPTFR) +    /*CCG009*/
/***********              (WHCNTR QFCNTR) (WHPTPA '%SUM(QFPTPA)') +   /*CCG009*/
/***********              (WHPTNA '%SUM(QFPTNA)') (WHPTMV +           /*CCG009*/
/***********              '%SUM(QFPTMV)') (WHPVPA '%SUM(QFPVPA)') +   /*CCG009*/
/***********              (WHPVNA '%SUM(QFPVNA)') (WHPVMV +           /*CCG009*/
/***********              '%SUM(QFPVMV)') (WHPTAI '%SUM(QFPTAIS01486* /*CCG009*/
/**********  OPNQRYF    FILE((PMHOLDQ2)) FORMAT(PMCNTWPD) +               */            /*AR796218*/
/**********               GRPFLD(QFCNUM QFPTFR QFCNTR) +                  */            /*AR796218*/
/**********               MAPFLD((WHCNUM QFCNUM) (WHPTFR QFPTFR) +        */            /*AR796218*/
/**********               (WHCNTR QFCNTR) (WHPTPA '%SUM(QFPTPA)') +       */            /*AR796218*/
/**********               (WHPTNA '%SUM(QFPTNA)') (WHPTMV +               */            /*AR796218*/
/**********               '%SUM(QFPTMV)') (WHPVPA '%SUM(QFPVPA)') +       */            /*AR796218*/
/**********               (WHPVNA '%SUM(QFPVNA)') (WHPVMV +               */            /*AR796218*/
/**********               '%SUM(QFPVMV)') (WHPTAI '%SUM(QFPTAI)') +       */            /*AR796218*/
/**********               (WHPTNI '%SUM(QFPTNI)'))                        */ /*CCG009*/ /*AR796218*/
             OPNQRYF    FILE((PMHOLDQ2)) FORMAT(PMCNTWPD)         +
                          GRPFLD(QFCNUM QFPTFR QFCNTR QFLOIC)     +
                          MAPFLD((WHCNUM QFCNUM) (WHPTFR QFPTFR)  +
                          (WHCNTR QFCNTR) (WHLOIC QFLOIC)         +
                          (WHPTPA '%SUM(QFPTPA)')                 +
                          (WHPTNA '%SUM(QFPTNA)') (WHPTMV         +
                          '%SUM(QFPTMV)') (WHPVPA '%SUM(QFPVPA)') +
                          (WHPVNA '%SUM(QFPVNA)') (WHPVMV         +
                          '%SUM(QFPVMV)') (WHPTAI '%SUM(QFPTAI)') +
                          (WHPTNI '%SUM(QFPTNI)'))                                      /*AR796218*/
/**********  CPYFRMQRYF FROMOPNID(PMHOLDX2) TOFILE(PMCNTTX0) +     */ /*S01486*/
/**********               MBROPT(*REPLACE) FMTOPT(*NOCHK)          */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMHOLDQ2) TOFILE(PMCNTWPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*S01486*/
/**********  CLOF       OPNID(PMHOLDX2)                            */ /*S01486*/
             CLOF       OPNID(PMHOLDQ2)                               /*S01486*/
 
/**COPY*TOTALS*FROM*PMCNTTX0*TO*COUNTRY*TOTALS*FILE*****************/ /*S01486*/
/* COPY TOTALS FROM PMCNTWPD TO COUNTRY TOTALS FILE */                /*S01486*/
/**********  CPYF       FROMFILE(PMCNTTX0) TOFILE(PMCNTTPP) +      */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYF       FROMFILE(PMCNTWPD) TOFILE(PMCNTTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
 
/* CREATE TOTALS FILE FOR 9998 AND 9999 PORTFOLIOS WHERE THE */
/* CUSTOMER ONLY HAS PORTFOLIOS IN BASE CURRENCY */
/**********  OPNQRYF    FILE((PMCNTTX0)) FORMAT(PMCNTTPP) +        */ /*S01486*/
/**********             QRYSLT('WHPTFR *NE "9997"') GRPFLD(WHCNUM +*/ /*S01486*/
/**********               WHCNTR) MAPFLD((QHCNUM WHCNUM) (QHPTFR + */ /*S01486*/
/**********               "9998") (QHCNTR WHCNTR) (QHPTPA +        */ /*S01486*/
/**********               '%SUM(WHPTPA)') (QHPTNA '%SUM(WHPTNA)') +*/ /*S01486*/
/**********               (QHPTMV '%SUM(WHPTMV)') (QHPVPA +        */ /*S01486*/
/**********               '%SUM(WHPVPA)') (QHPVNA '%SUM(WHPVNA)') +*/ /*S01486*/
/**********               (QHPVMV '%SUM(WHPVMV)') (QHPTAI +        */ /*S01486*/
/**********               '%SUM(WHPTAI)'))                         */ /*S01486*/
/*********** OPNQRYF    FILE((PMCNTWPD)) FORMAT(PMCNTTPD) +           /*CCG009*/
/***********              QRYSLT('WHPTFR *NE "9997"') GRPFLD(WHCNUM + /*CCG009*/
/***********              WHCNTR) MAPFLD((QHCNUM WHCNUM) (QHPTFR +    /*CCG009*/
/***********              "9998") (QHCNTR WHCNTR) (QHPTPA +           /*CCG009*/
/***********              '%SUM(WHPTPA)') (QHPTNA '%SUM(WHPTNA)') +   /*CCG009*/
/***********              (QHPTMV '%SUM(WHPTMV)') (QHPVPA +           /*CCG009*/
/***********              '%SUM(WHPVPA)') (QHPVNA '%SUM(WHPVNA)') +   /*CCG009*/
/***********              (QHPVMV '%SUM(WHPVMV)') (QHPTAI +           /*CCG009*/
/***********              '%SUM(WHPTAI)'))              /*S01486*/    /*CCG009*/
/**********  OPNQRYF    FILE((PMCNTWPD)) FORMAT(PMCNTTPD) +               */            /*AR796218*/
/**********               QRYSLT('WHPTFR *NE "9997"') GRPFLD(WHCNUM +     */            /*AR796218*/
/**********               WHCNTR) MAPFLD((QHCNUM WHCNUM) (QHPTFR +        */            /*AR796218*/
/**********               "9998") (QHCNTR WHCNTR) (QHPTPA +               */            /*AR796218*/
/**********               '%SUM(WHPTPA)') (QHPTNA '%SUM(WHPTNA)') +       */            /*AR796218*/
/**********               (QHPTMV '%SUM(WHPTMV)') (QHPVPA +               */            /*AR796218*/
/**********               '%SUM(WHPVPA)') (QHPVNA '%SUM(WHPVNA)') +       */            /*AR796218*/
/**********               (QHPVMV '%SUM(WHPVMV)') (QHPTAI +               */            /*AR796218*/
/**********               '%SUM(WHPTAI)') (QHPTNI '%SUM(WHPTNI)'))        */ /*CCG009*/ /*AR796218*/
             OPNQRYF    FILE((PMCNTWPD)) FORMAT(PMCNTTPD) +
                          QRYSLT('WHPTFR *NE "9997"') GRPFLD(WHCNUM       +
                          WHCNTR WHLOIC) MAPFLD((QHCNUM WHCNUM) (QHPTFR   +
                          "9998") (QHCNTR WHCNTR) (QHLOIC WHLOIC) (QHPTPA +
                          '%SUM(WHPTPA)') (QHPTNA '%SUM(WHPTNA)')         +
                          (QHPTMV '%SUM(WHPTMV)') (QHPVPA                 +
                          '%SUM(WHPVPA)') (QHPVNA '%SUM(WHPVNA)')         +
                          (QHPVMV '%SUM(WHPVMV)') (QHPTAI                 +
                          '%SUM(WHPTAI)') (QHPTNI '%SUM(WHPTNI)'))                      /*AR796218*/
                                                                      /*CCG009*/
/**********  CPYFRMQRYF FROMOPNID(PMCNTTX0) TOFILE(PMCNTTPP) +     */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMCNTWPD) TOFILE(PMCNTTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
/**********  CLOF       OPNID(PMCNTTX0)                            */ /*S01486*/
             CLOF       OPNID(PMCNTWPD)                               /*S01486*/
 
/**********  OPNQRYF    FILE((PMCNTTX0)) FORMAT(PMCNTTPP) +        */ /*S01486*/
/**********               GRPFLD(WHCNUM WHCNTR) MAPFLD((QHCNUM +   */ /*S01486*/
/**********               WHCNUM) (QHPTFR "9999") (QHCNTR WHCNTR) +*/ /*S01486*/
/**********               (QHPTPA '%SUM(WHPTPA)') (QHPTNA +        */ /*S01486*/
/**********               '%SUM(WHPTNA)') (QHPTMV '%SUM(WHPTMV)') +*/ /*S01486*/
/**********               (QHPVPA '%SUM(WHPVPA)') (QHPVNA +        */ /*S01486*/
/**********               '%SUM(WHPVNA)') (QHPVMV '%SUM(WHPVMV)') +*/ /*S01486*/
/**********               (QHPTAI '%SUM(WHPTAI)'))                 */ /*S01486*/
/*********** OPNQRYF    FILE((PMCNTWPD)) FORMAT(PMCNTTPD) +           /*CCG009*/
/***********              GRPFLD(WHCNUM WHCNTR) MAPFLD((QHCNUM +      /*CCG009*/
/***********              WHCNUM) (QHPTFR "9999") (QHCNTR WHCNTR) +   /*CCG009*/
/***********              (QHPTPA '%SUM(WHPTPA)') (QHPTNA +           /*CCG009*/
/***********              '%SUM(WHPTNA)') (QHPTMV '%SUM(WHPTMV)') +   /*CCG009*/
/***********              (QHPVPA '%SUM(WHPVPA)') (QHPVNA +           /*CCG009*/
/***********              '%SUM(WHPVNA)') (QHPVMV '%SUM(WHPVMV)') +   /*CCG009*/
/***********              (QHPTAI '%SUM(WHPTAI)'))         /*S01486*/ /*CCG009*/
             IF         COND(%SST(&FMT 104 1) *NE 'Y') THEN(DO)       /*CPB001*/
/**********  OPNQRYF    FILE((PMCNTWPD)) FORMAT(PMCNTTPD) +               */            /*AR796218*/
/**********               GRPFLD(WHCNUM WHCNTR) MAPFLD((QHCNUM +          */            /*AR796218*/
/**********               WHCNUM) (QHPTFR "9999") (QHCNTR WHCNTR) +       */            /*AR796218*/
/**********               (QHPTPA '%SUM(WHPTPA)') (QHPTNA +               */            /*AR796218*/
/**********               '%SUM(WHPTNA)') (QHPTMV '%SUM(WHPTMV)') +       */            /*AR796218*/
/**********               (QHPVPA '%SUM(WHPVPA)') (QHPVNA +               */            /*AR796218*/
/**********               '%SUM(WHPVNA)') (QHPVMV '%SUM(WHPVMV)') +       */            /*AR796218*/
/**********               (QHPTAI '%SUM(WHPTAI)') (QHPTNI +               */            /*AR796218*/
/**********               '%SUM(WHPTNI)'))                                */ /*CCG009*/ /*AR796218*/
             OPNQRYF    FILE((PMCNTWPD)) FORMAT(PMCNTTPD)             +
                          GRPFLD(WHCNUM WHCNTR WHLOIC) MAPFLD((QHCNUM +
                          WHCNUM) (QHPTFR "9999") (QHCNTR WHCNTR)     +
                          (QHLOIC WHLOIC)                             +
                          (QHPTPA '%SUM(WHPTPA)') (QHPTNA             +
                          '%SUM(WHPTNA)') (QHPTMV '%SUM(WHPTMV)')     +
                          (QHPVPA '%SUM(WHPVPA)') (QHPVNA             +
                          '%SUM(WHPVNA)') (QHPVMV '%SUM(WHPVMV)')     +
                          (QHPTAI '%SUM(WHPTAI)') (QHPTNI             +
                          '%SUM(WHPTNI)'))                                              /*AR796218*/
/**********  CPYFRMQRYF FROMOPNID(PMCNTTX0) TOFILE(PMCNTTPP) +     */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMCNTWPD) TOFILE(PMCNTTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
/**********  CLOF       OPNID(PMCNTTX0)                            */ /*S01486*/
             CLOF       OPNID(PMCNTWPD)                               /*S01486*/
             ENDDO                                                    /*CPB001*/
 
/* CREATE TOTALS FILE FOR ALL PORTFOLIOS FOR CUSTOMERS WITH */
/* PORTFOLIOS NOT IN CUSTOMER BASE CURRENCY */
/**********  OPNQRYF    FILE((PMHOLDX3)) FORMAT(PMCNTTPP) +        */ /*S01486*/
/**********               GRPFLD(QFCNUM QFPTFR QFCNTR) +           */ /*S01486*/
/**********               MAPFLD((QHCNUM QFCNUM) (QHPTFR QFPTFR) + */ /*S01486*/
/**********               (QHCNTR QFCNTR) (QHPTPA '%SUM(QFPTPA)') +*/ /*S01486*/
/**********               (QHPTNA '%SUM(QFPTNA)') (QHPTMV +        */ /*S01486*/
/**********               '%SUM(QFPTMV)') (QHPVPA '%SUM(QFPVPA)') +*/ /*S01486*/
/**********               (QHPVNA '%SUM(QFPVNA)') (QHPVMV +        */ /*S01486*/
/**********               '%SUM(QFPVMV)') (QHPTAI '%SUM(QFPTAI)')) */ /*S01486*/
/*********** OPNQRYF    FILE((PMHOLDQ3)) FORMAT(PMCNTTPD) +           /*CCG009*/
/***********              GRPFLD(QFCNUM QFPTFR QFCNTR) +              /*CCG009*/
/***********              MAPFLD((QHCNUM QFCNUM) (QHPTFR QFPTFR) +    /*CCG009*/
/***********              (QHCNTR QFCNTR) (QHPTPA '%SUM(QFPTPA)') +   /*CCG009*/
/***********              (QHPTNA '%SUM(QFPTNA)') (QHPTMV +           /*CCG009*/
/***********              '%SUM(QFPTMV)') (QHPVPA '%SUM(QFPVPA)') +   /*CCG009*/
/***********              (QHPVNA '%SUM(QFPVNA)') (QHPVMV +           /*CCG009*/
/***********              '%SUM(QFPVMV)') (QHPTAI '%SUM(QFPTAI)S01486 /*CCG009*/
/**********  OPNQRYF    FILE((PMHOLDQ3)) FORMAT(PMCNTTPD) +               */            /*AR796218*/
/**********               GRPFLD(QFCNUM QFPTFR QFCNTR) +                  */            /*AR796218*/
/**********               MAPFLD((QHCNUM QFCNUM) (QHPTFR QFPTFR) +        */            /*AR796218*/
/**********               (QHCNTR QFCNTR) (QHPTPA '%SUM(QFPTPA)') +       */            /*AR796218*/
/**********               (QHPTNA '%SUM(QFPTNA)') (QHPTMV +               */            /*AR796218*/
/**********               '%SUM(QFPTMV)') (QHPVPA '%SUM(QFPVPA)') +       */            /*AR796218*/
/**********               (QHPVNA '%SUM(QFPVNA)') (QHPVMV +               */            /*AR796218*/
/**********               '%SUM(QFPVMV)') (QHPTAI '%SUM(QFPTAI)') +       */            /*AR796218*/
/**********               (QHPTNI '%SUM(QFPTNI)'))                        */ /*CCG009*/ /*AR796218*/
             OPNQRYF    FILE((PMHOLDQ3)) FORMAT(PMCNTTPD)         +
                          GRPFLD(QFCNUM QFPTFR QFCNTR QFLOIC)     +
                          MAPFLD((QHCNUM QFCNUM) (QHPTFR QFPTFR)  +
                          (QHCNTR QFCNTR) (QHLOIC QFLOIC)         +
                          (QHPTPA '%SUM(QFPTPA)')                 +
                          (QHPTNA '%SUM(QFPTNA)') (QHPTMV         +
                          '%SUM(QFPTMV)') (QHPVPA '%SUM(QFPVPA)') +
                          (QHPVNA '%SUM(QFPVNA)') (QHPVMV         +
                          '%SUM(QFPVMV)') (QHPTAI '%SUM(QFPTAI)') +
                          (QHPTNI '%SUM(QFPTNI)'))                                      /*AR796218*/
/**********  CPYFRMQRYF FROMOPNID(PMHOLDX3) TOFILE(PMCNTTPP) +     */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMHOLDQ3) TOFILE(PMCNTTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
/**********  CLOF       OPNID(PMHOLDX3)                            */ /*S01486*/
             CLOF       OPNID(PMHOLDQ3)                               /*S01486*/
 
/* CREATE INDUSTRY TOTALS FOR ALL DEFINED PORTFOLIOS & 9997 PORTFOLIO  */
/**********  OPNQRYF    FILE((PMHOLDX2)) FORMAT(PMINDTX0) +        */ /*S01486*/
/**********               GRPFLD(QFCNUM QFPTFR QFLIND) +           */ /*S01486*/
/**********               MAPFLD((WICNUM QFCNUM) (WIPTFR QFPTFR) + */ /*S01486*/
/**********               (WILIND QFLIND) (WIPTPA '%SUM(QFPTPA)') +*/ /*S01486*/
/**********               (WIPTNA '%SUM(QFPTNA)') (WIPTMV +        */ /*S01486*/
/**********               '%SUM(QFPTMV)') (WIPVPA '%SUM(QFPVPA)') +*/ /*S01486*/
/**********               (WIPVNA '%SUM(QFPVNA)') (WIPVMV +        */ /*S01486*/
/**********               '%SUM(QFPVMV)') (WIPTAI '%SUM(QFPTAI)')) */ /*S01486*/
/*********** OPNQRYF    FILE((PMHOLDQ2)) FORMAT(PMINDWPD) +           /*CCG009*/
/***********              GRPFLD(QFCNUM QFPTFR QFLIND) +              /*CCG009*/
/***********              MAPFLD((WICNUM QFCNUM) (WIPTFR QFPTFR) +    /*CCG009*/
/***********              (WILIND QFLIND) (WIPTPA '%SUM(QFPTPA)') +   /*CCG009*/
/***********              (WIPTNA '%SUM(QFPTNA)') (WIPTMV +           /*CCG009*/
/***********              '%SUM(QFPTMV)') (WIPVPA '%SUM(QFPVPA)') +   /*CCG009*/
/***********              (WIPVNA '%SUM(QFPVNA)') (WIPVMV +           /*CCG009*/
/***********              '%SUM(QFPVMV)') (WIPTAI '%SUM(QFPTAI*S01486 /*CCG009*/
/**********  OPNQRYF    FILE((PMHOLDQ2)) FORMAT(PMINDWPD) +
                          GRPFLD(QFCNUM QFPTFR QFLIND) +
                          MAPFLD((WICNUM QFCNUM) (WIPTFR QFPTFR) +
                          (WILIND QFLIND) (WIPTPA '%SUM(QFPTPA)') +
                          (WIPTNA '%SUM(QFPTNA)') (WIPTMV +
                          '%SUM(QFPTMV)') (WIPVPA '%SUM(QFPVPA)') +
                          (WIPVNA '%SUM(QFPVNA)') (WIPVMV +
                          '%SUM(QFPVMV)') (WIPTAI '%SUM(QFPTAI)') +
                          (WIPTNI '%SUM(QFPTNI)'))                           /*CCG009*/ /*BUG23967*/
/**********  OPNQRYF    FILE((PMHOLDQ2)) FORMAT(PMINDWPD) +             */              /*AR796218*/
/**********               GRPFLD(QFCNUM QFPTFR QFLOIC) +                */              /*AR796218*/
/**********               MAPFLD((WICNUM QFCNUM) (WIPTFR QFPTFR) +      */              /*AR796218*/
/**********               (WILOIC QFLOIC) (WIPTPA '%SUM(QFPTPA)') +     */              /*AR796218*/
/**********               (WIPTNA '%SUM(QFPTNA)') (WIPTMV +             */              /*AR796218*/
/**********               '%SUM(QFPTMV)') (WIPVPA '%SUM(QFPVPA)') +     */              /*AR796218*/
/**********               (WIPVNA '%SUM(QFPVNA)') (WIPVMV +             */              /*AR796218*/
/**********               '%SUM(QFPVMV)') (WIPTAI '%SUM(QFPTAI)') +     */              /*AR796218*/
/**********               (WIPTNI '%SUM(QFPTNI)'))                      */ /*BUG23967*/ /*AR796218*/
             OPNQRYF    FILE((PMHOLDQ2)) FORMAT(PMINDWPD)         +
                          GRPFLD(QFCNUM QFPTFR QFLIND QFLOIC)     +
                          MAPFLD((WICNUM QFCNUM) (WIPTFR QFPTFR)  +
                          (WILIND QFLIND) (WILOIC QFLOIC)         +
                          (WIPTPA '%SUM(QFPTPA)')                 +
                          (WIPTNA '%SUM(QFPTNA)') (WIPTMV         +
                          '%SUM(QFPTMV)') (WIPVPA '%SUM(QFPVPA)') +
                          (WIPVNA '%SUM(QFPVNA)') (WIPVMV         +
                          '%SUM(QFPVMV)') (WIPTAI '%SUM(QFPTAI)') +
                          (WIPTNI '%SUM(QFPTNI)'))                                      /*AR796218*/
/**********  CPYFRMQRYF FROMOPNID(PMHOLDX2) TOFILE(PMINDTX0) +     */ /*S01486*/
/**********               MBROPT(*REPLACE) FMTOPT(*NOCHK)          */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMHOLDQ2) TOFILE(PMINDWPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
/**********  CLOF       OPNID(PMHOLDX2)                            */ /*S01486*/
             CLOF       OPNID(PMHOLDQ2)                               /*S01486*/
 
/**COPY*TOTALS*FROM*PMINDTX0*TO*INDUSTRY*TOTALS*FILE****************/ /*S01486*/
/* COPY TOTALS FROM PMINDWPD TO INDUSTRY TOTALS FILE */               /*S01486*/
/**********  CPYF       FROMFILE(PMINDTX0) TOFILE(PMINDTPP) +      */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYF       FROMFILE(PMINDWPD) TOFILE(PMINDTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
 
/* CREATE TOTALS FILE FOR 9998 AND 9999 PORTFOLIOS WHERE THE */
/* CUSTOMER ONLY HAS PORTFOLIOS IN BASE CURRENCY */
/**********  OPNQRYF    FILE((PMINDTX0)) FORMAT(PMINDTPP) +        */ /*S01486*/
/**********             QRYSLT('WIPTFR *NE "9997"') GRPFLD(WICNUM +*/ /*S01486*/
/**********               WILIND) MAPFLD((QICNUM WICNUM) (QIPTFR + */ /*S01486*/
/**********               "9998") (QILIND WILIND) (QIPTPA +        */ /*S01486*/
/**********               '%SUM(WIPTPA)') (QIPTNA '%SUM(WIPTNA)') +*/ /*S01486*/
/**********               (QIPTMV '%SUM(WIPTMV)') (QIPVPA +        */ /*S01486*/
/**********               '%SUM(WIPVPA)') (QIPVNA '%SUM(WIPVNA)') +*/ /*S01486*/
/**********               (QIPVMV '%SUM(WIPVMV)') (QIPTAI +        */ /*S01486*/
/**********               '%SUM(WIPTAI)'))                         */ /*S01486*/
/*********** OPNQRYF    FILE((PMINDWPD)) FORMAT(PMINDTPD) +           /*CCG009*/
/***********              QRYSLT('WIPTFR *NE "9997"') GRPFLD(WICNUM + /*CCG009*/
/***********              WILIND) MAPFLD((QICNUM WICNUM) (QIPTFR +    /*CCG009*/
/***********              "9998") (QILIND WILIND) (QIPTPA +           /*CCG009*/
/***********              '%SUM(WIPTPA)') (QIPTNA '%SUM(WIPTNA)') +   /*CCG009*/
/***********              (QIPTMV '%SUM(WIPTMV)') (QIPVPA +           /*CCG009*/
/***********              '%SUM(WIPVPA)') (QIPVNA '%SUM(WIPVNA)') +   /*CCG009*/
/***********              (QIPVMV '%SUM(WIPVMV)') (QIPTAI +           /*CCG009*/
/***********              '%SUM(WIPTAI)'))                 *S01486*/  /*CCG009*/
/**********  OPNQRYF    FILE((PMINDWPD)) FORMAT(PMINDTPD) +
                          QRYSLT('WIPTFR *NE "9997"') GRPFLD(WICNUM +
                          WILIND) MAPFLD((QICNUM WICNUM) (QIPTFR +
                          "9998") (QILIND WILIND) (QIPTPA +
                          '%SUM(WIPTPA)') (QIPTNA '%SUM(WIPTNA)') +
                          (QIPTMV '%SUM(WIPTMV)') (QIPVPA +
                          '%SUM(WIPVPA)') (QIPVNA '%SUM(WIPVNA)') +
                          (QIPVMV '%SUM(WIPVMV)') (QIPTAI +
                          '%SUM(WIPTAI)') (QIPTNI '%SUM(WIPTNI)'))           /*CCG009*/ /*BUG23967*/
                                                                      /*CCG009*/
/**********  OPNQRYF    FILE((PMINDWPD)) FORMAT(PMINDTPD) +             */              /*AR796218*/
/**********               QRYSLT('WIPTFR *NE "9997"') GRPFLD(WICNUM +   */              /*AR796218*/
/**********               WILOIC) MAPFLD((QICNUM WICNUM) (QIPTFR +      */              /*AR796218*/
/**********               "9998") (QILOIC WILOIC) (QIPTPA +             */              /*AR796218*/
/**********               '%SUM(WIPTPA)') (QIPTNA '%SUM(WIPTNA)') +     */              /*AR796218*/
/**********               (QIPTMV '%SUM(WIPTMV)') (QIPVPA +             */              /*AR796218*/
/**********               '%SUM(WIPVPA)') (QIPVNA '%SUM(WIPVNA)') +     */              /*AR796218*/
/**********               (QIPVMV '%SUM(WIPVMV)') (QIPTAI +             */              /*AR796218*/
/**********               '%SUM(WIPTAI)') (QIPTNI '%SUM(WIPTNI)'))      */ /*BUG23967*/ /*AR796218*/
             OPNQRYF    FILE((PMINDWPD)) FORMAT(PMINDTPD)                 +
                          QRYSLT('WIPTFR *NE "9997"') GRPFLD(WICNUM       +
                          WILIND WILOIC) MAPFLD((QICNUM WICNUM) (QIPTFR   +
                          "9998") (QILIND WILIND) (QILOIC WILOIC) (QIPTPA +
                          '%SUM(WIPTPA)') (QIPTNA '%SUM(WIPTNA)')         +
                          (QIPTMV '%SUM(WIPTMV)') (QIPVPA                 +
                          '%SUM(WIPVPA)') (QIPVNA '%SUM(WIPVNA)')         +
                          (QIPVMV '%SUM(WIPVMV)') (QIPTAI                 +
                          '%SUM(WIPTAI)') (QIPTNI '%SUM(WIPTNI)'))                      /*AR796218*/
/**********  CPYFRMQRYF FROMOPNID(PMINDTX0) TOFILE(PMINDTPP) +     */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMINDWPD) TOFILE(PMINDTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
/**********  CLOF       OPNID(PMINDTX0)                            */ /*S01486*/
             CLOF       OPNID(PMINDWPD)                               /*S01486*/
 
/**********  OPNQRYF    FILE((PMINDTX0)) FORMAT(PMINDTPP) +        */ /*S01486*/
/**********               GRPFLD(WICNUM WILIND) MAPFLD((QICNUM +   */ /*S01486*/
/**********               WICNUM) (QIPTFR "9999") (QILIND WILIND) +*/ /*S01486*/
/**********               (QIPTPA '%SUM(WIPTPA)') (QIPTNA +        */ /*S01486*/
/**********               '%SUM(WIPTNA)') (QIPTMV '%SUM(WIPTMV)') +*/ /*S01486*/
/**********               (QIPVPA '%SUM(WIPVPA)') (QIPVNA +        */ /*S01486*/
/**********               '%SUM(WIPVNA)') (QIPVMV '%SUM(WIPVMV)') +*/ /*S01486*/
/**********               (QIPTAI '%SUM(WIPTAI)'))                 */ /*S01486*/
/*********** OPNQRYF    FILE((PMINDWPD)) FORMAT(PMINDTPD) +           /*CCG009*/
/***********              GRPFLD(WICNUM WILIND) MAPFLD((QICNUM +      /*CCG009*/
/***********              WICNUM) (QIPTFR "9999") (QILIND WILIND) +   /*CCG009*/
/***********              (QIPTPA '%SUM(WIPTPA)') (QIPTNA +           /*CCG009*/
/***********              '%SUM(WIPTNA)') (QIPTMV '%SUM(WIPTMV)') +   /*CCG009*/
/***********              (QIPVPA '%SUM(WIPVPA)') (QIPVNA +           /*CCG009*/
/***********              '%SUM(WIPVNA)') (QIPVMV '%SUM(WIPVMV)') +   /*CCG009*/
/***********              (QIPTAI '%SUM(WIPTAI)'))         /*S01486*/ /*CCG009*/
             IF         COND(%SST(&FMT 104 1) *NE 'Y') THEN(DO)       /*CPB001*/
/**********  OPNQRYF    FILE((PMINDWPD)) FORMAT(PMINDTPD) +
                          GRPFLD(WICNUM WILIND) MAPFLD((QICNUM +
                          WICNUM) (QIPTFR "9999") (QILIND WILIND) +
                          (QIPTPA '%SUM(WIPTPA)') (QIPTNA +
                          '%SUM(WIPTNA)') (QIPTMV '%SUM(WIPTMV)') +
                          (QIPVPA '%SUM(WIPVPA)') (QIPVNA +
                          '%SUM(WIPVNA)') (QIPVMV '%SUM(WIPVMV)') +
                          (QIPTAI '%SUM(WIPTAI)') (QIPTNI +
                          '%SUM(WIPTNI)'))                                   /*CCG009*/ /*BUG23967*/
/**********  OPNQRYF    FILE((PMINDWPD)) FORMAT(PMINDTPD) +             */              /*AR796218*/
/**********               GRPFLD(WICNUM WILOIC) MAPFLD((QICNUM +        */              /*AR796218*/
/**********               WICNUM) (QIPTFR "9999") (QILOIC WILOIC) +     */              /*AR796218*/
/**********               (QIPTPA '%SUM(WIPTPA)') (QIPTNA +             */              /*AR796218*/
/**********               '%SUM(WIPTNA)') (QIPTMV '%SUM(WIPTMV)') +     */              /*AR796218*/
/**********               (QIPVPA '%SUM(WIPVPA)') (QIPVNA +             */              /*AR796218*/
/**********               '%SUM(WIPVNA)') (QIPVMV '%SUM(WIPVMV)') +     */              /*AR796218*/
/**********               (QIPTAI '%SUM(WIPTAI)') (QIPTNI +             */              /*AR796218*/
/**********               '%SUM(WIPTNI)'))                              */ /*BUG23967*/ /*AR796218*/
             OPNQRYF    FILE((PMINDWPD)) FORMAT(PMINDTPD)             +
                          GRPFLD(WICNUM WILIND WILOIC) MAPFLD((QICNUM +
                          WICNUM) (QIPTFR "9999")                     +
                          (QILIND WILIND) (QILOIC WILOIC)             +
                          (QIPTPA '%SUM(WIPTPA)') (QIPTNA             +
                          '%SUM(WIPTNA)') (QIPTMV '%SUM(WIPTMV)')     +
                          (QIPVPA '%SUM(WIPVPA)') (QIPVNA             +
                          '%SUM(WIPVNA)') (QIPVMV '%SUM(WIPVMV)')     +
                          (QIPTAI '%SUM(WIPTAI)') (QIPTNI             +
                          '%SUM(WIPTNI)'))                                              /*AR796218*/
/**********  CPYFRMQRYF FROMOPNID(PMINDTX0) TOFILE(PMINDTPP) +     */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMINDWPD) TOFILE(PMINDTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
/**********  CLOF       OPNID(PMINDTX0)                            */ /*S01486*/
             CLOF       OPNID(PMINDWPD)                               /*S01486*/
             ENDDO                                                    /*CPB001*/
 
/* CREATE TOTALS FILE FOR ALL PORTFOLIOS FOR CUSTOMERS WITH */
/* PORTFOLIOS NOT IN CUSTOMER BASE CURRENCY */
/**********  OPNQRYF    FILE((PMHOLDX3)) FORMAT(PMINDTPP) +        */ /*S01486*/
/**********               GRPFLD(QFCNUM QFPTFR QFLIND) +           */ /*S01486*/
/**********               MAPFLD((QICNUM QFCNUM) (QIPTFR QFPTFR) + */ /*S01486*/
/**********               (QILIND QFLIND) (QIPTPA '%SUM(QFPTPA)') +*/ /*S01486*/
/**********               (QIPTNA '%SUM(QFPTNA)') (QIPTMV +        */ /*S01486*/
/**********               '%SUM(QFPTMV)') (QIPVPA '%SUM(QFPVPA)') +*/ /*S01486*/
/**********               (QIPVNA '%SUM(QFPVNA)') (QIPVMV +        */ /*S01486*/
/**********               '%SUM(QFPVMV)') (QIPTAI '%SUM(QFPTAI)')) */ /*S01486*/
/*********** OPNQRYF    FILE((PMHOLDQ3)) FORMAT(PMINDTPD) +           /*CCG009*/
/***********              GRPFLD(QFCNUM QFPTFR QFLIND) +              /*CCG009*/
/***********              MAPFLD((QICNUM QFCNUM) (QIPTFR QFPTFR) +    /*CCG009*/
/***********              (QILIND QFLIND) (QIPTPA '%SUM(QFPTPA)') +   /*CCG009*/
/***********              (QIPTNA '%SUM(QFPTNA)') (QIPTMV +           /*CCG009*/
/***********              '%SUM(QFPTMV)') (QIPVPA '%SUM(QFPVPA)') +   /*CCG009*/
/***********              (QIPVNA '%SUM(QFPVNA)') (QIPVMV +           /*CCG009*/
/***********              '%SUM(QFPVMV)') (QIPTAI '%SUM(QFPTAI)S01486 /*CCG009*/
/**********  OPNQRYF    FILE((PMHOLDQ3)) FORMAT(PMINDTPD) +
                          GRPFLD(QFCNUM QFPTFR QFLIND) +
                          MAPFLD((QICNUM QFCNUM) (QIPTFR QFPTFR) +
                          (QILIND QFLIND) (QIPTPA '%SUM(QFPTPA)') +
                          (QIPTNA '%SUM(QFPTNA)') (QIPTMV +
                          '%SUM(QFPTMV)') (QIPVPA '%SUM(QFPVPA)') +
                          (QIPVNA '%SUM(QFPVNA)') (QIPVMV +
                          '%SUM(QFPVMV)') (QIPTAI '%SUM(QFPTAI)') +
                          (QIPTNI '%SUM(QFPTNI)'))                           /*CCG009*/ /*BUG23967*/
/**********  OPNQRYF    FILE((PMHOLDQ3)) FORMAT(PMINDTPD) +             */              /*AR796218*/
/**********               GRPFLD(QFCNUM QFPTFR QFLOIC) +                */              /*AR796218*/
/**********               MAPFLD((QICNUM QFCNUM) (QIPTFR QFPTFR) +      */              /*AR796218*/
/**********               (QILOIC QFLOIC) (QIPTPA '%SUM(QFPTPA)') +     */              /*AR796218*/
/**********               (QIPTNA '%SUM(QFPTNA)') (QIPTMV +             */              /*AR796218*/
/**********               '%SUM(QFPTMV)') (QIPVPA '%SUM(QFPVPA)') +     */              /*AR796218*/
/**********               (QIPVNA '%SUM(QFPVNA)') (QIPVMV +             */              /*AR796218*/
/**********               '%SUM(QFPVMV)') (QIPTAI '%SUM(QFPTAI)') +     */              /*AR796218*/
/**********               (QIPTNI '%SUM(QFPTNI)'))                      */ /*BUG23967*/ /*AR796218*/
             OPNQRYF    FILE((PMHOLDQ3)) FORMAT(PMINDTPD)         +
                          GRPFLD(QFCNUM QFPTFR QFLIND QFLOIC)     +
                          MAPFLD((QICNUM QFCNUM) (QIPTFR QFPTFR)  +
                          (QILIND QFLIND) (QILOIC QFLOIC)         +
                          (QIPTPA '%SUM(QFPTPA)')                 +
                          (QIPTNA '%SUM(QFPTNA)') (QIPTMV         +
                          '%SUM(QFPTMV)') (QIPVPA '%SUM(QFPVPA)') +
                          (QIPVNA '%SUM(QFPVNA)') (QIPVMV         +
                          '%SUM(QFPVMV)') (QIPTAI '%SUM(QFPTAI)') +
                          (QIPTNI '%SUM(QFPTNI)'))                                      /*AR796218*/
/**********  CPYFRMQRYF FROMOPNID(PMHOLDX3) TOFILE(PMINDTPP) +     */ /*S01486*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMHOLDQ3) TOFILE(PMINDTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
/**********  CLOF       OPNID(PMHOLDX3)                            */ /*S01486*/
             CLOF       OPNID(PMHOLDQ3)                               /*S01486*/
             ENDDO
 
/* IF PERFORMANCE STATISTICS ARE REQUIRED PERFORM PMC1600 */
             IF         COND(&WWPFMR *EQ 'Y') THEN(DO)
 
/* PERFORM PMC1600 TO CALCULATE PERFORMANCE STATISTICS TO BE OUTPUT */
/*********** CALL       PGM(PMC1600)                               */ /*S01486*/
             CALL       PGM(PMC1600) PARM(&RSEQ)                      /*S01486*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/********** SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*/ /*S01486*/
/**********                  TOMSGQ(MOPERQ MRUNQ)                  */ /*S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/***ABNOR:****** ENDPGM                                               /*CPM005*/
ABNOR:       DLTOVR     FILE(PMPORTPD)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             DLTOVR     FILE(PMPORTLL)                                /*CPM005*/
             MONMSG     MSGID(CPF9841)                                /*CPM005*/
             ENDPGM                                                   /*CPM005*/
