/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Input cycle restore/forward recovery')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Restart Recovery Module                         */
/*                                                                   */
/*       RRRECOVER - INPUT CYCLE RESTORE OR FORWARD RECOVERY IN      */
/*                   PROGRESS                                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9619            Date 01Feb06              */
/*       Prev Amend No. BUG2381            Date 13May04              */
/*                      CRE020             Date 20Jan04              */
/*                      CSC023             Date 30Jan04              */
/*                      CPK017             Date 28Oct03              */
/*                      CGL013             Date 29Mar02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CCM003             Date 27Mar01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      180491             Date 20Jun00              */
/*                      CDE001             Date 12Nov99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009             Date 18Mar99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CLE004             DATE 11MAY97              */
/*                      CGL004             DATE 03NOV97              */
/*                      CED007             DATE 03NOV97              */
/*                      110242             DATE 07NOV96              */
/*                      101971             DATE 15MAY96              */
/*                      S01408             DATE 10APR96              */
/*                      CCM002             DATE 04SEP95              */
/*                      086140             DATE 29MAR95              */
/*                      S01495             DATE 01OCT94              */
/*                      S01493            DATE  14JUN94              */
/*                      063084             DATE 11FEB94              */
/*                      S01319             DATE 20SEP91              */
/*                      S01343             DATE 15AUG91              */
/*                      LN1109             DATE 25JAN91              */
/*                      E20391             DATE 26NOV89              */
/*                      E13205             DATE 21/02/89             */
/*                      S01179             DATE 10/09/88             */
/*                      E12754             DATE 30/03/88             */
/*                      S01136             DATE 09/12/87             */
/*                      S01145             DATE 02/12/87             */
/*                      S01133             DATE 01/04/87             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       BUG2381 - Batch submit of confirmations programs            */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK017 - Midas Plus packaging.                              */
/*                Comment out the remove of msg from MSTATUS and     */
/*                the send of 'MIDAS' at ENDCLPGM.                   */
/*       CGL013 - MT94x Message Generation                           */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       CCM003 - Condition DL0003 on CCM003.                        */
/*       180491 - Add mode parameter to DEC0040 call.                */
/*       CDE001 - Data Export - CCRM Limits                          */
/*       CGL009 - Midas-Fontis Inter-Account Transfers (IAT) and     */
/*                Third Party Payments (TPP) Interface               */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       CLE004 - Customer Lending Enhancements - Syndications       */
/*       CGL004 - Midas-Fontis Interface, add submission of          */
/*                Background job.                                    */
/*       CED007 - ED enhancements, change JOBQ for submission of     */
/*                EDCONTROL.                                         */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       101971 - Change name of EDC0040 job to                      */
/*                descriptive EDCONTROL                              */
/*       S01408 - Addition of core hook RRRECOVINT                   */
/*                Addition of core hook RRRECOVMPE                   */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI).      */
/*                If feature is on, end the Citydealer background    */
/*                jobs before recovery and re-submit the jobs after. */
/*       086140 - Not redundant very live and kicking                */
/*                Change not to run SCC01                            */
/*       S01495 - COB enhancements.  This program is now redundant.  */
/*       S01493  -  MIDAS EXPORT DATA MODULE - ADD SUBMISSION OF     */
/*                  'DRIP FEED' JOB.                                 */
/*       063084 - Restore Database and Forward Recovery do not work. */
/*                Submitted job EM0101 was not terminated.           */
/*       S01319 - Remove redundant processing                        */
/*                                                                   */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                    */
/*              - RRRECOVER RENAMED FROM MRECOVR                     */
/*              - RRMENUN RENAMED FROM L2MNUN                        */
/*              - SCMINIT RENAMED FROM MINIT                         */
/*              - SCC01 RENAMED FROM SDC01                           */
/*       LN1109 - STRIP OUT CALLS TO REDUNDANT PROGRAMS              */
/*       E20391 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.            */
/*       E13205 - EM0101 not shut down                               */
/*                EMCHK data area lock message not monitored         */
/*                EMSTAT not received before SBMJOB for EM           */
/*                EM0100 job should be EM0101                        */
/*                EM SBMJOB should specify MSGQ(*NONE)               */
/*                Monitor for commitment control active message      */
/*       S01179 - AS400 CONVERSION                                   */
/*       E12754 - CM0330 TO BE CALLED WITH JUST 1 PARAMETER          */
/*       S01136 - CANCEL FX & MM DEAL TICKETS AND STANDING DATA      */
/*                UPDATES TO UNLOCK FILES BEFORE RECOVRY PROCESSING  */
/*       S01145 - ARBITRAGE                                          */
/*       S01133 - DEALING ROOM SYSTEM                                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*********************************************************************/
/******      PGM        PARM(&PRM01 &SDC01)                           /*S01343*/
             PGM        PARM(&PRM01 &SCC01)                           /*S01343*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,RRRECOVINT                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                            */
             DCL        &FLAG         TYPE(*CHAR)  LEN(1)
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
/******      DCL        &SDC01        TYPE(*CHAR)  LEN(8)             /*S01343*/
             DCL        &SCC01        TYPE(*CHAR)  LEN(8)             /*S01343*/
             DCL        &STATMSG      TYPE(*CHAR)  LEN(5)
             DCL        &RPY          TYPE(*CHAR)  LEN(1)
/***         DCLDTAARA  EMSTAT                                      *  *S01179*/
/***         DCLDTAARA  MMOD                                        *  *S01179*/
/***         DCLDTAARA  MPHAS                                       *  *S01179*/
             DCL        VAR(&EMSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                /*S01179*/
             DCL VAR(&AOMMOD) TYPE(*CHAR) LEN(200)                    /*S01493*/
             DCL VAR(&OPTN)  TYPE(*CHAR) LEN(7) VALUE('*FIRST')       /*S01493*/
             DCL VAR(&RTNC)  TYPE(*CHAR) LEN(7)                       /*S01493*/
             DCL        VAR(&CITYDLR) TYPE(*CHAR) LEN(1) VALUE('N')   /*CCM002*/
             DCL        VAR(&CDSTAT) TYPE(*CHAR) LEN(27)              /*CCM002*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CCM002*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)             /*CCM002*/
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5) VALUE(32)      /*CCM002*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(32) +
                          VALUE('END     0000000000000000000000NY')   /*CCM002*/
             DCL        VAR(&CLE004) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CLE004*/
             DCL        VAR(&CLE006) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CLE004*/
             DCL        VAR(&CGL009) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CGL009*/
             DCL        VAR(&CDE001) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CDE001*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CGL004*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CGL004*/
             DCL        VAR(&CCM003) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CCM003*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CRE020*/
/**/
/*    GLOBAL MONITOR MESSAGE                                         */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
/*                                                                   */
/*           RCVDTAARA  MPHAS                                       *  *S01179*/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                  /*S01179*/
/**/
/*    CHECK IF OTHER USERS ARE USING THE SYSTEM, IF NO THEN CONTINUE */
/*    ELSE INFORM THE USER AND ALLOW THEM TO END OR RETRY.           */
/**/
/************CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                                      */ /*CPK017*/
/************RCVMSG     MSGQ(MSTATUS)                                                  */ /*CPK017*/
/**/
/*****IF*PROGRAM*CALLED*FROM*RRMENUN,*REMOVE*A*SECOND*MESSAGE*FROM*Q**/ /*             */ /*CPK017*/
/************                                                                          */ /*CPK017*/
/************IF         COND(&PRM01 *EQ 'RRMENUN') THEN(RCVMSG +                       */ /*CPK017*/
/************             MSGQ(MSTATUS))                                               */ /*CPK017*/
/**/
LOOP1:       CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&STATMSG)
             IF         COND(&STATMSG *NE '     ') THEN(DO)
LOOP2:       SNDPGMMSG  MSG('Job cannot be run now - do you wish to +
                          re-try - Y or N?') TOPGMQ(*EXT) MSGTYPE(*INQ)
             RCVMSG     PGMQ(*N) MSGTYPE(*RPY) WAIT(*MAX) +
                          RMV(*YES) MSG(&RPY)
             IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                          THEN(GOTO CMDLBL(LOOP1))
             IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(GOTO CMDLBL(ENDCLPGM))
             ELSE       CMD(GOTO CMDLBL(LOOP2))
ENDD001:     ENDDO
/*                                                                  */
/*   REMOVE WAIT TIME ON FOLLOWING CMD FOR RELEASE                  */
/**/
/*   ALLOCATE DATAAREA TSTATUS EXCUSIVELY TO PREVENT OTHER USERS    */
/*   FROM SIGNING ON TO THE SYSTEM. IF THIS IS NOT POSSIBLE ALLOW   */
/*   THE USER TO END OR RETRY                                       */
/**/
ALLOC:       ALCOBJ     OBJ((TSTATUS *DTAARA *EXCL)) WAIT(10)
             MONMSG     MSGID(CPF1002) EXEC(DO)
LOOP3:          SNDPGMMSG  MSG('Job cannot be run now - do you wish to +
                             re-try - Y or N?') TOPGMQ(*EXT) MSGTYPE(*INQ)
                RCVMSG     PGMQ(*N) MSGTYPE(*RPY) WAIT(*MAX) +
                             RMV(*YES) MSG(&RPY)
                IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                             THEN(GOTO CMDLBL(ALLOC))
                IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(GOTO CMDLBL(ENDCLPGM))
                ELSE       CMD(GOTO CMDLBL(LOOP3))
             ENDDO
/**/
/*    CHANGE TSTATUS TO INDICATE RECOVERY IN PROGRESS IN CASE OF    */
/*    ABNORMAL SYSTEM TERMINATION BEFORE COMPLETION                 */
/**/
             CHGDTAARA  DTAARA(TSTATUS) VALUE(RECOVERY)
/*                                                                  */
/***-**IF MMOD POSITION 12 = 'Y' CALL CM0330                /*S01133*  *S01319*/
/**/                                                                  /*S01133*/
/***         RCVDTAARA  DTAARA(MMOD)                        /*S01179*  *S01133*/
/*****       RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)          /*S01179*  *S01319*/
/*****       IF COND(%SUBSTRING(&MMOD 12 1) *EQ 'Y') THEN(DO)*S01133*  *S01319*/
/*           CALL       PGM(CM0330) PARM(' ' 'R')                     /*E12754*/
/*****       CALL       PGM(CM0330) PARM('R')               /*E12754*  *S01319*/
/*****       IF COND(%SWITCH(XXXXX1XX)) THEN(GOTO ABNORMAL) /*S01133*  *S01319*/
                                                                      /*S01136*/
/***** THIS WILL CANCEL STANDING DATA UPDATES, CM0190       /*S01136*  *S01319*/
/***** SAVE OLD VALUE OF MPHAS                              /*S01136*  *S01319*/
/***         RCVDTAARA  MPHAS                               /*S01179*  *S01136*/
/*****       RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)        /*S01179*  *S01319*/
/*****       CHGDTAARA  DTAARA(MPHAS) VALUE('B')            /*S01136*  *S01319*/
/*****       DLYJOB     DLY(65)                             /*S01136*  *S01319*/
/*****       CHGDTAARA  DTAARA(MPHAS) VALUE(&MPHAS)         /*S01136*  *S01319*/
/*****       ENDDO                                          /*S01133*  *S01319*/
                                                                      /*S01136*/
/***** CANCEL THE FX DEAL TICKET PRINT TO ALLOW RECOVERY TO CONTINUE  /*S01136*/
/*****                                                                /*LN1109*/
/*****       IF         COND(%SUBSTRING(&MMOD 13 1) *EQ 'Y') THEN(DO) /*LN1109*/
/*****       CALL       PGM(FX1170) PARM(' ' '9')                  */ /*LN1109*/
/*****       IF         COND(%SWITCH(XXXXX1XX)) THEN(GOTO ABNORMAL)*/ /*LN1109*/
/*****       ENDDO                                                    /*LN1109*/
/*****                                                                /*S01145*/
/***** CANCEL THE ARBITRAGE DEAL TICKET PRINT TO ALLOW RECOVERY TO    /*S01145*/
/***** CONTINUE (UNLOCKS FILE)                                        /*S01145*/
/*****                                                                /*S01145*/
/*****       IF         COND(%SUBSTRING(&MMOD 19 1) *EQ 'Y') THEN(D*/ /*LN1109*/
/*****       CALL       PGM(AB0130) PARM(' ' '9')                  */ /*LN1109*/
/*****       IF         COND(%SWITCH(XXXXX1XX)) THEN(GOTO ABNORMAL)*/ /*LN1109*/
/*****       ENDDO                                                 */ /*LN1109*/
/*****                                                             */ /*LN1109*/
/***** CANCEL THE MM DEAL TICKET PRINT TO ALLOW RECOVERY TO CONTINUE  /*S01136*/
/*****                                                                /*S01136*/
/*****       IF         COND(%SUBSTRING(&MMOD 14 1) *EQ 'Y') THEN(D* //*S01136*/
/*****       CALL       PGM(MM0093) PARM(' ' '9')                  */ /*S01136*/
/*****       IF         COND(%SWITCH(XXXXX1XX)) THEN(GOTO ABNORMAL)*/ /*S01136*/
/*****       ENDDO                                                 */ /*S01136*/
 
/**/                                                                  /*E13205*/
/*  If Exposure Management Module is present and updating is       */ /*E13205*/
/*  active then stop updating and terminate the program            */ /*E13205*/
/*                                                                 */ /*E13205*/
/* */                                                                /*063084*/
/** Retrieve the values in data area MMOD.                        */ /*063084*/
/* */                                                                /*063084*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                   /*063084*/
/**/                                                                  /*CLE004*/
/*    Check if Lending Enhancements feature is active (CLE004)        /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SAR) VALUE('CLE004')                     /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CLE004*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE004) VALUE('Y'))                    /*CLE004*/
/**/                                                                  /*CLE004*/
/*    Check if Lending Enhancements feature is active (CLE006)        /*CLE004*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
             CHGVAR     VAR(&SAR) VALUE('CLE006')                     /*CLE004*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CLE004*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE006) VALUE('Y'))                    /*CLE004*/
/**/                                                                  /*CDE001*/
/*    Check if CCRM - Limits is active (CDE001)                       /*CDE001*/
/**/                                                                  /*CDE001*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CDE001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDE001*/
             CHGVAR     VAR(&SAR) VALUE('CDE001')                     /*CDE001*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CDE001*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE001) VALUE('Y'))                    /*CDE001*/
/**/                                                                  /*CLE004*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CLE004*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')                    /*CLE004*/
             IF         COND(&CLE004 *EQ 'Y' *AND &CLE006 *EQ 'Y') +
                          THEN(CALL PGM(LEC2011))                     /*CLE004*/
/**/                                                                  /*CDE001*/
/* If the CCRM - Limits Drip Feed job is active, shut it down         /*CDE001*/
/**/                                                                  /*CDE001*/
/**********  IF         COND(&CDE001 *EQ 'Y') +
/**********               THEN(CALL PGM(DEC0040))                              /*CDE001*/ /*180491*/
             IF         COND(&CDE001 *EQ 'Y') THEN(CALL PGM(DEC0040) +
                          PARM('I'))                                                      /*180491*/
/**/                                                                                     /*BUG2381*/
/* If the APIs Confirmations job is active, shut it down                                 /*BUG2381*/
/**/                                                                                     /*BUG2381*/
             CALL       PGM(APC0440)                                                     /*BUG2381*/
/**/                                                                                     /*BUG2381*/
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
/** If the APIs Retail Advices job is active, shut it down */                             /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&CRE020 *EQ 'Y') THEN(DO)                                    /*CRE020*/
                CALL       PGM(APC0470)                                                   /*CRE020*/
             ENDDO                                                                        /*CRE020*/
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
/**/                                                                  /*CCM003*/
/*    Check if Midas/City Dealer interface is active (CCM003)         /*CCM003*/
/**/                                                                  /*CCM003*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CCM003*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CCM003*/
             CHGVAR     VAR(&SAR) VALUE('CCM003')                     /*CCM003*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CCM003*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CCM003) VALUE('Y'))                    /*CCM003*/
/**/                                                                  /*CCM002*/
/*    If Citydealer Interface is active, retrieve the values in       /*CCM002*/
/*    data area DLCDSTAT.                                             /*CCM002*/
/**/                                                                  /*CCM002*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST')                    /*CCM002*/
             IF         COND(&CITYDLR *EQ 'Y') THEN(DO)               /*CCM002*/
               RTVDTAARA  DTAARA(DLCDSTAT) RTNVAR(&CDSTAT)            /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If 1st position of &CDSTAT is set to 'Y', send the message      /*CCM002*/
/*    to the data queue.                                              /*CCM002*/
/**/                                                                  /*CCM002*/
               IF         COND(%SST(&CDSTAT 1 1) *EQ 'Y') THEN(CALL +
                            PGM(QSNDDTAQ) PARM('DLCDDTAQ' '*LIBL' +
                            &LENGTH &MESSAGE))                        /*CCM002*/
             ENDDO                                                    /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If Citydealer Interface is active and Exposure Management       /*CCM002*/
/*    is not used and 1st position of &CDSTAT = 'Y', send a           /*CCM002*/
/*    Journal Entry to ICJRN.                                         /*CCM002*/
/**/                                                                  /*CCM002*/
/**********  IF         COND(&CITYDLR *EQ 'Y' *AND %SST(&MMOD 7 1) + */                  /*BUG9619*/
/**********               *NE 'Y' *AND %SST(&CDSTAT 1 1) *EQ 'Y') + */                   /*BUG9619*/
/**********               THEN(SNDJRNE JRN(ICJRN) TYPE('XE') + */                        /*BUG9619*/
/**********               ENTDTA('STOP CD UPDATE') FILE(SDBANKPD)) */         /*CCM002*/ /*BUG9619*/
             IF         COND(&CITYDLR *EQ 'Y' *AND %SST(&MMOD 7 1) +
                          *NE 'Y' *AND %SST(&CDSTAT 1 1) *EQ 'Y') +
                          THEN(SNDJRNE JRN(ICJRN) TYPE('XE') +
                          ENTDTA('STOP CD UPDATE') FILE(SDBANKPD) +
                          FORCE(*YES))                                                   /*BUG9619*/
/* */                                                                /*063084*/
             IF         COND(%SUBSTRING(&MMOD 7 1) *EQ 'Y') THEN(DO)  /*E13205*/
                RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)             /*E13205*/
                IF  COND(%SUBSTRING(&EMSTAT 2 1) *EQ 'Y') THEN(DO)    /*E13205*/
/**********         SNDJRNE JRN(ICJRN) TYPE('XE') FILE(TABTB10) + */                     /*BUG9619*/
/**********                        ENTDTA('STOP EM UPDATE') */                /*E13205*/ /*BUG9619*/
                    SNDJRNE    JRN(ICJRN) TYPE('XE') ENTDTA('STOP EM +
                          UPDATE') FILE(TABTB10) FORCE(*YES)                             /*BUG9619*/
                ENDDO                                                 /*E13205*/
             ENDDO                                                    /*E13205*/
/*                                                                 */ /*E13205*/
             ENDCMTCTL
/**/
/*    CALL THE APPROPRIATE RECOVERY PROGRAM                         */
/**/
/******      CALL       PGM(&PRM01) PARM(&SDC01 &FLAG)                /*S01343*/
             CALL       PGM(&PRM01) PARM(&SCC01 &FLAG)                /*S01343*/
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ENDCLPGM)
/**/
/*    CHANGE MPHAS BACK TO 'A'                                      */
/**/
             CHGDTAARA  DTAARA(MPHAS) VALUE(A)
/**/
/***-**IF MMOD POSITION 12 = 'Y' CALL CM0330                /*S01133*  *S01319*/
/**/                                                                  /*S01133*/
/***         RCVDTAARA  DTAARA(MMOD)                        /*S01179*  *S01133*/
/*****       RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)          /*S01179*  *S01319*/
/*****       IF COND(%SUBSTRING(&MMOD 12 1) *EQ 'Y') THEN(DO)*S01133*  *S01319*/
/*****       CALL       PGM(CM0330) PARM('A')               /*S01133*  *S01319*/
/*****       IF COND(%SWITCH(XXXXX1XX)) THEN(GOTO ABNORMAL) /*S01133*  *S01319*/
/*****       ENDDO                                          /*S01133*  *S01319*/
/**/
/*    RESTORE TSTATUS AFTER NORMAL COMPLETION                       */
/**/
             CHGDTAARA  DTAARA(TSTATUS) VALUE('        ')
/*                                                                  */
             DLCOBJ     OBJ((TSTATUS *DTAARA *EXCL))
/**/
/*    IF RECOVERY WAS DONE TO B.O.B. OR IF CONVERTING BACKUP MACHINE*/
/*    TO PRIMARY, TRANSFER CONTROL TO INPUT CYCLE INITIAITION       */
/*    TO REOPEN INPUT CYCLE & SET MPHAS TO 'F'                      */
/**/
             IF         COND(&FLAG *EQ 'D') THEN(DO)
/******         CHGDTAARA  DTAARA(MPHAS) VALUE(F)                     /*086140*/
/******         TFRCTL     PGM(SCMINIT) PARM(&SDC01)                  /*S01343*/
/******         TFRCTL     PGM(SCMINIT) PARM(&SCC01)           /*S01343 086140*/
                CHGDTAARA  DTAARA(MPHAS) VALUE(A)                     /*086140*/
                RRTJOB     RTGDTA(MIDASIC)                            /*086140*/
             ENDDO
/**/
/*    RESUBMIT EM0101 JOB IF EM MODULE IS PRESENT                  */ /*E13205*/
/**/
             IF  COND(%SUBSTRING(&MMOD 7 1) *EQ 'Y') THEN(DO)
                  ALCOBJ     OBJ((EMCHK *DTAARA *EXCL))
                  MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP_EM))
                  RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)           /*E13205*/
                  IF  COND(%SUBSTRING(&EMSTAT 2 1) *EQ 'N') THEN(DO)
/*****            SBMJOB     JOB(EM0100) JOBD(MBATCH) +            */ /*E13205*/
/*****                       JOBQ(EMJOBQ) RQSDTA('CALL EMC02')     */ /*E13205*/
/*****             SBMJOB     JOB(EMCLR) JOBD(MBATCH) +            */ /*E13205*/
/*****************SBMJOB     JOB(EM0101) JOBD(MBATCH) +               /*110242*/
/*************               JOBQ(EMJOBQ) RQSDTA('CALL EMC02') +      /*110242*/
/*************               MSGQ(*NONE) RTGDTA(*JOBD) */      /*E20391 110242*/
/*****************           MSGQ(*NONE)             /*E13205*/ /*E20391*/
/***************** SBMJOB     JOB(EMCLR) JOBD(MBATCH) +               /*110242*/
/*************                JOBQ(EMJOBQ) RQSDTA('CALL EMCLR') +     /*110242*/
/*************                MSGQ(*NONE) RTGDTA(*JOBD) */     /*E20391 110242*/
/*****************            MSGQ(*NONE)                  /*E13205*/ /*E20391*/
/************     SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +                      /*CPK014*/
/************                  RTGDTA(*JOBD) RQSDTA('CALL EMC02') +                       /*CPK014*/
/************                  INLLIBL(*JOBD) MSGQ(*NONE)             /*110242*/          /*CPK014*/
/************     SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +                       /*CPK014*/
/************                  RTGDTA(*JOBD) RQSDTA('CALL EMCLR') +                       /*CPK014*/
/************                  INLLIBL(*JOBD) MSGQ(*NONE)             /*110242*/          /*CPK014*/
/************     SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +                      /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             EMC02') INLLIBL(*JOBD) MSGQ(*NONE)                   /*CPK014*/ /*CSC023*/
/************     SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +                       /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             EMCLR') INLLIBL(*JOBD) MSGQ(*NONE)                   /*CPK014*/ /*CSC023*/
                  SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          EMC02') INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                  /*CSC023*/
                  SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          EMCLR') INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                  /*CSC023*/
                   CHGDTAARA  DTAARA(EMSTAT (2 1)) VALUE('Y')
                  ENDDO
                DLCOBJ     OBJ((EMCHK *DTAARA *EXCL))
/*           ENDDO                                                 */ /*E13205*/
SKIP_EM:     ENDDO                                                    /*E13205*/
/**/                                                                  /*CLE004*/
             IF         COND(&CLE004 *EQ 'Y' *AND &CLE006 *EQ 'Y') +
                          THEN(CALL PGM(LEC2010))                     /*CLE004*/
/**/                                                                  /*CDE001*/
/* Restart the CCRM - Limits Drip Feed job.                           /*CDE001*/
/**/                                                                  /*CDE001*/
             IF         COND(&CDE001 *EQ 'Y') +
                          THEN(CALL PGM(DEC0004))                     /*CDE001*/
/**/                                                                                     /*BUG2381*/
/* Restart the APIs Confirmations job                                                    /*BUG2381*/
/**/                                                                                     /*BUG2381*/
             CALL       PGM(APC0430)                                                     /*BUG2381*/
/**/                                                                                     /*BUG2381*/
                                                                                          /*CRE020*/
/** Restart the APIs Retail Advices jobs */                                               /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&CRE020 *EQ 'Y') THEN(DO)                                    /*CRE020*/
                CALL       PGM(APC0460)                                                   /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
/**/                                                                  /*CCM002*/
/*   If Citydealer Interface is active, retrieve the values in        /*CCM002*/
/*   data area DLCDSTAT.                                              /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&CITYDLR *EQ 'Y') THEN(DO)               /*CCM002*/
               RTVDTAARA  DTAARA(DLCDSTAT) RTNVAR(&CDSTAT)            /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If &CDSTAT is not set to 'Y', submit the Citydealer             /*CCM002*/
/*    Background jobs.                                                /*CCM002*/
/**/                                                                  /*CCM002*/
               IF         COND(%SST(&CDSTAT 1 1) *NE 'Y') THEN(DO)    /*CCM002*/
/****************SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +  /*110242*/
/*************                RTGDTA(CITYD) RQSDTA('CALL DLC0002') +  /*110242*/
/*************                MSGQ(*NONE) */                   /*CCM002 110242*/
/****************SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +   /*110242*/
/*************                RTGDTA(CITYD) RQSDTA('CALL DL0003') +   /*110242*/
/*************                MSGQ(*NONE) */                   /*CCM002 110242*/
/************    SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +                      /*CPK014*/
/************               RTGDTA(CITYD) RQSDTA('CALL DLC0002') +                        /*CPK014*/
/************               INLLIBL(*JOBD) MSGQ(*NONE)                /*110242*/          /*CPK014*/
/************    SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +                      /*CSC023*/
/************             USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +                        /*CSC023*/
/************             DLC0002') INLLIBL(*JOBD) MSGQ(*NONE)                 /*CPK014*/ /*CSC023*/
                 SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +
                          USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +
                          DLC0002') INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                /*CSC023*/
             IF         COND(&CCM003 *EQ 'N') THEN(DO)                /*CCM003*/
/************    SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +                       /*CPK014*/
/************               RTGDTA(CITYD) RQSDTA('CALL DL0003') +                         /*CPK014*/
/************               INLLIBL(*JOBD) MSGQ(*NONE)                /*110242*/          /*CPK014*/
/************    SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +                       /*CSC023*/
/************             USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +                        /*CSC023*/
/************             DL0003') INLLIBL(*JOBD) MSGQ(*NONE)                  /*CPK014*/ /*CSC023*/
                 SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +
                          USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +
                          DL0003') INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                 /*CSC023*/
               ENDDO                                                  /*CCM003*/
                 CHGDTAARA  DTAARA(DLCDSTAT (1 1)) VALUE('Y')         /*CCM002*/
               ENDDO                                                  /*CCM002*/
             ENDDO                                                    /*CCM002*/
/*                                                                  */
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
/**********           RTGDTA(*JOBD)                        /*S01493*/ /*101971*/
/************SBMJOB   JOB(EDCONTROL) JOBD(EDJOBD) USER(*JOBD) +       /*110242*/
/*************        JOBQ(EDJOBQ) RQSDTA('CALL EDC0040')    +        /*110242*/
/*************        RTGDTA(*JOBD)*/                          /*101971 110242*/
/************SBMJOB   JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(EDJOBQ) +      /*CED007*/
/*************        USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +        /*CED007*/
/*************        EDC0040') INLLIBL(*JOBD)                 /*110242 CED007*/
/************SBMJOB     JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(INTERFACE) +                     /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             EDC0040') INLLIBL(*JOBD)                    /*CED007*/          /*CSC023*/
             SBMJOB     JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          EDC0040') INLLIBL(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 EDLABL:                                                              /*S01493*/
    ENDDO                                                             /*S01493*/
                                                                      /*CGL004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL004' +
                          &FMT)                                       /*CGL004*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CGL004*/
             ALCOBJ     OBJ((GLFONTDA *DTAARA *EXCL)) WAIT(1)         /*CGL004*/
             MONMSG   MSGID(CPF1002) EXEC(GOTO CMDLBL(CGLABL))        /*CGL004*/
             DLCOBJ   OBJ((GLFONTDA *DTAARA *EXCL))                   /*CGL004*/
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
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL013' +
                          &FMT)                                       /*CGL013*/
             IF         (&RTCD *EQ '       ') +
                 CALL       PGM(GLC001410) PARM('*START' ' ' ' ')     /*CGL013*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,RRRECOVMPE                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             GOTO       ENDCLPGM
ABNORMAL:
/*           An abnormal message has been issued and to prevent      */
/*           further errors  being  sent to the ABNORMAL tag by      */
/*           the general MONMSG command  in  the  first line of      */
/*           executable code each of the  following  lines  are      */
/*           individually  monitored  to  prevent  any  further      */
/*           errors which may occur from causing looping.            */
/*                                                                   */
             SNDPGMMSG  MSG('Program RRRECOVER ended abnormally - job +
                          cancelled') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                  */
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
/*                                                                  */
 ENDCLPGM:
/************SNDPGMMSG  MSG(MIDAS) TOMSGQ(MSTATUS)                                     */ /*CPK017*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF8351)                                /*E13205*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDPGM:     ENDPGM     /* END CL PGM */
