/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD MDF transactions awaiting repair comp')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing data module                                */
/*                                                                   */
/*       SDC1494 - List of Transactions awaiting repair component    */
/*                 for MDF                                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Phase:  I/C  on request                                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 196570  *CREATE    Date 12Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       196570 - MDF Patch                                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      (c) Finastra International Limited')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*   Set off switches  */
/**/
             CHGJOB     SWS(00000000)
/**/
/*   Retrieve job information  */
/**/
             RTVJOBA       JOB(&JOB)
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 1 1))
/**/
/*   Check if another job is active and wait until it has ended */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 CHECK:      CRTDTAARA  DTAARA(&TOLIB/SDC1494) TYPE(*CHAR) LEN(1)
             MONMSG     MSGID(CPF1023) EXEC(DO)
             DLYJOB     DLY(30)
             GOTO       CMDLBL(CHECK)
             ENDDO
/**/
/*   Clear extract file */
/**/
             CLRPFM     FILE(SDINVLPD)
/**/
/*   Run extract to set up invalid transaction file */
/**/
             OVRDBF     FILE(FDIFWRTP) TOFILE(FDIFWRTPD) SHARE(*NO)
             OVRDBF     FILE(FDIINTRP) TOFILE(FDIINTRPD) SHARE(*NO)
             OVRDBF     FILE(SDIBSRTP) TOFILE(SDIBSRTPD) SHARE(*NO)
             OVRDBF     FILE(SDISPTRP) TOFILE(SDISPTRPD) SHARE(*NO)
             OVRDBF     FILE(SEIPRCSP) TOFILE(SEIPRCSPD) SHARE(*NO)
/**/
             CALL       PGM(SD1493)
             DLTOVR     FILE(*ALL)
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Call report program     */
             CALL       PGM(SD1494) PARM(&RSEQ &RLEV &RENT &RPARM)
             DLTOVR     FILE(*ALL)
/*                                                                   */
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
/**/
             ENDDO
/**/
/*   Clear extract file */
/**/
             CLRPFM     FILE(SDINVLPD)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination  */
/**/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SDC1494 ended abnormally ') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        DLTDTAARA  DTAARA(&TOLIB/SDC1494)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) +
                     VALUE('(c) Finastra International Limited')
 
             ENDPGM
