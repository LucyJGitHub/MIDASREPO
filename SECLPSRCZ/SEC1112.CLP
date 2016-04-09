/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Gen past due cust/depot posn events')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC1112 - Generate past due customer/depot position events  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 087177 *CREATE     Date 23MAY95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       087177 - Projected account movements                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,SEC1112INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Reset job switches */
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SEC1112MPS                                          */
 
/* Set the save library */
/**/
             RTVDTAARA DTAARA(SDSTAT)  RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
/**/
/* Send program message */
/**/
             CHGVAR     VAR(&MSG) VALUE('SEC1112 - Generate Past Due +
                          Customer/Depot Position Events')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/* Check for component restart */
/**/
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/**/
             IF         COND(&BUSY = 'Y') THEN(DO)
/**/
/* Override files */
/**/
                OVRDBF FILE(XDPEVED)  SEQONLY(*YES 100)
                OVRDBF FILE(XDPEVEA)  SEQONLY(*YES 1)
                OVRDBF FILE(XCPEVED)  SEQONLY(*YES 100)
                OVRDBF FILE(XCPEVEA)  SEQONLY(*YES 1)
/**/
/* and copy back original records of the files */
/**/
                CPYF       FROMFILE(XDPEVED) TOFILE(DPEVED) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(DPEVED))
/**/
                CPYF       FROMFILE(XDPEVEA) TOFILE(DPEVEA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(DPEVEA))
/**/
                CPYF       FROMFILE(XCPEVED) TOFILE(CPEVED) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(CPEVED))
/**/
                CPYF       FROMFILE(XCPEVEA) TOFILE(CPEVEA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                             FILE(CPEVEA))
/**/
/* Change data area to 'OLD' */
/**/
                CHGVAR     VAR(&BUSY) VALUE('N')
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/**/
             ENDDO
/**/
/* Save to be updated files to X(filename) */
/**/
             OVRDBF FILE(DPEVED) SEQONLY(*YES 100)
             OVRDBF FILE(DPEVEA) SEQONLY(*YES 1)
             OVRDBF FILE(CPEVED) SEQONLY(*YES 100)
             OVRDBF FILE(CPEVEA) SEQONLY(*YES 1)
             OVRDBF FILE(XDPEVED) SEQONLY(*YES 100)
             OVRDBF FILE(XDPEVEA) SEQONLY(*YES 1)
             OVRDBF FILE(XCPEVED) SEQONLY(*YES 100)
             OVRDBF FILE(XCPEVEA) SEQONLY(*YES 1)
/**/
             CPYF       FROMFILE(DPEVED) TOFILE(&TOLIB/XDPEVED) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XDPEVED))
/**/
             CPYF       FROMFILE(DPEVEA) TOFILE(&TOLIB/XDPEVEA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XDPEVEA))
/**/
             CPYF       FROMFILE(CPEVED) TOFILE(&TOLIB/XCPEVED) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCPEVED))
/**/
             CPYF       FROMFILE(CPEVEA) TOFILE(&TOLIB/XCPEVEA) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCPEVEA))
/**/
/* Change data area to 'NEW' */
/**/
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**/
/* Call program */
/**/
             CALL       PGM(SE1540)
/**/
/* If abnormal termination, goto ABNOR */
/**/
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(GOTO CMDLBL(ABNOR))
/**/
/* Normal completion  */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/* Change data area to 'OLD' */
/**/
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/**/
/* Delete copy files */
/**/
                DLTF       FILE(XDPEVED)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XDPEVEA)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XCPEVED)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XCPEVEA)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
/*/COPY WNCPYSRC,SEC1112MPE                                          */
 
             GOTO       CMDLBL(END)
/**/
 ABNOR:
/*/COPY WNCPYSRC,SEC1112ERR                                          */
/**/
/* For database error, recover data from LDA */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                MONMSG     MSGID(CPF0000 MCH0000)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                MONMSG     MSGID(CPF0000 MCH0000)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SEC1112 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/* End CL program  */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SEC1112END                                          */
 
             ENDPGM
