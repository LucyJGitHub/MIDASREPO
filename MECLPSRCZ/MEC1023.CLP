/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME Submit MS ME IMM extraction job')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MEC1023  - Submit MS ME IMM Extraction job                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD043618           Date 07Dec17              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD027770           Date 27Jun14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC023             Date 30Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 18Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 05MAY95              */
/*                      S01435             DATE 19AUG93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD043618 - Job ME_FT_IMM when started manually it is        */
/*                  submitted  with user’s profile and not system    */
/*                  owner profile -Formalization of onsite fix.      */
/*       MD046248 - Finastra Rebranding                              */
/*       MD027770 - Job ME_FT_IMM dumps due to xxOWNER not found     */
/*                  in MUSER. Use the current user in SBMJOB command */
/*                  as xxOWNER is no longer added to file MUSER.     */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK015 - 4.01 packaging.  Use DPLIB and not DILIB.          */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       S01408 - Addition of core hook MEC1023MP1                   */
/*       S01435 - Incoming Message Management                        */
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
                          Finastra International Limited')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1023 - Submit MS ME IMM Extraction +
                          Job') TOMSGQ(MRUNQ)
             CHGJOB     LOG(4 0 *MSG) SWS(XXXXXX00)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/**Construct*DILIB**/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)                         */ /*CPK015*/
/************CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')                      */ /*CPK015*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MEC1023MP1                                          */
                                                                      /*S01408*/
/**/
/* Check if data queue exists */
/**/
/************CALL       PGM(MEC1025)                                                   */ /*CPK015*/
/**/
/* Check activity of job submitted */
/**/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&JOBNBR1)
             CHGVAR     VAR(&THIS_JOB) VALUE(&JOB1 *CAT &USER1 *CAT +
                          &JOBNBR1)
             RTVDTAARA  DTAARA(MEDTA  (161 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEDTA  (171 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEDTA  (181 6)) RTNVAR(&TEMP)
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
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0123')
             RETURN
             ENDDO
             ENDDO
             ENDDO
/**/
/* Allocate data queue *EXCL to see if process active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/************ALCOBJ     OBJ((&DILIB/MSMEIMM *DTAQ *EXCL)) WAIT(60)                     */ /*CPK015*/
             ALCOBJ     OBJ((MSMEIMM *DTAQ *EXCL)) WAIT(60)                               /*CPK015*/
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/* Process already active */
/**/
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0124')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/**/
/* Change allocation to shared read */
/**/
/************ALCOBJ     OBJ((&DILIB/MSMEIMM *DTAQ *SHRUPD)) WAIT(0)                    */ /*CPK015*/
/************DLCOBJ     OBJ((&DILIB/MSMEIMM *DTAQ *EXCL))                              */ /*CPK015*/
             ALCOBJ     OBJ((MSMEIMM *DTAQ *SHRUPD)) WAIT(0)                              /*CPK015*/
             DLCOBJ     OBJ((MSMEIMM *DTAQ *EXCL))                                        /*CPK015*/
/**/
/* Remove messages to allow read of completion message */
/**/
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/************SBMJOB     CMD(CALL PGM(MEC1021)) JOB(MS_ME_IMM) +                           /*CPK014*/
/************             JOBD(MEJOBD) JOBQ(MEJOBQ) +                                     /*CPK014*/
/************             RTGDTA(MSMEIMM) INLLIBL(*JOBD) MSGQ(MOPERQ)                     /*CPK014*/
/************SBMJOB     CMD(CALL PGM(MEC1021)) JOB(MS_ME_IMM) +                           /*CSC023*/
/************             JOBD(MEJOBD) JOBQ(MEJOBQ) USER(*JOBD) +                         /*CSC023*/
/************             RTGDTA(MSMEIMM) INLLIBL(*JOBD) MSGQ(MOPERQ)          /*CPK014*/ /*CSC023*/
/************SBMJOB     CMD(CALL PGM(MEC1021)) JOB(MS_ME_IMM) +      */                 /*MD027770*/
/************             JOBD(MEJOBD) JOBQ(MEJOBQ) USER(*JOBD) +    */                 /*MD027770*/
/************             RTGDTA(MSMEIMM) INLLIBL(*JOBD) MSGQ(MOPERQ) +                 /*MD027770*/
/************             OUTQ(*JOBD)                                */          /*CSC023 MD027770*/
/**********  SBMJOB     CMD(CALL PGM(MEC1021)) JOB(MS_ME_IMM) +
/**********               JOBD(MEJOBD) JOBQ(MEJOBQ) USER(*CURRENT) +
/**********               RTGDTA(MSMEIMM) INLLIBL(*JOBD) +
/**********               MSGQ(MOPERQ) OUTQ(*JOBD)                             /*MD027770 MD043618*/
             SBMJOB     CMD(CALL PGM(MEC1021)) JOB(MS_ME_IMM) +
                          JOBD(MEJOBD) JOBQ(MEJOBQ) USER(*JOBD) +
                          RTGDTA(MSMEIMM) INLLIBL(*JOBD) +
                          MSGQ(MOPERQ) OUTQ(*JOBD)                                      /*MD043618*/
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID)
/**/
/* Retrieve job information and store on MEDTA */
/* If no completion message then end in error */
/**/
             IF         COND(&MSGID *EQ 'CPC1221') THEN(DO)
             CHGDTAARA  DTAARA(MEDTA  (161 10)) VALUE(%SST(&MSGDTA 1 +
                          10))
             CHGDTAARA  DTAARA(MEDTA  (171 10)) VALUE(%SST(&MSGDTA 11 +
                          10))
             CHGDTAARA  DTAARA(MEDTA  (181 6)) VALUE(%SST(&MSGDTA 21 +
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
/************DLCOBJ     OBJ((&DILIB/MSMEIMM *DTAQ *EXCL))                              */ /*CPK015*/
             DLCOBJ     OBJ((MSMEIMM *DTAQ *EXCL))                                        /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/MSMEIMM *DTAQ *SHRUPD))                            */ /*CPK015*/
             DLCOBJ     OBJ((MSMEIMM *DTAQ *SHRUPD))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1023 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1023 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/MSMEIMM *DTAQ *SHRUPD))                            */ /*CPK015*/
             DLCOBJ     OBJ((MSMEIMM *DTAQ *SHRUPD))                                      /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
