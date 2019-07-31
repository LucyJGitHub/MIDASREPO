/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Portfolio Charges Accrued Report')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0370 PM PORTFOLIO CHARGES ACCRUED REPORT                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO. S01486             DATE 01SEP94              */
/*                      049421             DATE 18JAN93              */
/*                      049467             DATE 18JAN93              */
/*                      B07866             DATE 29MAY91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01486  -  Portfolio Management Upgrade to R10              */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       049467  -  RECOMPILED FOR RELEASE 3 PTF 02                  */
/*       B07866  -  PROGRAM REWRITTEN FOR ERROR                      */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01486*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*S01486*/
/*                                                                   */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
/*  Reset external switches                                                   */
 
             CHGJOB     SWS(00000000)
 
/*  RETRIEVE EVENT CONTROL DATE                                   */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
 
/*  Override open query file                                                  */
 
/************OVRDBF     FILE(PMPORTJF) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             OVRDBF     FILE(PMPORTQ0) TOFILE(SDACOFPD) SHARE(*YES)   /*S01486*/
             MONMSG     MSGID(CPF0000)
 
/*  Run report showing all details                                            */
/***********                                                          /*S01486*/
/*********** OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPP)) +      /*S01486*/
/************             FORMAT(PMPORTJF) QRYSLT('PNRECI *NE "*" +   /*S01486*/
/***********              *AND PNBCGY *NE "   "') +                   /*S01486*/
/***********              KEYFLD((SDACOFPD/AZPRTL) +                  /*S01486*/
/***********              (SDACOFPD/AZACOC) (PMPORTPP/PNCNUM) +       /*S01486*/
/***********              (PMPORTPP/PNPTFR)) JFLD((SDACOFPD/AZACOC +  /*S01486*/
/***********              SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +         /*S01486*/
/***********              *MAPFLD/PNCNUA)) MAPFLD((PNCNUA +           /*S01486*/
/***********              'PMPORTPP/PNCNUM' *CHAR 6))                 /*S01486*/
/***********                                                          /*S01486*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (PMPORTPD)) +
                          FORMAT(PMPORTQ0) QRYSLT('PNRECI *NE "*" +
                          *AND PNBCGY *NE "   "') +
                          KEYFLD((PMPORTPD/PNCNUM) +
                          (PMPORTPD/PNPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/PNCNUA)) MAPFLD((PNCNUA +
                          'PMPORTPD/PNCNUM' *CHAR 6))                 /*S01486*/
 
/*  RUN REPORT PROGRAM    */
 
/*********** CALL       PGM(PM0370)  *****************/               /*S01486*/
             CALL       PGM(PM0370)  PARM(&RSEQ)                      /*S01486*/
             CLOF       OPNID(SDACOFPD)
             DLTOVR     FILE(*ALL)
 
/*  Database error, if U7 & U8 on  */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)          /*S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01486*/
/*                                                                    /*R00300*/
/***********    SNDPGMMSG  MSGID(MEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) /*S01486*/
/***********              TOMSGQ(MOPERQ MRUNQ)                     */ /*S01486*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
             ENDDO
 
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01486*/
