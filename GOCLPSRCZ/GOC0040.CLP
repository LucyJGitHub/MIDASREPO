/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Update global TRAP')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOC0040 - Update Global TRAP                                */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*   WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.           */               /*AR1097467A*/
/*             DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT   */               /*AR1097467A*/
/*             ABLE TO RUN IN TASK SPLIT.                            */               /*AR1097467A*/
/*                                                                   */               /*AR1097467A*/
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1097467          Date 11Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1097467A - Expected 15% COB run optimization not met      */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                     */               /*AR1097467A*/
             PGM        PARM(&CNAME &CSEQ)                                            /*AR1097467A*/
 
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)                               /*AR1097467A*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                                /*AR1097467A*/
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                                /*AR1097467A*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)                              /*AR1097467A*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)                            /*AR1097467A*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)                 /*AR1097467A*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)                             /*AR1097467A*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('GOTRAPSVDQ')                                         /*AR1097467A*/
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10)                             /*AR1097467A*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)                  /*AR1097467A*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)                              /*AR1097467A*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                                 /*AR1097467A*/
             DCL        VAR(&SNDMSG) TYPE(*CHAR) LEN(1) VALUE('N')                    /*AR1097467A*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                                /*AR1097467A*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                                 /*AR1097467A*/
             DCL        VAR(&INDEXFL) TYPE(*CHAR) LEN(10) +
                        VALUE('GOTAPIPD')                                             /*AR1097467A*/
             DCL        VAR(&DRIVEFL) TYPE(*CHAR) LEN(10) +
                        VALUE('GOTAPDPD')                                             /*AR1097467A*/
             DCL        VAR(&BATCH) TYPE(*CHAR) LEN(1) VALUE('0')                     /*AR1097467A*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOC0040 - Update Global TRAP') +
                          TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/* Process in task split if jobtype is Batch */                                       /*AR1097467A*/
                                                                                      /*AR1097467A*/
             IF         COND(&JOBTYPE *EQ &BATCH) THEN(DO)                            /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* Read COB components file to check the restart status. */                           /*AR1097467A*/
                                                                                      /*AR1097467A*/
                CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STAT)                       /*AR1097467A*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                           /*AR1097467A*/
                   GOTO       CMDLBL(ABNOR)                                           /*AR1097467A*/
                ENDDO                                                                 /*AR1097467A*/
                                                                                      /*AR1097467A*/
                CHGVAR     VAR(&RESTART) VALUE(&STAT)                                 /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* Set restart status to 'Y'. */                                                      /*AR1097467A*/
                                                                                      /*AR1097467A*/
                CHGVAR     VAR(&STAT) VALUE('Y')                                      /*AR1097467A*/
                CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)                       /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* Set up call to QSNDDTAQ and override files to their members. */                    /*AR1097467A*/
                                                                                      /*AR1097467A*/
                CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                                   /*AR1097467A*/
                CHGVAR     VAR(&MEMBER) VALUE('GOTAP' *CAT &CSEQC)                    /*AR1097467A*/
                CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                              /*AR1097467A*/
                CHGVAR     VAR(&RCVDTAQ) VALUE(&MEMBER)                               /*AR1097467A*/
                                                                                      /*AR1097467A*/
                OVRDBF     FILE(&DRIVEFL) TOFILE(&DRIVEFL) MBR(&MEMBER)               /*AR1097467A*/
                                                                                      /*AR1097467A*/
                STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                                /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* If restart from component failed because of no response from server */             /*AR1097467A*/
/* then resend message to server and wait.                             */             /*AR1097467A*/
                                                                                      /*AR1097467A*/
                IF         COND(&RESTART = 'F') THEN(DO)                              /*AR1097467A*/
                   GOTO       CMDLBL(LOOP)                                            /*AR1097467A*/
                ENDDO                                                                 /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* If restart from component failed for some other reason do not wait for the */      /*AR1097467A*/
/* data queue entry.  Clear any old data queue messages from the server but   */      /*AR1097467A*/
/* ensure that an 'END' message sent from the end process job is not lost.    */      /*AR1097467A*/
                                                                                      /*AR1097467A*/
                IF         COND(&RESTART = 'Y') THEN(DO)                              /*AR1097467A*/
                   CHGVAR     VAR(&RCVWAIT) VALUE(5)                                  /*AR1097467A*/
                   CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                             &MSGLENGTH &MSGDATA &RCVWAIT)                            /*AR1097467A*/
                   CHGVAR     VAR(&RCVWAIT) VALUE(600)                                /*AR1097467A*/
                   CHGVAR     VAR(&MSGLENGTH) VALUE(50)                               /*AR1097467A*/
                   IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)               /*AR1097467A*/
                      CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                                   &MSGLENGTH &MSGDATA)                               /*AR1097467A*/
                   ENDDO                                                              /*AR1097467A*/
                   GOTO       CMDLBL(RESTART)                                         /*AR1097467A*/
                ENDDO                                                                 /*AR1097467A*/
                                                                                      /*AR1097467A*/
LOOP:                                                                                 /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* Send message to main data queue. */                                                /*AR1097467A*/
                                                                                      /*AR1097467A*/
                CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)                               /*AR1097467A*/
                CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                             &MSGLENGTH &MSGDATA)                                     /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* Wait on reply for 5 minutes. */                                                    /*AR1097467A*/
                                                                                      /*AR1097467A*/
                CALL       PGM(QRCVDTAQ) PARM(&RCVDTAQ &DTAQLIBL +
                             &MSGLENGTH &MSGDATA &RCVWAIT)                            /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* If  - no reply  check if the server is still active.                 */            /*AR1097467A*/
/*     - server is not active then send error message and terminate.    */            /*AR1097467A*/
/*     - server is active then resend message to server.                */            /*AR1097467A*/
/*     - server still does not respond after resending the message then */            /*AR1097467A*/
/*       send error message and terminate.                              */            /*AR1097467A*/
                IF         COND(&MSGLENGTH = 0) THEN(DO)                              /*AR1097467A*/
                   ALCOBJ     OBJ((&INDEXFL *FILE *EXCL)) WAIT(0)                     /*AR1097467A*/
                   MONMSG     MSGID(CPF1002) EXEC(DO)                                 /*AR1097467A*/
                      IF         COND(&SNDMSG *EQ 'Y') THEN(DO)                       /*AR1097467A*/
                         CHGVAR     VAR(&STAT) VALUE('F')                             /*AR1097467A*/
                         CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)              /*AR1097467A*/
                         SNDPGMMSG  MSG('No response from server for GOC0040' +
                                      *BCAT &CSEQC) TOMSGQ(MOPERQ MRUNQ)              /*AR1097467A*/
                         GOTO       CMDLBL(ABNOR)                                     /*AR1097467A*/
                      ENDDO                                                           /*AR1097467A*/
                      ELSE       CMD(DO)                                              /*AR1097467A*/
                         CHGVAR     VAR(&SNDMSG) VALUE('Y')                           /*AR1097467A*/
                         GOTO       CMDLBL(LOOP)                                      /*AR1097467A*/
                      ENDDO                                                           /*AR1097467A*/
                   ENDDO                                                              /*AR1097467A*/
                   CHGVAR     VAR(&STAT) VALUE('F')                                   /*AR1097467A*/
                   CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)                    /*AR1097467A*/
                   SNDPGMMSG  MSG('Server for GOC0040' *BCAT &CSEQC *BCAT +
                                'not active.') TOMSGQ(MOPERQ MRUNQ)                   /*AR1097467A*/
                   GOTO       CMDLBL(ABNOR)                                           /*AR1097467A*/
                ENDDO                                                                 /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* If reply = 'END', set restart status to 'N' and terminate. */                      /*AR1097467A*/
                                                                                      /*AR1097467A*/
                IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)                  /*AR1097467A*/
                   CHGVAR     VAR(&STAT) VALUE('N')                                   /*AR1097467A*/
                   CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)                    /*AR1097467A*/
                   GOTO       CMDLBL(END)                                             /*AR1097467A*/
                ENDDO                                                                 /*AR1097467A*/
             ENDDO                                                                    /*AR1097467A*/
                                                                                      /*AR1097467A*/
             IF         COND(&JOBTYPE *NE &BATCH) THEN(DO)                            /*AR1097467A*/
                CLRPFM     FILE(&DRIVEFL) MBR(*ALL)                                   /*AR1097467A*/
                OVRDBF     FILE(&DRIVEFL) MBR(*FIRST)                                 /*AR1097467A*/
             ENDDO                                                                    /*AR1097467A*/
RESTART:                                                                              /*AR1097467A*/
                                                                                      /*AR1097467A*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)
 
/*overrides*/
             OVRDBF     FILE(GOWTRAPL0) SEQONLY(*YES 1000)
 
             CALL       PGM(GOUTRAP)
 
             DLTOVR     FILE(GOWTRAPL0)
                                                                                      /*AR1097467A*/
/* Process in task split if jobtype is batch */                                       /*AR1097467A*/
                                                                                      /*AR1097467A*/
             IF         COND(&JOBTYPE *EQ &BATCH) THEN(DO)                            /*AR1097467A*/
                                                                                      /*AR1097467A*/
/* Add rollback for error. */                                                         /*AR1097467A*/
                                                                                      /*AR1097467A*/
                IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)                      /*AR1097467A*/
                   RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)                           /*AR1097467A*/
                   CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))                      /*AR1097467A*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)                                  /*AR1097467A*/
                   ROLLBACK                                                           /*AR1097467A*/
                   GOTO       CMDLBL(ABNOR)                                           /*AR1097467A*/
                ENDDO                                                                 /*AR1097467A*/
                                                                                      /*AR1097467A*/
                CHGVAR     VAR(&RESTART) VALUE('N')                                   /*AR1097467A*/
                                                                                      /*AR1097467A*/
                GOTO       CMDLBL(LOOP)                                               /*AR1097467A*/
             ENDDO                                                                    /*AR1097467A*/
 
/*error*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                IF         COND(&JOBTYPE = '0') THEN(DO)
                   SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                                GOC0040 ended abnormally - see job log') +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(END)
                ENDDO
 
                IF         COND(&JOBTYPE = '1') THEN(DO)
                   SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(END)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                             GOC0040 ended abnormally - see job log') +
                             TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                                      /*AR1097467A*/
             ENDCMTCTL                                                                /*AR1097467A*/
             MONMSG     MSGID(CPF0000)                                                /*AR1097467A*/
                                                                                      /*AR1097467A*/
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
