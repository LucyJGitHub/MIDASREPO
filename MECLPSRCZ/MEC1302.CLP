/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME FT IMM action test')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC1302  - ME FT IMM Extraction Control - Batch process     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. AR545296           Date 19Aug14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015            Date 18Apr02               */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408            Date 05May95               */
/*                      S01435            Date 21Sep93               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR545296 - STP job ends after running through items to be   */
/*                processed. The DTAQ to be cleared is invalid.      */
/*                Changed it from 'MSFTIMM' to 'MEFTIMM'.            */
/*                Applied fix 256943.                                */
/*       CPK015 - 4.01 packaging.  Use DPLIB and not DILIB.          */
/*       S01408 - Addition of core hook MEC1302MP1                   */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION &MSG_REF)
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
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG_REF) TYPE(*CHAR) LEN(8)
/************DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)                                */ /*CPK015*/
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
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1302 - ME FT IMM Extraction Test +
                          Action') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&MSG_REF) VALUE(' ')
/**/
/**Construct*DILIB**/ /*                                                               */ /*CPK015*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)                         */ /*CPK015*/
/************CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')                      */ /*CPK015*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MEC1302MP1                                          */
                                                                      /*S01408*/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/**Check*if*data*queue*exists**/                                                          /*CPK015*/
/**/
/**********  CALL       PGM(MEC1305) */                                                   /*CPK015*/
/**/
/* If action is Start */
/**/
             IF         COND(&ACTION *EQ 'Start     ') THEN(DO)
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
/************ALCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *EXCL)) WAIT(60)                     */ /*CPK015*/
             ALCOBJ     OBJ((MEFTIMM *DTAQ *EXCL)) WAIT(60)                               /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0222')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Change allocation to shared read */
/**/
/************ALCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *SHRUPD)) WAIT(0)                    */ /*CPK015*/
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *EXCL))                              */ /*CPK015*/
             ALCOBJ     OBJ((MEFTIMM *DTAQ *SHRUPD)) WAIT(0)                              /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *EXCL))                                        /*CPK015*/
/**/
/* Process is not active - if interactive submit to batch */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CALL       PGM(MEC1303) PARM(&RTN_CODE)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'MIN0222')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *SHRUPD))                            */ /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *SHRUPD))                                      /*CPK015*/
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
             RTVDTAARA  DTAARA(MEDTA (187 4)) RTNVAR(&DELAYA)
             IF         COND(&DELAYA *EQ '    ') THEN(DO)
             CHGVAR     VAR(&DELAY_TIME) VALUE(5)
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
/*RDTAQ:*****CALL       PGM(QRCVDTAQ) PARM('MEFTIMM' &DILIB &FLDLEN +                  */ /*CPK015*/
/************             &DATA &WAIT &ORDER &KEY_LEN &KEY +                           */ /*CPK015*/
/************             &SNDR_LEN &SNDR)                                             */ /*CPK015*/
RDTAQ:                                                                                    /*CPK015*/
             CALL       PGM(QRCVDTAQ) PARM('MEFTIMM' '*LIBL' &FLDLEN +
                          &DATA &WAIT &ORDER &KEY_LEN &KEY +
                          &SNDR_LEN &SNDR)                                                /*CPK015*/
/**/
/* No information */
/**/
             IF         COND(&FLDLEN *EQ 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0224')
             ENDDO
/**/
/* Information */
/**/
             IF         COND(&FLDLEN *GT 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0225')
/**/
/* Close down requested */
/**/
             IF         COND(%SST(&DATA 1 3) *EQ 'End') THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0223')
             RETURN
             ENDDO
             CHGVAR     VAR(&MSG_REF) VALUE(%SST(&DATA 1 8))
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
             IF         COND(&RTN_CODE *EQ 'MIN0224') THEN(DO)
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
/*ADTAQ:*****CALL       PGM(QRCVDTAQ) PARM('MEFTIMM' &DILIB &FLDLEN +                  */ /*CPK015*/
/************             &DATA &WAIT &ORDER &KEY_LEN &KEY +                           */ /*CPK015*/
/************             &SNDR_LEN &SNDR)                                             */ /*CPK015*/
 ADTAQ:                                                                                   /*CPK015*/
             CALL       PGM(QRCVDTAQ) PARM('MEFTIMM' '*LIBL' &FLDLEN +
                          &DATA &WAIT &ORDER &KEY_LEN &KEY +
                          &SNDR_LEN &SNDR)                                                /*CPK015*/
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
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0225')
/**/
/* Close down requested */
/**/
             IF         COND(%SST(&DATA 1 3) *EQ 'End') THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0223')
             RETURN
             ENDDO
             CHGVAR     VAR(&MSG_REF) VALUE(%SST(&DATA 1 8))
             ENDDO
             GOTO       CMDLBL(ADTAQ)
             ENDDO
/* End 'Next' */
             ENDDO
/**/
/* If action is Re-submit */
/**/
             IF         COND(&ACTION *EQ 'Re-submit ') THEN(DO)
             CALL       PGM(MEC1303) PARM(&RTN_CODE)
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *SHRUPD))                            */ /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *SHRUPD))                                      /*CPK015*/
             ENDDO
/**/
/* If action is End */
/**/
             IF         COND(&ACTION *EQ 'End       ') THEN(DO)
/**/
/* Allocate data queue *SHRUPD to see if process active */
/**/
/************ALCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *SHRUPD)) WAIT(0)                    */ /*CPK015*/
             ALCOBJ     OBJ((MEFTIMM *DTAQ *SHRUPD)) WAIT(0)                              /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process cannot be killed re-try later */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0226')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Send data queue entry to End process */
/**/
             CHGVAR     VAR(&DATA) VALUE(' ')
             CHGVAR     VAR(&DATA) VALUE('End')
/************CALL       PGM(QSNDDTAQ) PARM('MEFTIMM' &DILIB &FLDLEN +                  */ /*CPK015*/
/************             &DATA &KEY_LEN 'End       ')                                 */ /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('MEFTIMM' '*LIBL' &FLDLEN +
                          &DATA &KEY_LEN 'End       ')                                    /*CPK015*/
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'MIN0220' +
                          'MEMSG    ' &MSGDTA '          ' ' ' +
                          'MEC1302' 'Y')
             ENDDO
/**/
/* Try to allocate data queue *EXCL */
/**/
/*ALCOBJ:****ALCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *EXCL)) WAIT(120)                    */ /*CPK015*/
ALCOBJ:                                                                                   /*CPK015*/
             ALCOBJ     OBJ((MEFTIMM *DTAQ *EXCL)) WAIT(120)                              /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Check activity of job submitted */
/**/
             RTVDTAARA  DTAARA(MEDTA (191 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEDTA (201 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEDTA (211 6)) RTNVAR(&TEMP)
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
/* Kill process defined in MEDTA */
/**/
             RTVDTAARA  DTAARA(MEDTA (191 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(MEDTA (201 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(MEDTA (211 6)) RTNVAR(&JOBNBR)
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CHGVAR     VAR(&MSGDTA) VALUE(&JOB *CAT &USER *CAT +
                          &JOBNBR)
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'MIN0221' +
                          'MEMSG    ' &MSGDTA '          ' ' ' +
                          'MEC1302' 'Y')
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
             RTVDTAARA  DTAARA(MEDTA (191 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEDTA (201 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEDTA (211 6)) RTNVAR(&TEMP)
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
             RTVDTAARA  DTAARA(MEDTA (191 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(MEDTA (201 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(MEDTA (211 6)) RTNVAR(&JOBNBR)
             ENDJOB     JOB(&JOBNBR/&USER/&JOB) OPTION(*IMMED)
             MONMSG     MSGID(CPF1362 CPF1363 CPF1361 CPF1352)
             GOTO       CMDLBL(ALCOBJ)
             ENDDO
             ENDDO
/**/
/* Delete data queue */
/**/
/************DLTDTAQ    DTAQ(&DILIB/MEFTIMM)                                           */ /*CPK015*/
/**********  CALL       PGM(QCLRDTAQ) PARM('MSFTIMM' '*LIBL ')                */ /*CPK015 AR545296*/
             CALL       PGM(QCLRDTAQ) PARM('MEFTIMM' '*LIBL ')                          /*AR545296*/
             CHGDTAARA  DTAARA(MEDTA (191 26)) VALUE(' ')
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
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *EXCL))                              */ /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *EXCL))                                        /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *SHRUPD))                            */ /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *SHRUPD))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1302 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1302 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
