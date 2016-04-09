/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE List of Outward Clearing Cheques')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4218 - Outward Clearing Cheques Extract                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 096490             DATE 28NOV95              */
/*       PREV AMEND NO. CRT001  *CREATE    DATE 28FEB95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001 - Retail Teller System                               */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&MODE &CNAM &CSEQ &RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LDA)    TYPE(*CHAR)  LEN(256) VALUE(' ')
             DCL        VAR(&MODE)   TYPE(*CHAR)  LEN(1)
             DCL        VAR(&MSGDTA) TYPE(*CHAR)  LEN(50)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
/**/
/*  Global monitor message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* SET SWITCHES DEPENDING ON MODE */
/**/
             IF (&MODE *EQ 'I') THEN(DO)
             CHGJOB SWS(10000000)
             SNDPGMMSG  MSG('REC4218 - I/C list of Outward Clearing +
                          Cheques') TOMSGQ(MRUNQ)
             ENDDO
             ELSE DO
             CHGJOB SWS(01000000)
             SNDPGMMSG  MSG('REC4218 - Daily list of Outward Clearing +
                          Cheques') TOMSGQ(MRUNQ)
             ENDDO
/**/
/*  COB recovery processing  */
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
/**/
             CALL          PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/
             IF         COND(&STAT *EQ 'N') THEN(DO)
             CPYF       FROMFILE(CHQDPPH) TOFILE(&TOLIB/XCHQDPPH) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCHQDPPH))
             CPYF       FROMFILE(CHQDPPD) TOFILE(&TOLIB/XCHQDPPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCHQDPPD))
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
             ELSE       CMD(DO)
             CPYF       FROMFILE(XCHQDPPH) TOFILE(CHQDPPH) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CHQDPPH))
             CPYF       FROMFILE(XCHQDPPD) TOFILE(CHQDPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CHQDPPD))
             ENDDO
/**/
/* CLEAR PHYSICAL FILE MEMBERS */
/**/
             CLRPFM OTCLRPH
             MONMSG     MSGID(CPF0000)
             CLRPFM OTCLRPD
             MONMSG     MSGID(CPF0000)
             CLRPFM OTCLRPZ
             MONMSG     MSGID(CPF0000)
/**/
/* INITIALIZE DB AREA OF LDA AND CALL THE EXTRACT PROGRAM */
/**/
             CALL          PGM(RE4231)
/**/
/**/
/* INITIALIZE DB AREA OF LDA AND CALL THE PRINT PROGRAM */
/**/
             CALL       PGM(RE4218) PARM(&RSEQ &RLEV &RENT)
/**/
/* Reset value of restart flag to 'N' */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             DLTF       FILE(XCHQDPPH)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(XCHQDPPD)
             MONMSG     MSGID(CPF2105)
             ENDDO
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
/**/
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA)-
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/* FOR FILE IMBALANCE ERROR */
/**/
             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 171 10))
                SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4114 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
