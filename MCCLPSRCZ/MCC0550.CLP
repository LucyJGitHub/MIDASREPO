/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC F/M Accounts Reconciliation Report')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounting Module                        */
/*                                                                   */
/*       MCC0550 - F/M Accounts Reconciliation                       */
/*                                                                   */
/*       Function:  This program reconciles the balances between the */
/*                  Financial accounts and the Management accounts.  */
/*                                                                   */
/*       Calls:     MC0550 - Financial/Management Accounts Extract   */
/*                  MC0551 - Financial/Management Accounts Reconc'n  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 124847 *CREATE     Date 05Sep97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       124847 - Financial/Management Accounts Reconciliation       */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
/**  Declare variables */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD)   TYPE(*CHAR) LEN(128)
             DCL        VAR(&PRCG)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSET)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDCT)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDYR)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDNY)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&DSFDY)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&OPNQRYF) TYPE(*CHAR) LEN(2000)
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
             SNDMSG     MSG('MCC0550 - F/M Acccounts +
                          Reconciliation') TOMSGQ(MRUNQ)
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
/**/
/**  Access PCA ICD for Primary Control Group */
/**/
             CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' &DSFDY)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PRCG) VALUE(%SST(&DSFDY 15 2))
/**/
/**  Access Historic Balances Control Group File for the 'Period */
/**  Set' code of the Primary Control Group                      */
/**/
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &PRCG &DSFDY)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PSET) VALUE(%SST(&DSFDY 33 1))
/**/
/**  Access Current Period Century, Year and Number */
/**/
             CALL       PGM(AORPERR0) PARM(&RTCD '*KEY' &PSET 0 &DSFDY)
             IF         COND(&RTCD *NE ' ') THEN(GOTO CMDLBL(ABNOR))
             CHGVAR     VAR(&PDCT) VALUE(%SST(&DSFDY 2 2))
             CHGVAR     VAR(&PDYR) VALUE(%SST(&DSFDY 4 2))
             CHGVAR     VAR(&PDNY) VALUE(%SST(&DSFDY 6 2))
/**/
/**  Initialise transaction file */
             CLRPFM     FILE(MCHIBLPD)
             CLRPFM     FILE(MCACHBPD)
/**/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLHIBLPD' +
                          *BCAT &PRCG *TCAT ')) FORMAT(MCHIBLPD) +
                          QRYSLT(''HBPDCT *EQ' *BCAT '''''' *TCAT +
                          &PDCT *TCAT '''''' *BCAT '*AND HBPDYR +
                          *EQ' *BCAT '''''' *TCAT &PDYR *TCAT +
                          '''''' *BCAT '*AND HBPDNY *EQ' *BCAT +
                          '''''' *TCAT &PDNY *TCAT '''''''' *TCAT ')')
/**/
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 2000)
/**/
             CPYFRMQRYF FROMOPNID(GLHIBLPD) TOFILE(MCHIBLPD) +
                          MBROPT(*REPLACE)
             CLOF       OPNID(GLHIBLPD)
/**/
             CHGJOB     SWS(00000000)
/**/
/**  Call extract program */
/**/
             CALL       PGM(MC0550)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/**  Call report program */
/**/
             CALL       PGM(MC0551) PARM(&RSEQ &RLEV &RENT)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
/**  Abnormal error processing */
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MCC0550 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
 END:        ENDPGM
