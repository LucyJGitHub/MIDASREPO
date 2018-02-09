/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Retail interest and charges')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC64A - RETAIL INTEREST & CHARGES CAPITALISATION           */
/*                                                                   */
/*   WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.           */                 /*CRE083BE*/
/*             DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT   */                 /*CRE083BE*/
/*             ABLE TO RUN IN TASK SPLIT.                            */                 /*CRE083BE*/
/*                                                                   */                 /*CRE083BE*/
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE083BK           Date 06Aug12              */
/*                      CRE083BE           Date 06Aug12              */
/*                      CER059             Date 19Jul10              */
/*                      BUG23276           Date 10Mar09              */
/*                      CER044             Date 19May08              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGL031             Date 05Jul04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      S01408             Date 26Jan98              */
/*                      CCB003             Date 16Dec96              */
/*                      085787             Date 16Nov95              */
/*                      S01408             DATE 18OCT95              */
/*                      S01408             DATE 05MAY95              */
/*                      S01408             DATE 08MAR95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE083BK - COB Restructure - RE COB Optimisation Phase 1    */
/*       CRE083BE - COB Restructure - RE COB Optimisation Phase 1    */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23276 - Items with Customers set up as Banks not shown   */
/*       CER044 - German Features LF035-00 AWV Reporting             */
/*       CGL031 - Taxation on Savings Income                         */
/*       S01408 - Core Hook Added - REC64AMP5                        */
/*                Core Hook Added - REC64AMP6                        */
/*                Label separated from call to RE3664 to allow       */
/*                insertion of the hook before calling the program.  */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Call RE3664 to run as specified by DTAQ INTCHSERVE */
/*       085787 - Display Error messages if pgm ended in error       */
/*       S01408 - Core Hook Added - REC64A001                        */
/*       S01408 - Core Hook Added - REC64AMP4                        */
/*       S01408 - Core Hook Added - REC64AINT                        */
/*              - Core Hook Added - REC64AMPS                        */
/*              - Core Hook Added - REC64AMP1                        */
/*              - Core Hook Added - REC64AMP2                        */
/*              - Core Hook Added - REC64AMP3                        */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/************PGM                                                      /*CCB003*/
             PGM     PARM(&CNAM &CSEQ)                                /*CCB003*/
/**/
/************DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                /*CCB003*/
/************DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB') /*CCB003*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(50)
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
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                 /*CCB003*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CGL031*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CGL031*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CGL031*/
             DCL        VAR(&CGL031) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CGL031*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CGL031*/
             DCL        VAR(&CER044) TYPE(*CHAR) LEN(1) +
                          VALUE(' ')                                                      /*CER044*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*/COPY WNCPYSRC,REC64AINT                                   /*S01408*/
/**/
/**/
/* Global monitor message */                                          /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')                 /*CCB003*/
                                                                      /*CCB003*/
             SNDPGMMSG  MSG('REC64A - Retail interest and charges ') +
                          TOMSGQ(MRUNQ)
 
/** Check if switchable feature CGL031 is on */                                           /*CGL031*/
                                                                                          /*CGL031*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CGL031*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGL031*/
             CHGVAR     VAR(&SAR) VALUE('CGL031')                                         /*CGL031*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CGL031*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CGL031) VALUE('Y')                                        /*CGL031*/
             ENDDO
                                                                      /*CCB003*/
/**//********                                                         /*CCB003*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           /*CCB003*/
/**//********                                                         /*CCB003*/
/****CREATE*JOURNAL*&*RECEIVER   */                                   /*CCB003*/
/************ENDCMTCTL                                                /*CCB003*/
/************MONMSG     MSGID(CPF0000)                                /*CCB003*/
/************  CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)    /*CCB003*/
/**/
/*/COPY WNCPYSRC,REC64AMP4                                   /*S01408*/
/**/
/************    ENDJRNPF   FILE(*ALL) JRN(JREC64A)                   /*CCB003*/
/************MONMSG MSGID(CPF0000)                                    /*CCB003*/
/************    DLTJRN     JRN(JREC64A)                              /*CCB003*/
/************MONMSG     MSGID(CPF0000)                                /*CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                           /*CCB003*/
/************    DLTJRNRCV  JRNRCV(JRREC64A)                          /*CCB003*/
/************MONMSG     MSGID(CPF0000)                                /*CCB003*/
/************CHGJOB     INQMSGRPY(*RQD)                               /*CCB003*/
/************  CRTJRNRCV  JRNRCV(&JLIB/JRREC64A)                      /*CCB003*/
/************  CRTJRN     JRN(&JLIB/JREC64A) JRNRCV(&JLIB/JRREC64A)   /*CCB003*/
/**/
/*/COPY WNCPYSRC,REC64AMP1                                   /*S01408*/
/**/
/************STRJRNPF   FILE(REHISPD REHISPS ACCNTAB REACRD REIACD +  /*CCB003*/
/************             REHPOSPP GEICPD GEICZZ REHISPM) +           /*CCB003*/
/************             JRN(JREC64A) IMAGES(*BOTH) OMTJRNE(*OPNCLO) /*CCB003*/
/************  STRCMTCTL *ALL                                         /*CCB003*/
                                                                      /*CCB003*/
               OVRDBF     FILE(REHISBC) SEQONLY(*YES 100)
               OVRDBF     FILE(ACCNTX) TOFILE(ACCNT) SHARE(*NO)
/**/
/*/COPY WNCPYSRC,REC64AMPS                                   /*S01408*/
/**/
/**/
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
/* Set restart status to 'Y' */                                       /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB003*/
                                                                      /*CCB003*/
/* Set up call to QSNDDTAQ and override files to their members */     /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                      /*CCB003*/
             CHGVAR     VAR(&MEMBER) VALUE('INTCH' *CAT &CSEQC)       /*CCB003*/
             CHGVAR     VAR(&SNDDTAQ) VALUE('INTCHSERVE')             /*CCB003*/
                                                                      /*CCB003*/
             OVRDBF     FILE(REINTCPD) TOFILE(REINTCPD) MBR(&MEMBER)  /*CCB003*/
             OVRDBF     FILE(REINTCPA) TOFILE(REINTCPA) MBR(&MEMBER)  /*CCB003*/
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
             SNDPGMMSG  MSG('No response from server for REC64A') +
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
/************  CALL       PGM(RE3664)                                 /*CCB003*/
                                                                      /*CCB003*/
/**/
/*/COPY WNCPYSRC,REC64AMP5                                   /*S01408*/
/**/
/*ESTART:****CALL*******PGM(RE3664) PARM(&RESTART)            *CCB003* *S01408*/
/**/
 RESTART:                                                    /*S01408*/
/**/
/*/COPY WNCPYSRC,REC64AMP6                                   /*S01408*/
/**/
             CALL       PGM(RE3664) PARM(&RESTART)           /*S01408*/
/***Clear*Extract*file****/                                                      /*CER044 CRE083BK*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ') */                           /*CER044 CRE083BK*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY') */                           /*CER044 CRE083BK*/
/**********  CHGVAR     VAR(&SAR) VALUE('CER044') */                             /*CER044 CRE083BK*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) */          /*CER044 CRE083BK*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(DO) */                    /*CER044 CRE083BK*/
/**********  CHGVAR     VAR(&CER044) VALUE('Y')                                  /*CER044 CRE083BK*/
/**********  CLRPFM     FILE(GLAWVRPD)  */                                   /*CER044*/ /*BUG23276*/
/**********  CLRPFM     FILE(GLAWXRPD)  */                                   /*CER044*/ /*BUG23276*/
/**********  CALL       PGM(RE3664B) */                                          /*CER044 CRE083BK*/
/**********  ENDDO */                                                            /*CER044 CRE083BK*/
                                                                                          /*CGL031*/
/**********  IF         COND(&CGL031 = 'Y') THEN(DO) */                          /*CGL031 CREO83BK*/
/**********  CALL       PGM(RE3664A) */                                          /*CGL031 CREO83BK*/
/**********  ENDDO */                                                            /*CGL031 CREO83BK*/
                                                                                          /*CGL031*/
/*/COPY WNCPYSRC,REC64A002                                           */
                                                                      /*CCB003*/
/************DLTOVR     FILE(*ALL)                                    /*CCB003*/
/**/
/**/
/****SUCCESSFUL*COMPLETION*-*DELETE*JOURNAL*&*RECEIVER   */           /*CCB003*/
                                                                      /*CCB003*/
               IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                                                                      /*CCB003*/
             CHGVAR     VAR(&RESTART) VALUE('N')                      /*CCB003*/
                                                                      /*CCB003*/
             GOTO       CMDLBL(LOOP)                                  /*CCB003*/
                                                                      /*CCB003*/
/************ENDCMTCTL                                                /*CCB003*/
/************    ENDJRNPF   FILE(*ALL) JRN(JREC64N)                   /*CCB003*/
/************    DLTJRN     JRN(JREC64N)                              /*CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                           /*CCB003*/
/************    DLTJRNRCV  JRNRCV(JRREC64N)                          /*CCB003*/
/************    CHGJOB     INQMSGRPY(*RQD)                           /*CCB003*/
/**/
/*/COPY WNCPYSRC,REC64AMP2                                   /*S01408*/
/**/
/**/
/*/COPY WNCPYSRC,REC64A001                                   /*S01408*/
/**/
               ENDDO
/**/
/*   UNSUCCESSFUL COMPLETION - REMOVE JOURNALLED CHANGES   */
/**/
               ELSE       CMD(DO)
                                                                      /*CCB003*/
                 ROLLBACK
                 ENDCMTCTL
                                                                      /*CCB003*/
/************    ENDJRNPF   FILE(*ALL) JRN(JREC64N)                   /*CCB003*/
/************    DLTJRN     JRN(JREC64N)                              /*CCB003*/
/************    CHGJOB     INQMSGRPY(*DFT)                           /*CCB003*/
/************    DLTJRNRCV  JRNRCV(JRREC64N)                          /*CCB003*/
/************CHGJOB     INQMSGRPY(*RQD)                               /*CCB003*/
/**/
/*/COPY WNCPYSRC,REC64AMP3                                   /*S01408*/
/**/
/**/
/*/COPY WNCPYSRC,REC64AMP2                                   /*S01408*/
/**/
/****************GOTO       CMDLBL(ENDCL)                          */ /*085787*/
/**/
/********************************************************************** CCB003*/
/*           E R R O R     M E S S A G E S                           */
/********************************************************************** CCB003*/
/**/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/************  SNDPGMMSG  MSG('FILE OUT OF BALANCE - RE3664') +       /*CCB003*/
/************             TOMSGQ(MOPERQ)                              /*CCB003*/
               SNDPGMMSG  MSG('DATABASE ERROR - RE3664') +
                          TOMSGQ(MOPERQ)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&ERROR)
/**/
/*/COPY WNCPYSRC,REC64A003                                           */
               SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&ERROR) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/*/COPY WNCPYSRC,REC64A004                                           */
/**/
               SNDPGMMSG  MSG('DATABASE IN ERROR - RE3664') +
                          TOMSGQ(MOPERQ)
             ENDDO
             ENDDO
/**/
/************ENDCL:       ENDPGM                                      /*CCB003*/
                                                                      /*CCB003*/
ABNOR:                                                                /*CCB003*/
                                                                      /*CCB003*/
             SNDPGMMSG  MSG('Program REC64A ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CCB003*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB003*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB003*/
                                                                      /*CCB003*/
ENDCL:       IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*CCB003*/
             CHGVAR     VAR(&STAT) VALUE('N')                         /*CCB003*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB003*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CCB003*/
             ENDDO                                                    /*CCB003*/
                                                                      /*CCB003*/
             DLTOVR     FILE(*ALL)                                    /*CCB003*/
                                                                      /*CCB003*/
             ENDCMTCTL                                                /*CCB003*/
             MONMSG     MSGID(CPF0000)                                /*CCB003*/
                                                                      /*CCB003*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM                                                   /*CCB003*/
