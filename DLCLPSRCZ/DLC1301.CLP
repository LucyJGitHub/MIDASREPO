/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL MONTHLY BROKERAGE REP & FILE MAINT.')        */
/********************************************************************/
/*                                                                  */
/*        Midas - Dealing Module                            */
/*                                                                  */
/*       DLC1301 - MONTHLY BROKERAGE REPORT & FILE MAINTENANCE      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. CDL008             Date 02May00             */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             DATE 20MAY96             */
/*                      S01408             DATE 11MAY95             */
/*                      E27942             DATE 03SEP91             */
/*                      LN1258             DATE  2MAY91             */
/*                      S01337             DATE 16APR91             */
/*                      BHF982             DATE 18FEB91             */
/*                      S01189             DATE 04JAN90             */
/*                      S01194             DATE 22/09/89            */
/*                      S01117             DATE 22/09/89            */
/*                      S01179             DATE 14/09/88            */
/*                      S01147             DATE 03/12/87            */
/*                      S01119             DATE 17/06/87            */
/*                      E81165             DATE 28/05/87            */
/*                      S01098             DATE 22/09/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       CDL008 - Continuous Linked Settlement (Recompiled CUSDE/   */
/*                CUSDL/DEALS/DEALSDB)                              */
/*       S01408  -  Core hook DLC1301001 added.                     */
/*                  Core hook DLC1301002 added.                     */
/*       S01408  -  Addition Of Core Hook DLC1301MP1                */
/*       E27942 - FOR NONMULTIBRANCHING SYSTEM SHOULD EXPECT A      */
/*                LEVEL OF BLANKS                                   */
/*       LN1258  -  THE FOLLOWING FILES ARE NOW REDUNDANT           */
/*                  EMDFX,EMDLS,EMDMM,EMFXDL,EMLSDL,EMMMDL          */
/*       S01337  -  SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES  */
/*       BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                    */
/*       S01189  -  COB recovery processing.                        */
/*       S01194  -  NEW STANDING DATA (REMOVAL OF TABLE FILES)      */
/*       S01117  -  MULTIBRANCHING/RELEASE 10 CHANGES               */
/*       S01179  -  AS400 CONVERSION                                */
/*       S01147  -  RELEASE 22                                      */
/*       S01119  -  ADDITION OF FRA/IRS FILE                           *S01119*/
/*       E81165  -  AMENDED TO ASSUME DEFAULT 'N' IN POS 22         */
/*                  OF GLSTAT IF EQUAL BLANK                        */
/*       S01098  -  AMENDMENT REPLACES DATA IN COPIED FILES,        */
/*                  INSTEAD OF CLEARING AND ADDING.                 */
/*                  FROM AND TO FILES ARE NOW 'BLOCKED'             */
/*                                                                  */
/********************************************************************/
/************PGM                                                      /*S01117*/
 
/************PGM PARM(&RSEQ &RLEV &RENT)                   /*S01117*/ /*S01189*/
             PGM PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)                  /*S01189*/
 
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */        /*S01117*/
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)        /*S01117*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)/*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*S01147*/
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)               /*S01147*/
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) +
                        VALUE('Job terminated - database in error')
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(75) +
                        VALUE('File controls out of balance')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*S01189*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*S01189*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*S01189*/
/************DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256) /*S01179*/  /*S01189*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
/*******     DCLDTAARA  DTAARA(DLSTAT)                                  S01179*/
/*******     DCLDTAARA  DTAARA(SDSTAT)                           S01147 S01179*/
/**/                                                                  /*S01147*/
             SNDMSG     MSG('Monthly brokerage report and update') +
                        TOMSGQ(MRUNQ)
             CHGJOB     SWS(1XXXXX00)
/**/
/*******     RCVDTAARA  DLSTAT                                          S01179*/
/*******     RCVDTAARA  SDSTAT                                   S01147 S01179*/
/************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)  /*S01179*/    /*S01189*/
             CHGVAR     VAR(&STAT) VALUE(' ')                         /*S01189*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*S01189*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*S01179*/
/**/                                                                  /*S01147*/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*S01147*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DLIB')    *S01147 S01337*/
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,DLC1301MP1                                          */
                                                                      /*S01408*/
/**/                                                                  /*S01098*/
             OVRDBF     FILE(DEALSDB) SEQONLY(*YES 100)               /*S01098*/
             OVRDBF     FILE(DEALSDC) SEQONLY(*YES 100)               /*S01098*/
             OVRDBF     FILE(DEALSDD) SEQONLY(*YES 100)               /*S01098*/
             OVRDBF     FILE(DEALSDE) SEQONLY(*YES 100)               /*S01098*/
             OVRDBF     FILE(DEALSDG) SEQONLY(*YES 100)               /*S01119*/
             OVRDBF     FILE(NEWDLDB) SEQONLY(*YES 100)               /*S01098*/
             OVRDBF     FILE(NEWDLDC) SEQONLY(*YES 100)               /*S01098*/
             OVRDBF     FILE(NEWDLDD) SEQONLY(*YES 100)               /*S01098*/
             OVRDBF     FILE(NEWDLDE) SEQONLY(*YES 100)               /*S01098*/
             OVRDBF     FILE(NEWDLDG) SEQONLY(*YES 100)               /*S01119*/
/**/                                                                  /*S01098*/
/**/                                                                  /*E81165*/
/************IF         COND(%SUBSTRING(&DLSTAT 22 1) *EQ 'N') +****   *E81165*/
/************THEN(DO)                                          ******  *E81165*/
/***************SNDMSG     MSG('Brokerage extract') TOMSGQ(MRUNQ)****  *E81165*/
/**/                                                                  /*E81165*/
/************IF         COND(%SUBSTRING(&DLSTAT 22 1) *NE 'Y') +
 ************THEN(DO)                                                 /*S01189*/
             IF         COND(&STAT *NE 'Y') THEN(DO)                  /*S01189*/
                SNDMSG     MSG('Brokerage extract') TOMSGQ(MRUNQ)     /*E81165*/
/**/                                                                  /*E81165*/
                DLTF       FILE(NEWDLDA)                              /*S01147*/
                MONMSG     MSGID(CPF0000)                             /*S01147*/
                DLTF       FILE(NEWDLDB)                              /*S01147*/
                MONMSG     MSGID(CPF0000)                             /*S01147*/
                DLTF       FILE(NEWDLDC)                              /*S01147*/
                MONMSG     MSGID(CPF0000)                             /*S01147*/
                DLTF       FILE(NEWDLDD)                              /*S01147*/
                MONMSG     MSGID(CPF0000)                             /*S01147*/
                DLTF       FILE(NEWDLDE)                              /*S01147*/
                MONMSG     MSGID(CPF0000)                             /*S01147*/
                DLTF       FILE(NEWDLDF)                              /*S01147*/
                MONMSG     MSGID(CPF0000)                             /*S01147*/
                DLTF       FILE(NEWDLDG)                              /*S01147*/
                MONMSG     MSGID(CPF0000)                             /*S01147*/
/************** CLRPFM *** FILE(NEWDLDA) ******************/          /*S01098*/
/************** CLRPFM *** FILE(NEWDLDB) ******************/          /*S01098*/
/************** CLRPFM *** FILE(NEWDLDC) ******************/          /*S01098*/
/************** CLRPFM *** FILE(NEWDLDD) ******************/          /*S01098*/
/************** CLRPFM *** FILE(NEWDLDE) ******************/          /*S01098*/
/************** CLRPFM *** FILE(NEWDLDF) ******************/          /*S01098*/
/**/
/**/
/***************CPYF*******FROMFILE(DEALSDA) TOFILE(NEWDLDA)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(DEALSDA) TOFILE(NEWDLDA) +  *****  *S01147*/
/*****                      MBROPT(*REPLACE) FMTOPT(*NONE)      *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM NEWDLDA)                 *****  *S01147*/
/**/                                                                  /*S01147*/
/**********     CPYF    FROMFILE(DEALSDA) TOFILE(NEWDLDA.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  S01147*S01179*/
                CPYF    FROMFILE(DEALSDA) TOFILE(&TOLIB/NEWDLDA) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01179*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/                                                                  /*S01147*/
/***************CPYF*******FROMFILE(DEALSDB) TOFILE(NEWDLDB)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/***************MONMSG*****MSGID(CPF2817)********************/        /*S01098*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(DEALSDB) TOFILE(NEWDLDB) +  *****  *S01147*/
/*****                      MBROPT(*REPLACE) FMTOPT(*NONE)      *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM NEWDLDB)                 ****   *S01147*/
/**/                                                                  /*S01147*/
/**********     CPYF    FROMFILE(DEALSDB) TOFILE(NEWDLDB.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  S01147*S01179*/
                CPYF    FROMFILE(DEALSDB) TOFILE(&TOLIB/NEWDLDB) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01179*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/                                                                  /*S01147*/
/***************CPYF*******FROMFILE(DEALSDC) TOFILE(NEWDLDC)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/***************MONMSG*****MSGID(CPF2817)********************/        /*S01098*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(DEALSDC) TOFILE(NEWDLDC) +  *****  *S01147*/
/*****                      MBROPT(*REPLACE) FMTOPT(*NONE)      *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM NEWDLDC)                 *****  *S01147*/
/**/                                                                  /*S01147*/
/*********      CPYF    FROMFILE(DEALSDC) TOFILE(NEWDLDC.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  S01147*S01179*/
                CPYF    FROMFILE(DEALSDC) TOFILE(&TOLIB/NEWDLDC) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01179*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/                                                                  /*S01147*/
/***************CPYF*******FROMFILE(DEALSDD) TOFILE(NEWDLDD)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/***************MONMSG*****MSGID(CPF2817)********************/        /*S01098*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(DEALSDD) TOFILE(NEWDLDD) +  *****  *S01147*/
/*****                      MBROPT(*REPLACE) FMTOPT(*NONE)      *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM NEWDLDD)                 *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF    FROMFILE(DEALSDD) TOFILE(NEWDLDD.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  S01147*S01179*/
                CPYF    FROMFILE(DEALSDD) TOFILE(&TOLIB/NEWDLDD) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01179*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/                                                                  /*S01147*/
/***************CPYF*******FROMFILE(DEALSDE) TOFILE(NEWDLDE)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/***************MONMSG*****MSGID(CPF2817)********************/        /*S01098*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(DEALSDE) TOFILE(NEWDLDE) +  *****  *S01147*/
/*****                      MBROPT(*REPLACE) FMTOPT(*NONE)      *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM NEWDLDE)                 *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF    FROMFILE(DEALSDE) TOFILE(NEWDLDE.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  S01147*S01179*/
                CPYF    FROMFILE(DEALSDE) TOFILE(&TOLIB/NEWDLDE) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01179*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/                                                                  /*S01147*/
/***************CPYF*******FROMFILE(DEALSDF) TOFILE(NEWDLDF)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(DEALSDF) TOFILE(NEWDLDF) +  *****  *S01147*/
/*****                      MBROPT(*REPLACE) FMTOPT(*NONE)      *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM NEWDLDF)                 *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF    FROMFILE(DEALSDF) TOFILE(NEWDLDF.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  S01147*S01179*/
                CPYF    FROMFILE(DEALSDF) TOFILE(&TOLIB/NEWDLDF) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01179*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/                                                                  /*S01147*/
/*****          CPYF       FROMFILE(DEALSDG) TOFILE(NEWDLDG) +  *****  *S01147*/
/*****                      MBROPT(*REPLACE) FMTOPT(*NONE)      *****  *S01147*/
/*****          MONMSG     (CPF2817) CMPDTA(CPF2869) +          *****  *S01147*/
/*****                     EXEC(CLRPFM NEWDLDG)                 *****  *S01147*/
/**/                                                                  /*S01147*/
/*              CPYF    FROMFILE(DEALSDG) TOFILE(NEWDLDG.&TOLIB) +
                   MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  S01147*S01179*/
                CPYF    FROMFILE(DEALSDG) TOFILE(&TOLIB/NEWDLDG) +
                        MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)  /*S01179*/
                MONMSG     (CPF2817) CMPDTA(CPF2869)                  /*S01147*/
/**/
/***************ALCOBJ    OBJ((DLSTAT *DTAARA *EXCLRD))               /*S01189*/
/*              RCVDTAARA DLSTAT                                        S01179*/
/***************RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT) /*S01179*/  /*S01189*/
/***************CHGVAR VAR(%SUBSTRING(&DLSTAT 22 1)) VALUE('Y')       /*S01189*/
/*              SNDDTAARA DLSTAT                                        S01179*/
/***************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)  /*S01179*/  /*S01189*/
/***************DLCOBJ    OBJ((DLSTAT *DTAARA *EXCLRD))               /*S01189*/
                CHGVAR     VAR(&STAT) VALUE('Y')                      /*S01189*/
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        /*S01189*/
          ENDDO
/**/
          ELSE       CMD(DO)
/**/
/***************CLRPFM*****FILE(DEALSDA)*********************/        /*S01098*/
/***************CLRPFM*****FILE(DEALSDB)*********************/        /*S01098*/
/***************CLRPFM*****FILE(DEALSDC)*********************/        /*S01098*/
/***************CLRPFM*****FILE(DEALSDD)*********************/        /*S01098*/
/***************CLRPFM*****FILE(DEALSDE)*********************/        /*S01098*/
/***************CLRPFM*****FILE(DEALSDF)*********************/        /*S01098*/
/**/
/*   REMOVE LOGICAL FILES OVER PHYSICALS BEFORE COPYING     */        /*S01098*/
/*                  AND REPLACE AFTER                       */        /*S01098*/
/**/                                                                  /*S01098*/
                RMVM       FILE(CUSDE) MBR(CUSDE)                     /*S01098*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
                RMVM       FILE(CUSDL) MBR(CUSDL)                     /*S01098*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
                RMVM       FILE(DEALS) MBR(DEALS)                     /*S01098*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/***********    RMVM       FILE(EMDFX) MBR(EMDFX)             *S01098* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/***********    RMVM       FILE(EMDMM) MBR(EMDMM)             *S01098* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/***********    RMVM       FILE(EMDLS) MBR(EMDLS)             *S01098* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/***********    RMVM       FILE(EMFXDL) MBR(EMFXDL)           *S01098* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/***********    RMVM       FILE(EMMMDL) MBR(EMMMDL)           *S01098* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/***********    RMVM       FILE(EMLSDL) MBR(EMLSDL)           *S01098* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/***************CPYF*******FROMFILE(NEWDLDA) TOFILE(DEALSDA)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
                CPYF       FROMFILE(NEWDLDA) TOFILE(DEALSDA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDA)                       /*S01098*/
/***************CPYF*******FROMFILE(NEWDLDB) TOFILE(DEALSDB)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/***************MONMSG*****MSGID(CPF2817)********************/        /*S01098*/
                CPYF       FROMFILE(NEWDLDB) TOFILE(DEALSDB) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDB)                       /*S01098*/
/***************CPYF*******FROMFILE(NEWDLDC) TOFILE(DEALSDC)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/***************MONMSG*****MSGID(CPF2817)********************/        /*S01098*/
                CPYF       FROMFILE(NEWDLDC) TOFILE(DEALSDC) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDC)                       /*S01098*/
/***************CPYF*******FROMFILE(NEWDLDD) TOFILE(DEALSDD)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/***************MONMSG*****MSGID(CPF2817)********************/        /*S01098*/
                CPYF       FROMFILE(NEWDLDD) TOFILE(DEALSDD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDD)                       /*S01098*/
/***************CPYF*******FROMFILE(NEWDLDE) TOFILE(DEALSDE)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
/***************MONMSG*****MSGID(CPF2817)********************/        /*S01098*/
                CPYF       FROMFILE(NEWDLDE) TOFILE(DEALSDE) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDE)                       /*S01098*/
/***************CPYF*******FROMFILE(NEWDLDF) TOFILE(DEALSDF)*/        /*S01098*/
/***************************MBROPT(*ADD) FMTOPT(*NOCHK)******/        /*S01098*/
                CPYF       FROMFILE(NEWDLDF) TOFILE(DEALSDF) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01098*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDF)                       /*S01098*/
                CPYF       FROMFILE(NEWDLDG) TOFILE(DEALSDG) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)            /*S01119*/
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                           EXEC(CLRPFM DEALSDG)                       /*S01119*/
/**/                                                                  /*S01098*/
/*              ADDLFM     FILE(CUSDE) MBR(CUSDE) */       /*S01098*/ /*BHF982*/
                ADDLFM     FILE(CUSDE) MBR(CUSDE) SHARE(*YES)         /*BHF982*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/*              ADDLFM     FILE(CUSDL) MBR(CUSDL) */       /*S01098*/ /*BHF982*/
                ADDLFM     FILE(CUSDL) MBR(CUSDL) SHARE(*YES)         /*BHF982*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/*              ADDLFM     FILE(DEALS) MBR(DEALS) */       /*S01098*/ /*BHF982*/
                ADDLFM     FILE(DEALS) MBR(DEALS) SHARE(*YES)         /*BHF982*/
                MONMSG     MSGID(CPF0000)                             /*S01098*/
/*              ADDLFM     FILE(EMDFX) MBR(EMDFX) */       /*S01098*/ /*BHF982*/
/***********    ADDLFM     FILE(EMDFX) MBR(EMDFX) SHARE(*YES) *BHF982* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/*              ADDLFM     FILE(EMDMM) MBR(EMDMM) */       /*S01098*/ /*BHF982*/
/***********    ADDLFM     FILE(EMDMM) MBR(EMDMM) SHARE(*YES) *BHF982* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/*              ADDLFM     FILE(EMDLS) MBR(EMDLS) */       /*S01098*/ /*BHF982*/
/***********    ADDLFM     FILE(EMDLS) MBR(EMDLS) SHARE(*YES) *BHF982* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/*              ADDLFM     FILE(EMFXDL) MBR(EMFXDL) */     /*S01098*/ /*BHF982*/
/***********    ADDLFM    FILE(EMFXDL) MBR(EMFXDL) SHARE(*YES)*BHF982* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/*              ADDLFM     FILE(EMMMDL) MBR(EMMMDL) */     /*S01098*/ /*BHF982*/
/***********    ADDLFM    FILE(EMMMDL) MBR(EMMMDL) SHARE(*YES)*BHF982* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/*              ADDLFM     FILE(EMLSDL) MBR(EMLSDL) */     /*S01098*/ /*BHF982*/
/***********    ADDLFM    FILE(EMLSDL) MBR(EMLSDL) SHARE(*YES)*BHF982* *LN1258*/
/***********    MONMSG     MSGID(CPF0000)                     *S01098* *LN1258*/
/**/                                                                  /*S01098*/
             ENDDO
 /**/
             DLTOVR     FILE(DEALSDB)
             DLTOVR     FILE(DEALSDC)
             DLTOVR     FILE(DEALSDD)
             DLTOVR     FILE(DEALSDE)
             DLTOVR     FILE(DEALSDG)                                 /*S01119*/
             DLTOVR     FILE(NEWDLDB)
             DLTOVR     FILE(NEWDLDC)
             DLTOVR     FILE(NEWDLDD)
             DLTOVR     FILE(NEWDLDE)
             DLTOVR     FILE(NEWDLDG)                                 /*S01119*/
/**/                                                                  /*S01098*/
                CLRPFM     FILE(BROKXHH)
                CLRPFM     FILE(BROKXBD)
                CLRPFM     FILE(BROKXTT)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC1301001                                           /*S01408*/
/*                                                                    /*S01408*/
/***********    OVRDBF     FILE(TABLE) TOFILE(TABDLEI)                /*S01194*/
/***********    OVRDBF     FILE(TABLED) TOFILE(TABDLEE)               /*S01194*/
                OVRDBF     FILE(DEALRD) TOFILE(DEALS) SHARE(*NO)
                CALL       PGM(DL1200)
/**/
             RTVJOBA    SWS(&SWS)
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '00') THEN(DO)
/**/
         /**/
                SNDMSG     MSG('Brokerage report') TOMSGQ(MRUNQ)
                CHGVAR     VAR(&SWS) VALUE('X0000000')
                CHGJOB     SWS(&SWS)
                                                                      /*S01117*/
/* MUST COPE WITH NON MULTIBRANCHED SYSTEM WHEN LEVEL SENT AS 'S' */  /*S01117*/
/************IF         COND(&RLEV *EQ 'S') THEN(CHGVAR VAR(&RENT) +
/************             VALUE('ALL'))                       *S01117* *E27942*/
             IF         COND(&RLEV *EQ 'S' *OR &RLEV *EQ ' ') +
                          THEN(CHGVAR VAR(&RENT) VALUE('ALL'))        /*E27942*/
                                                                      /*S01117*/
/*************  OVRDBF     FILE(TABLE) TOFILE(TABDLEE)                /*S01194*/
/*************  OVRDBF     FILE(TABD) TOFILE(TABDLEI)                 /*S01194*/
/*************  CALL       PGM(DL1220)                                /*S01117*/
                CALL       PGM(DL1220) PARM(&RSEQ &RENT)              /*S01117*/
                RTVJOBA    SWS(&SWS)
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/******************ALCOBJ    OBJ((DLSTAT *DTAARA *EXCLRD))            /*S01189*/
/*********         RCVDTAARA DLSTAT                                     S01179*/
/******************RTVDTAARA DTAARA(DLSTAT) RTNVAR(&DLSTAT)/*S01179*/ /*S01189*/
/******************CHGVAR VAR(%SUBSTRING(&DLSTAT 22 1)) VALUE('N')    /*S01189*/
/***********       SNDDTAARA DLSTAT                            S01179*/
/******************CHGDTAARA  DTAARA(DLSTAT) VALUE(&DLSTAT)/*S01179*/ /*S01189*/
/******************DLCOBJ    OBJ((DLSTAT *DTAARA *EXCLRD))            /*S01189*/
                   CHGVAR     VAR(&STAT) VALUE('N')                   /*S01189*/
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)     /*S01189*/
/**/
/*****             CLRPFM     FILE(NEWDLDA)                     *****  *S01147*/
/*****             CLRPFM     FILE(NEWDLDB)                     *****  *S01147*/
/*****             CLRPFM     FILE(NEWDLDC)                     *****  *S01147*/
/*****             CLRPFM     FILE(NEWDLDD)                     *****  *S01147*/
/*****             CLRPFM     FILE(NEWDLDE)                     *****  *S01147*/
/*****             CLRPFM     FILE(NEWDLDF)                     *****  *S01147*/
/*****             CLRPFM     FILE(NEWDLDG)                     *****  *S01147*/
                   DLTF       FILE(NEWDLDA)                           /*S01147*/
                   MONMSG     MSGID(CPF0000)                          /*S01147*/
                   DLTF       FILE(NEWDLDB)                           /*S01147*/
                   MONMSG     MSGID(CPF0000)                          /*S01147*/
                   DLTF       FILE(NEWDLDC)                           /*S01147*/
                   MONMSG     MSGID(CPF0000)                          /*S01147*/
                   DLTF       FILE(NEWDLDD)                           /*S01147*/
                   MONMSG     MSGID(CPF0000)                          /*S01147*/
                   DLTF       FILE(NEWDLDE)                           /*S01147*/
                   MONMSG     MSGID(CPF0000)                          /*S01147*/
                   DLTF       FILE(NEWDLDF)                           /*S01147*/
                   MONMSG     MSGID(CPF0000)                          /*S01147*/
                   DLTF       FILE(NEWDLDG)                           /*S01147*/
                   MONMSG     MSGID(CPF0000)                          /*S01147*/
/**/
                ENDDO
/**/
             ENDDO
/**/
             IF         COND(%SUBSTRING(&SWS 7 1) *EQ '1') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))
/**/
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '01') +
                          THEN(SNDMSG MSG(&MSG2) TOMSGQ(MOPERQ))
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,DLC1301002                                           /*S01408*/
/*                                                                    /*S01408*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
