/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME Submit ME FT IMM auto generation job')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC1303  - Submit ME FT IMM Auto Gen job                    */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD027770           Date 27Jun14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 30Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 18Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 05May95              */
/*                      S01435            Date 21Sep93               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD027770 - Job ME_FT_IMM dumps due to xxOWNER not found     */
/*                  in MUSER. Use the current user in SBMJOB command */
/*                  as xxOWNER is no longer added to file MUSER.     */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK015 - 4.01 packaging.  Use DPLIB and not DILIB.          */
/*       S01408 - Addition of core hook MEC1303MP1                   */
/*       S01435 - Incoming Message Management                        */
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
/************DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)                                */ /*CPK015*/
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
                          Misys International Banking Systems Ltd.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1303 - Submit ME FT IMM Auto Gen +
                          Job') TOMSGQ(MRUNQ)
             CHGJOB     LOG(4 0 *MSG) SWS(XXXXXX00)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/**Construct*DILIB**/ /*                                                               */ /*CPK015*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)                         */ /*CPK015*/
/************CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')                      */ /*CPK015*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MEC1303MP1                                          */
                                                                      /*S01408*/
/**/
/**Check*if*data*queue*exists**/                                                          /*CPK015*/
/**/
/**********  CALL       PGM(MEC1305)                                                      /*CPK015*/
/**/
/* Check activity of job submitted */
/**/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&JOBNBR1)
             CHGVAR     VAR(&THIS_JOB) VALUE(&JOB1 *CAT &USER1 *CAT +
                          &JOBNBR1)
             RTVDTAARA  DTAARA(MEDTA  (191 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEDTA  (201 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEDTA  (211 6)) RTNVAR(&TEMP)
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
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0222')
             RETURN
             ENDDO
             ENDDO
             ENDDO
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/************ALCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *EXCL)) WAIT(60)                     */ /*CPK015*/
             ALCOBJ     OBJ((MEFTIMM *DTAQ *EXCL)) WAIT(60)                               /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0227')
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
/* Remove messages to allow read of completion message */
/**/
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/************SBMJOB     CMD(CALL PGM(MEC1301)) JOB(ME_FT_IMM) +                           /*CSC023*/
/************             JOBD(MEFTJOBD) JOBQ(MEJOBQ) USER(*JOBD) +                       /*CSC023*/
/************             RTGDTA(MEFTIMM) INLLIBL(*JOBD) MSGQ(MOPERQ)                     /*CSC023*/
/************SBMJOB     CMD(CALL PGM(MEC1301)) JOB(ME_FT_IMM) +      */                 /*MD027770*/
/************             JOBD(MEFTJOBD) JOBQ(MEJOBQ) USER(*JOBD) +  */                 /*MD027770*/
/************             RTGDTA(MEFTIMM) INLLIBL(*JOBD) MSGQ(MOPERQ) +                 /*MD027770*/
/************             OUTQ(*JOBD)                                */          /*CSC023 MD027770*/
             SBMJOB     CMD(CALL PGM(MEC1301)) JOB(ME_FT_IMM) +
                          JOBD(MEFTJOBD) JOBQ(MEJOBQ) OUTQ(*JOBD) +
                          USER(*CURRENT) RTGDTA(MEFTIMM) +
                          INLLIBL(*JOBD) MSGQ(MOPERQ)                                   /*MD027770*/
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID)
/**/
/* Retrieve job information and store on MEDTA */
/* If no completion message then end in error */
/**/
             IF         COND(&MSGID *EQ 'CPC1221') THEN(DO)
             CHGDTAARA  DTAARA(MEDTA  (191 10)) VALUE(%SST(&MSGDTA 1 +
                          10))
             CHGDTAARA  DTAARA(MEDTA  (201 10)) VALUE(%SST(&MSGDTA 11 +
                          10))
             CHGDTAARA  DTAARA(MEDTA  (211 6)) VALUE(%SST(&MSGDTA 21 +
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
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *EXCL))                              */ /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *EXCL))                                        /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *SHRUPD))                            */ /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *SHRUPD))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1303 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1303 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/MEFTIMM *DTAQ *SHRUPD))                            */ /*CPK015*/
             DLCOBJ     OBJ((MEFTIMM *DTAQ *SHRUPD))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
