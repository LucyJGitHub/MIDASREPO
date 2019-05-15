/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Pay/receive telexes')                        */
/********************************************************************/
/*                                                                  */
/*       Midas - Securities Trading Module                          */
/*                                                                  */
/*       SEC0603 - PAY/RECEIVE TELEXES                              */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4.01.01 --------------------------------------------*/
/*                      CSW202             Date 20May02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025             Date 06Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      183583             Date 25Jun01              */
/*                      CSE029             Date 24Jul01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE017             Date 20Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      094335             Date 17Jan96              */
/*                      096837             DATE 04DEC95             */
/*                      S01408             DATE 11MAY95             */
/*                      067702             DATE 04MAR94             */
/*                      066209             DATE 26JAN94             */
/*                      S01401             DATE 16JUN93             */
/*                      043856             DATE 26AUG92             */
/*                      E40242             DATE 19JUN92             */
/*                      S01386             DATE 20MAY92             */
/*                      E34903             DATE 04FEB92             */
/*                      E33162             DATE 11DEC91             */
/*                      E32848             DATE 04DEC91             */
/*                      E30842             DATE 30OCT91             */
/*                      S01117             DATE 07JAN91             */
/*                      S01189             DATE 07JAN91             */
/*                      S01271             DATE 08JUN90             */
/*                      E22974             DATE 27SEP90             */
/*                      E23408             DATE 06SEP90             */
/*                      E21096             DATE 16MAR90             *   E21096*/
/*                      S01251             DATE 03FEB90             */
/*                      E20321             DATE 29NOV89             */
/*                      E19955             DATE 03NOV89             */
/*                      S17216             DATE 12OCT89             */
/*                      E19753             DATE 12OCT89             */
/*                      S01190             DATE 10/07/89            */
/*                      S01179             DATE 22/10/88            */
/*                      S01176             DATE 20/10/88            */
/*                      E14849             DATE 22/09/88            */
/*                      S01170             DATE 12/07/88            */
/*                      S01175             DATE 01/07/88            *   S01175*/
/*                      S01129             DATE 05/04/88            *   S01175*/
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CSW202 - SWIFT 2002 Standards Update                        */
/*       CSW025 - Midas Message Manager                             */
/*     183583 - Journal PF/MGOEXTPD.                                */
/*     CSE029 - ISO15022 messages generation                        */
/*       CDL008 - Continuous Linked Settlement                      */
/*       CCB009 - Journal files throughout close of business         */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set    */
/*                to CMTSCOPE(*JOB).                                */
/*     094335 - Process all cancellation in a first run.            */
/*     096837 - MG0521 calls MG0590 and MG5910 which both open      */
/*              TRADSDY1 and DPTMVDY4 under commitment control -    */
/*              this means that both these files must have separate */
/*              Open Data Paths. These files must be opened         */
/*              SHARE(*NO).                                         */
/*            - DPTMVDX1 should be journalled to SETEMPJRN          */
/*     S01408 - Addition of core hook SEC0603MP1                    */
/*              Addition of core hook SEC0603MPS                    */
/*     067702 - Need to journal file TRADSDX1 in order to recover   */
/*              for restart.                                        */
/*     066209 - RECOVERY PROBLEMS: Clear Message Management inter-  */
/*              mediary files.                                      */
/*       S01401 - Generate S.W.I.F.T. Settlement Messages if MT5xx  */
/*                Feature switched on.                              */
/*     043856  - OVRDBF TRADS TO SHARE(*NO) FOR CMTCTL IN MG9205    */
/*     E40242  -  Produce an audit report for                       */
/*                S.W.I.F.T. message generation                     */
/*     S01386  -  S.W.I.F.T. Pay/Receives enhancements              */
/*     E34903 - SETLXD,SETLXA,OTHSTD and OTHSTA should be cleared   */
/*              on successful completion                            */
/*     E33162 - Security copies of Euclid files are spelt wrong     */
/*     E32848 - Security copies of TRADSD,DPTMVD and ATPRPD need to */
/*              be deleted at the end of the program                */
/*     E30842 - Only de-allocate SWIFT dataarea MSMERG if SWIFT used*/
/*     S01117 - MULTIBRANCHING                                      */
/*     S01189 - CLOSE OF BUSINESS IMPROVEMENTS PHASE 2              *   S01189*/
/*     S01271 - PAY/RECEIVE IN INPUT CYCLE - INITIAL EXTRACT        */
/*              CREATION FOR CLOSE OF BUSINESS NOW DONE BY SE3315   */
/*              AND SE3325.  DO NOT CLEAR SETLXD, SETLXA, OTHSTA,   */
/*              AND OTHSTD IN CASE OF FAILURE WITHOUT SUBSEQUENT    */
/*              RESTART DURING I/C.  AS PAY/RECEIVE PROCESS NOW     */
/*              UPDATES TRADSD AND DPTMVD AND NEW FILE ATPRPD,      */
/*              SECURITY COPIES ARE NOW TAKEN.                      */
/*     E22974 - SDMMODL0 should be used in preference to MMOD and   */
/*              the dealing indicator need not be checked. SE0421   */
/*              needs two parameters passed. Redundant code removed.*/
/*     E23408 - SETON U1 IF RETAIL II OR INTEREST ON ACCOUNTS       */
/*              INSTALLED.  RETAIL 1 NOT SUPPORTED ON ABS.          */
/*     E21096 - PROCESSING TO ALLOW AMENDMENTS AND CANCELLATIONS    *   E21096*/
/*              OF SWIFT MESSAGES BY USING MSIXA FOR REFERENCE.     *   E21096*/
/*              PREVIOUSLY MSIXOSE/MSMSOSE WERE USED BUT THESE      *   E21096*/
/*              ARE CLEARED BEFORE USE, WHICH RESULTS IN NO         *   E21096*/
/*              MESSAGES BEING FOUND, AND NO AMENDMENT/DELETION     *   E21096*/
/*              PROCESSING.                                         *   E21096*/
/*     S01251 - SYNON FLIELD/PROGRAM NAME CHANGES                    */
/*     E20321 - SE1810 Swift Messages should run conditionally.   *    *E20321*/
/*     E19955 - COPY FILE SHOULD MONITOR FOR EMPTY FROM FILE      *    *E19955*/
/*     S17216 - RE DESIGN TO STOP LOCK OUT OF MSIXOPF & MSMSOPF   *    *S17216*/
/*     E19753 - CLRPFM OF REDUNDANT FILES                         *    *S01190*/
/*     S01190 - EUCLID FIXEX/ENHANCEMENTS                         *    *S01190*/
/*     S01179 - ABS INCORPORATION                                 *    *S01179*/
/*     S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                *    *S01176*/
/*                (ALSO SOME TIDYING OF CODE)                     *    *S01176*/
/*     E14849 - HALT EOD STREAM IF ABNORMAL TERMINATION           *    *E14849*/
/*     S01170 - INCLUSION OF SWIFT INTERFACE PROGRAM SE1810       *    *S01170*/
/*     S01175 - EUCLID                                            *    *S01175*/
/********************************************************************  *S01175*/
/*                                                                   * *S01175*/
/********    PGM                                                      /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)                  /*S01189*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 /*S01189*/
/************DCLDTAARA  DTAARA(MMOD)                               */ /*S01179*/
/************DCLDTAARA  DTAARA(LDA)                                */ /*S01179*/
/************DCLDTAARA  DTAARA(SDSTAT)                  */ /*S01129*/ /*S01179*/
/************DCL        VAR(&MMOD)    TYPE(*CHAR)  LEN(256)       S01179E22974*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)           /*S01179*/
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01117*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)      /*S01117*/ /*S01401*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(70)                 /*S01401*/
             DCL        VAR(&EUPB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EUTX) TYPE(*CHAR) LEN(1)                 /*S01271*/
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01129*/
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)                 /*S01386*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01129*/
/************DCL        VAR(&MSFCTL) TYPE(*CHAR) LEN(256)* /*E21096*/ /*S01386*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCLF       FILE(SDMMODL0)                                /*E20321*/
             DCL        VAR(&COBIND) TYPE(*CHAR) LEN(1)               /*S01271*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')  /*S01117*/
/*/COPY WNCPYSRC,SEC0603007                                          */
             DCL (&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')               /*S01401*/
/*/COPY WNCPYSRC,SEC0603004                                          */
             DCL (&S01401) TYPE(*CHAR) LEN(1) VALUE(' ')              /*S01401*/
             DCL (&CSE029) TYPE(*CHAR) LEN(1) VALUE(' ')              /*CSE029*/
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
                                                                                          /*CSW202*/
             DCL        VAR(&CSW202) TYPE(*CHAR) LEN(1)                                   /*CSW202*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
                                                                                          /*CSW202*/
/*/COPY WNCPYSRC,SEC0603003                                          */
                                                                      /*S01129*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERROR)   /*E14849*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/*           RCVDTAARA DTAARA(SDSTAT)                     *  *S01129*  *S01179*/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)                 /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01129*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01129 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
             CHGVAR    VAR(&JLIB) VALUE(&PRE *CAT 'JLIB')             /*CCB009*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0603MPS                                          */
                                                                      /*S01408*/
                                                                      /*S01129*/
/*   SET COB PARAMETER */                                             /*S01271*/
       CHGVAR VAR(&COBIND) VALUE('C')                                 /*S01271*/
 
/************MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERROR) /*  E14849*/
/* SEND PGM MESSAGE */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0603 - Pay/Receive +
                          Telexes')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)  MSGTYPE(*INFO)
             RCVF                                                     /*E22974*/
/************MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ERROR3))****/ /*S01386*/
                                                           /*E22974*/ /*S01386*/
                                                                      /*S01401*/
/***  Access Switchable Features file to see if MT5XX present  ***/   /*S01401*/
                                                                      /*S01401*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'S01401')          /*S01401*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&S01401) VALUE('Y'))        /*S01401*/
/* */                                                                 /*CSE029*/
/***  Access Switchable Features file to see if ISO15022 generation   /*CSE029*/
/***  present.  */                                                    /*CSE029*/
                                                                      /*CSE029*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSE029')          /*CSE029*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSE029) VALUE('Y'))        /*CSE029*/
                                                                                          /*CSW202*/
/* Check if SWIFT 2002 is installed */                                                    /*CSW202*/
                                                                                          /*CSW202*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSW202*/
             CHGVAR     VAR(&CSW202) VALUE('N')                                           /*CSW202*/
             CALL       PGM(SWIF2002) PARM(&PRTCD)                                        /*CSW202*/
             IF         COND(&PRTCD *EQ 'CSW2002') THEN(DO)                               /*CSW202*/
                CHGVAR  VAR(&CSW202) VALUE('Y')                                           /*CSW202*/
             ENDDO                                                                        /*CSW202*/
                                                                      /*CSE029*/
/*/COPY WNCPYSRC,SEC0603016                                          */
                                                                      /*S01401*/
  /*   IF SE0420 FAILED DURING PAY/RECEIVES IN INPUT CYCLE AND IT */ /*S01271*/
  /*   WAS NOT RERUN THEN USE BACK-UP COPIES OF EUCLID FILES      */ /*S01271*/
                                                                     /*S01271*/
       RTVDTAARA  DTAARA(SESTAT (75 1)) RTNVAR(&EUTX)                /*S01271*/
       IF COND(&EUTX = 'Y') THEN(DO)                                 /*S01271*/
 
/*********CPYF    FROMFILE(XSEUCH) TOFILE(SEEUCH)  +             S01271 E33162*/
          CPYF    FROMFILE(XSEEUCH) TOFILE(SEEUCH)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)                     /*S01271*/
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCH)                                /*S01271*/
/*********CPYF    FROMFILE(XSEUCD0) TOFILE(SEEUCD0)  +           S01271 E33162*/
          CPYF    FROMFILE(XSEEUCD0) TOFILE(SEEUCD0)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)                     /*S01271*/
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD0)                               /*S01271*/
/*********CPYF    FROMFILE(XSEUCD1) TOFILE(SEEUCD1)  +           S01271 E33162*/
          CPYF    FROMFILE(XSEEUCD1) TOFILE(SEEUCD1)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)                     /*S01271*/
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD1)                               /*S01271*/
/*********CPYF    FROMFILE(XSEUCD2) TOFILE(SEEUCD2)  +           S01271 E33162*/
          CPYF    FROMFILE(XSEEUCD2) TOFILE(SEEUCD2)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)                     /*S01271*/
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD2)                               /*S01271*/
/*********CPYF    FROMFILE(XSEUCD3) TOFILE(SEEUCD3)  +           S01271 E33162*/
          CPYF    FROMFILE(XSEEUCD3) TOFILE(SEEUCD3)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)                     /*S01271*/
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD3)                               /*S01271*/
/*********CPYF    FROMFILE(XSEUCD4) TOFILE(SEEUCD4)  +           S01271 E33162*/
          CPYF    FROMFILE(XSEEUCD4) TOFILE(SEEUCD4)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)                     /*S01271*/
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD4)                               /*S01271*/
/*********CPYF    FROMFILE(XSEUCD5) TOFILE(SEEUCD5)  +           S01271 E33162*/
          CPYF    FROMFILE(XSEEUCD5) TOFILE(SEEUCD5)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)                     /*S01271*/
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCD5)                               /*S01271*/
/*********CPYF    FROMFILE(XSEUCA) TOFILE(SEEUCA)  +             S01271 E33162*/
          CPYF    FROMFILE(XSEEUCA) TOFILE(SEEUCA)  +
                  MBROPT(*REPLACE) FMTOPT(*NONE)                     /*S01271*/
          MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                  EXEC(CLRPFM SEEUCA)                                /*S01271*/
          CHGDTAARA  DTAARA(SESTAT (75 1)) VALUE('N')                /*S01271*/
       ENDDO                                                         /*S01271*/
       ELSE CMD(DO)                                                  /*S01271*/
                                                                     /*S01271*/
/* IF TRANSMISSION FAILED IN INPUT CYCLE & WAS NOT RE-ATTEMPTED,  */
/*  THEN MUST USE BACKUP OF SEEUC TAKEN DURING I/C.               */ /*S01271*/
                                                                     /*S01271*/
/***THEN*MUST*USE BACKUP*OF*ECTLX*TAKEN*DURING*I/C.****************/ /*S01271*/
                                                                     /*S01271*/
             RTVDTAARA  DTAARA(SESTAT (51 1)) RTNVAR(&EUPB)
             IF         COND(&EUPB = '1') THEN(DO)
/*****          CPYF       FROMFILE(ECTLSHH) TOFILE(ECTLXHH)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01175*/
/*****          CPYF       FROMFILE(ECTLSL0) TOFILE(ECTLXL0)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01175*/
/*****          CPYF       FROMFILE(ECTLSL1) TOFILE(ECTLXL1)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01175*/
/*****          CPYF       FROMFILE(ECTLSL2) TOFILE(ECTLXL2)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01175*/
/*****          CPYF       FROMFILE(ECTLSL9) TOFILE(ECTLXL9)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01175*/
                CPYF       FROMFILE(SSEUCH) TOFILE(SEEUCH)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01175*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCH)                           /*E19955*/
                CPYF       FROMFILE(SSEUCD0) TOFILE(SEEUCD0)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01175*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD0)                          /*E19955*/
                CPYF       FROMFILE(SSEUCD1) TOFILE(SEEUCD1)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01175*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD1)                          /*E19955*/
                CPYF       FROMFILE(SSEUCD2) TOFILE(SEEUCD2)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01175*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD2)                          /*E19955*/
                CPYF       FROMFILE(SSEUCD3) TOFILE(SEEUCD3)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01190*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD3)                          /*E19955*/
                CPYF       FROMFILE(SSEUCD4) TOFILE(SEEUCD4)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01190*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD4)                          /*E19955*/
                CPYF       FROMFILE(SSEUCD5) TOFILE(SEEUCD5)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01190*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD5)                          /*E19955*/
                CPYF       FROMFILE(SSEUCA) TOFILE(SEEUCA)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01175*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCA)                           /*E19955*/
/***************CHGDTAARA  DTAARA(STSTAT (51 1)) VALUE('0')            *E14849*/
                CHGDTAARA  DTAARA(SESTAT (51 1)) VALUE('0')           /*E14849*/
             ENDDO
          ENDDO                                                      /*S01271*/
/**/
/* CHECK FOR COMPONENT RESTART                                      */
 
/********    RTVDTAARA  DTAARA(SESTAT (1 3)) RTNVAR(&BUSY)            /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE(' ')                         /*S01189*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/********    IF COND(&BUSY = 'NEW') THEN(DO)                          /*S01189*/
             IF         COND(&BUSY = 'Y') THEN(DO)                    /*S01189*/
 
/*****          CPYF       FROMFILE(XCTLXHH) TOFILE(ECTLXHH)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01175*/
/****           MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM ECTLXHH)                        *  *S01175*/
 /*****         CPYF       FROMFILE(XCTLXL0) TOFILE(ECTLXL0)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)         */  /*S01175*/
 /*****         MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM ECTLXL0)                      */  /*S01175*/
 /*****         CPYF       FROMFILE(XCTLXL1) TOFILE(ECTLXL1)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)         */  /*S01175*/
 /*****         MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM ECTLXL1)                      */  /*S01175*/
 /*****         CPYF       FROMFILE(XCTLXL2) TOFILE(ECTLXL2)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)         */  /*S01175*/
 /*****         MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM ECTLXL2)                      */  /*S01175*/
 /*****         CPYF       FROMFILE(XCTLXL9) TOFILE(ECTLXL9)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)         */  /*S01175*/
 /*****         MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM ECTLXL9)                      */  /*S01175*/
                CPYF       FROMFILE(XSEEUCH) TOFILE(SEEUCH)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCH)
                CPYF       FROMFILE(XSEEUCD0) TOFILE(SEEUCD0)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD0)
                CPYF       FROMFILE(XSEEUCD1) TOFILE(SEEUCD1)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD1)
                CPYF       FROMFILE(XSEEUCD2) TOFILE(SEEUCD2)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD2)
                CPYF       FROMFILE(XSEEUCD3) TOFILE(SEEUCD3)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01190*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD3)                          /*S01190*/
                CPYF       FROMFILE(XSEEUCD4) TOFILE(SEEUCD4)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01190*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD4)                          /*S01190*/
                CPYF       FROMFILE(XSEEUCD5) TOFILE(SEEUCD5)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01190*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD5)                          /*S01190*/
                CPYF       FROMFILE(XSEEUCA) TOFILE(SEEUCA)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCA)
                CPYF       FROMFILE(XOTHSTD) TOFILE(OTHSTD)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01176*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM OTHSTD)                           /*S01176*/
                CPYF       FROMFILE(XOTHSTA) TOFILE(OTHSTA)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01176*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM OTHSTA)                           /*S01176*/
                CPYF       FROMFILE(XSETLXD) TOFILE(SETLXD)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01271*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SETLXD)                           /*S01271*/
                CPYF       FROMFILE(XSETLXA) TOFILE(SETLXA)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01271*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SETLXA)                           /*S01271*/
/* Remove security copy as file is recovered through journalling   */ /*CCB009*/
/***************CPYF       FROMFILE(XTRADSD) TOFILE(TRADSD) + ******/ /*CCB009*/
/***************           MBROPT(*REPLACE) FMTOPT(*NONE)  /*S01271*/ /*CCB009*/
/***************MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +      ******/ /*CCB009*/
/***************        EXEC(CLRPFM TRADSD)                /*S01271*/ /*CCB009*/
                CPYF       FROMFILE(XBTCHNAB) TOFILE(BTCHNAB) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM BTCHNAB)                          /*CCB009*/
                CPYF       FROMFILE(XDPTMVDX1) TOFILE(DPTMVDX1) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM DPTMVDX1)                         /*CCB009*/
                CPYF       FROMFILE(XMGJREFPD) TOFILE(MGJREFPD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM MGJREFPD)                         /*CCB009*/
                CPYF       FROMFILE(XATPRPD) TOFILE(ATPRPD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01271*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM ATPRPD)                           /*S01271*/
                CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*S01271*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM DPTMVD)                           /*S01271*/
 
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),       */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/**/                                                                  /*CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                         */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)      /*CCB009*/
/**/                                                                  /*CCB009*/
/* If data area is not blank, calculate the job name, user and no. */ /*CCB009*/
/* of the previous run of this component.                             /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/**/                                                                  /*CCB009*/
             CHGVAR     VAR(&CCB009JOB) VALUE(%SST(&CB0180DA 1 10))   /*CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10))  /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6))   /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/**/                                                                  /*CCB009*/
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
/**/                                                                  /*CCB009*/
/*  Remove journaled changes.                                      */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/*/COPY WNCPYSRC,SEC0603024                                          */
             RMVJRNCHG  JRN(ICJRN) FILE((TRADSD) (MGOREFPD) +
                          (MGOMSGPD) (TRADSDX1)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
/*/COPY WNCPYSRC,SEC0603022                                          */
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)        /*CCB009*/
/*/COPY WNCPYSRC,SEC0603026                                          */
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
             RMVJRNCHG  JRN(JSEC0603) FILE((TRADSD) (MGOREFPD) +
                          (MGOMSGPD) (TRADSDX1))                      /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB009*/
             ENDDO                                                    /*CCB009*/
/* CHANGE DATA AREA                     */
 
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')           /*S01189*/
                CHGVAR     VAR(&BUSY) VALUE('N')                      /*S01189*/
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)             /*S01189*/
 
             ENDDO
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
/*              DLTF       FILE(XCTLXHH)           */       /*S01129*  *S01175*/
/*                 MONMSG MSGID(CPF0000)           */       /*S01129*  *S01175*/
/*              DLTF       FILE(XCTLXL0)           */       /*S01129*  *S01175*/
/*                 MONMSG MSGID(CPF0000)           */       /*S01129*  *S01175*/
/*              DLTF       FILE(XCTLXL1)           */       /*S01129*  *S01175*/
/*                 MONMSG MSGID(CPF0000)           */       /*S01129*  *S01175*/
/*              DLTF       FILE(XCTLXL2)           */       /*S01129*  *S01175*/
/*                 MONMSG MSGID(CPF0000)           */       /*S01129*  *S01175*/
/*              DLTF       FILE(XCTLXL9)           */       /*S01129*  *S01175*/
/*                 MONMSG MSGID(CPF0000)           */       /*S01129*  *S01175*/
                DLTF       FILE(XSEEUCH)                    /*S01129*  *S01175*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEEUCD0)                             /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEEUCD1)                             /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEEUCD2)                             /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEEUCD3)                             /*S01190*/
                   MONMSG MSGID(CPF0000)                              /*S01190*/
                DLTF       FILE(XSEEUCD4)                             /*S01190*/
                   MONMSG MSGID(CPF0000)                              /*S01190*/
                DLTF       FILE(XSEEUCD5)                             /*S01190*/
                   MONMSG MSGID(CPF0000)                              /*S01190*/
                DLTF       FILE(XSEEUCA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XOTHSTD)                              /*S01176*/
                   MONMSG MSGID(CPF0000)                              /*S01176*/
                DLTF       FILE(XOTHSTA)                              /*S01176*/
                   MONMSG MSGID(CPF0000)                              /*S01176*/
                DLTF       FILE(XSETLXD)                              /*S01271*/
                   MONMSG MSGID(CPF0000)                              /*S01271*/
                DLTF       FILE(XSETLXA)                              /*S01271*/
                   MONMSG MSGID(CPF0000)                              /*S01271*/
/***************DLTF       FILE(XTRADSD)*****************/ /*E32848*/ /*CCB009*/
/***************   MONMSG MSGID(CPF0000)*****************/ /*E32848*/ /*CCB009*/
                DLTF       FILE(XBTCHNAB)                             /*CCB009*/
                   MONMSG MSGID(CPF0000)                              /*CCB009*/
                DLTF       FILE(XDPTMVDX1)                            /*CCB009*/
                   MONMSG MSGID(CPF0000)                              /*CCB009*/
                DLTF       FILE(XMGJREFPD)                            /*CCB009*/
                   MONMSG MSGID(CPF0000)                              /*CCB009*/
                DLTF       FILE(XDPTMVD)                              /*E32848*/
                   MONMSG MSGID(CPF0000)                              /*E32848*/
                DLTF       FILE(XATPRPD)                              /*E32848*/
                   MONMSG MSGID(CPF0000)                              /*E32848*/
/**/
/*   SAVE TO BE UPDATED FILES TO X(filename)                        */
/**/
/*              CPYF       FROMFILE(ECTLXHH) TOFILE(XCTLXHH)  +     *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM ECTLXHH)                        *  *S01129*/
/*              CPYF       FROMFILE(ECTLXL0) TOFILE(XCTLXL0)  +     *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM ECTLXL0)                        *  *S01129*/
/*              CPYF       FROMFILE(ECTLXL1) TOFILE(XCTLXL1)  +     *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM ECTLXL1)                        *  *S01129*/
/*              CPYF       FROMFILE(ECTLXL2) TOFILE(XCTLXL2)  +     *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM ECTLXL2)                        *  *S01129*/
/*              CPYF       FROMFILE(ECTLXL9) TOFILE(XCTLXL9)  +     *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM ECTLXL9)                        *  *S01129*/
/*              CPYF       FROMFILE(SEEUCH) TOFILE(XSEEUCH)  +      *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM XSEEUCH)                        *  *S01129*/
/*              CPYF       FROMFILE(SEEUCD0) TOFILE(XSEEUCD0)  +    *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM XSEEUCD0)                       *  *S01129*/
/*              CPYF       FROMFILE(SEEUCD1) TOFILE(XSEEUCD1)  +    *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM XSEEUCD1)                       *  *S01129*/
/*              CPYF       FROMFILE(SEEUCD2) TOFILE(XSEEUCD2)  +    *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM XSEEUCD2)                       *  *S01129*/
/*              CPYF       FROMFILE(SEEUCA) TOFILE(XSEEUCA)  +      *  *S01129*/
/*                         MBROPT(*REPLACE) FMTOPT(*NONE)           *  *S01129*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            *  *S01129*/
/*                      EXEC(CLRPFM XSEEUCA)                        *  *S01175*/
/*              CPYF    FROMFILE(ECTLXHH) TOFILE(XCTLXHH.&TOLIB) +  */
/*                      MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)*  *S01175*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            */
/*                      EXEC(CLRPFM ECTLXHH)                        *  *S01175*/
/*              CPYF    FROMFILE(ECTLXL0) TOFILE(XCTLXL0.&TOLIB) +  */
/*                      MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)*  *S01175*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            */
/*                      EXEC(CLRPFM ECTLXL0)                        *  *S01175*/
/*              CPYF    FROMFILE(ECTLXL1) TOFILE(XCTLXL1.&TOLIB) +  */
/*                      MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)*  *S01175*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            */
/*                      EXEC(CLRPFM ECTLXL1)                        *  *S01175*/
/*              CPYF    FROMFILE(ECTLXL2) TOFILE(XCTLXL2.&TOLIB) +  */
/*                      MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)*  *S01175*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            */
/*                      EXEC(CLRPFM ECTLXL2)                        *  *S01175*/
/*              CPYF    FROMFILE(ECTLXL9) TOFILE(XCTLXL9.&TOLIB) +  */
/*                      MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)*  *S01175*/
/*              MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +            */
/*                      EXEC(CLRPFM ECTLXL9)                        *  *S01175*/
             CPYF       FROMFILE(SEEUCH) TOFILE(&TOLIB/XSEEUCH) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEEUCH)                          /*S01129*/
             CPYF       FROMFILE(SEEUCD0) TOFILE(&TOLIB/XSEEUCD0) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEEUCD0)                         /*S01129*/
             CPYF       FROMFILE(SEEUCD1) TOFILE(&TOLIB/XSEEUCD1) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEEUCD1)                         /*S01129*/
             CPYF       FROMFILE(SEEUCD2) TOFILE(&TOLIB/XSEEUCD2) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEEUCD2)                         /*S01129*/
                CPYF    FROMFILE(SEEUCD3) TOFILE(&TOLIB/XSEEUCD3) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01190*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEEUCD3)                         /*S01190*/
                CPYF    FROMFILE(SEEUCD4) TOFILE(&TOLIB/XSEEUCD4) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01190*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEEUCD4)                         /*S01190*/
                CPYF    FROMFILE(SEEUCD5) TOFILE(&TOLIB/XSEEUCD5) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01190*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEEUCD5)                         /*S01190*/
             CPYF       FROMFILE(SEEUCA) TOFILE(&TOLIB/XSEEUCA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01129*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSEEUCA)                          /*S01129*/
                CPYF    FROMFILE(OTHSTD) TOFILE(&TOLIB/XOTHSTD) +
MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)                          /*S01176*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XOTHSTD)                          /*S01176*/
                CPYF    FROMFILE(OTHSTA) TOFILE(&TOLIB/XOTHSTA) +
MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)                          /*S01176*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XOTHSTA)                          /*S01176*/
                CPYF    FROMFILE(SETLXD) TOFILE(&TOLIB/XSETLXD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01271*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSETLXD)                          /*S01271*/
                CPYF    FROMFILE(SETLXA) TOFILE(&TOLIB/XSETLXA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01271*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XSETLXA)                          /*S01271*/
/***************CPYF    FROMFILE(TRADSD) TOFILE(&TOLIB/XTRADSD) + **/ /*CCB009*/
/*************MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) /*S01271*/ /*CCB009*/
/***************MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) + ***********/ /*CCB009*/
/***************        EXEC(CLRPFM XTRADSD)*************/ /*S01271*/ /*CCB009*/
                CPYF    FROMFILE(BTCHNAB) TOFILE(&TOLIB/XBTCHNAB) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XBTCHNAB)                         /*CCB009*/
                CPYF    FROMFILE(DPTMVDX1) TOFILE(&TOLIB/XDPTMVDX1) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XDPTMVDX1)                        /*CCB009*/
                CPYF    FROMFILE(MGJREFPD) TOFILE(&TOLIB/XMGJREFPD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XMGJREFPD)                        /*CCB009*/
                CPYF    FROMFILE(DPTMVD) TOFILE(&TOLIB/XDPTMVD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01271*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XDPTMVD)                          /*S01271*/
                CPYF    FROMFILE(ATPRPD) TOFILE(&TOLIB/XATPRPD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01271*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XATPRPD)                          /*S01271*/
/* CHANGE DATA AREA   TO 'NEW'          */
 
/********    CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('NEW')              /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('Y')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
 
/**/
/*   SET JOB SWITCHES   */
/**/
/************RCVDTAARA  DTAARA(MMOD)                                *  *S01179*/
/************RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)***************S01179*E23408*/
/**/
/*   SET ON U1 IF RETAIL II OR INTEREST ON ACCOUNTS INSTALLED          *E23408*/
/**/
/************IF*********COND(%SST(&MMOD 3 1) ='Y') THEN(+***************E23408*/
             IF         COND((&BGRTBN *EQ 'Y') *OR (&BGIOAC *EQ +
                          'Y')) THEN(CHGJOB SWS(10000000))            /*E23408*/
             ELSE       CHGJOB     SWS(00000000)
/**/
/*   CLEAR OUTPUT FILES  */
/**/
             CLRPFM     FILE(CEDCS10)
             CLRPFM     FILE(CEDCS12)
             CLRPFM     FILE(CEDCS90)
             CLRPFM     FILE(CEDCS92)
             CLRPFM     FILE(CEDCSAC)
             CLRPFM     FILE(CEDTX31)
             CLRPFM     FILE(CEDTX32)
             CLRPFM     FILE(CEDTX41)
             CLRPFM     FILE(CEDTX42)
             CLRPFM     FILE(CEDTX51)
             CLRPFM     FILE(CEDTX52)
             CLRPFM     FILE(CEDTX61)
             CLRPFM     FILE(CEDTX62)
             CLRPFM     FILE(CEDTX81)
             CLRPFM     FILE(CEDTX82)
             CLRPFM     FILE(CEDTXAC)
             CLRPFM     FILE(ECASHAB)
             CLRPFM     FILE(ECASHAC)
             CLRPFM     FILE(NOTLXAB)
             CLRPFM     FILE(NOTLXAC)
             CLRPFM     FILE(STPR1TX)
             CLRPFM     FILE(STPR1ZZ)
             CLRPFM     FILE(STPR2TX)
             CLRPFM     FILE(STPR2ZZ)
             CLRPFM     FILE(STPR3TX)
             CLRPFM     FILE(STPR3ZZ)
             CLRPFM     FILE(STPR4TX)
             CLRPFM     FILE(STPR4ZZ)
             CLRPFM     FILE(STPR5TX)                                /*S01170*/
             CLRPFM     FILE(STPR5ZZ)                                /*S01170*/
             CLRPFM     FILE(UNFORAB)
             CLRPFM     FILE(UNFORAC)
/************CLRPFM     FILE(INSTRAB)                                /*E19753*/
/************CLRPFM     FILE(INSTRAC)                                /*E19753*/
 
/*  CLEAR MESSAGE MANAGEMENT FILES TOO */                             /*066209*/
             CLRPFM     FILE(MGF100PD)                                /*066209*/
             CLRPFM     FILE(MGF202PD)                                /*066209*/
             CLRPFM     FILE(MGF210PD)                                /*066209*/
             CLRPFM     FILE(MGF520PD)                                /*066209*/
             CLRPFM     FILE(MGF521PD)                                /*066209*/
             CLRPFM     FILE(MGF522PD)                                /*066209*/
             CLRPFM     FILE(MGF523PD)                                /*066209*/
             CLRPFM     FILE(MGF554PD)                                /*066209*/
             CLRPFM     FILE(MGF579PD)                                /*066209*/
             CLRPFM     FILE(MGISOTPD)                                /*CSE029*/
             CLRPFM     FILE(MGISODPD)                                /*CSE029*/
             CLRPFM     FILE(MGISOPPD)                                                    /*CSW025*/
/*/COPY WNCPYSRC,SEC0603013                                          */
             CLRPFM     FILE(MGF580PD)                                /*066209*/
/*/COPY WNCPYSRC,SEC0603010                                          */
/**/
/************CHGVAR     VAR(&JLIB) VALUE(&PRE *CAT 'JLIB') /*S01386*/ /*CCB009*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0603MP1                                          */
                                                                      /*S01408*/
                                                                      /*S01386*/
/*****CREATE*JOURNALS*-*IF*THEY*ALREADY*EXIST*THEN*THESE*ACTION 066209/*CCB009*/
/**************WILL*CAUSE*AN*ERROR*WHICH*WILL*BE*PICKED*UP /*066209*/ /*CCB009*/
/**************BY*THE*GLOBAL*MONITOR*MESSAGE,*ROUTED*TO*AB-/*066209*/ /*CCB009*/
/**************NORMAL*PROCESSING,*AND*THE*JOURNAL*CHANGES/ /*066209*/ /*CCB009*/
/**************APPLIED.**THIS*JOB*CAN*THEN*BE*RESTARTED**/ /*066209*/ /*CCB009*/
/**************AGAIN!**THIS*SEQUENCE*WILL*ONLY*HAPPEN****/ /*066209*/ /*CCB009*/
/**************VERY*INFREQUENTLY.************************/ /*066209*/ /*CCB009*/
/************                                              /*066209*/ /*CCB009*/
/************CRTJRNRCV  JRNRCV(&JLIB/SETEMPRCV)**********/ /*S01386*/ /*CCB009*/
/************CRTJRN     JRN(&JLIB/SETEMPJRN) JRNRCV(SETEMPRCV)S01386* /*CCB009*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JSEC0603)                      /*CCB009*/
             MONMSG MSGID(CPF0000)                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
/**/                                                                  /*CCB009*/
             ENDCMTCTL                                                /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCM0000)                /*CCB009*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             DLTJRN     JRN(JSEC0603)                                 /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
/**/                                                                  /*CCB009*/
             CHGJOB     INQMSGRPY(*DFT)                               /*CCB009*/
             DLTJRNRCV  JRNRCV(JRSEC0603)                             /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
             CHGJOB     INQMSGRPY(*RQD)                               /*CCB009*/
/**/                                                                  /*CCB009*/
             CRTJRNRCV  JRNRCV(&JLIB/JRSEC0603)                       /*CCB009*/
/**/                                                                  /*CCB009*/
             CRTJRN     JRN(&JLIB/JSEC0603) JRNRCV(&JLIB/JRSEC0603)   /*CCB009*/
/**/                                                                  /*CCB009*/
                                                                      /*S01386*/
/*********** STRJRNPF   FILE(TRADSD MGOREFPD MGOMSGPD MGF100PD +      /*S01401*/
/***********              MGF202PD MGF210PD) JRN(SETEMPJRN) +         /*S01401*/
/***********              IMAGES(*BOTH)                    /*S01386*/ /*S01401*/
/*********** STRJRNPF   FILE(TRADSD MGOREFPD MGOMSGPD MGF100PD +
/***********              MGF202PD MGF210PD MGF520PD MGF521PD +
/***********              MGF522PD MGF523PD MGF554PD MGF579PD +
/***********              MGF580PD) JRN(SETEMPJRN) IMAGES(*BOTH)*S01401*067702*/
/************STRJRNPF   FILE(TRADSD TRADSDX1 MGOREFPD MGOMSGPD +
                          MGF100PD MGF202PD MGF210PD MGF520PD +
                          MGF521PD MGF522PD MGF523PD MGF554PD +
                          MGF579PD MGF580PD) JRN(SETEMPJRN) +
                          IMAGES(*BOTH)******************/ /*067702*/ /*CCB009*/
/*/COPY WNCPYSRC,SEC0603014                                          */
/************STRJRNPF   FILE(DPTMVDX1) JRN(SETEMPJRN) IMAGES(*BOTH) +
                                       ******************/ /*096837*/ /*CCB009*/
/************STRJRNPF   FILE(TRADSD TRADSDX1 MGOREFPD MGOMSGPD +      /*CSE029*/
/************             MGF100PD MGF202PD MGF210PD MGF520PD +       /*CSE029*/
/************             MGF521PD MGF522PD MGF523PD MGF554PD +       /*CSE029*/
/************             MGF579PD MGF580PD DPTMVDX1) JRN(JSEC0603) + /*CSE029*/
/************             IMAGES(*BOTH)                    /*CCB009*/ /*CSE029*/
/**********  STRJRNPF   FILE(TRADSD TRADSDX1 MGOREFPD MGOMSGPD + */
/**********               MGF100PD MGF202PD MGF210PD MGF520PD +  */
/**********               MGF521PD MGF522PD MGF523PD MGF554PD +  */
/**********               MGF579PD MGF580PD DPTMVDX1 MGISOTPD +  */
/**********               MGISODPD ) +                           */
/**********               JRN(JSEC0603) IMAGES(*BOTH)            */            /*CSE029*/ /*183583*/
/**********  STRJRNPF   FILE(TRADSD TRADSDX1 MGOREFPD MGOMSGPD + */
/**********               MGF100PD MGF202PD MGF210PD MGF520PD + */
/**********               MGF521PD MGF522PD MGF523PD MGF554PD + */
/**********               MGF579PD MGF580PD DPTMVDX1 MGISOTPD + */
/**********               MGISODPD MGOEXTPD) + */
/**********               JRN(JSEC0603) IMAGES(*BOTH) */                       /*183583*/ /*CSW025*/
             STRJRNPF   FILE(TRADSD TRADSDX1 MGOREFPD MGOMSGPD +
                          MGF100PD MGF202PD MGF210PD MGF520PD +
                          MGF521PD MGF522PD MGF523PD MGF554PD +
                          MGF579PD MGF580PD DPTMVDX1 MGISOTPD +
                          MGISODPD MGOEXTPD MGISOPPD) +
                          JRN(JSEC0603) IMAGES(*BOTH)                                     /*CSW025*/
/*/COPY WNCPYSRC,SEC0603002                                          */
                                                                      /*S01386*/
/*/COPY WNCPYSRC,SEC0603011                                          */
             ENDDO                                                    /*CCB009*/
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))     /*S01386 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF0000)                                /*S01386*/
/* */                                                                 /*E40242*/
/** Retrieve the system date and time so that the correct          */ /*E40242*/
/** journal entries can be extracted for a SWIFT audit report      */ /*E40242*/
/* */                                                                 /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
                                                                      /*S01386*/
/*                                                                     S01271*/
/*  START INSERT FOR S01271                                            S01271*/
/*                                                                     S01271*/
/*   PAY/RECEIVE OTHST EXTRACT  */                                   /*S01271*/
             SNDPGMMSG  MSG('Pay/Receive extract') TOMSGQ(MRUNQ)      /*S01386*/
                                                                      /*S01386*/
             CALL  PGM(SE3315)                                       /*S01271*/
/************IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ERROR))*****************/ /*S01271*/ /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive extract +
                             failure')                                /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
                                                                     /*S01271*/
/*   PAY/RECEIVE SETLX EXTRACT  */                                   /*S01271*/
             SNDPGMMSG  MSG('Pay/Receive extract') TOMSGQ(MRUNQ)      /*S01386*/
                                                                      /*S01386*/
             CALL  PGM(SE3325)                                       /*S01271*/
/************IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ERROR))*****************/ /*S01271*/ /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive extract +
                             failure')                                /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
                                                                     /*S01271*/
/*                                                                     S01271*/
/*  END   INSERT FOR S01271                                            S01271*/
/*                                                                     S01271*/
/*   FORMATTED TELEXES EXTRACT  */
             SNDPGMMSG  MSG('Pay/Receive extract file split') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
         /***CALL  PGM(SE0420)***/                                    /*S01271*/
/************CALL  PGM(SE0420) PARM(&COBIND)                  *S01271* *S01117*/
             CALL  PGM(SE0420) PARM(&COBIND &RSEQ)                    /*S01117*/
/************IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR))  /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive file +
                             split failure')                          /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
/**/
/*   SET 'EUCLID TELEXES AVAILABLE' FLAG*/
/*           IF         COND(%SWITCH(XXX1XXXX)) THEN(CHGDTAARA +    */
/*                        DTAARA(STSTAT (20 1)) VALUE(Y))           */
/**/
/*   UNFORMATTED TELEXES EXTRACT  */
             SNDPGMMSG  MSG('Pay/Receive telex extract') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
/************CALL  PGM(SE0421)                                          E22974*/
/************CALL  PGM(SE0421) PARM(&BGSWST &BGMTMI)*****/ /*E22974*/ /*S01271*/
             CALL       PGM(SE0421) PARM(&BGSWST &BGMTMI  +
                           &COBIND)                                   /*S01271*/
/************IF    COND(%SWITCH(XXXXXXX1)) THEN( GOTO CMDLBL(ERROR))  /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/Receive telex +
                             extract failure')                        /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
/*/COPY WNCPYSRC,SEC0603021                                          */
/**/
/*   REFORMAT EUCLID TRANSMISSION  */
             SNDPGMMSG  MSG('Set EUCLID line numbers') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
/************CLRPFM     FILE(ECTLXDH)     */                          /*S01175*/
         /***CALL  PGM(SE0425)***/                                    /*S01271*/
/************CALL  PGM(SE0425) PARM(&COBIND)                  *S01271* *S01117*/
             CALL  PGM(SE0425) PARM(&COBIND &RSEQ)                    /*S01117*/
                                                                      /*S01386*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Set EUCLID line +
                             number failure')                         /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO                                                    /*S01386*/
                                                                      /*S01386*/
/************CPYF       FROMFILE(ECTLXDH) TOFILE(ECTLXHH) MBROPT(*ADD) */
/**/
/***  THE FOLLOWING SECTION HAS BEEN RESTRUCTURED TO  ***/
/***  REMOVE THE EXCESSIVE NESTING THAT HAS BUILT UP  ***/
/**/                                                                  /*S01176*/
/***  BEGINNING OF DELETION  ***/                                     /*S01176*/
/************IF    COND(%SWITCH(XXXXXXX0)) THEN(DO) */                /*S01176*/
/**/                                                                  /*S01176*/
/****EUCLID*INSTRUCTIONS***/                                          /*S01176*/
/************   CHGJOB     SWS(XXXXX1XX) */                           /*S01176*/
/************   CALL  PGM(SE0430) */                                  /*S01176*/
/************   CHGJOB     SWS(XXXXX0XX) */                           /*S01176*/
/************   IF    COND(%SWITCH(XXXXXXX0)) THEN(DO) */             /*S01176*/
/**/                                                                  /*S01176*/
/****EUROCLEAR*CASH***/                                               /*S01176*/
/************      CALL  PGM(SE0440) */                               /*S01176*/
/************      IF    COND(%SWITCH(XXXXXXX0)) THEN(DO) */          /*S01176*/
/**/                                                                  /*S01176*/
/****CEDEL*INSTRUCTIONS***/                                           /*S01176*/
/************         CALL  PGM(SE0450) */                            /*S01176*/
/************         IF    COND(%SWITCH(XXXXXXX0)) THEN(DO) */       /*S01176*/
/**/                                                                  /*S01176*/
/****CEDEL*CASH***/                                                   /*S01176*/
/************            CALL  PGM(SE0460) */                         /*S01176*/
/************            IF    COND(%SWITCH(XXXXXXX0)) THEN(DO) */    /*S01176*/
/**/                                                                  /*S01176*/
/****COMPLETE*TELEXES***/                                             /*S01176*/
/************               CALL  PGM(SE0470) */                      /*S01176*/
/************               IF    COND(%SWITCH(XXXXXXX0)) THEN(DO) */ /* +
S01176*/
/**/                                                                  /*S01176*/
/****INCOMPLETE*TELEXES***/                                           /*S01176*/
/************                  CALL  PGM(SE0480) */                   /*S01176*/
/************                 IF   COND(%SWITCH(XXXXXXX0)) THEN(DO)*/ /* +
S01176*/
/**/                                                                  /*S01176*/
/****DELIVERY*INSTRUCTIONS***/                                        /*S01176*/
/************                  CALL  PGM(SE0485) */                   /*S01176*/
/************IF      COND(%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0490))*/ /* +
S01176*/
/************ELSE      CMD(GOTO CMDLBL(ENDPRO)) */         /*S01170*/ /* +
S01176*/
/**/                                                                  /*S01176*/
/****INTERNAL*SETTLEMENTS***/                                         /*S01176*/
/************IF      COND(%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0500))*/ /* +
S01176*/
/************ELSE      CMD(GOTO CMDLBL(ENDPRO)) */         /*S01170*/ /* +
S01176*/
/**/                                                                  /*S01176*/
/****TRADES*NO.*TELEXES*****/                                         /*S01176*/
/************IF      COND(%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0510))*/ /* +
S01176*/
/************ELSE      CMD(GOTO CMDLBL(ENDPRO)) */         /*S01170*/ /* +
S01176*/
/****SWIFT*SETTLEMENTS****/                                           /*S01176*/
/************IF      COND(%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE1810))*/ /* +
S01176*/
/************ELSE      CMD(GOTO CMDLBL(ENDPRO)) */         /*S01170*/ /* +
S01176*/
/**/                                                       /*S01170*/ /* +
S01176*/
/*******Call*telex*conversion*program*************/        /*S01170*/ /* +
S01176*/
/************IF         COND(%SWITCH(XXXXXX00)) THEN(DO) */ /* S01170*//* +
S01176*/
/************   IF         COND((%SST(&MMOD 51 1) *EQ 'Y') *AND + */  /*S01176*/
/************                (%SST(&MMOD 53 1) *EQ 'Y'))        + */  /*S01176*/
/************              THEN(CALL PGM(MTC0015)) */                 /*S01176*/
/************ENDDO */                                      /*S01170*/ /* +
S01176*/
/************                  ENDDO */                               /*S01176*/
/************               ENDDO */                                  /*S01176*/
/************            ENDDO */                                     /*S01176*/
/************         ENDDO */                                        /*S01176*/
/************      ENDDO */                                           /*S01176*/
/************   ENDDO */                                              /*S01176*/
/************ENDDO */                                                 /*S01176*/
/**NORMAL*COMPLETION**/                                    /*S01175*/ /* +
S01176*/
/**/                                                                  /*S01176*/
/***  END OF DELETION  ***/                                           /*S01176*/
/**/                                                                  /*S01176*/
/***  IN THIS SECTION, EACH PROGRAM SHOULD ONLY EXECUTE IF  ***/      /*S01176*/
/***  ALL PREVIOUS PROGRAMS HAVE ENDED WITHOUT ERROR, ELSE  ***/      /*S01176*/
/***  PROCESSING WILL MOVE TO THE END OF THE SECTION.       ***/      /*S01176*/
/**/                                                                  /*S01176*/
/***********IF    COND(%SWITCH(XXXXXXX1)) THEN(GOTO ENDPRO)/*S01176*/ /*S01386*/
/*   EUCLID INSTRUCTIONS  */                                          /*S01176*/
             SNDPGMMSG  MSG('Euroclear Instructions') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
             CHGJOB SWS(XXXXX1XX)                                     /*S01176*/
/************CALL   PGM(SE0430)*****************************S01176*/  /*S01271*/
/************CALL   PGM(SE0430) PARM(&COBIND)                 *S01271* *S01117*/
             CALL   PGM(SE0430) PARM(&COBIND &RSEQ)                   /*S01117*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Euroclear +
                             instructions failure')                   /*S01386*/
                  GOTO       CMDLBL(ERROR)                            /*S01386*/
             ENDDO
             CHGJOB SWS(XXXXX0XX)                                     /*S01176*/
/**/                                                                  /*S01176*/
/*   EUROCLEAR CASH  */                                               /*S01176*/
             SNDPGMMSG  MSG('Euroclear cash telexes') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
         /***IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0440))**S01176*/  /*S01271*/
             IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0440) +
                                    PARM(&COBIND &RSEQ))              /*S01117*/
/************                                 PARM(&COBIND))  *S01271* *S01117*/
             ELSE GOTO ENDPRO                                         /*S01176*/
/**/                                                                  /*S01176*/
/*   CEDEL INSTRUCTIONS  */                                           /*S01176*/
             SNDPGMMSG  MSG('CEDEL telex instructions') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
         /***IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0450))***S01176*/ /*S01271*/
             IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0450) +
                                    PARM(&COBIND &RSEQ))              /*S01117*/
/************                                 PARM(&COBIND))  *S01271* *S01117*/
             ELSE GOTO ENDPRO                                         /*S01176*/
/**/                                                                  /*S01176*/
/*   CEDEL CASH  */                                                   /*S01176*/
             SNDPGMMSG  MSG('CEDEL cash telexes') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
     /*****  IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0460)    *S01176*  *S01271*/
             IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0460)  +
                                    PARM(&COBIND &RSEQ))              /*S01117*/
/************                                 PARM(&COBIND))  *S01271* *S01117*/
             ELSE GOTO ENDPRO                                         /*S01176*/
/**/                                                                  /*S01176*/
/*   COMPLETE TELEXES  */                                             /*S01176*/
             SNDPGMMSG  MSG('Pay/Receive telex formatting') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
         /***IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0470))***S01176*/ /*S01271*/
             IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0470) +
                                    PARM(&COBIND &RSEQ))              /*S01117*/
/************                                 PARM(&COBIND))  *S01271* *S01117*/
             ELSE GOTO ENDPRO                                         /*S01176*/
/**/                                                                  /*S01176*/
/*   INCOMPLETE TELEXES  */                                           /*S01176*/
             SNDPGMMSG  MSG('Incomplete telexes formatting') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
         /***IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0480))***S01176*/ /*S01271*/
             IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0480) +
                                    PARM(&COBIND &RSEQ))              /*S01117*/
/************                                 PARM(&COBIND))  *S01271* *S01117*/
             ELSE GOTO ENDPRO                                         /*S01176*/
/**/                                                                  /*S01176*/
/****DELIVERY*INSTRUCTIONS********************                        /*S01176*/
/*                             CALL  PGM(SE0485)*/                    /*S01176*/
/**/                                                                  /*S01176*/
/*   OTHER SETTLEMENT INSTRUCTIONS  */                                /*S01176*/
             SNDPGMMSG  MSG('Other Settlements report') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
         /***IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0486))***S01176*/ /*S01271*/
             IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0486) +
                                    PARM(&COBIND &RSEQ))              /*S01117*/
/************                                 PARM(&COBIND))  *S01271* *S01117*/
             ELSE GOTO ENDPRO                                         /*S01176*/
/**/                                                                  /*S01176*/
/*   BANKERS AUTHORISATIONS  */                                       /*S01176*/
             SNDPGMMSG  MSG('Bankers Authorisations') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
         /***IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0490))***S01176*/ /*S01271*/
             IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0490) +
                                    PARM(&COBIND &RSEQ))              /*S01117*/
/************                                 PARM(&COBIND))  *S01271* *S01117*/
             ELSE GOTO ENDPRO                                         /*S01176*/
/**/                                                                  /*S01176*/
/*   INTERNAL SETTLEMENTS  */                                         /*S01176*/
             SNDPGMMSG  MSG('Internal Settlements') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
         /***IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0500))***S01176*/ /*S01271*/
             IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0500) +
                                    PARM(&COBIND &RSEQ))              /*S01117*/
/************                                 PARM(&COBIND))  *S01271* *S01117*/
             ELSE GOTO ENDPRO                                         /*S01176*/
/**/                                                                  /*S01176*/
/*   TRADES NO. TELEXES  */                                           /*S01176*/
             SNDPGMMSG  MSG('Trades with no telex') +
                          TOMSGQ(MRUNQ)                               /*S01386*/
                                                                      /*S01386*/
         /***IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0510))***S01176*/ /*S01271*/
             IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE0510) +
                                    PARM(&COBIND &RSEQ))              /*S01117*/
/************                                 PARM(&COBIND))  *S01271* *S01117*/
             ELSE GOTO ENDPRO                                         /*S01176*/
/**/                                                                  /*S01176*/
/*   SWIFT SETTLEMENTS  */                                 /*S01170*/ /* +
S01176*/
/**/                                                                  /*E20321*/
/************RCVF                                                 E20321E22974*/
/**/                                                                  /*E20321*/
/****        IF         COND(&BGDBST *EQ 'Y') THEN(DO) **/ /*E20321*/ /*S01251*/
/************IF         COND(&BGSWST *EQ 'Y') THEN(DO) **/ /*S01251*/ /*S01386*/
/**/                                                                  /*E20321*/
/*IF (%SWITCH(XXXXXXX0)) THEN(CALL PGM(SE1810)) /*S01170*/ /*S01176*/ /*S17216*/
/************IF       COND(%SWITCH(XXXXXXX0)) THEN(DO) **/ /*S17216*/ /*S01386*/
                                                                      /*S01386*/
/***CLEAR*SEFCTL****************************************************/ /*S01386*/
/********************************************************/ /*S17216*/ /*S01386*/
/***WAIT*FOR*SWIFT*FILES*FOR*1000*SECONDS*FOR*MESSAGE*GENERATION****/ /*S01386*/
/********************************************************/ /*E21096*/ /*S01386*/
/************CALL     MS0504S****************************/ /*S17216*/ /*S01386*/
/************ALCOBJ     OBJ((MSMERG *DTAARA *EXCL)) WAIT(1000) +
            ************/ /*E21096*/                                  /*S01386*/
/************CLRPFM     FILE(MSIXOBK)********************/ /*E21096*/ /*S01386*/
/************CLRPFM     FILE(MSMSOBK)********************/ /*E21096*/ /*S01386*/
/************CPYF       FROMFILE(MSIXOPF) TOFILE(MSIXOBK) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)****/ /*E21096*/ /*S01386*/
/************CPYF       FROMFILE(MSMSOPF) TOFILE(MSMSOBK) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)****/ /*E21096*/ /*S01386*/
/************RTVDTAARA  DTAARA(MSFCTL) RTNVAR(&MSFCTL)***/ /*E21096*/ /*S01386*/
/*           CLRPFM   FILE(MSIXOSE)                       /*S17216*/  /*E21096*/
/*           CLRPFM   FILE(MSMSOSE)                       /*S17216*/  /*E21096*/
/*           OVRDBF   FILE(MSIXA)     TOFILE(MSIXSEA)     /*S17216*/  /*E21096*/
/*           OVRDBF   FILE(MSMSOPF)   TOFILE(MSMSOSE)     /*S17216*/  /*E21096*/
/*********** CALL     SE1810                    *******/  /*S17216*    *S01271*/
/************CALL     PGM(SE1810) PARM(&COBIND)               *S01271* *S01117*/
/*           DLTOVR   FILE(MSIXA)                         /*S17216*/  /*E21096*/
/*           DLTOVR   FILE(MSMSOPF)                       /*S17216*/  /*E21096*/
/************IF       COND(%SWITCH(XXXXXX00)) THEN(CALL +             /*E21096*/
/************         PGM(MSC5050) PARM('SE'))            /*S17216*/  /*E21096*/
/************IF       COND(%SWITCH(XXXXXX00)) THEN(CALL +
                      PGM(MS5050S))**********************/ /*E21096*/ /*S01386*/
/************ELSE       CMD(DO)*************************************/ /*S01386*/
/*                                                                    /*E21096*/
/*  ERROR RECOVERY */ /* MONITOR ON EVERY LINE TO PREVENT LOOP */     /*E21096*/
                                                                      /*E21096*/
/************CLRPFM     FILE(MSIXOPF)********************/ /*E21096*/ /*S01386*/
/************CLRPFM     FILE(MSMSOPF)********************/ /*E21096*/ /*S01386*/
/************CPYF       FROMFILE(MSMSOBK) TOFILE(MSMSOPF) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)****/ /*E21096*/ /*S01386*/
/************MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR2))****/ /*S01386*/
/************CPYF       FROMFILE(MSIXOBK) TOFILE(MSIXOPF) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)****/ /*E21096*/ /*S01386*/
/************MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR2))****/ /*S01386*/
/************CHGDTAARA  DTAARA(MSFCTL) VALUE(&MSFCTL)****/ /*E21096*/ /*S01386*/
/************SNDMSG     MSG('SE Message Generation Ended in Error') +
                          TOMSGQ(MOPERQ MRUNQ)***********/ /*E21096*/ /*S01386*/
/************ENDDO***************************************/ /*S17216*/ /*S01386*/
/************ENDDO***************************************/ /*E21096*/ /*S01386*/
/************DLCOBJ     OBJ((MSMERG *DTAARA *EXCL))******/ /*E21096*/ /*S01386*/
/*           ELSE GOTO ENDPRO                   /*S01170*/ /*S01176*/ /*S17216*/
                                                                      /*S01386*/
/* */                                                                 /*S01386*/
/** Perform SWIFT message generation                               */ /*S01386*/
/* */                                                                 /*S01386*/
             IF         COND((&BGSWST *EQ 'Y') *AND +
                          (%SWITCH(XXXXXXX0))) THEN(DO)               /*S01386*/
                                                                      /*S01386*/
                  OVRDBF     FILE(MGOREFL0) SHARE(*NO)                /*S01386*/
             OVRDBF     FILE(TRADS) SHARE(*NO)                        /*043856*/
                                                                      /*S01386*/
                  SNDPGMMSG  MSG('Pay/receive message generation') +
                               TOMSGQ(MRUNQ)                          /*S01386*/
                                                                      /*S01386*/
                  CALL       PGM(SE1710)                              /*S01386*/
                                                                      /*S01386*/
                  IF         COND(%SWITCH(XXXXXX1X) *OR +
                               (%SWITCH(XXXXXXX1))) THEN(DO)          /*S01386*/
                       CHGVAR     VAR(&MEM) VALUE('Pay/receive +
                                    message generation failure')      /*S01386*/
                       GOTO       CMDLBL(ERROR)                       /*S01386*/
                  ENDDO                                               /*E20321*/
                                                                      /*S01401*/
/***  If the MT5XX Feature is present, then extract and  ***/         /*S01401*/
/***  generate the S.W.I.F.T. Settlement Messages.       ***/         /*S01401*/
                                                                      /*S01401*/
             IF (&S01401 *EQ 'Y') THEN(DO)                            /*S01401*/
                                                                      /*S01401*/
               OVRDBF (MGOREFL0) SHARE(*NO)                           /*S01401*/
                                                                      /*S01401*/
/***  Extract Trade Settlement Messages.  ***/                        /*S01401*/
               CALL (SE1871) PARM(&RSEQ)                              /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MEM) VALUE('SE1871 - Trades Extract for +
                    S.W.I.F.T. Settlements failed.')                  /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  Extract Depot Movement Settlement Messages.  ***/               /*S01401*/
                                                                      /*S01401*/
               CALL (SE1873) PARM('Y' &RSEQ)                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MEM) VALUE('SE1873 - Depot Movements +
                    Extract for S.W.I.F.T. Settlements failed.')      /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  Extract Position Settlement Messages.  ***/                     /*S01401*/
                                                                      /*S01401*/
               CALL PGM(SE1874) PARM(&RSEQ)                           /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 CHGVAR (&MEM) VALUE('SE1874 - Position Settlements +
                    Extract for S.W.I.F.T. Settlements failed.')      /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
               DLTOVR (MGOREFL0)                                      /*S01401*/
/*/COPY WNCPYSRC,SEC0603008                                          */
                                                                      /*S01401*/
/*/COPY WNCPYSRC,SEC0603005                                          */
             ENDDO                                                    /*S01401*/
/* */                                                                 /*S01386*/
/** GDFs records are deleted as they are processed                 */ /*S01386*/
/* */                                                                 /*S01386*/
                                                                      /*S01386*/
/*/COPY WNCPYSRC,SEC0603001                                          */
/* */                                                                 /*S01386*/
/** Process customer transfer messages                             */ /*S01386*/
/* */                                                                 /*S01386*/
                  CALL       PGM(MG0100)                              /*S01386*/
                                                                      /*S01386*/
                       IF         COND(%SWITCH(XXXXXX1X) *OR +
                               %SWITCH(XXXXXXX1)) THEN(DO)            /*S01386*/
                       SNDPGMMSG  MSG('Customer transfer formatting +
                                    failure') TOPGMQ(*EXT) +
                                    TOMSGQ(MOPERQ)                    /*S01386*/
                       GOTO       CMDLBL(ERROR)                       /*S01386*/
                  ENDDO                                               /*S01386*/
                                                                      /*S01386*/
/* */                                                                 /*S01386*/
/** Process Bank transfer messages                                 */ /*S01386*/
/* */                                                                 /*S01386*/
                  CALL       PGM(MG0202)                              /*S01386*/
                                                                      /*S01386*/
                  IF         COND(%SWITCH(XXXXXX1X) *OR +
                               %SWITCH(XXXXXXX1)) THEN(DO)            /*S01386*/
                       SNDPGMMSG  MSG('Bank transfer formatting +
                                    failure') TOPGMQ(*EXT) +
                                    TOMSGQ(MOPERQ)                    /*S01386*/
                       GOTO       CMDLBL(ERROR)                       /*S01386*/
                  ENDDO                                               /*S01386*/
                                                                      /*S01386*/
/* */                                                                 /*S01386*/
/** Process notice to receive messages                             */ /*S01386*/
/* */                                                                 /*S01386*/
                  CALL       PGM(MG0210)                              /*S01386*/
                                                                      /*S01386*/
                  IF         COND(%SWITCH(XXXXXX1X) *OR +
                               %SWITCH(XXXXXXX1)) THEN(DO)            /*S01386*/
                       SNDPGMMSG  MSG('Notice to receive formatting +
                                    failure') TOPGMQ(*EXT) +
                                    TOMSGQ(MOPERQ)                    /*S01386*/
                       GOTO       CMDLBL(ERROR)                       /*S01386*/
                  ENDDO                                               /*S01386*/
/*/COPY WNCPYSRC,SEC0603018                                          */
                                                                      /*S01386*/
/***  If MT5XX Feature present then process S.W.I.F.T. Settlements */ /*S01401*/
                                                                      /*S01401*/
             IF (&S01401 *EQ 'Y') THEN(DO)                            /*S01401*/
                                                                      /*S01401*/
/*** If CSE029 ISO15022 is present then process data download ***  */ /*CSE029*/
/* */                                                                 /*CSE029*/
             IF (&CSE029 *EQ 'Y') THEN(DO)                            /*CSE029*/
             CALL MXC0010 PARM('MSG_TRD '  '*NONE')                   /*CSE029*/
/**********  CALL MXC0020 PARM('MSG_TRD' 'C' '*NONE')  */                      /*CSE029*/ /*CSW025*/
             CALL MXC0010 PARM('MSG_DPM '  '*NONE')                   /*CSE029*/
/**********  CALL MXC0020 PARM('MSG_DPM' 'C' '*NONE')  */                      /*CSE029*/ /*CSW025*/
             CALL MXC0010 PARM('MSG_PST '  '*NONE')                                       /*CSW025*/
             IF (%SWITCH(XXXXXX11)) THEN(DO)                          /*CSE029*/
                 SNDPGMMSG  MSG('ISO15022 Data Extract failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*CSE029*/
                 GOTO (ERROR)                                         /*CSE029*/
             ENDDO                                                    /*CSE029*/
             CALL SE1879
             IF (%SWITCH(XXXXXX11)) THEN(DO)                          /*CSE029*/
                 SNDPGMMSG  MSG('ISO15022 Status update failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*CSE029*/
                 GOTO (ERROR)                                         /*CSE029*/
             ENDDO
             ENDDO
                                                                                          /*CSW202*/
/* If SWIFT2002 is installed. bypass generation of    */                                  /*CSW202*/
/* MT520, MT521, MT522, MT523 and MT580 messages.     */                                  /*CSW202*/
                                                                                          /*CSW202*/
             IF         COND(&CSW202 *EQ 'Y') THEN(GOTO SW2002)                           /*CSW202*/
                                                                      /*094335*/
             OVRDBF     FILE(MGF580L0) TOFILE(MGF580L1)               /*094335*/
             CALL       PGM(MG0580)                                   /*094335*/
             DLTOVR     FILE(MGF580L0)                                /*094335*/
     IF COND(%SWITCH(XXXXXX1X) *OR %SWITCH(XXXXXXX1)) THEN(CHGVAR -
VAR(&MEM) VALUE('SEC0603/MG0580 MT5xx Settlements extract failure'))  /*094335*/
     IF COND(%SWITCH(XXXXXXX1)) THEN(GOTO CMDLBL(ERROR))              /*094335*/
                                                                      /*094335*/
/***  MT520 - Receive Free Messages.  ***/                            /*S01401*/
                                                                      /*S01401*/
             OVRDBF     FILE(TRADSDY1) SHARE(*NO)                     /*096837*/
             OVRDBF     FILE(DPTMVDY4) SHARE(*NO)                     /*096837*/
                                                                      /*096837*/
               CALL (MG0520)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0520 - Receive Free +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  MT521 - Receive Against Payment Messages.  ***/                 /*S01401*/
                                                                      /*S01401*/
               CALL (MG0521)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0521 - Receive Against Payment +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  MT522 - Deliver Free Messages.  ***/                            /*S01401*/
                                                                      /*S01401*/
               CALL (MG0522)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0522 - Deliver Free +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  MT523 - Deliver Against Payment Messages.  ***/                 /*S01401*/
                                                                      /*S01401*/
               CALL (MG0523)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0523 - Deliver Against Payment +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
                                                                      /*S01401*/
/***  MT579/MT580 - Instructions to Clearing System Messages.  ***/   /*S01401*/
                                                                      /*S01401*/
               OVRDBF (MGF579PD) SHARE(*NO)                           /*S01401*/
               CALL (MG0580)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0580 - Instructions to Clearing +
                    System Message Formatting failure') +
                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)                       /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
               DLTOVR (MGF579PD)                                      /*S01401*/
                                                                                          /*CSW202*/
SW2002:                                                                                   /*CSW202*/
                                                                      /*S01401*/
/***  MT554 - Advice of Money Income Messages.  ***/                  /*S01401*/
                                                                      /*S01401*/
               CALL (MG0554)                                          /*S01401*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*S01401*/
                 SNDPGMMSG ('MG0554 - Advice of Money Income +
                    Message Formatting failure') TOPGMQ(*EXT) +
                    TOMSGQ(MOPERQ)                                    /*S01401*/
                 GOTO (ERROR)                                         /*S01401*/
               ENDDO                                                  /*S01401*/
/*/COPY WNCPYSRC,SEC0603009                                          */
                                                                      /*S01401*/
/*/COPY WNCPYSRC,SEC0603006                                          */
/***  End of MT5XX S.W.I.F.T. Messages Generation.  ***/              /*S01401*/
             ENDDO                                                    /*S01401*/
/* */                                                                 /*E40242*/
/** Produce an audit report.                                       */ /*E40242*/
/** The parameters are: Module, Type of run, Journal, Date, Time   */ /*E40242*/
/* */                                                                 /*E40242*/
/*****************CALL       PGM(MEC0890) PARM('SE' 'P' +
                              'SETEMPJRN' &SDATE &STIME)*/ /*E40242*/ /*CCB009*/
                  CALL       PGM(MEC0890) PARM('SE' 'P' +
                               'JSEC0603' &SDATE &STIME)              /*CCB009*/
                                                                      /*S01386*/
                  IF         COND(%SWITCH(XXXXXX1X) *OR +
                               %SWITCH(XXXXXXX1)) THEN(DO)            /*S01386*/
                       SNDPGMMSG  MSG('Audit report failure') +
                                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)       /*S01386*/
                       GOTO       CMDLBL(ERROR)                       /*S01386*/
                  ENDDO                                               /*S01386*/
/*/COPY WNCPYSRC,SEC0603020                                          */
 
             ENDDO                                                    /*S01386*/
                                                                      /*S01386*/
/**/                                                                  /*S01176*/
/****TELEX CONVERSION***/                       /*S01170*/ /*S01176*/ /*S01386*/
/************IF (%SWITCH(XXXXXX00)) THEN(DO)**/ /*S01170*/ /*S01176*/ /*S01386*/
/************RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                E23408E22974*/
/***************IF ((%SST(&MMOD 51 1) *EQ 'Y') *AND (%SST(&MMOD 53 1)   E22974*/
/************** *EQ 'Y')) THEN(CALL PGM(MTC0015))           S01170S01176E22974*/
/****IF*MIDAS*TELEX*MODULE*IS*PRESENT********************/ /*E22974*/ /*S01386*/
/*******IF COND(&BGMTMI *EQ 'Y') THEN(CALL PGM(MTC0015))*/ /*E22974*/ /*S01386*/
/************ENDDO****************************/ /*S01170*/ /*S01176*/ /*S01386*/
/**/                                                                  /*S01175*/
/************IF         COND(%SWITCH(XXXXXX00)) THEN(DO)*/ /*S01175*/ /*S01170*/
 ENDPRO:     IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*S01170*/
/********       CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')/*S01175*/ /*S01189*/
             CHGVAR     VAR(&BUSY) VALUE('N')                         /*S01189*/
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)                /*S01189*/
                                                                      /*S01129*/
/* DELETE COPY FILES                               */                 /*S01129*/
                                                                      /*S01129*/
                DLTF       FILE(XSEEUCH)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEEUCD0)                             /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEEUCD1)                             /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEEUCD2)                             /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSEEUCD3)                             /*S01190*/
                   MONMSG MSGID(CPF0000)                              /*S01190*/
                DLTF       FILE(XSEEUCD4)                             /*S01190*/
                   MONMSG MSGID(CPF0000)                              /*S01190*/
                DLTF       FILE(XSEEUCD5)                             /*S01190*/
                   MONMSG MSGID(CPF0000)                              /*S01190*/
                DLTF       FILE(XSEEUCA)                              /*S01129*/
                   MONMSG MSGID(CPF0000)                              /*S01129*/
                DLTF       FILE(XSETLXD)                              /*S01271*/
                   MONMSG MSGID(CPF0000)                              /*S01271*/
                DLTF       FILE(XSETLXA)                              /*S01271*/
                   MONMSG MSGID(CPF0000)                              /*S01271*/
                DLTF       FILE(XOTHSTD)                              /*S01271*/
                   MONMSG MSGID(CPF0000)                              /*S01271*/
                DLTF       FILE(XOTHSTA)                              /*S01271*/
                   MONMSG MSGID(CPF0000)                              /*S01271*/
/***************DLTF       FILE(XTRADSD)*****************/ /*E32848*/ /*CCB009*/
/***************   MONMSG MSGID(CPF0000)*****************/ /*E32848*/ /*CCB009*/
                DLTF       FILE(XBTCHNAB)                             /*CCB009*/
                   MONMSG MSGID(CPF0000)                              /*CCB009*/
                DLTF       FILE(XDPTMVDX1)                            /*CCB009*/
                   MONMSG MSGID(CPF0000)                              /*CCB009*/
                DLTF       FILE(XMGJREFPD)                            /*CCB009*/
                   MONMSG MSGID(CPF0000)                              /*CCB009*/
                DLTF       FILE(XDPTMVD)                              /*E32848*/
                   MONMSG MSGID(CPF0000)                              /*E32848*/
                DLTF       FILE(XATPRPD)                              /*E32848*/
                   MONMSG MSGID(CPF0000)                              /*E32848*/
                CLRPFM     FILE(SETLXD)                               /*E34903*/
                CLRPFM     FILE(SETLXA)                               /*E34903*/
                CLRPFM     FILE(OTHSTD)                               /*E34903*/
                CLRPFM     FILE(OTHSTA)                               /*E34903*/
/***************GOTO ENDPGM******************************/ /*S01175*/ /*S01386*/
                GOTO END                                              /*S01386*/
             ENDDO                                                    /*S01175*/
/**/
/* */                                                                 /*S01386*/
/** Error Processing                                               */ /*S01386*/
/* */                                                                 /*S01386*/
 ERROR:      IF         COND(&MEM *EQ ' ') THEN(DO)                   /*S01386*/
                  CHGVAR     VAR(&MEM) VALUE('Pay/receive generation +
                               failure')                              /*S01386*/
             ENDDO                                                    /*S01386*/
                                                                      /*S01386*/
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)         /*S01386*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
                                                                      /*S01386*/
/* */                                                                 /*S01386*/
/** Check for database errors                                      */ /*S01386*/
/* */                                                                 /*S01386*/
/**ERROR:    IF         COND(%SWITCH(XXXXXX11)) THEN(DO)************/ /*S01386*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01386*/
/************** RCVDTAARA  DTAARA(LDA) ******************************  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)           /*S01386*/
/*              CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
/************SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)*********/
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)            /*S01386*/
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)           /*S01386*/
/***************CHGVAR    VAR(&MEM) VALUE('SEC0603 - Job Terminated, +
                          Database in Error')***********************/ /*S01386*/
/************SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)*/ /*S01386*/
/************IF         COND(&BGSWST *EQ 'Y') THEN(DO)***/ /*E30842*/ /*S01386*/
/************DLCOBJ     OBJ((MSMERG *DTAARA *EXCL))******/ /*E21096*/ /*S01386*/
/************ENDDO***************************************/ /*E30842*/ /*S01386*/
/***************GOTO ENDPGM*****************************************/ /*S01386*/
             ENDDO
 
/**FILE*CONTROLS*OUT*OF*BALANCE**/
 
/************IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)************/ /*S01386*/
/*************CHGVAR    VAR(&MEM) VALUE('SEC0603 - File Controls out +
                          of Balance')******************************/ /*S01386*/
/************SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)*/ /*S01386*/
/***************GOTO ENDPGM*****************************************/ /*S01386*/
/************ENDDO**************************************************/ /*S01386*/
/************SNDPGMMSG  MSG('Program SEC0603 ended abnormally') +
                       TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)*/ /*S01175*/ /*S01386*/
/************CHGJOB    SWS(XXXXXXX1)*********************/ /*E14849*/ /*S01386*/
/************DLCOBJ     OBJ((MSMERG *DTAARA *EXCL))******/ /*E21096*/ /*S01386*/
/***************GOTO ENDPGM******************************/ /*S01175*/ /*S01386*/
/*E21096*/
/*ERROR2:    SNDBRKMSG  MSG('Possible SWIFT file corruption may have +
                      occured do not restart') TOMSGQ(MOPERQ MRUNQ)*/ /*S01386*/
/************CHGJOB SWS(XXXXXX11)***********************************/ /*S01386*/
/************DLCOBJ     OBJ((MSMERG *DTAARA *EXCL))******/ /*E21096*/ /*S01386*/
/************GOTO ENDPGM*********************************/ /*E21096*/ /*S01386*/
/*                                                                      E22974*/
/*ERROR3:    SNDPGMMSG  MSG('Program SEC0603 ended abnormally - +
                          SDMMODL0 in error.') TOPGMQ(*EXT) +
                          TOMSGQ(MRUNQ MOPERQ)***********/ /*E22974*/ /*S01386*/
/************CHGJOB SWS(XXXXXXX1)************************/ /*E22974*/ /*S01386*/
/************DLCOBJ     OBJ((MSMERG *DTAARA *EXCL))******/ /*E22974*/ /*S01386*/
/************GOTO ENDPGM*********************************/ /*E22974*/ /*S01386*/
/*                                                                      E22974*/
/**NORMAL*COMPLETION**/                                               /*E22974*/
 
/************IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                E22974*/
/***************CHGDTAARA DTAARA(SESTAT (1 3)) VALUE('OLD')             E22974*/
                                                                      /*S01129*/
/**DELETE*COPY*FILES********************************/           /*S01129E22974*/
                                                                      /*S01129*/
/*              DLTF       FILE(XCTLXHH)                       /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/*              DLTF       FILE(XCTLXL0)                       /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/*              DLTF       FILE(XCTLXL1)                       /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/*              DLTF       FILE(XCTLXL2)                       /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/*              DLTF       FILE(XCTLXL9)                       /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/*              DLTF       FILE(XSEEUCH)                       /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/*              DLTF       FILE(XSEEUCD0)                      /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/*              DLTF       FILE(XSEEUCD1)                      /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/*              DLTF       FILE(XSEEUCD2)                      /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/*              DLTF       FILE(XSEEUCA)                       /*S01129 S01175*/
/*                 MONMSG MSGID(CPF0000)                       /*S01129 S01175*/
/************ENDDO                                                      E22974*/
 
/* */                                                                 /*S01386*/
/** If U7/U8 are both off, there must be a CPF error - ensure that */ /*S01386*/
/** these switches are both on                                     */ /*S01386*/
/* */                                                                 /*S01386*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(CHGJOB +
                          SWS(XXXXXX11))                              /*S01386*/
/* */                                                                 /*S01386*/
/** Recover message and transaction files                          */ /*S01386*/
/* */                                                                 /*S01386*/
                CPYF       FROMFILE(XSEEUCH) TOFILE(SEEUCH)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCH)                           /*CCB009*/
                CPYF       FROMFILE(XSEEUCD0) TOFILE(SEEUCD0)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD0)                          /*CCB009*/
                CPYF       FROMFILE(XSEEUCD1) TOFILE(SEEUCD1)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD1)                          /*CCB009*/
                CPYF       FROMFILE(XSEEUCD2) TOFILE(SEEUCD2)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD2)                          /*CCB009*/
                CPYF       FROMFILE(XSEEUCD3) TOFILE(SEEUCD3)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD3)                          /*CCB009*/
                CPYF       FROMFILE(XSEEUCD4) TOFILE(SEEUCD4)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD4)                          /*CCB009*/
                CPYF       FROMFILE(XSEEUCD5) TOFILE(SEEUCD5)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCD5)                          /*CCB009*/
                CPYF       FROMFILE(XSEEUCA) TOFILE(SEEUCA)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SEEUCA)                           /*CCB009*/
                CPYF       FROMFILE(XOTHSTD) TOFILE(OTHSTD)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM OTHSTD)                           /*CCB009*/
                CPYF       FROMFILE(XOTHSTA) TOFILE(OTHSTA)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM OTHSTA)                           /*CCB009*/
                CPYF       FROMFILE(XSETLXD) TOFILE(SETLXD)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SETLXD)                           /*CCB009*/
                CPYF       FROMFILE(XSETLXA) TOFILE(SETLXA)  +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM SETLXA)                           /*CCB009*/
                CPYF       FROMFILE(XATPRPD) TOFILE(ATPRPD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM ATPRPD)                           /*CCB009*/
                CPYF       FROMFILE(XBTCHNAB) TOFILE(BTCHNAB) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM BTCHNAB)                          /*CCB009*/
                CPYF       FROMFILE(XDPTMVDX1) TOFILE(DPTMVDX1) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM DPTMVDX1)                         /*CCB009*/
                CPYF       FROMFILE(XMGJREFPD) TOFILE(MGJREFPD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM MGJREFPD)                         /*CCB009*/
                CPYF       FROMFILE(XDPTMVD) TOFILE(DPTMVD) +
                           MBROPT(*REPLACE) FMTOPT(*NONE)             /*CCB009*/
                MONMSG  MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM DPTMVD)                           /*CCB009*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),       */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve attributes of current job.                            */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START) /*CCB009*/
/**/                                                                  /*CCB009*/
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
/*************************RTNSEQNBR(&FINISH)***CCB009***************************************CSC020*/
/************MONMSG*****MSGID(CPF0000*MCH0000)*EXEC(DO)*****************CCB009**************CSC020*/
/************CHGVAR*****VAR(&FINISH)*VALUE(0)***************************CCB009**************CSC020*/
/************ENDDO******************************************************CCB009**************CSC020*/
/*                                                                                          CSC020*/
/*  Determine starting journal sequence number of current job.                              CSC020*/
/*                                                                                          CSC020*/
             SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +
                          JOB(&CCB009JOB) USER(&CCB009USR) +
                          NUMBER(&CCB009NBR) SEQ(&FINISH)                                 /*CSC020*/
/**/                                                                  /*CCB009*/
/*  Remove journaled changes.                                      */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/*/COPY WNCPYSRC,SEC0603025                                          */
             RMVJRNCHG  JRN(ICJRN) FILE((TRADSD) (MGOREFPD) +
                          (MGOMSGPD) (TRADSDX1)) FROMENT(&START) +
                          TOENT(&FINISH)                              /*CCB009*/
/*/COPY WNCPYSRC,SEC0603023                                          */
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
/*/COPY WNCPYSRC,SEC0603019                                          */
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*********** RMVJRNCHG  JRN(SETEMPJRN) FILE((TRADSD) (MGOREFPD) +     /*S01401*/
/***********              (MGOMSGPD))                      /*S01386*/ /*S01401*/
/*********** RMVJRNCHG  JRN(SETEMPJRN) FILE((TRADSD) (MGOREFPD) +
/***********              (MGOMSGPD))                     /*S01401*/  /*067702*/
/************RMVJRNCHG  JRN(SETEMPJRN) FILE((TRADSD) (MGOREFPD) +
                          (MGOMSGPD) (TRADSDX1))*********/ /*067702*/ /*CCB009*/
/**********  RMVJRNCHG  JRN(JSEC0603) FILE((TRADSD) (MGOREFPD) + */
/**********               (MGOMSGPD) (TRADSDX1))                 */            /*CCB009*/ /*183583*/
             RMVJRNCHG  JRN(JSEC0603) FILE((TRADSD) (MGOREFPD) +
                          (MGOMSGPD) (TRADSDX1) (MGOEXTPD))                               /*183583*/
/*/COPY WNCPYSRC,SEC0603012                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
             ENDDO                                                    /*CCB009*/
/**/
/**/
/*/COPY WNCPYSRC,SEC0603015                                          */
/* */                                                                 /*S01386*/
/** End Process                                                    */ /*S01386*/
/* */                                                                 /*S01386*/
 END:        ENDCMTCTL                                                /*S01386*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
                                                                      /*S01386*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/************ENDJRNPF   FILE(*ALL) JRN(&JLIB/SETEMPJRN)**/ /*S01386*/ /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/JSEC0603)                /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
                                                                      /*S01386*/
             ENDDO                                                    /*CCB009*/
             CHGJOB     INQMSGRPY(*DFT)                               /*S01386*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
                                                                      /*S01386*/
/************DLTJRN     JRN(SETEMPJRN)*******************/ /*S01386*/ /*CCB009*/
             DLTJRN     JRN(JSEC0603)                                 /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
/************DLTJRNRCV  JRNRCV(&JLIB/SETEMPRCV)**********/ /*S01386*/ /*CCB009*/
             DLTJRNRCV  JRNRCV(&JLIB/JRSEC0603)                       /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01386*/
                                                                      /*S01386*/
                 CHGVAR     VAR(&BUSY) VALUE('N')                     /*CCB009*/
/**/                                                                  /*CCB009*/
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)       /*CCB009*/
/**/                                                                  /*CCB009*/
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
/*ENDPGM:     CHGVAR VAR(&BISCPY) VALUE('COPYRIGHT MKI')*/ /*S01117*/ /*S01386*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
