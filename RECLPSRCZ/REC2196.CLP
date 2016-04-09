/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas S17 Report')                                    */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Retail Module                              */
/*                                                                   */
/*      REC2196 - S17 REPORT                                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01383            DATE  27APR92              */
/*                                                                   */
/********************************************************************/
/*                                                                  */
/*       S01383 - BASIC RATE TAX INCORPORATION                      */
/*                NEW PROGRAM                                       */
/*                                                                  */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PARAM) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
             CHGVAR     VAR(&PARAM) VALUE(&RPARM)
/**/
/* Set-off Database Error Switches */
/**/
             CHGJOB     SWS(XXXXXX00)
 
/* Clear Data File before running report. */
 
             CLRPFM     FILE(S17RTNPD)
 
/* Override to correct history file                     */
 
             IF         COND(%SST(&PARAM 1 1) *EQ '1') THEN(DO)
             OVRDBF     FILE(INTPSL24) TOFILE(INTPSL24)
             GOTO       CMDLBL(CALL)
             ENDDO
/**/
             IF         COND(%SST(&PARAM 1 1) *EQ '2') THEN(DO)
             OVRDBF     FILE(INTPSL24) TOFILE(INTPSL19)
             GOTO       CMDLBL(CALL)
             ENDDO
/**/
             IF         COND(%SST(&PARAM 1 1) *EQ '3') THEN(DO)
             OVRDBF     FILE(INTPSL24) TOFILE(INTPSL20)
             GOTO       CMDLBL(CALL)
             ENDDO
/**/
             IF         COND(%SST(&PARAM 1 1) *EQ '4') THEN(DO)
             OVRDBF     FILE(INTPSL24) TOFILE(INTPSL11)
             GOTO       CMDLBL(CALL)
             ENDDO
/**/
             IF         COND(%SST(&PARAM 1 1) *EQ '5') THEN(DO)
             OVRDBF     FILE(INTPSL24) TOFILE(INTPSL23)
             GOTO       CMDLBL(CALL)
             ENDDO
/**/
             IF         COND(%SST(&PARAM 1 1) *EQ '6') THEN(DO)
             OVRDBF     FILE(INTPSL24) TOFILE(INTPSL21)
             GOTO       CMDLBL(CALL)
             ENDDO
/**/
             IF         COND(%SST(&PARAM 1 1) *EQ '7') THEN(DO)
             OVRDBF     FILE(INTPSL24) TOFILE(INTPSL22)
             GOTO       CMDLBL(CALL)
             ENDDO
 
CALL:        CALL  PGM(RE2196) PARM(&RSEQ ' ')
 
             DLTOVR     FILE(INTPSL24)
             MONMSG     MSGID(CPF9841)
 
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))
/**/
             IF         COND(%SST(&PARAM 2 1) *NE 'Y') THEN(CLRPFM +
                          FILE(S17RTNPD))
/**/
             GOTO       CMDLBL(END)
/**/
/* Database Error Messages will be sent by RCF */
/**/
 DBERR:      RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
             MSGDTA(&MEM) TOMSGQ(MOPERQ) TOPGMQ(*EXT)
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:      SNDPGMMSG  MSG('S17 Report ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        ENDPGM
