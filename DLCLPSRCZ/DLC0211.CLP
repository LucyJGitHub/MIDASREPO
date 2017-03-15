/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Input cycle pay/receive telexes')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - DEALING                                         */
/*                                                                   */
/*       DLC0211 - INPUT CYCLE PAY/RECEIVE PROCESSING                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD044140           Date 02Mar17              */
/*       Prev Amend No. 220343             Date 02Mar17              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CAS009             Date 04May04              */
/*                      228542             Date 05Aug04              */
/*                      CPK016             Date 04Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CIR003             Date 13Sep00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      105577             DATE 13MAY97              */
/*                      CFF003             DATE 11APR97              */
/*                      CDL002             DATE 17APR97              */
/*                      S01408             DATE 30AUG96              */
/*                      S01408             DATE 20SEP95              */
/*                      087845             DATE 15MAY95              */
/*                      061940             DATE 03JAN93              */
/*                      S01427             DATE 11JUL93              */
/*                      E40242             DATE 19JUN92              */
/*                      E33130             DATE 10DEC91              */
/*                      E29588             DATE 22OCT91              */
/*                      E26955             DATE 17OCT91              */
/*                      S01310             DATE 16APR91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD044140 - Ensure automatic submission of the job will      */
/*                  display the program name                         */
/*       220343 - Retrieve the value of the user profile that        */
/*                submitted the current job and override USRDTA      */
/*                of the ME0890P1 produced with the retrieved value. */
/*              - Applied for MD-44140                               */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CIR003 - Principal Exchange on Cross-Ccy IRS.               */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       105577 - Integrate fix 082042                               */
/*                Put correct related ref in cover MT202             */
/*       CFF003 - Enhanced OTC Processing - Phase II                 */
/*                Upgrade from BLI LBL001                            */
/*       CDL002 - FX Netting                                         */
/*       S01408 - Addition of Core Hook DLC0211003                   */
/*                Addition of Core Hook DLC0211004                   */
/*       S01408 - Addition of Core Hook DLC0211INT                   */
/*                Addition of Core Hook DLC0211001                   */
/*                Addition of Core Hook DLC0211002                   */
/*       087845 - System checks if Confirmations processing active   */
/*                before submitting Pay/Receive Generation, and goes */
/*                on DLYW if it is - this causes long delays if there*/
/*                are a number of confirmation jobs on the queue.    */
/*                MICJOBQ allows only 1 job at a time, so this check */
/*                is not necessary.                                  */
/*       061940 - E26955 Incorrect. Make 'GLOBAL' MOMMSG             */
/*                global again.                                      */
/*       S01427 - R10 CHIPS INCORPORATION                            */
/*       E40242 - CALL MEC0890 TO PRODUCE AUDIT LIST OF MESSAGES     */
/*                GENERATED                                          */
/*       E33130 - SEND MESSAGE TO OPERATOR WHEN JOB HAS COMPLETED    */
/*       E29588 - POST COLLECTION RATIONALISATION FIXES.             */
/*              - RE-INSATE CALL TO DL0308                           */
/*              - VARIOUS TEXT CHANGES.                              */
/*       E26955 - WORKSTATION ID REQUIRED FOR PAY/RCV ERROR MSGS.    */
/*                CALL P/R PROCESSING VIA FCC0201 WHICH CALLS        */
/*                DUMMY PROMPT PROGRAM MGC6000.                      */
/*       S01310 - RE WRITTEN FOR SWIFT RATIONALISATION               */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&RSEQ &RLEV &RENT)                         E26955*/
             PGM        PARM(&RSEQ &RLEV &RENT &WRK100)               /*E26955*/
/*/                                                                  */
/*/COPY WNCPYSRC,DLC0211INT                                          */
/**/                                                                  /*CFF003*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*CFF003*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*CFF003*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CFF003*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*CFF003*/
/*/                                                                  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
/************DCL        VAR(&FIVE) TYPE(*DEC) LEN(1 0) VALUE(1)         087845*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REON) TYPE(*CHAR) LEN(1) VALUE(N)
             DCL        VAR(&WRK100) TYPE(*CHAR) LEN(100)             /*E26955*/
             DCL        VAR(&WRKSTN) TYPE(*CHAR) LEN(10)              /*E26955*/
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1) VALUE(' ')       /*E33130*/
 
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
/************DCL        VAR(&CHSTAT) TYPE(*CHAR) LEN(256)             /*S01427*/
             DCL        VAR(&MCSTAT) TYPE(*CHAR) LEN(256)             /*S01427*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*CDL002*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')                                          /*CDL002*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)               /*CDL002*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CDL002*/
             DCL        VAR(&CDL002) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL002*/
             DCL        VAR(&CIR003) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CIR003*/
                                                                      /*E40242*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
/*/COPY WNCPYSRC,DLC0211013                                          */
 
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC011*/
             DCL        VAR(&S1SUPP) TYPE(*CHAR) LEN(2) VALUE(' ')                        /*CSC011*/
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2) VALUE(' ')                          /*CSC011*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
                                                                                          /*CSC011*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CAS009*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CAS009*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CAS009*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)                                   /*CAS009*/
                                                                                          /*CAS009*/
             DCL        VAR(&RTN_INFO) TYPE(*CHAR) LEN(512)                               /*220343*/
             DCL        VAR(&RTN_BIN) TYPE(*CHAR) LEN(4)                                  /*220343*/
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(10)                                  /*220343*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(26)                                     /*220343*/
             DCL        VAR(&INT_JOB_ID) TYPE(*CHAR) LEN(16)                              /*220343*/
             DCL        VAR(&SUBMITTER) TYPE(*CHAR) LEN(10)                               /*220343*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2) VALUE(' ')                        /*MD044140*/
                                                                                          /*220343*/
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))                             /*061940*/
/* */                                                                /*061940*/
/*  Access the Workstation address */
             CHGVAR     VAR(&WRKSTN) VALUE(%SST(&WRK100 1 10))        /*E26955*/
 
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +*/ /*061940*/
/************             CMDLBL(ERROR))                          */ /*061940*/
/*/COPY WNCPYSRC,DLC0211014                                          */
                                                                                          /*CSC011*/
/** Check if switchable feature CSC011 is on */                                           /*CSC011*/
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
                  SNDPGMMSG  MSG('Input Cycle Pay/Receive requested, +
                     but not valid on the support system') +
                     TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)                     /*CSC011*/
                  GOTO       CMDLBL(END)                                                  /*CSC011*/
             ENDDO                                                                        /*CSC011*/
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
 
/* Notify MRUNQ */
             SNDPGMMSG  MSG('Input Cycle Pay/Receive') +
                          TOMSGQ(MRUNQ)
 
/* Begin commitment control */
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) + */                /*CPK009*/ /*CPK016*/
/**********               CMTSCOPE(*JOB)                     */                /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
 
/* Zero switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(00000000)
/*/COPY WNCPYSRC,DLC0211006                                          */
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
 
/*/COPY WNCPYSRC,DLC0211011                                          */
 
/**/                                                                  /*CDL002*/
/* Check if switchable feature CDL002 is on (FX Netting) */           /*CDL002*/
/**/                                                                  /*CDL002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDL002*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDL002*/
             CHGVAR     VAR(&SAR) VALUE('CDL002')                     /*CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)  /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CDL002) VALUE('Y'))                      /*CDL002*/
/*/COPY WNCPYSRC,DLC0211019                                          */
/**/                                                                                      /*CIR003*/
/* Check if switchable feature CIR003 is on (Pay/Receive for Swaps)*/                     /*CIR003*/
/**/                                                                                      /*CIR003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CIR003*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CIR003*/
             CHGVAR     VAR(&SAR) VALUE('CIR003')                                         /*CIR003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR *SCSARD)                      /*CIR003*/
             IF         COND(&RTCD *EQ '       ') THEN( +
             CHGVAR     VAR(&CIR003) VALUE('Y'))                                          /*CIR003*/
 
/* Access MMOD for module details */
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
/* If Retail or IoA switched on, set Retail-on flag */
             IF         COND((%SUBSTRING(&MMOD 23 1) = 'Y') *OR +
                          (%SUBSTRING(&MMOD 16 1) = 'Y')) +
                          THEN(CHGVAR VAR(&REON) VALUE(Y))
 
/* C.H.I.P.S. processing */
             IF         COND(%SST(&MMOD 41 1) *EQ 'Y') THEN(DO)
 
/************RTVDTAARA  DTAARA(CHSTAT) RTNVAR(&CHSTAT)                /*S01427*/
             RTVDTAARA  DTAARA(MCSTAT) RTNVAR(&MCSTAT)                /*S01427*/
 
/************IF         COND(%SST(&CHSTAT 1 1) *EQ 'Y') THEN(DO)      /*S01427*/
             IF         COND(%SST(&MCSTAT 3 1) *EQ 'Y') THEN(DO)      /*S01427*/
             SNDPGMMSG  MSG('Previous C.H.I.P.S. Messages still +
                          outstanding - JOB CANNOT BE RUN') +
                          TOMSGQ(MOPERQ &WRKSTN)                      /*E26955*/
/************             TOMSGQ(MOPERQ)                                E26955*/
             GOTO END
             ENDDO
             ENDDO
 
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
/*  also check if Netting P/R has failed & posn 99 on DLSTAT          /*CDL002*/
/**********  IF         COND((%SUBSTRING(&DLSTAT 7 1) *EQ Y) *OR +
/**********               (%SUBSTRING(&DLSTAT 97 1) *NE ' ')) THEN(DO)/*CDL002*/
             IF         COND((%SUBSTRING(&DLSTAT 7 1) *EQ Y) *OR +
                          (%SUBSTRING(&DLSTAT 100 1) *NE ' ') *OR +
                          (%SUBSTRING(&DLSTAT 97 1) *NE ' ')) +
                          THEN(DO)                                    /*CDL002*/
/************SNDPGMMSG  MSG('DEALING PAY/RECEIVE PRINT REQUESTED BUT +
                          PAY/RECEIVE ALREADY ACTIVE/FAILED') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)   E29588 */
             SNDPGMMSG  MSG('Dealing Pay/Receive print requested but +
                          Pay/Receive already ACTIVE/FAILED') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ &WRKSTN)  /*E26955 E29588*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO)    E26955*/
             GOTO END
             ENDDO
/*/COPY WNCPYSRC,DLC0211012                                          */
                                                                      /*E40242*/
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
 
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
             CHGVAR     VAR(%SUBSTRING(&DLSTAT 7 1)) VALUE(Y)
             CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
 
/* Previous code for checking if confirmations active meant a five     087845*/
/* minute delay in some circumstances ; DL0105 checks for position 33  087845*/
/* on DTRIXHH which is reset at the end of DL0110 (Called by DLC0210A).087845*/
/* DLSTAT is set to Y in FXC0010 BEFORE DLC0210A is submitted and set  087845*/
/* to N at the end of DLC0210A. In certain circumstances if several    087845*/
/* of these jobs were submitted in succesion this meant that DL0105    087845*/
/* just sat on a delay wait. This also happened if this job was        087845*/
/* submitted via option PRPR and then subsequently someone submitted   087845*/
/* pay recieve generation after coming out of deal entry screen        087845*/
 
/* Note - because both DLC0210A and DLC0211A should be submitted to    087845*/
/* MICJOBQ and this should be a single stream JOBQ the 2 jobs should   087845*/
/* never be able to run at the same time anyway.                       087845*/
/* But just to be on the safe side check ONLY 1 of these flags DLSTAT  087845*/
/*                                                                     087845*/
/*********   IF         COND(%SST(&DLSTAT 6 1) *EQ 'Y') THEN(CALL +    087845*/
/*********                PGM(DL0105))                                 087845*/
 
/* DLC2350Z */
 
/* Check for confirmations still active */
/*RETRY:*****  RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)                087845*/
 
/********    IF         COND(%SST(&DLSTAT 6 1) *EQ 'Y') THEN(DO)        087845*/
/********    RCVMSG     WAIT(60) RMV(*NO)                               087845*/
/********    CHGVAR     VAR(&FIVE) VALUE(&FIVE + 1)                     087845*/
/********                                                               087845*/
/********    IF         COND(&FIVE *GT 5) THEN(GOTO CMDLBL(RETRY))      087845*/
/********    ELSE       CMD(DO)                                         087845*/
/************SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +         087845*/
/********                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)                   E29588*/
/********    SNDPGMMSG  MSG('Job CANNOT be run, confirmation job +      087845*/
/********                 still active') TOPGMQ(*EXT) TOMSGQ(MOPERQ +   087845*/
/********                 &WRKSTN)                       E26955 E29588  087845*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                   E26955*/
/********    GOTO END                                                   087845*/
/********    ENDDO                                                      087845*/
/********    ENDDO                                                      087845*/
 
/* Should not run Pay/Recs if last Confirmation run ended in error      E29588*/
             IF       COND(%SUBSTRING(&DLSTAT 98 1) *NE ' ') THEN(DO) /*E29588*/
             SNDPGMMSG  MSG('Dealing Pay/Receive print requested but +
                          last Confirmation run ended in error') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ &WRKSTN)         /*E29588*/
             GOTO END                                                 /*E29588*/
             ENDDO                                                    /*E29588*/
                                                                      /*E29588*/
/* Block large files */
             OVRDBF     FILE(PREXPH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX1PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX2PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX3PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX4PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX5PH) SEQONLY(*YES 50)
             OVRDBF     FILE(PREX6PH) SEQONLY(*YES 50)
 
             OVRDBF     FILE(TRANS) TOFILE(DTRIN)
 
             IF COND(%SST(&DLSTAT 99 1) *EQ 'D') THEN(GOTO TAGD)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'E') THEN(GOTO TAGE)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'F') THEN(GOTO TAGF)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'G') THEN(GOTO TAGG)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'H') THEN(GOTO TAGH)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'I') THEN(GOTO TAGI)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'J') THEN(GOTO TAGJ)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'K') THEN(GOTO TAGK)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'L') THEN(GOTO TAGL)
             IF COND(%SST(&DLSTAT 99 1) *EQ 'M') THEN(GOTO TAGM)
 
/* DLC2350A */
             CHGJOB     SWS(10000000)
 
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
/*/COPY WNCPYSRC,DLC0211017                                          */
 
TAGD:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('D')
 
             CLRPFM     FILE(PREXHH)
             CLRPFM     FILE(PREXPH)
             CLRPFM     FILE(PREXZZ)
/*/COPY WNCPYSRC,DLC0211003                                       */  /*S01408*/
             CHGJOB     SWS(XXXXXX1X)
             CALL DL1705
/*/COPY WNCPYSRC,DLC0211004                                       */  /*S01408*/
 
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
/*/COPY WNCPYSRC,DLC0211020                                          */
 
             CALL       PGM(DL0307)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive file split +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/                                                                  */
/*/COPY WNCPYSRC,DLC0211001                                          */
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
 
             SNDPGMMSG  MSG('Pay/Receive Settlements Report') +
                          TOMSGQ(MRUNQ)
 
             CALL       PGM(DL0320) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive settlements +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGF:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('F')
 
/* DLC2350B */
             SNDPGMMSG  MSG('Pay/Receive Telexes Report') TOMSGQ(MRUNQ)
 
/************CHGJOB     SWS(XXXXXX1X)           */
/************CALL       PGM(DL0308) PARM(&RSEQ) */
             CHGJOB     SWS(XXXXXX1X)                                 /*E29588*/
             CALL       PGM(DL0308) PARM(&RSEQ)                       /*E29588*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Complete pay/receive +
                          telexes failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGG:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('G')
 
             SNDPGMMSG  MSG('Incomplete Instructions Report') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX1X)
             CALL       PGM(DL0312) PARM(&RSEQ)
 
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
             CALL       PGM(DL0314) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Bankers authorisations +
                          failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGI:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('I')
 
             SNDPGMMSG  MSG('Internal Settlements Report') +
                          TOMSGQ(MRUNQ)
 
/* Set switch for Retail/IoA (U1 in DL0318) */
             IF         COND(&REON *EQ Y) THEN(CHGJOB SWS(1XXXXXXX))
             CALL       PGM(DL0318) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Internal Settlements failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF         COND(%SST(&MMOD 25 1) *EQ 'Y') THEN(DO)
 
/* CLEAR COVER MESSAGE FILE ONLY IF NOT A RE-RUN OF DL6315 */        /*105577*/
                                                                     /*105577*/
             CLRPFM     FILE(MGCOVRPD)                               /*105577*/
                                                                     /*105577*/
TAGJ:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('J')
 
/* DLC2350D */
             OVRDBF     FILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(DEALS) SHARE(*NO)
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
             CHGVAR     VAR(&RTN_BIN) VALUE(X'00000200')                                  /*220343*/
             CHGVAR     VAR(&FORMAT) VALUE('JOBI0300')                                    /*220343*/
             CHGVAR     VAR(&JOB) VALUE('*')                                              /*220343*/
             CALL       PGM(QUSRJOBI) PARM(&RTN_INFO &RTN_BIN +
                          &FORMAT &JOB &INT_JOB_ID)                                       /*220343*/
             CHGVAR     VAR(&SUBMITTER) VALUE(%SST(&RTN_INFO 127 10))                     /*220343*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                              /*MD044140*/
             IF         COND(&SUBMITTER *NE (&PRFX *CAT 'OWNER   ')) THEN(DO)           /*MD044140*/
             OVRPRTF    FILE(ME0890P1) USRDTA(&SUBMITTER)                                 /*220343*/
             ENDDO                                                                      /*MD044140*/
/*/COPY WNCPYSRC,DLC0211015                                          */
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
/*/COPY WNCPYSRC,DLC0211007                                          */
             GOTO       CMDLBL(ERROR)
             ENDDO
                                                                                          /*CIR003*/
/*/COPY WNCPYSRC,DLC0211021                                          */
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
 
TAGK:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('K')
 
/* GDFs records are deleted as they are processed */
/*/COPY WNCPYSRC,DLC0211008                                          */
 
/*/COPY WNCPYSRC,DLC0211005                                          */
/* Process customer transfer messages */
             CALL       PGM(MG0100)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Customer transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process nostro transfer messages */
             CALL       PGM(MG0200)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Nostro transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process Bank transfer messages */
             CALL       PGM(MG0202)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Bank transfer formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Process notice to receive messages */
             CALL       PGM(MG0210)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Notice to receive formatting failure') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ) MSGTYPE(*INFO))
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,DLC0211018                                          */
 
/**********  RGZPFM     FILE(MGF100PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF100PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF200PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF200PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF202PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF202PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MGF210PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF210PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/*/COPY WNCPYSRC,DLC0211009                                          */
             ENDDO
/*/COPY WNCPYSRC,DLC0211016                                          */
 
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
 
TAGL:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('L')
 
/* Generate C.H.I.P.S. messages if interface present */
/**********  IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +        /*S01427*/
/**********               THEN(CALL PGM(CHC01))                       /*S01427*/
                                                                      /*S01427*/
             IF         COND(%SUBSTRING(&MMOD 41 1) *EQ 'Y') +
                          THEN(DO)                                    /*S01427*/
/**/                                                                  /*S01427*/
/*    RESET SWITCHES FOR APPROPRIATE PHASE (WERE CHANGED IN SWC2350)  /*S01427*/
/**/                                                                  /*S01427*/
              CHGJOB    SWS(100XXXXX)                                 /*S01427*/
              CALL PGM(CHC01)                                         /*S01427*/
                                                                      /*S01427*/
              IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)             /*S01427*/
               RTVDTAARA  DTAARA(MCSTAT) RTNVAR(&MCSTAT)              /*S01427*/
               CHGVAR VAR(%SUBSTRING(&MCSTAT 2 1)) VALUE('N')         /*S01427*/
               CHGDTAARA  DTAARA(MCSTAT) VALUE(&MCSTAT)               /*S01427*/
               CLRPFM     FILE(CRCSVDD)                               /*S01427*/
               CLRPFM     FILE(CRCSVTT)                               /*S01427*/
              ENDDO                                                   /*S01427*/
             ENDDO                                                    /*S01427*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('C.H.I.P.S. message +
                          generation failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
/*                                                                  */
/*  TELEX INTERFACE                                                     E29588*/
TAGM:        CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE('M')
 
/* DLC2350C */
             CALL       PGM(DL0330) PARM(&RSEQ)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Update pay/receive +
                          indicators failure')
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/                                                                  */
/*/COPY WNCPYSRC,DLC0211002                                          */
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
 
/* Indicate that there has been no error within the CL stream */      /*E33130*/
             CHGDTAARA  DTAARA(DLSTAT (99 1)) VALUE(' ')
             CHGVAR     VAR(&ERR) VALUE('N')                          /*E33130*/
 
             GOTO       CMDLBL(END)
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Pay/receive generation +
                          failure')
             ENDDO
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Indicate that there has been an error within the CL stream */      /*E33130*/
             CHGVAR     VAR(&ERR) VALUE('Y')                          /*E33130*/
 
/**Send*database*error*message*to*workstation*&*MOPERQ */             /*E29588*/
/* Send database error message to MOPERQ */                           /*E29588*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             CHGJOB     SWS(XXXXXX11)
 
/* Reset busy flag in DLSTAT */
END:         ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD)) WAIT(32000)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(DLSTAT (7 1)) VALUE(N)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                      /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
             CALL       PGM(MEC0890) PARM('DL' 'P' 'ICJRN     ' +
                          &SDATE &STIME)                              /*E40242*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
/*/COPY WNCPYSRC,DLC0211010                                          */
 
/* Report to the user the Pay/Receive run has completed               /*E33130*/
/*  &ERR = 'Y' - error occured within the CL stream                   /*E33130*/
/*  &ERR = 'N' - no errors occured during CL stream                   /*E33130*/
/*  &ERR = ' ' - job could not be started, message already sent       /*E33130*/
                                                                      /*E33130*/
             IF         COND(&ERR *EQ 'Y') THEN(CHGVAR VAR(&MSG) +
                          VALUE('Dealing Pay/Receive run completed +
                          - ABNORMALLY'))                             /*E33130*/
 
             IF         COND(&ERR *EQ 'N') THEN(CHGVAR VAR(&MSG) +
                          VALUE('Dealing Pay/Receive run completed +
                          - SUCCESSFULLY'))                           /*E33130*/
 
/*/COPY WNCPYSRC,DLC0211022                                          */
             IF         COND(&ERR *NE ' ') THEN(DO)                   /*E33130*/
               SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          &WRKSTN) MSGTYPE(*INFO)                     /*E33130*/
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)              /*E33130*/
             ENDDO                                                    /*E33130*/
/*/COPY WNCPYSRC,DLC0211023                                          */
                                                                      /*E33130*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
