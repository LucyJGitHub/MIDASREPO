/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM DL Daily transaction daily extract')         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC0394 - DL DAILY TRANSACTION EXTRACT                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. 183309             Date 13Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPM004             Date 08Feb96              */
/*                      081339             Date 13Dec94              */
/*                      S01486             DATE 03OCT94              */
/*                      58933              DATE 27JUL93              */
/*                      049421             DATE 18JAN93              */
/*                      049467             DATE 18JAN93              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       183309 - Monitor for messages after CLOF and DLTOVR.        */
/*       CPM004 - Bank Portfolios                                    */
/*       081339 - Override does not exist                            */
/*       S01486 - Portfolio Management Upgrade to R10                */
/*       58933  - REMOVE FRA/IRS INTERFACE FROM PORTFOLIO MANAGEMENT */
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
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)*******/        /*S01486*/
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
/*********** OVRDBF     FILE(DEALSQB) SHARE(*YES)                     /*S01486*/
/*********** OVRDBF     FILE(DEALSQC) SHARE(*YES)                     /*S01486*/
/*           OVRDBF     FILE(DEALSQG) SHARE(*YES)              58933 */
/************OVRDBF     FILE(DEAMSQI) SHARE(*YES)                     /*S01486*/
             OVRDBF     FILE(PMDEALL6) SHARE(*YES)                    /*S01486*/
             OVRDBF     FILE(PMDEALL7) SHARE(*YES)                    /*S01486*/
             OVRDBF     FILE(PMDEAML0) SHARE(*YES)                    /*S01486*/
             MONMSG     MSGID(CPF0000)
/*********** IF         COND(&P9DP97 *EQ 'N') THEN(DO)****/           /*S01486*/
             IF         COND(&FCDP97 *EQ 'N') THEN(DO)                /*S01486*/
/***********                                                          /*S01486*/
/*********** OPNQRYF    FILE((*LIBL/DEALSQB)) QRYSLT(' PTFR *NE +     /*S01486*/
/***********              "9997" *AND *MAPFLD/LCD1 *EQ "' *CAT &RUN + /*S01486*/
/***********              *CAT '"') MAPFLD((LCDD LCD *ZONED 5) (LCD1 +/*S01486*/
/***********              LCDD *CHAR 5))                              /*S01486*/
/*********** OPNQRYF    FILE((*LIBL/DEALSQC)) QRYSLT(' PTFR *NE +     /*S01486*/
/***********              "9997" *AND *MAPFLD/LCD1 *EQ "' *CAT &RUN + /*S01486*/
/***********              *CAT '"') MAPFLD((LCDD LCD *ZONED 5) (LCD1 +/*S01486*/
/***********              LCDD *CHAR 5))                              /*S01486*/
/*           OPNQRYF    FILE((*LIBL/DEALSQG)) QRYSLT(' PTFR *NE +
                          "9997" *AND *MAPFLD/LCD1 *EQ "' *CAT &RUN +
                          *CAT '"') MAPFLD((LCDD LCD *ZONED 5) (LCD1 +
                          LCDD *CHAR 5))                       58933 */
             OPNQRYF    FILE((PMDEALL6)) QRYSLT(' PTFR *NE +
                          "9997" *AND *MAPFLD/LCD1 *EQ "' *CAT &RUN +
                          *CAT '"') MAPFLD((LCDD LCD *ZONED 5) (LCD1 +
                          LCDD *CHAR 5))                              /*S01486*/
             OPNQRYF    FILE((PMDEALL7)) QRYSLT(' PTFR *NE +
                          "9997" *AND *MAPFLD/LCD1 *EQ "' *CAT &RUN +
                          *CAT '"') MAPFLD((LCDD LCD *ZONED 5) (LCD1 +
                          LCDD *CHAR 5))                              /*S01486*/
             ENDDO
 
 
/*********** IF         COND(&P9DP97 *EQ 'Y') THEN(DO) ********/      /*S01486*/
             IF         COND(&FCDP97 *EQ 'Y') THEN(DO)                /*S01486*/
 
 
/*********** OPNQRYF    FILE((*LIBL/DEALSQB)) QRYSLT(' *MAPFLD/LCD1 + /*S01486*/
/***********              *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD +*S01486*/
/***********              *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
/*********** OPNQRYF    FILE((*LIBL/DEALSQC)) QRYSLT(' *MAPFLD/LCD1 + /*S01486*/
/***********              *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD +*S01486*/
/***********              *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
/*           OPNQRYF    FILE((*LIBL/DEALSQG)) QRYSLT(' *MAPFLD/LCD1 +
                          *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD +
                          *ZONED 5) (LCD1 LCDD *CHAR 5))       58933 */
 
             OPNQRYF    FILE((PMDEALL6)) QRYSLT(' *MAPFLD/LCD1 +
                          *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD +
                          *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
             OPNQRYF    FILE((PMDEALL7)) QRYSLT(' *MAPFLD/LCD1 +
                          *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD +
                          *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
             ENDDO
 
/************OPNQRYF    FILE((*LIBL/DEAMSQI)) QRYSLT(' *MAPFLD/LCD1 + /*S01486*/
/************             *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD /*S01486*/
/************             *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
             OPNQRYF    FILE((PMDEAML0)) QRYSLT(' *MAPFLD/LCD1 +
                          *EQ "' *CAT &RUN *CAT '"') MAPFLD((LCDD LCD +
                          *ZONED 5) (LCD1 LCDD *CHAR 5))              /*S01486*/
 
/*********** CALL       PGM(PM0394) PARM(&P9DP97)                     /*S01486*/
/*********** CALL       PGM(PM0394) PARM(&FCDP97)          /*S01486*/ /*CPM004*/
             CALL       PGM(PM0394)                                   /*CPM004*/
 
/************CLOF       OPNID(DEALSQB)                                /*S01486*/
/************CLOF       OPNID(DEALSQC)                                /*S01486*/
/*           CLOF       OPNID(DEALSQG)                         58933 */
/************CLOF       OPNID(DEAMSQI)                                /*S01486*/
             CLOF       OPNID(PMDEALL6)                               /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             CLOF       OPNID(PMDEALL7)                               /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             CLOF       OPNID(PMDEAML0)                               /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
 
/*********** DLTOVR     FILE(DEALSQB)                                 /*S01486*/
/*********** DLTOVR     FILE(DEALSQC)                                 /*S01486*/
/*           DLTOVR     FILE(DEALSQG)                          58933 */
/*********** DLTOVR     FILE(DEAMSQI)                                 /*S01486*/
             DLTOVR     FILE(PMDEALL6)                                /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
             DLTOVR     FILE(PMDEALL7)                                /*S01486*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
/*********** DLTOVR     FILE(PMDEALL0) *******                /*S01486* 081339*/
             DLTOVR     FILE(PMDEAML0)                                /*081339*/
             MONMSG     MSGID(CPF0000)                                /*183309*/
 
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
/************** CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52)) /*S01486*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 134 50)) /*S01486*/
/*                                                                    /*R00300*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(LXGBMSGF) MSGDTA(&MEM) +
**************************TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)          */
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +  /*S01486*/
/*************************TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
/*                                                                    /*R00300*/
             CHGVAR     VAR(&MEM) VALUE('PMC0390  - JOB TERMINATED, +
                          DATABASE IN ERROR')
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
 
/*ENDPGM:***  ENDPGM                                               */ /*S01486*/
 ENDPGM:                                                              /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
