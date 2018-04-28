/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Passbook Update Control File Reorg')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                   */
/*                                                                   */
/*       REC4204 - Passbook Update Control File Reorganisation       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. 199077             Date 23Oct01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 110973             Date 03Sep97              */
/*                      CRT001  *CREATE    Date 28Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       199077 - Correct PBUDCPD recovery procedure.                */
/*       110973 - Add *REPLACE option during CPYF from PBUDCP* files */
/*                to X* files so that it will not fail if X* files   */
/*                already exist during operation.                    */
/*       CRT001 - Retail Teller System                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSGDTA) TYPE(*CHAR)  LEN(50)
             DCL        VAR(&LDA)    TYPE(*CHAR)  LEN(256) VALUE(' ')
/**/
/*  Global monitor message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* SEND PGM MESSAGE */
/**/
             SNDPGMMSG  MSG('PASSBOOK UPDATE CONTROL FILE +
                          REORGANISATION') TOMSGQ(MRUNQ)
/**/
/* SET SWITCHES DEPENDING ON MODE */
/**/
             CHGJOB     SWS(00000000)
/**/
             RTVDTAARA DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
             CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/
             IF COND(&STAT *EQ 'N') THEN(DO)
/**/
/*********      CPYF    FROMFILE(PBUDCPH) TOFILE(&TOLIB/XPBUDCPH) +*/ /*110973*/
/*********                CRTFILE(*YES)                            */ /*110973*/
                CPYF    FROMFILE(PBUDCPH) TOFILE(&TOLIB/XPBUDCPH) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*110973*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPBUDCPH))
/*********      CPYF    FROMFILE(PBUDCPD) TOFILE(&TOLIB/XPBUDCPD) +*/ /*110973*/
/*********                CRTFILE(*YES)                            */ /*110973*/
                CPYF    FROMFILE(PBUDCPD) TOFILE(&TOLIB/XPBUDCPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)              /*110973*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XPBUDCPD))
                CHGVAR  VAR(&STAT) VALUE('Y')
                CALL    PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
/**/
             ELSE CMD(DO)
/**/
                CPYF    FROMFILE(&TOLIB/XPBUDCPH) TOFILE(PBUDCPH) +
                          MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PBUDCPH))
                CPYF    FROMFILE(&TOLIB/XPBUDCPD) TOFILE(PBUDCPD) +
                          MBROPT(*REPLACE)
/**********     MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PBUDCPH))                                                  /*199077*/
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(PBUDCPD))                                                  /*199077*/
             ENDDO
/**/
/* CALL THE PROGRAM */
/**/
                CALL    PGM(RE4204) PARM(&RSEQ)
/**/
/*   GOTO END OF CL IF U7 & U8 IS OFF.                         */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                        CHGVAR VAR(&STAT) VALUE('N')
                        CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
                        DLTF FILE(XPBUDCPH)
                        MONMSG MSGID(CPF2105)
                        DLTF FILE(XPBUDCPD)
                        MONMSG MSGID(CPF2105)
                        GOTO ENDPGM
                        ENDDO
/**/
/* FOR FILE IMBALANCE ERROR */
/**/
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR    VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/* FOR FILE IMBALANCE ERROR */
/**/
             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MSGDTA) VALUE(%SUBSTRING(&LDA 171 8))
                SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MSGDTA) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4204 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
