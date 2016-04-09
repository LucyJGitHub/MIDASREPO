/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Teller Cross In-Cross Out Audit')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4235 - Teller Cross-In / Cross-Out Report                */
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
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001 - Retail Teller System.                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(50) VALUE(' ')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/**  Send program Message */
 
             SNDPGMMSG  MSG('TELLER CROSS-IN CROSS-OUT REPORT') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/**/
/*    Global monitor message                                         */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**  Clear switches */
 
             CHGJOB    SWS(00000000)
 
             CPYF       FROMFILE(TTRANPD) TOFILE(*LIBL/TTALTPD) +
                          FROMMBR(*ALL) MBROPT(*REPLACE) CRTFILE(*NO) +
                          INCCHAR(*RCD 2 *EQ 'T') INCREL((*IF FNCD +
                          *EQ '00E')) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2689)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)
 
             CPYF       FROMFILE(TTRANPD) TOFILE(*LIBL/TTALTPD1) +
                          FROMMBR(*ALL) MBROPT(*REPLACE) CRTFILE(*NO) +
                          INCCHAR(*RCD 2 *EQ 'T') INCREL((*IF FNCD +
                          *EQ '00F')) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2689)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2870)
 
 
             OVRDBF    FILE(TTALTPD)  TOFILE(TTRANPD)
             OVRDBF    FILE(TTALTPD1)  TOFILE(TTRANPD)
 
             OVRDBF    FILE(TTRANL4)  TOFILE(*LIBL/TTALTPD) SHARE(*NO)
             OVRDBF    FILE(TTRANL5)  TOFILE(*LIBL/TTALTPD1) SHARE(*NO)
 
 
/**  Call the program */
 
             CALL          PGM(RE4235)   PARM(&RSEQ &RENT)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
 
/**  For database errors, recover data from LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4235 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/**  End of program */
 
 ENDPGM:     DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
