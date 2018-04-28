/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Menu option control')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas  - Securities Trading Module                          */
/*                                                                   */
/*       SEC023 - SE Menu Option Control                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. CAP137  *CREATE    Date 07Feb00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAP137 - Conversion of SE Security inputs into modular      */
/*                structure to use as APIs.                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG &RTNCD &ACTION &SESN &OSESN &OTHER +
                             &LINK)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(9)
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SESN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OSESN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OTHER) TYPE(*CHAR) LEN(156)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/** Return code for call to ZAGETACTGP */
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
 
/** The activation group that the called program runs in */
 
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10)
 
/** Monitor for error messages not trapped in the rest of the */
/** program.  If they occur, reclaim resources and exit.      */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERROR))
 
/** Reset job switches. */
 
             CHGJOB     SWS(XXXXXX00)
 
/** Override files. */
 
             OVRDBF     FILE(SECTY)    SHARE(*NO)
             OVRDBF     FILE(SECTYD)   SHARE(*NO)
 
/** Call program. */
 
             IF         COND(&PROG = 'SESECSSIN') THEN(DO)
                CALL       PGM(&PROG) PARM(&RTNCD &ACTION &SESN +
                                           &OSESN &OTHER &LINK)
             ENDDO
 
             ELSE (DO)
                CALL       PGM(&PROG)
             ENDDO
 
/** Delete overrides. */
 
             DLTOVR     FILE(SECTY)
             DLTOVR     FILE(SECTYD)
 
/** Destroy the activation group used by the program, and ensure */
/** that no files were left open in OPM programs called from it. */
/** First, retrieve the name of the activation group that the    */
/** program runs in.                                             */
 
             CALL       PGM(ZAGETACTGP) PARM(&RETURNCODE &ACTGRP &PROG)
 
             IF         COND(&RETURNCODE = ' ') THEN(DO)
                RCLACTGRP  ACTGRP(&ACTGRP)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             RCLRSC
 
/** For Database Errors, recover Data from LDA. */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ)
 
/** Call SCC0010 to send abnormal termination screen. */
 
                RTVMSG     MSGID(SCM0087) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                RTVMSG     MSGID(SCM0088) MSGF(MIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGDTAARA  DTAARA(MIDASMSG (3 1)) VALUE('1')
                MONMSG     MSGID(CPF0000 MCH0000)
                CALL       PGM(SCC0010) PARM('SEC023' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
 
             ENDDO
 
             GOTO       CMDLBL(ENDIS)
 
ERROR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
ENDIS:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
