/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Trans. input today report (COB)')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0850  -  TRANSACTIONS INPUT TODAY REPORT (EOC IN COB)        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*   Last Amend No. CCB009             Date 01Jun00                  */
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*   Prev Amend No. 163444             Date 06Aug99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  S01522             Date 16May95                  */
/*                  082461             DATE 08MAR95                  */
/*                  079666             DATE 01DEC94                  */
/*                  S01117             DATE 23APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  CCB009 - Journal files throughout close of business              */
/*  163444 - Y2K sort order and file allocation.                     */
/*  S01522 - User Defined Correspondence                             */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*  079666 - Add global monitor message processing                   */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)             /*S01522*/
             DCL        VAR(&OPTION)  TYPE(*CHAR) LEN(7)              /*S01522*/
             DCL        VAR(&FMT)     TYPE(*CHAR) LEN(200)            /*S01522*/
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(50)             /*S01522*/
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
/* SEND MESSAGE TO MRUNQ                                            */
/**/
             SNDPGMMSG  MSG('FFC0850 - +
                          Transactions Input Today Report') +
                          TOMSGQ(MRUNQ)
 
/** Access PF/SDMMODPD to determine whether UDC module is on            S01522*/
             CHGVAR     VAR(&RTN_CODE) VALUE('       ')               /*S01522*/
             CHGVAR     VAR(&OPTION) VALUE('*FIRST ')                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTN_CODE &OPTION &FMT)    /*S01522*/
 
/** Database error handling                                             S01522*/
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)        /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('Error on access to ICD file +
                          SDMMODPD')                                  /*S01522*/
             GOTO       CMDLBL(ABNOR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
/**/
/* START JOURNALLING OF ALL UPDATE OR OUTPUT FILES                  */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/TRANSA) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
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
             FFCJRN2    FILES(TRANSA)
/**/
/* PROCESS OTC'S (OVER THE COUNTER TRADES)                          */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(TRANS7) MBR(OTC)
             OVRDBF     FILE(TRSET) MBR(OTC)
             OVRDBF     FILE(TRANSA) MBR(OTC)
/*/COPY WNCPYSRC,FFC0850001                                          */
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
 AGAIN:      ALCOBJ     OBJ((FFTRANPD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIX) VALUE(&SIX + 1)                     /*163444*/
             IF         COND(&SIX *LE 6) THEN(GOTO CMDLBL(AGAIN))     /*163444*/
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDAGAIN)                              /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
             OPNQRYF    FILE((TRANS7         )) FORMAT(FFTRANPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFTRANPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((TRANS7         )) FORMAT(FFTRANPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFTRANPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
 
/**/
/*     CALL TRANSACTIONS INPUT TODAY REPORT                          */
/**/
/*********** CALL       PGM(FF1020) PARM('  ')                     */ /*S01117*/
             CALL       PGM(FF1020) PARM('  ' '     ' 'ALL')          /*S01117*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                 SNDPGMMSG  MSG('File Controls Out of Balance - +
                          FFC0850 - OTC') TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/*                                                                      S01522*/
/**  If UDC is active Extract Transactions Actioned Today               S01522*/
  IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                  /*S01522*/
             OVRDBF     FILE(TRANS) MBR(OTC)                          /*S01522*/
                                                                      /*S01522*/
             CALL       PGM(CG4604) PARM(' ' '  ' 'ALL')              /*S01522*/
                                                                      /*S01522*/
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)        /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')                           /*S01522*/
             ROLLBACK                                                 /*S01522*/
             GOTO       CMDLBL(ABNOR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
   ENDDO                                                              /*S01522*/
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
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET         */
/**/
             OVRDBF     FILE(TRANS7) MBR(&MKT)
             OVRDBF     FILE(TRSET) MBR(&MKT)
             OVRDBF     FILE(TRANSA) MBR(&MKT)
/*/COPY WNCPYSRC,FFC0850002                                          */
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
             OPNQRYF    FILE((TRANS7         )) FORMAT(FFTRANPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFTRANPD) +
                          MBROPT(*REPLACE)
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((TRANS7         )) FORMAT(FFTRANPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFTRANPD) +
                          MBROPT(*ADD)
             CLOF       OPNID(Q1)                                     /*163444*/
 
/**/
/*     CALL TRANSACTIONS INPUT TODAY REPORT                          */
/**/
/*********** CALL       PGM(FF1020) PARM(&MKT)                     */ /*S01117*/
             CALL       PGM(FF1020) PARM(&MKT '     ' 'ALL')          /*S01117*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                 SNDPGMMSG  MSG('File Controls Out of Balance - +
                          FFC0850 - ' *BCAT &MKT) TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/*                                                                      S01522*/
/**  If UDC is active Extract Transactions Actioned Today               S01522*/
  IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                  /*S01522*/
                                                                      /*S01522*/
             OVRDBF     FILE(TRANS) MBR(&MKT)                         /*S01522*/
             CALL       PGM(CG4604) PARM(' ' &MKT 'ALL')              /*S01522*/
                                                                      /*S01522*/
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)        /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')                           /*S01522*/
             ROLLBACK                                                 /*S01522*/
             GOTO       CMDLBL(ABNOR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
   ENDDO                                                              /*S01522*/
/**/
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(LOOP)
/**/
END:
/**/
             DLCOBJ     OBJ((FFTRANPD *FILE *EXCL))                   /*163444*/
ENDAGAIN:                                                             /*163444*/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN3    FILES(TRANSA)
/**/
             GOTO       CMDLBL(ENDPGM)                                /*079666*/
                                                                      /*079666*/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0850 - Transactions Input Today +
                          Report TERMINATED ABNORMALLY') +
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
