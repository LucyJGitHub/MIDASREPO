/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Update Customer Fiscal Average Prices')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC0606L - Midas SE Update Customer Fiscal Average Prices   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL031  *CREATE    Date 05Jul04              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL031 - Taxation of Savings Income                         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(75)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
             DCL        VAR(&SDSTAT)  TYPE(*CHAR)  LEN(256)
 
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
/* Setup and Send Pgm Message                                       */
 
             CHGVAR     VAR(&MSG) VALUE('SEC0606L - SE UPDATE +
                          CUSTOMER FISCAL AVERAGE PRICES')
 
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* Set Off Switches                                                 */
 
             CHGJOB     SWS(00000000)
 
/* Check For Component Restart                                      */
 
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* If Restart, Copy Files                                           */
 
             IF COND(&BUSY = 'Y') THEN(DO)
 
                CPYF       FROMFILE(XCAPRHD) TOFILE(CAPRHD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(CAPRHD))
 
                CPYF       FROMFILE(XCAPRHA) TOFILE(CAPRHA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(CAPRHA))
 
                CPYF       FROMFILE(XCPOSND) TOFILE(CPOSND) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(CPOSND))
 
                CPYF       FROMFILE(XCPOSNA) TOFILE(CPOSNA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(CPOSNA))
 
 
/* Change Data Area                                                 */
 
                CHGVAR     VAR(&BUSY) VALUE('N')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
 
             ENDDO
 
/* Else Backup Files                                                */
 
             ELSE       CMD(DO)
 
/* Delete Copy Files                                                */
 
                DLTF       FILE(XCAPRHD)
                MONMSG MSGID(CPF0000)
                DLTF       FILE(XCAPRHA)
                MONMSG MSGID(CPF0000)
                DLTF       FILE(XCPOSNA)
                MONMSG MSGID(CPF0000)
 
                CPYF       FROMFILE(CAPRHD) TOFILE(&TOLIB/XCAPRHD)  +
                            MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(XCAPRHD))
 
                CPYF       FROMFILE(CAPRHA) TOFILE(&TOLIB/XCAPRHA)  +
                            MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(XCAPRHA))
 
                CPYF       FROMFILE(CPOSND) TOFILE(XCPOSND) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(XCPOSND))
 
                CPYF       FROMFILE(CPOSNA) TOFILE(&TOLIB/XCPOSNA) +
                            MBROPT(*REPLACE) CRTFILE(*YES) +
                            FMTOPT(*NONE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(XCPOSNA))
 
             ENDDO
 
/* Change Data Area To 'NEW'                                        */
 
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/* Call Program To Extract Today's Customer Average Prices          */
 
                CALL       PGM(SE2405A)
 
/* If No Errors Call Program To Update Customer Average Prices      */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CALL       PGM(SE2410A)
             ENDDO
 
/* For Database Errors Recover Date From LDA                        */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0606L - JOB TERMINATED, +
                           DATABASE IN ERROR')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* For File Imbalance Error                                         */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR     VAR(&MEM) VALUE('SEC0606F - FILE CONTROLS OUT +
                           OF BALANCE')
                SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* Normal Completion - Clear Output Files                           */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Change Data Area To 'OLD'                                        */
 
                CHGVAR    VAR(&BUSY) VALUE('N')
                CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)
 
                CLRPFM     FILE(XCPOSND)
 
                RCLRSC
 
/* Delete Copy Files                                                */
 
                DLTF       FILE(XCAPRHD)
                MONMSG MSGID(CPF0000)
                DLTF       FILE(XCAPRHA)
                MONMSG MSGID(CPF0000)
                DLTF       FILE(XCPOSNA)
                MONMSG MSGID(CPF0000)
 
             ENDDO
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
