/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Events File Creation')                       */
/*********************************************************************/
/*                                                                  */
/*        Midas     - Customer Lending Module                   */
/*                                                                  */
/*     LEC0609A -  EVENTS FILE CREATION I                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD054799           Date 14Nov19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD021351           Date 06May14              */
/*                      MD021605           Date 22Aug13              */
/*                      MD020954           Date 02Aug13              */
/*                      AR1097204          Date 06Apr13              */
/*                      CCB022B            Date 06Aug12              */
/*                      AR1089839          Date 19Feb13              */
/*                      CLE075AF           Date 06Aug12              */
/*                      AR1073031          Date 27Dec12              */
/*                      AR1055617          Date 12Nov12              */
/*                      AR1055539          Date 12Nov12              */
/*                      AR1022006          Date 01Aug12              */
/*                      AR544187           Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/*                      262545             Date 15Dec08              */
/*                      BUG28050           Date 19Aug10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      247277             Date 24May07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      CSD028             Date 22Aug05              */
/*                      CLE040             Date 05Jul04              */
/*                      BUG3875            Date 30Jul04              */
/*                      BUG3523            Date 07Jul04              */
/*                      CLE025             Date 20Oct03              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      131373             Date 03Jan03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      154584             Date 18Feb99             */
/*                      127720             Date 25Nov97              */
/*                      104072             Date 05Mar97              */
/*                    S01408             DATE 26JUN96               */
/*                    S01408             DATE 08JAN96               */
/*                    S01408             DATE 05SEP95               */
/*                    088115 (CRM001)    DATE 26APR95               */
/*                    045634             DATE 23APR93               */
/*                    S01393             DATE 30OCT92               */
/*                    S01270             DATE 23APR92               */
/*                    S01189             DATE 09FEB90               */
/*                    S01194             DATE 08FEB90               */
/*                    S01179             DATE 14/09/88              */
/*                    S01128             DATE 04/03/87              */
/*                    S01098             DATE 24/07/86              */
/*                    E0231              DATE 14/01/85              */
/*                    S0650              DATE 14/09/84              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD054799 - LVNTXEL contains two P1 events for a single     */
/*                  PDCL                                            */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021351 - Design for Kill object locks                    */
/*       MD021605 - Process only non-PDCL on the first run and only */
/*                  PDCL on the second run to make sure that all    */
/*                  event for PDCL loan is processed.               */
/*       MD020954 - Missing projection on the new PDCL.             */
/*                  Clear the new file LELWNEPK on the first run of */
/*                  LE0480.                                         */
/*       AR1097204 - LEC06A 04001 failed due to DBerror in LENFCTL1 */
/*       CCB022B - COB Restructure - COB File Manager                */
/*       AR1089839 - COBOP and 2.1 source clashes                   */
/*       CLE075AF - COB Restructure - LE COB Optimisation Phase 1   */
/*       AR1073031 - JAR files path was not setup successfully      */
/*                   during COB                                     */
/*       AR1055617 - Additional code changes based on code           */
/*                   review                                          */
/*       AR1055539 - Various errors encountered in COB during       */
/*                   Link Test                                      */
/*       AR1022006 - COB Performance Optimisation                    */
/*       AR544187 - Improve performance of some LE COB               */
/*                  components (Child:AR544189)                      */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       262545 - Reduce cob run time when IAS active               */
/*       BUG28050 - LEC06A 10015 failed                             */
/*       247277 - Cater for native JDBC driver as well as toolbox    */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       CSD028 - KYC (Standing Data Authorisations )                */
/*       CLE040  - Collateralised Lending Phase 2                   */
/*       BUG3875 - CHECK FOR FCLTYFM LOCKING (TEMPORARY ONLY)       */
/*       BUG3523 - Collateralised lending jobs in COB fail           */
/*      CLE025 - Credit Lines                                       */
/*      131373  -  If CPYF to FCLTYFM or FCLTYFN fails, do ABNOR    */
/*                 processing instead of proceeding as if nothing   */
/*                 happened.                                        */
/*       154584 - Clears FCUPDFM when CLE005 is switched off.       */
/*       127720 - LECAUTPD cleared.                                 */
/*      104072  -  Fix 045632 commented out commands that affected  */
/*                 PF/LVENTEL but the CLRPFM commands are still     */
/*                 present. These commands are removed to prevent   */
/*                 lock with DLC0802D.                              */
/*      S01408  -  ADDITION OF CORE HOOK LEC0609A04                 */
/*      S01408  -  ADDITION OF CORE HOOK LEC0609A03                 */
/*      S01408  -  ADDITION OF CORE HOOK LEC0609A01                 */
/*                                       LEC0609A02                 */
/*      088115  -  FILE RMLEEVP NOW REDUNDENT (CRM001)              */
/*      045634  -  UPDATE ONLINE POSITIONS :                        */
/*                 CHANGE EVENTS OUTPUT, ONLY OUTPUT AFTER LE0492   */
/*      S01393  -  COPY EVENTS FILE FOR RISK MANAGEMENT             */
/*      S01270  -  CUSTOMER LENDING CHANGES TO LE0490 ET AL         */
/*                 COMMITMENT FEE PROCESSING HAS BEEN REMOVED FROM  */
/*                 CUSTOMER LENDING AND REPLACED WITH THE FEE       */
/*                 ENHANCEMENTS - LE0491 REPLACES LE0490 TO PROCESS */
/*                 ONLY FACILITY UPDATES LE0492 IS CALLED LATER IN  */
/*                 THE COB TO DO ALL THE FEE PROCESSING FOR BILLS   */
/*                 AND TELEXES                                      */
/*      S01189  -  COB RECOVERY PROCESSING                          */
/*      S01194  -  NEW STANDING DATA                                */
/*      S01179  -  AS400 INCORPORATION                              */
/*      S01128  -  ADD LE FACILITIES EVENTS EXTRACT.                */
/*      S01098  -  AMENDMENT BLOCKS SELECTED LARGE FILES            */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*S01189*/
/**********  PGM        PARM(&CNAM &CSEQ)                                          /*S01189 CLE134*/
             PGM        PARM(&CNAM &CSEQ &RERUN)                                          /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('CUSTOMER LENDING EVENTS FILE +
                        CREATION ')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*131373*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*131373*/
/************DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)              *131373*/
             DCL        VAR(&SARO) TYPE(*CHAR) LEN(6) VALUE('CLE005') /*127720*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*127720*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*127720*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*127720*/
             DCL        VAR(&CLE005) TYPE(*CHAR) LEN(1) VALUE('N')    /*127720*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CLE025*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')                   /*CLE025*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*CLE025*/
             DCL        VAR(&JAVAPATH) TYPE(*CHAR) LEN(200)                              /*BUG3523*/
             DCL        VAR(&JAVAPATH2) TYPE(*CHAR) LEN(210)                             /*BUG3523*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                                  /*BUG3523*/
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)                                 /*BUG3523*/
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)                                 /*BUG3523*/
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)                                 /*BUG3523*/
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)                                 /*BUG3523*/
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)                                 /*BUG3523*/
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)                                 /*BUG3523*/
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)                                 /*BUG3523*/
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)                                 /*BUG3523*/
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)                                 /*BUG3523*/
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)                                 /*BUG3523*/
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)                                 /*BUG3523*/
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)                                 /*BUG3523*/
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)                                 /*BUG3523*/
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)                                 /*BUG3523*/
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)                                 /*BUG3523*/
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)                                 /*BUG3523*/
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)                                 /*BUG3523*/
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)                                /*BUG3523*/
             DCL        VAR(&JAVA_PATH) TYPE(*CHAR) LEN(1024)                             /*CLE040*/
             DCL        VAR(&JAVA_HOME) TYPE(*CHAR) LEN(1024)                           /*BUG28050*/
             DCL        VAR(&ULX004) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CER001*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&MRPDCL) TYPE(*CHAR) LEN(1)                                 /*MD021605*/
  /*         DCLF       FILE(SDJARFPD)        */                               /*CLE040*/ /*CSD028*/
             DCLF       FILE(SDJARFL0)                                                    /*CSD028*/
/*/COPY WNCPYSRC,LEC0609A05                                          */
/**/
/*  Global Monitor Message                                            /*131373*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)       /*131373*/
/**/                                                                                    /*MD021605*/
                        CHGVAR VAR(&MRPDCL) VALUE(' ')                                  /*MD021605*/
                                                                                          /*CLE134*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/**/                                                                                    /*MD021605*/
             IF         COND(&RERUN *EQ 'NEWCOB') +
                        THEN(CHGVAR VAR(&MRPDCL) VALUE('Y'))                            /*MD021605*/
             ELSE       CMD(CHGVAR VAR(&MRPDCL) VALUE('N'))                             /*MD021605*/
                                                                      /*131373*/
/*           DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
/*           DCLDTAARA  DTAARA(MMOD)                         /*S0650*  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                     /*S0650*/
/**/                                                                            /*AR544187 CCB022B*/
/***Before*doing*anything*make*sure*that*any*missing*members**/                 /*AR544187 CCB022B*/
/***are*reinstated**/                                                           /*AR544187 CCB022B*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)           */         /*CLE134 AR1055617*/
/**********  SCLFMMGR  FILE(FCLTYHH) ACTION(ADD)                     */         /*AR544187 CCB022B*/
/**********  SCLFMMGR  FILE(FCLTYFM) ACTION(ADD)                     */         /*AR544187 CCB022B*/
/**********  SCLFMMGR  FILE(FCLTYFN) ACTION(ADD)                     */         /*AR544187 CCB022B*/
/**********  SCLFMMGR  FILE(FCLTYZZ) ACTION(ADD)                     */         /*AR544187 CCB022B*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
                                                                                          /*CLE025*/
/* Setup system prefix variable from SDSTAT data area */                                  /*CLE025*/
                                                                                          /*CLE025*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                               /*CLE025*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)                         /*CLE025*/
                                                                      /*127720*/
/*/COPY WNCPYSRC,LEC0609A06                                          */
/**/                                                                  /*127720*/
/* Check if CLE005 is installed */                                    /*127720*/
/**/                                                                  /*127720*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARO &FMT)    /*127720*/
             IF         COND(&RTCD *EQ '       ') +
                 THEN(CHGVAR VAR(&CLE005) VALUE('Y'))                 /*127720*/
             ELSE       CMD(CHGVAR VAR(&CLE005) VALUE('N'))           /*127720*/
                                                                      /*127720*/
/* Check if CLE025 is installed */                                                        /*CLE025*/
/**/                                                                                      /*CLE025*/
             CHGVAR     VAR(&SARO) VALUE('CLE025')                                        /*CLE025*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE025*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARO &FMT)                        /*CLE025*/
             IF         COND(&RTCD *EQ '       ') +
                 THEN(CHGVAR VAR(&CLE025) VALUE('Y'))                                     /*CLE025*/
             ELSE       CMD(CHGVAR VAR(&CLE025) VALUE('N'))                               /*CLE025*/
/**/                                                                                      /*CER001*/
/* Check if ULX004 is installed */                                                        /*CER001*/
/**/                                                                                      /*CER001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER001*/
             CHGVAR     VAR(&SARO) VALUE('ULX004')                                        /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARO &FMT)                        /*CER001*/
                                                                                          /*CER001*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CER001*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                                            /*CER001*/
             CHGJOB (XXXXXX11)                                                            /*CER001*/
             RETURN                                                                       /*CER001*/
             ENDDO                                                                        /*CER001*/
                                                                                          /*CER001*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&ULX004) VALUE('Y'))                                        /*CER001*/
                                                                                          /*CER001*/
                                                                      /*127720*/
/**/                                                                   /*S0650*/
/**/
/*  IF P/MFU INDICATOR 'OLD' THEN CLEAR PF/NFACLxx                  */
/*   UPDATE FILES AND P/MFU INDICATOR TO 'NEW'                      */
/**/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
/**/
/************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'OLD') +
 ***********************THEN(DO)                                      /*S01189*/
             IF         COND(&STAT *EQ 'N') THEN(DO)                  /*S01189*/
/**/
               IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                              /*CLE134*/
/**********    OVRDBF     FILE(NFACLFN) SEQONLY(*YES 300) +
                            NBRRCDS(300)                            */        /*AR544187 AR1097204*/
/**********    OVRDBF     FILE(NFACLFM) SEQONLY(*YES 100) +
                            NBRRCDS(100)                            */        /*AR544187 AR1097204*/
               OVRDBF     FILE(NFACLFN) FRCRATIO(300) SEQONLY(*YES)                    /*AR1097204*/
               OVRDBF     FILE(NFACLFM) FRCRATIO(100) SEQONLY(*YES)                    /*AR1097204*/
               ENDDO                                                                      /*CLE134*/
                                                                                          /*CLE134*/
                CLRPFM     FILE(NFACLHH)       /* NEW LF/FCLTY FILE */
/***************CLRPFM     FILE(NFACLFM)          OUTPUT FROM LE0490   *S01270*/
                CLRPFM     FILE(NFACLFM)       /* OUTPUT FROM LE0491   *S01270*/
                CLRPFM     FILE(NFACLFN)
                CLRPFM     FILE(NFACLZZ)
                IF         COND(&CLE005 *EQ 'Y') +
                   THEN(CLRPFM     FILE(LECAUTPD))                    /*127720*/
/**/
/************** CLRPFM     FILE(LVENTHH)        /*LF/LVENT FILE         104072*/
/***************CLRPFM     FILE(LVENTEL)          OUTPUT FROM LE0490   *S01270*/
/************** CLRPFM     FILE(LVENTEL) /*OUTPUT FROM LE0491   *S01270 104072*/
/************** CLRPFM     FILE(LVENTZZ)                                104072*/
/**/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,LEC0609A04                                           /*S01408*/
/*                                                                    /*S01408*/
                CLRPFM     FILE(CUTX2HH)
                CLRPFM     FILE(CUTX2HP)
                CLRPFM     FILE(CUTX2ZX)
/**/
/***************CLRPFM     FILE(CFTLXHH)                               *S01270*/
/***************CLRPFM     FILE(CFTLXPR)                               *S01270*/
/***************CLRPFM     FILE(CFTLXZZ)                               *S01270*/
/**/
             IF         COND(&RERUN *EQ '      ') THEN(DO)                             /*AR1022006*/
                CLRPFM     FILE(LVNTXHH)
                CLRPFM     FILE(LVNTXEL)
                CLRPFM     FILE(LVNTXZZ)
             ENDDO                                                                     /*AR1022006*/
/*/COPY WNCPYSRC,LEC0609A07                                          */
/**/                                                                   /*S0650*/
/*  IF EXPOSURE MANAGEMENT MODULE PRESENT CLEAR EM FILES AND SET ON */ /*S0650*/
/*       SWITCH 1 TO CONDITION OUTPUT           */                     /*S0650*/
/**/                                                                   /*S0650*/
             IF         COND(%SST(&MMOD 7 1)='Y') THEN(DO)             /*S0650*/
/**/                                                                   /*S0650*/
             IF         COND(&RERUN *EQ '      ') THEN(DO)                             /*AR1022006*/
                CLRPFM     FILE(EMXT1H1)                               /*S0650*/
                CLRPFM     FILE(EMXT1D1)                               /*S0650*/
                CLRPFM     FILE(EMXT1R1)                               /*S0650*/
                CLRPFM     FILE(EMXT1T1)                               /*S0650*/
                CLRPFM     FILE(EMTE1H1)                               /*S0650*/
                CLRPFM     FILE(EMTE1E1)                               /*S0650*/
                CLRPFM     FILE(EMTE1T1)                               /*S0650*/
             ENDDO                                                                     /*AR1022006*/
/* S01128 - CLEAR NEXT 4 PHYSICAL FILES FOR LE FACILITIES  */
                CLRPFM     FILE(EMXT4F1)
                CLRPFM     FILE(EMXT4T1)
                CLRPFM     FILE(EMTE4E4)
                CLRPFM     FILE(EMTE4T1)
/**/                                                                   /*S0650*/
                CHGJOB     SWS(1XXXXXXX)                               /*S0650*/
              ENDDO                                                    /*S0650*/
/**/                                                                   /*S0650*/
/**/                                                                   /*S0650*/
/**/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
             IF         COND(&RERUN *EQ '      ') THEN(DO)                                /*CLE134*/
                CLRPFM     FILE(LELWNEPD)                                              /*AR1022006*/
                CLRPFM     FILE(LELWNEZ1)                                              /*AR1055539*/
                CLRPFM     FILE(LELWNEPK)                                               /*MD020954*/
/**/                                                                  /*262545*/
/*   Identify loans requiring future events                           /*262545*/
/**/                                                                  /*262545*/
             IF         COND(&CSEQ = 10015) THEN(DO)                  /*262545*/
/**********     CLRPFM     FILE(LE0480PD)                          */            /*262545 CLE075AF*/
/**********  RUNSQL     SQL('DELETE FROM LE0480PD')                */         /*CLE075AF AR1089839*/
             SCRUNSQL   SQL('DELETE FROM LE0480PD')                                    /*AR1089839*/
/**********     CPYF       FROMFILE(CLOANCL) TOFILE(LE0480PD) +
                             MBROPT(*ADD) CRTFILE(*NO) INCCHAR(FSYLDC +
                             1 *NE '     ') FMTOPT(*MAP *DROP)     */            /*262545 CLE075AF*/
/**********  RUNSQL     SQL('INSERT INTO LE0480PD SELECT LNRF FROM +*/                 /*AR1089839*/
/**********               CLOANCL WHERE FSYLDC <> '' ''')          */         /*CLE075AF AR1089839*/
             SCRUNSQL   SQL('INSERT INTO LE0480PD SELECT LNRF FROM +
                          CLOANCL WHERE FSYLDC <> '' ''')                              /*AR1089839*/
                CALL       PGM(LE000480)                              /*262545*/
             ENDDO                                                    /*262545*/
             ENDDO                                                                        /*CLE134*/
/*/                                                                                     /*MD021605*/
/** Create a back-up for the re-run                                                     /*MD021605*/
/*/                                                                                     /*MD021605*/
              IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                             /*MD021605*/
                         DLTF       FILE(XLVNTXHH)                                      /*MD021605*/
                         MONMSG     MSGID(CPF2105)                                      /*MD021605*/
                         DLTF       FILE(XLVNTXEL)                                      /*MD021605*/
                         MONMSG     MSGID(CPF2105)                                      /*MD021605*/
                         DLTF       FILE(XLVNTXZZ)                                      /*MD021605*/
                         MONMSG     MSGID(CPF2105)                                      /*MD021605*/
                         DLTF       FILE(XEMTE1H1)                                      /*MD021605*/
                         MONMSG     MSGID(CPF2105)                                      /*MD021605*/
                         DLTF       FILE(XEMXT1H1)                                      /*MD021605*/
                         MONMSG     MSGID(CPF2105)                                      /*MD021605*/
                         DLTF       FILE(XEMTE1E1)                                      /*MD021605*/
                         MONMSG     MSGID(CPF2105)                                      /*MD021605*/
                         DLTF       FILE(XEMXT1D1)                                      /*MD021605*/
                         MONMSG     MSGID(CPF2105)                                      /*MD021605*/
                         DLTF       FILE(XEMXT1R1)                                      /*MD021605*/
                         MONMSG     MSGID(CPF2105)                                      /*MD021605*/
/**/                                                                                    /*MD021605*/
              CPYF       FROMFILE(&DPLIB/LVNTXHH) +
                           TOFILE(&DPLIB/XLVNTXHH) MBROPT(*REPLACE) +
                           CRTFILE(*YES)                                                /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/XLVNTXHH))                                       /*MD021605*/
              CPYF       FROMFILE(&DPLIB/LVNTXEL) +
                           TOFILE(&DPLIB/XLVNTXEL) MBROPT(*REPLACE) +
                           CRTFILE(*YES)                                                /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/XLVNTXEL))                                       /*MD021605*/
              CPYF       FROMFILE(&DPLIB/LVNTXZZ) +
                           TOFILE(&DPLIB/XLVNTXZZ) MBROPT(*REPLACE) +
                           CRTFILE(*YES)                                                /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/XLVNTXZZ))                                       /*MD021605*/
              CPYF       FROMFILE(&DPLIB/EMTE1H1) +
                           TOFILE(&DPLIB/XEMTE1H1) MBROPT(*REPLACE) +
                           CRTFILE(*YES)                                                /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/XEMTE1H1))                                       /*MD021605*/
              CPYF       FROMFILE(&DPLIB/EMXT1H1) +
                           TOFILE(&DPLIB/XEMXT1H1) MBROPT(*REPLACE) +
                           CRTFILE(*YES)                                                /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/XEMXT1H1))                                       /*MD021605*/
              CPYF       FROMFILE(&DPLIB/EMTE1E1) +
                           TOFILE(&DPLIB/XEMTE1E1) MBROPT(*REPLACE) +
                           CRTFILE(*YES)                                                /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/XEMTE1E1))                                       /*MD021605*/
              CPYF       FROMFILE(&DPLIB/EMXT1D1) +
                           TOFILE(&DPLIB/XEMXT1D1) MBROPT(*REPLACE) +
                           CRTFILE(*YES)                                                /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/XEMXT1D1))                                       /*MD021605*/
              CPYF       FROMFILE(&DPLIB/EMXT1R1) +
                           TOFILE(&DPLIB/XEMXT1R1) MBROPT(*REPLACE) +
                           CRTFILE(*YES)                                                /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/XEMXT1R1))                                       /*MD021605*/
              ENDDO                                                                     /*MD021605*/
/**/
/************** OVRDBF     FILE(TABLE) TOFILE(TABLEEI)               * *S01194*/
/************** OVRDBF     FILE(TABLED) TOFILE(TABLEEI) SHARE(*NO)   * *S01194*/
                OVRDBF     FILE(LVNTXEL) SEQONLY(*YES 100)            /*S01098*/
/*/COPY WNCPYSRC,LEC0609A08                                          */
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                             /*AR1022206*/
                OVRDBF     FILE(CLOAN) TOFILE(CLOANE) SHARE(*NO)                       /*AR1022206*/
             ENDDO                                                                     /*AR1022206*/
/**********     CALL       PGM(LE0480)                             */                   /*MD021605*/
                CALL       PGM(LE0480) PARM(&MRPDCL)                                    /*MD021605*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                             /*AR1022206*/
                DLTOVR     FILE(CLOAN)                                                 /*AR1022206*/
             ENDDO                                                                     /*AR1022206*/
/**/                                                                                    /*MD021605*/
/** Restore back up if LE0480 failed in the rerun.                                      /*MD021605*/
/**/                                                                                    /*MD021605*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)                                /*MD054799*/
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)            */         /*MD021605 MD054799*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                              /*MD021605*/
              CPYF       FROMFILE(&DPLIB/XLVNTXHH) +
                           TOFILE(&DPLIB/LVNTXHH) MBROPT(*REPLACE)                      /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/LVNTXHH))                                        /*MD021605*/
              CPYF       FROMFILE(&DPLIB/XLVNTXEL) +
                           TOFILE(&DPLIB/LVNTXEL) MBROPT(*REPLACE)                      /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/LVNTXEL))                                        /*MD021605*/
              CPYF       FROMFILE(&DPLIB/XLVNTXZZ) +
                           TOFILE(&DPLIB/LVNTXZZ) MBROPT(*REPLACE)                      /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/LVNTXZZ))                                        /*MD021605*/
              CPYF       FROMFILE(&DPLIB/XEMTE1H1) +
                           TOFILE(&DPLIB/EMTE1H1) MBROPT(*REPLACE)                      /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/EMTE1H1))                                        /*MD021605*/
              CPYF       FROMFILE(&DPLIB/XEMXT1H1) +
                           TOFILE(&DPLIB/EMXT1H1) MBROPT(*REPLACE)                      /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/EMXT1H1))                                        /*MD021605*/
              CPYF       FROMFILE(&DPLIB/XEMTE1E1) +
                           TOFILE(&DPLIB/EMTE1E1) MBROPT(*REPLACE)                      /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/EMTE1E1))                                        /*MD021605*/
              CPYF       FROMFILE(&DPLIB/XEMXT1D1) +
                           TOFILE(&DPLIB/EMXT1D1) MBROPT(*REPLACE)                      /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/EMXT1D1))                                        /*MD021605*/
              CPYF       FROMFILE(&DPLIB/XEMXT1R1) +
                           TOFILE(&DPLIB/EMXT1R1) MBROPT(*REPLACE)                      /*MD021605*/
              MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                           FILE(&DPLIB/EMXT1R1))                                        /*MD021605*/
             ENDDO                                                                      /*MD021605*/
             ENDDO                                                                      /*MD021605*/
                IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                             CMDLBL(ABNOR))                           /*131373*/
/*/COPY WNCPYSRC,LEC0609A09                                          */
                DLTOVR     FILE(LVNTXEL)                              /*S01098*/
/**/                                                                   /*S0650*/
/*  S01128 - CALL LE FACILITIES EVENTS EXTRACT PGM.    */
           IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                /*S01128*/
/**/                                                                  /*S01393*/
/* COPY EVENTS FILE FOR RISK MANAGEMENT                                *S01393*/
/**/                                                                  /*S01393*/
/*********   CLRPFM     FILE(RMLEEVP)                      /*S01393*/ /*088115*/
/*********   CPYF       FROMFILE(LVNTXEL) TOFILE(RMLEEVP) +
                          MBROPT(*REPLACE)                 /*S01393*/ /*088115*/
/*********   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)     /*S01393*/ /*088115*/
/**/                                                                  /*S01098*/
             IF         COND(%SST(&MMOD 7 1)='Y') THEN(DO)            /*S01128*/
                 CALL       PGM(LE0485)                               /*S01128*/
                 IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                              CMDLBL(ABNOR))                          /*131373*/
             ENDDO                                                    /*S01128*/
/**/                                                                  /*S01098*/
           ENDDO                                                      /*S01128*/
/**/                                                                   /*S0650*/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                IF         COND(&CLE025 = 'Y') THEN(DO)                                   /*CLE025*/
                    CHKOBJ     OBJ(&DPLIB/XLEFCLTQD) OBJTYPE(*FILE)                       /*CLE025*/
                    MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))                   /*CLE025*/
                    CPYF       FROMFILE(XLEFCLTQD) TOFILE(LEFCLTQD) +
                                 MBROPT(*REPLACE)                                         /*CLE025*/
                    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                                 EXEC(CLRPFM FILE(LEFCLTQD))                              /*CLE025*/
                    GOTO       CMDLBL(RECVRD)                                             /*CLE025*/
BACKUP:                                                                                   /*CLE025*/
                    DLTF       FILE(XLEFCLTQD)                                            /*CLE025*/
                    MONMSG     MSGID(CPF2105)                                             /*CLE025*/
                    CPYF       FROMFILE(LEFCLTQD) TOFILE(&DPLIB/XLEFCLTQD) +
                                 MBROPT(*REPLACE) CRTFILE(*YES)                           /*CLE025*/
                    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                             /*CLE025*/
                                                                                          /*CLE025*/
RECVRD:                                                                                   /*CLE025*/
                                                                                         /*BUG3523*/
/* Get 'JavaPath' system value from file SDSVALPD  */                                    /*BUG3523*/
                                                                                         /*BUG3523*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)           */         /*CLE134 AR1055617*/
/**********  CALL       PGM(AOSVALR0) PARM(&RTNCDE +                 */                /*AR1055617*/
/**********               'JavaPathStem' &JAVAPATH &SVALK2 +         */                /*AR1055617*/
/**********               &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +     */                /*AR1055617*/
/**********               &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +    */                /*AR1055617*/
/**********               &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +     */                /*AR1055617*/
/**********               &SVALK0 &SVAL10)                                      /*CLE134 AR1055617*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
/**********  CALL       PGM(AOSVALR0) PARM(&RTNCDE +                 */                 /*BUG28050*/
/**********               'JavaPathStem' &JAVAPATH &SVALK2 +         */                 /*BUG28050*/
/**********               &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +     */                 /*BUG28050*/
/**********               &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +    */                 /*BUG28050*/
/**********               &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +     */                 /*BUG28050*/
/**********               &SVALK0 &SVAL10)                           */         /*BUG3523 BUG28050*/
                                                                                        /*BUG28050*/
/* Get 'JavaPathStem' and 'JavaHome' system values from file SDSVALPD  */               /*BUG28050*/
                                                                                        /*BUG28050*/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)      */              /*CLE134 AR1073031*/
             CALL       PGM(AOSVALR0) PARM(&RTNCDE 'JavaPathStem' +
                          &JAVAPATH 'JavaHome' &JAVA_HOME &SVALK3 +
                          &SVAL3 &SVALK4 &SVAL4 &SVALK5 &SVAL5 +
                          &SVALK6 &SVAL6 &SVALK7 &SVAL7 &SVALK8 +
                          &SVAL8 &SVALK9 &SVAL9 &SVALK0 &SVAL10)                        /*BUG28050*/
/**********  ENDDO                                              */              /*CLE134 AR1073031*/
 
/* If the 'JavaPathStem' system value is missing then end abnormally */                  /*BUG3523*/
                                                                                         /*BUG3523*/
             IF         COND(%SST(&JAVAPATH 1 4) *EQ '*NRF') THEN(GOTO +
                          CMDLBL(ABNOR))                                                 /*BUG3523*/
                                                                                        /*BUG28050*/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)      */              /*CLE134 AR1073031*/
/* If the 'JavaHome' system value is missing then end abnormally */                     /*BUG28050*/
                                                                                        /*BUG28050*/
             IF         COND(%SST(&JAVA_HOME 1 4) *EQ '*NRF') THEN(GOTO +
                          CMDLBL(ABNOR))                                                /*BUG28050*/
/**********  ENDDO                                              */              /*CLE134 AR1073031*/
                                                                                         /*BUG3523*/
             RMVLNK     OBJLNK(A)                                                        /*BUG3523*/
             MONMSG     MSGID(CPFA0A9)                                                   /*BUG3523*/
                                                                                         /*BUG3523*/
             RMVLNK     OBJLNK(B)                                                        /*BUG3523*/
             MONMSG     MSGID(CPFA0A9)                                                   /*BUG3523*/
/** Add links to system */                                                                /*CLE025*/
                                                                                          /*CLE025*/
/**********     ADDLNK     OBJ('/QOpenSys/midasplus') NEWLNK(A)               /*CLE025*/ /*BUG3523*/
                ADDLNK     OBJ(&JAVAPATH) NEWLNK(A)                                      /*BUG3523*/
                MONMSG     MSGID(CPFA0A0)                                                 /*CLE025*/
                                                                                          /*CLE025*/
/**********     ADDLNK     OBJ('/QOpenSys/midasplus/lib') NEWLNK(B)           /*CLE025*/ /*BUG3523*/
                CHGVAR     VAR(&JAVAPATH2) VALUE(&JAVAPATH *TCAT +
                             '/lib/ext')                                                 /*BUG3523*/
                ADDLNK     OBJ(&JAVAPATH2) NEWLNK(B)                                     /*BUG3523*/
                MONMSG     MSGID(CPFA0A0)                                                 /*CLE025*/
 
/* Get 'BrgMidasSystemPrefix' system value from file SDSVALPD  */                         /*CLE040*/
                                                                                          /*CLE040*/
             CALL       PGM(AOSVALR0) PARM(&RTNCDE +
                          'BrgMidasSystemPrefix' &JAVAPATH &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK0 &SVAL10)                                                /*CLE040*/
                                                                                          /*CLE040*/
/* If the 'BrgMidasSystemPrefix' system value is missing then end abnormally */           /*CLE040*/
                                                                                          /*CLE040*/
             IF         COND(%SST(&JAVAPATH 1 4) *EQ '*NRF') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CLE040*/
                                                                                          /*CLE040*/
                                                                                          /*CLE025*/
/** Setup environment variable CLASSPATH with the necessary directories */                /*CLE025*/
/** for invoking the java calculator methods */                                           /*CLE025*/
                                                                                          /*CLE025*/
                RMVENVVAR  ENVVAR(CLASSPATH)                                              /*CLE025*/
                MONMSG     MSGID(CPFA981)                                                 /*CLE025*/
                                                                                          /*CLE025*/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)      */              /*CLE134 AR1073031*/
/** Setup environment variable JAVA_HOME */                                             /*BUG28050*/
                                                                                        /*BUG28050*/
             RMVENVVAR  ENVVAR(JAVA_HOME)                                               /*BUG28050*/
             MONMSG     MSGID(CPFA981)                                                  /*BUG28050*/
/**********  ENDDO                                              */              /*CLE134 AR1073031*/
                                                                                        /*BUG28050*/
/**********     ADDENVVAR  ENVVAR(CLASSPATH) +                                           /*BUG3523*/
/**********                  VALUE('A:A/calculationmanager.jar:A/calcula+                /*BUG3523*/
/**********                  tors.jar:A/collending.jar:A/frwkapi.jar:A/f+                /*BUG3523*/
/**********                  rwkapidef.jar:A/frwkdataaccess.jar:A/frwkda+                /*BUG3523*/
/**********                  taview.jar:A/frwkdtd.jar:A/frwkjavaext.jar:+                /*BUG3523*/
/**********                  B/xml-apis.jar:B/xmlParserAPIs.jar:B/xsdlib+                /*BUG3523*/
/**********                  .jar:A/midaslocalconfig:B/activation.jar:B/+                /*BUG3523*/
/**********                  commons-beanutils.jar:B/commons-collections+                /*BUG3523*/
/**********                  .jar:B/commons-dbcp.jar:B/commons-digester.+                /*BUG3523*/
/**********                  jar:B/commons-logging.jar:B/commons-pool.ja+                /*BUG3523*/
/**********                  r:B/concurrent.jar:B/getopt.jar:B/jaas.jar:+                /*BUG3523*/
/**********                  B/jaxb-api.jar:B/jaxb-impl.jar:B/jaxb-libs.+                /*BUG3523*/
/**********                  jar:B/jaxb-xjc.jar:B/jax-qname.jar:B/jt400.+                /*BUG3523*/
/**********                  jar:B/jta-spec1_0_1.jar:B/junit.jar:B/log4j+                /*BUG3523*/
/**********                  -1.2.8.jar:B/mail.jar:B/namespace.jar:B/pro+                /*BUG3523*/
/**********                  viderutil.jar:B/relaxngDatatype.jar:B/veloc+                /*BUG3523*/
/**********                  ity-dep-1.3.1.jar:B/xercesImpl.jar:B/rt.jar+                /*BUG3523*/
/**********                  :B/i18n.jar:B/indicim.jar:B/JawBridge.jar:B+                /*BUG3523*/
/**********                  /appprofile.jar:B/cm.jar:B/ecutils.jar:B/ej+                /*BUG3523*/
/**********                  bcontainer.jar:B/ejbportable.jar:B/ivjejb35+                /*BUG3523*/
/**********                  .jar:B/j2ee.jar:B/namingserver.jar:B/pm.jar+                /*BUG3523*/
/**********                  :B/pmimpl.jar:B/querymd.jar:B/ras.jar:B/rsa+                /*BUG3523*/
/**********                  daptercci.jar:B/rsadapterspi.jar:B/rsaexter+                /*BUG3523*/
/**********                  nal.jar:B/runtime.jar')                          /*CLE025*/ /*BUG3523*/
                                                                                         /*BUG3523*/
/**********  ADDENVVAR  ENVVAR(CLASSPATH) +                                              /*CLE040*/
/**********               VALUE('A:+                                                     /*CLE040*/
/**********               A/midaslocalconfig:+                                           /*CLE040*/
/**********               B/calculationmanager.jar:+                                     /*CLE040*/
/**********               B/calculators.jar:+                                            /*CLE040*/
/**********               B/frwkapi.jar:+                                                /*CLE040*/
/**********               B/frwkapidef.jar:+                                             /*CLE040*/
/**********               B/frwkdataaccess.jar:+                                         /*CLE040*/
/**********               B/frwkdataview.jar:+                                           /*CLE040*/
/**********               B/frwkdtd.jar:+                                                /*CLE040*/
/**********               B/frwkjavaext.jar:+                                            /*CLE040*/
/**********               B/xml-apis.jar:+                                               /*CLE040*/
/**********               B/xmlParserAPIs.jar:+                                          /*CLE040*/
/**********               B/xsdlib.jar:+                                                 /*CLE040*/
/**********               B/activation.jar:+                                             /*CLE040*/
/**********               B/midasplus.jar:+                                              /*CLE040*/
/**********               B/commons-beanutils.jar:+                                      /*CLE040*/
/**********               B/commons-collections.jar:+                                    /*CLE040*/
/**********               B/commons-dbcp.jar:+                                           /*CLE040*/
/**********               B/commons-digester.jar+                                        /*CLE040*/
/**********               B/commons-logging.jar:+                                        /*CLE040*/
/**********               B/commons-pool.jar:+                                           /*CLE040*/
/**********               B/concurrent.jar:+                                             /*CLE040*/
/**********               B/getopt.jar:+                                                 /*CLE040*/
/**********               B/jaas.jar:+                                                   /*CLE040*/
/**********               B/jaxb-api.jar:+                                               /*CLE040*/
/**********               B/jaxb-impl.jar:+                                              /*CLE040*/
/**********               B/jaxb-libs.jar:+                                              /*CLE040*/
/**********               B/jaxb-xjc.jar:+                                               /*CLE040*/
/**********               B/jax-qname.jar:+                                              /*CLE040*/
/**********               B/jt400.jar:+                                                  /*CLE040*/
/**********               B/jta-spec1_0_1.jar:+                                          /*CLE040*/
/**********               B/junit.jar:+                                                  /*CLE040*/
/**********               B/log4j-1.2.8.jar:+                                            /*CLE040*/
/**********               B/mail.jar:+                                                   /*CLE040*/
/**********               B/namespace.jar:+                                              /*CLE040*/
/**********               B/providerutil.jar:+                                           /*CLE040*/
/**********               B/relaxngDatatype.jar:+                                        /*CLE040*/
/**********               B/velocity-dep-1.3.1.jar:+                                     /*CLE040*/
/**********               B/xercesImpl.jar:+                                             /*CLE040*/
/**********               B/rt.jar:+                                                     /*CLE040*/
/**********               B/i18n.jar:+                                                   /*CLE040*/
/**********               B/indicim.jar:+                                                /*CLE040*/
/**********               B/JawBridge.jar:+                                              /*CLE040*/
/**********               B/appprofile.jar:+                                             /*CLE040*/
/**********               B/cm.jar:+                                                     /*CLE040*/
/**********               B/ecutils.jar:+                                                /*CLE040*/
/**********               B/ejbcontainer.jar:+                                           /*CLE040*/
/**********               B/ejbportable.jar:+                                            /*CLE040*/
/**********               B/ivjejb35.jar:+                                               /*CLE040*/
/**********               B/j2ee.jar:+                                                   /*CLE040*/
/**********               B/namingserver.jar:+                                           /*CLE040*/
/**********               B/pm.jar:+                                                     /*CLE040*/
/**********               B/pmimpl.jar:+                                                 /*CLE040*/
/**********               B/querymd.jar:+                                                /*CLE040*/
/**********               B/ras.jar:+                                                    /*CLE040*/
/**********               B/rsadaptercci.jar:+                                           /*CLE040*/
/**********               B/rsadapterspi.jar:+                                           /*CLE040*/
/**********               B/rsaexternal.jar:+                                            /*CLE040*/
/**********               B/runtime.jar:+                                                /*CLE040*/
/**********               B/managementlimitsplugin.jar:+                                 /*CLE040*/
/**********               A/logs:+                                                       /*CLE040*/
/**********               A/calmancl')                                                   /*CLE040*/
                                                                                          /*CLE040*/
 SETUP_PATH: RCVF       RCDFMT(SDJARFD0)                                                  /*CLE040*/
                                                                                          /*CLE040*/
             /* END OF FILE */                                                            /*CLE040*/
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ADD_ENVVAR))                      /*CLE040*/
                                                                                          /*CLE040*/
             /* CONCATENATE JAVA PATH */                                                  /*CLE040*/
             CHGVAR     VAR(&JAVA_PATH) VALUE(&JAVA_PATH *TCAT ':' *TCAT &JFNAME)         /*CLE040*/
                                                                                          /*CLE040*/
             IF         COND(&JFNAME *EQ 'A/calman                      ') +
                        THEN(+
                        CHGVAR     VAR(&JAVA_PATH) +
                                   VALUE(&JAVA_PATH *TCAT '/' *TCAT &JAVAPATH))           /*CLE040*/
                                                                                          /*CLE040*/
             /* READ NEXT RECORD */                                                       /*CLE040*/
             GOTO       CMDLBL(SETUP_PATH)                                                /*CLE040*/
                                                                                          /*CLE040*/
 ADD_ENVVAR: CHGVAR     VAR(&JAVA_PATH)   VALUE('A' *CAT &JAVA_PATH)                      /*CLE040*/
             ADDENVVAR  ENVVAR(CLASSPATH) VALUE(&JAVA_PATH)                               /*CLE040*/
                MONMSG     MSGID(CPFA0A0)                                                 /*CLE025*/
                                                                                        /*BUG28050*/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)      */              /*CLE134 AR1073031*/
                ADDENVVAR  ENVVAR(JAVA_HOME) VALUE(&JAVA_HOME)                          /*BUG28050*/
                MONMSG     MSGID(CPFA0A0)                                               /*BUG28050*/
/**********  ENDDO                                              */              /*CLE134 AR1073031*/
                ENDDO                                                                     /*CLE025*/
/**/                                                                  /*S01098*/
/*                BLOCK LARGE FILES                                 *  *S01098*/
/**/                                                                  /*S01098*/
/*                OVRDBF     FILE(LVENTEL) SEQONLY(*YES 100) /*S01098   045634*/
/**/
/******************CALL       PGM(LE0490)                              *S01270*/
                                                                                          /*CLE040*/
/* For ANWD run, perform overrides  */                                                    /*CLE040*/
                                                                                          /*CLE040*/
                   IF         COND((&CLE025 = 'Y') *AND (&CSEQ = 10025)) THEN(DO)         /*CLE040*/
                        OVRDBF     FILE(GLACP1L2) TOFILE(GLACP5L2) SHARE(*NO)             /*CLE040*/
                   ENDDO                                                                  /*CLE040*/
                                                                                          /*CLE040*/
/**********        CALL       PGM(LE0491)   */                                     /*S01270 CLE134*/
                   CALL       PGM(LE0491) PARM(&RERUN)                                    /*CLE134*/
                   IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                                CMDLBL(ABNOR))                        /*131373*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0609A03                                          */
/**/                                                                  /*S01408*/
/*                 DLTOVR     FILE(LVENTEL)                  /*S01098   045634*/
/**/
                   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/*********************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))        /*S01189*/
/*********************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/     /*S01189*/
/* P/MFU 'NEW'                                                      */
/*********************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 ********************************VALUE('NEW')                         /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)*/               /*S01189*/
/*********************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))        /*S01189*/
                      CHGVAR     VAR(&STAT) VALUE('Y')                /*S01189*/
                      CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)  /*S01189*/
/**/
                   ENDDO
/**/
                ENDDO
/**/
/*********** DLTOVR     FILE(*ALL)                                   * *S01194*/
/**/
             ENDDO
/**/
/*   CLEAR FCLTY - COPY NFACL TO FCLTY - CLEAR NFACL - RESET IND */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/***************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/           /*S01189*/
                CHGVAR     VAR(&STAT) VALUE(' ')                      /*S01189*/
                CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
/***************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'NEW') +
 **************************THEN(DO)****/                              /*S01189*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)               /*S01189*/
/**/
                                                                                         /*BUG3875*/
/**********  SCDOBJLCK  OBJ(FCLTYFN) PRINT(*PRINT)*/                            /*BUG3875 MD021351*/
/**********  SCKOBJLCK  OBJ(FCLTYFM) JUSR(*ALL) LOCKST(*ALL) FIRSTC(Y)*/        /*BUG3875 MD021351*/
/**********  SCKOBJLCK  OBJ(FCLTYFN) JUSR(*ALL) LOCKST(*ALL) FIRSTC(Y)*/        /*BUG3875 MD021351*/
/**********  SCKOBJLCK  OBJ(FCLTYFM) JNAM(QSQSRVR) JUSR(*ALL) +
                          LOCKST(*ALL) FIRSTC(Y)   */                            /*247277 MD021351*/
/**********  SCKOBJLCK  OBJ(FCLTYFN) JNAM(QSQSRVR) JUSR(*ALL) +
                          LOCKST(*ALL) FIRSTC(Y)   */                            /*247277 MD021351*/
/**/                                                                            /*AR544187 CCB022B*/
/***Disable*access*paths*using*Logical*File*manager**/                          /*AR544187 CCB022B*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)           */         /*CLE134 AR1055617*/
/**********  SCLFMMGR  FILE(FCLTYHH) ACTION(REM)                     */         /*AR544187 CCB022B*/
/**********  SCLFMMGR  FILE(FCLTYFM) ACTION(REM)                     */         /*AR544187 CCB022B*/
/**********  SCLFMMGR  FILE(FCLTYFN) ACTION(REM)                     */         /*AR544187 CCB022B*/
/**********  SCLFMMGR  FILE(FCLTYZZ) ACTION(REM)                     */         /*AR544187 CCB022B*/
                                                                                         /*BUG3875*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                             /*AR1055617*/
             OVRDBF     FILE(FCLTYFN) SEQONLY(*YES 300) +
                           NBRRCDS(300)                                                 /*AR544187*/
             OVRDBF     FILE(FCLTYFM) SEQONLY(*YES 100) +
                           NBRRCDS(100)                                                 /*AR544187*/
             ENDDO                                                                        /*CLE134*/
                                                                                          /*CLE134*/
                   CLRPFM     FILE(FCLTYHH)
                   CLRPFM     FILE(FCLTYFM)
                   CLRPFM     FILE(FCLTYFN)
                   CLRPFM     FILE(FCLTYZZ)
/**/
/* UPDATE PF/FCLTYxx                                                 */
/**********        CPYF       FROMFILE(NFACLHH) TOFILE(FCLTYHH) +    */                  /*CCB022B*/
/**********                   MBROPT(*ADD) FMTOPT(*NOCHK)            */                  /*CCB022B*/
/**/
/**********        CPYF       FROMFILE(NFACLFM) TOFILE(FCLTYFM) +    */                  /*CCB022B*/
/**********                   MBROPT(*ADD) FMTOPT(*NOCHK)            */                  /*CCB022B*/
/******************MONMSG     MSGID(CPF2817)                       */ /*131373*/
/**/
/**********        CPYF       FROMFILE(NFACLFN) TOFILE(FCLTYFN) +    */                  /*CCB022B*/
/**********                   MBROPT(*ADD) FMTOPT(*NOCHK)            */                  /*CCB022B*/
/******************MONMSG     MSGID(CPF2817)                       */ /*131373*/
/**/
/**********        CPYF       FROMFILE(NFACLZZ) TOFILE(FCLTYZZ) +    */                  /*CCB022B*/
/**********                   MBROPT(*ADD) FMTOPT(*NOCHK)            */                  /*CCB022B*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0609A01                                          */
/**/                                                                  /*S01408*/
/***Enable*Access*Paths*after*COPY**/                                           /*AR544187 CCB022B*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)           */         /*CLE134 AR1055617*/
/**********        SCLFMMGR  FILE(FCLTYHH) ACTION(ADD)               */         /*AR544187 CCB022B*/
/**********        SCLFMMGR  FILE(FCLTYFM) ACTION(ADD)               */         /*AR544187 CCB022B*/
/**********        SCLFMMGR  FILE(FCLTYFN) ACTION(ADD)               */         /*AR544187 CCB022B*/
/**********        SCLFMMGR  FILE(FCLTYZZ) ACTION(ADD)               */         /*AR544187 CCB022B*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
                                                                                          /*CLE134*/
             IF         COND(&ULX004 = 'Y') THEN(DO)                                      /*CER001*/
             CPYF       FROMFILE(LEFCX1PD) TOFILE(LENFX1PD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CER001*/
                   MONMSG     MSGID(CPF2817)                                              /*CER001*/
             CPYF       FROMFILE(LEFCX2PD) TOFILE(LENFX2PD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CER001*/
                   MONMSG     MSGID(CPF2817)                                              /*CER001*/
             CPYF       FROMFILE(LENFX1J0) TOFILE(LEFCX1PD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CER001*/
                   MONMSG     MSGID(CPF2817)                                              /*CER001*/
             CPYF       FROMFILE(LENFX2J0) TOFILE(LEFCX2PD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CER001*/
                   MONMSG     MSGID(CPF2817)                                              /*CER001*/
             ENDDO                                                                        /*CER001*/
/**/
/* UPDATE P/MFU IND.                                                 */
/******************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/******************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/        /*S01189*/
/******************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
/*****************************VALUE('OLD')****/                       /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)*/               /*S01189*/
/******************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('N')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
/**/
/**********        CLRPFM     FILE(NFACLHH)                        */                   /*CLE075AF*/
/**********        CLRPFM     FILE(NFACLFM)                        */                   /*CLE075AF*/
/**********        CLRPFM     FILE(NFACLFN)                        */                   /*CLE075AF*/
/**********        CLRPFM     FILE(NFACLZZ)                        */                   /*CLE075AF*/
/**********        IF         COND(&CLE005 *EQ 'Y') +
                      THEN(CLRPFM     FILE(LECAUTPD))              */            /*127720 CLE075AF*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0609A02                                          */
/**/                                                                  /*S01408*/
/**********  IF         COND(&ULX004 = 'Y') THEN(DO)               */            /*CER001 CLE075AF*/
/**********        CLRPFM     FILE(LENFX1PD)                       */            /*CER001 CLE075AF*/
/**********        CLRPFM     FILE(LENFX2PD)                       */            /*CER001 CLE075AF*/
/**********  ENDDO                                                 */            /*CER001 CLE075AF*/
/**/
/**********        CLRPFM     FILE(FCUPDHH)                        */                   /*CLE075AF*/
/**********        IF         COND(&CLE005 *EQ 'N')  +
                      THEN(CLRPFM     FILE(FCUPDFM))               */            /*154584 CLE075AF*/
/***************** CLRPFM     FILE(FCUPDFM) ***/                      /*154584*/
/**********        CLRPFM     FILE(FCUPDFN)                        */                   /*CLE075AF*/
/**********        CLRPFM     FILE(FCUPDZZ)                        */                   /*CLE075AF*/
/**/
/*                 CLRPFM     FILE(LVNTXHH) /*  CREATED IN LE0480  *    045634*/
/*                 CLRPFM     FILE(LVNYXEL)*/ /*  USED BY LE0490     *  *E0231*/
/*                 CLRPFM     FILE(LVNTXEL)   /*  USED BY LE0490/*E0231 045634*/
/*                 CLRPFM     FILE(LVNTXZZ)                             045634*/
/**/
                ENDDO
/**/
             ENDDO
/**/                                                                   /*S0650*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             DLTOVR     FILE(NFACLFN NFACLFM FCLTYFN FCLTYFM)                           /*AR544187*/
             MONMSG CPF9841                                                            /*AR1022006*/
             ENDDO                                                                        /*CLE134*/
                                                                                        /*AR544187*/
/*SWITCH OFF EM SWITCH 1           */                                  /*S0650*/
/**/                                                                   /*S0650*/
             IF         COND(%SST(&MMOD 7 1)='Y') THEN(CHGJOB +
                             SWS(0XXXXXXX))                            /*S0650*/
/**/
             GOTO       CMDLBL(ENDPGM)                                /*131373*/
/*  Abnormal Termination                                               *131373*/
ABNOR:                                                                /*131373*/
/*  If database error, output message to user  */                     /*131373*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)              /*131373*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*131373*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*131373*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*131373*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*131373*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*131373*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*131373*/
             ENDDO                                                    /*131373*/
             SNDPGMMSG  MSG('LEC0609A Customer Lending Events File +
                          Creation  ended  abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*131373*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*131373*/
             CHGJOB     SWS(XXXXXX11)                                 /*131373*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*131373*/
             DSPJOBLOG  OUTPUT(*PRINT)                                /*131373*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*131373*/
             DMPCLPGM                                                 /*131373*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*131373*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
