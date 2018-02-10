/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas PM Calculate portfolio management totals')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1150 - PM CALCULATE PORTFOLIO TOTALS                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR796218           Date 28Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CPB001             Date 12Jul99              */
/* Midas DBA 3.0 ---------------- Base ------------------------------*/
/*                      CPM005             DATE 08JUL96              */
/*                      CCG009             DATE 01JUN95              */
/*                      080682             DATE 22DEC94              */
/*                      S01486             DATE 22DEC94              */
/*                      049421             DATE 18JAN93              */
/*                      S01313     DHW     DATE 28APR92              */
/*                      32881      DT      DATE 04DEC91              */
/*                      B08255             DATE 07OCT91              */
/*                      B08040             DATE 07JUL91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR796218 - Local Industry Code error in COB                 */
/*       CPB001 - 'Private Banking' Module                           */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY       */
/*       CCG009 - Private Banking UDC                                */
/*       080682 - MISSING PROGRAM IN EOD                             */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       S01313 - CHANGES FOR PORTFOLIO PERFORMANCE                  */
/*       32881  - MONITOR CPYF PMISTTX0 WHEN THIS ONE IS EMPTY       */
/*       B08255 - SPEED UP COB BY SPLITTING TOTALS FILES             */
/*       B08040 - SUNDRY FIXES TO SPEED UP COB                       */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 /*********  PGM ***********************************/                 /*S01189*/
 /*********  PGM ****** PARM(&CNAM &CSEQ)                      /*S01189 S01486*/
             PGM                                                      /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DAEC2) TYPE(*CHAR) LEN(5) VALUE('00000')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
/*********** DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)        /*S01189  S01486*/
/*********** DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)          /*S01189  S01486*/
/*********** DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)         /*S01189  S01486*/
/*           DCL        VAR(&STMT) TYPE(*CHAR) LEN(1)          S01313*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*CPB001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPB001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPB001*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1150 - PM Generate Portfolio +
                          Totals') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SAVE EVENT CONTROL DATE AS DATE EXTRACT LAST RUN                  */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
 
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
 
/* CLEAR ALL TEMPORARY FILES */
/*********** CLRPFM     FILE(PMDSGTPP)                                  S01486*/
/*********** CLRPFM     FILE(PMVLGTPP)                                  S01486*/
             CLRPFM     FILE(PMDSGTPD)                                /*S01486*/
             CLRPFM     FILE(PMVLGTPD)                                /*S01486*/
/*           CLRPFM     FILE(PMCCYTPP)                         S01313*/
             CLRPFM     FILE(PMCCYTPD)                                /*CPM005*/
/*           CLRPFM     FILE(PMCNTTPP)                         S01313*/
/*           CLRPFM     FILE(PMINDTPP)                         S01313*/
/*********** CLRPFM     FILE(PMPOTTPP)                                  S01486*/
/*********** CLRPFM     FILE(PMISTTPP)                                  S01486*/
             CLRPFM     FILE(PMPOTTPD)                                /*S01486*/
             CLRPFM     FILE(PMISTTPD)                                /*S01486*/
/*********** CLRPFM     FILE(PMISTTX0)                       /*B08255   S01486*/
/*********** CLRPFM     FILE(PMISTWPD)                         /*S01486 CPM005*/
/*           CLRPFM     FILE(PMHOLDX2)                         S01313*/
/*           CLRPFM     FILE(PMPTDVPP)                         S01313*/
             CLRPFM     FILE(PMTMPTPD)                                /*CPM005*/
             CLRPFM     FILE(PMTMPTQ0)                                /*CPM005*/
 
/* PERFROM PM1152 - EXTRACT DETAILS OF PORTFOLIOS WITH VALUATION */
/* STATEMENTS DUE */
/*           OVRDBF     FILE(SDPLCSPD) SHARE(*YES)             S01313*/
/*           OVRDBF     FILE(PMPORTPP) SHARE(*YES)             S01313*/
/*           OPNQRYF    FILE((*LIBL/SDPLCSPD)) OPTION(*INP) +
                          FORMAT(SDPLCSPD) QRYSLT('QBVLNA *LE "' +
                          *CAT &DAECD *CAT '" *AND QBVLNA *GT "' +
                          *CAT &DAEC2 *CAT '" *AND QBRECI *EQ "D" +
                          *AND QBS2VR *EQ "Y" *OR QBVLRA *LE "' +
                          *CAT &DAECD *CAT '" *AND QBVLRA *GT "' +
                          *CAT &DAEC2 *CAT '" *AND QBRECI *EQ "D" +
                          *AND QBS2EV *EQ "Y"') MAPFLD((QBVLN1 +
                          QBVLND *ZONED 5 0) (QBVLNA QBVLN1 *CHAR +
                          5) (QBVLR1 QBVLOR *ZONED 5 0) (QBVLRA +
                          QBVLR1 *CHAR 5))                     S01313*/
 
/*           OPNQRYF    FILE((*LIBL/PMPORTPP)) OPTION(*INP) +
                          FORMAT(PMPORTPP) QRYSLT('PNVLNA *LE "' +
                          *CAT &DAECD *CAT '" *AND PNVLNA *GT "' +
                          *CAT &DAEC2 *CAT '" *AND PNS2VR *EQ "Y" +
                          *OR PNVLRA *LE "' *CAT &DAECD *CAT '" +
                          *AND PNVLRA *GT "' *CAT &DAEC2 *CAT '" +
                          *AND PNS2EV *EQ "Y" *OR PNPOLC *NE "  " +
                          *OR PNIPIN *EQ "Y" *OR PNCYIN *EQ "Y" *OR +
                          PNYPIN *EQ "Y" *OR PNNPIN *EQ "Y"') +
                          MAPFLD((PNVLN1 PNVLND *ZONED 5 0) (PNVLNA +
                          PNVLN1 *CHAR 5) (PNVLR1 PNVLOR *ZONED 5 +
                          0) (PNVLRA PNVLR1 *CHAR 5))          S01313*/
 
/*           CALL       PGM(PM1152) PARM(&STMT)                S01313*/
 
/*           CLOF       OPNID(PMPORTPP)                        S01313*/
/*           CLOF       OPNID(SDPLCSPD)                        S01313*/
 
/*           DLTOVR     FILE(*ALL)                             S01313*/
 
/* PROCESS ANY DATA BASE ERROR */
/*           IF         COND(%SWITCH(XXXXXX11)) THEN(DO)       S01313*/
/*              RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)  S01313*/
/*              SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)              S01313*/
/*                                                                    /*R00300*/
/*           GOTO       CMDLBL(ABNOR)                          S01313*/
/*           ENDDO                                             S01313*/
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
/*           IF         COND(%SWITCH(XXXXXX01)) THEN(DO)       S01313*/
/*              RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)  S01313*/
/*              SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)              S01313*/
/*                                                                    /*R00300*/
/*           GOTO       CMDLBL(ABNOR)                          S01313*/
/*           ENDDO                                             S01313*/
 
/* OVERRIDE FILES TO SPEED UP FILE GENERATION */
/*********** OVRDBF     FILE(PMDSGTPP) SEQONLY(*YES 100)                S01486*/
/*********** OVRDBF     FILE(PMVLGTPP) SEQONLY(*YES 100)                S01486*/
             OVRDBF     FILE(PMDSGTPD) SEQONLY(*YES 100)              /*S01486*/
             OVRDBF     FILE(PMVLGTPD) SEQONLY(*YES 100)              /*S01486*/
/*           OVRDBF     FILE(PMCCYTPP) SEQONLY(*YES 100)       S01313*/
             OVRDBF     FILE(PMCCYTPD) SEQONLY(*YES 100)              /*CPM005*/
/*           OVRDBF     FILE(PMCNTTPP) SEQONLY(*YES 100)       S01313*/
/*           OVRDBF     FILE(PMINDTPP) SEQONLY(*YES 100)       S01313*/
/*********** OVRDBF     FILE(PMPOTTPP) SEQONLY(*YES 100)                S01486*/
/*********** OVRDBF     FILE(PMISTTPP) SEQONLY(*YES 100)                S01486*/
/*********** OVRDBF     FILE(PMISTTX0) SEQONLY(*YES 100)       /*B08255 S01486*/
             OVRDBF     FILE(PMPOTTPD) SEQONLY(*YES 100)              /*S01486*/
             OVRDBF     FILE(PMISTTPD) SEQONLY(*YES 100)              /*S01486*/
/*********** OVRDBF     FILE(PMISTWPD) SEQONLY(*YES 100)       /*S01486 CPM005*/
/*           OVRDBF     FILE(PMHOLDX2) SEQONLY(*YES 100)       S01313*/
             OVRDBF     FILE(PMTMPTPD) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMTMPTQ0) SEQONLY(*YES 100)              /*CPM005*/
 
/* CREATE PORTFOLIO TOTALS FOR ALL DEFINED PORTFOLIOS & 9997 PORTFOLIO */
/*********** OPNQRYF    FILE((PMHOLDX0)) FORMAT(PMISTTX0) +
                          GRPFLD(QFCNUM QFPTFR QFDSPS QFDSPG QFITDS +
                          QFINNR QFVALG QFVLGS QFVLIS) +
                          MAPFLD((WECNUM QFCNUM) (WEPTFR QFPTFR) +
                          (WEDSPS QFDSPS) (WEDSPG QFDSPG) (WEITDS +
                          QFITDS) (WEINNR QFINNR) (WEVALG QFVALG) +
                          (WEVLGS QFVLGS) (WEVLIS QFVLIS) (WEPTPA +
                          '%SUM(QFPTPA)') (WEPTNA '%SUM(QFPTNA)') +
                          (WEPTMV '%SUM(QFPTMV)') (WEPVPA +
                          '%SUM(QFPVPA)') (WEPVNA '%SUM(QFPVNA)') +
                          (WEPVMV '%SUM(QFPVMV)') (WEPTAI +
                          '%SUM(QFPTAI)') (WEPTNI '%SUM(QFPTNI)'))      S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMHOLDX0) TOFILE(PMISTTX0) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)               S01486*/
/*********** CLOF       OPNID(PMHOLDX0)                                 S01486*/
/*********** OPNQRYF    FILE((PMHOLDQ0)) FORMAT(PMISTWPD) +           /*CPM005*/
/************************ GRPFLD(QFCNUM QFPTFR QFDSPS QFDSPG QFITDS + /*CPM005*/
/************************ QFINNR QFVALG QFVLGS QFVLIS) +              /*CPM005*/
/************************ MAPFLD((WECNUM QFCNUM) (WEPTFR QFPTFR) +    /*CPM005*/
/************************ (WEDSPS QFDSPS) (WEDSPG QFDSPG) (WEITDS +   /*CPM005*/
/************************ QFITDS) (WEINNR QFINNR) (WEVALG QFVALG) +   /*CPM005*/
/************************ (WEVLGS QFVLGS) (WEVLIS QFVLIS) (WEPTPA +   /*CPM005*/
/************************ '%SUM(QFPTPA)') (WEPTNA '%SUM(QFPTNA)') +   /*CPM005*/
/************************ (WEPTMV '%SUM(QFPTMV)') (WEPVPA +           /*CPM005*/
/************************ '%SUM(QFPVPA)') (WEPVNA '%SUM(QFPVNA)') +   /*CPM005*/
/************************ (WEPVMV '%SUM(QFPVMV)') (WEPTAI +           /*CPM005*/
/********************* '%SUM(QFPTAI)') (WEPTNI '%SUM(QFPTNI)'))/*S01486 CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMHOLDQ0) TOFILE(PMISTWPD) +        /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)      /*S01486 CPM005*/
/**********  OPNQRYF    FILE((PMHOLDQ0)) FORMAT(PMTMPTQ0) +               */            /*AR796218*/
/**********               GRPFLD(QFCNUM QFPTFR QFDSPS QFDSPG QFCCY +      */            /*AR796218*/
/**********               QFITDS QFINNR QFVALG QFVLGS QFVLIS) +           */            /*AR796218*/
/**********               MAPFLD((QXCNUM QFCNUM) (QXPTFR QFPTFR) +        */            /*AR796218*/
/**********               (QXDSPS QFDSPS) (QXDSPG QFDSPG) (QXITDS +       */            /*AR796218*/
/**********               QFITDS) (QXINNR QFINNR) (QXVALG QFVALG) +       */            /*AR796218*/
/**********               (QXCURR QFCCY) (QXVLGS QFVLGS) (QXVLIS +        */            /*AR796218*/
/**********               QFVLIS) (QXPTPA '%SUM(QFPTPA)') (QXPTNA +       */            /*AR796218*/
/**********               '%SUM(QFPTNA)') (QXPTMV '%SUM(QFPTMV)') +       */            /*AR796218*/
/**********               (QXPVPA '%SUM(QFPVPA)') (QXPVNA +               */            /*AR796218*/
/**********               '%SUM(QFPVNA)') (QXPVMV '%SUM(QFPVMV)') +       */            /*AR796218*/
/**********               (QXPTAI '%SUM(QFPTAI)') (QXPTNI +               */            /*AR796218*/
/**********               '%SUM(QFPTNI)'))                                */ /*CPM005*/ /*AR796218*/
             OPNQRYF    FILE((PMHOLDQ0)) FORMAT(PMTMPTQ0) +
                          GRPFLD(QFCNUM QFPTFR QFDSPS QFDSPG QFCCY +
                          QFITDS QFINNR QFVALG QFVLGS QFVLIS QFLOIC) +
                          MAPFLD((QXCNUM QFCNUM) (QXPTFR QFPTFR) +
                          (QXDSPS QFDSPS) (QXDSPG QFDSPG) (QXITDS +
                          QFITDS) (QXINNR QFINNR) (QXVALG QFVALG) +
                          (QXCURR QFCCY) (QXVLGS QFVLGS) (QXVLIS +
                          QFVLIS) (QXPTPA '%SUM(QFPTPA)') (QXPTNA +
                          '%SUM(QFPTNA)') (QXPTMV '%SUM(QFPTMV)') +
                          (QXPVPA '%SUM(QFPVPA)') (QXPVNA +
                          '%SUM(QFPVNA)') (QXPVMV '%SUM(QFPVMV)') +
                          (QXPTAI '%SUM(QFPTAI)') (QXPTNI +
                          '%SUM(QFPTNI)'))                                              /*AR796218*/
             CPYFRMQRYF FROMOPNID(PMHOLDQ0) TOFILE(PMTMPTQ0) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CLOF       OPNID(PMHOLDQ0)                               /*S01486*/
 
/* COPY TOTALS FROM PMISTTX0 TO INSTRUMENT TOTALS FILE */
/*********** CPYF       FROMFILE(PMISTTX0) TOFILE(PMISTTPP) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)               S01486*/
/*********** CPYF       FROMFILE(PMISTWPD) TOFILE(PMISTTPD) +         /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)      /*S01486 CPM005*/
             CPYF       FROMFILE(PMTMPTQ0) TOFILE(PMTMPTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/* >>> 32881 >>> */
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMISTTPP))      S01486*/
/******** MONMSG MSGID(CPF2817) EXEC(CLRPFM FILE(PMISTTPD))    /*S01486 CPM005*/
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMTMPTPD))    /*CPM005*/
/* <<< 32881 <<< */
 
/* CREATE TOTALS FILE FOR 9998 AND 9999 PORTFOLIOS WHERE THE */
/* CUSTOMER ONLY HAS PORTFOLIOS IN BASE CURRENCY */
/*********** OPNQRYF    FILE((PMISTTX0)) FORMAT(PMISTTPP) +
                          QRYSLT('WEPTFR *NE "9997"') GRPFLD(WECNUM +
                          WEDSPS WEDSPG WEITDS WEINNR WEVALG WEVLGS +
                          WEVLIS) MAPFLD((QECNUM WECNUM) (QEPTFR +
                          "9998") (QEDSPS WEDSPS) (QEDSPG WEDSPG) +
                          (QEITDS WEITDS) (QEINNR WEINNR) (QEVALG +
                          WEVALG) (QEVLGS WEVLGS) (QEVLIS WEVLIS) +
                          (QEPTPA '%SUM(WEPTPA)') (QEPTNA +
                          '%SUM(WEPTNA)') (QEPTMV '%SUM(WEPTMV)') +
                          (QEPVPA '%SUM(WEPVPA)') (QEPVNA +
                          '%SUM(WEPVNA)') (QEPVMV '%SUM(WEPVMV)') +
                          (QEPTAI '%SUM(WEPTAI)') (QEPTNI +
                          '%SUM(WEPTNI)'))                              S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMISTTX0) TOFILE(PMISTTPP) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                   S01486*/
/*********** CLOF       OPNID(PMISTTX0)                                 S01486*/
/*********** OPNQRYF    FILE((PMISTWPD)) FORMAT(PMISTTPD) +           /*CPM005*/
/************************ QRYSLT('WEPTFR *NE "9997"') GRPFLD(WECNUM + /*CPM005*/
/************************ WEDSPS WEDSPG WEITDS WEINNR WEVALG WEVLGS + /*CPM005*/
/************************ WEVLIS) MAPFLD((QECNUM WECNUM) (QEPTFR +    /*CPM005*/
/************************ "9998") (QEDSPS WEDSPS) (QEDSPG WEDSPG) +   /*CPM005*/
/************************ (QEITDS WEITDS) (QEINNR WEINNR) (QEVALG +   /*CPM005*/
/************************ WEVALG) (QEVLGS WEVLGS) (QEVLIS WEVLIS) +   /*CPM005*/
/************************ (QEPTPA '%SUM(WEPTPA)') (QEPTNA +           /*CPM005*/
/************************ '%SUM(WEPTNA)') (QEPTMV '%SUM(WEPTMV)') +   /*CPM005*/
/************************ (QEPVPA '%SUM(WEPVPA)') (QEPVNA +           /*CPM005*/
/************************ '%SUM(WEPVNA)') (QEPVMV '%SUM(WEPVMV)') +   /*CPM005*/
/************************ (QEPTAI '%SUM(WEPTAI)') (QEPTNI +           /*CPM005*/
/************************ '%SUM(WEPTNI)'))                     /*S01486 CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMISTWPD) TOFILE(PMISTTPD) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)          /*S01486 CPM005*/
/*********** CLOF       OPNID(PMISTWPD)                        /*S01486 CPM005*/
             OPNQRYF    FILE((PMTMPTQ0)) FORMAT(PMTMPTPD) +
                          QRYSLT('QXPTFR *NE "9997"') GRPFLD(QXCNUM +
                          QXDSPS QXDSPG QXCURR QXITDS QXINNR QXVALG +
                          QXVLGS QXVLIS) MAPFLD((QTCNUM QXCNUM) +
                          (QTPTFR "9998") (QTDSPS QXDSPS) (QTDSPG +
                          QXDSPG) (QTITDS QXITDS) (QTINNR QXINNR) +
                          (QTCURR QXCURR) (QTVALG QXVALG) (QTVLGS +
                          QXVLGS) (QTVLIS QXVLIS) (QTPTPA +
                          '%SUM(QXPTPA)') (QTPTNA '%SUM(QXPTNA)') +
                          (QTPTMV '%SUM(QXPTMV)') (QTPVPA +
                          '%SUM(QXPVPA)') (QTPVNA '%SUM(QXPVNA)') +
                          (QTPVMV '%SUM(QXPVMV)') (QTPTAI +
                          '%SUM(QXPTAI)') (QTPTNI '%SUM(QXPTNI)'))    /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMTMPTQ0) TOFILE(PMTMPTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CLOF       OPNID(PMTMPTQ0)                               /*CPM005*/
 
/*********** OPNQRYF    FILE((PMISTTX0)) FORMAT(PMISTTPP) +
                          GRPFLD(WECNUM WEDSPS WEDSPG WEITDS WEINNR +
                          WEVALG WEVLGS WEVLIS) MAPFLD((QECNUM +
                          WECNUM) (QEPTFR "9999") (QEDSPS WEDSPS) +
                          (QEDSPG WEDSPG) (QEITDS WEITDS) (QEINNR +
                          WEINNR) (QEVALG WEVALG) (QEVLGS WEVLGS) +
                          (QEVLIS WEVLIS) (QEPTPA '%SUM(WEPTPA)') +
                          (QEPTNA '%SUM(WEPTNA)') (QEPTMV +
                          '%SUM(WEPTMV)') (QEPVPA '%SUM(WEPVPA)') +
                          (QEPVNA '%SUM(WEPVNA)') (QEPVMV +
                          '%SUM(WEPVMV)') (QEPTAI '%SUM(WEPTAI)') +
                          (QEPTNI '%SUM(WEPTNI)'))                      S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMISTTX0) TOFILE(PMISTTPP) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                   S01486*/
/*********** CLOF       OPNID(PMISTTX0)                                 S01486*/
/*********** OPNQRYF    FILE((PMISTWPD)) FORMAT(PMISTTPD) +           /*CPM005*/
/************************ GRPFLD(WECNUM WEDSPS WEDSPG WEITDS WEINNR + /*CPM005*/
/************************ WEVALG WEVLGS WEVLIS) MAPFLD((QECNUM +      /*CPM005*/
/************************ WECNUM) (QEPTFR "9999") (QEDSPS WEDSPS) +   /*CPM005*/
/************************ (QEDSPG WEDSPG) (QEITDS WEITDS) (QEINNR +   /*CPM005*/
/************************ WEINNR) (QEVALG WEVALG) (QEVLGS WEVLGS) +   /*CPM005*/
/************************ (QEVLIS WEVLIS) (QEPTPA '%SUM(WEPTPA)') +   /*CPM005*/
/************************ (QEPTNA '%SUM(WEPTNA)') (QEPTMV +           /*CPM005*/
/************************ '%SUM(WEPTMV)') (QEPVPA '%SUM(WEPVPA)') +   /*CPM005*/
/************************ (QEPVNA '%SUM(WEPVNA)') (QEPVMV +           /*CPM005*/
/************************ '%SUM(WEPVMV)') (QEPTAI '%SUM(WEPTAI)') +   /*CPM005*/
/************************ (QEPTNI '%SUM(WEPTNI)'))             /*S01486 CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMISTWPD) TOFILE(PMISTTPD) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)          /*S01486 CPM005*/
/*********** CLOF       OPNID(PMISTWPD)                        /*S01486 CPM005*/
             IF         COND(%SST(&FMT 104 1) *NE 'Y') THEN(DO)       /*CPB001*/
             OPNQRYF    FILE((PMTMPTQ0)) FORMAT(PMTMPTPD) +
                          GRPFLD(QXCNUM QXDSPS QXDSPG QXCURR QXITDS +
                          QXINNR QXVALG QXVLGS QXVLIS) +
                          MAPFLD((QTCNUM QXCNUM) (QTPTFR "9999") +
                          (QTDSPS QXDSPS) (QTDSPG QXDSPG) (QTITDS +
                          QXITDS) (QTINNR QXINNR) (QTVALG QXVALG) +
                          (QTVLGS QXVLGS) (QTCURR QXCURR) (QTVLIS +
                          QXVLIS) (QTPTPA '%SUM(QXPTPA)') (QTPTNA +
                          '%SUM(QXPTNA)') (QTPTMV '%SUM(QXPTMV)') +
                          (QTPVPA '%SUM(QXPVPA)') (QTPVNA +
                          '%SUM(QXPVNA)') (QTPVMV '%SUM(QXPVMV)') +
                          (QTPTAI '%SUM(QXPTAI)') (QTPTNI +
                          '%SUM(QXPTNI)'))                            /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMTMPTQ0) TOFILE(PMTMPTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CLOF       OPNID(PMTMPTQ0)                               /*CPM005*/
             ENDDO                                                    /*CPB001*/
 
/* CREATE TOTALS FILE FOR ALL PORTFOLIOS FOR CUSTOMERS WITH */
/* PORTFOLIOS NOT IN CUSTOMER BASE CURRENCY */
/*********** OPNQRYF    FILE((PMHOLDX1)) FORMAT(PMISTTPP) +
                          GRPFLD(QFCNUM QFPTFR QFDSPS QFDSPG QFITDS +
                          QFINNR QFVALG QFVLGS QFVLIS) +
                          MAPFLD((QECNUM QFCNUM) (QEPTFR QFPTFR) +
                          (QEDSPS QFDSPS) (QEDSPG QFDSPG) (QEITDS +
                          QFITDS) (QEINNR QFINNR) (QEVALG QFVALG) +
                          (QEVLGS QFVLGS) (QEVLIS QFVLIS) (QEPTPA +
                          '%SUM(QFPTPA)') (QEPTNA '%SUM(QFPTNA)') +
                          (QEPTMV '%SUM(QFPTMV)') (QEPVPA +
                          '%SUM(QFPVPA)') (QEPVNA '%SUM(QFPVNA)') +
                          (QEPVMV '%SUM(QFPVMV)') (QEPTAI +
                          '%SUM(QFPTAI)') (QEPTNI '%SUM(QFPTNI)'))      S01486*/
/************ PYFRMQRYF FROMOPNID(PMHOLDX1) TOFILE(PMISTTPP) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                   S01486*/
/*********** CLOF       OPNID(PMHOLDX1)                                 S01486*/
/*********** OPNQRYF    FILE((PMHOLDQ1)) FORMAT(PMISTTPD) +           /*CPM005*/
/************************ GRPFLD(QFCNUM QFPTFR QFDSPS QFDSPG QFITDS + /*CPM005*/
/************************ QFINNR QFVALG QFVLGS QFVLIS) +              /*CPM005*/
/************************ MAPFLD((QECNUM QFCNUM) (QEPTFR QFPTFR) +    /*CPM005*/
/************************ (QEDSPS QFDSPS) (QEDSPG QFDSPG) (QEITDS +   /*CPM005*/
/************************ QFITDS) (QEINNR QFINNR) (QEVALG QFVALG) +   /*CPM005*/
/************************ (QEVLGS QFVLGS) (QEVLIS QFVLIS) (QEPTPA +   /*CPM005*/
/************************ '%SUM(QFPTPA)') (QEPTNA '%SUM(QFPTNA)') +   /*CPM005*/
/************************ (QEPTMV '%SUM(QFPTMV)') (QEPVPA +           /*CPM005*/
/************************ '%SUM(QFPVPA)') (QEPVNA '%SUM(QFPVNA)') +   /*CPM005*/
/************************ (QEPVMV '%SUM(QFPVMV)') (QEPTAI +           /*CPM005*/
/******************** '%SUM(QFPTAI)') (QEPTNI '%SUM(QFPTNI)')) /*S01486 CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMHOLDQ1) TOFILE(PMISTTPD) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)          /*S01486 CPM005*/
             OPNQRYF    FILE((PMHOLDQ1)) FORMAT(PMTMPTPD) +
                          GRPFLD(QFCNUM QFPTFR QFDSPS QFDSPG QFCCY +
                          QFITDS QFINNR QFVALG QFVLGS QFVLIS) +
                          MAPFLD((QTCNUM QFCNUM) (QTPTFR QFPTFR) +
                          (QTDSPS QFDSPS) (QTDSPG QFDSPG) (QTITDS +
                          QFITDS) (QTINNR QFINNR) (QTVALG QFVALG) +
                          (QTCURR QFCCY) (QTVLGS QFVLGS) (QTVLIS +
                          QFVLIS) (QTPTPA '%SUM(QFPTPA)') (QTPTNA +
                          '%SUM(QFPTNA)') (QTPTMV '%SUM(QFPTMV)') +
                          (QTPVPA '%SUM(QFPVPA)') (QTPVNA +
                          '%SUM(QFPVNA)') (QTPVMV '%SUM(QFPVMV)') +
                          (QTPTAI '%SUM(QFPTAI)') (QTPTNI +
                          '%SUM(QFPTNI)'))                            /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMHOLDQ1) TOFILE(PMTMPTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CLOF       OPNID(PMHOLDQ1)                               /*S01486*/
                                                                      /*CPM005*/
/**  Create totals file for by instruments */                         /*CPM005*/
             OPNQRYF    FILE((PMTMPTPD)) FORMAT(PMISTTPD) +
                          GRPFLD(QTCNUM QTPTFR QTDSPS QTDSPG QTITDS +
                          QTINNR QTVALG QTVLGS QTVLIS) +
                          MAPFLD((QECNUM QTCNUM) (QEPTFR QTPTFR) +
                          (QEDSPS QTDSPS) (QEDSPG QTDSPG) (QEITDS +
                          QTITDS) (QEINNR QTINNR) (QEVALG QTVALG) +
                          (QEVLGS QTVLGS) (QEVLIS QTVLIS) (QEPTPA +
                          '%SUM(QTPTPA)') (QEPTNA '%SUM(QTPTNA)') +
                          (QEPTMV '%SUM(QTPTMV)') (QEPVPA +
                          '%SUM(QTPVPA)') (QEPVNA '%SUM(QTPVNA)') +
                          (QEPVMV '%SUM(QTPVMV)') (QEPTAI +
                          '%SUM(QTPTAI)') (QEPTNI '%SUM(QTPTNI)'))    /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMTMPTPD) TOFILE(PMISTTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CLOF       OPNID(PMTMPTPD)                               /*CPM005*/
                                                                      /*CPM005*/
/**  Create totals file for by instruments */                         /*CPM005*/
             OPNQRYF    FILE((PMTMPTPD)) FORMAT(PMCCYTPD) +
                          GRPFLD(QTCNUM QTPTFR QTCURR) +
                          MAPFLD((QGCNUM QTCNUM) (QGPTFR QTPTFR) +
                          (QGCCY QTCURR) (QGPTPA '%SUM(QTPTPA)') +
                          (QGPTNA '%SUM(QTPTNA)') (QGPTMV +
                          '%SUM(QTPTMV)') (QGPVPA '%SUM(QTPVPA)') +
                          (QGPVNA '%SUM(QTPVNA)') (QGPVMV +
                          '%SUM(QTPVMV)') (QGPTAI '%SUM(QTPTAI)') +
                          (QGPTNI '%SUM(QTPTNI)'))                    /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMTMPTPD) TOFILE(PMCCYTPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CLOF       OPNID(PMTMPTPD)                               /*CPM005*/
 
/**CREATE*TOTALS*FILE*PMDSGTPP */                                     /*S01486*/
/* CREATE TOTALS FILE PMDSGTPD */                                     /*S01486*/
/*********** OPNQRYF    FILE((PMISTTPP)) FORMAT(PMDSGTPP) +
                          GRPFLD(QECNUM QEPTFR QEDSPS QEDSPG) +
                          MAPFLD((QDCNUM QECNUM) (QDPTFR QEPTFR) +
                          (QDDSPS QEDSPS) (QDDSPG QEDSPG) +
                          (QDPTPA +
                          '%SUM(QEPTPA)') (QDPTNA '%SUM(QEPTNA)') +
                          (QDPTMV '%SUM(QEPTMV)') (QDPVPA +
                          '%SUM(QEPVPA)') (QDPVNA '%SUM(QEPVNA)') +
                          (QDPVMV '%SUM(QEPVMV)') (QDPTAI +
                          '%SUM(QEPTAI)') (QDPTNI '%SUM(QEPTNI)'))      S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMISTTPP) TOFILE(PMDSGTPP) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)               S01486*/
/*********** CLOF       OPNID(PMISTTPP)                                 S01486*/
             OPNQRYF    FILE((PMISTTPD)) FORMAT(PMDSGTPD) +
                          GRPFLD(QECNUM QEPTFR QEDSPS QEDSPG) +
                          MAPFLD((QDCNUM QECNUM) (QDPTFR QEPTFR) +
                          (QDDSPS QEDSPS) (QDDSPG QEDSPG) +
                          (QDPTPA +
                          '%SUM(QEPTPA)') (QDPTNA '%SUM(QEPTNA)') +
                          (QDPTMV '%SUM(QEPTMV)') (QDPVPA +
                          '%SUM(QEPVPA)') (QDPVNA '%SUM(QEPVNA)') +
                          (QDPVMV '%SUM(QEPVMV)') (QDPTAI +
                          '%SUM(QEPTAI)') (QDPTNI '%SUM(QEPTNI)'))    /*S01486*/
             CPYFRMQRYF FROMOPNID(PMISTTPD) TOFILE(PMDSGTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*S01486*/
             CLOF       OPNID(PMISTTPD)                               /*S01486*/
 
/**CREATE*TOTALS*FILE*PMVLGTPP */                                     /*S01486*/
/* CREATE TOTALS FILE PMVLGTPD */                                     /*S01486*/
/*********** OPNQRYF    FILE((PMISTTPP)) FORMAT(PMVLGTPP) +
                          GRPFLD(QECNUM QEPTFR QEVLGS QEVALG) +
                          MAPFLD((ATCNUM QECNUM) (ATPTFR QEPTFR) +
                          (ATVLGS QEVLGS) (ATVALG QEVALG) (ATPTPA +
                          '%SUM(QEPTPA)') (ATPTNA '%SUM(QEPTNA)') +
                          (ATPTMV '%SUM(QEPTMV)') (ATPVPA +
                          '%SUM(QEPVPA)') (ATPVNA '%SUM(QEPVNA)') +
                          (ATPVMV '%SUM(QEPVMV)') (ATPTAI +
                          '%SUM(QEPTAI)'))                              S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMISTTPP) TOFILE(PMVLGTPP) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)               S01486*/
/*********** CLOF       OPNID(PMISTTPP)                                 S01486*/
/*********** OPNQRYF    FILE((PMISTTPD)) FORMAT(PMVLGTPD) +           /*CCG009*/
/***********              GRPFLD(QECNUM QEPTFR QEVLGS QEVALG) +       /*CCG009*/
/***********              MAPFLD((ATCNUM QECNUM) (ATPTFR QEPTFR) +    /*CCG009*/
/***********              (ATVLGS QEVLGS) (ATVALG QEVALG) (ATPTPA +   /*CCG009*/
/***********              '%SUM(QEPTPA)') (ATPTNA '%SUM(QEPTNA)') +   /*CCG009*/
/***********              (ATPTMV '%SUM(QEPTMV)') (ATPVPA +           /*CCG009*/
/***********              '%SUM(QEPVPA)') (ATPVNA '%SUM(QEPVNA)') +   /*CCG009*/
/***********              (ATPVMV '%SUM(QEPVMV)') (ATPTAI +           /*CCG009*/
/***********              '%SUM(QEPTAI)'))                 /*S01486*/ /*CCG009*/
             OPNQRYF    FILE((PMISTTPD)) FORMAT(PMVLGTPD) +
                          GRPFLD(QECNUM QEPTFR QEVLGS QEVALG) +
                          MAPFLD((ATCNUM QECNUM) (ATPTFR QEPTFR) +
                          (ATVLGS QEVLGS) (ATVALG QEVALG) (ATPTPA +
                          '%SUM(QEPTPA)') (ATPTNA '%SUM(QEPTNA)') +
                          (ATPTMV '%SUM(QEPTMV)') (ATPVPA +
                          '%SUM(QEPVPA)') (ATPVNA '%SUM(QEPVNA)') +
                          (ATPVMV '%SUM(QEPVMV)') (ATPTAI +
                          '%SUM(QEPTAI)') (ATPTNI '%SUM(QEPTNI)')) +
                                                                      /*CCG009*/
             CPYFRMQRYF FROMOPNID(PMISTTPD) TOFILE(PMVLGTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*S01486*/
             CLOF       OPNID(PMISTTPD)                               /*S01486*/
 
/**CREATE*TOTALS*FILE*PMPOTTPP */                                     /*S01486*/
/* CREATE TOTALS FILE PMPOTTPD */                                     /*S01486*/
/*********** OPNQRYF    FILE((PMDSGTPP)) FORMAT(PMPOTTPP) +
                          GRPFLD(QDCNUM QDPTFR) +
                          MAPFLD((QCCNUM QDCNUM) (QCPTFR QDPTFR) +
                          (QCPTPA +
                          '%SUM(QDPTPA)') (QCPTNA '%SUM(QDPTNA)') +
                          (QCPTMV '%SUM(QDPTMV)') (QCPVPA +
                          '%SUM(QDPVPA)') (QCPVNA '%SUM(QDPVNA)') +
                          (QCPVMV '%SUM(QDPVMV)') (QCPTAI +
                          '%SUM(QDPTAI)') (QCPTNI '%SUM(QDPTNI)'))    /*S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMDSGTPP) TOFILE(PMPOTTPP) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*S01486*/
/*********** CLOF       OPNID(PMDSGTPP)                               /*S01486*/
             OPNQRYF    FILE((PMDSGTPD)) FORMAT(PMPOTTPD) +
                          GRPFLD(QDCNUM QDPTFR) +
                          MAPFLD((QCCNUM QDCNUM) (QCPTFR QDPTFR) +
                          (QCPTPA +
                          '%SUM(QDPTPA)') (QCPTNA '%SUM(QDPTNA)') +
                          (QCPTMV '%SUM(QDPTMV)') (QCPVPA +
                          '%SUM(QDPVPA)') (QCPVNA '%SUM(QDPVNA)') +
                          (QCPVMV '%SUM(QDPVMV)') (QCPTAI +
                          '%SUM(QDPTAI)') (QCPTNI '%SUM(QDPTNI)'))    /*S01486*/
             CPYFRMQRYF FROMOPNID(PMDSGTPD) TOFILE(PMPOTTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*S01486*/
             CLOF       OPNID(PMDSGTPD)                               /*S01486*/
 
/* COPY RECORDS NEEDED FOR TOTALLING TO PF/PMHOLDX0 */
/*           IF         COND(&STMT *EQ 'Y') THEN(DO)          S01313*/
/*           OPNQRYF    FILE((PMPTDVPP) (PMHOLDX0)) FORMAT(PMHOLDX2) +
                          JFLD((PMPTDVPP/PNCNUM PMHOLDX0/QFCNUM +
                     *EQ) (PMPTDVPP/PNPTFR PMHOLDX0/QFPTFR))   S01313*/
/*           CPYFRMQRYF FROMOPNID(PMPTDVPP) TOFILE(PMHOLDX2) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)      S01313*/
/*           CLOF       OPNID(PMPTDVPP)                        S01313*/
 
/*           OPNQRYF    FILE((PMPTDVPP) (PMHOLDX1)) FORMAT(PMHOLDX2) +
                          JFLD((PMPTDVPP/PNCNUM PMHOLDX1/QFCNUM +
                  *EQ) (PMPTDVPP/PNPTFR PMHOLDX1/QFPTFR))      S01313*/
/*           CPYFRMQRYF FROMOPNID(PMPTDVPP) TOFILE(PMHOLDX2) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)          S01313*/
/*           CLOF       OPNID(PMPTDVPP)                        S01313*/
 
/* CREATE TOTALS FILE PMCCYTPP */
/*           OPNQRYF    FILE((PMHOLDX2)) FORMAT(PMCCYTPP) +
                          GRPFLD(QFCNUM QFPTFR QFCCY) +
                          MAPFLD((QGCNUM QFCNUM) (QGPTFR QFPTFR) +
                          (QGCCY QFCCY) (QGPTPA '%SUM(QFPTPA)') +
                          (QGPTNA '%SUM(QFPTNA)') (QGPTMV +
                          '%SUM(QFPTMV)') (QGPVPA '%SUM(QFPVPA)') +
                          (QGPVNA '%SUM(QFPVNA)') (QGPVMV +
                   '%SUM(QFPVMV)') (QGPTAI '%SUM(QFPTAI)'))    S01313*/
/*           CPYFRMQRYF FROMOPNID(PMHOLDX2) TOFILE(PMCCYTPP) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)      S01313*/
/*           CLOF       OPNID(PMHOLDX2)                        S01313*/
 
/* CREATE TOTALS FILE PMCNTTPP */
/*           OPNQRYF    FILE((PMHOLDX2)) FORMAT(PMCNTTPP) +
                          GRPFLD(QFCNUM QFPTFR QFCNTR) +
                          MAPFLD((QHCNUM QFCNUM) (QHPTFR QFPTFR) +
                          (QHCNTR QFCNTR) (QHPTPA '%SUM(QFPTPA)') +
                          (QHPTNA '%SUM(QFPTNA)') (QHPTMV +
                          '%SUM(QFPTMV)') (QHPVPA '%SUM(QFPVPA)') +
                          (QHPVNA '%SUM(QFPVNA)') (QHPVMV +
                    '%SUM(QFPVMV)') (QHPTAI '%SUM(QFPTAI)'))   S01313*/
/*           CPYFRMQRYF FROMOPNID(PMHOLDX2) TOFILE(PMCNTTPP) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)      S01313*/
/*           CLOF       OPNID(PMHOLDX2)                        S01313*/
 
/* CREATE TOTALS FILE PMINDTPP */
/*           OPNQRYF    FILE((PMHOLDX2)) FORMAT(PMINDTPP) +
                          GRPFLD(QFCNUM QFPTFR QFLIND) +
                          MAPFLD((QICNUM QFCNUM) (QIPTFR QFPTFR) +
                          (QILIND QFLIND) (QIPTPA '%SUM(QFPTPA)') +
                          (QIPTNA '%SUM(QFPTNA)') (QIPTMV +
                          '%SUM(QFPTMV)') (QIPVPA '%SUM(QFPVPA)') +
                          (QIPVNA '%SUM(QFPVNA)') (QIPVMV +
                     '%SUM(QFPVMV)') (QIPTAI '%SUM(QFPTAI)'))  S01313*/
/*           CPYFRMQRYF FROMOPNID(PMHOLDX2) TOFILE(PMINDTPP) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)      S01313*/
/*           CLOF       OPNID(PMHOLDX2)                        S01313*/
/*           DLTOVR     FILE(*ALL)                             S01313*/
/*           ENDDO                                             S01313*/
 
/**********ABNOR:       ENDPGM                                         *S01486*/
ABNOR:       CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
         ENDPGM                                                       /*S01486*/
