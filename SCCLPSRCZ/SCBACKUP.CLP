/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Input cycle log/database backup')            */
/********************************************************************/
/*                                                                  */
/*      Midas     - System Control Module                           */
/*                                                                  */
/*      SCBACKUP - INPUT CYCLE DATABASE BACKUP                      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD053437           Date 07Oct19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSC033             Date 18May07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG2381            Date 13May04              */
/*                      CRE020             Date 20Jan04              */
/*                      CGP004             Date 23Feb04              */
/*                      CSC023             Date 02Feb04              */
/*                      CPK017             Date 28Oct03              */
/*                      CRE008             Date 19Feb02              */
/*                      CGL013             Date 29Mar02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC011             Date 18SEP01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CCM003             Date 27Mar01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CRT004             Date 12May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      176691             Date 03Mar00              */
/*                      180491             Date 20Jun00              */
/*                      CDE001             Date 12Nov99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009             Date 18Mar99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      139764             Date 29Jul98              */
/*                      CAP002             Date 05May98              */
/*                      CLE004             DATE 11MAY97              */
/*                      CGL004             DATE 03NOV97             */
/*                      CED007             DATE 03NOV97             */
/*                      092719             DATE 22JAN97             */
/*                      110242             DATE 07NOV96             */
/*                      093022             DATE 27JUN96             */
/*                      101971             DATE 15MAY96             */
/*                      S01408             DATE 10APR96             */
/*                      CCM002             DATE 04SEP95             */
/*                      081177             DATE 07MAR95             */
/*                      S01493             DATE 01JUN94             */
/*                      S01343             DATE  21AUG91            */
/*                      E26655             DATE  12AUG91            */
/*                      RT0142             DATE  03JUN91            */
/*                      E20391             DATE  26NOV89            */
/*                      E16342             DATE  09/03/89           */
/*                      S01179             DATE  10/09/88           */
/*                      S01127             DATE  03/06/88           */
/*                      S01128             DATE  05/05/87           */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD053437 - CGL013 FTP exit program                          */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC033 - Include global libraries in database saves.        */
/*       BUG2381 - Batch submit of confirmations programs            */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CGP004 - Audit Reporting                                    */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK017 - Midas Plus packaging.                              */
/*                Comment out the remove of msg from MSTATUS and     */
/*                the send of 'MIDAS' at ENDCLPGM.                   */
/*       CRE008 - Cash Management                                    */
/*       CGL013 - MT94x Message Generation                           */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CCM003 - Condition DL0003 on CCM003.                        */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*       176691 - Remove the CLE006(Syndications) conditioning       */
/*       180491 - Add mode parameter to DEC0040 call.                */
/*       CDE001 - Data Export - CCRM Limits                          */
/*       CGL009 - Midas-Fontis Inter-Account Transfers (IAT) and     */
/*                Third Party Payments (TPP) Interface               */
/*       139764 - The call to AOSARDR0 for CAP002 should specify     */
/*                the option parameter as *VERIFY.                   */
/*       CAP002 - Conversion of input functions to APIs.            */
/*       CLE004 - Customer Lending Enhancements - Syndications      */
/*       CGL004 - Midas-Fontis interface, add submission of         */
/*                Background job                                    */
/*       CED007 - ED enhancements, change JOBQ for submission of    */
/*                EDCONTROL.                                        */
/*       092719  -  I/C DB SAVE DOES NOT KILL THE RCF JOB           */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD      */
/*       093022 - D/B save ended abnormally with CPF24B4 because    */
/*                parameter defined incorrectly  - &PRM02 should be */
/*                1 long.                                           */
/*       101971 - Change name of EDC0040 job to                      */
/*                descriptive EDCONTROL                              */
/*       S01408 - Addition of core hook SCBACKUINT                   */
/*                Addition of core hook SCBACKUMPE                   */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI).      */
/*                If feature is on, re-submit the Citydealer back-   */
/*                ground jobs after the database save has completed. */
/*       081177  -  Use Job Description library list instead of     */
/*                  current library list when submitting job.       */
/*       S01493  -  MIDAS EXPORT DATA MODULE - ADD SUBMISSION       */
/*                  OF 'DRIP FEED' JOB.                             */
/*       S01343  -  SC/RR/SD MODULE RENAME PROJECT.                 */
/*                  -  SCBACKUP RENAMED FROM MBACKUP                */
/*       E26655  -  AMEND CALLS TO SCC0010 TO REFLECT THE REWRITE   */
/*                  OF THAT PROGRAM.                                */
/*       RT0142  -  REPLACE *EXT MESSAGES WITH CALL TO NEW          */
/*                  PROGRAM SCC0010.                                */
/*               -  REMOVE REDUNDANT DCL COMMAND.                   */
/*       E20391  -  RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.        */ /*E20391*/
/*       E16342  -  EM0100 JOB SHOULD BE EM0101                    */ /*E16342*/
/*       S01179  -  AS400 CONVERSION                                */
/*       S01127  -  FUTURES AND OPTIONS INCORPORATION               */
/*       S01128 - DATA AREAS MMOD & EMSTAT ARE NOT RECEIVED         */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&PRM01 &PRM02)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCBACKUINT                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                            */
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
/************DCL        &PRM02        TYPE(*CHAR)  LEN(8)             /*093022*/
             DCL        &PRM02        TYPE(*CHAR)  LEN(1)             /*093022*/
/************DCL        &SPECIAL      TYPE(*CHAR)  LEN(6)             /*RT0142*/
             DCL        &STATMSG      TYPE(*CHAR)  LEN(5)
             DCL        &RPY          TYPE(*CHAR)  LEN(1)
             DCL        VAR(&FF) TYPE(*CHAR) LEN(1)                   /*S01127*/
/***         DCLDTAARA  EMSTAT                                      *  *S01179*/
/***         DCLDTAARA  MMOD                                        *  *S01179*/
/***         DCLDTAARA  MPHAS                                       *  *S01179*/
             DCL        VAR(&EMSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                /*S01179*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*E26655*/
             DCL VAR(&AOMMOD) TYPE(*CHAR) LEN(200)                    /*S01493*/
             DCL VAR(&OPTN)  TYPE(*CHAR) LEN(7) VALUE('*FIRST')       /*S01493*/
             DCL VAR(&RTNC)  TYPE(*CHAR) LEN(7)                       /*S01493*/
             DCL        VAR(&DTQDLEN) TYPE(*DEC) LEN(5) VALUE(1)      /*092719*/
             DCL        VAR(&T) TYPE(*CHAR) LEN(1) VALUE('T')         /*092719*/
             DCL        VAR(&CITYDLR) TYPE(*CHAR) LEN(1) VALUE('N')   /*CCM002*/
             DCL        VAR(&CDSTAT) TYPE(*CHAR) LEN(27)              /*CCM002*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CCM002*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)             /*CCM002*/
             DCL        VAR(&CLE004) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CLE004*/
/*********** DCL        VAR(&CLE006) TYPE(*CHAR) LEN( )*/ /*CLE004*/  /*176691*/
             DCL        VAR(&CLE010) TYPE(*CHAR) LEN(1) VALUE('N' )   /*176691*/
             DCL        VAR(&CAP002) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CAP002*/
             DCL        VAR(&CGL009) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CGL009*/
             DCL        VAR(&CDE001) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CDE001*/
             DCL        VAR(&CRE008) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CRE008*/
             DCL        VAR(&CGP004) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CGP004*/
             DCL        VAR(&CRT004) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CRT004*/
             DCL        VAR(&CCM003) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CCM003*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CGL004*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CGL004*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC011*/
             DCL        VAR(&APIBKJOB) TYPE(*CHAR) LEN(1) VALUE('Y')                      /*CSC011*/
             DCL        VAR(&CURR) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&MMODE) TYPE(*CHAR) LEN(1)                                    /*CSC011*/
             DCL        VAR(&MAIN) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&SOVR) TYPE(*CHAR) LEN(1)                                     /*CSC011*/
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)                                    /*CSC033*/
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)                                    /*CSC033*/
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)                                     /*CSC033*/
                                                                                          /*CSC011*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CRE020*/
             DCL        VAR(&CGL013) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC033*/
             DCL        VAR(&WFTP) TYPE(*CHAR) LEN(1)                                   /*MD053437*/
                                                                                          /*CRE020*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
/*  Check if MT94x Message Generation is on                                               /*CSC033*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL013' +
                          &FMT)                                                           /*CSC033*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CGL013) VALUE('Y'))                                        /*CSC033*/
                                                                      /*CAP002*/
/*  Check if the API Switchable Feature is on                         /*CAP002*/
             CHGVAR     VAR(&SAR) VALUE('CAP002')                     /*CAP002*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*139764*/
             CALL      PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)   /*CAP002*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP002) VALUE('Y'))                    /*CAP002*/
/**/                                                                  /*CRT004*/
/*    Check if Cashier TCP/IP Interface feature is active (CRT004)    /*CRT004*/
/**/                                                                  /*CRT004*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CRT004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CRT004*/
             CHGVAR     VAR(&SAR) VALUE('CRT004')                     /*CRT004*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CRT004*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CRT004) VALUE('Y'))                    /*CRT004*/
/**/                                                                  /*CLE004*/
/*    Check if Lending Enhancements feature is active (CLE004)        /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SAR) VALUE('CLE004')                     /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CLE004*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE004) VALUE('Y'))                    /*CLE004*/
/**/                                                                  /*CCM003*/
/*    Check if Midas/City Dealer interface is active (CCM003)         /*CCM003*/
/**/                                                                  /*CCM003*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CCM003*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CCM003*/
             CHGVAR     VAR(&SAR) VALUE('CCM003')                     /*CCM003*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CCM003*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CCM003) VALUE('Y'))                    /*CCM003*/
/**/                                                                  /*CLE004*/
/* Check if Lending Enhancements feature is active(CLE006)/*CLE004*/   /*176691*/
/**/                                                        /*CLE004*/ /*176691*/
/*********** CHGVAR     VAR(&RTNC) VALUE('       ')         /*CLE004*/ /*176691*/
/*********** CHGVAR     VAR(&OPTN) VALUE('*VERIFY')         /*CLE004*/ /*176691*/
/*********** CHGVAR     VAR(&SAR) VALUE('CLE006')           /*CLE004*/ /*176691*/
/*********** CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &C)  /*CLE004*/ /*176691*/
/*********** IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
/***********              VAR(&CLE006) VALUE('Y'))                    /*176691*/
/**/                                                                  /*176691*/
/*    Check if Lending Enhancements feature is active (CLE010)        /*176691*/
/**/                                                                  /*176691*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*176691*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*176691*/
             CHGVAR     VAR(&SAR) VALUE('CLE010')                     /*176691*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*176691*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE010) VALUE('Y'))                    /*176691*/
/**/                                                                  /*CDE001*/
/*    Check if CCRM - Limits is active (CDE001)                       /*CDE001*/
/**/                                                                  /*CDE001*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CDE001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDE001*/
             CHGVAR     VAR(&SAR) VALUE('CDE001')                     /*CDE001*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CDE001*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE001) VALUE('Y'))                    /*CDE001*/
                                                                                          /*CSC011*/
/** Check if 24x7 Midas Availability Feature is on */                                     /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&SAR) VALUE('CSC011')                                         /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CSC011*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSC011*/
                CHGVAR     VAR(&CSC011) VALUE('Y')                                        /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**/                                                                  /*CRE008*/
/*    Check if Cash Management is active (CRE008)                     /*CRE008*/
/**/                                                                  /*CRE008*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CRE008*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CRE008*/
             CHGVAR     VAR(&SAR) VALUE('CRE008')                     /*CRE008*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CRE008*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE008) VALUE('Y'))                    /*CRE008*/
/**/                                                                  /*CGP004*/
/*    Check if Audit Reporting is active (CGP004)                     /*CGP004*/
/**/                                                                  /*CGP004*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CGP004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CGP004*/
             CHGVAR     VAR(&SAR) VALUE('CGP004')                     /*CGP004*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CGP004*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CGP004) VALUE('Y'))                    /*CGP004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')                    /*CLE004*/
/*********** IF       COND(&CLE004 *EQ 'Y' *AND &CLE006 *EQ 'Y') +
/***********            THEN(CALL PGM(LEC2011))            /*CLE004*/ /*176691*/
             IF       COND(&CLE004 *EQ 'Y' *AND &CLE010 *EQ 'Y') +
                        THEN(CALL PGM(LEC2011))                       /*176691*/
/*                                                                   */
/**/                                                                                      /*CSC033*/
/*  Terminate online global layer update job, GO_ONL_SYN.                                 /*CSC033*/
/**/                                                                                      /*CSC033*/
             CALL       PGM(GOC0102) PARM('END')                                          /*CSC033*/
/**/                                                                                      /*CCS033*/
/*  If MT94x Message Generation is present, shut it down                                  /*CCS033*/
/**/                                                                                      /*CSC033*/
             IF         COND(&CGL013 *EQ 'Y') THEN(DO)                                    /*CSC033*/
                CALL       PGM(GLC001410) PARM('*END  ' '*SYNCH ' ' ')                    /*CSC033*/
                CALL       PGM(QSNDDTAQ) PARM(SD_MID_FTP *LIBL +
                          X'00001F' T)                                                  /*MD053437*/
             ENDDO       /*CSC033*/
/**/                                                                  /*CDE001*/
/* If the CCRM - Limits Drip Feed job is active, shut it down         /*CDE001*/
/**/                                                                  /*CDE001*/
/**********  IF         COND(&CDE001 *EQ 'Y') +
/**********               THEN(CALL PGM(DEC0040))                              /*CDE001*/ /*180491*/
             IF         COND(&CDE001 *EQ 'Y') THEN(CALL PGM(DEC0040) +
                          PARM('I'))                                                      /*180491*/
/*                                                                    /*CDE001*/
/**/                                                                  /*CRE008*/
/* If the Cash Management batch jobs are active, shut them down       /*CRE008*/
/**/                                                                  /*CRE008*/
             IF         COND(&CRE008 *EQ 'Y') THEN(DO)                /*CRE008*/
             CALL       PGM(REC101203)                                /*CRE008*/
             CALL       PGM(REC101503)                                /*CRE008*/
             ENDDO                                                    /*CRE008*/
/*                                                                    /*CRE008*/
                                                                                          /*CRE020*/
/** Check if MidasPlus Online Printing of Advices is on */                                /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CRE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
             CHGVAR     VAR(&SAR) VALUE('CRE020')                                         /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CRE020*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE020) VALUE('Y'))                                        /*CRE020*/
                                                                                          /*CRE020*/
/** If the APIs Retails Advices Job is active, shut it down */                            /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&CRE020 *EQ 'Y') THEN(DO)                                    /*CRE020*/
                CALL       PGM(APC0470)                                                   /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
/**/                                                                  /*CGP004*/
/* If the Audit Reporting batch job is active, shut it down           /*CGP004*/
/**/                                                                  /*CGP004*/
             IF         COND(&CGP004 *EQ 'Y') THEN(DO)                /*CGP004*/
                 CALL       PGM(GOC0301)                              /*CGP004*/
             ENDDO                                                    /*CGP004*/
/**/                                                                                     /*BUG2381*/
/* If the APIs Confirmations job is active, shut it down                                 /*BUG2381*/
/**/                                                                                     /*BUG2381*/
             CALL       PGM(APC0440)                                                     /*BUG2381*/
/**/                                                                                     /*BUG2381*/
/*                                                                    /*CGP004*/
/***         RCVDTAARA  MPHAS                                       *  *S01179*/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                  /*S01179*/
/*                                                                   */
/*       S01128 - RECEIVE DATA AREA MMOD & EMSTAT           /*S01179*  *S01128*/
/***         RCVDTAARA  MMOD                                /*S01179*  *S01128*/
/***         RCVDTAARA  EMSTAT                              /*S01179*  *S01128*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
             RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)                /*S01179*/
/*                                                                  */
/* First allocate the message queue.                                */
/*                                                                  */
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(9999)
             SNDMSG     MSG('BACKUP') TOMSGQ(MSPECIAL)
/************CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                                      */ /*CPK017*/
/************RCVMSG     MSGQ(MSTATUS)                                                  */ /*CPK017*/
LOOP1:       CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&STATMSG)
             IF         COND(&STATMSG *NE '     ') THEN(DO)
/*OP2:*******SNDPGMMSG  MSG('Job cannot be run now - do you wish to +
/************          re-try - Y or N?') TOPGMQ(*EXT) MSGTYPE(*INQ)  /*RT0124*/
/************RCVMSG     PGMQ(*N) MSGTYPE(*RPY) WAIT(*MAX) +
/************             RMV(*YES) MSG(&RPY)                         /*RT0142*/
                                                                      /*RT0142*/
/*  CALL SCC0010 TO INFORM USER THAT JOB CANNOT BE RUN NOW  */        /*RT0142*/
                                                                      /*RT0142*/
 LOOP2:      CHGVAR     VAR(&RPY) VALUE('Y')                          /*RT0142*/
                                                                      /*RT0142*/
/************CALL   PGM(SCC0010) PARM('SCBACKUP' 'NOTRUN' &RPY)/*RT0142*E26655*/
             RTVMSG     MSGID(SCM0026) MSGF(MIDASMSG) MSG(&MESSAGE)   /*E26655*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)     /*E26655*/
             CHGDTAARA  DTAARA(MIDASMSG (2 1)) VALUE('1')             /*E26655*/
             CALL       PGM(SCC0010) PARM('SCBACKUP' 'RETRY' &RPY)    /*E26655*/
                                                                      /*RT0142*/
             IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                          THEN(GOTO CMDLBL(LOOP1))
             IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(GOTO CMDLBL(ABEND))
             ELSE       CMD(GOTO CMDLBL(LOOP2))
ENDD001:     ENDDO
/**/                                                                  /*S01127*/
/* If no other users active ( = no other 'MIDAS' on msgq )        */  /*S01127*/
/* check no End Of Centres are active (including failed/held)     */  /*S01127*/
/* if FF present in system.                                       */  /*S01127*/
/**/                                                                  /*S01127*/
             RTVDTAARA  DTAARA(MMOD (50 1)) RTNVAR(&FF)               /*S01127*/
             IF         COND(&FF *EQ 'Y') THEN(DO)                    /*S01127*/
/**/                                                                  /*S01127*/
/* LF/MKCTL1 selects markets in End Of Centre                      *   *S01127*/
/* If this file cannot be copied to a temporary work file,         *   *S01127*/
/* i.e. it is empty, then no EOCs are active & the job can continue*   *S01127*/
/**/                                                                  /*S01127*/
                CPYF       FROMFILE(MKCTL1) TOFILE(QTEMP/MKCTL1) +
                          CRTFILE(*YES)                               /*S01127*/
 RETRY:         CPYF       FROMFILE(MKCTL1) TOFILE(QTEMP/MKCTL1) +
                          MBROPT(*REPLACE)                            /*S01127*/
                MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(CONT))     /*S01127*/
/*OP3:**********SNDPGMMSG  MSG('Job cannot be run when End Of Centres +
/***************             are active - do you wish to re-try - Y  +
/***************          or N?') TOPGMQ(*EXT) MSGTYPE(*INQ)   /*S01127*RT0142*/
/***************RCVMSG     PGMQ(*N) MSGTYPE(*RPY) WAIT(*MAX)         +
/***************             RMV(*YES) MSG(&RPY)               /*S01127*RT0142*/
                                                                      /*RT0142*/
/*  CALL SCC0010 TO INFORM USER THAT JOB CANNOT BE RUN WHEN  */       /*RT0142*/
/*  END OF CENTRES ARE ACTIVE                                */       /*RT0142*/
                                                                      /*RT0142*/
 LOOP3:         CHGVAR     VAR(&RPY) VALUE('Y')                       /*RT0142*/
                                                                      /*RT0142*/
/************CALL    PGM(SCC0010) PARM('MBACKUP' 'EOCACT' &RPY) /*RT0142E26655*/
             RTVMSG     MSGID(SCM0018) MSGF(MIDASMSG) MSG(&MESSAGE)   /*E26655*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)     /*E26655*/
             RTVMSG     MSGID(SCM0019) MSGF(MIDASMSG) MSG(&MESSAGE)   /*E26655*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)     /*E26655*/
             CHGDTAARA  DTAARA(MIDASMSG (1 1)) VALUE('1')             /*E26655*/
             CALL       PGM(SCC0010) PARM('SCBACKUP' 'RETRY' &RPY)    /*E26655*/
                                                                      /*RT0142*/
                IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y'))   +
                             THEN(GOTO CMDLBL(RETRY))                 /*S01127*/
                IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n'))   +
                             THEN(GOTO CMDLBL(ABEND))                 /*S01127*/
                ELSE       CMD(GOTO CMDLBL(LOOP3))                    /*S01127*/
CONT:        ENDDO                                                    /*S01127*/
                                                                      /*S01127*/
/**/                                                                  /*S01127*/
/*                                                                  */
             CHGDTAARA  DTAARA(MPHAS) VALUE(X)
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
/**/                                                                                      /*CSC033*/
/* Terminate Exposure Management job EM0101                                               /*CSC033*/
/**/                                                                                      /*CSC033*/
       IF  COND(%SUBSTRING(&MMOD 7 1) *EQ 'Y') THEN(DO)                                   /*CSC033*/
                                                                                          /*CSC033*/
           IF  COND(%SUBSTRING(&EMSTAT 2 1) *EQ 'Y') THEN(DO)                             /*CSC033*/
                                                                                          /*CSC033*/
           CHGVAR   VAR(&JOBN) VALUE(%SUBSTRING(&EMSTAT 100 10))                          /*CSC033*/
           CHGVAR   VAR(&USRN) VALUE(%SUBSTRING(&EMSTAT 110 10))                          /*CSC033*/
           CHGVAR   VAR(&JBNB) VALUE(%SUBSTRING(&EMSTAT 120 6))                           /*CSC033*/
                                                                                          /*CSC033*/
           ENDJOB   JOB(&JBNB/&USRN/&JOBN) OPTION(*IMMED) +
                    SPLFILE(*YES)                                                         /*CSC033*/
           MONMSG   MSGID(CPF0001 CPF1321 CPF1362)                                        /*CSC033*/
                                                                                          /*CSC033*/
           ENDDO                                                                          /*CSC033*/
       ENDDO                                                                              /*CSC033*/
/*                                                                  */
/* Terminate report distribution program */                         /*092719*/
/**/                                                                /*092719*/
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5)         /*092719*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                     /*092719*/
               CALL       PGM(QSNDDTAQ) PARM('FCDTAQ' '*LIBL' +
                            &DTQDLEN &T)                            /*092719*/
 DISTLP:       ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(30)      /*092719*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(DISTLP))  /*092719*/
             ENDDO                                                  /*092719*/
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                 /*092719*/
                                                                      /*CAP002*/
/*  If the SF is on, terminate API background functions               /*CAP002*/
             IF         COND(&CAP002 *EQ 'Y') THEN(DO)                /*CAP002*/
                CALL       PGM(APCENDBKJB)                            /*CAP002*/
             ENDDO                                                    /*CAP002*/
/**/
             RCLRSC
             CALL       &PRM01 PARM(&PRM02)
/**/                                                                                      /*CSC033*/
/*  Start online global layer update job, GO_ONL_SYN.                                     /*CSC033*/
/**/                                                                                      /*CSC033*/
             IF         COND(&MPHAS *EQ 'A') THEN(DO)                                     /*CSC033*/
             CALL       PGM(GOC0101)                                                      /*CSC033*/
             ENDDO                                                                        /*CSC033*/
/*                                                                  */
/* START REPORT DISTRIBUTION PROGRAM                            */  /*092719*/
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5)         /*092719*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(BYPASS))    /*092719*/
                                                                    /*092719*/
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                 /*092719*/
             MONMSG     MSGID(CPF0000)                              /*092719*/

/************SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +                               */ /*CPK014*/
/************             JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +                  */ /*CPK014*/
/************             OUTQ(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)             /*092719*/ /*CPK014*/
             SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
BYPASS:                                                             /*092719*/
                                                                      /*CAP002*/
/*  If the SF is on, start API background functions                   /*CAP002*/
             IF         COND(&CAP002 *EQ 'Y') THEN(DO)                /*CAP002*/
                                                                                          /*CSC011*/
/** If 24x7 Midas Availability Feature is on  */                                          /*CSC011*/
                      IF         COND(&CSC011 *EQ 'Y') THEN(DO)                           /*CSC011*/
                         RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)                    /*CSC011*/
                         RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&MAIN)                    /*CSC011*/
                         RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&SUPP)                    /*CSC011*/
                         RTVDTAARA  DTAARA(SC24X7 (11 1)) +
                                       RTNVAR(&MMODE)                                     /*CSC011*/
                         RTVDTAARA  DTAARA(SC24X7 (10 1)) RTNVAR(&SOVR)                   /*CSC011*/
                                                                                          /*CSC011*/
/** If 24x7 Midas availability is on, API background jobs in        */                    /*CSC011*/
/** the support system should not be started unless the support sys */                    /*CSC011*/
/** is ready to accept data from Meridian (i.e. API pgms in the     */                    /*CSC011*/
/** support sys are in maintenance mode already.)                   */                    /*CSC011*/

                         IF      COND(((&CURR *EQ &SUPP) *AND (&MMODE *EQ +
                                 'E')) *OR ((&SOVR *EQ 'S')  *AND (&CURR +
                                 *EQ &MAIN))) +
                                 THEN(CHGVAR VAR(&APIBKJOB) VALUE('N'))                   /*CSC011*/
                      ENDDO                                                               /*CSC011*/
                                                                                          /*CSC011*/
                      IF         COND(&APIBKJOB *EQ 'Y') THEN(DO)                         /*CSC011*/
                CALL       PGM(APCSTRBKJB)                            /*CAP002*/
                      ENDDO                                                               /*CSC011*/
             ENDDO                                                    /*CAP002*/
                                                                      /*CAP002*/
             CHGDTAARA  DTAARA(MPHAS) VALUE(A)
/**/
/*****RESUBMIT EM0100 JOB IF EM MODULE IS PRESENT     *****/ /*E16342*/
/*    RESUBMIT EM0101 JOB IF EM MODULE IS PRESENT         */ /*E16342*/
/**/
             IF  COND(%SUBSTRING(&MMOD 7 1) *EQ 'Y') THEN(DO)
                ALCOBJ     OBJ((EMCHK *DTAARA *EXCL))
                RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)                                 /*CSC033*/
                  IF  COND(%SUBSTRING(&EMSTAT 2 1) *EQ 'N') THEN(DO)
                                                             /*E16342*/
/*                SBMJOB     JOB(EM0100) JOBD(MBATCH) USER(*JOBD) +  */
/**************** SBMJOB     JOB(EM0101) JOBD(MBATCH) USER(*JOBD) +*/ /*E20391*/
/****************            JOBQ(EMJOBQ) RQSDTA('CALL EMC02') ******/
/****************/                                           /*E16342*/
/**********       SBMJOB     JOB(EM0101) JOBD(MBATCH) USER(*JOBD) +
/**********                  JOBQ(EMJOBQ) RQSDTA('CALL EMC02')    +
/**********                  RTGDTA(*JOBD)                 /*E20391*/ /*081177*/
/************     SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +                      /*CSC023*/
/************                  USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                   /*CSC023*/
/************                  EMC02') INLLIBL(*JOBD)                 /*081177*/          /*CSC023*/
                  SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +
                               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                               EMC02') INLLIBL(*JOBD) OUTQ(*JOBD)                         /*CSC023*/
/***************** SBMJOB     JOB(EMCLR) JOBD(MBATCH) + *********/
/*****************            JOBQ(EMJOBQ) RQSDTA('CALL EMCLR') */
/**********        SBMJOB     JOB(EMCLR) JOBD(MBATCH) +
/**********                   JOBQ(EMJOBQ) RQSDTA('CALL EMCLR') +
/**********                   RTGDTA(*JOBD)                /*E20391*/ /*081177*/
/************      SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +                   */ /*CPK014*/
/************                   RTGDTA(*JOBD) RQSDTA('CALL EMCLR') +                   */ /*CPK014*/
/************                   INLLIBL(*JOBD)                                 /*081177*/ /*CPK014*/
/************      SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +                      /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             EMCLR') INLLIBL(*JOBD)                               /*CPK014*/ /*CSC023*/
                   SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          EMCLR') INLLIBL(*JOBD) OUTQ(*JOBD)                              /*CSC023*/
                   CHGDTAARA  DTAARA(EMSTAT (2 1)) VALUE('Y')
                  ENDDO
                DLCOBJ     OBJ((EMCHK *DTAARA *EXCL))
             ENDDO

/**/                                                                  /*CCM002*/
/*    Check if Citydealer Interface feature is active.                /*CCM002*/
/**/                                                                  /*CCM002*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CCM002*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CCM002*/
             CHGVAR     VAR(&SAR) VALUE('CCM002')                     /*CCM002*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CCM002*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CITYDLR) VALUE('Y'))                   /*CCM002*/
             ELSE       CMD(CHGVAR VAR(&RTNC) VALUE('       '))       /*CCM002*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')                    /*CCM002*/
/**/                                                                  /*CCM002*/
/*   If Citydealer Interface is active, retrieve the values in        /*CCM002*/
/*   data area DLCDSTAT.                                              /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&CITYDLR *EQ 'Y') THEN(DO)               /*CCM002*/
               RTVDTAARA  DTAARA(DLCDSTAT) RTNVAR(&CDSTAT)            /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If 1st posn of &CDSTAT is not set to 'Y', submit the Citydealer /*CCM002*/
/*    Background jobs.                                                /*CCM002*/
/**/                                                                  /*CCM002*/
               IF         COND(%SST(&CDSTAT 1 1) *NE 'Y') THEN(DO)    /*CCM002*/
/****************SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +  /*110242*/
/*************                RTGDTA(CITYD) RQSDTA('CALL DLC0002') +  /*110242*/
/*************                MSGQ(*NONE) */                  /*CCM002  110242*/
/****************SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +   /*110242*/
/*************                RTGDTA(CITYD) RQSDTA('CALL DL0003') +   /*110242*/
/*************                MSGQ(*NONE)                     /*CCM002  110242*/
/************    SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +                      /*CPK014*/
/************                 RTGDTA(CITYD) RQSDTA('CALL DLC0002') +                      /*CPK014*/
/************                 INLLIBL(*JOBD) MSGQ(*NONE)                       /*110242*/ /*CPK014*/
/************   SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +                       /*CSC023*/
/************                USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +                     /*CSC023*/
/************                DLC0002') INLLIBL(*JOBD) MSGQ(*NONE)              /*CPK014*/ /*CSC023*/
                SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +
                             USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +
                             DLC0002') INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)             /*CSC023*/
             IF         COND(&CCM003 *EQ 'N') THEN(DO)                /*CCM003*/
/************    SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +                       /*CPK014*/
/************                 RTGDTA(CITYD) RQSDTA('CALL DL0003') +                       /*CPK014*/
/************                 INLLIBL(*JOBD) MSGQ(*NONE)                       /*110242*/ /*CPK014*/
/************   SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +                        /*CSC023*/
/************                USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +                     /*CSC023*/
/************                DL0003') INLLIBL(*JOBD) MSGQ(*NONE)               /*CPK014*/ /*CSC023*/
                SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +
                             USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +
                             DL0003') INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)              /*CSC023*/
               ENDDO                                                  /*CCM003*/
                 CHGDTAARA  DTAARA(DLCDSTAT (1 1)) VALUE('Y')         /*CCM002*/
               ENDDO                                                  /*CCM002*/
             ENDDO                                                    /*CCM002*/
/* Submit TCP/IP Listener Jobs                                          CRT004*/
             IF         COND(&CRT004 *EQ 'Y') +
                          THEN(CALL PGM(REC4510) PARM('START'))       /*CRT004*/
/**/                                                                  /*CRT004*/
/**/                                                                  /*CLE004*/
/*********** IF         COND(&CLE004 *EQ 'Y' *AND &CLE006 *EQ 'Y') +
/***********              THEN(CALL PGM(LEC2010))          /*CLE004*/ /*176691*/
             IF         COND(&CLE004 *EQ 'Y' *AND &CLE010 *EQ 'Y') +
                          THEN(CALL PGM(LEC2010))                     /*176691*/
/**/                                                                  /*CDE001*/
/* Restart the CCRM - Limits Drip Feed job.                           /*CDE001*/
/**/                                                                  /*CDE001*/
             IF         COND(&CDE001 *EQ 'Y') +
                          THEN(CALL PGM(DEC0004))                     /*CDE001*/
                                                                                          /*CRE020*/
/** Restart the APIs Retail Advices Job */                                                /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&CRE020 *EQ 'Y') THEN(DO)                                    /*CRE020*/
                CALL       PGM(APC0460)                                                   /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
/**/                                                                  /*CRE008*/
/* Restart the Cash Management batch jobs                             /*CRE008*/
/**/                                                                  /*CRE008*/
             IF         COND(&CRE008 *EQ 'Y') THEN(DO)                /*CRE008*/
             CALL       PGM(REC101201)                                /*CRE008*/
             CALL       PGM(REC101501)                                /*CRE008*/
             ENDDO                                                    /*CRE008*/
/**/                                                                  /*CGP004*/
/* Restart the Audit Reporting batch job                              /*CGP004*/
/**/                                                                  /*CGP004*/
             IF         COND(&CGP004 *EQ 'Y') THEN(DO)                /*CGP004*/
                CALL       PGM(GOC0300)                               /*CGP004*/
             ENDDO                                                    /*CGP004*/
/**/                                                                                     /*BUG2381*/
/* Restart the APIs Confirmations job                                                    /*BUG2381*/
/**/                                                                                     /*BUG2381*/
             CALL       PGM(APC0430)                                                     /*BUG2381*/
/**/                                                                                     /*BUG2381*/

/**/
/*****RESUBMIT*EDC0040*JOB*IF*ED*MODULE*IS*PRESENT*AND**** /*S01493*/ /*101971*/
/*    RESUBMIT EDCONTROL JOB IF ED MODULE IS PRESENT AND              /*101971*/
/*    THE JOB IS NOT ALREADY RUNNING                           S01493*/
/**/

    CALL       PGM(AOMMODR0) PARM(&RTNC &OPTN &AOMMOD)         /*S01493*/
    IF         COND(%SUBSTRING(&AOMMOD 99 1) *EQ 'Y') THEN(DO) /*S01493*/
             ALCOBJ   OBJ((EDC0040 *DTAARA *EXCL))             /*S01493*/
             MONMSG   MSGID(CPF1002) EXEC(GOTO CMDLBL(EDLABL)) /*S01493*/
             DLCOBJ   OBJ((EDC0040 *DTAARA *EXCL))             /*S01493*/
/**********  SBMJOB   JOB(EDC0040) JOBD(EDJOBD) USER(*JOBD) +
/**********           JOBQ(EDJOBQ) RQSDTA('CALL EDC0040')    +
/**********           RTGDTA(*JOBD)                        /*S01493*/ /*081177*/
/**********  SBMJOB     JOB(EDC0040) JOBD(EDJOBD) JOBQ(EDJOBQ) +
/**********               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
/**********               EDC0040') INLLIBL(*JOBD)         /*081177*/ /*101971*/
/**********  SBMJOB     JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(EDJOBQ) +    /*CED007*/
/**********               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +    /*CED007*/
/**********               EDC0040') INLLIBL(*JOBD)         /*101971*/ /*CED007*/
/************SBMJOB     JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(INTERFACE) +                     /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             EDC0040') INLLIBL(*JOBD)                    /*CED007*/          /*CSC023*/
             SBMJOB     JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          EDC0040') INLLIBL(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 EDLABL:                                                       /*S01493*/
    ENDDO                                                      /*S01493*/
                                                                      /*CGL004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL004' +
                          &FMT)                                       /*CGL004*/
             IF         COND(&RTCD *EQ '      ') THEN(DO)             /*CGL004*/
             ALCOBJ     OBJ((GLFONTDA *DTAARA *EXCL)) WAIT(1)         /*CGL004*/
             MONMSG   MSGID(CPF1002) EXEC(GOTO CMDLBL(CGLABL))        /*CGL004*/
             DLCOBJ     OBJ((GLFONTDA *DTAARA *EXCL))                 /*CGL004*/
             CALL       PGM(GLC2817) PARM(' ' ' ' '*START' ' ' ' ')   /*CGL004*/
CGLABL:                                                               /*CGL004*/
             ENDDO                                                    /*CGL004*/
/**/                                                                  /*CGL009*/
/*    Check if Fontis IAT/TPP Interface (CGL009) is active            /*CGL009*/
/**/                                                                  /*CGL009*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CGL009*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CGL009*/
             CHGVAR     VAR(&SAR) VALUE('CGL009')                     /*CGL009*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CGL009*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CGL009) VALUE('Y'))                    /*CGL009*/
                                                                      /*CGL009*/
             IF         COND(&CGL009 *EQ 'Y') THEN(DO)                /*CGL009*/
             ALCOBJ     OBJ((GLFIATDA *DTAARA *EXCL)) WAIT(10)        /*CGL009*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(TPPLBL))      /*CGL009*/
             DLCOBJ     OBJ((GLFIATDA *DTAARA *EXCL))                 /*CGL009*/
             CALL       PGM(GLC2822) PARM('*START' ' ' 'A' ' ')       /*CGL009*/
                                                                      /*CGL009*/
 TPPLBL:     ALCOBJ     OBJ((MEFTPPDA *DTAARA *EXCL)) WAIT(10)        /*CGL009*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(FONEND))      /*CGL009*/
             DLCOBJ     OBJ((MEFTPPDA *DTAARA *EXCL))                 /*CGL009*/
             CHGDTAARA  DTAARA(MEFTPPDA (29 1)) VALUE(' ')            /*CGL009*/
             CALL       PGM(MEC2001) PARM('*START' ' ' 'A' ' ')       /*CGL009*/
                                                                      /*CGL009*/
 FONEND:     ENDDO                                                    /*CGL009*/
                                                                      /*CGL009*/
/*******     CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL013' +                       CSC033*/
/*******                  &FMT)                                        *CGL013*             CSC033*/
/*******     IF         (&RTCD *EQ '       ') +                                             CSC033*/
             IF         COND(&CGL013 *EQ 'Y') THEN(DO)                                    /*CSC033*/
                 CALL       PGM(GLC001410) PARM('*START' ' ' ' ')     /*CGL013*/
                 CALL       PGM(SD3230) PARM(&WFTP)                                     /*MD053437*/
                 IF         (&WFTP *EQ 'Y') THEN(DO)                                    /*MD053437*/
                 ALCOBJ     OBJ((SD_MID_FTP *DTAARA *EXCL)) WAIT(0)                     /*MD053437*/
                 MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(NEXT1))                     /*MD053437*/
                 CALL       PGM(QCLRDTAQ) PARM('SD_MID_FTP' '*LIBL ')                   /*MD053437*/
                 MONMSG     MSGID(CPF0000)                                              /*MD053437*/
                 SBMJOB     CMD(CALL PGM(SDC3200)) JOB(SD_MID_FTP) JOBD(MBATCH) +
                              JOBQ(MSJOBQ) USER(*JOBD) RTGDTA(MULTILANGUAGE) +
                              MSGQ(MOPERQ) OUTQ(*JOBD)                                  /*MD053437*/
 NEXT1:          ENDDO       /*MD053437*/
                 ENDDO       /*CSC033*/

/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCBACKUMPE                                   */      /*S01408*/
/**/                                                                  /*S01408*/
/*                                                                  */
             GOTO       CMDLBL(ENDCLPGM)
/*                                                                  */
 ABEND:      DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             GOTO       ENDCLPGM
ABNORMAL:
/*           An abnormal message has been issued and to prevent      */
/*           further errors  being  sent to the ABNORMAL tag by      */
/*           the general MONMSG command  in  the  first line of      */
/*           executable code each of the  following  lines  are      */
/*           individually  monitored  to  prevent  any  further      */
/*           errors which may occur from causing looping.            */
/*                                                                   */
             SNDPGMMSG  MSG('Program SCBACKUP ended abnormally - job +
                          cancelled') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGDTAARA  MPHAS VALUE(A)
             MONMSG     MSGID(CPF0000 MCH0000)
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCVMSG     MSGQ(MSPECIAL)
             MONMSG     MSGID(CPF0000 MCH0000)
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                  */
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                  */
 ENDCLPGM:
 /***********SNDPGMMSG  MSG(MIDAS) TOMSGQ(MSTATUS)                                     */ /*CPK017*/
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(9999)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             RCVMSG     MSGQ(MSPECIAL)
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             IF         COND(&FF *EQ 'Y')  THEN(DO)                   /*S01127*/
                DLTF       FILE(QTEMP/MKCTL1)                         /*S01127*/
                MONMSG     MSGID(CPF2105)                             /*S01127*/
             ENDDO                                                    /*S01127*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM     /* END CL PGM */
