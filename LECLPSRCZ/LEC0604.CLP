/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE History processing')                         */
/********************************************************************/
/*                                                                  */
/*     Midas - Customer Lending Module                              */
/*                                                                  */
/*     LEC0604  -  HISTORY PROCESSING                               */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. MD046161           Date 09Aug17              */
/*       Prev Amend No. AR786878           Date 05Jun13              */
/*                      CCB022B            Date 06Aug12              */
/*                      AR1080820          Date 26Jan13              */
/*                      AR544186           Date 01Aug12              */
/*                      AR567199           Date 01Aug12              */
/*                      262509             Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CAS019A            Date 26Jul07              */
/*                      CAS016             Date 28Feb06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS009             Date 04May04              */
/*                      CLE041             Date 11Oct04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      152070             Date 25Jan99              */
/*                      CEU031             Date 12NoV98              */
/*                      094398             Date 31Jul96             */
/*                      S01408           DATE  23MAY96              */
/*                      S01408           DATE  26APR96              */
/*                      076542           DATE  06JUN95              */
/*                      BH3382           DATE  01AUG92              */
/*                      BHF982           DATE  19FEB91              */
/*                      BHF375           DATE  08AUG90              */
/*                      S01189           DATE  09FEB90              */
/*                      S01194           DATE  08FEB90              */
/*                      S01179           DATE  14SEP88              */
/*                      S01098           DATE 08/07/86              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046161 - Database error on COB component LEC60A.         */
/*       AR786878 - New processing for manual repayment and         */
/*                  repayment schedule for PDCL's. (Child:AR786879) */
/*       CCB022B - COB Restructure - COB File Manager                */
/*       AR1080820 - LEC06A seq 02002 encountered error in Day 3 SG */
/*                   COB                                            */
/*       AR544186 - Improve performance of LEC0604/LEC07003 in COB. */
/*                  (Child: AR544188)                               */
/*       AR567199 - Ignore Records with FERECI = '*' from LEFEEDAC  */
/*                  (Child: AR567200)                               */
/*       262509 - Empty STAT flag returned by COB                   */
/*       CLE134 - Past Due Call Loan Processing                     */
/*       CAS019A - CAS016 Upgrade to Midasplus-Alphanumeric Customer */
/*                 (Recompile)                                       */
/*       CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over     */
/*                Whole Period)                                      */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       CLE041 - Collateralised Lending Phase 2B                    */
/*       152070 - GMRV processing run when the feature is off.      */
/*       CEU031 - EMU Global Manager Changes                        */
/*                Here, call ED program ED0600 to extract           */
/*                before and after images of rolled over loans      */
/*     094398  - ADD FEE ACTIONS IN LE0410 REPORT                   */
/*     S01408  - Addition of core hook LEC0604011                   */
/*     S01408  - Addition of core hook LEC0604010                   */
/*               Addition of core hook LEC0604009                   */
/*               Addition of core hook LEC0604008                   */
/*               Addition of core hook LEC0604007                   */
/*               Addition of core hook LEC0604006                   */
/*               Addition of core hook LEC0604005                   */
/*               Addition of core hook LEC0604004                   */
/*               Addition of core hook LEC0604003                   */
/*               Addition of core hook LEC0604002                   */
/*               Addition of core hook LEC0604001                   */
/*     076542  -  DBE in LE0400  (see also LF HISTS)                */
/*     BH3382  -  Move clear of ACTN3 to CLP/LERC315                */
/*     BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                      */
/*     BHF375  -  HISTS NOT UPDATED DUE TO MISSING CALL TO CB0150   */
/*             -  DUPLICATE OF BHF235                               */
/*     S01189  -  COB RECOVERY PROCESSING                           */
/*     S01194  -  NEW STANDING DATA                                 */
/*     S01179  -  AS400 INCORPORATION                               */
/*     S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,INSTEAD   */
/*                OF CLEARING AND ADDING.                           */
/*                FROM AND TO FILES ARE NOW 'BLOCKED'.              */
/*                                                                  */
/********************************************************************/
/************PGM                                                      /*S01189*/
/**********  PGM        PARM(&CNAM &CSEQ)                                          /*S01189 CLE134*/
             PGM        PARM(&CNAM &CSEQ &RERUN)                                          /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('HISTORY UPDATE AND EVENTS +
                        ACTIONED TODAY REPORT ')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
/************DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)*/           /*S01189*/
             DCL        VAR(&RUNDX) TYPE(*CHAR) LEN(5)                /*094398*/
             DCLF       FILE(TABTB10) RCDFMT(TABTB10F)                /*094398*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU031*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU031*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU031*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU031*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*CEU031*/
             DCL        VAR(&CEU031) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CEU031*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CLE041*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CAS009*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)                                   /*CAS009*/
             DCL        VAR(&CAS016) TYPE(*CHAR) LEN(1)                                   /*CAS016*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&JOBDTAQ) TYPE(*CHAR) LEN(8)                               /*AR1080820*/
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)                                /*AR1080820*/
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)                                  /*AR1080820*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(8)                                 /*AR1080820*/
/**/
             RTVJOBA    NBR(&JOBNBR)                                                   /*AR1080820*/
             CHGVAR     VAR(&JOBDTAQ) VALUE('Q_' *CAT &JOBNBR)                         /*AR1080820*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)                             /*AR1080820*/
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')                         /*AR1080820*/
             DLTDTAQ    DTAQ(&DPLIB/&JOBDTAQ)                                          /*AR1080820*/
             MONMSG     MSGID(CPF0000 CPF2105)                                         /*AR1080820*/
                                                                                          /*CAS009*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/*/COPY WNCPYSRC,LEC0604016                                          */
/**/
/*           DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
                                                                                        /*AR544186*/
/* Before doing anything make sure that any missing members     */                      /*AR544186*/
/* are reinstated */                                                                    /*AR544186*/
/**********     SCLFMMGR  FILE(HISTSHH) ACTION(ADD)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSHM) ACTION(ADD)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSHN) ACTION(ADD)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSHP) ACTION(ADD)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSHQ) ACTION(ADD)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSZX) ACTION(ADD)                  */         /*AR544186 CCB022B*/
/**/                                                                  /*CEU031*/
/*  Access PF/SDMMODPD to determine whether ED  module is on.         /*CEU031*/
/**/                                                                  /*CEU031*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU031*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CEU031*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*CEU031*/
/**/                                                                  /*CEU031*/
/*  Database error handling.                                          /*CEU031*/
/**/                                                                  /*CEU031*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CEU031*/
                CHGJOB  SWS('XXXXXX11')                               /*CEU031*/
                GOTO       CMDLBL(ENDPGM)                             /*CEU031*/
             ENDDO                                                    /*CEU031*/
/* */                                                                 /*CEU031*/
/* Check if CEU031 is existing in SCSARDPD */                         /*CEU031*/
/* */                                                                 /*CEU031*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU031*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU031*/
             CHGVAR     VAR(&SARD) VALUE('CEU031')                    /*CEU031*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD ' ')     /*CEU031*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU031) VALUE('Y'))                    /*CEU031*/
/* */                                                                                     /*CLE041*/
/* Check if CLE025 is installed */                                                        /*CLE041*/
/* */                                                                                     /*CLE041*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE041*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE041*/
             CHGVAR     VAR(&SARD) VALUE('CLE025')                                        /*CLE041*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD ' ')                         /*CLE041*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                          CHGVAR     VAR(&CLE025) VALUE('Y')                              /*CLE041*/
                          CLRPFM     FILE(LEAGRDPD)                                       /*CLE041*/
                          CLRPFM     FILE(LEAGACPD)                                       /*CLE041*/
             ENDDO                                                                        /*CLE041*/
/**/                                                                                      /*CAS009*/
/* Check if CAS009 is enabled. */                                                         /*CAS009*/
/**/                                                                                      /*CAS009*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CAS009*/
           CHGVAR     VAR(&SARD) VALUE('CAS009')                                          /*CAS009*/
                                                                                          /*CAS009*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                       /*CAS009*/
                                                                                          /*CAS009*/
           CHGVAR     VAR(&CAS009) VALUE('N')                                             /*CAS009*/
           IF         COND(&RTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAS009) VALUE('Y'))                                /*CAS009*/
/**/                                                                                      /*CAS016*/
/* Check if CAS016 is enabled. */                                                         /*CAS016*/
/**/                                                                                      /*CAS016*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CAS016*/
           CHGVAR     VAR(&SARD) VALUE('CAS016')                                          /*CAS016*/
                                                                                          /*CAS016*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                       /*CAS016*/
                                                                                          /*CAS016*/
           CHGVAR     VAR(&CAS016) VALUE('N')                                             /*CAS016*/
           IF         COND(&RTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAS016) VALUE('Y'))                                /*CAS016*/
/*/COPY WNCPYSRC,LEC0604017                                          */
/**/
/*  IF P/MFU INDICATOR 'OLD' THEN CLEAR PF/HIUPDxx  ETC.,        */
/*   UPDATE FILE AND P/MFU INDICATOR TO 'NEW'                    */
/**/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
             RCVF                                                     /*094398*/
             CHGVAR     VAR(&RUNDX) VALUE(&RUND)                      /*094398*/
/**/
/************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'OLD') +
                        THEN(DO) *******/                             /*S01189*/
/**********  IF         COND(&STAT *EQ 'N') THEN(DO)  */                           /*S01189 262509*/
             IF         COND(&STAT *NE 'Y') THEN(DO)                                      /*262509*/
/**/
                   OVRDBF     FILE(HIUPDHM) SEQONLY(*YES 500) NBRRCDS(500)              /*AR544186*/
                   OVRDBF     FILE(HIUPDHN) SEQONLY(*YES 500) NBRRCDS(500)              /*AR544186*/
                   OVRDBF     FILE(HIUPDHP) SEQONLY(*YES 500) NBRRCDS(500)              /*AR544186*/
                   OVRDBF     FILE(HIUPDHQ) SEQONLY(*YES 500) NBRRCDS(500)              /*AR544186*/
                   OVRDBF     FILE(HISTSHM) SEQONLY(*YES 500) NBRRCDS(500)              /*AR544186*/
                   OVRDBF     FILE(HISTSHN) SEQONLY(*YES 500) NBRRCDS(500)              /*AR544186*/
                   OVRDBF     FILE(HISTSHP) SEQONLY(*YES 500) NBRRCDS(500)              /*AR544186*/
                   OVRDBF     FILE(HISTSHQ) SEQONLY(*YES 500) NBRRCDS(500)              /*AR544186*/
                                                                                        /*AR544186*/
                CLRPFM     FILE(HIUPDHH)
                CLRPFM     FILE(HIUPDHM)
                CLRPFM     FILE(HIUPDHN)
                CLRPFM     FILE(HIUPDHP)
                CLRPFM     FILE(HIUPDHQ)
                CLRPFM     FILE(HIUPDZX)
/*/COPY WNCPYSRC,LEC0604013                                          */
/**/                                                                  /*076542*/
                CPYF       FROMFILE(HISTSHM) TOFILE(HIUPDHM) +
                             MBROPT(*ADD) INCREL((*IF RECI *EQ 'N')) +
                             FMTOPT(*NOCHK)                           /*076542*/
                CPYF       FROMFILE(HISTSHN) TOFILE(HIUPDHN) +
                             MBROPT(*ADD) INCREL((*IF RECI *EQ 'N')) +
                             FMTOPT(*NOCHK)                           /*076542*/
                CPYF       FROMFILE(HISTSHP) TOFILE(HIUPDHP) +
                             MBROPT(*ADD) INCREL((*IF RECI *EQ 'N')) +
                             FMTOPT(*NOCHK)                           /*076542*/
                CPYF       FROMFILE(HISTSHQ) TOFILE(HIUPDHQ) +
                             MBROPT(*ADD) INCREL((*IF RECI *EQ 'N')) +
                             FMTOPT(*NOCHK)                           /*076542*/
/*/COPY WNCPYSRC,LEC0604014                                          */
/**/
                CLRPFM     FILE(LETLXHH)
                CLRPFM     FILE(LETLXDK)
                CLRPFM     FILE(LETLXZX)
/**/
                CLRPFM     FILE(CONFSHH)
                CLRPFM     FILE(CONFSDK)
                CLRPFM     FILE(CONFSZX)
/**/
                CLRPFM     FILE(INTSTHH)
                CLRPFM     FILE(INTSTHN)
                CLRPFM     FILE(INTSTHP)
                CLRPFM     FILE(INTSTHQ)
                CLRPFM     FILE(INTSTZX)
/**/
                CLRPFM     FILE(CUTX1HH)
                CLRPFM     FILE(CUTX1HN)
                CLRPFM     FILE(CUTX1HP)
                CLRPFM     FILE(CUTX1HQ)
                CLRPFM     FILE(CUTX1ZX)
/**/
                CLRPFM     FILE(PTSLDHH)
                CLRPFM     FILE(PTSLDPT)
                CLRPFM     FILE(PTSLDZX)
/**/
                CLRPFM     FILE(ACTN5DH)
                CLRPFM     FILE(ACTN5DK)
                CLRPFM     FILE(ACTN5DN)
                CLRPFM     FILE(ACTN5ZX)
                CLRPFM     FILE(LEREMRPD)                                               /*AR786878*/
                                                                                          /*CAS009*/
                IF         COND((&CAS009) *EQ 'Y') THEN(DO)                               /*CAS009*/
                CLRPFM     XLECFLSPD                                                      /*CAS009*/
                OVRDBF     FILE(LECFLSPD) TOFILE(XLECFLSPD)                               /*CAS009*/
                ENDDO                                                                     /*CAS009*/
                                                                                          /*CLE134*/
             IF         COND(&RERUN *EQ '      ') THEN(DO)                                /*CLE134*/
                CLRPFM     FILE(LELEGDPD)                                                 /*CLE134*/
                MONMSG     MSGID(CPF0000)                                                 /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604001                                  */       /*S01408*/
/*                                                           */
/**/
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABLEEE)                  * *S01194*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604002                                  */       /*S01408*/
/*                                                           */
/**********     CALL       PGM(LE0400)   */                                               /*CLE134*/
                CALL       PGM(LE0400)  PARM(&RERUN)                                      /*CLE134*/
                                                                                          /*CAS016*/
          IF         COND((&CAS016) *EQ 'Y') THEN(DO)                                     /*CAS016*/
            IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                   /*CAS016*/
                CLRPFM     FILE(LEHTRMPD)                                                 /*CAS016*/
                MONMSG     MSGID(CPF0000)                                                 /*CAS016*/
                CLRPFM     FILE(LEHTRNPD)                                                 /*CAS016*/
                MONMSG     MSGID(CPF0000)                                                 /*CAS016*/
                CLRPFM     FILE(LEHTRPPD)                                                 /*CAS016*/
                MONMSG     MSGID(CPF0000)                                                 /*CAS016*/
                CLRPFM     FILE(LEHTRQPD)                                                 /*CAS016*/
                MONMSG     MSGID(CPF0000)                                                 /*CAS016*/
                CALL       PGM(LE000401)                                                  /*CAS016*/
             ENDDO                                                                        /*CAS016*/
          ENDDO                                                                           /*CAS016*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604003                                  */       /*S01408*/
/**/                                                                  /*CEU031*/
/*  Call program to extract loan which have been actioned today    */ /*CEU031*/
/*  for multi-currency rollover.  This will later on be processed  */ /*CEU031*/
/*  tfor export to Global Manager through DTA.                     */ /*CEU031*/
/**/                                                                  /*CEU031*/
          IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                 /*CEU031*/
             IF         COND(&RERUN *EQ '      ') THEN(DO)                                /*CLE134*/
/**********  IF         COND((%SST(&FMT 99 1) *EQ 'Y') *EQ (&CEU031 + /*152070*/
/**********               *EQ 'Y')) THEN(CALL PGM(ED0600)) /*CEU031*/ /*152070*/
             IF         COND((%SST(&FMT 99 1) *EQ 'Y') *AND (&CEU031 +
                          *EQ 'Y')) THEN(CALL PGM(ED0600))            /*152070*/
             ENDDO                                                                        /*CLE134*/
          ENDDO                                                       /*CEU031*/
/*                                                           */
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)   */              /*CLE134*/ /*MD046161*/
             IF         COND((&RERUN *EQ '      ') *AND (&CSEQ *EQ +
                          9)) THEN(DO)                                                  /*MD046161*/
             CPYF       FROMFILE(LEFEED) TOFILE(LEFEEDAC) +
                          MBROPT(*REPLACE) INCREL((*IF FELCHD *EQ +
                          &RUNDX)) FMTOPT(*MAP *DROP)                 /*094398*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEFEEDAC))                             /*094398*/
             ENDDO                                                                        /*CLE134*/
                                                                                        /*AR567199*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)   */            /*AR567199*/ /*MD046161*/
             IF         COND((&RERUN *EQ 'NEWCOB') *OR (&CSEQ *EQ +
                          19)) THEN(DO)                                                 /*MD046161*/
                CPYF       FROMFILE(LEFEED) TOFILE(LEFEEDAC) +
                             MBROPT(*REPLACE) INCREL((*IF FELCHD *EQ +
                             &RUNDX) (*AND FERECI *NE '*')) +
                             FMTOPT(*MAP *DROP)                                         /*AR567199*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(LEFEEDAC))                                            /*AR567199*/
             ENDDO                                                                      /*AR567199*/
                                                                                        /*AR567199*/
/*/COPY WNCPYSRC,LEC0604012                                          */
                   CALL       PGM(LE0410)
/**/
/*/COPY WNCPYSRC,LEC0604011                                  */       /*S01408*/
                                                                                          /*CAS009*/
                   IF         COND((&CAS009) *EQ 'Y') THEN(DO)                            /*CAS009*/
                      IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                         /*CAS009*/
                         DLTOVR     FILE(LECFLSPD)                                        /*CAS009*/
                         CPYF       FROMFILE(XLECFLSPD) TOFILE(LECFLSPD) +
                                      MBROPT(*ADD)                                        /*CAS009*/
                         MONMSG     MSGID(CPF0000) EXEC(CHGJOB SWS(XXXXXX11))             /*CAS009*/
                      ENDDO                                                               /*CAS009*/
                   ENDDO                                                                  /*CAS009*/
                                                                                          /*CAS009*/
                   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/*********************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))        /*S01189*/
/*********************RTVDTAARA  DTAARA(LESTAT)                       /*S01189*/
/*********************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
/********************************VALUE('NEW')                         /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)                 /*S01189*/
/*********************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))        /*S01189*/
                      CHGVAR     VAR(&STAT) VALUE('Y')                /*S01189*/
/**/                                                                  /*BHF375*/
/* MUST CALL CB0150 HERE TO UPDATE RESTART FLAG ON FILE */            /*BHF375*/
/* ELSE SUBSEQUENT CALL TO CB0160 WILL RETRIEVE WRONG VALUE */        /*BHF375*/
                      CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)  /*BHF375*/
/**/
                   ENDDO
/**/
                ENDDO
/**/
/************** DLTOVR     FILE(TABLE)                                 *S01194*/
/**/
             ENDDO
/**/
/*   CLEAR HISTS - COPY HIUPD TO HISTS - CLEAR HIUPD - RESET IND */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/*********************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/     /*S01189*/
                CHGVAR     VAR(&STAT) VALUE(' ')                      /*S01189*/
                CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
/***************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'NEW') +
 **************************THEN(DO)                                   /*S01189*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)               /*S01189*/
/**/
/**************    CLRPFM     FILE(HISTSHH)                **********  *S01098*/
/**************    CLRPFM     FILE(HISTSHM)                **********  *S01098*/
/**************    CLRPFM     FILE(HISTSHN)                **********  *S01098*/
/**************    CLRPFM     FILE(HISTSHP)                **********  *S01098*/
/**************    CLRPFM     FILE(HISTSHQ)                **********  *S01098*/
/**************    CLRPFM     FILE(HISTSZX)                **********  *S01098*/
/**/                                                                  /*S01098*/
/**********        OVRDBF     FILE(HIUPDHM) SEQONLY(*YES 100)       */           /*S01098 AR544188*/
/**********        OVRDBF     FILE(HIUPDHN) SEQONLY(*YES 100)       */           /*S01098 AR544188*/
/**********        OVRDBF     FILE(HIUPDHP) SEQONLY(*YES 100)       */           /*S01098 AR544188*/
/**********        OVRDBF     FILE(HIUPDHQ) SEQONLY(*YES 100)       */           /*S01098 AR544188*/
/*/COPY WNCPYSRC,LEC0604015                                          */
/**********        OVRDBF     FILE(HISTSHM) SEQONLY(*YES 100)       */           /*S01098 AR544188*/
/**********        OVRDBF     FILE(HISTSHN) SEQONLY(*YES 100)       */           /*S01098 AR544188*/
/**********        OVRDBF     FILE(HISTSHP) SEQONLY(*YES 100)       */           /*S01098 AR544188*/
/**********        OVRDBF     FILE(HISTSHQ) SEQONLY(*YES 100)       */           /*S01098 AR544188*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604004                                  */       /*S01408*/
/*                                                           */
/**/
/*   REMOVE LOGICAL FILES OVER PHYSICALS BEFORE COPYING     */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604007                                  */       /*S01408*/
/*                                                           */
/**********        RMVM       FILE(HISTR) MBR(HISTR)                 */          /*S01098 AR544188*/
/**********        MONMSG     MSGID(CPF0000)                         */          /*S01098 AR544188*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604008                                  */       /*S01408*/
/*                                                           */
/**/                                                                  /*S01098*/
/* Disable Access Paths to speed up copies                          */                  /*AR544186*/
/**********     SCLFMMGR  FILE(HISTSHH) ACTION(REM)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSHM) ACTION(REM)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSHN) ACTION(REM)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSHP) ACTION(REM)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSHQ) ACTION(REM)                  */         /*AR544186 CCB022B*/
/**********     SCLFMMGR  FILE(HISTSZX) ACTION(REM)                  */         /*AR544186 CCB022B*/
/**************    CPYF       FROMFILE(HIUPDHH) TOFILE(HISTSHH) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**********        CPYF       FROMFILE(HIUPDHH) TOFILE(HISTSHH) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM HISTSHH)                   */           /*S01098 CCB022B*/
/**/
/**************    CPYF       FROMFILE(HIUPDHM) TOFILE(HISTSHM) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**************    MONMSG     MSGID(CPF2817)                 ********  *S01098*/
/**********        CPYF       FROMFILE(HIUPDHM) TOFILE(HISTSHM) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM HISTSHM)                   */           /*S01098 CCB022B*/
/**/
/**************    CPYF       FROMFILE(HIUPDHN) TOFILE(HISTSHN) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**************    MONMSG     MSGID(CPF2817)                 ********  *S01098*/
/**********        CPYF       FROMFILE(HIUPDHN) TOFILE(HISTSHN) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM HISTSHN)                   */           /*S01098 CCB022B*/
/**/
/**************    CPYF       FROMFILE(HIUPDHP) TOFILE(HISTSHP) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**************    MONMSG     MSGID(CPF2817)                 ********  *S01098*/
/**********        CPYF       FROMFILE(HIUPDHP) TOFILE(HISTSHP) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM HISTSHP)                   */           /*S01098 CCB022B*/
/**/
/**************    CPYF       FROMFILE(HIUPDHQ) TOFILE(HISTSHQ) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**************    MONMSG     MSGID(CPF2817)                 ********  *S01098*/
/**********        CPYF       FROMFILE(HIUPDHQ) TOFILE(HISTSHQ) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM HISTSHQ)                   */           /*S01098 CCB022B*/
/**/
/**************    CPYF       FROMFILE(HIUPDZX) TOFILE(HISTSZX) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**************    MONMSG     MSGID(CPF2817)                 ********  *S01098*/
/**********        CPYF       FROMFILE(HIUPDZX) TOFILE(HISTSZX) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM HISTSZX)                   */           /*S01098 CCB022B*/
/* Enable Access Paths after copy                                   */                  /*AR544186*/
/**********        SCLFMMGR  FILE(HISTSHH) ACTION(ADD)               */         /*AR544186 CCB022B*/
/**********        SCLFMMGR  FILE(HISTSHM) ACTION(ADD)               */         /*AR544186 CCB022B*/
/**********        SCLFMMGR  FILE(HISTSHN) ACTION(ADD)               */         /*AR544186 CCB022B*/
/**********        SCLFMMGR  FILE(HISTSHP) ACTION(ADD)               */         /*AR544186 CCB022B*/
/**********        SCLFMMGR  FILE(HISTSHQ) ACTION(ADD)               */         /*AR544186 CCB022B*/
/**********        SCLFMMGR  FILE(HISTSZX) ACTION(ADD)               */         /*AR544186 CCB022B*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604005                                  */       /*S01408*/
/*                                                           */
/**/                                                                  /*S01098*/
                   DLTOVR     FILE(HIUPDHM)                           /*S01098*/
                   DLTOVR     FILE(HIUPDHN)                           /*S01098*/
                   DLTOVR     FILE(HIUPDHP)                           /*S01098*/
                   DLTOVR     FILE(HIUPDHQ)                           /*S01098*/
                   DLTOVR     FILE(HISTSHM)                           /*S01098*/
                   DLTOVR     FILE(HISTSHN)                           /*S01098*/
                   DLTOVR     FILE(HISTSHP)                           /*S01098*/
                   DLTOVR     FILE(HISTSHQ)                           /*S01098*/
/**/
/*                 ADDLFM     FILE(HISTR) MBR(HISTR) */    /*S01098*/ /*BHF982*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604009                                  */       /*S01408*/
/*                                                           */
/**********        ADDLFM     FILE(HISTR) MBR(HISTR) SHARE(*YES)     */          /*BHF982 AR544188*/
/**********        MONMSG     MSGID(CPF0000)                         */          /*S01098 AR544188*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604010                                  */       /*S01408*/
/*                                                           */
/**/                                                                  /*S01098*/
/******************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/******************RTVDTAARA  DTAARA(LESTAT)*/                        /*S01189*/
/******************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 *****************************VALUE('OLD')                            /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)*/               /*S01189*/
/******************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('N')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
/**/
/**********        CLRPFM     FILE(HIUPDHH)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(HIUPDHM)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(HIUPDHN)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(HIUPDHP)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(HIUPDHQ)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(HIUPDZX)                          */                  /*CCB022B*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0604006                                  */       /*S01408*/
/*                                                           */
/**/
/******************CLRPFM     FILE(ACTN3DH)****/           /* BH3382 */
/******************CLRPFM     FILE(ACTN3DK)****/           /* BH3382 */
/******************CLRPFM     FILE(ACTN3DN)****/           /* BH3382 */
/******************CLRPFM     FILE(ACTN3ZX)****/           /* BH3382 */
/**/
                ENDDO
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
