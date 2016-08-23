/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Gen. Entries File Merge (COB)')              */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0630  -  GENERATED ENTRIES FILE MERGE (COB)                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   LAST AMEND NO. S01117             DATE 19MAR90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   S01117  -  MULTIBRANCHING                                       */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
/*********** DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)              */ /*S01117*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* SEND MESSAGE TO MRUNQ                                            */
/**/
             SNDPGMMSG  MSG('FFC0630 - +
                          Generated Entries File Merge') TOMSGQ(MRUNQ)
/**/
/* Clear single member files                                        */
/**/
             CLRPFM     GEFFHH
             CLRPFM     GEFFPD
             CLRPFM     GEFFZZ
/**/
/* Establish header and detail records                              */
/**/
             CPYF FROMFILE(MGEFFHH) TOFILE(GEFFHH) FROMMBR(OTC) +
                  TOMBR(*FIRST) MBROPT(*ADD)
             CPYF FROMFILE(MGEFFPD) TOFILE(GEFFPD) FROMMBR(*ALL) +
                  TOMBR(*FIRST) MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/**/
/*  Override multi-member file to all members                       */
/**/
             OVRDBF     FILE(MGEFFZZ) MBR(*ALL)
/**/
/* Call FF0630                                                      */
/**/
             CALL       PGM(FF0630)
/**/
/*     Database error processing. Send message to MOPERQ & MRUNQ    */
/**/
             IF  COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********    RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)       */ /*S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
/**/
