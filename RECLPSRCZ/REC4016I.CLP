/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE T&N Rate Changes at rollover')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail T&N Accounts                                 */
/*                                                                   */
/*       REC4016I- Midas RE T&N Rate Changes at rollover             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CRE015 *CREATE     Date 18Dec09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE015  - Retail Term & Notice Accounts                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
/**/
/* Declare variables */
/**/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
 
             DCL        VAR(&STADATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ENDDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&STADATEDEC) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&ENDDATEDEC) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&STADAYDEC) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ENDDAYDEC) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STADAY) TYPE(*CHAR) LEN(5)
             DCL        VAR(&ENDDAY) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(5)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ZERR) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&STADATE) VALUE(%SST(&PARM 1 6))
             CHGVAR     VAR(&ENDDATE) VALUE(%SST(&PARM 7 12))
             CHGVAR     VAR(&MODE) VALUE(%SST(&PARM 13 17))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SST(&DPLIB 1 2)) VALUE(&SYSID)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/**/
 /* CONVERT DATES */
/**/
             IF         COND(&STADATE *NE 'PRVRUN') THEN(DO)
             CHGVAR     VAR(&STADATEDEC) VALUE(&STADATE)
             CALL       PGM(ZDATE1) PARM(&ZERR &STADATEDEC 'D' +
                          &STADAYDEC)
             CHGVAR     VAR(&STADAY) VALUE(&STADAYDEC)
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&STADAY) VALUE('*PRUN')
             ENDDO
 
             IF         COND(&ENDDATE *NE 'RUNDAT') THEN(DO)
             CHGVAR     VAR(&ENDDATEDEC) VALUE(&ENDDATE)
             CALL       PGM(ZDATE1) PARM(&ZERR &ENDDATEDEC 'D' +
                          &ENDDAYDEC)
             CHGVAR     VAR(&ENDDAY) VALUE(&ENDDAYDEC)
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&ENDDAY) VALUE('*RUND')
             ENDDO
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                          VALUE('Y'))
/**/
 /* CREATE AUDIT FILES */
/**/
             CRTDUPOBJ  OBJ(REPPA1PD) FROMLIB(&DPLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(TNAUDIT1)
             MONMSG CPF0000
             CLRPFM QTEMP/TNAUDIT1
             CRTDUPOBJ  OBJ(REPPA2PD) FROMLIB(&DPLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(TNAUDIT2)
             MONMSG CPF0000
             CLRPFM QTEMP/TNAUDIT2
             OVRDBF     FILE(REPPA1PD) TOFILE(QTEMP/TNAUDIT1)
             OVRDBF     FILE(REPPA2PD) TOFILE(QTEMP/TNAUDIT2)
 
             CHGVAR     VAR(&PMODE) VALUE(&MODE)
             IF         COND(&MODE = 'UPDAT') THEN(DO)
             CHGVAR     VAR(&PMODE) VALUE('RERCH')
             ENDDO
             CALL       PGM(RE4016) PARM(&STADAY &ENDDAY ' ' +
                          &PMODE)
 
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO DATAERR)
/**/
/** Print out report **/
/**/
             CALL       PGM(RE4016P) PARM('USER')
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO DATAERR)
             GOTO END
 
/**/
/* Database Error has occurred */
/**/
DATAERR:
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
 
/**/
/* Abnormal termination processing                       */
/**/
 ABNOR:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Program REC4016I ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
             DLTOVR     FILE(*ALL)
/**/
 /* Changes should be commited, but rollback just in case there are +
    some uncommitted changes */
/**/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             IF         COND(&CMTCTL *NE 'Y') THEN(DO)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             CHGJOB     SWS(XXXXXX00)
 
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2009' )
 
             ENDPGM
