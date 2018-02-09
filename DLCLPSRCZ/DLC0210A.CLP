/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Input cycle confirmation print')             */
/*********************************************************************/
/*                                                                   */
/*     Midas - DEALING                                               */
/*                                                                   */
/*     DLC0210A - Input Cycle Confirmation Processing                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CDL099             Date 09Oct17              */
/*                      CSW214             Date 25Nov14              */
/*                      AR583880           Date 19Aug14              */
/*                      AR402334           Date 19Aug14              */
/*                      MD023241           Date 03Jun13              */
/*                      CSW213             Date 03Jun13              */
/*                      CMG003             Date 04Oct12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      255986             Date 26Aug08              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSW208             Date 15Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      243124A            Date 28Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG6604            Date 20Apr05              */
/*                      228542             Date 05Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             Date 04Jul01              */
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CSW200             Date 21Aug00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      171312             Date 02Dec99              */
/*                      CSE006             Date 13Sep99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Jul99              */
/*                      103997             Date 17SEP97              */
/*                      CSW097             Date 26May97              */
/*                      CSW011             Date 20MAR97              */
/*                      111547             Date 26FEB97              */
/*                      CSW005             Date 01AUG96              */
/*                      S01408             Date 01NOV96              */
/*                      S01408             Date 16AUG96              */
/*                      S01408             Date 13MAY96              */
/*                      088656             Date 01JUN95              */
/*                      086137             Date 17MAR95              */
/*                      083798             Date 15FEB95              */
/*                      081938             Date 24JAN95              */
/*                      082507             Date 26JAN95              */
/*                      S01522             Date 23JAN95              */
/*                      041579             Date 26MAR93              */
/*                      AUS009             Date 23JUL92              */
/*                      E40242             Date 19JUN92              */
/*                      E38955             Date 01JUN92              */
/*                      S01310             Date 16APR91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     MD046248 - Finastra Rebranding                                */
/*     CDL099 - Split Value Dates                                    */
/*     CSW214 - SWIFT Changes 2014                                   */
/*     AR583880 - CPYF command on file MGF300PD resulted to an error */
/*              that prevented the generation of MT300 messages.     */
/*     AR402334 - MGF300CLS table is 150MB in size but does not seem */
/*                to have a purging process in place to control its  */
/*                size. Change Copy File *ADD option to *REPLACE.    */
/*     MD023241 - No MT340 for Amend                                 */
/*     CSW213 - SWIFT Changes 2013                                   */
/*     CMG003 - SWIFT MT600 Message Generation                       */
/*     CLE134 - Past Due Call Loan Processing (Recompile)            */
/*     255986 - Field 72 to be included in MT300/320/321/330         */
/*     CSW208 - SWIFT 2008 Changes                                   */
/*     243124A- Need to run SE confirmation job.                     */
/*     BUG6604- Removal of RCLRSC from this program                  */
/*     228542 - RGZPFM has changed at R5V3                           */
/*     205448 - UDC module must be on for Correspondence Manager     */
/*     CCG015 - Correspondence Manager Phase 1                       */
/*     CSC011 - 24x7 Midas Availability                              */
/*     CDL008 - Continuous Linked Settlement                         */
/*     CSW200 - SWIFT 2000 changes                                   */
/*     171312 - SWIFT97 Changes to MT340S & MT360S related fix.      */
/*              Do appropriate recovery to files MGU/V/W/XNPD files  */
/*     CSE006 - Repurchase Agreements Enhancement (REPOS)            */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set     */
/*              to CMTSCOPE(*JOB).                                   */
/*     103997 - Move change of DLSTAT position 6 ='Y', from          */
/*              FXC0010 & MMC0010 to the start of DLC0210A           */
/*              to prevent non-submission of pay/receive job.        */
/*     CSW097 - SWIFT 1997 Changes                                   */
/*     CSW011 - FRA MT34n only Message Generation                    */
/*     CSW005 - FRA/IRS MG34n and MG36n Message Generation           */
/*     111547 - You should not overide the printer file.             */
/*     S01408 - Addition of Core Hook DLC0210A06                     */
/*              Addition of Core Hook DLC0210A05                     */
/*     S01408 - Addition of core hook DLC0210A04                     */
/*     S01408 - Addition of core hook DLC0210A03                     */
/*              Addition of core hook DLC0210A02                     */
/*              Addition of core hook DLC0210A01                     */
/*     088656 - If UDC switched on select only suppressed records.   */
/*     086137 - Only prompt immediates if UDC installed              */
/*     083798 - Add CGUSRMSG for multi-language overrides            */
/*              See 082507 same error                                */
/*     081938 - Reclaim resources after CG4000                       */
/*     082507 - CGUSRMSG NOT GETTING OVERWRITTEN                     */
/*     S01522 - USER DEFINED CORRESPONDENCE                          */
/*       041579 - Set up multi-language override for MSGF/MIDAS      */
/*                also, send error messages to MRUNQ as well as      */
/*                MOPERQ, as this job is now submitted.              */
/*     AUS009 - AUSTRALIAN PRODUCT - USER DEFINED CONFIRMATIONS      */
/*     E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF MESSAGES       */
/*              GENERATED                                            */
/*     E38955 - SET UP MULTI-LANGUAGE FILE OVERRIDE FOR MIUSRMSG     */
/*     S01310 - RE WRITTEN FOR SWIFT RATIONALISATION                 */
/*                                                                   */
/*********************************************************************/
             PGM
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210A03                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
                                                                      /*041579*/
/*  Multiple language support variables  */                           /*041579*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*E38955*/
             DCL        VAR(&MIUSRMSG) TYPE(*CHAR) LEN(10)            /*E38955*/
             DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)             /*041579*/
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)            /*082507*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*E38955*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*E38955*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*E38955*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*E38955*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*E38955*/
                                                                      /*041579*/
/*/COPY WNCPYSRC,DLC0210A07                                          */
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
/*/COPY WNCPYSRC,DLC0210A08                                          */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*AUS009*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*AUS009*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*AUS009*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*AUS009*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*S01522*/
             DCL        VAR(&CSW005) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW005*/
             DCL        VAR(&CSW011) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW011*/
             DCL        VAR(&CSW097) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW097*/
 
             DCL        VAR(&CSE006) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CSE006*/
             DCL        VAR(&S01401) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CSE006*/
             DCL        VAR(&CDL008) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CDL008*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')  /*CSE006*/
             DCL        VAR(&CSW200) TYPE(*CHAR) LEN(6)               /*CSW200*/
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)                               /*CCG015*/
/*/COPY WNCPYSRC,DLC0210A25                                          */
 
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC011*/
             DCL        VAR(&S1SUPP) TYPE(*CHAR) LEN(2) VALUE(' ')                        /*CSC011*/
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2) VALUE(' ')                          /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&CSW2008) TYPE(*CHAR) LEN(7) VALUE('       ')                 /*CSW208*/
             DCL        VAR(&CSW2013) TYPE(*CHAR) LEN(7) VALUE('       ')                 /*CSW213*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)                                    /*CSW213*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*CSW213*/
                                                                                          /*CSW208*/
             DCL        VAR(&CMG003) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CMG003*/
                                                                                          /*CMG003*/
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))                 /*103997*/
             CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')               /*103997*/
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))                 /*103997*/
 
/* Check if switchable feature CSC011 is on */                                            /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC011*/
             CHGVAR     VAR(&SAR) VALUE('CSC011')                                         /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CSC011*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CSC011) VALUE('Y')                                        /*CSC011*/
                RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&S1SUPP)                           /*CSC011*/
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBR)                             /*CSC011*/
             ENDDO
                                                                                          /*CSC011*/
             IF         COND((&CSC011 *EQ 'Y') *AND (&S1SUPP *EQ +
                &LIBR)) THEN(DO)                                                          /*CSC011*/
                  SNDPGMMSG  MSG('Confirmation requested, but not +
                     valid on the support system') TOPGMQ(*EXT) +
                     TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)                                  /*CSC011*/
                  GOTO       CMDLBL(END)                                                  /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/* Notify MRUNQ */
             SNDPGMMSG  MSG('Input Cycle Confirmations Print') +
                        TOMSGQ(MRUNQ)
 
/* Begin commitment control */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
/* Zero switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(10010000)
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,DLC0210A12                                          */
/*  MULTIPLE LANGUAGE SUPPORT -                  */                   /*E38955*/
/*  SET OP OVERRIDES FOR MESSAGE FILES           */                   /*E38955*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*E38955*/
                                                                      /*E38955*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*E38955*/
                CHGVAR     VAR(&MULT) VALUE('GB')                     /*E38955*/
             ENDDO                                                    /*E38955*/
                                                                      /*E38955*/
/*  BUILD MULTIPLE LANGUAGE SUPPORT OBJECT NAMES  */                  /*E38955*/
             CHGVAR     VAR(&MIUSRMSG) VALUE(&MULT *CAT 'MIUSRMSG  ') /*E38955*/
             CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*041579*/
             CHGVAR     VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*082507*/
                                                                      /*E38955*/
/*  APPLY MULTIPLE LANGUAGE SUPPORT OVERRIDES  */                     /*E38955*/
             OVRMSGF    MSGF(MIUSRMSG) TOMSGF(&MIUSRMSG)              /*E38955*/
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)                  /*041579*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)              /*082507*/
                                                                      /*E40242*/
/*/COPY WNCPYSRC,DLC0210A09                                          */
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
/*/COPY WNCPYSRC,DLC0210A10                                          */
 
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
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
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CSW005*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CSW005) VALUE('Y'))                      /*CSW005*/
/**/                                                                  /*CSE006*/
/***  Access Switchable Features file to see if MT5XX present  ***/   /*CSE006*/
/**/                                                                  /*CSE006*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE006*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE006*/
             CHGVAR     VAR(&SAR) VALUE('S01401')                     /*CSE006*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CSE006*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&S01401) VALUE('Y'))                      /*CSW005*/
/**/                                                                  /*CSW098*/
                                                                      /*CSE006*/
/***  Access Switchable Features file to see if CSE006 is on   ***/   /*CSE006*/
/**/                                                                  /*CSE006*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSE006*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE006*/
             CHGVAR     VAR(&SAR) VALUE('CSE006')                     /*CSE006*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CSE006*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CSE006) VALUE('Y'))                      /*CSW005*/
/**/                                                                  /*CSW098*/
                                                                      /*CSW005*/
/* Check if switchable feature CSW011 is on */                        /*CSW011*/
/**/                                                                  /*CSW011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSW011*/
             CHGVAR     VAR(&SAR) VALUE('CSW011')                     /*CSW011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CSW011*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CSW011) VALUE('Y'))                      /*CSW011*/
                                                                      /*CDL008*/
/*    Access Switchable Features file to see if CDL008 is on     */   /*CDL008*/
/**/                                                                  /*CDL008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDL008*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDL008*/
             CHGVAR     VAR(&SAR) VALUE('CDL008')                     /*CDL008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CDL008*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CDL008) VALUE('Y'))                      /*CDL008*/
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
                                                                                          /*CSW208*/
/** Check if switchable feature CMG003 is on */                                           /*CMG003*/
                                                                                          /*CMG003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CMG003*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CMG003*/
             CHGVAR     VAR(&SAR) VALUE('CMG003')                                         /*CMG003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)                      /*CMG003*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CMG003) VALUE('Y'))                                          /*CMG003*/
                                                                                          /*CMG003*/
/* Check if switchable feature CSW213 is on */                                            /*CSW213*/
             CALL       PGM(SWIF2013) PARM(&CSW2013)                                      /*CSW213*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)                           /*CSW213*/
             SNDPGMMSG  MSG('Call to SWIF2013 program failed.') +
                          TOPGMQ(*EXT)                                                    /*CSW213*/
                GOTO       CMDLBL(ERROR)                                                  /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
/*/COPY WNCPYSRC,DLC0210A23                                          */
 
             IF COND(%SST(&DLSTAT 98 1) *EQ 'A') THEN(GOTO TAGA)
             IF COND(%SST(&DLSTAT 98 1) *EQ 'B') THEN(GOTO TAGB)
             IF COND(%SST(&DLSTAT 98 1) *EQ 'C') THEN(GOTO TAGC)
 
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*AUS009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*AUS009*/
             CHGVAR     VAR(&SAR) VALUE('AUS009')                     /*AUS009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*AUS009*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*AUS009*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210A06                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
/*********   OVRPRTF    FILE(DL0110P1) PAGESIZE(42 90) OVRFLW(42) AUS009111547*/
/*********   OVRPRTF    FILE(DL0110P2) PAGESIZE(42 90) OVRFLW(42) AUS009111547*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210A05                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
             ENDDO                                                    /*AUS009*/
/* */                                                                 /*S01522*/
/* User Defined Correspondence processing  */                         /*S01522*/
/* */                                                                 /*S01522*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01522*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01522*/
/* */                                                                 /*S01522*/
/** Access PF/SDMMODPD to determine whether UDC module is on          /*S01522*/
/* */                                                                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01522*/
/* */                                                                 /*S01522*/
/** Database error handling                                           /*S01522*/
/* */                                                                 /*S01522*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*S01522*/
/*********** SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD')*/ /*081938*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +      */ /*081938*/
/***********              MSGTYPE(*INFO)                   /*S01522*/ /*081938*/
             CHGVAR     VAR(&MSG) VALUE('Error on access to ICD file +
                          SDMMODPD')                                  /*081938*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                      /*CSE006*/
/***  If MT5XX messages Feature present...                       ***/ /*CSE006*/
/***  If switchable feature, CSE006, is on, call SE1875 (trades  ***/ /*CSE006*/
/***  extract confirmations)                                     ***/ /*CSE006*/
                                                                      /*CSE006*/
             IF (&CSE006 *EQ 'Y') THEN(DO)                            /*CSE006*/
 
             IF (&S01401 *EQ 'Y') THEN(DO)                            /*CSE006*/
               OVRDBF (MGOREFL0) SHARE(*NO)                           /*CSE006*/
                                                                      /*CSE006*/
               OVRDBF (TRADSDY1) SHARE(*NO)                           /*CSE006*/
                                                                      /*CSE006*/
               CALL (SE1875) PARM(&RSEQ)                              /*CSE006*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*CSE006*/
                  CHGVAR (&MSG) VALUE('SE1875 - I/C SWIFT Trade +
                     Confirmations Extract failed')                   /*CSE006*/
                  GOTO (ERROR)                                        /*CSE006*/
             ENDDO                                                    /*CSE006*/
                                                                      /*CSE006*/
             DLTOVR     FILE(MGOREFL0)                                /*CSE006*/
                                                                      /*CSE006*/
             ENDDO                                                    /*CSE006*/
 
             ENDDO                                                    /*CSE006*/
                                                                      /*CSE006*/
/***  If MT5XX Feature present and switchable feature CSE006 ***/     /*CSE006*/
/***  on, then generate MT510 Messages                       ***/     /*CSE006*/
                                                                      /*CSE006*/
             IF (&CSE006 *EQ 'Y') THEN(DO)                            /*CSE006*/
             IF (&S01401 *EQ 'Y') THEN(DO)                            /*CSE006*/
                                                                      /*CSE006*/
             OVRDBF     FILE(MGF51NPD) SHARE(*NO)                     /*CSE006*/
               CALL (MG051N)                                          /*CSE006*/
               DLTOVR (MGF51NPD)                                      /*CSE006*/
               IF (%SWITCH(XXXXXX11)) THEN(DO)                        /*CSE006*/
                 CHGVAR (&MSG) VALUE('MG051N - I/C SWIFT Trade +
                    Confirmation MT51N Generation failed')            /*CSE006*/
                 GOTO (ERROR)                                         /*CSE006*/
               ENDDO                                                  /*CSE006*/
                 SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +
                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                          /*243124A*/
                 SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                          /*243124A*/
               ENDDO                                                  /*CSE006*/
               ENDDO                                                  /*CSE006*/
                                                                      /*S01522*/
/* */                                                                 /*S01522*/
             OVRDBF     FILE(DEALS) SHARE(*NO)                        /*081938*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
                                                                                          /*CCG015*/
/* If Correspondence manager is switched on, override files */                            /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
                                                                                          /*CCG015*/
             CALL       PGM(CG4000) PARM(&W0RTN &W0CMT)               /*S01522*/
                                                                      /*S01522*/
/*********   RCLRSC                                                   /*081938*/         /*BUG6604*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')                           /*S01522*/
             ROLLBACK                                                 /*081938*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
/*********** ENDDO                                              /*S01522088656*/
                                                                                          /*CCG015*/
/* If Correspondence manager is switched on, call custom defined */                       /*CCG015*/
/* extract program                                               */                       /*CCG015*/
                                                                                          /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
                                                                                          /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
                CHGVAR     VAR(&MSG) VALUE('Correspondence Manager +
                             Custom-Defined Data Extract failed')                         /*CCG015*/
                GOTO       CMDLBL(ERROR)                                                  /*CCG015*/
             ENDDO                                                                        /*CCG015*/
/* */                                                                 /*088656*/
/* Select only records with CNPR of S */                              /*088656*/
/* */                                                                 /*088656*/
/*/COPY WNCPYSRC,DLC0210A27                                          */
             OVRDBF     FILE(DTRIXL1) TOFILE(DTRIXL2)                 /*088656*/
/*/COPY WNCPYSRC,DLC0210A28                                          */
             ENDDO                                                    /*088656*/
/* */                                                                 /*088656*/
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210A01                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
/* Produce confirmation extract CONEX */
             CALL       PGM(DL0110) PARM('     ' 'ALL' 'Y')
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210A02                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmations print failure')
             ROLLBACK
/*********** CLRPFM     FILE(CONEXCY) ******************************/ /*081938*/
/*********** CLRPFM     FILE(CONEXCZ) ******************************/ /*081938*/
/*/COPY WNCPYSRC,DLC0210A13                                          */
             GOTO       CMDLBL(ERROR)
             ENDDO
                                                                                          /*CSW213*/
/**********  IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)                    /*CSW213 MD023241*/
                                                                                          /*CSW213*/
/**********  CALL DL201356                                                       /*CSW213 MD023241*/
                                                                                          /*CSW213*/
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                         /*CSW213 MD023241*/
                                                                                          /*CSW213*/
/**********  CHGVAR     VAR(&MSG) VALUE('Confirmation extract failure')          /*CSW213 MD023241*/
/**********  ROLLBACK                                                            /*CSW213 MD023241*/
/**********  GOTO       CMDLBL(ERROR)                                            /*CSW213 MD023241*/
                                                                                          /*CSW213*/
/**********  ENDDO                                                               /*CSW213 MD023241*/
                                                                                          /*CSW213*/
/**********  ENDDO                                                               /*CSW213 MD023241*/
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF COND(%SST(&MMOD 25 1) *EQ 'Y') THEN(DO)
 
TAGA:        CHGDTAARA  DTAARA(DLSTAT (98 1)) VALUE('A')
 
/* Extract messages */
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
             OVRDBF     FILE(DEALS) SHARE(*NO)
             OVRDBF     FILE(CLOAN) SHARE(*NO)
/*/COPY WNCPYSRC,DLC0210A14                                          */
             CALL       PGM(DL6305)  /* COMIT ONLY DEALS */
 
/* If all CONEX not processed report failure */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmation extract failure')
             ROLLBACK
             CLRPFM     FILE(MGF300PD)
             CLRPFM     FILE(MGF320PD)
             IF         COND(&CMG003 *EQ 'Y') THEN(DO)                                    /*CMG003*/
             CHKOBJ     OBJ(MGF600PD) OBJTYPE(*FILE)                                      /*CMG003*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(NOG600))                          /*CMG003*/
             CLRPFM     FILE(MGF600PD)                                                    /*CMG003*/
             ENDDO                                                                        /*CMG003*/
             NOG600:                                                                      /*CMG003*/
             IF         COND(&CSW2008 *EQ 'CSW2008') THEN( +
                          CLRPFM FILE(MGX320PD))                                          /*CSW208*/
             CLRPFM     FILE(MGF321PD)
/**/                                                                  /*CSW200*/
/* If switchable feature CSW200 is off clear MGF324PD and MGF335PD */ /*CSW200*/
/* If CSW200 is on clear MGU340PD instead */                          /*CSW200*/
/**/                                                                  /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             CLRPFM     FILE(MGF324PD)
             CLRPFM     FILE(MGF335PD)                                /*CSW200*/
             ENDDO                                                    /*CSW200*/
             ELSE       DO                                            /*CSW200*/
             CLRPFM     FILE(MGU340PD)                                /*CSW200*/
             ENDDO                                                    /*CSW200*/
/**/                                                                  /*CSW200*/
             CLRPFM     FILE(MGF330PD)
/*********** CLRPFM     FILE(MGF335PD)                                /*CSW200*/
             CLRPFM     FILE(MGF350PD)
/*/COPY WNCPYSRC,DLC0210A15                                          */
/**/                                                                  /*CSW005*/
/* If switchable feature CSW005 is on then clear the ff. files */     /*CSW005*/
/**/                                                                  /*CSW005*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                /*CSW005*/
             CLRPFM     FILE(MGF340PD)                                /*CSW005*/
             CLRPFM     FILE(MGX360PD)                                /*CSW005*/
             CLRPFM     FILE(MGX361PD)                                /*CSW005*/
             CLRPFM     FILE(MGU36NPD)                                /*171312*/
             CLRPFM     FILE(MGV36NPD)                                /*171312*/
             CLRPFM     FILE(MGW36NPD)                                /*171312*/
             CLRPFM     FILE(MGX36NPD)                                /*171312*/
             CLRPFM     FILE(MGY36NPD)                                /*CSW005*/
             CLRPFM     FILE(MGZ36NPD)                                /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(&CSW011 *EQ 'Y' *AND &CSW005 *EQ 'N') +
                          THEN(CLRPFM FILE(MGF340PD))                 /*CSW011*/
                                                                      /*CSW011*/
             GOTO       CMDLBL(ERROR)
             ENDDO
                                                                      /*CDL008*/
/*    Copy MGF300PD to MGF300CLS if CDL008 is switched on        */   /*CDL008*/
/**/                                                                  /*CDL008*/
/**********  IF         COND(&CDL008 *EQ 'Y') THEN(CPYF +
                          FROMFILE(MGF300PD) TOFILE(MGF300CLS) +
                          MBROPT(*ADD) INCREL((*IF MGCLSS *EQ 'Y')))  */           /*CDL008 255986*/
/**********  IF         COND(&CDL008 *EQ 'Y') THEN(CPYF + */                     /*255986 AR402334*/
/**********               FROMFILE(MGF300PD) TOFILE(MGF300CLS) + */              /*255986 AR402334*/
/**********               MBROPT(*ADD) INCREL((*IF MGCLSS *EQ 'Y')) + */         /*255986 AR402334*/
/**********               FMTOPT(*MAP *DROP)) */                                 /*255986 AR402334*/
/**********  IF         COND(&CDL008 *EQ 'Y') THEN(CPYF + */                   /*AR402334 AR583880*/
/**********               FROMFILE(MGF300PD) TOFILE(MGF300CLS) + */            /*AR402334 AR583880*/
/**********               MBROPT(*REPLACE) INCREL((*IF MGCLSS *EQ + */         /*AR402334 AR583880*/
/**********               'Y')) FMTOPT(*MAP *DROP)) */                         /*AR402334 AR583880*/
             IF         COND(&CDL008 *EQ 'Y') THEN(DO)                                  /*AR583880*/
             CPYF       FROMFILE(MGF300PD) TOFILE(MGF300CLS) +
                          MBROPT(*REPLACE) INCREL((*IF MGCLSS *EQ +
                          'Y')) FMTOPT(*MAP *DROP)                                      /*AR583880*/
             MONMSG     MSGID(CPF2817 CPF0000)                                          /*AR583880*/
             ENDDO                                                                      /*AR583880*/
 
TAGB:        CHGDTAARA  DTAARA(DLSTAT (98 1)) VALUE('B')
                                                                                          /*CSW213*/
             IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)                             /*CSW213*/
                                                                                          /*CSW213*/
             CPYF       FROMFILE(MGF300PD) TOFILE(QTEMP/MGF300EX) +
                          CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y'))                      /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(&CMG003 *EQ 'Y') THEN(DO)                                    /*CSW214*/
                                                                                          /*CSW214*/
             CPYF       FROMFILE(MGF600PD) TOFILE(QTEMP/MGF600EX) +
                          CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y'))                      /*CSW214*/
             ENDDO                                                                        /*CSW214*/
                                                                                          /*CSW214*/
             IF         COND(&CSW005 *EQ 'Y' *OR &CSW011 *EQ 'Y') THEN(DO)                /*CSW213*/
             CPYF       FROMFILE(MGF340PD) TOFILE(QTEMP/MGF340EX) +
                          CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y'))                      /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                                    /*CSW213*/
             CPYF       FROMFILE(MGX360PD) TOFILE(QTEMP/MGX360EX) +
                          CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y'))                      /*CSW213*/
             CPYF       FROMFILE(MGX361PD) TOFILE(QTEMP/MGX361EX) +
                          CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y'))                      /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             CLRPFM     FILE(CONEXCY)
             CLRPFM     FILE(CONEXCZ)
/*/COPY WNCPYSRC,DLC0210A16                                          */
 
/* GDFs records are deleted as they are processed */
 
/* Process foreign exchange confirmations */
/**********  IF         COND(&CSW097 = 'N') THEN( +                */                     /*255986*/
/**********  CALL       PGM(MG0300))                               */              /*CSW097 255986*/
             IF         COND(&CSW097 = 'N') THEN()                                        /*255986*/
/**********  ELSE       CMD(CALL PGM(MG0300A))                      */             /*CSW097 CDL099*/
             ELSE       DO /*CDL099*/
                OVRDBF     FILE(DEALS) SHARE(*NO) /*CDL099*/
                CALL       PGM(MG0300A) /*CDL099*/
             ENDDO      /*CDL099*/
/*********** CALL       PGM(MG0300)                                */ /*CSW097*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Foreign exchange confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*041579*/
/************SNDPGMMSG  MSG('Foreign exchange confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))           */ /*041579*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC0210A17                                          */
/* */                                                                 /*CSW005*/
/* Process FRA confirmations if switchable feature CSW005 is on */    /*CSW005*/
/* */                                                                 /*CSW005*/
/************IF         COND(&CSW005 *EQ 'Y') THEN(DO)         /*CSW005 CSW011*/
             IF         COND(&CSW005 *EQ 'Y' *OR &CSW011 *EQ 'Y') +
                          THEN(DO)                                    /*CSW011*/
             CALL       PGM(MG0340)                                   /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Forward Rate Agreement confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*CSW005*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)              /*CSW005*/
             ROLLBACK                                                 /*CSW005*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
/* */                                                                 /*CSW005*/
/* Process Single and Cross CCy IRS Confirmations if switchable */    /*CSW005*/
/* feature CSW005 is on */                                            /*CSW005*/
/* */                                                                 /*CSW005*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                /*CSW005*/
             CALL       PGM(MG036N)                                   /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CSW005*/
             CLRPFM     FILE(MGU36NPD)                                /*171312*/
             CLRPFM     FILE(MGV36NPD)                                /*171312*/
             CLRPFM     FILE(MGW36NPD)                                /*171312*/
             CLRPFM     FILE(MGX36NPD)                                /*171312*/
             CLRPFM     FILE(MGY36NPD)                                /*CSW005*/
             CLRPFM     FILE(MGZ36NPD)                                /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Single and Cross Ccy IRS confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*CSW005*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)              /*CSW005*/
             ROLLBACK                                                 /*CSW005*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
 
/* Process fixed loan/deposit confirmations */
             CALL       PGM(MG0320)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*041579*/
/************SNDPGMMSG  MSG('Loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))           */ /*041579*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC0210A18                                          */
 
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
 
/* Clear MGX320PD after successful call to MG0320 */                                      /*CSW208*/
             IF         COND(&CSW2008 *EQ 'CSW2008') THEN( +
                          CLRPFM FILE(MGX320PD))                                          /*CSW208*/
                                                                                          /*CSW208*/
/* Process secondary certificate of deposits */
             CALL       PGM(MG0321)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Secondary certificate of deposit +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*041579*/
/************SNDPGMMSG  MSG('Secondary certificate of deposit +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))           */ /*041579*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process liquidation of loan/deposits */
/*                  (only if CSW200 is off)                        */ /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             CALL       PGM(MG0324)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Loan/deposit liquidation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*041579*/
/************SNDPGMMSG  MSG('Loan/deposit liquidation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))           */ /*041579*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO                                                    /*CSW200*/
 
/* Process call loan/deposits */
             CALL       PGM(MG0330)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Call loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*041579*/
/************SNDPGMMSG  MSG('Call loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))           */ /*041579*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC0210A19                                          */
 
/* Process interest rate change advices */
/*                  (only if CSW200 is off)                        */ /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             CALL       PGM(MG0335)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Interest rate change advice +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*041579*/
/************SNDPGMMSG  MSG('Interest rate change advice +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))           */ /*041579*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO                                                    /*CSW200*/
 
/* Process interest advices */
             CALL       PGM(MG0350)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Interest rate advice +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*041579*/
/************SNDPGMMSG  MSG('Interest rate advice +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))           */ /*041579*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC0210A24                                          */
 
/**********  RGZPFM     FILE(MGF300PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF300PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF320PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF320PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*CSW208*/
             IF         COND(&CSW2008 *EQ 'CSW2008') THEN(DO)                             /*CSW208*/
             CALL       PGM(SCC000060) PARM('MGX320PD' '*FIRST')                          /*CSW208*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*CSW208*/
             ENDDO                                                                        /*CSW208*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF321PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF321PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**/                                                                  /*CSW200*/
/* If switchable feature CSW200 is off reorganise MGF335PD and     */ /*CSW200*/
/* MGF324PD.                                                       */ /*CSW200*/
/**/                                                                  /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
/**********  RGZPFM     FILE(MGF324PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF324PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF335PD)                                /*CSW200*/          /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                        /*CSW200*/          /*228542*/
             CALL       PGM(SCC000060) PARM('MGF335PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
             ENDDO                                                    /*CSW200*/
             ELSE       DO                                            /*CSW200*/
             CLRPFM     FILE(MGU340PD)                                /*CSW200*/
             ENDDO                                                    /*CSW200*/
/**/                                                                  /*CSW200*/
/**********  RGZPFM     FILE(MGF330PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF330PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/************RGZPFM     FILE(MGF335PD)                                 *CSW200*/
/************MONMSG     MSGID(CPF2995 CPF2981)                         *CSW200*/
/**********  RGZPFM     FILE(MGF350PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF350PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**/                                                                  /*CSW005*/
/* Re-organize MG files if switchable feature CSW005 is on */         /*CSW005*/
/**/                                                                  /*CSW005*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                /*CSW005*/
/**********  RGZPFM     FILE(MGF340PD)                                         /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                 /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGF340PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGX360PD)                                         /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                 /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGX360PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGX361PD)                                         /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                 /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGX361PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGY36NPD)                                         /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                 /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGY36NPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGZ36NPD)                                         /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                 /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGZ36NPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW011*/
             IF         COND(&CSW011 *EQ 'Y' *AND &CSW005 *EQ 'N') +
                          THEN(DO)                                    /*CSW011*/
/**********  RGZPFM     FILE(MGF340PD)                                         /*CSW011*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                 /*CSW011*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGF340PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
             ENDDO                                                    /*CSW011*/
                                                                                          /*CMG003*/
             IF         COND(&CMG003 *EQ 'Y') THEN(DO)                                    /*CMG003*/
             CALL       PGM(SCC000060) PARM('MGF600PD' '*FIRST')                          /*CMG003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*CMG003*/
             ENDDO                                                                        /*CMG003*/
                                                                                          /*CMG003*/
/*/COPY WNCPYSRC,DLC0210A20                                          */
 
TAGC:        CHGDTAARA  DTAARA(DLSTAT (98 1)) VALUE('C')
 
/* If ISO confirmations required print messages */
             RCVF
             IF         COND(&ENFFCR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(ME0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ISO print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             ENDDO
/*/COPY WNCPYSRC,DLC0210A21                                          */
 
             CHGDTAARA  DTAARA(DLSTAT (98 1)) VALUE(' ')
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*086137*/
                                                                      /*081938*/
/* Prompt for immediate print */                                      /*081938*/
             CALL       PGM(CGC5217) PARM(' ')                        /*081938*/
             MONMSG     MSGID(CPF0000)                                /*081938*/
             ENDDO                                                    /*086137*/
                                                                      /*081938*/
/*/COPY WNCPYSRC,DLC0210A26                                          */
                                                                                          /*CSW213*/
/* SWIFT 2013 archiving  */                                                               /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)                             /*CSW213*/
                                                                                          /*CSW213*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                              /*CSW213*/
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')                           /*CSW213*/
                                                                                          /*CSW213*/
             CPYF       FROMFILE(MGF300EX) TOFILE(&DMLIB/MGF300TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(&CMG003 *EQ 'Y') THEN(DO)                                    /*CSW214*/
             CPYF       FROMFILE(MGF600EX) TOFILE(&DMLIB/MGF600TR) +
                          MBROPT(*ADD)                                                    /*CSW214*/
             ENDDO                                                                        /*CSW214*/
                                                                                          /*CSW214*/
             IF         COND(&CSW005 *EQ 'Y' *OR &CSW011 *EQ 'Y') THEN(DO)                /*CSW213*/
             CPYF       FROMFILE(MGF340EX) TOFILE(&DMLIB/MGF340TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                                    /*CSW213*/
             CPYF       FROMFILE(MGX360EX) TOFILE(&DMLIB/MGX360TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CSW213*/
             CPYF       FROMFILE(MGX361EX) TOFILE(&DMLIB/MGX361TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             GOTO       CMDLBL(END)
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmations generation +
                          failure')
             ENDDO
/************SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                           */ /*041579*/
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*041579*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Send database error message to workstation & MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)              */ /*041579*/
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*041579*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             CHGJOB     SWS(XXXXXX11)
                                                                                          /*CCG015*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
/* If Correspondence manager is switched on, delete overrides                             /*CCG015*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
 
END:         ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC0210A04                                     */    /*S01408*/
/*/                                                             */    /*S01408*/
                                                                      /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
             CALL       PGM(MEC0890) PARM('DL' 'C' 'ICJRN     ' +
                          &SDATE &STIME)                              /*E40242*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
/*/COPY WNCPYSRC,DLC0210A11                                          */
 
/* Ensure stop confirmations indicator set off */
             CALL       PGM(DL0106)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Reset busy flag in DLSTAT */
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD)) WAIT(32000)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('N')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,DLC0210A22                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
