/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG TELLER Action Test')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC0522  - CG PrtGen Extraction Control - Retail Teller     */
/*                                                                   */
/*  (C) COPYRIGHT MKI INTERNATIONAL LIMITED 1994.                    */
/*                                                                   */
/*       Last Amend No. CCG016 *CREATE     Date 21FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCG016 - Correspondence Manager for Retail Teller System    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION &MSG_REF)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT MKI +
                          INTERNATIONAL LTD. 1997')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG_REF) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ORDER) TYPE(*CHAR) LEN(2)
             DCL        VAR(&KEY_LEN) TYPE(*DEC) LEN(3 0) VALUE(10)
             DCL        VAR(&KEY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SNDR_LEN) TYPE(*DEC) LEN(3 0) VALUE(44)
             DCL        VAR(&SNDR) TYPE(*CHAR) LEN(44)
             DCL        VAR(&DELAY_TIME) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DELAYA) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TEMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB_INFO) TYPE(*CHAR) LEN(512)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB26) TYPE(*CHAR) LEN(26)
             DCL        VAR(&INT_JOB_ID) TYPE(*CHAR) LEN(16)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&TXT1) TYPE(*CHAR) LEN(132)
             DCL        VAR(&TXT2) TYPE(*CHAR) LEN(512)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&MKICPY) VALUE('COPYRIGHT MKI +
                          International Ltd. 1997.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('CGC0522 - CG PrtGen Extraction Test +
                          Action') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&MSG_REF) VALUE(' ')
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/* Check if data queue exists */
/**/
             CALL       PGM(CGC0525)
/**/
/* If action is Start */
/**/
             IF         COND(&ACTION *EQ 'Start     ') THEN(DO)
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
             ALCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *EXCL)) WAIT(60)
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1000')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Change allocation to shared read */
/**/
             ALCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *SHRUPD)) WAIT(0)
             DLCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *EXCL))
/**/
/* Process is not active - if interactive submit to batch */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CALL       PGM(CGC0523) PARM(&RTN_CODE)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'CGP1000')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             DLCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *SHRUPD))
             ENDDO
/* End 'Start' */
             ENDDO
/**/
/* If action is Next */
/**/
             IF         COND(&ACTION *EQ 'Next      ') THEN(DO)
/* */
/* Set count and delay time */
/* If delay time not set, set to 5 seconds */
/* */
             RTVDTAARA  DTAARA(CGTELLER (51 4)) RTNVAR(&DELAYA)
             IF         COND(&DELAYA *EQ '    ') THEN(DO)
             CHGVAR     VAR(&DELAY_TIME) VALUE(0)
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&DELAY_TIME) VALUE(&DELAYA)
             ENDDO
/**/
/* Read data queue for next prompt for action */
/**/
             CHGVAR     VAR(&WAIT) VALUE(1)
             CHGVAR     VAR(&ORDER) VALUE('GE')
             CHGVAR     VAR(&KEY) VALUE(' ')
 RDTAQ:      CALL       PGM(QRCVDTAQ) PARM('CGTELLER' &DILIB &FLDLEN +
                          &DATA &WAIT &ORDER &KEY_LEN &KEY +
                          &SNDR_LEN &SNDR)
/**/
/* No information */
/**/
             IF         COND(&FLDLEN *EQ 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1003')
             ENDDO
/**/
/* Information */
/**/
             IF         COND(&FLDLEN *GT 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1004')
/**/
/* Close down requested */
/**/
             IF         COND(%SST(&DATA 1 3) *EQ 'End') THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1002')
             RETURN
             ENDDO
             CHGVAR     VAR(&MSG_REF) VALUE(&DATA)
             ENDDO
/**/
/* Delay job by wait time (first time only) */
/**/
             IF         COND(&WAIT *GE 0) THEN(DO)
             IF         COND(&DELAY_TIME *GT 0) THEN(DO)
             DLYJOB     DLY(&DELAY_TIME)
             ENDDO
             ENDDO
/**/
/* If no information from prior read of data queue */
/* Re-read queue for ever */
/**/
             IF         COND(&RTN_CODE *EQ 'CGP1003') THEN(DO)
             CHGVAR     VAR(&WAIT) VALUE(-1)
             GOTO       CMDLBL(RDTAQ)
             ENDDO
/**/
/* Else read all for end information on data queue */
/* and exit */
/**/
             ELSE       CMD(DO)
             CHGVAR     VAR(&WAIT) VALUE(1)
             CHGVAR     VAR(&ORDER) VALUE('EQ')
             CHGVAR     VAR(&KEY) VALUE('End')
 ADTAQ:      CALL       PGM(QRCVDTAQ) PARM('CGTELLER' &DILIB &FLDLEN +
                          &DATA &WAIT &ORDER &KEY_LEN &KEY +
                          &SNDR_LEN &SNDR)
/**/
/* No information */
/**/
             IF         COND(&FLDLEN *EQ 0) THEN(DO)
             RETURN
             ENDDO
/**/
/* Information */
/**/
             IF         COND(&FLDLEN *GT 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1004')
/**/
/* Close down requested */
/**/
             IF         COND(%SST(&DATA 1 3) *EQ 'End') THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1002')
             RETURN
             ENDDO
             CHGVAR     VAR(&MSG_REF) VALUE(&DATA)
             ENDDO
             GOTO       CMDLBL(ADTAQ)
             ENDDO
/* End 'Next' */
             ENDDO
/**/
/* If action is Re-submit */
/**/
             IF         COND(&ACTION *EQ 'Re-submit ') THEN(DO)
             CALL       PGM(CGC0523) PARM(&RTN_CODE)
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             DLCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *SHRUPD))
             ENDDO
/**/
/* If action is End */
/**/
             IF         COND(&ACTION *EQ 'End       ') THEN(DO)
/**/
/* Allocate data queue *SHRUPD to see if process active */
/**/
             ALCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *SHRUPD)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process cannot be killed re-try later */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1005')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Send data queue entry to End process */
/**/
             CHGVAR     VAR(&DATA) VALUE(' ')
             CHGVAR     VAR(&DATA) VALUE('End')
             CALL       PGM(QSNDDTAQ) PARM('CGTELLER' &DILIB &FLDLEN +
                          &DATA &KEY_LEN 'End       ')
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CALL       PGM(CGC0380) PARM(&RTN_CODE 'CGP1006' +
                          'CGUSRMSG ' &MSGDTA '          ' ' ' +
                          'CGC0522' 'Y')
             ENDDO
/**/
/* Try to allocate data queue *EXCL */
/**/
 ALCOBJ:     ALCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *EXCL)) WAIT(120)
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Check activity of job submitted */
/**/
             RTVDTAARA  DTAARA(CGTELLER (55 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGTELLER (65 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGTELLER (75 6)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 21 6)) VALUE(%SST(&TEMP 1 6))
             CHGVAR     VAR(&FORMAT) VALUE('JOBI0200')
             CALL       PGM(CGC5216) PARM(&RTN_CODE &JOB_INFO +
                          &FORMAT &JOB26 &INT_JOB_ID)
/**/
/* If inactive end in error */
/**/
             IF         COND((&RTN_CODE *EQ 'CGP1007') *OR +
                             (%SST(&JOB_INFO 51 10) *EQ '*OUTQ  ') +
                        ) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* Kill process defined in CGTELLER */
/**/
             RTVDTAARA  DTAARA(CGTELLER (55 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(CGTELLER (65 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(CGTELLER (75 6)) RTNVAR(&JOBNBR)
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CHGVAR     VAR(&MSGDTA) VALUE(&JOB *CAT &USER *CAT +
                          &JOBNBR)
             CALL       PGM(CGC0380) PARM(&RTN_CODE 'CGP1008' +
                          'CGUSRMSG ' &MSGDTA '          ' ' ' +
                          'CGC0522' 'Y')
             ENDDO
/**/
/* If jobq then *IMMED */
/**/
             IF         COND((%SST(&JOB_INFO 51 10) *EQ '*JOBQ  ') +
                        ) THEN(DO)
             ENDJOB     JOB(&JOBNBR/&USER/&JOB) OPTION(*IMMED)
             MONMSG     MSGID(CPF1362 CPF1363 CPF1361 CPF1352)
             GOTO       CMDLBL(ALCOBJ)
             ENDDO
/**/
/* If active then *CNTRLD for 10 minutes */
/**/
             IF         COND((%SST(&JOB_INFO 51 10) *EQ '*ACTIVE') +
                        ) THEN(DO)
             ENDJOB     JOB(&JOBNBR/&USER/&JOB) OPTION(*CNTRLD) +
                          DELAY(600)
             MONMSG     MSGID(CPF1362 CPF1363 CPF1361 CPF1352)
             GOTO       CMDLBL(ALCOBJ)
             ENDDO
/**/
             ENDDO
/**/
/* Check activity of job submitted */
/**/
             RTVDTAARA  DTAARA(CGTELLER (55 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGTELLER (65 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGTELLER (75 6)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 21 6)) VALUE(%SST(&TEMP 1 6))
             CHGVAR     VAR(&FORMAT) VALUE('JOBI0200')
/**/
/* If job specified */
/**/
             IF         COND(&JOB26 *NE ' ') THEN(DO)
             CALL       PGM(CGC5216) PARM(&RTN_CODE &JOB_INFO +
                          &FORMAT &JOB26 &INT_JOB_ID)
/**/
/* If jobq then *IMMED */
/**/
             IF         COND((%SST(&JOB_INFO 51 10) *EQ '*JOBQ  ') +
                        ) THEN(DO)
             RTVDTAARA  DTAARA(CGTELLER (55 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(CGTELLER (65 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(CGTELLER (75 6)) RTNVAR(&JOBNBR)
             ENDJOB     JOB(&JOBNBR/&USER/&JOB) OPTION(*IMMED)
             MONMSG     MSGID(CPF1362 CPF1363 CPF1361 CPF1352)
             GOTO       CMDLBL(ALCOBJ)
             ENDDO
             ENDDO
/**/
/* Delete data queue */
/**/
             DLTDTAQ    DTAQ(&DILIB/CGTELLER)
             CHGDTAARA  DTAARA(CGTELLER (55 26)) VALUE(' ')
/**/
             ENDDO
/* End 'End' */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             DMPCLPGM
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/CGTELLER *DTAQ *SHRUPD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC0522 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0522 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
