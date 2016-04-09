/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Update Portfolio Positions')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Portfolio Management Module                     */
/*                                                                   */
/*       PMC1100 - PM UPDATE PORTFOLIO POSITIONS                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01486             DATE 17OCT94              */
/*       PREV AMEND NO. 051105     GB      DATE 18FEB93              */
/*                      051103     GB      DATE 18FEB93              */
/*                      049421             DATE 18JAN93              */
/*                      S01189     GB      DATE 25MAR92              */
/*                      B4822              DATE 10OCT91              */
/*                      B5773              DATE 04APR91              */
/*                      R00300             DATE 28AUG90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01486 - Private Banking Upgrade to Release 10              */
/*       051105 - ALL RPG PGMS USE SWITCH-8 FOR DB ERROR,            */
/*                BUT DB ERROR IN CL PGM IS CONDITIONNED             */
/*                BY SWITCHES 7 AND 8                                */
/*       051103 - COB RECOVERY PROCESSING CALLED FROM SEC0606T       */
/*                (SUPPRESS S01189)                                  */
/*       049421 - HEADER BOX STANDARDISATION                         */
/*       S01189 - COB RECOVERY PROCESSING                            */
/*       B4822  - OBTAIN OTHER POSITION FROM DIFFERENT FILE          */
/*       B5773  - INCLUDE PORTFOLIO MANAGEMENT. CHANGES ORDER OF     */
/*                PGMS                                               */
/*       R00300 - Message file changes.                              */
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
/**********  DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)                 051103 */
 
/************DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)            *S01486*/
/************DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)            *S01486*/
/************DCL        VAR(&PMSTAT)  TYPE(*CHAR)  LEN(256)            *S01486*/
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                  *S01486*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01486*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(79)
             DCL        VAR(&TFRDON)  TYPE(*CHAR)  LEN(1)
 
 
/*  SETUP AND SEND PGM MESSAGE                                      */
 
             CHGVAR     VAR(&MSG) VALUE('PMC1100 - Update Portfolio +
                          Positions')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*  SET OFF ALL SWITCHES                                            */
 
             CHGJOB SWS(00000000)
 
/*  IF TRANSFERS HAVE BEEN DONE TODAY,THEN PROCESS THEM FIRST       */
 
             RTVDTAARA DTAARA(PMSTAT (19 1))  RTNVAR(&TFRDON)
 
             IF         COND(&TFRDON *EQ 'Y') THEN(DO)
 
/*                CALL PROGRAM : UPDATE TRADE DATE PORTFOLIO        */
/*                               POSITIONS IF BACKVALUATION         */
 
             OVRDBF     FILE(PMRPSXLL) TOFILE(PMRPSTLL) SHARE(*NO)
/************OVRDBF     FILE(CAPRALX) TOFILE(CAPRALT) SHARE(*NO)       *S01486*/
             OVRDBF     FILE(CAPRALX) TOFILE(PMCAPRL0) SHARE(*NO)     /*S01486*/
 
                CALL       PGM(PM1120) PARM('T')
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                GOTO ERROR
                ENDDO
 
/*                CALL PROGRAM : TRADE DATE CUSTOMER         */
/*                               PORTFOLIO POSITIONS REPORT         */
 
                CALL       PGM(PM1300) PARM('T' 'Y')
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                GOTO ERROR
                ENDDO
 
             OVRDBF     FILE(PMRPSXLL) TOFILE(PMRPSVLL) SHARE(*NO)
/************OVRDBF     FILE(CAPRALX) TOFILE(CAPRALV) SHARE(*NO)       *S01486*/
             OVRDBF     FILE(CAPRALX) TOFILE(PMCAPRL1) SHARE(*NO)     /*S01486*/
 
/*                CALL PROGRAM : UPDATE VALUE DATE PORTFOLIO        */
/*                               POSITIONS IF BACKVALUATION         */
 
                CALL       PGM(PM1120) PARM('V')
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                GOTO ERROR
                ENDDO
 
/*                CALL PROGRAM : VALUE DATE CUSTOMER         */
/*                               PORTFOLIO POSITIONS REPORT         */
 
                CALL       PGM(PM1300) PARM('V' 'Y')
                IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                GOTO ERROR
                ENDDO
 
                DLTOVR     FILE(*ALL)
 
             ENDDO
 
/*  NOW PROCESS TODAYS TRADES/DEPOT MOVEMENTS                       */
/*  OVERRIDE FILES                                                  */
 
             OVRDBF     FILE(PMRPSXLL) TOFILE(PMRPSTLL) SHARE(*NO)
/************OVRDBF     FILE(CAPRTDX) TOFILE(CAPRTDT) SHARE(*NO)       *S01486*/
/************OVRDBF     FILE(CAPRALX) TOFILE(CAPRALT) SHARE(*NO)       *S01486*/
             OVRDBF     FILE(CAPRTDX) TOFILE(PMCAPRL2) SHARE(*NO)     /*S01486*/
             OVRDBF     FILE(CAPRALX) TOFILE(PMCAPRL0) SHARE(*NO)     /*S01486*/
             OVRDBF     FILE(PMCPOSLX) TOFILE(PMCPOSLL) SHARE(*NO)     /*B4822*/
 
/*  CALL PROGRAM : UPDATE TRADE DATE PORTFOLIO POSITIONS            */
/*                 IF NO BACKVALUATION                              */
 
             CALL       PGM(PM1110) PARM('T')
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             GOTO ERROR
             ENDDO
 
/*  CALL PROGRAM : UPDATE TRADE DATE PORTFOLIO                      */
/*                 POSITIONS IF BACKVALUATION                       */
 
             CALL       PGM(PM1120) PARM('T')
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             GOTO ERROR
             ENDDO
 
/*  CALL PROGRAM : TRADE DATE CUSTOMER                              */
/*                 PORTFOLIO POSITIONS REPORT                       */
 
             CALL       PGM(PM1300) PARM('T' ' ')
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             GOTO ERROR
             ENDDO
 
             DLTOVR     FILE(*ALL)
 
/*   OVERRIDE FILES                                                 */
 
             OVRDBF     FILE(PMRPSXLL) TOFILE(PMRPSVLL) SHARE(*NO)
/************OVRDBF     FILE(CAPRTDX) TOFILE(CAPRTDV) SHARE(*NO)       *S01486*/
/************OVRDBF     FILE(CAPRALX) TOFILE(CAPRALV) SHARE(*NO)       *S01486*/
             OVRDBF     FILE(PMCAPRL2) TOFILE(PMCAPRL3) SHARE(*NO)    /*S01486*/
             OVRDBF     FILE(CAPRALX) TOFILE(PMCAPRL1) SHARE(*NO)     /*S01486*/
             OVRDBF     FILE(PMCPOSLX) TOFILE(PMCPOSLL) SHARE(*NO)     /*B4822*/
 
/*  CALL PROGRAM : UPDATE VALUE DATE PORTFOLIO POSITIONS            */
/*                 IF NO BACKVALUATION                              */
 
             CALL       PGM(PM1110) PARM('V')
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             GOTO ERROR
             ENDDO
 
/*  CALL PROGRAM : UPDATE VALUE DATE PORTFOLIO                      */
/*                 POSITIONS IF BACKVALUATION                       */
 
             CALL       PGM(PM1120) PARM('V')
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             GOTO ERROR
             ENDDO
 
/*  CALL PROGRAM : VALUE DATE CUSTOMER                              */
/*                 PORTFOLIO POSITIONS REPORT                       */
 
             CALL       PGM(PM1300) PARM('V' ' ')
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             GOTO ERROR
             ENDDO
 
/*  FOR DATABASE ERRORS RECOVER DATA FROM LDA                       */
 
/* >>> 051105 >>> */
/******** ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           ***/
 ERROR:      IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/* <<< 051105 <<< */
/***************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)           *S01486*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&MEM)          /*S01486*/
/*                                                                    /*R00300*/
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
***************************TOMSGQ(MOPERQ MRUNQ)                      */
/***************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +*S01486*/
/***************           TOMSGQ(MOPERQ MRUNQ)                        *S01486*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)                       /*S01486*/
/*                                                                    /*R00300*/
                CHGVAR     VAR(&MEM) VALUE('PMC1100 - Job Terminated, +
                                            Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/***IF*U7*AND*U8*OFF,*CHANGE*PMSTAT*TO*"OLD"************************** *S01486*/
/*********************AND*TRANSFERS*DONE*TODAY*INDICATOR*TO*"NO"****** *S01486*/
/*  IF U7 AND U8 OFF, CHANGE TRANSFERS DONE TODAY INDICATOR TO 'NO'  * *S01486*/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/***************CHGDTAARA  DTAARA(PMSTAT (19 3)) VALUE('N')            *S01486*/
                CHGDTAARA  DTAARA(PMSTAT (19 1)) VALUE('N')           /*S01486*/
             ENDDO
 
/***ENDPGM:******ENDPGM                                              * *S01486*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01486*/
