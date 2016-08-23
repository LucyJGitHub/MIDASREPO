/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Fontis backgrnd process IAT startup/down')   */
/*********************************************************************/
/*                                                                   */
/*   Midas - Midas-Fontis Interface                                  */
/*                                                                   */
/*   GLC2822    Fontis Background Process IAT Startup/Shutdown       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. 175255             Date 21Feb00              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009 *CREATE     Date 26May99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*   175255 - Do not submit new job if current one is on queue.      */
/*   CGL009 - Midas-Fontis IAT/TPP Interface                         */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&OPER &MODE &PHAS &RTCD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&OPER)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&RETRY)  TYPE(*DEC)  LEN(1 0) VALUE(0)
             DCL        VAR(&DAFIAT) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&PHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&VAR1) TYPE(*CHAR) LEN(1)
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
             SNDPGMMSG  MSG('GLC2822 - Fontis Background processing +
                          start/stop') TOMSGQ(MRUNQ)
 
/* Reset Job Switches */
             CHGJOB     SWS(XXXXXX00)
/**/
/* Retrieve background job id */
             RTVDTAARA  DTAARA(GLFIATDA) RTNVAR(&DAFIAT)
/**/
/* Operation 'START' */
             IF         COND(&OPER *EQ '*START') THEN(DO)
               IF         COND(%SST(&DAFIAT 1 26) *NE ' ') THEN(DO)
                 CHGVAR     VAR(&QUAL) VALUE(%SST(&DAFIAT 1 26))
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
                             THEN(DO)                                 /*175255*/
                   SNDPGMMSG MSG('(GLC2822) ***  WARNING - job is +
                     on queue  ***') TOMSGQ(MOPERQ)                   /*175255*/
                   CHGVAR     VAR(&RTCD) VALUE('*S_FAIL')             /*175255*/
                   GOTO CMDLBL(ENDPGM)                                /*175255*/
                 ENDDO                                                /*175255*/
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
                   SNDPGMMSG MSG('(GLC2822) ***  WARNING - job is +
                     already active  ***') TOMSGQ(MOPERQ)
                   CHGVAR     VAR(&RTCD) VALUE('*S_FAIL')
                   GOTO CMDLBL(ENDPGM)
                 ENDDO
               ENDDO
/************  SBMJOB     JOB(GLC2823) JOBD(MBATCH) JOBQ(INTERFACE) +                     /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             GLC2823') INLLIBL(*JOBD) MSGQ(MOPERQ)                           /*CSC023*/
               SBMJOB     JOB(GLC2823) JOBD(MBATCH) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          GLC2823') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)               /*CSC023*/
               RCVMSG     MSGTYPE(*LAST) WAIT(*MAX) +
                            MSGDTA(&MSGDTA) MSGID(&MSGID)
               IF         COND(&MSGID *EQ 'CPC1221') THEN(CHGDTAARA +
                    DTAARA(GLFIATDA (1 26)) VALUE(%SST(&MSGDTA 1 26)))
               GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* Operation 'END' */
             IF         COND(&OPER *EQ '*END') THEN(DO)
               IF         COND(%SST(&DAFIAT 1 26) *EQ ' ') THEN(DO)
                 SNDPGMMSG  MSG('(GLC2822) ***  WARNING - job is not +
                   active  ***') TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&RTCD) VALUE('*E_FAIL')
                 GOTO       CMDLBL(ENDPGM)
               ENDDO
               CHGVAR     VAR(&QUAL) VALUE(%SST(&DAFIAT 1 26))
/**/
               CHGVAR     VAR(&RETRY) VALUE(0)
/**/
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
                 SNDPGMMSG  MSG('(GLC2822) ***  WARNING - Background +
                   job already finished  ***') TOMSGQ(MOPERQ)
                 CHGVAR     VAR(&RTCD) VALUE('*E_FAIL')
                 GOTO       CMDLBL(ENDPGM)
               ENDDO
               IF         COND(&PHAS *NE 'B') THEN(DO)
                 CHGVAR     VAR(&VAR1) VALUE('E')
               ENDDO
               ELSE CMD(DO)
                 CHGVAR     VAR(&VAR1) VALUE('T')
                 CHGDTAARA  DTAARA(GLFIATDA (29 1)) VALUE('B')
               ENDDO
               CALL       PGM(QSNDDTAQ) PARM(GLIATSA *LIBL X'00001F' +
                          &VAR1)
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
 
                   CHGDTAARA  DTAARA(GLFIATDA (1 26)) VALUE(' ')
 
                   IF COND(&PHAS *EQ 'B') THEN(DO)
                     IF COND(%SST(&DAFIAT 28 1) *EQ 'Y') THEN(DO)
                       CHGVAR     VAR(&RTCD) VALUE('*MSGREJ')
                     ENDDO
                   ENDDO
 
               ENDDO
             ENDDO
/**/
/* If U7 or U8 are ON, perform standard database error processing */
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
/**/
 ABNOR:        CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
               SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA+
                 ('Program GLC2822 ended abnormally - see job log') +
                 TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             ENDDO
/**/
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
