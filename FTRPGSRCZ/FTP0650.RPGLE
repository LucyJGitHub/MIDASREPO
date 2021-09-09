     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0650 - Midas FT STP Payment Corr. Pay Via Maintenance     *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 13Sep11               *
      *  Last Amend No. PNL015             Date 01Dec2005             *
      *                 EEE065 *Amend      Date 25Nov2004             *
      *                 EEE065             Date 31Mar2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  PNL015 - Redirection to head office BIC                      *
      *  PNL015 - Redirection to head office BIC                      *
      *  PNL014 - Time Sensitive Payments                             *
      *  EEE065 - Allow Foreign BICs                                  *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTP0650DF CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Display STP Payment Correspondent
      *
     FFTMSCPV1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : FT STP Payment Correspondent
      *
     FFTMSCCV1  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      * RTV : FT STP Payment Correspondent
      *
     FFTMSCPV0  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      * UPD : FT STP Payment Correspondent  .
      *
     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : SWIFT BIC Directory
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array containing Copyright statement
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array of QCMDEXC commands
      *
     D EDT             S              1    DIM(80)
      *
      *  Array of QCMDEXC command to edit
      *
      *
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
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
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      *
      * Modules Data Structure *
      *
     D DSCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Data Structures for Currency Definition
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
      * O : MAP BIC identifier
     D  P2BICC                 1      8
      * O : MAP BIC Branch identifier
     D  P2BICB                 9     11
      * O : MAP Pay Currency
     D  P2PCCY                12     14
      * Outgoing Parameter declarations
     D O2PARM          DS           256
      * O : MAP BIC identifier
     D  O2BICC                 1      8
      * O : MAP BIC Branch identifier
     D  O2BICB                 9     11
      * O : MAP Pay Currency
     D  O2PCCY                12     14
      * O : MAP BIC identifier
     D  O2CBIC                15     22
      * O : MAP BIC Branch identifier
     D  O2CBIB                23     25
     D O3PARM          DS           256
      * O : MAP BIC identifier
     D  O3BICC                 1      8
      * O : MAP BIC Branch identifier
     D  O3BICB                 9     11
      * O : MAP Pay Currency
     D  O3PCCY                12     14
      * O : MAP BIC identifier
     D  O3CBIC                15     22
      * O : MAP BIC Branch identifier
     D  O3CBIB                23     25
      *
      * Work variables
     D  S#RECI                             Like( MPRECI )
      *
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code'
      * *SFLSEL
     D  ZA0001                 1      1
      *
     D W0DATA          DS           256
      *
      *  Define data structure used to pass parameters
      *
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MPART                 1      2P 0
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D  W#Sel_Pos      S              2
     D  W#Authorise    S              1
      *
     D Digits          S             10    Inz('1234567890')
      *
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         RCD: Incoming V
      *
      *  Set up primary reference
      *
     C                   MOVEL     P2PARM        W0PREF
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise & load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   EXSR      CAEXFM
      * Validate position and selection
     C                   Eval      W#Sel_Pos = 'Ok'
     C                   If        *in03 <> *on and *in12 <> *on
     C                   EXSR      SrValidate
     C                   Endif
      * Process response
     C                   If        W#Sel_Pos = 'Ok'
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   END
     C                   Endif
      *
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
      *================================================================
      *                                                               *
      * SrValidate - Validate position and selection                  *
      *                                                               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      *================================================================
     CSR   SrValidate    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrValidate'  @STK(Q)
      *
      *
      *  Unwind subroutine stack name
      *
     C     ExValidate    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise and load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialise subfile control
      * Position DBF file
     C     KRST          KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY

     C     KPOS          KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
     C                   KFLD                    MPCBIC
      * Setup key
     C                   MOVEL     #2BICC        MPBICC
     C                   MOVEL     #2BICB        MPBICB
     C                   MOVEL     #2PCCY        MPPCCY
     C                   MOVEL     #2CBIC        MPCBIC
     C                   MOVEL     #2CBIB        MPCBIB

     C     KPOS          SETLL     @MSCPV1
     C     KRST          READE     @MSCPV1                              8782    *82=EOF
      * Save previous selector values
     C     *LIKE         DEFINE    #2CBIC        WZCBIC
     C                   MOVEL     #2CBIC        WZCBIC                         BIC (Bank, Country,
      *
     C     *LIKE         DEFINE    #2CBIB        WZCBIB
     C                   MOVEL     #2CBIB        WZCBIB                         BIC Branch
      *
      * Load subfile page
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page
      *================================================================
      * Re-establish fields in read-ahead record
     C   27              DO
     C  N82KRST          READPE    @MSCPV1                                90    *
     C  N82KRST          READE     @MSCPV1                                90    *
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(42)
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      *................................................................
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C     #2CBIC        IFNE      *BLANK
     C     MPCBIC        CABNE     #2CBIC        BB020
     C                   END
      * Check selection fields - if fail, read next record
     C     #2CBIB        IFNE      *BLANK                                       BIC Branch
     C     MPCBIB        CABNE     #2CBIB        BB020                          BIC Branch
     C                   END
      * Load SFL fields
     C                   EXSR      MBFL#1
     C                   EXSR      MC#1FN
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialise subfile record from DBF record
      * DBF record not selected
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
     C                   WRITE     #SFLRCD
      *
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C     KRST          READE     @MSCPV1                                82    *82=EOF
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI ##RR = *ZERO
      *
      *................................................................
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      * If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen
      *================================================================
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8392    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      *
      * CALC: Subfile control function fields
      * Change of position specified
     C     WZCBIC        CASNE     #2CBIC        FBRQRL
     C     WZCBIB        CASNE     #2CBIB        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *
      * CASE: CTL.*CMD key is CF09
      *
      *
      * Call add processing
      *
     C     *IN09         IFEQ      '1'                                          *IF
      *
      * Check user has access to add
      *
     C     *IN09         IFEQ      '1'                                          *IF
     C                   MOVEL     'I'           #1SEL
     C  NU1              EXSR      SRMBIN
      *
      * User does not have access
      *
     C     *IN99         IFEQ      '1'                                          *IF
     C                   GOTO      DAEXIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      *
      * Set up parameters
      *
     C                   Select
     C     *IN09         Wheneq    '1'                                          *IF
     C                   CLEAR                   O2PARM
     C                   Eval      O2BICC = #2BICC
     C                   Eval      O2BICB = #2BICB
     C                   Eval      O2PCCY = #2PCCY
      *
     C                   CALL      'FTP0640'                            9090
     C                   PARM                    P0RTN             7
     C                   PARM      'I'           WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *
     C                   Endsl
      *
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'PR10012'     P0RTN
     C                   END                                                    *FI
      *
      *  Depending on return code - exit or re-display screen
      *
     C                   SELECT                                                *SL
      *
      *  F12 pressed - redisplay subfile
      *
     C     P0RTN         WHENEQ    'USR0790'                                    *IF
     C                   MOVEL     *BLANKS       P0RTN                          *Return code
      *
      * Send message 'F12 taken from previous screen'
      *
     C                   MOVEL     'PR10014'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      DAEXIT
      *
      *  F3 pressed - exit program
      *
     C     P0RTN         WHENEQ    'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *
      *  If error redisplay
      *
     C     P0RTN         WHENNE    *BLANKS                                     *IF
      *
      * Re-display screen
      *
     C                   MOVEL     'PR10012'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DAEXIT
      *
      *  New selection - redisplay subfile
      *
     C     P0RTN         WHENEQ    *BLANKS                                     *IF
     C                   EXSR      FBRQRL
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DAEXIT
     C                   ENDSL                                                 *LS
     C                   ENDIF                                                 *FI
      *
      *
      * USER: Process command keys
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Read first changed slf record
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process subfile record
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
      *================================================================
      *                                                               *
      * SRACTD - Check Action code                                    *
      *                                                               *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *================================================================
     CSR   SRACTD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACTD'      @STK(Q)
      *
      * Check all valid actions
      *
      *
      * CASE: RCD.*SFLSEL is not valid
      *
     C     #1SEL         IFEQ      ' '                                          *IF
     C                   GOTO      EXACTD
     C                   END                                                    *FI
      *
     C     P1ACTC        IFEQ      'A'                                          *IF
     C     #1SEL         ANDNE     'A'                                          *IF
     C     #1SEL         ANDNE     'C'                                          *IF
     C     #1SEL         ANDNE     'R'                                          *IF
     C     #1SEL         ANDNE     'D'                                          *IF
     C     #1SEL         ANDNE     'E'                                          *IF
     C     P1ACTC        OREQ      'E'                                          *IF
     C     #1SEL         ANDNE     'E'                                          *IF
     C     #1SEL         ANDNE     'C'                                          *IF
     C     #1SEL         ANDNE     'R'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'Invalid Action code'
     C                   MOVEL     'PR10015'     ZAMSID
     C                   Movel(p)  'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9842      *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      EXACTD
     C                   END                                                    *FI
      *
      * Check multi-branch actions
      *
     C  NU1              EXSR      SRMBIN
      *
      *  Unwind subroutine stack name
      *
     C     EXACTD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
      *================================================================
      *                                                               *
      * SRMBIN - Check Multi-branch actions                           *
      *                                                               *
      *                                                               *
      * Called by: SRACTD                                             *
      *                                                               *
      *================================================================
     CSR   SRMBIN        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMBIN'      @STK(Q)
      *
      * Set up parameters
      *
     C                   CLEAR                   W0DATA
     C                   MOVEL     *Blanks       B#BRCA
     C                   MOVEL     #1SEL         O#ACTD
     C                   MOVEL     ##PGM         O#CPGM
      *
      * If select then need insert writes
      *
     C                   If        #1Sel = '1'
     C                   MOVEL     'I'           O#ACTD
     C                   Endif
      *
      * Check all valid actions
      *
     C                   CALL      'ME1190'                             9090
     C                   PARM      *BLANKS       P0RTN             7
     C                   PARM      '*ACTCODE'    W0ACT             8
     C                   PARM                    W0DATA
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'PR10012'     P0RTN
     C                   SETON                                        9842      *
     C                   END                                                    *FI
      *
      * Invalid action
      *
     C     P0RTN         IFNE      *BLANKS                                      *IF
     C     #1SEL         IFNE      'I'
     C                   SETON                                        9842      *
     C                   ELSE                                                   *FI
     C                   SETON                                        99        *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *
      *  Unwind subroutine stack name
      *
     C     EXMBIN        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
      *================================================================
      *                                                               *
      * SRRCHG - Record Changed                                       *
      *                                                               *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *================================================================
     CSR   SRRCHG        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRCHG'      @STK(Q)
      *
      * Set up key from subfile record and chain to record
      *
     C     KYMSCPV0      KLIST
     C                   KFLD                    #1BICC                         BIC
     C                   KFLD                    #1BICB
     C                   KFLD                    #1PCCY
     C                   KFLD                    #1CBIC
     C                   KFLD                    #1CBIB
      *
     C     KYMSCPV0      CHAIN     @MSCPV0                            90        *
      *
      * Record not found - database error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'FTMSCPV0'    W0FILE
     C                   Eval      W0Key = #1BICC + #1BICB + #1PCCY +
     C                                     #1CBIC + #1CBIB
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ELSE
     C                   MOVEL     MPRECI        #1RECI
     C                   END
      *
      *  If action code is not blank then send messge record has been
      *  deleted if RECI equal to '*'
      *
     C     #1SEL         IFNE      *BLANKS
     C     MPRECI        IFEQ      '*'
      * Send message 'Invalid Action code - record deleted'
     C                   MOVEL     'PR10016'     ZAMSID
     C                   Movel(p)  'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9842      *
     C                   END
     C                   GOTO      EXRCHG
     C                   END
      *
      *  Reload subfile record
      *
     C                   EXSR      MBFL#1
     C                   EXSR      MC#1FN
      *
      *  Unwind subroutine stack name
      *
     C     EXRCHG        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKIND0        *IN(42)
     C                   MOVEL     *BLANKS       P0RTN
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      *
      * Check action code is valid, if invalid exit.
      *
     C                   EXSR      SRACTD
      *
      * Check record is active
      *
     C                   EXSR      SRRCHG
      *
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
     C                   END                                                    *FI
      *
      * Call option
      *
     C                   SELECT
      *
      * Amend, Delete, Enquire and Confirm
      *
     C                   WHEN      #1Sel = 'E'  or
     C                             #1Sel = 'A'  or
     C                             #1Sel = 'D'
      *
      * Set up parameters
      *
     C                   Clear                   O2PARM
     C                   Eval      O2BICC = #1BICC
     C                   Eval      O2BICB = #1BICB
     C                   Eval      O2PCCY = #1PCCY
     C                   Eval      O2CBIC = #1CBIC
     C                   Eval      O2CBIB = #1CBIB
      *
     C                   CALL      'FTP0640'                            9090
     C                   PARM                    P0RTN             7
     C                   PARM      #1Sel         WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *                                                                                  MKCHANGE
     C                   If        P0RTN <> *Blanks
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ENDIF
      *
      * Correspondent
      *
     C                   WHEN      #1Sel = 'C'
      *
     C                   Clear                   O2PARM
     C                   Eval      O2BICC = #1BICC
     C                   Eval      O2BICB = #1BICB
     C                   Eval      O2PCCY = #1PCCY
      *
     C                   If        P1ACTC = 'A'
     C                   Eval      WP0001 = 'A'
     C                   Else
     C                   Eval      WP0001 = 'E'
     C                   Endif
      *
     C                   CALL      'FTP0680'                            9090
     C                   PARM                    P0RTN             7
     C                   PARM                    WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *                                                                                  MKCHANGE
     C                   If        P0RTN <> *Blanks
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ENDIF
      *
      * Route Correspondent
      *
     C                   WHEN      #1Sel = 'R'
      *
      * Check existence
      *
     C     KMsccV1       Klist
     C                   Kfld                    McBicc
     C                   Kfld                    McBicB
     C                   Kfld                    McPCcy
      *
     C                   Eval      McBICC = #1CBIC
     C                   Eval      McBICB = #1CBIB
     C                   Eval      McPCCY = #1PCCY
      *
     C     KMsccV1       Chain     @MsccV1
     C                   If        Not %Found
      *
      * No correspondent information
     C                   MOVEL     'PR10188'     ZAMSID
     C                   Movel(p)  'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9842      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
     C                   Else
      *
     C                   Clear                   O2PARM
     C                   Eval      O2BICC = #1CBIC
     C                   Eval      O2BICB = #1CBIB
     C                   Eval      O2PCCY = #1PCCY
      *
     C                   If        P1ACTC = 'A'
     C                   Eval      WP0001 = 'A'
     C                   Else
     C                   Eval      WP0001 = 'E'
     C                   Endif
      *
     C                   CALL      'FTP0680'                            9090
     C                   PARM                    P0RTN             7
     C                   PARM                    WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *                                                                                  MKCHANGE
     C                   If        P0RTN <> *Blanks
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ENDIF
      *
     C                   Endif
      *
     C                   ENDSL
      *
      * If in error set up return code
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'PR10012'     P0RTN
     C                   END
      *
      *  Depending on return code - exit or re-display screen
      *
     C                   SELECT                                                 *SL
      *
      *  F12 pressed - redisplay subfile
      *
     C     P0RTN         WHENEQ    'USR0790'                                    *IF
      *
      * Send message 'F12 taken from previous screen'
      *
     C                   MOVEL     'PR10014'     ZAMSID
     C                   Movel(p)  'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9842      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
      *
      *  F3 pressed - exit program
      *
     C     P0RTN         WHENEQ    'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *
      *  If error redisplay
      *
     C     P0RTN         WHENNE    *BLANKS                                      *IF
      *
      * Re-display screen
      *
     C                   MOVEL     'PR10012'     ZAMSID
     C                   Movel(p)  'FTUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9842      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
      *
      *  Function completed normally
      *
     C     P0RTN         WHENEQ    *BLANKS                                      *IF
     C                   ENDSL                                                  *LS
      *
     C     DCENDT        TAG
     C     *IN98         IFEQ      '1'
      * SFLRCD invalid
     C  N99              Z-ADD     ##RR          ##SFRC               99        *
      * SFLNXTCHG
     C                   SETON                                        84
     C                   ELSE
      * SFLRCD valid
      * SFLNXTCHG
     C                   SETOFF                                       84
     C                   MOVEL     *BLANK        #1SEL
     C                   END                                                    FI *IN98
      *
      *  If option did not end in error, F12 or F3 then update record
      *  with changes
      *
     C     P0RTN         IFEQ      *BLANKS
     C     *IN98         ANDEQ     '0'
     C                   EXSR      SRRCHG
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @MSCPV1 fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL

     C                   MOVEL     MPRECI        #1RECI
     C                   MOVEL     MPBICC        #1BICC
     C                   MOVEL     MPBICB        #1BICB
     C                   MOVEL     MPPCCY        #1PCCY

      *---------------------------------------------------------------------
      * Correspondent Payment Re-Route
     C                   Eval      #1CBIC    =   MPCBIC
     C                   Eval      #1CBIB    =   MPCBIB
     C                   Eval      #1RCAU    =   MPRCAU
     C                   Eval      #1RCAC    =   MPRCAC
     C                   Eval      #1C53C    =   MPC53C
     C                   Eval      #1C53B    =   MPC53B
     C                   Eval      #1C53A    =   MPC53A
     C                   Eval      #1C53R    =   MPC53R
     C                   Eval      #1SERP    =   MPSERP
     C                   Eval      #1SLVP    =   MPSLVP
     C                   Eval      #1SREG    =   MPSREG
     C                   Eval      #1FBIC    =   MPFBIC
     C                   Eval      #1RHOB    =   MPRHOB                                       PNL015
     C                   Eval      #1SOUR    =   MPSOUR
     C                   Eval      #1C54C    =   MPC54C
     C                   Eval      #1C54B    =   MPC54B
     C                   Eval      #1C56C    =   MPC56C
     C                   Eval      #1C56B    =   MPC56B
     C                   Eval      #1SCHR    =   MPSCHR
     C                   Eval      #1SCHL    =   MPSCHL
     C                   Eval      #1SCHH    =   MPSCHH
     C                   Eval      #1SCHC    =   MPSCHC
     C                   Eval      #1DES1    =   MPDES1
     C                   Eval      #1DES2    =   MPDES2
     C                   Eval      #1DES3    =   MPDES3
     C                   Eval      #1Pcor    =   MPPcor
     C                   Eval      #1Pbcr    =   MPPbcr
     C                   Eval      #1Pscr    =   MPPscr
     C                   Eval      #1Pocr    =   MPPocr
     C                   Eval      #1Ppct    =   MPPpct
     C                   Eval      #1Pnbr    =   MPPnbr
     C                   Eval      #1Pbpt    =   MPPbpt
     C                   Eval      #1Pbnb    =   MPPbnb
     C                   Eval      #1Pspt    =   MPPspt
     C                   Eval      #1Psnb    =   MPPsnb
     C                   Eval      #1Popt    =   MPPopt
     C                   Eval      #1Ponb    =   MPPonb
     C                   Eval      #1Preg    =   MPPreg
     C                   Eval      #1Prpc    =   MPPrpc
     C                   Eval      #1Prnb    =   MPPrnb
     C                   Eval      #1Plvp    =   MPPlvp
     C                   Eval      #1Plpc    =   MPPlpc
     C                   Eval      #1Plnb    =   MPPlnb
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
      *---------------------------------------------------------------------
     C                   Eval      #1R910    =   MPR910
     C                   Eval      #1STMT    =   MPSTMT
      *---------------------------------------------------------------------
      * Active Dates
     C                   Eval      #1STAT    =   MPSTAT
     C                   Eval      #1STDT    =   MPSTDT
     C                   Eval      #1ENDT    =   MPENDT
                                                                                              PNL014
      * Time Sensitive Routing                                                                PNL014
     C                   Eval      #1RTSQ    =   MPRTSQ                                       PNL014
     C                   Eval      #1TSDO    =   MPTSDO                                       PNL014
     C                   Eval      #1TSCT    =   MPTSCT                                       PNL014
     C                   Eval      #1TSCD    =   MPTSCD                                       PNL014
     C                   Eval      #1TSCK    =   MPTSCK                                       PNL014
     C                   Eval      #1TSHC    =   MPTSHC                                       PNL014
     C                   Eval      #1TSHL    =   MPTSHL                                       PNL014
     C                   Eval      #1TSFC    =   MPTSFC                                       PNL014
     C                   Eval      #1TSIS    =   MPTSIS                                       PNL014
     C                   Eval      #1RREF    =   MPRREF                                       PNL014
     C                   Eval      #1TSIS8   =   %Subst(MpTsIs:1:8)                           PNL014
                                                                                              PNL014
      *---------------------------------------------------------------------

     C                   MOVEL     MPAJOB        #1AJOB                         Job name
     C                   MOVEL     MPAUSR        #1AUSR                         User name
     C                   Z-ADD     MPATIM        #1ATIM                         Action Time
     C                   MOVEL     MPARDT        #1ARDT                         Action Date
     C                   MOVEL     MPAACT        #1AACT                         Action Type
     C                   Z-ADD     MPRDNB        #1RDNB                         Run day number
      *
      * If deleted stop subfile selection and place deleted in
      * access point
      *
     C     #1RECI        IFEQ      '*'                                          Record Identifi
     C                   MOVEL     *BLANKS       #1DES1
     C                   MOVEL     U#DELT        #1DES1
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   GOTO      MBEXIT
     C                   END
      *
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MC#1FN        BEGSR
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
      *
      * Initialise header and footer fields
      *
     C                   MOVEL     *BLANK        ##ONAM                         Option Name
     C                   MOVEL     *BLANK        ##CMD1                         CMD Line 1
     C                   MOVEL     *BLANK        ##CMD2                         CMD Line 2
      *
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     P2BICC        #2BICC
     C                   MOVEL     P2BICB        #2BICB
     C                   MOVEL     P2PCCY        #2PCCY
     C                   MOVEL     *Blanks       #2CBIC
     C                   MOVEL     *Blanks       #2CBIB
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
     C                   PARM      'PR10056'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10186'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10019'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
     C                   MOVEL     '1'           *IN78
      *
      * Update screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10057'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10187'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10022'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Allow function key 9
      *
     C                   MOVEL     '1'           *IN77
     C                   MOVEL     '1'           *IN78
      *
     C                   ENDSL
      *
      * Get deleted text
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10011'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C     *LIKE         DEFINE    #1DES1        U#DELT
     C                   MOVEL     #MSTX1        U#DELT
      * Define key
     C     KBICD         Klist                                                  IF
     C                   Kfld                    BDBICC                         IF
     C                   Kfld                    BDBICB                         IF
      * Set key
     C                   Eval      BDBICC = #2BICC
     C                   Eval      BDBICB = #2BICB
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   Clear                   #2INS1                         IF
     C                   If        Not %Found
     C                   Eval      BDBICB = 'XXX'
      * Get data
     C     KBICD         Chain     @BICDL2                                      IF
     C                   If        %Found
     C                   Eval      #2INS1 = BDINS1
     C                   Endif
     C                   Else
     C                   Eval      #2INS1 = BDINS1
     C                   Endif
      *================================================================
     CSR   MEEXIT        ENDSR
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
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
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
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      *
      * Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      *
      * Terminate program
     C                   SETON                                        LR
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
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'FTUSRMSG'    ZADFMF           10
     C                   Z-ADD     11            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      *................................................................
     C                   MOVEL     *BLANK        W0GRP             1
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEA     '00'          *IN(77)
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
      * Set multi-branch indicator
      *
     C     WUMBIN        IFNE      'Y'                                          Multi Branched ?
     C                   MOVEL     '1'           *IN70
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
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Open file FTMSCPV1
      *
     C     FIL001        IFEQ      *BLANKS
      *
      *  Override file FTMSCPV1 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'FTMSCPV1'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      FTMSCPV1
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *
      * Open file FTMSCPV0
      *
     C     FIL002        IFEQ      *BLANKS
      *
      *  Override file FTMSCPV0 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'FTMSCPV0'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      FTMSCPV0
     C                   MOVEL     'Y'           FIL002            1
     C                   END
      *
      * Open file FTMSCCV1
      *
     C     FIL003        IFEQ      *BLANKS
      *
      *  Override file FTMSCCV1 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'FTMSCCV1'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      FTMSCCV1
     C                   MOVEL     'Y'           FIL003            1
     C                   END
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO)
