/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CASH Reconciliation - Event Analysis')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4142  - RE CASH Reconciliation - Event Analysis          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CPK015             Date 26Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 148202             Date 19NOV98              */
/*                      CCI001             Date 10NOV98              */
/*                      122060             Date 21Aug97              */
/*                      CRT002 *CREATE     Date  1Dec95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       148202 - Message should no longer be sent as it fills MRUNQ */
/*       CCI001 - Midas Cashier Enhancements - dtaq RECASH in XLIB   */
/*                not DILIB                                          */
/*       122060 - Drafts Issuance.  Remove re-submit processing.     */
/*       CRT002 - Retail Branch Access.                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &ACTION)
/**/
/* Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(10)
/*********** DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)            */ /*CCI001*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)                /*CCI001*/
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
/*********** DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)             */ /*122060*/
/*********** DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)             */ /*122060*/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
/*********** DCL        VAR(&TXT1) TYPE(*CHAR) LEN(132)            */ /*122060*/
/*********** DCL        VAR(&TXT2) TYPE(*CHAR) LEN(512)            */ /*122060*/
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
/**Send*Message*to*MRUNQ**/
/* */
/************SNDPGMMSG  MSG('REC4142 - RE CASH Reconciliation - + */  /*148202*/
/************************Event Analysis') TOMSGQ(MRUNQ)           */  /*148202*/
             CHGJOB     SWS(XXXXXX00)
/**/
/**Construct*DILIB**/                                                 /*CCI001*/
/**/
/*********** RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)     */ /*CCI001*/
/*********** CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')  */ /*CCI001*/
/*********** CHGVAR     VAR(&RTN_CODE) VALUE(' ')                  */ /*CCI001*/
/**/
/* Construct &XLIB */                                                 /*CCI001*/
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)        /*CCI001*/
             CHGVAR     VAR(&XLIB) VALUE(&DBPREFIX *CAT 'XLIB')       /*CCI001*/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')                     /*CCI001*/
/**/
/* Check if data queue exists */
/**/
/************CALL       PGM(REC4145)                                                   */ /*CPK015*/
/**/
/* If action is Start */
/**/
             IF         COND(&ACTION *EQ 'Start     ') THEN(DO)
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
/*********** ALCOBJ     OBJ((&DILIB/RECASH *DTAQ *EXCL)) WAIT(60)  */ /*CCI001*/
/************ALCOBJ     OBJ((&XLIB/RECASH *DTAQ *EXCL)) WAIT(60)               /*CCI001*/ /*CPK015*/
             ALCOBJ     OBJ((RE4144DRI *DTAQ *EXCL)) WAIT(60)                             /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('MRC0009')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Change allocation to shared read */
/**/
/*********** ALCOBJ     OBJ((&DILIB/RECASH *DTAQ *SHRUPD)) WAIT(0) */ /*CCI001*/
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *EXCL))           */ /*CCI001*/
/************ALCOBJ     OBJ((&XLIB/RECASH *DTAQ *SHRUPD)) WAIT(0)              /*CCI001*/ /*CPK015*/
/************DLCOBJ     OBJ((&XLIB/RECASH *DTAQ *EXCL))                        /*CCI001*/ /*CPK015*/
             ALCOBJ     OBJ((RE4144DRI *DTAQ *SHRUPD)) WAIT(0)                            /*CPK015*/
             DLCOBJ     OBJ((RE4144DRI *DTAQ *EXCL))                                      /*CPK015*/
/**/
/* Process is not active - if interactive submit to batch */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CALL       PGM(REC4143) PARM(&RTN_CODE)
             IF         COND((&RTN_CODE *NE '       ')  *AND +
                             (&RTN_CODE *NE 'MRC0009')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *SHRUPD))  */        /*CCI001*/
/************DLCOBJ     OBJ((&XLIB/RECASH *DTAQ *SHRUPD))                      /*CCI001*/ /*CPK015*/
             DLCOBJ     OBJ((RE4144DRI *DTAQ *SHRUPD))                                    /*CPK015*/
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
             RTVDTAARA  DTAARA(CASH (150 5)) RTNVAR(&DELAYA)
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
 /*TAQ:******CALL       PGM(QRCVDTAQ) PARM('RECASH' &DILIB &FLDLEN +
                          &DATA &WAIT)                         */     /*CCI001*/
/*RDTAQ:*****CALL       PGM(QRCVDTAQ) PARM('RECASH' &XLIB &FLDLEN +                       /*CPK015*/
/************             &DATA &WAIT)                                         /*CCI001*/ /*CPK015*/
 RDTAQ:      CALL       PGM(QRCVDTAQ) PARM('RE4144DRI' '*LIBL' &FLDLEN +
                          &DATA &WAIT)                                                    /*CPK015*/
/**/
/* No information */
/**/
             IF         COND(&FLDLEN *EQ 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MRC0011')
             ENDDO
/**/
/* Information */
/**/
             IF         COND(&FLDLEN *GT 0) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MRC0012')
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
/* Return */                                                          /*122060*/
/**Re-read*queue*for*ever**/                                          /*122060*/
/**/
             IF         COND(&RTN_CODE *EQ 'MRC0011') THEN(DO)
/*********** CHGVAR     VAR(&WAIT) VALUE(-1)                       */ /*122060*/
/*********** GOTO       CMDLBL(RDTAQ)                              */ /*122060*/
               RETURN                                                 /*122060*/
             ENDDO
/**/
/* Else read all information on data queue */
/* and exit */
/**/
             ELSE       CMD(DO)
             CHGVAR     VAR(&WAIT) VALUE(1)
/*DTAQ:******CALL       PGM(QRCVDTAQ) PARM('RECASH' &DILIB &FLDLEN +
                          &DATA &WAIT)                       */       /*CCI001*/
/*ADTAQ:*****CALL       PGM(QRCVDTAQ) PARM('RECASH' &XLIB &FLDLEN +                    */ /*CPK015*/
/************             &DATA &WAIT)                                         /*CCI001*/ /*CPK015*/
 ADTAQ:      CALL       PGM(QRCVDTAQ) PARM('RE4144DRI' '*LIBL' &FLDLEN +
                          &DATA &WAIT)                                                    /*CPK015*/
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
             CHGVAR     VAR(&RTN_CODE) VALUE('MRC0012')
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
/**If*action*is*Re-submit**/                                          /*122060*/
/**/
/*********** IF         COND(&ACTION *EQ 'Re-submit ') THEN(DO)    */ /*122060*/
/*********** CALL       PGM(REC4143) PARM(&RTN_CODE)               */ /*122060*/
/*********** IF         COND(&RTN_CODE *NE '       ') THEN(DO)     */ /*122060*/
/*********** GOTO       CMDLBL(ABNORMAL)                           */ /*122060*/
/*********** ENDDO                                                 */ /*122060*/
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *SHRUPD))         */ /*122060*/
/*********** ENDDO                                                 */ /*122060*/
/**/
/* If action is End */
/**/
             IF         COND(&ACTION *EQ 'End       ') THEN(DO)
/**/
/* Allocate data queue *SHRUPD to see if process active */
/**/
/*********** ALCOBJ     OBJ((&DILIB/RECASH *DTAQ *SHRUPD)) WAIT(0) */ /*CCI001*/
/************ALCOBJ     OBJ((&XLIB/RECASH *DTAQ *SHRUPD)) WAIT(0)              /*CCI001*/ /*CPK015*/
             ALCOBJ     OBJ((RE4144DRI *DTAQ *SHRUPD)) WAIT(0)                            /*CPK015*/
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
/*********** CALL       PGM(QSNDDTAQ) PARM('RECASH' &DILIB +
                          &FLDLEN &DATA)                       */     /*CCI001*/
/************CALL       PGM(QSNDDTAQ) PARM('RECASH' &XLIB +                               /*CPK015*/
/************             &FLDLEN &DATA)                                       /*CCI001*/ /*CPK015*/
             CALL       PGM(QSNDDTAQ) PARM('RE4144DRI' '*LIBL' &FLDLEN +
                          &DATA)                                                          /*CPK015*/
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'MRC0013' +
                          'MEMSG    ' &MSGDTA '          ' ' ' +
                          'REC4142' 'Y')
             ENDDO
/**/
/* Try to allocate data queue *EXCL */
/**/
/*LCOBJ:**** ALCOBJ     OBJ((&DILIB/RECASH *DTAQ *EXCL)) WAIT(120) */ /*CCI001*/
/*ALCOBJ:****ALCOBJ     OBJ((&XLIB/RECASH *DTAQ *EXCL)) WAIT(120)              /*CCI001*/ /*CPK015*/
 ALCOBJ:     ALCOBJ     OBJ((RE4144DRI *DTAQ *EXCL)) WAIT(120)                            /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Check activity of job submitted */
/**/
             RTVDTAARA  DTAARA(CASH (161 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CASH (171 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CASH (181 6)) RTNVAR(&TEMP)
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
/* Kill process defined in CASH */
/**/
             RTVDTAARA  DTAARA(CASH (161 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(CASH (171 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(CASH (181 6)) RTNVAR(&JOBNBR)
/**/
/* If termination is interactive then show info screen */
/**/
             RTVJOBA    TYPE(&TYPE)
             IF         COND(&TYPE *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(' ')
             CHGVAR     VAR(&MSGDTA) VALUE(&JOB *CAT &USER *CAT +
                          &JOBNBR)
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'MRC0014' +
                          'MEMSG    ' &MSGDTA '          ' ' ' +
                          'REC4142' 'Y')
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
             RTVDTAARA  DTAARA(CASH (161 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CASH (171 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB26 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CASH (181 6)) RTNVAR(&TEMP)
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
             RTVDTAARA  DTAARA(CASH (161 10)) RTNVAR(&JOB)
             RTVDTAARA  DTAARA(CASH (171 10)) RTNVAR(&USER)
             RTVDTAARA  DTAARA(CASH (181 6)) RTNVAR(&JOBNBR)
             ENDJOB     JOB(&JOBNBR/&USER/&JOB) OPTION(*IMMED)
             MONMSG     MSGID(CPF1362 CPF1363 CPF1361 CPF1352)
             GOTO       CMDLBL(ALCOBJ)
             ENDDO
             ENDDO
/**/
/* Delete data queue */
/**/
/*********** DLTDTAQ    DTAQ(&DILIB/RECASH)             */            /*CCI001*/
/************DLTDTAQ    DTAQ(&XLIB/RECASH)                                     /*CCI001*/ /*CPK015*/
             CALL       PGM(QCLRDTAQ) PARM(RE4144DRI '*LIBL')                             /*CPK015*/
             CHGDTAARA  DTAARA(CASH (161 26)) VALUE(' ')
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
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *EXCL)) */           /*CCI001*/
/************DLCOBJ     OBJ((&XLIB/RECASH *DTAQ *EXCL))                        /*CCI001*/ /*CPK015*/
             DLCOBJ     OBJ((RE4144DRI *DTAQ *EXCL))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *SHRUPD))*/          /*CCI001*/
/************DLCOBJ     OBJ((&XLIB/RECASH *DTAQ *SHRUPD))                      /*CCI001*/ /*CPK015*/
             DLCOBJ     OBJ((RE4144DRI *DTAQ *SHRUPD))                                    /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program REC4142 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4142 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
