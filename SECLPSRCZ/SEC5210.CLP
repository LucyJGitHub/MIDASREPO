/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Bulk update')                                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC5210 - GENERATE POOL PORTFOLIO TRADES                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Aug99              */
/*                      S01486             Date 14Dec94              */
/*                      058886             DATE 20JUL93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*                Copyright Statement and Standard Header Box.       */
/*                Creation Parameters. Message Files.                */
/*       058886 - OBJECT RENAMED FROM PMC5110 TO SEC5210             */
/*                                                                   */
/*********************************************************************/
/*********** PGM        PARM(&JOB &BLKREF)                            /*S01486*/
             PGM        PARM(&JOB &BLKREF &RSEQ &RLVL &RENT)          /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1) /* RCF level +
                          flag (S/C/B)                                /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity +
                          code (all/comp/bch)                         /*S01486*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BLKREF) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
             DCL        VAR(&RE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IA) TYPE(*CHAR) LEN(1)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*USE)
 
/************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))                /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                  /*CPK009*/
 
             RTVDTAARA  DTAARA(MMOD (16 1)) RTNVAR(&RE)
             RTVDTAARA  DTAARA(MMOD (23 1)) RTNVAR(&IA)
 
             IF         COND((&RE *EQ 'Y') *OR (&IA *EQ 'Y')) +
                          THEN(CHGJOB SWS(1XXXXX00))
             ELSE       CMD(CHGJOB SWS(00000000))
 
             OVRDBF     FILE(RSACMTPD) SEQONLY(*NO)
 
/*           CALL       PGM(PM5110) PARM(&BLKREF &JOB)         58886 */
/*           CALL       PGM(SE5210) PARM(&BLKREF &JOB)         58886  /*S01486*/
             CALL       PGM(SE5210) PARM(&BLKREF &JOB &RSEQ &RLVL +
                          &RENT)                                      /*S01486*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM)  +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
/***********    SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)  +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01486*/
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
