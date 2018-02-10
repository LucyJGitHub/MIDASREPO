/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Menu Option Control Program')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC0011 - PM Menu Option Control                            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CAP033  *CREATE    Date 26Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP033 - Conversion of PM inputs into modular structure to  */
/*                use as APIs.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Return code for call to ZAGETACTGP */
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)
 
/** The activation group that the called program runs in */
 
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10)
 
/** Monitor for error messages not trapped in the rest of the */
/** program.  If they occur, reclaim resources and exit.      */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
             GOTO       CMDLBL(RUN)
 
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
             RETURN
 
RUN:
 
/** Reset job switches. */
 
             CHGJOB     SWS(XXXXXX00)
 
/** Override files. */
 
             OVRDBF     FILE(PMPORTPD) SHARE(*NO)
             OVRDBF     FILE(PMPORTL0) SHARE(*NO)
 
             IF         COND(&PROG = 'PMPFDMSIN') THEN(DO)
                OVRDBF     FILE(PMCHRGPD) SHARE(*NO)
             ENDDO
 
/** Call program. */
 
             CALL       PGM(&PROG)
 
/** Delete overrides. */
 
             DLTOVR     FILE(PMPORTPD)
             DLTOVR     FILE(PMPORTL0)
 
             IF         COND(&PROG = 'PMPFDMSIN') THEN(DO)
                DLTOVR     FILE(PMCHRGPD)
             ENDDO
 
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
                CALL       PGM(SCC0010) PARM('PMC0011' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
 
             ENDDO
 
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
