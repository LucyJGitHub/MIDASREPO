/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE End of day confirmations')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                         */
/*                                                                   */
/*       LEC0702 - CLOSE OF BUSINESS CONFIRMATION PROCESSING         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021577           Date 05Aug13              */
/*                      CLE075BO           Date 06Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      183583             Date 28Jun01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      190127             Date 29Mar01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CCG008             Date 06Feb96              */
/*                      S01408             DATE 05MAY95              */
/*                      087362             DATE 02MAY95              */
/*                      S01465             DATE 22MAR94              */
/*                      E29371             DATE 10OCT91              */
/*                      S01310             DATE 16APR91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021577 - LEC0702 failed due to lock conflict              */
/*       CLE075BO - COB Restructure - LE COB Optimisation Phase 1    */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       183583 - Journal PF/MGOEXTPD.                               */
/*       190127 - Journal MGHISTPD                                   */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCG008 - User Defined Confirmation - Lending                */
/*       S01408 - Addition of core hook LEC0702MP1                   */
/*  087362 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*       S01465 - BLI Lending and Guarantees Issued Enhancements.    */
/*       E29371 - Change TEMPJRN/TEMPRCV to LETEMPJRN/LETEMPRCV      */
/*       S01310 - Re-written for SWIFT rationalisation               */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*CCB009*/
/**********  PGM        PARM(&CNAM &CSEQ)      */                                  /*CCB009 CLE134*/
             PGM        PARM(&CNAM &CSEQ &RERUN)                                          /*CLE134*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**********  DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)              */                   /*CLE075BO*/
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)            */                   /*CLE075BO*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
/**********  DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)          */                   /*CLE075BO*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)              */            /*087362 CLE075BO*/
                                                                     /*S01465*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                 /*S01465*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)            /*S01465*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*CCG008*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*CCB009*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CCB009*/
/**********  DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')   */            /*CCB009 CLE075BO*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature************/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)            */            /*CCB009 CLE075BO*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)           */            /*CCB009 CLE075BO*/
/**/                                                                  /*CCB009*/
/* Declare job name, user and number for remove journal changes    */ /*CCB009*/
/**/                                                                  /*CCB009*/
/**********  DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)        */            /*CCB009 CLE075BO*/
/**********  DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)        */            /*CCB009 CLE075BO*/
/**********  DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)         */            /*CCB009 CLE075BO*/
/**********  DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)         */            /*CCB009 CLE075BO*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CLE075BO*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CLE075BO*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CLE075BO*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CLE075BO*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075BO*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075BO*/
/*/COPY WNCPYSRC,LEC0702001                                          */
 
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/*/COPY WNCPYSRC,LEH01063                                            */
 
                                                                                          /*CLE134*/
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
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CLE075BO*/
/**********  SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +      */                   /*CLE075BO*/
/**********               TEXT(&STEXT)                             */            /*CSC020 CLE075BO*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*CLE075BO*/
 
/* Notify MRUNQ & create temporary journal */
             SNDPGMMSG  MSG('CoB Confirmations Generation') +
                          TOMSGQ(MRUNQ)
/*******************************************************************/            /*CCB009 CLE075BO*/
/***Check*for*Switchable*feature*CCB009.****************************/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +     */                   /*CLE075BO*/
/**********               'CCB009' &AOFMT)                         */            /*CCB009 CLE075BO*/
/**/                                                                  /*CCG008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CCG008*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CCG008*/
/**/                                                                  /*CCG008*/
/*  Access PF/SDMMODPD to determine whether UDC module is on.         /*CCG008*/
/**/                                                                  /*CCG008*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*CCG008*/
/*/COPY WNCPYSRC,LEC0702002                                          */
/**/                                                                  /*CCG008*/
/*  Database error handling.                                          /*CCG008*/
/**/                                                                  /*CCG008*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CCG008*/
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDMMODPD')                          /*CCG008*/
                GOTO       CMDLBL(ERROR)                              /*CCG008*/
             ENDDO                                                    /*CCG008*/
/*/COPY WNCPYSRC,LEC0702005                                          */
 
/* Clear down extract files */
             CLRPFM     FILE(LENXTAA)
/**/                                                                  /*CCG008*/
/**********  IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)    */            /*CCG008 CLE075BO*/
/**********  CPYF       FROMFILE(LENXTAB) TOFILE(QTEMP/XLENXTAB) + */                   /*CLE075BO*/
/**********                MBROPT(*REPLACE) CRTFILE(*YES)          */            /*CCG008 CLE075BO*/
/**********  ENDDO                                                 */            /*CCG008 CLE075BO*/
/**********  ELSE (DO)                                             */            /*CCG008 CLE075BO*/
             IF         COND(%SST(&FMT 101 1) *NE 'Y') THEN(DO)                         /*CLE075BO*/
             CLRPFM     FILE(LENXTAB)
             ENDDO                                                    /*CCG008*/
/**/                                                                  /*CCG008*/
             CLRPFM     FILE(LENXTAC)
             CLRPFM     FILE(MGF330PD)
 
/**********  RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)             */                   /*CLE075BO*/
 
/**********  CHGVAR     VAR(&PREFIX) VALUE(%SST(&SDSTAT 6 2))      */                   /*CLE075BO*/
/**********  CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')      */                   /*CLE075BO*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LEC0702MP1                                          */
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/****If*Restart,*Remove*Journalled*Changes**************************/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********     IF         COND(&STAT *EQ 'Y') THEN(DO)            */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),********/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)       */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**Retrieve*data*area*CB0180DA*from*QTEMP.**************************/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)   */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**If*data*area*is*not*blank,*calculate*the*job*name,*user*and*no.**/            /*CCB009 CLE075BO*/
/**of*the*previous*run*of*this*component.***************************/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  IF         COND(&CB0180DA *NE ' ') THEN(DO)           */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  CHGVAR     VAR(&CCB009JOB) VALUE(%SST(&CB0180DA 1 10))*/            /*CCB009 CLE075BO*/
/**********  CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10))*/           /*CCB009 CLE075BO*/
/**********  CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6))*/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/***Retrieve*the*most*recent*journal*entry*sequence*number**********/            /*CCB009 CLE075BO*/
/***for*the*specific*job.*******************************************/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +*/                 /*CLE075BO*/
/**********               TOENT(*FIRST) SEARCH(*DESCEND) +         */                   /*CLE075BO*/
/**********               JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +  */                   /*CLE075BO*/
/**********               RTNSEQNBR(&START)                        */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)            */            /*CCB009 CLE075BO*/
/**********  CHGVAR     VAR(&START) VALUE(0)                       */            /*CCB009 CLE075BO*/
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
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
/*******************************************************************/            /*CSC020 CLE075BO*/
/***Determine*starting*journal*sequence*number*of*job.**************/            /*CSC020 CLE075BO*/
/*******************************************************************/            /*CSC020 CLE075BO*/
/**********  SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +        */                   /*CLE075BO*/
/**********               JOB(&CCB009JOB) USER(&CCB009USR) +       */                   /*CLE075BO*/
/**********               NUMBER(&CCB009NBR) SEQ(&FINISH)          */            /*CSC020 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/***Remove*journaled*changes.***************************************/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +*/                   /*CLE075BO*/
/**********               THEN(DO)                                 */            /*CCB009 CLE075BO*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((CLOANCL) (MGOREFPD) +     */                   /*CLE075BO*/
/**********               (MGOMSGPD) (CFFEEDPD) (MGOEXTPD)) +      */                   /*CLE075BO*/
/**********               FROMENT(&START) TOENT(&FINISH)           */            /*183583 CLE075BO*/
/**********               (MGOMSGPD) (CFFEEDPD)) FROMENT(&START) + */ /*183583*/
/**********               TOENT(&FINISH) */                    /*CCB009 183583*/
/**********  MONMSG     MSGID(CPF0000 MCH0000)                     */            /*CCB009 CLE075BO*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((MGHISTPD)) +              */                   /*CLE075BO*/
/**********               FROMENT(&START) TOENT(&FINISH)           */            /*190127 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000 MCH0000)                     */            /*190127 CLE075BO*/
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
/**********  ELSE       CMD(DO)                                    */            /*CCB009 CLE075BO*/
/**********  RMVJRNCHG  JRN(JLEC0702) FILE((CLOANCL) (MGOREFPD) +  */                   /*CLE075BO*/
/**********               (MGOMSGPD) (CFFEEDPD) (MGOEXTPD))        */            /*183583 CLE075BO*/
/**********               (MGOMSGPD) (CFFEEDPD)) */            /*CCB009 183583*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*CCB009 CLE075BO*/
/**********  RMVJRNCHG  JRN(JLEC0702) FILE((MGHISTPD))             */            /*190127 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*190127 CLE075BO*/
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
 
                                                           /* E29371 */
 /***********CRTJRNRCV  JRNRCV(&JLIB/TEMPRCV)               */
/************CRTJRNRCV  JRNRCV(&JLIB/LETEMPRCV)****************/      /*CCB009*/
 /***********CRTJRN     JRN(&JLIB/TEMPJRN) JRNRCV(TEMPRCV)  */
/************CRTJRN     JRN(&JLIB/LETEMPJRN) JRNRCV(LETEMPRCV)*/      /*CCB009*/
 
/*******************************************************************/            /*CCB009 CLE075BO*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */            /*CCB009 CLE075BO*/
/**********  ENDJRNPF   FILE(*ALL) JRN(JLEC0702)                   */            /*CCB009 CLE075BO*/
/**********  MONMSG MSGID(CPF0000)                                 */            /*CCB009 CLE075BO*/
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  ENDCMTCTL                                             */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCM0000)             */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */            /*CCB009 CLE075BO*/
/**********  DLTJRN     JRN(JLEC0702)                              */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000)                             */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  CHGJOB     INQMSGRPY(*DFT)                            */            /*CCB009 CLE075BO*/
/**********  DLTJRNRCV  JRNRCV(JRLEC0702)                          */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000)                             */            /*CCB009 CLE075BO*/
/**********  CHGJOB     INQMSGRPY(*RQD)                            */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRLEC0702)                    */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  CRTJRN     JRN(&JLIB/JLEC0702) JRNRCV(&JLIB/JRLEC0702)*/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
 /***********STRJRNPF   FILE(CLOANCL MGOREFPD MGOMSGPD MGF330PD +
 /***********             CFFEEDPD) JRN(TEMPJRN) IMAGES(*BOTH) +
 /***********             OMTJRNE(*NONE)                    */
 
/************STRJRNPF   FILE(CLOANCL MGOREFPD MGOMSGPD MGF330PD +
/************             CFFEEDPD) JRN(LETEMPJRN) IMAGES(*BOTH) +
/************             OMTJRNE(*NONE)                              /*087362*/
                                                                      /*087362*/
/***RETRY:**********************************************************/            /*087362 CLE075BO*/
/*********STRJRNPF   FILE(CLOANCL) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(CLOANCL) JRN(JLEC0702) IMAGES(*BOTH) +   */                   /*CLE075BO*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 CLE075BO*/
/*********STRJRNPF   FILE(MGOREFPD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(MGOREFPD) JRN(JLEC0702) IMAGES(*BOTH) +  */                   /*CLE075BO*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 CLE075BO*/
/*********STRJRNPF   FILE(MGOMSGPD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(MGOMSGPD) JRN(JLEC0702) IMAGES(*BOTH) +  */                   /*CLE075BO*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 CLE075BO*/
/*********STRJRNPF   FILE(MGOEXTPD) JRN(JLEC0702) IMAGES(*BOTH) +  */                   /*CLE075BO*/
/**********               OMTJRNE(*NONE)                           */            /*183583 CLE075BO*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*183583 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*183583 CLE075BO*/
/*********STRJRNPF   FILE(MGF330PD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(MGF330PD) JRN(JLEC0702) IMAGES(*BOTH) +  */                   /*CLE075BO*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 CLE075BO*/
/*********STRJRNPF   FILE(CFFEEDPD) JRN(LETEMPJRN) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)*****************/ /*087362*/ /*CCB009*/
/*********STRJRNPF   FILE(CFFEEDPD) JRN(JLEC0702) IMAGES(*BOTH) +  */                   /*CLE075BO*/
/**********               OMTJRNE(*NONE)                           */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*087362 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*087362 CLE075BO*/
/*********STRJRNPF   FILE(MGHISTPD) JRN(JLEC0702) IMAGES(*BOTH) +  */                   /*CLE075BO*/
/**********               OMTJRNE(*NONE)                           */            /*190127 CLE075BO*/
/**********  MONMSG     MSGID(CPF7030)                             */            /*190127 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))  */            /*190127 CLE075BO*/
/***COPY WNCPYSRC,LEC0702003                                       */                   /*CLE075BO*/
/*******************************************************************/            /*087362 CLE075BO*/
/**********  GOTO       CMDLBL(BYPASS)                             */            /*087362 CLE075BO*/
/*******************************************************************/            /*087362 CLE075BO*/
/***JRNFAIL:********************************************************/            /*087362 CLE075BO*/
/*******************************************************************/            /*087362 CLE075BO*/
/**********  CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)              */            /*087362 CLE075BO*/
/**********  IF         COND(&COUNT *LE 3) THEN(DO)                */            /*087362 CLE075BO*/
/**********  DLYJOB     DLY(60)                                    */            /*087362 CLE075BO*/
/**********  GOTO       CMDLBL(RETRY)                              */            /*087362 CLE075BO*/
/**********  ENDDO                                                 */            /*087362 CLE075BO*/
/**********  ELSE       CMD(DO)                                    */            /*087362 CLE075BO*/
/**********  GOTO       CMDLBL(ERROR)                              */            /*087362 CLE075BO*/
/**********  ENDDO                                                 */            /*087362 CLE075BO*/
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
/***BYPASS:*********************************************************/            /*087362 CLE075BO*/
                                                           /* E29371 */
 
/* Begin commitment control */
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF0000)
 
/**********  CHGVAR     VAR(&STAT) VALUE('Y')                      */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/* Zero switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(10000000)
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD AS400 LOCAL DATA AREA +
                          EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
/* Produce confirmation extract LENXT */
/* U4 - LE SWIFT Extract File Details */
             CHGJOB     SWS(XXX1XXXX)
/*/COPY WNCPYSRC,LEC0702008                                          */
/**/                                                                 /*S01465*/
/* Access the SAR file to determine if the switchable feature for */ /*S01465*/
/* S01465 is on                                                   */ /*S01465*/
/**/                                                                 /*S01465*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                  /*S01465*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                  /*S01465*/
             CHGVAR     VAR(&SAR) VALUE('S01465')                    /*S01465*/
/*/COPY WNCPYSRC,LEC0702011                                          */
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) /*S01465*/
/*/COPY WNCPYSRC,LEC0702007                                          */
             IF         COND(&RTCD *EQ '       ') THEN(+
                CALL       PGM(LE1160))                              /*S01465*/
/*/COPY WNCPYSRC,LEC0702006                                          */
             ELSE       CMD(CALL PGM(LE0420))                        /*S01465*/
/************CALL PGM(LE0420)                                     */ /*S01465*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmation print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF COND(%SST(&MMOD 28 1) *EQ 'Y') THEN(DO)
 
             OVRDBF     FILE(MGOREFPD) SHARE(*NO)
             CALL       PGM(LE4505)   /* COMIT LOANS ONLY */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmation extract failure')
/**********  IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)    */            /*CCG008 CLE075BO*/
/**********  CPYF       FROMFILE(XLENXTAB) TOFILE(LENXTAB) +       */                   /*CLE075BO*/
/**********               MBROPT(*REPLACE)                         */            /*CCG008 CLE075BO*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +*/                  /*CLE075BO*/
/**********               FILE(LEEXTAB))                           */            /*CCG008 CLE075BO*/
/**********  ENDDO                                                 */            /*CCG008 CLE075BO*/
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* GDFs records are deleted as they are processed */
/*/COPY WNCPYSRC,LEC0702009                                          */
 
/* Process call loan/deposits */
             CALL       PGM(MG0330)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Call loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,LEC0702010                                          */
 
/* If ISO confirmations required print messages */
             RCVF
             IF         COND(&ENFFCR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             CALL PGM(ME0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ISO print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             ENDDO
 
             COMMIT                                                                     /*MD021577*/
                                                                                        /*MD021577*/
             GOTO       CMDLBL(END)
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmations generation +
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
 
                                                           /* E29371 */
/*******************************************************************/            /*CCB009 CLE075BO*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),********/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)       */            /*CCB009 CLE075BO*/
/**/                                                                  /*CCB009*/
/*  Retrieve attributes of current job.                            */ /*CCB009*/
/**/                                                                  /*CCB009*/
/**********  RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +         */                   /*CLE075BO*/
/**********               NBR(&CCB009NBR)                          */            /*CCB009 CLE075BO*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CLE075BO*/
/**/                                                                  /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
/**********  RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +*/                 /*CLE075BO*/
/**********               TOENT(*FIRST) SEARCH(*DESCEND) +         */                   /*CLE075BO*/
/**********               JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +  */                   /*CLE075BO*/
/**********               RTNSEQNBR(&START)                        */            /*CCB009 CLE075BO*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*CLE075BO*/
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
/**********  SCRTVJCMP  COMP(&CNAM) CSEQ(&CSEQ) FLAG('S') +        */                   /*CLE075BO*/
/**********               JOB(&CCB009JOB) USER(&CCB009USR) +       */                   /*CLE075BO*/
/**********               NUMBER(&CCB009NBR) SEQ(&FINISH)          */            /*CSC020 CLE075BO*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CLE075BO*/
/**/                                                                  /*CCB009*/
/*  Remove journaled changes.                                      */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((CLOANCL) (MGOREFPD) +     */                   /*CLE075BO*/
/**********               (MGOMSGPD) (CFFEEDPD) (MGOEXTPD)) +      */                   /*CLE075BO*/
/**********               FROMENT(&START) TOENT(&FINISH)           */            /*183583 CLE075BO*/
/**********               (MGOMSGPD) (CFFEEDPD)) FROMENT(&START) + */ /*183583*/
/**********               TOENT(&FINISH)                       /*CCB009 183583*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*CCB009 CLE075BO*/
/**********  RMVJRNCHG  JRN(ICJRN) FILE((MGHISTPD)) +              */                   /*CLE075BO*/
/**********               FROMENT(&START) TOENT(&FINISH)           */            /*190127 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*190127 CLE075BO*/
             RMVJRNCHG  JRN(ICJRN) FILE((CLOANCL) (MGOREFPD) +
                          (MGOMSGPD) (CFFEEDPD) (MGOEXTPD) +
                          (MGHISTPD)) RCVRNG(&SJRNRCVR &FJRNRCVR) +
                          FROMENT(&START) TOENT(&FINISH)                                /*CLE075BO*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*CLE075BO*/
                                                                                        /*CLE075BO*/
             IF COND(%SST(&MMOD 28 1) *EQ 'Y') THEN(DO)                                 /*CLE075BO*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                         /*CLE075BO*/
             RMVJRNCHG  JRN(ICJRN) FILE((LENXTAB)) RCVRNG(&SJRNRCVR +
                          &FJRNRCVR) FROMENT(&START) TOENT(&FINISH)                     /*CLE075BO*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEEXTAB))                                                /*CLE075BO*/
             ENDDO                                                                      /*CLE075BO*/
             ENDDO                                                                      /*CLE075BO*/
             ENDDO                                                    /*CCB009*/
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
/**********  ELSE       CMD(DO)                                    */            /*CCB009 CLE075BO*/
 /*          RMVJRNCHG  JRN(TEMPJRN) FILE((CLOANCL) (MGOREFPD) +
                          (MGOMSGPD) (CFFEEDPD))    */
 
/************RMVJRNCHG  JRN(LETEMPJRN) FILE((CLOANCL) (MGOREFPD) +
                          (MGOMSGPD) (CFFEEDPD))********************/ /*CCB009*/
/**********  RMVJRNCHG  JRN(JLEC0702) FILE((CLOANCL) (MGOREFPD) +  */                   /*CLE075BO*/
/**********               (MGOMSGPD) (CFFEEDPD) (MGOEXTPD))        */            /*183583 CLE075BO*/
/**********               (MGOMSGPD) (CFFEEDPD)) */            /*CCB009 183583*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*CLE075BO*/
/**********  RMVJRNCHG  JRN(JLEC0702) FILE((MGHISTPD))             */            /*190127 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */            /*190127 CLE075BO*/
/***COPY WNCPYSRC,LEC0702004                                       */                   /*CLE075BO*/
                                                           /* E29371 */
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
 
/* Reset busy flag in LESTAT */
 END:        ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD)) WAIT(32000)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(LESTAT (6 1)) VALUE('N')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/*******************************************************************/            /*CCB009 CLE075BO*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)       */            /*CCB009 CLE075BO*/
                                                           /* E29371 */
 /*          ENDJRNPF   FILE(*ALL) JRN(&JLIB/TEMPJRN)       */
/************ENDJRNPF   FILE(*ALL) JRN(&JLIB/LETEMPJRN)     */        /*CCB009*/
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/JLEC0702)             */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*CLE075BO*/
                                                           /* E29371 */
/**********  ENDDO                                                 */            /*CCB009 CLE075BO*/
             CHGJOB     INQMSGRPY(*DFT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
                                                           /* E29371 */
 /*          DLTJRN     JRN(&JLIB/TEMPJRN)                  */
/************DLTJRN     JRN(&JLIB/LETEMPJRN)               */         /*CCB009*/
/**********  DLTJRN     JRN(&JLIB/JLEC0702)                        */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*CLE075BO*/
 /*          DLTJRNRCV  JRNRCV(&JLIB/TEMPRCV)               */
/************DLTJRNRCV  JRNRCV(&JLIB/LETEMPRCV)            */         /*CCB009*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRLEC0702)                    */            /*CCB009 CLE075BO*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                   /*CLE075BO*/
                                                           /* E29371 */
 
/* CLEAR FILES NO LONGER NEEDED                                     */
/**/
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
                CLRPFM     FILE(CONFSHH)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CLRPFM     FILE(CONFSDK)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                CLRPFM     FILE(CONFSZX)
                MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/**/
             CLRPFM     FILE(LENXTAA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(LENXTAC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGF330PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**********      CHGVAR     VAR(&STAT) VALUE('N')                  */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
/**********      CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)    */            /*CCB009 CLE075BO*/
/*******************************************************************/            /*CCB009 CLE075BO*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
/**********  SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +      */                   /*CLE075BO*/
/**********               TEXT(&STEXT)                             */            /*CSC020 CLE075BO*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*CLE075BO*/
             RETURN                                                                       /*CSC020*/
/**********  ENDPGM    */                                                                 /*CLE134*/
ENDPGM:      ENDPGM                                                                       /*CLE134*/
