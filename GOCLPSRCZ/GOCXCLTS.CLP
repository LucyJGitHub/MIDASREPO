/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Universal transactions upd: Task Split')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOCXCLTS - Universal Transactions Update - COB              */
/*                  Task Split version replacing GOC0020             */
/*                  in the case of Customer Loans only               */
/*                                                                   */
/*   WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.           */                 /*CGO001AC*/
/*             DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT   */                 /*CGO001AC*/
/*             ABLE TO RUN IN TASK SPLIT.                            */                 /*CGO001AC*/
/*                                                                   */                 /*CGO001AC*/
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CGO001AC           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGP014  *CREATE    Date 27Feb09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGO001AC - COB Restructure - GO COB Optmisation Phase 1     */
/*       CGP014 - Task split of Extract Controller, Customer Loans   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(3 0) VALUE(0)
 
             DCL        VAR(&SMOD) TYPE(*CHAR) LEN(4) VALUE('LOAN')
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FULLCHECK) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&ZOZONE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ZOSHTC)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZORDNB)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZODNWD)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&ZOBCCY)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZONJOB)  TYPE(*DEC)  LEN(1 0)
 
             DCL        VAR(&LOC ) TYPE(*CHAR) LEN(4)  VALUE('ZONE')
             DCL        VAR(&CCID) TYPE(*DEC) LEN(10) VALUE(0)
 
             DCL        VAR(&EXTT) TYPE(*CHAR) LEN( 4) VALUE('*TSK')
 
             DCL        VAR(&CNUM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PTFR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BRCA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BOOK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ACCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ACOD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ACSQ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SESN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MKTI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ISTT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&YRNO) TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&MTHN) TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&PCAL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STRP) TYPE(*DEC)  LEN(15 8)
             DCL        VAR(&TREF) TYPE(*CHAR) LEN(20)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('GOCXCLTS - Universal Transactions +
                          Update Task-split - ' *CAT &SMOD) +
                          TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/* Check if normal run or restart */
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
/* Check if any problems with COB components file */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&RESTART) VALUE(&STAT)
 
/* Set restart status to 'Y' */
 
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
 
/* Set up call to QSNDDTAQ and override files to their members */
 
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)
             CHGVAR     VAR(&MEMBER) VALUE('XCLND' *CAT &CSEQC)
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')
             CHGVAR     VAR(&SNDDTAQ) VALUE('GOXCLNSRV')
 
             OVRDBF     FILE(XCLNDVPD) MBR(&MEMBER) NBRRCDS(1000) +
                          SEQONLY(*YES 2000)
 
/* If restart, do not wait for the data queue entry */
/* Clear any old data queue message from server but ensure that an */
/* 'END' message, sent from the end proc job is not lost */
 
             IF         COND(&RESTART = 'Y') THEN(DO)
             CHGVAR     VAR(&RCVWAIT) VALUE(5)
             CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)
             CHGVAR     VAR(&RCVWAIT) VALUE(600)
             CHGVAR     VAR(&MSGLENGTH) VALUE(50)
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)
             CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
             ENDDO
             GOTO       CMDLBL(RESTART)
             ENDDO
 
/* Check that Data Queue exists - if not retry 10 times       */
 CHKDTAQ:    CHKOBJ     OBJ(&DTAQLIBL/&MEMBER) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                        CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
                        IF         COND(&COUNT *LT 11) THEN(DO)
                                   DLYJOB     DLY(10)
                                   GOTO       CMDLBL(CHKDTAQ)
                        ENDDO
                        ELSE (DO)
                                   GOTO       CMDLBL(ABNOR)
                        ENDDO
             ENDDO
LOOP:
 
/* Request response from DTAQ whether to run job again or end */
 
             CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
/* Wait on reply for 1 hour */
             CHGVAR     VAR(&RCVWAIT) VALUE(3600)
             CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)
 
/* If no reply, error message and terminate */
             IF         COND(&MSGLENGTH = 0) THEN(DO)
             SNDPGMMSG  MSG('No response from server for GOCXCLTS') +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* If reply = END, terminate */
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)
             GOTO       CMDLBL(ENDCL)
             ENDDO
 
/**/
 RESTART:
 
/* Get zone */
 
             CALL       PGM(GOGETZONE) PARM(&RTCD &ERMS &FULLCHECK +
                          &ZOZONE &ZOSHTC &ZORDNB &ZODNWD &ZOBCCY +
                          &ZONJOB)
 
/* error */
             IF         COND(&RTCD ¬= '       ') THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* overrides */
             OVRDBF     FILE(GOTRAPPD) MBR(&SMOD) SHARE(*NO) +
                          SEQONLY(*YES 1000)
             OVRDBF     FILE(GOPOSNPD) MBR(&SMOD) SHARE(*NO) +
                          SEQONLY(*YES 1000)
             OVRDBF     FILE(GOCASHPD) MBR(&SMOD) SHARE(*NO) +
                          SEQONLY(*YES 1000)
 
             OVRDBF     FILE(GOWPOSNPD) MBR(&SMOD) SHARE(*NO) +
                          SEQONLY(*YES 1000)
             OVRDBF     FILE(GOWEVNTPD) MBR(&SMOD) SHARE(*NO)
 
             OVRDBF     FILE(DEALSX) TOFILE(DEALS) SHARE(*NO)
             OVRDBF     FILE(CLOAN ) TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)
             OVRDBF     FILE(CLOANS) TOFILE(CLOAN) SHARE(*NO)
 
/*RETURN*/
             CHGVAR     VAR(&PGM) VALUE('GOXC' *CAT &SMOD)
             CALL       PGM(&PGM) PARM(&RTCD &ERMS &LOC &ZOZONE +
                          &CCID &EXTT &CNUM &PTFR &BRCA &BOOK &ACCY +
                          &ACOD &ACSQ &SESN &MKTI &ISTT &YRNO &MTHN +
                          &PCAL &STRP &TREF)
 
/* error */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Successful completion */
             CHGVAR     VAR(&RESTART) VALUE('N')
 
             CLRPFM     FILE(XCLNDVPD) MBR(&MEMBER)
 
             GOTO       CMDLBL(LOOP)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GOCXCLTS ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                ROLLBACK
                MONMSG     MSGID(CPF0000 MCH0000)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 ENDCL:      CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
