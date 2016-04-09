/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Revaluation Using All-in-Rate A/C Key Gen')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Lending Module                                      */
/*                                                                   */
/*       LEC4410 - Revaluation Using All-in-Rate A/C Key Generation  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS005  *CREATE    Date 16Dec02              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
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
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             SNDPGMMSG  MSG('LEC4410 - Customer Lending Revaluation +
                          A/C Key Generation') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
             RTVJOBA    TYPE(&JOBTYPE)
 
/* Setup system prefix variable from SDSTAT data area */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
 
/* Call program CB0160 to get value of restart indicator */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* If it is NOT a restart */
 
             IF         COND(&STAT *NE 'Y') THEN(DO)
               DLTF       FILE(XCLOANCL)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XLKEY1DP)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XLKEY1ZZ)
               MONMSG     MSGID(CPF2105)
 
               CPYF       FROMFILE(CLOANCL) TOFILE(&DPLIB/XCLOANCL) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
               CPYF       FROMFILE(LKEY1DP) TOFILE(&DPLIB/XLKEY1DP) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
               CPYF       FROMFILE(LKEY1ZZ) TOFILE(&DPLIB/XLKEY1ZZ) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
/* If it is a restart */
 
             IF         COND(&STAT *EQ 'Y') THEN(DO)
               CPYF       FROMFILE(XCLOANCL) TOFILE(CLOANCL) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(CLOANCL))
 
               CPYF       FROMFILE(XLKEY1DP) TOFILE(LKEY1DP) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(LKEY1DP))
 
               CPYF       FROMFILE(XLKEY1ZZ) TOFILE(LKEY1ZZ) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(LKEY1ZZ))
             ENDDO
 
             CHGVAR     VAR(&STAT) VALUE('Y')
 
/* Call CB0150 to update restart indicator */
 
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/* Clear Revalued Customer Loans file */
 
             CLRPFM     FILE(LENPVAPD)
 
/* Call LE Revaluation Using All-in-Rate & A/Key Generation Report */
 
             CALL       PGM(LE4410)
 
/* If no error occured in the program */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/* Call CB0150 to update restart indicator */
 
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               DLTF       FILE(XCLOANCL)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XLKEY1DP)
               MONMSG     MSGID(CPF2105)
               DLTF       FILE(XLKEY1ZZ)
               MONMSG     MSGID(CPF2105)
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            LEC4410 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
