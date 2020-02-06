/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Submit UDC IMMEDS extraction job')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5213  - Submit CG IMMEDS Extraction job                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6604            Date 20Apr05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 28May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      123441             Date 09FEB98              */
/*                      083770             DATE 13FEB95              */
/*                      S01522             DATE 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG6604- Remove RCLRSC from this program                    */
/*       CPK015 - R4.01 Packaging:                                   */
/*                - DTAQ CGIMMED is now a permanent object in the    */
/*                  DPLIB.                                           */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       123441 - Specify OUTQ parameter                             */
/*       083770 - Change job name to UDC_IMMEDS                      */
/*       S01522 - User Defined Correspondence                        */
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
             SNDPGMMSG  MSG('CGC5213 - Submit CG IMMEDS Extraction +
                          Job') TOMSGQ(MRUNQ)
             CHGJOB     LOG(4 0 *MSG) SWS(XXXXXX00)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
/**/
/**Check*if*data*queue*exists**/                                                          /*CPK015*/
/**/
/**********  CALL       PGM(CGC5215) */                                                   /*CPK015*/
/**/
/* Check activity of job submitted */
/**/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&JOBNBR1)
             CHGVAR     VAR(&THIS_JOB) VALUE(&JOB1 *CAT &USER1 *CAT +
                          &JOBNBR1)
             RTVDTAARA  DTAARA(CGDTA  (86 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA  (96 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA  (106 6)) RTNVAR(&TEMP)
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
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1010')
             RETURN
             ENDDO
             ENDDO
             ENDDO
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**********  ALCOBJ     OBJ((&DILIB/CGIMMED *DTAQ *EXCL)) WAIT(60) */                     /*CPK015*/
             ALCOBJ     OBJ((CGIMMED *DTAQ *EXCL)) WAIT(60)                               /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('CGP1011')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Change allocation to shared read */
/**/
/**********  ALCOBJ     OBJ((&DILIB/CGIMMED *DTAQ *SHRUPD)) WAIT(0) */                    /*CPK015*/
/**********  DLCOBJ     OBJ((&DILIB/CGIMMED *DTAQ *EXCL)) */                              /*CPK015*/
             ALCOBJ     OBJ((CGIMMED *DTAQ *SHRUPD)) WAIT(0)                              /*CPK015*/
             DLCOBJ     OBJ((CGIMMED *DTAQ *EXCL))                                        /*CPK015*/
/**/
/* Remove messages to allow read of completion message */
/**/
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/*           SBMJOB     CMD(CALL PGM(CGC5211)) JOB(CG_IMMEDS) +        *083770*/
/*                        JOBD(CGJOBD) JOBQ(CGJOBQ) +                  *083770*/
/*                        RTGDTA(UDC) INLLIBL(*JOBD) MSGQ(MOPERQ)      *083770*/
/*           SBMJOB     CMD(CALL PGM(CGC5211)) JOB(UDC_IMMEDS) +        123441*/
/*                        JOBD(CGJOBD) JOBQ(CGJOBQ) RTGDTA(UDC) +       123441*/
/*                        INLLIBL(*JOBD) MSGQ(MOPERQ)         /*083770  123441*/
/************SBMJOB     CMD(CALL PGM(CGC5211)) JOB(UDC_IMMEDS) +                          /*CPK014*/
/************             JOBD(CGJOBD) JOBQ(CGJOBQ) OUTQ(*JOBD) +                         /*CPK014*/
/************             RTGDTA(UDC) INLLIBL(*JOBD) MSGQ(MOPERQ)     /*123441*/          /*CPK014*/
             SBMJOB     CMD(CALL PGM(CGC5211)) JOB(UDC_IMMEDS) +
                          JOBD(CGJOBD) JOBQ(CGJOBQ) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(UDC) INLLIBL(*JOBD) +
                          MSGQ(MOPERQ)                                                    /*CPK014*/
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID)
/**/
/* Retrieve job information and store on CGDTA */
/* If no completion message then end in error */
/**/
             IF         COND(&MSGID *EQ 'CPC1221') THEN(DO)
             CHGDTAARA  DTAARA(CGDTA  (86 10)) VALUE(%SST(&MSGDTA 1 +
                          10))
             CHGDTAARA  DTAARA(CGDTA  (96 10)) VALUE(%SST(&MSGDTA 11 +
                          10))
             CHGDTAARA  DTAARA(CGDTA  (106 6)) VALUE(%SST(&MSGDTA 21 +
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
/**********  DLCOBJ     OBJ((&DILIB/CGIMMED *DTAQ *EXCL)) */                              /*CPK015*/
             DLCOBJ     OBJ((CGIMMED *DTAQ *EXCL))                                        /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**********  DLCOBJ     OBJ((&DILIB/CGIMMED *DTAQ *SHRUPD)) */                            /*CPK015*/
             DLCOBJ     OBJ((CGIMMED *DTAQ *SHRUPD))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5213 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5213 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:                                                                               /*BUG6604*/
/***** ENDCLPGM:   RCLRSC     LVL(*CALLER)  *******/                                     /*BUG6604*/
/*******     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG6604*/
/**********  DLCOBJ     OBJ((&DILIB/CGIMMED *DTAQ *SHRUPD)) */                            /*CPK015*/
             DLCOBJ     OBJ((CGIMMED *DTAQ *SHRUPD))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
