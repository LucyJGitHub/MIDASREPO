/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF I/c interim prices list')                    */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0320  -  PRICES LIST (INTERIM)                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*   LAST AMEND NO. 163444             DATE 30SEP99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   PREV AMEND NO. E37350             DATE 27MAY92                  */
/*                  RT0121             DATE 23MAY91                  */
/*                  FO0073             DATE 15APR91                  */
/*                  FO0066             DATE 09APR91                  */
/*                  FO0045             DATE 27MAR91                  */
/*                  S01117             DATE 19APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*   163444  -  Y2K Sort Order amd file allocation.                  */
/*   E37350  -  Dummy value('##') used for OTC Market Centre to      */
/*              trigger an OTC report.                               */
/*   RT0121  -  Monitor the creation of LDA to trap error            */
/*           -  lda already exists.                                  */
/*   FO0073  -  U7 + U8 SHOULD BE SET ON IN ABNOR PROCESSING, AND    */
/*              DB ERROR MESSAGES SHOULD BE SENT TO MRUNQ + MOPERQ.  */
/*   FO0066  -  SUBMITTED REPORT NEEDS TO CREATE AN LDA              */
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
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&PMRKT)   TYPE(*CHAR)  LEN(2)
/*********** DCL        VAR(&PHEAD)   TYPE(*CHAR)  LEN(30)         */ /*FO0045*/
             DCL        &RSEQ         TYPE(*CHAR)  LEN(5)             /*S01117*/
             DCL        &RLEV         TYPE(*CHAR)  LEN(1)             /*S01117*/
             DCL        &RENT         TYPE(*CHAR)  LEN(3)             /*S01117*/
             DCL        &RPARM        TYPE(*CHAR)  LEN(100)           /*FO0045*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(10000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*FO0066*/
             MONMSG     MSGID(CPF1023)                                /*RT0121*/
/**/
/*  PROGRAM FF1265 NOW CALLED BY NEW PROMPT PROGRAM FFC0320P       */ /*FO0045*/
/**/                                                                  /*FO0045*/
/****CALL*PROMPT*PROGRAM****                                       */ /*FO0045*/
/*********** CHGVAR     VAR(&PHEAD) VALUE('PRICES LIST (INTERIM)') */ /*FO0045*/
/*********** CALL       PGM(FF1265) PARM(&PMRKT &PHEAD)            */ /*FO0045*/
/**FOR*DATABASE*ERRORS*RECOVER*DATA*FROM*LOCAL*DATA*AREA,*SEND******/ /*FO0045*/
/**MESSAGE*TO*MOPERQ.***                                            */
/*********** IF         COND(%SWITCH(XXXXXX11)) THEN(DO)           */ /*FO0045*/
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
/***********     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)   *S01117*FO0045*/
/*********** SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +  */ /*FO0045*/
/***********              TOPGMQ(*EXT) TOMSGQ(MOPERQ)              */ /*FO0045*/
/*********** GOTO       CMDLBL(EXIT)                               */ /*FO0045*/
/*********** ENDDO                                                 */ /*FO0045*/
/**/                                                                  /*FO0045*/
/***CMD/1*TAKEN,*MARKET*CENTRE*PARAMETER*WILL*BE '**'**********    */ /*FO0045*/
/*********** IF         COND(&PMRKT *EQ '**') THEN(GOTO EXIT)      */ /*FO0045*/
/*                                                                 */ /*FO0045*/
/**/                                                                  /*FO0045*/
/* RETRIEVE MARKET CODE FROM PARAMETERS PASSED FROM PROMPT PROGRAM */ /*FO0045*/
/**/                                                                  /*FO0045*/
             CHGVAR     VAR(&PMRKT) VALUE(%SST(&RPARM 1 2))           /*FO0045*/
             IF         COND(&PMRKT *EQ '##') THEN(CHGVAR +
                          VAR(&PMRKT) VALUE('  '))                    /*E37350*/
/**/
/* CALL PRICES LIST FOR REQUIRED MARKET                            */
/**/
             IF         COND(&PMRKT *NE '  ') THEN(DO)
             OVRDBF FILE(PRICS1) TOFILE(PRICS) MBR(&PMRKT)
             OVRDBF FILE(PRISP1) TOFILE(PRISP) MBR(&PMRKT)
             ENDDO
             ELSE DO
             OVRDBF FILE(PRICS1) TOFILE(PRICS) MBR(OTC)
             OVRDBF FILE(PRISP1) TOFILE(PRISP) MBR(OTC)
             ENDDO
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
 LOOP:       ALCOBJ     OBJ((FFPRICPD *FILE *EXCL))                   /*163444*/
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
             OPNQRYF    FILE((PRICS1         )) FORMAT(FFPRICPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPRICPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((PRICS1         )) FORMAT(FFPRICPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPRICPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
 
/**/
/*  CALL REPORT PROGRAM, PASSING MARKET CENTRE PARAMETER           */
/**/
/************CALL       PGM(FF1040) PARM(&PMRKT)                   */ /*S01117*/
             CALL       PGM(FF1040) PARM(&PMRKT &RSEQ)                /*S01117*/
             DLCOBJ     OBJ((FFPRICPD *FILE *EXCL))                   /*163444*/
ENDLOOP:                                                              /*163444*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND     */
/* MESSAGE TO MRUNQ AND MOPERQ.                                    */ /*FO0073*/
/**MESSAGE*TO*MOPERQ*.****                                         */ /*FO0073*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************    RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MRUNQ MOPERQ)                        /*FO0073*/
/************    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +  *FO0073*/
/************             TOPGMQ(*EXT) TOMSGQ(MOPERQ)                  *FO0073*/
             GOTO       CMDLBL(ABNOR)                                 /*FO0045*/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
/*BNOR:******SNDPGMMSG  MSG('FFC0320 PRICES LIST (INTERIM) ENDED + */ /*FO0073*/
/************             ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*FO0073*/
 ABNOR:      SNDPGMMSG  MSG('FFC0320 - PRICES LIST (INTERIM) ENDED +
                          ABNORMALLY') TOMSGQ(MRUNQ MOPERQ)           /*FO0073*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)                                 /*FO0073*/
/**/
/* DELETE OVERRIDES                                                */
/**/
END:         DLTOVR FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* DEALLOCATE THE MARKET DATA AREA AFTER USE                       */
/**/
/*********** IF      COND(&PMRKT *NE '   ') THEN(DO)               */ /*FO0045*/
             IF      COND(&PMRKT *NE '  ') THEN(DO)                   /*FO0045*/
                     DLCOBJ OBJ((&PMRKT *DTAARA *SHRRD))
                     MONMSG MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*FO0045*/
/**EXIT:******ENDPGM***                                                *FO0045*/
