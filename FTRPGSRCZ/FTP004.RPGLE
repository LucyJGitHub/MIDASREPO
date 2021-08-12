     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT STP Payment Charges Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0004 - Midas FT STP Payment Charges Maintenance           *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 ESL038 *Create     Date 16Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTP004DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Display STP Payment Charges
      *
     FFTPAYY1   IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
     F                                     RENAME(FTPAYX0F:FTPAYX1F)
      * RTV : FT STP Payment Charges
      *
     FFTPAYY0   IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      * UPD : FT STP Payment Charges
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
      *
      * ABO Define LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      * Get Rundate - Rundate  *
      *
     D DSBANK        E DS                  EXTNAME(SDBANKPD)
      * Data Structures for Bank Definition
      *
     D DSCURR        E DS                  EXTNAME(SDCURRPD)
      * Data Structures for Currency Definition
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Data Structures used by Access Programs
      *
      /EJECT
      *
      * Parameter declarations
     D P1Parm          DS
     D  P1ACTC                 1      1
      *
     D P2Parm          DS           256
     D  P2PREF                 1     15
      *
      * Work variables
     D  S#RECI                             Like( X1RECI )
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
     C                   Parm                    P0RTN             7
     C     P1ACTC        Parm                    WP0001            1            Action Code
     C                   Parm                    P2Parm                         RCD: Incoming V
      *
      *  Set up primary reference
      *
     C                   MoveL     P2Parm        W0PREF
      *****************************************************************
      * Initialise
     C                   Exsr      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise & load subfile page
     C                   Exsr      BAIZSF
     C                   MoveL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   Exsr      CAEXFM
      * Validate position and selection
     C                   Eval      W#Sel_Pos = 'Ok'
     C                   If        *in03 <> *on and *in12 <> *on
     C                   Exsr      SrValidate
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
     C                   End
     C                   EndIf
      *
     C                   EndDo                                                  OD W0RSF
     C                   EndDo                                                  OD *HIVAL
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
     CSR   SrValidate    BegSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MoveL     'SrValidate'  @STK(Q)
      *
      * Charge Ccy must be valid if entered
     C                   If        #2CCCY <> *blanks
      *
     C                   Call      'AOCURRR0'                           9090
     C                   Parm      *BLANKS       P@RTCD            7            B:Return code
     C                   Parm      '*KEY   '     P@OPTN            7            I:Option
     C                   Parm      #2CCCY        P@CCY             3            I:Currency
     C     DSCURR        Parm      *BLANKS       DSSDY
 
     C                   If        P@RTCD <> *blanks
     C                   Eval      W#Sel_Pos = *blanks
     C                   SetOn                                        32        *
     C                   MoveL     'FTP0007'     ZAMSID
     C                   MoveL     'FTUSRMSG'    ZAMSGF
     C                   MoveL     #2CCCY        ZAMSDA
     C                   Exsr      ZASNMS
     C                   Endif
     C                   Endif
      *
      * Date Sent must be a valid date
     C                   If        #2DATS <> *blanks
 
     C                   Movel     #2DATS        ZDATE
     C                   CallB     'ZDATE1'
     C                   Parm                    ZDATE             6
     C                   Parm      *ZERO         SelDate           5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
 
     C                   If        ErrorFlag = 'Y'
     C                   Eval      W#Sel_Pos = *blanks
     C                   SetOn                                        33        *
     C                   MoveL     'FTP0006'     ZAMSID
     C                   MoveL     'FTUSRMSG'    ZAMSGF
     C                   MoveL     #2DATS        ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
     C                   Movel     SelDate       ULDATS            5 0
     C                   Endif
     C                   Endif
      *
      *  Unwind subroutine stack name
     C                   MoveA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 EndSR
      /EJECT
     CSR   BAIZSF        BegSR
      *================================================================
      * Initialise and load subfile page
      *================================================================
      * Clear subfile
     C                   SetOn                                        80
     C                   Write     #SFLCTL
     C                   SetOff                                       80
      * Reset no of records in subfile
     C                   Z-Add     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialise subfile control
      * Position DBF file
     C     KPOS          KList
     C                   KFld                    X1PREF                         Payment Reference
      * Setup key
     C                   MoveL     #2PREF        X1PREF
     C     KPOS          SetLL     FTPAYX1F
     C                   Read      FTPAYX1F                             8782    *82=EOF
      *
      * Save previous selector values
     C     *LIKE         Define    #2PREF        WZPREF
     C                   MoveL     #2PREF        WZPREF                         Payment Reference
      *
     C     *LIKE         Define    #2CCCY        WZCCCY
     C                   MoveL     #2CCCY        WZCCCY                         Charge Currency
      *
     C     *LIKE         Define    #2DATS        WZDATS
     C                   MoveL     #2DATS        WZDATS                         Date Sent
      *
      * Load subfile page
     C                   Z-Add     0             ##RROK            5 0
     C                   Exsr      BBLDSF
      *================================================================
     CSR   BAEXIT        EndSR
      /EJECT
     CSR   BBLDSF        BegSR
      *================================================================
      * Load subfile page
      *================================================================
      * Re-establish fields in Read-ahead record
     C   27              DO
     C  N82              ReadP     FTPAYX1F                               90    *
     C  N82              Read      FTPAYX1F                               90    *
     C                   EndDo
      *
      * Setof record error indicators
     C                   MoveL     *ALL'0'       WKIND0            1
     C                   MoveA     WKIND0        *IN(42)
      * Start at previous highest record in SFL
     C                   Z-Add     ##RRMX        ##RR              5 0
      * Reset count of DBF records Read
     C                   Z-Add     0             ##RRRD            5 0
      *................................................................
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
      *                                                                                       ESL038
      * Only output records which are flagged for MT199 generation                            ESL038
     C     X1M199        CABNE     'Y'           BB020                                        ESL038
      *
      * Check selection fields - if fail, Read next record
     C     #2DATS        IFNE      *BLANK
     C     X1DATS        CABNE     ULDATS        BB020
     C                   EndIf
      *
     C     #2CCCY        IFNE      *BLANK
     C     X1CCCY        CABNE     #2CCCY        BB020
     C                   EndIf
      *
      * Load SFL fields
     C                   Exsr      MBFL#1
     C                   MoveL     'Y'           W0RSL             1
      * USER: Initialise subfile record from DBF record
      * DBF record not selected
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
     C                   Write     #SFLRCD
      *
     C     BB020         Tag
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C                   Read      FTPAYX1F                               82    *82=EOF
     C                   EndDo                                                  OD 1 - ##SFPG
      *................................................................
      * If no DBF records found, display error message
     C                   MoveL     *Blanks       ULRECS            6
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MoveL     'Y2U0008'     ZAMSID
     C                   MoveL     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   MoveL     'NoRecs'      ULRECS
     C                   EndIf                                                  FI ##RR = *ZERO
      *
      *................................................................
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-Add     ##RR          ##RRMX
     C                   EndIf
      * If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MoveL     'Y2U0017'     ZAMSID
     C                   MoveL     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   Else
     C                   Z-Add     0             ##RROK
     C                   EndIf
      *================================================================
     CSR   BBEXIT        EndSR
      /EJECT
     CSR   CAEXFM        BegSR
      *================================================================
      * Display screen
      *================================================================
     C                   Move      *ALL'0'       ##OFF            30
     C                   MoveA     ##OFF         *IN(1)
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SetOn                                        86
     C     *IN81         IFNE      CAIN81
     C                   SetOff                                       86
     C                   EndIf
     C                   Move      *IN81         CAIN81            1
     C                   Write     #MSGCTL
     C                   Write     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-Add     @#SFRC        ##SFRC
     C                   EndIf
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MoveL     'Y'           ZAFSMS            1      99    *
     C                   SetOff                                         8392    *
      *================================================================
     CSR   CAEXIT        EndSR
      /EJECT
     CSR   DAPR##        BegSR
      *================================================================
      * Process screen input
      *================================================================
      *
      * Confirm/update is not deferred
     C                   MoveL     'N'           W0DCF             1
      *
      * CALC: Subfile control function fields
      * Change of position specified
     C     WZPREF        CASNE     #2PREF        FBRQRL
     C     WZDATS        CASNE     #2DATS        FBRQRL
     C     WZCCCY        CASNE     #2CCCY        FBRQRL
     C                   End
      * USER: Process subfile control (Pre-confirm)
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   Exsr      DBPRSF
     C                   EndIf
      * USER: Final processing (Pre-confirm)
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *
      *  New selection - redisplay subfile
     C     P0RTN         IFEQ      *BLANKS                                     *IF
     C                   Exsr      FBRQRL
     C                   MoveL     'Y'           W0DCF
     C                   EndIf                                                 *FI
      *
      * USER: Process command keys
      *================================================================
     CSR   DAEXIT        EndSR
      /EJECT
     CSR   DBPRSF        BegSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Read first changed slf record
     C                   ReadC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process subfile record
     C                   Exsr      DCPRSR
     C                   Update    #SFLRCD
     C                   ReadC     #SFLRCD                                92    *
     C                   EndDo
      *================================================================
     CSR   DBEXIT        EndSR
      /EJECT
      *================================================================
      *                                                               *
      * SRACTD - Check Action code                                    *
      *                                                               *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *================================================================
     CSR   SRACTD        BegSR
      *
      *  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MoveL     'SRACTD'      @STK(Q)
      *
      * Check all valid actions
      *
      * CASE: RCD.*SFLSEL is not valid
     C     #1SEL         IFEQ      ' '                                          *IF
     C                   Goto      EXACTD
     C                   EndIf                                                  *FI
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
     C                   MoveL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'Invalid Action code'
     C                   MoveL     'FTP0010'     ZAMSID
     C                   Movel(p)  'FTUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   SetOn                                        9842      *
      *
     C                   MoveL     'Y'           W0DCF                          *Defer confirm
     C                   Goto      EXACTD
     C                   EndIf                                                  *FI
      *
      * Check multi-branch actions
     C  NU1              Exsr      SRMBIN
      *
      *  Unwind subroutine stack name
      *
     C     EXACTD        Tag
     C                   MoveA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 EndSR
      /EJECT
      *================================================================
      *                                                               *
      * SRMBIN - Check Multi-branch actions                           *
      *                                                               *
      *                                                               *
      * Called by: SRACTD                                             *
      *                                                               *
      *================================================================
     CSR   SRMBIN        BegSR
      *
      *  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MoveL     'SRMBIN'      @STK(Q)
      *
      * Set up parameters
     C                   CLEAR                   W0DATA
     C                   MoveL     *Blanks       B#BRCA
     C                   MoveL     #1SEL         O#ACTD
     C                   MoveL     ##PGM         O#CPGM
      *
      * If select then need insert Writes
     C                   If        #1Sel = '1'
     C                   MoveL     'I'           O#ACTD
     C                   Endif
      *
      * Check all valid actions
     C                   Call      'ME1190'                             9090
     C                   Parm      *BLANKS       P0RTN             7
     C                   Parm      '*ACTCODE'    W0ACT             8
     C                   Parm                    W0DATA
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MoveL     'FTP0009'     P0RTN
     C                   SetOn                                        9842      *
     C                   EndIf                                                  *FI
      *
      * Invalid action
     C     P0RTN         IFNE      *BLANKS                                      *IF
     C     #1SEL         IFNE      'I'
     C                   SetOn                                        9842      *
     C                   Else                                                   *FI
     C                   SetOn                                        99        *
     C                   EndIf                                                  *FI
     C                   EndIf                                                  *FI
      *
      *  Unwind subroutine stack name
     C     EXMBIN        Tag
     C                   MoveA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 EndSR
      /EJECT
      *================================================================
      *                                                               *
      * SRRCHG - Record Changed                                       *
      *                                                               *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *================================================================
     CSR   SRRCHG        BegSR
      *
      *  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MoveL     'SRRCHG'      @STK(Q)
      *
      * Set up key from subfile record and chain to record
     C     KYFTPAY       KList
     C                   KFld                    #1PREF                         Payment Reference
      *
     C     KYFTPAY       CHAIN     FTPAYY0                            90        *
      *
      * Record not found - database error
      *
     C     *IN90         IFEQ      '1'
     C                   MoveL     'FTPAYY0 '    W0FILE
     C                   Eval      W0Key = #1PREF
     C                   Z-Add     1             W0ERNB
     C                   MoveL     'MEM5004'     W0MSGD
     C                   MoveL     'MIDAS  '     W0MSGF
     C                   Exsr      SRERR
     C                   Else
     C                   MoveL     X1RECI        #1RECI
     C                   EndIf
      *
      *  If action code is not blank then send messge record has been
      *  deleted if RECI equal to '*'
     C     #1SEL         IFNE      *BLANKS
     C     X1RECI        IFEQ      '*'
      * Send message 'Invalid Action code - record deleted'
     C                   MoveL     'FTP0011'     ZAMSID
     C                   Movel(p)  'FTUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   SetOn                                        9842      *
     C                   EndIf
     C                   Goto      EXRCHG
     C                   EndIf
      *
      *  Reload subfile record
     C                   Exsr      MBFL#1
      *
      *  Unwind subroutine stack name
     C     EXRCHG        Tag
     C                   MoveA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 EndSR
      /EJECT
     CSR   DCPRSR        BegSR
      *================================================================
      * Process subfile record
      *================================================================
      * Setof error indicators and SFLNXTCHG
     C                   MoveA     WKIND0        *IN(42)
     C                   MoveL     *BLANKS       P0RTN
     C                   SetOff                                       98        *
      * USER: Process subfile record (Pre-confirm)
      *
      * Check action code is valid, if invalid exit.
     C                   Exsr      SRACTD
      *
      * Check record is active
     C                   Exsr      SRRCHG
      *
     C     *IN98         IFEQ      '1'
     C                   MoveL     'Y'           W0DCF                          *Defer confirm
     C                   Goto      DCENDT                                       *QUIT
     C                   EndIf                                                  *FI
      *
      *  If action code is 1 then return with selected batch
     C     #1SEL         IFEQ      '1'
     C                   Clear                   P2Parm
     C                   Eval      P2PREF = #1PREF
      * Terminate program
     C                   Exsr      ZXEXPG
     C                   Endif
      *
      * Call option
     C                   SELECT
      *
      * Amend, Delete, Enquire and Confirm
     C                   WHEN      #1Sel = 'E'  or
     C                             #1Sel = 'A'  or
     C                             #1Sel = 'D'
      *
      * Set up parameters
     C                   Eval      P2PREF = #1PREF
      *
     C                   Call      'FTP002'                             9090
     C                   Parm                    P0RTN             7
     C                   Parm      #1Sel         WP0001            1            Action Code
     C                   Parm                    P2PREF                         KEY: Incoming M
      *                                                                                  MKCHANGE
     C                   If        P0RTN <> *Blanks
     C                   MoveL     'Y'           W0DCF                          *Defer confirm
     C                   ENDIF
      *
     C                   ENDSL
      *
      * If in error set up return code
     C     *IN90         IFEQ      '1'
     C                   MoveL     'FTP0009'     P0RTN
     C                   EndIf
      *
      *  Depending on return code - exit or re-display screen
     C                   SELECT                                                 *SL
      *
      *  F12 pressed - redisplay subfile
     C     P0RTN         WHENEQ    'USR0790'                                    *IF
     C                   MoveL     'FTP0008'     ZAMSID
     C                   Movel(p)  'FTUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   SetOn                                        9842      *
     C                   MoveL     'Y'           W0DCF                          *Defer confirm
     C                   Goto      DCENDT                                       *QUIT
      *
      *  F3 pressed - exit program
     C     P0RTN         WHENEQ    'Y2U9999'                                    *IF
     C                   MoveL     'Y2U9999'     P0RTN                          *Return code
     C                   Exsr      ZYEXPG
      *
      *  If error redisplay
     C     P0RTN         WHENNE    *BLANKS                                      *IF
      *
      * Re-display screen
     C                   MoveL     'FTP0009'     ZAMSID
     C                   Movel(p)  'FTUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   SetOn                                        9842      *
     C                   MoveL     'Y'           W0DCF                          *Defer confirm
     C                   Goto      DCENDT                                       *QUIT
      *
      *  Function completed normally
     C     P0RTN         WHENEQ    *BLANKS                                      *IF
     C                   ENDSL                                                  *LS
      *
     C     DCENDT        Tag
     C     *IN98         IFEQ      '1'
      * SFLRCD invalid
     C  N99              Z-Add     ##RR          ##SFRC               99        *
      * SFLNXTCHG
     C                   SetOn                                        84
     C                   Else
      * SFLRCD valid
      * SFLNXTCHG
     C                   SetOff                                       84
     C                   MoveL     *BLANK        #1SEL
     C                   EndIf                                                  FI *IN98
      *
      *  If option did not end in error, F12 or F3 then update record
      *  with changes
      *
     C     P0RTN         IFEQ      *BLANKS
     C     *IN98         ANDEQ     '0'
     C                   Exsr      SRRCHG
     C                   EndIf
      *================================================================
     CSR   DCEXIT        EndSR
      /EJECT
     CSR   FBRQRL        BegSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MoveL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        EndSR
      /EJECT
     CSR   MBFL#1        BegSR
      *================================================================
      * Move FTPAYX0 fields to subfile
      *================================================================
     C                   MoveL     *BLANK        #1SEL
 
     C                   MoveL     X1RECI        #1RECI
     C                   MoveL     X1PREF        #1PREF
 
     C                   Eval      #1F20R    =   X1F20R
     C                   Eval      #1CCCY    =   X1CCCY
     C                   Eval      #1M19R    =   X1M19R
      *
     C                   Call      'AOCURRR0'
     C                   Parm      *BLANKS       PRTCD             7
     C                   Parm      '*KEY   '     POPTN             7
     C                   Parm      X1CCCY        PCCY              3
     C     DSCURR        Parm      *Blanks       DSSDY
      *
     C                   Move      *Blanks       PFMTIN
     C                   Move      X1AMNT        PFMTIN
     C                   CallB     'ZA0920'
     C                   Parm      *BLANK        PRETC            10
     C                   Parm                    PFMTIN           13 0
     C                   Parm      A6NBDP        PFMDEC            1 0
     C                   Parm      '.'           PCCYSEP           1
     C                   Parm      *BLANK        PFMTOUT          14
     C                   Move      PFMTOUT       #1AMNT
      *
     C                   Eval      PDayNo    =   X1DATS
     C                   CallB     'ZDATE2'
     C                   Parm                    PDayNo            5 0
     C                   Parm      BJDFIN        PFMT              1
     C                   Parm      *ZERO         PDate             6 0
     C                   Parm      *BLANKS       PADate            7
     C                   Movel     PDate         #1DATS
     C                   If        #1DATS = '000000'
     C                   Movel     *Blanks       #1DATS
     C                   EndIf
      *
     C                   Eval      #1REA1    =   X1REA1
     C                   Eval      #1REA2    =   X1REA2
     C                   Eval      #1REA3    =   X1REA3
     C                   Eval      #1REA4    =   X1REA4
     C                   Eval      #1REA5    =   X1REA5
     C                   Eval      #1REA6    =   X1REA6
     C                   MoveL     *BLANK        #1SEL                          *SFLSEL
      *
      *================================================================
     CSR   MBEXIT        EndSR
      /EJECT
     CSR   MEIZ#2        BegSR
      *================================================================
      * Initialise subfile control
      *================================================================
      *
      * Initialise header and footer fields
      *
     C                   MoveL     *BLANK        ##ONAM                         Option Name
     C                   MoveL     *BLANK        ##CMD1                         CMD Line 1
     C                   MoveL     *BLANK        ##CMD2                         CMD Line 2
      *
     C                   MoveL     P1ACTC        #PACTC                         Action Code
     C                   MoveL     *BLANK        #2PREF
     C                   MoveL     *BLANK        #2DATS
     C                   MoveL     *BLANK        #2CCCY
      *
     C     ULRECS        IfEq      'NoRecs'
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0003'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
     C                   MoveL     #MSTX1        ##CMD2
     C                   MoveL     '1'           *IN76
     C                   MoveL     '1'           *IN75
     C                   GoTo      MEEXIT
     C                   EndIf
      *
      * Fill Command lines and narrative text from messages
     C                   SELECT
      *
      * Enquiry screen
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0001'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##ONAM
      *
      * Action codes
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0002'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##CMD1
      *
      * Function keys
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0003'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##CMD2
      *
     C                   MoveL     '1'           *IN76
     C                   MoveL     '1'           *IN75
      *
      * Select screen
     C     P1ACTC        WHENEQ    'S'
      *
      * Option Name
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0004'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##ONAM
      *
      * Action codes
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0005'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##CMD1
      *
      * Function keys
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0003'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##CMD2
      * Allow F12
     C                   MoveL     '1'           *IN78
      *
      * Update screen
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0004'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##ONAM
      *
      * Action codes
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0005'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##CMD1
      *
      * Function keys
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0003'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##CMD2
      *
     C                   ENDSL
      *
      *================================================================
     CSR   MEEXIT        EndSR
      /EJECT
     CSR   ZASNMS        BegSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MoveL     ##PGM         ZAPGMQ
     C                   EndIf
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MoveL     ZADFMF        ZAMSGF
     C                   EndIf
     C                   Call      'Y2SNMGC'
     C                   Parm                    ZAPGMQ           10            Program queue
     C                   Parm                    ZAPGRL            5            Rel queue
     C                   Parm                    ZAMSID            7            Message ID
     C                   Parm                    ZAMSGF           10            Message file
     C                   Parm                    ZAMSDA          132            Message data
     C                   Parm                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MoveL     *BLANK        ZAPGMQ
     C                   MoveL     *BLANK        ZAPGRL
     C                   MoveL     *BLANK        ZAMSID
     C                   MoveL     *BLANK        ZAMSGF
     C                   MoveL     *BLANK        ZAMSDA
     C                   MoveL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        EndSR
      /EJECT
     CSR   ZXEXPG        BegSR
      *================================================================
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
      *
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MoveL     'Y2U9999'     P0RTN                          *Return code
     C                   EndIf                                                  *FI
      * CASE: CTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MoveL     'USR0790'     P0RTN                          *Return code
     C                   EndIf                                                  *FI
      *
     C                   Exsr      ZYEXPG
      *================================================================
     CSR   ZXEXIT        EndSR
      /EJECT
     CSR   ZYEXPG        BegSR
      *================================================================
      * Exit program: Direct
      *================================================================
      *
      * Copy any undisplayed messages back to Caller
     C                   Call      'Y2CPMSC'
     C                   Parm                    ##PGM
      *
      * Terminate program
     C                   SetOn                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        EndSR
      /EJECT
     CSR   ZZINIT        BegSR
      *================================================================
      * Initialisation
      *================================================================
     C                   Move      *BLANK        P0RTN
     C                   Move      *BLANK        W0RTN             7
     C                   MoveL     *BLANK        W0RSL             1
     C                   MoveL     *BLANK        W0RSF             1
      * Setup job date/time
      *
     C                   Z-Add     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MoveL     'FTUSRMSG'    ZADFMF           10
     C                   Z-Add     12            ##SFPG            3 0          SFLPAG
     C                   Z-Add     1             ##SFRC
      * Maximum record number
     C                   Z-Add     *ZERO         ##RRMX
      * Scan limit
     C                   Z-Add     500           W0SLM             5 0
      *................................................................
     C                   MoveL     *BLANK        W0GRP             1
     C                   Z-Add     0             Q                 5 0
     C                   MoveA     '00'          *IN(77)
      * USER: Initialise program
      *
      *  Set up copyright parameter
      *
     C                   MoveA     CPY@          BIS@             80
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       Define    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   Move      AGMRDT        ##MRDT            7            Midas Run date
     C                   Move      AGMRDT        WUMRDT            7            Midas Run date
     C                   Move      AGRDNB        WURDNB            5 0          Run day number
     C                   Move      AGSUC         WUSUC             1            Set up complete
     C                   Move      AGDFF         WUDFF             1            Date Format
     C                   Move      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Set multi-branch indicator
     C     WUMBIN        IFNE      'Y'                                          Multi Branched ?
     C                   MoveL     '1'           *IN70
     C                   EndIf
      *
      * Access Bank Details
     C                   CallB     'AOBANKR0'                                   Multi Branched ?
     C                   Parm      *BLANKS       PRTCD             7            Multi Branched ?
     C                   Parm      '*FIRST '     POPTN             7            Multi Branched ?
     C     DSBANK        Parm      DSBANK        DSFDY                          Multi Branched ?
      *                                                                         Multi Branched ?
      ** Database error.                                                        Multi Branched ?
     C     PRTCD         IFNE      *BLANKS                                      Multi Branched ?
     C                   MoveL     POPTN         W0KEY                          Multi Branched ?
     C                   MoveL     'SDBANKPD'    W0FILE                         Multi Branched ?
     C                   Z-Add     101           W0ERNB                         Multi Branched ?
     C                   Exsr      SRERR
     C                   ENDIF
      *                                                                         Multi Branched ?
      * Open file FTPAYY1
     C     FIL001        IFEQ      *BLANKS
      *
      *  Override file FTPAYY1 to share(*NO)
     C                   MoveA     CMD@(1)       EDT
     C                   MoveL     'FTPAYY1 '    U#FILE           10
     C                   MoveA     U#FILE        EDT(17)
     C                   MoveA     EDT           OVRDBF           80
     C                   Z-Add     80            CMDLEN           15 5
     C                   Call      'QCMDEXC'                              90    90
     C                   Parm                    OVRDBF
     C                   Parm                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MoveL     '*Call  '     W0FILE
     C                   MoveL     'QCMDEXC'     W0KEY
     C                   Z-Add     3             W0ERNB
     C                   MoveL     'MEM5003'     W0MSGD
     C                   MoveL     'MIDAS  '     W0MSGF
     C                   Exsr      SRERR
     C                   EndIf
      *
     C                   OPEN      FTPAYY1
     C                   MoveL     'Y'           FIL001            1
     C                   EndIf
      *
      * Open file FTPAYY0
     C     FIL002        IFEQ      *BLANKS
      *
      *  Override file FTPAYY0 to share(*NO)
     C                   MoveA     CMD@(1)       EDT
     C                   MoveL     'FTPAYY0 '    U#FILE           10
     C                   MoveA     U#FILE        EDT(17)
     C                   MoveA     EDT           OVRDBF           80
     C                   Z-Add     80            CMDLEN           15 5
     C                   Call      'QCMDEXC'                              90    90
     C                   Parm                    OVRDBF
     C                   Parm                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MoveL     '*Call  '     W0FILE
     C                   MoveL     'QCMDEXC'     W0KEY
     C                   Z-Add     4             W0ERNB
     C                   MoveL     'MEM5003'     W0MSGD
     C                   MoveL     'MIDAS  '     W0MSGF
     C                   Exsr      SRERR
     C                   EndIf
      *
     C                   OPEN      FTPAYY0
     C                   MoveL     'Y'           FIL002            1
     C                   EndIf
      *
      * Initialise subfile control
     C                   Exsr      MEIZ#2
      *================================================================
     CSR   ZZEXIT        EndSR
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO)
