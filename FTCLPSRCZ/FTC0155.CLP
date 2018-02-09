/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Incoming Payments Selection')                */
/*********************************************************************/
/*                                                                   */
/*       Midas       FUNDS TRANSFER MODULE                       */
/*                       PAYMENTS MODULE                             */
/*                                                                   */
/*       FTC0155    INCOMING PAYMENTS SELECTION                      */
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
/*       PREV AMEND NO.  042167           DATE     21JUL92           */
/*                       S01194           DATE     31AUG90           */
/*                       XXXXXX           DATE     DDMMMYY           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       042167  -  Include CL Program for record locking            */
/*       S01194  -  NEW DATABASE HANDLING                            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
                                                                      /*042167*/
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)               /*042167*/
             DCL        VAR(&TRNREF) TYPE(*CHAR) LEN(15)              /*042167*/
             DCL        VAR(&RINFOR) TYPE(*CHAR) LEN(80)              /*042167*/
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*042167*/
 
/*/COPY WNCPYSRC,FTC0155001                                          */
 
             CHGJOB     SWS(XXXXXX00)
 
/*  CALL PROGRAM & MONITOR FOR ERRORS                               */
 
             CALL       PGM(FT0155)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('Transaction Failed. Re-input necessary. +
                          Press Enter to Continue.') TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO
 
/**   DATABASE ERROR HANDLING   **/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)             /*S01194*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*S01194*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
/*/COPY WNCPYSRC,FTC0155002                                          */
 
/*END:*******ENDPGM                                                   /*S01194*/
END:                                                                  /*S01194*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* CALL AOC8000 to release locks */                                   /*042167*/
/**/                                                                  /*042167*/
             CHGVAR     VAR(&MODULE) VALUE('FT')                      /*042167*/
             CHGVAR     VAR(&TRNREF) VALUE('               ')         /*042167*/
             CHGVAR     VAR(&RINFOR) VALUE('    ')                    /*042167*/
             CHGVAR     VAR(&RTNCDE) VALUE('       ')                 /*042167*/
             CALL       PGM(AOC8000) PARM(&RTNCDE &MODULE &TRNREF +
                          &RINFOR)                                    /*042167*/
/**/                                                                  /*042167*/
             ENDPGM
 
