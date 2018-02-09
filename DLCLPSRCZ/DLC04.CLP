/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL I/C termination - dealing')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - DEALING                                             */
/*                                                                   */
/*       DLC04 - INPUT CYCLE TERMINATION                             */
/*               CONFIRMATION & PAY/RECEIVE PROCESSING               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD039542           Date 30Jun16              */
/*                      MD031673           Date 17Dec14              */
/*                      CSW214             Date 25Nov14              */
/*                      MD021693A          Date 29Aug13              */
/*                      CSW213             Date 03Jun13              */
/*                      CMG003             Date 04Oct12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSW208             Date 15Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      245403             Date 01Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      241463             Date 02Aug06              */
/*                      CAS009             Date 04May04              */
/*                      228542             Date 22Jul04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205958             Date 22May02              */
/*                      CAS001             Date 23Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      174646             Date 02Mar01              */
/*                      CIR003             Date 13Sep00              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CSW200             Date 21Aug00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      130302             Date 17Jun98              */
/*                      CFF003             DATE 11APR97              */
/*                      CDL002             Date 15Sep97              */
/*                      CSW097             Date 26May97              */
/*                      CSW011             Date 20MAR97              */
/*                      CSW005             DATE 30AUG96              */
/*                      S01408             DATE 30AUG96              */
/*                      081938             DATE 27JUN96              */
/*                      S01408             DATE 13MAY96              */
/*                      S01408             DATE 20SEP95              */
/*                      CIR001             DATE 13JUN95              */
/*                      089167             DATE 23MAY95              */
/*                      081957             DATE 16JAN95              */
/*                      082024             DATE 20DEC94              */
/*                      S01522             DATE 18NOV94              */
/*                      062858             DATE 07JAN94              */
/*                      057243             DATE 16AUG93              */
/*                      S01427             DATE 12JUL93              */
/*                      E46234             DATE 01FEB93              */
/*                      E46893             DATE 01FEB93              */
/*                      E41062             DATE 28OCT92              */
/*                      E40462             DATE 27OCT92              */
/*                      E40242             DATE 19JUN92              */
/*                      E29588             DATE 05FEB92              */
/*                      E29020             DATE 30SEP91              */
/*                      S01310             DATE 16APR91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD039542 - Commitment definition control error              */
/*       MD031673 - Component DLC0400 00001 failed during COB run    */
/*       CSW214 - SWIFT Changes 2014                                 */
/*       MD021693A - DLC0400 seq 00001 failed                        */
/*       CSW213 - SWIFT Changes 2013                                 */
/*       CMG003 - SWIFT MT600 Message Generation                     */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CSW208 - SWIFT 2008 Changes                                 */
/*       245403 - U7 U8 reset in CGC3605. Review 227780.             */
/*       241463 - Applied fix 227780.                                */
/*       227780 - Apply CCG015 coding.                               */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       205958 - DLC1966 should not be conditional to CIR001        */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*       174646 - If UDC is switched ON, program DL0110 should       */
/*                select DTRIXDD record with CNPR = 'S' (suppressed  */
/*                by CG4000). Patterned after core fix 088656 of     */
/*                DLC0210A.                                          */
/*       CIR003 - Principal Exchange on Cross-Ccy IRS.               */
/*       CDL008 - Continuous Linked Settlement                       */
/*       CSW200 - SWIFT 2000 changes                                 */
/*       130302 - Ensure U4 is off when Dl0308 and DL0312 are called */
/*                to prevent COB failure as a file in those programs */
/*                conditioned on U4 appears to be absent at DBA2.    */
/*       CFF003 - Enhanced OTC Processing - Phase II                 */
/*                upgrade from BLI LBL001                            */
/*       CDL002 - FX Netting                                         */
/*       CSW097 - SWIFT 1997 Changes                                 */
/*       CSW011 - FRA MT34n only Message Generation                  */
/*       CSW005 - FRA/IRS MG34n and MG36n Message Generation         */
/*       S01408 - Addition of Core Hook DLC04005                     */
/*                Addition of Core Hook DLC04006                     */
/*       081938 - Override file DEALS with SHARE(*NO)                */
/*                Reason was missing from header.                    */
/*       S01408 - Addition of Core Hook DLC04004                     */
/*                Addition of Core Hook DLC04003                     */
/*       S01408 - Addition of Core Hook DLC04INT                     */
/*                Addition of Core Hook DLC04001                     */
/*                Addition of Core Hook DLC04002                     */
/*       CIR001 - Interest Rate Calendars                            */
/*       089167 - Reclaim resources at end of process                */
/*       081957 - Reclaim resources after CG4000                     */
/*       082024 - Amend error handling for MG formatting failures    */
/*                so that switch U7 is now recognised as stopping    */
/*                condition and not carried forward still set on to  */
/*                next pgm                                           */
/*                CALLs affected : MG0300, MG0320, MG0321, MG0324    */
/*                MG0330, MG0335, MG0350, MG0100, MG0200, MG0202,    */
/*                MG0210.                                            */
/*       S01522 - USER DEFINED CORRESPONDENCE                        */
/*       062858 - E29588 didn't actually quite manage to reinstate   */
/*                DL0308. (fix taken fm Sydney E059580)              */
/*       057243 - E46893 conditions call to DLC1962 on position 75 of*/
/*                MMOD. This position is a filler & thus is incorrect*/
/*       S01427 - R10 CHIPS INCORPORATION                            */
/*       E46234 - CRTDTAQ command will fail if data queue MEISOPRT   */
/*                already exist in QTEMP, either because it was      */
/*                created already in the program, or because I/C     */
/*                TERM was restarted. Fix is to monitor for CPF9870  */
/*       E46893 - Call to DLC1962 should be conditioned on IR flag   */
/*                (position 75 on MMOD)                              */
/*       E41062 - Override  file MGOREFL0                            */
/*       E40462 - Override  files CLOAN and DEALS with SHARE(*NO)    */
/*                paramenter to prevent commitment control error     */
/*                on call to MG9210.                                 */
/*     E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF MESSAGES       */
/*              GENERATED                                            */
/*     E29588 - POST COLLECTION SWIFT RATIONALISATION AMENDMENTS     */
/*               o Re-instate DL0308                                 */
/*               o Tag sequence incorrect as DL0318 is missing       */
/*     E29020 - FRA/IRS Revaluation - Call DLC1962 to rebuild        */
/*              MM Discount Factors if necessary.                    */
/*     S01310 - RE WRITTEN FOR SWIFT RATIONALISATION                 */
/*                                                                   */
/*********************************************************************/
             PGM
/*/                                                                  */
/*/COPY WNCPYSRC,DLC04INT                                            */
/**/                                                                  /*CFF003*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*CFF003*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*CFF003*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CFF003*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CFF003*/
/**/                                                                  /*CFF003*/
/*/                                                                  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REON) TYPE(*CHAR) LEN(1) VALUE(N)        /*E29588*/
 
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MCSTAT) TYPE(*CHAR) LEN(256)             /*S01427*/
                                                                      /*E29020*/
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)                 /*E29020*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&TYPR) TYPE(*CHAR) LEN(1)                 /*E40242*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*057243*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*057243*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')                                          /*057243*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*S01522*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*S01522*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)               /*CIR001*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CIR001*/
             DCL        VAR(&CIR001) TYPE(*CHAR) LEN(1) VALUE('N')    /*CIR001*/
             DCL        VAR(&CSW005) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW005*/
             DCL        VAR(&CSW011) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW011*/
             DCL        VAR(&CSW097) TYPE(*CHAR) LEN(1) VALUE('N')    /*CSW097*/
             DCL        VAR(&CDL002) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL002*/
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)                  /*CDL002*/
             DCL        VAR(&CDL008) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL008*/
             DCL        VAR(&CIR003) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CIR003*/
             DCL        VAR(&CSW200) TYPE(*CHAR) LEN(6)               /*CSW200*/
             DCL        VAR(&CAS001) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CAS001*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CAS009*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CAS009*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CAS009*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)                                   /*CAS009*/
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)                               /*227780*/
/*/COPY WNCPYSRC,DLC04016                                            */
 
             DCL        VAR(&CSW2008) TYPE(*CHAR) LEN(7) VALUE('       ')                 /*CSW208*/
                                                                                          /*CSW208*/
             DCL        VAR(&CMG003) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CMG003*/
                                                                                          /*CMG003*/
             DCL        VAR(&CSW2013) TYPE(*CHAR) LEN(7) VALUE('       ')                 /*CSW213*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)                                    /*CSW213*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*CSW213*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                                 /*CSW213*/
                                                                                          /*CSW213*/
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/*/COPY WNCPYSRC,DLC04015                                            */
 
/* Zero switches */
/*********** CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(10100000) ********/ /*081957*/
/*/COPY WNCPYSRC,DLC04013                                            */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(10110000)           /*081957*/
/*/COPY WNCPYSRC,DLC04014                                            */
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,DLC04007                                            */
                                                                      /*E40242*/
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report of Confirmations produced                /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
                                                                      /*E40242*/
/**/                                                                  /*CSW005*/
/* Check if switchable feature CSW005 is on */                        /*CSW005*/
/**/                                                                  /*CSW005*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW005*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSW005*/
             CHGVAR     VAR(&SAR) VALUE('CSW005')                     /*CSW005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CSW005*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CSW005) VALUE('Y'))                      /*CSW005*/
                                                                      /*CSW005*/
/**/                                                                  /*CDL002*/
/* Check if switchable feature CDL002 is on (FX Netting)*/            /*CDL002*/
/**/                                                                  /*CDL002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDL002*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDL002*/
             CHGVAR     VAR(&SAR) VALUE('CDL002')                     /*CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CDL002) VALUE('Y'))                      /*CDL002*/
/*/COPY WNCPYSRC,DLC04029                                            */
                                                                      /*CDL002*/
/* Check if switchable feature CSW011 is on */                        /*CSW011*/
/**/                                                                  /*CSW011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSW011*/
             CHGVAR     VAR(&SAR) VALUE('CSW011')                     /*CSW011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CSW011*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CSW011) VALUE('Y'))                      /*CSW011*/
/**/                                                                  /*CDL008*/
/* Check if switchable feature CDL008 is on (CLS)                     /*CDL008*/
/**/                                                                  /*CDL008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDL008*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDL008*/
             CHGVAR     VAR(&SAR) VALUE('CDL008')                     /*CDL008*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CDL008*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CDL008) VALUE('Y'))                      /*CDL008*/
/**/                                                                                      /*CIR003*/
/* Check if switchable feature CIR003 is on (Pay/Receive for Swaps)*/                     /*CIR003*/
/**/                                                                                      /*CIR003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CIR003*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CIR003*/
             CHGVAR     VAR(&SAR) VALUE('CIR003')                                         /*CIR003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)                      /*CIR003*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CIR003) VALUE('Y'))                                          /*CIR003*/
/**/                                                                  /*CDL008*/
/*  Set Type of Run flag to 'Confirmations' for Audit report          /*E40242*/
             CHGVAR     VAR(&TYPR) VALUE('C')                         /*E40242*/
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
/* If Retail or IoA switched on, set Retail-on flag */                /*E29588*/
             IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 16 1) = 'Y')) +
                          THEN(CHGVAR VAR(&REON) VALUE(Y))            /*E29588*/
 
/*/COPY WNCPYSRC,DLC04012                                            */
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
                                                                                          /*CSW213*/
/* Check if switchable feature CSW213 is on */                                            /*CSW213*/
             CALL       PGM(SWIF2013) PARM(&CSW2013)                                      /*CSW213*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)                           /*CSW213*/
             SNDPGMMSG  MSG('Call to SWIF2013 program failed.') +
                          TOPGMQ(*EXT)                                                    /*CSW213*/
                GOTO       CMDLBL(ERROR)                                                  /*CSW213*/
             ENDDO                                                                        /*CSW213*/
/**/                                                                                      /*CAS009*/
/* Check if CAS009 is enabled. */                                                         /*CAS009*/
/**/                                                                                      /*CAS009*/
           CHGVAR     VAR(&PRTCD) VALUE('       ')                                        /*CAS009*/
           CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                        /*CAS009*/
           CHGVAR     VAR(&PSARD) VALUE('CAS009')                                         /*CAS009*/
                                                                                          /*CAS009*/
           CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &SCSARD)                    /*CAS009*/
                                                                                          /*CAS009*/
           CHGVAR     VAR(&CAS009) VALUE('N')                                             /*CAS009*/
           IF         COND(&PRTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAS009) VALUE('Y'))                                /*CAS009*/
           ELSE       DO                                                                  /*CAS009*/
           IF         COND(&PRTCD *NE '*NRF   ') +
                      THEN(GOTO CMDLBL(ERROR))                                            /*CAS009*/
           ENDDO                                                                          /*CAS009*/
                                                                                          /*CMG003*/
/** Check if switchable feature CMG003 is on */                                           /*CMG003*/
                                                                                          /*CMG003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CMG003*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CMG003*/
             CHGVAR     VAR(&SAR) VALUE('CMG003')                                         /*CMG003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)                      /*CMG003*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CMG003) VALUE('Y'))                                          /*CMG003*/
                                                                                          /*CMG003*/
/* */
/** File over-ride for MGOREFL0                                   */ /*E41062*/
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)                    /*E41062*/
 
/* DLC0401 */
             IF COND(%SST(&DLSTAT 98 1) *EQ 'A') THEN(GOTO TAGA)
             IF COND(%SST(&DLSTAT 98 1) *EQ 'B') THEN(GOTO TAGB)
             IF COND(%SST(&DLSTAT 98 1) *EQ 'C') THEN(GOTO TAGC)
 
             SNDPGMMSG  MSG('Input Cycle Termination Confirmation +
                        Print') TOMSGQ(MRUNQ)
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
/*********** SNDPGMMSG  MSG('Error on access to ICD file SDMMODPD')*/ /*081957*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +      */ /*081957*/
/***********              MSGTYPE(*INFO)                   /*S01522*/ /*081957*/
             CHGVAR     VAR(&MSG) VALUE('Error on access to ICD file +
                          SDMMODPD')                                  /*081957*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
/* */                                                                 /*S01522*/
             OVRDBF     FILE(DEALS) SHARE(*NO)                        /*081938*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
/* */                                                                                     /*227780*/
/* If Correspondence manager is switched on, override files                               /*227780*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*227780*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*227780*/
/* */                                                                                     /*227780*/
             CALL       PGM(CG4000) PARM(&W0RTN &W0CMT)               /*S01522*/
                                                                      /*S01522*/
             RCLRSC                                                   /*081957*/
             IF         COND(&W0RTN *NE '       ') THEN(DO)           /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')                           /*S01522*/
             ROLLBACK                                                 /*081957*/
             GOTO       CMDLBL(ERROR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
/**********  ENDDO */                                                              /*S01522 174646*/
/* */                                                                                     /*227780*/
/* If Correspondence manager is switched on, call custom defined                          /*227780*/
/* extract program                                                                        /*227780*/
/* */                                                                                     /*227780*/
             CALL       PGM(CGC3604)                                                      /*227780*/
/* */                                                                                     /*227780*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*227780*/
             CHGVAR     VAR(&MSG) VALUE('Correspondence Manager +
                        Custom-Defined Data Extract failed')                              /*227780*/
             GOTO       CMDLBL(ERROR)                                                     /*227780*/
             ENDDO                                                                        /*227780*/
/**/                                                                                      /*174646*/
/** If UDC is ON, DL0110 must select records with CNPR = 'S' */                           /*174646*/
/**/                                                                                      /*174646*/
             OVRDBF     FILE(DTRIXL1) TOFILE(DTRIXL2)                                     /*174646*/
             ENDDO                                                                        /*174646*/
/**/                                                                                      /*174646*/
/**/                                                                                      /*174646*/
 
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC04003                                       */    /*S01408*/
/*/                                                             */    /*S01408*/
             CALL       PGM(DL0110) PARM('     ' 'ALL' 'Y')
/*/                                                             */    /*S01408*/
/*/COPY WNCPYSRC,DLC04004                                       */    /*S01408*/
/*/                                                             */    /*S01408*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmations print failure')
             ROLLBACK
/*********** CLRPFM     FILE(CONEXCY) ******************************/ /*081957*/
/*********** CLRPFM     FILE(CONEXCZ) ******************************/ /*081957*/
/*/COPY WNCPYSRC,DLC04019                                            */
             GOTO       CMDLBL(ERROR)
             ENDDO
                                                                                          /*CSW213*/
             IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)                             /*CSW213*/
                                                                                          /*CSW213*/
             CALL DL201356                                                                /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CSW213*/
                                                                                          /*CSW213*/
             CHGVAR     VAR(&MSG) VALUE('Confirmation extract failure')                   /*CSW213*/
             ROLLBACK                                                                     /*CSW213*/
             GOTO       CMDLBL(ERROR)                                                     /*CSW213*/
                                                                                          /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             ENDDO                                                                        /*CSW213*/
 
             IF COND(%SST(&MMOD 25 1) *EQ 'Y') THEN(DO)
 
TAGA:        CHGDTAARA  DTAARA(DLSTAT (98 1)) VALUE('A')
 
/* Extract messages */
/*/COPY WNCPYSRC,DLC04020                                            */
             CALL       PGM(DL6305) /* COMIT ONLY DEALS */
 
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
                                                                                          /*CSW208*/
             IF         COND(&CSW2008 *EQ 'CSW2008') THEN( +
                          CLRPFM FILE(MGX320PD))                                          /*CSW208*/
                                                                                          /*CSW208*/
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
             IF         COND((&CSW005 *EQ 'Y') *OR +
                          (&CSW011 *EQ 'Y')) THEN(DO)                 /*CSW200*/
             CLRPFM     FILE(MGU340PD)                                /*CSW200*/
             ENDDO                                                    /*CSW200*/
             ENDDO                                                    /*CSW200*/
/**/                                                                  /*CSW200*/
             CLRPFM     FILE(MGF330PD)
/************CLRPFM     FILE(MGF335PD)  */                            /*CSW200*/
             CLRPFM     FILE(MGF350PD)
/**/                                                                  /*CSW005*/
/* If switchable feature CSW005 is on then clear the ff. files */     /*CSW005*/
/**/                                                                  /*CSW005*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                /*CSW005*/
             CLRPFM     FILE(MGF340PD)                                /*CSW005*/
             CLRPFM     FILE(MGX360PD)                                /*CSW005*/
             CLRPFM     FILE(MGX361PD)                                /*CSW005*/
             CLRPFM     FILE(MGY36NPD)                                /*CSW005*/
             CLRPFM     FILE(MGZ36NPD)                                /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(&CSW011 *EQ 'Y' *AND &CSW005 *EQ 'N') +
                          THEN(CLRPFM FILE(MGF340PD))                 /*CSW011*/
                                                                      /*CSW011*/
/*/COPY WNCPYSRC,DLC04017                                            */
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGB:        CHGDTAARA  DTAARA(DLSTAT (98 1)) VALUE('B')
                                                                                          /*CSW213*/
             IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)                             /*CSW213*/
                                                                                          /*CSW213*/
/**********  CPYF       FROMFILE(MGF300PD) TOFILE(QTEMP/MGF300EX) +  */                /*MD021693A*/
/**********               CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y')) */         /*CSW213 MD021693A*/
             CPYF       FROMFILE(MGF300PD) TOFILE(QTEMP/MGF300EX) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF MGACMI *EQ 'Y'))                                 /*MD021693A*/
             MONMSG     MSGID(CPF0000)                                                 /*MD021693A*/
                                                                                          /*CSW213*/
             IF         COND(&CMG003 *EQ 'Y') THEN(DO)                                    /*CSW214*/
             CPYF       FROMFILE(MGF600PD) TOFILE(QTEMP/MGF600EX) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF MGACMI *EQ 'Y'))                                    /*CSW214*/
             MONMSG     MSGID(CPF0000)                                                    /*CSW214*/
             ENDDO                                                                        /*CSW214*/
                                                                                          /*CSW214*/
             IF         COND(&CSW005 *EQ 'Y' *OR &CSW011 *EQ 'Y') THEN(DO)                /*CSW213*/
/**********  CPYF       FROMFILE(MGF340PD) TOFILE(QTEMP/MGF340EX) +  */                /*MD021693A*/
/**********               CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y')) */         /*CSW213 MD021693A*/
             CPYF       FROMFILE(MGF340PD) TOFILE(QTEMP/MGF340EX) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF MGACMI *EQ 'Y'))                                 /*MD021693A*/
             MONMSG     MSGID(CPF0000)                                                 /*MD021693A*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                                    /*CSW213*/
/**********  CPYF       FROMFILE(MGF360PD) TOFILE(QTEMP/MGF360EX) +  */                /*MD021693A*/
/**********               CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y')) */         /*CSW213 MD021693A*/
/**********  CPYF       FROMFILE(MGF361PD) TOFILE(QTEMP/MGF361EX) +  */                /*MD021693A*/
/**********               CRTFILE(*YES) INCREL((*IF MGACMI *EQ 'Y')) */         /*CSW213 MD021693A*/
             CPYF       FROMFILE(MGX360PD) TOFILE(QTEMP/MGF360EX) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF MGACMI *EQ 'Y'))                                 /*MD021693A*/
             MONMSG     MSGID(CPF0000)                                                 /*MD021693A*/
             CPYF       FROMFILE(MGX361PD) TOFILE(QTEMP/MGF361EX) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF MGACMI *EQ 'Y'))                                 /*MD021693A*/
             MONMSG     MSGID(CPF0000)                                                 /*MD021693A*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             CLRPFM     FILE(CONEXCY)
             CLRPFM     FILE(CONEXCZ)
/*/COPY WNCPYSRC,DLC04021                                            */
 
/* GDFs records are deleted as they are processed */
 
/* Process foreign exchange confirmations */
             IF         COND(&CSW097 = 'N') THEN( +
             CALL       PGM(MG0300))                                  /*CSW097*/
/**********  ELSE       CMD(CALL PGM(MG0300A))                      */           /*CSW097 MD039542*/
             ELSE       DO                                                              /*MD039542*/
                OVRDBF     FILE(DEALS) SHARE(*NO)                                       /*MD039542*/
                CALL       PGM(MG0300A)                                                 /*MD039542*/
             ENDDO                                                                      /*MD039542*/
/*********** CALL       PGM(MG0300)                                */ /*CSW097*/
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
/*************************%SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Foreign exchange confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)             /* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC04022                                            */
 
/* Process fixed loan/deposit confirmations */
             CALL       PGM(MG0320)
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
/*************************%SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)             /* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC04023                                            */
 
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
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
/*************************%SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Secondary certificate of deposit +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)             /* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process liquidation of loan/deposits */
/*                  (only if CSW200 is off)                        */ /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             CALL       PGM(MG0324)
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
/*************************%SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Loan/deposit liquidation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)             /* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO                                                    /*CSW200*/
 
/* Process call loan/deposits */
             CALL       PGM(MG0330)
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Call loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)             /* 082024 */
/***********************  TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC04024                                            */
 
/* Process interest rate change advices */
/*                  (only if CSW200 is off)                        */ /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
             CALL       PGM(MG0335)
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Interest rate change advice +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)             /* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO                                                    /*CSW200*/
 
/* Process interest advices */
             CALL       PGM(MG0350)
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Interset rate advice +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)             /* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC04028                                            */
/* */                                                                 /*CSW005*/
/* Process FRA confirmations if switchable feature CSW005 is on */    /*CSW005*/
/* */                                                                 /*CSW005*/
/************IF         COND(&CSW005 *EQ 'Y') THEN(DO)         /*CSW005 CSW011*/
             IF         COND(&CSW005 *EQ 'Y' *OR &CSW011 *EQ 'Y') +
                          THEN(DO)                                    /*CSW011*/
                CALL       PGM(MG0340)                                /*CSW005*/
                                                                      /*CSW005*/
                IF         COND(%SWITCH(XXXXXX1X) *OR +
                             %SWITCH(XXXXXXX1)) THEN(DO)
                   SNDPGMMSG  MSG('Forward Rate Agreement confirmation +
                                formatting failure') TOPGMQ(*EXT) +
                                TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)   /*CSW005*/
                   ROLLBACK                                           /*CSW005*/
                   GOTO       CMDLBL(ERROR)                           /*CSW005*/
                ENDDO                                                 /*CSW005*/
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
             CLRPFM     FILE(MGY36NPD)                                /*CSW005*/
             CLRPFM     FILE(MGZ36NPD)                                /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG  MSG('Single and Cross Ccy IRS confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)         /*CSW005*/
             ROLLBACK                                                 /*CSW005*/
             GOTO       CMDLBL(ERROR)                                 /*CSW005*/
             ENDDO                                                    /*CSW005*/
             ENDDO                                                    /*CSW005*/
                                                                      /*CSW005*/
 
/**********  RGZPFM     FILE(MGF300PD)                           */                       /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF300PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGF320PD)                           */                       /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF320PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*CSW208*/
             IF         COND(&CSW2008 *EQ 'CSW2008') THEN(DO)                             /*CSW208*/
             CALL       PGM(SCC000060) PARM('MGX320PD' '*FIRST')                          /*CSW208*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*CSW208*/
             ENDDO                                                                        /*CSW208*/
                                                                                          /*CSW208*/
/**********  RGZPFM     FILE(MGF321PD)                           */                       /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF321PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**/                                                                  /*CSW200*/
/* If switchable feature CSW200 is off reorganise MGF335PD and     */ /*CSW200*/
/* MGF324PD.                                                       */ /*CSW200*/
/**/                                                                  /*CSW200*/
             IF         COND(&CSW200 *NE 'CSW200') THEN(DO)           /*CSW200*/
/**********  RGZPFM     FILE(MGF324PD)                           */                       /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF324PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGF335PD)                           */            /*CSW200*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */            /*CSW200*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGF335PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
             ENDDO                                                    /*CSW200*/
             ELSE       DO                                            /*CSW200*/
             CLRPFM     FILE(MGU340PD)                                /*CSW200*/
             ENDDO                                                    /*CSW200*/
/**/                                                                  /*CSW200*/
/**********  RGZPFM     FILE(MGF330PD)                           */                       /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF330PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/************RGZPFM     FILE(MGF335PD)                                 *CSW200*/
/************MONMSG     MSGID(CPF2995 CPF2981)                         *CSW200*/
/*********** RGZPFM     FILE(MGF350PD)                           */                       /*228542*/
/*********** MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF350PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**/                                                                  /*CSW005*/
/* Re-organize MG files if switchable feature CSW005 is on */         /*CSW005*/
/**/                                                                  /*CSW005*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                /*CSW005*/
/**********  RGZPFM     FILE(MGF340PD)                             */          /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */          /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGF340PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGX360PD)                             */          /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */          /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGX360PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGX361PD)                             */          /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */          /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGX361PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGY36NPD)                             */          /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */          /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGY36NPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGZ36NPD)                             */          /*CSW005*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */          /*CSW005*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGZ36NPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
             ENDDO                                                    /*CSW005*/
 
             IF         COND(&CSW011 *EQ 'Y' *AND &CSW005 *EQ 'N') +
                          THEN(DO)                                    /*CSW011*/
/**********  RGZPFM     FILE(MGF340PD)                             */          /*CSW011*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                     */          /*CSW011*/ /*228542*/
             CALL       PGM(SCC000060) PARM('MGF340PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
             ENDDO                                                    /*CSW011*/
                                                                      /*CSW011*/
             IF         COND(&CMG003 *EQ 'Y') THEN(DO)                                    /*CMG003*/
             CALL       PGM(SCC000060) PARM('MGF600PD' '*FIRST')                          /*CMG003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*CMG003*/
             ENDDO                                                                        /*CMG003*/
                                                                                          /*CMG003*/
/*/COPY WNCPYSRC,DLC04018                                            */
 
TAGC:        CHGDTAARA  DTAARA(DLSTAT (98 1)) VALUE('C')
 
/* If ISO confirmations required print messages */
             RCVF
             IF         COND(&ENFFCR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             MONMSG     MSGID(CPF9870)                               /*E46234*/
             CALL       PGM(ME0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ISO print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             ENDDO
/*/COPY WNCPYSRC,DLC04025                                            */
                                                                      /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
             CALL       PGM(MEC0890) PARM('DL' &TYPR 'ICJRN     ' +
                          &SDATE &STIME)                              /*E40242*/
             CHGVAR     VAR(&TYPR) VALUE(' ')                         /*E40242*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERROR)      /*E40242*/
 
             CHGDTAARA  DTAARA(DLSTAT (98 1)) VALUE(' ')
 
/* Block large files */
             OVRDBF     FILE(PREXPH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX1PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX2PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX3PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX4PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX5PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX6PH) SEQONLY(*YES 50)
 
             OVRDBF     FILE(TRANS) TOFILE(DTRIN)
                                                                      /*E40242*/
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report of Pay/Receives produced                 /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
                                                                      /*E40242*/
/*  Set Type of Run flag to 'Pay/Receives' for Audit report           /*E40242*/
             CHGVAR     VAR(&TYPR) VALUE('P')                         /*E40242*/
 
             IF COND(%SST(&DLSTAT 99 1) *EQ 'D') THEN(GOTO TAGD)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'E') THEN(GOTO TAGE)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'F') THEN(GOTO TAGF)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'G') THEN(GOTO TAGG)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'H') THEN(GOTO TAGH)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'I') THEN(GOTO TAGI)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'J') THEN(GOTO TAGJ)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'K') THEN(GOTO TAGK)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'L') THEN(GOTO TAGL)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'M') THEN(GOTO TAGM)      /*E29020*/
             IF COND(%SST(&DLSTAT 99 1) *EQ 'N') THEN(GOTO TAGN)      /*E29588*/
 
/* DLC2350A */
             CHGJOB     SWS(01000000)
 
             SNDPGMMSG  MSG('Create Pay/Receive Extract Files') +
                          TOMSGQ(MRUNQ)
 
             CLRPFM     FILE(DTRIEHH)
             CLRPFM     FILE(DTRIEPH)
             CLRPFM     FILE(DTRIEZZ)
 
             CALL DL1700
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive extract failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGD:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('D')
 
             CLRPFM     FILE(PREXHH)
             CLRPFM     FILE(PREXPH)
             CLRPFM     FILE(PREXZZ)
/*/COPY WNCPYSRC,DLC04005                                       */    /*S01408*/
             CHGJOB     SWS(00000010)
             CALL DL1705
/*/COPY WNCPYSRC,DLC04006                                       */    /*S01408*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Create pay/receive extract +
                          file failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/*  if netting installed run the extract prune to remove records to   /*CDL002*/
/*  be processed in the net run of pay/receives                       /*CDL002*/
             IF         COND(&CDL002 *EQ 'Y') THEN(DO)                /*CDL002*/
                CALL       PGM(DL0351)                                /*CDL002*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           /*CDL002*/
                  CHGVAR     VAR(&MSG) VALUE('Pay/receive extract netting +
                             prune failure')                          /*CDL002*/
                  GOTO       CMDLBL(ERROR)                            /*CDL002*/
                ENDDO                                                 /*CDL002*/
             ENDDO                                                    /*CDL002*/
                                                                      /*CDL002*/
/**/                                                                                      /*CAS009*/
/* Create extract files for fees if CAS009 is enabled. */                                 /*CAS009*/
/**/                                                                                      /*CAS009*/
             IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                    /*CAS009*/
                CALL       PGM(DL1069)                                                    /*CAS009*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CAS009*/
                  CHGVAR     VAR(&MSG) VALUE('Create extract files for fees failure.')    /*CAS009*/
                  GOTO       CMDLBL(ERROR)                                                /*CAS009*/
                ENDDO                                                                     /*CAS009*/
             ENDDO                                                                        /*CAS009*/
                                                                                          /*CAS009*/
TAGE:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('E')
 
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
/*/COPY WNCPYSRC,DLC04030                                            */
 
             CALL       PGM(DL0307)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive file split +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/                                                                  */
/*/COPY WNCPYSRC,DLC04001                                            */
/*/                                                                  */
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
 
             SNDPGMMSG  MSG('Pay/Receive Settlements Report') +
                          TOMSGQ(MRUNQ)
 
             CALL       PGM(DL0320) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive settlements +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGF:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('F')
 
/* DLC2350B */
             SNDPGMMSG  MSG('Pay/Receive Telexes Report') TOMSGQ(MRUNQ)
 
/*           CHGJOB     SWS(XXXXXX1X)             */
/*           CALL       PGM(DL0308) PARM('     ') */
/************CHGJOB*****SWS(XXXXXX1X)             *         *062858*  *130302*/
/*   Ensure U4 is off before call to DL0308 */                       /*130302*/
             CHGJOB     SWS(XXX0XX1X)                                /*130302*/
             CALL       PGM(DL0308) PARM('     ')                    /*062858*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Complete pay/receive +
                          telexes failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGG:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('G')
 
             SNDPGMMSG  MSG('Incomplete Instructions Report') +
                          TOMSGQ(MRUNQ)
 
/************CHGJOB*****SWS(XXXXXX1X)                                /*130302*/
/*   Ensure U4 is off before call to DL0312 */                       /*130302*/
             CHGJOB     SWS(XXX0XX1X)                                /*130302*/
             CALL       PGM(DL0312) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Incomplete pay/receive +
                          telexes failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGH:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('H')
 
             SNDPGMMSG  MSG('Bankers Authorisations Report') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX1X)
             CALL       PGM(DL0314) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Bankers authorisations +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGI:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('I')
 
             SNDPGMMSG  MSG('Internal Settlements Report') +
                          TOMSGQ(MRUNQ)                               /*E29588*/
                                                                      /*E29588*/
/* Set switch for Retail/IoA (U1 in DL0318) */                        /*E29588*/
             IF         COND(&REON *EQ Y) THEN(CHGJOB SWS(1XXXXXXX))  /*E29588*/
             CALL       PGM(DL0318) PARM('     ')                     /*E29588*/
                                                                      /*E29588*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                 /*E29588*/
             CHGVAR     VAR(&MSG) VALUE('Internal Settlements failure')
             GOTO       CMDLBL(ERROR)                                 /*E29588*/
             ENDDO                                                    /*E29588*/
                                                                      /*E29588*/
             IF         COND(%SST(&MMOD 25 1) *EQ 'Y') THEN(DO)
 
TAGJ:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('J')              /*E29588*/
/* DLC2350D */
             OVRDBF FILE(CLOAN) SHARE(*NO)                           /*E40462*/
             OVRDBF FILE(DEALS) SHARE(*NO)                           /*E40462*/
/*/COPY WNCPYSRC,DLC04026                                            */
             CALL DL6315  /* COMIT DEALS ONLY */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive message +
                          generation failure')
             ROLLBACK
             CLRPFM     FILE(MGF100PD)
             CLRPFM     FILE(MGF200PD)
             CLRPFM     FILE(MGF202PD)
             CLRPFM     FILE(MGF210PD)
/*/COPY WNCPYSRC,DLC04008                                            */
             GOTO       CMDLBL(ERROR)
             ENDDO
                                                                                          /*CIR003*/
/* If CIR003 is installed, process FRA/IRS pay/receive message */                         /*CIR003*/
/* gneration for the exchange of principal for x-ccy swaps     */                         /*CIR003*/
                                                                                          /*CIR003*/
             IF COND(&CIR003 *EQ 'Y') THEN(DO)                                            /*CIR003*/
             CALL       PGM(DL6320) PARM('N')                                             /*CIR003*/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)                                     /*CIR003*/
             CHGVAR     VAR(&MSG) VALUE('Pay/receive message +
                          generation failure (FRA/IRS - DL6320)')                         /*CIR003*/
             ROLLBACK                                                                     /*CIR003*/
             CLRPFM     FILE(MGF100PD)                                                    /*CIR003*/
             CLRPFM     FILE(MGF200PD)                                                    /*CIR003*/
             CLRPFM     FILE(MGF202PD)                                                    /*CIR003*/
             CLRPFM     FILE(MGF210PD)                                                    /*CIR003*/
             GOTO       CMDLBL(ERROR)                                                     /*CIR003*/
             ENDDO                                                                        /*CIR003*/
             ENDDO                                                                        /*CIR003*/
 
/*/COPY WNCPYSRC,DLC04031                                            */
TAGK:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('K')     /*E29588*/
/*GJ:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('J')       E29588*/
 
/* GDFs records are deleted as they are processed */
/*/COPY WNCPYSRC,DLC04009                                            */
 
/*/COPY WNCPYSRC,DLC04032                                            */
/* Process customer transfer messages */
             CALL       PGM(MG0100)
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Customer transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)/* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process nostro transfer messages */
             CALL       PGM(MG0200)
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Nostro transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)/* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process Bank transfer messages */
             CALL       PGM(MG0202)
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Bank transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)/* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process notice to receive messages */
             CALL       PGM(MG0210)
 
/************IF*********COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +             */ /* 082024 */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)               /* 082024 */
             SNDPGMMSG  MSG('Notice to receive formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)/* 082024 */
/*************************TOMSGQ(MOPERQ) MSGTYPE(*INFO))         */ /* 082024 */
/************IF*********COND(%SWITCH(XXXXXXX1)) THEN(DO)         */ /* 082024 */
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/**********  RGZPFM     FILE(MGF100PD)                           */                       /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF100PD' '*FIRST')                          /*288542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGF200PD)                           */                       /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF200PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGF202PD)                           */                       /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF202PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGF210PD)                           */                       /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                   */                       /*228542*/
             CALL       PGM(SCC000060) PARM('MGF210PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**/                                                                  /*CDL008*/
             IF         COND(&CDL008 *EQ 'Y') THEN(DO)
                                                                      /*CDL008*/
                 CALL DL6316                                          /*CDL008*/
                                                                      /*CDL008*/
/* Database error processing */                                       /*CDL008*/
                                                                      /*CDL008*/
                 IF         COND(%SWITCH(XXXXXX11)) THEN(DO)          /*CDL008*/
                 CHGVAR     VAR(&MSG) VALUE('Pay/receive message +
                              generation failure')                    /*CDL008*/
                 ROLLBACK                                             /*CDL008*/
                 GOTO       CMDLBL(ERROR)                             /*CDL008*/
                 ENDDO                                                /*CDL008*/
                                                                      /*CDL008*/
/* Commit changes if no database error occurred*/                     /*CDL008*/
                                                                      /*CDL008*/
                 IF         COND(%SWITCH(XXXXXX00)) THEN(DO)          /*CDL008*/
                   COMMIT                                             /*CDL008*/
                 ENDDO                                                /*CDL008*/
                                                                      /*CDL008*/
/* Process bank transfer messages */                                  /*CDL008*/
                                                                      /*CDL008*/
                 CALL       PGM(MG0202)                               /*CDL008*/
                                                                      /*CDL008*/
/* Process notice to receive messages */                              /*CDL008*/
                                                                      /*CDL008*/
                 CALL       PGM(MG0210)                               /*CDL008*/
                                                                      /*CDL008*/
                 IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(SNDPGMMSG +
                          MSG('Bank transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)) /*CDL008*/
                 IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)          /*CDL008*/
                 ROLLBACK                                             /*CDL008*/
                 GOTO       CMDLBL(END)                               /*CDL008*/
                 ENDDO                                                /*CDL008*/
             ENDDO                                                    /*CDL008*/
                                                                      /*CDL008*/
/*/COPY WNCPYSRC,DLC04010                                            */
             ENDDO
/*/COPY WNCPYSRC,DLC04027                                            */
 
/* If ISO advices required (PF/SDMGMEPD, ENFFAR='N') print messages */
             IF         COND(&ENFFAR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             MONMSG     MSGID(CPF9870)                               /*E46234*/
             CALL PGM(ME0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ISO print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
 
TAGL:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('L')     /*E29588*/
/*GK:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('K')       E29588*/
 
/* Generate C.H.I.P.S. messages if interface present */
/************IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +       /*S01427*/
/************             THEN(CALL PGM(CHC01))                      /*S01427*/
 
             IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +
                          THEN(DO)                                    /*S01427*/
/**/                                                                  /*S01427*/
/*    RESET SWITCHES FOR APPROPRIATE PHASE (WERE CHANGED IN SWC2350)    S01427*/
/**/                                                                  /*S01427*/
              CHGJOB    SWS(010XXXXX)                                 /*S01427*/
              CALL PGM(CHC01)                                         /*S01427*/
 
              IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)             /*S01427*/
               RTVDTAARA  DTAARA(MCSTAT) RTNVAR(&MCSTAT)              /*S01427*/
               CHGVAR VAR(%SUBSTRING(&MCSTAT 2 1)) VALUE('N')         /*S01427*/
               CHGDTAARA  DTAARA(MCSTAT) VALUE(&MCSTAT)               /*S01427*/
               CLRPFM     FILE(CRCSVDD)                               /*S01427*/
               CLRPFM     FILE(CRCSVTT)                               /*S01427*/
              ENDDO                                                   /*S01427*/
             ENDDO                                                    /*S01427*/
                                                                      /*S01427*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('C.H.I.P.S. message +
                          generation failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGM:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('M')     /*E29588*/
/*GL:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('L')       E29588*/
 
/* DLC2350C */
             CALL       PGM(DL0330) PARM('     ')
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Update pay/receive +
                          indicators failure')
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/                                                                  */
/*/COPY WNCPYSRC,DLC04002                                            */
/**/                                                                  /*CFF003*/
/* If CFF003 is in the system, call */                                /*CFF003*/
/* OTC Update Pay/Receive Indicators program */                       /*CFF003*/
/**/                                                                  /*CFF003*/
             CHGVAR     VAR(&RTN) VALUE('       ')                    /*CFF003*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CFF003*/
             CHGVAR     VAR(&SARD) VALUE('CFF003')                    /*CFF003*/
/**/                                                                  /*CFF003*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*CFF003*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CFF003*/
                OVRDBF     FILE(TRANSD) MBR(OTC)                      /*CFF003*/
                CALL       PGM(FF0331)                                /*CFF003*/
             ENDDO                                                    /*CFF003*/
/*/                                                                  */
                                                                      /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
             CALL       PGM(MEC0890) PARM('DL' &TYPR 'ICJRN     ' +
                          &SDATE &STIME) /*E40242*/
             CHGVAR     VAR(&TYPR) VALUE(' ')                         /*E40242*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERROR)      /*E40242*/
                                                                      /*E29020*/
/* --------------------------------------------------------------- */ /*E29020*/
                                                                      /*E29020*/
TAGN:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('N')              /*E29588*/
/*GM:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('M')         E29020*E29588*/
                                                                      /*E29020*/
/***If*FRA/IRS*revaluations*flag*is*on***********************E46893*/ /*057243*/
/************IF COND(%SST(&MMOD 75 1) *EQ 'Y') THEN(DO)     *E46893*/ /*057243*/
/* */                                                                 /*057243*/
/** Access PF/SDMMODPD to determine whether FRA/IRS module is on   */ /*057243*/
/************                                                   057243/*S01522*/
/************CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)    057243/*S01522*/
/************                                                   057243/*S01522*/
/***Database*error handling                                  057243*/ /*S01522*/
/************                                                   057243/*S01522*/
/************IF         COND(&RTCD *NE '       ') THEN(DO)      057243/*S01522*/
/************     SNDPGMMSG  MSG('Error on access to ICD file + 057243/*S01522*/
/************                     SDMMODPD') TOMSGQ(MOPERQ)     057243/*S01522*/
/************     GOTO       CMDLBL(ERROR)                      057243/*S01522*/
/************ENDDO                                              057243/*S01522*/
/* */                                                                 /*057243*/
             IF         COND(%SST(&FMT 47 1) *EQ 'Y') THEN(DO)        /*057243*/
                                                                      /*E46893*/
/* Call DLC1962 to determine if MM Discount Factors need to be        /*E29020*/
/* rebuilt - and to rebuild them if necessary.                        /*E29020*/
/************CALL       PGM(DLC1962) PARM(' ')               *E29020* /*CIR001*/
             CALL       PGM(DLC1962) PARM(&TERM)                      /*CIR001*/
                                                                      /*E29020*/
/* Monitor for errors and send appropriate message to MOPERQ          /*E29020*/
             IF         COND((%SWITCH(XXXXXX11)) *OR (&TERM = 'E')) +
                          THEN(DO)                                    /*E29020*/
               CHGVAR     VAR(&MSG) VALUE('MM Discount Factors +
                            Rebuild has terminated abnormally.  +
                            Ensure that the Discount Factors are +
                            recalculated prior to FRA or IRS +
                            revaluation.')                            /*E29020*/
               GOTO       CMDLBL(ERROR)                               /*E29020*/
             ENDDO                                                    /*E29020*/
/**/                                                                  /*CIR001*/
/*  Determine if IRS Calendars installed                              /*CIR001*/
/**/                                                                  /*CIR001*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                     /*CIR001*/
           CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                     /*CIR001*/
           CHGVAR     VAR(&SAR) VALUE('CIR001')                       /*CIR001*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)    /*CIR001*/
           IF         COND(&RTCD *EQ '       ') +
                THEN(CHGVAR VAR(&CIR001) VALUE('Y'))                  /*CIR001*/
                                                                                          /*CAS001*/
/* Determine if Net Present Value Accounting is installed */                              /*CAS001*/
                                                                                          /*CAS001*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CAS001*/
           CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                         /*CAS001*/
           CHGVAR     VAR(&SAR) VALUE('CAS001')                                           /*CAS001*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                        /*CAS001*/
           IF         COND(&RTCD *EQ '       ') +
                THEN(CHGVAR VAR(&CAS001) VALUE('Y'))                                      /*CAS001*/
/**/                                                                  /*CIR001*/
/* Call DLC1966 to rebuild IRS discount Factors                       /*CIR001*/
/**/                                                                  /*CIR001*/
/*********** IF         COND(&CIR001 *EQ 'Y') THEN(DO)                         /*CIR001*/ /*CAS001*/
/**********  IF         COND((&CIR001 *EQ 'Y') *AND +   */                                /*205958*/
/**********               (&CAS001 *EQ 'N')) THEN(DO)   */                     /*CAS001*/ /*205958*/
             IF         COND(&CAS001 *EQ 'N') THEN(DO)                                    /*205958*/
             CALL       PGM(DLC1966) PARM(&TERM)                      /*CIR001*/
                                                                      /*CIR001*/
/* Monitor for errors and send appropriate message to MOPERQ          /*CIR001*/
             IF         COND((%SWITCH(XXXXXX11)) *OR (&TERM = 'E')) +
                          THEN(DO)                                    /*CIR001*/
             CHGVAR     VAR(&MSG) VALUE('IRS Discount Factors +
                          Rebuild has terminated abnormally.')        /*CIR001*/
               GOTO       CMDLBL(ERROR)                               /*CIR001*/
             ENDDO                                                    /*CIR001*/
           ENDDO                                                      /*CIR001*/
           ENDDO                                                      /*E46893*/
                                                                      /*E29020*/
/* --------------------------------------------------------------- */ /*E29020*/
 
             CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE(' ')
                                                                      /*CDL002*/
/*  Run Netting Pay/Receives                                          /*CDL002*/
             IF         COND(&CDL002 = 'Y') THEN(DO)                  /*CDL002*/
             CALL       PGM(DLC0360) PARM(&ERR)                       /*CDL002*/
             IF         COND(&ERR = 'Y') THEN(GOTO ERROR)             /*CDL002*/
             ENDDO                                                    /*CDL002*/
                                                                      /*CDL002*/
/* If Correspondence manager is switched on, delete overrides                             /*245403*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*245403*/
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                    /*245403*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*245403*/
             ENDDO                                                                        /*245403*/
/* */                                                                                     /*245403*/
/* SWIFT 2013 archiving  */                                                               /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(&CSW2013 *EQ 'CSW2013') THEN(DO)                             /*CSW213*/
                                                                                          /*CSW213*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                                    /*CSW213*/
             CHGVAR     VAR(&PREFIX) VALUE(%SST(&SDSTAT 6 2))                             /*CSW213*/
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')                           /*CSW213*/
                                                                                          /*CSW213*/
             CPYF       FROMFILE(MGF300EX) TOFILE(&DMLIB/MGF300TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(&CMG003 *EQ 'Y') THEN(DO)                                    /*CSW214*/
             CPYF       FROMFILE(MGF600EX) TOFILE(&DMLIB/MGF600TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CSW214*/
             ENDDO                                                                        /*CSW214*/
                                                                                          /*CSW214*/
             IF         COND(&CSW005 *EQ 'Y' *OR &CSW011 *EQ 'Y') THEN(DO)                /*CSW213*/
             CPYF       FROMFILE(MGF340EX) TOFILE(&DMLIB/MGF340TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                                      /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             IF         COND(&CSW005 *EQ 'Y') THEN(DO)                                    /*CSW213*/
/**********  CPYF       FROMFILE(MGF360EX) TOFILE(&DMLIB/MGF360TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                 */          /*CSW213 MD031673*/
/**********  CPYF       FROMFILE(MGF361EX) TOFILE(&DMLIB/MGF361TR) +
                          MBROPT(*ADD) CRTFILE(*YES)                 */          /*CSW213 MD031673*/
             CPYF       FROMFILE(MGF360EX) TOFILE(&DMLIB/MGX360TR) MBROPT(*ADD) +
                             CRTFILE(*YES)                                              /*MD031673*/
             CPYF       FROMFILE(MGF361EX) TOFILE(&DMLIB/MGX361TR) MBROPT(*ADD) +
                             CRTFILE(*YES)                                              /*MD031673*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             ENDDO                                                                        /*CSW213*/
                                                                                          /*CSW213*/
             GOTO       CMDLBL(END)
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmation & pay/receive +
                          generation failure')
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
                                                                      /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job, if   */ /*E40242*/
/* it has not already listed all the messages generated.           */ /*E40242*/
             IF         COND(&TYPR *NE ' ') THEN(DO)                  /*E40242*/
             CALL       PGM(MEC0890) PARM('DL' &TYPR 'ICJRN     ' +
                          &SDATE &STIME)                              /*E40242*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
             ENDDO                                                    /*E40242*/
                                                                      /*E40242*/
             CHGJOB     SWS(XXXXXX11)
/* */                                                                                     /*227780*/
/* If Correspondence manager is switched on, delete overrides                             /*227780*/
/**********  CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ') */                          /*227780*245403*/
/**********  CALL       PGM(CGC3605) PARM(&ACTION) */                              /*227780*245403*/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,DLC04011                                            */
RCLRSC                                                                /*089167*/
             ENDPGM
