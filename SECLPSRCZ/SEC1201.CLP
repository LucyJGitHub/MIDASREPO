/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EUCLID Transmission')                        */
/*******************************************************************/
/*                                                                 */
/*         Midas - Securities Trading Module                       */
/*                                                                 */
/*         SEC1201 - EUCLID TRANSMISSION                           */
/*                                                                 */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                 */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 11MAY95            */
/*       PREV AMEND NO. S01502             DATE 08JUL94            */
/*                      S01117             DATE 10JAN91            */
/*                         S01271            DATE  08JUN90         */
/*                         S01190            DATE  23/02/89        */
/*                         S01179            DATE  16/09/88        */
/*                         S01175            DATE  01/07/88        */
/*                         S01158            DATE  09/05/88        */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*     S01408   Addition of core hook SEC1201MPS                   */
/*     S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*              change in length of SESTAT, 133 long.              */
/*     S01117 - MULTIBRANCHING                                     */
/*     S01271 - PAY/RECEIVE IN INPUT CYCLE                         */ /*S01271*/
/*              SE0430 NOW HAS A PARAMETER                         */ /*S01271*/
/*     S01190   EUCLID FIX/ENHANCEMENT                             */ /*S01190*/
/*     S01179   RELEASE                                            */ /*S01179*/
/*     S01175   EUCLID                                             */ /*S01175*/
/*     S01158   POST INCORPORATION DEVELOPMENT FIXES               */ /*S01158*/
/*                                                                 */
/*******************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM    PARM(&MSG2 &MSG3)                                * *S01117*/
             PGM    PARM(&MSG2 &MSG3 &RSEQ)                           /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/*    THE RESTART PROCESSING IS GEARED AROUND THE VALUE HELD IN     */
/*    POSITION 51 OF SESTAT - AS FOLLOWS :                          */
/*                                                                  */
/*    0 - NO ERROR IN LAST RUN OF WHOLE SUITE                       */
/*    1 - ERROR OCCURED DURING LAST TRANSMISSION, SO RECOVER        */
/*        SECURITY COPY OF S/SEEUCH & TRY AGAIN                     */
/*    2 - ERROR OCCURED DURING LAST REFORMATTING, SO RESTART THERE  */
/*    3 - ERROR OCCURED DURING LAST REPORTING, SO RESTART THERE     */
/*                                                                  */
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)              /*S01158*/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01158*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCLF       FILE(EUCLIDWAIT)
/* S01179                                                          */ /*S01179*/
/*********   DCLDTAARA  DTAARA(SESTAT)                       *******/ /*S01179*/
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(256)*/    /*S01179 S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
/* S01179                                                          */ /*S01179*/
/*********   DCLDTAARA  DTAARA(SDSTAT)                       *******/ /*S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/* S01179                                                          */ /*S01179*/
/*********   RCVDTAARA  DTAARA(SESTAT)                      ********/ /*S01179*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01179*/
/* S01179                                                          */ /*S01179*/
/*********   RCVDTAARA  DTAARA(SDSTAT)                      ********/ /*S01179*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))             /*S01158*/
/************CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')     *S01158 S01117*/
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')          /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC1201MPS                                          */
                                                                      /*S01408*/
/**/
/*    IF RESTART FLAG = '2' OR '3', NO NEED TO RERUN THIS COMPONENT */
/**/
             IF         COND((%SST(&SESTAT 51 1) = '2') *OR (+
                             %SST(&SESTAT 51 1) = '3')) THEN(+
                GOTO       CMDLBL(ENDPGM))
/**/
/*    IF FLAG ='0', SAVE SECURITY COPY OF S/SEEUCH & SET FLAG TO '1' */
/**/
             IF         COND(%SST(&SESTAT 51 1) = '0') THEN(DO)
/*              CLRPFM     FILE(SSEUCH)                       */      /*S01158*/
/*              CLRPFM     FILE(SSEUCD0)                      */      /*S01158*/
/*              CLRPFM     FILE(SSEUCD1)                      */      /*S01158*/
/*              CLRPFM     FILE(SSEUCD2)                      */      /*S01158*/
/*              CLRPFM     FILE(SSEUCA)                       */      /*S01158*/
/*              CPYF       FROMFILE(SEEUCH) TOFILE(SSEUCH) +
                          MBROPT(*ADD)                        */      /*S01158*/
/*              MONMSG     MSGID(CPF2817)                     */      /*S01158*/
/*              CPYF       FROMFILE(SEEUCD0) TOFILE(SSEUCD0) +
                          MBROPT(*ADD)                         */     /*S01158*/
/*              MONMSG     MSGID(CPF2817)                      */     /*S01158*/
/*              CPYF       FROMFILE(SEEUCD1) TOFILE(SSEUCD1) +
                          MBROPT(*ADD)                         */     /*S01158*/
/*              MONMSG     MSGID(CPF2817)                      */     /*S01158*/
/*              CPYF       FROMFILE(SEEUCD2) TOFILE(SSEUCD2) +
                          MBROPT(*ADD)                         */     /*S01158*/
/*              MONMSG     MSGID(CPF2817)                      */     /*S01158*/
/******         CPYF       FROMFILE(SSEUCA) TOFILE(SSEUCA) +     ***/ /*S01158*/
/*              CPYF       FROMFILE(SEEUCA) TOFILE(SSEUCA) +
                          MBROPT(*ADD)                         */     /*S01158*/
/*              MONMSG     MSGID(CPF2817)                      */     /*S01158*/
             CPYF       FROMFILE(SEEUCH) TOFILE(&TOLIB/SSEUCH) +
                      MBROPT(*REPLACE) CRTFILE(*YES)                  /*S01190*/
/************             MBROPT(*ADD) CRTFILE(*YES)   */  /*S01158*/ /*S01190*/
/************   MONMSG     MSGID(CPF2817) */                          /*S01190*/
       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM SSEUCH)  /*S01190*/
             CPYF       FROMFILE(SEEUCD0) TOFILE(&TOLIB/SSEUCD0) +
                      MBROPT(*REPLACE) CRTFILE(*YES)                  /*S01190*/
/************             MBROPT(*ADD) CRTFILE(*YES)   */  /*S01158*/ /*S01190*/
/************   MONMSG     MSGID(CPF2817) */                          /*S01190*/
       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM SSEUCD0) /*S01190*/
             CPYF       FROMFILE(SEEUCD1) TOFILE(&TOLIB/SSEUCD1) +
                      MBROPT(*REPLACE) CRTFILE(*YES)                  /*S01190*/
/************             MBROPT(*ADD) CRTFILE(*YES)   */  /*S01158*/ /*S01190*/
/************   MONMSG     MSGID(CPF2817) */                          /*S01190*/
       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM SSEUCD1) /*S01190*/
             CPYF       FROMFILE(SEEUCD2) TOFILE(&TOLIB/SSEUCD2) +
                      MBROPT(*REPLACE) CRTFILE(*YES)                  /*S01190*/
/************             MBROPT(*ADD) CRTFILE(*YES)   */  /*S01158*/ /*S01190*/
/************   MONMSG     MSGID(CPF2817) */                          /*S01190*/
       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM SSEUCD2) /*S01190*/
             CPYF       FROMFILE(SEEUCD3) TOFILE(&TOLIB/SSEUCD3) +
                      MBROPT(*REPLACE) CRTFILE(*YES)                  /*S01190*/
       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM SSEUCD3) /*S01190*/
             CPYF       FROMFILE(SEEUCD4) TOFILE(&TOLIB/SSEUCD4) +
                      MBROPT(*REPLACE) CRTFILE(*YES)                  /*S01190*/
       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM SSEUCD4) /*S01190*/
             CPYF       FROMFILE(SEEUCD5) TOFILE(&TOLIB/SSEUCD5) +
                          MBROPT(*REPLACE) CRTFILE(*YES) /*S01190*/
       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM SSEUCD5) /*S01190*/
             CPYF       FROMFILE(SEEUCA) TOFILE(&TOLIB/SSEUCA) +
                      MBROPT(*REPLACE) CRTFILE(*YES)                  /*S01190*/
/************             MBROPT(*ADD) CRTFILE(*YES)   */  /*S01158*/ /*S01190*/
                MONMSG     MSGID(CPF2817)
                CHGDTAARA  DTAARA(SESTAT (51 1)) VALUE('1')
             ENDDO
/**/
             ELSE (DO)
/**/
/*    IF FLAG ='1', RECOVER COPY OF S/SEEUCH                         */
/**/
                CLRPFM     FILE(SEEUCH)
                CLRPFM     FILE(SEEUCD0)
                CLRPFM     FILE(SEEUCD1)
                CLRPFM     FILE(SEEUCD2)
                CLRPFM     FILE(SEEUCD3)                              /*S01190*/
                CLRPFM     FILE(SEEUCD4)                              /*S01190*/
                CLRPFM     FILE(SEEUCD5)                              /*S01190*/
                CLRPFM     FILE(SEEUCA)
                CPYF       FROMFILE(SSEUCH) TOFILE(SEEUCH) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD0) TOFILE(SEEUCD0) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD1) TOFILE(SEEUCD1) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD2) TOFILE(SEEUCD2) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD3) TOFILE(SEEUCD3) +
                          MBROPT(*ADD)                                /*S01190*/
                MONMSG     MSGID(CPF2817)                             /*S01190*/
                CPYF       FROMFILE(SSEUCD4) TOFILE(SEEUCD4) +
                          MBROPT(*ADD)                                /*S01190*/
                MONMSG     MSGID(CPF2817)                             /*S01190*/
                CPYF       FROMFILE(SSEUCD5) TOFILE(SEEUCD5) +
                          MBROPT(*ADD)                                /*S01190*/
                MONMSG     MSGID(CPF2817)                             /*S01190*/
                CPYF       FROMFILE(SSEUCA) TOFILE(SEEUCA) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
             ENDDO
/**/
/*     CALL TRANSMISSION PROMPT                                      */
/**/
             CLRPFM     FILE(SEEUZH)
             CLRPFM     FILE(SEEUZD0)
             CLRPFM     FILE(SEEUZD1)
             CLRPFM     FILE(SEEUZD2)
             CLRPFM     FILE(SEEUZD3)                                 /*S01190*/
             CLRPFM     FILE(SEEUZD4)                                 /*S01190*/
             CLRPFM     FILE(SEEUZD5)                                 /*S01190*/
             CLRPFM     FILE(SEEUZA)
             CLRPFM     FILE(ECTRF)
             CALL       PGM(SE1200)
/**/
/*   RESET REPORT REQUESTED INDICATOR                                */
/**/
             CHGDTAARA      DTAARA(SESTAT (52 1)) VALUE(' ')
/**/
/*   IF CMD/1 TAKEN IN SE1200, RESET FLAG & END                      */
/**/
             IF         COND(%SWITCH(000XXXXX)) THEN(DO)
/**/
/*  IF CMD/1 TAKEN USER MAY HAVE REJECTED TRANSMISSION AFTER SE1200 */
/*    HAD DELETED ECTLX RECORDS AND SENT USER A MSG THAT MORE THAN  */
/*    500 INSTRUCTIONS WERE AVAILABLE FOR SENDING (REST IGNORED     */
/*    UNTIL NEXT RUN) - SO RESTORE FROM SAVED FILES BEFORE ENDING   */
/**/
                CLRPFM     FILE(SEEUCH)
                CLRPFM     FILE(SEEUCD0)
                CLRPFM     FILE(SEEUCD1)
                CLRPFM     FILE(SEEUCD2)
                CLRPFM     FILE(SEEUCD3)                              /*S01190*/
                CLRPFM     FILE(SEEUCD4)                              /*S01190*/
                CLRPFM     FILE(SEEUCD5)                              /*S01190*/
                CLRPFM     FILE(SEEUCA)
                CPYF       FROMFILE(SSEUCH) TOFILE(SEEUCH) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD0) TOFILE(SEEUCD0) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
 /************* CPYF       FROMFILE(SSECUD1) TOFILE(SEEUCD1) +     */ /*S01190*/
                CPYF       FROMFILE(SSEUCD1) TOFILE(SEEUCD1) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD2) TOFILE(SEEUCD2) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD3) TOFILE(SEEUCD3) +
                          MBROPT(*ADD)                                /*S01190*/
                MONMSG     MSGID(CPF2817)                             /*S01190*/
                CPYF       FROMFILE(SSEUCD4) TOFILE(SEEUCD4) +
                          MBROPT(*ADD)                                /*S01190*/
                MONMSG     MSGID(CPF2817)                             /*S01190*/
                CPYF       FROMFILE(SSEUCD5) TOFILE(SEEUCD5) +
                          MBROPT(*ADD)                                /*S01190*/
                MONMSG     MSGID(CPF2817)                             /*S01190*/
                CPYF       FROMFILE(SSEUCA) TOFILE(SEEUCA) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CHGDTAARA  DTAARA(SESTAT (51 1)) VALUE('0')
                GOTO      CMDLBL(ENDPGM)
             ENDDO
/**/
/*   CHECK IF ERROR FOUND IN SE1200                                  */
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ENDPGM))
/**/
/*   CLEAR BACKLOG FILE, IF REQUESTED                                */
/**/
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)
                CLRPFM    FILE(EDUMP)
                CHGDTAARA      DTAARA(SESTAT (52 1)) VALUE('Y')
             ENDDO
/**/
/*     VARY OFF & ON THE COMMUNICATION DEVICES REQUIRED              */
/**/
/****        VRYLIN     LINE(STLIN) STATUS(*OFF)              ****/   /*S01158*/
/****        MONMSG     MSGID(CPF2640)                        ****/   /*S01158*/
/**/                                                                  /*S01158*/
/****        VRYDEV     DEV(STDEV) STATUS(*OFF)               ****/   /*S01158*/
/****        MONMSG     MSGID(CPF2640)                        ****/   /*S01158*/
/**/                                                                  /*S01158*/
/****        VRYCTLU    CTLU(STCTLU) STATUS(*OFF)             ****/   /*S01158*/
/****        MONMSG     MSGID(CPF2640)                        ****/   /*S01158*/
/**/
/*****       VRYLIN     LINE(STLIN) STATUS(*ON)                 ****/ /*S01158*/
/**/
/*****       VRYCTLU    CTLU(STCTLU) STATUS(*ON)                ****/ /*S01158*/
/**/
/*****       VRYDEV     DEV(STDEV) STATUS(*ON)                  ****/ /*S01158*/
/**/                                                                  /*S01158*/
             VRYCFG     CFGOBJ(EUCLID) CFGTYPE(*DEV) STATUS(*OFF)     /*S01158*/
             MONMSG     MSGID(CPF2640)                                /*S01158*/
             VRYCFG     CFGOBJ(EUCLID) CFGTYPE(*CTL) STATUS(*OFF)     /*S01158*/
             MONMSG     MSGID(CPF2640)                                /*S01158*/
             VRYCFG     CFGOBJ(EUCLID) CFGTYPE(*LIN) STATUS(*OFF)     /*S01158*/
             MONMSG     MSGID(CPF2640)                                /*S01158*/
             VRYCFG     CFGOBJ(EUCLID) CFGTYPE(*LIN) STATUS(*ON)      /*S01158*/
             VRYCFG     CFGOBJ(EUCLID) CFGTYPE(*CTL) STATUS(*ON)      /*S01158*/
             VRYCFG     CFGOBJ(EUCLID) CFGTYPE(*DEV) STATUS(*ON)      /*S01158*/
/**/
/*     SEND MESSAGE                                                  */
/**/
             SNDF       RCDFMT(EUCLIDF1)
             CHGVAR     VAR(&MSG1) VALUE(' ')
             CHGVAR     VAR(&MSG2) VALUE(' ')
             CHGVAR     VAR(&MSG3) VALUE('EUCLID Transmission In +
                        Progress')
             SNDF       RCDFMT(EUCLIDF2)
/**/
/*     CALL TRANSMISSION PROGRAM                                     */
/**/
             CHGJOB     SWS(XXX0X000)
/*******************************************************************/ /*S01179*/
/**   CURRENTLY MIDAS SYSTEM USES FILE BSCF - A 38 MODE OBJECT -  **/ /*S01179*/
/**COMMAND CRTBSCF IS NOT SUPPORTED ON AS/400. THIS OVERRIDE IS TO**/ /*S01179*/
/**  ENSURE FILE WILL RUN IF CREATED WITH THE WRONG ATTRIBUTES.   **/ /*S01179*/
/**     FILE SHOULD EXIST WITH ATTRIBUTES AS SPECIFIED BELOW.     **/ /*S01179*/
/*********** OVRBSCF    FILE(BSCF) TOFILE(BSCF) DEV(EUCLID) +  *****/ /*S01179*/
/***********              BLOCK(*ITB) BLKLEN(82) TRNSPY(*NO) + *****/ /*S01179*/
/***********              DTACPR(*NO)                 *S01175* *****/ /*S01179*/
/*******************************************************************/ /*S01179*/
/************CALL       PGM(SE1210)                                  * *S01117*/
             CALL       PGM(SE1210) PARM(&RSEQ)                       /*S01117*/
/**/
/*     VARY OFF THE COMMUNICATION DEVICES USED                       */
/**/
/*           VRYLIN     LINE(STLIN) STATUS(*OFF)                   */ /*S01175*/
/*           MONMSG     MSGID(CPF2640)                             */ /*S01175*/
             VRYCFG     CFGOBJ(EUCLID) CFGTYPE(*DEV) STATUS(*OFF)     /*S01175*/
             MONMSG     MSGID(CPF2640)                                /*S01175*/
/**/
/*           VRYDEV     DEV(STDEV) STATUS(*OFF)                    */ /*S01175*/
/*           MONMSG     MSGID(CPF2640)                             */ /*S01175*/
             VRYCFG     CFGOBJ(EUCLID) CFGTYPE(*CTL) STATUS(*OFF)     /*S01175*/
             MONMSG     MSGID(CPF2640)                                /*S01175*/
/**/
/*           VRYCTLU    CTLU(STCTLU) STATUS(*OFF)                  */ /*S01175*/
/*           MONMSG     MSGID(CPF2640)                             */ /*S01175*/
             VRYCFG     CFGOBJ(EUCLID) CFGTYPE(*LIN) STATUS(*OFF)     /*S01175*/
             MONMSG     MSGID(CPF2640)                                /*S01175*/
/**/
/*********** DLTOVR BSCF ************************************S01175*/ /*S01179*/
/**/
/**/
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
             DSPSPLF    FILE(SE1210P1) SPLNBR(*LAST)                  /*S01190*/
                CHGVAR     VAR(&MSG) VALUE('Was Transmission Succe+
                        ssful (''Y'' or ''N'') ?')
RETRY:
                SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) MSGTYPE(*INQ)
                RCVMSG    PGMQ(*EXT) MSGTYPE(*RPY) WAIT(*MAX) MSG(&RPY)
/**/
                SNDF       RCDFMT(EUCLIDF1)
                SNDF       RCDFMT(EUCLIDF2)
/**/
                IF       COND((&RPY ='N') | (&RPY ='n')) THEN(DO)
                   CHGJOB     SWS(XXXXX1XX)
                   GOTO       CMDLBL(OKAY)
                ENDDO
/**/
                IF       COND((&RPY ='Y') | (&RPY ='y')) THEN(DO)
/**/
/*              IF TRANSMISSION SELECTED, PRODUCE AUDIT TRAIL       */
/**/
                   IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
/**/
/*     SEND MESSAGE                                                  */
/**/
                      CHGVAR     VAR(&MSG1) VALUE(&MSG2)
                      CHGVAR     VAR(&MSG2) VALUE(&MSG3)
                      CHGVAR     VAR(&MSG3) VALUE('EUCLID Transmissio+
                        n Audit Trail')
                      SNDF       RCDFMT(EUCLIDF2)
                      OVRDBF     FILE(SEEUC) TOFILE(SEEUZ)
/****************     CALL       PGM(SE0430)     ****************  S01271  **/
/*********************CALL       PGM(SE0430) PARM('T')        *S01271* *S01117*/
                      CALL       PGM(SE0430) PARM('T' &RSEQ)          /*S01117*/
                      DLTOVR     FILE(SEEUC)
                      IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                         CHGJOB     SWS(XXXXX100)
                         GOTO       CMDLBL(OKAY)
                      ENDDO
                   ENDDO
/**/
/*                 ON COMPLETION SET INDICATOR FOR NEXT COMPONENT   */
/**/
                   IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/* S01179                                                          */ /*S01179*/
/*********            RCVDTAARA  DTAARA(SESTAT)             ********/ /*S01179*/
                      RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)       /*S01179*/
                      IF         COND(%SST(&SESTAT 52 1) ='Y') THEN(+
                         CHGDTAARA  DTAARA(SESTAT (51 1)) VALUE('2'))
                      ELSE (+
                         CHGDTAARA  DTAARA(SESTAT (51 1)) VALUE('0'))
                      GOTO       CMDLBL(ENDPGM)
                   ENDDO
                ENDDO
                GOTO       CMDLBL(RETRY)
             ENDDO
/**/
/*  CHECK IF ERROR HAS OCCURED (OR TRANSMISSION REFUSED)             */
/**/
OKAY:
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
/**/
/*  RECOVER S/SEEUCH & SET FLAG TO '0'                               */
/**/
                CLRPFM     FILE(SEEUCH)
                CLRPFM     FILE(SEEUCD0)
                CLRPFM     FILE(SEEUCD1)
                CLRPFM     FILE(SEEUCD2)
                CLRPFM     FILE(SEEUCD3)                              /*S01190*/
                CLRPFM     FILE(SEEUCD4)                              /*S01190*/
                CLRPFM     FILE(SEEUCD5)                              /*S01190*/
                CLRPFM     FILE(SEEUCA)
/**/
                CPYF       FROMFILE(SSEUCH) TOFILE(SEEUCH) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
/****           CPYF       FROMFILE(SSECUD0) TOFILE(SEEUCD0) + ***/   /*S01158*/
                CPYF       FROMFILE(SSEUCD0) TOFILE(SEEUCD0) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD1) TOFILE(SEEUCD1) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD2) TOFILE(SEEUCD2) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CPYF       FROMFILE(SSEUCD3) TOFILE(SEEUCD3) +
                          MBROPT(*ADD)                                /*S01190*/
                MONMSG     MSGID(CPF2817)                             /*S01190*/
                CPYF       FROMFILE(SSEUCD4) TOFILE(SEEUCD4) +
                          MBROPT(*ADD)                                /*S01190*/
                MONMSG     MSGID(CPF2817)                             /*S01190*/
                CPYF       FROMFILE(SSEUCD5) TOFILE(SEEUCD5) +
                          MBROPT(*ADD)                                /*S01190*/
                MONMSG     MSGID(CPF2817)                             /*S01190*/
                CPYF       FROMFILE(SSEUCA) TOFILE(SEEUCA) +
                          MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
                CHGDTAARA  DTAARA(SESTAT (51 1)) VALUE('0')
/**/
/*  ABNORMAL TERMINATION MESSAGES                                    */
/**/
/*  RECEIVE ERROR                                                    */
/**/
                IF         COND(%SWITCH(XXXXX110)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('File/communication er+
                              ror - RECEIVE')
                   SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                              MSGTYPE(*INFO)
                   CHGJOB     SWS(XXXXXX00)
                ENDDO
/**/
/*  SEND ERROR                                                       */
/**/
                IF         COND(%SWITCH(XXXXX101)) THEN(DO)
                   CHGVAR     VAR(&MSG) VALUE('File/communication er+
                              ror - SEND')
                   SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                              MSGTYPE(*INFO)
                   CHGJOB     SWS(XXXXXX00)
                ENDDO
             ENDDO
/**/
/*ENDPGM:*****ENDPGM                                                 * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01117*/
