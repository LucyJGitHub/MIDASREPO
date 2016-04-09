/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD menu option control - customer details')     */
/*********************************************************************/
/*                                                                   */
/*       Midas   - Standing Data Module                              */
/*                                                                   */
/*       SDC1    - SD MENU OPTION CONTROL                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CRE026             Date 24May06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSD028             Date 22Aug04              */
/*                      BUG3362            Date 28Jul04              */
/*                      CGP001             Date 23May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CAP034  *Create    Date 12JUL99              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE026 - Consumer Banking                                   */
/*       CSD028 - KYC (Standing Data Authorisations )                */
/*       BUG3362 - Added override on SDTICSLR.                       */
/*       CGP001 - Global Processing                                  */
/*       CAP034 - Conversion of Midas inputs to modular API structure*/
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
 
             OVRDBF     FILE(SDCUSTLR) TOFILE(SDCUSTL0) SHARE(*NO)
             OVRDBF     FILE(SDCBRTLR) TOFILE(SDCBRTL1) SHARE(*NO)
             OVRDBF     FILE(PTYHSTPR) TOFILE(PTYHSTPD) SHARE(*NO)
             OVRDBF     FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
             OVRDBF     FILE(SDTICSLR) TOFILE(SDTICSL0) SHARE(*NO)                       /*BUG3362*/
             OVRDBF     FILE(GPCUSTXLR) TOFILE(GPCUSTXL0) SHARE(*NO)                      /*CGP001*/
             OVRDBF     FILE(SDCMRKLR) TOFILE(SDCMRKL1) SHARE(*NO)                        /*CRE026*/
             OVRDBF     FILE(SDACUSLR) TOFILE(SDACUSL1) SHARE(*NO)                        /*CRE026*/
             OVRDBF     FILE(SDCFCDLR) TOFILE(SDCFCDL1) SHARE(*NO)                        /*CRE026*/
             OVRDBF     FILE(SDCHEQLR) TOFILE(SDCHEQL1) SHARE(*NO)                        /*CRE026*/
             OVRDBF     FILE(SDCRWALR) TOFILE(SDCRWAL1) SHARE(*NO)                        /*CRE026*/
             OVRDBF     FILE(SDFOCSLR) TOFILE(SDFOCSL1) SHARE(*NO)                        /*CRE026*/
             OVRDBF     FILE(SDPLCSLR) TOFILE(SDPLCSL0) SHARE(*NO)                        /*CRE026*/
             OVRDBF     FILE(SDFOX1LR) TOFILE(SDFOX1L0) SHARE(*NO)                        /*CRE026*/
             OVRDBF     FILE(SDCUX2LR) TOFILE(SDCUX2L0) SHARE(*NO)                        /*CRE026*/
             OVRDBF     FILE(SDCUX1LR) TOFILE(SDCUX1L0) SHARE(*NO)                        /*CRE026*/
 
/* CALL PROGRAM  */
                                                                                          /*CSD028*/
             IF         COND(&PROG = 'SDCUSDSIN ') THEN(DO)
             CALL       PGM(&PROG) PARM(' ' ' ')                                          /*CSD028*/
             ENDDO
             ELSE       CMD(DO)                                                           /*CSD028*/
 
             CALL PGM(&PROG)
 
             ENDDO                                                                        /*CSD028*/
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
                CALL       PGM(SCC0010) PARM('FXC0011' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
             ENDDO
 
             RCLRSC
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
