/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Submit ME CASH reconcilition job')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4143  - Submit RE CASH Reconciliation                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 26Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCI001             Date 10NOV98              */
/*                      122060             Date 29Aug97              */
/*                      CRT002 *CREATE     Date  1Dec95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CCI001 - Midas Cashier Enhancements - dtaq RECASH in XLIB   */
/*                not DILIB                                          */
/*       122060 - Drafts Issuance.                                   */
/*       CRT002 - Retail Branch Access.                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
/*********** DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)            */ /*CCI001*/
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)                /*CCI001*/
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TEMP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB_INFO) TYPE(*CHAR) LEN(512)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(26)
             DCL        VAR(&INT_JOB_ID) TYPE(*CHAR) LEN(16)
             DCL        VAR(&JOB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNBR1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&THIS_JOB) TYPE(*CHAR) LEN(26)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('REC4143 - Submit RE CASH +
                          Reconciliation Job') TOMSGQ(MRUNQ)
             CHGJOB     LOG(4 0 *MSG) SWS(XXXXXX00)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/**Construct*DILIB**************************************************/ /*CCI001*/
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
/* Check activity of job submitted */
/**/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&JOBNBR1)
             CHGVAR     VAR(&THIS_JOB) VALUE(&JOB1 *CAT &USER1 *CAT +
                          &JOBNBR1)
             RTVDTAARA  DTAARA(CASH  (161 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CASH  (171 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CASH  (181 6)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 21 6)) VALUE(%SST(&TEMP 1 6))
             CHGVAR     VAR(&FORMAT) VALUE('JOBI0200')
             IF         COND((&JOB *NE ' ')    *AND +
                             (&JOB *NE &THIS_JOB)) THEN(DO)
             CALL       PGM(MEC1026) PARM(&RTN_CODE &JOB_INFO +
                          &FORMAT &JOB &INT_JOB_ID)
/**/
/* If active say so or on jobq say so */
/**/
             IF         COND(&RTN_CODE *NE 'MIN0125') THEN(DO)
             IF         COND((%SST(&JOB_INFO 51 10) *EQ '*ACTIVE') *OR +
                             (%SST(&JOB_INFO 51 10) *EQ '*JOBQ  ') +
                        ) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('MRC0009')
             RETURN
             ENDDO
             ENDDO
             ENDDO
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/*********** ALCOBJ     OBJ((&DILIB/RECASH *DTAQ *EXCL)) WAIT(60)  */ /*CCI001*/
/************ALCOBJ     OBJ((&XLIB/RECASH *DTAQ *EXCL)) WAIT(60)               /*CCI001*/ /*CPK015*/
             ALCOBJ     OBJ((RE4144DRI *DTAQ *EXCL)) WAIT(60)                             /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('MRC0010')
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
/* Remove messages to allow read of completion message */
/**/
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/************SBMJOB     CMD(CALL PGM(REC4141)) JOB(CASH_REC) +                            /*CPK014*/
/************             JOBD(MEJOBD) JOBQ(MEJOBQ) RTGDTA('IMM +                         /*CPK014*/
/************             CASHIER') INLLIBL(*JOBD) MSGQ(MOPERQ) +                         /*CPK014*/
/************             LOG(4)                                      /*122060*/          /*CPK014*/
/***********              CASHIER') INLLIBL(*JOBD) MSGQ(MOPERQ)    */ /*122060*/
/************SBMJOB     CMD(CALL PGM(REC4141)) JOB(CASH_REC) +                            /*CSC023*/
/************             JOBD(MEJOBD) JOBQ(MEJOBQ) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA('IMM CASHIER') INLLIBL(*JOBD) +                          /*CSC023*/
/************             LOG(4) MSGQ(MOPERQ)                                  /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(REC4141)) JOB(CASH_REC) +
                          JOBD(MEJOBD) JOBQ(MEJOBQ) USER(*JOBD) +
                          RTGDTA('IMM CASHIER') INLLIBL(*JOBD) +
                          LOG(4) MSGQ(MOPERQ) OUTQ(*JOBD)                                 /*CSC023*/
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID)
/**/
/* Retrieve job information and store on CASH */
/* If no completion message then end in error */
/**/
             IF         COND(&MSGID *EQ 'CPC1221') THEN(DO)
             CHGDTAARA  DTAARA(CASH  (161 10)) VALUE(%SST(&MSGDTA 1 +
                          10))
             CHGDTAARA  DTAARA(CASH  (171 10)) VALUE(%SST(&MSGDTA 11 +
                          10))
             CHGDTAARA  DTAARA(CASH  (181 6)) VALUE(%SST(&MSGDTA 21 +
                          6))
             ENDDO
             ELSE       CMD(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *EXCL))    */        /*CCI001*/
/************DLCOBJ     OBJ((&XLIB/RECASH *DTAQ *EXCL))                        /*CCI001*/ /*CPK015*/
             DLCOBJ     OBJ((RE4144DRI *DTAQ *EXCL))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *SHRUPD))  */        /*CCI001*/
/************DLCOBJ     OBJ((&XLIB/RECASH *DTAQ *SHRUPD))                      /*CCI001*/ /*CPK015*/
             DLCOBJ     OBJ((RE4144DRI *DTAQ *SHRUPD))                                    /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program REC4143 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4143 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*********** DLCOBJ     OBJ((&DILIB/RECASH *DTAQ *SHRUPD))*/          /*CCI001*/
/************DLCOBJ     OBJ((&XLIB/RECASH *DTAQ *SHRUPD))                      /*CCI001*/ /*CPK015*/
             DLCOBJ     OBJ((RE4144DRI *DTAQ *SHRUPD))                                    /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
