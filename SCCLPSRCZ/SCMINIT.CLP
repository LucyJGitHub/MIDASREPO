/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Midas initial program with EMC02')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCMINIT -  STARTS OR RE-OPENS THE INPUT CYCLE               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020B            Date 06Aug12              */
/*                      CSD083             Date 27May10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      243665             Date 24Apr07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BG7613R            Date 29Mar06              */
/*                      BG7613             Date 29Jun05              */
/*                      CPK020             Date 13Aug04              */
/*                      BUG4836            Date 25Oct04              */
/*                      BUG3587            Date 15Jul04              */
/*                      BUG2381            Date 13May04              */
/*                      CRE020             Date 20Jan04              */
/*                      CGP004             Date 23Feb04              */
/*                      CSC023             Date 02Feb04              */
/*                      CSC020             Date 31Mar04              */
/*                      CPK017             Date 28Oct03              */
/*                      CRE008             Date 19Feb02              */
/*                      CGL013             Date 29Mar02              */
/*                      CSE039             Date 20MAR03              */
/*                      CSD015             Date 03Mar03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      203561             Date 21Jun02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 01May02              */
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 07Nov11              */
/*                      193083             Date 06Jul01              */
/*                      CCM003             Date 27Mar01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                                         Date 12May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      178120             Date 31Aug00              */
/*                      176691             Date 03Mar00              */
/*                      CDE001             Date 12Nov99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009             Date 18Mar99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      124115             Date 08Oct97              */
/*                      CLE004             Date 11May97              */
/*                      CGL004             DATE 03NOV97              */
/*                      CED007             DATE 03NOV97              */
/*                      S01408             DATE 17JUN96              */
/*                      S01408             DATE 11JUN96              */
/*                      101971             DATE 15MAY96              */
/*                      S01408             DATE 10APR96              */
/*                      CCM002             DATE 04SEP95              */
/*                      S01408             DATE 18APR95              */
/*                      S01420             DATE 17MAR95              */
/*                      081177             DATE 07MAR95              */
/*                      S01493             DATE 01JUN94              */
/*                      061601             DATE 24FEB94              */
/*                      S01343             DATE 21AUG91              */
/*                      E22893             DATE 07AUG90              */
/*                      LN0017             DATE 26APR90              */
/*                      S01117             DATE 09MAR90              */
/*                      S01189             DATE 04APR89              */
/*                      E20391             DATE 26NOV89              */
/*                      E13205             DATE 14/03/89             */
/*                      E16342             DATE 09/03/89             */
/*                      E14071             DATE 25/08/88             */
/*                      S01179             DATE 10/09/88             */
/*                      E80694             DATE 12/06/86             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020B - COB Restructure - Secondary COB Infrastructure    */
/*       CSD083 - Watch List Compliance Upgrade                      */
/*       243665 - Reset MPHAS if error, don't fail if CB files locked*/
/*       BG7613R- Correct typo...                                    */
/*       BG7613 - Don't reset triggers if they haven't been removed  */
/*                yet (otherwise you get file locking problems)      */
/*       CPK020 - Put command over SCMNTTRIG.                        */
/*       BUG4836 - Global triggers should not be removed on reopen   */
/*       BUG3587 - Trigger programs should run after Reopen IC is    */
/*                 taken in COB.                                     */
/*       BUG2381 - Batch submit of confirmations programs            */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CGP004 - Audit Reporting                                    */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CPK017 - Midas Plus packaging.                              */
/*                Comment out the remove of msg from MSTATUS and     */
/*                the send of 'MIDAS' to MSTATUS at ENDCLPGM.        */
/*       CRE008 - Cash Management                                    */
/*       CGL013 - MT94x Message Generation                           */
/*       CSE039 - Automatic Settlement of Trades                     */
/*       CSD015 - Midas Compliance Watch - Watch List Checking       */
/*       203561 - Ensure Loan Manager is kept in sync with Midas.    */
/*       CPK015 - Release 4.01 packaging.                            */
/*                - SBMJOBs changed to specify USER(*JOBD).          */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CPK014 - Release 4 packaging.  Data queues moved from XLIB  */
/*                to DPLIB.                                          */
/*       193083 - Call to LEC2010 now has a parameter                */
/*       CCM003 - Condition DL0003 on CCM003.                        */
/*       178120 - Ensure that the system is in Client Mode at start  */
/*                of each input cycle - the alternative, BIS Mode,   */
/*                allows technicians to amend certain data not       */
/*                normally accessible by users.                      */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*       176691 - Remove the CLE006(Syndications) conditioning       */
/*       CDE001 - Data Export - CCRM Limits                          */
/*       CGL009 - Midas-Fontis Inter-Account Transfers (IAT) and     */
/*                Third Party Payments (TPP) Interface               */
/*       124115 - LEC2016 still not ending.                          */
/*       CLE004 - Customer Lending Enhancements - Syndications       */
/*       CGL004 - Midas-Fontis Interface, add submission of          */
/*                Background job                                     */
/*       CED007 - ED enhancements, change JOBQ for submission        */
/*                of EDCONTROL                                       */
/*       S01408 - Core hook SCMINIT005 added.                        */
/*       S01408 - Core hook SCMINIT004 added.                        */
/*                Core hook SCMINIT003 added.                        */
/*                Core hook SCMINIT002 added.                        */
/*                Core hook SCMINIT001 added.                        */
/*       101971 - Change name of EDC0040 job to                      */
/*                descriptive EDCONTROL                              */
/*       S01408 - Addition of core hook SCMINITINT                   */
/*                Addition of core hook SCMINITMPE                   */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI).      */
/*                If feature is on, submit the Citydealer Interface  */
/*                background jobs.                                   */
/*       S01408 - Core hook added SCMINTMP1                          */
/*       S01420 - CoB enhancements (Batch Processing)                */
/*       081177 - Use Job Description library list instead of        */
/*                current library list when submitting job.          */
/*       S01493 - MIDAS EXPORT DATA MODULE                           */
/*       061601 - Change the delivery parameter of the MSGQ to       */
/*                *BREAK to ensure that the message 'Job cannot be   */
/*                run at this time' will break on the screen.        */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                    */
/*              - SCMINIT RENAMED FROM MINIT                         */
/*              - SCC07 RENAMED FROM SDC07                           */
/*              - SCC01 RENAMED FROM SDC01                           */
/*       E22893 - WHEN NON-DRS RECOVERY WAS REQUIRED THE SYSTEM      */
/*                SIGNED THE USER OFF. PGM CHANGED TO PRINT THE      */
/*                JOBLOG AND RRTJOB (MIDASIC).                       */
/*       LN0017 - REMOVAL OF TERMINATION OF RCF DISTRIBUTION         */
/*                JOB                                                */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01189 - CLOSE OF BUSINESS ENHANCEMENTS PHASE 2             */
/*       E20391 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.            */
/*       E13205 - Change EMSTAT position 2 to 'Y' after SBMJOB       */
/*       E16342 - EM0100 JOB SHOULD BE EM0101                        */
/*       E14071 - ALLOW DRS TAKE-ON TO BE RESTARTED.                 */
/*       S01179 - AS400 CONVERSION                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PRM01)
/*                                                                            */
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCMINITINT                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        &PRM01        TYPE(*CHAR)  LEN(8)
             DCL        &ERROR        TYPE(*CHAR)  LEN(1) VALUE('0')
             DCL        &JOB          TYPE(*CHAR)  LEN(10)
             DCL        &USER         TYPE(*CHAR)  LEN(10)
             DCL        &DATE         TYPE(*CHAR)  LEN(6)
             DCL        &SPECIAL      TYPE(*CHAR)  LEN(6)
             DCL        &STATMSG      TYPE(*CHAR)  LEN(5)
             DCL        &RPY          TYPE(*CHAR)  LEN(1)
             DCL        &REOPFL       TYPE(*CHAR)  LEN(1)             /*S01189*/
             DCL        VAR(&DTQALEN)  TYPE(*DEC) LEN(5) VALUE(16)    /*S01189*/
             DCL        VAR(&DTQCLEN)  TYPE(*DEC) LEN(5) VALUE(1)     /*S01189*/
/**********  DCL        VAR(&DTQDLEN)  TYPE(*DEC) LEN(5) VALUE(1) S01117LN0017*/
/**********  DCL        VAR(&T) TYPE(*CHAR) LEN(1) VALUE('T')     S01117LN0017*/
/************DCL        VAR(&PRELIB)  TYPE(*CHAR) LEN(2)                       /*S01189*/ /*CPK014*/
/************DCL        VAR(&DTAQLIB)  TYPE(*CHAR) LEN(10) +                              /*CPK014*/
/************           VALUE('  XLIB    ')                                    /*S01189*/ /*CPK014*/
             DCL        VAR(&MSGA) TYPE(*CHAR) LEN(16) +
                          VALUE('               E')                   /*S01189*/
             DCL        VAR(&MSGC) TYPE(*CHAR) LEN(1) VALUE('C')      /*S01189*/
/***         DCLDTAARA  MPHAS                                       *  *S01179*/
/***         DCLDTAARA  TSTATUS                                     *  *S01179*/
/***         DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
/***         DCLDTAARA  DTAARA(EMSTAT)                              *  *S01179*/
             DCL        VAR(&TSTATUS) TYPE(*CHAR) LEN(8)              /*S01179*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                /*S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
             DCL        VAR(&EMSTAT) TYPE(*CHAR) LEN(256)             /*S01179*/
             DCL VAR(&AOMMOD) TYPE(*CHAR) LEN(200)                    /*S01493*/
             DCL VAR(&OPTN)  TYPE(*CHAR) LEN(7) VALUE('*FIRST')       /*S01493*/
             DCL VAR(&RTNC)  TYPE(*CHAR) LEN(7)                       /*S01493*/
             DCL        VAR(&CITYDLR) TYPE(*CHAR) LEN(1) VALUE('N')   /*CCM002*/
             DCL        VAR(&CDSTAT) TYPE(*CHAR) LEN(27)              /*CCM002*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CCM002*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)             /*CCM002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CGL004*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CGL004*/
             DCL        VAR(&CLE004) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CLE004*/
/*********** DCL VAR(&CLE006) TYPE(*CHAR) LEN(1) VALUE('N' )/*CLE004    176691*/
             DCL        VAR(&CSE039) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CSE039*/
             DCL        VAR(&CLE010) TYPE(*CHAR) LEN(1) VALUE('N' )   /*176691*/
             DCL        VAR(&CGL009) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CGL009*/
             DCL        VAR(&CDE001) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CDE001*/
             DCL        VAR(&CRE008) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CRE008*/
             DCL        VAR(&CGP004) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CGP004*/
             DCL        VAR(&CCM003) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CCM003*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC011*/
             DCL        VAR(&CSD015) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD015*/
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD015*/
             DCL        VAR(&CSD083) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD083*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CSD015*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CSD015*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CSD015*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)                                  /*CSD015*/
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)                                  /*CSD015*/
             DCL        VAR(&PRELIB)  TYPE(*CHAR) LEN(2)                                  /*CSD015*/
             DCL        VAR(&PREMAIN)  TYPE(*CHAR) LEN(2)                                 /*CSD015*/
             DCL        VAR(&W1OFSR)  TYPE(*CHAR) LEN(32)                                 /*CSD015*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CRE020*/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(10)                              /*BG7613*/
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)                                    /*243665*/
                                                                                         /*CCB020B*/
/* Declare system values variables. */                                                   /*CCB020B*/
                                                                                         /*CCB020B*/
             DCL        VAR(&POP01) TYPE(*CHAR) LEN(20) +
                          VALUE('BankPhaseEndReopen')                                    /*CCB020B*/
             DCL        VAR(&POP02) TYPE(*CHAR) LEN(20)                                  /*CCB020B*/
             DCL        VAR(&POP03) TYPE(*CHAR) LEN(20)                                  /*CCB020B*/
             DCL        VAR(&POP04) TYPE(*CHAR) LEN(20)                                  /*CCB020B*/
             DCL        VAR(&POP05) TYPE(*CHAR) LEN(20)                                  /*CCB020B*/
             DCL        VAR(&POP06) TYPE(*CHAR) LEN(20)                                  /*CCB020B*/
             DCL        VAR(&POP07) TYPE(*CHAR) LEN(20)                                  /*CCB020B*/
             DCL        VAR(&POP08) TYPE(*CHAR) LEN(20)                                  /*CCB020B*/
             DCL        VAR(&POP09) TYPE(*CHAR) LEN(20)                                  /*CCB020B*/
             DCL        VAR(&POP10) TYPE(*CHAR) LEN(20)                                  /*CCB020B*/
             DCL        VAR(&PVL01) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
             DCL        VAR(&PVL02) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
             DCL        VAR(&PVL03) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
             DCL        VAR(&PVL04) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
             DCL        VAR(&PVL05) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
             DCL        VAR(&PVL06) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
             DCL        VAR(&PVL07) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
             DCL        VAR(&PVL08) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
             DCL        VAR(&PVL09) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
             DCL        VAR(&PVL10) TYPE(*CHAR) LEN(200)                                 /*CCB020B*/
                                                                                         /*CCB020B*/
             DCL        VAR(&BPPARM) TYPE(*CHAR) LEN(98)                                 /*CCB020B*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
                                                                                          /*CSC011*/
/** Check if 24x7 Midas Availability Feature is on */                                     /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CSC011*/
             CHGVAR     VAR(&SAR) VALUE('CSC011')                                         /*CSC011*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC011) VALUE('Y'))                                        /*CSC011*/
/*                                                                          */
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SCMINIT005                                           /*S01408*/
/*                                                                    /*S01408*/
/***         RCVDTAARA  MPHAS                                       *  *S01179*/
/***         RCVDTAARA  DTAARA(MMOD)                                *  *S01179*/
/***         RCVDTAARA  DTAARA(EMSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                  /*S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
             RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)                /*S01179*/
             RTVJOBA    JOB(&JOB)  USER(&USER)  DATE(&DATE)
/*                                                                          */
/*       Allocate the message queue.                                        */
/*                                                                          */
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(9999)
/**/                                                                  /*E80694*/
/********    ALCOBJ OBJ((EODQ0 *MSGQ *EXCL) (EODQ1 *MSGQ *EXCL)/*E80694*/
                                                                      /*S01189*/
/********    (EODQ2 *MSGQ *EXCL) (EODQ3 *MSGQ *EXCL) (EODQ4 *MSGQ/*E80694*/
                                                                      /*S01189*/
/********    *EXCL) (EODQ5 *MSGQ *EXCL) (EODQ6 *MSGQ *EXCL) (EODQ7/*E80694*/
                                                                      /*S01189*/
 /*******    *MSGQ *EXCL) (EODQ8 *MSGQ *EXCL) (EODQ9 *MSGQ *EXCL)) /*E80694*/
                                                                      /*S01189*/
/**/                                                                  /*E80694*/
/********    RMVMSG     MSGQ(EODQ0) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/********    RMVMSG     MSGQ(EODQ1) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/********    RMVMSG     MSGQ(EODQ2) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/********    RMVMSG     MSGQ(EODQ3) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/********    RMVMSG     MSGQ(EODQ4) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/********    RMVMSG     MSGQ(EODQ5) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/********    RMVMSG     MSGQ(EODQ6) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/********    RMVMSG     MSGQ(EODQ7) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/********    RMVMSG     MSGQ(EODQ8) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/********    RMVMSG     MSGQ(EODQ9) CLEAR(*ALL)            /*E80694*/ /*S01189*/
/**/                                                                  /*E80694*/
/********    DLCOBJ OBJ((EODQ0 *MSGQ *EXCL) (EODQ1 *MSGQ *EXCL)/*E80694*/
                                                                      /*S01189*/
/********    (EODQ2 *MSGQ *EXCL) (EODQ3 *MSGQ *EXCL) (EODQ4 *MSGQ/*E80694*/
                                                                      /*S01189*/
/********    *EXCL) (EODQ5 *MSGQ *EXCL) (EODQ6 *MSGQ *EXCL) (EODQ7/*E80694*/
                                                                      /*S01189*/
/********    *MSGQ *EXCL) (EODQ8 *MSGQ *EXCL) (EODQ9 *MSGQ *EXCL))/*E80694*/
                                                                      /*S01189*/
/*                                                                          */
             SNDPGMMSG  MSG('INIT  ') TOMSGQ(MSPECIAL)
/************CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                                      */ /*CPK017*/
/************RCVMSG     MSGQ(MSTATUS)                                                  */ /*CPK017*/
/*                                                                          */
LOOP1:       CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&STATMSG)
/*                                                                          */
             IF         COND(&STATMSG *NE '     ') THEN(DO)
/**LOOP2:****SNDPGMMSG  MSG('Job cannot be run now - do you wish +*/ /*061601*/
/************             to re-try - Y or N?') TOMSGQ(&JOB) +    */ /*061601*/
/************             MSGTYPE(*INQ)                           */ /*061601*/
LOOP2:            CHGMSGQ    MSGQ(&JOB) DLVRY(*BREAK)                /*061601*/
                  SNDPGMMSG  MSG('Job cannot be run now - do you +
                                  wish to re-try - Y or N?') +
                                  TOMSGQ(&JOB) MSGTYPE(*INQ)         /*061601*/
                  CHGMSGQ    MSGQ(&JOB) DLVRY(*NOTIFY)               /*061601*/
             RCVMSG     MSGQ(*PGMQ) MSGTYPE(*RPY) WAIT(*MAX) +
                          RMV(*YES) MSG(&RPY)
             IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                          THEN(GOTO CMDLBL(LOOP1))
             IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(GOTO CMDLBL(ABEND))
             ELSE       CMD(GOTO CMDLBL(LOOP2))
             ENDDO
/*                                                                          */
             RCLRSC
/** Check whether the' kill object lock' component has completed  */                      /*BG7613*/
/** If so, the remove trigger component may have started, so      */                      /*BG7613*/
/** replace them all anyway.                                      */                      /*BG7613*/
             CALL       PGM(SC000010) PARM(&RETURNCODE)                                   /*BG7613*/
/*********** IF         COND(&RETURNCODE = '*Complete') THEN(DO)             /*BG7613*/  /*BG7613R*/
             IF         COND(&RETURNCODE = '*Error') THEN(DO)                            /*BG7613R*/
                SNDPGMMSG  MSG('Error accessing trigger details - +
                          SCMINIT') TOMSGQ(MRUNQ)
             ENDDO                                                                        /*BG7613*/
             IF         COND(&RETURNCODE = '*Complete') THEN(DO)                          /*BG7613*/
                                                                                         /*BUG3587*/
/** Call the following programs to activate the triggers. */                             /*BUG3587*/
                                                                                         /*BUG3587*/
/** For Zonal */                                                                         /*BUG3587*/
/**********  CALL       PGM(SCMNTTRIG) PARM('A' '          ' 'Y')          */ /*BUG3587*/ /*CPK020*/
             TRIGZONE   ACTION(*ADDTRIG)                                                  /*CPK020*/
/** For Global */                                                                        /*BUG3587*/
/*********** CALL       PGM(GPMNTTRIG) PARM('A' '          ' 'Y') *************BUG3587*/ /*BUG4836*/
/*********** TRIGGLOB   ACTION(*ADDTRIG)                          **************CPK020*/ /*BUG7613*/
                                                                                         /*BUG3587*/
             ENDDO                                                                        /*BG7613*/
/*                                                                          */
             CALL       &PRM01 PARM(&ERROR)
/*The following coding applies if a database error is encountered by*/
/*the*component*procedure*-*SDC01:*In*order*to*prevent*any*other***** /*S01343*/
/*the component procedure - SCC01: In order to prevent any other    * /*S01343*/
/*users from attempting to sign on to retry initiation, the data    */
/*area TSTATUS must be changed to 'RECOVERY'. The current user has  */
/*then to be signed off, and upon re-signon is shown the Recovery   */
/*screen - controlled by MIPGM.                                     */
/***         RCVDTAARA  DTAARA(TSTATUS)                             *  *S01179*/
             RTVDTAARA  DTAARA(TSTATUS) RTNVAR(&TSTATUS)              /*S01179*/
/**/                                                                  /*E14071*/
             IF COND(&TSTATUS = 'DRSRECOV') THEN(DO)                  /*E14071*/
                CHGJOB  SWS(00000000)                                 /*E14071*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SCMINIT001                                           /*S01408*/
/*                                                                    /*S01408*/
                SNDPGMMSG 'DATABASE ERROR FOUND - SCMINIT' TOMSGQ(MRUNQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SCMINIT002                                           /*S01408*/
/*                                                                    /*S01408*/
                CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)                 /*E14071*/
                RCVMSG  MSGQ(MSPECIAL) /*REMOVE INIT*/                /*E14071*/
                GOTO CMDLBL(RETURN)                                   /*E14071*/
             ENDDO                                                    /*E14071*/
/**/
             IF COND(&TSTATUS = 'RECOVERY') THEN(DO)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SCMINIT003                                           /*S01408*/
/*                                                                    /*S01408*/
                SNDPGMMSG 'DATABASE ERROR FOUND - SCMINIT' TOMSGQ(MRUNQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,SCMINIT004                                           /*S01408*/
/*                                                                    /*S01408*/
                CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
                RCVMSG  MSGQ(MSPECIAL) /*REMOVE INIT*/
/***************SIGNOFF LOG(*LIST) */                                 /*E22893*/
                DSPJOB     OUTPUT(*PRINT) OPTION(*JOBLOG)             /*E22893*/
                                                                                          /*CSC011*/
             IF         COND(&CSC011 *EQ 'Y') THEN(DO)                                    /*CSC011*/
                CALL       PGM(SCC004340)                                                 /*CSC011*/
                                                                                          /*CSC011*/
/** Database Error Processing */                                                          /*CSC011*/
                                                                                          /*CSC011*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                           CMDLBL(ABNORMAL))                                              /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
                RRTJOB     RTGDTA(MIDASIC)                            /*E22893*/
             ENDDO
/**/
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
/*                                                                  */
             IF         COND(&ERROR *EQ '0') THEN(DO)
/**/                                                                  /*CSE039*/
/*    Check if Automatic Settlement of Trades is active (CSE039)      /*CSE039*/
/**/                                                                  /*CSE039*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CSE039*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSE039*/
             CHGVAR     VAR(&SAR) VALUE('CSE039')                     /*CSE039*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CSE039*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSE039) VALUE('Y'))                    /*CSE039*/
/**/                                                                  /*124115*/
/*    Check if Lending Enhancements feature is active (CLE004)        /*124115*/
/**/                                                                  /*124115*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*124115*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*124115*/
             CHGVAR     VAR(&SAR) VALUE('CLE004')                     /*124115*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*124115*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE004) VALUE('Y'))                    /*124115*/
/**/                                                                  /*124115*/
/*    Check if CCRM - Limits is active (CDE001)                       /*CDE001*/
/**/                                                                  /*CDE001*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CDE001*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CDE001*/
             CHGVAR     VAR(&SAR) VALUE('CDE001')                     /*CDE001*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CDE001*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE001) VALUE('Y'))                    /*CDE001*/
/**/                                                                  /*CDE001*/
/*    Check if Cash Management is active (CRE008)                                         /*CRE008*/
/**/                                                                                      /*CRE008*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CRE008*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE008*/
             CHGVAR     VAR(&SAR) VALUE('CRE008')                                         /*CRE008*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CRE008*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CRE008) VALUE('Y'))                                        /*CRE008*/
/**/                                                                                      /*CGP004*/
/*    Check if Audit Reporting is active (CGP004)                                         /*CGP004*/
/**/                                                                                      /*CGP004*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                                       /*CGP004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CGP004*/
             CHGVAR     VAR(&SAR) VALUE('CGP004')                                         /*CGP004*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CGP004*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CGP004) VALUE('Y'))                                        /*CGP004*/
/**/                                                                                      /*CRE008*/
/* Check if Lending Enhancements feature is active (CLE006)/*124115*/ /*176691*/
/**/                                                       /*124115*/ /*176691*/
/*********** CHGVAR     VAR(&RTNC) VALUE('       ')        /*124115*/ /*176691*/
/*********** CHGVAR     VAR(&OPTN) VALUE('*VERIFY')        /*124115*/ /*176691*/
/*********** CHGVAR     VAR(&SAR) VALUE('CLE006')          /*124115*/ /*176691*/
/*** CALL    PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*124115*/ /*176691*/
/*********** IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE006) VALUE('Y'))         /*124115*/ /*176691*/
/**/                                                                  /*124115*/
/*    Check if Lending Enhancements feature is active (CLE010)        /*176691*/
/**/                                                                  /*176691*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*176691*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*176691*/
             CHGVAR     VAR(&SAR) VALUE('CLE010')                     /*176691*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*176691*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE010) VALUE('Y'))                    /*176691*/
/**/                                                                  /*176691*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*124115*/
/*********** IF         COND(&CLE004 *EQ 'Y' *AND &CLE006 *EQ 'Y') +
/***********              THEN(CALL PGM(LEC2010))          /*124115*/ /*176691*/
/************IF         COND(&CLE004 *EQ 'Y' *AND &CLE010 *EQ 'Y') + */                   /*203561*/
/************             THEN(CALL PGM(LEC2010) PARM('N'))          */        /*193083*/ /*203561*/
/************             THEN(CALL PGM(LEC2010))                           */ /*176691*/ /*193083*/
                                                                                          /*203561*/
/* Restart the Loan Manager Interface jobs & inform Loan Manager Server                   /*203561*/
                                                                                          /*203561*/
             IF         COND(&CLE004 *EQ 'Y' *AND &CLE010 *EQ 'Y') +
                          THEN(CALL PGM(LEC2018))                                         /*203561*/
                                                                                          /*203561*/
/**/                                                                  /*CDE001*/
/* Restart the CCRM - Limits Drip Feed job.                           /*CDE001*/
/**/                                                                  /*CDE001*/
             IF         COND(&CDE001 *EQ 'Y') +
                          THEN(CALL PGM(DEC0004))                     /*CDE001*/
/**/                                                                  /*CDE001*/
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
/** Restart the APIs Retail Advices jobs */                                               /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&CRE020 *EQ 'Y') THEN(DO)                                    /*CRE020*/
                CALL       PGM(APC0460)                                                   /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
/* Restart the Cash Management batch jobs                                                 /*CRE008*/
/**/                                                                                      /*CRE008*/
             IF         COND(&CRE008 *EQ 'Y') THEN(DO)                                    /*CRE008*/
             CALL       PGM(REC101201)                                                    /*CRE008*/
             CALL       PGM(REC101501)                                                    /*CRE008*/
             ENDDO                                                                        /*CRE008*/
/**/                                                                                      /*CGP004*/
/* Restart the Audit Reporting batch job                                                  /*CGP004*/
/**/                                                                                      /*CGP004*/
             IF         COND(&CGP004 *EQ 'Y') THEN(DO)                                    /*CGP004*/
                CALL       PGM(GOC0300)                                                   /*CGP004*/
             ENDDO                                                                        /*CGP004*/
/**/                                                                                      /*CRE008*/
/* Restart the APIs Confirmations job                                                    /*BUG2381*/
/**/                                                                                     /*BUG2381*/
             CALL       PGM(APC0430)                                                     /*BUG2381*/
/**/                                                                                     /*BUG2381*/
                CHGDTAARA  DTAARA(MPHAS) VALUE('A')
                                                                                         /*CCB020B*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                     /*CCB020B*/
             CALL       PGM(AOSVALR0) PARM(&PRTCD &POP01 &PVL01 +
                          &POP02 &PVL02 &POP03 &PVL03 &POP04 +
                          &PVL04 &POP05 &PVL05 &POP06 &PVL06 +
                          &POP07 &PVL07 &POP08 &PVL08 &POP09 +
                          &PVL09 &POP10 &PVL10)                                          /*CCB020B*/
                                                                                         /*CCB020B*/
             IF         COND((&PRTCD *NE ' ') *AND (&PRTCD *NE +
                          '*NRF')) THEN(DO)                                              /*CCB020B*/
                GOTO       CMDLBL(ABNORMAL)                                              /*CCB020B*/
             ENDDO                                                                       /*CCB020B*/
                                                                                         /*CCB020B*/
             IF         COND(&PVL01 *NE '       ') THEN(DO)                              /*CCB020B*/
                CHGVAR     VAR(&BPPARM) VALUE(%SUBSTRING(&PVL01 1 98))                   /*CCB020B*/
                CALL       PGM(SCC001060) PARM(&BPPARM)                                  /*CCB020B*/
                                                                                         /*CCB020B*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                              /*CCB020B*/
                   GOTO       CMDLBL(ABNORMAL)                                           /*CCB020B*/
                ENDDO                                                                    /*CCB020B*/
             ENDDO                                                                       /*CCB020B*/
                                                                                         /*CCB020B*/
             SCWRTJREG  EVENT(MPHAS) FLAG(R) TEXT('MPHAS changed +
                          to A on input cycle reopen')                                    /*CSC020*/
                                                                                          /*CGP002*/
/* Update global dashboard */                                                             /*CGP002*/
                                                                                          /*CGP002*/
             CALL       PGM(GOC000100) PARM('*PHASE')                                     /*CGP002*/
                                                                                          /*CGP002*/
/*/COPY WNCPYSRC,SCMINIT006                                          */
/**/                                                                  /*CSE039*/
/* Restart the AGENCY TRADE SETTLEMENT Job.                           /*CSE039*/
/**/                                                                  /*CSE039*/
             IF         COND(&CSE039 *EQ 'Y') +
                          THEN(CALL PGM(SEC4320))                     /*CSE039*/
/**/                                                                  /*CRT004*/
/*    Check if Cashier TCP/IP Interface feature is active (CRT004)    /*CRT004*/
/**/                                                                  /*CRT004*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CRT004*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CRT004*/
             CHGVAR     VAR(&SAR) VALUE('CRT004')                     /*CRT004*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CRT004*/
             IF         COND(&RTNC *EQ '       ') +
                          THEN(CALL PGM(REC4510) PARM('START'))       /*CRT004*/
/**/                                                                  /*CRT004*/
                  IF  COND(%SUBSTRING(&MMOD 7 1) *EQ 'Y') THEN(DO)
                  ALCOBJ     OBJ((EMCHK *DTAARA *EXCL)) WAIT(1)
                  MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP1))
                  IF  (%SST(&EMSTAT 2 1) *EQ 'N') THEN(DO)
                                                             /*E16342*/
/*                SBMJOB     JOB(EM0100) JOBD(MBATCH) +              */
/**************** SBMJOB     JOB(EM0101) JOBD(MBATCH) +               /*E20391*/
/****************   USER(*JOBD) JOBQ(EMJOBQ) RQSDTA('CALL EMC02') */
                                                             /*E16342*/
/**************** SBMJOB     JOB(EMCLR) JOBD(MBATCH) +
/****************   USER(*JOBD) JOBQ(EMJOBQ) RQSDTA('CALL EMCLR')     /*E20391*/
                                                                      /*E20391*/
/**********       SBMJOB     JOB(EM0101) JOBD(MBATCH) +
/**********         USER(*JOBD) JOBQ(EMJOBQ) RQSDTA('CALL EMC02') +
/**********         RTGDTA(*JOBD)                          /*S01189*/ /*081177*/
/************     SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +                      /*CSC023*/
/************                  USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                   /*CSC023*/
/************                  EMC02') INLLIBL(*JOBD)                 /*081177*/          /*CSC023*/
                  SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +
                               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                               EMC02') INLLIBL(*JOBD) OUTQ(*JOBD)                         /*CSC023*/
 
/**********       SBMJOB     JOB(EMCLR) JOBD(MBATCH) +
/**********         USER(*JOBD) JOBQ(EMJOBQ) RQSDTA('CALL EMCLR') +
/**********         RTGDTA(*JOBD)                          /*S01189*/ /*081177*/
/************     SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +                       /*CSC023*/
/************                  USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                   /*CSC023*/
/************                  EMCLR') INLLIBL(*JOBD)                 /*081177*/          /*CSC023*/
                  SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +
                               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                               EMCLR') INLLIBL(*JOBD) OUTQ(*JOBD)                         /*CSC023*/
                                                                      /*E20391*/
                  CHGDTAARA  DTAARA(EMSTAT (2 1)) VALUE('Y')          /*E13205*/
                  ENDDO
                  DLCOBJ     OBJ((EMCHK *DTAARA *EXCL))
 SKIP1:      ENDDO
/*    BEGIN  124115  */
/**/                                                                  /*CLE004*/
/*    Check if Lending Enhancements feature is active (CLE004)        /*CLE004*/
/**/                                                                  /*CLE004*/
/************CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CLE004*/
/************CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CLE004*/
/************CHGVAR     VAR(&SAR))VALUE('CLE004')')                   /*CLE004*/
/************CALLAR     PGM(AOSARDR0)LPARM(&RTNC &OPTN &SAR &SARREC)  /*CLE004*/
/************IFGVAR     COND(&RTNC *EQU'('     ')'THEN(CHGVAR +       /*CLE004*/
/************CHGVAR     VAVAR(&CLE004) VALUE('Y')))                   /*CLE004*/
/**/                                                                  /*CLE004*/
/*    Check if Lending Enhancements feature is active (CLE006)        /*CLE004*/
/**/                                                                  /*CLE004*/
/************CHGVAR     VAR(&RTNC)0VALUE('UE('Y')')                   /*CLE004*/
/************CHGVAR     VAR(&OPTN)0VALUE('*VERIFY')                   /*CLE004*/
/************CHGVAR     VAR(&SAR)EVALUE('CLE006')))                   /*CLE004*/
/************CALLAR     PGM(AOSARDR0))PARM(&RTNC)&OPTN &SAR &SARREC)  /*CLE004*/
/************IFGVAR     COND(&RTNC0*EQU'ALUE('Y'))THEN(CHGVAR +       /*CLE004*/
/************CHGVAR     VAVAR(&CLE006) VALUE('Y')))                   /*CLE004*/
/**/                                                                  /*CLE004*/
/************                                                          *CLE004*/
/************CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CLE004*/
/************IF         COND(&CLE004 *EQ 'Y' *AND &CLE006 *EQ 'Y') +   *CLE004*/
/************             THEN(CALL PGM(LEC2010))                     /*CLE004*/
/*    END    124115  */
/**/                                                                  /*CCM002*/
/*    Check if Citydealer Interface feature is active.                /*CCM002*/
/**/                                                                  /*CCM002*/
             CHGVAR     VAR(&RTNC) VALUE('       ')                   /*CCM002*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CCM002*/
             CHGVAR     VAR(&SAR) VALUE('CCM002')                     /*CCM002*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)  /*CCM002*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CITYDLR) VALUE('Y'))                   /*CCM002*/
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
/**********      SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) + */        /*CCM002*/ /*CPK015*/
/**********                   RTGDTA(CITYD) RQSDTA('CALL DLC0002') + */        /*CCM002*/ /*CPK015*/
/**********                   MSGQ(*NONE)                            */        /*CCM002*/ /*CPK015*/
/************    SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +                      /*CSC023*/
/************                 RTGDTA(CITYD) RQSDTA('CALL DLC0002') +                      /*CSC023*/
/************                 MSGQ(*NONE) USER(*JOBD)                          /*CPK015*/ /*CSC023*/
                 SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +
                              RTGDTA(CITYD) RQSDTA('CALL DLC0002') +
                              MSGQ(*NONE) USER(*JOBD) OUTQ(*JOBD)                         /*CSC023*/
             IF         COND(&CCM003 *EQ 'N') THEN(DO)                /*CCM003*/
/**********      SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +  */        /*CCM003*/ /*CPK015*/
/**********                   RTGDTA(CITYD) RQSDTA('CALL DL0003') +  */        /*CCM003*/ /*CPK015*/
/**********                   MSGQ(*NONE)                            */        /*CCM003*/ /*CPK015*/
/************    SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +                       /*CSC023*/
/************                 RTGDTA(CITYD) RQSDTA('CALL DL0003') +                       /*CSC023*/
/************                 MSGQ(*NONE) USER(*JOBD)                          /*CPK015*/ /*CSC023*/
                 SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +
                              RTGDTA(CITYD) RQSDTA('CALL DL0003') +
                              MSGQ(*NONE) USER(*JOBD) OUTQ(*JOBD)                         /*CSC023*/
               ENDDO                                                  /*CCM003*/
                 CHGDTAARA  DTAARA(DLCDSTAT (1 1)) VALUE('Y')         /*CCM002*/
               ENDDO                                                  /*CCM002*/
             ENDDO                                                    /*CCM002*/
/**/
/*****SUBMIT*EDC0040*JOB*IF*ED*MODULE*IS*PRESENT*AND****** /*S01493*/ /*101971*/
/*    SUBMIT EDCONTROL JOB IF ED MODULE IS PRESENT AND                /*101971*/
/*    THE JOB IS NOT ALREADY RUNNING                                  S01493*/
/**/
 
             CALL       PGM(AOMMODR0) PARM(&RTNC &OPTN &AOMMOD) +
                          /*S01493*/
             IF         COND(%SUBSTRING(&AOMMOD 99 1) *EQ 'Y') +
                          THEN(DO) /*S01493*/
             ALCOBJ   OBJ((EDC0040 *DTAARA *EXCL)) WAIT(1)            /*S01493*/
             MONMSG   MSGID(CPF1002) EXEC(GOTO CMDLBL(EDLABL))        /*S01493*/
             DLCOBJ   OBJ((EDC0040 *DTAARA *EXCL))                    /*S01493*/
/**********  SBMJOB   JOB(EDC0040) JOBD(EDJOBD) USER(*JOBD) +
/**********           JOBQ(EDJOBQ) RQSDTA('CALL EDC0040')    +
/**********           RTGDTA(*JOBD)                        /*S01493*/ /*081177*/
/**********  SBMJOB     JOB(EDC0040) JOBD(EDJOBD) JOBQ(EDJOBQ) +
/**********               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
/**********               EDC0040') INLLIBL(*JOBD)         /*081177*/ /*101971*/
/**********  SBMJOB     JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(EDJOBQ) +    /*CED007*/
/**********               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +    /*CED007*/
/**********               EDC0040') INLLIBL(*JOBD)          /*101971    CED007*/
/************SBMJOB     JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(INTERFACE) +                     /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             EDC0040') INLLIBL(*JOBD)                    /*CED007*/          /*CSC023*/
             SBMJOB     JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(INTERFACE) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          EDC0040') INLLIBL(*JOBD) OUTQ(*JOBD)                            /*CSC023*/
 EDLABL:                                                              /*S01493*/
             ENDDO                                                    /*S01493*/
                                                                                          /*CSD015*/
/** Check if Compliance Watch - Watch List Checking is installed */                       /*CSD015*/
                                                                                          /*CSD015*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSD015*/
             CHGVAR     VAR(&PSARD) VALUE('CSD015')                                       /*CSD015*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CSD015*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &DSFDY)                   /*CSD015*/
                                                                                          /*CSD015*/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSD015) VALUE('Y'))                                        /*CSD015*/
                                                                                          /*CSD015*/
/** Check if Midas Message Manager is installed */                                        /*CSD015*/
                                                                                          /*CSD015*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSD015*/
             CHGVAR     VAR(&PSARD) VALUE('CSW025')                                       /*CSD015*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CSD015*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD &DSFDY)                   /*CSD015*/
                                                                                          /*CSD015*/
             IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSW025) VALUE('Y'))                                        /*CSD015*/
                                                                                          /*CSD015*/
/** Retrieve current system prefix */                                                     /*CSD015*/
                                                                                          /*CSD015*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRELIB)                              /*CSD015*/
                                                                                          /*CSD015*/
/** Retrieve main system prefix */                                                        /*CSD015*/
                                                                                          /*CSD015*/
             IF         COND(&CSC011 *EQ 'Y') THEN(DO)                                    /*CSD015*/
                RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&PREMAIN)                          /*CSD015*/
             ENDDO                                                                        /*CSD015*/
                                                                                          /*CSD015*/
/** If compliance watch is installed */                                                   /*CSD015*/
                                                                                          /*CSD015*/
             IF         COND(&CSD015 *EQ 'Y') THEN(DO)                                    /*CSD015*/
                                                                                          /*CSD015*/
               IF         COND((&CSC011 *NE 'Y') *OR (&CSC011 *EQ 'Y' *AND +
                            &PRELIB *EQ &PREMAIN)) THEN(DO)                               /*CSD015*/
                                                                                          /*CSD015*/
/** Access compliance watch configuration file */                                         /*CSD015*/
                                                                                          /*CSD015*/
               CHGVAR     VAR(&PRTCD) VALUE('       ')                                    /*CSD015*/
               CHGVAR     VAR(&POPTN) VALUE('*FIRST')                                     /*CSD015*/
               CALL       PGM(AOCWCDR0) PARM(&PRTCD &POPTN &DSSDY)                        /*CSD015*/
                                                                                          /*CSD015*/
               CHGVAR     VAR(&W1OFSR) VALUE(%SUBSTRING(&DSSDY 54 32))                    /*CSD015*/
                                                                                          /*CSD015*/
/** If OFAC-Agent server ID is blank or no record exists */                               /*CSD015*/
                                                                                          /*CSD015*/
                 IF         COND((&PRTCD *EQ '*EMPTY') *OR +
                              (&W1OFSR *EQ ' ')) THEN(SNDPGMMSG +
                                 MSG('SCMINIT - Attempt to start +
                                   the Compliance Watch OFAC-AGENT +
                                   Server and Compliance Watch List +
                                   Engine has failed. Cause: OFAC-AGENT +
                                   Server ID is not yet defined') +
                                   TOMSGQ(MOPERQ))                                        /*CSD015*/
                                                                                          /*CSD015*/
                 ELSE (DO)                                                                /*CSD015*/
                                                                                          /*CSD015*/
                   CHGVAR     VAR(&RTCD) VALUE('       ')                                 /*CSD083*/
                   CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSD083' +
                              &FMT)                                                       /*CSD083*/
                   IF         COND(&RTCD *EQ '       ') THEN(DO)                          /*CSD083*/
                   CHGVAR     VAR(&CSD083) VALUE('Y')                                     /*CSD083*/
                   GOTO       CMDLBL(ECHECK)                                              /*CSD083*/
                   ENDDO                                                                  /*CSD083*/
                                                                                          /*CSD083*/
                   ALCOBJ     OBJ((COMPWTCH *DTAARA *EXCL)) WAIT(1)                       /*CSD015*/
                   MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(EWATCH))                    /*CSD015*/
                   DLCOBJ     OBJ((COMPWTCH *DTAARA *EXCL))                               /*CSD015*/
/************      SBMJOB     CMD(CALL PGM(SDFOFSRV) PARM(&PRELIB +                       /*CSC023*/
/************                   &W1OFSR)) JOB(COMPWATCH) JOBD(MBATCH) +                   /*CSC023*/
/************                   JOBQ(INTERFACE) USER(*JOBD) RTGDTA(*JOBD) +               /*CSC023*/
/************                   INLLIBL(*JOBD) ALWMLTTHD(*YES)                 /*CSD015*/ /*CSC023*/
                   SBMJOB     CMD(CALL PGM(SDFOFSRV) PARM(&PRELIB +
                                &W1OFSR)) JOB(COMPWATCH) JOBD(MBATCH) +
                                JOBQ(INTERFACE) USER(*JOBD) RTGDTA(*JOBD) +
                                INLLIBL(*JOBD) ALWMLTTHD(*YES) OUTQ(*JOBD)                /*CSC023*/
                                                                                          /*CSD015*/
 EWATCH:                                                                                  /*CSD015*/
                   ALCOBJ     OBJ((SDWLENGN *DTAARA *EXCL)) WAIT(1)                       /*CSD015*/
                   MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ECHECK))                    /*CSD015*/
                   DLCOBJ     OBJ((SDWLENGN *DTAARA *EXCL))                               /*CSD015*/
/************      SBMJOB     CMD(CALL PGM(SDCWENGN)) JOB(CWLCHECK) +                     /*CSC023*/
/************                   JOBD(MBATCH) JOBQ(INTERFACE) USER(*JOBD) +                /*CSC023*/
/************                   RTGDTA(*JOBD) INLLIBL(*JOBD)                   /*CSD015*/ /*CSC023*/
                                                                                          /*CSD015*/
                   SBMJOB     CMD(CALL PGM(SDCWENGN)) JOB(CWLCHECK) +
                                JOBD(MBATCH) JOBQ(INTERFACE) USER(*JOBD) +
                                RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                  /*CSC023*/
                                                                                          /*CSD015*/
 ECHECK:                                                                                  /*CSD015*/
                   ALCOBJ     OBJ((SDWLMENG *DTAARA *EXCL)) WAIT(1)                       /*CSD015*/
                   MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ELMENG))                    /*CSD015*/
                   DLCOBJ     OBJ((SDWLMENG *DTAARA *EXCL))                               /*CSD015*/
/************      SBMJOB     CMD(CALL PGM(SDCWMENG)) JOB(CWLMENG) +                      /*CSC023*/
/************                   JOBD(MBATCH) JOBQ(INTERFACE) USER(*JOBD) +                /*CSC023*/
/************                   RTGDTA(*JOBD) INLLIBL(*JOBD)                   /*CSD015*/ /*CSC023*/
                                                                                          /*CSD015*/
                   SBMJOB     CMD(CALL PGM(SDCWMENG)) JOB(CWLMENG) +
                                JOBD(MBATCH) JOBQ(INTERFACE) USER(*JOBD) +
                                RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)                  /*CSC023*/
                                                                                          /*CSD015*/
 ELMENG:                                                                                  /*CSD015*/
                   IF COND(&CSW025 *EQ 'N') THEN(DO)                                      /*CSD015*/
                      ALCOBJ     OBJ((SDWLSENG *DTAARA *EXCL)) WAIT(1)                    /*CSD015*/
                      MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ELSENG))                 /*CSD015*/
                      DLCOBJ     OBJ((SDWLSENG *DTAARA *EXCL))                            /*CSD015*/
/************         SBMJOB     CMD(CALL PGM(SDCWSENG)) JOB(CWLSENG) +                   /*CSC023*/
/************                      JOBD(MBATCH) JOBQ(INTERFACE) +                         /*CSC023*/
/************                      RTGDTA(*JOBD) INLLIBL(*JOBD)                /*CSD015*/ /*CSC023*/
                      SBMJOB     CMD(CALL PGM(SDCWSENG)) JOB(CWLSENG) +
                                   JOBD(MBATCH) JOBQ(INTERFACE) +
                                   RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)               /*CSC023*/
                   ENDDO                                                                  /*CSD015*/
                                                                                          /*CSD015*/
 ELSENG:                                                                                  /*CSD015*/
                 ENDDO                                                                    /*CSD015*/
                                                                                          /*CSD015*/
               ENDDO                                                                      /*CSD015*/
                                                                                          /*CSD015*/
             ENDDO                                                                        /*CSD015*/
                                                                                          /*CSD015*/
                                                                                          /*CSD083*/
             IF         COND(&CSD083 *EQ 'Y') THEN(DO)                                    /*CSD083*/
             CALL       PGM(SDC000904)                                                    /*CSD083*/
             ENDDO                                                                        /*CSD083*/
                                                                                          /*CSD083*/
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
 
             ENDDO
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
                          &FMT)                                                           /*CGL013*/
             IF         (&RTCD *EQ '       ') +
                 CALL       PGM(GLC001410) PARM('*START' ' ' ' ')                         /*CGL013*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,SCMINITMPE                                   */      /*S01408*/
/**/                                                                  /*S01408*/
             GOTO       CMDLBL(ENDCLPGM)
/*                                                                   */
ABEND:
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             GOTO       ENDCLPGM
/*                                                                          */
ABNORMAL:
/*           An abnormal message has been issued and to prevent      */
/*           further errors  being  sent to the ABNORMAL tag by      */
/*           the general MONMSG command  in  the  first line of      */
/*           executable code each of the  following  lines  are      */
/*           individually  monitored  to  prevent  any  further      */
/*           errors which may occur from causing looping.            */
/*                                                                   */
             SNDPGMMSG  TOMSGQ(&JOB) MSG('PROGRAM SCMINIT ENDED +
                                                    ABNORMALLY')
             MONMSG     MSGID(CPF0000 MCH0000)
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCVMSG     MSGQ(MSPECIAL) /*REMOVE INIT*/
             MONMSG     MSGID(CPF0000 MCH0000)
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
             MONMSG     MSGID(CPF0000 MCH0000)
                                                                                          /*243665*/
/* Set MPHAS back to its previous value                 */                                /*243665*/
                                                                                          /*243665*/
             CHGDTAARA  DTAARA(MPHAS) VALUE(&MPHAS)                                       /*243665*/
             CHGVAR     VAR(&TEXT) VALUE('MPHAS changed to ' *CAT +
                          &MPHAS *CAT ' on input cycle reopen failure')                   /*243665*/
             SCWRTJREG  EVENT(MPHAS) FLAG(R) TEXT(&TEXT)                                  /*243665*/
                                                                                          /*243665*/
/* IF ATTEMPT TO REOPEN INPUT CYCLE IS NOT FROM COB                   /*S01189*/
/* AND FAILS, SIGN OFF FROM SYSTEM                                    /*S01189*/
             RTVDTAARA  DTAARA(CBSTAT (32 1)) RTNVAR(&REOPFL)         /*S01189*/
/************IF         COND((&REOPFL *EQ 'N') *AND (&PRM01 *NE +
/************             'SDC07')) THEN(DO)               /*S01189*/ /*S01343*/
/**********  IF         COND((&REOPFL *EQ 'N') *AND (&PRM01 *NE +
/**********               'SCC07')) THEN(DO)               /*S01343*/ /*S01420*/
             IF         COND(((&REOPFL *EQ 'N') *AND (&PRM01 *NE +
                          'SCC07')) *OR ((&REOPFL *EQ 'N') *AND +
                          (&PRM01 *NE 'SCC0700'))) THEN(DO)           /*S01420*/
/*                                                                    /*S01189*/
/*                                                                  */
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO                                                    /*S01189*/
/* RETURN TO CALLING PROGRAM IF FAILS WHEN CALLED FROM COB            /*S01189*/
             RETURN                                                   /*S01189*/
/*                                                                    /*S01189*/
/*                                                                            */
 ENDCLPGM:
/************SNDPGMMSG  MSG(MIDAS) TOMSGQ(MSTATUS)                                     */ /*CPK017*/
             ALCOBJ     OBJ((MSPECIAL *MSGQ *EXCL)) WAIT(9999)
             CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)
             RCVMSG     MSGQ(MSPECIAL)
                                                                      /*S01189*/
/* IF MORE THAN ONE MIDAS MESSAGE ON MSTATUS AND REPLY             */ /*S01189*/
/* OPTION TAKEN IS N THEN BYPASS END PROCESSING AND RETURN         */ /*S01189*/
             IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(GOTO CMDLBL(RETURN))                   /*S01189*/
/**/                                                                  /*S01189*/
/* IF ATTEMPT TO REOPEN INPUT CYCLE FROM COB IS SUCCESSFUL            /*S01189*/
/* UPDATE DATA AREA CBSTAT, SEND MESSAGES TO DATA QUEUES              /*S01189*/
/* CBDTQA AND CBDTQC TO CANCEL THE SCHEDULER, RESET DATA              /*S01189*/
/* AREA SDSTAT, CLEAR THE FILES USED FOR THE AUDIT                    /*S01189*/
/* REPORT AND REROUTE THE JOB TO MIDASIC                              /*S01189*/
/************IF         COND((&PRM01 *EQ 'SDC07') *AND (&ERROR *EQ +
/************             '0')) THEN(DO)                   /*S01189*/ /*S01343*/
/**********  IF         COND((&PRM01 *EQ 'SCC07') *AND (&ERROR *EQ +
/**********               '0')) THEN(DO)                   /*S01343*/ /*S01420*/
             IF         COND(((&PRM01 *EQ 'SCC07') *AND (&ERROR *EQ +
                          '0')) *OR ((&PRM01 *EQ 'SCC0700') *AND +
                          (&ERROR *EQ '0'))) THEN(DO)                 /*S01420*/
                        CHGDTAARA  DTAARA(CBSTAT (14 3)) VALUE('000') /*S01189*/
                        CHGDTAARA  DTAARA(CBSTAT (17 1)) VALUE('N')   /*S01189*/
                        CHGDTAARA  DTAARA(CBSTAT (20 1)) VALUE('N')   /*S01189*/
                        CHGDTAARA  DTAARA(CBSTAT (21 11)) VALUE(' ')  /*S01189*/
                        CHGDTAARA  DTAARA(CBSTAT (32 1)) VALUE('N')   /*S01189*/
                        CHGDTAARA  DTAARA(CBSTAT (45 1)) VALUE('N')   /*S01189*/
                        CHGDTAARA  DTAARA(SDSTAT (50 1)) VALUE('C')   /*178120*/
                        CHGDTAARA  DTAARA(SDSTAT (110 5)) VALUE('BEGIN') +
                                                                                          /*CGP002*/
/* Update global dashboard */                                                             /*CGP002*/
                                                                                          /*CGP002*/
             CALL       PGM(GOC000100) PARM('*PHASE')                                     /*CGP002*/
                                                                                          /*CGP002*/
/************                                                                  /*S01189*/ /*CPK014*/
/************           RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRELIB)  +                /*CPK014*/
/************                                                                  /*S01189*/ /*CPK014*/
/************           CHGVAR     VAR(%SST(&DTAQLIB 1 2)) VALUE(&PRELIB) +               /*CPK014*/
/************                                                                  /*S01189*/ /*CPK014*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCMINITMP1                                          */
                                                                      /*S01408*/
/************           CALL    QSNDDTAQ PARM('CBDTQA    ' &DTAQLIB +                     /*CPK014*/
/************                      &DTQALEN &MSGA)                             /*S01189*/ /*CPK014*/
/************           CALL    QSNDDTAQ PARM('CBDTQC    ' &DTAQLIB +                     /*CPK014*/
/************                      &DTQCLEN &MSGC)                             /*S01189*/ /*CPK014*/
                        CALL       PGM(QSNDDTAQ) PARM('CBDTQA    ' '*LIBL     ' +
                                     &DTQALEN &MSGA)                                      /*CPK014*/
                        CALL       PGM(QSNDDTAQ) PARM('CBDTQC    ' '*LIBL     ' +
                                     &DTQCLEN &MSGC)                                      /*CPK014*/
                                                                                          /*243665*/
 /* If CoB files cannot be cleared, do not go to abnor.  They will */                     /*243665*/
 /* get cleared at the beginning of the next CoB anyway.          */                      /*243665*/
                                                                                          /*243665*/
                        CLRPFM  FILE(CBAUDTPD)                        /*S01189*/
                        MONMSG     MSGID(CPF0000)                                         /*243665*/
                        CLRPFM  FILE(CBHALTPD)                        /*S01189*/
                        MONMSG     MSGID(CPF0000)                                         /*243665*/
                        CLRPFM  FILE(CBMESGPD)                        /*S01189*/
                        MONMSG     MSGID(CPF0000)                                         /*243665*/
/**REMOVE*'MIDAS'*FROM*MSTATUS,*ANOTHER*WILL*BE SENT*BY*MIPGM*/ /*                     */ /*S01189*/
/************           RCVMSG     MSGQ(MSTATUS) RMV(*YES)                  */ /*S01189*/ /*CPK017*/
/****************                                                 S01117LN0017*/
/**TERMINATE*REPORT DISTRIBUTION PROGRAM                          S01117LN0017*/
/****************                                                 S01117LN0017*/
/****************       CALL       PGM(QSNDDTAQ) PARM('FCDTAQ' '*LIBL' +
/****************                         &DTQDLEN &T)            S01117LN0017*/
/*DISTLP:********         ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) +
/****************                                     WAIT(30)    S01117LN0017*/
/****************       MONMSG     MSGID(CPF1002) +
/****************                   EXEC(GOTO CMDLBL(DISTLP))     S01117LN0017*/
/****************       DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))    S01117LN0017*/
/****************                                                 S01117LN0017*/
                                                                                          /*CSC011*/
             IF         COND(&CSC011 *EQ 'Y') THEN(DO)                                    /*CSC011*/
                DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))                                    /*CSC011*/
                CALL       PGM(SCC004340)                                                 /*CSC011*/
                                                                                          /*CSC011*/
/** Database Error Processing */                                                          /*CSC011*/
                                                                                          /*CSC011*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                           CMDLBL(ABNORMAL))                                              /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
                        RRTJOB     RTGDTA(MIDASIC)                    /*S01189*/
                        ENDDO                                         /*S01189*/
/**/                                                                  /*S01189*/
             DLCOBJ     OBJ((MSPECIAL *MSGQ *EXCL))
/************RETURN****************************************************E14071*/
RETURN:      RETURN                                                  /*E14071*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM     /* END CL PGM */
/********************************************************************/
