/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG End of day retail advices')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC2170  - End Of Day Retail Advices                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 233690             Date 11Jul05              */
/*       Prev Amend No. CRE020             Date 20Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 15Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       233690 - Add OVRDBF to avoid DBASE004 in CG3615.            */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
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
                                                                                          /*CCG015*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
                                                                                          /*CRE020*/
/* Declare the variables to check the enhancements file */                                /*CRE020*/
                                                                                          /*CRE020*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CRE020*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                     /*CRE020*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                                    /*CRE020*/
                                                                                          /*CRE020*/
 
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
                                                                                          /*CRE020*/
/* Check if enhancement CRE020 in installed */                                            /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&SARD) VALUE('CRE020')                                        /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTN_CODE &OPTN &SARD &FMT)                    /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTN_CODE *NE '       ' *AND &RTN_CODE *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
             SNDPGMMSG  MSG('DATABASE IN ERROR - SCSARDPD') TOMSGQ(MOPERQ)                /*CRE020*/
             GOTO       CMDLBL(ENDCLPGM)                                                  /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTN_CODE *EQ '       ') THEN(GOTO +
                          CMDLBL(ENDCLPGM))                                               /*CRE020*/
                                                                                          /*CRE020*/
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('CGC2170 - End Of Day Retail Advices') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
 
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
 
/* */
/* Create data LDA in QTEMP  */
/* */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                        MONMSG     MSGID(CPF1023)
 
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
             CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
/* */
/* Run Extract Component */
/* */
             CHGVAR     VAR(&COMP_SEQA) VALUE(&COMP_SEQ)
             CHGVAR     VAR(&MSG_DATA) VALUE(&COMP_NAME *CAT +
                          &COMP_SEQA *CAT &EXTRACT *CAT &MEMBER +
                          *CAT &COMMIT_OPT)
             SNDPGMMSG  MSGID(CGD1271) MSGF(CGUSRMSG) +
                          MSGDTA(&MSG_DATA) TOPGMQ(*PRV)
             CALL       PGM(CG4800) PARM(&RTN_CODE &COMMIT_OPT)
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
                                                                                          /*CCG015*/
/** Call Custom-Defined Data Extract pgm */                                               /*CCG015*/
             RCLRSC                                                                       /*233690*/
             OVRDBF     FILE(CGUDCRL0) TOFILE(EXCGUDCRPD) +
                          MBR(RETAIL_ADV) SHARE(*YES)                                     /*233690*/
             OPNQRYF    FILE((EXCGUDCRPD RETAIL_ADV)) +
                          FORMAT(CGUDCRL0) KEYFLD((DRITEM))                               /*233690*/
/* */                                                                                     /*233690*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
/* */                                                                                     /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)                                /*CCG015*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                                     /*CCG015*/
             GOTO       CMDLBL(ABNORMAL)                                                  /*CCG015*/
             ENDDO                                                                        /*CCG015*/
/**/
             CLOF       OPNID(EXCGUDCRPD)                                                 /*233690*/
             DLTOVR     FILE(CGUDCRL0)                                                    /*233690*/
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
             CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                    /*CCG015*/
             CALL       PGM(CGC3605) PARM(&ACTION)                                        /*CCG015*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC2170 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC2170 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
