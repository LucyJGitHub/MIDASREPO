/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Transaction Income Splits Mnt/Repair/Enq')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2080 - Transaction Income Splits Mnt/Repair/Enq          */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE035  *CREATE    Date 22Sep03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE035 - Lending Enhancements for Nordea Priority 1 Phase 2:*/
/*                Income Splits                                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &OPTN)
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF1023)
 
             IF         COND(&MODE *EQ 'I') THEN(DO)
             OVRDBF     FILE(LETISPLX) TOFILE(LETISPL0) SHARE(*NO)
             OVRDBF     FILE(LETISPLY) TOFILE(LETISPL1) SHARE(*NO)
             OVRDBF     FILE(LETISPLV) TOFILE(LETISPL3) SHARE(*NO)
             OVRDBF     FILE(LETISPLW) TOFILE(LETISPL4) SHARE(*NO)
             CALL       PGM(LE2080) PARM(&MODE &OPTN ' ' ' ')
             ENDDO
 
             IF         COND(&MODE *EQ 'F') THEN(DO)
             OVRDBF     FILE(LEITISLX) TOFILE(LEITISL0) SHARE(*NO)
             OVRDBF     FILE(LEITISLY) TOFILE(LEITISL1) SHARE(*NO)
             OVRDBF     FILE(LEITISLZ) TOFILE(LEITISL2) SHARE(*NO)
             CALL       PGM(LE2081) PARM(&OPTN)
             ENDDO
 
             IF         COND(&MODE *EQ 'E') THEN(DO)
             CALL       PGM(LE2082) PARM(&OPTN)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC2080 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
 
 /* End program */
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
