/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Initialisation utility for CFT009')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Funds Transfer Module                               */
/*                                                                   */
/*       FTC0009 - FT Initialisation Utility for CFT009 (SAR is on)  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Prev Amend No. CFT009  *CREATE    Date 28Mar01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CFT009 - Funds Transfer Fees and Charges                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&S01499)  TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CFT010)  TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&S01501)  TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CFT011)  TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD Local data area +
                          equivalent') AUT(*USE))
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Send program message to MRUNQ that this utility is running */
 
             SNDPGMMSG  MSG('FTC0009 - FT Initialisation Utility for +
                          CFT009') TOMSGQ(MRUNQ)
 
/* Retrieve System Id */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *CAT 'DPLIB')
 
 
/* Create back-up for error proccessing */
 
             CPYF       FROMFILE(INPAYXPD) TOFILE(&DPLIB/XINPAYXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XINPAYXPD))
 
             CPYF       FROMFILE(OTPAYXPD) TOFILE(&DPLIB/XOTPAYXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XOTPAYXPD))
 
/* Call FT0009 */
 
             IF         COND(&PMODE *EQ '1') THEN(DO)
                CALL       PGM(FT0009) PARM(&PMODE)
             ENDDO
 
             IF         COND(&PMODE *EQ '2') THEN(DO)
                CALL       PGM(FT0009) PARM(&PMODE)
             ENDDO
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                CPYF       FROMFILE(XINPAYXPD) TOFILE(INPAYXPD) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(INPAYXPD))
                CPYF       FROMFILE(XOTPAYXPD) TOFILE(OTPAYXPD) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(OTPAYXPD))
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* No Database Error */
 
/* Destroy the activation group used by the program             */
/* First, retrieve the name of the activation group that the    */
/* program runs in                                              */
 
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
/* Check switchable features file */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('S01499')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01499) VALUE('Y'))
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CFT010')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CFT010) VALUE('Y'))
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('S01501')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01501) VALUE('Y'))
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CFT011')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CFT011) VALUE('Y'))
 
/* Show warning if S01499 and CFT009 is installed,  */
/* but CFT010 isn't                                 */
 
             IF         COND(&S01499 = 'Y' *AND &CFT010 = 'N') THEN(DO)
                SNDPGMMSG  MSG('Warning: S01499 and CFT009 are +
                             installed but CFT010 isn''t') TOMSGQ(MOPERQ)
                RTVMSG     MSGID(SCM0093) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (121 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(SCM0094) MSGF(MIDASMSG) MSGDTA('S01499 +
                             VAT on Old Charges') MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (221 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(SCM0095) MSGF(MIDASMSG) MSGDTA('CFT009 +
                          Funds Transfer Fees & Charges') MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(SCM0096) MSGF(MIDASMSG) MSGDTA('CFT010 +
                             FT Fees & Charges with VAT') MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('FTC0009' 'ENTER' &NOREPLY)
             ENDDO
 
/* Show warning if CFT010 and S01501 is installed,  */
/* but CFT011 isn't                                 */
 
             IF         COND(&CFT010 = 'Y' *AND &S01501 = 'Y' *AND +
                          &CFT011 = 'N') THEN(DO)
                SNDPGMMSG  MSG('Warning: CFT010 and S01501 are +
                             installed but CFT011 isn''t') TOMSGQ(MOPERQ)
                RTVMSG     MSGID(SCM0093) MSGF(MIDASMSG) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (121 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(SCM0094) MSGF(MIDASMSG) MSGDTA('CFT010 +
                             FT Fees & Charges w/ VAT') MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (207 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(SCM0095) MSGF(MIDASMSG) MSGDTA('S01501 +
                             Old VAT Accounting') MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (255 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(SCM0096) MSGF(MIDASMSG) MSGDTA('CFT011 +
                             New VAT Accounting') MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (305 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('FTC0009' 'ENTER' &NOREPLY)
             ENDDO
 
/* Program completed */
 
             SNDPGMMSG  MSG('FTC0009 - FT Initialisation Utility +
                          completed normally') TOMSGQ(MRUNQ)
 
             DLTF       FILE(XINPAYXPD)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(XOTPAYXPD)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
 ABNOR:
             DMPCLPGM
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FTC0009 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
