/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Gen accrual entries in ANWD (COB)')          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0675  -  GENERATE ACCRUAL ACCOUNTING ENTRIES FOR ANWD (COB)  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL045             Date 14Feb06              */
/* Midas Plus 1.2 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      163444             Date 03Aug99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      109562             DATE 01NOV96              */
/*                      E41892             DATE 25MAR93              */
/*                      S01189             DATE 03JUL90              */
/*                      S01117             DATE 11APR90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   CDL045 - Copy out Account Keys file to Extract library          */
/*            as specified on the System Value parameter             */
/*            'AccountKeysSavedLib'                                  */
/*            Upgrade to Midas Plus 1.2.                             */
/*   163444 - Y2K sort order and file allocation.                    */
/*   109562 - Correct parameters to FF0427                           */
/*       E41892 - Switch U2 not seton if Retail II OR Interest on    */
/*                Accounts installed, so posting to Suspense Account */
/*                (see SUBSR FFSETL)                                 */
/*   S01189  -  COB IMPROVEMENTS PHASE 2                             */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/*********   PGM                                                      /*S01189*/
             PGM        PARM(&NAM &SEQ)                               /*S01189*/
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &FFSTAT       TYPE(*CHAR)  LEN(256)
             DCL        VAR(&NAM) TYPE(*CHAR) LEN(10)                 /*S01189*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(5 0)                 /*S01189*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)              /*E41892*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                                                                                          /*CDL045*/
             DCL        VAR(&FOKEY) TYPE(*CHAR) LEN(10)                                   /*CDL045*/
             DCL        VAR(&EXTLIB) TYPE(*CHAR) LEN(8)                                   /*CDL045*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*CDL045*/
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)                                   /*CDL045*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)                              /*CDL045*/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)                                      /*CDL045*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CDL045*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CDL045*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                          /*CDL045*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CDL045*/
             DCL        VAR(&CDL045) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CDL045*/
                                                                                          /*CDL045*/
/* Define parameters used in AOSVALR0 to retrieve system value                            /*CDL045*/
/*/COPY SDCPYSRC,SDSVALDCL                                                    */          /*CDL045*/
                                                                                          /*CDL045*/
/**/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0675 - Generate +
                          Accrual Accounting Entries for ANWD') +
                          TOMSGQ(MRUNQ)
                                                                                          /*CDL045*/
/** Check for Switchable feature CDL045                            */                     /*CDL045*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CDL045*/
             CHGVAR     VAR(&SARD) VALUE('CDL045')                                        /*CDL045*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)                        /*CDL045*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDL045) VALUE('Y'))                                        /*CDL045*/
                                                                                          /*CDL045*/
/**/
/* CLEAR MGEFF2 FILES                                               */
/**/
             CLRPFM     FILE(GEFF2HH)
             CLRPFM     FILE(GEFF2PD)
             CLRPFM     FILE(GEFF2ZZ)
/**/
/*  OVERRIDE PF/MGEFFHH, PF/MGEFFPD AND PF/MGEFFZZ                  */
/**/
             OVRDBF     FILE(MGEFFHH) TOFILE(GEFF2HH)
             OVRDBF     FILE(MGEFFPD) TOFILE(GEFF2PD) +
                          SEQONLY(*YES 100)
             OVRDBF     FILE(MGEFFZZ) TOFILE(GEFF2ZZ)
/**/
/*  U6 MUST BE ON (FOR FFSETL IN FF0420)                           */
/**/
             CHGJOB     SWS(XXX00100)
/**/
/* */                                                                /*E41892*/
/** Test if Retail II or Interest on Accounts                     */ /*E41892*/
/** Seton U2 if present                                           */ /*E41892*/
/* */                                                                /*E41892*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)              /*E41892*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))                 /*E41892*/
/*   CALL FF0420 - GENERATE ACCOUNTING ENTRIES                      */
/**/
             CALL       PGM(FF0420) PARM('  ' 'N' ' ' ' ')
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
                          FFC0675') TOMSGQ(MOPERQ MRUNQ)
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
                     CALL       PGM(CB0175) PARM(&NAM &SEQ)           /*S01189*/
/**/                                                                  /*S01189*/
                     CHGJOB     SWS(XXXXXX1X)
                 ENDDO
             ENDDO
/**/                                                                                      /*CDL045*/
                                                                                          /*CDL045*/
/* CDL045 - Copy out Account Keys file(s) to Extract library   */                         /*CDL045*/
                                                                                          /*CDL045*/
         IF         COND(&CDL045 *EQ 'Y') THEN(DO)                                        /*CDL045*/
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
                          CMDLBL(ENDAGAIN))                                               /*CDL045*/
                                                                                          /*CDL045*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRFX)                                /*CDL045*/
                                                                                          /*CDL045*/
/* Set value of extract library */                                                        /*CDL045*/
             CHGVAR     VAR(&EXTLIB) VALUE(%SST(&SVAL1 1 10))                             /*CDL045*/
             CHGVAR     VAR(&FOKEY) VALUE(&PRFX *CAT 'FOKEYD2')                           /*CDL045*/
                                                                                          /*CDL045*/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)                                      /*CDL045*/
                                                                                          /*CDL045*/
 /* Copy default member OTC */                                                            /*CDL045*/
             CPYF       FROMFILE(FOKEYD) TOFILE(&EXTLIB/&FOKEY) +
                          FROMMBR(*FIRST) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
 /* From member is empty */                                                               /*CDL045*/
             MONMSG     MSGID(CPF2869 CPF2817) EXEC(DO)                                   /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&FOKEY) MBR(*FIRST)                                  /*CDL045*/
 /* To member is empty */                                                                 /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)                                    /*CDL045*/
                   ENDDO                                                                  /*CDL045*/
                                                                                          /*CDL045*/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC  */                       /*CDL045*/
                                                                                          /*CDL045*/
  LOOP:                                                                                   /*CDL045*/
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A +
                          *GT 61)) THEN(GOTO CMDLBL(NEXT))                                /*CDL045*/
                                                                                          /*CDL045*/
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))                                /*CDL045*/
             CPYF       FROMFILE(FOKEYD) TOFILE(&EXTLIB/&FOKEY) +
                          FROMMBR(&MKT) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)                                  /*CDL045*/
             MONMSG     MSGID(CPF2869 CPF2817) EXEC(DO)                                   /*CDL045*/
                                                                                          /*CDL045*/
/*  CLEAR CORRECT MEMBER FOR MARKET FOR MULTI-MEMBER FILES       */                       /*CDL045*/
             CLRPFM     FILE(&EXTLIB/&FOKEY) MBR(&MKT)                                    /*CDL045*/
             MONMSG     MSGID(CPF2870 CPF2817 CPF2869)                                    /*CDL045*/
             ENDDO                                                                        /*CDL045*/
                                                                                          /*CDL045*/
             CHGVAR     VAR(&A) VALUE(&A + 2)                                             /*CDL045*/
             GOTO       CMDLBL(LOOP)                                                      /*CDL045*/
                                                                                          /*CDL045*/
         ENDDO                                                                            /*CDL045*/
                                                                                          /*CDL045*/
    NEXT:                                                                                 /*CDL045*/
                                                                                          /*CDL045*/
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
/*   CALL FF0427 - ACCOUNT KEYS GENERATED TODAY LIST                */
/**/
/************CALL       PGM(FF0427) PARM('  ')                        /*109562*/
             CALL       PGM(FF0427) PARM('  ' 'N')                    /*109562*/
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
/*      DELETE ALL OVERRIDES                                        */
/**/
END:         DLTOVR     FILE(MGEFFHH)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MGEFFPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(MGEFFZZ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXX0XX)
/* */                                                                /*E41892*/
             CHGJOB     SWS(X0XXXXXX)                                /*E41892*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
