     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT STP Payment Corr. Pay Via Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0640 - Midas FT STP Payment Corr. Pay Via Maintenance     *
      *                                                               *
      *  Function:  This program controls the display and update      *
      *             of STP Requirements                               *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 15Jul2011             *
      *                 HVB003             Date 19Oct2011             *
      *                 PNL015             Date 01Dec2005             *
      *                 PNL014             Date 07Dec2005             *
      *                 EEE065   *CREATE   Date 05Apr2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  HVB003 - Routing for Target Balance payments                 *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *             Renamed QQDFAC field in SDBRCHPD                  *
      *             Changed length of P@ACCD to 10                    *
      *  PNL015 - Redirection to head office BIC                      *
      *  PNL014 - Time Sensitive Payments                             *
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
     FFTP0640DF CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Incoming Collection Header
      *
     FFTMSCPV1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : STP Correspondent payment routes
      *
     FFTMSCPV0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(SRFILE)
      * UPD : STP Correspondent payment routes
      *
     FFTMSCCV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : STP Correspondents
      *
     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Deal type sub-type combinations
      *
     FFTPCHGL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Pay charge codes
      *
     FFTPICDV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Midas FT Payment Route ICD
      *
     FFTPSTTV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Midas FT Payment Route Settlement Methods
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
     D @1DBRC        E DS                  EXTNAME(FTMSCPV0)
      * UPD : Incoming Msg Translation  Update index
      * Current/previous master file format fields for change control
      *
     D*#1DBRC******    DS           466                                                       PNL014
     D #1DBRC          DS           524                                                       PNL014
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D @@I1            DS
      * Screen one error indicator store
     D  @I1                    1    100
     D                                     DIM(100)
     D**INSCR1                31     60                                                       PNL014
     D  INSCR1                31     70                                                       PNL014
     D @@I2            DS
      * Screen two error indicator store
     D  @I2                    1    100
     D                                     DIM(100)
     D  INSCR2                31     60
     D @@I3            DS
      * Screen three error indicator store
     D  @I3                    1    100
     D                                     DIM(100)
     D  INSCR3                31     60
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
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  PNL014
                                                                                              PNL014
      *  Currency Details *                                                                   PNL014
      *                                                                                       PNL014
     D DSDLST        E DS                  EXTNAME(SDDLSTPD)
      *
      * Data Structures for Deal Sub-Types
      *
     D DSCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      * Data Structures for Country codes
      *
     D DSBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)                       AR856737
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
     D DsAccounts      DS
     D  W0Account              1     34
     D  W0Brca                             Like(AcBrca)
     D  W0Cnum                             Like(AcCnum)
     D  W0Ccy                              Like(AcCcy )
     D  W0Acod                             Like(AcAcod)
     D  W0Acsq                             Like(AcAcsq)
     D  W0Acno                             Like(AcAcno)
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
      * O : MAP Pay Currency
     D  P2PCCY                12     14
      * O : MAP BIC identifier
     D  P2CBIC                15     22
      * O : MAP BIC Branch identifier
     D  P2CBIB                23     25
      *
     D O2PARM          DS           256
      *
      *  Define data structure used to pass parameters
      *
      * Booking branch
     D  O2BRCA                 1      3
      * Information type  (S=SWIFT C=Customer)
     D  O2TYPE                 4      4
      * SWIFT BIC
     D  O2SBIC                 5     15
     D  O2SBICC                5     12
     D  O2SBICB               13     15
      * Customer
     D  O2CUST                16     21
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
     I/COPY QWINDSRC,FTP0640DTA
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
      * Set control to display first screen
     C                   Z-ADD     1             W0SCR             3 0
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1BICC        IFEQ      *BLANK
     C     #1BICB        OREQ      *BLANK
     C     #1PCCY        orEQ      *BLANK
     C     #1CBIC        orEQ      *BLANK
     C     #1CBIB        OREQ      *BLANK
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
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
     C                   KFLD                    MPCBIC
     C                   KFLD                    MPCBIB
      * Setup key
     C                   MOVEL     #1BICC        MPBICC
     C                   MOVEL     #1BICB        MPBICB
     C                   MOVEL     #1PCCY        MPPCCY
     C                   MOVEL     #1CBIC        MPCBIC
     C                   MOVEL     #1CBIB        MPCBIB
     C     KRTV          CHAIN     @MSCPV1                            9091      *
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
     C     #1CBIC        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'PR10058'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * BIC Identifier
     C                   Eval      #1INT1 = *blanks
      *
     C                   Select                                                 FI
     C                   When      #1CBIC = 'SERVICES'                          IF
      *
     C                   If        #1CBIB <> 'ACH'
     C                             and #1CBIB <> 'EBA'
     C                             and #1CBIB <> 'ERP'
     C                             and #1CBIB <> 'ES2'
     C                             and #1CBIB <> 'EEX'
     C                             and #1CBIB <> 'ACX'
     C                             and #1CBIB <> 'EES'
     C                             and #1CBIB <> 'ACE'
     C                             and #1CBIB <> 'ACL'
     C                             and #1CBIB <> 'TBL'                          HVB003
     D/COPY WNCPYSRC,FTP0640C01
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'PR10197'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   When      #1CBIC <> *Blanks                            IF

     C                   Eval      O2type = 'S'
     C                   Eval      O2SBicc = #1CBic
     C                   Eval      O2SBicb = #1CBib
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat

      * Define key
     C     KBICD         Klist                                                  IF
     C                   Kfld                    BDBICC                         IF
     C                   Kfld                    BDBICB                         IF
      * Set key
     C                   Eval      BDBICC = #1CBIC
     C                   Eval      BDBICB = #1CBIB
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   Select
     C                   When      Not %Found and #1CBIB = *blanks
     C                   Eval      BDBICB = 'XXX'
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        Not %Found
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
     C                   Eval      #1CBIB = 'XXX'
     C                   Eval      #1INT1 = BDINS1
     C                   Endif                                                  FI
     C                   When      Not %Found and #1CBIB = '???'
     C                             And O2Rtn = *blanks
     C                             And #1BicC = #1CBic
     C                   When      Not %Found
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   When      %Found
     C                   Eval      #1INT1 = BDINS1
     C                   Endsl
     C**>>>>             Endif                                                  FI

      * Check correspondent type for conflicts
     C                   If        *In99 = *Off                                 FI

     C                   If        %subst(#1BICC:1:4) = '????'                  FI
     C                             Or
     C                             %subst(#1BICC:5:2) = '??'
     C                             Or
     C                             %subst(#1BICC:7:2) = '??'
     C                             Or
     C                             #1BICB = '???'
     C                   Eval      McBICC = #1CBIC
     C                   Eval      McBICB = #1CBIB
     C                   Eval      McPCCY = #1PCCY

      * If branch is blank then set default

     C                   Select
     C                   When      O2Brca = *blanks  and IcDbrc = *blanks
     C                   Eval      O2Brca = 'MBB'
     C                   Other
     C                   Eval      O2Brca = ICDBrc
     C                   Endsl

     C                   Eval      O2type = 'S'
     C                   Eval      O2SBicc = #1CBic
     C                   Eval      O2SBicb = #1CBib
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
      * Get data
     C     KMsccv1       Chain     @Msccv1
     C                   If        %Found and McCtyp <> 'ACCOUNT'
     C                             and O2Rtn <> *blanks
     C                             or Not %Found and O2Rtn <> *blanks
      *
     C                   SETON                                        993132    *
     C                   MOVEL     'PR10157'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI

     C                   Endif                                                  FI

     C                   Endsl                                                  FI
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
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
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
     C                   ELSE
     C     W0SCR         IFEQ      3
      * Set error
     C                   MOVEA     INSCR3        *IN(31)
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT4
     C                   EXFMT     #RCDDTL3
     C                   END
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
      * Initialise error memories
     C                   MOVE      *ZERO         INSCR1
     C                   MOVE      *ZERO         INSCR2
     C                   MOVE      *ZERO         INSCR3
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CDNXSC        BEGSR
      *================================================================
      * Display next screen
      *================================================================
      * Set roll flag
     C                   MOVEL     'Y'           W0ROL             1
     C     W0SCR         IFLT      3
     C                   ADD       1             W0SCR
     C                   END
      *================================================================
     CSR   CDEXIT        ENDSR
      /EJECT
     CSR   CEPVSC        BEGSR
      *================================================================
      * Display previous screen
      *================================================================
      * Set roll flag
     C                   MOVEL     'Y'           W0ROL             1
     C     W0SCR         IFGT      1
     C                   SUB       1             W0SCR
     C                   END
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
      * Validate details
     C                   MOVE      *ZEROS        INSCR1
     C                   MOVE      *ZEROS        INSCR2
     C                   MOVE      *ZEROS        INSCR3
     C                   Exsr      DCVLDL
      * Display first screen in error
     C     INSCR1        IFNE      *ZERO
     C                   Z-ADD     1             W0SCR
     C                   ELSE
     C     INSCR2        IFNE      *ZERO
     C                   Z-ADD     2             W0SCR
     C                   ELSE
     C     INSCR3        IFNE      *ZERO
     C                   Z-ADD     3             W0SCR
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
      *
      * Validate Screen 1
      *
     C                   EXSR      SRSCR1
      *
      * Validate Screen 2
      *
     C                   EXSR      SRSCR2
      *
      * Validate Screen 2
      *
     C                   EXSR      SRSCR3
      *
      * Cross Validations
      *
     C                   IF        *In99 = '0'
     C                   EXSR      SRXVAL
     C                   END
     C                   IF        *In99 = '0'
     C                   EXSR      SRXVAL2
     C                   END
     C                   IF        *In99 = '0'
     C                   EXSR      SRXVAL3
     C                   END
      * USER: Validate detail screen fields
      *
      * To test if any ? are entered in screen fields
     C                   MOVEL     'N'           W0PMT             1
      *================================================================
     CSR   DCEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRSCR1   : Validate Screen 1                                 *
      *                                                               *
      *================================================================
     CSR   SRSCR1        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSCR1'      @STK(Q)
      * Receiver a/c must be Y, N or blanks
     C                   If        #1RCAU <> 'N' and #1RCAU <> 'Y'
     C                             and #1RCAU <> *blanks
      *
     C                   MOVEL     'PR10145'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(45)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Check if SWIFT entered
     C                   If        #1C53A <> *blanks
     C                   Eval      McBICC = #1C53A
     C                   Eval      McBICB = 'XXX'
     C                   Eval      McPCCY = #1PCCY
     C     KMsccv1       Chain     @Msccv1
     C                   If        %Found and McCtyp = 'ACCOUNT'
     C                   Eval      #1C53A = %Subst(McDAcr:1:10)
     C                   Endif
     C                   Endif
      * Sender's correspondent entered
     C                   If        #1C53A <> *blanks
     C                   Eval      W0Account = #1C53A
     C                   Exsr      SrAccount
     C                   Else
     C                   Eval      #1C53C = *blanks
     C                   Eval      #1C53B = *blanks
     C                   Endif
      * Cover required default is no
     C                   If        #1C53R = *blanks
     C                   Movel     'N'           #1C53R
     C                   Endif
      * Cover required must be Yes or No
     C                   If        #1C53R <> 'N' and #1C53R <> 'Y'
      *
     C                   MOVEL     'PR10067'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(32)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Replace Mt910 must be Y or N
     C                   If        #1R910 = *blanks
     C                   Movel     'N'           #1R910
     C                   Endif
      * Replace 910 must be Yes or No
     C                   If        #1R910 <> 'N' and #1R910 <> 'Y'
      *
     C                   MOVEL     'PR10195'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(51)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
     C     KPSttV1       Klist
     C                   Kfld                    SMSTMT
      *
     C                   If        #1STMT <> '08' and #1STMT <> *blanks
     C                   Eval      SMSTMT = #1STMT
     C     KPSttV1       Chain     @PSTTV1
      *
     C                   If        Not %Found
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(52)
      *
     C                   MOVEL     'PR10196'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Endif
      * Receiver's Correspondent
     C                   If        #1C54C <> *blanks or #1C54B <> *Blanks
     C                   If        #1C54B = *blanks
     C                   Eval      #1C54B = 'XXX'
     C                   Endif
      * Set key
     C                   Eval      BDBICC = #1C54C
     C                   Eval      BDBICB = #1C54B
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        Not %Found
      * Send message 'Error and default
     C                   MOVEL     'PR10065'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(33)
     C                   Movel     'Y'           W0DCF
     C                   Endif
     C                   Endif
      * Intermediary
     C                   If        #1C56C <> *blanks or #1C56B <> *Blanks
     C                   If        #1C56B = *blanks
     C                   Eval      #1C56B = 'XXX'
     C                   Endif
      * Set key
     C                   Eval      BDBICC = #1C56C
     C                   Eval      BDBICB = #1C56B
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        Not %Found
      * Send message 'Error and default
     C                   MOVEL     'PR10066'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(34)
     C                   Movel     'Y'           W0DCF
     C                   Endif
     C                   Endif
      * Serial Pay default is no
     C                   If        #1SERP = *blanks
     C                   Movel     'N'           #1SERP
     C                   Endif
      * Serial Pay must be Yes or No
     C                   If        #1SERP <> 'N' and #1SERP <> 'Y'
      *
     C                   MOVEL     'PR10148'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(47)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Serial LVP default is no
     C                   If        #1SLVP = *blanks
     C                   Movel     'N'           #1SLVP
     C                   Endif
      * Serial LVP must be Yes or No
     C                   If        #1SLVP <> 'N' and #1SLVP <> 'Y'
      *
     C                   MOVEL     'PR10155'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(48)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Serial Reg default is no
     C                   If        #1SREG = *blanks
     C                   Movel     'N'           #1SREG
     C                   Endif
      * Serial REG must be Yes or No
     C                   If        #1SREG <> 'N' and #1SREG <> 'Y'
      *
     C                   MOVEL     'PR10166'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(49)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Allow Foreign Banks default is Y
     C                   If        #1FBIC = *blanks
     C                   Movel     'Y'           #1FBIC
     C                   Endif
      * Allow Foreign Banks must be Y or N
     C                   If        #1FBIC <> 'N' and #1FBIC <> 'Y'
      *
     C                   MOVEL     'PR10232'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(53)
     C                   Movel     'Y'           W0DCF
     C                   Endif
                                                                                              PNL015
      * Route via Head Office default is N                                                    PNL015
     C                   If        #1RHOB = *blanks                                           PNL015
     C                   Movel     'N'           #1RHOB                                       PNL015
     C                   Endif                                                                PNL015
      * Route via Head Office must be Y or N                                                  PNL015
     C                   If        #1RHOB <> 'N' and #1RHOB <> 'Y'                            PNL015
      *                                                                                       PNL015
     C                   MOVEL     'PR23003'     ZAMSID                                       PNL015
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL015
     C                   EXSR      ZASNMS                                                     PNL015
     C                   MOVEL     '1'           @I1(54)                                      PNL015
     C                   Movel     'Y'           W0DCF                                        PNL015
     C                   Endif                                                                PNL015
      * Serial OUR default is no
     C                   If        #1SOUR = *blanks
     C                   Movel     'N'           #1SOUR
     C                   Endif
      * Serial OUR must be Yes or No
     C                   If        #1SOUR <> 'N' and #1SOUR <> 'Y'
      *
     C                   MOVEL     'PR10167'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(50)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Status must be A or S (Active or suspended
     C                   If        #1STAT <> 'A' and #1STAT <> 'S'
      * Send message 'Cheque receipt date is mandatory'
     C                   MOVEL     'PR10060'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(40)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
      * Status may not be blank
     C                   If        #1STAT = *blanks
      * Send message 'Error and default
     C                   MOVEL     'PR10059'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(40)
     C                   Movel     'Y'           W0DCF
     C                   Movel     'A'           #1STAT
     C                   Endif
      * Status must be A or S (Active or suspended
     C                   If        #1STAT <> 'A' and #1STAT <> 'S'
      * Send message 'Cheque receipt date is mandatory'
     C                   MOVEL     'PR10060'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(40)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
      * Validate Start date
      *
     C                   Eval      #1STDT = 0
     C                   If        #1STDTA <> *blanks                           Date entered
      *
      *  Check that date is numeric
      *
     C     Digits        Check     #1STDTA       ##005N            5 0    90
      *
      *  Convert date to Midas Day no.
      *
     C                   If        *In90 = *Off                                 Valid date
     C                   Movel     #1STDTA       W2DATE
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD                         Return code
     C                   PARM                    W2DATE            6 0          Date
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   ELse
     C                   Eval      P@RTCD = '*NUM'
     C                   Endif
      *
     C                   If        P@RTCD <> *Blanks
      * Send message '*No data to display'
     C                   MOVEL     'PR10068'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(41)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Else
     C                   Eval      #1STDT = W2DAYN
     C                   Endif
     C                   Endif
      *
      * Validate End date
      *
     C                   Eval      #1ENDT = 0
     C                   If        #1ENDTA <> *blanks                           Date entered
      *
      *  Check that date is numeric
      *
     C     Digits        Check     #1ENDTA       ##005N            5 0    90
      *
      *  Convert date to Midas Day no.
      *
     C                   If        *In90 = *Off                                 Valid date
     C                   Movel     #1ENDTA       W2DATE
     C                   CALL      'ZDATE1'                             90
     C                   PARM      *BLANKS       P@RTCD                         Return code
     C                   PARM                    W2DATE            6 0          Date
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   ELse
     C                   Eval      P@RTCD = '*NUM'
     C                   Endif
      *
     C                   If        P@RTCD <> *Blanks
      * Send message '*No data to display'
     C                   MOVEL     'PR10069'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(42)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Else
     C                   Eval      #1ENDT = W2DAYN
     C                   Endif
     C                   Endif
                                                                                              PNL014
      * Time sensitive payment checking                                                       PNL014
                                                                                              PNL014
     C                   Eval      #1TSCT = -1                                                PNL014
      * Cut off Time                                                                          PNL014
      * Must be a valid time 00:00 to 23:59                                                   PNL014
     C                   If        #1TSCTA <> *blanks                                         PNL014
      *                                                                                       PNL014
      *  Check that date is numeric                                                           PNL014
                                                                                              PNL014
     C     Digits        Check     #1TSCTA       ##005N                   90                  PNL014
      *                                                                                       PNL014
      *  If numeric then check hours and minutes                                              PNL014
      *                                                                                       PNL014
     C                   Select                                                               PNL014
     C                   When      *In90 = *Off                                 Valid time?   PNL014
     C                   Movel     #1TSCTA       ##002n1           2 0                        PNL014
     C                   Move      #1TSCTA       ##002n2           2 0                        PNL014
                                                                                              PNL014
     C                   If        ##002n1 > 23 or                              Valid time?   PNL014
     C                             ##002n2 > 59                                 Valid time?   PNL014
     C                   MOVEL     'PR23007'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(55)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Else                                                                 PNL014
     C                   Move      #1TSCTA       #1TSCT                                       PNL014
     C                   Endif                                                                PNL014
     C                   Other                                                                PNL014
     C                   MOVEL     'PR23007'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(55)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endsl                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   Eval      #1TSCD = -1                                                PNL014
      * Cut off Days adjustment                                                               PNL014
     C                   If        #1TSCDA <> *blanks                                         PNL014
      *                                                                                       PNL014
      *  Check that date is numeric                                                           PNL014
                                                                                              PNL014
     C     Digits        Check     #1TSCDA       ##005N                   90                  PNL014
      *                                                                                       PNL014
      *  If numeric then check hours and minutes                                              PNL014
      *                                                                                       PNL014
     C                   Select                                                               PNL014
     C                   When      *In90 = *Off                                 Valid time?   PNL014
     C                   Movel     #1TSCDA       ##002n1           2 0                        PNL014
                                                                                              PNL014
     C                   If        ##002n1 > 10 or ##002n1 < 1                  Valid time?   PNL014
     C                   MOVEL     'PR23008'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(56)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Else                                                                 PNL014
     C                   Move      #1TSCDA       #1TSCD                                       PNL014
     C                   Endif                                                                PNL014
     C                   Other                                                                PNL014
     C                   MOVEL     'PR23008'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(56)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endsl                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
      * Cut off Time Check                                                                    PNL014
      * Check must be T for time, C for calculate or blanks                                   PNL014
     C                   If        #1TSCK <> 'T' and #1TSCK <> 'C'                            PNL014
     C                             and #1TSCK <> ' '                                          PNL014
      *                                                                                       PNL014
     C                   MOVEL     'PR23004'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(57)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
      * Fail condition                                                                        PNL014
      * Default is continue                                                                   PNL014
     C                   If        #1TSFC = *blanks and #1TsCk <> *blanks                     PNL014
     C                   Eval      #1TSFC = 'C'                                               PNL014
     C                   Endif                                                                PNL014
      * Check must be S for stop, C for calculate or blanks                                   PNL014
     C                   If        #1TSFC <> 'S' and #1TSFC <> 'C'                            PNL014
     C                             and #1TSFC <> ' '                                          PNL014
      *                                                                                       PNL014
     C                   MOVEL     'PR23005'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(58)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
      * Second Iteration                                                                      PNL014
      * Default is no                                                                         PNL014
     C                   Select                                                               PNL014
     C                   When      #1TSIS = *blanks and ICTSDS <> *blanks                     PNL014
     C                   Eval      #1TSIS = ICTSDS                                            PNL014
     C                   When      #1TSIS = *blanks and ICTSDS = *blanks                      PNL014
     C                   Eval      #1TSIS = 'YNNNNNNNNNN'                                     PNL014
     C                   Endsl                                                                PNL014
      * Check must be Y or N                                                                  PNL014
     C     'NY'          Check     #1TSIS        ##005N            5 0    90                  PNL014
     C                   If        *In90 = *On                                  Valid date    PNL014
      *                                                                                       PNL014
     C                   MOVEL     'PR23006'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(59)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Else                                                                 PNL014
      * If Ok then Y flag must not be greater iteration number                                PNL014
     C     'N'           Checkr    #1TSIS        ##005N            5 0    90                  PNL014
     C                   If        *In90 = *On and ##005N > ICTSNI                            PNL014
      *                                                                                       PNL014
     C                   MOVEL     'PR23012'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   If        ##005N > 10                                                PNL014
     C                   Eval      ZAMSDA = %Char(##005N)                                     PNL014
     C                                    + %Char(IcTsNi)                                     PNL014
     C                   Else                                                                 PNL014
     C                   Eval      ZAMSDA = ' ' + %Char(##005N)                               PNL014
     C                                    + %Char(IcTsNi)                                     PNL014
     C                   Endif                                                                PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(59)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endif                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
                                                                                              PNL014
     C                   If        #1TSHC <> *blanks                                          PNL014
      * Get currency details                                                                  PNL014
      *                                                                                       PNL014
     C                   CALL      'AOCURRR0'                           9090                  PNL014
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code PNL014
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option      PNL014
     C                   PARM      #1TSHC        P@CCY             3            I:Currency    PNL014
     C     DSCURR        PARM      *BLANKS       DSSDY                                        PNL014
      *                                                                                       PNL014
     C                   If        P@RTCD <> *blanks                                          PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(61)                                      PNL014
      *                                                                                       PNL014
     C                   MOVEL     'PR10088'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   MOVEL     #1TSHC        ZAMSDA                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   Else                                                                 PNL014
      * If return is different and ? then fill                                                PNL014
     C     '?'           Scan      #1TSHC                                 90                  PNL014
     C                   If        *In90 = *On                                                PNL014
     C                   Eval      #1TSHC = A6CYCD                                            PNL014
     C                   Eval      *In99 = *On                                                PNL014
     C                   Endif                                                  FI            PNL014
     C                   Endif                                                  FI            PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        #1TSHL <> *blanks                                          PNL014
      * Get currency details                                                                  PNL014
      *                                                                                       PNL014
     C                   CALL      'AOLOCNR0'                           9090                  PNL014
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code PNL014
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option      PNL014
     C                   PARM      #1TSHL        P@LOCN            3            I:Location    PNL014
     C     SDLOCN        PARM      *BLANKS       DSSDY                                        PNL014
      *                                                                                       PNL014
     C                   If        P@RTCD <> *blanks                                          PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(62)                                      PNL014
      *                                                                                       PNL014
     C                   MOVEL     'PR23016'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   MOVEL     #1TSHL        ZAMSDA                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   Else                                                                 PNL014
      * If return is different and ? then fill                                                PNL014
     C     '?'           Scan      #1TSHL                                 90                  PNL014
     C                   If        *In90 = *On                                                PNL014
     C                   Eval      #1TSHL = DVLCCD                                            PNL014
     C                   Eval      *In99 = *On                                                PNL014
     C                   Endif                                                  FI            PNL014
     C                   Endif                                                  FI            PNL014
     C                   Endif                                                                PNL014
      *
     C     EXSCR1        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRSCR2   : Validate Screen 2                                 *
      *                                                               *
      *================================================================
     CSR   SRSCR2        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSCR2'      @STK(Q)
      *
      * Validate percentage
     C                   Eval      #1SCHR = 0
      *
     C                   If        #1SCHRA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1SCHRA       ZFIELD
     C                   Eval      Zadig = 9
     C                   Eval      Zadec = 6
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(35)
      * Send message '*Value required'
     C                   MOVEL     'PR10076'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        W3FLD15
     C                   Move      ZFIELD        #1SCHR
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      6             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:7     #1SCHRA
      *
     C     #1SCHR        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(35)
      * Send message '*Value required'
     C                   MOVEL     'PR10077'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI

      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     DSCURR        PARM      *BLANKS       DSSDY
      *
      * Validate minimum fee
     C                   Eval      #1SCHL = 0
      *
     C                   If        #1SCHLA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1SCHLA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(36)
      * Send message '*Value required'
     C                   MOVEL     'PR10071'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1SCHL
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SCHL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1SCHLA
      *
     C     #1SCHL        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(36)
      * Send message '*Value required'
     C                   MOVEL     'PR10072'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate maximum fee
     C                   Eval      #1SCHH = 0
      *
     C                   If        #1SCHHA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1SCHHA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(37)
      * Send message '*Value required'
     C                   MOVEL     'PR10073'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1SCHH
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SCHH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1SCHHA
      * Cheque amount must be greater than0
     C     #1SCHH        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(37)
      * Send message '*Value required'
     C                   MOVEL     'PR10072'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      * Charge code validation
     C                   If        #1SCHC <> *blanks
     C     KPchgl1       Klist
     C                   Kfld                    PYCHCD
      *
     C                   Eval      PYCHCD = #1SCHC
     C     KPchgl1       Chain     FTPCHGD0
     C                   If        Not %Found
      * Send message 'Error and default
     C                   MOVEL     'PR10078'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(38)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
     C                   Endif
      *
      * Default to No for preferential correspondent
     C                   If        #1PCOR = *blanks
     C                   Eval      #1PCOR = 'N'
     C                   Endif
      * Default to No for preferential correspondent
     C                   If        #1PBcr = *blanks
     C                   Eval      #1PBcr = 'N'
     C                   Endif
     C                   If        #1PScr = *blanks
     C                   Eval      #1PScr = 'N'
     C                   Endif
     C                   If        #1POcr = *blanks
     C                   Eval      #1POcr = 'N'
     C                   Endif
      *
     C                   If        #1PCOR <> 'N'
     C                             And #1PCOR <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(43)
      *
     C                   MOVEL     'PR10105'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PBcr <> 'N'
     C                             And #1PBcr <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(40)
      *
     C                   MOVEL     'PR10105'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PBcr        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1Pscr <> 'N'
     C                             And #1Pscr <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(41)
      *
     C                   MOVEL     'PR10105'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1Pscr        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1Pocr <> 'N'
     C                             And #1Pocr <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(42)
      *
     C                   MOVEL     'PR10105'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1Pocr        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PCOR <> 'Y'
     C                             And #1PPCTA <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(43)
     C                   MOVEL     '1'           @I2(44)
      *
     C                   MOVEL     'PR10136'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PCOR <> 'Y'
     C                             And #1PBPTA <> *blanks
     C                             Or
     C                             #1PBcr = 'N'
     C                             And #1PBPTA <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(43)
     C                   MOVEL     '1'           @I2(45)
      *
     C                   MOVEL     'PR10136'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PCOR <> 'Y'
     C                             And #1PsPTA <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(43)
     C                   MOVEL     '1'           @I2(46)
      *
     C                   MOVEL     'PR10136'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PCOR <> 'Y'
     C                             And #1PsPTA <> *blanks
     C                             Or
     C                             #1PScr = 'N'
     C                             And #1PSPTA <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(43)
     C                   MOVEL     '1'           @I2(47)
      *
     C                   MOVEL     'PR10136'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PCOR = 'Y'
     C                             And #1PPCTA = *blanks
     C                             Or
     C                             #1POcr = 'N'
     C                             And #1POPTA <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(43)
     C                   MOVEL     '1'           @I2(44)
      *
     C                   MOVEL     'PR10137'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      * Validate percentage
     C                   Eval      #1PPCT = 0
      *
     C                   If        #1PPCTA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1PPCTA       ZFIELD
     C                   Eval      Zadig = 2
     C                   Eval      Zadec = 0
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(44)
      * Send message '*Value required'
     C                   MOVEL     'PR10138'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        W3FLD15
     C                   Move      ZFIELD        #1Ppct
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PPCTA
      *
     C     #1PPCT        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(44)
      * Send message '*Value required'
     C                   MOVEL     'PR10139'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate percentage
     C                   Eval      #1PBPt = 0
      *
     C                   If        #1PBPtA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1PBPTA       ZFIELD
     C                   Eval      Zadig = 2
     C                   Eval      Zadec = 0
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(45)
      * Send message '*Value required'
     C                   MOVEL     'PR10138'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        W3FLD15
     C                   Move      ZFIELD        #1Pbpt
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PbPTA
      *
     C     #1PBpt        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(45)
      * Send message '*Value required'
     C                   MOVEL     'PR10139'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate percentage
     C                   Eval      #1PsPt = 0
      *
     C                   If        #1PsPtA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1PsPTA       ZFIELD
     C                   Eval      Zadig = 2
     C                   Eval      Zadec = 0
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(46)
      * Send message '*Value required'
     C                   MOVEL     'PR10138'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        W3FLD15
     C                   Move      ZFIELD        #1Pspt
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PsPTA
      *
     C     #1Pspt        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(46)
      * Send message '*Value required'
     C                   MOVEL     'PR10139'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate percentage
     C                   Eval      #1PoPt = 0
      *
     C                   If        #1PoPtA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1PoPTA       ZFIELD
     C                   Eval      Zadig = 2
     C                   Eval      Zadec = 0
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(47)
      * Send message '*Value required'
     C                   MOVEL     'PR10138'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        W3FLD15
     C                   Move      ZFIELD        #1Popt
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PoPTA
      *
     C     #1Popt        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(47)
      * Send message '*Value required'
     C                   MOVEL     'PR10139'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Default to No for preferential correspondent
     C                   If        #1PREG = *blanks
     C                   Eval      #1PREG = 'N'
     C                   Endif
      *
     C                   If        #1PREG <> 'N'
     C                             And #1PREG <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(51)
      *
     C                   MOVEL     'PR10105'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PREG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PREG <> 'Y'
     C                             And #1PRPCA <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(51)
     C                   MOVEL     '1'           @I2(52)
      *
     C                   MOVEL     'PR10136'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PREG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PREG = 'Y'
     C                             And #1PRPCA = *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(51)
     C                   MOVEL     '1'           @I2(52)
      *
     C                   MOVEL     'PR10137'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PREG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      * Validate percentage
     C                   Eval      #1PRPC = 0
      *
     C                   If        #1PRPCA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1PRPCA       ZFIELD
     C                   Eval      Zadig = 2
     C                   Eval      Zadec = 0
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(52)
      * Send message '*Value required'
     C                   MOVEL     'PR10138'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        W3FLD15
     C                   Move      ZFIELD        #1Prpc
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PRPCA
      *
     C     #1PRPC        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(52)
      * Send message '*Value required'
     C                   MOVEL     'PR10139'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Default to No for preferential correspondent
     C                   If        #1PLVP = *blanks
     C                   Eval      #1PLVP = 'N'
     C                   Endif
      *
     C                   If        #1PLVP <> 'N'
     C                             And #1PLVP <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(53)
      *
     C                   MOVEL     'PR10105'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PLVP        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PLVP <> 'Y'
     C                             And #1PLPCA <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(53)
     C                   MOVEL     '1'           @I2(54)
      *
     C                   MOVEL     'PR10136'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PLVP        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1PLVP = 'Y'
     C                             And #1PLPCA = *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(53)
     C                   MOVEL     '1'           @I2(54)
      *
     C                   MOVEL     'PR10137'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PLVP        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      * Validate percentage
     C                   Eval      #1PLPC = 0
      *
     C                   If        #1PLPCA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1PLPCA       ZFIELD
     C                   Eval      Zadig = 2
     C                   Eval      Zadec = 0
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(54)
      * Send message '*Value required'
     C                   MOVEL     'PR10138'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        W3FLD15
     C                   Move      ZFIELD        #1Plpc
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PLPCA
      *
     C     #1PLPC        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(54)
      * Send message '*Value required'
     C                   MOVEL     'PR10139'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      *  Unwind subroutine stack name
      *
     C     EXSCR2        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRSCR3   : Validate Screen 3                                 *
      *                                                               *
      *================================================================
     CSR   SRSCR3        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSCR3'      @STK(Q)
      * Apply BEN ?  default to Y
     C                   If        #1BENR = *blanks
     C                   Movel     'Y'           #1BENR
     C                   Endif
      * Apply BEN ? must be Yes or No
     C                   If        #1BENR <> 'N' and #1BENR <> 'Y'
      *
     C                   MOVEL     'PR10172'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(34)
     C                   Movel     'Y'           W0DCF
     C                   Endif

      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     DSCURR        PARM      *BLANKS       DSSDY
      *
      * Validate minimum value
     C                   Eval      #1BENL = 0
      *
     C                   If        #1BENLA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1BENLA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(35)
      * Send message '*Value required'
     C                   MOVEL     'PR10178'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1BENL
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1BENL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1BENLA
      *
     C     #1BENL        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(35)
      * Send message '*Value required'
     C                   MOVEL     'PR10174'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate maximum fee
     C                   Eval      #1BENH = 0
      *
     C                   If        #1BENHA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1BENHA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(36)
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1BENH
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1BENH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1BENHA
      * Cheque amount must be greater than0
     C     #1BENH        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(36)
      * Send message '*Value required'
     C                   MOVEL     'PR10177'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      * Apply SHA ?  default to Y
     C                   If        #1SHAR = *blanks
     C                   Movel     'Y'           #1SHAR
     C                   Endif
      * Apply SHA ? must be Yes or No
     C                   If        #1SHAR <> 'N' and #1SHAR <> 'Y'
      *
     C                   MOVEL     'PR10173'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(37)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Apply OUR ?  default to Y
     C                   If        #1OURR = *blanks
     C                   Movel     'Y'           #1OurR
     C                   Endif
      * Apply OUR ? must be Yes or No
     C                   If        #1OURR <> 'N' and #1OURR <> 'Y'
      *
     C                   MOVEL     'PR10174'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(40)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Validate minimum value
     C                   Eval      #1ShaL = 0
      *
     C                   If        #1ShaLA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1ShaLA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(38)
      * Send message '*Value required'
     C                   MOVEL     'PR10178'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1ShaL
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1ShaL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1ShaLA
      *
     C     #1ShaL        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(38)
      * Send message '*Value required'
     C                   MOVEL     'PR10174'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate maximum fee
     C                   Eval      #1ShaH = 0
      *
     C                   If        #1ShaHA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1ShaHA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(39)
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1ShaH
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1ShaH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1ShaHA
      * Cheque amount must be greater than0
     C     #1ShaH        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(39)
      * Send message '*Value required'
     C                   MOVEL     'PR10177'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      * Validate minimum value
     C                   Eval      #1OurL = 0
      *
     C                   If        #1OurLA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1OurLA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(41)
      * Send message '*Value required'
     C                   MOVEL     'PR10178'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1OurL
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1OurL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1OurLA
      *
     C     #1OurL        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(41)
      * Send message '*Value required'
     C                   MOVEL     'PR10174'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate maximum fee
     C                   Eval      #1OurH = 0
      *
     C                   If        #1OurHA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1OurHA       ZFIELD
     C                   Eval      Zadig = 15 - A6NBDP
     C                   Eval      Zadec = A6NBDP
      *
     C                   CALL      'ZALIGN'                               90
     C                   Parm      *blanks       ZRTN              7            B:Return Code
     C                   Parm                    ZFIELD           16            B:Check Field
     C                   Parm                    ZADEC             1 0          I:No Of Decs
     C                   Parm                    ZADIG             2 0          I:No Of Digits
     C                   Parm      *blanks       ZAFLD            16            O:Check Field
      * If error set on indicator
     C                   If        Zrtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(42)
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1OurH
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1OurH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1OurHA
      * Cheque amount must be greater than0
     C     #1OurH        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(42)
      * Send message '*Value required'
     C                   MOVEL     'PR10177'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      *  Unwind subroutine stack name
      *
     C     EXSCR3        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRXVAL2  : Validate Cross Validations                        *
      *                                                               *
      *================================================================
     CSR   SRXVAL2       BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRXVAL2'     @STK(Q)

      * Minimum fee must not be greater than maximum
     C                   If        #1Schl <> 0 and #1Schh <> 0
     C                             and #1Schl > #1Schh
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(36)
     C                   MOVEL     '1'           @I2(37)
      * Send message '*Value required'
     C                   MOVEL     'PR10075'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

      * If charge code then other fields must be blank
     C                   If        #1Schc <> *blanks
     C                   If        #1Schr <> 0
     C                             or  #1Schl <> 0
     C                             or  #1Schh <> 0
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(35)
     C                   MOVEL     '1'           @I2(36)
     C                   MOVEL     '1'           @I2(37)
     C                   MOVEL     '1'           @I2(38)
      * Send message '*Value required'
     C                   MOVEL     'PR10079'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI

      *
      *  Unwind subroutine stack name
      *
     C     EXXVAL2       TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRXVAL3  : Validate Cross Validations                        *
      *                                                               *
      *================================================================
     CSR   SRXVAL3       BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRXVAL3'     @STK(Q)


      * Minimum value must not be greater than maximum
     C                   If        #1Benl <> 0 and #1Benh <> 0
     C                             and #1Benl > #1Benh
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(35)
     C                   MOVEL     '1'           @I3(36)
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

      * Minimum value must not be greater than maximum
     C                   If        #1Shal <> 0 and #1Shah <> 0
     C                             and #1Shal > #1Shah
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(38)
     C                   MOVEL     '1'           @I3(39)
      * Send message '*Value required'
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

      * Minimum value must not be greater than maximum
     C                   If        #1Ourl <> 0 and #1Ourh <> 0
     C                             and #1Ourl > #1Ourh
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(41)
     C                   MOVEL     '1'           @I3(42)
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
                                                                                              PNL014
      * Time sensitive payment checking                                                       PNL014
                                                                                              PNL014
      * Time check is C                                                                       PNL014
                                                                                              PNL014
     C                   If        #1TSCK = 'C'                                               PNL014
     C                   If        #1STMT = '01'                                              PNL014
     C                             or #1STMT = '08'                                           PNL014
     C                   MOVEL     'PR23014'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(57)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endif                                                                PNL014
     C                   Endif                                                                PNL014
      *
      *  Unwind subroutine stack name
      *
     C     EXXVAL3       TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRAccount: Validate Account                                  *
      *                                                               *
      *================================================================
     CSR   SRAccount     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRAccount'   @STK(Q)
      *
      * Check for IBAN account
      *
     C                   Call      'AOIBANR4'
     C                   PARM      *blanks       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      W0Account     P@IBAN           34            I:Retail key
     C     ACCNT         PARM      *blanks       DSSDY                          O:OUTPUT
      *
     C                   If        P@RTCD = *blanks and ACRECI = 'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
      *
     C     29            SUBST     W0Account:6   ##0029a          29
      *
     C     24            SUBST     W0Account:11  ##0024a          24
      *
     C     16            SUBST     W0Account:19  ##0016a          16
      * Setup key
     C                   select
     C                   When      ##0029a = *blanks
      *
     C     3             Subst     W0Account:1   P@CYCD
     C     2             Subst     W0Account:4   P@NONB
      *
     C                   Call      'AONOSTR0'
     C                   PARM      *Blanks       P@RTCD            7            B:Return code
     C                   PARM      '*KEY'        P@OPTN            7            I:Option
     C                   PARM      *blanks       P@CUST            6            I:Customer No
     C                   PARM                    P@CYCD            3            I:Currency
     C*****              PARM      *blanks       P@ACCD            4            I:A/c Code  AR856737
     C                   PARM      *blanks       P@ACCD           10            I:A/c Code  AR856737
     C                   PARM      *blanks       P@ACSN            2            I:A/c Seq
     C                   PARM                    P@NONB            2            I:Nostro No
     C                   PARM      *blanks       P@BRCD            3            I:Branch Code
     C                   PARM      *blanks       P@CSSN           10            I:Cust ShortN
     C                   PARM      *blanks       P@PNOI            1            I:Prime Nost In
     C     SDNOST        PARM                    DSSDY                          O:Format
      *
     C                   If        P@RTCD = *blanks
     C                   Movel     A7Cust        P@CNUM
     C                   Movel     A7cycd        P@CUCD
     C                   Movel     A7Accd        P@ACCD
     C                   Movel     A7Acsn        P@ACSQ
     C                   Movel     A7Brcd        P@BRCA
      *
      *  Call to access pgm for Accounts
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      *blanks       P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C*****              PARM                    P@ACCD            4          I:Key field 3 AR856737
     C                   PARM                    P@ACCD                         I:Key field AR856737
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     ACReci        Andeq     'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Else
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   When      ##0024a = *blanks
     C     10            SUBST     W0Account:1   P@Retl
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@RETL           10            I:Retail key
     C                   PARM      *blanks       P@CNUM            6            I:Key field 1
     C                   PARM      *blanks       P@CUCD            3            I:Key field 2
     C*****              PARM      *blanks       P@ACCD            4          I:Key field 3 AR856737
     C                   PARM      *blanks       P@ACCD                         I:Key field AR856737
     C                   PARM      *blanks       P@ACSQ            2            I:Key field 4
     C                   PARM      *blanks       P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     ACReci        Andeq     'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   When      ##0016a = *blanks
     C     6             SUBST     W0Account:1   P@CNUM
     C     3             SUBST     W0Account:7   P@CUCD
     C     4             SUBST     W0Account:10  P@ACCD
     C     2             SUBST     W0Account:14  P@ACSQ
     C     3             SUBST     W0Account:16  P@BRCA
      *
      *  Call to access pgm for Accounts
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      *blanks       P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C*****              PARM                    P@ACCD            4          I:Key field 3 AR856737
     C                   PARM                    P@ACCD                         I:Key field AR856737
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     ACReci        Andeq     'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Other
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endsl

     C                   Endif

      * Account currency must equal payment currency
     C                   If        W0Ccy <> #1PCCY
      * Send message 'Invalid account'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)
     C                   MOVEL     'PR10081'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Ccy         ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      *  If account them get customer SWIFT Address
      *
     C                   If        W0Brca <> *blanks

     C                   Movel(p)  W0Cnum        P@Key1

     C                   Call      'AOCUSTR0'
     C                   PARM      *blanks       P@RTCD            7            B:Return code
     C                   PARM      '*KEY'        P@OPTN            7            I:Option
     C                   PARM                    P@KEY1           10            I:Key field
     C                   PARM                    P@KYST            7            O:Key status
     C     SDCUST        PARM                    DSSDY                          O:Format
      *
     C                   If        P@Rtcd = *blanks                                        e
     C                   Eval      #1C53c = %subst(BBCSID:1:8)
     C                   Eval      #1C53b = %subst(BBCSID:9:3)
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *================================================================
      *
      *  Unwind subroutine stack name
      *
     C     EXAccount     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR

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

      *  Check for specific routing for Pay Through

      * If branch is blank then set default

     C                   If        #1CBic <> 'SERVICES'
     C                   Select
     C                   When      O2Brca = *blanks  and IcDbrc = *blanks
     C                   Eval      O2Brca = 'MBB'
     C                   Other
     C                   Eval      O2Brca = ICDBrc
     C                   Endsl

     C                   Eval      O2type = 'S'
     C                   Eval      O2SBicc = #1CBic
     C                   Eval      O2SBicb = #1CBib
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   If        O2Rtn <> *blanks  and #1C53a <> *blanks
     C                   MOVEL     'PR10147'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(31)
     C                   MOVEL     '1'           @I1(32)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
     C                   Endif
      *
      * Cover required can only be Y if sender entered
     C                   If        #1C53R = 'Y' and #1C53A = *blanks
      * Send message '*No data to display'
     C                   MOVEL     'PR10082'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(31)
     C                   MOVEL     '1'           @I1(32)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
      * Start date must be before end date
     C                   If        #1STDT <> 0 and #1ENDT <> 0 and
     C                             #1STDT > #1ENDT
      * Send message '*No data to display'
     C                   MOVEL     'PR10070'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(41)
     C                   MOVEL     '1'           @I1(42)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif

      * Define key
     C     KMsccv1       Klist
     C                   Kfld                    McBICC
     C                   Kfld                    McBICB
     C                   Kfld                    McPCCY

     C                   Eval      McBICC = #1CBIC
     C                   Eval      McBICB = #1CBIB
     C                   Eval      McPCCY = #1PCCY
      * Get data
     C     KMsccv1       Chain     @Msccv1
      *

      * If generic
     C                   If        %subst(#1BICC:1:4) = '????'                  FI
     C                             Or
     C                             %subst(#1BICC:5:2) = '??'
     C                             Or
     C                             %subst(#1BICC:7:2) = '??'
     C                             Or
     C                             #1BICB = '???'
     C                   If        %Found and McCtyp <> 'ACCOUNT'
     C                             and O2Rtn <> *blanks
     C                             or
     C                             %Found and McCtyp <> 'ACCOUNT'
     C                             and O2Rtn = *blanks
     C                             and #1C53a = *blanks
     C                             or
     C                             Not %Found and O2Rtn <> *blanks
     C                             and #1C53a = *blanks
     C                             or
     C                             Not %Found and O2Rtn = *blanks
     C                             and #1C53a = *blanks
     C                   MOVEL     'PR10171'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(31)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
     C                   Endif

      * Check for account correspondent
     C                   If        #1SERP = 'Y'
     C                             or #1SReg = 'Y'
     C                             or #1SOur = 'Y'
     C                             or #1SLvp = 'Y'

     C                   If        %Found and McCtyp <> 'ACCOUNT'
     C                             or Not %Found
      *
     C                   SETON                                        99        *
     C                   If        #1SERP = 'Y'
     C                   MOVEL     '1'           @I1(47)
     C                   Endif                                                  FI
     C                   If        #1SReg = 'Y'
     C                   MOVEL     '1'           @I1(49)
     C                   Endif                                                  FI
     C                   If        #1SOur = 'Y'
     C                   MOVEL     '1'           @I1(50)
     C                   Endif                                                  FI
     C                   If        #1SLvp = 'Y'
     C                   MOVEL     '1'           @I1(48)
     C                   Endif                                                  FI
      *
     C                   MOVEL     'PR10129'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

     C                   Endif                                                  FI

      * Check for Regulated Payment
     C                   If        Not %Found and #1Preg = 'Y'
     C                             Or
     C                             Not %Found and #1SReg = 'Y'
     C                             Or
     C                             %Found and
     C                             #1SReg = 'Y' and McRegP <> 'Y'
     C                             Or
     C                             %Found and
     C                             #1PReg = 'Y' and McRegP <> 'Y'
     C                   If        #1SReg = 'Y'
     C                   MOVEL     '1'           @I1(49)
     C                   Endif                                                  FI
     C                   If        #1PReg = 'Y'
     C                   MOVEL     '1'           @I2(51)
     C                   Endif                                                  FI
     C                   SETON                                        99        *
      *
     C                   MOVEL     'PR10170'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

      * Check for LVP
     C                   If        Not %Found and #1PLvp = 'Y'
     C                             Or
     C                             Not %Found and #1SLvp = 'Y'
     C                             Or
     C                             %Found and
     C                             #1SLvp = 'Y' and McLvpa <> 'Y'
     C                             Or
     C                             %Found and
     C                             #1PLvp = 'Y' and McLvpa <> 'Y'
     C                   SETON                                        99        *
     C                   If        #1SLvp = 'Y'
     C                   MOVEL     '1'           @I1(48)
     C                   Endif                                                  FI
     C                   If        #1PLvp = 'Y'
     C                   MOVEL     '1'           @I2(53)
     C                   Endif                                                  FI
      *
     C                   MOVEL     'PR10169'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

     C                   Eval      McBICC = #1BICC
     C                   Eval      McBICB = #1BICB
     C                   Eval      McPCCY = #1PCCY
      * Get data
     C     KMsccv1       Chain     @Msccv1
      * Check for consistency of fields

      * If peferential then must be on correspondent
     C                   If        Not %Found and #1Pcor = 'Y'
     C                             Or
     C                             %Found and
     C                             McPcor <> 'Y' and #1Pcor = 'Y'
      *
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(43)
     C                   MOVEL     'PR10168'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

      * If peferential then must be on correspondent
     C                   If        Not %Found and #1Preg = 'Y'
     C                             Or
     C                             %Found and
     C                             McPcor <> 'Y' and #1Preg = 'Y'
      *
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(51)
     C                   MOVEL     'PR10168'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

      * If peferential then must be on correspondent
     C                   If        Not %Found and #1Plvp = 'Y'
     C                             Or
     C                             %Found and
     C                             McPcor <> 'Y' and #1Plvp = 'Y'
      *
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(53)
     C                   MOVEL     'PR10168'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI

      * Check for account correspondent
     C                   If        #1SERP = 'Y' and #1C53r = 'Y'
     C                             or
     C                             #1SERP = 'Y' and #1C53a <> *blanks
      *
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(47)
     C                   MOVEL     'PR10150'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
                                                                                              PNL014
      * Time sensitive payment checking                                                       PNL014
                                                                                              PNL014
      * Time fields only if check being applied                                               PNL014
                                                                                              PNL014
     C                   If        #1TSCK = *blanks                                           PNL014
     C                   If        #1TSCTA <> *blanks                                         PNL014
     C                             or #1TsCda <> *blanks                                      PNL014
     C                             or #1TsFc  <> *blanks                                      PNL014
     C                   MOVEL     'PR23009'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(57)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endif                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
      * Time fields mandatory if T                                                            PNL014
                                                                                              PNL014
     C                   If        #1TSCK = 'T'                                               PNL014
     C                   If        #1TSCTA =  *blanks                                         PNL014
     C                   MOVEL     'PR23010'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   If        #1TSCTA = *blanks                                          PNL014
     C                   MOVEL     '1'           @I1(55)                                      PNL014
     C                   Endif                                                                PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endif                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
      * Cut days only if time non-blanks                                                      PNL014
                                                                                              PNL014
     C                   If        #1TSCTA = *blanks and #1TSCDA <> *blanks                   PNL014
     C                   MOVEL     'PR23011'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   MOVEL     '1'           @I1(56)                                      PNL014
     C                   SETON                                        99        *             PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endif                                                                PNL014
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
     C     P2CBIC        IFEQ      *BLANK
     C     P2CBIB        OREQ      *BLANK
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
     C****               Clear                   #1CBIC
     C****               Clear                   #1CBIB
     C                   Clear                   #1RCAU
     C                   Clear                   #1RCAC
     C                   Clear                   #1C53C
     C                   Clear                   #1C53B
     C                   Clear                   #1C53A
     C                   Clear                   #1C53R
     C                   Clear                   #1R910
     C                   Clear                   #1STMT
     C                   Clear                   #1SERP
     C                   Clear                   #1SLVP
     C                   Clear                   #1SREG
     C                   Clear                   #1FBIC
     C                   Clear                   #1RHOB                                       PNL015
     C                   Clear                   #1SOUR
     C                   Clear                   #1C54C
     C                   Clear                   #1C54B
     C                   Clear                   #1C56C
     C                   Clear                   #1C56B
     C                   Clear                   #1SCHR
     C                   Clear                   #1SCHL
     C                   Clear                   #1SCHH
     C                   Clear                   #1SCHC
     C                   Clear                   #1DES1
     C                   Clear                   #1DES2
     C                   Clear                   #1DES3
     C                   Clear                   #1PCOR
     C                   Clear                   #1PBcr
     C                   Clear                   #1PScr
     C                   Clear                   #1POcr
     C                   Clear                   #1PPCT
     C                   Clear                   #1PNBR
     C                   Clear                   #1PPCTA
     C                   Clear                   #1PNBRA
     C                   Clear                   #1PBPTA
     C                   Clear                   #1PBNBA
     C                   Clear                   #1PSPTA
     C                   Clear                   #1PSNBA
     C                   Clear                   #1POPTA
     C                   Clear                   #1PONBA
     C                   Clear                   #1PREG
     C                   Clear                   #1PRPC
     C                   Clear                   #1PRNB
     C                   Clear                   #1PRPCA
     C                   Clear                   #1PRNBA
     C                   Clear                   #1PLVP
     C                   Clear                   #1PLPC
     C                   Clear                   #1PLNB
     C                   Clear                   #1PLPCA
     C                   Clear                   #1PLNBA
     C                   Clear                   #1STAT
     C                   Clear                   #1STDT
     C                   Clear                   #1ENDT
      *---------------------------------------------------------------------
     C                   Clear                   #1BENR
     C                   Clear                   #1BENL
     C                   Clear                   #1BENH
     C                   Clear                   #1SHAR
     C                   Clear                   #1SHAL
     C                   Clear                   #1SHAH
     C                   Clear                   #1OURR
     C                   Clear                   #1OURL
     C                   Clear                   #1OURH

     C                   Clear                   #1BENLA
     C                   Clear                   #1BENHA
     C                   Clear                   #1SHALA
     C                   Clear                   #1SHAHA
     C                   Clear                   #1OURLA
     C                   Clear                   #1OURHA

      *---------------------------------------------------------------------
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Clear                   #1RTSQ                                       PNL014
     C                   Clear                   #1TSDO                                       PNL014
     C                   Clear                   #1TSCT                                       PNL014
     C                   Clear                   #1TSCD                                       PNL014
     C                   Clear                   #1TSCTA                                      PNL014
     C                   Clear                   #1TSCDA                                      PNL014
     C                   Clear                   #1TSCK                                       PNL014
     C                   Clear                   #1TSFC                                       PNL014
     C                   Clear                   #1TSIS                                       PNL014
     C                   Clear                   #1TSHC                                       PNL014
     C                   Clear                   #1TSHL                                       PNL014
     C                   Clear                   #1RREF                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
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
     C                   PARM      'PR10062'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
      * Function keys
      *
     C                   MOVEL     'PR10090'     ##PG1
     C                   MOVEL     'PR10091'     ##PG2
     C                   MOVEL     'PR10092'     ##PG3
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10061'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
      *
      * Function keys
      *
     C                   MOVEL     'PR10090'     ##PG1
     C                   MOVEL     'PR10091'     ##PG2
     C                   MOVEL     'PR10092'     ##PG3
      *
      *
      * Amendment screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10063'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
      *
      * Function keys
      *
     C                   MOVEL     'PR10090'     ##PG1
     C                   MOVEL     'PR10091'     ##PG2
     C                   MOVEL     'PR10092'     ##PG3
      *
      *
      * Delete screen
      *
     C     P1ACTC        WHENEQ    'D'
      *
      * Option Name
     C                   Movel     'PR10064'     #MSGID
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
      *
      * Function keys and allow delete key
      *
     C                   MOVEL     'PR10095'     ##PG1
     C                   MOVEL     'PR10096'     ##PG2
     C                   MOVEL     'PR10097'     ##PG3
     C                   MOVEL     '1'           *IN77
      *
     C                   ENDSL
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       #ACMD1
     C                   MOVEL     *BLANKS       #BCMD1
     C                   MOVEL     *BLANKS       #CCMD1
      *
      * Function keys page 1
      *
     C     *LIKE         DEFINE    #MSGID        ##PG1
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      ##PG1         #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
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
     C                   CALL      'MEC1150'                            9090
     C                   PARM      ##PG2         #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #BCMD2
      *
      * Function keys page 3
      *
     C     *LIKE         DEFINE    #MSGID        ##PG3
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      ##PG3         #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #CCMD2
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
      * Move @MSCPV1 fields to screen
      *================================================================

     C                   MOVEL     MPBICC        #1BICC
     C                   MOVEL     MPBICB        #1BICB
     C                   MOVEL     *BLANKS       #1INS1
     C                   MOVEL     *BLANKS       #1INT1

     C                   EVAL      #1PCCY    =   MPPCCY

     C                   EVAL      #1RECI    =   MPRECI

     C                   EVAL      #1CBIC    =   MPCBIC
     C                   EVAL      #1CBIB    =   MPCBIB
     C                   EVAL      #1RCAU    =   MPRCAU
     C                   EVAL      #1RCAC    =   MPRCAC
     C                   EVAL      #1C53C    =   MPC53C
     C                   EVAL      #1C53B    =   MPC53B
     C                   EVAL      #1C53A    =   MPC53A
     C                   EVAL      #1C53R    =   MPC53R
     C                   EVAL      #1R910    =   MPR910
     C                   EVAL      #1STMT    =   MPSTMT
     C                   EVAL      #1SERP    =   MPSERP
     C                   EVAL      #1SLVP    =   MPSLVP
     C                   EVAL      #1SREG    =   MPSREG
     C                   EVAL      #1FBIC    =   MPFBIC
     C                   EVAL      #1RHOB    =   MPRHOB                                       PNL015
     C                   EVAL      #1SOUR    =   MPSOUR
     C                   EVAL      #1C54C    =   MPC54C
     C                   EVAL      #1C54B    =   MPC54B
     C                   EVAL      #1C56C    =   MPC56C
     C                   EVAL      #1C56B    =   MPC56B
     C                   EVAL      #1SCHR    =   MPSCHR
     C                   EVAL      #1SCHL    =   MPSCHL
     C                   EVAL      #1SCHH    =   MPSCHH
     C                   EVAL      #1SCHC    =   MPSCHC
     C                   EVAL      #1DES1    =   MPDES1
     C                   EVAL      #1DES2    =   MPDES2
     C                   EVAL      #1DES3    =   MPDES3
     C                   EVAL      #1STAT    =   MPSTAT
     C                   EVAL      #1PCOR    =   MPPCOR
     C                   EVAL      #1Pbcr    =   MPPbcr
     C                   EVAL      #1Pscr    =   MPPscr
     C                   EVAL      #1Pocr    =   MPPocr
     C                   EVAL      #1PPCT    =   MPPPCT
     C                   EVAL      #1PNBR    =   MPPNBR
     C                   EVAL      #1PBPT    =   MPPBPT
     C                   EVAL      #1PBNB    =   MPPBNB
     C                   EVAL      #1PSPT    =   MPPSPT
     C                   EVAL      #1PSNB    =   MPPSNB
     C                   EVAL      #1POPT    =   MPPOPT
     C                   EVAL      #1PONB    =   MPPONB
     C                   EVAL      #1PREG    =   MPPREG
     C                   EVAL      #1PRPC    =   MPPRPC
     C                   EVAL      #1PRNB    =   MPPRNB
     C                   EVAL      #1PLVP    =   MPPLVP
     C                   EVAL      #1PLPC    =   MPPLPC
     C                   EVAL      #1PLNB    =   MPPLNB
     C                   EVAL      #1STDT    =   MPSTDT
     C                   EVAL      #1ENDT    =   MPENDT
      *---------------------------------------------------------------------
     C                   Eval      #1BENR    =   MPBENR
     C                   Eval      #1BENL    =   MPBENL
     C                   Eval      #1BENH    =   MPBENH
     C                   Eval      #1SHAR    =   MPSHAR
     C                   Eval      #1SHAL    =   MPSHAL
     C                   Eval      #1SHAH    =   MPSHAH
     C                   Eval      #1OURR    =   MPOURR
     C                   Eval      #1OURL    =   MPOURL
     C                   Eval      #1OURH    =   MPOURH
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      #1RTSQ    =   MpRtSq                                       PNL014
     C                   Eval      #1TSDO    =   MpTSDO                                       PNL014
     C                   Eval      #1TSCT    =   MpTSCT                                       PNL014
     C                   Eval      #1TSCD    =   MpTSCD                                       PNL014
     C                   Eval      #1TSCK    =   MpTSCK                                       PNL014
     C                   Eval      #1TSFC    =   MpTSFC                                       PNL014
     C                   Eval      #1TSIS    =   MpTSIS                                       PNL014
     C                   Eval      #1RREF    =   MpRREF                                       PNL014
     C                   Eval      #1TSHC    =   MpTSHC                                       PNL014
     C                   Eval      #1TSHL    =   MpTSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------

     C                   MOVEL     MPAJOB        #1AJOB                         Job name
     C                   MOVEL     MPAACT        #1AACT                         Action Type
     C                   Z-ADD     MPRDNB        #1RDNB                         Run day number
     C                   MOVEL     MPAUSR        #1AUSR                         User name
     C                   MOVEL     MPARDT        #1ARDT                         Action Date
     C                   Z-ADD     MPATIM        #1ATIM                         Action Time
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
      *
      * BIC Identifier
     C                   Eval      #1INT1 = *blanks
     C                   If        #1CBIC <> *Blanks                            IF
      * Set key
     C                   Eval      BDBICC = #1CBIC
     C                   Eval      BDBICB = #1CBIB
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   Select
     C                   When      Not %Found
     C                   When      %Found
     C                   Eval      #1INT1 = BDINS1
     C                   Endsl
     C                   Endif                                                  FI
      * Format start date
     C                   If        #1STDT <> 0
     C                   Z-ADD     #1STDT        W2DAYN                         Day No.
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2DATE        #1STDTA
     C                   Endif
      * Format end date
     C                   If        #1ENDT <> 0
     C                   Z-ADD     #1ENDT        W2DAYN                         Day No.
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2DATE        #1ENDTA
     C                   Endif

      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     DSCURR        PARM      *BLANKS       DSSDY
      *
      *
     C                   If        #1SCHL <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SCHL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1SCHLA
     C                   Endif
      *
      *
     C                   If        #1SCHH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SCHH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1SCHHA
     C                   Endif
      * Format percentage
      *
     C                   If        #1SCHR <> 0
      *
      * Reformat for screen
      *
     C                   Move      #1SCHR        W3FLD15
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      6             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:7     #1SCHRA
      *
     C                   Endif                                                  FI
      *
     C                   Clear                   #1PPCTA
     C                   If        #1PPCT <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PPCT        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PPCTA
     C                   Endif
      *
     C                   Clear                   #1PNBRA
     C                   If        #1PNBR <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PNBR        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     7             Subst     W3OUT21:14    #1PNBRA
     C                   Endif

     C                   Clear                   #1PBNBA
     C                   If        #1PBNB <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PBNB        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     7             Subst     W3OUT21:14    #1PBNBA
     C                   Endif
      *
     C                   Clear                   #1PBPTA
     C                   If        #1PBPT <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PBPT        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PBPTA
     C                   Endif

     C                   Clear                   #1PSNBA
     C                   If        #1PSNB <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PSNB        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     7             Subst     W3OUT21:14    #1PSNBA
     C                   Endif
      *
     C                   Clear                   #1PsPTA
     C                   If        #1PsPT <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PsPT        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PsPTA
     C                   Endif

     C                   Clear                   #1PONBA
     C                   If        #1PONB <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PONB        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     7             Subst     W3OUT21:14    #1PONBA
     C                   Endif
      *
     C                   Clear                   #1PoPTA
     C                   If        #1PoPT <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PoPT        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PoPTA
     C                   Endif
      *
      *
     C                   If        #1SCHH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SCHH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1SCHHA
     C                   Endif
      *
     C                   Clear                   #1PRPCA
     C                   If        #1PRPC <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PRPC        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PRPCA
     C                   Endif
      *
     C                   Clear                   #1PRNBA
     C                   If        #1PRNB <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PRNB        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     7             Subst     W3OUT21:14    #1PRNBA
     C                   Endif
      *
     C                   Clear                   #1PlPCA
     C                   If        #1PlPC <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PlPC        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     2             Subst     W3OUT21:19    #1PlPCA
     C                   Endif
      *
     C                   Clear                   #1PlNBA
     C                   If        #1PlNB <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PlNB        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     7             Subst     W3OUT21:14    #1PlNBA
     C                   Endif

     C                   Clear                   #1BENLA
     C                   Clear                   #1BENHA
     C                   Clear                   #1SHALA
     C                   Clear                   #1SHAHA
     C                   Clear                   #1OURLA
     C                   Clear                   #1OURHA

      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     DSCURR        PARM      *BLANKS       DSSDY
      *
     C                   If        #1BENL <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1BENL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1BENLA
     C                   Endif
      *
      *
     C                   If        #1BENH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1BENH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1BENHA
     C                   Endif
      *
     C                   If        #1SHAL <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SHAL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1SHALA
     C                   Endif
      *
      *
     C                   If        #1SHAH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SHAH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1SHAHA
     C                   Endif
      *
     C                   If        #1OURL <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1OURL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1OURLA
     C                   Endif
      *
      *
     C                   If        #1OURH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1OURH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value

     C     15            Subst     W3OUT21:6     #1OURHA
     C                   Endif
     C                   Clear                   #1TSCTA                                      PNL014
     C                   Clear                   #1TSCDA                                      PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   If        #1TSCK   <>   *blanks                                      PNL014
      * Set up cut off time                                                                   PNL014
     C                   If        #1TSCT    >   -1                                           PNL014
     C                   Movel     MpTsCt        #1TsCtA                                      PNL014
     C                   Endif                                                                PNL014
      * Set up cut off day adjustment                                                         PNL014
     C                   If        #1TSCD    >   -1                                           PNL014
     C                   Movel     MpTsCd        #1TsCdA                                      PNL014
     C                   Endif                                                                PNL014
     C                   Endif                                                                PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
      *
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
     C                   MOVEL     *BLANKS       #1INS1
     C                   Eval      #1INT1 = *blanks

     C                   MOVEL     P2BICC        #1BICC
     C                   MOVEL     P2BICB        #1BICB
     C                   MOVEL     P2PCCY        #1PCCY
     C                   MOVEL     P2CBIC        #1CBIC
     C                   MOVEL     P2CBIB        #1CBIB
      * USER: Initialise key screen
      * Option Name
     C                   SELECT
      * Insert screen
     C     P1ACTC        WHENEQ    'I'
     C                   MOVEL     '0'           *IN77
     C                   MOVEL     'PR10062'     #MSGID
      * Enquiry screen
     C     P1ACTC        WHENEQ    'E'
     C                   MOVEL     'PR10061'     #MSGID
      * Amendment screen
     C     P1ACTC        WHENEQ    'A'
     C                   MOVEL     'PR10063'     #MSGID
      * Delete screen
     C     P1ACTC        WHENEQ    'D'
     C                   MOVEL     'PR10064'     #MSGID
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
     C                   MOVEL     #1BICC        MPBICC
     C                   MOVEL     #1BICB        MPBICB
     C                   MOVEL     #1PCCY        MPPCCY
     C                   MOVEL     #1CBIC        MPCBIC
     C                   MOVEL     #1CBIB        MPCBIB
     C     KRTV          CHAIN     @MSCPV0                            90        *
      * If found and live
     C     *IN90         IFEQ      '0'
     C     MPRECI        ANDEQ     'D'
     C                   MOVEL     'CCS0093'     W0RTN             7
      * USER: Processing if DBF record already exists
     C                   GOTO      SAEXIT
     C                   END                                                    FI 91
     C
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @MSCPV0
     C                   MOVEL     #1BICC        MPBICC                         Receiving Branch
     C                   MOVEL     #1BICB        MPBICB                         Transaction Type
     C                   MOVEL     #1AJOB        MPAJOB                         Job name
     C                   MOVEL     #1AACT        MPAACT                         Action Type
     C                   Z-ADD     #1RDNB        MPRDNB                         Run day number
     C                   MOVEL     #1AUSR        MPAUSR                         User name
     C                   MOVEL     #1ARDT        MPARDT                         Action Date
     C                   Z-ADD     #1ATIM        MPATIM                         Action Time
      *
     C                   EVAL      MPPCCY    =   #1PCCY

     C                   EVAL      MPCBIC    =   #1CBIC
     C                   EVAL      MPCBIB    =   #1CBIB
     C                   EVAL      MpRCAU    =   #1RCAU
     C                   EVAL      MpRCAC    =   #1RCAC
     C                   EVAL      MPC53C    =   #1C53C
     C                   EVAL      MPC53B    =   #1C53B
     C                   EVAL      MPC53A    =   #1C53A
     C                   EVAL      MPC53R    =   #1C53R
     C                   EVAL      MPR910    =   #1R910
     C                   EVAL      MPSTMT    =   #1STMT
     C                   EVAL      MPSERP    =   #1SERP
     C                   EVAL      MPSLVP    =   #1SLVP
     C                   EVAL      MPSREG    =   #1SREG
     C                   EVAL      MPFBIC    =   #1FBIC
     C                   EVAL      MPRHOB    =   #1RHOB                                       PNL015
     C                   EVAL      MPSOUR    =   #1SOUR
     C                   EVAL      MPC54C    =   #1C54C
     C                   EVAL      MPC54B    =   #1C54B
     C                   EVAL      MPC56C    =   #1C56C
     C                   EVAL      MPC56B    =   #1C56B
     C                   EVAL      MPSCHR    =   #1SCHR
     C                   EVAL      MPSCHL    =   #1SCHL
     C                   EVAL      MPSCHH    =   #1SCHH
     C                   EVAL      MPSCHC    =   #1SCHC
     C                   EVAL      MPDES1    =   #1DES1
     C                   EVAL      MPDES2    =   #1DES2
     C                   EVAL      MPDES3    =   #1DES3
     C                   EVAL      MPSTAT    =   #1STAT
     C                   EVAL      MPPCOR    =   #1PCOR
     C                   EVAL      MPPbcr    =   #1Pbcr
     C                   EVAL      MPPscr    =   #1Pscr
     C                   EVAL      MPPocr    =   #1Pocr
     C                   EVAL      MPPPCT    =   #1PPCT
     C                   EVAL      MPPNBR    =   #1PNBR
     C                   EVAL      MPPREG    =   #1PREG
     C                   EVAL      MPPRPC    =   #1PRPC
     C                   EVAL      MPPRNB    =   #1PRNB
     C                   EVAL      MPPLVP    =   #1PLVP
     C                   EVAL      MPPLPC    =   #1PLPC
     C                   EVAL      MPPLNB    =   #1PLNB
     C                   EVAL      MPSTDT    =   #1STDT
     C                   EVAL      MPENDT    =   #1ENDT
      *---------------------------------------------------------------------
     C                   Eval      MPBENR    =   #1BENR
     C                   Eval      MPBENL    =   #1BENL
     C                   Eval      MPBENH    =   #1BENH
     C                   Eval      MPSHAR    =   #1SHAR
     C                   Eval      MPSHAL    =   #1SHAL
     C                   Eval      MPSHAH    =   #1SHAH
     C                   Eval      MPOURR    =   #1OURR
     C                   Eval      MPOURL    =   #1OURL
     C                   Eval      MPOURH    =   #1OURH
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      MpRtSq    =   #1RtSq                                       PNL014
     C                   Eval      MpTSDO    =   #1TSDO                                       PNL014
     C                   Eval      MpTSCT    =   #1TSCT                                       PNL014
     C                   Eval      MpTSCD    =   #1TSCD                                       PNL014
     C                   Eval      MpTSCK    =   #1TSCK                                       PNL014
     C                   Eval      MpTSFC    =   #1TSFC                                       PNL014
     C                   Eval      MpTSIS    =   #1TSIS                                       PNL014
     C                   Eval      MpRREF    =   #1RREF                                       PNL014
     C                   Eval      MpTSHC    =   #1TSHC                                       PNL014
     C                   Eval      MpTSHL    =   #1TSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------

     C                   EVAL      MPPBPT    =   #1PBPT
     C                   EVAL      MPPBNB    =   #1PBNB
     C                   EVAL      MPPSPT    =   #1PSPT
     C                   EVAL      MPPSNB    =   #1PSNB
     C                   EVAL      MPPOPT    =   #1POPT
     C                   EVAL      MPPONB    =   #1PONB

     C                   MOVEL     'D'           MPRECI                         Record Identifi
     C                   MOVEL     ##JOB         MPAJOB                         Job name
     C                   MOVEL     ##USR         MPAUSR                         User name
     C                   Z-ADD     ##JTM         MPATIM                         Action Time
     C                   MOVEL     WUMRDT        MPARDT                         Action Date
     C                   MOVEL     'I'           MPAACT                         Action Type
     C                   Z-ADD     WURDNB        MPRDNB                         Run day number
      *
     C                   MOVEL     #1BICC        MPBICC
     C                   MOVEL     #1BICB        MPBICB
      *
     C                   MOVEL     #1PCCY        MPPCCY
      *
     C                   MOVEL     #1CBIC        MPCBIC
     C                   MOVEL     #1CBIB        MPCBIB
      *
     C     KLCRSA        KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
     C                   KFLD                    MPCBIC
     C                   KFLD                    MPCBIB
      * Write or update
     C                   If        %Found
     C                   Update    @MSCPV0
     C                   Else
      *
     C                   WRITE     @MSCPV0                              91      *
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
      * Move key fields to @MSCPV0
     C                   MOVEL     #1BICC        MPBICC
     C                   MOVEL     #1BICB        MPBICB
     C                   MOVEL     #1PCCY        MPPCCY
     C                   MOVEL     #1CBIC        MPCBIC
     C                   MOVEL     #1CBIB        MPCBIB
      *
     C     KLCHSB        KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
     C                   KFLD                    MPCBIC
     C                   KFLD                    MPCBIB
     C     KLCHSB        CHAIN     @MSCPV0                            9091      *
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
      * Move non-key fields to @MSCPV0
     C                   EVAL      MpRCAU    =   #1RCAU
     C                   EVAL      MpRCAC    =   #1RCAC
     C                   EVAL      MPC53C    =   #1C53C
     C                   EVAL      MPC53B    =   #1C53B
     C                   EVAL      MPC53A    =   #1C53A
     C                   EVAL      MPC53R    =   #1C53R
     C                   EVAL      MPR910    =   #1R910
     C                   EVAL      MPSTMT    =   #1STMT
     C                   EVAL      MPSERP    =   #1SERP
     C                   EVAL      MPSLVP    =   #1SLVP
     C                   EVAL      MPSREG    =   #1SREG
     C                   EVAL      MPFBIC    =   #1FBIC
     C                   EVAL      MPRHOB    =   #1RHOB                                       PNL015
     C                   EVAL      MPSOUR    =   #1SOUR
     C                   EVAL      MPC54C    =   #1C54C
     C                   EVAL      MPC54B    =   #1C54B
     C                   EVAL      MPC56C    =   #1C56C
     C                   EVAL      MPC56B    =   #1C56B
     C                   EVAL      MPSCHR    =   #1SCHR
     C                   EVAL      MPSCHL    =   #1SCHL
     C                   EVAL      MPSCHH    =   #1SCHH
     C                   EVAL      MPSCHC    =   #1SCHC
     C                   EVAL      MPDES1    =   #1DES1
     C                   EVAL      MPDES2    =   #1DES2
     C                   EVAL      MPDES3    =   #1DES3
     C                   EVAL      MPSTAT    =   #1STAT
     C                   EVAL      MPPCOR    =   #1PCOR
     C                   EVAL      MPPbcr    =   #1Pbcr
     C                   EVAL      MPPscr    =   #1Pscr
     C                   EVAL      MPPocr    =   #1Pocr
     C                   EVAL      MPPPCT    =   #1PPCT
     C                   EVAL      MPPNBR    =   #1PNBR
     C                   EVAL      MPPREG    =   #1PREG
     C                   EVAL      MPPRPC    =   #1PRPC
     C                   EVAL      MPPRNB    =   #1PRNB
     C                   EVAL      MPPLVP    =   #1PLVP
     C                   EVAL      MPPLPC    =   #1PLPC
     C                   EVAL      MPPLNB    =   #1PLNB
     C                   EVAL      MPSTDT    =   #1STDT
     C                   EVAL      MPENDT    =   #1ENDT
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      MpRtSq    =   #1RtSq                                       PNL014
     C                   Eval      MpTSDO    =   #1TSDO                                       PNL014
     C                   Eval      MpTSCT    =   #1TSCT                                       PNL014
     C                   Eval      MpTSCD    =   #1TSCD                                       PNL014
     C                   Eval      MpTSCK    =   #1TSCK                                       PNL014
     C                   Eval      MpTSFC    =   #1TSFC                                       PNL014
     C                   Eval      MpTSIS    =   #1TSIS                                       PNL014
     C                   Eval      MpRREF    =   #1RREF                                       PNL014
     C                   Eval      MpTSHC    =   #1TSHC                                       PNL014
     C                   Eval      MpTSHL    =   #1TSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------
     C                   Eval      MPBENR    =   #1BENR
     C                   Eval      MPBENL    =   #1BENL
     C                   Eval      MPBENH    =   #1BENH
     C                   Eval      MPSHAR    =   #1SHAR
     C                   Eval      MPSHAL    =   #1SHAL
     C                   Eval      MPSHAH    =   #1SHAH
     C                   Eval      MPOURR    =   #1OURR
     C                   Eval      MPOURL    =   #1OURL
     C                   Eval      MPOURH    =   #1OURH
      *---------------------------------------------------------------------

     C                   EVAL      MPPBPT    =   #1PBPT
     C                   EVAL      MPPBNB    =   #1PBNB
     C                   EVAL      MPPSPT    =   #1PSPT
     C                   EVAL      MPPSNB    =   #1PSNB
     C                   EVAL      MPPOPT    =   #1POPT
     C                   EVAL      MPPONB    =   #1PONB

     C                   MOVEL     #1RECI        MPRECI                         Record Identifi
     C                   MOVEL     #1AJOB        MPAJOB                         Job name
     C                   MOVEL     #1AACT        MPAACT                         Action Type
     C                   Z-ADD     #1RDNB        MPRDNB                         Run day number
     C                   MOVEL     #1AUSR        MPAUSR                         User name
     C                   MOVEL     #1ARDT        MPARDT                         Action Date
     C                   Z-ADD     #1ATIM        MPATIM                         Action Time
      *
     C                   MOVEL     'D'           MPRECI                         Record Identifi
     C                   MOVEL     ##JOB         MPAJOB                         Job name
     C                   MOVEL     ##USR         MPAUSR                         User name
     C                   Z-ADD     ##JTM         MPATIM                         Action Time
     C                   MOVEL     WUMRDT        MPARDT                         Action Date
     C                   MOVEL     'A'           MPAACT                         Action Type
     C                   Z-ADD     WURDNB        MPRDNB                         Run day number
      *
     C                   UPDATE    @MSCPV0                              91      *
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
      * Move key fields to @MSCPV0
     C                   MOVEL     #1BICC        MPBICC
     C                   MOVEL     #1BICB        MPBICB
     C                   MOVEL     #1PCCY        MPPCCY
     C                   MOVEL     #1CBIC        MPCBIC
     C                   MOVEL     #1CBIB        MPCBIB
      *
     C     KLCHSC        KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
     C                   KFLD                    MPCBIC
     C                   KFLD                    MPCBIB
     C     KLCHSC        CHAIN     @MSCPV0                            9091      *
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
     C     KLCHSC        SETLL     @MSCPV0                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before DBF update
     C                   MOVEL     '*'           MPRECI                         Record Identifi
     C                   MOVEL     'D'           MPAACT                         Action Type
      *
     C                   MOVEL     ##JOB         MPAJOB                         Job name
     C                   MOVEL     ##USR         MPAUSR                         User name
     C                   Z-ADD     ##JTM         MPATIM                         Action Time
     C                   MOVEL     WUMRDT        MPARDT                         Action Date
     C                   Z-ADD     WURDNB        MPRDNB                         Run day number
      *
     C                   UPDATE    @MSCPV0                              91      *
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
      * Move key fields to @MSCPV0
     C                   MOVEL     #1BICC        MPBICC
     C                   MOVEL     #1BICB        MPBICB
     C                   MOVEL     #1PCCY        MPPCCY
     C                   MOVEL     #1CBIC        MPCBIC
     C                   MOVEL     #1CBIB        MPCBIB
      *
     C     KLCHSD        KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
     C                   KFLD                    MPCBIC
     C                   KFLD                    MPCBIB
     C     KLCHSD        CHAIN     @MSCPV0                            9091      *
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
     C     KLCHSD        SETLL     @MSCPV0                            9091      *
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      *
      *
      * Move non-key fields to @MSCPV0
     C                   EVAL      MpRCAU    =   #1RCAU
     C                   EVAL      MpRCAC    =   #1RCAC
     C                   EVAL      MPC53C    =   #1C53C
     C                   EVAL      MPC53B    =   #1C53B
     C                   EVAL      MPC53A    =   #1C53A
     C                   EVAL      MPC53R    =   #1C53R
     C                   EVAL      MPR910    =   #1R910
     C                   EVAL      MPSTMT    =   #1STMT
     C                   EVAL      MPSERP    =   #1SERP
     C                   EVAL      MPSLVP    =   #1SLVP
     C                   EVAL      MPSREG    =   #1SREG
     C                   EVAL      MPFBIC    =   #1FBIC
     C                   EVAL      MPRHOB    =   #1RHOB                                       PNL015
     C                   EVAL      MPSOUR    =   #1SOUR
     C                   EVAL      MPC54C    =   #1C54C
     C                   EVAL      MPC54B    =   #1C54B
     C                   EVAL      MPC56C    =   #1C56C
     C                   EVAL      MPC56B    =   #1C56B
     C                   EVAL      MPSCHR    =   #1SCHR
     C                   EVAL      MPSCHL    =   #1SCHL
     C                   EVAL      MPSCHH    =   #1SCHH
     C                   EVAL      MPSCHC    =   #1SCHC
     C                   EVAL      MPDES1    =   #1DES1
     C                   EVAL      MPDES2    =   #1DES2
     C                   EVAL      MPDES3    =   #1DES3
     C                   EVAL      MPSTAT    =   #1STAT
     C                   EVAL      MPPCOR    =   #1PCOR
     C                   EVAL      MPPbcr    =   #1Pbcr
     C                   EVAL      MPPscr    =   #1Pscr
     C                   EVAL      MPPocr    =   #1Pocr
     C                   EVAL      MPPPCT    =   #1PPCT
     C                   EVAL      MPPNBR    =   #1PNBR
     C                   EVAL      MPPREG    =   #1PREG
     C                   EVAL      MPPRPC    =   #1PRPC
     C                   EVAL      MPPRNB    =   #1PRNB
     C                   EVAL      MPPLVP    =   #1PLVP
     C                   EVAL      MPPLPC    =   #1PLPC
     C                   EVAL      MPPLNB    =   #1PLNB
     C                   EVAL      MPSTDT    =   #1STDT
     C                   EVAL      MPENDT    =   #1ENDT
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      MpRtSq    =   #1RtSq                                       PNL014
     C                   Eval      MpTSDO    =   #1TSDO                                       PNL014
     C                   Eval      MpTSCT    =   #1TSCT                                       PNL014
     C                   Eval      MpTSCD    =   #1TSCD                                       PNL014
     C                   Eval      MpTSCK    =   #1TSCK                                       PNL014
     C                   Eval      MpTSFC    =   #1TSFC                                       PNL014
     C                   Eval      MpTSIS    =   #1TSIS                                       PNL014
     C                   Eval      MpRREF    =   #1RREF                                       PNL014
     C                   Eval      MpTSHC    =   #1TSHC                                       PNL014
     C                   Eval      MpTSHL    =   #1TSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------
     C                   Eval      MPBENR    =   #1BENR
     C                   Eval      MPBENL    =   #1BENL
     C                   Eval      MPBENH    =   #1BENH
     C                   Eval      MPSHAR    =   #1SHAR
     C                   Eval      MPSHAL    =   #1SHAL
     C                   Eval      MPSHAH    =   #1SHAH
     C                   Eval      MPOURR    =   #1OURR
     C                   Eval      MPOURL    =   #1OURL
     C                   Eval      MPOURH    =   #1OURH
      *---------------------------------------------------------------------

     C                   EVAL      MPPBPT    =   #1PBPT
     C                   EVAL      MPPBNB    =   #1PBNB
     C                   EVAL      MPPSPT    =   #1PSPT
     C                   EVAL      MPPSNB    =   #1PSNB
     C                   EVAL      MPPOPT    =   #1POPT
     C                   EVAL      MPPONB    =   #1PONB

     C                   MOVEL     #1RECI        MPRECI                         Record Identifi
     C                   MOVEL     #1AJOB        MPAJOB                         Job name
     C                   MOVEL     #1AACT        MPAACT                         Action Type
     C                   Z-ADD     #1RDNB        MPRDNB                         Run day number
     C                   MOVEL     #1AUSR        MPAUSR                         User name
     C                   MOVEL     #1ARDT        MPARDT                         Action Date
     C                   Z-ADD     #1ATIM        MPATIM                         Action Time
      *
     C                   MOVEL     'D'           MPRECI                         Record Identifi
     C                   MOVEL     ##JOB         MPAJOB                         Job name
     C                   MOVEL     ##USR         MPAUSR                         User name
     C                   Z-ADD     ##JTM         MPATIM                         Action Time
     C                   MOVEL     WUMRDT        MPARDT                         Action Date
     C                   MOVEL     'A'           MPAACT                         Action Type
     C                   Z-ADD     WURDNB        MPRDNB                         Run day number
      *
     C                   UPDATE    @MSCPV0                              91      *
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
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
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
     C                   MOVEL     '0'           *IN75
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
     C                   OPEN      FTMSCPV0
      * Signal that files are now open
     C                   MOVE      'Y'           W0OPN             1
     C                   END
     C                   MOVEL     'N'           W0PMT             1
      * Initialise error memories
     C                   MOVE      *ZERO         @@I1
     C                   MOVE      *ZERO         @@I2
     C                   MOVE      *ZERO         @@I3
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
      *
      * Get ICD Data
     C     KPicdV1       KLIST
     C                   KFLD                    IcKey
      *
      *
      * Get ICD data
     C                   Clear                   IcKey
     C     KPicdV1       Setll     @PicdV1
     C                   Read      @PicdV1
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
      /COPY WNCPYSRC,FTP064MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,FTP064MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,FTP064MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,FTP064MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,FTP064MOV5
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
      /COPY WNCPYSRC,FTP064MOV6
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
