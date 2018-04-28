/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Revaluation A/C Key Generation')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Money Market Dealing Module                         */
/*                                                                   */
/*       MMC4210 - MM Revaluation A/C Key Generation                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CAS001  *CREATE    Date 23Nov01              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CAS001 - Net Present Value (NPV) Accounting                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MMC4210 - Money Market Revaluation +
                          A/C Key Generation') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
 
/* Create data area LDA */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
 
             RTVJOBA    TYPE(&JOBTYPE)
 
/* Setup system prefix variable from SDSTAT data area */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
 
/* Call program CB0160 to get value of restart indicator */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* If it is not a restart */
 
             IF         COND(&STAT *NE 'Y') THEN(DO)
               DLTF       FILE(XDEALSDC)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDEALSDD)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDKEYSDP)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDKEYSZZ)
               MONMSG     MSGID(CPF2105)
 
               CPYF       FROMFILE(DEALSDC) TOFILE(&DPLIB/XDEALSDC) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
               CPYF       FROMFILE(DEALSDD) TOFILE(&DPLIB/XDEALSDD) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
               CPYF       FROMFILE(DKEYSDP) TOFILE(&DPLIB/XDKEYSDP) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
               CPYF       FROMFILE(DKEYSZZ) TOFILE(&DPLIB/XDKEYSZZ) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
/* If it is a restart */
 
             IF         COND(&STAT *EQ 'Y') THEN(DO)
               CPYF       FROMFILE(XDEALSDC) TOFILE(DEALSDC) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(DEALSDC))
 
               CPYF       FROMFILE(XDEALSDD) TOFILE(DEALSDD) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(DEALSDD))
 
               CPYF       FROMFILE(XDKEYSDP) TOFILE(DKEYSDP) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(DKEYSDP))
 
               CPYF       FROMFILE(XDKEYSZZ) TOFILE(DKEYSZZ) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(DKEYSZZ))
             ENDDO
 
             CHGVAR     VAR(&STAT) VALUE('Y')
 
/* Call CB0150 to update restart indicator */
 
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/* Clear Revalued Money Market Deals file */
 
             CLRPFM     FILE(MMNPVLPD)
 
/* Call MM Revaluation A/C Key Generation */
 
             CALL       PGM(MM4210)
 
/* If no error occured in the program */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Call CB0150 to update restart indicator */
 
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               DLTF       FILE(XDEALSDC)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDEALSDD)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDKEYSDP)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XDKEYSZZ)
               MONMSG     MSGID(CPF2105)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job */
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             MMC4210 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
