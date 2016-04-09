/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE menu option control')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas   -  Securities Module                                */
/*                                                                   */
/*       SEC001  -  Calls entry module SEPRCSSIN                     */
/*                  Securities Prices input for market data feed     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 214817             Date 28Mar03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CAP060  *CREATE    Date 25Oct00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       214817 - Not able to '?' on security field. Fix is to call  */
/*                pgm SE0043 if '?' entered here. Need to issue      */
/*                ovrdbf on SECTYZ1 and SECTYZ2.                     */
/*       CAP060 - Midas APIs, Security Prices Full API               */
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
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)
/* Extel Indicator */
             DCL        VAR(&EX) TYPE(*LGL)
/* Extel Status */
             DCL        VAR(&EXST) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10) /* +
                          Return code for call to ZAGETACTGP */
             DCL        VAR(&ACTGRP) TYPE(*CHAR) LEN(10) /* The +
                          activation group that the called program +
                          runs in */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*214817*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*214817*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*214817*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*214817*/
             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1)                                   /*214817*/
 
/* Monitor for error messages not trapped in the rest of the */
/* program. If they occur reclaim resources and exit.        */
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ERR))
                                                                                          /*214817*/
/**  Check if Transaction Enhancements is installed */                                    /*214817*/
                                                                                          /*214817*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*214817*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*214817*/
             CHGVAR     VAR(&SAR) VALUE('CSE010')                                         /*214817*/
             CHGVAR     VAR(&CSE010) VALUE('N')                                           /*214817*/
                                                                                          /*214817*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*214817*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*214817*/
                CHGVAR     VAR(&CSE010) VALUE('Y')                                        /*214817*/
             ENDDO                                                                        /*214817*/
             GOTO       CMDLBL(RUN)
ERR:
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
             RETURN
 
RUN:
 
/* RESET THE JOB SWITCHES */
             CHGJOB     SWS(XXXXXX00)
 
/* Check if EXTEL option is on                                       */
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
             CHGVAR     VAR(&EX) VALUE(%SST(&SESTAT 63 1) *EQ 'Y')
 
             IF         COND(&EX) THEN(DO)
 
/* Check EXTEL link status */
             RTVDTAARA  DTAARA(EXSTAT (76 1)) RTNVAR(&EXST)
                IF         COND((&EXST *NE 'A') *AND (&EXST *NE 'T') +
                          *AND (&EXST *NE 'C') *AND (&EXST *NE +
                          'F')) THEN(DO)
                   SNDPGMMSG  MSG('Option unavailable - EXTEL processing +
                             not complete') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
                OVRDBF     FILE(PRICEX) TOFILE(PRICE) SHARE(*NO)
                OVRDBF     FILE(EXVALDX) TOFILE(EXVALD) SHARE(*NO)
 
             IF         COND(&CSE010 *EQ 'Y') THEN(DO)                                    /*214817*/
                OVRDBF     FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)                         /*214817*/
                OVRDBF     FILE(SECTYZ2) TOFILE(SECTY) SHARE(*NO)                         /*214817*/
             ENDDO                                                                        /*214817*/
/* Call  Program */
 
             CALL PGM(&PROG)
 
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
             CALL       PGM(SCC0010) PARM('GLC1' 'ENTER' &NOREPLY)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                ROLLBACK
             ENDDO
 
             RCLRSC
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 END:        ENDPGM
