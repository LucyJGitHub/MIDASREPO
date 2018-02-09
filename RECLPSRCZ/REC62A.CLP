/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Accrual for Alternate')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC62A - RETAIL ACCRUAL UPDATE FOR ALTERNATE ACCOUNT        */
/*                                                                   */
/*    WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.          */                 /*CRE083AY*/
/*              DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT  */                 /*CRE083AY*/
/*              ABLE TO RUN IN TASK SPLIT.                           */                 /*CRE083AY*/
/*                                                                   */                 /*CRE083AY*/
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE083AY           Date 09Aug99              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CCB003             Date 12Dec96              */
/*                      S01408             DATE 13SEP96              */
/*                      S01408             DATE 05MAY95              */
/*                      053122     ADI     DATE 06APR93              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE083AY - COB Restructure - RE COB Optimisation Phase 1    */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Call RE3662 to run as specified by DTAQ ACNAASERVE */
/*       S01408 - Addition of core hook REC62A002                    */
/*              - Addition of core hook REC62A001                    */
/*       S01408 - Addition of core hook REC62AMPS                    */
/*       053122 - Wrong program termination in case of duplicate     */
/*                records in REHISPS (RMVJRNCHG not done)            */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
             PGM     PARM(&CNAM &CSEQ)
                                                                      /*CCB003*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/************DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                  CCB003*/
/************DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')   CCB003*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                /*CCB003*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(12)              /*CCB003*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)            /*CCB003*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50) /*CCB003*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)             /*CCB003*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)             /*CCB003*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)  /*CCB003*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)              /*CCB003*/
/*/COPY WNCPYSRC,REC62A003                                           */
                                                                      /*CCB003*/
/* Global monitor message */                                          /*CCB003*/
                                                                      /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CCB003*/
/* */
             SNDPGMMSG  MSG('REC62A - Retail history accrual +
                          update') TOMSGQ(MRUNQ)
                                                                      /*CCB003*/
/* Read COB components file to check the restart status */            /*CCB003*/
                                                                      /*CCB003*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
                                                                      /*CCB003*/
/* Check if any problems with COB components file */                  /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/* Keep the restart value */                                          /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE(&STAT)                    /*CCB003*/
                                                                      /*CCB003*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           /*CCB003*/
/* *//*******                                                         /*CCB003*/
/***IF*P/MFU*INDICATOR*IS*'OLD'**THEN                         */      /*CCB003*/
/***UPDATE*FILE*&*P/MFU*INDICATOR*TO*'NEW'                    */      /*CCB003*/
/* *//*******                                                         /*CCB003*/
/************IF         COND(&STAT *EQ 'N') THEN(DO)                  /*CCB003*/
/************    ENDJRNPF   FILE(*ALL)AJRN(JREC62A)                   /*CCB003*/
/************MONMSG MSGID(CPF0000)                                    /*CCB003*/
/************    DLTJRN     JRN(JREC62A)                              /*CCB003*/
/************MONMSG MSGID(CPF0000)                                    /*CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                           /*CCB003*/
/************    DLTJRNRCV  JRNRCV(JRREC62A)                          /*CCB003*/
/************MONMSG MSGID(CPF0000)                                    /*CCB003*/
/************    CHGJOB     INQMSGRPY(*RQD)                           /*CCB003*/
/* *//*******                                                         /*CCB003*/
/****CREATE*JOURNAL*&*RECEIVER   */                                   /*CCB003*/
/* *//*******                                                         /*CCB003*/
/************  CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('Y')            /*CCB003*/
/************  CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)    /*CCB003*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC62AMPS                                           */
                                                                      /*S01408*/
/************  CRTJRNRCV  JRNRCV(&JLIB/JRREC62A)                      /*CCB003*/
/************  CRTJRN     JRN(&JLIB/JREC62A) JRNRCV(&JLIB/JRREC62A)   /*CCB003*/
/************STRJRNPF   FILE(REHISPD REHISPS REHISPM REACRD REIACD +  /*CCB003*/
/************             RECAPM) JRN(JREC62A) IMAGES(*BOTH)          /*CCB003*/
/************OVRDBF   FILE(REHISBN) TOFILE(REHISBA) SEQONLY(*YES 100) /*CCB003*/
/* *//*******                                                         /*CCB003*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC62A001                                            /*S01408*/
/**/                                                                  /*S01408*/
                                                                      /*CCB003*/
/* Set restart status to 'Y' */                                       /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB003*/
                                                                      /*CCB003*/
/* Set up call to QSNDDTAQ and override files to their members */     /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                      /*CCB003*/
             CHGVAR     VAR(&MEMBER) VALUE('ACNAA' *CAT &CSEQC)       /*CCB003*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                 /*CCB003*/
             CHGVAR     VAR(&SNDDTAQ) VALUE('ACNAASERVE')             /*CCB003*/
                                                                      /*CCB003*/
             OVRDBF     FILE(REACNAPD) TOFILE(REACNAPD) MBR(&MEMBER)  /*CCB003*/
                                                                      /*CCB003*/
/**********  STRCMTCTL  LCKLVL(*CHG)                           /*CCB003 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                   /*CPK009*/
                                                                      /*CCB003*/
/* If restart, do not wait for the data queue entry */                /*CCB003*/
/* Clear any old data queue message from server but ensure that an */ /*CCB003*/
/* 'END' message, sent from the end proc job is not lost */           /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(&RESTART = 'Y') THEN(DO)                 /*CCB003*/
             CHGVAR     VAR(&RCVWAIT) VALUE(5)                        /*CCB003*/
             CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)               /*CCB003*/
             CHGVAR     VAR(&RCVWAIT) VALUE(600)                      /*CCB003*/
             CHGVAR     VAR(&MSGLENGTH) VALUE(50)                     /*CCB003*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)     /*CCB003*/
             CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                        /*CCB003*/
             ENDDO                                                    /*CCB003*/
             GOTO       CMDLBL(RESTART)                               /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
LOOP:                                                                 /*CCB003*/
                                                                      /*CCB003*/
/* Request response from DTAQ whether to run job again or end */      /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)                  /*CCB003*/
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                        /*CCB003*/
                                                                      /*CCB003*/
/* Wait on reply for 5 minutes */                                     /*CCB003*/
             CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)               /*CCB003*/
                                                                      /*CCB003*/
/* If no reply, error message and terminate */                        /*CCB003*/
             IF         COND(&MSGLENGTH = 0) THEN(DO)                 /*CCB003*/
             SNDPGMMSG  MSG('No response from server for REC62A') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
             GOTO       CMDLBL(ENDCL)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/* If reply = END, terminate */                                       /*CCB003*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)     /*CCB003*/
             GOTO       CMDLBL(ENDCL)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/**************CALL       PGM(RE3662)                                   CCB003*/
                                                                      /*CCB003*/
/*/COPY WNCPYSRC,REC62A004                                           */
/*RESTART:    CALL       PGM(RE3662) PARM(&RESTART)                */            /*CCB003 CRE083AY*/
 RESTART:    OVRDBF     FILE(REHISBN) TOFILE(REHISBA) SEQONLY(*YES 100)                 /*CRE083AY*/
             CALL       PGM(RE3662) PARM(&RESTART)                                      /*CRE083AY*/
                                                                      /*CCB003*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC62A002                                             *S01408*/
/**/                                                                  /*S01408*/
/*>>> 053122 >>> */
               MONMSG     MSGID(CPF0000) EXEC(CHGJOB SWS(XXXXXX11))   /*053122*/
/*<<< 053122 <<< */
                                                                      /*CCB003*/
/************  DLTOVR     FILE(*ALL)                                    CCB003*/
/* *//*******                                                           CCB003*/
/****SUCCESSFUL*COMPLETION*-*DELETE*JOURNAL*&*RECEIVER   */           /*CCB003*/
/* *//*******                                                           CCB003*/
/************  IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              CCB003*/
/************    ENDJRNPF   FILE(*ALL) JRN(JREC62A)                     CCB003*/
/************    DLTJRN     JRN(JREC62A)                                CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                             CCB003*/
/************    DLTJRNRCV  JRNRCV(JRREC62A)                            CCB003*/
/************    CHGJOB     INQMSGRPY(*RQD)                             CCB003*/
/************    CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('N')            CCB003*/
/************  ENDDO                                                    CCB003*/
/* *//*******                                                           CCB003*/
/****UNSUCCESSFUL*COMPLETION*-*REMOVE*JOURNALLED*CHANGES */           /*CCB003*/
/* *//*******                                                           CCB003*/
/************  ELSE       CMD(DO)                                       CCB003*/
/************    RMVJRNCHG  JRN(JREC62A) FILE((REHISPD) (REHISPS) +     CCB003*/
/************               (REHISPM) (REACRD) (REIACD) (RECAPM))       CCB003*/
/************    MONMSG     MSGID(CPF7049)                              CCB003*/
/************    ENDJRNPF   FILE(*ALL)AJRN(JREC62A)                     CCB003*/
/************    DLTJRN     JRN(JREC62A)                                CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                             CCB003*/
/************    DLTJRNRCV  JRNRCV(JRREC62A)                            CCB003*/
/************    CHGJOB     INQMSGRPY(*RQD)                             CCB003*/
/************    CHGDTAARA  DTAARA(GLSTAT (57 1)) VALUE('N')            CCB003*/
/************    GOTO       CMDLBL(ENDCL)                               CCB003*/
/************  ENDDO                                                    CCB003*/
/* *//*******                                                           CCB003*/
/************  IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)              CCB003*/
/************  CHGVAR     VAR(&STAT) VALUE('Y')                         CCB003*/
/************  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           CCB003*/
/************  ENDDO                                                    CCB003*/
/* *//*******                                                           CCB003*/
/************ENDDO                                                      CCB003*/
/* *//*******                                                           CCB003*/
/**IF*U1*IS*ON,*CLEAR*PF/ACCNTXX*-*COPY*ACORDXX*TO ACCNTXX     */     /*CCB003*/
/*****RESET*P/MFU*INDICATOR*&*CLEAR*ACORDXX                    */     /*CCB003*/
/* *//*******                                                           CCB003*/
/************IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)                CCB003*/
/* *//*******                                                           CCB003*/
/************  IF         COND((&STAT) *EQ 'Y')  THEN(DO)               CCB003*/
/************  CHGVAR     VAR(&STAT) VALUE('N')                         CCB003*/
/************  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           CCB003*/
/* *//*******                                                           CCB003*/
/************  ENDDO                                                    CCB003*/
/* *//*******                                                           CCB003*/
/************ENDDO                                                      CCB003*/
/* *//*******                                                           CCB003*/
/************ELSE       CMD(DO)                                         CCB003*/
/************  CHGVAR     VAR(&STAT) VALUE('N')                         CCB003*/
/************  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           CCB003*/
/************ENDDO                                                      CCB003*/
/* */
/********************************************************************** CCB003*/
/*           E R R O R     M E S S A G E S                           */
/********************************************************************** CCB003*/
/* */
/************IF         COND(%SWITCH(XXXXXXX1)))THEN(DO)                CCB003*/
/************  SNDPGMMSG  MSG('FILE OUT OF BALANCE - RE3662') +         CCB003*/
/************             TOMSGQ(MOPERQ)                                CCB003*/
/************ENDDO                                                      CCB003*/
/* */
/*/COPY WNCPYSRC,REC62A005                                           */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM)   +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               SNDPGMMSG  MSG('DATABASE IN ERROR - RE3662') +
                          TOMSGQ(MOPERQ)
                                                                      /*CCB003*/
             ROLLBACK                                                 /*CCB003*/
             GOTO       CMDLBL(ENDCL)                                 /*CCB003*/
                                                                      /*CCB003*/
             ENDDO
/* */
             CHGVAR     VAR(&RESTART) VALUE('N')                      /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(LOOP)                                  /*CCB003*/
                                                                      /*CCB003*/
 ABNOR:      SNDPGMMSG  MSG('Program REC62A ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
                                                                      /*CCB003*/
ENDCL:       IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                      /*CCB003*/
/************ENDCL:      ENDPGM                                       /*CCB003*/
/*/COPY WNCPYSRC,REC62A006                                           */
                                                                      /*CCB003*/
             ENDPGM                                                   /*CCB003*/
