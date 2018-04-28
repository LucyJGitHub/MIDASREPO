/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Missing custody fees report COB')               */
/********************************************************************/
/*                                                                  */
/*          Midas     SECURITIES TRADING MODULE                     */
/*                                                                  */
/*          SEC6282    MISSING CUSTODY FEES REPORT COB              */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01464             DATE 04APR94             */
/*     + PREV AMEND NO. 049421     BZ      DATE 19JAN93             */
/*       PREV AMEND NO. SESCS              DATE 28AUG92             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       S01464  -  Safe Custody Fees                               */
/*       049421  -  HEADER BOX STANDARDISATION                      */
/*       SESCS   -  SAFE CUSTODY FEES SWITCHABLE                    */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&WWACOF &WWCUST)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*S01464*/
             DCL        VAR(&WWACOF) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WWCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
/**>>>*SESCS*>>>**/
/*********** DCL        VAR(&SCSW) TYPE(*CHAR) LEN(1)                 /*S01464*/
             DCL        VAR(&SCAC) TYPE(*CHAR) LEN(1)
             DCL       VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ') /*S01464*/
             DCL       VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST ') /*S01464*/
             DCL       VAR(&FMT) TYPE(*CHAR) LEN(800)                 /*S01464*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01464*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) VALUE('ALL')    /*S01464*/
/**<<<*SESCS*<<<**/
 
/* GLOBAL MONITOR MESSAGE                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))
 
/**>>>*SESCS*>>>**/
/************RTVDTAARA  DTAARA(LZSTAT (28 1)) RTNVAR(&SCSW)           /*S01464*/
/************IF         COND(&SCSW *EQ 'Y') THEN(DO)                  /*S01464*/
/* */                                                                 /*S01464*/
/* Check Safe Custody Fees flag on Securities Trading ICD             /*S01464*/
/* */                                                                 /*S01464*/
             CALL       PGM(AOSTRDR0) PARM(&RTCD &OPTN &FMT)          /*S01464*/
/* */
             IF         COND((%SST(&FMT 189 1) *EQ 'Y') *AND (&RTCD +
                          *EQ '       ')) THEN(DO)                    /*S01464*/
 
/* CHECK WHETHER ACCRUALS PROCESSING TO BE RUN TODAY */
/************RTVDTAARA  DTAARA(SESTAT (74 1)) RTNVAR(&SCAC)           /*S01464*/
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
             SNDPGMMSG  MSG('SEC6282 - Missing custody fee codes +
                          report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/*  OPEN QUERY FILE TO SELECT CUSTOMERS AND PORTFOLIOS TO BE REPORTED         */
/************OVRDBF     FILE(SCSECSPO) TOFILE(SDACOFPD) SHARE(*YES)   /*S01464*/
             OVRDBF     FILE(SESECSPP) TOFILE(SDCUSTPD) SHARE(*YES)
/**/
/*  RUN REPORT SHOWING ALL DETAILS                                            */
/************OPNQRYF    FILE((*LIBL/SDACOFPD) (SDCUSTPD) (SDSECSPD)) +
                          FORMAT(SCSECSPO) QRYSLT('BFSBJF *EQ "Y"') +
                                           KEYFLD((SDACOFPD/AZPRTL) +
                          (SDACOFPD/AZACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDACOFPD/AZACOC SDCUSTPD/BBACOC) +
                          (SDCUSTPD/BBCUST SDSECSPD/BFCUST))          /*S01464*/
             OPNQRYF    FILE((SDCUSTPD) (SDSECSPD)) FORMAT(SESECSPP) +
                          QRYSLT('BFSBJF *EQ "Y"') +
                          KEYFLD((SDCUSTPD/BBBRCD) +
                          (SDCUSTPD/BBACOC) (SDCUSTPD/BBCUST)) +
                          JFLD((SDCUSTPD/BBCUST SDSECSPD/BFCUST))     /*S01464*/
/**/
/************CALL       PGM(SE6280) PARM(&WWACOF &WWCUST)             /*S01464*/
             CALL       PGM(SE6280) PARM(&WWACOF &WWCUST &RSEQ &RENT) /*S01464*/
/************CLOF       OPNID(SDACOFPD)                               /*S01464*/
             CLOF       OPNID(SDCUSTPD)                               /*S01464*/
             DLTOVR     FILE(*ALL)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/****************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         /*S01464*/
/*                                                                    /*R00300*/
/****************SNDPGMMSG MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)+/*S01464*/
/****************         TOMSGQ(MOPERQ MRUNQ)                        /*S01464*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01464*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)        /*S01464*/
             ENDDO
 
/* >>> SESCS >>> */
             ENDDO                                                 /* SESCS */
/* <<< SESCS <<< */
 
/***END:*********ENDPGM                                               /*S01464*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
ENDPGM                                                                /*S01464*/
