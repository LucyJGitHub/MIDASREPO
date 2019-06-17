/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL GCMS background process startup/down')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas-GCMS Interface                                */
/*                                                                   */
/********GLCJ003*-*GCMS*Background*Process*Startup/Shutdown***********/                   /*JMI113*/
/*       XXC113003 - GCMS Background Process Startup/Shutdown        */                   /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/                   /*JMI113*/
/*       (c) Finastra International Limited 2018                     */                   /*JMI113*/
/*                                                                   */
/*       Last Amend No. JMI113             Date 21May18              */
/*       Prev Amend No. JMI019             Date 21Feb07              */
/*                      JMI019B            Date 28Apr05              */
/*                      JMI019  *CREATE    Date 11Jun03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       JMI113 - Midas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - Upgrade as is                                      */
/*       JMI019B - GCMS. File Name and Confirmation File             */
/*       JMI019 - Midas-GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&CNAM &CSEQ &OPER &MODE &RTCD)

 /*          DCL        VAR(&CPY)    TYPE(*CHAR) LEN(64) VALUE('(c) ++
                           Misys International Banking Systems Ltd. +
                           2007.')      */                                                /*JMI113*/
             DCL        VAR(&CPY)    TYPE(*CHAR) LEN(64) VALUE('(c) ++
                           Finastra International Limited 2018')                          /*JMI113*/
             DCL        VAR(&CNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)   TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&OPER)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&RETRY)  TYPE(*DEC)  LEN(1 0) VALUE(0)
             DCL        VAR(&DAGCMS) TYPE(*CHAR) LEN(256) VALUE(' ')
/**/
/* I/O parameters for calling QUSRJOBI */
             DCL        VAR(&RTRN)   TYPE(*CHAR) LEN(200)
             DCL        VAR(&LENG) TYPE(*CHAR) LEN(4) VALUE(X'0110')
             DCL        VAR(&INPT)   TYPE(*CHAR) LEN(8) +
                                                      VALUE('JOBI0200')
             DCL        VAR(&QUAL)   TYPE(*CHAR) LEN(26)
             DCL        VAR(&INTR)   TYPE(*CHAR) LEN(16)

             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGID)  TYPE(*CHAR) LEN(10)

 /*          DCLF       FILE(SDGCMSPD)                 */                                 /*JMI113*/
             DCLF       FILE(XXGCMSPD)                                                    /*JMI113*/

             RCVF
/**/
/* Global Error Trap */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/* Send message to MRUNQ */
/*           SNDPGMMSG  MSG('GLCJ003 - GCMS Background processing +
                          start/stop') TOMSGQ(MRUNQ)     */                               /*JMI113*/
             SNDPGMMSG  MSG('XXC113003 - GCMS Background processing +
                          start/stop') TOMSGQ(MRUNQ) /*JMI113*/

/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)
/**/
/* Retrieve background job id */
 /*          RTVDTAARA  DTAARA(GLGCMSDA) RTNVAR(&DAGCMS)  */                              /*JMI113*/
             RTVDTAARA  DTAARA(XXGCMGDA) RTNVAR(&DAGCMS)                                  /*JMI113*/
/**/
/* Operation 'START' */
             IF         COND(&OPER *EQ '*START') THEN(DO)
               IF         COND(%SST(&DAGCMS 1 26) *NE ' ') THEN(DO)
                 CHGVAR     VAR(&QUAL) VALUE(%SST(&DAGCMS 1 26))
                 CHGVAR     VAR(&RETRY) VALUE(0)
/**/
/* Get job status */
 RETRY1:         CHGVAR     VAR(&MSGID) VALUE(' ')
                 CALL       PGM(QUSRJOBI) PARM(&RTRN &LENG &INPT +
                              &QUAL &INTR)
                 MONMSG     MSGID(CPF3C53 CPF3C55 CPF3C58) +
                              EXEC(CHGVAR VAR(&RTRN) VALUE(' '))
                 MONMSG     MSGID(CPF3C54) EXEC(RCVMSG MSGID(&MSGID))
                 IF         COND(%SST(&RTRN 51 8) *EQ '*JOBQ   ') +
                             THEN(DO)
/*               SNDPGMMSG MSG('(GLCJ003) ***  WARNING - job is +
                   on queue  ***') TOMSGQ(MOPERQ)   */                                    /*JMI113*/
                    SNDPGMMSG  MSG('(XXC113003) ***  WARNING - job +
                                 is on queue  ***') TOMSGQ(MOPERQ) +
                                 /*JMI113*/
                   CHGVAR     VAR(&RTCD) VALUE('*S_FAIL')
                   GOTO CMDLBL(ENDPGM)
                 ENDDO
                 IF         COND(&MSGID *EQ 'CPF3C54') THEN(DO)
                   CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
/**********        IF         COND(&RETRY *LT 5) THEN(DO)                                /*JMI019B*/
                   IF         COND(&RETRY *LT &J0MAXT) THEN(DO)                          /*JMI019B*/
                     DLYJOB     DLY(30)
                     GOTO       CMDLBL(RETRY1)
                   ENDDO
                 ENDDO
/**********      IF         COND(&RETRY *GE 5) THEN(DO)                                  /*JMI019B*/
                 IF         COND(&RETRY *GE &J0MAXT) THEN(DO)                            /*JMI019B*/
                   CHGVAR     VAR(%SST(&RTRN 51 8)) VALUE(' ')
                 ENDDO
/**/
                 IF         COND(%SST(&RTRN 51 8) *EQ '*ACTIVE') +
                 THEN(DO)
/*                 SNDPGMMSG MSG('(GLCJ003) ***  WARNING - job is +
                     already active  ***') TOMSGQ(MOPERQ)       */                        /*JMI113*/
                 SNDPGMMSG MSG('(XXC113003) ***  WARNING - job is +
                     already active  ***') TOMSGQ(MOPERQ)                                 /*JMI113*/
                   CHGVAR     VAR(&RTCD) VALUE('*S_FAIL')
                   GOTO CMDLBL(ENDPGM)
                 ENDDO
               ENDDO
/*             SBMJOB     JOB(GLCJ005) JOBD(MBATCH) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          GLCJ005') INLLIBL(*JOBD) MSGQ(MOPERQ)        */                 /*JMI113*/
               SBMJOB     JOB(XXC113005) JOBD(MBATCH) +
                            JOBQ(INTERFACE) USER(*JOBD) +
                            RTGDTA(*JOBD) RQSDTA('CALL XXC113005') +
                            INLLIBL(*JOBD) MSGQ(MOPERQ) /*JMI113*/
               RCVMSG     MSGTYPE(*LAST) WAIT(*MAX) +
                            MSGDTA(&MSGDTA) MSGID(&MSGID)
/*             IF         COND(&MSGID *EQ 'CPC1221') THEN(CHGDTAARA +
                            DTAARA(GLGCMSDA (1 26)) +
                            VALUE(%SST(&MSGDTA 1 26)))   */                               /*JMI113*/
               IF         COND(&MSGID *EQ 'CPC1221') THEN(CHGDTAARA +
                            DTAARA(XXGCMGDA (1 26)) +
                            VALUE(%SST(&MSGDTA 1 26)))                                    /*JMI113*/
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* Operation 'END' */
             IF         COND(&OPER *EQ '*END') THEN(DO)
               IF         COND(%SST(&DAGCMS 1 26) *EQ ' ') THEN(DO)
/*               SNDPGMMSG  MSG('(GLCJ003) ***  WARNING - job is not +
                   active  ***') TOMSGQ(MOPERQ)          */                               /*JMI113*/
               SNDPGMMSG  MSG('(XXC113003) ***  WARNING - job is not +
                   active  ***') TOMSGQ(MOPERQ)                                           /*JMI113*/
                 CHGVAR     VAR(&RTCD) VALUE('*E_FAIL')
                 GOTO       CMDLBL(ENDPGM)
               ENDDO
               CHGVAR     VAR(&QUAL) VALUE(%SST(&DAGCMS 1 26))
/**/
               CHGVAR     VAR(&RETRY) VALUE(0)
 RETRY2:       CHGVAR     VAR(&MSGID) VALUE(' ')
               CALL       PGM(QUSRJOBI) PARM(&RTRN &LENG &INPT &QUAL +
                            &INTR)
               CHGVAR     VAR(&MSGID) VALUE(' ')
               MONMSG     MSGID(CPF3C53 CPF3C55 CPF3C58) +
                            EXEC(CHGVAR VAR(&RTRN) VALUE(' '))
               MONMSG     MSGID(CPF3C54) EXEC(RCVMSG MSGID(&MSGID))
               IF         COND(&MSGID *EQ 'CPF3C54') THEN(DO)
                 CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
/**********      IF         COND(&RETRY *LT 5) THEN(DO)                                  /*JMI019B*/
                 IF         COND(&RETRY *LT &J0MAXT) THEN(DO)                            /*JMI019B*/
                   DLYJOB     DLY(30)
                   GOTO       CMDLBL(RETRY2)
                 ENDDO
               ENDDO
/**********    IF         COND(&RETRY *GE 5) THEN(DO)                                    /*JMI019B*/
               IF         COND(&RETRY *GE &J0MAXT) THEN(DO)                              /*JMI019B*/
                 CHGVAR     VAR(%SST(&RTRN 51 8)) VALUE(' ')
               ENDDO
/**/
               IF         COND(%SST(&RTRN 51 8) *NE '*ACTIVE') THEN(DO)
/*               SNDPGMMSG  MSG('(GLCJ003) ***  WARNING - Background +
                   job already finished  ***') TOMSGQ(MOPERQ)   */                        /*JMI113*/
               SNDPGMMSG  MSG('(XXC113003) ***  WARNING - Background +
                   job already finished  ***') TOMSGQ(MOPERQ)                             /*JMI113*/
                 CHGVAR     VAR(&RTCD) VALUE('*E_FAIL')
                 GOTO       CMDLBL(ENDPGM)
               ENDDO
               CALL       PGM(QSNDDTAQ) PARM(GLGCMSA *LIBL +
                            X'00001F' T)
               IF         COND(&MODE *EQ '*SYNCH') THEN(DO)

 RETRY3:           CHGVAR     VAR(&MSGID) VALUE(' ')
                   CALL       PGM(QUSRJOBI) PARM(&RTRN &LENG &INPT +
                                &QUAL &INTR)
                   CHGVAR     VAR(&MSGID) VALUE(' ')                  /*169571*/
                   MONMSG     MSGID(CPF3C53 CPF3C55 CPF3C58) +
                                EXEC(CHGVAR VAR(&RTRN) VALUE(' '))
                   MONMSG     MSGID(CPF3C54) EXEC(RCVMSG MSGID(&MSGID))
                   IF         COND(&MSGID *EQ 'CPF3C54') THEN(DO)
                     CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
/**********          IF         COND(&RETRY *LT 5) THEN(DO)                              /*JMI019B*/
                     IF         COND(&RETRY *LT &J0MAXT) THEN(DO)                        /*JMI019B*/
                       DLYJOB     DLY(30)
                       GOTO       CMDLBL(RETRY3)
                     ENDDO
                   ENDDO
/**********        IF         COND(&RETRY *GE 5) THEN(DO)                                /*JMI019B*/
                   IF         COND(&RETRY *GE &J0MAXT) THEN(DO)                          /*JMI019B*/
                     CHGVAR     VAR(%SST(&RTRN 51 8)) VALUE(' ')
                   ENDDO
/**/
                   IF         COND(%SST(&RTRN 51 8) *EQ '*ACTIVE') +
                                THEN(DO)
                     DLYJOB     DLY(60)
                     GOTO       CMDLBL(RETRY3)
                   ENDDO
/**/
                   CHGVAR     VAR(%SST(&DAGCMS 1 26)) VALUE(' ')
               ENDDO
               CHGVAR     VAR(%SST(&DAGCMS 1 26)) VALUE(' ')
             ENDDO
/**/
/* If U7 or U8 are ON, perform standard database error processing */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
/**/
 ABNOR:        CHGJOB     SWS(XXXXXX11)
               MONMSG     MSGID(CPF0000 MCH0000)
/*             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA+
                 ('Program GLCJ003 ended abnormally - see job log') +
                 TOMSGQ(MOPERQ MRUNQ)         */                                          /*JMI113*/
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                            MSGDTA('Program XXC113003 ended +
                            abnormally - see job log') TOMSGQ(MOPERQ +
                            MRUNQ) /*JMI113*/
               MONMSG     MSGID(CPF0000 MCH0000)
/**/
             ENDDO
/**/
 ENDPGM:     ENDPGM
