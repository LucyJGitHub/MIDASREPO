/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Start of Day Reorganisation Control')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - MM Dealer Module                            */
/*                                                                   */
/*       MM8010  -  START OF DAY REORGANISATION CONTROL              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*           1989                                                    */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CDL033             Date 10Feb05              */
/*                      CDL022             Date 03Feb04              */
/*                      CDL020             Date 03Feb04              */
/*                      CDL019             Date 03Feb04              */
/*                      CDL018             Date 03Feb04              */
/*                      CDL017             Date 03Feb04              */
/*                      CDL016             Date 03Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 05MAY95              */
/*                      058012             DATE 31JAN94              */
/*                      S01319             DATE 19SEP91              */
/*                      E27624             DATE 05SEP91              */
/*                      S01328             DATE 28MAY91              */
/*                      S01280             DATE 3DEC90               */
/*                      S01337             DATE 17APR91              */
/*                      E23462             DATE 01OCT90              */
/*                      E22273             DATE 30MAY90              */
/*                      E17654             DATE 25/01/89             */
/*                      E90036             DATE 25/01/89             */
/*                      E16246             DATE 19/01/89             */
/*                      E14042             DATE 30/10/88             */
/*                      E14259             DATE 30/10/88             */
/*                      S01149             DATE 01/06/88             */
/*                      S01145             DATE 08/04/88             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       CDL033 - Floating Rate CDs Issued                           */
/*       CDL022 - Deal Amendment Changes (Recompile)                 */
/*       CDL020 - Apply Base Rate at Value Date (Recompile)          */
/*       CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans    */
/*                (Recompile)                                        */
/*       CDL018 - Multiple Settlement Accounts on Loans/Deposits     */
/*                (Recompile)                                        */
/*       CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep*/
/*                (Recompile)                                        */
/*       CDL016 - Automatic rollover of Fixed Term Loans/Deposits    */
/*                (Recompile)                                        */
/*       S01408 - Addition of core hook MM8010MP1                    */
/*       058012 - Copy error occurred because initial run does not   */
/*                initialise backup file because MMSTAT pos'n 1 has  */
/*                not been initialised to 'Y' yet (ie it is blank).  */
/*       S01319 - Remove redundant processing                        */
/*              - Remove references to TS                            */
/*       E27624 - CREATE LDA DATA AREA AT TOP OF PROGRAM.            */
/*                AMEND PROGRAM TO USE IT AND NOT *LDA               */
/*       S01328 - FRA/IRS REVALUATION - COMMENT ONLY.                */
/*       S01280 - Include FRA, IRS, FF, LE into MM forward book      */
/*       S01337 - SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES     */
/*       E23462 - REPLACE DRS WITH TRADER SUPPORT, (TS).             */
/*       E22273 - CHANGE SECURITY COPIES FROM BEING DONE WITH CPYF   */
/*                TO BEING DONE WITH CRTDUPOBJ. THIS IS TO ENSURE    */
/*                THE SECURITY FILES ARE ALWAYS A COPY OF THE LATEST */
/*                VERSION OF THE MASTER FILE. ALSO CHANGE MONITOR    */
/*                AFTER RESTORE FROM SECURITY FILES SO IT ONLY       */
/*                PICKS UP EMPTY MEMBER MESSAGES.                    */
/*       E17654 - STOP CALLING PROGRAMS INTERACTIVELY                */
/*       E90036 - USE CORRECT VERSIONS OF PROGRAMS WHICH DO NOT NEED */
/*                COMMITMENT CONTROL TO BE ACTIVE. ALSO USE THE PARM */
/*                WHICH IS MONITORED FOR ERROR IN THIS PGM           */
/*       E16246 - REMOVE PROCESSING TO REMOVE PHYSICAL FILE MEMBERS  */
/*                AS THIS CAUSES RESTORE ERRORS DURING RECOVERIES    */
/*                AND AFTER-HOURS LIBRARY SETUP.                     */
/*       E14042 - MULTISTREAMING START OF DAY PERFORMANCE MOD        */
/*       E14259 - JOURNALLING REMOVED TO SPEED UP PROCESSING         */
/*       S01145 - FIX AS COMMITMENT CONTROL MEANS MM                 */
/*                PROGRAMS NEED TO BE RELEASED.                      */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&TERM)
/**/
/*  DECLARE TERMINATION PARAMETER                                   */
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RECVR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWSUBN) TYPE(*DEC) LEN(1)               /*E14042*/
             DCL        VAR(&WWSUBNA) TYPE(*CHAR) LEN(1)             /*E14042*/
             DCL        VAR(&WWSDSTAT) TYPE(*CHAR) LEN(2)            /*E14042*/
             DCL        VAR(&LIBPRE) TYPE(*CHAR) LEN(2)              /*E14259*/
             DCL        VAR(&LIBJNAM) TYPE(*CHAR) LEN(10)   /*E14259*/
/************DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)       /*E22273* *S01337*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)               /*S01337*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)               /*E22273*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,MM8010005                                           */
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CDL033*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CDL033*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CDL033*/
             DCL        VAR(&PFMT) TYPE(*CHAR) LEN(200)                                   /*CDL033*/
             DCL        VAR(&CDL033) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CDL033*/
                                                                                          /*CDL033*/
/**/
/**          DCLDTAARA  DTAARA(MMSTAT) **/                            /*AS/400*/
/**/
/*  GLOBAL MONITOR MESSAGE                                          */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
/**/                                                                  /*E27624*/
/* CREATE LOCAL DATA FOR JOB IN QTEMP */                              /*E27624*/
/**/                                                                  /*E27624*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                         TEXT('Local data area for MM8010') AUT(*USE) /*E27624*/
             MONMSG     MSGID(CPF1023)                                /*E27624*/
 
/**/
/*  IF TERMINATION PARAMETER = 'T', TERMINATE PROGRAM IMMEDIATELY   */
             IF         COND(&TERM *EQ 'T') THEN(GOTO CMDLBL(END))
 
/*ASSEMBLE LIBRARY NAMES AND SWITCH JOURNALLING OFF FOR PERFORMANCE * *E14259*/
                                                                     /*E14259*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBPRE)         /*E14259*/
/************CHGVAR     &LIBJNAM   VALUE(&LIBPRE****'JLIB')      */  /*E14259*/ /*BG18886*/
             CHGVAR     &LIBJNAM   VALUE(&LIBPRE *CAT 'JLIB')        /*E14259*/ /*BG18886*/
/************CHGVAR     VAR(&DLIB) VALUE(&LIBPRE *TCAT 'DLIB')/*E22273 S01337*/
             CHGVAR     VAR(&DPLIB) VALUE(&LIBPRE *TCAT 'DPLIB')      /*S01337*/
             CHGVAR     VAR(&DMLIB) VALUE(&LIBPRE *TCAT 'DMLIB')      /*E22273*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MM8010MP1                                           */
                                                                                         /*CDL033*/
/** Determine if Floating Rate CD Issued feature is                                   */ /*CDL033*/
/** switched on.                                                                      */ /*CDL033*/
                                                                                         /*CDL033*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                     /*CDL033*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                     /*CDL033*/
             CHGVAR     VAR(&PSARD) VALUE('CDL033')                                      /*CDL033*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &PFMT)                   /*CDL033*/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL033) VALUE('Y'))                                       /*CDL033*/
             IF         COND(&PRTCD *NE '       ' *AND &PRTCD *NE +
                          '*NRF   ') THEN(DO)                                            /*CDL033*/
                SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                             TOMSGQ(MOPERQ)                                              /*CDL033*/
                CHGJOB     JOB(XXXXXX11)                                                 /*CDL033*/
                GOTO       CMDLBL(ERROR)                                                 /*CDL033*/
             ENDDO                                                                       /*CDL033*/
                                                                      /*S01408*/
                                                                     /*E14259*/
/* ********* ENDJRNPF * FILE(*ALL) JRN(ICJRN.&LIBJNAM)         E14259   E14042*/
/**/
/*  REMOVE MEMBERS FROM LOGICAL FILES BASED OVER PHYSICAL FILES:    */
/***MMEPOSPP,*MMFNRDPP,*MMFWDDPP,*MMFWDHPP,*MMFWDTPP,*MMCUPAPP,*****/ /*S01319*/
/***MMCUEXPP,*MMFLIQPP                                             */ /*S01319*/
/*  MMEPOSPP, MMFNRDPP, MMFWDDPP, MMFWDHPP, MMFWDTPP, MMFLIQPP,    */ /*S01319*/
             RMVM       FILE(MMEPOSLL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMEPOULL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFNRDLL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFNRULL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFWDDLL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFWUDLL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFWDHLL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFWUHLL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFWDTLL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFWUTLL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFWDDL1) MBR(*ALL)          /*S01149*/
             MONMSG     MSGID(CPF7301)                    /*S01149*/
             RMVM       FILE(MMFWDHL1) MBR(*ALL)          /*S01149*/
             MONMSG     MSGID(CPF7301)                    /*S01149*/
/******      RMVM       FILE(MMCUPALL) MBR(*ALL)          /*S01319*/
/******      MONMSG     MSGID(CPF7301)                    /*S01319*/
/******      RMVM       FILE(MMCUPULL) MBR(*ALL)          /*S01319*/
/******      MONMSG     MSGID(CPF7301)                    /*S01319*/
/******      RMVM       FILE(MMCEXELL) MBR(*ALL)          /*S01319*/
/******      MONMSG     MSGID(CPF7301)                    /*S01319*/
/******      RMVM       FILE(MMCUEXLL) MBR(*ALL)          /*S01319*/
/******      MONMSG     MSGID(CPF7301)                    /*S01319*/
/******      RMVM       FILE(MMCUEULL) MBR(*ALL)          /*S01319*/
/******      MONMSG     MSGID(CPF7301)                    /*S01319*/
             RMVM       FILE(MMFLIQLL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
             RMVM       FILE(MMFLQULL) MBR(*ALL)
             MONMSG     MSGID(CPF7301)
                                                                      /*S01280*/
             RMVM       FILE(DLFUTSLL) MBR(*ALL)                      /*S01280*/
             MONMSG     MSGID(CPF7301)                                /*S01280*/
 
/**/
/*  REMOVE MEMBERS FROM PHYSICAL FILES                              */
/****        RMVM       FILE(MMEPOSPP) MBR(*ALL)             E12246 */
/****        MONMSG     MSGID(CPF7301)                              */
/****        RMVM       FILE(MMFNRDPP) MBR(*ALL)                    */
/****        MONMSG     MSGID(CPF7301)                              */
/****        RMVM       FILE(MMFWDDPP) MBR(*ALL)                    */
/****        MONMSG     MSGID(CPF7301)                              */
/****        RMVM       FILE(MMFWDHPP) MBR(*ALL)                    */
/****        MONMSG     MSGID(CPF7301)                              */
/****        RMVM       FILE(MMFWDTPP) MBR(*ALL)                    */
/****        MONMSG     MSGID(CPF7301)                              */
/****        RMVM       FILE(MMCUPAPP) MBR(*ALL)                    */
/****        MONMSG     MSGID(CPF7301)                              */
/****        RMVM       FILE(MMCUEXPP) MBR(*ALL)                    */
/****        MONMSG     MSGID(CPF7301)                              */
/****        RMVM       FILE(MMFLIQPP) MBR(*ALL)                    */
/****        MONMSG     MSGID(CPF7301)                       E16246 */
 
/**/
/*  ADD MEMBERS BACK TO PHYSICAL FILES                              */
/****                                                        E16246 */
/****        ADDPFM     FILE(MMFLIQPP) MBR(MMFLIQPP) SHARE(*YES) +  */
/****                     TEXT('DRS - Liquidity Exposure File')     */
/****        ADDPFM     FILE(MMCUEXPP) MBR(MMCUEXPP) SHARE(*YES) +  */
/****                     TEXT('DRS - Customer Exposures')          */
/****        ADDPFM     FILE(MMCUPAPP) MBR(MMCUPAPP) SHARE(*YES) +  */
/****                     TEXT('DRS - Customer/Parent Data')        */
/****        ADDPFM     FILE(MMFWDTPP) MBR(MMFWDTPP) SHARE(*YES) +  */
/****                     TEXT('DRS - Forward Book - Totals')       */
/****        ADDPFM     FILE(MMFWDHPP) MBR(MMFWDHPP) SHARE(*YES) +  */
/****                     TEXT('DRS - Forward Book - Half-Monthly + */
/****                     Details')                                 */
/****        ADDPFM     FILE(MMFWDDPP) MBR(MMFWDDPP) SHARE(*YES) +  */
/****                     TEXT('DRS - Forward Book - Daily Details')*/
/****        ADDPFM     FILE(MMFNRDPP) MBR(MMFNRDPP) SHARE(*YES) +  */
/****                     TEXT('DRS - Near Dates Summary')          */
/****        ADDPFM     FILE(MMEPOSPP) MBR(MMEPOSPP) SHARE(*YES) +  */
/****                     TEXT('DRS - Positions For Currency')      */
/****                                                        E16246 */
 
/**/
/* CLEAR PHYSICAL FILE MEMBERS                               E16246 */
             CLRPFM     FILE(MMFLIQPP) MBR(MMFLIQPP)
/******      CLRPFM     FILE(MMCUEXPP) MBR(MMCUEXPP)        /*S01319*/
/******      CLRPFM     FILE(MMCUPAPP) MBR(MMCUPAPP)        /*S01319*/
             CLRPFM     FILE(MMFWDTPP) MBR(MMFWDTPP)
             CLRPFM     FILE(MMFWDHPP) MBR(MMFWDHPP)
             CLRPFM     FILE(MMFWDDPP) MBR(MMFWDDPP)
             CLRPFM     FILE(MMFNRDPP) MBR(MMFNRDPP)
             CLRPFM     FILE(MMEPOSPP) MBR(MMEPOSPP)
/****                                                        E16246 */
                                                                      /*S01280*/
             CLRPFM     FILE(DLFUTSPP) MBR(DLFUTSPP)                  /*S01280*/
/**/
/*  ADD MEMBERS BACK TO LOGICAL FILES                               */
/************ADDLFM     FILE(MMFLQULL) MBR(MMFLQULL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Liquidity Exposure Update File')  E23462*/
/************ADDLFM     FILE(MMFLIQLL) MBR(MMFLIQLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Liquidity Exposures')             E23462*/
/************ADDLFM     FILE(MMCUEULL) MBR(MMCUEULL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - MM Customers Exposures Update +   E23462*/
/*************************File')                                        E23462*/
/************ADDLFM     FILE(MMCUEXLL) MBR(MMCUEXLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - MM Customer Exposures')           E23462*/
/************ADDLFM     FILE(MMCEXELL) MBR(MMCEXELL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Customer Exposures by Date for +  E23462*/
/*************************Enquiries')                                   E23462*/
/************ADDLFM     FILE(MMCUPULL) MBR(MMCUPULL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - MM Customer/Parent Data Update +  E23462*/
/*************************File')                                        E23462*/
/************ADDLFM     FILE(MMCUPALL) MBR(MMCUPALL) SHARE(*YES) +      E23462*/
/************************ TEXT('DRS - MM Customer/Parent Data')         E23462*/
/************ADDLFM     FILE(MMFWUTLL) MBR(MMFWUTLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Forward Book Totals Update File') E23462*/
/************ADDLFM     FILE(MMFWDTLL) MBR(MMFWDTLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Forward Book Totals')             E23462*/
/************ADDLFM     FILE(MMFWUHLL) MBR(MMFWUHLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Forward Book Half Month Totals +  E23462*/
/*************************Update File')                                 E23462*/
/************ADDLFM     FILE(MMFWDHLL) MBR(MMFWDHLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Forward Book Half Month Totals')  E23462*/
/************ADDLFM     FILE(MMFWDHL1) MBR(MMFWDHL1) SHARE(*YES) +      E23462*/
/***********************TEXT('DRS - Forward Book Half Month TotaL)S01149E23462*/
/************ADDLFM     FILE(MMFWDDL1) MBR(MMFWDDL1) SHARE(*YES) +      E23462*/
/***********************TEXT('DRS - Forward Book Half Month Total)S01149E23462*/
/************ADDLFM     FILE(MMFWUDLL) MBR(MMFWUDLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Forward Book Daily Deals Update + E23462*/
/*************************File')                                        E23462*/
/************ADDLFM     FILE(MMFWDDLL) MBR(MMFWDDLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Forward Book Daily Details')      E23462*/
/************ADDLFM     FILE(MMFNRULL) MBR(MMFNRULL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Near Dates Summary Update File')  E23462*/
/************ADDLFM     FILE(MMFNRDLL) MBR(MMFNRDLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Near Dates Summary')              E23462*/
/************ADDLFM     FILE(MMEPOULL) MBR(MMEPOULL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Position for Currency Update +    E23462*/
/*************************File')                                        E23462*/
/************ADDLFM     FILE(MMEPOSLL) MBR(MMEPOSLL) SHARE(*YES) +      E23462*/
/*************************TEXT('DRS - Position for Currency')           E23462*/
/*                                                                      E23462*/
/************ADDLFM*****FILE(MMFLQULL) MBR(MMFLQULL) SHARE(*YES) +
/**************TEXT('TS - Liquidity Exposure Update File') /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFLIQLL) MBR(MMFLIQLL) SHARE(*YES) +
/*************************TEXT('TS - Liquidity Exposures') /*E23462*/ /*S01319*/
             ADDLFM     FILE(MMFLQULL) MBR(MMFLQULL) +
                          TEXT('Midas Liquidity Exposure +
                          Update File') SHARE(*YES)                   /*S01319*/
             ADDLFM     FILE(MMFLIQLL) MBR(MMFLIQLL) +
                          TEXT('Midas Liquidity Exposures') +
                          SHARE(*YES)                                 /*S01319*/
/******      ADDLFM     FILE(MMCUEULL) MBR(MMCUEULL) SHARE(*YES) +
                          TEXT('TS - MM Customers Exposures Update +
                          File')                           /*E23462*/ /*S01319*/
/******      ADDLFM     FILE(MMCUEXLL) MBR(MMCUEXLL) SHARE(*YES) +
                          TEXT('TS - MM Customer Exposures'/*E23462*/ /*S01319*/
/******      ADDLFM     FILE(MMCEXELL) MBR(MMCEXELL) SHARE(*YES) +
                          TEXT('TS - Customer Exposures by Date for +
                          Enquiries')                      /*E23462*/ /*S01319*/
/******      ADDLFM     FILE(MMCUPULL) MBR(MMCUPULL) SHARE(*YES) +
                          TEXT('TS - MM Customer/Parent Data Update +
                          File')                           /*E23462*/ /*S01319*/
/******      ADDLFM     FILE(MMCUPALL) MBR(MMCUPALL) SHARE(*YES) +
                          TEXT('TS - MM Customer/Parent Dat/*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFWUTLL) MBR(MMFWUTLL) SHARE(*YES) +
/*************TEXT('TS - Forward Book Totals Update File') /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFWDTLL) MBR(MMFWDTLL) SHARE(*YES) +
/*************************TEXT('TS - Forward Book Totals') /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFWUHLL) MBR(MMFWUHLL) SHARE(*YES) +
/*************************TEXT('TS - Forward Book Half Month Totals +
/*************************Update File')                    /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFWDHLL) MBR(MMFWDHLL) SHARE(*YES) +
/**************TEXT('TS - Forward Book Half Month Totals') /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFWDHL1) MBR(MMFWDHL1) SHARE(*YES) +
/************TEXT('TS - Forward Book Half Month Totals')   /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFWDDL1) MBR(MMFWDDL1) SHARE(*YES) +
/************TEXT('TS - Forward Book Half Month Totals')   /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFWUDLL) MBR(MMFWUDLL) SHARE(*YES) +
/*************************TEXT('TS - Forward Book Daily Deals Update +
/*************************File')                           /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFWDDLL) MBR(MMFWDDLL) SHARE(*YES) +
/**************TEXT('TS - Forward Book Daily Details')     /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMFNRULL) MBR(MMFNRULL) SHARE(*YES) +
/***********************TEXT('TS - Near Dates Summary Update File')*/ /*S01319*/
/************ADDLFM*****FILE(MMFNRDLL) MBR(MMFNRDLL) SHARE(*YES) +
/*************************TEXT('TS - Near Dates Summary')  /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMEPOULL) MBR(MMEPOULL) SHARE(*YES) +
/*************************TEXT('TS - Position for Currency Update +
/*************************File')                           /*E23462*/ /*S01319*/
/************ADDLFM*****FILE(MMEPOSLL) MBR(MMEPOSLL) SHARE(*YES) +
/************************TEXT('TS - Position for Currency')/*E23462*/ /*S01319*/
             ADDLFM     FILE(MMFWUTLL) MBR(MMFWUTLL) +
                          TEXT('Midas Forward Book Totals +
                          Update File') SHARE(*YES)                   /*S01319*/
             ADDLFM     FILE(MMFWDTLL) MBR(MMFWDTLL) +
                          TEXT('Midas Forward Book Totals') +
                          SHARE(*YES)                                 /*S01319*/
             ADDLFM     FILE(MMFWUHLL) MBR(MMFWUHLL) +
                          TEXT('Midas Frwrd Bk Half Month +
                          Totals Update') SHARE(*YES)                 /*S01319*/
             ADDLFM     FILE(MMFWDHLL) MBR(MMFWDHLL) +
                          TEXT('Midas Forward Book Half +
                          Month Totals') SHARE(*YES)                  /*S01319*/
             ADDLFM     FILE(MMFWDHL1) MBR(MMFWDHL1) +
                          TEXT('Midas Forward Book Half +
                          Month Totals') SHARE(*YES)                  /*S01319*/
             ADDLFM     FILE(MMFWDDL1) MBR(MMFWDDL1) +
                          TEXT('Midas Forward Book Half +
                          Month Totals') SHARE(*YES)                  /*S01319*/
             ADDLFM     FILE(MMFWUDLL) MBR(MMFWUDLL) +
                          TEXT('Midas Forward Book Daily +
                          Deals Update') SHARE(*YES)                  /*S01319*/
             ADDLFM     FILE(MMFWDDLL) MBR(MMFWDDLL) +
                          TEXT('Midas Forward Book Daily +
                          Details') SHARE(*YES)                       /*S01319*/
             ADDLFM     FILE(MMFNRULL) MBR(MMFNRULL) +
                          TEXT('Midas Near Dates Summary +
                          Update File') SHARE(*YES)                   /*S01319*/
             ADDLFM     FILE(MMFNRDLL) MBR(MMFNRDLL) +
                          TEXT('Midas Near Dates Summary') +
                          SHARE(*YES)                                 /*S01319*/
             ADDLFM     FILE(MMEPOULL) MBR(MMEPOULL) +
                          TEXT('Midas Position for Currency +
                          Update File') SHARE(*YES)                   /*S01319*/
             ADDLFM     FILE(MMEPOSLL) MBR(MMEPOSLL) +
                          TEXT('Midas Position for +
                          Currency') SHARE(*YES)                      /*S01319*/
                                                                      /*S01280*/
             ADDLFM     FILE(DLFUTSLL) MBR(DLFUTSLL) TEXT('FF - +
                          Interest Rate Futures') SHARE(*YES)         /*S01280*/
/**/                                                                  /*E23462*/
/***IF*FIRST*TIME*ROUTINE*CALLED*DTAARA/MMSTAT*SET*TO*'Y'.*TAKE****/ /*058012*/
/** If component has not failed (i.e. this is not a restart) take */ /*058012*/
/*  BACKUPS OF DEALS AND DEAMS FILES IN CASE COMPONENT FAILS        */
             RTVDTAARA  DTAARA(MMSTAT) RTNVAR(&MSTAT)
             CHGVAR     VAR(&RECVR) VALUE(%SST(&MSTAT 1 1))
 
/************IF         COND(&RECVR *EQ 'Y') THEN(DO)             */ /*058012*/
             IF         COND(&RECVR *NE 'N') THEN(DO)                /*058012*/
/************CPYF       FROMFILE(MMDELDPP) TOFILE(ZZMMDELDPP) +
                          MBROPT(*REPLACE) */                         /*E22273*/
/************MONMSG CPF2817 */                                        /*E22273*/
/***************CPYF       FROMFILE(MMDENBPP) TOFILE(ZZMMDENBPP) +
                             MBROPT(*REPLACE) */                      /*E22273*/
/************MONMSG CPF2817 */                                        /*E22273*/
/***************CPYF       FROMFILE(MMDENSPP) TOFILE(ZZMMDENSPP) +
                             MBROPT(*REPLACE) */                      /*E22273*/
/************MONMSG CPF2817 */                                        /*E22273*/
/************CPYF       FROMFILE(MMDEAMPP) TOFILE(ZZMMDEAMPP) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK) */          /*E22273*/
/************MONMSG CPF2817 */                                        /*E22273*/
                                                                      /*E22273*/
             DLTF       FILE(ZZMMDELDPP)                              /*E22273*/
             MONMSG     MSGID(CPF2105)                                /*E22273*/
             DLTF       FILE(ZZMMDENBPP)                              /*E22273*/
             MONMSG     MSGID(CPF2105)                                /*E22273*/
             DLTF       FILE(ZZMMDENSPP)                              /*E22273*/
             MONMSG     MSGID(CPF2105)                                /*E22273*/
             DLTF       FILE(ZZMMDEAMPP)                              /*E22273*/
             MONMSG     MSGID(CPF2105)                                /*E22273*/
/*/COPY WNCPYSRC,MM8010001                                           */
                                                                                          /*CDL033*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
                DLTF       FILE(XDLFRSCPD)                                                /*CDL033*/
                MONMSG     MSGID(CPF2105)                                                 /*CDL033*/
                CRTDUPOBJ  OBJ(DLFRSCPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                             TOLIB(&DPLIB) NEWOBJ(XDLFRSCPD) DATA(*YES)                   /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                      /*E22273*/
/************CRTDUPOBJ  OBJ(MMDELDPP) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
/************    TOLIB(&DLIB) NEWOBJ(ZZMMDELDPP) DATA(*YES)/*E22273*/ /*S01337*/
             CRTDUPOBJ  OBJ(MMDELDPP) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(ZZMMDELDPP) DATA(*YES) /*E22273*/
/************CRTDUPOBJ  OBJ(MMDENBPP) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
/************    TOLIB(&DLIB) NEWOBJ(ZZMMDENBPP) DATA(*YES)/*E22273*/ /*S01337*/
             CRTDUPOBJ  OBJ(MMDENBPP) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(ZZMMDENBPP) DATA(*YES) /*S01337*/
/************CRTDUPOBJ  OBJ(MMDENSPP) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
/************    TOLIB(&DLIB) NEWOBJ(ZZMMDENSPP) DATA(*YES)/*E22273*/ /*S01337*/
             CRTDUPOBJ  OBJ(MMDENSPP) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(ZZMMDENSPP) DATA(*YES) /*S01337*/
/************CRTDUPOBJ  OBJ(MMDEAMPP) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
/************   TOLIB(&DLIB) NEWOBJ(ZZMMDEAMPP) DATA(*YES)  *E22273*/ /*S01337*/
             CRTDUPOBJ  OBJ(MMDEAMPP) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(ZZMMDEAMPP) DATA(*YES) /*S01337*/
/*/COPY WNCPYSRC,MM8010002                                           */
                                                                      /*E22273*/
             ENDDO
/**/
/*  IF LAST TIME ROUTINE CALLED ENDED IN ERROR DTAARA/MMSTAT WILL BE*/
/*  SET TO 'N'. RESTORE DEALS AND DEAMS FILES FROM BACKUP           */
/*  SET SWITCHES OFF AND RESET &TERM TO ' '                         */
             IF         COND(&RECVR *EQ 'N') THEN(DO)
             CPYF       FROMFILE(ZZMMDELDPP) TOFILE(MMDELDPP) +
                          MBROPT(*REPLACE)
/************MONMSG CPF2817 */                                        /*E22273*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             /*E22273*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)             /*E22273*/
                CPYF       FROMFILE(ZZMMDENBPP) TOFILE(MMDENBPP) +
                             MBROPT(*REPLACE)
/************MONMSG CPF2817 */                                        /*E22273*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             /*E22273*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)             /*E22273*/
                CPYF       FROMFILE(ZZMMDENSPP) TOFILE(MMDENSPP) +
                             MBROPT(*REPLACE)
/************MONMSG CPF2817 */                                        /*E22273*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             /*E22273*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)             /*E22273*/
/************CPYF       FROMFILE(ZZMMDEAMPP) TOFILE(MMDEAMPP) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK) */          /*E22273*/
/************MONMSG CPF2817 */                                        /*E22273*/
                CPYF       FROMFILE(ZZMMDEAMPP) TOFILE(MMDEAMPP) +
                          MBROPT(*REPLACE)                            /*E22273*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)             /*E22273*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)             /*E22273*/
/*/COPY WNCPYSRC,MM8010003                                           */
 
                IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                 /*CDL033*/
                   CPYF       FROMFILE(XDLFRSCPD) TOFILE(DLFRSCPD) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)                            /*CDL033*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(DLFRSCPD))                                           /*CDL033*/
                ENDDO                                                                     /*CDL033*/
                                                                                          /*CDL033*/
                CHGJOB     SWS(00000000)
                CHGVAR     VAR(&TERM) VALUE(' ')
             ENDDO
/**/
/*  CALL PROGRAM MM0101 TO REBUILD THE FILES                        */
/*  (MM0101 CONTAINS FRA AND IRS PERIOD DATE REBUILD AND SHOULD,        S01328*/
/*   THEREFORE, BE CALLED IF FRA/IRS ON - AT THE MOMENT IF FRA/IRS      S01328*/
/*   IS ON THEN MM WILL BE ON AND THIS PROGRAM CALLED.  IF THIS IS      S01328*/
/*   EVER CHANGED AND FRA/IRS CAN BE ON WITHOUT MM THEN THE PERIOD      S01328*/
/*   DATES (FOR MM TOO) WILL NEED TO BE REBUILT ELSEWHERE.)             S01328*/
/*/COPY WNCPYSRC,MM8010006                                           */
             CALL       PGM(MM0101) PARM(&TERM)
 
/*  CALL PROGRAM MM0101 AGAIN TO FREE THEM FROM THE STACK             S01145*/
/*  SO AB CAN ENDJRN ON FILES.                                        S01145*/
/*                                                    */  /*          E17654*/
/*           CODE BELOW WAS ALSO CHANGED FOR S01145   */  /*          E17654*/
/*                                                    */  /*          E17654*/
/*           CALL       PGM(MM0101) PARM('&TERM')     */  /*S01145    E17654*/
/*           CALL       PGM(MM0173) PARM('&TERM')     */  /*E90036    E17654*/
/*           CALL       PGM(MM0174) PARM('&TERM')     */  /*E90036    E17654*/
/*           CALL       PGM(MM0175) PARM('&TERM')     */  /*E90036    E17654*/
/*           OVRDBF FDICDRLL SHARE(*NO)               */  /*E90036    E17654*/
/*                                                    */  /*          E17654*/
/*           CODE ABOVE WAS ALSO CHANGED FOR S01145   */  /*          E17654*/
/*                                                    */  /*          E17654*/
/*           CALL       PGM(MM0194) PARM('&TERM')     */  /*E90036    E17654*/
/*           CALL       PGM(MM0073) PARM('T' ' ')          *S01145*  *E90036*/
/*           CALL       PGM(MM0074) PARM('T' ' ')          *S01145*  *E90036*/
/*           CALL       PGM(MM0075) PARM('T' ' ')          *S01145*  *E90036*/
/*           CALL       PGM(MM0094) PARM('T' ' ')          *S01145*  *E90036*/
/*           COMMIT                                        *S01145*  *E90036*/
 
/**/
/*  IF TERMINATION PARAMETER IS RETURNED WITH VALUE 'E', PERFORM    */
 
/**/
/*  IF TERMINATION PARAMETER IS RETURNED WITH VALUE ' ', CLEAR      */
/*  BACKUP FILES AND SET DTAARA/MMSTAT TO 'Y'                       */
             IF         COND(&TERM *EQ ' ') THEN(DO)
                CLRPFM     FILE(ZZMMDELDPP)
                CLRPFM     FILE(ZZMMDENBPP)
                CLRPFM     FILE(ZZMMDENSPP)
                CLRPFM     FILE(ZZMMDEAMPP)
/*/COPY WNCPYSRC,MM8010004                                           */
                                                                                          /*CDL033*/
                IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                 /*CDL033*/
                   DLTF       FILE(XDLFRSCPD)                                             /*CDL033*/
                   MONMSG     MSGID(CPF2105)                                              /*CDL033*/
                ENDDO                                                                     /*CDL033*/
                                                                                          /*CDL033*/
                CHGVAR     VAR(&MSTAT) VALUE('Y')
/**             SNDDTAARA  DTAARA(MMSTAT) **/                         /*AS/400*/
                CHGDTAARA  DTAARA(MMSTAT) VALUE(&MSTAT)
             ENDDO
 
/**/
/*  IF TERMINATION PARAMETER IS RETURNED WITH VALUE 'E', RESTORE    */
/*  DEALS AND DEAMS FILES TO THEIR PREVIOUS VALUES, SET DTAARA/     */
/*  MMSTAT TO 'N' AND SEND ERROR MESSAGES TO MSGQ/MOPERQ AND MRUNQ  */
             IF         COND(&TERM *EQ 'E') THEN(DO)
 
                CHGVAR     VAR(&MSTAT) VALUE('N')
                CHGDTAARA  DTAARA(MMSTAT) VALUE(&MSTAT)
 
                SNDPGMMSG  MSG('PROGRAM MM0101 ENDED IN ERROR') +
                             TOMSGQ(MRUNQ)
                SNDPGMMSG  MSG('PROGRAM MM0101 ENDED IN ERROR') +
                             TOMSGQ(MOPERQ)                 /*ME1436*/
/*   Indicate Failed job to Stream handler, CM0220    */    /*E14042*/
                CHGDTAARA  DTAARA(SDSTAT (101 1)) VALUE('X') /*E14042*/
                GOTO       ERROR                            /*E14042*/
             ENDDO
 
/*   RESTART JOURNALLING     */
             RCLRSC                                          /*E14259*/
/* ********* CALL **** SDC1730 ***********                  E14259   /*E14042*/
                                                                     /*E14042*/
/*   DECREMENT DRS JOB COUNTER ON SDSTAT */                          /*E14042*/
             RTVDTAARA  DTAARA(SDSTAT (100 1)) RTNVAR(&WWSUBNA)      /*E14042*/
             CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBNA)                 /*E14042*/
             CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBN-1)                /*E14042*/
             CHGVAR     VAR(&WWSUBNA) VALUE(&WWSUBN)                 /*E14042*/
             CHGDTAARA  DTAARA(SDSTAT (100 1)) VALUE(&WWSUBNA)       /*E14042*/
 
 END:        RETURN
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/*PROCESSING WHEN ERROR HAS OCCURRED                                */
 ERROR:      CHGJOB     SWS(XXXXX1XX)
             MONMSG     MSGID(CPF0000)
/************CHGDTAARA  DTAARA(*LDA (171 10)) VALUE('MM0101    ')    * *E27624*/
             CHGDTAARA  DTAARA(LDA (171 10)) VALUE('MM0101    ')      /*E27624*/
             MONMSG     MSGID(CPF0000)
/************CHGDTAARA  DTAARA(*LDA (181 3)) VALUE('001')            * *E27624*/
             CHGDTAARA  DTAARA(LDA (181 3)) VALUE('001')              /*E27624*/
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&TERM) VALUE('E')
/*   Decrement DRS job counter and send error message    */          /*E14042*/
             RTVDTAARA  DTAARA(SDSTAT (100 2)) RTNVAR(&WWSDSTAT)     /*E14042*/
             MONMSG      CPF0000                                     /*E14042*/
             CHGVAR     VAR(&WWSUBN) VALUE(%SST(&WWSDSTAT 1 1))      /*E14042*/
             MONMSG      CPF0000                                     /*E14042*/
             CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBN-1)                /*E14042*/
             MONMSG      CPF0000                                     /*E14042*/
             CHGVAR     VAR(%SST(&WWSDSTAT 1 1)) VALUE(&WWSUBN)      /*E14042*/
             MONMSG      CPF0000                                     /*E14042*/
             CHGVAR     VAR(%SST(&WWSDSTAT 2 1)) VALUE('X')          /*E14042*/
             MONMSG      CPF0000                                     /*E14042*/
             CHGDTAARA  DTAARA(SDSTAT (100 2)) VALUE(&WWSDSTAT)      /*E14042*/
             MONMSG      CPF0000                                     /*E14042*/
             SNDMSG     MSG('MM8010 has ended abnormally in batch.') +
                          TOMSGQ(MOPERQ)                             /*E14042*/
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             ENDPGM
 
