/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas PM LE Daily transaction daily extract')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0396 - LE DAILY TRANSACTION EXTRACT                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 183309             Date 13Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPM004             Date 08Feb96              */
/*                      S01486             Date 04Oct94              */
/*                      049421             DATE 18JAN93              */
/*                      049467             DATE 18JAN93              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       183309 - Monitor for messages after CLOF and DLTOVR.        */
/*       CPM004  -  Bank Portfolios                                  */
/*       S01486  -  Portfolio Management Upgrade to R10              */
/*       049421  -  HEADER BOX STANDARDISATION                       */
/*       049467  -  RECOMPILED FOR RELEASE 3 PTF 02                  */
/*       R00300  -  Message file changes.                            */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RUN) TYPE(*CHAR) LEN(5)
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)                /*S01486*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01486*/
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
             DCLF       FILE(SDPORTPD)
             RCVF       RCDFMT(SDPORTD0)
             MONMSG     MSGID(CPF0000)
/* SET OFF SWITCHES                                              */
 
             CHGJOB     SWS(00000000)
/********************************************************************/
/*  GET RUN DATE FROM DTAARA/PMSTAT                                 */
/********************************************************************/
             RTVDTAARA  DTAARA(PMSTAT) RTNVAR(&PMSTAT)
             CHGVAR     VAR(&RUN) VALUE(%SST(&PMSTAT 6 5))
/********************************************************************/
/*  TEST DISPLAY NON-PORTFOLIO IDICATOR IN PM ICD                   */
/********************************************************************/
/************OVRDBF     FILE(CLOANQ1) SHARE(*YES)                     /*S01486*/
/************OVRDBF     FILE(LOAMSQK) SHARE(*YES)                     /*S01486*/
             OVRDBF     FILE(PMCLONL5) SHARE(*YES)                    /*S01486*/
             OVRDBF     FILE(PMLOAML0) SHARE(*YES)                    /*S01486*/
             MONMSG     MSGID(CPF0000)
 
/************IF         COND(&P9DP97 *EQ 'N') THEN(DO)                /*S01486*/
             IF         COND(&FCDP97 *EQ 'N') THEN(DO)                /*S01486*/
/************OPNQRYF    FILE((*LIBL/CLOANQ1)) QRYSLT('PTFR *NE "9997" /*S01486*/
/************             *AND *MAPFLD/LCD1 *EQ "' *CAT &RUN *CAT +   /*S01486*/
/************             '"') MAPFLD((LCDD LCD *ZONED 5) (LCD1 LCDD +/*S01486*/
/************             *CHAR 5))                                   /*S01486*/
             OPNQRYF    FILE((PMCLONL5)) QRYSLT('PTFR *NE "9997"       +
                          *AND *MAPFLD/LCD1 *EQ "' *CAT &RUN *CAT +
                          '"') MAPFLD((LCDD LCD *ZONED 5) (LCD1 LCDD +
                          *CHAR 5))                                   /*S01486*/
             ENDDO
 
/************IF         COND(&P9DP97 *EQ 'Y') THEN(DO)                /*S01486*/
             IF         COND(&FCDP97 *EQ 'Y') THEN(DO)                /*S01486*/
/************OPNQRYF    FILE((*LIBL/CLOANQ1)) QRYSLT(' *MAPFLD/LCD1 + /*S01486*/
/************             *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD /*S01486*/
/************             *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
             OPNQRYF    FILE((PMCLONL5)) QRYSLT(' *MAPFLD/LCD1 +
                          *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD +
                          *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
             ENDDO
/************OPNQRYF    FILE((*LIBL/LOAMSQK)) QRYSLT('*MAPFLD/LCD1 +  /*S01486*/
/************             *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD /*S01486*/
/************             *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
             OPNQRYF    FILE((PMLOAML0)) QRYSLT('*MAPFLD/LCD1 +
                          *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD +
                          *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
 
/************CALL       PGM(PM0396) PARM(&P9DP97)                     /*S01486*/
/************CALL       PGM(PM0396) PARM(&FCDP97)          /*S01486*/ /*CPM004*/
             CALL       PGM(PM0396)                                   /*CPM004*/
/************CLOF       OPNID(CLOANQ1)                                /*S01486*/
/************CLOF       OPNID(LOAMSQK)                                /*S01486*/
/************DLTOVR     FILE(CLOANQ1)                                 /*S01486*/
/************DLTOVR     FILE(LOAMSQK)                                 /*S01486*/
             CLOF       OPNID(PMCLONL5)                               /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             CLOF       OPNID(PMLOAML0)                               /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             DLTOVR     FILE(PMCLONL5)                                /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             DLTOVR     FILE(PMLOAML0)                                /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52)) /*S01486*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01486*/
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)          */
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +  /*S01486*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
/*                                                                    /*R00300*/
             CHGVAR     VAR(&MEM) VALUE('PMC0396  - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
 
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
