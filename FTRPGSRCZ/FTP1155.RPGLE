     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP1155 - Midas FT Payment Customer Specific Routes          *
      *                                                               *
      *  Function:  This program controls the display and update      *
      *             of STP Requirements                               *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 15Jul2011             *
      *  Last Amend No. PNL014             Date 08Dec2005             *
      *  Prev Amend No. EEE065 *Create     Date 01Feb2005             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *           Renamed QQDFAC field in SDBRCHPD                    *
      *           Changed length of P@ACCD to 10                      *
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
     FFTP1155DF CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Incoming Collection Header
      *
     FFTMscsV1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : STP Correspondent payment routes
      *
     FFTMscsV0  UF A E           K DISK    USROPN
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
     D @1DBRC        E DS                  EXTNAME(FTMscsV0)
      * UPD : Incoming Msg Translation  Update index
      * Current/previous master file format fields for change control
      *
     D #1DBRC          DS           842
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
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
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
      * O : MAP Customer Id
     D  P2Idks                             Like( CsIdks )
      * O : MAP IBAN
     D  P2Iban                             Like( CsIban )
      * O : MAP Pay Currency
     D  P2PCCY                             Like( CsPccy )
      * O : MAP Reference
     D  P2REF1                             Like( CsRef1 )
     D  P2REF2                             Like( CsRef2 )
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
      * Define passed paramters to FTP880
     D O4parm          DS            68
     D  O4Iban                 1     34
     D  O4rnbr                35     68
     D  O4rnb1                35     50
     D  O4rnb2                51     68

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
      * Container array for countries
     DArrCtry          S              2    Dim(05)
     D##Ptr            S              5S 0
     D##In             S              5S 0
      *
     D W0BICC          S                   Like( McBicc )
     D W0BICB          S                   Like( McBicb )
     D#Ind             S              5S 0
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
     I/COPY QWINDSRC,FTP1150DTA
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
     C     #1Idks        IFEQ      *BLANK
     C     #1Iban        Andeq     *BLANK
     C     #1Pccy        orEQ      *BLANK
     C     #1Ref1        orEQ      *BLANK
     C***  #1Ref2        OREQ      *BLANK
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
     C                   KFLD                    CsIdks
     C                   KFLD                    CsIban
     C                   KFLD                    CsPccy
     C                   KFLD                    CsRef1
     C                   KFLD                    CsRef2
      * Setup key
     C                   MOVEL     #1Idks        CsIdks
     C                   MOVEL     #1Iban        CsIban
     C                   MOVEL     #1Pccy        CsPccy
     C                   MOVEL     #1Ref1        CsRef1
     C                   MOVEL     #1Ref2        CsRef2
     C     KRTV          CHAIN     @MscsV1                            9091      *
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
     C                   MOVEL     'PR10412'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'PR10412'     ZAMSID
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
      * Customer entered?
     C     #1Idks        IFEQ      *BLANK                                       IF
     C     #1Iban        Andeq     *BLANK                                       IF
     C                   SETON                                        993132    *
      * Send message '*Value required'
     C                   MOVEL     'PR10414'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI

     C     #1Idks        IFNE      *BLANK                                       IF
     C     #1Iban        Andne     *BLANK                                       IF
     C                   SETON                                        993132    *
      * Send message '*Value required'
     C                   MOVEL     'PR10422'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Reference entered
     C     #1Ref1        IFEQ      *BLANK                                       IF
     C                   SETON                                        9934      *
      * Send message '*Value required'
     C                   MOVEL     'PR10058'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * If return is different and ? then fill
     C     '?'           Scan      #1IBAN                                 90
     C                   If        *In90 = *On
     C                   Eval      *In99 = *On
     C                   Eval      ActionCode = 'S'
      *
     C                   Clear                   O4parm
     C                   Eval      O4iban = #1Iban
      *
     C                   CALL      'FTP880'
     C                   PARM                    O4RTN             7
     C                   PARM                    ActionCode        1
     C                   PARM                    O4Parm
      *
      **   If data selected then show on screen
      *
     C                   If        O4RTN = 'PTC0020'
     C                   Eval      #1iban = O4Iban
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
      * Validate IBAN
      *
     C                   If        #1Iban <> *blanks
     C                   Eval      O5Iban = 'PL' + #1Iban
      *
     C                   Call      'AOIBANR5'
     C                   Parm      *blanks       O5Rtn             7
     C                   Parm                    O5Iban           34
      *                                                                                       ERN054
     C                   If        O5Rtn <> *blanks
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL(p)  O5Rtn         ZAMSDA
     C                   MOVEL     'PTC0043'     ZAMSID
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Endif
      *
      * Reference is a BIC ?
      *
     C                   Select                                                 FI
      *
     C                   When      #1Ref1 <> *Blanks and                        IF
     C                             #1Ref1 <> '???????????'

      * Define key
     C     KBICD         Klist                                                  IF
     C                   Kfld                    BDBICC                         IF
     C                   Kfld                    BDBICB                         IF
      * Set key
     C                   Eval      BDBICC = %subst(#1Ref1:1:8)
     C                   Eval      BDBICB = %subst(#1Ref1:9:3)
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   Select
     C                   When      Not %Found and %subst(#1Ref1:9:3) = *blanks
     C                   Eval      BDBICB = 'XXX'
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        Not %Found
     C                   SETON                                        9934      *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1CBIC + #1CBIB
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
     C                   Eval      %Subst(#1Ref1:9:3) = 'XXX'
     C                   Endif                                                  FI
     C                   When      Not %Found and %subst(#1Ref1:11:1) = *blanks
     C                   When      Not %Found
     C                   SETON                                        9934      *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1Ref1
     C                   EXSR      ZASNMS
     C                   When      %Found
     C                   Endsl

     C                   Endsl                                                  FI

      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1PCCY        P@CCY             3            I:Currency
     C     DSCURR        PARM      *BLANKS       DSSDY
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

     C                   If        #1Ref1 = '???????????'
     C                   If        #1CDST <> *blanks or
     C                             #1C53A <> *blanks or
     C                             #1C54C <> *blanks or
     C                             #1C54B <> *blanks or
     C                             #1C56C <> *blanks or
     C                             #1C56B <> *blanks or
     C                             #1R910 <> *blanks or
     C                             #1OCCY <> *blanks or
     C                             #1STMT <> *blanks
      * All fields must be empty
     C                   MOVEL     'PR10423'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(31)
     C                   MOVEL     '1'           @I1(32)
     C                   MOVEL     '1'           @I1(33)
     C                   MOVEL     '1'           @I1(34)
     C                   MOVEL     '1'           @I1(51)
     C                   MOVEL     '1'           @I1(52)
     C                   MOVEL     '1'           @I1(35)
     C                   MOVEL     '1'           @I1(54)
     C                   Movel     'Y'           W0DCF
      *
     C                   Else
     C                   Clear                   #1C53C
     C                   Clear                   #1C53B
     C                   Clear                   #1C53R
     C                   Endif
     C                   Endif

      * Check if SWIFT entered
     C                   If        #1CDST = *blanks
     C                             and #1Ref1 <> '???????????'
      * Send message 'Error and default
     C                   MOVEL     'PR10421'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(35)
     C                   Movel     'Y'           W0DCF
     C                   Endif

      * Check if SWIFT entered
     C                   If        #1CDST <> *blanks
     C                             and #1Ref1 <> '???????????'

     C                   Eval      McBICC = %Subst(#1CDST:1:8)
     C                   Eval      McBICB = %Subst(#1CDST:9:3)

     C                   If        McBicb = *blanks
     C                   Eval      McBICB = 'XXX'
     C                   Endif

     C                   Eval      McPCCY = #1PCCY

     C     KMsccv1       Chain     @Msccv1
      *
     C                   Select
      * If an account
     C                   When      %Found and McCtyp = 'ACCOUNT'
     C                   Eval      #1CDST = %Subst(McDAcr:1:18)
     C                   Eval      W0Account = #1CDST
     C                   Eval      #Ind = 35
     C                   Exsr      SrAccount
     C                   Eval      #1CBIC = W0BICC
     C                   Eval      #1CBIB = W0BICB
      * Not an account hence must be BIC
     C                   Other
      * Set key
     C                   Eval      BDBICC = %subst(#1Cdst:1:8)
     C                   Eval      BDBICB = %subst(#1Cdst:9:3)
      * Add XXX
     C                   If        BDBICB = *blanks
     C                   Eval      BDBICB = 'XXX'
     C                   Endif
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
      *
     C                   Select
     C                   When      %Found
     C                   If        %subst(#1Cdst:9:3) = *blanks
     C                   Eval      %subst(#1Cdst:9:3) = 'XXX'

     C                   Eval      #1CBIC = %subst(#1Cdst:1:8)
     C                   Eval      #1CBIB = %subst(#1Cdst:9:3)
     C                   Endif
     C                   When      Not %Found

     C                   Eval      W0Account = #1CDST
     C                   Eval      #Ind = 35
     C                   Exsr      SrAccount

     C                   Eval      #1CBIC = W0BICC
     C                   Eval      #1CBIB = W0BICB

      * Send message 'Error and default
     C                   If        @I1(35) <> '0'
     C                   MOVEL     'PR10420'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(35)
     C                   Movel     'Y'           W0DCF
     C                   Endif
     C                   Endsl

     C                   Endsl

     C                   Endif
      *

      * Check if SWIFT entered
     C                   If        #1C53A <> *blanks
     C                             and #1Ref1 <> '???????????'
     C                   Eval      McBICC = #1C53A
     C                   Eval      McBICB = 'XXX'
     C                   Eval      McPCCY = #1PCCY

      * Define key
     C     KMsccv1       Klist
     C                   Kfld                    McBICC
     C                   Kfld                    McBICB
     C                   Kfld                    McPCCY

     C     KMsccv1       Chain     @Msccv1
     C                   If        %Found and McCtyp = 'ACCOUNT'
     C                   Eval      #1C53A = %Subst(McDAcr:1:10)
     C                   Endif
     C                   Endif
      * Sender's correspondent entered
     C                   If        #1C53A <> *blanks
     C                   Eval      W0Account = #1C53A
     C                   Eval      #Ind = 31
     C                   Exsr      SrAccount
     C                   Eval      #1C53C = W0BICC
     C                   Eval      #1C53B = W0BICB
     C                   Else
     C                   Eval      #1C53C = *blanks
     C                   Eval      #1C53B = *blanks
     C                   Endif
      * Cover required default is no
     C                   If        #1C53R = *blanks
     C                             and #1Ref1 <> '???????????'
     C                   Movel     'N'           #1C53R
     C                   Endif
      * Cover required must be Yes or No
     C                   If        #1C53R <> 'N' and #1C53R <> 'Y'
     C                             and #1Ref1 <> '???????????'
      *
     C                   MOVEL     'PR10067'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(32)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Fail Option must be C or M
     C                   If        #1MROF = *blanks
     C                   Movel     'C'           #1MROF
     C                   Endif
      * Fail option must be Manual Route or Continue
     C                   If        #1MROF <> 'C' and #1MROF <> 'M'
      *
     C                   MOVEL     'PR10424'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(53)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Replace Mt910 must be Y or N
     C                   If        #1R910 = *blanks
     C                             and #1Ref1 <> '???????????'
     C                   Movel     'N'           #1R910
     C                   Endif
      * Replace 910 must be Yes or No
     C                   If        #1R910 <> 'N' and #1R910 <> 'Y'
     C                             and #1Ref1 <> '???????????'
      *
     C                   MOVEL     'PR10195'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I1(51)
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * If Override currency non-blank validate
     C                   If        #1OCCY <> *blanks
     C                             and #1Ref1 <> '???????????'

      * Get currency details
      *
     C                   CALL      'AOCURRR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      #1OCCY        P@CCY             3            I:Currency
     C     DSCURR        PARM      *BLANKS       DSSDY
      *
     C                   If        P@RTCD <> *blanks
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(54)
     C                   Movel     'Y'           W0DCF
      *
     C                   MOVEL     'PR10088'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     #1OCCY        ZAMSDA
     C                   EXSR      ZASNMS
     C                   Else
      * If return is different and ? then fill
     C     '?'           Scan      #1OCCY                                 90
     C                   If        *In90 = *On
     C                   Eval      #1OCCY = A6CYCD
     C                   Eval      *In99 = *On
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *
     C                   Endif
      *
     C     KPSttV1       Klist
     C                   Kfld                    SMSTMT
      *
     C                   If        #1STMT <> '08' and #1STMT <> *blanks
     C                             and #1Ref1 <> '???????????'
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
     C                   If        #1C54C <> *blanks
     C                             and #1Ref1 <> '???????????'
     C                             or #1C54B <> *Blanks
     C                             and #1Ref1 <> '???????????'
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
     C                   If        #1C56C <> *blanks
     C                             and #1Ref1 <> '???????????'
     C                             or #1C56B <> *Blanks
     C                             and #1Ref1 <> '???????????'
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

     C                   If        #1Ref1 = '???????????'
     C                   If        #1C57C <> *blanks or
     C                             #1C57B <> *blanks or
     C                             #1C701 <> *blanks or
     C                             #1C702 <> *blanks or
     C                             #1C703 <> *blanks or
     C                             #1C704 <> *blanks or
     C                             #1C721 <> *blanks or
     C                             #1C722 <> *blanks or
     C                             #1C723 <> *blanks or
     C                             #1C724 <> *blanks
      * All fields must be empty
     C                   MOVEL     'PR10423'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(33)
     C                   MOVEL     '1'           @I2(34)
     C                   MOVEL     '1'           @I2(38)
     C                   Movel     'Y'           W0DCF
      *
     C                   Else
     C                   Endif
     C                   Endif
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

      * Account with Institution
     C                   If        #1C57C <> *blanks
     C                             and #1Ref1 <> '???????????'
     C                             or #1C57B <> *Blanks
     C                             and #1Ref1 <> '???????????'
     C                   If        #1C57B = *blanks
     C                   Eval      #1C57B = 'XXX'
     C                   Endif
      * Set key
     C                   Eval      BDBICC = #1C57C
     C                   Eval      BDBICB = #1C57B
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        Not %Found
      * Send message 'Error and default
     C                   MOVEL     'PR10065'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(33)
     C                   Movel     'Y'           W0DCF
     C                   Endif
     C                   Endif

      * Account with Institution and Details of Payment only allowed if not STP
     C                   If        #1C57C <> *blanks or
     C                             #1C701 <> *blanks or
     C                             #1C702 <> *blanks or
     C                             #1C703 <> *blanks or
     C                             #1C704 <> *blanks
      * Set key
     C                   Eval      BDBICC = %subst(#1Ref1:1:8)
     C                   Eval      BDBICB = %subst(#1Ref1:9:3)
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        %Found or
     C                             #1Ref1 = '???????????'
      * Send message 'Error and default
     C                   MOVEL     'PR10065'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVEL     '1'           @I2(33)
     C                   MOVEL     '1'           @I2(34)
     C                   Movel     'Y'           W0DCF
     C                   Endif
     C                   Endif
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
     C                   Clear                   W0Bicc
     C                   Clear                   W0Bicb
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
     C                   MOVEL     '1'           @I1(#ind)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Else
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(#Ind)
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
     C                   MOVEL     '1'           @I1(#Ind)
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
     C                   MOVEL     '1'           @I1(#Ind)
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Other
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(#Ind)
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
     C                   MOVEL     '1'           @I1(#Ind)
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
     C                   Eval      W0Bicc = %subst(BBCSID:1:8)
     C                   Eval      W0Bicb = %subst(BBCSID:9:3)
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
     C     P2Idks        IFEQ      *BLANK
     C     P2Iban        ANDEQ     *BLANK
     C     P2PCCY        OREQ      *BLANK
     C     P2Ref1        OREQ      *BLANK
     C***  P2Ref2        OREQ      *BLANK
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
     C                   Clear                   #1RDNB
     C                   Clear                   #1RECI
     C                   Clear                   #1AJOB
     C                   Clear                   #1AACT
      *---------------------------------------------------------------------
     C                   Clear                   #1CBIC
     C                   Clear                   #1CBIB
     C                   Clear                   #1CDST
     C                   Clear                   #1RCAU
     C                   Clear                   #1RCAC
      *---------------------------------------------------------------------
     C                   Clear                   #1C53C
     C                   Clear                   #1C53B
     C                   Clear                   #1C53A
     C                   Clear                   #1C53R
     C                   Clear                   #1C54C
     C                   Clear                   #1C54B
     C                   Clear                   #1C56C
     C                   Clear                   #1C56B
     C                   Clear                   #1SCHR
     C                   Clear                   #1SCHL
     C                   Clear                   #1SCHH
     C                   Clear                   #1SCHC
      *---------------------------------------------------------------------
     C                   Clear                   #1DES1
     C                   Clear                   #1DES2
     C                   Clear                   #1DES3
      *---------------------------------------------------------------------
     C                   Clear                   #1R910
     C                   Clear                   #1STMT
     C                   Clear                   #1MROF
     C                   Clear                   #1C57C
     C                   Clear                   #1C57B
     C                   Clear                   #1C701
     C                   Clear                   #1C702
     C                   Clear                   #1C703
     C                   Clear                   #1C704
     C                   Clear                   #1OCcy
     C                   Clear                   #1C721
     C                   Clear                   #1C722
     C                   Clear                   #1C723
     C                   Clear                   #1C724
     C                   Clear                   #1C725
     C                   Clear                   #1C726
      *---------------------------------------------------------------------
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

     C                   Clear                   #1SCHRA
     C                   Clear                   #1SCHLA
     C                   Clear                   #1SCHHA
     C                   Clear                   #1BENLA
     C                   Clear                   #1BENHA
     C                   Clear                   #1SHALA
     C                   Clear                   #1SHAHA
     C                   Clear                   #1OURLA
     C                   Clear                   #1OURHA

      *---------------------------------------------------------------------
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
     C                   PARM      'PR10416'     #MSGID
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
     C                   PARM      'PR10417'     #MSGID
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
     C                   PARM      'PR10417'     #MSGID
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
     C                   Movel     'PR10419'     #MSGID
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
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @MscsV1 fields to screen
      *================================================================

     C                   MOVEL     CsIdks        #1Idks
     C                   MOVEL     CsIban        #1Iban

     C                   EVAL      #1PCCY    =   CsPccy

     C                   EVAL      #1Ref1    =   CsRef1
     C                   EVAL      #1Ref2    =   CsRef2

     C                   EVAL      #1RECI    =   CsRECI

     C                   EVAL      #1CBIC    =   CsCbic
     C                   EVAL      #1CBIB    =   CsCbib
     C                   EVAL      #1CDST    =   CsCdst
     C                   EVAL      #1RCAU    =   CsRCAU
     C                   EVAL      #1RCAC    =   CsRCAC
      *---------------------------------------------------------------------
     C                   EVAL      #1C53C    =   CsC53C
     C                   EVAL      #1C53B    =   CsC53B
     C                   EVAL      #1C53A    =   CsC53A
     C                   EVAL      #1C53R    =   CsC53R
     C                   EVAL      #1C54C    =   CsC54C
     C                   EVAL      #1C54B    =   CsC54B
     C                   EVAL      #1C56C    =   CsC56C
     C                   EVAL      #1C56B    =   CsC56B
     C                   EVAL      #1SCHR    =   CsSCHR
     C                   EVAL      #1SCHL    =   CsSCHL
     C                   EVAL      #1SCHH    =   CsSCHH
     C                   EVAL      #1SCHC    =   CsSCHC
      *---------------------------------------------------------------------
     C                   EVAL      #1DES1    =   CsDES1
     C                   EVAL      #1DES2    =   CsDES2
     C                   EVAL      #1DES3    =   CsDES3
      *---------------------------------------------------------------------
     C                   EVAL      #1STAT    =   CsSTAT
     C                   EVAL      #1STDT    =   CsSTDT
     C                   EVAL      #1ENDT    =   CsENDT
      *---------------------------------------------------------------------
     C                   Eval      #1BENR    =   CsBENR
     C                   Eval      #1BENL    =   CsBENL
     C                   Eval      #1BENH    =   CsBENH
     C                   Eval      #1SHAR    =   CSSHAR
     C                   Eval      #1SHAL    =   CSSHAL
     C                   Eval      #1SHAH    =   CSSHAH
     C                   Eval      #1OURR    =   CSOURR
     C                   Eval      #1OURL    =   CSOURL
     C                   Eval      #1OURH    =   CSOURH
      *---------------------------------------------------------------------
     C                   Eval      #1R910    =   CSR910
     C                   Eval      #1STMT    =   CSSTMT
     C                   Eval      #1MROF    =   CSMROF
     C                   Eval      #1C57C    =   CSC57C
     C                   Eval      #1C57B    =   CSC57B
     C                   Eval      #1C701    =   CSC701
     C                   Eval      #1C702    =   CSC702
     C                   Eval      #1C703    =   CSC703
     C                   Eval      #1C704    =   CSC704
     C                   Eval      #1Occy    =   CSOccy
     C                   Eval      #1C721    =   CSC721
     C                   Eval      #1C722    =   CSC722
     C                   Eval      #1C723    =   CSC723
     C                   Eval      #1C724    =   CSC724
     C                   Eval      #1C725    =   CSC725
     C                   Eval      #1C726    =   CSC726
      *---------------------------------------------------------------------

     C                   MOVEL     CsAJOB        #1AJOB                         Job name
     C                   MOVEL     CsAACT        #1AACT                         Action Type
     C                   Z-ADD     CsRDNB        #1RDNB                         Run day number
     C                   MOVEL     CsAUSR        #1AUSR                         User name
     C                   MOVEL     CsARDT        #1ARDT                         Action Date
     C                   Z-ADD     CsATIM        #1ATIM                         Action Time
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      * Get description data
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
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialise key screen
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code

     C                   MOVEL     P2Idks        #1Idks
     C                   MOVEL     P2Iban        #1Iban
     C                   MOVEL     P2PCCY        #1PCCY
     C                   MOVEL     P2Ref1        #1Ref1
     C                   MOVEL     P2Ref2        #1Ref2
      * USER: Initialise key screen
      * Option Name
     C                   SELECT
      * Insert screen
     C     P1ACTC        WHENEQ    'I'
     C                   MOVEL     '0'           *IN77
     C                   MOVEL     'PR10416'     #MSGID
      * Enquiry screen
     C     P1ACTC        WHENEQ    'E'
     C                   MOVEL     'PR10417'     #MSGID
      * Amendment screen
     C     P1ACTC        WHENEQ    'A'
     C                   MOVEL     'PR10418'     #MSGID
      * Delete screen
     C     P1ACTC        WHENEQ    'D'
     C                   MOVEL     'PR10419'     #MSGID
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
     C                   MOVEL     #1Idks        CsIdks
     C                   MOVEL     #1Iban        CsIban
     C                   MOVEL     #1PCCY        CsPCCY
     C                   MOVEL     #1Ref1        CsRef1
     C                   MOVEL     #1Ref2        CsRef2
     C     KRTV          CHAIN     @MscsV0                            90        *
      * If found and live
     C     *IN90         IFEQ      '0'
     C     CsRECI        ANDEQ     'D'
     C                   MOVEL     'CCS0093'     W0RTN             7
      * USER: Processing if DBF record already exists
     C                   GOTO      SAEXIT
     C                   END                                                    FI 91
     C
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @MscsV0
      *---------------------------------------------------------------------

     C                   MOVEL     #1Idks        CsIdks
     C                   MOVEL     #1Iban        CsIban

     C                   EVAL      CsPCCY    =   #1Pccy

     C                   EVAL      CsRef1    =   #1Ref1
     C                   EVAL      CsRef2    =   #1Ref2

     C                   EVAL      CsRECI    =   #1RECI

     C                   EVAL      CsCBIC    =   #1Cbic
     C                   EVAL      CsCBIB    =   #1Cbib
     C                   EVAL      CsCDST    =   #1Cdst
     C                   EVAL      CsRCAU    =   #1RCAU
     C                   EVAL      CsRCAC    =   #1RCAC
      *---------------------------------------------------------------------
     C                   EVAL      CsC53C    =   #1C53C
     C                   EVAL      CsC53B    =   #1C53B
     C                   EVAL      CsC53A    =   #1C53A
     C                   EVAL      CsC53R    =   #1C53R
     C                   EVAL      CsC54C    =   #1C54C
     C                   EVAL      CsC54B    =   #1C54B
     C                   EVAL      CsC56C    =   #1C56C
     C                   EVAL      CsC56B    =   #1C56B
     C                   EVAL      CsSCHR    =   #1SCHR
     C                   EVAL      CsSCHL    =   #1SCHL
     C                   EVAL      CsSCHH    =   #1SCHH
     C                   EVAL      CsSCHC    =   #1SCHC
      *---------------------------------------------------------------------
     C                   EVAL      CsDES1    =   #1DES1
     C                   EVAL      CsDES2    =   #1DES2
     C                   EVAL      CsDES3    =   #1DES3
      *---------------------------------------------------------------------
     C                   EVAL      CsSTAT    =   #1STAT
     C                   EVAL      CsSTDT    =   #1STDT
     C                   EVAL      CsENDT    =   #1ENDT
      *---------------------------------------------------------------------
     C                   Eval      CsBENR    =   #1BENR
     C                   Eval      CsBENL    =   #1BENL
     C                   Eval      CsBENH    =   #1BENH
     C                   Eval      CSSHAR    =   #1SHAR
     C                   Eval      CSSHAL    =   #1SHAL
     C                   Eval      CSSHAH    =   #1SHAH
     C                   Eval      CSOURR    =   #1OURR
     C                   Eval      CSOURL    =   #1OURL
     C                   Eval      CSOURH    =   #1OURH
      *---------------------------------------------------------------------
     C                   Eval      CSR910    =   #1R910
     C                   Eval      CSSTMT    =   #1STMT
     C                   Eval      CSMROF    =   #1MROF
     C                   Eval      CSC57C    =   #1C57C
     C                   Eval      CSC57B    =   #1C57B
     C                   Eval      CSC701    =   #1C701
     C                   Eval      CSC702    =   #1C702
     C                   Eval      CSC703    =   #1C703
     C                   Eval      CSC704    =   #1C704
     C                   Eval      CSOCcy    =   #1OCcy
     C                   Eval      CSC721    =   #1C721
     C                   Eval      CSC722    =   #1C722
     C                   Eval      CSC723    =   #1C723
     C                   Eval      CSC724    =   #1C724
     C                   Eval      CSC725    =   #1C725
     C                   Eval      CSC726    =   #1C726
      *---------------------------------------------------------------------

     C                   MOVEL     'D'           CsRECI                         Record Identifi
     C                   MOVEL     ##JOB         CsAJOB                         Job name
     C                   MOVEL     ##USR         CsAUSR                         User name
     C                   Z-ADD     ##JTM         CsATIM                         Action Time
     C                   MOVEL     WUMRDT        CsARDT                         Action Date
     C                   MOVEL     'I'           CsAACT                         Action Type
     C                   Z-ADD     WURDNB        CsRDNB                         Run day number
      *
     C                   MOVEL     #1Idks        CsIdks
     C                   MOVEL     #1Iban        CsIban
     C                   MOVEL     #1PCCY        CsPCCY
     C                   MOVEL     #1Ref1        CsRef1
     C                   MOVEL     #1Ref2        CsRef2
      *
     C     KLCRSA        KLIST
     C                   KFLD                    CsIdks
     C                   KFLD                    CsIban
     C                   KFLD                    CsPCCY
     C                   KFLD                    CsRef1
     C                   KFLD                    CsRef2
      * Write or update
     C                   If        %Found
     C                   Update    @MscsV0
     C                   Else
      *
     C                   WRITE     @MscsV0                              91      *
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
      * Move key fields to @MscsV0
     C                   MOVEL     #1Idks        CsIdks
     C                   MOVEL     #1Iban        CsIban
     C                   MOVEL     #1PCCY        CsPCCY
     C                   MOVEL     #1Ref1        CsRef1
     C                   MOVEL     #1Ref2        CsRef2
      *
     C     KLCHSB        KLIST
     C                   KFLD                    CsIdks
     C                   KFLD                    CsIban
     C                   KFLD                    CsPCCY
     C                   KFLD                    CsRef1
     C                   KFLD                    CsRef2
     C     KLCHSB        CHAIN     @MscsV0                            9091      *
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
      * Move non-key fields to @MscsV0
     C                   EVAL      CsRECI    =   #1RECI

     C                   EVAL      CsCBIC    =   #1Cbic
     C                   EVAL      CsCBIB    =   #1Cbib
     C                   EVAL      CsCDST    =   #1Cdst
     C                   EVAL      CsRCAU    =   #1RCAU
     C                   EVAL      CsRCAC    =   #1RCAC
      *---------------------------------------------------------------------
     C                   EVAL      CsC53C    =   #1C53C
     C                   EVAL      CsC53B    =   #1C53B
     C                   EVAL      CsC53A    =   #1C53A
     C                   EVAL      CsC53R    =   #1C53R
     C                   EVAL      CsC54C    =   #1C54C
     C                   EVAL      CsC54B    =   #1C54B
     C                   EVAL      CsC56C    =   #1C56C
     C                   EVAL      CsC56B    =   #1C56B
     C                   EVAL      CsSCHR    =   #1SCHR
     C                   EVAL      CsSCHL    =   #1SCHL
     C                   EVAL      CsSCHH    =   #1SCHH
     C                   EVAL      CsSCHC    =   #1SCHC
      *---------------------------------------------------------------------
     C                   EVAL      CsDES1    =   #1DES1
     C                   EVAL      CsDES2    =   #1DES2
     C                   EVAL      CsDES3    =   #1DES3
      *---------------------------------------------------------------------
     C                   EVAL      CsSTAT    =   #1STAT
     C                   EVAL      CsSTDT    =   #1STDT
     C                   EVAL      CsENDT    =   #1ENDT
      *---------------------------------------------------------------------
     C                   Eval      CsBENR    =   #1BENR
     C                   Eval      CsBENL    =   #1BENL
     C                   Eval      CsBENH    =   #1BENH
     C                   Eval      CSSHAR    =   #1SHAR
     C                   Eval      CSSHAL    =   #1SHAL
     C                   Eval      CSSHAH    =   #1SHAH
     C                   Eval      CSOURR    =   #1OURR
     C                   Eval      CSOURL    =   #1OURL
     C                   Eval      CSOURH    =   #1OURH
      *---------------------------------------------------------------------
     C                   Eval      CSR910    =   #1R910
     C                   Eval      CSSTMT    =   #1STMT
     C                   Eval      CSMROF    =   #1MROF
     C                   Eval      CSC57C    =   #1C57C
     C                   Eval      CSC57B    =   #1C57B
     C                   Eval      CSC701    =   #1C701
     C                   Eval      CSC702    =   #1C702
     C                   Eval      CSC703    =   #1C703
     C                   Eval      CSC704    =   #1C704
     C                   Eval      CSOCcy    =   #1OCcy
     C                   Eval      CSC721    =   #1C721
     C                   Eval      CSC722    =   #1C722
     C                   Eval      CSC723    =   #1C723
     C                   Eval      CSC724    =   #1C724
     C                   Eval      CSC725    =   #1C725
     C                   Eval      CSC726    =   #1C726
      *---------------------------------------------------------------------

     C                   MOVEL     #1RECI        CsRECI                         Record Identifi
     C                   MOVEL     #1AJOB        CsAJOB                         Job name
     C                   MOVEL     #1AACT        CsAACT                         Action Type
     C                   Z-ADD     #1RDNB        CsRDNB                         Run day number
     C                   MOVEL     #1AUSR        CsAUSR                         User name
     C                   MOVEL     #1ARDT        CsARDT                         Action Date
     C                   Z-ADD     #1ATIM        CsATIM                         Action Time
      *
     C                   MOVEL     'D'           CsRECI                         Record Identifi
     C                   MOVEL     ##JOB         CsAJOB                         Job name
     C                   MOVEL     ##USR         CsAUSR                         User name
     C                   Z-ADD     ##JTM         CsATIM                         Action Time
     C                   MOVEL     WUMRDT        CsARDT                         Action Date
     C                   MOVEL     'A'           CsAACT                         Action Type
     C                   Z-ADD     WURDNB        CsRDNB                         Run day number
      *
     C                   UPDATE    @MscsV0                              91      *
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
      * Move key fields to @MscsV0
     C                   MOVEL     #1Idks        CsIdks
     C                   MOVEL     #1Iban        CsIban
     C                   MOVEL     #1PCCY        CsPCCY
     C                   MOVEL     #1Ref1        CsRef1
     C                   MOVEL     #1Ref2        CsRef2
      *
     C     KLCHSC        KLIST
     C                   KFLD                    CsIdks
     C                   KFLD                    CsIban
     C                   KFLD                    CsPCCY
     C                   KFLD                    CsRef1
     C                   KFLD                    CsRef2
     C     KLCHSC        CHAIN     @MscsV0                            9091      *
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
     C     KLCHSC        SETLL     @MscsV0                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before DBF update
     C                   MOVEL     '*'           CsRECI                         Record Identifi
     C                   MOVEL     'D'           CsAACT                         Action Type
      *
     C                   MOVEL     ##JOB         CsAJOB                         Job name
     C                   MOVEL     ##USR         CsAUSR                         User name
     C                   Z-ADD     ##JTM         CsATIM                         Action Time
     C                   MOVEL     WUMRDT        CsARDT                         Action Date
     C                   Z-ADD     WURDNB        CsRDNB                         Run day number
      *
     C                   UPDATE    @MscsV0                              91      *
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
      * Move key fields to @MscsV0
     C                   MOVEL     #1Idks        CsIdks
     C                   MOVEL     #1Iban        CsIban
     C                   MOVEL     #1PCCY        CsPCCY
     C                   MOVEL     #1Ref1        CsRef1
     C                   MOVEL     #1Ref2        CsRef2
      *
     C     KLCHSD        KLIST
     C                   KFLD                    CsIdks
     C                   KFLD                    CsIban
     C                   KFLD                    CsPCCY
     C                   KFLD                    CsRef1
     C                   KFLD                    CsRef2
     C     KLCHSD        CHAIN     @MscsV0                            9091      *
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
     C     KLCHSD        SETLL     @MscsV0                            9091      *
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      *
      *
      * Move non-key fields to @MscsV0
     C                   EVAL      CsRECI    =   #1RECI

     C                   EVAL      CsCBIC    =   #1Cbic
     C                   EVAL      CsCBIB    =   #1Cbib
     C                   EVAL      CsCDST    =   #1Cdst
     C                   EVAL      CsRCAU    =   #1RCAU
     C                   EVAL      CsRCAC    =   #1RCAC
      *---------------------------------------------------------------------
     C                   EVAL      CsC53C    =   #1C53C
     C                   EVAL      CsC53B    =   #1C53B
     C                   EVAL      CsC53A    =   #1C53A
     C                   EVAL      CsC53R    =   #1C53R
     C                   EVAL      CsC54C    =   #1C54C
     C                   EVAL      CsC54B    =   #1C54B
     C                   EVAL      CsC56C    =   #1C56C
     C                   EVAL      CsC56B    =   #1C56B
     C                   EVAL      CsSCHR    =   #1SCHR
     C                   EVAL      CsSCHL    =   #1SCHL
     C                   EVAL      CsSCHH    =   #1SCHH
     C                   EVAL      CsSCHC    =   #1SCHC
      *---------------------------------------------------------------------
     C                   EVAL      CsDES1    =   #1DES1
     C                   EVAL      CsDES2    =   #1DES2
     C                   EVAL      CsDES3    =   #1DES3
      *---------------------------------------------------------------------
     C                   EVAL      CsSTAT    =   #1STAT
     C                   EVAL      CsSTDT    =   #1STDT
     C                   EVAL      CsENDT    =   #1ENDT
      *---------------------------------------------------------------------
     C                   Eval      CsBENR    =   #1BENR
     C                   Eval      CsBENL    =   #1BENL
     C                   Eval      CsBENH    =   #1BENH
     C                   Eval      CSSHAR    =   #1SHAR
     C                   Eval      CSSHAL    =   #1SHAL
     C                   Eval      CSSHAH    =   #1SHAH
     C                   Eval      CSOURR    =   #1OURR
     C                   Eval      CSOURL    =   #1OURL
     C                   Eval      CSOURH    =   #1OURH
      *---------------------------------------------------------------------
     C                   Eval      CSR910    =   #1R910
     C                   Eval      CSSTMT    =   #1STMT
     C                   Eval      CSMROF    =   #1MROF
     C                   Eval      CSC57C    =   #1C57C
     C                   Eval      CSC57B    =   #1C57B
     C                   Eval      CSC701    =   #1C701
     C                   Eval      CSC702    =   #1C702
     C                   Eval      CSC703    =   #1C703
     C                   Eval      CSC704    =   #1C704
     C                   Eval      CSOCcy    =   #1OCcy
     C                   Eval      CSC721    =   #1C721
     C                   Eval      CSC722    =   #1C722
     C                   Eval      CSC723    =   #1C723
     C                   Eval      CSC724    =   #1C724
     C                   Eval      CSC725    =   #1C725
     C                   Eval      CSC726    =   #1C726
      *---------------------------------------------------------------------

     C                   MOVEL     #1RECI        CsRECI                         Record Identifi
     C                   MOVEL     #1AJOB        CsAJOB                         Job name
     C                   MOVEL     #1AACT        CsAACT                         Action Type
     C                   Z-ADD     #1RDNB        CsRDNB                         Run day number
     C                   MOVEL     #1AUSR        CsAUSR                         User name
     C                   MOVEL     #1ARDT        CsARDT                         Action Date
     C                   Z-ADD     #1ATIM        CsATIM                         Action Time
      *
     C                   MOVEL     'D'           CsRECI                         Record Identifi
     C                   MOVEL     ##JOB         CsAJOB                         Job name
     C                   MOVEL     ##USR         CsAUSR                         User name
     C                   Z-ADD     ##JTM         CsATIM                         Action Time
     C                   MOVEL     WUMRDT        CsARDT                         Action Date
     C                   MOVEL     'A'           CsAACT                         Action Type
     C                   Z-ADD     WURDNB        CsRDNB                         Run day number
      *
     C                   UPDATE    @MscsV0                              91      *
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
     C                   OPEN      FTMscsV0
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
      /COPY WNCPYSRC,FTP115MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,FTP115MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,FTP115MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,FTP115MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,FTP115MOV5
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
      /COPY WNCPYSRC,FTP115MOV6
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
(c) Misys International Banking Systems Ltd. 2005
