/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Custody fee settlements audit report')          */
/*********************************************************************/
/*                                                                   */
/*          Midas     SECURITIES TRADING MODULE                      */
/*                                                                   */
/*          SEC6250    SAFE CUSTODY FEE SETTLEMENTS AUDIT REPORT     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01464             DATE 04APR94              */
/*     + PREV AMEND NO. 049421     BZ      DATE 19JAN93              */
/*            AMEND NO. SESCS              DATE 28AUG92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       S01464  -  Safe Custody Fees                                */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       SESCS   -  SAFE CUSTODY FEES SWITCHABLE                     */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MRDT) TYPE(*CHAR) LEN(5)
/************DCL        VAR(&DATA) TYPE(*CHAR) LEN(52)                /*S01464*/
/************DCL        VAR(&SCSW) TYPE(*CHAR) LEN(1)      /*SESCS */ /*S01464*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                 /*S01464*/
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ') /*S01464*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*S01464*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*S01464*/
 
/************RTVDTAARA  DTAARA(LZSTAT (28 1)) RTNVAR(&SCSW)/*SESCS */ /*S01464*/
/************IF         COND(&SCSW *EQ 'Y') THEN(DO)       /*SESCS */ /*S01464*/
/* */                                                                 /*S01464*/
/* Check Safe Custody Fees flag on Securities Trading ICD */          /*S01464*/
/* */                                                                 /*S01464*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*S01464*/
/* */
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)                    /*S01464*/
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/* RESET EXTERNAL SWITCHES */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
             SNDPGMMSG  MSG('SEC6250 - Safe custody fee settlements +
                          audit report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             RTVDTAARA  DTAARA(SDSTAT (117 5)) RTNVAR(&MRDT)
 
/* SELECT RECORDS CHANGED TODAY */
 
/************OVRDBF     FILE(SCOCFSQ1) TOFILE(SDACOFPD) SHARE(*YES)   /*S01464*/
             OVRDBF     FILE(SEOCFSQ1) TOFILE(SDACOFPD) SHARE(*YES)   /*S01464*/
/************OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SCOCFSPD)) +
                          FORMAT(SCOCFSQ1 SCOCFSQ0) QRYSLT('RDATE +
                          *EQ "' *CAT &MRDT *CAT '"') +
                          KEYFLD((AZPRTL) (AZACOC) (SECNUM) +
                          (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) MAPFLD((CNUM +
                          'SCOCFSPD/SECNUM' *CHAR 6) (WDATE SELCD +
                          *ZONED 5) (RDATE WDATE *CHAR 5))            /*S01464*/
             OPNQRYF    FILE((SDACOFPD) (SDCUSTPD) (SEOCFSPD)) +
                          FORMAT(SEOCFSQ1 SEOCFSQ0) QRYSLT('RDATE +
                          *EQ "' *CAT &MRDT *CAT '"') +
                          KEYFLD((SEBRCA) (AZACOC) (SECNUM) +
                          (SEPTFR)) JFLD((SDACOFPD/AZACOC +
                          SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST +
                          *MAPFLD/CNUM)) MAPFLD((CNUM +
                          'SEOCFSPD/SECNUM' *CHAR 6) (WDATE SELCD +
                          *ZONED 5) (RDATE WDATE *CHAR 5) (BBCUSB +
                          SECSCY *CHAR 3) (BBCSCY SECSCY *CHAR 3))    /*S01464*/
 
             CALL       PGM(SE6250)
             CLOF       OPNID(SDACOFPD)
/************DLTOVR     FILE(SCOCFSQ1)                                /*S01464*/
             DLTOVR     FILE(SEOCFSQ1)                                /*S01464*/
 
/* PROCESS ANY DATA BASE ERROR */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 /**************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&DATA)         /*S01464*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01464*/
/*                                                                    /*R00300*/
 /**************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&DATA)+
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01464*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01464*/
/*                                                                    /*R00300*/
             ENDDO
 
             ENDDO                                                 /* SESCS */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM:   ENDPGM
