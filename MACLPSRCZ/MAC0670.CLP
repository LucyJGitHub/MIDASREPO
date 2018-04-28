/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MA Add members to OD download file')            */
/*********************************************************************/
/*                                                                   */
/*  Midas - Microfiche/Optical Disk Archiving Module         */
/*                                                                   */
/*  MAC0670  - Add Members to Optical Disk Bureau file               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO  S01408                DATE 05MAY95                */
/*  PREV AMEND.NO. 065368                DATE 12JAN94                */
/*                 S01382                DATE 28JUL92                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  S01408 - Addition of core hook MAC0670MPS                        */
/*  065368 - PF/MAOPTDPD NOW RESIDES IN DP LIBRARY                   */
/*  S01382 - NEW PROGRAM FOR OPTICAL DISK DEVELOPMENT                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* This program adds members to PF/MAOPTDPD for each archive ID      */
/* specified on LF/MAARCHL1                                          */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*********************************************************************/
 
             PGM        PARM(&EFLG)
 
             DCL        VAR(&EFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
/************DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) +
/************             VALUE('XXDMLIB   ')                      */ /*065368*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('XXDPLIB   ')                         /*065368*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(MAARCHL1)
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&EFLG) VALUE(' ')
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*  Retrieve Midas system ID                                       */
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
/************CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(%SST(&SDSTAT 6 2)) *065368*/
             CHGVAR     VAR(%SST(&DPLIB 1 2)) +
                        VALUE(%SST(&SDSTAT 6 2))                      /*065368*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,MAC0670MPS          */                               /*S01408*/
/* */                                                                 /*S01408*/
 
/*  For each Archive ID on MAARCHL1, add a member to MAOPTDPD       +
    with member name equal to Archive ID and member text equal      +
    to Archive ID Description                                       */
 READF:      RCVF       RCDFMT(@EAREJO)
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
/************ADDPFM     FILE(&DMLIB/MAOPTDPD) MBR(&EAARID) +
/************             TEXT(&EAADSC)                            */ /*065368*/
             ADDPFM     FILE(&DPLIB/MAOPTDPD) MBR(&EAARID) +
                          TEXT(&EAADSC)                               /*065368*/
             GOTO       CMDLBL(READF)
 
/*  Error processing                                                */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             CHGVAR     VAR(&EFLG) VALUE('Y')
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSG) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSG) TOMSGQ(MOPERQ)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
             SNDPGMMSG  MSG('MAC0670 Add Members to Optical Disk +
                          Bureau file terminated abnormally.  See +
                          previous messages for further +
                          information.') TOMSGQ(MOPERQ)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
 END:        ENDPGM
