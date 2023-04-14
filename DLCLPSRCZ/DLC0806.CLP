/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Exposure limits & mat. FX deals')            */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                                */
/*                                                                  */
/*       DLC0806 - EXPOSURE AGAINST LIMITS & MATURITY OF FX DEALS   */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. EMP104             Date 22Apr20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CDL002             Date 22Sep97              */
/*                      S01433             Date 30Sep93              */
/*                      E40459             DATE 04JUN92             */
/*                      S01360             DATE 03MAR92             */
/*                      BHF934             DATE 26NOV90             */
/*                      BHF982             DATE 18FEB91             */
/*                      E273               DATE 16MAR90             */
/*                      E78                DATE 10JAN90             */
/*                      E108               DATE 27NOV89             */
/*                      E16341             DATE 14/03/89            */
/*                      S01117             DATE 17/07/89            */
/*                      S01194             DATE 17/07/89            */
/*                      S01179             DATE 12/09/88            */
/*                      S01098             DATE 22/09/86            */
/*                      S01105             DATE 22/09/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       EMP104 - Remove FX/IRS exposures and limits                 */
/*                (Upgrade NADC02 to FM2.1 SP23)                     */
/*                Amendment of core hook DLC0806001                  */
/*                Amendment of core hook DLC0806003                  */
/*                Amendment of core hook DLC0806004                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL002 - FX Netting. Set Switches for FX Net Event file     */
/*                processing                                         */
/*       S01433  -  ENHANCED DEALING LIMITS                         */
/*                  (NB. This function is to remain switchable until*/
/*                   after Alpha-site testing, when it will become  */
/*                   mandatory.)                                    */
/*       E40459 - S01362 put in a call to access program AOSARDR0,  */
/*                to check whether the SAR in question is enabled;  */
/*                however no call was coded with an option of *FREE,*/
/*                to close the file.  This meant that the file was  */
/*                open at Next-day set-up, preventing its being     */
/*                journalled.  A call to AOSARDR0 with *FREE has    */
/*                now been coded in the end processing, which       */
/*                should prevent this happening both now and for    */
/*                any calls to AOSARDR0 which may be added in the   */
/*                future.                                           */
/*       S01360  -  MONEY MARKET CUSTOMER EXPOSURE BY COUNTRY REPORT*/
/*       BHF934  -  RPG PROGRAMMES CALLED TWICE                     */
/*       BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                    */
/*       E273    - CHANGE POSITION OF PARMS ON CALL TO PROGRAM      */
/*       E78     -  ENSURE FULL EXPOSURE OR EXCEPTION ONLY REPORTING*/
/*                  PARAMETER IS PASSED                             */
/*       E1O8    -  REMOVE CALL TO DL068* - THEY HAVE THEIR OWN CL  */
/*                  ADD PARM &RSEQ TO CALLS TO DL0760, 780, 800     */
/*       E16341  -  EXPOSURE REPORT PROCESSING SHOULD BE DEPENDENT  */
/*                  ON THE PARAMETER PASSED TO THE PROGRAM AND NOT  */
/*                  ON MMOD POSITION 5                              */
/*       S01117  -  MULTIBRANCHING                                  */
/*       S01194  -  NEW STANDING DATA FILES                         */
/*       S01179  -  AS400 CONVERSION                                */
/*       S01098  -  AMENDMENT BLOCKS SELECTED LARGE FILES           */
/*       S01105  -  TO ENABLE LIMITS TO RUN WITH U1 ON              */
/*                                                                  */
/********************************************************************/
/**********  PGM                                                    *  *S1105*/
/*********** PGM        PARM(&PARM)                        /*S1105*/  /*S01117*/
/*******     PGM        PARM(&PARM &RSEQ &RLEV &RENT)      /*S01117*/ /*E273*/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)                 /*E273*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
/*********** DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)      /*S1105*/  /*E78*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)               /*E78*/
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('Job +
                          terminated - database in error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) VALUE('File +
                          controls out of balance')
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                /*S01360*/
/*********   DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) +              /*S01433*/
/*********                VALUE('*VERIFY')                    S01360  /*S01433*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)                /*S01433*/
/*********   DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6) +              /*S01433*/
/*********                VALUE('S01360')                     S01360  /*S01433*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)                /*S01433*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01433*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CDL002*/
/**/
/*********** DCLDTAARA   DTAARA(MMOD)                                   S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                /*S01433*/
             DCL        VAR(&CDL002) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL002*/
/*/COPY WNCPYSRC,DLC0806001                                          */
             DCL        VAR(&BNNTCE) TYPE(*CHAR) LEN(1) VALUE('N')    /*CDL002*/
/**/
/*********** RCVDTAARA   DTAARA(MMOD)                                   S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/**/
             CHGJOB      SWS(00000000)
/************SNDMSG      MSG('EXPOSURE AGAINST LIMITS REPORTING +     /*BHF934*/
/************               & MATURING FX DEALS REPORT')  TOMSGQ(MRUN /*BHF934*/
             SNDMSG     MSG('EXPOSURE AGAINST ALL LIMITS REPORTING') +
                          TOMSGQ(MRUNQ)                               /*BHF934*/
/**/
             RMVM        FILE(EVLSC) MBR(EVLSC)
             MONMSG      MSGID(CPF0000)
             RMVM        FILE(EVLSR) MBR(EVLSR)
             MONMSG      MSGID(CPF0000)
             RMVM        FILE(EVLSX) MBR(EVLSX)
             MONMSG      MSGID(CPF0000)
/**/
             CLRPFM      FILE(EVLXCEC)
             CLRPFM      FILE(EVLXCEE)
             CLRPFM      FILE(EVLXCEG)
             CLRPFM      FILE(EVLXCED)
             CLRPFM      FILE(EVLXCBH)                                /*S01360*/
             CLRPFM      FILE(EVLXCBE)                                /*S01360*/
/**/
             IF          COND(%SUBSTRING(&MMOD 4 1) = 'Y') +
                         THEN(CHGJOB   SWS(X1XXXXXX))
/**/
/**/
/*********** IF          COND(%SUBSTRING(&MMOD 5 1) = 'Y') +   */     /*E16341*/
/***********             THEN(CHGJOB   SWS(1XXXXXXX))          */     /*E16341*/
/*********** IF         COND(&PARM = 'Y') THEN(CHGJOB SWS(1XXXXXXX))E16341/E78*/
/**/
/*********** IF          COND(%SUBSTRING(&PARM 1 1) = 'Y') +          /*BHF934*/
/***********             THEN(CHGJOB   SWS(1XXXXXXX))        /*E78*/  /*BHF934*/
/**/
             SNDMSG      MSG('EXPOSURE LIMITS EXTRACT EXECUTING')  TOMSGQ(MRUNQ)
/*********** OVRDBF      FILE(TABLE) TOFILE(TABDLEE)                  /*S01194*/
/**/                                                                  /*S01098*/
/*                BLOCK LARGE FILES                                 *  *S01098*/
/**/                                                                  /*S01098*/
             OVRDBF      FILE(EVLXCED) SEQONLY(*YES 100)              /*S01098*/
             OVRDBF      FILE(EVLXCEE) SEQONLY(*YES 100)              /*S01098*/
                                                                      /*CDL002*/
/* FX Netting? */                                                     /*CDL002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CDL002')  /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL002) VALUE('Y'))                    /*CDL002*/
/*/COPY WNCPYSRC,DLC0806002                                          */
             CHGVAR     VAR(&RTCD) VALUE('*MSG   ')                   /*CDL002*/
             CALL       PGM(AODEALR0) PARM(&RTCD '*FIRST' &DSFDY)     /*CDL002*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&BNNTCE) VALUE(%SST(&DSFDY 94 +
                          94)))                                       /*CDL002*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CDL002*/
                                                                      /*CDL002*/
/**/                                                                  /*S01360*/
/* DETERMINE IF SAR INSTALLED */                                      /*S01360*/
/**/                                                                  /*S01360*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                  /*S01433*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                  /*S01433*/
             CHGVAR     VAR(&SSARD) VALUE('S01360')                   /*S01433*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)      /*S01360*/
/**/                                                                  /*S01360*/
/* ERROR */                                                           /*S01360*/
/**/                                                                  /*S01360*/
             IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                         /*S01360*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                        /*S01360*/
             CHGJOB (XXXXXX11)                                        /*S01360*/
             GOTO       CMDLBL(EXIT)                                  /*S01360*/
             ENDDO                                                    /*S01360*/
/**/                                                                  /*S01360*/
/* SAR INSTALLED */                                                   /*S01360*/
/* (MONEY MARKET CUSTOMER EXPOSURE BY COUNTRY REPORT) */              /*S01360*/
/**/                                                                  /*S01360*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)           /*S01360*/
                CHGJOB SWS(X1XXXXXX)                                  /*S01360*/
             ENDDO                                                    /*S01360*/
             CALL        PGM(DL0740)
             DLTOVR      FILE(EVLXCED)                                /*S01098*/
             DLTOVR      FILE(EVLXCEE)                                /*S01098*/
/**/
/*           ADDLFM      FILE(EVLSC) MBR(EVLSC) */                    /*BHF982*/
             ADDLFM      FILE(EVLSC) MBR(EVLSC) SHARE(*YES)           /*BHF982*/
             MONMSG      MSGID(CPF0000)
/*           ADDLFM      FILE(EVLSR) MBR(EVLSR) */                    /*BHF982*/
             ADDLFM      FILE(EVLSR) MBR(EVLSR) SHARE(*YES)           /*BHF982*/
             MONMSG      MSGID(CPF0000)
/*           ADDLFM      FILE(EVLSX) MBR(EVLSX) */                    /*BHF982*/
             ADDLFM      FILE(EVLSX) MBR(EVLSX) SHARE(*YES)           /*BHF982*/
             MONMSG      MSGID(CPF0000)
/**/
             RTVJOBA     SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
/**/
/***************SNDMSG     MSG('CUSTOMER EXPOSURE AGAINST LIMITS REPO /*BHF934*/
/***************              TOMSGQ(MRUNQ)                           /*BHF934*/
             SNDMSG     MSG('CUSTOMER EXPOSURE AGAINST ALL LIMITS +
                          REPORT') TOMSGQ(MRUNQ)                      /*BHF934*/
/*************  OVRDBF     FILE(TABLE)  TOFILE(TABDLEI)               /*S01194*/
/*****          CALL       PGM(DL0760)                                /*E108*/
/************** CALL       PGM(DL0760) PARM(&RSEQ)           /*E108*/ /*BHF934*/
/**/                                                                  /*S1105*/
/*************  IF COND(&PARM = 'Y') THEN(DO)               /*S1105*/ /*E78*/
                IF COND(%SUBSTRING(&PARM 1 1) = 'Y') THEN(DO)         /*E78*/
                   CHGJOB  SWS(10000000)                              /*S1105*/
                ENDDO                                                 /*BHF934*/
/*****             CALL    PGM(DL0760)                      /*S1105*/ /*E108*/
/*********         CALL    PGM(DL0760) PARM(&RSEQ)                    /*E108*/
/**/                                                                  /*S01433*/
/* DETERMINE IF SAR INSTALLED */                                      /*S01433*/
/**/                                                                  /*S01433*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01433*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                  /*S01433*/
             CHGVAR     VAR(&SAR) VALUE('S01433')                     /*S01433*/
                                                                      /*S01433*/
                                                                      /*CDL002*/
             IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
                CHGJOB     SWS(XX1XXXXX)                              /*CDL002*/
             ENDDO                                                    /*CDL002*/
                                                                      /*CDL002*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &SOPTN &SAR)         /*S01433*/
/*/COPY WNCPYSRC,DLC0806003                                          */
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                        PGM(DL0760A) PARM(&RSEQ))                     /*S01433*/
             ELSE       CMD(CALL PGM(DL0760) PARM(&RSEQ))             /*S01433*/
/*/COPY WNCPYSRC,DLC0806004                                          */
                                                                      /*CDL002*/
             IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
                CHGJOB     SWS(XX0XXXXX)                              /*CDL002*/
             ENDDO                                                    /*CDL002*/
                                                                      /*CDL002*/
/**/                                                                  /*S01360*/
/* SAR INSTALLED */                                                   /*S01360*/
/* (MONEY MARKET CUSTOMER EXPOSURE BY COUNTRY REPORT) */              /*S01360*/
/**/                                                                  /*S01360*/
             IF         COND(&SRTCD *EQ '       ') THEN(DO)           /*S01360*/
                   CALL    PGM(DL0765) PARM(&RSEQ)                    /*S01360*/
             ENDDO                                                    /*S01360*/
                   CHGJOB  SWS(0XXXXXXX)                              /*S1105*/
/************** ENDDO                                       /*S1105*/ /*BHF934*/
/**/                                                                  /*S1105*/
                RTVJOBA    SWS(&SWS)
/**/
                IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
/**/
/***************** SNDMSG     MSG('EXPOSURE BY COUNTRY OF RISK REPORT /*BHF934*/
/*****************               TOMSGQ(MRUNQ)                        /*BHF934*/
             SNDMSG     MSG('COUNTRY OF RISK EXPOSURE AGAINST ALL +
                          LIMITS REPORT') TOMSGQ(MRUNQ)               /*BHF934*/
/*****             CALL       PGM(DL0780)                             /*E108*/
/**************    CALL    PGM(DL0780) PARM(&RSEQ)           /*E108*/ /*BHF934*/
/**/                                                                  /*S1105*/
/***************** IF COND(&PARM = 'Y') THEN(DO)            /*S1105*/ /*E78*/
                   IF COND(%SUBSTRING(&PARM 1 1) ='Y') THEN(DO)       /*E78*/
                      CHGJOB  SWS(10000000)                           /*S1105*/
                   ENDDO                                              /*BHF934*/
/*****                CALL    PGM(DL0780)                   /*S1105*/ /*E108*/
                                                                      /*CDL002*/
             IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
                CHGJOB     SWS(XX1XXXXX)                              /*CDL002*/
             ENDDO                                                    /*CDL002*/
                                                                      /*CDL002*/
                      CALL    PGM(DL0780) PARM(&RSEQ)                 /*E108*/
                                                                      /*CDL002*/
             IF         COND((&CDL002 *EQ 'Y') *AND (&BNNTCE *EQ +
                          'Y')) THEN(DO)                              /*CDL002*/
                CHGJOB     SWS(XX0XXXXX)                              /*CDL002*/
             ENDDO                                                    /*CDL002*/
                                                                      /*CDL002*/
                      CHGJOB  SWS(0XXXXXXX)                           /*S1105*/
/***************** ENDDO                                    /*S1105*/ /*BHF934*/
/**/                                                                  /*S1105*/
                   RTVJOBA    SWS(&SWS)
/**/
                   IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
/**/
/*****************    SNDMSG MSG('EXPOSURE BY REGION OF RISK REPORT' /*BHF934*/
/*****************       TOMSGQ(MRUNQ)                               /*BHF934*/
             SNDMSG     MSG('REGION OF RISK EXPOSURE AGAINST ALL +
                          LIMITS REPORT') TOMSGQ(MRUNQ)              /*BHF934*/
/*****                CALL       PGM(DL0800)                /*S1105*/ /*E108*/
/******************   CALL       PGM(DL0800) PARM(&RSEQ)    /*E108*/  /*BHF934*/
/**/                                                                  /*S1105*/
/***************** IF COND(&PARM = 'Y') THEN(DO)            /*S1105*/ /*E78*/
                   IF COND(%SUBSTRING(&PARM 1 1) ='Y') THEN(DO)       /*E78*/
                      CHGJOB  SWS(10000000)                           /*S1105*/
                   ENDDO                                              /*BHF934*/
/*****                CALL    PGM(DL0800)                   /*S1105*/ /*E108*/
                      CALL    PGM(DL0800) PARM(&RSEQ)                 /*E108*/
                      CHGJOB  SWS(0XXXXXXX)                           /*S1105*/
/**************    ENDDO                                    /*S1105*/ /*BHF934*/
/**/                                                                  /*S1105*/
                      RTVJOBA    SWS(&SWS)
/**/
/***************      IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00')  /*BHF934*/
/***************                 THEN(DO)                             /*BHF934*/
/**/
/***************         SNDMSG    MSG('MATURING FX DEALS REPORT') +  /*BHF934*/
/***************                     TOMSGQ(MRUNQ)                    /*BHF934*/
/***************         OVRDBF    FILE(TABLE) TOFILE(TABDLEE)        /*S01194*/
/***************         CALL      PGM(DL0680)                        /*S01117*/

/*****       IF         COND(&RLEV *EQ 'S') THEN(CALL PGM(DL0681))    /*E108*/
/*****             ELSE CMD(CALL PGM(DL0683) PARM(&RSEQ &RENT))/*S01117 E108*/
/*****                   RTVJOBA   SWS(&SWS)                          /*E108*/
/**/
/****************     ENDDO                                           /*BHF934*/
/**/
                   ENDDO
/**/
                ENDDO
/**/
             ENDDO
/**/
/*********** DLTOVR     FILE(TABLE)                                   /*S01194*/
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG(&MSG2) TOMSGQ(MOPERQ))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/****        ENDPGM                                                */ /*S01360*/
/**EXIT:********ENDPGM                                      /*S01360* *E40459*/
EXIT:                                                                /*E40459*/
/* */                                                                /*E40459*/
/** Call AOSARDR0 with an option of '*FREE' to close the file.       /*E40459*/
             CHGVAR     VAR(&SOPTN) VALUE('*FREE')                   /*E40459*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD)     /*E40459*/
/* */                                                                /*E40459*/
             ENDPGM                                                  /*E40459*/
