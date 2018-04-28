/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Prod.  depend'y tab. rep interact')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Close of Business Processing              */
/*                                                                   */
/*       CBC0210  PRODUCE DEPENDENCY TABLE REPORT INTERACTIVELY      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.                    DATE 00/00/00             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&NUM &COMPNM &COMPSQ &MODID)
/**/
             DCL        VAR(&NUM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&COMPNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMPSQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MODID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* RESET SWITCHES U7 & U8 */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* IF SELECTING BY MODULE OBTAIN ALL RELEVANT COMPONENTS    */
/* USING QUERY ON COMPONENTS FILE CBCMPNPD AND PERFORM      */
/* OVERRIDE BEFORE CALLING PROGRAM                          */
/**/
             IF         COND(&NUM *EQ '2') THEN(DO)
                        OVRDBF     FILE(CBCMPNPD) SHARE(*YES)
             OPNQRYF    FILE((CBCMPNPD)) FORMAT(CBCMPNL4 @CMPNHK) +
                          QRYSLT('"' *CAT &MODID *CAT '" *EQ +
                          DHCMOD') KEYFLD((DHCMOD) (DHCOTT) (DHCSEQ))
                        OVRDBF     FILE(CBCMPNL4) TOFILE(CBCMPNPD) +
                              SHARE(*YES)
             ENDDO
/**/
/* CREATE DATA AREA LDA IN QTEMP - REQUIRED FOR BATCH JOBS */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('LOCAL DATA AREA FOR BATCH JOB') +
                          AUT(*USE)
/**/
/* MONITOR FOR MESSAGE SAYING DATA AREA ALREADY */
/* EXISTS WHEN RUNNING INTERACTIVE JOBS */
/**/
             MONMSG     MSGID(CPF1023)
/**/
             CALL       PGM(CB0210) PARM(&NUM &COMPNM &COMPSQ &MODID)
/**/
/* IF QUERY USED CLOSE OPEN QUERY FILE AND DELETE OVERRIDES  */
/**/
             IF         COND(&NUM *EQ '2') THEN(DO)
                        CLOF       OPNID(CBCMPNPD)
                        DLTOVR     FILE(CBCMPNL4 CBCMPNPD)
             ENDDO
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM        **/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
ABNOR:                  SNDPGMMSG  MSG('PRODUCTION OF DEPENDENCY +
                        TABLE REPORT TERMINATED ABNORMALLY') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                        MONMSG     MSGID(CPF0000 MCH0000)
/**/
                        RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                        MONMSG     MSGID(CPF0000 MCH0000)
                        SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                   MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)
                        MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
             ENDPGM
