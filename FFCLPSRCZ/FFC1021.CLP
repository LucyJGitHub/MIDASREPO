/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Trans input today list (EOC)')               */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1021  -  TRANSACTIONS INPUT TODAY LIST (EOC)                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*       Prev Amend No. 163444             Date 09Aug99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 16May95              */
/*                  S01117             DATE 07JUN90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   163444 - Y2K sort order and file allocation                     */
/*   S01522 - User Defined Correspondence                            */
/*   S01117 - MULTIBRANCHING                                         */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CODE)
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        &MEM          TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        &CODE         TYPE(*CHAR)  LEN(2)
             DCL        &ACT          TYPE(*CHAR)  LEN(1)
             DCL        &MSG          TYPE(*CHAR)  LEN(70)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)             /*S01522*/
             DCL        VAR(&OPTION)  TYPE(*CHAR) LEN(7)              /*S01522*/
             DCL        VAR(&FMT)     TYPE(*CHAR) LEN(200)            /*S01522*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)            /*S01522*/
             DCL        VAR(&MIDAS   ) TYPE(*CHAR) LEN(10)            /*S01522*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(0XXXXX00)
             CHGVAR     VAR(&CGUSRMSG) VALUE('GB'  *CAT 'CGUSRMSG  ') /*S01522*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)              /*S01522*/
             CHGVAR     VAR(&MIDAS   ) VALUE('GB'  *CAT 'MIDAS     ') /*S01522*/
             OVRMSGF    MSGF(MIDAS   ) TOMSGF(&MIDAS   )              /*S01522*/
 
 
/** Access PF/SDMMODPD to determine whether UDC module is on */       /*S01522*/
             CHGVAR     VAR(&RTN_CODE) VALUE('       ')               /*S01522*/
             CHGVAR     VAR(&OPTION) VALUE('*FIRST ')                 /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTN_CODE &OPTION &FMT)    /*S01522*/
 
/** Database error handling */                                        /*S01522*/
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)        /*S01522*/
              CHGVAR     VAR(&MSG) VALUE('Error on access to ICD file +
                           SDMMODPD')                                 /*S01522*/
              GOTO       CMDLBL(ABNOR)                                /*S01522*/
             ENDDO                                                    /*S01522*/
/**/
/*   OVERRIDE MULTIMEMBER FILES TO MEMBER 'CODE'                    */
/**/
             OVRDBF     FILE(TRANS7) TOFILE(TRANS7) MBR(&CODE)
             OVRDBF     FILE(TRSET) TOFILE(TRSET) MBR(&CODE)
             OVRDBF     FILE(TRANSA) TOFILE(TRANSA) MBR(&CODE)
/*/COPY WNCPYSRC,FFC1021001                                          */
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
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
/*   CALL PROGRAM                                                  */
/**/
/*********** CALL       PGM(FF1020) PARM(&CODE)                    */ /*S01117*/
             CALL       PGM(FF1020) PARM(&CODE '     ' 'ALL')         /*S01117*/
             DLCOBJ     OBJ((FFTRANPD *FILE *EXCL))                   /*163444*/
ENDLOOP:                                                              /*163444*/
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ.                                               */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&ACT) VALUE('I')
                 CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1021')
                 CALL       FF0473 PARM(&CODE &ACT &MSG)
             ENDDO
/*                                                                      S01522*/
/**  If UDC is active Extract Transactions Actioned Today               S01522*/
  IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                  /*S01522*/
                                                                      /*S01522*/
             OVRDBF     FILE(TRANS) TOFILE(TRANS) MBR(&CODE)          /*S01522*/
             CALL       PGM(CG4604) PARM(' ' &CODE 'ALL')             /*S01522*/
                                                                      /*S01522*/
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)        /*S01522*/
             CHGVAR     VAR(&MSG) VALUE('User Defined Correspondence +
                          Extract failure')                           /*S01522*/
             ROLLBACK                                                 /*S01522*/
             GOTO       CMDLBL(ABNOR)                                 /*S01522*/
             ENDDO                                                    /*S01522*/
   ENDDO                                                              /*S01522*/
/*                                                                   */
             GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX1X)
/**/
END:
             DLTOVR     FILE(TRANS7)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRSET)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(TRANSA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,FFC1021002                                          */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
