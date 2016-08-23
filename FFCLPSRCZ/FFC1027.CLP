/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Inst hldngs by broker rpt (EOC)')            */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1027  -  INSTRUMENT HOLDINGS BY BROKER REPORT (EOC)          */
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
/*   LAST AMEND NO. 163444             DATE 09AUG99                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   PREV AMEND NO. E23409             DATE 31AUG90                  */
/*                  S01117             DATE 15MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   163444 - Y2K sort order and file allocation.                    */
/*   E23409 - SETTLEMENT ACROSS RETAIL ACCOUNTS ALLOWED IF RETAIL II */
/*            OR INTEREST ON ACCOUNTS INSTALLED - SETON U2 IF RE OR  */
/*            IA = 'Y'.   NOTE - RETAIL I NOT SUPPORTED ON AS/400    */
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
             DCL        &CODE         TYPE(*CHAR)  LEN(2)
/*********** DCL        &MEM1         TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM1         TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &ACT          TYPE(*CHAR)  LEN(1)
             DCL        &MSG          TYPE(*CHAR)  LEN(70)
             DCL        &MMOD         TYPE(*CHAR)  LEN(256)
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/*   TEST FOR RETAIL II OR INTEREST ON ACCOUNTS       */           /*E23409*/
/*     ( SET ON U2 IF PRESENT)                        */           /*E23409*/
/**/                                                               /*E23409*/
             CHGJOB     SWS(XXXXX100)                              /*E23409*/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)            /*E23409*/
             IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                          (%SST(&MMOD 23 1) *EQ 'Y')) +
                          THEN(CHGJOB SWS(X1XXXXXX))               /*E23409*/
/**/                                                               /*E23409*/
/****TEST*FOR*RETAIL*II*MODULE*-*SETON*U2*IF*PRESENT***//************E23409*/
/************CHGJOB*****SWS(XXXXX100)********************************E23409*/
/************RTVDTAARA**DTAARA(MMOD *ALL) RTNVAR(&MMOD)**************E23409*/
/************IF*********COND((%SST(&MMOD 3 1) *EQ 'Y') *AND +********E23409*/
/*************************(%SST(&MMOD 16 1) *EQ 'Y')) +**************E23409*/
/*************************THEN(CHGJOB SWS(X1XXXXXX))*****************E23409*/
/**/
/*   OVERRIDE FILES TO MEMBER 'CODE'                                */
/**/
             OVRDBF     FILE(POCHG6X) TOFILE(POCHG6) MBR(&CODE) +
                         SHARE(*NO)
             OVRDBF     FILE(POCHG6) TOFILE(POCHG6) MBR(&CODE)
             OVRDBF     FILE(TSMKT2) TOFILE(TSMKT2) MBR(&CODE)
             OVRDBF     FILE(POSTNC4) TOFILE(POSTNC4) MBR(&CODE)
             OVRDBF     FILE(TRANS) TOFILE(TRANS) MBR(&CODE)
             OVRDBF     FILE(PRICS) TOFILE(PRICS) MBR(&CODE)
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
                                                                      /*163444*/
 AGAIN:      ALCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
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
             OPNQRYF    FILE((POSTNC4        )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNC4        )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
 
/**/
/*   CALL PROGRAM  FF1050                                          */
/**/
        CALL       PGM(FF1050) PARM(&CODE)
/**/
             DLCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
ENDAGAIN:                                                             /*163444*/
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ                                                */
/*                                                                  */
         IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM1)         */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM1)            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM1) +
                          TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1027')
             CALL       FF0473 PARM(&CODE &ACT &MSG)
         ENDDO
/**/
         GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
 ABNOR: CHGJOB     SWS(XXXXXX1X)
/**/
/*  REMOVE ALL FILE OVERRIDES                                        */
/**/
END:    DLTOVR     FILE(POCHG6X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(POCHG6)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TSMKT2)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(POSTNC4)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TRANS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(PRICS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
        ENDPGM
