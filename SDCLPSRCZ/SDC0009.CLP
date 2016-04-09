/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Initialisation program for CSD009')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data                                       */
/*                                                                   */
/*       SDC0009 - Midas SD Initialisation program for CSD009        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*       Last Amend No. CSD009  *CREATE    Date 10Oct00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD009 - PCA Default Matrix Enhancement                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
 
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&LIB) VALUE(&PREF *TCAT 'DPLIB')
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(*LIBL/SDPRFMPD) +
                          TOFILE(&LIB/XSDPRFMPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CPYF       FROMFILE(*LIBL/SDGELRPD) +
                          TOFILE(&LIB/XSDGELRPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CALL       PGM(SD0009) PARM(&PMODE)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                CPYF       FROMFILE(&LIB/XSDPRFMPD) TOFILE(SDPRFMPD) +
                             MBROPT(*REPLACE)
                CPYF       FROMFILE(&LIB/XSDGELRPD) TOFILE(SDGELRPD) +
                             MBROPT(*REPLACE)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
 
 /* Send the error message */
 
             SNDPGMMSG  MSG('Program SDC0009 ended abnormally') +
                          TOMSGQ(MOPERQ)
 
 END:        DLTF       FILE(&LIB/XSDPRFMPD)
             DLTF       FILE(&LIB/XSDGELRPD)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
