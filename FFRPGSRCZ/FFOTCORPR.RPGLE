     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Invalid non-currency OTC repair function')    *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCORPR - Invalid FF Non-Currency OTC options repair       *
      *                                                               *
      *  Function:  This function allows invalid non-currency OTC     *
      *             options to be repaired and applied to the Midas   *
      *             database.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9078            Date 08Aug05               *
      *                 BG9185             Date 08Nov05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 28Oct03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 214057             Date 17Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9078 - Action 'N' updates the database file even with     *
      *            errors.                                            *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  214057 - Allow broker if S01457 is installed.                *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction error details
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Invalid OTC currency option transactions by timestamp and
      ** front-office ID
     FFFIOTCOL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFIOTCOD0 : FFIOTCOX0)
 
      ** Invalid OTC currency option transactions by front-office ID
      ** and timestamp
     FFFIOTCOL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Invalid customer settlement instructions by timestamp and
      ** front-office ID and front-office ID and timestamp
     FFFICSETL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFICSETD0:FFICSETX0)
     FFFICSETL1 UF   E           K DISK    INFSR(*PSSR) COMMIT
 
      ** API invalid log file
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFOTCOR012
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY includes the FF standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-------------------------------------------------------------------
 
      **-------------------------------------------------------------------
      ** The following /COPY line includes all the named constants
      ** used specifically in FF.
     D/COPY FFCPYSRC,NAMEDCONST
      **-------------------------------------------------------------------
 
     D/COPY QWINDSRC,FFTRANSDTA
 
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
     D  EndOfFile             01     01
     D  NoRecFnd              02     02
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     D @EI             S              1    DIM(60) INZ(*all'Y')
 
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
 
      ** Transaction Details - File Format
      ** ---------------------------------
 
      ** Current transaction in file format
     D CurTranFil    E DS                  EXTNAME(TRANSD)
 
      ** Valid transaction in file format
     D NewTranFil    E DS                  EXTNAME(FFVTRANPD)
     D                                     PREFIX(V)
 
      ** Transaction Details - Screen Format
      ** -----------------------------------
 
      ** Current transaction in screen format
     D CurTranScn    E DS                  EXTNAME(FFOTCOPD)
     D                                     PREFIX(@)
 
      ** New transaction in screen format
     D NewTranScn    E DS                  EXTNAME(FFOTCOPD)
     D  NewPBScn             269    294
 
      ** Dummy incoming Transaction in screen format
     D DummyTIn      E DS                  EXTNAME(FFOTCCPD)
 
      ** Transaction Details - OK Flags
      ** ------------------------------
 
      ** External data structure for transaction details OK flags
     D OKTransDet    E DS                  EXTNAME(FFEOTCOPD)
     D  OKPBFlag              44     52
 
      ** The OK flags for the OTCC transaction details
     D OKDummyDS     E DS                  EXTNAME(FFEOTCCPD)
     D                                     PREFIX(A)
 
      ** Customer and Broker Settlement Details - File Format
      ** ----------------------------------------------------
 
      ** Settlements in file format
     D CurTrstFil    E DS                  EXTNAME(TRSETD)
     D                                     PREFIX(ST)
 
      ** Valid settlement instructions; prefixed with VS for valid
      ** settlemnts.
     D NewTrstFil    E DS                  EXTNAME(FFVSETLPD) PREFIX(VS)
 
      ** Customer Settlement Details - Screen Format
      ** -------------------------------------------
 
      ** New Customer Settlement details in screen format
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
 
      ** Current Customer Settlement Details in Screen Format
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD) PREFIX(@)
 
 
      ** Broker Settlement Details - Screen Format
      ** -----------------------------------------
 
      ** New broker settlement details in screen format
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
 
      ** Current broker settlement details in screen format
     D CurBrStScn    E DS                  EXTNAME(FFBSETPD)
     D                                     PREFIX(@)
 
      ** Settlement Details - OK Flags
      ** -----------------------------
 
      ** External data structure for broker settlement flags
     D OKBrokSet     E DS                  EXTNAME(FFEBSETPD)
 
      ** External data structure for customer settlement flags
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
 
      ** Market details DS (MK=MarKet)
     D MarketDet     E DS                  EXTNAME(MARKT) PREFIX(MK)
 
      ** Current Instrument types
     D CInstType     E DS                  EXTNAME(INTYP)  PREFIX(CT)
 
      ** New Instrument types
     D NInstType     E DS                  EXTNAME(INTYP)  PREFIX(IT)
 
      ** FF Extension data (OTCs) - File (D/B) format
     D ExtData       E DS                  EXTNAME(FFOTEXPD)
 
 
      ** Standing Data files
      ** -------------------
      ** passed as data structures to lower level modules.
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
     ** Trading details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Portfolio Management ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
     ** Retail ICD
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  QQACC3       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Futures and Options ICD
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  QQACC4       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** EXTERNAL DS FOR API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** External DS SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  WLCD         E                     EXTFLD(LCD)
 
      ** Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for data area SC24X7
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Data structure for data area SDSTAT
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** ------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('FFOTCOPD')
 
     D Field           S             10A   INZ('NACTN')
 
     D FieldNo         S              5P 0
 
     D FldOffset       S              5P 0
 
      ** End of fields for getting starting field number
      ** ------------------------------------------------------------------
 
      ** The current trading date
     D CTDATE          S                   LIKE(BJRDNB)
 
      ** Enhanced OTCs feature flag & CFF007 flag
     D CFF001          S              1A
     D CFF007          S              1A
 
      ** --- Parameters for ZATRNRTV --------------------------------------
      ** Module ID
     D Module          S              2A   INZ('FF')
 
      ** Transaction type (dummy field as it is not needed for FF)
     D DummyTRTY       S              1A
      ** --- End of parameters for ZATRNRTV -------------------------------
 
      ** Customer/Broker Flag (B = Broker, C = Customer)
     D CustBrokFl      S              1A
 
      ** Customer or broker number
     D*CustBrokNo      S              6S 0                                                    CSD027
     D CustBrokNo      S              6A                                                      CSD027
 
      ** Flags to indicate that the customer settlements
      ** are in error.
     D CustSetErr      S              1A   INZ('N')
 
      ** Flags to indicate that the customer charges and
      ** commission fields are in error.
     D CustCCErr       S              1A   INZ('N')
 
      ** Flag to indicate that the FFOTCCRTV is not being called
      ** as a linked enquiry.
     D LinkEnq         S              1A   INZ('N')
 
      ** Customer/Broker Flag (Y = Broker, N = Customer)
     D BrokerFlag      S              1A   INZ('N')
 
      ** Flag to indicate that the transaction number was automatically
      ** generated
     D AutoTran        S              1A   INZ('N')
 
      ** Error flag array start position of the customer settlement
      ** instructions flags
     D CSetStart       S              5P 0
 
      ** Record length
     D RecordLen       S              5P 0
 
      ** File name (for UTGETRCDLN)
     D FileName        S             10A
 
      ** File library (for UTGETRCDLN)
     D FileLib         S             10A   INZ('*LIBL')
 
      ** Dummy market and instrument fields to pass as blanks to
      ** procedures which need them.
     D DummyMark       S              2A
     D DummyInst       S              3A
 
      ** (imported from module FFVOTCCTYP)
     D NewInst         S              1A   IMPORT
 
      ** Flag to indicate that an amendment is legitimate
     D AmendOK         S              1A
 
      ** Screen Mode ('1' for transaction screen & '2' for plato screen)
     D PScnMode        S              1A   INZ('1')
 
     D WScrn           S              1A
     D WReDisplay      S              1A
     D WDtaSubs1       S              1A
     D WDtaSubs2       S              1A
 
      ** PB customer indicator - Customer
     D PPBFLG          S              1A
 
      ** PB customer indicator - Broker
     D PPBBFLG         S              1A
 
      ** Market
     D PMRKT           S              2A
 
      ** Instrument
     D PISTC           S              3A
 
      ** CSC011 enhancement
     D CSC011          S              1A   INZ('N')
 
      ** Work field for Message type
     D WMTYP           S                   LIKE(APMTYP)
 
     D PSIDN           S              6
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D PRTCD           S              7                                                       CGL014
     D POPTN           S              7                                                       CGL014
     D PSARD           S              6                                                       CGL014
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFOTCOR001
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FFOTCOR002
 
      ** Do screen: browse invalid transactions
 
     C                   IF        WScrn = 'B'
     C                   EXSR      SRRprBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOR003
 
      ** Read next browse subfile record
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOR004
 
      ** Do while screen: main details
     C                   DOW       WScrn = 'M'
     C                   EXSR      SRMainScn
     C                   ENDDO
 
      /COPY WNCPYSRC,FFOTCOR005
 
      ** Settlement details processing
     C                   DOW       WScrn = 'S'
     C                   EXSR      SRSettScn
     C                   ENDDO
 
      ** Private Banking Details
 
     C                   DOW       WScrn = 'P' and CFF007 = 'Y'
     C                   EXSR      SRPBScn
     C                   ENDDO
 
      /COPY WNCPYSRC,FFOTCOR006
 
      ** Screen: window
     C                   IF        WScrn = 'W'
     C                   EXSR      SRWindow
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOR007
 
      ** Screen: confirmation of input
     C                   IF        WScrn = 'C'
     C                   EXSR      SRCnfScn
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOR008
 
      ** Do file updates
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOR009
 
      ** Terminate program
 
     C                   IF        WScrn = 'T'
     C                   EVAL      *INLR = True
     C                   ENDIF
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFOTCOR010
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRprBrw - Browse invalid transactions
      *****************************************************************
     C     SRRprBrw      BEGSR
 
      ** Reset read next browse subfile record
 
     C                   MOVEL     *BLANK        WRdNB             1
 
      ** Build browse subfile
 
     C                   CALLB     'FFOTCORPB'
 
      ** Inputs
      ** ------
 
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Build subfile
      ** Read subfile record
 
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANK        @RDSFL            1
 
      ** Error in update of previous deal
 
     C                   PARM                    @ERRUP            1
 
      ** Outputs
      ** -------
 
      ** Error message
 
     C                   PARM      *BLANK        @ERRMS            7
 
      ** Option selected
      ** Action selected
 
     C                   PARM                    @OPSEL            1
     C                   PARM                    @ACSEL            1
 
      ** FO transaction ID selected
 
     C                   PARM                    @FOTRANSEL       20
 
      ** Timestamp of transaction selected
 
     C                   PARM                    @TMESTPSEL
 
      ** Command keys
 
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      ** Successful Insert Deal Number
 
     C                   PARM                    PSIDN
 
      ** Enhancement CSC011
 
     C                   PARM                    CSC011
 
      ** Enhancement CSC022                                                                   CSC022
                                                                                              CSC022
     C                   PARM                    CSC022                                       CSC022
 
      ** If F3 or F12 taken in browse, or error message, end program
 
     C                   IF        @INKC = True or @INKL = True or
     C                             @ERRMS <> *BLANKS
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@B
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   EVAL      WRdNB = 'Y'
     C                   EVAL      WScrn = 'R'
 
     C     ESCRN@B       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdNBrw - Read next browse subfile record
      *****************************************************************
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
 
     C                   CALLB     'FFOTCORPB'
 
      ** Inputs
      ** ------
 
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Build subfile
      ** Read subfile record
 
     C                   PARM      *BLANK        @BDSFL            1
     C                   PARM      'Y'           @RDSFL            1
 
      ** Error in update of previous deal
 
     C                   PARM                    @ERRUP            1
 
      ** Outputs
      ** -------
 
      ** Error message
 
     C                   PARM      *BLANK        @ERRMS            7
      ** Option selected
      ** Action selected
 
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @ACSEL            1
 
      ** FO transaction ID selected
 
     C                   PARM      *BLANK        @FOTRANSEL       20
 
      ** Timestamp of transaction selected
 
     C                   PARM                    @TMESTPSEL
 
      ** Command keys
 
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      ** Successful Insert Deal Number
 
     C                   PARM                    PSIDN
 
      ** Enhancement CSC011
 
     C                   PARM                    CSC011
      ** Enhancement CSC022                                                                   CSC022
                                                                                              CSC022
     C                   PARM                    CSC022                                       CSC022
 
      ** If F3 taken within invalid transaction deletion function,
      ** End program
 
     C                   IF        @INKC = True
     C                   EXSR      ENDP
     C                   GOTO      ERDNBRW
     C                   ENDIF
 
      ** If invalid transaction read from subfile
 
     C                   IF        @OPSEL <> *BLANK
 
      ** Blank the main details screen
 
     C                   EVAL      NewTranScn = *BLANKS
     C                   EVAL      SPREM      = *BLANKS
     C                   EVAL      FFSTS      = *BLANKS
 
      ** Reset errors
 
     C                   EVAL      OKTransDet = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIdArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
     C                   EVAL      WFldNamArr  = *BLANKS
     C                   EVAL      WMsgIdArr   = *BLANKS
     C                   EVAL      WMsgDtaArr  = *BLANKS
 
      ** Retrieve transaction details
 
     C                   MOVEL     @ACSEL        NACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
 
      ** Make sure Invalid transaction's  details are passed to 'Retrieve'
      ** module for SPF checking .
 
     C     ZATRNKX0      CHAIN     FFIOTCOL0                          02
 
      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).
 
     C                   IF        NACTN = 'I'
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   IF        NTNBR = *BLANK
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      @@MODE = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRRtvTrn
 
      ** If transaction details were retrieved,
      ** put the transaction on the main details screen
 
     C                   IF        RECI <> *BLANK and NACTN <> 'I'
     C                   EXSR      PUTD@M
     C                   ENDIF
 
      ** Now overwrite the fields on the main details screen with those
      ** on the invalid transactions file (except for the Midas transaction
      ** number and Midas associated transaction number retrieved above
      ** using the front office transaction and associated transaction IDs).
      ** Access invalid transaction with timestamp and front office
      ** transaction ID.
 
     C                   MOVEL     NTNBR         ##STNBR           6
 
     C     ZATRNKX0      CHAIN     FFIOTCOL0                          02
 
     C                   IF        RECI <> *BLANK and NACTN <> 'I'
     C                   EVAL      NTNBR = ##STNBR
     C                   ENDIF
 
      ** Access invalid transaction settlement instructions
 
      ** ... customer
 
     C                   CLEAR                   NewCuStScn
     C     ZATRNKX0      CHAIN     FFICSETX0                          02
 
      ** If transaction details were retrieved and this is an amendment
      ** Do data substitution if the substitution character is present
 
     C                   IF        RECI <> *BLANK and NACTN = 'A' and
     C                             GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      NewTranScn                             02
 
     C                   IF        NoRecFnd = True
     C                   EVAL      WDtaSubs1 = 'Y'
     C                   ELSE
     C                   EVAL      WDtaSubs1 = 'N'
     C                   ENDIF
 
     C     GHSUBS        SCAN      NewCuStScn                             02
 
     C                   IF        NoRecFnd = True
     C                   EVAL      WDtaSubs2 = 'Y'
     C                   ELSE
     C                   EVAL      WDtaSubs2 = 'N'
     C                   ENDIF
 
     C                   IF        WDtaSubs1 = 'Y' or WDtaSubs2 = 'Y'
     C                   EXSR      TDtDtaSubs
     C                   ENDIF
 
     C                   ENDIF
 
      ** If action code, or transaction number were NOT OK
      ** blank out action code so that the input cannot proceed
 
     C                   IF        OKACTN = 'N' or OKTNBR = 'N'
     C                   EVAL      NACTN = *BLANK
     C                   ENDIF
 
      ** Send the transactions error messages to the main details screen
 
     C                   EXSR      SNDM@M
 
      ** Go to main details screen
 
     C                   EVAL      WScrn = 'M'
 
      ** Else if no invalid transaction read from subfile
 
     C                   ELSE
 
      ** Go to browse screen
 
     C                   EVAL      WScrn = 'B'
 
     C                   ENDIF
 
     C     ERDNBRW       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
 
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
 
     C                   IF        OKACTN = 'N' or OKTNBR = 'N'
     C                   EVAL      E = E + 1
     C                   EVAL      FldNameArr(E) = '*ANY'
     C                   EVAL      MsgIdArr(E) = 'APM0110'
     C                   ENDIF
 
      ** Initialize error indicators
 
     C                   EVAL      @EI = *ALL'Y'
     C                   MOVEA     OKTransDet    @EI
 
      ** Read error messages for transaction
 
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             01
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C                   DOW       EndOfFile = False
 
     C                   EVAL      E = E + 1
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffset     F
 
     C                   IF        F < 1 or F > 60
     C                   Z-ADD     1             F
     C                   ENDIF
 
     C                   MOVE      'N'           @EI(F)
     C     ZATRNKD0      READE     ZATRNERRD0                             01
 
     C                   ENDDO
 
      ** Put the extracted OK flags into the relevant OK flags data
      ** structures.
 
     C                   MOVEA     @EI           OKTransDet
     C                   MOVEA     @EI(CSetStart)OKCustSet
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMainScn - Process screen: main details
      *****************************************************************
 
     C     SRMainScn     BEGSR
 
      ** Issue rollback to clear any possible updates in window function
 
     C                   IF        BGWDPR = 'Y'
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   ENDIF
 
      ** Reset the transaction-number-automatically-generated flag
 
     C                   RESET                   AutoTran
 
      ** Enable/disable detail fields on main details screen
      ** if changes to the data are allowed
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'I', 'A', or 'D')
 
     C                   IF        NACTN = 'I' and @OPSEL = 'U' or
     C                             NACTN = 'A' and @OPSEL = 'U'
     C                   EVAL      @EDTFD = 'Y'
     C                   ELSE
     C                   EVAL      @EDTFD = 'N'
     C                   ENDIF
 
      ** KJ = COMMAND KEY 10 = CONFIRM DELETE
 
     C                   IF        NACTN = 'D'
     C                   EVAL      @EINKJ = 'Y'
     C                   ELSE
     C                   EVAL      @EINKJ = 'N'
     C                   ENDIF
 
      ** WRITE/READ DISPLAY SCREEN
 
     C                   CALLB     'FFOTCODSP'
 
      ** Return Code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Input Parameters
      ** ----------------
 
      ** Transaction (in screen format)
 
     C                   PARM                    NewTranScn
     C                   PARM                    NewCuStScn
 
 
      ** Premium
      ** Transaction status
 
     C                   PARM                    SPREM
     C                   PARM                    FFSTS            24
 
      ** Fields in error
 
     C                   PARM                    OKTransDet
     C                   PARM                    OKCustSet
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
      ** Enabled function keys
      ** KG = Command key 07 = Read prevoius
      ** KH = Command key 08 = Read next
      ** KJ = Command key 10 = Confirm delete
      ** KP = Command key 15 = Browse
 
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKP            1
 
      ** Successful insert transaction
 
     C                   PARM                    @SIDN             6
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Standing Data
      ** -------------
 
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
 
      ** CFF001 and CFF007 enhancements
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Screen Mode
      ** -----------
 
     C                   PARM                    PScnMode
 
      ** Output Parameters
      ** -----------------
      ** Function Keys
 
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
 
      ** Save warning message ids array of this screen.
 
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
 
      ** Reset Errors
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      OKTransDet = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
     C                   EVAL      @SIDN = *BLANKS
 
     C                   SELECT
 
      ** CK/3 - End Program
 
     C                   WHEN      @INKC = '1'
     C                   EXSR      ENDP
 
      ** CK/12 - Cancel on Main Details Screen
 
     C                   WHEN      @INKL = '1'
     C                   IF        PScnMode = '1'
     C                   EXSR      CANC@M
     C                   ELSE
     C                   IF        CFF007 = 'Y' and BGN4ST = 'Y'
     C                   EVAL      WScrn = 'P'
     C                   ELSE
     C                   EVAL      PScnMode = '1'
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
     C                   ENDIF
 
      ** If CK/10 taken, go onto updates
 
     C                   WHEN      @INKJ =  '1'
 
      ** Update transaction in File Format
      ** Update transaction settlement details in File Format
 
     C                   MOVEL     CurTranFil    NewTranFil
     C                   MOVEL     CurTrstFil    NewTrstFil
     C                   MOVEL     CInstType     NInstType
 
     C                   EVAL      WScrn = 'U'
 
      ** Validate input to Main Details Screen
 
     C                   OTHER
     C                   EXSR      VAL@M
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRClear - Clear variables and data structures
      *****************************************************************
 
     C     SRClear       BEGSR
 
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   EVAL      OKTransDet = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
 
     C                   IF        PScnMode = '1'
     C                   CLEAR                   NewTranFil
     C                   CLEAR                   NewTrstFil
 
      ** Zeroise all non-blank field for TranFlFmt
 
     C                   EVAL      VTNBR = 0
     C**********         EVAL      VBOCO = 0                                                  CSD027
     C**********         EVAL      VCUSC = 0                                                  CSD027
     C                   EVAL      VBOCO = *BLANKS                                            CSD027
     C                   EVAL      VCUSC = *BLANKS                                            CSD027
     C                   EVAL      VYRNO = 0
     C                   EVAL      VMTHN = 0
     C                   EVAL      VSTRP = 0
     C                   EVAL      VTRSD = 0
     C                   EVAL      VNUCO = 0
     C                   EVAL      VNOCO = 0
     C                   EVAL      VNOBO = 0
     C                   EVAL      VCOPR = 0
     C                   EVAL      VLNKR = 0
     C                   EVAL      VCLSR = 0
     C                   EVAL      VFCDA = 0
     C                   EVAL      VLCD  = 0
     C                   EVAL      VTNLU = 0
     C                   EVAL      VORED = 0
     C                   EVAL      VVALD = 0
     C                   EVAL      VMABK = 0
     C                   EVAL      VMACU = 0
     C                   EVAL      VCUUN = 0
     C                   EVAL      VUNPL = 0
     C                   EVAL      VUPLS = 0
     C                   EVAL      VPLSPTP = 0
     C                   EVAL      VCENT = 0
 
      ** Zeroise all non-blank field for TrStFlFmt
 
     C                   EVAL      VSTNBR = 0
     C                   EVAL      VSOCSB = 0
     C                   EVAL      VSOCDB = 0
     C                   EVAL      VSCCSB = 0
     C                   EVAL      VSCCDB = 0
     C                   EVAL      VSCPSB = 0
     C                   EVAL      VSCPDB = 0
     C                   EVAL      VSOCSC = 0
     C                   EVAL      VSOCDC = 0
     C                   EVAL      VSCCSC = 0
     C                   EVAL      VSCCDC = 0
     C                   EVAL      VSCCSC = 0
     C                   EVAL      VSCCDC = 0
     C                   EVAL      VSCPSC = 0
     C                   EVAL      VSCPDC = 0
     C                   EVAL      VSNCCP = 0
     C                   EVAL      VSPRMP = 0
     C                   EVAL      VSBCMC = 0
     C                   EVAL      VSBCMS = 0
     C                   EVAL      VSBCMA = 0
     C                   EVAL      VSBCHC = 0
     C                   EVAL      VSBCHA = 0
     C                   EVAL      VSBMAR = 0
     C                   EVAL      VSBSLT = 0
     C                   EVAL      VSBCHP = 0
     C                   EVAL      VSBCMP = 0
     C                   EVAL      VSCCMC = 0
     C                   EVAL      VSCCMS = 0
     C                   EVAL      VSCCMA = 0
     C                   EVAL      VSCCHC = 0
     C                   EVAL      VSCCHA = 0
     C                   EVAL      VSCMAR = 0
     C                   EVAL      VSCSLT = 0
     C                   EVAL      VSCCHP = 0
     C                   EVAL      VSCCMC = 0
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - Validate input to main details screen
      *****************************************************************
 
     C     VAL@M         BEGSR
 
      ** Retrieve Transaction details
 
     C                   EVAL      @@MODE = *BLANKS
     C                   EXSR      SRRtvTrn
 
      ** If action code or transaction number are NOT OK
      ** Re-output screen with error messages on it
 
     C                   IF        OKACTN = 'N' OR OKTNBR = 'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** If insert or amend
      ** ------------------
 
     C                   IF        NACTN = 'I' OR NACTN = 'A'
 
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Transaction in File Format
 
     C                   EXSR      SRClear
 
      ** If Amemd
      ** --------
 
     C                   IF        NACTN = 'A' and PScnMode = '1'
 
      ** Update Transaction in File Format
      ** Update transaction settlement details in File Format
 
     C                   EVAL      NewTranFil = CurTranFil
     C                   EVAL      NewTrstFil = CurTrstFil
 
      ** Validate whether non-amendable fields have been changed
 
     C                   CALLB     'FFOTCOAMD'
 
      ** Input Parameters
      ** ----------------
      ** Return Code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** New transaction in Screen Format
      ** New Customer Settlement deatils in screen format
      ** Current transaction in Screen Format
      ** Current Customer Settlement Details in Screen Format
      ** Reset of Fields in Error Required (Y/N)
 
     C                   PARM                    NewTranScn
     C                   PARM                    NewCuStScn
     C                   PARM                    CurTranScn
     C                   PARM                    CurCuStScn
     C                   PARM      'Y'           @@RSTE            1
 
      ** Current transaction in file format
 
     C                   PARM                    CurTranFil
 
      ** Standing Data ICD
      ** -----------------
 
      ** SDBANKPD
      ** Midas modules
      ** General Ledger ICD
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
 
      ** Switchable feature
      ** ------------------
 
      ** O.T.C. instrument switchable field
      ** Futures and Option Enhancement (CFF007)
      ** Portfolio Management Details
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
     C                   PARM                    SDPORT
 
      ** Output Parameters
      ** -----------------
      ** Transaction Details OK flags(DS) from/to caller
      ** Customer Settlement OK flags(DS) from/to caller
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    OKTransdet
     C                   PARM                    OKCustSet
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Amendments OK
 
     C                   PARM                    AmendOk
 
     C                   ENDIF
 
      ** If errors returned by the amend function, do not do validation
      ** processing.
 
     C                   IF        Idx = 0
 
      ** Validate Transaction details
      ** ----------------------------
 
     C                   CALLB     'FFOTCOVAL'
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
 
     C                   PARM                    RespMode
 
      ** Screen details from incoming transactions
      ** Extension file data
 
     C                   PARM                    NewTranScn
     C                   PARM                    ExtData
 
      ** Standing data ICD
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
     C                   PARM                    SDFODA
     C                   PARM                    SDDEAL
     C                   PARM                    SDPORT
 
      ** O.T.C. instrument switchable field & CFF007
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Screen mode ('1' = Transaction screen and '2' = Plato Screen)
 
     C                   PARM                    PScnMode
 
      ** Output Parameters
      ** -----------------
 
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning flds/message IDs/message data (arrays) from/to caller
      ** Warning array index (3P0) from/to caller
      ** Screen error indicators
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    OKTransDet
 
      ** FF Non-currency OTC for file update - detail file format
      ** The branch details format (from SDBRCHPD via MMVBKGBRCH)
      ** The current trading date (Midas day number)
      ** Instrument details (DS based on INTYPD)
      ** Premium
 
     C                   PARM                    NewTranFil
     C                   PARM                    SDBRCH
     C                   PARM                    CTDATE
     C                   PARM                    NInstType
     C                   PARM                    SPREM
     C                   PARM                    PPBFLG                                       222373
     C                   PARM                    S01457                                       214057
 
     C                   ENDIF
      ** (End of "If no errors returned by amend")
 
      ** If errors returned
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      EVAL@M
     C                   ENDIF
 
     C                   IF        PScnMode = '1'
 
      ** Continue to settlements screen
 
     C                   EVAL      WScrn = 'S'
 
     C                   ELSE
 
      ** Reset PScnMode back to transaction mode
 
     C                   EVAL      PScnMode = '1'
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
 
      ** Otherwise continue to the confirmation screen
 
     C                   IF        @OPSEL <> 'N'                                             BUG9078
     C                   EVAL      WScrn = 'C'
     C                   ELSE                                                                BUG9078
     C                   IF        WRdNb = 'Y'                                               BUG9078
     C                   EVAL      WScrn = 'R'                                               BUG9078
     C                   ELSE                                                                BUG9078
     C                   EVAL      WScrn = 'B'                                               BUG9078
     C                   ENDIF                                                               BUG9078
     C                   ENDIF                                                               BUG9078
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPBScn - Process Screen: Private Banking Details
      *****************************************************************
 
     C     SRPBScn       BEGSR
 
      ** Write/read display screen
 
     C                   CALLB     'FFOTCO2DP'
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Transaction (in screen format)
 
     C                   PARM                    NewTranScn
 
      ** Premium
 
     C                   PARM                    SPREM
     C                   PARM                    NewInst
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
 
      ** Fields in error
 
     C                   PARM                    OKTransDet
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Option selected
 
     C                   PARM                    @OPSEL
 
      ** Output
      ** ------
      ** Function keys
 
     C                   PARM                    @INKC
     C                   PARM                    @INKL
 
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
     C                   SELECT
 
      ** CK/3 - End Program
 
     C                   WHEN      @INKC = '1'
     C                   EXSR      ENDP
 
      ** CK/12 - Cancel on Private Banking Screen
 
     C                   WHEN      @INKL = '1'
     C                   EVAL      PScnMode = '1'
     C                   EVAL      WScrn = 'M'
 
      ** Validate input to private banking detail screen
 
     C                   OTHER
     C                   EXSR      VAL@P
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@P  - Validate input for Private Banking Details
      *****************************************************************
 
     C     VAL@P         BEGSR
 
      ** If Enquire
 
     C                   IF        NACTN = 'E'
 
      ** If Plato (BGN2ST) is on and PScnMode = '1'
 
     C                   IF        BGN2ST = 'Y' and PScnMode = '1'
     C                   EVAL      PScnMode = '2'
     C                   EVAL      WScrn = 'M'
     C                   ELSE
 
      ** If windows processing on, call window routine
      ** If browse outstanding, read next browse subfile record
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
     C                   IF        WRdNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   GOTO      EVAL@P
     C                   ENDIF
 
      **---------------------------------------------------------------
      ** If Insert or Amend
 
     C                   IF        NACTN = 'I' OR NACTN = 'A'
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
 
      ** If errors returned by the amend function, do not do validation
      ** processing.
 
     C                   IF        Idx = 0
     C                   EVAL      WReDisplay = 'N'
 
     C                   IF        NCOVE = *BLANKS or NHETR = *BLANKS or
     C                             NBLUP = *BLANKS
     C                   EVAL      WReDisplay = 'Y'
     C                   ENDIF
 
     C                   IF        NewInst = 'Y' and BGSECS = 'Y'
     C                   IF        NTECO = *BLANKS or NTNAT = *BLANKS or
     C                             NCRIK = *BLANKS or NCCYR = *BLANKS or
     C                             NTWEI = *BLANKS
     C                   EVAL      WReDisplay = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Transaction details
 
     C                   CALLB     'FFOTCC2VL'
 
      ** Outputs
      ** -------
 
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    OKDummyDS
     C                   PARM                    OKTransDet
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    NewTranFil
     C                   PARM                    NInstType
 
      ** Inputs
      ** ------
 
     C                   PARM                    DummyTIn
     C                   PARM                    NewTranScn
     C                   PARM                    NewInst
 
      ** ICD
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
     C                   PARM                    SDFODA
     C                   PARM      'OTCO'        TransType
 
     C                   IF        WReDisplay = 'Y'
     C                   GOTO      EVAL@P
     C                   ENDIF
 
     C                   ENDIF
 
      ** If errors returned
 
     C                   IF        Idx <> 0
     C                   GOTO      EVAL@P
     C                   ENDIF
 
     C                   ENDIF
 
      **---------------------------------------------------------------
 
      ** If Plato (BGN2ST) is on and PScnMode = '1'
 
     C                   IF        BGN2ST = 'Y' and PScnMode = '1' or
     C                             PScnMode = '2'
     C                   EVAL      PScnMode = '2'
     C                   EVAL      WScrn = 'M'
     C                   ELSE
 
      ** Continue to windows screen
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
 
      ** Otherwise continue to the confirmation screen
 
     C                   IF        @OPSEL <> 'N'                                             BUG9078
     C                   EVAL      WScrn = 'C'
     C                   ELSE                                                                BUG9078
     C                   IF        WRdNb = 'Y'                                               BUG9078
     C                   EVAL      WScrn = 'R'                                               BUG9078
     C                   ELSE                                                                BUG9078
     C                   EVAL      WScrn = 'B'                                               BUG9078
     C                   ENDIF                                                               BUG9078
     C                   ENDIF                                                               BUG9078
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
     C     EVAL@P        ENDSR
 
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
      ** Outputs
      ** -------
 
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
      * SRWindow - Call Window Manager
      *****************************************************************
     C     SRWindow      BEGSR
 
      ** Reset errors
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      OKTransDet = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
 
      ** Write out screen to remove error messages
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCODSP'
 
      ** Input Parameters
      ** ----------------
      ** Return Code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Transaction (in screen format)
 
     C                   PARM                    NewTranScn
     C                   PARM                    NewCuStScn
 
      ** Premium
      ** Transaction status
 
     C                   PARM                    SPREM
     C                   PARM                    FFSTS            24
 
      ** Fields in error
 
     C                   PARM                    OKTransdet
     C                   PARM                    OKCustSet
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
      ** Enabled function keys
      ** KG = Command key 07 = Read prevoius
      ** KH = Command key 08 = Read next
      ** KJ = Command key 10 = Confirm delete
      ** KP = Command key 15 = Browse
 
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKP
 
      ** Successful insert transaction
 
     C                   PARM                    @SIDN
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Standing Data
      ** -------------
 
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
 
      ** CFF001 and CFF007 enhancements
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Screen Mode
      ** -----------
 
     C                   PARM                    PScnMode
 
      ** Output Parameters
      ** -----------------
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKG
     C                   PARM      '0'           @INKH
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKP
 
     C/COPY QWINDSRC,FFTRANSMV1
 
     C                   CALL      'WN0010'
     C                   PARM      'FFOTCORPR'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      NACTN         ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
 
      ** Process returned command keys
 
     C                   IF        #RTRN = 'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
 
      ** If Cmd12 pressed, or in enquiry, return to main details screen;
      ** otherwise, go to settlements screen
 
     C                   IF        #RTRN = 'USR0790' or NACTN = 'E'
 
      ** Reset PScnMode to main detail screen
 
     C                   EVAL      PScnMode = '1'
 
     C                   IF        WRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'M'
 
     C                   IF        BGN2ST = 'Y' and PScnMode = '1'
     C                   EVAL      PScnMode = '2'
     C                   ELSE
     C                   IF        CFF007 = 'Y' and BGN4ST = 'Y'
     C                   EVAL      WScrn = 'P'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        NACTN = 'D'
     C                   EVAL      WScrn = 'U'
     C                   ELSE
     C                   IF        @OPSEL <> 'N'                                             BUG9078
     C                   EVAL      WScrn = 'C'
     C                   ELSE                                                                BUG9078
     C                   IF        WRdNb = 'Y'                                               BUG9078
     C                   EVAL      WScrn = 'R'                                               BUG9078
     C                   ELSE                                                                BUG9078
     C                   EVAL      WScrn = 'B'                                               BUG9078
     C                   ENDIF                                                               BUG9078
     C                   ENDIF                                                               BUG9078
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     WIND          ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvTrn - Retrieve transaction
      *****************************************************************
 
     C     SRRtvTrn      BEGSR
 
     C                   CALLB     'FFOTCCRTV'
 
      ** Return code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Input Parameters
      ** ----------------
 
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface) (6A)
 
     C                   PARM                    @@MODE            6
 
      ** Response mode (1A)
 
     C                   PARM      'S'           @@RSMD            1
 
      ** Action Code (1A)
      ** Front Office Transaction ID (20A)
      ** (Midas) Transaction Number (6A)
      ** Module being called as linked enquiry (1A)
 
     C                   PARM                    NACTN
     C                   PARM                    FOTRID           20
     C                   PARM                    NTNBR
     C                   PARM                    LinkEnq
 
      ** Standing Data
      ** -------------
 
      ** Bank details ICD
      ** General Ledger ICD
      ** Multibranching indicator
 
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    BGMBIN
 
      ** Transaction type
 
     C                   PARM      'OTCO'        TransType
 
      ** Outputs
      ** -------
 
      ** (Current) transaction in file format
      ** (Current) Settlements in file format
      ** Instrument Types
      * OK - Action code (1A)
      * OK - Transaction Number (1A)
 
     C                   PARM                    CurTranFil
     C                   PARM                    CurTrstFil
     C                   PARM                    CInstType
     C                   PARM      *BLANK        OKACTN
     C                   PARM      *BLANK        OKTNBR
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - Put a transaction on the main details screen
      *****************************************************************
 
     C     PUTD@M        BEGSR
 
      ** Call program to fill screen fields with data from TRANSD
 
     C                   CALLB     'FFOTCOCVT'
 
      ** Inputs
      ** ------
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Transaction in file format
      ** Instrument types
 
     C                   PARM                    CurTranFil
     C                   PARM                    CInstType
 
      ** Standing Data
 
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
 
      ** CFF001 and CFF007 enhancements
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Outputs
      ** -------
 
      ** Transaction in screen format
 
     C                   PARM                    NewTranScn
 
      ** Premium
      ** Transaction Status
 
     C                   PARM                    SPREM            15
     C                   PARM                    FFSTS            24
 
 
     C                   EVAL      CustBrokFl = 'C'
 
      ** Call program to fill screen fields with data from TRSETD
 
     C                   CALLB     'FFSETLCVT'
 
      ** Outputs
      ** -------
 
      ** Return code (10A, returned to caller)
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Customer settlement instructions, screen format
      ** Broker settlement instructions, screen format
 
     C                   PARM                    NewCuStScn
     C                   PARM                    NewBrStScn
 
      ** Inputs
      ** ------
 
      ** Settlements in file format
 
     C                   PARM                    CurTrstFil
 
      ** Customer/broker flag (1A)
      ** Midas Transaction Number
      ** Instrument currency
 
     C                   PARM                    CustBrokFl
     C                   PARM                    NTNBR
     C                   PARM                    ISCY
 
      ** Update 'Current' Deal with Deal in Screen Format
 
     C                   EVAL      CurTranScn = NewTranScn
     C                   EVAL      CurCuStScn = NewCuStScn
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** Else, return to the browse screen
 
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSettScn -  Not exactly a separate screen but the bottom     *
      *              half of the main details input screen.           *
      *              This validates the charges and commission        *
      *              details and applies default settlement           *
      *              instructions if none have been applied;          *
      *              otherwise settlement details are converted and   *
      *              validated.                                       *
      *****************************************************************
 
     C     SRSettScn     BEGSR
 
      ** This routine is called if none of the settlement fields have been
      ** entered.
 
     C                   IF        NewCuStScn = *BLANK
 
      ** Default customer instructions
 
     C                   EVAL      CustBrokFl = 'C'
     C**********         MOVE      *ZERO         CustBrokNo                                   CSD027
     C                   EVAL      CustBrokNo = *BLANKS                                       CSD027
     C                   MOVEL     NCUSC         CustBrokNo
 
     C                   CALLB     'FFSETLDFT'
 
      ** Outputs
      ** -------
 
      ** Return code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Broker settlement instructions
      ** Customer settlement instructions
 
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
 
      ** Inputs
      ** ------
 
      ** Customer/broker flag
 
     C                   PARM                    CustBrokFl
      ** Customer or broker number
      ** Market centre
      ** Instrument code
 
     C                   PARM                    CustBrokNo
     C                   PARM                    DummyMark
     C                   PARM                    DummyInst
 
      ** Transaction type (purchase or sale) (1A)
 
     C                   PARM                    NTRTY
 
      ** Enhanced OTCs feature flag
 
     C                   PARM                    CFF001
 
     C                   ENDIF
 
      ** (End of "If no settlement instructions entered")
 
      ** Validate the customer charge and commission details
 
     C                   EXSR      ValChgCom
 
      ** Validate customer settlement instructions
 
     C                   RESET                   CustSetErr
 
     C                   EVAL      CustBrokFl = 'C'
     C                   RESET                   ReturnCode
 
     C                   CALLB     'FFSETLVAL'
 
      ** Outputs
      ** -------
 
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Field name array (<WArrMax> x 10A, returned to caller)
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamWArr
     C                   PARM                    MsgIDWArr
     C                   PARM                    MsgDtaWArr
 
      ** The valid settlements file format (data structure, from FFVSETLPD)
 
     C                   PARM                    NewTrstFil
 
      ** Inputs
      ** ------
 
      ** Data structure containing broker settlement details
      ** Data structure containing customer settlement details
 
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
 
      ** Data structure containing broker settlement OK flags
      ** Data structure containing customer settlement OK flags
 
     C                   PARM                    OKBrokSet
     C                   PARM                    OKCustSet
 
      ** Customer/ Broker flag (1A)
 
     C                   PARM                    CustBrokFl
 
      ** Branch code (3A, from transaction)
      ** Portfolio reference (4A)
      ** Instrument currency (3A)
      ** Trade date in Midas day number format (5,0P)
      ** Broker Code (6S,0 from FFVTRANPD)
      ** Customer Code (6S,0 from FFVTRANPD)
 
     C                   PARM                    NBRCD
     C                   PARM                    NPTFR
     C                   PARM                    VISCY
     C                   PARM                    VTRSD
     C                   PARM                    VBOCO
     C                   PARM                    VCUSC
 
      ** Branch internal customer number (from SDBRCHPD)
      ** Current trading date
 
     C                   PARM                    A8BICN
     C                   PARM                    CTDATE
 
      ** Standing Data
      ** -------------
 
      ** Bank Details ICD
      ** General Ledger ICD
      ** Midas Modules ICD
      ** Trading ICD
      ** Portfolio Management ICD
      ** Retail ICD
 
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
     C                   PARM                    SDTRAD
     C                   PARM                    SDPORT
     C                   PARM                    SDRETL
 
      ** CFF007 enhancement
      ** PB customer indicator - Broker
      ** PB customer indicator - Customer
      ** Collaterals Processing enhancement                                                   CGL014
 
     C                   PARM                    CFF007
     C                   PARM                    PPBBFLG
     C                   PARM                    PPBFLG
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure or warning
 
     C                   IF        ReturnCode <> *BLANKS
 
     C                   IF        ReturnCode = 'Error'
     C                   EVAL      CustSetErr = 'Y'
     C                   ENDIF
 
     C                   IF        ReturnCode = 'ErrAndWarn'
     C                   EVAL      CustSetErr = 'Y'
     C                   ENDIF
 
     C                   IF        ReturnCode = 'Warning'
     C                   EVAL      CustSetErr = 'W'
     C                   ENDIF
 
      ** Append the array details from the above call onto the general
      ** error arrays
 
     C                   EXSR      AppendArrs
 
     C                   ENDIF
 
     C                   IF        CustSetErr = 'W'
 
     C                   Z-ADD     1             WIdx
     C                   EVAL      WReDisplay = *BLANK
 
     C                   DOW       WMsgIdArr(WIdx) <> *BLANKS and
     C                             WReDisplay = *BLANK or
     C                             WPrvWarnAr(WIdx) <> *BLANKS and
     C                             WReDisplay = *BLANK
 
     C                   IF        WMsgIdArr(WIdx) <> WPrvWarnAr(WIdx)
     C                   EVAL      WReDisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIdx = WIdx + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   Z-ADD     0             WIdx
 
      ** Reset Errors
 
     C                   IF        CustSetErr = 'W' and WReDisplay = *BLANK
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      OKTransDet = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
     C                   ENDIF
 
     C                   ENDIF
 
      * If settlement or charge and commission details invalid,
      * return to main details screen.
     C                   IF        CustSetErr = 'Y' or CustCCErr = 'Y' or
     C                             CustSetErr = 'W' and WReDisplay = 'Y'
 
     C                   EVAL      WScrn = 'M'
 
     C                   ELSE
 
      ** Continue to Private Banking Screen
 
     C                   IF        CFF007 = 'Y' and BGN4ST = 'Y'
     C                   EVAL      WScrn = 'P'
     C                   ELSE
 
      ** If Plato (BGN2ST) is on and PScnMode = '1'
 
     C                   IF        BGN2ST = 'Y' and PScnMode = '1'
     C                   EVAL      PScnMode = '2'
     C                   EVAL      WScrn = 'M'
     C                   ELSE
 
      ** Otherwise, if windows on, show windows screen
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
 
      ** Otherwise continue to the confirmation screen
 
     C                   IF        @OPSEL <> 'N'                                             BUG9078
     C                   EVAL      WScrn = 'C'
     C                   ELSE                                                                BUG9078
     C                   IF        WRdNb = 'Y'                                               BUG9078
     C                   EVAL      WScrn = 'R'                                               BUG9078
     C                   ELSE                                                                BUG9078
     C                   EVAL      WScrn = 'B'                                               BUG9078
     C                   ENDIF                                                               BUG9078
     C                   ENDIF                                                               BUG9078
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCnfScn - Process screen: confirmation of input
      *            evoked for inserts, amends & authorizations
      *****************************************************************
 
     C     SRCnfScn      BEGSR
 
     C                   EVAL      PScnMode = '1'
 
      ** If transaction number not defined (on insert),
      ** get next available transaction number.
 
     C                   IF        NTNBR = *BLANK
 
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY
     C                   PARM                    NTNBR
     C                   PARM                    VTNBR
 
      ** End in error if generator returned an error
 
     C                   IF        ReturnCode <> *BLANK
     C                   EVAL      DBFILE = 'ZATRNRTV'
     C                   EVAL      DBKEY  = NTNBR
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set a flag to indicate that the transaction number was generated
      ** rather than entered.
 
     C                   EVAL      AutoTran = 'Y'
 
     C                   ENDIF
 
      ** If transaction is valid output message 'Press enter to accept'
 
     C                   EVAL      WFldNamArr(1) = '*ANY'
     C                   EVAL      WMsgIdArr(1)  = 'APM0121'
 
      ** Write/Read display screen
 
     C                   CALLB     'FFOTCODSP'
 
      ** Input Parameters
      ** ----------------
      ** Return Code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Transaction (in screen format)
 
     C                   PARM                    NewTranScn
     C                   PARM                    NewCuStScn
 
      ** Premium
      ** Transaction status
 
     C                   PARM                    SPREM            15
     C                   PARM                    FFSTS            24
 
      ** Fields in error
 
     C                   PARM                    OKTransDet
     C                   PARM                    OKCustSet
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
      ** Enabled function keys
      ** KG = Command key 07 = Read prevoius
      ** KH = Command key 08 = Read next
      ** KJ = Command key 10 = Confirm delete
      ** KP = Command key 15 = Browse
 
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKP            1
 
      ** Successful insert transaction
 
     C                   PARM                    @SIDN             6
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Standing Data
      ** -------------
 
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
 
      ** CFF001 and CFF007 enhancements
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Screen Mode
      ** -----------
 
     C                   PARM                    PScnMode
 
      ** Output Parameters
      ** -----------------
 
      ** Function Keys
 
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
 
      ** Reset Errors
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      OKTransDet = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
 
     C                   SELECT
 
      ** CK/3 - End Program
 
     C                   WHEN      @INKC = '1'
     C                   EXSR      ENDP
 
      ** CK/12 - Cancel on Main Details Screen
 
     C                   WHEN      @INKL = '1'
     C                   EXSR      CANC@C
 
      ** Exit confirmation screen
 
     C                   OTHER
     C                   EXSR      EXIT@C
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - Cancel on confirmation screen
      *****************************************************************
 
     C     CANC@C        BEGSR
 
      ** Return to main details screen
 
     C                   EVAL      WScrn = 'M'
 
      ** If F12 was pressed on the confirm screen, and the transaction number
      ** was automatically generated, blank it out and do a rollback to
      ** release the generated transaction number.
 
     C                   IF        AutoTran = 'Y'
     C                   CLEAR                   NTNBR
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - Exit from confirmation screen
      *****************************************************************
     C     EXIT@C        BEGSR
 
      ** Reset PScnMode back to transaction mode
 
     C                   EVAL      PScnMode = '1'
 
      ** If no errors in validation
 
     C                   IF        Idx = *ZERO
 
      ** Continue with updates
 
     C                   EVAL      WScrn = 'U'
 
      ** Else, return to main details screen
 
     C                   ELSE
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdate - Updates
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
      ** If transaction number not defined (on insert),
      ** get next available transaction number.
 
     C                   IF        NTNBR = *BLANK
 
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY
     C                   PARM                    NTNBR
     C                   PARM                    VTNBR
 
      ** End in error if generator returned an error
 
     C                   IF        ReturnCode <> *BLANK
     C                   EVAL      DBFILE = 'ZATRNRTV'
     C                   EVAL      DBKEY  = NTNBR
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set a flag to indicate that the transaction number was generated
      ** rather than entered.
 
     C                   EVAL      AutoTran = 'Y'
 
     C                   ENDIF
 
      ** Succesfully Inserted Deal Number
 
     C                   EVAL      @SIDN = NTNBR
 
      ** Settlements file version of transaction number
 
     C                   EVAL      VSTNBR = VTNBR
 
      ** Set the change type equal to the action code
 
     C                   EVAL      VCHTP  = NACTN
 
      ** Set the front office transaction ID
 
     C                   EVAL      VFRNT  = @FOTRANSEL
     C                   EVAL      VSFRNT = @FOTRANSEL
 
      ** Update the main transaction details
 
     C                   CALLB     'FFTRANUPD'
 
      ** Return Code
      ** -----------
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Input parameters
      ** ----------------
 
      ** The format containing the valid transaction
      ** The instrument details (data structure)
      ** The settlement details (data structure)
 
     C                   PARM                    NewTranFil
     C                   PARM                    NInstType
     C                   PARM                    NewTrstFil
 
      ** A code to indicate whether the trade is an OTC or an exchange-
      ** traded one.
 
     C                   PARM                    TransType
 
      ** New OTC instrument Y/N
 
     C                   PARM                    NewInst
 
      ** Whether switchable feature CFF001 (Enhanced OTCs) is on
 
     C                   PARM                    CFF001
 
      ** General Ledger ICD (SDGELRPD data structure
      ** Midas modules (DS, from SDMMODPD)
 
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
 
      ** Trade and book positions reconcilable flag (from SDFODAPD)
 
     C                   PARM                    BXTBRC
 
 
      ** If no errors, update settlement instructions.
     C                   IF        ReturnCode <> 'Error' and
     C                             ReturnCode <> '*RECUPD'
 
      ** Update the settlement instructions.
 
     C                   CALLB     'FFSETLUPD'
 
      ** Return code (10A, returned to caller)
 
     C                   PARM                    ReturnCode
 
      ** Inputs
      ** ------
 
      ** The format containing the valid settlements (data structure)
      ** The format containing the valid transaction (data structure)
      ** The instrument details (data structure)
 
     C                   PARM                    NewTrstFil
     C                   PARM                    NewTranFil
     C                   PARM                    NInstType
 
      ** Multibranching indicator
 
     C                   PARM                    BGMBIN
 
      ** CFF007 enhancement
      ** PB customer indicator (Broker)
      ** PB customer indicator (Customer)
 
     C                   PARM                    CFF007
     C                   PARM                    PPBBFLG
     C                   PARM                    PPBFLG
 
     C                   ENDIF
 
      ** (End of "If return code <> 'Error'")
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this module.
      ** Otherwise delete the invalid transaction & commit the updates
 
     C                   IF        ReturnCode <> *BLANKS
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
 
     C                   IF        ReturnCode <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
 
     C     ZATRNKD0      CHAIN     FFIOTCOL1                          02
     C                   IF        NoRecFnd = False
     C                   DELETE    FFIOTCOD0
     C                   ENDIF
 
     C     ZATRNKD0      CHAIN     FFICSETD0                          02
     C                   IF        NoRecFnd = False
     C                   DELETE    FFICSETD0
     C                   ENDIF
 
      ** Also delete corresponding record in API standard log file
      ** if CSC011 is present and user is still in support system.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
 
     C                   EVAL      WMTYP = 'FFOTCO'
     C     KAPILOG       CHAIN     APILOGL0                           71
 
      ** If record found
 
     C                   IF        *IN71 = False
     C                   DELETE    APILOGD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   ENDIF
 
      ** If error occurred in updating last transaction set on flag to
      ** display message on 'browse' screen.
 
     C                   IF        ReturnCode = '*RECUPD'
     C                   EVAL      @ERRUP = 'Y'
     C                   ELSE
     C                   EVAL      @ERRUP = 'N'
     C                   ENDIF
     C
 
      ** Remove the multimembered file overrides for this transaction
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
      ** If records are still to be read from the subfile, reaf them
 
     C                   IF        WRdNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** Else, return to the browse screen
 
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
 
     C     ENDP          BEGSR
 
      ** Issue rollback to clear any possible updates in window function
 
     C                   IF        BGWDPR  = 'Y'
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   ENDIF
 
     C                   EVAL      WScrn = 'T'
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * ValChgCom - Validate charges and commission details.
      *
      *****************************************************************
 
     C     ValChgCom     BEGSR
 
      ** Customer charges and commissions
      ** --------------------------------
 
     C                   RESET                   CustCCErr
 
     C                   EVAL      BrokerFlag = 'N'
 
     C                   CALLB     'FFVCHGCOM'
 
      ** Outputs from called procedure
      ** -----------------------------
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Broker settlement OK flags.
      ** Customer settlement OK flags
 
     C                   PARM                    OKBrokSet
     C                   PARM                    OKCustSet
 
      ** The valid settlements file format (data structure, from FFVSETLPD)
 
     C                   PARM                    NewTrstFil
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Data structure containing customer settlement details
 
     C                   PARM                    NewCuStScn
 
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
      ** Instrument currency (3A)
 
     C                   PARM                    BrokerFlag
     C                   PARM                    VISCY
 
      ** Broker Chrg./Comm. Pattern
      ** Market
      ** Instrument
      ** No. of contracts
      ** Action code
      ** Broker
      ** PB customer indicator
 
     C                   PARM                    ITBCPT
     C                   PARM      *BLANKS       PMRKT
     C                   PARM      *BLANKS       PISTC
     C                   PARM                    VNUCO
     C                   PARM                    NACTN
     C                   PARM                    VBOCO
      ** Futures and Options Enhancement for Private Banking                                  222373
     C                   PARM                    CFF007                                       222373
     C                   PARM                    PPBFLG
 
      ** Record any failure
 
     C                   IF        ReturnCode <> *BLANKS
     C                   EVAL      CustCCErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
 
     C                   EXSR      AppendArrs
     C                   ENDIF
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
      ** Data substitution
      ** =================
 
      ** Transaction details
      ** ===================
 
     C                   IF        WDtaSubs1 = 'Y'
 
      ** Clear IncDATA and CurDATA
 
     C                   CLEAR                   IncDATA
     C                   CLEAR                   CurDATA
 
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode       10
 
      ** Substitution character
 
     C                   PARM      GHSUBS        SubsChar          1
 
      ** Incoming Data
      ** Current Data
 
     C                   PARM      NewTranScn    IncDATA        2000
     C                   PARM      CurTranScn    CurDATA        2000
 
     C                   MOVEL     IncDATA       NewTranScn
 
     C                   ENDIF
 
      ** Customer settlement details
      ** ===========================
 
     C                   IF        WDtaSubs2 = 'Y'
 
      ** Clear IncDATA and CurDATA
 
     C                   CLEAR                   IncDATA
     C                   CLEAR                   CurDATA
 
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
 
     C                   PARM                    ReturnCode       10
 
      ** Substitution character
 
     C                   PARM      GHSUBS        SubsChar          1
 
      ** Incoming Data
      ** Current Data
 
     C                   PARM      NewCuStScn    IncDATA        2000
     C                   PARM      CurCuStScn    CurDATA        2000
 
     C                   MOVEL     IncDATA       NewCuStScn
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Access Bank details via access program
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Get the module flags
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Get the General Ledger ICD
 
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Get the trading details
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** Access Dealing ICD
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
 
      ** Get the portfolio ICD
 
     C                   IF        BGPFMG = 'Y'
 
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST'      @Optn
     C     SDPORT        PARM      SDPORT        DSFDY
 
     C                   ENDIF
 
      ** Get the retail ICD
 
     C                   IF        BGRTBN = 'Y' or BGIOAC = 'Y'
 
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDRETL        PARM      SDRETL        DSFDY
 
     C                   ENDIF
 
      ** Futures and Options ICD
 
     C                   CALL      'AOFODAR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDFODA        PARM      SDFODA        DSFDY
 
      ** Access SAR Details to determine whether Enhanced OTCs is present
 
     C                   EVAL      CFF001 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFF001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RtCd = *BLANK
     C                   EVAL      CFF001 = 'Y'
     C                   ENDIF
 
      ** Determine if CFF007 is installed
 
     C                   EVAL      CFF007 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFF007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANK
     C                   EVAL      CFF007 = 'Y'
     C                   ENDIF
 
      ** Determine if CSC011 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
 
     C                   IF        @RtCd <> *BLANKS and @RtCd <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   OPEN      APILOGL0
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
                                                                                              214057
      ** Determine if S01457 is installed                                                     214057
                                                                                              214057
     C                   CALLB     'AOSARDR0'                                                 214057
     C                   PARM      *BLANKS       @RTCD                                        214057
     C                   PARM      '*VERIFY'     @OPTN                                        214057
     C                   PARM      'S01457'      @SARD                                        214057
     C     SCSARD        PARM      SCSARD        DSFDY                                        214057
                                                                                              214057
     C     @RTCD         IFEQ      *BLANKS                                                    214057
     C                   MOVE      'Y'           S01457            1                          214057
     C                   ELSE                                                                 214057
     C                   MOVE      'N'           S01457                                       214057
     C                   ENDIF                                                                214057
 
      ** Get the API ICD
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDAPI         PARM      SDAPI         DSFDY
      ** Determine if enhancement CSC022 is switched on                                       CSC022
                                                                                              CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD             7                          CSC022
     C                   PARM      '*VERIFY'     POPTN             7                          CSC022
     C                   PARM      'CSC022'      PSARD             6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      * Initialize work fields                                                                CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   If        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   Eval      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   If        WPos > 0                                                   CSC022
     C                   Eval      WSkpCom = 'Y'                                              CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Else                                                                 CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSC022
     C                   Eval      DBKEY = 'CSC022'                                           CSC022
     C                   Eval      DBASE = 004                                                CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 4                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
 
      ** Key Lists
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
 
      ** Key List for access to API standard log file
 
     C     KAPILOG       KLIST
     C                   KFLD                    WMTYP
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
 
      ** Set the transaction type field used by the database updater
 
     C                   EVAL      TransType = 'OTCO'
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *BLANK
     C                   EVAL      FldOffset = FieldNo - 1
 
      ** If there was an error default the offset to 13
 
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
 
      ** Use the get record length function to retrieve the record
      ** lengths of the error OK-flag files.  As each field on these is
      ** only one byte, this gives us the number of fields.  Use these
      ** values to calculate the start positions in the array of error
      ** flags for the various data structures.
 
     C                   EVAL      FileName = 'FFEOTCOPD'
     C                   CLEAR                   RecordLen
 
     C                   CALLB     'UTGETRCDLN'
 
      ** Return code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Record length
 
     C                   PARM                    RecordLen
 
      ** File name
      ** File library
 
     C                   PARM                    FileName
     C                   PARM                    FileLib
 
     C                   EVAL      CSetStart = RecordLen + 1
 
      ** Start on Browse Screen
 
     C                   EVAL      WScrn = 'B'
 
      **-------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **-------------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFOTCOR011
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
