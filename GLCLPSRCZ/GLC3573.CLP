/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Account Details Cards')                      */
/*********************************************************************/
/*                                                                   */
/*  Midas   General Ledger Module                            */
/*                                                                   */
/*  GLC3573 - ACCOUNT DETAIL CARDS                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. S01413 *CREATE          DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  S01413 - Retail 3 Incorporation                                  */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
/*/COPY WNCPYSRC,GLC3573001                                          */
/**/
             SNDPGMMSG  MSG('GLC3573 - Account Details report-Cards') +
                        TOMSGQ(MRUNQ)
/**/
/*   Create Local Data Area                                          */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
/**/
             CHGJOB     SWS(00000000)
/*/COPY WNCPYSRC,GLC3573002                                          */
/**/
/*  If the request is not for all accounts, run extract program  */
/**/
             IF         COND(%SST(&RPARM 1 3) *NE 'ALL') THEN(DO)
                CLRPFM     FILE(ACDETAA)
                CLRPFM     FILE(ACDETAB)
                CLRPFM     FILE(ACDETAC)
/*/COPY WNCPYSRC,GLC3573003                                          */
                CALL       PGM(GL0782) PARM(&RSEQ)
                ENDDO
/**/
/*  If no errors, run the report */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/*  If all a/cs to be printed, use Accounts file, else use extract */
/**/
                IF         COND(%SST(&RPARM 1 3) *EQ 'ALL') THEN(DO)
                   OVRDBF     FILE(SADET) TOFILE(ACCBA) +
                              SEQONLY(*YES 100)
                   ENDDO
                ELSE       CMD(DO)
                IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                           THEN(DO)
                           OVRDBF FILE(SADETA) POSITION(*KEY 1 +
                           ACCNTABF &RENT)
                           OPNDBF FILE(SADETA) OPTION(*ALL)
                           MONMSG MSGID(CPF0000) EXEC(DO)
                           DLTOVR FILE(SADETA)
                           ENDDO
                           ENDDO
                   OVRDBF     FILE(SADET) TOFILE(SADETA) +
                              SEQONLY(*YES 100)
                   ENDDO
/**/
/*  Run report */
/**/
                RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)
                IF         COND(&RSEQ *EQ '     ') THEN(CHGJOB +
                             SWS(1XXXXXXX))
                   CALL       PGM(GL0573) PARM(&RSEQ &RENT)
/**/
                   DLTOVR     FILE(SADET)
/**/
                ENDDO
/**/
             CLOF       OPNID(SADETA)
                          MONMSG MSGID(CPF0000)
/**/
/*  If no errors, exit */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
/**/
/*  Database error */
/**/
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR -+
                        GL3573') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR -+
                        GL3573') TOMSGQ(MOPERQ)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:         ENDPGM
