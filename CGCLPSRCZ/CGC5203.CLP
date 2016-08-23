/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Submit CG PrtGen job')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5203  - Submit CG PrtGen job                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CSD053             Date 07Jul06              */
/*       Prev Amend No. CPK015             Date 29May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 123441             Date 09FEB98              */
/*                      S01522             Date 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD053 - Correspondence Manager Multilanguage Upgrade.      */
/*                - run UDC_PRTGEN with job CCSID retrieved from     */
/*                  SDCORMPD.                                        */
/*       CPK015 - R4.01 Packaging:                                   */
/*                - DTAQ CGPRTGEN is now a permanent object in the   */
/*                  DPLIB.                                           */
/*       123441 - Specify OUTQ parameter                             */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE)
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
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
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
             DCL        VAR(&CCSID) TYPE(*CHAR) LEN(8)                                    /*CSD053*/
/* */                                                                                     /*CSD053*/
/* Declare file SDCORMPD */                                                               /*CSD053*/
/* */                                                                                     /*CSD053*/
             DCLF       FILE(SDCORMPD)                                                    /*CSD053*/
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
             SNDPGMMSG  MSG('CGC5203 - Submit CG PrtGen Job') +
                          TOMSGQ(MRUNQ)
             CHGJOB     LOG(4 0 *MSG) SWS(XXXXXX00)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */                                                                                     /*CSD053*/
/* Get Job CCSID information */                                                           /*CSD053*/
/* */                                                                                     /*CSD053*/
             OVRDBF     FILE(SDCORMPD) SHARE(*NO)                                         /*CSD053*/
             RCVF                                                                         /*CSD053*/
             IF         COND(&CMJCCS *NE ' ') THEN(DO)                                    /*CSD053*/
             CHGVAR     VAR(&CCSID) VALUE(&CMJCCS)                                        /*CSD053*/
             ENDDO                                                                        /*CSD053*/
             ELSE       (DO)                                                              /*CSD053*/
             CHGVAR     VAR(&CCSID) VALUE('*CURRENT')                                     /*CSD053*/
             ENDDO                                                                        /*CSD053*/
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
/**/
/**Check*if*data*queue*exists**/                                                          /*CPK015*/
/**/
/**********  CALL       PGM(CGC5205) */                                                   /*CPK015*/
/**/
/* Check activity of job submitted */
/**/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&JOBNBR1)
             CHGVAR     VAR(&THIS_JOB) VALUE(&JOB1 *CAT &USER1 *CAT +
                          &JOBNBR1)
             RTVDTAARA  DTAARA(CGDTA  (55 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA  (65 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA  (75 6)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 21 6)) VALUE(%SST(&TEMP 1 6))
             CHGVAR     VAR(&FORMAT) VALUE('JOBI0200')
             IF         COND((&JOB *NE ' ')    *AND +
                             (&JOB *NE &THIS_JOB)) THEN(DO)
             CALL       PGM(CGC5216) PARM(&RTN_CODE &JOB_INFO +
                          &FORMAT &JOB &INT_JOB_ID)
/**/
/* If active say so or on jobq say so */
/**/
             IF         COND(&RTN_CODE *NE 'CGP1007') THEN(DO)
             IF         COND((%SST(&JOB_INFO 51 10) *EQ '*ACTIVE') *OR +
                             (%SST(&JOB_INFO 51 10) *EQ '*JOBQ  ') +
                        ) THEN(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1000')
             RETURN
             ENDDO
             ENDDO
             ENDDO
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**********  ALCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *EXCL)) WAIT(60) */                    /*CPK015*/
             ALCOBJ     OBJ((CGPRTGEN *DTAQ *EXCL)) WAIT(60)                              /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1009')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Change allocation to shared read */
/**/
/**********  ALCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *SHRUPD)) WAIT(0) */                   /*CPK015*/
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *EXCL)) */                             /*CPK015*/
             ALCOBJ     OBJ((CGPRTGEN *DTAQ *SHRUPD)) WAIT(0)                             /*CPK015*/
             DLCOBJ     OBJ((CGPRTGEN *DTAQ *EXCL))                                       /*CPK015*/
/**/
/* Remove messages to allow read of completion message */
/**/
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/*           SBMJOB     CMD(CALL PGM(CGC5201)) JOB(UDC_PRTGEN) +
                          JOBD(CGJOBD) JOBQ(CGJOBQ) USER(*JOBD) +
                          RTGDTA(UDC) INLLIBL(*JOBD) MSGQ(MOPERQ)       123441*/
/**********  SBMJOB     CMD(CALL PGM(CGC5201)) JOB(UDC_PRTGEN) +     */                   /*CSD053*/
/**********               JOBD(CGJOBD) JOBQ(CGJOBQ) OUTQ(*JOBD) +    */                   /*CSD053*/
/**********               USER(*JOBD) RTGDTA(UDC) INLLIBL(*JOBD) +   */                   /*CSD053*/
/**********               MSGQ(MOPERQ)                               */            /*123441 CSD053*/
             SBMJOB     CMD(CALL PGM(CGC5201)) JOB(UDC_PRTGEN) +
                          JOBD(CGJOBD) JOBQ(CGJOBQ) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(UDC) INLLIBL(*JOBD) +
                          MSGQ(MOPERQ) CCSID(&CCSID)                                      /*CSD053*/
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID)
/**/
/* Retrieve job information and store on CGDTA */
/* If no completion message then end in error */
/**/
             IF         COND(&MSGID *EQ 'CPC1221') THEN(DO)
             CHGDTAARA  DTAARA(CGDTA  (55 10)) VALUE(%SST(&MSGDTA 1 +
                          10))
             CHGDTAARA  DTAARA(CGDTA  (65 10)) VALUE(%SST(&MSGDTA 11 +
                          10))
             CHGDTAARA  DTAARA(CGDTA  (75 6)) VALUE(%SST(&MSGDTA 21 +
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
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *EXCL)) */                             /*CPK015*/
             DLCOBJ     OBJ((CGPRTGEN *DTAQ *EXCL))                                       /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *SHRUPD)) */                           /*CPK015*/
             DLCOBJ     OBJ((CGPRTGEN *DTAQ *SHRUPD))                                     /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5203 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5203 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**********  DLCOBJ     OBJ((&DILIB/CGPRTGEN *DTAQ *SHRUPD)) */                           /*CPK015*/
             DLCOBJ     OBJ((CGPRTGEN *DTAQ *SHRUPD))                                     /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
