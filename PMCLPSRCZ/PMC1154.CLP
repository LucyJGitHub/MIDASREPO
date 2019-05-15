/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas PM Generate Position Type Totals Info')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC1154 - Setup Position Type Totals Information            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD029813           Date 08Sep14              */
/*                      AR796218           Date 28Jun11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CPB001             Date 12Jul99              */
/* Midas DBA 3.0 ---------------- Base ------------------------------*/
/*                      CPM005             DATE 09JUL96              */
/*                      S01124             DATE 06JUN94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD029813 - Field TTLOIC on FORMAT parameter not found.      */
/*                  Added Local Industry Code (FILOIC/TTLOIC) in     */
/*                  grouping field names and mapped field of OPNQRYF */
/*                  command.                                         */
/*       AR796218 - Local Industry Code error in COB                 */
/*       CPB001 - 'Private Banking' Module                           */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       S01124 - PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY       */
/*                VERSION RELEASE III                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/                                                                  /*CPM005*/
/* Copyright statement defination  */                                 /*CPM005*/
/**/                                                                  /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*CPB001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPB001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPB001*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1154 - PM Generate Portfolio +
                          Position Type Totals Information') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT */
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
/*********** CLRPFM     FILE(PMCIALPP)                                /*CPM005*/
             CLRPFM     FILE(PMCIALPD)                                /*CPM005*/
/*********** CLRPFM     FILE(PMICALPP)                                /*CPM005*/
             CLRPFM     FILE(PMICALPD)                                /*CPM005*/
/*********** CLRPFM     FILE(PMCITTPP)                                /*CPM005*/
             CLRPFM     FILE(PMCIALQ0)                                /*CPM005*/
/*********** CLRPFM     FILE(PMICTTPP)                                /*CPM005*/
             CLRPFM     FILE(PMICALQ0)                                /*CPM005*/
 
/*********** CLRPFM     FILE(PMASLIPP)                                /*CPM005*/
             CLRPFM     FILE(PMASLIPD)                                /*CPM005*/
/*********** CLRPFM     FILE(PMASITPP)                                /*CPM005*/
             CLRPFM     FILE(PMASITPD)                                /*CPM005*/
 
/* OVERRIDE FILES TO SPEED UP FILE GENERATION */
/*********** OVRDBF     FILE(PMCIALPP) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMCIALPD) SEQONLY(*YES 100)              /*CPM005*/
/*********** OVRDBF     FILE(PMICALPP) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMICALPD) SEQONLY(*YES 100)              /*CPM005*/
/*********** OVRDBF     FILE(PMCITTPP) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMCIALQ0) SEQONLY(*YES 100)              /*CPM005*/
/*********** OVRDBF     FILE(PMICTTPP) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMICALQ0) SEQONLY(*YES 100)              /*CPM005*/
 
/*********** OVRDBF     FILE(PMASLIPP) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMASLIPD) SEQONLY(*YES 100)              /*CPM005*/
/*********** OVRDBF     FILE(PMASITPP) SEQONLY(*YES 100)              /*CPM005*/
             OVRDBF     FILE(PMASITPD) SEQONLY(*YES 100)              /*CPM005*/
 
/* CREATE PORTFOLIO TOTALS FOR ALL DEFINED PORTFOLIOS & 9997 PORTFOLIO */
/*********** OPNQRYF    FILE((PMHOLDX0)) FORMAT(PMCIALPP) +           /*CPM005*/
/************************ GRPFLD(QFCNUM QFPTFR QFCCY QFPOTY QFDSPG +  /*CPM005*/
/************************ QFDSPS QFINNR QFITDS) MAPFLD((FIRECI +      /*CPM005*/
/************************ '"D"') (FICNUM QFCNUM) (FICURR QFCCY) +     /*CPM005*/
/************************ (FIPTFR QFPTFR) (FIPOTY QFPOTY) (FITOTT +   /*CPM005*/
/************************ '"I"') (FIDGRS QFDSPS) (FIINSC QFINNR) +    /*CPM005*/
/************************ (FIDGRC QFDSPG) (FIINDS QFITDS) (FIASVL +   /*CPM005*/
/************************ '%SUM(QFASVL)') (FILIVL '%SUM(QFLIVL)'))    /*CPM005*/
/**********  OPNQRYF    FILE((PMHOLDQ0)) FORMAT(PMCIALPD) +               */            /*AR796218*/
/**********               GRPFLD(QFCNUM QFPTFR QFCCY QFPOTY QFDSPG +      */            /*AR796218*/
/**********               QFDSPS QFINNR QFITDS) MAPFLD((FIRECI +          */            /*AR796218*/
/**********               '"D"') (FICNUM QFCNUM) (FICURR QFCCY) +         */            /*AR796218*/
/**********               (FIPTFR QFPTFR) (FIPOTY QFPOTY) (FITOTT +       */            /*AR796218*/
/**********               '"I"') (FIDGRS QFDSPS) (FIINSC QFINNR) +        */            /*AR796218*/
/**********               (FIDGRC QFDSPG) (FIINDS QFITDS) (FIASVL +       */            /*AR796218*/
/**********               '%SUM(QFASVL)') (FILIVL '%SUM(QFLIVL)'))        */ /*CPM005*/ /*AR796218*/
             OPNQRYF    FILE((PMHOLDQ0)) FORMAT(PMCIALPD)             +
                          GRPFLD(QFCNUM QFPTFR QFCCY QFPOTY QFDSPG    +
                          QFDSPS QFINNR QFITDS QFLOIC) MAPFLD((FIRECI +
                          '"D"') (FICNUM QFCNUM) (FICURR QFCCY)       +
                          (FIPTFR QFPTFR) (FIPOTY QFPOTY) (FITOTT     +
                          '"I"') (FIDGRS QFDSPS) (FIINSC QFINNR)      +
                          (FIDGRC QFDSPG) (FIINDS QFITDS) (FIASVL     +
                          '%SUM(QFASVL)') (FILIVL '%SUM(QFLIVL)')     +
                          (FILOIC QFLOIC))                                              /*AR796218*/
/*********** CPYFRMQRYF FROMOPNID(PMHOLDX0) TOFILE(PMCIALPP) +        /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMHOLDQ0) TOFILE(PMCIALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** CLOF       OPNID(PMHOLDX0)                               /*CPM005*/
             CLOF       OPNID(PMHOLDQ0)                               /*CPM005*/
 
/**COPY*TOTALS*FROM*PMCIALPP*TO*INSTRUMENT*TOTALS*FILE**/
/* COPY TOTALS FROM PMCIALPD TO INSTRUMENT TOTALS FILE */
/*********** CPYF       FROMFILE(PMCIALPP) TOFILE(PMCITTPP) +         /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYF       FROMFILE(PMCIALPD) TOFILE(PMCIALQ0) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCITTPP))    /*CPM005*/
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCIALQ0))    /*CPM005*/
 
/* CREATE TOTALS FILE FOR 9998 AND 9999 PORTFOLIOS WHERE THE */
/* CUSTOMER ONLY HAS PORTFOLIOS IN BASE CURRENCY */
/*********** OPNQRYF    FILE((PMCIALPP)) FORMAT(PMCITTPP) +           /*CPM005*/
/************************ QRYSLT('FIPTFR *NE "9997"') GRPFLD(FICNUM + /*CPM005*/
/************************ FIPTFR FICURR FIPOTY FIDGRC FIDGRS FIINSC + /*CPM005*/
/************************ FIINDS) MAPFLD((TTCNUM FICNUM) (TTPTFR +    /*CPM005*/
/************************ "9998") (TTCURR FICURR) (TTRECI '"D"') +    /*CPM005*/
/************************ (TTDGRC FIDGRC) (TTDGRS FIDGRS) (TTTOTT +   /*CPM005*/
/************************ '"I"') (TTINDS FIINDS) (TTPOTY FIPOTY) +    /*CPM005*/
/************************ (TTINSC FIINSC) (TTASVL '%SUM(FIASVL)') +   /*CPM005*/
/************************ (TTLIVL '%SUM(FILIVL)'))                    /*CPM005*/
/**********  OPNQRYF    FILE((PMCIALPD)) FORMAT(PMCIALQ0) +               */            /*AR796218*/
/**********               QRYSLT('FIPTFR *NE "9997"') GRPFLD(FICNUM +     */            /*AR796218*/
/**********               FIPTFR FICURR FIPOTY FIDGRC FIDGRS FIINSC +     */            /*AR796218*/
/**********               FIINDS) MAPFLD((TTCNUM FICNUM) (TTPTFR +        */            /*AR796218*/
/**********               "9998") (TTCURR FICURR) (TTRECI '"D"') +        */            /*AR796218*/
/**********               (TTDGRC FIDGRC) (TTDGRS FIDGRS) (TTTOTT +       */            /*AR796218*/
/**********               '"I"') (TTINDS FIINDS) (TTPOTY FIPOTY) +        */            /*AR796218*/
/**********               (TTINSC FIINSC) (TTASVL '%SUM(FIASVL)') +       */            /*AR796218*/
/**********               (TTLIVL '%SUM(FILIVL)'))                        */ /*CPM005*/ /*AR796218*/
             OPNQRYF    FILE((PMCIALPD)) FORMAT(PMCIALQ0)               +
                          QRYSLT('FIPTFR *NE "9997"') GRPFLD(FICNUM     +
                          FIPTFR FICURR FIPOTY FIDGRC FIDGRS FIINSC     +
                          FIINDS FILOIC) MAPFLD((TTCNUM FICNUM) (TTPTFR +
                          "9998") (TTCURR FICURR) (TTRECI '"D"')        +
                          (TTDGRC FIDGRC) (TTDGRS FIDGRS) (TTTOTT       +
                          '"I"') (TTINDS FIINDS) (TTPOTY FIPOTY)        +
                          (TTINSC FIINSC)(TTASVL '%SUM(FIASVL)')        +
                          (TTLIVL '%SUM(FILIVL)') (TTLOIC FILOIC))                      /*AR796218*/
/*********** CPYFRMQRYF FROMOPNID(PMCIALPP) TOFILE(PMCITTPP) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMCIALPD) TOFILE(PMCIALQ0) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
/*********** CLOF       OPNID(PMCIALPP)                               /*CPM005*/
             CLOF       OPNID(PMCIALPD)                               /*CPM005*/
 
/*********** OPNQRYF    FILE((PMCIALPP)) FORMAT(PMCITTPP) +           /*CPM005*/
/************************ GRPFLD(FICNUM FIPTFR FICURR FIPOTY FIDGRC + /*CPM005*/
/************************ FIDGRS FIINSC FIINDS) MAPFLD((TTCNUM +      /*CPM005*/
/************************ FICNUM) (TTPTFR "9999") (TTPOTY FIPOTY) +   /*CPM005*/
/************************ (TTCURR FICURR) (TTRECI '"D"') (TTTOTT +    /*CPM005*/
/************************ '"I"') (TTINSC FIINSC) (TTDGRC FIDGRC) +    /*CPM005*/
/************************ (TTDGRS FIDGRS) (TTINDS FIINDS) (TTASVL +   /*CPM005*/
/************************ '%SUM(FIASVL)') (TTLIVL '%SUM(FILIVL)'))    /*CPM005*/
             IF         COND(%SST(&FMT 104 1) *NE 'Y') THEN(DO)       /*CPB001*/
/**********  OPNQRYF    FILE((PMCIALPD)) FORMAT(PMCIALQ0) +          */
/**********               GRPFLD(FICNUM FIPTFR FICURR FIPOTY FIDGRC +*/
/**********               FIDGRS FIINSC FIINDS) MAPFLD((TTCNUM +     */
/**********               FICNUM) (TTPTFR "9999") (TTPOTY FIPOTY) +  */
/**********               (TTCURR FICURR) (TTRECI '"D"') (TTTOTT +   */
/**********               '"I"') (TTINSC FIINSC) (TTDGRC FIDGRC) +   */
/**********               (TTDGRS FIDGRS) (TTINDS FIINDS) (TTASVL +  */
/**********               '%SUM(FIASVL)') (TTLIVL '%SUM(FILIVL)'))   */          /*CPM005 MD029813*/
             OPNQRYF    FILE((PMCIALPD)) FORMAT(PMCIALQ0) +
                          GRPFLD(FICNUM FIPTFR FICURR FIPOTY FIDGRC +
                          FIDGRS FIINSC FIINDS FILOIC) MAPFLD((TTCNUM +
                          FICNUM) (TTPTFR "9999") (TTPOTY FIPOTY) +
                          (TTCURR FICURR) (TTRECI '"D"') (TTTOTT +
                          '"I"') (TTINSC FIINSC) (TTDGRC FIDGRC) +
                          (TTDGRS FIDGRS) (TTINDS FIINDS) (TTASVL +
                          '%SUM(FIASVL)') (TTLIVL '%SUM(FILIVL)') +
                          (TTLOIC FILOIC))                                              /*MD029813*/
/*********** CPYFRMQRYF FROMOPNID(PMCIALPP) TOFILE(PMCITTPP) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMCIALPD) TOFILE(PMCIALQ0) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
/*********** CLOF       OPNID(PMCIALPP)                               /*CPM005*/
             CLOF       OPNID(PMCIALPD)                               /*CPM005*/
             ENDDO                                                    /*CPB001*/
 
/* CREATE TOTALS FILE FOR ALL PORTFOLIOS FOR CUSTOMERS WITH */
/* PORTFOLIOS NOT IN CUSTOMER BASE CURRENCY */
/*********** OPNQRYF    FILE((PMHOLDX1)) FORMAT(PMCITTPP) +           /*CPM005*/
/************************ GRPFLD(QFCNUM QFPTFR QFCCY QFPOTY +         /*CPM005*/
/************************ QFDSPG QFDSPS QFINNR QFITDS) +              /*CPM005*/
/************************ MAPFLD((TTCNUM QFCNUM) (TTCURR QFCCY) +     /*CPM005*/
/************************ (TTRECI '"D"') (TTPTFR QFPTFR) (TTINSC +    /*CPM005*/
/************************ QFINNR) (TTTOTT '"I"') (TTDGRC QFDSPG) +    /*CPM005*/
/************************ (TTDGRS QFDSPS) (TTPOTY QFPOTY) (TTINDS +   /*CPM005*/
/************************ QFITDS) (TTASVL '%SUM(QFASVL)') (TTLIVL +   /*CPM005*/
/************************ '%SUM(QFLIVL)'))                            /*CPM005*/
/**********  OPNQRYF    FILE((PMHOLDQ1)) FORMAT(PMCIALQ0) +               */            /*AR796218*/
/**********               GRPFLD(QFCNUM QFPTFR QFCCY QFPOTY +             */            /*AR796218*/
/**********               QFDSPG QFDSPS QFINNR QFITDS) +                  */            /*AR796218*/
/**********               MAPFLD((TTCNUM QFCNUM) (TTCURR QFCCY) +         */            /*AR796218*/
/**********               (TTRECI '"D"') (TTPTFR QFPTFR) (TTINSC +        */            /*AR796218*/
/**********               QFINNR) (TTTOTT '"I"') (TTDGRC QFDSPG) +        */            /*AR796218*/
/**********               (TTDGRS QFDSPS) (TTPOTY QFPOTY) (TTINDS +       */            /*AR796218*/
/**********               QFITDS) (TTASVL '%SUM(QFASVL)') (TTLIVL +       */            /*AR796218*/
/**********               '%SUM(QFLIVL)'))                                */ /*CPM005*/ /*AR796218*/
             OPNQRYF    FILE((PMHOLDQ1)) FORMAT(PMCIALQ0)         +
                          GRPFLD(QFCNUM QFPTFR QFCCY QFPOTY       +
                          QFDSPG QFDSPS QFINNR QFITDS QFLOIC)     +
                          MAPFLD((TTCNUM QFCNUM) (TTCURR QFCCY)   +
                          (TTRECI '"D"') (TTPTFR QFPTFR) (TTINSC  +
                          QFINNR) (TTTOTT '"I"') (TTDGRC QFDSPG)  +
                          (TTDGRS QFDSPS) (TTPOTY QFPOTY) (TTINDS +
                          QFITDS) (TTASVL '%SUM(QFASVL)') (TTLIVL +
                          '%SUM(QFLIVL)') (TTLOIC QFLOIC))                              /*AR796218*/
/*********** CPYFRMQRYF FROMOPNID(PMHOLDX1) TOFILE(PMCITTPP) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMHOLDQ1) TOFILE(PMCIALQ0) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
/*********** CLOF       OPNID(PMHOLDX1)                               /*CPM005*/
             CLOF       OPNID(PMHOLDQ1)                               /*CPM005*/
 
/*********** CPYF       FROMFILE(PMCITTPP) TOFILE(PMCIALPP) +         /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYF       FROMFILE(PMCIALQ0) TOFILE(PMCIALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCIALPP))    /*CPM005*/
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMCIALPD))    /*CPM005*/
 
/* CREATE TOTAL FILE WITH TOTAL TYPE EQUAL TO "B" */
/*********** OPNQRYF    FILE((PMCITTPP)) FORMAT(PMCIALPP) +           /*CPM005*/
/************************ GRPFLD(TTCNUM TTPTFR TTCURR TTPOTY) +       /*CPM005*/
/************************ MAPFLD((FICNUM TTCNUM) (FIPTFR TTPTFR) +    /*CPM005*/
/************************ (FICURR TTCURR) (FIRECI '"D"') (FIDGRS +    /*CPM005*/
/************************ '0') (FIPOTY TTPOTY) (FIINSC '"   "') +     /*CPM005*/
/************************ (FIDGRC '"   "') (FIINDS '0') (FITOTT +     /*CPM005*/
/************************ '"B"') (FIASVL '%SUM(TTASVL)') (FILIVL +    /*CPM005*/
/************************ '%SUM(TTLIVL)'))                            /*CPM005*/
/**********  OPNQRYF    FILE((PMCIALQ0)) FORMAT(PMCIALPD) +               */            /*AR796218*/
/**********               GRPFLD(TTCNUM TTPTFR TTCURR TTPOTY) +           */            /*AR796218*/
/**********               MAPFLD((FICNUM TTCNUM) (FIPTFR TTPTFR) +        */            /*AR796218*/
/**********               (FICURR TTCURR) (FIRECI '"D"') (FIDGRS +        */            /*AR796218*/
/**********               '0') (FIPOTY TTPOTY) (FIINSC '"   "') +         */            /*AR796218*/
/**********               (FIDGRC '"   "') (FIINDS '0') (FITOTT +         */            /*AR796218*/
/**********               '"B"') (FIASVL '%SUM(TTASVL)') (FILIVL +        */            /*AR796218*/
/**********               '%SUM(TTLIVL)'))                                */ /*CPM005*/ /*AR796218*/
             OPNQRYF    FILE((PMCIALQ0)) FORMAT(PMCIALPD)            +
                          GRPFLD(TTCNUM TTPTFR TTCURR TTPOTY TTLOIC) +
                          MAPFLD((FICNUM TTCNUM) (FIPTFR TTPTFR)     +
                          (FICURR TTCURR) (FIRECI '"D"') (FIDGRS     +
                          '0') (FIPOTY TTPOTY) (FIINSC '"   "')      +
                          (FIDGRC '"   "') (FIINDS '0') (FITOTT      +
                          '"B"') (FIASVL '%SUM(TTASVL)') (FILIVL     +
                          '%SUM(TTLIVL)') (FILOIC TTLOIC))                              /*AR796218*/
/*********** CPYFRMQRYF FROMOPNID(PMCITTPP) TOFILE(PMCIALPP) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMCIALQ0) TOFILE(PMCIALPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
/*********** CLOF       OPNID(PMCITTPP)                               /*CPM005*/
             CLOF       OPNID(PMCIALQ0)                               /*CPM005*/
 
/* CREATE TOTAL FILE WITH TOTAL TYPE EQUAL TO "A" */
/*********** OPNQRYF    FILE((PMCITTPP)) FORMAT(PMCIALPP) +           /*CPM005*/
/************************ GRPFLD(TTCNUM TTPTFR TTCURR) +              /*CPM005*/
/************************ MAPFLD((FICNUM TTCNUM) (FIPTFR TTPTFR) +    /*CPM005*/
/************************ (FICURR TTCURR) (FIRECI '"D"') (FIPOTY +    /*CPM005*/
/************************ '"  "') (FITOTT '"A"') (FIDGRS '0') +       /*CPM005*/
/************************ (FIDGRC '"   "') (FIINSC '"   "') (FIINDS + /*CPM005*/
/************************ '0') (FIASVL '%SUM(TTASVL)') (FILIVL +      /*CPM005*/
/************************ '%SUM(TTLIVL)'))                            /*CPM005*/
/**********  OPNQRYF    FILE((PMCIALQ0)) FORMAT(PMCIALPD) +               */            /*AR796218*/
/**********               GRPFLD(TTCNUM TTPTFR TTCURR) +                  */            /*AR796218*/
/**********               MAPFLD((FICNUM TTCNUM) (FIPTFR TTPTFR) +        */            /*AR796218*/
/**********               (FICURR TTCURR) (FIRECI '"D"') (FIPOTY +        */            /*AR796218*/
/**********               '"  "') (FITOTT '"A"') (FIDGRS '0') +           */            /*AR796218*/
/**********               (FIDGRC '"   "') (FIINSC '"   "') (FIINDS +     */            /*AR796218*/
/**********               '0') (FIASVL '%SUM(TTASVL)') (FILIVL +          */            /*AR796218*/
/**********               '%SUM(TTLIVL)'))                                */ /*CPM005*/ /*AR796218*/
             OPNQRYF    FILE((PMCIALQ0)) FORMAT(PMCIALPD)           +
                          GRPFLD(TTCNUM TTPTFR TTCURR TTLOIC)       +
                          MAPFLD((FICNUM TTCNUM) (FIPTFR TTPTFR)    +
                          (FICURR TTCURR) (FIRECI '"D"') (FIPOTY    +
                          '"  "') (FITOTT '"A"') (FIDGRS '0')       +
                          (FIDGRC '"   "') (FIINSC '"   "') (FIINDS +
                          '0') (FIASVL '%SUM(TTASVL)') (FILIVL      +
                          '%SUM(TTLIVL)') (FILOIC TTLOIC))                              /*AR796218*/
/*********** CPYFRMQRYF FROMOPNID(PMCITTPP) TOFILE(PMCIALPP) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMCIALQ0) TOFILE(PMCIALPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
/*********** CLOF       OPNID(PMCITTPP)                               /*CPM005*/
             CLOF       OPNID(PMCIALQ0)                               /*CPM005*/
 
/* CREATE PORTFOLIO TOTALS FOR ALL PORTFOLIOS */
/*********** OPNQRYF    FILE((PMCITTPP)) FORMAT(PMASITPP) +           /*CPM005*/
/************************ GRPFLD(TTCNUM TTPTFR TTPOTY TTDGRC TTDGRS + /*CPM005*/
/************************ TTINSC TTINDS) MAPFLD((QICNUM TTCNUM) +     /*CPM005*/
/************************ (QIPTFR TTPTFR) (QIDGRS TTDGRS) (QIDGRC +   /*CPM005*/
/************************ TTDGRC) (QIINSC TTINSC) (QITOTT '"I"') +    /*CPM005*/
/************************ (QIPOTY TTPOTY) (QIINSS TTINDS) (QIASSV +   /*CPM005*/
/************************ '%SUM(TTASVL)') (QILIAV '%SUM(TTLIVL)'))    /*CPM005*/
/**********  OPNQRYF    FILE((PMCIALQ0)) FORMAT(PMASITPD) +               */            /*AR796218*/
/**********               GRPFLD(TTCNUM TTPTFR TTPOTY TTDGRC TTDGRS +     */            /*AR796218*/
/**********               TTINSC TTINDS) MAPFLD((QICNUM TTCNUM) +         */            /*AR796218*/
/**********               (QIPTFR TTPTFR) (QIDGRS TTDGRS) (QIDGRC +       */            /*AR796218*/
/**********               TTDGRC) (QIINSC TTINSC) (QITOTT '"I"') +        */            /*AR796218*/
/**********               (QIPOTY TTPOTY) (QIINSS TTINDS) (QIASSV +       */            /*AR796218*/
/**********               '%SUM(TTASVL)') (QILIAV '%SUM(TTLIVL)'))        */ /*CPM005*/ /*AR796218*/
             OPNQRYF    FILE((PMCIALQ0)) FORMAT(PMASITPD)           +
                          GRPFLD(TTCNUM TTPTFR TTPOTY TTDGRC TTDGRS +
                          TTINSC TTINDS) MAPFLD((QICNUM TTCNUM)     +
                          (QIPTFR TTPTFR) (QIDGRS TTDGRS) (QIDGRC   +
                          TTDGRC) (QIINSC TTINSC) (QITOTT '"I"')    +
                          (QIPOTY TTPOTY) (QIINSS TTINDS) (QIASSV   +
                          '%SUM(TTASVL)') (QILIAV '%SUM(TTLIVL)'))                      /*AR796218*/
/*********** CPYFRMQRYF FROMOPNID(PMCITTPP) TOFILE(PMASITPP) +        /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMCIALQ0) TOFILE(PMASITPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** CLOF       OPNID(PMCITTPP)                               /*CPM005*/
             CLOF       OPNID(PMCIALQ0)                               /*CPM005*/
 
/*********** CPYF       FROMFILE(PMASITPP) TOFILE(PMASLIPP) +         /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYF       FROMFILE(PMASITPD) TOFILE(PMASLIPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMASLIPP))    /*CPM005*/
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMASLIPD))    /*CPM005*/
 
/* CREATE TOTAL FILE WITH TOTAL TYPE EQUAL TO "D" */
/*********** OPNQRYF    FILE((PMASITPP)) FORMAT(PMASLIPP) +           /*CPM005*/
/************************ GRPFLD(QICNUM QIPTFR QIPOTY QIDGRC +        /*CPM005*/
/************************ QIDGRS) MAPFLD((FECNUM QICNUM) (FEPTFR +    /*CPM005*/
/************************ QIPTFR) (FEDGRS QIDGRS) (FEPOTY QIPOTY) +   /*CPM005*/
/************************ (FEINSC '"   "') (FEINSS '0') (FETOTT +     /*CPM005*/
/************************ '"D"') (FEDGRC QIDGRC) (FEASSV +            /*CPM005*/
/************************ '%SUM(QIASSV)') (FELIAV '%SUM(QILIAV)'))    /*CPM005*/
             OPNQRYF    FILE((PMASITPD)) FORMAT(PMASLIPD) +
                          GRPFLD(QICNUM QIPTFR QIPOTY QIDGRC +
                          QIDGRS) MAPFLD((FECNUM QICNUM) (FEPTFR +
                          QIPTFR) (FEDGRS QIDGRS) (FEPOTY QIPOTY) +
                          (FEINSC '"   "') (FEINSS '0') (FETOTT +
                          '"D"') (FEDGRC QIDGRC) (FEASSV +
                          '%SUM(QIASSV)') (FELIAV '%SUM(QILIAV)'))    /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMASITPP) TOFILE(PMASLIPP) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMASITPD) TOFILE(PMASLIPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
/*********** CLOF       OPNID(PMASITPP)                               /*CPM005*/
             CLOF       OPNID(PMASITPD)                               /*CPM005*/
 
/* CREATE TOTAL FILE WITH TOTAL TYPE EQUAL TO "B" */
/*********** OPNQRYF    FILE((PMASITPP)) FORMAT(PMASLIPP) +           /*CPM005*/
/************************ GRPFLD(QICNUM QIPTFR QIPOTY) +              /*CPM005*/
/************************ MAPFLD((FECNUM QICNUM) (FEPTFR QIPTFR) +    /*CPM005*/
/************************ (FEPOTY QIPOTY) (FETOTT '"B"') +            /*CPM005*/
/************************ (FEDGRC '"   "') (FEDGRS '0') +             /*CPM005*/
/************************ (FEINSC '"   "') (FEINSS '0') +             /*CPM005*/
/************************ (FEASSV '%SUM(QIASSV)') +                   /*CPM005*/
/************************ (FELIAV '%SUM(QILIAV)'))                    /*CPM005*/
             OPNQRYF    FILE((PMASITPD)) FORMAT(PMASLIPD) +
                          GRPFLD(QICNUM QIPTFR QIPOTY) +
                          MAPFLD((FECNUM QICNUM) (FEPTFR QIPTFR) +
                          (FEPOTY QIPOTY) (FETOTT '"B"') +
                          (FEDGRC '"   "') (FEDGRS '0') +
                          (FEINSC '"   "') (FEINSS '0') +
                          (FEASSV '%SUM(QIASSV)') +
                          (FELIAV '%SUM(QILIAV)'))                    /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMASITPP) TOFILE(PMASLIPP) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMASITPD) TOFILE(PMASLIPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
/*********** CLOF       OPNID(PMASITPP)                               /*CPM005*/
             CLOF       OPNID(PMASITPD)                               /*CPM005*/
 
/* CREATE TOTAL BY INSTRUMENT */
/* CREATE TOTAL FILE WITH TOTAL TYPE EQUAL TO "R" */
/*********** OPNQRYF    FILE((PMCIALPP)) FORMAT(PMICALPP) +           /*CPM005*/
/************************ QRYSLT('FITOTT *EQ "I"') GRPFLD(FICNUM +    /*CPM005*/
/************************ FIPTFR FIPOTY FIDGRC FIDGRS FIINSC FIINDS + /*CPM005*/
/************************ FICURR) MAPFLD((FMRECI '"D"') (FMCNUM +     /*CPM005*/
/************************ FICNUM) (FMPTFR FIPTFR) (FMPOTY FIPOTY) +   /*CPM005*/
/************************ (FMTOTT '"R"') (FMINSC FIINSC) (FMINDS +    /*CPM005*/
/************************ FIINDS) (FMCURR FICURR) (FMDGRC FIDGRC) +   /*CPM005*/
/************************ (FMDGRS FIDGRS) (FMASVL '%SUM(FIASVL)') +   /*CPM005*/
/************************ (FMLIVL '%SUM(FILIVL)'))                    /*CPM005*/
             OPNQRYF    FILE((PMCIALPD)) FORMAT(PMICALPD) +
                          QRYSLT('FITOTT *EQ "I"') GRPFLD(FICNUM +
                          FIPTFR FIPOTY FIDGRC FIDGRS FIINSC FIINDS +
                          FICURR) MAPFLD((FMRECI '"D"') (FMCNUM +
                          FICNUM) (FMPTFR FIPTFR) (FMPOTY FIPOTY) +
                          (FMTOTT '"R"') (FMINSC FIINSC) (FMINDS +
                          FIINDS) (FMCURR FICURR) (FMDGRC FIDGRC) +
                          (FMDGRS FIDGRS) (FMASVL '%SUM(FIASVL)') +
                          (FMLIVL '%SUM(FILIVL)'))                    /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMCIALPP) TOFILE(PMICALPP) +        /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMCIALPD) TOFILE(PMICALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** CLOF       OPNID(PMCIALPP)                               /*CPM005*/
             CLOF       OPNID(PMCIALPD)                               /*CPM005*/
 
/* CREATE PORTFOLIO TOTALS FOR TOTAL TYPE "I" */
/*********** OPNQRYF    FILE((PMCIALPP)) FORMAT(PMICALPP) +           /*CPM005*/
/************************ QRYSLT('FITOTT *EQ "I"') GRPFLD(FICNUM +    /*CPM005*/
/************************ FIPTFR FIPOTY FIDGRC FIDGRS FIINSC +        /*CPM005*/
/************************ FIINDS) MAPFLD((FMRECI '"D"') (FMCNUM +     /*CPM005*/
/************************ FICNUM) (FMPTFR FIPTFR) (FMPOTY FIPOTY) +   /*CPM005*/
/************************ (FMDGRC FIDGRC) (FMDGRS FIDGRS) (FMINSC +   /*CPM005*/
/************************ FIINSC) (FMINDS FIINDS) (FMTOTT '"I"') +    /*CPM005*/
/************************ (FMCURR '"   "') (FMASVL '%SUM(FIASVL)') +  /*CPM005*/
/************************ (FMLIVL '%SUM(FILIVL)'))                    /*CPM005*/
             OPNQRYF    FILE((PMCIALPD)) FORMAT(PMICALPD) +
                          QRYSLT('FITOTT *EQ "I"') GRPFLD(FICNUM +
                          FIPTFR FIPOTY FIDGRC FIDGRS FIINSC +
                          FIINDS) MAPFLD((FMRECI '"D"') (FMCNUM +
                          FICNUM) (FMPTFR FIPTFR) (FMPOTY FIPOTY) +
                          (FMDGRC FIDGRC) (FMDGRS FIDGRS) (FMINSC +
                          FIINSC) (FMINDS FIINDS) (FMTOTT '"I"') +
                          (FMCURR '"   "') (FMASVL '%SUM(FIASVL)') +
                          (FMLIVL '%SUM(FILIVL)'))                    /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMCIALPP) TOFILE(PMICALPP) +        /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMCIALPD) TOFILE(PMICALPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
/*********** CLOF       OPNID(PMCIALPP)                               /*CPM005*/
             CLOF       OPNID(PMCIALPD)                               /*CPM005*/
 
/* CREATE PORTFOLIO TOTALS FOR TOTAL TYPE "B" */
/*********** OPNQRYF    FILE((PMICALPP)) FORMAT(PMICTTPP) +           /*CPM005*/
/************************ QRYSLT('FMTOTT *EQ "I"') GRPFLD(FMCNUM +    /*CPM005*/
/************************ FMPTFR FMPOTY) MAPFLD((ICRECI '"D"') +      /*CPM005*/
/************************ (ICCNUM FMCNUM) (ICPTFR FMPTFR) (ICPOTY +   /*CPM005*/
/************************ FMPOTY) (ICINSC '"   "') (ICINDS '00') +    /*CPM005*/
/************************ (ICTOTT '"B"') (ICCURR '"   "') (ICDGRC +   /*CPM005*/
/************************ '"   "') (ICDGRS '00') (ICASVL +            /*CPM005*/
/************************ '%SUM(FMASVL)') (ICLIVL '%SUM(FMLIVL)'))    /*CPM005*/
             OPNQRYF    FILE((PMICALPD)) FORMAT(PMICALQ0) +
                          QRYSLT('FMTOTT *EQ "I"') GRPFLD(FMCNUM +
                          FMPTFR FMPOTY) MAPFLD((ICRECI '"D"') +
                          (ICCNUM FMCNUM) (ICPTFR FMPTFR) (ICPOTY +
                          FMPOTY) (ICINSC '"   "') (ICINDS '00') +
                          (ICTOTT '"B"') (ICCURR '"   "') (ICDGRC +
                          '"   "') (ICDGRS '00') (ICASVL +
                          '%SUM(FMASVL)') (ICLIVL '%SUM(FMLIVL)'))    /*CPM005*/
/*********** CPYFRMQRYF FROMOPNID(PMICALPP) TOFILE(PMICTTPP) +        /*CPM005*/
/************************ MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMICALPD) TOFILE(PMICALQ0) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)             /*CPM005*/
/*********** CLOF       OPNID(PMICALPP)                               /*CPM005*/
             CLOF       OPNID(PMICALPD)                               /*CPM005*/
 
/*********** CPYF       FROMFILE(PMICTTPP) TOFILE(PMICALPP) +         /*CPM005*/
/************************ MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
             CPYF       FROMFILE(PMICALQ0) TOFILE(PMICALPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*CPM005*/
 
             DLTOVR     FILE(*ALL)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ABNOR:       ENDPGM
