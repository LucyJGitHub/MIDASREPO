/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Upgrade Utility 2 (SAR is on)')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Funds Transfer Module                               */
/*                                                                   */
/*       FTC0014 - FT Upgrade Utility 2 (SAR is on)                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Prev Amend No. CFT014  *CREATE    Date 25May00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CFT014 - Straight-through Processing Phase 2 MT103          */
/*                Messages Generation for FT.                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTNCDE &IPMODE)
 
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&SYSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD LOCAL DATA AREA +
                          EQUIVALENT') AUT(*USE))
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/** Send program message to MRUNQ that this component is running. */
 
             SNDPGMMSG  MSG('FTC0014 - FT Upgrade Utility 2 (SAR is +
                          on)') TOMSGQ(MRUNQ)
 
/** Mode 1 - Calling program for the first time                      */
 
             IF         COND(&IPMODE = '1') THEN(DO)
 
/** Retrieve System Id. */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *CAT 'DPLIB')
 
/** Create back-up for error proccessing. */
 
             CPYF       FROMFILE(INPAYDD) TOFILE(&DPLIB/XINPAYDD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XINPAYDD))
             CPYF       FROMFILE(INPAYXPD) TOFILE(&DPLIB/XINPAYXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XINPAYXPD))
             CPYF       FROMFILE(OTPAYXPD) TOFILE(&DPLIB/XOTPAYXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XOTPAYXPD))
 
/** Call FT0014. */
 
             CALL       PGM(FT0014)
 
/** Destroy the activation group used by the program.            */
/** First, retrieve the name of the activation group that the    */
/** program runs in.                                             */
 
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
/** Database error processing. */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             CPYF       FROMFILE(XINPAYDD) TOFILE(INPAYDD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(INPAYDD))
             CPYF       FROMFILE(XINPAYXPD) TOFILE(INPAYXPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(INPAYXPD))
             CPYF       FROMFILE(XOTPAYXPD) TOFILE(OTPAYXPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(OTPAYXPD))
                GOTO       CMDLBL(END)
             ENDDO
 
/** No Database Error. */
 
             SNDPGMMSG  MSG('FTC0014 - FT Upgrade Utility 2 (SAR is +
                          on) completed normally') TOMSGQ(MRUNQ)
 
             DLTF       FILE(XINPAYDD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XINPAYXPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(XOTPAYXPD)
             MONMSG     MSGID(CPF0000)
 
             GOTO       CMDLBL(END)
 
             ENDDO
 
/** Mode 2 - Re-calling program if already previously used           */
 
             IF         COND(&IPMODE = '2') THEN(DO)
               CHGJOB     SWS(XXXXXX00)
               GOTO       CMDLBL(END)
             ENDDO
 
/** Mode 3 - Switching off the SAR                                   */
 
             IF         COND(&IPMODE = '3') THEN(DO)
               CHGJOB     SWS(XXXXXX00)
               GOTO       CMDLBL(END)
             ENDDO
 
 ABNOR:
             DMPCLPGM
             CPYF       FROMFILE(XINPAYDD) TOFILE(INPAYDD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(INPAYDD))
             CPYF       FROMFILE(XINPAYXPD) TOFILE(INPAYXPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(INPAYXPD))
             CPYF       FROMFILE(XOTPAYXPD) TOFILE(OTPAYXPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(OTPAYXPD))
             CHGJOB     SWS(XXXXXX11)
 
/** Abnormal termination - batch job. */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                            MSGDTA('Program FTC0014 ended +
                            abnormally - see job log') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
