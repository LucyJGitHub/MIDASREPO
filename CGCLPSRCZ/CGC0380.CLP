/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Display Midas Information Screen')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC0380  - Display Midas Information screen                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG5456            Date 03Feb05              */
/*       Prev Amend No. CSC022             Date 24Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 21Nov94              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG5456 - Fixes for Commitment Control Changes (CSC022)     */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &MSGID &MSGF &MSGDTA &OPTION +
                          &REPLY &PROGRAM &SECLVL)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TXT1) TYPE(*CHAR) LEN(132)
             DCL        VAR(&TXT2) TYPE(*CHAR) LEN(512)
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SECLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC022*/
             DCL        VAR(&WCMTSK) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC022*/
             DCL        VAR(&WSCCMTJOB) TYPE(*CHAR) LEN(256)                              /*CSC022*/
             DCL        VAR(&WCMTNUM) TYPE(*DEC) LEN(3 0)                                 /*CSC022*/
             DCL        VAR(&WCMTJOB) TYPE(*CHAR) LEN(100)                                /*CSC022*/
             DCL        VAR(&PRTN) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&POPT) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC022*/
             DCL        VAR(&PSAR) TYPE(*CHAR) LEN(6) VALUE('CSC022')                     /*CSC022*/
             DCL        VAR(&PFMT) TYPE(*CHAR) LEN(200)                                   /*CSC022*/
             DCL        VAR(&WJOB) TYPE(*CHAR) LEN(10)                                    /*CSC022*/
/************DCL        VAR(&WSTR) TYPE(*DEC) LEN(2 0) VALUE(1) */                /*CSC022 BUG5456*/
             DCL        VAR(&WSTR) TYPE(*DEC) LEN(3 0) VALUE(1)                          /*BUG5456*/
             DCL        VAR(&WJOBCTR) TYPE(*DEC) LEN(3 0) VALUE(1)                       /*BUG5456*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches off */
/* */
             CHGJOB     SWS(XXXXX000)
/* */                                                                                     /*CSC022*/
/* Retrieve Commitment Control Jobs data area */                                          /*CSC022*/
/* */                                                                                     /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&PRTN &POPT &PSAR &PFMT)                       /*CSC022*/
                                                                                          /*CSC022*/
/************IF         COND(&PRTN *EQ *BLANKS) THEN(DO) */                       /*CSC022 BUG5456*/
             IF         COND(&PRTN *EQ '       ') THEN(DO)                               /*BUG5456*/
             CHGVAR     VAR(&CSC022) VALUE('Y')                                           /*CSC022*/
             CHGVAR     VAR(&WCMTSK) VALUE('N')                                           /*CSC022*/
                                                                                          /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB) RTNVAR(&WSCCMTJOB)                               /*CSC022*/
             CHGVAR     VAR(&WCMTNUM) VALUE(%SST(&WSCCMTJOB 1 3))                         /*CSC022*/
             CHGVAR     VAR(&WCMTJOB) VALUE(%SST(&WSCCMTJOB 4 103))                       /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&WCMTNUM *GT 0) THEN(DO)                                     /*CSC022*/
             RTVJOBA    JOB(&WJOB)                                                        /*CSC022*/
                                                                                          /*CSC022*/
 SCAN:       IF         COND(&WJOB *EQ %SST(&WCMTJOB &WSTR 10)) +
                          THEN(CHGVAR VAR(&WCMTSK) VALUE('Y'))                            /*CSC022*/
                                                                                          /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&WJOBCTR *LT &WCMTNUM) THEN(DO)                             /*BUG5456*/
             CHGVAR     VAR(&WJOBCTR) VALUE(&WJOBCTR + 1)                                /*BUG5456*/
             CHGVAR     VAR(&WSTR) VALUE(&WSTR + 10)                                      /*CSC022*/
             GOTO       CMDLBL(SCAN)                                                     /*BUG5456*/
/************IF         COND(&WSTR *LT 100) THEN(GOTO CMDLBL(SCAN)) */            /*CSC022 BUG5456*/
             ENDDO                                                                       /*BUG5456*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(IF COND(&PRTN *NE '*NRF') THEN(GOTO +
                          CMDLBL(ABNORMAL)))                                              /*CSC022*/
/* */
/* Run CGC1000 - to obtain message detail  */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
             CALL       PGM(CGC1000) PARM(&MSGID &MSGF &MSGDTA &TXT1 +
                          &TXT2)
/* */
/* Update MIDASMSG data area and call prompt screen program */
/* */
             IF         COND(&SECLVL *EQ 'Y') THEN(DO)
             CHGDTAARA  DTAARA(MIDASMSG (101 500)) VALUE(%SST(&TXT2 +
                          1 500))
             ENDDO
             ELSE       CMD(DO)
             CHGDTAARA  DTAARA(MIDASMSG (101 500)) VALUE(%SST(&TXT1 +
                          1 132))
             ENDDO
/* */
             CALL       PGM(SCC0010) PARM(&PROGRAM &OPTION &REPLY)
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
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +
                          'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO)                          /*CSC022*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*CSC022*/
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC0380 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0380 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
