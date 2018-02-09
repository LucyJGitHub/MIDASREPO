/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF O/s holdings by inst. (EOC)')                */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1024  -  OUTSTANDING HOLDINGS BY INSTRUMENT (EOC)            */
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
/*   PREV AMEND NO. 163444             DATE  09AUG99                 */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  S01117             DATE 02APR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   163444  - Y2K sort order and file allocation                    */
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
             DCL        &CODEW1       TYPE(*CHAR)  LEN(3)             /*163444*/
/*********** DCL        &MEM1         TYPE(*CHAR)  LEN(44)         */ /*S01117*/
             DCL        &MEM1         TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &ACT          TYPE(*CHAR)  LEN(1)
             DCL        &MSG          TYPE(*CHAR)  LEN(70)
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&SIX2) TYPE(*DEC) LEN(1 0) VALUE(0)       /*163444*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
/**/
/*   DEFAULT POSTN1 AND PRICS OVERRIDE IS TO OTC WHICH CORRESPONDS  */
/*   TO PARAMETER CODE BEING BLANK                                  */
/**/
/*   IF CODE IS NOT BLANK OVERRIDE POSTN1 AND PRICS TO MEMBER 'CODE'*/
/**/
        IF         COND(&CODE *EQ '  ') THEN(DO)
             OVRDBF     FILE(POSTN1) TOFILE(POSTN1) MBR(OTC)
             OVRDBF     FILE(PRICS) TOFILE(PRICS) MBR(OTC)
        ENDDO
        ELSE       CMD(DO)
             OVRDBF     FILE(POSTN1) TOFILE(POSTN1) MBR(&CODE)
             OVRDBF     FILE(PRICS) TOFILE(PRICS) MBR(&CODE)
        ENDDO
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
        IF         COND(&CODE *EQ '  ') THEN(DO)                      /*163444*/
             CHGVAR     VAR(&CODEW1) VALUE('OTC')                     /*163444*/
        ENDDO                                                         /*163444*/
        ELSE       CMD(DO)                                            /*163444*/
             CHGVAR     VAR(&CODEW1) VALUE(&CODE)                     /*163444*/
        ENDDO                                                         /*163444*/
                                                                      /*163444*/
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
             OPNQRYF    FILE((POSTNCD &CODEW1)) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNCD &CODEW1)) FORMAT(FFPSNCPD) +
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
             OPNQRYF    FILE((POSTNKD &CODEW1)) FORMAT(FFPSNKPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNKPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNKD &CODEW1)) FORMAT(FFPSNKPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNKPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
/**/
/*   CALL PROGRAM  FF1210                                          */
/**/
        CALL       PGM(FF1210) PARM(&CODE)
             DLCOBJ     OBJ((FFPSNKPD *FILE *EXCL))                   /*163444*/
ENDLOOP2:                                                             /*163444*/
             DLCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
ENDLOOP:                                                              /*163444*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO MOPERQ AND RUNQ                                       */
/**/
         IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM1)         */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM1)            /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM1) +
                          TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1024')
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
END:    DLTOVR     FILE(POSTN1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(PRICS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
        ENDPGM
