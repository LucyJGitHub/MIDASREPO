/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Control display of 'POOL CUSTOMER' job')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC5020 - PROGRAM TO CONTROL DISPLAY OF 'POOL CUSTOMER' JOB */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             DATE 17JUL96              */
/*       Prev Amend No. 089169             DATE 06SEP95              */
/*                      082392             DATE 30JAN95              */
/*                      S01486             DATE 26AUG94              */
/*                      049421             DATE 18JAN93              */
/*                      SA9108                  07APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*                PBFG/7 - NET COMMITMENT BY CURRENCY                */
/*                PBFG/8 - DISPLAY POSITIONS SPLIT BY CURRENCY       */
/*       089169 - CORRECT CALL TO PM0670 AND PM0690                  */
/*       082392 - CHANGE CALL TO PMC0670 TO CALL PM0670              */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       SA9108 - WRITTEN FOR POOL SECURITIES                        */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM     PARM(&SCROLL)                                    /*CPM005*/
             PGM        PARM(&WJOB)                                   /*CPM005*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&WWEND) TYPE(*CHAR) LEN(1)                 *S01486*/
             DCL        VAR(&DSPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RETR) TYPE(*CHAR) LEN(1)
/*********** DCL        VAR(&SCROLL) TYPE(*CHAR) LEN(1)               /*CPM005*/
             DCL        VAR(&WJOB) TYPE(*CHAR) LEN(8)                 /*CPM005*/
/************DCL        VAR(&ENQT) TYPE(*CHAR) LEN(1)                  *S01486*/
             DCL        VAR(&ENQT) TYPE(*CHAR) LEN(1)                 /*CPM005*/
 
/* IF SCROLL SCREEN SELECTED START SCROLL SCREEN    */
 
/*********** IF         COND(&SCROLL *EQ 'Y') THEN(DO)                /*CPM005*/
             IF         COND(&WJOB *EQ 'POSINS') THEN(DO)             /*CPM005*/
/************CHGDTAARA  DTAARA(*GDA (1 1)) VALUE(' ')                  *S01486*/
/************TFRGRPJOB  GRPJOB(SCROLL) INLGRPPGM(PMC0670)              *S01486*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*S01486*/
/*********** CALL       PGM(PMC0670)                          *S01486* *082392*/
             CALL       PGM(PM0670)                                   /*082392*/
 
 /**RETRIEVE*DATA*AREA**GDA*********************************************S01486*/
/************                                                          *S01486*/
/************RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)               *S01486*/
/************IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'C') THEN(DO) *S01486*/
/************CALL       PGM(PMC1020)                                   *S01486*/
/************ENDDO                                                     *S01486*/
 
             ENDDO
/**/                                                                  /*CPM005*/
/**  Call PM6090 to allow selection of display group  */              /*CPM005*/
             IF         COND(&WJOB *EQ 'TOTICY') THEN(DO)             /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             CALL       PGM(PM6090)                                   /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND((&ENQT *EQ 'Y') *OR (&ENQT *EQ 'C')) +
                          THEN(RETURN)                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
/**/                                                                  /*CPM005*/
/**  Call PM6070 to allow selection of display group  */              /*CPM005*/
             IF         COND(&WJOB *EQ 'TOTCCY') THEN(DO)             /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             CALL       PGM(PM6070)                                   /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND((&ENQT *EQ 'Y') *OR (&ENQT *EQ 'C')) +
                          THEN(RETURN)                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
/**/                                                                  /*CPM005*/
/**  Call PM0671 to allow selection of display group  */              /*CPM005*/
             IF         COND(&WJOB *EQ 'POSCCY') THEN(DO)             /*CPM005*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*CPM005*/
             CALL       PGM(PM0671)                                   /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND((&ENQT *EQ 'Y') *OR (&ENQT *EQ 'C')) +
                          THEN(RETURN)                                /*CPM005*/
             ENDDO                                                    /*CPM005*/
 
/**CALL*PM0680*TO*ALLOW*SELECTION*OF*DISPLAY*GROUP***/                /*CPM005*/
/**  Call PM6050 to allow selection of display group  */              /*CPM005*/
 
/*********** IF         COND(&SCROLL *EQ 'N') THEN(DO)                /*CPM005*/
             IF         COND(&WJOB *EQ 'TOTINS') THEN(DO)             /*CPM005*/
/************CHGDTAARA  DTAARA(*GDA (1 1)) VALUE(' ')                  *S01486*/
             CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')               /*S01486*/
/*********** CALL       PGM(PM0680) PARM(&DSPG &RETR)                 /*CPM005*/
             CALL       PGM(PM6050)                                   /*CPM005*/
             RTVDTAARA  DTAARA(*LDA (540 1)) RTNVAR(&ENQT)            /*CPM005*/
             IF         COND((&ENQT *EQ 'Y') *OR (&ENQT *EQ 'C')) +
                          THEN(RETURN)                                /*CPM005*/
 
/**IF*SCROLL*SCREEN*SELECTED*TRANSFER*TO*GROUP*JOB*SCROL****************S01486*/
/**IF*SCROLL*SCREEN*SELECTED*TRANSFER*TO*SCROLL*SCREEN******** /*S01486 CPM005*/
/***********                                                          /*CPM005*/
/*********** IF         COND(&DSPG *EQ 'SCROLL    ') THEN(DO)         /*CPM005*/
/************TFRGRPJOB  GRPJOB(&DSPG) INLGRPPGM(PMC0670)               *S01486*/
/*********** CALL       PGM(PMC0670)                          *S01486* *089169*/
/*********** CALL       PGM(PM0670)                            /*089169 CPM005*/
/***********                                                          /*CPM005*/
 /**RETRIEVE*DATA*AREA**GDA*********************************************S01486*/
/************                                                          *S01486*/
/************RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)               *S01486*/
/************IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'C') THEN(DO) *S01486*/
/************CALL       PGM(PMC1020)                                   *S01486*/
/************ENDDO                                                     *S01486*/
/***********                                                          /*CPM005*/
/*********** ENDDO                                                    /*CPM005*/
/***********                                                          /*CPM005*/
/**IF*DISPLAY*GROUP*ENTERED*START*THAT*GROUP*JOB*********************  *S01486*/
/**IF*DISPLAY*GROUP*ENTERED*START*THAT*SCREEN***************** /*S01486 CPM005*/
/***********                                                          /*CPM005*/
/*********** IF         COND(&DSPG *NE '   ' *AND &DSPG *NE +         /*CPM005*/
/***********              'SCROLL    ' *AND &RETR *EQ ' ') THEN(DO)   /*CPM005*/
/************CHGDTAARA  DTAARA(*GDA (1 1)) VALUE(' ')                  *S01486*/
/************TFRGRPJOB  GRPJOB(&DSPG) INLGRPPGM(PMC0690)               *S01486*/
/*********** CHGDTAARA  DTAARA(*LDA (540 1)) VALUE(' ')        /*S01486 CPM005*/
/*********** CALL       PGM(PMC0690)                          *S01486* *089169*/
/*********** CALL       PGM(PM0690)                            /*089169 CPM005*/
/***********                                                          /*CPM005*/
 /**RETRIEVE*DATA*AREA**GDA*********************************************S01486*/
/************                                                          *S01486*/
/************RTVDTAARA  DTAARA(*GDA (1 1)) RTNVAR(&ENQT)               *S01486*/
/************IF         COND(&ENQT *EQ 'Y' *OR &ENQT *EQ 'C') THEN(DO) *S01486*/
/************CALL       PGM(PMC1020)                                   *S01486*/
/************ENDDO                                                     *S01486*/
/***********                                                          /*CPM005*/
/*********** ENDDO                                                    /*CPM005*/
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
