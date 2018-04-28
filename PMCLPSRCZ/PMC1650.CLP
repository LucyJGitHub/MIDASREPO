/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Calculate Performance Totals')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1650 - Calculate Performance Totals                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. CPM004             DATE 07FEB96              */
/*       PREV AMEND NO. S01408             DATE 05MAY95              */
/*                      S01486             DATE 11AUG94              */
/*                      049421             DATE 18JAN93              */
/*                      S01313             DATE 07APR92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CPM004 - Bank Portfolios                                    */
/*       S01408 - Addition of core hook PMC1650MP1                   */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01313 - PROGRAM WRITTEN FOR PORTFOLIO PERFORMANCE          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&FMLIB) TYPE(*CHAR) LEN(10)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1650 - Calculate Performance +
                          Totals') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* FORMAT 'TO LIBRARY NAME' FOR BACKUP COPIES  */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
/*********** CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DLIB')       */ /*S01486*/
             CHGVAR     VAR(&FMLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01486*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,PMC1650MP1                                          */
                                                                      /*S01408*/
 
/**COPY*EMPTY*FILES TO LIB/QTEMP */                                   /*CPM004*/
/*********** CPYF       FROMFILE(&FMLIB/PMPSPOPP) +                */ /*S01486*/
/***********              TOFILE(QTEMP/PMPSPOPP) MBROPT(*REPLACE) +*/ /*S01486*/
/***********              CRTFILE(*YES)                            */ /*S01486*/
/*********** CPYF       FROMFILE(&FMLIB/PMPSPOQ0) +                   /*CPM004*/
/***********              TOFILE(QTEMP/PMPSPOQ0) MBROPT(*REPLACE) +   /*CPM004*/
/***********              CRTFILE(*YES)                       S01486  /*CPM004*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSPOPP)) */ /*S01486*/
/*********** MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSPOS01486  /*CPM004*/
/* */                                                                 /*CPM004*/
/* CLEAR WORKFILE */                                                  /*CPM004*/
/* */                                                                 /*CPM004*/
             CLRPFM     FILE(PMPSPOQ0)                                /*CPM004*/
 
/* SUM ALL RECORDS FOR SAME CUSTOMER, PORTFOLIO, PERFORMANCE */
/* CATEGORY, PERFORMANCE SUB CATEGORY AND PERFORMANCE PERIOD */
/*********** OPNQRYF    FILE((PMPIMTPP)) FORMAT(PMPSPOPP) +        */ /*S01486*/
/***********             QRYSLT('QTPFMC *EQ "CI " *AND QTCPTC *EQ +*/ /*S01486*/
/***********             "Y" *OR QTPFMC *EQ "CO " *AND QTCPTC *EQ +*/ /*S01486*/
/***********             "Y" *OR QTPFMC *EQ "CX " *AND QTCPTC *EQ +*/ /*S01486*/
/***********              "Y" *OR QTPFMC *EQ "VE " *OR QTPFMC *EQ +*/ /*S01486*/
/***********            "VS " *OR QTPFMC *EQ "VP " *OR QTPFMC *EQ +*/ /*S01486*/
/***********            "TR " *OR QTPFMC *EQ "TU " *OR QTPFMC *EQ +*/ /*S01486*/
/***********            "DV " *OR QTPFMC *EQ "IER" *OR QTPFMC *EQ +*/ /*S01486*/
/***********            "IEU" *OR QTPFMC *EQ "XIR" *OR QTPFMC *EQ +*/ /*S01486*/
/***********            "XIU" *OR QTPFMC *EQ "XTR" *OR QTPFMC *EQ +*/ /*S01486*/
/***********            "XTU" *OR QTPFMC *EQ "F  " *OR QTPFMC *EQ +*/ /*S01486*/
/***********            "T  " *OR QTPFMC *EQ "OT " *OR QTPFMC *eq +*/ /*S01486*/
/***********              "C  " *OR QTPFMC *EQ "ADJ"') +           */ /*S01486*/
/***********              GRPFLD(QTCNUM QTPTFR QTPFMC QTPFMS +     */ /*S01486*/
/***********              QTPFMP) MAPFLD((QVCNUM QTCNUM) (QVPTFR + */ /*S01486*/
/***********              QTPTFR) (QVPFMC QTPFMC) (QVPFMS QTPFMS) +*/ /*S01486*/
/***********              (QVPFMP QTPFMP) (QVPFMA '%SUM(QTPFMA)')) */ /*S01486*/
             OPNQRYF    FILE((PMPIMTPD)) FORMAT(PMPSPOQ0) +
                          QRYSLT('QTPFMC *EQ "CI " *AND QTCPTC *EQ +
                          "Y" *OR QTPFMC *EQ "CO " *AND QTCPTC *EQ +
                          "Y" *OR QTPFMC *EQ "CX " *AND QTCPTC *EQ +
                          "Y" *OR QTPFMC *EQ "VE " *OR QTPFMC *EQ +
                          "VS " *OR QTPFMC *EQ "VP " *OR QTPFMC *EQ +
                          "TR " *OR QTPFMC *EQ "TU " *OR QTPFMC *EQ +
                          "DV " *OR QTPFMC *EQ "IER" *OR QTPFMC *EQ +
                          "IEU" *OR QTPFMC *EQ "XIR" *OR QTPFMC *EQ +
                          "XIU" *OR QTPFMC *EQ "XTR" *OR QTPFMC *EQ +
                          "XTU" *OR QTPFMC *EQ "F  " *OR QTPFMC *EQ +
                          "T  " *OR QTPFMC *EQ "OT " *OR QTPFMC *eq +
                          "C  " *OR QTPFMC *EQ "ADJ"') +
                          GRPFLD(QTCNUM QTPTFR QTPFMC QTPFMS +
                          QTPFMP) MAPFLD((QVCNUM QTCNUM) (QVPTFR +
                          QTPTFR) (QVPFMC QTPFMC) (QVPFMS QTPFMS) +
                          (QVPFMP QTPFMP) (QVPFMA '%SUM(QTPFMA)'))    /*S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMPIMTPP) TOFILE(PMPSPOPP) +     */ /*S01486*/
/***********              MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMPIMTPD) TOFILE(PMPSPOQ0) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
/*********** CLOF       OPNID(PMPIMTPP)                            */ /*S01486*/
             CLOF       OPNID(PMPIMTPD)                               /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
