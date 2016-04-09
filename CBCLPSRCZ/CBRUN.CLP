/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB COB run controlling component')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBRUN - CLOSE OF BUSINESS CONTROLLING COMPONENT             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD023005           Date 23Oct13              */
/*       Prev Amend No. MD022112           Date 05Sep13              */
/*                      CCB021             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGL030             Date 18Dec09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CCB014             Date 25Apr05              */
/*                      CPK018             Date 22Feb04              */
/*                      CGP002             Date 04Jul03              */
/*                      CCB012             DATE 31May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 07Nov11              */
/*                      196795             Date 13Aug01              */
/*                      196122             Date 10Aug01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB003             DATE 17Oct96              */
/*                      S01408             DATE 30Aug96              */
/*                      083886             DATE 20FEB95              */
/*                      S01420             DATE 14MAR95              */
/*                      S01408             DATE 18APR95              */
/*                      S01502             DATE 02DEC94              */
/*                      078087             DATE 24OCT94              */
/*                      035423             DATE 11AUG94              */
/*                      S01491             DATE 01OCT94              */
/*                      S01495             DATE 01OCT94              */
/*                      S01488             DATE 18APR94              */
/*                      054545             DATE 24FEB94              */
/*                      055670             DATE 21FEB94              */
/*                      036796             DATE 10JAN94              */
/*                      S01421             DATE 23JUN93              */
/*                      S01375             DATE 03APR92              */
/*                      E28933             DATE 27SEP91              */
/*                      LN0278             DATE 11JUL90              */
/*                      LN0482             DATE 05JUL90              */
/*                      LN0420             DATE 25JUN90              */
/*                      LN0076             DATE 01MAY90              */
/*                      LN0017             DATE 26APR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD023005 - Change of LF access path during reopen IC proc   */
/*       MD022112 - SCC1711 performance improvement                  */
/*       CCB021 - COB Restructure - Non Working Day COB              */
/*              - Remove processing for files CBCOUNT, CBFINISH,     */
/*                TOTALP, and FINISH. Replace call to CBCOUNT with   */
/*                CB000002.                                          */
/*       CGL030 - Sundry Postings                                    */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*                Use of hooks CBRUN001,003,008,031->040             */
/*       CPK018 - Change the TFRCTL of CBCMOND to a CALL.            */
/*       CGP002 - Add call to GOC000100 to update the global         */
/*                dashboard.                                         */
/*       CCB012 - Journaling options for high availability.  Make    */
/*              CBJRN redundant.                                     */
/*       CPK014 - Release 4 packaging.  Data queues moved from XLIB  */
/*                to DPLIB.                                          */
/*              - Switches U7/U8 not monitored after call to CBC0510 */
/*       196795 - Use DTAARA CBRECV instead of DTAQ MAINDTQ to avoid */
/*                object lock at V5R1M0.                             */
/*     196122 - Creation of CBDTQA/B/C/D use *LIBCRTAUT              */
/*     CCB003 - COB Performance Enhancements - Task Split            */
/*              Task Split - Create Components and Dependencies      */
/*              Also create new copy of Mutually Exclusive for       */
/*              use in CoB                                           */
/*     S01408 - Addition of core hook CBRUN007                       */
/*            - Addition of core hook CBRUN006                       */
/*            - Addition of core hook CBRUN005                       */
/*            - Addition of core hook CBRUN004                       */
/*            - Addition of core hook CBRUN003                       */
/*            - Addition of core hook CBRUN002                       */
/*            - Addition of core hook CBRUN001                       */
/*     083886 - Do not exclude COBBEGIN/COBEND from count of         */
/*              components held on CBRUN, as these components must   */
/*              also run in the Close Of Business run. Program       */
/*              CBMON has been amended to display the correct no. of */
/*              'real' components on the screen.                     */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*       S01408 - Core hook added CBRUNMP1                           */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*       078087 - Set logging levels so that all relevant info is    */
/*                logged but the spool file does not exceed the max  */
/*                size specified by the system.                      */
/*       035423 - SHOULD END JOURNALLING BEFORE DELETING JOURNAL     */
/*       S01491 - Autocall.                                          */
/*       S01495 - COB enhancements.                                  */
/*       S01488 - CoB run condition enhancements                     */
/*       054545 - For Forward Revals Posted should check pos.23 of   */
/*                DLSTAT not pos.24                                  */
/*       055670 - Set-up of DTAARA/CBRUN moved to here to prevent    */
/*                errors in complete componenets count on restart.   */
/*                This also incorporates 034909.                     */
/*       036796  - SPOT REVAL. INDICATOR WAS MOVED FROM DLSTAT       */
/*                 (POS.14) TO GLSTAT (POS.35).                      */
/*       S01421 - Condition CoB prompts on flag from SDCOBPPD        */
/*                BLI step 1 changes                                 */
/*       S01375 - Auto COB changes                                   */
/*       E28933 - REMOVE CALL TO REDUNDANT RT BOND PROGRAM           */
/*       LN0278 - ACCESS DATE AND TIME USING PROGRAM CBTIME          */
/*       LN0482 - AMEND COB AUDIT REPORT MESSAGE TO BE *STATUS       */
/*       LN0420 - ADD INFORMATION MESSAGE FOR COB AUDIT REPORT       */
/*       LN0076 - WAIT TIME NECESSARY ON RCF DISTRIBUTION ALCOBJ     */
/*       LN0017 - AMENDMENT TO RCF DISTRIBUTION PROGRAM              */
/*                TERMINATION PROCESSING                             */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCLF       FILE(CBRUNDF)
/**/
             DCL        VAR(&GL) TYPE(*LGL) LEN(1)
             DCL        VAR(&DL) TYPE(*LGL) LEN(1)
             DCL        VAR(&CL) TYPE(*LGL) LEN(1)
             DCL        VAR(&EM) TYPE(*LGL) LEN(1)
             DCL        VAR(&LE) TYPE(*LGL) LEN(1)
             DCL        VAR(&FD) TYPE(*LGL) LEN(1)
             DCL        VAR(&FX) TYPE(*LGL) LEN(1)
             DCL        VAR(&MM) TYPE(*LGL) LEN(1)
             DCL        VAR(&RE) TYPE(*LGL) LEN(1)
             DCL        VAR(&MS) TYPE(*LGL) LEN(1)
             DCL        VAR(&SE) TYPE(*LGL) LEN(1)
             DCL        VAR(&RC) TYPE(*LGL) LEN(1)
             DCL        VAR(&FF) TYPE(*LGL) LEN(1)
             DCL        VAR(&MT) TYPE(*LGL) LEN(1)
             DCL        VAR(&FT) TYPE(*LGL) LEN(1)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(5)
/*******     DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(3)               /*LN0278*/
/*******     DCL        VAR(&FROMFMT) TYPE(*CHAR) LEN(4)              /*LN0278*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)
/*******     DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*LN0278*/
/*******     DCL        VAR(&DATE) TYPE(*DEC) LEN(6)                  /*LN0278*/
             DCL        VAR(&DFMT) TYPE(*CHAR) LEN(1)
/*******     DCL        VAR(&RFMT) TYPE(*CHAR) LEN(1)                 /*LN0278*/
/*******     DCL        VAR(&DAYNO) TYPE(*DEC) LEN(5)                 /*LN0278*/
             DCL        VAR(&DAYNOA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&ACCR) TYPE(*DEC) LEN(1)
             DCL        VAR(&EOM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&GLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&BOM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ACCRA) TYPE(*CHAR) LEN(5)
/************DCL        VAR(&BOND) TYPE(*CHAR) LEN(1)                  E28933*/
             DCL        VAR(&IN50) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN51) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN52) TYPE(*LGL) LEN(1)
/************DCL        VAR(&PRELIB)  TYPE(*CHAR) LEN(2)                                  /*CPK014*/
             DCL        VAR(&DTQDLEN) TYPE(*DEC) LEN(5) VALUE(1)
             DCL        VAR(&T) TYPE(*CHAR) LEN(1) VALUE('T')
/************DCL        VAR(&DTAQLIB)  TYPE(*CHAR) LEN(10) +                              /*CPK014*/
/************           VALUE('  XLIB    ')                                               /*CPK014*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&FRQLST) TYPE(*CHAR) LEN(20)              /*S01488*/
             DCL        VAR(&FRQLST) TYPE(*CHAR) LEN(99)              /*S01488*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/           /*S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
             DCL        VAR(&FREVAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SREVAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FREVLP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HKINT) TYPE(*LGL) LEN(1)
             DCL        VAR(&CBSTAT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RSTTIM) TYPE(*CHAR) LEN(9)
             DCL        VAR(&SRTTIM) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRINT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INU7) TYPE(*LGL) LEN(1)
             DCL        VAR(&INU8) TYPE(*LGL) LEN(1)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SPECIAL) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)           /*S01375*/
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)            /*S01375*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                /*S01375*/
             DCL        VAR(&SDCOB) TYPE(*CHAR) LEN(200)              /*S01421*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                 /*S01421*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01421*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01491*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01491*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01491*/
             DCL        VAR(&S01491) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01491*/
             DCL        VAR(&S01420) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01420*/
             DCL        VAR(&BYPASS) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01420*/
             DCL        VAR(&CONT) TYPE(*DEC) LEN(1 0) VALUE(0)       /*S01420*/
             DCL        VAR(&LOG) TYPE(*CHAR) LEN(10)                 /*078087*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBRUN001                                          */ /*S01408*/
                                                                      /*S01408*/
             DCL        VAR(&CCB014) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CCB014*/
             DCL        VAR(&DLYCOB) TYPE(*CHAR) LEN(256)                                 /*CCB014*/
             DCL        VAR(&AUTSCH) TYPE(*CHAR) LEN(1)                                   /*CCB014*/
/**/
/* GLOBAL ERROR TRAP */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBRUN031                                            */
/*                                                                                        /*CCB014*/
/** Check to see if automatic scheduling is on                       */                   /*CCB014*/
/*                                                                                        /*CCB014*/
                                                                                          /*CCB014*/
             RTVDTAARA  DTAARA(DLYCOB (2 1)) RTNVAR(&AUTSCH)                              /*CCB014*/
/*                                                                                        /*CCB014*/
/** Check to see if the Delay COB feature is set on (CCB014)       */                     /*CCB014*/
/*                                                                                        /*CCB014*/
                                                                                          /*CCB014*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CCB014*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CCB014*/
             CHGVAR     VAR(&SAR) VALUE('CCB014')                                         /*CCB014*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR +
                          &SCSARD)                                                        /*CCB014*/
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&CCB014) VALUE('Y'))                                        /*CCB014*/
/**/                                                                  /*S01420*/
/* Determine if SAR S01420 (CoB Enh.) is switched ON */               /*S01420*/
/**/                                                                  /*S01420*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01420*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01420*/
             CHGVAR     VAR(&SAR) VALUE('S01420')                     /*S01420*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01420*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01420) VALUE('Y'))                    /*S01420*/
/**/                                                                  /*S01420*/
/* VERIFY IF MONITOR IS ACTIVE */                                     /*S01420*/
/* IF MONITOR ACTIVE - COB SHOULD BE RUNNING */                       /*S01420*/
             IF         COND(&S01420 *EQ 'Y') THEN(DO)                /*S01420*/
                ALCOBJ     OBJ((MONCHK *DTAARA *EXCL)) WAIT(5)        /*S01420*/
                MONMSG     MSGID(CPF1002) EXEC(CHGVAR VAR(&BYPASS) +
                             VALUE('Y'))                              /*S01420*/
                DLCOBJ     OBJ((MONCHK *DTAARA *EXCL))                /*S01420*/
             ENDDO                                                    /*S01420*/
/**/
/* SET JOB MESSAGE QUEUE AND MOPERQ TO *BREAK */
/**/
             IF         COND(&S01420 *NE 'Y') THEN(DO)                /*S01420*/
             RTVJOBA    JOB(&JOB) USER(&USRID)
/*********** CHGMSGQ    MSGQ(&JOB) DLVRY(*BREAK)   **/                /*S01375*/
/*********** CHGMSGQ    MSGQ(MOPERQ) DLVRY(*BREAK) **/                /*S01375*/
/*********** CALL       PGM(SCC2451)                         /*S01375   S01495*/
             CHGMSGQ    MSGQ(&JOB) DLVRY(*NOTIFY)                     /*S01495*/
/*/COPY WNCPYSRC,CBRUN010                                            */
             CHGMSGQ    MSGQ(MOPERQ) DLVRY(*NOTIFY)                   /*S01495*/
/**/                                                                  /*S01420*/
/* IF S01420 INSTALLED MOPERQ MAY BE ALREADY CHANGED BY ANOTHER JOB *   S01420*/
/**/                                                                  /*S01420*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01420*/
/*/COPY WNCPYSRC,CBRUN011                                            */
             IF         COND(&S01420 *NE 'Y') THEN(GOTO +
                          CMDLBL(ABNORMAL))                           /*S01420*/
/*/COPY WNCPYSRC,CBRUN012                                            */
             ENDDO                                                    /*S01420*/
             ENDDO                                                    /*S01420*/
/**/                                                                  /*S01491*/
/* Determine if SAR S01491 (Autocall) is switched ON */               /*S01491*/
/**/                                                                  /*S01491*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01491*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01491*/
             CHGVAR     VAR(&SAR) VALUE('S01491')                     /*S01491*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01491*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01491) VALUE('Y'))                    /*S01420*/
/**/
/* DETERMINE WHICH MODULES ARE PRESENT */
/* BY CHECKING VALUES ON DATA AREA MMOD */
/**/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/**/
             CHGVAR     VAR(&GL) VALUE(%SST(&MMOD 1 1) *EQ 'Y')
             CHGVAR     VAR(&DL) VALUE(%SST(&MMOD 2 1) *EQ 'Y')
             CHGVAR     VAR(&CL) VALUE(%SST(&MMOD 4 1) *EQ 'Y')
             CHGVAR     VAR(&EM) VALUE(%SST(&MMOD 7 1) *EQ 'Y')
             CHGVAR     VAR(&LE) VALUE(%SST(&MMOD 10 1) *EQ 'Y')
             CHGVAR     VAR(&FD) VALUE(%SST(&MMOD 11 1) *EQ 'Y')
             CHGVAR     VAR(&FX) VALUE(%SST(&MMOD 13 1) *EQ 'Y')
             CHGVAR     VAR(&MM) VALUE(%SST(&MMOD 14 1) *EQ 'Y')
             CHGVAR     VAR(&RE) VALUE(%SST(&MMOD 16 1) *EQ 'Y')
             CHGVAR     VAR(&MS) VALUE(%SST(&MMOD 18 1) *EQ 'Y')
             CHGVAR     VAR(&SE) VALUE(%SST(&MMOD 21 1) *EQ 'Y')
             CHGVAR     VAR(&RC) VALUE(%SST(&MMOD 22 1) *EQ 'Y')
             CHGVAR     VAR(&FF) VALUE(%SST(&MMOD 50 1) *EQ 'Y')
             CHGVAR     VAR(&MT) VALUE(%SST(&MMOD 51 1) *EQ 'Y')
             CHGVAR     VAR(&FT) VALUE(%SST(&MMOD 57 1) *EQ 'Y')
/**/
/* IF AUDIT REPORT FAILED BYPASS SET UP */
/* PROCESSING AND PRODUCE AUDIT REPORT  */
/**/
             RTVDTAARA  DTAARA(SDSTAT (110 5)) RTNVAR(&TYPE)
/**/
             IF         COND(&TYPE *EQ 'PRINT') THEN(GOTO AUDREP)
/**/
/* CBRUN SET UP PROCESSING */
/**/
/**/
/**SET*UP*START*TIME*AND*DATE*ON*CBSTAT*USING**/                      /*LN0278*/
/**SYSTEM*TIME,*DATE*AND*DATE*FORMAT*TO*SET**/                        /*LN0278*/
/**UP*VARIABLES*FOR*STANDARD*PROGRAM*ZA0270**/                        /*LN0278*/
/**/
/* USE PROGRAM CBTIME TO GET START DATE AND TIME FOR CBSTAT */        /*LN0278*/
/**/
/********    RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*LN0278*/
/********    RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*LN0278*/
/********    RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&DATFMT)               /*LN0278*/
/********    IF         COND(&DATFMT *EQ 'DMY') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('D'))                      /*LN0278*/
/********    IF         COND(&DATFMT *EQ 'MDY') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('M'))                      /*LN0278*/
/********    IF         COND((&DATFMT *EQ 'YMD') *OR (&DATFMT *EQ +
                          'JUL')) THEN(DO)                            /*LN0278*/
/********               CHGVAR   VAR(&FROMFMT) VALUE('*' *CAT &DATFMT)/*LN0278*/
/********               CVTDAT   DATE(&SDATE) TOVAR(&SDATE) +
                           FROMFMT(&FROMFMT) TOFMT(*DMY) TOSEP(*NONE) /*LN0278*/
/********               CHGVAR   VAR(&DFMT) VALUE('D')                /*LN0278*/
/********    ENDDO                                                    /*LN0278*/
/********    CHGVAR     VAR(&DATE) VALUE(&SDATE)                      /*LN0278*/
/********    CALL       PGM(ZA0270) PARM(&DATE &DFMT &RFMT &DAYNO)    /*LN0278*/
/********    IF         COND(&RFMT *EQ '1') THEN(GOTO CMDLBL(ABNORMAL)) LN0278*/
/********    CHGVAR     VAR(&DAYNOA) VALUE(&DAYNO)                    /*LN0278*/
             IF         COND((&S01420 *EQ 'Y') *AND (&BYPASS *EQ +
                          'Y')) THEN(GOTO CMDLBL(TYPE))               /*S01420*/
             CALL       PGM(CBTIME) PARM(&DAYNOA &STIME &DFMT)        /*LN0278*/
             CHGDTAARA  DTAARA(CBSTAT (33 5)) VALUE(&DAYNOA)
             CHGDTAARA  DTAARA(CBSTAT (38 6)) VALUE(&STIME)
TYPE:                                                                 /*S01420*/
/**/
/* IF NOT A RESTART */
/**/
   IF        COND(&TYPE *EQ 'BEGIN') THEN(DO)
/* */                                                                 /*S01375*/
/**Analyse*to*see*if*prompts*are*necessary*else*only*set*****S01375*/ /*S01491*/
/**data*area*************************************************S01375*/ /*S01491*/
/************************************************************S01375*/ /*S01491*/
/* CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')   S01375*/ /*S01491*/
/* CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)        S01375*/ /*S01491*/
/************IF        COND((%SST(&CB_AUTO 66 4) *EQ '*YES') *AND +*/ /*S01495*/
/************               (%SST(&CB_AUTO 21 10) *EQ 'IC TERM')) +*/ /*S01495*/
/************           THEN(DO)                            */ /*S01375 S01495*/
/*   IF         COND(%SST(&CB_AUTO 21 10) *EQ 'IC TERM') +
                          THEN(DO)                           S01495*/ /*S01491*/
/*           GOTO       CMDLBL(UPD_SDSTAT)                   S01375*/ /*S01491*/
/*           ENDDO                                           S01375*/ /*S01491*/
/**/
/* DELETE JOURNAL AND JOURNAL RECEIVER USED YESTERDAY */
/**/
/**********  ENDJRNPF   FILE(*ALL) JRN(CBJRN)                                  /*035423*/ /*CCB012*/
/**********  MONMSG     MSGID(CPF0000)                                         /*035423*/ /*CCB012*/
/**********  DLTJRN     JRN(CBJRN)                                                        /*CCB012*/
/**********  MONMSG     MSGID(CPF2105)                                                    /*CCB012*/
/**********  CHGJOB     INQMSGRPY(*DFT)                                                   /*CCB012*/
/**********  DLTJRNRCV  JRNRCV(CBRCV000)                                                  /*CCB012*/
/**********  MONMSG     MSGID(CPF2105)                                                    /*CCB012*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                                   /*CCB012*/
/**/
/* CLEAR FILES CONTAINING FAILED COMPONENT MESSAGES, HALT DETAILS */
/* AND COMPONENT STATUS MESSAGES PRODUCED BY YESTERDAY'S RUN */
/**/
             CLRPFM     FILE(CBAUDTPD)
             CLRPFM     FILE(CBHALTPD)
             CLRPFM     FILE(CBMESGPD)
             CLRPFM     FILE(SCACCPTD)                                                  /*MD023005*/
/**/
/* CALL EODCHK TO DETERMINE ACCRUAL TYPE */
/* AND SET UP ACCRUAL FIELDS ON SDSTAT AND CBSTAT */
/**/
             CALL       PGM(EODCHK) PARM(&ACCR)
/**/
/* IF EODCHK FAILS TO SET UP A CORRECT ACCRUAL VALUE */
/* TERMINATE WITH DATABASE ERROR */
/**/
             IF         COND(&ACCR *NE 1 *AND &ACCR *NE 2 *AND &ACCR +
                          *NE 3) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* TYPE 1 - NORMAL CLOSE OF BUSINESS RUN */
/**/
             IF         COND(&ACCR *EQ 1) THEN(DO)
                        CHGDTAARA  DTAARA(SDSTAT (116 1)) VALUE('1')
                        CHGVAR     VAR(&ACCRA) VALUE('ONE  ')
                        CHGDTAARA  DTAARA(CBSTAT (46 5)) VALUE(&ACCRA)
             ENDDO
/**/
/* TYPE 2 - BRANCH ACCRUAL FOLLOWED BY WORKING DAY */
/**/
             IF         COND(&ACCR *EQ 2) THEN(DO)
                        CHGDTAARA  DTAARA(SDSTAT (116 1)) VALUE('2')
                        CHGVAR     VAR(&ACCRA) VALUE('TWO  ')
                        CHGDTAARA  DTAARA(CBSTAT (46 5)) VALUE(&ACCRA)
             ENDDO
/**/
/* TYPE 3 - BRANCH ACCRUAL FOLLOWED BY NON-WORKING DAY */
/**/
             IF         COND(&ACCR *EQ 3) THEN(DO)
                        CHGDTAARA  DTAARA(SDSTAT (116 1)) VALUE('3')
                        CHGVAR     VAR(&ACCRA) VALUE('THREE')
                        CHGDTAARA  DTAARA(CBSTAT (46 5)) VALUE(&ACCRA)
             ENDDO
/*/COPY WNCPYSRC,CBRUN018                                            */
/**/
/* CALL SD2000 TO DETERMINE WHETHER END OF MONTH OR END OF YEAR */
/**/
/************CALL       PGM(SD2000) PARM(&EOM &EOY &ERROR)            /*S01488*/
/************IF         COND(&ERROR *EQ 'Y') THEN(DO)                 /*S01488*/
/************           RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)  /*S01488*/
/************           SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
/************                      MSGDTA(&MEM) TOMSGQ(MOPERQ)        /*S01488*/
/************           GOTO       CMDLBL(ABNORMAL)                   /*S01488*/
/************ENDDO                                                    /*S01488*/
/************RTVDTAARA  DTAARA(GLSTAT) RTNVAR(&GLSTAT)                /*S01488*/
/************IF         COND(&EOM *EQ 'Y') THEN+
/************           (CHGDTAARA DTAARA(GLSTAT (67 1)) VALUE('Y'))  /*S01488*/
/************ELSE       CMD(IF COND(%SST(&GLSTAT 67 1) *EQ 'Y') +
/************             THEN(DO))  */                               /*S01488*/
/************               CHGVAR VAR(&BOM) VALUE('Y')*/             /*S01488*/
/************               CHGDTAARA  DTAARA(GLSTAT (67 1)) VALUE('N') S01488*/
/************             ENDDO */                                    /*S01488*/
/**/
/* CALL SE2500 FOR END OF MONTH OR END */
/* OF YEAR CHECK FOR SECURITIES TRADING */
/**/
             IF         COND(&SE) THEN(DO)
                        OVRDBF     FILE(TABLE) TOFILE(TABSE)
                        CALL       PGM(SE2500)
                        DLTOVR     FILE(TABLE)
             ENDDO
/**/
/**IF*RT*BOND*INTERFACE*INSTALLED*SET*UP**/                           /*E28933*/
/**PARAMETER*TO*PRODUCE*BOND*REPORTS**/                               /*E28933*/
/**/
/************IF         COND(&SE) THEN(CALL PGM(SE2013) PARM(&BOND))    E28933*/
/**/
/* CLEAR HALT TIME AND DATE FIELDS FROM DATA AREA CBSTAT */
/**/
             CHGDTAARA  DTAARA(CBSTAT (5 9)) VALUE(' ')
                                                                                          /*CGP002*/
/* Clear global dashboard */                                                              /*CGP002*/
                                                                                          /*CGP002*/
             CALL       PGM(GOC000100) PARM('*CLEAR')                                     /*CGP002*/
                                                                                          /*CGP002*/
/* Reset global dashboard */                                                              /*CGP002*/
                                                                                          /*CGP002*/
             CALL       PGM(GOC000100) PARM('*ALL')                                       /*CGP002*/
                                                                                          /*CGP002*/
/**/
/* DELETE AND RECREATE DATA QUEUES REQUIRED */
/**/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRELIB)                              /*CPK014*/
/************CHGVAR     VAR(%SST(&DTAQLIB 1 2)) VALUE(&PRELIB)                            /*CPK014*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBRUNMP1                                            */
                                                                      /*S01408*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CGL030*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGL030*/
             CHGVAR     VAR(&SAR) VALUE('CGL030')                                         /*CGL030*/
                                                                                          /*CGL030*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CGL030*/
                                                                                          /*CGL030*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CGL030*/
             CALL CBC0042                                                                 /*CGL030*/
             ENDDO                                                                        /*CGL030*/
/************DLTDTAQ    DTAQ(&DTAQLIB/CBDTQA)                                             /*CPK014*/
/************MONMSG     MSGID(CPF2105)                                                    /*CPK014*/
/************DLTDTAQ    DTAQ(&DTAQLIB/CBDTQB)                                             /*CPK014*/
/************MONMSG     MSGID(CPF2105)                                                    /*CPK014*/
/************DLTDTAQ    DTAQ(&DTAQLIB/CBDTQC)                                             /*CPK014*/
/************MONMSG     MSGID(CPF2105)                                                    /*CPK014*/
/************DLTDTAQ    DTAQ(&DTAQLIB/CBDTQD)                                             /*CPK014*/
/************MONMSG     MSGID(CPF2105)                                                    /*CPK014*/
/*/COPY WNCPYSRC,CBRUN013                                            */
/*******     CRTDTAQ    DTAQ(&DTAQLIB/CBDTQA) MAXLEN(16) TEXT('COB +
/************             scheduler data queue') AUT(*USE)          */   /*196122*/
/*******     CRTDTAQ    DTAQ(&DTAQLIB/CBDTQB) MAXLEN(8) TEXT('COB +
/************             free streams data queue') AUT(*USE)       */   /*196122*/
/*******     CRTDTAQ    DTAQ(&DTAQLIB/CBDTQC) MAXLEN(1) TEXT('COB +
/************             restart data queue') AUT(*USE)            */   /*196122*/
/*******     CRTDTAQ    DTAQ(&DTAQLIB/CBDTQD) MAXLEN(86) TEXT('COB +
/************             passing messages data queue') AUT(*USE)   */   /*196122*/
/************CRTDTAQ    DTAQ(&DTAQLIB/CBDTQA) MAXLEN(16) TEXT('COB +                      /*CPK014*/
/************             scheduler data queue') AUT(*LIBCRTAUT)               /*196122*/ /*CPK014*/
/************CRTDTAQ    DTAQ(&DTAQLIB/CBDTQB) MAXLEN(8) TEXT('COB +                       /*CPK014*/
/************             free streams data queue') AUT(*LIBCRTAUT)            /*196122*/ /*CPK014*/
/************CRTDTAQ    DTAQ(&DTAQLIB/CBDTQC) MAXLEN(1) TEXT('COB +                       /*CPK014*/
/************             restart data queue') AUT(*LIBCRTAUT)                 /*196122*/ /*CPK014*/
/************CRTDTAQ    DTAQ(&DTAQLIB/CBDTQD) MAXLEN(86) TEXT('COB +                      /*CPK014*/
/************            passing messages data queue') AUT(*LIBCRTAUT)         /*196122*/ /*CPK014*/
 
/* Clear data queues. */                                                                  /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('CBDTQA' '*LIBL ')                             /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('CBDTQB' '*LIBL ')                             /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('CBDTQC' '*LIBL ')                             /*CPK014*/
             CALL       PGM(QCLRDTAQ) PARM('CBDTQD' '*LIBL ')                             /*CPK014*/
 
/*/COPY WNCPYSRC,CBRUN017                                            */
/**/                                                                  /*S01420*/
/* SAR S01420 - COB ENHANCEMENTS INSTALLED */                         /*S01420*/
/* BUILD ENVIRONMENT                       */                         /*S01420*/
/**/                                                                  /*S01420*/
             IF         COND(&S01420 *EQ 'Y') THEN(DO)                /*S01420*/
                CALL       PGM(CBC0510)                               /*S01420*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CPK014*/
                   SNDPGMMSG  MSG('CBC0510 - Initialise COB Monitor +
                             terminated abnormally') +
                             TOMSGQ(MOPERQ)                                               /*CPK014*/
                   GOTO       CMDLBL(ABNORMAL)                                            /*CPK014*/
                ENDDO                                                                     /*CPK014*/
             ENDDO                                                    /*S01420*/
/**/
/* CALL EODPMD PROMPT FOR MODULE DETAILS */
/**/
             CHGVAR     VAR(&RTCD) VALUE('*MSG')                      /*S01421*/
             CALL       PGM(AOCOBPR0) PARM(&RTCD '*FIRST ' +
                          &SDCOB)                                     /*S01421*/
             IF         COND(&RTCD *NE ' ') THEN(GOTO +
                        CMDLBL(ABNORMAL))                             /*S01421*/
/*/COPY WNCPYSRC,CBRUN032                                            */
             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(GOTO CMDLBL(TAGUSC1))                                      /*CCB014*/
             IF         COND(%SUBSTRING(&SDCOB 19 1) *EQ Y) +
                          THEN(CALL PGM(EODPMD) PARM('C'))            /*S01421*/
/*/COPY WNCPYSRC,CBRUN033                                            */
TAGUSC1:                                                                                  /*CCB014*/
                                                                      /*S01421*/
 /**/
 /*          CALL       PGM(EODPMD) PARM(&DL &CL &LE &SE &FT &FF)     /*S01421*/
 /**/
/**/                                                                  /*S01375*/
/* Process the Auto COB on request reports and next working day */    /*S01375*/
/**/                                                                  /*S01375*/
/************CHGVAR     VAR(%SST(&CB_AUTO 1 10)) +                 */ /*S01495*/
/************             VALUE('*TODAY    ')               */ /*S01375 S01495*/
/************CALL    PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)*/ /*S01375 S01495*/
/************IF         COND((%SST(&CB_AUTO 66 4) *EQ '*YES')) +   */ /*S01495*/
/************           THEN(DO)                            */ /*S01375 S01495*/
/**/                                                                  /*S01420*/
/* Reset CoB files */                                                 /*S01420*/
/**/                                                                  /*S01420*/
/************CALL       PGM(CBC0517)                                  /*S01420*/          /*196795*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBRUN002                                          */ /*S01408*/
                                                                      /*S01408*/
/**/                                                                  /*S01420*/
             CALL       PGM(SCC2453)                                  /*S01375*/
/*/COPY WNCPYSRC,CBRUN016                                            */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBRUN003                                          */ /*S01408*/
                                                                      /*S01408*/
             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(DO)                                                        /*CCB014*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)                                  /*CCB014*/
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                      /*CCB014*/
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ)                            /*CCB014*/
                        GOTO       CMDLBL(ABNORMAL)                                       /*CCB014*/
             ENDDO                                                                        /*CCB014*/
             ENDDO                                                                        /*CCB014*/
/************ENDDO                                          */ /*S01375 S01495*/
/**/                                                                  /*S01375*/
/**/
/* INITIALISE COMPONENTS WORK FILE AND */
/* DEPENDENCIES WORK FILE FROM MASTER FILES */
/**/
             CPYF       FROMFILE(CBCMPNPD) TOFILE(CBCOMSPD) +
                          MBROPT(*REPLACE)
                                                                                        /*MD022112*/
             CPYF       FROMFILE(SFAPIMDD) TOFILE(SFAPIMTD) +
                          MBROPT(*REPLACE)                                              /*MD022112*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM FILE(SFAPIMTD))                                   /*MD022112*/
/**/
             CPYF       FROMFILE(CBDPRLPD) TOFILE(CBDEPSPD) +
                          MBROPT(*REPLACE)
/**/                                                                  /*CCB003*/
             CPYF       FROMFILE(CBMEXCPD) TOFILE(CBMUTXPD) +
                          MBROPT(*REPLACE)                            /*CCB003*/
/**/
/* CALL CB0105 TO SELECT ON-REQUEST REPORTS TO RUN TODAY */
/**/
             CALL       PGM(CB0105)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* DISPLAY CBRUN STARTED SCREEN */
/**/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUNA)
/*/COPY WNCPYSRC,CBRUN034                                            */
             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(GOTO CMDLBL(TAGUSC2))                                      /*CCB014*/
             SNDF       DEV(*FILE) RCDFMT(CBRUNF2)
/*/COPY WNCPYSRC,CBRUN035                                            */
TAGUSC2:                                                                                  /*CCB014*/
/**/
/* INITIALISE FREQUENCY PARAMETER LIST */
/**/
/************CHGVAR     VAR(&FRQLST) VALUE('YNNNNNNNNNNNNNNNNNNN')    /*S01488*/
/**/
/* SET UP FREQUENCY PARAMETER LIST */
/**/
/************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*S01488*/
/************RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01488*/
/************CHGVAR     VAR(&FREVAL) VALUE(%SST(&DLSTAT 16 1))        /*S01488*/
/************CHGVAR     VAR(&SREVAL) VALUE(%SST(&DLSTAT 14 1))        /*036796*/
/************CHGVAR     VAR(&SREVAL) VALUE(%SST(&GLSTAT 35 1))/*036796/*S01488*/
/*********   CHGVAR     VAR(&FREVLP) VALUE(%SST(&DLSTAT 24 1))        /*054545*/
/************CHGVAR     VAR(&FREVLP) VALUE(%SST(&DLSTAT 23 1))054545* /*S01488*/
/************CHGVAR     VAR(&HKINT) VALUE(%SST(&DLSTAT 21 1) *EQ 'Y') /*S01488*/
/************IF         COND(&ACCR *EQ 2 *OR &ACCR *EQ 3) +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 2 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND(&ACCR *EQ 3) +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 3 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND(&BOND *EQ 'Y') +                           E28933*/
/*************            THEN(CHGVAR VAR(%SST(&FRQLST 4 1)) +          E28933*/
/*************            VALUE('Y'))                                   E28933*/
/************IF         COND(&HKINT *EQ '1') +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 5 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND((&ACCR *EQ 3) *AND (&HKINT *EQ '1')) +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 6 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND((&FREVAL *EQ 'Y') *AND (&FREVLP *EQ +
/************             'Y')) THEN(CHGVAR VAR(%SST(&FRQLST 7 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND((&FREVAL *EQ 'Y') *AND (&FREVLP *EQ +
/************             'N')) THEN(CHGVAR VAR(%SST(&FRQLST 8 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND((&SREVAL *EQ 'Y') *AND (&ACCR *EQ 1)) +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 9 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND(&EOM *EQ 'Y') THEN(CHGVAR +
/************             VAR(%SST(&FRQLST 10 1)) VALUE('Y'))*/       /*S01488*/
/************IF         COND((&ACCR *EQ 2 *OR &ACCR *EQ 3) *AND +
/************             (&EOM *EQ 'Y')) THEN(CHGVAR +
/************             VAR(%SST(&FRQLST 11 1)) VALUE('Y'))*/       /*S01488*/
/************IF         COND(&BOM *EQ 'Y') THEN(CHGVAR +
/************             VAR(%SST(&FRQLST 12 1)) VALUE('Y'))*/       /*S01488*/
/************IF         COND((&ACCR *EQ 2) *AND (&EOM *EQ 'Y')) +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 13 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND((&ACCR *EQ 3) *AND (&EOM *EQ 'Y')) +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 14 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND(%SST(&SESTAT 61 1) *EQ 'Y') +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 15 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND(%SST(&SESTAT 62 1) *EQ 'Y') +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 16 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND(%SST(&SESTAT 64 1) *EQ 'Y') +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 17 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND(%SST(&SESTAT 72 1) *EQ 'Y') +
/************             THEN(CHGVAR VAR(%SST(&FRQLST 18 1)) +
/************             VALUE('Y'))*/                               /*S01488*/
/************IF         COND((%SST(&SESTAT 64 1) *EQ 'Y') *AND (&ACCR +
/************             *EQ 3)) THEN(CHGVAR VAR(%SST(&FRQLST 19 1)) +
/************             VALUE('Y')) */                              /*S01488*/
/************IF         COND((%SST(&SESTAT 72 1) *EQ 'Y') *AND (&ACCR +
/************             *EQ 3)) THEN(CHGVAR VAR(%SST(&FRQLST 20 1)) +
/************             VALUE('Y')) */                              /*S01488*/
/**/                                                                  /*S01488*/
/* SET UP FREQUENCY PARAMETER LIST */                                 /*S01488*/
/**/                                                                  /*S01488*/
             CALL       PGM(CB0800) PARM(&FRQLST)                     /*S01488*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01488*/
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)  /*S01488*/
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ)        /*S01488*/
                        GOTO       CMDLBL(ABNORMAL)                   /*S01488*/
             ENDDO                                                    /*S01488*/
/**/
/* DETERMINE WHETHER COMPONENT REQUIRED TODAY */
/**/
             CALL       PGM(CB0100) PARM(&FRQLST &ERROR)
             IF         COND(&ERROR *EQ 'Y') THEN(DO)
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ)
                        GOTO       CMDLBL(ABNORMAL)
             ENDDO
                                                                      /*CCB003*/
/* Create Task Split components */                                    /*CCB003*/
                                                                      /*CCB003*/
             CALL       PGM(CB0101)                                   /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CCB003*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*CCB003*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)                              /*CCB003*/
             GOTO       CMDLBL(ABNORMAL)                              /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/**/
/* SET UP DEFAULTS FOR TYPE OF AUDIT REPORT REQUIRED */
/**/
             CHGVAR     VAR(&AUDTIM) VALUE('Y')
             CHGVAR     VAR(&AUDMOD) VALUE('Y')
             CHGVAR     VAR(&AUDHAL) VALUE(' ')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBRUN004                                          */ /*S01408*/
                                                                      /*S01408*/
/**/
/* PROMPT FOR TYPE OF AUDIT REPORT REQUIRED */
/* AND ANY HALTS REQUESTED BY USER */
/**/
 DISPLAY:    RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUNA)
/*/COPY WNCPYSRC,CBRUN036                                            */
             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(DO)                                                        /*CCB014*/
             CHGVAR     VAR(&AUDTIM) VALUE('Y')                                           /*CCB014*/
             CHGVAR     VAR(&AUDMOD) VALUE('Y')                                           /*CCB014*/
             GOTO       CMDLBL(TAGUSC3)                                                   /*CCB014*/
             ENDDO                                                                        /*CCB014*/
             SNDRCVF    DEV(*FILE) RCDFMT(CBRUNF0) WAIT(*YES)
             IF         COND(&AUDTIM *NE 'Y' *AND &AUDTIM *NE ' ') +
                          THEN(DO)
                                    CHGVAR VAR(&IN50) VALUE('1')
                                    GOTO       CMDLBL(DISPLAY)
                          ENDDO
             IF         COND(&AUDMOD *NE 'Y' *AND &AUDMOD *NE ' ') +
                          THEN(DO)
                                    CHGVAR VAR(&IN51) VALUE('1')
                                    GOTO       CMDLBL(DISPLAY)
                          ENDDO
             IF         COND(&AUDHAL *NE 'Y' *AND &AUDHAL *NE ' ') +
                          THEN(DO)
                                    CHGVAR VAR(&IN52) VALUE('1')
                                    GOTO       CMDLBL(DISPLAY)
                          ENDDO
/**/
/* SET CBSTAT DATA AREA FOR TYPE OF AUDIT REPORT REQUIRED */
/**/
/*/COPY WNCPYSRC,CBRUN037                                            */
TAGUSC3:                                                                                  /*CCB014*/
             IF         COND(&AUDTIM *EQ 'Y' *AND &AUDMOD *EQ 'Y') +
                          THEN(CHGDTAARA DTAARA(CBSTAT (44 1)) +
                          VALUE('B'))
             IF         COND(&AUDTIM *EQ 'Y' *AND &AUDMOD *EQ ' ') +
                          THEN(CHGDTAARA DTAARA(CBSTAT (44 1)) +
                          VALUE('T'))
             IF         COND(&AUDTIM *EQ ' ' *AND &AUDMOD *EQ 'Y') +
                          THEN(CHGDTAARA DTAARA(CBSTAT (44 1)) +
                          VALUE('M'))
             IF         COND(&AUDTIM *EQ ' ' *AND &AUDMOD *EQ ' ') +
                          THEN(CHGDTAARA DTAARA(CBSTAT (44 1)) +
                          VALUE('N'))
/*/COPY WNCPYSRC,CBRUN008                                            */
             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(GOTO CMDLBL(TAGUSC4))                                      /*CCB014*/
/**/
/* CALL PROGRAM TO DISPLAY REQUEST HALTS MENU */
/**/
             IF         COND(&AUDHAL *EQ 'Y') THEN(CALL PGM(CBC0020) +
                         PARM(&ERROR))
/*/COPY WNCPYSRC,CBRUN009                                            */
/**/
/* IF ERROR IN HALT PROGRAM IS SCREEN TIME OUT THEN CONTINUE       */
/* WITH PROCESSING OTHERWISE TERMINATE THROUGH ABNORMAL PROCESSING */
/**/
             IF         COND(&ERROR *EQ 'T') THEN(CHGJOB SWS(0XXXXXXX))
             IF         COND(&ERROR *EQ 'Y') THEN(GOTO CMDLBL(ABNORMAL))
/*/COPY WNCPYSRC,CBRUN038                                            */
TAGUSC4:                                                                                  /*CCB014*/
/**/
/* SET UP DATA AREA SDSTAT TO 'EOD' */
/**/
 UPD_SDSTAT:                                                          /*S01375*/
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('EOD  ')
/**/                                                                  /*055670*/
/* SET UP DATA AREA CBRUN           */                                /*055670*/
/**/                                                                  /*055670*/
/**********  DLTF       FILE(QTEMP/CBCOUNT)                        */              /*055670 CCB021*/
/**********  MONMSG     MSGID(CPF0000)                             */              /*055670 CCB021*/
/**********  DLTF       FILE(QTEMP/CBFINISH)                       */              /*055670 CCB021*/
/**********  MONMSG     MSGID(CPF0000)                             */              /*055670 CCB021*/
/**********  DLTF       FILE(QTEMP/TOTALP)                         */              /*055670 CCB021*/
/**********  MONMSG     MSGID(CPF0000)                             */              /*055670 CCB021*/
/**********  DLTF       FILE(QTEMP/FINISH)                         */              /*055670 CCB021*/
/**********  MONMSG     MSGID(CPF0000)                             */              /*055670 CCB021*/
/************CPYF       FROMFILE(*LIBL/CBCOMSPD) +
/****************         TOFILE(QTEMP/CBCOUNT) CRTFILE(*YES) +
/****************         INCREL((*IF DHCRQD *EQ 'Y') (*AND DHCOTT +
/****************         *NE 'COBBEGIN') (*AND DHCOTT *NE +
/****************         'COBEND'))                           /*055670 083886*/
/**********  CPYF       FROMFILE(*LIBL/CBCOMSPD) +
/**********               TOFILE(QTEMP/CBCOUNT) CRTFILE(*YES) +
/**********               INCREL((*IF DHCRQD *EQ 'Y'))             */              /*083886 CCB021*/
/**********  CPYF       FROMFILE(QTEMP/CBCOUNT) +
/**********               TOFILE(QTEMP/CBFINISH) CRTFILE(*YES) +
/**********               INCREL((*IF DHCSTS *EQ 'C'))             */              /*055670 CCB021*/
/**********  DSPFD      FILE(QTEMP/CBCOUNT) TYPE(*MBR) +
/**********               OUTPUT(*OUTFILE) OUTFILE(QTEMP/TOTALP)   */              /*055670 CCB021*/
/**********  DSPFD      FILE(QTEMP/CBFINISH) TYPE(*MBR) +
/**********               OUTPUT(*OUTFILE) OUTFILE(QTEMP/FINISH)   */              /*055670 CCB021*/
/**********  CALL       PGM(CBCOUNT)*/                                             /*055670 CCB021*/
             CALL       PGM(CB000002)                                                     /*CCB021*/
             CALL       PGM(GOC000100) PARM(*PHASE)                                       /*CCB021*/
             IF         COND(&S01420 *EQ 'Y') THEN(DO)                /*S01420*/
                CALL       PGM(CBC0511)                               /*S01420*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNORMAL))                        /*S01420*/
             ENDDO                                                    /*S01420*/
/**/
   ENDDO
/**/
/* ELSE IF A RESTART */
/**/
   ELSE      CMD(DO)
             IF         COND(&S01420 *EQ 'Y') THEN(DO)                /*S01420*/
                CALL       PGM(CBC0511)                               /*S01420*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNORMAL))                        /*S01420*/
             ENDDO                                                    /*S01420*/
PASSMON:                                                              /*S01420*/
/**/
/* IF A RESTART AFTER A MACHINE CRASH SET STATUS TO 'Y' */
/**/
             RTVDTAARA  DTAARA(CBSTAT) RTNVAR(&CBSTAT)
             IF         COND(%SST(&CBSTAT 45 1) *EQ 'N') +
                          THEN(CHGDTAARA DTAARA(CBSTAT (45 1)) +
                          VALUE('Y'))
/**/
/**RETRIEVE*NEW*START*TIME*AND*DATE*ON*CBSTAT*/                       /*LN0278*/
/**USING*SYSTEM*TIME,*DATE*AND*DATE*FORMAT*TO**/                      /*LN0278*/
/**SET*UP*VARIABLES*FOR*STANDARD*PROGRAM*ZA0270**/                    /*LN0278*/
/**/
/* USE PROGRAM CBTIME TO GET START DATE AND TIME FOR CBSTAT */        /*LN0278*/
/**/
/********    RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*LN0278*/
/********    RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*LN0278*/
/********    RTVSYSVAL  SYSVAL(QDATFMT) RTNVAR(&DATFMT)               /*LN0278*/
/********    IF         COND(&DATFMT *EQ 'DMY') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('D'))                      /*LN0278*/
/********    IF         COND(&DATFMT *EQ 'MDY') THEN(CHGVAR +
                          VAR(&DFMT) VALUE('M'))                      /*LN0278*/
/********    IF         COND((&DATFMT *EQ 'YMD') *OR (&DATFMT *EQ +
                          'JUL')) THEN(DO)                            /*LN0278*/
/********               CHGVAR   VAR(&FROMFMT) VALUE('*' *CAT &DATFMT)/*LN0278*/
/********               CVTDAT   DATE(&SDATE) TOVAR(&SDATE) +
                           FROMFMT(&FROMFMT) TOFMT(*DMY) TOSEP(*NONE) /*LN0278*/
/********               CHGVAR   VAR(&DFMT) VALUE('D')                /*LN0278*/
/********    ENDDO                                                    /*LN0278*/
/********    CHGVAR     VAR(&DATE) VALUE(&SDATE)                      /*LN0278*/
/********    CALL       PGM(ZA0270) PARM(&DATE &DFMT &RFMT &DAYNO)    /*LN0278*/
/********    IF         COND(&RFMT *EQ '1') THEN(GOTO CMDLBL(ABNORMAL)) LN0278*/
/********    CHGVAR     VAR(&DAYNOA) VALUE(&DAYNO)                    /*LN0278*/
             CALL       PGM(CBTIME) PARM(&DAYNOA &STIME &DFMT)        /*LN0278*/
             CHGVAR     VAR(&RSTTIM) VALUE(&DAYNOA *CAT &STIME)
             RTVDTAARA  DTAARA(CBSTAT (5 9)) RTNVAR(&SRTTIM)
             IF         COND(&RSTTIM *GT &SRTTIM) +
                          THEN(CHGDTAARA DTAARA(CBSTAT (5 9)) +
                          VALUE(' '))
/**/
/* DISPLAY CBRUN RESTARTED SCREEN */
/* UNTIL MONITOR SCREEN DISPLAYED */
/**/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&RUNA)
             SNDF       DEV(*FILE) RCDFMT(CBRUNF1)
   ENDDO
/**/                                                                  /*S01491*/
/* If SAR S01491 is switched ON, setup dataarea ACCOBT */             /*S01491*/
/**/                                                                  /*S01491*/
             IF         COND(&S01491 *EQ 'Y') THEN(DO)                /*S01491*/
/**/                                                                  /*S01491*/
/*   Default - End of day */                                          /*S01491*/
/**/                                                                  /*S01491*/
               CHGDTAARA  DTAARA(ACCOBT (1 1)) VALUE('D')             /*S01491*/
/**/                                                                  /*S01491*/
/*   End of month */                                                  /*S01491*/
/**/                                                                  /*S01491*/
               IF         COND(%SST(&FRQLST 10 1) *EQ 'Y') +
                            THEN(CHGDTAARA DTAARA(ACCOBT (1 1)) +
                            VALUE('M'))                               /*S01491*/
/**/                                                                  /*S01491*/
/*   Beginning of month */                                            /*S01491*/
/**/                                                                  /*S01491*/
               IF         COND(%SST(&FRQLST 12 1) *EQ 'Y') +
                            THEN(CHGDTAARA DTAARA(ACCOBT (1 1)) +
                            VALUE('B'))                               /*S01491*/
/**/                                                                  /*S01491*/
/*   End of year */                                                   /*S01491*/
/**/                                                                  /*S01491*/
               IF         COND(%SST(&FRQLST 22 1) *EQ 'Y') +
                            THEN(CHGDTAARA DTAARA(ACCOBT (1 1)) +
                            VALUE('Y'))                               /*S01491*/
             ENDDO                                                    /*S01491*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBRUN005                                          */ /*S01408*/
                                                                      /*S01408*/
/**/
/* CALL MONITOR PROGRAM */
/* CHANGE LOGGING LEVEL BEFORE CALLING THE COB MONITOR, AND  */       /*078087*/
/* RESET AFTERWARDS                                          */       /*078087*/
/**/
/*/COPY WNCPYSRC,CBRUN039                                            */
             IF         COND(&CCB014 *EQ 'Y' *AND &AUTSCH *EQ 'Y') +
                          THEN(DO)                                                        /*CCB014*/
             CHGDTAARA  DTAARA(DLYCOB (2 1)) VALUE('N')                                   /*CCB014*/
             GOTO       CMDLBL(TAGUSC5)                                                   /*CCB014*/
             ENDDO                                                                        /*CCB014*/
/**********  IF         COND(&S01420 *EQ 'Y') THEN(TFRCTL +                    /*S01420*/ /*CPK018*/
/**********               PGM(CBCMOND))                                        /*S01420*/ /*CPK018*/
             IF         COND(&S01420 *EQ 'Y') THEN(CALL +
                          PGM(CBCMOND))                                                   /*CPK018*/
             CHGMSGQ    MSGQ(&JOB) DLVRY(*NOTIFY)
             RTVJOBA    LOGCLPGM(&LOG)                                /*078087*/
             CHGJOB     LOGCLPGM(*NO)                                 /*078087*/
             CALL       PGM(CBCMON) PARM(&ERROR &JOB)
             CHGJOB     LOGCLPGM(&LOG)                                /*078087*/
             IF         COND(&ERROR *EQ 'Y') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* IF A COB COMPLETES NORMALLY SET STATUS TO 'N' */
/**/
             CHGDTAARA  DTAARA(CBSTAT (45 1)) VALUE('N')
/*/COPY WNCPYSRC,CBRUN014                                            */
/**/
/* PRODUCE EITHER OR BOTH AUDIT REPORTS IF REQUESTED */
/**/
AUDREP:      RTVDTAARA  DTAARA(CBSTAT) RTNVAR(&CBSTAT)
/*********** SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('COB +
                Audit Report(s) being produced') TOPGMQ(*EXT)   /*LN0420LN0482*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('COB +
                          Audit Report(s) being produced') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*LN0482*/
             CHGVAR     VAR(&PRINT) VALUE(%SST(&CBSTAT 44 1))
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('PRINT')
             IF         COND((&PRINT *EQ 'T') *OR (&PRINT *EQ 'B')) +
                          THEN(DO)
                  CALL       PGM(CBC0300) PARM('T')
                  RTVJOBA    SWS(&SWS)
                  IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(CHGVAR +
                               VAR(&INU7) VALUE('1'))
                  IF         COND(%SST(&SWS 8 1) *EQ '1') THEN(CHGVAR +
                               VAR(&INU8) VALUE('1'))
                  IF       COND((&INU7 *EQ '1') *AND (&INU8 *EQ '1')) +
                               THEN(GOTO CMDLBL(ABNORMAL))
             ENDDO
             IF         COND((&PRINT *EQ 'M') *OR (&PRINT *EQ 'B')) +
                          THEN(DO)
                  CALL       PGM(CBC0300) PARM('M')
                  RTVJOBA    SWS(&SWS)
                  IF         COND(%SST(&SWS 7 1) *EQ '1') THEN(CHGVAR +
                               VAR(&INU7) VALUE('1'))
                  IF         COND(%SST(&SWS 8 1) *EQ '1') THEN(CHGVAR +
                               VAR(&INU8) VALUE('1'))
                  IF       COND((&INU7 *EQ '1') *AND (&INU8 *EQ '1')) +
                               THEN(GOTO CMDLBL(ABNORMAL))
             ENDDO
             IF         COND(&PRINT *EQ ' ') THEN(GOTO +
                          CMDLBL(ABNORMAL))
/**/
/* SET DATA AREA SDSTAT FOR NEXT CLOSE OF BUSINESS RUN */
/**/
             CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('BEGIN')
/*******************************************************************/ /*S01491*/
/**TERMINATE*REPORT*DISTRIBUTION*PROGRAM****************************/ /*S01491*/
/*******************************************************************/ /*S01491*/
/*********** CALL       PGM(QSNDDTAQ) PARM('FCDTAQ' '*LIBL' &DTQDLEN +
                          &T)                                           LN0017*/
/*           ALCOBJ     OBJ((FC0100 *DTAARA *EXCL))        /*LN0017*/ /*LN0076*/
/************ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5) */ /*LN0076 S01491*/
/************MONMSG     MSGID(CPF1002) EXEC(CALL PGM(QSNDDTAQ) +      /*S01491*/
/************           PARM('FCDTAQ' '*LIBL' &DTQDLEN &T)) */ /*LN0017 S01491*/
/*DISTLP:****ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(30)       */ /*S01491*/
/************MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(DISTLP))   */ /*S01491*/
/************DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                */ /*S01491*/
/**/
/**SET*DATA*AREA*MPHAS*FOR*NEXT*DAY*SET*UP**************************/ /*S01495*/
/*******************************************************************/ /*S01495*/
/************CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('D')             */ /*S01495*/
             CHGDTAARA  DTAARA(MPHAS (1 1)) VALUE('A')                /*S01495*/
/**/
/* REMOVE 'EOD' FROM MSGQ/MSPECIAL  */
/**/
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(*CLS)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             RCVMSG     MSGQ(MSPECIAL) RMV(*YES) MSG(&SPECIAL)
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             IF         COND(&SPECIAL *NE 'EOD   ') THEN(SNDMSG +
                          MSG('''EOD'' not found on MSPECIAL') +
                          TOMSGQ(MOPERQ))
/*/COPY WNCPYSRC,CBRUN021                                            */
/**/
/* EXIT FROM PROGRAM USING REROUTE JOB */
/**/
/************RRTJOB*****RTGDTA(MIDASIC)*****************************/ /*S01375*/
/**/                                                                  /*S01375*/
/**If*Auto*COB*is*off*or*phase*code*is*not*equal*************/ /*S01375 S01495*/
/**to*'D'*re-route*the*job*as*before,*else call the**********/ /*S01375 S01495*/
/**control*pgm*for*auto*next*day*up*and*i/c*init.*SCC2452.***/ /*S01375 S01495*/
/************************************************************/ /*S01375 S01495*/
/************CHGVAR     VAR(%SST(&CB_AUTO 1 10)) +                 */ /*S01495*/
/************             VALUE('*TODAY    ')               */ /*S01375 S01495*/
/************CALL    PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)*/ /*S01375 S01495*/
/************RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)  */ /*S01375 S01495*/
/************IF        COND((%SST(&CB_AUTO 11 5) *EQ '*STOP') *OR +*/ /*S01495*/
/************                (%SST(&CB_AUTO 66 4) *EQ '*NO ') *OR +*/ /*S01495*/
/************                (&MPHAS *NE 'D')) +                   */ /*S01495*/
/************           THEN(RRTJOB RTGDTA(MIDASIC))        */ /*S01375 S01495*/
/************************************************************/ /*S01375 S01495*/
/************TFRCTL     PGM(SCC2452)                        */ /*S01375 S01495*/
/**/                                                                  /*S01495*/
                                                                                          /*CGP002*/
/* Clear global dashboard */                                                              /*CGP002*/
                                                                                          /*CGP002*/
             CALL       PGM(GOC000100) PARM('*CLEAR')                                     /*CGP002*/
                                                                                          /*CGP002*/
/* Reset global dashboard */                                                              /*CGP002*/
                                                                                          /*CGP002*/
             CALL       PGM(GOC000100) PARM('*ALL')                                       /*CGP002*/
                                                                                          /*CGP002*/
             RRTJOB     RTGDTA(MIDASIC)                               /*S01495*/
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(*CLS)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             MONMSG     MSGID(CPF0000 MCH0000)
             RMVMSG     MSGQ(MSPECIAL) CLEAR(*ALL)
             MONMSG     MSGID(CPF0000 MCH0000)
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBRUN006                                         */  /*S01408*/
                                                                      /*S01408*/
/**/
             SNDPGMMSG  MSG('PROGRAM CBRUN ENDED ABNORMALLY - JOB +
                          CANCELLED') TOMSGQ(MOPERQ)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBRUN007                                          */ /*S01408*/
                                                                      /*S01408*/
             MONMSG     MSGID(CPF0000 MCH0000)
             DSPMSG     MSGQ(MRUNQ) OUTPUT(*PRINT) START(*FIRST)
             MONMSG     MSGID(CPF0000 MCH0000)
SIGNOF:                                                              /*S01420*/
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/*/COPY WNCPYSRC,CBRUN040                                            */
TAGUSC5:                                                                                  /*CCB014*/
             ENDPGM
