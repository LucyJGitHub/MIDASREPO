/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM NEXT DAY SET-UP')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Exposure Management Module                      */
/*                                                                   */
/*       EMC09 - NEXT DAY SET-UP (UPDATE EMCEX WITH RETAIL EXP/OSB)  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 066988             DATE 23JUN94              */
/*       PREV AMEND NO. E23410             DATE 19/09/90             */
/*                      S01194             DATE 13DEC89              */
/*                      S00014             DATE 22/04/87             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       066988 - Switch off U1 + U2 after call to EM0700R.          */
/*       E23410 - PROGRAM CHECKS FOR MODULES RT AND RE.              */
/*                AMEND TO CHECK FOR RE AND IA.                      */
/*       S01194 - STANDING DATA CHANGES                              */
/*       S00014 - UPDATE EMCEXX1 WITH JOURNAL RECEIVER NAME          */
/*                AND SEQUENCE NUMBER.                               */
/*       E80969 - NO SOURCE CHANGE HERE BUT PROGRAM RECOMPILED       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44) */              /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(10)                  /*S00014*/
             DCL        VAR(&RCV) TYPE(*CHAR) LEN(10)                 /*S00014*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/**/
             CHGJOB SWS(00000000)
/**/
             OVRDBF     FILE(TABLE) TOFILE(TABEM)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
/**** CHECK MODULE INDICATORS ****/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         ((%SST(&MMOD 4 1)) *EQ 'Y') +
                        CHGJOB SWS(X1XXXXXX)
/*                                                             E23410*/
/************IF*********((%SST(&MMOD 3 1)) *EQ 'Y') +*****************/
/***********************CHGJOB SWS(1XXXXXXX)**************************/
             IF         ((%SST(&MMOD 23 1)) *EQ 'Y') +
                        CHGJOB SWS(1XXXXXXX)
/*                                                             E23410*/
             ELSE IF    ((%SST(&MMOD 16 1)) *EQ 'Y') +
                        CHGJOB SWS(1XXXXXXX)
/**/
             RTVJRNE JRN(ICJRN) FROMENT(*LAST) TOENT(*LAST) +
                     SEARCH(*DESCEND) RTNSEQNBR(&SEQ) RTNRCV(&RCV)    /*S00014*/
/****        CALL EM0700R                                           *  *S00014*/
             CALL       PGM(EM0700R) PARM(&SEQ &RCV)                  /*S00014*/
/**/
             DLTOVR     FILE(TABLE)
             CHGJOB SWS(00XXXXXX)                                    /*066988*/
/**/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                        */
/**/
    DBERROR:
              IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
/*             CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44)) */           /*S01194*/
                  CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))           /*S01194*/
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
              ENDDO
/**/
/* FOR FILE CONTROLS OUT OF BALANCE                                  */
/**/
   FCERROR:
              IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
                  SNDPGMMSG MSGID(MEM0002) MSGF(MIDAS)  +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
              ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
           ENDPGM
