/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Cheque Book Reorganisation')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4219 - Cheque Book Reorganisation                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 096490             DATE 28NOV95              */
/*       PREV AMEND NO. CRT001  *CREATE    DATE 28FEB95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       096490 - Remove creation parameters which were adopting the */
/*                owners user profile.                               */
/*                Use the standard CLP creation parameters instead.  */
/*       CRT001 - Retail Teller System.                              */
/*                                                                   */
/*********************************************************************/
 
             PGM PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&RSEQ)    TYPE(*CHAR)  LEN(5)
             DCL        VAR(&RLEV)    TYPE(*CHAR)  LEN(1)
             DCL        VAR(&RENT)    TYPE(*CHAR)  LEN(3)
             DCL        VAR(&RPARM)   TYPE(*CHAR)  LEN(100)
             DCL        VAR(&CODT)    TYPE(*CHAR)  LEN(6)
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)  VALUE(' ')
             DCL        VAR(&MSGDTA)  TYPE(*CHAR)  LEN(50)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
 
 
/**  Global monitor message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(+
                        GOTO ABNOR)
 
 
 
/**  Send program message */
 
             CHGJOB     SWS(00000000)
 
             SNDPGMMSG  MSG('CHEQUE BOOK REORGANISATION ') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/**/
/*  COB recovery processing  */
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
/**/
             CALL          PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/
             IF         COND(&STAT *EQ 'N') THEN(DO)
             CPYF       FROMFILE(CHQBKPD) TOFILE(&TOLIB/XCHQBKPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCHQBKPD))
             CPYF       FROMFILE(CHQBKPT) TOFILE(&TOLIB/XCHQBKPT) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XCHQBKPT))
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
             ELSE       CMD(DO)
             CPYF       FROMFILE(XCHQBKPD) TOFILE(CHQBKPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CHQBKPD))
             CPYF       FROMFILE(XCHQBKPT) TOFILE(CHQBKPT) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(CHQBKPT))
             ENDDO
 
/**  Call the program */
 
             CHGVAR     VAR(&CODT)  VALUE(%SUBSTRING(&RPARM 1 6))
 
             CALL       PGM(RE4219) PARM(&CODT)
 
/**/
/* Reset value of restart flag to 'N' */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             DLTF       FILE(XCHQBKPD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(XCHQBKPT)
             MONMSG     MSGID(CPF2105)
             ENDDO
 
/**  For database errors, recover data from LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
 
/**  For file imbalance error */
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 171 10))
             SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
 
/**  For invalid cut-off date as parameter */
 
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
             SNDPGMMSG  MSGID(USR0143) MSGF(RTSMSGF) MSGDTA(&CODT) +
                          TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4219 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/**  End of program */
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
 
