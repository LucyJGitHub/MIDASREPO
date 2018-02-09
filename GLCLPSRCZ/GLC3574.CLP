/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Account details authorisation report')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC3574 - Account Details Authorisation - Detail Rpt        */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSD012  *CREATE    Date 15Oct02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CSD012 - Standing Data Authorisation                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)             */                     /*CCB020*/
                                                                                          /*CCB020*/
/* Parameter for call to CBC001001 */                                                     /*CCB020*/
             DCL        VAR(&WCOB) TYPE(*CHAR) LEN(4)                                     /*CCB020*/
 
             SNDPGMMSG  MSG('GLC3574 - Account Authorisation Report') +
                        TOMSGQ(MRUNQ)
 
/*   Create Local Data Area                                          */
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
 
/*  If requested in Input Cycle, set on U3 for 'Interim' on report */
 
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)               */                     /*CCB020*/
                                                                                          /*CCB020*/
/* Call program CBC001001 to check if program is in COB or IC */                          /*CCB020*/
/* If the return value is *YES, system is in COB */                                       /*CCB020*/
/* If *NO, system is in Input Cycle */                                                    /*CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(CBC001001) PARM(&WCOB)                                        /*CCB020*/
 
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)              */                     /*CCB020*/
             IF         COND(&WCOB = '*NO') THEN(DO)                                      /*CCB020*/
                CHGJOB     SWS(00100000)
             ENDDO
             ELSE       CMD(DO)
                CHGJOB     SWS(00000000)
             ENDDO
 
/*  If the request is not for all accounts, run extract program  */
 
             IF         COND(%SST(&RPARM 1 3) *NE 'ALL') THEN(DO)
                CLRPFM     FILE(ACDETAA)
                CLRPFM     FILE(ACDETAB)
                CLRPFM     FILE(ACDETAC)
                OVRDBF     FILE(ACNUM) TOFILE(REACSHL0) SEQONLY(*YES 100)
                OVRDBF     FILE(ACCBR) TOFILE(GLACSHL1) SEQONLY(*YES 100)
                OVRDBF     FILE(ACCNT) TOFILE(GLACSHL2) SEQONLY(*YES 100)
                CALL       PGM(GL0782) PARM(&RSEQ)
                DLTOVR     FILE(ACNUM)
                DLTOVR     FILE(ACCBR)
                DLTOVR     FILE(ACCNT)
             ENDDO
 
/*  If no errors, run the report */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/*  If all a/cs to be printed, use Accounts file, else use extract */
 
                IF         COND(%SST(&RPARM 1 3) *EQ 'ALL') THEN(DO)
                   OVRDBF     FILE(SADET) TOFILE(GLACSHL1) SEQONLY(*YES 100)
                ENDDO
                ELSE       CMD(DO)
                   IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                                THEN(DO)
                      OVRDBF     FILE(SADETA) POSITION(*KEY 1 ACCNTABF &RENT)
                      OPNDBF     FILE(SADETA) OPTION(*ALL)
                      MONMSG     MSGID(CPF0000) EXEC(DO)
                         DLTOVR     FILE(SADETA)
                      ENDDO
                   ENDDO
 
                   OVRDBF     FILE(SADET) TOFILE(SADETA) SEQONLY(*YES 100)
                ENDDO
 
/*  Run report */
 
                CALL       PGM(GL3572) PARM(&RSEQ &RENT)
 
                DLTOVR     FILE(SADET)
 
             ENDDO
 
             CLOF       OPNID(SADETA)
             MONMSG     MSGID(CPF0000)
 
/*  If no errors, exit */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
 
/*  Database error */
 
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR +
                          -GL3574') TOMSGQ(MRUNQ)
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE IN ERROR +
                          -GL3574') TOMSGQ(MOPERQ)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Banking Systems Ltd.')
END:
             ENDPGM
