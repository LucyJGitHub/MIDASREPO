/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Identify trans bynd hist prd (EOC)')         */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1028  -  IDENTIFY TRADES BEYOND HISTORICAL PERIOD (EOC)      */
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
/*       Prev Amend No. 163444             Date 04Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 20Apr90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   163444 - Y2K sort order and file allocation.                    */
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
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        &ACT          TYPE(*CHAR)  LEN(1)
             DCL        &MSG          TYPE(*CHAR)  LEN(70)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(0XXXXX00)
/**/
/*   OVERRIDE FILES TO MEMBER 'CODE'                                */
/**/
             OVRDBF     FILE(TRANS10) MBR(&CODE)
             OVRDBF     FILE(TRANS) MBR(&CODE)
             OVRDBF     FILE(TRSET) MBR(&CODE)
             OVRDBF     FILE(CLOST2) MBR(&CODE)
             OVRDBF     FILE(CLOST8) MBR(&CODE)
             OVRDBF     FILE(TRANSA) MBR(&CODE)
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
  LOOP:      ALCOBJ     OBJ((FFTR10PD *FILE *EXCL))                   /*163444*/
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
             OPNQRYF    FILE((TRANS10        )) FORMAT(FFTR10PD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFTR10PD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((TRANS10        )) FORMAT(FFTR10PD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFTR10PD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
/**/
/*   CALL PROGRAM  FF0455                                          */
/**/
        CALL       PGM(FF0455) PARM(&CODE)
             DLCOBJ     OBJ((FFTR10PD *FILE *EXCL))                   /*163444*/
ENDLOOP:                                                              /*163444*/
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
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1028')
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
END:    DLTOVR     FILE(TRANS10)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TRANS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TRSET)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(CLOST2)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(CLOST8)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TRANSA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
        ENDPGM
