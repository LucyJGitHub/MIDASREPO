/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Daily update phase two')                     */
/********************************************************************/
/*                                                                  */
/*     Midas - Customer Lending Module                              */
/*                                                                  */
/*     LEC0605  -  DAILY MAINTENANCE PHASE - 2                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. MD048608           Date 20Nov17              */
/*       Prev Amend No. MD031676           Date 17Dec14              */
/*                      MD023527           Date 18Nov13              */
/*                      MD022967           Date 21Oct13              */
/*                      MD022290           Date 09Sep13              */
/*                      MD020268           Date 12May13              */
/*                      AR1091292          Date 04Mar13              */
/*                      CCB022B            Date 06Aug12              */
/*                      AR1080825          Date 28Jan13              */
/*                      AR1055617          Date 12Nov12              */
/*                      AR544187           Date 01Aug12              */
/*                      263074             Date 01Aug12              */
/*                      262509             Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      258399             Date 19Jan09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CDL045             Date 14Feb06              */
/*                      CER001             Date 25Apr05              */
/*                      CLE038             Date 13May04              */
/*                      CAS009             Date 04May04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      180044             Date 17Jul00              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      119350             Date 09Jul97              */
/*                      128044             Date 02Dec97              */
/*                      CLE005             Date 22May97              */
/*                      099147             Date  17Jun96             */
/*                      106892             Date  09Aug96             */
/*                      105061    DATE  21JUN96                     */
/*                      S01408    DATE  23MAY96                     */
/*                      S01408    DATE  01MAY96                     */
/*                      S01408    DATE  22APR96                     */
/*                      S01408    DATE  21FEB96                     */
/*                      091793    DATE  22JAN96                     */
/*                      S01408    DATE  08JAN96                     */
/*                      093379    DATE  25SEP95                     */
/*                      S01408    DATE  05SEP95                     */
/*                      S01408    DATE  17AUG95                     */
/*                      082177    DATE  25JAN95                     */
/*                      S10227    DATE  07APR92                     */
/*                      BHF982    DATE  19FEB91                     */
/*                      S01194    DATE  07FEB90                     */
/*                      S01189    DATE  08FEB90                     */
/*                      S01179    DATE  14/09/88                    */
/*                      S01098    DATE  08/07/86                    */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*     MD048608 - Component LEC0609B seq 01001 failed               */
/*     MD031676 - Component LEC06A 0010 Failed during COB           */
/*                Removed copy statement for file LEACCNPD which    */
/*                was made redundant by enhancement F               */
/*     MD023527 - Error encountered when CLE134 is OFF.             */
/*     MD022967 - LEC06A 00010 no TOFILE value in CPYF              */
/*     MD022290 - BankFusion_Close of Business: Reversed loan       */
/*                wasn't deleted from LEPEMGD file after COB        */
/*     MD020268 - Failed recovery processing                        */
/*     AR1091292 - LEC08 00001_FOOB in Interst Accruals Extract -   */
/*                 File Controls                                    */
/*     CCB022B - COB Restructure - COB File Manager                 */
/*     AR1080825 - LEC06A seq 03002 encountered error in Day 3 SG   */
/*                 COB caused by incomplete fix introduced by       */
/*                 262509. Applied fix 262509                       */
/*     AR1055617 - Additional code changes based on code            */
/*                 review                                           */
/*     AR544187 - Improve performance of some LE COB Components     */
/*                (Child: AR544189)                                 */
/*     263074 - Wrong Postings when interest and principal are      */
/*              paid on the same day (Recompile)                    */
/*     262509 - Empty STAT flag returned by COB                     */
/*     CLE134 - Past Due Call Loan Processing                       */
/*     258399 - copy NLAMSQD to CLOAMSQD.                           */
/*     CDL045 - Copy out Account Keys file to Extract library       */
/*              as specified on the System Value parameter          */
/*              'AccountKeysSavedLib'                               */
/*              Upgrade to Midas Plus 1.2                           */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*     CLE038 - Lending Enhancement for Nordea: Allocation by Amt   */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       180044 - Copy REVPDDP to ACTN5DK before running LE0440.     */
/*     119350 - MCLONCL/CK not being updated with records created   */
/*              in XMCLONCL/CK by LE0450. Amended the pgm to copy   */
/*              the records to the matured loans file if the pgm    */
/*              ends normally.                                      */
/*     128044 - Restore copy to LETEMPPD                            */
/*     CLE005 - Customer Lending Enhancements - Tranche 3           */
/*     106892 - Recovery processing does not work.  Perform file    */
/*              override on MCLONCL.                                */
/*     105061 - Switch on U7 and U8 if an error occurs so that it   */
/*              can be detected by the COB Monitor.                 */
/*     099147 - Recovery for MCLONCL and MCLONCL does not work,     */
/*              causing duplicate records on restart. Fix is to     */
/*              Make security copies of files MCLONCL and MCLONCK   */
/*              before running program LE0450, and restore these    */
/*              copies if the component is restarted.               */
/*     S01408 - Addition of core hook LEC0605010                    */
/*              Addition of core hook LEC0605011                    */
/*              Addition of core hook LEC0605012                    */
/*     S01408 - Addition of core hook LEC0605009                    */
/*              Addition of core hook LEC0605008                    */
/*              Addition of core hook LEC0605007                    */
/*              Addition of core hook LEC0605006                    */
/*     S01408 - Addition of core hook LEC0605DCL                    */
/*     S01408 - Addition of core hook LEC0605005                    */
/*     091793 - Duplicate ST record is produced in history file     */
/*              HISTSHM since CLOANCL does not contain the updated  */
/*              records from the extract file NCLONCL due to failure*/
/*              in the CPYF command.                                */
/*              (This fix has been incorporated from R.2 due to the */
/*              possibility of it also being an error at R.10)      */
/*     S01408 - Addition of core hook LEC0605INT                    */
/*              Addition of core hook LEC0605004                    */
/*     093379 - Update PMLOANPD with details of todays reversed     */
/*              loans for use in PM1500                             */
/*     S01408 - Addition of core hook LEC0605002                    */
/*                                    LEC0605003                    */
/*     S01408 - Addition of core hook LEC0605001                    */
/*     082177 - SAVE MATURED LOANS IN A WORK FILE OTHERWISE         */
/*              DATABASE ERROR IN LB0690                            */
/*     S10227 - RETENTION OF MATURED LOANS HISTORY                  */
/*     BHF982 - ADDLFM SHOULD BE SHARE(*YES)                        */
/*     S01194 - NEW STANDING DATA                                   */
/*     S01189  -  COB RECOVERY PROCESSING                           */
/*     S01179  -  AS400 INCORPORATION                               */
/*     S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,INSTEAD   */
/*                OF CLEARING AND ADDING.                           */
/*                FROM AND TO FILES ARE NOW 'BLOCKED'.              */
/*                                                                  */
/********************************************************************/
/************PGM                                                      /*S01189*/
/**********  PGM        PARM(&CNAM &CSEQ) */                                       /*S01189 CLE134*/
             PGM        PARM(&CNAM &CSEQ &RERUN)                                          /*CLE134*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('CUSTOMER LENDING FILE UPDATE +
                        PHASE TWO ')
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CLE005*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CLE005*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CLE005*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CLE005*/
             DCL        VAR(&CLE005) TYPE(*CHAR) LEN(1)               /*CLE005*/
             DCL        VAR(&LKEY1) TYPE(*CHAR) LEN(10)                                   /*CDL045*/
             DCL        VAR(&LKEY1B) TYPE(*CHAR) LEN(10)                                  /*CDL045*/
             DCL        VAR(&LKEY3) TYPE(*CHAR) LEN(10)                                   /*CDL045*/
             DCL        VAR(&LKEY3B) TYPE(*CHAR) LEN(10)                                  /*CDL045*/
             DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(8)                                   /*CDL045*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*CDL045*/
             DCL        VAR(&CDL045) TYPE(*CHAR) LEN(1)                                   /*CDL045*/
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&LEPDCL) TYPE(*CHAR) LEN(256)                                 /*CLE134*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                   /*CLE134*/
             DCL        VAR(&CLE134) TYPE(*CHAR) LEN(1)                                /*AR1055617*/
                                                                                          /*CDL045*/
/* Define parameters used in AOSVALR0 to retrieve system value                            /*CDL045*/
/*/COPY SDCPYSRC,SDSVALDCL                                                    */          /*CDL045*/
             DCL        VAR(&ULX004) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CER001*/
             DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CAS009*/
             DCL        VAR(&CLE038) TYPE(*CHAR) LEN(1)                                   /*CLE038*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LEC0605DCL                                           /*S01408*/
/**/                                                                  /*082177*/
             DCLF       FILE(SDMMODPD)                                /*082177*/
/**/                                                                  /*091793*/
             MONMSG     MSGID(CPF0000 MCH0000) +
                        EXEC(GOTO CMDLBL(ABNOR))                      /*091793*/
                                                                                          /*CLE134*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                                /*CLE134*/
             RTVDTAARA  DTAARA(LEPDCL) RTNVAR(&LEPDCL)                                    /*CLE134*/
                 IF         COND(%SUBSTRING(&LEPDCL 1 1) *EQ 'N') +
                               THEN(GOTO CMDLBL(ENDPGM))                                  /*CLE134*/
             ENDDO                                                                        /*CLE134*/
/**/                                                                  /*091793*/
/* Before doing anything make sure that any missing members     */                      /*AR544189*/
/* are reinstated */                                                                    /*AR544189*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)           */         /*CLE134 AR1055617*/
/**********  SCLFMMGR  FILE(LOAMSDH) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(LOAMSDK) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(LOAMSZ1) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANHH) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANCL) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANCK) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANZ1) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(LESTALPD) ACTION(ADD)                    */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(MCLONCL) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(MCLONCK) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
                                                                                        /*AR544189*/
/* READ FILE SDMMODPD TO TEST IF PORTFOLIO LENDING PRESENT         */ /*082177*/
             RCVF       RCDFMT(SDMMODD0)                              /*082177*/
                                                                      /*S01408*/
/**/                                                                                   /*AR1055617*/
/* Check if CLE134 is installed */                                                     /*AR1055617*/
/**/                                                                                   /*AR1055617*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                    /*AR1055617*/
             CHGVAR     VAR(&SARD) VALUE('CLE134')                                     /*AR1055617*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                     /*AR1055617*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                             /*AR1055617*/
                          CHGVAR VAR(&CLE134) VALUE('Y')                               /*AR1055617*/
             ENDDO                                                                     /*AR1055617*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)           */         /*CLE134 AR1055617*/
/**********  IF         COND(&CLE134 *EQ 'Y') THEN(DO)             */         /*AR1055617 MD022967*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                                /*CLE134*/
             CHGVAR     VAR(&DPLIB) VALUE(&PRFX *TCAT 'DPLIB')                            /*CLE134*/
/**********  ENDDO                                                 */            /*CLE134 MD022967*/
                                                                                          /*CLE134*/
/*/COPY WNCPYSRC,LEC0605INT                                           /*S01408*/
                                                                      /*S01408*/
/**/
/*           DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
/*           DCLDTAARA  DTAARA(LESTAT)                              *  *S01179*/
/**/                                                                                      /*CDL045*/
/* Check if CDL045 is installed */                                                        /*CDL045*/
/**/                                                                                      /*CDL045*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL045*/
             CHGVAR     VAR(&SARD) VALUE('CDL045')                                        /*CDL045*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CDL045*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL045) VALUE('Y'))                                        /*CDL045*/
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
                          CMDLBL(ABNOR))                                                  /*CDL045*/
                                                                                          /*CDL045*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                                /*CDL045*/
                                                                                          /*CDL045*/
/* Set value of extract library */                                                        /*CDL045*/
             CHGVAR     VAR(&EXTLIB) VALUE(%SST(&SVAL1 1 10))                             /*CDL045*/
             CHGVAR     VAR(&LKEY1) VALUE(&PRFX *CAT 'LKEY1DP')                           /*CDL045*/
             CHGVAR     VAR(&LKEY3) VALUE(&PRFX *CAT 'LKEY3DP')                           /*CDL045*/
             CHGVAR     VAR(&LKEY1B) VALUE(&PRFX *CAT 'LKEY1DP2')                         /*CDL045*/
             CHGVAR     VAR(&LKEY3B) VALUE(&PRFX *CAT 'LKEY3DP2')                         /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/
/**/                                                                  /*CLE005*/
/* Check if CLE005 is installed */                                    /*CLE005*/
/**/                                                                  /*CLE005*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE005*/
             CHGVAR     VAR(&SARD) VALUE('CLE005')                    /*CLE005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CLE005*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE005) VALUE('Y'))                    /*CLE005*/
/**/                                                                                      /*CER001*/
/* Check if ULX004 is installed */                                                        /*CER001*/
/**/                                                                                      /*CER001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER001*/
             CHGVAR     VAR(&SARD) VALUE('ULX004')                                        /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CER001*/
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
/**/                                                                                      /*CAS009*/
/* Check if CAS009 is installed */                                                        /*CAS009*/
/**/                                                                                      /*CAS009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CAS009*/
             CHGVAR     VAR(&SARD) VALUE('CAS009')                                        /*CAS009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CAS009*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CAS009) VALUE('Y'))                                        /*CAS009*/
/*/COPY WNCPYSRC,LEC0605015                                          */
/**/                                                                                      /*CLE038*/
/* Check if CLE038 is installed */                                                        /*CLE038*/
/**/                                                                                      /*CLE038*/
             CHGVAR     VAR(&SARD) VALUE('CLE038')                                        /*CLE038*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CLE038*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE038) VALUE('Y'))                                        /*CLE038*/
/**/
/*  IF P/MFU INDICATOR 'OLD' THEN CLEAR PF/NLAMSxx PF/NCLONxx ,     */
/*   UPDATE FILES AND P/MFU INDICATOR TO 'NEW'                      */
/**/
/************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/              /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)          /*S01189*/
/**/
             IF         COND(&STAT *EQ 'Y') THEN(DO)                                   /*AR1055617*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                      /*CLE134 AR1055617*/
/* If restart process and CLE134 is on  */                                                /*CLE134*/
/**/                                                                                      /*CLE134*/
/**/                                                                                      /*CLE134*/
/**********  IF         COND(&STAT *EQ 'Y') THEN(DO)                         */ /*CLE134 AR1055617*/
/**/                                                                                      /*CLE134*/
/* LEACCNPD */                                                                   /*CLE134 MD031676*/
/**********  IF         COND(&CLE134 *EQ 'Y') THEN(DO) */                     /*AR1055617 MD031676*/
/**********   CPYF       FROMFILE(XLEACCNPD) TOFILE(LEACCNPD) +
/**********               TOMBR(*FIRST) MBROPT(*REPLACE) */                      /*CLE134 MD031676*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(+
/**********   CLRPFM    FILE(LEACCNPD)) */                                       /*CLE134 MD031676*/
/**********  ENDDO */                                                         /*AR1055617 MD031676*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                             /*AR1055617*/
             CPYF       FROMFILE(&DPLIB/XLEPK1DPD) +
                          TOFILE(&DPLIB/LEPK1DPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)                                                   /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DPLIB/XLEPK1DPD))                                         /*CLE134*/
             CPYF       FROMFILE(&DPLIB/XLEPK1ZZ) +
                          TOFILE(&DPLIB/LEPK1ZZ) MBROPT(*REPLACE) +
                          CRTFILE(*YES)                                                   /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DPLIB/XLEPK1ZZ))                                          /*CLE134*/
             ENDDO                                                                     /*AR1055617*/
                                                                                        /*MD020268*/
             IF         COND(&CLE134 *EQ 'Y') THEN(DO)                                  /*MD023527*/
             CPYF       FROMFILE(&DPLIB/XACTN5DK) +
                          TOFILE(&DPLIB/ACTN5DK) MBROPT(*REPLACE)                       /*MD020268*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DPLIB/ACTN5DK))                                         /*MD020268*/
             ENDDO                                                                      /*MD023527*/
                                                                                        /*MD020268*/
             ENDDO                                                                        /*CLE134*/
              /**/                                                                        /*CLE134*/
             IF         COND(&STAT *NE 'Y') THEN(DO)                                      /*CLE134*/
/**********  IF         COND(&CLE134 *EQ 'Y') THEN(DO) */                     /*AR1055617 MD031676*/
/**********  DLTF       FILE(&DPLIB/XLEACCNPD) */                                /*CLE134 MD031676*/
/**********  MONMSG     MSGID(CPF2105) */                                        /*CLE134 MD031676*/
/**********  ENDDO */                                                        /*AR1055617  MD031676*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                             /*AR1055617*/
             DLTF       FILE(&DPLIB/XLEPK1DPD)                                            /*CLE134*/
             MONMSG     MSGID(CPF2105)                                                    /*CLE134*/
             DLTF       FILE(&DPLIB/XLEPK1ZZ)                                             /*CLE134*/
             MONMSG     MSGID(CPF2105)                                                    /*CLE134*/
             ENDDO                                                                     /*AR1055617*/
/**/                                                                                      /*CLE134*/
/**********  IF         COND(&CLE134 *EQ 'Y') THEN(DO) */                     /*AR1055617 MD031676*/
/**********  CPYF       FROMFILE(LEACCNPD) TOFILE(&DPLIB/XLEACCNPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) */                      /*CLE134 MD031676*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) */                        /*CLE134 MD031676*/
/**********  ENDDO */                                                         /*AR1055617 MD031676*/
/**/                                                                                      /*CLE134*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                             /*AR1055617*/
             CPYF       FROMFILE(&DPLIB/LEPK1ZZ) +
                          TOFILE(&DPLIB/XLEPK1ZZ) MBROPT(*REPLACE) +
                          CRTFILE(*YES)                                                   /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CLE134*/
/**/                                                                                      /*CLE134*/
             CPYF       FROMFILE(&DPLIB/LEPK1DPD) +
                          TOFILE(&DPLIB/XLEPK1DPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)                                                   /*CLE134*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*CLE134*/
             ENDDO                                                                     /*AR1055617*/
                                                                                        /*MD020268*/
             IF         COND(&CLE134 *EQ 'Y') THEN(DO)                                  /*MD023527*/
             CPYF       FROMFILE(&DPLIB/ACTN5DK) +
                          TOFILE(&DPLIB/XACTN5DK) MBROPT(*REPLACE) +
                          CRTFILE(*YES)                                                 /*MD020268*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&DPLIB/XACTN5DK))                                        /*MD020268*/
             ENDDO                                                                      /*MD023527*/
                                                                                        /*MD020268*/
/**********  ENDDO                                                              /*CLE134 AR1055617*/
             ENDDO                                                                        /*CLE134*/
/************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'OLD') +
 ***********************THEN(DO)                                      /*S01189*/
/**********  IF         COND(&STAT *EQ 'N') THEN(DO)                               /*S01189 262509*/
             IF         COND(&STAT *NE 'Y') THEN(DO)                                      /*262509*/
/**/                                                                                      /*CLE134*/
/**********     IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)        */         /*CLE134 AR1055617*/
                   OVRDBF     FILE(NLAMSDK) SEQONLY(*YES 100) NBRRCDS(100)              /*AR544189*/
                   OVRDBF     FILE(LOAMSDK) SEQONLY(*YES 100) NBRRCDS(100)              /*AR544189*/
                   OVRDBF     FILE(NCLONCL) SEQONLY(*YES 100) NBRRCDS(100)              /*AR544189*/
                   OVRDBF     FILE(NCLONCK) SEQONLY(*YES 100) NBRRCDS(100)              /*AR544189*/
                   OVRDBF     FILE(CLOANCL) SEQONLY(*YES 100) NBRRCDS(100)              /*AR544189*/
                   OVRDBF     FILE(CLOANCK) SEQONLY(*YES 100) NBRRCDS(100)              /*AR544189*/
/**********     ENDDO                                                */         /*CLE134 AR1055617*/
/**/
                CLRPFM     FILE(NLAMSDH)       /* NEW LF/LOAMS FILE */
                CLRPFM     FILE(NLAMSDK)       /* OUTPUT FROM LE0440*/
                CLRPFM     FILE(NLAMSQD)       /* OUTPUT FROM LE0440*/                    /*258399*/
                CLRPFM     FILE(NLAMSZ1)
/**/
                CLRPFM     FILE(NCLONHH)       /* NEW LF/CLOAN FILE */
                CLRPFM     FILE(NCLONCL)       /* OUTPUT FROM LE0450*/
                CLRPFM     FILE(NCLONCK)
                CLRPFM     FILE(NCLONZ1)
/**/
                CLRPFM     FILE(PDUEHH)
                CLRPFM     FILE(PDUEDU)
                CLRPFM     FILE(PDUEZX)
/*/COPY WNCPYSRC,LEC0605019                                          */
/**/
                CLRPFM     FILE(LKEY1HH)
                CLRPFM     FILE(LKEY1DP)
                CLRPFM     FILE(LKEY1ZZ)
                                                                                          /*CLE134*/
                IF         COND(&RERUN *EQ '      ') THEN(DO)                             /*CLE134*/
                  CLRPFM     FILE(LEPK1DPD)                                               /*CLE134*/
                  CLRPFM     FILE(LEPK1HH)                                                /*CLE134*/
                  CLRPFM     FILE(LEPK1ZZ)                                                /*CLE134*/
                ENDDO                                                                     /*CLE134*/
/**/
                CLRPFM     FILE(MATLNHH)
                CLRPFM     FILE(MATLNMT)
                CLRPFM     FILE(MATLNZX)
/**/                                                                  /*CLE005*/
                IF         COND(&CLE005 *EQ 'Y') THEN(DO)             /*CLE005*/
                  CLRPFM     FILE(LKEY3HH)                            /*CLE005*/
                  CLRPFM     FILE(LKEY3DP)                            /*CLE005*/
                  CLRPFM     FILE(LKEY3ZZ)                            /*CLE005*/
                ENDDO                                                 /*CLE005*/
/**/                                                                                      /*CLE038*/
                IF         COND(&CLE038 *EQ 'Y') THEN(DO)                                 /*CLE038*/
                  CLRPFM     FILE(XESTALPD)                                               /*CLE038*/
                                                                                          /*CLE038*/
/*  Take Temporary copy of LESTALPD for update by LE0450                                  /*CLE038*/
             CPYF       FROMFILE(LESTALPD) TOFILE(XESTALPD) +
                          MBROPT(*REPLACE)                                                /*CLE038*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XESTALPD))                                                 /*CLE038*/
             OVRDBF     FILE(LESTALPD) TOFILE(XESTALPD)                                   /*CLE038*/
             OVRDBF     FILE(LESTALL0) TOFILE(LEXSTAL0) MBR(LEXSTAL0)                     /*CLE038*/
             OVRDBF     FILE(LESTALL3) TOFILE(LEXSTAL3) MBR(LEXSTAL3)                     /*CLE038*/
             OVRDBF     FILE(LESTALL4) TOFILE(LEXSTAL4) MBR(LEXSTAL4)                     /*CLE038*/
             OVRDBF     FILE(LESTALL5) TOFILE(LEXSTAL5) MBR(LEXSTAL5)                     /*CLE038*/
                ENDDO                                                                     /*CLE038*/
                IF         COND(&CLE038 *NE 'Y') THEN(DO) /*MD048608*/
                   IF         COND(&CLE134 *EQ 'Y') THEN(DO) /*MD048608*/
                   CLRPFM     FILE(XESTALPD) /*MD048608*/
                                                                                        /*MD048608*/
                   CPYF       FROMFILE(LESTALPD) TOFILE(XESTALPD) MBROPT(*REPLACE) +
                                /*MD048608*/
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(XESTALPD)) /*MD048608*/
                   ENDDO      /*MD048608*/
                ENDDO      /*MD048608*/
                                                                                          /*CAS009*/
                IF         COND(&CAS009 *EQ 'Y') THEN(DO)                                 /*CAS009*/
                  CPYF       FROMFILE(LEEIRDPD) TOFILE(XLEEIRDPD) +
                               MBROPT(*REPLACE)                                           /*CAS009*/
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                               FILE(XLEEIRDPD))                                           /*CAS009*/
                  OVRDBF     FILE(LEEIRDPD) TOFILE(XLEEIRDPD)                             /*CAS009*/
                ENDDO                                                                     /*CAS009*/
                                                                      /*S10227*/
/*  NEW FILES FOR HISTORY RETENTION SAR                               /*S10227*/
                CLRPFM     FILE(XMCLONCL)                             /*S10227*/
                CLRPFM     FILE(XMCLONCK)                             /*S10227*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0605006                                  */       /*S01408*/
/*                                                           */
/**/
/*  SAVE LOANS REVERSED TODAY FOR USE IN PM1500 */                    /*093379*/
             CPYF       FROMFILE(CLOANCL) TOFILE(PMLOANPD) +
                          MBROPT(*REPLACE) INCREL((*IF RECI *EQ +
                          'R'))                                       /*093379*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PMLOANPD))                             /*093379*/
/**/
/*  TAKE TEMPORARY COPY OF CLOANCL FOR P'TY EXTRACTS         */

             IF         COND(&RERUN *NE 'NEWCOB') THEN(DO)                              /*MD022290*/
                DLTF       FILE(&DPLIB/XPETEMPLN)                                       /*MD022290*/
                MONMSG     MSGID(CPF2105)                                               /*MD022290*/
                CPYF       FROMFILE(CLOAN) TOFILE(&DPLIB/XPETEMPLN) +
                           CRTFILE(*YES) RCDFMT(CLOANCLF) +
                           INCREL((*IF RECI *EQ 'R'))                                   /*MD022290*/
             ENDDO                                                                      /*MD022290*/
                                                                                        /*MD022290*/
             CPYF       FROMFILE(CLOAN) TOFILE(PETEMPLN) +
                          MBROPT(*REPLACE) RCDFMT(CLOANCLF)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(PETEMPLN))

             CPYF       FROMFILE(CLOAN) TOFILE(LETEMPPD) +
                          MBROPT(*REPLACE) RCDFMT(CLOANCKF)
    MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LETEMPPD)) /*128044*/
                                                                      /*128044*/
             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                              /*MD022290*/
                CPYF       FROMFILE(&DPLIB/XPETEMPLN) +
                           TOFILE(&DPLIB/PETEMPLN) MBROPT(*ADD)
             ENDDO                                                                      /*MD022290*/
                                                                                        /*MD022290*/
                SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/                                                                  /*180044*/
/* Copy file REVPDDP (contains the reversed PD records) to ACTN5DK    /*180044*/
/**/                                                                  /*180044*/
             CPYF       FROMFILE(REVPDDP) TOFILE(ACTN5DK) +
                          MBROPT(*ADD)                                /*180044*/
             MONMSG     MSGID(CPF2817)                                /*180044*/
             MONMSG     MSGID(CPF2869)                                /*180044*/
/**/                                                                  /*180044*/
/**/
/**********     OVRDBF     FILE(TABLE) TOFILE(TABLEEE)   */           /*S01194*/
/**********     CALL       PGM(LE0440)      */                                            /*CLE134*/
                CALL       PGM(LE0440) PARM(&RERUN)                                       /*CLE134*/
/**********     DLTOVR     FILE(TABLE)                   */           /*S01194*/
/**/
   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/**********        OVRDBF     FILE(TABLE)  TOFILE(TABLEEI)  */        /*S01194*/
/**********      OVRDBF     FILE(TABLED) TOFILE(TABLEEI) SHARE(*NO)*/ /*S01194*/

/***Keep*a*copy*of MCLONCL and MCLONCK before the run of next   *099147 119350*/
/*********** CPYF       FROMFILE(MCLONCL) TOFILE(XMCLONCL) +          /*119350*/
/***************          MBROPT(*ADD)                      */ /*099147 119350*/
/*********** CPYF       FROMFILE(MCLONCK) TOFILE(XMCLONCK) +          /*119350*/
/**************           MBROPT(*ADD)                      */ /*099147 119350*/
/*/COPY WNCPYSRC,LEC0605010                                           /*S01408*/
/**/                                                                  /*106892*/
                   OVRDBF     FILE(MCLONCL) TOFILE(XMCLONCL)          /*106892*/
                   OVRDBF     FILE(MCLONCK) TOFILE(XMCLONCK)          /*106892*/
/**/                                                                  /*106892*/

/**********        CALL       PGM(LE0450) */                                              /*CLE134*/
                   CALL       PGM(LE0450) PARM(&RERUN)                                    /*CLE134*/
/**/                                                                  /*106892*/
                   DLTOVR     FILE(MCLONCL)                           /*106892*/
                   DLTOVR     FILE(MCLONCK)                           /*106892*/
                                                                                          /*CDL045*/
/* CDL045 - Copy out Account Keys file(s) to extract library   */                         /*CDL045*/
                                                                                          /*CDL045*/
         IF         COND(&CDL045 *EQ 'Y') THEN(DO)                                        /*CDL045*/
                                                                                          /*CDL045*/
  /*If Accrual Non-working Day process */                                                 /*CDL045*/
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)                                  /*CDL045*/
             CPYF       FROMFILE(LKEY1DP) TOFILE(&EXTLIB/&LKEY1B) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&EXTLIB/&LKEY1B))                                          /*CDL045*/
             CPYF       FROMFILE(LKEY3DP) TOFILE(&EXTLIB/&LKEY3B) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&EXTLIB/&LKEY3B))                                          /*CDL045*/
                          ENDDO                                                           /*CDL045*/
             ELSE       CMD(DO)                                                           /*CDL045*/
             CPYF       FROMFILE(LKEY1DP) TOFILE(&EXTLIB/&LKEY1) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(&EXTLIB/&LKEY1))                                           /*CDL045*/
             CPYF       FROMFILE(LKEY3DP) TOFILE(&EXTLIB/&LKEY3) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(&EXTLIB/&LKEY3))                                     /*CDL045*/
 /* Clear ANWD files */                                                                   /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&LKEY1B)                                             /*CDL045*/
             MONMSG     MSGID(CPF3142)                  /* file does not exist */         /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&LKEY3B)                                             /*CDL045*/
             MONMSG     MSGID(CPF3142)                  /* file does not exist */         /*CDL045*/
             ENDDO                                                                        /*CDL045*/
                                                                                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
             IF         COND(&CLE038 *EQ 'Y') THEN(DO)                                    /*CLE038*/
             DLTOVR     FILE(LESTALL0)                                                    /*CLE038*/
             MONMSG     MSGID(CPF9841)                                                    /*CLE038*/
             DLTOVR     FILE(LESTALL3)                                                    /*CLE038*/
             MONMSG     MSGID(CPF9841)                                                    /*CLE038*/
             DLTOVR     FILE(LESTALL4)                                                    /*CLE038*/
             MONMSG     MSGID(CPF9841)                                                    /*CLE038*/
             DLTOVR     FILE(LESTALL5)                                                    /*CLE038*/
             MONMSG     MSGID(CPF9841)                                                    /*CLE038*/
             DLTOVR     FILE(LESTALPD)                                                    /*CLE038*/
             ENDDO                                                                        /*CLE038*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LEC0605001                                           /*S01408*/
                                                                      /*S01408*/
/**********        DLTOVR     FILE(*ALL)                    */        /*S01194*/
/**/
                   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/*/COPY WNCPYSRC,LEC0605011                                           /*S01408*/
/**/                                                                  /*082177*/
/* IF PORTFOLIO LENDING ON, SAVE MATURED LOANS IN A WORK FILE     */  /*082177*/
             IF         COND(&BGLMCR *EQ 'Y') THEN(DO)                /*082177*/
             CPYF       FROMFILE(MATLNMT) TOFILE(LBMATLPD) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)             /*082177*/
             MONMSG     MSGID(CPF0000)                                /*082177*/
                      ENDDO                                           /*082177*/
/**/
                      ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
                      RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
                      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/* YEAREND                                                          */
/*********************IF         COND(%SUBSTRING(&LDA 178 7) +   */   /*S01194*/
                      IF         COND(%SUBSTRING(&LDA 184 7) +
                                 *EQ YEAREND) THEN(DO)
                         CHGVAR     VAR(%SUBSTRING(&LESTAT 13 2)) +
                                    VALUE('YY')
                      ENDDO
/* MONTHEND                                                         */
/*********************IF         COND(%SUBSTRING(&LDA 178 7) +   */   /*S01194*/
                      IF         COND(%SUBSTRING(&LDA 184 8) +
                                 *EQ MONTHEND) THEN(DO)
                         CHGVAR     VAR(%SUBSTRING(&LESTAT 13 1)) +
                                    VALUE('Y')
                      ENDDO
/* P/MFU 'NEW'                                                      */
/************************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 ***********************************VALUE('NEW')*****/                /*S01189*/
                   IF         COND((&CAS009) *EQ 'Y') THEN(DO)                            /*CAS009*/
                      DLTOVR     FILE(LEEIRDPD)                                           /*CAS009*/
                      CPYF       FROMFILE(XLEEIRDPD) TOFILE(LEEIRDPD) +
                                   MBROPT(*REPLACE)                                       /*CAS009*/
                      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                   FILE(LEEIRDPD))                                        /*CAS009*/
                   ENDDO                                                                  /*CAS009*/
                   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                            /*CAS009*/
                         CHGVAR  VAR(&STAT) VALUE('Y')                /*S01189*/
                         CALL    PGM(CB0150) PARM(&CNAM &CSEQ &STAT)  /*S01189*/
             CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)
                      DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))
                   ENDDO                                                                  /*CAS009*/
/**/
                   ENDDO
/**/
             ELSE       CMD(DO)                                       /*099147*/
                                                                      /*119350*/
             CLRPFM     FILE(XMCLONCL)                                /*119350*/
             CLRPFM     FILE(XMCLONCK)                                /*119350*/
                                                                      /*099147*/
/** If*program*failed*copy back files for restart:                      099147*/
/************CPYF       FROMFILE(XMCLONCL) TOFILE(MCLONCL) +          /*119350*/
/*************            MBROPT(*REPLACE)                     /*099147 119350*/
/************CPYF       FROMFILE(XMCLONCK) TOFILE(MCLONCK) +          /*119350*/
/****************         MBROPT(*REPLACE)                     /*099147 119350*/
/*/COPY WNCPYSRC,LEC0605013                                          */
                                                                      /*099147*/
             ENDDO                                                    /*099147*/
                                                                      /*099147*/
/**/
/*/COPY WNCPYSRC,LEC0605012                                           /*S01408*/
                ENDDO
/**/
             ENDDO
/**/
/*   CLEAR LOAMS - COPY NLAMS TO LOAMS - CLEAR NLAMS - RESET IND */
/*   CLEAR CLOAN - COPY CLONS TO CLOAN - CLEAR CLONS - RESET IND */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/***************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/           /*S01189*/
                CHGVAR     VAR(&STAT) VALUE(' ')                      /*S01189*/
                CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
/***************IF         COND(%SUBSTRING(&LESTAT 9 3) *EQ 'NEW') +
 **************************THEN(DO)****/                              /*S01189*/
/**********     IF         COND(&STAT *EQ 'Y') THEN(DO) */                      /*S01189 AR1080825*/
/**********     IF         COND(&STAT *NE 'Y') THEN(DO) */                   /*AR1080825 AR1091292*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)                                /*AR1091292*/
/**/
/*************     CLRPFM     FILE(LOAMSDH)           ***************  *S01098*/
/*************     CLRPFM     FILE(LOAMSDK)           ***************  *S01098*/
/*************     CLRPFM     FILE(LOAMSZ1)           ***************  *S01098*/
/**/
/*************     CLRPFM     FILE(CLOANHH)           ***************  *S01098*/
/*************     CLRPFM     FILE(CLOANCL)           ***************  *S01098*/
/*************     CLRPFM     FILE(CLOANCK)           ***************  *S01098*/
/*************     CLRPFM     FILE(CLOANZ1)           ***************  *S01098*/
/**/                                                                  /*S01098*/
/**********        OVRDBF     FILE(NLAMSDK) SEQONLY(*YES 100)                    /*S01098 AR544189*/
/**********        OVRDBF     FILE(LOAMSDK) SEQONLY(*YES 100)                    /*S01098 AR544189*/
/**********        OVRDBF     FILE(NCLONCL) SEQONLY(*YES 100)                    /*S01098 AR544189*/
/**********        OVRDBF     FILE(NCLONCK) SEQONLY(*YES 100)                    /*S01098 AR544189*/
/**********        OVRDBF     FILE(CLOANCL) SEQONLY(*YES 100)                    /*S01098 AR544189*/
/**********        OVRDBF     FILE(CLOANCK) SEQONLY(*YES 100)                    /*S01098 AR544189*/
                   OVRDBF     FILE(NLAMSQD) SEQONLY(*YES 100)                             /*258399*/
                   OVRDBF     FILE(CLOAMSQD) SEQONLY(*YES 100)                            /*258399*/
/*                                                           */
/*/COPY WNCPYSRC,LEC0605007                                  */       /*S01408*/
/*                                                           */
/**/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)           */         /*CLE134 AR1055617*/
/*   REMOVE LOGICAL FILES OVER PHYSICALS BEFORE COPYING     */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
/**********        RMVM       FILE(LOAMS) MBR(LOAMS)                 */         /*S01098 AR1055617*/
/**********        MONMSG     MSGID(CPF0000)                         */         /*S01098 AR1055617*/
/**/                                                                  /*S01098*/
/**********        RMVM       FILE(CLOAN) MBR(CLOAN)                 */         /*S01098 AR1055617*/
/**********        MONMSG     MSGID(CPF0000)                         */         /*S01098 AR1055617*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
                                                                                          /*CLE134*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)           */         /*CLE134 AR1055617*/
/**********  SCLFMMGR  FILE(LOAMSDH) ACTION(REM)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(LOAMSDK) ACTION(REM)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(LOAMSZ1) ACTION(REM)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANHH) ACTION(REM)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANCL) ACTION(REM)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANCK) ACTION(REM)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANZ1) ACTION(REM)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(LESTALPD) ACTION(REM)                    */         /*AR544189 CCB022B*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
/**/                                                                  /*S01098*/
/* UPDATE PF/LOAMSxx                                                 */
/**/                                                                  /*S01098*/
/**************    CPYF       FROMFILE(NLAMSDH) TOFILE(LOAMSDH) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**********        CPYF       FROMFILE(NLAMSDH) TOFILE(LOAMSDH) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM LOAMSDH)                   */           /*S01098 CCB022B*/
/**/
/**************    CPYF       FROMFILE(NLAMSDK) TOFILE(LOAMSDK) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**************    MONMSG     MSGID(CPF2817)                 ********  *S01098*/
/**********        CPYF       FROMFILE(NLAMSDK) TOFILE(LOAMSDK) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM LOAMSDK)                   */           /*S01098 CCB022B*/
/**/
/**********        CPYF       FROMFILE(NLAMSQD) TOFILE(CLOAMSQD) +   */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*258399 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM CLOAMSQD)                  */           /*258399 CC0220B*/
/**/                                                                                      /*258399*/
/**************    CPYF       FROMFILE(NLAMSZ1) TOFILE(LOAMSZ1) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**********        CPYF       FROMFILE(NLAMSZ1) TOFILE(LOAMSZ1) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM LOAMSZ1)                   */           /*S01098 CCB022B*/
/**/
/* UPDATE PF/CLOANxx                                                 */
/**************    CPYF       FROMFILE(NCLONHH) TOFILE(CLOANHH) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**********        CPYF       FROMFILE(NCLONHH) TOFILE(CLOANHH) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM CLOANHH)                   */           /*S01098 CCB022B*/
/**/
/**************    CPYF       FROMFILE(NCLONCL) TOFILE(CLOANCL) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**************    MONMSG     MSGID(CPF2817)                 ********  *S01098*/
/***LUPCL:*        ALCOBJ     OBJ((CLOANCL *FILE *EXCL)) WAIT(60)    */           /*091793 CCB022B*/
/**********        MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(LUPCL))*/           /*091793 CCB022B*/
/**********        CPYF       FROMFILE(NCLONCL) TOFILE(CLOANCL) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM CLOANCL)                   */           /*S01098 CCB022B*/
/*/COPY WNCPYSRC,LEC0605014                                          */
/**********        DLCOBJ     OBJ((CLOANCL *FILE *EXCL))             */           /*091793 CCB022B*/
/**/
/**************    CPYF       FROMFILE(NCLONCK) TOFILE(CLOANCK) +****   S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/**************    MONMSG     MSGID(CPF2817)                 ********  *S01098*/
/***LUPCK:*        ALCOBJ     OBJ((CLOANCK *FILE *EXCL)) WAIT(60)    */           /*091793 CCB022B*/
/**********        MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(LUPCK))*/           /*091793 CCB022B*/
/**********        CPYF       FROMFILE(NCLONCK) TOFILE(CLOANCK) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM CLOANCK)                   */           /*S01098 CCB022B*/
/**********        DLCOBJ     OBJ((CLOANCK *FILE *EXCL))             */           /*091793 CCB022B*/
/**/
/**************    CPYF       FROMFILE(NCLONZ1) TOFILE(CLOANZ1) +****  *S01098*/
/**************               MBROPT(*ADD) FMTOPT(*NOCHK)    ********  *S01098*/
/***LUPZ1:*        ALCOBJ     OBJ((CLOANZ1 *FILE *EXCL)) WAIT(60)    */           /*091793 CCB022B*/
/**********        MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(LUPZ1))*/           /*091793 CCB022B*/
/**********        CPYF       FROMFILE(NCLONZ1) TOFILE(CLOANZ1) +    */                  /*CCB022B*/
/**********                   MBROPT(*REPLACE) FMTOPT(*NONE)         */           /*S01098 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM CLOANZ1)                   */           /*S01098 CCB022B*/
/**********        DLCOBJ     OBJ((CLOANZ1 *FILE *EXCL))             */           /*091793 CCB022B*/
                                                                      /*S01408*/
/**********     IF         COND(&CLE038 *EQ 'Y') THEN(DO)            */           /*CLE038 CCB022B*/
/***USTAL:*        ALCOBJ     OBJ((LESTALPD *FILE *EXCL)) WAIT(60)   */           /*CLE038 CCB022B*/
/**********        MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(USTAL))*/           /*CLE038 CCB022B*/
/**********  CPYF       FROMFILE(XESTALPD) TOFILE(LESTALPD) +        */                  /*CCB022B*/
/**********               MBROPT(*REPLACE) FMTOPT(*NONE)             */           /*CLE038 CCB022B*/
/**********        MONMSG     (CPF2817) CMPDTA(CPF2869) +            */                  /*CCB022B*/
/**********                   EXEC(CLRPFM LESTALPD)                  */           /*CLE038 CCB022B*/
/**********        DLCOBJ     OBJ((LESTALPD *FILE *EXCL))            */           /*CLE038 CCB022B*/
/**********     ENDDO                                                */           /*CLE038 CCB022B*/
/*/COPY WNCPYSRC,LEC0605002                                           /*S01408*/
             IF         COND(&ULX004 = 'Y') THEN(DO)                                      /*CER001*/
             CPYF       FROMFILE(LECLX1PD) TOFILE(LENCX1PD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CER001*/
             MONMSG     MSGID(CPF2817)                                                    /*CER001*/
             CPYF       FROMFILE(LENCX1J0) TOFILE(LECLX1PD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CER001*/
             MONMSG     MSGID(CPF2817)                                                    /*CER001*/
             ENDDO                                                                        /*CER001*/
                                                                      /*S01408*/
/**/                                                                  /*S01098*/
                   DLTOVR     FILE(NLAMSDK)                           /*S01098*/
                   MONMSG     MSGID(CPF9841)                                              /*CLE134*/
                   DLTOVR     FILE(LOAMSDK)                           /*S01098*/
                   MONMSG     MSGID(CPF9841)                                              /*CLE134*/
                   DLTOVR     FILE(NCLONCL)                           /*S01098*/
                   MONMSG     MSGID(CPF9841)                                              /*CLE134*/
                   DLTOVR     FILE(NCLONCK)                           /*S01098*/
                   MONMSG     MSGID(CPF9841)                                              /*CLE134*/
                   DLTOVR     FILE(CLOANCL)                           /*S01098*/
                   MONMSG     MSGID(CPF9841)                                              /*CLE134*/
                   DLTOVR     FILE(CLOANCK)                           /*S01098*/
                   MONMSG     MSGID(CPF9841)                                              /*CLE134*/
                   DLTOVR     FILE(NLAMSQD)                                               /*258399*/
                   DLTOVR     FILE(CLOAMSQD)                                              /*258399*/
/*/COPY WNCPYSRC,LEC0605016                                          */
/**/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)           */         /*CLE134 AR1055617*/
/***************** ADDLFM     FILE(LOAMS) MBR(LOAMS) */    /*S01098*/ /*BHF982*/
/**********        ADDLFM     FILE(LOAMS) MBR(LOAMS) SHARE(*YES)     */         /*BHF982 AR1055617*/
/**********        MONMSG     MSGID(CPF0000)                         */         /*S01098 AR1055617*/
/***************** ADDLFM     FILE(CLOAN) MBR(CLOAN) */    /*S01098*/ /*BHF982*/
/**********        ADDLFM     FILE(CLOAN) MBR(CLOAN) SHARE(*YES)     */         /*BHF982 AR1055617*/
/**********        MONMSG     MSGID(CPF0000)                         */         /*S01098 AR1055617*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
                                                                                          /*CLE134*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)           */         /*CLE134 AR1055617*/
/**********  SCLFMMGR  FILE(LOAMSDH) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(LOAMSDK) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(LOAMSZ1) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANHH) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANCL) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANCK) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(CLOANZ1) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(LESTALPD) ACTION(ADD)                    */         /*AR544189 CCB022B*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
                                                                      /*S10227*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LEC0605005                                           /*S01408*/
                                                                      /*S01408*/
/*  NEW FILES FOR HISTORY RETENTION SAR                       *S10227* *099147*/
/***************** OVRDBF     FILE(MCLONCL) SEQONLY(*YES 100) *S10227 /*099147*/
/***************** OVRDBF     FILE(MCLONCK) SEQONLY(*YES 100) *S10227 /*099147*/
/***************** OVRDBF     FILE(XMCLONCL) SEQONLY(*YES 100)*S10227 /*099147*/
/***************** OVRDBF     FILE(XMCLONCK) SEQONLY(*YES 100)*S10227 /*099147*/
/***************** RMVM       FILE(MLOAN) MBR(MLOAN)          *S10227 /*099147*/
/***************** MONMSG     MSGID(CPF0000)                  *S10227 /*099147*/
/*****************                                            *S10227 /*099147*/
                   OVRDBF     FILE(MCLONCL) SEQONLY(*YES 100)         /*119350*/
                   OVRDBF     FILE(MCLONCK) SEQONLY(*YES 100)         /*119350*/
                   OVRDBF     FILE(XMCLONCL) SEQONLY(*YES 100)        /*119350*/
                   OVRDBF     FILE(XMCLONCK) SEQONLY(*YES 100)        /*119350*/
/*/COPY WNCPYSRC,LEC0605017                                          */
/**********        RMVM       FILE(MLOAN) MBR(MLOAN)                 */         /*119350 AR1055617*/
/**********        MONMSG     MSGID(CPF0000)                         */         /*119350 AR1055617*/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)           */         /*CLE134 AR1055617*/
/**********  SCLFMMGR  FILE(MCLONCL) ACTION(REM)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(MCLONCK) ACTION(REM)                     */         /*AR544189 CCB022B*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
/*****************                                           */
/*****************                                           */
/*/COPY WNCPYSRC,LEC0605008                                  */       /*S01408*/
/*****************                                           */       /*099147*/
/***************** CPYF       FROMFILE(XMCLONCL) TOFILE(MCLONCL) +    /*099147*/
/*****************            MBROPT(*ADD) FMTOPT(*NONE)     /*S10227 /*099147*/
/***************** CPYF       FROMFILE(XMCLONCK) TOFILE(MCLONCK) +
/*****************            MBROPT(*ADD) FMTOPT(*NONE)     /*S10227 /*099147*/
/*****************                                           /*S10227 /*099147*/
/***************** DLTOVR     FILE(MCLONCL)                  /*S10227 /*099147*/
/***************** DLTOVR     FILE(MCLONCK)                  /*S10227 /*099147*/
/***************** DLTOVR     FILE(XMCLONCL)                 /*S10227 /*099147*/
/***************** DLTOVR     FILE(XMCLONCK)                 /*S10227 /*099147*/
/*****************                                           /*S01408 /*099147*/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)           */           /*CLE134 CCB022B*/
/**********        CPYF       FROMFILE(XMCLONCL) TOFILE(MCLONCL) +   */                  /*CCB022B*/
/**********                   MBROPT(*ADD) FMTOPT(*NONE)             */           /*119350 CCB022B*/
/**********        CPYF       FROMFILE(XMCLONCK) TOFILE(MCLONCK) +   */                  /*CCB022B*/
/**********                   MBROPT(*ADD) FMTOPT(*NONE)             */           /*119350 CCB022B*/
/**********  ENDDO                                                   */           /*CLE134 CCB022B*/
/*/COPY WNCPYSRC,LEC0605018                                          */
                                                                      /*119350*/
                   DLTOVR     FILE(MCLONCL)                           /*119350*/
                   DLTOVR     FILE(MCLONCK)                           /*119350*/
                   DLTOVR     FILE(XMCLONCL)                          /*119350*/
                   DLTOVR     FILE(XMCLONCK)                          /*119350*/
/*/COPY WNCPYSRC,LEC0605004                                           /*S01408*/
/*****************                                             /*S01408 099147*/
/***************** ADDLFM     FILE(MLOAN) MBR(MLOAN)           /*S10227 099147*/
/***************** MONMSG     MSGID(CPF0000)                   /*S10227 099147*/
/**********  IF         COND(&RERUN *EQ '      ') THEN(DO)           */         /*CLE134 AR1055617*/
/**********        ADDLFM     FILE(MLOAN) MBR(MLOAN)                 */         /*119350 AR1055617*/
/**********        MONMSG     MSGID(CPF0000)                         */         /*119350 AR1055617*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
/**********  IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)           */         /*CLE134 AR1055617*/
/**********  SCLFMMGR  FILE(MCLONCL) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  SCLFMMGR  FILE(MCLONCK) ACTION(ADD)                     */         /*AR544189 CCB022B*/
/**********  ENDDO                                                   */         /*CLE134 AR1055617*/
                                                               /*S10227 099147*/
/* UPDATE P/MFU IND.                                                 */
/******************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
/******************RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)*/        /*S01189*/
/******************CHGVAR     VAR(%SUBSTRING(&LESTAT 9 3)) +
 *****************************VALUE('OLD')****/                       /*S01189*/
/************CHGDTAARA  DTAARA(LESTAT) VALUE(&LESTAT)*/               /*S01189*/
/******************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))*/         /*S01189*/
                   CHGVAR  VAR(&STAT) VALUE('N')                      /*S01189*/
                   CALL    PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
/**/
/**********        CLRPFM     FILE(NLAMSDH)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(NLAMSDK)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(NLAMSZ1)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(NLAMSQD)                          */           /*258399 CCB022B*/
/**/
                   CLRPFM     FILE(LAUPDDH)
                   CLRPFM     FILE(LAUPDDK)
                   CLRPFM     FILE(LAUPDZ1)
/**/
/**********        CLRPFM     FILE(NCLONHH)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(NCLONCL)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(NCLONCK)                          */                  /*CCB022B*/
/**********        CLRPFM     FILE(NCLONZ1)                          */                  /*CCB022B*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,LEC0605003                                           /*S01408*/
             IF         COND(&ULX004 = 'Y') THEN(DO)                                      /*CER001*/
                   CLRPFM     FILE(LENCX1PD)                                              /*CER001*/
             ENDDO                                                                        /*CER001*/
                                                                      /*S01408*/
/**/
                   CLRPFM     FILE(LOUPDHH)
                   CLRPFM     FILE(LOUPDCL)
                   CLRPFM     FILE(LOUPDCK)
                   CLRPFM     FILE(LOUPDZ1)
/**/
                   CLRPFM     FILE(PTSLDHH) /*  CREATED IN LEC0604  */
                   CLRPFM     FILE(PTSLDPT)
                   CLRPFM     FILE(PTSLDZX)
                                                                      /*S10227*/
/**********        CLRPFM     FILE(XMCLONCL)                         */           /*S10227 CCB022B*/
/**********        CLRPFM     FILE(XMCLONCK)                         */           /*S10227 CCB022B*/
/**/
/*                                                           */
/*/COPY WNCPYSRC,LEC0605009                                  */       /*S01408*/
/*                                                           */
                ENDDO
/**/
             ENDDO
/*/COPY WNCPYSRC,LEC0605020                                          */
             GOTO       CMDLBL(ENDPGM)                                /*091793*/
ABNOR:       SNDPGMMSG  MSG('LEC0605 ended abnormally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*091793*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*091793*/
             CHGJOB     SWS(XXXXXX11)                                 /*105061*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:      ENDPGM
