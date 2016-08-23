/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL CGL013 Initialisation Program')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Funds Transfer Module                               */
/*                                                                   */
/*       GLC001450 - GL CGL013  Upgrade Utility                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL013  *CREATE    Date 25May02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL013 - MT94x Messages Generation                          */
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
                          Misys International Banking Systems Ltd. +
                          2002')
 
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
 
             SNDPGMMSG  MSG('GLC001450 - CGL013 Upgrade Utility') +
                           TOMSGQ(MRUNQ)
 
/** Mode 1 - Calling program for the first time                      */
 
             IF         COND(&IPMODE = '1') THEN(DO)
 
/** Retrieve System Id. */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DPLIB) VALUE(&SYSID *CAT 'DPLIB')
 
/** Create back-up for error proccessing. */
 
             CPYF       FROMFILE(SDNWRKPD) TOFILE(&DPLIB/XSDNWRKPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSDNWRKPD))
/** Clear new files */
             CLRPFM     GLNWACPD
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CLRPFM     GLNW94PD
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CLRPFM     GLPOSTPD
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/** Call GL001450. */
 
             CALL       PGM(GL001450)
 
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
             CPYF       FROMFILE(XSDNWRKPD) TOFILE(SDNWRKPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSDNWRKPD))
                GOTO       CMDLBL(END)
             ENDDO
 
/** No Database Error. */
 
             SNDPGMMSG  MSG('GLC001450 - CGL013 Upgrade Utility +
                          completed normally') TOMSGQ(MRUNQ)
 
             DLTF       FILE(XSDNWRKPD)
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
             CPYF       FROMFILE(XSDNWRKPD) TOFILE(SDNWRKPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SDNWRKPD))
             CHGJOB     SWS(XXXXXX11)
 
/** Abnormal termination - batch job. */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                            MSGDTA('Program GLC001450 ended +
                            abnormally - see job log') TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             RCLRSC
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
