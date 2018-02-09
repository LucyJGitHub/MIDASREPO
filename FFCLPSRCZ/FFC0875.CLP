/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Prices file purge during cob')               */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0875  -  PRICES PURGING, END OF CENTRE IN COB                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. 190552             Date 29May01              */
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      163444             Date 04Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  079666             DATE 01DEC94                  */
/*                  S01117             DATE  13MAR90                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  190552 - Add proper overrides for file PRICSA to subract         */
/*           no. of records from corresponding member file.          */
/*  163444 - Y2K sort order and file allocation.                     */
/*  079666 - Add global monitor message processing                   */
/*  S01117 - MULTIBRANCHING                                          */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&A) TYPE(*DEC) LEN(2 0) VALUE(1)
             DCL        VAR(&FFEOC) TYPE(*CHAR) LEN(62)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*079666*/
                                                                      /*079666*/
/*   SEND MESSAGE TO MSGQ/MRUNQ                                    */
/**/
             SNDPGMMSG  MSG('FFC0875 - +
             Prices Purging') TOMSGQ(MRUNQ)
/**/
/*  OVERRIDE  LF/PRICS                                 */
/**/
             OVRDBF     FILE(PRICS) MBR(OTC)
             OVRDBF     FILE(PRICSA) MBR(OTC)                         /*190552*/
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
 AGAIN:      ALCOBJ     OBJ((FFPRICPD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIX) VALUE(&SIX + 1)                     /*163444*/
             IF         COND(&SIX *LE 6) THEN(GOTO CMDLBL(AGAIN))     /*163444*/
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDAGAIN)                              /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
             OPNQRYF    FILE((PRICS          )) FORMAT(FFPRICPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPRICPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((PRICS          )) FORMAT(FFPRICPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPRICPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
/**/
/*   CALL FF0467 - PRICES PURGING                                   */
/**/
             CALL       PGM(FF0467)  PARM('  ')
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC     */
/**/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
/**/
 LOOP:       IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/**/
/*  OVERRIDE LF/PRICS                               */
/**/
             OVRDBF     FILE(PRICS) MBR(&MKT)
             OVRDBF     FILE(PRICSA) MBR(&MKT)                        /*190552*/
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
             OPNQRYF    FILE((PRICS          )) FORMAT(FFPRICPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPRICPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((PRICS          )) FORMAT(FFPRICPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPRICPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
/**/
/*   CALL FF0467 - PRICES PURGING                                   */
/**/
             CALL       PGM(FF0467)  PARM(&MKT)
/**/
/* FOR DATABASE ERRORS GO TO DBERR TAG                              */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERR)
/**/
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(LOOP)
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND MRUNQ.                                     */
/**/
/**DBERR:*******RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)       */ /*S01117*/
DBERR:       RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                         TOMSGQ(MOPERQ MRUNQ)
/**/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0870 - Prices Purging TERMINATED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             DMPCLPGM                                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             CHGJOB     SWS(XXXXXX11)                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
                                                                      /*079666*/
END:                                                                  /*163444*/
             DLCOBJ     OBJ((FFPRICPD *FILE *EXCL))                   /*163444*/
ENDAGAIN:                                                             /*163444*/
 
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(*ALL)                                    /*163444*/
/** END:     DLTOVR     FILE(*ALL)                                 */ /*163444*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
