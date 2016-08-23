/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Pool Settlement Position Maintenance')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                       */
/*                                                                   */
/*       SEC5230 - POOL POSITION SETTLEMENT MAINTENANCE              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 099814             DATE 16FEB96              */
/*       PREV AMEND NO. 085019             DATE 06SEP95              */
/*                      S01408             DATE 10MAY95              */
/*                      S01486             DATE 14DEC94              */
/*                      058886             DATE 20JUL93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       099814 - Pool Trades should use CQQ001 feature not PMSTAT   */
/*                SDMMODPD securities Flag is posn 31.               */
/*       085019 - Should be conditioned on Securities Trading        */
/*       S01408 - Addition of core hook SEC5230INT                   */
/*              - Addition of core hook SEC5230MPS                   */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*                Copyright Statement and Standard Header Box.       */
/*                Creation Parameters. Message Files.                */
/*       058886 - OBJECT PMC5130 RENAMED TO SEC5230                  */
/*     WRITTEN FOR SAR 91/08 - POOL SECURITIES TRANSACTIONS          */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* DECLARE VARIABLES */
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PPT) TYPE(*CHAR) LEN(1)
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ') /*085019*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*085019*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*085019*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC5230INT                                          */
                                                                      /*S01408*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIB)
/************                                                         /*099814*/
/************RTVDTAARA  DTAARA((&LIB *CAT 'DMLIB')/PMSTAT (35 1)) +   /*099814*/
/************             RTNVAR(&PPT)                                /*099814*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC5230MPS                                          */
                                                                      /*S01408*/
 
/************IF         COND(&PPT *NE 'Y') THEN(DO)                   /*099814*/
/*                                                                    /*099814*/
/* If Pool Trades Optional Feature not present, terminate             /*099814*/
/*                                                                    /*099814*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CQQ001' +
                          &FMT)                                       /*099814*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*099814*/
                                                                      /*099814*/
             SNDPGMMSG  MSG('Pool Portfolios not installed - Option +
                          not allowed') TOPGMQ(*EXT)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
                                                                      /*085019*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*085019*/
/************IF         COND(%SST(&FMT 35 1) *NE 'Y') THEN(DO)  *085019 099814*/
             IF         COND(%SST(&FMT 31 1) *NE 'Y') THEN(DO)        /*099814*/
             SNDPGMMSG  MSG('Securities Trading not installed +
                          - Option not allowed') TOPGMQ(*EXT)         /*085019*/
             GOTO       CMDLBL(ENDPGM)                                /*085019*/
             ENDDO                                                    /*085019*/
 
/* SET OFF SWITCHES */
             CHGJOB     SWS(00000000)
 
/* OVERWRITE FILES SHARE *NO */
             OVRDBF     FILE(PMPSETPD) SHARE(*NO)
/*           OVRDBF     FILE(POSETDL1) SHARE(*NO)                  */ /*S01486*/
             OVRDBF     FILE(POSET) SHARE(*NO)                        /*S01486*/
             OVRDBF     FILE(PMPOSDL4) SHARE(*NO)                     /*S01486*/
 
/* CALL PGM PM5130 */
/*           CALL       PGM(PM5130)                            58886 */
             CALL       PGM(SE5230)                          /*58886 */
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/*           SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)        */ /*S01486*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
             ENDDO
 
/* ENDPGM:      ENDPGM                                             */ /*S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
