/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ML QCMDEXC multi-language (BATCH)')             */
/*********************************************************************/
/*                                                                   */
/*      Midas - Multiple Language Support Module                     */
/*                                                                   */
/*      MLC0020 - Apply Overrides for BATCH                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CPK030             Date 11Apr14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*      Last Amend No. CER001              Date 25Apr05              */
/*                      CPK022             Date 29Jul05              */
/*                     CPK018              Date 28Feb04              */
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
/*                     CAP002                DATE 06MAY98            */
/*                     CEU001                DATE 26JAN98            */
/*                     CTI001                DATE 03OCT97            */
/*                     CRT003                DATE 22JUL96            */
/*                     S01408                DATE 23AUG95            */
/*                     CAAA01                DATE 31JUL95            */
/*                     CRT001                DATE 28FEB95            */
/*                     S01486                DATE 20JUN94            */
/*                     S01498                DATE 20JUN94            */
/*                     S01522                DATE 25NOV94            */
/*                     S01413                DATE 13APR94            */
/*                     S01435                DATE 19AUG93            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK030 - Clean up of deliverable data library.              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
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
/*      CRT003 - Cashier Interface.                                  */
/*               Addition of override to CIMSGF.                     */
/*      S01408 - Addition of hook MLCOVRRC1                          */
/*               Addition of hook MLCOVRRC2                          */
/*               Addition of hook MLCOVRRC3                          */
/*               Addition of hook MLCOVRRC4                          */
/*      CAAA01 - GUI Development:                                    */
/*               - Multiple Language overrides moved to /COPYs       */
/*                 MLCOVRDCL (declares) and MLCOVROVR (overrides).   */
/*      CRT001 - Retail Teller System                                */
/*      S01486 - PORTFOLIO MANAGEMENT                                */
/*      S01498 - PORTFOLIO LENDING - LOMBARD CREDITS                 */
/*      S01522  -  User Defined Correspondence                       */
/*      S01413  -  Retail 3 Incorporation.                           */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM
/* */
/*  Multiple Language Support Variables  */
/* */
/**********  DCL        VAR(&Y2MGFLA8) TYPE(*CHAR) LEN(8)       **/   /*CAAA01*/
/**********  DCL        VAR(&MIMGFLA8) TYPE(*CHAR) LEN(8)       **/   /*CAAA01*/
/**********  DCL        VAR(&CBMGFLA8) TYPE(*CHAR) LEN(8)       **/   /*CAAA01*/
/**********  DCL        VAR(&Y2MGFLA10) TYPE(*CHAR) LEN(10)     **/   /*CAAA01*/
/**********  DCL        VAR(&MIMGFLA10) TYPE(*CHAR) LEN(10)     **/   /*CAAA01*/
/**********  DCL        VAR(&CBMGFLA10) TYPE(*CHAR) LEN(10)     **/   /*CAAA01*/
/**********  DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)           **/   /*CAAA01*/
/**********  DCL        VAR(&MITLG) TYPE(*CHAR) LEN(10)         **/   /*CAAA01*/
/**********  DCL        VAR(&MITZLG) TYPE(*CHAR) LEN(10)        **/   /*CAAA01*/
/**********  DCL        VAR(&MITCLG) TYPE(*CHAR) LEN(10)        **/   /*CAAA01*/
/**********  DCL        VAR(&ZZMSGF) TYPE(*CHAR) LEN(8)         **/   /*CAAA01*/
/**********  DCL        VAR(&SDUSRLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&CBUSRLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&DRSMMLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&MACLG) TYPE(*CHAR) LEN(10)         **/   /*CAAA01*/
/**********  DCL        VAR(&MIUSRLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&WNLG) TYPE(*CHAR) LEN(10)          **/   /*CAAA01*/
/**********  DCL        VAR(&Y1USRLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&Y2USRPMLG) TYPE(*CHAR) LEN(10)     **/   /*CAAA01*/
/**********  DCL        VAR(&MIDASMSG) TYPE(*CHAR) LEN(10)      **/   /*CAAA01*/
/**********  DCL        VAR(&HFMSGF)   TYPE(*CHAR) LEN(10)      **/   /*CAAA01*/
/**********  DCL        VAR(&XXUSRLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)         **/   /*CAAA01*/
/**********  DCL        VAR(&USER) TYPE(*CHAR) LEN(25)          **/   /*CAAA01*/
/**********  DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)          **/   /*CAAA01*/
/**********  DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)           **/   /*CAAA01*/
/**********  DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0) **/   /*CAAA01*/
/**********  DCL        VAR(&FCUSRLG) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&SEUSRMSG) TYPE(*CHAR) LEN(10)      **/   /*CAAA01*/
/**********  DCL        VAR(&LERMSGF) TYPE(*CHAR) LEN(10)       **/   /*CAAA01*/
/**********  DCL        VAR(&FTUSRMSG) TYPE(*CHAR) LEN(10)      **/   /*CAAA01*/
/**********  DCL        VAR(&REUSRLG) TYPE(*CHAR) LEN(10) **/  /*S01413*CAAA01*/
/**********  DCL        VAR(&REPTMSGF) TYPE(*CHAR) LEN(10) */  /*S01413*CAAA01*/
/**********  DCL        VAR(&MEMSG) TYPE(*CHAR) LEN(10)         **/   /*CAAA01*/
/**********  DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10) */  /*S01522*CAAA01*/
/**********  DCL        VAR(&PMUSRMSG) TYPE(*CHAR) LEN(10) */  /*S01486*CAAA01*/
/**********  DCL        VAR(&LBUSRMSG) TYPE(*CHAR) LEN(10) */  /*S01498*CAAA01*/
/**********  DCL        VAR(&RTSMSGF)  TYPE(*CHAR) LEN(10) */  /*CRT001*CAAA01*/
/**********  DCL        VAR(&PRDINF) TYPE(*CHAR) LEN(27) +                             */ /*CPK030*/
/**********               VALUE('*OPSYS *CUR  0000*CODE    ')                   */ /*147256 CPK030*/
/**********  DCL        VAR(&RCVVAR) TYPE(*CHAR) LEN(25)                        */ /*147256 CPK030*/
/**********  DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +                              */ /*CPK030*/
/**********               VALUE('PRDR0100')                                     */ /*147256 CPK030*/
                                                                      /*CAAA01*/
/***COPY*MLCPYSRC,MLCOVRDCL                                         */             /*CAAA01 CPK022*/
/*/COPY GPCPYSRCG,MLCOVRDCL                                        */              /*CAAA01 CPK022*/
                                                                      /*CAAA01*/
/*/COPY WNCPYSRC,MLCOVRRC1                                         */ /*S01408*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MLCOVRRC2                                         */ /*S01408*/
                                                                      /*S01408*/
/* */
/*  Copyright Statement Variable  */
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Global monitor */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNORMAL))
/* */
/***Retrieve*Dtaaras*fpr*Multiple*Language*Support***/                /*CAAA01*/
/* */
/**********  RTVDTAARA  DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10)      **/   /*CAAA01*/
/**********  RTVDTAARA  DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10)      **/   /*CAAA01*/
/**********  RTVDTAARA  DTAARA(CBMGFLA) RTNVAR(&CBMGFLA10)      **/   /*CAAA01*/
/* */
/***Multiple*Language*Support*-*******************/                   /*CAAA01*/
/***Initial*processing*for*user*defined*menus*****/                   /*CAAA01*/
/* */
/**********  CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO +/*CAAA01*/
/**********               &ERRORC &MULT)                        **/   /*CAAA01*/
/* */
/**********  IF         COND(&MULT *EQ '  ') THEN(DO)           **/   /*CAAA01*/
/**********     CHGVAR     VAR(&MULT) VALUE('GB')               **/   /*CAAA01*/
/**********  ENDDO                                              **/   /*CAAA01*/
/* */
/***Build*Multiple*Language*Support*Object*names***/                  /*CAAA01*/
/* */
/**********  CHGVAR     VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT 'MSGF')*CAAA01*/
/**********  CHGVAR     VAR(&MITLG) VALUE(&MULT *CAT 'MITEM     ')/   /*CAAA01*/
/**********  CHGVAR     VAR(&MITZLG) VALUE(&MULT *CAT 'MITEMZZ   ')   /*CAAA01*/
/**********  CHGVAR     VAR(&MITCLG) VALUE(&MULT *CAT 'MITMC     ')   /*CAAA01*/
/**********  CHGVAR     VAR(&Y2MGFLA8) VALUE(%SST(&Y2MGFLA10 1 8))    /*CAAA01*/
/**********  CHGVAR     VAR(&MIMGFLA8) VALUE(%SST(&MIMGFLA10 1 8))    /*CAAA01*/
/**********  CHGVAR     VAR(&CBMGFLA8) VALUE(%SST(&CBMGFLA10 1 8))    /*CAAA01*/
/**********  CHGVAR     VAR(&SDUSRLG) VALUE(&MULT *CAT &Y2MGFLA8)*/   /*CAAA01*/
/**********  CHGVAR     VAR(&GLUSRLG) VALUE(&MULT *CAT &MIMGFLA8)*/   /*CAAA01*/
/**********  CHGVAR     VAR(&CBUSRLG) VALUE(&MULT *CAT &CBMGFLA8)*/   /*CAAA01*/
/**********  CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*CAAA01*/
/**********  CHGVAR     VAR(&DRSMMLG) VALUE(&MULT *CAT 'DRSMM     ')  /*CAAA01*/
/**********  CHGVAR     VAR(&MACLG) VALUE(&MULT *CAT 'MACMSG    ')    /*CAAA01*/
/**********  CHGVAR     VAR(&MIUSRLG) VALUE(&MULT *CAT 'MIUSRMSG  ')  /*CAAA01*/
/**********  CHGVAR     VAR(&WNLG) VALUE(&MULT *CAT 'WNMSGF    ')**/  /*CAAA01*/
/**********  CHGVAR     VAR(&Y1USRLG) VALUE(&MULT *CAT 'Y1USRMSG  ')  /*CAAA01*/
/**********  CHGVAR     VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')  /*CAAA01*/
/**********  CHGVAR     VAR(&Y2USRPMLG) VALUE(&MULT *CAT 'Y2USRPMT  ')/*CAAA01*/
/**********  CHGVAR     VAR(&FCUSRLG)  VALUE(&MULT *CAT 'FCUSRMSG  ') /*CAAA01*/
/**********  CHGVAR     VAR(&MIDASMSG) VALUE(&MULT *CAT 'MIDASMSG  ') /*CAAA01*/
/**********  CHGVAR     VAR(&HFMSGF)   VALUE(&MULT *CAT 'HFMSGF    ') /*CAAA01*/
/**********  CHGVAR     VAR(&XXUSRLG)  VALUE(&MULT *CAT 'XXUSRMSG  ') /*CAAA01*/
/**********  CHGVAR     VAR(&SEUSRMSG) VALUE(&MULT *CAT 'SEUSRMSG  ') /*CAAA01*/
/**********  CHGVAR     VAR(&LERMSGF) VALUE(&MULT *CAT 'LERMSGF  ')   /*CAAA01*/
/**********  CHGVAR     VAR(&FTUSRMSG) VALUE(&MULT *CAT 'FTUSRMSG  ') /*CAAA01*/
/**********  CHGVAR     VAR(&REUSRLG) VALUE(&MULT *CAT 'REUSRMSG  ')  /*S01413*/
/**********  CHGVAR     VAR(&REPTMSGF) VALUE(&MULT *CAT 'REPTMSGF  ') /*S01413*/
/**********  CHGVAR     VAR(&MEMSG) VALUE(&MULT *CAT 'MEMSG  ') **/   /*CAAA01*/
/******** CHGVAR VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*S01522*CAAA01*/
/******** CHGVAR VAR(&PMUSRMSG) VALUE(&MULT *CAT 'PMUSRMSG  ') /*S01486*CAAA01*/
/******** CHGVAR VAR(&LBUSRMSG) VALUE(&MULT *CAT 'LBUSRMSG  ') /*S01498*CAAA01*/
/******** CHGVAR VAR(&RTSMSGF)  VALUE(&MULT *CAT 'RTSMSGF   ') /*CRT001*CAAA01*/
/* */
/***Apply*Multiple*Language*Support*Overrides***/                     /*CAAA01*/
/* */
/**********                                                     **/   /*CAAA01*/
/**********  OVRDBF     FILE(MITEM) MBR(&MITLG) SHARE(*NO)      **/   /*CAAA01*/
/**********  OVRDBF     FILE(MITEMJ0) MBR(&MITLG) SHARE(*NO)    **/   /*CAAA01*/
/**********  OVRDBF     FILE(MITEMJ1) MBR(&MITLG) SHARE(*NO)    **/   /*CAAA01*/
/**********  OVRDBF     FILE(MITEMZZ) MBR(&MITZLG)              **/   /*CAAA01*/
/**********  OVRDBF     FILE(MITMC) MBR(&MITCLG)                **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(ZZGBMSGF) TOMSGF(&ZZMSGF)          **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(&Y2MGFLA10) TOMSGF(&SDUSRLG)       **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(&MIMGFLA10) TOMSGF(&GLUSRLG)       **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(&CBMGFLA10) TOMSGF(&CBUSRLG)       **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)            **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(DRSMM) TOMSGF(&DRSMMLG)            **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(MACMSG) TOMSGF(&MACLG)             **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(MIUSRMSG) TOMSGF(&MIUSRLG)         **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(WNMSGF) TOMSGF(&WNLG)              **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(Y1USRMSG) TOMSGF(&Y1USRLG)         **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)         **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(Y2USRPMT) TOMSGF(&Y2USRPMLG)       **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(FCUSRMSG) TOMSGF(&FCUSRLG)         **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(MIDASMSG) TOMSGF(&MIDASMSG)        **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(HFMSGF)   TOMSGF(&HFMSGF)          **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(XXUSRMSG) TOMSGF(&XXUSRLG)         **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(SEUSRMSG) TOMSGF(&SEUSRMSG)        **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(LERMSGF) TOMSGF(&LERMSGF)          **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(FTUSRMSG) TOMSGF(&FTUSRMSG)        **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(REUSRMSG) TOMSGF(&REUSRLG)  **/   /*S01413*CAAA01*/
/**********  OVRMSGF    MSGF(REPTMSGF) TOMSGF(&REPTMSGF) **/   /*S01413*CAAA01*/
/**********  OVRMSGF    MSGF(MEMSG) TOMSGF(&MEMSG)              **/   /*CAAA01*/
/**********  OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG) **/   /*S01522*CAAA01*/
/**********  OVRMSGF    MSGF(PMUSRMSG) TOMSGF(&PMUSRMSG) **/   /*S01486*CAAA01*/
/**********  OVRMSGF    MSGF(LBUSRMSG) TOMSGF(&LBUSRMSG) **/   /*S01498*CAAA01*/
/**********  OVRMSGF    MSGF(RTSMSGF)  TOMSGF(&RTSMSGF)  **/   /*CRT001*CAAA01*/
                                                                      /*CAAA01*/
/***COPY*MLCPYSRC,MLCOVROVR                                         */             /*CAAA01 CPK022*/
/*/COPY GPCPYSRCG,MLCOVROVR                                         */             /*CAAA01 CPK022*/
                                                                      /*CAAA01*/
/*/COPY WNCPYSRC,MLCOVRRC3                                         */ /*S01408*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MLCOVRRC4                                         */ /*S01408*/
                                                                      /*S01408*/
/*****Determine*operating*system*level*                            */ /*        */ /*147256 CPK030*/
                                                                      /*147256*/
/**********  CALL       PGM(QSZRTVPR) PARM(&RCVVAR X'00000019' +                       */ /*CPK030*/
/**********               &FORMAT &PRDINF X'00000000')                          */ /*147256 CPK030*/
                                                                      /*147256*/
/**********  CHGVAR     VAR(&OSLVL) VALUE(%SST(&RCVVAR 20 6))                   */ /*147256 CPK030*/
                                                                      /*147256*/
/**Apply*AFT*overrides**/ /*                                                    */ /*147256 CPK030*/
                                                                      /*147256*/
/**********  CHGVAR     VAR(&OSLVL2) VALUE(%SST(&OSLVL 1 2) *CAT +                     */ /*CPK030*/
/**********               'DFT')                                                */ /*147256 CPK030*/
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
                                                                      /*147256*/
/* */
/*  End of progeam processing  */
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
/* */
/* Call Qcmd to execute command on external message queue */
/* */
             CALL       PGM(QCMD)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MLC0020 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MLC0020 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
