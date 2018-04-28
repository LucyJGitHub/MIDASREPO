/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Update next coupon date on securities')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC1030 - Update Next Coupon Date on Securities File        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CSE031 *CREATE     Date 09Nov01              */
/*       Prev Amend No.                    Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE031 - Coupon Fixing for Floating Rate Notes              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare Variables */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(52)
             DCL        VAR(&PRESBS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' '))
 
/* Reset Switches */
 
             CHGJOB     SWS(00000000)
 
             SNDPGMMSG  MSG('SEC1030 - Update Next Coupon Date on +
                          Securities file') TOMSGQ(MRUNQ)
 
/* Do Security Copies */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRESBS)
             CHGVAR     VAR(&TOLIB) VALUE(&PRESBS *TCAT 'DPLIB')
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)
 
/* If Restart, Take Security Copies */
 
             IF         COND(&STATUS = 'Y') THEN(DO)
 
                CPYF       FROMFILE(&TOLIB/XSECTYD) TOFILE(SECTYD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                             EXEC(CLRPFM FILE(SECTYD))
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
 
                DLTF       FILE(XSECTYD)
                MONMSG     MSGID(CPF0000)
 
/* Backup File */
 
                CPYF       FROMFILE(SECTYD) TOFILE(&TOLIB/XSECTYD) +
                             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
                CHGVAR     VAR(&STATUS) VALUE('Y')
 
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
             ENDDO
 
/* Call RPG/SE1030 - Update Next Coupon Date on Securities file */
 
             CALL       PGM(SE1030)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
 
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
 
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
                CHGVAR     VAR(&MEM) VALUE('SEC1030 - JOB TERMINATED, +
                             DATABASE IN ERROR')
 
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
 
                GOTO       CMDLBL(ABNOR)
 
             ENDDO
 
/* Change component status */
 
             CHGVAR     VAR(&STATUS) VALUE('N')
 
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
             DLTF       FILE(&TOLIB/XSECTYD)
 
             MONMSG     MSGID(CPF0000)
 
             RCLRSC
 
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
             CHGVAR     VAR(&CPYFLD) VALUE('Copyright +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
