/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Accounts Post - Spot Trade Hist. POST')      */
/********************************************************************/
/*                                                                  */
/*             MIDAS/ABS EUROPEAN REPORTING SYSTEM                  */
/*                                                                  */
/*       ERC5347 - GL Accounts Post - Spot Trade Historic Post A/c's*/
/*                 (based on GLC37)                                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. EMFIX              Date 26Aug98              */
/*                      ER0999             Date 22Dec91              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       EMFIX  - ACORDBX0 DOES NOT EXIST AFTER DBA2. MONMSG        */
/*       ER0999 - ACORDBX0 NOT CLEARED                              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*                                                                  */
/*  The following fixes were incorporated when created:             */
/*       35052   -  IF RE0600 CALLED WITH RE ON U5 MUST BE SET ON   */
/*       32911   -  CALL ALWAYS  RE0600 ALTHOUGH RE IS NOT ON       */
/*       B9750   -  NEW FILE ADDED IN RE0600                        */
/*       E21390  -  CLOSE OF BUSINESS CONTROL PROGRAMS AMENDED TO   */
/*                  RUN REQUIRED RETAIL EOD PROCESSING IF INTEREST  */
/*                  ON ACCOUNTS INSTALLED IN SYSTEM.                */
/*       E22151  -  ADD CALL TO GL0349 TO UPDATE START OF DAY       */
/*                  LEDGER AND CLEARED BALANCES FROM ACCNT.         */
/*       E18834  -  COB RESTART/RECOVERY. IF ACCNTS POST HALTS      */
/*                  WITH A DATABASE ERROR, THEN ON RESTART THE      */
/*                  COMPONENT SHOULD RERUN THE POST.                */
/*       S03220  -  FUNDS TRANSFER                                  */
/*                  TRAILERS FROM SACPO SPLIT OFF INTO FILE SACPOZ  */
/*       E10366  -  RETAIL 1 IS NO LONGER SUPPORTED AS FROM         */
/*                  RELEASE 21.                                     */
/*       S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,        */
/*                  INSTEAD OF CLEARING AND ADDING.                 */
/*                  FROM AND TO FILES ARE NOW 'BLOCKED'             */
/*                  AMENDMENT BLOCKS SELECTED LARGE FILES           */
/*                                                                  */
/********************************************************************/
 
/* Valid parameters are '1' (Spot Trade Historic & Equiv. Postings,  */
/*                  and '2'  Spot Trade Hist. Revaluation Postings)  */
 
             PGM        PARM(&POSTNUM)
 
             DCL        VAR(&POSTNUM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(44)
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&ERSTAT) TYPE(*CHAR) LEN(256)
 
             RTVDTAARA  DTAARA(ERSTAT) RTNVAR(&ERSTAT)
             RTVDTAARA  DTAARA(MMOD)   RTNVAR(&MMOD)
 
             IF         COND(&POSTNUM *EQ '1') THEN(DO)
                SNDPGMMSG  MSG('ERC5347 - GL Accounts Post - +
                          Spot Trade Historic & Equivalent') +
                          TOMSGQ(MRUNQ)
                ENDDO
             ELSE       CMD(DO)
                SNDPGMMSG  MSG('ERC5347 - GL Accounts Post - +
                          Spot Trade Historic Revaluations') +
                          TOMSGQ(MRUNQ)
             ENDDO
 
             CHGJOB     SWS(00000XXX)
 
/* If 1st time, then clear work files                                */
 
             IF         COND(%SUBSTRING(&ERSTAT 43 1) = 'N') +
                          THEN(DO)
 
                CLRPFM     FILE(ACORDAA)
                CLRPFM     FILE(ACORDAB)
                CLRPFM     FILE(ACORDAC)
                CLRPFM     FILE(ACORDBX0)                           /* ER0999 */
             MONMSG     MSGID(CPF3142)                              /* EMFIX */
 
/* Identify which new postings file is to be used for Postings Update*/
 
                IF         COND(&POSTNUM *EQ '1') THEN(DO)
/**********        OVRDBF     FILE(SACPO) TOFILE(GEACPOE)                                 /*CER001*/
/**********        OVRDBF     FILE(SACPOZ) TOFILE(GEACPOEZ)                               /*CER001*/
                   OVRDBF     FILE(SACPO) TOFILE(GLSHX2L1)                                /*CER001*/
                   OVRDBF     FILE(SACPOZ) TOFILE(GLSHX2L3)                               /*CER001*/
                   ENDDO
                ELSE       CMD(DO)
/**********        OVRDBF     FILE(SACPO) TOFILE(GEACPOR)                                 /*CER001*/
/**********        OVRDBF     FILE(SACPOZ) TOFILE(GEACPORZ)                               /*CER001*/
                   OVRDBF     FILE(SACPO) TOFILE(GLSRX2L1)                                /*CER001*/
                   OVRDBF     FILE(SACPOZ) TOFILE(GLSRX2L3)                               /*CER001*/
                ENDDO
 
                CHGJOB     SWS(XXXXX0XX)
 
/* Update SACPO Start Of Day Ledger and Cleared Balances             */
/*   with values from ACCNT                                          */
 
                CALL       PGM(GL0349)
 
/* Identify if Retail II or Interest on A/c's Modules are installed, */
/*   if so then set on U5                                            */
 
                CHGJOB     SWS(XXXX0XXX)
                IF         COND(%SUBSTRING(&MMOD 16 1) = 'Y' *OR +
                          (%SUBSTRING(&MMOD 23 1) = 'Y')) +
                          THEN(CHGJOB SWS(XXXX1XXX))
 
                OVRDBF     FILE(TABLE) TOFILE(TABRE2)
 
/* Block large files                                                 */
 
                OVRDBF     FILE(ACORDAB) SEQONLY(*YES 100)
                OVRDBF     FILE(REIAC2) TOFILE(REIAC)
 
/* Call RE Account Postings program                                  */
 
                CALL       PGM(RE0600)
 
                DLTOVR     FILE(ACORDAB)
                DLTOVR     FILE(TABLE SACPO SACPOZ)
 
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                   ALCOBJ     OBJ((ERSTAT *DTAARA *EXCLRD))
                   CHGVAR     VAR(%SUBSTRING(&ERSTAT 43 1)) VALUE('Y')
                   CHGDTAARA  DTAARA(ERSTAT) VALUE(&ERSTAT)
                   DLCOBJ     OBJ((ERSTAT *DTAARA *EXCLRD))
                ENDDO
 
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
               IF          COND(%SUBSTRING(&ERSTAT 43 1) = 'Y') +
                             THEN(DO)
 
                   ALCOBJ     OBJ((ERSTAT *DTAARA *EXCLRD))
 
                   RMVM       FILE(ACCNT) MBR(ACCNT)
                   MONMSG     MSGID(CPF0000)
                   RMVM       FILE(ACNUM) MBR(ACNUM)
                   MONMSG     MSGID(CPF0000)
                   RMVM       FILE(SADETC) MBR(SADETC)
                   MONMSG     MSGID(CPF0000)
                   RMVM       FILE(SAIR) MBR(SAIR)
                   MONMSG     MSGID(CPF0000)
 
                   OVRDBF     FILE(ACORDAB) SEQONLY(*YES 100)
                   OVRDBF     FILE(ACCNTAB) SEQONLY(*YES 100)
 
                   CPYF       FROMFILE(ACORDAA) TOFILE(ACCNTAA) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM ACCNTAA)
                   CPYF       FROMFILE(ACORDAB) TOFILE(ACCNTAB) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM ACCNTAB)
                   CPYF       FROMFILE(ACORDAC) TOFILE(ACCNTAC) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     (CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM ACCNTAC)
/* ER0999 START */
                   CPYF       FROMFILE(ACORDBX0) TOFILE(ACCNTBX0) +
                              MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2802)                        /* EMFIX*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ACCNTBX0))
/* ER0999 END */
 
                   DLTOVR     FILE(ACORDAB)
                   DLTOVR     FILE(ACCNTAB)
 
                   CLRPFM    FILE(ACORDAA)
                   CLRPFM    FILE(ACORDAB)
                   CLRPFM    FILE(ACORDAC)
                   CLRPFM     FILE(ACORDBX0)                        /* ER0999 */
             MONMSG     MSGID(CPF3142)                        /* EMFIX*/
 
                   CHGVAR     VAR(%SUBSTRING(&ERSTAT 43 1)) +
                              VALUE('N')
                   CHGDTAARA  DTAARA(ERSTAT) VALUE(&ERSTAT)
                   DLCOBJ     OBJ((ERSTAT *DTAARA *EXCLRD))
 
                ENDDO
 
             ENDDO
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG  MSG('JOB TERMINATED - FILE CONTROLS OUT +
                           OF BALANCE') TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             ADDLFM     FILE(ACCNT) MBR(ACCNT)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(ACNUM) MBR(ACNUM)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(SADETC) MBR(SADETC)
             MONMSG     MSGID(CPF0000)
             ADDLFM     FILE(SAIR) MBR(SAIR)
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
