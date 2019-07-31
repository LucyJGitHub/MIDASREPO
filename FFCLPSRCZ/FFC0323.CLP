/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF I/c customer trading statements')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0323  -  CUSTOMER TRADING STATEMENTS ( INTERIM )             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*   Last Amend No. MD046248           Date 27Oct17                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       PREV Amend No. 205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      163444             Date 29Sep99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 28Mar95              */
/*                  E27708             DATE 27AUG91                  */
/*                  RT0121             DATE 23MAY91                  */
/*                  FO0073             DATE 15APR91                  */
/*                  FO0066             DATE 09APR91                  */
/*                  FO0046             DATE 02APR91                  */
/*                  S01299             DATE 29AUG90                  */
/*                  S01117             DATE 30MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   205448  - UDC module must be on for Correspondence Manager      */
/*   CCG015  - Correspondence Manager Phase 1                        */
/*   163444  -  Y2K Sort Order and file allocation.                  */
/*   S01522  -  User Defined Correspondence                          */
/*   S01522  -  User Defined Correspondence                          */
/*   E27708  -  Amend list of i/p parms used to match the parameters */
/*              passed by a new RCF calling program.                 */
/*   RT0121  -  Monitor the creation of LDA to trap error            */
/*           -  lda already exists.                                  */
/*   FO0073  -  U7 + U8 SHOULD BE SET ON IN ABNOR PROCESSING, AND    */
/*              DB ERROR MESSAGES SHOULD BE SENT TO MRUNQ + MOPERQ.  */
/*   FO0066  -  SUBMITTED REPORT NEEDS TO CREATE AN LDA              */
/*   FO0046  -  Program FF1270 called by new prompt program FFC0323P */
/*              - change due to R10 RCF processing.                  */
/*              Note - the prompt program flags Cust Trading Stmt    */
/*                     records, instead of passing parameters        */
/*   S01299  -  Allow up to 32 market centres as per original        */
/*              specification.                                       */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01117*/
/*********** PGM        PARM(&RSEQ &RLEV &RENT)                /*S01117*FO0046*/
/*********** PGM        PARM(&RSEQ &RLEV &RENT &PARM)          /*FO0046*E27708*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*E27708*/
/**/
/*  DECLARE VARIABLES                                               */
/**/
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)             /*S01117*/
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)             /*S01117*/
             DCL        &RENT         TYPE(*CHAR)  LEN(3)             /*S01117*/
/*********** DCL        &PARM         TYPE(*CHAR)  LEN(100)    /*FO0046*E27708*/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&COMP_NAME)  TYPE(*CHAR) LEN(10)          /*S01522*/
             DCL        VAR(&COMP_SEQ)   TYPE(*DEC)  LEN(5)           /*S01522*/
             DCL        VAR(&EXTRACT)    TYPE(*CHAR) LEN(10)          /*S01522*/
             DCL        VAR(&MEMBER)     TYPE(*CHAR) LEN(10)          /*S01522*/
             DCL        VAR(&COMMIT_OPT) TYPE(*CHAR) LEN(3)           /*S01522*/
/* */
             DCL        VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)           /*S01522*/
             DCL        VAR(&OPTION)     TYPE(*CHAR) LEN(7)           /*S01522*/
             DCL        VAR(&FMT)        TYPE(*CHAR) LEN(200)         /*S01522*/
             DCL        VAR(&MSG)        TYPE(*CHAR) LEN(50)          /*S01522*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGJOB     SWS(00000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*FO0066*/
             MONMSG     MSGID(CPF1023)                                /*RT0121*/
/**/
             OVRDBF     FILE(TSCCYX) TOFILE(TSCCY) SHARE(*NO)
/**/
/*  PROGRAM FF1270 NOW CALLED BY NEW PROMPT PROGRAM FFC0323P       */ /*FO0046*/
/**/
/***CALL*REPORT*PROMPT*PROGRAM***                                  */ /*FO0046*/
/*********** CALL       PGM(FF1270)                                */ /*S01117*/
/*********** CALL       PGM(FF1270) PARM(&RENT)                    */ /*FO0046*/
/**FOR*DATABASE*ERRORS*RECOVER*DATA*FROM*LOCAL*DATA*AREA,*SEND******/ /*FO0046*/
/**MESSAGE*TO*MOPERQ.***                                           */ /*FO0046*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*FO0046*/
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
/***********     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)  /*S01117*FO0046*/
/*********** SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +  */ /*FO0046*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ)              */ /*FO0046*/
/*********** GOTO       CMDLBL(REL)                                */ /*FO0046*/
/*********** ENDDO                                                 */ /*FO0046*/
/***CMD/1*TAKEN,*U1*WILL*BE*ON*-*NO*REPORT*REQUIRED*****************/ /*FO0046*/
/*********** IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO REL)     */ /*FO0046*/
/**/
/*********** OVRDBF     FILE(POCHG4X) TOFILE(POCHG4) SHARE(*NO)    */ /*S01299*/
/**/
 
 
/** Access PF/SDMMODPD to determine whether UDC module is on            S01522*/
             CHGVAR     VAR(&RTN_CODE) VALUE('       ')               /*S01522*/
             CHGVAR     VAR(&OPTION) VALUE('*FIRST ')                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTN_CODE &OPTION &FMT)    /*S01522*/
 
/** Database error handling                                             S01522*/
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)        /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('Error on access to ICD file +
                          SDMMODPD')                                  /*S01522*/
             GOTO       CMDLBL(ABNOR)                                 /*S01522*/
             ENDDO
 
/*                                                                      S01522*/
/**  If UDC is active, perform extract production                       S01522*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*S01522*/
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
                                                                                          /*CCG015*/
/* UDC EXTRACT                                                        /*S01522*/
             CHGJOB     SWS(10000000)                                 /*S01522*/
             CHGVAR     VAR(&COMP_NAME) VALUE('CGC2270   ')           /*S01522*/
             CHGVAR     VAR(&COMP_SEQ)  VALUE(00001)                  /*S01522*/
             CHGVAR     VAR(&EXTRACT)   VALUE('FF_STMTS  ')           /*S01522*/
             CHGVAR     VAR(&MEMBER)    VALUE('          ')           /*S01522*/
             CHGVAR     VAR(&COMMIT_OPT) VALUE('YES')                 /*S01522*/
                                                                      /*S01522*/
             CALL       PGM(CGC2270) PARM(&COMP_NAME &COMP_SEQ +
                          &EXTRACT &MEMBER &COMMIT_OPT)               /*S01522*/
                                                                                          /*CCG015*/
/** Call Custom Defined Data Extract pgm */                                               /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)                                 /*CCG015*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CCG015*/
             GOTO       CMDLBL(ABNOR)                                                     /*CCG015*/
             ENDDO                                                                        /*CCG015*/
                                                                      /*S01522*/
             ENDDO                                                    /*S01522*/
                                                                      /*S01522*/
/**/
/*  CALL REPORT PROGRAM , U1 ON - INPUT CYCLE ON REQUEST           */
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
 LOOP:       ALCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIX) VALUE(&SIX + 1)                     /*163444*/
             IF         COND(&SIX *LE 6) THEN(GOTO CMDLBL(LOOP))      /*163444*/
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDLOOP)                               /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNC1        )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNC1        )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
             CHGJOB     SWS(10000000)
/*********** CALL       PGM(FF0570)                                */ /*S01117*/
             CALL       PGM(FF0570) PARM(&RSEQ)                       /*S01117*/
/**/
             DLCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
ENDLOOP:                                                              /*163444*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND     */
/* MESSAGE TO MRUNQ AND MOPERQ.                                    */ /*FO0073*/
/**MESSAGE*TO*MOPERQ*.****                                         */ /*FO0073*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)                        /*FO0073*/
/************    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) + /*FO0073*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              */ /*FO0073*/
             GOTO       CMDLBL(ABNOR)                                 /*FO0073*/
             ENDDO
/**/
             GOTO       CMDLBL(REL)
/**/
/*  ERROR PROCESSING IF PROGRAM FAILS                              */
/**/
/*BNOR:******SNDPGMMSG  MSG('FFC0323 CUSTOMER TRADING STATEMENTS + */ /*FO0073*/
/************             ENDED ABNORMALLY') TOPGMQ(*EXT) +        */ /*FO0073*/
/************             TOMSGQ(MOPERQ)                           */ /*FO0073*/
 ABNOR:      SNDPGMMSG  MSG('FFC0323 - CUSTOMER TRADING STATEMENTS +
                          REQUEST ENDED ABNORMALLY') TOMSGQ(MRUNQ +
                          MOPERQ)                                     /*FO0073*/
             CHGJOB     SWS(XXXXXX11)                                 /*FO0073*/
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
/**/
 REL:        DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/                                                                  /*FO0046*/
/*   RESET 'CUSTOMER TRADING STATEMENTS' FLAG ON FFSTAT TO 'N'     */ /*FO0046*/
/**/                                                                  /*FO0046*/
             CHGDTAARA  DTAARA(FFSTAT (36 1)) VALUE('N')              /*FO0046*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0046*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
