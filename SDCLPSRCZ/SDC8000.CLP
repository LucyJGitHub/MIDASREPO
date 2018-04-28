/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Menu option control for SD authorisation')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC8000 - SD Menu Option Control for SD Authorisation       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG6431            Date 01Apr05              */
/*       Prev Amend No. BUG4654            Date 04Nov04              */
/*                      BUG3362            Date 28Jul04              */
/*                      CSD012  *Create    Date 15Oct02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG6431 - CDL031 Authorisation Log problems                 */
/*       BUG4654 - Authorisation of Account input/amend/delete       */
/*                 is failing.                                       */
/*       BUG3362 - Added override for SDTICSL0.                      */
/*       CSD012 - Standing Data Authorisation                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PROG &ACT)
 
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
 
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
 
/* Reset the Job Switches */
 
             CHGJOB     SWS(XXXXXX00)
 
             OVRDBF     FILE(SDCUSTLR) TOFILE(SDCUSTL0) SHARE(*NO)
             OVRDBF     FILE(SDCBRTLR) TOFILE(SDCBRTL1) SHARE(*NO)
             OVRDBF     FILE(PTYHSTPR) TOFILE(PTYHSTPD) SHARE(*NO)
             OVRDBF     FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
             OVRDBF     FILE(SDTICSLR) TOFILE(SDTICSL0) SHARE(*NO)                       /*BUG3362*/
             OVRDBF     FILE(SDAULGL0) TOFILE(SDAULGL0) SHARE(*NO)
             OVRDBF     FILE(SDAULGL3) TOFILE(SDAULGL3) SHARE(*NO)
             OVRDBF     FILE(SDPBDSL0) TOFILE(SDPBDSL0) SHARE(*NO)
             OVRDBF     FILE(SDCUSTL0) TOFILE(SDCUSTL0) SHARE(*NO)
             OVRDBF     FILE(SDCBRTL0) TOFILE(SDCBRTL0) SHARE(*NO)
             OVRDBF     FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)
             OVRDBF     FILE(ACCNTL1) TOFILE(ACCNTL0) SHARE(*NO)
             OVRDBF     FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)
             OVRDBF     FILE(RECOMXX) TOFILE(RECOM) SHARE(*NO)
             OVRDBF     FILE(REAPWDL1) TOFILE(REAPWDL0) SHARE(*NO)
             OVRDBF     FILE(ACCBR) TOFILE(ACCBR) SHARE(*NO)
             OVRDBF     FILE(ACCNTBXC) TOFILE(ACCNTBXC) SHARE(*NO)
             OVRDBF     FILE(REIAC) TOFILE(REIAC) SHARE(*NO)
             OVRDBF     FILE(RECOM) TOFILE(RECOM) SHARE(*NO)
             OVRDBF     FILE(REAPWDL0) TOFILE(REAPWDL0) SHARE(*NO)
             OVRDBF     FILE(SDNOSTAU) TOFILE(SDNOSTL0) SHARE(*NO)
             OVRDBF     FILE(SDNOSHAU) TOFILE(SDNOSHL0) SHARE(*NO)
             OVRDBF     FILE(SDEXSTAU) TOFILE(SDEXSTL0) SHARE(*NO)
             OVRDBF     FILE(SDEXSHAU) TOFILE(SDEXSHL0) SHARE(*NO)
             OVRDBF     FILE(SDEXSTAX) TOFILE(SDEXSTLA) SHARE(*NO)                       /*BUG6431*/
             OVRDBF     FILE(SDEXSHAX) TOFILE(SDEXSHL2) SHARE(*NO)                       /*BUG6431*/
             OVRDBF FILE(REPWSHL0) TOFILE(REPWSHL0) SHARE(*NO)                           /*BUG4654*/
             STRCMTCTL  LCKLVL(*ALL) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                                 /*BUG4654*/
             MONMSG     MSGID(CPF0000)                                                   /*BUG4654*/
 
/* Call Prpgram */
 
             CALL PGM(&PROG) PARM(&ACT)
 
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
 
/* If U7 and U8 are on send Data Base error message to MOPERQ */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MSG)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MSG) +
                             TOMSGQ(MOPERQ)
 
/* Call SCC0010 to send abnormal termination screen */
 
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
