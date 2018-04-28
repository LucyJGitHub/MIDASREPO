/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB audit report')                           */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0300  CLOSE OF BUSINESS AUDIT REPORT                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408             DATE 02/09/96             */
/*       PREV AMEND NO.                    DATE 00/00/00             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01408 - Addition of core hook CBC0300END                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TYPE)
/**/
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* RESET SWITCHES U7 & U8 */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* IF MODULE REPORT REQUIRED OVERRIDE TO COMPONENTS BY */
/* MODULE FILE AND TO USE MODULE REPORT PRINTER FILE */
/**/
             IF         COND(&TYPE = 'M') THEN(DO)
                        OVRDBF     FILE(CBCOMSL5) TOFILE(CBCOMSLA)
                        OVRDBF     FILE(CB0300P1) TOFILE(CB0300P2)
             ENDDO
/**/
             CALL       PGM(CB0300) PARM(&TYPE)
/*/COPY WNCPYSRC,CBC0300001                                          */
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
ABNOR:                  SNDPGMMSG  MSG('CLOSE OF BUSINESS AUDIT +
                        REPORT TERMINATED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                        MONMSG     MSGID(CPF0000 MCH0000)
/**/
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        MONMSG     MSGID(CPF0000 MCH0000)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)
                        MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBC0300END                                                   */
                                                                      /*S01408*/
             ENDPGM
