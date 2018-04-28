/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Pool Portofolio Details Report')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC5030 - POOL SECURITIES DETAILS REPORT                    */
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
/*       PREV AMEND NO. S01486             DATE 31AUG94              */
/*                      063365             DATE 16NOV93              */
/*                      049421             DATE 18JAN93              */
/*                      47346              DATE 18NOV92              */
/*                      S01355             DATE 28AUG92              */
/*                      SA9108             DATE 28AUG92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       099814 - Pool Trades should use CQQ001 feature              */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       063365 - ERROR ON POOL PORTFOLIO POSITION                   */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       47346  - TERMINATE PROGRAM IMMEDIATELY IF POOL PORTF. OFF   */
/*       S01355 - POOL PORTFOLIO SWITCHABLE                          */
/*       SA9108 - WRITTEN FOR POOL SECURITIES                        */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM        PARM(&PARM)                                    *S01486*/
             PGM        PARM(&PARM &RSEQ &RLVL &RENT)                 /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&PPT) TYPE(*CHAR) LEN(1)                   *S01486*/
/************DCL        VAR(&PPSW) TYPE(*CHAR) LEN(1)         *S01355* *S01486*/
/************DCL        VAR(&PPRQ) TYPE(*CHAR) LEN(1)       */ /*47346  099814*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01486*/
 
/*>>> 063365 >>>*/
/*********** RTVDTAARA  DTAARA(LZSTAT (33 1)) RTNVAR(&PPSW)  /*S01355  063365 */
/************RTVDTAARA  DTAARA(LZSTAT (35 1)) RTNVAR(&PPSW)   *063365* *S01486*/
/*<<< 063365 <<<*/
/************IF         COND(&PPSW *EQ 'Y') THEN(DO)          *S01355* *S01486*/
 
/*>>> 063365 >>>*/
/************RTVDTAARA  DTAARA(PMSTAT (40 1)) RTNVAR(&PPRQ)  /*47346   063365 */
/************RTVDTAARA  DTAARA(PMSTAT (35 1)) RTNVAR(&PPRQ) */ /*063365 099814*/
/*<<<<063365 <<<*/
/**********  IF         COND(&PPRQ *EQ 'Y') THEN(DO)        */ /*47346  099814*/
 
/* SET OFF SWITCHES */
             CHGJOB     SWS(00000000)
 
             CALL       PGM(PM5030) PARM(&PARM)
 
/* PROCESS DATA BASE ERROR */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/************   SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             GOTO ENDPGM
             ENDDO
 
/* CHECK FOR FILE CONTROL ERRORS TRAPPED BY THE PROGRAM */
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)
/************   SNDPGMMSG  MSGID(PEM0002) MSGF(CEUSRMSG) MSGDTA(&DATA)+*S01486*/
/************                TOMSGQ(MOPERQ MRUNQ)                      *S01486*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01486*/
             ENDDO
/************ENDDO                                          */ /*47346  099814*/
/************ENDDO                                            *S01355* *S01486*/
 
/***********ENDPGM:        ENDPGM                                      *S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
