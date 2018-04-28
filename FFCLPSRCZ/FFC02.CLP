/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Input cycle processing')                     */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC02  -  INPUT CYCLE PROCESSING                                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CFF007             Date 13Feb01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E23409             Date 31Aug90              */
/*                      S01117             Date 07Feb90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CHANGE DESCRIPTIONS                                           */
/*                                                                   */
/*       CFF007 - Futures and Options Enhancement for Private Banking*/
/*   E23409 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF RETAIL II */
/*            OR INTEREST ON ACCOUNTS INSTALLED - SETON U2 IF RE OR  */
/*            IA = 'Y'.   NOTE - RETAIL I NOT SUPPORTED ON AS/400    */
/*   S01117 - MULTIBRANCHING                                         */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)
/**/
/**********  DCL        VAR(&PARM) TYPE(*CHAR) LEN(8)              */                     /*CFF007*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(10)                                    /*CFF007*/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&FFMRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BLANKS) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             CHGJOB SWS(00000000)
             CHGDTAARA  DTAARA(LDA) VALUE(&BLANKS)
/**/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*E23409*/
/*     ( SET ON U2 IF PRESENT)                        */           /*E23409*/
/**/                                                               /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*E23409*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*SETON*U2*IF*PRESENT***//************E23409*/
/************RTVDTAARA**DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) +**************E23409*/
/*************************THEN(CHGJOB SWS(X1XXXXXX))*****************E23409*/
/**/
/*   SETON U6 TO SIGNIFY INPUT CYCLE OPERATION        */
/*   FOR STANDARD SUBROUTINE FFSETL IN FF0020/FF0040  */
/**/
             CHGJOB SWS(XXXXX1XX)
/**/
/*   CALL INPUT CYCLE PROGRAM  */
/**/
             CALL       PGM(&PARM)
/**/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG MSG('Transaction failed. Re-input +
                      necessary. Enter to continue.') TOPGMQ(*EXT)
             ENDDO
/**/
/*   FOR DATABASE ERRORS RECOVER DATA FROM LDA   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
/***********    CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))      */ /*S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))         /*S01117*/
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/**/
             RTVDTAARA  DTAARA(FFMRKT) RTNVAR(&FFMRKT)
             MONMSG     MSGID(CPF1015)
/**/
             IF         COND(&FFMRKT *NE '  ') THEN(DO)
                DLCOBJ     OBJ((&FFMRKT *DTAARA *SHRRD))
             ENDDO
/**/
             DLTOVR     FILE(*ALL)
             RCLRSC
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
