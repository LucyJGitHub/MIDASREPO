     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Exchange-traded contracts validation')        *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFEXTRVAL - Validation controller for exchange-traded        *
      *              futures and options.                             *
      *                                                               *
      *  Function:  This module controls the transaction validation   *
      *             for exchange-traded futures and options.          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243913             Date 03Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG1034            Date 06Feb06               *
      *                 BUG6979            Date 04May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 208635             Date 16Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002             Date 14Jan02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 06Sep99               *
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  243913 - Fix for BUG10345 did not take in account Private    *
      *           Banking module.                                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10345 - PMC1140 DBASE ERROR 11, PM1142 ,PF/ SDPLCSPD      *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208635 - Allow broker if S01457 is installed.                *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CPB001 - 'Private Banking' Module                            *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface                               *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - APIs Phase 3.                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Field names/numbers table
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFEXTRV001
 
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
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for FF-specific
      ** variables.
     D/COPY FFCPYSRC,DECLAREVAR
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
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  LookupSucc            98     98
      ** ¦                                                                ¦
     D  NoRecFound            99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     D TranIn        E DS                  EXTNAME(FFEXTRPD)
      ** Incoming transaction structure
 
     D ValidTran     E DS                  EXTNAME(FFVTRANPD)
      ** Valid transaction layout
 
     D OKFlagsDS     E DS                  EXTNAME(FFEEXTRPD)
      ** The OK flags for the transaction
 
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
      ** Instrument types
 
     D MarketCont    E DS                  EXTNAME(MKCTLD) PREFIX(MC)
      ** Market control details (MC=Market Control)
 
     D MarketDet     E DS                  EXTNAME(MARKT) PREFIX(MK)
      ** Market details DS (MK=MarKet)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details ICD
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** Deakub ICD (needed for decimal separator field)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD) PREFIX(T)                        CFF007
      ** Customer Details                                                                     CFF007
                                                                                              CFF007
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  #ACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ** General Ledger ICD
 
     D CustomerDS    E DS                  EXTNAME(SDCUSTPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** Customer record format
 
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for Access Programs
 
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CFF007
      ** Very Long data structure for Access Programs                                         CFF007
                                                                                              CFF007
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio Management ICD
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas modules flags
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  #ACCD2       E                     EXTFLD(QQACCD)                                     CGL029
      ** Futures and Options ICD
 
     D ZMUSER        E DS            17    DTAARA(ZMUSER) EXTNAME(ZMUSER)
      ** ZMUSER data area layout
 
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(FFETEXPD)                    CAP004
      * FF Extension data (Exchange Traded) - File (D/B) format                 CAP004
                                                                                              CSC011
      ** Externally described DS for SAR details                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D    SARLCD     E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** 13,0S and 1,0S field for passing to FFVSTRKPR
     D Zero13S         S             13S 0 INZ(0)
     D Zero1S          S              1S 0 INZ(0)
 
      ** The current trading date
     D CTDATE          S                   LIKE(BJRDNB)
 
      ** The start of the historical data period
     D STHDP           S                   LIKE(BJRDNB)
 
      ** Flag to indicate that no broker was entered (so customer is
      ** mandatory)
     D NoBroker        S              1A
 
      ** Transaction type and subtype: dummy fields for passing to
      ** profit center validation.
     D Type2A          S              2A
     D SubType         S              2A
 
      ** Generic OK flag
     D GenOKFlag       S              1A   INZ('Y')
 
      ** General-purpose array index
     D GI              S              3P 0 INZ(1)
 
      ** Error array index
     D Idx             S              3P 0
 
      ** Response mode
     D RespMode        S              1A
 
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - broker                                                       CFF007
     D PPBBFLG         S              1A                                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     D PPBCFLG         S              1A                                                      CFF007
 
     D PRTCD           S              7                                                       CFF007
     D POPTN           S              7                                                       CFF007
     D PKEY1           S             10                                                       CFF007
     D PKYST           S              7                                                       CFF007
                                                                                              CSC011
      ** Define variable for switchable CSC011.                                               CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
                                                                                              CSC011
      ** Define parameters for AOSARDR0                                                       CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
      ** Portfolio Customer Indicator                                                       BUG10345
     D WPLCS           S              1A                                                    BUG10345
                                                                                            BUG10345
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFEXTRV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
                                                                                             BUG6979
      ** Get default branch from ZMUSER                                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
     C                   UNLOCK    ZMUSER                                                    BUG6979
 
      ** Reset the fields specific to the VAL function
      ** ---------------------------------------------
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
 
      /COPY WNCPYSRC,FFEXTRV003
 
      ** Call Validation Modules in Sequence
      ** -----------------------------------
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Purchase or sale flag                    |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVPSALIN'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Purchase or sale indicator (1A, from transaction)
     C                   PARM                    STRTY
 
      /COPY WNCPYSRC,FFEXTRV004
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKTRTY = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV005
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Number of contracts                      |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVNOCONT'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Number of contracts (5A, from transaction)
     C                   PARM                    SNUCO
 
      /COPY WNCPYSRC,FFEXTRV006
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKNUCO = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV007
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Market                                   |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVMARKET'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** Market control details (data structure)
     C                   PARM                    MarketCont
      ** Market centre details (data structure)
     C                   PARM                    MarketDet
 
      ** Inputs to called procedure
      ** --------------------------
      ** Market centre (2A, from transaction)
     C                   PARM                    SMRKT
      ** Action code (1A, from transaction)
     C                   PARM                    SACTN
 
      /COPY WNCPYSRC,FFEXTRV008
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKMRKT = GenOKFlag
 
      ** If market validated successfully we can use data returned
      ** by the above procedure to determine the current trading date
      ** and historical data period, which are used by later validation
      ** modules.
     C                   IF        ReturnCode = *blanks
     C                   EXSR      GetCTDate
     C                   EXSR      GetHistPer
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRV009
 
      ** -------------------------------------------------------------------------------------------
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Instrument                               |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVMKTINS'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** The instrument types format (data strucure)
     C                   PARM                    InstTypes
 
      ** Inputs to called procedure
      ** --------------------------
      ** Instrument type (3A, from transaction
     C                   PARM                    SISTC
      ** Market I.D. (2A, from transaction)
     C                   PARM                    SMRKT
 
      /COPY WNCPYSRC,FFEXTRV010
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKISTC = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV011
 
      ** Fields for Private Banking                                                           CFF007
                                                                                              CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     BGN4ST        ANDEQ     'Y'                                                        CFF007
                                                                                              CFF007
      ** Reset variables updated by each module before each call                              CFF007
     C                   EXSR      ResetErrs                                                  CFF007
                                                                                              CFF007
      ** Covered Validation                                                                   CFF007
     C                   CALLB     'FFVCXPN01'                                                CFF007
     C                   PARM                    ReturnCode                                   CFF007
     C                   PARM                    SCOVE                                        CFF007
     C                   PARM                    MsgIDXArr                                    CFF007
     C                   PARM                    FldNamXArr                                   CFF007
                                                                                              CFF007
      ** Do the return code and error details handling                                        CFF007
     C                   EXSR      HandleRet                                                  CFF007
     C                   EVAL      OKCOVE = GenOKFlag                                         CFF007
                                                                                              CFF007
      ** Reset variables updated by each module before each call                              CFF007
     C                   EXSR      ResetErrs                                                  CFF007
                                                                                              CFF007
      ** Hedged/Traded Validation                                                             CFF007
     C                   CALLB     'FFVHGTR01'                                                CFF007
     C                   PARM                    ReturnCode                                   CFF007
     C                   PARM                    SHETR                                        CFF007
     C                   PARM                    SCOVE                                        CFF007
     C                   PARM                    MsgIDXArr                                    CFF007
     C                   PARM                    FldNamXArr                                   CFF007
                                                                                              CFF007
      ** Do the return code and error details handling                                        CFF007
     C                   EXSR      HandleRet                                                  CFF007
     C                   EVAL      OKHETR = GenOKFlag                                         CFF007
                                                                                              CFF007
      ** Reset variables updated by each module before each call                              CFF007
     C                   EXSR      ResetErrs                                                  CFF007
                                                                                              CFF007
      ** Block Underlying Position Validation                                                 CFF007
     C                   CALLB     'FFVBOUL01'                                                CFF007
     C                   PARM                    ReturnCode                                   CFF007
     C                   PARM                    SBLUP                                        CFF007
     C                   PARM                    MsgIDXArr                                    CFF007
     C                   PARM                    FldNamXArr                                   CFF007
                                                                                              CFF007
      ** Do the return code and error details handling                                        CFF007
     C                   EXSR      HandleRet                                                  CFF007
     C                   EVAL      OKBLUP = GenOKFlag                                         CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** +------------------------------------------+-----------------------------------------------
      ** | Month and year                           |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVYRMNTH'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** Numeric (file) version of month number
     C                   PARM                    MTHN
      ** Numeric (file) version of year number
     C                   PARM                    YRNO
 
      ** Input/output
      ** ------------
      ** OK flags
     C                   PARM                    OKFlagsDS
 
      ** Inputs to called procedure
      ** --------------------------
      ** Month number (3A, from transaction)
     C                   PARM                    SMTHN
      ** Year number (2A, from transaction)
     C                   PARM                    SYRNO
      ** Current trading date
     C                   PARM                    CTDATE
      ** Run date format (1A, from SDBANKPD)
     C                   PARM                    BJDFIN
      ** The instrument types format (data strucure)
     C                   PARM                    InstTypes
 
      /COPY WNCPYSRC,FFEXTRV012
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
 
      ** (The two OK flags for the above prodedure are set in the
      ** procedure itself, so GenOKFlag, set by the HandleRet SR, can
      ** be ignored.)
 
      ** Now that both the market and the month are validated, we can
      ** retrieve the market details, which are used by later validation.
     C                   IF        OKISTC <> 'N' AND OKMTHN <> 'N'
     C                   EXSR      GetMarket
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV013
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Put/call indicator                       |
      ** +------------------------------------------+
 
      ** Only validate if instrument was ok, as otherwise ISPT won't be
      ** set up.
     C                   IF        OKISTC <> 'N'
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVPUTCAL'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Put/call indicator (1A, from transaction)
     C                   PARM                    SPCAL
      ** Instrument processing type (1,0S, from INTYPD)
     C                   PARM                    ITISPT
 
      /COPY WNCPYSRC,FFEXTRV014
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKPCAL = GenOKFlag
 
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV015
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Strike price                             |
      ** +------------------------------------------+
 
      ** Only validate if instrument was ok, as otherwise INTYPD fields
      ** won't be set up.
     C                   IF        OKISTC <> 'N'
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVSTRKPR'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** Numeric (file) version of strike price
     C                   PARM                    STRP
 
      ** Inputs to called procedure
      ** --------------------------
      ** Strike price (16A, from transaction)
     C                   PARM                    SSTRP
      ** The INTYPD format (several fields required by calld module)
     C                   PARM                    InstTypes
      ** Market (2A, from transaction)
     C                   PARM                    SMRKT
      ** Counter amount (13,0S, from transaction - not applicable for
      ** exchange-traded transactions)
     C                   PARM                    Zero13S
      ** Delivery amount (13,0S, from transaction - not applicable for
      ** exchange-traded transactions)
     C                   PARM                    Zero13S
      ** Counter currency decimal places (1,0P, from currencies file -
      ** not applicable for exchange-traded transactions)
     C                   PARM                    Zero1S
      ** Delivery currency decimal places (1,0P, from currencies file -
      ** not applicable for exchange-traded transactions)
     C                   PARM                    Zero1S
 
      /COPY WNCPYSRC,FFEXTRV016
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKSTRP = GenOKFlag
 
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV017
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Contract price                           |
      ** +------------------------------------------+
 
      ** Don't do contract price validation if instrument type or
      ** strike price was not valid
     C                   IF        OKISTC <> 'N'
     C                             AND OKSTRP <> 'N'
 
     C/COPY WNCPYSRC,FFEXTRVC01
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVCONTPR'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
      ** Numeric (file) version of price
     C                   PARM                    COPR
 
      ** Inputs to called procedure
      ** --------------------------
      ** Contract price (16A)
     C                   PARM                    SCOPR
      ** Year number (2,0S)
     C                   PARM                    YRNO
      ** Month number (2,0S)
     C                   PARM                    MTHN
      ** Put call indicator
     C                   PARM                    SPCAL
      ** Strike price (15,8P)
     C                   PARM                    STRP
      ** Instrument types (DS, from INTYPD)
     C                   PARM                    InstTypes
      ** OK flags
     C                   PARM                    OKFlagsDS
 
      /COPY WNCPYSRC,FFEXTRV018
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKCOPR = GenOKFlag
 
     C                   ENDIF
      **                 End of "If OKISTC <> 'N'"
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV019
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Broker code                              |
      ** +------------------------------------------+
 
      ** Broker is not amendable (which will be trapped by FFEXTRAMD),
      ** so only validate if action is 'I'; to validate on 'A' can cause
      ** unwanted defaulting.
     C                   IF         SACTN = 'I'
 
      ** Broker is not validated if an asterisk is entered in position 1,
      ** and nothing else.
     C                   IF         NOT(
     C                                  %subst(SBOCO : 1 : 1) = '*'
     C                                  AND %subst(SBOCO : 2 : 9) = *blanks
     C                                 )
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVBROKER'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** Numeric version of broker code (6,0S)
     C                   PARM                    BOCO
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBBFLG                                      CFF007
 
      ** Inputs to called procedure
      ** --------------------------
      ** Broker I.D. (10A, from transaction)
     C                   PARM                    SBOCO
      ** Market Instrument OK flag (1A)
     C                   PARM                    OKISTC
      ** Default Broker I.D. (6,0S, from INTYPD)
     C                   PARM                    ITDBRK
      ** Action Code (1A)                                                                     CSD025
     C                   PARM                    SACTN                                        CSD025
 
      /COPY WNCPYSRC,FFEXTRV020
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKBOCO = GenOKFlag
 
     C                   ENDIF
      **                 (End of IF NOT SBOCO position 1 = '*' and 2-9 blank)
 
     C                   ENDIF
      **                 (End of "If SACTN = 'I'")
 
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     SACTN         ANDEQ     'A'                                                        CFF007
     C                   CALLB     'AOCUSTR1'                                                 CFF007
     C                   PARM      *BLANKS       PRTCD                                        CFF007
     C                   PARM      '*KEY   '     POPTN                                        CFF007
     C                   PARM      SBOCO         PKEY1                                        CFF007
     C                   PARM                    PKYST                                        CFF007
     C     SDCUST        PARM      SDCUST        DSLDY                                        CFF007
                                                                                              CFF007
     C     PRTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVEL     TBBPRBA       PPBBFLG                                      CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV021
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Customer code                            |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
      ** This procedure requires a flag to indicate that no broker was
      ** entered (in which case the customer is mandatory)
     C**********         IF        BOCO = 0                                                   CSD027
     C                   IF        BOCO = *BLANKS                                             CSD027
     C                   EVAL      NoBroker = 'Y'
     C                   ELSE
     C                   EVAL      NoBroker = 'N'
     C                   ENDIF
 
     C                   CALLB     'FFVCUST'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** Numeric version of customer code (6,0S)
     C                   PARM                    CUSC
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBCFLG                                      CFF007
      ** Customer format (from SDCUSTPD
     C                   PARM                    CustomerDS
 
      ** Inputs to called procedure
      ** --------------------------
      ** Customer I.D. (10A, from transaction)
     C                   PARM                    SCUSC
      ** No broker, so customer mandatory
     C                   PARM                    NoBroker
     C                   PARM                    S01457                                       208635
     C                   PARM                    SACTN                                        CSD025
 
      /COPY WNCPYSRC,FFEXTRV022
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKCUSC = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV023
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Book code                                |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVBOOKCD'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Book code (2A, from transaction)
     C                   PARM                    SBOKC
      ** Customer I.D. (10A, from transaction)
     C                   PARM                    SCUSC
      ** Default Trade book (2A, from SDFODAPD)
     C                   PARM                    BXDTBC
      ** Default Customer book (2A, from SDFODAPD)
     C                   PARM                    BXBKCD
 
      /COPY WNCPYSRC,FFEXTRV024
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKBOKC = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV025
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Booking branch                           |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVBKGBRCH'
      ** Return code
     C                   PARM                    ReturnCode
      ** Error message ID
     C                   PARM                    #Msgid
      ** Single branch code from SDBANKPD
     C                   PARM                    BJSBRC
      ** Default branch code from ZMUSER data area
     C                   PARM                    DBRN
      ** Round-down indicator from SDBRCHPD
     C                   PARM                    A8RDFC
      ** Action code from transaction
     C                   PARM                    SACTN
      ** Booking branch from transaction
     C                   PARM                    SBRCD
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode
      ** Returned version of branch code
     C                   PARM                    BRCA
      ** The branch detail format from SDBRCHPD
     C                   PARM                    SDBRCH
 
      /COPY WNCPYSRC,FFEXTRV026
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
     C                   EVAL      FieldName = 'SBRCD'
     C                   EXSR      SpecialRet
     C                   EVAL      OKBRCD = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV027
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Trade date                               |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVTRDDAT'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    TRSD
 
      ** Inputs to called procedure
      ** --------------------------
      ** Trade date (6A, from transaction)
     C                   PARM                    STRSD
      ** Current trading date (5,0P, derived from transaction data)
     C                   PARM                    CTDATE
      ** Run date format (1A, from SDBANKPD)
     C                   PARM                    BJDFIN
      ** Historical date period (5,0P, derived from transaction data)
     C                   PARM                    STHDP
      ** Market centre  (2A, from transaction)
     C                   PARM                    SMRKT
      ** Month (2,0S, derived from transaction data)
     C                   PARM                    MTHN
      ** Year (2,0S, derived from transaction data)
     C                   PARM                    YRNO
      ** Location code (3A, from SDBRCHPD)
     C                   PARM                    A8LCCD
      ** Local currency code (3A, from SDBANKPD)
     C                   PARM                    BJLCCY
      ** Instrument types format (DS, from INTYPD)
     C                   PARM                    InstTypes
      ** Market centres format (DS, from MARKTD)
     C                   PARM                    MarketDet
      ** OK flags
     C                   PARM                    OKFlagsDS
 
      /COPY WNCPYSRC,FFEXTRV028
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKTRSD = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV029
 
      ** Value Date                                                                           CFF007
                                                                                              CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
                                                                                              CFF007
      ** Reset variables updated by each module before each call                              CFF007
     C                   EXSR      ResetErrs                                                  CFF007
                                                                                              CFF007
      ** Value Date Validation                                                                CFF007
     C                   CALLB     'FFVVDAT01'                                                CFF007
     C                   PARM                    ReturnCode                                   CFF007
     C                   PARM                    SVALD                                        CFF007
     C                   PARM                    STRSD                                        CFF007
     C                   PARM                    SMRKT                                        CFF007
     C                   PARM                    MTHN                                         CFF007
     C                   PARM                    YRNO                                         CFF007
     C                   PARM                    TRSD                                         CFF007
     C                   PARM                    InstTypes                                    CFF007
     C                   PARM                    MarketDet                                    CFF007
     C                   PARM                    BJDFIN                                       CFF007
     C                   PARM                    BJLCCY                                       CFF007
     C                   PARM                    OKTRSD                                       CFF007
     C                   PARM                    VALD                                         CFF007
     C                   PARM                    MsgIDXArr                                    CFF007
     C                   PARM                    FldNamXArr                                   CFF007
                                                                                              CFF007
      ** Do the return code and error details handling                                        CFF007
     C                   EXSR      HandleRet                                                  CFF007
     C                   EVAL      OKVALD = GenOKFlag                                         CFF007
                                                                                              CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** +------------------------------------------+-----------------------------------------------
      ** | To be left open flag                     |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFV2BLFOP'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** To be left open  indicator (1A, from transaction)
     C                   PARM                    STBLO
 
      /COPY WNCPYSRC,FFEXTRV030
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKTBLO = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV031
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Linked reference                         |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'MMVLINKREF'
      ** Return code
     C                   PARM                    ReturnCode
      ** Error message ID
     C                   PARM                    #Msgid
      ** Linked reference
     C                   PARM                    SLNKR
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP
 
      /COPY WNCPYSRC,FFEXTRV032
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
     C                   EVAL      FieldName = 'SLNKR'
     C                   EXSR      SpecialRet
     C                   EVAL      OKLNKR = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV033
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Originating branch                       |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'ZAVORGBRCH'
      ** Return code
     C                   PARM                    ReturnCode
      ** Error message ID
     C                   PARM                    #Msgid
      ** Originating branch
     C                   PARM                    SORBR
      ** Booking branch OK flag
     C                   PARM                    OKBRCD
      ** Booking branch
     C                   PARM                    SBRCD
      ** Multibranching indicator
     C                   PARM                    BGMBIN
      ** Originating branches used (from SDGELRPD)
     C                   PARM                    BKOBRU
      ** Originating branch/user validation required (from SDGELRPD)
     C                   PARM                    BKOBUV
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode
 
      /COPY WNCPYSRC,FFEXTRV034
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
     C                   EVAL      FieldName = 'SORBR'
     C                   EXSR      SpecialRet
     C                   EVAL      OKORBR = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV035
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Portfolio reference                      |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
      ** Don't call portfolio reference validation if customer was invalid,
      ** as the customer code is required in portfolio reference validation.
     C                   IF        OKCUSC <> 'N'
 
     C                   CALLB     'FFVPORTRF'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Field name array
     C                   PARM                    FldNamXArr
      ** Error message ID array
     C                   PARM                    MsgIDXArr
      ** Error message data array
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
     C                   PARM                    WPLCS                                      BUG10345
 
      ** Inputs to called procedure
      ** --------------------------
      ** Portfolio reference (4A)
     C                   PARM                    SPTFR
      ** Portfolio management module flag (1A, from SDMMODPD)
     C                   PARM                    BGPFMG
      ** Private Banking module flag (1A, from SDMMODPD)                        CPB001
     C                   PARM                    BGN4ST                         CPB001
      ** Private Banking customer flag (1A, from SDCUSTPD)                      CPB001
     C                   PARM                    BBPRBA                         CPB001
      ** Customer code (6,0S)
     C                   PARM                    CUSC
      ** Portfolio management ICD (DS, from SDPORTPD)
     C                   PARM                    SDPORT
 
      /COPY WNCPYSRC,FFEXTRV036
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKPTFR = GenOKFlag
 
     C                   ENDIF
      **                 End of "If OKCUSC <> 'N'"
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV037
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Profit centre                            |
      ** +------------------------------------------+
 
      ** Only validate when Profit Centre Accounting is off
     C                   IF        CAC003 = 'N'
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
      /COPY WNCPYSRC,FFEXTRV038
 
     C                   CALLB     'ZAVPROFITC'
      ** Return code
     C                   PARM                    ReturnCode
      ** Error message ID
     C                   PARM                    #Msgid
      ** Profit centre
     C                   PARM                    SPRFC
      ** Profit centres used (from SDGELRPD)
     C                   PARM                    BKPRCU
      ** Profit centres amendable (from SDGELRPD)
     C                   PARM                    BKPRCA
      ** Profit centre defaults used (from SDGELRPD)
     C                   PARM                    BKPCDU
      ** Transaction type (passed as blanks)
     C                   PARM      *blanks       Type2A
      ** Account officer code (from SDCUSTPD)
     C                   PARM                    BBACOC
      ** Customer number (from SDCUSTPD)
     C                   PARM                    BBCUST
      ** Book code
     C                   PARM                    SBOKC
      ** Transaction subtype (passed as blanks)
     C                   PARM      *blanks       SubType
      ** Branch codes
     C                   PARM                    SBRCD
      ** Department (from ZMUSER)
     C                   PARM                    DPPT
      ** User (from ZMUSER)
     C                   PARM                    USRID
      ** Customer OK flag
     C                   PARM                    OKCUSC
      ** Analytical (Profit-Centre) Accounting module flag
     C                   PARM                    BGN0ST
 
      /COPY WNCPYSRC,FFEXTRV039
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
     C                   EVAL      FieldName = 'SPRFC'
     C                   EXSR      SpecialRet
     C                   EVAL      OKPRFC = GenOKFlag
 
     C                   ENDIF
      **                 (End of "If CAC003 = 'N')
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFEXTRV040
 
      ** +-----------------------------------------------+------------------------------------------
      ** | Book and transaction positions profit centres |
      ** +-----------------------------------------------+
 
      ** Only validate when Profit Centre Accounting is on
      ** and various other fields are valid
     C                   IF        CAC003 = 'Y'
     C                             AND OKBOKC <> 'N'
     C                             AND OKBRCD <> 'N'
     C                             AND OKMRKT <> 'N'
     C                             AND OKISTC <> 'N'
     C                             AND OKBOCO <> 'N'
     C                             AND OKCUSC <> 'N'
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   EVAL      SISTT = SMRKT + SISTC
 
     C                   CALLB     'FFVPCAPRFC'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** OK flags for book and transaction positions profit centres
     C                   PARM                    OKBPRC
     C                   PARM                    OKTPRC
      ** Inputs to called procedure
      ** --------------------------
      ** Book positions profit centre
     C                   PARM                    SBPRC
      ** Transaction positions profit centre
     C                   PARM                    STPRC
      ** Book code
     C                   PARM                    SBOKC
      ** Branch codes
     C                   PARM                    SBRCD
      ** Instrument Type
     C                   PARM                    SISTT             5
      ** Transaction broker
     C                   PARM                    BOCO
      ** Transaction customer
     C                   PARM                    CUSC
      ** Department (from ZMUSER)
     C                   PARM                    DPPT
      ** User (from ZMUSER)
     C                   PARM                    USRID
      ** ICD
      ** Profit centres defaults used
     C                   PARM                    BKPCDU
      ** Reconcile trade/book position profit centre
     C                   PARM                    BXTBRC
 
      /COPY WNCPYSRC,FFEXTRV041
 
      ** Do the return code and error details handling.  The two OK flags
      ** are set in the called module, so don't need to do SR/HandlRet;
      ** just append the error codes if necessary.
      ** If errors or warnings found, append error and warning details
      ** from this module to the overall error and warning arrays.
     C                   IF        ReturnCode <> *blanks
     C                   EXSR      AppendArrs
     C                   ENDIF
 
     C                   ENDIF
      **                 (End of "If CAC003 = 'Y')
 
      ** -------------------------------------------------------------------------------------------
                                                                                CPL002
      ** +-----------------------------------------------+----------------------CPL002--------------
      ** | Spot Price                                    |                      CPL002
      ** +-----------------------------------------------+                      CPL002
                                                                                CPL002
      ** Only validate when Midas- Plato interface is ON and                    CPL002
      ** no error found for investment was ok.                                  CPL002
     C                   IF        BGN2ST = 'Y' AND OKISTC <> 'N'               CPL002
                                                                                CPL002
     C                   EXSR      ResetErrs                                    CPL002
                                                                                CPL002
     C                   CALLB     'FFVSPOTPR'                                  CPL002
      ** Parameters returned to caller                                          CPL002
      ** -----------------------------                                          CPL002
      ** Return code (10A, returned to caller)                                  CPL002
     C                   PARM                    ReturnCode                     CPL002
      ** Field name array (<ErrArrMax> x 10A, returned to caller)               CPL002
     C                   PARM                    FldNamXArr                     CPL002
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)          CPL002
     C                   PARM                    MsgIDXArr                      CPL002
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)       CPL002
     C                   PARM                    MsgDtaXArr                     CPL002
      ** Numeric (file) version of spot price (15,8P)                           CPL002
     C                   PARM                    PLSPTP                         CPL002
                                                                                CPL002
      ** Parameters received from caller                                        CPL002
      ** -------------------------------                                        CPL002
      ** Spot price (16A, from transaction)                                     CPL002
     C                   PARM                    SSPTP                          CPL002
      ** The INTYPD format (DS, several fields required)                        CPL002
     C                   PARM                    InstTypes                      CPL002
      ** Market (2A, from transaction if exchange-traded, passed as             CPL002
      ** blank for OTCs)                                                        CPL002
     C                   PARM                    SMRKT                          CPL002
                                                                                CPL002
      ** Do the return code and error details handling                          CPL002
     C                   EXSR      HandleRet                                    CPL002
     C                   EVAL      OKSPOT = GenOKFlag                           CPL002
                                                                                CPL002
     C                   ENDIF                                                  CPL002
      **                 (End of  Spot Price Validation)                        CPL002
                                                                                CPL002
      ** -----------------------------------------------------------------------CPL002--------------
 
      /COPY WNCPYSRC,FFEXTRV042
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
 
     C                   ELSE
     C                   EVAL      ReturnCode = 'Error'
 
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRV043
 
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFEXTRV044
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupValid - Set up the remaining valid file details which    *
      *              are not set up within the validation.            *
      *                                                               *
      *****************************************************************
 
     C     SetupValid    BEGSR
 
      ** --- Fields straight from the transaction --------------------------------------------------
 
      ** Transaction reference
     C                   MOVE      STNBR         TNBR
 
      ** Put/call indicator
     C                   EVAL      PCAL = SPCAL
 
      ** Transaction type (purchase or sale)
     C                   EVAL      TRTY = STRTY
 
      ** Number of contracts
     C                   MOVE      SNUCO         NUCO
 
      ** Instrument type is market concatenated with instrument
     C                   EVAL      ISTT = SMRKT + SISTC
 
      ** Transaction narrative
     C                   EVAL      TNAR = STNAR
 
      ** Instrument currency
     C                   EVAL      ISCY = ITISCY
 
      ** Portfolio reference
      ** If screen Portfolio Reference is the Non-Portfolio value, default
      ** in the file equivalent of this
     C**********         IF        WPLCS = 'Y'                                       BUG10345 243913
     C                   IF        WPLCS = 'Y' OR                                             243913
     C                             PPBCFLG = 'Y'                                              243913
     C                   IF        SPTFR = FCR997
     C                             AND BGN4ST <> 'Y'                            CPB001
     C                   EVAL      PTFR = '9997'
     C                   ELSE                                                                  S0148
     C                   EVAL      PTFR = SPTFR
     C                   ENDIF
     C                   ELSE                                                               BUG10345
     C                   EVAL      PTFR = *BLANK                                            BUG10345
     C                   ENDIF                                                              BUG10345
 
      ** Book code
     C                   EVAL      BOKC = SBOKC
 
      ** Originating branch
     C                   EVAL      BRCA = SBRCD
 
      ** To be left open indicator
     C                   EVAL      TBLO = STBLO
 
      ** Linked reference number
     C                   MOVE      SLNKR         LNKR
 
      ** Originating branch
     C                   EVAL      ORBR = SORBR
 
      ** Profit centre
     C                   EVAL      PRFC = SPRFC
 
      ** Book positions profit centre
     C                   EVAL      BPRC = SBPRC
 
      ** Transactions position profit centre
     C                   EVAL      TPRC = STPRC
 
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     BGN4ST        ANDEQ     'Y'                                                        CFF007
     C                   MOVE      SCOVE         COVE                                         CFF007
     C                   MOVE      SHETR         HETR                                         CFF007
     C                   MOVE      SBLUP         BLUP                                         CFF007
     C                   ENDIF                                                                CFF007
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AppendArrs - Append one field's error and warning details to  *
      *              the general error and warning arrays.            *
      *                                                               *
      *****************************************************************
 
     C     AppendArrs    BEGSR
 
     C                   CALLB     'APAPNDARRS'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Error array index (3,0P)
     C                   PARM                    Idx
      ** Field names with errors array (<ArrayMax> x 10A)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A)
     C                   PARM                    MsgDtaArr
      ** Warning array index (3,0P)
     C                   PARM                    WIdx
      ** Field names with warnings array (<ArrayMax> x 10A)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A)
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Field name array (<ErrArrMax> x 10A)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A)
     C                   PARM                    MsgDtaWArr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * HandleRet - Handle the return code and error details for      *
      *             each called procedure                             *
      *                                                               *
      *****************************************************************
 
     C     HandleRet     BEGSR
 
      ** Use the return code's value to set the field's OK flag
     C                   RESET                   GenOKFlag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    GenOKFlag
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If the OK flag is blank, set it to 'Y'; this shouldn't normally
      ** happen, but is a fallback.
     C                   IF        GenOKFlag = ' '
     C                   EVAL      GenOKFlag = 'Y'
     C                   ENDIF
 
      ** If errors or warnings found, append error and warning details
      ** from this module to the overall error and warning arrays.
     C                   IF        ReturnCode <> *blanks
     C                   EXSR      AppendArrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SpecialRet - Special return code and error details handling   *
      *              for called procedures with nonstandard parameter *
      *              structures.                                      *
      *                                                               *
      *****************************************************************
 
     C     SpecialRet    BEGSR
 
      ** Use the return code's value to set the field's OK flag
     C                   RESET                   GenOKFlag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    GenOKFlag
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If the OK flag is blank, set it to 'Y'; this shouldn't normally
      ** happen, but is a fallback.
     C                   IF        GenOKFlag = ' '
     C                   EVAL      GenOKFlag = 'Y'
     C                   ENDIF
 
      ** If errors or warnings found, append error and warning details
      ** from this module to the overall error and warning arrays.
     C                   IF        ReturnCode <> *blanks
 
      ** Initialise the general-purpose array index
     C                   RESET                   GI
 
      ** Put the field name passed into this subroutine, and the message
      ** ID returned from the most recently-called procedure, into the
      ** appropriate elements of the field-level error arrays.
     C                   EVAL      FldNamXArr(GI) = FieldName
     C                   EVAL      MsgIDXArr(GI) = #MsgID
 
     C                   EXSR      AppendArrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetErrs - Reset or clear all error-related fields           *
      *                                                               *
      *****************************************************************
 
     C     ResetErrs     BEGSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetMarket - Get the market details                            *
      *                                                               *
      *****************************************************************
 
     C     GetMarket     BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFGETMKT'
      ** Parameters returned from called module
      ** --------------------------------------
      ** Return code (10A)
     C                   PARM                    ReturnCode
      ** Market centre data structure
     C                   PARM                    MarketDet
 
      ** Parameters sent to called module
      ** --------------------------------
      ** Month number (2,0S)
     C                   PARM                    MTHN
      ** Instrument type (5A)
     C                   PARM                    ITISTT
 
      ** If the called module returned a database error, end in error
     C                   IF        ReturnCode = 'DBError'
     C                   EXSR      *pssr
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetCTDate - Determine the current trading date                *
      *                                                               *
      *****************************************************************
 
     C     GetCTDate     BEGSR
 
      ** Set up the current trading date
      ** -------------------------------
      ** MCBUSD is from MKCTL and BJRDNB is from SDBANKPD
     C                   IF        MCBUSD = 0
     C                   EVAL      CTDATE = BJRDNB
                                                                                              CSC011
      ** If 24x7 Midas availability is installed and user is in support                       CSC011
      ** system, set the trading date to the processing date held in                          CSC011
      ** dtaara SC24X7                                                                        CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      CTDATE = S1DATE                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE
     C                   EVAL      CTDATE = MCBUSD
     C                   ENDIF
 
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetHistPer - Determine start of the historical data period    *
      *                                                               *
      *****************************************************************
 
     C     GetHistPer    BEGSR
 
      ** Get the start of the Historical data period
      ** -------------------------------------------
      ** CTDATE is determined in SR/GetCTDate; BXHSPR is from the F & O
      ** ICD file, SDFODAPD.
     C                   EVAL      STHDP = CTDATE - BXHSPR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Outputs
      ** -------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field OK flags (data structure, from/to caller)
     C                   PARM                    OKFlagsDS
      ** Error array index (3,0P, from/to caller)
     C                   PARM                    Idx
      ** Field names in error array (<ArrayMax> x 10A, returned to caller)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A, returned to caller)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaArr
      ** Warning array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Field names w/warnings array (<ArrayMax> x 10A, returned to caller)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A, returned to caller)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A, returned to caller)
     C                   PARM                    WMsgDtaArr
      ** Valid transaction layout (data structure, from/to caller)
     C                   PARM                    ValidTran
      ** The branch details format (from SDBRCHPD via MMVBKGBRCH)
     C                   PARM                    SDBRCH
      ** The current trading date (Midas day number)
     C                   PARM                    CTDATE
      ** Instrument details (DS based on INTYPD)
     C                   PARM                    InstTypes
      ** PB customer indicator - broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
 
      ** Inputs
      ** ------
      ** Response mode (1A), from source system common header
     C                   PARM                    RespMode
      ** Transaction information (data structure, from source system)
     C                   PARM                    TranIn
      ** Extension file data                                                    CAP004
     C                   PARM                    ExtData                        CAP004
      ** Bank details (data structure based on SDBANKPD)
     C                   PARM                    SDBANK
      ** Module flags (data structure based on SDMMODPD)
     C                   PARM                    SDMMOD
      ** General Ledger ICD (data structure based on SDGELRPD)
     C                   PARM                    SDGELR
      ** Futures and Options ICD (data structure based on SDFODAPD)
     C                   PARM                    SDFODA
      ** Dealing ICD (data structure based on SDDEALPD)
     C                   PARM                    SDDEAL
      ** Portfolio Management ICD (data structure based on SDPORTPD)
     C                   PARM                    SDPORT                                        CPM00
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
     C                   PARM                    S01457            1                          208635
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY determines whether the Profit-Centre Accounting
      ** feature is on.  CAC003 is set to 'Y' if CAC003 is on and the
      ** Analytical Accounting module is on (BGN0ST = 'Y').
     C/COPY FFCPYSRC,CAC003CHEK
      **--------------------------------------------------------------------------------------------
      **********                                                                             BUG6979
      ***Get*default*branch*from*ZMUSER                                                      BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
     C**********         UNLOCK    ZMUSER                                                    BUG6979
                                                                                              CSC011
      ** Determine if 24x7 Midas availability is installed                                    CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** An NRF (No Record Found) return code is valid.                                       CSC011
      ** Issue database error only for error return codes.                                    CSC011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKey = 'CSC011'                                           CSC011
     C                   EVAL      DBASE = 1                                                  CSC011
     C                   EXSR      *pssr                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFEXTRV045
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
