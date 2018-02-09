/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas Retail history update')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3661 - RETAIL HISTORY UPDATE                             */
/*                                                                   */
/*    WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.          */                 /*CRE083AX*/
/*              DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT  */                 /*CRE083AX*/
/*              ABLE TO RUN IN TASK SPLIT.                           */                 /*CRE083AX*/
/*                                                                   */                 /*CRE083AX*/
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE083AX           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CCB003             Date 22Oct96              */
/*                      S01408             DATE 09MAY95              */
/*                      083247             DATE 12APR95              */
/*                      064035             DATE 07MAR94              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE083AX - COB Restructure - RE COB Optimisation Phase 1    */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Call RE3661 to run as specified by DTAQ REHISSERVE */
/*       S01408  - Addition of core hook REC3661MP1                  */
/*       083247  -  Set up MADJPF here for history update.           */
/*                  Data for REC3661 00001. Empty for REC3661 00002. */
/*                  (Data re-extracted for REC58).                   */
/*       064035  -  Clear files MADJPF,RCHGR1,RCHGR2 & RCHGR3        */
/*                  to avoid error when a second run is necessary    */
/*       S01413  -  Retail 3 Incorporation.                          */
/*                                                                   */
/*********************************************************************/
/*********** PGM ***********/                                         /*083247*/
/*********** PGM        PARM(&MADJI)                       /*083247*/ /*CCB003*/
             PGM        PARM(&CNAM &CSEQ)                             /*CCB003*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/************DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)               /*CCB003*/
/************DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)                  /*CCB003*/
/************DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*CCB003*/
/************DCL        VAR(&MADJI) TYPE(*CHAR) LEN(1)     /*083247*/ /*CCB003*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*CCB003*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CCB003*/
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                /*CCB003*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                 /*CCB003*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(12)              /*CCB003*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)            /*CCB003*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50) /*CCB003*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)             /*CCB003*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)             /*CCB003*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)  /*CCB003*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)              /*CCB003*/
/*/COPY WNCPYSRC,REC3661001                                          */
                                                                      /*CCB003*/
/* Global monitor message */                                          /*CCB003*/
                                                                      /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CCB003*/
                                                                      /*CCB003*/
/**/
/* Send message to MRUNQ */                                           /*CCB003*/
                                                                      /*CCB003*/
             SNDPGMMSG  MSG('REC3661 - History update') TOMSGQ(MRUNQ)
                                                                      /*CCB003*/
/**//***********                                                      /*CCB003*/
/***FOLLOWING*CHECK IS DONE TO AVOID RUN OF PROGRAM IF POSTING     */ /*CCB003*/
/***PROCESSING*IS REQUIRED : FILE REDPOSL IS EMPTY                 */ /*CCB003*/
/**//***********                                                      /*CCB003*/
/**//***********                                                      /*CCB003*/
/************CPYF       FROMFILE(RTZZ) TOFILE(BCHGZZ) FROMMBR(BCHG) +
/***************          TOMBR(BCHGZZ) MBROPT(*REPLACE) FMTOPT(*NOCHK)*CCB003*/
/************RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)           /*CCB003*/
/**//***********                                                      /*CCB003*/
/************CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))            /*CCB003*/
/************CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'JLIB')          /*CCB003*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3661MP1                                          */
                                                                      /*S01408*/
/************IF*        COND(&MADJI *EQ 'Y') THEN(DO)      /*083247*/ /*CCB003*/
/***************RMVM       FILE(MADJ) MBR(MADJ)            /*083247*/ /*CCB003*/
/***************MONMSG     MSGID(CPF0000)                  /*083247*/ /*CCB003*/
/***************CPYF       FROMFILE(STRAN) TOFILE(MADJPF) +           /*CCB003*/
/***************             MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 'D') +*CCB003*/
/***************             FMTOPT(*NOCHK)               /*083247*/  /*CCB003*/
/***************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +*CCB003*/
/***************             FILE(MADJPF))                 /*083247*/ /*CCB003*/
/***************ADDLFM     FILE(MADJ) MBR(MADJ) SHARE(*YES)/*083247*/ /*CCB003*/
/***************MONMSG     MSGID(CPF0000)                  /*083247*/ /*CCB003*/
/************ENDDO                                         /*083247*/ /*CCB003*/
/**//***********                                                      /*CCB003*/
/****CREATE*JOURNAL & RECEIVER   */                                   /*CCB003*/
/**//***********                                                      /*CCB003*/
/************RMVJRNCHG  JRN(JREC3661) FILE((REHISPD) (REHISPS) +      /*CCB003*/
/***************          (REHPOSPP) (REHPOSPM) (REHPOSR1) (REHPOSR2) +*CCB003*/
/***************          (REHPOSR3))                                 /*CCB003*/
/************MONMSG     MSGID(CPF7049 CPF9801)                        /*CCB003*/
/************ENDJRNPF   FILE(*ALL) JRN(JREC3661)                      /*CCB003*/
/**************MONMSG MSGID(CPF0000)                                  /*CCB003*/
/************DLTJRN     JRN(JREC3661)                                 /*CCB003*/
/**************MONMSG MSGID(CPF0000)                                  /*CCB003*/
/************CHGJOB     INQMSGRPY(*DFT)                               /*CCB003*/
/************DLTJRNRCV  JRNRCV(JRREC3661)                             /*CCB003*/
/**************MONMSG MSGID(CPF0000)                                  /*CCB003*/
/************CHGJOB     INQMSGRPY(*RQD)                               /*CCB003*/
/************CRTJRNRCV  JRNRCV(&TOLIB/JRREC3661)                      /*CCB003*/
/************CRTJRN     JRN(&TOLIB/JREC3661) JRNRCV(&TOLIB/JRREC3661) /*CCB003*/
/************STRJRNPF   FILE(REHISPD REHISPS REHPOSPP REHPOSPM +      /*CCB003*/
/************REHPOSR1 REHPOSR2 REHPOSR3) +                            /*CCB003*/
/***************          JRN(JREC3661) IMAGES(*BOTH) OMTJRNE(*OPNCLO)/*CCB003*/
                                                                      /*CCB003*/
/* Read COB components file to check the restart status */            /*CCB003*/
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
/* Set restart status to 'Y' */                                       /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB003*/
                                                                      /*CCB003*/
/* Set up call to QSNDDTAQ and override files to their members */     /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                      /*CCB003*/
             CHGVAR     VAR(&MEMBER) VALUE('REHIS' *CAT &CSEQC)       /*CCB003*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                 /*CCB003*/
             CHGVAR     VAR(&SNDDTAQ) VALUE('REHISSERVE')             /*CCB003*/
                                                                      /*CCB003*/
             OVRDBF     FILE(REHISUPD) TOFILE(REHISUPD) MBR(&MEMBER)  /*CCB003*/
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
/* If no reply, error meesage and terminate */                        /*CCB003*/
             IF         COND(&MSGLENGTH = 0) THEN(DO)                 /*CCB003*/
             SNDPGMMSG  MSG('No response from server for REC3661') +
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
             OVRDBF     FILE(REHISBL) SHARE(*NO)
             OVRDBF     FILE(REHISDL) SHARE(*NO)
/**/
/************CALL       PGM(RE3661)                                   /*CCB003*/
                                                                      /*CCB003*/
/*/COPY WNCPYSRC,REC3661002                                          */
 RESTART:    CALL       PGM(RE3661) PARM(&RESTART)                    /*CCB003*/
/*/COPY WNCPYSRC,REC3661003                                          */
                                                                      /*CCB003*/
/**/
/************DLTOVR     FILE(*ALL)                                    /*CCB003*/
/************IF  COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)                /*CCB003*/
/************RMVJRNCHG  JRN(JREC3661) FILE((REHISPD) (REHISPS) +      /*CCB003*/
/***************          (REHPOSPP) (REHPOSPM) (REHPOSR1) (REHPOSR2) +*CCB003*/
/***************          (REHPOSR3))                                 /*CCB003*/
/***************   MONMSG     (CPF7049)                               /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/*************** ENDJRNPF   FILE(*ALL) JRN(JREC3661)                  /*CCB003*/
/***************   MONMSG MSGID(CPF0000)                              /*CCB003*/
/*************** DLTJRN     JRN(JREC3661)                             /*CCB003*/
/***************   MONMSG MSGID(CPF0000)                              /*CCB003*/
/*************** CHGJOB     INQMSGRPY(*DFT)                           /*CCB003*/
/*************** DLTJRNRCV  JRNRCV(JRREC3661)                         /*CCB003*/
/***************   MONMSG MSGID(CPF0000)                              /*CCB003*/
/*************** CHGJOB     INQMSGRPY(*RQD)                           /*CCB003*/
/**//***********                                                      /*CCB003*/
/**//***********                                                      /*CCB003*/
/* >>> 064035 >>> */
/************IF* COND(%SWITCH(XXXXXX00)) THEN(DO)                     /*CCB003*/
/***************                                                      /*CCB003*/
/************CLRPFM     FILE(MADJPF)                                  /*CCB003*/
/************MONMSG     MSGID(CPF0000)                                /*CCB003*/
/************CLRPFM     FILE(RCHGR1)                                  /*CCB003*/
/************MONMSG     MSGID(CPF0000)                                /*CCB003*/
/************CLRPFM     FILE(RCHGR2)                                  /*CCB003*/
/************MONMSG     MSGID(CPF0000)                                /*CCB003*/
/************CLRPFM     FILE(RCHGR3)                                  /*CCB003*/
/************MONMSG     MSGID(CPF0000)                                /*CCB003*/
/************ENDDO                                                    /*CCB003*/
/* <<< 064035 <<< */
/**/
             IF  COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
                                                                      /*CCB003*/
/*************** IF  COND(%SWITCH(XXXXXXX1)) THEN(DO)                 /*CCB003*/
/***************     SNDPGMMSG  MSG('FILES OUT OF BALANCE - RE3661') +/*CCB003*/
/***************            TOMSGQ(MOPERQ)                            /*CCB003*/
/*************** ENDDO                                                /*CCB003*/
/**//***********                                                      /*CCB003*/
/*************** IF  COND(%SWITCH(XXXXXX1X)) THEN(DO)                 /*CCB003*/
                                                                      /*CCB003*/
             RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
 
             SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
                                                                      /*CCB003*/
             SNDPGMMSG  MSG('DATABASE ERROR - RE3661') +
                          TOMSGQ(MOPERQ)                              /*CCB003*/
                                                                      /*CCB003*/
             ROLLBACK                                                 /*CCB003*/
             GOTO       CMDLBL(ENDCL)                                 /*CCB003*/
 
/*************** ENDDO                                                /*CCB003*/
                                                                      /*CCB003*/
             ENDDO
                                                                      /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE('N')                      /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(LOOP)                                  /*CCB003*/
                                                                      /*CCB003*/
/**/
/***********ENDCL:                                                    /*CCB003*/
                                                                      /*CCB003*/
 ABNOR:      SNDPGMMSG  MSG('Program REC3661 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
                                                                      /*CCB003*/
ENDCL:       IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB003*/
             ENDDO                                                    /*CCB003*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                      /*CCB003*/
             ENDPGM
