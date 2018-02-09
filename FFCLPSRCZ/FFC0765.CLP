/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Exercise gen. for mat. ins (COB)')           */
/*********************************************************************/
/*                                                                   */
/*   Midas - Futures and Options Module                          */
/*                                                                   */
/*   FFC0765 - EXERCISE GENERATION FOR MATURED INSTRUMENTS           */
/*                                         (EOC IN COB)              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      082461             Date 08Mar95              */
/*                  079666             Date 01Dec94                  */
/*                  S01117             DATE  21MAR90                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  CCB009 - Journal files throughout close of business              */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*  079666 - Add global monitor message processing                   */
/*   S01117 - MULTIBRANCHING                                         */
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
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*                                                                  */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*079666*/
/* SEND MESSAGE TO MRUNQ                                            */
/*                                                                  */
             SNDPGMMSG  MSG('FFC0765 - +
                          Exercise Generation for Matured +
                          Instruments') TOMSGQ(MRUNQ)
/*                                                                  */
/* START JOURNALLING OF ALL UPDATE OR OUTPUT FILES                  */
/*                                                                  */
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
/*/COPY WNCPYSRC,FFC0765001                                          */
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
/*/COPY WNCPYSRC,FFC0765002                                          */
             FFCJRN2    FILES(TRANSA TRANSD TRSETD POSTNCD POSTNKD +
                          CLOSTD CLOSTT)
/*/COPY WNCPYSRC,FFC0765003                                          */
/**/
/* PROCESS OTC'S (OVER THE COUNTER TRADES)                          */
/**/
             CHGJOB     SWS(X0XXX000)
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(MATINE) MBR(OTC)
             OVRDBF     FILE(POSTNC) MBR(OTC)
             OVRDBF     FILE(POSTNK) MBR(OTC)
             OVRDBF     FILE(TRANSA) MBR(OTC)
             OVRDBF     FILE(TRANS6) MBR(OTC)
             OVRDBF     FILE(TRSET) MBR(OTC)
             OVRDBF     FILE(TRANSD) MBR(OTC)
             OVRDBF     FILE(TRSETD) MBR(OTC)
             OVRDBF     FILE(CLOSTD) MBR(OTC)
             OVRDBF     FILE(CLOSTT) MBR(OTC)
/**/
/*     CALL MATURED INSTRUMENT EXERCISES GENERATION PROGRAM          */
/*                                                                   */
             CALL       PGM(FF0350) PARM('  ')
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*               RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
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
             OVRDBF     FILE(MATINE) MBR(&MKT)
             OVRDBF     FILE(POSTNC) MBR(&MKT)
             OVRDBF     FILE(POSTNK) MBR(&MKT)
             OVRDBF     FILE(TRANSA) MBR(&MKT)
             OVRDBF     FILE(TRANS6) MBR(&MKT)
             OVRDBF     FILE(TRSET) MBR(&MKT)
             OVRDBF     FILE(TRANSD) MBR(&MKT)
             OVRDBF     FILE(TRSETD) MBR(&MKT)
             OVRDBF     FILE(CLOSTD) MBR(&MKT)
             OVRDBF     FILE(CLOSTT) MBR(&MKT)
/**/
/*     CALL CLOSE OUT CREATION SHADOW POST                           */
/**/
             CALL       PGM(FF0350) PARM(&MKT)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*               RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
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
/*/COPY WNCPYSRC,FFC0765004                                          */
             FFCJRN3    FILES(TRANSA TRANSD TRSETD POSTNCD POSTNKD +
                          CLOSTD CLOSTT)
/*/COPY WNCPYSRC,FFC0765005                                          */
/**/
             GOTO       CMDLBL(ENDPGM)                                /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0765 - Exercise Generation for +
                          Matured Instruments TERMINATED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             DMPCLPGM                                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             CHGJOB     SWS(XXXXXX11)                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
                                                                      /*079666*/
ENDPGM:                                                               /*079666*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
