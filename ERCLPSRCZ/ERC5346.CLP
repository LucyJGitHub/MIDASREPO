/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Accounts Post - DAILY JOURNAL')              */
/********************************************************************/
/*                                                                  */
/*             MIDAS/ABS EUROPEAN REPORTING SYSTEM                  */
/*                                                                  */
/*       ERC5346 - GL Accounts Post - Daily Journal                 */
/*                 (based on GLC32)                                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. EMFIX              Date 26Aug98              */
/*                      ER1023             Date 01Feb93              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*   EMFIX  - DBA2 upgrade : GL3320 and GL0340                      */
/*            are called with parameter.                            */
/*   ER1023 - Lock occured when Journalling started.                */
/*------------------------------------------------------------------*/
/*                                                                  */
/*  The following fixes were incorporated when created:             */
/*       B7296   -  REMOVE OF RGZPFM ACCNTAB                        */
/*       E23416  -  PROGRAM SHOULD CHECK FOR RETAIL2 AND INTEREST   */
/*                  ON ACCOUNTS INSTEAD OF RETAIL1                  */
/*       E20615  -  IF PROGRAM FAILS TO ALLOCATE GLSTAT AFTER GOING */
/*                  TO TAG ABNOR,  PROGRAM MAY TERMINATE ABNORMALLY */
/*                  WITHOUT SETTING U8 ON, SO CALLING PROGRAM GLC35B*/
/*                  ASSUMES IT COMPLETED NORMALLY AND CONTINUES.    */
/*       NRCOB   -  CALL OF GL3320 INSTEAD OF GL0320                */
/*       E15196  -  VALUE IN GLSTAT NOT ACCESSED FOR BUSY FLAG IN   */
/*                  ABNORMAL PROCESSING.                            */
/*       E11829  -  ABNORMAL PROCESSING NOT EXECUTED FOR FILE       */
/*                  CONTROLS OUT OF BALANCE.                        */
/*       S03220  -  FUNDS TRANSFER                                  */
/*       E10877  -  MONMSG TO END JOURNALLING                       */
/*       E43680  -  SWITCH U7 NOT SET OFF                           */
/*       S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,        */
/*                  INSTEAD OF CLEARING AND ADDING.                 */
/*                  FROM AND TO FILES ARE NOW 'BLOCKED'             */
/*       S01097  -  GL0323 REMOVED AND FILES CHANGED                */
/*                                                                  */
/********************************************************************/
 
/* Valid parameters are '1' (Spot Trade Historic & Equiv. Postings,  */
/*                  and '2'  Spot Trade Hist. Revaluation Postings)  */
 
             PGM        PARM(&POSTNUM)
 
             DCL        VAR(&POSTNUM) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&ACJND) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACJNT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MMOD)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&ERSTAT) TYPE(*CHAR) LEN(256)
 
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
 
             DCL        VAR(&TIMES) TYPE(*DEC) LEN(1 0) VALUE(0) /* +
                          ER1023 */
 
             DCL        VAR(&MAUD) TYPE(*CHAR) LEN(1) VALUE(' ') /* +
                          EMFIX */
 
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
             IF         COND(&POSTNUM *EQ '1') THEN(DO)
             SNDPGMMSG  MSG('ERC5346 - GL A/c Post, Daily Journal - +
                          Spot Trade Historic & Equivalent') +
                          TOMSGQ(MRUNQ)
                ENDDO
             ELSE       CMD(DO)
             SNDPGMMSG  MSG('ERC5345 - GL A/c Post, Daily Journal - +
                          Spot Trade Historic Revaluations') +
                          TOMSGQ(MRUNQ)
             ENDDO
 
/* Identify Library Group and if this is a restart                   */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             RTVDTAARA  DTAARA(ERSTAT (41 1)) RTNVAR(&BUSY)
 
/* If restart, then remove journalled changes                        */
 
             IF         COND(&BUSY = 'Y') THEN(DO)
                CHKOBJ     OBJ(JRERC5346) OBJTYPE(*JRNRCV)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRNRCV))
                CHKOBJ     OBJ(JERC5346) OBJTYPE(*JRN)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(NOJRN))
                RMVM       FILE(ACCNT) MBR(ACCNT)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(ACNUM) MBR(ACNUM)
                MONMSG     MSGID(CPF0000)
                RMVJRNCHG  JRN(JERC5346) FILE(ACCNTAB ACCNTAA ACCNTAC)
                MONMSG     (CPF7042 CPF7049)
                ENDJRNPF   FILE(*ALL) JRN(JERC5346)
                MONMSG     MSGID(CPF7032)
                DLTJRN     JRN(JERC5346)
                ADDLFM     FILE(ACCNT) MBR(ACCNT)
                MONMSG     MSGID(CPF0000)
                ADDLFM     FILE(ACNUM) MBR(ACNUM)
                MONMSG     MSGID(CPF0000)
NOJRN:          CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(JRERC5346)
                CHGJOB     INQMSGRPY(*RQD)
NOJRNRCV:       CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
             ENDDO
 
/* Create temporary Journal & Receiver                               */
 
             CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('Y')
             CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
 
             CRTJRNRCV  JRNRCV(&JLIB/JRERC5346)
             CRTJRN     JRN(&JLIB/JERC5346) JRNRCV(&JLIB/JRERC5346)
 
 
    RETRY:                                    /* ER1023 */
/* Prevent file LOCK by another job                          ER1023  */
             IF         COND(&TIMES *GT 5) THEN(DO) /* ER1023 */
             SNDPGMMSG  MSG('ERC5346- Not able to allocate +
                          ACCNTAA,ACCNTAB,ACCNTAC for journalling. +
                          Check lock state for those files before +
                          restart.') TOMSGQ(MOPERQ MRUNQ) /* ER1023 */
             GOTO       CMDLBL(ABNOR) /* ER1023 */
                                                ENDDO    /* ER1023 */
 
             CHGVAR     VAR(&TIMES) VALUE(&TIMES + 1) /* ER1023 */
 
             ALCOBJ     OBJ((ACCNTAA *FILE *EXCL)) WAIT(9999) /* +
                          ER1023 */
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(RETRY)) /* +
                          ER1023 */
 
             ALCOBJ     OBJ((ACCNTAB *FILE *EXCL)) WAIT(9999) /* +
                          ER1023 */
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(RETRY)) /* +
                          ER1023 */
 
             ALCOBJ     OBJ((ACCNTAC *FILE *EXCL)) WAIT(9999) /* +
                          ER1023 */
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(RETRY)) /* +
                          ER1023 */
 
 
             STRJRNPF   FILE(ACCNTAB ACCNTAA ACCNTAC) JRN(JERC5346) +
                          IMAGES(*BOTH)
 
             DLCOBJ     OBJ((ACCNTAA *FILE *EXCL)) /* ER1023 */
             MONMSG     MSGID(CPF0000) /* ER1023 */
             DLCOBJ     OBJ((ACCNTAB *FILE *EXCL)) /* ER1023 */
             MONMSG     MSGID(CPF0000) /* ER1023 */
             DLCOBJ     OBJ((ACCNTAC *FILE *EXCL)) /* ER1023 */
             MONMSG     MSGID(CPF0000) /* ER1023 */
 
 
/* Clear work files                                                  */
 
             RMVM       FILE(SACBL) MBR(SACBL)
             MONMSG     MSGID(CPF0000)
 
             CLRPFM     FILE(ABEXHH)
             CLRPFM     FILE(ABEXAG)
             CLRPFM     FILE(ABEXZY)
 
/* Identify if Retail II or Interest on A/c's Modules are installed  */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
             CHGJOB     SWS(00000000)
 
             IF         COND((%SST(&MMOD 16 1) = 'Y') *OR +
                          (%SST(&MMOD 23 1) = 'Y')) THEN(CHGJOB +
                          SWS(01XX1XXX))
 
             OVRDBF     FILE(TABLE) TOFILE(TABGL)
 
/* Block large files                                                 */
 
             OVRDBF     FILE(ACCNTAB) SEQONLY(*YES 100)
             OVRDBF     FILE(ACBRC) SEQONLY(*YES 100)
             OVRDBF     FILE(ABEXAG) SEQONLY(*YES 100)
 
/* Call GL Account Balances Extract program                          */
 
/*******     CALL       PGM(GL3320)                                       EMFIX*****/
             CALL       PGM(GL3320) PARM(&MAUD) /* EMFIX*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             DLTOVR     FILE(ABEXAG)
 
/* UNSUCCESSFUL COMPLETION - Therefore REMOVE Journalled changes     */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RMVM       FILE(ACCNT) MBR(ACCNT)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(ACBRC) MBR(ACBRC)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(ACNUM) MBR(ACNUM)
                MONMSG     MSGID(CPF0000)
                RMVJRNCHG  JRN(JERC5346) FILE(ACCNTAB ACCNTAA ACCNTAC)
                MONMSG     (CPF7049)
                ADDLFM     FILE(ACCNT) MBR(ACCNT)
                MONMSG     MSGID(CPF0000)
                ADDLFM     FILE(ACBRC) MBR(ACBRC)
                MONMSG     MSGID(CPF0000)
                ADDLFM     FILE(ACNUM) MBR(ACNUM)
                MONMSG     MSGID(CPF0000)
                ADDLFM     FILE(SACBL) MBR(SACBL)
                MONMSG     MSGID(CPF0000)
                ENDJRNPF   FILE(*ALL) JRN(JERC5346)
                DLTJRN     JRN(JERC5346)
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(JRERC5346)
                CHGJOB     INQMSGRPY(*RQD)
                CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
 
                SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                             TOMSGQ(MRUNQ)
                SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR') +
                             TOMSGQ(MOPERQ)
/* GL3320 - Abort                                                    */
                GOTO ENDPGM
             ENDDO
 
/* SUCCESSFUL COMPLETION - Therefore, delete Journal & Receiver      */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                ENDJRNPF   FILE(*ALL) JRN(JERC5346)
                DLTJRN     JERC5346
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRERC5346
                CHGJOB     INQMSGRPY(*RQD)
                CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
             ENDDO
 
             IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
 
/* If U1, then reorganise of GL Accounts Files required              */
 
                IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
 
                   RMVM       FILE(SADETC) MBR(SADETC)
                   MONMSG     MSGID(CPF0000)
                   RMVM       FILE(SAIR) MBR(SAIR)
                   MONMSG     MSGID(CPF0000)
 
                ENDDO
 
                ADDLFM     FILE(SACBL) MBR(SACBL)
                MONMSG     MSGID(CPF0000)
 
/* Identify which new postings file is to be used for Daily Journal  */
 
                CHGDTAARA  DTAARA(ERSTAT (42 1)) VALUE(&POSTNUM)
 
                IF         COND(&POSTNUM *EQ '1') THEN(DO)
/**********        CHGVAR     VAR(&ACJND) VALUE('ACJNDHE')                                /*CER001*/
/**********        CHGVAR     VAR(&ACJNT) VALUE('ACJNTHE')                                /*CER001*/
                   CHGVAR     VAR(&ACJND) VALUE('GLSHX2L0')                               /*CER001*/
                   CHGVAR     VAR(&ACJNT) VALUE('GLSHX2L2')                               /*CER001*/
                   ENDDO
                ELSE       CMD(DO)
/**********        CHGVAR     VAR(&ACJND) VALUE('ACJNDHR')                                /*CER001*/
/**********        CHGVAR     VAR(&ACJNT) VALUE('ACJNTHR')                                /*CER001*/
                   CHGVAR     VAR(&ACJND) VALUE('GLSRX2L0')                               /*CER001*/
                   CHGVAR     VAR(&ACJNT) VALUE('GLSRX2L2')                               /*CER001*/
                ENDDO
 
/* Override files to work file & new postings file for Daily Journal */
 
                OVRDBF     FILE(ACBL) TOFILE(SACBL) SEQONLY(*YES 100)
 
                OVRDBF     FILE(ACJND) TOFILE(&ACJND)
                OVRDBF     FILE(ACJNT) TOFILE(&ACJNT)
 
/* Set off external switch for Funds Transfer module for report      */
 
                CHGJOB     SWS(XXXXX0XX)
 
/* Call GL Daily Journal report program                              */
 
/*************  CALL       PGM(GL0340)                                        EMFIX*/
             CALL       PGM(GL0340) PARM(&MAUD)                             /*EMFIX*/
 
                DLTOVR     FILE(ACBL ACJND ACJNT TABLE)
 
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                   CLRPFM     FILE(ABEXHH)
                   CLRPFM     FILE(ABEXAG)
                   CLRPFM     FILE(ABEXZY)
                   ENDDO
 
                ELSE      CMD(DO)
 
                   IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                      SNDPGMMSG  MSG('DAILY JOURNAL DOES NOT BALANCE') +
                                  TOMSGQ(MRUNQ)
                      SNDPGMMSG  MSG('DAILY JOURNAL DOES NOT BALANCE') +
                                  TOMSGQ(MOPERQ)
                      ENDDO
 
                   ELSE       CMD(DO)
                      CHGJOB     SWS(XXXXXXX1)
                      SNDPGMMSG  MSG('FILE OUT OF BALANCE - SACBL') +
                                   TOMSGQ(MRUNQ)
                      SNDPGMMSG  MSG('FILE OUT OF BALANCE - SACBL') +
                                   TOMSGQ(MOPERQ)
                      ENDDO
 
                   ENDDO
 
                ENDDO
 
             ELSE      CMD(DO)
 
                CHGJOB     SWS(XXXXXXX1)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - ACCNT') +
                             TOMSGQ(MRUNQ)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - ACCNT') +
                             TOMSGQ(MOPERQ)
                ENDDO
 
             ADDLFM     FILE(SADETC) MBR(SADETC)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(SAIR) MBR(SAIR)
             MONMSG     MSGID(CPF0000)
 
/* SUCCESSFUL COMPLETION - Therefore, end procedure                  */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGDTAARA  DTAARA(ERSTAT (42 2)) VALUE(' N')
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* GENERAL ABORT - Remove all journalled changes                     */
 
ABNOR:       RTVDTAARA  DTAARA(ERSTAT (41 1)) RTNVAR(&BUSY)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(EXIT))
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             DLCOBJ     OBJ((ACCNTAA *FILE *EXCL)) /* ER1023 */
             MONMSG     MSGID(CPF0000) /* ER1023 */
             DLCOBJ     OBJ((ACCNTAB *FILE *EXCL)) /* ER1023 */
             MONMSG     MSGID(CPF0000) /* ER1023 */
             DLCOBJ     OBJ((ACCNTAC *FILE *EXCL)) /* ER1023 */
             MONMSG     MSGID(CPF0000) /* ER1023 */
 
                RMVM       FILE(ACCNT) MBR(ACCNT)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(ACBRC) MBR(ACBRC)
                MONMSG     MSGID(CPF0000)
                RMVM       FILE(ACNUM) MBR(ACNUM)
                MONMSG     MSGID(CPF0000)
                RMVJRNCHG  JRN(JERC5346) FILE(ACCNTAB ACCNTAA ACCNTAC)
                MONMSG     (CPF7042 CPF7049)
                ENDJRNPF   FILE(*ALL) JRN(JERC5346)
                MONMSG     MSGID(CPF7032)
                DLTJRN     JRN(JERC5346)
                ADDLFM     FILE(ACCNT) MBR(ACCNT)
                MONMSG     MSGID(CPF0000)
                ADDLFM     FILE(ACBRC) MBR(ACBRC)
                MONMSG     MSGID(CPF0000)
                ADDLFM     FILE(ACNUM) MBR(ACNUM)
                MONMSG     MSGID(CPF0000)
                CHGJOB     INQMSGRPY(*DFT)
                DLTJRNRCV  JRNRCV(JRERC5346)
                CHGJOB     INQMSGRPY(*RQD)
                CHGDTAARA  DTAARA(ERSTAT (41 1)) VALUE('N')
                MONMSG     MSGID(CPF0000)
                ENDDO
EXIT:        CHGJOB     SWS(XXXXXXX1)
 
ENDPGM:      ENDPGM
