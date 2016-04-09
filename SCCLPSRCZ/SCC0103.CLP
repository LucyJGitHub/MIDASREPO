/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Start up input cycle monitor jobs')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SCC0103 - Start Up Input Cycle Background Jobs.             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CSD083             Date 27May10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 22May08              */
/*                      253716 (BUG17735)  Date 07Apr08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      222468             Date 06Jun06              */
/*                      225286             Date 17Mar04              */
/*                      BUG2381            Date 13May04              */
/*                      CRE020             Date 20Jan04              */
/*                      CSC023             Date 02Feb04              */
/*                      CGP002             Date 04Jul03              */
/*                      CRE008             Date 19Feb02              */
/*                      CSE039             Date 18MAR03              */
/*                      CSD015             Date 03Mar03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      203561             Date 21Jun02              */
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/*                      196358             Date 26Jun01              */
/*                      193083             Date 02Jul01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CSD006             Date 01Jun01              */
/*                      CTI003             DATE 12Sep00              */
/*                      CCM003             Date 27Mar01              */
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      CRT004             Date 12May00              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      166101             Date  7JUN00              */
/*                      CDE001             Date 15Nov99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CGL009             Date 18Mar99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTI001             Date 01Sep97              */
/*                      CGL004             Date 03Nov97              */
/*                      CED007             DATE 03NOV97              */
/*                      115624             DATE 23SEP97              */
/*                      110242             DATE 07NOV96              */
/*                      S01408             DATE 08AUG96              */
/*                      101971             DATE 15MAY96              */
/*                      S01408             DATE 01APR96              */
/*                      CCM002             DATE 04SEP95              */
/*                      076725             DATE 25OCT94              */
/*                      S01493             DATE 01JUN94              */
/*                      S01463             DATE 20JAN94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSD083 - Watch List Compliance Upgrade                      */
/*       BG18886 - Amend non-standard codes.                         */
/*       253716 - Deallocate data area only after the program/job    */
/*                has already been called/submitted. Applu fix 230530*/
/*                BUG17735                                           */
/*       222468 - The deallocation of EMCHK should not be dependent  */
/*                upon data area EMSTAT having 'N' in position 2.    */
/*                The result is that a job can allocate EMCHK        */
/*                without submitting the EM jobs and continue to     */
/*                allocate the data area preventing other jobs       */
/*                from submitting the EM batch jobs.                 */
/*       225286 - Back out 193083 from this program as no longer     */
/*                want a user logging on to trigger the submission   */
/*                of the batch jobs                                  */
/*       BUG2381 - Batch submit of confirmations programs            */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CGP002 - Add submission of MIDASSTS job.                    */
/*       CRE008 - Cash Management                                    */
/*       CSE039 - Automatic Trades Settlement - Submit job           */
/*       CSD015 - Midas Compliance Watch - Watch List Checking       */
/*       203561 - Parameters for LEC2010 have changed                */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*                - Move the JRNMONITOR submit to the 'TP' code.     */
/*                  - Remove switchability and 5 second delay.       */
/*       196358 - Submit jounal receiver size monitor.               */
/*       193083 - Ensure Lending PC Interface jobs submitted if      */
/*                Loan Manager switched on (CLE010)                  */
/*       CSD006 - Market Data Feeds                                  */
/*       CTI003 - Midas/TI Interface CoB changes.  If user signs on  */
/*                to system but Midas/TI Interface CoB is active     */
/*                then do not submit background jobs.                */
/*       CCM003 - Condition DL0003 on CCM003.                        */
/*       CRT004 - Cashier Midas TCP/IP interface.                    */
/*       166101 - Submit RCFMONITOR with USER(*JOBD)                 */
/*       CDE001 - Data Export - CCRM Limits                          */
/*       CGL009 - Midas-Fontis Inter-Account Transfers (IAT) and     */
/*                Third Party Payments (TPP) Interface               */
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*       CGL004 - Midas-Fontis Interface, add submission of          */
/*                Background job.                                    */
/*       CED007 - ED enhancements, change JOBQ for submission of     */
/*                EDCONTROL.                                         */
/*       115624 - Problem due to files being locked by 2nd RCF       */
/*                Monitor job. Amend to allow only one RCF Monitor to*/
/*                be submitted.                                      */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       S01408 - Addition of core hook SCC0103001                   */
/*       101971 - Change name of EDC0040 job to                      */
/*                descriptive EDCONTROL                              */
/*       S01408 - Addition of core hook SCC0103INT                   */
/*                Addition of core hook SCC0103MPS                   */
/*                Addition of core hook SCC0103MPE                   */
/*                Addition of core hook SCC0103ERR                   */
/*                Addition of core hook SCC0103END                   */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI).      */
/*                If the parameter passed is set to 'CD', submit the */
/*                Citydealer Interface background jobs.              */
/*       076725 - Add a new routing entry for HAF to allow us        */
/*                to define via the JOBD:                            */
/*                - A job priority for HAFMONITOR.                   */
/*                - A compare value.                                 */
/*       S01493 - Midas-Export Data module - ADD SUBMISSION          */
/*                - Add submission of the 'Drip Feed' job.           */
/*       S01463 - New program to allow the Midas initial program     */
/*                processing to be updated without the need to       */
/*                change the subsystem routing entries.              */
/*                                                                   */
/*              - This program contains a very small part of the     */
/*                processing that used to be performed by MIPGM.     */
/*                The bulk of the MIPGM processing has been moved    */
/*                to a new program called SCC0102.                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODULE)
 
/*/COPY WNCPYSRC,SCC0103INT                                        */ /*S01408*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&HAFFMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&HAFRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&HAFOPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*FIRST ')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&EMSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CDSTAT) TYPE(*CHAR) LEN(27)              /*CCM002*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CGL004*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CGL004*/
             DCL        VAR(&FIRSTRUN) TYPE(*CHAR) LEN(1)             /*CTI001*/
             DCL        VAR(&CGL009) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CGL009*/
             DCL        VAR(&CSD006) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CSD006*/
             DCL        VAR(&CCM003) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CCM003*/
             DCL        VAR(&TIC0050) TYPE(*CHAR) LEN(1)                                  /*CTI003*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSD015*/
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD015*/
/*                                                                                        /*196358*/
/* Declare variable CCB009 - flag for permanent journaling.                               /*196358*/
/*                                                                                        /*196358*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                                   /*196358*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                                  /*196358*/
                                                                                          /*CSC011*/
/** Define work variables for CSC011 */                                                   /*CSC011*/
                                                                                          /*CSC011*/
             DCL        VAR(&BKJOBRUN) TYPE(*CHAR) LEN(1) VALUE('Y')                      /*CSC011*/
             DCL        VAR(&CURR) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(2)                                     /*CSC011*/
             DCL        VAR(&MAIN) TYPE(*CHAR) LEN(2)                                     /*CSD015*/
             DCL        VAR(&SWMD) TYPE(*CHAR) LEN(1)                                     /*CSD015*/
             DCL        VAR(&W1OFSR) TYPE(*CHAR) LEN(32)                                  /*CSD015*/
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)                                  /*CSD015*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CRE020*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,SCC0103MPS                                        */ /*S01408*/
 
                                                                                          /*CSC011*/
/** Check if 24x7 Midas Availability Feature is on */                                     /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSC011' +
                          '&FMT')                                                         /*CSC011*/
                                                                                          /*CSC011*/
/** If CSC011 is installed, check if current system is support */                         /*CSC011*/
/** system. If yes, not all background jobs should run in the  */                         /*CSC011*/
/** support system.                                            */                         /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSC011*/
                CHGVAR     VAR(&CSC011) VALUE('Y')                                        /*CSD015*/
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)                             /*CSC011*/
                RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&SUPP)                             /*CSC011*/
                RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&MAIN)                             /*CSD015*/
                RTVDTAARA  DTAARA(SC24X7 (10 1)) RTNVAR(&SWMD)                            /*CSD015*/
                IF         COND(&CURR *EQ &SUPP) THEN(DO)                                 /*CSC011*/
                   CHGVAR     VAR(&BKJOBRUN) VALUE('N')                                   /*CSC011*/
                ENDDO                                                                     /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/* If this is the main Midas system then submit the MIDASSTS job */                       /*CGP002*/
                                                                                          /*CGP002*/
             IF         COND((&CSC011 *NE 'Y') *OR ((&CSC011 *EQ +
                          'Y') *AND (&CURR *EQ &MAIN))) THEN(DO)                          /*CGP002*/
                CALL       PGM(GOC000101) PARM('*MONITOR')                                /*CGP002*/
             ENDDO                                                                        /*CGP002*/
                                                                                          /*CGP002*/
             IF         COND(&MODULE *EQ 'TI') THEN(DO)               /*CTI001*/
                                                                      /*CTI001*/
/* If this is the first time the TI module is installed don't */      /*CTI001*/
/* call TIC0050 */                                                    /*CTI001*/
/* - or if Midas/TI CoB phase is not pending then do not call TIC0050 */                  /*CTI003*/
             RTVDTAARA  DTAARA(TIDTA (31 1)) RTNVAR(&FIRSTRUN)        /*CTI001*/
             RTVDTAARA  DTAARA(TIDTA (51 1)) RTNVAR(&TIC0050)                             /*CTI003*/
             IF         COND(&FIRSTRUN *EQ 'N') THEN(DO)              /*CTI001*/
/**********     IF         COND(&TIC0050 *EQ 'P') THEN(DO) */                  /*CTI003*/ /*CSC011*/
                IF   COND((&TIC0050 *EQ 'P') *AND (&BKJOBRUN *EQ +
                          'Y')) THEN(DO)                                                  /*CSC011*/
                                                                      /*CTI001*/
/* Submit the TI Midas background jobs                                  CTI001*/
                                                                      /*CTI001*/
             CALL       PGM(TIC0050) PARM('START')                    /*CTI001*/
/**********  IF         COND(*%SWITCH(XXXXXX00)) THEN(GOTO +         */       /*CTI001*/ /*BG18886*/
/**********               CMDLBL(ABNOR))                             */       /*CTI001*/ /*BG18886*/
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ABNOR)) /*BG18886*/
                                                                      /*CTI001*/
             ENDDO                                                                        /*CTI003*/
             ENDDO                                                    /*CTI001*/
             ELSE    CMD(CHGDTAARA DTAARA(TIDTA (31 1)) VALUE('N'))   /*CTI001*/
             ENDDO                                                    /*CTI001*/
                                                                      /*CTI001*/
/**Submit*Lending*PC*Interface*jobs*if*CLE010*is*switched*on**/                /*193083*/ /*225286*/
                                                                               /*193083*/ /*225286*/
/**********  IF         COND(&MODULE *EQ 'LE') THEN(DO)              */        /*193083*/ /*225286*/
/**********     CHGVAR     VAR(&RTCD) VALUE('       ')               */        /*193083*/ /*225286*/
/**********     CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                           'CLE010' &FMT)                            */        /*193083*/ /*225286*/
/**********     IF         COND(&RTCD *EQ '       ') THEN(CALL +
/**********                PGM(LEC2010) PARM('N'))                   */        /*193083*/ /*203561*/
/**********     IF         COND(&RTCD *EQ '       ') THEN(DO)        */        /*203561*/ /*225286*/
/**********        CALL       PGM(LEC2010) PARM('ALL' '   ')         */        /*203561*/ /*225286*/
/**********        CALL       PGM(LEC2012)                           */        /*203561*/ /*225286*/
/**********     ENDDO                                                */        /*203561*/ /*225286*/
/**********  ENDDO                                                   */        /*193083*/ /*225286*/
                                                                                          /*193083*/
/* Submit Agency Trade Settlement job if CSE039 is on */          /*CSE039*/
                                                                  /*CSE039*/
             IF         COND(&MODULE *EQ 'SE') THEN(DO)           /*CSE039*/
                CHGVAR     VAR(&RTCD) VALUE('       ')            /*CSE039*/
                CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' +
                           'CSE039' &FMT)                         /*CSE039*/
                IF         COND(&RTCD *EQ '       ') THEN(CALL +
                           PGM(SEC4320))                          /*CSE039*/
             ENDDO                                                /*CSE039*/
 
/* Submit the Exposure Management background jobs */
 
             IF         COND(&MODULE *EQ 'EM') THEN(DO)
/*/COPY WNCPYSRC,SCC0103003                                          */
 
/* Retrieve various module status data areas */
 
                RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)
 
                ALCOBJ     OBJ((EMCHK *DTAARA *EXCL)) WAIT(1)
                MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP1))
 
                IF         COND(%SUBSTRING(&EMSTAT 2 1) *EQ 'N') +
                             THEN(DO)
 
/* Submit the Exposure Management journal processing job */
 
/*************    SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +  /*110242*/
/*************                 USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +*110242*/
/*************                 EMC02') MSGQ(*NONE) */                 /*110242*/
/************     SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +                      /*CSC023*/
/************                  USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                   /*CSC023*/
/************                  EMC02') INLLIBL(*JOBD) MSGQ(*NONE)     /*110242*/          /*CSC023*/
                  SBMJOB     JOB(EM0101) JOBD(MBATCH) JOBQ(EMJOBQ) +
                               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                               EMC02') INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)             /*CSC023*/
 
/* Submit the Exposure Management clearup processing job */
 
/*************    SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +   /*110242*/
/*************                 USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +*110242*/
/*************                 EMCLR') MSGQ(*NONE) */                 /*110242*/
/************     SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +                       /*CSC023*/
/************                  USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                   /*CSC023*/
/************                  EMCLR') INLLIBL(*JOBD) MSGQ(*NONE)     /*110242*/          /*CSC023*/
                  SBMJOB     JOB(EMCLR) JOBD(MBATCH) JOBQ(EMJOBQ) +
                               USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                               EMCLR') INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)             /*CSC023*/
 
                  CHGDTAARA  DTAARA(EMSTAT (2 1)) VALUE('Y')
 
                  DLCOBJ     OBJ((EMCHK *DTAARA *EXCL))
 SKIP1:
                ENDDO
                DLCOBJ     OBJ((EMCHK *DTAARA *EXCL))                                     /*222468*/
                MONMSG     MSGID(CPF0000)                                                 /*222468*/
             ENDDO
                                                                      /*S01408*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/***Check*for Switchable feature CCB009.                          */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +    */           /*196358*/ /*CPK014*/
/**********               'CCB009' &AOFMT)                        */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**If*Feature CCB009 is 'on' (permanent journaling),              */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)      */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**try*to*allocate data area SCJRNLOCK.                           */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**********  ALCOBJ     OBJ((SCJRNLOCK *DTAARA *EXCL)) WAIT(1)    */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**If*not*allocated, then journal size monitor is active.         */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**********  MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP2))   */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**Otherwise submit the journal size monitor job.                 */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**********  SBMJOB     CMD(CALL PGM(SCC2470)) JOB(JRNMONITOR) +  */           /*196358*/ /*CPK014*/
/**********               JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +  */           /*196358*/ /*CPK014*/
/**********               RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(*NONE)*/           /*196358*/ /*CPK014*/
/**********  DLCOBJ     OBJ((SCJRNLOCK *DTAARA *EXCL))            */           /*196358*/ /*CPK014*/
/**********  DLYJOB     DLY(5)                                    */           /*196358*/ /*CPK014*/
/*SKIP2:*****                                                     */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/**********  ENDDO                                                */           /*196358*/ /*CPK014*/
/**********                                                       */           /*196358*/ /*CPK014*/
/*/COPY WNCPYSRC,SCC0103001                                        */ /*S01408*/
                                                                      /*S01408*/
/**/                                                                  /*CCM003*/
/*    Check if Midas/City Dealer interface is active (CCM003)         /*CCM003*/
/**/                                                                  /*CCM003*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CCM003*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CCM003' +
                          &FMT)                                       /*CCM003*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CCM003) VALUE('Y'))                    /*CCM003*/
/**/                                                                  /*CRT004*/
/*    Check if Cashier TCP/IP Interface (CRT004) is active            /*CRT004*/
/**/                                                                  /*CRT004*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CRT004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CRT004' +
                          &FMT)                                       /*CRT004*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(CALL + */                          /*CSC011*/
/**********               PGM(REC4510) PARM('START'))         */               /*CRT004*/ /*CSC011*/
             IF         COND((&RTCD *EQ '       ') *AND (&BKJOBRUN +
                          *EQ 'Y')) THEN(CALL PGM(REC4510) +
                          PARM('START'))                                                  /*CSC011*/
 
/* Submit the Midas Export Data Drip Feed Background job               *S01493*/
 
/**********  IF         COND(&MODULE *EQ 'ED') THEN(DO) */                     /*S01493*/ /*CSC011*/
             IF         COND((&MODULE *EQ 'ED') *AND (&BKJOBRUN *EQ +
                          'Y')) THEN(DO)                                                  /*CSC011*/
 
             ALCOBJ   OBJ((EDC0040 *DTAARA *EXCL)) WAIT(1)            /*S01493*/
             MONMSG   MSGID(CPF1002) EXEC(GOTO CMDLBL(EDLABL))        /*S01493*/
             DLCOBJ   OBJ((EDC0040 *DTAARA *EXCL))                    /*S01493*/
/**********  SBMJOB   JOB(EDC0040) JOBD(EDJOBD) USER(*JOBD) +
/**********           JOBQ(EDJOBQ) RQSDTA('CALL EDC0040')   +
/**********           RTGDTA(*JOBD)                        /*S01493*/ /*101971*/
/************SBMJOB   JOB(EDCONTROL) JOBD(EDJOBD) USER(*JOBD) +       /*110242*/
/*************        JOBQ(EDJOBQ) RQSDTA('CALL EDC0040')   +         /*110242*/
/*************        RTGDTA(*JOBD) */                        /*101971  110242*/
/************SBMJOB   JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(EDJOBQ) +      /*CED007*/
/*************        USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +        /*CED007*/
/*************        EDC0040') INLLIBL(*JOBD)               /*110242   CED007*/
/************SBMJOB   JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(INTERFACE) +                       /*CSC023*/
/************         USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                            /*CSC023*/
/************         EDC0040') INLLIBL(*JOBD)                        /*CED007*/          /*CSC023*/
             SBMJOB   JOB(EDCONTROL) JOBD(EDJOBD) JOBQ(INTERFACE) +
                      USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                      EDC0040') INLLIBL(*JOBD) OUTQ(*JOBD)                                /*CSC023*/
 EDLABL:                                                              /*S01493*/
             ENDDO
                                                                      /*CGL004*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL004' +
                          &FMT)                                       /*CGL004*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(DO) */                  /*CGL004*/ /*CSC011*/
             IF         COND((&RTCD *EQ '       ') *AND (&BKJOBRUN +
                          *EQ 'Y')) THEN(DO)                                              /*CSC011*/
             ALCOBJ     OBJ((GLFONTDA *DTAARA *EXCL)) WAIT(1)         /*CGL004*/
             MONMSG   MSGID(CPF1002) EXEC(GOTO CMDLBL(CGLABL))        /*CGL004*/
/**********  DLCOBJ   OBJ((GLFONTDA *DTAARA *EXCL))                 */             /*CGL004 253716*/
             CALL       PGM(GLC2817) PARM(' ' ' ' '*START' ' ' ' ')   /*CGL004*/
             DLCOBJ   OBJ((GLFONTDA *DTAARA *EXCL))                                       /*253716*/
CGLABL:                                                               /*CGL004*/
             ENDDO                                                    /*CGL004*/
/**/                                                                  /*CGL009*/
/*    Check if Fontis IAT/TPP Interface (CGL009) is active            /*CGL009*/
/**/                                                                  /*CGL009*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CGL009*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CGL009' +
                          &FMT)                                       /*CGL009*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CGL009) VALUE('Y'))                    /*CGL009*/
                                                                      /*CGL009*/
/**********  IF         COND(&CGL009 *EQ 'Y') THEN(DO) */                      /*CGL009*/ /*CSC011*/
             IF         COND((&CGL009 *EQ 'Y') *AND (&BKJOBRUN *EQ +
                          'Y')) THEN(DO)                                                  /*CSC011*/
             ALCOBJ     OBJ((GLFIATDA *DTAARA *EXCL)) WAIT(10)        /*CGL009*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(TPPLBL))      /*CGL009*/
 /********** DLCOBJ     OBJ((GLFIATDA *DTAARA *EXCL))           */                 /*CGL009 253716*/
             CALL       PGM(GLC2822) PARM('*START' ' ' 'A' ' ')       /*CGL009*/
             DLCOBJ     OBJ((GLFIATDA *DTAARA *EXCL))                                     /*253716*/
                                                                      /*CGL009*/
 TPPLBL:     ALCOBJ     OBJ((MEFTPPDA *DTAARA *EXCL)) WAIT(10)        /*CGL009*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(FONEND))      /*CGL009*/
 /********** DLCOBJ     OBJ((MEFTPPDA *DTAARA *EXCL))           */                 /*CGL009 253716*/
             CHGDTAARA  DTAARA(MEFTPPDA (29 1)) VALUE(' ')            /*CGL009*/
             CALL       PGM(MEC2001) PARM('*START' ' ' 'A' ' ')       /*CGL009*/
             DLCOBJ     OBJ((MEFTPPDA *DTAARA *EXCL))                                     /*253716*/
                                                                      /*CGL009*/
 FONEND:     ENDDO                                                    /*CGL009*/
                                                                      /*CGL009*/
                                                                      /*CSD006*/
/**/                                                                  /*CSD006*/
/*    Check if Market Data Feed Switchable feature is on              /*CSD006*/
/**/                                                                  /*CSD006*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSD006*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSD006' +
                          &FMT)                                       /*CSD006*/
/* If CSD006 is on, SD Initiate Market Data Feed */                   /*CSD006*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSD006) VALUE('Y'))                    /*CSD006*/
/**********  IF         COND(&CSD006 *EQ 'Y') THEN(DO) */                      /*CSD006*/ /*CSC011*/
             IF         COND((&CSD006 *EQ 'Y') *AND (&BKJOBRUN *EQ +
                          'Y')) THEN(DO)                                                  /*CSC011*/
             ALCOBJ     OBJ((SDC1490 *DTAARA *EXCL)) WAIT(0)          /*CSD006*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(MDFEND))      /*CSD006*/
             DLCOBJ     OBJ((SDC1490 *DTAARA *EXCL))                  /*CSD006*/
             CALL       PGM(SDC1480)                                  /*CSD006*/
 MDFEND:     ENDDO                                                    /*CSD006*/
                                                                      /*CSD006*/
/**/                                                                  /*CCM002*/
/*    If the program module is 'CD', retrieve the values in           /*CCM002*/
/*    data area DLCDSTAT.                                             /*CCM002*/
/**/                                                                  /*CCM002*/
             IF         COND(&MODULE *EQ 'CD') THEN(DO)               /*CCM002*/
               RTVDTAARA  DTAARA(DLCDSTAT) RTNVAR(&CDSTAT)            /*CCM002*/
/**/                                                                  /*CCM002*/
/*    If 1st posn of &CDSTAT is not set to 'Y', submit the Citydealer /*CCM002*/
/*    Background jobs.                                                /*CCM002*/
/**/                                                                  /*CCM002*/
/**********    IF         COND(%SST(&CDSTAT 1 1) *NE 'Y') THEN(DO) */          /*CCM002*/ /*CSC011*/
               IF         COND((%SST(&CDSTAT 1 1) *NE 'Y') *AND +
                          (&BKJOBRUN *EQ 'Y')) THEN(DO)                                   /*CSC011*/
/*************   SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +  /*110242*/
/*************                RTGDTA(CITYD) RQSDTA('CALL DLC0002') +  /*110242*/
/*************                MSGQ(*NONE) */                  /*CCM002  110242*/
/*************   SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +   /*110242*/
/*************                RTGDTA(CITYD) RQSDTA('CALL DL0003') +   /*110242*/
/*************                MSGQ(*NONE) */                  /*CCM002  110242*/
/************    SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +                      /*CPK014*/
/************                 RTGDTA(CITYD) RQSDTA('CALL DLC0002') +                      /*CPK014*/
/************                 INLLIBL(*JOBD) MSGQ(*NONE)              /*110242*/          /*CPK014*/
/************    SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +                      /*CSC023*/
/************             USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +                        /*CSC023*/
/************             DLC0002') INLLIBL(*JOBD) MSGQ(*NONE)                 /*CPK014*/ /*CSC023*/
                 SBMJOB     JOB(DLC0002) JOBD(MBATCH) JOBQ(TSJOBQ) +
                          USER(*JOBD) RTGDTA(CITYD) RQSDTA('CALL +
                          DLC0002') INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                /*CSC023*/
             IF         COND(&CCM003 *EQ 'N') THEN(DO)                /*CCM003*/
/************    SBMJOB     JOB(DL0003) JOBD(MBATCH) JOBQ(TSJOBQ) +                       /*CPK014*/
/************                 RTGDTA(CITYD) RQSDTA('CALL DL0003') +                       /*CPK014*/
/************                 INLLIBL(*JOBD) MSGQ(*NONE)              /*110242*/          /*CPK014*/
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
/**/                                                                  /*CDE001*/
/*    If the program module is 'DE', call program to submit Data      /*CDE001*/
/*    Export background jobs.                                         /*CDE001*/
/**/                                                                  /*CDE001*/
/**********  IF         COND(&MODULE *EQ 'DE') +  */                                      /*CSC011*/
/**********               THEN(CALL PGM(DEC0004)) */                           /*CDE001*/ /*CSC011*/
             IF         COND((&MODULE *EQ 'DE') *AND (&BKJOBRUN *EQ +
                          'Y')) THEN(CALL PGM(DEC0004))                                   /*CSC011*/
/**/                                                                                      /*CRE008*/
/*    If the program module is 'CM', call programs to submit                              /*CRE008*/
/*    the Cash Management background jobs.                                                /*CRE008*/
/**/                                                                                      /*CRE008*/
             IF         COND(&MODULE *EQ 'CM') THEN(DO)                                   /*CRE008*/
             CALL       PGM(REC101201)                                                    /*CRE008*/
             CALL       PGM(REC101501)                                                    /*CRE008*/
             ENDDO                                                                        /*CRE008*/
/**/                                                                  /*CCM002*/
/*/COPY WNCPYSRC,SCC0103002                                          */
/* Submit the Technical Platform background jobs */
 
             IF         COND(&MODULE *EQ 'TP') THEN(DO)
/**/                                                                                     /*BUG2381*/
/* Start the APIs Confirmations job                                                      /*BUG2381*/
/**/                                                                                     /*BUG2381*/
             CALL       PGM(APC0430)                                                     /*BUG2381*/
/**/                                                                                     /*BUG2381*/
/*                                                                                        /*CPK014*/
/* If the background journal monitor program is not already */                            /*CPK014*/
/* running then start it up                                 */                            /*CPK014*/
/*                                                                                        /*CPK014*/
/* try to allocate data area SCJRNLOCK.                                                   /*CPK014*/
/*                                                                                        /*CPK014*/
                ALCOBJ     OBJ((SCJRNLOCK *DTAARA *EXCL)) WAIT(1)                         /*CPK014*/
/*                                                                                        /*CPK014*/
/* If not allocated, then journal size monitor is active.                                 /*CPK014*/
/*                                                                                        /*CPK014*/
                MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP2))                        /*CPK014*/
/*                                                                                        /*CPK014*/
/* Otherwise submit the journal size monitor job.                                         /*CPK014*/
/*                                                                                        /*CPK014*/
/************   SBMJOB     CMD(CALL PGM(SCC2470)) JOB(JRNMONITOR) +                       /*CSC023*/
/************                JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +                       /*CSC023*/
/************                RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(*NONE)          /*CPK014*/ /*CSC023*/
                SBMJOB     CMD(CALL PGM(SCC2470)) JOB(JRNMONITOR) +
                             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +
                             RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(*NONE) +
                             OUTQ(*JOBD)                                                  /*CSC023*/
/*                                                                                        /*CPK014*/
                DLCOBJ     OBJ((SCJRNLOCK *DTAARA *EXCL))                                 /*CPK014*/
SKIP2:                                                                                    /*CPK014*/
/*                                                                                        /*CPK014*/
/* If the background RCF distribution program is not already */
/* running then start it up                                  */
 
                ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(0)
                MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(HAF))
 
/************DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                 /* 115624 */
 
/***********  SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +           166101*/
/***********              JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ)+166101*/
/***********              OUTQ(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)  166101*/
                SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +
                            JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                            OUTQ(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) +
                            USER(*JOBD)                               /*166101*/
 
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                 /* 115624 */
 
/* Submit HAFMONITOR to read journal entries */
 
/* Access PF/SDMMODPD to determine which modules are live */
 
 HAF:
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)
 
/*  Database error handling  */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
                SNDPGMMSG  MSG('Database error on Midas modules +
                             file') TOMSGQ(MOPERQ MRUNQ)
 
/* Call SCC0010 to inform user that an error has occurred */
 
                RTVMSG     MSGID(SCM0074) MSGF(MIDASMSG) +
                             MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(SCM0075) MSGF(MIDASMSG) +
                             MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (18 1)) VALUE('1')
                CALL       PGM(SCC0010) PARM('SCC0103' 'ENTER' ' ')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
                IF         COND(%SST(&FMT 94 1) *EQ 'Y') THEN(DO)
 
/* Access PF/SDHAFDPD to determine whether to submit HAFMONITOR */
 
                   CALL       PGM(AOHAFDR0) PARM(&HAFRTCD &HAFOPTN +
                                &HAFFMT)
 
/* Database error handling */
 
                   IF         COND(&HAFRTCD *NE '       ') THEN(DO)
 
                      SNDPGMMSG  MSG('Error on access to ICD +
                                   file AOHAFDPD') TOMSGQ(MOPERQ MRUNQ)
 
/* Call SCC0010 to inform user that an error has occurred */
 
                      RTVMSG     MSGID(SCM0074) MSGF(MIDASMSG) +
                                   MSG(&MESSAGE)
                      CHGDTAARA  DTAARA(MIDASMSG (251 50)) +
                                   VALUE(&MESSAGE)
                      RTVMSG     MSGID(SCM0083) MSGF(MIDASMSG) +
                                   MSG(&MESSAGE)
                      CHGDTAARA  DTAARA(MIDASMSG (351 50)) +
                                   VALUE(&MESSAGE)
                      CHGDTAARA  DTAARA(MIDASMSG (18 1)) VALUE('1')
                      CALL       PGM(SCC0010) PARM('SCC0103' 'ENTER' +
                                   ' ')
                      GOTO       CMDLBL(ABNOR)
                   ENDDO
 
                   IF         COND(%SST(&HAFFMT 15 1) *EQ 'Y') THEN(DO)
 
                      ALCOBJ     OBJ((HFLOCK *DTAARA *EXCL)) WAIT(0)
 
/* If unable to allocate HFLOCK then HAFMONITOR is already active */
/* in the process of being submitted                              */
 
                      MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
 
/* Ensure that DTAARA/HFCOB is blank */
 
                      CHGDTAARA  DTAARA(HFCOB) VALUE('     ')
 
/* Submit the HAF monitor program */
 
/**********           SBMJOB     CMD(CALL PGM(HFC0400)) +
/**********                        JOB(HAFMONITOR) JOBD(*LIBL/HFJOBD) +
/**********                        JOBQ(*LIBL/HFJOBQ) INLLIBL(*JOBD)  /*076725*/
/************         SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +                 /*CPK014*/
/************                      JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +                /*CPK014*/
/************                      RTGDTA(*JOBD) INLLIBL(*JOBD)       /*076725*/          /*CPK014*/
/************         SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +                 /*CSC023*/
/************             JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +                         /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)             /*CPK014*/ /*CSC023*/
                      SBMJOB     CMD(CALL PGM(HFC0400)) JOB(HAFMONITOR) +
                          JOBD(*LIBL/HFJOBD) JOBQ(*LIBL/HFJOBQ) +
                          USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)            /*CSC023*/
 
/* Deallocate HFLOCK */
 
                      DLCOBJ     OBJ((HFLOCK *DTAARA *EXCL))
 
                   ENDDO
                ENDDO
             ENDDO
 
/** Check if Midas Message Manager is installed */                                        /*CSD015*/
                                                                                          /*CSD015*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSD015*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSW025' +
                          &FMT)                                                           /*CSD015*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSW025) VALUE('Y'))                                        /*CSD015*/
 
/** Check if Midas Compliance Watch Feature is on */                                      /*CSD015*/
                                                                                          /*CSD015*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CSD015*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSD015' +
                          &FMT)                                                           /*CSD015*/
                                                                                          /*CSD015*/
/** If CSD015 is installed; And CSC011 is not installed or     */                         /*CSD015*/
/** CSC011 is installed and current system is main system      */                         /*CSD015*/
/** start the compliance watch engine.                         */                         /*CSD015*/
                                                                                          /*CSD015*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CSD015*/
                IF         COND((&CSC011 *EQ 'N') *OR ((&CSC011 *EQ +
                               'Y') *AND (&SWMD *EQ ' ') *AND +
                               (&CURR *EQ &MAIN))) THEN(DO)
 
                   IF         COND(&CSC011 *EQ 'N') THEN(DO)                              /*CSD015*/
                      RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)                       /*CSD015*/
                   ENDDO                                                                  /*CSD015*/
                   CHGVAR     VAR(&RTCD) VALUE('       ')                                 /*CSD015*/
                   CALL       PGM(AOCWCDR0) PARM(&RTCD &OPTN &DSSDY)                      /*CSD015*/
                   CHGVAR     VAR(&W1OFSR) VALUE(%SUBSTRING(&DSSDY 54 32))                /*CSD015*/
                   IF         COND((&RTCD *NE '       ') *OR (&W1OFSR *EQ +
                                  *BLANKS)) THEN(DO)                                      /*CSD015*/
                      SNDPGMMSG  MSG('SCC0103 - Attempt to start the Co+
                                     mpliance Watch OFAC-AGENT Server +
                                     and Compliance Watch List Engine +
                                     has failed.  Cause: OFAC-Agent +
                                     Server ID is not yet defined') +
                                     TOMSGQ(MOPERQ)                                       /*CSD015*/
                      GOTO       CMDLBL(ABNOR)                                            /*CSD015*/
                   ENDDO                                                                  /*CSD015*/
                                                                                          /*CSD015*/
                   ELSE (DO)                                                              /*CSD015*/
                                                                                          /*CSD015*/
/* Check if CSD083 Feature is on */                                                       /*CSD083*/
                                                                                          /*CSD083*/
                   CHGVAR     VAR(&RTCD) VALUE('       ')                                 /*CSD083*/
                   CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSD083' +
                              &FMT)                                                       /*CSD083*/
                   IF         COND(&RTCD *EQ '       ') THEN(DO)                          /*CSD083*/
                   GOTO       CMDLBL(ECHECK)                                              /*CSD083*/
                   ENDDO                                                                  /*CSD083*/
                      ALCOBJ     OBJ((COMPWTCH *DTAARA *EXCL)) WAIT(1)                    /*CSD015*/
                      MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(EWATCH))                 /*CSD015*/
                      DLCOBJ     OBJ((COMPWTCH *DTAARA *EXCL))                            /*CSD015*/
/************         SBMJOB     CMD(CALL PGM(SDFOFSRV) PARM(&CURR &W1OFSR)) +            /*CSC023*/
/************                      JOB(COMPWATCH) JOBD(MBATCH) +                          /*CSC023*/
/************                      JOBQ(INTERFACE) USER(*JOBD) RTGDTA(*JOBD) +            /*CSC023*/
/************                      INLLIBL(*JOBD) ALWMLTTHD(*YES)              /*CSD015*/ /*CSC023*/
                      SBMJOB     CMD(CALL PGM(SDFOFSRV) PARM(&CURR &W1OFSR)) +
                                   JOB(COMPWATCH) JOBD(MBATCH) +
                                   JOBQ(INTERFACE) USER(*JOBD) RTGDTA(*JOBD) +
                                   INLLIBL(*JOBD) ALWMLTTHD(*YES) OUTQ(*JOBD)             /*CSC023*/
                                                                                          /*CSD015*/
 EWATCH:                                                                                  /*CSD015*/
                      ALCOBJ     OBJ((SDWLENGN *DTAARA *EXCL)) WAIT(1)                    /*CSD015*/
                      MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ECHECK))                 /*CSD015*/
                      DLCOBJ     OBJ((SDWLENGN *DTAARA *EXCL))                            /*CSD015*/
/************         SBMJOB     CMD(CALL PGM(SDCWENGN)) JOB(CWLCHECK) +                  /*CSC023*/
/************                      JOBD(MBATCH) JOBQ(INTERFACE) USER(*JOBD) +             /*CSC023*/
/************                      RTGDTA(*JOBD) INLLIBL(*JOBD)                /*CSD015*/ /*CSC023*/
                      SBMJOB     CMD(CALL PGM(SDCWENGN)) JOB(CWLCHECK) +
                                   JOBD(MBATCH) JOBQ(INTERFACE) USER(*JOBD) +
                                   RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)               /*CSC023*/
                                                                                          /*CSD015*/
 ECHECK:                                                                                  /*CSD015*/
                      ALCOBJ     OBJ((SDWLMENG *DTAARA *EXCL)) WAIT(1)                    /*CSD015*/
                      MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ELMENG))                 /*CSD015*/
                      DLCOBJ     OBJ((SDWLMENG *DTAARA *EXCL))                            /*CSD015*/
/************         SBMJOB     CMD(CALL PGM(SDCWMENG)) JOB(CWLMENG) +                   /*CSC023*/
/************                      JOBD(MEJOBD) JOBQ(INTERFACE) USER(*JOBD) +             /*CSC023*/
/************                      RTGDTA(*JOBD) INLLIBL(*JOBD)                /*CSD015*/ /*CSC023*/
                      SBMJOB     CMD(CALL PGM(SDCWMENG)) JOB(CWLMENG) +
                                   JOBD(MEJOBD) JOBQ(INTERFACE) USER(*JOBD) +
                                   RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)               /*CSC023*/
                                                                                          /*CSD015*/
 ELMENG:                                                                                  /*CSD015*/
                      IF COND(&CSW025 *EQ 'N') THEN(DO)                                   /*CSD015*/
                          ALCOBJ     OBJ((SDWLSENG *DTAARA *EXCL)) WAIT(1)                /*CSD015*/
                          MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ELSENG))             /*CSD015*/
                          DLCOBJ     OBJ((SDWLSENG *DTAARA *EXCL))                        /*CSD015*/
/************             SBMJOB     CMD(CALL PGM(SDCWSENG)) JOB(CWLSENG) +               /*CSC023*/
/************                          JOBD(MEJOBD) JOBQ(INTERFACE) USER(*JOBD) +         /*CSC023*/
/************                          RTGDTA(*JOBD) INLLIBL(*JOBD)            /*CSD015*/ /*CSC023*/
                          SBMJOB     CMD(CALL PGM(SDCWSENG)) JOB(CWLSENG) +
                                       JOBD(MEJOBD) JOBQ(INTERFACE) USER(*JOBD) +
                                       RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD)           /*CSC023*/
                      ENDDO                                                               /*CSD015*/
                                                                                          /*CSD015*/
 ELSENG:                                                                                  /*CSD015*/
                                                                                          /*CSD015*/
                   ENDDO                                                                  /*CSD015*/
                                                                                          /*CSD015*/
                ENDDO                                                                     /*CSD015*/
             ENDDO                                                                        /*CSD015*/
                                                                                          /*CSD015*/
/** Check if MidasPlus Online Printing of Advices is on */                                /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CRE020' +
                          &FMT)                                                           /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CRE020*/
                CHGVAR     VAR(&CRE020) VALUE('Y')                                        /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
/** Restart the APIs Retail Advices jobs */                                               /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&CRE020 *EQ 'Y') THEN(DO)                                    /*CRE020*/
                CALL       PGM(APC0460)                                                   /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
/*/COPY WNCPYSRC,SCC0103MPE                                        */ /*S01408*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/*/COPY WNCPYSRC,SCC0103ERR                                        */ /*S01408*/
 
             SNDPGMMSG  MSG('Midas background monitors initiation +
                          terminated abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
             RTVMSG     MSGID(SCM0082) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             RTVMSG     MSGID(SCM0022) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CALL       PGM(SCC0010) PARM('SCC0103' 'ENTER' ' ')
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SIGNOFF    LOG(*LIST)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC0103END                                        */ /*S01408*/
 
             ENDPGM
