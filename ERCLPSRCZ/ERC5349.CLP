/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Spot Trade Historic A/c Postings MERGE')        */
/********************************************************************/
/*                                                                  */
/*             MIDAS/ABS EUROPEAN REPORTING SYSTEM                  */
/*                                                                  */
/*       ERC5349 - SPOT TRADE HISTORIC A/C POSTINGS MERGE           */
/*                 (based on GLC41 - Daily Accounting Merge)        */
/*                                                                  */
/*       (c) Finastra International Limited 2005                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/*                      FS0001             Date 14Sep95              */
/*                      ER0004 VT          Date 30Nov92              */
/*                      EMFIX1             DATE 16AUG90             */
/*                      EU                 DATE 19JUN90             */
/*                      S01235             DATE 14/05/90            */
/*                      S03220             DATE 09/05/88            */
/*                      S01098             DATE 24/07/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       FS0001  -  FILE HPOSTPD IS REPLACED BY GLACPHPD            */
/*       ER0004  -  WRITTEN TO CALL NEW DAILY REPORTING MERGE PGM   */
/*                  BASED ON CODING FROM CLP/GLC41.                 */
/*       EMFIX1  -  REMOVE PORTFOLIO MANAGEMENT                     */
/*       EU      -  EUROPEAN ENHANCEMENT                            */
/*       S01235  -  MERGE PORTFOLIO MANAGEMENT POSTINGS             */
/*       S03220  -  FUNDS TRANSFER                                  */
/*       S01098  -  AMENDMENT BLOCKS SELECTED LARGE FILES           */
/*                                                                  */
/********************************************************************/
             PGM
/**/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8) VALUE('00000000')
 
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
 
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             SNDPGMMSG  MSG('ERC5349 - SPOT TRADE HISTORIC A/C +
                          POSTINGS MERGE') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(&SWS)
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABGL)
 
/* Identify Library Group and if this is a restart                   */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             RTVDTAARA  DTAARA(ERSTAT (41 1)) RTNVAR(&BUSY)
 
/* If restart, then remove journalled changes                        */
 
             IF         COND(&BUSY = 'Y') THEN(DO)
                CHKOBJ     OBJ(JRERC5349) OBJTYPE(*JRNRCV)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
                CHKOBJ     OBJ(JERC5349) OBJTYPE(*JRN)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
/*************  RMVJRNCHG  JRN(JERC5349) FILE(EODPOPD HPOSTPD)          FS0001*/
                RMVJRNCHG  JRN(JERC5349) FILE(EODPOPD GLACPHPD)       /*FS0001*/
                MONMSG     (CPF7042 CPF7049)
                ENDJRNPF   FILE(*ALL) JRN(JERC5349)
                MONMSG     MSGID(CPF7032)
                DLTJRN     JRN(JERC5349)
NOJRN:          CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(JRERC5349)
                CHGJOB     INQMSGRPY(*RQD)
NOJRNRCV:       CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
             ENDDO
 
/* Create temporary Journal & Receiver                               */
 
             CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('Y')
             CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
 
             CRTJRNRCV  JRNRCV(&JLIB/JRERC5349)
             CRTJRN     JRN(&JLIB/JERC5349) JRNRCV(&JLIB/JRERC5349)
 
/*********** STRJRNPF   FILE(EODPOPD HPOSTPD) JRN(JERC5349) +
                          IMAGES(*BOTH)                                 FS0001*/
             STRJRNPF   FILE(EODPOPD GLACPHPD) JRN(JERC5349) +
                          IMAGES(*BOTH)                               /*FS0001*/
 
/**/                                                                  /*S01098*/
/*                BLOCK LARGE FILES                                 *  *S01098*/
/**/                                                                  /*S01098*/
             OVRDBF     FILE(EODPOPD) SEQONLY(*YES 100)               /*S01098*/
/**/                                                                  /*S01098*/
/* ER0004 ***CALL       PGM(GL0400)                                           */
             CALL       PGM(ER5349)
/**/                                                                  /*S01098*/
             DLTOVR     FILE(EODPOPD)                                 /*S01098*/
             DLTOVR     FILE(TABLE)
/**/
/*  *** EUROPEAN ENHANCEMENT  */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**********     OVRDBF     FILE(EODPOPD) TOFILE(GESTHRPD)                                   CER001*/
                OVRDBF     FILE(EODPOPD) TOFILE(GLSRX2PD)                                 /*CER001*/
             CALL       PGM(ABSFDA4)
                DLTOVR     FILE(EODPOPD)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**********     OVRDBF     FILE(EODPOPD) TOFILE(GESTHEPD)                                   CER001*/
                OVRDBF     FILE(EODPOPD) TOFILE(GLSHX2PD)                                 /*CER001*/
             CALL       PGM(ABSFDA4)
                DLTOVR     FILE(EODPOPD)
             ENDDO
/*  *** EU */
/**/
/**/
/* UNSUCCESSFUL COMPLETION - Therefore REMOVE Journalled changes     */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/************** RMVJRNCHG  JRN(JERC5349) FILE(EODPOPD HPOSTPD)          FS0001*/
                RMVJRNCHG  JRN(JERC5349) FILE(EODPOPD GLACPHPD)       /*FS0001*/
                MONMSG     (CPF7049)
                ENDJRNPF   FILE(*ALL) JRN(JERC5349)
                DLTJRN     JRN(JERC5349)
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(JRERC5349)
                CHGJOB     INQMSGRPY(*RQD)
                CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
 
/**/
/**********  SNDPGMMSG  MSG('FILE OUT OF BALANCE - GEACPO1') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CER001*/
             SNDPGMMSG  MSG('FILE OUT OF BALANCE - GLSTX1L0') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CER001*/
/**/
                GOTO ENDPGM
             ENDDO
 
/* SUCCESSFUL COMPLETION - Therefore, delete Journal & Receiver      */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                ENDJRNPF   FILE(*ALL) JRN(JERC5349)
                DLTJRN     JERC5349
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRERC5349
                CHGJOB     INQMSGRPY(*RQD)
                CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* GENERAL ABORT - Remove all journalled changes                     */
 
ABNOR:       RTVDTAARA  DTAARA(ERSTAT (41 1)) RTNVAR(&BUSY)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(EXIT))
             IF         COND(&BUSY = 'Y') THEN(DO)
/************** RMVJRNCHG  JRN(JERC5349) FILE(EODPOPD HPOSTPD)          FS0001*/
                RMVJRNCHG  JRN(JERC5349) FILE(EODPOPD GLACPHPD)       /*FS0001*/
                MONMSG     (CPF7042 CPF7049)
                ENDJRNPF   FILE(*ALL) JRN(JERC5349)
                MONMSG     MSGID(CPF7032)
                DLTJRN     JRN(JERC5349)
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(JRERC5349)
                CHGJOB     INQMSGRPY(*RQD)
                CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
                MONMSG     MSGID(CPF0000)
                ENDDO
EXIT:        CHGJOB     SWS(XXXXXXX1)
 
/* IF JOB ENDED NORMALLY */
/**/
ENDPGM:      ENDPGM
