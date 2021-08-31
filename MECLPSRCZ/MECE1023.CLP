/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME IMM Extraction job')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Message Management Module                           */
/*                                                                   */
/*       MECE1023 - Submit EE ME IMM Extraction job                  */
/*                                                                   */
/*       (C) COPYRIGHT MKI LIMITED 1999.                             */
/*                                                                   */
/*       Last Amend No. MD031937           Date 13Jan15              */
/*       Prev Amend No. AR856737           Date 13Sep11              */
/*                      ESL038             Date 01Oct2004            */
/*                      EAH080   *CREATE   Date 17May99              */
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
             PGM        PARM(&RTN_CODE)
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
             CHGVAR     VAR(&MKI_CPY_@) VALUE('(C) COPYRIGHT MKI Ltd +
                          1999.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MECE1023 - Submit EE ME IMM Extraction +
                          Job') TOMSGQ(MRUNQ)
             CHGJOB     LOG(4 0 *MSG) SWS(XXXXXX00)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/* Construct DILIB */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)
             CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')
/**/
/* Check if data queue exists */
/**/
             CALL       PGM(MECE1025)
/**/
/* Check activity of job submitted */
/**/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&JOBNBR1)
             CHGVAR     VAR(&THIS_JOB) VALUE(&JOB1 *CAT &USER1 *CAT +
                          &JOBNBR1)
             RTVDTAARA  DTAARA(MEEDTA  (161 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEEDTA  (171 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(MEEDTA  (181 6)) RTNVAR(&TEMP)
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
             ALCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL)) WAIT(60)
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
             ALCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *SHRUPD)) WAIT(0)
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL))
/**/
/* Remove messages to allow read of completion message */
/**/
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
             SBMJOB     CMD(CALL PGM(MECE1021)) JOB(EE_ME_IMM) +
                          JOBD(HFJOBD) JOBQ(MEJOBQ) USER(*JOBD) +
                          RTGDTA(MSMEIMM) INLLIBL(*JOBD) MSGQ(MOPERQ)
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID)
/**/
/* Retrieve job information and store on MEEDTA */
/* If no completion message then end in error */
/**/
             IF         COND(&MSGID *EQ 'CPC1221') THEN(DO)
             CHGDTAARA  DTAARA(MEEDTA  (161 10)) VALUE(%SST(&MSGDTA 1 +
                          10))
             CHGDTAARA  DTAARA(MEEDTA  (171 10)) VALUE(%SST(&MSGDTA 11 +
                          10))
             CHGDTAARA  DTAARA(MEEDTA  (181 6)) VALUE(%SST(&MSGDTA 21 +
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
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *EXCL))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *SHRUPD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MECE1023 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MECE1023 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((&DILIB/EEMEIMM *DTAQ *SHRUPD))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
