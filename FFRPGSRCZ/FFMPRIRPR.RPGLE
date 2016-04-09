     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Invalid Market Prices Repair')                *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Market Price API                 *
      *                                                               *
      *  FFMPRIRPR - Invalid Midas FF Market Prices Details           *
      *              Repair Function                                  *
      *                                                               *
      *  Function:  This function  allows  invalid  Market  Prices    *
      *             details to be 'repaired' and  applied  to  the    *
      *             Midas database.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 245144             Date 24Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  245144 - Parameter mismatch when calling FFMPRICVT.          *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction error details
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Invalid Market Prices transactions by timestamp and
      ** front-office ID
     FFFIMPRIL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFIMPRID0:FFIMPRIX0)
 
      ** Invalid Market Prices transactions by front-office ID
      ** and timestamp
     FFFIMPRIL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas FF Instrument Types
     FINTYP     IF   E           K DISK
 
      ** API invalid log file
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFMPRIR001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
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
 
     D @EI             S              1    DIM(60)
 
      ** Array of Fields in error, temporary store
     D TmpFldNmAr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs, temporary store
     D TmpMsgIdAr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Current Market Prices Transaction in File Format
     D CrTrFilFmt    E DS                  EXTNAME(PRICSD)
     D                                     PREFIX(C_)
 
      ** Current Market Prices Transaction in Screen Format
     D CurTrScrn     E DS                  EXTNAME(FFMPRIPD)
     D                                     PREFIX(@)
 
      ** New Market Prices Transaction in File Format
     D NwTrFilFmt    E DS                  EXTNAME(FFVMPRIPD)
 
      ** New Market Prices Transaction in Screen Format
     D NewTrScrn     E DS                  EXTNAME(FFMPRIPD)
 
      ** Previous Market Prices Transaction in Screen Format
     D PrvTrScrn     E DS                  EXTNAME(FFMPRIPD)
     D                                     PREFIX(@P)
 
      ** Error indicators
     D OKTrMPRI      E DS                  EXTNAME(FFEMPRIPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** FF Market Prices Transaction Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(FFMPEXPD)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
      ** Changed Party Names Array
     D ChgNamArr       S              1    DIM(5)
 
      ** Data structure for data area SC24X7
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Parameter: Market Prices Transaction Reference Parameter Keys
     D PRTRNN          DS
     D  PRISTT                 1      5
     D  PRMRKT                 1      2
     D  PRISTC                 3      5
     D  PRMTHN                 6      8
     D  PRYRNO                 9     10
     D  PRPCAL                11     11
     D  PRSTRP                12     27
 
      ** Key List: Key List for chaining to invalid file
     D KYTRNN          DS
     D  KYISTT                 1      5
     D  KYMRKT                 1      2
     D  KYISTC                 3      5
     D  KYMTHN                 6      8
     D  KYYRNO                 9     10
     D  KYPCAL                11     11
     D  KYSTRP                12     27
 
      ** Transaction reference record selected from RPB parameters
     D @MRKTSEL        S                   LIKE(DDMRKT)
     D @ISTCSEL        S                   LIKE(DDISTC)
     D @MTHNSEL        S                   LIKE(DDMTHN)
     D @YRNOSEL        S                   LIKE(DDYRNO)
     D @PCALSEL        S                   LIKE(DDPCAL)
     D @STRPSEL        S                   LIKE(DDSTRP)
     D @NEWPSEL        S                   LIKE(DDNEWP)
 
      ** APYOVR  parameter
     D wMember         S              2A
     D wMarketIns      S              5A
 
      ** CSC011 enhancement
     D CSC011          S              1A   INZ('N')
 
      ** Work field for Message type
     D WMTYP           S                   LIKE(APMTYP)
 
      ** Numeric equivalent of Strike Price
     D NDDSTRP         S             15P 8
 
      ** Define parameters for AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
      ** -----------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D FormatA         S             10A   INZ('FFMPRIPD')
 
     D FieldA          S             10A   INZ('DDFLD1')
 
     D FldOffsetA      S              5P 0
 
     D FieldNo         S              5P 0
 
      ** End of fields for getting starting field number
 
      ** -----------------------------------------------------------------
 
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepMPRI         S              1A   inz('N')
      *
 
      ** Flags
     D POTCFlag        S              1A
     D wInstMissingF   S              1A
 
      ** Transaction Status
     D PTransStat      S             10A
      ** -----------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFMPRIR002
 
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
      /COPY WNCPYSRC,FFMPRIR003
      *
      *
      *
      ** Issue rollback to clear any possible updates in window functions
     C                   IF        @INKL = '1'
     C                   ROLBK
     C                   ENDIF
      *
      *
      *
      ** DO Screen: Browse 'Invalid Market Prices' Inputs
     C                   IF        @SCRN = 'B'
     C                   EXSR      SCRN@B
     C                   ENDIF
      *
      *
      *
      ** Read next browse subfile 'Invalid' record
     C                   IF        @SCRN = 'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      *
      *
      ** DO WHILE Details Screen
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   DOW       @SCRN = 'D'
     C                   EXSR      SCRN@D
     C                   ENDDO
      *
      *
      *
      ** Screen: Confirmation of Input
     C                   IF        @SCRN = 'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      *
      *
      ** Do File updates
     C                   IF        @SCRN = 'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      *
      *
      ** Terminate program
     C                   IF        @SCRN = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFMPRIR004
 
      /EJECT
      *****************************************************************
      * SCRN@B - BROWSE INVALID MARKET PRICES TRANSACTIONS
      *****************************************************************
     C     SCRN@B        BEGSR
      *
      ** Reset read next browse Subfile Record
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ** Build Browse Subfile
     C                   CALLB     'FFMPRIRPB'
      *
      ** Input Parameters
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Build Sub-File
     C                   PARM      'Y'           @BDSFL            1
      *
      ** Read Subfile Record
     C                   PARM      *BLANK        @RDSFL            1
      *
      ** Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      ** Output Parameters
      *
      ** Error Message
     C                   PARM      *BLANK        @ERRMS            7
      *
      ** Option Selected
     C                   PARM                    @OPSEL            1
      *
      ** Action Selected
     C                   PARM                    @ACSEL            1
      *
      ** FO Transaction ID Selected
     C                   PARM                    @FOTRANSEL       20
      *
      ** 'Invalid Market Price Transaction' Fields Selected from BRW
      *
     C                   PARM                    @MRKTSEL
     C                   PARM                    @ISTCSEL
     C                   PARM                    @MTHNSEL
     C                   PARM                    @YRNOSEL
     C                   PARM                    @PCALSEL
     C                   PARM                    @STRPSEL
     C                   PARM                    @NEWPSEL
      *
      ** Timestamp of Transaction Record Selected
     C                   PARM                    @TMESTPSEL
      *
      ** Command Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      ** Enhancement CSC011
     C                   PARM                    CSC011
      *
      ** If error set on external switches
     C                   IF        @ERRMS <> *BLANK
     C                   EVAL      *INU6 = *ON
     C                   ENDIF
      *
      ** If CK/3 or CK/12 taken in browse, or error message
      ** End program
     C                   IF        @INKC = '1' OR
     C                             @INKL = '1' OR
     C                             @ERRMS <> *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   ENDIF
 
      ** Check if Instrument is OTC
     C                   EXSR      SrOTCCheck
      *
      ** Read next browse subfile record
     C                   EVAL      @RDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
      *
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      ** Read Next Subfile Record
     C                   CALLB     'FFMPRIRPB'
      *
      ** Input Parameters
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Build Sub-File
     C                   PARM      *BLANK        @BDSFL
      *
      ** Read Subfile Record
     C                   PARM      'Y'           @RDSFL
      *
      ** Error in update of previous deal
     C                   PARM                    @ERRUP
      *
      ** Output Parameters
      *
      ** Error Message
     C                   PARM      *BLANK        @ERRMS
      *
      ** Option Selected
     C                   PARM      *BLANK        @OPSEL
      *
      ** Action Selected
     C                   PARM      *BLANK        @ACSEL
      *
      ** FO Transaction ID Selected
     C                   PARM      *BLANK        @FOTRANSEL
      *
      ** 'Invalid Market Price Transaction' Fields Selected from BRW
      *
     C                   PARM                    @MRKTSEL
     C                   PARM                    @ISTCSEL
     C                   PARM                    @MTHNSEL
     C                   PARM                    @YRNOSEL
     C                   PARM                    @PCALSEL
     C                   PARM                    @STRPSEL
     C                   PARM                    @NEWPSEL
      *
      ** Timestamp of Transaction Record Selected
     C                   PARM                    @TMESTPSEL
      *
      ** Command Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
 
      ** Enhancement CSC011
     C                   PARM                    CSC011
      *
      ** If CK/3 taken within invalid transaction deletion function,
      ** End program
     C                   IF        @INKC = '1'
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   ENDIF
 
      ** Check if Instrument is OTC
     C                   EXSR      SrOTCCheck
      *
      ** If invalid customer read from subfile
     C                   IF        @OPSEL <> *BLANK
      *
      ** Clear file formats
     C                   CLEAR                   NwTrFilFmt
      *
      ** Blank the screens
     C                   CLEAR                   NewTrScrn
      *
      ** Reset Errors
     C                   MOVE      *ALL'Y'       OKTrMPRI
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   Z-ADD     0             Idx
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIdArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   Z-ADD     0             WIdx
      *
      ** Retrieve Transaction details
     C                   EVAL      PRFRNT = @FOTRANSEL
     C                   EVAL      PRMRKT = @MRKTSEL
     C                   EVAL      PRISTC = @ISTCSEL
     C                   EVAL      PRMTHN = @MTHNSEL
     C                   EVAL      PRYRNO = @YRNOSEL
     C                   EVAL      PRPCAL = @PCALSEL
     C                   EVAL      PRSTRP = @STRPSEL
      *
      ** Move selected transaction key to NewTrScrn for DSP
     C                   EVAL      DDACTN = @ACSEL
     C                   EVAL      DDMRKT = @MRKTSEL
     C                   EVAL      DDISTC = @ISTCSEL
     C                   EVAL      DDMTHN = @MTHNSEL
     C                   EVAL      DDYRNO = @YRNOSEL
     C                   EVAL      DDPCAL = @PCALSEL
     C                   EVAL      DDSTRP = @STRPSEL
     C                   EVAL      DDNEWP = @NEWPSEL
      *
      ** Make sure Invalid transaction's  details are passed to 'Retrieve'
      ** module for SPF checking .
     C     ZATRNKX0      CHAIN     FFIMPRIX0                          99
      *
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ** if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).
 
     C                   IF        DDACTN = 'I'
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   IF        PRTRNN = *BLANK
     C                   MOVEL     '*FRONT'      @@MODE
     C                   ELSE
     C                   MOVEL     '      '      @@MODE
     C                   ENDIF
     C                   ENDIF
      *
      *
     C                   EXSR      RTVTRN
      *
      ** If Market Prices Transaction details were retrieved
      ** Convert to screen format.
      *
     C                   IF        C_ISTT <> *BLANK AND
     C                             C_YRNO <> *ZEROS AND
     C                             C_MTHN <> *ZEROS AND
     C                             DDACTN <> 'I'
     C                   EXSR      CVTTRN
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
     C                   ENDIF
      *
      ** Now overwite the fields on the main details screen with those
      ** on the invalid Transactions file (except for the Midas Transaction
      ** reference retrieved above using the front office transaction ID).
      ** Access invalid transaction with timestamp and front office transaction ID.
      *
      ** Market Prices Transaction details:
     C                   MOVEL     PRISTT        KYISTT
     C                   MOVE      PRMTHN        KYMTHN
     C                   MOVE      PRYRNO        KYYRNO
     C                   MOVE      PRPCAL        KYPCAL
     C                   MOVE      PRSTRP        KYSTRP
      *
     C     ZATRNKX0      CHAIN     FFIMPRIX0                          99
      *
     C     C_RECI        IFNE      *BLANK
     C     DIACTN        ANDNE     'I'
     C                   MOVEL     KYISTT        PRISTT
     C                   MOVE      KYMTHN        PRMTHN
     C                   MOVE      KYYRNO        PRYRNO
     C                   MOVE      KYPCAL        PRPCAL
     C                   MOVE      KYSTRP        PRSTRP
     C                   ENDIF
      *
      ** If Transaction details were retrieved and this is an amendment
      *
     C                   IF        C_ISTT <> *BLANK AND
     C                             C_YRNO <> *ZEROS AND
     C                             C_MTHN <> *ZEROS AND
     C                             DDACTN = 'A'
 
      ** Data Substitution - Transaction Details
 
     C                   IF        GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      NewTrScrn                              99
     C                   IF        *IN99 = *ON
     C                   EVAL      RepMPRI = 'Y'
     C                   ENDIF
 
      ** If any of the flags set above is true, do the data
      ** substitution subroutine.
     C                   IF        RepMPRI = 'Y'
     C                   EXSR      TDtDtaSubs
     C                   ENDIF
 
     C                   ENDIF
 
 
     C                   ENDIF
      *
      ** If action code, or Transaction reference were NOT OK
      ** blank out action code so that the input cannot proceed
      **
     C                   IF        OKACTN   = 'N' OR
     C                             OKISTC   = 'N' AND
     C                             OKMTHN   = 'N' AND
     C                             OKYEAR   = 'N' AND
     C                             OKPCAL   = 'N'
     C                   EVAL      DDACTN = *BLANK
     C                   ENDIF
      *
      ** Send the Transactions error messages to the details screen
      ** and GO TO DETAILS SCREEN
      *
     C                   EXSR      SNDM@D
     C                   EVAL      @SCRN = 'D'
 
      ** Else if No Invalid Transaction Read from Subfile
      *
     C                   ELSE
      *
      ** Go to browse screen
      *
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
      *
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@D - SEND A MESSAGE TO DETAILS SCREEN
      *****************************************************************
     C     SNDM@D        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C                   IF        OKACTN   = 'N'
     C                   ADD       1             E
      *
      ** Ensure that the message 'TRANSACTION CANNOT PROCEED' is seen
      ** first by the user
      *
     C                   EVAL      TmpfldNmAr = *BLANKS
     C                   EVAL      TmpMsgIdAr = *BLANKS
     C                   MOVEA     FldNameArr    TmpFldNmAr
     C                   MOVE      *BLANKS       FldNameArr(1)
     C                   MOVEA     TmpFldNmAr    FldNameArr(2)
     C                   MOVEA     MsgIdArr      TmpMsgIdAr
     C                   MOVE      *BLANKS       MsgIdArr(1)
     C                   MOVEA     TmpMsgIdAr    MsgIdArr(2)
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0110'     MsgIdArr(1)
     C                   ENDIF
      *
      ** Initialise error indicators
      *
     C                   MOVEA     OKTrMPRI      @EI
      *
      ** Read error messages for Transactions
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C                   DOW       *IN99 = '0'
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    FormatA
     C                   PARM                    ABFIELDNAM
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetA    F
     C                   IF        F < 1 OR
     C                             F > 60
     C                   EVAL      F = 1
     C                   ENDIF
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKTrMPRI
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@D - PROCESS SCREEN
      *****************************************************************
     C     SCRN@D        BEGSR
      *
      ** Enable/disable detail fields on primary details screen
      ** if changes to the data are allowed
      ** (key fields = action code & Transaction reference; detail fields = rest)
      ** (Action code can only be 'I', 'A', 'D', or 'E')
      *
     C                   IF        DDACTN = 'I' AND
     C                             @OPSEL = 'U' OR
     C                             DDACTN = 'A' AND
     C                             @OPSEL = 'U'
     C                   EVAL      @EDTFD = 'Y'
     C                   ELSE
     C                   EVAL      @EDTFD = 'N'
     C                   ENDIF
      *
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
     C                   IF        DDACTN = 'D'
     C                   EVAL      @EINKJ = 'Y'
     C                   ELSE
     C                   EVAL      @EINKJ = 'N'
     C                   ENDIF
 
      ** Update 'previous' screen
     C                   EVAL      PrvTrScrn = NewTrScrn
      *
     C                   EVAL      PTransStat  = *BLANKS
      *
      ** Set function key status on PRIMARY screen
     C                   EXSR      SFKEYS
      *
      ** WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'FFMPRIDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Input Parameters :
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Transaction (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewTrScrn
 
     C                   PARM                    PTransStat
      *
      ** Fields in error
     C                   PARM                    OKTrMPRI
 
      ** Market Prices Transaction Reference Key
     C                   PARM                    PRTRNN
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled Key & Detail Fields
      *
     C                   PARM                    @EDTFD            1
      *
      *
      ** Enabled Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KX = Command Key 23 = Further Details
     C                   PARM                    @EINKJ            1
      *
      ** Screen to display
     C                   PARM      'X'           PSCRN
      *
      ** Output Parameters :
      ** Function Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
      *
      ** Reset Errors ....
      *
     C                   MOVE      *ALL'Y'       OKTrMPRI
     C                   EVAL      FldNameArr =  *BLANK
     C                   EVAL      MsgIdArr   =  *BLANK
     C                   EVAL      MsgDtaArr  =  *BLANK
     C                   EVAL      WFldNamArr =  *BLANK
     C                   EVAL      WMsgIdArr  =  *BLANK
     C                   EVAL      WMsgDtaArr =  *BLANK
      *
      ** F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      ** F12 - Cancel on Screen
     C     @INKL         CASEQ     '1'           CANC@D
      *
      ** Validate input to screen
     C                   CAS                     VAL@D
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@D  - VALIDATE INPUT TO DETAILS SCREEN
      *****************************************************************
     C     VAL@D         BEGSR
      *
     C                   EVAL      CurTrScrn  = NewTrScrn
      *
      ** Retrieve Market Prices Transaction details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVTRN
      *
      ** If action code is NOT OK
      ** Re-output screen with error messages on it
      *
     C                   IF        OKACTN = 'N' OR OKISTC = 'N' OR
     C                             OKYEAR = 'N' OR OKMTHN = 'N' OR
     C                             OKPCAL = 'N' OR OKSTRP = 'N'
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      *----------------------------------------------------------------
      ** If Delete
      *
     C                   IF        DDACTN = 'D'
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
      *
      ** If CK/10 Taken, Go Onto Updates
      *
     C                   IF        @EINKJ = 'Y'
     C                   EVAL      @SCRN = 'U'
     C                   ENDIF
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      *----------------------------------------------------------------
 
      ** Validation process for Inserts and Amends
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
 
      ** Prior to validation, initialise error indicators as 'OK'
      ** and clear Transaction in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   MOVE      *ALL'Y'       OKTrMPRI
     C                   CLEAR                   NwTrFilFmt
      *
      ** Store current number of warnings
 
     C                   Z-ADD     WIdx          PrvN_Warn         3 0
     C                   Z-ADD     *ZERO         WIdx
 
      *
      ** Validate Market Prices Transaction details
      *
     C                   CALLB     'FFMPRIVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
 
      ** Response mode
     C                   PARM                    RespMode
 
      ** Transaction Primary Details
     C                   PARM                    NewTrScrn
 
      ** Extension File Data
     C                   PARM                    ExtData
 
      ** Strike price file format
     C                   PARM                    NDDSTRP
 
      ** Outputs:
 
      ** Transaction Primary Details OK inds
     C                   PARM                    OKTrMPRI
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Valid Transaction layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
 
      ** Instrument Types
     C                   PARM                    InstTypes
 
      *
      ** If errors returned
     C                   IF        Idx <> 0
     C                   GOTO      EndVAL@D
     C                   ENDIF
     C                   ENDIF
      *
      ** If any screen defaulting or reformatting has occurred in validation
      ** or if the number of warnings has changed, re-display the screen
      *
     C                   IF        NewTrScrn <> PrvTrScrn OR
     C                             WIdx <> PrvN_Warn
     C                   GOTO      EndVAL@D
     C                   ENDIF
      *
      ** Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrMPRI
 
      *
      ** If No Errors in Validation
 
     C     Idx           IFEQ      *ZERO
 
      ** Continue with Confirmation of Update
 
     C                   MOVEL     'C'           @SCRN
 
      ** Else, Return To Main Details Screen
 
     C                   ELSE
     C                   MOVEL     'D'           @SCRN
     C                   ENDIF
 
      *
     C     EndVAL@D      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - RETRIEVE Market Prices Transaction Details
      *****************************************************************
     C     RTVTRN        BEGSR
 
      ** Apply the multimember file overrides for the transaction, and
      ** get the current trading date.
 
     C                   IF        POTCFlag = 'Y'
     C                             OR wInstMissingF = 'Y'
     C                   EVAL      wMember = 'OT'
     C                   ELSE
     C                   EVAL      wMember = @MRKTSEL
     C                   ENDIF
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    wMember
 
 
      *
      ** Retrieve Transaction
      *
     C                   CALLB     'FFMPRIRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Inputs :
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE            6
      *
      ** Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction ID
     C                   PARM      @FOTRANSEL    PRFRNT           20
      *
      ** Market Prices Transaction Reference Key
     C                   PARM                    PRTRNN
      *
      ** A = First retrieve, K = second retrieve, P = third retrieve
 
     C                   PARM      'X'           PSCRN             1
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      *
      ** Outputs :
      ** (Current) Market Prices Transaction Details in file format
     C                   PARM                    CrTrFilFmt
      *
     C                   PARM                    OKTrMPRI
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      ** Warning
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
     C                   PARM                    WIdx
      ** Market Name
 
     C                   PARM                    PMKTN            20
 
      ** Business Date in 99MON99 format
 
     C                   PARM                    PBUSD             7
 
      ** Valid instrument types
 
     C                   PARM                    InstTypes
 
      ** Numeric strike price
     C                   PARM                    NDDSTRP
      *
 
      ** Remove the multimembered file overrides for this transaction
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
 
     C     EndRTVTRN     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTTRN - CONVERT Mrkt Prices Tran Details ( File --> Screen )
      *****************************************************************
     C     CVTTRN        BEGSR
      *
      ** Call program to fill screen fields with data
      *
     C                   CALLB     'FFMPRICVT'
      *
      ** Inputs :
      ** Return Code
      ** Transaction in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrTrFilFmt
      ** Outputs
      ** Transaction - screen formats
     C                   PARM                    NewTrScrn
     C                   PARM                    InstTypes                                    245144
 
      *
      ** Update 'Current' Transaction with Transaction in Screen Format
      *
     C                   MOVEL     NewTrScrn     CurTrScrn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@D - CANCEL ON DETAILS SCREEN
      *****************************************************************
     C     CANC@D        BEGSR
      *
      ** If Records are still to be read from the subfile, read them
      *
     C                   IF        @RDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
      *
      ** Else, return to the browse screen
      *
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS & AMENDS
      *****************************************************************
     C     SCRN@C        BEGSR
 
      ** Prior to validation, initialize error indicators as 'OK'
 
     C                   MOVE      *ALL'Y'       OKTrMPRI
 
      *
      ** Validate Market Prices Transaction details
      *
     C                   CALLB     'FFMPRIVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
 
      ** Response mode
     C                   PARM                    RespMode
 
      ** Transaction Primary Details
     C                   PARM                    NewTrScrn
 
      ** Extension File Data
     C                   PARM                    ExtData
 
      ** Strike price file format
     C                   PARM                    NDDSTRP
 
      ** Outputs:
 
      ** Transaction Primary Details OK inds
     C                   PARM                    OKTrMPRI
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Valid Transaction layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
 
      ** Instrument Types
     C                   PARM                    InstTypes
 
      *
      ** If transaction is valid output message 'Press enter to accept'
 
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'USR4450'     MsgIdArr(1)
     C                   ENDIF
      *
     C                   EVAL      PTransStat  = *BLANKS
 
      ** Write/Read Display Screen
      *
     C                   CALLB     'FFMPRIDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Input Parameters :
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Transaction (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewTrScrn
      *
     C                   PARM                    PTransStat
      *
      ** Fields in error
     C                   PARM                    OKTrMPRI
 
      ** Market Prices Transaction Reference Key
     C                   PARM                    PRTRNN
 
      ** OTC Flag
     C                   PARM                    POTCFlag
 
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled Key & Detail Fields
      *
     C                   PARM      'N'           @EDTFD            1
      *
      *
      ** Enabled Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KX = Command Key 23 = Further Details
     C                   PARM                    @EINKJ            1
      *
      ** Screen to display
     C                   PARM      'X'           PSCRN
      *
      ** Output Parameters :
      ** Function Keys
     C                   PARM      '0'           @INKC
      ** Should be 'N' (disabled)
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
      *
      ** Reset Errors ....
      *
     C                   MOVE      *ALL'Y'       OKTrMPRI
     C                   EVAL      FldNameArr =  *BLANK
     C                   EVAL      MsgIdArr   =  *BLANK
     C                   EVAL      MsgDtaArr  =  *BLANK
     C                   EVAL      WFldNamArr =  *BLANK
     C                   EVAL      WMsgIdArr  =  *BLANK
     C                   EVAL      WMsgDtaArr =  *BLANK
      *
      ** F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      ** F12 - Cancel on Screen
     C     @INKL         CASEQ     '1'           CANC@C
      *
      ** Exit Confirmation Screen
     C                   CAS                     EXIT@C
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
 
      ** Return to Details Screen
 
     C                   MOVEL     'D'           @SCRN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
 
      ** If No Errors in Validation
 
     C     Idx           IFEQ      *ZERO
 
      ** Continue with Updates
 
     C                   MOVEL     'U'           @SCRN
 
      ** Else, Return to Main Details Screen
 
     C                   ELSE
     C                   MOVEL     'D'           @SCRN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SETTLEMENT SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
 
      ** Return to Details Screen
 
     C                   MOVEL     'D'           @SCRN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@S - EXIT FROM SETTLEMENT SCREEN
      *****************************************************************
     C     EXIT@S        BEGSR
 
      ** If No Errors in Validation
 
     C     Idx           IFEQ      *ZERO
 
      ** Continue with Confirmation of Update
 
     C                   MOVEL     'C'           @SCRN
 
      ** Else, Return To Main Details Screen
 
     C                   ELSE
     C                   MOVEL     'D'           @SCRN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      ** Update valid market prices transaction data struct. with valid screen entries
      *
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C                   EVAL      DVRECI = 'D'
     C     DDACTN        WHENEQ    'D'
     C                   EVAL      DVRECI = 'R'
     C                   ENDSL
      ** Market Prices Transaction reference
     C                   EVAL      DVISTT = PRISTT
     C                   SELECT
     C                   WHEN      PRMTHN = 'JAN'
     C                   EVAL      DVMTHN = 01
     C                   WHEN      PRMTHN = 'FEB'
     C                   EVAL      DVMTHN=  02
     C                   WHEN      PRMTHN = 'MAR'
     C                   EVAL      DVMTHN=  03
     C                   WHEN      PRMTHN = 'APR'
     C                   EVAL      DVMTHN=  04
     C                   WHEN      PRMTHN = 'MAY'
     C                   EVAL      DVMTHN=  05
     C                   WHEN      PRMTHN = 'JUN'
     C                   EVAL      DVMTHN=  06
     C                   WHEN      PRMTHN = 'JUL'
     C                   EVAL      DVMTHN=  07
     C                   WHEN      PRMTHN = 'AUG'
     C                   EVAL      DVMTHN=  08
     C                   WHEN      PRMTHN = 'SEP'
     C                   EVAL      DVMTHN=  09
     C                   WHEN      PRMTHN = 'OCT'
     C                   EVAL      DVMTHN=  10
     C                   WHEN      PRMTHN = 'NOV'
     C                   EVAL      DVMTHN=  11
     C                   WHEN      PRMTHN = 'DEC'
     C                   EVAL      DVMTHN = 12
     C                   OTHER
     C                   EVAL      DVMTHN = 0
     C                   ENDSL
     C                   MOVE      PRYRNO        DVYRNO
     C                   EVAL      DVPCAL = PRPCAL
     C                   EVAL      DVSTRP = NDDSTRP
      *
      *
      ** Carry forward file data to valid file
     C                   Z-ADD     BJRDNB        DVLCD
     C                   EVAL      DVCHTP = C_CHTP
     C                   EVAL      DVTNLU = C_TNLU
      *
     C                   IF        DDACTN = 'A'
      *
      ** Carry forward number of trades value to valid file field
      *
     C                   EVAL      DVFRNT = C_FRNT
     C                   EVAL      DVAFRT = C_AFRT
     C                   EVAL      DVREPA = C_REPA
     C                   EVAL      DVTMST = C_TMST
     C                   EVAL      DVPLEC = C_PLEC
     C                   EVAL      DVPBEC = C_PBEC
     C                   EVAL      DVPRSM = C_PRSM
      *
     C                   ELSE
      *
     C                   IF        DDACTN = 'I'
      *
      ** Initialise number of trades field for Insert
      *
     C                   EVAL      DVPLEC = *ZEROS
     C                   EVAL      DVPBEC = *ZEROS
     C                   EVAL      DVPRSM = *ZEROS
      *
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      @RTCD = *BLANK
 
     C                   IF        POTCFlag = 'Y'
     C                   EVAL      wMember = 'OT'
     C                   ELSE
     C                   EVAL      wMember = DVISTT
     C                   ENDIF
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    wMember
 
      *
      ** Market Prices Transaction details updates
      *
     C                   CALLB     'FFMPRIUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwTrFilFmt
     C                   PARM                    POTCFlag
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
      *
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.
      ** Otherwise delete the invalid trancsaction actioned & commit the updates.
      *
     C                   IF        @RTCD <> *BLANK AND
     C                             @RTCD <> '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C     ZATRNKD0      CHAIN     FFIMPRID0                          99
     C  N99              DELETE    FFIMPRID0
 
      ** Also delete corresponding record in API standard log file
      ** if CSC011 is present and user is still in support system.
 
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)
     C                   EVAL      WMTYP = 'FFMPRI'
     C     KAPILOG       CHAIN     APILOGL0                           71
 
      ** If record found
     C                   IF        *IN71 = '0'
     C                   DELETE    APILOGD0
     C                   ENDIF
     C                   ENDIF
 
     C                   COMMIT
     C                   ENDIF
      *
      ** If error occurred in updating last transaction set on flag to
      ** display message on 'browse' screen.
     C                   IF        @RTCD = '*RECUPD'
     C                   EVAL      @ERRUP = 'Y'
     C                   ELSE
     C                   EVAL      @ERRUP = 'N'
     C                   ENDIF
     C
      ** If records are still to be read from the subfile, read them
      *
     C                   IF        @RDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
      *
      ** Else, return to the browse screen
      *
     C                   EVAL      @SCRN = 'B'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKEYS - SET FUNCTION KEY STATUS ON SCREEN
      *****************************************************************
     C     SFKEYS        BEGSR
      *
      ** Enable/disable function keys
      *
      ** KG = COMMAND KEY 07 = READ PREVIOUS TRANSACTION
      ** KH = COMMAND KEY 08 = READ NEXT TRANSACTION
      *
     C                   EVAL      @INKG = '0'
     C                   EVAL      @INKH = '0'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   EVAL      @SCRN = 'T'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   IF        RepMPRI = 'Y'
 
     C                   RESET                   ReturnCode
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
     C                   PARM                    ReturnCode       10
      ** Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      ** Incoming Data
     C                   PARM      NewTrScrn     IncDATA        2000
      ** Current Data
     C                   PARM      CurTrScrn     CurDATA        2000
 
     C                   MOVEL     IncDATA       NewTrScrn
 
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      ** Go to primary screen
     C                   EVAL      @SCRN = 'D'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'FFMPRIRPR'
      *
      ** Access bank details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAP050
      ** (Midas/ToF Interface) is on.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP050'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '909'         DBASE
     C                   MOVEL     'CAP050'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           CAP050            1
     C                   ELSE
     C                   MOVEL     'N'           CAP050
     C                   ENDIF
      *
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      ** if insert
      ** if not insert and Midas transaction ID is not present
      ** Otherwise
      ** Set retrieve mode to blank  (Access using Midas transaction ID).
     C                   IF        DDACTN = 'I'
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   IF        PRTRNN = *BLANK
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      @@MODE = '      '
     C                   ENDIF
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Key Lists
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
 
      ** Get the field number for the action code field; the primary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    FormatA
     C                   PARM                    FieldA
     C                   PARM      *ZERO         FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetA = FieldNo - 3
     C                   ENDIF
      ** Determine if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   OPEN      APILOGL0
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
 
      ** Key List for access to API standard log file
     C     KAPILOG       KLIST
     C                   KFLD                    WMTYP
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
 
      *
      ** Start on Browse Screen
     C                   MOVEL     'B'           @SCRN             1
      *
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFMPRIR014
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrOTCCheck - Check if instrument is OTC
      *****************************************************************
     C     SrOTCCheck    BEGSR
 
      ** Obtain five character instrument
     C                   EVAL      wMarketIns = @MRKTSEL + @ISTCSEL
 
      ** Chain to INTYP
     C     wMarketIns    CHAIN     INTYP
 
     C                   EVAL      POTCFlag = 'N'
     C                   EVAL      wInstMissingF = 'N'
     C                   IF        %FOUND(INTYP)
     C                   IF        ISTI = 'Y'
      ** If Found and Instrument Indicator is 'Y', assume that it is
      ** an OTC instrument.
     C                   EVAL      POTCFlag = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      wInstMissingF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
