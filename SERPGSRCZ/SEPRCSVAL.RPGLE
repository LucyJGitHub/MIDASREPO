     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Market prices validation')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module.                                   *
      *                                                               *
      *  SEPRCSVAL - Market Price record Validation                   *
      *                                                               *
      *  Function: This Program Validates SE Input Prices into the    *
      *            Midas database.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR1092524          Date 12Mar13               *
      *  Prev Amend No. AR670962           Date 27Nov12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10423           Date 07Feb06               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189506             Date 02Feb01               *
      *                 CSD006             Date 25Oct00               *
      *                 CAP060             Date 02May01               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CAP030  *CREATE    Date 02Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1092524 - Data inserted in Branch, Market & Book were not  *
      *           displayed in the Main list view of Securities       *
      *           Prices.                                             *
      *  AR670962 - Security price amount 0 is validated. Fix is to   *
      *             allow insertion of 0 security prices.             *
      *             (Child: AR670963)                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10423 - Remove dependency of CGL031 on CAP060.            *
      *  CGL031 - Taxation on Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  189506 - Securities Prices API could not update extel fields *
      *  CSD006 - Market Data Feed                                    *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *  CAP030 - API for SE Price input                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      * Incoming Price record
     D TranIn        E DS                  EXTNAME(SEPRCSPD)
 
      * Valid Prices record layout
     D ValidPRCS     E DS                  EXTNAME(SEVPRCSPD)
     D ValidPRXT     E DS                  EXTNAME(SEVPRXTPD)
     D ValidEXTL     E DS                  EXTNAME(SEVEXVLPD)                                 CAP060
 
      * Prices Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SEPREXPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** EXTERNAL DS FOR SECURITIES TRADING DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                  CAP060
      *  PORTFOLIO MANAGEMENT ICD                                                             CAP060
      **                                                                                      CAP060
     D SDMOD         E DS                  EXTNAME(SDMMODPD)                                  CAP060
      *   EXTERNAL DS FOR WHICH MODULES INSTALLED                                             CAP060
                                                                                              CAP060
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP060
      ** EXTERNAL DS FOR SAR DETAILS                                                          CAP060
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CAP060
     D** Customer Details                                                                     CAP060
      *                                                                                       CSD006
     D SDMDFC        E DS                  EXTNAME(SDMDFCPD)                                  CSD006
      ** External DS for Market Data Feeds ICD                                                CAP060
                                                                                              CAP060
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(SEEPRCSPD)
 
      ** Rundat
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      ** Midas day number
     D ZDAYNO          S              5P 0
     D ZDYNBR          S                   LIKE(ZDAYNO)
 
      ** Holiday flag
     D ZIND            S              1A
 
      ** Error flag passed back from ZDATE1
     D ErrorFlag       S              1A
 
      ** Time stamp field in file format, defaulted if necessary                              CAP060
     D JDFTS           S             14  0                                                    CAP060
                                                                                              CGL031
      ** Switchable features                                                                  CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
                                                                                              CSC011
      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(AGRDNB)                                       CSC011
                                                                                              CSC011
     D CSD010          S              1A                                                      CSD010
     D HBDPR           S                   LIKE(PRBDPR)                                       CSD010
     D HOFPR           S                   LIKE(PROFPR)                                       CSD010
     D HCLPR           S                   LIKE(PRCLPR)                                       CSD010
                                                                                              CSD010
      ** Hedge Accounting Phase B Switchable Feature                                          CAS006
     D CAS006          S              1A                                                      CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B Net Treasury Price                                          CAS006
     D WNTPrice        S             16P 8                                                    CAS006
                                                                                              CAS006
      ** Name of the field that will be validated in SEVPCSPDRT                               CAS006
     D PfldName        S             10A                                                      CAS006
                                                                                              CAS006
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SEPRCSV001
 
      * Initial processing to be executed on each call.
 
     C                   EXSR      INIT
 
      * Do Validation
 
     C                   IF        CAP060F= 'N'                                               CAP060
     C                   EXSR      VPRDPRICE
                                                                                            BUG10423
      ** Validate Price Excluding Interest                                                  BUG10423
                                                                                            BUG10423
     C                   IF        CGL031 = 'Y'                                             BUG10423
     C                   EXSR      SrPEXI                                                   BUG10423
     C                   ENDIF                                                              BUG10423
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
      /COPY WNCPYSRC,SEPRCSV002
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
     C                   ENDIF                                                                CAP060
      *
     C                   IF        CAP060F= 'Y'                                               CAP060
      *
      * Reset variables updated by this routine.
      *
     C                   EXSR      RESETERRS
      *                                                                                       CAP060
      ** Validate Percentage                                                                  CAP060
      *                                                                                       CAP060
      /COPY WNCPYSRC,SEPRCSV005                                                               CAP060
     C                   EXSR      SrSEPC                                                     CAP060
      /COPY WNCPYSRC,SEPRCSV006                                                               CAP060
      *                                                                                       CAP060
      *                                                                                       CAP060
      ** Validate Security Price                                                              CAP060
      *                                                                                       CAP060
      /COPY WNCPYSRC,SEPRCSV007                                                               CAP060
     C                   EXSR      SrPRIC                                                     CAP060
      /COPY WNCPYSRC,SEPRCSV008                                                               CAP060
                                                                                              CSD010
      ** If CSD010 is installed, validate Bid Price, Offer Price and                          CSD010
      ** Closing Price                                                                        CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   EXSR      SRPRICE2                                                   CSD010
     C                   ENDIF                                                                CSD010
      *                                                                                       CAP060
      ** Validate Value Date                                                                  CAP060
      *                                                                                       CAP060
      /COPY WNCPYSRC,SEPRCSV009                                                               CAP060
     C                   EXSR      SrVALD                                                     CAP060
      /COPY WNCPYSRC,SEPRCSV010                                                               CAP060
      *                                                                                       CAP060
      ** Validate FX Rate/ M/D Indicator                                                      CAP060
      *                                                                                       CAP060
      /COPY WNCPYSRC,SEPRCSV011                                                               CAP060
     C                   EXSR      SrFXMD                                                     CAP060
      /COPY WNCPYSRC,SEPRCSV012                                                               CAP060
      *                                                                                       CAP060
      ** Validate Data Request Id
      *                                                                                       CSD006
      /COPY WNCPYSRC,SEPRCSV013                                                               CSD006
     C                   EXSR      SrDFRQ                                                     CSD006
      /COPY WNCPYSRC,SEPRCSV014                                                               CSD006
      *                                                                                       CSD006
      ** Validate Price Timestamp
      *                                                                                       CSD006
      /COPY WNCPYSRC,SEPRCSV015                                                               CSD006
     C                   EXSR      SrPRTM                                                     CSD006
      /COPY WNCPYSRC,SEPRCSV016                                                               CSD006
      *                                                                                       CSD006
      ** Check that entry into Extel Fields will update something                             CAP060
      *                                                                                       CAP060
      /COPY WNCPYSRC,SEPRCSV017                                                               CAP060
     C                   EXSR      SrEXCK                                                     CAP060
      /COPY WNCPYSRC,SEPRCSV018                                                               CAP060
      *                                                                                       CAP060
      ** Validate Auto Price Indicator                                                        CAP060
      *                                                                                       CAP060
      /COPY WNCPYSRC,SEPRCSV019                                                               CAP060
     C                   EXSR      SrAUTP                                                     CAP060
      /COPY WNCPYSRC,SEPRCSV020                                                               CAP060
      *                                                                                       CAP060
      ** Validate Lower/Upper Price Boundary                                                  CAP060
      *                                                                                       CAP060
      /COPY WNCPYSRC,SEPRCSV021                                                               CAP060
     C                   EXSR      SrLWPR                                                     CAP060
      /COPY WNCPYSRC,SEPRCSV022                                                               CAP060
                                                                                              CGL031
      ** Validate Price Excluding Interest                                                    CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EXSR      SrPEXI                                                     CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', validate Credit Risk Spread and Liquidity                         CAS006
      ** Premium fields if non-blank.  The Net Treasury Price should                          CAS006
      ** not be equal or less than zero.                                                      CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND (DDPPRT = 'V'                             CAS006
     C                             OR DDPPRT = 'DT' OR DDPPRT = 'DV')                         CAS006
                                                                                              CAS006
     C                   EXSR      SrCRSK                                                     CAS006
                                                                                              CAS006
     C                   EXSR      SrLQPR                                                     CAS006
                                                                                              CAS006
     C                   IF        DDCRSKOK <>'N' AND DDLQPROK <>'N'                          CAS006
     C                             AND DDPRCOK <>'N'                                          CAS006
     C                   EXSR      SrNTPrice                                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        IDX = 0                                                    CAP060
     C                   EXSR      SetupValid                                                 CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
      /COPY WNCPYSRC,SEPRCSV003
      *
      * Return.
      *
     C                   RETURN
      *****************************************************************                       CAP060
      ** Sr PRIC  Security Price                                                              CAP060
      *****************************************************************                       CAP060
     C     SrPRIC        BEGSR                                                                CAP060
                                                                                              CAP060
      * Reset variables updated by validation                                                 CAP060
                                                                                              CAP060
     C                   EXSR      RSTERRS                                                    CAP060
      *                                                                                       CAP060
      ** Validate Security Price                                                              CAP060
      *                                                                                       CAP060
     C                   CALLB     'SEVSEPR01'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      ** Return Code                                                                          CAP060
     C                   PARM                    RetCodeIn                                    CAP060
      ** Action Code                                                                          CAP060
     C                   PARM                    DDACTN                                       CAP060
      ** Price                                                                                CAP060
     C                   PARM                    DDPPRC                                       CAP060
      ** Price Type                                                                           CAP060
     C                   PARM                    DDPPRT                                       CAP060
      ** FX Rate                                                                              CAP060
     C                   PARM                    DDNPXR                                       CAP060
      ** Current price                                                                        CAP060
     C                   PARM                    DDCURP                                       CAP060
      ** Portfolio reference                                                                  CAP060
     C                   PARM                    DDPTFR                                       CAP060
      ** Data Request feed identifier                                                         CAP060
     C                   PARM                    DDDTFR           32                          CAP060
      * Price (for warnings, passed from CVT, in numeric format)                              CAP060
      * lower boundary, upper boundary and percentage in numeric format                       CAP060
     C                   PARM                    HPPRC                                        CAP060
     C                   PARM                    PRPCEN            9 6                        CAP060
                                                                                              CAP060
      * Securites Prices tolerance                                                            CAP060
     C                   PARM                    MDSPTL            5 2                        CAP060
      *                                                                                       CAP060
      * OUTPUTS                                                                               CAP060
      *                                                                                       CAP060
      * Error fields/message IDs/message data (arrays) from/to caller                         CAP060
     C                   PARM                    FldNamXAr                                    CAP060
     C                   PARM                    MsgIdXar                                     CAP060
     C                   PARM                    MsgDtaXAr                                    CAP060
      *                                                                                       CAP060
      * Warning fields/message IDs/message data (arrays) from/to caller                       CAP060
     C                   PARM                    WFldNmXAr                                    CAP060
     C                   PARM                    WMsgIDXAr                                    CAP060
     C                   PARM                    WMsgDtXAR                                    CAP060
      *                                                                                       CAP060
      ** Price OK flag                                                                        CAP060
     C                   PARM                    DDPRCOK                                      CAP060
      ** FX Rate OK flag                                                                      CAP060
     C                   PARM                    DDNPXROK                                     CAP060
      *  EXTEL Price percentage allowable movement warning                                    CAP060
     C                   PARM                    PRPPWN            1                          CAP060
      *  Rates Tolerance exceeded                                                             CAP060
     C                   PARM                    PRTLEX            1                          CAP060
      *  Price in file format                                                                 CAP060
     C                   PARM                    PRPPRC                                       CAP060
                                                                                              CSD010
      ** CSD010 Switchable Feature                                                            CSD010
                                                                                              CSD010
     C                   PARM                    CSD010                                       CSD010
      *                                                                                       CAP060
      * Update error info with that returned from the validation module                       CAP060
                                                                                              CAP060
     C                   EXSR      UPDERRS                                                    CAP060
      *                                                                                       CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
     C/EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      ** Sr VALD  Value Date                                                                  CAP060
      *****************************************************************                       CAP060
     C     SrVALD        BEGSR                                                                CAP060
                                                                                              CAP060
      * Reset variables updated by validation                                                 CAP060
                                                                                              CAP060
     C                   EXSR      RSTERRS                                                    CAP060
      *                                                                                       CAP060
      ** Validate Value Date                                                                  CAP060
      *                                                                                       CAP060
     C                   CALLB     'SEVVLDT01'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      ** Return Code                                                                          CAP060
     C                   PARM                    RetCodeIn                                    CAP060
      ** Value Date                                                                           CAP060
     C                   PARM                    DDPVDT                                       CAP060
      ** Portfolio Reference                                                                  CAP060
     C                   PARM                    DDPTFR                                       CAP060
      ** Price Type                                                                           CAP060
     C                   PARM                    DDPPRT                                       CAP060
      ** Security Shortname                                                                   CAP060
     C                   PARM                    DDPSSN                                       CAP060
      ** Customer Number                                                                      CAP060
     C                   PARM                    DDPCNM                                       CAP060
      *                                                                                       CAP060
      ** ICD                                                                                  CAP060
      *                                                                                       CAP060
      * portfolio management indicator                                                        CAP060
     C                   PARM                    BGPFMG                                       CAP060
      * date format indicator                                                                 CAP060
     C                   PARM                    BJDFIN                                       CAP060
      * Ref attached to 997                                                                   CAP060
     C                   PARM                    FCR997                                       CAP060
      * portfolios supported                                                                  CAP060
     C                   PARM                    FCPORS                                       CAP060
      * private banking                                                                       CAP060
     C                   PARM                    BGN4ST                                       CAP060
      *                                                                                       CAP060
      * OUTPUTS                                                                               CAP060
      *                                                                                       CAP060
      * Error fields/message IDs/message data (arrays) from/to caller                         CAP060
     C                   PARM                    FldNamXAr                                    CAP060
     C                   PARM                    MsgIdXar                                     CAP060
     C                   PARM                    MsgDtaXAr                                    CAP060
      ** Value Date, numeric                                                                  CAP060
     C                   PARM                    PRPVDT            5 0                        CAP060
      ** Nominal currency                                                                     CAP060
     C                   PARM                    QATNMC            3                          CAP060
      ** Portfolio currency code                                                              CAP060
     C                   PARM                    QAPTCY            3                          CAP060
                                                                                              CAP060
      ** Value Date OK flag                                                                   CAP060
     C                   PARM                    DDVDTOK           1                          CAP060
      *                                                                                       CAP060
      *                                                                                       CAP060
      * Update error info with that returned from the validation module                       CAP060
                                                                                              CAP060
     C                   EXSR      UPDERRS                                                    CAP060
      *                                                                                       CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
     C/EJECT                                                                                  CAP060
      *****************************************************************                       CSD006
      ** Sr PRTM  Security Price Timestamp                                                    CSD006
      *****************************************************************                       CSD006
     C     SrPRTM        BEGSR                                                                CSD006
                                                                                              CSD006
      * Reset variables updated by validation                                                 CSD006
                                                                                              CSD006
     C                   EXSR      RSTERRS                                                    CSD006
      *                                                                                       CSD006
      ** Validate Time Stamp                                                                  CSD006
      *                                                                                       CSD006
     C                   CALLB     'SEVPRTM01'                                                CSD006
      ** Return Code                                                                          CSD006
     C                   PARM                    RetCodeIn                                    CSD006
      ** Data Feed Timestamp                                                                  CSD006
     C                   PARM                    DDDFTS                                       CSD006
      ** Data Feed Request ID                                                                 CSD006
     C                   PARM                    DDDTFR                                       CSD006
      * OUTPUTS                                                                               CSD006
      *                                                                                       CSD006
      * Error fields/message IDs/message data (arrays) from/to caller                         CSD006
     C                   PARM                    FldNamXAr                                    CSD006
     C                   PARM                    MsgIdXar                                     CSD006
     C                   PARM                    MsgDtaXAr                                    CSD006
                                                                                              CSD006
      *  Data Feed Req Id OK flag                                                             CSD006
     C                   PARM                    DDDTFROK          1                          CSD006
      *  Data Feed Timestamp OK flag                                                          CSD006
     C                   PARM                    DDDFTSOK          1                          CSD006
      ** Data Feed Timestamp                                                                  CSD006
     C                   PARM      *ZERO         JDFTS                                        CSD006
      *                                                                                       CSD006
      * Update error info with that returned from the validation module                       CSD006
                                                                                              CSD006
     C                   EXSR      UPDERRS                                                    CSD006
      *                                                                                       CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************                       CSD006
     C/EJECT                                                                                  CSD006
      *****************************************************************                       CSD006
      ** Sr FXMD  FX Rate / M/D indicator                                                     CAP060
      *****************************************************************                       CAP060
     C     SrFXMD        BEGSR                                                                CAP060
                                                                                              CAP060
      * Reset variables updated by validation                                                 CAP060
                                                                                              CAP060
     C                   EXSR      RSTERRS                                                    CAP060
      *                                                                                       CAP060
      ** Validate FX Rate /  M/D Indicator                                                    CAP060
      *                                                                                       CAP060
     C                   CALLB     'SEVFXIN01'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      ** Return Code                                                                          CAP060
      *                                                                                       CAP060
     C                   PARM                    RetCodeIn                                    CAP060
      * Multiply / divide indicator                                                           CAP060
     C                   PARM                    DDNPMD                                       CAP060
      * Exchange Rate                                                                         CAP060
     C                   PARM                    DDNPXR                                       CAP060
      * Portfolio Reference                                                                   CAP060
     C                   PARM                    DDPTFR                                       CAP060
      * Price                                                                                 CAP060
     C                   PARM                    DDPPRC                                       CAP060
      *                                                                                       CAP060
      ** ICD                                                                                  CAP060
      *                                                                                       CAP060
     C                   PARM                    FCR997                                       CAP060
      ** Portfolio management indicator                                                       CAP060
     C                   PARM                    BGPFMG                                       CAP060
      ** Nominal currency                                                                     CAP060
     C                   PARM                    QATNMC            3                          CAP060
      ** Portfolio currency code                                                              CAP060
     C                   PARM                    QAPTCY            3                          CAP060
      ** Value Date                                                                           CAP060
     C                   PARM                    PRPVDT                                       CAP060
      *                                                                                       CAP060
      * OUTPUTS                                                                               CAP060
      *                                                                                       CAP060
      * Error fields/message IDs/message data (arrays) from/to caller                         CAP060
     C                   PARM                    FldNamXAr                                    CAP060
     C                   PARM                    MsgIdXar                                     CAP060
     C                   PARM                    MsgDtaXAr                                    CAP060
      *                                                                                       CAP060
      * Warning fields/message IDs/message data (arrays) from/to caller                       CAP060
     C                   PARM                    WFldNmXAr                                    CAP060
     C                   PARM                    WMsgIdXar                                    CAP060
     C                   PARM                    WMsgDtXAR                                    CAP060
      **  OK flags                                                                            CAP060
      * Multiply / divide indicator                                                           CAP060
     C                   PARM                    DDNPMDOK                                     CAP060
      * Exchange Rate                                                                         CAP060
     C                   PARM                    DDNPXROK                                     CAP060
      ** Exchange Rate (Nominl > Port)                                                        CAP060
     C                   PARM                    PRNPXR                                       CAP060
      ** Nominal Portfolio Mult/Div Ind                                                       CAP060
     C                   PARM                    PRNPMD                                       CAP060
      ** Price                                                                                CAP060
     C                   PARM                    PRPPRC                                       CAP060
      ** Warning on FX rate, if this is called more than once                                 CAP060
     C                   PARM                    WWNPXR           13 8                        CAP060
      *                                                                                       CAP060
      *                                                                                       CAP060
      * Update error info with that returned from the validation module                       CAP060
                                                                                              CAP060
     C                   EXSR      UPDERRS                                                    CAP060
      *                                                                                       CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
     C/EJECT                                                                                  CAP060
      *****************************************************************                       CSD006
      ** Sr DFRQ  Data Feed Request ID                                                        CSD006
      *****************************************************************                       CSD006
     C     SrDFRQ        BEGSR                                                                CSD006
                                                                                              CSD006
      * Reset variables updated by validation                                                 CSD006
                                                                                              CSD006
     C                   EXSR      RSTERRS                                                    CSD006
      *                                                                                       CSD006
      ** Validate Data Feed Request ID                                                        CSD006
      *                                                                                       CSD006
     C                   CALLB     'SEVDFRQ01'                                                CSD006
      ** Return Code                                                                          CSD006
     C                   PARM                    RetCodeIn                                    CSD006
      ** Data Feed Request ID                                                                 CSD006
     C                   PARM                    DDDTFR           32                          CSD006
      * OUTPUTS                                                                               CSD006
      *                                                                                       CSD006
      * Warning fields/message IDs/message data (arrays) from/to caller                       CSD006
     C                   PARM                    WFldNmXAr                                    CSD006
     C                   PARM                    WMsgIdXar                                    CSD006
     C                   PARM                    WMsgDtXAR                                    CSD006
      *  Data Feed Req Id OK flag                                                             CSD006
     C                   PARM                    DDDTFROK          1                          CSD006
      ** Data Feed Request ID                                                                 CSD006
     C                   PARM                    WDDTFR           32                          CSD006
      * Update error info with that returned from the validation module                       CSD006
                                                                                              CSD006
     C                   EXSR      UPDERRS                                                    CSD006
      *                                                                                       CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************                       CSD006
     C/EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      ** Sr EXCK  Check input into EXTEL fields will update EXVALD file                       CAP060
      *****************************************************************                       CAP060
     C     SrEXCK        BEGSR                                                                CAP060
                                                                                              CAP060
      * Reset variables updated by validation                                                 CAP060
                                                                                              CAP060
     C                   EXSR      RSTERRS                                                    CAP060
      *                                                                                       CAP060
      ** Validate Extel fields                                                                CAP060
      *                                                                                       CAP060
     C                   CALLB     'SEVEXCK01'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      ** Return Code                                                                          CAP060
     C                   PARM                    RetCodeIn                                    CAP060
      ** Action Code                                                                          CAP060
     C                   PARM                    DDACTN                                       CAP060
      ** Security Shortname                                                                   CAP060
     C                   PARM                    DDPSSN                                       CAP060
      ** Price Type                                                                           CAP060
     C                   PARM                    DDPPRT                                       CAP060
      ** Auto Price Indicator                                                                 CAP060
     C                   PARM                    DDAPND                                       CAP060
      ** Lower Price                                                                          CAP060
     C                   PARM                    DDLPRI                                       CAP060
      ** Upper Price                                                                          CAP060
     C                   PARM                    DDUPRI                                       CAP060
      ** Percentage                                                                           CAP060
     C                   PARM                    DDPCEN                                       CAP060
      ** ICD                                                                                  CAP060
      *                                                                                       CAP060
     C                   PARM                    BVEXOP                                       CAP060
      * OUTPUTS                                                                               CAP060
      *                                                                                       CAP060
      * Warning fields/message IDs/message data (arrays) from/to caller                       CAP060
     C                   PARM                    WFldNmXAr                                    CAP060
     C                   PARM                    WMsgIdXar                                    CAP060
     C                   PARM                    WMsgDtXAR                                    CAP060
      *                                                                                       CAP060
      ** Auto price indicator OK                                                              CAP060
     C                   PARM                    DDAPNDOK                                     CAP060
      ** Lower Price Indicator OK flags                                                       CAP060
     C                   PARM                    DDLPRIOK                                     CAP060
      ** Upper Price Indicator OK flags                                                       CAP060
     C                   PARM                    DDUPRIOK                                     CAP060
      ** Percentage OK flag                                                                   CAP060
     C                   PARM                    DDPCENOK                                     CAP060
      ** Work version of security shortname, to check if warning should be shown again        CAP060
     C                   PARM                    WXPSSN           10                          CAP060
      *                                                                                       CAP060
      *                                                                                       CAP060
      * Update error info with that returned from the validation module                       CAP060
                                                                                              CAP060
     C                   EXSR      UPDERRS                                                    CAP060
      *                                                                                       CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
     C/EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      ** Sr AUTP  Auto Price Indicator                                                        CAP060
      *****************************************************************                       CAP060
     C     SrAUTP        BEGSR                                                                CAP060
                                                                                              CAP060
      * Reset variables updated by validation                                                 CAP060
                                                                                              CAP060
     C                   EXSR      RSTERRS                                                    CAP060
      *                                                                                       CAP060
      ** Validate Auto Price Indicator                                                        CAP060
      *                                                                                       CAP060
     C                   CALLB     'SEVAUIN01'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      ** Return Code                                                                          CAP060
     C                   PARM                    RetCodeIn                                    CAP060
      ** Auto Price Indicator                                                                 CAP060
     C                   PARM                    DDAPND                                       CAP060
      ** Price Type                                                                           CAP060
     C                   PARM                    DDPPRT                                       CAP060
      ** ICD                                                                                  CAP060
     C                   PARM                    BVEXOP                                       CAP060
      *                                                                                       CAP060
      * OUTPUTS                                                                               CAP060
      *                                                                                       CAP060
      * Error fields/message IDs/message data (arrays) from/to caller                         CAP060
     C                   PARM                    FldNamXAr                                    CAP060
     C                   PARM                    MsgIDXAr                                     CAP060
     C                   PARM                    MsgDtaXAr                                    CAP060
      *                                                                                       CAP060
      ** Auto price                                                                           CAP060
     C                   PARM                    EXVEXAP                                      CAP060
      *                                                                                       CAP060
      ** Auto price indicator OK                                                              CAP060
     C                   PARM                    DDAPNDOK                                     CAP060
      *                                                                                       CAP060
      *                                                                                       CAP060
      * Update error info with that returned from the validation module                       CAP060
                                                                                              CAP060
     C                   EXSR      UPDERRS                                                    CAP060
      *                                                                                       CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
     C/EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      ** Sr LWPR   Lower/Upper Price Boundary                                                 CAP060
      *****************************************************************                       CAP060
     C     SrLWPR        BEGSR                                                                CAP060
                                                                                              CAP060
      * Reset variables updated by validation                                                 CAP060
                                                                                              CAP060
     C                   EXSR      RSTERRS                                                    CAP060
                                                                                              CAP060
      * Validate Lower/Upper Price Boundary                                                   CAP060
                                                                                              CAP060
     C                   CALLB     'SEVLWPR01'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      ** Return Code                                                                          CAP060
     C                   PARM                    RetCodeIn                                    CAP060
      ** Lower Price                                                                          CAP060
     C                   PARM                    DDLPRI                                       CAP060
      ** Upper Price                                                                          CAP060
     C                   PARM                    DDUPRI                                       CAP060
      ** Price Type                                                                           CAP060
     C                   PARM                    DDPPRT                                       CAP060
      *  Price in file format                                                                 CAP060
     C                   PARM                    PRPPRC                                       CAP060
      ** EXTEL indicator                                                                      CAP060
     C                   PARM                    BVEXOP                                       CAP060
      *                                                                                       CAP060
      * OUTPUTS                                                                               CAP060
      *                                                                                       CAP060
      * Error fields/message IDs/message data (arrays) from/to caller                         CAP060
     C                   PARM                    FldNamXAr                                    CAP060
     C                   PARM                    MsgIDXAr                                     CAP060
     C                   PARM                    MsgDtaXAr                                    CAP060
      *                                                                                       CAP060
      * Warning fields/message IDs/message data (arrays) from/to caller                       CAP060
     C                   PARM                    WFldNmXAr                                    CAP060
     C                   PARM                    WMsgIDXAr                                    CAP060
     C                   PARM                    WMsgDtXAR                                    CAP060
      *                                                                                       CAP060
      ** Lower and Upper Price Boundary                                                       CAP060
     C                   PARM                    PRLPRI           15 8                        CAP060
     C                   PARM                    PRUPRI           15 8                        CAP060
      *  EXTEL Price boundaries warning indicator                                             CAP060
     C                   PARM                    PRPBWN            1                          CAP060
      *                                                                                       CAP060
      ** Lower and Upper Price Indicator OK flags                                             CAP060
     C                   PARM                    DDLPRIOK          1                          CAP060
     C                   PARM                    DDUPRIOK          1                          CAP060
     C                   PARM                    DDPRCOK           1                          CAP060
      ** Work fields used only to condition the display of warnings                           CAP060
     C                   PARM                    WLPBD            15 8                        CAP060
     C                   PARM                    WUPBD            15 8                        CAP060
     C                   PARM                    WPPRC            15 8                        CAP060
                                                                                              CAP060
      *                                                                                       CAP060
      *                                                                                       CAP060
      * Update error info with that returned from the validation module                       CAP060
                                                                                              CAP060
     C                   EXSR      UPDERRS                                                    CAP060
      *                                                                                       CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
     C/EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      ** Sr SEPC  Securities Prices Percentage                                                CAP060
      *****************************************************************                       CAP060
     C     SrSEPC        BEGSR                                                                CAP060
                                                                                              CAP060
      * Reset variables updated by validation                                                 CAP060
                                                                                              CAP060
     C                   EXSR      RSTERRS                                                    CAP060
                                                                                              CAP060
      * Validate Percentage                                                                   CAP060
                                                                                              CAP060
     C                   CALLB     'SEVSEPC01'                                                CAP060
      *                                                                                       CAP060
      * INPUTS                                                                                CAP060
      *                                                                                       CAP060
      ** Return Code                                                                          CAP060
     C                   PARM                    RetCodeIn                                    CAP060
      ** Percentage                                                                           CAP060
     C                   PARM                    DDPCEN                                       CAP060
      ** Price Type                                                                           CAP060
     C                   PARM                    DDPPRT                                       CAP060
      ** EXTEL Indicator                                                                      CAP060
     C                   PARM                    BVEXOP                                       CAP060
      *                                                                                       CAP060
      * OUTPUTS                                                                               CAP060
      *                                                                                       CAP060
      * Error fields/message IDs/message data (arrays) from/to caller                         CAP060
     C                   PARM                    FldNamXAr                                    CAP060
     C                   PARM                    MsgIdXar                                     CAP060
     C                   PARM                    MsgDtaXAr                                    CAP060
      *                                                                                       CAP060
      ** Percentage                                                                           CAP060
     C                   PARM                    PRPCEN                                       CAP060
      *                                                                                       CAP060
      ** Percentage OK flag                                                                   CAP060
     C                   PARM                    DDPCENOK          1                          CAP060
      *                                                                                       CAP060
      * Update error info with that returned from the validation module                       CAP060
                                                                                              CAP060
     C                   EXSR      UPDERRS                                                    CAP060
      *                                                                                       CAP060
     C                   ENDSR                                                                CAP060
                                                                                              CSD010
      *****************************************************************                       CSD010
      * SRPRICE2 - Bid Price, Offer Price, Closing Price Validation   *                       CSD010
      *****************************************************************                       CSD010
                                                                                              CSD010
     C     SRPRICE2      BEGSR                                                                CSD010
                                                                                              CSD010
      ** Reset variables updated by validation                                                CSD010
                                                                                              CSD010
     C                   EXSR      RSTERRS                                                    CSD010
                                                                                              CSD010
      ** Validate Security Price                                                              CSD010
                                                                                              CSD010
     C                   CALLB     'SEVSEPR02'                                                CSD010
                                                                                              CSD010
      ** Inputs                                                                               CSD010
                                                                                              CSD010
      ** Return Code                                                                          CSD010
                                                                                              CSD010
     C                   PARM                    RetCodeIn                                    CSD010
                                                                                              CSD010
      ** Action Code                                                                          CSD010
                                                                                              CSD010
     C                   PARM                    DDACTN                                       CSD010
                                                                                              CSD010
      ** Mid Price                                                                            CSD010
                                                                                              CSD010
     C                   PARM                    DDPPRC                                       CSD010
                                                                                              CSD010
      ** Bid Price                                                                            CSD010
                                                                                              CSD010
     C                   PARM                    DDBDPR                                       CSD010
                                                                                              CSD010
      ** Offer Price                                                                          CSD010
                                                                                              CSD010
     C                   PARM                    DDOFPR                                       CSD010
                                                                                              CSD010
      ** Closing Price                                                                        CSD010
                                                                                              CSD010
     C                   PARM                    DDCLPR                                       CSD010
                                                                                              CSD010
      ** Price Type                                                                           CSD010
                                                                                              CSD010
     C                   PARM                    DDPPRT                                       CSD010
                                                                                              CSD010
      ** FX Rate                                                                              CSD010
                                                                                              CSD010
     C                   PARM                    DDNPXR                                       CSD010
                                                                                              CSD010
      ** Current price                                                                        CSD010
                                                                                              CSD010
     C                   PARM                    DDCURP                                       CSD010
                                                                                              CSD010
      ** Portfolio reference                                                                  CSD010
                                                                                              CSD010
     C                   PARM                    DDPTFR                                       CSD010
                                                                                              CSD010
      ** Data Request feed identifier                                                         CSD010
                                                                                              CSD010
     C                   PARM                    DDDTFR                                       CSD010
                                                                                              CSD010
      ** Price (for warnings, passed from CVT, in numeric format)                             CSD010
      ** lower boundary, upper boundary and percentage in numeric                             CSD010
      ** format                                                                               CSD010
                                                                                              CSD010
     C                   PARM                    HPPRC                                        CSD010
     C                   PARM                    HBDPR                                        CSD010
     C                   PARM                    HOFPR                                        CSD010
     C                   PARM                    HCLPR                                        CSD010
     C                   PARM                    PRPCEN                                       CSD010
                                                                                              CSD010
      ** Securites Prices tolerance                                                           CSD010
                                                                                              CSD010
     C                   PARM                    MDSPTL                                       CSD010
                                                                                              CSD010
      ** Outputs                                                                              CSD010
                                                                                              CSD010
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD010
                                                                                              CSD010
     C                   PARM                    FldNamXAr                                    CSD010
     C                   PARM                    MsgIdXar                                     CSD010
     C                   PARM                    MsgDtaXAr                                    CSD010
                                                                                              CSD010
      ** Warning fields/message IDs/message data(arrays) from/to caller                       CSD010
                                                                                              CSD010
     C                   PARM                    WFldNmXAr                                    CSD010
     C                   PARM                    WMsgIDXAr                                    CSD010
     C                   PARM                    WMsgDtXAR                                    CSD010
                                                                                              CSD010
      ** Mid Price OK flag                                                                    CSD010
                                                                                              CSD010
     C                   PARM                    DDPRCOK                                      CSD010
                                                                                              CSD010
      ** Bid Price OK Flag                                                                    CSD010
                                                                                              CSD010
     C                   PARM                    DDBDPROK                                     CSD010
                                                                                              CSD010
      ** Offer Price OK flag                                                                  CSD010
                                                                                              CSD010
     C                   PARM                    DDOFPROK                                     CSD010
                                                                                              CSD010
      ** Closing Price OK flag                                                                CSD010
                                                                                              CSD010
     C                   PARM                    DDCLPROK                                     CSD010
                                                                                              CSD010
      ** FX Rate OK flag                                                                      CSD010
                                                                                              CSD010
     C                   PARM                    DDNPXROK                                     CSD010
                                                                                              CSD010
      ** EXTEL Price percentage allowable movement warning                                    CSD010
                                                                                              CSD010
     C                   PARM                    PRPPWN                                       CSD010
                                                                                              CSD010
      ** Rates Tolerance exceeded                                                             CSD010
                                                                                              CSD010
     C                   PARM                    PRTLEX                                       CSD010
                                                                                              CSD010
      ** Mid Price in file format                                                             CSD010
                                                                                              CSD010
     C                   PARM                    PRPPRC                                       CSD010
                                                                                              CSD010
      ** Bid Price in file format                                                             CSD010
                                                                                              CSD010
     C                   PARM                    PRBDPR                                       CSD010
                                                                                              CSD010
      ** Offer Price in file format                                                           CSD010
                                                                                              CSD010
     C                   PARM                    PROFPR                                       CSD010
                                                                                              CSD010
      ** Closing Price in file format                                                         CSD010
                                                                                              CSD010
     C                   PARM                    PRCLPR                                       CSD010
                                                                                              CSD010
      ** Update error info with that returned from the validation                             CSD010
      ** module                                                                               CSD010
                                                                                              CSD010
     C                   EXSR      UPDERRS                                                    CSD010
                                                                                              CSD010
     C                   ENDSR                                                                CSD010
                                                                                              CSD010
      *****************************************************************                       CAP060
     C/EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      * SrCRSK - Price Credit Risk Spread Validation                                          CAS006
      *****************************************************************                       CAS006
     C     SrCRSK        BEGSR                                                                CAS006
                                                                                              CAS006
      ** Reset variables updated by validation                                                CAS006
                                                                                              CAS006
     C                   EXSR      RSTERRS                                                    CAS006
                                                                                              CAS006
      ** Validate Price Credit Risk Spread                                                    CAS006
                                                                                              CAS006
     C                   CALLB     'SEVPCSPDRT'                                               CAS006
                                                                                              CAS006
      ** Input Parameters:                                                                    CAS006
                                                                                              CAS006
      ** Return Code                                                                          CAS006
      ** Spread Rate                                                                          CAS006
                                                                                              CAS006
     C                   PARM      *BLANKS       RetCodeIn                                    CAS006
     C                   PARM      'DDCRSK    '  PfldName                                     CAS006
     C                   PARM                    DDCRSK                                       CAS006
                                                                                              CAS006
      ** Output Parameters:                                                                   CAS006
                                                                                              CAS006
      ** Error Fields/Message IDs/Message Data (Arrays) From/To Caller                        CAS006
      ** Validated Spread Rate                                                                CAS006
      ** Spread Rate OK Indicator                                                             CAS006
                                                                                              CAS006
     C                   PARM                    FldNamXAr                                    CAS006
     C                   PARM                    MsgIDXAr                                     CAS006
     C                   PARM                    MsgDtaXAr                                    CAS006
     C                   PARM                    PRCRSK                                       CAS006
     C                   PARM                    DDCRSKOK                                     CAS006
                                                                                              CAS006
      ** Update error info with that returned from the validation module                      CAS006
                                                                                              CAS006
     C                   EXSR      UPDERRS                                                    CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
     C/EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      * SrLQPR - Price Liquidity Premium Validation                                           CAS006
      *****************************************************************                       CAS006
     C     SrLQPR        BEGSR                                                                CAS006
                                                                                              CAS006
      ** Reset variables updated by validation                                                CAS006
                                                                                              CAS006
     C                   EXSR      RSTERRS                                                    CAS006
                                                                                              CAS006
      ** Validate Price Liquidity Previum                                                     CAS006
                                                                                              CAS006
     C                   CALLB     'SEVPCSPDRT'                                               CAS006
                                                                                              CAS006
      ** Input Parameters:                                                                    CAS006
                                                                                              CAS006
      ** Return Code                                                                          CAS006
      ** Spread Rate                                                                          CAS006
                                                                                              CAS006
     C                   PARM      *BLANKS       RetCodeIn                                    CAS006
     C                   PARM      'DDLQPR    '  PfldName                                     CAS006
     C                   PARM                    DDLQPR                                       CAS006
                                                                                              CAS006
      ** Output Parameters:                                                                   CAS006
                                                                                              CAS006
      ** Error Fields/Message IDs/Message Data (Arrays) From/To Caller                        CAS006
      ** Validated Spread Rate                                                                CAS006
      ** Spread Rate OK Indicator                                                             CAS006
                                                                                              CAS006
     C                   PARM                    FldNamXAr                                    CAS006
     C                   PARM                    MsgIDXAr                                     CAS006
     C                   PARM                    MsgDtaXAr                                    CAS006
     C                   PARM                    PRLQPR                                       CAS006
     C                   PARM                    DDLQPROK                                     CAS006
                                                                                              CAS006
      ** Update error info with that returned from the validation module                      CAS006
                                                                                              CAS006
     C                   EXSR      UPDERRS                                                    CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
     C/EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      * SrNTPrice - Validates Net Treasury Price                                              CAS006
      *****************************************************************                       CAS006
     C     SrNTPrice     BEGSR                                                                CAS006
                                                                                              CAS006
      ** Net Treasury Price should not be equal to or less than zero.                         CAS006
                                                                                              CAS006
     C                   IF        CAP060F = 'Y'                                              CAS006
     C                   EVAL      WNTPrice = PRPPRC + PRCRSK + PRLQPR                        CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WNTPrice = JPPRC + PRCRSK + PRLQPR                         CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WNTPrice <= *ZERO                                          CAS006
     C                   EVAL      DDPRCOK = 'N'                                              CAS006
     C                   EVAL      DDCRSKOK = 'N'                                             CAS006
     C                   EVAL      DDLQPROK = 'N'                                             CAS006
     C                   ADD       1             Idx                                          CAS006
     C                   EVAL      MsgIDArr(Idx) = 'SEA0523'                                  CAS006
     C                   EVAL      FldNameArr(Idx) = 'DDCRSK'                                 CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
     C/EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      * RSTERRS   - Reset error information that is received back     *                       CAP060
      *    from each validation module.                               *                       CAP060
      *****************************************************************                       CAP060
     C     RSTERRS       BEGSR                                                                CAP060
                                                                                              CAP060
     C                   EVAL      RetCodeOut = *Blanks                                       CAP060
      *                                                                                       CAP060
      * Reset error & warning fields/message IDs/message data (arrays)                        CAP060
     C                   MOVEL     *BLANK        FldNamXAr                                    CAP060
     C                   MOVEL     *BLANK        MsgIDXAr                                     CAP060
     C                   MOVEL     *BLANK        MsgDtaXAr                                    CAP060
     C                   MOVEL     *BLANK        WFldNmXAr                                    CAP060
     C                   MOVEL     *BLANK        WMsgIDXAr                                    CAP060
     C                   MOVEL     *BLANK        WMsgDtXAr                                    CAP060
                                                                                              CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      *****************************************************************                       CAP060
      * UPDERRS   - Update error information with that received back  *                       CAP060
      *    from each validation module.                               *                       CAP060
      *****************************************************************                       CAP060
     C     UPDERRS       BEGSR                                                                CAP060
      *                                                                                       CAP060
      * Update warning fields/message IDs/message data (arrays)                               CAP060
      *                                                                                       CAP060
     C                   Z-ADD     1             I                                            CAP060
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  CAP060
     C     *IN99         IFEQ      '1'                                                        CAP060
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)                                CAP060
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)                                 CAP060
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)                                CAP060
     C                   END                                                                  CAP060
      *                                                                                       CAP060
      * Set Warning Index                                                                     CAP060
     C                   Z-ADD     1             I                                            CAP060
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  CAP060
     C     I             SUB       1             WIdx                                         CAP060
      *                                                                                       CAP060
      *                                                                                       CAP060
      * Update error fields/message IDs/message data (arrays)                                 CAP060
      *                                                                                       CAP060
     C                   Z-ADD     1             I                 3 0                        CAP060
     C     *BLANK        LOOKUP    FldNameArr(I)                          99                  CAP060
     C     *IN99         IFEQ      '1'                                                        CAP060
     C                   MOVEA     FldNamXAr     FlDNameArr(I)                                CAP060
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)                                  CAP060
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)                                 CAP060
     C                   END                                                                  CAP060
      *                                                                                       CAP060
      * Set Error Index                                                                       CAP060
     C                   Z-ADD     1             I                                            CAP060
     C     *BLANK        LOOKUP    FldNameArr(I)                          99                  CAP060
     C     I             SUB       1             Idx                                          CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
     C/EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      ** SrPEXI  Price Excluding Interest                                                     CGL031
      *****************************************************************                       CGL031
     C     SrPEXI        BEGSR                                                                CGL031
                                                                                              CGL031
      ** Reset variables updated by validation                                                CGL031
                                                                                              CGL031
     C                   EXSR      RSTERRS                                                    CGL031
                                                                                              CGL031
      ** Validate Price Excluding Interest                                                    CGL031
                                                                                              CGL031
     C                   CALLB     'SEVSEFSPR1'                                               CGL031
                                                                                              CGL031
      ** INPUTS                                                                               CGL031
      ** -----------                                                                          CGL031
                                                                                              CGL031
      ** Return Code                                                                          CGL031
     C                   PARM                    RetCodeIn                                    CGL031
                                                                                              CGL031
      ** Price Excluding Interest                                                             CGL031
     C                   PARM                    DDPEXI                                       CGL031
                                                                                              CGL031
      ** Price Type                                                                           CGL031
     C                   PARM                    DDPPRT                                       CGL031
                                                                                              CGL031
      ** Security Shortname                                                                   CGL031
     C                   PARM                    DDPSSN                                       CGL031
                                                                                              CGL031
      ** Price                                                                                CGL031
     C                   PARM                    DDPPRC                                       CGL031
                                                                                              CGL031
      ** Price Value Date                                                                     CGL031
     C                   PARM                    DDPVDT                                       CGL031
                                                                                              CGL031
      ** OUTPUTS                                                                              CGL031
      ** -------                                                                              CGL031
                                                                                              CGL031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL031
     C                   PARM                    FldNamXAr                                    CGL031
     C                   PARM                    MsgIDXAr                                     CGL031
     C                   PARM                    MsgDtaXAr                                    CGL031
                                                                                              CGL031
      ** Price Excluding Interest Indicator OK                                                CGL031
     C                   PARM                    DDPEXIOK                                     CGL031
                                                                                              CGL031
      ** Fiscal Price                                                                         CGL031
     C                   PARM                    PRPEXI                                       CGL031
                                                                                              CGL031
      ** Update error info with that returned from the validation module                      CGL031
                                                                                              CGL031
     C                   EXSR      UPDERRS                                                    CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
     C/EJECT
      *****************************************************************
      ** VPRDPRICE - Validate Price Record
      *****************************************************************
     C     VPRDPRICE     BEGSR
      *
      * Reset variables updated by this routine.
      *
     C                   EXSR      RESETERRS
     C                   Z-ADD     *ZERO         JPPRC
     C                   Z-ADD     *ZERO         JLPBD
     C                   Z-ADD     *ZERO         JUPBD
     C                   Z-ADD     *ZERO         JPMOV
     C                   Z-ADD     *ZERO         PRPVDT
     C                   MOVEL     *BLANK        JEXAP                                        189506
      *
      * ACTION = I or A, AND PRICE TYPE IS 'V '
      *  VALIDATION OF FIELDS FOR INSERT/AMEND
      * ========================================
      *
     C     DDLPRI        IFNE      *BLANKS
     C     DDUPRI        ORNE      *BLANKS
     C     DDPCEN        ORNE      *BLANKS
      *
      * Move Price source into output field
      *
     C                   MOVEL     'S'           PRPSRC
      * Lower price boundary if present, must be validated as a 15,8
      *       numeric field.
      *
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDLPRI        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      * Check that LPRI is numeric
      *
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDLPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'MMA0820'
     C                   EVAL      FldNameArr(Idx) = 'DDLPRI'
     C                   ELSE
      *
      * If field is OK, move to numeric output field
      * Check that LPRI is positive.
      *
     C                   MOVE      ZFIELD        JLPBD            15 8
      *
     C     JLPBD         IFLT      0
     C                   MOVE      'N'           DDLPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIdArr(Idx) = 'MMA0821'
     C                   EVAL      FldNameArr(Idx) = 'DDLPRI'
     C                   ENDIF
     C                   ENDIF
      *
      * Upper price boundary if present, must be validated as a 15,8
      *       numeric field.
      *
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDUPRI        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      * Check that UPRI is numeric
      *
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDUPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'MMA0822'
     C                   EVAL      FldNameArr(Idx) = 'DDUPRI'
     C                   ELSE
      *
      * If field is OK, move to numeric output field
      * Check that UPRI is positive.
      *
     C                   MOVE      ZFIELD        JUPBD            15 8
      *
     C     JUPBD         IFLT      0
     C                   MOVE      'N'           DDUPRIOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0823'
     C                   EVAL      FldNamXAr (Idx) = 'DDUPRI'
     C                   ENDIF
     C                   ENDIF
      *
      * Percentage allowable is mandatory and must be validated as a 9,6
      *       numeric field.
      *
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     6             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDPCEN        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      * Check that PCEN is numeric
      *
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDPCENOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'MMA0824'
     C                   EVAL      FldNameArr(Idx) = 'DDPCEN'
     C                   ELSE
      *
      * If field is OK, move to numeric output field
      * Check that PCEN is positive.
      *
     C                   MOVE      ZFIELD        JPMOV             9 6
      *
     C     JPMOV         IFLT      0
     C                   MOVE      'N'           DDPCENOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'MMA0825'
     C                   EVAL      FldNameArr (Idx) = 'DDPCEN'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      *  Price field  -  mandatory entry as valid number.
      *
     C     DDPPRC        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'MMA0810'
     C                   EVAL      FldNameArr(Idx) = 'DDPPRC'
     C                   ELSE
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDPPRC        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      * Check that PPRC is numeric
      *
     C     ZRTN          IFEQ      'N'
     C                   MOVE      'N'           DDPRCOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'MMA0811'
     C                   EVAL      FldNameArr(Idx) = 'DDPPRC'
     C                   ELSE
      *
      * If field is OK, move to numeric output field
      * Check that PPRC is positive.
      *
     C                   MOVE      ZFIELD        JPPRC            15 8
      *
     C*****JPPRC         IFLE      0                                                        AR670962
     C     JPPRC         IFLT      0                                                        AR670962
     C                   MOVE      'N'           DDPRCOK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'MMA0812'
     C                   EVAL      FldNameArr (Idx) = 'DDPPRC'
     C                   ENDIF
     C                   ENDIF
      *
      * Fetch market price
      *
     C     DDPSSN        CHAIN     SECTYDF                            99
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     MKPR          CURPRC           15 8
     C                   ENDIF
      *
      * Fetch 10% + or - of Current price for comparison
      *    ** WARNING ERROR ONLY - ACCEPT IF UNCHANGED **
      *
     C     JPPRC         IFNE      HPPRC
      *
      * Price type is 'V ', (current price), use value entered
      * (ie. do not use if blanks)
      *   as percentage allowable otherwise use 10%.
      *
     C     JPMOV         IFNE      0
     C     JPMOV         DIV(H)    100           WK158            15 8
     C     CURPRC        MULT      WK158         WK158
     C                   ELSE
     C     CURPRC        DIV(H)    10            WK158
     C                   ENDIF
     C     CURPRC        ADD       WK158         CURPRP           15 8
     C     CURPRC        SUB       WK158         CURPRL           15 8
     C     JPPRC         IFGT      CURPRP
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0813'
     C                   EVAL      WFldNamArr(WIdx) = 'JPPRC'
     C                   EVAL      DDPRCOK = 'W'
     C                   EVAL      PRPPWN = 'Y'
     C                   ELSE
     C     JPPRC         IFLT      CURPRL
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0813'
     C                   EVAL      WFldNamArr(WIdx) = 'JPPRC'
     C                   EVAL      DDPRCOK = 'W'
     C                   EVAL      PRPPWN = 'Y'
     C                   ELSE
     C                   EVAL      PRPPWN = 'N'
     C                   EVAL      DDPRCOK = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      * Price type is 'V ', (current price) and the upper and lower
      * boundaries are not zero, the price must be within these boundaries.
      *
      *   ** WARNING ERROR ONLY - ACCEPT IF UNCHANGED **
      *
     C     JLPBD         IFNE      0
     C     JUPBD         ANDNE     0
     C     JPPRC         IFGT      JUPBD
     C     JPPRC         ORLT      JLPBD
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0815'
     C                   EVAL      WFldNamArr(WIdx) = 'JPPRC'
     C                   EVAL      DDPRCOK = 'W'
     C                   EVAL      PRPBWN = 'Y'
     C                   ELSE
     C                   EVAL      DDPRCOK = 'Y'
     C                   EVAL      PRPBWN = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     JPPRC         HPPRC            15 8
     C                   ENDIF
     C                   ENDIF
      *
      * Narrative field
      *
     C                   MOVEL     DDPNTV        PRPNTV
      *
      * Value date field
      *
     C     DDPVDT        IFNE      *BLANKS
      * Check valid date
     C                   MOVE      DDPVDT        DATEN             6 0
     C                   MOVE      DATEN         DATEA             6
      **
      ** Valid date format
      **      Test if date is numeric
      **
     C                   TESTN                   DATEA                9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZDATE1'
     C                   PARM                    DATEA
     C                   PARM      *ZEROS        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPVDT'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0816'
     C                   EVAL      DDVDTOK   = 'N'
     C                   ELSE
      **
      **  Check date is not prior to Back Value Period
      **
     C*****AGRDNB        SUB       BVBVP         WBKVP             6 0                        CSC011
     C     WRunday       SUB       BVBVP         WBKVP             6 0                        CSC011
     C     ZDAYNO        IFLT      WBKVP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPVDT'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0817'
     C                   EVAL      DDVDTOK   = 'N'
     C                   ENDIF
      **
      **   Check not after run date
      **
     C*****ZDAYNO        IFGT      AGRDNB                                                     CSC011
     C     ZDAYNO        IFGT      WRunday                                                    CSC011
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPVDT'
     C                   EVAL      MsgIDArr(Idx) = 'MMA0818'
     C                   EVAL      DDVDTOK   = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        PRPVDT
     C                   ENDIF
      * Default to run date
     C                   ELSE
     C**********         Z-ADD     AGRDNB        PRPVDT                                       CSC011
     C                   Z-ADD     WRunday       PRPVDT                                       CSC011
     C                   ENDIF
      *
      * Update error info with that produced by this subroutine.
      *
      *
     C                   IF        DDPPRT <> 'V' AND                                          189506
     C                             BVEXOP <> 'Y'                                              189506
                                                                                              189506
     C                   IF        DDAPND <> *BLANKS                                          189506
     C                   MOVE      'N'           DDAPNDOk                                     189506
     C                   ADD       1             Idx                                          189506
     C                   EVAL      FldNameArr(Idx) = 'DDAPND'                                 189506
     C                   EVAL      MsgIDArr(Idx) = 'MMA1149'                                  189506
     C                   ENDIF                                                                189506
     C                   ENDIF                                                                189506
      *                                                                                       189506
      ** Auto price indicator is mandatory and must be 'Y' or 'N'.                            189506
      *                                                                                       189506
     C                   IF        DDPPRT =  'V' AND                                          189506
     C                             BVEXOP =  'Y'                                              189506
     C                   IF        DDAPND =   *BLANK OR                                       189506
     C                             DDAPND <>    'Y'  AND                                      189506
     C                             DDAPND <>    'N'                                           189506
     C                   MOVE      'N'           DDAPNDOk                                     189506
     C                   ADD       1             Idx                                          189506
     C                   EVAL      FldNameArr(Idx) = 'DDAPND'                                 189506
      * Error 203  Entry invalid.  Either 'Y' or 'N' must be entered.                         189506
     C                   EVAL      MsgIDArr(Idx) = 'MMA1133'                                  189506
     C                   ELSE                                                                 189506
     C                   MOVE      DDAPND        JEXAP             1                          189506
     C                   ENDIF                                                                189506
     C                   ENDIF                                                                189506
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', validate Credit Risk Spread and Liquidity                         CAS006
      ** Premium fields if non-blank.                                                         CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND (DDPPRT = 'V'                             CAS006
     C                             OR DDPPRT = 'DT' OR DDPPRT = 'DV')                         CAS006
                                                                                              CAS006
     C                   EXSR      SrCRSK                                                     CAS006
                                                                                              CAS006
     C                   EXSR      SrLQPR                                                     CAS006
                                                                                              CAS006
     C                   IF        DDCRSKOK <>'N' AND DDLQPROK <>'N'                          CAS006
     C                             AND DDPRCOK <>'N'                                          CAS006
     C                   EXSR      SrNTPrice                                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIDArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIDArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * INIT - Inital Processing                                      *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      * IN the dtaarea RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   IF        CSC011 = 'Y' AND S1SUPP = LIBR                             CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      WRunday = AGRDNB                                           CSC011
     C                   ENDIF                                                                CSC011
 
      * Access Installation Control Data record fo Securities Trading
      * (Database error handling done in access program).
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
     C     SETUPVALID    BEGSR
      *
      * Set up valid Price record fields.
      *
     C                   IF        CAP060F= 'N'                                               CAP060
     C                   EVAL      PRRECI = 'D'
     C                   EVAL      PRPSSN = DDPSSN
 
     C                   EVAL      PRPPRT = DDPPRT
 
     C                   EVAL      PRPCNM = DDPCNM                                         AR1092524
     C                   EVAL      PRPMKT = DDPMKT                                         AR1092524
     C                   EVAL      PRPBRA = DDPBRA                                         AR1092524
     C                   EVAL      PRPBOK = DDPBOK                                         AR1092524
     C**********         EVAL      PRPCNM = *ZERO                                             CSD027
     C**********         EVAL      PRPCNM = *BLANKS                                 CSD027 AR1092524
     C**********         EVAL      PRPMKT = ' '                                            AR1092524
     C**********         EVAL      PRPBRA = *BLANKS                                        AR1092524
     C**********         EVAL      PRPBOK = *BLANKS                                        AR1092524
     C                   EVAL      PRPPRC = JPPRC
     C                   EVAL      PRLCD = *ZERO
     C                   EVAL      PRCHTP = *BLANKS
     C                   EVAL      PRTNLU = *ZERO
     C                   EVAL      PRPTFR = *BLANKS
     C                   EVAL      PRNPXR = *ZERO
     C                   EVAL      PRNPMD = *BLANKS
      *
      * Set up valid Price record fields, Extra Data file
      *
     C                   EVAL      XTVRECI = 'D'
     C                   EVAL      XTVSESN = DDPSSN
     C                   EVAL      XTVPVDT = PRPVDT
 
     C     JLPBD         IFNE      0
     C                   EVAL      XTVUPBD = JUPBD
     C                   EVAL      XTVLPBD = JLPBD
     C                   EVAL      XTVPMOV = JPMOV
     C                   ELSE
     C                   EVAL      XTVUPBD = *ZERO
     C                   EVAL      XTVLPBD = *ZERO
     C                   EVAL      XTVPMOV = *ZERO
     C                   ENDIF
      *  initialise fields                                                                    CAP060
     C                   EVAL      XTVEXAP = JEXAP                                            189506
     C                   EVAL      XTVLCD = BJRDNB                                            189506
     C                   EVAL      XTVCHTP = DDACTN                                           189506
     C                   EVAL      XTVTNLU = *ZERO                                            CAP060
     C                   ENDIF                                                                CAP060
 
     C                   IF        CAP060F= 'Y'                                               CAP060
      * Record Id                                                                             CAP060
     C                   EVAL      PRRECI = 'D'                                               CAP060
      * Security Shortname                                                                    CAP060
     C                   EVAL      PRPSSN = DDPSSN                                            CAP060
      * Price Type                                                                            CAP060
     C                   EVAL      PRPPRT = DDPPRT                                            CAP060
      * Value Date - returned from module                                                     CAP060
      * Market                                                                                CAP060
     C                   EVAL      PRPMKT = DDPMKT                                            CAP060
      * Branch                                                                                CAP060
     C                   EVAL      PRPBRA = DDPBRA                                            CAP060
                                                                                              CAP060
      * Price - returned from module                                                          CAP060
      * Narrative                                                                             CAP060
     C                   EVAL      PRPNTV = DDPNTV                                            CAP060
      * Last change date ( = run date)                                                        CAP060
     C                   EVAL      PRLCD = AGRDNB                                             CAP060
      * Type of last change                                                                   CAP060
     C                   EVAL      PRCHTP= DDACTN                                             CAP060
      * Transact.no of last update                                                            CAP060
     C                   Reset                   ReturnCode                                   CAP060
     C                   CALLB     'ZTNLU1'                                                   CAP060
     C                   PARM                    ReturnCode                                   CAP060
     C                   PARM                    PRTNLU                                       CAP060
      * Price Source                                                                          CAP060
                                                                                              CAP060
     C                   EVAL      PRPSRC = DDPSRC                                            CAP060
                                                                                              CAP060
      * EXTEL Price boundaries warning indicator - comes back from module                     CAP060
      * EXTEL Price percentage allowable movement warning - comes back from module            CAP060
      * Portfolio reference                                                                   CAP060
     C                   EVAL      PRPTFR = DDPTFR                                            CAP060
      * Profit Centre                                                                         CAP060
     C                   EVAL      PRPRFC = DDPRFC                                            CAP060
      * Lower Price - retrieved from module                                                   CAP060
      * Upper Price - retrieved from module                                                   CAP060
      * Percentage  - retrieved from module                                                   CAP060
      * Data feed timestamp                                                                   CAP060
     C                   EVAL      PRDFTS = JDFTS                                             CAP060
      * PRCS Data Feed Request Identifier                                                     CAP060
     C                   EVAL      PRDTFR = DDDTFR                                            CAP060
      * PRCS Rate Tolerance Exceeded - returned from module                                   CAP060
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                               CAP060
      ** If price type is 'V ' (current price), then validate fields                          CAP060
      **   for update of PF/EXVALD.                                                           CAP060
 
     C                   IF        DDPPRT = 'V' AND BVEXOP = 'Y'                              CAP060
     C                   EVAL      PRPSRC = 'S'                                               CAP060
     C                   EVAL      EXVRECI = 'D'                                              CAP060
     C                   EVAL      EXVSESN = DDPSSN                                           CAP060
     C                   EVAL      EXVA1P = 0                                                 CAP060
     C                   EVAL      EXVLCD = AGRDNB                                            CAP060
     C                   EVAL      EXVCHTP = DDACTN                                           CAP060
     C                   EVAL      EXVTNLU = PRTNLU                                           CAP060
     C                   EVAL      EXVUPBD = PRUPRI                                           CAP060
     C                   EVAL      EXVLPBD = PRLPRI                                           CAP060
     C                   EVAL      EXVPMOV = PRPCEN                                           CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Prices information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Prices layout (DS) from/to caller
     C                   PARM                    ValidPRCS
     C                   PARM                    ValidEXTL                                    CAP060
     C                   PARM                    ValidPRXT
      * Price in file format
     C                   PARM                    HPPRC                                        CAP060
      * CAC005 switchable feature on (Y / N)                                                  CAP060
     C                   PARM                    CAC005            1                          CAP060
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SEPRCSVAL'   DBPGM
     C                   OUT       LDA
      *
      * Access Bank details via access program
      * (database error handling done in access program).
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *  Set up the name of the MSGF from which the message handler will
      *  obtain the messages.
      *
      *
      ** Access SAR details file to determine if CAP060                                       CAP060
      ** (Market Data Feed) is on.                                                            CAP060
      *                                                                                       CAP060
     C                   CALLB     'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAP060'      @SARD                                        CAP060
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP060
     C     @RTCD         IFNE      *BLANKS                                                    CAP060
     C     @RTCD         ANDNE     '*NRF   '                                                  CAP060
     C     *LOCK         IN        LDA                                          ************* CAP060
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 002 CAP060
     C                   MOVEL     '002'         DBASE                          ************* CAP060
     C                   MOVEL     'CAP060'      DBKEY                                        CAP060
     C                   OUT       LDA                                                        CAP060
     C                   SETON                                        U7U8LR                  CAP060
     C                   EXSR      SRERR                                                      CAP060
     C                   END                                                                  CAP060
 
     C     @RTCD         IFEQ      *BLANK                                                     CAP060
     C                   MOVEL     'Y'           CAP060F           1                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     'N'           CAP060F                                      CAP060
     C                   END                                                                  CAP060
      *
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD                                        CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
     C     @RTCD         IFNE      *BLANKS                                                    CSD006
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD006
     C     *LOCK         IN        LDA                                          ************* CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 003 CSD006
     C                   MOVEL     '003'         DBASE                          ************* CSD006
     C                   MOVEL     'CSD006'      DBKEY                                        CSD006
     C                   OUT       LDA                                                        CSD006
     C                   SETON                                        U7U8LR                  CSD006
     C                   EXSR      SRERR                                                      CSD006
     C                   END                                                                  CSD006
 
     C     @RTCD         IFEQ      *BLANK                                                     CSD006
     C                   MOVEL     'Y'           CSD006F           1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CSD006F                                      CSD006
     C                   END                                                                  CSD006
      *
      ** Access Market Data Feed if switchable CSD006 is installed.                           CSD006
                                                                                              CSD006
     C                   IF        CSD006F= 'Y'                                               CSD006
     C                   CALLB     'AOMDFCR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*FIRST '     @OPTN                                        CSD006
     C     SDMDFC        PARM      SDMDFC        DSSDY                                        CSD006
                                                                                              CSD006
     C                   IF        @RTCD <> *Blanks                                           CSD006
     C                   MOVEL     'SDMDFCPD'    DBFILE                                       CSD006
     C                   MOVEL     '080'         DBASE                                        CSD006
     C                   MOVEL     @OPTN         DBKEY                                        CSD006
     C                   EXSR      *PSSR                                                      CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
 
     C                   IF        CAP060F='Y'                                                CAP060
     C                   CALL      'AOMMODR0'                                                 CAP060
     C                   PARM      '*DBERR '     @RTCD                                        CAP060
     C                   PARM      '*FIRST '     @OPTN                                        CAP060
     C     SDMOD         PARM      SDMOD         DSFDY                                        CAP060
      *                                                                                       CAP060
     C** Portfolio Management Module                                                          CAP060
     C*                                                                                       CAP060
     C     BGPFMG        IFEQ      'Y'                                                        CAP060
     C                   CALL      'AOPORTR0'                                                 CAP060
     C                   PARM      *BLANKS       P@RTCD            7                          CAP060
     C                   PARM      '*FIRST '     P@OPTN            7                          CAP060
     C     SDPORT        PARM      SDPORT        DSFDY                                        CAP060
     C*                                                                                       CAP060
     C     P@RTCD        IFNE      *BLANKS                                                    CAP060
     C     *LOCK         IN        LDA                                                        CAP060
     C                   Z-ADD     1             DBASE                          **************CAP060
     C                   MOVEL     'SDPORTL0'    DBFILE                         * DB ERROR 01 CAP060
     C                   MOVEL     *BLANKS       DBKEY                          **************CAP060
     C                   SETON                                        U7U8                    CAP060
     C                   OUT       LDA                                                        CAP060
     C                   EXSR      SRERR                                                      CAP060
     C                   RETURN                                                               CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C                                                                                        CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 4                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Access switchable features file - Collateralised Lending (CSD010)                    CSD010
                                                                                              CSD010
     C                   CALLB     'AOSARDR0'                                                 CSD010
     C                   PARM      *BLANKS       PRtCd                                        CSD010
     C                   PARM      '*VERIFY'     POptn                                        CSD010
     C                   PARM      'CSD010'      PSard                                        CSD010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD010
                                                                                              CSD010
     C                   IF        PRtCd <> *BLANKS AND                                       CSD010
     C                             PRtCd <> '*NRF   '                                         CSD010
     C                   EVAL      DBASE = 5                                                  CSD010
     C                   EVAL      DBKEY = 'CSD010'                                           CSD010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD010
     C                   EXSR      *PSSR                                                      CSD010
     C                   ENDIF                                                                CSD010
     C                                                                                        CSD010
     C                   IF        PRtCd = *BLANKS                                            CSD010
     C                   EVAL      CSD010 = 'Y'                                               CSD010
     C                   ELSE                                                                 CSD010
     C                   EVAL      CSD010 = 'N'                                               CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CSD010
      ** Access switchable features file - Hedge Accounting Phase B (CAS006)                  CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtCd                                        CAS006
     C                   PARM      '*VERIFY'     POptn                                        CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRtCd <> *BLANKS AND                                       CAS006
     C                             PRtCd <> '*NRF   '                                         CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBASE = 006                                                CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBMOD = 'SEPRCSVAL'                                        CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRtCd = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      #MsgFile = 'DRSMM'
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEPRCSV004
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAP060
      *                                                               *                       CAP060
      * SRERR - EXCEPTION ERRORS                                      *                       CAP060
      *                                                               *                       CAP060
      *****************************************************************                       CAP060
     C     SRERR         BEGSR                                                                CAP060
      *                                                                                       CAP060
     C                   MOVEL     'SEPRCSVAL'   DBPGM                                        CAP060
     C                   MOVE      '1'           *INU7                                        CAP060
     C                   MOVE      '1'           *INU8                                        CAP060
     C                   MOVE      '1'           *INLR                                        CAP060
     C                   DUMP                                                                 CAP060
      *                                                                                       CAP060
      **  Terminte the program                                                                CAP060
      *                                                                                       CAP060
     C                   RETURN                                                               CAP060
      *                                                                                       CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
