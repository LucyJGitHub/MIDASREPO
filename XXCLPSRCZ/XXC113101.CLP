/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME GCMS backgrnd process startup/down')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas GCMS Interface                                */
/*                                                                   */
/********MECJ001*-*GCMS Background Process Startup/Shutdown***********/        /*JMI113*/
/*       XXC113101 - GCMS Background Process Startup/Shutdown        */        /*JMI113*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2007************/        /*JMI113*/
/*       (c) Finastra International Limited 2018                     */        /*JMI113*/
/*                                                                   */
/*       Last Amend No. EMFIX5             Date 17Jun20              */
/*       Prev Amend No. JMI113             Date 22May18              */
/*                      JMI019  *CREATE    Date 21Feb07              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EMFIX5 - Data queue XXGCMMDA does not exist, use MEGCMSDA   */
/*                (JMI113)                                           */
/*       JMI113 - MIdas GCMS Interface. Upgrade to FBM 2.1           */
/*       JMI019 - MIdas-GCMS Interface                               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&OPER &MODE &PHAS &RTCD)
/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2007') */ /*JMI113*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*JMI113*/

             DCL        VAR(&OPER)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&RETRY)  TYPE(*DEC)  LEN(1 0) VALUE(0)
             DCL        VAR(&DAFTPP) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&PHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&VAR1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
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
/**/
/* Global Error Trap */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Send message to MRUNQ */
/*             SNDPGMMSG  MSG('MECJ001 - GCMS Background processing +
                          start/stop') TOMSGQ(MRUNQ) */ /*JMI113*/

             SNDPGMMSG  MSG('XXC113101 - GCMS Background processing start/stop') +
                          TOMSGQ(MRUNQ) /*JMI113*/
/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)
/**/
/* Retrieve background job id */
/*           RTVDTAARA  DTAARA(MEGCMSDA) RTNVAR(&DAFTPP)   */ /*JMI113*/
             RTVDTAARA  DTAARA(XXGCMMDA) RTNVAR(&DAFTPP) /*JMI113*/
/**/
/* Operation 'START' */
             IF         COND(&OPER *EQ '*START') THEN(DO)
               IF         COND(%SST(&DAFTPP 1 26) *NE ' ') THEN(DO)
                 CHGVAR     VAR(&QUAL) VALUE(%SST(&DAFTPP 1 26))
                 CHGVAR     VAR(&RETRY) VALUE(0)
/**/
/* Get job status */
 RETRY1:         CHGVAR     VAR(&MSGID) VALUE(' ')
                 CALL       PGM(QUSRJOBI) PARM(&RTRN &LENG &INPT +
                              &QUAL &INTR)
                 MONMSG     MSGID(CPF3C53 CPF3C55 CPF3C58) +
                              EXEC(CHGVAR VAR(&RTRN) VALUE(' '))
                 MONMSG     MSGID(CPF3C54) EXEC(RCVMSG MSGID(&MSGID))
                 IF         COND(&MSGID *EQ 'CPF3C54') THEN(DO)
                   CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
                   IF         COND(&RETRY *LT 5) THEN(DO)
                     DLYJOB     DLY(30)
                     GOTO       CMDLBL(RETRY1)
                   ENDDO
                 ENDDO
                 IF         COND(&RETRY *GE 5) THEN(DO)
                   CHGVAR     VAR(%SST(&RTRN 51 8)) VALUE(' ')
                 ENDDO
/**/
                 IF         COND(%SST(&RTRN 51 8) *EQ '*ACTIVE') +
                 THEN(DO)
/*                  SNDPGMMSG  MSG('(MECJ001) ***  WARNING - job is already active -
 ***') TOMSGQ(MOPERQ) */ /*JMI113*/
                    SNDPGMMSG  MSG('(XXC113101) ***  WARNING - job is already +
                                 active  ***') TOMSGQ(MOPERQ) /*JMI113*/
                   CHGVAR     VAR(&RTCD) VALUE('*S_FAIL')
                   GOTO CMDLBL(ENDPGM)
                 ENDDO
               ENDDO
/*               SBMJOB     JOB(MECJ002) JOBD(MBATCH) JOBQ(INTERFACE) USER(*JOBD) +
                            RTGDTA(MSMEIMM) RQSDTA('CALL MECJ002') INLLIBL(*JOBD) +
                            MSGQ(MOPERQ) */ /*JMI113*/
               SBMJOB     JOB(XXC113102) JOBD(MBATCH) JOBQ(INTERFACE) USER(*JOBD) +
                            RTGDTA(MSMEIMM) RQSDTA('CALL XXC113102') +
                            INLLIBL(*JOBD) MSGQ(MOPERQ) /*JMI113*/
               RCVMSG     MSGTYPE(*LAST) WAIT(*MAX) +
                            MSGDTA(&MSGDTA) MSGID(&MSGID)
/*               IF         COND(&MSGID *EQ 'CPC1221') THEN(CHGDTAARA +
                            DTAARA(MEGCMSDA (1 26)) VALUE(%SST(&MSGDTA 1 26))) */ /*JMI113*/
               IF         COND(&MSGID *EQ 'CPC1221') THEN(CHGDTAARA +
                            DTAARA(XXGCMMDA (1 26)) VALUE(%SST(&MSGDTA 1 26))) +
                            /*JMI113*/
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* Operation 'END' */
             IF         COND(&OPER *EQ '*END') THEN(DO)
               IF         COND(%SST(&DAFTPP 1 26) *EQ ' ') THEN(DO)
/*                SNDPGMMSG  MSG('(MECJ001) ***  WARNING - job is not active  +
                               ***') TOMSGQ(MOPERQ) */ /*JMI113*/
                  SNDPGMMSG  MSG('(XXC113101) ***  WARNING - job is not active  +
                               ***') TOMSGQ(MOPERQ) /*JMI113*/
                 CHGVAR     VAR(&RTCD) VALUE('*E_FAIL')
                 GOTO       CMDLBL(ENDPGM)
               ENDDO
               CHGVAR     VAR(&QUAL) VALUE(%SST(&DAFTPP 1 26))
/**/
               CHGVAR     VAR(&RETRY) VALUE(0)
 RETRY2:       CHGVAR     VAR(&MSGID) VALUE(' ')
               CALL       PGM(QUSRJOBI) PARM(&RTRN &LENG &INPT &QUAL +
                            &INTR)
               MONMSG     MSGID(CPF3C53 CPF3C55 CPF3C58) +
                            EXEC(CHGVAR VAR(&RTRN) VALUE(' '))
               MONMSG     MSGID(CPF3C54) EXEC(RCVMSG MSGID(&MSGID))
               IF         COND(&MSGID *EQ 'CPF3C54') THEN(DO)
                 CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
                 IF         COND(&RETRY *LT 5) THEN(DO)
                   DLYJOB     DLY(30)
                   GOTO       CMDLBL(RETRY2)
                 ENDDO
               ENDDO
               IF         COND(&RETRY *GE 5) THEN(DO)
                 CHGVAR     VAR(%SST(&RTRN 51 8)) VALUE(' ')
               ENDDO
/**/
               IF         COND(%SST(&RTRN 51 8) *NE '*ACTIVE') THEN(DO)
/*               SNDPGMMSG  MSG('(MECJ001) ***  WARNING - Background job already +
                            finished  ***') TOMSGQ(MOPERQ) */ /*JMI113*/
                  SNDPGMMSG  MSG('(XXC113101) ***  WARNING - Background job +
                               already finished  ***') TOMSGQ(MOPERQ) /*JMI113*/
                 CHGVAR     VAR(&RTCD) VALUE('*E_FAIL')
                 GOTO       CMDLBL(ENDPGM)
               ENDDO
               IF         COND(&PHAS *EQ 'A') THEN(DO)
                 CHGVAR     VAR(&VAR1) VALUE('E')
               ENDDO
               ELSE CMD(DO)
                 CHGVAR     VAR(&VAR1) VALUE('T')
/*                 CHGDTAARA  DTAARA(MEGCMSDA (29 1)) VALUE('B') */ /*JMI113*/
                 CHGDTAARA  DTAARA(XXGCMMDA (29 1)) VALUE('B') /*JMI113*/
               ENDDO
/*             CALL       PGM(QSNDDTAQ) PARM(MEGCMSDA *LIBL X'00001F' &VAR1) */ /*JMI113*/
/*             CALL       PGM(QSNDDTAQ) PARM(XXGCMMDA *LIBL X'00001F' &VAR1) + */
/*                            *JMI113*  *EMFIX5*/
               CALL       PGM(QSNDDTAQ) PARM(MEGCMSDA *LIBL X'00001F' &VAR1) +
                            /*EMFIX5*/

               IF         COND(&MODE *EQ '*SYNCH') THEN(DO)

 RETRY3:           CHGVAR     VAR(&MSGID) VALUE(' ')
                   CALL       PGM(QUSRJOBI) PARM(&RTRN &LENG &INPT +
                                &QUAL &INTR)
                   MONMSG     MSGID(CPF3C53 CPF3C55 CPF3C58) +
                                EXEC(CHGVAR VAR(&RTRN) VALUE(' '))
                   MONMSG     MSGID(CPF3C54) EXEC(RCVMSG MSGID(&MSGID))
                   IF         COND(&MSGID *EQ 'CPF3C54') THEN(DO)
                     CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
                     IF         COND(&RETRY *LT 5) THEN(DO)
                       DLYJOB     DLY(30)
                       GOTO       CMDLBL(RETRY3)
                     ENDDO
                   ENDDO
                   IF         COND(&RETRY *GE 5) THEN(DO)
                     CHGVAR     VAR(%SST(&RTRN 51 8)) VALUE(' ')
                   ENDDO
/**/
                   IF         COND(%SST(&RTRN 51 8) *EQ '*ACTIVE') +
                                THEN(DO)
                     DLYJOB     DLY(60)
                     GOTO       CMDLBL(RETRY3)
                   ENDDO

                   IF COND(&PHAS *EQ 'B') THEN(DO)
                     IF COND(%SST(&DAFTPP 28 1) *EQ 'Y') THEN(DO)
                       CHGVAR     VAR(&RTCD) VALUE('*MSGREJ')
                     ENDDO
                   ENDDO
/**/
               ENDDO

             ENDDO
/**/
/* If U7 or U8 are ON, perform standard database error processing */

             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
/**/
 ABNOR:        CHGJOB     SWS(XXXXXX11)
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
               /*         SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MECJ001 ended abnormally - see job log') TOMSGQ(MOPERQ +
                            MRUNQ) */ /*JMI113*/
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program XXC113101 +
                            ended abnormally - see job log') TOMSGQ(MOPERQ MRUNQ) +
                            /*JMI113*/
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             ENDDO
/**/
 ENDPGM:     ENDPGM
