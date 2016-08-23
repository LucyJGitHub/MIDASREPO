/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG DL dealing confirmations')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2220  - Dealing Confirmations                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.02 --------------------------------------------*/
/*       Last Amend No. 211713             Date 08Nov02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CCG015             DATE 14Nov00              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      086130             DATE 29MAR95              */
/*                      S01522             DATE 15FEB95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       211713 - ENDJRNPF on JRN/CGCOBJRN not required if CCB009    */
/*                is not present.                                    */
/*       CCG015 - Correspondence Manager - Phase 1                   */
/*       CCB009 - Journal files throughout close of business         */
/*       086130 - Add Endjrnpf to recovery                           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&COMP_NAME &COMP_SEQ &EXTRACT &MEMBER +
                          &COMMIT_OPT)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&COMP_NAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMP_SEQ)   TYPE(*DEC)  LEN(5)
             DCL        VAR(&COMP_SEQA)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&EXTRACT)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMMIT_OPT) TYPE(*CHAR) LEN(3)
/* */
             DCL        VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&STATUS)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_DATA)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)           /*CCG015*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2220 - Dealing Confirmations') +
                          TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
             CHGJOB     SWS(XXXXX000)
 
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
 
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        MONMSG     MSGID(CPF1023)
 
/* */
/* Clear ECONX* files */
/* */
             CLRPFM     FILE(ECONXCY)
             CLRPFM     FILE(ECONXCZ)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* */
/* Journal Files to CGCOBJRN */
/* */
             STRJRNPF   FILE(DLINDDM DAINDDL ECONXCY ECONXCZ) +
                          JRN(CGCOBJRN) IMAGES(*BOTH)
             ENDDO                                                    /*CCB009*/
/* */                                                                /*CCG015*/
/* Override relevant files used by Correspondent Mgr module.         /*CCG015*/
/* */                                                                /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')               /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                   /*CCG015*/
/* */
/* Run Extract Component */
/* */
             CHGVAR     VAR(&COMP_SEQA) VALUE(&COMP_SEQ)
             CHGVAR     VAR(&MSG_DATA) VALUE(&COMP_NAME *CAT +
                          &COMP_SEQA *CAT &EXTRACT *CAT &MEMBER +
                          *CAT &COMMIT_OPT)
             SNDPGMMSG  MSGID(CGD1271) MSGF(CGUSRMSG) +
                          MSGDTA(&MSG_DATA) TOPGMQ(*PRV)
             CALL       PGM(CG4100) PARM(&RTN_CODE &COMMIT_OPT)
             ROLLBACK
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */                                                                /*CCG015*/
/* Call custom defined extract program.                              /*CCG015*/
/* */                                                                /*CCG015*/
             CALL       PGM(CGC3604)                                 /*CCG015*/
/* */                                                                /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             /*CCG015*/
             SNDPGMMSG  MSG('Correspondence Manager Custom-Defined +
                        Data Extract failed.') TOMSGQ(MRUNQ)         /*CCG015*/
             GOTO       CMDLBL(DBERR)                                /*CCG015*/
             ENDDO                                                   /*CCG015*/
/**/
             GOTO       CMDLBL(ENDCLPGM)
 
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
/* */                                                                /*CCG015*/
/* If Correspondence manager is switched on, delete overrides        /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')               /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                   /*CCG015*/
/* */                                                                /*CCG015*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(DLINDDM DAINDDL ECONXCY ECONXCZ) +
                          JRN(CGCOBJRN)                               /*086130*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*086130*/
             ENDDO                                                    /*CCB009*/
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2220 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2220 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             IF         COND(&CCB009 *NE '       ') THEN(DO)                              /*211713*/
             ENDJRNPF   FILE(DLINDDM DAINDDL ECONXCY ECONXCZ) +
                          JRN(CGCOBJRN)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*211713*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
