/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ML Multi-language support initiation')          */
/*********************************************************************/
/*                                                                   */
/*      Midas - Multiple Language Support Module                     */
/*                                                                   */
/*      MLC0000 - Multiple Language Support Initiation.              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CPK030             Date 11Apr14              */
/*       Prev Amend No. MD030772           Date 28Oct14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                     CER001             Date 25Apr05              */
/*                      BUG8439            Date 08Nov05              */
/*                     CPK022              Date 29Jul05              */
/*                     CPK018              Date 28FEB04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                     CSC014              Date 11Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                     CPB001                Date 02Jun99            */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                     CPL002                DATE 08MAR99            */
/*                     147256                DATE 20Jan99            */
/*                     CUT004                DATE 12OCT98            */
/*                     CTI002                Date 07OCT98            */
/*                     CAP002                DATE 06May98            */
/*                     CEU001                DATE 26JAN98            */
/*                     CTI001                DATE 03OCT97            */
/*                     CRT003                DATE 22JUL96            */
/*                     S01408                DATE 23AUG95            */
/*                     CAAA01                DATE 05MAY95            */
/*                     085173                DATE 12APR95            */
/*                     CRT001                DATE 28FEB95            */
/*                     082708                DATE 03FEB95            */
/*                     S01486                DATE 20JUN94            */
/*                     S01498                DATE 20JUN94            */
/*                     S01522                DATE 25NOV94            */
/*                     076789                DATE 03OCT94            */
/*                     S01413                DATE 13APR93            */
/*                     S01463                DATE 20JAN94            */
/*                     061289                DATE 28SEP93            */
/*                     S01401                DATE 16JUN93            */
/*                     S01407                DATE 18MAR93            */
/*                     S01379                DATE 23SEP92            */
/*                     S01343                DATE 15AUG91            */
/*                     E27199                DATE 09AUG91            */
/*                     RT0032                DATE 14MAY91            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK030 - Clean up of deliverable data library.              */
/*       MD030772 - Switchable features not cached. Call SCC000300   */
/*                  to update SW features caching file (SCSARHTD).   */
/*                - Applied for MD031073.                            */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       BUG8439 - MIDASMSG not found in *LIBL.                      */
/*                 Error in CPK022 coding which removed MLCPYSRC     */
/*                 but also used MLCPYSRC for MLCOVROVR. Fix is      */
/*                 use GPCPYSRCG instead.                            */
/*       CPK022 - Should not use zone /COPYs.                        */
/*       CPK018 - MidasPlus Packaging:                               */
/*                - Replace MSAFT* with GPAFT*.                      */
/*       CSC014 - Allow support for DBCS (Recompiled)                */
/*       CPB001 - Private Banking Module                             */
/*       CPL002 - Midas / Plato Interface Enhancement (Recompiled)   */
/*       147256 - Process overrides for AFT data files.              */
/*       CUT004 - Allow Core and Non-Core mode of compilation for    */
/*                Multilanguage  (RECOMPILED)                        */
/*       CTI002 - MIDAS/TI INTERFACE PHASE II                        */
/*                (RECOMPILED)                                       */
/*       CAP002 - Conversion of transaction inputs into modular      */
/*                structure to use as APIs.                          */
/*                Program recompiled over amended /COPYs             */
/*       CEU001  -  EMU Base Currency For Accounting Conversion      */
/*                  Addition of override to EUMSGF - recompile only. */
/*       CTI001  -  Midas/TI Interface     Phase 1                   */
/*                  Addition of override to TIUSRMSG                 */
/*       CRT003  -  Cashier Interface.                               */
/*                  Addition of override to CIMSGF.                  */
/*      S01408  -  Addition of hook MLCOVRRC1                        */
/*                 Addition of hook MLCOVRRC2                        */
/*                 Addition of hook MLCOVRRC3                        */
/*                 Addition of hook MLCOVRRC4                        */
/*      CAAA01  -  GUI Development:                                  */
/*                 - Multiple Language overrides moved to /COPYs     */
/*                   MLCOVRDCL (declares) and MLCOVROVR (overrides). */
/*                 - Add overrides for MITEMJ3 and MITEMJ4.          */
/*      085173  -  Apply overrides for SPF.                          */
/*      CRT001  -  Retail Teller System                              */
/*      082708  -  Use the most recent RCF default system level if   */
/*                 no record is found on SCIBMDPD.                   */
/*      S01486  -  PORTFOLIO MANAGEMENT                              */
/*      S01498  -  PORTFOLIO LENDING - LOMBARD CREDITS               */
/*      S01522  -  User Defined Correspondence                       */
/*      076789  -  Apply overrides for RCF here                      */
/*      S01413  -  Retail 3 Incorporation.                           */
/*      S01463  -  Program amended to allow the following programs   */
/*                 to use it to set up multiple language support     */
/*                 overrides.                                        */
/*      061289  -  Add override for message file LERMSGF             */
/*      S01401  -  SWIFT Messages MT5xxs : Add SEUSRMSG to the list  */
/*                 of multiple language support overrides.           */
/*      S01407  -  SWITCHABILITY ENHANCEMENTS                        */
/*                 ADD MESSAGE FILES FOR CLOSE OF BUSINESS (CB) AND  */
/*                 FOR CLIENT MODIFICATIONS (XX)                     */
/*      S01379  -  HISTORY AND AUDIT FACILITY                        */
/*                 ADD MSGF/HFMSGF TO THE LIST OF MULTIPLE           */
/*                 LANGUAGE SUPPORT OVERRIDES.                       */
/*      S01343  -  SC/RR/SD MODULE RENAME PROJECT.                   */
/*                 - MLC0000 RENAMED FROM SCC0000.                   */
/*      E27199  -  ADD MSGF/MIDASMSG TO THE LIST OF MULTIPLE         */
/*                 LANGUAGE SUPPORT OVERRIDES.                       */
/*      RT0032  -  NEW PROGRAM TO APPLY MULTI-LANGUAGE OVERRIDES     */
/*                 TO I/C REPORT BATCH JOBS.                         */
/*                                                                   */
/*********************************************************************/
/**********  PGM */                                                   /*S01463*/
             PGM        PARM(&PROGRAM &PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)                                     /*S01463*/

/**Multiple*Language*Support*variables**/                             /*CAAA01*/
/**********                                                   */      /*CAAA01*/
/**********  DCL        VAR(&Y2MGFLA8) TYPE(*CHAR) LEN(8)     */      /*CAAA01*/
/**********  DCL        VAR(&MIMGFLA8) TYPE(*CHAR) LEN(8)     */      /*CAAA01*/
/**********  DCL        VAR(&CBMGFLA8) TYPE(*CHAR) LEN(8)  /*S01407*/ /*CAAA01*/
/**********  DCL        VAR(&Y2MGFLA10) TYPE(*CHAR) LEN(10)   */      /*CAAA01*/
/**********  DCL        VAR(&MIMGFLA10) TYPE(*CHAR) LEN(10)   */      /*CAAA01*/
/**********  DCL        VAR(&CBMGFLA10) TYPE(*CHAR) LEN(10)/*S01407*/ /*CAAA01*/
/**********  DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)         */      /*CAAA01*/
/**********  DCL        VAR(&MITLG) TYPE(*CHAR) LEN(10)       */      /*CAAA01*/
/**********  DCL        VAR(&MITZLG) TYPE(*CHAR) LEN(10)      */      /*CAAA01*/
/**********  DCL        VAR(&MITCLG) TYPE(*CHAR) LEN(10)      */      /*CAAA01*/
/**********  DCL        VAR(&ZZMSGF) TYPE(*CHAR) LEN(8)       */      /*CAAA01*/
/**********  DCL        VAR(&SDUSRLG) TYPE(*CHAR) LEN(10)     */      /*CAAA01*/
/**********  DCL        VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)     */      /*CAAA01*/
/**********  DCL        VAR(&CBUSRLG) TYPE(*CHAR) LEN(10)  /*S01407*/ /*CAAA01*/
/**********  DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)     */      /*CAAA01*/
/**********  DCL        VAR(&DRSMMLG) TYPE(*CHAR) LEN(10)     */      /*CAAA01*/
/**********  DCL        VAR(&MACLG) TYPE(*CHAR) LEN(10)       */      /*CAAA01*/
/**********  DCL        VAR(&MIUSRLG) TYPE(*CHAR) LEN(10)     */      /*CAAA01*/
/**********  DCL        VAR(&WNLG) TYPE(*CHAR) LEN(10)        */      /*CAAA01*/
/**********  DCL        VAR(&Y1USRLG) TYPE(*CHAR) LEN(10)     */      /*CAAA01*/
/**********  DCL        VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)     */      /*CAAA01*/
/**********  DCL        VAR(&Y2USRPMLG) TYPE(*CHAR) LEN(10)   */      /*CAAA01*/
/**********  DCL        VAR(&MIDASMSG) TYPE(*CHAR) LEN(10) /*E27199*/ /*CAAA01*/
/**********  DCL        VAR(&HFMSGF)   TYPE(*CHAR) LEN(10) /*S01379*/ /*CAAA01*/
/**********  DCL        VAR(&XXUSRLG) TYPE(*CHAR) LEN(10)  /*S01407*/ /*CAAA01*/
/**********  DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)       */      /*CAAA01*/
/**********  DCL        VAR(&USER) TYPE(*CHAR) LEN(25)        */      /*CAAA01*/
/**********  DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)        */      /*CAAA01*/
/**********  DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)         */      /*CAAA01*/
/**********  DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)/      /*CAAA01*/
/**********  DCL        VAR(&FCUSRLG) TYPE(*CHAR) LEN(10)     */      /*CAAA01*/
/**********  DCL        VAR(&SEUSRMSG) TYPE(*CHAR) LEN(10) /*S01401*/ /*CAAA01*/
/**********  DCL        VAR(&LERMSGF) TYPE(*CHAR) LEN(10)  /*061289*/ /*CAAA01*/
/**********  DCL        VAR(&MEMSG) TYPE(*CHAR) LEN(10)    /*S01463*/ /*CAAA01*/
/**********  DCL        VAR(&FTUSRMSG) TYPE(*CHAR) LEN(10) /*S01463*/ /*CAAA01*/
/**********  DCL        VAR(&REUSRLG) TYPE(*CHAR) LEN(10)  /*S01413*/ /*CAAA01*/
/**********  DCL        VAR(&REPTMSGF) TYPE(*CHAR) LEN(10) /*S01413*/ /*CAAA01*/
/**********  DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10) /*S01522*/ /*CAAA01*/
/**********  DCL        VAR(&PMUSRMSG) TYPE(*CHAR) LEN(10) /*S01486*/ /*CAAA01*/
/**********  DCL        VAR(&LBUSRMSG) TYPE(*CHAR) LEN(10) /*S01498*/ /*CAAA01*/
/**********  DCL        VAR(&SFUSRMSG) TYPE(*CHAR) LEN(10) /*085173*/ /*CAAA01*/

/***COPY*MLCPYSRC,MLCOVRDCL                                         */             /*CAAA01 CPK022*/
/*/COPY GPCPYSRCG,MLCOVRDCL                                         */             /*CAAA01 CPK022*/
                                                                      /*CAAA01*/
/*/COPY WNCPYSRC,MLCOVRRC1                                         */ /*S01408*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MLCOVRRC2                                         */ /*S01408*/
                                                                      /*S01408*/
/* Program call variables */                                          /*S01463*/
                                                                      /*S01463*/
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)             /*S01463*/
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)              /*S01463*/
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)              /*S01463*/
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)              /*S01463*/
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)              /*S01463*/
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)              /*S01463*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)              /*S01463*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*S01463*/
                                                                      /*S01463*/
/**********  DCL        VAR(&OLDNAME) TYPE(*CHAR) LEN(10)                       */ /*076789 CPK030*/
/**********  DCL        VAR(&IBMLVL) TYPE(*CHAR) LEN(6)                         */ /*076789 CPK030*/
/**********  DCL        VAR(&NEWNAME) TYPE(*CHAR) LEN(10)                       */ /*076789 CPK030*/
/**********  DCL        VAR(&VALUE) TYPE(*CHAR) LEN(50)                         */ /*076789 CPK030*/
/**********  DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)                         */ /*076789 CPK030*/
/**********  DCL        VAR(&RCVVAR) TYPE(*CHAR) LEN(25)                        */ /*076789 CPK030*/
/**********  DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +                              */ /*CPK030*/
/**********               VALUE('PRDR0100')                                     */ /*076789 CPK030*/
/**********  DCL        VAR(&PRDINF) TYPE(*CHAR) LEN(27) +                             */ /*CPK030*/
/**********               VALUE('*OPSYS *CUR  0000*CODE    ')                   */ /*076789 CPK030*/
/**********  DCL        VAR(&V2R3) TYPE(*CHAR) LEN(1) VALUE('Y')                */ /*076789 CPK030*/
/* Copyright statement variable */

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')

/* Global monitor */                                                  /*S01463*/
                                                                      /*S01463*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))       /*S01463*/
                                                                      /*S01463*/
/* Retrieve job type to determine whether this is an interactive */   /*S01463*/
/* or a batch job */                                                  /*S01463*/
                                                                      /*S01463*/
             RTVJOBA    TYPE(&JOBTYPE)                                /*S01463*/

/**Retrieve*data*areas*for*Multiple*Language*Support**/               /*CAAA01*/
/**********                                                   */      /*CAAA01*/
/**********  RTVDTAARA  DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10)    */      /*CAAA01*/
/**********  RTVDTAARA  DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10)    */      /*CAAA01*/
/**********  RTVDTAARA  DTAARA(CBMGFLA) RTNVAR(&CBMGFLA10) /*S01407*/ /*CAAA01*/
/**********                                                   */      /*CAAA01*/
/**Multiple*Language*Support*-****************/                       /*CAAA01*/
/**Initial*processing*for*user*defined*menus**/                       /*CAAA01*/
/**********                                                   */      /*CAAA01*/
/**********  CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO +/*CAAA01*/
/**********               &ERRORC &MULT)                      */      /*CAAA01*/
/**********                                                   */      /*CAAA01*/
/**********  IF         COND(&MULT *EQ '  ') THEN(DO)         */      /*CAAA01*/
/**********     CHGVAR     VAR(&MULT) VALUE('GB')             */      /*CAAA01*/
/**********  ENDDO                                            */      /*CAAA01*/
/**********                                                   */      /*CAAA01*/
/**Build*Multiple*Language*Support*object*names**/                    /*CAAA01*/
/**********                                                   */      /*CAAA01*/
/**********  CHGVAR     VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT/'MSGF')*CAAA01*/
/**********  CHGVAR     VAR(&MITLG) VALUE(&MULT *CAT 'MITEM     ')    /*CAAA01*/
/**********  CHGVAR     VAR(&MITZLG) VALUE(&MULT *CAT 'MITEMZZ   ')   /*CAAA01*/
/**********  CHGVAR     VAR(&MITCLG) VALUE(&MULT *CAT 'MITMC     ')   /*CAAA01*/
/**********  CHGVAR     VAR(&Y2MGFLA8) VALUE(%SST(&Y2MGFLA10 1*8))    /*CAAA01*/
/**********  CHGVAR     VAR(&MIMGFLA8) VALUE(%SST(&MIMGFLA10 1*8))    /*CAAA01*/
/********** CHGVAR VAR(&CBMGFLA8) VALUE(%SST(&CBMGFLA10 1*8))  /*S01407*CAAA01*/
/**********  CHGVAR     VAR(&SDUSRLG) VALUE(&MULT *CAT &Y2MGFLA8)     /*CAAA01*/
/**********  CHGVAR     VAR(&GLUSRLG) VALUE(&MULT *CAT &MIMGFLA8)     /*CAAA01*/
/**********  CHGVAR VAR(&CBUSRLG) VALUE(&MULT *CAT &CBMGFLA8)  /*S01407*CAAA01*/
/**********  CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*CAAA01*/
/**********  CHGVAR     VAR(&DRSMMLG) VALUE(&MULT *CAT 'DRSMM     ')  /*CAAA01*/
/**********  CHGVAR     VAR(&MACLG) VALUE(&MULT *CAT 'MACMSG    ')    /*CAAA01*/
/**********  CHGVAR     VAR(&MIUSRLG) VALUE(&MULT *CAT 'MIUSRMSG  ')  /*CAAA01*/
/**********  CHGVAR     VAR(&WNLG) VALUE(&MULT *CAT 'WNMSGF   *')     /*CAAA01*/
/**********  CHGVAR     VAR(&Y1USRLG) VALUE(&MULT *CAT 'Y1USRMSG  ')  /*CAAA01*/
/**********  CHGVAR     VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')  /*CAAA01*/
/**********  CHGVAR     VAR(&Y2USRPMLG) VALUE(&MULT *CAT 'Y2USRPMT  ')/*CAAA01*/
/**********  CHGVAR     VAR(&FCUSRLG)  VALUE(&MULT *CAT 'FCUSRMSG  ') /*CAAA01*/
/******** CHGVAR VAR(&MIDASMSG) VALUE(&MULT *CAT 'MIDASMSG  ') /*E27199*CAAA01*/
/******** CHGVAR VAR(&HFMSGF)   VALUE(&MULT *CAT 'HFMSGF/   ') /*S01379*CAAA01*/
/******** CHGVAR VAR(&XXUSRLG)  VALUE(&MULT *CAT 'XXUSRMSG  ') /*S01407*CAAA01*/
/******** CHGVAR VAR(&SEUSRMSG) VALUE(&MULT *CAT 'SEUSRMSG  ') /*S01401*CAAA01*/
/******** CHGVAR VAR(&LERMSGF) VALUE(&MULT *CAT 'LERMSGF/ ')   /*061289*CAAA01*/
/******** CHGVAR VAR(&MEMSG) VALUE(&MULT *CAT 'MEMSG    *')    /*S01463*CAAA01*/
/******** CHGVAR VAR(&FTUSRMSG) VALUE(&MULT *CAT 'FTUSRMSG  ') /*S01463*CAAA01*/
/******** CHGVAR VAR(&REUSRLG) VALUE(&MULT *CAT 'REUSRMSG  ')  /*S01413*CAAA01*/
/******** CHGVAR VAR(&REPTMSGF) VALUE(&MULT *CAT 'REPTMSGF  ') /*S01413*CAAA01*/
/******** CHGVAR VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*S01522*CAAA01*/
/******** CHGVAR VAR(&PMUSRMSG) VALUE(&MULT *CAT 'PMUSRMSG  ') /*S01486*CAAA01*/
/******** CHGVAR VAR(&LBUSRMSG) VALUE(&MULT *CAT 'LBUSRMSG  ') /*S01498*CAAA01*/
/******** CHGVAR VAR(&SFUSRMSG) VALUE(&MULT *CAT 'SFUSRMSG  ') /*085173*CAAA01*/
/**********                                                   */      /*CAAA01*/
/**Apply*Multiple*Language*Support*overrides**/                       /*CAAA01*/
/**********                                                   */      /*CAAA01*/
/**********  OVRDBF     FILE(MITEM) MBR(&MITLG) SHARE(*NO)    */      /*CAAA01*/
/**********  OVRDBF     FILE(MITEMJ0) MBR(&MITLG) SHARE(*NO)   /*S01407*CAAA01*/
/**********  OVRDBF     FILE(MITEMJ1) MBR(&MITLG) SHARE(*NO)   /*S01407*CAAA01*/
/**********  OVRDBF     FILE(MITEMZZ) MBR(&MITZLG)            */      /*CAAA01*/
/**********  OVRDBF     FILE(MITMC) MBR(&MITCLG)              */      /*CAAA01*/
/**********  OVRMSGF    MSGF(ZZGBMSGF) TOMSGF(&ZZMSGF)        */      /*CAAA01*/
/**********  OVRMSGF    MSGF(&Y2MGFLA10) TOMSGF(&SDUSRLG)     */      /*CAAA01*/
/**********  OVRMSGF    MSGF(&MIMGFLA10) TOMSGF(&GLUSRLG)     */      /*CAAA01*/
/**********  OVRMSGF    MSGF(&CBMGFLA10) TOMSGF(&CBUSRLG)      /*S01407*CAAA01*/
/**********  OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)          */      /*CAAA01*/
/**********  OVRMSGF    MSGF(DRSMM) TOMSGF(&DRSMMLG)          */      /*CAAA01*/
/**********  OVRMSGF    MSGF(MACMSG) TOMSGF(&MACLG)           */      /*CAAA01*/
/**********  OVRMSGF    MSGF(MIUSRMSG) TOMSGF(&MIUSRLG)       */      /*CAAA01*/
/**********  OVRMSGF    MSGF(WNMSGF) TOMSGF(&WNLG)            */      /*CAAA01*/
/**********  OVRMSGF    MSGF(Y1USRMSG) TOMSGF(&Y1USRLG)       */      /*CAAA01*/
/**********  OVRMSGF    MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)       */      /*CAAA01*/
/**********  OVRMSGF    MSGF(Y2USRPMT) TOMSGF(&Y2USRPMLG)     */      /*CAAA01*/
/**********  OVRMSGF    MSGF(FCUSRMSG) TOMSGF(&FCUSRLG)       */      /*CAAA01*/
/**********  OVRMSGF    MSGF(MIDASMSG) TOMSGF(&MIDASMSG)   /*E27199*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(HFMSGF)   TOMSGF(&HFMSGF)     /*S01379*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(XXUSRMSG) TOMSGF(&XXUSRLG)    /*S01407*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(SEUSRMSG) TOMSGF(&SEUSRMSG)   /*S01401*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(LERMSGF) TOMSGF(&LERMSGF)     /*061289*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(MEMSG) TOMSGF(&MEMSG)         /*S01463*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(FTUSRMSG) TOMSGF(&FTUSRMSG)   /*S01463*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(REUSRMSG) TOMSGF(&REUSRLG)    /*S01413*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(REPTMSGF) TOMSGF(&REPTMSGF)   /*S01413*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)   /*S01522*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(PMUSRMSG) TOMSGF(&PMUSRMSG)   /*S01486*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(LBUSRMSG) TOMSGF(&LBUSRMSG)   /*S01498*/ /*CAAA01*/
/**********  OVRMSGF    MSGF(SFUSRMSG) TOMSGF(&SFUSRMSG)   /*085173*/ /*CAAA01*/
                                                                      /*CAAA01*/
/***COPY*MLCPYSRC,MLCOVROVR                                         */             /*CAAA01 CPK022*/
/***COPY MLCPYSRC,MLCOVROVR                                         */     /*CAAA01 CPK022 BUG8439*/
/*/COPY GPCPYSRCG,MLCOVROVR                                        */                    /*BUG8439*/
                                                                      /*CAAA01*/
/*/COPY WNCPYSRC,MLCOVRRC3                                         */ /*S01408*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MLCOVRRC4                                         */ /*S01408*/
                                                                      /*S01408*/
/*****Determine*operating*system*level*                                         */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  CALL       PGM(QSZRTVPR) PARM(&RCVVAR X'00000019' +                       */ /*CPK030*/
/**********               &FORMAT &PRDINF X'00000000')                          */ /*076789 CPK030*/
                                                                      /*076789*/
/*****If*API*not*found*system*is*pre-V2R3*                         */ /*        */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  MONMSG     MSGID(CPF0000) EXEC(DO)                                 */ /*076789 CPK030*/
/**********  CHGVAR     VAR(&V2R3) VALUE('N')                                   */ /*076789 CPK030*/
/**********  RTVDTAARA  DTAARA(QSYS/QSS1MRI (1 6)) RTNVAR(&IBMLVL)              */ /*076789 CPK030*/
/**********  ENDDO                                                              */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  CHGVAR     VAR(&OSLVL) VALUE(%SST(&RCVVAR 20 6))                   */ /*147256 CPK030*/
                                                                      /*147256*/
/**********  IF         COND(&V2R3 = 'Y') THEN(DO)                              */ /*076789 CPK030*/
/**********  CHGVAR     VAR(&IBMLVL) VALUE(%SST(&RCVVAR 20 6))                  */ /*076789 CPK030*/
/**********  CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +                    */ /*CPK030*/
/**********               &OLDNAME &VALUE)                                      */ /*082708 CPK030*/
/**********  IF         COND(&RTNCDE *EQ '*NRF') THEN(DO)                       */ /*082708 CPK030*/
/**********     CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*LAST' &IBMLVL +                */ /*CPK030*/
/**********                  &OLDNAME &VALUE)                                   */ /*082708 CPK030*/
/**********     CHGVAR     VAR(&IBMLVL) VALUE(%SST(&VALUE 1 6))                 */ /*082708 CPK030*/
/**********  ENDDO                                                              */ /*082708 CPK030*/
/**********  ENDDO                                                              */ /*076789 CPK030*/
                                                                      /*076789*/
/*****Check*for*PF/QAOKDP01*                                       */ /*        */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  CHGVAR     VAR(&OLDNAME) VALUE(QAOKDP01)                           */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +                    */ /*CPK030*/
/**********               &OLDNAME &VALUE)                                      */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  IF         COND(&RTNCDE *NE '*NRF') THEN(DO)                       */ /*076789 CPK030*/
/**********     CHGVAR     VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))              */ /*076789 CPK030*/
/**********     OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)                      */ /*076789 CPK030*/
/**********  ENDDO                                                              */ /*076789 CPK030*/
                                                                      /*076789*/
/*****Check*for*PF/QAOKLP02*                                       */ /*        */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  CHGVAR     VAR(&OLDNAME) VALUE(QAOKLP02)                           */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +                    */ /*CPK030*/
/**********               &OLDNAME &VALUE)                                      */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  IF         COND(&RTNCDE *NE '*NRF') THEN(DO)                       */ /*076789 CPK030*/
/**********     CHGVAR     VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))              */ /*076789 CPK030*/
/**********     OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)                      */ /*076789 CPK030*/
/**********  ENDDO                                                              */ /*076789 CPK030*/
                                                                      /*076789*/
/*****Check*for*LF/QAOKDL01*                                       */ /*        */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  CHGVAR     VAR(&OLDNAME) VALUE(QAOKDL01)                           */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  CALL       PGM(AOIBMDR0) PARM(&RTNCDE '*KEY' &IBMLVL +                    */ /*CPK030*/
/**********               &OLDNAME &VALUE)                                      */ /*076789 CPK030*/
                                                                      /*076789*/
/**********  IF         COND(&RTNCDE *NE '*NRF') THEN(DO)                       */ /*076789 CPK030*/
/**********     CHGVAR     VAR(&NEWNAME) VALUE(%SST(&VALUE 17 10))              */ /*076789 CPK030*/
/**********     OVRDBF     FILE(&OLDNAME) TOFILE(&NEWNAME)                      */ /*076789 CPK030*/
/**********  ENDDO                                                              */ /*076789 CPK030*/
                                                                      /*076789*/
/**Apply*AFT*overrides**/ /*                                                    */ /*147256 CPK030*/
                                                                      /*147256*/
             CHGVAR     VAR(&OSLVL2) VALUE(%SST(&OSLVL 1 2) *CAT +
                          'DFT')                                      /*147256*/
                                                                      /*147256*/
/**MSAFT1PD**/                                                                 /*147256*/ /*CPK018*/
/**GPAFT1PD**/ /*                                                               */ /*CPK018 CPK030*/
                                                                      /*147256*/
/**********  CHGVAR     VAR(&AFTMBR) VALUE('          ')                        */ /*147256 CPK030*/
/**********  CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL)                              */ /*147256 CPK030*/
/**********  CHKOBJ     OBJ(MSAFT1PD) OBJTYPE(*FILE) MBR(&OSLVL) */            /*147256*/ /*CPK018*/
/**********  CHKOBJ     OBJ(GPAFT1PD) OBJTYPE(*FILE) MBR(&OSLVL)                */ /*CPK018 CPK030*/
/**********  MONMSG     MSGID(CPF9815) EXEC(DO)                                 */ /*147256 CPK030*/
/**********     CHGVAR     VAR(&AFTMBR) VALUE('          ')                     */ /*147256 CPK030*/
/**********     CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL2)                          */ /*147256 CPK030*/
/**********     CHKOBJ     OBJ(MSAFT1PD) OBJTYPE(*FILE) MBR(&OSLVL2)           /*147256*/ /*CPK018*/
/**********     CHKOBJ     OBJ(GPAFT1PD) OBJTYPE(*FILE) MBR(&OSLVL2)            */ /*CPK018 CPK030*/
/**********     MONMSG     MSGID(CPF9815) EXEC(DO)                              */ /*147256 CPK030*/
/**********        CHGVAR     VAR(&AFTMBR) VALUE('          ')                  */ /*147256 CPK030*/
/**********        CHGVAR     VAR(&AFTMBR) VALUE(*FIRST)                        */ /*147256 CPK030*/
/**********     ENDDO                                                           */ /*147256 CPK030*/
/**********  ENDDO                                                              */ /*147256 CPK030*/
                                                                      /*147256*/
/**********  OVRDBF     FILE(MSAFT1PD) MBR(&AFTMBR) */                         /*147256*/ /*CPK018*/
/**********  OVRDBF     FILE(GPAFT1PD) MBR(&AFTMBR)                             */ /*CPK018 CPK030*/
                                                                      /*147256*/
/**MSAFT2PD**/                                                                 /*147256*/ /*CPK018*/
/**GPAFT2PD**/ /*                                                               */ /*CPK018 CPK030*/
                                                                      /*147256*/
/**********  CHGVAR     VAR(&AFTMBR) VALUE('          ')                        */ /*147256 CPK030*/
/**********  CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL)                              */ /*147256 CPK030*/
/**********  CHKOBJ     OBJ(MSAFT2PD) OBJTYPE(*FILE) MBR(&OSLVL) */            /*147256*/ /*CPK018*/
/**********  CHKOBJ     OBJ(GPAFT2PD) OBJTYPE(*FILE) MBR(&OSLVL)                */ /*CPK018 CPK030*/
/**********  MONMSG     MSGID(CPF9815) EXEC(DO)                                 */ /*147256 CPK030*/
/**********     CHGVAR     VAR(&AFTMBR) VALUE('          ')                     */ /*147256 CPK030*/
/**********     CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL2)                          */ /*147256 CPK030*/
/**********     CHKOBJ     OBJ(MSAFT2PD) OBJTYPE(*FILE) MBR(&OSLVL2) */        /*147256*/ /*CPK018*/
/**********     CHKOBJ     OBJ(GPAFT2PD) OBJTYPE(*FILE) MBR(&OSLVL2)            */ /*CPK018 CPK030*/
/**********     MONMSG     MSGID(CPF9815) EXEC(DO)                              */ /*147256 CPK030*/
/**********        CHGVAR     VAR(&AFTMBR) VALUE('          ')                  */ /*147256 CPK030*/
/**********        CHGVAR     VAR(&AFTMBR) VALUE(*FIRST)                        */ /*147256 CPK030*/
/**********     ENDDO                                                           */ /*147256 CPK030*/
/**********  ENDDO                                                              */ /*147256 CPK030*/
                                                                      /*147256*/
/**********  OVRDBF     FILE(MSAFT2PD) MBR(&AFTMBR) */                         /*147256*/ /*CPK018*/
/**********  OVRDBF     FILE(GPAFT2PD) MBR(&AFTMBR)                             */ /*CPK018 CPK030*/
                                                                      /*147256*/
/**MSAFT3PD**/                                                                 /*147256*/ /*CPK018*/
/**GPAFT3PD**/ /*                                                               */ /*CPK018 CPK030*/
                                                                      /*147256*/
/**********  CHGVAR     VAR(&AFTMBR) VALUE('          ')                        */ /*147256 CPK030*/
/**********  CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL)                              */ /*147256 CPK030*/
/**********  CHKOBJ     OBJ(MSAFT3PD) OBJTYPE(*FILE) MBR(&OSLVL) */            /*147256*/ /*CPK018*/
/**********  CHKOBJ     OBJ(GPAFT3PD) OBJTYPE(*FILE) MBR(&OSLVL)                */ /*CPK018 CPK030*/
/**********  MONMSG     MSGID(CPF9815) EXEC(DO)                                 */ /*147256 CPK030*/
/**********     CHGVAR     VAR(&AFTMBR) VALUE('          ')                     */ /*147256 CPK030*/
/**********     CHGVAR     VAR(&AFTMBR) VALUE(&OSLVL2)                          */ /*147256 CPK030*/
/**********     CHKOBJ     OBJ(MSAFT3PD) OBJTYPE(*FILE) MBR(&OSLVL2) */        /*147256*/ /*CPK018*/
/**********     CHKOBJ     OBJ(GPAFT3PD) OBJTYPE(*FILE) MBR(&OSLVL2)            */ /*CPK018 CPK030*/
/**********     MONMSG     MSGID(CPF9815) EXEC(DO)                              */ /*147256 CPK030*/
/**********        CHGVAR     VAR(&AFTMBR) VALUE('          ')                  */ /*147256 CPK030*/
/**********        CHGVAR     VAR(&AFTMBR) VALUE(*FIRST)                        */ /*147256 CPK030*/
/**********     ENDDO                                                           */ /*147256 CPK030*/
/**********  ENDDO                                                              */ /*147256 CPK030*/
                                                                      /*147256*/
/**********  OVRDBF     FILE(MSAFT3PD) MBR(&AFTMBR) */                         /*147256*/ /*CPK018*/
/**********  OVRDBF     FILE(GPAFT3PD) MBR(&AFTMBR)                             */ /*CPK018 CPK030*/

/* If the program to be called is 'RETURN' */                         /*S01463*/
                                                                      /*S01463*/
             IF         COND(&PROGRAM *EQ 'RETURN') THEN(DO)          /*S01463*/
                RETURN                                                /*S01463*/
             ENDDO                                                    /*S01463*/
                                                                      /*S01463*/
/* Otherwise call the program name as passed to this program */       /*S01463*/
                                                                      /*S01463*/
             CALL       PGM(&PROGRAM) PARM(&PARM1 &PARM2 &PARM3 +
                          &PARM4 &PARM5)                              /*S01463*/
                                                                      /*S01463*/

/* Cache switchable features after switch-on/off */                                     /*MD030772*/
             CALL       PGM(SCC000300)                                                  /*MD030772*/

/* Go to the end of the program */                                    /*S01463*/
                                                                      /*S01463*/
             GOTO       CMDLBL(ENDPGM)                                /*S01463*/
                                                                      /*S01463*/
 ABNOR:                                                               /*S01463*/
             SNDMSG     MSG('Multiple language support initiation +
                          terminated abnormally') TOMSGQ(MOPERQ)      /*S01463*/
             MONMSG     MSGID(CPF0000)                                /*S01463*/
                                                                      /*S01463*/
             CHGJOB     SWS(XXXXXX11)                                 /*S01463*/
             MONMSG     MSGID(CPF0000)                                /*S01463*/
                                                                      /*S01463*/
/* If this is an interactive job then inform the user that */         /*S01463*/
/* there has been an error                                 */         /*S01463*/
                                                                      /*S01463*/
             IF         COND(&JOBTYPE *EQ '1') THEN(DO)               /*S01463*/
                                                                      /*S01463*/
                RTVMSG     MSGID(MLM0001) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)                            /*S01463*/
                MONMSG     MSGID(CPF0000 MCH0000)                     /*S01463*/
                                                                      /*S01463*/
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)  /*S01463*/
                MONMSG     MSGID(CPF0000 MCH0000)                     /*S01463*/
                                                                      /*S01463*/
                RTVMSG     MSGID(MLM0002) MSGF(GBMIDASMSG) +
                             MSG(&MESSAGE)                            /*S01463*/
                MONMSG     MSGID(CPF0000 MCH0000)                     /*S01463*/
                                                                      /*S01463*/
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)  /*S01463*/
                MONMSG     MSGID(CPF0000 MCH0000)                     /*S01463*/
                                                                      /*S01463*/
                CALL       PGM(MLC0010) PARM('MLC0000' 'ENTER' ' ')   /*S01463*/
                MONMSG     MSGID(CPF0000 MCH0000)                     /*S01463*/
                                                                      /*S01463*/
             ENDDO                                                    /*S01463*/
                                                                      /*S01463*/
/* End of program processing */                                       /*S01463*/
                                                                      /*S01463*/
 ENDPGM:                                                              /*S01463*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
