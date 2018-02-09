/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OIS Events File Housekeeping Control')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1657 - OIS Events File Housekeeping Control              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CIR007  *CREATE    Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CIR007 - Overnight Index Swaps                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
 
/*-------------------------------------------------------------------*/
/* Global monitor message                                            */
/*-------------------------------------------------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
 
/*-------------------------------------------------------------------*/
/* Initialization                                                    */
/*-------------------------------------------------------------------*/
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             MONMSG     MSGID(CPF1015) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
             CHGJOB     SWS(XXXXXX00)
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
 
/*-------------------------------------------------------------------*/
/* Main processing                                                   */
/*-------------------------------------------------------------------*/
 
             CHGVAR     VAR(&STAT) VALUE(' ')
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* If restart, Copy back the saved event file */
             IF         COND(&STAT = 'Y') THEN(DO)
                CPYF     FROMFILE(&TOLIB/DLOEVTPDX1) TOFILE(DLOEVTPD) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DLOEVTPD))
             ENDDO
 
/* Delete backup files, existing or nonexisting */
             DLTF       FILE(&TOLIB/DLOEVTPDX1)
             MONMSG     MSGID(CPF0000)
 
/* Make a copy of the event file DLOEVTPD */
             CPYF       FROMFILE(DLOEVTPD) TOFILE(&TOLIB/DLOEVTPDX1) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
             CALL       PGM(DL1657)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Successful Completion - Clear Saved event file */
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             DLTF       FILE(&TOLIB/DLOEVTPDX1)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
 
 
/*-------------------------------------------------------------------*/
/* Abnormal processing                                               */
/*-------------------------------------------------------------------*/
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC1657 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 
/*-------------------------------------------------------------------*/
/* End processing                                                    */
/*-------------------------------------------------------------------*/
 
END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
             ENDPGM
