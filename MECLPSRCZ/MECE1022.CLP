/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME IMM Extraction Control - Batch process')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECE1022  - EE ME IMM Extraction Control - Batch process     */
/*                                                                   */
/*       (C) COPYRIGHT MKI LIMITED 1999.                             */
/*                                                                   */
/*       Last Amend No. MD031937           Date 13Jan15              */
/*       Prev Amend No. AR856737           Date 13Sep11              */
/*                      ESL038             Date 01Oct2004            */
/*                      EAH080             Date 17May99              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD031937 - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*       ESL038 - ING STP Development                                */
/*       EAH080 - Generic Incoming Interface                         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&MKI_CPY_@) TYPE(*CHAR) LEN(80) +
                          VALUE('(C) COPYRIGHT MKI 1999. Company +
                          Confidential.')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FLDLEN) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DELAY_TIME) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DELAYA) TYPE(*CHAR) LEN(5)
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
             CHGVAR     VAR(&MKI_CPY_@) VALUE('(C) COPYRIGHT MKI Ltd +
                          1999.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MECE1022 - EE ME IMM Extraction Test +
                          Action') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/* Check if data queue exists */
/**/
             CALL       PGM(MECE1025)
/**/
/* If action is Start */
/**/
             IF         COND(&ACTION *EQ 'Start     ') THEN(DO)
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
             ALCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL)) WAIT(60)
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0123')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Change allocation to shared read */
/**/
             ALCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *SHRUPD)) WAIT(0)
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL))
/**/
/* Process is not active - if interactive submit to batch */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CALL       PGM(MECE1023) PARM(&RTN_CODE)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'MIN0123')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *SHRUPD))
             ENDDO
/* End 'Start' */
             ENDDO
/**/
/* If action is Next */
/**/
             IF         COND(&ACTION *EQ 'Next      ') THEN(DO)
/* */
/* Set count and delay time */
/* If delay time not set, set to 5 minutes */
/* */
             RTVDTAARA  DTAARA(MEEDTA (150 5)) RTNVAR(&DELAYA)
             IF         COND(&DELAYA *EQ '     ') THEN(DO)
             CHGVAR     VAR(&DELAY_TIME) VALUE(300)
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&DELAY_TIME) VALUE(&DELAYA)
             ENDDO
/**/
/* Read data queue for next prompt for action */
/**/
             CHGVAR     VAR(&WAIT) VALUE(1)
 RDTAQ:      CALL       PGM(QRCVDTAQ) PARM('EEMEIMM' &DILIB &FLDLEN +
                          &DATA &WAIT)
/**/
/* No information */
/**/
             IF         COND(&FLDLEN *EQ 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0126')
             ENDDO
/**/
/* Information */
/**/
             IF         COND(&FLDLEN *GT 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0127')
/**/
/* Close down requested */
/**/
             IF         COND(%SST(&DATA 1 3) *EQ 'End') THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0128')
             RETURN
             ENDDO
             ENDDO
/**/
/* Delay job by wait time (first time only) */
/**/
             IF         COND(&WAIT *GE 0) THEN(DO)
             DLYJOB     DLY(&DELAY_TIME)
             ENDDO
/**/
/* If no information from prior read of data queue */
/* Re-read queue for ever */
/**/
             IF         COND(&RTN_CODE *EQ 'MIN0126') THEN(DO)
             CHGVAR     VAR(&WAIT) VALUE(-1)
             GOTO       CMDLBL(RDTAQ)
             ENDDO
/**/
/* Else read all information on data queue */
/* and exit */
/**/
             ELSE       CMD(DO)
             CHGVAR     VAR(&WAIT) VALUE(1)
 ADTAQ:      CALL       PGM(QRCVDTAQ) PARM('EEMEIMM' &DILIB &FLDLEN +
                          &DATA &WAIT)
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
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0127')
/**/
/* Close down requested */
/**/
             IF         COND(%SST(&DATA 1 3) *EQ 'End') THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0128')
             RETURN
             ENDDO
             ENDDO
             GOTO       CMDLBL(ADTAQ)
             ENDDO
/* End 'Next' */
             ENDDO
/**/
/* If action is Re-submit */
/**/
             IF         COND(&ACTION *EQ 'Re-submit ') THEN(DO)
             CALL       PGM(MECE1023) PARM(&RTN_CODE)
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *SHRUPD))
             ENDDO
/**/
/* If action is End */
/**/
             IF         COND(&ACTION *EQ 'End       ') THEN(DO)
/**/
/* Allocate data queue *SHRUPD to see if process active */
/**/
             ALCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *SHRUPD)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process cannot be killed re-try later */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0129')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Send data queue entry to End process */
/**/
             CHGVAR     VAR(&DATA) VALUE(' ')
             CHGVAR     VAR(&DATA) VALUE('End')
             CALL       PGM(QSNDDTAQ) PARM('EEMEIMM' &DILIB +
                          &FLDLEN &DATA)
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'MIN0134' +
                          'MEMSG    ' &MSGDTA '          ' ' ' +
                          'MECE1022' 'Y')
             ENDDO
/**/
/* Try to allocate data queue *EXCL */
/**/
 ALCOBJ:     ALCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL)) WAIT(120)
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Check activity of job submitted */
/**/
             RTVDTAARA  DTAARA(MEEDTA (161 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEEDTA (171 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEEDTA (181 6)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 21 6)) VALUE(%SST(&TEMP 1 6))
             CHGVAR     VAR(&FORMAT) VALUE('JOBI0200')
             CALL       PGM(MEC1026) PARM(&RTN_CODE &JOB_INFO +
                          &FORMAT &JOB26 &INT_JOB_ID)
/**/
/* If inactive end in error */
/**/
             IF         COND((&RTN_CODE *EQ 'MIN0125') *OR +
                             (%SST(&JOB_INFO 51 10) *EQ '*OUTQ  ') +
                        ) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
/* Kill process defined in MEEDTA */
/**/
             RTVDTAARA  DTAARA(MEEDTA (161 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(MEEDTA (171 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(MEEDTA (181 6)) RTNVAR(&JOBNBR)
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CHGVAR     VAR(&MSGDTA) VALUE(&JOB *CAT &USER *CAT +
                          &JOBNBR)
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'MIN0135' +
                          'MEMSG    ' &MSGDTA '          ' ' ' +
                          'MECE1022' 'Y')
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
             RTVDTAARA  DTAARA(MEEDTA (161 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEEDTA (171 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEEDTA (181 6)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 21 6)) VALUE(%SST(&TEMP 1 6))
             CHGVAR     VAR(&FORMAT) VALUE('JOBI0200')
/**/
/* If job specified */
/**/
             IF         COND(&JOB26 *NE ' ') THEN(DO)
             CALL       PGM(MEC1026) PARM(&RTN_CODE &JOB_INFO +
                          &FORMAT &JOB26 &INT_JOB_ID)
/**/
/* If jobq then *IMMED */
/**/
             IF         COND((%SST(&JOB_INFO 51 10) *EQ '*JOBQ  ') +
                        ) THEN(DO)
             RTVDTAARA  DTAARA(MEEDTA (161 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(MEEDTA (171 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(MEEDTA (181 6)) RTNVAR(&JOBNBR)
             ENDJOB     JOB(&JOBNBR/&USER/&JOB) OPTION(*IMMED)
             MONMSG     MSGID(CPF1362 CPF1363 CPF1361 CPF1352)
             GOTO       CMDLBL(ALCOBJ)
             ENDDO
             ENDDO
/**/
/* Delete data queue */
/**/
             DLTDTAQ    DTAQ(&DILIB/EEMEIMM)
             CHGDTAARA  DTAARA(MEEDTA (161 26)) VALUE(' ')
/**/
             ENDDO
/* End 'End' */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *SHRUPD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MECE1022 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MECE1022 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
