/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Shadow post update')                         */
/*****************************************************************/
/*                                                               */
/*     Midas - Retail Module                             */
/*                                                               */
/*     REC0672  - Shadow Post Update                             */
/*                                                               */
/*       (c) Finastra International Limited 2001                     */
/*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD002850           Date 08Apr13              */
/*                      CSC056             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CRE023             Date 29Jul05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 28Aug01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                    184970            Date: 11Apr01            */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                    S01408            DATE: 02SEP96            */
/*                    CCB002            DATE: 30AUG96            */
/*                    S01408            DATE: 15MAR95            */
/*                    041693            DATE: 05JAN93            */
/*                    045014            DATE: 07DEC92            */
/*                                                               */
/*---------------------------------------------------------------*/
/*                                                               */
/*       MD046248 - Finastra Rebranding                              */
/*     MD002850 - Correct the processing for restart of subtasks */
/*                after failure.                                 */
/*     CSC056 - COB Restructure - SC COB Optimisation Phase 1    */
/*     CRE023 - 2 O'clock Flag Upgrade to MidasPlus              */
/*     CPK014 - Packaging for Release 4.  Part of fix 184970 was */
/*              missing.                                         */
/*     184970 - Add Start Commitment Control for update of MEMOS */
/*     S01408 - Addition of core hook REC0672002                 */
/*            - Addition of core hook REC0672001                 */
/*     CCB002 - COB Performance Enhancements                     */
/*              Access now via access object                     */
/*              RE0672 now uses an access object for update.     */
/*              Initialisation and Clearing of MEMOS removed.    */
/*     S01408 - Core Hook Added - REC0672MPE                     */
/*            - Core Hook Added - REC0672INT                     */
/*     041693 - Delivered as part of fix.                        */
/*                                                               */
/*     045014 - New program to call RE0672                       */
/*                                                               */
/*****************************************************************/
/*/COPY WNCPYSRC,REH00040                                            */
/**********  PGM                                                   */                     /*CSC056*/
             PGM        PARM(&CNAME &CSEQ)                                                /*CSC056*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,REC0672INT                                           /*S01408*/
/* */                                                                 /*S01408*/
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
             DCL        VAR(&MEMOS_NBR) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&MEMOS_A) TYPE(*CHAR) LEN(6)
/* */
/*/COPY WNCPYSRC,REC0672003                                          */
/**********  DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)             */              /*CRE023 CSC056*/
/**********  DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')*/          /*CRE023 CSC056*/
/**********  DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)           */              /*CRE023 CSC056*/
/**********  DCL        VAR(&CRE023) TYPE(*CHAR) LEN(1) VALUE('N') */              /*CRE023 CSC056*/
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)                                   /*CSC056*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                                    /*CSC056*/
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                                    /*CSC056*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)                                  /*CSC056*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)                                /*CSC056*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)                     /*CSC056*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)                                 /*CSC056*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)                                 /*CSC056*/
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10)                                 /*CSC056*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)                      /*CSC056*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)                                  /*CSC056*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                                     /*CSC056*/
             DCL        VAR(&SNDMSG) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC056*/
             DCL        VAR(&DRIVER) TYPE(*CHAR) LEN(10) +
                           VALUE('RESPODPD')                                              /*CSC056*/
             DCL        VAR(&INDEXFL) TYPE(*CHAR) LEN(10) +
                           VALUE('RESPOIPD')                                              /*CSC056*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                                    /*CSC056*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                                     /*CSC056*/
                                                                                          /*CSC056*/
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/*/COPY WNCPYSRC,REC0672004                                          */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('REC0672 - Shadow Post Update') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
                                                                                          /*CSC056*/
/* Read COB components file to check the restart status */                                /*CSC056*/
                                                                                          /*CSC056*/
             CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STAT)                              /*CSC056*/
                                                                                          /*CSC056*/
/* Check if any problems with CB0160 call */                                              /*CSC056*/
                                                                                          /*CSC056*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CSC056*/
             GOTO       CMDLBL(ABNORMAL)                                                  /*CSC056*/
             ENDDO                                                                        /*CSC056*/
                                                                                          /*CSC056*/
             CHGVAR     VAR(&RESTART) VALUE(&STAT)                                        /*CSC056*/
                                                                                          /*CSC056*/
/* Set restart status to 'Y' */                                                           /*CSC056*/
                                                                                          /*CSC056*/
             CHGVAR     VAR(&STAT) VALUE('Y')                                             /*CSC056*/
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)                              /*CSC056*/
                                                                                          /*CSC056*/
/* Set up call to QSNDDTAQ and override files to their members */                         /*CSC056*/
                                                                                          /*CSC056*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                                          /*CSC056*/
             CHGVAR     VAR(&MEMBER) VALUE('SHPOS' *CAT &CSEQC)                           /*CSC056*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                                     /*CSC056*/
             CHGVAR     VAR(&SNDDTAQ) VALUE('RESPOSSVDQ')                                 /*CSC056*/
             CHGVAR     VAR(&RCVDTAQ) VALUE(&MEMBER)                                      /*CSC056*/
                                                                                          /*CSC056*/
/* Clear output files                             */                                      /*CSC056*/
                                                                                          /*CSC056*/
             CLRPFM     FILE(GLACCMPD) MBR(&MEMBER)                                       /*CSC056*/
             CLRPFM     FILE(REMEMOPD) MBR(&MEMBER)                                       /*CSC056*/
             CLRPFM     FILE(REOUTCPD) MBR(&MEMBER)                                       /*CSC056*/
                                                                                          /*CSC056*/
             OVRDBF     FILE(&DRIVER) TOFILE(&DRIVER) MBR(&MEMBER)                        /*CSC056*/
             OVRDBF     FILE(GLACCMPD) MBR(&MEMBER) SHARE(*YES)                           /*CSC056*/
             OVRDBF     FILE(REMEMOPD) MBR(&MEMBER) SHARE(*YES)                           /*CSC056*/
             OVRDBF     FILE(REOUTCPD) MBR(&MEMBER) SHARE(*YES)                           /*CSC056*/
                                                                                          /*CSC056*/
/* Override the database for optimization of data transfer */                             /*CSC056*/
                                                                                          /*CSC056*/
             OVRDBF FILE(RSACMTPD) NBRRCDS(900) SEQONLY(*YES 900)                         /*CSC056*/
                                                                                          /*CSC056*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*184970*/
             MONMSG CPF0000                                           /*184970*/
                                                                                          /*CSC056*/
/* If restart from component failed because of no respond from     */                     /*CSC056*/
/* Server, So resend message to Server and wait.                   */                     /*CSC056*/
                                                                                          /*CSC056*/
             IF         COND(&RESTART = 'F') THEN(DO)                                     /*CSC056*/
             GOTO       CMDLBL(LOOP)                                                      /*CSC056*/
             ENDDO                                                                        /*CSC056*/
                                                                                          /*CSC056*/
/* If restart, not caused by server do not responds, */                                   /*CSC056*/
/* do not wait for the data queue entry */                                                /*CSC056*/
/* Clear any old data queue message from server but ensure that an */                     /*CSC056*/
/* 'END' message, sent from the end proc job is not lost */                               /*CSC056*/
                                                                                          /*CSC056*/
             IF         COND(&RESTART = 'Y') THEN(DO)                                     /*CSC056*/
             CHGVAR     VAR(&RCVWAIT) VALUE(5)                                            /*CSC056*/
             CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)                                   /*CSC056*/
             CHGVAR     VAR(&RCVWAIT) VALUE(600)                                          /*CSC056*/
             CHGVAR     VAR(&MSGLENGTH) VALUE(50)                                         /*CSC056*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)                         /*CSC056*/
             CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                                            /*CSC056*/
             ENDDO                                                                        /*CSC056*/
             GOTO       CMDLBL(RESTART)                                                   /*CSC056*/
             ENDDO                                                                        /*CSC056*/
                                                                                          /*CSC056*/
LOOP:                                                                                     /*CSC056*/
                                                                                          /*CSC056*/
/* Send message to main data queue */                                                     /*CSC056*/
                                                                                          /*CSC056*/
             CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)                                      /*CSC056*/
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                           &MSGLENGTH &MSGDATA)                                           /*CSC056*/
/**********  CHGVAR     VAR(&STAT) VALUE('F')                      */            /*CSC056 MD002850*/
/**********  CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)       */            /*CSC056 MD002850*/
                                                                                          /*CSC056*/
/* Wait on reply for 5 minutes */                                                         /*CSC056*/
                                                                                          /*CSC056*/
             CALL       PGM(QRCVDTAQ) PARM(&RCVDTAQ &DTAQLIBL +
                           &MSGLENGTH &MSGDATA &RCVWAIT)                                  /*CSC056*/
                                                                                          /*CSC056*/
/* If no reply, check if the server is still active.        */                            /*CSC056*/
/* If Server is not active then error message and Terminate */                            /*CSC056*/
/* If Server is active, then resend a message to server     */                            /*CSC056*/
/* If Server still do not respond after message send, then  */                            /*CSC056*/
/* error message and Terminate.                             */                            /*CSC056*/
                                                                                          /*CSC056*/
             IF         COND(&MSGLENGTH = 0) THEN(DO)                                     /*CSC056*/
             ALCOBJ     OBJ((&INDEXFL *FILE *EXCL)) WAIT(0)                               /*CSC056*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                                           /*CSC056*/
             IF         COND(&SNDMSG *EQ 'Y') THEN(DO)                                    /*CSC056*/
             CHGVAR     VAR(&STAT) VALUE('F')                                           /*MD002850*/
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)                            /*MD002850*/
             SNDPGMMSG  MSG('No response from server for REC0672') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CSC056*/
             GOTO       CMDLBL(ABNORMAL)                                                  /*CSC056*/
             ENDDO                                                                        /*CSC056*/
             IF         COND(&SNDMSG *NE 'Y') THEN(DO)                                    /*CSC056*/
             CHGVAR     VAR(&SNDMSG) VALUE('Y')                                           /*CSC056*/
             GOTO       CMDLBL(LOOP)                                                      /*CSC056*/
             ENDDO                                                                        /*CSC056*/
             ENDDO                                                                        /*CSC056*/
                                                                                        /*MD002850*/
             CHGVAR     VAR(&STAT) VALUE('F')                                           /*MD002850*/
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)                            /*MD002850*/
             SNDPGMMSG  MSG('Server for REC0672 not active') +
                           TOMSGQ(MOPERQ MRUNQ)                                           /*CSC056*/
             GOTO       CMDLBL(ABNORMAL)                                                  /*CSC056*/
                                                                                          /*CSC056*/
             ENDDO                                                                        /*CSC056*/
                                                                                          /*CSC056*/
/* If reply = END, set restart status to 'N' and terminate */                             /*CSC056*/
                                                                                          /*CSC056*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)                         /*CSC056*/
                                                                                          /*CSC056*/
             CHGVAR     VAR(&STAT) VALUE('N')                                             /*CSC056*/
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)                              /*CSC056*/
                                                                                          /*CSC056*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CSC056*/
                                                                                          /*CSC056*/
             ENDDO                                                                        /*CSC056*/
                                                                                          /*CSC056*/
 RESTART:                                                                                 /*CSC056*/
 /* */                                                                                    /*CSC056*/
/*/COPY WNCPYSRC,REC0672005                                          */
/*******************************************************************/              /*CRE023 CSC056*/
/****Determine*if*2*O'clock*Flag*SAR*switch*is*on*******************/              /*CRE023 CSC056*/
/*******************************************************************/              /*CRE023 CSC056*/
/**********  CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN 'CRE023' +
                          &DSFDY)                                  */              /*CRE023 CSC056*/
/**********  IF         COND(&SRTCD *EQ '       ') THEN(DO)        */              /*CRE023 CSC056*/
/**********     CHGVAR     VAR(&CRE023) VALUE('Y')                 */              /*CRE023 CSC056*/
/**********  ENDDO                                                 */              /*CRE023 CSC056*/
/**********  IF         COND(&SRTCD *NE '       ' *AND &SRTCD *NE +
                          '*NRF   ') THEN(DO)                      */              /*CRE023 CSC056*/
/**********     SNDPGMMSG  MSG('AOSARDR0 - Program error') TOMSGQ(MOPERQ) */       /*CRE023 CSC056*/
/**********     MONMSG     MSGID(CPF0000 MCH0000)                  */              /*CRE023 CSC056*/
/**********     GOTO       CMDLBL(ABNORMAL)                        */              /*CRE023 CSC056*/
/**********  ENDDO                                                 */              /*CRE023 CSC056*/
                                                                                          /*CRE023*/
/* */
/* Initialise MEMOS file */
/* */
             RTVDTAARA  DTAARA(RESTAT (1 6)) RTNVAR(&MEMOS_A)
             CHGVAR VAR(&MEMOS_NBR) VALUE(&MEMOS_A)
/*********** CLRPFM FILE(MEMOS)                                         CCB002*/
/*********** INZPFM     FILE(MEMOS) TOTRCDS(&MEMOS_NBR)                 CCB002*/
/*/COPY WNCPYSRC,REC0672006                                          */
/* */
/* Run RE0672 - Shadow post update */
/* */
                                                                     /*S01408*/
/*/COPY WNCPYSRC,REC0672001                                       */ /*S01408*/
                                                                     /*S01408*/
             CALL       PGM(RE0672) PARM(&RTN_CODE)
                                                                     /*S01408*/
/*/COPY WNCPYSRC,REC0672002                                       */ /*S01408*/
                                                                     /*S01408*/
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/**Check*for*MEMOS*file*full */
/* */
/*********   IF COND(%SWITCH(XXXXX1XX)) THEN(DO)            */        /*CCB002*/
/*********   SNDPGMMSG  MSG('REC0672 - File MEMOS full') +  */        /*CCB002*/
/*********                TOMSGQ(MRUNQ MOPERQ)              */        /*CCB002*/
/*********   ENDDO                                          */        /*CCb002*/
/* */                                                                 /*S01408*/
/*/COPY WNCPYSRC,REC0672MPE                                           /*S01408*/
/* */                                                                 /*S01408*/
/*******************************************************************/              /*CRE023 CSC056*/
/***2*O'clock*Flag*SAR*switch*ON*-*REMEMLPD*merge*******************/              /*CRE023 CSC056*/
/*******************************************************************/              /*CRE023 CSC056*/
/*********   IF COND(&CRE023 *EQ 'Y') THEN(DO)                     */              /*CRE023 CSC056*/
/*********      CHGJOB SWS(00000000)                               */              /*CRE023 CSC056*/
/*********      OVRDBF FILE(TABLE) TOFILE(TABRE2)                  */              /*CRE023 CSC056*/
/*********      CALL PGM(RE2008)                                   */              /*CRE023 CSC056*/
/*********      IF COND(%SWITCH(XXXXXXX1)) THEN(DO)                */              /*CRE023 CSC056*/
/*********         SNDPGMMSG  MSG('File out of balance - RE2008') +
                          TOMSGQ(MRUNQ MOPERQ)                     */              /*CRE023 CSC056*/
/*********         GOTO      CMDLBL(ABNORMAL)                      */              /*CRE023 CSC056*/
/*********      ENDDO                                              */              /*CRE023 CSC056*/
/*********      IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                */              /*CRE023 CSC056*/
/*********         SNDPGMMSG  MSG('Job terminated, database in error') +
/*********                TOMSGQ(MRUNQ MOPERQ)                     */              /*CRE023 CSC056*/
/*********         GOTO CMDLBL(ABNORMAL)                           */              /*CRE023 CSC056*/
/*********      ENDDO                                              */              /*CRE023 CSC056*/
/*********   ENDDO                                                 */              /*CRE023 CSC056*/
/**/
/* Add rollback if error */                                                               /*CSC056*/
                                                                                          /*CSC056*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)                             /*CSC056*/
                                                                                          /*CSC056*/
             RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)                                     /*CSC056*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))                                /*CSC056*/
                                                                                          /*CSC056*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(GBREUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*CSC056*/
                                                                                          /*CSC056*/
             ROLLBACK                                                                     /*CSC056*/
                                                                                          /*CSC056*/
             GOTO       CMDLBL(ABNORMAL)                                                  /*CSC056*/
             ENDDO                                                                        /*CSC056*/
                                                                                          /*CSC056*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                                  /*CSC056*/
                COMMIT                                                                    /*CSC056*/
             ENDDO                                                                        /*CSC056*/
                                                                                          /*CSC056*/
             CHGVAR     VAR(&RESTART) VALUE('N')                                          /*CSC056*/
                                                                                          /*CSC056*/
             GOTO       CMDLBL(LOOP)                                                      /*CSC056*/
/*/COPY WNCPYSRC,REH00041                                            */
/**********  GOTO       CMDLBL(ENDCLPGM)                             */                   /*CSC056*/
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**********  RCLRSC     LVL(*CALLER)                               */                     /*CSC056*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                     /*CSC056*/
/**/
             SNDPGMMSG  MSG('Program REC0672 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC0672 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
ENDPGM:                                                                                   /*CSC056*/
/***ENDCLPGM:   RCLRSC     LVL(*CALLER)                            */                     /*CSC056*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)             */                     /*CSC056*/
/**********  RCLACTGRP  ACTGRP(*ELIGIBLE)                          */              /*CPK014 CSC056*/
/**********  MONMSG     MSGID(CPF0000)                             */              /*CPK014 CSC056*/
/**********  COMMIT                                                */              /*CPK014 CSC056*/
/**********  MONMSG     MSGID(CPF0000)                             */              /*CPK014 CSC056*/
             ENDCMTCTL                                                                    /*CPK014*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK014*/
             DLTOVR     FILE(RSACMTPD)                                                    /*CSC056*/
/*/COPY WNCPYSRC,REH00042                                            */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
