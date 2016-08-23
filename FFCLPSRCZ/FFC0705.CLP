/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Margin a/c int. rate chgs. (COB)')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                        */
/*                                                                   */
/*   FFC0705  -  MARGIN ACCOUNT INTEREST RATE CHANGES UPDATE (COB)   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*   Last Amend No. CCB009             Date 01Jun00                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Prev Amend No. 082461             Date 08Mar95                  */
/*                  079666             Date 01Dec94                  */
/*                  E23409             DATE 31AUG90                  */
/*                  S01117             DATE 22MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  CCB009 - Journal files throughout close of business              */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*  079666 - Add global monitor message processing                   */
/*   E23409 - THIS COMPONENT SHOULD RUN IF RETAIL II -OR- INTEREST   */
/*            ON ACCOUNTS INSTALLED.                                 */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        VAR(&MEM)   TYPE(*CHAR)  LEN(44)           */ /*S01117*/
             DCL        VAR(&MEM)   TYPE(*CHAR)  LEN(50)              /*S01117*/
             DCL        VAR(&MMOD)  TYPE(*CHAR)  LEN(256)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*079666*/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS - END PROGRAM  */  /*E23409*/
/*        IF NOT SWITCHED ON IN SYSTEM.                        */  /*E23409*/
/**/                                                               /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) THEN(DO)     /*E23409*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*END*PROGRAM IF IT ISN'T*************E23409*/
/************RTVDTAARA**DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) THEN(DO)*******E23409*/
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0705 - Margin +
                          Account Interest Rate Changes Update') +
                          TOMSGQ(MRUNQ)
/**/
/* START JOURNALLING OF PF/RCHGRA                                   */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/RCHGRA) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
                                                                      /*082461*/
             GOTO       CMDLBL(BYPASS)                                /*082461*/
                                                                      /*082461*/
JRNFAIL:                                                              /*082461*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*082461*/
             IF         COND(&COUNT *LE 3) THEN(DO)                   /*082461*/
             DLYJOB     DLY(60)                                       /*082461*/
             GOTO       CMDLBL(RETRY)                                 /*082461*/
             ENDDO                                                    /*082461*/
             ELSE       CMD(DO)                                       /*082461*/
             GOTO       CMDLBL(ABNOR)                                 /*082461*/
             ENDDO                                                    /*082461*/
BYPASS:                                                               /*082461*/
             ENDDO                                                    /*CCB009*/
/**/
/*  CALL START JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN2    FILES(RCHGRA)
/**/
/*  OVERRIDE LF/RCHG2                                               */
/**/
             OVRDBF     FILE(RCHG2) SHARE(*YES)
/**/
/* OPNQRYF Selects types 2 and 3 Detail records  */
/**/
             OPNQRYF    FILE((RCHG2)) OPTION(*INP *UPD) FORMAT(*FILE) +
                          QRYSLT(' %SST(ZZ006 1 1) *NE ''1''') +
                          KEYFLD(*FILE)
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/*   CALL FF0670 - MARGIN ACCOUNT INTEREST RATE CHANGES UPDATE      */
/**/
             CALL FF0670
/**/
             CLOF OPNID(RCHG2)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(RCHG2)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN3    FILES(RCHGRA)
/**/
             ENDDO
/**/
             GOTO       CMDLBL(END)                                   /*079666*/
                                                                      /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0705 - Margin Account Interest Rate +
                          Changes Update TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             DMPCLPGM                                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             CHGJOB     SWS(XXXXXX11)                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
                                                                      /*079666*/
END:                                                                  /*079666*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
       ENDPGM
/**/
