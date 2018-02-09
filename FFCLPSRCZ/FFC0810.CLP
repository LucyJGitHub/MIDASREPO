/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Close out set a/c key gen. (COB)')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                        */
/*                                                                   */
/*   FFC0810  -  CLOSE OUT SET ACCOUNT KEY GENERATION (EOC IN COB)   */
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
/*                  S01117             DATE 10/04/90                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  CCB009 - Journal files throughout close of business              */
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
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
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
             SNDPGMMSG  MSG('FFC0810 - Close +
                     Out Set Account Key Generation') TOMSGQ(MRUNQ)
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
STRJRNPF   FILE(*LIBL/POCHGTC) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POCHGTK) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POCHGCC) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/POCHGCK) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/CLOSTD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
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
             FFCJRN2    FILES(FOKEYA FOKEYD CLOSTD POCHGCC POCHGCK +
                              POCHGTC POCHGTK)
/**/
/* PROCESS OTC'S (OVER THE COUNTER TRADES)                          */
/**/
             CHGJOB     SWS(XXXXXX00)
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(CLOST1) MBR(OTC)
             OVRDBF     FILE(CLOST4) MBR(OTC)
             OVRDBF     FILE(CLOST5) MBR(OTC)
             OVRDBF     FILE(TRANS) MBR(OTC)
             OVRDBF     FILE(TRSET) MBR(OTC)
             OVRDBF     FILE(FOKEYD) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(FOKEYA) MBR(OTC)
             OVRDBF     FILE(POCHGCC) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGCK) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTC) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTK) MBR(OTC) SEQONLY(*YES 100)
/**/
/*     CALL CLOSE OUT ACCOUNT KEY GENERATION                         */
/**/
             CALL       PGM(FF0410) PARM('  ')
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
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
 LOOP:       CHGJOB     SWS(XXXXXX00)
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/**/
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET         */
/**/
             OVRDBF     FILE(CLOST1) MBR(&MKT)
             OVRDBF     FILE(CLOST4) MBR(&MKT)
             OVRDBF     FILE(CLOST5) MBR(&MKT)
             OVRDBF     FILE(TRANS) MBR(&MKT)
             OVRDBF     FILE(TRSET) MBR(&MKT)
             OVRDBF     FILE(FOKEYD) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(FOKEYA) MBR(&MKT)
             OVRDBF     FILE(POCHGCC) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGCK) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTC) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(POCHGTK) MBR(&MKT) SEQONLY(*YES 100)
/**/
/*     CALL CLOSE OUT ACCOUNT KEY GENERATION                         */
/**/
             CALL       PGM(FF0410) PARM(&MKT)
/**/
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
             FFCJRN3    FILES(FOKEYD FOKEYA CLOSTD POCHGCC POCHGCK +
/**/                          POCHGTC POCHGTK)
             GOTO       CMDLBL(ENDPGM)                                /*079666*/
                                                                      /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0810 - Close Out Set Account Key +
                          Generation TERMINATED ABNORMALLY') +
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
