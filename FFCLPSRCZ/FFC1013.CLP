/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Add Chgs to Cust/Brok Posns(EOC)')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1013  -  ADD POSITION CHANGES TO CUSTOMER/BROKER POSNS (EOC) */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01456             Date 05Dec93              */
/*                      S01117             Date 01Feb90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   S01456 - Monthly P&L Enhancements.                              */
/*   S01117 - MULTIBRANCHING                                         */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
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
             DCL VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')            /*S01456*/
             DCL VAR(&S01456) TYPE(*CHAR) LEN(1) VALUE(' ')           /*S01456*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
                                                                      /*S01456*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'S01456')          /*S01456*/
             IF COND(&PRTCD *EQ ' ') THEN(DO)                         /*S01456*/
               CHGVAR (&S01456) VALUE('Y')                            /*S01456*/
             ENDDO                                                    /*S01456*/
                                                                      /*S01456*/
/**/
/*   DEFAULT OVERRIDES ARE TO OTC WHICH CORRESPONDS TO PARAMETER    */
/*   CODE BEING BLANK                                               */
/**/
/*   IF CODE IS NOT BLANK OVERRIDE FILES TO MEMBER 'CODE'           */
/**/
        IF         COND(&CODE *EQ '  ') THEN(DO)
             OVRDBF     FILE(POSTNC) TOFILE(POSTNC) MBR(OTC)
             OVRDBF     FILE(TSMKT) TOFILE(TSMKT) MBR(OTC)
             OVRDBF     FILE(POCHG2) TOFILE(POCHG2) MBR(OTC)
             OVRDBF     FILE(TRANS) TOFILE(TRANS) MBR(OTC)
        ENDDO
        ELSE       CMD(DO)
             OVRDBF     FILE(POSTNC) TOFILE(POSTNC) MBR(&CODE)
             OVRDBF     FILE(TSMKT) TOFILE(TSMKT) MBR(&CODE)
             OVRDBF     FILE(POCHG2) TOFILE(POCHG2) MBR(&CODE)
             OVRDBF     FILE(TRANS) TOFILE(TRANS) MBR(&CODE)
        ENDDO
/**/
/*   CALL PROGRAM  FF0430                                          */
/**/
        CALL       PGM(FF0430) PARM(&CODE)
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
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1013')
             CALL       FF0473 PARM(&CODE &ACT &MSG)
         ENDDO
                                                                      /*S01456*/
             IF COND(&S01456 *EQ 'Y') THEN(DO)                        /*S01456*/
               CALL   PGM(FF2000) PARM(&CODE)                         /*S01456*/
             ENDDO                                                    /*S01456*/
/**/
         GOTO       CMDLBL(END)
/**/
/*   ERROR PROCESSING IF PROGRAM FAILS                             */
/**/
 ABNOR: CHGJOB     SWS(XXXXXX1X)
/**/
/*  REMOVE ALL FILE OVERRIDES                                        */
/**/
END:    DLTOVR     FILE(POSTNC)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TSMKT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(POCHG2)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TRANS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
        ENDPGM
