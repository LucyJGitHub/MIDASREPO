/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Trade gen. for matrd insts (COB)')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                        */
/*                                                                   */
/*   FFC0760  -  TRADE GENERATION FOR MATURED INSTRUMENTS            */
/*                                                    (EOC IN COB)   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*   Last Amend No. BUG10453R          Date 13Feb06                  */
/*   Prev Amend No. BUG10453           Date 09Feb06                  */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                  137719             Date 30Jan01                  */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                  CCB009             Date 01Jun00                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  114717             Date 25Feb97                  */
/*                  082461             Date 08Mar95                  */
/*                  079666             DATE 01DEC94                  */
/*                  S01117             DATE 15MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  BUG10453R - Check for switchable feature LUX if on. If ON,       */
/*           include overrides and journalling for extension file.   */
/*  BUG10453 - Add overrides for file FFTRX2PD                       */
/*                for processing inside FF0355.                      */
/*  137719 - Add proper overrides for file PRICSD and PRICSA         */
/*                for processing inside FF0355.                      */
/*  CCB009 - Journal files throughout close of business              */
/*  114717 - SUPPRESS OVRDBF SEQONLY(*YES 100) TO AVOID SOME LOST    */
/*           RECORDS                                                 */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*  079666 - Add global monitor message processing                   */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                /*BUG10453R*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                /*BUG10453R*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                /*BUG10453R*/
             DCL        VAR(&ULX008) TYPE(*CHAR) LEN(1)                              /*BUG10453R*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*079666*/
/** Check for Switchable feature ULX008                                                BUG10453R*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                  /*BUG10453R*/
             CHGVAR     VAR(&SARD) VALUE('ULX008')                                   /*BUG10453R*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                        /*BUG10453R*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&ULX008) VALUE('Y'))                                   /*BUG10453R*/
/* SEND MESSAGE TO MRUNQ                                            */
/**/
             SNDPGMMSG  MSG('FFC0760 - Trade +
                          Generation for Matured Instruments') +
                          TOMSGQ(MRUNQ)
/**/
/* START JOURNALLING OF ALL UPDATE OR OUTPUT FILES                  */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/POSTNCD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POSTNKD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/TRANSD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/TRANSA) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/TRSETD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/CLOSTD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/CLOSTT) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
IF         COND(&ULX008 *EQ 'Y') THEN(DO)                                            /*BUG10453R*/
STRJRNPF   FILE(*LIBL/FFTRX2PD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)                                                        /*BUG10453R*/
             MONMSG     MSGID(CPF7030)                                               /*BUG10453R*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                    /*BUG10453R*/
ENDDO                                                                                /*BUG10453R*/
/*/COPY WNCPYSRC,FFC0760001                                          */
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
/*  CALL INITIAL JOURNAL PROCESSING FOR SUB-COMPONENT               */
/**/
/*/COPY WNCPYSRC,FFC0760002                                          */
IF         COND(&ULX008 *NE 'Y') THEN(DO)                                            /*BUG10453R*/
             FFCJRN2    FILES(TRANSD TRANSA TRSETD POSTNCD POSTNKD +
                          CLOSTD CLOSTT)
ENDDO                                                                                /*BUG10453R*/
ELSE       CMD(DO)                                                                   /*BUG10453R*/
             FFCJRN2    FILES(TRANSD TRANSA TRSETD POSTNCD POSTNKD +
                          CLOSTD CLOSTT FFTRX2PD)                                    /*BUG10453R*/
ENDDO                                                                                /*BUG10453R*/
/*/COPY WNCPYSRC,FFC0760003                                          */
/**/
/* PROCESS OTC'S (OVER THE COUNTER TRADES)                          */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(MATINC) MBR(OTC)
             OVRDBF     FILE(TRANS6) MBR(OTC)
             OVRDBF     FILE(TRANSA) MBR(OTC)
             OVRDBF     FILE(PRICS) MBR(OTC)
             OVRDBF     FILE(PRICSD) MBR(OTC)                         /*137719*/
             OVRDBF     FILE(PRICSA) MBR(OTC)                         /*137719*/
             OVRDBF     FILE(POSTNC) MBR(OTC)
             OVRDBF     FILE(POSTNK) MBR(OTC)
/*           OVRDBF     FILE(TRANSD) MBR(OTC) SEQONLY(*YES 100)        114717 */
/*           OVRDBF     FILE(TRSETD) MBR(OTC) SEQONLY(*YES 100)        114717 */
/*           OVRDBF     FILE(WTRNSD) MBR(OTC) SEQONLY(*YES 100)        114717 */
             OVRDBF     FILE(TRANSD) MBR(OTC)                       /* 114717 */
             OVRDBF     FILE(TRSETD) MBR(OTC)                       /* 114717 */
             OVRDBF     FILE(WTRNSD) MBR(OTC)                       /* 114717 */
IF         COND(&ULX008 *EQ 'Y') THEN(DO)                                            /*BUG10453R*/
             OVRDBF     FILE(FFTRX2PD) MBR(OTC)                     /* BUG10453 */
ENDDO                                                                                /*BUG10453R*/
/**/
             CLRPFM     FILE(WTRNSD) MBR(OTC)
/**/
/*     CALL MATURED INSTRUMENT TRADES GENERATION PROGRAM             */
/**/
             CHGJOB     SWS(XXXXX1XX)                                 /*S01117*/
             CALL       PGM(FF0355) PARM('  ')
             CHGJOB     SWS(XXXXX0XX)                                 /*S01117*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(WTRNSLP) MBR(OTC)
             OVRDBF     FILE(WTRNSFP) MBR(OTC)
             OVRDBF     FILE(WTRNSLS) MBR(OTC)
             OVRDBF     FILE(WTRNSFS) MBR(OTC)
             OVRDBF     FILE(CLOSTT) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(CLOSTD) MBR(OTC) SEQONLY(*YES 100)
/**/
/*     CALL CLOSE OUT SET CREATION PROGRAM                           */
/**/
             CALL       PGM(FF0330) PARM('  ')
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(WTRNS1) MBR(OTC)
             OVRDBF     FILE(TRANS) MBR(OTC)
IF         COND(&ULX008 *EQ 'Y') THEN(DO)                                            /*BUG10453R*/
             OVRDBF     FILE(FFTRX2PD) MBR(OTC)                     /* BUG10453 */
ENDDO                                                                                /*BUG10453R*/
/**/
/*     CALL TRANSACTIONS UPDATE PROGRAM                              */
/**/
             CALL       PGM(FF0335)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC     */
/**/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
/**/
 LOOP:       CHGJOB     SWS(X0XXXX00)
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/**/
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET         */
/**/
             OVRDBF     FILE(MATINC) MBR(&MKT)
             OVRDBF     FILE(TRANS6) MBR(&MKT)
             OVRDBF     FILE(TRANSA) MBR(&MKT)
             OVRDBF     FILE(PRICS)  MBR(&MKT)
             OVRDBF     FILE(PRICSD) MBR(&MKT)                        /*137719*/
             OVRDBF     FILE(PRICSA) MBR(&MKT)                        /*137719*/
             OVRDBF     FILE(POSTNC) MBR(&MKT)
             OVRDBF     FILE(POSTNK) MBR(&MKT)
/*           OVRDBF     FILE(TRANSD) MBR(&MKT) SEQONLY(*YES 100)       114717 */
/*           OVRDBF     FILE(TRSETD) MBR(&MKT) SEQONLY(*YES 100)       114717 */
/*           OVRDBF     FILE(WTRNSD) MBR(&MKT) SEQONLY(*YES 100)       114717 */
             OVRDBF     FILE(TRANSD)  MBR(&MKT)                     /* 114717 */
             OVRDBF     FILE(TRSETD) MBR(&MKT)                      /* 114717 */
             OVRDBF     FILE(WTRNSD) MBR(&MKT)                      /* 114717 */
IF         COND(&ULX008 *EQ 'Y') THEN(DO)                                            /*BUG10453R*/
             OVRDBF     FILE(FFTRX2PD) MBR(&MKT)                    /* BUG10453 */
ENDDO                                                                                /*BUG10453R*/
/**/
             CLRPFM     FILE(WTRNSD) MBR(&MKT)
/**/
/*     CALL MATURED INSTRUMENT TRADES GENERATION PROGRAM             */
/**/
             CHGJOB     SWS(XXXXX1XX)                                 /*S01117*/
             CALL       PGM(FF0355) PARM(&MKT)
             CHGJOB     SWS(XXXXX0XX)                                 /*S01117*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(WTRNSLP) MBR(&MKT)
             OVRDBF     FILE(WTRNSFP) MBR(&MKT)
             OVRDBF     FILE(WTRNSLS) MBR(&MKT)
             OVRDBF     FILE(WTRNSFS) MBR(&MKT)
             OVRDBF     FILE(CLOSTT) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(CLOSTD) MBR(&MKT) SEQONLY(*YES 100)
/**/
/*     CALL CLOSE OUT SET CREATION PROGRAM                           */
/**/
             CALL       PGM(FF0330) PARM(&MKT)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(WTRNS1) MBR(&MKT)
             OVRDBF     FILE(TRANS) MBR(&MKT)
IF         COND(&ULX008 *EQ 'Y') THEN(DO)                                            /*BUG10453R*/
             OVRDBF     FILE(FFTRX2PD) MBR(&MKT)                    /* BUG10453 */
ENDDO                                                                                /*BUG10453R*/
/**/
/*     CALL TRANSACTIONS UPDATE PROGRAM                              */
/**/
             CALL       PGM(FF0335)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
/**/
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(LOOP)
/**/
END:
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
/*/COPY WNCPYSRC,FFC0760004                                          */
IF         COND(&ULX008 *NE 'Y') THEN(DO)                                            /*BUG10453R*/
             FFCJRN3    FILES(TRANSA TRANSD TRSETD POSTNCD POSTNKD +
                          CLOSTD CLOSTT)
ENDDO                                                                                /*BUG10453R*/
ELSE       CMD(DO)                                                                   /*BUG10453R*/
             FFCJRN3    FILES(TRANSD TRANSA TRSETD POSTNCD POSTNKD +
                          CLOSTD CLOSTT FFTRX2PD)                                    /*BUG10453R*/
ENDDO                                                                                /*BUG10453R*/
/*/COPY WNCPYSRC,FFC0760005                                          */
/**/
             GOTO       CMDLBL(ENDPGM)                                /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0760 - Trade Generation for Matured +
                          Instruments TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             DMPCLPGM                                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             CHGJOB     SWS(XXXXXX11)                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
                                                                      /*079666*/
ENDPGM:                                                               /*079666*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
