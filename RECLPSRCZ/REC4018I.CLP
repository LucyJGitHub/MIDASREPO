/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE T&N Accounts - Account code check')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail T&N Accounts                                 */
/*                                                                   */
/*       REC4018I -  Midas Retail Term & Notice Account Code Check   */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CRE015 *C *CREATE  Date 18Dec09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CRE015 - Retail Term & Notice Accounts                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &PARM)
/**/
/* Declare variables */
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) VALUE('  +
                          DMLIB   ')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10) VALUE('  +
                          JLIB    ')
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR)  LEN(1)                               */ /*CCB020*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(%SST(&MODE 1 7)) VALUE(&PARM)
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGJOB     SWS(XXXXXX00)
 
/* Send Message to MRUNQ */
 
             SNDPGMMSG  MSG('REC4018 Midas RE Term & Notice +
                          synchronise Accounts and Term and Notice +
                          Files') TOMSGQ(MRUNQ)
 
/* Format library Names */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(&SYSID)
             CHGVAR     VAR(%SST(&JLIB 1 2)) VALUE(&SYSID)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                          VALUE('Y'))
 
 
/* Synchronise ACCNTAB and REPRPNPD  */
 
             CALL       PGM(RE4018) PARM(&MODE)
 
/* Database Error has occurred */
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             GOTO          CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            REC4018I ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
 
             IF         COND(&CMTCTL *NE 'Y') THEN(DO)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2009')
             ENDPGM
