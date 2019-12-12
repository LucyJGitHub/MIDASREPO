/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Re-open input cycle')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC07 -  RE-OPENING OF INPUT CYCLE                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. ERZ178             Date 15Mar13              */
/*       Prev Amend No. MD054045           Date 27Aug19              */
/*                      MD046248           Date 27Oct17              */
/*                      MD037757           Date 26Apr16              */
/*                      MD031644           Date 12Jan15              */
/*                      MD023896           Date 06May14              */
/*                      MD022394D          Date 23Apr14              */
/*                      MD022112           Date 05Sep13              */
/*                      MD020345           Date 03Jun13              */
/*                      AR762171           Date 26May11              */
/*                      AR1093685          Date 04Mar13              */
/*                      CCB023A            Date 06Aug12              */
/*                      CSC048             Date 06Aug12              */
/*                      AR1090688          Date 21Feb13              */
/*                      CCB022             Date 06Aug12              */
/*                      AR1075853          Date 08Jan13              */
/*                      AR1073235          Date 28Dec12              */
/*                      AR855839           Date 25Nov12              */
/*                      AR1042302          Date 11Oct12              */
/*                      AR544188           Date 01Aug12              */
/*                      CCB020             Date 06Aug12              */
/*                      CSC054             Date 23Feb12              */
/*                      CBF002             Date 04Jul11              */
/*                      AR787620           Date 10Jun11              */
/*                      AR680192           Date 10Dec10              */
/*                      CER059             Date 19Jul10              */
/*                      BUG26305A          Date 18Nov09              */
/*                      BUG26305           Date 07Oct09              */
/*                      BUG25489           Date 14Aug09              */
/*                      BUG27914           Date 22Jul10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      249135             Date 20Jul07              */
/*                      CSC032             Date 06Jul07              */
/*                      260790             Date 19Jun09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BUG14879           Date 19Sep07              */
/*                      BUG14179A          Date 19Sep07              */
/*                      BUG14179           Date 30Jun07              */
/*                      BUG12169           Date 18Oct06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      218851             Date 02Nov06              */
/*                      237463             Date 21Jun06              */
/*                      240226             Date 06Jun06              */
/*                      BUG9619            Date 01Feb06              */
/*                      CER001             Date 25Apr05              */
/*                      BUG4841            Date 28Oct04              */
/*                      CSC023             Date 02Feb04              */
/*                      224829             Date 31Mar04              */
/*                      CSC020             Date 31Mar04              */
/*                      222005             Date 07Oct03              */
/*                      CAS006             Date 21Jan02              */
/*                      CAS005             Date 16Dec02              */
/*                      CSC018             Date 31May03              */
/*                      CCB012             Date 04Jul02              */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                      210581             Date 13Oct02              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025             Date 26Mar02              */
/*                      202444             Date 29Jan02              */
/*                      CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 08Nov01              */
/*                      CSC012             Date 22Oct01              */
/*                      196358             DATE 26Jun01              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CTI003             DATE 08Sep00              */
/*                      CPB002             Date 01Jun99              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      139764             DATE 29Jul98              */
/*                      CAP002             DATE 05May98              */
/*                      127256             Date 08Dec97              */
/*                      CTI001             Date 01Sep97              */
/*                      CCB003             Date 17Jan97              */
/*                      110242             DATE 07NOV96              */
/*                      S01408             DATE 07OCT96              */
/*                      092729             DATE 19SEP95              */
/*                      S01408             DATE 08SEP95              */
/*                      085307             DATE 23MAY95              */
/*                      S01420             DATE 22MAR95              */
/*                      S01408             DATE 18APR95              */
/*                      081177             DATE 07MAR95              */
/*                      S01522             DATE 25NOV94              */
/*                      059503             DATE 22JUN94              */
/*                      068922             DATE 02APR94              */
/*                      S01435             DATE 15SEP93              */
/*                      S01463             DATE 11FEB94              */
/*                      053723             DATE 16DEC93              */
/*                      056289             DATE 15OCT93              */
/*                      S01421             DATE 16AUG92              */
/*                      056290             DATE 30JUN93              */
/*                      E35464             DATE 05FEB92              */
/*                      S01319             DATE 10OCT91              */
/*                      S01345             DATE 06NOV91              */
/*                      S01343             DATE 15AUG91              */
/*                      E26655             DATE 12AUG91              */
/*                      E23979             DATE 01JUL91              */
/*                      RT0142             DATE 03JUN91              */
/*                      S01184             DATE 21FEB90              */
/*                      E20391             DATE 23OCT90              */
/*                      LN0076             DATE 01MAY90              */
/*                      LN0017             DATE 26APR90              */
/*                      S01194             DATE 08FEB90              */
/*                      S01117             DATE 08FEB90              */
/*                      E13205             DATE 15/03/89             */
/*                      E14941             DATE 12/10/88             */
/*                      E10061             DATE 15/07/88             */
/*                      S01179             DATE 12/09/88             */
/*                      S01127             DATE 03/06/88             */
/*                      E10334             DATE 24/05/88             */
/*                      S01145             DATE 02/12/87             */
/*                      S01129             DATE 31/07/87             */
/*                      S01133             DATE 30/03/87             */
/*                      S01098             DATE 08/07/86             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       ERZ178 - COB Save Enhancements + MIMIX                      */
/*                Amended hooks:                                     */
/*                - SCH00005, SCH00006, SCC07002                     */
/*       MD054045 - Not able to reopen i/c after the 1st attempt     */
/*                  to reopen failed.                                */
/*       MD046248 - Finastra Rebranding                              */
/*       MD037757 - When running COB, component CBC022001 00296      */
/*                  failed                                           */
/*       MD031644 - SP7 Build issue (Rework of CFT158 Return         */
/*                  Status of Interfaced FT Payments). Unable        */
/*                  to compile GP002900 due to zonal access.         */
/*                  Submit background job FTRETS_zz.                 */
/*       MD023896 - Switching on of Journal Cache for global layer   */
/*       MD022394D - Remove call to SC001006 before RSTLIB           */
/*       MD022112 - SCC1711 performance improvement                  */
/*       AR762171 - Meridian Replication job fails with MSGW after   */
/*                  COB.  Change to name of Meridian Replication     */
/*                  data area.  (Child: AR762172)                    */
/*       MD020345 - Expected PDCL generated transactions went to     */
/*                  Repair Queue after COB was reopened              */
/*       AR1093685 - DBIC save and restore issues                    */
/*       CCB023A - COB Restructure - Restructure Input Cycle         */
/*                 Termination Components                            */
/*       CSC048 - Journal Caching                                    */
/*       AR1090688 - Additional changes during re-open               */
/*       CCB022 - COB Restructure - COB File Manager                 */
/*       AR1075853 - APCTRANR does not allow transactions from being */
/*                   processed during COB                            */
/*       AR1073235 - LEC06A seq 03001 component failed               */
/*       AR855839 - Reopen of Input cycle gives MSGW in COBJRNMON.   */
/*                  Fix is to issue the 'STOP' message for SCC2470MON*/
/*                  before RSTLIB is done by SCC07. (Child: AR855840)*/
/*                - Applied for AR1006062 (Child:AR1006063)          */
/*       AR1042302 - PEA COB Output must be allowed for archiving    */
/*                   (Child:AR1042303)                               */
/*       AR544188 - Performance enhancements for LEC07003 component  */
/*                  (Child: AR544186)                                */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CSC054 - Period End Adjustments                             */
/*       CBF002 - BF Infrastructure: Backup and Recovery             */
/*       AR787620 - Hooks Incorporation                              */
/*                  WNCPYSRC,SCH00005                                */
/*                  WNCPYSRC,SCH00006                                */
/*       AR680192 - COB Re-open failed                               */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG26305A - L5 COB re-open failed                           */
/*       BUG26305 - L5 COB re-open failed                            */
/*       BUG25489 - DBERRCTL error encountered in ACUD               */
/*       BUG27914 - RAME Design Changes                              */
/*       249135 - Program Crashing during COB                        */
/*       CSC032 - Add exit programs to Midas save and restore        */
/*       260790 - COB performance fix                                */
/*                Terminate COBJRNMON if it is running.              */
/*       BUG14879 - COB re-open failed                               */
/*       BUG14179A - End journal Equation files prior to restore     */
/*       BUG14179 - Include save/restore of KINPXzz equation library */
/*                  when Consumer Banking is switched on.            */
/*       BUG12169 - Include restore of equation DBIC when Consumer   */
/*                  Banking is switched on.                          */
/*       218851 - Restart SWIFT and MMM jobs                         */
/*       237463 - Call SCKOBJLCB to kill object locks in COB before  */
/*                restoring files.                                   */
/*       240226 - Call SCKOBJLCB to kill object locks in COB before  */
/*                restoring files.                                   */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*       BUG4841 - On restore of DB end global background jobs       */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       224829 - Features CAS005, CAS006 and CSC011 always set on   */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       222005 - Clear Compliance Watch Data Queues                 */
/*       CAS006 - Hedge Accounting Phase B                           */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*       CSC018 - Journaling options for High Availability           */
/*       CCB012 - Use 70 job streams. Change to data area CBCTRL.    */
/*       210581 - Output Replication and TI Interface starting       */
/*                journal sequence numbers.                          */
/*       207764 - Change all SAV* and RST* commands to print a       */
/*                report of objects saved or restored.               */
/*       CSW025 - Midas Message Manager                              */
/*                - Save/restore message manager library             */
/*       202444 - Receiver monitor submit is in wrong place.         */
/*       CSC011 - 24x7 Midas Availability                            */
/*       CPK014 - Release 4 packaging:                               */
/*                _ Remove call to redundant program CGC2010.        */
/*                - Submit jobs with user *JOBD                      */
/*       CSC012 - Addition of a DTALIB restore.                      */
/*       196358 - Submit journal receiver size monitor.              */
/*       CTI003 - Midas/TI Interface CoB Changes                     */
/*       CPB002 - Meridian DBA Middleware Replication Customization. */
/*                Midas/TOF Interface.                               */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       139764 - The call to AOSARDR0 for CAP002 should specify     */
/*                the option parameter as *VERIFY.                   */
/*       CAP002 - Conversion of input functionss to APIs.            */
/*       127256 - Stop Midas/TI batch jobs when entering I/C from COB*/
/*       CTI001 - Midas / Trade Innovation Interface Phase 1         */
/*       CCB003 - End journalling for Task Split components          */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       S01408 - Core hook added SCC07MP5                           */
/*                Core hook added SCC07MP4                           */
/*       092729 - Cannot journal if reopen after data base save      */
/*       S01408 - Addition of core hook SCC07INT                     */
/*                Addition of core hook SCC07001                     */
/*       085307 - Cannot reopen if device type is TAPE(program loop) */
/*       S01420 - CoB enhancement (Batch processing)                 */
/*       S01408 - Core hook added SCC07MP1                           */
/*                Core hook added SCC07MP2                           */
/*                Core hook added SCC07MP3                           */
/*       081177 - Use Job Description library list instead of        */
/*                current library list when submitting job           */
/*       S01522 - User Defined Correspondence                        */
/*       059503 - Workstation ID truncated when updated to file      */
/*                MNTYF.  Include the 10char field WSTI to file      */
/*                MNTYF.  Update all programs using CMTTXT (COMMIT   */
/*                TEXT) accordingly.                                 */
/*       068922 - If S01411 is in the system call SCCLRBT,           */
/*                amendment for 'Business Transaction Statistics'    */
/*       S01435 - Incoming Message Management.                       */
/*       S01463 - Rename FCC0401 job to RCFMONITOR.                  */
/*       053723 - Parameter &ERROR wrongly defined as *LGL where it  */
/*                should be *CHAR.  The expected return value of     */
/*                the calling program SCMINIT is a length 1 char.    */
/*       056289 - Should monitor on STRCMTCTL in case already active */
/*       S01421 - BLI step 1 development                             */
/*                Changes required to secure reopen. If the          */
/*                Restore from Save File flage on DTAARA/JNSTAT      */
/*                is 'Y' then ensure that the restore of the         */
/*                database is done from DBIC and not from            */
/*                external media                                     */
/*       056290 - ALLOCATE THE DATABASE LIBRARY EXCLUSIVELY BEFORE   */
/*                RESTORING FROM BACKUP.  THE 'DVLIB' SHOULD BE      */
/*                ALLOCATED NOT THE 'DMLIB'.                         */
/*       E35464 - Need to tell SCCLRSE that called during reopen     */
/*                input cycle                                        */
/*       S01319 - Remove redundant processing                        */
/*       S01345 - JOURNALLING SYSTEM RE-WRITE                        */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT                     */
/*                - SCC07 RENAMED FROM SDC07                         */
/*                - SDCLRCL REDUNDANT AT R10                         */
/*                - SCCLRAB RENAMED FROM SDCLRAB                     */
/*                - SCCLRDL RENAMED FROM SDCLRDL                     */
/*                - SCCLRFD RENAMED FROM SDCLRFD                     */
/*                - SCCLRFX RENAMED FROM SDCLRFX                     */
/*                - SCCLRGL RENAMED FROM SDCLRGL                     */
/*                - SCCLRRE RENAMED FROM SDCLRRE                     */
/*                - SCCLRSE RENAMED FROM SDCLRSE                     */
/*       E26655 - AMEND CALLS TO SCC0010 TO REFLECT THE REWRITE      */
/*                OF THAT PROGRAM.                                   */
/*       E23979 - WHEN REOPENING I/C THE PROGRAM ATTEMPTS TO USE     */
/*                THE VOLUME ID OF THE LAST SAVE AS THE SAVE         */
/*                DEVICE. THIS IS BECAUSE IT USES POSN 126,5         */
/*                FROM THE JOURNAL ENTRY INSTEAD OF 151,4.           */
/*                                                                   */
/*       RT0142 - REPLACE *EXT MESSAGES WITH CALL TO NEW PROGRAM     */
/*                SCC0010.                                           */
/*       S01184 - CONFIRMATION MATCHING INCORPORATION -              */
/*                RE-SUBMIT CONTROL PROGRAM                          */
/*       E20391 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.            */
/*       LN0076 - ADD WAIT TIME TO RCF DISTRIBUTION ALCOBJ           */
/*       LN0017 - ADD TERMINATION OF RCF DISTRIBUTION JOB            */
/*       S01194 - STANDING DATA AMENDMENTS                           */
/*       S01117 - MULTIBRANCHING - DROP SDC0101,ST AND BC            */
/*                REPORT CONTROL FACILITY                            */
/*       E13205 - Replace call of SDC1724 with call to SDC1774       */
/*              - Retrieve time using RTVSYSVAL                      */
/*       E14941 - SDC1724 (OPEN & CLOSE LOGICAL FILES) IS NOW        */
/*                CALLED IF THE DATABASE IS RESTORED FROM DISK.      */
/*                IF THE DATABASE IS RESTORED FROM TAPE/DISKETTE     */
/*                THEN SDC1724 IS CALLED FROM SDC1721.               */
/*                WITHOUT THIS CALL SOME USERS MAY BE PREVENTED      */
/*                FROM PERFORMING INPUT ONCE THE INPUT CYCLE         */
/*                HAS BEEN REOPENED BECAUSE SOME ACCESS PATHS        */
/*                HAVE NOT YET BEEN REBUILT BY 'SPCF'.               */
/*       E10061 - ERROR FLAG NOT SET ON IF REOPEN INPUT CYCLE        */
/*                REQUESTED AFTER NEXT DAY SET UP HAS COMPLETED.     */
/*       S01179 - AS400 CONVERSION                                   */
/*       S01127 - FUTURES AND OPTIONS INCORPORATION                  */
/*       E10334 - DTAARA MPHAS NOT BEING ACCESSED FOR ITS VALUE      */
/*       S01145 - CLEAR ARBITRAGE DAILY FILES                        */
/*       S01129 - SECURITIES TRADING REL. 2                          */
/*       S01133 - DEALING ROOM SYSTEM                                */
/*       S01098 - DI LIBRARY SAVE FILE PROCESSING                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ERROR)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/************DCL        VAR(&ERROR) TYPE(*LGL) LEN(1)             */ /*053723*/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)               /*053723*/
/************DCL        VAR(&JOEDS) TYPE(*CHAR) LEN(130)              /*E23979*/
             DCL        VAR(&JOEDS) TYPE(*CHAR) LEN(250)              /*E23979*/
             DCL        VAR(&VOL1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LIB2) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)                                  /*CSC012*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(7)               /*056290*/
             DCL        VAR(&SEQNBR) TYPE(*DEC) LEN(10)
             DCL        VAR(&SEQNB1) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&CURRCV) TYPE(*CHAR) LEN(8)                                     CSC020*/
             DCL        VAR(&CURRCV) TYPE(*CHAR) LEN(10)                                  /*CSC020*/
             DCL        VAR(&LIBID) TYPE(*CHAR) LEN(2)
             DCL        &JOB   *CHAR 10
/************DCL        &CMTTXT *CHAR 112                         */ /*059503*/
             DCL        &CMTTXT *CHAR 460                            /*059503*/
             DCL        &WSID *CHAR 3
             DCL        &WSTI *CHAR 10                               /*059503*/
             DCL        &USRID *CHAR 10
             DCL        &TIME *CHAR 6
             DCL        VAR(&BLNK339) TYPE(*CHAR) LEN(339) +
                        VALUE(' ')                                   /*059503*/
/**********  DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
/**********  DCLDTAARA  DTAARA(MPHAS)                               *  *S01179*/
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                /*S01179*/
/**********  DCLDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)             /*S01179*/
             DCL        VAR(&DTQDLEN)  TYPE(*DEC) LEN(5) VALUE(1)     /*LN0017*/
             DCL        VAR(&T) TYPE(*CHAR) LEN(1) VALUE('T')         /*LN0017*/
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)              /*RT0142*/
             DCL        VAR(&SAVD) TYPE(*CHAR) LEN(4)                 /*E23979*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)             /*E26655*/
             DCL        VAR(&RSTSAV) TYPE(*CHAR) LEN(1)               /*S01421*/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)                  /*068922*/
             DCL        VAR(&OPN) TYPE(*CHAR) LEN(7)                  /*068922*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*068922*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)               /*068922*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*S01522*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')                                          /*S01522*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*S01522*/
             DCL        VAR(&CAP002) TYPE(*CHAR) LEN(1) VALUE('N' )   /*CAP002*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)               /*S01420*/
             DCL        VAR(&PRC) TYPE(*CHAR) LEN(7) VALUE('REOPEN ') /*S01420*/
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(10) +
                          VALUE('*ALL      ')                         /*S01420*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                 /*S01420*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                 /*S01420*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                  /*S01420*/
             DCL        VAR(&SEV) TYPE(*DEC) LEN(2 0)                 /*S01420*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(40)                 /*S01420*/
/*                                                                      CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature***************         */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                         */ /*CCB009 CCB020*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/

             DCL        VAR(&REOPTI) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CTI003*/
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(5)                                    /*CTI003*/
             DCL        VAR(&LENGTH) TYPE(*DEC) LEN(5 0)                                  /*CTI003*/
             DCL        VAR(&KEYWD) TYPE(*CHAR) LEN(10)                                   /*CTI003*/
             DCL        VAR(&MESGS) TYPE(*CHAR) LEN(10)                                   /*CTI003*/
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(80)                                    /*CTI003*/
/*******     DCL        VAR(&CBCTRL) TYPE(*CHAR) LEN(512)                      /*CPK014*/ /*CCB012*/
             DCL        VAR(&CBCTRL) TYPE(*CHAR) LEN(2000)                                /*CCB012*/
             DCL        VAR(&CBCTRLMJB) TYPE(*CHAR) LEN(10)                               /*CPK014*/
             DCL        VAR(&CBCTRLMUR) TYPE(*CHAR) LEN(10)                               /*CPK014*/
             DCL        VAR(&CBCTRLMJN) TYPE(*CHAR) LEN(6)                                /*CPK014*/
             DCL        VAR(&CBCTRLSJB) TYPE(*CHAR) LEN(10)                               /*CPK014*/
             DCL        VAR(&CBCTRLSUR) TYPE(*CHAR) LEN(10)                               /*CPK014*/
             DCL        VAR(&CBCTRLSJN) TYPE(*CHAR) LEN(6)                                /*CPK014*/
/**********  DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE('N') */              /*CSC011 CCB022*/
/**********  DCL        VAR(&APIBKJOB) TYPE(*CHAR) LEN(1) VALUE('Y')*/             /*CSC011 CCB022*/
/**********  DCL        VAR(&CURR) TYPE(*CHAR) LEN(2)              */              /*CSC011 CCB022*/
/**********  DCL        VAR(&SUPP) TYPE(*CHAR) LEN(2)              */              /*CSC011 CCB022*/
/**********  DCL        VAR(&MMODE) TYPE(*CHAR) LEN(1)             */              /*CSC011 CCB022*/
/**********  DCL        VAR(&MAIN) TYPE(*CHAR) LEN(2)              */              /*CSC011 CCB022*/
/**********  DCL        VAR(&SOVR) TYPE(*CHAR) LEN(1)              */              /*CSC011 CCB022*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')                         /*CSW025*/
             DCL        VAR(&CSW025) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSW025*/
             DCL        VAR(&SAVEFILE) TYPE(*CHAR) LEN(10)                                /*CSW025*/
             DCL        VAR(&LIBTOSAVE) TYPE(*CHAR) LEN(10)                               /*CSW025*/
             DCL        VAR(&MNGSYS) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSW025*/
/*                                                                                        /*CSC018*/
/**Declare*variables*for*CSC018*-*Journaling*options*for*High*Availability      */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
/**********  DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                         */ /*CSC018 CCB020*/
             DCL        VAR(&MX1RTNRCV) TYPE(*CHAR) LEN(10)                               /*CSC018*/
/*********** DCL        VAR(&MX1ANUMB) TYPE(*CHAR) LEN(3)                      /*CSC018*/ /*CSC020*/
             DCL        VAR(&MX1ANUMB) TYPE(*CHAR) LEN(8)                                 /*CSC020*/
/*********** DCL        VAR(&MX1NUMB) TYPE(*DEC) LEN(3 0)                      /*CSC018*/ /*CSC020*/
             DCL        VAR(&MX1NUMB) TYPE(*DEC) LEN(8 0)                                 /*CSC020*/
             DCL        VAR(&MX1NXTRCV) TYPE(*CHAR) LEN(10)                               /*CSC018*/
             DCL        VAR(&DDMRM6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&DDMLI6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&RMTJR6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&IGNTG6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&MNGBJ6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&JLIBRMT) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&RMTCM6) TYPE(*CHAR) LEN(150)                                 /*CSC018*/
             DCL        VAR(&JLIBBKP) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&JNSEQ) TYPE(*DEC) LEN(10 0)                                  /*210581*/
             DCL        VAR(&JNSEQA) TYPE(*CHAR) LEN(10)                                  /*210581*/
             DCL        VAR(&RPBASELIB) TYPE(*CHAR) LEN(10)                               /*210581*/
             DCL        VAR(&RPDTASEQ) TYPE(*CHAR) LEN(10)                                /*210581*/
             DCL        VAR(&TILIB) TYPE(*CHAR) LEN(10)                                   /*210581*/
             DCL        VAR(&CAS005) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CAS005*/
             DCL        VAR(&CAS006) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CAS006*/
             DCL        VAR(&ULX043) TYPE(*CHAR) LEN(1)                                   /*CER001*/
/**********  DCL        VAR(&CRE026) TYPE(*CHAR) LEN(1) VALUE(' ') */            /*BUG12169 CCB022*/
/**********  DCL        VAR(&LIB3) TYPE(*CHAR) LEN(7) VALUE('KFIL   ')*/         /*BUG12169 CCB022*/
/**********  DCL        VAR(&LIB4) TYPE(*CHAR) LEN(7) VALUE('KLIB   ')*/         /*BUG12169 CCB022*/
/**********  DCL        VAR(&LIB5) TYPE(*CHAR) LEN(7) VALUE('KOPT   ')*/         /*BUG12169 CCB022*/
/**********  DCL        VAR(&LIB6) TYPE(*CHAR) LEN(7) VALUE('KINP   ')*/         /*BUG14179 CCB022*/
/**********  DCL        VAR(&KAPUNMNM) TYPE(*CHAR) LEN(3)          */            /*BUG12169 CCB022*/
/**********  DCL        VAR(&KJRNLIB)  TYPE(*CHAR) LEN(10)         */           /*BUG14179A CCB022*/
/**********  DCL        VAR(&KJRN)     TYPE(*CHAR) LEN(10)         */           /*BUG14179A CCB022*/
             DCL        VAR(&DATAQN) TYPE(*CHAR) LEN(10) +
                          VALUE('SCC2470MON')                                             /*260790*/
             DCL        VAR(&DATAQL) TYPE(*CHAR) LEN(10)                                  /*260790*/
             DCL        VAR(&DLEN) TYPE(*DEC) LEN(5 0) VALUE(10)                          /*260790*/
             DCL        VAR(&MESS) TYPE(*CHAR) LEN(10)                                    /*260790*/
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)                                    /*260790*/
/**********  DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7) VALUE('*KEY')          /*BUG26305 BUG26305A*/
/**********  DCL        VAR(&PRTNCODE) TYPE(*CHAR) LEN(7) VALUE(' ')          /*BUG26305 BUG26305A*/
/**********  DCL        VAR(&PFMT) TYPE(*CHAR) LEN(200) VALUE(' ')            /*BUG26305 BUG26305A*/
/**********  DCL        VAR(&WTxEndT) TYPE(*DEC) LEN(6)                       /*BUG26305 BUG26305A*/
/**********  DCL        VAR(&WTxEndC) TYPE(*CHAR) LEN(6)                      /*BUG26305 BUG26305A*/
/**********  DCL        VAR(&WMmYy) TYPE(*CHAR) LEN(4)                        /*BUG26305 BUG26305A*/
/**********  DCL        VAR(&PDateIn) TYPE(*CHAR) LEN(6)                      /*BUG26305 BUG26305A*/
/**********  DCL        VAR(&ZDateIn) TYPE(*DEC) LEN(6)                       /*BUG26305 BUG26305A*/
/**********  DCL        VAR(&PDayNo) TYPE(*DEC) LEN(5)                        /*BUG26305 BUG26305A*/
             DCL        VAR(&YY) TYPE(*CHAR) LEN(2)                                     /*BUG26305*/
             DCL        VAR(&MBRNAME) TYPE(*CHAR) LEN(10)                               /*BUG26305*/
             DCL        VAR(&MBRNAMELF0) TYPE(*CHAR) LEN(10)                           /*BUG26305A*/
             DCL        VAR(&MBRNAMELF1) TYPE(*CHAR) LEN(10)                           /*BUG26305A*/
             DCL        VAR(&MBRNAMELF2) TYPE(*CHAR) LEN(10)                           /*BUG26305A*/
             DCL        VAR(&MBRNAMELF3) TYPE(*CHAR) LEN(10)                           /*BUG26305A*/
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(5)                                /*BUG26305A*/
             DCL        VAR(&ENDTXYR) TYPE(*CHAR) LEN(5)                               /*BUG26305A*/
             DCL        VAR(&PCRDTA)  TYPE(*CHAR) LEN(1) VALUE('N')                     /*BUG26305*/
                                                                                        /*BUG26305*/
/**********  DCLF       FILE(SDBANKPD) RCDFMT(SDBANKD0)                       /*BUG26305 BUG26305A*/
                                                                      /*S01408*/
                                                                                          /*CSC032*/
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)                                      /*CSC032*/
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(7)                                     /*CSC032*/
             DCL        VAR(&CSC032) TYPE(*CHAR) LEN(1)                                   /*CSC032*/
             DCL        VAR(&RSTCMPL) TYPE(*CHAR) LEN(1) /*CSC032*/                       /*CSC032*/
             DCL        VAR(&JOBINFO) TYPE(*CHAR) LEN(86)                                 /*CSC032*/
             DCL        VAR(&DTALEN) TYPE(*INT) VALUE(75)                                 /*CSC032*/
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) VALUE(JOBI0100)                   /*CSC032*/
             DCL        VAR(&JOB5140) TYPE(*CHAR) LEN(26) /*CSC032*/                      /*249135*/
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)                                 /*249135*/
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)                                 /*249135*/
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)                                   /*249135*/
             DCL        VAR(&INTJOBID) TYPE(*CHAR) LEN(16)                                /*249135*/
             DCL        VAR(&ERRDTA) TYPE(*CHAR) LEN(256)                                 /*249135*/
             DCL        VAR(&JOBSTS) TYPE(*CHAR) LEN(10)                                  /*249135*/
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)                                      /*249135*/
             DCL        VAR(&PRFK) TYPE(*CHAR) LEN(3) VALUE('   ')                        /*CBF002*/
             DCL        VAR(&PEAIND) TYPE(*CHAR) LEN(1)                                   /*CSC054*/
             DCL        VAR(&MQMGR) TYPE(*CHAR) LEN(48)                                   /*CSC054*/
             DCL        VAR(&MQOUT) TYPE(*CHAR) LEN(48)                                   /*CSC054*/
             DCL        VAR(&MQMSG) TYPE(*CHAR) LEN(2000) VALUE('PEA +
                          Ready')                                                         /*CSC054*/
             DCL        VAR(&PRFX) TYPE(*CHAR) LEN(2)                                     /*CSC054*/
/*/COPY WNCPYSRC,SCH00005                                            */
                                                                                          /*249135*/
/*/COPY WNCPYSRC,SCC07INT                                            */
                                                                      /*S01408*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX0X)
/*/COPY WNCPYSRC,SCH00006                                            */
                                                                                          /*CAS005*/
/**Call*SC001006*to*return*members*that*were*removed*during*CoB**/           /*AR1090688 MD022394D*/
                                                                                       /*AR1090688*/
/**********  CALL       PGM(SC001006)                           */           /*AR1090688 MD022394D*/
                                                                                       /*AR1090688*/
/* Get copy of file SCFMBRTD */                                                         /*MD037757*/
                                                                                        /*MD054045*/
             CHKOBJ     OBJ(QTEMP/SCFMBRTD) OBJTYPE(*FILE)                              /*MD054045*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                         /*MD054045*/
                                                                                        /*MD054045*/
             CRTDUPOBJ  OBJ(SCFMBRTD) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*YES) CST(*NO) TRG(*NO)                     /*MD037757*/
             MONMSG     MSGID(CPF4128) EXEC(GOTO ABNOR)                                 /*MD037757*/
                                                                                        /*MD054045*/
             ENDDO                                                                      /*MD054045*/


/** Check if CAS005 is on /*                                                              /*CAS005*/
                                                                                          /*CAS005*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CAS005*/
             CHGVAR     VAR(&SARD) VALUE('CAS005')                                        /*CAS005*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CAS005*/
/*********** CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                  CAS005   224829*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPN &SARD &SFMT)                        /*224829*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CAS005*/
                CHGVAR     VAR(&CAS005) VALUE('Y')                                        /*CAS005*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS006*/
/** Check if CAS006 is on /*                                                              /*CAS006*/
                                                                                          /*CAS006*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CAS006*/
             CHGVAR     VAR(&SARD) VALUE('CAS006')                                        /*CAS006*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CAS006*/
/*********   CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                  CAS006   224829*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPN &SARD &SFMT)                        /*224829*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CAS006*/
                CHGVAR     VAR(&CAS006) VALUE('Y')                                        /*CAS006*/
             ENDDO                                                                        /*CAS006*/
                                                                                          /*CSC011*/
/***Check*if*24x7*Midas*Availability*Feature*is*on******************/              /*CSC011 CCB022*/
/*******************************************************************/              /*CSC011 CCB022*/
/**********  CHGVAR     VAR(&RTCD) VALUE('       ')                */              /*CSC011 CCB022*/
/**********  CHGVAR     VAR(&SARD) VALUE('CSC011')                 */              /*CSC011 CCB022*/
/**********  CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                */              /*CSC011 CCB022*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                 CSC011    224829*/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD &OPN &SARD &SFMT) */              /*224829 CCB022*/
/**********  IF         COND(&RTCD *EQ '       ') THEN(DO)         */              /*CSC011 CCB022*/
/**********     CHGVAR     VAR(&CSC011) VALUE('Y')                 */              /*CSC011 CCB022*/
/**********  ENDDO                                                 */              /*CSC011 CCB022*/
                                                                                          /*CSC011*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSW025')                              /*CSW025*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&CSW025) VALUE('Y'))                            /*CSW025*/
                                                                                          /*CSW025*/
/***Check*for*switchable*feature*CRE026*-*Consumer*Banking**********/            /*BUG12169 CCB022*/
/*******************************************************************/            /*BUG12169 CCB022*/
/**********  CHGVAR     VAR(&PRTCD) VALUE('       ')               */            /*BUG12169 CCB022*/
/**********  CHGVAR     VAR(&OPN) VALUE('*VERIFY')                 */            /*BUG12169 CCB022*/
/**********  CHGVAR     VAR(&SARD) VALUE('CRE026')                 */            /*BUG12169 CCB022*/
/**********  CALL       PGM(AOSARDR0) PARM(&PRTCD &OPN &SARD)      */            /*BUG12169 CCB022*/
/**********  IF         COND(&PRTCD *EQ '       ') THEN(CHGVAR +   */                     /*CCB022*/
/**********               VAR(&CRE026) VALUE('Y'))                 */            /*BUG12169 CCB022*/
/*******************************************************************/            /*BUG12169 CCB022*/
/**********  IF         COND(&CRE026 *EQ 'Y') THEN(DO)             */            /*BUG12169 CCB022*/
/**********  RTVDTAARA   DTAARA(KAPUNMNM)  RTNVAR(&KAPUNMNM)       */            /*BUG12169 CCB022*/
/**********  CHGVAR      VAR(&LIB3) VALUE('KFIL' *CAT +            */                     /*CCB022*/
/**********               (&KAPUNMNM))                             */            /*BUG12169 CCB022*/
/**********  CHGVAR      VAR(&LIB4) VALUE('KLIB' *CAT +            */                     /*CCB022*/
/**********               (&KAPUNMNM))                             */            /*BUG12169 CCB022*/
/**********  CHGVAR      VAR(&LIB5) VALUE('KOPT' *CAT +            */                     /*CCB022*/
/**********               (&KAPUNMNM))                             */            /*BUG12169 CCB022*/
/**********  CHGVAR      VAR(&LIB6) VALUE('KINP' *CAT +            */                     /*CCB022*/
/**********               (&KAPUNMNM))                             */            /*BUG14179 CCB022*/
/**********  ENDDO                                                 */            /*BUG12169 CCB022*/
/*                                                                      CCB009*/
/***Check*for*Switchable*feature*CCB009.*******************************         */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                                      */ /*CCB009 CCB020*/
/*                                                                                        /*CSC018*/
/***Check*for*Switchable*feature*CSC018*(Journaling*options*for*high***         */ /*CSC018 CCB020*/
/** availability)******************************************************         */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/**********  CALL       PGM(AOSARDR0) PARM(&CSC018 '*VERIFY' +
                          'CSC018' &AOFMT)                                      */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on',                                                             /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  IF         COND(&CSC018 *EQ '       ') THEN(DO)                    */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/*  Get the high availability system values */                                            /*CSC018*/
                                                                                          /*CSC018*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'HighAvlRmtJrnActive' &SVAL1 +
                          'HighAvlIgnTgtOnDel' &SVAL2 +
                          'HighAvlMangBackUpJrn' &SVAL3 +
                          'HighAvlDdmFileName' &SVAL4 +
                          'HighAvlDdmFileLib' &SVAL5 &SVALK6 &SVAL6 +
                          &SVALK7 &SVAL7 &SVALK8 &SVAL8 &SVALK9 +
                          &SVAL9 &SVALK10 &SVAL10)                                        /*CSC018*/
                                                                                          /*CSC018*/
/* If there is an error finding any system value then end abnormally */                   /*CSC018*/
                                                                                          /*CSC018*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote command DDM file name.                                            /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL4 1 10))                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote command DDM file library name.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL5 1 10))                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Determine whether remote journaling is being used.                                     /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL1 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* If remote journaling is being used,                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
/* Determine whether to ignore target receivers when deleting.                            /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL2 1 1))                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the remote journaling journal library.                                       /*CSC018*/
/*                                                                                        /*CSC018*/
               RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)                             /*CSC018*/
               CHGVAR     VAR(&JLIBRMT) VALUE(&LIBID *CAT 'JLIBRMT ')                     /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/* Determine whether backup journal management is being used                              /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL3 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the backup machine journal library.                                          /*CSC018*/
/*                                                                                        /*CSC018*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)                               /*CSC018*/
             CHGVAR     VAR(&JLIBBKP) VALUE(&LIBID *CAT 'JLIB    ')                       /*CSC018*/
CSC018END:                                                                                /*CSC018*/
/**********  ENDDO                                                              */ /*CSC018 CCB020*/
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),***********         */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/*                                                                                        /*CSC018*/
/**If*Feature*CSC018*is*'on'*(journal*options*for*high*availability),**         */ /*CSC018 CCB020*/
/*                                                                              */ /*CSC018 CCB020*/
/**********  IF         COND(&CSC018 *EQ '       ') THEN(DO)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/* If remote journaling is being used,                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* determine currently attached receiver.                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) RTNRCV(&MX1RTNRCV)                      /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the next receiver in the chain.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*********** CHGVAR     VAR(&MX1ANUMB) VALUE(%SST(&MX1RTNRCV 6 3))             /*CSC018*/ /*CSC020*/
             CHGVAR     VAR(&MX1ANUMB) VALUE(%SST(&MX1RTNRCV 3 8))                        /*CSC020*/
             CHGVAR     VAR(&MX1NUMB) VALUE(&MX1ANUMB)                                    /*CSC018*/
             CHGVAR     VAR(&MX1NUMB) VALUE(&MX1NUMB + 1)                                 /*CSC018*/
             CHGVAR     VAR(&MX1ANUMB) VALUE(&MX1NUMB)                                    /*CSC018*/
/*********** CHGVAR     VAR(&MX1NXTRCV) VALUE(%SST(&MX1RTNRCV 1 5) +
                          *CAT &MX1ANUMB *CAT '  ')                            /*CSC018*/ /*CSC020*/
             CHGVAR     VAR(&MX1NXTRCV) VALUE(%SST(&MX1RTNRCV 1 2) +
                          *CAT &MX1ANUMB)                                                 /*CSC020*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete the next receiver.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                          &JLIBRMT *TCAT '/' *CAT &MX1NXTRCV *CAT ' +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete the next receiver in the remote                   /*CSC018*/
/* journaling library on the other machine.                                               /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/* If backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* determine currently attached receiver.                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) RTNRCV(&MX1RTNRCV)                      /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate the next receiver in the chain.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
/************CHGVAR     VAR(&MX1ANUMB) VALUE(%SST(&MX1RTNRCV 6 3))             /*CSC018*/ /*CSC020*/
             CHGVAR     VAR(&MX1ANUMB) VALUE(%SST(&MX1RTNRCV 3 8))                        /*CSC020*/
             CHGVAR     VAR(&MX1NUMB) VALUE(&MX1ANUMB)                                    /*CSC018*/
             CHGVAR     VAR(&MX1NUMB) VALUE(&MX1NUMB + 1)                                 /*CSC018*/
             CHGVAR     VAR(&MX1ANUMB) VALUE(&MX1NUMB)                                    /*CSC018*/
/************CHGVAR     VAR(&MX1NXTRCV) VALUE(%SST(&MX1RTNRCV 1 5) +
                          *CAT &MX1ANUMB *CAT '  ')                           /*CSC018*/  /*CSC020*/
             CHGVAR     VAR(&MX1NXTRCV) VALUE(%SST(&MX1RTNRCV 1 2) +
                          *CAT &MX1ANUMB)                                                 /*CSC020*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete the next receiver.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                          &JLIBBKP *TCAT '/' *CAT &MX1NXTRCV *CAT ' +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete the next receiver in the                          /*CSC018*/
/* journaling library on the backup machine.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/**********  ENDDO                                                              */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/**********  ENDDO                                                              */ /*CSC018 CCB020*/
/*                                                                      CCB009*/
/* Change the journal receiver, changing the journal to                 CCB009*/
/* receiver management by '*USER' for input cycle.                      CCB009*/
/*                                                                      CCB009*/
             CHGJRN     JRN(ICJRN) JRNRCV(*GEN) MNGRCV(*USER) +
                                                                      /*CCB009*/
/*                                                                                        /*CSC018*/
/**If*Feature*CSC018*is*'on'*(journal*options*for*high*availability),**         */ /*CSC018 CCB020*/
/**and*if*backup*journal*management*is*being*used,*********************         */ /*CSC018 CCB020*/
/*                                                                                        /*CSC018*/
/**********  IF         COND((&CSC018 *EQ '       ') *AND (&MNGBJ6 +
                          *EQ 'Y')) THEN(DO)                                    */ /*CSC018 CCB020*/
             IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                    /*CCB020*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to execute CHGJRN command.                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('CHGJRN JRN(' *CAT +
                          &JLIBBKP *TCAT '/ICJRN) JRNRCV(*GEN) +
                          MNGRCV(*USER)')                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to execute the CHGJRN command on the                        /*CSC018*/
/* backup machine.                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/*                                                                                        /*202444*/
/**If*Feature*CCB009*is*'on'*(permanent*journaling),*******************         */ /*CCB009 CCB020*/
/*                                                                                        /*202444*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/*                                                                                        /*202444*/
/* try to allocate data area SCJRNLOCK.                                                   /*202444*/
/*                                                                                        /*202444*/
             ALCOBJ     OBJ((SCJRNLOCK *DTAARA *EXCL)) WAIT(1)                            /*202444*/
/*                                                                                        /*202444*/
/* If not allocated, then journal size monitor is active.                                 /*202444*/
/*                                                                                        /*202444*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP))                            /*202444*/
/*                                                                                        /*202444*/
/* Otherwise submit the journal size monitor job.                                         /*202444*/
/*                                                                                        /*202444*/
/************SBMJOB     CMD(CALL PGM(SCC2470)) JOB(JRNMONITOR) +                          /*CSC023*/
/************             JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(*NONE)             /*202444*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(SCC2470)) JOB(JRNMONITOR) +
                          JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)            /*CSC023*/
             DLCOBJ     OBJ((SCJRNLOCK *DTAARA *EXCL))                                    /*202444*/
SKIP:                                                                                     /*202444*/
/*                                                                                        /*202444*/
/**********  ENDDO                                                              */ /*202444 CCB020*/
/*                                                                                        /*202444*/
/*                                                                      CCB009*/
/* Determine the name of the currently attached receiver.               CCB009*/
/*                                                                      CCB009*/
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) RTNRCV(&SEQNB1) +
                                                                      /*CCB009*/
/*                                                                      CCB009*/
/* Update JNSTAT with the name of the currently attached receiver.      CCB009*/
/*                                                                      CCB009*/
             CHGDTAARA  DTAARA(JNSTAT (1 10)) VALUE(&SEQNB1)          /*CCB009*/
/*                                                                      CCB009*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,SCC07002                                            */
/**/
/*  Check if the API Switchable Feature is on                         /*CAP002*/
             CHGVAR     VAR(&SARD) VALUE('CAP002')                    /*CAP002*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*139764*/
             CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)      /*CAP002*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                          VAR(&CAP002) VALUE('Y'))                    /*CAP002*/
                                                                      /*CAP002*/
/*  If the SF is on, terminate API background functions               /*CAP002*/
             IF         COND(&CAP002 *EQ 'Y') THEN(DO)                /*CAP002*/
                CALL       PGM(APCENDBKJB)                            /*CAP002*/
             ENDDO                                                    /*CAP002*/
                                                                      /*CAP002*/
/* TERMINATE REPORT DISTRIBUTION PROGRAM */                           /*LN0017*/
/**/                                                                  /*LN0017*/
/*           ALCOBJ     OBJ((FC0100 *DTAARA *EXCL))        /*LN0017*/ /*LN0076*/
             ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5)           /*LN0076*/
             MONMSG     MSGID(CPF1002) EXEC(CALL PGM(QSNDDTAQ) +
                          PARM('FCDTAQ' '*LIBL' &DTQDLEN &T))         /*LN0017*/
 DISTLP:     ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(30)          /*LN0017*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(DISTLP))      /*LN0017*/
             DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))                   /*LN0017*/
                                                                                          /*CPK014*/
/* Close down COBSCHED and COBMONITOR */                                                  /*CPK014*/
                                                                                          /*CPK014*/
/* Retrieve COBSCHED and COBMONITOR job information */                                    /*CPK014*/
                                                                                          /*CPK014*/
             RTVDTAARA  DTAARA(CBCTRL) RTNVAR(&CBCTRL)                                    /*CPK014*/
                                                                                          /*CPK014*/
/* COBMONITOR */                                                                          /*CPK014*/
                                                                                          /*CPK014*/
             CHGVAR     VAR(&CBCTRLMJB) VALUE(%SST(&CBCTRL 1 10))                         /*CPK014*/
             CHGVAR     VAR(&CBCTRLMUR) VALUE(%SST(&CBCTRL 11 10))                        /*CPK014*/
             CHGVAR     VAR(&CBCTRLMJN) VALUE(%SST(&CBCTRL 21 6))                         /*CPK014*/
                                                                                          /*CPK014*/
             ENDJOB     JOB(&CBCTRLMJN/&CBCTRLMUR/&CBCTRLMJB) +
                          OPTION(*IMMED)                                                  /*CPK014*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK014*/
                                                                                          /*CPK014*/
/* COBSCHED */                                                                            /*CPK014*/
                                                                                          /*CPK014*/
             CHGVAR     VAR(&CBCTRLSJB) VALUE(%SST(&CBCTRL 27 10))                        /*CPK014*/
             CHGVAR     VAR(&CBCTRLSUR) VALUE(%SST(&CBCTRL 37 10))                        /*CPK014*/
             CHGVAR     VAR(&CBCTRLSJN) VALUE(%SST(&CBCTRL 47 6))                         /*CPK014*/
                                                                                          /*CPK014*/
             ENDJOB     JOB(&CBCTRLSJN/&CBCTRLSUR/&CBCTRLSJB) +
                          OPTION(*IMMED)                                                  /*CPK014*/
             MONMSG     MSGID(CPF0000)                                                    /*CPK014*/
/**/                                                                  /*LN0017*/
/*  IDENTIFY THE MOST RECENT DATABASE SAVE (I-C TERMINATION)        */
/**/
             RTVDTAARA  DTAARA(JNSTAT (1 8)) RTNVAR(&CURRCV)
/************SNDJRNE****JRN(ICJRN)*TYPE('SR')***********************/ /*S01127*/
/*/COPY WNCPYSRC,SCC07007                                            */
/**********  SNDJRNE    JRN(ICJRN) TYPE('IR') */                              /*S01127*/ /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('IR') FORCE(*YES)                                /*BUG9619*/
/**********  RTVJRNE    JRN(ICJRN) RCVRNG(&CURRCV ICRCV001) +                               CSC020*/
/**********               FROMENT(*LAST) TOENT(*FIRST) +                                    CSC020*/
/**********               SEARCH(*DESCEND) ENTTYP('SV') +                                   CSC020*/
/**********               RTNSEQNBR(&SEQNBR) RTNJRNE(&JOEDS)                                CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN)        +
                          FROMENT(*LAST) TOENT(*FIRST) +
                          SEARCH(*DESCEND) ENTTYP('SV') +
                          RTNSEQNBR(&SEQNBR) RTNJRNE(&JOEDS)                              /*CSC020*/
                    MONMSG CPF0000                                    /*S01133*/
/*/COPY WNCPYSRC,SCC07008                                            */
/**/
/*  IF BEING RUN AFTER NEXT DAY SETUP, SEND ERROR MESSAGE & END     */
/**/
/**********  RCVDTAARA  DTAARA(MPHAS)                               *  *S01179*/
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                  /*S01179*/
/**********  IF         COND(&MPHAS *EQ 'F') THEN(DO)                                     /*CCB020*/
             IF         COND(&MPHAS *EQ 'G') THEN(DO)                                     /*CCB020*/
/***************SNDPGMMSG  MSG('Input Cycle cannot be re-opened +
/***************               in this phase') TOPGMQ(*EXT) +
/***************               TOMSGQ(MOPERQ MRUNQ)                   /*RT0142*/
                                                                      /*RT0142*/
                SNDPGMMSG  MSG('Input Cycle cannot be re-opened +
                             in this phase') TOMSGQ(MOPERQ MRUNQ)     /*RT0142*/
                                                                      /*RT0142*/
/*  CALL SCC0010 TO SEND I/C CANNOT BE RE-OPENED IN THIS PHASE  */    /*RT0142*/
/*  SCREEN                                                      */    /*RT0142*/
                                                                      /*RT0142*/
/***************CALL       PGM(SCC0010) PARM('SDC07' 'ICNOTREOPN' +
/***************             &NOREPLY)                     /*RT0142*/ /*E26655*/
             RTVMSG     MSGID(SCM0023) MSGF(MIDASMSG) MSG(&MESSAGE)   /*E26655*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)     /*E26655*/
             RTVMSG     MSGID(SCM0024) MSGF(MIDASMSG) MSG(&MESSAGE)   /*E26655*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)     /*E26655*/
             CHGDTAARA  DTAARA(MIDASMSG (8 1)) VALUE('1')             /*E26655*/
             CALL       PGM(SCC0010) PARM('SCC07' 'ENTER' &NOREPLY)   /*E26655*/
                                                                      /*RT0142*/
                CHGVAR     VAR(&ERROR) VALUE('1')                     /*E10061*/
                GOTO       ENDPGM                                     /*E10061*/
/*              GOTO       END                                      ****E10061*/
             ENDDO
/* If TI is present as a module then check if Midas/TI Interface CoB */                   /*CTI003*/
/*  needs to be re-set.                                              */                   /*CTI003*/
             CHGVAR     VAR(&FMT) VALUE(' ')                                              /*CTI003*/
             CALL       PGM(AOMMODR0) PARM(' ' '*FIRST' &FMT)                             /*CTI003*/
             IF         COND(%SST(&FMT 103 1) *EQ 'Y') THEN(DO)                           /*CTI003*/
/* Check which components have failed; this looks for component's module. */              /*CTI003*/
                CALL       PGM(TIC0016) PARM('TI' &REPLY)                                 /*CTI003*/
                IF         COND(&REPLY *EQ '*BOTH' *OR &REPLY *EQ +
                             '*NONE') THEN(DO)                                            /*CTI003*/
                   RTVMSG     MSGID(SCM0165) MSGF(MIDASMSG) +
                                MSG(&MESSAGE)                                             /*CTI003*/
                   CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                   /*CTI003*/
                   CHGDTAARA  DTAARA(MIDASMSG (18 1)) VALUE('1')                          /*CTI003*/
                   CHGVAR     VAR(&NOREPLY) VALUE(' ')                                    /*CTI003*/
                   CALL       PGM(SCC0010) PARM('SCC07' 'OPTION' +
                                &NOREPLY)                                                 /*CTI003*/
                                                                                          /*CTI003*/
/* If the user wishes to reopen TI as well. */                                            /*CTI003*/
                   IF         COND(&NOREPLY = 'Y') THEN(DO)                               /*CTI003*/
                      CHGVAR     VAR(&REOPTI) VALUE('Y')                                  /*CTI003*/
                   ENDDO                                                                  /*CTI003*/
                ENDDO                                                                     /*CTI003*/
                IF         COND(&REPLY *EQ '*ONLY') THEN(DO)                              /*CTI003*/
                   CHGVAR     VAR(&REOPTI) VALUE('Y')                                     /*CTI003*/
                ENDDO                                                                     /*CTI003*/
             ENDDO                                                                        /*CTI003*/
/**/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*S01420*/
             CHGVAR     VAR(&SARD) VALUE('S01420')                    /*S01420*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)     /*S01420*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*S01420*/
                DLCOBJ     OBJ((CBLOCK *DTAARA *EXCL))                /*S01420*/
                MONMSG     MSGID(CPF0000)                             /*S01420*/
                ALCOBJ     OBJ((CBLOCK *DTAARA *EXCL)) WAIT(5)        /*S01420*/
                MONMSG     MSGID(CPF1002) EXEC(DO)                    /*S01420*/
                   SNDPGMMSG  MSG('Re-open ended abnormally')         /*S01420*/
                   GOTO       CMDLBL(ENDPGM)                          /*S01420*/
                ENDDO                                                 /*S01420*/
                RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)             /*S01420*/
                RTVMSG     MSGID(CBM0133) MSGF(CBUSRMSG) MSGDTA(&USR) +
                             MSG(&MSG) SEV(&SEV)                      /*S01420*/
                CHGVAR     VAR(%SST(&PARM 1 7)) VALUE(&PRC)           /*S01420*/
                CHGVAR     VAR(%SST(&PARM 8 10)) VALUE(&USR)          /*S01420*/
                CHGVAR     VAR(%SST(&PARM 18 10)) VALUE(&JOB)         /*S01420*/
                CHGVAR     VAR(%SST(&PARM 28 6)) VALUE(&NBR)          /*S01420*/
                CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEV)          /*S01420*/
                CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MSG)        /*S01420*/
                CALL       PGM(CBC0525) PARM(&ALL &PARM)              /*S01420*/
             ENDDO                                                    /*S01420*/
                                                                      /*127256*/
/* Stop Midas/TI Batch Jobs               */                          /*127256*/
                                                                      /*127256*/
             IF         COND(%SST(&FMT 103 1) *EQ 'Y') THEN(CALL +
                          PGM(TIC0050) PARM('STOP'))                  /*127256*/
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),*******         */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/* */                                                                 /*S01435*/
/* End Journalling for Task Split Components */                       /*CCB003*/
                                                                      /*CCB003*/
/**********  CALL       PGM(SCENDTSJRN)                                         */ /*CCB003 CCB020*/
                                                                      /*CCB003*/
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                        */ /*CCB003 CCB020*/
/**********  GOTO       CMDLBL(ENDPGM)                                          */ /*CCB003 CCB020*/
/**********  ENDDO                                                              */ /*CCB003 CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
                                                                      /*CCB003*/
/* Delete I.M.M. Journal Environment */                               /*S01435*/
/* */                                                                 /*S01435*/
             CALL       PGM(MEC1210) PARM('MEC1200' X'00001F')        /*S01435*/
/* */                                                                 /*S01435*/
/* */                                                                 /*S01522*/
/*  Access PF/SDMMODPD to determine which modules are live  */        /*S01522*/
/* */                                                                 /*S01522*/
             CHGVAR     VAR(&RTCD) VALUE(' ')                         /*S01522*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*S01522*/
             CHGVAR     VAR(&FMT) VALUE(' ')                          /*S01522*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*S01522*/
/**********                                                                    /*S01522*/ /*CPK014*/
/**Delete*U.D.C.*Journal*Environment**/                                        /*S01522*/ /*CPK014*/
/**********                                                                    /*S01522*/ /*CPK014*/
/**********  IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)  */            /*S01522*/ /*CPK014*/
/**********  CALL       PGM(CGC2010) PARM('CGC2000' X'00001F')   */            /*S01522*/ /*CPK014*/
/**********  ENDDO                                               */            /*S01522*/ /*CPK014*/
/* */                                                                 /*S01522*/
/* Clear Compliance Watch Data Queues */                                                  /*222005*/
                                                                                          /*222005*/
             CALL       QCLRDTAQ PARM(SDCWEDTQ *LIBL)                                     /*222005*/
             CALL       QCLRDTAQ PARM(SDCWMDTQ *LIBL)                                     /*222005*/
             CALL       QCLRDTAQ PARM(SDCWSDTQ *LIBL)                                     /*222005*/
                                                                                          /*222005*/
/** Stop the SCC2470MON journal save process */                                         /*AR855839*/
                                                                                        /*AR855839*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                             /*AR855839*/
             CHGVAR     VAR(&DATAQL) VALUE(&SYSID *CAT 'XLIB')                          /*AR855839*/
             CHGVAR     VAR(&MESS) VALUE('STOP      ')                                  /*AR855839*/
             CALL       PGM(QSNDDTAQ) PARM(&DATAQN &DATAQL &DLEN +
                           &MESS)                                                       /*AR855839*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                  /*AR855839*/
                                                                                        /*AR855839*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)
             CHGVAR     VAR(&VOL1) VALUE(%SST(&JOEDS 126 5))
             CHGVAR     VAR(&SAVD) VALUE(%SST(&JOEDS 151 4))          /*E23979*/
/*/COPY WNCPYSRC,SCC07009                                            */
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),*******         */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**********  ENDJRNPF   FILE(*ALL) JRN(ICJRN)                                   */ /*092729 CCB020*/
/**********  MONMSG     MSGID(CPF7032 CPC7033)                                  */ /*092729 CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
/*/COPY WNCPYSRC,SCC07010                                            */
/**/
/*  RESTORE THE DATABASE FROM APPROPRIATE MEDIUM                     */
/**/                                                                  /*S01421*/
/*  IF THE RESTORE FROM DISK FLAG ON JNSTAT IS 'Y' */                 /*S01421*/
/*  CHANGE THE VALUE OF THE SAVE PARAMETER TO DISK */                 /*S01421*/
/**/                                                                  /*S01421*/
             IF         COND(&SAVD *NE 'DISK') THEN(DO)               /*S01421*/
                RTVDTAARA  DTAARA(JNSTAT (171 1)) RTNVAR(&RSTSAV)     /*S01421*/
                IF         COND(&RSTSAV *EQ 'Y') THEN(CHGVAR +
                           VAR(&SAVD) VALUE('DISK'))                  /*S01421*/
             ENDDO                                                    /*S01421*/
                                                                      /*S01408*/
             CHGVAR     VAR(&SARD) VALUE('ULX043')                                        /*CER001*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                        /*CER001*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*CER001*/
             CHGVAR     VAR(&ULX043) VALUE('N')                                           /*CER001*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                         /*CER001*/
             IF         COND(&RTN *EQ '       ') THEN(CHGVAR +
                        VAR(&ULX043) VALUE('Y'))                                          /*CER001*/
/*/COPY WNCPYSRC,SCC07001                                            */
                                                                      /*S01408*/
/** Ensure that file is deleted to allow restore */                                       /*CER001*/
                                                                                          /*CER001*/
             IF         COND(&ULX043 *EQ 'Y') THEN(DO)                                    /*CER001*/
                        CHGVAR     VAR(&LIB1) VALUE(&LIBID *CAT 'DMLIB')                  /*CER001*/
                        DLTF       FILE(&LIB1/ILDATAPD)                                   /*CER001*/
                        MONMSG     MSGID(CPF0000 CPF2105)                                 /*CER001*/
             ENDDO                                                                        /*CER001*/
/**/
/* FOLLOWING CHANGED FOR DI LIBRARY SAVE FILE */                      /*S01098*/
/**/                                                                  /*S01098*/
                CHGVAR     VAR(&LIB1) VALUE(&LIBID *CAT 'DMLIB')      /*085307*/
                CHGVAR     VAR(&DVLIB) VALUE(&LIBID *CAT 'DVLIB')     /*085307*/
                CHGVAR     VAR(&LIB2) VALUE(&LIBID *CAT 'DILIB')      /*085307*/
                CHGVAR     VAR(&DTALIB) VALUE(&LIBID *CAT 'DTALIB')                       /*CSC012*/
/**/                                                                  /*085307*/
             ALCOBJ     OBJ((&DVLIB *LIB *EXCLRD)) WAIT(10)           /*085307*/
/**/                                                                  /*085307*/
/************IF   COND(&VOL1 *EQ 'DISK') THEN(DO) **/      /*S01098*/ /*E23979*/
             IF   COND(&SAVD *EQ 'DISK') THEN(DO)                     /*E23979*/
/**/                                                                  /*S01098*/
/************CHGVAR VAR(&LIB1) VALUE(&LIBID *CAT'DMLIB')*/ /*S01098*/ /*085307*/
/************CHGVAR VAR(&DVLIB) VALUE(&LIBID*CAT'DVLIB')*/ /*056290*/ /*085307*/
/************CHGVAR VAR(&LIB2) VALUE(&LIBID*CAT'DILIB')*/ /*S01098*/  /*085307*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC07MP1                                            */
                                                                      /*S01408*/
/**/                                                                  /*S01098*/
/************ALCOBJ OBJ((&DVLIB *LIB *EXCLRD)) WAIT(10)*/ /*056290*/  /*085307*/
/**********      RSTLIB  SAVLIB(&LIB1) DEV(*SAVF) SAVF(&LIB2/DBIC) + */        /*S01098*/ /*207764*/
                                                                               /*S01098*/
/**********      RSTLIB  SAVLIB(&DTALIB) DEV(*SAVF) SAVF(&LIB2/DBICDTA) */     /*CSC012*/ /*207764*/
             IF  COND(&CAS005 *EQ 'Y') THEN(DO)                                           /*CAS005*/
             RMVM       FILE(&LIB1/DLHNPLPD) MBR(*ALL)                                    /*CAS005*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS005*/
                                                                                          /*CAS005*/
             RMVM       FILE(&LIB1/MMHNPAPD) MBR(*ALL)                                    /*CAS005*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS005*/
                                                                                          /*CAS005*/
             RMVM       FILE(&LIB1/MMHNPLPD) MBR(*ALL)                                    /*CAS005*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS005*/
                                                                                          /*CAS005*/
             RMVM       FILE(&LIB1/IRHNPAPD) MBR(*ALL)                                    /*CAS005*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS005*/
                                                                                          /*CAS005*/
             RMVM       FILE(&LIB1/IRHNPBPD) MBR(*ALL)                                    /*CAS005*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS005*/
                                                                                          /*CAS005*/
             RMVM       FILE(&LIB1/RXHNPAPD) MBR(*ALL)                                    /*CAS005*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS005*/
                                                                                          /*CAS005*/
             RMVM       FILE(&LIB1/RXHNPBPD) MBR(*ALL)                                    /*CAS005*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS005*/
                                                                                          /*CAS005*/
             RMVM       FILE(&LIB1/LEHNPAPD) MBR(*ALL)                                    /*CAS005*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS005*/
                                                                                          /*CAS005*/
             RMVM       FILE(&LIB1/LEHNPLPD) MBR(*ALL)                                    /*CAS005*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS005*/
/**********  RSTOBJ     OBJ(DLHNPLPD MMHNPAPD MMHNPLPD IRHNPAPD +*/                    /*AR1093685*/
/**********               IRHNPBPD RXHNPAPD RXHNPBPD LEHNPAPD +  */                    /*AR1093685*/
/**********               LEHNPLPD) SAVLIB(&LIB1) DEV(*SAVF) +   */                    /*AR1093685*/
/**********               SAVF(&LIB2/DBIC) MBROPT(*ALL)          */             /*CAS005 AR1093685*/
             RSTOBJ     OBJ(DLHNPLPD MMHNPAPD MMHNPLPD IRHNPAPD +
                          IRHNPBPD RXHNPAPD RXHNPBPD LEHNPAPD +
                          LEHNPLPD) SAVLIB(&LIB1) DEV(*SAVF) +
                          SAVF(&LIB2/DBICDM) MBROPT(*ALL)                              /*AR1093685*/
             ENDDO                                                                        /*CAS005*/
                                                                                          /*CAS006*/
             IF  COND(&CAS006 *EQ 'Y') THEN(DO)                                           /*CAS006*/
             RMVM       FILE(&LIB1/FRHNPAPD) MBR(*ALL)                                    /*CAS006*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS006*/
                                                                                          /*CAS006*/
             RMVM       FILE(&LIB1/FRHNPLPD) MBR(*ALL)                                    /*CAS006*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS006*/
                                                                                          /*CAS006*/
             RMVM       FILE(&LIB1/SEHMKAPD) MBR(*ALL)                                    /*CAS006*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS006*/
                                                                                          /*CAS006*/
             RMVM       FILE(&LIB1/SEHMKLPD) MBR(*ALL)                                    /*CAS006*/
             MONMSG     MSGID(CPF5815 CPF7303 CPF7301)                                    /*CAS006*/
/**********  RSTOBJ     OBJ(FRHNPAPD FRHNPLPD SEHMKAPD SEHMKLPD) +*/                   /*AR1093685*/
/**********               SAVLIB(&LIB1) DEV(*SAVF) +              */                   /*AR1093685*/
/**********               SAVF(&LIB2/DBIC) MBROPT(*ALL)           */            /*CAS006 AR1093685*/
             RSTOBJ     OBJ(FRHNPAPD FRHNPLPD SEHMKAPD SEHMKLPD) +
                          SAVLIB(&LIB1) DEV(*SAVF) +
                          SAVF(&LIB2/DBICDM) MBROPT(*ALL)                              /*AR1093685*/
             ENDDO                                                                        /*CAS006*/
                                                                                       /*BUG26305A*/
/* Retrieve from KESTAT the end of tax year, end of tax year date, rundate*/           /*BUG26305A*/
             RTVDTAARA  DTAARA(KESTAT (66 2)) RTNVAR(&YY)                              /*BUG26305A*/
             RTVDTAARA  DTAARA(KESTAT (73 5)) RTNVAR(&ENDTXYR)                         /*BUG26305A*/
             RTVDTAARA  DTAARA(KESTAT (78 5)) RTNVAR(&RUNDAT)                          /*BUG26305A*/
                                                                                         /*BUG4841*/
/*****End*global*background*job**/                                             /*BUG4841 BUG26305A*/
/**********/                                                                   /*BUG4841 BUG26305A*/
/**********  CALL       PGM(GOC0002) PARM('END  ' '*LIBL     ' '1')  */        /*BUG4841 BUG26305A*/
                                                                                         /*BUG4841*/
             CALL       PGM(GOC0002) PARM('END  ' '*LIBL     ' '1')                      /*BUG4841*/
                                                                                         /*BUG4841*/
/*****KILL*OBJECT*LOCKS*IN*COB*/                                                /*237463 BUG26305A*/
/**********/                                                                    /*237463 BUG26305A*/
/**********  CALL       PGM(SCKOBJLCB)                               */         /*237463 BUG26305A*/
/**********/                                                                    /*237463 BUG26305A*/
/**********  RMVM       FILE(&DVLIB/SDINPHL0) MBR(*ALL)              */       /*BUG25489 BUG26305A*/
/**********  MONMSG     MSGID(CPF0000)                               */       /*BUG25489 BUG26305A*/
/**********/                                                                  /*BUG25489 BUG26305A*/
/**********  RMVM       FILE(&DVLIB/SDINPHL1) MBR(*ALL)              */       /*BUG25489 BUG26305A*/
/**********  MONMSG     MSGID(CPF0000)                               */       /*BUG25489 BUG26305A*/
/**********/                                                                  /*BUG25489 BUG26305A*/
/**********  RMVM       FILE(&DVLIB/SDINPHL2) MBR(*ALL)              */       /*BUG25489 BUG26305A*/
/**********  MONMSG     MSGID(CPF0000)                               */       /*BUG25489 BUG26305A*/
/**********/                                                                  /*BUG25489 BUG26305A*/
/**********  RMVM       FILE(&DVLIB/SDINPHL3) MBR(*ALL)              */       /*BUG25489 BUG26305A*/
/**********  MONMSG     MSGID(CPF0000)                               */       /*BUG25489 BUG26305A*/
/**********                                                          */       /*BUG26305 BUG26305A*/
/***Read*SDBANKPD*to*retrieve*Country*Code,Runday*number,*Date*of***/         /*BUG26305 BUG26305A*/
/***Next*Working*Day*&*Date*Format*Indicator************************/         /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/**********  RCVF      RCDFMT(SDBANKD0)                              */       /*BUG26305 BUG26305A*/
/**********                                                          */       /*BUG26305 BUG26305A*/
/** Call AOCTRYR0 (Access Country code to retrieve Tax Enddate */             /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/**********  CALL      PGM(AOCTRYR0) PARM(&PRTNCODE &POPTN +         */                /*BUG26305A*/
/**********              &BJCNCD &PFMT)                              */       /*BUG26305 BUG26305A*/
/**********  IF         COND(&PRTNCODE *NE ' ') THEN(GOTO +          */                /*BUG26305A*/
/**********                CMDLBL(ABNOR))                            */       /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&WTxEndC) VALUE(%SST(&PFMT 74 4))        */       /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&WTxEndT) VALUE(&WTxEndC)                */       /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/**********  IF         COND(&WTxEndt *EQ 0) THEN(DO)                */       /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/**********  IF         COND(&BJDFIN *EQ 'D') THEN(DO)               */       /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&WMmYy) VALUE('3112')                    */       /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&PDATEIN) VALUE(&WMmYy  *TCAT +          */                /*BUG26305A*/
/**********               (%SST(&BJMRDT 6 2)))                       */       /*BUG26305 BUG26305A*/
/**********  ENDDO                                                   */       /*BUG26305 BUG26305A*/
/**********  ELSE       CMD(DO)                                      */       /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&WMmYy) VALUE('1231')                    */       /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&PDATEIN) VALUE(&WMmYy  *TCAT +          */                /*BUG26305A*/
/**********               (%SST(&BJMRDT 6 2)))                       */       /*BUG26305 BUG26305A*/
/**********  ENDDO                                                   */       /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/**********  ENDDO                                                   */       /*BUG26305 BUG26305A*/
/**********  ELSE       CMD(DO)                                      */       /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&PDATEIN) VALUE(&WTxEndC *TCAT +         */                /*BUG26305A*/
/**********               (%SST(&BJMRDT 6 2)))                       */       /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/**********  ENDDO                                                   */       /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/** Call ZDATE1 (Convert to day number) */                                    /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&PRTNCODE) VALUE(' ')                    */       /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&ZDateIn) VALUE(&PDateIn)                */       /*BUG26305 BUG26305A*/
/**********  CALL      PGM(ZDATE1) PARM(&PRTNCODE &ZDateIn +         */                /*BUG26305A*/
/**********                          &BJDFIN &PDayNo)                */       /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/**********  IF         COND(&PRTNCODE *NE ' ') THEN(GOTO +          */                /*BUG26305A*/
/**********             CMDLBL(ABNOR))                               */       /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/** Check if this is an End of Tax Year run */                                /*BUG26305 BUG26305A*/
/**********  IF         COND((&PDayNo *GE &BJRDNB) *AND (&PDayNo *LT +*/      /*BUG26305 BUG26305A*/
/**********               &BJDNWD)) THEN(DO)                         */       /*BUG26305 BUG26305A*/
/**********/                                                                  /*BUG26305 BUG26305A*/
/** Retrieve the year from Midas Run Date */                                  /*BUG26305 BUG26305A*/
/**********                                                                   /*BUG26305 BUG26305A*/
/**********  CHGVAR     VAR(&YY) VALUE(%SST(&BJMRDT 6 2))                     /*BUG26305 BUG26305A*/
/**********                                                                   /*BUG26305 BUG26305A*/
                                                                                        /*AR680192*/
/** Check if the CER048 Feature is on */                                                /*AR680192*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                      /*AR680192*/
             CHGVAR     VAR(&SARD) VALUE('CER048')                                      /*AR680192*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                      /*AR680192*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                       /*AR680192*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                               /*AR680192*/
                                                                                       /*BUG26305A*/
             IF         COND(&ENDTXYR = &RUNDAT) THEN(DO)                              /*BUG26305A*/
                                                                                       /*BUG26305A*/
             CHGVAR     VAR(&MBRNAME) VALUE('SDINPHPD' *CAT &YY)                        /*BUG26305*/
             CHGVAR     VAR(&MBRNAMELF0) VALUE('SDINPHL0' *CAT &YY)                    /*BUG26305A*/
             CHGVAR     VAR(&MBRNAMELF1) VALUE('SDINPHL1' *CAT &YY)                    /*BUG26305A*/
             CHGVAR     VAR(&MBRNAMELF2) VALUE('SDINPHL2' *CAT &YY)                    /*BUG26305A*/
             CHGVAR     VAR(&MBRNAMELF3) VALUE('SDINPHL3' *CAT &YY)                    /*BUG26305A*/
                                                                                       /*BUG26305A*/
/* Check if SDINPH objects with current tax year end member are already existing */    /*BUG26305A*/
                                                                                        /*BUG26305*/
             CHKOBJ     OBJ(&LIB1/SDINPHPD) OBJTYPE(*FILE) +
                          MBR(&MBRNAME)                                                 /*BUG26305*/
             MONMSG     MSGID(CPF9815) EXEC(CHGVAR VAR(&PCRDTA) +
                          VALUE('Y'))                                                   /*BUG26305*/
                                                                                        /*BUG26305*/
             CHKOBJ     OBJ(&DVLIB/SDINPHL0) OBJTYPE(*FILE) +
                          MBR(&MBRNAMELF0)                                             /*BUG26305A*/
             MONMSG     MSGID(CPF9815) EXEC(CHGVAR VAR(&PCRDTA) +
                          VALUE('Y'))                                                  /*BUG26305A*/
                                                                                       /*BUG26305A*/
             CHKOBJ     OBJ(&DVLIB/SDINPHL1) OBJTYPE(*FILE) +
                          MBR(&MBRNAMELF1)                                             /*BUG26305A*/
             MONMSG     MSGID(CPF9815) EXEC(CHGVAR VAR(&PCRDTA) +
                          VALUE('Y'))                                                  /*BUG26305A*/
                                                                                       /*BUG26305A*/
             CHKOBJ     OBJ(&DVLIB/SDINPHL2) OBJTYPE(*FILE) +
                          MBR(&MBRNAMELF2)                                             /*BUG26305A*/
             MONMSG     MSGID(CPF9815) EXEC(CHGVAR VAR(&PCRDTA) +
                          VALUE('Y'))                                                  /*BUG26305A*/
                                                                                       /*BUG26305A*/
             CHKOBJ     OBJ(&DVLIB/SDINPHL3) OBJTYPE(*FILE) +
                          MBR(&MBRNAMELF3)                                             /*BUG26305A*/
             MONMSG     MSGID(CPF9815) EXEC(CHGVAR VAR(&PCRDTA) +
                          VALUE('Y'))                                                  /*BUG26305A*/
                                                                                       /*BUG26305A*/
/* If object with tax year end member already exists, remove the member */             /*BUG26305A*/
                                                                                       /*BUG26305A*/
             IF         COND(&PCRDTA *NE 'Y') THEN(DO)                                  /*BUG26305*/
                        RMVM FILE(&DVLIB/SDINPHL0) MBR(&MBRNAMELF0)                    /*BUG26305A*/
                        MONMSG MSGID(CPF0000)                                          /*BUG26305A*/
                        RMVM FILE(&DVLIB/SDINPHL1) MBR(&MBRNAMELF1)                    /*BUG26305A*/
                        MONMSG MSGID(CPF0000)                                          /*BUG26305A*/
                        RMVM FILE(&DVLIB/SDINPHL2) MBR(&MBRNAMELF2)                    /*BUG26305A*/
                        MONMSG MSGID(CPF0000)                                          /*BUG26305A*/
                        RMVM FILE(&DVLIB/SDINPHL3) MBR(&MBRNAMELF3)                    /*BUG26305A*/
                        MONMSG MSGID(CPF0000)                                          /*BUG26305A*/
                        RMVM FILE(&LIB1/SDINPHPD) MBR(&MBRNAME)                         /*BUG26305*/
                        MONMSG MSGID(CPF0000)                                           /*BUG26305*/
             ENDDO                                                                      /*BUG26305*/
                                                                                        /*BUG26305*/
             ENDDO                                                                      /*BUG26305*/
             ENDDO                                                                      /*AR680192*/
                                                                                        /*BUG25489*/
/**********  RMVM       FILE(&LIB1/SDINPHPD) MBR(*ALL) */                  /*BUG25489*/ /*BUG26305*/
/**********  MONMSG     MSGID(CPF0000)                 */                  /*BUG25489*/ /*BUG26305*/
                                                                                        /*BUG25489*/
/* End global background job */                                                        /*BUG26305A*/
                                                                                       /*BUG26305A*/
             CALL       PGM(GOC0002) PARM('END  ' '*LIBL     ' '1')                    /*BUG26305A*/
                                                                                       /*BUG26305A*/
/* Kill object locks in COB*/                                                          /*BUG26305A*/
                                                                                       /*BUG26305A*/
/**********  CALL       PGM(SCKOBJLCB)                             */          /*BUG26305A CCB023A*/
             CALL       PGM(SCKOBJLCB) PARM('Y')                                         /*CCB023A*/
                                                                                       /*BUG26305A*/
/* Restore database */                                                                   /*BUG4841*/
                                                                                         /*BUG4841*/
/* Check switch CSC032 */                                                                 /*CSC032*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'CSC032')                              /*CSC032*/

             IF         COND(&PRTCD *EQ ' ') THEN(DO)                                     /*CSC032*/

             CHGVAR (&CSC032) VALUE('Y')                                                  /*CSC032*/

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYS)                                 /*CSC032*/
                                                                                          /*CSC032*/
             CHGVAR     VAR(&DLIB) VALUE(&SYS *CAT 'DPLIB')                               /*CSC032*/

             CHGVAR     VAR(&RSTCMPL) VALUE('N')                                          /*CSC032*/

             CHGDTAARA  DTAARA(&DLIB/SCC5140DA (1 1)) +
                          VALUE(&RSTCMPL) /*CSC032*/
             CHGDTAARA  DTAARA(&DLIB/SCC5140DA (2 26)) VALUE(' ') +
                          /*249135*/

             SBMJOB     JOB(SCC5140) JOBD(MBATCH) JOBPTY(4) +
                          OUTQ(*JOBD) USER(*JOBD) RQSDTA('CALL +
                          PGM(SCC5140)') INLLIBL(*JOBD) /*CSC032*/
                                                                                          /*CSC032*/
             ENDDO                                                                        /*CSC032*/
                                                                                          /*CSC032*/
             IF         COND(&CSC032 = 'Y') THEN(DO)
CHKCMPLFL:                                                                                /*CSC032*/
             DLYJOB     DLY(15)                                                           /*CSC032*/
                                                                                          /*CSC032*/
             RTVDTAARA  DTAARA(&DLIB/SCC5140DA (1 1)) +
                          RTNVAR(&RSTCMPL)                                                /*CSC032*/
             IF         COND(&RSTCMPL = 'N') THEN(DO)                                     /*CSC032*/

             RTVDTAARA  DTAARA(&DLIB/SCC5140DA (2 26)) RTNVAR(&JOB5140)                   /*249135*/
             IF         COND(&JOB5140 = ' ') THEN(GOTO +
                          CMDLBL(CHKCMPLFL)) /*249135*/

             CALL       PGM(QUSRJOBI) PARM(&JOBINFO &DTALEN &FORMAT +
                          &JOB5140 &INTJOBID &ERRDTA) /*249135*/
             CHGVAR     VAR(&JOBSTS) VALUE(%SST(&JOBINFO 51 10))                          /*249135*/
             IF         COND(&JOBSTS *EQ *OUTQ) THEN(DO)                                  /*249135*/

             CHGVAR     VAR(&JOBNAME) VALUE(%SST(&JOB5140 1 10))                          /*249135*/
             CHGVAR     VAR(&JOBUSER) VALUE(%SST(&JOB5140 11 10))                         /*249135*/
             CHGVAR     VAR(&JOBNBR) VALUE(%SST(&JOB5140 21 6))                           /*249135*/
             SNDUSRMSG  MSG('Job' *BCAT &JOBNBR *CAT '/' *TCAT +
                          &JOBUSER *TCAT '/' *TCAT &JOBNAME *BCAT +
                          'failed. Please enter "r"to re-submit +
                          when ready before I/C can be re-opened.') +
                          VALUES('R' 'r') MSGTYPE(*INQ) +
                          TOMSGQ(*SYSOPR) MSGRPY(&RPY) /*249135*/

             CHGDTAARA  DTAARA(&DLIB/SCC5140DA (2 26)) VALUE(' ') +
                          /*249135*/
             SBMJOB     JOB(SCC5140) JOBD(MBATCH) JOBPTY(4) +
                          OUTQ(*JOBD) USER(*JOBD) RQSDTA('CALL +
                          PGM(SCC5140)') INLLIBL(*JOBD) /*249135*/

             ENDDO                                                                        /*249135*/

             GOTO       CMDLBL(CHKCMPLFL) /*249135*/
             ENDDO                                                                        /*CSC032*/
                                                                                          /*CSC032*/
             ENDDO                                                                        /*CSC032*/
/* Kill object locks in COB*/                                                             /*240226*/
                                                                                          /*240226*/
/**********  CALL       PGM(SCKOBJLCB)                             */             /*240226 CCB023A*/
             CALL       PGM(SCKOBJLCB) PARM('Y')                                         /*CCB023A*/
                                                                                          /*240226*/
/** Call SCC000203 to perform BF database restore*/                                       /*CBF002*/
/** restore BF schemas found in Schemas/Libraries file */                                 /*CBF002*/
                                                                                          /*CBF002*/
             CHGVAR     VAR(&PRFK) VALUE('018')                                           /*CBF002*/
             CALL       PGM(SCC000203) PARM(&PRFK)                                        /*CBF002*/
                                                                                          /*CBF002*/
/**********      RSTLIB     SAVLIB(&LIB1) DEV(*SAVF) SAVF(&LIB2/DBIC) +*/              /*AR1093685*/
/**********                   OUTPUT(*PRINT)                           */       /*207764 AR1093685*/
                 RSTLIB     SAVLIB(&LIB1) DEV(*SAVF) SAVF(&LIB2/DBICDM) +
                              OUTPUT(*PRINT)                                           /*AR1093685*/
                 RSTLIB     SAVLIB(&DTALIB) DEV(*SAVF) +
                              SAVF(&LIB2/DBICDTA) OUTPUT(*PRINT)                          /*207764*/
                                                                                          /*CBF002*/
/**********  IF         COND(&CRE026 *EQ 'Y') THEN(DO)             */            /*BUG12169 CCB022*/
/*******************************************************************/           /*BUG14179A CCB022*/
/**********  CHGVAR     VAR(&KJRNLIB) VALUE('K@JR' *CAT &KAPUNMNM) */           /*BUG14179A CCB022*/
/**********  CHGVAR     VAR(&KJRN) VALUE('KJR' *CAT &KAPUNMNM)     */           /*BUG14179A CCB022*/
/**********  ENDJRNPF   FILE(*ALL) JRN(&KJRNLIB/&KJRN)             */           /*BUG14179A CCB022*/
/**********  MONMSG     MSGID(CPF7032 CPF6959)                     */           /*BUG14179A CCB022*/
/*******************************************************************/           /*BUG14179A CCB022*/
/**********  CLRLIB     LIB(&LIB3)                                 */            /*BUG14879 CCB022*/
/**********  CLRLIB     LIB(&LIB5)                                 */            /*BUG14879 CCB022*/
/**********  CLRLIB     LIB(&LIB6)                                 */            /*BUG14879 CCB022*/
/**********  CLRLIB     LIB(&LIB4)                                 */            /*BUG14879 CCB022*/
/**********  RSTOBJ     OBJ(KAPUNMNM) SAVLIB(&LIB4) DEV(*SAVF) +   */                     /*CCB022*/
/**********               SAVF(&LIB2/DBICEQLIB)                    */            /*BUG14879 CCB022*/
/*******************************************************************/            /*BUG14879 CCB022*/
/**********      RSTLIB     SAVLIB(&LIB3) DEV(*SAVF) SAVF(&LIB2/DBICEQFIL) +*/            /*CCB022*/
/**********                   OUTPUT(*PRINT)                       */            /*BUG12169 CCB022*/
/**********      RSTLIB     SAVLIB(&LIB4) DEV(*SAVF) SAVF(&LIB2/DBICEQLIB) +*/            /*CCB022*/
/**********                   OUTPUT(*PRINT)                       */            /*BUG12169 CCB022*/
/**********      RSTLIB     SAVLIB(&LIB5) DEV(*SAVF) SAVF(&LIB2/DBICEQOPT) +*/            /*CCB022*/
/**********                   OUTPUT(*PRINT)                       */            /*BUG12169 CCB022*/
/**********      RSTLIB     SAVLIB(&LIB6) DEV(*SAVF) SAVF(&LIB2/DBICEQINP) +*/            /*CCB022*/
/**********                   OUTPUT(*PRINT)                       */            /*BUG14179 CCB022*/
/*******************************************************************/            /*BUG14879 CCB022*/
/**********      CHGDTAARA  DTAARA(&LIB4/KAPPHS) VALUE('DAY')      */            /*BUG14879 CCB022*/
/**********      DLTDTAARA  DTAARA(&LIB4/NXTPHS)                   */            /*BUG14879 CCB022*/
/**********      MONMSG     MSGID(CPF9801)                         */            /*BUG14879 CCB022*/
/*******************************************************************/            /*BUG14879 CCB022*/
/**********  ENDDO                                                 */            /*BUG12169 CCB022*/
                                                                      /*S01408*/
             IF COND((&CSW025 *EQ 'Y') *AND (&MNGSYS *EQ 'Y')) +
                        THEN(DO)                                                          /*CSW025*/
                RTVDTAARA  DTAARA(MESTAT (9 10)) RTNVAR(&LIBTOSAVE)                       /*CSW025*/
                RTVDTAARA  DTAARA(MESTAT (19 10)) RTNVAR(&SAVEFILE)                       /*CSW025*/
/**********  RSTLIB     SAVLIB(&LIBTOSAVE) DEV(*SAVF) + */                     /*CSW025*/ /*207764*/
/**********               SAVF(&LIB2/&SAVEFILE)         */                     /*CSW025*/ /*207764*/
             RSTLIB     SAVLIB(&LIBTOSAVE) DEV(*SAVF) +
                          SAVF(&LIB2/&SAVEFILE) OUTPUT(*PRINT)                            /*207764*/
             ENDDO                                                                        /*CSW025*/
/*/COPY WNCPYSRC,SCC07MP4                                            */
                                                                      /*S01408*/
/**/                                                                  /*S01098*/
/*  CLEAR MASTER FILES                                           */   /*S01098*/
/**/                                                                  /*S01098*/
/*              CALL       SDC1701 PARM(&LIB1)                   */   /*S01098*/
/*              IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)      */   /*S01098*/
/*                 CHGVAR     VAR(&ERROR) VALUE('1')             */   /*S01098*/
/*                 GOTO       END                                */   /*S01098*/
/*              ENDDO                                            */   /*S01098*/
/**/                                                                  /*S01098*/
/*  COPY MASTER FILES FROM BACKUP LIBRARY TO 'DM' LIBRARY        */   /*S01098*/
/**/                                                                  /*S01098*/
/*              CALL       SDC1702 PARM(&LIB2 &LIB1)             */   /*S01098*/
/*              IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)      */   /*S01098*/
/*                 CHGVAR     VAR(&ERROR) VALUE('1')             */   /*S01098*/
/*                 GOTO       END                                */   /*S01098*/
/*              ENDDO                                               *  *S01098*/
             ENDDO
/**/
/*  CALL SDC1721 IF RESTORING FROM TAPE/DISKETTE                     */
/**/
/************IF   COND(&VOL1 *NE 'DISK') THEN(DO) ***/                /*E23979*/
             IF   COND(&SAVD *NE 'DISK') THEN(DO)                     /*E23979*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC07MP2                                            */
                                                                      /*S01408*/
                CALL       SDC1721 PARM(&VOL1 &LIBID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC07MP3                                            */
                                                                      /*S01408*/
                IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   CHGVAR     VAR(&ERROR) VALUE('1')
                   GOTO       END
                ENDDO
             ENDDO
/**/
/*   CALL SDC1724, TO OPEN AND CLOSE ALL LOGICAL FILES,             ****E14941*/
/*   IF RESTORING FROM DISK.                                        ****E14941*/
/**/                                                                  /*E14941*/
/************IF   COND(&VOL1 *EQ 'DISK') THEN(DO)          /*E14941*/ /*E23979*/
             IF   COND(&SAVD *EQ 'DISK') THEN(DO)                     /*E23979*/
/*           CALL       PGM(SDC1724)                               */ /*E14941*/
             CALL       PGM(SDC1774)                                  /*E13205*/
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)        /*E14941*/
                      CHGVAR     VAR(&ERROR) VALUE('1')               /*E14941*/
                      GOTO       END                                  /*E14941*/
                   ENDDO                                              /*E14941*/
             ENDDO
                                                                                         /*BUG4841*/
/* Start global background job */                                                        /*BUG4841*/
                                                                                         /*BUG4841*/
             CALL       PGM(GOC0002) PARM('START' '*LIBL     ' '1')                      /*BUG4841*/
                                                                                         /*BUG4841*/
/*    Clear General Ledger Daily files.                              */
/**/
                   CALL       SCCLRGL
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/**If*S01411*is*in*the*system,*clear**/                                            /*068922 CSC048*/
/**Business*Transaction*daily*files**/                                             /*068922 CSC048*/
/**/
/**********  CHGVAR     VAR(&RTN) VALUE('       ')                   */            /*068922 CSC048*/
/**********  CHGVAR     VAR(&OPN) VALUE('*VERIFY')                   */            /*068922 CSC048*/
/**********  CHGVAR     VAR(&SARD) VALUE('S01411')                   */            /*068922 CSC048*/
/**/
/**********  CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)    */            /*068922 CSC048*/
/**********  IF         COND(&RTN *EQ '       ') THEN(DO)            */            /*068922 CSC048*/
                CALL SCCLRBT                                          /*068922*/
/**********  ENDDO                                                   */            /*068922 CSC048*/
/**/
/*    Clear Dealing Daily files.                                     */
/**/
/****************  RCVDTAARA  DTAARA(MMOD)                          *  *S01179*/
                   RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)              /*S01179*/
/**/
/******************IF*******COND((%SUBSTRING(&MMOD*2*1))**EQ*'Y')*+*/ /*S01319*/
/*****************************THEN(CALL*PGM(SCCLRDL))***************/ /*S01319*/
                   IF         COND((%SUBSTRING(&MMOD 2 1)) *EQ 'Y') +
                              THEN(DO)                                /*S01319*/
                              CALL       PGM(SCCLRDL)                 /*S01319*/
                              CALL       PGM(SCCLRFX)                 /*S01319*/
                              CALL       PGM(SCCLRMM)                 /*S01319*/
                              ENDDO                                   /*S01319*/

                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/*   Clear Retail Daily files.                                       */
/**/
                   IF         COND(%SST(&MMOD 16 1) *EQ 'Y') +
                              THEN(CALL PGM(SCCLRRE))
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
/****Clear*Commercial*Loans*Daily*files.*************                 /*S01343*/
/*****/                                                               /*S01343*/
/*****             IF         COND((%SUBSTRING(&MMOD 4 1)) *EQ 'Y') + /*S01343*/
/*****                        THEN(CALL PGM(SDCLRCL))                 /*S01343*/
/*****             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)  /*S01343*/
/**/
/***Call*SCCLRFD*for*D.R.S.*Users*******Amendment*F00070*****S01133*/ /*S01319*/
/************************************************************S01133*/ /*S01319*/
/************IF*********COND((%SUBSTRING(&MMOD*11*1))**EQ*'Y')*+****/ /*S01319*/
/**************************THEN(CALL*PGM(SCCLRFD))***********S01133*/ /*S01319*/
             CALL       PGM(SCCLRFD)                                  /*S01319*/
/**/                                                                  /*S01133*/
/***Call*SCCLRFX*for*D.R.S.*Users*******Amendment*F00070*****S01133*/ /*S01319*/
/************************************************************S01133*/ /*S01319*/
/************IF*********COND((%SUBSTRING(&MMOD*13*1))**EQ*'Y')*+****/ /*S01319*/
/**************************THEN(CALL*PGM(SCCLRFX))***********S01133*/ /*S01319*/
/**/                                                                  /*S01145*/
/****CLEAR*ARBITRAGE*DAILY*FILES*************************/ /*S01145*/ /*S01319*/
/************IF*********COND((%SUBSTRING(&MMOD*19*1))**EQ*'Y')*+****/ /*S01319*/
/***************************THEN(CALL*PGM(SCCLRAB))******/ /*S01145*/ /*S01319*/

/****Clear*Securities*Trading*Daily*files*****                       * *S01117*/
/**/                                                                  /*S01117*/
/***************** IF         COND((%SUBSTRING(&MMOD 5 1)) *EQ 'Y') +* *S01117*/
/*****************            THEN(CALL PGM(SDCLRST))                * *S01117*/
/**/                                                                  /*S01117*/
/****Clear*Letters*of*Credit*Daily*files******                       * *S01117*/
/**/                                                                  /*S01117*/
/***************** IF         COND((%SUBSTRING(&MMOD 6 1)) *EQ 'Y') +* *S01117*/
/*****************            THEN(CALL PGM(SDCLRBC))                * *S01117*/
/**/                                                                  /*S01129*/
/*   Clear Securities Trading Rel. 2 Daily files.                   *  *S01129*/
/**/                                                                  /*S01129*/
/******            IF         COND((%SUBSTRING(&MMOD 21 1)) *EQ 'Y') +
                              THEN(CALL PGM(SDCLRSE))      /*S01129*/ /*S01343*/
/******************IF         COND((%SUBSTRING(&MMOD 21 1)) *EQ 'Y') +
/******************           THEN(CALL PGM(SCCLRSE))         *S01343* *E35464*/
                   IF         COND((%SUBSTRING(&MMOD 21 1)) *EQ 'Y') +
                              THEN(CALL PGM(SCCLRSE) PARM('R'))       /*E35464*/
                   IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/*/COPY WNCPYSRC,SCC07004                                            */
                                                                                          /*CSC048*/
/* Set journal caching off irrespective of */                                             /*CSC048*/
/* 'UseIBMJournalCache?' System Value. */                                                 /*CSC048*/
                                                                                          /*CSC048*/
             CHGJRN     JRN(ICJRN) JRNCACHE(*NO)                                          /*CSC048*/
                                                                                        /*MD023896*/
/* Set Global journal caching off */                                                    /*MD023896*/
             CALL       PGM(SCC003002) PARM('*NO ')                                     /*MD023896*/
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),*******         */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**/
/*  JOURNAL PHYSICAL FILES                                          */
/**/
/******************CALL       PGM(SDC1730) **/                        /*S01345*/
/**********        CALL       PGM(SCJRN)                                        */ /*S01345 CCB020*/
/**********        IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)                         */ /*CCB020*/
/**********           CHGVAR     VAR(&ERROR) VALUE('1')                                */ /*CCB020*/
/**********           GOTO       END                                                   */ /*CCB020*/
/**********        ENDDO                                                               */ /*CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
                   CHGVAR     VAR(&SEQNB1) VALUE(&SEQNBR)
/*/COPY WNCPYSRC,SCC07011                                            */
/**********        SNDJRNE    JRN(ICJRN) TYPE('ER') ENTDTA(&SEQNB1) */                   /*BUG9619*/
                   SNDJRNE    JRN(ICJRN) TYPE('ER') ENTDTA(&SEQNB1) +
                          FORCE(*YES)                                                    /*BUG9619*/
/**********        SNDJRNE    JRN(ICJRN) TYPE('BJ') */                                   /*BUG9619*/
                   SNDJRNE    JRN(ICJRN) TYPE('BJ') FORCE(*YES)                          /*BUG9619*/
/*/COPY WNCPYSRC,SCC07012                                            */
/******************STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))          CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                  /*CPK009*/
                   MONMSG     MSGID(CPF8351)                          /*056289*/
/**/
             RTVJOBA    JOB(&JOB) USER(&USRID)
             CHGVAR     VAR(&WSID) VALUE(&JOB)
             CHGVAR     VAR(&WSTI) VALUE(&JOB)                       /*059503*/
/*           CHGVAR     VAR(&TIME) VALUE(QTIME)                    */ /*E13205*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)                   /*E13205*/
/************CHGVAR     VAR(&CMTTXT) VALUE('       MIDAS   ' +    */ /*059503*/
/************           *CAT &WSID *CAT &TIME *CAT ' ' *CAT +     */ /*059503*/
/************           &USRID *CAT '               MIDAS +       */ /*059503*/
/************           Initial Program - No committed +          */ /*059503*/
/************           transactions for this job')               */ /*059503*/
             CHGVAR     VAR(&CMTTXT) VALUE('       MIDAS   ' +
                        *CAT &WSID *CAT &TIME *CAT ' ' *CAT +
                        &USRID *CAT '               MIDAS +
                        Initial Program - No committed +
                        transactions for this job' *CAT +
                        &BLNK339 *CAT &WSTI)                         /*059503*/
/*********** OPNDBF     FILE(TABTB10) OPTION(*INP) COMMIT(*YES)      * *S01194*/
             OPNDBF     FILE(SDBANKPD) OPTION(*INP) COMMIT(*YES)      /*S01194*/
             COMMIT     CMTID(&CMTTXT)
/*********** CLOF       OPNID(TABTB10)                               * *S01194*/
             CLOF       OPNID(SDBANKPD)                               /*S01194*/
/**********  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**/
/*  START AUTOBACKUP IF REQUIRED                                    */
/**/
             IF         COND((%SUBSTRING(&JNSTAT 106 5)) *NE '00000') +
                          THEN(CALL PGM(SDC1760))
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                CHGVAR     VAR(&ERROR) VALUE('1')
                GOTO       END
             ENDDO
/**/                                                                  /*S01184*/
/* IF CONFIRMATION MATCHING IS PRESENT, RE-SUBMIT THE CONTROL      */ /*S01184*/
/* PROGRAM BEFORE RETURNING TO INPUT CYCLE.                        */ /*S01184*/
/**/                                                                  /*S01184*/
/**********  IF         COND(%SST(&MMOD 60 1) *EQ 'Y') THEN(SBMJOB +
/**********               CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +
/**********               JOBD(MBATCH) JOBQ(CFJOBQA))      /*S01184*/ /*081177*/
/************IF         COND(%SST(&MMOD 60 1) *EQ 'Y') THEN(SBMJOB +  /*110242*/
/*************            CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +     /*110242*/
/*************            JOBD(MBATCH) JOBQ(CFJOBQA) +                /*110242*/
/*************            INLLIBL(*JOBD)) */                  /*081177  110242*/
/************IF         COND(%SST(&MMOD 60 1) *EQ 'Y') THEN(SBMJOB +                      /*CPK014*/
/************             CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +                         /*CPK014*/
/************             JOBD(MBATCH) JOBQ(CFJOBQA) RTGDTA(*JOBD) +                      /*CPK014*/
/************             INLLIBL(*JOBD))                             /*110242*/          /*CPK014*/
/************IF         COND(%SST(&MMOD 60 1) *EQ 'Y') THEN(SBMJOB +                      /*CSC023*/
/************             CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +                         /*CSC023*/
/************             JOBD(MBATCH) JOBQ(CFJOBQA) USER(*JOBD) +                        /*CSC023*/
/************             RTGDTA(*JOBD) INLLIBL(*JOBD))                        /*CPK014*/ /*CSC023*/
             IF         COND(%SST(&MMOD 60 1) *EQ 'Y') THEN(SBMJOB +
                          CMD(CALL PGM(CFC0180)) JOB(CFCONTROL) +
                          JOBD(MBATCH) JOBQ(CFJOBQA) USER(*JOBD) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) OUTQ(*JOBD))                       /*CSC023*/
/*/COPY WNCPYSRC,SCC07006                                            */
/**/                                                                  /*S01184*/
/**/
/* SUBMIT REPORT DISTRIBUTION */                                      /*S01117*/
/**/                                                                  /*S01117*/
                                                                      /*E20391*/
/************SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) JOB(FCC0401) +*/
/************             JOBD(FCJOBD) JOBQ(FCJOBQ) OUTQ(*JOBD) +  */
/************             INLLIBL(*JOBD) RTGDTA(MBATCH) */            /*S01117*/
/**/                                                                  /*S01117*/
/**********  SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) JOB(FCC0401) +
/**********               JOBD(FCJOBD) JOBQ(FCJOBQ) OUTQ(*JOBD) +
/**********               INLLIBL(*JOBD) RTGDTA(*JOBD)                /*S01463*/
                                                                      /*E20391*/
/************SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +                                  /*CPK014*/
/************             JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +                     /*CPK014*/
/************             OUTQ(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD)    /*S01463*/          /*CPK014*/
                                                                                       /*MD031644*/
/* If FT Return Status Feature is on, submit background job  */                        /*MD031644*/
  CHGVAR     VAR(&RTN) VALUE('       ') /*MD031644*/
  CHGVAR     VAR(&SARD) VALUE('CFT158') /*MD031644*/
  CHGVAR     VAR(&OPN) VALUE('*VERIFY') /*MD031644*/
  CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT) /*MD031644*/
  IF         COND(&RTN *EQ '       ') THEN(DO) /*MD031644*/
     CALL       PGM(FTC000987) PARM('START') /*MD031644*/
  ENDDO      /*MD031644*/
                                                                                       /*MD031644*/
             SBMJOB     CMD(CALL PGM(FCC0401) PARM(I)) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
                                                                      /*CAP002*/
/*  If the SF is on, start API background functions                   /*CAP002*/
             IF         COND(&CAP002 *EQ 'Y') THEN(DO)                /*CAP002*/
                                                                                          /*CSC011*/
/***If*24x7*Midas*Availability*Feature*is*on***/                                   /*CSC011 CCB022*/
/**********           IF         COND(&CSC011 *EQ 'Y') THEN(DO)    */              /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&CURR)*/           /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SC24X7 (1 2)) RTNVAR(&MAIN)*/           /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&SUPP)*/           /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SC24X7 (11 1)) +        */                     /*CCB022*/
/**********                            RTNVAR(&MMODE)              */              /*CSC011 CCB022*/
/**********              RTVDTAARA  DTAARA(SC24X7 (10 1)) RTNVAR(&SOVR)*/          /*CSC011 CCB022*/
/**********                                                        */              /*CSC011 CCB022*/
/***If*24x7*Midas*availability*is*on,*API*background*jobs*in*********/             /*CSC011 CCB022*/
/***the*support*system*should*not*be*started*unless*the*support*sys**/             /*CSC011 CCB022*/
/***is*ready*to*accept*data*from*Meridian*(i.e.*API*pgms*in*the******/             /*CSC011 CCB022*/
/***support sys are in maintenance mode already.)********************/             /*CSC011 CCB022*/
/**********                                                        */              /*CSC011 CCB022*/
/**********              IF      COND(((&CURR *EQ &SUPP) *AND (&MMODE *EQ +*/             /*CCB022*/
/**********                      'E')) *OR ((&SOVR *EQ 'S')  *AND (&CURR +*/              /*CCB022*/
/**********                      *EQ &MAIN))) +                    */                     /*CCB022*/
/**********                      THEN(CHGVAR VAR(&APIBKJOB) VALUE('N'))*/          /*CSC011 CCB022*/
/**********           ENDDO                                        */              /*CSC011 CCB022*/
/**********                                                        */              /*CSC011 CCB022*/
/**********           IF         COND(&APIBKJOB *EQ 'Y') THEN(DO)  */              /*CSC011 CCB022*/
                CALL       PGM(APCSTRBKJB)                            /*CAP002*/
/**********           ENDDO                                        */              /*CSC011 CCB022*/
             ENDDO                                                    /*CAP002*/
                                                                      /*CAP002*/

/* Determine first journal sequence number of current receiver. */                        /*210581*/
             RTVJRNE    JRN(ICJRN) RTNSEQNBR(&JNSEQ)                                      /*210581*/
             CHGVAR     VAR(&JNSEQA) VALUE(&JNSEQ)                                        /*210581*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBID)                               /*210581*/
/************IF         COND((%SST(&FMT 103 1) *EQ 'Y') *AND (&MPHAS +                    /*CTI003*/
/************             *EQ 'A')) THEN(DO)                                   /*CTI001*/ /*CTI003*/
             IF         COND(%SST(&FMT 103 1) *EQ 'Y') THEN(DO)                           /*CTI003*/
                                                                                          /*CTI003*/
/* Calculate name of Trade Innovation interface library. */                               /*210581*/
                CHGVAR     VAR(&TILIB) VALUE(&LIBID *CAT 'TILIB   ')                      /*210581*/
/* Update the TI data area, KCMJRNSEQ, with the journal sequence number. */               /*210581*/
                CHGDTAARA  DTAARA(&TILIB/KCMJRNSEQ) VALUE(&JNSEQA)                        /*210581*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*210581*/
/* If user has specified to re-open TI as well                                            /*CTI003*/
                IF         COND(&REOPTI = 'Y') THEN(DO)                                   /*CTI003*/
                                                                      /*CTI001*/
/**Start*the*SD*Replication*Task*in*the*TI/CSCS                          */    /*CTI001*/ /*CTI003*/
/************      CALL       PGM(TIC0030) PARM('START' 'SCC07')               /*CTI001*/ /*CTI003*/
                                                                      /*CTI001*/
/*  Send RELEASE message to TI */                                     /*CTI001*/
/************   CALL       PGM(TIC0013) PARM('RELEASE' '*MODE')                /*CTI001*/ /*CTI003*/
                   RSTTICOB   STRCOB(*YES)                                                /*CTI003*/
                                                                      /*CTI001*/
/* Start Midas/TI Batch Jobs                                    */    /*CTI001*/
                   CALL       PGM(TIC0050) PARM('START')                    /*CTI001*/
                                                                      /*CTI001*/
                ENDDO                                                                     /*CTI003*/
                ELSE       CMD(DO)                                                        /*CTI003*/
                                                                                          /*CTI003*/
/* Start Midas/TI Batch Jobs                                                              /*CTI003*/
                   CALL       PGM(TIC0050) PARM('START')                                  /*CTI003*/
                ENDDO                                                                     /*CTI003*/
             ENDDO                                                    /*CTI001*/
                                                                      /*CTI001*/
/*/COPY WNCPYSRC,SCC07005                                            */
/***Call*CBCFMGR001*to*rerun*logical*file*manager*background*jobs**/         /*AR1073235 AR1075853*/
/******members***/                                                           /*AR1073235 AR1075853*/
                                                                                       /*AR1073235*/
/**********  CALL       PGM(CBCFMGR001) PARM(' ')               */           /*AR1073235 AR1075853*/
                                                                                        /*AR544188*/
/***Call*CBCFMGR004*to*attempt*to*add*back*all*logical*file**/                   /*AR544188 CCB022*/
/******members***/                                                               /*AR544188 CCB022*/
/*******************************************************************/            /*AR544188 CCB022*/
/**********  CALL       PGM(CBCFMGR004)            */                            /*AR544188 CCB022*/
/*******************************************************************/            /*AR544188 CCB022*/
/***Call*CBCFMGR005*to*shut*down*background*jobs*if*active**********/            /*AR544188 CCB022*/
/*******************************************************************/            /*AR544188 CCB022*/
/**********  CALL       PGM(CBCFMGR005)            */                            /*AR544188 CCB022*/
                                                                                          /*CCB022*/
/* Call SC001006 to return members that were removed during CoB */                        /*CCB022*/
                                                                                          /*CCB022*/
             OVRDBF     FILE(SCFMBRTD) TOFILE(QTEMP/SCFMBRTD) OVRSCOPE(*JOB)            /*MD037757*/
             CALL       PGM(SC001006)                                                     /*CCB022*/
                                                                                          /*CCB022*/
/**/                                                                                      /*260790*/
/**Stop*the*SCC2470MON*journal*save*process***************************/          /*260790 AR855839*/
/**/                                                                                      /*260790*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID) */                   /*260790 AR855839*/
/**********  CHGVAR     VAR(&DATAQL) VALUE(&SYSID *CAT 'XLIB') */                /*260790 AR855839*/
/**********  CHGVAR     VAR(&MESS) VALUE('STOP      ') */                        /*260790 AR855839*/
/**********  CALL       PGM(QSNDDTAQ) PARM(&DATAQN &DATAQL &DLEN &MESS) */       /*260790 AR855839*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000) */                        /*260790 AR855839*/
                                                                                          /*260790*/
                                                                      /*S01463*/
/**********  IF         COND(%SST(&FMT 104 1) *EQ 'Y') THEN(DO)                    /*CPB002 CCB022*/
/**********    RMVPFTRG   FILE(FWDRTFE)                                            /*CPB002 CCB022*/
/**********    MONMSG     MSGID(CPF0000)                                           /*CPB002 CCB022*/
/**********                                                                        /*CPB002 CCB022*/
/**********    ADDPFTRG   FILE(FWDRTFE) TRGTIME(*AFTER) +                                 /*CCB022*/
/**********               TRGEVENT(*INSERT) PGM(PB6602)                            /*CPB002 CCB022*/
/**********                                                                        /*CPB002 CCB022*/
/**********    ADDPFTRG   FILE(FWDRTFE) TRGTIME(*AFTER) +                                 /*CCB022*/
/**********               TRGEVENT(*UPDATE) PGM(PB6602) +                                 /*CCB022*/
/**********               TRGUPDCND(*CHANGE)                                       /*CPB002 CCB022*/
/**********  ENDDO                                                                 /*CPB002 CCB022*/
                                                                      /*CPB002*/
/*  Check if the REPLICATION Feature is on   */                       /*CPB002*/
             CHGVAR     VAR(&SARD) VALUE('CRP006')                    /*CPB002*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                    /*CPB002*/
             CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)      /*CPB002*/
             IF         COND(&RTN *EQ '       ') THEN(DO)             /*CPB002*/
/* Calculate name of Replication base library and data area. */                           /*210581*/
                RTVDTAARA  DTAARA(RPLIBNAMES (11 10)) RTNVAR(&RPBASELIB)                  /*210581*/
                CHGVAR     VAR(&RPDTASEQ) VALUE('JD' *CAT &LIBID *CAT +
                             '1SEQ1 ')                                                    /*210581*/
                CHKOBJ     OBJ(&RPBASELIB/&RPDTASEQ) OBJTYPE(*DTAARA)                   /*AR762171*/
                MONMSG     MSGID(CPF9801) EXEC(DO)                                      /*AR762171*/
                CHGVAR     VAR(&RPDTASEQ) VALUE('JDFDR' *CAT &LIBID *CAT +
                          '11 ')                                                        /*AR762171*/
                ENDDO                                                                   /*AR762171*/
                                                                                          /*210581*/
/* Update the data area with the journal sequence number. */                              /*210581*/
                CHGDTAARA  DTAARA(&RPBASELIB/&RPDTASEQ (1 10)) +
                             VALUE(&JNSEQA)                                               /*210581*/
                MONMSG     MSGID(CPF0000 MCH0000)                                         /*210581*/
                                                                      /*CPB002*/
/**  Start System Replication  **/                                    /*CPB002*/
               CALL       PGM(RPC0010)                                /*CPB002*/
             ENDDO                                                    /*CPB002*/

/* Start SWIFT jobs (process includes MS_ENABLED data area check)                         /*218851*/
             CALL       PGM(MSC0203)                                                      /*218851*/
                                                                                          /*218851*/
/* Check if the CSW025 Feature is on */                                                   /*218851*/
             CHGVAR     VAR(&SARD) VALUE('CSW025')                                        /*218851*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                        /*218851*/
             CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                          /*218851*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                                 /*218851*/
                                                                                          /*218851*/
/* Start MMM jobs */                                                                      /*218851*/
               CALL       PGM(MEC0720)                                                    /*218851*/
             ENDDO                                                                        /*218851*/
                                                                                          /*218851*/
/***Check*if*the*CAP203*Feature*is*on******************************/           /*BUG27914 MD022112*/
/**********  CHGVAR     VAR(&RTN) VALUE('       ')                */           /*BUG27914 MD022112*/
/**********  CHGVAR     VAR(&SARD) VALUE('CAP203')                */           /*BUG27914 MD022112*/
/**********  CHGVAR     VAR(&OPN) VALUE('*VERIFY')                */           /*BUG27914 MD022112*/
/**********  CALL      PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)  */           /*BUG27914 MD022112*/
/**********  IF         COND(&RTN *EQ '       ') THEN(DO)         */           /*BUG27914 MD022112*/
/******************************************************************/           /*BUG27914 MD022112*/
/***Reset*Retail*Account*Movements*Enquiry*flag********************/           /*BUG27914 MD022112*/
/**********    CALL       PGM(CB000130)                           */           /*BUG27914 MD022112*/
/**********  ENDDO                                                */           /*BUG27914 MD022112*/
                                                                                        /*BUG27914*/
/** Housekeep UDF insert during COB by CLE134 */                                        /*MD020345*/
                                                                                        /*MD020345*/
             CHGVAR     VAR(&RTN) VALUE('       ')                                      /*MD020345*/
             CHGVAR     VAR(&SARD) VALUE('CLE134')                                      /*MD020345*/
             CHGVAR     VAR(&OPN) VALUE('*VERIFY')                                      /*MD020345*/
             CALL       PGM(AOSARDR0) PARM(&RTN &OPN &SARD &SFMT)                       /*MD020345*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                               /*MD020345*/
               SBMJOB     CMD(CALL PGM(SC002501)) JOB(UDFHKEEP) +
                            JOBD(MBATCH) JOBQ(INTERFACE) +
                            PRTDEV(*CURRENT) OUTQ(*JOBD) USER(*JOBD) +
                            RTGDTA(*JOBD) INLLIBL(*JOBD)                                /*MD020345*/
             ENDDO                                                                      /*MD020345*/
                                                                                          /*CSC054*/
/** Start Listener Port */                                                                /*CSC054*/
                                                                                          /*CSC054*/
             CALL       PGM(LSNPORCTL) PARM('START')                                      /*CSC054*/
                                                                                          /*CSC054*/
/** Check for PEA Switchable feature CSC054 */                                            /*CSC054*/
                                                                                          /*CSC054*/
             CALL       PGM(AOSARDR0) PARM(&RTN '*VERIFY' +
                          'CSC054' &AOFMT)                                                /*CSC054*/
                                                                                          /*CSC054*/
             IF         COND(&RTN *EQ '       ') THEN(DO)                                 /*CSC054*/
                                                                                          /*CSC054*/
/** Get PEA system values */                                                              /*CSC054*/
                                                                                          /*CSC054*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'PEAIndicator' &SVAL1 +
                          'PEAHandShakingQM' &SVAL2 +
                          'PEAHandShakingOQ' &SVAL3 +
                          'PEALiveSystemPrefix' &SVAL4 +
                          &SVALK5 &SVAL5  &SVALK6 &SVAL6 +
                          &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)                                /*CSC054*/
                                                                                          /*CSC054*/
             CHGVAR     VAR(&PEAIND) VALUE(%SST(&SVAL1 1 1))                              /*CSC054*/
                                                                                          /*CSC054*/
             IF         COND(&PEAIND *EQ 'Y') THEN(DO)                                    /*CSC054*/
             CHGVAR     VAR(&MQMGR) VALUE(&SVAL2)                                         /*CSC054*/
             CHGVAR     VAR(&MQOUT) VALUE(&SVAL3)                                         /*CSC054*/
             CHGVAR     VAR(&PRFX) VALUE(%SST(&SVAL4 1 2))                                /*CSC054*/
                                                                                          /*CSC054*/
/** Send PEA Ready message to Live */                                                     /*CSC054*/
                                                                                          /*CSC054*/
             CALL       PGM(ZAMSGTOMQ) PARM(&RSVALRTNC &PRFX +
                          &MQMGR &MQOUT &MQMSG)                                           /*CSC054*/
                                                                                       /*AR1042302*/
/** Run Archiving */                                                                   /*AR1042302*/
             CALL       PGM(SCC0420)                                                   /*AR1042302*/
                                                                                       /*AR1042302*/
              ENDDO                                                                       /*CSC054*/
                                                                                          /*CSC054*/
              ENDDO                                                                       /*CSC054*/
                                                                                          /*CSC054*/
             GOTO       END
 ABNOR:      CHGVAR     VAR(&ERROR) VALUE('1')
             MONMSG     MSGID(CPF0000 MCH0000)  /* MONITOR AT EVERY LINE FOR +
                        POSSIBLE ERROR AND AVOID GOING TO THE TAG - 'ABNOR' */
                                                                                          /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/**If*Feature*CCB009*is*'on' (permanent journaling),                           /*196358*/ /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/************IF*********COND(&CCB009 *EQ '       ') THEN(DO)                   /*196358*/ /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/**try*to*allocate*data*area SCJRNLOCK.                                        /*196358*/ /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/************ALCOBJ*****OBJ((SCJRNLOCK *DTAARA *EXCL)) WAIT(1)                 /*196358*/ /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/**If*not*allocated,*then journal size monitor is active.                      /*196358*/ /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/************MONMSG*****MSGID(CPF1002) EXEC(GOTO CMDLBL(SKIP))                 /*196358*/ /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/**Otherwise*submit*the*journal size monitor job.                              /*196358*/ /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/************SBMJOB*****CMD(CALL PGM(SCC2470)) JOB(JRNMONITOR) +
/***********************  JOBD(MBATCH) JOBQ(MEODQ) USER(*JOBD) +
/***********************  RTGDTA(*JOBD) INLLIBL(*JOBD) MSGQ(*NONE)             /*196358*/ /*202444*/
/************DLCOBJ*****OBJ((SCJRNLOCK *DTAARA *EXCL))                         /*196358*/ /*202444*/
/*SKIP:*****************                                                       /*196358*/ /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/************ENDDO******                                                       /*196358*/ /*202444*/
/***********************                                                       /*196358*/ /*202444*/
/*/COPY WNCPYSRC,SCC07003                                            */
 END:        IF         COND((&ERROR) *EQ '1') THEN(DO)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCC07MP5                                            */
                                                                      /*S01408*/
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),*******         */ /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**********  ENDJRNPF   FILE(*ALL) JRN(ICJRN)                                          */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 MCH0000)  /* MONITOR AT EVERY LINE +
                        FOR POSSIBLE ERROR AND AVOID GOING TO THE TAG - 'END' */          /*CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
/*/COPY WNCPYSRC,SCC07013                                            */
             ENDDO
/**/
/*           ENDPGM                                                 ****E10061*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDPGM:     DLCOBJ     OBJ((&DVLIB *LIB *EXCLRD))                   /*056290*/
             MONMSG     MSGID(CPF0000)                               /*S01420*/
/* Delete file QTEMP/SCFMBRTD */                                                        /*MD037757*/
             IF         COND((&ERROR) *NE '1') THEN(DO)                                 /*MD037757*/
                DLTF       FILE(QTEMP/SCFMBRTD)                                         /*MD037757*/
                MONMSG     MSGID(CPF2105)                                               /*MD037757*/
             ENDDO                                                                      /*MD037757*/
             DLCOBJ     OBJ((CBLOCK *DTAARA *EXCL))                  /*S01420*/
             MONMSG     MSGID(CPF0000)                               /*S01420*/
/*ENDPGM:****ENDPGM */                                      /*E10061* *056290*/
             ENDPGM                                                  /*056290*/
/*********************************************************************/
