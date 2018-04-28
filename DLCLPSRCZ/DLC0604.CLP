/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL COB pay/receive reporting')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - DEALING                                             */
/*                                                                   */
/*       DLC0604 - CLOSE OF BUSINESS PAY/RECEIVE PROCESSING          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 240603A            Date 22Sep06              */
/*                      CDL033             Date 10Feb05              */
/*                      CSC020             Date 31Mar04              */
/*                      CPK016             Date 04Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      183583             Date 11Jun01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      179660             Date 12Jul00              */
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      120725             Date 23Jan98              */
/*                      CFF003             DATE 11APR97              */
/*                      S01408             DATE 04NOV96              */
/*                      S01408             DATE 30AUG96              */
/*                      070251             DATE 01JUL96              */
/*                      076411             DATE 06OCT95              */
/*                      S01408             DATE 20SEP95              */
/*                      S01408             DATE 04MAY95              */
/*                      046820             DATE 13DEC93              */
/*                      S01427             DATE 12JUL93              */
/*                      E40242             DATE 19JUN92              */
/*                      E29588             DATE 16OCT91              */
/*                      E29371             DATE 10OCT91              */
/*                      S01310             DATE 16APR91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       240603A - Call DL0351 after DL1705 to remove PREXPH records */
/*                 if netting.                                       */
/*       CDL033 - Floating Rate CDs Issued.                          */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       183583 - Journal the new PF/MGOEXTPD to resolve the problem */
/*                with several customers having the same SWIFT ID.   */
/*       179660 - Need SHARE(*NO) for MGOREFL0 as well as MGOREFPD   */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       120725 - When MEC0890 failed there was no backward recovery */
/*                of changes written to DEALx, MGOREFPD and MGOMSGPD */
/*                As a result dealing messages were generated twice  */
/*                when component was restarted .                     */
/*       CFF003 - Enhanced OTC Processing - Phase II                 */
/*                upgrade from BLI LBL001                            */
/*       S01408 - Addition of Core Hook DLC0604004                   */
/*       S01408 - Addition of Core Hook DLC0604002                   */
/*                Addition of Core Hook DLC0604003                   */
/*       070251 - CHIPS MESSAGES STILL BEING CLEARED DURING NON      */
/*                WORKING DAY PROCESSING. PROGRAM SHOULD ALWAYS      */
/*                CHECK THAT MCSTAT POSITION 3(DL-CHIPS MESSAGES     */
/*                AVAILABLE) IS NOT EQUAL TO "Y" BEFORE CALLING      */
/*                CHC01.                                             */
/*       076411 - Override  files CLOAN and DEALS with SHARE(*NO)    */
/*                paramenter to prevent commitment control error     */
/*                on call to MG9210. Patterned after GEMS fix 041062.*/
/*       S01408 - Addition of Core Hook DLC0604INT                   */
/*                Addition of Core Hook DLC0604001                   */
/*       S01408 - Addition of Core Hook DLC0604MP1                   */
/*       046820 - Add re-run parameter to call to DL6320             */
/*       S01427 - R10 CHIPS INCORPORATION                            */
/*       E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF MESSAGES     */
/*                GENERATED                                          */
/*       E29588 - POST COLLECTION SWIFT RATIONALISATION FIXES        */
/*                o Re-instate DL0308                                */
/*       E29371 - RENAME TEMPJRN TO AVOID ALLOCATION CLASH           */
/*       S01310 - RE WRITTEN FOR SWIFT RATIONALISATION               */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*CCB009*/
             PGM        PARM(&CNAM &CSEQ)                             /*CCB009*/
/*/                                                                  */
/*/COPY WNCPYSRC,DLC0604INT                                          */
/**/                                                                  /*CFF003*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*CFF003*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*CFF003*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CFF003*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CFF003*/
/**/                                                                  /*CFF003*/
/*/                                                                  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MCSTAT) TYPE(*CHAR) LEN(256)             /*S01427*/
             DCL        VAR(&FION) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*CCB009*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CCB009*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CCB009*/
/**/                                                                  /*CCB009*/
/* Declare variable CCB009 - flag for switchable feature           */ /*CCB009*/
/**/                                                                  /*CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/                                                                  /*CCB009*/
/* Declare job name, user and number for remove journal changes    */ /*CCB009*/
/**/                                                                  /*CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
/*/COPY WNCPYSRC,DLC0604011                                          */
                                                                                          /*CDL033*/
             DCL        VAR(&CDL033) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CDL033*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                         /*240603A*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')                                                             /*240603A*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)                                  /*240603A*/
             DCL        VAR(&CDL002) TYPE(*CHAR) LEN(1) VALUE('N')                       /*240603A*/
 
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/*/COPY WNCPYSRC,DLC0604012                                          */
 
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
/* Set switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(00100000)
 
/* Notify MRUNQ */
             SNDPGMMSG  MSG('End Of Day Pay/Receive Reporting') +
                          TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,DLC0604006                                          */
/** Determine if Floating Rate CD Issued feature is                                    */ /*CDL033*/
/** switched on.                                                                       */ /*CDL033*/
                                                                                          /*CDL033*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                        /*CDL033*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CDL033*/
             CHGVAR     VAR(&SARD) VALUE('CDL033')                                        /*CDL033*/
                                                                                          /*CDL033*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                         /*CDL033*/
                                                                                          /*CDL033*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL033) VALUE('Y'))                                        /*CDL033*/
                                                                                          /*CDL033*/
             IF         COND(&RTN *NE '       ' *AND &RTN  *NE +
                          '*NRF   ') THEN(DO)                                             /*CDL033*/
                SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                             TOMSGQ(MOPERQ)                                               /*CDL033*/
                CHGJOB     JOB(XXXXXX11)                                                  /*CDL033*/
                GOTO       CMDLBL(ERROR)                                                  /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
 
/*  Clear extract files */
             CLRPFM     FILE(PREXHH)
             CLRPFM     FILE(PREXPH)
             CLRPFM     FILE(PREXZZ)
             CLRPFM     FILE(PREX1HH)
             CLRPFM     FILE(PREX1PH)
             CLRPFM     FILE(PREX1ZZ)
             CLRPFM     FILE(PREX2HH)
             CLRPFM     FILE(PREX2PH)
             CLRPFM     FILE(PREX2ZZ)
             CLRPFM     FILE(PREX3HH)
             CLRPFM     FILE(PREX3PH)
             CLRPFM     FILE(PREX3ZZ)
             CLRPFM     FILE(PREX4HH)
             CLRPFM     FILE(PREX4PH)
             CLRPFM     FILE(PREX4ZZ)
             CLRPFM     FILE(PREX5HH)
             CLRPFM     FILE(PREX5PH)
             CLRPFM     FILE(PREX5ZZ)
             CLRPFM     FILE(PREX6HH)
             CLRPFM     FILE(PREX6PH)
             CLRPFM     FILE(PREX6ZZ)
 
             CLRPFM     FILE(MGF100PD)
             CLRPFM     FILE(MGF200PD)
             CLRPFM     FILE(MGF202PD)
             CLRPFM     FILE(MGF210PD)
/*/COPY WNCPYSRC,DLC0604007                                          */
 
/* Journal transaction and message files */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
 
             CHGVAR     VAR(&PREFIX) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC0604MP1                                          */
                                                                      /*S01408*/
/**/                                                                  /*CCB009*/
/** Check for Switchable feature CCB009.                           */ /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/**/                                                                  /*CCB009*/
/*   If Restart, Remove Journalled Changes   */                       /*CCB009*/
/**/                                                                  /*CCB009*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)               /*CCB009*/
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
/*/COPY WNCPYSRC,DLC0604020                                          */
             RMVJRNCHG  JRN(ICJRN) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD)(MGOEXTPD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*183583*/
/*/COPY WNCPYSRC,DLC0604018                                          */
/***********              (MGOREFPD) (MGOMSGPD)) + */                 /*183583*/
/***********              FROMENT(&START) TOENT(&FINISH) */    /*CCB009 183583*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB009*/
/*/COPY WNCPYSRC,DLC0604022                                          */
                                                                                          /*CDL033*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
                RMVJRNCHG  JRN(ICJRN) FILE((MGHISTPD)) FROMENT(&START) +
                             TOENT(&FINISH)                                               /*CDL033*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
             RMVJRNCHG  JRN(JDLC0604) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD) (MGOEXTPD))           /*183583*/
/***********              (MGOREFPD) (MGOMSGPD)) */            /*CCB009 183583*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB009*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
                RMVJRNCHG  JRN(JDLC0604) FILE((MGHISTPD))                                 /*CDL033*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
 
                                                           /* E29371 */
/*           CRTJRNRCV  JRNRCV(&JLIB/TEMPRCV)               */
/*           CRTJRN     JRN(&JLIB/TEMPJRN) JRNRCV(TEMPRCV)  */
 
/************CRTJRNRCV  JRNRCV(&JLIB/DLTEMPRCV)****************/      /*CCB009*/
/************CRTJRN     JRN(&JLIB/DLTEMPJRN) JRNRCV(DLTEMPRCV)*/      /*CCB009*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JDLC0604)                      /*CCB009*/
             MONMSG MSGID(CPF0000)                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
/**/                                                                  /*CCB009*/
             ENDCMTCTL                                                /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCM0000)                /*CCB009*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             DLTJRN     JRN(JDLC0604)                                 /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
/**/                                                                  /*CCB009*/
             CHGJOB     INQMSGRPY(*DFT)                               /*CCB009*/
             DLTJRNRCV  JRNRCV(JRDLC0604)                             /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
             CHGJOB     INQMSGRPY(*RQD)                               /*CCB009*/
/**/                                                                  /*CCB009*/
             CRTJRNRCV  JRNRCV(&JLIB/JRDLC0604)                       /*CCB009*/
/**/                                                                  /*CCB009*/
             CRTJRN     JRN(&JLIB/JDLC0604) JRNRCV(&JLIB/JRDLC0604)   /*CCB009*/
/**/                                                                  /*CCB009*/
 
/*           STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
                          DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
                          MGOREFPD MGOMSGPD MGF100PD MGF200PD +
                          MGF210PD MGF202PD) JRN(TEMPJRN) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)      */
 
/*/COPY WNCPYSRC,DLC0604023                                          */
/**********  STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
/**********               DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
/**********               MGOREFPD MGOMSGPD MGF100PD MGF200PD +
/**********               MGF210PD MGF202PD) JRN(DLTEMPJRN) +
/**********               IMAGES(*BOTH) OMTJRNE(*NONE) *************/ /*CCB009*/
             STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
                          DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
                          MGOREFPD MGOMSGPD MGF100PD MGF200PD +
                          MGF210PD MGF202PD MGOEXTPD) JRN(JDLC0604) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)                /*183583*/
/*/COPY WNCPYSRC,DLC0604025                                          */
                                                                                          /*CDL033*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
                STRJRNPF   FILE(MGHISTPD) JRN(JDLC0604) IMAGES(*BOTH) +
                             OMTJRNE(*NONE)                                               /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
/***********              MGF210PD MGF202PD) JRN(JDLC0604) + */       /*183583*/
/***********              IMAGES(*BOTH) OMTJRNE(*NONE) */      /*CCB009 183583*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,DLC0604008                                          */
                                                           /* E29371 */
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
 
/* Begin commitment control */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) + */                /*CPK009*/ /*CPK016*/
/**********               CMTSCOPE(*JOB)                     */                /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/**/                                                                  /*CCB009*/
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/* Block large files */
             OVRDBF     FILE(PREXPH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX2PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX3PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX4PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX5PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX6PH) SEQONLY(*YES 50)
 
/* Over-ride to appropriate transaction extracts */
             OVRDBF     FILE(DEAMS) TOFILE(DAUPD)
             OVRDBF     FILE(TRANS) TOFILE(DLIND)
 
/* DLC2350A */
             SNDPGMMSG  MSG('Create Pay/Receive Extract Files') +
                          TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,DLC0604002                                          */
 
             CHGJOB     SWS(XXXXX100)
 
             CALL DL1705
/*/COPY WNCPYSRC,DLC0604003                                          */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Create pay/receive extract +
                          file failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/**/                                                                                     /*240603A*/
/* Check if switchable feature CDL002 is on (FX Netting) */                              /*240603A*/
/**/                                                                                     /*240603A*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                      /*240603A*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                      /*240603A*/
             CHGVAR     VAR(&SAR) VALUE('CDL002')                                        /*240603A*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)                     /*240603A*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CDL002) VALUE('Y'))                                         /*240603A*/
                                                                                         /*240603A*/
/*  if netting installed run the extract prune to remove records to                      /*240603A*/
/*  be processed in the net run of pay/receives                                          /*240603A*/
             IF         COND(&CDL002 *EQ 'Y') THEN(DO)                                   /*240603A*/
                CALL       PGM(DL0351)                                                   /*240603A*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                              /*240603A*/
                  CHGVAR     VAR(&MSG) VALUE('Pay/receive extract netting +
                             prune failure')                                             /*240603A*/
                  GOTO       CMDLBL(ERROR)                                               /*240603A*/
                ENDDO                                                                    /*240603A*/
             ENDDO                                                                       /*240603A*/
                                                                                         /*240603A*/
             CALL PGM(DL0307)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive file split +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/                                                                  */
/*/COPY WNCPYSRC,DLC0604001                                          */
/**/                                                                  /*CFF003*/
/* If CFF003 is in the system, call */                                /*CFF003*/
/* OTC Pay/Receive Extract File Split program */                      /*CFF003*/
/**/                                                                  /*CFF003*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*CFF003*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CFF003*/
             CHGVAR     VAR(&SARD) VALUE('CFF003')                    /*CFF003*/
/**/                                                                  /*CFF003*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*CFF003*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CFF003*/
                CALL    PGM(FF0307)                                   /*CFF003*/
             ENDDO                                                    /*CFF003*/
/*/                                                                  */
 
/* DLC2351B */
             SNDPGMMSG  MSG('Incomplete Instructions Report') +
                          TOMSGQ(MRUNQ)
 
             SNDPGMMSG  MSG('Pay/Receive Telexes Report') +
                          TOMSGQ(MRUNQ)                             /* E29588 */
                                                                    /* E29588 */
             CHGJOB     SWS(XXX0XXXX)                               /* E29588 */
             CALL       PGM(DL0308) PARM('     ')                   /* E29588 */
                                                                    /* E29588 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* E29588 */
             CHGVAR     VAR(&MSG) VALUE('Complete pay/receive +
                          telexes failure')                         /* E29588 */
             GOTO       CMDLBL(ERROR)                               /* E29588 */
             ENDDO                                                  /* E29588 */
             CALL       PGM(DL0312) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Incomplete pay/receive +
                          telexes failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             SNDPGMMSG  MSG('Bankers Authorisations Report') +
                          TOMSGQ(MRUNQ)
 
             CALL       PGM(DL0314) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Bankers authorisations +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             SNDPGMMSG  MSG('Internal Settlements Report') +
                          TOMSGQ(MRUNQ)
 
             IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 16 1) = 'Y')) +
                          THEN(CHGJOB SWS(1XXXXXXX))
 
             CALL       PGM(DL0318) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Internal settlements failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF COND(%SST(&MMOD 25 1) *EQ 'Y') THEN(DO)
 
/* DLC2350E */
             OVRDBF     FILE(MGOREFPD) SHARE(*NO)
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)                    /*179660*/
 
             OVRDBF FILE(CLOAN) SHARE(*NO)                           /*076411*/
             OVRDBF FILE(DEALS) SHARE(*NO)                           /*076411*/
/*/COPY WNCPYSRC,DLC0604024                                          */
                                                                                          /*CDL033*/
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)                                         /*CDL033*/
                                                                                          /*CDL033*/
/**/
/* Extract Dealing GDF records */
             CALL DL6315
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive message +
                          generation failure (DL6315)')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* If FRA/IRS switched ON, extract FRA/IRS GDF records */
             CALL       PGM(MGFICHK) PARM(&FION)
             IF         COND(&FION *EQ Y) THEN(DO)
 
/************CALL DL6320                                          */ /*046820*/
             CALL       PGM(DL6320) PARM('N')                        /*046820*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive message +
                          generation failure (FRA/IRS - DL6320)')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             ENDDO
 
/* GDFs records are deleted as they are processed */
 
/*/COPY WNCPYSRC,DLC0604005                                          */
/* Process customer transfer messages */
             CALL       PGM(MG0100)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Customer transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process nostro transfer messages */
             CALL       PGM(MG0200)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Nostro transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process Bank transfer messages */
             CALL       PGM(MG0202)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Bank transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process notice to receive messages */
             CALL       PGM(MG0210)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Notice to receive formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC0604016                                          */
 
/* If ISO advices required (PF/SDMGMEPD, ENFFAR='N') print messages */
             RCVF
             IF         COND(&ENFFAR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             CALL PGM(ME0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ISO print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             ENDDO
 
/* Generate C.H.I.P.S. messages if interface present */
/************IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +        /*S01427*/
/************             THEN(CALL PGM(CHC01))                       /*S01427*/
 
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)              /*S01427*/
 
              CHGJOB    SWS(001XXXXX)                                 /*S01427*/
              IF        COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +
                          THEN(DO)                                    /*S01427*/
/**/                                                                  /*S01427*/
                RTVDTAARA  DTAARA(MCSTAT) RTNVAR(&MCSTAT)             /*S01427*/
                RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)             /*S01427*/
/************** IF         COND(%SUBSTRING(&SDSTAT 116 1) *NE '3') +* /*070251*/
/**************           THEN(CALL PGM(CHC01))      ******* /*S01427* *070251*/
                IF   COND((%SUBSTRING(&SDSTAT 116 1) *NE '3') *AND +
                          (%SST(&MCSTAT 3 1) *NE 'Y')) THEN(DO)       /*070251*/
                          CALL PGM(CHC01)                             /*070251*/
                          ENDDO                                       /*070251*/
                ELSE CMD(IF COND(%SST(&MCSTAT 3 1) *NE 'Y')      +
                          THEN(CALL PGM(CHC01)))                      /*S01427*/
              ENDDO                                                   /*S01427*/
             ENDDO                                                    /*S01427*/
/*                                                                      S01427*/
            IF        COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +
                          THEN(DO)                                    /*S01427*/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)              /*S01427*/
             RTVDTAARA  DTAARA(MCSTAT) RTNVAR(&MCSTAT)                /*S01427*/
               CHGVAR VAR(%SUBSTRING(&MCSTAT 2 1)) VALUE('N')         /*S01427*/
               CHGDTAARA  DTAARA(MCSTAT) VALUE(&MCSTAT)               /*S01427*/
               CLRPFM     FILE(CRCSVDD)                               /*S01427*/
               CLRPFM     FILE(CRCSVTT)                               /*S01427*/
              ENDDO                                                   /*S01427*/
             ENDDO                                                    /*S01427*/
/*                                                                  */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('C.H.I.P.S. message +
                          generation failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
                                                                      /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
/**********  CALL       PGM(MEC0890) PARM('DL' 'P' 'DLTEMPJRN ' +
/**********               &SDATE &STIME)*****************/ /*E40242*/ /*CCB009*/
             CALL       PGM(MEC0890) PARM('DL' 'P' 'JDLC0604  ' +
                          &SDATE &STIME)                              /*CCB009*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)  */ /*E40242*/ /*120725*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*120725*/
             CHGVAR     VAR(&MSG) VALUE('Message Generation Audit +
                          report failure')                            /*120725*/
             GOTO       CMDLBL(ERROR)                                 /*120725*/
             ENDDO                                                    /*120725*/
 
/* Skip error processing if none have occurred */
/*/COPY WNCPYSRC,DLC0604014                                          */
             GOTO       CMDLBL(END)
 
/* Error processing */
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive generation +
                          failure')
             ENDDO
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Send database error message */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
 
/* If U7/U8 both OFF, must be CPF error - ensure switches ON for */
/* return to CB */
             IF         COND(%SWITCH(XXXXXX00)) THEN(CHGJOB +
                          SWS(XXXXXX11))
 
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
/*/COPY WNCPYSRC,DLC0604021                                          */
             RMVJRNCHG  JRN(ICJRN) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD) (MGOEXTPD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*183583*/
/*/COPY WNCPYSRC,DLC0604019                                          */
/***********              (MGOREFPD) (MGOMSGPD)) + */                 /*183583*/
/***********              FROMENT(&START) TOENT(&FINISH) */    /*CCB009 183583*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CCB009*/
/*/COPY WNCPYSRC,DLC0604017                                          */
                                                                                          /*CDL033*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
                RMVJRNCHG  JRN(ICJRN) FILE((MGHISTPD)) FROMENT(&START) +
                             TOENT(&FINISH)                                               /*CDL033*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/* Recover message and transaction files */
/*/COPY WNCPYSRC,DLC0604015                                          */
                                                           /* E29371 */
/*           RMVJRNCHG  JRN(TEMPJRN) FILE((DEALSDA) (DEALSDB) +   */
/**********  RMVJRNCHG  JRN(DLTEMPJRN) FILE((DEALSDA) (DEALSDB) +
/**********               (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
/**********               (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
/**********               (MGOREFPD) (MGOMSGPD))********************/ /*CCB009*/
/*/COPY WNCPYSRC,DLC0604027                                          */
             RMVJRNCHG  JRN(JDLC0604) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD) (MGOEXTPD))           /*183583*/
/*/COPY WNCPYSRC,DLC0604026                                          */
/***********              (MGOREFPD) (MGOMSGPD)) */            /*CCB009 183583*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,DLC0604013                                          */
                                                                                          /*CDL033*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
                RMVJRNCHG  JRN(JDLC0604) FILE((MGHISTPD))                                 /*CDL033*/
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
             ENDDO                                                    /*CCB009*/
                                                           /* E29371 */
 
END:         ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/*  Clear extract files */
             CLRPFM     FILE(PREXHH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREXPH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREXZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX1HH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/                                                                  */
/*/COPY WNCPYSRC,DLC0604004                                          */
/*/                                                                  */
             CLRPFM     FILE(PREX1PH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX1ZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX2HH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX2PH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX2ZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX3HH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX3PH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX3ZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX4HH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX4PH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX4ZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX5HH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX5PH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX5ZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX6HH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX6PH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(PREX6ZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CLRPFM     FILE(MGF100PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGF200PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGF202PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGF210PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,DLC0604009                                          */
 
                                                           /* E29371 */
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
 /*          ENDJRNPF   FILE(*ALL) JRN(&JLIB/TEMPJRN)       */
/************ENDJRNPF   FILE(*ALL) JRN(&JLIB/DLTEMPJRN)     */        /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/JDLC0604)                /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                    /*CCB009*/
                                                           /* E29371 */
             CHGJOB     INQMSGRPY(*DFT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
                                                           /* E29371 */
/*           DLTJRN     JRN(&JLIB/TEMPJRN)                  */
/************DLTJRN     JRN(&JLIB/DLTEMPJRN)              */          /*CCB009*/
             DLTJRN     JRN(&JLIB/JDLC0604)                           /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 /*          DLTJRNRCV  JRNRCV(&JLIB/TEMPRCV)               */
/************DLTJRNRCV  JRNRCV(&JLIB/DLTEMPRCV)           */          /*CCB009*/
             DLTJRNRCV  JRNRCV(&JLIB/JRDLC0604)                       /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,DLC0604010                                          */
                                                           /* E29371 */
 
                 CHGVAR     VAR(&STAT) VALUE('N')                     /*CCB009*/
/**/                                                                  /*CCB009*/
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)       /*CCB009*/
/**/                                                                  /*CCB009*/
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
             ENDPGM
