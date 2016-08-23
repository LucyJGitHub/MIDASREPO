/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Create Consolidated Pool Cashflows')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1411 - PM Create Pool Portfolio Consolidated             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 099814             DATE 14FEB96              */
/*       PREV AMEND NO. S01486             DATE 11AUG94              */
/*                      046657             DATE 12NOV92              */
/*                      049421             DATE 18JAN93              */
/*                      47346              DATE 18NOV92              */
/*                      S01355             DATE 28AUG92              */
/*                      SA9108             DATE 05NOV91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       099814 - Pool Trades should use CQQ001 feature not PMSTAT   */
/*       S01486 - Portfolio Management Upgrade to Release 10         */
/*       046657 - EMERGENCY FIX TO AVOID ANOTHER CRASH IN THE EOD.   */
/*                DUE TO NEW IBM PTF (?), CPYFRMQRYF HAD TO BE       */
/*                CHANGED TO *NOCHK.                                 */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       47346  - TERMINATE PROGRAM IMMEDIATELY IF POOL PORTF. OFF   */
/*       S01355 - POOL PORTFOLIO SWITCHABLE                          */
/*       SA9108 - POOL PORTFOLIOS SAR                                */
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
/*********** DCL        VAR(&PPSW) TYPE(*CHAR) LEN(1)       */ /*S01355 S01486*/
/*********** DCL        VAR(&PPRQ) TYPE(*CHAR) LEN(1)       */ /*47346  099814*/
 
/*********** RTVDTAARA  DTAARA(LZSTAT (33 1)) RTNVAR(&PPSW) */ /*S01355 S01486*/
/*********** IF         COND(&PPSW *EQ 'Y') THEN(DO)        */ /*S01355 S01486*/
 
/************RTVDTAARA  DTAARA(PMSTAT (40 1)) RTNVAR(&PPRQ) */ /*47346  099814*/
/************IF         COND(&PPRQ *EQ 'Y') THEN(DO)        */ /*47346  099814*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC1411 - Create Pool Portfolio +
                          Cashflows') TOMSGQ(MRUNQ)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* COPY DAILY AND MONTHLY CASHFLOWS TO WORKFILES FOR TOTALLING */
             OVRDBF     FILE(PMPPTMPD) SHARE(*YES)
/*********** OPNQRYF FILE((PMPPTMPD) (PMCFDYPP)) FORMAT(WWCFDYPP) +*/ /*S01486*/
/***********              JFLD((PMPPTMPD/OSCNUM PMCFDYPP/QKCNUM) + */ /*S01486*/
/***********              (PMPPTMPD/OSPTFR PMCFDYPP/QKPTFR)) +     */ /*S01486*/
/***********              MAPFLD((WWCNUM OSPCNU) (WWPTFR OSPPTF) + */ /*S01486*/
/***********              (WWDYNO QKDYNO) (WWCCY QKCCY) +          */ /*S01486*/
/***********              (WWCDP QKCDP) (WWICAS QKICAS) +          */ /*S01486*/
/***********              (WWOCAS QKOCAS) (WWNECS QKNECS) +        */ /*S01486*/
/***********              (WWNEPT QKNEPT) (WWNECT QKNECT) +        */ /*S01486*/
/***********              (WWNEBS QKNEBS))                         */ /*S01486*/
             OPNQRYF    FILE((PMPPTMPD) (PMCFDYPD)) FORMAT(PMCFDYQ0) +
                          JFLD((PMPPTMPD/OSCNUM PMCFDYPD/QKCNUM) +
                          (PMPPTMPD/OSPTFR PMCFDYPD/QKPTFR)) +
                          MAPFLD((WWCNUM OSPCNU) (WWPTFR OSPPTF) +
                          (WWDYNO QKDYNO) (WWCCY QKCCY) +
                          (WWCDP QKCDP) (WWICAS QKICAS) +
                          (WWOCAS QKOCAS) (WWNECS QKNECS) +
                          (WWNEPT QKNEPT) (WWNECT QKNECT) +
                          (WWNEBS QKNEBS))                            /*S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMPPTMPD) TOFILE(WWCFDYPP) +     */ /*S01486*/
/***********              MBROPT(*REPLACE)                         */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMPPTMPD) TOFILE(PMCFDYQ0) +
                          MBROPT(*REPLACE)                            /*S01486*/
             CLOF       OPNID(PMPPTMPD)
 
             OVRDBF     FILE(PMPPTMPD) SHARE(*YES)
/*********** OPNQRYF FILE((PMPPTMPD) (PMCFMYPP)) FORMAT(WWCFMYPP) +*/ /*S01486*/
/***********              JFLD((PMPPTMPD/OSCNUM PMCFMYPP/QLCNUM) + */ /*S01486*/
/***********              (PMPPTMPD/OSPTFR PMCFMYPP/QLPTFR)) +     */ /*S01486*/
/***********              MAPFLD((WWCNUM OSPCNU) (WWPTFR OSPPTF) + */ /*S01486*/
/***********              (WWMYNO QLMYNO) (WWMYIN QLMYIN) (WWCCY + */ /*S01486*/
/***********              QLCCY) (WWCDP QLCDP) (WWICAS QLICAS) +   */ /*S01486*/
/***********              (WWOCAS QLOCAS) (WWNECS QLNECS) (WWNEPT +*/ /*S01486*/
/***********              QLNEPT) (WWNECT QLNECT) (WWNEBS QLNEBS)) */ /*S01486*/
             OPNQRYF    FILE((PMPPTMPD) (PMCFMYPD)) FORMAT(PMCFMYQ0) +
                          JFLD((PMPPTMPD/OSCNUM PMCFMYPD/QLCNUM) +
                          (PMPPTMPD/OSPTFR PMCFMYPD/QLPTFR)) +
                          MAPFLD((WWCNUM OSPCNU) (WWPTFR OSPPTF) +
                          (WWMYNO QLMYNO) (WWMYIN QLMYIN) (WWCCY +
                          QLCCY) (WWCDP QLCDP) (WWICAS QLICAS) +
                          (WWOCAS QLOCAS) (WWNECS QLNECS) (WWNEPT +
                          QLNEPT) (WWNECT QLNECT) (WWNEBS QLNEBS))    /*S01486*/
/*********** CPYFRMQRYF FROMOPNID(PMPPTMPD) TOFILE(WWCFMYPP) +     */ /*S01486*/
/***********              MBROPT(*REPLACE)                         */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMPPTMPD) TOFILE(PMCFMYQ0) +
                          MBROPT(*REPLACE)                            /*S01486*/
             CLOF       OPNID(PMPPTMPD)
 
/* CREATE POOL PORTFOLIO DAILY CASHFLOWS */
/*********** OPNQRYF    FILE((WWCFDYPP)) FORMAT(PMCFDYPP) +        */ /*S01486*/
/***********             GRPFLD(WWCNUM WWPTFR WWDYNO WWCCY WWCDP) +*/ /*S01486*/
/***********              MAPFLD((QKCNUM WWCNUM) (QKPTFR WWPTFR) + */ /*S01486*/
/***********              (QKDYNO WWDYNO) (QKCCY WWCCY) (QKCDP +   */ /*S01486*/
/***********              WWCDP) (QKICAS '%SUM(WWICAS)') (QKOCAS + */ /*S01486*/
/***********              '%SUM(WWOCAS)') (QKNECS '%SUM(WWNECS)') +*/ /*S01486*/
/***********              (QKNEPT '%SUM(WWNEPT)') (QKNECT +        */ /*S01486*/
/***********              '%SUM(WWNECT)') (QKNEBS '%SUM(WWNEBS)')) */ /*S01486*/
             OPNQRYF    FILE((PMCFDYQ0)) FORMAT(PMCFDYPD) +
                          GRPFLD(WWCNUM WWPTFR WWDYNO WWCCY WWCDP) +
                          MAPFLD((QKCNUM WWCNUM) (QKPTFR WWPTFR) +
                          (QKDYNO WWDYNO) (QKCCY WWCCY) (QKCDP +
                          WWCDP) (QKICAS '%SUM(WWICAS)') (QKOCAS +
                          '%SUM(WWOCAS)') (QKNECS '%SUM(WWNECS)') +
                          (QKNEPT '%SUM(WWNEPT)') (QKNECT +
                          '%SUM(WWNECT)') (QKNEBS '%SUM(WWNEBS)'))    /*S01486*/
/*>>046657>>*/
/************CPYFRMQRYF FROMOPNID(WWCFDYPP) TOFILE(PMCFDYPP) +
                          MBROPT(*ADD)*/
/*********** CPYFRMQRYF FROMOPNID(WWCFDYPP) TOFILE(PMCFDYPP) +     */ /*S01486*/
/***********              MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMCFDYQ0) TOFILE(PMCFDYPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
/*<<046657<<*/
/*********** CLOF       OPNID(WWCFDYPP)                            */ /*S01486*/
             CLOF       OPNID(PMCFDYQ0)                               /*S01486*/
 
/* CREATE POOL PORTFOLIO MONTHLY AND YEARLY CASHFLOWS */
/*********** OPNQRYF    FILE((WWCFMYPP)) FORMAT(PMCFMYPP) +        */
/***********             GRPFLD(WWCNUM WWPTFR WWMYNO WWMYIN WWCCY +*/
/***********              WWCDP) MAPFLD((QLCNUM WWCNUM) (QLPTFR +  */
/***********              WWPTFR) (QLMYNO WWMYNO) (QLMYIN WWMYIN) +*/
/***********              (QLCCY WWCCY) (QLCDP WWCDP) (QLICAS +    */
/***********              '%SUM(WWICAS)') (QLOCAS '%SUM(WWOCAS)') +*/
/***********              (QLNECS '%SUM(WWNECS)') (QLNEPT +        */
/***********              '%SUM(WWNEPT)') (QLNECT '%SUM(WWNECT)') +*/
/***********              (QLNEBS '%SUM(WWNEBS)'))                 */
             OPNQRYF    FILE((PMCFMYQ0)) FORMAT(PMCFMYPD) +
                          GRPFLD(WWCNUM WWPTFR WWMYNO WWMYIN WWCCY +
                          WWCDP) MAPFLD((QLCNUM WWCNUM) (QLPTFR +
                          WWPTFR) (QLMYNO WWMYNO) (QLMYIN WWMYIN) +
                          (QLCCY WWCCY) (QLCDP WWCDP) (QLICAS +
                          '%SUM(WWICAS)') (QLOCAS '%SUM(WWOCAS)') +
                          (QLNECS '%SUM(WWNECS)') (QLNEPT +
                          '%SUM(WWNEPT)') (QLNECT '%SUM(WWNECT)') +
                          (QLNEBS '%SUM(WWNEBS)'))                    /*S01486*/
/*>>046657>>*/
/************CPYFRMQRYF FROMOPNID(WWCFMYPP) TOFILE(PMCFMYPP) +
                          MBROPT(*ADD)*/
/*********** CPYFRMQRYF FROMOPNID(WWCFMYPP) TOFILE(PMCFMYPP) +     */ /*S01486*/
/***********              MBROPT(*ADD) FMTOPT(*NOCHK)              */ /*S01486*/
             CPYFRMQRYF FROMOPNID(PMCFMYQ0) TOFILE(PMCFMYPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)                 /*S01486*/
/*<<046657<<*/
/*********** CLOF       OPNID(WWCFMYPP)                               /*S01486*/
             CLOF       OPNID(PMCFMYQ0)                               /*S01486*/
 
 
/************ENDDO                                          */ /* 47346 099814*/
/************ENDDO                                          */ /*S01355 S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
