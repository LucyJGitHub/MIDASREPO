/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MS Incoming messages reference generator')      */
/*********************************************************************/
/*                                                                   */
/*     Midas - SWIFT DIRECT LINK                                     */
/*                                                                   */
/*     MSC1240 - INCOMING MESSAGES REFERENCE GENERATION              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*        Last Amend No. CPK009            Date 09Aug99              */
/*        Prev Amend No  S01310            DATE 06DEC90              */
/*                       S01259            DATE 20AUG90              */
/*                       S01179            DATE 12/09/88             */
/*                       E12907            DATE 14/04/88             */
/*                       S05452            DATE 20/08/87             */
/*                       E11391            DATE 31/07/87             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*     CPK009 - Packaging for DBA3 release. STRCMTCTL values set     */
/*              to CMTSCOPE(*JOB).                                   */
/*     S01310 - SWIFT RATIONALISATION                                */
/*     S01259 - If SWIFT II on call MS5030 else call MS1240          */
/*     S01179  -  CHANGE RCVDTAARA TO RTVDTAARA FOR AS400            */
/*     E12907 - PROGRAM CALL RCC0250 EVEN WHEN THE CLIENT DOES       */
/*              NOT HAVE THE MODULE INSTALLED                        */
/*     S05452 - INCLUSION OF AUTO RECONCILIATIONS                    */
/*     E11391 - BEGIN COMMITMENT CONTROL ADDED. ALSO, POSITION 57    */
/*              OF DATA AREA MSSTAT SET TO 'N' ON SUCCESSFUL         */
/*              COMPLETION OF JOB.                                   */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
/* Declare Message Detail Field.                                    */
/*                                                                  */
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
/*           DCL        VAR(&QAPARM) TYPE(*CHAR) LEN(1)               /*S01259*/
/************DCL********VAR(&SWII) TYPE(*CHAR) LEN(1)           /*S01259S01310*/
/**/                                                                  /*E12907*/
/*           DCLDTAARA  DTAARA(MMOD)                      *  *E12907*  *S01179*/
             DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*E12907*/
/*                                                                   */
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                  *  *E11391*/
/* Create Local Data Area in QTEMP for Submitted Job.               *  *E11391*/
/*                                                                  *  *E11391*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('AS400 Equivalent of System/34 Local +
                          Data Area') /*E11391*/
/*                                                                  *  *E11391*/
/*     SET OFF EXTERNAL SWITCHES                                     */
/*                                                                   */
             CHGJOB     SWS(00000000)
/*                                                                  *  *E11391*/
/* Begin Commitment Control.                                        *  *E11391*/
/*                                                                  *  *E11391*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))     /*E11391 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
/*                                                                   */
/*     Call Incoming messages reference generation program           */
/*                                                                   */
/************RTVDTAARA  DTAARA(MMOD (95 1)) RTNVAR(&SWII)       /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*on*call*MS5030                                  /*S01259S01310*/
/************IF*COND(&SWII**EQ 'Y') THEN(DO)                    /*S01259S01310*/
             CALL PGM(MS5030)                                         /*S01259*/
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)           /*S01259*/
             ROLLBACK                                                 /*S01259*/
             GOTO ABNOR                                               /*S01259*/
             ENDDO                                                    /*S01259*/
/************ENDDO*********                                     /*S01259S01310*/
/**************************                                     /*S01259S01310*/
/***If*SWIFT*II*off*call*MS1240                                 /*S01259S01310*/
/************IF*COND(&SWII**NE 'Y') THEN(DO)                    /*S01259S01310*/
/******************CALL****   PGM(MS1240)                             /*S01310*/
/******************MONMSG**   MSGID(CPF0000 RPG0000 MCH0000) +        /*S01310*/
/**********************EXEC(DO)                                       /*S01310*/
/*************************ROLLBACK                                    /*S01310*/
/*************************GOTO ABNOR                                  /*S01310*/
/**********************ENDDO                                          /*S01310*/
/************ENDDO*********                                     /*S01259S01310*/
/*                                                                   */
/*     Database error processing. Send message to MOPERQ & MRUNQ     */
/*                                                                   */
             IF COND(%SWITCH(XXXXXX11)) +
                THEN(DO)
                   ROLLBACK
                   RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOPGMQ(*EXT)
                   GOTO       ENDPGM                                  /*E11391*/
                ENDDO
                                                                      /*S05452*/
/*  Reformat MT950 messages for Auto Reconciliation                 *  *S05452*/
                                                                      /*S05452*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
             IF         COND(%SST(&MMOD 22 1) *EQ 'Y') THEN(DO)       /*E12907*/
             CALL RCC0250                                             /*S05452*/
             ENDDO                                                    /*E12907*/
                                                                      /*S05452*/
/*                                                                  *  *E11391*/
/* Set Data Area MSSTAT position 57 to 'N' on successful completion *  *E11391*/
/*                                                                  *  *E11391*/
             CHGDTAARA  DTAARA(MSSTAT (57 1)) VALUE('N')              /*E11391*/
/*                                                                   */
             GOTO ENDPGM
/*                                                                   */
 ABNOR:      SNDPGMMSG  MSG('Incoming Messages Reference Generation   +
     ENDED ABNORMALLY')   TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDPGM:     ENDPGM
