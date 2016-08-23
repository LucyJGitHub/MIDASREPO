/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Incomplete Pool Transactions Report')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC5200 - INCOMPLETE POOL TRANSACTIONS REPORT               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486             DATE 17JUN94              */
/*       PREV AMEND NO. 049421             DATE 18JAN93              */
/*                      47346              DATE 18NOV92              */
/*                      S01355             DATE 28AUG92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       47346  - TERMINATE PROGRAM IMMEDIATELY IF POOL PORTF. OFF   */
/*       S01355 - POOL PORTFOLIO SWITCHABLE                          */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* DECLARE VARIABLES */
/*********** DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                  S01486*/
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)                /*S01486*/
/*********** DCL        VAR(&WWMOD) TYPE(*CHAR) LEN(1)                  S01486*/
/*********** DCL        VAR(&PPSW) TYPE(*CHAR) LEN(1)         /*S01355  S01486*/
/*********** DCL        VAR(&PPRQ) TYPE(*CHAR) LEN(1)         /*47346   S01486*/
             DCL VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')            /*S01486*/
             DCL VAR(&CQQ001) TYPE(*CHAR) LEN(1) VALUE(' ')           /*S01486*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*********** RTVDTAARA  DTAARA(LZSTAT (33 1)) RTNVAR(&PPSW)   /*S01355  S01486*/
/*********** IF         COND(&PPSW *EQ 'Y') THEN(DO)          /*S01355  S01486*/
 
/*********** RTVDTAARA  DTAARA(PMSTAT (40 1)) RTNVAR(&PPRQ)   /*47346   S01486*/
/*********** IF         COND(&PPRQ *EQ 'Y') THEN(DO)          /*47346   S01486*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CQQ001')          /*S01486*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CQQ001) VALUE('Y'))        /*S01486*/
             IF (&CQQ001 *EQ 'Y') THEN(DO)                            /*S01486*/
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('PMC5200 - Incomplete Pool +
                          Transactions') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/**/
/**CHECK*WHETHER*SE*PRESENT*AND*IF*PRESENT*CALL*PGM/PM5210              S01486*/
/*********** RTVDTAARA  DTAARA(MMOD (21 1)) RTNVAR(&WWMOD)              S01486*/
/**/
/*********** IF         COND(&WWMOD *EQ 'Y') THEN(DO)                   S01486*/
/* CALL RPG PROGRAM */
             CALL       PGM(PM5210)
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************** RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)           S01486*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)         /*S01486*/
/************** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                       S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&DATA) +
                             TOMSGQ(MOPERQ MRUNQ)                    /*S01486*/
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO                                                    /*S01486*/
/*********** ENDDO                                                      S01486*/
/*********** ENDDO                                            /* 47346  S01486*/
/*********** ENDDO                                            /* S01355 S01486*/
 
ABNOR:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM
