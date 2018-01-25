/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Close of business confirmations')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - DEALING MODULE                                      */
/*                                                                   */
/*       DLC0603 - CLOSE OF BUSINESS CONFIRMATION PROCESSING         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD041958           Date 11Dec17              */
/*       Prev Amend No. MD031243           Date 06Nov14              */
/*                      CSW214             Date 25Nov14              */
/*                      MD030111           Date 28Aug14              */
/*                      MD028093           Date 03Jul14              */
/*                      MD022405           Date 16Sep13              */
/*                      CSW213             Date 03Jun13              */
/*                      CMG003             Date 04Oct12              */
/*                      AR1077561          Date 08Feb13              */
/*                      CLE134             Date 01Aug12              */
/*                      CER059             Date 19Jul10              */
/*                      BUG23123           Date 09Mar09              */
/*                      CER040             Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSW208             Date 15Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      232543             Date 06Apr05              */
/*                      CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      183583             Date 11Jun01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      190127             Date 29Mar01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CSW200             Date 21Aug00              */
/*                      CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      171312             Date 04Jan00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CSW097             Date 26May97              */
/*                      CSW011             Date 19MAR97              */
/*                      CSW005             Date 01AUG96              */
/*                      S01408             DATE 14MAY96              */
/*                      090998             DATE 16FEB96              */
/*                      096561             DATE 21DEC95              */
/*                      076411             DATE 06OCT95              */
/*                      S01408             DATE 04MAY95              */
/*                      084318             DATE 07MAR95              */
/*                      086128             DATE 01MAR95              */
/*                      081957             DATE 16JAN95              */
/*                      S01522             DATE 18NOV94              */
/*                      051496             DATE 03MAY94              */
/*                      S01427             DATE 12JUL93              */
/*                      E43951             DATE 30SEP92              */
/*                      E40242                  19JUN92              */
/*                      E29714                  16OCT91              */
/*                      E29371                  10OCT91              */
/*                      S01310                  16APR91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD041958 - DLC0603 MSGW - I/O error detected DAIND          */
/*                  Applied for MD048787                            */
/*       MD031243 - DLC0603 sequence 00001 failed in COB             */
/*       CSW214 - SWIFT Changes 2014                                 */
/*       MD030111 - Incorrect value equated for CSW213 condition     */
/*       MD028093 - No MT341 confirmation was archived on            */
/*                  MGF341TR file                                    */
/*       MD022405 - DLC0603 seq 00001 failed in Day 3 COB           */
/*       CSW213 - SWIFT Changes 2013                                 */
/*       CMG003 - SWIFT MT600 Message Generation                     */
/*       AR1077561 - Cob failure in DLC0606B                         */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23123 - Report: Does not show Retail Account Number      */
/*                          Date is not Midas Standard Date          */
/*                          Period should be actual int. calc. period*/
/*                          Secondary Tax amount is not printed      */
/*                          Added field TSSLID                       */
/*                          (Recompile)                              */
/*       CER040 - Consolidated MM Deal Confirmation Correspondence   */
/*                (upgFGE097)                                        */
/*       CSW208 - SWIFT 2008 Changes                                 */
/*       232543 - Fix to CGL031                                      */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       183583 - Journal the new PF/MGOEXTPD to resolve the problem */
/*                with several customers having the same SWIFT ID.   */
/*       190127 - Journal MGHISTPD                                   */
/*       CSW200 - SWIFT 2000 changes                                 */
/*       CCB009 - Journal files throughout close of business         */
/*       171312 - CSW097/CSW005 fix - clear and joournal             */
/*                MGX36NPD and MGY36NPD                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CSW097 - SWIFT 1997 Changes                                 */
/*       CSW011 - Generate FRA MT34n messages only                   */
/*       CSW005 - FRA/IRS MG34n and MG36n Message Generation.        */
/*       S01408 - Addition Of Core Hook DLC0603002                   */
/*                Addition of Core Hook DLC0603001                   */
/*       090998 - Change 088675 causes a FOOB error in DL1705.       */
/*                A new logical file DLIND2 has been created and     */
/*                should be used instead of DLIND.                   */
/*       096561 - Add BRCA at start of processing order.             */
/*       076411 - Override  file CLOAN with SHARE(*NO)               */
/*                paramenter to prevent commitment control error     */
/*                on call to MG9210. Patterned after GEMS fix 041062.*/
/*       S01408 - Addition Of Core Hook DLC0603MP1                   */
/*       084318 - When CFC0180 fails, do error processing so that    */
/*                there are no problems when component restarted.    */
/*                Similar processing is also put in for MEC0890.     */
/*              - Got I/O error CPF5129 in MG9205 updating DEALS.    */
/*                DLC0603 opens DEALS SHARE(*YES) input only.        */
/*                MG9205 tries to open DEALS for update. This is     */
/*                ignored creating the error. Need SHARE(*NO).       */
/*       086128 - Move CG extract to CGC2220                         */
/*       081957 - RCLRSC before ENDJRNPF                             */
/*       S01522 - USER DEFINED CORRESPONDENCE                        */
/*       051496 - Change confirmation sequence to processing sequence*/
/*       S01427 - R10 CHIPS INCORPORATION                            */
/*       E43951 - Add journalling to journal CFCHSRPD                */
/*       E40242 - Call MEC0890 to produce audit list of messages     */
/*                generated                                          */
/*       E29714 - To prevent a Commitment Control failure in the case*/
/*                of a shared open, MGOREFL0 must be overridden to   */
/*                SHARE(*NO).                                        */
/*       S01310 - Re written for SWIFT rationalisation               */
/*       E29371 - Rename TEMPJRN to avoid allocation clash           */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*CCB009*/
             PGM        PARM(&CNAM &CSEQ)                             /*CCB009*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,DLC0603009                                          */
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
/*/COPY WNCPYSRC,DLC0603010                                          */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01522*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*S01522*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CSW005*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CSW005*/
             DCL        VAR(&CSW005) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW005*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE('N')                      /*AR1077561*/
/*/COPY WNCPYSRC,DLC0603003                                          */
             DCL        VAR(&CER040) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CER040*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CER040*/
             DCL        VAR(&DATA)   TYPE(*CHAR) LEN(50)                                  /*CER040*/
/**/                                                                                      /*CER040*/
             DCL        VAR(&CSW011) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW011*/
             DCL        VAR(&CSW097) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW097*/
             DCL        VAR(&CSW200) TYPE(*CHAR) LEN(6)               /*CSW200*/
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
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                    /*CSC020*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(50)                                   /*CSC020*/
             DCL        VAR(&CSW2008) TYPE(*CHAR) LEN(7) VALUE('       ')                 /*CSW208*/
             DCL        VAR(&CSW2013) TYPE(*CHAR) LEN(7) VALUE('       ')                 /*CSW213*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)                                    /*CSW213*/
                                                                                          /*CSW208*/
             DCL        VAR(&CMG003) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CMG003*/
                                                                                          /*CMG003*/
/*/COPY WNCPYSRC,DLC0603018                                          */
 
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                          /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                          TEXT(&STEXT)                                                    /*CSC020*/
/* Notify MRUNQ & create temporary journal */
             SNDPGMMSG  MSG('CoB Confirmations Generation') +
                          TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,DLC0603004                                          */
 
/* Clear down extract files */
/* */                                                                 /*086128*/
/* Only Clear ECONX if UDC not installed   */                         /*086128*/
/* */                                                                 /*086128*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*086128*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*086128*/
/* */                                                                 /*086128*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*086128*/
/* */                                                                 /*086128*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*086128*/
/* */                                                                 /*086128*/
/** Database error handling                                           /*086128*/
/* */                                                                 /*086128*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*086128*/
             SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*086128*/
             GOTO       CMDLBL(ERROR)                                 /*086128*/
             ENDDO                                                    /*086128*/
                                                                      /*086128*/
/**/                                                                  /*CSW097*/
/* Check if switchable feature CSW097 is on */                        /*CSW097*/
/**/                                                                  /*CSW097*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW097*/
             CALL       PGM(SWIFT97) PARM(&RTCD)                      /*CSW097*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)       /*CSW097*/
             SNDPGMMSG  MSG('Call to SWIFT97 program failed.') +
                          TOPGMQ(*EXT)                                /*CSW097*/
                GOTO       CMDLBL(ERROR)                              /*CSW097*/
             ENDDO                                                    /*CSW097*/
             IF         COND(&RTCD *EQ 'CSW097') THEN( +
             CHGVAR     VAR(&CSW097) VALUE('Y'))                      /*CSW097*/
/**/                                                                  /*CSW005*/
/* Check if switchable feature CSW005 is on */                        /*CSW005*/
/**/                                                                  /*CSW005*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW005*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSW005*/
             CHGVAR     VAR(&SAR) VALUE('CSW005')                     /*CSW005*/
             CHGVAR     VAR(&SCSARD) VALUE(' ')                       /*CSW005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CSW005*/
             IF         COND(&RTCD *EQ '      ') THEN( +
             CHGVAR     VAR(&CSW005) VALUE('Y'))                      /*CSW005*/
/**/                                                                  /*CSW011*/
/* Check if switchable feature CSW011 is on */                        /*CSW011*/
/**/                                                                  /*CSW011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSW011*/
             CHGVAR     VAR(&SAR) VALUE('CSW011')                     /*CSW011*/
             CHGVAR     VAR(&SCSARD) VALUE(' ')                       /*CSW011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CSW011*/
             IF         COND(&RTCD *EQ '      ') THEN( +
             CHGVAR     VAR(&CSW011) VALUE('Y'))                      /*CSW011*/
/**/                                                                                      /*CER040*/
/* Check if if CER040 is Enabled or Not */                                                /*CER040*/
/**/                                                                                      /*CER040*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CER040*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER040*/
             CHGVAR     VAR(&SAR) VALUE('CER040')                                         /*CER040*/
             CHGVAR     VAR(&SCSARD) VALUE(' ')                                           /*CER040*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)                      /*CER040*/
             IF         COND(&RTCD *EQ '      ') THEN(DO)
             CHGVAR     VAR(&CER040) VALUE('Y')                                           /*CER040*/
             ENDDO
             ELSE (DO)                                                                    /*CER040*/
             CHGVAR     VAR(&CER040) VALUE('N')                                           /*CER040*/
             ENDDO                                                                        /*CER040*/
/*/COPY WNCPYSRC,DLC0603025                                          */
                                                                      /*CSW011*/
/**/                                                                  /*CSW200*/
/* Check if switchable feature CSW200 is on */                        /*CSW200*/
/**/                                                                  /*CSW200*/
             CALL       PGM(SWIF2000) PARM(&CSW200)                   /*CSW200*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)       /*CSW200*/
             SNDPGMMSG  MSG('Call to SWIFT2000 program failed.') +
                          TOPGMQ(*EXT)                                /*CSW200*/
                GOTO       CMDLBL(ERROR)                              /*CSW200*/
             ENDDO                                                    /*CSW200*/
                                                                      /*CSW200*/
/* Check if switchable feature CSW208 is on */                                            /*CSW208*/
             CALL       PGM(SWIF2008) PARM(&CSW2008)                                      /*CSW208*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)                           /*CSW208*/
             SNDPGMMSG  MSG('Call to SWIFT2008 program failed.') +
                          TOPGMQ(*EXT)                                                    /*CSW208*/
                GOTO       CMDLBL(ERROR)                                                  /*CSW208*/
             ENDDO                                                                        /*CSW208*/
/*/COPY WNCPYSRC,DLH00173                                            */
                                                                                          /*CSW208*/
/** Check if switchable feature CMG003 is on */                                           /*CMG003*/
                                                                                          /*CMG003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CMG003*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CMG003*/
             CHGVAR     VAR(&SAR) VALUE('CMG003')                                         /*CMG003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)                      /*CMG003*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CMG003) VALUE('Y'))                                          /*CMG003*/
                                                                      /*CSW005*/
/* */                                                                 /*086128*/
             IF         COND(%SST(&FMT 101 1) *NE 'Y') THEN(DO)       /*086128*/
             CLRPFM     FILE(ECONXCY)
             CLRPFM     FILE(ECONXCZ)
             ENDDO                                                    /*086128*/
             CLRPFM     FILE(MGF300PD)
             CLRPFM     FILE(MGF600PD)                                                    /*CMG003*/
             CLRPFM     FILE(MGF320PD)
                                                                                          /*CSW208*/
             IF         COND(&CSW2008 *EQ 'CSW2008') THEN( +
                          CLRPFM FILE(MGX320PD))                                          /*CSW208*/
                                                                                          /*CSW208*/
             CLRPFM     FILE(MGF321PD)
/**/                                                                  /*CSW200*/
/* If switchable feature CSW200 is off clear MGF324PD and MGF335PD */ /*CSW200*/
/**/                                                                  /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             CLRPFM     FILE(MGF324PD)
             CLRPFM     FILE(MGF335PD)                                /*CSW200*/
             ENDDO                                                    /*CSW200*/
/**/                                                                  /*CSW200*/
             CLRPFM     FILE(MGF330PD)
/*********** CLRPFM     FILE(MGF335PD)                                 *CSW200*/
             CLRPFM     FILE(MGF350PD)
/**/                                                                  /*CSW005*/
/* If switchable feature CSW005 is on then clear the ff. files */     /*CSW005*/
/**/                                                                  /*CSW005*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                /*CSW005*/
             CLRPFM     FILE(MGF341PD)                                /*CSW005*/
             CLRPFM     FILE(MGF362PD)                                /*CSW005*/
             CLRPFM     FILE(MGX36NPD)                                /*171312*/
             CLRPFM     FILE(MGY36NPD)                                /*171312*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
/**/                                                                  /*CSW011*/
/* If switchable feature CSW011 is on then clear MGF341PD *           /*CSW011*/
/**/                                                                  /*CSW011*/
             IF         COND((&CSW011 *EQ 'Y') *AND (&CSW005 *NE +
                          'Y')) THEN(CLRPFM FILE(MGF341PD))           /*CSW011*/
                                                                      /*CSW011*/
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
 
             CHGVAR     VAR(&PREFIX) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC0603MP1                                          */
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
             RMVJRNCHG  JRN(ICJRN) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD) (CFFEEDPD) +
                          (CFCHSRPD) (ECONXCY) (ECONXCZ) (MGOEXTPD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*183583*/
/**********               (CFCHSRPD) (ECONXCY) (ECONXCZ)) + */        /*183583*/
/**********               FROMENT(&START) TOENT(&FINISH)    */ /*CCB009 183583*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((MGHISTPD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*190127*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*190127*/
             RMVJRNCHG  JRN(ICJRN) FILE((SDCSINPD)) +
                          FROMENT(&START) TOENT(&FINISH)                                  /*232543*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*232543*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
             RMVJRNCHG  JRN(JDLC0603) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD) (CFFEEDPD) +
                          (CFCHSRPD) (ECONXCY) (ECONXCZ) (MGOEXTPD))  /*183583*/
/***********              (CFCHSRPD) (ECONXCY) (ECONXCZ)) */   /*CCB009 183583*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB009*/
             RMVJRNCHG  JRN(JDLC0603) FILE((MGHISTPD))                /*190127*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*190127*/
             RMVJRNCHG  JRN(JDLC0603) FILE((SDCSINPD))                                    /*232543*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*232543*/
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
             ENDJRNPF   FILE(*ALL) JRN(JDLC0603)                      /*CCB009*/
             MONMSG MSGID(CPF0000)                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
/**/                                                                  /*CCB009*/
             ENDCMTCTL                                                /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCM0000)                /*CCB009*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             DLTJRN     JRN(JDLC0603)                                 /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
/**/                                                                  /*CCB009*/
             CHGJOB     INQMSGRPY(*DFT)                               /*CCB009*/
             DLTJRNRCV  JRNRCV(JRDLC0603)                             /*CCB009*/
             MONMSG     MSGID(CPF0000)                                /*CCB009*/
             CHGJOB     INQMSGRPY(*RQD)                               /*CCB009*/
/**/                                                                  /*CCB009*/
             CRTJRNRCV  JRNRCV(&JLIB/JRDLC0603)                       /*CCB009*/
/**/                                                                  /*CCB009*/
             CRTJRN     JRN(&JLIB/JDLC0603) JRNRCV(&JLIB/JRDLC0603)   /*CCB009*/
/**/                                                                  /*CCB009*/
 
/*           STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
                          DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
                          MGOREFPD MGOMSGPD MGF300PD MGF350PD +
                          MGF320PD MGF321PD MGF324PD MGF330PD +
                          MGF335PD CFFEEDPD) JRN(TEMPJRN) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)      */
 
/************STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
                          DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
                          MGOREFPD MGOMSGPD MGF300PD MGF350PD +
                          MGF320PD MGF321PD MGF324PD MGF330PD +
                          MGF335PD CFFEEDPD) JRN(DLTEMPJRN) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)           E29371E43951*/
 
/************STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
                          DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
                          MGOREFPD MGOMSGPD MGF300PD MGF350PD +
                          MGF320PD MGF321PD MGF324PD MGF330PD +
                          MGF335PD CFFEEDPD CFCHSRPD) JRN(DLTEMPJRN) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)           E43951*086128*/
 
/**********  STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
/**********               DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
/**********               MGOREFPD MGOMSGPD MGF300PD MGF350PD +
/**********               MGF320PD MGF321PD MGF324PD MGF330PD +
/**********               MGF335PD CFFEEDPD CFCHSRPD ECONXCY +
/**********               ECONXCZ) JRN(DLTEMPJRN) IMAGES(*BOTH) +
/**********               OMTJRNE(*NONE)*****************/ /*086128*/ /*CCB009*/
/**********  STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
/**********               DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
/**********               MGOREFPD MGOMSGPD MGF300PD MGF350PD +
/**********               MGF320PD MGF321PD MGF324PD MGF330PD +
/**********               MGF335PD CFFEEDPD CFCHSRPD ECONXCY +
/**********               ECONXCZ) JRN(JDLC0603) IMAGES(*BOTH) +
/**********               OMTJRNE(*NONE)*****************/ /*CCB009*/ /*CSW200*/
/**/                                                                  /*CSW200*/
/**********  STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
                          DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
                          MGOREFPD MGOMSGPD MGF300PD MGF350PD +
                          MGF320PD MGF321PD MGF330PD CFFEEDPD +
                          CFCHSRPD ECONXCY ECONXCZ MGOEXTPD) +
                          JRN(JDLC0603) IMAGES(*BOTH) OMTJRNE(*NONE)  */      /*183583*/ /*CMG003*/
             STRJRNPF   FILE(DEALSDA DEALSDB DEALSDC DEALSDD DEALSDE +
                          DEALSDF DEALSDG DEAMSDH DEAMSDI DEAMSDJ +
                          MGOREFPD MGOMSGPD MGF300PD MGF600PD MGF350PD +
                          MGF320PD MGF321PD MGF330PD CFFEEDPD +
                          CFCHSRPD ECONXCY ECONXCZ MGOEXTPD) +
                          JRN(JDLC0603) IMAGES(*BOTH) OMTJRNE(*NONE)                      /*CMG003*/
/***********              CFCHSRPD ECONXCY ECONXCZ) JRN(JDLC0603)+ */ /*183583*/
/***********              IMAGES(*BOTH) OMTJRNE(*NONE) */      /*CSW200 183583*/
             STRJRNPF   FILE(MGHISTPD) JRN(JDLC0603) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)                /*190127*/
             STRJRNPF   FILE(SDCSINPD) JRN(JDLC0603) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)                                    /*232543*/
                                                                                          /*CSW208*/
             STRJRNPF   FILE(MGX320PD) JRN(JDLC0603) +
                          IMAGES(*BOTH) OMTJRNE(*NONE)                                    /*CSW208*/
/**/                                                                  /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             STRJRNPF   FILE(MGF324PD MGF335PD) JRN(JDLC0603) +
                        IMAGES(*BOTH) OMTJRNE(*NONE)                  /*CSW200*/
             ENDDO                                                    /*CSW200*/
/**/                                                                  /*CSW005*/
/* If switchable feature CSW005 is on start journal the ff. files */  /*CSW005*/
/**/                                                                  /*CSW005*/
/************IF         COND(&CSW005 *EQ 'Y') THEN(DO)          *CSW005 CSW011*/
             IF  COND(&CSW005 *EQ 'Y' *OR &CSW011 *EQ 'Y') THEN(DO)   /*CSW011*/
/**********  STRJRNPF   FILE(MGF341PD MGF362PD) +
/**********               JRN(DLTEMPJRN) IMAGES(*BOTH) +
/**********               OMTJRNE(*NONE)*****************/ /*CSW005*/ /*CCB009*/
             STRJRNPF   FILE(MGF341PD MGF362PD) +
                          JRN(JDLC0603) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)                              /*CCB009*/
             ENDDO                                                    /*CSW005*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                /*171312*/
/**********  STRJRNPF   FILE(MGX36NPD MGY36NPD) +
/**********               JRN(DLTEMPJRN) IMAGES(*BOTH) +
/**********               OMTJRNE(*NONE)*****************/ /*171312*/ /*CCB009*/
             STRJRNPF   FILE(MGX36NPD MGY36NPD) +
                          JRN(JDLC0603) IMAGES(*BOTH) +
                          OMTJRNE(*NONE)                              /*CCB009*/
             ENDDO                                                    /*171312*/
             ENDDO                                                    /*CCB009*/
                                                                      /*171312*/
 
/*/COPY WNCPYSRC,DLC0603011                                          */
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
/*/COPY WNCPYSRC,DLC0603012                                          */
 
/* Begin commitment control */
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/**/                                                                  /*CCB009*/
/* Zero switches */
/*/COPY WNCPYSRC,DLC0603016                                          */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(10000000)
/*/COPY WNCPYSRC,DLC0603017                                          */
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD AS400 LOCAL DATA AREA +
                          EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/*** *******                                                   *S01522**086128*/
/**User*Defined Correspondence processing  *                   *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** CHGVAR     VAR(&RTCD) VALUE('       ')            *S01522**086128*/
/*********** CHGVAR     VAR(&OPTN) VALUE('*FIRST ')            *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/***Access*PF/SDMMODPD to determine whether UDC module is on   *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)   *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/***Database error handling                                    *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** IF         COND(&RTCD *NE '       ') THEN(DO)     *S01522**086128*/
/*********** SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD') +  *086128*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +          *086128*/
/***********              MSGTYPE(*INFO)                       *S01522**086128*/
/*********** GOTO       CMDLBL(ERROR)                          *S01522**086128*/
/*********** ENDDO                                             *S01522**086128*/
/***********                                                   *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)*S01522**086128*/
/***  ******                                                   *S01522**086128*/
/**Journal*Dealing files temporarily *                         *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** STRJRNPF   FILE(DLINDDM DAINDDL ECONXCY ECONXCZ) +        *086128*/
/***********              JRN(CGCOBJRN) IMAGES(*BOTH)          *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** CALL       PGM(CG4100) PARM(&W0RTN &W0CMT)        *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/**End*Journal Dealing files temporarily                       *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** RCLRSC                                            *081957**086128*/
/*********** ENDJRNPF   FILE(DLINDDM DAINDDL ECONXCY ECONXCZ) +        *086128*/
/***********              JRN(CGCOBJRN)                        *S01522**086128*/
                                                                      /*S01522*/
/*********** RCLRSC                                          /*S01522* *081957*/
/*********** ENDCMTCTL                                         *S01522**086128*/
/*********** STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))      *S01522**086128*/
/***********                                                   *S01522**086128*/
/*********** IF         COND(&W0RTN *NE '       ') THEN(DO)    *S01522**086128*/
/*********** CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence + *086128*/
/***********              Extract failure')                    *S01522**086128*/
/*********** ROLLBACK                                          *081957**086128*/
/*********** GOTO       CMDLBL(ERROR)                          *S01522**086128*/
/*********** ENDDO                                             *S01522**086128*/
/*********** ENDDO                                             *S01522**086128*/
 
/*/COPY WNCPYSRC,DLC0603005                                          */
                IF         COND(&CER040 *EQ 'Y') THEN(DO)                                 /*CER040*/
                  CLRPFM     FILE(DLDABRPD)                                               /*CER040*/
                  CALL       PGM(DL9910)                                                  /*CER040*/
                                                                                          /*CER040*/
                  IF         COND(%SWITCH(XXXXXX1X) *OR +
                               %SWITCH(XXXXXXX1)) THEN(DO)                                /*CER040*/
                       CHGVAR     VAR(&MSG) VALUE('Amendments Cons. Extract +
                                    failure')                                             /*CER040*/
                       GOTO       CMDLBL(ERROR)                                           /*CER040*/
                  ENDDO                                                                   /*CER040*/
                  CLRPFM     FILE(DLDACOPD)                                               /*CER040*/
                  CALL       PGM(DL9911)                                                  /*CER040*/
 
                  IF         COND(%SWITCH(XXXXXX1X) *OR +
                               %SWITCH(XXXXXXX1)) THEN(DO)                                /*CER040*/
                       CHGVAR     VAR(&MSG) VALUE('Amendments Consolidation +
                                    failure')                                             /*CER040*/
                       GOTO       CMDLBL(ERROR)                                           /*CER040*/
                  ENDDO                                                                   /*CER040*/
                ENDDO                                                                     /*CER040*/
/**/                                                                                      /*CER040*/
             OVRDBF     FILE(DAIND) SHARE(*YES)                      /*051496*/
/**********  OPNQRYF    FILE((DAIND *FIRST DTRIEPHF)) KEYFLD((DLNO) +
/**********                  (VDAT) (RRLA) (DASN))   */  /*051496*/  /*096561*/
/**********  OPNQRYF    FILE((DAIND *FIRST DTRIEPHF)) KEYFLD((BRCA) +
                             (DLNO) (VDAT) (RRLA) (DASN)) */                     /*096561 MD041958*/
             OPNQRYF    FILE((DAIND *FIRST DTRIEPHF)) KEYFLD((BRCA) +
                          (DLNO) (VDAT) (RRLA) (DASN)) +
                          IGNDECERR(*YES)                                               /*MD041958*/
             OVRDBF     FILE(DLIND) TOFILE(DLIND2)                   /*090998*/
/* */                                                                /*051496*/
/* Produce confirmation extract ECONX */
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0603001                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
             CALL PGM(DL0195)
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0603002                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
/* */                                                                /*051496*/
             DLTOVR     FILE(DLIND)                                  /*090998*/
             DLTOVR     FILE(DAIND)                                  /*051496*/
             CLOF       OPNID(DAIND)                                 /*051496*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmation print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/*/COPY WNCPYSRC,DLC0603006                                          */
             IF         COND(&CER040 *EQ 'Y') THEN(DO)                                    /*CER040*/
                                                                                          /*CER040*/
/** Call Extract File Instance Management */                                              /*CER040*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CER040*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CER040*/
                                                                                          /*CER040*/
                  CALL       PGM(CG7030) PARM(&W0RTN &W0CMT)                              /*CER040*/
                  RCLRSC                                                                  /*CER040*/
                  IF         COND(%SWITCH(XXXXXX1X) *OR +
                               %SWITCH(XXXXXXX1)) THEN(DO)                                /*CER040*/
                        CHGVAR     VAR(&MSG) VALUE('UDC Consolidated Conf. +
                                     failure')                                            /*CER040*/
                        GOTO       CMDLBL(ERROR)                                          /*CER040*/
                   ENDDO                                                                  /*CER040*/
                                                                                          /*CER040*/
/** Call Custom-Defined Data Extract pgm */                                               /*CER040*/
             CALL       PGM(CGC3604)                                                      /*CER040*/
/* */                                                                                     /*CER040*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CER040*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)                                /*CER040*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CER040*/
             GOTO       CMDLBL(ERROR)                                                     /*CER040*/
             ENDDO                                                                        /*CER040*/
/**/                                                                                      /*CER040*/
                  CALL       PGM(DL9912)                                                  /*CER040*/
                  IF         COND(%SWITCH(XXXXXX1X) *OR +
                               %SWITCH(XXXXXXX1)) THEN(DO)                                /*CER040*/
                       CHGVAR     VAR(&MSG) VALUE('Amendments Consolidation +
                                    failure')                                             /*CER040*/
                       GOTO       CMDLBL(ERROR)                                           /*CER040*/
                  ENDDO                                                                   /*CER040*/
             ENDDO                                                                        /*CER040*/
/**/                                                                                      /*CER040*/
/************IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +        /*S01427*/
/************             THEN(CALL PGM(CHC0603))                     /*S01427*/
 
             IF         COND((%SUBSTRING(&MMOD 41 1) *EQ 'Y') *AND             +
                             (%SWITCH(XXXXXX00))) THEN(DO)            /*S01427*/
             OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                   /*S01427*/
                           CLRPFM     FILE(*LIBL/CHRXCTT)             /*S01427*/
                           CALL       PGM(CH0060)                     /*S01427*/
             DLTOVR     FILE(TABLE)                                   /*S01427*/
                           ENDDO                                      /*S01427*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('C.H.I.P.S. message +
                          generation failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF COND(%SST(&MMOD 25 1) *EQ 'Y') THEN(DO)
 
             OVRDBF     FILE(MGOREFPD) SHARE(*NO)
/**                                                      START E29714*/
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
/**                                                      END   E29714*/
             OVRDBF     FILE(CLOAN) SHARE(*NO)                        /*076411*/
             OVRDBF     FILE(DEALS) SHARE(*NO)                        /*084318*/
/** If CSW213 is installed, override DEALS file and set  **/                            /*MD022405*/
/**  Share open data path to YES   **/                                                  /*MD022405*/
/**********  IF         COND(&CSW2013 *EQ 'CSW213') THEN( +
             OVRDBF     FILE(DEALS) SHARE(*YES))                   */          /*MD022405 MD030111*/
/**********  IF         COND(&CSW2013 *EQ 'CSW2013') THEN( +                  
             OVRDBF     FILE(DEALS) SHARE(*YES))                   */          /*MD030111 MD031243*/
                                                                                        /*MD022405*/
/**                                                                   /*084318*/
/*/COPY WNCPYSRC,DLC0603015                                          */
             CALL       PGM(DL6310)   /* COMIT DEALS ONLY */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmation extract failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
/**/                                                                  /*CSW005*/
/* If switchable feature CSW005 is on run FRA/IRS msg extract pgm */  /*CSW005*/
/**/                                                                  /*CSW005*/
/************IF         COND((&CSW005 *EQ 'Y') THEN (DO)   /*CSW005*/ /*CSW011*/
             IF         COND((&CSW005 *EQ 'Y') *OR (&CSW011 *EQ +
                          'Y')) THEN(DO)                              /*CSW011*/
                                                                      /*CSW005*/
             CALL       PGM(DL6330)                                   /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*CSW005*/
             CHGVAR     VAR(&MSG) VALUE('FRA/IRS Confirmation +
                          extract failure')                           /*CSW005*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                                        /*MD028093*/
             IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)                           /*MD028093*/
                                                                                        /*MD028093*/
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')                         /*MD028093*/
                                                                                        /*MD028093*/
             CPYF       FROMFILE(MGF300PD) TOFILE(&DMLIB/MGF300TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                    /*MD028093*/
                                                                                        /*MD028093*/
/** If switchable feature CMG003 is on create archiving */                                /*CSW214*/
/** for MGF600PD  */                                                                      /*CSW214*/
                                                                                          /*CSW214*/
             IF         COND(&CMG003 *EQ 'Y') THEN(DO)                                    /*CSW214*/
             CPYF       FROMFILE(MGF600PD) TOFILE(&DMLIB/MGF600TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CSW214*/
             ENDDO                                                                        /*CSW214*/
                                                                                          /*CSW214*/
/** If switchable feature CSW005 is on create archiving for MGF341PD */                 /*MD028093*/
                                                                                        /*MD028093*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                                  /*MD028093*/
             CPYF       FROMFILE(MGF341PD) TOFILE(&DMLIB/MGF341TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                    /*MD028093*/
             ENDDO                                                                      /*MD028093*/
                                                                                        /*MD028093*/
             ENDDO                                                                      /*MD028093*/
                                                                                        /*MD028093*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
 
/* GDFs records are deleted as they are processed */
/*/COPY WNCPYSRC,DLC0603026                                          */
 
/* Process foreign exchange confirmations */
             IF         COND(&CSW097 = 'N') THEN( +
             CALL       PGM(MG0300))                                  /*CSW097*/
             ELSE       CMD(CALL PGM(MG0300A))                        /*CSW097*/
/*********** CALL       PGM(MG0300)                                */ /*CSW097*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Foreign exchange confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process fixed loan/deposit confirmations */
             CALL       PGM(MG0320)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF         COND(&CMG003 *EQ 'Y') THEN(DO)                                    /*CMG003*/
             CALL       PGM(MG000600)                                                     /*CMG003*/
                                                                                          /*CMG003*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Commodity confiramtion +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))                            /*CMG003*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)                                  /*CMG003*/
             ROLLBACK                                                                     /*CMG003*/
             GOTO       CMDLBL(ERROR)                                                     /*CMG003*/
             ENDDO                                                                        /*CMG003*/
             ENDDO                                                                        /*CMG003*/
                                                                                          /*CMG003*/
/* Clear MGX320PD after successful call to MG0320 */                                      /*CSW208*/
             IF         COND(&CSW2008 *EQ 'CSW2008') THEN( +
                          CLRPFM FILE(MGX320PD))                                          /*CSW208*/
                                                                                          /*CSW208*/
/* Process secondary certificate of deposits */
             CALL       PGM(MG0321)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Secondary certificate of deposit +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process liquidation of loan/deposits */
/*                  (only if CSW200 is off)                        */ /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             CALL       PGM(MG0324)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Loan/deposit liquidation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO                                                    /*CSW200*/
 
/* Process call loan/deposits */
             CALL       PGM(MG0330)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Call loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process interest rate change advices */
/*                  (only if CSW200 is off)                        */ /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             CALL       PGM(MG0335)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Interest rate change advice +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO                                                    /*CSW200*/
 
/* Process interest advices */
             CALL       PGM(MG0350)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Interset rate advice +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC0603027                                          */
                                                                      /*CSW005*/
/**/                                                                  /*CSW005*/
/* If switchable feature CSW005 is on run FRA/IRS MG* programs */     /*CSW005*/
/**/                                                                  /*CSW005*/
/************IF         COND(&CSW005 *EQ 'Y') THEN(DO)     /*CSW005*/ /*CSW011*/
             IF         COND((&CSW005 *EQ 'Y') *OR (&CSW011 *EQ +
                          'Y')) THEN(DO)                              /*CSW011*/
                                                                      /*CSW005*/
/* Process FRA settlement confirmations */                            /*CSW005*/
             CALL       PGM(MG0341)                                   /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*CSW005*/
             SNDPGMMSG  MSG('FRA settlement confirmations +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)               /*CSW005*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                /*CSW011*/
/* Process IRS Reset/Advice of Payment */                             /*CSW005*/
             CALL       PGM(MG0362)                                   /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*CSW005*/
             SNDPGMMSG  MSG('IRS Reset/Advice of Payment +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)               /*CSW005*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
             ENDDO                                                    /*CSW011*/
                                                                      /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
 
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
 
/* Call Confirmation matching control program */
/************IF*********COND(%SST(&MMOD 60 1) *EQ 'Y') THEN(CALL +
/*************************PGM(CFC0180))                            */ /*084318*/
             IF  (%SST(&MMOD 60 1) *EQ 'Y') THEN(DO)                  /*084318*/
                  CALL CFC0180                                        /*084318*/
                  IF  (%SWITCH(XXXXXX1X) *OR +
                       %SWITCH(XXXXXXX1)) THEN(DO)                    /*084318*/
                       SNDPGMMSG  MSG('Confirmation matching +
                                   control failure') TOPGMQ(*EXT) +
                                   TOMSGQ(MOPERQ) MSGTYPE(*INFO)      /*084318*/
                       GOTO  ERROR                                    /*084318*/
                       ENDDO                                          /*084318*/
                  ENDDO                                               /*084318*/
                                                                      /*084318*/
/*/COPY WNCPYSRC,DLC0603013                                          */
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
/**********  CALL       PGM(MEC0890) PARM('DL' 'C' 'DLTEMPJRN ' +
/**********               &SDATE &STIME)*****************/ /*E40242*/ /*CCB009*/
             CALL       PGM(MEC0890) PARM('DL' 'C' 'JDLC0603  ' +
                          &SDATE &STIME)                              /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
/*/COPY WNCPYSRC,DLC0603014                                          */
             IF  (%SWITCH(XXXXXX1X) *OR +
                  %SWITCH(XXXXXXX1)) THEN(DO)                         /*084318*/
                  SNDPGMMSG  MSG('Message Generation Audit +
                              Report failure') TOPGMQ(*EXT) +
                              TOMSGQ(MOPERQ) MSGTYPE(*INFO)           /*084318*/
                  GOTO  ERROR                                         /*084318*/
                  ENDDO                                               /*084318*/
 
/* */                                                                 /*086128*/
/* Clear ECONX files */                                               /*086128*/
/* */                                                                 /*086128*/
             CLRPFM     FILE(ECONXCY)                                 /*086128*/
             CLRPFM     FILE(ECONXCZ)                                 /*086128*/
                                                                      /*086128*/
/*/COPY WNCPYSRC,DLC0603019                                          */
/**********                                                        */            /*CSW213 MD028093*/
/**********  IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)      */            /*CSW213 MD028093*/
/**********                                                        */            /*CSW213 MD028093*/
/**********  CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')    */            /*CSW213 MD028093*/
/**********                                                        */            /*CSW213 MD028093*/
/**********  CPYF       FROMFILE(MGF300PD) TOFILE(&DMLIB/MGF300TR) +
                          MBROPT(*ADD) CRTFILE(*YES)               */            /*CSW213 MD028093*/
/**********                                                        */            /*CSW213 MD028093*/
/**If*switchable*feature*CSW005*is*on*create*archiving*for*MGF341PD**/           /*CSW213 MD028093*/
/**********  IF         COND(&CSW005 *EQ 'Y') THEN(DO)             */            /*CSW213 MD028093*/
/**********  CPYF       FROMFILE(MGF341PD) TOFILE(&DMLIB/MGF341TR) +
/**********               MBROPT(*ADD) CRTFILE(*YES)               */            /*CSW213 MD028093*/
/**********  ENDDO                                                 */            /*CSW213 MD028093*/
/**********                                                        */            /*CSW213 MD028093*/
/**********  ENDDO                                                 */            /*CSW213 MD028093*/
/**********                                                        */            /*CSW213 MD028093*/
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
             CHGVAR     VAR(&ERROR) VALUE('Y')                                         /*AR1077561*/
             ENDDO
 
/* If U7/U8 both OFF, must be CPF error - ensure switches ON for */
/* return to CB */
             IF         COND(%SWITCH(XXXXXX00)) THEN(CHGJOB +
                          SWS(XXXXXX11))
 
/*/COPY WNCPYSRC,DLC0603020                                          */
            CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                     /*CER040*/
            CALL       PGM(CGC3605) PARM(&ACTION)                                         /*CER040*/
            IF         COND(&ERROR *EQ 'Y') THEN(DO)                                   /*AR1077561*/
                         CHGJOB SWS(XXXXXX11)                                          /*AR1077561*/
            ENDDO                                                                      /*AR1077561*/
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
             RMVJRNCHG  JRN(ICJRN) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD) (CFFEEDPD) +
                          (CFCHSRPD) (ECONXCY) (ECONXCZ) (MGOEXTPD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*183583*/
/***********              (CFCHSRPD) (ECONXCY) (ECONXCZ)) + */        /*183583*/
/***********              FROMENT(&START) TOENT(&FINISH) */    /*CCB009 183583*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((MGHISTPD)) +
                          FROMENT(&START) TOENT(&FINISH)              /*190127*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*190127*/
             RMVJRNCHG  JRN(ICJRN) FILE((SDCSINPD)) +
                          FROMENT(&START) TOENT(&FINISH)                                  /*232543*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*232543*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
                                                           /* E29371 */
 /*          RMVJRNCHG  JRN(TEMPJRN) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD) (CFFEEDPD)) */
 
/************RMVJRNCHG  JRN(DLTEMPJRN) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD) (CFFEEDPD)) */       /*E43951*/
/* **********RMVJRNCHG  JRN(DLTEMPJRN) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                        (MGOREFPD) (MGOMSGPD) (CFFEEDPD) (CFCHSRPD))  *E43951*/
                                                                     /*086128*/
/**********  RMVJRNCHG  JRN(DLTEMPJRN) FILE((DEALSDA) (DEALSDB) +
/**********               (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
/**********               (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
/**********               (MGOREFPD) (MGOMSGPD) (CFFEEDPD) +
/**********               (CFCHSRPD) (ECONXCY) (ECONXCZ))* /*086128*/ /*CCB009*/
             RMVJRNCHG  JRN(JDLC0603) FILE((DEALSDA) (DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEALSDE) (DEALSDF) +
                          (DEALSDG) (DEAMSDH) (DEAMSDI) (DEAMSDJ) +
                          (MGOREFPD) (MGOMSGPD) (CFFEEDPD) +
                          (CFCHSRPD) (ECONXCY) (ECONXCZ))             /*CCB009*/
/*/COPY WNCPYSRC,DLC0603007                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,DLC0603008                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000 CPI0000)                            /*CER040*/
             RMVJRNCHG  JRN(JDLC0603) FILE((MGHISTPD))                /*190127*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*190127*/
                                                           /* E29371 */
             RMVJRNCHG  JRN(JDLC0603) FILE((SDCSINPD))                                    /*232543*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*232543*/
             ENDDO                                                    /*CCB009*/
 
/* Reset busy flag in DLSTAT */
 END:        ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD)) WAIT(32000)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('N')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
                                                           /* E29371 */
/*/COPY WNCPYSRC,DLC0603021                                          */
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
 /*          ENDJRNPF   FILE(*ALL) JRN(&JLIB/TEMPJRN)       */
/************ENDJRNPF   FILE(*ALL) JRN(&JLIB/DLTEMPJRN)     */        /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/JDLC0603)                /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,DLC0603022                                          */
                                                           /* E29371 */
             CHGJOB     INQMSGRPY(*DFT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
                                                           /* E29371 */
/***********                                                           *086128*/
/*** *******                                                   *S01522**086128*/
/**End*Journal Dealing files temporarily                       *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*********** ENDJRNPF   FILE(DLINDDM DAINDDL ECONXCY ECONXCZ) +        *086128*/
/***********              JRN(CGCOBJRN)                        *S01522**086128*/
/*********** MONMSG     MSGID(CPF0000 RPG0000 MCH0000)         *S01522**086128*/
/*** *******                                                   *S01522**086128*/
/*/COPY WNCPYSRC,DLC0603023                                          */
 /*          DLTJRN     JRN(&JLIB/TEMPJRN)                */
/************DLTJRN     JRN(&JLIB/DLTEMPJRN)              */          /*CCB009*/
             DLTJRN     JRN(&JLIB/JDLC0603)                           /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 /*          DLTJRNRCV  JRNRCV(&JLIB/TEMPRCV)             */
/************DLTJRNRCV  JRNRCV(&JLIB/DLTEMPRCV)           */          /*CCB009*/
             DLTJRNRCV  JRNRCV(&JLIB/JRDLC0603)                       /*CCB009*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,DLC0603024                                          */
                                                           /* E29371 */
 
             IF         COND(%SST(&FMT 101 1) *NE 'Y') THEN(DO)       /*086128*/
             CLRPFM     FILE(ECONXCY)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(ECONXCZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                    /*086128*/
             CLRPFM     FILE(MGF300PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGF600PD)                                                    /*CMG003*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*CMG003*/
             CLRPFM     FILE(MGF320PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                                          /*CSW208*/
             IF         COND(&CSW2008 *EQ 'CSW2008') THEN( +
                          CLRPFM FILE(MGX320PD))                                          /*CSW208*/
                                                                                          /*CSW208*/
             CLRPFM     FILE(MGF321PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/                                                                  /*CSW200*/
/* If switchable feature CSW200 is off clear MGF324PD and MGF335PD */ /*CSW200*/
/**/                                                                  /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             CLRPFM     FILE(MGF324PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLRPFM     FILE(MGF335PD)                                /*CSW200*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CSW200*/
             ENDDO                                                    /*CSW200*/
/**/                                                                  /*CSW200*/
             CLRPFM     FILE(MGF330PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**********  CLRPFM     FILE(MGF335PD)                               * *CSW200*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               * *CSW200*/
             CLRPFM     FILE(MGF350PD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/                                                                  /*CSW005*/
/* If switchable feature CSW005 is on clear the ff. files */          /*CSW005*/
/**/                                                                  /*CSW005*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                /*CSW005*/
             CLRPFM     FILE(MGF341PD)                                /*CSW005*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CSW005*/
             CLRPFM     FILE(MGF362PD)                                /*CSW005*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CSW005*/
             CLRPFM     FILE(MGX36NPD)                                /*171312*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*171312*/
             CLRPFM     FILE(MGY36NPD)                                /*171312*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*171312*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
/**/                                                                  /*CSW011*/
/* If switchable feature CSW011 is on clear MGF341PD */               /*CSW011*/
/**/                                                                  /*CSW011*/
             IF         COND((&CSW011 *EQ 'Y') & (&CSW005 *NE 'Y')) +
                          THEN(DO)                                    /*CSW011*/
             CLRPFM     FILE(MGF341PD)                                /*CSW011*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CSW011*/
             ENDDO                                                    /*CSW011*/
 
                 CHGVAR     VAR(&STAT) VALUE('N')                     /*CCB009*/
/**/                                                                  /*CCB009*/
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)       /*CCB009*/
/**/                                                                  /*CCB009*/
/*                                                                                        /*CSC020*/
/* Write current journal sequence number to file SCJSEQPD, using command SCWRTJREG.       /*CSC020*/
/*                                                                                        /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                            /*CSC020*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                    /*CSC020*/
             SCWRTJREG  COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('E') +
                          TEXT(&STEXT)                                                    /*CSC020*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
