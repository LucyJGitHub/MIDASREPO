/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE COB pay/receive reporting')                  */
/*********************************************************************/
/*                                                                   */
/*     Midas - LENDING                                               */
/*                                                                   */
/*     LEC0701 - CLOSE OF BUSINESS PAY/RECEIVE PROCESSING            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD050114           Date 14Apr18              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC020             Date 31Mar04              */
/*                      CLE031             Date 07Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      183583             Date 28Jun01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CLE009             Date 14Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      157756             Date 16Apr99              */
/*                      127652             Date 06Nov97              */
/*                      CLE007             Date 11Sep97              */
/*                      076411             Date 06Oct95              */
/*                      S01408             Date 05May95              */
/*                  087362        DATE 02MAY95                       */
/*                  S01427        DATE 11JUL93                       */
/*                   E40242       DATE 19JUN92                       */
/*                   E39477       DATE 05MAY92                       */
/*                   E34766       DATE 05FEB92                       */
/*                   E29371       DATE 03FEB92                       */
/*                   S01310       DATE 16APR91                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD050114 - Failure handling issue in COB component LEC0701  */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CLE031 - Lending Enhancements.                              */
/*       183583 - Journal PF/MGOEXTPD.                               */
/*       CCB009 - Journal files throughout close of business         */
/*       CLE009 - SWIFT Message Generation for Fees                  */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       157756 - Override MGOREFL0 with share(*NO) parameter to     */
/*                prevent commitment control error on call to MG9205 */
/*                (Patterned after fix 076411).                      */
/*       127652 - Journal LEFEED and LEFEEAD                         */
/*       CLE007 - Customer Lending Enhancement - Others              */
/*     076411 - Override  files CLOAN and DEALS with SHARE(*NO)      */
/*              paramenter to prevent commitment control error       */
/*              on call to MG9210. Patterned after GEMS fix 041062.  */
/*     S01408 - Addition of core hook LEC0701MP1                     */
/*  087362 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*     S01427 - R10 CHIPS INCORPORATION                              */
/*     E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF MESSAGES       */
/*              GENERATED                                            */
/*     E39477 - ONLY RUN LE0550 IF MUTIBRANCH                        */
/*     E34766 - SET ON U1 IF RETAIL IS PRESENT.                      */
/*     E29371 - CHANGE TEMPJRN/TEMPRCV TO LETEMPJRN/LETEMPRCV        */
/*     S01310 - RE WRITTEN FOR SWIFT RATIONALISATION                 */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*CCB009*/
/**********  PGM        PARM(&CNAM &CSEQ)                                          /*CCB009 CLE134*/
             PGM        PARM(&CNAM &CSEQ &RERUN)                                          /*CLE134*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*/COPY WNCPYSRC,LEC0701001                                          */
/*                                                  */                /*CLE007*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CLE007*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CLE007*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CLE007*/
             DCL        VAR(&CLE007) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CLE007*/
             DCL        VAR(&CLE009) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE009*/
             DCL        VAR(&CLE031) TYPE(*CHAR) LEN(1) VALUE('N')    /*CLE031*/
/*                                                  */                /*CLE007*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
/**********  DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)              */                   /*MD050114*/
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)            */                   /*MD050114*/
 
/**********  DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)          */                   /*MD050114*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MCSTAT) TYPE(*CHAR) LEN(256)             /*S01427*/
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)    /*E39477*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
/**********  DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                            /*087362 MD050114*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*CCB009*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CCB009*/
/**********  DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')                 /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature************/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/                                                                  /*CCB009*/
/* Declare job name, user and number for remove journal changes    */ /*CCB009*/
/**/                                                                  /*CCB009*/
/**********  DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)        */            /*CCB009 MD050114*/
/**********  DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)        */            /*CCB009 MD050114*/
/**********  DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)         */            /*CCB009 MD050114*/
/**********  DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)         */            /*CCB009 MD050114*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&WCRUN) TYPE(*CHAR) LEN(1)                                    /*CLE134*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*MD050114*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*MD050114*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*MD050114*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*MD050114*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*MD050114*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*MD050114*/
/*/COPY WNCPYSRC,LEC0701004                                          */
 
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*MD050114*/
/**********  SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +      */                   /*MD050114*/
/**********               TEXT(&STEXT)                             */            /*CSC020 MD050114*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*MD050114*/
 
/* set switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(00100000)
/*/COPY WNCPYSRC,LEC0701005                                          */
 
/* Notify MRUNQ */
             SNDPGMMSG  MSG('End Of Day Pay/Receive Reporting') +
                          TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,LEC0701013                                          */
/**/                                                                  /*CCB009*/
/***Check*for*Switchable*feature*CCB009.****************************/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +     */                   /*MD050114*/
/**********               'CCB009' &AOFMT)                         */            /*CCB009 MD050114*/
/*                                                  */                /*CLE007*/
/* Check if Enhancement Number CLE007 is present.   */                /*CLE007*/
/*                                                  */                /*CLE007*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CLE007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE007*/
             CHGVAR     VAR(&SAR) VALUE('CLE007')                     /*CLE007*/
                                                                      /*CLE007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CLE007*/
                                                                      /*CLE007*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE007) VALUE('Y'))                    /*CLE007*/
             ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(ERROR)))                             /*CLE007*/
 
/*                                                  */                /*CLE009*/
/* Check if Enhancement Number CLE009 is present.   */                /*CLE009*/
/*                                                  */                /*CLE009*/
               IF (&CLE007 *EQ 'Y') THEN(DO)                          /*CLE009*/
                 CALL (AOSARDR0) PARM(&RTCD '*VERIFY' 'CLE009')       /*CLE009*/
                 IF (&RTCD *EQ ' ') THEN(CHGVAR (&CLE009) VALUE('Y')) /*CLE009*/
               ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(ERROR)))                             /*CLE009*/
               ENDDO                                                  /*CLE009*/
/*/COPY WNCPYSRC,LEC0701010                                          */
                                                                      /*CLE009*/
/*                                                  */                /*CLE031*/
/* Check if Enhancement Number CLE031 is present.   */                /*CLE031*/
/*                                                  */                /*CLE031*/
                                                                      /*CLE031*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CLE031')  /*CLE031*/
 
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE031) VALUE('Y'))                    /*CLE031*/
             ELSE       CMD(IF COND(&RTCD *NE '*NRF   ') THEN(GOTO +
                          CMDLBL(ERROR)))                             /*CLE031*/
/* Clear GDF files */
             CLRPFM     FILE(MGF100PD)
             CLRPFM     FILE(MGF202PD)
             CLRPFM     FILE(MGF210PD)
 
             CLRPFM     FILE(LETX1HH)
             CLRPFM     FILE(LETX1PR)
             CLRPFM     FILE(LETX1ZZ)
             CLRPFM     FILE(LETX2HH)
             CLRPFM     FILE(LETX2PR)
             CLRPFM     FILE(LETX2ZZ)
             CLRPFM     FILE(LETX3HH)
             CLRPFM     FILE(LETX3PR)
             CLRPFM     FILE(LETX3ZZ)
             CLRPFM     FILE(LETX4HH)
             CLRPFM     FILE(LETX4PR)
             CLRPFM     FILE(LETX4ZZ)
/*/COPY WNCPYSRC,LEC0701006                                          */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             CHGJOB     SWS(XXX1XXXX)
             IF         COND(&CLE007 *NE 'Y') THEN(DO)                /*CLE007*/
             CLRPFM     FILE(LEPXTAA)
             CLRPFM     FILE(LEPXTAB)
             CLRPFM     FILE(LEPXTAC)
             ENDDO                                                    /*CLE007*/
/**/                                                                  /*S01427*/
/*  MIDAS/CHIPS LENDING                                          */   /*S01427*/
             IF         COND(%SST(&MMOD 43 1) *EQ 'Y') THEN(DO)       /*S01427*/
                CHGJOB     SWS(1XXXXXXX)                              /*S01427*/
                CLRPFM     FILE(*LIBL/LETX6HH)                        /*S01427*/
                CLRPFM     FILE(*LIBL/LETX6PR)                        /*S01427*/
                CLRPFM     FILE(*LIBL/LETX6ZZ)                        /*S01427*/
             ENDDO                                                    /*S01427*/
/*/COPY WNCPYSRC,LEC0701015                                          */
/* Journal transaction and message files */
/**********  RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)             */                   /*MD050114*/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT) /*E39477*/
 
/**********  CHGVAR     VAR(&PREFIX) VALUE(%SST(&SDSTAT 6 2))      */                   /*MD050114*/
/**********  CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')      */                   /*MD050114*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LEC0701MP1                                          */
/**/                                                                  /*CCB009*/
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/****If*Restart,*Remove*Journalled*Changes****/                                  /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********     IF         COND(&STAT *EQ 'Y') THEN(DO)                          /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),********/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)       */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**Retrieve*data*area*CB0180DA*from*QTEMP.**************************/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)   */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**If*data*area*is*not*blank,*calculate*the*job*name,*user*and*no.**/            /*CCB009 MD050114*/
/**of*the*previous*run*of*this*component.***************************/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  IF         COND(&CB0180DA *NE ' ') THEN(DO)           */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  CHGVAR     VAR(&CCB009JOB) VALUE(%SST(&CB0180DA 1 10))  */          /*CCB009 MD050114*/
/**********  CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10)) */          /*CCB009 MD050114*/
/**********  CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6))  */          /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/***Retrieve*the*most*recent*journal*entry*sequence*number**********/            /*CCB009 MD050114*/
/***for*the*specific*job.*******************************************/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) + */                /*MD050114*/
/**********               TOENT(*FIRST) SEARCH(*DESCEND) +         */                   /*MD050114*/
/**********               JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +  */                   /*MD050114*/
/**********               RTNSEQNBR(&START)                        */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)            */            /*CCB009 MD050114*/
/**********  CHGVAR     VAR(&START) VALUE(0)                       */            /*CCB009 MD050114*/
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
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
/**/                                                                                      /*CLE134*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)         */            /*CLE134 MD050114*/
/***Retrieve*the*most*recent*journal*entry*sequence*number**********/            /*CLE134 MD050114*/
/***for*the*specific*job.*******************************************/            /*CLE134 MD050114*/
/**/                                                                                      /*CLE134*/
/**********  RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) + */                /*MD050114*/
/**********               TOENT(*FIRST) SEARCH(*DESCEND) +         */                   /*MD050114*/
/**********               JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +  */                   /*MD050114*/
/**********               RTNSEQNBR(&START)                        */            /*CLE134 MD050114*/
/**/                                                                                      /*CLE134*/
/**********  MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)            */            /*CLE134 MD050114*/
/**********  CHGVAR     VAR(&START) VALUE(0)                       */            /*CLE134 MD050114*/
/**********  ENDDO                                                 */           /*CLE134 MD050114*/
/**********  ENDDO                                                 */            /*CLE134 MD050114*/
/*                                                                                          CSC020*/
/***Determine*starting*journal*sequence*number*of*job.**************/            /*CSC020 MD050114*/
/*                                                                                          CSC020*/
/**********  SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +        */                   /*MD050114*/
/**********               JOB(&CCB009JOB) USER(&CCB009USR) +       */                   /*MD050114*/
/**********               NUMBER(&CCB009NBR) SEQ(&FINISH)          */            /*CSC020 MD050114*/
/**/                                                                  /*CCB009*/
/***Remove*journaled*changes.***************************************/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +*/            /*CCB009 MD050114*/
/**********               THEN(D)                                  */            /*CCB009 MD050114*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((FCLTYFM) (FCLTYFN) +      */                   /*MD050114*/
/**********               (LOAMSDK) (MGOREFPD) (MGOMSGPD) +        */                   /*MD050114*/
/**********               (CLOANCL) (MGOEXTPD)) FROMENT(&START) +  */                   /*MD050114*/
/**********               TOENT(&FINISH)                           */            /*183583 MD050114*/
/**********       (CLOANCL)) FROMENT(&START) TOENT(&FINISH) */ /*CCB009 183583*/
/**********  MONMSG     MSGID(CPF0000 MCH0000)                     */            /*CCB009 MD050114*/
/*/COPY WNCPYSRC,LEC0701018                                          */
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
/**********  IF         COND(&CLE007 *EQ 'Y') THEN(DO)             */            /*CCB009 MD050114*/
/**********  IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +*/                   /*MD050114*/
/**********               THEN(DO)                                 */            /*CCB009 MD050114*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((LEPXTAA) (LEPXTAB) +      */                   /*MD050114*/
/**********               (LEPXTAC)) FROMENT(&START) TOENT(&FINISH) + */                /*MD050114*/
/**********                                                        */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*CCB009 MD050114*/
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
/*********** ENDDO                                                 */            /*CCB009 MD050114*/
/*********** ENDDO                                                 */            /*CCB009 MD050114*/
/**********  ELSE       CMD(DO)                                    */            /*CCB009 MD050114*/
/**********  RMVJRNCHG  JRN(JLEC0701) FILE((FCLTYFM) (FCLTYFN) +   */                   /*MD050114*/
/**********              (LOAMSDK) (MGOREFPD) (MGOMSGPD) (CLOANCL) + */                 /*MD050114*/
/**********              (MGOEXTPD))                               */            /*183583 MD050114*/
/**********      (LOAMSDK) (MGOREFPD) (MGOMSGPD) (CLOANCL)) */ /*CCB009 183583*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                           /*CCB009 MD050114*/
/*/COPY*WNCPYSRC,LEC0701019*******************************************/                 /*MD050114*/
                                                                      /*CCB009*/
/**********  IF         COND(&CLE007 *EQ 'Y') THEN(DO)             */            /*CCB009 MD050114*/
/**********  RMVJRNCHG  JRN(JLEC0701) FILE((LEPXTAA) (LEPXTAB) +   */                   /*MD050114*/
/**********               (LEPXTAC))                               */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*CCB009 MD050114*/
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
 
                                                           /* E29371 */
/************CRTJRNRCV  JRNRCV(&JLIB/TEMPRCV)               */
/************CRTJRNRCV  JRNRCV(&JLIB/LETEMPRCV)****************/      /*CCB009*/
/************CRTJRN     JRN(&JLIB/TEMPJRN) JRNRCV(TEMPRCV)  */
/************CRTJRN     JRN(&JLIB/LETEMPJRN) JRNRCV(LETEMPRCV)*/      /*CCB009*/
 
/**/                                                                  /*CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */            /*CCB009 MD050114*/
/**********  ENDJRNPF   FILE(*ALL) JRN(JLEC0701)                   */            /*CCB009 MD050114*/
/**********  MONMSG MSGID(CPF0000)                                 */            /*CCB009 MD050114*/
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  ENDCMTCTL                                             */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCM0000)             */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */            /*CCB009 MD050114*/
/**********  DLTJRN     JRN(JLEC0701)                              */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF0000)                             */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  CHGJOB     INQMSGRPY(*DFT)                            */            /*CCB009 MD050114*/
/**********  DLTJRNRCV  JRNRCV(JRLEC0701)                          */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF0000)                             */            /*CCB009 MD050114*/
/**********  CHGJOB     INQMSGRPY(*RQD)                            */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRLEC0701)                    */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  CRTJRN     JRN(&JLIB/JLEC0701) JRNRCV(&JLIB/JRLEC0701)*/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/************STRJRNPF   FILE(LOAMSDK FCLTYFM FCLTYFN MGOREFPD +
/*************            MGOMSGPD MGF100PD MGF210PD MGF202PD +
/*************            CLOANCL) JRN(TEMPJRN) IMAGES(*BOTH) +
/*************            OMTJRNE(*NONE)                    */
 
/************STRJRNPF   FILE(LOAMSDK FCLTYFM FCLTYFN MGOREFPD +
/*************            MGOMSGPD MGF100PD MGF210PD MGF202PD +
/*************            CLOANCL) JRN(LETEMPJRN) IMAGES(*BOTH) +
/*************            OMTJRNE(*NONE)                              /*087362*/
                                                          /* E29371 */
/******RETRY:*******************************************************/            /*087362 MD050114*/
/*********STRJRNPF   FILE(LOAMSDK) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(LOAMSDK) JRN(JLEC0701) IMAGES(*BOTH) +   */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 MD050114*/
/*********STRJRNPF   FILE(FCLTYFM) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(FCLTYFM) JRN(JLEC0701) IMAGES(*BOTH) +   */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 MD050114*/
/*********STRJRNPF   FILE(FCLTYFN) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(FCLTYFN) JRN(JLEC0701) IMAGES(*BOTH) +   */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 MD050114*/
/*********STRJRNPF   FILE(MGOREFPD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(MGOREFPD) JRN(JLEC0701) IMAGES(*BOTH) +  */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 MD050114*/
/*********STRJRNPF   FILE(MGOMSGPD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(MGOMSGPD) JRN(JLEC0701) IMAGES(*BOTH) +  */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 MD050114*/
/*********STRJRNPF   FILE(MGOEXTPD) JRN(JLEC0701) IMAGES(*BOTH) +  */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*183583 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*183583 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*183583 MD050114*/
/*********STRJRNPF   FILE(MGF100PD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(MGF100PD) JRN(JLEC0701) IMAGES(*BOTH) +  */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 MD050114*/
/*********STRJRNPF   FILE(MGF202PD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(MGF202PD) JRN(JLEC0701) IMAGES(*BOTH) +  */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 MD050114*/
/*********STRJRNPF   FILE(MGF210PD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(MGF210PD) JRN(JLEC0701) IMAGES(*BOTH) +  */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 MD050114*/
/*********STRJRNPF   FILE(CLOANCL) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(CLOANCL) JRN(JLEC0701) IMAGES(*BOTH) +   */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 MD050114*/
/**********  IF         COND(&CLE007 *EQ 'Y') THEN(DO)             */            /*CLE007 MD050114*/
/*********STRJRNPF   FILE(LEPXTAA) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*CLE007*/ /*CCB009*/
/*********STRJRNPF   FILE(LEPXTAA) JRN(JLEC0701) IMAGES(*BOTH) +                        /*MD050114*/
/**********               OMTJRNE(*NONE)                                         /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                                           /*CLE007 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                /*CLE007 MD050114*/
/*********STRJRNPF   FILE(LEPXTAB) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*CLE007*/ /*CCB009*/
/*********STRJRNPF   FILE(LEPXTAB) JRN(JLEC0701) IMAGES(*BOTH) +                        /*MD050114*/
/**********               OMTJRNE(*NONE)                                         /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                                           /*CLE007 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                /*CLE007 MD050114*/
/*********STRJRNPF   FILE(LEPXTAC) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*CLE007*/ /*CCB009*/
/*********STRJRNPF   FILE(LEPXTAC) JRN(JLEC0701) IMAGES(*BOTH) +   */                   /*MD050114*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*CLE007 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*CLE007 MD050114*/
/*********STRJRNPF   FILE(LEFEED) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*127652*/ /*CCB009*/
/*********STRJRNPF   FILE(LEFEED) JRN(JLEC0701) IMAGES(*BOTH) +                         /*MD050114*/
/**********               OMTJRNE(*NONE)                                         /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                                           /*127652 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                /*127652 MD050114*/
/*********STRJRNPF   FILE(LEFEEAD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*127652*/ /*CCB009*/
/*********STRJRNPF   FILE(LEFEEAD) JRN(JLEC0701) IMAGES(*BOTH) +                        /*MD050114*/
/**********               OMTJRNE(*NONE)                                         /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF7030)                                           /*127652 MD050114*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                /*127652 MD050114*/
/**********  ENDDO                                                               /*127652 MD050114*/
                                                                      /*087362*/
/*/COPY*WNCPYSRC,LEC0701002*****************************************/                   /*MD050114*/
/**********  GOTO       CMDLBL(BYPASS)                             */            /*087362 MD050114*/
                                                                      /*087362*/
/*****JRNFAIL:******************************************************/            /*087362 MD050114*/
/**********  CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                            /*087362 MD050114*/
/**********  IF         COND(&COUNT *LE 3) THEN(DO)                              /*087362 MD050114*/
/**********  DLYJOB     DLY(60)                                                  /*087362 MD050114*/
/**********  GOTO       CMDLBL(RETRY)                                            /*087362 MD050114*/
/**********  ENDDO                                                               /*087362 MD050114*/
/**********  ELSE       CMD(DO)                                                  /*087362 MD050114*/
/**********  GOTO       CMDLBL(ERROR)                                            /*087362 MD050114*/
/**********  ENDDO                                                               /*087362 MD050114*/
/**********  ENDDO                                                               /*CCB009 MD050114*/
/*/COPY WNCPYSRC,LEC0701014                                          */
/*****BYPASS:******************************************************/             /*087362 MD050114*/
/*/COPY WNCPYSRC,LEC0701007                                          */
                                                                      /*087362*/
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
 
/* Begin commitment control */
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF0000)
 
/**********  CHGVAR     VAR(&STAT) VALUE('Y')                      */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
             SNDPGMMSG  MSG('Create Pay/Receive Extract Files') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXX100)
 
             OVRDBF     FILE(TABLE) TOFILE(TABLEEE)
/*/COPY WNCPYSRC,LEH01435                                            */
             CALL LE0430
             DLTOVR     FILE(TABLE)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Create pay/receive extract +
                          file failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,LEC0701017                                          */
 
             IF COND(%SST(&MMOD 28 1) *EQ 'Y') THEN(DO)
 
             OVRDBF     FILE(MGOREFPD) SHARE(*NO)
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)                    /*157756*/
/**/
             OVRDBF FILE(CLOAN) SHARE(*NO)                           /*076411*/
             OVRDBF FILE(DEALS) SHARE(*NO)                           /*076411*/
/*/COPY WNCPYSRC,LEC0701008                                          */
/**/
             CALL LE4510  /* COMIT LOANS ONLY */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive message +
                          generation failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,LEC0701016                                          */
 
/* GDFs records are deleted as they are processed */
/*/COPY WNCPYSRC,LEC0701011                                          */
 
/* Process customer transfer messages */
             CALL       PGM(MG0100)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Customer transfer formatting failure') +
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
/*/COPY WNCPYSRC,LEC0701012                                          */
 
/* If ISO pay receives required print messages */
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
 
             IF COND(%SST(&MMOD 36 1) *EQ Y) THEN(DO)
             CHGJOB     SWS(XXX1XXXX)
             ENDDO
 
/* Pay/receive (complete)                                            */
 
             SNDPGMMSG  MSG('Pay/receive telexes print complete +
                          instructions') TOMSGQ(MRUNQ)
             CALL       PGM(LE0500) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive telexes print +
                          complete instructions failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Pay/receive (incomplete)                                          */
 
             SNDPGMMSG  MSG('Pay/receive telexes incomplete +
                          instructions') TOMSGQ(MRUNQ)
             CALL       PGM(LE0510) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive telexes +
                          incomplete instructions failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Bankers authorisations                                            */
 
             SNDPGMMSG  MSG('Bankers authorisations') TOMSGQ(MRUNQ)
             CALL       PGM(LE0520) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Bankers authorisation +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Internal settlements                                              */
 
/* Seton U1 if Retail is switched on */                               /*E34766*/
             IF         COND(%SUBSTRING(&MMOD 3 1) *EQ Y) THEN(DO)    /*E34766*/
                        CHGJOB SWS(1XXXXXXX)                          /*E34766*/
             ENDDO                                                    /*E34766*/
             SNDPGMMSG  MSG('Internal settlements report') +
                          TOMSGQ(MRUNQ)
             CALL       PGM(LE0530) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Internal settlements report +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Settlements in other branches                                   */
             IF         COND(%SST(&RUNDAT 13 1) *EQ Y) THEN(DO)  /*E39477*/
             SNDPGMMSG  MSG('Pay/receive settlements in other +
                          branches') TOMSGQ(MRUNQ)
             CALL       PGM(LE0550) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive settlements in +
                          other branches failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO         /*E39477*/
 
/**/                                                                  /*S01427*/
             IF         COND(%SST(&MMOD 43 1) *EQ 'Y') THEN(DO)       /*S01427*/
                CHGJOB     SWS(00000000)                              /*S01427*/
/**/                                                                  /*S01427*/
             CHGJOB     SWS(100XXXXX)                                 /*S01427*/
/**/                                                                  /*S01427*/
CALL       PGM(*LIBL/MCC01)                                           /*S01427*/
/**/                                                                  /*S01427*/
                IF  COND(%SWITCH(XXXXXXX0)) THEN(DO)                  /*S01427*/
CLRPFM     FILE(*LIBL/LETX6HH)                                        /*S01427*/
CLRPFM     FILE(*LIBL/LETX6PR)                                        /*S01427*/
CLRPFM     FILE(*LIBL/LETX6ZZ)                                        /*S01427*/
                ENDDO                                                 /*S01427*/
/**/                                                                  /*S01427*/
             ENDDO                                                    /*S01427*/
/* CLEAR FILES NO LONGER NEEDED                                      */
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
 
                CLRPFM     FILE(LETX1HH)
                CLRPFM     FILE(LETX1PR)
                CLRPFM     FILE(LETX1ZZ)
                CLRPFM     FILE(LETX2HH)
                CLRPFM     FILE(LETX2PR)
                CLRPFM     FILE(LETX2ZZ)
                CLRPFM     FILE(LETX3HH)
                CLRPFM     FILE(LETX3PR)
                CLRPFM     FILE(LETX3ZZ)
                CLRPFM     FILE(LETX4HH)
                CLRPFM     FILE(LETX4PR)
                CLRPFM     FILE(LETX4ZZ)
 
                IF         COND(%SWITCH(XXX1XXXX)) THEN(DO)
                   CLRPFM     FILE(LEPXTAA)
                   CLRPFM     FILE(LEPXTAB)
                   CLRPFM     FILE(LEPXTAC)
                ENDDO
 
                CLRPFM     FILE(LETLXHH)
                CLRPFM     FILE(LETLXDK)
                CLRPFM     FILE(LETLXZX)
                CLRPFM     FILE(CFTLXHH)
                CLRPFM     FILE(CFTLXPR)
                CLRPFM     FILE(CFTLXZZ)
             ENDDO
 
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
/************CALL       PGM(MEC0890) PARM('LE' 'P' 'LETEMPJRN ' +
                          &SDATE &STIME)*****************/ /*E40242*/ /*CCB009*/
             CALL       PGM(MEC0890) PARM('LE' 'P' 'JLEC0701  ' +
                          &SDATE &STIME)                              /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
 
             IF         COND(&CLE007 *EQ 'Y') THEN(DO)                /*CLE007*/
                CLRPFM     FILE(LEFEEAD)                              /*CLE007*/
                IF         COND(&CLE009 *EQ 'Y') THEN(DO)             /*CLE009*/
                   CLRPFM     FILE(LEFELNPD)                          /*CLE009*/
                   CLRPFM     FILE(LEFELAPD)                          /*CLE009*/
                   IF         COND(&CLE031 *EQ 'Y') THEN(CLRPFM +
                              FILE(LEFERLPD))                         /*CLE031*/
                ENDDO                                                 /*CLE009*/
             ENDDO                                                    /*CLE007*/
/* Skip error processing if none have occurred */                     /*E40242*/
             GOTO       CMDLBL(END)
 
/* Error processing */
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive generation +
                          failure')
             ENDDO
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Send database error message to workstation & MOPERQ */
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
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),********/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)       */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/*  Retrieve attributes of current job.                            */ /*CCB009*/
/**/                                                                  /*CCB009*/
/**********  RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +         */                   /*MD050114*/
/**********               NBR(&CCB009NBR)                          */            /*CCB009 MD050114*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*MD050114*/
/**/                                                                  /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
/**********  RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) + */                /*MD050114*/
/**********               TOENT(*FIRST) SEARCH(*DESCEND) +         */                   /*MD050114*/
/**********               JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +  */                   /*MD050114*/
/**********               RTNSEQNBR(&START)                        */            /*CCB009 MD050114*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*MD050114*/
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
/**********  SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +        */                   /*MD050114*/
/**********               JOB(&CCB009JOB) USER(&CCB009USR) +       */                   /*MD050114*/
/**********               NUMBER(&CCB009NBR) SEQ(&FINISH)          */            /*CSC020 MD050114*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*MD050114*/
/**/                                                                  /*CCB009*/
/*  Remove journaled changes.                                      */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((FCLTYFM) (FCLTYFN) +      */                   /*MD050114*/
/**********               (LOAMSDK) (MGOREFPD) (MGOMSGPD) +        */                   /*MD050114*/
/**********               (CLOANCL) (MGOEXTPD)) FROMENT(&START) +  */                   /*MD050114*/
/**********               TOENT(&FINISH)                           */            /*183583 MD050114*/
/**********       (CLOANCL)) FROMENT(&START) TOENT(&FINISH) */ /*CCB009 183583*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*CCB009 MD050114*/
             RMVJRNCHG  JRN(ICJRN) FILE((FCLTYFM) (FCLTYFN) +
                          (LOAMSDK) (MGOREFPD) (MGOMSGPD) +
                          (CLOANCL) (MGOEXTPD))  +
                          RCVRNG(&SJRNRCVR &FJRNRCVR)  +
                          FROMENT(&START) TOENT(&FINISH)                                /*MD050114*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*MD050114*/

/*/COPY WNCPYSRC,LEC0701020                                          */
             ENDDO                                                    /*CCB009*/
             IF         COND(&CLE007 *EQ 'Y') THEN(DO)                /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((LEPXTAA) (LEPXTAB) +      */                   /*MD050114*/
/**********               (LEPXTAC)) FROMENT(&START) TOENT(&FINISH)*/            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*CCB009 MD050114*/
             RMVJRNCHG  JRN(ICJRN) FILE((LEPXTAA) (LEPXTAB) +
                          (LEPXTAC)) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR) +
                          FROMENT(&START) TOENT(&FINISH)                                /*MD050114*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*MD050114*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
/**********  ELSE       CMD(DO)                                                  /*CCB009 MD050114*/
/**Recover*message*and*transaction*files**/                                             /*MD050114*/
                                                          /* E29371 */
/*           RMVJRNCHG  JRN(TEMPJRN) FILE((FCLTYFM) (FCLTYFN) +
                          (LOAMSDK) (MGOREFPD) (MGOMSGPD) (CLOANCL)) */
/************RMVJRNCHG  JRN(LETEMPJRN) FILE((FCLTYFM) (FCLTYFN) +
                        (LOAMSDK) (MGOREFPD) (MGOMSGPD) (CLOANCL))**/ /*CCB009*/
/**********  RMVJRNCHG  JRN(JLEC0701) FILE((FCLTYFM/ (FCLTYFN) +   */                   /*MD050114*/
/**********              (LOAMSDK) (MGOREFPD) (MGOMSGPD) (CLOANCL) + */                 /*MD050114*/
/**********              (MGOEXTPD))                               */            /*183583 MD050114*/
/**********      (LOAMSDK) (MGOREFPD) (MGOMSGPD) (CLOANCL)) */ /*CCB009 183583*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*MD050114*/
/*/COPY*WNCPYSRC,LEC0701021*******************************************/                 /*MD050114*/
                                                          /* E29371 */
/**********  IF         COND(&CLE007 *EQ 'Y') THEN(DO)             */            /*CLE007 MD050114*/
/************RMVJRNCHG  JRN(LETEMPJRN) FILE((LEPXTAA) (LEPXTAB) +
                          (LEPXTAC))*********************/ /*CLE007*/ /*CCB009*/
/**********  RMVJRNCHG  JRN(JLEC0701) FILE((LEPXTAA) (LEPXTAB) +                        /*MD050114*/
/**********               (LEPXTAC))                                             /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                           /*CLE007 MD050114*/
/**********  ENDDO                                                               /*CLE007 MD050114*/
/**********  ENDDO                                                               /*CCB009 MD050114*/
/*/COPY WNCPYSRC,LEC0701009                                          */
 
END:         ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Clear GDF files */
             CLRPFM     FILE(MGF100PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGF202PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGF210PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,LEC0701003                                          */
 
                                                          /* E29371 */
/**/                                                                  /*CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                     /*CCB009 MD050114*/
/*           ENDJRNPF   FILE(*ALL) JRN(&JLIB/TEMPJRN)      */
/************ENDJRNPF   FILE(*ALL) JRN(&JLIB/LETEMPJRN)    */         /*CCB009*/
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/JLEC0701)             */                   /*MD050114*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*MD050114*/
                                                          /* E29371 */
/**********  ENDDO                                                 */            /*CCB009 MD050114*/
             CHGJOB     INQMSGRPY(*DFT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
                                                          /* E29371 */
/*           DLTJRN     JRN(&JLIB/TEMPJRN)                 */
/************DLTJRN     JRN(&JLIB/LETEMPJRN)               */         /*CCB009*/
/**********  DLTJRN     JRN(&JLIB/JLEC0701)                        */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*MD050114*/
/*           DLTJRNRCV  JRNRCV(&JLIB/TEMPRCV)              */
/************DLTJRNRCV  JRNRCV(&JLIB/LETEMPRCV)            */         /*CCB009*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRLEC0701)                    */            /*CCB009 MD050114*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*MD050114*/
                                                          /* E29371 */
/**********      CHGVAR     VAR(&STAT) VALUE('N')                  */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
/**********      CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)    */            /*CCB009 MD050114*/
/**/                                                                  /*CCB009*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
/**********  SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +      */                   /*MD050114*/
/**********               TEXT(&STEXT)                             */            /*CSC020 MD050114*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*MD050114*/
             RETURN                                                                       /*CSC020*/
/**********  ENDPGM           */                                                          /*CLE134*/
ENDPGM:      ENDPGM                                                                       /*CLE134*/
