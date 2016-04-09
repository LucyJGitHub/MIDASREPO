/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Position revaluation (COB)')                 */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                        */
/*                                                                   */
/*   FFC0800  -  POSITION REVALUATION (EOC IN COB)                   */
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
/* Midas DBA 3.02 ---------------------------------------------------*/
/*   Prev Amend No. CPB001             Date 15Jun99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  CPM003             Date 02May96                  */
/*                  S71062             DATE 21FEB94                  */
/*                  S01408             DATE 10JAN96                  */
/*                  082461             DATE 08MAR95                  */
/*                  079666             DATE 01DEC94                  */
/*                  S01117             DATE 21JUN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  CCB009 - Journal files throughout close of business              */
/*  CPB001 - Private Banking Module                                  */
/*  CPM003 - FF/PM Interface upgrade to Release 10                   */
/*  S71062 - FF/PM Interface                                         */
/*  S01408 - Addition of core hooks FFC0800001                       */
/*                                  FFC0800002                       */
/*                                  FFC0800003                       */
/*                                  FFC0800004                       */
/*                                  FFC0800005                       */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*  079666 - Add global monitor message processing                   */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
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
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S71062*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S71062*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*S71062*/
             DCL        VAR(&FMT2) TYPE(*CHAR) LEN(800)               /*CPM003*/
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
/* SEND MESSAGE TO MRUNQ                                            */
/**/
             SNDPGMMSG  MSG('FFC0800 - Position +
                          Revaluation') TOMSGQ(MRUNQ)
/**/
/* START JOURNALLING OF ALL UPDATE OR OUTPUT FILES                  */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/FOKEYD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/FOKEYA) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POCHGRC) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POCHGRK) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POSTNCD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POSTNKD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0800001                                          */
/**/                                                                  /*S01408*/
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
/**/
/*  CALL INITIAL JOURNAL PROCESSING FOR SUB-COMPONENT               */
/**/
             FFCJRN2    FILES(FOKEYA FOKEYD POSTNCD POSTNKD POCHGRC +
                              POCHGRK)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0800002                                          */
/**/                                                                  /*S01408*/
/**/
/* PROCESS OTC'S (OVER THE COUNTER TRADES)                          */
/**/
             CHGJOB     SWS(X0XXX000)
/* N.B. U2 SET OFF TO PREVENT MEMOSM UPDATE - NOT REQUIRED IN COB   */
/* N.B. U6 SET OFF TO PREVENT PRONOM UPDATE - NOT REQUIRED IN COB   */
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(POSTNC) MBR(OTC)
             OVRDBF     FILE(POSTNK) MBR(OTC)
             OVRDBF     FILE(WUNRLC) MBR(OTC)
             OVRDBF     FILE(WUNRLK) MBR(OTC)
             OVRDBF     FILE(FOKEYD) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(FOKEYA) MBR(OTC)
             OVRDBF     FILE(POCHGRC) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGRK) MBR(OTC) SEQONLY(*YES 100)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0800003                                          */
/**/                                                                  /*S01408*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S71062*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S71062*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S71062*/
                                                                      /*S71062*/
/*********** IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO) S71062 /*CPB001*/
             IF         COND((%SST(&FMT 65 1) *EQ 'Y') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001*/
/* If Bank Portfolios are supported, treat as if FF off               /*CPM003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CPM003*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CPM003*/
             IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO)        /*CPB001*/
             CALL       PGM(AOPORTR0) PARM(&RTCD &OPTN &FMT2)         /*CPM003*/
             ENDDO                                                    /*CPB001*/
/*********** IF         COND(%SST(&FMT2 112 1) *NE 'B') THEN(DO)CPM003/*CPB001*/
             IF         COND((%SST(&FMT2 112 1) *NE 'B') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001*/
             OVRDBF     FILE(TRANS7) MBR(OTC)                         /*S71062*/
             ENDDO                                                    /*CPM003*/
             ENDDO                                                    /*S71062*/
/**/
/*     CALL POSITION REVALUATION                                     */
/**/
             CALL       PGM(FF0400) PARM('  ')
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/*********** IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO) *S71062**CPM003*/
/*********** IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *NE 'B')) THEN(DO) CPM003/*CPB001*/
             IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *NE 'B') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001*/
             CALL       PGM(FF0401) PARM('  ')                        /*S71062*/
/**/                                                                  /*S71062*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S71062*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S71062*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S71062*/
                 GOTO END                                             /*S71062*/
             ENDDO                                                    /*S71062*/
             ENDDO                                                    /*S71062*/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC     */
/**/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
/**/
 LOOP:       CHGJOB     SWS(X0XXX000)
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/**/
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET         */
/**/
             OVRDBF     FILE(POSTNC) MBR(&MKT)
             OVRDBF     FILE(POSTNK) MBR(&MKT)
             OVRDBF     FILE(WUNRLC) MBR(&MKT)
             OVRDBF     FILE(WUNRLK) MBR(&MKT)
             OVRDBF     FILE(FOKEYD) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(FOKEYA) MBR(&MKT)
             OVRDBF     FILE(POCHGRC) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGRK) MBR(&MKT) SEQONLY(*YES 100)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0800004                                          */
/**/                                                                  /*S01408*/
/*********** IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO) *S71062**CPM003*/
/*********** IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *NE 'B')) THEN(DO) CPM003/*CPB001*/
             IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *NE 'B') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001*/
             OVRDBF     FILE(TRANS7) MBR(&MKT)                        /*S71062*/
             ENDDO                                                    /*S71062*/
/**/
/*     CALL POSITION REVALUATION                                     */
/**/
             CALL       PGM(FF0400) PARM(&MKT)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/*********** IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO) *S71062**CPM003*/
/*********** IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *NE 'B')) THEN(DO) CPM003/*CPB001*/
             IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *NE 'B') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001*/
             CALL       PGM(FF0401) PARM(&MKT)                        /*S71062*/
/**/                                                                  /*S71062*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S71062*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S71062*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S71062*/
                 GOTO END                                             /*S71062*/
             ENDDO                                                    /*S71062*/
             ENDDO                                                    /*S71062*/
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
             FFCJRN3    FILES(FOKEYD FOKEYA POSTNCD POSTNKD POCHGRC +
/**/                          POCHGRK)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0800005                                          */
/**/                                                                  /*S01408*/
             GOTO       CMDLBL(ENDPGM)                                /*079666*/
                                                                      /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0800 - Position + Revaluation +
                          TERMINATED ABNORMALLY') TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*079666*/
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
