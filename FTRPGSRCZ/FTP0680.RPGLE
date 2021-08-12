     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT STP Payment Correspondent Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0680 - Midas FT STP Payment Correspondent Maintenance     *
      *                                                               *
      *  Function:  This program controls the display and update      *
      *             of STP Correspondents                             *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 15Jul2011             *
      *                 HVB003             Date 19Oct2011             *
      *                 PNL015             Date 01Dec2005             *
      *                 PNL014             Date 07Dec2005             *
      *                 ESL044             Date 03Feb2005             *
      *                 EEE065 *Amend      Date 25Nov2004             *
      *                 EEE065             Date 07Apr2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  HVB003 - Routing for Target Balance payments                 *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *           Renamed QQDFAC field in SDBRCHPD                    *
      *  PNL015 - Redirection to head office BIC                      *
      *  PNL014 - Time Sensitive Payments                             *
      *  ESL044 - Extra services for Euro Clearing                    *
      *  EEE065 - Allow Foreign BICs                                  *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTP0680DF CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Edit Cheque Detail Record Edit record(3 screens)
      *
     FFTMSCCV1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : STP Correspondents        Retrieval index
      *
     FFTMSCCV0  UF A E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     COMMIT
      * UPD : STP Correspondent         Update index
      *
     FFTMSCPV0  UF A E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     COMMIT
      * UPD : STP Payment routes        Update index
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
      *  Array containing Copyright statement
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
      **  Data Structure for input/output parameters
     D/COPY FTCPYSRC,FT0010D001
      *
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
     D @1DBRC        E DS                  EXTNAME(FTMSCCV0)
      * UPD : Cheque Details            Update index
      * Current/previous master file format fields for change control
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SDLCD        E                     EXTFLD(LCD)
      * Switchable Features Details accessed via Access Program
      *
     D*#1DBRCa****     DS           634                                                       PNL014
     D #1DBRCa         DS           688                                                       PNL014
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D @@I1            DS
      * Screen one error indicator store
     D  @I1                    1    100
     D                                     DIM(100)
     D  INSCR1                31     60
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
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      *
      * Modules Data Structure *
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)                       AR856737
      *
      *  Branch Details *
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      *  Customer Details *
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      * Data Structures for Branch Details
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      * Data Structures for Country codes
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      *  Counterparty Nostro Details *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * Bank details Structure *
      *
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB) PREFIX(AC)
     D  ##ACCT                 2     16
      *
      *  Accounts *
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
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      *  SWIFT BIC identification
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      *  Currency Details *
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  PNL014
                                                                                              PNL014
      *  Location Details *                                                                   PNL014
      *                                                                                       PNL014
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      *
      *  Funds Transfer details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
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
      *
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
      /EJECT
      *
      * Data to be passed to window processing
      *
     I*/COPY*QWINDSRC,FTP0280DTA
     I/COPY QWINDSRC,FTP0680DTA
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Correspond
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
      *
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
     C     #1BICC        IFEQ      *BLANK
     C     #1BICB        OREQ      *BLANK
      * One or more key fields is blank
     C                   Clear                   #1INS1
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
      * If E,D ignore key field validation
     C     P1ACTC        IFEQ      'D'
     C     P1ACTC        OREQ      'E'
     C                   SETOFF                                       99
     C                   MOVE      '000'         *IN(31)
     C                   MOVE      *BLANK        W0RTN
     C                   END
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    MCBICC
     C                   KFLD                    MCBICB
     C                   KFLD                    MCPCCY
      * Setup key
     C                   MOVEL     #1BICC        MCBICC
     C                   MOVEL     #1BICB        MCBICB
     C                   MOVEL     #1PCCY        MCPCCY
     C     KRTV          CHAIN     @MSCCV1                            9091      *
      *
      * Send message 'Record Exists'
      *
     C     *IN90         IFEQ      '0'
     C     P1ACTC        ANDEQ     'I'
     C                   MOVEL     'PR10029'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEA     '111'         *IN(31)
     C                   MOVEL     '1'           *IN99
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
     C                   ELSE
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * USER: Initialize detail screen (existing record)
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
      *
     C     #1BICC        IFEQ      *BLANK                                       IF
     C     #1BICB        OREQ      *BLANK                                       IF
     C                   SETON                                        993132    *
      * Send message '*Value required'
     C                   MOVEL     'PR10030'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
 
     C                   Select
     C                   When      #1BICC = 'SERVICES'
     C                             And #1BICB = '???'
     C                             Or
     C                             #1BICC = 'SERVICES'
     C                             And #1BICB = 'ACH'
     C                             Or                                                         ESL044
     C                             #1BICC = 'SERVICES'                                        ESL044
     C                             And #1BICB = 'EBA'                                         ESL044
     C                             Or                                                         ESL044
     C                             #1BICC = 'SERVICES'                                        ESL044
     C                             And #1BICB = 'ERP'                                         ESL044
     C                             Or                                                         ESL044
     C                             #1BICC = 'SERVICES'                                        ESL044
     C                             And #1BICB = 'ES2'                                         ESL044
     C                             Or                                                         ESL044
     C                             #1BICC = 'SERVICES'                                        ESL044
     C                             And #1BICB = 'EEX'                                         ESL044
     C                             Or                                                         ESL044
     C                             #1BICC = 'SERVICES'                                        ESL044
     C                             And #1BICB = 'ACE'                                         ESL044
     C                             Or                                                         ESL044
     C                             #1BICC = 'SERVICES'                                        ESL044
     C                             And #1BICB = 'EES'                                         ESL044
     C                             Or                                                         ESL044
     C                             #1BICC = 'SERVICES'                                        ESL044
     C                             And #1BICB = 'ACL'                                         ESL044
     C                             Or                                                         ESL044
     C                             #1BICC = 'SERVICES'                                        ESL044
     C                             And #1BICB = 'ACX'                                         ESL044
     C                             Or                                                         HVB003
     C                             #1BICC = 'SERVICES'                                        HVB003
     C                             And #1BICB = 'TBL'                                         HVB003
     C/COPY WNCPYSRC,FTP0680C01
     C                   Other
      * Define key
     C     KBICD1        Klist                                                  IF
     C                   Kfld                    BDBICC                         IF
 
      * Define key
     C     KBICD         Klist                                                  IF
     C                   Kfld                    BDBICC                         IF
     C                   Kfld                    BDBICB                         IF
      * Set key
     C                   Eval      BDBICC = #1BICC
     C                   Eval      BDBICB = #1BICB
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   Select
     C                   When      Not %Found and %subst(#1BICC:1:4) = '????'
     C                             and %subst(#1BICC:7:2) = '??'
     C                             and #1BICB = '???'
     C                   When      Not %Found and %subst(#1BICC:1:4) <> '????'
     C                             and %subst(#1BICC:7:2) = '??'
     C                             and #1BICB = '???'
      * Get data
     C     KBICD1        Setll     @BICDL2
     C                   Read      @BICDL2                                90
     C                   If        *In90 = *Off
     C                             and %subst(BDBICC:1:6) <>
     C                                 %subst(#1BICC:1:6)
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10134'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1BICB + #1BICB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   When      Not %Found and %subst(#1BICC:1:4) <> '????'
     C                             and %subst(#1BICC:7:2) <> '??'
     C                             and #1BICB = '???'
      * Get data
     C     KBICD1        Setll     @BICDL2
     C     KBICD1        Reade     @BICDL2                                90
     C                   If        *In90 = *On
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10133'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1BICB + #1BICB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
     C                   When      Not %Found and #1BICB = *blanks
     C                   Eval      BDBICB = 'XXX'
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        Not %Found
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1BICB + #1BICB
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
     C                   Eval      #1BICB = 'XXX'
     C                   Eval      #1INS1 = BDINS1
     C                   Endif                                                  FI
     C                   When      Not %Found
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1BICB + #1BICB
     C                   EXSR      ZASNMS
     C                   When      %Found
     C                   Eval      #1INS1 = BDINS1
     C                   Endsl
 
     C                   Endsl
 
      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
     C                   If        P@RTCD <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           *In33
      *
     C                   MOVEL     'PR10088'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCCY        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Else
      * If return is different and ? then fill
     C     '?'           Scan      #1PCCY                                 90
     C                   If        *In90 = *On
     C                   Eval      #1PCCY = A6CYCD
     C                   Eval      *In99 = *On
     C                   Endif                                                  FI
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
     C                   MOVEL     'K'           W0TRN
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
     C                   EXSR      DCVLDL
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
      * CALC: Detail screen function fields
      * USER: Validate detail screen relations
      *
      * Validate Screen 1
      *
     C                   EXSR      SRSCR1
      *
      * Validate Screen 2
      *
     C                   EXSR      SRSCR2
      *
      * Validate Screen 3
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
      *
      * Default to lowest type, BENEF
     C                   If        #1CTYP = *blanks
     C                   Eval      #1CTYP = 'BENEF'
     C                   Endif
      *
     C                   If        #1CTYP <> 'ACCOUNT'
     C                             And #1CTYP <> 'BENEF'
     C                             And #1CTYP <> 'SWIFTKEY'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)
      *
     C                   MOVEL     'PR10101'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1CTYP        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1CTYP = 'SWIFTKEY'
      *  Check for specific routing for Pay Through
 
      * If branch is blank then set default
 
     C                   Select
     C                   When      O2Brca = *blanks  and IcDbrc = *blanks
     C                   Eval      O2Brca = 'MBB'
     C                   Other
     C                   Eval      O2Brca = ICDBrc
     C                   Endsl
 
     C                   Eval      O2type = 'S'
     C                   Eval      O2SBicc = #1Bicc
     C                   Eval      O2SBicb = #1Bicb
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   If        O2Rtn <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)
      *
     C                   MOVEL     'PR10140'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1CTYP        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Endif
      *
     C                   If        #1CTYP = 'BENEF'
      *  Check for specific routing for Pay Through
     C                   Eval      O2SBicc = #1Bicc
     C                   Eval      O2SBicb = #1Bicb
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   If        O2Rtn = *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)
      *
     C                   MOVEL     'PR10141'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1CTYP        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Endif
 
      * Validate country
     C                   If        #1CTRY <> *blanks
 
      * Get currency details
      *
     C                   CALL      'AOCTRYR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1CTRY        P@CTRY            2            I:Sub-type
     C     SDCTRY        PARM      *BLANKS       DSSDY
      *
     C                   If        P@RTCD <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(32)
      *
     C                   MOVEL     'PR10102'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1CTRY        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Else
      * If return is different and ? then fill
     C     '?'           Scan      #1CTRY                                 90
     C                   If        *In90 = *On
     C                   Eval      #1CTRY = A4CNCD
     C                   Eval      *In99 = *On
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
 
      * Validate country
     C                   If        #1CTRY <> *blanks and #1BICC <> 'SERVICES'
     C                             and %subst(#1Bicc:5:2) <> #1CTRY
     C                             and %subst(#1Bicc:5:2) <> '??'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(32)
      *
     C                   MOVEL     'PR10103'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1CTRY        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
 
      * Validate country
     C                   If        #1CTRY = *blanks
     C                             and %subst(#1Bicc:6:2) = '??'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(32)
      *
     C                   MOVEL     'PR10104'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1CTRY        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      * Default to ALL for standard quotation convention
     C                   If        #1S71A = *blanks
     C                   Eval      #1S71A = 'ALL'
     C                   Endif
      *
     C                   If        #1S71A <> *blanks
     C                             and #1S71A <> 'BEN'
     C                             and #1S71A <> 'SHA'
     C                             and #1S71A <> 'OUR'
     C                             and #1S71A <> 'BENSHA'
     C                             and #1S71A <> 'OURBEN'
     C                             and #1S71A <> 'OURSHA'
     C                             and #1S71A <> 'ALL'
      *
     C                   MOVEL     'PR10115'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(43)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
      * Default to No for preferential correspondent
     C                   If        #1PCOR = *blanks
     C                   Eval      #1PCOR = 'N'
     C                   Endif
      *
     C                   If        #1PCOR <> 'N'
     C                             And #1PCOR <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(33)
      *
     C                   MOVEL     'PR10105'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      * Default to No for Inhibit Direct Account
     C                   If        #1IDAB = *blanks
     C                   Eval      #1IDAB = 'N'
     C                   Endif
     C                   If        #1IDAS = *blanks
     C                   Eval      #1IDAS = 'N'
     C                   Endif
     C                   If        #1IDAO = *blanks
     C                   Eval      #1IDAO = 'N'
     C                   Endif
      *
     C                   If        #1IDAB <> 'N'
     C                             And #1IDAB <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(44)
      *
     C                   MOVEL     'PR10180'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1IDAS <> 'N'
     C                             And #1IDAS <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(45)
      *
     C                   MOVEL     'PR10180'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
     C                   If        #1IDAO <> 'N'
     C                             And #1IDAO <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(46)
      *
     C                   MOVEL     'PR10180'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
      * Sender's correspondent entered
     C                   Clear                   DsAccounts
     C                   If        #1DACR <> *blanks
     C                   Eval      W0Account = #1DACR
     C                   Exsr      SrAccount
     C                   Endif
     C                   Eval      #1DBRC = W0Brca
     C                   Movel     W0Cnum        #1DCST
     C                   Eval      #1DCcy  = W0Ccy
     C                   Movel     W0Acod        #1DAcd
     C                   Movel     W0Acsq        #1DAsq
      * Status must be A or S (Active or suspended
     C                   If        #1STAT <> 'A' and #1STAT <> 'S'
      *
     C                   MOVEL     'PR10060'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
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
     C                   Movel     'Y'           W0DCF
     C                   Movel     'A'           #1STAT
     C                   Endif
      * Status must be A or S (Active or suspended
     C                   If        #1STAT <> 'A' and #1STAT <> 'S'
      * Send message 'Cheque receipt date is mandatory'
     C                   MOVEL     'PR10060'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
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
     C                   SETON                                        99        *
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
     C                   MOVEL     '1'           @I1(47)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Else                                                                 PNL014
     C                   Move      #1TSCTA       #1TSCT                                       PNL014
     C                   Endif                                                                PNL014
     C                   Other                                                                PNL014
     C                   MOVEL     'PR23007'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(47)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endsl                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   Eval      #1TSCD = -1                                                PNL014
      * Cut off Days adjustment                                                               PNL014
     C                   If        #1TSCDA <> *blanks                                         PNL014
      *                                                                                       PNL014
      *  Check that date is numeric                                                           PNL014
 
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
     C                   MOVEL     '1'           @I1(48)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Else                                                                 PNL014
     C                   Move      #1TSCDA       #1TSCD                                       PNL014
     C                   Endif                                                                PNL014
     C                   Other                                                                PNL014
     C                   MOVEL     'PR23008'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(48)                                      PNL014
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
     C                   MOVEL     '1'           @I1(49)                                      PNL014
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
     C                   MOVEL     '1'           @I1(50)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endif                                                                PNL014
      * Check must be S for stop, C for calculate or blanks                                   PNL014
     C                   If        #1TSFC = 'S'                                               PNL014
     C                   Select                                                               PNL014
     C                   When      %SubSt(#1BICC:1:4) = '????' and                            PNL014
     C                             %SubSt(#1BICC:7:2) = '??'   and                            PNL014
     C                                    #1BICB      = '???'                                 PNL014
     C                   Other                                                                PNL014
      *                                                                                       PNL014
     C                   MOVEL     'PR23015'     ZAMSID                                       PNL014
     C                   MOVEL     'FTUSRMSG'    ZAMSGF                                       PNL014
     C                   EXSR      ZASNMS                                                     PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(50)                                      PNL014
     C                   Movel     'Y'           W0DCF                                        PNL014
     C                   Endsl                                                                PNL014
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
     C                   MOVEL     '1'           @I1(51)                                      PNL014
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
     C                   MOVEL     '1'           @I1(51)                                      PNL014
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
     C     SDCURR        PARM      *BLANKS       DSSDY                                        PNL014
      *                                                                                       PNL014
     C                   If        P@RTCD <> *blanks                                          PNL014
     C                   SETON                                        99        *             PNL014
     C                   MOVEL     '1'           @I1(52)                                      PNL014
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
     C                   MOVEL     '1'           @I1(53)                                      PNL014
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
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      W0Account     P@IBAN           34            I:Retail key
     C     ACCNT         PARM                    DSSDY                          O:OUTPUT
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
      ** Account code changed to 10 dig                                                    AR856737
     C*****16            SUBST     W0Account:19  ##0016a          16                       AR856737
     C     10            SUBST     W0Account:25  ##0010a          10                       AR856737
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
     C*****              PARM      *blanks       P@ACCD            4   :A/c Code            AR856737
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
     C                   PARM                    P@ACCD           10            I:Key field AR856737
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
     C                   MOVEL     '1'           @I1(35)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Else
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(35)
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
     C******             PARM      *blanks       P@ACCD            4          I:Key field 3 AR856737
     C                   PARM      *blanks       P@ACCD           10            I:Key field AR856737
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
     C                   MOVEL     '1'           @I1(35)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C*****              When      ##0016a = *blanks                                      AR856737
     C                   When      ##0010a = *blanks                                      AR856737
     C     6             SUBST     W0Account:1   P@CNUM
     C     3             SUBST     W0Account:7   P@CUCD
     C*****4             SUBST     W0Account:10  P@ACCD                                   AR856737
     C*****2             SUBST     W0Account:14  P@ACSQ                                   AR856737
     C*****3             SUBST     W0Account:16  P@BRCA                                   AR856737
     C     10            SUBST     W0Account:10  P@ACCD                                   AR856737
     C     2             SUBST     W0Account:20  P@ACSQ                                   AR856737
     C     3             SUBST     W0Account:22  P@BRCA                                   AR856737
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
     C                   PARM                    P@ACCD           10            I:Key field AR856737
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
     C                   MOVEL     '1'           @I1(35)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Other
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(35)
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
     C                   MOVEL     '1'           @I1(35)
     C                   MOVEL     'PR10081'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Ccy         ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
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
      * Validate LVPA Flag
      *
     C                   If        #1LVPA = *blanks
      *
     C                   MOVEL     'PR10108'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(31)
     C                   Movel     'Y'           W0DCF
     C                   Movel     'N'           #1LVPA
     C                   Endif
      * Must Y or N
     C                   If        #1LVPA <> 'N' and #1LVPA <> 'Y'
      *
     C                   MOVEL     'PR10109'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(31)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
      * Validate Quotation convention
     C                   If        #1Q71A = *blanks
     C                   Eval      #1Q71A = 'ALL'
     C                   Endif
      *
     C                   If        #1Q71A <> *blanks
     C                             and #1Q71A <> 'BEN'
     C                             and #1Q71A <> 'SHA'
     C                             and #1Q71A <> 'OUR'
     C                             and #1Q71A <> 'BENSHA'
     C                             and #1Q71A <> 'OURBEN'
     C                             and #1Q71A <> 'OURSHA'
     C                             and #1Q71A <> 'ALL'
      *
     C                   MOVEL     'PR10115'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(33)
     C                   Movel     'Y'           W0DCF
     C                   Endif
 
      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
      * Validate minimum fee
     C                   Eval      #1LVPT = 0
      *
     C                   If        #1LVPTA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1LVPTA       ZFIELD
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
     C                   MOVEL     '1'           @I2(32)
      * Send message '*Value required'
     C                   MOVEL     'PR10110'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1LVPT
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1LVPT        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1LVPTA
      *
     C     #1LVPT        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(32)
      * Send message '*Value required'
     C                   MOVEL     'PR10111'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
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
     C                   MOVEL     '1'           @I2(34)
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
     C                   MOVEL     '1'           @I2(34)
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
     C     SDCURR        PARM      *BLANKS       DSSDY
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
     C                   MOVEL     '1'           @I2(35)
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
     C                   MOVEL     '1'           @I2(35)
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
     C                   MOVEL     '1'           @I2(36)
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
     C                   MOVEL     '1'           @I2(36)
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
      *
     C                   MOVEL     'PR10078'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(37)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Status must be A or S (Active or suspended
     C                   If        #1STAT <> 'A' and #1STAT <> 'S'
      *
     C                   MOVEL     'PR10060'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In40 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
     C                   Endif
      *
      * Validate percentage
     C                   Eval      #1LCHR = 0
      *
     C                   If        #1LCHRA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1LCHRA       ZFIELD
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
     C                   MOVEL     '1'           @I2(38)
      * Send message '*Value required'
     C                   MOVEL     'PR10076'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        W3FLD15
     C                   Move      ZFIELD        #1LCHR
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      6             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:7     #1LCHRA
      *
     C     #1LCHR        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(38)
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
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
      * Validate minimum fee
     C                   Eval      #1LCHL = 0
      *
     C                   If        #1LCHLA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1LCHLA       ZFIELD
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
     C                   MOVEL     '1'           @I2(39)
      * Send message '*Value required'
     C                   MOVEL     'PR10071'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1LCHL
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SCHL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1LCHLA
      *
     C     #1LCHL        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(39)
      * Send message '*Value required'
     C                   MOVEL     'PR10072'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate maximum fee
     C                   Eval      #1LCHH = 0
      *
     C                   If        #1LCHHA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1LCHHA       ZFIELD
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
     C                   MOVEL     '1'           @I2(40)
      * Send message '*Value required'
     C                   MOVEL     'PR10073'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1LCHH
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1LCHH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1LCHHA
      * Cheque amount must be greater than0
     C     #1LCHH        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(40)
      * Send message '*Value required'
     C                   MOVEL     'PR10072'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      * Charge code validation
     C                   If        #1LCHC <> *blanks
      *
     C                   Eval      PYCHCD = #1LCHC
     C     KPchgl1       Chain     FTPCHGD0
     C                   If        Not %Found
      *
     C                   MOVEL     'PR10078'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(41)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Status must be A or S (Active or suspended
     C                   If        #1STAT <> 'A' and #1STAT <> 'S'
      *
     C                   MOVEL     'PR10060'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In40 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
     C                   Endif
      *
      * Validate Regular Payment Flag
      *
     C                   If        #1REGP = *blanks
      *
     C                   MOVEL     'PR10161'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(42)
     C                   Movel     'Y'           W0DCF
     C                   Movel     'N'           #1REGP
     C                   Endif
      * Must Y or N
     C                   If        #1REGP <> 'N' and #1REGP <> 'Y'
      *
     C                   MOVEL     'PR10162'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(42)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      *
      * Validate Quotation convention
     C                   If        #1r71A = *blanks
     C                   Eval      #1r71A = 'ALL'
     C                   Endif
      *
     C                   If        #1r71A <> *blanks
     C                             and #1r71A <> 'BEN'
     C                             and #1r71A <> 'SHA'
     C                             and #1r71A <> 'OUR'
     C                             and #1r71A <> 'BENSHA'
     C                             and #1r71A <> 'OURBEN'
     C                             and #1r71A <> 'OURSHA'
     C                             and #1r71A <> 'ALL'
      *
     C                   MOVEL     'PR10115'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(34)
     C                   Movel     'Y'           W0DCF
     C                   Endif
 
      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
      * Validate minimum fee
     C                   Eval      #1REGT = 0
      *
     C                   If        #1REGTA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1REGTA       ZFIELD
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
     C                   MOVEL     '1'           @I2(43)
      * Send message '*Value required'
     C                   MOVEL     'PR10163'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1REGT
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1REGT        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1REGTA
      *
     C     #1REGT        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(43)
      * Send message '*Value required'
     C                   MOVEL     'PR10164'     ZAMSID
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
      *
      * Validate SPCR Flag
      *
     C                   If        #1SPCR = *blanks
     C                   Movel     'N'           #1SPCR
     C                   Endif
      * Must Y or N
     C                   If        #1SPCR <> 'N' and #1SPCR <> 'Y'
      *
     C                   MOVEL     'PR10181'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(31)
     C                   Movel     'Y'           W0DCF
     C                   Endif
 
      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
      * Validate amount
     C                   Eval      #1SPTH = 0
      *
     C                   If        #1SPTHA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1SPTHA       ZFIELD
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
     C                   MOVEL     '1'           @I3(32)
      * Send message '*Value required'
     C                   MOVEL     'PR10182'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1SPTH
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SPTH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1SPTHA
      *
     C     #1SPTH        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(32)
      * Send message '*Value required'
     C                   MOVEL     'PR10183'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate minimum value
     C                   Eval      #1BPAL = 0
      *
     C                   If        #1BPALA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1BPALA       ZFIELD
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
     C                   MOVEL     '1'           @I3(33)
      * Send message '*Value required'
     C                   MOVEL     'PR10178'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1BPAL
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1BPAL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1BPALA
      *
     C     #1BpaL        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(33)
      * Send message '*Value required'
     C                   MOVEL     'PR10174'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate maximum fee
     C                   Eval      #1BPAH = 0
      *
     C                   If        #1BPAHA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1BPAHA       ZFIELD
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
     C                   MOVEL     '1'           @I3(34)
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1BPAH
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1BpaH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1BPAHA
      * Cheque amount must be greater than0
     C     #1BpaH        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(34)
      * Send message '*Value required'
     C                   MOVEL     'PR10177'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      * Validate minimum value
     C                   Eval      #1SpaL = 0
      *
     C                   If        #1SpaLA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1SpaLA       ZFIELD
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
     C                   Move      ZFIELD        #1SpaL
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SpaL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1SpaLA
      *
     C     #1SpaL        IFLT      0                                            IF
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
     C                   Eval      #1SpaH = 0
      *
     C                   If        #1SpaHA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1SpaHA       ZFIELD
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
     C                   Move      ZFIELD        #1SpaH
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SpaH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1SpaHA
      * Cheque amount must be greater than0
     C     #1SpaH        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(36)
      * Send message '*Value required'
     C                   MOVEL     'PR10177'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      * Validate minimum value
     C                   Eval      #1OpaL = 0
      *
     C                   If        #1OpaLA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1OpaLA       ZFIELD
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
     C                   MOVEL     '1'           @I3(37)
      * Send message '*Value required'
     C                   MOVEL     'PR10178'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1OpaL
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1OpaL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1OpaLA
      *
     C     #1OpaL        IFLT      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(37)
      * Send message '*Value required'
     C                   MOVEL     'PR10174'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate maximum fee
     C                   Eval      #1OpaH = 0
      *
     C                   If        #1OpaHA <> *blanks
      *
      *
     C                   Eval      Zfield = *blanks
     C                   Move      #1OpaHA       ZFIELD
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
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
      *
      * Reformat for screen
      *
     C                   Move      ZFIELD        #1OpaH
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1OpaH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1OpaHA
      * Cheque amount must be greater than0
     C     #1OpaH        IFLE      0                                            IF
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(38)
      * Send message '*Value required'
     C                   MOVEL     'PR10177'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Value Added Service
      *
     C                   If        #1PVAS <> *blanks
     C                             And #1PVAS <> 'ACH'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(40)
      *
     C                   MOVEL     'PR10191'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      * Mt910 replace of Mt202 cover must be Y or N
     C                   If        #1R910 = *blanks
     C                   Eval      #1R910 = 'N'
     C                   Endif
      *
     C                   If        #1R910 <> 'N'
     C                             And #1R910 <> 'Y'
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(40)
      *
     C                   MOVEL     'PR10190'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
      *
      * Settlement method must be defined on file
     C                   If        #1STMT = *blanks
     C                   Eval      #1STMT = '08'
     C                   Endif
      *
     C     KPSttV1       Klist
     C                   Kfld                    SMSTMT
      *
     C                   Eval      SMSTMT = #1STMT
     C     KPSttV1       Chain     @PSTTV1
      *
     C                   If        #1STMT <> '08'
     C                             and Not %Found
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(41)
      *
     C                   MOVEL     'PR10189'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1PCOR        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
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
      *  SRXVAL   : Validate Cross Validations                        *
      *                                                               *
      *================================================================
     CSR   SRXVAL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRXVAL'      @STK(Q)
      * If ???? in bic branch then must be BENEF
     C                   If        #1CTYP <> 'BENEF'
     C                             and %subst(#1BICC:1:4) = '????'
      *
     C                   MOVEL     'PR10132'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(31)
     C                   MOVEL     '1'           @I1(35)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * If ??? in bic branch then cannot be type ACCOUNT
     C                   If        #1CTYP = 'ACCOUNT'
     C                             and #1BICB = '???'
     C                             or #1CTYP = 'ACCOUNT'
     C                             and %subst(#1BICC:7:2) = '??'
     C                             and #1BICB = '???'
      *
     C                   MOVEL     'PR10131'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(31)
     C                   MOVEL     '1'           @I1(35)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * If not account then cannot be type ACCOUNT
     C                   If        #1CTYP <> 'ACCOUNT'
     C                             and #1DACR <> *blanks
      *
     C                   MOVEL     'PR10130'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(31)
     C                   MOVEL     '1'           @I1(35)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * If account then account mandatory
     C                   If        #1CTYP = 'ACCOUNT'
     C                             and #1DACR = *blanks
      *
     C                   MOVEL     'PR10106'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(31)
     C                   MOVEL     '1'           @I1(35)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * If not account then account must not be entered
     C                   If        #1CTYP <> 'ACCOUNT'
     C                             and #1DACR <> *blanks
      *
     C                   MOVEL     'PR10107'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(31)
     C                   MOVEL     '1'           @I1(35)
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
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
     C                   MOVEL     '1'           @I1(49)                                      PNL014
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
     C                   MOVEL     '1'           @I1(47)                                      PNL014
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
     C                   MOVEL     '1'           @I1(48)                                      PNL014
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
      * If LVPA then amount must be specified
     C                   If        #1LVPA = 'Y' and #1LVPT = 0
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(31)
     C                   MOVEL     '1'           @I2(32)
      * Send message '*Value required'
     C                   MOVEL     'PR10112'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
      * If Not LVPA then amount must not be specified
     C                   If        #1LVPA = 'N' and #1LVPT <> 0
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(31)
     C                   MOVEL     '1'           @I2(32)
      * Send message '*Value required'
     C                   MOVEL     'PR10113'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
      * Minimum fee must not be greater than maximum
     C                   If        #1Schl <> 0 and #1Schh <> 0
     C                             and #1Schl > #1Schh
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(35)
     C                   MOVEL     '1'           @I2(36)
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
     C                   MOVEL     '1'           @I2(34)
     C                   MOVEL     '1'           @I2(35)
     C                   MOVEL     '1'           @I2(36)
     C                   MOVEL     '1'           @I2(37)
      * Send message '*Value required'
     C                   MOVEL     'PR10079'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
 
      * Minimum fee must not be greater than maximum
     C                   If        #1Lchl <> 0 and #1Lchh <> 0
     C                             and #1Lchl > #1Lchh
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(39)
     C                   MOVEL     '1'           @I2(40)
      * Send message '*Value required'
     C                   MOVEL     'PR10075'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
      * If charge code then other fields must be blank
     C                   If        #1Lchc <> *blanks
     C                   If        #1Lchr <> 0
     C                             or  #1Lchl <> 0
     C                             or  #1Lchh <> 0
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(38)
     C                   MOVEL     '1'           @I2(39)
     C                   MOVEL     '1'           @I2(40)
     C                   MOVEL     '1'           @I2(41)
      * Send message '*Value required'
     C                   MOVEL     'PR10079'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      * If LVPA then amount must be specified
     C                   If        #1LVPA = 'N'
     C                             And #1LCHRA <> *blanks
     C                             And #1LCHLA <> *blanks
     C                             And #1LCHHA <> *blanks
     C                             And #1LCHC  <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(31)
     C                   MOVEL     '1'           @I2(38)
     C                   MOVEL     '1'           @I2(39)
     C                   MOVEL     '1'           @I2(40)
     C                   MOVEL     '1'           @I2(41)
      * Send message '*Value required'
     C                   MOVEL     'PR10114'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
      * If Regulated Payment Amount then amount must be specified
     C                   If        #1REGP = 'Y' and #1REGT = 0
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(42)
     C                   MOVEL     '1'           @I2(43)
      * Send message '*Value required'
     C                   MOVEL     'PR10164'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
      * If Not LVPA then amount must not be specified
     C                   If        #1REGP = 'N' and #1REGT <> 0
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(42)
     C                   MOVEL     '1'           @I2(43)
      * Send message '*Value required'
     C                   MOVEL     'PR10165'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
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
      * If LVPA then amount must be specified
     C                   If        #1SPCR = 'Y' and #1SPTH = 0
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(31)
     C                   MOVEL     '1'           @I3(32)
      * Send message '*Value required'
     C                   MOVEL     'PR10184'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
      * If Not LVPA then amount must not be specified
     C                   If        #1SPCR = 'N' and #1SPTH <> 0
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(31)
     C                   MOVEL     '1'           @I3(32)
      * Send message '*Value required'
     C                   MOVEL     'PR10185'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
      * Minimum value must not be greater than maximum
     C                   If        #1Bpal <> 0 and #1Bpah <> 0
     C                             and #1Bpal > #1Bpah
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(33)
     C                   MOVEL     '1'           @I3(34)
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
      * Minimum value must not be greater than maximum
     C                   If        #1Spal <> 0 and #1Spah <> 0
     C                             and #1Spal > #1Spah
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(35)
     C                   MOVEL     '1'           @I3(36)
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
      * Minimum value must not be greater than maximum
     C                   If        #1Opal <> 0 and #1Opah <> 0
     C                             and #1Opal > #1Opah
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I3(37)
     C                   MOVEL     '1'           @I3(38)
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
     C                   MOVEL     '1'           @I1(49)                                      PNL014
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
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      *
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
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
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
      * Create Correspondent - Correspondent Details  * 
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
      * Delete Correspondent - Correspondent Details  * 
     C                   EXSR      SCCHRC
 
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'PR10032'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
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
      * Change Correspondent - Correspondent Details  * 
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
     C     P2BICC        IFEQ      *BLANK
     C     P2BICB        ANDEQ     *BLANK
     C     P2PCCY        ANDEQ     *BLANK
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
     C                   END
     C     W0SCR         IFNE      3
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
     C                   ELSE
     C     W0SCR         IFEQ      3
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
      *
     C                   If        P1Actc = 'I'
     C                   Clear                   #1INS1
     C                   Clear                   #1RECI
     C                   Clear                   #1PNBR
     C                   Clear                   #1PNBRA
     C                   Clear                   #1DBRC
     C                   Clear                   #1DCST
     C                   Clear                   #1DCCY
     C                   Clear                   #1DACD
     C                   Clear                   #1DASQ
     C                   Clear                   #1LVPA
     C                   Clear                   #1LVPT
     C                   Clear                   #1LVPTA
     C                   Clear                   #1Q71A
     C                   Clear                   #1REGP
     C                   Clear                   #1REGT
     C                   Clear                   #1REGTA
     C                   Clear                   #1PRNBA
     C                   Clear                   #1PLNBA
     C                   Clear                   #1R71A
     C                   Clear                   #1SCHR
     C                   Clear                   #1SCHRA
     C                   Clear                   #1SCHL
     C                   Clear                   #1SCHLA
     C                   Clear                   #1SCHH
     C                   Clear                   #1SCHHA
     C                   Clear                   #1SCHC
     C                   Clear                   #1LCHR
     C                   Clear                   #1LCHRA
     C                   Clear                   #1LCHL
     C                   Clear                   #1LCHLA
     C                   Clear                   #1LCHH
     C                   Clear                   #1LCHHA
     C                   Clear                   #1LCHC
     C                   Clear                   #1AJOB
     C                   Clear                   #1AUSR
     C                   Clear                   #1ATIM
     C                   Clear                   #1ARDT
     C                   Clear                   #1AACT
     C                   Clear                   #1RDNB
     C                   Clear                   #1CTYP
     C                   Clear                   #1CTRY
     C                   Clear                   #1S71A
     C                   Clear                   #1PCOR
     C                   Clear                   #1DACR
     C                   Clear                   #1DES1
     C                   Clear                   #1DES2
     C                   Clear                   #1DES3
     C                   Clear                   #1STAT
     C                   Clear                   #1STDT
     C                   Clear                   #1STDTA
     C                   Clear                   #1ENDT
     C                   Clear                   #1ENDTA
     C*---------------------------------------------------------------------
     C                   Clear                   #1IDAB
     C                   Clear                   #1IDAS
     C                   Clear                   #1IDAO
     C                   Clear                   #1SPCR
     C                   Clear                   #1SPTH
     C                   Clear                   #1SPTHA
     C                   Clear                   #1BPALA
     C                   Clear                   #1BPAHA
     C                   Clear                   #1SPALA
     C                   Clear                   #1SPAHA
     C                   Clear                   #1OPALA
     C                   Clear                   #1OPAHA
     C                   Clear                   #1SPBN
     C                   Clear                   #1SPSN
     C                   Clear                   #1SPON
     C                   Clear                   #1SPBNA
     C                   Clear                   #1SPSNA
     C                   Clear                   #1SPONA
     C                   Clear                   #1BPAL
     C                   Clear                   #1BPAH
     C                   Clear                   #1SPAL
     C                   Clear                   #1SPAH
     C                   Clear                   #1OPAL
     C                   Clear                   #1OPAH
     C                   Clear                   #1STMT
     C                   Clear                   #1PVAS
     C                   Clear                   #1R910
     C                   Clear                   #1OTHR
     C                   Clear                   #1OSTM
     C                   Clear                   #1OVAS
     C                   Clear                   #1O71A
     C                   Clear                   #1OACR
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
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
      *---------------------------------------------------------------------
      * Direct account
     C                   Clear                   #1OBRC
     C                   Clear                   #1OCST
     C                   Clear                   #1OCCY
     C                   Clear                   #1OACD
     C                   Clear                   #1OASQ
     C                   Endif
      *
      * Fill Command lines and narrative text from messages
      *
     C                   SELECT
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10089'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys
      *
     C                   MOVEL     'PR10090'     ##PG1
     C                   MOVEL     'PR10091'     ##PG2
     C                   MOVEL     'PR10092'     ##PG3
      *
      *
      * Insert screen
      *
     C     P1ACTC        WHENEQ    'I'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10098'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Function keys
      *
     C                   MOVEL     'PR10090'     ##PG1
     C                   MOVEL     'PR10091'     ##PG2
     C                   MOVEL     'PR10092'     ##PG3
      *
      * Amendment screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10093'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
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
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10094'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
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
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @MSCCV1 fields to screen
      *================================================================
     C                   Eval      #1BICC  = mcBICC
     C                   Eval      #1BICB  = mcBICB
     C                   Eval      #1PCCY  = mcPCCY
     C                   Eval      #1RECI  = mcRECI
     C                   Eval      #1PNBR  = mcPNBR
     C                   Eval      #1DBRC  = mcDBRC
     C                   Eval      #1DCST  = mcDCST
     C                   Eval      #1DCCY  = mcDCCY
     C                   Eval      #1DACD  = mcDACD
     C                   Eval      #1DASQ  = mcDASQ
     C                   Eval      #1LVPA  = mcLVPA
     C                   Eval      #1LVPT  = mcLVPT
     C                   Eval      #1Q71A  = mcQ71A
     C                   Eval      #1REGP  = mcREGP
     C                   Eval      #1REGT  = mcREGT
     C                   Eval      #1R71A  = mcR71A
     C                   Eval      #1PLNB  = mcPLNB
     C                   Eval      #1PRNB  = mcPRNB
     C                   Eval      #1SCHR  = mcSCHR
     C                   Eval      #1SCHL  = mcSCHL
     C                   Eval      #1SCHC  = mcSCHC
     C                   Eval      #1LCHR  = mcLCHR
     C                   Eval      #1SCHH  = mcSCHH
     C                   Eval      #1LCHL  = mcLCHL
     C                   Eval      #1LCHH  = mcLCHH
     C                   Eval      #1LCHC  = mcLCHC
     C                   Eval      #1AJOB  = mcAJOB
     C                   Eval      #1AUSR  = mcAUSR
     C                   Eval      #1ATIM  = mcATIM
     C                   Eval      #1ARDT  = mcARDT
     C                   Eval      #1AACT  = mcAACT
     C                   Eval      #1RDNB  = mcRDNB
     C                   Eval      #1CTYP  = mcCTYP
     C                   Eval      #1CTRY  = mcCTRY
     C                   Eval      #1S71A  = mcS71A
     C                   Eval      #1PCOR  = mcPCOR
     C                   Eval      #1DACR  = mcDACR
     C                   Eval      #1DES1  = mcDES1
     C                   Eval      #1DES2  = mcDES2
     C                   Eval      #1DES3  = mcDES3
     C                   Eval      #1STAT  = mcSTAT
     C                   Eval      #1STDT  = mcSTDT
     C                   Eval      #1ENDT  = mcENDT
     C*---------------------------------------------------------------------
     C                   Eval      #1IDAB    =   MCIDAB
     C                   Eval      #1IDAS    =   MCIDAS
     C                   Eval      #1IDAO    =   MCIDAO
     C                   Eval      #1SPCR    =   MCSPCR
     C                   Eval      #1SPTH    =   MCSPTH
     C                   Eval      #1SPBN    =   MCSPBN
     C                   Eval      #1SPSN    =   MCSPSN
     C                   Eval      #1SPON    =   MCSPON
     C                   Eval      #1BPAL    =   MCBPAL
     C                   Eval      #1BPAH    =   MCBPAH
     C                   Eval      #1SPAL    =   MCSPAL
     C                   Eval      #1SPAH    =   MCSPAH
     C                   Eval      #1OPAL    =   MCOPAL
     C                   Eval      #1OPAH    =   MCOPAH
     C                   Eval      #1STMT    =   MCSTMT
     C                   Eval      #1PVAS    =   MCPVAS
     C                   Eval      #1R910    =   MCR910
     C                   Eval      #1OTHR    =   MCOTHR
     C                   Eval      #1OSTM    =   MCOSTM
     C                   Eval      #1OVAS    =   MCOVAS
     C                   Eval      #1O71A    =   MCO71A
     C                   Eval      #1OACR    =   MCOACR
      *---------------------------------------------------------------------
      * Direct account in Midas
     C                   Eval      #1OBRC    =   MCOBRC
     C                   Eval      #1OCST    =   MCOCST
     C                   Eval      #1OCCY    =   MCOCCY
     C                   Eval      #1OACD    =   MCOACD
     C                   Eval      #1OASQ    =   MCOASQ
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      #1TSDO    =   McTSDO                                       PNL014
     C                   Eval      #1TSCT    =   McTSCT                                       PNL014
     C                   Eval      #1TSCD    =   McTSCD                                       PNL014
     C                   Eval      #1TSCK    =   McTSCK                                       PNL014
     C                   Eval      #1TSFC    =   McTSFC                                       PNL014
     C                   Eval      #1TSIS    =   McTSIS                                       PNL014
     C                   Eval      #1RREF    =   McRREF                                       PNL014
     C                   Eval      #1TSHC    =   McTSHC                                       PNL014
     C                   Eval      #1TSHL    =   McTSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------
     C                   Clear                   #1PNBRA
     C                   Clear                   #1SPBNA
     C                   Clear                   #1SPSNA
     C                   Clear                   #1SPONA
     C                   Clear                   #1LVPTA
     C                   Clear                   #1SPTHA
     C                   Clear                   #1BPALA
     C                   Clear                   #1BPAHA
     C                   Clear                   #1SPALA
     C                   Clear                   #1SPAHA
     C                   Clear                   #1OPALA
     C                   Clear                   #1OPAHA
     C                   Clear                   #1REGTA
     C                   Clear                   #1SCHRA
     C                   Clear                   #1SCHLA
     C                   Clear                   #1SCHHA
     C                   Clear                   #1LCHRA
     C                   Clear                   #1LCHLA
     C                   Clear                   #1LCHHA
     C                   Clear                   #1STDTA
     C                   Clear                   #1ENDTA
     C                   Clear                   #1TSCTA                                      PNL014
     C                   Clear                   #1TSCDA                                      PNL014
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRCa
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
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
     C                   If        #1LVPT <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1LVPT        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1LVPTA
     C                   Endif
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
     C                   If        #1LCHL <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1LCHL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1LCHLA
     C                   Endif
      *
      *
     C                   If        #1LCHH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1LCHH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1LCHHA
     C                   Endif
      * Format percentage
      *
     C                   If        #1LCHR <> 0
      *
      * Reformat for screen
      *
     C                   Move      #1LCHR        W3FLD15
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM                    W3FLD15          15 0          I:numeric field
     C                   PARM      6             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:7     #1LCHRA
      *
     C                   Endif                                                  FI
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
      *
     C                   Clear                   #1SPBNA
     C                   If        #1SPBN <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SPBN        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     7             Subst     W3OUT21:14    #1SPBNA
     C                   Endif
      *
     C                   Clear                   #1SPSNA
     C                   If        #1SPSN <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SPSN        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     7             Subst     W3OUT21:14    #1SPSNA
     C                   Endif
      *
     C                   Clear                   #1SPONA
     C                   If        #1SPON <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SPON        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     7             Subst     W3OUT21:14    #1SPONA
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
     C                   If        #1REGT <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1REGT        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1REGTA
     C                   Endif
      *
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
      *
     C                   Clear                   #1PLNBA
     C                   If        #1PLNB <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1PLNB        W3FLD15          15 0          I:numeric field
     C                   PARM      0             W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     7             Subst     W3OUT21:14    #1PLNBA
     C                   Endif
      *
     C                   If        #1SPTH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SPTH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1SPTHA
     C                   Endif
      *
     C                   If        #1BPAL <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1BPAL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1BPALA
     C                   Endif
      *
     C                   If        #1BPAH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1BPAH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1BPAHA
     C                   Endif
      *
     C                   If        #1SPAL <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SPAL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1SPALA
     C                   Endif
      *
     C                   If        #1SPAH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1SPAH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1SPAHA
     C                   Endif
      *
     C                   If        #1OPAL <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1OPAL        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1OPALA
     C                   Endif
      *
     C                   If        #1OPAH <> 0
      *
      * Reformat for screen
      *
     C                   CALL      'ZSEDIT'                             90
     C                   PARM      #1OPAH        W3FLD15          15 0          I:numeric field
     C                   PARM      A6NBDP        W3DECS            1 0          I:No of decimals
     C                   PARM      *blanks       W3ECODE           1            I:Edit Code
     C                   PARM                    W3OUT21          21            O:Return value
 
     C     15            Subst     W3OUT21:6     #1OPAHA
     C                   Endif
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   If        #1TSCK   <>   *blanks                                      PNL014
      * Set up cut off time                                                                   PNL014
     C                   If        #1TSCT    >   -1                                           PNL014
     C                   Movel     McTsCt        #1TsCtA                                      PNL014
     C                   Endif                                                                PNL014
      * Set up cut off day adjustment                                                         PNL014
     C                   If        #1TSCD    >   -1                                           PNL014
     C                   Movel     McTsCd        #1TsCdA                                      PNL014
     C                   Endif                                                                PNL014
     C                   Endif                                                                PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
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
     C                   MOVEL     P2BICC        #1BICC
     C                   MOVEL     P2BICB        #1BICB
     C                   MOVEL     P2PCCY        #1PCCY
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10098'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
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
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10099'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #KCMD2
      * USER: Initialize key screen
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Correspondent - Correspondent Details  * 
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @MSCCV0
     C                   Eval      mcBICC  = #1BICC
     C                   Eval      mcBICB  = #1BICB
     C                   Eval      mcPCCY  = #1PCCY
     C                   Eval      mcRECI  = 'D'
     C                   Eval      mcPNBR  = #1PNBR
     C                   Eval      mcDBRC  = #1DBRC
     C                   Eval      mcDCST  = #1DCST
     C                   Eval      mcDCCY  = #1DCCY
     C                   Eval      mcDACD  = #1DACD
     C                   Eval      mcDASQ  = #1DASQ
     C                   Eval      mcLVPA  = #1LVPA
     C                   Eval      mcLVPT  = #1LVPT
     C                   Eval      mcQ71A  = #1Q71A
     C                   Eval      mcREGP  = #1REGP
     C                   Eval      mcREGT  = #1REGT
     C                   Eval      mcR71A  = #1R71A
     C                   Eval      mcSCHR  = #1SCHR
     C                   Eval      mcSCHL  = #1SCHL
     C                   Eval      mcSCHC  = #1SCHC
     C                   Eval      mcLCHR  = #1LCHR
     C                   Eval      mcSCHH  = #1SCHH
     C                   Eval      mcLCHL  = #1LCHL
     C                   Eval      mcLCHH  = #1LCHH
     C                   Eval      mcLCHC  = #1LCHC
     C                   Eval      mcAJOB  = #1AJOB
     C                   Eval      mcAUSR  = #1AUSR
     C                   Eval      mcATIM  = #1ATIM
     C                   Eval      mcARDT  = #1ARDT
     C                   Eval      mcAACT  = #1AACT
     C                   Eval      mcRDNB  = #1RDNB
     C                   Eval      mcCTYP  = #1CTYP
     C                   Eval      mcCTRY  = #1CTRY
     C                   Eval      mcS71A  = #1S71A
     C                   Eval      mcPCOR  = #1PCOR
     C                   Eval      mcDACR  = #1DACR
     C                   Eval      mcDES1  = #1DES1
     C                   Eval      mcDES2  = #1DES2
     C                   Eval      mcDES3  = #1DES3
     C                   Eval      mcSTAT  = #1STAT
     C                   Eval      mcSTDT  = #1STDT
     C                   Eval      mcENDT  = #1ENDT
     C*---------------------------------------------------------------------
     C                   Eval      MCIDAB    =   #1IDAB
     C                   Eval      MCIDAS    =   #1IDAS
     C                   Eval      MCIDAO    =   #1IDAO
     C                   Eval      MCSPCR    =   #1SPCR
     C                   Eval      MCSPTH    =   #1SPTH
     C                   Eval      MCSPBN    =   #1SPBN
     C                   Eval      MCSPSN    =   #1SPSN
     C                   Eval      MCSPON    =   #1SPON
     C                   Eval      MCBPAL    =   #1BPAL
     C                   Eval      MCBPAH    =   #1BPAH
     C                   Eval      MCSPAL    =   #1SPAL
     C                   Eval      MCSPAH    =   #1SPAH
     C                   Eval      MCOPAL    =   #1OPAL
     C                   Eval      MCOPAH    =   #1OPAH
     C                   Eval      MCSTMT    =   #1STMT
     C                   Eval      MCPVAS    =   #1PVAS
     C                   Eval      MCR910    =   #1R910
     C                   Eval      MCOTHR    =   #1OTHR
     C                   Eval      MCOSTM    =   #1OSTM
     C                   Eval      MCOVAS    =   #1OVAS
     C                   Eval      MCO71A    =   #1O71A
     C                   Eval      MCOACR    =   #1OACR
      *----------------------------------------------------  ---------------
      * Direct account in Midas
     C                   Eval      MCOBRC    =   #1OBRC
     C                   Eval      MCOCST    =   #1OCST
     C                   Eval      MCOCCY    =   #1OCCY
     C                   Eval      MCOACD    =   #1OACD
     C                   Eval      MCOASQ    =   #1OASQ
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      McTSDO    =   #1TSDO                                       PNL014
     C                   Eval      McTSCT    =   #1TSCT                                       PNL014
     C                   Eval      McTSCD    =   #1TSCD                                       PNL014
     C                   Eval      McTSCK    =   #1TSCK                                       PNL014
     C                   Eval      McTSFC    =   #1TSFC                                       PNL014
     C                   Eval      McTSIS    =   #1TSIS                                       PNL014
     C                   Eval      McRREF    =   #1RREF                                       PNL014
     C                   Eval      McTSHC    =   #1TSHC                                       PNL014
     C                   Eval      McTSHL    =   #1TSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------
     C                   MOVEL     ##JOB         mcAJOB                         Job name
     C                   MOVEL     ##USR         mcAUSR                         User name
     C                   Z-ADD     ##JTM         mcATIM                         Action Time
     C                   MOVEL     WUMRDT        mcARDT                         Action Date
     C                   MOVEL     'I'           mcAACT                         Action Type
     C                   Z-ADD     WURDNB        mcRDNB                         Run day number
 
      *
     C     KLCRSA        KLIST
     C                   KFLD                    McBICC
     C                   KFLD                    MCBICB
     C                   KFLD                    MCPCCY
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @MSCCV0                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'PR10100'     W0RTN             7
      * USER: Processing if Data record already exists
      * Change Correspondent Deta - Correspondent Details  * 
     C                   EXSR      SBCHRC
     C                   GOTO      SAEXIT
     C                   END
      *
     C                   WRITE     @MSCCV0                              91      *
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
      * Change Correspondent Deta - Correspondent Details  * 
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @MSCCV0
     C                   MOVEL     #1BICC        McBICC
     C                   MOVEL     #1BICB        MCBICB
     C                   MOVEL     #1PCCY        MCPCCY
      *
     C     KLCHSB        KLIST
     C                   KFLD                    McBICC
     C                   KFLD                    MCBICB
     C                   KFLD                    MCPCCY
     C     KLCHSB        CHAIN     @MSCCV0                            9091      *
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
      * Move non-key fields to @MSCCV0
     C                   Eval      mcBICC  = #1BICC
     C                   Eval      mcBICB  = #1BICB
     C                   Eval      mcPCCY  = #1PCCY
     C                   Eval      mcRECI  = #1RECI
     C                   Eval      mcPNBR  = #1PNBR
     C                   Eval      mcDBRC  = #1DBRC
     C                   Eval      mcDCST  = #1DCST
     C                   Eval      mcDCCY  = #1DCCY
     C                   Eval      mcDACD  = #1DACD
     C                   Eval      mcDASQ  = #1DASQ
     C                   Eval      mcLVPA  = #1LVPA
     C                   Eval      mcLVPT  = #1LVPT
     C                   Eval      mcQ71A  = #1Q71A
     C                   Eval      mcREGP  = #1REGP
     C                   Eval      mcREGT  = #1REGT
     C                   Eval      mcR71A  = #1R71A
     C                   Eval      mcSCHR  = #1SCHR
     C                   Eval      mcSCHL  = #1SCHL
     C                   Eval      mcSCHC  = #1SCHC
     C                   Eval      mcLCHR  = #1LCHR
     C                   Eval      mcSCHH  = #1SCHH
     C                   Eval      mcLCHL  = #1LCHL
     C                   Eval      mcLCHH  = #1LCHH
     C                   Eval      mcLCHC  = #1LCHC
     C                   Eval      mcAJOB  = #1AJOB
     C                   Eval      mcAUSR  = #1AUSR
     C                   Eval      mcATIM  = #1ATIM
     C                   Eval      mcARDT  = #1ARDT
     C                   Eval      mcAACT  = #1AACT
     C                   Eval      mcRDNB  = #1RDNB
     C                   Eval      mcCTYP  = #1CTYP
     C                   Eval      mcCTRY  = #1CTRY
     C                   Eval      mcS71A  = #1S71A
     C                   Eval      mcPCOR  = #1PCOR
     C                   Eval      mcDACR  = #1DACR
     C                   Eval      mcDES1  = #1DES1
     C                   Eval      mcDES2  = #1DES2
     C                   Eval      mcDES3  = #1DES3
     C                   Eval      mcSTAT  = #1STAT
     C                   Eval      mcSTDT  = #1STDT
     C                   Eval      mcENDT  = #1ENDT
     C*---------------------------------------------------------------------
     C                   Eval      MCIDAB    =   #1IDAB
     C                   Eval      MCIDAS    =   #1IDAS
     C                   Eval      MCIDAO    =   #1IDAO
     C                   Eval      MCSPCR    =   #1SPCR
     C                   Eval      MCSPTH    =   #1SPTH
     C                   Eval      MCSPBN    =   #1SPBN
     C                   Eval      MCSPSN    =   #1SPSN
     C                   Eval      MCSPON    =   #1SPON
     C                   Eval      MCBPAL    =   #1BPAL
     C                   Eval      MCBPAH    =   #1BPAH
     C                   Eval      MCSPAL    =   #1SPAL
     C                   Eval      MCSPAH    =   #1SPAH
     C                   Eval      MCOPAL    =   #1OPAL
     C                   Eval      MCOPAH    =   #1OPAH
     C                   Eval      MCSTMT    =   #1STMT
     C                   Eval      MCPVAS    =   #1PVAS
     C                   Eval      MCR910    =   #1R910
     C                   Eval      MCOTHR    =   #1OTHR
     C                   Eval      MCOSTM    =   #1OSTM
     C                   Eval      MCOVAS    =   #1OVAS
     C                   Eval      MCO71A    =   #1O71A
     C                   Eval      MCOACR    =   #1OACR
      *----------------------------------------------------  ---------------
      * Direct account in Midas
     C                   Eval      MCOBRC    =   #1OBRC
     C                   Eval      MCOCST    =   #1OCST
     C                   Eval      MCOCCY    =   #1OCCY
     C                   Eval      MCOACD    =   #1OACD
     C                   Eval      MCOASQ    =   #1OASQ
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      McTSDO    =   #1TSDO                                       PNL014
     C                   Eval      McTSCT    =   #1TSCT                                       PNL014
     C                   Eval      McTSCD    =   #1TSCD                                       PNL014
     C                   Eval      McTSCK    =   #1TSCK                                       PNL014
     C                   Eval      McTSFC    =   #1TSFC                                       PNL014
     C                   Eval      McTSIS    =   #1TSIS                                       PNL014
     C                   Eval      McRREF    =   #1RREF                                       PNL014
     C                   Eval      McTSHC    =   #1TSHC                                       PNL014
     C                   Eval      McTSHL    =   #1TSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------
     C                   MOVEL     ##JOB         mcAJOB                         Job name
     C                   MOVEL     ##USR         mcAUSR                         User name
     C                   Z-ADD     ##JTM         mcATIM                         Action Time
     C                   MOVEL     WUMRDT        mcARDT                         Action Date
     C                   MOVEL     'I'           mcAACT                         Action Type
     C                   Z-ADD     WURDNB        mcRDNB                         Run day number
     C                   Eval      mcRECI  = 'D'
      *
     C                   UPDATE    @MSCCV0                              91      *
      *
     C     *IN91         IFEQ      '1'
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
      * Delete Correspondent - Correspondent Details  * 
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @MSCCV0
     C                   MOVEL     #1BICC        McBICC
     C                   MOVEL     #1BICB        MCBICB
     C                   MOVEL     #1PCCY        MCPCCY
      *
     C     KLCHSC        KLIST
     C                   KFLD                    McBICC
     C                   KFLD                    MCBICB
     C                   KFLD                    MCPCCY
     C     KLCHSC        CHAIN     @MSCCV0                            9091      *
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
     C     #1DBRCa       IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSC        SETLL     @MSCCV0                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before Data update
 
     C                   MOVEL     '*'           mcRECI                         Record Identifi
     C                   MOVEL     'D'           mcAACT                         Record Identifi
 
     C                   MOVEL     ##JOB         mcAJOB                         Job name
     C                   MOVEL     ##USR         mcAUSR                         User name
     C                   Z-ADD     ##JTM         mcATIM                         Action Time
     C                   MOVEL     WUMRDT        mcARDT                         Action Date
     C                   Z-ADD     WURDNB        mcRDNB                         Run day number
 
     C                   UPDATE    @MSCCV0                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRCa
      * DBF change successful
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Correspondent - Correspondent Details  * 
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @MSCCV0
     C                   MOVEL     #1BICC        McBICC
     C                   MOVEL     #1BICB        MCBICB
     C                   MOVEL     #1PCCY        MCPCCY
      *
     C     KLCHSD        KLIST
     C                   KFLD                    McBICC
     C                   KFLD                    MCBICB
     C                   KFLD                    MCPCCY
     C     KLCHSD        CHAIN     @MSCCV0                            9091      *
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
     C     #1DBRCa       IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSD        SETLL     @MSCCV0                            9091      *
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @MSCCV0
     C                   Eval      mcRECI  = #1RECI
     C                   Eval      mcPNBR  = #1PNBR
     C                   Eval      mcDBRC  = #1DBRC
     C                   Eval      mcDCST  = #1DCST
     C                   Eval      mcDCCY  = #1DCCY
     C                   Eval      mcDACD  = #1DACD
     C                   Eval      mcDASQ  = #1DASQ
     C                   Eval      mcLVPA  = #1LVPA
     C                   Eval      mcLVPT  = #1LVPT
     C                   Eval      mcQ71A  = #1Q71A
     C                   Eval      mcREGP  = #1REGP
     C                   Eval      mcREGT  = #1REGT
     C                   Eval      mcR71A  = #1R71A
     C                   Eval      mcSCHR  = #1SCHR
     C                   Eval      mcSCHL  = #1SCHL
     C                   Eval      mcSCHC  = #1SCHC
     C                   Eval      mcLCHR  = #1LCHR
     C                   Eval      mcSCHH  = #1SCHH
     C                   Eval      mcLCHL  = #1LCHL
     C                   Eval      mcLCHH  = #1LCHH
     C                   Eval      mcLCHC  = #1LCHC
     C                   Eval      mcAJOB  = #1AJOB
     C                   Eval      mcAUSR  = #1AUSR
     C                   Eval      mcATIM  = #1ATIM
     C                   Eval      mcARDT  = #1ARDT
     C                   Eval      mcAACT  = #1AACT
     C                   Eval      mcRDNB  = #1RDNB
     C                   Eval      mcCTYP  = #1CTYP
     C                   Eval      mcCTRY  = #1CTRY
     C                   Eval      mcS71A  = #1S71A
     C                   Eval      mcPCOR  = #1PCOR
     C                   Eval      mcDACR  = #1DACR
     C                   Eval      mcDES1  = #1DES1
     C                   Eval      mcDES2  = #1DES2
     C                   Eval      mcDES3  = #1DES3
     C                   Eval      mcSTAT  = #1STAT
     C                   Eval      mcSTDT  = #1STDT
     C                   Eval      mcENDT  = #1ENDT
     C*---------------------------------------------------------------------
     C                   Eval      MCIDAB    =   #1IDAB
     C                   Eval      MCIDAS    =   #1IDAS
     C                   Eval      MCIDAO    =   #1IDAO
     C                   Eval      MCSPCR    =   #1SPCR
     C                   Eval      MCSPTH    =   #1SPTH
     C                   Eval      MCSPBN    =   #1SPBN
     C                   Eval      MCSPSN    =   #1SPSN
     C                   Eval      MCSPON    =   #1SPON
     C                   Eval      MCBPAL    =   #1BPAL
     C                   Eval      MCBPAH    =   #1BPAH
     C                   Eval      MCSPAL    =   #1SPAL
     C                   Eval      MCSPAH    =   #1SPAH
     C                   Eval      MCOPAL    =   #1OPAL
     C                   Eval      MCOPAH    =   #1OPAH
     C                   Eval      MCSTMT    =   #1STMT
     C                   Eval      MCPVAS    =   #1PVAS
     C                   Eval      MCR910    =   #1R910
     C                   Eval      MCOTHR    =   #1OTHR
     C                   Eval      MCOSTM    =   #1OSTM
     C                   Eval      MCOVAS    =   #1OVAS
     C                   Eval      MCO71A    =   #1O71A
     C                   Eval      MCOACR    =   #1OACR
      *----------------------------------------------------  ---------------
      * Direct account in Midas
     C                   Eval      MCOBRC    =   #1OBRC
     C                   Eval      MCOCST    =   #1OCST
     C                   Eval      MCOCCY    =   #1OCCY
     C                   Eval      MCOACD    =   #1OACD
     C                   Eval      MCOASQ    =   #1OASQ
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      McTSDO    =   #1TSDO                                       PNL014
     C                   Eval      McTSCT    =   #1TSCT                                       PNL014
     C                   Eval      McTSCD    =   #1TSCD                                       PNL014
     C                   Eval      McTSCK    =   #1TSCK                                       PNL014
     C                   Eval      McTSFC    =   #1TSFC                                       PNL014
     C                   Eval      McTSIS    =   #1TSIS                                       PNL014
     C                   Eval      McRREF    =   #1RREF                                       PNL014
     C                   Eval      McTSHC    =   #1TSHC                                       PNL014
     C                   Eval      McTSHL    =   #1TSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------
     C                   MOVEL     ##JOB         McAJOB                         Job name
     C                   MOVEL     ##USR         McAUSR                         User name
     C                   Z-ADD     ##JTM         McATIM                         Action Time
     C                   MOVEL     WUMRDT        McARDT                         Action Date
     C                   MOVEL     'A'           McAACT                         Action Type
     C                   Z-ADD     WURDNB        McRDNB                         Run day number
      *
     C                   UPDATE    @MSCCV0                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRCa
      * DBF change successful
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
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
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
     C                   MOVEL     'FTUSRMSG'    ZADFMF           10
      * Define work field Midas run date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
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
     C                   OPEN      FTMSCCV0
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
      * USER: Initialize program
      * Retrieve Midas Date - R10 Standard Functions  * 
     C*
     C*  Set up copyright parameter
     C*
     C                   MOVEA     CPY@          ACT@             80
      *
      *  Extract bank details
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 30 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
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
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
 
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
                                                                                              E00009
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
      /COPY WNCPYSRC,FTP0680MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,FTP0680MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,FTP0680MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,FTP0680MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,FTP0680MOV5
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
     C                   Z-ADD     12            W0ERNB                         * DB ERROR 12 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *   /copy to move data back from the data structure fields passed
      *    as a parameter to the window controller and control user
      *    defined processing.
      *
      /COPY WNCPYSRC,FTP0680MOV6
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
