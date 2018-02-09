/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF I/c trans. input today (interim)')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0321  -  TRANSACTION INPUT TODAY LIST (INTERIM)              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CER001             Date 25Apr05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      163444             Date 05Aug99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E37350             DATE 27May92              */
/*                  RT0121             DATE 23MAY91                  */
/*                  FO0073             DATE 15APR91                  */
/*                  FO0066             DATE 09APR91                  */
/*                  FO0045             DATE 27MAR91                  */
/*                  S01117             DATE 07JUN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*   163444  -  Y2K sort order and file allocation.                  */
/*   E37350  -  Dummy value('##') used for OTC Market Centre to      */
/*              trigger an OTC report.                               */
/*   RT0121  -  Monitor the creation of LDA to trap error            */
/*           -  lda already exists.                                  */
/*   FO0073  -  U7 + U8 SHOULD BE SET ON IN ABNOR PROCESSING, AND    */
/*              DB ERROR MESSAGES SHOULD BE SENT TO MRUNQ + MOPERQ.  */
/*   FO0066  -  SUBMITTED REPORTS NEED TO HAVE AN LDA CREATED        */
/*   FO0045  -  R10 RCF Processing change - Market Prompt program    */
/*              now called by FFC0320P and Market Code passes as a   */
/*              parameter.                                           */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01117*/
/*********** PGM        PARM(&RSEQ &RLEV &RENT)             */ /*S01117*FO0045*/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)                /*FO0045*/
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)             /*S01117*/
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)             /*S01117*/
             DCL        &RENT         TYPE(*CHAR)  LEN(3)             /*S01117*/
             DCL        &RPARM        TYPE(*CHAR)  LEN(100)           /*FO0045*/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&PMRKT)   TYPE(*CHAR)  LEN(2)
/*********** DCL        VAR(&PHEAD)   TYPE(*CHAR)  LEN(30)         */ /*FO0045*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,FFC0321001                                          */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CER001*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CER001*/
             DCL        VAR(&FEAT) TYPE(*CHAR) LEN(6)                                     /*CER001*/
             DCL        VAR(&ULX008) TYPE(*CHAR) LEN(1)                                   /*CER001*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGJOB     SWS(10000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*FO0066*/
             MONMSG     MSGID(CPF1023)                                /*RT0121*/
/*/COPY WNCPYSRC,FFC0321002                                          */
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CER001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CER001*/
             CHGVAR     VAR(&FEAT) VALUE('ULX008')                                        /*CER001*/
             CHGVAR     VAR(&ULX008) VALUE('N')                                           /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &FEAT) +
                                                                                          /*CER001*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&ULX008) VALUE('Y'))                                        /*CER001*/
/**/
/*  PROGRAM FF1265 NOW CALLED BY NEW PROMPT PROGRAM FFC0320P       */ /*FO0045*/
/**/                                                                  /*FO0045*/
/****CALL*PROMPT*PROGRAM****                                       */ /*FO0045*/
/*********** CHGVAR     VAR(&PHEAD) VALUE('TRANSACTIONS INPUT TODAY + /*FO0045*/
/***********              LIST')                                   */ /*FO0045*/
/*********** CALL       PGM(FF1265) PARM(&PMRKT &PHEAD)            */ /*FO0045*/
/*                                                                 */
/**FOR*DATABASE*ERRORS*RECOVER*DATA*FROM*LOCAL*DATA*AREA,*SEND******/ /*FO0045*/
/**MESSAGE*TO*MOPERQ.***                                           */ /*FO0045*/
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*FO0045*/
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
/***********     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)   *S01117*FO0045*/
/*********** SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +  */ /*FO0045*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ)              */ /*FO0045*/
/*********** GOTO       CMDLBL(EXIT)                               */ /*FO0045*/
/*********** ENDDO                                                 */ /*FO0045*/
/**/
/***CMD/1*TAKEN,*MARKET*CENTRE*PARAMETER*WILL*BE '**'**********    */ /*FO0045*/
/*********** IF         COND(&PMRKT *EQ '**') THEN(GOTO EXIT)      */ /*FO0045*/
/**/
/**/                                                                  /*FO0045*/
/* RETRIEVE MARKET CODE FROM PARAMETERS PASSED FROM PROMPT PROGRAM */ /*FO0045*/
/**/                                                                  /*FO0045*/
             CHGVAR     VAR(&PMRKT) VALUE(%SST(&RPARM 1 2))           /*FO0045*/
             IF         COND(&PMRKT *EQ '##') THEN(CHGVAR +
                          VAR(&PMRKT) VALUE('  '))                    /*E37350*/
/**/                                                                  /*FO0045*/
/* CALL TRANSACTIONS LIST FOR REQUIRED MARKET                       */
/**/
             IF         COND(&PMRKT *NE '  ') THEN(DO)
             OVRDBF TRANS7 MBR(&PMRKT)
             OVRDBF TRANSA MBR(&PMRKT)
             OVRDBF TRSET MBR(&PMRKT)
/*/COPY WNCPYSRC,FFC0321004                                          */
             ENDDO
             ELSE DO
             OVRDBF TRANS7 MBR(OTC)
             OVRDBF TRANSA MBR(OTC)
             OVRDBF TRSET MBR(OTC)
/*/COPY WNCPYSRC,FFC0321005                                          */
             ENDDO
/*/COPY WNCPYSRC,FFC0321003                                          */
             IF         COND(&ULX008 *EQ 'Y') THEN(DO)                                    /*CER001*/
             IF         COND(&PMRKT *NE *BLANK) THEN(DO)                                  /*CER001*/
             OVRDBF     FILE(FFTRX2PD) MBR(&PMRKT)                                        /*CER001*/
             ENDDO                                                                        /*CER001*/
             ELSE DO                                                                      /*CER001*/
             OVRDBF     FILE(FFTRX2PD) MBR(OTC)                                           /*CER001*/
             ENDDO                                                                        /*CER001*/
             ENDDO                                                                        /*CER001*/
/**/
/*  CALL REPORT PROGRAM, PASSING MARKET CENTRE PARAMETER             */
/**/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01117*/
 
               IF       COND(&PMRKT *NE '  ') +
                        THEN(OVRDBF FILE(TRANS7) MBR(&PMRKT) POSITION(*KEY 1 +
                        TRANSDF &RENT))                               /*S01117*/
/**/
               IF       COND(&PMRKT *EQ '  ') +
                        THEN(OVRDBF FILE(TRANS7) MBR(OTC) POSITION(*KEY 1 +
                        TRANSDF &RENT))                               /*S01117*/
 
 
/**/
/************           OPNDBF FILE(TRANS7) OPTION(*ALL)     S01117*/ /*163444*/
/************           MONMSG MSGID(CPF0000) EXEC(DO)       S01117*/ /*163444*/
/**/
/************           DLTOVR FILE(TRANS7)                  S01117*/ /*163444*/
/************    IF     COND(&PMRKT *NE '  ') +                    */ /*163444*/
/************           THEN(OVRDBF FILE(TRANS7) MBR(&PMRKT))S01117*/ /*163444*/
/************    IF     COND(&PMRKT *EQ '  ') +                    */ /*163444*/
/************           THEN(OVRDBF FILE(TRANS7) MBR(OTC))   S01117*/ /*163444*/
/**/
/************           ENDDO                                S01117*/ /*163444*/
                        ENDDO                                         /*S01117*/
/**/
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
 LOOP:       ALCOBJ     OBJ((FFTRANPD *FILE *EXCL))                   /*163444*/
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
             OPNQRYF    FILE((TRANS7         )) FORMAT(FFTRANPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFTRANPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((TRANS7         )) FORMAT(FFTRANPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFTRANPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
 
/**/
/*********** CALL       PGM(FF1020) PARM(&PMRKT)                   */ /*S01117*/
             CALL       PGM(FF1020) PARM(&PMRKT &RSEQ &RENT)          /*S01117*/
             DLCOBJ     OBJ((FFTRANPD *FILE *EXCL))                   /*163444*/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                        THEN(DO)                                      /*S01117*/
                        DLTOVR FILE(TRANS7)                           /*S01117*/
                        MONMSG MSGID(CPF9841)                         /*S01117*/
                        ENDDO                                         /*S01117*/
                        RCLRSC                                        /*S01117*/
ENDLOOP:                                                              /*163444*/
/*                                                                 */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND     */
/* MESSAGE TO MOPERQ AND MRUNQ.                                    */
/*                                                                 */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************    RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)                        /*FO0073*/
/************             TOMSGQ(MOPERQ)                           */ /*FO0073*/
             GOTO       CMDLBL(ABNOR)                                 /*FO0045*/
             ENDDO
/*                                                                 */
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
/*BNOR:******SNDPGMMSG  MSG('FFC0321 TRANSACTIONS INPUT TODAY LIST +  /*FO0073*/
/************             ENDED ABNORMALLY') TOPGMQ(*EXT) +        */ /*FO0073*/
/************             TOMSGQ(MOPERQ)                           */ /*FO0073*/
 ABNOR:      SNDPGMMSG  MSG('FFC0321 - TRANSACTIONS INPUT TODAY LIST +
                          ENDED ABNORMALLY') TOMSGQ(MRUNQ MOPERQ)     /*FO0073*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)                                 /*FO0073*/
/**/
/* DELETE FILE OVERRIDES */
/**/
END:         DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             IF         COND(&PMRKT *NE '  ') THEN(DO)
                  DLCOBJ     OBJ((&PMRKT *DTAARA *SHRRD))
                  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             ENDPGM                                                   /*FO0045*/
/**EXIT:******ENDPGM***                                                *FO0045*/
