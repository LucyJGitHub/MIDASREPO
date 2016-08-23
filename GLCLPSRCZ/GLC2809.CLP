/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis History processing')                  */
/********************************************************************/
/*                                                                  */
/*   Midas - Midas-Fontis Interface                                 */
/*                                                                  */
/*   GLC2809    Fontis History Processing                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL004   *CREATE   Date 14FeB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       228542 - RGZPFM has changed at R5V3                         */
/*   CGL004 - Midas-Fontis Interface                                */
/*                                                                  */
/********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&F3MBRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
 
             DCLF       FILE(GLFREFL0)
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Send program message to MRUNQ */
 
             SNDPGMMSG  MSG('GLC2809 - Fontis History Processing') +
                          TOMSGQ(MRUNQ)
 
/* Switch off all user switches */
 
             CHGJOB     SWS(00000000)
 
/* Call program CB0160, to update Status parameter */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* If status parameter is 'N', clear file XGLFDTAPD, and copy all  */
/* members from GLFDTAPD into it. */
 
             IF         COND(&STAT = 'N') THEN(DO)
                RMVM       FILE(XGLFDTAPD) MBR(*ALL)
                MONMSG     MSGID(CPF0000)
                CPYF       FROMFILE(GLFDTAPD) TOFILE(XGLFDTAPD) +
                           FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*ADD)
                MONMSG     MSGID(CPF2817)
             ENDDO
 
 
/* Change status variable to 'Y' */
 
             CHGVAR     VAR(&STAT) VALUE('Y')
 
/* Call program CB0150, to update the restart indicator. */
 
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/* Call program GL2809, to drop historic records from GLFREFPD */
 
             CALL       PGM(GL2809)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* If job switches 7 & 8 are off, then reorganise GLFREFPD to  */
/* compress out deleted records, and copy members back to GLFDATAPD */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* If status parameter is 'Y', clear file GLFDTAPD */
 
               IF         COND(&STAT = 'Y') THEN(DO)
                   RMVM       FILE(GLFDTAPD) MBR(*ALL)
                   MONMSG     MSGID(CPF0000)
               ENDDO
 
/**********    RGZPFM     FILE(GLFREFPD)                                                  /*228542*/
/**********    MONMSG     MSGID(CPF2995 CPF2981)                                          /*228542*/
               CALL       PGM(SCC000060) PARM('GLFREFPD' '*FIRST')                        /*228542*/
               IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
LOOP:          RCVF
               MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP))
 
/* Empty Member */
 
               IF         COND(&F3MBRN = 'FONTIS942') THEN(DO)
                   ADDPFM     FILE(GLFDTAPD) MBR(FONTIS942)
                   MONMSG     MSGID(CPF0000)
                   ENDDO
             ELSE       CMD(DO)
 
/* Ignore missing members */
 
                   CPYF       FROMFILE(XGLFDTAPD) TOFILE(GLFDTAPD) +
                          FROMMBR(&F3MBRN) TOMBR(*FROMMBR) MBROPT(*ADD)
                   MONMSG     MSGID(CPF2817)
                   ENDDO
 
                   GOTO       CMDLBL(LOOP)
 
/* Change status parameter to 'N' */
 
 ENDLOOP:      CHGVAR     VAR(&STAT) VALUE('N')
 
/* Call CB0150 to Update restart indicator */
 
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/* Remove all members from XGLFDTAPD */
 
               RMVM       FILE(XGLFDTAPD) MBR(*ALL)
               MONMSG     MSGID(CPF0000)
             ENDDO
 
/* If either job user switches 7 or 8 are on, perform standard */
/* database error processing */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal Processing */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GL2809 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
