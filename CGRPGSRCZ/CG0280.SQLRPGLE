     H DEBUG
     H CVTOPT (*GRAPHIC)                                                                    MD054955
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/**** *  RPGBNOCVT                                                    *              CSD053 MD054955
/**** *  RPGCVTOPT1                                                   *              CSD053 MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Edit Corr.Sched.Edit record(2 screens)')      *
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG0280 - Edit Corr. Schedule       Edit record(2 screens)    *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055928           Date 02Jun20               *
      *  Prev Amend No. MD054955           Date 16Dec19               *
      *                 MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245085             Date 18Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSD053             Date 01Jun06               *
      *                 222860             Date 07Jul05               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2380            Date 03May04               *
      *                 BUG2330            Date 29Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 117207             Date 21May01               *
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 01Mar99               *
      *                 CTI002             Date 19Aug98               *
     F*                 115722             Date 12Feb98               *
     F*                 116605             DATE 09APR97               *
     F*                 CCG009             DATE 01JUN95               *
     F*                 089186             DATE 23MAY95               *
     F*                 086588             DATE 21APR95               *
     F*                 083687             DATE 22FEB95               *
     F*                 082944             DATE 08FEB95               *
     F*                 082886             DATE 02FEB95               *
     F*                 079846             DATE 07DEC94               *
     F*                 079843             DATE 07DEC94               *
     F*                 S01522             DATE 22NOV94               *
     F*                                                               *
     F*---------------------------------------------------------------*
      *                                                               *
      *  MD055928 - Schedule cannot be inserted for Primary recipient.*
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  245085 - Correct date validation.                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *           (Recompile)                                         *
      *  222860 - An error msg appears when a correspondent schedule  *
      *           is amended if the item type/subtype belongs to a    *
      *           group.                                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2380 - increase #1DBRC length as per CGL029 changes.      *
     F*  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  117207 - Retention Period of maximum 99 days is too short.   *
      *  CSD005 - Standing Data Account Narrative.  Add new field     *
      *           to SDACODPD.  Recompilation of programs.            *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
     F*  115722 - Comment out references to CGUSRMSG/CGD1001          *
     F*  116605 - 'Print Addresss Label' should default to 'N' if     *
     F*           left blank.                                         *
     F*  095468 - Decimal Data error if ? in Schedule print date      *
     F*  CCG009 - Private Banking UDC                                 *
     F*  089186 - Correct access to check print type sub-type         *
     F*  086588 - Correct conditions for charge processing            *
     F*  083687 - Correct page numbers                                *
     F*  082944 - Add Structure Type validation                       *
     F*  082886 - Correct validation of Reset date etc                *
     F*  079846 - Post day number only allowed if frequency entered   *
     F*  079843 - Correct processing to look at item status           *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*EDTRCD: Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,CG0280DFPG
     FCG0280DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Edit Corr. Schedule       Edit record(2 screens)
      *
     F*CGCSCHL1* IF   E           K DISK                                                    MD054955
     F**********                           INFDS(INFDS1)                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * RTV : Correspondent Schedule    Retrieval index
      *
     F*CGCSCHL8* IF   E           K DISK
     F*********                            INFSR(SRFILE)                                    MD054955
      * RTV : Correspondent Schedule    Key only                                            MD054955
      *
     F*CGCSCHL3* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * RTV : Correspondent Schedule    By Account
      *
     F*CGCSCHL2* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * RTV : Correspondent Schedule    By Account code
      *
     F*CGCSCHL5* IF   E           K DISK                                         082944     MD054955
     F**********                           INFSR(SRFILE)                        082944      MD054955
      * RTV : Correspondent Schedule    By Corr. Print Prim Corr.         082944
      *                                                                   082944
     F*CGPTYPL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * RTV : Print Item Type/Sub-Type  Retrieval index
      *
     FCGPSCHL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Print Schedule Types      Retrieval index
      *
     FCGCORRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Correspondent Details     Retrieval index
      *
     F*CGCSCHL0* UF A E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F**********                           COMMIT                                           MD054955
      * UPD : Correspondent Schedule    Update index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,CG0280DEPG
      * Screen one error indicator store
      * Screen two error indicator store
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)
      *                                                                                       CSC022
     D CGCSCH        E DS                  EXTNAME(CGCSHJW0)                                MD054955
     D CGPTYP        E DS                  EXTNAME(CGPTYJW0)                                MD054955
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,CG0280DIPG
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC***     E DS                  EXTNAME(CGCSCHL0)                                MD054955
     D @1DBRC        E DS                  EXTNAME(CGCSHJW0)                                MD054955
     D                                     PREFIX(X)                                        MD054955
     D Found           S              5  0                                                  MD055928
      * UPD : Correspondent Schedule    Update index
      * Current/previous master file format fields for change control
      *
     D**#1DBRC**      DS                            196                                      BUG2380
     D*#1DBRC***       DS           214                                                     MD054955
     D #1DBRC          DS           215                                                     MD054955
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D @@I1            DS
      * Screen one error indicator store
     D  @I1                    1    100
     D                                     DIM(100)
     D  INSCR1                31     41
     D @@I2            DS
      * Screen two error indicator store
     D  @I2                    1    100
     D                                     DIM(100)
     D  INSCR2                31     44
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D SDLANG        E DS                  EXTNAME(SDLANGPD)
      *
      *  Languages *
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  ACRECI       E                     EXTFLD(RECI)
     D  ACLCD        E                     EXTFLD(LCD)
     D  ACCHTP       E                     EXTFLD(CHTP)
     D  ACTNLU       E                     EXTFLD(TNLU)
     D**********                              2  16 ##ACCT                                    CGL029
     D ##ACCT          DS
     D  WCNUM                  1      6
     D  WCCY                   7      9
     D  WACOD                 10     19
     D  WACSQ                 20     21
      *
      *  Accounts *
      *
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      *
      *  Branch Details *
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      *  Currency Details *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
      *                                                                                       CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  WLCD         E                     EXTFLD(LCD)
      * Switchable Features Details accessed via Access Program                               CSC022
      *                                                                                       CSC022
     D WDSJOB        E DS                  EXTNAME(SCCMTJOB)
     D  WCMTNO       E                     EXTFLD(COMITNUM)
     D  WJOB01       E                     EXTFLD(COMITJOB1)
     D  WJOB02       E                     EXTFLD(COMITJOB2)
     D  WJOB03       E                     EXTFLD(COMITJOB3)
     D  WJOB04       E                     EXTFLD(COMITJOB4)
     D  WJOB05       E                     EXTFLD(COMITJOB5)
     D  WJOB06       E                     EXTFLD(COMITJOB6)
     D  WJOB07       E                     EXTFLD(COMITJOB7)
     D  WJOB08       E                     EXTFLD(COMITJOB8)
     D  WJOB09       E                     EXTFLD(COMITJOB9)
     D  WJOB10       E                     EXTFLD(COMITJOB10)
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      *                                                                                       CSC022
     D*COPY*CGCPYSRC,CGCOV                                                082944            MD054955
     D/COPY CGCPYSRC,CGCOVLE                                                                MD054955
     D*                                                                   082944
     D* Plist DS for CG0011                                               082944
     D*                                                                   082944
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS            33
      * KEY: Correspondent Schedule    Retrieval index
      * I : RST Correspondent
     D  P2CORR                 1     10
      * I : MAP Print Item Type
     D  P2PTYP                11     20
      * I : MAP Print Item Sub-type
     D  P2PSTP                21     30
      * I : MAP Sequence Number
     D  P2SEQN                31     33  0
     D O4PARM          DS             6
      * KEY: Print Schedule Types      Retrieval index
      * I : MAP Print Schedule
     D  O4PSCH                 1      6
     D O6PARM          DS            20
      * KEY: Print Item Type/Sub-Type  Retrieval index
      * I : MAP Print Item Type
     D  O6PTYP                 1     10
      * I : MAP Print Item Sub-type
     D  O6PSTP                11     20
     D O7PARM          DS           100
      * KEY: Correspondent Details     Retrieval index
      * I : MAP Correspondent
     D  O7CORR                 1     10
      * I : MAP Customer
     D  O7CUST                11     16
      * I : MAP Branch
     D  O7BRCH                17     19
      * I : MAP Counterparty Nostro
     D  O7CTRN                20     27
      * I : MAP Account identifier
     D**********                             28  45 O7ACID                                    CGL029
     D  O7QQID                28     45
      * I : MAP Account code
     D**********                             46  49 O7ACOD                                    CGL029
     D  O7QQOD                46     49
      * I : MAP Processing
     D  O7PTYP                50     57
      ** MAP Account Identifier                                                               CGL029
      *                                                                                       CGL029
     D  O7ACID                58     75
      ** MAP Account Code                                                                     CGL029
      *                                                                                       CGL029
     D  O7ACOD                76     85
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code (FT)'
      * Action Code
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
      *  Defined Constants
      *
      *
     D DIGITS          C                   CONST('0123456789')
     D ##HOLD          C                   CONST('HOLDMAIL')
     D ##SPRS          C                   CONST('SUPPRESS')
     D ##IMED          C                   CONST('IMMEDIATE')
      *
      /EJECT
      *
      * Data to be passed to window processing
      *
     I/COPY QWINDSRC,CG0280WDTA
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Correspond
      *                                                                   082944
      * CG0011 Plist                                                      082944
      *                                                                   082944
     C     PL0011        PLIST                                                                 08294
     C                   PARM      *BLANKS       P@RTN             7                           08294
     C                   PARM                    CGCOV                                         08294
      *
      *  Set up primary reference
      *
     C                   MOVEL     P2PARM        W0PREF
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Check passed parameters
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Set control to display first screen
     C                   Z-ADD     1             W0SCR             3 0
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1SEQN        IFEQ      *ZERO                                        Sequence Number
     C     #1CORR        OREQ      *BLANK                                       Correspondent
     C     #1PTYP        OREQ      *BLANK                                       Print Item Type
     C     #1PSTP        OREQ      *BLANK                                       Print Item Sub-
      * One or more key fields is blank
     C     P1ACTC        IFEQ      'I'                                          Print Item Sub-
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
     C                   END
      * Bypass key screen
     C     W0BYP         IFNE      'Y'
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      * Process key screen input
     C                   CAS                     BEPRKY
     C                   END
     C     W0TRN         DOWEQ     'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSAK
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
      * Update screen time
     C                   TIME                    ##TME
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen input
      *================================================================
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Validate key fields
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    CPCORR                         Correspondent
     C                   KFLD                    CPPTYP                         Print Item Type
     C                   KFLD                    CPPSTP                         Print Item Sub-
     C                   KFLD                    CPSEQN                         Sequence Number
      * Setup key
     C                   MOVEL     #1CORR        CPCORR                         Correspondent
     C                   MOVEL     #1PTYP        CPPTYP                         Print Item Type
     C                   MOVEL     #1PSTP        CPPSTP                         Print Item Sub-
     C                   Z-ADD     #1SEQN        CPSEQN                         Sequence Number
     C*****KRTV*         CHAIN     @CSCHL1                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPCORR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN and CPRECI = 'D'                                               MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       9091                  MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      * Send message 'Record Exists'
      *
     C     *IN90         IFEQ      '0'
     C     P1ACTC        ANDEQ     'I'
     C                   MOVEL     'CGD1340'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        993132    *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialize detail screen (new record)
      * EDTRCD: Init. det. scr NW - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl New Rcd
     C/COPY WNCPYSRC,CG0280DISN
     C                   ELSE
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG0280DSFF
      * USER: Initialize detail screen (existing record)
      * EDTRCD: Init. det. scr EX - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,CG0280DISE
     C                   END
      *..................................................
     C   99              GOTO      BEEXIT
      *
      * No error: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields
      *================================================================
      * Check relations
      * Check reference to Print Item Type/Sub-Type
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   SETON                                        9931      *
     C                   SETON                                        993132    *
     C                   END
      * USER: Validate key screen
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Key Screen
     C/COPY WNCPYSRC,CG0280DVKS
      * Print Item Type required
     C     #1PTYP        IFEQ      *BLANK                                       IF
     C     #1PSTP        ANDNE     *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1423'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * If Insert get next reference number
      *
     C     P1ACTC        IFEQ      'I'
      *
     C     KRTV1         KLIST
     C                   KFLD                    CPCORR                         Correspondent
     C                   KFLD                    CPPTYP                         Print Item Type
     C                   KFLD                    CPPSTP                         Print Item Sub-
      * Setup key
     C                   MOVEL     #1CORR        CPCORR                         Correspondent
     C                   MOVEL     #1PTYP        CPPTYP                         Print Item Type
     C                   MOVEL     #1PSTP        CPPSTP                         Print Item Sub-
      *
     C*****KRTV1         SETGT     @CSCHL8                                                  MD054955
     C*****KRTV1         READPE    @CSCHL8                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPCORR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPRECI = 'D'                                                                    MD054955
     C+ order by CPCORR, CPPTYP, CPPSTP, CPSEQN DESC                                        MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      * If record exits add one to seq else set to one
      *
     C     *IN90         IFEQ      '0'                                          IF
     C***********          ADD  1         #1SEQN           Sequence Number082886
     C     CPSEQN        ADD       1             #1SEQN                         Sequence Number08288
     C                   ELSE
     C                   Z-ADD     1             #1SEQN                         Sequence Number
     C                   END                                                    FI
     C                   END                                                    FI
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0TRN
     C                   Z-ADD     1             W0SCR
     C                   EXSR      MAIZ#1
     C                   END
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
     C     W0ROL         DOUEQ     'N'
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
      * Update screen time
     C                   TIME                    ##TME
     C     W0SCR         IFEQ      1
      * Set error
     C                   MOVEA     INSCR1        *IN(31)
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
     C                   ELSE
     C     W0SCR         IFEQ      2
      * Set error
     C                   MOVEA     INSCR2        *IN(31)
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT3
     C                   EXFMT     #RCDDTL2
     C                   END
     C                   END
      * Reset roll flag
     C                   MOVEL     'N'           W0ROL             1
      * Show next page of details
     C   27              EXSR      CDNXSC
      * Show previous page of details
     C   28              EXSR      CEPVSC
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * EDTRCD: Process key req. - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Key Screen Rqst
     C/COPY WNCPYSRC,CG0280DPKR
     C   05              MOVEL     'R'           W0TRN
      *
      * If insert go to key screen else exit
      *
     C     *IN12         IFEQ      '1'
     C     P1ACTC        IFEQ      'I'
     C                   MOVEL     'K'           W0TRN
     C                   ELSE
     C                   EXSR      ZXEXPG
     C                   END
     C                   END
      * Initialise error memories
     C                   MOVE      *ZERO         INSCR1
     C                   MOVE      *ZERO         INSCR2
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CDNXSC        BEGSR
      *================================================================
      * Display next screen
      *================================================================
      * Set roll flag
     C                   MOVEL     'Y'           W0ROL             1
     C                   Z-ADD     2             W0SCR
      *================================================================
     CSR   CDEXIT        ENDSR
      /EJECT
     CSR   CEPVSC        BEGSR
      *================================================================
      * Display previous screen
      *================================================================
      * Set roll flag
     C                   MOVEL     'Y'           W0ROL             1
     C                   Z-ADD     1             W0SCR
      *================================================================
     CSR   CEEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
     C     P1ACTC        IFEQ      'I'
     C     P1ACTC        OREQ      'A'
     C     *IN10         IFEQ      '0'
      * Validate details
     C                   MOVE      *ZEROS        INSCR1
     C                   MOVE      *ZEROS        INSCR2
     C                   EXSR      DCVLDL
      * Display first screen in error
     C     INSCR1        IFNE      *ZERO
     C                   Z-ADD     1             W0SCR
     C                   ELSE
     C     INSCR2        IFNE      *ZERO
     C                   Z-ADD     2             W0SCR
     C                   END
     C                   END
     C                   END
     C                   END
      *
      *  Call window processing
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRWIND
     C                   END
      * QUIT if error:
     C     *IN99         CABEQ     '1'           CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: update record
     C     P1ACTC        IFEQ      'A'
     C     P1ACTC        OREQ      'I'
     C     P1ACTC        OREQ      'D'
     C     *IN10         ANDEQ     '1'
     C                   EXSR      EBPR##
     C                   END
      *
      * Exit if enquire
      *
     C     P1ACTC        IFEQ      'E'
     C                   MOVEL     'N'           W0RPT
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * USER: Validate detail screen fields
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Key Screen
     C/COPY WNCPYSRC,CG0280DVKS
      * Check relations
      * Check reference to Print Schedule Types
     C                   EXSR      VBCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(37)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Correspondent Details
     C                   EXSR      VCCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(34)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Midas Languages codes
     C                   EXSR      VDCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(35)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Midas Account codes
     C                   EXSR      VECKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(32)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Midas Account
     C                   EXSR      VICKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(31)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Charge Account
     C                   EXSR      VJCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(44)
     C                   SETON                                        99        *
     C                   END
      * Check reference to Currency
     C                   EXSR      VKCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(36)
     C                   SETON                                        99        *
     C                   END
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG0280DSFF
      * USER: Validate detail screen relations
      * EDTRCD: Detail scrn rels - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Screen Relns
     C/COPY WNCPYSRC,CG0280DVSR
      *
      * Validate Midas information
      *
     C                   EXSR      SRMINF
      *
      * Validate Print information
      *
     C                   EXSR      SRDPRT
      *
      * Validate Output Information
      *
     C                   EXSR      SROINF
      *
      * Validate Charge information
      *
     C                   EXSR      SRCINF
      *
      * Cross Validations
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRXVAL
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRMINF   : Validate Midas Information                        *
      *                                                               *
      *================================================================
     CSR   SRMINF        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMINF'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0280MINF
      *
      * Defaults must be applied must be either "Y" or "N"
      *
     C     #1APDF        IFNE      'N'                                          IF
     C     #1APDF        ANDNE     'Y'                                          IF
     C                   MOVEL     '1'           @I1(33)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1424'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Only Account code or Account id. may be entered
      *
     C     #1MACT        IFNE      *BLANKS                                      IF
     C     #1ACCD        ANDNE     *BLANKS                                      IF
     C                   MOVEA     '11'          @I1(31)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1470'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXMINF        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRDPRT   : Validate Print Information                        *
      *                                                               *
      *================================================================
     CSR   SRDPRT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDPRT'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0280DPRT
      *
      * Validate print day number
      *
     C     #SSFDY        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SSFDY        ZFIELD
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      0             ZADEC             1 0          I:No Of Decs
     C                   PARM      2             ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I1(38)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1471'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1SFDY
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1SFDY
     C                   END                                                    FI
      *
      * Validate Print Date
      *
     C     #SNPDT        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C***********          MOVE #SNPDT    ZDATE                           095468
      *
     C     DIGITS        CHECK     #SNPDT                                 90
      *
      * Check to see if field is numeric
      *
     C     *IN90         IFEQ      '1'                                          IF
     C                   MOVEL     '1'           @I1(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1472'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
      * Validate as a date
      *
     C                   MOVE      #SNPDT        ZDATE                                         09546
     C                   CALL      'ZDATE1'                                     Entry parameter
     C                   PARM      *BLANKS       ZERR              7            error code (Z r
     C                   PARM                    ZDATE             6 0          Value date
     C**********           PARM           ZDATFM  1        Date format ind                    245085
     C                   PARM      WUDFF         ZDATFM            1            Date format ind
     C                   PARM                    ZDAYNO            5 0          Value date
      *
      * Check to see if field is a valid date
      *
     C     ZERR          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I1(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1473'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   Z-ADD     ZDAYNO        #1NPDT
     C                   END                                                    FI
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1NPDT
     C                   END                                                    FI
      *
      * Validate Retention period
      *
     C     #SRETP        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SRETP        ZFIELD
     C/COPY WNCPYSRC,CG0280C001
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      0             ZADEC             1 0          I:No Of Decs
     C**********           PARM 2         ZADIG   20       I:No Of Digits                     117207
     C                   PARM      4             ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
     C/COPY WNCPYSRC,CG0280C002
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I1(40)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1474'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1RETP
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1RETP
     C                   END                                                    FI
      *
      * Print Address Label required
      * (it will default to 'N' if it is left blank)                      116605
      *                                                                   116605
     C     #1PLAB        IFEQ      *BLANK                                       IF             11660
     C                   MOVEL     'N'           #1PLAB                                        11660
     C                   ENDIF                                                  FI             11660
      *
     C     #1PLAB        IFNE      'Y'                                          IF
     C     #1PLAB        ANDNE     'N'                                          IF
     C                   MOVEL     '1'           @I1(41)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1425'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXDPRT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SROINF   : Validate Output Information                       *
      *                                                               *
      *================================================================
     CSR   SROINF        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROINF'      @STK(Q)
      *
      * Output Sequence Number
      *
     C     #SOSQN        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SOSQN        ZFIELD
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      0             ZADEC             1 0          I:No Of Decs
     C                   PARM      5             ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(31)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1475'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1OSQN
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1OSQN
     C                   END                                                    FI
      *
      * Total Number of Pages
      *
     C     #SNPAG        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SNPAG        ZFIELD
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      0             ZADEC             1 0          I:No Of Decs
     C                   PARM      5             ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(32)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1476'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1NPAG
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1NPAG
     C                   END                                                    FI
      *
      * Validate Reset Date
      *
     C     #SRDTE        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C***********          MOVE #SRDTE    ZDATE                           095468
      *
     C     DIGITS        CHECK     #SRDTE                                 90
      *
      * Check to see if field is numeric
      *
     C     *IN90         IFEQ      '1'                                          IF
     C                   MOVEL     '1'           @I2(33)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1477'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
      * Validate as a date
      *
     C                   MOVE      #SRDTE        ZDATE                                         09546
     C                   CALL      'ZDATE1'                                     Entry parameter
     C                   PARM      *BLANKS       ZERR              7            error code (Z r
     C                   PARM                    ZDATE             6 0          Value date
     C**********           PARM           ZDATFM  1        Date format ind                    245085
     C                   PARM      WUDFF         ZDATFM            1            Date format ind
     C                   PARM                    ZDAYNO            5 0          Value date
      *
      * Check to see if field is a valid date
      *
     C     ZERR          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(33)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1478'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   Z-ADD     ZDAYNO        #1RDTE
     C                   END                                                    FI
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1RDTE
     C                   END                                                    FI
     C*                                                                   082886
     C*                                                                   082886
     C*** Validate Reset Day Number                                       082886
     C     #SRSDN        IFNE      *BLANKS                                                     08288
     C*                                                                   082886
     C*** Validate number                                                 082886
     C                   MOVEL     *BLANKS       ZFIELD                                        08288
     C                   MOVE      #SRSDN        ZFIELD                                        08288
      *                                                                   082886
     C                   CALL      'ZALIGN'                                     Entry parameter08288
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code  08288
     C                   PARM                    ZFIELD           16            B:Check Field  08288
     C                   PARM      0             ZADEC             1 0          I:No Of Decs   08288
     C                   PARM      2             ZADIG             2 0          I:No Of Digits 08288
     C                   PARM                    ZAFLD            16            O:Check Field  08288
     C*                                                                   082886
     C* Check to see if field is numeric                                  082886
     C     ZRTN          IFNE      *BLANKS                                                     08288
     C                   MOVEL     '1'           @I2(35)                                       08288
     C                   SETON                                        99                       08288
     C                   MOVEL     'CGD1800'     ZAMSID                                        08288
     C                   EXSR      ZASNMS                                                      08288
     C                   ELSE                                                                  08288
      *                                                                   082886
     C                   MOVE      ZAFLD         #1RSDN                                        08288
     C                   END                                                                   08288
      *                                                                   082886
     C                   ELSE                                                                  08288
     C                   Z-ADD     0             #1RSDN                                        08288
     C                   END                                                                   08288
      *
      *  Unwind subroutine stack name
      *
     C     EXOINF        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRCINF   : Validate Charge Information                       *
      *                                                               *
      *================================================================
     CSR   SRCINF        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCINF'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0280CINF
      *
      * Validate Post Charges day number
      *
     C     #SPDAY        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SPDAY        ZFIELD
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      0             ZADEC             1 0          I:No Of Decs
     C                   PARM      2             ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(41)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1450'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1PDAY
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1PDAY
     C                   END                                                    FI
      *
      * Validate Next Post Date
      *
     C     #SNTDT        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C***********          MOVE #SNTDT    ZDATE                           095468
      *
     C     DIGITS        CHECK     #SNTDT                                 90
      *
      * Check to see if field is numeric
      *
     C     *IN90         IFEQ      '1'                                          IF
     C                   MOVEL     '1'           @I2(42)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1451'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
      * Validate as a date
      *
     C                   MOVE      #SNTDT        ZDATE                                         09546
     C                   CALL      'ZDATE1'                                     Entry parameter
     C                   PARM      *BLANKS       ZERR              7            error code (Z r
     C                   PARM                    ZDATE             6 0          Value date
     C**********           PARM           ZDATFM  1        Date format ind                    245085
     C                   PARM      WUDFF         ZDATFM            1            Date format ind
     C                   PARM                    ZDAYNO            5 0          Value date
      *
      * Check to see if field is a valid date
      *
     C     ZERR          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(42)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1452'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   Z-ADD     ZDAYNO        #1NTDT
     C                   END                                                    FI
     C                   END                                                    FI
      *
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1NTDT
     C                   END                                                    FI
      *
      * Apply Charge required
      *
     C     #1ACHG        IFNE      'N'                                          IF
     C     #1ACHG        ANDNE     'Y'                                          IF
     C     #1ACHG        ANDNE     'S'                                          IF
     C     #1ACHG        ANDNE     *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(43)
     C                   SETON                                        99        *
      * Send message '*Value required'
     C                   MOVEL     'CGD1453'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXCINF        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRXVAL   : Validate Cross Validations                        *
      *                                                               *
      *================================================================
     CSR   SRXVAL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRXVAL'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG0280XVAL
      *
      * Midas Account Identifier only if print item type allows
      *
     C     #1MACT        IFNE      *BLANK
     C     #1PTYP        ANDNE     *BLANK
     C     #1PSTP        ANDNE     *BLANK
     C     ITALAC        ANDNE     'Y'
     C     #1MACT        ORNE      *BLANK
     C     #1PTYP        ANDNE     *BLANK
     C     #1PSTP        ANDEQ     *BLANK
     C     #1MACT        ORNE      *BLANK
     C     #1PTYP        ANDEQ     *BLANK
     C     #1PSTP        ANDEQ     *BLANK
     C                   MOVEL     '1'           @I1(31)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1479'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Account Code only if print item type allows
      *
     C     #1ACCD        IFNE      *BLANK                                       IF
     C     #1PTYP        ANDNE     *BLANK
     C     #1PSTP        ANDNE     *BLANK
     C     ITAACD        ANDNE     'Y'
     C     #1ACCD        ORNE      *BLANK
     C     #1PTYP        ANDNE     *BLANK
     C     #1PSTP        ANDEQ     *BLANK
     C     #1ACCD        ORNE      *BLANK
     C     #1PTYP        ANDEQ     *BLANK
     C     #1PSTP        ANDEQ     *BLANK
     C                   MOVEL     '1'           @I1(32)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1480'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *                                                                   082944
     C     P1ACTC        IFEQ      'I'                                                         08294
     C     #1PCOR        ANDNE     *BLANKS                                                     08294
     C     P1ACTC        OREQ      'A'                                                         08294
     C     #1PCOR        ANDNE     *BLANKS                                                     08294
      * Correspondent external validation                                 082944
     C                   CLEAR                   CGCOV                                         08294
     C                   MOVE      #1PCOR        W0COR1                                        08294
     C                   MOVE      #1CORR        W0COR2                                        08294
     C                   MOVE      'S'           W0FIL                                         08294
     C                   MOVE      'I'           W0ACTP                                        08294
     C                   MOVE      ##PGM         W0PGM                                         08294
      *                                                                   082944
     C                   CALL      'CG0011'      PL0011                 9090                   08294
      *                                                                   082944
     C     *IN90         IFEQ      '1'                                                         08294
     C                   MOVEL     'CG0011'      W0FILE                                        08294
     C                   MOVEL     '*CALL'       W0KEY                          ***************08294
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 05 *08294
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************08294
     C                   MOVEL     'MIDAS  '     W0MSGF                                        08294
     C                   EXSR      SRERR                                                       08294
     C                   END                                                                   08294
      *                                                                   082944
     C     P@RTN         IFNE      *BLANKS                                                     08294
     C                   MOVEL     '1'           @I1(34)                                       08294
     C                   SETON                                        99                       08294
     C                   END                                                                   08294
      *                                                                   082944
     C                   END                                                                   08294
      *
      * Check that print schedule is not already set up
      *
     C                   SELECT
     C     #1MACT        WHENNE    *BLANK
      *
     C     KCSHL3        KLIST
     C                   KFLD                    #1MACT
     C                   KFLD                    #1CORR
     C                   KFLD                    #1PTYP
     C                   KFLD                    #1PSTP
      *
      *  Access L3 to see if record exists
      *
     C*****KCSHL3        SETLL     @CSCHL3                                                  MD054955
     C*****KCSHL3        READE     @CSCHL3                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPMACT = :#1MACT and CPCORR = :#1CORR and CPPTYP = :#1PTYP                    MD054955
     C+ and CPPSTP = :#1PSTP and CPRECI = 'D' and CPMACT <> '          '                    MD054955
     C+ order by CPMACT, CPCORR, CPPTYP, CPPSTP, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      * If found and not same sequence then error
      *
     C     *IN90         IFEQ      '0'
     C     #1SEQN        ANDNE     CPSEQN
     C                   MOVEL     '1'           @I1(31)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1487'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
     C     #1ACCD        WHENNE    *BLANK
      *
     C     KCSHL2        KLIST
     C                   KFLD                    #1ACCD
     C                   KFLD                    #1CORR
     C                   KFLD                    #1PTYP
     C                   KFLD                    #1PSTP
      *
      *  Access L2 to see if record exists
      *
     C*****KCSHL2        SETLL     @CSCHL2                                                  MD054955
     C*****KCSHL2        READE     @CSCHL2                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPACCD = :#1ACCD and CPCORR = :#1CORR and CPPTYP = :#1PTYP                    MD054955
     C+ and CPPSTP = :#1PSTP and CPRECI = 'D' and CPACCD <> '          '                    MD054955
     C+ order by CPACCD, CPCORR, CPPTYP, CPPSTP, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      * If found and not same sequence then error
      *
     C     *IN90         IFEQ      '0'
     C     #1SEQN        ANDNE     CPSEQN
     C                   MOVEL     '1'           @I1(32)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1487'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
     C                   OTHER
      *
     C***********KCSHL8    KLIST                                          082944
     C***********          KFLD           #1CORR
     C     KCSHL5        KLIST                                                                 08294
     C                   KFLD                    #TPCOR                                        08294
     C                   KFLD                    #1PTYP
     C                   KFLD                    #1PSTP
     C                   KFLD                    #1CORR                                        08294
      *                                                                   082944
      * Set up primary correspondent                                      082944
      *                                                                   082944
     C     *LIKE         DEFINE    #1PCOR        #TPCOR                                        08294
     C     #1PCOR        IFNE      *BLANKS                                                     08294
     C                   MOVEL     #1PCOR        #TPCOR                         Primary Corresp08294
     C                   ELSE                                                                  08294
     C                   MOVEL     #1CORR        #TPCOR                         Primary Corresp08294
     C                   END                                                                   08294
      *
      ***Access*L8*to*see*if*record*exists                                082944
      *  Access L5 to see if record exists                                082944
      *
     C***********KCSHL8    SETLL@CSCHL8                                   082944
     C***********KCSHL8    READE@CSCHL8                  90               082944
     C*****KCSHL5        SETLL     @CSCHL5                                            08294 MD054955
     C*****KCSHL5        READE     @CSCHL5                                90          08294 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPPCOR = :#TPCOR and CPPTYP = :#1PTYP and CPPSTP = :#1PSTP                    MD054955
     C+ and CPCORR = :#1CORR and CPRECI = 'D'                                               MD054955
     C+ order by CPPCOR, CPPTYP, CPPSTP, CPCORR, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      * If found and not same sequence then error
      *
     C     *IN90         IFEQ      '0'
     C     #1SEQN        ANDNE     CPSEQN
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1487'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
     C                   ENDSL
      *
      * If account entered then must same customer as Primary Corr.
      *
     C     #1MACT        IFNE      *BLANK
      *
      *  Get correspondent information
      *
     C     #1PCOR        IFEQ      *BLANK                                       IF
     C     #1CORR        CHAIN     @CORRL1                            90
     C                   ELSE                                                   FI
     C     #1PCOR        CHAIN     @CORRL1                            90
     C                   END                                                    FI
      *
     C     *LIKE         DEFINE    CDCUST        ##CUST
     C     6             SUBST     #1MACT:1      ##CUST
      *
      * Customer numbers must be equal
      *
     C     ##CUST        IFNE      CDCUST
     C                   MOVEL     '1'           @I1(34)
     C                   MOVEL     '1'           @I1(31)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1486'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Validate if print schedule and day number are valid
      *
      * Day number may only be specified if print schedule defined
      *
     C     #1PSCH        IFEQ      *BLANK                                       IF
     C     #SSFDY        ANDNE     *BLANKS                                      IF
     C                   MOVEL     '1'           @I1(38)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1483'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Check that print schedule is valid
      *
     C     #1PSCH        IFNE      *BLANK                                       IF
      *
      * Call access object to validate frequency specification
      *
     C                   CALL      'CG99FREQ'
     C                   PARM      *BLANKS       O1RTN             7
     C                   PARM      '*VERIFY'     O1ACT             8
     C                   PARM      STFREQ        O1FREQ           10
     C                   PARM      *ZEROS        O1RDNB            5 0
     C                   PARM      #1SFDY        O1MDAY            2 0
     C                   PARM      *BLANKS       O1CCY             3
     C                   PARM      *BLANKS       O1LOC             3
     C                   PARM      *BLANKS       O1EXT           256
      *
     C     O1RTN         IFNE      *BLANK                                       IF
     C                   MOVEA     '11'          @I1(37)
     C                   SETON                                        99        *
     C                   MOVEL     O1RTN         ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Print date must be greater than or eqaul to today
      *
     C     #1PSCH        IFNE      *BLANK                                       IF
     C                   SELECT
     C     #1NPDT        WHENGT    0
     C     STFREQ        ANDEQ     ##HOLD
     C     #1NPDT        ORGT      0
     C     STFREQ        ANDEQ     ##SPRS
     C     #1NPDT        ORGT      0
     C     STFREQ        ANDEQ     ##IMED
     C                   MOVEL     '1'           @I1(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1458'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C     STFREQ        WHENEQ    ##HOLD
     C     STFREQ        OREQ      ##SPRS
     C                   Z-ADD     -1            #1NPDT
      *
     C     STFREQ        WHENEQ    ##IMED
     C                   Z-ADD     0             #1NPDT
      *
     C                   OTHER
     C                   ENDSL                                                  FI
     C                   END                                                    FI
      *
     C     #SNPDT        IFNE      *BLANKS
     C     #1NPDT        ANDLT     WURDNB                                       IF
     C                   MOVEL     '1'           @I1(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1484'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *                                                                   079843
      * Print date is mandatory if schedule input and not SPECIAL         079843
      *                                                                   079843
     C     #SNPDT        IFEQ      *BLANKS                                                     07984
     C     #1PSCH        ANDNE     *BLANKS                                      IF             07984
     C     STFREQ        ANDNE     ##HOLD                                                      07984
     C     STFREQ        ANDNE     ##SPRS                                                      07984
     C     STFREQ        ANDNE     ##IMED                                                      07984
     C                   MOVEL     '1'           @I1(39)                                       07984
     C                   SETON                                        99        *              07984
     C                   MOVEL     'CGD1655'     ZAMSID                                        07984
     C                   EXSR      ZASNMS                                                      07984
     C                   END                                                                   07984
      *                                                                   079843
      * If not frequency then print date must be blank                    079843
      *                                                                   079843
     C     #SNPDT        IFNE      *BLANKS                                                     07984
     C     #1PSCH        ANDEQ     *BLANKS                                      IF             07984
     C                   MOVEL     '1'           @I1(39)                                       07984
     C                   SETON                                        99        *              07984
     C                   MOVEL     'CGD1659'     ZAMSID                                        07984
     C                   EXSR      ZASNMS                                                      07984
     C                   END                                                                   07984
      *
      * Reset date must be greater than or equal to run date
      *
     C     #SRDTE        IFNE      *BLANK                                       IF
     C     #1RDTE        ANDLT     WURDNB                                       IF
     C                   MOVEL     '1'           @I2(33)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1485'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
     C*                                                                   082886
     C*** Reset date is mandatory if frequency input                      082886
     C     #SRDTE        IFEQ      *BLANKS                                                     08288
     C     #1RFRQ        ANDNE     *BLANKS                                                     08288
     C                   MOVEL     '1'           @I2(33)                                       08288
     C                   SETON                                        99                       08288
     C                   MOVEL     'CGD1801'     ZAMSID                                        08288
     C                   EXSR      ZASNMS                                                      08288
     C                   END                                                                   08288
     C*                                                                   082886
     C*** Reset date must be blank if no frequency                        082886
     C     #SRDTE        IFNE      *BLANKS                                                     08288
     C     #1RFRQ        ANDEQ     *BLANKS                                                     08288
     C                   MOVEL     '1'           @I2(33)                                       08288
     C                   SETON                                        99                       08288
     C                   MOVEL     'CGD1802'     ZAMSID                                        08288
     C                   EXSR      ZASNMS                                                      08288
     C                   END                                                                   08288
     C*                                                                   082886
     C* Day number may only be specified if frequency defined             082886
     C     #1RFRQ        IFEQ      *BLANK                                                      08288
     C     #SRSDN        ANDNE     *BLANKS                                                     08288
     C                   MOVEL     '1'           @I2(35)                                       08288
     C                   SETON                                        99                       08288
     C                   MOVEL     'CGD1803'     ZAMSID                                        08288
     C                   EXSR      ZASNMS                                                      08288
     C                   END                                                                   08288
     C*                                                                   082886
     C*** Reset frequency required                                        082886
     C     #1RFRQ        IFNE      *BLANK                                                      08288
      *                                                                   082886
      * Call access object to validate frequency specification            082886
     C                   MOVEL     *BLANKS       O1FREQ                                        08288
     C                   MOVEL     #1RFRQ        O1FREQ                                        08288
      *                                                                   082886
     C                   CALL      'CG99FREQ'                                                  08288
     C                   PARM      *BLANKS       O1RTN             7                           08288
     C                   PARM      '*VERIFY'     O1ACT             8                           08288
     C                   PARM                    O1FREQ           10                           08288
     C                   PARM      *ZEROS        O1RDNB            5 0                         08288
     C                   PARM      #1RSDN        O1MDAY            2 0                         08288
     C                   PARM      *BLANKS       O1CCY             3                           08288
     C                   PARM      *BLANKS       O1LOC             3                           08288
     C                   PARM      *BLANKS       O1EXT           256                           08288
      *                                                                   082886
     C     O1RTN         IFNE      *BLANK                                                      08288
     C                   MOVEA     '11'          @I2(34)                                       08288
     C                   SETON                                        99                       08288
     C                   MOVEL     O1RTN         ZAMSID                                        08288
     C                   EXSR      ZASNMS                                                      08288
     C                   END                                                                   08288
     C                   END                                                                   08288
      *
      * Charge Currency required if charge per item specified
      * Charge Currency required if charge not posted specified
      * Charge Currency required if charge account specified
      * Charge Currency required if post charge frequency specified
      *
     C     #1CCCY        IFEQ      *BLANK                                       IF
     C***********#SCITM    ANDEQ*ZERO                      IF             086588
     C     #SCITM        ANDNE     *BLANKS                                      IF             08658
     C     #1CCCY        OREQ      *BLANK                                       IF
     C***********#SBSNB    ANDEQ*ZERO                      IF             086588
     C     #SBSNB        ANDNE     *BLANKS                                      IF             08658
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #1CACT        ANDNE     *BLANKS                                      IF
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #1CFRQ        ANDNE     *BLANKS                                      IF
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #SPDAY        ANDNE     *BLANKS                                      IF
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #SNTDT        ANDNE     *BLANKS                                      IF
     C     #1CCCY        OREQ      *BLANK                                       IF
     C     #1ACHG        ANDNE     *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(36)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1459'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EXXVAL
     C                   END                                                    FI
      *                                                                   079846
      * Apply Charge required if currency specified                       079846
      *                                                                   079846
     C     #1ACHG        IFEQ      *BLANKS                                      IF             07984
     C     #1CCCY        ANDNE     *BLANKS                                      IF             07984
     C                   MOVEL     '1'           @I2(36)                                       07984
     C                   MOVEL     '1'           @I2(43)                                       07984
     C                   SETON                                        99        *              07984
      * Send message '*Value required'                                    079846
     C                   MOVEL     'CGD1813'     ZAMSID                                        07984
     C                   EXSR      ZASNMS                                                      07984
     C                   END                                                    FI             07984
      *
      * Charge Account must not be specified if apply charge "N"
      * or blank
      *
     C     #1CACT        IFNE      *BLANK                                       IF
     C     #1ACHG        ANDEQ     *BLANK                                       IF
     C     #1CACT        ORNE      *BLANK                                       IF
     C     #1ACHG        ANDEQ     'N'                                          IF
     C                   MOVEL     '1'           @I2(43)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1460'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Charge Account must be in charge currency
      *
     C     #1CACT        IFNE      *BLANK                                       IF
     C     #1CCCY        ANDNE     ##CCY
     C                   MOVEL     '1'           @I2(39)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1461'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Next posting date must be greater than or equal to run date
      *
     C     #SNTDT        IFNE      *BLANK                                       IF
     C     #1NTDT        ANDLT     WURDNB                                       IF
     C                   MOVEL     '1'           @I2(42)
     C                   SETON                                        99        *
     C***********          MOVEL'CGD1461' ZAMSID                          079843
     C                   MOVEL     'CGD1814'     ZAMSID                                        07984
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *                                                                   079843
      * Post date is mandatory if schedule input                          079843
      *                                                                   079843
     C     #SNTDT        IFEQ      *BLANKS                                                     07984
     C     #1CFRQ        ANDNE     *BLANKS                                      IF             07984
     C                   MOVEL     '1'           @I2(42)                                       07984
     C                   SETON                                        99        *              07984
     C                   MOVEL     'CGD1656'     ZAMSID                                        07984
     C                   EXSR      ZASNMS                                                      07984
     C                   END                                                                   07984
      *                                                                   079843
      * Post date must be blank if no frequency                           079843
      *                                                                   079843
     C     #SNTDT        IFNE      *BLANKS                                                     07984
     C     #1CFRQ        ANDEQ     *BLANKS                                      IF             07984
     C                   MOVEL     '1'           @I2(42)                                       07984
     C                   SETON                                        99        *              07984
     C                   MOVEL     'CGD1663'     ZAMSID                                        07984
     C                   EXSR      ZASNMS                                                      07984
     C                   END                                                                   07984
      *                                                                   079846
      * Day number may only be specified if frequency defined             079846
      *                                                                   079846
     C     #1CFRQ        IFEQ      *BLANK                                       IF             07984
     C     #SPDAY        ANDNE     *BLANKS                                      IF             07984
     C                   MOVEL     '1'           @I2(42)                                       07984
     C                   SETON                                        99        *              07984
     C                   MOVEL     'CGD1664'     ZAMSID                                        07984
     C                   EXSR      ZASNMS                                                      07984
     C                   END                                                    FI             07984
      *
      * Post charge frequency required
      *
     C     #1CFRQ        IFNE      *BLANK                                       IF
      *
      * Call access object to validate frequency specification
      *
     C                   MOVEL     *BLANKS       O1FREQ
     C                   MOVEL     #1CFRQ        O1FREQ
      *
     C                   CALL      'CG99FREQ'
     C                   PARM      *BLANKS       O1RTN             7
     C                   PARM      '*VERIFY'     O1ACT             8
     C                   PARM                    O1FREQ           10
     C                   PARM      *ZEROS        O1RDNB            5 0
     C                   PARM      #1PDAY        O1MDAY            2 0
     C                   PARM      *BLANKS       O1CCY             3
     C                   PARM      *BLANKS       O1LOC             3
     C                   PARM      *BLANKS       O1EXT           256
      *
     C     O1RTN         IFNE      *BLANK                                       IF
     C                   MOVEA     '11'          @I2(40)
     C                   SETON                                        99        *
     C                   MOVEL     O1RTN         ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
     C                   END                                                    FI
      *
      * Charge per item must be numeric
      *
     C     #SCITM        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SCITM        ZFIELD
     C     13            SUB       A6NBDP        ZADIG
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      A6NBDP        ZADEC             1 0          I:No Of Decs
     C                   PARM                    ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(37)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1462'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1CITM
     C                   END                                                    FI
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1CITM
     C                   END                                                    FI
      *
      * Charge per item required if charge currency entered
      *
     C     #1CITM        IFLT      1
     C     #1CCCY        ANDNE     *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(37)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1463'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Charge not posted must be numeric
      *
     C     #SBSNB        IFNE      *BLANKS                                      IF
      *
      * Validate number
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      #SBSNB        ZFIELD
     C     13            SUB       A6NBDP        ZADIG
      *
     C                   CALL      'ZALIGN'                                     Entry parameter
     C                   PARM      *BLANKS       ZRTN              7            B:Return Code
     C                   PARM                    ZFIELD           16            B:Check Field
     C                   PARM      A6NBDP        ZADEC             1 0          I:No Of Decs
     C                   PARM                    ZADIG             2 0          I:No Of Digits
     C                   PARM                    ZAFLD            16            O:Check Field
      *
      * Check to see if field is numeric
      *
     C     ZRTN          IFNE      *BLANKS                                      IF
     C                   MOVEL     '1'           @I2(38)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1464'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   FI
      *
     C                   MOVE      ZAFLD         #1BSNB
     C                   END                                                    FI
     C                   ELSE                                                   FI
     C                   Z-ADD     0             #1BSNB
     C                   END                                                    FI
      *
      * Re format charges accumlated to date
      *
     C     CPCACC        IFGT      0
     C     P1ACTC        ANDNE     'I'
     C     #1CCCY        ANDNE     *BLANKS
     C                   Z-ADD     CDCACC        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C                   MOVE      ZOUT21        #SCACC
     C                   ELSE
     C                   MOVEL     *BLANKS       #SCACC
      *
      * Zeroise charges accumlated to date
      *
     C                   Z-ADD     0             #1CACC
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXXVAL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMTSK        ANDEQ     'N'
     C                   ROLBK
     C                   ELSE
     C                   SETON                                        U7U8
     C                   ENDIF
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMTSK        ANDEQ     'N'
     C                   COMMIT
     C                   ENDIF
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * EDTRCD: Process cmds - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Command Keys
     C/COPY WNCPYSRC,CG0280DPCK
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'R'           W0RPT
     C                   END
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Corr. Schedules - Correspondent Schedule  *
     C                   EXSR      SACRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Corr. Schedules - Correspondent Schedule  *
     C                   EXSR      SCCHRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Corr. Schedules - Correspondent Schedule  *
     C                   EXSR      SDCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P2PTYP        IFEQ      *BLANK                                       Print Item Type
     C     P1ACTC        ANDEQ     'I'
     C     P2PSTP        OREQ      *BLANK                                       Print Item Sub-
     C     P1ACTC        ANDEQ     'I'
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen
     C                   SETON                                        88        *
     C     W0SCR         IFNE      1
     C                   MOVEL     '0'           *IN79
     C                   END
     C     W0SCR         IFNE      2
     C                   MOVEL     '0'           *IN79
     C                   MOVEL     '0'           *IN78
     C                   END
     C     W0SCR         IFEQ      1
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'E'                                          *IF
     C     P1ACTC        OREQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   ELSE
     C     W0SCR         IFEQ      2
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'E'                                          *IF
     C     P1ACTC        OREQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   END
     C                   END
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   MOVEL     *BLANK        #1RECI                         Record Identifi
     C                   Z-ADD     *ZERO         #1OSQN                         Output Sequence
     C                   Z-ADD     *ZERO         #1NPAG                         Number of Pages
     C                   Z-ADD     *ZERO         #1TPAG                         Total Number of
     C                   Z-ADD     *ZERO         #1RDTE                         Reset Date
     C                   MOVEL     *BLANK        #1RFRQ                         Reset Frequency
     C                   Z-ADD     *ZERO         #1RSDN                         Reset dayno.   08288
     C                   MOVEL     *BLANK        #1CCCY                         Charge Currency
     C                   Z-ADD     *ZERO         #1CITM                         Charge per item
     C                   Z-ADD     *ZERO         #1BSNB                         Charge Not Post
     C                   Z-ADD     *ZERO         #1CACC                         Charge Accumlat
     C                   MOVEL     *BLANK        #1CFRQ                         Post charge fre
     C                   Z-ADD     *ZERO         #1NTDT                         Next Post Date
     C                   MOVEL     *BLANK        #1ACHG                         Apply Charge
     C                   MOVEL     *BLANK        #1CACT                         Charge Account
     C                   Z-ADD     *ZERO         #1PDAY                         Post Charges da
     C                   MOVEL     *BLANK        #1AJOB                         Job name
     C                   MOVEL     *BLANK        #1AUSR                         User name
     C                   Z-ADD     *ZERO         #1ATIM                         Action Time
     C                   MOVEL     *BLANK        #1ARDT                         Action Date
     C                   MOVEL     *BLANK        #1AACT                         Action Type
     C                   Z-ADD     *ZERO         #1RDNB                         Run day number
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     *BLANK        #1MACT                         Midas Account I
     C                   MOVEL     *BLANK        #1ACCD                         Account Code
     C                   MOVEL     *BLANK        #1APDF                         Defaults must b
     C                   MOVEL     *BLANK        #1PCOR                         Primary Corresp
     C                   MOVEL     *BLANK        #1LGID                         Language identi
     C                   MOVEL     *BLANK        #1MSHC                         Mail Shot code
     C                   MOVEL     *BLANK        #1PSCH                         Print Schedule
     C                   Z-ADD     *ZERO         #1SFDY                         Frequency Day N
     C                   Z-ADD     *ZERO         #1NPDT                         Next Print Date
     C                   Z-ADD     *ZERO         #1RETP                         Retention Perio
     C                   MOVEL     *BLANK        #1PLAB                         Print Address L
      *                                                                   079846
      * Initialise screen numeric fields                                  079846
      *                                                                   079846
     C                   MOVEL     *BLANK        #SSFDY                         Day Number     07984
     C                   MOVEL     *BLANK        #SNPDT                         Print Date     07984
     C                   MOVEL     *BLANK        #SRETP                         Retention Perio07984
     C                   MOVEL     *BLANK        #SOSQN                         Output Seq.    07984
     C                   MOVEL     *BLANK        #SNPAG                         Page Number    07984
     C                   MOVEL     *BLANK        #SRDTE                         Reset Date     07984
     C                   MOVEL     *BLANK        #SRSDN                         Reset Day Num. 07984
     C                   MOVEL     *BLANK        #SCITM                         Item Charge    07984
     C                   MOVEL     *BLANK        #SBSNB                         Not Posted     07984
     C                   MOVEL     *BLANK        #SCACC                         Accum. To Date 07984
     C                   MOVEL     *BLANK        #SPDAY                         Post Day Number07984
     C                   MOVEL     *BLANK        #SNTDT                         Next Date      07984
      *
      * Fill Command lines and narrative text from messages
      *
     C                   SELECT
      *
      * Insert screen
      *
     C     P1ACTC        WHENEQ    'I'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1344'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys
      *
     C                   MOVEL     'CGD1134'     ##PG1
     C******************** MOVEL'CGD1136' ##PG2                           083687
     C                   MOVEL     'CGD2507'     ##PG2                                         08368
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1345'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys
      *
     C                   MOVEL     'CGD1134'     ##PG1
     C******************** MOVEL'CGD1136' ##PG2                           083687
     C                   MOVEL     'CGD2507'     ##PG2
      *
      *
      * Amendment screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1346'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys
      *
     C                   MOVEL     'CGD1134'     ##PG1
     C******************** MOVEL'CGD1136' ##PG2                           083687
     C                   MOVEL     'CGD2507'     ##PG2                                         08368
      *
      *
      * Delete screen
      *
     C     P1ACTC        WHENEQ    'D'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1347'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys and allow delete key
      *
     C                   MOVEL     'CGD1137'     ##PG1
     C******************** MOVEL'CGD1139' ##PG2                           083687
     C                   MOVEL     'CGD2508'     ##PG2                                         08368
     C                   MOVEL     '1'           *IN77
      *
     C                   ENDSL
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       #ACMD1
     C                   MOVEL     *BLANKS       #BCMD1
      *
      * Function keys page 1
      *
     C     *LIKE         DEFINE    #MSGID        ##PG1
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      ##PG1         #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #ACMD2
      *
      * Function keys page 2
      *
     C     *LIKE         DEFINE    #MSGID        ##PG2
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      ##PG2         #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #BCMD2
      *
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @CSCHL1 fields to screen
      *================================================================
     C                   Z-ADD     CPSEQN        #1SEQN                         Sequence Number
     C                   MOVEL     CPRECI        #1RECI                         Record Identifi
     C                   Z-ADD     CPOSQN        #1OSQN                         Output Sequence
     C                   Z-ADD     CPNPAG        #1NPAG                         Number of Pages
     C                   Z-ADD     CPTPAG        #1TPAG                         Total Number of
     C                   Z-ADD     CPRDTE        #1RDTE                         Reset Date
     C                   MOVEL     CPRFRQ        #1RFRQ                         Reset Frequency
     C                   Z-ADD     CPRSDN        #1RSDN                         Reset dayno.   08288
     C                   MOVEL     CPCCCY        #1CCCY                         Charge Currency
     C                   Z-ADD     CPCITM        #1CITM                         Charge per item
     C                   Z-ADD     CPBSNB        #1BSNB                         Charge Not Post
     C                   Z-ADD     CPCACC        #1CACC                         Charge Accumlat
     C                   MOVEL     CPCFRQ        #1CFRQ                         Post charge fre
     C                   Z-ADD     CPNTDT        #1NTDT                         Next Post Date
     C                   MOVEL     CPACHG        #1ACHG                         Apply Charge
     C                   MOVEL     CPCACT        #1CACT                         Charge Account
     C                   Z-ADD     CPPDAY        #1PDAY                         Post Charges da
     C                   MOVEL     CPAJOB        #1AJOB                         Job name
     C                   MOVEL     CPAUSR        #1AUSR                         User name
     C                   Z-ADD     CPATIM        #1ATIM                         Action Time
     C                   MOVEL     CPARDT        #1ARDT                         Action Date
     C                   MOVEL     CPAACT        #1AACT                         Action Type
     C                   Z-ADD     CPRDNB        #1RDNB                         Run day number
     C                   MOVEL     CPCORR        #1CORR                         Correspondent
     C                   MOVEL     CPPTYP        #1PTYP                         Print Item Type
     C                   MOVEL     CPPSTP        #1PSTP                         Print Item Sub-
     C                   MOVEL     CPMACT        #1MACT                         Midas Account I
     C                   MOVEL     CPACCD        #1ACCD                         Account Code
     C                   MOVEL     CPAPDF        #1APDF                         Defaults must b
     C     CPPCOR        IFNE      CDCORR
     C                   MOVEL     CPPCOR        #1PCOR                         Primary Corresp
     C                   ELSE
     C                   MOVEL     *BLANKS       #1PCOR                         Primary Corresp
     C                   END
     C                   MOVEL     CPLGID        #1LGID                         Language identi
     C                   MOVEL     CPMSHC        #1MSHC                         Mail Shot code
     C                   MOVEL     CPPSCH        #1PSCH                         Print Schedule
     C                   Z-ADD     CPSFDY        #1SFDY                         Frequency Day N
     C                   Z-ADD     CPNPDT        #1NPDT                         Next Print Date
     C                   Z-ADD     CPRETP        #1RETP                         Retention Perio
     C                   MOVEL     CPPLAB        #1PLAB                         Print Address L
      * Hold existing record image
     C                   eval      @1DBRC = CGCSCH                                          MD054955
     C                   MOVEL     @1DBRC        #1DBRC
      *
      * Delete screen
      *
     C     P1ACTC        IFEQ      'D'
     C                   MOVEL     '1'           *IN77
     C                   END
      *
      *  Format Print day number
      *
     C     CPSFDY        IFGT      0
     C                   Z-ADD     CPSFDY        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     2             SUBST     ZOUT21:19     #SSFDY
     C                   ELSE
     C                   MOVEL     *BLANKS       #SSFDY
     C                   END
      *
      *  Print date
      *
     C     CPNPDT        IFGT      0
     C                   Z-ADD     CPNPDT        W2DAYN                         Creation date
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2DATE        #SNPDT                         Creation date
     C                   ELSE
     C                   MOVEL     *BLANKS       #SNPDT                         Creation date
     C                   END
      *
      *  Format retention period
      *
     C     CPRETP        IFGT      0
     C                   Z-ADD     CPRETP        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
     C/COPY WNCPYSRC,CG0280C003
      *
     C********** 2         SUBSTZOUT21:19 #SRETP                                              117207
     C     4             SUBST     ZOUT21:17     #SRETP
     C/COPY WNCPYSRC,CG0280C004
     C                   ELSE
     C                   MOVEL     *BLANKS       #SRETP
     C                   END
      *
      *  Format Reset date
      *
     C     CPRDTE        IFGT      0
     C                   Z-ADD     CPRDTE        W2DAYN                         Reset date
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C*********************MOVELW2FDAT    #SRDTE           Reset date     082886
     C                   MOVEL     W2DATE        #SRDTE                         Reset date     08288
     C                   ELSE
     C                   MOVEL     *BLANKS       #SRDTE                         Reset date
     C                   END
      *
      *  Format Reset day number
      *
     C     CPRSDN        IFGT      0
     C                   Z-ADD     CPRSDN        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     2             SUBST     ZOUT21:19     #SRSDN
     C                   ELSE
     C                   MOVEL     *BLANKS       #SRSDN
     C                   END
      *
      *  Format Output sequence
      *
     C     CPOSQN        IFGT      0
     C                   Z-ADD     CPOSQN        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     5             SUBST     ZOUT21:16     #SOSQN
     C                   ELSE
     C                   MOVEL     *BLANKS       #SOSQN
     C                   END
      *
      *  Format Number of Pages
      *
     C     CPNPAG        IFGT      0
     C                   Z-ADD     CPNPAG        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     5             SUBST     ZOUT21:16     #SNPAG
     C                   ELSE
     C                   MOVEL     *BLANKS       #SNPAG
     C                   END
      *
      *  Obtain Currency decimal places.
      *
     C     CPCCCY        IFNE      *BLANKS
      *
      *  Format Post day number
      *
     C     CPPDAY        IFGT      0
     C***********          Z-ADDCDPDAY    ZFLD15                          082886
     C                   Z-ADD     CPPDAY        ZFLD15                                        08288
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     2             SUBST     ZOUT21:19     #SPDAY
     C                   ELSE
     C                   MOVEL     *BLANKS       #SPDAY
     C                   END
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CDCCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      *  Format Charge per item
      *
     C     CPCITM        IFGT      0
     C                   Z-ADD     CPCITM        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     14            SUBST     ZOUT21:7      #SCITM
     C                   ELSE
     C                   MOVEL     *BLANKS       #SCITM
     C                   END
      *
      *  Format Charge not posted
      *
     C     CPBSNB        IFGT      0
     C                   Z-ADD     CPBSNB        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C     14            SUBST     ZOUT21:7      #SBSNB
     C                   ELSE
     C                   MOVEL     *BLANKS       #SBSNB
     C                   END
      *
      *  Format Charge accumulated to date
      *
     C     CPCACC        IFGT      0
     C                   Z-ADD     CPCACC        ZFLD15
      *
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C                   MOVE      ZOUT21        #SCACC
     C                   ELSE
     C                   MOVEL     *BLANKS       #SCACC
     C                   END
      *
     C                   END
     C*                                                                   082886
     C*** Format Next Post Date                                           082886
     C*                                                                   082886
     C     CPNTDT        IFGT      0                                                           08288
     C                   Z-ADD     CPNTDT        W2DAYN                                        08288
     C*                                                                   082886
     C*  Convert Midas Day no. to system date                             082886
     C                   CALL      'ZDATE2'                             90                     08288
     C                   PARM                    W2DAYN            5 0          Day No.        08288
     C                   PARM      WUDFF         W2DTFM            1            Date Format    08288
     C                   PARM      *ZEROS        W2DATE            6 0          Date           08288
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY        08288
      *                                                                   082886
     C                   MOVEL     W2DATE        #SNTDT                                        08288
     C                   ELSE                                                                  08288
     C                   MOVEL     *BLANKS       #SNTDT                                        08288
     C                   END                                                                   08288
      *
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   Z-ADD     P2SEQN        #1SEQN                         Sequence Number
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     P2CORR        #1CORR                         Correspondent
     C                   MOVEL     P2PTYP        #1PTYP                         Print Item Type
     C                   MOVEL     P2PSTP        #1PSTP                         Print Item Sub-
      * Check restriction within
     C                   EXSR      VFCKRL
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1344'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONKY
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       #KCMD1
      *
      * Function keys
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1021'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #KCMD2
      * USER: Initialize key screen
      * EDTRCD: Init. key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Key Screen
     C/COPY WNCPYSRC,CG0280DIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Corr. Schedules - Correspondent Schedule  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @CSCHL0
     C                   MOVEL     #1CORR        CPCORR                         Correspondent
     C                   MOVEL     #1PTYP        CPPTYP                         Print Item Type
     C                   MOVEL     #1PSTP        CPPSTP                         Print Item Sub-
     C                   Z-ADD     #1SEQN        CPSEQN                         Sequence Number
     C                   MOVEL     'D'           CPRECI                         Record Identifi
     C                   MOVEL     #1PSCH        CPPSCH                         Print Schedule
     C     #1PCOR        IFNE      #1CORR
     C     #1PCOR        ANDNE     *BLANKS
     C                   MOVEL     #1PCOR        CPPCOR                         Primary Corresp
     C                   ELSE
     C                   MOVEL     #1CORR        CPPCOR                         Primary Corresp
     C                   END
     C                   MOVEL     #1LGID        CPLGID                         Language identi
     C                   MOVEL     #1ACCD        CPACCD                         Account Code
     C                   Z-ADD     #1NPDT        CPNPDT                         Next Print Date
     C                   MOVEL     #1MACT        CPMACT                         Midas Account I
     C                   MOVEL     #1PLAB        CPPLAB                         Print Address L
     C                   Z-ADD     #1SFDY        CPSFDY                         Frequency Day N
     C                   Z-ADD     #1RETP        CPRETP                         Retention Perio
     C                   MOVEL     #1MSHC        CPMSHC                         Mail Shot code
     C                   MOVEL     #1APDF        CPAPDF                         Defaults must b
     C                   Z-ADD     #1OSQN        CPOSQN                         Output Sequence
     C                   Z-ADD     #1NPAG        CPNPAG                         Number of Pages
     C                   Z-ADD     #1TPAG        CPTPAG                         Total Number of
     C                   Z-ADD     #1RDTE        CPRDTE                         Reset Date
     C                   MOVEL     #1RFRQ        CPRFRQ                         Reset Frequency
     C                   Z-ADD     #1RSDN        CPRSDN                         Reset dayno.   08288
     C                   MOVEL     #1CCCY        CPCCCY                         Charge Currency
     C                   Z-ADD     #1CITM        CPCITM                         Charge per item
     C                   Z-ADD     #1BSNB        CPBSNB                         Charge Not Post
     C                   Z-ADD     #1CACC        CPCACC                         Charge Accumlat
     C                   MOVEL     #1CFRQ        CPCFRQ                         Post charge fre
     C                   Z-ADD     #1NTDT        CPNTDT                         Next Post Date
     C                   MOVEL     #1ACHG        CPACHG                         Apply Charge
     C                   MOVEL     #1CACT        CPCACT                         Charge Account
     C                   Z-ADD     #1PDAY        CPPDAY                         Post Charges da
     C                   MOVEL     ##JOB         CPAJOB                         Job name
     C                   MOVEL     ##USR         CPAUSR                         User name
     C                   Z-ADD     ##JTM         CPATIM                         Action Time
     C                   MOVEL     WUMRDT        CPARDT                         Action Date
     C                   MOVEL     'I'           CPAACT                         Action Type
     C                   Z-ADD     WURDNB        CPRDNB                         Run day number
      *
     C     KLCRSA        KLIST
     C                   KFLD                    CPCORR                         Correspondent
     C                   KFLD                    CPPTYP                         Print Item Type
     C                   KFLD                    CPPSTP                         Print Item Sub-
     C                   KFLD                    CPSEQN                         Sequence Number
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @CSCHL0                                90    *           MD054955
     C*EXEC*SQL*                                                                   MD054955 MD055928
     C**SELECT**                                                                   MD054955 MD055928
     C**into**CGCSCH                                                               MD054955 MD055928
     C**from*CGCSHJW0                                                              MD054955 MD055928
     C**where*CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP           MD054955 MD055928
     C**and*CPSEQN = :CPSEQN                                                       MD054955 MD055928
     C*END-EXEC*                                                                   MD054955 MD055928
     C/EXEC SQL                                                                             MD055928
     C+ declare BCursor insensitive scroll cursor for                                       MD055928
     C+ select * from CGCSHJW0                                                              MD055928
     C+ where CPCORR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD055928
     C+ and CPSEQN = :CPSEQN                                                                MD055928
     C/END-EXEC                                                                             MD055928
                                                                                            MD055928
     C/EXEC SQL                                                                             MD055928
     C+ open BCursor                                                                        MD055928
     C/END-EXEC                                                                             MD055928
                                                                                            MD055928
     C/EXEC SQL                                                                             MD055928
     C+ get diagnostics :Found = DB2_NUMBER_ROWS                                            MD055928
     C/END-EXEC                                                                             MD055928
                                                                                            MD055928
     C/EXEC SQL                                                                             MD055928
     C+ close BCursor                                                                       MD055928
     C/END-EXEC                                                                             MD055928

     C                   SETOFF                                       90                    MD054955
     C**********         If        SQLCODE = 0                                     MD054955 MD055928
     C                   If        Found > 0                                                MD055928
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1340'     W0RTN             7
      * USER: Processing if Data record already exists
      * One or more parameters have been defaulted.
      * Field '(DB1) CPAPDF' defaulted for 'Defaults must be applied'.
      * Change Corr. Schedules - Correspondent Schedule  *
     C                   EXSR      SBCHRC
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********         WRITE     @CSCHL0                              91      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGCSHBTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   CPCORR                                                                            MD054955
     C+ , CPPTYP                                                                            MD054955
     C+ , CPPSTP                                                                            MD054955
     C+ , CPSEQN                                                                            MD054955
     C+ , CPRECI                                                                            MD054955
     C+ , CPPSCH                                                                            MD054955
     C+ , CPPCOR                                                                            MD054955
     C+ , CPLGID                                                                            MD054955
     C+ , QQACCD                                                                            MD054955
     C+ , CPNPDT                                                                            MD054955
     C+ , QQMACT                                                                            MD054955
     C+ , CPPLAB                                                                            MD054955
     C+ , CPSFDY                                                                            MD054955
     C+ , CPRETP                                                                            MD054955
     C+ , CPMSHC                                                                            MD054955
     C+ , CPAPDF                                                                            MD054955
     C+ , CPOSQN                                                                            MD054955
     C+ , CPNPAG                                                                            MD054955
     C+ , CPTPAG                                                                            MD054955
     C+ , CPRDTE                                                                            MD054955
     C+ , CPRFRQ                                                                            MD054955
     C+ , CPRSDN                                                                            MD054955
     C+ , CPCCCY                                                                            MD054955
     C+ , CPCITM                                                                            MD054955
     C+ , CPBSNB                                                                            MD054955
     C+ , CPCACC                                                                            MD054955
     C+ , CPCFRQ                                                                            MD054955
     C+ , CPNTDT                                                                            MD054955
     C+ , CPACHG                                                                            MD054955
     C+ , QQCACT                                                                            MD054955
     C+ , CPPDAY                                                                            MD054955
     C+ , CPAJOB                                                                            MD054955
     C+ , CPAUSR                                                                            MD054955
     C+ , CPATIM                                                                            MD054955
     C+ , CPARDT                                                                            MD054955
     C+ , CPAACT                                                                            MD054955
     C+ , CPRDNB                                                                            MD054955
     C+ , CPACCD                                                                            MD054955
     C+ , CPMACT                                                                            MD054955
     C+ , CPCACT                                                                            MD054955
     C+ , CPMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :CPCORR                                                                           MD054955
     C+ , :CPPTYP                                                                           MD054955
     C+ , :CPPSTP                                                                           MD054955
     C+ , :CPSEQN                                                                           MD054955
     C+ , :CPRECI                                                                           MD054955
     C+ , :CPPSCH                                                                           MD054955
     C+ , :CPPCOR                                                                           MD054955
     C+ , :CPLGID                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPNPDT                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPPLAB                                                                           MD054955
     C+ , :CPSFDY                                                                           MD054955
     C+ , :CPRETP                                                                           MD054955
     C+ , :CPMSHC                                                                           MD054955
     C+ , :CPAPDF                                                                           MD054955
     C+ , :CPOSQN                                                                           MD054955
     C+ , :CPNPAG                                                                           MD054955
     C+ , :CPTPAG                                                                           MD054955
     C+ , :CPRDTE                                                                           MD054955
     C+ , :CPRFRQ                                                                           MD054955
     C+ , :CPRSDN                                                                           MD054955
     C+ , :CPCCCY                                                                           MD054955
     C+ , :CPCITM                                                                           MD054955
     C+ , :CPBSNB                                                                           MD054955
     C+ , :CPCACC                                                                           MD054955
     C+ , :CPCFRQ                                                                           MD054955
     C+ , :CPNTDT                                                                           MD054955
     C+ , :CPACHG                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPPDAY                                                                           MD054955
     C+ , :CPAJOB                                                                           MD054955
     C+ , :CPAUSR                                                                           MD054955
     C+ , :CPATIM                                                                           MD054955
     C+ , :CPARDT                                                                           MD054955
     C+ , :CPAACT                                                                           MD054955
     C+ , :CPRDNB                                                                           MD054955
     C+ , :CPACCD                                                                           MD054955
     C+ , :CPMACT                                                                           MD054955
     C+ , :CPCACT                                                                           MD054955
     C+ , 'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGCSHXTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   CPCORR                                                                            MD054955
     C+ , CPPTYP                                                                            MD054955
     C+ , CPPSTP                                                                            MD054955
     C+ , CPSEQN                                                                            MD054955
     C+ , CPRECI                                                                            MD054955
     C+ , CPPSCH                                                                            MD054955
     C+ , CPPCOR                                                                            MD054955
     C+ , CPLGID                                                                            MD054955
     C+ , QQACCD                                                                            MD054955
     C+ , CPNPDT                                                                            MD054955
     C+ , QQMACT                                                                            MD054955
     C+ , CPPLAB                                                                            MD054955
     C+ , CPSFDY                                                                            MD054955
     C+ , CPRETP                                                                            MD054955
     C+ , CPMSHC                                                                            MD054955
     C+ , CPAPDF                                                                            MD054955
     C+ , CPOSQN                                                                            MD054955
     C+ , CPNPAG                                                                            MD054955
     C+ , CPTPAG                                                                            MD054955
     C+ , CPRDTE                                                                            MD054955
     C+ , CPRFRQ                                                                            MD054955
     C+ , CPRSDN                                                                            MD054955
     C+ , CPCCCY                                                                            MD054955
     C+ , CPCITM                                                                            MD054955
     C+ , CPBSNB                                                                            MD054955
     C+ , CPCACC                                                                            MD054955
     C+ , CPCFRQ                                                                            MD054955
     C+ , CPNTDT                                                                            MD054955
     C+ , CPACHG                                                                            MD054955
     C+ , QQCACT                                                                            MD054955
     C+ , CPPDAY                                                                            MD054955
     C+ , CPAJOB                                                                            MD054955
     C+ , CPAUSR                                                                            MD054955
     C+ , CPATIM                                                                            MD054955
     C+ , CPARDT                                                                            MD054955
     C+ , CPAACT                                                                            MD054955
     C+ , CPRDNB                                                                            MD054955
     C+ , CPACCD                                                                            MD054955
     C+ , CPMACT                                                                            MD054955
     C+ , CPCACT                                                                            MD054955
     C+ , CPMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :CPCORR                                                                           MD054955
     C+ , :CPPTYP                                                                           MD054955
     C+ , :CPPSTP                                                                           MD054955
     C+ , :CPSEQN                                                                           MD054955
     C+ , :CPRECI                                                                           MD054955
     C+ , :CPPSCH                                                                           MD054955
     C+ , :CPPCOR                                                                           MD054955
     C+ , :CPLGID                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPNPDT                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPPLAB                                                                           MD054955
     C+ , :CPSFDY                                                                           MD054955
     C+ , :CPRETP                                                                           MD054955
     C+ , :CPMSHC                                                                           MD054955
     C+ , :CPAPDF                                                                           MD054955
     C+ , :CPOSQN                                                                           MD054955
     C+ , :CPNPAG                                                                           MD054955
     C+ , :CPTPAG                                                                           MD054955
     C+ , :CPRDTE                                                                           MD054955
     C+ , :CPRFRQ                                                                           MD054955
     C+ , :CPRSDN                                                                           MD054955
     C+ , :CPCCCY                                                                           MD054955
     C+ , :CPCITM                                                                           MD054955
     C+ , :CPBSNB                                                                           MD054955
     C+ , :CPCACC                                                                           MD054955
     C+ , :CPCFRQ                                                                           MD054955
     C+ , :CPNTDT                                                                           MD054955
     C+ , :CPACHG                                                                           MD054955
     C+ , ' '                                                                               MD054955
     C+ , :CPPDAY                                                                           MD054955
     C+ , :CPAJOB                                                                           MD054955
     C+ , :CPAUSR                                                                           MD054955
     C+ , :CPATIM                                                                           MD054955
     C+ , :CPARDT                                                                           MD054955
     C+ , :CPAACT                                                                           MD054955
     C+ , :CPRDNB                                                                           MD054955
     C+ , :CPACCD                                                                           MD054955
     C+ , :CPMACT                                                                           MD054955
     C+ , :CPCACT                                                                           MD054955
     C+ , 'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN91*        IFEQ      '1'                                                      MD055928
     C                   IF        SQLCODE <> 0                                             MD055928
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Corr. Schedules - Correspondent Schedule  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CSCHL0
     C                   MOVEL     #1CORR        CPCORR                         Correspondent
     C                   MOVEL     #1PTYP        CPPTYP                         Print Item Type
     C                   MOVEL     #1PSTP        CPPSTP                         Print Item Sub-
     C                   Z-ADD     #1SEQN        CPSEQN                         Sequence Number
      *
     C     KLCHSB        KLIST
     C                   KFLD                    CPCORR                         Correspondent
     C                   KFLD                    CPPTYP                         Print Item Type
     C                   KFLD                    CPPSTP                         Print Item Sub-
     C                   KFLD                    CPSEQN                         Sequence Number
     C*****KLCHSB        CHAIN     @CSCHL0                            9091      *           MD549555
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C**where*CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP           MD054955 MD055928
     C+ where CPCORR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD055928
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       9091                  MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * Move non-key fields to @CSCHL0
     C                   MOVEL     'D'           CPRECI                         Record Identifi
     C                   MOVEL     #1PSCH        CPPSCH                         Print Schedule
     C     #1PCOR        IFNE      #1CORR
     C     #1PCOR        ANDNE     *BLANKS
     C                   MOVEL     #1PCOR        CPPCOR                         Primary Corresp
     C                   ELSE
     C                   MOVEL     #1CORR        CPPCOR                         Primary Corresp
     C                   END
     C                   MOVEL     #1LGID        CPLGID                         Language identi
     C                   MOVEL     #1ACCD        CPACCD                         Account Code
     C                   Z-ADD     #1NPDT        CPNPDT                         Next Print Date
     C                   MOVEL     #1MACT        CPMACT                         Midas Account I
     C                   MOVEL     #1PLAB        CPPLAB                         Print Address L
     C                   Z-ADD     #1SFDY        CPSFDY                         Frequency Day N
     C                   Z-ADD     #1RETP        CPRETP                         Retention Perio
     C                   MOVEL     #1MSHC        CPMSHC                         Mail Shot code
     C                   Z-ADD     #1OSQN        CPOSQN                         Output Sequence
     C                   Z-ADD     #1NPAG        CPNPAG                         Number of Pages
     C                   Z-ADD     #1TPAG        CPTPAG                         Total Number of
     C                   Z-ADD     #1RDTE        CPRDTE                         Reset Date
     C                   MOVEL     #1RFRQ        CPRFRQ                         Reset Frequency
     C                   Z-ADD     #1RSDN        CPRSDN                         Reset dayno.   08288
     C                   MOVEL     #1CCCY        CPCCCY                         Charge Currency
     C                   Z-ADD     #1CITM        CPCITM                         Charge per item
     C                   Z-ADD     #1BSNB        CPBSNB                         Charge Not Post
     C                   Z-ADD     #1CACC        CPCACC                         Charge Accumlat
     C                   MOVEL     #1CFRQ        CPCFRQ                         Post charge fre
     C                   Z-ADD     #1NTDT        CPNTDT                         Next Post Date
     C                   MOVEL     #1ACHG        CPACHG                         Apply Charge
     C                   MOVEL     #1CACT        CPCACT                         Charge Account
     C                   Z-ADD     #1PDAY        CPPDAY                         Post Charges da
     C                   MOVEL     ##JOB         CPAJOB                         Job name
     C                   MOVEL     ##USR         CPAUSR                         User name
     C                   Z-ADD     ##JTM         CPATIM                         Action Time
     C                   MOVEL     WUMRDT        CPARDT                         Action Date
     C                   MOVEL     'I'           CPAACT                         Action Type
     C                   Z-ADD     WURDNB        CPRDNB                         Run day number
      *
     C**********         UPDATE    @CSCHL0                              91      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGCSHXTD set                                                                 MD054955
     C+   CPRECI = :CPRECI                                                                  MD054955
     C+ , CPPSCH = :CPPSCH                                                                  MD054955
     C+ , CPPCOR = :CPPCOR                                                                  MD054955
     C+ , CPLGID = :CPLGID                                                                  MD054955
     C+ , CPNPDT = :CPNPDT                                                                  MD054955
     C+ , CPPLAB = :CPPLAB                                                                  MD054955
     C+ , CPSFDY = :CPSFDY                                                                  MD054955
     C+ , CPRETP = :CPRETP                                                                  MD054955
     C+ , CPMSHC = :CPMSHC                                                                  MD054955
     C+ , CPOSQN = :CPOSQN                                                                  MD054955
     C+ , CPNPAG = :CPNPAG                                                                  MD054955
     C+ , CPTPAG = :CPTPAG                                                                  MD054955
     C+ , CPRDTE = :CPRDTE                                                                  MD054955
     C+ , CPRFRQ = :CPRFRQ                                                                  MD054955
     C+ , CPRSDN = :CPRSDN                                                                  MD054955
     C+ , CPCCCY = :CPCCCY                                                                  MD054955
     C+ , CPCITM = :CPCITM                                                                  MD054955
     C+ , CPBSNB = :CPBSNB                                                                  MD054955
     C+ , CPCACC = :CPCACC                                                                  MD054955
     C+ , CPCFRQ = :CPCFRQ                                                                  MD054955
     C+ , CPNTDT = :CPNTDT                                                                  MD054955
     C+ , CPACHG = :CPACHG                                                                  MD054955
     C+ , CPPDAY = :CPPDAY                                                                  MD054955
     C+ , CPAJOB = :CPAJOB                                                                  MD054955
     C+ , CPAUSR = :CPAUSR                                                                  MD054955
     C+ , CPATIM = :CPATIM                                                                  MD054955
     C+ , CPARDT = :CPARDT                                                                  MD054955
     C+ , CPAACT = :CPAACT                                                                  MD054955
     C+ , CPRDNB = :CPRDNB                                                                  MD054955
     C+ , CPACCD = :CPACCD                                                                  MD054955
     C+ , CPMACT = :CPMACT                                                                  MD054955
     C+ , CPCACT = :CPCACT                                                                  MD054955
     C**where*CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP           MD054955 MD055928
     C+ where CPCORR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD055928
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C******IN91*        IFEQ      '1'                                                      MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Delete Corr. Schedules - Correspondent Schedule  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CSCHL0
     C                   MOVEL     #1CORR        CPCORR                         Correspondent
     C                   MOVEL     #1PTYP        CPPTYP                         Print Item Type
     C                   MOVEL     #1PSTP        CPPSTP                         Print Item Sub-
     C                   Z-ADD     #1SEQN        CPSEQN                         Sequence Number
      *
     C     KLCHSC        KLIST
     C                   KFLD                    CPCORR                         Correspondent
     C                   KFLD                    CPPTYP                         Print Item Type
     C                   KFLD                    CPPSTP                         Print Item Sub-
     C                   KFLD                    CPSEQN                         Sequence Number
     C*****KLCHSC        CHAIN     @CSCHL0                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       9091                  MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * Do not allow deletion of core schedule                                              MD054955
     C     CPCORR        IFEQ      'SYSTEM'                                                 MD054955
     C     CPSEQN        ANDEQ     1                                                        MD054955
     C                   MOVEL     'CGD3016'     ZAMSID                                     MD054955
     C                   EXSR      ZASNMS                                                   MD054955
     C                   GOTO      SCEXIT                                                   MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      * Check for changed record
     C                   eval      @1DBRC = CGCSCH                                          MD054955
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSC        SETLL     @CSCHL0                            9091      *           MD054955
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before Data update
     C                   MOVEL     '*'           CPRECI                         Record Identifi
     C                   MOVEL     ##JOB         CPAJOB                         Job name
     C                   MOVEL     ##USR         CPAUSR                         User name
     C                   Z-ADD     ##JTM         CPATIM                         Action Time
     C                   MOVEL     WUMRDT        CPARDT                         Action Date
     C                   MOVEL     'D'           CPAACT                         Action Type
     C                   Z-ADD     WURDNB        CPRDNB                         Run day number
     C**********         UPDATE    @CSCHL0                              91      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGCSHXTD set                                                                 MD054955
     C+   CPRECI = :CPRECI                                                                  MD054955
     C+ , CPAJOB = :CPAJOB                                                                  MD054955
     C+ , CPAUSR = :CPAUSR                                                                  MD054955
     C+ , CPATIM = :CPATIM                                                                  MD054955
     C+ , CPARDT = :CPARDT                                                                  MD054955
     C+ , CPAACT = :CPAACT                                                                  MD054955
     C+ , CPRDNB = :CPRDNB                                                                  MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C******IN91*        IFEQ      '1'                                                      MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Corr. Schedules - Correspondent Schedule  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CSCHL0
     C                   MOVEL     #1CORR        CPCORR                         Correspondent
     C                   MOVEL     #1PTYP        CPPTYP                         Print Item Type
     C                   MOVEL     #1PSTP        CPPSTP                         Print Item Sub-
     C                   Z-ADD     #1SEQN        CPSEQN                         Sequence Number
      *
     C     KLCHSD        KLIST
     C                   KFLD                    CPCORR                         Correspondent
     C                   KFLD                    CPPTYP                         Print Item Type
     C                   KFLD                    CPPSTP                         Print Item Sub-
     C                   KFLD                    CPSEQN                         Sequence Number
     C*****KLCHSD        CHAIN     @CSCHL0                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       9091                  MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = CGCSCH                                          MD054955
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSD        SETLL     @CSCHL0                            9091      *           MD054955
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @CSCHL0
     C                   MOVEL     'D'           CPRECI                         Record Identifi
     C                   MOVEL     #1PSCH        CPPSCH                         Print Schedule
     C     #1PCOR        IFNE      #1CORR
     C     #1PCOR        ANDNE     *BLANKS
     C                   MOVEL     #1PCOR        CPPCOR                         Primary Corresp
     C                   ELSE
     C                   MOVEL     #1CORR        CPPCOR                         Primary Corresp
     C                   END
     C                   MOVEL     #1LGID        CPLGID                         Language identi
     C                   MOVEL     #1ACCD        CPACCD                         Account Code
     C                   Z-ADD     #1NPDT        CPNPDT                         Next Print Date
     C                   MOVEL     #1MACT        CPMACT                         Midas Account I
     C                   MOVEL     #1PLAB        CPPLAB                         Print Address L
     C                   Z-ADD     #1SFDY        CPSFDY                         Frequency Day N
     C                   Z-ADD     #1RETP        CPRETP                         Retention Perio
     C                   MOVEL     #1MSHC        CPMSHC                         Mail Shot code
     C                   MOVEL     #1APDF        CPAPDF                         Defaults must b
     C                   Z-ADD     #1OSQN        CPOSQN                         Output Sequence
     C                   Z-ADD     #1NPAG        CPNPAG                         Number of Pages
     C                   Z-ADD     #1TPAG        CPTPAG                         Total Number of
     C                   Z-ADD     #1RDTE        CPRDTE                         Reset Date
     C                   MOVEL     #1RFRQ        CPRFRQ                         Reset Frequency
     C                   Z-ADD     #1RSDN        CPRSDN                         Reset dayno.   08288
     C                   MOVEL     #1CCCY        CPCCCY                         Charge Currency
     C                   Z-ADD     #1CITM        CPCITM                         Charge per item
     C                   Z-ADD     #1BSNB        CPBSNB                         Charge Not Post
     C                   Z-ADD     #1CACC        CPCACC                         Charge Accumlat
     C                   MOVEL     #1CFRQ        CPCFRQ                         Post charge fre
     C                   Z-ADD     #1NTDT        CPNTDT                         Next Post Date
     C                   MOVEL     #1ACHG        CPACHG                         Apply Charge
     C                   MOVEL     #1CACT        CPCACT                         Charge Account
     C                   Z-ADD     #1PDAY        CPPDAY                         Post Charges da
     C                   MOVEL     ##JOB         CPAJOB                         Job name
     C                   MOVEL     ##USR         CPAUSR                         User name
     C                   Z-ADD     ##JTM         CPATIM                         Action Time
     C                   MOVEL     WUMRDT        CPARDT                         Action Date
     C                   MOVEL     'A'           CPAACT                         Action Type
     C                   Z-ADD     WURDNB        CPRDNB                         Run day number
      *
     C**********         UPDATE    @CSCHL0                              91      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGCSHXTD set                                                                 MD054955
     C+   CPRECI = :CPRECI                                                                  MD054955
     C+ , CPPSCH = :CPPSCH                                                                  MD054955
     C+ , CPPCOR = :CPPCOR                                                                  MD054955
     C+ , CPLGID = :CPLGID                                                                  MD054955
     C+ , CPNPDT = :CPNPDT                                                                  MD054955
     C+ , CPPLAB = :CPPLAB                                                                  MD054955
     C+ , CPSFDY = :CPSFDY                                                                  MD054955
     C+ , CPRETP = :CPRETP                                                                  MD054955
     C+ , CPMSHC = :CPMSHC                                                                  MD054955
     C+ , CPAPDF = :CPAPDF                                                                  MD054955
     C+ , CPOSQN = :CPOSQN                                                                  MD054955
     C+ , CPNPAG = :CPNPAG                                                                  MD054955
     C+ , CPTPAG = :CPTPAG                                                                  MD054955
     C+ , CPRDTE = :CPRDTE                                                                  MD054955
     C+ , CPRFRQ = :CPRFRQ                                                                  MD054955
     C+ , CPRSDN = :CPRSDN                                                                  MD054955
     C+ , CPCCCY = :CPCCCY                                                                  MD054955
     C+ , CPCITM = :CPCITM                                                                  MD054955
     C+ , CPBSNB = :CPBSNB                                                                  MD054955
     C+ , CPCACC = :CPCACC                                                                  MD054955
     C+ , CPCFRQ = :CPCFRQ                                                                  MD054955
     C+ , CPNTDT = :CPNTDT                                                                  MD054955
     C+ , CPACHG = :CPACHG                                                                  MD054955
     C+ , CPPDAY = :CPPDAY                                                                  MD054955
     C+ , CPAJOB = :CPAJOB                                                                  MD054955
     C+ , CPAUSR = :CPAUSR                                                                  MD054955
     C+ , CPATIM = :CPATIM                                                                  MD054955
     C+ , CPARDT = :CPARDT                                                                  MD054955
     C+ , CPAACT = :CPAACT                                                                  MD054955
     C+ , CPRDNB = :CPRDNB                                                                  MD054955
     C+ , CPACCD = :CPACCD                                                                  MD054955
     C+ , CPMACT = :CPMACT                                                                  MD054955
     C+ , CPCACT = :CPCACT                                                                  MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C******IN91*        IFEQ      '1'                                                      MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check reference to Print Item Type/Sub-Type
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1PTYP        IFEQ      *BLANK                                       Print Item Type
     C     #1PSTP        ANDEQ     *BLANK                                       Print Item Sub-
     C                   GOTO      VAEXIT
     C                   END
      *
      * Check for selection
      *
     C     ' ?'          CHECK     #1PTYP                                 90
     C     *IN90         IFEQ      '1'
     C     #1PSTP        ANDNE     *BLANKS
     C     ' ?'          CHECK     #1PSTP                                 90
     C                   END
     C     *IN90         IFEQ      '0'
     C     #1PTYP        ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       O6PARM
     C                   CALL      'CG1180'                             9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      'S'           O6ACTC            1            Action Code
     C                   PARM                    O6PARM                         B:RDE
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found
      *                                                                                       222860
     C     KLVAIT        KLIST
     C                   KFLD                    ITPTYP                         Print Item Type
     C                   KFLD                    ITPSTP                         Print Item Sub-
      *                                                                                       222860
     C                   MOVEL     O6PTYP        ITPTYP                         Print Item Type
     C                   MOVEL     O6PSTP        ITPSTP                         Print Item Sub-
      *                                                                                       222860
     C*****KLVAIT        CHAIN     @PTYPL1                            9091                  MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGPTYP                                                                        MD054955
     C+ from CGPTYJW0                                                                       MD054955
     C+ where ITPTYP = :ITPTYP and ITPSTP = :ITPSTP and ITRECI = 'D'                        MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C                   MOVEL     O6PTYP        #1PTYP
     C     *IN90         IFEQ      '0'
     C     ITGPHD        ANDNE     *BLANK
     C                   MOVE      *BLANKS       #1PSTP
     C                   ELSE
     C                   MOVEL     O6PSTP        #1PSTP
     C                   ENDIF
      *
      * Delay
      *
     C                   MOVEL     '1'           *IN99
     C                   GOTO      VAEXIT
     C                   END
      *
     C                   END
      *
     C********** KLVAIT    KLIST                                                              222860
     C**********           KFLD           ITPTYP           Print Item Type                    222860
     C**********           KFLD           ITPSTP           Print Item Sub-                    222860
      *
     C     KLVAI2        KLIST
     C                   KFLD                    ITPTYP                         Print Item Type
      * Setup key
     C                   MOVEL     #1PTYP        ITPTYP                         Print Item Type
     C                   MOVEL     #1PSTP        ITPSTP                         Print Item Sub-
     C*****KLVAIT        CHAIN     @PTYPL1                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGPTYP                                                                        MD054955
     C+ from CGPTYJW0                                                                       MD054955
     C+ where ITPTYP = :ITPTYP and ITPSTP = :ITPSTP and GARECI = 'D'                        MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN90         IFEQ      '1'
     C     #1PSTP        ANDEQ     *BLANKS                                                     08918
     C***********KLVAI2    CHAIN@PTYPL1              9091  *              089186
      *                                                                   089186
      * Set lower limits and read equal, at least one record expected     089186
      *                                                                   089186
     C*****KLVAI2        SETLL     @PTYPL1                                            08918 MD054955
     C*****KLVAI2        READE     @PTYPL1                                90          08918 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGPTYP                                                                        MD054955
     C+ from CGPTYJW0                                                                       MD054955
     C+ where ITPTYP = :ITPTYP  and GARECI = 'D'                                            MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C                   END
     C     *IN90         IFEQ      '0'
      *                                                                   CCG009
      **  If the Type/Sub-Type is part of a group,                        CCG009
      **  only the Type may be selected for printing                      CCG009
     C     ITGPHD        IFNE      *BLANK                                                      CCG00
     C     #1PSTP        ANDNE     *BLANKS                                                     CCG00
      *                                                                   CCG009
      * Send message 'Print Sub Type cannot be selected for printing'     CCG009
     C                   MOVEL     'CGD1529'     ZAMSID                                        CCG00
     C                   EXSR      ZASNMS                                                      CCG00
     C                   MOVEL     'CGD1529'     W0RTN                                         CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG009
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Send message 'Print Item Type/Sub-Ty NF'
     C                   MOVEL     'CGD1411'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1411'     W0RTN
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   VBCKRL        BEGSR
      *================================================================
      * Check reference to Print Schedule Types
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1PSCH        IFEQ      *BLANK                                       Print Schedule
     C                   GOTO      VBEXIT
     C                   END
      *
      * Check for selection
      *
     C     ' ?'          CHECK     #1PSCH                                 90
     C     *IN90         IFEQ      '0'
     C     #1PSCH        ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       O4PARM
     C                   CALL      'CG0160'                             9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      'S'           O4ACTC            1            Action Code
     C                   PARM                    O4PARM                         B:RDE
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found
     C                   MOVEL     O4PSCH        #1PSCH
      *
      * Delay
      *
     C                   MOVEL     '1'           *IN99
     C                   GOTO      VBEXIT
     C                   END
      *
     C                   END
      *
     C     KLVBST        KLIST
     C                   KFLD                    STPSCH                         Print Schedule
      * Setup key
     C                   MOVEL     #1PSCH        STPSCH                         Print Schedule
     C     KLVBST        CHAIN     @PSCHL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VBEXIT
     C                   END
      * Send message 'Print Schedule Types   NF'
     C                   MOVEL     'CGD1281'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1281'     W0RTN
      *================================================================
     CSR   VBEXIT        ENDSR
      /EJECT
     CSR   VCCKRL        BEGSR
      *================================================================
      * Check reference to Correspondent Details
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1PCOR        IFEQ      *BLANK                                       Correspondent
     C                   GOTO      VCEXIT
     C                   END
      *
      * Check for selection
      *
     C     ' ?'          CHECK     #1PCOR                                 90
     C     *IN90         IFEQ      '0'
     C     #1PCOR        ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       O7PARM
     C                   CALL      'CG0021'                             9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      'S'           O7ACTC            1            Action Code
     C                   PARM                    O7PARM                         B:RDE
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found
     C                   MOVEL     O7CORR        #1PCOR
      *
      * Delay
      *
     C                   MOVEL     '1'           *IN99
     C                   GOTO      VCEXIT
     C                   END
      *
     C                   END
      *
     C     KLVCCD        KLIST
     C                   KFLD                    CDCORR                         Correspondent
      * Setup key
     C                   MOVEL     #1PCOR        CDCORR                         Correspondent
     C     KLVCCD        CHAIN     @CORRL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VCEXIT
     C                   END
      * Send message 'Correspondent Details  NF'
     C                   MOVEL     'CGD1157'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1157'     W0RTN
      *================================================================
     CSR   VCEXIT        ENDSR
      /EJECT
     CSR   VDCKRL        BEGSR
      *================================================================
      * Check reference to Midas Languages codes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1LGID        IFEQ      *BLANK                                       Language identi
     C                   GOTO      VDEXIT
     C                   END
      * Setup key
     C                   MOVEL     #1LGID        P@LGID                         Language identi
      *
      *  Call to access pgm for Counterparty Nostro Details
      *
     C                   CALL      'AOLANGR0'                           9090
     C                   PARM      *BLANKS       P@RTCD                         B:Return code
     C                   PARM      '*KEY'        P@OPTN                         I:Option
     C                   PARM                    P@LGID            2            I:Key field
     C     SDLANG        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOLANGR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     SCUNT         #1LGID                         Language identi
     C                   GOTO      VDEXIT
     C                   END
      *
      * Send message 'Midas Languages co NF'
     C                   MOVEL     'CGD1280'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1280'     W0RTN
      *================================================================
     CSR   VDEXIT        ENDSR
      /EJECT
     CSR   VECKRL        BEGSR
      *================================================================
      * Check reference to Midas Account codes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1ACCD        IFEQ      *BLANK                                       Account Code
     C                   GOTO      VEEXIT
     C                   END
      *
      * Setup key
     C                   MOVEL     #1ACCD        P@ACCD                         Account Code
     C  N99'?'           SCAN      #1ACCD                                 99
      *
      *  Call to access pgm for Customer details
      *
     C                   CALL      'AOACODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C**********           PARM           P@ACCD  4                                           CGL029
     C                   PARM                    P@ACCD           10
     C     SDACOD        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACODR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      *
     C                   MOVEL     A5ACCD        #1ACCD                         Branch
      *
      * If account code entered then must be non-title
      *
     C     #1ACCD        IFNE      *BLANK                                       IF
     C     A5TOIN        ANDNE     'N'
     C                   MOVEL     '1'           @I1(32)
     C                   SETON                                        99        *
     C                   MOVEL     'CGD1389'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1389'     W0RTN
     C                   END                                                    FI
      * Record found - move back any virtuals
     C                   GOTO      VEEXIT
     C                   END
      *
      * Send message 'Midas Account code NF'
     C                   MOVEL     'CGD1358'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1358'     W0RTN
      *================================================================
     CSR   VEEXIT        ENDSR
      /EJECT
     CSR   VFCKRL        BEGSR
      *================================================================
      * Check restriction within
      *================================================================
      *
     C     KLVFCD        KLIST
     C                   KFLD                    CDCORR                         Correspondent
      * Setup key
     C                   MOVEL     #1CORR        CDCORR                         Correspondent
     C     KLVFCD        CHAIN     @CORRL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VFEXIT
     C                   END
      * Restrictor relation not satisfied
      * Send message 'Correspondent Details  NF'
     C                   MOVEL     'CGD1157'     ZAMSID
     C                   MOVEL     '*PRV '       ZAPGRL                         Rel queue
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1157'     P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   VFEXIT        ENDSR
      /EJECT
     CSR   VICKRL        BEGSR
      *================================================================
      * Check reference to Midas Account
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1MACT        IFEQ      *BLANK                                       Account Code
     C                   GOTO      VIEXIT
     C                   END
      *
      * Setup key
     C     6             SUBST     #1MACT:1      P@CNUM
     C     3             SUBST     #1MACT:7      P@CUCD
     C     10            SUBST     #1MACT:10     P@ACCD
     C     2             SUBST     #1MACT:20     P@ACSQ
     C     3             SUBST     #1MACT:22     P@BRCA
     C********** 4         SUBST#1MACT:10 P@ACCD                                              CGL029
     C********** 2         SUBST#1MACT:14 P@ACSQ                                              CGL029
     C********** 3         SUBST#1MACT:16 P@BRCA                                              CGL029
      *
      *  Call to access pgm for Accounts
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C**********           PARM           P@ACCD  4        I:Key field 3                      CGL029
     C                   PARM                    P@ACCD
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     3             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVE      *BLANKS       ##ACCT
     C                   MOVE      CNUM          WCNUM
     C                   MOVE      CCY           WCCY
     C                   MOVE      ACOD          WACOD
     C                   MOVE      ACSQ          WACSQ
     C     ##ACCT        CAT       BRCA          #1MACT
     C                   GOTO      VIEXIT
     C                   END
      * Send message 'Midas Account NF'
     C                   MOVEL     'CGD1363'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1363'     W0RTN
      *================================================================
     CSR   VIEXIT        ENDSR
      /EJECT
     CSR   VJCKRL        BEGSR
      *================================================================
      * Check reference to Charge Account
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANKS       ##CCY
      * If all low order keys not entered, exit
     C     #1CACT        IFEQ      *BLANK                                       Account Code
     C                   GOTO      VJEXIT
     C                   END
      *
      * Setup key
     C     6             SUBST     #1CACT:1      P@CNUM
     C     3             SUBST     #1CACT:7      P@CUCD
     C     10            SUBST     #1CACT:10     P@ACCD
     C     2             SUBST     #1CACT:20     P@ACSQ
     C     3             SUBST     #1CACT:22     P@BRCA
     C********** 4         SUBST#1CACT:10 P@ACCD                                              CGL029
     C********** 2         SUBST#1CACT:14 P@ACSQ                                              CGL029
     C********** 3         SUBST#1CACT:16 P@BRCA                                              CGL029
      *
      *  Call to access pgm for Accounts
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C**********           PARM           P@ACCD  4        I:Key field 3                      CGL029
     C                   PARM                    P@ACCD
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOACCTR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 04 *
     C                   Z-ADD     4             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVE      *BLANKS       ##ACCT
     C                   MOVE      CNUM          WCNUM
     C                   MOVE      CCY           WCCY
     C                   MOVE      ACOD          WACOD
     C                   MOVE      ACSQ          WACSQ
     C     ##ACCT        CAT       BRCA          #1CACT
     C     *LIKE         DEFINE    CCY           ##CCY
     C                   MOVEL     CCY           ##CCY
     C                   GOTO      VJEXIT
     C                   END
      * Send message 'Midas Account code NF'
     C                   MOVEL     'CGD1363'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1363'     W0RTN
      *================================================================
     CSR   VJEXIT        ENDSR
      /EJECT
     CSR   VKCKRL        BEGSR
      *================================================================
      * Check reference to Midas Currency Codes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1CCCY        IFEQ      *BLANK                                       Currency Code
     C                   GOTO      VKEXIT
     C                   END
      *
      * Setup key
     C  N99'?'           SCAN      #1CCCY                                 99
     C                   MOVEL     #1CCCY        P@CYCD                         Location
      *
      *  Call to access pgm for Currency details
      *
     C                   CALL      'AOCURRR0'                           9090    *1
     C                   PARM      *BLANKS       P@RTCD            7            *1
     C                   PARM      '*KEY   '     P@OPTN            7            *1
     C                   PARM                    P@CYCD            3            *1
     C     SDCURR        PARM      *BLANK        DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'AOCURRR0'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     P@RTCD        IFEQ      *BLANKS
      * Record found - move back any virtuals
     C                   MOVEL     A6CYCD        #1CCCY                         Location
     C                   GOTO      VKEXIT
     C                   END
      * Send message 'Midas Currency Cod NF'
     C                   MOVEL     'CGD1284'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1284'     W0RTN
      *================================================================
     CSR   VKEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
     C                   MOVEL     *BLANK        P0RTN
      *
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   END                                                    *FI
      * CASE: CTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   END                                                    *FI
      *
      * EDTRCD: Exit program - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,CG0280DEPP
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMTSK        ANDEQ     'N'
     C                   ROLBK                                          90
     C                   ELSE
     C                   SETON                                        U7U8
     C                   ENDIF
      *
      * Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'CGUSRMSG'    ZADFMF           10
      * Define work field Midas run date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Open files first time only
     C     W0OPN         IFEQ      *BLANK
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C**********         OPEN      CGCSCHL0                                                 MD054955
      * Signal that files are now open
     C                   MOVE      'Y'           W0OPN             1
     C                   END
     C                   MOVEL     'N'           W0PMT             1
      * Initialise error memories
     C                   MOVE      *ZERO         @@I1
     C                   MOVE      *ZERO         @@I2
     C                   MOVEL     *BLANKS       BBIN89
     C                   MOVEL     *BLANKS       CBIN89
      * Select initial mode
     C     @1NROP        IFEQ      *ZERO
      * Add mode
     C                   MOVEL     'ADD'         W0PMD             3
     C                   ELSE
      * Change mode
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Retrieve Midas Date - R10 Standard Functions  *
     C*
     C*  Set up copyright parameter
     C*
     C                   MOVEA     CPY@          ACT@             80
     C**********         CLEAR                   @CSCHL0                                    MD054955
     C                   CLEAR                   CGCSCH                                     MD054955
     C*
     C* Get Rundate - Rundate  *
     C*
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCMTSK            1
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CSC022'      P@SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSC022
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
     C                   MOVE      'N'           WCMTSK
      *                                                                                       CSC022
     C                   IN        WDSJOB
      *                                                                                       CSC022
     C     WCMTNO        IFGT      0
     C                   MOVEA     WCJOBS        WCMT
     C                   Z-ADD     1             I                 2 0
      *                                                                                       CSC022
     C     ##JOB         LOOKUP    WCMT(I)                                50
     C     *IN50         IFEQ      *ON
     C                   MOVE      'Y'           WCMTSK
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSC022
     C                   ELSE
     C     P@RTCD        IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     8             W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CSC022
     C                   ENDIF
      *                                                                                       CSC022
     C     *LIKE         DEFINE    SARN          P@SARD
     C************NAMVAR   DEFN           WDSJOB                                       CSC022BUG2330
     C     *DTAARA       DEFINE    SCCMTJOB      WDSJOB
      *                                                                                       CSC022
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     6             W0ERNB                         * DB ERROR 06 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      * EDTRCD: Initialise prog - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,CG0280DCPG
      *================================================================
     CSR   ZZEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRWIND   : Control Window Processing                         *
      *                                                               *
      *================================================================
     CSR   SRWIND        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRWIND'      @STK(Q)
      *
      * If window processing call WN0010
      *
     C     BGWDPR        IFEQ      'Y'
      *
      *    /copy to move data into the data structure fields passed
      *     as a parameter to the window controller
      *
      /COPY WNCPYSRC,CG0280MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,CG0280MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,CG0280MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,CG0280MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,CG0280MOV5
     C                   ENDSL
      *
     C                   CALL      'WN0010'                             9190
     C                   PARM      ##PGM         O#PGM            10
     C                   PARM      *BLANKS       O#CMD             2
     C                   PARM      P1ACTC        O#ACTN            1
     C                   PARM                    DATA
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM                    EXTRA           256
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'WN0010'      W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     7             W0ERNB                         * DB ERROR 07 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *   /copy to move data back from the data structure fields passed
      *    as a parameter to the window controller and control user
      *    defined processing.
      *
      /COPY WNCPYSRC,CG0280MOV6
      *
     C     *LIKE         DEFINE    O#RTN         R#RTN
     C     R#RTN         CABEQ     *BLANKS       EXWIND
      *
      *  Check return code and send message on action
      *  - set no update as some action has been specified.
      *
     C                   MOVEL     'Y'           W0DCF
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMTSK        ANDEQ     'N'
     C                   ROLBK
     C                   ELSE
     C                   SETON                                        U7U8
     C                   ENDIF
      *
     C                   SELECT
      *
      * *Return code is *User QUIT requested
      *
     C     R#RTN         WHENEQ    'Y2U9999'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   MOVEL     'Y2U9999'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   EXSR      ZYEXPG
      *
      * *Return code is WN Window Error
      *
     C     R#RTN         WHENEQ    'USR0563'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
      * *Return code is *DBF update error
      *
     C     R#RTN         WHENEQ    'USR0567'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
     C***Return*code*is**Previous*Screen******************************    115722
     C*                                                                   115722
     C***********R#RTN*****WHEQ 'USR0790'                                 115722
     C*********************MOVEL'CGD1001' ZAMSID                          115722
     C*********************EXSR ZASNMS                                    115722
     C                   ENDSL
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXWIND        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
     C*
     C* File and Program Error Processing
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     O*EDTRCD: Cpysrc Templates Initialise Program O-spec
     O/COPY WNCPYSRC,CG0280DOPG
**  CPY@
(c) Finastra International Limited 2001
