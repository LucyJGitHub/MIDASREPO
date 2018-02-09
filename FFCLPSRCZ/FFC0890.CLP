/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF O/s holdings by inst. (cob)')                */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0890  -  OUTSTANDING HOLDINGS BY INSTRUMENT REPORT           */
/*                 (EOC IN COB)                                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*   PREV AMEND NO. 163444             DATE  07OCT99                 */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  079666             DATE 01DEC94                  */
/*                  S01117             DATE 02APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   163444  - Y2K sort order and file allocation                    */
/*   079666 - Add global monitor message processing                  */
/*   S01117  -  MULTIBRANCHING                                       */
/*    S01117  -  MULTIBRANCHING                                      */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&MKT) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&SIX2) TYPE(*DEC) LEN(1 0) VALUE(0)       /*163444*/
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
/* SEND MESSAGE TO MRUNQ                                            */
/**/
             SNDPGMMSG  MSG('FFC0890 - +
              Outstanding Holdings by Instrument Report') TOMSGQ(MRUNQ)
/**/
/* PROCESS OTC'S (OVER THE COUNTER TRADES)                          */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR OTC            */
/**/
             OVRDBF     FILE(POSTN1) MBR(OTC)
             OVRDBF     FILE(PRICS) MBR(OTC)
 LOOP1:      ALCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIX) VALUE(&SIX + 1)                     /*163444*/
             IF         COND(&SIX *LE 6) THEN(GOTO CMDLBL(LOOP1))     /*163444*/
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDLOOP1)                              /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
             OPNQRYF    FILE((POSTNCD OTC)) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNCD OTC    )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
 
 LOOP2:      ALCOBJ     OBJ((FFPSNKPD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIX2) VALUE(&SIX2 + 1)
             IF         COND(&SIX2 *LE 6) THEN(GOTO CMDLBL(LOOP2)) +
 
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDLOOP2)                              /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
             OPNQRYF    FILE((POSTNKD OTC    )) FORMAT(FFPSNKPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNKPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNKD OTC    )) FORMAT(FFPSNKPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNKPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
/**/
/*     CALL OUTSTANDING HOLDINGS BY INSTRUMENT REPORT                */
/**/
             CALL       PGM(FF1210) PARM('  ')
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC     */
/**/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
/**/
 LOOP:       CHGJOB     SWS(XXXXXX00)
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/**/
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET         */
/**/
             OVRDBF     FILE(PRICS) MBR(&MKT)
             OVRDBF     FILE(POSTN1) MBR(&MKT)
/**/
/*     CALL OUTSTANDING HOLDINGS BY INSTRUMENT REPORT                */
/**/
             OPNQRYF    FILE((POSTNCD &MKT   )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNCD &MKT   )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
 
             OPNQRYF    FILE((POSTNKD &MKT   )) FORMAT(FFPSNKPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNKPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNKD &MKT   )) FORMAT(FFPSNKPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNKPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
             CALL       PGM(FF1210) PARM(&MKT)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                 GOTO END
             ENDDO
/**/
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(LOOP)
             DLCOBJ     OBJ((FFPSNKPD *FILE *EXCL))                   /*163444*/
ENDLOOP2:                                                             /*163444*/
             DLCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
ENDLOOP1:                                                             /*163444*/
/**/
ABNOR:                                                                /*079666*/
             SNDPGMMSG  MSG('FFC0880 - Outstanding Holdings by +
                          Instrument Report TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             DMPCLPGM                                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
             CHGJOB     SWS(XXXXXX11)                                 /*079666*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*079666*/
END:
/**/
/*      DELETE ALL OVERRIDES                                        */
/**/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
