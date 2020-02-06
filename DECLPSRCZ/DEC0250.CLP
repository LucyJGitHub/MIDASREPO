/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Purge Generic Files')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0250 - DE Purge Generic Files Controller                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDE005             Date 22Aug02              */
/*                      CDE003             Date 11Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CDE004  *CREATE    Date 02Jul01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDE005 - Data Export - Reservation ID (Re-compile)          */
/*       CDE003 - Data Export - MCR Limits Phase II (Recompiled)     */
/*       CDE004 - Cross Modular History Extract                      */
/*                                                                   */
/*********************************************************************/
             PGM   PARM(&CNAM &CSEQ &TTYP)
 
             DCL        VAR(&TTYP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYST) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0250 - DE Purge Generic Files +
                          Controller') TOMSGQ(MRUNQ)
 
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             MONMSG     MSGID(CPF1015) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
             CHGJOB SWS(00000000)
 
/* Set up susbsytem data */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYST)
             CHGVAR     VAR(&DPLIB) VALUE(&SYST *CAT 'DPLIB')
 
/* Check for component restart                */
 
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If Restart copy file to back up copy    */
 
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&DPLIB/XDEGTRANPD) +
                          TOFILE(DEGTRANPD) FROMMBR(&TTYP) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DEGTRANPD) MBR(&TTYP))
 
             CPYF       FROMFILE(&DPLIB/XDEGPOSNPD) +
                          TOFILE(DEGPOSNPD) FROMMBR(&TTYP) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DEGPOSNPD) MBR(&TTYP))
 
             CPYF       FROMFILE(&DPLIB/XDEGEVNTPD) +
                          TOFILE(DEGEVNTPD) FROMMBR(&TTYP) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DEGEVNTPD) MBR(&TTYP))
 
             CPYF       FROMFILE(&DPLIB/XDEGVALUPD) +
                          TOFILE(DEGVALUPD) FROMMBR(&TTYP) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(DEGVALUPD) MBR(&TTYP))
 
             ENDDO
             ELSE       CMD(DO)
             CPYF       FROMFILE(DEGTRANPD) +
                          TOFILE(&DPLIB/XDEGTRANPD) FROMMBR(&TTYP) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XDEGTRANPD) MBR(&TTYP))
 
             CPYF       FROMFILE(DEGPOSNPD) +
                          TOFILE(&DPLIB/XDEGPOSNPD) FROMMBR(&TTYP) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XDEGPOSNPD) MBR(&TTYP))
 
             CPYF       FROMFILE(DEGEVNTPD) +
                          TOFILE(&DPLIB/XDEGEVNTPD) FROMMBR(&TTYP) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XDEGEVNTPD) MBR(&TTYP))
 
             CPYF       FROMFILE(DEGVALUPD) +
                          TOFILE(&DPLIB/XDEGVALUPD) FROMMBR(&TTYP) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XDEGVALUPD) MBR(&TTYP))
             ENDDO
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
             OVRDBF     FILE(DEGTRANL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEGPOSNL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEGEVNTL1) MBR(&TTYP) SHARE(*NO)
             OVRDBF     FILE(DEGVALUL1) MBR(&TTYP) SHARE(*NO)
 
/** Call the program **/
 
             CALL       PGM(DEPURGETR) PARM(&TTYP)
 
             IF COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(ABNOR))
             ELSE (DO)
                DLTF       FILE(XDEGTRANPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XDEGPOSNPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XDEGEVNTPD)
                MONMSG     MSGID(CPF0000)
                DLTF       FILE(XDEGVALUPD)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DEC0250 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
