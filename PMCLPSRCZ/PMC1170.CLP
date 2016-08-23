/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Portfolio due Valuation Statement')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1170 - Portfolio Due Valuation Statement                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CPM005             Date 29Jul96              */
/*       Prev Amend No. 095867             Date 08Nov95              */
/*                      CCG009             Date 01Jun95              */
/*                      S01408             DATE 05MAY95              */
/*                      085852             DATE 14MAR95              */
/*                      080733             DATE 22DEC94              */
/*                      053103             DATE 23NOV94              */
/*                      072242             DATE 23NOV94              */
/*                      S01486             DATE 11AUG94              */
/*                      049421             DATE 18JAN93              */
/*                      S01313             DATE 18JAN93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*                Just Recompiled because of PM File(s) changes      */
/*       095867 - Can have all account officers and selected cust.   */
/*       CCG009 - Private Banking UDC                                */
/*       S01408 - Addition of core hook PMC1170MPS                   */
/*       085852 - Rename SDACCSQ1 to PMACCSQ1                        */
/*       080733 - Wrong file used                                    */
/*       053103 - Portfolio Management Reconciliation Report.        */
/*       072242 - Select correct Portfolios for Reconciliation.      */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - PROGRAM WRITTEN FOR PORTFOLIO PERFORMANCE          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*         PGM        PARM(&WWDPCD &WWACOC &WWPMNG &WWMODE &WWTNLA +*//* 53103*/
/*                        &WWSCBR &WWPFMR)                          *//* 53103*/
             PGM        PARM(&WWDPCD &WWACOC &WWPMNG &WWMODE &WWTNLA +
                          &WWSCBR &WWPFMR &WWCNUM &WWPTFR)            /* 53103*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&WWDPCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWACOC) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWPMNG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWTNLA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WWSCBR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWPFMR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DAEC2) TYPE(*CHAR) LEN(5) VALUE('00000')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WWCNUM) TYPE(*CHAR) LEN(6)               /* 53103*/
             DCL        VAR(&WWPTFR) TYPE(*CHAR) LEN(4)               /* 53103*/
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*********** CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1170MPS                                          */
                                                                      /*S01408*/
 
/* SAVE EVENT CONTROL DATE AS DATE EXTRACT LAST RUN                  */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
 
                                                                      /*CCG009*/
/*  CLEAR FILES WRITTEN TO BY PM1170                                  /*CCG009*/
                                                                      /*CCG009*/
             CLRPFM     FILE(PMPTDVPD)                                /*CCG009*/
             CLRPFM     FILE(PMUNQVPD)                                /*CCG009*/
                                                                      /*CCG009*/
/**CREATE*WORKFILE*PF/PMPTDVPP*IN*QTEMP*****************************/ /*S01486*/
/* CREATE WORKFILE PF/PMPTDVPD IN QTEMP */                            /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMPTDVPP) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMPTDVPP) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMPTDVPD) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMPTDVPD) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPTDVPP)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPTDVPS01486 /*CCG009*/
 
/**CREATE*WORKFILE*PF/PMPTDVPP*IN*QTEMP*****************************/ /*S01486*/
/* CREATE WORKFILE PF/PMPTDVPD IN QTEMP */                            /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMUNQVPP) +                */ /*S01486*/
/**********               TOFILE(QTEMP/PMUNQVPP) MBROPT(*REPLACE) +*/ /*S01486*/
/**********               CRTFILE(*YES)                            */ /*S01486*/
/**********  CPYF       FROMFILE(&FMLIB/PMUNQVPD) +                   /*CCG009*/
/**********               TOFILE(QTEMP/PMUNQVPD) MBROPT(*REPLACE) +   /*CCG009*/
/**********               CRTFILE(*YES)                        S01486 /*CCG009*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMUNQVPP)) */ /*S01486*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMUNQV*S01486 /*CCG009*/
 
/**********  OVRDBF     FILE(PMPTDVXX) TOFILE(PMPTDVPP) SHARE(*NO) */ /*S01486*/
             OVRDBF     FILE(PMPTDVXX) TOFILE(PMPTDVPD) SHARE(*NO)    /*S01486*/
 
/* IF MODE 'C' (COB PROCESSING) OPNQRYF'S SELECTING CUSTOMERS AND */
/* PORTFOLIOS WITH NEXT VALUATION DATE *LE ECD OR PORTFOLIOS WITH */
/* INVESTMENT POLICIES ATTACHED                                   */
             IF         COND(&WWMODE *EQ 'C') THEN(DO)
             OVRDBF     FILE(SDPLCSPD) SHARE(*YES)
/**********  OVRDBF     FILE(PMPORTPP) SHARE(*YES)                 */ /*S01486*/
             OVRDBF     FILE(PMPORTPD) SHARE(*YES)                    /*S01486*/
/**********  OVRDBF     FILE(PMRQXSPP) SHARE(*YES)                 */ /*S01486*/
             OVRDBF     FILE(PMRQXSPD) SHARE(*YES)                    /*S01486*/
             OPNQRYF    FILE((*LIBL/SDPLCSPD)) OPTION(*ALL) +
                          FORMAT(SDPLCSPD) QRYSLT('QBVLNA *LE "' +
                          *CAT &DAECD *CAT '" *AND QBVLNA *GT "' +
                          *CAT &DAEC2 *CAT '" *AND QBRECI *EQ "D"') +
                          MAPFLD((QBVLN1 QBVLND *ZONED 5 0) (QBVLNA +
                          QBVLN1 *CHAR 5))
 
/**********  OPNQRYF    FILE((*LIBL/PMPORTPP)) OPTION(*ALL) +      */ /*S01486*/
/**********               FORMAT(PMPORTPP) QRYSLT('PNVLNA *LE "' + */ /*S01486*/
/**********               *CAT &DAECD *CAT '" *AND PNVLNA *GT "' + */ /*S01486*/
/**********               *CAT &DAEC2 *CAT '" *AND PNRECI *EQ "D" +*/ /*S01486*/
/**********               *OR PNPOLC *NE "  " *AND PNRECI *EQ "D" +*/ /*S01486*/
/**********               *OR PNCYIN *EQ "Y" *AND PNRECI *EQ "D" + */ /*S01486*/
/**********               *OR PNYPIN *EQ "Y" *AND PNRECI *EQ "D" + */ /*S01486*/
/**********               *OR PNNPIN *EQ "Y" *AND PNRECI *EQ "D"')+*/ /*S01486*/
/**********             MAPFLD((PNVLN1 PNVLND *ZONED 5 0) (PNVLNA +*/ /*S01486*/
/**********               PNVLN1 *CHAR 5))                         */ /*S01486*/
             OPNQRYF    FILE((*LIBL/PMPORTPD)) OPTION(*ALL) +
                          FORMAT(PMPORTPD) QRYSLT('PNVLNA *LE "' +
                          *CAT &DAECD *CAT '" *AND PNVLNA *GT "' +
                          *CAT &DAEC2 *CAT '" *AND PNRECI *EQ "D" +
                          *OR PNPOLC *NE "  " *AND PNRECI *EQ "D" +
                          *OR PNCYIN *EQ "Y" *AND PNRECI *EQ "D" +
                          *OR PNYPIN *EQ "Y" *AND PNRECI *EQ "D" +
                          *OR PNNPIN *EQ "Y" *AND PNRECI *EQ "D"') +
                          MAPFLD((PNVLN1 PNVLND *ZONED 5 0) (PNVLNA +
                          PNVLN1 *CHAR 5))                            /*S01486*/
 
/**********  OPNQRYF    FILE((*LIBL/PMRQXSPP)) OPTION(*ALL) +      */ /*S01486*/
/**********               FORMAT(PMRQXSPP) QRYSLT('QOVLOA *LE "' + */ /*S01486*/
/**********               *CAT &DAECD *CAT '" *AND QOVLOA *GT "' + */ /*S01486*/
/**********               *CAT &DAEC2 *CAT '"') MAPFLD((QOVLO1 +   */ /*S01486*/
/**********             QOVLOR *ZONED 5 0) (QOVLOA QOVLO1 *CHAR 5))*/ /*S01486*/
             OPNQRYF    FILE((*LIBL/PMRQXSPD)) OPTION(*ALL) +
                          FORMAT(PMRQXSPD) QRYSLT('QOVLOA *LE "' +
                          *CAT &DAECD *CAT '" *AND QOVLOA *GT "' +
                          *CAT &DAEC2 *CAT '"') MAPFLD((QOVLO1 +
                          QOVLOR *ZONED 5 0) (QOVLOA QOVLO1 *CHAR 5)) /*S01486*/
             ENDDO
 
/**IF*MODE*'I'*(INPUT*CYCLE)*OPNQRYF*BASED*ON*PMRQXSPP*SELECTING****/ /*S01486*/
/* IF MODE 'I' (INPUT CYCLE) OPNQRYF BASED ON PMRQXSPD SELECTING   */ /*S01486*/
/* RECORDS INPUT IN CURRENT REQUEST AND WHEN PRODUCED *EQ 'C'     */
             IF         COND(&WWMODE *EQ 'I') THEN(DO)
/**********  OVRDBF     FILE(PMRQXSPP) SHARE(*YES)                 */ /*S01486*/
             OVRDBF     FILE(PMRQXSPD) SHARE(*YES)                    /*S01486*/
/**********  OPNQRYF    FILE((*LIBL/PMRQXSPP)) OPTION(*ALL) +      */ /*S01486*/
/**********               FORMAT(PMRQXSPP) QRYSLT('QOTNLA *EQ "' + */ /*S01486*/
/**********              *CAT &WWTNLA *CAT '" *AND QOWHEN *EQ "I"')*/ /*S01486*/
             OPNQRYF    FILE((*LIBL/PMRQXSPD)) OPTION(*ALL) +
                          FORMAT(PMRQXSPD) QRYSLT('QOTNLA *EQ "' +
                          *CAT &WWTNLA *CAT '" *AND QOWHEN *EQ "I"')  /*S01486*/
             ENDDO
 
/* IF MODE 'R' (REPORT) OPNQRYF SELECTING PORTFOLIOS WITH PERFORMANCE*/
             IF         COND(&WWMODE *EQ 'R') THEN(DO)
 
             CHGJOB     SWS(1XXXXXXX)
/*********** OVRDBF     FILE(SDCUSTQ1) TOFILE(SDDEPTPD) SHARE(*YES)   /*080733*/
             OVRDBF     FILE(PMCUSTQ1) TOFILE(SDDEPTPD) SHARE(*YES)   /*080733*/
 
/* SELECT ALL RECORDS */
/*********** IF         COND(&WWDPCD *EQ '*ALL') THEN(DO)          */ /*S01486*/
             IF         COND(&WWDPCD *EQ '*ALL' *OR &WWACOC *EQ +
                          '*ALL') THEN(DO)                            /*S01486*/
/**********  OPNQRYF    FILE((SDDEPTPD) (SDACOFPD) (SDCUSTPD) +    */ /*S01486*/
/**********               (PMPORTPP)) FORMAT(SDCUSTQ1) +           */ /*S01486*/
/**********             QRYSLT('PNRECI *EQ "D" *AND PNPSDA *LT "' +*/ /*S01486*/
/**********               *CAT &DAECD *CAT '"') +                  */ /*S01486*/
/**********               JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) + */ /*S01486*/
/**********               (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +      */ /*S01486*/
/**********               (*MAPFLD/BBCUSN PMPORTPP/PNCNUM)) +      */ /*S01486*/
/**********               MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +*/ /*S01486*/
/**********               PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))*/ /*S01486*/
/*********** OPNQRYF    FILE((SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMPORTPD)) FORMAT(SDCUSTQ1) +
                          QRYSLT('PNRECI *EQ "D" *AND PNPSDA *LT "' +
                          *CAT &DAECD *CAT '"') +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                    PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))  /*S01486 080733*/
             OPNQRYF    FILE((SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMPORTPD)) FORMAT(PMCUSTQ1) +
                          QRYSLT('PNRECI *EQ "D" *AND PNPSDA *LT "' +
                          *CAT &DAECD *CAT '"') +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                          PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))   /*080733*/
             ENDDO
 
/* SELECT ALL RECORDS FOR DEFINED DEPARTMENT */
/*********** IF         COND(&WWDPCD *NE '*ALL' *AND &WWACOC *EQ + */ /*S01486*/
/***********              '*ALL') THEN(DO)                         */ /*S01486*/
             IF         COND(&WWDPCD *NE '*ALL' *AND &WWACOC *EQ +
                          '    ') THEN(DO)                            /*S01486*/
/**********  OPNQRYF    FILE((SDDEPTPD) (SDACOFPD) (SDCUSTPD) +    */ /*S01486*/
/**********               (PMPORTPP)) FORMAT(SDCUSTQ1) +           */ /*S01486*/
/**********             QRYSLT('PNRECI *EQ "D" *AND PNPSDA *LT "' +*/ /*S01486*/
/**********               *CAT &DAECD *CAT '" *AND AEDPCD *EQ "' + */ /*S01486*/
/**********               *CAT &WWDPCD *CAT '"') +                 */ /*S01486*/
/**********               JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) + */ /*S01486*/
/**********               (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +      */ /*S01486*/
/**********               (*MAPFLD/BBCUSN PMPORTPP/PNCNUM)) +      */ /*S01486*/
/**********               MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +*/ /*S01486*/
/**********               PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))*/ /*S01486*/
/*********** OPNQRYF    FILE((SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMPORTPD)) FORMAT(SDCUSTQ1) +
                          QRYSLT('PNRECI *EQ "D" *AND PNPSDA *LT "' +
                          *CAT &DAECD *CAT '" *AND AEDPCD *EQ "' +
                          *CAT &WWDPCD *CAT '"') +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                  PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))   /*S01486 080733*/
             OPNQRYF    FILE((SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMPORTPD)) FORMAT(PMCUSTQ1) +
                          QRYSLT('PNRECI *EQ "D" *AND PNPSDA *LT "' +
                          *CAT &DAECD *CAT '" *AND AEDPCD *EQ "' +
                          *CAT &WWDPCD *CAT '"') +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                          PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))   /*080733*/
             ENDDO
 
/* SELECT ALL RECORDS FOR DEFINED ACCOUNT OFFICER */
/*********** IF         COND(&WWACOC *NE '*ALL') THEN(DO)          */ /*S01486*/
             IF         COND(&WWACOC *NE '*ALL' *AND &WWDPCD *EQ +
                          '    ') THEN(DO)                            /*S01486*/
/**********  OPNQRYF    FILE((SDDEPTPD) (SDACOFPD) (SDCUSTPD) +    */ /*S01486*/
/**********               (PMPORTPP)) FORMAT(SDCUSTQ1) +           */ /*S01486*/
/**********             QRYSLT('PNRECI *EQ "D" *AND PNPSDA *LT "' +*/ /*S01486*/
/**********               *CAT &DAECD *CAT '" *AND AZACOC *EQ "' + */ /*S01486*/
/**********               *CAT &WWACOC *CAT '"') +                 */ /*S01486*/
/**********               JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) + */ /*S01486*/
/**********               (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +      */ /*S01486*/
/**********               (*MAPFLD/BBCUSN PMPORTPP/PNCNUM)) +      */ /*S01486*/
/**********               MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +*/ /*S01486*/
/**********               PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))*/ /*S01486*/
/*********** OPNQRYF    FILE((SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMPORTPD)) FORMAT(SDCUSTQ1) +
                          QRYSLT('PNRECI *EQ "D" *AND PNPSDA *LT "' +
                          *CAT &DAECD *CAT '" *AND AZACOC *EQ "' +
                          *CAT &WWACOC *CAT '"') +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                   PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))   /*S01486 080733*/
             OPNQRYF    FILE((SDDEPTPD) (SDACOFPD) (SDCUSTPD) +
                          (PMPORTPD)) FORMAT(PMCUSTQ1) +
                          QRYSLT('PNRECI *EQ "D" *AND PNPSDA *LT "' +
                          *CAT &DAECD *CAT '" *AND AZACOC *EQ "' +
                          *CAT &WWACOC *CAT '"') +
                          JFLD((SDDEPTPD/AEDPCD SDACOFPD/AZDPCD) +
                          (SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                          PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))   /*080733*/
             ENDDO
             ENDDO
/* IF MODE 'D' (RECONCILIATION REPORTING)                          */ /* 53103*/
             IF         COND(&WWMODE *EQ 'D') THEN(DO)                /* 53103*/
                                                                      /* 53103*/
/************OVRDBF FILE(SDACCSQ1) TOFILE(SDACOFPD) SHARE(*YES)*53103* *085852*/
             OVRDBF     FILE(PMACCSQ1) TOFILE(SDACOFPD) SHARE(*YES)   /*085852*/
                                                                      /* 53103*/
/* SELECT ALL RECORDS */                                              /* 53103*/
/************IF         COND(&WWACOC *EQ '*ALL') THEN(DO)    /* 72242* *095867*/
             IF         COND(&WWACOC *EQ '*ALL' *AND &WWCNUM *EQ +
                          '*ALL  ' *AND &WWPTFR *EQ '*ALL') THEN(DO)  /*095867*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +     * *085852*/
/************             FORMAT(SDACCSQ1) QRYSLT('PNRECI *EQ "D" +  * *085852*/
/************             *AND PNPSDA *LT "' *CAT &DAECD *CAT '"') + * *085852*/
/************             JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +   * *085852*/
/************             (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +        * *085852*/
/************             MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +  * *085852*/
/************        PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6)) *53103* *085852*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMACCSQ1) QRYSLT('PNRECI *EQ "D" +
                          *AND PNPSDA *LT "' *CAT &DAECD *CAT '"') +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                          PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))   /*085852*/
             ENDDO                                                    /* 53103*/
/**/
/* SELECT ALL RECORDS FOR DEFINED ACCOUNT OFFICER                        72242*/
             IF         COND(&WWACOC *NE '*ALL' *AND &WWCNUM *EQ +
                          '*ALL  ') THEN(DO)                           /*72242*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +     * *085852*/
/************             FORMAT(SDACCSQ1) QRYSLT('PNRECI *EQ "D" +  * *085852*/
/************             *AND PNPSDA *LT "' *CAT &DAECD *CAT '" +   * *085852*/
/************             *AND AZACOC *EQ "' *CAT &WWACOC *CAT '"') +* *085852*/
/************             JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +   * *085852*/
/************             (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +        * *085852*/
/************             MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +  * *085852*/
/************        PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6)) *72242* *085852*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMACCSQ1) QRYSLT('PNRECI *EQ "D" +
                          *AND PNPSDA *LT "' *CAT &DAECD *CAT '" +
                          *AND AZACOC *EQ "' *CAT &WWACOC *CAT '"') +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                          PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))   /*085852*/
             ENDDO                                                    /* 72242*/
                                                                      /* 53103*/
/* SELECT ALL RECORDS FOR DEFINED CUSTOMER */                         /* 53103*/
             IF         COND(&WWCNUM *NE '*ALL  ' *AND &WWPTFR *EQ +
                          '*ALL') THEN(DO)                            /* 53103*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +     * *085852*/
/************             FORMAT(SDACCSQ1) QRYSLT('PNRECI *EQ "D" +  * *085852*/
/************             *AND PNPSDA *LT "' *CAT &DAECD *CAT '" +   * *085852*/
/************             *AND BBCUST *EQ "' *CAT &WWCNUM *CAT '"') +* *085852*/
/************             JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +   * *085852*/
/************             (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +        * *085852*/
/************             MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +  * *085852*/
/************        PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6)) *53103* *085852*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMACCSQ1) QRYSLT('PNRECI *EQ "D" +
                          *AND PNPSDA *LT "' *CAT &DAECD *CAT '" +
                          *AND BBCUST *EQ "' *CAT &WWCNUM *CAT '"') +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                          PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))   /*085852*/
             ENDDO                                                    /* 53103*/
                                                                      /* 53103*/
/* SELECT ALL RECORDS FOR DEFINED CUSTOMER AND PORTFOLIO */           /* 53103*/
             IF         COND(&WWPTFR *NE '*ALL') THEN(DO)             /* 53103*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +     * *085852*/
/************             FORMAT(SDACCSQ1) QRYSLT('PNRECI *EQ "D" +  * *085852*/
/************             *AND PNPSDA *LT "' *CAT &DAECD *CAT '" +   * *085852*/
/************             *AND BBCUST *EQ "' *CAT &WWCNUM *CAT '" +  * *085852*/
/************             *AND PNPTFR *EQ "' *CAT &WWPTFR *CAT '"') +* *085852*/
/************             JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +   * *085852*/
/************             (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +        * *085852*/
/************             MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +  * *085852*/
/************        PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6)) *53103* *085852*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMACCSQ1) QRYSLT('PNRECI *EQ "D" +
                          *AND PNPSDA *LT "' *CAT &DAECD *CAT '" +
                          *AND BBCUST *EQ "' *CAT &WWCNUM *CAT '" +
                          *AND PNPTFR *EQ "' *CAT &WWPTFR *CAT '"') +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (*MAPFLD/BBCUSN PMPORTPD/PNCNUM)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5) (PNPSDA +
                          PNPSD1 *CHAR 5) (BBCUSN BBCUST *ZONED 6))   /*085852*/
             ENDDO                                                    /* 53103*/
             ENDDO                                                    /* 53103*/
 
/**CALL*PROGRAM*PM1170*TO*SET*UP*PF/PMPTDVPP************************/ /*S01486*/
/* CALL PROGRAM PM1170 TO SET UP PF/PMPTDVPD */                       /*S01486*/
             CALL       PGM(PM1170) PARM(&WWDPCD &WWACOC &WWMODE +
                          &WWPMNG &WWSCBR &WWPFMR)
 
/* CLOSE FILES OPENED ABOVE */
             DLTOVR     FILE(*ALL)
 
             IF         COND(&WWMODE *EQ 'C') THEN(DO)
             CLOF       OPNID(SDPLCSPD)
/**********  CLOF       OPNID(PMPORTPP)                            */ /*S01486*/
             CLOF       OPNID(PMPORTPD)                               /*S01486*/
/**********  CLOF       OPNID(PMRQXSPP)                            */ /*S01486*/
             CLOF       OPNID(PMRQXSPD)                               /*S01486*/
             ENDDO
 
             IF         COND(&WWMODE *EQ 'I') THEN(DO)
/**********  CLOF       OPNID(PMRQXSPP)                            */ /*S01486*/
             CLOF       OPNID(PMRQXSPD)                               /*S01486*/
             ENDDO
 
             IF         COND(&WWMODE *EQ 'R') THEN(DO)
             CLOF       OPNID(SDDEPTPD)
             ENDDO
             IF         COND(&WWMODE *EQ 'D') THEN(DO)                /* 53103*/
             CLOF       OPNID(SDACOFPD)                               /* 53103*/
             ENDDO                                                    /* 53103*/
 
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
