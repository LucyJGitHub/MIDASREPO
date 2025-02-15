/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Calculate fixed commission')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC113A - CALCULATE COMMISSION                              */
/*                                                                   */
/*    WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.          */                 /*MD021155*/
/*              DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT  */                 /*MD021155*/
/*              ABLE TO RUN IN TASK SPLIT.                           */                 /*MD021155*/
/*                                                                   */                 /*MD021155*/
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021155           Date 10Jul13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CCB003             Date 17Dec96              */
/*                      S01408             Date 05May95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021155 - COB Restructure Phase 1 Remnants                 */
/*                - Header box not changed                           */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Call RE3113 to run as specified by DTAQ FIXCMSERVE */
/*       S01408 - Addition of core hook REC113AMPS                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                and changes for Release 10 standards               */
/*                                                                   */
/*********************************************************************/
/**//*********************************************************          CCB003*/
/**THIS*PGM*USE*SECURITY*COPY*OF*FILES*INSTEAD*OF*JOURNALING**/       /*CCB003*/
/**//*********************************************************          CCB003*/
/************PGM                                                        CCB003*/
             PGM     PARM(&CNAM &CSEQ)                                /*CCB003*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/************DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                    CCB003*/
/************DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)               CCB003*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
/************DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)                   CCB003*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                 /*CCB003*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*CCB003*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CCB003*/
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                /*CCB003*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(12)              /*CCB003*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)            /*CCB003*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50) /*CCB003*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)             /*CCB003*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)             /*CCB003*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)  /*CCB003*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)              /*CCB003*/
/*/COPY WNCPYSRC,REC113A001                                          */
                                                                      /*CCB003*/
             DCLF       FILE(TABTBRE)
                                                                      /*CCB003*/
/* Global monitor message */                                          /*CCB003*/
                                                                      /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CCB003*/
                                                                      /*CCB003*/
/**/
/*    Check if Correct flags are on before calling program */
/**/
             RCVF       RCDFMT(TABTBREF)
                                                                      /*CCB003*/
             IF         COND(&CHOV *EQ 'Y' *OR &CDTO *EQ 'Y' *OR +
                          &FXAC *EQ 'Y' *OR &CNDS +
                          *EQ 'Y' *OR &CDRI *EQ 'Y' *OR &CMBL *EQ +
                          'Y' *OR &CINA *EQ 'Y') THEN(DO)
                                                                      /*CCB003*/
             SNDPGMMSG  MSG('REC113A - Calculate commission') +
                          TOMSGQ(MRUNQ)
                                                                      /*CCB003*/
/************RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)             CCB003*/
/************CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))              CCB003*/
/************CHGVAR     VAR(&JLIB) VALUE(&PRE *TCAT 'JLIB')             CCB003*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC113AMPS                                          */
                                                                      /*S01408*/
/***********ENDCMTCTL                                                   CCB003*/
/************MONMSG     MSGID(CPF0000)                                  CCB003*/
/************    ENDJRNPF   FILE(*ALL) JRN(JREC113A)                    CCB003*/
/************MONMSG     MSGID(CPF0000)                                  CCB003*/
/************    DLTJRN     JRN(JREC113A)                               CCB003*/
/************MONMSG     MSGID(CPF0000)                                  CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                             CCB003*/
/************    DLTJRNRCV  JRREC113A                                   CCB003*/
/************MONMSG     MSGID(CPF0000)                                  CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                             CCB003*/
/************MONMSG     MSGID(CPF0000)                                  CCB003*/
/************  CRTJRNRCV  JRNRCV(&JLIB/JRREC113A)                       CCB003*/
/************  CRTJRN     JRN(&JLIB/JREC113A) JRNRCV(&JLIB/JRREC113A)   CCB003*/
/************  STRJRNPF   FILE(REHISPD RECOMD) +                        CCB003*/
/************             JRN(JREC113A) IMAGES(*BOTH)                   CCB003*/
/************  STRCMTCTL *ALL                                           CCB003*/
/************OVRDBF     FILE(REHISBN) TOFILE(REHISBAA) SEQONLY(*YES 100)CCB003*/
/************CALL       PGM(RE3113)                                     CCB003*/
/************IF         COND(%SWITCH(XXXXXX00)) THEN(DO)                CCB003*/
/************    ENDCMTCTL                                              CCB003*/
/************    ENDJRNPF   FILE(*ALL) JRN(JREC113A)                    CCB003*/
/************    DLTJRN     JRN(JREC113A)                               CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                             CCB003*/
/************    DLTJRNRCV  JRREC113A                                   CCB003*/
/************    CHGJOB     INQMSGRPY(*RQD)                             CCB003*/
/************ENDDO                                                      CCB003*/
/************IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)           CCB003*/
/************    RMVM       FILE(REHISBC) MBR(REHISBC)                  CCB003*/
/************    MONMSG     MSGID(CPF0000)                              CCB003*/
/************    RMVM       FILE(REHISBL) MBR(REHISBL)                  CCB003*/
/************    MONMSG     MSGID(CPF0000)                              CCB003*/
/************    RMVM       FILE(REHISDL) MBR(REHISDL)                  CCB003*/
/************    MONMSG     MSGID(CPF0000)                              CCB003*/
/************    RMVM       FILE(REHISL) MBR(REHISL)                    CCB003*/
/************    MONMSG     MSGID(CPF0000)                              CCB003*/
/************    RMVM       FILE(REHISBA) MBR(REHISBA)                  CCB003*/
/************    MONMSG     MSGID(CPF0000)                              CCB003*/
/************    RMVM       FILE(REHISBN) MBR(REHISBN)                  CCB003*/
/************    MONMSG     MSGID(CPF0000)                              CCB003*/
/************    RMVM       FILE(REHISBAA)MMBR(REHISBA)                 CCB003*/
/************    MONMSG     MSGID(CPF0000)                              CCB003*/
/************    RMVM       FILE(REHISBNA)MMBR(REHISBN)                 CCB003*/
/************    MONMSG     MSGID(CPF0000)                              CCB003*/
/************    RMVM       FILE(RECOM) MBR(RECOM)                      CCB003*/
/************    MONMSG     MSGID(CPF0000)                              CCB003*/
/************    ROLLBACK                                              *CCB003*/
/************    ENDCMTCTL                                             *CCB003*/
/************    ADDLFM     FILE(REHISBC) MBR(REHISBC)                 *CCB003*/
/************    MONMSG     MSGID(CPF0000)                             *CCB003*/
/************    ADDLFM     FILE(REHISBL) MBR(REHISBL)                 *CCB003*/
/************    MONMSG     MSGID(CPF0000)                             *CCB003*/
/************    ADDLFM     FILE(REHISDL) MBR(REHISDL)                 *CCB003*/
/************    MONMSG     MSGID(CPF0000)                             *CCB003*/
/************    ADDLFM     FILE(REHISL) MBR(REHISL)                   *CCB003*/
/************    MONMSG     MSGID(CPF0000)                             *CCB003*/
/************    ADDLFM     FILE(REHISBA) MBR(REHISBA)                 *CCB003*/
/************    MONMSG     MSGID(CPF0000)                             *CCB003*/
/************    ADDLFM     FILE(REHISBN) MBR(REHISBN)                 *CCB003*/
/************    MONMSG     MSGID(CPF0000)                             *CCB003*/
/************    ADDLFM     FILE(REHISBAA) MBR(REHISBA)                *CCB003*/
/************    MONMSG     MSGID(CPF0000)                             *CCB003*/
/************    ADDLFM     FILE(REHISBNA) MBR(REHISBN)                *CCB003*/
/************    MONMSG     MSGID(CPF0000)                             *CCB003*/
/************    ADDLFM     FILE(RECOM) MBR(RECOM)                     *CCB003*/
/************    MONMSG     MSGID(CPF0000)                             *CCB003*/
/************    ENDJRNPF   FILE(*ALL) JRN(JREC113A)                   *CCB003*/
/************    DLTJRN     JRN(JREC113A)                              *CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                            *CCB003*/
/************    DLTJRNRCV  JRNRCV(JRREC113A)                          *CCB003*/
/************    CHGJOB     INQMSGRPY(*RQD)                            *CCB003*/
/************    RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)              *CCB003*/
/************    CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))         *CCB003*/
/************    SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +CCB003*/
/************               TOMSGQ(MOPERQ MRUNQ)                       *CCB003*/
/************ENDDO                                                     *CCB003*/
                                                                      /*CCB003*/
/* Check if normal run or restart */                                  /*CCB003*/
                                                                      /*CCB003*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*CCB003*/
                                                                      /*CCB003*/
/* Check if any problems with COB components file */                  /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE(&STAT)                    /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB003*/
                                                                      /*CCB003*/
/* Set up call to QSNDDTAQ and override files to their members */     /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                      /*CCB003*/
             CHGVAR     VAR(&MEMBER) VALUE('FIXCM' *CAT &CSEQC)       /*CCB003*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                 /*CCB003*/
             CHGVAR     VAR(&SNDDTAQ) VALUE('FIXCMSERVE')             /*CCB003*/
                                                                      /*CCB003*/
             OVRDBF     FILE(REFIXCPD) TOFILE(REFIXCPD) MBR(&MEMBER)  /*CCB003*/
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
             SNDPGMMSG  MSG('No response from server for REC113A') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
             GOTO       CMDLBL(ENDPGM)                                /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/* If reply = END, terminate */                                       /*CCB003*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)     /*CCB003*/
             GOTO       CMDLBL(ENDPGM)                                /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
 RESTART:    OVRDBF     FILE(REHISBN) TOFILE(REHISBAA) SEQONLY(*YES +
                          100)                                        /*CCB003*/
/*/COPY WNCPYSRC,REC113A002                                          */
             CALL       PGM(RE3113) PARM(&RESTART)                    /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)         /*CCB003*/
                                                                      /*CCB003*/
             RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)                 /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))            /*CCB003*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(ENDPGM)                                /*CCB003*/
                                                                      /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/* Set restart paramater to 'N' */                                    /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE('N')                      /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(LOOP)                                  /*CCB003*/
                                                                      /*CCB003*/
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)                                /*CCB003*/
                                                                      /*CCB003*/
 ABNOR:      SNDPGMMSG  MSG('Program REC3661 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
                                                                      /*CCB003*/
 ENDPGM:                                                              /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/************ENDPGM:      ENDPGM                                      /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             ENDPGM                                                   /*CCB003*/
