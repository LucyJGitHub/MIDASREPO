/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Postings history maintenance component')     */
/*********************************************************************/
/*                                                                   */
/*  Midas General Ledger Module                                      */
/*                                                                   */
/*  GLC4450 - ACCOUNT POSTINGS HISTORY PURGE COMPONENT               */
/*                                                                   */
/*   WARNING - THIS PROGRAM IS RUNNING IN TASK SPLIT MODE.           */                 /*CGL127AY*/
/*             DO NOT ADD ANY NEW PROGRAMS TO THIS CL IF IT IS NOT   */                 /*CGL127AY*/
/*             ABLE TO RUN IN TASK SPLIT.                            */                 /*CGL127AY*/
/*                                                                   */                 /*CGL127AY*/
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. MD002850           Date 08Apr13              */
/*       Prev Amend No. CGL127AY           Date 06Aug12              */
/*                      CCB020             Date 06Aug12              */
/*                      CGL127AB           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK016             Date 04Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      190699             Date 12Mar01              */
/*                      188622             Date 17Jan01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      127318             DATE 26JUN97              */
/*                      107793             DATE 01OCT96              */
/*                      S01408             DATE 27JUN96              */
/*                      S01408             DATE 09FEB95              */
/*                      S01520             DATE 02NOV94              */
/*                      S01189             DATE 03MAY91              */
/*                      S01337             DATE 16APR91              */
/*                      S01238             DATE 03MAY90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*  MD002850 - Correct the processing for restart of subtasks        */
/*             after failure.                                        */
/*  CGL127AY - COB Restructure - GL COB Optimisation Phase 1         */
/*  CCB020 - COB Restructure - Secondary COB Infrastructure          */
/*  CGL127AB - General Ledger module optimisation - Phase 1          */
/*  CPK016 - Externalise STRCMTCTL code for ease of later upgrade.   */
/*  190699 - GLC2550 MSGW due to journal receiver overflow.          */
/*           Fully apply core 170465 from GLC2550 and delete all     */
/*           journal receivers before program terminates.            */
/*           CRTJRN to use MNGRCV(*SYSTEM).                          */
/*  188622 - GLC2550 MSGW due to journal receiver overflow.          */
/*           Fix is to specify in the cmd CRTJRNRCV the maximum      */
/*           storage space threshold limit and in the cmd            */
/*           CRTJRN to use MNGRCV(*SYSTEM).                          */
/*  CCB009 - Journal files throughout close of business              */
/*  CPK009 - Packaging for DBA3 release. STRCMTCTL values set        */
/*           to CMTSCOPE(*JOB).                                      */
/*  127318 - Call GL4450A instead of GL4450 if S01520 not installed. */
/*           This removes the need for journalling and commitment    */
/*           control and speeds up the purge.                        */
/*  107793 - Use journalling for recovery, rather than security      */
/*           copies, to speed up recovery and prevent the security   */
/*           copies crashing the machine.                            */
/*         - Remove the RGZPFM command - this is not required as     */
/*           the file has been changed to reuse deleted records.     */
/*    Note - all processing for security copying has been commented  */
/*           out, but the hooks have been re-inserted in the program */
/*           in the equivalent position, although this means that    */
/*           some hooks are next to each other.                      */
/*  S01408 - Core hook GLC4450001 added.                             */
/*           Core hook GLC4450END added.                             */
/*  S01408 - ADDITION OF CORE HOOK GLC4450INT                        */
/*           ADDITION OF CORE HOOK GLC4450MPS                        */
/*           ADDITION OF CORE HOOK GLC4450MP1                        */
/*           ADDITION OF CORE HOOK GLC4450MP2                        */
/*           ADDITION OF CORE HOOK GLC4450MP3                        */
/*  S01520 - BLI Account Statements Changes.                         */
/*  S01189 - COB II RESTART CHANGES                                  */
/*  S01337 - SPLIT 'D' LIB INTO 'DP' AND 'DV' LIBRARIES              */
/*  S01238 - CREATED DURING MIS INCORPORATION                        */
/*                                                                   */
/*********************************************************************/
/*********PGM                                                         /*S01189*/
             PGM        PARM(&CNAM &CSEQ)                             /*S01189*/
 
/**DCL*VAR(&BISCPY)*TYPE(*CHAR)*LEN(64)*VALUE('(c)*+*              */ /*107793*/
/******COPYRIGHT*ACT*INTERNATIONAL*LIMITED*1990,*1995')*           */ /*107793*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC4450INT                                     */    /*S01408*/
/**/                                                                  /*S01408*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                 /*S01189*/
/************DCL        VAR(&RESTART) TYPE(*CHAR) LEN(3)              /*S01189*/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01189*/
/************DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' '/*S01189 107793*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)              */          /*107793 CGL127AY*/
             DCL        VAR(&COUNT)  TYPE(*DEC)  LEN(2)               /*107793*/
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR)  LEN(1)                        */ /*107793 CCB020*/
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)                /*107793*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)               /*127318*/
             DCL        VAR(&S01520) TYPE(*CHAR) LEN(1)               /*127318*/
             DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)               /*127318*/
             DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)               /*127318*/
             DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)               /*127318*/
/************DCL        VAR(&DLIB) TYPE(*CHAR) LEN(6)                 /*S01337*/
/************DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)         /*S01337 107793*/
/************DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)                /*107793*/
/************DCL        VAR(&S01520) TYPE(*CHAR) LEN(1)        /*S01520 107793*/
/************DCL        VAR(&RTCD)   TYPE(*CHAR) LEN(7)        /*S01520 107793*/
/************DCL        VAR(&OPTN)   TYPE(*CHAR) LEN(7)        /*S01520 107793*/
/************DCL        VAR(&SAR)    TYPE(*CHAR) LEN(6)        /*S01520 107793*/
/**********                                                          */          /*CCB009 CGL127AY*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature*            */          /*CCB009 CGL127AY*/
/**********                                                          */          /*CCB009 CGL127AY*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)              */          /*CCB009 CGL127AY*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)             */          /*CCB009 CGL127AY*/
/**********  DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)             */          /*CPK016 CGL127AY*/
                                                                                        /*CGL127AY*/
/* Declare Variables for Task Splitting */                                              /*CGL127AY*/
                                                                                        /*CGL127AY*/
             DCL        VAR(&DRIVER) TYPE(*CHAR) LEN(10) +
                          VALUE(GLACHDPD)                                               /*CGL127AY*/
             DCL        VAR(&CSEQC) TYPE(*CHAR) LEN(5)                                  /*CGL127AY*/
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)                                /*CGL127AY*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL')                                                /*CGL127AY*/
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)                   /*CGL127AY*/
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)                               /*CGL127AY*/
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('ACPHPSERVE')                                           /*CGL127AY*/
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10)                               /*CGL127AY*/
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(600)                    /*CGL127AY*/
             DCL        VAR(&RESTART) TYPE(*CHAR) LEN(1)                                /*CGL127AY*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                                   /*CGL127AY*/
             DCL        VAR(&SNDMSG) TYPE(*CHAR) LEN(1) VALUE('N')                      /*CGL127AY*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,GLC4450001                                           /*S01408*/
                                                                                        /*CGL127AY*/
/* Global monitor message */                                                            /*CGL127AY*/
                                                                                        /*CGL127AY*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                                                /*CGL127AY*/
 
             SNDPGMMSG  MSG('GLC4450 - Postings History +
                          Maintenance') TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/***Check*for*Switchable*feature*CCB009.**/                                      /*CCB009 CGL127AY*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +     */                   /*CGL127AY*/
/**********               'CCB009' &AOFMT)                         */            /*CCB009 CGL127AY*/
/**********  CHGJOB     SWS(XXXXXX00)                              */                   /*CGL127AY*/
 
/**Determine*phase*of*system**/                                                    /*107793 CCB020*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*107793 CCB020*/
                                                                      /*107793*/
/* Set up Journal library name */                                     /*107793*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)          /*107793*/
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')         /*107793*/
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')       /*127318*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC4450MPS                                     */    /*S01408*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC4450MP1                                     */    /*S01408*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,GLC4450MP2                                     */    /*S01408*/
                                                                      /*107793*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*107793*/
             MONMSG     MSGID(CPF1023)                                /*107793*/
             CRTDTAARA  DTAARA(&DPLIB/RUNPRG) TYPE(*CHAR) LEN(1) +
                          VALUE('R') TEXT('Historic Postings purge +
                          control data area')                         /*127318*/
             MONMSG     MSGID(CPF1023)                                /*127318*/
             GRTOBJAUT  OBJ(&DPLIB/RUNPRG) OBJTYPE(*DTAARA) +
                          USER(*PUBLIC) AUT(*ALL)                     /*127318*/
             MONMSG     MSGID(CPF0000)                                /*127318*/
                                                                      /*107793*/
/*   Check if SAR S01520 is installed */                              /*127318*/
/**/                                                                  /*127318*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*127318*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*127318*/
             CHGVAR     VAR(&SAR)  VALUE('S01520')                    /*127318*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR)          /*127318*/
             IF         COND(&RTCD *EQ '       ') THEN(+
                CHGVAR     VAR(&S01520) VALUE('Y'))                   /*127318*/
             ELSE       CMD(+
                CHGVAR     VAR(&S01520) VALUE('N'))                   /*127318*/
                                                                                        /*CGL127AY*/
/* Read COB components file to check the restart status */                              /*CGL127AY*/
                                                                                        /*CGL127AY*/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)                             /*CGL127AY*/
                                                                                        /*CGL127AY*/
/* Check if any problems with CB0160 call */                                            /*CGL127AY*/
                                                                                        /*CGL127AY*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*CGL127AY*/
             GOTO       CMDLBL(ABNOR)                                                   /*CGL127AY*/
             ENDDO                                                                      /*CGL127AY*/
                                                                                        /*CGL127AY*/
             CHGVAR     VAR(&RESTART) VALUE(&STAT)                                      /*CGL127AY*/
                                                                                        /*CGL127AY*/
/* Set restart status to 'Y' */                                                         /*CGL127AY*/
                                                                                        /*CGL127AY*/
             CHGVAR     VAR(&STAT) VALUE('Y')                                           /*CGL127AY*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                             /*CGL127AY*/
                                                                                        /*CGL127AY*/
/* Set up call to QSNDDTAQ and override files to their members */                       /*CGL127AY*/
                                                                                        /*CGL127AY*/
             CHGVAR     VAR(&CSEQC) VALUE(&CSEQ)                                        /*CGL127AY*/
             CHGVAR     VAR(&MEMBER) VALUE('ACPHP' *CAT &CSEQC)                         /*CGL127AY*/
             CHGVAR     VAR(&RCVDTAQ) VALUE(&MEMBER)                                    /*CGL127AY*/
                                                                                        /*CGL127AY*/
             OVRDBF     FILE(&DRIVER) TOFILE(&DRIVER) MBR(&MEMBER)                      /*CGL127AY*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                                     /*CGL127AY*/
                                                                                        /*CGL127AY*/
/* If restart from component failed because of no response from    */                   /*CGL127AY*/
/* server, resend message to server and wait. */                                        /*CGL127AY*/
                                                                                        /*CGL127AY*/
             IF         COND(&RESTART = 'F') THEN(DO)                                   /*CGL127AY*/
             GOTO       CMDLBL(LOOP)                                                    /*CGL127AY*/
             ENDDO                                                                      /*CGL127AY*/
                                                                                        /*CGL127AY*/
/* If restart, not caused by server do not respond, */                                  /*CGL127AY*/
/* do not wait for the data queue entry */                                              /*CGL127AY*/
/* Clear any old data queue message from server but ensure that an */                   /*CGL127AY*/
/* 'END' message, sent from the end proc job is not lost */                             /*CGL127AY*/
                                                                                        /*CGL127AY*/
             IF         COND(&RESTART = 'Y') THEN(DO)                                   /*CGL127AY*/
             CHGVAR     VAR(&RCVWAIT) VALUE(5)                                          /*CGL127AY*/
             CALL       PGM(QRCVDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)                                 /*CGL127AY*/
             CHGVAR     VAR(&RCVWAIT) VALUE(600)                                        /*CGL127AY*/
             CHGVAR     VAR(&MSGLENGTH) VALUE(50)                                       /*CGL127AY*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)                       /*CGL127AY*/
             CALL       PGM(QSNDDTAQ) PARM(&MEMBER &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                                          /*CGL127AY*/
             ENDDO                                                                      /*CGL127AY*/
             GOTO       CMDLBL(RESTART)                                                 /*CGL127AY*/
             ENDDO                                                                      /*CGL127AY*/
                                                                                        /*CGL127AY*/
LOOP:                                                                                   /*CGL127AY*/
                                                                                        /*CGL127AY*/
/* Send message to main data queue */                                                   /*CGL127AY*/
                                                                                        /*CGL127AY*/
             CHGVAR     VAR(&MSGDATA) VALUE(&MEMBER)                                    /*CGL127AY*/
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                                          /*CGL127AY*/
/**********  CHGVAR     VAR(&STAT) VALUE('F')                      */          /*CGL127AY MD002850*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)        */          /*CGL127AY MD002850*/
                                                                                        /*CGL127AY*/
/* Wait on reply for 5 minutes */                                                       /*CGL127AY*/
                                                                                        /*CGL127AY*/
             CALL       PGM(QRCVDTAQ) PARM(&RCVDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)                                 /*CGL127AY*/
                                                                                        /*CGL127AY*/
             IF         COND(&MSGLENGTH = 0) THEN(DO)                                   /*CGL127AY*/
             CHGVAR     VAR(&STAT) VALUE('F')                                           /*MD002850*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                             /*MD002850*/
             SNDPGMMSG  MSG('No response from server for GLC4450') +
                          TOMSGQ(MOPERQ MRUNQ)                                          /*CGL127AY*/
             GOTO       CMDLBL(ABNOR)                                                   /*CGL127AY*/
             ENDDO                                                                      /*CGL127AY*/
                                                                                        /*CGL127AY*/
/* If reply = END, set restart status to 'N' and terminate */                           /*CGL127AY*/
                                                                                        /*CGL127AY*/
             IF         COND(%SST(&MSGDATA 1 3) = 'END') THEN(DO)                       /*CGL127AY*/
                                                                                        /*CGL127AY*/
             CHGVAR     VAR(&STAT) VALUE('N')                                           /*CGL127AY*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                             /*CGL127AY*/
                                                                                        /*CGL127AY*/
             GOTO       CMDLBL(END)                                                     /*CGL127AY*/
                                                                                        /*CGL127AY*/
             ENDDO                                                                      /*CGL127AY*/
                                                                                        /*CGL127AY*/
 RESTART:                                                                               /*CGL127AY*/
/**/                                                                  /*127318*/
/*  If S01520 Maintain Historic Postings NOT installed,            */ /*127318*/
/*      call GL4450A                                               */ /*127318*/
/**/                                                                  /*127318*/
             IF         COND(&S01520 *NE 'Y') THEN(DO)                /*127318*/
/**********  CALL       PGM(GL4450A)                               */            /*127318 CGL127AY*/
             CALL       PGM(GL4450A) PARM(&RESTART)                                     /*CGL127AY*/
             ENDDO                                                    /*127318*/
             ELSE       CMD(DO)                                       /*127318*/
                                                                      /*127318*/
/*  .. else set up journalling and commitment control and call         *127318*/
/*     GL4450                                                          *127318*/
/*/COPY WNCPYSRC,GLC4450004                                          */
LOOP1:                                                                /*107793*/
                                                                      /*107793*/
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/            /*CCB009 CGL127AB*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                  */ /*CCB009 CGL127AB*/
/***If*system*not*in*Input*Cycle,*set*up*journalling*environment****/            /*107793 CGL127AB*/
                                                                      /*107793*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                         */ /*107793 CGL127AB*/
                                                                      /*107793*/
/***Create*JRNRCV*with*AUTHORITY**PUBLIC**ALL*in*case*comp't*ends***/            /*107793 CGL127AB*/
/***and*is*restarted*by*a*different*user*who*may*require*authority**/            /*107793 CGL127AB*/
/***to*delete*this*journal*receiver.                               */            /*107793 CGL127AB*/
/********    CRTJRNRCV  JRNRCV(&JLIB/JRGLC4450) TEXT('Temporary +     /*188622*/
/********        journal receiver for component GLC4450')    /*107793* *188622*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRGLC4450) THRESHOLD(1919999) +                 */ /*CGL127AB*/
/**********               TEXT('Temporary journal receiver for +                     */ /*CGL127AB*/
/**********               component GLC4450')                                 */ /*188622 CGL127AB*/
/**********  MONMSG     MSGID(CPF7010) EXEC(DO)                               */ /*107793 CGL127AB*/
/**/                                                                  /*107793*/
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/JGLC4450)                        */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000)                                        */ /*107793 CGL127AB*/
/**/                                                                  /*107793*/
/**********  DLTJRN     JRN(&JLIB/JGLC4450)                                   */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF2105)                                        */ /*107793 CGL127AB*/
/**/                                                                  /*107793*/
/**Cannot*monitor*for*CPA*msgs,*but*must*ensure*job*takes*default***/            /*107793 CGL127AB*/
/**reply*for*message*CPA7025,*(delete*issued*without*full*save)*****/            /*107793 CGL127AB*/
/**********  CHGJOB     INQMSGRPY(*DFT)                                       */ /*107793 CGL127AB*/
/*********** DLTJRNRCV  JRNRCV(&JLIB/JRGLC4450)             */ /*107793 190699*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRGLC445*)                               */ /*190699 CGL127AB*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                       */ /*107793 CGL127AB*/
/**********  GOTO       CMDLBL(LOOP1)                                         */ /*107793 CGL127AB*/
/**********  ENDDO                                                            */ /*107793 CGL127AB*/
                                                                      /*107793*/
/***Create*journal*WITH*AUTHORITY**PUBLIC**ALL*in*case*COB*ends*****/            /*107793 CGL127AB*/
/***and*is*restaretd*by*a*different*user*who*may*require*authority**/            /*107793 CGL127AB*/
/***to*delete*this*journal.                                        */            /*107793 CGL127AB*/
 LOOP2:                                                               /*107793*/
/*********   CRTJRN     JRN(&JLIB/JGLC4450) JRNRCV(&JLIB/JRGLC4450) +
/*********                TEXT('Temporary journal for component +
/*********                GLC4450') AUT(*ALL)                /*107793* *188622*/
/**********  CRTJRN     JRN(&JLIB/JGLC4450) JRNRCV(&JLIB/JRGLC4450) +                */ /*CGL127AB*/
/**********               MNGRCV(*SYSTEM) TEXT('Temporary journal +                  */ /*CGL127AB*/
/**********               for component GLC4450') AUT(*ALL)                   */ /*188622 CGL127AB*/
/**********  MONMSG     MSGID(CPF7010 CPF7015) EXEC(DO)                       */ /*107793 CGL127AB*/
/*********   DLTJRN     JRN(&JLIB/JGLC4450)                  /*107793* *188622*/
/**********  DLTJRN     JRN(&JLIB/JGLC445*)                                   */ /*188622 CGL127AB*/
/**********  GOTO       CMDLBL(LOOP2)                                         */ /*107793 CGL127AB*/
/**********  ENDDO                                                            */ /*107793 CGL127AB*/
                                                                      /*107793*/
/**********  ENDDO                                                            */ /*107793 CGL127AB*/
                                                                      /*107793*/
RETRY:                                                                /*107793*/
                                                                      /*107793*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                         */ /*107793 CGL127AB*/
/**********  STRJRNPF   FILE(GLACPHPD) JRN(JGLC4450) IMAGES(*BOTH)            */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF7030)                                        */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))             */ /*107793 CGL127AB*/
/**********  STRJRNPF   FILE(ACCNTAB) JRN(JGLC4450) IMAGES(*BOTH)             */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF7030)                                        */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))             */ /*107793 CGL127AB*/
/**COPY WNCPYSRC,GLC4450002                                                          */ /*CGL127AB*/
/**********  ENDDO                                                            */ /*107793 CGL127AB*/
/**********  ELSE       CMD(DO)                                               */ /*107793 CGL127AB*/
/**********  STRJRNPF   FILE(GLACPHPD) JRN(ICJRN) IMAGES(*BOTH)               */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF7030)                                        */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))             */ /*107793 CGL127AB*/
/**********  STRJRNPF   FILE(ACCNTAB) JRN(ICJRN) IMAGES(*BOTH)                */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF7030)                                        */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))             */ /*107793 CGL127AB*/
/**COPY WNCPYSRC,GLC4450003                                                          */ /*CGL127AB*/
/**********  ENDDO                                                            */ /*107793 CGL127AB*/
                                                                      /*107793*/
/**********  GOTO       CMDLBL(BYPASS)                                        */ /*107793 CGL127AB*/
                                                                      /*107793*/
JRNFAIL:                                                              /*107793*/
/**********  CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)                         */ /*107793 CGL127AB*/
/**********  IF         COND(&COUNT *LE 3) THEN(DO)                           */ /*107793 CGL127AB*/
/**********  DLYJOB     DLY(60)                                               */ /*107793 CGL127AB*/
/**********  GOTO       CMDLBL(RETRY)                                         */ /*107793 CGL127AB*/
/**********  ENDDO                                                            */ /*107793 CGL127AB*/
/**********  ELSE       CMD(DO)                                               */ /*107793 CGL127AB*/
/**********  GOTO       CMDLBL(ABNOR)                                         */ /*107793 CGL127AB*/
/**********  ENDDO                                                            */ /*107793 CGL127AB*/
/**********  ENDDO                                                            */ /*CCB009 CGL127AB*/
                                                                      /*107793*/
                                                                      /*107793*/
BYPASS:                                                               /*107793*/
/*/COPY WNCPYSRC,GLC4450005                                          */
                                                                      /*107793*/
/* Start commitment control */                                                            /*CPK016*/
/**********  STRCMTCTL  LCKLVL(*CHG)                          /*107793  CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB) */                         /*CPK009*/ /*CPK016*/
/**********  MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +                         /*CPK016*/
/**********               VALUE('Y'))                                                     /*CPK016*/
/**********  CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)            */            /*CPK016 CGL127AY*/
/**********  IF         COND(&CMTRTN *EQ '*ACTIVE   ') THEN(CHGVAR +*/                  /*CGL127AY*/
/**********               VAR(&CMTCTL) VALUE('Y'))                 */                   /*CGL127AY*/
                                                                      /*107793*/
/* Call postings purge program  */                                    /*107793*/
/*/COPY WNCPYSRC,GLC4450006                                          */
                                                                      /*107793*/
/**********  CALL       PGM(GL4450)                                */            /*107793 CGL127AY*/
             CALL       PGM(GL4450) PARM(&RESTART)                                      /*CGL127AY*/
                                                                      /*107793*/
             ENDDO                                                    /*127318*/
                                                                      /*127318*/
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)                      /*107793*/
                                                                      /*107793*/
/*/COPY WNCPYSRC,GLC4450MP3                                        */ /*107793*/
                                                                      /*107793*/
             ENDDO                                                    /*107793*/
             ELSE       CMD(DO)                                       /*107793*/
                                                                      /*107793*/
/* Database error routine */                                          /*107793*/
                                                                      /*107793*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*107793*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*107793*/
             GOTO       CMDLBL(ABNOR)                                 /*107793*/
             ENDDO                                                    /*107793*/
                                                                      /*107793*/
             CHGVAR     VAR(&RESTART) VALUE('N')                                        /*CGL127AY*/
             GOTO       CMDLBL(LOOP)                                                    /*CGL127AY*/
                                                                                        /*CGL127AY*/
/**********  GOTO       CMDLBL(END)                                */            /*107793 CGL127AY*/
/*/COPY WNCPYSRC,GLC4450007                                          */
 ABNOR:                                                               /*107793*/
/*/COPY WNCPYSRC,GLC4450ERR                                        */ /*107793*/
             DMPCLPGM                                                 /*107793*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*107793*/
             CHGJOB     SWS(XXXXXX11)                                 /*107793*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*107793*/
             SNDPGMMSG  MSG('Program GLC4450 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)                        /*107793*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*107793*/
                                                                      /*107793*/
 END:                                                                 /*107793*/
/*/COPY WNCPYSRC,GLC4450END                                        */ /*107793*/
                                                                      /*107793*/
             ROLLBACK                                                 /*107793*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*107793*/
                                                                      /*107793*/
             CHGVAR     VAR(&RESTART) VALUE('E')                                        /*CGL127AY*/
             IF         COND(&S01520 *EQ 'Y') THEN(DO)                                  /*CGL127AY*/
             CALL       PGM(GL4450) PARM(&RESTART)                                      /*CGL127AY*/
             ENDDO                                                                      /*CGL127AY*/
             ELSE       DO                                                              /*CGL127AY*/
             CALL       PGM(GL4450A) PARM(&RESTART)                                     /*CGL127AY*/
             ENDDO                                                                      /*CGL127AY*/
                                                                                        /*CGL127AY*/
/**********  IF         COND(&CMTCTL *NE 'Y') THEN(DO)             */            /*107793 CGL127AY*/
             ENDCMTCTL                                                /*107793*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*107793*/
/**********  ENDDO                                                 */            /*107793 CGL127AY*/
                                                                      /*107793*/
             DLTDTAARA  DTAARA(&DPLIB/RUNPRG)                         /*127318*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*127318*/
                                                                      /*127318*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                  */ /*CCB009 CGL127AB*/
/**********  ENDJRNPF   FILE(*ALL) JRN(JGLC4450)                              */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        */ /*107793 CGL127AB*/
/**********  ENDJRNPF   FILE(GLACPHPD) JRN(ICJRN)                             */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        */ /*107793 CGL127AB*/
                                                                      /*107793*/
/**********  DLTJRN     JRN(&JLIB/JGLC4450)                                   */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        */ /*107793 CGL127AB*/
                                                                      /*107793*/
/**********  CHGJOB     INQMSGRPY(*DFT)                                       */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        */ /*107793 CGL127AB*/
/*********** DLTJRNRCV  JRNRCV(&JLIB/JRGLC4450)                    */ /*190699*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRGLC445*)                               */ /*190699 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        */ /*107793 CGL127AB*/
/*/COPY WNCPYSRC,GLC4450008                                          */
/**********  CHGJOB     INQMSGRPY(*RQD)                                       */ /*107793 CGL127AB*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                        */ /*107793 CGL127AB*/
/**********  ENDDO                                                            */ /*CCB009 CGL127AB*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*                                                                    /*S01408*/
             ENDPGM                                                   /*107793*/
                                                               /*S01520 107793*/
/****Check*if SAR S01520 is installed */                       /*S01520 107793*/
/************                                                         /*107793*/
/************CHGVAR     VAR(&RTCD) VALUE('       ')            /*S01520*107793*/
/************CHGVAR     VAR(&OPTN) VALUE('*VERIFY')            /*S01520*107793*/
/************CHGVAR     VAR(&SAR)  VALUE('S01520')             /*S01520*107793*/
/************CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR)   /*S01520*107793*/
/************IF         COND(&RTCD *EQ '       ') THEN(+              /*107793*/
/************   CHGVAR     VAR(&S01520) VALUE('Y'))            /*S01520*107793*/
/************ELSE       CMD(+                                         /*107793*/
/************   CHGVAR     VAR(&S01520) VALUE('N'))            /*S01520*107793*/
/************                                                         /*107793*/
/**RETRIEVE*RESTART*FLAG**/                                    /*S01189*107793*/
/************                                                         /*107793*/
/************RTVDTAARA  DTAARA(GLSTAT (54 3)) RTNVAR(&RESTART) /*S01189*107793*/
/************                                                         /*107793*/
/****Call*PGM CB0160 , to find out the value of Busy           /*S01189*107793*/
/************                                                  /*S01189*107793*/
/************CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)    /*S01189*107793*/
/************                                                         /*107793*/
/**SETUP*SECURITY COPY LIBRARY NAME */                                /*107793*/
/************                                                         /*107793*/
/************RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)          /*107793*/
/************CHGVAR     VAR(&DLIB) VALUE(&PREFIX *CAT 'DLIB')  /*S01337*107793*/
/************CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB' /*S01337*107793*/
/************CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')       /*107793*/
/************                                                  /*S01408*107793*/
/*/COPY*WNCPYSRC,GLC4450MPS                                     */    /*S01408*/
/************                                                         /*107793*/
/**IF*THIS*IS NOT A RESTART THEN CREATE SECURITY COPY */              /*107793*/
/************IF         COND(&RESTART *EQ 'OLD') THEN(DO)      /*S01189*107793*/
/************IF         COND(&BUSY *EQ 'N') THEN(DO)           /*S01189*107793*/
/*****************DLTF       FILE(&DLIB/XGLACPHPD)             /*S01337*107793*/
/************     DLTF       FILE(&DPLIB/XGLACPHPD)            /*S01337*107793*/
/************                MONMSG     MSGID(CPF0000)                /*107793*/
/*****************CPYF       FROMFILE(&DMLIB/GLACPHPD) +              /*107793*/
/*****************             TOFILE(&DLIB/XGLACPHPD) +              /*107793*/
/*****************             MBROPT(*REPLACE) CRTFILE(*YES)  /*S01337*107793*/
/************     CPYF       FROMFILE(&DMLIB/GLACPHPD) +              /*107793*/
/************                  TOFILE(&DPLIB/XGLACPHPD) +             /*107793*/
/************                  MBROPT(*REPLACE) CRTFILE(*YES)  /*S01337*107793*/
/************                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)/*107793*/
/************                                                  /*S01520*107793*/
/************     IF         COND(&S01520 *EQ 'Y') THEN(DO)    /*S01520*107793*/
/************        DLTF       FILE(&DPLIB/XACCNTAB)          /*S01520*107793*/
/************        MONMSG     MSGID(CPF0000)                 /*S01520*107793*/
/************        CPYF       FROMFILE(&DMLIB/ACCNTAB) +            /*107793*/
/************                     TOFILE(&DPLIB/XACCNTAB) +           /*107793*/
/************                     MBROPT(*REPLACE) CRTFILE(*YE /*S01520*107793*/
/************        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) /*S01520*107793*/
/************     ENDDO                                        /*S01520*107793*/
/************                                                  /*S01520*107793*/
/*****************CHGDTAARA  DTAARA(GLSTAT (54 3)) VALUE('NEW' /*S01189*107793*/
/************                                                  /*S01408*107793*/
/*/COPY*WNCPYSRC,GLC4450MP1                                     */    /*S01408*/
/************     CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'Y') /*S01189*107793*/
/***********ENDDO                                                     /*107793*/
/************                                                         /*107793*/
/***********ELSE       CMD(DO)                                        /*107793*/
/************                                                         /*107793*/
/**IF*THIS*IS A RESTART THEN COPY SECURITY COPY BACK TO MASTER FILE * /*107793*/
/************                                                         /*107793*/
/*****************CPYF       FROMFILE(&DLIB/XGLACPHPD) +              /*107793*/
/*****************            TOFILE(&DMLIB/GLACPHPD) MBROPT(*REP*S01337107793*/
/************     CPYF       FROMFILE(&DPLIB/XGLACPHPD) TOFILE+       /*107793*/
/************                  (&DMLIB/GLACPHPD) MBROPT(*REPLACE)*S01337107793*/
/************                MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +*107793*/
/************                  EXEC(CLRPFM FILE(&DMLIB/GLACPHPD))     /*107793*/
/************                                                  /*S01520*107793*/
/************     IF         COND(&S01520 *EQ 'Y') THEN(DO)    /*S01520*107793*/
/************        CPYF       FROMFILE(&DPLIB/XACCNTAB) TOFILE+     /*107793*/
/************                     (&DMLIB/ACCNTAB) MBROPT(*REP /*S01520*107793*/
/************        MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +      /*107793*/
/************                      EXEC(CLRPFM FILE(&DMLIB/ACC /*S01520*107793*/
/************     ENDDO                                        /*S01520*107793*/
/************                                                  /*S01520*107793*/
/*/COPY*WNCPYSRC,GLC4450MP2                                    /*S01408*107793*/
/************                                                  /*S01408*107793*/
/***********ENDDO                                                     /*107793*/
/************                                                         /*107793*/
/**CALL*POSTINGS HISTORY PURGE PROGRAM */                             /*107793*/
/************                                                         /*107793*/
/************CALL       PGM(GL4450)                                   /*107793*/
/************IF COND(%SWITCH(XXXXXX00)) THEN(DO)                      /*107793*/
/************                                                         /*107793*/
/**IF*PURGE*IS SUCCESSFUL THEN REORGANIZE MASTER FILE */              /*107793*/
/************    CPYF       FROMFILE(&DMLIB/GLACPHPD) +               /*107793*/
/************                 TOFILE(QTEMP/GLACPHPD) MBROPT(*REPLACE) +*107793*/
/************                 CRTFILE(*YES)                           /*107793*/
/************               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) /*107793*/
/************    RGZPFM     FILE(QTEMP/GLACPHPD)                      /*107793*/
/************               MONMSG     MSGID(CPF2981)                 /*107793*/
/************    CPYF       FROMFILE(QTEMP/GLACPHPD) +                /*107793*/
/************                TOFILE(&DMLIB/GLACPHPD) MBROPT(*REPLACE) +*107793*/
/************                CRTFILE(*NO)                             /*107793*/
/************               MONMSG    MSGID(CPF2817) CMPDTA(CPF2869) +/*107793*/
/************                 EXEC(CLRPFM FILE(&DMLIB/GLACPHPD))      /*107793*/
/**SET*OFF*THE*RESTART*FLAG**/                                 /*S01189*107793*/
/**SET*OFF*THE BUSY FLAG */                                    /*S01189*107793*/
/*/COPY*WNCPYSRC,GLC4450MP3                                    /*S01408*107793*/
/****************CHGDTAARA  DTAARA(GLSTAT (54 3)) VALUE('OLD') /*S01189*107793*/
/************    CALL       PGM(CB0150) PARM(&CNAM &CSEQ 'N')  /*S01189*107793*/
/****************DLTF       FILE(&DLIB/XGLACPHPD)              /*S01337*107793*/
/************    DLTF       FILE(&DPLIB/XGLACPHPD)             /*S01337*107793*/
/************    MONMSG     MSGID(CPF0000)                            /*107793*/
/************                                                  /*S01520*107793*/
/************    IF         COND(&S01520 *EQ 'Y') THEN(DO)     /*S01520*107793*/
/************       DLTF       FILE(&DPLIB/XACCNTAB)           /*S01520*107793*/
/************       MONMSG     MSGID(CPF0000)                  /*S01520*107793*/
/************    ENDDO                                         /*S01520*107793*/
/************                                                  /*S01520*107793*/
/************ENDDO                                                    /*107793*/
/************                                                         /*107793*/
/************ELSE       CMD(DO)                                       /*107793*/
/************                                                         /*107793*/
/**DATABASE*ERROR ROUTINE */                                          /*107793*/
/************                                                  /*S01189*107793*/
/******************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM /*S01189*107793*/
/************      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)       /*107793*/
/************      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +*107793*/
/************                 TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)       /*107793*/
/************ENDDO                                                    /*107793*/
/************                                                         /*107793*/
/************                                                         /*107793*/
/******CHGVAR &BISCPY '(C) COPYRIGHT MKI LIMITED 1995'  /*107793*/
/************                                                  /*S01408*107793*/
/*/COPY*WNCPYSRC,GLC4450END                                    /*S01408*107793*/
/************                                                  /*S01408*107793*/
/************ENDPGM                                                   /*107793*/
