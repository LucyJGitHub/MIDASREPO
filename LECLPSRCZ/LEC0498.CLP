/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Transaction Income Splits Housekeeping')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0498 - Transaction Income Splits Housekeeping Control    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9678            Date 20Dec05              */
/*       Prev Amend No. CLE035 *CREATE     Date 22Sep03              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG9678- LEC0498 00001 failed due on copy command error.    */
/*       CLE035 - Lending Enhancement for Nordea Phase 1 Priority 2  */
/*                Income Splits                                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare the variables for rerun checking */
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Midas Transaction Income Splits House+
                          keeping') TOPGMQ(*EXT) TOMSGQ(MRUNQ)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&LIB) VALUE(&PREF *TCAT 'DPLIB')
 
/* Check the current status of this component */
/* If this is not a restart, backup Transaction Income Splits File */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
             IF         COND(&STAT *EQ 'N') THEN(DO)
 
                CPYF       FROMFILE(LETISPPD) TOFILE(&LIB/XLETISPPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                /*BUG9678*/
                CHGVAR     VAR(&STAT) VALUE('Y')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
 
/* If this is a restart, restore master files */
 
             ELSE       CMD(DO)
 
                CPYF       FROMFILE(XLETISPPD) TOFILE(LETISPPD) +
                             MBROPT(*REPLACE)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                /*BUG9678*/
 
             ENDDO
 
/* Call Manual Facility Utilisation Audit Report */
 
             CALL       PGM(LE0498)
 
/* No database error or not file-out-of-balance */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
                DLTF       FILE(XLETISPPD)
                CHGVAR     VAR(&STAT) VALUE('N')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
             ELSE       CMD(DO)
 
/* Database error processing */
 
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                             MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ))
                ELSE       CMD(SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) +
                             MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                             MRUNQ))
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          LEC0498 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
