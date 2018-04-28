     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC validation')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFOTCCVAL - Validation controller for currency over-the-     *
      *              counter options.                                 *
      *                                                               *
      *  Function:  This module controls the transaction validation   *
      *             for currency OTC options.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 247486             Date 01May07               *
      *                 247144             Date 18Apr07               *
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
      *                 215528             Date 21Mar03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 208635             Date 16Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166             Date 15Oct01               *
      *                 CSC011             Date 18Sep01               *
      *                 CAS002             Date 14Jan02               *
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
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247486 - Adjust premium.                                     *
      *  247144 - Apply 242992.                                       *
      *  242992 - Calculate Premium Amount based on Premium Ccy       *
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
      *  215528 - System is associating a wrong premium amount.       *
      *  208635 - Allow broker if S01457 is installed.                *
      *  CAP166 - API for Non-Currency OTC                            *
      *         - Changes in FFVOTCINS parameter                      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CPB001 - 'Private Banking' Module                            *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface.                              *
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
      /COPY WNCPYSRC,FFOTCCV001
 
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
 
     D TranIn        E DS                  EXTNAME(FFOTCCPD)
      ** Incoming transaction structure
 
      ** Dummy data structure which currency otc don't need                                   CAP166
     D FFOTCO        E DS                  EXTNAME(FFOTCOPD)                                  CAP166
     D                                     PREFIX(D2)                                         CAP166
                                                                                              CAP166
     D ValidTran     E DS                  EXTNAME(FFVTRANPD)
      ** Valid transaction layout
 
     D OKFlagsDS     E DS                  EXTNAME(FFEOTCCPD)
      ** The OK flags for the transaction
 
      ** Dummy data structure which currency otc don't need                                   CAP166
     D FFEOTCO       E DS                  EXTNAME(FFEOTCOPD)                                 CAP166
     D                                     PREFIX(D2)                                         CAP166
                                                                                              CAP166
      ** Dummy OKFlags DS for modules which non-ccy otc don't need this parm                  CAP166
     D FFEEXTR       E DS                  EXTNAME(FFEEXTRPD)                                 CAP166
     D                                     PREFIX(DM)                                         CAP166
                                                                                              CAP166
     D XInstTypes    E DS                  EXTNAME(INTYPD) PREFIX(AB)
      ** Instrument types
 
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
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  #ACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ** General Ledger ICD
 
     D CustomerDS    E DS                  EXTNAME(SDCUSTPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** Customer record format
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for Access Programs
 
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
 
      ** Enhanced OTCs feature on flag
     D CFF001          S              1A
 
      ** Dummy market field to pass as blanks to the modules that need it
     D DummyMarkt      S              2A
 
      ** Counter currency decimal places
     D CntCyDec        S              1S 0
      ** Delivery currency decimal places
     D DelCyDec        S              1S 0
      ** Premium currency decimal places
     D PrmCyDec        S              1S 0
 
      ** Number of contracts
     D FFNOC           S              5P 0
 
      * Price (File Format)
     D FFPRIC          S             15P 8
 
      * Ticks Denominator
     D FFTKDM          S              3P 0
 
      * Minimum Price Fluctuation
     D FFMNPF          S             15P 8
 
      ** Contract type
     D FFCNTT          S              1S 0
 
      ** Tick value
     D FFTKVL          S             14P 5
 
      ** Premium
     D FFPREM          S             13P 0
                                                                                              215528
      ** Strike Price                                                                         215528
     D FFSTRP          S                   LIKE(STRP)                                         215528
 
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - customer                                                     CFF007
     D PPBFLG          S              1A                                                      CFF007
                                                                                              CFF007
      ** Market                                                                               CFF007
     D SMRKT           S              2A                                                      CFF007
                                                                                              CFF007
      ** ZSEDIT fields
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
                                                                                              CSC011
      ** Define variable for switchable CSC011.                                               CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
                                                                                              CSC011
      ** Define parameters for AOSARDR0                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
 
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
      /COPY WNCPYSRC,FFOTCCV002
 
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
 
      ** Clear output premium
 
     C                   CLEAR                   SPREM
 
      ** Reset the fields specific to the VAL function
      ** ---------------------------------------------
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   EVAL      FFEOTCO = *ALL'Y'                                          CAP166
     C                   EVAL      FFEEXTR = *ALL'Y'                                          CAP166
 
      /COPY WNCPYSRC,FFOTCCV003
 
      ** Call Validation Modules in Sequence
      ** -----------------------------------
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Instrument processing type               |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVPRCTYP'
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
      ** Numeric (file) version of processing type
     C                   PARM                    ITISPT
 
      ** Inputs to called procedure
      ** --------------------------
      ** Processing type
     C                   PARM      '5'           SISPT
      ** Action code
     C                   PARM                    SACTN
 
      ** Transaction type                                                                     CAP166
     C                   PARM      'OTCC'        TransType                                    CAP166
                                                                                              CAP166
      /COPY WNCPYSRC,FFOTCCV004
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKISPT = GenOKFlag
 
 
      /COPY WNCPYSRC,FFOTCCV005
 
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
 
      /COPY WNCPYSRC,FFOTCCV006
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKTRTY = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV007
 
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
 
      /COPY WNCPYSRC,FFOTCCV008
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKNUCO = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV009
 
      ** +------------------------------------------+-----------------------------------------------
      ** | OTC type                                 |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVOTCTYP'
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
      ** Return record from Instrument type file
     C                   PARM                    XInstTypes
 
      ** Inputs to called procedure
      ** --------------------------
      ** OTC Type
     C                   PARM                    SISTT
      ** Instrument processing type
     C                   PARM                    SISPT
 
      /COPY WNCPYSRC,FFOTCCV010
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKISTT = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV011
 
      ** +------------------------------------------+-----------------------------------------------
      ** | OTC Instrument details                   |
      ** +------------------------------------------+
 
      ** Only validate if OTC type was ok
     C                   IF        OKISTT <> 'N'
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVOTCINS'
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
      ** FF OTC currency options OK flags
     C                   PARM                    OKFlagsDS
      ** FF OTC non-currency options OK flags                                                 CAP166
     C                   PARM                    FFEOTCO                                      CAP166
      ** Midas FF instrument types (detail) format - OUTPUT
     C                   PARM                    InstTypes
      ** Counter currency decimal places
     C                   PARM                    CntCyDec
      ** Delivery currency decimal places
     C                   PARM                    DelCyDec
      ** Premium currency decimal places
     C                   PARM                    PrmCyDec
 
      ** Inputs to called procedure
      ** --------------------------
      ** Entire transaction data structure (based on FFOTCCPD)
     C                   PARM                    TranIn
      ** Dummy transaction data structure (based on FFOTCOPD)                                 CAP166
     C                   PARM                    FFOTCO                                       CAP166
      ** Midas FF instrument types (detail) format - INPUT
     C                   PARM                    XInstTypes
      ** O.T.C. instrument switchable field
     C                   PARM                    CFF001
      ** Date format indicator
     C                   PARM                    BJDFIN
      ** Transaction type                                                                     CAP166
     C                   PARM      'OTCC'        TransType                                    CAP166
 
      /COPY WNCPYSRC,FFOTCCV012
 
      ** Do the return code and error details handling (note that in this
      ** case the relevant OK flags were set in the called procedure).
     C                   EXSR      HandleRet
 
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV013
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Put/call indicator                       |
      ** +------------------------------------------+
 
      ** Only validate if OTC type was ok
     C                   IF        OKISTT <> 'N'
 
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
 
      /COPY WNCPYSRC,FFOTCCV014
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKPCAL = GenOKFlag
 
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV015
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Strike price                             |
      ** +------------------------------------------+
 
      ** Only validate if OTC type was ok
     C                   IF        OKISTT <> 'N'
 
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
     C                   PARM                    DummyMarkt
      ** Counter amount (13,0S, from transaction)
     C                   PARM                    ITCCAM
      ** Delivery amount (13,0S, from transaction)
     C                   PARM                    ITCTAM
      ** Counter currency decimal places (1,0P, from currencies file)
     C                   PARM                    CntCyDec
      ** Delivery currency decimal places (1,0P, from currencies file)
     C                   PARM                    DelCyDec
 
      /COPY WNCPYSRC,FFOTCCV016
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKSTRP = GenOKFlag
 
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV017
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Contract price                           |
      ** +------------------------------------------+
 
      ** Only validate if OTC type was ok
     C                   IF        OKISTT <> 'N'
     C/COPY WNCPYSRC,FFOTCCVC01
 
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
 
      /COPY WNCPYSRC,FFOTCCV018
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKCOPR = GenOKFlag
 
     C                   ENDIF
      **                 End of "If OKISTT <> 'N'"
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV019
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Customer code                            |
      ** +------------------------------------------+
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
      ** This procedure requires a flag to indicate that no broker was
      ** entered (in which case the customer is mandatory).  OTCs do
      ** not have a broker, so just set the flag on.
     C                   EVAL      NoBroker = 'Y'
 
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
     C                   PARM                    PPBFLG                                       CFF007
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
 
      /COPY WNCPYSRC,FFOTCCV020
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKCUSC = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV021
 
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
 
      /COPY WNCPYSRC,FFOTCCV022
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKBOKC = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV023
 
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
 
      /COPY WNCPYSRC,FFOTCCV024
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
     C                   EVAL      FieldName = 'SBRCD'
     C                   EXSR      SpecialRet
     C                   EVAL      OKBRCD = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV025
 
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
     C                   PARM                    DummyMarkt
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
 
      /COPY WNCPYSRC,FFOTCCV026
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKTRSD = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV027
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Value date                               |
      ** +------------------------------------------+
 
      ** Only validate if OTC type was ok
     C                   IF        OKISTT <> 'N'
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C     CFF001        IFEQ      'Y'                                                        CFF007
     C     CFF007        ORNE      'Y'                                                        CFF007
     C                   CALLB     'FFVVALDAT'
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
      ** Value Date in Midas Day Number format
     C                   PARM                    VALD
 
      ** Inputs to called procedure
      ** --------------------------
      ** Value Date (6A)
     C                   PARM                    SVALD
      ** Trade date in Midas day number format
     C                   PARM                    TRSD
      ** Expiry Date
     C                   PARM                    ITFTDT
      ** Trade date
     C                   PARM                    STRSD
      ** Run date format (1A)
     C                   PARM                    BJDFIN
      ** Premium Currency (3A)
     C                   PARM                    SISCY
      ** Location code (3A)
     C                   PARM                    BJSLCD
      ** Trade date error flag (1A)
     C                   PARM                    OKTRSD
      ** Instrument/ O.T.C type error flag (1A)
     C                   PARM                    OKISTT
      ** Expiry date error flag (1A)
     C                   PARM                    OKFTDT
      ** Branch Code error flag (1A)
     C                   PARM                    OKBRCD
     C                   ELSE                                                                 CFF007
                                                                                              CFF007
     C                   CALLB     'FFVVDAT01'                                                CFF007
      ** Return code                                                                          CFF007
     C                   PARM                    ReturnCode                                   CFF007
      ** Value Date (6A)                                                                      CFF007
     C                   PARM                    SVALD                                        CFF007
      ** Trade date                                                                           CFF007
     C                   PARM                    STRSD                                        CFF007
      ** Market centre                                                                        CFF007
     C                   PARM      *BLANKS       SMRKT                                        CFF007
      ** Month (2,0S, derived from transaction data)                                          CFF007
     C                   PARM                    MTHN                                         CFF007
      ** Year (2,0S, derived from transaction data)                                           CFF007
     C                   PARM                    YRNO                                         CFF007
      ** Trade date in Midas day number format                                                CFF007
     C                   PARM                    TRSD                                         CFF007
      ** Instrument types format                                                              CFF007
     C                   PARM                    InstTypes                                    CFF007
      ** Market centres format                                                                CFF007
     C                   PARM                    MarketDet                                    CFF007
      ** Run date format (1A)                                                                 CFF007
     C                   PARM                    BJDFIN                                       CFF007
      ** Local currency code                                                                  CFF007
     C                   PARM                    BJLCCY                                       CFF007
      ** Midas OK flag for Trade Date                                                         CFF007
     C                   PARM                    OKTRSD                                       CFF007
      ** Value Date in Midas Day Number format                                                CFF007
     C                   PARM                    VALD                                         CFF007
      ** Error message ID array                                                               CFF007
     C                   PARM                    MsgIDXArr                                    CFF007
      ** Field name array                                                                     CFF007
     C                   PARM                    FldNamXArr                                   CFF007
     C                   ENDIF                                                                CFF007
 
      /COPY WNCPYSRC,FFOTCCV028
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKVALD = GenOKFlag
 
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV029
 
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
 
      /COPY WNCPYSRC,FFOTCCV030
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKTBLO = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV031
 
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
 
      /COPY WNCPYSRC,FFOTCCV032
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
     C                   EVAL      FieldName = 'SLNKR'
     C                   EXSR      SpecialRet
     C                   EVAL      OKLNKR = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV033
 
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
 
      /COPY WNCPYSRC,FFOTCCV034
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
     C                   EVAL      FieldName = 'SORBR'
     C                   EXSR      SpecialRet
     C                   EVAL      OKORBR = GenOKFlag
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV035
 
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
      ** Private Banking Customer flag (1A, from SDCUSTPD)                      CPB001
     C                   PARM                    BBPRBA                         CPB001
      ** Customer reference (6,0S)
     C                   PARM                    CUSC
      ** Portfolio management ICD (DS, from SDPORTPD)
     C                   PARM                    SDPORT
 
      /COPY WNCPYSRC,FFOTCCV036
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKPTFR = GenOKFlag
 
     C                   ENDIF
      **                 End of "If OKCUSC <> 'N'"
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV037
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Profit centre                            |
      ** +------------------------------------------+
 
      ** Only validate when Profit Centre Accounting is off
     C                   IF        CAC003 = 'N'
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
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
 
      /COPY WNCPYSRC,FFOTCCV038
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
     C                   EVAL      FieldName = 'SPRFC'
     C                   EXSR      SpecialRet
     C                   EVAL      OKPRFC = GenOKFlag
 
     C                   ENDIF
      **                 (End of "If CAC003 = 'N')
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV039
 
      ** +------------------------------------------+-----------------------------------------------
      ** | PM instrument type                       |
      ** +------------------------------------------+
 
     ****Only*validate*this*field*if*enhanced*OTCs*is*on                        CPB001
      ** Only validate if Private Banking Module is active                      CPB001
      ** Or Portfolio Management is active with Customer support                CPB001
     C**********         IF        CFF001 = 'Y'                                 CPB001
     C                   IF        BGN4ST = 'Y'                                 CPB001
     C                             OR BGPFMG = 'Y'                              CPB001
     C                             AND FCPORS <> 'B'                            CPB001
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVPMINST'
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
      ** PM instrument type
     C                   PARM                    SINNR
      ** Default  instrument type
     C                   PARM                    FCDINR
      ** Private Banking Module Indicator                                       CPB001
     C                   PARM                    BGN4ST                         CPB001
 
      /COPY WNCPYSRC,FFOTCCV040
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKINNR = GenOKFlag
 
     C                   ENDIF
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCCV041
 
      ** +-----------------------------------------------+------------------------------------------
      ** | Book and transaction positions profit centres |
      ** +-----------------------------------------------+
 
      ** Only validate when Profit Centre Accounting is on
      ** and various other fields are valid
     C                   IF        CAC003 = 'Y'
     C                             AND OKBOKC <> 'N'
     C                             AND OKBRCD <> 'N'
     C                             AND OKISTT <> 'N'
     C                             AND OKCUSC <> 'N'
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
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
     C                   PARM                    SISTT
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
 
      /COPY WNCPYSRC,FFOTCCV042
 
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
 
      /COPY WNCPYSRC,FFOTCCV043
                                                                                CPL002
      ** +-----------------------------------------------+----------------------CPL002--------------
      ** | Spot Price                                    |                      CPL002
      ** +-----------------------------------------------+                      CPL002
                                                                                CPL002
      ** Only validate when Midas- Plato interface is ON                        CPL002
     C                   IF        BGN2ST = 'Y'                                 CPL002
                                                                                CPL002
     C                   EXSR      ResetErrs                                    CPL002
                                                                                CPL002
     C                   CALLB     'FFVOTCSPT'                                  CPL002
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
      ** Strike price (15,8)                                                    CPL002
     C                   PARM                    STRP                           CPL002
      ** Counter amount (13,0S, from transaction)                               CPL002
     C                   PARM                    ITCCAM                         CPL002
      ** Delivery amount (13,0S, from transaction)                              CPL002
     C                   PARM                    ITCTAM                         CPL002
      ** Delivery Currency (3A, from transaction)                               CPL002
     C                   PARM                    SDCCY                          CPL002
      ** Counter  Currency (3A, from transaction)                               CPL002
     C                   PARM                    SCTCY                          CPL002
      ** Euro Currency Code (3A, from SDGELRPD)                                 CPL002
     C                   PARM                    BKEURO                         CPL002
      ** Transaction Value Date (5,0 in Midas date Format)                      CPL002
     C                   PARM                    VALD                           CPL002
                                                                                CPL002
      ** Do the return code and error details handling                          CPL002
     C                   EXSR      HandleRet                                    CPL002
     C                   EVAL      OKSPOT = GenOKFlag                           CPL002
                                                                                CPL002
     C                   ENDIF                                                  CPL002
      **                 (End of  Spot Price Validation)                        CPL002
                                                                                CPL002
      ** -----------------------------------------------------------------------CPL002--------------
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   EXSR      CalcPrem
 
     C                   ELSE
     C                   EVAL      ReturnCode = 'Error'
 
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCCV044
 
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFOTCCV045
 
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
 
      ** Instrument type
     C                   EVAL      ISTT = SISTT
 
      ** Transaction narrative
     C                   EVAL      TNAR = STNAR
 
      ** Instrument currency
     C                   EVAL      ISCY = ITISCY
 
      ** Portfolio reference
      ** If screen Portfolio Reference is the Non-Portfolio value, default
      ** in the file equivalent of this
     C**********         IF        WPLCS = 'Y'                                       BUG10345 243913
     C                   IF        WPLCS = 'Y' OR                                             243913
     C                             PPBFLG = 'Y'                                               243913
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
 
      ** Commodity reference
     C                   EVAL      ITCMRF = SCMRF
 
      ** PM instrument type
     C                   EVAL      ITINNR = SINNR
 
      ** Book positions profit centre
     C                   EVAL      BPRC = SBPRC
 
      ** Transactions position profit centre
     C                   EVAL      TPRC = STPRC
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcPrem - Calculate Premium                                  *
      *                                                               *
      *****************************************************************
 
     C     CalcPrem      BEGSR
 
      **   Calculate Premium For Display
 
     C                   Z-ADD     NUCO          FFNOC
     C                   Z-ADD     COPR          FFPRIC
     C                   Z-ADD     ITTKDM        FFTKDM
     C                   Z-ADD     ITMNPF        FFMNPF
     C                   Z-ADD     ITTKVL        FFTKVL
     C                   Z-ADD     ITCNTT        FFCNTT
     C                   CALLB     'FFPMCL'
      *                               Premium (13,0P)
     C                   PARM                    FFPREM
      **                              Number of contracts (5,0P)
     C                   PARM                    FFNOC
      **                              Price (15,8P)
     C                   PARM                    FFPRIC
      **                              Ticks denominator (3,0P)
     C                   PARM                    FFTKDM
      **                              Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
      **                              Tick Value (14,5P)
     C                   PARM                    FFTKVL
      **                              Instrument type (1,0S)
     C                   PARM                    ITISPT
      **                              Contract type (1,0S, from INTYPD)
     C                   PARM                    FFCNTT
      **                              Contingent amount (13,0P), from INTYPD)
     C                   PARM                    ITCTAM
      **                              Strike Price (15,8P)                                    215528
     C                   PARM      STRP          FFSTRP                                       215528
      *                                                                                       242992
     C     SISCY         IFEQ      SCTCY                                                      242992
     C*****FFPREM        MULT      STRP          FFPREM                                 242992247486
     C     FFPREM        MULT(H)   STRP          FFPREM                                       247486
     C                   END                                                                  242992
     C     SISCY         IFNE      SCTCY                                                      242992
     C     SISCY         ANDNE     SDCCY                                                      242992
     C                   Z-ADD     0             FFPREM                                       242992
     C                   END                                                                  242992
      *                                                                                       242992
 
     C                   Z-ADD     FFPREM        ZFLD15
     C                   Z-ADD     PrmCyDec      ZDECS
     C                   MOVE      'J'           ZECODE
     C                   CALLB     'ZSEDIT'
      ** Field to edit
     C                   PARM                    ZFLD15
      ** Decimal places
     C                   PARM                    ZDECS
      ** Edit code ('J', 'L' or ' ')
     C                   PARM                    ZECODE
      ** OUTPUT ***
     C                   PARM                    ZOUT21
     C                   MOVE      ZOUT21        SPREM
 
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
      * Premium
     C                   PARM                    SPREM            15
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBFLG                                       CFF007
 
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
      ** General Ledger ICD (data structure based on SDGELRPD
     C                   PARM                    SDGELR
      ** Futures and Options ICD (data structure based on SDFODAPD)
     C                   PARM                    SDFODA
      ** Dealing ICD (data structure based on SDDEALPD)
     C                   PARM                    SDDEAL
      ** Portfolio Management ICD (data structure based on SDPORTPD)
     C                   PARM                    SDPORT                                        CPM00
      ** O.T.C. instrument switchable field
     C                   PARM                    CFF001
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
     C                   PARM                    S01457            1                          208635
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY determines whether the Profit-Centre Accounting
      ** feature is on.  CAC003 is set to 'Y' if CAC003 is on and the
      ** Analytical Accounting module is on (BGN0ST = 'Y').
     C/COPY FFCPYSRC,CAC003CHEK
      **--------------------------------------------------------------------------------------------
                                                                                              CSC011
      ** Determine if 24x7 Midas availability is installed                                    CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** An NRF (No Record Found) return code is valid.                                       CSC011
      ** Issue database error only for error return codes.                                    CSC011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBASE = 1                                                  CSC011
     C                   EXSR      *PSSR                                                      CSC011
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
      **********                                                                             BUG6979
      ***Get*default*branch*from*ZMUSER                                                      BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
     C**********         UNLOCK    ZMUSER                                                    BUG6979
 
      ** Current trading date is run date
     C                   EVAL      CTDATE = BJRDNB
                                                                                              CSC011
      ** If 24x7 Midas availability is installed and user is in support                       CSC011
      ** system, set the trading date to the processing date held in                          CSC011
      ** dtaara SC24X7                                                                        CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      CTDATE = S1DATE                                            CSC011
     C                   ENDIF                                                                CSC011
 
      ** Get the start of the Historical data period:
      ** CTDATE is determined above; BXHSPR is from the F & O
      ** ICD file, SDFODAPD.
     C                   EVAL      STHDP = CTDATE - BXHSPR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFOTCCV046
 
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
(c) Misys International Banking Systems Ltd. 2001
