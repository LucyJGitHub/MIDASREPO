/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Closing trades/exercises (EOC)')             */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1006  -  CLOSING TRADES AND EXERCISES GENERATION AT MATURITY */
/*                                                           (EOC)   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*   Last Amend No. 190552             DATE 29May01                  */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*   Pevt Amend No. 137719             DATE 30Jan01                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  E23409             DATE 31AUG90                  */
/*                  S01117             DATE 15MAR90                  */
/*                  S01240             DATE 04/04/89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   190552 - Delete overrides for file PRICSD and PRICSA            */
/*            for processing inside FF0355. (Bit missed by 137719)   */
/*   137719 - Add proper overrides for file PRICSD and PRICSA        */
/*            for processing inside FF0355.                          */
/*   E23409 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF RETAIL II */
/*            OR INTEREST ON ACCOUNTS INSTALLED - SETON U2 IF RE OR  */
/*            IA = 'Y'.   NOTE - RETAIL I NOT SUPPORTED ON AS/400    */
/*   S01117 - MULTIBRANCHING                                         */
/*   S01240 - ADDITION OF REAL-TIME STATEMENTS                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MKT)
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
/**/
/*  OVERRIDE TO CORRECT MARKET                                      */
/**/
             OVRDBF     FILE(MATINC) MBR(&MKT)
             OVRDBF     FILE(TRANS6) MBR(&MKT)
             OVRDBF     FILE(TRANSA) MBR(&MKT)
             OVRDBF     FILE(PRICS) MBR(&MKT)
             OVRDBF     FILE(PRICSD) MBR(&MKT)                       /*137719*/
             OVRDBF     FILE(PRICSA) MBR(&MKT)                       /*137719*/
             OVRDBF     FILE(POSTNC) MBR(&MKT)
             OVRDBF     FILE(POSTNK) MBR(&MKT)
             OVRDBF     FILE(TRANSD) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(TRSETD) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(WTRNSD) MBR(&MKT) SEQONLY(*YES 100)
/**/
             CLRPFM     FILE(WTRNSD) MBR(&MKT)
/**/
/*     CALL FF0355 - GENERATION OF CLOSING TRADES FOR MATURED INST'S */
/**/
             CALL       PGM(FF0355) PARM(&MKT)
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(MATINC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANS6)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANSA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRICS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRICSD)                                 /*137719*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*137719*/
             DLTOVR     FILE(PRICSA)                                 /*137719*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*137719*/
             DLTOVR     FILE(POSTNC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POSTNK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANSD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRSETD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*     DATABASE ERROR?  IF SO GO TO DBERR TAG                        */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*                                         INPUT                     */
/**/
             OVRDBF     FILE(WTRNSLP) MBR(&MKT)
             OVRDBF     FILE(WTRNSFP) MBR(&MKT)
             OVRDBF     FILE(WTRNSLS) MBR(&MKT)
             OVRDBF     FILE(WTRNSFS) MBR(&MKT)
/**/
/*                                         OUTPUT                    */
/**/
             OVRDBF     FILE(CLOSTT) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(CLOSTD) MBR(&MKT) SEQONLY(*YES 100)
/**/
/*     CALL CLOSE OUT SET CREATION PROGRAM                           */
/**/
             CALL       PGM(FF0330) PARM(&MKT)
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(WTRNSLP)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSFP)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSLS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSFS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
/*                                         INPUT                     */
/**/
             OVRDBF     FILE(WTRNS1) MBR(&MKT)
/**/
/*                                         OUTPUT                    */
/**/
             OVRDBF     FILE(TRANS) MBR(&MKT)
/**/
/*     CALL TRANSACTIONS UPDATE PROGRAM                              */
/**/
             CALL       PGM(FF0335)
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(WTRNS1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*E23409*/
/*     ( SET ON U2 IF PRESENT)                        */           /*E23409*/
/**/                                                               /*E23409*/
             CHGJOB     SWS(XXXXX100)                              /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*E23409*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*SET*ON*U2*IF*IT*IS*PRESENT**********E23409*/
/************CHGJOB*****SWS(XXXXX100)********************************E23409*/
/************RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) THEN(DO)*******E23409*/
/****************CHGJOB*****SWS(X1XXXXXX)****************************E23409*/
/************ENDDO***************************************************E23409*/
/**/
/*  OVERRIDE TO CORRECT MARKET                                      */
/**/
             OVRDBF     FILE(MATINE) MBR(&MKT)
             OVRDBF     FILE(POSTNC) MBR(&MKT)
             OVRDBF     FILE(POSTNK) MBR(&MKT)
             OVRDBF     FILE(MEMOSM) MBR(&MKT)
             OVRDBF     FILE(PRONOM) MBR(&MKT)
                                                                     /*S01240*/
             OVRDBF     FILE(FFACMVD) MBR(&MKT)                      /*S01240*/
                                                                     /*S01240*/
             OVRDBF     FILE(TRANSA) MBR(&MKT)
             OVRDBF     FILE(TRANS6) MBR(&MKT)
             OVRDBF     FILE(TRSET) MBR(&MKT)
             OVRDBF     FILE(TRANSD) MBR(&MKT)
             OVRDBF     FILE(TRSETD) MBR(&MKT)
             OVRDBF     FILE(CLOSTD) MBR(&MKT)
             OVRDBF     FILE(CLOSTT) MBR(&MKT)
/**/
/*     CALL FF0350 - GENERATION OF EXERCISES FOR MATURED INSTRUMENTS */
/**/
             CALL       PGM(FF0350) PARM(&MKT)
/**/
/*     DATABASE ERROR?  IF SO GO TO DBERR TAG                        */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
             GOTO END
/**/
/*     DATABASE ERROR?  IF SO SEND MESSAGE TO MOPERQ AND CALL FF0473 */
/*     - THE ERROR MONITORING PROGRAM                                */
/**/
/*ERR:       RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
DBERR:       RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1006')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
/*                                                                   */
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX1X)
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
END:         DLTOVR     FILE(MATINC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MATINE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRICS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRICSD)                                  /*190552*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*190552*/
             DLTOVR     FILE(PRICSA)                                  /*190552*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*190552*/
             DLTOVR     FILE(TRANSD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRSETD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(WTRNSD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POSTNC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POSTNK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MEMOSM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRONOM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                     /*S01240*/
             DLTOVR     FILE(FFACMVD)                                /*S01240*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)               /*S01240*/
                                                                     /*S01240*/
             DLTOVR     FILE(TRANSA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANS6)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRSET)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(CLOSTD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(CLOSTT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
