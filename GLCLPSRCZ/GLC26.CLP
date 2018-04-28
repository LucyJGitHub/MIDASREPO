/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Batch trans file split')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC26 - BATCH TRANSACTION FILE SPLIT                        */
/*                                                                   */
/*    WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.          */                 /*CGL127AM*/
/*              DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT  */                 /*CGL127AM*/
/*              ABLE TO RUN IN TASK SPLIT.                           */                 /*CGL127AM*/
/*                                                                   */                 /*CGL127AM*/
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CGL127AM           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 05Aug04              */
/*                      CPK016             Date 04Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CGL010             Date 08Nov99              */
/*                      168526             Date 13Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CEU028             Date 24Aug98              */
/*                      CEU013             Date 06Apr98              */
/*                      CCB003             Date 14Oct96              */
/*                      S01408             DATE 17JAN96              */
/*                      S01408             DATE 17OCT95              */
/*                      S01408             DATE 05SEP95              */
/*                      S01413             DATE 13APR93              */
/*                      LN0092                  02MAY90              */
/*                      S01194                  16MAR89              */
/*                      S01117                  02MAR89              */
/*                      S01154                  24AUG88              */
/*                      S01098                  26AUG86              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL127AM - COB Restructure - GL COB Optimisation Phase 1    */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       CGL010 - Future Value Dated Journal Entries for Non-Retail  */
/*                Accounts.                                          */
/*       168526 - Message data queue length variable is being set    */
/*                to zero when restart is run. Applied modified      */
/*                fix 144792.                                        */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CEU028 -   EMU GL Utilities                                 */
/*       CEU013 -   EMU Account Postings Narrative                   */
/*       CCB003 -   COB Performance Enhancements - Task Split        */
/*                  Call GL0260 and GL0261 to run as specified by    */
/*                  data queue BATCHSERVE.                           */
/*       S01408 -   Addition of core hook GLC26002                   */
/*       S01408 -   Addition of core hooks GLC26INT                  */
/*                                         GLC26MPS                  */
/*       S01408 -   Addition of core hook GLC26001.                  */
/*       S01413  -  Recompiled for Retail 3 Incorporation            */
/*       LN0092  -  Cond. Stat on field 'BKIEBI' incorrect           */
/*       S01194  -  New Standing Data                                */
/*       S01117  -  Multibranching                                   */
/*       S01154  -  Changes for New General Ledger  : New File       */
/*       S01098  -  Buffer MANPOPD                                   */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*CCB003*/
             PGM        PARM(&CNAME &CSEQ)                            /*CCB003*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          1982, 1989')
/************DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)                    CCB003*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                 /*S01117*/
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)                 /*S01117*/
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
             DCL        VAR(&FILEREAD) TYPE(*LGL) VALUE('0')          /*CCB003*/
             DCL        VAR(&NXTAVRID) TYPE(*CHAR) LEN(3)             /*CEU013*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU028*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU028*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CEU028*/
             DCL        VAR(&CEU028) TYPE(*CHAR) LEN(1)               /*CEU028*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                            /*CGL010*/
             DCL        VAR(&CGL010) TYPE(*CHAR) LEN(1) VALUE('N')    /*CGL010*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CGL010*/
             DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                  /*CPK016*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC26INT                                     */      /*S01408*/
/**/                                                                  /*S01408*/
             DCLF       FILE(SDGELRPD)                                /*S01117*/
/**/
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/************CHGDTAARA  DTAARA(*LDA) VALUE('  ')           /*S01117*/ /*CCB003*/
/**/
             SNDPGMMSG  MSG('GLC26 - Batch Transaction file split') +
                        TOMSGQ(MRUNQ)
/**/
/************CLRPFM     FILE(MANPOHH)                                 /*CCB003*/
/************CLRPFM     FILE(MANPOPD)                                 /*CCB003*/
/************CLRPFM     FILE(MANPOZZ)                                 /*CCB003*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC26MPS                                     */      /*S01408*/
/**/                                                                  /*S01408*/
/**/
/*           OVRDBF     FILE(BTRANCH) TOFILE(BTRAN) SHARE(*NO)      *  *S01154*/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                   /*S01194*/
/*           OVRDBF     FILE(TABLED) TOFILE(TABGL) SHARE(*NO) */      /*S01117*/
/**/                                                                  /*CEU028*/
/** Check if SAR CEU028 EMU GL Utilities is installed                 /*CEU028*/
/**/                                                                  /*CEU028*/
             CHGVAR     VAR(&SARD) VALUE('CEU028')                    /*CEU028*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*KEY' &SARD &FMT)   /*CEU028*/
                                                                      /*CEU028*/
             IF         COND((&RTCD *NE ' ') *AND (&RTCD *NE '*NRF')) +
                          THEN(GOTO CMDLBL(ABNOR))                    /*CEU028*/
             IF         COND(&RTCD *EQ ' ') THEN(CHGVAR VAR(&CEU028) +
                          VALUE('Y'))                                 /*CEU028*/
/**/                                                                  /*CGL010*/
/** Check if SAR CGL010 Future Valued Postings is installed           /*CGL010*/
/**/                                                                  /*CGL010*/
             CHGVAR     VAR(&SARD) VALUE('CGL010')                    /*CGL010*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CGL010*/
                                                                      /*CGL010*/
             IF         COND((&RTCD *NE ' ') *AND (&RTCD *NE '*NRF')) +
                          THEN(GOTO CMDLBL(ABNOR))                    /*CGL010*/
             IF         COND(&RTCD *EQ ' ') THEN(CHGVAR VAR(&CGL010) +
                          VALUE('Y'))                                 /*CGL010*/
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
/* Set up call to QSNDDTAQ and override to new members */             /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                      /*CCB003*/
             CHGVAR     VAR(&MEMBER) VALUE('BATCH' *CAT &CSEQC)       /*CCB003*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                 /*CCB003*/
             CHGVAR     VAR(&SNDDTAQ) VALUE('BATCHSERVE')             /*CCB003*/
             CHGVAR     VAR(&RCVDTAQ) VALUE(&MEMBER)                  /*CCB003*/
                                                                      /*CCB003*/
             OVRDBF     FILE(GLBATHPD) TOFILE(GLBATHPD) MBR(&MEMBER)  /*CCB003*/
             OVRDBF     FILE(GLBATHPA) TOFILE(GLBATHPA) MBR(&MEMBER)  /*CCB003*/
                                                                      /*CCB003*/
/* Start commitment control */                                        /*CCB003*/
/**********  STRCMTCTL  LCKLVL(*CHG)                          /*CCB003  CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) */                         /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
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
             CHGVAR     VAR(&MSGLENGTH) VALUE(50)                     /*168526*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)     /*CCB003*/
             CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                        /*CCB003*/
             ENDDO                                                    /*CCB003*/
             GOTO       CMDLBL(RESTART)                               /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/*  Request response from DTAQ whether to run job again or end */     /*CCB003*/
                                                                      /*CCB003*/
LOOP:                                                                 /*CCB003*/
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
             IF         COND(&MSGLENGTH = 0) THEN(DO)                 /*CCB003*/
             SNDPGMMSG  MSG('No response from server for GLC26') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
/* If reply = END, set restart status to 'N' and terminate */         /*CCB003*/
                                                                      /*CCB003*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)     /*CCB003*/
             GOTO       CMDLBL(END)                                   /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
 RESTART:                                                             /*CCB003*/
             CHGVAR     VAR(&NXTAVRID) VALUE(%SST(&CSEQC 3 3))        /*CEU013*/
             OVRDBF     FILE(MANPOPD) SEQONLY(*YES 500)               /*S01098*/
             OVRDBF     FILE(MANPOAPD) SEQONLY(*YES 500)              /*CEU013*/
/*/COPY WNCPYSRC,GLC26004                                            */
/*********** CALL       PGM(GL0260)                                    *CEU013*/
             CALL       PGM(GL0260) PARM(&NXTAVRID)                   /*CEU013*/
/*/COPY WNCPYSRC,GLC26005                                            */
                                                                      /*CCB003*/
/*           DLTOVR     FILE(BTRANCH TABLE TABLED)          */        /*S01098*/
/************DLTOVR     FILE(BTRANCH TABLE TABLED MANPOPD)*  *S01098*  *S01154*/
/*********** DLTOVR     FILE(TABLE TABLED MANPOPD)           *S01154*  *S01117*/
/*********** DLTOVR     FILE(TABLE MANPOPD)                  *S01117*  *S01194*/
             DLTOVR     FILE(MANPOPD)                                 /*S01194*/
             DLTOVR     FILE(MANPOAPD)                                /*CEU013*/
/**/
/************RTVJOBA    SWS(&SWS)                                       CCB003*/
/**/                                                                  /*S01194*/
/************IF         COND(%SUBSTRING(&SWS 7 2) = '11') +           /*CCB003*/
/************           THEN(SNDPGMMSG MSG('Database in error') +     /*CCB003*/
/************           TOPGMQ(*EXT))                                 /*CCB003*/
                                                                      /*CCB003*/
/* Add rollback if error */                                           /*CCB003*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CCB003*/
             SNDPGMMSG  MSG('Database in error') TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*CCB003*/
             ROLLBACK                                                 /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             ELSE (DO)
/*/COPY WNCPYSRC,GLC26003                                            */
/**/                                                                  /*CGL010*/
             IF         COND(&CGL010 *EQ 'Y') THEN(DO)                /*CGL010*/
/**/                                                                  /*CGL010*/
             CALL       PGM(GL0533)                                   /*CGL010*/
/**/                                                                  /*CGL010*/
/*/COPY WNCPYSRC,GLC26009                                            */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CGL010*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CGL010*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CGL010*/
                 GOTO ABNOR                                           /*CGL010*/
             ENDDO                                                    /*CGL010*/
/*/COPY WNCPYSRC,GLC26007                                            */
/**/                                                                  /*CGL010*/
             CALL       PGM(GL0534)                                   /*CGL010*/
/*/COPY WNCPYSRC,GLC26008                                            */
/**/                                                                  /*CGL010*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*CGL010*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CGL010*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CGL010*/
                 GOTO ABNOR                                           /*CGL010*/
             ENDDO                                                    /*CGL010*/
/**/                                                                  /*CGL010*/
/**********  RGZPFM     FILE(GLVALPPD)                                /*CGL010*/          /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                /*CGL010*/          /*228542*/
             CALL       PGM(SCC000060) PARM('GLVALPPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/*/COPY WNCPYSRC,GLC26006                                            */
                                                                      /*CGL010*/
             ENDDO                                                    /*CGL010*/
/**/
/* Read RUNDAT and SDGELRPD only once */                              /*CCB003*/
             IF         COND(&FILEREAD = '0') THEN(DO)                /*CCB003*/
             CHGVAR     VAR(&FILEREAD) VALUE('1')                     /*CCB003*/
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)           /*S01117*/
             RCVF                                                     /*S01117*/
             ENDDO                                                    /*CCB003*/
/************IF         COND(&BKIEBI *EQ 'N' *AND &MBIN *EQ 'Y') +**/ /*LN0092*/
/************             THEN(CALL PGM(GL0261)) ********/ /*S01117*/ /*LN0092*/
             IF         COND(&BKIEBI *EQ 'B' *AND &MBIN *EQ 'Y') +
                          THEN(CALL PGM(GL0261))                      /*LN0092*/
/**/                                                                  /*S01194*/
/************IF         COND(%SUBSTRING(&SWS 8 1) = '1') +            /*CCB003*/
/************           THEN(SNDPGMMSG MSG('File Out of Balance - +   /*CCB003*/
/************           GLBTREP') TOPGMQ(*EXT))            /*S01154*/ /*CCB003*/
/*******************    BTRAN') TOPGMQ(*EXT))            */           /*S01154*/
                                                                      /*CCB003*/
/* Add rollback if error */                                           /*CCB003*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)              /*CCB003*/
             SNDPGMMSG  MSG('Database in error') TOMSGQ(MOPERQ +
                          MRUNQ)                                      /*CCB003*/
             ROLLBACK                                                 /*CCB003*/
             GOTO       CMDLBL(ABNOR)                                 /*CCB003*/
             ENDDO                                                    /*CCB003*/
/**/                                                                  /*S01194*/
             ENDDO                                                    /*S01194*/
                                                                      /*CCB003*/
/* Commit changes */                                                  /*CCB003*/
             COMMIT                                                   /*CCB003*/
                                                                      /*CCB003*/
/* Clear physical file member */                                      /*CCB003*/
             CLRPFM     FILE(GLBATHPD) MBR(&MEMBER)                   /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(LOOP)                                  /*CCB003*/
                                                                      /*CCB003*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC26001                                     */      /*S01408*/
/**/                                                                  /*S01408*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC26002                                     */      /*S01408*/
/**/                                                                  /*S01408*/
/**/
/**/
 ABNOR:      SNDPGMMSG  MSG('Program GLC26 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
             ROLLBACK                                                 /*CGL010*/
                                                                      /*CCB003*/
/**/                                                                  /*CEU028*/
/**  Add Records of PF/EUPOSTPD to PF/MANPOPD if CEU028 is installed  /*CEU028*/
/**/                                                                  /*CEU028*/
 END:        IF         COND((&CEU028 *EQ 'Y') *AND +
                          (%SWITCH(XXXXXX00))) THEN(DO)               /*CEU028*/
                                                                      /*CEU028*/
                           CPYF  FROMFILE(EUPOSTPD) TOFILE(MANPOPD) +
                                  MBROPT(*ADD) FMTOPT(*NONE)          /*CEU028*/
                           MONMSG (CPF2817) CMPDTA(CPF2869)           /*CEU028*/
                                                                      /*CEU028*/
                           CLRPFM EUPOSTPD                            /*CEU028*/
                                                                      /*CEU028*/
             ENDDO                                                    /*CEU028*/
                                                                      /*CEU028*/
/*END:********IF         COND(%SWITCH(XXXXXX00)) THEN(DO)      /*CCB003 CEU028*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CEU028*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)          /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                      /*CCB003*/
             ENDPGM
