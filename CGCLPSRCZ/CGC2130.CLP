/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Statements')                                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2130  - Statements                                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 227781             Date 16Jun04              */
/*       Prev Amend No. 216937             Date 28Apr03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015             Date 25Jun01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 21Nov94              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       227781 - Add OVRDBF to avoid DBASE004 in CG3615.            */
/*       216937- Include source of posting if GA posting             */
/*       CCG015 - Correspondence Manager Phase 1                     */
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
             DCL        VAR(&ACTION)     TYPE(*CHAR) LEN(8)          /*CCG015*/
/*/COPY WNCPYSRC,CGC2130001                                          */
 
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2130 - Statements') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
 
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
 
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        MONMSG     MSGID(CPF1023)
/*/COPY WNCPYSRC,CGC2130002                                          */
/* */
/* Override Update Logicals                                          */
/* */
             OVRDBF     FILE(ACCNT)    SHARE(*NO)
             OVRDBF     FILE(ACCNTL0)  SHARE(*NO)
             OVRDBF     FILE(CGSTMTLU) TOFILE(CGSTMTL1) SHARE(*NO)
             OVRDBF     FILE(GLAPSGL0) TOFILE(GLAPSGAL0)              /*216937*/
/*/COPY WNCPYSRC,CGH00008                                            */
/* */                                                                /*CCG015*/
/* If Correspondence manager is switched on, override files          /*CCG015*/
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
             CALL       PGM(CG4500) PARM(&RTN_CODE &COMMIT_OPT)
             ROLLBACK
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,CGC2130003                                          */
 
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
/* If Correspondence manager is switched on, call custom defined     /*CCG015*/
/* extract program                                                   /*CCG015*/
             RCLRSC                                                  /*227781*/
             OVRDBF     FILE(CGUDCRL0) TOFILE(EXCGUDCRPD) +
                          MBR(STATEMENTS) SHARE(*YES)                /*227781*/
             OPNQRYF    FILE((EXCGUDCRPD STATEMENTS)) +
                          FORMAT(CGUDCRL0) KEYFLD((DRITEM))          /*227781*/
/* */                                                                /*CCG015*/
             CALL       PGM(CGC3604)                                 /*CCG015*/
/* */                                                                /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             /*CCG015*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)           /*CCG015*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                /*CCG015*/
             GOTO       CMDLBL(ABNORMAL)                             /*CCG015*/
             ENDDO                                                   /*CCG015*/
/**/
             CLOF       OPNID(EXCGUDCRPD)                            /*227781*/
             DLTOVR     FILE(CGUDCRL0)                               /*227781*/
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
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2130 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2130 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
