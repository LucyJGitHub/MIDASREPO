/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Calc Precious Metal A/C Balances')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                   */
/*                                                                   */
/*       CL/SEC6410 - Calculate Precious Metal Account Balances      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 096390             Date 09Jul96              */
/*                      091522             Date 16Aug95              */
/*                      S01464             Date 04APR94              */
/*                      049421     BZ      DATE 19JAN93              */
/*                      SESCS              DATE 28AUG92              */
/*                      B5737      SCO     DATE 25MAR91              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       096390 - Non-retail precious metal accounts were excluded   */
/*                by B5737 - remove the check on account type 'R'.   */
/*       091522 - Safe Custody Fees - Private Banking (CSE001)       */
/*       S01464 - Safe Custody Fees                                  */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       SESCS  - SAFE CUSTODY FEES SWITCHABLE                       */
/*       B5737  - ONLY  INCLUDE RETAIL ACCOUNTS                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ANWD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                 /*S01464*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01464*/
             DCL        VAR(&ANWD) TYPE(*CHAR) LEN(1)
/* >>> SESCS >>> */
/************DCL        VAR(&SCSW) TYPE(*CHAR) LEN(1)                 /*S01464*/
             DCL        VAR(&SCAC) TYPE(*CHAR) LEN(1)
/* <<< SESCS <<< */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) +
                          VALUE('       ')                            /*S01464*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*FIRST ')                            /*S01464*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(800)                /*S01464*/
 
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))
 
/* >>> SESCS >>> */
/************RTVDTAARA  DTAARA(LZSTAT (28 1)) RTNVAR(&SCSW)           /*S01464*/
/************IF         COND(&SCSW *EQ 'Y') THEN(DO)                  /*S01464*/
/************                                                         /*S01464*/
/**CHECK*WHETHER*ACCRUALS*PROCESSING*TO*BE*RUN*TODAY****************/ /*S01464*/
/************RTVDTAARA  DTAARA(SESTAT (74 1)) RTNVAR(&SCAC)           /*S01464*/
/* */                                                                 /*S01464*/
/* Check Safe Custody Fees flag on Securities Trading ICD          */ /*S01464*/
/* */                                                                 /*S01464*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*S01464*/
/* */                                                                 /*S01464*/
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)                    /*S01464*/
/* */                                                                 /*S01464*/
/* Check whether accruals processing to be run today               */ /*S01464*/
/* */                                                                 /*S01464*/
             RTVDTAARA  DTAARA(SESTAT (78 1)) RTNVAR(&SCAC)           /*S01464*/
             IF         COND(&SCAC *NE 'Y') THEN(GOTO +
                          CMDLBL(END))
/* <<< SESCS <<< */
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
/**/
/*  SET OFF SWITCHES:                                                         */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('SEC6410 - Calculate precious metal +
                          account balances') TOMSGQ(MRUNQ) +
                          MSGTYPE(*INFO)
/**/
/** CALCULATE PRECIOUS METAL ACCOUNT BALANCES */
/************CLRPFM     FILE(SCPMABPD)                                /*S01464*/
             CLRPFM     FILE(SEPMABPD)                                /*S01464*/
/**/
/***IF*PROGRAM*RUNNING*IN*ANWD2*OVERRIDE*TO*SCGEDLL1*FOR*POSTINGS***/ /*S01464*/
/** If program running in ANWD2, override to SEGEDLL1 for postings */ /*S01464*/
/* */                                                                 /*S01464*/
             IF         COND(&ANWD *EQ 'Y') THEN(DO)
/************OVRDBF     FILE(SCGEDLL0) TOFILE(SCGEDLL1)               /*S01464*/
             OVRDBF     FILE(SEGEDLL0) TOFILE(SEGEDLL1)               /*S01464*/
             ENDDO
 
/**OPEN*QUERY*FILE*SELECTING*PRCIOUS*METAL*ACCOUNTS*****************/ /*S01464*/
/************OVRDBF     FILE(SCACCNLL) TOFILE(SDCURRX0) SHARE(*YES)   /*S01464*/
/*>>B5737>>*/
/************OPNQRYF    FILE((SDCURRX0) (ACCNTAB) (SDSECSPD)) +
                          FORMAT(SCACCNLL SCACCND0) QRYSLT('CYPMRT +
                          *EQ "Y" *AND BFSBJF *EQ "Y" *AND RECI *NE +
                          "*"') KEYFLD((CNUM) (PTFR) (CCY)) +
                          JFLD((SDCURRX0/CYCURR ACCNTAB/CCY) +
                          (ACCNTAB/CNUM *MAPFLD/CUST)) +
                          JDFTVAL(*YES) MAPFLD((CUST +
                          'SDSECSPD/BFCUST' *ZONED 6 0))        */
 
/************OPNQRYF    FILE((SDCURRX0) (ACCNTAB) (SDSECSPD)) +       /*S01464*/
/************             FORMAT(SCACCNLL SCACCND0) QRYSLT('CYPMRT +  /*S01464*/
/************             *EQ "Y" *AND BFSBJF *EQ "Y" *AND RECI *NE + /*S01464*/
/************             "*" *AND ATYP *EQ "R"')     +               /*S01464*/
/************             KEYFLD((CNUM) (PTFR) (CCY)) +               /*S01464*/
/************             JFLD((SDCURRX0/CYCURR ACCNTAB/CCY) +        /*S01464*/
/************             (ACCNTAB/CNUM *MAPFLD/CUST)) +              /*S01464*/
/************             JDFTVAL(*YES) MAPFLD((CUST +                /*S01464*/
/************             'SDSECSPD/BFCUST' *ZONED 6 0))              /*S01464*/
/*<<B5737<<*/
/* */                                                                 /*S01464*/
/**  OPEN QUERY FILE SELECTING PRECIOUS METAL ACCOUNTS             */ /*S01464*/
/* */                                                                 /*S01464*/
             OVRDBF     FILE(SEACCNLL) TOFILE(SDCURRL0) SHARE(*YES)   /*S01464*/
/************OPNQRYF    FILE((SDCURRL0) (ACCNTAB) (SDSECSPD)) +       /*091522*/
/***********************  FORMAT(SEACCNLL SEACCND0) QRYSLT('A6PMRT +  /*091522*/
/***********************  *EQ "Y" *AND BFSBJF *EQ "Y" *AND RECI *NE + /*091522*/
/***********************  "*" *AND ATYP *EQ "R"') KEYFLD((CNUM) +     /*091522*/
/***********************  (CCY)) JFLD((SDCURRL0/A6CYCD ACCNTAB/CCY) + /*091522*/
/***********************  (ACCNTAB/CNUM *MAPFLD/CUST)) +              /*091522*/
/***********************  JDFTVAL(*YES) MAPFLD((CUST +                /*091522*/
/**********************   'SDSECSPD/BFCUST' *ZONED 6 0))   /*S01464*/ /*091522*/
/************OPNQRYF    FILE((SDCURRL0) (ACCNTAB) (SDSECSPD)) +       /*096390*/
/************             FORMAT(SEACCNLL SEACCND0) QRYSLT('A6PMRT +  /*096390*/
/************             *EQ "Y" *AND BFSBJF *EQ "Y" *AND RECI *NE + /*096390*/
/************             "*" *AND ATYP *EQ "R"') KEYFLD((CNUM) +     /*096390*/
/************             (PTFR) (CCY)) JFLD((SDCURRL0/A6CYCD +       /*096390*/
/************             ACCNTAB/CCY) (ACCNTAB/CNUM *MAPFLD/CUST)) + /*096390*/
/************             JDFTVAL(*YES) MAPFLD((CUST +                /*096390*/
/************             'SDSECSPD/BFCUST' *ZONED 6 0))       /*091522 096390*/
             OPNQRYF    FILE((SDCURRL0) (ACCNTAB) (SDSECSPD)) +
                          FORMAT(SEACCNLL SEACCND0) QRYSLT('A6PMRT +
                          *EQ "Y" *AND BFSBJF *EQ "Y" *AND RECI *NE +
                          "*"')                   KEYFLD((CNUM) +
                          (PTFR) (CCY)) JFLD((SDCURRL0/A6CYCD +
                          ACCNTAB/CCY) (ACCNTAB/CNUM *MAPFLD/CUST)) +
                          JDFTVAL(*YES) MAPFLD((CUST +
                          'SDSECSPD/BFCUST' *ZONED 6 0))              /*096390*/
 
             CALL       PGM(SE6410)
/************CLOF       OPNID(SDCURRX0)                               /*S01464*/
/************DLTOVR     FILE(SCACCNLL)                                /*S01464*/
             CLOF       OPNID(SDCURRL0)                               /*S01464*/
             DLTOVR     FILE(SEACCNLL)                                /*S01464*/
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01464*/
/************    RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01464*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+/*S01464*/
/****************         TOMSGQ(MOPERQ MRUNQ)                        /*S01464*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*S01464*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01464*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01464*/
             ENDDO
 
/* >>> SESCS >>> */
             ENDDO
/* <<< SESCS <<< */
 
/***END:*********ENDPGM                                               /*S01464*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
          ENDPGM                                                      /*S01464*/
