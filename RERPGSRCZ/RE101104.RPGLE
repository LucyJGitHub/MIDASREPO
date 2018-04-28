     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE MT101 & MT103 Translation MNT per Dest')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE101104 - MT101 & MT103 Translation Maintenance             *
      *             per Destination                                   *
      *                                                               *
      *  Function: This new maintanace function will define the key   *
      *            fields to match when reconciling the Outgoing      *
      *            MT101 to the Reply MT103.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSW207             Date 15Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG6979            Date 03May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 211499             Date 07Jan03               *
      *                 211210             Date 11Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW207 - SWIFT 2007 Standard Changes                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  211499 - Option included to exclude address part in Name and *
      *           Address option fields                               *
      *  211210 - Various action code errors                          *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    20         Continuation Line for MT101                     *
      *    21         Enable Command Line for First Screen            *
      *    22         Enable Command Line for Second Screen           *
      *    23         Enable Command Line for Third Screen            *
      *    24         Enable F10 in Command Line                      *
      *    25         MSGCTL Indicator                                *
      *    26         Protect/Underline Indicator                     *
      *    27         Force Input Format                              *
      *    28         READ/CHAIN Indicator                            *
      *    29         READ/CHAIN Indicator                            *
      *    30         Invalid Action Code                             *
      *    31         Rollup/Rolldown                                 *
      *    32         Invalid Rule Number                             *
      *    33         Invalid MT103 Tag                               *
      *    34         Invalid MT101 Tag 1                             *
      *    35         Invalid MT101 Field Component 1                 *
      *    36         Invalid MT101 Tag 2                             *
      *    37         Invalid MT101 Field Component 2                 *
      *    38         Invalid MT101 Tag 3                             *
      *    39         Invalid MT101 Field Component 3                 *
      *    40         Invalid MT101 Tag 4                             *
      *    41         Invalid MT101 Field Component 4                 *
      *    42         Invalid MT101 Tag 5                             *
      *    43         Invalid MT101 Field Component 5                 *
      *    44         Invalid MT101 Tag 6                             *
      *    45         Invalid MT101 Field Component 6                 *
      *    46         Invalid Destination                             *
      *    47         Invalid Description                             *
      *    48         Enable Command Line for Key Screen              *
      *    49         TESTN Indicator                                 *
      *    50         LOOKUP Indicator                                *
      *    51         Protect Rule Number if Amend                    *
      *    80         SFLCLR (First Screen)                           *
      *    81         SFLDSP (First Screen)                           *
      *    82         Rollup (First Screen)                           *
      *    83         READC Indicator                                 *
      *    84         SFLNXTCHG Indicator                             *
      *    85         SFLCLR (Second Screen)                          *
      *    86         SFLDSP (Second Screen)                          *
      *    87         Rollup (Second Screen)                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBuild       -  Build First Screen                          *
      *  SRLoad        -  Load Subfile (First Screen)                 *
      *  SRDisplay     -  Display First Screen                        *
      *  SRProcKey     -  Process Key Screen                          *
      *  SRProcSF1     -  Process First Screen                        *
      *  SRVAction     -  Validate Action Code                        *
      *  SRValDest     -  Validate Destination                        *
      *  SRValDesc     -  Validate Description                        *
      *  SRValRec1     -  Validate Record 1                           *
      *  SRProcActn1   -  Process Action Code 1                       *
      *  SREnquire1    -  Handle Enquire 1                            *
      *  SRDelete1     -  Handle Delete 1                             *
      *  SRAmend1      -  Handle Insert/Amend 1                       *
      *  SRDetail      -  Process Detail Screen                       *
      *  SRProcSub     -  Process Subfile 2                           *
      *  SRDelRec      -  Delete Record                               *
      *  SRBuild2      -  Build Second Screen                         *
      *  SRLoad2       -  Load Subfile (Second Screen)                *
      *  SRDisplay2    -  Display Second Screen                       *
      *  SRProcSF2     -  Process Second Screen                       *
      *  SRVAction2    -  Validate Action Code 2                      *
      *  SRValRec2     -  Validate Record 2                           *
      *  SRProcActn2   -  Process Action Code 2                       *
      *  SREnquire2    -  Handle Enquire 2                            *
      *  SRDelete2     -  Handle Delete 2                             *
      *  SRAmend2      -  Handle Insert/Amend 2                       *
      *  SRCompare     -  Display Subfile Detail Comparison Values    *
      *  SRValDFlds    -  Validate Detail Fields                      *
      *  SRVFldCom     -  Validate Field Component                    *
      *  SRMoveSF      -  Move Screen Fields to File Fields           *
      *  SRMoveFS      -  Move File Fields to Screen Fields           *
      *  SRClear       -  Clear Fields                                *
      *  SRRoll        -  Rollback or Commit Changes                  *
      *  SRSndMsg      -  Send Message                                *
      *                                                               *
      *  *PSSR - Error Processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FRE101104DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(RE101104S0:#0RLRN)
     F                                     SFILE(RE101104S1:#1RLRN)
      ** Midas RE MT101 & MT103 Translation MNT per Destination DF
 
     FREZSHDL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Zero Balancing/Sweeping Hierarchy Details
 
     FRETBDSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas RE MT101/MT103 Translation by Destination File
 
     FRETBDDL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas RE MT101/MT103 Translation by Destination Details File
 
     FRETBDDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RETBDDD0:RETBDDD1)
     F                                     PREFIX(RX)
      ** Midas RE MT101/MT103 Translation by Destination Details File
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Standard D specifications
     D/COPY ZACPYSRC,RECMSTDD
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                211210
     D ZMUSER          DS            17                                         211210
     D  BRC                   11     13                                         211210
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D                 DS
     D*MT101****                     45    DIM(30) CTDATA PERRCD(1)                           CSW207
     D MT101                         45    DIM(31) CTDATA PERRCD(1)                           CSW207
     D    MT101Tag                    5    Overlay(MT101)
     D    MT101Cmp                   40    Overlay(MT101:*NEXT)
     D*MT103****                     45    DIM(35) CTDATA PERRCD(1)                           CSW207
     D MT103                         45    DIM(36) CTDATA PERRCD(1)                           CSW207
     D    MT103Tag                    5    Overlay(MT103)
     D    MT103Cmp                   40    Overlay(MT103:*NEXT)
     D*MT101H***       S              5    DIM(13) CTDATA PERRCD(1)                           CSW207
     D MT101H          S              5    DIM(14) CTDATA PERRCD(1)                           CSW207
     D*MT101D***       S              5    DIM(24) CTDATA PERRCD(1)                           CSW207
     D MT101D          S              5    DIM(25) CTDATA PERRCD(1)                           CSW207
     D AComp           S              6    DIM(4)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PZMsgFile       S             10
     D PZMsgID         S             10
 
     D POption         S              7
     D PRtrnCode       S              7
     D PType           S              7
     D PKEY1           S             10
     D PKYST           S              7
 
     D WReload         S              1
     D WLastRec        S              4  0
     D WRecPag         S              5  0
     D WSflPag         S              3  0
     D WReload2        S              1
     D WLastRec2       S              4  0
     D WRecPag2        S              5  0
     D WSflPag2        S              3  0
 
     D WError          S              1
     D WErrFC          S              1
     D W0DCF           S              1
 
     D WFLD2           S             35
     D WFLD3           S             35
     D WFLD4           S             35
     D WFLD5           S             35
     D WFLD6           S             35
     D WFldCom         S             35
     D WMTAG           S              5
     D WMTAG2          S              5
     D WMTAG3          S              5
     D WMTAG4          S              5
     D WMTAG5          S              5
     D WMTAG6          S              5
     D WMTHD           S              5
     D WMTHD2          S              5
     D WMTHD3          S              5
     D WMTHD4          S              5
     D WMTHD5          S              5
     D WMTHD6          S              5
     D WRule           S              2  0
 
     D KDest           S             11
     D KDest2          S             18
     D KRule           S              2  0
     D KMT3T           S              5
 
     D S               S              2  0
     D S1              S              2  0
     D X               S              2  0
     D Y               S              1  0
     D Z               S              2  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing --------------------------------+
      ** ¦                                                             ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is¦
      ** ¦ executed at program activation.                             ¦
      ** ¦                                                             ¦
      ** +-------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Main Program
      *                                                                                    BUG6979
      **  GET ZMUSER to access default branch.                                             BUG6979
      *                                                                                    BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                    BUG6979
     C                   IN        ZMUSER                                                  BUG6979
     C                   UNLOCK    ZMUSER                                                  BUG6979
      *                                                                                    BUG6979
      * Check for user authority to insert                                                 BUG6979
      *                                                                                    BUG6979
     C                   CALL      'ZVACTBU'                                               BUG6979
     C                   PARM      'I'           @ZACTN            1                       BUG6979
     C                   PARM      BRC           @ZBR              3                       BUG6979
     C                   PARM      *ZERO         @ERR              1 0                     BUG6979
                                                                                           BUG6979
     C                   IF        @ERR = 2                                                BUG6979
     C                   MOVE      *ON           *IN15                                     BUG6979
     C                   ENDIF                                                             BUG6979
                                                                                           BUG6979
      ** Initialise subfile control                                                        BUG6979
                                                                                           BUG6979
     C                   EVAL      #0WSID = PSJobName                                      BUG6979
     C                   EVAL      #0USER = PSUser                                         BUG6979
     C                   EVAL      #2PGMQ = PSProcName                                     BUG6979
 
     C                   DOU       *INKC = *ON
 
      ** Initialise and load subfile page
 
     C                   IF        WReload <> 'N' and WError <> 'Y'
     C                   EXSR      SRBuild
     C                   EVAL      WReload = 'N'
     C                   ENDIF
 
      ** Display screen
 
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C                   IF        *INKC <> *ON
 
     C                   IF        *IN31 = *ON
     C                   EXSR      SRLoad
     C                   ELSE
     C                   EXSR      SRProcKey
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuild - Build First Screen                                 *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRLoad                                            *
      *                                                               *
      *****************************************************************
 
     C     SRBuild       BEGSR
 
      ** Initialise and load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     RE101104C0
     C                   EVAL      *IN80 = *OFF
 
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *OFF
 
      ** Reset number of records in subfile
 
     C                   EVAL      WLastRec = 0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Setup key
 
     C     *LOVAL        SETLL     RETBDSL0
 
      ** Load subfile page
 
     C                   EVAL      WRecPag = 0
     C                   EXSR      SRLoad
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoad - Load Subfile (First Screen)                         *
      *                                                               *
      *  Called by: Main, SRBuild                                     *
      *                                                               *
      *  Calls    : SRSndMsg                                          *
      *                                                               *
      *****************************************************************
 
     C     SRLoad        BEGSR
 
     C                   EVAL      *IN30 = *OFF
 
      ** Start at previous highest record in SFL
 
     C                   EVAL      #0RLRN = WLastRec
 
      ** Load next subfile page
 
     C                   DOU       %EOF(RETBDSL0) or WRecPag = WSflPag
 
     C                   READ      RETBDSL0
 
      ** Retrieve subfile fields
 
     C                   IF        NOT %EOF(RETBDSL0)
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0DEST = TBDEST
     C                   EVAL      #0DESC = TBDESC
 
      ** Output to subfile
 
     C                   ADD       1             #0RLRN               81
     C                   ADD       1             WRecPag
 
     C                   WRITE     RE101104S0
     C                   ENDIF
 
     C                   ENDDO
 
      ** If no records found, display error message
 
     C                   IF        %EOF(RETBDSL0) and #0RLRN = 0
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *ON
     C                   EVAL      PZMsgID = 'RE74041'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
      ** Save highest SFL record
 
     C                   IF        #0RLRN > WLastRec
     C                   EVAL      WLastRec = #0RLRN
     C                   ENDIF
 
     C                   EVAL      WRecPag = 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display First Screen                             *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
      ** Update screen time
 
     C                   TIME                    #0TIME
 
      ** Seton indicator for appropriate command line
 
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN48 = *OFF
 
      ** Display screen
 
     C                   WRITE     RE101104F0
     C                   WRITE     RE101104F1
     C                   WRITE     RE101104C2
     C                   EXFMT     RE101104C0
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
 
     C                   EVAL      WError = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcKey - Process Key Screen                               *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRValDest, SRValDesc, SRProcSF1, SRValRec1        *
      *                                                               *
      *****************************************************************
 
     C     SRProcKey     BEGSR
 
     C                   EVAL      *INKL = *OFF
     C                   EVAL      W0DCF = 'N'
 
      ** If F9 was not pressed and file not empty, process subfile
 
     C                   IF        *IN81 = *ON
     C                   EXSR      SRProcSF1
     C                   ENDIF
 
      ** If F9 was pressed, process add request
 
     C                   IF        *INKI = *ON and W0DCF = 'N'
 
     C                   EVAL      #0ACTN = 'I'
     C                   EVAL      #0DEST = *BLANKS
     C                   EVAL      #0DESC = *BLANKS
 
      ** Display screen for add request
 
     C                   DOW       *INKC = *OFF and *INKL = *OFF
 
     C                   EVAL      *IN48 = *ON
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN26 = *OFF
 
     C                   WRITE     RE101104F0
     C                   WRITE     RE101104F1
     C                   WRITE     RE101104C2
     C                   EXFMT     RE101104D1
 
     C                   IF        *INKL <> *ON and *INKC <> *ON
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Validate destination and description
 
     C                   EXSR      SRValDest
     C                   EXSR      SRValDesc
 
     C                   IF        WError = 'N'
     C                   EXSR      SRValRec1
     C                   ENDIF
 
     C                   ENDIF
 
      ** IF F12 was pressed
 
     C                   IF        *INKL = *ON
     C                   EVAL      #0DEST = *BLANKS
     C                   EVAL      #0DESC = *BLANKS
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   EVAL      WReload = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcSF1 - Process First Screen                             *
      *                                                               *
      *  Called by: SRProcKey                                         *
      *                                                               *
      *  Calls    : SRVAction, SRValRec1                              *
      *                                                               *
      *****************************************************************
 
     C     SRProcSF1     BEGSR
 
     C                   READC     RE101104S0                             83
 
     C                   DOW       *IN83 = *OFF and *INKC = *OFF
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN27 = *OFF
 
      ** Validate Action Code
 
     C                   IF        #0ACTN <> *BLANKS and *INKI <> *ON
     C                   EXSR      SRVAction
 
     C                   IF        *IN30 = *ON
     C                   EVAL      *IN27 = *ON
     C                   ELSE
     C                   EVAL      *IN27 = *OFF
     C                   EXSR      SRValRec1
     C                   ENDIF
 
     C                   IF        *IN83 = *OFF
 
      ** If there is an error, seton SFLNXTCHG indicator
 
     C                   IF        *IN27 = *ON
     C                   EVAL      *IN84 = *ON
     C                   ELSE
     C                   EVAL      *IN84 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN83 = *OFF
     C                   UPDATE    RE101104S0
     C                   READC     RE101104S0                             83
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAction - Validate Action Code                             *
      *                                                               *
      *  Called by: SRProcSF1                                         *
      *                                                               *
      *  Calls    : SRSndMsg                                          *
      *                                                               *
      *****************************************************************
 
     C     SRVAction     BEGSR
 
     C                   EVAL      *IN30 = *OFF
 
     C                   IF        #0ACTN <> 'E' and #0ACTN <> 'D' and
     C                             #0ACTN <> 'A' and #0ACTN <> *BLANKS
     C                   EVAL      *IN30 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74049'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ELSE                                                   211210
                                                                                211210
      * Check for user authority to action code                                 211210
                                                                                211210
     C                   CALL      'ZVACTBU'                                    211210
     C                   PARM      #0ACTN        @ZACTN            1            211210
     C                   PARM      BRC           @ZBR              3            211210
     C                   PARM      *ZERO         @ERR              1 0          211210
                                                                                211210
     C                   IF        @ERR = 2                                     211210
     C                   EVAL      *IN30 = *ON                                  211210
     C                   EVAL      *IN82 = *ON                                  211210
     C                   EVAL      WError = 'Y'                                 211210
     C                   EVAL      PZMsgID = 'RE74080'                          211210
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'                     211210
     C                   EXSR      SRSndMsg                                     211210
     C                   ENDIF                                                  211210
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDest - Validate Destination                             *
      *                                                               *
      *  Called by: SRProcKey, SRValDFlds                             *
      *                                                               *
      *  Calls    : SRSndMsg                                          *
      *                                                               *
      *****************************************************************
 
     C     SRValDest     BEGSR
 
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      WError = 'N'
     C                   EVAL      PKEY1 = #0DEST
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRtrncode = *BLANKS
 
      ** If not attached to a SWIFT Id
 
     C                   IF        BBCSID = *BLANKS
     C                   EVAL      *IN46 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74050'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      #0DEST = BBCSID
     C                   ENDIF
 
     C                   ELSE
 
     C                   CALL      'AOBICDV0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM                    #0DEST
     C                   PARM                    PType
     C                   PARM                    MEBICD
 
      ** If not SWIFT Id or Customer Number
 
     C                   IF        PType = '*NRF' and PRtrnCode = *BLANKS
     C                   EVAL      *IN46 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74051'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
      ** If it does not exist in REZSHDPD
 
     C                   IF        WError = 'N'
 
     C                   EVAL      KDest2 = #0DEST
 
     C     KDest2        CHAIN     REZSHDL1                           28
 
     C                   IF        *IN28 = *ON
     C*******************EVAL      *IN46 = *ON
     C*******************EVAL      WError = 'Y'
     C*******************EVAL      PZMsgID = 'RE74060'
     C*******************EVAL      PZMsgFile = 'GBREUSRMSG'
     C*******************EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDesc - Validate Description                             *
      *                                                               *
      *  Called by: SRProcKey, SRValDFlds                             *
      *                                                               *
      *  Calls    : SRSndMsg                                          *
      *                                                               *
      *****************************************************************
 
     C     SRValDesc     BEGSR
 
     C                   EVAL      *IN47 = *OFF
 
     C                   IF          #0DESC = *BLANKS
 
      ** If SWIFT Id found in directory
 
     C                   CALL      'AOBICDV0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM                    #0DEST
     C                   PARM                    PType
     C                   PARM                    MEBICD
 
     C                   IF        PType = '*BIC'
     C                   EVAL      #0DESC = BDINS1
     C                   ELSE
 
      ** If SWIFT Id present in SDCUSTPD
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      #0DEST        PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRtrnCode = *BLANKS and BBCSID <> *BLANKS
     C                   EVAL      #0DESC = BBCNA1
     C                   ELSE
     C                   EVAL      *IN47 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74052'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValRec1 - Validate Record 1                                *
      *                                                               *
      *  Called by: SRProcKey, SRProcSF1                              *
      *                                                               *
      *  Calls    : SRSndMsg, SRProcActn1                             *
      *                                                               *
      *****************************************************************
 
     C     SRValRec1     BEGSR
 
      ** Check if record exists
 
     C     #0DEST        CHAIN     RETBDSL0                           2829
 
      ** Send message 'Record is already in use'
 
     C                   IF        *IN29 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'MIN0272'
     C                   EVAL      PZMsgFile = 'GBMEMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      W0DCF = 'Y'
     C                   ENDIF
 
     C                   IF        *IN28 = *ON
 
      ** Send message 'Record does not exist'
 
     C                   IF        #0ACTN <> 'I'
     C                   EVAL      *IN46 = *ON
     C                   EVAL      *IN29 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'MIN0271'
     C                   EVAL      PZMsgFile = 'GBMEMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      W0DCF = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
      ** Send message 'Record already exists'
 
     C                   IF        #0ACTN = 'I'
     C                   EVAL      *IN46 = *ON
     C                   EVAL      *IN29 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'MIN0270'
     C                   EVAL      PZMsgFile = 'GBMEMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      W0DCF = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Process Action Code
 
     C                   IF        WError = 'N'
     C                   IF        #0ACTN = 'I'
     C                   EVAL      TBDEST = #0DEST
     C                   EVAL      TBDESC = #0DESC
     C                   EVAL      TBJBNM = #0WSID
     C                   EVAL      TBUSRN = #0USER
     C                   MOVE      #0TIME        TBACTM
     C                   EVAL      TBACTD = BJRDNB
     C                   EVAL      TBACTP = 'I'
     C                   WRITE     RETBDSD0
     C                   ENDIF
     C                   EXSR      SRProcActn1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcActn1 - Process Action Code 1                          *
      *                                                               *
      *  Called by: SRValRec1                                         *
      *                                                               *
      *  Calls    : SREnquire1, SRDelete1, SRAmend1, SRRoll           *
      *                                                               *
      *****************************************************************
 
     C     SRProcActn1   BEGSR
 
      ** If action code is 'E'
 
     C     #0ACTN        CASEQ     'E'           SREnquire1
 
      ** If action code is 'D'
 
     C     #0ACTN        CASEQ     'D'           SRDelete1
 
      ** If action code is 'A'
 
     C     #0ACTN        CASEQ     'A'           SRAmend1
 
      ** If action code is 'I'
 
     C     #0ACTN        CASEQ     'I'           SRAmend1
 
     C                   ENDCS
 
      ** Rollback or commit any changes
      ** Applicable only in delete. Other cases handle their own commitment
 
     C                   IF        #0ACTN = 'D'
     C                   EXSR      SRRoll
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnquire1 - Handle Enquiry 1                                *
      *                                                               *
      *  Called by: SRProcActn1                                       *
      *                                                               *
      *  Calls    : SRProcSub                                         *
      *                                                               *
      *****************************************************************
 
     C     SREnquire1    BEGSR
 
     C                   EXSR      SRProcSub
     C                   EVAL      *IN83 = *OFF
 
     C                   IF        *INKC = *ON or *INKL = *ON
     C                   EVAL      WReload = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete1 - Handle Delete 1                                  *
      *                                                               *
      *  Called by: SRProcActn1                                       *
      *                                                               *
      *  Calls    : SRDelRec                                          *
      *                                                               *
      *****************************************************************
 
     C     SRDelete1     BEGSR
 
     C                   EXSR      SRDelRec
 
     C                   EVAL      WReload = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend1 - Handle Insert/Amend 1                             *
      *                                                               *
      *  Called by: SRProcActn1                                       *
      *                                                               *
      *  Calls    : SRProcSub, SRDetail                               *
      *                                                               *
      *****************************************************************
 
     C     SRAmend1      BEGSR
 
      ** Display and process appropriate screen
 
     C                   IF        #0ACTN = 'I'
     C                   EVAL      *INKI = *ON
     C                   EVAL      *IN86 = *OFF
     C                   EXSR      SRDetail
     C                   ELSE
     C                   EXSR      SRProcSub
     C                   EVAL      *IN83 = *OFF
     C                   ENDIF
 
     C                   IF        *INKC = *ON or *INKL = *ON
     C                   EVAL      WReload = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail - Process Detail Screen                             *
      *                                                               *
      *  Called by: SRAmend1, SRProcSF1                               *
      *                                                               *
      *  Calls    : SRProcSF2, SRValRec2                              *
      *                                                               *
      *****************************************************************
 
     C     SRDetail      BEGSR
 
      ** Confirm/update is not deferred
 
     C                   EVAL      W0DCF = 'N'
 
      ** Process detail subfile records
 
     C                   IF        *IN86 = *ON
     C                   EXSR      SRProcSF2
     C                   ENDIF
 
      ** Process add request
 
     C                   IF        *INKI = *ON and W0DCF = 'N'
     C                   EVAL      #1ACTN = 'I'
     C                   EXSR      SRProcActn2
     C                   ENDIF
 
     C                   IF        WError = 'N'
     C                   EVAL      WReload2 = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcSub - Process Subfile 2                                *
      *                                                               *
      *  Called by: SREnquire1, SRAmend1                              *
      *                                                               *
      *  Calls    : SRDisplay2, SRLoad2, SRDetail, SRBuild2           *
      *                                                               *
      *****************************************************************
 
     C     SRProcSub     BEGSR
 
     C                   EVAL      WReload2 = 'Y'
 
      ** Perform the following until F3 or F12 is pressed
 
     C                   DOU       *INKC = *ON or *INKL = *ON
 
      ** Initialise and load subfile page
 
     C                   IF        WReload2 <> 'N' and WError <> 'Y'
     C                   EXSR      SRBuild2
     C                   EVAL      WReload2 = 'N'
     C                   ENDIF
 
      ** Display second screen
 
     C                   EXSR      SRDisplay2
 
      ** Process screen input
 
     C                   IF        *INKC <> *ON and *INKL <> *ON
 
      ** If F5 was pressed, request subfile reload
 
     C                   IF        *INKE = *ON
     C                   CALL      'ZA0250'
     C                   EVAL      WReload2 = 'Y'
     C                   ENDIF
 
      ** Display next subfile page
 
     C                   IF        *IN31 = *ON
     C                   EXSR      SRLoad2
     C                   ENDIF
 
      ** Process screen
 
     C                   IF        *INKE <> *ON and *IN31 <> *ON
 
     C                   IF        *INKI = *ON
     C                   EVAL      #1ACTN = 'I'
     C                   ENDIF
 
     C                   EXSR      SRDetail
 
     C                   IF        *INKL = *ON
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      *INKL = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        *INKL = *ON
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      WReload = 'Y'
     C                   EVAL      *INKL = *OFF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelRec - Delete Record                                     *
      *                                                               *
      *  Called by: SRDelete1                                         *
      *                                                               *
      *  Calls    : SRSndMsg                                          *
      *                                                               *
      *****************************************************************
 
     C     SRDelRec      BEGSR
 
     C                   EVAL      KDest = #0DEST
 
      ** Position to detail file records to be deleted
 
     C     KRETBDD       SETLL     RETBDDL0
     C                   READ      RETBDDL0                             2928
 
      ** Send message 'Record is in use by other'
 
     C                   IF        *IN29 = *ON
     C                   EVAL      PZMsgID = 'MIN0272'
     C                   EVAL      PZMsgFile = 'GBMEMSG'
     C                   EXSR      SRSndMsg
     C                   ELSE
 
      ** Delete record
 
     C     #0DEST        CHAIN     RETBDSL0                           29
 
     C                   IF        *IN29 = *OFF
 
     C                   DELETE    RETBDSD0                             29
 
      ** Change error detected
 
     C                   IF        *IN29 = *ON
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EVAL      PZMsgFile = 'GBY2USRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Delete corresponding detail records
 
     C                   DOW       #0DEST = TDDEST and *IN28 = *OFF
     C                   DELETE    RETBDDD0                             29
 
      ** Change error detected
 
     C                   IF        *IN29 = *ON
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EVAL      PZMsgFile = 'GBY2USRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   READ      RETBDDD0                               28
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuild2 - Build Second Screen                               *
      *                                                               *
      *  Called by: SRProcSub                                         *
      *                                                               *
      *  Calls    : SRLoad2                                           *
      *                                                               *
      *****************************************************************
 
     C     SRBuild2      BEGSR
 
      ** Initialise and load subfile page
 
     C                   EVAL      *IN85 = *ON
     C                   WRITE     RE101104C1
     C                   EVAL      *IN85 = *OFF
 
     C                   EVAL      *IN86 = *ON
     C                   EVAL      *IN87 = *OFF
 
      ** Reset number of records in subfile
 
     C                   EVAL      WLastRec2 = 0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Setup key
 
     C     #0DEST        SETLL     RETBDDL0
 
      ** Load subfile page
 
     C                   EVAL      WRecPag2 = 0
     C                   EXSR      SRLoad2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoad2 - Load Subfile (Second Screen)                       *
      *                                                               *
      *  Called by: SRBuild2                                          *
      *                                                               *
      *  Calls    : SRCompare, SRSndMsg                               *
      *                                                               *
      *****************************************************************
 
     C     SRLoad2       BEGSR
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN84 = *OFF                                 211210
 
      ** Start at previous highest record in SFL
 
     C                   EVAL      #1RLRN = WLastRec2
 
      ** Load next subfile page
 
     C                   DOU       %EOF(RETBDDL0) or WRecPag2 = WSflPag2 or
     C                             TDDEST <> #0DEST
 
     C                   READ      RETBDDL0
 
      ** Retrieve subfile fields
 
     C                   IF        NOT %EOF(RETBDDL0) and TDDEST = #0DEST
 
     C                   EXSR      SRCompare
 
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      #0DEST = TDDEST
     C                   EVAL      #0DESC = TBDESC
     C                   MOVE      TDRULE        #1RULE
     C                   EVAL      #1MT3T = TDMT3T
     C                   EVAL      #1OPER = 'EQ'
     C                   EVAL      #1MT1T = TDMTG1
     C                   EVAL      #1MTHD = TDMTH1
     C                   EVAL      #1FLDC = TDFLD1
     C                   EVAL      WMTAG2 = TDMTG2
     C                   EVAL      WMTHD2 = TDMTH2
     C                   EVAL      WFLD2 = TDFLD2
     C                   EVAL      WMTAG3 = TDMTG3
     C                   EVAL      WMTHD3 = TDMTH3
     C                   EVAL      WFLD3 = TDFLD3
     C                   EVAL      WMTAG4 = TDMTG4
     C                   EVAL      WMTHD4 = TDMTH4
     C                   EVAL      WFLD4 = TDFLD4
     C                   EVAL      WMTAG5 = TDMTG5
     C                   EVAL      WMTHD5 = TDMTH5
     C                   EVAL      WFLD5 = TDFLD5
     C                   EVAL      WMTAG6 = TDMTG6
     C                   EVAL      WMTHD6 = TDMTH6
     C                   EVAL      WFLD6 = TDFLD6
 
      ** Output to subfile
 
     C                   ADD       1             #1RLRN               86
     C                   ADD       1             WRecPag2
 
     C                   WRITE     RE101104S1
 
     C                   EXSR      SRCompare
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SRCompare
 
      ** If no records found, display error message
 
     C                   IF        #1RLRN = 0
     C                   EVAL      *IN86 = *OFF
     C                   EVAL      *IN87 = *ON
     C                   EVAL      PZMsgID = 'RE74041'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
      ** Save highest SFL record
 
     C                   IF        #1RLRN > WLastRec2
     C                   EVAL      WLastRec2 = #1RLRN
     C                   ENDIF
 
     C                   IF        NOT %EOF(RETBDDL0)
     C                   IF        TDDEST <> #0DEST
     C                   EVAL      *IN87 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WRecPag2 = 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay2 - Display Second Screen                           *
      *                                                               *
      *  Called by: SRProcSub                                         *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay2    BEGSR
 
      ** Update screen time
 
     C                   TIME                    #0TIME
 
      ** Seton indicator for appropriate command line
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN48 = *OFF
 
     C                   WRITE     RE101104F0
     C                   WRITE     RE101104F1
     C                   WRITE     RE101104C2
     C                   EXFMT     RE101104C1
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   EVAL      WError = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcSF2 - Process Second Screen                            *
      *                                                               *
      *  Called by: SRDetail                                          *
      *                                                               *
      *  Calls    : SRVAction2, SRValRec2                             *
      *                                                               *
      *****************************************************************
 
     C     SRProcSf2     BEGSR
 
     C                   READC     RE101104S1                             83
 
     C                   DOW       *IN83 = *OFF and *INKC = *OFF
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN27 = *OFF
 
      ** Validate Action Code
 
     C                   IF        #1ACTN <> *BLANKS and *INKI <> *ON
     C                   EXSR      SRVAction2
 
     C                   IF        *IN30 = *ON
     C                   EVAL      *IN27 = *ON
     C                   ELSE
     C                   EVAL      *IN27 = *OFF
     C                   EXSR      SRValRec2
     C                   ENDIF
 
     C                   IF        *IN83 = *OFF
 
      ** If there is an error, seton SFLNXTCHG indicator
 
     C                   IF        *IN27 = *ON
     C                   EVAL      *IN84 = *ON
     C                   ELSE
     C                   EVAL      *IN84 = *OFF
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      *INKL = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN83 = *OFF
     C                   UPDATE    RE101104S1
     C                   READC     RE101104S1                             83
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAction2 - Validate Action Code 2                          *
      *                                                               *
      *  Called by: SRProcSF2                                         *
      *                                                               *
      *  Calls    : SRSndMsg                                          *
      *                                                               *
      *****************************************************************
 
     C     SRVAction2    BEGSR
 
     C                   EVAL      *IN30 = *OFF
 
     C                   IF        #1ACTN <> 'E' and #1ACTN <> 'D' and
     C                             #1ACTN <> 'A' and #1ACTN <> *BLANKS
     C                   EVAL      *IN30 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74049'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ELSE                                                   211210
                                                                                211210
      * Check for user authority to action code                                 211210
                                                                                211210
     C                   CALL      'ZVACTBU'                                    211210
     C                   PARM      #1ACTN        @ZACTN            1            211210
     C                   PARM      BRC           @ZBR              3            211210
     C                   PARM      *ZERO         @ERR              1 0          211210
                                                                                211210
     C                   IF        @ERR = 2                                     211210
     C                   EVAL      *IN30 = *ON                                  211210
     C                   EVAL      *IN87 = *ON                                  211210
     C                   EVAL      WError = 'Y'                                 211210
     C                   EVAL      PZMsgID = 'RE74080'                          211210
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'                     211210
     C                   EXSR      SRSndMsg                                     211210
     C                   ENDIF                                                  211210
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValRec2 - Validate Record 2                                *
      *                                                               *
      *  Called by: SRDetail, SRProcSF2                               *
      *                                                               *
      *  Calls    : SRSndMsg, SRProcActn2                             *
      *                                                               *
      *****************************************************************
 
     C     SRValRec2     BEGSR
 
     C                   EVAL      KDest = #0DEST
     C                   MOVE      #1RULE        KRule
 
      ** Check if record exists
 
     C     KRETBDD       CHAIN     RETBDDL0                           2829
 
      ** Send message 'Record is already in use'
 
     C                   IF        *IN29 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'MIN0272'
     C                   EVAL      PZMsgFile = 'GBMEMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      W0DCF = 'Y'
     C                   ENDIF
 
     C                   IF        *IN28 = *ON
 
      ** Send message 'Record does not exist'
 
     C                   IF        #1ACTN <> 'I'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'MIN0271'
     C                   EVAL      PZMsgFile = 'GBMEMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ELSE
 
      ** Send message 'Record already exists'
 
     C                   IF        #1ACTN = 'I'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'MIN0270'
     C                   EVAL      PZMsgFile = 'GBMEMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
      ** Process Action Code
 
     C                   IF        WError = 'N'
     C                   EXSR      SRProcActn2
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcActn2 - Process Action Code 2                          *
      *                                                               *
      *  Called by: SRValRec2                                         *
      *                                                               *
      *  Calls    : SREnquire2, SRDelete2, SRAmend2                   *
      *                                                               *
      *****************************************************************
 
     C     SRProcActn2   BEGSR
 
      ** If action code is 'E'
 
     C     #1ACTN        CASEQ     'E'           SREnquire2
 
      ** If action code is 'D'
 
     C     #1ACTN        CASEQ     'D'           SRDelete2
 
      ** If action code is 'A'
 
     C     #1ACTN        CASEQ     'A'           SRAmend2
 
      ** If action code is 'I'
 
     C     #1ACTN        CASEQ     'I'           SRAmend2
 
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnquire2 - Handle Enquire 2                                *
      *                                                               *
      *  Called by: SRProcActn2                                       *
      *                                                               *
      *  Calls    : SRClear, SRMoveFS                                 *
      *                                                               *
      *****************************************************************
 
     C     SREnquire2    BEGSR
 
     C                   EVAL      *IN26 = *ON
 
     C                   EVAL      #1ACTN = *BLANKS
     C                   EXSR      SRClear
     C                   EXSR      SRMoveFS
 
      ** Update screen time
 
     C                   TIME                    #0TIME
 
     C                   EVAL      *IN48 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *ON
     C                   EVAL      *IN24 = *OFF
 
     C                   WRITE     RE101104F0
     C                   WRITE     RE101104F1
     C                   WRITE     RE101104C2
     C                   EXFMT     RE101104D0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   EVAL      WReload2 = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete2 - Handle Delete 2                                  *
      *                                                               *
      *  Called by: SRProcActn2                                       *
      *                                                               *
      *  Calls    : SRSndMsg, SRClear, SRMoveFS                       *
      *                                                               *
      *****************************************************************
 
     C     SRDelete2     BEGSR
 
     C                   EVAL      *IN26 = *ON
 
     C                   EXSR      SRClear
     C                   EXSR      SRMoveFS
 
      ** Update screen time
 
     C                   TIME                    #0TIME
 
     C                   EVAL      *IN48 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *ON
     C                   EVAL      *IN24 = *ON
 
     C                   WRITE     RE101104F0
     C                   WRITE     RE101104F1
     C                   WRITE     RE101104C2
     C                   EXFMT     RE101104D0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   IF        *INKJ = *ON
 
     C     #0DEST        CHAIN     RETBDSL0                           29
 
     C                   IF        *IN29 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EVAL      PZMsgFile = 'GBY2USRMSG'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
     C                   DELETE    RETBDDD0                             29
 
     C                   IF        *IN29 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EVAL      PZMsgFile = 'GBY2USRMSG'
     C                   EXSR      SRSndMsg
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      WReload2 = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend2 - Handle Insert/Amend 2                             *
      *                                                               *
      *  Called by: SRProcActn2                                       *
      *                                                               *
      *  Calls    : SRClear, SRValDFlds, SRSndMsg, SRMoveSF, SRMoveFS *
      *                                                               *
      *****************************************************************
 
     C     SRAmend2      BEGSR
 
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN51 = *OFF
 
      ** Clear screen fields if Action Code is 'I'
 
     C                   IF        #1ACTN = 'I'
     C                   EXSR      SRClear
     C                   ENDIF
 
      ** Move file fields to screen fields if Action Code is 'A'
 
     C                   IF        #1ACTN = 'A'
     C                   EVAL      *IN51 = *ON
     C                   EXSR      SRClear
     C                   EXSR      SRMoveFS
     C                   ENDIF
 
     C                   DOU       *INKC = *ON or *INKL = *ON
 
      ** Update screen time
 
     C                   TIME                    #0TIME
 
     C                   EVAL      *IN48 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *ON
     C                   EVAL      *IN24 = *OFF
 
     C                   WRITE     RE101104F0
     C                   WRITE     RE101104F1
     C                   WRITE     RE101104C2
     C                   EXFMT     RE101104D0
 
     C                   IF        *INKE <> *ON and *INKC <> *ON and
     C                             *INKL <> *ON
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   EXSR      SRValDFlds
 
     C                   IF        WError = 'N'
 
     C                   IF        #1ACTN = 'A'
 
     C                   EVAL      KDest = #0DEST
     C                   MOVE      #1RULE        KRule
 
     C     KRETBDD       CHAIN     RETBDDL0                           29
 
     C                   IF        *IN29 = *ON
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EVAL      PZMsgFile = 'GBY2USRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If no error, move screen fields to file fields
 
     C                   IF        WError = 'N'
 
     C                   EXSR      SRMoveSF
     C                   EXSR      SRClear
 
     C                   IF        #1ACTN = 'A'
     C                   EVAL      *INKL = *ON
     C                   UPDATE    RETBDDD0                             29
 
     C                   IF        *IN29 = *ON
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EVAL      PZMsgFile = 'GBY2USRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WError = 'Y'
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   ELSE
 
     C                   WRITE     RETBDDD0                             29
     C                   IF        *IN29 = *ON
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EVAL      PZMsgFile = 'GBY2USRMSG'
     C                   EXSR      SRSndMsg
     C                   EVAL      WError = 'Y'
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If F12 was pressed
 
     C                   IF        *INKL = *ON
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN61 = *OFF
     C                   EVAL      *IN62 = *OFF
     C                   EVAL      *IN63 = *OFF
     C                   EVAL      *IN64 = *OFF
     C                   EVAL      *IN65 = *OFF
     C                   EVAL      *IN66 = *OFF
     C                   EVAL      *IN67 = *OFF
     C                   CALL      'ZA0250'
     C                   ENDIF
 
      ** If F5 was pressed
 
     C                   IF        *INKE = *ON
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN61 = *OFF
     C                   EVAL      *IN62 = *OFF
     C                   EVAL      *IN63 = *OFF
     C                   EVAL      *IN64 = *OFF
     C                   EVAL      *IN65 = *OFF
     C                   EVAL      *IN66 = *OFF
     C                   EVAL      *IN67 = *OFF
     C                   CALL      'ZA0250'
     C                   EXSR      SRClear
     C                   IF        #1ACTN = 'A'
     C                   EXSR      SRMoveFS
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   CALL      'ZA0250'
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      WReload2 = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCompare - Display Subfile Detail Comparison Values         *
      *                                                               *
      *  Called by: SRLoad2                                           *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRCompare     BEGSR
 
     C                   IF        WMTAG2 <> *BLANKS and WRecPag2 < WSflPag2
     C                   EVAL      *IN20 = *ON
     C                   EVAL      #1MT1T = WMTAG2
     C                   EVAL      #1MTHD = WMTHD2
     C                   EVAL      #1FLDC = WFLD2
     C                   ADD       1             #1RLRN               86
     C                   ADD       1             WRecPag2
     C                   WRITE     RE101104S1
     C                   EVAL      WMTAG2 = *BLANKS
     C                   ENDIF
 
     C                   IF        WMTAG3 <> *BLANKS and WRecPag2 < WSflPag2
     C                   EVAL      *IN20 = *ON
     C                   EVAL      #1MT1T = WMTAG3
     C                   EVAL      #1MTHD = WMTHD3
     C                   EVAL      #1FLDC = WFLD3
     C                   ADD       1             #1RLRN               86
     C                   ADD       1             WRecPag2
     C                   WRITE     RE101104S1
     C                   EVAL      WMTAG3 = *BLANKS
     C                   ENDIF
 
     C                   IF        WMTAG4 <> *BLANKS and WRecPag2 < WSflPag2
     C                   EVAL      *IN20 = *ON
     C                   EVAL      #1MT1T = WMTAG4
     C                   EVAL      #1MTHD = WMTHD4
     C                   EVAL      #1FLDC = WFLD4
     C                   ADD       1             #1RLRN               86
     C                   ADD       1             WRecPag2
     C                   WRITE     RE101104S1
     C                   EVAL      WMTAG4 = *BLANKS
     C                   ENDIF
 
     C                   IF        WMTAG5 <> *BLANKS and WRecPag2 < WSflPag2
     C                   EVAL      *IN20 = *ON
     C                   EVAL      #1MT1T = WMTAG5
     C                   EVAL      #1MTHD = WMTHD5
     C                   EVAL      #1FLDC = WFLD5
     C                   ADD       1             #1RLRN               86
     C                   ADD       1             WRecPag2
     C                   WRITE     RE101104S1
     C                   EVAL      WMTAG5 = *BLANKS
     C                   ENDIF
 
     C                   IF        WMTAG6 <> *BLANKS and WRecPag2 < WSflPag2
     C                   EVAL      *IN20 = *ON
     C                   EVAL      #1MT1T = WMTAG6
     C                   EVAL      #1MTHD = WMTHD6
     C                   EVAL      #1FLDC = WFLD6
     C                   ADD       1             #1RLRN               86
     C                   ADD       1             WRecPag2
     C                   WRITE     RE101104S1
     C                   EVAL      WMTAG6 = *BLANKS
     C                   ENDIF
 
     C                   EVAL      *IN20 = *OFF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDFlds - Validate Detail Fields                          *
      *                                                               *
      *  Called by: SRAmend2                                          *
      *                                                               *
      *  Calls    : SRSndMsg, SRVFldCom, SRValDesc,SRValDest          *
      *                                                               *
      *****************************************************************
 
     C     SRValDFlds    BEGSR
 
     C                   EVAL      WError = 'N'
 
      ** Validate Description
 
     C                   IF        #0DESC <> TBDESC
     C                   EXSR      SRValDesc
     C                   ENDIF
 
      ** Validate Rule Number
 
     C                   EVAL      *IN32 = *OFF
 
     C                   IF        #1RULE <> *BLANKS
 
     C                   TESTN                   #1RULE               49
 
      ** If not numeric, send error message
 
     C                   IF        *IN49 <> *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74053'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
 
      ** Must be 01 to 99
 
     C                   MOVE      #1RULE        WRule
 
     C                   IF        WRule = 0
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74053'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
 
     C                   IF        #1ACTN = 'I'
 
      ** Must not already exist in file
 
     C                   EVAL      KDest = #0DEST
     C                   MOVE      #1RULE        KRule
 
     C     KRETBDD       CHAIN     RETBDDL0                           28
 
     C                   IF        *IN28 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74054'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74055'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
      ** Validate MT103 Tag
 
     C                   EVAL      *IN33 = *OFF
 
     C                   IF        #1MT3T <> *BLANKS
 
     C     #1MT3T        LOOKUP    MT103Tag                               50
 
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74056'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
 
      ** Must not already exist in file
 
     C                   IF        (#1ACTN = 'A' and  #1MT3T <> TDMT3T)
     C                             or #1ACTN = 'I'
 
     C                   EVAL      KDest = #0DEST
     C                   MOVE      #1MT3T        KMT3T
 
     C     KRETBDD2      CHAIN     RETBDDL1                           28
 
     C                   IF        *IN28 = *OFF
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74072'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74057'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
      *  Bypass validation of  MT101 Tag, Header Flag and Field component if all these
      *  fields are blank and ZB/S detail flag has been filled in.
     C                   IF        #0MTG1 <> *BLANKS Or
     C                             #0MTG2 <> *BLANKS Or
     C                             #0MTG3 <> *BLANKS Or
     C                             #0MTG4 <> *BLANKS Or
     C                             #0MTG5 <> *BLANKS Or
     C                             #0MTG6 <> *BLANKS Or
     C                             #0HDR1 <> *BLANKS Or
     C                             #0HDR2 <> *BLANKS Or
     C                             #0HDR3 <> *BLANKS Or
     C                             #0HDR4 <> *BLANKS Or
     C                             #0HDR5 <> *BLANKS Or
     C                             #0HDR6 <> *BLANKS Or
     C                             #0FLD1 <> *BLANKS Or
     C                             #0FLD2 <> *BLANKS Or
     C                             #0FLD3 <> *BLANKS Or
     C                             #0FLD4 <> *BLANKS Or
     C                             #0FLD5 <> *BLANKS Or
     C                             #0FLD6 <> *BLANKS
 
      ** Validate MT101 Tag
 
 
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN44 = *OFF
 
     C                   IF        #0MTG1 <> *BLANKS
 
     C     #0MTG1        LOOKUP    MT101Tag                               50
 
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74058'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74059'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0MTG2 <> *BLANKS
 
     C     #0MTG2        LOOKUP    MT101Tag                               50
 
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN36 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74058'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0MTG3 <> *BLANKS
 
     C     #0MTG3        LOOKUP    MT101Tag                               50
 
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN38 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74058'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0MTG4 <> *BLANKS
 
     C     #0MTG4        LOOKUP    MT101Tag                               50
 
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74058'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0MTG5 <> *BLANKS
 
     C     #0MTG5        LOOKUP    MT101Tag                               50
 
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN42 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74058'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0MTG6 <> *BLANKS
 
     C     #0MTG6        LOOKUP    MT101Tag                               50
 
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN44 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74058'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Header Flag
     C                   EVAL      *IN61 = *OFF
     C                   EVAL      *IN62 = *OFF
     C                   EVAL      *IN63 = *OFF
     C                   EVAL      *IN64 = *OFF
     C                   EVAL      *IN65 = *OFF
     C                   EVAL      *IN66 = *OFF
 
      *  entry must be 'Y' or 'N'
      *  if 'Y', field tag must be qualified for a header tag
 
     C                   IF        #0MTG1 <> *BLANKS  And
     C                             *IN34  =  *Off
      *
     C                   IF        #0HDR1 <> 'Y' and #0HDR1 <> 'N'
     C                   EVAL      *IN61 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74069'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0HDR1 = 'Y'
     C     #0MTG1        LOOKUP    MT101H                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN61 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74067'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0HDR1 = 'N'
     C     #0MTG1        LOOKUP    MT101D                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN61 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74070'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0MTG2 <> *BLANKS  And
     C                             *IN36  =  *Off
 
     C                   IF        #0HDR2 <> 'Y' and #0HDR2 <> 'N'
     C                   EVAL      *IN62 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74069'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0HDR2 = 'Y'
     C     #0MTG2        LOOKUP    MT101H                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN62 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74067'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0HDR2 = 'N'
     C     #0MTG2        LOOKUP    MT101D                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN62 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74070'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0MTG3 <> *BLANKS  And
     C                             *IN38  <> *Off
 
     C                   IF        #0HDR3 <> 'Y' and #0HDR3 <> 'N'
     C                   EVAL      *IN63 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74069'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0HDR3 = 'Y'
     C     #0MTG3        LOOKUP    MT101H                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN63 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74067'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0HDR3 = 'N'
     C     #0MTG3        LOOKUP    MT101D                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN63 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74070'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0MTG4 <> *BLANKS  And
     C                             *IN40  =  *Off
 
     C                   IF        #0HDR4 <> 'Y' and #0HDR4 <> 'N'
     C                   EVAL      *IN64 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74069'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0HDR4 = 'Y'
     C     #0MTG4        LOOKUP    MT101H                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN64 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74067'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0HDR4 = 'N'
     C     #0MTG4        LOOKUP    MT101D                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN64 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74070'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0MTG5 <> *BLANKS  And
     C                             *IN42  =  *Off
 
     C                   IF        #0HDR5 <> 'Y' and #0HDR5 <> 'N'
     C                   EVAL      *IN65 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74069'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0HDR5 = 'Y'
     C     #0MTG5        LOOKUP    MT101H                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN65 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74067'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0HDR5 = 'N'
     C     #0MTG5        LOOKUP    MT101D                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN65 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74070'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #0MTG6 <> *BLANKS  And
     C                             *IN44  =  *Off
 
     C                   IF        #0HDR6 <> 'Y' and #0HDR6 <> 'N'
     C                   EVAL      *IN66 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74069'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0HDR6 = 'Y'
     C     #0MTG6        LOOKUP    MT101H                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN66 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74067'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0HDR6 = 'N'
     C     #0MTG6        LOOKUP    MT101D                                 50
     C                   IF        *IN50 = *OFF
     C                   EVAL      *IN66 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74070'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Header Flag must be blank if MT101 field tag is not entered
 
     C                   IF        #0MTG1 = *BLANKS  and #0HDR1 <> *Blank
     C                   EVAL      *IN61 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74068'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0MTG2 = *BLANKS  and #0HDR2 <> *Blank
     C                   EVAL      *IN62 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74068'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0MTG3 = *BLANKS  and #0HDR3 <> *Blank
     C                   EVAL      *IN63 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74068'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0MTG4 = *BLANKS  and #0HDR4 <> *Blank
     C                   EVAL      *IN64 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74068'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0MTG5 = *BLANKS  and #0HDR5 <> *Blank
     C                   EVAL      *IN65 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74068'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0MTG6 = *BLANKS  and #0HDR6 <> *Blank
     C                   EVAL      *IN66 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74068'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
      ** Validate Field Component
 
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      WErrFC = 'N'
 
      ** If MT101 Tag is blank and Field Component not blank
 
     C                   IF        #0FLD1 <> *BLANKS and #0MTG1 = *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrFC = 'Y'
     C                   EVAL      PZMsgID = 'RE74061'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0FLD2 <> *BLANKS and #0MTG2 = *BLANKS
     C                   EVAL      *IN37 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrFC = 'Y'
     C                   EVAL      PZMsgID = 'RE74061'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0FLD3 <> *BLANKS and #0MTG3 = *BLANKS
     C                   EVAL      *IN39 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrFC = 'Y'
     C                   EVAL      PZMsgID = 'RE74061'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0FLD4 <> *BLANKS and #0MTG4 = *BLANKS
     C                   EVAL      *IN41 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrFC = 'Y'
     C                   EVAL      PZMsgID = 'RE74061'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0FLD5 <> *BLANKS and #0MTG5 = *BLANKS
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrFC = 'Y'
     C                   EVAL      PZMsgID = 'RE74061'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   IF        #0FLD6 <> *BLANKS and #0MTG6 = *BLANKS
     C                   EVAL      *IN45 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      WErrFC = 'Y'
     C                   EVAL      PZMsgID = 'RE74061'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
      ** Validate Field Component with MT101 Tag
 
     C                   IF        WErrFC = 'N'
 
     C                   IF        #0FLD1 <> *BLANKS
     C                   EVAL      WFldCom = #0FLD1
     C                   EVAL      WMTag = #0MTG1
     C                   EXSR      SRVFldCom
     C                   IF        WErrFC = 'Y'
     C                   EVAL      *IN35 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0FLD2 <> *BLANKS
     C                   EVAL      WFldCom = #0FLD2
     C                   EVAL      WMTag = #0MTG2
     C                   EXSR      SRVFldCom
     C                   IF        WErrFC = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0FLD3 <> *BLANKS
     C                   EVAL      WFldCom = #0FLD3
     C                   EVAL      WMTag = #0MTG3
     C                   EXSR      SRVFldCom
     C                   IF        WErrFC = 'Y'
     C                   EVAL      *IN39 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0FLD4 <> *BLANKS
     C                   EVAL      WFldCom = #0FLD4
     C                   EVAL      WMTag = #0MTG4
     C                   EXSR      SRVFldCom
     C                   IF        WErrFC = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0FLD5 <> *BLANKS
     C                   EVAL      WFldCom = #0FLD5
     C                   EVAL      WMTag = #0MTG5
     C                   EXSR      SRVFldCom
     C                   IF        WErrFC = 'Y'
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0FLD6 <> *BLANKS
     C                   EVAL      WFldCom = #0FLD6
     C                   EVAL      WMTag = #0MTG6
     C                   EXSR      SRVFldCom
     C                   IF        WErrFC = 'Y'
     C                   EVAL      *IN45 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate ZB/S Detail Flag
 
     C                   EVAL      *IN67 = *OFF
 
      *  Entry only allowed if MT101 Tag, Header, Component not entered
     C
     C                   IF        #0MTG1 <> *BLANKS Or
     C                             #0MTG2 <> *BLANKS Or
     C                             #0MTG3 <> *BLANKS Or
     C                             #0MTG4 <> *BLANKS Or
     C                             #0MTG5 <> *BLANKS Or
     C                             #0MTG6 <> *BLANKS Or
     C                             #0HDR1 <> *BLANKS Or
     C                             #0HDR2 <> *BLANKS Or
     C                             #0HDR3 <> *BLANKS Or
     C                             #0HDR4 <> *BLANKS Or
     C                             #0HDR5 <> *BLANKS Or
     C                             #0HDR6 <> *BLANKS Or
     C                             #0FLD1 <> *BLANKS Or
     C                             #0FLD2 <> *BLANKS Or
     C                             #0FLD3 <> *BLANKS Or
     C                             #0FLD4 <> *BLANKS Or
     C                             #0FLD5 <> *BLANKS Or
     C                             #0FLD6 <> *BLANKS
     C
     C                   If        #0ZSWD <> *BLANKS
     C                   EVAL      *IN67 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74071'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ELSE
 
      * If entry allowed, must be 'Y' or 'N'
     C                   If        #0ZSWD <> 'Y'  And
     C                             #0ZSWD <> 'N'
     C                   EVAL      *IN67 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74069'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFldCom - Validate Field Component                         *
      *                                                               *
      *  Called by: SRValDFlds                                        *
      *                                                               *
      *  Calls    : SRSndMsg                                          *
      *                                                               *
      *****************************************************************
 
     C     SRVFldCom     BEGSR
 
      *  Retrieve up to 4 components
     C
     C                   MoveA     *blanks       AComp
     C                   Eval      Y = 1
     C                   Eval      Z = 1
     C
     C     WMtag         LOOKUP    MT101Tag(Z)                            50
     C
     C                   If        *IN50 = *ON
     C                   EVAL      S  = 0
     C                   EVAL      S1 = 1
 
     C                   Dou       Y > 4  Or  S <= 0
     C                   EVAL      S = %scan('*' : WFldCom : S1)
 
     C                   If        S > 0
     C                   Eval      S1 = %scan(' ' : WFldCom : S)
     C                   Eval      AComp(Y) = %Subst(WFldCom : S : S1 - 1)
 
      * Check if entered component matches any of the tag's components:
     C     AComp(Y)      Scan      MT101Cmp(Z)                            51
     C                   If        *IN51 = *Off
     C                   EVAL      WErrFC = 'Y'
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74062'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   Leave
     C                   Endif
                                                                                211499
      * Check only one of *NAME or *NAMAD may only be used once per field       211499
     C                   If        AComp(Y) = '*NAMAD'                          211499
     C     '*NAME '      Scan      WFldCom                                51    211499
     C                   If        *IN51 = *On                                  211499
     C                   EVAL      WErrFC = 'Y'                                 211499
     C                   EVAL      WError = 'Y'                                 211499
     C                   EVAL      PZMsgID = 'RE74074'                          211499
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'                     211499
     C                   EXSR      SRSndMsg                                     211499
     C                   Leave                                                  211499
     C                   Endif                                                  211499
     C                   Endif                                                  211499
     C                   If        AComp(Y) = '*NAME '                          211499
     C     '*NAMAD'      Scan      WFldCom                                51    211499
     C                   If        *IN51 = *On                                  211499
     C                   EVAL      WErrFC = 'Y'                                 211499
     C                   EVAL      WError = 'Y'                                 211499
     C                   EVAL      PZMsgID = 'RE74074'                          211499
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'                     211499
     C                   EXSR      SRSndMsg                                     211499
     C                   Leave                                                  211499
     C                   Endif                                                  211499
     C                   Endif                                                  211499
 
     C                   Eval      Y = Y + 1
 
     C                   Endif
 
     C                   Enddo
 
     C                   Endif
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMoveSF - Move Screen Fields to File Fields                 *
      *                                                               *
      *  Called by: SRAmend2                                          *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRMoveSF      BEGSR
 
     C                   EVAL      TDDEST = #0DEST
     C                   MOVE      #1RULE        TDRULE
     C                   EVAL      TDMT3T = #1MT3T
     C                   EVAL      TDMTG1 = #0MTG1
     C                   EVAL      TDMTH1 = #0HDR1
     C                   EVAL      TDFLD1 = #0FLD1
     C                   EVAL      TDMTG2 = #0MTG2
     C                   EVAL      TDMTH2 = #0HDR2
     C                   EVAL      TDFLD2 = #0FLD2
     C                   EVAL      TDMTG3 = #0MTG3
     C                   EVAL      TDMTH3 = #0HDR3
     C                   EVAL      TDFLD3 = #0FLD3
     C                   EVAL      TDMTG4 = #0MTG4
     C                   EVAL      TDMTH4 = #0HDR4
     C                   EVAL      TDFLD4 = #0FLD4
     C                   EVAL      TDMTG5 = #0MTG5
     C                   EVAL      TDMTH5 = #0HDR5
     C                   EVAL      TDFLD5 = #0FLD5
     C                   EVAL      TDMTG6 = #0MTG6
     C                   EVAL      TDMTH6 = #0HDR6
     C                   EVAL      TDMTG6 = #0FLD6
     C                   EVAL      TDSDEF = #0ZSWD
 
     C     #0DEST        CHAIN     RETBDSL0                           29
 
     C                   IF        *IN29 = *OFF
     C                   EVAL      TBDESC = #0DESC
     C                   UPDATE    RETBDSD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMoveFS - Move File Fields to Screen Fields                 *
      *                                                               *
      *  Called by: SREnquire2, SRDelete2, SRAmend2                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRMoveFS      BEGSR
 
     C                   MOVE      TDRULE        #1RULE
     C                   EVAL      #1MT3T = TDMT3T
     C                   EVAL      #0MTG1 = TDMTG1
     C                   EVAL      #0HDR1 = TDMTH1
     C                   EVAL      #0FLD1 = TDFLD1
     C                   EVAL      #0MTG2 = TDMTG2
     C                   EVAL      #0HDR2 = TDMTH2
     C                   EVAL      #0FLD2 = TDFLD2
     C                   EVAL      #0MTG3 = TDMTG3
     C                   EVAL      #0HDR3 = TDMTH3
     C                   EVAL      #0FLD3 = TDFLD3
     C                   EVAL      #0MTG4 = TDMTG4
     C                   EVAL      #0HDR4 = TDMTH4
     C                   EVAL      #0FLD4 = TDFLD4
     C                   EVAL      #0MTG5 = TDMTG5
     C                   EVAL      #0HDR5 = TDMTH5
     C                   EVAL      #0FLD5 = TDFLD5
     C                   EVAL      #0MTG6 = TDMTG6
     C                   EVAL      #0HDR6 = TDMTH6
     C                   EVAL      #0FLD6 = TDMTG6
     C                   EVAL      #0ZSWD = TDSDEF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClear - Clear Fields                                       *
      *                                                               *
      *  Called by: SREnquire2, SRDelete2, SRAmend2                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRClear       BEGSR
 
     C                   EVAL      #1RULE = *BLANKS
     C                   EVAL      #1MT3T = *BLANKS
     C                   EVAL      #0MTG1 = *BLANKS
     C                   EVAL      #0HDR1 = *BLANKS
     C                   EVAL      #0FLD1 = *BLANKS
     C                   EVAL      #0MTG2 = *BLANKS
     C                   EVAL      #0HDR2 = *BLANKS
     C                   EVAL      #0FLD2 = *BLANKS
     C                   EVAL      #0MTG3 = *BLANKS
     C                   EVAL      #0HDR3 = *BLANKS
     C                   EVAL      #0FLD3 = *BLANKS
     C                   EVAL      #0MTG4 = *BLANKS
     C                   EVAL      #0HDR4 = *BLANKS
     C                   EVAL      #0FLD4 = *BLANKS
     C                   EVAL      #0MTG5 = *BLANKS
     C                   EVAL      #0HDR5 = *BLANKS
     C                   EVAL      #0FLD5 = *BLANKS
     C                   EVAL      #0MTG6 = *BLANKS
     C                   EVAL      #0HDR6 = *BLANKS
     C                   EVAL      #0FLD6 = *BLANKS
     C                   EVAL      #0ZSWD = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRoll - Rollback or Commit Changes                          *
      *                                                               *
      *  Called by: SRProcActn1                                       *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRRoll        BEGSR
 
     C                   IF        WError = 'Y'
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Send Message                                      *
      *                                                               *
      *  Called by: SRLoad, SRVAction, SRValRec1, SRDelRec, SRLoad2,  *
      *             SRValRec2, SRDelete2, SRAmend2, SRVAction2,       *
      *             SRVFldCom, SRValDFlds                             *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRSndMsg      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      **********                                                                    211210 BUG6979
      ****GET*ZMUSER*to*access*default*branch.                                      211210 BUG6979
      **********                                                                    211210 BUG6979
     C******DTAARA       DEFINE                  ZMUSER                             211210 BUG6979
     C**********         IN        ZMUSER                                           211210 BUG6979
     C**********         UNLOCK    ZMUSER                                           211210 BUG6979
      **********                                                                    211210 BUG6979
      **Check*for*user*authority*to*insert                                          211210 BUG6979
      **********                                                                    211210 BUG6979
     C**********         CALL      'ZVACTBU'                                        211210 BUG6979
     C**********         PARM      'I'           @ZACTN            1                211210 BUG6979
     C**********         PARM      BRC           @ZBR              3                211210 BUG6979
     C**********         PARM      *ZERO         @ERR              1 0              211210 BUG6979
      **********                                                                    211210 BUG6979
     C**********         IF        @ERR = 2                                         211210 BUG6979
     C**********         MOVE      *ON           *IN15                              211210 BUG6979
     C**********         ENDIF                                                      211210 BUG6979
 
      ** Call Access Program for Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRtrnCode <> *BLANKS
     C                   EVAL      X_ERMS = 'Database error in file SDBANKPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise subfile control
 
     C                   EVAL      #0RUNA = BJMRDT
     C**********         EVAL      #0WSID = PSJobName                                      BUG6979
     C**********         EVAL      #0USER = PSUser                                         BUG6979
     C**********         EVAL      #2PGMQ = PSProcName                                     BUG6979
 
     C                   Z-ADD     14            WSflPag
     C                   Z-ADD     10            WSflPag2
 
     C     KRETBDD       KLIST
     C                   KFLD                    KDest
     C                   KFLD                    KRule
 
     C     KRETBDD2      KLIST
     C                   KFLD                    KDest
     C                   KFLD                    KMT3T
 
     C     KREZSHD       KLIST
     C                   KFLD                    KDest2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,RECMPSSR
      ********************************************************************
** MT101 - Message tags for MT101
SNDR
:20:
:21R:
:28D:
:50C:*BIC
:50F:*ACLIN                                                                                   CSW207
:50L:*ACLIN
:50G:*ACLIN    *BIC
:50H:*ACLIN    *NAMAD    *NAME
:52A:*ACLIN    *BIC
:52C:*ACLIN
:51A:*ACLIN    *BIC
:30: *DATE
:25:
:21:
:21F:
:23E:
:32B:*CCY      *AMT
:56A:*ACLIN    *BIC
:56C:*ACLIN
:56D:*ACLIN    *NAMAD    *NAME
:57A:*ACLIN    *BIC
:57C:*ACLIN
:57D:*ACLIN    *BIC
:59: *ACLIN    *NAMAD    *NAME
:59A:*ACLIN    *BIC
:70: *LINE1    *LINE2    *LINE3    *LINE4
:33B:*CCY      *AMT
:71A:
:25A:*ACLIN
:36: *RATE
** MT103 - Message tags for MT103
SNDR
:20:
:23B:
:23E:
:32A:*DATE     *CCY      *AMT
:33B:*CCY      *AMT
:50A:*ACLIN    *BIC
:50F:*ACLIN                                                                                   CSW207
:50K:*ACLIN    *NAMAD    *NAME
:51A:*ACLIN    *BIC
:52A:*ACLIN    *BIC
:52D:*ACLIN    *NAMAD    *NAME
:53A:*ACLIN    *BIC
:53B:*ACLIN    *LINE1
:53D:*ACLIN    *NAMAD    *NAME
:54A:*ACLIN    *BIC
:54B:*ACLIN    *LINE1
:54D:*ACLIN    *NAMAD    *NAME
:55A:*ACLIN    *BIC
:55B:*ACLIN    *LINE1
:55D:*ACLIN    *NAMAD    *NAME
:56A:*ACLIN    *BIC
:56C:*ACLIN
:56D:*ACLIN    *NAMAD    *NAME
:57A:*ACLIN    *BIC
:57B:*ACLIN    *LINE1
:57C:*ACLIN
:57D:*ACLIN    *NAMAD    *NAME
:59: *ACLIN    *NAMAD    *NAME
:59A:*ACLIN    *BIC
:70: *LINE1    *LINE2    *LINE3    *LINE4
:71A:
:71F:*CCY      *AMT
:71G:*CCY      *AMT
:72:
:77B:
** MT101H - Header tags for MT101
:20:
:21R:
:28D:
:50C:
:50F:                                                                                         CSW207
:50L:
:50G:
:50H:
:52A:
:52C:
:51A:
:51A:
:30:
:25:
** MT101D - Detail tags for MT101
:21:
:21F:
:23E:
:32B:
:50C:
:50F:                                                                                         CSW207
:50L:
:50G:
:50H:
:52A:
:52C:
:56A:
:56C:
:56D:
:57A:
:57C:
:57D:
:59:
:59A:
:70:
:77B:
:33B:
:71A:
:25A:
:36A:
