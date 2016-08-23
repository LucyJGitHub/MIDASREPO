/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Check job activity')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5216  - Check job activity                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG6604            Date 20Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 095625             DATE 08NOV95              */
/*                      S01522             DATE 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG6604- Remove RCLRSC from this program                    */
/*       095625 - If CPF3C54 loop again                              */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &JOB_INFO &FORMAT &JOB +
                          &INT_JOB_ID)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOB_INFO) TYPE(*CHAR) LEN(512)
             DCL        VAR(&RTN_INFO) TYPE(*CHAR) LEN(512)
             DCL        VAR(&RTN_BIN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(26)
             DCL        VAR(&INT_JOB_ID) TYPE(*CHAR) LEN(16)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0)               /*095625*/
             DCL        VAR(&DELAY) TYPE(*DEC) LEN(5 0)               /*095625*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC5216 - Check job activity') +
                          TOMSGQ(MRUNQ)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
             CHGVAR     VAR(&JOB_INFO) VALUE(' ')
             CHGVAR     VAR(&RTN_BIN) VALUE(X'00000200')
/* */
/* Call IBM API to obtain information */
/* Note error code not coded to allow API to send diagonistics */
/* */
 LOOP:                                                                /*095625*/
             CALL       PGM(QUSRJOBI) PARM(&RTN_INFO &RTN_BIN +
                          &FORMAT &JOB &INT_JOB_ID)
             MONMSG     MSGID(CPF3C54) EXEC(DO)                       /*095625*/
/* */                                                                 /*095625*/
/* If CPF3C54 received job is not available at present, retry */      /*095625*/
/* */                                                                 /*095625*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                 /*095625*/
             CHGVAR     VAR(&DELAY) VALUE(&DELAY + (5 * &COUNT))      /*095625*/
             IF         COND(&DELAY *LT 150) THEN(DO)                 /*095625*/
                DLYJOB     DLY(&DELAY)                                /*095625*/
                GOTO       CMDLBL(LOOP)                               /*095625*/
             ENDDO                                                    /*095625*/
             GOTO       CMDLBL(ABNORMAL)                              /*095625*/
             ENDDO                                                    /*095625*/
             MONMSG     MSGID(CPF3C53 CPF3C55) EXEC(DO)
/* */
/* Job not found or does not exist */
/* */
             CHGVAR     VAR(&RTN_CODE) VALUE('CPG1007')
             ENDDO
/* */
/* Set up return information */
/* */
             CHGVAR     VAR(&JOB_INFO) VALUE(&RTN_INFO)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5216 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5216 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:                                                                               /*BUG6604*/
/***** ENDCLPGM:   RCLRSC     LVL(*CALLER)  *******/                                     /*BUG6604*/
/*******     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG6604*/
             ENDPGM
