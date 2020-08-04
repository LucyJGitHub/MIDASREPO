     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Edit RDE        Edit record(1 screen)')
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG1000 - Edit RDE                  Edit record(1 screen)     *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG2330            Date 29Apr04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 115722             Date 12Feb98               *
      *                 118741             Date 02Jun97               *
     F*                 082911             DATE 07FEB95               *
     F*                 S01522             DATE 22NOV94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
     F*  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
     F*  115722 - Comment out references to CGUSRMSG/CGD1001          *
     F*  118741 - Allow 'Derived Info' to default to 'N' if blank.    *
     F*  082911 - Force leading space for numeric RDEs                *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*EDTRCD: Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,CG1000DFPG
     FCG1000DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Edit RDE                  Edit record(1 screen)
      *
     F*CGRDTAL1* IF   E           K DISK                                                    MD054955
     F**********                           INFDS(INFDS1)                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * RTV : Report Data Elements      Retrieval index
      *
     FCGFGRPL1  IF   E           K DISK    INFSR(SRFILE)
      * RTV : Format Group              Retrieval index
      *
     F*CGRDTAL0* UF A E           K DISK    USROPN                                          MD054955
     F**********                           COMMIT                                           MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * UPD : Report Data Elements      Update index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,CG1000DEPG
     D CGRDTA        E DS                  EXTNAME(CGRDTJW0)                                MD054955
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,CG1000DIPG
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
     D*@1DBRC***     E DS                  EXTNAME(CGRDTAL0)                                MD054955
     D @1DBRC        E DS                  EXTNAME(CGRDTJW0)                                MD054955
     D                                     PREFIX(X)                                        MD054955
      * UPD : Report Data Elements      Update index
      * Current/previous master file format fields for change control
      *
     D*#1DBRC***       DS           147                                                     MD054955
     D #1DBRC          DS           148                                                     MD054955
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
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS            10
      * KEY: Report Data Elements      Retrieval index
      * I : MAP Report Data Element
     D  P2RDE                  1     10
     D O2PARM          DS            10
      * KEY: Format Group              Retrieval index
      * I : MAP Formatting Options
     D  O2FOPT                 1     10
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
     I/COPY QWINDSRC,CG1000WDTA
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Report Dat
      *
     C     *LIKE         DEFINE    #1ETXT        @1ETXT          + 1                           08291
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
     C     #1RDE         IFEQ      *BLANK                                       Report Data Ele
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
     C                   KFLD                    RDRDE                          Report Data Ele
      * Setup key
     C                   MOVEL     #1RDE         RDRDE                          Report Data Ele
     C*****KRTV*         CHAIN     @RDTAL1                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDTA                                                                        MD054955
     C+ from CGRDTJW0                                                                       MD054955
     C+ where RDRDE = :RDRDE and RDRECI = 'D'                                               MD054955
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
      * Send message 'Record Exists'
      *
     C     *IN90         IFEQ      '0'
     C     P1ACTC        ANDEQ     'I'
     C                   MOVEL     'CGD1125'     ZAMSID
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
     C/COPY WNCPYSRC,CG1000DISN
     C                   ELSE
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG1000DSFF
      * USER: Initialize detail screen (existing record)
      * EDTRCD: Init. det. scr EX - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,CG1000DISE
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
      * USER: Validate key screen
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Key Screen
     C/COPY WNCPYSRC,CG1000DVKS
      * Report Data Element required
     C     #1RDE         IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1428'     ZAMSID
     C                   EXSR      ZASNMS
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
     C/COPY WNCPYSRC,CG1000DPKR
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
      *  Check referential integrity if delete
      *
     C     P1ACTC        IFEQ      'D'
     C                   EXSR      SRREFI
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
     C/COPY WNCPYSRC,CG1000DVSF
      * CASE: DTL.Element Type is Blank
      * Check relations
      * Check reference to Format Group
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9934      *
     C                   END
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG1000DSFF
      * USER: Validate detail screen relations
      * EDTRCD: Detail scrn rels - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Screen Relns
     C/COPY WNCPYSRC,CG1000DVSR
      *
      * Validate Element Type
      *
     C                   EXSR      SRELYP
      *
      * Validate Maximum Length
      *
     C                   EXSR      SRMAXL
      *
      * Validate Description
      *
     C                   EXSR      SRDESC
      *
      * Validate Formatting Option
      *
     C                   EXSR      SRFOPT
      *
      * Validate Example Data
      *
     C                   EXSR      SRETXT
      *
      * Validate Allow Derived Information
      *
     C                   EXSR      SRDRVD
      *
      * Validate Start position
      *
     C                   EXSR      SRSPOS
      *
      * Validate End position
      *
     C                   EXSR      SREPOS
      *
      *  Cross validations
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRXVAL
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRREFI   : Referential Integrity Check                       *
      *                                                               *
      *================================================================
     CSR   SRREFI        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRREFI'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG1000REFI
      *
      *  Call referential integrity check process
      *
     C                   CALL      'CG0240'                             9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      #1RDE         P@RDE            10
     C                   PARM      ##PGM         P@CPGM           10
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'CG0240'      W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  If return code non-blank send message
      *
     C     P@RTCD        IFNE      *BLANK                                       IF
     C                   SETON                                        99        *
      * Send message '*Value required'
     C                   MOVEL     P@RTCD        ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EXREFI
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXREFI        TAG
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
     C/COPY WNCPYSRC,CG1000DPCK
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
      * Create RDE - Report Data Elements  *
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
      * Delete RDE - Report Data Elements  *
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
      * Change RDE - Report Data Elements  *
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
     C     P2RDE         IFEQ      *BLANK                                       Report Data Ele
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
     C                   MOVEL     *BLANK        #1ELYP                         Element Type
     C                   Z-ADD     *ZERO         #1MAXL                         Maximum Length
     C                   MOVEL     *BLANK        #1DESC                         Description
     C                   MOVEL     *BLANK        #1FOPT                         Formatting Opti
     C                   MOVEL     *BLANK        #1ETXT                         Example Data
     C                   MOVEL     *BLANK        #1DRVD                         Allow Derived I
     C                   MOVEL     *BLANK        #1DSRC                         Derived Informa
     C                   Z-ADD     *ZERO         #1SPOS                         Start Position
     C                   MOVEL     *BLANK        #1DINT                         Derived Data in
     C                   Z-ADD     *ZERO         #1EPOS                         End Position
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
     C                   PARM      'CGD1020'     #MSGID
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
     C                   PARM      'CGD1022'     #MSGID
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
     C                   PARM      'CGD1023'     #MSGID
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
     C                   PARM      'CGD1024'     #MSGID
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
      * Move @RDTAL1 fields to screen
      *================================================================
     C                   MOVEL     RDRECI        #1RECI                         Record Identifi
     C                   MOVEL     RDAJOB        #1AJOB                         Job name
     C                   MOVEL     RDAACT        #1AACT                         Action Type
     C                   Z-ADD     RDRDNB        #1RDNB                         Run day number
     C                   MOVEL     RDRDE         #1RDE                          Report Data Ele
     C                   MOVEL     RDELYP        #1ELYP                         Element Type
     C                   Z-ADD     RDMAXL        #1MAXL                         Maximum Length
     C                   MOVEL     RDDESC        #1DESC                         Description
     C                   MOVEL     RDFOPT        #1FOPT                         Formatting Opti
      *                                                                   082911
     C     RDELYP        IFEQ      '*DEC  '                                                    08291
     C                   SUBST(P)  RDETXT:2      #1ETXT                                        08291
     C                   ELSE                                                                  08291
     C                   MOVEL     RDETXT        #1ETXT                         Example Data
     C                   END                                                                   08291
      *                                                                   082911
     C                   MOVEL     RDDRVD        #1DRVD                         Allow Derived I
     C                   MOVEL     RDDSRC        #1DSRC                         Derived Informa
     C                   Z-ADD     RDSPOS        #1SPOS                         Start Position
     C                   MOVEL     RDDINT        #1DINT                         Derived Data in
     C                   Z-ADD     RDEPOS        #1EPOS                         End Position
     C                   MOVEL     RDAUSR        #1AUSR                         User name
     C                   Z-ADD     RDATIM        #1ATIM                         Action Time
     C                   MOVEL     RDARDT        #1ARDT                         Action Date
      * Hold existing record image
     C                   eval      @1DBRC = CGRDTA                                          MD054955
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
     C                   MOVEL     P2RDE         #1RDE                          Report Data Ele
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1020'     #MSGID
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
     C/COPY WNCPYSRC,CG1000DIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create RDE - Report Data Elements  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @RDTAL0
     C                   MOVEL     #1RDE         RDRDE                          Report Data Ele
     C                   MOVEL     'D'           RDRECI                         Record Identifi
     C                   MOVEL     #1ELYP        RDELYP                         Element Type
     C                   MOVEL     #1FOPT        RDFOPT                         Formatting Opti
     C                   Z-ADD     #1MAXL        RDMAXL                         Maximum Length
      *                                                                   082911
     C     #1ELYP        IFEQ      '*DEC  '                                                    08291
     C                   MOVE(P)   #1ETXT        @1ETXT                                        08291
     C                   MOVEL     @1ETXT        RDETXT                         Example Data   08291
     C                   ELSE                                                                  08291
     C                   MOVEL     #1ETXT        RDETXT                         Example Data
     C                   END                                                                   08291
      *                                                                   082911
     C                   MOVEL     #1DRVD        RDDRVD                         Allow Derived I
     C                   MOVEL     #1DSRC        RDDSRC                         Derived Informa
     C                   MOVEL     #1DINT        RDDINT                         Derived Data in
     C                   Z-ADD     #1SPOS        RDSPOS                         Start Position
     C                   Z-ADD     #1EPOS        RDEPOS                         End Position
     C                   MOVEL     #1DESC        RDDESC                         Description
     C                   MOVEL     ##JOB         RDAJOB                         Job name
     C                   MOVEL     ##USR         RDAUSR                         User name
     C                   Z-ADD     ##JTM         RDATIM                         Action Time
     C                   MOVEL     WUMRDT        RDARDT                         Action Date
     C                   MOVEL     'I'           RDAACT                         Action Type
     C                   Z-ADD     WURDNB        RDRDNB                         Run day number
      *
     C     KLCRSA        KLIST
     C                   KFLD                    RDRDE                          Report Data Ele
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @RDTAL0                                90    *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDTA                                                                        MD054955
     C+ from CGRDTJW0                                                                       MD054955
     C+ where RDRDE = :RDRDE and RDRECI = 'D'                                               MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 0                                              MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1067'     W0RTN             7
      * USER: Processing if Data record already exists
      * Change Report Data Elemen - Report Data Elements  *
     C                   EXSR      SBCHRC
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********         WRITE     @RDTAL0                              91      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGRDTBTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   RDRDE                                                                             MD054955
     C+ , RDRECI                                                                            MD054955
     C+ , RDELYP                                                                            MD054955
     C+ , RDFOPT                                                                            MD054955
     C+ , RDMAXL                                                                            MD054955
     C+ , RDETXT                                                                            MD054955
     C+ , RDDRVD                                                                            MD054955
     C+ , RDDSRC                                                                            MD054955
     C+ , RDDINT                                                                            MD054955
     C+ , RDSPOS                                                                            MD054955
     C+ , RDEPOS                                                                            MD054955
     C+ , RDDESC                                                                            MD054955
     C+ , RDAJOB                                                                            MD054955
     C+ , RDAUSR                                                                            MD054955
     C+ , RDATIM                                                                            MD054955
     C+ , RDARDT                                                                            MD054955
     C+ , RDAACT                                                                            MD054955
     C+ , RDRDNB                                                                            MD054955
     C+ , RDMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :RDRDE                                                                            MD054955
     C+ , :RDRECI                                                                           MD054955
     C+ , :RDELYP                                                                           MD054955
     C+ , :RDFOPT                                                                           MD054955
     C+ , :RDMAXL                                                                           MD054955
     C+ , :RDETXT                                                                           MD054955
     C+ , :RDDRVD                                                                           MD054955
     C+ , :RDDSRC                                                                           MD054955
     C+ , :RDDINT                                                                           MD054955
     C+ , :RDSPOS                                                                           MD054955
     C+ , :RDEPOS                                                                           MD054955
     C+ , :RDDESC                                                                           MD054955
     C+ , :RDAJOB                                                                           MD054955
     C+ , :RDAUSR                                                                           MD054955
     C+ , :RDATIM                                                                           MD054955
     C+ , :RDARDT                                                                           MD054955
     C+ , :RDAACT                                                                           MD054955
     C+ , :RDRDNB                                                                           MD054955
     C+ , 'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGRDTXTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   RDRDE                                                                             MD054955
     C+ , RDMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :RDRDE                                                                            MD054955
     C+ , 'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN91         IFEQ      '1'                                                      MD054955
     C                   If        (SQLCODE <> 0)                                           MD054955
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Report Data Elemen - Report Data Elements  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @RDTAL0
     C                   MOVEL     #1RDE         RDRDE                          Report Data Ele
      *
     C     KLCHSB        KLIST
     C                   KFLD                    RDRDE                          Report Data Ele
     C*****KLCHSB        CHAIN     @RDTAL0                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDTA                                                                        MD054955
     C+ from CGRDTJW0                                                                       MD054955
     C+ where RDRDE = :RDRDE                                                                MD054955
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
      * Move non-key fields to @RDTAL0
     C                   MOVEL     'D'           RDRECI                         Record Identifi
     C                   MOVEL     #1ELYP        RDELYP                         Element Type
     C                   MOVEL     #1FOPT        RDFOPT                         Formatting Opti
     C                   Z-ADD     #1MAXL        RDMAXL                         Maximum Length
      *                                                                   082911
     C     #1ELYP        IFEQ      '*DEC  '                                                    08291
     C                   MOVE(P)   #1ETXT        @1ETXT                                        08291
     C                   MOVEL     @1ETXT        RDETXT                         Example Data   08291
     C                   ELSE                                                                  08291
     C                   MOVEL     #1ETXT        RDETXT                         Example Data
     C                   END                                                                   08291
      *                                                                   082911
     C                   MOVEL     #1DRVD        RDDRVD                         Allow Derived I
     C                   MOVEL     #1DSRC        RDDSRC                         Derived Informa
     C                   MOVEL     #1DINT        RDDINT                         Derived Data in
     C                   Z-ADD     #1SPOS        RDSPOS                         Start Position
     C                   Z-ADD     #1EPOS        RDEPOS                         End Position
     C                   MOVEL     #1DESC        RDDESC                         Description
     C                   MOVEL     ##JOB         RDAJOB                         Job name
     C                   MOVEL     ##USR         RDAUSR                         User name
     C                   Z-ADD     ##JTM         RDATIM                         Action Time
     C                   MOVEL     WUMRDT        RDARDT                         Action Date
     C                   MOVEL     'I'           RDAACT                         Action Type
     C                   Z-ADD     WURDNB        RDRDNB                         Run day number
      *
     C**********         UPDATE    @RDTAL0                              91      *           MD054955
     C                   If        RDMODE = 'B'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGRDTBTD set                                                                 MD054955
     C+   RDRECI = :RDRECI                                                                  MD054955
     C+  ,RDELYP = :RDELYP                                                                  MD054955
     C+  ,RDFOPT = :RDFOPT                                                                  MD054955
     C+  ,RDMAXL = :RDMAXL                                                                  MD054955
     C+  ,RDETXT = :RDETXT                                                                  MD054955
     C+  ,RDDRVD = :RDDRVD                                                                  MD054955
     C+  ,RDDSRC = :RDDSRC                                                                  MD054955
     C+  ,RDDINT = :RDDINT                                                                  MD054955
     C+  ,RDSPOS = :RDSPOS                                                                  MD054955
     C+  ,RDEPOS = :RDEPOS                                                                  MD054955
     C+  ,RDDESC = :RDDESC                                                                  MD054955
     C+  ,RDAJOB = :RDAJOB                                                                  MD054955
     C+  ,RDAUSR = :RDAUSR                                                                  MD054955
     C+  ,RDATIM = :RDATIM                                                                  MD054955
     C+  ,RDARDT = :RDARDT                                                                  MD054955
     C+  ,RDAACT = :RDAACT                                                                  MD054955
     C+  ,RDRDNB = :RDRDNB                                                                  MD054955
     C+ where RDRDE = :RDRDE and RDRECI = 'D'                                               MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C                   If        RDMODE = 'C'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGRDTCTD set                                                                 MD054955
     C+   RDRECI = :RDRECI                                                                  MD054955
     C+  ,RDELYP = :RDELYP                                                                  MD054955
     C+  ,RDFOPT = :RDFOPT                                                                  MD054955
     C+  ,RDMAXL = :RDMAXL                                                                  MD054955
     C+  ,RDETXT = :RDETXT                                                                  MD054955
     C+  ,RDDRVD = :RDDRVD                                                                  MD054955
     C+  ,RDDSRC = :RDDSRC                                                                  MD054955
     C+  ,RDDINT = :RDDINT                                                                  MD054955
     C+  ,RDSPOS = :RDSPOS                                                                  MD054955
     C+  ,RDEPOS = :RDEPOS                                                                  MD054955
     C+  ,RDDESC = :RDDESC                                                                  MD054955
     C+  ,RDAJOB = :RDAJOB                                                                  MD054955
     C+  ,RDAUSR = :RDAUSR                                                                  MD054955
     C+  ,RDATIM = :RDATIM                                                                  MD054955
     C+  ,RDARDT = :RDARDT                                                                  MD054955
     C+  ,RDAACT = :RDAACT                                                                  MD054955
     C+  ,RDRDNB = :RDRDNB                                                                  MD054955
     C+ where RDRDE = :RDRDE and RDRECI = 'D'                                               MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
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
      * Delete RDE - Report Data Elements  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @RDTAL0
     C                   MOVEL     #1RDE         RDRDE                          Report Data Ele
      *
     C     KLCHSC        KLIST
     C                   KFLD                    RDRDE                          Report Data Ele
     C*****KLCHSC        CHAIN     @RDTAL0                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDTA                                                                        MD054955
     C+ from CGRDTJW0                                                                       MD054955
     C+ where RDRDE = :RDRDE                                                                MD054955
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
     C                   eval      @1DBRC = CGRDTA                                          MD054955
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSC        SETLL     @RDTAL0                            9091      *           MD054955
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before Data update
     C                   MOVEL     '*'           RDRECI                         Record Identifi
     C                   MOVEL     ##JOB         RDAJOB                         Job name
     C                   MOVEL     ##USR         RDAUSR                         User name
     C                   Z-ADD     ##JTM         RDATIM                         Action Time
     C                   MOVEL     WUMRDT        RDARDT                         Action Date
     C                   MOVEL     'D'           RDAACT                         Action Type
     C                   Z-ADD     WURDNB        RDRDNB                         Run day number
     C**********         UPDATE    @RDTAL0                              91      *           MD054955
     C                   If        RDMODE = 'B'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGRDTBTD set                                                                 MD054955
     C+   RDRECI = :RDRECI                                                                  MD054955
     C+  ,RDAJOB = :RDAJOB                                                                  MD054955
     C+  ,RDAUSR = :RDAUSR                                                                  MD054955
     C+  ,RDATIM = :RDATIM                                                                  MD054955
     C+  ,RDARDT = :RDARDT                                                                  MD054955
     C+  ,RDAACT = :RDAACT                                                                  MD054955
     C+  ,RDRDNB = :RDRDNB                                                                  MD054955
     C+ where RDRDE = :RDRDE                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C                   If        RDMODE = 'C'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGRDTCTD set                                                                 MD054955
     C+   RDRECI = :RDRECI                                                                  MD054955
     C+  ,RDAJOB = :RDAJOB                                                                  MD054955
     C+  ,RDAUSR = :RDAUSR                                                                  MD054955
     C+  ,RDATIM = :RDATIM                                                                  MD054955
     C+  ,RDARDT = :RDARDT                                                                  MD054955
     C+  ,RDAACT = :RDAACT                                                                  MD054955
     C+  ,RDRDNB = :RDRDNB                                                                  MD054955
     C+ where RDRDE = :RDRDE                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
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
      * Change RDE - Report Data Elements  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @RDTAL0
     C                   MOVEL     #1RDE         RDRDE                          Report Data Ele
      *
     C     KLCHSD        KLIST
     C                   KFLD                    RDRDE                          Report Data Ele
     C*****KLCHSD        CHAIN     @RDTAL0                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDTA                                                                        MD054955
     C+ from CGRDTJW0                                                                       MD054955
     C+ where RDRDE = :RDRDE                                                                MD054955
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
     C                   eval      @1DBRC = CGRDTA                                          MD054955
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSD        SETLL     @RDTAL0                            9091      *           MD054955
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @RDTAL0
     C                   MOVEL     'D'           RDRECI                         Record Identifi
     C                   MOVEL     #1ELYP        RDELYP                         Element Type
     C                   MOVEL     #1FOPT        RDFOPT                         Formatting Opti
     C                   Z-ADD     #1MAXL        RDMAXL                         Maximum Length
      *                                                                   082911
     C     #1ELYP        IFEQ      '*DEC  '                                                    08291
     C                   MOVE(P)   #1ETXT        @1ETXT                                        08291
     C                   MOVEL     @1ETXT        RDETXT                         Example Data   08291
     C                   ELSE                                                                  08291
     C                   MOVEL     #1ETXT        RDETXT                         Example Data
     C                   END                                                                   08291
      *                                                                   082911
     C                   MOVEL     #1DRVD        RDDRVD                         Allow Derived I
     C                   MOVEL     #1DSRC        RDDSRC                         Derived Informa
     C                   MOVEL     #1DINT        RDDINT                         Derived Data in
     C                   Z-ADD     #1SPOS        RDSPOS                         Start Position
     C                   Z-ADD     #1EPOS        RDEPOS                         End Position
     C                   MOVEL     #1DESC        RDDESC                         Description
     C                   MOVEL     ##JOB         RDAJOB                         Job name
     C                   MOVEL     ##USR         RDAUSR                         User name
     C                   Z-ADD     ##JTM         RDATIM                         Action Time
     C                   MOVEL     WUMRDT        RDARDT                         Action Date
     C                   MOVEL     'A'           RDAACT                         Action Type
     C                   Z-ADD     WURDNB        RDRDNB                         Run day number
      *
     C**********         UPDATE    @RDTAL0                              91      *           MD054955
     C                   If        RDMODE = 'B'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGRDTBTD set                                                                 MD054955
     C+   RDRECI = :RDRECI                                                                  MD054955
     C+  ,RDELYP = :RDELYP                                                                  MD054955
     C+  ,RDFOPT = :RDFOPT                                                                  MD054955
     C+  ,RDMAXL = :RDMAXL                                                                  MD054955
     C+  ,RDETXT = :RDETXT                                                                  MD054955
     C+  ,RDDRVD = :RDDRVD                                                                  MD054955
     C+  ,RDDSRC = :RDDSRC                                                                  MD054955
     C+  ,RDDINT = :RDDINT                                                                  MD054955
     C+  ,RDSPOS = :RDSPOS                                                                  MD054955
     C+  ,RDEPOS = :RDEPOS                                                                  MD054955
     C+  ,RDDESC = :RDDESC                                                                  MD054955
     C+  ,RDAJOB = :RDAJOB                                                                  MD054955
     C+  ,RDAUSR = :RDAUSR                                                                  MD054955
     C+  ,RDATIM = :RDATIM                                                                  MD054955
     C+  ,RDARDT = :RDARDT                                                                  MD054955
     C+  ,RDAACT = :RDAACT                                                                  MD054955
     C+  ,RDRDNB = :RDRDNB                                                                  MD054955
     C+ where RDRDE = :RDRDE and RDRECI = 'D'                                               MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C                   If        RDMODE = 'C'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGRDTCTD set                                                                 MD054955
     C+   RDRECI = :RDRECI                                                                  MD054955
     C+  ,RDELYP = :RDELYP                                                                  MD054955
     C+  ,RDFOPT = :RDFOPT                                                                  MD054955
     C+  ,RDMAXL = :RDMAXL                                                                  MD054955
     C+  ,RDETXT = :RDETXT                                                                  MD054955
     C+  ,RDDRVD = :RDDRVD                                                                  MD054955
     C+  ,RDDSRC = :RDDSRC                                                                  MD054955
     C+  ,RDDINT = :RDDINT                                                                  MD054955
     C+  ,RDSPOS = :RDSPOS                                                                  MD054955
     C+  ,RDEPOS = :RDEPOS                                                                  MD054955
     C+  ,RDDESC = :RDDESC                                                                  MD054955
     C+  ,RDAJOB = :RDAJOB                                                                  MD054955
     C+  ,RDAUSR = :RDAUSR                                                                  MD054955
     C+  ,RDATIM = :RDATIM                                                                  MD054955
     C+  ,RDARDT = :RDARDT                                                                  MD054955
     C+  ,RDAACT = :RDAACT                                                                  MD054955
     C+  ,RDRDNB = :RDRDNB                                                                  MD054955
     C+ where RDRDE = :RDRDE and RDRECI = 'D'                                               MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
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
      * Check reference to Format Group
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit
     C     #1FOPT        IFEQ      *BLANK                                       Formatting Opti
     C                   GOTO      VAEXIT
     C                   END
      *
      * Check for selection
      *
     C     ' ?'          CHECK     #1FOPT                                 90
     C     *IN90         IFEQ      '0'
     C     #1FOPT        ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       O2PARM
     C                   CALL      'CG1110'                             9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      'S'           O2ACTC            1            Action Code
     C                   PARM                    O2PARM                         B:RDE
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found
     C                   MOVEL     O2FOPT        #1FOPT
      *
      * Delay
      *
     C                   MOVEL     '1'           *IN99
     C                   GOTO      VAEXIT
     C                   END
      *
     C                   END
      *
     C     KLVAFG        KLIST
     C                   KFLD                    FGFOPT                         Formatting Opti
      * Setup key
     C                   MOVEL     #1FOPT        FGFOPT                         Formatting Opti
     C     KLVAFG        CHAIN     @FGRPL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Send message 'Format Group           NF'
     C                   MOVEL     'CGD1068'     ZAMSID
     C                   MOVEL     #1FOPT        ZAMSDA
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1068'     W0RTN
      *================================================================
     CSR   VAEXIT        ENDSR
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
     C/COPY WNCPYSRC,CG1000DEPP
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
      * Define work field Action Date
     C                   MOVEL     *BLANK        WUARDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Midas run date
     C                   MOVEL     *BLANK        WUMRDT            7
     C                   MOVEL     '0'           *IN77
     C                   MOVEL     *BLANKS       BBIN89
     C                   MOVEL     *BLANKS       CBIN89
      * Open files first time only
     C     W0OPN         IFEQ      *BLANK
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C**********         OPEN      CGRDTAL0                                                 MD054955
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
     C                   Z-ADD     4             W0ERNB
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
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      * EDTRCD: Initialise prog - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,CG1000DCPG
      *================================================================
     CSR   ZZEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRELYP   : Validate Element Type                             *
      *                                                               *
      *================================================================
     CSR   SRELYP        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRELYP'      @STK(Q)
      *
      * Element Type required
      *
     C     #1ELYP        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1041'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EXELYP
     C                   END                                                    FI
      *
      * Element Type must be *DEC, *CHAR or *CODE
      *
     C     #1ELYP        IFNE      '*CHAR'                                      IF
     C     #1ELYP        ANDNE     '*DEC '                                      IF
     C     #1ELYP        ANDNE     '*CODE'                                      IF
     C                   SETON                                        9931      *
     C                   MOVEL     'CGD1042'     ZAMSID
     C                   MOVEL     #1ELYP        ZAMSDA
     C                   EXSR      ZASNMS
     C                   GOTO      EXELYP
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXELYP        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRMAXL   : Maximum Length                                    *
      *                                                               *
      *================================================================
     CSR   SRMAXL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMAXL'      @STK(Q)
      *
      * Maximum Length required
      *
     C     #1MAXL        IFEQ      *ZERO                                        IF
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1066'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXMAXL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRDESC   : Description                                       *
      *                                                               *
      *================================================================
     CSR   SRDESC        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDESC'      @STK(Q)
      *
      * Description required
      *
     C     #1DESC        IFEQ      *BLANK                                       IF
     C                   SETON                                        9933      *
     C                   MOVEL     'CGD1069'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXDESC        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRFOPT   : Formatting Option                                 *
      *                                                               *
      *================================================================
     CSR   SRFOPT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFOPT'      @STK(Q)
      *
      * Formatting Options mandatory if *DEC or *CODE
      *
     C     #1FOPT        IFEQ      *BLANK                                       IF
     C     #1ELYP        ANDEQ     '*DEC  '                                     IF
     C     #1FOPT        OREQ      *BLANK                                       IF
     C     #1ELYP        ANDEQ     '*CODE '                                     IF
     C                   SETON                                        9934      *
     C                   MOVEL     'CGD1070'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXFOPT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRETXT   : Example Text                                      *
      *                                                               *
      *================================================================
     CSR   SRETXT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRETXT'      @STK(Q)
      *
      * Example Data is mandatory
      *
     C     #1ETXT        IFEQ      *BLANK                                       IF
     C                   SETON                                        9935      *
     C                   MOVEL     'CGD1071'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXETXT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRDRVD   : Allow Derived Information                         *
      *                                                               *
      *================================================================
     CSR   SRDRVD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDRVD'      @STK(Q)
      *
      * Allow Derived Information required
      * (it will default to 'N' if it is left blank)                      118741
      *
     C     #1DRVD        IFEQ      *BLANK                                       IF             11874
     C                   MOVEL     'N'           #1DRVD                                        11874
     C                   ENDIF                                                  FI             11874
      *                                                                   118741
     C     #1DRVD        IFEQ      *BLANK                                       IF
     C     #1DRVD        ORNE      'N'                                          IF
     C     #1DRVD        ANDNE     'Y'                                          IF
     C                   SETON                                        9936      *
     C                   MOVEL     'CGD1072'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXDRVD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRSPOS   : Start Position                                    *
      *                                                               *
      *================================================================
     CSR   SRSPOS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSPOS'      @STK(Q)
      *
      *  Start position must be greater than or equal to zero
      *
     C     #1SPOS        IFLT      0                                            IF
     C                   SETON                                        9938      *
     C                   MOVEL     'CGD1076'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXSPOS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SREPOS   : End Position                                      *
      *                                                               *
      *================================================================
     CSR   SREPOS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SREPOS'      @STK(Q)
      *
      *  Start position must be greater than or equal to zero
      *
     C     #1EPOS        IFLT      0                                            IF
     C                   SETON                                        9940      *
     C                   MOVEL     'CGD1077'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXEPOS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRXVAL   : Cross Validations                                 *
      *                                                               *
      *================================================================
     CSR   SRXVAL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRXVAL'      @STK(Q)
      *
      *  If mail merge start position entered it must be less than or
      *  equal to end position
      *
     C     #1SPOS        IFGT      0                                            IF
     C     #1SPOS        ANDGT     #1EPOS
     C                   SETON                                        993840    *
     C                   MOVEL     'CGD1073'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  If mail merge end position entered it must be greater than or
      *  equal to start position
      *
     C     #1EPOS        IFGT      0                                            IF
     C     #1EPOS        ANDLT     #1SPOS
     C                   SETON                                        993840    *
     C                   MOVEL     'CGD1074'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  If mail merge end position entered then start position must be
      *  greater than zero
      *
     C     #1EPOS        IFGT      0                                            IF
     C     #1SPOS        ANDLE     0
     C                   SETON                                        993840    *
     C                   MOVEL     'CGD1075'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXXVAL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
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
      /COPY WNCPYSRC,CG1000MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,CG1000MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,CG1000MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,CG1000MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,CG1000MOV5
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
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *   /copy to move data back from the data structure fields passed
      *    as a parameter to the window controller and control user
      *    defined processing.
      *
      /COPY WNCPYSRC,CG1000MOV6
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
     O/COPY WNCPYSRC,CG1000DOPG
**  CPY@
(c) Finastra International Limited 2001
