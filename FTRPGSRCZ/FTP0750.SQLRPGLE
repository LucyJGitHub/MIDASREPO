     H DEBUG
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD056560
/*STD *  RPGSQLMOD                                                    *                     MD056560
/*EXI *  TEXT('Midas FT STP Requirements Maintenance Values')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0750 - Midas FT STP Requirements Maintenance Values       *
      *                                                               *
      *  Function:  This program controls the display and update      *
      *             of STP Requirements                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD056560           Date 22Aug21               *
      *  Prev Amend No. MD031937           Date 13Jan15               *
      *                 AR856737           Date 15Jul2011             *
      *                 EEE065   *CREATE   Date 18Mar2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 Upgrade STP to Midas Plus level.                    *
      *           Renamed QQDFAC field in SDBRCHPD                    *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  03    Cancel and exit                                        *
      *  05    Reset screen field                                     *
      *  10    Delete record                                          *
      *  12    Redisplay previous screen                              *
      *  31,...,35 Error indicator for screen field                   *
      *  35    Used for TESTN operation                               *
      *  75    Protect Address etc                                    *
      *  76    Protect Confirmation                                   *
      *  77    Allow delete                                           *
      *  78    Protect key field                                      *
      *  79    Protect key field on detail screen                     *
      *  86    Putover                                                *
      *  89    Add mode                                               *
      *  90    Error indicator                                        *
      *  91    Record locked                                          *
      *  99    General error indicators                               *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *   ZZINIT - Initialization                                     *
      *   FACKPM - Check passed parameters                            *
      *   BADSKY - Display and process key screen                     *
      *   ZXEXPG - Cancel and exit from key screen                    *
      *   MDIZ#K - Initialise key screen                              *
      *   MAIZ#1 - Initialise record - except for key fields          *
      *   BBEXFM - Display key screen and process HELP requests       *
      *   BEPRKY - Process key screen input                           *
      *   GADSAK - Set key screen conditioning indicators             *
      *   BFVLKY - Validate key fields                                *
      *   MBFL#1 - Move @CIHDV1 fields to screen                      *
      *   CADSDAy- Display and process detail screen                  *
      *   CBEXFM - Display screen and process HELP requests           *
      *   GBDSAD - Set detail screen conditioning indicators          *
      *   SRWIND - Control Window Processing                          *
      *   EBPR## - Process record                                     *
      *   SACRRC - Create Record                                      *
      *   SCCHRC - Delete Record                                      *
      *   SDCHRC - Change Record                                      *
      *   SBCHRC - Change Record                                      *
      *   BDHMKY - Process HOME key                                   *
      *   BEPRKY - Process key screen input                           *
      *   CCDSPV - Redisplay previous screen                          *
      *   CFPRSC - Validate record                                    *
      *   DCVLDL - Validate details                                   *
      *   EDDLRQ - Process delete request                             *
      *   ECADRQ - Process add request                                *
      *   EECHRQ - Process update request                             *
      *                                                               *
      *****************************************************************
     FFTP0750DF CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Incoming Collection Header
      *
     FFTMSTRV1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : STP Requirements
      *
     FFTMSTRV0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(SRFILE)
      * UPD : STP Requirements
      *
     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : BIC Directory
      *
     F*SDMTAGL1* IF   E           K DISK
     F**********                           RENAME(@EFREJ5:@MTAGL1)                          MD056560
     F**********                           INFSR(SRFILE)                                    MD056560
      * RTV : Message Tags                                                                  MD056560
      *
     FFTMSTVV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : STP Requirements Values
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  End of Program Error Processing copysource
      *
      *
      **  Data Structure for input/output parameters
     D/COPY FTCPYSRC,FT0010D001
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
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC        E DS                  EXTNAME(FTMSTRV0)
      * UPD : Incoming Msg Translation  Update index
      * Current/previous master file format fields for change control
      *
     D #1DBRC          DS           202
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * Modules Data Structure *
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      *
      *  Funds Transfer details
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB) Prefix(Ac)
      *
      * Midas Accounts  *
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      * Data Structures for Branch Details
      *
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      *
      * Modules Data Structure *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * @CUST - Customer record format data structure
      *
     D DSCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Data Structures for Currency Definition
      *
     D DSDLST        E DS                  EXTNAME(SDDLSTPD)
      *
      * Data Structures for Deal Sub-Types
      *
     D DSCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      * Data Structures for Country codes
      *
     D DSBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)                                   AR856737
      *
      * Data Structures for Branch Details
      *
     D DSBOOK        E DS                  EXTNAME(SDBOOKPD)
      *
      * Data Structures for Book Details
      *
     D DSPRFC        E DS                  EXTNAME(SDPRFCPD)
      *
      * Data Structures for Profit Centre Details
      *
     D DSMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
      *
     D W0DATA          DS           256
      *
      *  Define data structure used to pass parameters
      *
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS           256
      *
      * I : MAP BIC identifier
     D  P2BICC                 1      8
      * I : MAP BIC Branch identifier
     D  P2BICB                 9     11
      * O : MAP LVP Agreement
     D  P2LVPA                12     12
      * O : MAP Regulated Pay
     D  P2REGP                13     13
      * I : MAP Tag of message
     D  P2MTAG                14     18
      * I : MAP Sequence
     D  P2TSEQ                19     21
     D O2PARM          DS           256
      * O : MAP Message Tag
     D  O2MTAG                 1      5
      * O : MAP Test
     D  O2TEST                 6     15
      * O : MAP Test data
     D  O2TSTD                16     45
      *
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
      *  Work fields
      *
      *  Defined Constants
      *
     D DIGITS          C                   CONST('0123456789')
      *
      *------------------------------
      *  Array containing Copyright statement
      *
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
      /EJECT
      *
      * Data to be passed to window processing
      *
     I/COPY QWINDSRC,FTP0750DTA
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         Date In
      *****************************************************************
      * Initialise
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
      * Initialise key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1BICC        IFEQ      *BLANK
     C     #1BICB        OREQ      *BLANK
     C     #1LVPA        OREQ      *BLANK
     C     #1REGP        OREQ      *BLANK
     C     #1MTAG        OREQ      *BLANK
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
      * Validate key fields
     C     P1ACTC        IFEQ      'I'
     C                   EXSR      BFVLKY
     C                   ENDIF
      * If C,E,D ignore key field validation
     C     P1ACTC        IFEQ      'D'
     C     P1ACTC        OREQ      'E'
     C                   SETOFF                                       99
     C                   MOVE      '00'          *IN(31)
     C                   MOVE      *BLANK        W0RTN
     C                   END
      *
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    MSBICC
     C                   KFLD                    MSBICB
     C                   KFLD                    MSLVPA
     C                   KFLD                    MSREGP
     C                   KFLD                    MSMTAG
     C                   KFLD                    MSTSEQ
      * Setup key
     C                   MOVEL     #1BICC        MSBICC
     C                   MOVEL     #1BICB        MSBICB
     C                   MOVEL     #1LVPA        MSLVPA
     C                   MOVEL     #1REGP        MSREGP
     C                   MOVEL     #1MTAG        MSMTAG
     C                   MOVEL     #1TSEQ        MSTSEQ
     C     KRTV          CHAIN     @MSTRV1                            9091      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
      *
      * If insert then send record already exists
      *
     C                   If        P1ACTC = 'I'
     C                   MOVEA     '11'          *IN(31)
     C                   MOVEL     '1'           *IN99
      * Send message 'Already exists'
     C                   MOVEL     'PR10029'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'PR10029'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      BEEXIT
     C                   Endif
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
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
      *
      * BIC Identifier
     C     #1MTAG        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'PR10038'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI

      * Define key
     C     KMTAGL1       Klist                                                  IF
     C                   Kfld                    EFMTAG                         IF
     C                   Kfld                    EFMTPY                         IF
     C                   Kfld                    EFMSEQ                         IF
      *
     C                   Eval      EFMTAG = #1MTAG
     C                   Eval      EFMTPY = '103'
     C                   Clear                   EFMSEQ
      *
     C*****KMTAGL1       Chain     @MTAGL1                                                  MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :DSMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :EFMTAG and EFMTPY = :EFMTPY                                         MD056560
     C/END-EXEC                                                                             MD056560
     C**********         If        Not %Found                                               MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'PR10039'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
      *
      *
      * BIC Identifier
     C                   Eval      #1INS1 = *blanks
     C                   If        #1BICC <> *Blanks                            IF

      * Define key
     C     KBICD         Klist                                                  IF
     C                   Kfld                    BDBICC                         IF
     C                   Kfld                    BDBICB                         IF
      * Set key
     C                   Eval      BDBICC = #1BICC
     C                   Eval      BDBICB = #1BICB
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        %Found
     C                   Eval      #1INS1 = BDINS1
     C                   Endif
     C                   Endif                                                  FI
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
     C   05              MOVEL     'R'           W0TRN
      *
      * If insert go to key screen else exit
      *
     C     *IN12         IFEQ      '1'
     C     P1ACTC        IFEQ      'I'
     C   12              MOVEL     'K'           W0TRN
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
     C                   Exsr      DCVLDL
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
     C                   EXSR      EBPR##
     C                   END
      *
      *
     C     P1ACTC        IFEQ      'D'                                          Cancel delete
     C     *IN10         ANDNE     '1'
     C                   MOVEL     'N'           W0TRN
     C                   END
      *
      * Exit if enquire or reverse exist
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
      *
      * To test if any ? are entered in screen fields
     C                   MOVEL     'N'           W0PMT             1
     C     '?'           Scan      #1TEST                                 90
     C                   If        *In90 = *On
     C                   Movel     'Y'           W0DCF
     C                   CLEAR                   O2PARM
     C                   Eval      O2MTAG = #1MTAG
      *
     C                   CALL      'FTP0760'                            9090
     C                   PARM                    P0RTN             7
     C                   PARM      'S'           WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *
     C                   If        P0rtn = 'Selectd'
     C                   Eval      #1TEST = O2TEST
     C                   Eval      #1TSTD = O2TSTD
     C                   Endif                                                  FI
      *
     C                   Endif                                                  FI
      * Test cannot be blank
     C                   If        #1TEST = *blanks
      * Send message 'Error and default
     C                   MOVEL     'PR10033'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In31 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif

      * Define key
     C     KMSTVV1       Klist                                                  IF
     C                   Kfld                    MVMTAG                         IF
     C                   Kfld                    MVTEST                         IF
     C                   Kfld                    MVTSTD                         IF
      *
     C                   Eval      MVMTAG = #1MTAG
     C                   Eval      MVTEST = #1TEST
     C                   Eval      MVTSTD = #1TSTD
      *
     C     KMSTVV1       Chain     @MSTVV1
     C                   If        Not %Found
     C                   Eval      MVTSTD = '*DATA'
     C     KMSTVV1       Chain     @MSTVV1
     C                   If        Not %Found
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL     'PR10043'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      * Test data must be specified
     C                   If        *In99 = *Off and MVTSTD = '*DATA'
     C                             And MVTSTD = *blanks
      * Send message 'Error and default
     C                   MOVEL     'PR10034'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In31 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
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
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
      *
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'N'           W0RPT
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
      * Create Record - Incoming Msg Translation  * 
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
      * Delete Record - Incoming Msg Translation  * 
     C                   EXSR      SCCHRC
      *
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'PR10032'     ZAMSID
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
      * Change Incoming Msg Trans - Incoming Msg Translation  * 
     C                   EXSR      SDCHRC
     C     W0RTN         IFNE      *BLANK
      * DBF update error
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
     C     P2BICC        IFEQ      *BLANK
     C     P2BICB        OREQ      *BLANK
     C     P2LVPA        OREQ      *BLANK
     C     P2REGP        OREQ      *BLANK
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
     C     W0FRST        IFEQ      *BLANKS
     C                   MOVEL     'k'           CBIN89
     C                   MOVEL     'Y'           W0FRST
     C                   ENDIF
     C                   MOVEL     '0'           *IN75
     C                   MOVEL     '0'           *IN76
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'I'                                          *IF
     C     P1ACTC        OREQ      'A'                                          *IF
     C                   MOVEL     '0'           *IN75
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
     C     P1ACTC        IFEQ      'E'                                          *IF
     C     P1ACTC        OREQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN75
     C                   MOVEL     '1'           *IN76
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
      * Initialise record - except for key fields
      *================================================================
     C                   If        P1Actc = 'I'
     C                   Clear                   #1RECI
     C                   Clear                   #1AJOB
     C                   Clear                   #1AACT
     C                   Clear                   #1RDNB
     C                   Clear                   #1MTAG
     C                   Clear                   #1TSEQ
     C                   Clear                   #1TEST
     C                   Eval      #1Test = '?'
     C                   Clear                   #1TSTD
     C                   Clear                   #1INS1
     C                   Endif
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
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10034'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
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
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10024'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
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
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10035'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
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
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10024'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
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
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10036'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
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
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10024'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
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
     C                   Movel     'PR10037'     #MSGID
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM                    #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
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
     C                   Movel     'PR10028'     #MSGID
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM                    #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     '1'           *IN77
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
     C                   ENDSL
      *
      * Set expansion fields
     C                   Eval      #1INS1 = *blanks
      * Set key
     C                   Eval      BDBICC = #1BICC
     C                   Eval      BDBICB = #1BICB
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        %Found
     C                   Eval      #1INS1 = BDINS1
     C                   Endif
      *
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @MSTRV1 fields to screen
      *================================================================

     C                   MOVEL     MSBICC        #1BICC
     C                   MOVEL     MSBICB        #1BICB
     C                   MOVEL     MSLVPA        #1LVPA
     C                   MOVEL     MSREGP        #1REGP
     C                   MOVEL     MSMTAG        #1MTAG
     C                   MOVEL     MSTSEQ        #1TSEQ
     C                   MOVEL     MSTEST        #1TEST
     C                   MOVEL     MSTSTD        #1TSTD
     C                   MOVEL     MSDER1        #1DER1
     C                   MOVEL     MSDER2        #1DER2
     C                   MOVEL     MSDER3        #1DER3
     C                   MOVEL     *BLANKS       #1INS1

     C                   MOVEL     MSAJOB        #1AJOB                         Job name
     C                   MOVEL     MSAACT        #1AACT                         Action Type
     C                   Z-ADD     MSRDNB        #1RDNB                         Run day number
     C                   MOVEL     MSAUSR        #1AUSR                         User name
     C                   MOVEL     MSARDT        #1ARDT                         Action Date
     C                   Z-ADD     MSATIM        #1ATIM                         Action Time
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      * Get description data
      * Set expansion fields
     C                   Eval      #1INS1 = *blanks
      * Set key
     C                   Eval      BDBICC = #1BICC
     C                   Eval      BDBICB = #1BICB
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        %Found
     C                   Eval      #1INS1 = BDINS1
     C                   Endif
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialise key screen
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code

     C                   MOVEL     *Blanks       #1BICC
     C                   MOVEL     *Blanks       #1BICB
     C                   MOVEL     *Blanks       #1LVPA
     C                   MOVEL     *Blanks       #1REGP
     C                   MOVEL     *BLANKS       #1INS1

     C                   MOVEL     P2BICC        #1BICC
     C                   MOVEL     P2BICB        #1BICB
     C                   MOVEL     P2LVPA        #1LVPA
     C                   MOVEL     P2REGP        #1REGP
     C                   MOVEL     P2MTAG        #1MTAG
     C                   MOVEL     P2TSEQ        #1TSEQ
      * USER: Initialise key screen
      * Option Name
     C                   SELECT
      * Insert screen
     C     P1ACTC        WHENEQ    'I'
     C                   MOVEL     '0'           *IN77
     C                   MOVEL     'PR10034'     #MSGID
      * Enquiry screen
     C     P1ACTC        WHENEQ    'E'
     C                   MOVEL     'PR10035'     #MSGID
      * Amendment screen
     C     P1ACTC        WHENEQ    'A'
     C                   MOVEL     'PR10036'     #MSGID
      * Delete screen
     C     P1ACTC        WHENEQ    'D'
     C                   MOVEL     'PR10037'     #MSGID
     C                   ENDSL
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM                    #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONKY
      * Action codes
     C                   MOVEL     *BLANKS       #KCMD1
      * Function keys
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10024'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #KCMD2
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Record
      *================================================================
      * Setup key
     C                   MOVEL     #1BICC        MSBICC
     C                   MOVEL     #1BICB        MSBICB
     C                   MOVEL     #1LVPA        MSLVPA
     C                   MOVEL     #1REGP        MSREGP
     C                   MOVEL     #1MTAG        MSMTAG
     C                   MOVEL     #1TSEQ        MSTSEQ
     C     KRTV          CHAIN     @MSTRV0                                      *
      * If found and live
     C                   IF        %Found and MsReci = 'D'
     C                   MOVEL     'CCS0093'     W0RTN             7
      * USER: Processing if DBF record already exists
     C                   GOTO      SAEXIT
     C                   END                                                    FI 91
     C
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @MSTRV0
     C                   MOVEL     #1BICC        MSBICC
     C                   MOVEL     #1BICB        MSBICB
     C                   MOVEL     #1LVPA        MSLVPA
     C                   MOVEL     #1REGP        MSREGP
     C                   MOVEL     #1MTAG        MSMTAG
     C                   MOVEL     #1TSEQ        MSTSEQ
     C                   MOVEL     #1TEST        MSTEST
     C                   MOVEL     #1TSTD        MSTSTD
      *
     C                   MOVEL     #1DER1        MSDER1
     C                   MOVEL     #1DER2        MSDER2
     C                   MOVEL     #1DER3        MSDER3
      *
     C                   MOVEL     #1AJOB        MSAJOB
     C                   MOVEL     #1AACT        MSAACT
     C                   Z-ADD     #1RDNB        MSRDNB
     C                   MOVEL     #1AUSR        MSAUSR
     C                   MOVEL     #1ARDT        MSARDT
     C                   Z-ADD     #1ATIM        MSATIM
      *
     C                   MOVEL     'D'           MSRECI                         Record Identifi
     C                   MOVEL     ##JOB         MSAJOB                         Job name
     C                   MOVEL     ##USR         MSAUSR                         User name
     C                   Z-ADD     ##JTM         MSATIM                         Action Time
     C                   MOVEL     WUMRDT        MSARDT                         Action Date
     C                   MOVEL     'I'           MSAACT                         Action Type
     C                   Z-ADD     WURDNB        MSRDNB                         Run day number
      *
     C                   MOVEL     #1BICC        MSBICC
     C                   MOVEL     #1BICB        MSBICB
     C                   MOVEL     #1LVPA        MSLVPA
     C                   MOVEL     #1REGP        MSREGP
     C                   MOVEL     #1MTAG        MSMTAG
     C                   MOVEL     #1TSEQ        MSTSEQ
      *
     C     KLCRSA        KLIST
     C                   KFLD                    MSBICC
     C                   KFLD                    MSBICB
     C                   KFLD                    MSLVPA
     C                   KFLD                    MSREGP
     C                   KFLD                    MSMTAG
     C                   KFLD                    MSTSEQ
      * Write or update
     C                   If        %Found
     C                   Update    @MSTRV0
     C                   Else
      *
     C                   WRITE     @MSTRV0                              91      *
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF write successful
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Record - Incoming Msg Translation  * 
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CIHDV0
     C                   MOVEL     #1BICC        MSBICC
     C                   MOVEL     #1BICB        MSBICB
     C                   MOVEL     #1LVPA        MSLVPA
     C                   MOVEL     #1REGP        MSREGP
     C                   MOVEL     #1MTAG        MSMTAG
     C                   MOVEL     #1TSEQ        MSTSEQ
      *
     C     KLCHSB        KLIST
     C                   KFLD                    MSBICC
     C                   KFLD                    MSBICB
     C                   KFLD                    MSLVPA
     C                   KFLD                    MSREGP
     C                   KFLD                    MSMTAG
     C                   KFLD                    MSTSEQ
     C     KLCHSB        CHAIN     @MSTRV0                            9091      *
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
      * Move non-key fields to @MSTRV0
     C                   MOVEL     #1TEST        MSTEST
     C                   MOVEL     #1TSTD        MSTSTD
      *
     C                   MOVEL     #1DER1        MSDER1
     C                   MOVEL     #1DER2        MSDER2
     C                   MOVEL     #1DER3        MSDER3
      *
     C                   MOVEL     #1RECI        MSRECI                         Record Identifi
     C                   MOVEL     #1AJOB        MSAJOB                         Job name
     C                   MOVEL     #1AACT        MSAACT                         Action Type
     C                   Z-ADD     #1RDNB        MSRDNB                         Run day number
     C                   MOVEL     #1AUSR        MSAUSR                         User name
     C                   MOVEL     #1ARDT        MSARDT                         Action Date
     C                   Z-ADD     #1ATIM        MSATIM                         Action Time
      *
     C                   MOVEL     'D'           MSRECI                         Record Identifi
     C                   MOVEL     ##JOB         MSAJOB                         Job name
     C                   MOVEL     ##USR         MSAUSR                         User name
     C                   Z-ADD     ##JTM         MSATIM                         Action Time
     C                   MOVEL     WUMRDT        MSARDT                         Action Date
     C                   MOVEL     'A'           MSAACT                         Action Type
     C                   Z-ADD     WURDNB        MSRDNB                         Run day number
      *
     C                   UPDATE    @MSTRV0                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Delete Record -
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CIHDV0
     C                   MOVEL     #1BICC        MSBICC
     C                   MOVEL     #1BICB        MSBICB
     C                   MOVEL     #1LVPA        MSLVPA
     C                   MOVEL     #1REGP        MSREGP
     C                   MOVEL     #1MTAG        MSMTAG
     C                   MOVEL     #1TSEQ        MSTSEQ
      *
     C     KLCHSC        KLIST
     C                   KFLD                    MSBICC
     C                   KFLD                    MSBICB
     C                   KFLD                    MSLVPA
     C                   KFLD                    MSREGP
     C                   KFLD                    MSMTAG
     C                   KFLD                    MSTSEQ
     C     KLCHSC        CHAIN     @MSTRV0                            9091      *
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
     C     KLCHSC        SETLL     @MSTRV0                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before DBF update
     C                   MOVEL     '*'           MSRECI                         Record Identifi
     C                   MOVEL     'D'           MSAACT                         Action Type
      *
     C                   MOVEL     ##JOB         MSAJOB                         Job name
     C                   MOVEL     ##USR         MSAUSR                         User name
     C                   Z-ADD     ##JTM         MSATIM                         Action Time
     C                   MOVEL     WUMRDT        MSARDT                         Action Date
     C                   Z-ADD     WURDNB        MSRDNB                         Run day number
      *
     C                   UPDATE    @MSTRV0                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF change successful
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Record
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @CIHDV0
     C                   MOVEL     #1BICC        MSBICC
     C                   MOVEL     #1BICB        MSBICB
     C                   MOVEL     #1LVPA        MSLVPA
     C                   MOVEL     #1REGP        MSREGP
     C                   MOVEL     #1MTAG        MSMTAG
     C                   MOVEL     #1TSEQ        MSTSEQ
      *
     C     KLCHSD        KLIST
     C                   KFLD                    MSBICC
     C                   KFLD                    MSBICB
     C                   KFLD                    MSLVPA
     C                   KFLD                    MSREGP
     C                   KFLD                    MSMTAG
     C                   KFLD                    MSTSEQ
     C     KLCHSD        CHAIN     @MSTRV0                            9091      *
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
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSD        SETLL     @MSTRV0                            9091      *
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      *
      *
      * Move non-key fields to @MSTRV0
     C                   MOVEL     #1TEST        MSTEST
     C                   MOVEL     #1TSTD        MSTSTD
      *
     C                   MOVEL     #1DER1        MSDER1
     C                   MOVEL     #1DER2        MSDER2
     C                   MOVEL     #1DER3        MSDER3
      *
     C                   MOVEL     #1RECI        MSRECI                         Record Identifi
     C                   MOVEL     #1AJOB        MSAJOB                         Job name
     C                   MOVEL     #1AACT        MSAACT                         Action Type
     C                   Z-ADD     #1RDNB        MSRDNB                         Run day number
     C                   MOVEL     #1AUSR        MSAUSR                         User name
     C                   MOVEL     #1ARDT        MSARDT                         Action Date
     C                   Z-ADD     #1ATIM        MSATIM                         Action Time
      *
     C                   MOVEL     'D'           MSRECI                         Record Identifi
     C                   MOVEL     ##JOB         MSAJOB                         Job name
     C                   MOVEL     ##USR         MSAUSR                         User name
     C                   Z-ADD     ##JTM         MSATIM                         Action Time
     C                   MOVEL     WUMRDT        MSARDT                         Action Date
     C                   MOVEL     'A'           MSAACT                         Action Type
     C                   Z-ADD     WURDNB        MSRDNB                         Run day number
      *
     C                   UPDATE    @MSTRV0                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF change successful
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
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
      *EDTRCD: Cpysrc Templates Exit Program Processing
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK
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
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *BLANK        W0FRST            1
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'FTUSRMSG'    ZADFMF           10
      * Define work field Action Code
     C                   MOVEL     *BLANK        WUACTC            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEL     '0'           *IN77
      * Open files first time only
     C     W0OPN         IFEQ      *BLANK
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C                   OPEN      FTMSTRV0
      * Signal that files are now open
     C                   MOVE      'Y'           W0OPN             1
     C                   END
      * Select initial mode
     C     @1NROP        IFEQ      *ZERO
      * Add mode
     C                   MOVEL     'ADD'         W0PMD             3
     C                   ELSE
      * Change mode
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialise program
      *
      *  Set up copyright parameter
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      *  Extract bank details
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     SDBANK        PARM      *BLANKS       DSFDY
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     6             W0ERNB                         * DB ERROR 06 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Get modules information
      *
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
     C                   Z-ADD     7             W0ERNB                         * DB ERROR 07 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *

      **?Get Funds Transfer ICD

     C                   CALL      'AOFTFRR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
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
      /COPY WNCPYSRC,FTP075MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,FTP075MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,FTP075MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,FTP075MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,FTP075MOV5
     C                   ENDSL
      *
     C                   CALL      'WN0010'
     C                   PARM      ##PGM         O#PGM            10
     C                   PARM      *BLANKS       O#CMD             2
     C                   PARM      P1ACTC        O#ACTN            1
     C                   PARM                    DATA
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM                    EXTRA           256
      *
      *   /copy to move data back from the data structure fields passed
      *    as a parameter to the window controller and control user
      *    defined processing.
      *
      /COPY WNCPYSRC,FTP075MOV6
      *
     C     *LIKE         DEFINE    O#RTN         R#RTN
     C     R#RTN         CABEQ     *BLANKS       EXWIND
      *
      *  Check return code and send message on action
      *  - set no update as some action has been specified.
      *
     C                   MOVEL     'Y'           W0DCF
     C                   ROLBK
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
      * *Return code is *Previous Screen
      *
     C     R#RTN         WHENEQ    'USR0790'
     C                   MOVEL     'PR10014'     ZAMSID
     C                   EXSR      ZASNMS
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
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
