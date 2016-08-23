/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Midas information screen')                   */
/*********************************************************************/
/*                                                                   */
/*  Midas - Standing Data Module                                     */
/*                                                                   */
/*  SDC0700 - DISPLAY MIDAS INFORMATION SCREEN                       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG2955            Date 28May04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      094108             Date 03Oct95              */
/*                      S01339             Date 31Jul92              */
/*                 S01343              DATE 15AUG91                  */
/*                 RT0159              DATE 25JUN91                  */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG2955 - Added new message for workstation lock.           */
/*       CSC011 - 24x7 Midas Availability                            */
/*      094108 - ADD 2 NEW MESSAGES FOR SDC26                        */
/*      S01339 - ADD MESSAGES FOR NEW PROGRAM SDC9002.               */
/*      S01343 - SC/RR/SD MODULE RENAME PROJECT.                     */
/*               - MRUNQP RENAMED TO SCRUNQP                         */
/*               - SDC1711 RENAMED TO SCC1711                        */
/*                                                                   */
/*      RT0159  -  New program to replace messages sent to external  */
/*                 queues with a Midas-type screen, as this gives    */
/*                 a more professional image.                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FPGM &SCREEN &REPLY1)
 
             DCL        VAR(&SCREEN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REPLY1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DABTCH) TYPE(*CHAR) LEN(1)                                   /*CSC011*/
             DCLF       FILE(SDC0700DF)
 
/*  COPYRIGHT STATEMENT VARIABLE  */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*******************************************************************/
/* MESSAGES ASSOCIATED WITH &SCREEN VALUES           ¦ USED BY PGM */
/*******************************************************************/
/*                                                   ¦             */
/* CANTRUNA   - JOB CANNOT BE RUN AT THIS TIME       ¦ SDC9002     */ /*S01339*/
/*              PHASE MUST BE A                      ¦             */ /*S01339*/
/*              PRESS ENTER TO CONTINUE              ¦             */ /*S01339*/
/*===================================================*=============*/ /*S01339*/
/* CANTRUNAOD - JOB CANNOT BE RUN AT THIS TIME       ¦ SDC26       */
/*              PHASE MUST BE A OR D                 ¦             */
/*              PRESS ENTER TO CONTINUE              ¦ SDC27       */
/*===================================================*=============*/
/* CANTRUNNOW - JOB CANNOT BE RUN AT THIS TIME       ¦ SDC26       */
/*              OTHER JOB(S) ACTIVE.                 ¦             */
/*              PRESS ENTER TO CONTINUE              ¦ SDC27       */
/*===================================================*=============*/
/* CANTRUNSSF - JOB CANNOT BE RUN AT THIS TIME       ¦ SDC9002     */ /*S01339*/
/*              THE SYSTEM SET-UP FLAG IS ON         ¦             */ /*S01339*/
/*              PRESS ENTER TO CONTINUE              ¦             */ /*S01339*/
/*===================================================*=============*/ /*S01339*/
/* CNMSBSNACT - JOB COMPLETED NORMALLY BUT NOT TRANS-¦ SDCSY       */
/*              FERRED AS MIDAS SBS NOT ACTIVE       ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* DBERRJOBTM - DATABASE ERROR - JOB TERMINATED      ¦ SDCSY       */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* DBERRRECNF - DATABASE ERROR - RECORD NOT FOUND    ¦ SDC27       */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/**ICDBSAVABN***INPUT*CYCLE*DB*SAVE*ENDED*ABNORMALLY*¦*SDC1711******/ /*S01343*/
/* ICDBSAVABN - INPUT CYCLE DB SAVE ENDED ABNORMALLY ¦ SCC1711     */ /*S01343*/
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* ICTERMABN  - INPUT CYCLE INITIATION ENDED         ¦ SDCSY       */
/*              ABNORMALLY                           ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* JRNPFILABN - JOURNAL PHYSICAL FILES ENDED         ¦ SDC1730     */
/*              ABNORMALLY                           ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* JRNRCVMISS - RECOVERY CANT BE RUN AS JOURNAL      ¦ SDC1720     */
/*              RECEIVERS MISSING. RESTORE JOURNAL   ¦             */
/*              RECEIVERS AND RETRY OPTION           ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/**MRUNQRDBER*-*DATABASE*ERROR*IN*TABLE*FILE*********¦*MRUNQP*******/ /*S01343*/
/* MRUNQRDBER - DATABASE ERROR IN TABLE FILE         ¦ SCRUNQP     */ /*S01343*/
/*              KEYS 1-10                            ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* NOMIDASACT - NO MIDAS ACTIVITY TO REPORT FROM     ¦ SDCSY       */
/*              MRUNQ                                ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* NOVLDDATEI - NO VALID DATE HAS BEEN INPUT         ¦ SDCSY       */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* OPTPRIMMCH - OPTION ONLY FOR PRIMARY MACHINE      ¦ SDC1720     */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* RODBAFRABN - RESTORE OF DATABASE AND FORWARD      ¦ SDC1720     */
/*              RECOVERY ENDED ABNORMALLY            ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* RDARTCSABN - RESTORE DATA AREAS AFTER RECOVERY TO ¦ SDC1719     */
/*              CURRENT STATUS ENDED ABNORMALLY      ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* RPSRRPTABN - REPORTING STRUCTURES REPORT REQUEST  ¦ SDC1324     */
/*              ENDED ABNORMALLY                     ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* RPSTENQABN - REPORTING STRUCTURES ENQUIRY ENDED   ¦ SDC1320     */
/*              ABNORMALLY                           ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* RPSTRPTABN - REPORTING STRUCTURES REPORT ENDED ABN¦ SDC1325     */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* RSTDABMABN - RESTORE DATA AREAS ON BACKUP MACHINE ¦ SDC1752     */
/*              ENDED ABNORMALLY                     ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* RSTDTARABN - RESTORE DATA AREAS ENDED ABNORMALLY  ¦ SDC1723     */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* SDARTCSABN - SAVE DATA AREAS FOR RECOVERY TO      ¦ SDC1718     */
/*              CURRENT STATUS ENDED ABNORMALLY      ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* SDARTRSABN - SAVE DATA AREAS FOR RECOVERY TO      ¦ SDC1717     */
/*              RECEIVER SAVE ENDED ABNORMALLY       ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* SDC27ABN   - INSTALLATION CONTROL MAINTENANCE     ¦ SDC27       */
/*              ENDED ABNORMALLY                     ¦             */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* SYSERRINVD - SYSTEM ERROR - INVALID DATA          ¦ SDC27       */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/
/* TRANSFAIL  - TRANSACTION FAILED.                  ¦ SDC26       */
/*              RE-INPUT NECESSARY.                  ¦ SDC27       */
/*              PRESS ENTER TO CONTINUE              ¦             */
/*===================================================*=============*/ /*094108*/
/* SDSETUPNOR - STANDING FILES SET UP SUCCESFULLY.   ¦ SDC26       */ /*094108*/
/*              PRESS ENTER TO CONTINUE.             ¦             */ /*094108*/
/*===================================================*=============*/ /*094108*/
/* SDSETUPABN - SETUP OF STANDING DATA FILES TERMIN- ¦ SDC26       */ /*094108*/
/*              ATED ABNORMALLY.                     ¦             */ /*094108*/
/*              PRESS ENTER TO CONTINUE.             ¦             */ /*094108*/
/*                                                   ¦             */
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F0  - General error on Data Replication.   ¦ SCC000050   */                     /*CSC011*/
/*              Job cannot be run at this time.      ¦             */                     /*CSC011*/
/*              Press Enter to continue              ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F1  - A Data Replication Configurator error¦ SCC000050   */                     /*CSC011*/
/*              exists. Job cannot be run at this    ¦             */                     /*CSC011*/
/*              time.                                ¦             */                     /*CSC011*/
/*              Press Enter to continue              ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F2  - General error on Data Replication.   ¦ SCC000600   */                     /*CSC011*/
/*              The Data Replication cannot be       ¦             */                     /*CSC011*/
/*              started.                             ¦             */                     /*CSC011*/
/*              Press Enter to continue              ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F3  - A Data Replication Configurator error¦ SCC000600   */                     /*CSC011*/
/*              exists. The Data Replication cannot  ¦             */                     /*CSC011*/
/*              be started.                          ¦             */                     /*CSC011*/
/*              Press Enter to continue              ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F4  - This option is not allowed in this   ¦ SCC000070   */                     /*CSC011*/
/*              Midas environment.                   ¦             */                     /*CSC011*/
/*              Press Enter to continue              ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F5  - Option is not yet available.         ¦ SF0420      */                     /*CSC011*/
/*              Press Enter to continue              ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F8  - 'Support' to 'Main' System Transition¦ SFC4464     */                     /*CSC011*/
/*              Processing is not yet completed.     ¦ SCC000050   */                     /*CSC011*/
/*              Job cannot be run at this time.      ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F9  - Job cannot be run at the Main System.¦ SCC004315   */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F10 - Job cannot be run at the Support     ¦ SDC1720     */                     /*CSC011*/
/*              System.                              ¦             */                     /*CSC011*/
/*              Press Enter to continue              ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F12 - 'Support' to 'Main' System Transition¦ SCC004320   */                     /*CSC011*/
/*              Processing is already completed.     ¦             */                     /*CSC011*/
/*              Job cannot be run at this time.      ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/* SDC0700F14 - Number of files in batch N is        ¦ SCC000070   */                     /*CSC011*/
/*              incorrect.  This must be corrected   ¦             */                     /*CSC011*/
/*              before data replication will run.    ¦             */                     /*CSC011*/
/*              Press Enter to continue              ¦             */                     /*CSC011*/
/*===================================================*=============*/                     /*CSC011*/
/*******************************************************************/
 
/*  SEND HEADER/TRAILER INFORMATION  */
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DATE)
             RTVJOBA    JOB(&WSID) USER(&USER)
             SNDF       RCDFMT(HEADER)
             SNDF       RCDFMT(TRAILER)
 
/*  SEND REQUESTED SCREEN  */
 
/**  CANTRUNA    **/                                                  /*S01339*/
/* JOB CANNOT BE RUN AT THIS TIME. PHASE OF DAY MUST BE A  */         /*S01339*/
                                                                      /*S01339*/
             IF         COND(&SCREEN *EQ 'CANTRUNA') THEN(DO)         /*S01339*/
                SNDRCVF    RCDFMT(CANTRUNA)                           /*S01339*/
                GOTO       CMDLBL(END)                                /*S01339*/
             ENDDO                                                    /*S01339*/
 
/**  CANTRUNAOD  **/
/* JOB CANNOT BE RUN AT THIS TIME. PHASE OF DAY MUST BE A OR D  */
 
             IF         COND(&SCREEN *EQ 'CANTRUNAOD') THEN(DO)
                SNDRCVF    RCDFMT(CANTRUNAOD)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  CANTRUNNOW  **/
/* THE JOB CANNOT BE RUN AT THIS TIME. OTHER JOB(S) ACTIVE  */
 
             IF         COND(&SCREEN *EQ 'CANTRUNNOW') THEN(DO)
                SNDRCVF    RCDFMT(CANTRUNNOW)
                GOTO       CMDLBL(END)
             ENDDO
                                                                                         /*BUG2955*/
/** CANTRUNWRK                                                 */                        /*BUG2955*/
/** The Job cannot be run at this time. Another workstation is */                        /*BUG2955*/
/** using the ICD menu.                                        */                        /*BUG2955*/
                                                                                         /*BUG2955*/
             IF         COND(&SCREEN *EQ 'CANTRUNWRK') THEN(DO)                          /*BUG2955*/
                SNDRCVF    RCDFMT(CANTRUNWRK)                                            /*BUG2955*/
                GOTO       CMDLBL(END)                                                   /*BUG2955*/
             ENDDO                                                                       /*BUG2955*/
 
/**  CANTRUNSSF  **/                                                  /*S01339*/
/* JOB CANNOT BE RUN AT THIS TIME. SYSTEM SET-UP FLAG IS ON  */       /*S01339*/
                                                                      /*S01339*/
             IF         COND(&SCREEN *EQ 'CANTRUNSSF') THEN(DO)       /*S01339*/
                SNDRCVF    RCDFMT(CANTRUNSSF)                         /*S01339*/
                GOTO       CMDLBL(END)                                /*S01339*/
             ENDDO                                                    /*S01339*/
 
/**  CNMSBSNACT  **/
/* JOB COMPLETED NORMALLY BUT NOT TRANSFERRED AS MIDAS SBS NOT ACTIVE*/
 
             IF         COND(&SCREEN *EQ 'CNMSBSNACT') THEN(DO)
                SNDRCVF    RCDFMT(CNMSBSNACT)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  DBERRJOBTM   **/
/*  DATABASE ERROR - JOB TERMINATED  */
 
             IF         COND(&SCREEN *EQ 'DBERRJOBTM') THEN(DO)
                SNDRCVF    RCDFMT(DBERRJOBTM)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  DBERRRECNF  **/
/*  DATABASE ERROR - RECORD NOT FOUND  */
 
             IF         COND(&SCREEN *EQ 'DBERRRECNF') THEN(DO)
                SNDRCVF    RCDFMT(DBERRRECNF)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  ICDBSAVABN  **/
/* INPUT CYCLE DATABASE SAVE ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'ICDBSAVABN') THEN(DO)
                SNDRCVF    RCDFMT(ICDBSAVABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  ICTERMABN   **/
/* INPUT CYCLE INITIATION ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'ICTERMABN') THEN(DO)
                SNDRCVF    RCDFMT(ICTERMABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  JRNPFILABN  **/
/* JOURNAL PHYSICAL FILES ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'JRNPFILABN') THEN(DO)
                SNDRCVF    RCDFMT(JRNPFILABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  JRNRCVMISS  **/
/* RECOVERY CANT BE RUN AS JOURNAL RECEIVERS MISSING. */
/* RESTORE JOURNAL RECEIVERS AND RETRY OPTION */
 
             IF         COND(&SCREEN *EQ 'JRNRCVMISS') THEN(DO)
                SNDRCVF    RCDFMT(JRNRCVMISS)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  MRUNQRDBER  **/
/* DATABASE ERROR IN FILE TABLE KEYS 1-10 */
 
             IF         COND(&SCREEN *EQ 'MRUNQRDBER') THEN(DO)
                SNDRCVF    RCDFMT(MRUNQRDBER)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  NOMIDASACT  **/
/* NO MIDAS ACTIVITY TO REPORT FROM MRUNQ */
 
             IF         COND(&SCREEN *EQ 'NOMIDASACT') THEN(DO)
                SNDRCVF    RCDFMT(NOMIDASACT)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  NOVLDDATEI  **/
/* NO VALID DATE HAS BEEN INPUT */
 
             IF         COND(&SCREEN *EQ 'NOVLDDATEI') THEN(DO)
                SNDRCVF    RCDFMT(NOVLDDATEI)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  OPTPRIMMCH  **/
/* OPTION ONLY FOR PRIMARY MACHINE */
 
             IF         COND(&SCREEN *EQ 'OPTPRIMMCH') THEN(DO)
                SNDRCVF    RCDFMT(OPTPRIMMCH)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  RODBAFRABN  **/
/*RESTORE OF DATABASE AND FORWARD RECOVERY ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'RODBAFRABN') THEN(DO)
                SNDRCVF    RCDFMT(RODBAFRABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  RDARTCSABN  **/
/* RESTORE DATA AREAS AFTER RECOVERY TO CURRENT STATUS ENDED ABN */
 
             IF         COND(&SCREEN *EQ 'RDARTCSABN') THEN(DO)
                SNDRCVF    RCDFMT(RDARTCSABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  RPSRRPTABN  **/
/* REPORTING STRUCTURES REPORT REQUEST ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'RPSRRPTABN') THEN(DO)
                SNDRCVF    RCDFMT(RPSRRPTABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  RPSTENQABN  **/
/*  REPORTING STRUCTURES ENQUIRY ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'RPSTENQABN') THEN(DO)
                SNDRCVF    RCDFMT(RPSTENQABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  RPSTRPTABN  **/
/* REPORTING STRUCTURES REPORT ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'RPSTRPTABN') THEN(DO)
                SNDRCVF    RCDFMT(RPSTRPTABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  RSTDABMABN  **/
/* RESTORE DATA AREAS ON BACKUP MACHINE ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'RSTDABMABN') THEN(DO)
                SNDRCVF    RCDFMT(RSTDABMABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  RSTDTARABN  **/
/* RESTORE DATA AREAS ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'RSTDTARABN') THEN(DO)
                SNDRCVF    RCDFMT(RSTDTARABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  SDARTCSABN  **/
/* SAVE DATA AREAS FOR RECOVERY TO CURRENT STATUS ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'SDARTCSABN') THEN(DO)
                SNDRCVF    RCDFMT(SDARTCSABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  SDARTRSABN  **/
/* SAVE DATA AREAS FOR RECOVERY TO RECEIVER SAVE ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'SDARTRSABN') THEN(DO)
                SNDRCVF    RCDFMT(SDARTRSABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  SDC27ABN  **/
/* INSTALLATION CONTROL MAINTENANCE ENDED ABNORMALLY */
 
             IF         COND(&SCREEN *EQ 'SDC27ABN') THEN(DO)
                SNDRCVF    RCDFMT(SDC27ABN)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  SYSERRINVD  **/
/* SYSTEM ERROR - INVALID DATA */
 
             IF         COND(&SCREEN *EQ 'SYSERRINVD') THEN(DO)
                SNDRCVF    RCDFMT(SYSERRINVD)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  TRANSFAIL  **/
/* TRANSACTION FAILED. RE-INPUT NECESSARY */
 
             IF         COND(&SCREEN *EQ 'TRANSFAIL') THEN(DO)
                SNDRCVF    RCDFMT(TRANSFAIL)
                GOTO       CMDLBL(END)
             ENDDO
 
/**  SDSETUPNOR  **/                                         /*094108*/
/* SD FILE SETUP COMPLETED NORMALLY */                       /*094108*/
                                                             /*094108*/
          IF         COND(&SCREEN *EQ 'SDSETUPNOR') THEN(DO) /*094108*/
                SNDRCVF    RCDFMT(SDSETUPNOR)                /*094108*/
                GOTO       CMDLBL(END)                       /*094108*/
             ENDDO                                           /*094108*/
                                                             /*094108*/
/**  SDSETUPABN  **/                                         /*094108*/
/* SD FILE SETUP TERMINATED ABNORMALLY */                    /*094108*/
                                                             /*094108*/
          IF         COND(&SCREEN *EQ 'SDSETUPABN') THEN(DO) /*094108*/
                SNDRCVF    RCDFMT(SDSETUPABN)                /*094108*/
                GOTO       CMDLBL(END)                       /*094108*/
             ENDDO                                           /*094108*/
                                                             /*094108*/
/**  SDC0700F0  **/                                                                       /*CSC011*/
/** General error on Data Replication. */                                                 /*CSC011*/
                                                                                          /*CSC011*/
             IF      COND(&SCREEN *EQ 'SDC0700F0') THEN(DO)                               /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F0)                                              /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F1  **/                                                                       /*CSC011*/
/** A Data Replication Configurator error exists. */                                      /*CSC011*/
                                                                                          /*CSC011*/
             IF      COND(&SCREEN *EQ 'SDC0700F1') THEN(DO)                               /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F1)                                              /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F2  **/                                                                       /*CSC011*/
/** General error on Data Replication. */                                                 /*CSC011*/
                                                                                          /*CSC011*/
             IF      COND(&SCREEN *EQ 'SDC0700F2') THEN(DO)                               /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F2)                                              /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F3  **/                                                                       /*CSC011*/
/** A Data Replication Configurator error exists. */                                      /*CSC011*/
                                                                                          /*CSC011*/
             IF      COND(&SCREEN *EQ 'SDC0700F3') THEN(DO)                               /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F3)                                              /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F4  **/                                                                       /*CSC011*/
/** This option is not allowed in this Midas environment. */                              /*CSC011*/
                                                                                          /*CSC011*/
             IF      COND(&SCREEN *EQ 'SDC0700F4') THEN(DO)                               /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F4)                                              /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F5  **/                                                                       /*CSC011*/
/** Option is not yet available */                                                        /*CSC011*/
                                                                                          /*CSC011*/
             IF      COND(&SCREEN *EQ 'SDC0700F5') THEN(DO)                               /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F5)                                              /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F8  */                                                                        /*CSC011*/
/** 'Support' to 'Main' System Transition Processing is not yet  */                       /*CSC011*/
/**  completed.                                                  */                       /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&SCREEN *EQ 'SDC0700F8') THEN(DO)                            /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F8)                                              /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F9  */                                                                        /*CSC011*/
/** Job cannot be run at the Main System.  */                                             /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&SCREEN *EQ 'SDC0700F9') THEN(DO)                            /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F9)                                              /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F10 **/                                                                       /*CSC011*/
/** Job cannot be run at the Support System.  */                                          /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&SCREEN *EQ 'SDC0700F10') THEN(DO)                           /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F10)                                             /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F12 */                                                                        /*CSC011*/
/** 'Support' to 'Main' System Transition Processing is already  */                       /*CSC011*/
/**  completed.                                                  */                       /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND(&SCREEN *EQ 'SDC0700F12') THEN(DO)                           /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F12)                                             /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
/**  SDC0700F14 **/                                                                       /*CSC011*/
/** Number of files in batch N is incorrect. */                                           /*CSC011*/
                                                                                          /*CSC011*/
             IF      COND(&SCREEN *EQ 'SDC0700F14') THEN(DO)                              /*CSC011*/
                RTVDTAARA  DTAARA(SCDRSTAT (3 1)) RTNVAR(&DABTCH)                         /*CSC011*/
                CHGVAR     VAR(&#14BAT) VALUE(&DABTCH)                                    /*CSC011*/
                SNDRCVF    RCDFMT(SDC0700F14)                                             /*CSC011*/
                GOTO       CMDLBL(END)                                                    /*CSC011*/
             ENDDO                                                                        /*CSC011*/
 
/*  END OF PROGRAM PROCESSING  */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             RCLRSC
 
             ENDPGM
