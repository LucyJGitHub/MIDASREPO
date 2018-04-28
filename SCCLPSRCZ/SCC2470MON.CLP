/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC COB monitor for rcvr save to save files')    */
/*********************************************************************/
/*                                                                   */
/*       MIDAS SYSTEM CONTROL MODULE                                 */
/*                                                                   */
/*       SCC2470MON - Monitor COB and save journal rcvrs             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. 260790  *CREATE    Date 19Jun09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       260790 - COB performance fix                                */
/*                Save journal receivers to disk as they are chg'd.  */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* System ID */
/**/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
/**/
/* Libraries */
/**/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
/**/
/* Variables for Receive Data Queue processing */
/**/
             DCL        VAR(&DLEN) TYPE(*DEC) LEN(5 0) VALUE(10)
             DCL        VAR(&MESS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DATAQN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATAQE) TYPE(*CHAR) LEN(10)
/**/
/* Copyright statement definition */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
/**/
/* Global MONMSG */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/* Copyright statement definition at runtime */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE(&CPYFLD)
/**/
/* Obtain the system library id from SDSTAT */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&XLIB) VALUE(&SYSID *CAT 'XLIB')
/**/
/* Set up Data Queue Name */
/* DataQ is set up by SCC0401 and 'STOP' is sent by SCC0405 (I/C */
/* INIT RECEIVER SAVE) or SCC07 or SCC0700 (REOPEN I/C) */
/**/
             CHGVAR     VAR(&DATAQN)     VALUE('SCC2470MON')
             CHGVAR     VAR(&DATAQE)     VALUE('SCC2470END')
/**/
/* Remove the STOP message on SCC2470END placed there by SCC0401 */
/**/
             CHGVAR     VAR(&WAIT) VALUE(1)
             CHGVAR     VAR(&DLEN) VALUE(10)
             CHGVAR     VAR(&MESS) VALUE(' ')
             CALL       PGM(QRCVDTAQ) PARM(&DATAQE &XLIB &DLEN &MESS +
                          &WAIT)
             CHGVAR     VAR(&WAIT) VALUE(60)
 
LOOP:
/**/
/* Receive the data Queue - if the entry is 'STOP' then exit the program */
/**/
             CHGVAR     VAR(&DLEN) VALUE(10)
             CHGVAR     VAR(&MESS) VALUE(' ')
             CALL       PGM(QRCVDTAQ) PARM(&DATAQN &XLIB &DLEN &MESS +
                          &WAIT)
             IF         COND(%SST(&MESS 1 4) *EQ 'STOP') THEN(DO)
                 CHGVAR     VAR(&MESS) VALUE('STOP')
                 CHGVAR     VAR(&DLEN) VALUE(10)
                 CALL       PGM(QSNDDTAQ) PARM(&DATAQE &XLIB &DLEN &MESS)
                 RETURN
             ENDDO
/**/
/* Call SCC2470S to check if the journal receivers need saving */
/**/
             CALL       PGM(SCC2470SAV)
 
             GOTO       CMDLBL(LOOP)
/**/
/* Abnormal Termination */
/**/
ABNORMAL:
             CHGVAR     VAR(&MESS) VALUE('STOP')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&DLEN) VALUE(10)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CALL       PGM(QSNDDTAQ) PARM(&DATAQE &XLIB &DLEN &MESS)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program SCC2470MON ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDCLPGM:
             ENDPGM
