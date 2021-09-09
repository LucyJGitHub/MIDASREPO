     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP1080 - Midas FX Preferential Rates relationship           *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 13Sep11               *
      *  Last Amend No. EEE065             Date 16Nov2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTP1080DF CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Display Clearing Account Cross-Reference
      *
     FFTFxGpV1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : FX Preferential Rates
      *
     FFTFxGpV0  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      * UPD : FX Preferential Rates
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
      * O : MAP Set Number
     D  P2SNBR                             Like(GPSNBR)
      * O : MAP Customer Group
     D  P2GPCD                             Like(GPGPCD)
      * O : MAP STP Rate
     D  P2STPR                             Like(GPSTPR)
      * O : MAP STP Rate
     D  P2CYCD                             Like(GPCYCD)
      * Outgoing Parameter declarations
     D O2PARM          DS           256
      * O : MAP Set Number
     D  O2SNBR                             Like(GPSNBR)
      * O : MAP Customer Group
     D  O2GPCD                             Like(GPGPCD)
      * O : MAP STP Rate
     D  O2STPR                             Like(GPSTPR)
      * O : MAP STP Rate
     D  O2CYCD                             Like(GPCYCD)
      *
      * Work variables
     D  S#RECI                             Like( GPRECI )
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
     C     KPOS          KLIST
     C                   KFLD                    GpSnbr
     C                   KFLD                    GpGpCd
      * Setup key
     C                   MOVEL     #2Snbr        GpSnbr
     C                   MOVEL     #2GpCd        GpGpCd
     C     KPOS          SETLL     @FxGpV1
     C                   READ      @FxGpV1                              8782    *82=EOF
      * Save previous selector values
     C     *LIKE         DEFINE    #2Snbr        WZSnbr
     C                   MOVEL     #2Snbr        WZSnbr
      *
     C     *LIKE         DEFINE    #2GpCd        WZGpCd
     C                   MOVEL     #2GpCd        WZGpCd
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
     C  N82              READP     @FxGpV1                                82    *82=EOF
     C  N82              READ      @FxGpV1                                82    *82=EOF
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
     C                   READ      @FxGpV1                              8782    *82=EOF
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
     C     WZSnbr        CASNE     #2Snbr        FBRQRL
     C     WZGpCd        CASNE     #2GpCd        FBRQRL
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
      *
     C                   CALL      'FTP1085'                            9090
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
     C     #1SEL         ANDNE     'D'                                          *IF
     C     #1SEL         ANDNE     'E'                                          *IF
     C     P1ACTC        OREQ      'E'                                          *IF
     C     #1SEL         ANDNE     'E'                                          *IF
     C     P1ACTC        OREQ      'S'                                          *IF
     C     #1SEL         ANDNE     '1'                                          *IF
     C     #1SEL         ANDNE     'E'                                          *IF
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
     C     KYFxGpV0      KLIST
     C                   KFLD                    #1Snbr
     C                   KFLD                    #1GpCd
     C                   KFLD                    #1Stpr
     C                   KFLD                    #1CyCd
      *
     C     KYFxGpV0      CHAIN     @FxGpV0                            90        *
      *
      * Record not found - database error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'FTFxGpV0'    W0FILE
     C                   Eval      W0Key = #1Snbr + #1GpCd + #1Stpr + #1Cycd
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ELSE
     C                   MOVEL     GpRECI        #1RECI
     C                   END
      *
      *  If action code is not blank then send messge record has been
      *  deleted if RECI equal to '*'
      *
     C     #1SEL         IFNE      *BLANKS
     C     GpRECI        IFEQ      '*'
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
      *  If action code is 1 then return with selected batch
      *
     C     #1SEL         IFEQ      '1'
     C                   Clear                   P2parm
     C                   Eval      P2Snbr = #1Snbr
     C                   Eval      P2GpCd = #1GpCd
     C                   Eval      P2Stpr = #1Stpr
     C                   Eval      P2CyCd = #1CyCd
     C                   Eval      P0RTN = 'Selectd'
      * Terminate program
     C                   EXSR      ZXEXPG
     C                   Endif
      *
      * Call option
      *
     C                   SELECT
      *
      * Amend, Delete, Enquire
      *
     C                   WHEN      #1Sel = 'E'  or
     C                             #1Sel = 'A'  or
     C                             #1Sel = 'D'
      *
      * Set up parameters
      *
     C                   Clear                   O2PARM
     C                   Eval      O2Snbr = #1Snbr
     C                   Eval      O2GpCd = #1GpCd
     C                   Eval      O2Stpr = #1Stpr
     C                   Eval      O2CyCd = #1CyCd
      *
     C                   CALL      'FTP1085'                            9090
     C                   PARM                    P0RTN             7
     C                   PARM      #1Sel         WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *                                                                                  MKCHANGE
     C                   If        P0RTN <> *Blanks
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ENDIF
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
      * Move @FxGpV1 fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL

     C                   MOVEL     GpRECI        #1RECI

     C                   MOVEL     GpSnbr        #1Snbr
     C                   MOVEL     GpGpCd        #1GpCd
     C                   MOVEL     GpStpr        #1Stpr
     C                   MOVEL     GpCyCd        #1CyCd
     C                   MOVEL     GpQccy        #1Qccy

     C                   MOVEL     GpLAM1        #1LAM1
     C                   MOVEL     GpFXS1        #1FXS1
     C                   MOVEL     GpDLR1        #1DLR1

     C                   MOVEL     GpLAM2        #1LAM2
     C                   MOVEL     GpFXS2        #1FXS2
     C                   MOVEL     GpDLR2        #1DLR2

     C                   MOVEL     GpLAM3        #1LAM3
     C                   MOVEL     GpFXS3        #1FXS3
     C                   MOVEL     GpDLR3        #1DLR3

     C                   MOVEL     GpLAM4        #1LAM4
     C                   MOVEL     GpFXS4        #1FXS4
     C                   MOVEL     GpDLR4        #1DLR4

     C                   MOVEL     GpLAM5        #1LAM5
     C                   MOVEL     GpFXS5        #1FXS5
     C                   MOVEL     GpDLR5        #1DLR5

     C                   MOVEL     GpLAM6        #1LAM6
     C                   MOVEL     GpFXS6        #1FXS6
     C                   MOVEL     GpDLR6        #1DLR6

     C                   MOVEL     GpLAM7        #1LAM7
     C                   MOVEL     GpFXS7        #1FXS7
     C                   MOVEL     GpDLR7        #1DLR7

     C                   MOVEL     GpLAM8        #1LAM8
     C                   MOVEL     GpFXS8        #1FXS8
     C                   MOVEL     GpDLR8        #1DLR8

     C                   MOVEL     GpLAM9        #1LAM9
     C                   MOVEL     GpFXS9        #1FXS9
     C                   MOVEL     GpDLR9        #1DLR9

     C                   MOVEL     GpDES1        #1DES1
     C                   MOVEL     GpDES2        #1DES2
     C                   MOVEL     GpDES3        #1DES3

     C                   MOVEL     GpAJOB        #1AJOB                         Job name
     C                   MOVEL     GpAUSR        #1AUSR                         User name
     C                   Z-ADD     GpATIM        #1ATIM                         Action Time
     C                   MOVEL     GpARDT        #1ARDT                         Action Date
     C                   MOVEL     GpAACT        #1AACT                         Action Type
     C                   Z-ADD     GpRDNB        #1RDNB                         Run day number
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
     C                   MOVEL     P2SNBR        #2Snbr
     C                   MOVEL     P2GpCd        #2GpCd
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
     C                   PARM      'PR10276'     #MSGID
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
     C                   PARM      'PR10018'     #MSGID
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
     C                   PARM      'PR10277'     #MSGID
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
     C                   PARM      'PR10021'     #MSGID
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
      * Select screen
      *
     C     P1ACTC        WHENEQ    'S'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'PR10278'     #MSGID
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
     C                   PARM      'PR10041'     #MSGID
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
     C                   PARM      'PR10007'     #MSGID
     C                   PARM      'FTUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      * Allow F12
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
     C                   Z-ADD     12            ##SFPG            3 0          SFLPAG
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
      * Open file FTFxGpV1
      *
     C     FIL001        IFEQ      *BLANKS
      *
      *  Override file FTMSTVV1 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'FTFxGpV1'    U#FILE           10
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
     C                   OPEN      FTFxGpV1
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *
      * Open file FTFxGpV0
      *
     C     FIL002        IFEQ      *BLANKS
      *
      *  Override file FTMSTVV0 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'FTFxGpV0'    U#FILE           10
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
     C                   OPEN      FTFxGpV0
     C                   MOVEL     'Y'           FIL002            1
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
