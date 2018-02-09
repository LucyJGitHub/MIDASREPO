/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Accrual for Non-Alternate')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC62N - RETAIL HISTORY ACCRUAL UPDATE FOR NON ALTERNATE    */
/*                                                                   */
/*    WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.          */                 /*CRE083AY*/
/*              DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT  */                 /*CRE083AY*/
/*              ABLE TO RUN IN TASK SPLIT.                           */                 /*CRE083AY*/
/*                                                                   */                 /*CRE083AY*/
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE083AY           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CCB003             Date 24Oct96              */
/*                      S01408             DATE 13SEP96              */
/*                      S01408             DATE 05MAY95              */
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
/*       S01408 - Addition of core hook REC62NMPS                    */
/*              - Addition of core hook REC62NMPE                    */
/*       S01408 - Addition of core hook REC62NMP1                    */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/* */
/**THIS*PGM*USE*SECURITY*COPY*OF*FILES*INSTEAD*OF*JOURNALING */       /*CCB003*/
/* */
             PGM     PARM(&CNAM &CSEQ)
                                                                      /*CCB003*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/************DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)               /*CCB003*/
/************DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*CCB003*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                /*CCB003*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
/************DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*CCB003*/
/*/COPY WNCPYSRC,REC62N001                                           */
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(12)              /*CCB003*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)            /*CCB003*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50) /*CCB003*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)             /*CCB003*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)             /*CCB003*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)  /*CCB003*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)              /*CCB003*/
/************DCLF       FILE(REHISBN)TYPE(*CHAR) LEN(256)             /*CCB003*/
/*/COPY WNCPYSRC,REC62N005                                           */
                                                                      /*CCB003*/
/* Global monitor message */                                          /*CCB003*/
                                                                      /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CCB003*/
/* */
             SNDPGMMSG  MSG('REC62N - Retail history accrual +
                          update') TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,REC62N002                                           */
/* */
/***FOLLOWING*CHECK*IS*DONE*TO*AVOID*RUN*OF*PROGRAM*IF*NO          */ /*CCB003*/
/***PROCESSING*IS*REQUIRED*:*FILE*REHISBN*IS*EMPTY                 */ /*CCB003*/
/* */
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
/* */
/************IF         COND(&STAT *EQ 'N') THEN(DO)                  /*CCB003*/
/***//*******                                                         /*CCB003*/
/************RCVF                                                     /*CCB003*/
/************MONMSG     MSGID(CPF0864) EXEC(DO)                       /*CCB003*/
/************SNDPGMMSG  MSG('No data to process in file : REHISBN by +/*CCB003*/
/************             PGM : RE3662') TOMSGQ(MRUNQ)                /*CCB003*/
/************ GOTO       CMDLBL(ENDCL)                                /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/************DLCOBJ     OBJ((REHISBN *FILE *SHRRD))                   /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/***//*******                                                         /*CCB003*/
/************RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)           /*CCB003*/
/***//*******                                                         /*CCB003*/
/************CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*CCB003*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')         /*CCB003*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC62NMP1                                           */
                                                                      /*S01408*/
/* */
/************OVRDBF     FILE(REHISPD) SEQONLY(*YES 100)               /*CCB003*/
/************OVRDBF     FILE(XREHISPD) SEQONLY(*YES 100)              /*CCB003*/
/************OVRDBF     FILE(REHISPS) SEQONLY(*YES 100)               /*CCB003*/
/************OVRDBF     FILE(XREHISPS) SEQONLY(*YES 100)              /*CCB003*/
/************OVRDBF     FILE(REHISPM) SEQONLY(*YES 100)               /*CCB003*/
/************OVRDBF     FILE(XREHISPM) SEQONLY(*YES 100)              /*CCB003*/
/************OVRDBF     FILE(REACRD) SEQONLY(*YES 100)                /*CCB003*/
/************OVRDBF     FILE(XREACRD) SEQONLY(*YES 100)               /*CCB003*/
/************OVRDBF     FILE(REIACD) SEQONLY(*YES 100)                /*CCB003*/
/************OVRDBF     FILE(XREIACD) SEQONLY(*YES 100)               /*CCB003*/
/***//*******                                                         /*CCB003*/
/************IF         COND(&STAT *EQ 'N') THEN(DO)                  /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  DLTF       FILE(XREHISPD)                              /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  DLTF       FILE(XREHISPS)                              /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  DLTF       FILE(XREHISPM)                              /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  DLTF       FILE(XREACRD)                               /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  DLTF       FILE(XREIACD)                               /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  DLTF       FILE(XRECAPM)                               /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  CPYF       FROMFILE(RECAPM) TOFILE(&TOLIB/XRECAPM) +   /*CCB003*/
/************             TOMBR(XRECAPM) MBROPT(*REPLACE) +           /*CCB003*/
/************             CRTFILE(*YES) FMTOPT(*NONE)                 /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  CPYF       FROMFILE(REHISPD) TOFILE(&TOLIB/XREHISPD) + /*CCB003*/
/************             TOMBR(XREHISPD) MBROPT(*REPLACE) +          /*CCB003*/
/************             CRTFILE(*YES) FMTOPT(*NONE)                 /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  CPYF       FROMFILE(REHISPS) TOFILE(&TOLIB/XREHISPS) + /*CCB003*/
/************             TOMBR(XREHISPS) MBROPT(*REPLACE) +          /*CCB003*/
/************             CRTFILE(*YES) FMTOPT(*NONE)                 /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  CPYF       FROMFILE(REHISPM) TOFILE(&TOLIB/XREHISPM) + /*CCB003*/
/************             TOMBR(XREHISPM) MBROPT(*REPLACE) +          /*CCB003*/
/************             CRTFILE(*YES) FMTOPT(*NONE)                 /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  CPYF       FROMFILE(REACRD) TOFILE(&TOLIB/XREACRD) +   /*CCB003*/
/************             TOMBR(XREACRD) MBROPT(*REPLACE) +           /*CCB003*/
/************             CRTFILE(*YES) FMTOPT(*NONE)                 /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  CPYF       FROMFILE(REIACD) TOFILE(&TOLIB/XREIACD) +   /*CCB003*/
/************             TOMBR(XREIACD) MBROPT(*REPLACE) +           /*CCB003*/
/************             CRTFILE(*YES) FMTOPT(*NONE)                 /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  CHGVAR     VAR(&STAT) VALUE('Y')                       /*CCB003*/
/************  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)         /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/***//*******                                                         /*CCB003*/
/************ELSE       CMD(DO)                                       /*CCB003*/
/***//*******                                                         /*CCB003*/
/****REMOVE*LOGICAL FILE OVER PHYSICAL BEFORE COPYING       */        /*CCB003*/
/************       AND REPLACE AFTER                       */        /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  RMVM       FILE(REHISL) MBR(REHISL)                    /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  CPYF       FROMFILE(XRECAPM) TOFILE(RECAPM) +          /*CCB003*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)              /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +/*CCB003*/
/************             FILE(RECAPM))                               /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  CPYF       FROMFILE(XREHISPD) TOFILE(REHISPD) +        /*CCB003*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)              /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +/*CCB003*/
/************             FILE(REHISPD))                              /*CCB003*/
/************  CPYF       FROMFILE(XREHISPS) TOFILE(REHISPS) +        /*CCB003*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)              /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +/*CCB003*/
/************             FILE(REHISPS))                              /*CCB003*/
/************  CPYF       FROMFILE(XREHISPM) TOFILE(REHISPM) +        /*CCB003*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)              /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +/*CCB003*/
/************             FILE(REHISPM))                              /*CCB003*/
/************  CPYF       FROMFILE(XREACRD) TOFILE(REACRD) +          /*CCB003*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)              /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +/*CCB003*/
/************             FILE(REACRD))                               /*CCB003*/
/************  CPYF       FROMFILE(XREIACD) TOFILE(REIACD) +          /*CCB003*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)              /*CCB003*/
/************  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +/*CCB003*/
/************             FILE(REIACD))                               /*CCB003*/
/***//*******                                                         /*CCB003*/
/************  ADDLFM     FILE(REHISL) MBR(REHISL)                    /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/***//*******                                                         /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/***//*******                                                         /*CCB003*/
/************DLTOVR     FILE(REHISPD)                                 /*CCB003*/
/************DLTOVR     FILE(XREHISPD)                                /*CCB003*/
/************DLTOVR     FILE(REHISPS)                                 /*CCB003*/
/************DLTOVR     FILE(XREHISPS)                                /*CCB003*/
/************DLTOVR     FILE(REHISPM)                                 /*CCB003*/
/************DLTOVR     FILE(XREHISPM)                                /*CCB003*/
/************DLTOVR     FILE(REACRD)                                  /*CCB003*/
/************DLTOVR     FILE(XREACRD)                                 /*CCB003*/
/************DLTOVR     FILE(REIACD)                                  /*CCB003*/
/************DLTOVR     FILE(XREIACD)                                 /*CCB003*/
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
             SNDPGMMSG  MSG('No response from server for REC62N') +
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
/* *//*******                                                         /*CCB003*/
/************CALL       PGM(RE3662)                                   /*CCB003*/
/* *//*******                                                         /*CCB003*/
                                                                      /*CCB003*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC62NMPS                                            /*S01408*/
/**/                                                                  /*S01408*/
 RESTART:    CALL       PGM(RE3662) PARM(&RESTART)                    /*CCB003*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,REC62NMPE                                            /*S01408*/
/**/                                                                  /*S01408*/
                                                                      /*CCB003*/
/************IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CCB003*/
/************  CHGVAR     VAR(&STAT) VALUE('N')                       /*CCB003*/
/************  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)         /*CCB003*/
/************  DLTF       FILE(XREHISPD)                              /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  DLTF       FILE(XREHISPS)                              /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  DLTF       FILE(XREHISPM)                              /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  DLTF       FILE(XREACRD)                               /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/************  DLTF       FILE(XREIACD)                               /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/* *//*******                                                         /*CCB003*/
/************  DLTF       FILE(XRECAPM)                               /*CCB003*/
/************  MONMSG     MSGID(CPF0000)                              /*CCB003*/
/* *//*******                                                         /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/* */
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/* */
/************  IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)            /*CCB003*/
/************    SNDPGMMSG  MSG('FILES OUT OF BALANCE - RE3662') +    /*CCB003*/
/************               TOMSGQ(MOPERQ)                            /*CCB003*/
/************  ENDDO                                                  /*CCB003*/
/* */
               IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
/*/COPY WNCPYSRC,REC62N003                                           */
                 RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOMSGQ(MOPERQ MRUNQ)
             ROLLBACK                                                 /*CCB003*/
             GOTO       CMDLBL(ENDCL)                                 /*CCB003*/
               ENDDO
/* */
             ENDDO
                                                                      /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE('N')                      /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(LOOP)                                  /*CCB003*/
                                                                      /*CCB003*/
/* */
/******CHGVAR &BISCPY '(C) COPYRIGHT MKI LIMITED 1994'  /*CCB003*/
/************ENDCL:       ENDPGM                                      /*CCB003*/
                                                                      /*CCB003*/
ABNOR:                                                                /*CCB003*/
                                                                      /*CCB003*/
             SNDPGMMSG  MSG('Program REC62N ended abnormally') +
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
/*/COPY WNCPYSRC,REC62N004                                           */
                                                                      /*CCB003*/
             ENDPGM                                                   /*CCB003*/
