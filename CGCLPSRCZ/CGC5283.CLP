/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Submit bulk PrtGenbk job')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5283  - Submit CG PrtGenbk jobs                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK022             Date 08Jul05              */
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 18Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 28Apr95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK022 - MidasPlus additional packaging.  remove calling    */
/*                CGC5285.                                           */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK015 - 4.01 packaging.  Use DPLIB instead of DILIB.       */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &JOB_NAME &OFF_SET)
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
             DCL        VAR(&OFF_SET) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&JOB_OFF_ST) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&USR_OFF_ST) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&NBR_OFF_ST) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&JOB_NAME) TYPE(*CHAR) LEN(10)
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
             SNDPGMMSG  MSG('CGC5283 - Submit CG PrtGenbk Job') +
                          TOMSGQ(MRUNQ)
             CHGJOB     LOG(4 0 *MSG) SWS(XXXXXX00)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/**/
/**Construct*DILIB**/ /*                                                               */ /*CPK015*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&DBPREFIX)                         */ /*CPK015*/
/************CHGVAR     VAR(&DILIB) VALUE(&DBPREFIX *CAT 'DILIB')                      */ /*CPK015*/
/**/
/**Check*if*data*queue*exists**/                                                          /*CPK022*/
/**/
/**********  CALL       PGM(CGC5285) */                                                   /*CPK022*/
/**/
/* Check activity of job submitted */
/**/
             CHGVAR     VAR(&JOB_OFF_ST) VALUE(&OFF_SET)
             CHGVAR     VAR(&USR_OFF_ST) VALUE(&OFF_SET + 10)
             CHGVAR     VAR(&NBR_OFF_ST) VALUE(&OFF_SET + 20)
/**/
             RTVJOBA    JOB(&JOB1) USER(&USER1) NBR(&JOBNBR1)
             CHGVAR     VAR(&THIS_JOB) VALUE(&JOB1 *CAT &USER1 *CAT +
                          &JOBNBR1)
             RTVDTAARA  DTAARA(CGDTA (&JOB_OFF_ST 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 1 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA (&USR_OFF_ST 10)) RTNVAR(&TEMP)
             CHGVAR     VAR(%SST(&JOB 11 10)) VALUE(&TEMP)
             RTVDTAARA  DTAARA(CGDTA (&NBR_OFF_ST 6)) RTNVAR(&TEMP)
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
/************ALCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *EXCL)) WAIT(60)                 */ /*CPK015*/
             ALCOBJ     OBJ((&JOB_NAME *DTAARA *EXCL)) WAIT(60)                           /*CPK015*/
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
/************ALCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *SHRUPD)) WAIT(0)                */ /*CPK015*/
/************DLCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *EXCL))                          */ /*CPK015*/
             ALCOBJ     OBJ((&JOB_NAME *DTAARA *SHRUPD)) WAIT(0)                          /*CPK015*/
             DLCOBJ     OBJ((&JOB_NAME *DTAARA *EXCL))                                    /*CPK015*/
/**/
/* Remove messages to allow read of completion message */
/**/
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/************SBMJOB     CMD(CALL PGM(CGC5281)) JOB(&JOB_NAME) +                           /*CSC023*/
/************             JOBD(CGJOBD) JOBQ(MCOBQ) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(UDC) INLLIBL(*JOBD) MSGQ(MOPERQ)                         /*CSC023*/
             SBMJOB     CMD(CALL PGM(CGC5281)) JOB(&JOB_NAME) +
                          JOBD(CGJOBD) JOBQ(MCOBQ) USER(*JOBD) +
                          RTGDTA(UDC) INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)             /*CSC023*/
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID)
/**/
/* Retrieve job information and store on CGDTA */
/* If no completion message then end in error */
/**/
             IF         COND(&MSGID *EQ 'CPC1221') THEN(DO)
             CHGDTAARA  DTAARA(CGDTA (&JOB_OFF_ST 10)) +
                          VALUE(%SST(&MSGDTA 1 10))
             CHGDTAARA  DTAARA(CGDTA (&USR_OFF_ST 10)) +
                          VALUE(%SST(&MSGDTA 11 10))
             CHGDTAARA  DTAARA(CGDTA (&NBR_OFF_ST 6)) +
                          VALUE(%SST(&MSGDTA 21 6))
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
/************DLCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *EXCL))                          */ /*CPK015*/
             DLCOBJ     OBJ((&JOB_NAME *DTAARA *EXCL))                                    /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *SHRUPD))                        */ /*CPK015*/
             DLCOBJ     OBJ((&JOB_NAME *DTAARA *SHRUPD))                                  /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5283 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5283 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************DLCOBJ     OBJ((&DILIB/&JOB_NAME *DTAARA *SHRUPD))                        */ /*CPK015*/
             DLCOBJ     OBJ((&JOB_NAME *DTAARA *SHRUPD))                                  /*CPK015*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
