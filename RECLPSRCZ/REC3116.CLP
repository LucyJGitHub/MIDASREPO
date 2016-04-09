/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Retail Commission Capitalisation.')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3116 - COMMISSION CAPITALISATIONS                        */
/*                                                                   */
/*   WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.           */
/*             DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT   */
/*             ABLE TO RUN IN TASK SPLIT.                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CRE083BD           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. 112836             Date 04Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CCB003             Date 01Nov96              */
/*                      S01408             DATE 09MAY95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CRE083BD - COB Restructure - RE COB Optimisation Phase 1    */
/*                  (Added Header Box warning text, and changed      */
/*                  member text from 'Midas DBA' to Midas RE'.)      */
/*       112836 - Change to IF statement to correct coding problems. */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Call RE3116 to run as specified by dtaq COMMCSERVE */
/*       S01408 - Addition of core hook REC3116MP1                   */
/*       S01413 - Retail 3 Incorporation                             */
/*                and changes for Release 10 standards               */
/*                                                                   */
/*********************************************************************/
/**/
/**THIS*PGM*USE*SECURITY*COPY*OF*FILES*INSTEAD*OF*JOURNALING */       /*CCB003*/
/* This program use journalling */                                    /*CCB003*/
/**/                                                                  /*CCB003*/
/************PGM                                                      /*CCB003*/
             PGM        PARM(&CNAME &CSEQ)                            /*CCB003*/
                                                                      /*CCB003*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)                /*CCB003*/
/************DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*CCB003*/
/************DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*CCB003*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/* Additional variables */                                            /*CCB003*/
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)               /*CCB003*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CCB003*/
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                /*CCB003*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)              /*CCB003*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)            /*CCB003*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50) /*CCB003*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)             /*CCB003*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)             /*CCB003*/
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10)             /*CCB003*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)  /*CCB003*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)              /*CCB003*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                 /*CCB003*/
                                                                      /*CCB003*/
             DCLF       FILE(TABTBRE)
/*/COPY WNCPYSRC,REC3116002                                          */
                                                                      /*CCB003*/
/* Global monitor message */                                          /*CCB003*/
                                                                      /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CCB003*/
                                                                      /*CCB003*/
             RCVF       RCDFMT(TABTBREF)
                                                                      /*CCB003*/
/************IF         COND(&CHOV *EQ 'Y' *OR &CDTO *EQ 'Y' *OR +    /*CCB003*/
/************             &FXAC *EQ 'Y' *OR &CNDS *EQ 'Y'+            /*CCB003*/
/************             &CDRI *EQ 'Y' *OR &CMBL *EQ 'Y'+            /*CCB003*/
/************             &CINA *EQ 'Y' *OR &VATP *EQ 'Y') +          /*CCB003*/
/************             THEN(DO)                                    /*CCB003*/
                                                                      /*CCB003*/
/************IF         COND(*NOT (&CHOV = 'Y' *OR &CDTO = 'Y' *OR +    112836*/
/************             &FXAC = 'Y' *OR &CNDS = 'Y' & CDRI = 'Y' +    112836*/
/************             *OR &CMBL = 'Y' & CINA = 'Y' *OR &VATP = +    112386*/
/************             'Y')) THEN(DO)                         CCB003*112836*/
                                                                      /*112836*/
             IF         COND(*NOT (&CHOV = 'Y' *OR &CDTO = 'Y' *OR +
                          &FXAC = 'Y' *OR &CNDS = 'Y' *OR &CDRI = +
                          'Y' *OR &CMBL = 'Y' *OR &CINA = 'Y' *OR +
                          &VATP = 'Y')) THEN(DO)                      /*112836*/
                                                                      /*CCB003*/
             SNDPGMMSG  MSG('No records to process by RE3116') +
                          TOMSGQ(MRUNQ)                               /*CCB003*/
             GOTO       CMDLBL(ENDPGM)                                /*CCB003*/
                                                                      /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/**/
             SNDPGMMSG  MSG('REC3116 - Commission capitalisation') +
                          TOMSGQ(MRUNQ)
/************/                                                        /*CCB003*/
/************RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)           /*CCB003*/
/************/                                                        /*CCB003*/
/************CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*CCB003*/
/************CHGVAR     VAR(&DMLIB) VALUE(&PRE *TCAT 'DMLIB')         /*CCB003*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3116MP1                                          */
                                                                      /*S01408*/
/**/
/************OVRDBF     FILE(GEICZZ) SEQONLY(*YES 100)                /*CCB003*/
/************OVRDBF     FILE(XGEICZZ) SEQONLY(*YES 100)               /*CCB003*/
/************OVRDBF     FILE(GEICPD) SEQONLY(*YES 100)                /*CCB003*/
/************OVRDBF     FILE(XGEICPD) SEQONLY(*YES 100)               /*CCB003*/
/************/                                                        /*CCB003*/
/************DLTF       FILE(XGEICZZ)                                 /*CCB003*/
/************MONMSG     MSGID(CPF0000)                                /*CCB003*/
/************DLTF       FILE(XGEICPD)                                 /*CCB003*/
/************MONMSG     MSGID(CPF0000)                                /*CCB003*/
/************/                                                        /*CCB003*/
/******STEP1:                                                         /*CCB003*/
/************CRTDUPOBJ  OBJ(GEICZZ) FROMLIB(&DMLIB) OBJTYPE(*FILE) +  /*CCB003*/
/************             NEWOBJ(XGEICZZ) DATA(*YES)                  /*CCB003*/
/************MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 +       /*CCB003*/
/************             CPF2116 CPF2122 CPF2151 CPF2162 CPF2176 +   /*CCB003*/
/************             CPF2182) EXEC(DO)                           /*CCB003*/
/************SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : GEICZZ by + /*CCB003*/
/************             PGM : REC3116 (STEP1)') TOMSGQ(MRUNQ)       /*CCB003*/
/************GOTO       CMDLBL(ENDPGM)                                /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/************/                                                        /*CCB003*/
/******STEP2:                                                        / *CCB003*/
/************CRTDUPOBJ  OBJ(GEICPD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +  /*CCB003*/
/************             NEWOBJ(XGEICPD) DATA(*YES)                  /*CCB003*/
/************MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 +       /*CCB003*/
/************             CPF2116 CPF2122 CPF2151 CPF2162 CPF2176 +   /*CCB003*/
/************             CPF2182) EXEC(DO)                           /*CCB003*/
/************SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : GEICPD by + /*CCB003*/
/************             PGM : REC3116 (STEP2)') TOMSGQ(MRUNQ)       /*CCB003*/
/************GOTO       CMDLBL(ENDPGM)                                /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/************/                                                        /*CCB003*/
/************DLTOVR     FILE(GEICZZ)                                  /*CCB003*/
/************DLTOVR     FILE(XGEICZZ)                                 /*CCB003*/
/************DLTOVR     FILE(GEICPD)                                  /*CCB003*/
/************DLTOVR     FILE(XGEICPD)                                 /*CCB003*/
/************/                                                        /*CCB003*/
/************CLRPFM  GECOMD                                           /*CCB003*/
/************CALL       PGM(RE3116)                                   /*CCB003*/
/************/                                                        /*CCB003*/
/************IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CCB003*/
/************  DLTF       FILE(XGEICZZ)                               /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  DLTF       FILE(XGEICPD)                               /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  GOTO       CMDLBL(ENDPGM)                              /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/************/                                                        /*CCB003*/
                                                                      /*CCB003*/
/* Read COB components file to check the restart status */            /*CCB003*/
                                                                      /*CCB003*/
             CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STAT)          /*CCB003*/
                                                                      /*CCB003*/
/* Check if any problems with COB components file */                  /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE(&STAT)                    /*CCB003*/
                                                                      /*CCB003*/
/* Set restart status to 'Y' */                                       /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)          /*CCB003*/
                                                                      /*CCB003*/
/* Set up call to QSNDDTAQ and override files to their members */     /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                      /*CCB003*/
             CHGVAR     VAR(&MEMBER) VALUE('COMMC' *CAT &CSEQC)       /*CCB003*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                 /*CCB003*/
             CHGVAR     VAR(&SNDDTAQ) VALUE('COMMCSERVE')             /*CCB003*/
             CHGVAR     VAR(&RCVDTAQ) VALUE(&MEMBER)                  /*CCB003*/
                                                                      /*CCB003*/
             OVRDBF     FILE(RECOMCPD) TOFILE(RECOMCPD) MBR(&MEMBER)  /*CCB003*/
             OVRDBF     FILE(RECOMCPA) TOFILE(RECOMCPA) MBR(&MEMBER)  /*CCB003*/
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
/* Send message to main data queue */                                 /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)                  /*CCB003*/
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                        /*CCB003*/
                                                                      /*CCB003*/
/* Wait on reply for 5 minutes */                                     /*CCB003*/
                                                                      /*CCB003*/
             CALL       PGM(QRCVDTAQ) PARM(&RCVDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)               /*CCB003*/
                                                                      /*CCB003*/
/* If no reply, error message and terminate */                        /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(&MSGLENGTH = 0) THEN(DO)                 /*CCB003*/
             SNDPGMMSG  MSG('No response from server for REC3116') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/* If reply = END, set restart status to 'N' and terminate */         /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)     /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)          /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(ENDPGM)                                /*CCB003*/
                                                                      /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/*/COPY WNCPYSRC,REC3116003                                          */
 RESTART:    CALL       PGM(RE3116) PARM(&RESTART)                    /*CCB003*/
/*/COPY WNCPYSRC,REC3116004                                          */
                                                                      /*CCB003*/
/* Add rollback if error */                                           /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/**/
             RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
/**/
             SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                                                                      /*CCB003*/
             ROLLBACK                                                 /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
/**/
             ENDDO
/*/COPY WNCPYSRC,REC3116001                                          */
                                                                      /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE('N')                      /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(LOOP)                                  /*CCB003*/
                                                                      /*CCB003*/
/**/
/******EXIT1:                                                         /*CCB003*/
/************CPYF       FROMFILE(XGEICPD) TOFILE(GEICPD) +            /*CCB003*/
/************             MBROPT(*REPLACE) FMTOPT(*MAP *DROP)         /*CCB003*/
/************/                                                        /*CCB003*/
/************MONMSG     MSGID(CPF0000) EXEC(DO)                       /*CCB003*/
/************SNDPGMMSG  MSG('Error in RESTART COPY with XGEICPD in +  /*CCB003*/
/************             REC3116 (EXIT1)') TOMSGQ(MRUNQ)             /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/************/                                                        /*CCB003*/
/******EXIT2:                                                         /*CCB003*/
/************CPYF       FROMFILE(XGEICZZ) TOFILE(GEICZZ) +            /*CCB003*/
/************             MBROPT(*REPLACE) FMTOPT(*MAP *DROP)         /*CCB003*/
/************/                                                        /*CCB003*/
/************MONMSG     MSGID(CPF0000) EXEC(DO)                       /*CCB003*/
/************SNDPGMMSG  MSG('Error in RESTART COPY with XGEICZZ in +  /*CCB003*/
/************             REC3116 (EXIT1)') TOMSGQ(MRUNQ)             /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/************ELSE DO                                                  /*CCB003*/
/************SNDPGMMSG  MSG('No records to process by RE3116') +      /*CCB003*/
/************             TOMSGQ(MRUNQ)                               /*CCB003*/
/************             ENDDO                                       /*CCB003*/
/************/                                                        /*CCB003*/
/******CHGVAR &BISCPY '(C) COPYRIGHT MKI LIMITED 1994'  /*CCB003*/
/******ENDPGM:      ENDPGM                                            /*CCB003*/
                                                                      /*CCB003*/
 ABNOR:      SNDPGMMSG  MSG('Program REC3116 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
                                                                      /*CCB003*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                      /*CCB003*/
             ENDPGM                                                   /*CCB003*/
