     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT STP Payment Corr. ReRoute Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0660 - Midas FT STP Payment Corr. ReRoute Maintenance     *
      *                                                               *
      *  Function:  This program controls the display and update      *
      *             of STP Requirements                               *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 15Jul2011             *
      *                 PNL014             Date 07Dec2005             *
      *                 EEE065             Date 05Apr2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 Upgrade STP to Midas Plus level.                    *
      *           Renamed QQDFAC field in SDBRCHPD                    *
      *           Changed size of P@ACCD to 10                        *
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
     FFTP0660DF CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Incoming Collection Header
      *
     FFTMSCRV1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : STP Reroutes
      *
     FFTMSCCV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : STP Correspondents
      *
     FFTMSCRV0  UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(SRFILE)
      * UPD : STP Requirements
      *
     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Deal type sub-type combinations
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
     D @1DBRC        E DS                  EXTNAME(FTMSCRV0)
      * UPD : Incoming Msg Translation  Update index
      * Current/previous master file format fields for change control
      *
     D*#1DBRC*******   DS           273                                                       PNL014
     D #1DBRC          DS           330                                                       PNL014
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
     D  P2RBIC                15     22
      * O : MAP BIC Branch identifier
     D  P2RBIB                23     25
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
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1BICC        IFEQ      *BLANK
     C     #1BICB        OREQ      *BLANK
     C     #1PCCY        orEQ      *BLANK
     C     #1RBIC        orEQ      *BLANK
     C     #1RBIB        OREQ      *BLANK
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
     C                   KFLD                    MRBICC
     C                   KFLD                    MRBICB
     C                   KFLD                    MRPCCY
     C                   KFLD                    MRRBIC
     C                   KFLD                    MRRBIB
      * Setup key
     C                   MOVEL     #1BICC        MRBICC
     C                   MOVEL     #1BICB        MRBICB
     C                   MOVEL     #1PCCY        MRPCCY
     C                   MOVEL     #1RBIC        MRRBIC
     C                   MOVEL     #1RBIB        MRRBIB
     C     KRTV          CHAIN     @MSCRV1                            9091      *
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
     C     #1RBIC        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'PR10058'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * BIC Identifier
     C                   Eval      #1INT1 = *blanks
     C                   If        #1RBIC <> *Blanks                            IF
 
      * Define key
     C     KBICD         Klist                                                  IF
     C                   Kfld                    BDBICC                         IF
     C                   Kfld                    BDBICB                         IF
 
      * Define key
     C     KBICD1        Klist                                                  IF
     C                   Kfld                    BDBICC                         IF
 
      * Set key
     C                   Eval      BDBICC = #1RBIC
     C                   Eval      BDBICB = #1RBIB
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   Select
     C                   When      Not %Found and %subst(#1RBIC:1:4) = '????'
     C                             and %subst(#1RBIC:5:2) <> '??'
     C                             and %subst(#1RBIC:7:2) = '??'
     C                             and #1RBIB = '???'
     C                   When      Not %Found and %subst(#1RBIC:1:4) <> '????'
     C                             and %subst(#1RBIC:5:2) = '??'
     C                             and %subst(#1RBIC:7:2) = '??'
     C                             and #1RBIB = '???'
      * Get data
     C                   Move      '    '        BDBICC
     C     KBICD1        Setll     @BICDL2
     C                   Read      @BICDL2                                90
     C                   If        *In90 = *Off
     C                             and %subst(BDBICC:1:4) <>
     C                                 %subst(#1RBIC:1:4)
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10134'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1RBIB + #1RBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   When      Not %Found and %subst(#1RBIC:1:4) <> '????'
     C                             and %subst(#1RBIC:7:1) <> '?'
     C                             and %subst(#1RBIC:8:1) = '?'
     C                             and #1RBIB = '???'
      * Get data
     C                   Move      ' '           BDBICC
     C     KBICD1        Setll     @BICDL2
     C                   Read      @BICDL2                                90
     C                   If        *In90 = *Off
     C                             and %subst(BDBICC:1:7) <>
     C                                 %subst(#1RBIC:1:7)
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10134'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1RBIB + #1RBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   When      Not %Found and %subst(#1RBIC:1:4) <> '????'
     C                             and %subst(#1RBIC:7:2) = '??'
     C                             and #1RBIB = '???'
      * Get data
     C                   Move      '  '          BDBICC
     C     KBICD1        Setll     @BICDL2
     C                   Read      @BICDL2                                90
     C                   If        *In90 = *Off
     C                             and %subst(BDBICC:1:6) <>
     C                                 %subst(#1RBIC:1:6)
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10134'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1RBIB + #1RBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   When      Not %Found and %subst(#1RBIC:1:4) <> '????'
     C                             and %subst(#1RBIC:7:2) <> '??'
     C                             and #1RBIB = '???'
      * Get data
     C     KBICD1        Setll     @BICDL2
     C     KBICD1        Reade     @BICDL2                                90
     C                   If        *In90 = *On
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10133'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1RBIB + #1RBIB
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
     C                   When      Not %Found and #1RBIB = *blanks
     C                   Eval      BDBICB = 'XXX'
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        Not %Found
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1RBIC + #1RBIB
     C                   EXSR      ZASNMS
     C                   Else                                                   FI
     C                   If        #1RBIB <> '???'
     C                   Eval      #1RBIB = 'XXX'
     C                   Eval      #1INT1 = BDINS1
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   When      Not %Found
     C                   SETON                                        993132    *
      * Send message 'BIC not found'
     C                   MOVEL     'PR10031'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   Eval      ZAMSDA = #1RBIC + #1RBIB
     C                   EXSR      ZASNMS
     C                   When      %Found
     C                   Eval      #1INT1 = BDINS1
     C                   Endsl
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
      * Cover required default is no
     C                   If        #1COVR = *blanks
     C                   Movel     'N'           #1COVR
     C                   Endif
      * Cover required must be Yes or No
     C                   If        #1COVR <> 'N' and #1COVR <> 'Y'
      *
     C                   MOVEL     'PR10067'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In31 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Cover flag value
     C                   If        #1COVR = 'Y' and #1CFLG = *blanks
     C                   Movel     'Y'           #1CFLG
     C                   Endif
      * Cover flag must be Yes or No  or blanks
     C                   If        #1CFLG <> 'Y' and #1CFLG <> 'N'
     C                             and #1CFLG <> *blanks
      *
     C                   MOVEL     'PR10192'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In46 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Cover flag must be blank
     C                   If        #1COVR <> 'Y' and #1CFLG <> *blanks
      *
     C                   MOVEL     'PR10193'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In46 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Cover flag must be Y or N as cover may be required.
     C                   Select
     C                   When      #1COVR = 'Y' and #1CFLG = 'N'
     C                   When      #1COVR = 'Y' and #1CFLG = 'Y'
     C                   When      #1COVR = 'N' and #1CFLG = *blanks
     C                   Other
      *
     C                   MOVEL     'PR10194'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In46 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endsl
      * Replace default is no
     C                   If        #1RPLC = *blanks
     C                   Movel     'N'           #1RPLC
     C                   Endif
      * Cover required must be Yes or No
     C                   If        #1RPLC <> 'N' and #1RPLC <> 'Y'
      *
     C                   MOVEL     'PR10083'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In32 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
      * Status may not be blank
     C                   If        #1STAT = *blanks
      * Send message 'Error and default
     C                   MOVEL     'PR10059'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In43 = *On
     C                   Movel     'Y'           W0DCF
     C                   Movel     'A'           #1STAT
     C                   Endif
      * Status must be A or S (Active or suspended
     C                   If        #1STAT <> 'A' and #1STAT <> 'S'
      * Send message 'Cheque receipt date is mandatory'
     C                   MOVEL     'PR10060'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In43 = *On
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
     C                   Eval      *In44 = *On
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
     C                   Eval      *In45 = *On
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Else
     C                   Eval      #1ENDT = W2DAYN
     C                   Endif
     C                   Endif
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
     C                   Eval      *In34 = *On
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
     C                   Eval      *In35 = *On
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
     C                   Eval      *In35 = *On
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
     C                   Eval      *In36 = *On
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
     C                   Eval      *In36 = *On
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
     C                   Eval      *In37 = *On
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
     C                   Eval      *In40 = *On
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
     C                   Eval      *In38 = *On
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
     C                   Eval      *In38 = *On
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
     C                   Eval      *In39 = *On
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
     C                   Eval      *In39 = *On
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
     C                   Eval      *In41 = *On
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
     C                   Eval      *In41 = *On
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
     C                   Eval      *In42 = *On
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
     C                   Eval      *In42 = *On
      * Send message '*Value required'
     C                   MOVEL     'PR10177'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
     C                   Endif                                                  FI
     C                   Endif                                                  FI
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
     C                   SETON                                        9931      *
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Else
     C                   SETON                                        9931      *
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
     C                   SETON                                        9931      *
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
     C******             PARM                    P@ACCD            4          I:Key field 3 AR856737
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
     C                   SETON                                        9939      *
      * Send message 'Invalid account'
     C                   MOVEL     'PR10080'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   MOVEL     W0Account     ZAMSDA
     C                   EXSR      ZASNMS
     C                   Endif
     C                   Other
     C                   SETON                                        9931      *
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
     C                   SETON                                        9931      *
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
      * Define keys
     C     KMsccV1       KLIST
     C                   KFLD                    MCBICC
     C                   KFLD                    MCBICB
     C                   KFLD                    MCPCCY
      *
      *  Cannot replace if bank and country not defined
     C                   If        #1Rplc = 'Y' and %subst(#1rbic:5:2) = '??'
     C                             or
     C                             #1Rplc = 'Y' and %subst(#1rbic:1:4) = '????'
      *
     C                   MOVEL     'PR10144'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In31 = *On
     C                   Eval      *In32 = *On
     C                   Movel     'Y'           W0DCF
      *
     C                   Endif
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = #1Bicc
     C                   Eval      McBicb = #1Bicb
     C                   Eval      McPccy = #1Pccy
      *
     C     KMsccV1       Chain     @MsccV1
     C                   Select
     C                   When      %Found and McCtyp = 'ACCOUNT'
     C                             and #1Rplc = 'Y' and #1Covr = 'Y'
      *
     C                   MOVEL     'PR10142'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In31 = *On
     C                   Eval      *In32 = *On
     C                   Movel     'Y'           W0DCF
      *
     C                   When      %Found and McCtyp <> 'ACCOUNT'
     C                             and #1Covr = 'Y'
      *
     C                   MOVEL     'PR10143'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In31 = *On
     C                   Movel     'Y'           W0DCF
      *
     C                   Endsl
      *
      *
      * Start date must be before end date
     C                   If        #1STDT <> 0 and #1ENDT <> 0 and
     C                             #1STDT > #1ENDT
      * Send message '*No data to display'
     C                   MOVEL     'PR10070'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Eval      *In44 = *On
     C                   Eval      *In45 = *On
     C                   Eval      *In99 = *On
     C                   Movel     'Y'           W0DCF
     C                   Endif
 
      * Minimum value must not be greater than maximum
     C                   If        #1Benl <> 0 and #1Benh <> 0
     C                             and #1Benl > #1Benh
     C                   SETON                                        99        *
     C                   Eval      *In35 = *On
     C                   Eval      *In36 = *On
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
      * Minimum value must not be greater than maximum
     C                   If        #1Shal <> 0 and #1Shah <> 0
     C                             and #1Shal > #1Shah
     C                   SETON                                        99        *
     C                   Eval      *In38 = *On
     C                   Eval      *In39 = *On
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
      * Minimum value must not be greater than maximum
     C                   If        #1Ourl <> 0 and #1Ourh <> 0
     C                             and #1Ourl > #1Ourh
     C                   SETON                                        99        *
     C                   Eval      *In41 = *On
     C                   Eval      *In42 = *On
      * Send message '*Value required'
     C                   MOVEL     'PR10176'     ZAMSID
     C                   MOVEL     'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   Endif                                                  FI
 
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
     C     P2RBIC        IFEQ      *BLANK
     C     P2RBIB        OREQ      *BLANK
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
     C                   Clear                   #1RBIC
     C                   Clear                   #1RBIB
     C                   Clear                   #1COVR
     C                   Clear                   #1CFLG
     C                   Clear                   #1RPLC
     C                   Clear                   #1BENR
     C                   Clear                   #1BENL
     C                   Clear                   #1BENH
     C                   Clear                   #1BENLA
     C                   Clear                   #1BENHA
     C                   Clear                   #1SHAR
     C                   Clear                   #1SHAL
     C                   Clear                   #1SHAH
     C                   Clear                   #1SHALA
     C                   Clear                   #1SHAHA
     C                   Clear                   #1OURR
     C                   Clear                   #1OURL
     C                   Clear                   #1OURH
     C                   Clear                   #1OURLA
     C                   Clear                   #1OURHA
     C                   Clear                   #1DES1
     C                   Clear                   #1DES2
     C                   Clear                   #1DES3
     C                   Clear                   #1STAT
     C                   Clear                   #1STDT
     C                   Clear                   #1ENDT
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Clear                   #1RTSQ                                       PNL014
     C                   Clear                   #1TSDO                                       PNL014
     C                   Clear                   #1TSCT                                       PNL014
     C                   Clear                   #1TSCD                                       PNL014
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
     C                   PARM      'PR10084'     #MSGID
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
     C                   PARM      'PR10085'     #MSGID
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
     C                   PARM      'PR10086'     #MSGID
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
     C                   Movel     'PR10087'     #MSGID
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
      * Move @MSCRV1 fields to screen
      *================================================================
 
     C                   MOVEL     MRBICC        #1BICC
     C                   MOVEL     MRBICB        #1BICB
     C                   MOVEL     *BLANKS       #1INS1
     C                   MOVEL     *BLANKS       #1INT1
 
     C                   EVAL      #1PCCY    =   MRPCCY
 
     C                   EVAL      #1RECI    =   MRRECI
 
     C                   EVAL      #1RBIC    =   MRRBIC
     C                   EVAL      #1RBIB    =   MRRBIB
     C                   EVAL      #1COVR    =   MRCOVR
     C                   EVAL      #1CFLG    =   MRCFLG
     C                   EVAL      #1RPLC    =   MRRPLC
     C                   EVAL      #1BENR    =   MRBENR
     C                   EVAL      #1BENL    =   MRBENL
     C                   EVAL      #1BENH    =   MRBENH
     C                   EVAL      #1SHAR    =   MRSHAR
     C                   EVAL      #1SHAL    =   MRSHAL
     C                   EVAL      #1SHAH    =   MRSHAH
     C                   EVAL      #1OURR    =   MROURR
     C                   EVAL      #1OURL    =   MROURL
     C                   EVAL      #1OURH    =   MROURH
     C                   EVAL      #1DES1    =   MRDES1
     C                   EVAL      #1DES2    =   MRDES2
     C                   EVAL      #1DES3    =   MRDES3
     C                   EVAL      #1STAT    =   MRSTAT
     C                   EVAL      #1STDT    =   MRSTDT
     C                   EVAL      #1ENDT    =   MRENDT
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      #1RTSQ    =   MrRtSq                                       PNL014
     C                   Eval      #1TSDO    =   MrTSDO                                       PNL014
     C                   Eval      #1TSCT    =   MrTSCT                                       PNL014
     C                   Eval      #1TSCD    =   MrTSCD                                       PNL014
     C                   Eval      #1TSCK    =   MrTSCK                                       PNL014
     C                   Eval      #1TSFC    =   MrTSFC                                       PNL014
     C                   Eval      #1TSIS    =   MrTSIS                                       PNL014
     C                   Eval      #1RREF    =   MrRREF                                       PNL014
     C                   Eval      #1TSHC    =   MrTSHC                                       PNL014
     C                   Eval      #1TSHL    =   MrTSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
 
     C                   MOVEL     MRAJOB        #1AJOB                         Job name
     C                   MOVEL     MRAACT        #1AACT                         Action Type
     C                   Z-ADD     MRRDNB        #1RDNB                         Run day number
     C                   MOVEL     MRAUSR        #1AUSR                         User name
     C                   MOVEL     MRARDT        #1ARDT                         Action Date
     C                   Z-ADD     MRATIM        #1ATIM                         Action Time
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
     C                   If        #1RBIC <> *Blanks                            IF
      * Set key
     C                   Eval      BDBICC = #1RBIC
     C                   Eval      BDBICB = #1RBIB
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
 
     C                   MOVEL     P2BICC        #1BICC
     C                   MOVEL     P2BICB        #1BICB
     C                   MOVEL     P2PCCY        #1PCCY
     C                   MOVEL     P2RBIC        #1RBIC
     C                   MOVEL     P2RBIB        #1RBIB
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
     C                   MOVEL     #1BICC        MRBICC
     C                   MOVEL     #1BICB        MRBICB
     C                   MOVEL     #1PCCY        MRPCCY
     C                   MOVEL     #1RBIC        MRRBIC
     C                   MOVEL     #1RBIB        MRRBIB
     C     KRTV          CHAIN     @MSCRV0                            9091      *
      * If found and live
     C     *IN90         IFEQ      '0'
     C     MRRECI        ANDEQ     'D'
     C                   MOVEL     'CCS0093'     W0RTN             7
      * USER: Processing if DBF record already exists
     C                   GOTO      SAEXIT
     C                   END                                                    FI 91
     C
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @MSCRV0
     C                   MOVEL     #1BICC        MRBICC                         Receiving Branch
     C                   MOVEL     #1BICB        MRBICB                         Transaction Type
     C                   MOVEL     #1AJOB        MRAJOB                         Job name
     C                   MOVEL     #1AACT        MRAACT                         Action Type
     C                   Z-ADD     #1RDNB        MRRDNB                         Run day number
     C                   MOVEL     #1AUSR        MRAUSR                         User name
     C                   MOVEL     #1ARDT        MRARDT                         Action Date
     C                   Z-ADD     #1ATIM        MRATIM                         Action Time
      *
     C                   EVAL      MRPCCY    =   #1PCCY
 
     C                   EVAL      MRRBIC    =   #1RBIC
     C                   EVAL      MRRBIB    =   #1RBIB
     C                   EVAL      MRCOVR    =   #1COVR
     C                   EVAL      MRCFLG    =   #1CFLG
     C                   EVAL      MRRPLC    =   #1RPLC
     C                   EVAL      MRBENR    =   #1BENR
     C                   EVAL      MRBENL    =   #1BENL
     C                   EVAL      MRBENH    =   #1BENH
     C                   EVAL      MRSHAR    =   #1SHAR
     C                   EVAL      MRSHAL    =   #1SHAL
     C                   EVAL      MRSHAH    =   #1SHAH
     C                   EVAL      MROURR    =   #1OURR
     C                   EVAL      MROURL    =   #1OURL
     C                   EVAL      MROURH    =   #1OURH
     C                   EVAL      MRDES1    =   #1DES1
     C                   EVAL      MRDES2    =   #1DES2
     C                   EVAL      MRDES3    =   #1DES3
     C                   EVAL      MRSTAT    =   #1STAT
     C                   EVAL      MRSTDT    =   #1STDT
     C                   EVAL      MRENDT    =   #1ENDT
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      MrRtSq    =   #1RtSq                                       PNL014
     C                   Eval      MrTSDO    =   #1TSDO                                       PNL014
     C                   Eval      MrTSCT    =   #1TSCT                                       PNL014
     C                   Eval      MrTSCD    =   #1TSCD                                       PNL014
     C                   Eval      MrTSCK    =   #1TSCK                                       PNL014
     C                   Eval      MrTSFC    =   #1TSFC                                       PNL014
     C                   Eval      MrTSIS    =   #1TSIS                                       PNL014
     C                   Eval      MrRREF    =   #1RREF                                       PNL014
     C                   Eval      MrTSHC    =   #1TSHC                                       PNL014
     C                   Eval      MrTSHL    =   #1TSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
 
     C                   MOVEL     'D'           MRRECI                         Record Identifi
     C                   MOVEL     ##JOB         MRAJOB                         Job name
     C                   MOVEL     ##USR         MRAUSR                         User name
     C                   Z-ADD     ##JTM         MRATIM                         Action Time
     C                   MOVEL     WUMRDT        MRARDT                         Action Date
     C                   MOVEL     'I'           MRAACT                         Action Type
     C                   Z-ADD     WURDNB        MRRDNB                         Run day number
      *
     C                   MOVEL     #1BICC        MRBICC
     C                   MOVEL     #1BICB        MRBICB
      *
     C                   MOVEL     #1PCCY        MRPCCY
      *
     C                   MOVEL     #1RBIC        MRRBIC
     C                   MOVEL     #1RBIB        MRRBIB
      *
     C     KLCRSA        KLIST
     C                   KFLD                    MRBICC
     C                   KFLD                    MRBICB
     C                   KFLD                    MRPCCY
     C                   KFLD                    MRRBIC
     C                   KFLD                    MRRBIB
      * Write or update
     C                   If        %Found
     C                   Update    @MSCRV0
     C                   Else
      *
     C                   WRITE     @MSCRV0                              91      *
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
      * Move key fields to @MSCRV0
     C                   MOVEL     #1BICC        MRBICC
     C                   MOVEL     #1BICB        MRBICB
     C                   MOVEL     #1PCCY        MRPCCY
     C                   MOVEL     #1RBIC        MRRBIC
     C                   MOVEL     #1RBIB        MRRBIB
      *
     C     KLCHSB        KLIST
     C                   KFLD                    MRBICC
     C                   KFLD                    MRBICB
     C                   KFLD                    MRPCCY
     C                   KFLD                    MRRBIC
     C                   KFLD                    MRRBIB
     C     KLCHSB        CHAIN     @MSCRV0                            9091      *
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
      * Move non-key fields to @MSCRV0
     C                   EVAL      MRCOVR    =   #1COVR
     C                   EVAL      MRCFLG    =   #1CFLG
     C                   EVAL      MRRPLC    =   #1RPLC
     C                   EVAL      MRBENR    =   #1BENR
     C                   EVAL      MRBENL    =   #1BENL
     C                   EVAL      MRBENH    =   #1BENH
     C                   EVAL      MRSHAR    =   #1SHAR
     C                   EVAL      MRSHAL    =   #1SHAL
     C                   EVAL      MRSHAH    =   #1SHAH
     C                   EVAL      MROURR    =   #1OURR
     C                   EVAL      MROURL    =   #1OURL
     C                   EVAL      MROURH    =   #1OURH
     C                   EVAL      MRDES1    =   #1DES1
     C                   EVAL      MRDES2    =   #1DES2
     C                   EVAL      MRDES3    =   #1DES3
     C                   EVAL      MRSTAT    =   #1STAT
     C                   EVAL      MRSTDT    =   #1STDT
     C                   EVAL      MRENDT    =   #1ENDT
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      MrRtSq    =   #1RtSq                                       PNL014
     C                   Eval      MrTSDO    =   #1TSDO                                       PNL014
     C                   Eval      MrTSCT    =   #1TSCT                                       PNL014
     C                   Eval      MrTSCD    =   #1TSCD                                       PNL014
     C                   Eval      MrTSCK    =   #1TSCK                                       PNL014
     C                   Eval      MrTSFC    =   #1TSFC                                       PNL014
     C                   Eval      MrTSIS    =   #1TSIS                                       PNL014
     C                   Eval      MrRREF    =   #1RREF                                       PNL014
     C                   Eval      MrTSHC    =   #1TSHC                                       PNL014
     C                   Eval      MrTSHL    =   #1TSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
 
     C                   MOVEL     #1RECI        MRRECI                         Record Identifi
     C                   MOVEL     #1AJOB        MRAJOB                         Job name
     C                   MOVEL     #1AACT        MRAACT                         Action Type
     C                   Z-ADD     #1RDNB        MRRDNB                         Run day number
     C                   MOVEL     #1AUSR        MRAUSR                         User name
     C                   MOVEL     #1ARDT        MRARDT                         Action Date
     C                   Z-ADD     #1ATIM        MRATIM                         Action Time
      *
     C                   MOVEL     'D'           MRRECI                         Record Identifi
     C                   MOVEL     ##JOB         MRAJOB                         Job name
     C                   MOVEL     ##USR         MRAUSR                         User name
     C                   Z-ADD     ##JTM         MRATIM                         Action Time
     C                   MOVEL     WUMRDT        MRARDT                         Action Date
     C                   MOVEL     'A'           MRAACT                         Action Type
     C                   Z-ADD     WURDNB        MRRDNB                         Run day number
      *
     C                   UPDATE    @MSCRV0                              91      *
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
      * Move key fields to @MSCRV0
     C                   MOVEL     #1BICC        MRBICC
     C                   MOVEL     #1BICB        MRBICB
     C                   MOVEL     #1PCCY        MRPCCY
     C                   MOVEL     #1RBIC        MRRBIC
     C                   MOVEL     #1RBIB        MRRBIB
      *
     C     KLCHSC        KLIST
     C                   KFLD                    MRBICC
     C                   KFLD                    MRBICB
     C                   KFLD                    MRPCCY
     C                   KFLD                    MRRBIC
     C                   KFLD                    MRRBIB
     C     KLCHSC        CHAIN     @MSCRV0                            9091      *
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
     C     KLCHSC        SETLL     @MSCRV0                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before DBF update
     C                   MOVEL     '*'           MRRECI                         Record Identifi
     C                   MOVEL     'D'           MRAACT                         Action Type
      *
     C                   MOVEL     ##JOB         MRAJOB                         Job name
     C                   MOVEL     ##USR         MRAUSR                         User name
     C                   Z-ADD     ##JTM         MRATIM                         Action Time
     C                   MOVEL     WUMRDT        MRARDT                         Action Date
     C                   Z-ADD     WURDNB        MRRDNB                         Run day number
      *
     C                   UPDATE    @MSCRV0                              91      *
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
      * Move key fields to @MSCRV0
     C                   MOVEL     #1BICC        MRBICC
     C                   MOVEL     #1BICB        MRBICB
     C                   MOVEL     #1PCCY        MRPCCY
     C                   MOVEL     #1RBIC        MRRBIC
     C                   MOVEL     #1RBIB        MRRBIB
      *
     C     KLCHSD        KLIST
     C                   KFLD                    MRBICC
     C                   KFLD                    MRBICB
     C                   KFLD                    MRPCCY
     C                   KFLD                    MRRBIC
     C                   KFLD                    MRRBIB
     C     KLCHSD        CHAIN     @MSCRV0                            9091      *
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
     C     KLCHSD        SETLL     @MSCRV0                            9091      *
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      *
      *
      * Move non-key fields to @MSCRV0
     C                   EVAL      MRCOVR    =   #1COVR
     C                   EVAL      MRCFLG    =   #1CFLG
     C                   EVAL      MRRPLC    =   #1RPLC
     C                   EVAL      MRBENR    =   #1BENR
     C                   EVAL      MRBENL    =   #1BENL
     C                   EVAL      MRBENH    =   #1BENH
     C                   EVAL      MRSHAR    =   #1SHAR
     C                   EVAL      MRSHAL    =   #1SHAL
     C                   EVAL      MRSHAH    =   #1SHAH
     C                   EVAL      MROURR    =   #1OURR
     C                   EVAL      MROURL    =   #1OURL
     C                   EVAL      MROURH    =   #1OURH
     C                   EVAL      MRDES1    =   #1DES1
     C                   EVAL      MRDES2    =   #1DES2
     C                   EVAL      MRDES3    =   #1DES3
     C                   EVAL      MRSTAT    =   #1STAT
     C                   EVAL      MRSTDT    =   #1STDT
     C                   EVAL      MRENDT    =   #1ENDT
                                                                                              PNL014
      *---------------------------------------------------------------------                  PNL014
     C                   Eval      MrRtSq    =   #1RtSq                                       PNL014
     C                   Eval      MrTSDO    =   #1TSDO                                       PNL014
     C                   Eval      MrTSCT    =   #1TSCT                                       PNL014
     C                   Eval      MrTSCD    =   #1TSCD                                       PNL014
     C                   Eval      MrTSCK    =   #1TSCK                                       PNL014
     C                   Eval      MrTSFC    =   #1TSFC                                       PNL014
     C                   Eval      MrTSIS    =   #1TSIS                                       PNL014
     C                   Eval      MrRREF    =   #1RREF                                       PNL014
     C                   Eval      MrTSHC    =   #1TSHC                                       PNL014
     C                   Eval      MrTSHL    =   #1TSHL                                       PNL014
      *---------------------------------------------------------------------                  PNL014
                                                                                              PNL014
 
     C                   MOVEL     #1RECI        MRRECI                         Record Identifi
     C                   MOVEL     #1AJOB        MRAJOB                         Job name
     C                   MOVEL     #1AACT        MRAACT                         Action Type
     C                   Z-ADD     #1RDNB        MRRDNB                         Run day number
     C                   MOVEL     #1AUSR        MRAUSR                         User name
     C                   MOVEL     #1ARDT        MRARDT                         Action Date
     C                   Z-ADD     #1ATIM        MRATIM                         Action Time
      *
     C                   MOVEL     'D'           MRRECI                         Record Identifi
     C                   MOVEL     ##JOB         MRAJOB                         Job name
     C                   MOVEL     ##USR         MRAUSR                         User name
     C                   Z-ADD     ##JTM         MRATIM                         Action Time
     C                   MOVEL     WUMRDT        MRARDT                         Action Date
     C                   MOVEL     'A'           MRAACT                         Action Type
     C                   Z-ADD     WURDNB        MRRDNB                         Run day number
      *
     C                   UPDATE    @MSCRV0                              91      *
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
     C                   OPEN      FTMSCRV0
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
