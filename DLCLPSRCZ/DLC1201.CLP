/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Interest and deals this month report')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1201 - INTEREST & DEALS THIS MONTH REPORT &              */
/*                 CREATE FRESH DEALS FILE MONTHLY                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CDL098             Date 06Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG7956            Date 12Jul05              */
/*                      228542             Date 05Aug04              */
/*                      CLE025             Date 20Oct03              */
/*                      CDL012             Date 19Aug03              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CIR003             Date 13Sep00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      126469             Date 14Jan98              */
/*                      104174             DATE 02APR97             */
/*                      116284             DATE 02APR97              */
/*                      115998             DATE 25MAR97              */
/*                      114906             DATE 06MAR97              */
/*                      S01408             DATE 20NOV96              */
/*                      110242             DATE 07NOV96              */
/*                      S01408             DATE 11OCT96              */
/*                      S01408             DATE 16AUG96              */
/*                      S01408             DATE 20MAY96              */
/*                      099144             DATE 30APR96              */
/*                      088630             DATE 14JUN95              */
/*                      S01408             DATE 11MAY95              */
/*                      S01444             DATE 11APR95              */
/*                      074471             DATE 23FEB94              */
/*                      059223             DATE 27JAN94              */
/*                      048933             DATE 19MAR93              */
/*                      048932             DATE 19MAR93              */
/*                      AUS019             DATE 20AUG92              */
/*                      S01319             DATE 09OCT91              */
/*                      E27942             DATE 03SEP91              */
/*                      E23806             DATE 04OCT90              */
/*                      E23407             DATE 13SEP90              */
/*                      S01189             DATE 25/04/89             */
/*                      S01117             DATE 25/04/89             */
/*                      S01194             DATE 25/04/89             */
/*                      S01179             DATE 14/09/88             */
/*                      S01145             DATE 01/12/87             */
/*                      S01133             DATE 01/04/87             */
/*                      ME1057             DATE 25/02/87             */
/*                      S01125             DATE 13/11/86             */
/*                      F00100             DATE 27/08/86             */
/*                      REORGANISE DEBTORS DEALS FILE.               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CDL098 - Cancelled Deal Numbers                             */
/*       BUG7956 - FOOB in DLC1201                                   */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CLE025 - Credit Lines                                       */
/*       CDL012 - Interest Statements for Call/Time Deposits.        */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CIR003 - Principal Exchange on Cross-Ccy IRS.               */
/*       CCB009 - Journal files throughout close of business         */
/*       126469 - Submitted jobs DLC0606BR1 and BR2 always lock      */
/*                each other out as they are reorganising DEALS*     */
/*                files which share the same access path. Fix is     */
/*                to replace these programs with a new component     */
/*                DLC0609 to reorganise the deals files efficiently. */
/*       104174 - MMDELULL access path cannot be maintained. OPNDBF  */
/*                MMDELULL to rebuild access path before calling     */
/*                DL1070.                                            */
/*       116284 - Condition the Reorganize processing to prevent     */
/*                looping.                                           */
/*       115998 - Delete RGZOBJ data area before creation to prevent */
/*                looping.                                           */
/*                Also, change SBMJOBs to specify a job description. */
/*       114906 - Do not submit DLC0606BR2 until DLC0606BR1          */
/*                has completed to avoid record locking.             */
/*       S01408 - Core hook DLC1201009 added                         */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       S01408 - Core hook DLC1201008 added                         */
/*       S01408 - Core hook DLC1201007 adeed.                        */
/*                Core hook DLC1201006 added.                        */
/*                Core hook DLC1201005 added.                        */
/*                Core hook DLC1201004 added.                        */
/*       S01408 - Core hook DLC1201001 adeed.                        */
/*                Core hook DLC1201002 added.                        */
/*                Core hook DLC1201003 added.                        */
/*       099144 - Increase file and record wait time to avoid        */
/*                locking problems.                                  */
/*       088630 - Fix 074471 incomplete. Program always removes      */
/*                journal changes even if it is a normal end.        */
/*       S01408 - Addition of core hook DLC1201MP1                   */
/*                Addition of core hook DLC1201MP2                   */
/*                Addition of core hook DLC1201MP3                   */
/*       S01444 - Historic deals files added to recovery processing  */
/*       074471 - Pgm should do ABNOR processing (and not reset     */
/*                Restart flag) if an error occurs.                 */
/*       059223 - File reorganisation is too slow especially if      */
/*                done everyday.  So, reorganize DEALS files only    */
/*                during month-end.                                  */
/*       048933 - RESTART RECOVERY PROCESSING REWRITE                */
/*       048932 - THIS REPORT IS MANDATORY AND IS AVAILABLE AS       */
/*                A BRANCH REPORT ONLY. IT IS NO NEED TO CODE        */
/*                FOR SYSTEM AND COMPANY REPORTS. AUS019 WHICH       */
/*                INTRODUCES TWO NEW TYPES OF REPORTS (ONE FOR FX    */
/*                DEALS AND ONE FOR MM DEALS AS WELL THE EXISTING    */
/*                ONE FOR ALL DEALS) HAS BEEN INCORPORATED IN A      */
/*                POOR WAY. THIS FIX GETS THE BUGGER WORKING.        */
/*       AUS019 - AUSTRALIAN CONVERSION - FX/MM DEALS THIS MONTH     */
/*                BY CUSTOMER                                        */
/*       S01319 - Remove redundant processing                        */
/*       E27942 - FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A       */
/*                LEVEL OF BLANKS                                    */
/*       E23806 - REMOVE CALL TO NON-EXISTANT PROGRAM                */
/*       E23407 - CHECK FOR MODULES RE(RETAIL 2 - MMOD POSITION      */
/*                16) OR IA(INTEREST ON ACCOUNTS - MMOD POSITION     */
/*                23), RATHER THAN RT(RETAIL 1 - MMOD POSITION       */
/*                3).                                                */
/*       S01189 - COB recovery processing.                           */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01194 - STANDING DATA CHANGES.                             */
/*       S01179 - AS400 CONVERSION                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
/************PGM                                                      /*S01117*/
/************PGM PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)         /*S01117* *AUS019*/
/**********  PGM PARM(&TYPE &CNAM &CSEQ &RSEQ &RLEV &RENT)   *AUS019*  *048932*/
             PGM PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)                  /*048932*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**********  DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) +
                        VALUE('JOB TERMINATED - DATABASE ERROR')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) +
                        VALUE('FILE CONTROLS OUT OF BALANCE')
/************DCL        VAR(&DLMFU) TYPE(*CHAR) LEN(3)                /*S01189*/
/************DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256) /*S01179*/  /*S01189*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
/************DCL********VAR(&MMOD)*TYPE(*CHAR)*LEN(256)**/ /*S01179*/ /*S01319*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)              /*059223*/
             DCL        VAR(&RGZ) TYPE(*CHAR) LEN(2)                 /*059223*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CIR003*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CIR003*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CIR003*/
             DCL        VAR(&CIR003) TYPE(*CHAR) LEN(1)                                   /*CIR003*/
             DCL        VAR(&CDL012) TYPE(*CHAR) LEN(1)                                   /*CDL012*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1)                                   /*CLE025*/
             DCL        VAR(&CDL098) TYPE(*CHAR) LEN(1)                                   /*CDL098*/
/* */                                                                 /*AUS019*/
/** NEW PARAMETER: DEAL TYPE SELECTION (FX, MM OR BLANKS FOR BOTH) */ /*AUS019*/
/* */                                                                 /*AUS019*/
/**DCL*VAR(&TYPE)*TYPE(*CHAR)*LEN(2)***                        /*AUS019 074471*/
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
   DCL VAR(&SYSID) TYPE(*CHAR) LEN(2)                                 /*048933*/
   DCL VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')                  /*048933*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*                                                                      CCB009*/
/* Declare job name, user and number for remove journal changes         CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,DLC1201008                                          /*S01408*/
/*                                                                   /*S01408*/
/**/                                                                  /*048933*/
  
/**/
/********    DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
/********    DCLDTAARA  DTAARA(MMOD)                                    S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                                     S01179*/
/**/
/*********   RCVDTAARA  DTAARA(MMOD)                                    S01179*/
/************RTVDTAARA**DTAARA(MMOD)*RTNVAR(&MMOD)***********S01179*/ /*S01319*/
             DCLF       FILE(SDMMODL1)                                /*S01319*/
                                                                      /*074471*/
/* Global Monitor Message */                                          /*074471*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*074471*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CIR003*/
             CHGVAR     VAR(&SARD) VALUE('CIR003')                                        /*CIR003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &AOFMT)                      /*CIR003*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CIR003) VALUE('Y'))                                        /*CIR003*/
                                                                                          /*CLE025*/
/** Check if enhancement CLE025 (Credit Lines) is on */                                   /*CLE025*/
                                                                                          /*CLE025*/
             CHGVAR     VAR(&RTCD) VALUE(' ')                                             /*CLE025*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE025*/
             CHGVAR     VAR(&SARD) VALUE('CLE025')                                        /*CLE025*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &AOFMT)                      /*CLE025*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE025) VALUE('Y'))                                        /*CLE025*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve current job attributes.                                     CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
             ENDDO                                                    /*CCB009*/
                                                                                          /*CDL012*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CDL012*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL012*/
             CHGVAR     VAR(&SARD) VALUE('CDL012')                                        /*CDL012*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &AOFMT)                      /*CDL012*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL012) VALUE('Y'))                                        /*CDL012*/
                                                                      /*074471*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           /*048933*/
             CHGVAR     VAR(&TOLIB) VALUE(&SYSID *TCAT 'DPLIB')      /*059223*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC1201MP2                                          */
                                                                      /*S01408*/
/**/
/*      INTEREST THIS MONTH                                         */
/**/
             CHGJOB     SWS(00000000)
             SNDMSG     MSG('Interest this month extract') +
                          TOMSGQ(MRUNQ)
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*048933*/
/*   IF RESTART, REMOVE JOURNALLED CHANGES   */                       /*048933*/
             IF         COND(&STAT *NE 'N') THEN(DO)                  /*048933*/
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                              CCB009*/
/*                                                                      CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)
/*                                                                      CCB009*/
/* If data area is not blank, calculate the job name, user and number   CCB009*/
/* of the previous run of this component.                               CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/*                                                                      CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10)) +
                                                                      /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6)) +
                                                                      /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of job.                                      CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/*/COPY WNCPYSRC,DLH00227                                            */
             RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (BKRATAA) +
                          (DEALSDB) (DEALSDC) (DEALSDD) (DEALSDE) +
                          (DEALSDF) (DEALSDG) (DLBHISPD) (DLCHISPD) +
                          (DLDHISPD) (DLEHISPD) (DLGHISPD)) +
                          RCVRNG(*CURRENT) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
/*/COPY WNCPYSRC,DLH00228                                            */
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
/*/COPY WNCPYSRC,DLC1201022                                          */
             IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                    /*CIR003*/
                 RMVJRNCHG  JRN(ICJRN) FILE(DLGXSTPD) +
                   RCVRNG(*CURRENT) FROMENT(&START) TOENT(&FINISH)                        /*CIR003*/
                 MONMSG  MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                           /*CIR003*/
             ENDDO                                                                        /*CIR003*/
                                                                                          /*CLE025*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                    /*CLE025*/
                RMVJRNCHG  JRN(ICJRN) FILE((DLDLDBQD) (DLDLDCQD) +
                             (DLDLDGQD)) FROMENT(&START) +
                             TOENT(&FINISH)                                               /*CLE025*/
                MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                         /*CLE025*/
             ENDDO                                                                        /*CLE025*/
                                                                                          /*CLE025*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*/COPY WNCPYSRC,DLC1201013                                          */
                CHKOBJ     OBJ(JRDLC1201) OBJTYPE(*JRNRCV)            /*048933*/
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV)) /*048933*/
                CHKOBJ     OBJ(JDLC1201) OBJTYPE(*JRN)                /*048933*/
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))    /*048933*/
/***********    RMVJRNCHG  JRN(JDLC1201) FILE((ACCNTAB) (BKRATAA) +   /*S01444*/
/***********               (DEALSDB) (DEALSDC) (DEALSDD) (DEALSDE) +  /*S01444*/
/***********               (DEALSDF) (DEALSDG))             */ /*048933 S01444*/
/*/COPY WNCPYSRC,DLC1201020                                          */
                RMVJRNCHG  JRN(JDLC1201) FILE((ACCNTAB) (BKRATAA) +
                           (DEALSDB) (DEALSDC) (DEALSDD) (DEALSDE) +
                           (DEALSDF) (DEALSDG) (DLBHISPD) (DLCHISPD) +
                           (DLDHISPD) (DLEHISPD) (DLGHISPD))          /*S01444*/
/*/COPY WNCPYSRC,DLH00229                                            */
                MONMSG     (CPF7042 CPF7049)                          /*048933*/
/*/COPY WNCPYSRC,DLH00234                                            */
                IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                 /*CIR003*/
                     RMVJRNCHG  JRN(JDLC1201) FILE(DLGXSTPD)                              /*CIR003*/
                     MONMSG     MSGID(CPF7042 CPF7049)                                    /*CIR003*/
                ENDDO                                                                     /*CIR003*/
                                                                                          /*CLE025*/
                IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                 /*CLE025*/
                   RMVJRNCHG  JRN(JDLC1201) FILE((DLDLDBQD) (DLDLDCQD) +
                                (DLDLDGQD))                                               /*CLE025*/
                   MONMSG     MSGID(CPF7042 CPF7049)                                      /*CLE025*/
                ENDDO                                                                     /*CLE025*/
                                                                                          /*CLE025*/
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,DLC1201004                                          /*S01408*/
/*                                                                   /*S01408*/
                ENDJRNPF   FILE(*ALL) JRN(JDLC1201)                   /*048933*/
                MONMSG     MSGID(CPF7032)                             /*048933*/
                DLTJRN     JRN(JDLC1201)                              /*048933*/
NOJRN:          CHGJOB     INQMSGRPY(*DFT)                            /*048933*/
                DLTJRNRCV  JRNRCV(JRDLC1201)                          /*048933*/
                CHGJOB     INQMSGRPY(*RQD)                            /*048933*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,DLC1201014                                          */
NOJRNRCV:       CHGVAR VAR(&STAT) VALUE('N')                          /*048933*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        /*048933*/
/**/                                                                  /*048933*/
             ENDDO                                                    /*048933*/
/*   CREATE JOURNAL & RECEIVER   */                                   /*048933*/
/**/                                                                  /*048933*/
             CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)      /*048933*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC1201MP1                                          */
                                                                      /*S01408*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             CRTJRNRCV  JRNRCV(&JLIB/JRDLC1201)                       /*048933*/
             CRTJRN     JRN(&JLIB/JDLC1201) JRNRCV(&JLIB/JRDLC1201) +
                                                                      /*048933*/
/*********** STRJRNPF   FILE(ACCNTAB BKRATAA DEALSDB DEALSDC DEALSDD +/*S01444*/
/***********              DEALSDE DEALSDF DEALSDG) JRN(JDLC1201) +    /*S01444*/
/***********              IMAGES(*BOTH) OMTJRNE(*OPNCLO)  */   /*048933 S01444*/
/*/COPY WNCPYSRC,DLC1201021                                          */
             STRJRNPF   FILE(ACCNTAB BKRATAA DEALSDB DEALSDC DEALSDD +
                          DEALSDE DEALSDF DEALSDG DLBHISPD DLCHISPD +
                          DLDHISPD DLEHISPD DLGHISPD) JRN(JDLC1201) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)              /*S01444*/
/*/COPY WNCPYSRC,DLH00230                                            */
             MONMSG     MSGID(CPF7030)                                /*048933*/
/*/COPY WNCPYSRC,DLC1201024                                          */
             IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                    /*CIR003*/
                 STRJRNPF  FILE(DLGXSTPD) JRN(JDLC1201) IMAGES(*BOTH) +
                           OMTJRNE(*OPNCLO)                                               /*CIR003*/
                 MONMSG    MSGID(CPF7030)                                                 /*CIR003*/
             ENDDO                                                                        /*CIR003*/
                                                                                          /*CLE025*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                    /*CLE025*/
                STRJRNPF   FILE(DLDLDBQD DLDLDCQD DLDLDGQD) +
                             JRN(JDLC1201) IMAGES(*BOTH) OMTJRNE(*OPNCLO)                 /*CLE025*/
                MONMSG     MSGID(CPF7030)                                                 /*CLE025*/
             ENDDO                                                                        /*CLE025*/
                                                                                          /*CLE025*/
             ENDDO                                                    /*CCB009*/
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,DLC1201005                                          /*S01408*/
/*                                                                   /*S01408*/
/**/                                                                  /*048933*/
                CHGVAR     VAR(&STAT) VALUE('Y')                      /*048933*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        /*048933*/
/**/                                                                  /*048933*/
             CLRPFM     FILE(IREXDHH)
             CLRPFM     FILE(IREXDIC)
             CLRPFM     FILE(IREXDZZ)
/*********** OVRDBF     FILE(TABLE)  TOFILE(TABDLEE)                  /*S01194*/
             OVRDBF     FILE(DEALS2) TOFILE(DEALS) SHARE(*NO)
/**/
             CALL       PGM(DL1000)
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)
                SNDMSG     MSG(&MSG1)  TOMSGQ(MOPERQ)
                GOTO       END
             ENDDO
/**/                                                                  /*048933*/
             IF         COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)   /*048933*/
                SNDMSG     MSG(&MSG2)  TOMSGQ(MOPERQ)                 /*048933*/
                GOTO       END                                        /*048933*/
             ENDDO       /*048933*/
/**/                                                                  /*048933*/

/**/
             IF         COND(%SUBSTRING(&SWS 6 1) *NE '1') THEN(DO)
/**/
/***************IF         COND(%SUBSTRING(&MMOD 3 1) = 'Y') THEN(DO)   E23407*/
/***FOLLOWING LINE INSERTED FOR E80432 - TO CHECK ON EXISTENCE OF RT MODE23407*/
/****************IF         COND(%SUBSTRING(&MMOD 16 1) = 'N') THEN(DO) E23407*/
/**/
/************IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
/*************************(%SUBSTRING(&MMOD 16 1) = 'Y')) THEN(DO)    /*E23806*/
/**/
/******************CALL       PGM(RTC85)                                E23806*/
/******************RTVJOBA    SWS(&SWS)                                 E23806*/
/**/
/******************IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)23806*/
/*********************SNDMSG     MSG(&MSG1) TOMSGQ(MOPERQ)              E23806*/
/*********************GOTO       END                                    E23806*/
/******************ENDDO                                                E23806*/
/**/
/******************IF         COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)23806*/
/*********************SNDMSG     MSG(&MSG2) TOMSGQ(MOPERQ)              E23806*/
/*********************GOTO       END                                    E23806*/
/******************ENDDO                                                E23806*/
/**/
/************ENDDO                                                E23407E23806*/
/**/
/************** OVRDBF     FILE(TABLE)  TOFILE(TABDLEE)               /*S01194*/
                SNDMSG     MSG('Interest this month report') TOMSGQ(MRUNQ)
/************** CALL       PGM(DL1030)                                /*S01117*/
/*/COPY WNCPYSRC,DLC1201010                                          */
                CALL       PGM(DL1030) PARM(&RSEQ &RENT)              /*S01117*/
/*/COPY WNCPYSRC,DLC1201011                                          */
                RTVJOBA    SWS(&SWS)
/**/
                IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)
                   SNDMSG     MSG(&MSG1)  TOMSGQ(MOPERQ)
                   GOTO       END
                ENDDO
/**/
                IF         COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)
                   SNDMSG     MSG(&MSG2)  TOMSGQ(MOPERQ)
                   GOTO       END
                ENDDO
/**/
             ENDDO
/**/
/*      DEALS THIS MONTH                                           */
/**/
             CLRPFM     FILE(EVDCMHH)
             CLRPFM     FILE(EVDCMED)
             CLRPFM     FILE(EVDCMZZ)
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,DLC1201001                                          /*S01408*/
/*                                                                   /*S01408*/
             SNDMSG     MSG('Deals by customer this month extract') +
                        TOMSGQ(MRUNQ)
             CHGJOB     SWS(00000000)
             CALL       PGM(DL1040)
/*/COPY WNCPYSRC,DLC1201019                                          */
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)
                SNDMSG     MSG(&MSG1)  TOMSGQ(MOPERQ)
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,DLC1201002                                          /*S01408*/
/*                                                                   /*S01408*/
                GOTO       END
             ENDDO
/**/
             IF       COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)
                      SNDMSG     MSG(&MSG2) TOMSGQ(MOPERQ)
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,DLC1201003                                          /*S01408*/
/*                                                                   /*S01408*/
                      GOTO       END
             ENDDO
/**/
             IF         COND(%SUBSTRING(&SWS 6 1) *NE '1') THEN(DO)
/**/
                SNDMSG     MSG('Deals by customer this month report')         +
                           TOMSGQ(MRUNQ)
/************** CALL       PGM(DL1060)                                /*S01117*/

/***REPORT*BY*SYSTEM***/                                  /*S01117*/  /*048932*/
/************IF    COND(&RLEV *EQ 'S') THEN(CALL PGM(DL1060)) *S01117* *E27942*/
/************IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
/************             THEN(CALL PGM(DL1060) PARM(&RSEQ)) /*E27942* *AUS019*/
/**********  IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +       /*048932*/
/**********     THEN(CALL PGM(DL1060) PARM(&TYPE &RSEQ))   /*AUS019*/ /*048932*/
/**********                                                /*S01117*/ /*048932*/
/***REPORT*BY*BRANCH***/                                  /*S01117*/  /*048932*/
/************IF         COND(&RLEV *EQ 'B') THEN(CALL PGM(DL1061) +
/************           PARM(&RSEQ &RENT))                   /*S01117* *AUS019*/
/**********  IF    COND(&RLEV *EQ 'B') THEN(CALL PGM(DL1061 +         /*048932*/
/**********             PARM(&TYPE &RSEQ &RENT))           /*AUS019*/ /*048932*/
/**********                                                /*S01117*/ /*048932*/
/***REPORT*BY*COMPANY**/                                   /*S01117*/ /*048932*/
/************IF         COND(&RLEV *EQ 'C') THEN(CALL PGM(DL1062) +
/************           PARM(&RSEQ &RENT))                   /*S01117* *AUS019*/
/**********  IF  COND(&RLEV *EQ 'C') THEN(CALL PGM(DL1062) +          /*048932*/
/**********             PARM(&TYPE &RSEQ &RENT))           /*AUS019*/ /*048932*/
/**********                                                /*S01117*/ /*048932*/
/* THIS REPORT IS MANDAROTY AND THUS NEED NOT BE CALLED WITH ANY PARMS. 048932*/
/* HOWEVER, IT IS AVAILABLE BY ALL DEALS, FX DEALS AND MM DEALS AND     048932*/
/* THAT IS THERE ARE THREE CALLS IN THIS PROGRAM.                       048932*/
/*  REPORT FOR FX DEALS ONLY                                            048932*/
            CALL PGM(DL1061) PARM('FX' '     ' 'ALL')                 /*048932*/
/*  REPORT FOR ALL DEALS                                                048932*/
            CALL PGM(DL1061) PARM('  ' '     ' 'ALL')                 /*048932*/
/*  REPORT FOR MM DEALS ONLY                                            048932*/
            CALL PGM(DL1061) PARM('MM' '     ' 'ALL')                 /*048932*/
                RTVJOBA    SWS(&SWS)
/**/
                IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)
                   SNDMSG     MSG(&MSG1)  TOMSGQ(MOPERQ)
                   GOTO       END
                ENDDO
/**/
                IF         COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)
                   SNDMSG     MSG(&MSG2)  TOMSGQ(MOPERQ)
                   GOTO       END
                ENDDO
/**/
             ENDDO
/**/
/*      CREATE NEW DEALS FILE                                      */
/**/
/************IF         COND(%SUBSTRING(&SWS 6 1) *NE '1') THEN(DO)   /*048933*/
/**/
/*           RCVDTAARA DTAARA(DLSTAT)                                   S01179*/
/************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)    /*S01179*/  /*S01189*/
/************CHGVAR    VAR(&DLMFU)  VALUE(%SUBSTRING(&DLSTAT 17 3))   /*S01189*/
/************CHGVAR     VAR(&STAT) VALUE(' ')                 /*S01189**048933*/
/************CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)   /*S01189**048933*/
/**/
/************IF      COND(&DLMFU = OLD)  THEN(DO)*/                   /*S01189*/
/************IF      COND(&STAT *EQ 'N')  THEN(DO)             /*S01189**SSSSS*/
/**/
                SNDMSG    MSG('Create new Deals file')  TOMSGQ(MRUNQ)
/*********      CLRPFM    FILE(NEWDLDA)      */
/*********      CLRPFM    FILE(NEWDLDB)      */
/*********      CLRPFM    FILE(NEWDLDC)      */
/*********      CLRPFM    FILE(NEWDLDD)      */
/*********      CLRPFM    FILE(NEWDLDE)      */
/*********      CLRPFM    FILE(NEWDLDF)      */
/**/                                                                  /*104174*/
                OPNDBF    FILE(MMDELULL) OPTION(*INP) MBR(MMDELULL) +
                          ACCPTH(*FILE)                               /*104174*/
                MONMSG    MSGID(CPF0000)                              /*104174*/
                CLOF      OPNID(MMDELULL)                             /*104174*/
                MONMSG    MSGID(CPF0000)                              /*104174*/
/**/                                                                  /*104174*/
                CALL      PGM(DL1070)
/*/COPY WNCPYSRC,DLC1201012                                          */
                RTVJOBA   SWS(&SWS)
/**/
                IF        COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)
                   SNDMSG     MSG(&MSG1)  TOMSGQ(MOPERQ)
                   GOTO       END
                ENDDO
/**/
             IF       COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)
                      SNDMSG     MSG(&MSG2) TOMSGQ(MOPERQ)
                      GOTO       END
             ENDDO
/**/                                                                                      /*CDL098*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CDL098*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL098*/
             CHGVAR     VAR(&SARD) VALUE('CDL098')                                        /*CDL098*/
             CHGVAR     VAR(&CDL098) VALUE('N')                                           /*CDL098*/
/**  Check if Enhancement is installed */                                                 /*CDL098*/
                                                                                          /*CDL098*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &AOFMT)                      /*CDL098*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR VAR(&CDL098) +
                          VALUE('Y'))                                                     /*CDL098*/
/**/                                                                                      /*CDL098*/
             IF         COND(&CDL098 *EQ 'Y') THEN(DO)                                    /*CDL098*/
/**/                                                                                      /*CDL098*/
                SNDMSG     MSG('Remove old cancelled deals') TOMSGQ(MRUNQ)                /*CDL098*/
/**/                                                                                      /*CDL098*/
                CALL       PGM(DL000110)                                                  /*CDL098*/
                RTVJOBA    SWS(&SWS)                                                      /*CDL098*/
/**/                                                                                      /*CDL098*/
                IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)                    /*CDL098*/
                   SNDMSG     MSG(&MSG1)  TOMSGQ(MOPERQ)                                  /*CDL098*/
                   GOTO       END                                                         /*CDL098*/
                ENDDO                                                                     /*CDL098*/
/**/                                                                                      /*CDL098*/
                IF         COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)                    /*CDL098*/
                   SNDMSG     MSG(&MSG2) TOMSGQ(MOPERQ)                                   /*CDL098*/
                   GOTO       END                                                         /*CDL098*/
                ENDDO                                                                     /*CDL098*/
/**/                                                                                      /*CDL098*/
             ENDDO                                                                        /*CDL098*/
                                                                                          /*CDL012*/
             IF         COND(&CDL012 *EQ 'Y') THEN(DO)                                    /*CDL012*/
/**********      RGZPFM     FILE(DLTCSTPD)                                     /*CDL012*/ /*228542*/
/**********      MONMSG     MSGID(CPF2981)                                     /*CDL012*/ /*228542*/
             CALL       PGM(SCC000060) PARM('DLTCSTPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
             ENDDO                                                                        /*CDL012*/
                                                                                          /*CDL012*/
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,DLC1201006                                          /*S01408*/
/*                                                                   /*S01408*/
/**/
/***************ALCOBJ     OBJ((DLSTAT  *DTAARA  *EXCL))              /*S01189*/
/********       RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
/***************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT) /*S01179*/  /*S01189*/
/***************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3))  VALUE(NEW)  /*S01189*/
/********       SNDDTAARA  DTAARA(DLSTAT)                               S01179*/
/***************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)  /*S01179*/  /*S01189*/
/***************DLCOBJ     OBJ((DLSTAT  *DTAARA  *EXCL))*/            /*S01189*/
/***************CHGVAR     VAR(&STAT) VALUE('Y')              /*S01189**048933*/
/***************CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)/*S01189**048933*/
/**/
/************ENDDO                                                    /*048933*/
/**/
/*******     RCVDTAARA  DTAARA(DLSTAT)                                  S01179*/
/************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                /*S01179*/
/************CHGVAR     VAR(&DLMFU)  VALUE(%SUBSTRING(&DLSTAT 17 3))  /*S01189*/
/************CHGVAR     VAR(&STAT) VALUE(' ')                 /*S01189**048933*/
/************CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)   /*S01189**048933*/
/**/
/************IF         COND(&DLMFU = NEW) THEN(DO)                   /*S01189*/
/************IF         COND(&STAT *EQ 'Y') THEN(DO)          /*S01189**048933*/
/**/
/**********     CLRPFM     FILE(DEALSDA)      */
/**********     CLRPFM     FILE(DEALSDB)      */
/**********     CLRPFM     FILE(DEALSDC)      */
/**********     CLRPFM     FILE(DEALSDD)      */
/*********      CLRPFM     FILE(DEALSDE)      */
/*********      CLRPFM     FILE(DEALSDF)      */
/**/
/**********     CPYF       FROMFILE(NEWDLDA) TOFILE(DEALSDA)    */             +
/**********                MBROPT(*REPLACE) FMTOPT(*NOCHK)      */
/**********     MONMSG     MSGID(CPF2817)                       */
/**********     CPYF       FROMFILE(NEWDLDB) TOFILE(DEALSDB)    */             +
/**********                MBROPT(*REPLACE) FMTOPT(*NOCHK)      */
/**********     MONMSG     MSGID(CPF2817)                       */
/**********     CPYF       FROMFILE(NEWDLDC) TOFILE(DEALSDC)    */             +
/**********                MBROPT(*REPLACE) FMTOPT(*NOCHK)      */
/**********     MONMSG     MSGID(CPF2817)                       */
/**********     CPYF       FROMFILE(NEWDLDD) TOFILE(DEALSDD)    */             +
/**********                MBROPT(*REPLACE) FMTOPT(*NOCHK)      */
/**********     MONMSG     MSGID(CPF2817)                       */
/**********     CPYF       FROMFILE(NEWDLDE) TOFILE(DEALSDE)    */             +
/**********                MBROPT(*REPLACE) FMTOPT(*NOCHK)      */
/*********      MONMSG     MSGID(CPF2817)                       */
/*********      CPYF       FROMFILE(NEWDLDF) TOFILE(DEALSDF)    */             +
/*********                 MBROPT(*REPLACE) FMTOPT(*NOCHK)      */
/*********      MONMSG     MSGID(CPF2817)                       */
/**/
/***************ALCOBJ     OBJ((DLSTAT  *DTAARA  *EXCL))*/            /*S01189*/
/*********      RCVDTAARA  DTAARA(DLSTAT)                               S01179*/
/***************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT) /*S01179*/  /*S01189*/
/***************CHGVAR     VAR(%SUBSTRING(&DLSTAT 17 3))  VALUE(OLD)  /*S01189*/
/*********      SNDDTAARA  DTAARA(DLSTAT)                               S01179*/
/***************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)  /*S01179*/  /*S01189*/
/***************DLCOBJ     OBJ((DLSTAT  *DTAARA  *EXCL))              /*S01189*/
/***************CHGVAR     VAR(&STAT) VALUE('N')              /*S01189**048933*/
/***************CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)/*S01189**048933*/
/**/
/************ENDDO                                                    /*048933*/
/**/
/*********   CLRPFM     FILE(NEWDLDA)    */
/*********   CLRPFM     FILE(NEWDLDB)    */
/*********   CLRPFM     FILE(NEWDLDC)    */
/*********   CLRPFM     FILE(NEWDLDD)    */
/*********   CLRPFM     FILE(NEWDLDE)    */
/*********   CLRPFM     FILE(NEWDLDF)    */
/**/
/************ENDDO                                                    /*048933*/
/**/
 /**/                                                                 /*048933*/
/************CHGVAR     VAR(&STAT) VALUE('N')                  /*048933 074471*/
/************CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)    /*048933 074471*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*088630*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*088630*/
 /**/                                                                 /*048933*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC1201009                                           /*S01408*/
/**/                                                                  /*S01408*/
             GOTO       CMDLBL(END)                                   /*074471*/
/*ABNOR:***                                                      */               /*074471 BUG7956*/
/**********  CHGJOB     SWS(XXXXXX11)                            */               /*074471 BUG7956*/
/**********  MONMSG     MSGID(CPF0000)                           */               /*116284 BUG7956*/
 /**/                                                                 /*074471*/
/*ND:********CHGVAR*****VAR(&STAT) VALUE(' ')                         /*074471*/
 END:                                                                 /*074471*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*074471*/
             MONMSG     MSGID(CPF0000)                                /*116284*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*048933*/
             MONMSG     MSGID(CPF0000)                                /*116284*/
             IF         COND(&STAT *EQ 'Y') THEN(DO)                  /*048933*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/***********    RMVJRNCHG  JRN(JDLC1201) FILE((ACCNTAB) (BKRATAA) +   /*S01444*/
/***********              (DEALSDB) (DEALSDC) (DEALSDD) (DEALSDE) +   /*S01444*/
/***********              (DEALSDF) (DEALSDG))              */ /*048933 S01444*/
/*/COPY WNCPYSRC,DLC1201015                                          */
                RMVJRNCHG  JRN(JDLC1201) FILE((ACCNTAB) (BKRATAA) +
                          (DEALSDB) (DEALSDC) (DEALSDD) (DEALSDE) +
                          (DEALSDF) (DEALSDG) (DLBHISPD) (DLCHISPD) +
                          (DLDHISPD) (DLEHISPD) (DLGHISPD))           /*S01444*/
/*/COPY WNCPYSRC,DLH00231                                            */
/***********    MONMSG     (CPF7042 CPF7049)                   /*048933 116284*/
             MONMSG     MSGID(CPF0000)                                /*116284*/
/*/COPY WNCPYSRC,DLC1201025                                          */
                IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                 /*CIR003*/
                     RMVJRNCHG  JRN(JDLC1201) FILE(DLGXSTPD)                              /*CIR003*/
                     MONMSG     MSGID(CPF0000)                                            /*CIR003*/
                ENDDO                                                                     /*CIR003*/
                                                                                          /*CLE025*/
                IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                 /*CLE025*/
                   RMVJRNCHG  JRN(JDLC1201) FILE((DLDLDBQD) (DLDLDCQD) +
                                (DLDLDGQD))                                               /*CLE025*/
                   MONMSG     MSGID(CPF0000)                                              /*CLE025*/
                ENDDO                                                                     /*CLE025*/
                                                                                          /*CLE025*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve attributes of current job.                                 CCB009*/
/*                                                                      CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
/*                                                                      CCB009*/
/*  Retrieve the most recent journal entry sequence number              CCB009*/
/*  for the specific job.                                               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/*                                                                      CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/***********************************************************************CCB009**************CSC020*/
/***Retrieve*the*first*journal*entry*sequence*number********************CCB009**************CSC020*/
/***for*the*specific*job.***********************************************CCB009**************CSC020*/
/***********************************************************************CCB009**************CSC020*/
/************RTVJRNE****JRN(ICJRN)*RCVRNG(*CURCHAIN)*FROMENT(*FIRST)*+**********************CSC020*/
/*************************TOENT(*LAST)*SEARCH(*ASCEND)*+************************************CSC020*/
/*************************JOB(&CCB009NBR/&CCB009USR/&CCB009JOB)*+***************************CSC020*/
/*************************RTNSEQNBR(&FINISH)****************************CCB009**************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of current job.                              CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/*                                                                      CCB009*/
/*  Remove journaled changes.                                           CCB009*/
/*                                                                      CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/*/COPY WNCPYSRC,DLH00232                                            */
             RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (BKRATAA) +
                          (DEALSDB) (DEALSDC) (DEALSDD) (DEALSDE) +
                          (DEALSDF) (DEALSDG) (DLBHISPD) (DLCHISPD) +
                          (DLDHISPD) (DLEHISPD) (DLGHISPD)) +
                          RCVRNG(*CURRENT) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
/*/COPY WNCPYSRC,DLH00233                                            */
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
/*/COPY WNCPYSRC,DLC1201023                                          */
             IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                    /*CIR003*/
                 RMVJRNCHG  JRN(ICJRN) FILE(DLGXSTPD) +
                   RCVRNG(*CURRENT) FROMENT(&START) TOENT(&FINISH)                        /*CIR003*/
                 MONMSG  MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                           /*CIR003*/
             ENDDO                                                                        /*CIR003*/
                                                                                          /*CLE025*/
             IF         COND(&CLE025 *EQ 'Y') THEN(DO)                                    /*CLE025*/
                RMVJRNCHG  JRN(ICJRN) FILE((DLDLDBQD) (DLDLDCQD) +
                          (DLDLDGQD)) FROMENT(&START) +
                          TOENT(&FINISH)                                                  /*CLE025*/
                MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                         /*CLE025*/
             ENDDO                                                                        /*CLE025*/
                                                                                          /*CLE025*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*                                                                   /*S01408*/
/*/COPY WNCPYSRC,DLC1201007                                          /*S01408*/
/*                                                                   /*S01408*/
             ENDDO                                                    /*048933*/
/*/COPY WNCPYSRC,DLC1201016                                          */
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JDLC1201)                      /*048933*/
/*********** MONMSG     MSGID(CPF7032)                         /*048933 116284*/
             MONMSG     MSGID(CPF0000)                                /*116284*/
             IF         COND(&STAT *EQ 'N') THEN(DO)                  /*088630*/
             DLTJRN     JRN(JDLC1201)                                 /*048933*/
             MONMSG     MSGID(CPF0000)                                /*116284*/
             CHGJOB     INQMSGRPY(*DFT)                               /*048933*/
             MONMSG     MSGID(CPF0000)                                /*116284*/
             DLTJRNRCV  JRNRCV(JRDLC1201)                             /*048933*/
             MONMSG     MSGID(CPF0000)                                /*116284*/
             CHGJOB     INQMSGRPY(*RQD)                               /*048933*/
             MONMSG     MSGID(CPF0000)                                /*116284*/
             ENDDO                                                    /*088630*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,DLC1201017                                          */
/*********** CHGVAR     VAR(&STAT) VALUE('N')               /*048933*  *088630*/
/*********** CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT) /*048933*  *088630*/
/*******REORGANISE*DEALS*FILE*FOR*DRS*                   *  *F00100*/ /*S01319*/
/*      REORGANISE DEALS FILES                                      * /*S01319*/
/*      But only reorganize if this is NOT an Abnormal Ending.        /*116284*/
             RTVJOBA    SWS(&SWS)                                                        /*BUG7956*/
             MONMSG     MSGID(CPF0000)                                                   /*BUG7956*/
             IF         COND(%SUBSTRING(&SWS 7 2) *NE '11') THEN(DO)  /*116284*/
/**/                                                                  /*F00100*/
             RCVF       RCDFMT(@BGREC8)                               /*S01319*/
/****IF*******COND(%SUBSTRING(&MMOD*13*1)*=*'Y')*THEN(DO)***F00100*/  /*S01319*/
                   CALL       PGM(FX0760)                             /*F00100*/
             OVRDBF     FILE(MMDENBPP) TOFILE(*LIBL/MMDENBPP) +
                          WAITFILE(180) WAITRCD(180)                  /*099144*/
/****************ENDDO**************************************F00100*/ /*S01319*/
/****IF*******COND(%SUBSTRING(&MMOD*14*1)*=*'Y')*THEN(DO)***ME1057*/ /*S01319*/
                   CALL       PGM(MM0063)                             /*ME1057*/
             DLTOVR     FILE(*ALL)                                    /*099144*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC1201MP3                                          */
                                                                      /*S01408*/
/****************ENDDO**************************************ME1057*/  /*S01319*/
/****IF*******COND(%SUBSTRING(&MMOD*19*1)*=*'Y')*THEN(DO)***S01145*/  /*S01319*/
             IF         COND(&BGINCN = 'Y') THEN(DO)                  /*S01319*/
                   CALL       PGM(AB0160)                             /*S01145*/
                 ENDDO                                                /*S01145*/
/* */                                                                 /*059223*/
/*  Reorganise of DEALS* files now done in component DLC0609           *126469*/
/*/                                                                    *126469*/
/***REORGANISE THE DEALS FILES IN BATCH JOBS                */ /*059223 126469*/
/***********                                                       */ /*126469*/
/***********CRTDTAARA  DTAARA(&TOLIB/RGZJOB) TYPE(*CHAR) LEN(2)/*059223 115998*/
/***********                                                   /*115998 126469*/
/*********** DLTDTAARA  DTAARA(&TOLIB/RGZJOB)                  /*115998 126469*/
/*********** MONMSG     MSGID(CPF2105)                         /*115998 126469*/
/*********** CRTDTAARA  DTAARA(&TOLIB/RGZJOB) TYPE(*CHAR) LEN(2) +
/***********  TEXT('Control of DLC0606BR* jobs - created by DLC120115998126469*/
/***********                                                          /*115998*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BR1)) JOB(DLC0606BR1) +   /*110242*/
/***********                 JOBQ(MEODQ) RTGDTA(MBATCH) */ /*059223     110242*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BR2)) JOB(DLC0606BR2) +   /*110242*/
/***********                 JOBQ(MEODQ) RTGDTA(MBATCH) */ /*059223     110242*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BR1)) JOB(DLC0606BR1) +   /*115998*/
/***********        (MEODQ) RTGDTA(MBATCH) INLLIBL(*JOBD)  /*110242*/ /*115998*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BR1)) JOB(DLC0606BR1) +
/***********    JOBD(MEODD) JOBQ(MEODQ) RTGDTA(MBATCH) INLLIBL(*J115998 126469*/
/*LOOPRG:*** DLYJOB     DLY(60)                                /*114906 126469*/
/*********** RTVDTAARA  DTAARA(&TOLIB/RGZJOB) RTNVAR(&RGZ)     /*114906 126469*/
/*********** IF         COND(&RGZ *NE 'N ') THEN(GOTO +
/***********                 CMDLBL(LOOPRG))                   /*114906 126469*/
/***********                                                           *126469*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BR2)) JOB(DLC0606BR2) +
/***********     JOBQ(MEODQ) RTGDTA(MBATCH) INLLIBL(*JOBD) /*110242*/ /*115998*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BR2)) JOB(DLC0606BR2) +    *126469*/
/***********    JOBD(MEODD) JOBQ(MEODQ) RTGDTA(MBATCH) INLLIBL(*JOBD) /*115998*/
/***********                                                           *126469*/
/***LOOP*UNTIL ALL SUBMITTED JOBS ARE COMPLETED             */ /*059223 126469*/
/***********                                                   /*059223 126469*/
/*RGZFIN:*** DLYJOB     DLY(60)                                /*059223 126469*/
/*********** RTVDTAARA  DTAARA(&TOLIB/RGZJOB) RTNVAR(&RGZ)     /*059223 126469*/
/*********** IF         COND(&RGZ *NE 'NN') THEN(GOTO +               /*126469*/
/***********                 CMDLBL(RGZFIN))                   /*059223 126469*/
/*********** DLTDTAARA  DTAARA(&TOLIB/RGZJOB)                  /*059223 126469*/
/*      End of Reorganize Deals Files                                 /*116284*/
             ENDDO                                                    /*116284*/
/* */                                                                /*059223*/
                                                                                         /*BUG7956*/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)                      /*BUG7956*/
                        GOTO MEM                                                         /*BUG7956*/
                        ENDDO                                                            /*BUG7956*/
             IF         COND(%SUBSTRING(&SWS 8 1) *EQ '1') THEN(DO)                      /*BUG7956*/
                        GOTO END2                                                        /*BUG7956*/
                        ENDDO                                                            /*BUG7956*/
             GOTO       CMDLBL(END2)                                                     /*BUG7956*/
ABNOR:                                                                                   /*BUG7956*/
             CHGJOB     SWS(XXXXXX11)                                                    /*BUG7956*/
             MONMSG     MSGID(CPF0000)                                                   /*BUG7956*/
                                                                                         /*BUG7956*/
/**END:******                                                         /*048933*/
MEM:                                                                                     /*BUG7956*/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') THEN(DO)
/*******                RCVDTAARA DTAARA(LDA)                           S01179*/
                        RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)           /*S01179*/
/********               CHGVAR VAR(%SUBSTRING(&MEM 1 10)) +           /*S01117*/
/********               VALUE(%SUBSTRING(&LDA 168 10))                /*S01117*/
/********               CHGVAR VAR(%SUBSTRING(&MEM 11 34)) +          /*S01117*/
/********               VALUE(%SUBSTRING(&LDA 134 34))                /*S01117*/
                 CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))  /*S01117*/
/*******                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +        /*S01117*/
                        SNDPGMMSG MSGID(MEM0011) MSGF(MIDAS) +
                        MSGDTA(&MEM) TOPGMQ(*EXT)
             ENDDO
/**/
/*/COPY WNCPYSRC,DLC1201018                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             RETURN                                                                       /*CSC020*/
/**********  ENDPGM                                                 */                   /*BUG7956*/
END2:        ENDPGM                                                                      /*BUG7956*/
