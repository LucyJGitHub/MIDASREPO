     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Dealing Fees validation')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLFEVAL -  Dealing Fees Validation                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12892           Date 14Dec06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG12892 - For CI deals, customer number entered should be   *
      *             compared with current holder of neg. assets.      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(75)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Flags to indicate whether transaction fields are valid
     D OKDlfe        E DS                  EXTNAME(DLEDLFEPD)
 
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      ** External DS for Fee Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **   CUSTOMER
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **   CURRENCY TYPE
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG12892
                                                                                            BUG12892
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * First DS for Access programs - Long data structure
 
     D ValidDlfe     E DS                  EXTNAME(DLVDLFEPD)
 
     D TranInPrim    E DS                  EXTNAME(DLDLFEPD)
      * Incoming Transaction
 
     D DealsDtlC     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(C_)
     D DealsDtlD     E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(D_)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
      * ZMUSER data layout
     D  DBRN                  11     13
 
     D                 DS
     D  WF3TDS                 1      8
     D  WF3DD                  1      2
     D  WF3MM                  3      4
     D  WF3CC                  5      6
     D  WF3YY                  7      8
      *
     D                 DS
      ** Data structure to set work amounts
     D  WFAMT                  1     13  0
     D  DDMMYY                14     19  0
     D  WFAC3                 20     22  0
     D  WA13                  23     35  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D Ix              S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
     D PMsgId          S              7A
     D WWCNUM          S              6A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A
     D I               S              3  0
 
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
      *
      ** Call Validation Modules in Sequence
      *
      ** Customer
      ** ========
      *
     C                   EXSR      ValCust
      *
      *
      ** Fee Code
      ** ========
      *
     C                   EXSR      ValFcod
      *
      ** Fee Currency
      ** ============
      *
     C                   EXSR      ValFccy
      *
      ** Fee Amount and sign
      ** ===================
      *
     C                   IF        OKFCCY <> 'N'
     C                   EXSR      ValFamtSgn
     C                   ENDIF
      *
      ** Validate Start Date
      ** ===================
      *
     C                   EXSR      ValSdat
      *
      ** Validate End Date
      ** =================
      *
     C                   EXSR      ValEdat
      *
      ** Validate Payment On Indicator
      ** =============================
      *
     C                   EXSR      ValFind
      *
      ** Validate Next Payment Date
      ** ==========================
      *
     C                   EXSR      ValNpyd
      *
      ** Validate Frequency Code
      ** =======================
      *
     C                   EXSR      ValFreq
      *
      ** Validate Day In Month
      ** =====================
      *
     C                   EXSR      ValPday
 
      *
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALCUST - Validate Customer                                  *
      *****************************************************************
     C     VALCUST       BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   IF        DDCUST = *BLANKS
     C                   EVAL      OKCUST = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDCUST'
     C                   EVAL      MsgIDXAr(Ix) = 'DLF0030'
     C                   ELSE
     C                   MOVEL(P)  DDCUST        PKEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      OKCUST = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDCUST'
     C                   EVAL      MsgIDXAr(Ix) = 'DLF0007'
     C                   ELSE
     C*****C_CNUM        IFEQ      *ZERO                                                      CSD027
     C     C_CNUM        IFEQ      *BLANKS                                                    CSD027
     C                   MOVEL     D_ISCN        WWCNUM
     C                   ELSE
     C                   IF        C_DTYP = 'CI' OR                                         BUG12892
     C                             (C_DTYP = 'CF' AND CDL033 = 'Y')                         BUG12892
     C                   MOVEL     C_CHNA        WWCNUM                                     BUG12892
     C                   ELSE                                                               BUG12892
     C                   MOVEL     C_CNUM        WWCNUM
     C                   ENDIF                                                              BUG12892
                                                                                            BUG12892
     C                   ENDIF
     C                   IF        BBCUST <> WWCNUM  AND OKDLNO = 'Y'
     C                   EVAL      OKCUST = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDCUST'
     C                   EVAL      MsgIDXAr(Ix) = 'DLF0035'
     C                   ELSE
     C                   EVAL      DDCUST = BBCUST
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALFCOD - Validate Fee code                                  *
      *****************************************************************
     C     VALFCOD       BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'DLVFCODE'
      ** Return Code Error Indicator
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Fee Code
 
     C                   PARM                    DDFCOD
     C                   PARM                    DealsDtlC
     C                   PARM                    DealsDtlD
 
      ** OUTPUT
      ** -------------------
 
      ** Array of Fields in error.
     C                   PARM                    FldNamXAr
      ** Array of error message IDs
     C                   PARM                    MsgIDXAr
      ** Array of error message data.
     C                   PARM                    MsgDtaXAr
 
      ** Fee Code Ok Indicator
      ** Adjustment to Yield
     C                   PARM                    OKFCOD
     C                   PARM                    DLADJY
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALFCCY - Validate Currency                                  *
      *****************************************************************
     C     VALFCCY       BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   EVAL      OKFCCY = 'Y'
 
     C                   CALLB     'ZAVCURCODE'
      ** Return Code Error Indicator
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PMsgId
     C                   PARM                    DDFCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      OKFCCY = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDFCCY'
     C                   EVAL      MsgIDXAr(Ix) = PMsgId
     C                   ENDIF
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALFAMTSGN - Validate Fee amount                             *
      *****************************************************************
     C     VALFAMTSGN    BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'DLVFAMNT'
      ** Return Code Error Indicator
 
     C                   PARM                    ReturnCode
 
      ** Fee Amount
     C                   PARM                    DDFAMT
      ** Fee Amount Sign
     C                   PARM                    DDFSGN
      ** Currency Number of Decimal Places
     C                   PARM                    A6NBDP
 
      ** OUTPUT
      ** ------
 
      ** Array of Fields in error.
     C                   PARM                    FldNamXAr
      ** Array of error message IDs
     C                   PARM                    MsgIDXAr
      ** Array of error message data.
     C                   PARM                    MsgDtaXAr
      ** Fee Amount Ok Indicator
     C                   PARM                    OKFAMT
      ** Fee Amount Sign Ok Indicator
     C                   PARM                    OKFSGN
     ** Work Amount
     C                   PARM                    DLFAMT
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALSDAT - Validate Fee Start Date                            *
      *****************************************************************
     C     VALSDAT       BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'DLVFSDAT'
      ** Return Code Error Indicator
 
     C                   PARM                    ReturnCode
 
      ** Received Parameters
      ** -------------------
 
      ** Start Date
      ** Date Format Indicator
      ** Rundate
      ** Deal Number
 
     C                   PARM                    DDSDAT
     C                   PARM                    BJDFIN
     C                   PARM                    DDFIND
     C                   PARM                    DDDLNO
     C                   PARM                    DDFCOD
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Start Date day number format
      ** Start Date Ok Indicator
 
     C                   PARM                    DLPSTD
     C                   PARM                    OKSDAT
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALEDAT - Validate Fee End Date                              *
      *****************************************************************
     C     VALEDAT       BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'DLVFEDAT'
      ** Return Code Error Indicator
 
     C                   PARM                    ReturnCode
 
      ** Received Parameters
      ** -------------------
 
      ** End Date
      ** Date Format Indicator
      ** Payment On Indicator
      ** Deal Number
      ** Fee Code
 
     C                   PARM                    DDEDAT
     C                   PARM                    BJDFIN
     C                   PARM                    DDFIND
     C                   PARM                    DDDLNO
     C                   PARM                    DDFCOD
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Start Date day number format
      ** Start Date Ok Indicator
 
     C                   PARM                    DLPEND
     C                   PARM                    OKEDAT
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALFIND - Validate Fee Payment on indicator                  *
      *****************************************************************
     C     VALFIND       BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'DLVFEIND'
      ** Return Code Error Indicator
 
     C                   PARM                    ReturnCode
 
      ** INPUT
      ** -----
 
      ** Fee Payment On Indicator
     C                   PARM                    DDFIND
      ** End Date
     C                   PARM                    DDEDAT
 
      ** OUTPUT
      ** ------
 
      ** Array of Fields in error.
     C                   PARM                    FldNamXAr
      ** Array of error message IDs
     C                   PARM                    MsgIDXAr
      ** Array of error message data.
     C                   PARM                    MsgDtaXAr
      ** 'Fee Payment On Indicator' Ok Indicator
     C                   PARM                    OKFIND
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALNPYD - Validate Next Payment Date                         *
      *****************************************************************
     C     VALNPYD       BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'DLVNXPY'
      ** Return Code Error Indicator
 
     C                   PARM                    ReturnCode
 
      ** Received Parameters
      ** -------------------
 
      ** Next Payment Date
      ** Start Date
      ** End Date
      ** Date Format Indicator
      ** Payment On Indicator
 
     C                   PARM                    DDNPYD
     C                   PARM                    DLPSTD
     C                   PARM                    DLPEND
     C                   PARM                    BJDFIN
     C                   PARM                    DDFIND
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Start Date day number format
      ** Start Date Ok Indicator
 
     C                   PARM                    DLNPYD
     C                   PARM                    OKNPYD
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALFREQ - Validate Payment Frequency                         *
      *****************************************************************
     C     VALFREQ       BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'DLVPFRQ'
      ** Return Code Error Indicator
 
     C                   PARM                    ReturnCode
 
      ** Received Parameters
      ** -------------------
 
      ** Fee Payment On Indicator
      ** End Date
 
     C                   PARM                    DDFREQ
     C                   PARM                    DDNPYD
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** 'Fee Payment On Indicator' Ok Indicator
 
     C                   PARM                    OKFREQ
 
     C                   EXSR      UPDATERRS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  VALPDAY - Validate Payment Day in Month                      *
      *****************************************************************
     C     VALPDAY       BEGSR
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'DLVPDAY'
      ** Return Code Error Indicator
 
     C                   PARM                    ReturnCode
      ** Received Parameters
      ** -------------------
 
      ** Fee Payment On Indicator
      ** End Date
 
     C                   PARM                    DDPDAY
     C                   PARM                    DDFREQ
     C                   PARM                    DDNPYD
     C                   PARM                    DDEDAT
     C                   PARM                    DDFCCY
     C                   PARM                    DLPEND
     C                   PARM                    DLNPYD
     C                   PARM                    OKNPYD
     C                   PARM                    OKEDAT
     C                   PARM                    OKFCCY
     C                   PARM                    BJDFIN
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** 'Fee Payment On Indicator' Ok Indicator
 
     C                   PARM                    OKPDAY
     C                   PARM                    DLDYIM
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SETUPVALID - Set up Valid file                               *
      *****************************************************************
     C     SETUPVALID    BEGSR
      *
      * Fields from DLVDLFEPD File
     C                   IF        DDACTN <> 'X'
     C                   EVAL      DLLCDT = DDACTN
     C                   ENDIF
     C                   IF        C_BRCA <> *BLANK
     C                   EVAL      DLBRCA = C_BRCA
     C                   ELSE
     C                   EVAL      DLBRCA = D_BRCA
     C                   ENDIF
 
     C                   MOVEL     DDDLNO        DLDLNO
     C                   MOVEL     DDFSEQ        DLFSEQ
     C                   MOVEL     DDCUST        DLCUST
     C                   MOVEL     DDFCOD        DLFCOD
     C                   EVAL      DLFCCY = DDFCCY
     C                   EVAL      DLPYON = DDFIND
     C                   EVAL      DLFREQ = DDFREQ
 
     C     C_RCDT        IFEQ      'C'
     C                   EVAL      DLDTYP = C_DTYP
     C                   EVAL      DLSTYP = C_DLST
     C                   ELSE
     C                   EVAL      DLDTYP = D_DTYP
     C                   EVAL      DLSTYP = D_DLST
     C                   ENDIF
 
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C                   EVAL      DLRECI = 'D'
     C     DDACTN        WHENEQ    'D'
     C                   EVAL      DLRECI = 'R'
     C                   ENDSL
 
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
      ** Transaction Details
     C                   PARM                    TranInPrim
 
      * OUTPUTS
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKDlfe
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Fee layout (DS) from/to caller
     C                   PARM                    ValidDlfe
      * Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC
      * Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD
      *
      **  GET ZMUSER to access default branch.
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      **  Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     'DLDLFEVAL'   DBPGM
     C                   OUT       LDA
      *
      ** Define work field
     C     *LIKE         DEFINE    A6NBDP        W#NBDP
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN96                          MMDDYY
     C                   ENDIF
                                                                                            BUG12892
      ** Access SAR details file to determine if CDL033 is switch on                        BUG12892
                                                                                            BUG12892
     C                   MOVEL     'N'           CDL033            1                        BUG12892
     C                   CALL      'AOSARDR0'                                               BUG12892
     C                   PARM      *BLANKS       @RTCD                                      BUG12892
     C                   PARM      '*VERIFY'     @OPTN                                      BUG12892
     C                   PARM      'CDL033'      @SARD                                      BUG12892
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG12892
                                                                                            BUG12892
     C     @RTCD         IFEQ      *BLANK                                                   BUG12892
     C                   MOVEL     'Y'           CDL033                                     BUG12892
     C                   ELSE                                                               BUG12892
      ** Database Error, if Return Code is not blanks or *NRF                               BUG12892
     C     @RTCD         IFNE      '*NRF'                                                   BUG12892
     C                   MOVEL     'SCSARDPD'    DBFILE                                     BUG12892
     C                   MOVEL     '002'         DBASE                                      BUG12892
     C                   MOVEL     'CDL033'      DBKEY                                      BUG12892
     C                   EXSR      *PSSR                                                    BUG12892
     C                   ENDIF                                                              BUG12892
     C                   ENDIF                                                              BUG12892
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RESETERRS - Reset error information that is received back    *
      *    from each validation module.                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
     C                   EVAL      Ix = *ZERO
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  UPDATERRS - Update error information with that received back *
      *    from each validation module.                               *
      *****************************************************************
 
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
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
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
