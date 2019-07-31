/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Autoclosure (COB)')                          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                        */
/*                                                                   */
/*   FFC0740  -  AUTOCLOSURE (EOC IN COB)                            */
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
/*                  S01117             DATE 15MAR90                  */
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
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(3)
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
             SNDPGMMSG  MSG('FFC0740 - Autoclosure ') TOMSGQ(MRUNQ)
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
STRJRNPF   FILE(*LIBL/CLOSTT) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/TRANSD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
/*/COPY WNCPYSRC,FFC0740001                                          */
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
/*/COPY WNCPYSRC,FFC0740002                                          */
             FFCJRN2    FILES(CLOSTD CLOSTT TRANSD)
/*/COPY WNCPYSRC,FFC0740003                                          */
/**/
/* PROCESS OTC'S BEFORE MARKET CENTRES                              */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
             OVRDBF     FILE(TRANS5) MBR(OTC)
             OVRDBF     FILE(WTRNSD) MBR(OTC) SEQONLY(*YES 100)
/**/
             CLRPFM     FILE(WTRNSD) MBR(OTC)
/**/
/*     CALL EXTRACT PROGRAM                                          */
/**/
             CALL       PGM(FF0325) PARM('  ')
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
/*                                         INPUT                     */
/**/
             OVRDBF     FILE(WTRNSLP) MBR(OTC)
             OVRDBF     FILE(WTRNSFP) MBR(OTC)
             OVRDBF     FILE(WTRNSLS) MBR(OTC)
             OVRDBF     FILE(WTRNSFS) MBR(OTC)
/**/
/*                                         OUTPUT                    */
/**/
             OVRDBF     FILE(CLOSTT) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(CLOSTD) MBR(OTC) SEQONLY(*YES 100)
/**/
/*     CALL CLOSE OUT SET CREATION PROGRAM                           */
/**/
             CALL       PGM(FF0330) PARM('   ')
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
/*                                         INPUT                     */
/**/
             OVRDBF     FILE(WTRNS1) MBR(OTC)
/**/
/*                                         OUTPUT                    */
/**/
             OVRDBF     FILE(TRANS) MBR(OTC)
/**/
/*     CALL TRANSACTIONS UPDATE PROGRAM                              */
/**/
             CALL       PGM(FF0335)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
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
/*  OVERRIDE TO CORRECT MARKET          - INPUT                     */
/**/
             OVRDBF     FILE(TRANS5) MBR(&MKT)
/**/
/*                                         OUTPUT                    */
/**/
             OVRDBF     FILE(WTRNSD) MBR(&MKT) SEQONLY(*YES 100)
/**/
             CLRPFM     FILE(WTRNSD) MBR(&MKT)
/**/
/*     CALL EXTRACT PROGRAM                                          */
/**/
             CALL       PGM(FF0325) PARM(&MKT)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
/*                                         INPUT                     */
/**/
             OVRDBF     FILE(WTRNSLP) MBR(&MKT)
             OVRDBF     FILE(WTRNSFP) MBR(&MKT)
             OVRDBF     FILE(WTRNSLS) MBR(&MKT)
             OVRDBF     FILE(WTRNSFS) MBR(&MKT)
/**/
/*                                         OUTPUT                    */
/**/
             OVRDBF     FILE(CLOSTT) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(CLOSTD) MBR(&MKT) SEQONLY(*YES 100)
/**/
/*     CALL CLOSE OUT SET CREATION PROGRAM                           */
/**/
             CALL       PGM(FF0330) PARM(&MKT)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
/*                                         INPUT                     */
/**/
             OVRDBF     FILE(WTRNS1) MBR(&MKT)
/**/
/*                                         OUTPUT                    */
/**/
             OVRDBF     FILE(TRANS) MBR(&MKT)
/**/
/*     CALL TRANSACTIONS UPDATE PROGRAM                              */
/**/
             CALL       PGM(FF0335)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(LOOP)
/**/
DBERR:
/*               RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
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
/*/COPY WNCPYSRC,FFC0740004                                          */
             FFCJRN3    FILES(CLOSTD CLOSTT TRANSD)
/*/COPY WNCPYSRC,FFC0740005                                          */
/**/
             GOTO       CMDLBL(ENDPGM)                                /*079666*/
                                                                      /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0740 - Autoclosure (EOC in COB) +
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
                          Finastra International Limited')
             ENDPGM
