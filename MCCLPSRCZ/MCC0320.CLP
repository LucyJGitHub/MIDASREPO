/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Funding GAP Entry Generation')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounts Module                          */
/*                                                                   */
/*       MCC0320 - Funding GAP Entry Generation                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. 226963             Date 23Nov06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      158557             Date 28Apr99              */
/*                      CMC001 *CREATE     DATE 18MAR96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       226963 - Set on U6 when MCC0320 00002 being run.            */
/*                Applied 212958                                     */
/*       158557 - PCA015, Provide a Funding Gap Accrual Report       */
/*       CMC001 - Management Accounts Enhancement for PCA:           */
/*                Created for Management Accounts.                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10) +
                           VALUE('  DPLIB')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
/**/
/* Global error message                                              */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                           CMDLBL(ERROR))
/**/
/* Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                           DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                           VALUE(' ') TEXT('MIDAS SD AS400 LOCAL +
                           DATA AREA EQUIVALENT'))
/**/
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MCC0320 - Funding GAP Entry Generation') +
                           TOMSGQ(MRUNQ)
/* */
/* Set Job Switch */
/**/
             CHGJOB     SWS(00000000)
/**/
/* Clear Ouput file */
/**/
             CLRPFM     FILE(MCPCACPD)
/**/
/* Setup file Names */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SST(&TOLIB 1 2)) VALUE(&SYSID)
/* */
/* Retrieve recovery flag */
/* */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
/* */
/* If restart, Restore for Security Copies  */
/* */
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(&TOLIB/XMCACHRPD) TOFILE(MCACHRPD) +
                           MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(MCACHRPD))
 
             CPYF       FROMFILE(&TOLIB/XMCACDTPD) TOFILE(MCACDTPD) +
                           MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(MCACDTPD))
 
             CPYF       FROMFILE(&TOLIB/XMCDIRYPD) TOFILE(MCDIRYPD) +
                           MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(MCDIRYPD))
 
             ENDDO
 
             ELSE       CMD(DO)
 
/* ELSE,  take Security Copies for restart                      */
 
             CPYF       FROMFILE(MCACHRPD) TOFILE(&TOLIB/XMCACHRPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(XMCACHRPD))
 
             CPYF       FROMFILE(MCACDTPD) TOFILE(&TOLIB/XMCACDTPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(XMCACDTPD))
 
             CPYF       FROMFILE(MCDIRYPD) TOFILE(&TOLIB/XMCDIRYPD) +
                           MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)  +
                           EXEC(CLRPFM FILE(XMCDIRYPD))
 
             ENDDO
 
/* Set busy flag */
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
             IF         COND(&CSEQ = 2) THEN(CHGJOB SWS(XXXXX1XX))                        /*226963*/
/**/
/* Process Back Valued Postings                      */
/**/
             CALL       PGM(MC0320)
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/**/
/* Call Diary update, to Transfer Gap Income/Expense                 */
/**/
             RCLRSC
             CALL       PGM(MCC0520) PARM('NNYYNN')
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/**/
/* Call Funding GAP Accrual Entry Generation                         */
/**/
             RCLRSC
/**/                                                                  /*158557*/
             CLRPFM     FILE(MCGAP1PD)                                /*158557*/
             CALL       PGM(MC0330)
             CHGJOB SWS(XXXXX0XX)                                                         /*226963*/
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Reset busy flag as run was successful */
 
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
             RCLRSC
 
/* Delete security copies */
 
             DLTF       FILE(&TOLIB/XMCACHRPD)
             DLTF       FILE(&TOLIB/XMCACDTPD)
             DLTF       FILE(&TOLIB/XMCDIRYPD)
             GOTO       CMDLBL(ENDPGM)
 
 ERROR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Funding Gap Entry Generation - +
                           ENDED ABNORMALLY') TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCLRSC
ENDPGM:      ENDPGM
