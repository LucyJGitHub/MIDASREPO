/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE FRN/mortgage rate change generation ctl')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC2105 - FRN/Mortgage Rate Change Generation Control       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSE031 *C *CREATE  Date 09Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CSE031 - Coupon Fixing for Floating Rate Notes              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)
 
/* Declare Variables */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&PRESBS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
/* Reset Switches */
 
             CHGJOB     SWS(00000000)
 
             SNDPGMMSG  MSG('SEC2105 - FRN/Mortgage Rate Change +
                          Generation Ctl') TOMSGQ(MRUNQ)
 
/* Do Security Copies */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRESBS)
 
             CHGVAR     VAR(&TOLIB) VALUE(&PRESBS *TCAT 'DPLIB')
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
/* Override to SEQONLY(*YES 100) */
 
             OVRDBF     FILE(XSECTYD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSEDEVD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSEDEVA) SEQONLY(*YES 100)
 
             OVRDBF     FILE(SECTYD) SEQONLY(*YES 100)
             OVRDBF     FILE(SEDEVD) SEQONLY(*YES 100)
             OVRDBF     FILE(SEDEVA) SEQONLY(*YES 100)
 
/* If Restart, Take Security Copies */
 
             IF         COND(&STATUS = 'Y') THEN(DO)
 
                CPYF       FROMFILE(&TOLIB/XSECTYD) TOFILE(SECTYD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                             EXEC(CLRPFM FILE(SECTYD))
 
                CPYF       FROMFILE(&TOLIB/XSEDEVD) TOFILE(SEDEVD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                             EXEC(CLRPFM FILE(SEDEVD))
 
                CPYF       FROMFILE(&TOLIB/XSEDEVA) TOFILE(SEDEVA) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                             EXEC(CLRPFM FILE(SEDEVA))
 
                CPYF       FROMFILE(&TOLIB/XSESRNFPD) TOFILE(SESRNFPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                             EXEC(CLRPFM FILE(SESRNFPD))
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
 
                DLTF       FILE(XSECTYD)
                MONMSG     MSGID(CPF0000)
 
                DLTF       FILE(XSEDEVD)
                MONMSG     MSGID(CPF0000)
 
                DLTF       FILE(XSEDEVA)
                MONMSG     MSGID(CPF0000)
 
                DLTF       FILE(XSESRNFPD)
                MONMSG     MSGID(CPF0000)
 
/* Backup File */
 
                CPYF       FROMFILE(SECTYD) TOFILE(&TOLIB/XSECTYD) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
                CPYF       FROMFILE(SEDEVD) TOFILE(&TOLIB/XSEDEVD) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
                CPYF       FROMFILE(SEDEVA) TOFILE(&TOLIB/XSEDEVA) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
                CPYF       FROMFILE(SESRNFPD) TOFILE(&TOLIB/XSESRNFPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
                CHGVAR     VAR(&STATUS) VALUE('Y')
 
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
             ENDDO
 
             DLTOVR     FILE(XSECTYD XSEDEVD XSEDEVA)
 
             DLTOVR     FILE(SECTYD SEDEVD SEDEVA)
 
/* Call RPG/SE2150 - FRN/Mortgage Rate Change Generation */
 
             CALL       PGM(SE2105) PARM(&RSEQ)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
 
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
                CHGVAR     VAR(&MEM) VALUE('SEC2105 - JOB TERMINATED, +
                             DATABASE IN ERROR')
 
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
 
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Change component status */
 
             CHGVAR     VAR(&STATUS) VALUE('N')
 
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
             DLTF       FILE(&TOLIB/XSECTYD)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(&TOLIB/XSEDEVD)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(&TOLIB/XSEDEVA)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(&TOLIB/XSESRNFPD)
             MONMSG     MSGID(CPF0000)
 
             RCLRSC
 
/**********  RGZPFM     FILE(SESRNFPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('SESRNFPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
 
             DSPJOBLOG  OUTPUT(*PRINT)
             MONMSG     MSGID(CPF0000)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
