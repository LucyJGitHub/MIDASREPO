     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details browse')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECDBRW - SECURITY CUSTOMER DETAILS BROWSE                 *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of securities clients details  *
      *             for selection , the other picks off the           *
      *             selection made.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR694139           Date 07Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 249076             Date 03Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11828           Date 13Aug06               *
      *                 CSD027             Date 05Jan06               *
      *                 CSE070             Date 15Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CSD018             Date 27Nov02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 01Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR694139 - Filtering and amending customer number not        *
      *             working properly (Child: AR694140)                *
      *             (Recompile)                                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  BUG11828 - If CSD031 is on, System Values are defined        *
      *             centrally.                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSD018 - Restrict Access to Customers By Branch.             *
      *  CAP039 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDSECDBDF CF   E             WORKSTN
     F                                     SFILE(SDSECDBS1:@@RRN)
      * Securities Clients Details File - by Customer Number
     FSDSECSL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BFREDP:SECFMAT)
 
      * Customer file - by Customer Number
     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BBREBG:CUSTNUM)
 
     **  Valid Booking Branches by User.                                                      CSD018
     FMBRBS     IF   E           K DISK    INFSR(*PSSR)                                       CSD018
                                                                                              CSD018
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WWVBRX          S              3    DIM(900) ASCEND                                    CSD018
                                                                                              CSD018
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details                                                          CSD018
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD018
                                                                                              CSD018
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      **  Third DS for access programs, very long data structure                              CSD018
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CSD018
                                                                                              CSD018
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)                   CSD027
     D PRetCode        S              7A                                                      CSD027
     D PSysValK1       S             20A                                                      CSD027
     D PSysVal1        S            200A                                                      CSD027
     D PSysValK2       S             20A                                                      CSD027
     D PSysVal2        S            200A                                                      CSD027
     D PSysValK3       S             20A                                                      CSD027
     D PSysVal3        S            200A                                                      CSD027
     D PSysValK4       S             20A                                                      CSD027
     D PSysVal4        S            200A                                                      CSD027
     D PSysValK5       S             20A                                                      CSD027
     D PSysVal5        S            200A                                                      CSD027
     D PSysValK6       S             20A                                                      CSD027
     D PSysVal6        S            200A                                                      CSD027
     D PSysValK7       S             20A                                                      CSD027
     D PSysVal7        S            200A                                                      CSD027
     D PSysValK8       S             20A                                                      CSD027
     D PSysVal8        S            200A                                                      CSD027
     D PSysValK9       S             20A                                                      CSD027
     D PSysVal9        S            200A                                                      CSD027
     D PSysValK10      S             20A                                                      CSD027
     D PSysVal10       S            200A                                                      CSD027
      *                                                                                       CSD027
      * For holding the system values                                                         CSD027
     DWCusAlphaAllow   S            200A                                                      CSD027
     DWCusAlphaSupNum  S            200A                                                      CSD027
      *                                                                                       CSD027
      ** Parameters for calling SDCUSTISO (Validate Customer Number)                          CSD027
     D PCust           S              6A                                                      CSD027
     D PValid          S              6A                                                      CSD027
     D PCheckDigit     S              1A                                                      CSD027
                                                                                            BUG11828
      ** Access Object Parameters                                                           BUG11828
     D PRtcd           S              7A                                                    BUG11828
     D POptn           S              7A                                                    BUG11828
     D PSARD           S              6A                                                    BUG11828
                                                                                            BUG11828
      ** Switchable Features                                                                BUG11828
     D CSD031          S              1A                                                    BUG11828
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDCUSN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Initialization
      *
     C                   EXSR      INIT
 
      ** BUILD Sub-file
 
     C     @BDSFL        IFEQ      'Y'
 
      ** On F5, initialize position/select fields
      *
     C     *INKE         DOUEQ     '0'
      *
     C     *INKE         IFEQ      '1'
      *
     C                   MOVE      *BLANK        DDCUSN
     C                   MOVE      *BLANK        SBCUST
     C                   MOVE      *BLANK        SBCSSN
     C                   MOVE      *BLANK        SBCRNM
     C                   MOVE      *BLANK        SBCRTN
 
      ** Clear program message queue
     C                   CALL      'ZA0250'
 
     C                   ENDIF
 
     C                   EXSR      BLDSFL
 
     C                   ENDDO
 
     C                   ENDIF
 
 
      ** READ Subfile Record
 
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ** Validate Customer Reference (FOR POINTER)
      *
     C                   EXSR      VALCUST
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDSECDBS0
     C                   MOVE      '0'           *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C     @@CUST        SETLL     SECFMAT
      *
      **  Read a Valid Customer
      *
     C                   EXSR      RDCUST
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Format customer fields for output
      *
     C                   EXSR      FMTCUS
      *
      **  Write the customer to the subfile.
      *
      **  If action code or customer number selected is invalid
      **  the subfile postions on the error record and rebuilds
      *
     C                   MOVE      *OFF          *IN92
     C     @@RRN         IFNE      1
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDCUSN    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   MOVE      *BLANK        DDOPT
     C                   ELSE
     C                   MOVE      *ON           *IN92
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SDSECDBS1
      *
      **  Read a valid Customer
      *
     C                   EXSR      RDCUST
     C                   ENDDO
      *
      **  Write the footer
      *
     C                   WRITE     SDSECDBF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SDSECDBM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDSECDBS0
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     c                   MOVE      '1'           *IN93
     C                   WRITE     SDSECDBS1
     c                   MOVE      '0'           *IN93
     C                   WRITE     SDSECDBS0
     c                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDSECDBS0
     c                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDSECDBS0                              99
      *
      ** Clear any messages before processing user input
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
      *
      **  If F3, bypass further processing.
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F9, bypass further processing.
     C     *INKI         IFEQ      '1'
     C                   MOVEL     'I'           @OPSEL
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
 
     C                   READC     SDSECDBS1                              99
 
     C                   END
      *
      **  Return the selected customer reference and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *
     C                   MOVE      DDCUS         @CUSEL
      *
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTCUS - FORMAT CUSTOMER FOR OUTPUT
      ******************************************************************
     C     FMTCUS        BEGSR
 
      * Customer reference
 
     C                   MOVE      BFCUST        DDCUS
     C     *in95         IFEQ      '0'
     C                   MOVE      BBCSSN        DDCSSN
     C                   MOVE      BBCRNM        DDCRNM
     C                   MOVE      BBCRTN        DDCRTN
     C                   ELSE
     C                   MOVEL     *ALL' '       DDCSSN
     C                   MOVEL     *ALL' '       DDCRNM
     C                   MOVEL     *ALL' '       DDCRTN
     C                   ENDIF
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RDCUST - READ A CUSTOMER
      *****************************************************************
     C     RDCUST        BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     BFCUST        ORNE      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
     C     BFTYLC        ANDNE     'D'
     C     WSHOW         ANDEQ     'Y'                                                        CSD018
      *
      **  Read the file
      *
      **  Position according to customer number
      *
     C     SBCUST        IFNE      *BLANK
     C     SBCUST        SETLL     SECFMAT                            89
     C                   READ      SECFMAT                                96
     C     BFCUST        CHAIN     CUSTNUM                            95
     C                   MOVE      *BLANK        SBCUST
     C                   ELSE
     C                   READ      SECFMAT                                96
     C     BFCUST        CHAIN     CUSTNUM                            95
     C                   ENDIF
      *
     C                   EXSR      SRSHOW                                                     CSD018
      *                                                                                       CSD018
      ** Select according to customer shortname mask
      *
     C     SBCSSN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCSSN
     C                   PARM      10            LENGTH1           3 0
     C                   PARM      1             START             3 0
     C                   PARM                    SBCSSN
     C                   PARM      10            LENGTH2           3 0
     C                   PARM      '1'           TRANSLATE         1
     C                   PARM      '1'           TRIM              1
     C                   PARM      '?'           WILD              1
     C                   PARM                    RESULT            3 0
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BFCUST
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to customer report name mask
      *
     C     SBCRNM        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRNM
     C                   PARM      20            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SBCRNM
     C                   PARM      20            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BFCUST
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to customer report town mask
      *
     C     SBCRTN        IFNE      *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    BBCRTN
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    SBCRTN
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C     RESULT        IFLT      1
     C                   MOVE      *BLANK        BFCUST
     C                   ENDIF
     C                   ENDIF
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
     C                   END
      *
     C     ERDCUST       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALCUST - VALIDATE CUSTOMER REFERENCE POINTER
      *****************************************************************
     C     VALCUST       BEGSR
      *
      **  Validate that the customer reference is numeric or blank.
      *
     C                   TESTN                   DDCUSN               98
     C                   MOVE      DDCUSN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
      *
      ** If Alphanumeric Customer Numbers are enabled                                         CSD027
     C                   If        WCusAlphaAllow = 'Y'                                       CSD027
     C                   Eval      PCust = DDCUSN                                             CSD027
     C                   Eval      PValid = *BLANKS                                           CSD027
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO                                  CSD027
      * If Error                                                                              CSD027
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)                    CSD027
     C                   Eval      DBFILE = 'SDCUSTISO'                                       CSD027
     C                   Eval      DBASE = 903                                                CSD027
     C                   Eval      DBKEY = PCust                                              CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C*****DDCUSN        IFEQ      *BLANKS                                                    CSD027
     C******IN98         OREQ      '1'                                                        CSD027
     C******IN99         ANDEQ     '1'                                                        CSD027
     C**********         MOVE      DDCUSN        @@CUST            6                          CSD027
      **********                                                                              CSD027
      * RETURN ERROR MESSAGE                                                                  CSD027
      **********                                                                              CSD027
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     'MMA0087'     @ERRMS                                       CSD027
     C**********         RETURN                                                               CSD027
     C**********         END                                                                  CSD027
      *                                                                                       CSD027
      * Check if Customer# is valid                                                           CSD027
     C                   If        DDCUSN = *BLANKS                                           CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'N' And                                  CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'Y' And                                  CSD027
     C                              WCusAlphaSupNum = 'Y' And                                 CSD027
     C                              *IN98 = *ON And *IN99 = *ON)                              CSD027
     C                             Or                                                         CSD027
     C                             (WCusAlphaAllow = 'Y' And                                  CSD027
     C                              WCusAlphaSupNum = 'N' And                                 CSD027
     C                              PValid = *BLANKS)                                         CSD027
     C                   Move      DDCUSN        @@CUST            6                          CSD027
      * If invalid Customer#, return error message                                            CSD027
     C                   Else                                                                 CSD027
      *                                                                                       CSD027
     C                   If        WCusAlphaAllow = 'N'                                       CSD027
     C                   Eval      @ERRMS = 'S270003'                                         CSD027
     C                   Else                                                                 CSD027
     C                   Eval      @ERRMS = 'S270004'                                         CSD027
     C                   move      *blanks       @data                                        249076
     C                   movel     @datarcv      @data                                        249076
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   Return                                                               CSD027
     C                   EndIf                                                                CSD027
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @CUSEL
     C                   MOVE      '0'           @INKC
      *
     C                   ENDSR
      *
      *****************************************************************                       CSD018
      * SRSHOW - Determine if details should be shown                                         CSD018
      *****************************************************************                       CSD018
     C     SRSHOW        BEGSR                                                                CSD018
                                                                                              CSD018
     C                   MOVE      'Y'           WSHOW             1                          CSD018
      *                                                                                       CSD018
     C     CSD018        IFEQ      'Y'                                                        CSD018
      *                                                                                       CSD018
      ** When building the sub-file of Securities Clients Details,                            CSD018
      *  do not include the records if the branch code of the customer                        CSD018
      *  being processed does not exist for this Midas user on file                           CSD018
      *  MBRBSDD.                                                                             CSD018
      *                                                                                       CSD018
      * Check if the User is authorized to the branch code of the                             CSD018
      * Customer being processed.                                                             CSD018
      *                                                                                       CSD018
     C     PsUser        CHAIN     MBRBS                              74                      CSD018
      *                                                                                       CSD018
     C     *IN74         IFEQ      '0'                                                        CSD018
     C     RECI          ANDEQ     'D'                                                        CSD018
     C                   MOVEA     VBRX          WWVBRX                                       CSD018
     C     BBBRCD        LOOKUP    WWVBRX                                 73                  CSD018
     C     *IN73         IFEQ      *OFF                                                       CSD018
     C                   MOVE      'N'           WSHOW                                        CSD018
     C                   ENDIF                                                                CSD018
     C                   ENDIF                                                                CSD018
      *                                                                                       CSD018
     C                   ENDIF                                                                CSD018
                                                                                              CSD018
     C                   ENDSR                                                                CSD018
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return Code
     C                   PARM                    RetCodeIn
      * Action Code
     C                   PARM                    DDACTN            1
      * Customer Reference Pointer
     C                   PARM                    DDCUSN            6
      * Build Subfile
     C                   PARM                    @BDSFL            1
      * Read Subfile Record
     C                   PARM                    @RDSFL            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * Error Message
      * Option Selected
      * Customer Reference selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @data            45                          249076
     C                   PARM                    @OPSEL            1
     C                   PARM                    @CUSEL            6
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
      *
      ** Parameter list for calling AOSVALR0                                                  CSD027
     C     P_AOSVALR0    PList                                                                CSD027
      * Return Code (Output)                                                                  CSD027
     C                   Parm                    PRetCode                                     CSD027
      * System Value to be retrieved (Input)                                                  CSD027
     C                   Parm                    PSysValK1                                    CSD027
      * Value returned (Output)                                                               CSD027
     C                   Parm                    PSysVal1                                     CSD027
     C                   Parm                    PSysValK2                                    CSD027
     C                   Parm                    PSysVal2                                     CSD027
     C                   Parm                    PSysValK3                                    CSD027
     C                   Parm                    PSysVal3                                     CSD027
     C                   Parm                    PSysValK4                                    CSD027
     C                   Parm                    PSysVal4                                     CSD027
     C                   Parm                    PSysValK5                                    CSD027
     C                   Parm                    PSysVal5                                     CSD027
     C                   Parm                    PSysValK6                                    CSD027
     C                   Parm                    PSysVal6                                     CSD027
     C                   Parm                    PSysValK7                                    CSD027
     C                   Parm                    PSysVal7                                     CSD027
     C                   Parm                    PSysValK8                                    CSD027
     C                   Parm                    PSysVal8                                     CSD027
     C                   Parm                    PSysValK9                                    CSD027
     C                   Parm                    PSysVal9                                     CSD027
     C                   Parm                    PSysValK10                                   CSD027
     C                   Parm                    PSysVal10                                    CSD027
      *                                                                                       CSD027
      ** Parameter list for calling SDCUSTISO                                                 CSD027
     C     P_SDCUSTISO   PList                                                                CSD027
      ** Customer Number (Input)                                                              CSD027
     C                   Parm                    PCust                                        CSD027
      ** Validity Flags (Output)                                                              CSD027
     C                   Parm                    PValid                                       CSD027
      ** Check Digit (Output)                                                                 CSD027
     C                   Parm                    PCheckDigit                                  CSD027
     C                   Parm                    @datarcv          2                          249076
      *
      ** Initialize program name
     C                   MOVEL     'SDSECDBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
     C                   MOVE      '1'           *IN94
     C                   MOVEL     '*'           DDPGMQ
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                            BUG11828
      ** Check if CSD031 is on.                                                             BUG11828
                                                                                            BUG11828
     C                   CALL      'AOSARDR0'                                               BUG11828
     C                   PARM      *BLANKS       PRtCd                                      BUG11828
     C                   PARM      '*VERIFY'     POptn                                      BUG11828
     C                   PARM      'CSD031'      PSARD                                      BUG11828
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG11828
                                                                                            BUG11828
     C                   IF        PRtCd = *BLANKS                                          BUG11828
     C                   EVAL      CSD031 = 'Y'                                             BUG11828
     C                   ELSE                                                               BUG11828
                                                                                            BUG11828
     C                   IF        PRtCd <> '*NRF   '                                       BUG11828
     C     *LOCK         IN        LDA                                                      BUG11828
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG11828
     C                   EVAL      DBKey = POptn                                            BUG11828
     C                   EVAL      DBase = 101                                              BUG11828
     C                   OUT       LDA                                                      BUG11828
     C                   EXSR      *PSSR                                                    BUG11828
     C                   ENDIF                                                              BUG11828
                                                                                            BUG11828
     C                   ENDIF                                                              BUG11828
      *
      ** Access SAR details to check if CSD018 is installed                                   CSD018
                                                                                              CSD018
     C                   CALLB     'AOSARDR0'                                                 CSD018
     C                   PARM      *BLANKS       @RTCD                                        CSD018
     C                   PARM      '*VERIFY'     @OPTN                                        CSD018
     C                   PARM      'CSD018'      @SARD             6                          CSD018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD018
                                                                                              CSD018
     C     @RTCD         IFNE      *BLANKS                                                    CSD018
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD018
     C                   MOVEL     '902'         DBASE                                        CSD018
     C                   MOVEL     @SARD         DBKEY                                        CSD018
     C                   EXSR      *PSSR                                                      CSD018
     C                   ENDIF                                                                CSD018
                                                                                              CSD018
     C     @RTCD         IFEQ      *BLANKS                                                    CSD018
     C                   MOVEL     'Y'           CSD018            1                          CSD018
     C                   ELSE                                                                 CSD018
     C                   MOVEL     'N'           CSD018                                       CSD018
     C                   ENDIF                                                                CSD018
      *                                                                                       CSD018
 
      * Retrieve System Value 'CustAlphaAllow' & 'CustAlphaSupNumeric'                        CSD027
     C                   Eval      PRetCode = *BLANKS                                         CSD027
     C                   Eval      PSysValK1 = 'CustAlphaAllow'                               CSD027
     C                   Eval      PSysVal1 = *BLANKS                                         CSD027
     C                   Eval      PSysValK2 = 'CustAlphaSupNumeric'                          CSD027
     C                   Eval      PSysVal2 = *BLANKS                                         CSD027
     C**********         CallB(E)  'AOSVALR0'    P_AOSVALR0                          CSD027 BUG11828
                                                                                            BUG11828
     C                   IF        CSD031 = 'Y'                                             BUG11828
     C                   CALL (E)  'GPAOSVALR0'  P_AOSVALR0                                 BUG11828
     C                   ELSE                                                               BUG11828
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                 BUG11828
     C                   ENDIF                                                              BUG11828
      *                                                                                       CSD027
      * If Error retrieving the System value                                                  CSD027
     C                   If        %Error Or PRetCode <> *BLANKS                              CSD027
     C                             Or (*INU7 = *ON And *INU8 = *ON)                           CSD027
     C                   Eval      DBFILE = 'SDSVALPD'                                        CSD027
     C                   Eval      DBASE = 904                                                CSD027
     C                   Eval      DBKEY = 'CustAlpha(Allow/SupNumeric)'                      CSD027
     C                   ExSr      *PSSR                                                      CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       CSD027
     C                   Eval      WCusAlphaAllow  = PSysVal1                                 CSD027
     C                   Eval      WCusAlphaSupNum = PSysVal2                                 CSD027
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      *
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
