/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Add Chgs to Book Positions (EOC)')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1014  -  ADD POSITION CHANGES TO BOOK POSITIONS (EOC)        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. S01117             DATE  01FEB90                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
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
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
/**/
/*   DEFAULT OVERRIDES ARE TO OTC WHICH CORRESPONDS TO PARAMETER    */
/*   CODE BEING BLANK                                               */
/**/
/*   IF CODE IS NOT BLANK OVERRIDE FILES TO MEMBER 'CODE'           */
/**/
        IF         COND(&CODE *EQ '  ') THEN(DO)
             OVRDBF     FILE(POSTNK) TOFILE(POSTNK) MBR(OTC)
             OVRDBF     FILE(POCHG3) TOFILE(POCHG3) MBR(OTC)
             OVRDBF     FILE(TRANS) TOFILE(TRANS) MBR(OTC)
        ENDDO
        ELSE       CMD(DO)
             OVRDBF     FILE(POSTNK) TOFILE(POSTNK) MBR(&CODE)
             OVRDBF     FILE(POCHG3) TOFILE(POCHG3) MBR(&CODE)
             OVRDBF     FILE(TRANS) TOFILE(TRANS) MBR(&CODE)
        ENDDO
/**/
/*   CALL PROGRAM  FF0435                                          */
/**/
        CALL       PGM(FF0435)
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
             CHGVAR     VAR(&MSG) VALUE('Database Error - FFC1014')
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
END:    DLTOVR     FILE(POSTNK)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(POCHG3)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
        DLTOVR     FILE(TRANS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
        ENDPGM
