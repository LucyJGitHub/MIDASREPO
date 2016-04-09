/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Deals file update - phase 2')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0606B - DEALS FILE UPDATE PHASE II                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CRE105             Date 03Mar15              */
/*       Prev Amend No. MD034346           Date 08May15              */
/*                      CGL165             Date 23Feb15              */
/*                      CER069             Date 03Jul14              */
/*                      MD027681           Date 02Jul14              */
/*                      AR755195           Date 13Dec13              */
/*                      CER059             Date 19Jul10              */
/*                      BUG23123           Date 09Mar09              */
/*                      BUG23008           Date 20Feb09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      205045             Date 06Jun06              */
/*                      CDL045             Date 14Feb06              */
/*                      CDL013             Date 06Jun06              */
/*                      CIR014             Date 11May06              */
/*                      233206 (Reopen)    Date 11May05              */
/*                      233206             Date 26Apr05              */
/*                      232928             Date 08Apr05              */
/*                      CAS009             Date 04May04              */
/*                      CDL039             Date 22Aug05              */
/*                      CDL033             Date 10Feb05              */
/*                      CDL027             Date 24Feb05              */
/*                      BUG4426            Date 04Oct04              */
/*                      BUG2494            Date 12May03              */
/*                      CDL012             Date 12Aug03              */
/*                    . CAS005             Date 05Sep03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      211652             Date 11Nov02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CIR007             Date 11May01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CIR003             Date 13Sep00              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CDL008             Date 02May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 30AUG96             */
/*                      S01408             DATE 11APR96             */
/*                      S01408             DATE 11MAY95             */
/*                      S01444             DATE 11APR95              */
/*                      S01408             DATE 20FEB95              */
/*                      058320             DATE 24MAR94              */
/*                      059223             DATE 27JAN94              */
/*                      S01383             DATE 27APR92              */
/*                      E36803             DATE 04MAR92              */
/*                      E29588             DATE 15OCT91              */
/*                      S01319             DATE 31OCT91              */
/*                      E27670             DATE 02OCT91              */
/*                      BH3106             DATE 08AUG91              */
/*                      E26335             DATE 23JUL91              */
/*                      E25586             DATE 21JUN91              */
/*                      LN1258             DATE  2MAY91              */
/*                      S01337             DATE 16APR91              */
/*                      BHF982             DATE 18FEB91              */
/*                      LN0747             DATE 13SEP90              */
/*                      LN0737             DATE 12SEP90              */
/*                      BHF486             DATE 27AUG90              */
/*                      BHF238             DATE 02JUL90              */
/*                      BHF236             DATE 28JUN90              */
/*                      BHF088             DATE 06JUN90              */
/*                      S01117             DATE 19/07/89             */
/*                      S01194             DATE 19/07/89             */
/*                      E18                DATE 31OCT89              */
/*                      S01189             DATE 23/05/89             */
/*                      S01179             DATE 12/09/88             */
/*                      S01147             DATE 03/12/87             */
/*                      S01119             DATE 17/06/87             */
/*                      E10356             DATE 18/02/87             */
/*                      S01093             DATE 22/09/86             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CRE105 - Withholding Tax Extract Report                     */
/*                Added hooks: CRE105_001, CRE105_002, CRE105_003    */
/*                             CRE105_004, CRE105_005, CRE105_006    */
/*       MD034346 - No data was shown on generated Reports after COB */
/*                   for  CGL165                                     */
/*       CGL165 - Dual Withholding Tax                               */
/*       CER069 - German Tax Enhancement                             */
/*       MD027681 - Incorrect calculation of interest with CDL034    */
/*       AR755195 - Back up PF/HISTSAA. (Child: AR755196)            */
/*                - Applied for MD024110                             */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23123 - Report: Does not show Retail Account Number      */
/*                          Date is not Midas Standard Date          */
/*                          Period should be actual int. calc. period*/
/*                          Secondary Tax amount is not printed      */
/*                          Added field TSSLID                       */
/*                          (Recompile)                              */
/*       BUG23008 - Cannot Agree Thresholds or Utilisations after COB*/
/*       205045 - Properly comment out BHF238 fix to remove override */
/*                DEALSL to DEALS.  Applied fix 103930.              */
/*       CDL045 - Copy out Account Keys file to Extract library      */
/*                as specified on the System Value parameter         */
/*                'AccountKeysSavedLib'                              */
/*                Upgrade to Midas Plus 1.2.                         */
/*       CDL013 - Tiered Withholding Tax                             */
/*       CIR014 - Mark to Market Cross-currency Interest Rate Swaps  */
/*       233206 - Error in DLC0606B                                  */
/*       232928 - Amortise all fees non-linearly, EIR calculation,   */
/*                Non-linear amortisation calculation & adjustment   */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       CDL039 - Amendable Deal Sub Types & Classes                 */
/*       CDL033 - Floating Rate CDs Issued.                          */
/*       CDL027 - Back-valued base rate changes: call to DL000050    */
/*       BUG4426 - Include file DLEMDAPD in restart recovery.        */
/*       BUG2494 - CPYF of DKEYSDP into DLACKRPD does not capture    */
/*                 errors arising from empty DKEYSDP.                */
/*       CDL012 - Interest Statements for Call/Time Deposits.        */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*       211652 - Create a reference copy of file DKEYSDP after      */
/*                the call to DL0280.                                */
/*       CIR007 - Overnight Index Swaps                              */
/*       CIR003 - Principal Exchange on Cross-Ccy IRS.               */
/*       CDL008 - Continuous Linked Settlement (Recompiled DEALSDB/  */
/*                MGOREFPD)                                          */
/*       S01408 - Addition of core hook DLC0606B04                   */
/*                Addition of core hook DLC0606B05                   */
/*                Addition of core hook DLC0606B06                   */
/*                Addition of core hook DLC0606B07                   */
/*                Addition of core hook DLC0606B08                   */
/*                Addition of core hook DLC0606B09                   */
/*       S01408 - Addition of core hook DLC0606B03                   */
/*                Addition of core hook DLC0606B02                   */
/*                Addition of core hook DLC0606B01                   */
/*       S01408 - Addition Of Core Hook DLC0606BM2                   */
/*                Addition of core hook DLC0606BME                   */
/*       S01444 - Restart and recovery processing for historic files */
/*       S01408 - Addition of core hook DLC0606BIN                   */
/*                Addition of core hook DLC0606BMP                   */
/*                Addition of core hook DLC0606BM1                   */
/*       058320 - Amend processing for BRT. Prevent duplicate        */
/*                key error in PTYSEQPD.                             */
/*       059223 - File reorganisation is too slow especially if      */
/*                done everyday.  So, reorganize DEALS files only    */
/*                during month-end.                                  */
/*       S01383 - BASIC RATE TAX INCORPORATION                       */
/*       E36803 - COMPONENT not restartable when adding LF's         */
/*                Removal of remove and add LF's to speed up         */
/*                processing, as updated in place and Reorg          */
/*                rebuilds access paths if required.                 */
/*       E29588 - SWIFT Rationalisation post-collection amendment    */
/*                 o Processing added to DL0280 to call MG5002 if    */
/*                   reversed deal is dropped. MG5002 increments     */
/*                   TRN for messages relating to dropped deal.      */
/*                 o Insert recovery processing for message files    */
/*                   in this program.                                */
/*       S01319 - Remove redundant processing                        */
/*       E27670 - MULTI-STREAM THE REORGANISE OF THE DEALS FILES     */
/*                AND ADDING OF LOGICAL FILE MEMBERS IN AN           */
/*                ATTEMPT TO SPEED UP JOB IN CLOSE OF BUSINESS       */
/*       BH3106 - REMOVE FILES FXTKDNLL, FXOTSWLL, FXOPTNLL,         */
/*                FXTODLLL, DEALSBRC AND FXMIDNLL IN AN ATTEMPT      */
/*                TO SPEED UP THE JOB IN CLOSE OF BUSINESS           */
/*       E26335 - Add new files and remove redundant ones            */
/*       E25586 - DEALSLL IS NOW REDUNDANT .CACUSDLL IS STILL        */
/*                IN USE BY DL2480                                   */
/*       LN1258 - THE FOLLOWING FILES ARE NOW REDUNDANT              */
/*                  EMDFX,EMDLS,EMDMM,EMFXDL,EMLSDL,EMMMDL           */
/*       S01337 - SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES     */
/*       BHF982 - ADDLFM SHOULD HAVE SHARE(*YES)                     */
/*       LN0747 - CACUSDL1 REPLACES CACUSDLL, FILE BY BRANCH         */
/*       LN0737 - MIDASQ USES CUSDL SO MUST ADD BACK (SEE BHF486)    */
/*       BHF486 - SPEED UP COB BY REMOVING REDUNDANT FILES. THIS WIL */
/*                SPEED UP DLC0606B WHICH IS A COB BOTTLENECK DUE TO */
/*                DEPENDANCIES. FILES WERE USED BY DL0170, DL0120    */
/*                  AND DL2480.                                      */
/*       BHF238 - DEALSL1 IS NEEDED FOR DL0280 SO ONLY REMOVE        */
/*              - THIS MEMBER IMMEDIATELY BEFORE REORGANIZING        */
/*       BHF236 - BHF088 ONLY DONE IF RESTART NOT EVERYTIME          */
/*       BHF088 - RMVM AND ADDPFM TO LF'S TO IMPROVE SPEED           */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01194 - STANDING DATA CHANGES                              */
/*       S01189 - COB recovery processing.                           */
/*       S01179 - AS400 CONVERSION                                   */
/*       S01147 - RELEASE 22                                         */
/*       S01119 - ADDITION OF FRA/IRS FILE                           */
/*       E10356 - MEMBER REMOVED FROM WRONG FILE                     */
/*       S01093 - REWRITTEN FOR UPDATE IN PLACE                      */
/*       E18    - REMOVE CALLING PARAMETERS                          */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*S01189*/
/*/COPY WNCPYSRC,DLC0606B04                                           /*S01408*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
/*/COPY WNCPYSRC,DLC0606B05                                           /*S01408*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/********    DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)                 /*S01189*/
             DCL        VAR(&SHAD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)                 /*S01147*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)               /*S01147*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
             DCL        VAR(&ADD) TYPE(*CHAR) LEN(5)                  /*E27670*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CIR003*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CIR003*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CIR003*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CIR003*/
             DCL        VAR(&CIR003) TYPE(*CHAR) LEN(1)                                   /*CIR003*/
             DCL        VAR(&CDL012) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CDL012*/
             DCL        VAR(&CDL027) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CDL027*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CAS009*/
/************DCL        VAR(&RGZ) TYPE(*CHAR) LEN(2)       */ /*E27670 059223*/
/*/COPY WNCPYSRC,DLC0606B15                                          */
/**/                                                                  /*S01147*/
                                                                                          /*CDL033*/
             DCL        VAR(&CDL033) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CDL033*/
                                                                                          /*CDL033*/
                                                                                          /*CDL033*/
                                                                                          /*CDL039*/
             DCL        VAR(&CDL039) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CDL039*/
                                                                                          /*CDL039*/
             DCL        VAR(&CIR014) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CIR014*/
                                                                                          /*CIR014*/
             DCL        VAR(&CGL165) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CGL165*/
                                                                                          /*CGL165*/
/*********   DCLDTAARA  DTAARA(SDSTAT)                           S01147 S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&CIR007) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CIR007*/
             DCL        VAR(&DKEYS) TYPE(*CHAR) LEN(10)                                   /*CDL045*/
             DCL        VAR(&DKEYS2) TYPE(*CHAR) LEN(10)                                  /*CDL045*/
             DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(8)                                   /*CDL045*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*CDL045*/
             DCL        VAR(&CDL045) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CDL045*/
             DCL        VAR(&CDL034) TYPE(*CHAR) LEN(1) VALUE(' ')                      /*MD027681*/
                                                                                          /*CDL045*/
/* Define parameters used in AOSVALR0 to retrieve system value                            /*CDL045*/
/*/COPY SDCPYSRC,SDSVALDCL                                                                /*CDL045*/
                                                                                          /*CDL045*/
             DCL        VAR(&CGL031) TYPE(*CHAR) LEN(1) VALUE('N')                        /*233206*/
/*/COPY OFCPYSRCZ,CRE105_001                                                              /*CRE105*/
/*  AOSARDRO variables.                                              */                   /*CDL013*/
             DCL        VAR(&CDL013) TYPE(*CHAR) LEN(7)                                   /*CDL013*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CDL013*/
/**/                                                                                      /*CDL013*/
             CALL       PGM(AOSARDR0) PARM(&CDL013 '*VERIFY' 'CDL013' +
                            &SFMT)                                                        /*CDL013*/
/**/                                                                                      /*CDL013*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC0606BIN                                           /*S01408*/
/**/                                                                  /*S01408*/
/** Determine if Floating Rate CD Issued feature is                  */                   /*CDL033*/
/** switched on.                                                     */                   /*CDL033*/
                                                                                          /*CDL033*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL033*/
             CHGVAR     VAR(&SARD) VALUE('CDL033')                                        /*CDL033*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CDL033*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL033) VALUE('Y'))                                        /*CDL033*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CDL033*/
             SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                          TOMSGQ(MOPERQ)                                                  /*CDL033*/
             CHGJOB     JOB(XXXXXX11)                                                     /*CDL033*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CRE105*/
/*/COPY OFCPYSRCZ,CRE105_002                                                              /*CRE105*/
                                                                                          /*CRE105*/
                                                                                          /*CDL033*/
/** Determine if Amendable Sub-Types feature is switched on.         */                   /*CDL039*/
                                                                                          /*CDL039*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL039*/
             CHGVAR     VAR(&SARD) VALUE('CDL039')                                        /*CDL039*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CDL039*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL039) VALUE('Y'))                                        /*CDL039*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CDL039*/
             SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                          TOMSGQ(MOPERQ)                                                  /*CDL039*/
             CHGJOB     JOB(XXXXXX11)                                                     /*CDL039*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CDL039*/
             ENDDO                                                                        /*CDL039*/
                                                                                          /*CDL039*/
/** Determine if Mark to Market Cross-currency Interest Rate Swaps is*/                   /*CIR014*/
/** switched on.                                                     */                   /*CIR014*/
                                                                                          /*CIR014*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CIR014*/
             CHGVAR     VAR(&SARD) VALUE('CIR014')                                        /*CIR014*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CIR014*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CIR014) VALUE('Y'))                                        /*CIR014*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CIR014*/
             SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                          TOMSGQ(MOPERQ)                                                  /*CIR014*/
             CHGJOB     JOB(XXXXXX11)                                                     /*CIR014*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CIR014*/
             ENDDO                                                                        /*CIR014*/
                                                                                          /*CIR014*/
/*********   RCVDTAARA  DTAARA(SDSTAT)                           S01147 S01179*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CIR003*/
             CHGVAR     VAR(&SARD) VALUE('CIR003')                                        /*CIR003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CIR003*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CIR003) VALUE('Y'))                                        /*CIR003*/
 /**/                                                                                     /*CIR003*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CIR003*/
                SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                                TOMSGQ(MOPERQ)                                            /*CIR003*/
                CHGJOB (XXXXXX11)                                                         /*CIR003*/
                GOTO       CMDLBL(ENDPGM)                                                 /*CIR003*/
             ENDDO                                                                        /*CIR003*/
                                                                                          /*CIR007*/
/** Check for Switchable feature CIR007                            */                     /*CIR007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CIR007*/
             CHGVAR     VAR(&SARD) VALUE('CIR007')                                        /*CIR007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                                           &FMT)                                          /*CIR007*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CIR007) VALUE('Y'))                                        /*CIR007*/
                                                                                          /*233206*/
/** Check for Switchable feature CGL031 **/                                               /*233206*/
                                                                                          /*233206*/
             CHGVAR      VAR(&OPTN) VALUE('*VERIFY')                                      /*233206*/
/**********  CHGVAR      VAR(&OPTN) VALUE('CGL031') ***/                           /*233206 233206*/
             CHGVAR      VAR(&SARD) VALUE('CGL031')                                       /*233206*/
             CALL        PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                         &FMT)                                                            /*233206*/
             IF          COND(&RTCD *EQ '       ') THEN(CHGVAR +
                           VAR(&CGL031) VALUE('Y'))                                       /*233206*/
 /**/                                                                                     /*CIR003*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL012*/
             CHGVAR     VAR(&SARD) VALUE('CDL012')                                        /*CDL012*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CDL012*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL012) VALUE('Y'))                                        /*CDL012*/
/** Check for Switchable feature CDL027                            */                     /*CDL027*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL027*/
             CHGVAR     VAR(&SARD) VALUE('CDL027')                                        /*CDL027*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CDL027*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL027) VALUE('Y'))                                        /*CDL027*/
                                                                                          /*CDL045*/
/** Check if Switchable feature CDL045 ON                          */                     /*CDL045*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL045*/
             CHGVAR     VAR(&SARD) VALUE('CDL045')                                        /*CDL045*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CDL045*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL045) VALUE('Y'))                                        /*CDL045*/
                                                                                          /*CDL045*/
 /**/                                                                                     /*CAS009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CAS009*/
             CHGVAR     VAR(&SARD) VALUE('CAS009')                                        /*CAS009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CAS009*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS009) VALUE('Y'))                                        /*CAS009*/
 /**/                                                                                     /*CAS009*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CAS009*/
                SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                                TOMSGQ(MOPERQ)                                            /*CAS009*/
                CHGJOB (XXXXXX11)                                                         /*CAS009*/
                GOTO       CMDLBL(ENDPGM)                                                 /*CAS009*/
             ENDDO                                                                        /*CAS009*/
/**/                                                                                    /*MD027681*/
/** Check for Switchable feature CDL034                            */                   /*MD027681*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                     /*MD027681*/
             CHGVAR     VAR(&SARD) VALUE('CDL034')                                      /*MD027681*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                                           &FMT)                                        /*MD027681*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL034) VALUE('Y'))                                      /*MD027681*/
/**/                                                                                    /*MD027681*/
/** Check for Switchable feature CER069                            */                     /*CER069*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER069*/
             CHGVAR     VAR(&SARD) VALUE('CER069')                                        /*CER069*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                                           &FMT)                                          /*CER069*/
             IF         COND(&RTCD *EQ '       ') THEN(CLRPFM +
                          FILE(SDTSCHPD))                                                 /*CER069*/
/**/                                                                                      /*CER069*/
/** Check for Switchable feature CGL165                            */                     /*CGL165*/
             IF         COND(&CSEQ *EQ 00001) THEN(DO)                                  /*MD034346*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGL165*/
             CHGVAR     VAR(&SARD) VALUE('CGL165')                                        /*CGL165*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                                           &FMT)                                          /*CGL165*/
/**/                                                                                      /*CER069*/
/** If CGL165 is On, clear the daily tax files                     */                     /*CGL165*/
             IF         COND(&RTCD *EQ '       ') THEN(CLRPFM +
                          FILE(DLDWTXPD))                                                 /*CGL165*/
             IF         COND(&RTCD *EQ '       ') THEN(CLRPFM +
                          FILE(REDWTXPD))                                                 /*CGL165*/
             ENDDO                                                                      /*MD034346*/
/**/                                                                                      /*CGL165*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
/*/COPY WNCPYSRC,DLC0606B18                                          */
/**/                                                                  /*S01147*/
                                                                                          /*CDL045*/
         IF         COND(&CDL045 *EQ 'Y') THEN(DO)                                        /*CDL045*/
                                                                                          /*CDL045*/
      /* Call AOSVALR0 to get system values for 'AccountKeysSavedLib' */                  /*CDL045*/
                                                                                          /*CDL045*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC  +
                          'AccountKeysSavedLib' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CDL045*/
                                                                                          /*CDL045*/
/* If there is an error finding any system value then end abnormally */                   /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ENDPGM))                                                 /*CDL045*/
                                                                                          /*CDL045*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                                /*CDL045*/
             CHGVAR     VAR(&EXTLIB) VALUE(%SST(&SVAL1 1 10))                             /*CDL045*/
             CHGVAR     VAR(&DKEYS) VALUE(&PRFX *CAT 'DKEYSDP')                           /*CDL045*/
             CHGVAR     VAR(&DKEYS2) VALUE(&PRFX *CAT 'DKEYSDP2')                         /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/

/* THESE ARE MANDATORY REPORTS SO PARMS ARE PASSED HARD CODED HERE */
             CHGVAR     VAR(&RENT) VALUE('ALL')                       /*S01117*/
             CHGVAR     VAR(&RSEQ) VALUE('     ')                     /*S01117*/

             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*S01147*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')    *S01147 S01337*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC0606BM2                                          */
                                                                      /*S01408*/
/**/
             RTVDTAARA  DTAARA(DLSTAT (21 1)) RTNVAR(&SHAD)
             IF         COND(&SHAD *EQ 'Y') THEN(CHGJOB SWS(11000000))
             ELSE       CMD(CHGJOB SWS(10000000))
/**/
             CLRPFM     FILE(DKEYSHH)
             CLRPFM     FILE(DKEYSDP)
             CLRPFM     FILE(DKEYSZZ)
             CLRPFM     FILE(MINTNMH)
             CLRPFM     FILE(MINTNMD)
             CLRPFM     FILE(MINTNMT)
             SNDPGMMSG  MSG('Deals File Update - Phase 2') +
                          TOMSGQ(MRUNQ)
/**/
/************RTVDTAARA  DTAARA(DLSTAT (17 3)) RTNVAR(&BUSY)           /*S01189*/
             CHGVAR     VAR(&STAT) VALUE(' ')                         /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*   IF RESTART, COPY BACK SAVED DEALS FILES */
/************IF         COND(&BUSY = 'NEW') THEN(DO)                  /*S01189*/
             IF         COND(&STAT = 'Y') THEN(DO)                    /*S01189*/
/************   RMVM       FILE(CUSDE) MBR(CUSDE)                     /*E36803*/
/************   MONMSG     MSGID(CPF0000)                             /*E36803*/
/*************  RMVM       FILE(CUSDL) MBR(CUSDL)                     /*BHF486*/
/*************  MONMSG     MSGID(CPF0000)                             /*BHF486*/
/************   RMVM       FILE(CUSDL) MBR(CUSDL)          /*LN0737*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*LN0737*/ /*E36803*/
/************   RMVM       FILE(DEALS) MBR(DEALS)                     /*E36803*/
/************   MONMSG     MSGID(CPF0000)                             /*E36803*/
/***********    RMVM       FILE(EMDFX) MBR(EMDFX)                    * *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                            * *LN1258*/
/***********    RMVM       FILE(EMDMM) MBR(EMDMM)                    * *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                            * *LN1258*/
/***********    RMVM       FILE(EMDLS) MBR(EMDLS)                    * *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                            * *LN1258*/
/***********    RMVM       FILE(EMFXDL) MBR(EMFXDL)                  * *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                            * *LN1258*/
/***********    RMVM       FILE(EMMMDL) MBR(EMMMDL)                  * *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                            * *LN1258*/
/***********    RMVM       FILE(EMLSDL) MBR(EMLSDL)                  * *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                            * *LN1258*/
/************RMVM       FILE(CACUSDLL) MBR(CACUSDLL)       /*LN0747*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*LN0747*/ /*E36803*/
/************RMVM       FILE(CACUSDLL) MBR(CACUSDLL)       /*E25586*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E25586*/ /*E36803*/
/************RMVM       FILE(CACUSDL1) MBR(CACUSDL1)       /*LN0747*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*LN0747*/ /*E36803*/
/************RMVM       FILE(CUSDEM) MBR(CUSDEM)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DEALSBRC) MBR(DEALSBRC)       /*BHF088*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BH3106*/
/************RMVM       FILE(DEALSH) MBR(DEALSH)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DEALSI) MBR(DEALSI)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DEALSL) MBR(DEALSL)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DEALSLL) MBR(DEALSLL)            *BHF088* *E25586*/
/************   MONMSG     MSGID(CPF0000)                     *BHF088* *E25586*/
/************RMVM       FILE(DLDLDGLA) MBR(DLDLDGLA)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGLB) MBR(DLDLDGLB)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGLC) MBR(DLDLDGLC)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGLD) MBR(DLDLDGLD)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGLE) MBR(DLDLDGLE)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGL1) MBR(DLDLDGL1)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGL2) MBR(DLDLDGL2)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGL3) MBR(DLDLDGL3)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGL4) MBR(DLDLDGL4)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGL5) MBR(DLDLDGL5)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGL6) MBR(DLDLDGL6)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGL7) MBR(DLDLDGL7)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDLDGL8) MBR(DLDLDGL8)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DRSDEALS) MBR(DRSDEALS)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/**********  RMVM       FILE(FXCUSDLL) MBR(FXCUSDLL)       /*BHF088*/ /*BHF486*/
/**********     MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BHF486*/
/************RMVM       FILE(FXMIDLLL) MBR(FXMIDLLL)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/*********** RMVM       FILE(MMCUSDLL) MBR(MMCUSDLL)       /*BHF088*/ /*BHF486*/
/***********    MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BHF486*/
/************RMVM       FILE(MMDLCSLL) MBR(MMDLCSLL)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT1L1R) MBR(EVNT1L1R)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT1L2R) MBR(EVNT1L2R)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT2JL1) MBR(EVNT2JL1)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT1JL1) MBR(EVNT1JL1)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT1JL2) MBR(EVNT1JL2)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT1R) MBR(EVNT1R)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT2J) MBR(EVNT2J)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT1J) MBR(EVNT1J)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT3J) MBR(EVNT3J)*******/   /*BHF088*/ /*E26335*/
/***************MONMSG     MSGID(CPF0000)**************/   /*BHF088*/ /*E26335*/
/************RMVM       FILE(CUSDLM) MBR(CUSDLM)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNTJL2) MBR(EVNTJL2)         /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNTJL1) MBR(EVNTJL1)         /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNTJL3) MBR(EVNTJL3)         /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(CAMIDNLL) MBR(CAMIDNLL)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(CUSDB) MBR(CUSDB)             /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/*           RMVM       FILE(DEALSL1) MBR(DEALSL1)         /*BHF088*/ /*BHF238*/
/*              MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BHF238*/
/************RMVM       FILE(FXMIDBLL) MBR(FXMIDBLL)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(FXOPTNLL) MBR(FXOPTNLL)       /*BHF088*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BH3106*/
/************RMVM       FILE(FXOTSWLL) MBR(FXOTSWLL)       /*BHF088*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BH3106*/
/************RMVM       FILE(FXTKDNLL) MBR(FXTKDNLL)       /*BHF088*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BH3106*/
/************RMVM       FILE(FXTODLLL) MBR(FXTODLLL)       /*BHF088*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BH3106*/
/************RMVM       FILE(MMDELULL) MBR(MMDELULL)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/*********** RMVM       FILE(MMDENQLL) MBR(MMDENQLL)       /*BHF088*/ /*BHF486*/
/***********    MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BHF486*/
/************RMVM       FILE(ABDELULL) MBR(ABDELULL)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM*******FILE(ABMIDSLL)*MBR(ABMIDSLL)*********BHF088*/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)********************BHF088*/ /*S01319*/
/************RMVM       FILE(DEALRP) MBR(DEALRP)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/**********  RMVM       FILE(FXDENQLL) MBR(FXDENQLL)       /*BHF088*/ /*BHF486*/
/**********     MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BHF486*/
/************RMVM       FILE(FXMIDNLL) MBR(FXMIDNLL)       /*BHF088*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*BH3106*/
/************RMVM*******FILE(MMMIDSLL)*MBR(MMMIDSLL)*********BHF088*/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)********************BHF088*/ /*S01319*/
/************RMVM       FILE(REPOD) MBR(REPOD)             /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(REPOM) MBR(REPOM)             /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLSDD1) MBR(DLSDD1)           /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(EVNT2JL2) MBR(EVNT2JL2)       /*BHF088*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF088*/ /*E36803*/
/************RMVM       FILE(DLDEALL) MBR(DLDEALL)         /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(CUSDL1) MBR(CUSDL1)           /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(DLDLFRLL) MBR(DLDLFRLL)       /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(DLDLIRLL) MBR(DLDLIRLL)       /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(DLFRIRLL) MBR(DLFRIRLL)       /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(DEALSR) MBR(DEALSR)           /*E27670*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E27670*/ /*E36803*/
/**/
                OVRDBF     FILE(DEALSDB) SEQONLY(*YES 100)
                OVRDBF     FILE(DEALSDC) SEQONLY(*YES 100)
                OVRDBF     FILE(DEALSDD) SEQONLY(*YES 100)
                OVRDBF     FILE(DEALSDE) SEQONLY(*YES 100)
                OVRDBF     FILE(DEALSDG) SEQONLY(*YES 100)            /*S01119*/
                OVRDBF     FILE(NEWDLDB) SEQONLY(*YES 100)
                OVRDBF     FILE(NEWDLDC) SEQONLY(*YES 100)
                OVRDBF     FILE(NEWDLDD) SEQONLY(*YES 100)
                OVRDBF     FILE(NEWDLDE) SEQONLY(*YES 100)
                OVRDBF     FILE(NEWDLDG) SEQONLY(*YES 100)            /*S01119*/
             OVRDBF     FILE(HISTSAA) SEQONLY(*YES 100)                                 /*AR755195*/
             OVRDBF     FILE(NEWHISTA) SEQONLY(*YES 100)                                /*AR755195*/
             IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                    /*CIR003*/
                 OVRDBF  FILE(NEWDLGX) SEQONLY(*YES 100)                                  /*CIR003*/
                 OVRDBF  FILE(DLGXSTPD) SEQONLY(*YES 100)                                 /*CIR003*/
             ENDDO                                                                        /*CIR003*/
/**/
                                                   /*Begin S01408*/
/*/COPY WNCPYSRC,DLC0606B03                                           /*S01408*/
                                                   /*End   S01408*/
             IF         COND(&CDL013 *EQ ' ') THEN(DO)                                    /*CDL013*/
               CPYF       FROMFILE(XGLWHTCPD) TOFILE(GLWHTCPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)                                /*CDL013*/
               MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM GLWHTCPD)                                          /*CDL013*/
               IF         COND(&CSEQ *NE 00001) THEN(DO)                                  /*CDL013*/
                  CPYF       FROMFILE(XGLXTAXPD) TOFILE(GLXTAXPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)                               /*CDL013*/
                  MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM GLXTAXPD)                                       /*CDL013*/
                ENDDO                                                                     /*CDL013*/
             ENDDO                                                                        /*CDL013*/
 /**/                                                                                     /*CDL013*/
                                                                                          /*CDL033*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
             OVRDBF     FILE(DLFRSCPD) SEQONLY(*YES 100)                                  /*CDL033*/
             OVRDBF     FILE(XDLFRSCPD) SEQONLY(*YES 100)                                 /*CDL033*/
             CPYF       FROMFILE(XDLFRSCPD) TOFILE(DLFRSCPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                                  /*CDL033*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DLFRSCPD))                                                 /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
                                                                                          /*CDL012*/
             IF         COND(&CDL012 *EQ 'Y') THEN(DO)                                    /*CDL012*/
                CPYF       FROMFILE(NEWDLTCST) TOFILE(DLTCSTPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                                  /*CDL012*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLTCSTPD)                                          /*CDL012*/
             ENDDO                                                                        /*CDL012*/
                                                                                          /*CDL012*/
             IF         COND(&CDL034 *EQ 'Y') THEN(DO)                                  /*MD027681*/
                CPYF       FROMFILE(XDLDIRHPD) TOFILE(DLDIRHPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                                /*MD027681*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLDIRHPD)                                        /*MD027681*/
             ENDDO                                                                      /*MD027681*/
/*/COPY OFCPYSRCZ,CRE105_003                                                              /*CRE105*/

                CPYF       FROMFILE(NEWDLDA) TOFILE(DEALSDA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDA)
                CPYF       FROMFILE(NEWDLDB) TOFILE(DEALSDB) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDB)
                CPYF       FROMFILE(NEWDLDC) TOFILE(DEALSDC) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDC)
                CPYF       FROMFILE(NEWDLDD) TOFILE(DEALSDD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDD)
                CPYF       FROMFILE(NEWDLDE) TOFILE(DEALSDE) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDE)
                CPYF       FROMFILE(NEWDLDF) TOFILE(DEALSDF) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDF)
                CPYF       FROMFILE(NEWDLDG) TOFILE(DEALSDG) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01119*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDG)                       /*S01119*/
             CPYF       FROMFILE(NEWHISTA) TOFILE(HISTSAA) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                                /*AR755195*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(HISTSAA))                                                /*AR755195*/
                IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                 /*CAS009*/
                   CPYF       FROMFILE(NEWMMCF) TOFILE(MMCFLSPD) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)                            /*CAS009*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(MMCFLSPD))                                           /*CAS009*/

                   CPYF       FROMFILE(NEWHISM) TOFILE(MMHISTHM) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)                            /*232928*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(MMHISTHM))                                           /*232928*/

                   CPYF       FROMFILE(NEWHISP) TOFILE(MMHISTHP) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)                            /*232928*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(MMHISTHP))                                           /*232928*/

                   CPYF       FROMFILE(NEWHISQ) TOFILE(MMHISTHQ) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)                            /*232928*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(MMHISTHQ))                                           /*232928*/

                ENDDO                                                                     /*CAS009*/
                IF         COND(&CGL031 *EQ 'Y') THEN(DO)                                 /*233206*/
                   CPYF       FROMFILE(NEWCSIN) TOFILE(SDCSINPD) +
                               MBROPT(*REPLACE) FMTOPT(*NONE)                             /*233206*/
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM SDCSINPD)                                       /*233206*/
                ENDDO                                                                     /*233206*/
                                                                                          /*CIR014*/
             IF         COND(&CIR014 *EQ 'Y') THEN(DO)                                    /*CIR014*/
                CPYF       FROMFILE(NEWDLDGQD) TOFILE(DLDLDGQD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)                                /*CIR014*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM FILE(DLDLDGQD))                                    /*CIR014*/
                           ENDDO                                                          /*CIR014*/
/*/COPY WNCPYSRC,DLC0606B10                                          */
                 CPYF      FROMFILE(NEWDLEMDA) TOFILE(DLEMDAPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                                 /*BUG4426*/
                 MONMSG    (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLEMDAPD)                                         /*BUG4426*/
                                                                                          /*CIR007*/
/** If CIR007 is on, copy back the saved OIS Postings Pending File */                     /*CIR007*/
             IF         COND(&CIR007 *EQ 'Y') THEN(DO)                                    /*CIR007*/
                CPYF       FROMFILE(DLOPOSPDX1) TOFILE(DLOPOSPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)                                /*CIR007*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLOPOSPD)                                          /*CIR007*/
                ENDDO                                                                     /*CIR007*/
                                                                                          /*CIR007*/
                                                                      /*S01444*/
                CPYF       FROMFILE(NEWHISB) TOFILE(DLBHISPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01444*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLBHISPD)                      /*S01444*/
                                                                      /*S01444*/
                CPYF       FROMFILE(NEWHISC) TOFILE(DLCHISPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01444*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLCHISPD)                      /*S01444*/
                                                                      /*S01444*/
                CPYF       FROMFILE(NEWHISD) TOFILE(DLDHISPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01444*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLDHISPD)                      /*S01444*/
                                                                      /*S01444*/
                CPYF       FROMFILE(NEWHISE) TOFILE(DLEHISPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01444*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLEHISPD)                      /*S01444*/
                                                                      /*S01444*/
                CPYF       FROMFILE(NEWHISG) TOFILE(DLGHISPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01444*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DLGHISPD)                      /*S01444*/
                IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                 /*CIR003*/
                    CPYF       FROMFILE(NEWDLGX) TOFILE(DLGXSTPD) +
                               MBROPT(*REPLACE) FMTOPT(*NONE)                             /*CIR003*/
                    MONMSG     (CPF2817) CMPDTA(CPF2869) +
                               EXEC(CLRPFM DLGXSTPD)                                      /*CIR003*/
                ENDDO                                                                     /*CIR003*/
/* E29588 - recover message files                                       E29588*/
/*/COPY WNCPYSRC,DLC0606B19                                          */
             CPYF       FROMFILE(MGOREFBK) TOFILE(MGOREFPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*E29588*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MGOREFPD))                             /*E29588*/
             CPYF       FROMFILE(MGOMSGBK) TOFILE(MGOMSGPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*E29588*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MGOMSGPD))                             /*E29588*/
/*/COPY WNCPYSRC,DLC0606B20                                          */
             CPYF       FROMFILE(XPTYSEQ) TOFILE(PTYSEQPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)          /*058320*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(PTYSEQPD))                         /*058320*/
             CPYF       FROMFILE(XDLNPVPPD) TOFILE(DLNPVPPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)                               /*CAS005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(DLNPVPPD))                                              /*CAS005*/
             IF         COND(&CDL027 *EQ 'Y') THEN(DO)                                    /*CDL027*/
             CPYF       FROMFILE(XDLIRLFPD) TOFILE(DLIRLFPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)                               /*CDL027*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(DLIRLFPD))                                              /*CDL027*/
             ENDDO                                                                        /*CDL027*/
             CPYF       FROMFILE(XSDINPHPD) TOFILE(SDINPHPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)                             /*BUG23008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(SDINPHPD))                                            /*BUG23008*/

/*/COPY WNCPYSRC,DLC0606B14                                          */
/*              ADDLFM     FILE(CUSDE) MBR(CUSDE) */                  /*BHF982*/
/************   ADDLFM     FILE(CUSDE) MBR(CUSDE) SHARE(*YES) *BHF982 /*E36803*/
/************   MONMSG     MSGID(CPF0000)                             /*E36803*/
/***************CHGDTAARA  DTAARA(DLSTAT (17 3)) VALUE('OLD')         /*S01189*/
                CHGVAR     VAR(&STAT) VALUE('N')                      /*S01189*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
             ENDDO
/*   SAVE DEALS FILES   */
             OVRDBF     FILE(DEALSDB) SEQONLY(*YES 100)
             OVRDBF     FILE(DEALSDC) SEQONLY(*YES 100)
             OVRDBF     FILE(DEALSDD) SEQONLY(*YES 100)
             OVRDBF     FILE(DEALSDE) SEQONLY(*YES 100)
             OVRDBF     FILE(DEALSDG) SEQONLY(*YES 100)               /*S01119*/
             OVRDBF     FILE(NEWDLDB) SEQONLY(*YES 100)
             OVRDBF     FILE(NEWDLDC) SEQONLY(*YES 100)
             OVRDBF     FILE(NEWDLDD) SEQONLY(*YES 100)
             OVRDBF     FILE(NEWDLDE) SEQONLY(*YES 100)
             OVRDBF     FILE(NEWDLDG) SEQONLY(*YES 100)               /*S01119*/
             OVRDBF     FILE(HISTSAA) SEQONLY(*YES 100)                                 /*AR755195*/
             OVRDBF     FILE(NEWHISTA) SEQONLY(*YES 100)                                /*AR755195*/
             IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                    /*CIR003*/
                 OVRDBF  FILE(NEWDLGX) SEQONLY(*YES 100)                                  /*CIR003*/
                 OVRDBF  FILE(DLGXSTPD) SEQONLY(*YES 100)                                 /*CIR003*/
             ENDDO                                                                        /*CIR003*/
/*/COPY WNCPYSRC,DLC0606B06                                           /*S01408*/
                                                                                          /*CDL033*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
             OVRDBF     FILE(DLFRSCPD) SEQONLY(*YES 100)                                  /*CDL033*/
             OVRDBF     FILE(XDLFRSCPD) SEQONLY(*YES 100)                                 /*CDL033*/
             DLTF       FILE(XDLFRSCPD)                                                   /*CDL033*/
             MONMSG     MSGID(CPF0000)                                                    /*CDL033*/
             CPYF       FROMFILE(DLFRSCPD) TOFILE(&TOLIB/XDLFRSCPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*CDL033*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
/**/                                                                  /*S01147*/
             DLTF       FILE(NEWDLDA)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDB)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDC)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDD)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDE)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDF)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDG)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWHISTA)                                                  /*AR755195*/
             MONMSG     MSGID(CPF0000)                                                  /*AR755195*/
             IF         COND(&CDL034 *EQ 'Y') THEN(DO)                                  /*MD027681*/
             DLTF       FILE(XDLDIRHPD)                                                 /*MD027681*/
             MONMSG     MSGID(CPF0000)                                                  /*MD027681*/
             ENDDO                                                                      /*MD027681*/
             IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                    /*CAS009*/
                DLTF       FILE(NEWMMCF)                                                  /*CAS009*/
                MONMSG     MSGID(CPF0000)                                                 /*CAS009*/

                DLTF       FILE(NEWHISM)                                                  /*232928*/
                MONMSG     MSGID(CPF0000)                                                 /*232928*/
                DLTF       FILE(NEWHISP)                                                  /*232928*/
                MONMSG     MSGID(CPF0000)                                                 /*232928*/
                DLTF       FILE(NEWHISQ)                                                  /*232928*/
                MONMSG     MSGID(CPF0000)                                                 /*232928*/

             ENDDO                                                                        /*CAS009*/
/*/COPY WNCPYSRC,DLC0606B11                                          */
              DLTF      FILE(NEWDLEMDA)                                                  /*BUG4426*/
              MONMSG    MSGID(CPF0000)                                                   /*BUG4426*/

/*/COPY OFCPYSRCZ,CRE105_004                                                              /*CRE105*/

                                                                                          /*CIR007*/
/** If CIR007 is on, delete existing backup copy of the OIS        */                     /*CIR007*/
/** Postings Pending file so that a new backup can be created      */                     /*CIR007*/
             IF         COND(&CIR007 *EQ 'Y') THEN(DO)                                    /*CIR007*/
                DLTF       FILE(DLOPOSPDX1)                                               /*CIR007*/
                MONMSG     MSGID(CPF0000)                                                 /*CIR007*/
             ENDDO                                                                        /*CIR007*/
             IF         COND(&CGL031 *EQ 'Y') THEN(DO)                                    /*233206*/
                DLTF       FILE(NEWCSIN)                                                  /*233206*/
                MONMSG     MSGID(CPF0000)                                                 /*233206*/
             ENDDO                                                                        /*233206*/
                                                                                          /*CIR007*/
             DLTF       FILE(NEWHISB)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             DLTF       FILE(NEWHISC)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             DLTF       FILE(NEWHISD)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             DLTF       FILE(NEWHISE)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             DLTF       FILE(NEWHISG)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                    /*CIR003*/
                DLTF       FILE(NEWDLGX)                                                  /*CIR003*/
                MONMSG     MSGID(CPF0000)                                                 /*CIR003*/
             ENDDO                                                                        /*CIR003*/
             DLTF       FILE(XPTYSEQ)                                 /*058320*/
             MONMSG     MSGID(CPF0000)                                /*058320*/
             DLTF       FILE(XDLNPVPPD)                                                   /*CAS005*/
             MONMSG     MSGID(CPF0000)                                                    /*CAS005*/
             IF         COND(&CDL027 *EQ 'Y') THEN(DO)                                    /*CDL027*/
             DLTF       FILE(XDLIRLFPD)                                                   /*CDL027*/
             MONMSG     MSGID(CPF0000)                                                    /*CDL027*/
             ENDDO                                                                        /*CDL027*/
/*/COPY WNCPYSRC,DLC0606B07                                           /*S01408*/
/**/
/*****       CPYF       FROMFILE(DEALSDA) TOFILE(NEWDLDA) +     *****  *S01147*/
/*****                   MBROPT(*REPLACE) FMTOPT(*NONE)         *****  *S01147*/
/*****       MONMSG     (CPF2817) CMPDTA(CPF2869) +             *****  *S01147*/
/*****                  EXEC(CLRPFM NEWDLDA)                    *****  *S01147*/
/**/                                                                  /*S01147*/
/*****       CPYF       FROMFILE(DEALSDB) TOFILE(NEWDLDB) +     *****  *S01147*/
/*****                   MBROPT(*REPLACE) FMTOPT(*NONE)         *****  *S01147*/
/*****       MONMSG     (CPF2817) CMPDTA(CPF2869) +             *****  *S01147*/
/*****                  EXEC(CLRPFM NEWDLDB)                    *****  *S01147*/
/**/                                                                  /*S01147*/
/*****       CPYF       FROMFILE(DEALSDC) TOFILE(NEWDLDC) +     *****  *S01147*/
/*****                   MBROPT(*REPLACE) FMTOPT(*NONE)         *****  *S01147*/
/*****       MONMSG     (CPF2817) CMPDTA(CPF2869) +             *****  *S01147*/
/*****                  EXEC(CLRPFM NEWDLDC)                    *****  *S01147*/
/**/                                                                  /*S01147*/
/*****       CPYF       FROMFILE(DEALSDD) TOFILE(NEWDLDD) +     *****  *S01147*/
/*****                   MBROPT(*REPLACE) FMTOPT(*NONE)         *****  *S01147*/
/*****       MONMSG     (CPF2817) CMPDTA(CPF2869) +             *****  *S01147*/
/*****                  EXEC(CLRPFM NEWDLDD)                    *****  *S01147*/
/**/                                                                  /*S01147*/
/*****       CPYF       FROMFILE(DEALSDE) TOFILE(NEWDLDE) +     *****  *S01147*/
/*****                   MBROPT(*REPLACE) FMTOPT(*NONE)         *****  *S01147*/
/*****       MONMSG     (CPF2817) CMPDTA(CPF2869) +             *****  *S01147*/
/*****                  EXEC(CLRPFM NEWDLDE)                    *****  *S01147*/
/**/                                                                  /*S01147*/
/*****       CPYF       FROMFILE(DEALSDF) TOFILE(NEWDLDF) +     *****  *S01147*/
/*****                   MBROPT(*REPLACE) FMTOPT(*NONE)         *****  *S01147*/
/*****       MONMSG     (CPF2817) CMPDTA(CPF2869) +             *****  *S01147*/
/*****                  EXEC(CLRPFM NEWDLDF)                    *****  *S01147*/
/**/                                                                  /*S01147*/
/*****       CPYF       FROMFILE(DEALSDG) TOFILE(NEWDLDG) +     *****  *S01147*/
/*****                   MBROPT(*REPLACE) FMTOPT(*NONE)         *****  *S01147*/
/*****       MONMSG     (CPF2817) CMPDTA(CPF2869) +             *****  *S01147*/
/*****                  EXEC(CLRPFM NEWDLDG)                    *****  *S01147*/
/**/                                                                  /*S01147*/
/*           CPYF       FROMFILE(DEALSDA) TOFILE(NEWDLDA.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) *S01147*S01179*/
             CPYF       FROMFILE(DEALSDA) TOFILE(&TOLIB/NEWDLDA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01179*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01147*/
/**/                                                                  /*S01147*/
/*********** CPYF       FROMFILE(DEALSDB) TOFILE(NEWDLDB.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) *S01147*S01179*/
             CPYF       FROMFILE(DEALSDB) TOFILE(&TOLIB/NEWDLDB) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01179*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01147*/
/**/                                                                  /*S01147*/
/*********** CPYF       FROMFILE(DEALSDC) TOFILE(NEWDLDC.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) *S01147*S01179*/
             CPYF       FROMFILE(DEALSDC) TOFILE(&TOLIB/NEWDLDC) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01179*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01147*/
/**/                                                                  /*S01147*/
/*********** CPYF       FROMFILE(DEALSDD) TOFILE(NEWDLDD.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) *S01147*S01179*/
             CPYF       FROMFILE(DEALSDD) TOFILE(&TOLIB/NEWDLDD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01179*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01147*/
/**/                                                                  /*S01147*/
/**********  CPYF       FROMFILE(DEALSDE) TOFILE(NEWDLDE.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) *S01147*S01179*/
             CPYF       FROMFILE(DEALSDE) TOFILE(&TOLIB/NEWDLDE) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01179*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01147*/
/**/                                                                  /*S01147*/
/************CPYF       FROMFILE(DEALSDF) TOFILE(NEWDLDF.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) *S01147*S01179*/
             CPYF       FROMFILE(DEALSDF) TOFILE(&TOLIB/NEWDLDF) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01179*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01147*/
/**/                                                                  /*S01147*/
/**********  CPYF       FROMFILE(DEALSDG) TOFILE(NEWDLDG.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES) *S01147*S01179*/
             CPYF       FROMFILE(DEALSDG) TOFILE(&TOLIB/NEWDLDG) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01179*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01147*/
             CPYF       FROMFILE(HISTSAA) TOFILE(&TOLIB/NEWHISTA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                 /*AR755195*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                                       /*AR755195*/
                                                                                          /*CIR014*/
             IF         COND(&CIR014 *EQ 'Y') THEN(DO)                                    /*CIR014*/
             CPYF       FROMFILE(DLDLDGQD) TOFILE(&TOLIB/NEWDLDGQD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*CIR014*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                                         /*CIR014*/
             ENDDO                                                                        /*CIR014*/
                                                                                          /*CIR014*/
             IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                    /*CIR003*/
                CPYF       FROMFILE(DLGXSTPD) TOFILE(&TOLIB/NEWDLGX) +
                           MBROPT(*REPLACE) CRTFILE(*YES) +
                           FMTOPT(*NONE)                                                  /*CIR003*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                                      /*CIR003*/
             ENDDO                                                                        /*CIR003*/
             IF         COND(&CGL031 *EQ 'Y') THEN(DO)                                    /*233206*/
                CPYF       FROMFILE(SDCSINPD) TOFILE(&TOLIB/NEWCSIN) +
                             MBROPT(*REPLACE) CRTFILE(*YES) +
                             FMTOPT(*NONE)                                                /*233206*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                                      /*233206*/
             ENDDO                                                                        /*233206*/
/*/COPY WNCPYSRC,DLC0606B12                                          */
             CPYF       FROMFILE(DLEMDAPD) TOFILE(&TOLIB/NEWDLEMDA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                              /*BUG4426*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                    /*BUG4426*/
             IF         COND(&CDL012 *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(DLTCSTPD) TOFILE(&TOLIB/NEWDLTCST) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*CDL012*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                                         /*CDL012*/
             ENDDO                                                                        /*CDL012*/
             IF         COND(&CDL034 *EQ 'Y') THEN(DO)                                  /*MD027681*/
             CPYF       FROMFILE(DLDIRHPD) TOFILE(&TOLIB/XDLDIRHPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                 /*MD027681*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                                       /*MD027681*/
             ENDDO                                                                      /*MD027681*/
             IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                    /*CAS009*/
                CPYF       FROMFILE(MMCFLSPD) TOFILE(&TOLIB/NEWMMCF) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*CAS009*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                                      /*CAS009*/

                CPYF       FROMFILE(MMHISTHM) TOFILE(&TOLIB/NEWHISM) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*232928*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                                      /*232928*/

                CPYF       FROMFILE(MMHISTHP) TOFILE(&TOLIB/NEWHISP) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*232928*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                                      /*232928*/

                CPYF       FROMFILE(MMHISTHQ) TOFILE(&TOLIB/NEWHISQ) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*232928*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                                      /*232928*/

             ENDDO                                                                        /*CAS009*/

/*/COPY OFCPYSRCZ,CRE105_005                                                              /*CRE105*/

                                                                                          /*CIR007*/
/** Make backup copy of the OIS Postings Pending file DLOPOSPD.                           /*CIR007*/
             IF         COND(&CIR007 *EQ 'Y') THEN(DO)                                    /*CIR007*/
                CPYF    FROMFILE(DLOPOSPD) TOFILE(&TOLIB/DLOPOSPDX1) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*CIR007*/
                MONMSG  (CPF2817) CMPDTA(CPF2869)                                         /*CIR007*/
             ENDDO                                                                        /*CIR007*/
                                                                                          /*CIR007*/
/**/                                                                  /*S01444*/
             CPYF       FROMFILE(DLBHISPD) TOFILE(&TOLIB/NEWHISB) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01444*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01444*/
/**/                                                                  /*S01444*/
             CPYF       FROMFILE(DLCHISPD) TOFILE(&TOLIB/NEWHISC) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01444*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01444*/
/**/                                                                  /*S01444*/
             CPYF       FROMFILE(DLDHISPD) TOFILE(&TOLIB/NEWHISD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01444*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01444*/
/**/                                                                  /*S01444*/
             CPYF       FROMFILE(DLEHISPD) TOFILE(&TOLIB/NEWHISE) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01444*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01444*/
/**/                                                                  /*S01444*/
             CPYF       FROMFILE(DLGHISPD) TOFILE(&TOLIB/NEWHISG) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*S01444*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                     /*S01444*/
/* E29588 - save message files                                          E29588*/
/*/COPY WNCPYSRC,DLC0606B21                                          */
             CPYF       FROMFILE(MGOREFPD) TOFILE(MGOREFBK) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*E29588*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MGOREFBK))                             /*E29588*/
             CPYF       FROMFILE(MGOMSGPD) TOFILE(MGOMSGBK) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)              /*E29588*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MGOMSGBK))                             /*E29588*/
/*/COPY WNCPYSRC,DLC0606B22                                          */
             CPYF       FROMFILE(PTYSEQPD) TOFILE(&TOLIB/XPTYSEQ) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                               /*058320*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XPTYSEQ))                          /*058320*/
             CPYF       FROMFILE(DLNPVPPD) TOFILE(&TOLIB/XDLNPVPPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*CAS005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XDLNPVPPD))                                             /*CAS005*/
             IF         COND(&CDL027 *EQ 'Y') THEN(DO)                                    /*CDL027*/
             CPYF       FROMFILE(DLIRLFPD) TOFILE(&TOLIB/XDLIRLFPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*CDL027*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XDLIRLFPD))                                             /*CDL027*/
             ENDDO                                                                        /*CDL027*/
             CPYF       FROMFILE(SDINPHPD) TOFILE(XSDINPHPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)                                /*BUG23008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(XSDINPHPD))                                           /*BUG23008*/

/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC0606BMP                                           /*S01408*/
/**/                                                                  /*S01408*/
/**/                                                                  /*S01147*/
/**********  DLTOVR     FILE(DEALSDB DEALSDC DEALSDD DEALSDE +     */                   /*AR755195*/
/**********      DEALSDG NEWDLDB NEWDLDC NEWDLDD NEWDLDE NEWDLDG)  */            /*S01119 AR755195*/
              /*          NEWDLDB NEWDLDC NEWDLDD NEWDLDE)    */      /*S01119*/
             DLTOVR     FILE(DEALSDB DEALSDC DEALSDD DEALSDE DEALSDG +
                          NEWDLDB NEWDLDC NEWDLDD NEWDLDE NEWDLDG +
                          HISTSAA NEWHISTA)                                             /*AR755195*/
             IF         COND(&CIR003 *EQ 'Y') THEN( +
                 DLTOVR   FILE(DLGXSTPD))                                                 /*CIR003*/
/*/COPY WNCPYSRC,DLC0606B08                                           /*S01408*/
                                                                                          /*CDL033*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
             DLTOVR     FILE(DLFRSCPD)                                                    /*CDL033*/
             DLTOVR     FILE(XDLFRSCPD)                                                   /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
/************CHGDTAARA  DTAARA(DLSTAT (17 3)) VALUE('NEW')            /*S01189*/
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*S01189*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*  DISABLE ACCESS PATHS WHILE FILE IS BEING UPDATED  */
/************RMVM       FILE(CUSDL) MBR(CUSDL)                        /*BHF486*/
/************MONMSG     MSGID(CPF0000)                                /*BHF486*/
/************RMVM       FILE(CUSDL) MBR(CUSDL)             /*LN0737*/ /*E36803*/
/************MONMSG     MSGID(CPF0000)                     /*LN0737*/ /*E36803*/
/************RMVM       FILE(DEALS) MBR(DEALS)                        /*E36803*/
/************MONMSG     MSGID(CPF0000)                                /*E36803*/
/*********** RMVM       FILE(EMDFX) MBR(EMDFX)                       * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*********** RMVM       FILE(EMDMM) MBR(EMDMM)                       * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*********** RMVM       FILE(EMDLS) MBR(EMDLS)                       * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*********** RMVM       FILE(EMFXDL) MBR(EMFXDL)                     * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*********** RMVM       FILE(EMMMDL) MBR(EMMMDL)                     * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*********** RMVM       FILE(EMLSDL) MBR(EMLSDL)                     * *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/****        RMVM       FILE(CACUSDLL) MBR(CACUSDLL)                  /*LN0747*/
/****           MONMSG     MSGID(CPF0000)                             /*LN0747*/
/************RMVM       FILE(CACUSDLL) MBR(CACUSDLL)       /*E25586*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E25586*/ /*E36803*/
/************RMVM       FILE(CACUSDL1) MBR(CACUSDL1)       /*LN0747*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*LN0747*/ /*E36803*/
/************RMVM       FILE(CUSDEM) MBR(CUSDEM)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DEALSBRC) MBR(DEALSBRC)       /*BHF236*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BH3106*/
/************RMVM       FILE(DEALSH) MBR(DEALSH)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DEALSI) MBR(DEALSI)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DEALSL) MBR(DEALSL)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DEALSLL) MBR(DEALSLL)            *BHF236* *E25586*/
/************   MONMSG     MSGID(CPF0000)                     *BHF236* *E25586*/
/************RMVM       FILE(DLDLDGLA) MBR(DLDLDGLA)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGLB) MBR(DLDLDGLB)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGLC) MBR(DLDLDGLC)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGLD) MBR(DLDLDGLD)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGLE) MBR(DLDLDGLE)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGL1) MBR(DLDLDGL1)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGL2) MBR(DLDLDGL2)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGL3) MBR(DLDLDGL3)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGL4) MBR(DLDLDGL4)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGL5) MBR(DLDLDGL5)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGL6) MBR(DLDLDGL6)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGL7) MBR(DLDLDGL7)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDLDGL8) MBR(DLDLDGL8)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DRSDEALS) MBR(DRSDEALS)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/**********  RMVM       FILE(FXCUSDLL) MBR(FXCUSDLL)       /*BHF236*/ /*BHF486*/
/**********     MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BHF486*/
/************RMVM       FILE(FXMIDLLL) MBR(FXMIDLLL)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/**********  RMVM       FILE(MMCUSDLL) MBR(MMCUSDLL)       /*BHF236*/ /*BHF486*/
/**********     MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BHF486*/
/************RMVM       FILE(MMDLCSLL) MBR(MMDLCSLL)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT1L1R) MBR(EVNT1L1R)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT1L2R) MBR(EVNT1L2R)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT2JL1) MBR(EVNT2JL1)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT1JL1) MBR(EVNT1JL1)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT1JL2) MBR(EVNT1JL2)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT1R) MBR(EVNT1R)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT2J) MBR(EVNT2J)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT1J) MBR(EVNT1J)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT3J) MBR(EVNT3J)*********/ /*BHF236*/ /*E26335*/
/***************MONMSG     MSGID(CPF0000)****************/ /*BHF236*/ /*E26335*/
/************RMVM       FILE(CUSDLM) MBR(CUSDLM)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNTJL2) MBR(EVNTJL2)         /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNTJL1) MBR(EVNTJL1)         /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNTJL3) MBR(EVNTJL3)         /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(CAMIDNLL) MBR(CAMIDNLL)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(CUSDB) MBR(CUSDB)             /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/*           RMVM       FILE(DEALSL1) MBR(DEALSL1)         /*BHF236*/ /*BHF238*/
/*              MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BHF238*/
/************RMVM       FILE(FXMIDBLL) MBR(FXMIDBLL)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(FXOPTNLL) MBR(FXOPTNLL)       /*BHF236*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BH3106*/
/************RMVM       FILE(FXOTSWLL) MBR(FXOTSWLL)       /*BHF236*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BH3106*/
/************RMVM       FILE(FXTKDNLL) MBR(FXTKDNLL)       /*BHF236*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BH3106*/
/************RMVM       FILE(FXTODLLL) MBR(FXTODLLL)       /*BHF236*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BH3106*/
/************RMVM       FILE(MMDELULL) MBR(MMDELULL)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/**********  RMVM       FILE(MMDENQLL) MBR(MMDENQLL)       /*BHF236*/ /*BHF486*/
/**********     MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BHF486*/
/************RMVM       FILE(ABDELULL) MBR(ABDELULL)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM*******FILE(ABMIDSLL)*MBR(ABMIDSLL)*********BHF236*/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)********************BHF236*/ /*S01319*/
/************RMVM       FILE(DEALRP) MBR(DEALRP)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/*********** RMVM       FILE(FXDENQLL) MBR(FXDENQLL)       /*BHF236*/ /*BHF486*/
/***********    MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BHF486*/
/************RMVM       FILE(FXMIDNLL) MBR(FXMIDNLL)       /*BHF236*/ /*BH3106*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*BH3106*/
/************RMVM*******FILE(MMMIDSLL)*MBR(MMMIDSLL)*********BHF236*/ /*S01319*/
/***************MONMSG*****MSGID(CPF0000)********************BHF236*/ /*S01319*/
/************RMVM       FILE(REPOD) MBR(REPOD)             /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(REPOM) MBR(REPOM)             /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLSDD1) MBR(DLSDD1)           /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(EVNT2JL2) MBR(EVNT2JL2)       /*BHF236*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*BHF236*/ /*E36803*/
/************RMVM       FILE(DLDEALL) MBR(DLDEALL)         /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(CUSDL1) MBR(CUSDL1)           /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(DLDLFRLL) MBR(DLDLFRLL)       /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(DLDLIRLL) MBR(DLDLIRLL)       /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(DLFRIRLL) MBR(DLFRIRLL)       /*E26335*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E26335*/ /*E36803*/
/************RMVM       FILE(DEALSR) MBR(DEALSR)           /*E27670*/ /*E36803*/
/************   MONMSG     MSGID(CPF0000)                  /*E27670*/ /*E36803*/
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                   /*S01194*/
/*********** OVRDBF     FILE(DEALS) TOFILE(DEALSL) */                 /*BHF238*/          /*205045*/
/*/COPY WNCPYSRC,DLC0606B23                                          */
             CLRPFM FILE(INTPSDD) MBR(NEW)                            /*S01383*/
             CLRPFM FILE(COINTDD) MBR(NEW)                            /*S01383*/
/************CLRPFM FILE(PTYSEQPD) MBR(NEW)                */ /*S01383 058320*/
             OVRDBF     FILE(DKEYSDP) SEQONLY(*YES 320)
             OVRDBF     FILE(INTPSDD) MBR(NEW)                        /*S01383*/
             OVRDBF     FILE(COINTDD) MBR(NEW)                        /*S01383*/
/************OVRDBF     FILE(PTYSEQPD) MBR(NEW)            */ /*S01383 058320*/
/*********** CALL       PGM(DL0280)                                   /*S01117*/
/************CALL       PGM(DL0280) PARM(&RSEQ &RENT)         /*E18     S01117*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC0606B01                                           /*S01408*/
/**/                                                                  /*S01408*/
        IF         COND(&CDL013 *EQ ' ') THEN(DO)                                         /*CDL013*/
             CHGDTAARA  DTAARA(GLWHT) VALUE('Y')                                          /*CDL013*/
   /* Take security copies */                                                             /*CDL013*/
             CPYF       FROMFILE(GLWHTCPD) TOFILE(&TOLIB/XGLWHTCPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*CDL013*/
             MONMSG     (CPF2817) CMPDTA(CPF2869)                                         /*CDL013*/
             IF         COND(&CSEQ *NE 00001) THEN(DO)                                    /*CDL013*/
                CPYF       FROMFILE(GLXTAXPD) TOFILE(&TOLIB/XGLXTAXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          FMTOPT(*NONE)                                                   /*CDL013*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                                      /*CDL013*/
             ENDDO                                                                        /*CDL013*/
             ELSE (DO)                                                                    /*CDL013*/
             CLRPFM     FILE(GLXTAXPD)                                                    /*CDL013*/
             MONMSG     (CPF0000)                                                         /*CDL013*/
             ENDDO                                                                        /*CDL013*/
          ENDDO                                                                           /*CDL013*/
/**/                                                                                      /*CDL013*/
             CALL       PGM(DL0280)                           /*E18     S01117*/
/*                                                                  */                    /*CDL013*/
        IF         COND(&CDL013 *EQ ' ') THEN(DO)                                         /*CDL013*/
             CHGDTAARA  DTAARA(GLWHT) VALUE('N')                                          /*CDL013*/
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)                                          /*CDL013*/
               DLTF       FILE(XGLWHTCPD)                                                 /*CDL013*/
               MONMSG     MSGID(CPF0000)                                                  /*CDL013*/
               DLTF       FILE(XGLXTAXPD)                                                 /*CDL013*/
               MONMSG     MSGID(CPF0000)                                                  /*CDL013*/
             ENDDO                                                                        /*CDL013*/
          ENDDO                                                                           /*CDL013*/

/*/COPY OFCPYSRCZ,CRE105_006                                                              /*CRE105*/

/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC0606B02                                           /*S01408*/
/**/                                                                  /*S01408*/
                                                                                          /*CDL039*/
/* Add deal sub type/class change account keys to DKEYSDP */                              /*CDL039*/
                                                                                          /*CDL039*/
             IF         COND(&CDL039 *EQ 'Y' *AND &CSEQ = 00001) THEN(DO)                 /*CDL039*/
             CALL       PGM(DLSTCLCR)                                                     /*CDL039*/
             ENDDO                                                                        /*CDL039*/
                                                                                          /*211652*/
/* Create a reference copy of PF/DKEYSDP */                                               /*211652*/
                                                                                          /*211652*/
             CPYF       FROMFILE(DKEYSDP) TOFILE(DLACKRPD) +
                          MBROPT(*REPLACE)                                                /*211652*/
                                                                                          /*211652*/
             MONMSG     (CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM DLACKRPD)                                          /*BUG2494*/
                                                                                         /*BUG2494*/
             DLTOVR     FILE(*ALL)
/*/COPY WNCPYSRC,DLC0606B24                                          */
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                GOTO    CMDLBL(ENDPGM)
             ENDDO
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                           TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                GOTO    CMDLBL(ENDPGM)
             ENDDO
                                                                                          /*CDL045*/
/* CDL045 - Copy out Account Keys file(s) to extract library   */                         /*CDL045*/
                                                                                          /*CDL045*/
         IF         COND(&CDL045 *EQ 'Y') THEN(DO)                                        /*CDL045*/
                                                                                          /*CDL045*/
  /*If Accrual Non-working Day process */                                                 /*CDL045*/
             IF         COND(&CSEQ = 00002) THEN(DO)                                      /*CDL045*/
             CPYF       FROMFILE(DKEYSDP) TOFILE(&EXTLIB/&DKEYS2) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&EXTLIB/&DKEYS2))                                          /*CDL045*/
                          ENDDO                                                           /*CDL045*/
  /* Daily Processing */                                                                  /*CDL045*/
             ELSE       CMD(DO)                                                           /*CDL045*/
             CPYF       FROMFILE(DKEYSDP) TOFILE(&EXTLIB/&DKEYS) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&EXTLIB/&DKEYS))                                           /*CDL045*/
  /* Clear out ANWD files */                                                              /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&DKEYS2)                                             /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
             ENDDO                                                                        /*CDL045*/
                                                                                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/
/*   SUCCESSFUL COMPLETION - REORG DEALS & CLEAR SAVED DEALS FILES  */

/*   Run IRS Rate Fixing Update                                                           /*CDL027*/
             IF         COND(&CDL027 *EQ 'Y') THEN(DO)                                    /*CDL027*/
             OVRDBF     FILE(DEALSDG) TOFILE(*LIBL/NEWDLDG) /* +
                          CDL027 */
             CALL       PGM(DL000050)                                                     /*CDL027*/
             DLTOVR     FILE(DEALSDG)                                                     /*CDL027*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CDL027*/
             SNDPGMMSG  MSG('JOB DL000050 TERMINATED-DATABASE IN +
                          ERROR') TOMSGQ(MOPERQ) MSGTYPE(*INFO)                           /*CDL027*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CDL027*/
             ENDDO                                                                        /*CDL027*/
             ENDDO                                                                        /*CDL027*/

/**********  RMVM       FILE(CUSDL) MBR(CUSDL)           */           /*E10356*/
/**********  RMVM       FILE(CUSDE) MBR(CUSDE)             /*E10356*/ /*E36803*/
/**********  RMVM       FILE(DEALSL1) MBR(DEALSL1)         /*BHF238*/ /*E36803*/
/**********  MONMSG     MSGID(CPF0000)                                /*E36803*/
/*  REORGANISE THE DEALS FILES IN BATCH JOBS */                       /*E27670*/
/************RGZPFM     FILE(DEALSDB)                                 /*E27670*/
/************MONMSG     MSGID(CPF2981)                                /*E27670*/
/************RGZPFM     FILE(DEALSDC)                                 /*E27670*/
/************MONMSG     MSGID(CPF2981)                                /*E27670*/
/************RGZPFM     FILE(DEALSDD)                                 /*E27670*/
/************MONMSG     MSGID(CPF2981)                                /*E27670*/
/************RGZPFM     FILE(DEALSDE)                                 /*E27670*/
/************MONMSG     MSGID(CPF2981)                                /*E27670*/
/************RGZPFM     FILE(DEALSDG)                                 /*E27670*/
/************MONMSG     MSGID(CPF2981)                                /*E27670*/
/************CRTDTAARA  DTAARA(&TOLIB/RGZJOB) TYPE(*CHAR)+ */ /*E27670 059223*/
/************                LEN(2)                        */ /*E27670 059223*/
/************SBMJOB     CMD(CALL PGM(DLC0606BR1))        + */ /*E27670 059223*/
/************                JOB(DLC0606BR1) JOBQ(MEODQ) + */ /*E27670 059223*/
/************                RTGDTA(MBATCH)                */ /*E27670 059223*/
/************SBMJOB     CMD(CALL PGM(DLC0606BR2))        + */ /*E27670 059223*/
/************                JOB(DLC0606BR2) JOBQ(MEODQ) + */ /*E27670 059223*/
/************                RTGDTA(MBATCH)                */ /*E27670 059223*/
/**/                                                                  /*E27670*/
/*  LOOP UNTIL ALL SUBMITTED JOBS ARE COMPLETED                 */    /*E27670*/
/**/                                                                  /*E27670*/
/***RGZFIN:**DLYJOB     DLY(60)                            */ /*E27670 059223*/
/************RTVDTAARA  DTAARA(&TOLIB/RGZJOB) RTNVAR(&RGZ) */ /*E27670 059223*/
/************IF         COND(&RGZ *NE 'NN') THEN(GOTO +    */ /*E27670 059223*/
/************             CMDLBL(RGZFIN))                  */ /*E27670 059223*/
/************DLTDTAARA  DTAARA(&TOLIB/RGZJOB)              */ /*E27670 059223*/
/************CHGDTAARA  DTAARA(DLSTAT (17 3)) VALUE('OLD')*/          /*S01189*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*S01189*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/*****       CLRPFM     FILE(NEWDLDA)                           *****  *S01147*/
/*****       CLRPFM     FILE(NEWDLDB)                           *****  *S01147*/
/*****       CLRPFM     FILE(NEWDLDC)                           *****  *S01147*/
/*****       CLRPFM     FILE(NEWDLDD)                           *****  *S01147*/
/*****       CLRPFM     FILE(NEWDLDE)                           *****  *S01147*/
/*****       CLRPFM     FILE(NEWDLDF)                           *****  *S01147*/
/*****       CLRPFM     FILE(NEWDLDG)                           *****  *S01147*/
             DLTF       FILE(NEWDLDA)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDB)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDC)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDD)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDE)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDF)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWDLDG)                                 /*S01147*/
             MONMSG     MSGID(CPF0000)                                /*S01147*/
             DLTF       FILE(NEWHISTA)                                                  /*AR755195*/
             MONMSG     MSGID(CPF0000)                                                  /*AR755195*/
             IF         COND(&CIR003 *EQ 'Y') THEN(DO)                                    /*CIR003*/
                DLTF       FILE(NEWDLGX)                                                  /*CIR003*/
                MONMSG     MSGID(CPF0000)                                                 /*CIR003*/
             ENDDO                                                                        /*CIR003*/
             IF         COND(&CGL031 *EQ 'Y') THEN(DO)                                    /*233206*/
                DLTF       FILE(NEWCSIN)                                                  /*233206*/
                MONMSG     MSGID(CPF0000)                                                 /*233206*/
             ENDDO                                                                        /*233206*/
/*/COPY WNCPYSRC,DLC0606B13                                          */
                                                                                          /*CDL033*/
             IF         COND(&CDL033 *EQ 'Y') THEN(DO)                                    /*CDL033*/
             DLTF       FILE(XDLFRSCPD)                                                   /*CDL033*/
             MONMSG     MSGID(CPF0000)                                                    /*CDL033*/
             ENDDO                                                                        /*CDL033*/
                                                                                          /*CDL033*/
                                                                                          /*CIR007*/
/** If CIR007 is on and process completed successfully, delete     */                     /*CIR007*/
/** backup copy of the OIS Postings Pending File                   */                     /*CIR007*/
             IF         COND(&CIR007 *EQ 'Y') THEN(DO)                                    /*CIR007*/
                DLTF       FILE(DLOPOSPDX1)                                               /*CIR007*/
                MONMSG     MSGID(CPF0000)                                                 /*CIR007*/
             ENDDO                                                                        /*CIR007*/
                                                                                         /*BUG4426*/
                DLTF       FILE(NEWDLEMDA)                                               /*BUG4426*/
                MONMSG     MSGID(CPF0000)                                                /*BUG4426*/
                RGZPFM     FILE(DLEMDAPD)                                                /*BUG4426*/
                MONMSG     MSGID(CPF0000)                                                /*BUG4426*/
                                                                                          /*CIR007*/
             IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                    /*CAS009*/
                DLTF       FILE(NEWMMCF)                                                  /*CAS009*/
                MONMSG     MSGID(CPF0000)                                                 /*CAS009*/

                DLTF       FILE(NEWHISM)                                                  /*232928*/
                MONMSG     MSGID(CPF0000)                                                 /*232928*/
                DLTF       FILE(NEWHISP)                                                  /*232928*/
                MONMSG     MSGID(CPF0000)                                                 /*232928*/
                DLTF       FILE(NEWHISQ)                                                  /*232928*/
                MONMSG     MSGID(CPF0000)                                                 /*232928*/

             ENDDO                                                                        /*CAS009*/
             DLTF       FILE(NEWHISB)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             DLTF       FILE(NEWHISC)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             DLTF       FILE(NEWHISD)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             DLTF       FILE(NEWHISE)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             DLTF       FILE(NEWHISG)                                 /*S01444*/
             MONMSG     MSGID(CPF0000)                                /*S01444*/
             DLTF       FILE(XPTYSEQ)                                 /*058320*/
             MONMSG     MSGID(CPF0000)                                /*058320*/
             DLTF       FILE(XDLNPVPPD)                                                   /*CAS005*/
             MONMSG     MSGID(CPF0000)                                                    /*CAS005*/
             IF         COND(&CDL027 *EQ 'Y') THEN(DO)                                    /*CDL027*/
             DLTF       FILE(XDLIRLFPD)                                                   /*CDL027*/
             MONMSG     MSGID(CPF0000)                                                    /*CDL027*/
             ENDDO                                                                        /*CDL027*/
                                                                                          /*CIR014*/
             IF         COND(&CIR014 *EQ 'Y') THEN(DO)                                    /*CIR014*/
             DLTF       FILE(NEWDLDGQD)                                                   /*CIR014*/
             MONMSG     MSGID(CPF0000)                                                    /*CIR014*/
             ENDDO                                                                        /*CIR014*/
/*/COPY WNCPYSRC,DLC0606B09                                           /*S01408*/
             DLTOVR     INTPSDD                                       /*S01383*/
             MONMSG     CPF0000                                       /*S01383*/
             DLTOVR     COINTDD                                       /*S01383*/
             MONMSG     CPF0000                                       /*S01383*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,DLC0606BM1                                           /*S01408*/
/**/                                                                  /*S01408*/
/************DLTOVR     PTYSEQPD                           */ /*S01383 058320*/
/************MONMSG     CPF0000                            */ /*S01383 058320*/
                CPYF   FROMFILE(INTPSDD) TOFILE(INTPSDD) +
                       FROMMBR(NEW) TOMBR(INTPSDD) MBROPT(*ADD)       /*S01383*/
                MONMSG (CPF2817) CMPDTA(CPF2869)                      /*S01383*/
/***************CPYF   FROMFILE(COINTDD) TOFILE(COINTDD) + */ /*S01383 058320*/
/***************            FROMMBR(NEW) TOMBR(COINTDD) +  */ /*S01383 058320*/
/***************            MBROPT(*ADD)                   */ /*S01383 058320*/
/***************MONMSG (CPF2817) CMPDTA(CPF2869)           */ /*S01383 058320*/
                CPYF   FROMFILE(COINTDD) TOFILE(COINTDD) +
                            FROMMBR(NEW) TOMBR(COINTDD) +
                            MBROPT(*ADD)                              /*058320*/
                MONMSG (CPF2817) CMPDTA(CPF2869)                      /*058320*/
/***************CPYF   FROMFILE(PTYSEQPD) TOFILE(PTYSEQPD) +
/***************       FROMMBR(NEW) TOMBR(PTYSEQPD) MBROPT(*ADD)      /*058320*/
/***************MONMSG (CPF2817) CMPDTA(CPF2869)                      /*058320*/
                CLRPFM FILE(INTPSDD) MBR(NEW)                         /*S01383*/
                CLRPFM FILE(COINTDD) MBR(NEW)                         /*S01383*/
/***************CLRPFM FILE(PTYSEQPD) MBR(NEW)             */ /*S01383 058320*/
/*/COPY WNCPYSRC,DLC0606B16                                          */
/*  ENABLE ACCESS PATHS  */
/*  THIS IS NOW PERFORMED IN BATCH JOBS */                            /*E27670*/
/*ENDPGM:      ADDLFM     FILE(CUSDE) MBR(CUSDE) */
/*ENDPGM:     ADDLFM     FILE(CUSDE) MBR(CUSDE) SHARE(*YES)           /*E27670*/
/***********  MONMSG     MSGID(CPF0000)                               /*E27670*/
/*********** ADDLFM     FILE(CUSDL) MBR(CUSDL)                        /*BHF486*/
/*********** MONMSG     MSGID(CPF0000)                                /*BHF486*/
/*           ADDLFM     FILE(CUSDL) MBR(CUSDL) */          /*LN0737*/ /*BHF982*/
/*********** ADDLFM     FILE(CUSDL) MBR(CUSDL) SHARE(*YES)            /*BHF982*/
/*********** MONMSG     MSGID(CPF0000)                                /*LN0737*/
/*           ADDLFM     FILE(DEALS) MBR(DEALS) */                     /*BHF982*/
/*********** ADDLFM     FILE(DEALS) MBR(DEALS) SHARE(*YES)    /*BHF982  E27670*/
/*********** MONMSG     MSGID(CPF0000)                                /*E27670*/
/*           ADDLFM     FILE(EMDFX) MBR(EMDFX) */                     /*BHF982*/
/*********** ADDLFM     FILE(EMDFX) MBR(EMDFX) SHARE(*YES)    *BHF982* *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*           ADDLFM     FILE(EMDMM) MBR(EMDMM) */                     /*BHF982*/
/*********** ADDLFM     FILE(EMDMM) MBR(EMDMM) SHARE(*YES)    *BHF982* *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*           ADDLFM     FILE(EMDLS) MBR(EMDLS) */                     /*BHF982*/
/*********** ADDLFM     FILE(EMDLS) MBR(EMDLS) SHARE(*YES)    *BHF982* *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*           ADDLFM     FILE(EMFXDL) MBR(EMFXDL) */                   /*BHF982*/
/*********** ADDLFM     FILE(EMFXDL) MBR(EMFXDL) SHARE(*YES)  *BHF982* *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*           ADDLFM     FILE(EMMMDL) MBR(EMMMDL) */                   /*BHF982*/
/*********** ADDLFM     FILE(EMMMDL) MBR(EMMMDL) SHARE(*YES)  *BHF982* *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/*           ADDLFM     FILE(EMLSDL) MBR(EMLSDL) */                   /*BHF982*/
/*********** ADDLFM     FILE(EMLSDL) MBR(EMLSDL) SHARE(*YES)  *BHF982* *LN1258*/
/*********** MONMSG     MSGID(CPF0000)                               * *LN1258*/
/****        ADDLFM     FILE(CACUSDLL) MBR(CACUSDLL)                  /*LN0747*/
/****        MONMSG     MSGID(CPF0000)                                /*LN0747*/
/*********** ADDLFM     FILE(CACUSDLL) MBR(CACUSDLL) SHARE(*YES)/*E25586E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*E25586E27670*/
/*           ADDLFM     FILE(CACUSDL1) MBR(CACUSDL1) */    /*LN0747*/ /*BHF982*/
/*********** ADDLFM     FILE(CACUSDL1) MBR(CACUSDL1) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*LN0747E27670*/
/*           ADDLFM     FILE(CUSDEM) MBR(CUSDEM) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(CUSDEM) MBR(CUSDEM) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DEALSBRC) MBR(DEALSBRC) */    /*BHF088*/ /*BHF982*/
/************ADDLFM     FILE(DEALSBRC) MBR(DEALSBRC) SHARE(*YES)/BHF982*BH3106*/
/************MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BH3106*/
/*           ADDLFM     FILE(DEALSH) MBR(DEALSH) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DEALSH) MBR(DEALSH) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DEALSI) MBR(DEALSI) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DEALSI) MBR(DEALSI) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DEALSL) MBR(DEALSL) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DEALSL) MBR(DEALSL) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DEALSLL) MBR(DEALSLL) */      /*BHF088*/ /*BHF982*/
/************ADDLFM     FILE(DEALSLL) MBR(DEALSLL) SHARE(*YES)*BHF982* *E25586*/
/************MONMSG     MSGID(CPF0000)                        *BHF088* *E25586*/
/*           ADDLFM     FILE(DLDLDGLA) MBR(DLDLDGLA) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGLA) MBR(DLDLDGLA) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGLB) MBR(DLDLDGLB) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGLB) MBR(DLDLDGLB) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGLC) MBR(DLDLDGLC) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGLC) MBR(DLDLDGLC) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGLD) MBR(DLDLDGLD) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGLD) MBR(DLDLDGLD) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGLE) MBR(DLDLDGLE) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGLE) MBR(DLDLDGLE) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGL1) MBR(DLDLDGL1) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGL1) MBR(DLDLDGL1) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGL2) MBR(DLDLDGL2) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGL2) MBR(DLDLDGL2) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGL3) MBR(DLDLDGL3) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGL3) MBR(DLDLDGL3) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGL4) MBR(DLDLDGL4) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGL4) MBR(DLDLDGL4) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGL5) MBR(DLDLDGL5) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGL5) MBR(DLDLDGL5) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGL6) MBR(DLDLDGL6) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGL6) MBR(DLDLDGL6) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGL7) MBR(DLDLDGL7) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGL7) MBR(DLDLDGL7) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLDLDGL8) MBR(DLDLDGL8) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLDLDGL8) MBR(DLDLDGL8) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DRSDEALS) MBR(DRSDEALS) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DRSDEALS) MBR(DRSDEALS) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/**********  ADDLFM     FILE(FXCUSDLL) MBR(FXCUSDLL)       /*BHF088*/ /*BHF486*/
/**********  MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BHF486*/
/*           ADDLFM     FILE(FXMIDLLL) MBR(FXMIDLLL) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(FXMIDLLL) MBR(FXMIDLLL) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/**********  ADDLFM     FILE(MMCUSDLL) MBR(MMCUSDLL)       /*BHF088*/ /*BHF486*/
/**********  MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BHF486*/
/*           ADDLFM     FILE(MMDLCSLL) MBR(MMDLCSLL) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(MMDLCSLL) MBR(MMDLCSLL) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT1L1R) MBR(EVNT1L1R) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNT1L1R) MBR(EVNT1L1R) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT1L2R) MBR(EVNT1L2R) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNT1L2R) MBR(EVNT1L2R) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT2JL1) MBR(EVNT2JL1) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNT2JL1) MBR(EVNT2JL1) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT2JL2) MBR(EVNT2JL2) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNT2JL2) MBR(EVNT2JL2) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT1JL1) MBR(EVNT1JL1) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNT1JL1) MBR(EVNT1JL1) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT1JL2) MBR(EVNT1JL2) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNT1JL2) MBR(EVNT1JL2) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT1R) MBR(EVNT1R) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNT1R) MBR(EVNT1R) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT2J) MBR(EVNT2J) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNT2J) MBR(EVNT2J) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT1J) MBR(EVNT1J) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNT1J) MBR(EVNT1J) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNT3J) MBR(EVNT3J) */        /*BHF088*/ /*BHF982*/
/************ADDLFM FILE(EVNT3J) MBR(EVNT3J) SHARE(*YES)*/ /*BHF982*/ /*E26335*/
/************MONMSG     MSGID(CPF0000)*******************/ /*BHF088*/ /*E26335*/
/*           ADDLFM     FILE(CUSDLM) MBR(CUSDLM) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(CUSDLM) MBR(CUSDLM) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNTJL2) MBR(EVNTJL2) */      /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNTJL2) MBR(EVNTJL2) SHARE(*YES)  /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNTJL1) MBR(EVNTJL1) */      /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNTJL1) MBR(EVNTJL1) SHARE(*YES)  /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(EVNTJL3) MBR(EVNTJL3) */      /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(EVNTJL3) MBR(EVNTJL3) SHARE(*YES)  /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(CAMIDNLL) MBR(CAMIDNLL) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(CAMIDNLL) MBR(CAMIDNLL) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(CUSDB) MBR(CUSDB) */          /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(CUSDB) MBR(CUSDB) SHARE(*YES)      /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DEALSL1) MBR(DEALSL1) */      /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DEALSL1) MBR(DEALSL1) SHARE(*YES)  /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(FXMIDBLL) MBR(FXMIDBLL) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(FXMIDBLL) MBR(FXMIDBLL) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(FXOPTNLL) MBR(FXOPTNLL) */    /*BHF088*/ /*BHF982*/
/************ADDLFM     FILE(FXOPTNLL) MBR(FXOPTNLL) SHARE(*YES)/BHF982*BH3106*/
/************MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BH3106*/
/*           ADDLFM     FILE(FXOTSWLL) MBR(FXOTSWLL) */    /*BHF088*/ /*BHF982*/
/************ADDLFM     FILE(FXOTSWLL) MBR(FXOTSWLL) SHARE(*YES)/BHF982*BH3106*/
/************MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BH3106*/
/*           ADDLFM     FILE(FXTKDNLL) MBR(FXTKDNLL) */    /*BHF088*/ /*BHF982*/
/************ADDLFM     FILE(FXTKDNLL) MBR(FXTKDNLL) SHARE(*YES)/*BHF982BH3106*/
/************MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BH3106*/
/*           ADDLFM     FILE(FXTODLLL) MBR(FXTODLLL) */    /*BHF088*/ /*BHF982*/
/************ADDLFM     FILE(FXTODLLL) MBR(FXTODLLL) SHARE(*YES)/BHF982*BH3106*/
/************MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BH3106*/
/*           ADDLFM     FILE(MMDELULL) MBR(MMDELULL) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(MMDELULL) MBR(MMDELULL) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/**********  ADDLFM     FILE(MMDENQLL) MBR(MMDENQLL)       /*BHF088*/ /*BHF486*/
/**********  MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BHF486*/
/*           ADDLFM     FILE(ABDELULL) MBR(ABDELULL) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(ABDELULL) MBR(ABDELULL) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(ABMIDSLL) MBR(ABMIDSLL) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(ABMIDSLL) MBR(ABMIDSLL) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DEALRP) MBR(DEALRP) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DEALRP) MBR(DEALRP) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/**********  ADDLFM     FILE(FXDENQLL) MBR(FXDENQLL)       /*BHF088*/ /*BHF486*/
/**********  MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BHF486*/
/*           ADDLFM     FILE(FXMIDNLL) MBR(FXMIDNLL) */    /*BHF088*/ /*BHF982*/
/************ADDLFM     FILE(FXMIDNLL) MBR(FXMIDNLL) SHARE(*YES)/BHF982*BH3106*/
/************MONMSG     MSGID(CPF0000)                     /*BHF088*/ /*BH3106*/
/*           ADDLFM     FILE(MMMIDSLL) MBR(MMMIDSLL) */    /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(MMMIDSLL) MBR(MMMIDSLL) SHARE(*YES)/*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(REPOD) MBR(REPOD) */          /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(REPOD) MBR(REPOD) SHARE(*YES)      /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(REPOM) MBR(REPOM) */          /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(REPOM) MBR(REPOM) SHARE(*YES)      /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*           ADDLFM     FILE(DLSDD1) MBR(DLSDD1) */        /*BHF088*/ /*BHF982*/
/*********** ADDLFM     FILE(DLSDD1) MBR(DLSDD1) SHARE(*YES)    /*BHF982E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*BHF088E27670*/
/*********** ADDLFM     FILE(DLDEALL) MBR(DLDEALL) SHARE(*YES)  /*E26335E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*E26335E27670*/
/*********** ADDLFM     FILE(CUSDL1) MBR(CUSDL1) SHARE(*YES)    /*E26335E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*E26335E27670*/
/*********** ADDLFM     FILE(DLDLFRLL) MBR(DLDLFRLL) SHARE(*YES)/*E26335E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*E26335E27670*/
/*********** ADDLFM     FILE(DLDLIRLL) MBR(DLDLIRLL) SHARE(*YES)/*E26335E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*E26335E27670*/
/*********** ADDLFM     FILE(DLFRIRLL) MBR(DLFRIRLL) SHARE(*YES)/*E26335E27670*/
/*********** MONMSG     MSGID(CPF0000)                          /*E26335E27670*/
/**ENDPGM:** CRTDTAARA  DTAARA(&TOLIB/ADDJOB) TYPE(*CHAR) LEN(5/*E27670*E36803*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BA1)) JOB(DLC0606BA1) +   /*E36803*/
/***********              JOBQ(MEODQ) RTGDTA(MBATCH)       /*E27670*/ /*E36803*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BA2)) JOB(DLC0606BA2) +   /*E36803*/
/***********              JOBQ(MEODQ) RTGDTA(MBATCH)       /*E27670*/ /*E36803*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BA3)) JOB(DLC0606BA3) +   /*E36803*/
/***********              JOBQ(MEODQ) RTGDTA(MBATCH)       /*E27670*/ /*E36803*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BA4)) JOB(DLC0606BA4) +   /*E36803*/
/***********              JOBQ(MEODQ) RTGDTA(MBATCH)       /*E27670*/ /*E36803*/
/*********** SBMJOB     CMD(CALL PGM(DLC0606BA5)) JOB(DLC0606BA5) +   /*E36803*/
/***********              JOBQ(MEODQ) RTGDTA(MBATCH)       /*E27670*/ /*E36803*/
/**/                                                                  /*E27670*/
/*  LOOP UNTIL ALL SUBMITTED JOBS ARE COMPLETED                       /*E27670*/
/**/                                                                  /*E27670*/
/**ADDFIN:** DLYJOB     DLY(60)                            /*E27670*/ /*E36803*/
/*********** RTVDTAARA  DTAARA(&TOLIB/ADDJOB) RTNVAR(&ADD)            /*E36803*/
/*********** IF         COND(&ADD *NE 'NNNNN') THEN(GOTO +            /*E36803*/
/***********              CMDLBL(ADDFIN))                  /*E27670*/ /*E36803*/
/*********** DLTDTAARA  DTAARA(&TOLIB/ADDJOB)              /*E27670*/ /*E36803*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,DLC0606BME                                           /*S01408*/
/**/                                                                  /*S01408*/
/*********** ENDPGM                                                   /*E36803*/
 ENDPGM:     ENDPGM                                                   /*SSSSS*/
