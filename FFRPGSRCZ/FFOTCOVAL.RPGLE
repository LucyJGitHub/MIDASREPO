     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Non-Currency OTC validation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFOTCOVAL - Validation controller for non-currency           *
      *              over-the-counter options.                        *
      *                                                               *
      *  Function:  This module controls the transaction validation   *
      *             for non-currency OTC options.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 243913             Date 03Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG1034            Date 06Feb06               *
      *                 BUG6979            Date 04May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3234            Date 14Jun04               *
      *                 CGL029             Date 01Sep03               *
      *                 215528             Date 21Mar03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 214057             Date 17Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  BUG3234- Divide by zero error on input                       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215528 - System is associating a wrong premium amount.       *
      *  214057 - Allow broker if S01457 is installed.                *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Field names/numbers table
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFOTCOV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------
 
      **--------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------
 
      **--------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------
 
      **--------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------
 
      **--------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------
 
      **--------------------------------------------------------------------
      ** The following /COPY line includes the definitions for FF-specific
      ** variables.
     D/COPY FFCPYSRC,DECLAREVAR
      **--------------------------------------------------------------------
 
 
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
 
      ** Incoming transaction structure
     D FFOTCO        E DS                  EXTNAME(FFOTCOPD)
 
      ** Dummy data structure which non-ccy otc don't need
     D FFOTCC        E DS                  EXTNAME(FFOTCCPD)
     D                                     PREFIX(D2)
 
      ** Valid transaction layout
     D ValidTran     E DS                  EXTNAME(FFVTRANPD)
     D                                     PREFIX(V)
 
      ** The OK flags for the transaction
     D FFEOTCO       E DS                  EXTNAME(FFEOTCOPD)
 
      ** Dummy data structure which non-ccy otc don't need
     D FFEOTCC       E DS                  EXTNAME(FFEOTCCPD)
     D                                     PREFIX(D2)
 
      ** Dummy OKFlags DS for modules which non-ccy otc don't need this parm
     D DummyOKFlgs   E DS                  EXTNAME(FFEEXTRPD)
     D                                     PREFIX(DM)
 
      ** Instrument types
     D XInstTypes    E DS                  EXTNAME(INTYPD) PREFIX(AB)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
      ** Market control details (MC=Market Control)
     D MarketCont    E DS                  EXTNAME(MKCTLD) PREFIX(MC)
 
      ** Market details DS (MK=MarKet)
     D MarketDet     E DS                  EXTNAME(MARKT) PREFIX(MK)
 
      ** Bank Details ICD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Deakub ICD (needed for decimal separator field)
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  #ACCD1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Customer record format
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** Short data structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Portfolio Management ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** Midas modules flags
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Futures and Options ICD
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  #ACCD2       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** ZMUSER data area layout
     D ZMUSER        E DS            17    DTAARA(ZMUSER) EXTNAME(ZMUSER)
 
 
      * FF Extension data (Exchange Traded) - File (D/B) format
     D ExtData       E DS                  EXTNAME(FFETEXPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D    SARLCD     E                     EXTFLD(LCD)
 
      ** Data structure for data area SC24X7
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  LookupSucc            98     98
     D  NoRecFound            99     99
 
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
 
      ** Enhanced OTCs feature on flag and CFF007 flag
     D CFF001          S              1A
     D CFF007          S              1A
 
      ** Screen mode
     D PScnMode        S              1A
 
      ** Dummy market field to pass as blanks to the modules that need it
     D DummyMarkt      S              2A
 
      ** Counter currency decimal places
     D CntCyDec        S              1S 0 INZ(0)
 
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
     D FFSTRP          S                   LIKE(VSTRP)                                        215528
 
      ** PB customer indicator - customer
     D PPBFLG          S              1A
 
      ** Market
     D NMRKT           S              2A
 
      ** ZSEDIT fields
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
      ** Define variable for switchable CSC011.
     D CSC011          S              1A   INZ('N')
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
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
      /COPY WNCPYSRC,FFOTCOV002
 
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
 
     C                   CLEAR                   FFPREM
 
      ** Reset the fields specific to the VAL function
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   EVAL      FFEOTCO = *ALL'Y'
     C                   EVAL      FFEOTCC = *ALL'Y'
     C                   EVAL      DummyOKFlgs = *ALL'Y'
 
      ** Check if validating first screen or second screen
 
     C                   IF        PScnMode = '1'
     C                   EXSR      SRValTrans
     C                   ELSE
     C                   EXSR      SRValPlto
     C                   ENDIF
 
     C                   IF        Idx = 0
 
      ** Do this for main transaction screen only
 
     C                   IF        PScnMode = '1'
     C                   EXSR      SetupValid
     C                   EXSR      CalcPrem
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ReturnCode = 'Error'
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValTrans - Validate Transaction Details                    *
      *                                                               *
      *****************************************************************
 
     C     SRValTrans    BEGSR
 
      ** Call Validation Modules in Sequence
      ** -----------------------------------
      /COPY WNCPYSRC,FFOTCOV003
 
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Numeric (file) version of processing type
 
     C                   PARM                    ITISPT
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Processing type
      ** Action code
      ** Transaction type
 
     C                   PARM                    NISPT
     C                   PARM                    NACTN
     C                   PARM      'OTCO'        TransType
 
      /COPY WNCPYSRC,FFOTCOV004
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKISPT = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV004
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Purchase or sale indicator (1A, from transaction)
 
     C                   PARM                    NTRTY
 
      /COPY WNCPYSRC,FFOTCOV006
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKTRTY = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV005
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Number of contracts (5A, from transaction)
 
     C                   PARM                    NNUCO
 
      /COPY WNCPYSRC,FFOTCOV008
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKNUCO = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV006
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Return record from Instrikent type file
 
     C                   PARM                    XInstTypes
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** OTC Type
      ** Instrument processing type
 
     C                   PARM                    NISTT
     C                   PARM                    NISPT
 
      /COPY WNCPYSRC,FFOTCOV010
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKISTT = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV007
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Put/call indicator (1A, from transaction)
      ** Instrument processing type (1,0S, from INTYPD)
 
     C                   PARM                    NPCAL
     C                   PARM                    ITISPT
 
      /COPY WNCPYSRC,FFOTCOV014
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKPCAL = GenOKFlag
 
     C                   ENDIF
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV008
 
      ** +------------------------------------------+--------------------
      ** | OTC Instrument details                   |
      ** +------------------------------------------+
 
      ** Only validate if OTC type was ok
 
     C                   IF        OKISTT <> 'N'
 
      ** Reset variables updated by each module before each call
 
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVOTCINS'
 
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Outputs from called procedure
      ** -----------------------------
 
      ** Field name array
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** FF OTC currency options OK flags
      ** FF OTC non-currency options OK flags
 
     C                   PARM                    FFEOTCC
     C                   PARM                    FFEOTCO
 
      ** Midas FF instrument types (detail) format - OUTPUT
 
     C                   PARM                    InstTypes
 
      ** Counter currency decimal places
      ** Delivery currency decimal places
      ** Premium currency decimal places
 
     C                   PARM                    CntCyDec
     C                   PARM                    DelCyDec
     C                   PARM                    PrmCyDec
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Dummy transaction data structure (based on FFOTCCPD)
      ** Entire transaction data structure (based on FFOTCOPD)
 
     C                   PARM                    FFOTCC
     C                   PARM                    FFOTCO
 
      ** Midas FF instrument types (detail) format - INPUT
 
     C                   PARM                    XInstTypes
 
      ** O.T.C. instrument switchable field
      ** Date format indicator
      ** Transaction type
 
     C                   PARM                    CFF001
     C                   PARM                    BJDFIN
     C                   PARM      'OTCO'        TransType
 
      /COPY WNCPYSRC,FFOTCOV012
 
      ** Do the return code and error details handling (note that in this
      ** case the relevant OK flags were set in the called procedure).
 
     C                   EXSR      HandleRet
 
     C                   ELSE
 
      ** This will bypass validation of dates against final transaction date
 
     C                   EVAL      DMOKISTC = 'N'
 
     C                   ENDIF
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV009
 
      ** +------------------------------------------+--------------------
      ** | Tick Value                               |
      ** +------------------------------------------+
 
      ** Only validate if premium currency is not in error
 
     C                   IF        OKISCY <> 'N'
 
      ** Reset variables updated by each module before each call
 
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVOTCTKV'
 
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Input Parameters
      ** ----------------
 
      ** Field(s) requiring validation
      ** Premium currency decimal places
 
     C                   PARM                    NTKVL
     C                   PARM                    PrmCyDec
 
      ** Output parameters
      ** -----------------
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamWArr
     C                   PARM                    MsgIDWArr
     C                   PARM                    MsgDtaWArr
 
      ** Numeric (file) version of tick value
      ** Tick value OK flag
 
     C                   PARM                    ITTKVL
     C                   PARM                    OKTKVL
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
 
     C                   ENDIF
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV010
 
      ** +------------------------------------------+--------------------
      ** | Minimum price fluctuation                |
      ** +------------------------------------------+
 
      ** Only validate if premium currency is not in error
 
     C                   IF        OKISCY <> 'N'
 
      ** Reset variables updated by each module before each call
 
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVOTCMNP'
 
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Input parameters
      ** ----------------
 
      ** Field(s) requiring validation
 
     C                   PARM                    NMNPF
 
      ** Output parameters
      ** ----------------
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamWArr
     C                   PARM                    MsgIDWArr
     C                   PARM                    MsgDtaWArr
 
      ** Numeric (file) version of minimum price fluctuation
      ** Minimum price fluctuation OK flag
 
     C                   PARM                    ITMNPF
     C                   PARM                    OKMNPF
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
 
     C                   ENDIF
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV011
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Numeric (file) version of strike price
 
     C                   PARM                    VSTRP
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Strike price (16A, from transaction)
 
     C                   PARM                    NSTRP
 
      ** The INTYPD format (several fields required by calld module)
 
     C                   PARM                    InstTypes
 
      ** Market (2A, from transaction)
      ** Counter amount (13,0S, from transaction)
      ** Delivery amount (13,0S, from transaction)
      ** Counter currency decimal places (1,0P, from currencies file)
      ** Delivery currency decimal places (1,0P, from currencies file)
 
     C                   PARM                    DummyMarkt
     C                   PARM                    ITCCAM
     C                   PARM                    ITCTAM
     C                   PARM                    CntCyDec
     C                   PARM                    DelCyDec
 
      /COPY WNCPYSRC,FFOTCOV016
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKSTRP = GenOKFlag
 
     C                   ENDIF
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV012
 
      ** +------------------------------------------+--------------------
      ** | Contract price                           |
      ** +------------------------------------------+
 
      ** Only validate if OTC type was ok
      ** and instrument processing type is OK                                   BUG3234
     C                   IF        OKISTT <> 'N'
     C                             AND OKISPT <> 'N'                            BUG3234
 
      ** Reset variables updated by each module before each call
 
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVCONTPR'
 
      ** Outputs from called procedure
      ** -----------------------------
 
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Field name array
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Field name array (<WArrMax> x 10A, returned to caller)
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamWArr
     C                   PARM                    MsgIDWArr
     C                   PARM                    MsgDtaWArr
 
      ** Numeric (file) version of price
 
     C                   PARM                    VCOPR
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Contract price (16A)
 
     C                   PARM                    NCOPR
 
      ** Year number (2,0S)
      ** Month number (2,0S)
 
     C                   PARM                    VYRNO
     C                   PARM                    VMTHN
 
      ** Put call indicator
      ** Strike price (15,8P)
 
     C                   PARM                    NPCAL
     C                   PARM                    VSTRP
 
      ** Instrument types (DS, from INTYPD)
      ** Dummy Ok flags this parm is not needed by non-ccy OTC
 
     C                   PARM                    InstTypes
     C                   PARM                    DummyOkFlgs
 
      /COPY WNCPYSRC,FFOTCOV018
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKCOPR = GenOKFlag
 
     C                   ENDIF
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV013
 
      ** +------------------------------------------+--------------------
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
      ** Default branch code from ZMUSER data area
      ** Round-down indicator from SDBRCHPD
 
     C                   PARM                    BJSBRC
     C                   PARM                    DBRN
     C                   PARM                    A8RDFC
 
      ** Action code from transaction
      ** Booking branch from transaction
 
     C                   PARM                    NACTN
     C                   PARM                    NBRCD
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
 
     C                   PARM                    RespMode
 
      ** Returned version of branch code
 
     C                   PARM                    VBRCA
 
      ** The branch detail format from SDBRCHPD
 
     C                   PARM                    SDBRCH
 
      /COPY WNCPYSRC,FFOTCOV024
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
 
     C                   EVAL      FieldName = '#1BRCD'
     C                   EXSR      SpecialRet
     C                   EVAL      OKBRCD = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV014
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Trade date in Midas day number format (5,0P)
 
     C                   PARM                    VTRSD
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Trade date (6A, from transaction)
      ** Current trading date (5,0P, derived from transaction data)
      ** Run date format (1A, from SDBANKPD)
      ** Historical date period (5,0P, derived from transaction data)
 
     C                   PARM                    NTRSD
     C                   PARM                    CTDATE
     C                   PARM                    BJDFIN
     C                   PARM                    STHDP
 
      ** Market centre  (2A, from transaction)
 
     C                   PARM                    DummyMarkt
 
      ** Month (2,0S, derived from transaction data)
      ** Year (2,0S, derived from transaction data)
 
     C                   PARM                    VMTHN
     C                   PARM                    VYRNO
 
      ** Location code (3A, from SDBRCHPD)
      ** Local currency code (3A, from SDBANKPD)
 
     C                   PARM                    A8LCCD
     C                   PARM                    BJLCCY
 
      ** Instrument types format (DS, from INTYPD)
      ** Market centres format (DS, from MARKTD)
      ** DummyOkFlags as this parm not needed for non-ccy OTC
 
     C                   PARM                    InstTypes
     C                   PARM                    MarketDet
     C                   PARM                    DummyOkFlgs
 
      /COPY WNCPYSRC,FFOTCOV026
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKTRSD = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV015
 
      ** +------------------------------------------+--------------------
      ** | Value date                               |
      ** +------------------------------------------+
 
      ** Only validate if OTC type was ok
 
     C                   IF        OKISTT <> 'N'
 
      ** Reset variables updated by each module before each call
 
     C                   EXSR      ResetErrs
 
     C                   IF        CFF001 = 'Y' OR CFF007 <> 'Y'
 
     C                   CALLB     'FFVVALDAT'
 
      ** Outputs from called procedure
      ** -----------------------------
 
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Field name array
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Value Date in Midas Day Number format
 
     C                   PARM                    VVALD
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Value Date (6A)
      ** Trade date in Midas day number format
      ** Expiry Date
      ** Trade date
      ** Run date format (1A)
 
     C                   PARM                    NVALD
     C                   PARM                    VTRSD
     C                   PARM                    ITFTDT
     C                   PARM                    NTRSD
     C                   PARM                    BJDFIN
 
      ** Premium Currency (3A)
      ** Location code (3A)
      ** Trade date error flag (1A)
 
     C                   PARM                    NISCY
     C                   PARM                    BJSLCD
     C                   PARM                    OKTRSD
 
      ** Instrument/ O.T.C type error flag (1A)
      ** Expiry date error flag (1A)
      ** Branch Code error flag (1A)
 
     C                   PARM                    OKISTT
     C                   PARM                    OKFTDT
     C                   PARM                    OKBRCD
 
     C                   ELSE
 
     C                   CALLB     'FFVVDAT01'
 
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Value Date (6A)
      ** Trade date
      ** Market centre
 
     C                   PARM                    NVALD
     C                   PARM                    NTRSD
     C                   PARM      *BLANKS       NMRKT
 
      ** Month (2,0S, derived from transaction data)
      ** Year (2,0S, derived from transaction data)
      ** Trade date in Midas day number format
 
     C                   PARM                    VMTHN
     C                   PARM                    VYRNO
     C                   PARM                    VTRSD
 
      ** Instrument types format
      ** Market centres format
 
     C                   PARM                    InstTypes
     C                   PARM                    MarketDet
 
      ** Run date format (1A)
      ** Local currency code
 
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
 
      ** Midas OK flag for Trade Date
 
     C                   PARM                    OKTRSD
 
      ** Value Date in Midas Day Number format
 
     C                   PARM                    VVALD
 
      ** Error message ID array
      ** Field name array
 
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOV028
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKVALD = GenOKFlag
 
     C                   ENDIF
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV016
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Numeric version of customer code (6,0S)
      ** PB customer indicator
      ** Customer format (from SDCUSTPD)
 
     C                   PARM                    VCUSC
     C                   PARM                    PPBFLG
     C                   PARM                    SDCUST
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Customer I.D. (10A, from transaction)
      ** No broker, so customer mandatory
 
     C                   PARM                    NCUSC
     C                   PARM                    NoBroker
     C                   PARM                    S01457                                       214057
     C                   PARM                    NACTN                                        CSD025
 
      /COPY WNCPYSRC,FFOTCOV020
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKCUSC = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV017
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Book code (2A, from transaction)
      ** Customer I.D. (10A, from transaction)
      ** Default Trade book (2A, from SDFODAPD)
      ** Default Customer book (2A, from SDFODAPD)
 
     C                   PARM                    NBOKC
     C                   PARM                    NCUSC
     C                   PARM                    BXDTBC
     C                   PARM                    BXBKCD
 
      /COPY WNCPYSRC,FFOTCOV022
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKBOKC = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV018
 
      ** +------------------------------------------+--------------------
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
      ** Booking branch OK flag
      ** Booking branch
 
     C                   PARM                    NORBR
     C                   PARM                    OKBRCD
     C                   PARM                    NBRCD
 
      ** Multibranching indicator
      ** Originating branches used (from SDGELRPD)
      ** Originating branch/user validation required (from SDGELRPD)
 
     C                   PARM                    BGMBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
 
     C                   PARM                    RespMode
 
      /COPY WNCPYSRC,FFOTCOV034
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
 
     C                   EVAL      FieldName = '#1ORBR'
     C                   EXSR      SpecialRet
     C                   EVAL      OKORBR = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV019
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** To be left open  indicator (1A, from transaction)
 
     C                   PARM                    NTBLO
 
      /COPY WNCPYSRC,FFOTCOV030
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKTBLO = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV020
 
      ** +------------------------------------------+--------------------
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
 
     C                   PARM                    NLNKR
 
      ** Decimal separator (1A, from SDDEALPD)
 
     C                   PARM                    BNDCSP
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
 
     C                   EVAL      FieldName = '#1LNKR'
     C                   EXSR      SpecialRet
     C                   EVAL      OKLNKR = GenOKFlag
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV021
 
      ** +------------------------------------------+--------------------
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
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Field name array (<WArrMax> x 10A, returned to caller)
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamWArr
     C                   PARM                    MsgIDWArr
     C                   PARM                    MsgDtaWArr
     C                   PARM                    WPLCS                                      BUG10345
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Portfolio reference (4A)
 
     C                   PARM                    NPTFR
 
      ** Portfolio management module flag (1A, from SDMMODPD)
      ** Private Banking module flag (1A, from SDMMODPD)
      ** Customer reference (6,0S)
      ** Private Banking Customer flag (1A, from SDCUSTPD)
      ** Portfolio management ICD (DS, from SDPORTPD)
 
     C                   PARM                    BGPFMG
     C                   PARM                    BGN4ST
     C                   PARM                    BBPRBA
     C                   PARM                    VCUSC
     C                   PARM                    SDPORT
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKPTFR = GenOKFlag
 
     C                   ENDIF
 
      **                 End of "If OKCUSC <> 'N'"
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV022
 
      ** +------------------------------------------+--------------------
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
 
     C                   PARM                    NPRFC
 
      ** Profit centres used (from SDGELRPD)
      ** Profit centres amendable (from SDGELRPD)
      ** Profit centre defaults used (from SDGELRPD)
 
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
 
      ** Transaction type (passed as blanks)
 
     C                   PARM      *BLANKS       Type2A
 
      ** Account officer code (from SDCUSTPD)
      ** Customer number (from SDCUSTPD)
 
     C                   PARM                    BBACOC
     C                   PARM                    BBCUST
 
      ** Book code
      ** Transaction subtype (passed as blanks)
      ** Branch codes
 
     C                   PARM                    NBOKC
     C                   PARM      *BLANKS       SubType
     C                   PARM                    NBRCD
 
      ** Department (from ZMUSER)
      ** User (from ZMUSER)
 
     C                   PARM                    DPPT
     C                   PARM                    USRID
 
      ** Customer OK flag
 
     C                   PARM                    OKCUSC
 
      ** Analytical (Profit-Centre) Accounting module flag
 
     C                   PARM                    BGN0ST
 
      ** Do the return code and error details handling (special one for
      ** nonstandard parameter structure).
 
     C                   EVAL      FieldName = '#1PRFC'
     C                   EXSR      SpecialRet
     C                   EVAL      OKPRFC = GenOKFlag
 
     C                   ENDIF
 
      ** (End of "If CAC003 = 'N')
 
      ** -------------------------------------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV023
 
      ** +------------------------------------------+--------------------
      ** | PM instrument type                       |
      ** +------------------------------------------+
 
      ** Only validate if Private Banking Module is active
      ** Or Portfolio Management is active with Customer support
 
     c                   IF        NACTN = 'I'
     C                   IF        BGN4ST = 'Y' or BGPFMG = 'Y' and
     C                             FCPORS <> 'B'
 
      ** Reset variables updated by each module before each call
 
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVPMINST'
 
      ** Outputs from called procedure
      ** -----------------------------
 
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Field name array
      ** Error message ID array
      ** Error message data array
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** PM instrument type
      ** Default  instrument type
 
     C                   PARM                    NINNR
     C                   PARM                    FCDINR
 
      ** Private Banking Module Indicator
 
     C                   PARM                    BGN4ST
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKINNR = GenOKFlag
 
     C                   ENDIF
     C                   ENDIF
 
      ** ----------------------------------------------------------------
 
      /COPY WNCPYSRC,FFOTCOV024
 
      ** +-----------------------------------------------+---------------
      ** | Book and transaction positions profit centres |
      ** +-----------------------------------------------+
 
      ** Only validate when Profit Centre Accounting is on
      ** and various other fields are valid
 
     C                   IF        CAC003 = 'Y' and OKBOKC <> 'N' and
     C                             OKBRCD <> 'N'and OKISTT <> 'N' and
     C                             OKCUSC <> 'N'
 
      ** Reset variables updated by each module before each call
 
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVPCAPRFC'
 
      ** Outputs from called procedure
      ** -----------------------------
 
      ** Return code (10A, returned to caller)
 
     C                   PARM                    ReturnCode
 
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** OK flags for book and transaction positions profit centres
 
     C                   PARM                    OKBPRC
     C                   PARM                    OKTPRC
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Book positions profit centre
      ** Transaction positions profit centre
 
     C                   PARM                    NBPRC
     C                   PARM                    NTPRC
 
      ** Book code
      ** Branch code
      ** Instrument Type
      ** Transaction broker
      ** Transaction customer
 
     C                   PARM                    NBOKC
     C                   PARM                    NBRCD
     C                   PARM                    NISTT
     C                   PARM                    VBOCO
     C                   PARM                    VCUSC
 
      ** Department (from ZMUSER)
      ** User (from ZMUSER)
 
     C                   PARM                    DPPT
     C                   PARM                    USRID
 
      ** ICD
      ** Profit centres defaults used
      ** Reconcile trade/book position profit centre
 
     C                   PARM                    BKPCDU
     C                   PARM                    BXTBRC
 
      /COPY WNCPYSRC,FFOTCOV042
 
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
 
      ** ----------------------------------------------------------------
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFOTCOV025
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValPlto  - Validate Plato screen field.                     *
      *                                                               *
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFOTCOV026
 
     C     SRValPlto     BEGSR
 
     C                   CALLB     'FFVPLTOIN'
 
      ** Return code
 
     C                   PARM                    ReturnCode
 
      ** Input parameters
      ** ----------------
 
      ** Transaction information (data structure, from source system)
 
     C                   PARM                    FFOTCO
 
      ** Euro currency code (from SDGELRPD, to be used for spot price val)
      ** Date format indicator (from SDBANKPD, to be used for date conversion)
 
     C                   PARM                    BKEURO
     C                   PARM                    BJDFIN
 
      ** Ouput parameters
      ** ----------------
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Error array index (3,0P, from/to caller)
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Warning array index (3P0) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
      ** Field OK flags (data structure, from/to caller)
 
     C                   PARM                    FFEOTCO
 
      ** Valid transaction layout (data structure, from/to caller)
      ** Instrument details (DS based on INTYPD)
 
     C                   PARM                    ValidTran
     C                   PARM                    InstTypes
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFOTCOV027
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetupValid - Set up the remaining valid file details which    *
      *              are not set up within the validation.            *
      *                                                               *
      *****************************************************************
 
     C     SetupValid    BEGSR
 
      ** --- Fields straight from the transaction -----------------------
 
      ** Transaction reference
      ** Put/call indicator
      ** Transaction type (purchase or sale)
      ** Number of contracts
      ** Instrument type
      ** Transaction narrative
      ** Instrument currency
 
     C                   MOVE      NTNBR         VTNBR
     C                   EVAL      VPCAL = NPCAL
     C                   EVAL      VTRTY = NTRTY
     C                   MOVE      NNUCO         VNUCO
     C                   EVAL      VISTT = NISTT
     C                   EVAL      VTNAR = NTNAR
     C                   EVAL      VISCY = ITISCY
 
      ** Portfolio reference
      ** If screen Portfolio Reference is the Non-Portfolio value, default
      ** in the file equivalent of this
 
     C**********         IF        WPLCS = 'Y'                                       BUG10345 243913
     C                   IF        WPLCS = 'Y' OR                                             243913
     C                             PPBFLG = 'Y'                                               243913
     C                   IF        NPTFR = FCR997
     C                             AND FCR997 <> *BLANKS
     C                             AND BGN4ST <> 'Y'
     C                   EVAL      VPTFR = '9997'
     C                   ELSE
     C                   EVAL      VPTFR = NPTFR
     C                   ENDIF
     C                   ELSE                                                               BUG10345
     C                   EVAL      VPTFR = *BLANK                                           BUG10345
     C                   ENDIF                                                              BUG10345
 
      ** Book code
      ** Originating branch
      ** To be left open indicator
      ** Linked reference number
      ** Originating branch
      ** Profit centre
      ** Commodity reference
      ** PM instrument type
      ** Book positions profit centre
      ** Transactions position profit centre
 
     C                   EVAL      VBOKC = NBOKC
     C                   EVAL      VBRCA = NBRCD
     C                   EVAL      VTBLO = NTBLO
     C                   MOVE      NLNKR         VLNKR
     C                   EVAL      VORBR = NORBR
     C                   EVAL      VPRFC = NPRFC
     C                   EVAL      ITCMRF = NCMRF
     C                   EVAL      ITINNR = NINNR
     C                   EVAL      VBPRC = NBPRC
     C                   EVAL      VTPRC = NTPRC
 
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
 
     C                   Z-ADD     VNUCO         FFNOC
     C                   Z-ADD     VCOPR         FFPRIC
     C                   Z-ADD     ITTKDM        FFTKDM
     C                   Z-ADD     ITMNPF        FFMNPF
     C                   Z-ADD     ITTKVL        FFTKVL
     C                   Z-ADD     ITCNTT        FFCNTT
 
     C                   CALLB     'FFPMCL'
 
      ** Premium (13,0P)
      ** Number of contracts (5,0P)
      ** Price (15,8P)
      ** Ticks denominator (3,0P)
      ** Minimum price fluctuation (15,8P)
      ** Tick Value (14,5P)
      ** Instrument type (1,0S)
      ** Contract type (1,0S, from INTYPD)
      ** Contingent amount (13,0P), from INTYPD)
 
     C                   PARM                    FFPREM
     C                   PARM                    FFNOC
     C                   PARM                    FFPRIC
     C                   PARM                    FFTKDM
     C                   PARM                    FFMNPF
     C                   PARM                    FFTKVL
     C                   PARM                    ITISPT
     C                   PARM                    FFCNTT
     C                   PARM                    ITCTAM
     C                   PARM      VSTRP         FFSTRP                                       215528
 
     C                   Z-ADD     FFPREM        ZFLD15
     C                   Z-ADD     PrmCyDec      ZDECS
 
     C                   EVAL      ZECODE = 'J'
 
     C                   CALLB     'ZSEDIT'
 
      ** Field to edit
      ** Decimal places
      ** Edit code ('J', 'L' or ' ')
 
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
 
      ** Output
 
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
      ** Field names with errors array (<ArrayMax> x 10A)
      ** Error message ID array (<ArrayMax> x 7A)
      ** Error message data array (<ArrayMax> x 45A)
 
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Warning array index (3,0P)
      ** Field names with warnings array (<ArrayMax> x 10A)
      ** Warning message ID array (<ArrayMax> x 7A)
      ** Warning message data array (<ArrayMax> x 45A)
 
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Field name array (<ErrArrMax> x 10A)
      ** Error message ID array (<ErrArrMax> x 7A)
      ** Error message data array (<ErrArrMax> x 45A)
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Field name array (<WArrMax> x 10A)
      ** Warning message ID array (<WArrMax> x 7A)
      ** Warning message data array (<WArrMax> x 45A)
 
     C                   PARM                    FldNamWArr
     C                   PARM                    MsgIDWArr
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
 
      **-----------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires FVAL_ARRAY and STD_D_SPEC.
      /COPY ZACPYSRC,FVAL_RESET
      **-----------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return code (10A, returned to caller)
 
     C                   PARM                    ReturnCode
 
      ** Input parameters
      ** ----------------
 
      ** Response mode (1A), from source system common header
 
     C                   PARM                    RespMode
 
      ** Transaction information (data structure, from source system)
      ** Extension file data
 
     C                   PARM                    FFOTCO
     C                   PARM                    ExtData
 
      ** Standing data ICD
      ** -----------------
 
      ** Bank details (data structure based on SDBANKPD)
      ** Module flags (data structure based on SDMMODPD)
      ** General Ledger ICD (data structure based on SDGELRPD
      ** Futures and Options ICD (data structure based on SDFODAPD)
      ** Dealing ICD (data structure based on SDDEALPD)
      ** Portfolio Management ICD (data structure based on SDPORTPD)
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
     C                   PARM                    SDFODA
     C                   PARM                    SDDEAL
     C                   PARM                    SDPORT
 
      ** O.T.C. instrument switchable field
      ** CFF007 Enhancement
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Screen mode ('1' = Transaction screen and '2' = Plato Screen)
 
     C                   PARM                    PScnMode
 
      ** Output Parameters
      ** =================
 
      ** Field names in error array (<ArrayMax> x 10A, returned to caller)
      ** Error message ID array (<ArrayMax> x 7A, returned to caller)
      ** Error message data array (<ArrayMax> x 45A, returned to caller)
      ** Error array index (3,0P, from/to caller)
      ** Warning message ID array (<ArrayMax> x 7A, returned to caller)
      ** Field names w/warnings array (<ArrayMax> x 10A, returned to caller)
      ** Warning message data array (<ArrayMax> x 45A, returned to caller)
      ** Warning array index (3P0) from/to caller
      ** Field OK flags (data structure, from/to caller)
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    FFEOTCO
 
      ** Valid transaction layout (data structure, from/to caller)
      ** The branch details format (from SDBRCHPD via MMVBKGBRCH)
      ** The current trading date (Midas day number)
      ** Instrument details (DS based on INTYPD)
      ** Premium
      ** PB customer indicator
 
     C                   PARM                    ValidTran
     C                   PARM                    SDBRCH
     C                   PARM                    CTDATE
     C                   PARM                    InstTypes
     C                   PARM                    SPREM            15
     C                   PARM                    PPBFLG
     C                   PARM                    S01457            1                          214057
 
     C                   EVAL      CAC003 = 'N'
 
      **--------------------------------------------------------------------
      ** The following /COPY determines whether the Profit-Centre Accounting
      ** feature is on.  CAC003 is set to 'Y' if CAC003 is on and the
      ** Analytical Accounting module is on (BGN0ST = 'Y').
     C/COPY FFCPYSRC,CAC003CHEK
      **--------------------------------------------------------------------
 
      ** Determine if 24x7 Midas availability is installed
 
     C                   EVAL      CSC011 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        @RtCd <> *BLANKS AND @RtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ENDIF
      **********                                                                             BUG6979
      ***Get*default*branch*from*ZMUSER                                                      BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
     C**********         UNLOCK    ZMUSER                                                    BUG6979
 
      ** Current trading date is run date
 
     C                   EVAL      CTDATE = BJRDNB
 
      ** If 24x7 Midas availability is installed and user is in support
      ** system, set the trading date to the processing date held in
      ** dtaara SC24X7
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
     C                   EVAL      CTDATE = S1DATE
     C                   ENDIF
 
      ** Get the start of the Historical data period:
      ** CTDATE is determined above; BXHSPR is from the F & O
      ** ICD file, SDFODAPD.
 
     C                   EVAL      STHDP = CTDATE - BXHSPR
 
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFOTCOV046
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
