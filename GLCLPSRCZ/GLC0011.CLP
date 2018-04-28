/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Menu Option Control Program')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC0011 - GL Menu Option Control                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CGL011  *CREATE    Date 20Sep99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CGL011 - Collateral Processing for Midas (Phase 1)          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG &PENQ)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PENQ) TYPE(*CHAR) LEN(1)
 
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
 
             IF         COND(&PROG = 'GLCOLLSIN') THEN(DO)
             OVRDBF     FILE(FOCLTLXX) TOFILE(FOCLT) SHARE(*NO)
             OVRDBF     FILE(FCLTYLXX) TOFILE(FCLTY) SHARE(*NO)
             OVRDBF     FILE(CLOANLXX) TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(GLCOLLX1) TOFILE(GLCOLLL1) SHARE(*NO)
             OVRDBF     FILE(GLCOLAX0) TOFILE(GLCOLAL0) SHARE(*NO)
             ENDDO
 
/** Call program. */
 
             CALL       PGM(&PROG) PARM(&PENQ)
 
/** Delete overrides. */
 
             IF         COND(&PROG = 'GLCOLLSIN') THEN(DO)
             DLTOVR     FILE(FOCLTLXX)
             DLTOVR     FILE(FCLTYLXX)
             DLTOVR     FILE(CLOANLXX)
             DLTOVR     FILE(GLCOLLX1)
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
                CALL       PGM(SCC0010) PARM('GLC0011' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
 
             ENDDO
 
             RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
