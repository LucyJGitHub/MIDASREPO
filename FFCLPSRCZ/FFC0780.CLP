/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Trans. update phase I (COB)')                */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                        */
/*                                                                   */
/*   FFC0780  -  TRANSACTIONS UPDATE PHASE I  (EOC IN COB)           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 222165             Date 26MAY06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       PREV Amend No. CFF007             Date 13Feb01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 10Oct95              */
/*                  082461             Date 08Mar95                  */
/*                  079666             DATE 01DEC94                  */
/*                  S01117             DATE 19APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       222165 - Fix to avoid reversal of comms & charges twice.    */
/*       CFF007 - Futures and Options Enhancement for Private Banking*/
/*  CCB009 - Journal files throughout close of business              */
/*  S01408 - Apply Core Hooks FFC0780INT                             */
/*                            FFC0780001                             */
/*                            FFC0780002                             */
/*                            FFC0780003                             */
/*                            FFC0780004                             */
/*                            FFC0780005                             */
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
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CFF007*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CFF007*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CFF007*/
             DCL        VAR(&CFF007) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CFF007*/
/**/
 
/*/COPY WNCPYSRC,FFC0780INT                                        */ /*S01408*/
 
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
             SNDPGMMSG  MSG('FFC0780 - +
                          Transactions Update Phase I') TOMSGQ(MRUNQ)
 
/**/                                                                                      /*CFF007*/
/** Check for Switchable feature CFF007                                                   /*CFF007*/
/**/                                                                                      /*CFF007*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CFF007*/
             CHGVAR     VAR(&SARD) VALUE('CFF007')                                        /*CFF007*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD +
                                           &AOFMT)                                        /*CFF007*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CFF007) VALUE('Y'))                                        /*CFF007*/
/*/COPY WNCPYSRC,FFC0780001                                        */ /*S01408*/
 
/**/
/* START JOURNALLING OF ALL UPDATE OR OUTPUT FILES                  */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/POCHGTC) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POCHGTK) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/TRSETD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
             STRJRNPF   FILE(*LIBL/FFCOCHPD) JRN(*LIBL/FFJRN) +
                          IMAGES(*BOTH) OMTJRNE(*OPNCLO)                                  /*CFF007*/
             MONMSG     MSGID(CPF7030)                                                    /*CFF007*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                         /*CFF007*/
/*/COPY WNCPYSRC,FFC0780006                                          */
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
/*/COPY WNCPYSRC,FFC0780007                                          */
/**/
/**********  FFCJRN2    FILES(POCHGTC POCHGTK TRSETD) */                                  /*CFF007*/
             FFCJRN2    FILES(POCHGTC POCHGTK TRSETD FFCOCHPD)                            /*CF0007*/
/*/COPY WNCPYSRC,FFC0780008                                          */
/**/
/* PROCESS OTC'S (OVER THE COUNTER TRADES)                          */
/**/
/*      U2 SET OFF TO PREVENT MEMOSM UPDATE - NOT REQUIRED IN COB.  */
/**/
             CHGJOB     SWS(X0XXX000)
/**/
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
 
/*/COPY WNCPYSRC,FFC0780002                                        */ /*S01408*/
 
             IF         COND(&CFF007 *EQ 'Y') THEN(OVRDBF +
                          FILE(TRANS12) MBR(OTC))                                         /*CFF007*/
             OVRDBF     FILE(TRANS3) MBR(OTC)
             OVRDBF     FILE(TRSET) MBR(OTC)
             OVRDBF     FILE(FOKEYA) MBR(OTC)
             OVRDBF     FILE(FOKEYD) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTC) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTK) MBR(OTC) SEQONLY(*YES 100)
/**/
/* CLEAR FOKEY FILES THEN INITIALISE AUDIT FILE BEFORE RUNNING      */
/**/
             CLRPFM     FILE(FOKEYD) MBR(OTC)
             CLRPFM     FILE(FOKEYA) MBR(OTC)
             CLRPFM     FILE(CCREVPD)                                                     /*222165*/
             INZPFM     FILE(FOKEYA) MBR(OTC) TOTRCDS(1)
/**/
/*     CALL TRANSACTIONS UPDATE PHASE 1                              */
/**/
             CALL       PGM(FF0380) PARM('  ')
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
 
             IF         COND(&CFF007 *EQ 'Y') THEN(DO)                                    /*CFF007*/
             CALL       PGM(FF000381) PARM('  ')                                          /*CFF007*/
/**/                                                                                      /*CFF007*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CFF007*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                             /*CFF007*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CFF007*/
                 GOTO END                                                                 /*CFF007*/
             ENDDO                                                                        /*CFF007*/
             ENDDO                                                                        /*CFF007*/
/*/COPY WNCPYSRC,FFC0780003                                        */ /*S01408*/
 
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
 
/*/COPY WNCPYSRC,FFC0780004                                        */ /*S01408*/
 
             IF         COND(&CFF007 *EQ 'Y') THEN(OVRDBF +
                          FILE(TRANS12) MBR(&MKT))                                        /*CFF007*/
             OVRDBF     FILE(TRANS3) MBR(&MKT)
             OVRDBF     FILE(TRSET) MBR(&MKT)
             OVRDBF     FILE(FOKEYA) MBR(&MKT)
             OVRDBF     FILE(FOKEYD) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTC) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTK) MBR(&MKT) SEQONLY(*YES 100)
/**/
/* CLEAR FOKEY FILES THEN INITIALISE AUDIT FILE BEFORE RUNNING      */
/**/
             CLRPFM     FILE(FOKEYD) MBR(&MKT)
             CLRPFM     FILE(FOKEYA) MBR(&MKT)
             INZPFM     FILE(FOKEYA) MBR(&MKT) TOTRCDS(1)
/**/
/*     CALL TRANSACTIONS UPDATE PHASE 1                              */
/**/
             CALL       PGM(FF0380) PARM(&MKT)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
 
             IF         COND(&CFF007 *EQ 'Y') THEN(DO)                                    /*CFF007*/
             CALL       PGM(FF000381) PARM(&MKT)                                          /*CFF007*/
/**/                                                                                      /*CFF007*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CFF007*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                             /*CFF007*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CFF007*/
                 GOTO END                                                                 /*CFF007*/
             ENDDO                                                                        /*CFF007*/
             ENDDO                                                                        /*CFF007*/
/*/COPY WNCPYSRC,FFC0780005                                        */ /*S01408*/
 
/**/
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(LOOP)
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
END:         DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/*/COPY WNCPYSRC,FFC0780009                                          */
/**/
/**********  FFCJRN3    FILES(POCHGTC POCHGTK TRSETD) */                                  /*CFF007*/
             FFCJRN3    FILES(POCHGTC POCHGTK TRSETD FFCOCHPD)                            /*CF0007*/
/*/COPY WNCPYSRC,FFC0780010                                          */
/**/
             GOTO       CMDLBL(ENDPGM)                                /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0780 - Transactions Update Phase I +
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
