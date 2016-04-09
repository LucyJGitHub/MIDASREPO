/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Funding GAP Accrual Report')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounting Module                        */
/*                                                                   */
/*       MCC0560 - Funding GAP Accrual Report                        */
/*                                                                   */
/*       Function:  This program extracts and prints the details of  */
/*        (COB)     the Funding GAP Accrual postings.                */
/*                                                                   */
/*       Calls:     MC0560 - Funding GAP Accrual Extract             */
/*                  MC0561 - Funding GAP Accrual Report              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 158557 *CREATE     Date 28Apr99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       158557 - Provide a Funding GAP Accrual Report.              */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ)
/**/
/**  Declare variables */
/**/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BUSY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(128)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)  VALUE(' ')
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10) VALUE('  DPLIB')
             DCL        VAR(&SYSID)  TYPE(*CHAR) LEN(2)
/**/
/**  Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CALL       PGM(AOMMODR0) PARM(&RTCD '*FIRST' &MMOD)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
/**/
/**  If Analytical Accounting is not present, then end the program */
/**/
             IF         COND(%SST(&MMOD 100 1) *EQ 'N') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
/**/
             SNDPGMMSG  MSG('MCC0560 - Funding GAP Accrual Report') +
                           TOMSGQ(MRUNQ)
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
/**/
             CHGJOB     SWS(00000000)
/**/
/**  Clear Output file */
/**/
             CLRPFM     FILE(MCGEXTPD)
/**/
/**  Setup file Names */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SST(&TOLIB 1 2)) VALUE(&SYSID)
/**/
/**  Retrieve recovery flag */
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
/**/
/**  If restart, restore security copies */
/**/
             IF         COND(&BUSY = 'Y') THEN(DO)
/**/
             CPYF       FROMFILE(&TOLIB/XMCGAPAPD) TOFILE(MCGAPAPD) +
                           MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(MCGAPAPD))
/**/
             CPYF       FROMFILE(&TOLIB/XMCGAP1PD) TOFILE(MCGAP1PD) +
                           MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(MCGAP1PD))
/**/
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
/**  ELSE, take security copies for restart */
/**/
             CPYF       FROMFILE(MCGAPAPD) TOFILE(&TOLIB/XMCGAPAPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(XMCGAPAPD))
/**/
             CPYF       FROMFILE(MCGAP1PD) TOFILE(&TOLIB/XMCGAP1PD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(XMCGAP1PD))
/**/
             ENDDO
/**/
/**  Set busy flag */
/**/
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**/
             CPYF       FROMFILE(MCGAP1PD) TOFILE(MCGAPAPD) +
                           MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/**/
/**  Call extract program */
/**/
             CALL       PGM(MC0560)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/**  Call report program */
/**/
             CALL       PGM(MC0561)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             CPYF       FROMFILE(MCGAP1PD) TOFILE(MCGAPAPD) +
                           MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(MCGAPAPD))
/**/
             CLRPFM     FILE(MCGEXTPD)
             CLRPFM     FILE(MCGAP1PD)
/**/
/**  Reset busy flag as run was successful */
/**/
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**/
/**  Delete security copies */
/**/
             DLTF       FILE(&TOLIB/XMCGAPAPD)
             DLTF       FILE(&TOLIB/XMCGAP1PD)
             GOTO       CMDLBL(END)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/**  Abnormal error processing */
/**/
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Funding GAP Accrual Report - ENDED +
                           ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC
/**/
 END:        ENDPGM
