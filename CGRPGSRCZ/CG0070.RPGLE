     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Edit Corr. Assoc. Edit record(1 screen)')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG0070 - Edit Corr. Association    Edit record(1 screen)     *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSD053             Date 01Jun06               *
      *                 BUG2330            Date 29Apr04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 115722             Date 12Feb98               *
      *                 088587             Date 02Jun95               *
     F*                 082944             DATE 08FEB95               *
     F*                 S01522             DATE 21NOV94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD to readable  *
      *             unicode equivalent.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *           (Recompile)                                         *
     F*  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
     F*  115722 - Comment out references to CGUSRMSG/CGD1001          *
     F*  088587 - Extra check for duplicate                           *
     F*  082944 - Add Structure Type validation                       *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*EDTRCD: Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,CG0070DFPG
     FCG0070DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Edit Corr. Association    Edit record(1 screen)
      *
     FCGCASCL1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : Correspondent Association Retrieval index
      *
     FCGCORRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Correspondent Details     Retrieval index
      *
     FCGCASCL0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(SRFILE)
      * UPD : Correspondent Association Update index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
     D*
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)                                            CSC022
      *                                                                                       CSC022
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,CG0070DEPG
     D*COPY*CGCPYSRC,SRERRI                                                                 MD056543
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,CG0070DIPG
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
     D @1DBRC        E DS                  EXTNAME(CGCASCL0)
      * UPD : Correspondent Association Update index
      * Current/previous master file format fields for change control
      *
     D #1DBRC          DS            86
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     S01194
     D*                                                                                       S01194
     D* Data Structures used by Access Programs                                               S01194
     D*                                                                                       S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     S01194
     D*                                                                                       S01194
     D* Data Structures used by Access Programs                                               S01194
     D*                                                                                       S01194
      *                                                                                       CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      * Switchable Features Details accessed via Access Program                               CSC022
      *                                                                                       CSC022
     D WDSJOB        E DS                  EXTNAME(SCCMTJOB)                                  CSC022
     D  WCMTNO       E                     EXTFLD(COMITNUM)                                   CSC022
     D  WJOB01       E                     EXTFLD(COMITJOB1)                                  CSC022
     D  WJOB02       E                     EXTFLD(COMITJOB2)                                  CSC022
     D  WJOB03       E                     EXTFLD(COMITJOB3)                                  CSC022
     D  WJOB04       E                     EXTFLD(COMITJOB4)                                  CSC022
     D  WJOB05       E                     EXTFLD(COMITJOB5)                                  CSC022
     D  WJOB06       E                     EXTFLD(COMITJOB6)                                  CSC022
     D  WJOB07       E                     EXTFLD(COMITJOB7)                                  CSC022
     D  WJOB08       E                     EXTFLD(COMITJOB8)                                  CSC022
     D  WJOB09       E                     EXTFLD(COMITJOB9)                                  CSC022
     D  WJOB10       E                     EXTFLD(COMITJOB10)                                 CSC022
     D  WCJOBS                 4    103                                                       CSC022
      ** Commitment Control dataarea                                                          CSC022
      *                                                                                       CSC022
     D*COPY*CGCPYSRC,CGCOV                                                           082944 MD056543
     D/COPY CGCPYSRC,CGCOVLE                                                                MD056543
     D*                                                                                       082944
     D* Plist DS for CG0011                                                                   082944
     D*                                                                                       082944
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS            20
      * KEY: Correspondent Association Retrieval index
      * I : RST From Correspondent
     D  P2FCOR                 1     10
      * I : MAP To Correspondent
     D  P2TCOR                11     20
     D O3PARM          DS            10
      * KEY: Correspondent Details     Retrieval index
      * I : MAP Correspondent
     D  O3TCOR                 1     10
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
      /EJECT
      *
      * Data to be passed to window processing
      *
     I/COPY QWINDSRC,CG0070WDTA
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Correspond
      *                                                                                       082944
      * CG0011 Plist                                                                          082944
      *                                                                                       082944
     C     PL0011        PLIST                                                                082944
     C                   PARM      *BLANKS       P@RTN             7                          082944
     C                   PARM                    CGCOV                                        082944
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
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1FCOR        IFEQ      *BLANK                                       From Correspond
     C     #1TCOR        OREQ      *BLANK                                       To Corresponden
      * One or more key fields is blank
     C                   MOVEL     'N'           W0BYP
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
      * Update screen time
     C                   TIME                    ##TME
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
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
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
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
     C                   KFLD                    CAFCOR                         From Correspond
     C                   KFLD                    CATCOR                         To Corresponden
      * Setup key
     C                   MOVEL     #1FCOR        CAFCOR                         From Correspond
     C                   MOVEL     #1TCOR        CATCOR                         To Corresponden
     C     KRTV          CHAIN     @CASCL1                            9091      *
      *
      * Send message 'Record Exists'
      *
     C     *IN90         IFEQ      '0'
     C     P1ACTC        ANDEQ     'I'
     C                   MOVEL     'CGD1156'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialize detail screen (new record)
      * EDTRCD: Init. det. scr NW - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl New Rcd
     C/COPY WNCPYSRC,CG0070DISN
     C                   ELSE
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG0070DSFF
      * USER: Initialize detail screen (existing record)
      * EDTRCD: Init. det. scr EX - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,CG0070DISE
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
      * Check reference to Correspondent Details
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9931      *
     C                   END
      * USER: Validate key screen
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Key Screen
     C/COPY WNCPYSRC,CG0070DVKS
      * To must not equal from
     C     #1TCOR        IFEQ      #1FCOR                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1410'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * To Correspondent required
     C     #1TCOR        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1409'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * If no trivial errors for insertion                                                    082944
     C     *IN99         IFEQ      *OFF                                                       082944
     C     P1ACTC        ANDEQ     'I'                                                        082944
      * Correspondent external validation                                                     082944
     C                   CLEAR                   CGCOV                                        082944
     C                   MOVE      #1FCOR        W0COR1                                       082944
     C                   MOVE      #1TCOR        W0COR2                                       082944
     C                   MOVE      'A'           W0FIL                                        082944
     C                   MOVE      'I'           W0ACTP                                       082944
     C                   MOVE      ##PGM         W0PGM                                        082944
      *                                                                                       082944
     C                   CALL      'CG0011'      PL0011                 9090                  082944
      *                                                                                       082944
     C     *IN90         IFEQ      '1'                                                        082944
     C                   MOVEL     'CG0011'      W0FILE                                       082944
     C                   MOVEL     '*CALL'       W0KEY                          **************082944
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 05 082944
     C                   MOVEL     'MEM5003'     W0MSGD                         **************082944
     C                   MOVEL     'MIDAS  '     W0MSGF                                       082944
     C                   EXSR      SRERR                                                      082944
     C                   END                                                                  082944
      *                                                                                       082944
     C     P@RTN         IFNE      *BLANKS                                                    082944
     C                   SETON                                        9931                    082944
     C                   END                                                                  082944
      *                                                                                       082944
     C                   END                                                                  082944
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
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * Update screen time
     C                   TIME                    ##TME
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
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
     C/COPY WNCPYSRC,CG0070DPKR
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
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details
     C     P1ACTC        IFEQ      'I'
     C     P1ACTC        OREQ      'A'
     C  N10              CAS                     DCVLDL
     C                   END
     C                   END
      *
      *  Call window processing
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRWIND
     C                   END
      * QUIT if error:
     C   99              GOTO      CFEXIT
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
      * EDTRCD: Valid det. scrn - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Detail Screen
     C/COPY WNCPYSRC,CG0070DVSF
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG0070DSFF
      * USER: Validate detail screen relations
      * EDTRCD: Detail scrn rels - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Screen Relns
     C/COPY WNCPYSRC,CG0070DVSR
      *================================================================
     CSR   DCEXIT        ENDSR
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
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'                                                        CSC022
     C     WCMTSK        ANDEQ     'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'                                                        CSC022
     C     WCMTSK        ANDEQ     'N'                                                        CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * EDTRCD: Process cmds - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Command Keys
     C/COPY WNCPYSRC,CG0070DPCK
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
      * Create Corr. Association - Correspondent Association  *
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
      * Delete Corr. Association - Correspondent Association  *
     C                   EXSR      SBCHRC
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
      * Change Corr. Association - Correspondent Association  *
     C                   EXSR      SCCHRC
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
     C     P2FCOR        IFEQ      *BLANK                                       From Correspond
     C     P2TCOR        OREQ      *BLANK                                       To Corresponden
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
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'E'                                          *IF
     C     P1ACTC        OREQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
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
     C                   MOVEL     *BLANK        #1AJOB                         Job name
     C                   MOVEL     *BLANK        #1AACT                         Action Type
     C                   Z-ADD     *ZERO         #1RDNB                         Run day number
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     *BLANK        #1DESC                         Description
     C                   MOVEL     *BLANK        #1AUSR                         User name
     C                   Z-ADD     *ZERO         #1ATIM                         Action Time
     C                   MOVEL     *BLANK        #1ARDT                         Action Date
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
     C                   PARM      'CGD1161'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
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
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1162'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
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
     C                   MOVEL     #MSTX1        ##CMD2
      *
      *
      * Amendment screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1163'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
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
     C                   MOVEL     #MSTX1        ##CMD2
      *
      *
      * Delete screen
      *
     C     P1ACTC        WHENEQ    'D'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1164'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
      *
      * Function keys and allow delete key
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1025'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     '1'           *IN77
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
     C                   ENDSL
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @CASCL1 fields to screen
      *================================================================
     C                   MOVEL     CARECI        #1RECI                         Record Identifi
     C                   MOVEL     CAAJOB        #1AJOB                         Job name
     C                   MOVEL     CAAACT        #1AACT                         Action Type
     C                   Z-ADD     CARDNB        #1RDNB                         Run day number
     C                   MOVEL     CAFCOR        #1FCOR                         From Correspond
     C                   MOVEL     CATCOR        #1TCOR                         To Corresponden
     C                   MOVEL     CADESC        #1DESC                         Description
     C                   MOVEL     CAAUSR        #1AUSR                         User name
     C                   Z-ADD     CAATIM        #1ATIM                         Action Time
     C                   MOVEL     CAARDT        #1ARDT                         Action Date
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *
      * Delete screen
      *
     C     P1ACTC        IFEQ      'D'
     C                   MOVEL     '1'           *IN77
     C                   END
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     P2FCOR        #1FCOR                         From Correspond
     C                   MOVEL     P2TCOR        #1TCOR                         To Corresponden
      * Check restriction within
     C                   EXSR      VBCKRL
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1161'     #MSGID
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
     C/COPY WNCPYSRC,CG0070DIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Corr. Association - Correspondent Association  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @CASCL0
     C                   MOVEL     #1FCOR        CAFCOR                         From Correspond
     C                   MOVEL     #1TCOR        CATCOR                         To Corresponden
     C                   MOVEL     'D'           CARECI                         Record Identifi
     C                   MOVEL     #1DESC        CADESC                         Description
     C                   MOVEL     ##JOB         CAAJOB                         Job name
     C                   MOVEL     ##USR         CAAUSR                         User name
     C                   Z-ADD     ##JTM         CAATIM                         Action Time
     C                   MOVEL     WUMRDT        CAARDT                         Action Date
     C                   MOVEL     'I'           CAAACT                         Action Type
     C                   Z-ADD     WURDNB        CARDNB                         Run day number
      *
     C     KLCRSA        KLIST
     C                   KFLD                    CAFCOR                         From Correspond
     C                   KFLD                    CATCOR                         To Corresponden
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @CASCL0                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1156'     W0RTN             7
      **Send*message 'Correspondent Associat EX'                                              082944
     C***********          MOVEL'CGD1156' ZAMSID                                              082944
     C***********          EXSR ZASNMS                                                        082944
      * USER: Processing if Data record already exists                                        082944
      * Change Correspondent Type - Correspondent Type  *                                     082944
     C                   EXSR      SDCHRC                                                     082944
     C                   GOTO      SAEXIT
     C                   END
      *
     C                   WRITE     @CASCL0                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Delete Corr. Association - Correspondent Association  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CASCL0
     C                   MOVEL     #1FCOR        CAFCOR                         From Correspond
     C                   MOVEL     #1TCOR        CATCOR                         To Corresponden
      *
     C     KLCHSB        KLIST
     C                   KFLD                    CAFCOR                         From Correspond
     C                   KFLD                    CATCOR                         To Corresponden
     C     KLCHSB        CHAIN     @CASCL0                            9091      *
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
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSB        SETLL     @CASCL0                            9091      *
     C                   GOTO      SBEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before Data update
     C                   MOVEL     '*'           CARECI                         Record Identifi
     C                   MOVEL     ##JOB         CAAJOB                         Job name
     C                   MOVEL     ##USR         CAAUSR                         User name
     C                   Z-ADD     ##JTM         CAATIM                         Action Time
     C                   MOVEL     WUMRDT        CAARDT                         Action Date
     C                   MOVEL     'D'           CAAACT                         Action Type
     C                   Z-ADD     WURDNB        CARDNB                         Run day number
     C                   UPDATE    @CASCL0                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Change Corr. Association - Correspondent Association  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CASCL0
     C                   MOVEL     #1FCOR        CAFCOR                         From Correspond
     C                   MOVEL     #1TCOR        CATCOR                         To Corresponden
      *
     C     KLCHSC        KLIST
     C                   KFLD                    CAFCOR                         From Correspond
     C                   KFLD                    CATCOR                         To Corresponden
     C     KLCHSC        CHAIN     @CASCL0                            9091      *
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
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSC        SETLL     @CASCL0                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @CASCL0
     C                   MOVEL     'D'           CARECI                         Record Identifi
     C                   MOVEL     #1DESC        CADESC                         Description
     C                   MOVEL     ##JOB         CAAJOB                         Job name
     C                   MOVEL     ##USR         CAAUSR                         User name
     C                   Z-ADD     ##JTM         CAATIM                         Action Time
     C                   MOVEL     WUMRDT        CAARDT                         Action Date
     C                   MOVEL     'A'           CAAACT                         Action Type
     C                   Z-ADD     WURDNB        CARDNB                         Run day number
      *
     C                   UPDATE    @CASCL0                              91      *
     C     *IN91         IFEQ      '1'
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
     CSR   SDCHRC        BEGSR                                                                082944
      *================================================================                       082944
      * Write  Corr. Association - Correspondent Association  *                               082944
      *================================================================                       082944
     C                   MOVEL     *BLANK        W0RTN             7                          082944
      * Move key fields to @CASCL0                                                            082944
     C                   MOVEL     #1FCOR        CAFCOR                         From Correspo 082944
     C                   MOVEL     #1TCOR        CATCOR                         To Correspond 082944
      *                                                                                       082944
     C     KLCHSC        CHAIN     @CASCL0                            9091      *             082944
      *                                                                                       082944
     C     *IN90         IFEQ      '1'                                                        082944
      * Record not found                                                                      082944
     C                   MOVEL     'Y2U0009'     W0RTN             7                          082944
      * Send message '*Record no longer on file'                                              082944
     C                   MOVEL     'Y2U0009'     ZAMSID                                       082944
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                       082944
     C                   EXSR      ZASNMS                                                     082944
     C                   GOTO      SDEXIT                                                     082944
     C                   END                                                                  082944
      *                                                                                       082944
     C     *IN91         IFEQ      '1'                                                        082944
      * Record locked                                                                         082944
     C                   MOVEL     'Y2U0004'     W0RTN             7                          082944
     C                   GOTO      SDEXIT                                                     082944
     C                   END                                                                  082944
      *                                                                                       082944
      **Check*for changed record                                                       082944 088587
     C***********#1DBRC    IFNE @1DBRC                     IF                          082944 088587
     C***********          MOVEL'Y2U0007' W0RTN   7                                    082944 088587
      **Send*message '*Update not accepted'                                            082944 088587
     C***********          MOVEL'Y2U0007' ZAMSID                                       082944 088587
     C***********          MOVEL'Y2USRMSG'ZAMSGF                                       082944 088587
     C***********          EXSR ZASNMS                                                 082944 088587
      **Use*SETLL to release record lock                                               082944 088587
     C***********KLCHSC    SETLL@CASCL0              9091  *                           082944 088587
     C***********          GOTO SDEXIT                                                 082944 088587
     C***********          END                             FI #1DBRC                   082944 088587
      * Move non-key fields to @CASCL0                                                        082944
     C                   MOVEL     'D'           CARECI                         Record Identi 082944
     C                   MOVEL     #1DESC        CADESC                         Description   082944
     C                   MOVEL     ##JOB         CAAJOB                         Job name      082944
     C                   MOVEL     ##USR         CAAUSR                         User name     082944
     C                   Z-ADD     ##JTM         CAATIM                         Action Time   082944
     C                   MOVEL     WUMRDT        CAARDT                         Action Date   082944
     C                   MOVEL     'I'           CAAACT                         Action Type   082944
     C                   Z-ADD     WURDNB        CARDNB                         Run day numbe 082944
      *                                                                                       082944
     C                   UPDATE    @CASCL0                              91      *             082944
     C     *IN91         IFEQ      '1'                                                        082944
      * Change error detected                                                                 082944
     C                   MOVEL     'Y2U0004'     W0RTN             7                          082944
     C                   ELSE                                                                 082944
      *                                                                                       082944
      * Update saved record image                                                             082944
     C                   MOVEL     @1DBRC        #1DBRC                                       082944
      * DBF change successful                                                                 082944
     C                   END                                                                  082944
      *================================================================                       082944
     CSR   SDEXIT        ENDSR                                                                082944
      /EJECT                                                                                  082944
     CSR   VACKRL        BEGSR
      *================================================================
      * Check reference to Correspondent Details
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1TCOR        IFEQ      *BLANK                                       Correspondent
     C                   GOTO      VAEXIT
     C                   END
      *
      * Check for selection
      *
     C     ' ?'          CHECK     #1TCOR                                 90
     C     *IN90         IFEQ      '0'
     C     #1TCOR        ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       O3PARM
     C                   CALL      'CG0021'                             9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      'S'           O3ACTC            1            Action Code
     C                   PARM                    O3PARM                         B:RDE
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found
     C                   MOVEL     O3TCOR        #1TCOR
      *
      * Delay
      *
     C                   MOVEL     '1'           *IN99
     C                   GOTO      VAEXIT
     C                   END
      *
     C                   END
      *
     C     KLVACD        KLIST
     C                   KFLD                    CDCORR                         Correspondent
      * Setup key
     C                   MOVEL     #1TCOR        CDCORR                         Correspondent
     C     KLVACD        CHAIN     @CORRL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Send message 'Correspondent Details  NF'
     C                   MOVEL     'CGD1157'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1157'     W0RTN
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   VBCKRL        BEGSR
      *================================================================
      * Check restriction within
      *================================================================
      *
     C     KLVBCD        KLIST
     C                   KFLD                    CDCORR                         Correspondent
      * Setup key
     C                   MOVEL     #1FCOR        CDCORR                         Correspondent
     C     KLVBCD        CHAIN     @CORRL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VBEXIT
     C                   END
      * Restrictor relation not satisfied
      * Send message 'Correspondent Details  NF'
     C                   MOVEL     'CGD1157'     ZAMSID
     C                   MOVEL     '*PRV '       ZAPGRL                         Rel queue
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1157'     P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   VBEXIT        ENDSR
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
      * USER: Exit program processing
      * EDTRCD: Exit program - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,CG0070DEPP
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'                                                        CSC022
     C     WCMTSK        ANDEQ     'N'                                                        CSC022
     C                   ROLBK                                          90
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
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
     C                   MOVEL     '0'           *IN77
     C                   MOVEL     *BLANKS       BBIN89
     C                   MOVEL     *BLANKS       CBIN89
     C     W0OPN         IFEQ      *BLANK
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C                   OPEN      CGCASCL0
      * Signal that files are now open
     C                   MOVE      'Y'           W0OPN             1
     C                   END
     C                   MOVEL     'N'           W0PMT             1
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
     C                   MOVE      'N'           CSC022            1                          CSC022
     C                   MOVE      'N'           WCMTSK            1                          CSC022
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       P@RTCD                                       CSC022
     C                   PARM      '*VERIFY'     P@OPTN                                       CSC022
     C                   PARM      'CSC022'      P@SARD                                       CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C     P@RTCD        IFEQ      *BLANKS                                                    CSC022
     C                   MOVE      'Y'           CSC022                                       CSC022
     C                   MOVE      'N'           WCMTSK                                       CSC022
      *                                                                                       CSC022
     C                   IN        WDSJOB                                                     CSC022
      *                                                                                       CSC022
     C     WCMTNO        IFGT      0                                                          CSC022
     C                   MOVEA     WCJOBS        WCMT                                         CSC022
     C                   Z-ADD     1             I                 2 0                        CSC022
      *                                                                                       CSC022
     C     ##JOB         LOOKUP    WCMT(I)                                50                  CSC022
     C     *IN50         IFEQ      *ON                                                        CSC022
     C                   MOVE      'Y'           WCMTSK                                       CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C                   ELSE                                                                 CSC022
     C     P@RTCD        IFNE      '*NRF'                                                     CSC022
     C                   MOVEL     'CSC022'      W0KEY                                        CSC022
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CSC022
     C                   Z-ADD     3             W0ERNB                                       CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSC022
     C     *LIKE         DEFINE    SARN          P@SARD                                       CSC022
     C************NAMVAR   DEFN           WDSJOB                                      CSC022 BUG2330
     C     *DTAARA       DEFINE    SCCMTJOB      WDSJOB                                      BUG2330
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
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      * EDTRCD: Initialise prog - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,CG0070DCPG
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
      /COPY WNCPYSRC,CG0070MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,CG0070MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,CG0070MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,CG0070MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,CG0070MOV5
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
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *   /copy to move data back from the data structure fields passed
      *    as a parameter to the window controller and control user
      *    defined processing.
      *
      /COPY WNCPYSRC,CG0070MOV6
      *
     C     *LIKE         DEFINE    O#RTN         R#RTN
     C     R#RTN         CABEQ     *BLANKS       EXWIND
      *
      *  Check return code and send message on action
      *  - set no update as some action has been specified.
      *
     C                   MOVEL     'Y'           W0DCF
     C     CSC022        IFEQ      'N'                                                        CSC022
     C     CSC022        OREQ      'Y'                                                        CSC022
     C     WCMTSK        ANDEQ     'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
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
     C***Return*code*is**Previous*Screen*******************************                       115722
     C*                                                                                       115722
     C***********R#RTN*****WHEQ 'USR0790'                                                     115722
     C*********************MOVEL'CGD1001' ZAMSID                                              115722
     C*********************EXSR ZASNMS                                                        115722
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
     C**
     C**PSSR Processing
     C**
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
     C*
     C* File and Program Error Processing
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
     O*EDTRCD: Cpysrc Templates Initialise Program O-spec
     O/COPY WNCPYSRC,CG0070DOPG
**  CPY@
(c) Finastra International Limited 2001
