/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Close out revrsl shadow post (COB)')         */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                        */
/*                                                                   */
/*   FFC0730  -  CLOSE OUT SET REVERSAL SHADOW POSTING (EOC IN COB)  */
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
/*                      CPK009             Date 09Aug99              */
/*                  082461             Date 08Mar95                  */
/*                  079666             DATE 01DEC94                  */
/*                  S01117             DATE 15MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  CCB009 - Journal files throughout close of business              */
/*  CPK009 - Packaging for DBA3 release. STRCMTCTL values set        */
/*           to CMTSCOPE(*JOB).                                      */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*  079666 - Add global monitor message processing                   */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/*                                                                  */
             PGM
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RCD) TYPE(*DEC)  LEN(1 0)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
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
             SNDPGMMSG  MSG('FFC0730 - Close +
                          Out Reversal Shadow Posting') TOMSGQ(MRUNQ)
/**/
/* START JOURNALLING OF ALL UPDATE OR OUTPUT FILES                  */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/CLOSTD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/TRANSD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/TRSETD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
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
             FFCJRN2    FILES(CLOSTD TRANSD TRSETD POSTNCD POSTNKD)
/**/
/* PROCESS OTC'S (OVER THE COUNTER TRADES)                          */
/**/
             CHGJOB     SWS(X0XXX000)
/* N.B. U2 SET OFF TO PREVENT MEMOSM UPDATE - NOT REQUIRED IN COB   */
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(CLOST3) MBR(OTC)
             OVRDBF     FILE(CLOST4) MBR(OTC)
             OVRDBF     FILE(CLOST5) MBR(OTC)
             OVRDBF     FILE(TRANSP) TOFILE(TRANS) MBR(OTC) SHARE(*NO)
             OVRDBF     FILE(TRANSS) TOFILE(TRANS) MBR(OTC) SHARE(*NO)
             OVRDBF     FILE(TRSETP) TOFILE(TRSET) MBR(OTC) SHARE(*NO)
             OVRDBF     FILE(TRSETS) TOFILE(TRSET) MBR(OTC) SHARE(*NO)
             OVRDBF     FILE(POSTNC) MBR(OTC)
             OVRDBF     FILE(POSTNK) MBR(OTC)
/**/
/*     OTHER OVERRIDES - ACTIVE THROUGHOUT PROGRAM                   */
/**/
             OVRDBF     FILE(FOCLTB) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF     FILE(FOCLTC) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF     FILE(DEFLTB) TOFILE(DEFLT) SHARE(*NO)
             OVRDBF     FILE(DEFLTC) TOFILE(DEFLT) SHARE(*NO)
/**/
/*     CALL CLOSE OUT REVERSAL SHADOW POST                           */
/**/
/*********  STRCMTCTL  LCKLVL(*CHG)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                  /*CPK009*/
             MONMSG     MSGID(CPF8351)
             CALL       PGM(FF0320) PARM('  ' &RCD)
/**/
             ENDCMTCTL
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
             DLTOVR     FILE(CLOST3 CLOST4 CLOST5 TRSETP TRSETS +
                          TRANSP TRANSS POSTNC POSTNK)
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
             OVRDBF     FILE(CLOST3) MBR(&MKT)
             OVRDBF     FILE(CLOST4) MBR(&MKT)
             OVRDBF     FILE(CLOST5) MBR(&MKT)
             OVRDBF     FILE(TRANSP) TOFILE(TRANS) MBR(&MKT) SHARE(*NO)
             OVRDBF     FILE(TRANSS) TOFILE(TRANS) MBR(&MKT) SHARE(*NO)
             OVRDBF     FILE(TRSETP) TOFILE(TRSET) MBR(&MKT) SHARE(*NO)
             OVRDBF     FILE(TRSETS) TOFILE(TRSET) MBR(&MKT) SHARE(*NO)
             OVRDBF     FILE(POSTNC) MBR(&MKT)
             OVRDBF     FILE(POSTNK) MBR(&MKT)
/**/
/*     CALL CLOSE OUT REVERSAL SHADOW POST                           */
/**/
/*********  STRCMTCTL  LCKLVL(*CHG)                                  /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                  /*CPK009*/
             MONMSG     MSGID(CPF8351)
             CALL       PGM(FF0320) PARM(&MKT &RCD)
/**/
             ENDCMTCTL
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
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
             FFCJRN3    FILES(CLOSTD TRANSD TRSETD POSTNCD POSTNKD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
/**/
             GOTO       CMDLBL(ENDPGM)                                /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0730 - Close Out Reversal Shadow +
                          Posting TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*079666*/
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
