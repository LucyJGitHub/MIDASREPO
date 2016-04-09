/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG SE Trading Statements On Request')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2260  - SE Trading Statements On Request                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01522             DATE 15MAR95              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RBCH &RPARM)
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
             DCL        VAR(&EXT_COMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EXTRACT)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMMIT_OPT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RECOVERY) TYPE(*CHAR) LEN(10)
/* */
             DCL        VAR(&RTN_CODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&STATUS)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG_DATA)   TYPE(*CHAR) LEN(256)
/* Parameters received for RCF                                       */
             DCL        VAR(&RSEQ)        TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)        TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(100)
             DCL        VAR(&CNUM)       TYPE(*CHAR) LEN(6)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2260 - SE Trading Statement +
                          OnRequest') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
 
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/* */
/* Run Extract Component */
/* */
             CHGDTAARA  DTAARA(LDA (7 3)) VALUE(&RBCH)
             CHGDTAARA  DTAARA(LDA (1 6)) VALUE(%SST(&RPARM 1 6))
             CHGVAR     VAR(&COMP_NAME) VALUE('CGC2260')
             CHGVAR     VAR(&COMP_SEQ) VALUE(10001)
             CHGVAR     VAR(&EXT_COMP) VALUE(CGC2250)
             CHGVAR     VAR(&CNUM) VALUE(%SST(&RPARM 1 6))
             CHGVAR     VAR(&EXTRACT) VALUE('SE_' *CAT &CNUM)
             CHGVAR     VAR(&COMMIT_OPT) VALUE('YES')
             CHGVAR     VAR(&RECOVERY) VALUE('*NONE')
/* */
             CALL       PGM(CGC2050) PARM(&COMP_NAME &COMP_SEQ +
                          &EXT_COMP &EXTRACT &COMMIT_OPT &RECOVERY)
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
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2210 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2210 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
