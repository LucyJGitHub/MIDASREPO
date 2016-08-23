     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('MIDAS Common Routines - Date and Time Converter')
      *****************************************************************
      *                                                               *
      *  Midas - MIDAS Common Routines                                *
      *                                                               *
      *  ZADTMCVT - Date and Time Converter                           *
      *                                                               *
      *  Function:  This function will convert a date and time zone   *
      *             to the 3 time zones (Market, Local and System)    *
      *             taking account the System, Branch and Market      *
      *             offsets                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG20932           Date 28Aug08               *
      *  Prev Amend No. BUG20102           Date 15Aug08               *
      *                 BUG19628           Date 29Jul08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG20932 - Wrong date reflected in 98E based on the time     *
      *             conversion                                        *
      *  BUG20102 - Value in field 98 of the generated MT518 and      *
      *             MT541 is different. It should be the same.        *
      *  BUG19628  - DST is being switched on even if start time is   *
      *              not yet reached                                  *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *Pssr    - Error Processing                                  *
      *  *INZSR   - Program Initialisation Routine                    *
      *  SRVerifyInput - Verify input parameters from calling program *
      *  SRGetSysLoc - Get System and Local Time Offset and Sign      *
      *  SRGetMarket - Get Market Time Offset and Sign                *
      *  SRGetOffset - Retrieve offset and sign                       *
      *  SRConvert   - Convert from one time zone to another          *
      *                                                               *
      *    The *INZSR subroutine will only get Called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Midas SE Securities
      *
     FSECTY     IF   E           K DISK    INFSR(*Pssr)
 
      ** Midas SE Market Centres
      *
     FSEMKC     IF   E           K DISK    INFSR(*Pssr)
 
      ** Midas FF Market Centres (Detail)
      *
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D WPositive       C                   CONST('+')
     D WNegative       C                   CONST('-')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for SDMICCPD
     D SDMICC        E DS                  EXTNAME(SDMICCPD)
 
      ** External DS for SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SCSARDPD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** First DS for Access Programs, Short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** ENTRY Parameters from calling program
     D   PRtCd         S              7A
     D   PFrTZ         S              1A
     D   PFrTM         S              6S 0
     D   PFrDT         S              5P 0
     D   PModu         S              2A
     D   PBrca         S              3A
     D   PMrkt         S              2A
     D   PSesn         S             10A
     D   PMicc         S              4A
     D   PMktm         S              6S 0
     D   PMkdt         S              5P 0
     D   PMktOf        S              4S 0
     D   PMktOs        S              1A
     D   PLcTm         S              6S 0
     D   PLcDt         S              5P 0
     D   PLctOf        S              4S 0
     D   PLctOs        S              1A
     D   PSyTm         S              6S 0
     D   PSyDt         S              5P 0
     D   PSytOf        S              4S 0
     D   PSytOs        S              1A
 
      *
      ** Work variables
     D   WMicc         S                   LIKE(MICCOD) INZ(*Blanks)
     D   WMktCnvFlg    S              1A   INZ('Y')
     D   WMarketCtr    S                   LIKE(MRKT) INZ(*Blanks)
     D   WTizoCode     S                   LIKE(MITZCD) INZ(*Blanks)
     D   WRun          S              1A   INZ(*Blanks)
     D   WDate1        S              6A   INZ(*Blanks)
     D   WSign1        S                   LIKE(PSign) INZ(*Blanks)
     D   WSign2        S                   LIKE(PSign) INZ(*Blanks)
     D   WTzLc         S              1A   INZ(*Blanks)
     D   WZone         S             10A   INZ(*Blanks)
     D   WBrCa         S                   LIKE(PBrCa) INZ(*Blanks)
     D   WEffOffset    S                   LIKE(PEffOffset)
     D   WSign         S                   LIKE(PSign)
     D   WInDate       S                   LIKE(PFrDt)
     D   PTime         S              6S 0 INZ(*ZEROS)                                     BUG19628
 
     D   WPrvTime      S               T   TIMFMT(*HMS)
     D   WCurTime      S               T   TIMFMT(*HMS)
     D   WCurDate      S               D   DATFMT(*YMD)
     D   WTimeStr      S              6A   INZ(*Blanks)
     D   WDateStr      S              6A   INZ(*Blanks)
 
     D   WOffSet1      DS
     D     S1HH                1      2S 0
     D     S1MM                3      4S 0
     D   WOffSet2      DS
     D     S2HH                1      2S 0
     D     S2MM                3      4S 0
 
     D   WDSTim1       DS
     D     W1HH                1      2S 0
     D     W1MM                3      4S 0
     D     W1SS                5      6S 0
      *
      ** CSD082 variable for checking of MiFID Feature
     D   CSD082        S              1A   INZ('N')
      *
 
      ** Parameter list for ZDATE2
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
 
      ** Parameters for ZDATE1
     D PZDate          S              6P 0 INZ(*Zeros)
     D PZDayNo         S              5P 0 INZ(*Zeros)
 
      ** Parameters for access programs
     D PTzLc           S              1A
     D PZone           S             10A
     D PBrCd           S                   LIKE(PBrCa)
     D PMiCd           S                   LIKE(MICCOD)
     D PTzCd           S                   LIKE(MITZCD)
     D PInDate         S                   LIKE(PFrDt)
     D PEffOffset      S                   LIKE(PSytof)
     D PSign           S              1A
 
     D PTimeStamp      S             26Z                                                    BUG20932
                                                                                            BUG20932
     D TimeStmpDS      DS                                                                   BUG20932
     D  RetYear                1      4A                                                    BUG20932
     D                         5      5A   INZ('-')                                         BUG20932
     D  RetMonth               6      7A                                                    BUG20932
     D                         8      8A   INZ('-')                                         BUG20932
     D  RetDay                 9     10A                                                    BUG20932
     D                        11     11A   INZ('-')                                         BUG20932
     D  RetHour               12     13A                                                    BUG20932
     D                        14     14A   INZ('.')                                         BUG20932
     D  RetMin                15     16A                                                    BUG20932
     D                        17     17A   INZ('.')                                         BUG20932
     D  RetSec                18     19A                                                    BUG20932
     D                        20     20A   INZ('.')                                         BUG20932
     D  RetMilli              21     23A                                                    BUG20932
     D  RetMicro              24     26A   INZ('000')                                       BUG20932
                                                                                            BUG20932
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Execute subroutine to verify input parameters from calling program
      *
     C                   EXSR      SrVerifyInput
      *
      ** Execute subroutine to get system and local time offset and sign
      *
     C                   EXSR      SrGetSysLoc
      *
      ** Execute subroutine to get Market time offset and sign
      *
     C                   EVAL      PTime = 0                                               BUG19628
     C                   EVAL      WInDate = PFrDt                                         BUG19628
     C                   EXSR      SrGetMarket
      *
      ** Return to calling program if no basis for market conversion
      *
     C                   IF        WMktCnvFlg <> 'Y'
     C                   EXSR      srReturn
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      PFrTz = 'M'
     C                   EVAL      PMkTm = PFrTm
     C                   EVAL      PMkDt = PFrDt
      *
      ** Convert Market Date and Time to Branch/Local Date and Time
      *
     C                   MOVE      PMktOf        WOffset1
     C                   EVAL      WSign1   = PMktOs
     C                   MOVE      PLctOf        WOffset2
     C                   EVAL      WSign2   = PLctOs
 
     C                   EXSR      SrConvert
 
     C                   MOVE      WTimeStr      PLcTm
     C                   EVAL      PlcDt = PZDayNo
      *
      ** Convert Market Date and Time to System Date and Time
      *
     C                   MOVE      PSytOf        WOffset2
     C                   EVAL      WSign2   = PSytOs
 
     C                   EXSR      SrConvert
 
     C                   MOVE      WTimeStr      PSyTm
     C                   EVAL      PSyDt = PZDayNo
 
     C                   WHEN      PFrTz = 'L'
     C                   EVAL      PLcTm = PFrTm
     C                   EVAL      PLcDt = PFrDt
      *
      ** Convert Local Date and Time to Market Date and Time
      *
     C                   MOVE      PLctOf        WOffset1
     C                   EVAL      WSign1   = PLctOs
     C                   MOVE      PMktOf        WOffset2
     C                   EVAL      WSign2   = PMktOs
 
     C                   EXSR      SrConvert
 
     C                   MOVE      WTimeStr      PMkTm
     C                   EVAL      PMkDt = PZDayNo
                                                                                           BUG19628
     C                   EVAL      PTime = PMkTm                                           BUG19628
     C                   EVAL      WInDate = PMkDt                                         BUG19628
     C                   EXSR      SrGetMarket                                             BUG19628
                                                                                           BUG19628
     C                   MOVE      PSytOf        WOffset1                                  BUG19628
     C                   EVAL      WSign1   = PSytOs                                       BUG19628
     C                   MOVE      PMktOf        WOffset2                                  BUG19628
     C                   EVAL      WSign2   = PMktOs                                       BUG19628
                                                                                           BUG19628
     C                   EXSR      SrConvert                                               BUG19628
                                                                                           BUG19628
     C                   MOVE      WTimeStr      PMkTm                                     BUG19628
     C                   EVAL      PMkDt = PZDayNo                                         BUG19628
                                                                                           BUG19628
      *
      ** Convert Local Date and Time to System Date and Time
      *
     C                   MOVE      PSytOf        WOffset2
     C                   EVAL      WSign2   = PSytOs
     C                   EXSR      SrConvert
 
     C                   MOVE      WTimeStr      PSyTm
     C                   EVAL      PSyDt = PZDayNo
 
     C                   WHEN      PFrTz = 'S'
     C                   EVAL      PSyTm = PFrTm
     C                   EVAL      PSyDt = PFrDt
      *
      ** Convert System Date and Time to Market Date and Time
      *
     C                   MOVE      PSytOf        WOffset1
     C                   EVAL      WSign1   = PSytOs
     C                   MOVE      PMktOf        WOffset2
     C                   EVAL      WSign2   = PMktOs
 
     C                   EXSR      SrConvert
 
     C                   MOVE      WTimeStr      PMkTm
     C                   EVAL      PMkDt = PZDayNo
      *                                                                                     BUG20102
     C                   EVAL      PTime = PMkTm                                            BUG20102
     C                   EVAL      WInDate = PMkDt                                          BUG20102
     C                   EXSR      SrGetMarket                                              BUG20102
      *                                                                                     BUG20102
     C                   MOVE      PSytOf        WOffset1                                   BUG20102
     C                   EVAL      WSign1   = PSytOs                                        BUG20102
     C                   MOVE      PMktOf        WOffset2                                   BUG20102
     C                   EVAL      WSign2   = PMktOs                                        BUG20102
      *                                                                                     BUG20102
     C                   EXSR      SrConvert                                                BUG20102
      *                                                                                     BUG20102
     C                   MOVE      WTimeStr      PMkTm                                      BUG20102
     C                   EVAL      PMkDt = PZDayNo                                          BUG20102
      *
      ** Convert System Date and Time to Local Date and Time
      *
     C                   MOVE      PLctOf        WOffset2
     C                   EVAL      WSign2   = PLctOs
 
     C                   EXSR      SrConvert
 
     C                   MOVE      WTimeStr      PLcTm
     C                   EVAL      PLcDt = PZDayNo
 
     C                   ENDSL
 
     C                   EVAL      *InLR = *On
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial processing                                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *Pssr                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Input Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtCd
     C                   PARM                    PFrTz
     C                   PARM                    PFrTM
     C                   PARM                    PFrDT
     C                   PARM                    PModu
     C                   PARM                    PBrca
     C                   PARM                    PMrkt
     C                   PARM                    PSesn
     C                   PARM                    PMicc
      *
      ** Output Parameters
      *
     C                   PARM                    PMktm
     C                   PARM                    PMkdt
     C                   PARM                    PMktOf
     C                   PARM                    PMktOs
     C                   PARM                    PLcTm
     C                   PARM                    PLcDt
     C                   PARM                    PLctOf
     C                   PARM                    PLctOs
     C                   PARM                    PSyTm
     C                   PARM                    PSyDt
     C                   PARM                    PSytOf
     C                   PARM                    PSytOs
      *
      ** Initialize output parameters
      *
     C                   EVAL      PMktm    =   *Zeros
     C                   EVAL      PMkdt    =   *Zeros
     C                   EVAL      PMktOf   =   *Zeros
     C                   EVAL      PMktOs   =   *Blanks
     C                   EVAL      PLcTm    =   *Zeros
     C                   EVAL      PLcDt    =   *Zeros
     C                   EVAL      PLctOf   =   *Zeros
     C                   EVAL      PLctOs   =   *Blanks
     C                   EVAL      PSyTm    =   *Zeros
     C                   EVAL      PSyDt    =   *Zeros
     C                   EVAL      PSytOf   =   *Zeros
     C                   EVAL      PSytOs   =   *Blanks
     C                   EVAL      PRtCd    =   *Blanks
      *
      ** Call AOSARDR0 to check If CSD082 is switched on
      *
     C                   EVAL      CSD082 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSD082'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RtCd <> *Blanks
     C                             and @RtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SCSARDPD'
     C                   EVAL      Dbkey  = 'CSD082'
     C                   EVAL      DBPGM  = 'ZADTMCVT'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *Pssr
 
     C                   ELSEIF    @RtCd = *Blanks
     C                   EVAL      CSD082 = 'Y'
 
     C                   ENDIF
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbkey  = @Optn
     C                   EVAL      DBPGM  = 'ZADTMCVT'
     C                   EVAL      DBase  = 2
     C                   OUT       LDA
     C                   EXSR      *Pssr
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrVerifyInput - Subroutine to verify input parameters from   *
      *                  calling program                              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrVerifyInput BEGSR
 
     C                   SELECT
     C                   WHEN      PFrTz = *Blanks
     C                             or (PFrTz <> 'M' and PFrTz <> 'L'
     C                             and PFrTz <> 'S')
     C                             or (PFrTm = *Zeros and PFrDt = *Zeros)
     C                             or PBrCa = *Blanks
     C                             or PFrDt = *Zeros
     C                             or PFrTm > 240000
     C                   EXSR      srReturn
 
     C                   WHEN      PFrTm = *Zeros
     C                   EVAL      PMkDt = PFrDt
     C                   EVAL      PLcDt = PFrDt
     C                   EVAL      PSyDt = PFrDt
     C                   EVAL      PRtCd = '*NOTIME'
     C                   EVAL      *InLR = *On
     C                   RETURN
 
     C                   WHEN      PFrTm <> *Zeros
     C                   MOVE      PFrTm         WDSTim1
     C                   IF        W1HH > 24
     C                             or W1MM >= 60
     C                             or W1SS >= 60
     C                   EXSR      srReturn
     C                   ENDIF
 
     C                   OTHER
     C                   ENDSL
 
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrGetSysLoc - Subroutine to get system and local time offset *
      *                and sign                                       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrGetSysLoc   BEGSR
      *
      ** Retrieve system time offset and sign
      *
     C                   EVAL      WTzLc = 'S'
     C                   EVAL      WTizoCode = *Blanks
     C                   EVAL      WMicc = *Blanks
     C                   EVAL      WBrCa = *Blanks
     C                   EVAL      WZone = *Blanks
     C                   EVAL      WInDate = PFrDt
     C                   EVAL      WCurTime = %TIME()                                      BUG19628
     C                   EVAL      WTimeStr = %CHAR(WCurTime:*HMS0)                        BUG19628
     C                   MOVE      WTimeStr      PTime                                     BUG19628
     C                   EXSR      srGetOffset
     C                   EVAL      WCurTime = %TIME()                                       BUG20102
     C                   EVAL      WTimeStr = %CHAR(WCurTime:*HMS0)                         BUG20102
     C                   MOVE      WTimeStr      PTime                                      BUG20102
      *
      ** Set the system time offset and sign
      *
     C                   EVAL      PSytOf  = WEffOffset
     C                   EVAL      PSytOs  = WSign
 
     C                   IF        PSytOs = *Blanks
     C                   IF        PSytOF >= *Zeros
     C                   EVAL      PSytOs  = WPositive
     C                   ELSE
     C                   EVAL      PSytOs  = WNegative
     C                   ENDIF
     C                   ENDIF
      *
      ** Retrieve local time offset and sign
      *
     C                   EVAL      WTzLc = 'B'
     C                   EVAL      WTizoCode = *Blanks
     C                   EVAL      WMicc = *Blanks
     C                   EVAL      WBrCa = PBrCa
     C                   EVAL      WZone = *Blanks
     C                   EVAL      WInDate = PFrDt
     C                   EVAL      WCurTime = %TIME()                                      BUG19628
     C                   EVAL      WTimeStr = %CHAR(WCurTime:*HMS0)                        BUG19628
     C                   MOVE      WTimeStr      PTime                                     BUG19628
     C                   EXSR      srGetOffset
      *
      ** Set the local time offset and sign
      *
     C                   EVAL      PLctOf  = WEffOffset
     C                   EVAL      PLctOs  = WSign
 
     C                   IF        PLctOs = *Blanks
     C                   IF        PLctOF >= *Zeros
     C                   EVAL      PLctOs  = WPositive
     C                   ELSE
     C                   EVAL      PLctOs  = WNegative
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SrGetMarket - Subroutine to get market time offset and sign  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrGetMarket   BEGSR
 
     C                   IF        PMicc <> *Blanks
     C                   EVAL      WMicc = PMicc
 
     C                   ELSE
      *
      ** MIC Code is unknown, determine the MIC Code based on other parameters
      *
     C                   EVAL      WMarketCtr = PMrkt
 
     C                   SELECT
      *
      ** Determine MIC Code for Securities Trading Market
      *
     C                   WHEN      PModu = 'SE'
      *
      ** If Market center passed is blanks then determine the market center
      *
     C                   IF        WMarketCtr = *Blanks
 
     C                   IF        PSesn = *Blanks
     C                   EVAL      WMktCnvFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Access SECTY to get the Market Centre
      *
     C     PSesn         Chain     SECTY                              50
 
     C                   IF        (*In50 = *Off)
     C                   EVAL      WMarketCtr  = SMCC
     C                   ELSE
     C                   EVAL      WMktCnvFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Access SEMKC to get MIC Code
      *
     C     WMarketCtr    Chain     SEMKC                              50
     C                   IF        (*In50 = *Off)
     C                   EVAL      WMicc = SWMKTC
     C                   ELSE
     C                   EVAL      WMktCnvFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Determine MIC Code for Futures and Options Market
      *
     C                   WHEN      (PModu = 'FO')
 
     C                   IF        (CSD082 = 'N')
     C                   EVAL      WMktCnvFlg = 'N'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Market conversion not required for other modules
      *
     C                   OTHER
     C                   EVAL      WMktCnvFlg = 'N'
     C                   LEAVESR
 
     C                   ENDSL
 
     C                   ENDIF
      *
      ** Determine the time zone code based on the MIC Code
      *
     C                   CALL      'AOMICCR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WMicc         PMiCd
     C     SDMICC        PARM      SDMICC        DSSDY
     C                   IF        @RtCd  <> *Blanks
     C                             and @RtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDMICCPD'
     C                   EVAL      DBPGM  = 'ZADTMCVT'
     C                   EVAL      DBase = 3
     C                   EVAL      Dbkey =  WMicc
     C                   OUT       LDA
     C                   EXSR      *Pssr
     C                   ELSEIF    @RtCd = '*NRF    '
     C                   EVAL      WMktCnvFlg = 'N'
     C                   LEAVESR
     C                   ELSEIF    @RtCd = *Blanks
     C                   EVAL      WTizoCode = MITZCD
     C                   ENDIF
      *
      ** Retrieve market time offset and sign
      *
     C                   EVAL      WTzLc = 'M'
     C                   EVAL      WBrCa = *Blanks
     C                   EVAL      WZone = *Blanks
     C**********         EVAL      WInDate = PFrDt                                         BUG19628
     C                   EXSR      srGetOffset
      *
      ** Set the market time offset and sign
      *
     C                   EVAL      PMktOf  = WEffOffset
     C                   EVAL      PMktOs  = WSign
 
     C                   IF        PMktOs = *Blanks
     C                   IF        PMktOF >= *Zeros
     C                   EVAL      PMktOs  = WPositive
     C                   ELSE
     C                   EVAL      PMktOs  = WNegative
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SrGetOffset - Subroutine to retrieve offset and time         *
      *                                                               *
      *  Called by: SrGetSysLoc, SrGetMarket                          *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrGetOffset   BEGSR
 
     C                   EVAL      WEffOffset = *Zeros
     C                   EVAL      WSign = *Blanks
 
     C                   CALL      'SD001008'
     C                   PARM      WTzLc         PTzLc
     C                   PARM      WTizocode     PTzCd
     C                   PARM      WMicc         PMiCd
     C                   PARM      WBrCa         PBrCd
     C                   PARM      WZone         PZone
     C                   PARM      WInDate       PInDate
     C                   PARM      *Zeros        PEffOffset
     C                   PARM      *Blanks       PSign
     C                   PARM                    PTime                                     BUG19628
 
     C                   EVAL      WEffOffset = PEffOffset
     C                   EVAL      WSign = PSign
 
     C                   ENDSR
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SrReturn - Subroutine to return error code                   *
      *                                                               *
      *  Called by: Main, SrVerifyInput                               *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrReturn      BEGSR
 
      *
      ** Initialize output parameters
      *
     C                   EVAL      PMktm    =   *Zeros
     C                   EVAL      PMkdt    =   *Zeros
     C                   EVAL      PMktOf   =   *Zeros
     C                   EVAL      PMktOs   =   *Blanks
     C                   EVAL      PLcTm    =   *Zeros
     C                   EVAL      PLcDt    =   *Zeros
     C                   EVAL      PLctOf   =   *Zeros
     C                   EVAL      PLctOs   =   *Blanks
     C                   EVAL      PSyTm    =   *Zeros
     C                   EVAL      PSyDt    =   *Zeros
     C                   EVAL      PSytOf   =   *Zeros
     C                   EVAL      PSytOs   =   *Blanks
     C                   EVAL      PRtCd    =   '*ERROR'
 
     C                   SELECT
     C                   WHEN      PFrTz = 'S'
     C                   EVAL      PSyTm    =   PFrTM
     C                   EVAL      PSyDt    =   PFrDT
     C                   WHEN      PFrTz = 'L'
     C                   EVAL      PLcTm    =   PFrTM
     C                   EVAL      PLcDt    =   PFrDT
     C                   WHEN      PFrTz = 'M'
     C                   EVAL      PMktm    =   PFrTM
     C                   EVAL      PMkdt    =   PFrDT
     C                   OTHER
     C                   ENDSL
 
     C                   EVAL      *InLR = *On
     C                   RETURN
 
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrConvert - Converts date and time to local date and time    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrConvert     BEGSR
 
     C                   IF        PFrTm = 240000
     C                   MOVEL     '000000'      WTimeStr
     C                   ELSE
     C                   MOVEL     PFrTM         WTimeStr
     C                   ENDIF
     C                   EVAL      WCurTime  = %TIME(WTimeStr:*HMS0)
     C                   EVAL      WPrvTime  = WCurTime
 
     C                   EVAL      PDateIn = PFrDt
     C                   CALL      'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *Zeros        PDateOut
     C                   PARM      *Blanks       PADateOut
 
     C                   MOVEL     PDateOut      WDate1
     C                   IF        (BJDFIN  = 'D')
     C                   EVAL      WCurDate = %DATE(WDate1:*DMY0)
     C                   ELSE
     C                   EVAL      WCurDate = %DATE(WDate1:*MDY0)
     C                   ENDIF
     C                   EVAL      PTimeStamp = WCurDate + WCurTime                         BUG20932
 
     C                   IF        (WSign1 = WPositive)
     C                   SUBDUR    S1HH:*Hours   WCurTime
     C                   SUBDUR    S1MM:*Minutes WCurTime
 
     C                   SUBDUR    S1HH:*Hours   PTimeStamp                                 BUG20932
     C                   SUBDUR    S1MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WCurTime >= %TIME('12:00:00':*Hms) And                   BUG20932
     C**********                   WCurTime <= %TIME('23:59:59':*Hms) And                   BUG20932
     C**********                   WPrvTime >= %TIME('00:00:00':*Hms) And                   BUG20932
     C**********                   WPrvTime <= %TIME('11:59:59':*Hms)                       BUG20932
     C**********         SUBDUR    1:*Days       WCurDate                                   BUG20932
     C**********         ENDIF                                                              BUG20932
 
     C                   ELSEIF    (WSign1 = WNegative)
     C                   ADDDUR    S1HH:*Hours   WCurTime
     C                   ADDDUR    S1MM:*Minutes WCurTime
 
     C                   ADDDUR    S1HH:*Hours   PTimeStamp                                 BUG20932
     C                   ADDDUR    S1MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WCurTime >= %TIME('00:00:00':*Hms) And                   BUG20932
     C**********                   WCurTime <= %TIME('11:59:59':*Hms) And                   BUG20932
     C**********                   WPrvTime >= %TIME('12:00:00':*Hms) And                   BUG20932
     C**********                   WPrvTime <= %TIME('23:59:59':*Hms)                       BUG20932
     C**********         ADDDUR    1:*Days       WCurDate                                   BUG20932
     C**********         ENDIF                                                              BUG20932
 
     C                   ENDIF
 
     C                   EVAL      WPrvTime  = WCurTime
 
     C                   IF        (WSign2 = WPositive)
     C                   ADDDUR    S2HH:*Hours   WCurTime
     C                   ADDDUR    S2MM:*Minutes WCurTime
 
     C                   ADDDUR    S2HH:*Hours   PTimeStamp                                 BUG20932
     C                   ADDDUR    S2MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WCurTime >= %TIME('00:00:00':*Hms) And                   BUG20932
     C**********                   WCurTime <= %TIME('11:59:59':*Hms) And                   BUG20932
     C**********                   WPrvTime >= %TIME('12:00:00':*Hms) And                   BUG20932
     C**********                   WPrvTime <= %TIME('23:59:59':*Hms)                       BUG20932
     C**********         ADDDUR    1:*DAYS       WCurDate                                   BUG20932
     C**********         ENDIF                                                              BUG20932
 
     C                   ELSEIF    (WSign2 = WNegative)
     C                   SUBDUR    S2HH:*Hours   WCurtime
     C                   SUBDUR    S2MM:*Minutes WCurTime
 
     C                   SUBDUR    S2HH:*Hours   PTimeStamp                                 BUG20932
     C                   SUBDUR    S2MM:*Minutes PTimeStamp                                 BUG20932
                                                                                            BUG20932
     C**********         IF        WCurTime >= %TIME('12:00:00':*Hms) And                   BUG20932
     C**********                   WCurTime <= %TIME('23:59:59':*Hms) And                   BUG20932
     C**********                   WPrvTime >= %TIME('00:00:00':*Hms) And                   BUG20932
     C**********                   WPrvTime <= %TIME('11:59:59':*Hms)                       BUG20932
     C**********         SUBDUR    1:*Days       WCurDate                                   BUG20932
     C**********         ENDIF                                                              BUG20932
 
     C                   ENDIF
     C                   MOVEL     PTimeStamp    TimeStmpDS                                 BUG20932
     C                   MOVEL     RETDAY        #WDAYM            4                        BUG20932
     C                   MOVE      RETMONTH      #WDAYM                                     BUG20932
     C                   MOVE      RETYEAR       #WYEAR            2                        BUG20932
     C                   MOVEL     #WDAYM        WDate1                                     BUG20932
     C                   MOVE      #WYEAR        WDate1                                     BUG20932
     C                                                                                      BUG20932
     C                   IF        (BJDFIN  = 'D')                                          BUG20932
     C                   EVAL      WCurDate = %DATE(WDate1:*DMY0)                           BUG20932
     C                   ELSE                                                               BUG20932
     C                   EVAL      WCurDate = %DATE(WDate1:*MDY0)                           BUG20932
     C                   ENDIF                                                              BUG20932
 
     C                   IF        BJDFIN  = 'D'
     C                   EVAL      WDateStr   = %CHAR(WCurDate:*DMY0)
     C                   ELSE
     C                   EVAL      WDateStr   = %CHAR(WCurDate:*MDY0)
     C                   ENDIF
     C                   EVAL      WTimeStr = %CHAR(WCurTime:*HMS0)
      *
      ** Convert back date into Midas Day Number
      *
     C                   EVAL      PZDate = %DEC(WDateStr:6:0)
     C                   CALL      'ZDATE1'
     C                   PARM      *Blanks       PRtCd
     C                   PARM                    PZDate
     C                   PARM                    BJDFIN
     C                   PARM                    PZDayNo
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Pssr  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using exsr.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *Pssr         BEGSR
 
     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      PrtCd = '*ERROR'
     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2007
