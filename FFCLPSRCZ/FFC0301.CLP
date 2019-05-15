/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Customer/broker holdings enquiry')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0301  -  CUSTOMER/BROKER HOLDINGS ENQUIRY                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      163444             Date 07Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01332             Date 17MAY91              */
/*                  E23409             DATE 31AUG90                  */
/*                  S01117             DATE 19APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*   163444 - Add Century field                                      */
/*   S01332  -  Amended for Exposure Management Release 10           */
/*   E23409 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF RETAIL II */
/*            OR INTEREST ON ACCOUNTS INSTALLED - SETON U2 IF RE OR  */
/*            IA = 'Y'.   NOTE - RETAIL I NOT SUPPORTED ON AS/400    */
/*   S01117 - MULTIBRANCHING                                         */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*           DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &MMOD         TYPE(*CHAR)  LEN(256)
/**********  DCL        VAR(&EMSDS)  TYPE(*CHAR) LEN(161)                      /*S01332*/ /*CGL029*/
             DCL        VAR(&EMSDS)  TYPE(*CHAR) LEN(167)                                 /*CGL029*/
             DCL        VAR(&PGN1D)  TYPE(*CHAR) LEN(8)              /*S01332*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(00000000)
 
/*   IF POSITIONS 2 TO 9 ON DTAARA/EMSDS ARE BLANK, THIS IS THE   */ /*S01332*/
/*   FIRST ENQUIRY IN THE STACK, SO CLEAR DTAARA/EMSDS AND SET    */ /*S01332*/
/*   POSITIONS 2 TO 9 TO 'FFC0301' TO INDICATE THAT THIS IS FIRST */ /*S01332*/
/*   ENQUIRY IN STACK                                             */ /*S01332*/
                                                                     /*S01332*/
             RTVDTAARA DTAARA(EMSDS) RTNVAR(&EMSDS)                  /*S01332*/
             CHGVAR     VAR(&PGN1D) VALUE(%SST(&EMSDS 2 8))          /*S01332*/
             IF COND(&PGN1D *EQ '        ') THEN(DO)                 /*S01332*/
                CHGDTAARA  DTAARA(EMSDS) VALUE(' ')                  /*S01332*/
                CHGDTAARA  DTAARA(EMSDS (2 8)) VALUE('FFC0301 ')     /*S01332*/
             ENDDO                                                   /*S01332*/
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
/*   FOR STANDARD SUBROUTINE FFSETL IN FF0720         */
/**/
             CHGJOB SWS(XXXXX1XX)
/**/
/*   CALL PROGRAM                                                  */
/**/
             OVRDBF     FILE(POSTNC1) TOFILE(POSTNL1)                 /*163444*/
             OVRDBF     FILE(POSTNC2) TOFILE(POSTNL2)                 /*163444*/
/**/
             CALL       PGM(FF0720)
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ.                                               */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/*                                                                   */
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC0301 CUSTOMER/BROKER HOLDINGS ENQUIRY +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:                                                                 /*S01332*/
/*   RESET POSITIONS 2 TO 9 ON EMSDS TO BLANK                     */ /*S01332*/
                                                                     /*S01332*/
             CHGDTAARA  DTAARA(EMSDS (2 8)) VALUE('        ')        /*S01332*/
/*END**********ENDPGM */                                             /*S03132*/
             ENDPGM                                                  /*S01332*/
