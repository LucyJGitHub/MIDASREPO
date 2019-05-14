/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FF Generate accounting entries (COB)')          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0910  -  GENERATE ACCOUNTING ENTRIES (EOC IN COB)            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD020934           Date 11May19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      262523             Date 10Nov09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      222971             Date 26May06              */
/*                  CDL045                 Date 14Feb06              */
/* Midas Plus 1.2 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                  CCB009                 Date 01Jun00              */
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                  163444                 Date 03Aug99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  CPM003                 Date 31Jan96              */
/*                  B9582                  DATE 08JAN96              */
/*                  S01408                 DATE 10OCT95              */
/*                  082461                 DATE 08MAR95              */
/*                  079666                 DATE 01DEC94              */
/*                  062926                 DATE 05/11/93             */
/*                  E41892                 DATE 22FEB93              */
/*                  S01189                 DATE 03JUL90              */
/*                  S01117                 DATE 11APR90              */
/*                                                   Q               */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD020934 - COB component LERC135 failed due to CDL045.      */
/*                  Amend length of field &EXTLIB from 8 to 10 to    */
/*                  avoid truncated library name which causes error. */
/*                  - applied for MD-53322                           */
/*       MD046248 - Finastra Rebranding                              */
/*  262523 - Component FFC0910 failed due to missing account         */
/*           keys. System should only halt the COB (component        */
/*           should not fail) and there will be an option to         */
/*           restart the COB.                                        */
/*  222971 - Move ABNOR processing to before END processing, else    */
/*           file updates not removed if component terminates        */
/*           abnormally so postings will be duplicated.              */
/*  CDL045 - Copy out Account Keys file to Extract library           */
/*           as specified on the System Value parameter              */
/*           'AccountKeysSavedLib'                                   */
/*           Upgrade to Midas Plus 1.2                               */
/*  CCB009 - Journal files throughout close of business              */
/*  163444 - Y2K sort order and file allocation.                     */
/*  CPM003 - Portfolio Management Upgrade to R10                     */
/*  B9582  - Add a parameter in the call of FF0427 pgm to mean       */
/*              EOC activities or not.                               */
/*  S01408 - Apply Core Hooks FFC0910001                             */
/*                            FFC0910002                             */
/*  082461 - If journalling fails because pgm cannot allocate file,  */
/*           retry before failing.                                   */
/*  079666 - Add global monitor message processing                   */
/*       062926 - FF0425 SHOULD BE CALLED IF EOC IS RUN DURING COB   */
/*       E41892 - Switch U2 not seton if Retail II OR Interest on    */
/*                Accounts installed, so posting to Suspense Account.*/
/*                (see SUBSR FFSETL)                                 */
/*   S01189  -  COB IMPROVEMENTS PHASE 2                             */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/*********   PGM                                                      /*S01189*/
             PGM        PARM(&NAM &SEQ)                               /*S01189*/
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)
             DCL        VAR(&FFSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)                 /*S01189*/
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(5 0)                 /*S01189*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)              /*E41892*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)                 /*082461*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*                                                                                        /*CDL045*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CDL045*/
             DCL        VAR(&FOKEY) TYPE(*CHAR) LEN(10)                                   /*CDL045*/
             DCL        VAR(&FOKEY2) TYPE(*CHAR) LEN(10)                                  /*CDL045*/
/**********  DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(8)                       */ /*CDL045 MD020934*/
             DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(10)                                /*MD020934*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*CDL045*/
             DCL        VAR(&CDL045) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CDL045*/
                                                                                          /*CDL045*/
/* Define parameters used in AOSVALR0 to retrieve system value                            /*CDL045*/
/*/COPY SDCPYSRC,SDSVALDCL                                                    */          /*CDL045*/
                                                                                          /*CDL045*/
/*/COPY WNCPYSRC,FFC0910003                                          */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
                                                                                          /*CDL045*/
/** Check if Switchable feature CDL045 ON    */                                           /*CDL045*/
/**/                                                                                      /*CDL045*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CDL045' +
                          &AOFMT)                                                         /*CDL045*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL045) VALUE('Y'))                                        /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&CDL045 *EQ 'Y') THEN(DO)                                    /*CDL045*/
                                                                                          /*CDL045*/
      /* Call AOSVALR0 to get system values for 'AccountKeysSavedLib' */                  /*CDL045*/
                                                                                          /*CDL045*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC  +
                          'AccountKeysSavedLib' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CDL045*/
                                                                                          /*CDL045*/
/* If there is an error finding any system value then end abnormally */                   /*CDL045*/
                                                                                          /*CDL045*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CDL045*/
                                                                                          /*CDL045*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                                /*CDL045*/
                                                                                          /*CDL045*/
/* Set value of extract library */                                                        /*CDL045*/
             CHGVAR     VAR(&EXTLIB) VALUE(%SST(&SVAL1 1 10))                             /*CDL045*/
             CHGVAR     VAR(&FOKEY) VALUE(&PRFX *CAT 'FOKEYD')                            /*CDL045*/
             CHGVAR     VAR(&FOKEY2) VALUE(&PRFX *CAT 'FOKEYD2')                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
                                                                      /*079666*/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0910 - Generate Accounting Entries') +
                          TOMSGQ(MRUNQ)
/**/
/* START JOURNALLING OF PF/MGEFFPD AND PF/MGEFFZZ                   */
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
BYPASS:                                                               /*082461*/
             ENDDO                                                    /*CCB009*/
/**/
/*  CALL START JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN2    FILES(MGEFFHH MGEFFPD MGEFFZZ)
/**/
/*  OVERRIDE MULTIMEMBER FILES TO MEMBER FOR OTC                    */
/**/
             OVRDBF     FILE(MGEFFHH) MBR(OTC)
             OVRDBF     FILE(MGEFFPD) MBR(OTC) SEQONLY(*YES 100)
             OVRDBF     FILE(MGEFFZZ) MBR(OTC)
             OVRDBF     FILE(FOKEY) MBR(OTC)
             OVRDBF     FILE(FOKEYA) MBR(OTC)

/*/COPY WNCPYSRC,FFC0910001                                        */ /*S01408*/

/**/
/*  U6 MUST BE ON (FOR FFSETL IN FF0420)                           */
/**/
             CHGJOB     SWS(XXX00100)
/* */                                                                /*E41892*/
/** Test for Retail II or Interest on Accounts                    */ /*E41892*/
/** (seton U2 if present)                                         */ /*E41892*/
/* */                                                                /*E41892*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)              /*E41892*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))                 /*E41892*/
/**/
/*   CALL FF0420 - GENERATE ACCOUNTING ENTRIES                      */
/**/
/*/COPY WNCPYSRC,FFC0910004                                          */
             CALL       PGM(FF0420) PARM('  ' 'Y' ' ' ' ')
/*/COPY WNCPYSRC,FFC0910005                                          */
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
/**********      GOTO END                                                                 /*222971*/
                 GOTO ABNOR                                                               /*222971*/
             ENDDO
/**/
/* FOR FILE CONTROLS OUT OF BALANCE,SEND MESSAGE TO MOPERQ AND MRUNQ*/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                 SNDPGMMSG  MSG('File Controls Out of Balance - +
                          FFC0910') TOMSGQ(MOPERQ MRUNQ)
/**********      GOTO END                                                                 /*222971*/
                 GOTO ABNOR                                                               /*222971*/
             ENDDO
/**/
/* FOR ACCOUNT KEYS MISSING, CHECK FFSTAT POSITION 10 TO SEE IF     */
/* CANCELLATION HAS BEEN REQUESTED                                  */
/**/
             IF         COND(%SWITCH(XXX1XX00)) THEN(DO)
                 RTVDTAARA DTAARA(FFSTAT *ALL) RTNVAR(&FFSTAT)
                 IF         COND(%SST(&FFSTAT 10 1) *EQ 'Y') THEN(DO)
                     SNDPGMMSG  MSG('Futures/Options A/c Keys Missing (OTC) - +
                              Processing Continued') TOMSGQ(MRUNQ)
                 ENDDO
                 IF         COND((%SST(&FFSTAT 10 1) *EQ 'N')) THEN(DO)
                     SNDPGMMSG  MSG('Futures/Options A/c Keys Missing (OTC) - +
                              Processing Halted') TOMSGQ(MOPERQ MRUNQ)
/**/                                                                  /*S01189*/
                      CALL       PGM(CB0175) PARM(&NAM &SEQ)          /*S01189*/
/**/                                                                  /*S01189*/
/**********          CHGJOB     SWS(XXXXXX1X)                   */                        /*262523*/
/**********          GOTO       END                                                       /*222971*/
/**********          GOTO       ABNOR                           */                 /*222971 262523*/
                     GOTO       END                                                       /*262523*/
                 ENDDO
             ENDDO
                                                                                          /*CDL045*/
/* CDL045 - Copy out Account Keys file(s) to LBBWSOFT library   */                        /*CDL045*/
                                                                                          /*CDL045*/
         IF         COND(&CDL045 *EQ 'Y') THEN(DO)                                        /*CDL045*/
                                                                                          /*CDL045*/
 /* Copy default member OTC */                                                            /*CDL045*/
             CPYF       FROMFILE(FOKEYD) TOFILE(&EXTLIB/&FOKEY) +
                          FROMMBR(*FIRST) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
 /* From member is empty */                                                               /*CDL045*/
             MONMSG     MSGID(CPF2869 CPF2817) EXEC(CLRPFM +
                          FILE(&EXTLIB/&FOKEY) MBR(OTC))                                  /*CDL045*/
 /* To member is empty */                                                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)                                    /*CDL045*/
                                                                                          /*CDL045*/
 /* Clear OTC member in ANWD file */                                                      /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&FOKEY2) MBR(OTC)                                    /*CDL045*/
             MONMSG     MSGID(CPF3142)                 /* File does not exist yet */      /*CDL045*/
                                                                                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/
/**/                                                                  /*062926*/
/*      CALL FF0425 - GENERATED A/C ENTRIES REPORT             */     /*062926*/
/**/                                                                  /*062926*/
             CALL       PGM(FF0425) PARM('  ')                        /*062926*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*062926*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*062926*/
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM) 062926  /*CPM003*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM003*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*062926*/
/***********     GOTO END                                                          /*062926 222971*/
                 GOTO ABNOR                                                               /*222971*/
             ENDDO                                                    /*062926*/
/**/                                                                  /*062926*/
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
 LOOP:       CHGJOB     SWS(XXX00X00)
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(ENDLOOP))
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/**/
/*  OVERRIDE MULTIMEMBER FILES TO MEMBER FOR EOC MARKET             */
/**/
             OVRDBF     FILE(MGEFFHH) MBR(&MKT)
             OVRDBF     FILE(MGEFFPD) MBR(&MKT) SEQONLY(*YES 100)
             OVRDBF     FILE(MGEFFZZ) MBR(&MKT)
             OVRDBF     FILE(FOKEY) MBR(&MKT)
             OVRDBF     FILE(FOKEYA) MBR(&MKT)

/*/COPY WNCPYSRC,FFC0910002                                        */ /*S01408*/

/**/
/*   CALL FF0420 - GENERATE ACCOUNTING ENTRIES                      */
/**/
             CALL       PGM(FF0420) PARM(&MKT 'Y' ' ' ' ')
/*/COPY WNCPYSRC,FFC0910006                                          */
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
/**********      GOTO END                                                                 /*222971*/
                 GOTO ABNOR                                                               /*222971*/
             ENDDO
/**/
/* FOR FILE CONTROLS OUT OF BALANCE,SEND MESSAGE TO MOPERQ AND MRUNQ*/
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                 SNDPGMMSG  MSG('File Controls Out of Balance - +
                          FFC0910') TOMSGQ(MOPERQ MRUNQ)
/**********      GOTO END                                                                 /*222971*/
                 GOTO ABNOR                                                               /*222971*/
             ENDDO
/**/
/* FOR ACCOUNT KEYS MISSING, CHECK FFSTAT POSITION 10 TO SEE IF     */
/* CANCELLATION HAS BEEN REQUESTED                                  */
/**/
             IF         COND(%SWITCH(XXX1XX00)) THEN(DO)
                 RTVDTAARA DTAARA(FFSTAT *ALL) RTNVAR(&FFSTAT)
                 IF         COND((%SST(&FFSTAT 10 1) *EQ 'Y')) THEN(DO)
                     SNDPGMMSG  MSG('Futures/Options A/c Keys Missing (' +
                          *CAT &MKT *CAT ') - Processing +
                          Continued') TOMSGQ(MRUNQ)
                 ENDDO
                 IF         COND((%SST(&FFSTAT 10 1) *EQ 'N')) THEN(DO)
                     SNDPGMMSG  MSG('Futures/Options A/c Keys Missing (' +
                          *CAT &MKT *CAT ') - Processing Halted') +
                          TOMSGQ(MOPERQ MRUNQ)
/**********          CHGJOB     SWS(XXXXXX1X)                   */                        /*262523*/
/**********          GOTO       END                                                       /*222971*/
/**********          GOTO       ABNOR                           */                 /*222971 262523*/
                     CALL       PGM(CB0175) PARM(&NAM &SEQ)                               /*262523*/
                     GOTO       END                                                       /*262523*/
                 ENDDO
             ENDDO
                                                                                          /*CDL045*/
/* CDL045 - Save out account keys file for each market centre  */                         /*CDL045*/
                                                                                          /*CDL045*/
         IF         COND(&CDL045 *EQ 'Y') THEN(DO)                                        /*CDL045*/
                                                                                          /*CDL045*/
             CPYF       FROMFILE(FOKEYD) TOFILE(&EXTLIB/&FOKEY) +
                          FROMMBR(&MKT) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2869 CPF2817) EXEC(CLRPFM +
                          FILE(&EXTLIB/&FOKEY) MBR(&MKT))                                 /*CDL045*/
/*  CLEAR CORRECT MEMBER FOR MARKET FOR MULTI-MEMBER FILES       */                       /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)                                    /*CDL045*/
                                                                                          /*CDL045*/
/* Clear out ANWD files */                                                                /*CDL045*/
                  CLRPFM  FILE(&EXTLIB/&FOKEY2) MBR(&MKT)                                 /*CDL045*/
                  MONMSG     MSGID(CPF3142)                 /* File does not exist yet */ /*CDL045*/
                                                                                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/
/**/                                                                  /*062926*/
/*      CALL FF0425 - GENERATED A/C ENTRIES REPORT                */  /*062926*/
/**/                                                                  /*062926*/
             OVRDBF     FILE(MGEFF) MBR(&MKT)                         /*062926*/
             CALL       PGM(FF0425) PARM(&MKT)                        /*062926*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*062926*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*062926*/
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM) 062926  /*CPM003*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CPM003*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*062926*/
/*********       GOTO END                                                          /*062926 222971*/
                 GOTO ABNOR                                                               /*222971*/
             ENDDO                                                    /*062926*/
/**/                                                                  /*062926*/
/**/
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(LOOP)
/**/
/*   CALL FF0427 - ACCOUNT KEYS GENERATED TODAY LIST                */
/**/
/***ENDLOOP:****CALL       PGM(FF0427) PARM('  ')                     /*B9582 */
/***ENDLOOP:****CALL    PGM(FF0427) PARM('  ' 'Y')          /*B9582*/ /*163444*/
 ENDLOOP:                                                             /*163444*/
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
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

             CALL       PGM(FF0427) PARM('  ' 'Y')                    /*163444*/
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
/**********      GOTO END                                                                 /*222971*/
                 GOTO ABNOR                                                               /*222971*/
             ENDDO
             GOTO       CMDLBL(END)                                                       /*222971*/
ABNOR:                                                                                    /*222971*/
             SNDPGMMSG  MSG('FFC0910 - Generate Accounting Entries +
                          TERMINATED ABNORMALLY') TOMSGQ(MOPERQ +
                          MRUNQ)                                                          /*222971*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*222971*/
             DMPCLPGM                                                                     /*222971*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*222971*/
             CHGJOB     SWS(XXXXXX11)                                                     /*222971*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*222971*/
END:
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXX0XX)
/**/
/*  CALL FINAL JOURNAL PROCESSING FOR SUB-COMPONENT                 */
/**/
             FFCJRN3    FILES(MGEFFHH MGEFFPD MGEFFZZ)
/* */                                                                /*E41892*/
             CHGJOB     SWS(X0XXXXXX)                                /*E41892*/
/**/
/**********  GOTO       CMDLBL(ENDPGM)                                             /*079666 222971*/
/*ABNOR:***                                                                        /*079666 222971*/
/**********  SNDPGMMSG  MSG('FFC0910 - Generate Accounting Entries +
/**********               TERMINATED ABNORMALLY') TOMSGQ(MOPERQ +
/**********               MRUNQ)                                                   /*079666 222971*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                             /*079666 222971*/
/**********  DMPCLPGM                                                              /*079666 222971*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                             /*079666 222971*/
/**********  CHGJOB     SWS(XXXXXX11)                                              /*079666 222971*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                             /*079666 222971*/
                                                                                   /*079666 222971*/
/*ENDPGM**                                                                         /*079666 222971*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
