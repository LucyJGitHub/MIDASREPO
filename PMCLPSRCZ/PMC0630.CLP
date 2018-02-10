/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Display of Customer Group')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0630  - DISPLAY OF CUSTOMER GROUP                        */
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
/*       Prev Amend No. CPM005             Date 20Jun96              */
/*                      S01486             Date 07Jul94              */
/*                      35446  SL          DATE 12FEB92              */
/*                      R0757              DATE 20/10/90             */
/*                      R10045             DATE 20/09/90             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*                PBFG/5 - INSTRUMENT ASSET/LIABILITY SPLIT          */
/*                PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY       */
/*       S01486 - Portfolio Management Incorporation                 */
/*       35446  - TFRGRPJOB FAILS WHEN NAME OF DISPLAY GROUP (WHICH IS*/
/*                USED AS GRPJOB NAME) DOESN'T BEGIN WITH ALPHABETIC */
/*                CHARACTER                                          */
/*       R0757  - DIPLAY GROUP ENQUIRY DISPLAYED WHEN DO F12         */
/*       R10045 - CALL INLGRPPGM/PMC0670 INSTEAD OF INLGRPPGM/PM0670 */
/*                CALL INLGRPPGM/PMC0690 INSTEAD OF INLGRPPGM/PM0690 */
/*                                                                   */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/****PGM     PARM(&SCROLL)                                            /*CPM005*/
PGM     PARM(&WJOB &ENQT)                                             /*CPM005*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCL        VAR(&WWEND) TYPE(*CHAR) LEN(1)                 *S01486*/
             DCL        VAR(&DSPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DSPGA) TYPE(*CHAR) LEN(10)                /*35446*/
             DCL        VAR(&RETR) TYPE(*CHAR) LEN(1)            /*R0757*/
/*********** DCL        VAR(&SCROLL) TYPE(*CHAR) LEN(1)               /*CPM005*/
             DCL        VAR(&WJOB) TYPE(*CHAR) LEN(8)                 /*CPM005*/
/************DCL        VAR(&ENQT) TYPE(*CHAR) LEN(1)                  *S01486*/
             DCL        VAR(&ENQT) TYPE(*CHAR) LEN(1)                 /*CPM005*/
/**/
/* IF SCROLL SCREEN SELECTED START SCROLL SCREEN    */
/*********** IF         COND(&SCROLL *EQ 'Y') THEN(DO)                /*CPM005*/
             IF         COND(&WJOB *EQ 'POSINS') THEN(DO)             /*CPM005*/
 /*                                                                    S01486*/
/*********** CHGDTAARA  DTAARA(*GDA (1 1)) VALUE(' ')                  *S01486*/
 /*                                                                    S01486*/
 /*          TFRGRPJOB  GRPJOB(SCROLL) INLGRPPGM(PM0670)               R10045 */
/*********** TFRGRPJOB  GRPJOB(SCROLL) INLGRPPGM(PMC0670)              *S01486*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*S01486*/
             CALL       PGM(PM0670)                                   /*S01486*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
 /**RETRIEVE*DATA*AREA**GDA*********************************************S01486*/
/************                                                          *S01486*/
/************RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)               *S01486*/
/************IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'C') THEN(DO) *S01486*/
/************CALL       PGM(PMC1020)                                   *S01486*/
/************ENDDO                                                     *S01486*/
 /*                         */
             ENDDO
                                                                      /*CPM005*/
/* CALL PM6090 TO ALLOW SELECTION OF DISPLAY GROUP  */                /*CPM005*/
             IF         COND(&WJOB *EQ 'TOTICY') THEN(DO)             /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             CALL       PGM(PM6090)                                   /*CPM005*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             ENDDO                                                    /*CPM005*/
/* CALL PM6070 TO ALLOW SELECTION OF DISPLAY GROUP  */                /*CPM005*/
             IF         COND(&WJOB *EQ 'TOTCCY') THEN(DO)             /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             CALL       PGM(PM6070)                                   /*CPM005*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             ENDDO                                                    /*CPM005*/
/* CALL PMC0671 TO ALLOW SELECTION OF DISPLAY GROUP  */               /*CPM005*/
             IF         COND(&WJOB *EQ 'POSCCY') THEN(DO)             /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             CALL       PGM(PM0671)                                   /*CPM005*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             ENDDO                                                    /*CPM005*/
/**/
/* CALL PM0680 TO ALLOW SELECTION OF DISPLAY GROUP  */
/*********** IF         COND(&SCROLL *EQ 'N') THEN(DO)                 *CPM005*/
             IF         COND(&WJOB *EQ 'TOTINS') THEN(DO)             /*CPM005*/
/************CHGDTAARA  DTAARA(*GDA (1 1)) VALUE(' ')                  *S01486*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*S01486*/
/*           CALL       PGM(PM0680) PARM(&DSPG)                 R0757*/
/*********** CALL       PGM(PM0680) PARM(&DSPG &RETR)         *R0757* /*CPM005*/
             CALL       PGM(PM6050)                                   /*CPM005*/
 /* RETRIEVE DATA AREA *LDA */                                        /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
/**/
/* IF SCROLL SCREEN SELECTED TRANSFER TO GROUP JOB SCROLL  */
/**/
/*********** IF         COND(&DSPG *EQ 'SCROLL    ') THEN(DO)          *CPM005*/
/*           TFRGRPJOB  GRPJOB(&DSPG) INLGRPPGM(PM0670)                R10045 */
/*********** CHGVAR     VAR(&DSPGA) VALUE(X *TCAT &DSPG)        /*35446 S01486*/
/************TFRGRPJOB  GRPJOB(&DSPG) INLGRPPGM(PMC0670)               **35446*/
/*********** TFRGRPJOB  GRPJOB(&DSPGA) INLGRPPGM(PMC0670)       /*35446 S01486*/
/*********** CALL       PGM(PM0670)                           /*S01486* CPM005*/
 /**RETRIEVE*DATA*AREA**GDA*********************************************S01486*/
/************                                                          *S01486*/
/************RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)               *S01486*/
/************IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'C') THEN(DO) *S01486*/
/************CALL       PGM(PMC1020)                                   *S01486*/
/************ENDDO                                                     *S01486*/
 /*                         */
/*********** ENDDO                                                     *CPM005*/
/**/
/**IF*DISPLAY*GROUP*ENTERED*START*THAT*GROUP*JOB*********************  *S01486*/
/* IF DISPLAY GROUP ENTERED START THAT SCREEN                          *S01486*/
/*******     IF         COND(&DSPG *NE '   ' *AND &DSPG *NE +         /*CPM005*/
/*******                  'SCROLL    ' *AND &RETR *EQ ' ') THEN(DO)   /*CPM005*/
/************CHGDTAARA  DTAARA(*GDA (1 1)) VALUE(' ')                  *S01486*/
/*           TFRGRPJOB  GRPJOB(&DSPG) INLGRPPGM(PM0690)                R10045 */
/*********** CHGVAR     VAR(&DSPGA) VALUE(X *TCAT &DSPG)        /*35446 S01486*/
/************TFRGRPJOB  GRPJOB(&DSPG) INLGRPPGM(PMC0690)               **35446*/
/*********** TFRGRPJOB  GRPJOB(&DSPGA) INLGRPPGM(PMC0690)       /*35446 S01486*/
/*********** CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')     /*S01486*  *CPM005*/
/*********** CALL       PGM(PM0690)                         /*S01486* /*CPM005*/
 /**RETRIEVE*DATA*AREA**GDA*********************************************S01486*/
/************                                                          *S01486*/
/************RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)               *S01486*/
/************IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'C') THEN(DO) *S01486*/
/************CALL       PGM(PMC1020)                                   *S01486*/
/************ENDDO                                                     *S01486*/
 /*                         */
/*********** ENDDO                                                    /*CPM005*/
             ENDDO
END:         CHGDTAARA  DTAARA(*LDA (654 10)) VALUE('          ')     /*CPM005*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
