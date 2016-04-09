/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Input Cycle Revaluation')                    */
/*******************************************************************/
/*                                                                 */
/*   Midas  -  Futures and Options Module                  */
/*                                                                 */
/*   FFC0221  -  INPUT CYCLE REVALUATION                           */
/*                                                                 */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                 */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Last Amend No. CPK009             Date 09Aug99                */
/*   Prev Amend No. S01408             DATE 10JAN96                */
/*                  088717             DATE 12JUN95                */
/*                  E44667             DATE 18SEP92                */
/*                  E44681 (FUJI-FF0005)   DATE 17SEP92            */
/*                  E23409             DATE 31AUG90                */
/*                  S01117             DATE 19APR90                */
/*                  E19862             DATE 02APR90                */
/*                  S01240             DATE 07/03/89               */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*   CPK009 - Packaging for DBA3 release. STRCMTCTL values set     */
/*            to CMTSCOPE(*JOB).                                   */
/*   S01408 - Addition of core hook - FFC0221001                   */
/*   088717 - ALLOCATION PROBLEM DURING EOC ON SAME MARKET         */
/*   E44667 - Amend the program to cater for multi-language        */
/*            processing.                                          */
/*                                                                 */
/*   E44681      - A parameter missmatch occurs when the position  */
/*                 revaluation program FFC0221 is submitted to     */
/*                 batch for an OTC position.                      */
/*                                                                 */
/*   E23409 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF RETAIL  */
/*            II OR INTEREST ON ACCOUNTS INSTALLED - SETON U2 IF RE*/
/*            OR IA = 'Y'.   NOTE - RETAIL I NOT SUPPORTED ON ABS. */
/*   S01117 - MULTIBRANCHING                                       */
/*   E19862 - Parm MARKT was different length to that used by      */
/*            calling program.                                     */
/*   S01240 - ADDITION OF REAL-TIME STATEMENTS                     */
/*                                                                 */
/*******************************************************************/
/*                                                                   */
             PGM        PARM(&MARKT)
/**/
/*  DECLARE VARIABLES                                               */
/**/
/*********** DCL        VAR(&DBERR)  TYPE(*CHAR)  LEN(44)          */ /*S01117*/
             DCL        VAR(&DBERR)  TYPE(*CHAR)  LEN(50)             /*S01117*/
/* MARKT need not be 3 long as OTC's are passed as '  '   */          /*E19862*/
/************DCL        VAR(&MARKT)   TYPE(*CHAR)  LEN(3) */          /*E19862*/
/************DCL        VAR(&MARKT)   TYPE(*CHAR)  LEN(2)  /*E19862*/ /*E44681*/
             DCL        VAR(&MARKT)   TYPE(*CHAR)  LEN(3)             /*E44681*/
             DCL        VAR(&RERUN)   TYPE(*CHAR)  LEN(3)
             DCL        VAR(&FFSTAT)   TYPE(*CHAR)  LEN(256)
             DCL        VAR(&MMOD)     TYPE(*CHAR)  LEN(256)
/**/                                                                  /*E44667*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*E44667*/
             DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(10)               /*E44667*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*E44667*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*E44667*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*E44667*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*E44667*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*E44667*/
/**/                                                                  /*E44667*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**********STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*LIBL/MNTYF (*FILE))       /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(*LIBL/MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                             /*CPK009*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             IF         COND(&MARKT *NE 'OTC') THEN(DO)              /*088717*/
                 ALCOBJ     OBJ((&MARKT *DTAARA *SHRRD))             /*088717*/
             ENDDO                                                   /*088717*/
/**/
/*   CREATE LOCAL DATA AREA                                         */
/**/
CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) AUT(*EXCLUDE) +
             TEXT('Midas SD Local Data Area')                     /*S01117*/
/*********** TEXT('MIDAS/38 SD Local Data Area')                   */ /*S01117*/
             MONMSG     MSGID(CPF0000) /* Monitor here to prevent +
                          error during re-routing of job */
/**/                                                                  /*E44667*/
/*  MULTIPLE LANGUAGE SUPPORT -                  */                   /*E44667*/
/*  SET OP OVERRIDES FOR MESSAGE FILES           */                   /*E44667*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*E44667*/
                                                                      /*E44667*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*E44667*/
                CHGVAR     VAR(&MULT) VALUE('GB')                     /*E44667*/
             ENDDO                                                    /*E44667*/
                                                                      /*E44667*/
/*  BUILD MULTIPLE LANGUAGE SUPPORT OBJECT NAMES  */                  /*E44667*/
             CHGVAR     VAR(&MIDAS) VALUE(&MULT *CAT 'MIDAS')         /*E44667*/
                                                                      /*E44667*/
/*  APPLY MULTIPLE LANGUAGE SUPPORT OVERRIDES  */                     /*E44667*/
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDAS)                    /*E44667*/
                                                                      /*E44667*/
             RTVDTAARA  DTAARA(FFSTAT *ALL) RTNVAR(&FFSTAT)
             IF  COND((%SST(&FFSTAT 3 1) *NE ' ') *AND +
                      (%SST(&FFSTAT 4 3) *NE '   ')) THEN(DO)
             IF  COND((%SST(&FFSTAT 4 3) *NE &MARKT)) THEN(DO)
             SNDPGMMSG  MSG('I/C REVALUATION FOR MARKET' *BCAT  +
                        &MARKT *BCAT 'NOT PROCESSED.') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&RERUN) VALUE(%SST(&FFSTAT 4 3))
             SNDPGMMSG  MSG('PREVIOUS REVALUATION FOR MARKET' *BCAT +
                        &RERUN *BCAT 'FAILED AND IS BEING RERUN.') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSG('I/C REVALUATION FOR MARKET' *BCAT +
                        &MARKT *BCAT 'MUST BE RESUBMITTED.') +
                         TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
             CHGVAR     VAR(&MARKT) VALUE(%SST(&FFSTAT 4 3))
             ENDDO
             ELSE       CMD(DO)
             CHGDTAARA  DTAARA(FFSTAT (3 1)) VALUE('1')
             CHGDTAARA  DTAARA(FFSTAT (4 3)) VALUE(&MARKT)
             ENDDO
/**/
/*  IF FFSTAT IS BLANK BETWEEN POSITIONS 3 & 6 (INCLUSIVE) THEN     */
/*  SET UP FFSTAT WITH MARKET THAT IS TO BE RUN                     */
/**/
             RTVDTAARA  DTAARA(FFSTAT *ALL) RTNVAR(&FFSTAT)
/**/
             OVRDBF     FILE(WUNRLC)   MBR(&MARKT)
             OVRDBF     FILE(WUNRLK)   MBR(&MARKT)
/**/
             IF  COND((%SST(&FFSTAT 3 1) *EQ '1')) THEN(DO)
             CLRPFM     FILE(WUNRLCD)   MBR(&MARKT)
             CLRPFM     FILE(WUNRLKD)   MBR(&MARKT)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,FFC0221001                                          */
/**/                                                                  /*S01408*/
             OVRDBF     FILE(PRICS)   MBR(&MARKT)
             OVRDBF     FILE(TRANS6)   MBR(&MARKT)
             CALL       PGM(FF0200)
/**/
/*  IF A DATABASE ERROR HAS OCCURRED FINISH PROCESSING              */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
             CHGDTAARA  DTAARA(FFSTAT (3 1)) VALUE('2')
             ENDDO
/**/
             RTVDTAARA  DTAARA(FFSTAT *ALL) RTNVAR(&FFSTAT)
/**/
             IF  COND((%SST(&FFSTAT 3 1) *EQ '2')) THEN(DO)
/**/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*E23409*/
/*     ( SET ON U2 IF PRESENT)                        */           /*E23409*/
/**/                                                               /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*E23409*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*SETON*U2*IF*PRESENT***//************E23409*/
/************RTVDTAARA**DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) +**************E23409*/
/*************************THEN(CHGJOB SWS(X1XXXXXX))*****************E23409*/
/**/
/*   SETON U6 TO SIGNIFY INPUT CYCLE OPERATION        */
/*   FOR STANDARD SUBROUTINE FFSETL IN FF0210         */
/**/
             CHGJOB SWS(XXXXX1XX)
/**/
             OVRDBF     FILE(POSTNC)   MBR(&MARKT)
             OVRDBF     FILE(POSTNK)   MBR(&MARKT)
             OVRDBF     FILE(MEMOSM)   MBR(&MARKT)
             OVRDBF     FILE(PRONOM)   MBR(&MARKT)
                                                                     /*S01240*/
             OVRDBF     FILE(FFACMVD)   MBR(&MARKT)                  /*S01240*/
                                                                     /*S01240*/
             CALL       PGM(FF0210)
/**/
/*  IF A DATABASE ERROR HAS OCCURRED FINISH PROCESSING              */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR2))
/**/
/*  IF NORMAL COMPLETION BLANK OUT DATA AREA POSITIONS              */
/**/
             CHGDTAARA  DTAARA(FFSTAT (3 1)) VALUE(' ')
             CHGDTAARA  DTAARA(FFSTAT (4 3)) VALUE('   ')
             ENDDO
/**/
             GOTO  END
/**/
/*  ERROR PROCESSING IF PROGRAM FAILS                                */
/**/
ABNOR:       SNDPGMMSG  MSG('INPUT CYCLE REVALUATION I FOR MARKET' +
                        *BCAT &MARKT *BCAT 'TERMINATED ABNORMALLY') +
                         TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO MSGEND
ABNOR2:      SNDPGMMSG  MSG('INPUT CYCLE REVALUATIONS II FOR MARKET' +
                        *BCAT &MARKT *BCAT 'TERMINATED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/**/
/*  DATABASE ERRORS, IF U7 + U8 ON                                   */
/*  FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/*  MESSAGE TO MOPERQ AND MRUNQ & WORKSTATION                        */
/**/
MSGEND:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&DBERR)    */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DBERR)       /*S01117*/
/**********      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DBERR) + E44667*/
/**********      TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)                      E44667*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(&MIDAS) MSGDTA(&DBERR) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*E44667*/
                 ENDDO
/**/
END:         DLTOVR     FILE(*ALL)
             ENDCMTCTL
             IF         COND(&MARKT *NE 'OTC') THEN(DO)              /*088717*/
                 DLCOBJ     OBJ((&MARKT *DTAARA *SHRRD))             /*088717*/
             ENDDO                                                   /*088717*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
