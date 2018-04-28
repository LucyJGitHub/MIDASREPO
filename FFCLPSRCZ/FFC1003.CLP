/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Close Out Revrsl Shadow Post(EOC)')          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1003  -  CLOSE OUT SET REVERSAL SHADOW POST (EOC)            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Last Amend No. CPK009             Date 09Aug99                  */
/*   Prev Amend No. E23409             DATE 31AUG90                  */
/*                  S01117             DATE 15MAR90                  */
/*                  S01240             DATE 12/04/89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   CPK009 - Packaging for DBA3 release. STRCMTCTL values set       */
/*            to CMTSCOPE(*JOB).                                     */
/*   E23409 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF RETAIL II */
/*            OR INTEREST ON ACCOUNTS INSTALLED - SETON U2 IF RE OR  */
/*            IA = 'Y'.   NOTE - RETAIL I NOT SUPPORTED ON AS/400    */
/*   S01117 - MULTIBRANCHING                                         */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*     S01240 - ADDITION OF REAL TIME STATEMENT CHANGES              */
/*********************************************************************/
/*                                                                   */
             PGM        PARM(&MKT)
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCD) TYPE(*DEC)  LEN(1 0)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(70)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*LIBL/MNTYF (*FILE))   /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*LIBL/MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                           /*CPK009*/
             MONMSG     MSGID(CPF8351)
/**/
             CHGJOB     SWS(XXXXX100)
/**/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*E23409*/
/*     ( SET ON U2 IF PRESENT)                        */           /*E23409*/
/**/                                                               /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*E23409*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*SET*ON*U2*IF*IT*IS*PRESENT**********E23409*/
/************RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) THEN(DO)*******E23409*/
/****************CHGJOB*****SWS(X1XXXXXX)****************************E23409*/
/************ENDDO***************************************************E23409*/
/**/
/*  OVERRIDE TO CORRECT MARKET                                      */
/**/
             OVRDBF     FILE(CLOST3) MBR(&MKT)
             OVRDBF     FILE(CLOST4) MBR(&MKT)
             OVRDBF     FILE(CLOST5) MBR(&MKT)
             OVRDBF     FILE(POSTNC) MBR(&MKT)
             OVRDBF     FILE(POSTNK) MBR(&MKT)
             OVRDBF     FILE(MEMOSM) MBR(&MKT)
             OVRDBF     FILE(PRONOM) MBR(&MKT)
             OVRDBF     FILE(FFACMVD) MBR(&MKT)                       /*S01240*/
             OVRDBF     FILE(TRSETS) TOFILE(TRSET) MBR(&MKT) SHARE(*NO)
             OVRDBF     FILE(TRSETP) TOFILE(TRSET) MBR(&MKT) SHARE(*NO)
             OVRDBF     FILE(TRANSS) TOFILE(TRANS) MBR(&MKT) SHARE(*NO)
             OVRDBF     FILE(TRANSP) TOFILE(TRANS) MBR(&MKT) SHARE(*NO)
/**/
/*  OTHER OVERRIDES                                                 */
/**/
             OVRDBF     FILE(FOCLTB) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF     FILE(FOCLTC) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF     FILE(DEFLTB) TOFILE(DEFLT) SHARE(*NO)
             OVRDBF     FILE(DEFLTC) TOFILE(DEFLT) SHARE(*NO)
/**/
/*     CALL FF0320 - CLOSE OUT SET REVERSAL SHADOW POST              */
/**/
             CALL       PGM(FF0320) PARM(&MKT &RCD)
             ENDCMTCTL
/**/
/*     DATABASE ERROR?  IF SO SEND MESSAGE TO MOPERQ AND CALL FF0473 */
/*     - THE ERROR MONITORING PROGRAM                                */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1003')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
             ENDDO
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
END:         DLTOVR     FILE(FOCLTB)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(FOCLTC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(DEFLTB)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(DEFLTC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANSP)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANSS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRSETP)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRSETS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(CLOST3)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(CLOST4)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(CLOST5)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POSTNC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POSTNK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MEMOSM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRONOM)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(FFACMVD)                                 /*S01240*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01240*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
