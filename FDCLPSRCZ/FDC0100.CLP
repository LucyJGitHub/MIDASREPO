/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FD Menu option control')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas   - FD Module                                         */
/*                                                                   */
/*       FDC0100 - FD Menu Option Control                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG1056            Date 21May04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CAP058  *CREATE    Date 13Jul00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG1056 - Add OVRDBF FWDRT SHARE(*NO). Related to CSC022    */
/*                 Commitment Control Changes.                       */
/*       CAP058 - Midas API, Money Market Interest Rates             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10) /* +
                          Return code for call to ZAGETACTGP */
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10) /* The +
                          activation group that the called program +
                          runs in */
 
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
             GOTO       CMDLBL(RUN)
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
             RETURN
 
RUN:
 
/* RESET THE JOB SWITHCHES */
             CHGJOB     SWS(XXXXXX00)
 
/* CALL PROGRAM  */
 
             OVRDBF     FILE(FWDRT) SHARE(*NO)                                           /*BUG1056*/
             CALL       PGM(&PROG)
             DLTOVR     FILE(FWDRT)                                                      /*BUG1056*/
 
/** +
    Destroy the activation group used by the program, and ensure +
    that no files were left open in OPM programs called from it. +
    First retrieve the name of the activation group that the +
    program runs in. +
**/
             CALL       PGM(ZAGETACTGP) PARM(&RETURNCODE &ACTGRP &PROG)
 
             IF         COND(&RETURNCODE = ' ') THEN(DO)
                RCLACTGRP  ACTGRP(&ACTGRP)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             RCLRSC
 
 /* IF U7 AND U8 ARE ON SEND DATA BASE ERROR MESSAGE TO MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ)
 
/*  CALL SCC0010 TO SEND ABNORMAL TERMINATION SCREEN */
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
                CALL       PGM(SCC0010) PARM('FDC0100' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
             ENDDO
 
             RCLRSC
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
