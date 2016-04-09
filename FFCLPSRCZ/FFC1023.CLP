/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Prices list (EOC)')                          */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC1023  -  PRICES LIST (EOC)                                   */
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
/*   PREV AMEND NO. S01117             DATE 22FEB90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*   163444 - Y2K SORT ORDER                                         */
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
             DCL        &ACT          TYPE(*CHAR)  LEN(1)
             DCL        &MSG          TYPE(*CHAR)  LEN(70)
             DCL        &MEM          TYPE(*CHAR)  LEN(44)
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Global monitor message                                           */
/**/
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGJOB     SWS(0X1XXX00)
/**/
/*   DEFAULT OVERRIDES ARE TO MEMBER OTC WHICH CORRESPONDS          */
/*   TO PARAMETER CODE BEING BLANK                                  */
/**/
/*   IF CODE IS NOT BLANK OVERRIDE TO MEMBER 'CODE'                 */
/**/
        IF         COND(&CODE *NE '  ') THEN(DO)
             OVRDBF     FILE(PRICS1) TOFILE(PRICS) MBR(&CODE)
             OVRDBF     FILE(PRISP1) TOFILE(PRISP) MBR(&CODE)
             OVRDBF     FILE(PRICSA) TOFILE(PRICSA) MBR(&CODE)
             OVRDBF     FILE(PRISPA) TOFILE(PRISPA) MBR(&CODE)
        ENDDO
/**/
        IF         COND(&CODE *EQ '  ') THEN(DO)
             OVRDBF     FILE(PRICS1) TOFILE(PRICS) MBR(OTC)
             OVRDBF     FILE(PRISP1) TOFILE(PRISP) MBR(OTC)
             OVRDBF     FILE(PRICSA) TOFILE(PRICSA) MBR(OTC)
             OVRDBF     FILE(PRISPA) TOFILE(PRISPA) MBR(OTC)
        ENDDO
/**/
/*   Create Y2K sort extract file                                  */ /*163444*/
/**/
                                                                      /*163444*/
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
/*   CALL PROGRAM                                                  */
/**/
/*********** CALL       PGM(FF1040) PARM(&CODE)                    */ /*S01117*/
             CALL       PGM(FF1040) PARM(&CODE '     ')               /*S01117*/
             DLCOBJ     OBJ((FFTRANPD *FILE *EXCL))                   /*163444*/
ENDLOOP:                                                              /*163444*/
/**/
             DLTOVR     FILE(PRICS1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRISP1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRICSA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRISPA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*     Database error processing. Send message to MOPERQ/MRUNQ      */
/**/
DBERR:       IF COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)
/*********** RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)          */ /*S01117*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ)
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1023')
             CALL       FF0473 PARM(&CODE &ACT &MSG)
             ENDDO
/**/
             GOTO END
/**/
/*     Abnormal error processing.                                   */
/**/
 ABNOR:
             DLTOVR     FILE(PRICS1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRISP1)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRICSA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRISPA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:         ENDPGM
