/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Gen accnt entries : non EOC (COB)')          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0670  -  GENERATE ACCOUNTING ENTRIES : NON EOC (COB)         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. CCB009             Date 01Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CPB001             Date 15Jun99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/*                      163444             Date 03Aug99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPM003             DATE 02MAY96              */
/*                      076370             DATE 08JAN96              */
/*                      B9582              DATE 08JAN96              */
/*                      082461             DATE 08MAR95              */
/*                      E41892             DATE 25MAR93              */
/*                      S01189             DATE 03JUL90              */
/*                      S01117             DATE 11APR90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   CCB009 - Journal files throughout close of business             */
/*   CPB001 - Private Banking Module                                 */
/*   163444 - Y2K sort order and file allocation.                    */
/*   CPM003 - FF/PM Interface upgrade to Release 10                  */
/*   076370 - With the new FF/PM interface development, A/C keys are */
/*            now generated in all FOKEYD members by the new RPG/    */
/*            FF0521. So RPG/FF0420 must be called for all markets.  */
/*   B9582  - Add a parameter to the call of FF0427 pgm to mean      */
/*              EOC activities or not                                */
/*   082461 - If journalling fails because pgm cannot allocate file, */
/*            retry before failing.                                  */
/*   E41892 - Switch U2 not seton if Retail II OR Interest on        */
/*            Accounts installed, so posting to Suspense Account.    */
/*            (see SUBSR FFSETL)                                     */
/*   S01189  -  COB IMPROVEMENTS PHASE 2                             */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/*********   PGM                                                      /*S01189*/
             PGM        PARM(&NAM &SEQ)                               /*S01189*/
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*           DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &FFSTAT       TYPE(*CHAR)  LEN(256)
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)                 /*S01189*/
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(5 0)                 /*S01189*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)              /*E41892*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)                  /*076370*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)          /*076370*/
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)               /*076370*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*076370*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*076370*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*076370*/
             DCL        VAR(&FMT2) TYPE(*CHAR) LEN(800)               /*CPM003*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,FFC0670001                                          */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*082461*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*082461*/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0670 - Generate +
                          Accounting Entries : Non EOC') TOMSGQ(MRUNQ)
/**/
/* START JOURNALLING OF PF/MGEFFHH, PF/MGEFFPD AND PF/MGEFFZZ       */
/**/
RETRY:                                                                /*082461*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
STRJRNPF   FILE(*LIBL/MGEFFHH) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/MGEFFPD) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
             OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))     /*082461*/
STRJRNPF   FILE(*LIBL/MGEFFZZ) JRN(*LIBL/FFJRN) IMAGES(*BOTH) +
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
             ENDDO                                                    /*CCB009*/
BYPASS:                                                               /*082461*/
/**/
/*  CALL START JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN2    FILES(MGEFFHH MGEFFPD MGEFFZZ)
/**/
/*  OVERRIDE PF/MGEFFPD                                             */
/**/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*076370*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*076370*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*076370*/
                                                                      /*076370*/
/*********** IF         COND(%SST(&FMT 65 1) *NE 'Y') THEN(DO) 076370 /*CPB001*/
             IF         COND((%SST(&FMT 65 1) *NE 'Y') *AND +
                          (%SST(&FMT 104 1) *NE 'Y')) THEN(DO)        /*CPB001*/
             OVRDBF     FILE(MGEFFPD) SEQONLY(*YES 100)
             ENDDO                                                    /*076370*/
/*********** IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO) 076370 /*CPB001*/
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
             OVRDBF     FILE(MGEFFPD) SEQONLY(*YES 100)               /*CPM003*/
             ENDDO                                                    /*CPM003*/
/*********** IF         COND(%SST(&FMT2 112 1) *EQ 'B') THEN(DO)CPM003/*CPB001*/
             IF         COND((%SST(&FMT2 112 1) *EQ 'B') *AND +
                          (%SST(&FMT 104 1) *NE 'Y')) THEN(DO)        /*CPB001*/
             OVRDBF     FILE(MGEFFHH) MBR(OTC)                        /*076370*/
             OVRDBF     FILE(MGEFFPD) MBR(OTC) SEQONLY(*YES 100)      /*076370*/
             OVRDBF     FILE(MGEFFZZ) MBR(OTC)                        /*076370*/
             OVRDBF     FILE(FOKEY) MBR(OTC)                          /*076370*/
             OVRDBF     FILE(FOKEYA) MBR(OTC)                         /*076370*/
             ENDDO                                                    /*CPM003*/
             ENDDO                                                    /*076370*/
/**/
/*  U6 MUST BE ON (FOR FFSETL IN FF0420)                           */
/**/
             CHGJOB     SWS(XXX00100)
/* */                                                                /*E41892*/
/** Test for Retail II or Interest on Accounts                    */ /*E41892*/
/** Seton U2 if present                                           */ /*E41892*/
/* */                                                                /*E41892*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)              /*E41892*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))                 /*E41892*/
/**/
/*   CALL FF0420 - GENERATE ACCOUNTING ENTRIES                      */
/**/
/*/COPY WNCPYSRC,FFC0670002                                          */
             CALL       PGM(FF0420) PARM('  ' 'N' ' ' ' ')
/*/COPY WNCPYSRC,FFC0670003                                          */
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
/* FOR FILE CONTROLS OUT OF BALANCE,SEND MESSAGE TO MOPERQ AND MRUNQ*/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                 SNDPGMMSG  MSG('File Controls Out of Balance - +
                          FFC0670') TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
/* FOR ACCOUNT KEYS MISSING, CHECK FFSTAT POSITION 10 TO SEE IF     */
/* CANCELLATION HAS BEEN REQUESTED                                  */
/**/
             IF         COND(%SWITCH(XXX1XX00)) THEN(DO)
                 RTVDTAARA DTAARA(FFSTAT *ALL) RTNVAR(&FFSTAT)
                 IF         COND((%SST(&FFSTAT 10 1) *EQ 'Y')) THEN(DO)
                     SNDPGMMSG  MSG('Futures/Options A/c Keys Missing +
                             - Processing Continued') TOMSGQ(MRUNQ)
                 ENDDO
                 IF         COND((%SST(&FFSTAT 10 1) *EQ 'N')) THEN(DO)
                     SNDPGMMSG  MSG('Futures/Options A/c Keys Missing +
                             - Processing Halted') TOMSGQ(MOPERQ MRUNQ)
/**/                                                                  /*S01189*/
                      CALL       PGM(CB0175) PARM(&NAM &SEQ)          /*S01189*/
/**/                                                                  /*S01189*/
                     CHGJOB     SWS(XXXXXX1X)
                     GOTO       END                                   /*076370*/
                 ENDDO
             ENDDO
/**/                                                                  /*076370*/
/*      DELETE ALL OVERRIDES                                         * *076370*/
/**/                                                                  /*076370*/
/*********** IF         COND(%SST(&FMT 65 1) *EQ 'Y') THEN(DO)  076370**CPM003*/
/*********** IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *EQ 'B')) THEN(DO) CPM003/*CPB001*/
             IF         COND((%SST(&FMT 65 1) *EQ 'Y') *AND +
                          (%SST(&FMT2 112 1) *EQ 'B') *OR +
                          (%SST(&FMT 104 1) *EQ 'Y')) THEN(DO)        /*CPB001*/
             DLTOVR     FILE(*ALL)                                    /*076370*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*076370*/
/**/                                                                  /*076370*/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC      * *076370*/
/**/                                                                  /*076370*/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)                  /*076370*/
/**/                                                                  /*076370*/
 LOOP:       CHGJOB     SWS(XXX00X00)                                 /*076370*/
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(ENDLOOP))             /*076370*/
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))            /*076370*/
/**/                                                                  /*076370*/
/*  OVERRIDE MULTIMEMBER FILES TO MEMBER FOR EOC MARKET              * *076370*/
/**/                                                                  /*076370*/
             OVRDBF     FILE(MGEFFHH) MBR(&MKT)                       /*076370*/
             OVRDBF     FILE(MGEFFPD) MBR(&MKT) SEQONLY(*YES 100)     /*076370*/
             OVRDBF     FILE(MGEFFZZ) MBR(&MKT)                       /*076370*/
             OVRDBF     FILE(FOKEY) MBR(&MKT)                         /*076370*/
             OVRDBF     FILE(FOKEYA) MBR(&MKT)                        /*076370*/
/**/                                                                  /*076370*/
/*   CALL FF0420 - GENERATE ACCOUNTING ENTRIES                       * *076370*/
/**/                                                                  /*076370*/
/*/COPY WNCPYSRC,FFC0670004                                          */
             CALL       PGM(FF0420) PARM(&MKT 'N' ' ' ' ')            /*076370*/
/*/COPY WNCPYSRC,FFC0670005                                          */
/**/                                                                  /*076370*/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND       * *076370*/
/* MESSAGE TO MOPERQ AND MRUNQ.                                      * *076370*/
/**/                                                                  /*076370*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*076370*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*076370*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*076370*/
                 GOTO END                                             /*076370*/
             ENDDO                                                    /*076370*/
/**/                                                                  /*076370*/
/* FOR FILE CONTROLS OUT OF BALANCE,SEND MESSAGE TO MOPERQ AND MRUNQ * *076370*/
/**/                                                                  /*076370*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*076370*/
                 SNDPGMMSG  MSG('File Controls Out of Balance - +
                          FFC0670') TOMSGQ(MOPERQ MRUNQ)              /*076370*/
                 GOTO END                                             /*076370*/
             ENDDO                                                    /*076370*/
/**/                                                                  /*076370*/
/* FOR ACCOUNT KEYS MISSING, CHECK FFSTAT POSITION 10 TO SEE IF      * *076370*/
/* CANCELLATION HAS BEEN REQUESTED                                   * *076370*/
/**/                                                                  /*076370*/
             IF         COND(%SWITCH(XXX1XX00)) THEN(DO)              /*076370*/
             RTVDTAARA  DTAARA(FFSTAT *ALL) RTNVAR(&FFSTAT)           /*076370*/
                 IF         COND(%SST(&FFSTAT 10 1) *EQ 'Y') THEN(DO) /*076370*/
                 SNDPGMMSG  MSG('Futures/Options A/c Keys Missing (' +
                          *CAT &MKT *CAT ') - Processing +
                          Continued') TOMSGQ(MRUNQ)                   /*076370*/
             ENDDO                                                    /*076370*/
             IF         COND(%SST(&FFSTAT 10 1) *EQ 'N') THEN(DO)     /*076370*/
                 SNDPGMMSG  MSG('Futures/Options A/c Keys Missing (' +
                          *CAT &MKT *CAT ') - Processing Halted') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*076370*/
                 CHGJOB     SWS(XXXXXX1X)                             /*076370*/
                 GOTO       CMDLBL(END)                               /*076370*/
             ENDDO                                                    /*076370*/
             ENDDO                                                    /*076370*/
/**/                                                                  /*076370*/
             CHGVAR     VAR(&A) VALUE(&A + 2)                         /*076370*/
             GOTO       CMDLBL(LOOP)                                  /*076370*/
             ENDDO                                                    /*076370*/
/**/
/*   CALL FF0427 - ACCOUNT KEYS GENERATED TODAY LIST                */
/**/
/*********** CALL       PGM(FF0427) PARM('  ')                       * *B9582 */
/*********** CALL       PGM(FF0427) PARM('  ' 'N')            *B9582 * *076370*/
/***ENDLOOP: CALL       PGM(FF0427) PARM('  ' 'N')            *076370* *163444*/
ENDLOOP:                                                              /*163444*/
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
 AGAIN:      ALCOBJ     OBJ((FFKEY1PD *FILE *EXCL))                   /*163444*/
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
                                                                      /*163444*/
             OPNQRYF    FILE((FOKEY1         )) FORMAT(FFKEY1PD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFKEY1PD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((FOKEY1         )) FORMAT(FFKEY1PD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFKEY1PD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
/**/
             CALL       PGM(FF0427) PARM('  ' 'N')                    /*163444*/
/*********** DLTOVR     FILE(FOKEY1)                                */
             DLCOBJ     OBJ((FFKEY1PD *FILE *EXCL))                   /*163444*/
ENDAGAIN:                                                             /*163444*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
             GOTO       CMDLBL(END)                                   /*082461*/
ABNOR:                                                                /*082461*/
             SNDPGMMSG  MSG('FFC0670 - Generate Accounting Entries : +
                          Non EOC TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             DMPCLPGM                                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
             CHGJOB     SWS(XXXXXX11)                                 /*082461*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
                                                                      /*082461*/
/*      DELETE ALL OVERRIDES                                        */
/**/
END:         DLTOVR     FILE(MGEFFPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(*ALL)                                    /*076370*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*076370*/
             CHGJOB     SWS(XXXXX0XX)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN3    FILES(MGEFFHH MGEFFPD MGEFFZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*082461*/
/* */                                                                /*E41892*/
             CHGJOB     SWS(X0XXXXXX)                                /*E41892*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
