     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Non-Currency OTC input function')             *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCOSIN - Futures and options screen input                 *
      *             (Over-the-Counter)                                *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Futures and Options non-currency              *
      *             OTC options.                                      *
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
      *                 BG9185             Date 08Nov05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
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
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214057 - Allow broker if S01457 is installed.                *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY includes the FF standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the named constants
      ** used specifically in FF.
     D/COPY FFCPYSRC,NAMEDCONST
      **------------------------------------------------------------------------
 
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
     D                                     PREFIX(Cr)
 
      ** New transaction in screen format
     D NewTranScn    E DS                  EXTNAME(FFOTCOPD)
     D  NewPlatoScn          206    268
     D  NewPBScn             269    294
 
      ** Dummy incoming Transaction in screen format
     D DummyTIn      E DS                  EXTNAME(FFOTCCPD)
 
      ** Transaction Details - OK Flags
      ** ------------------------------
 
      ** External data structure for transaction details OK flags
     D OKFlagsDS     E DS                  EXTNAME(FFEOTCOPD)
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
     D NewTrstFil    E DS                  EXTNAME(FFVSETLPD)
     D                                     PREFIX(VS)
 
      ** Customer Settlement Details - Screen Format
      ** -------------------------------------------
 
      ** Current Customer Settlement Details in Screen Format
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD)
     D                                     PREFIX(Cr)
 
      ** New Customer Settlement details in screen format
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
 
 
      ** Broker Settlement Details - Screen Format
      ** -----------------------------------------
 
      ** Current broker settlement details in screen format
     D CurBrStScn    E DS                  EXTNAME(FFBSETPD)
     D                                     PREFIX(Cr)
 
      ** New broker settlement details in screen format
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
 
 
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
 
      * FF Extension data (OTCs) - File (D/B) format
     D ExtData       E DS                  EXTNAME(FFOTEXPD)
 
      * Screen Control Indicators
      * -------------------------
 
      ** Current Control Indicators for main details screen
     D PCCI@M          DS
     D  PEKYFD                 1      1
     D  PEDTFD                 2      2
     D  PEINKG                 3      3
     D  PEINKH                 4      4
     D  PEINKJ                 5      5
     D  PEINKP                 6      6
 
      ** Previous Control Indicators for main detail screen
     D PPCI@M          DS             6
 
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
 
      ** Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  WLCD         E                     EXTFLD(LCD)
 
      ** Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D PRespMode       S              1A   INZ('S')
 
      ** The current trading date
     D CTDATE          S                   LIKE(BJRDNB)
 
      ** Enhanced OTCs feature flag & CFF007 flag
     D CFF001          S              1A
     D CFF007          S              1A
 
      ** Parameters for ZATRNRTV
      ** -----------------------
 
      ** Module ID
     D Module          S              2A   INZ('FF')
 
      ** Transaction type (dummy field as it is not needed for FF)
     D DummyTRTY       S              1A
 
      ** End of parameters for ZATRNRTV
      ** ------------------------------
 
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
 
      ** Dummy market and instrument fields to pass as blanks to
      ** procedures which need them.
     D DummyMark       S              2A
     D DummyInst       S              3A
 
      ** (imported from module FFVOTCTYP)
     D NewInst         S              1A   IMPORT
 
      ** Screen Mode ('1' for transaction screen & '2' for plato screen)
     D PScnMode        S              1A   INZ('1')
     D WScrn           S              1A
     D Idx             S              3P 0
     D WPACTN          S              1A
     D WPTRNO          S              6A
     D WRDNB           S              1A
     D WReDisplay      S              1A
 
      ** Premium
      ** Transaction status
     D NPREM           S             15A
     D FFSTS           S             24A
 
      ** Function keys activated
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
      ** Successful insert transaction
     D PSITran         S              6A
 
      ** Amendments Ok
     D PAmdOk          S              1A
 
      ** Parameters for WN0010 program
     D PWPgm           S             10A   INZ('FFOTCOSIN')
     D PWKey           S              2A
     D PWAction        S              1A
     D PWRtn           S              7A
     D PWSpare         S            256A
 
      ** Other parameter variables
     D PRdFwd          S              1A
     D PRdBck          S              1A
     D PErrMsg         S              7A
     D PTrnRd          S              6A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D POpSel          S              1A
     D PTrnSel         S              6A
     D PMbrSel         S              2A
     D PModeOfOp       S              6A
     D PFrntId         S             20A
 
      ** PB customer indicator - customer
     D PPBFLG          S              1A
 
      ** PB customer indicator - broker
     D PPBBFLG         S              1A
 
      ** Market
     D PMRKT           S              2A
 
      ** Instrument
     D PISTC           S              3A
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
      /COPY WNCPYSRC,FFOTCOS001
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FFOTCOS002
 
      ** Read next browse subfile record
 
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOS003
 
      ** Do while screen: main details
 
     C                   DOW       WScrn = 'M'
     C                   EXSR      SRMainScn
     C                   ENDDO
 
      /COPY WNCPYSRC,FFOTCOS004
 
      ** Settlement details processing
 
     C                   DOW       WScrn = 'S'
     C                   EXSR      SRSettScn
     C                   ENDDO
 
      ** Private Banking Details
 
     C                   DOW       WScrn = 'P' and CFF007 = 'Y'
     C                   EXSR      SCRN@P
     C                   ENDDO
 
      /COPY WNCPYSRC,FFOTCOS005
 
      ** Screen: window
 
     C                   IF        WScrn = 'W'
     C                   EXSR      SRWindow
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOS006
 
      ** Screen: confirmation of input
 
     C                   IF        WScrn = 'C'
 
     C                   EXSR      SRCnfScn
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOS007
 
      ** Do file updates
 
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
 
      ** Reset PScnMode back to transaction mode
 
     C                   EVAL      PScnMode = '1'
 
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCOS008
 
      ** Terminate program
 
     C                   IF        WScrn = 'T'
     C                   MOVE      '1'           *INLR
     C                   ENDIF
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFOTCOS009
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMainScn - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
 
     C     SRMainScn     BEGSR
 
      ** Issue rollback to clear any possible updates in window function
      ** Only required if transaction number or action code has been changed
      ** (this check will also cater for F12 taken from main screen)
 
     C                   IF        BGWDPR = 'Y'
     C                   IF        NTNBR <> WPTRNO or
     C                             NACTN <> WPACTN or
     C                             PCCI@M <> PPCI@M
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
     C                   ENDIF
 
      ** Reset the transaction-number-automatically-generated flag
 
     C                   RESET                   AutoTran
 
      ** Update 'previous' transaction number & screen control indicator
 
     C                   EVAL      WPTRNO = NTNBR
     C                   EVAL      WPACTN  = NACTN
     C                   EVAL      PPCI@M = PCCI@M
 
      ** Write/Read display screen
 
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
 
     C                   PARM                    NPREM
     C                   PARM                    FFSTS
 
      ** Fields in error
 
     C                   PARM                    OKFlagsDS
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
 
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
 
      ** Successful insert transaction
 
     C                   PARM                    PSITran
 
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
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
 
      ** Save warning message ids array of this screen.
 
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
 
      ** Reset Errors
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      OKFlagsDS  = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
     C                   EVAL      PSITran = *BLANKS
 
     C                   SELECT
 
      ** CK/12 - Cancel on Main Details Screen
 
     C                   WHEN      PINKL = '1'
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
 
      ** CK/3 - End Program
 
     C                   WHEN      PINKC = '1'
     C                   EXSR      ENDP
 
      ** CK/7 - Roll Backwards
 
     C                   WHEN      PINKG = '1'
     C                   EXSR      ROLL
 
      ** CK/8 - Roll Forwards
 
     C                   WHEN      PINKH = '1'
     C                   EXSR      ROLL
 
 
      ** If CK/10 taken, go onto updates
 
     C                   WHEN      PINKJ =  '1'
 
      ** Update transaction in File Format
      ** Update transaction settlement details in File Format
 
     C                   MOVEL     CurTranFil    NewTranFil
     C                   MOVEL     CurTrstFil    NewTrstFil
     C                   MOVEL     CInstType     NInstType
 
     C                   EVAL      WScrn = 'U'
 
      ** CK/15 - Build Browse
 
     C                   WHEN      PINKP = '1'
     C                   EXSR      BLDBRW
 
      ** Validate input to Main Details Screen
 
     C                   OTHER
     C                   EXSR      VAL@M
 
     C                   ENDSL
 
     C     ESCRN@M       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - Validate input to Main Details Screen
      *****************************************************************
 
     C     VAL@M         BEGSR
 
      ** Retrieve Transaction details
 
     C                   EXSR      RTVTRN
 
      ** If action code or transaction number are NOT OK
      ** Re-output screen with error messages on it
 
     C                   IF        OKACTN = 'N' OR OKTNBR = 'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
 
      ** If action code is delete, or enquire;
      ** or action code is amend and transaction number
      ** number has changed
      ** Put the transaction on the main details screen
 
     C                   IF        NACTN = 'D' OR NACTN = 'E' OR
     C                             NACTN = 'A' AND NTNBR <> WPTRNO OR
     C                             NACTN = 'A' AND NACTN <> WPACTN
     C                   EXSR      PUTD@M
     C                   ELSE
     C                   EVAL      FFSTS = *BLANKS
     C                   ENDIF
 
      ** If transaction number or screen control indicators have
      ** changed, Re-output screen
 
     C                   IF        NTNBR <> WPTRNO and NACTN <> 'I' or
     C                             PCCI@M <> PPCI@M
 
     C                   IF        CFF007 = 'Y' and NACTN = 'I' and
     C                             WPACTN <> 'I'
     C                   EVAL      NewPBScn = *BLANKS
     C                   ENDIF
 
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** If Enquire
      ** ----------
 
     C                   IF        NACTN = 'E'
 
      ** Update Transaction in File Format
      ** Update transaction settlement details in File Format
 
     C                   EVAL      NewTranFil = CurTranFil
     C                   EVAL      NewTrstFil = CurTrstFil
 
     C                   SELECT
 
      ** If CFF007 and Private Banking (BGN4ST) on
 
     C                   WHEN      CFF007 = 'Y' and BGN4ST = 'Y' and
     C                             PScnMode = '1'
     C                   EVAL      WScrn = 'P'
     C                   IF        NACTN = 'I'
     C                   EVAL      NewPBScn = *BLANKS
     C                   ENDIF
 
      ** If Plato (BGN2ST) is on and PScnMode = '1'
 
     C                   WHEN      BGN2ST = 'Y' and PScnMode = '1'
     C                   EVAL      PScnMode = '2'
     C                   EVAL      WScrn = 'M'
     C                   IF        NACTN = 'I'
     C                   EVAL      NewPlatoScn = *BLANKS
     C                   ENDIF
 
      ** If windows processing on, call window routine
      ** If browse outstanding, read next browse subfile record
 
     C                   WHEN      BGWDPR = 'Y'
     C                   EVAL      PScnMode = '1'
     C                   EVAL      WScrn = 'W'
 
     C                   WHEN      WRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
 
     C                   ENDSL
 
     C                   GOTO      EVAL@M
 
      ** End of Enquire
      ** --------------
 
     C                   ENDIF
 
      ** If insert or amend
      ** ------------------
 
     C                   IF        NACTN = 'I' OR NACTN = 'A'
 
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Transaction in File Format
 
     C                   EVAL      Idx = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   EVAL      OKFlagsDS  = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
 
     C                   IF        PScnMode = '1'
     C                   CLEAR                   NewTranFil
     C                   CLEAR                   NewTrstFil
     C                   ENDIF
 
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
 
     C                   PARM                    OKFlagsDS
     C                   PARM                    OKCustSet
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Amendments OK
 
     C                   PARM      'Y'           PAmdOk
 
     C                   IF        PAmdOk <> 'Y'
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** End of If Amend (access to FFOTCOAMD)
 
     C                   ENDIF
 
      ** Validate Transaction details
      ** ----------------------------
 
     C                   CALLB     'FFOTCOVAL'
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
 
     C                   PARM                    PRespMode
 
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
 
      ** O.T.C. instrument switchable field
      ** CFF007 Enhancement
 
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
     C                   PARM                    OKFlagsDS
 
      ** FF Non-currency OTC for file update - detail file format
      ** The branch details format (from SDBRCHPD via MMVBKGBRCH)
      ** The current trading date (Midas day number)
      ** Instrument details (DS based on INTYPD)
      ** Premium
      ** PB customer indicator
 
     C                   PARM                    NewTranFil
     C                   PARM                    SDBRCH
     C                   PARM                    CTDATE
     C                   PARM                    NInstType
     C                   PARM                    NPREM
     C                   PARM                    PPBFLG
     C                   PARM                    S01457                                       214057
 
      ** If errors returned
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      EVAL@M
     C                   ENDIF
 
     C                   IF        PScnMode = '1'
 
      ** Continue to settlements screen
 
     C                   EVAL      WScrn = 'S'
 
     C                   ELSE
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
 
      ** Otherwise continue to the confirmation screen
 
     C                   EVAL      WScrn = 'C'
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** End of If insert or amend
      ** -------------------------
 
     C                   ENDIF
 
     C                   IF        CFF007 = 'Y' and NewInst = 'Y' and
     C                             NACTN = 'I'
     C                   EVAL      OKPBFlag = *ALL'Y'
     C                   EVAL      NewPBScn = *BLANKS
     C                   ENDIF
 
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@P - Process Screen: Private Banking Details
      *****************************************************************
 
     C     SCRN@P        BEGSR
 
      ** Write/read display screen
 
     C                   CALLB     'FFOTCO2DP'
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Transaction (in screen format)
 
     C                   PARM                    NewTranScn
 
      ** Premium
 
     C                   PARM                    NPREM
     C                   PARM                    NewInst
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
 
      ** Fields in error
 
     C                   PARM                    OKFlagsDS
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Option selected
 
     C                   PARM                    POpSel
 
      ** Output
      ** ------
      ** Function keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
     C                   SELECT
 
      ** CK/3 - End Program
 
     C                   WHEN      PINKC = '1'
     C                   EXSR      ENDP
 
      ** CK/12 - Cancel on Private Banking Screen
 
     C                   WHEN      PINKL = '1'
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
 
     C                   SELECT
 
      ** If Plato (BGN2ST) is on and PScnMode = '1'
 
     C                   WHEN      BGN2ST = 'Y' and PScnMode = '1'
     C                   EVAL      PScnMode = '2'
     C                   EVAL      WScrn = 'M'
 
      ** If windows processing on, call window routine
      ** If browse outstanding, read next browse subfile record
 
     C                   WHEN      BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
 
     C                   WHEN      WRDNB  = 'Y'
     C                   EVAL      WScrn = 'R'
 
     C                   ENDSL
 
     C                   GOTO      EVAL@P
     C                   ENDIF
 
      **---------------------------------------------------------------
      ** If Insert or Amend
 
     C                   IF        NACTN = 'I' or NACTN = 'A'
 
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
     c
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
     C                   PARM                    OKFlagsDS
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
     C                   IF        NACTN = 'I'
     C                   EVAL      NewPlatoScn = *BLANKS
     C                   ENDIF
     C                   EVAL      WScrn = 'M'
     C                   ELSE
 
      ** Continue to windows screen
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
 
      ** Otherwise continue to the confirmation screen
 
     C                   EVAL      WScrn = 'C'
 
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
 
      ** Reset erros
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      OKFlagsDS  = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
 
      ** Write out screen to remove error messages
 
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
 
     C                   PARM                    NPREM
     C                   PARM                    FFSTS
 
      ** Fields in error
 
     C                   PARM                    OKFlagsDS
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
 
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
 
      ** Successful insert transaction
 
     C                   PARM                    PSITran
 
      ** Write screen with no read indicator
 
     C                   PARM      'Y'           WriteOnly
 
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
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
 
     C/COPY QWINDSRC,FFTRANSMV1
 
     C                   CALL      'WN0010'
     C                   PARM                    PWPgm
     C                   PARM                    PWKey
     C                   PARM      NACTN         PWAction
     C                   PARM                    Data
     C                   PARM      *BLANKS       PWRtn
     C                   PARM                    PWSpare
 
      ** Process returned command keys
 
     C                   IF        PWRtn = 'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
 
      **  If Cmd12 pressed, or in enquiry, return to main details screen;
      **  otherwise, go to previous screen
 
     C                   IF        PWRtn = 'USR0790' OR NACTN = 'E'
 
     C                   IF        WRDNB = 'Y'
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
     C                   EVAL      WScrn = 'C'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EWindow       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - Roll backwards & forwards through transaction file
      *****************************************************************
     C     ROLL          BEGSR
 
      ** Default action code to enquiry if not valid
 
     C                   IF        NACTN <> 'A' AND NACTN <> 'D' AND
     C                             NACTN <> 'I'
     C                   EVAL      NACTN = 'E'
     C                   ENDIF
 
      ** Read next or previous record on transactions file
      ** according to command key taken (CK/7 or CK/8)
 
     C                   IF        PINKG = '1'
     C                   EVAL      PRdFwd = *BLANK
     C                   EVAL      PRdBck = 'Y'
     C                   ELSE
     C                   EVAL      PRdFwd = 'Y'
     C                   EVAL      PRdBck = *BLANK
     C                   ENDIF
 
     C                   CALLB     'FFOTCORED'
 
      ** Input Parameters
      ** ----------------
 
      ** Return Code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Transaction number
 
     C                   PARM                    NTNBR
 
      ** Read forwards
      ** Read backwards
 
     C                   PARM                    PRdFwd
     C                   PARM                    PRdBck
 
      ** Standing Data
      ** -------------
 
     C                   PARM                    SDBANK
 
      ** Output Parameters
      ** -----------------
 
      ** Error Message
      ** Transaction number read
 
     C                   PARM                    PErrMsg
     C                   PARM                    PTrnRd
 
 
      ** If error message returned from read, send it to detail screen
 
     C                   IF        PErrMsg <> *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   ENDIF
 
      ** If transaction read
 
     C                   IF        PTrnRd <> *BLANK
 
      ** Retrieve transaction details
 
     C                   EVAL      NTNBR = PTrnRd
     C                   EXSR      RTVTRN
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
 
      ** Put the transaction on the main details screen
 
     C                   EXSR      PUTD@M
     C                   ENDIF
 
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - Build Browse Subfile
      *****************************************************************
 
     C     BLDBRW        BEGSR
 
      ** Reset read next browse subfile record
 
     C                   EVAL      WRDNB = *BLANK
 
      ** Build browse subfile
 
     C                   CALLB     'FFTRANBRW'
 
      ** Input Parameters
      ** ----------------
 
      ** Return Code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Transaction number pointer
 
     C                   PARM                    NTNBR
 
      ** Build sub-file
      ** Read subfile record
 
     C                   PARM      'Y'           PBdSfl
     C                   PARM      *BLANK        PRdSfl
 
      ** Standing Data
      ** -------------
 
     C                   PARM                    SDBANK
 
      ** Transaction type
 
     C                   PARM                    TransType
 
      ** Output Parameters
      ** -----------------
 
      ** Error Message
 
     C                   PARM      *BLANKS       PErrMsg
 
      ** Option Selected
      ** Transaction number selected
      ** Member selected
 
     C                   PARM      *BLANK        POpSel
     C                   PARM      *BLANK        PTrnSel
     C                   PARM      *BLANK        PMbrSel
 
      ** Command Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If CK/3 taken in browse, end program
 
     C                   IF        PINKC = '1'
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   ENDIF
 
      ** If error message returned from browse, send it to detail screen
 
     C                   IF        PErrMsg <> *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   ENDIF
 
      ** If CK/12 not taken in browse
      ** Read next browse subfile record
 
     C                   IF        PINKL <> '1'
     C                   EVAL      WRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   GOTO      EBLDBR
     C                   ENDIF
 
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdNBrw - Read next browse subfile record
      *****************************************************************
 
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
 
     C                   CALLB     'FFTRANBRW'
 
      ** Input Parameters
      ** ----------------
 
      ** Return Code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Transaction number pointer
 
     C                   PARM                    NTNBR
 
      ** Build sub-file
      ** Read subfile record
 
     C                   PARM      *BLANK        PBdSfl
     C                   PARM      'Y'           PRdSfl
 
      ** Standing Data
 
     C                   PARM                    SDBANK
 
      ** Transaction type
 
     C                   PARM                    TransType
 
      ** Output Parameters
      ** -----------------
 
      ** Error Message
 
     C                   PARM      *BLANK        PErrMsg
 
      ** Option Selected
      ** Transaction number selected
      ** Member selected
 
     C                   PARM      *BLANK        POpSel
     C                   PARM      *BLANK        PTrnSel
     C                   PARM      *BLANK        PMbrSel
 
      ** Command Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If transaction read from subfile
 
     C                   IF        PTrnSel <>  *BLANK
 
      ** Retrieve transaction details
 
     C                   EVAL      NACTN = POpSel
     C                   EVAL      NTNBR = PTrnSel
     C                   EXSR      RTVTRN
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
 
      ** Put the transaction on the main details screen
 
     C                   EXSR      PUTD@M
 
      ** Else, reset read next browse subfile record
 
     C                   ELSE
     C                   EVAL      WRDNB = *BLANK
     C                   ENDIF
 
      ** Go to main details screen
 
     C                   EVAL      WScrn = 'M'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - Retrieve Transaction
      *****************************************************************
 
     C     RTVTRN        BEGSR
 
     C                   CALLB     'FFOTCCRTV'
 
      ** Input Parameters
      ** ----------------
 
      ** Return code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
 
     C                   PARM      '      '      PModeOfOp
 
      ** Response mode (1A)
 
     C                   PARM                    PRespMode
 
      ** Action Code (1A)
      ** Front Office Transaction ID (20A)
      ** (Midas) Transaction Number (6A)
      ** Module being called as linked enquiry (1A)
 
     C                   PARM                    NACTN
     C                   PARM                    PFrntId
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
 
      ** Output Parameters
      ** -----------------
 
      ** (Current) transaction in file format
      ** (Current) Settlements in file format
      ** Instrument Types
      ** OK - Action code (1A)
      ** OK - Transaction Number (1A)
 
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
 
      ** Input Parameter
      ** ---------------
 
      ** Return Code
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Transaction in file format
      ** Instrument types
 
     C                   PARM                    CurTranFil
     C                   PARM                    CInstType
 
      ** Standing Data
      ** -------------
 
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
 
      ** CFF001 and CFF007 enhancements
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Output Parameters
      ** -----------------
 
      ** Transaction in screen format
 
     C                   PARM                    NewTranScn
 
      ** Premium
      ** Transaction Status
 
     C                   PARM                    NPREM
     C                   PARM      *BLANKS       FFSTS
 
     C                   EVAL      CustBrokFl = 'C'
 
      ** Call program to fill screen fields with data from TRSETD
 
     C                   CALLB     'FFSETLCVT'
 
      ** Output Parameters
      ** -----------------
      ** Return code (10A, returned to caller)
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Customer settlement instructions, screen format
      ** Broker settlement instructions, screen format
 
     C                   PARM                    NewCuStScn
     C                   PARM                    NewBrStScn
 
      ** Input Parameter
      ** ---------------
 
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
      * SFDS@M - Set field status on main details screen
      *          according to action code
      *****************************************************************
 
     C     SFDS@M        BEGSR
 
      ** Enable/disable key & detail fields on main details screen
      ** (key fields = action code & transaction number.
      **  detail fields = rest)
      ** (Action code can only be 'I', 'A', 'E' or 'D')
 
     C                   IF        NACTN = 'I' OR NACTN = 'A'
     C                   EVAL      PEKYFD = 'Y'
     C                   EVAL      PEDTFD = 'Y'
     C                   ELSE
     C                   EVAL      PEKYFD = 'N'
     C                   EVAL      PEDTFD = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@M - Set function key status on main details screen
      *          according to action code
      *****************************************************************
 
     C     SFKS@M        BEGSR
 
      ** Enable/disable function keys on main details screen
 
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
 
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
 
      ** KJ = Command key 10 = Confirm Delete
 
     C                   IF        NACTN = 'D'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
      ** KP = Command key 15 = Browse
 
     C                   EVAL      PEINKP = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@M - Initialize field status on main details screen
      *****************************************************************
 
     C     IFDS@M        BEGSR
 
      ** Enable key & details fields on main details screen
 
     C                   EVAL      PEKYFD = 'Y'
     C                   EVAL      PEDTFD = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@M - Initialise function key status on main details screen
      *****************************************************************
 
     C     IFKS@M        BEGSR
 
      ** Enable/Disable function keys on main details screen
      ** KG = Command key 07 = Read previous
      ** KH = Command Key 08 = Read next
      ** KJ = Command Key 10 = Confirm Delete
      ** KP = Command Key 15 = Browse
 
     C                   EVAL      PEINKG = 'Y'
     C                   EVAL      PEINKH = 'Y'
     C                   EVAL      PEINKJ = 'N'
     C                   EVAL      PEINKP = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - Cancel on main details screen
      *****************************************************************
 
     C     CANC@M        BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   EVAL      WRDNB = *BLANK
 
      ** If input fields are enabled
      ** Blank the main details screen
 
     C                   IF        PEKYFD = 'Y' OR
     C                             PEDTFD = 'Y'
     C                   EVAL      NewTranScn = *BLANK
     C                   EVAL      NewCuStScn = *BLANK
     C                   EVAL      NPREM      = *BLANK
     C                   EVAL      FFSTS      = *BLANK
     C                   ENDIF
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - Send a message to main details screen
      *****************************************************************
 
     C     SNDM@M        BEGSR
 
      ** If single branching, user can't browse file
 
     C                   IF        PErrMsg = 'FXM0292'
     C                   EVAL      OKACTN = 'N'
     C                   ENDIF
 
      ** Transaction number on screen must be blank or numeric for pointer
 
     C                   IF        PErrMsg = 'APM0112'
     C                   EVAL      OKTNBR = 'N'
     C                   ENDIF
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   EVAL      FldNameArr(E) = '*ANY'
     C                   EVAL      MsgIdArr(E) = PErrMsg
 
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
      ** ======
 
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
      ** ======
 
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
 
      ** CFF007 Enhancement
 
     C                   PARM                    CFF007
 
      ** PB customer indicator - Broker
      ** PB customer indicator - Customer
 
     C                   PARM                    PPBBFLG
     C                   PARM                    PPBFLG
                                                                                              CGL014
      ** Collaterals Processing enhancement                                                   CGL014
                                                                                              CGL014
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure or warning
 
     C                   IF        ReturnCode <> *blanks
 
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
 
     C                   IF        CustSetErr = 'W' or WMsgIDArr(1) <> *BLANKS
 
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
 
     C                   CLEAR                   WPrvWarnAr
     C                   Z-ADD     0             WIdx
 
      ** Reset Errors
 
     C                   IF        WReDisplay = *BLANK
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      OKFlagsDS  = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
     C                   ENDIF
 
     C                   ENDIF
 
      ** If settlement or charge and commission details invalid,
      ** return to main details screen.
 
     C                   IF        CustSetErr = 'Y' or CustCCErr = 'Y' or
     C                             WReDisplay = 'Y'
 
     C                   EVAL      WScrn = 'M'
 
     C                   ELSE
 
     C                   SELECT
 
      ** If Private Banking and CFF007 is on
 
     C                   WHEN      CFF007 = 'Y' and BGN4ST = 'Y'
     C                   EVAL      WScrn = 'P'
     C                   IF        NACTN = 'I'
     C                   EVAL      NewPBScn = *BLANKS
     C                   ENDIF
 
      ** If Plato (BGN2ST) is on and PScnMode = '1'
 
     C                   WHEN      BGN2ST = 'Y' and PScnMode = '1'
     C                   EVAL      PScnMode = '2'
     C                   EVAL      WScrn = 'M'
     C                   IF        NACTN = 'I'
     C                   EVAL      NewPlatoScn = *BLANKS
     C                   ENDIF
 
      ** Otherwise, if windows on, show windows screen
 
     C                   WHEN      BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
 
      ** Otherwise continue to the confirmation screen
 
     C                   OTHER
     C                   EVAL      WScrn = 'C'
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCnfScn - Process screen: Confirmation of input
      *            evoked for inserts , amends, and authorisations
      *****************************************************************
 
     C     SRCnfScn      BEGSR
 
      ** Output message 'Press enter to accept'
 
     C                   EVAL      WFldNamArr(1) = '*ANY'
     C                   EVAL      WMsgIdArr(1)  = 'APM0121'
     C                   EVAL      PScnMode = '1'
 
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
 
     C                   PARM                    NPREM
     C                   PARM                    FFSTS
 
      ** Fields in error
 
     C                   PARM                    OKFlagsDS
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
 
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
 
      ** Successful insert transaction
 
     C                   PARM                    PSITran
 
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
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
 
      ** Reset Errors
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   EVAL      OKFlagsDS  = *ALL'Y'
     C                   EVAL      OKBrokSet  = *ALL'Y'
     C                   EVAL      OKCustSet  = *ALL'Y'
 
     C                   SELECT
 
      ** CK/12 - Cancel on Confirmation Screen
 
     C                   WHEN      PINKL = '1'
     C                   EVAL      PScnMode = '1'
     C                   EXSR      CANC@C
 
      ** CK/3 - End Program
 
     C                   WHEN      PINKC = '1'
     C                   EXSR      ENDP
 
      ** Exit confirmation screen
 
     C                   OTHER
     C                   EXSR      EXIT@C
 
     C                   ENDSL
 
     C     ESCRN@C       ENDSR
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
 
      ** Initialize field status on main details screen
 
     C                   EXSR      IFDS@M
 
      * Set function key status on main details screen
      * (according to action code)
 
     C                   EXSR      SFKS@M
 
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
 
      ** Initialize field status on main details screen
 
     C                   EXSR      IFDS@M
 
      ** Set function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SFKS@M
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
 
     C                   IF        NTNBR = *BLANKS
 
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY
     C                   PARM                    NTNBR
     C                   PARM                    VTNBR
 
      ** End in error if generator returned an error
 
     C                   IF        ReturnCode <> *blank
     C                   EVAL      DBKEY  =  NTNBR
     C                   EVAL      DBFILE =  'ZATRNRTV'
     C                   EVAL      DBASE  =  009
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set a flag to indicate that the transaction number was generated
      ** rather than entered.
 
     C                   EVAL      AutoTran = 'Y'
 
     C                   ENDIF
 
      ** Succesfully Inserted Deal Number
 
     C                   EVAL      PSITran = NTNBR
 
      ** Settlements file version of transaction number
 
     C                   EVAL      VSTNBR = VTNBR
 
      ** Set the change type equal to the action code
 
     C                   EVAL      VCHTP  = NACTN
 
      ** Update the main transaction details
 
     C                   CALLB     'FFTRANUPD'
 
      ** Returned parameters
 
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
 
      ** Input Parameters
      ** ----------------
 
      ** The format containing the valid settlements (data structure)
      ** The format containing the valid transaction (data structure)
      ** The instrument details (data structure)
 
     C                   PARM                    NewTrstFil
     C                   PARM                    NewTranFil
     C                   PARM                    NInstType
 
      ** Multibranching indicator
 
     C                   PARM                    BGMBIN
 
      ** CFF007 enhancement
 
     C                   PARM                    CFF007
 
      ** PB customer indicator (Broker)
      ** PB customer indicator (Customer)
 
     C                   PARM                    PPBBFLG
     C                   PARM                    PPBFLG
 
      ** (End of "If return code <> 'Error'")
 
     C                   ENDIF
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this module. Otherwise commit the updates.
 
     C                   IF        ReturnCode <> '*RECUPD'
 
     C                   IF        ReturnCode <> *blanks
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C                   ENDIF
 
     C                   ELSE
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1) = 'MMM1067'
 
     C                   ENDIF
 
      ** Remove the multimembered file overrides for this transaction
 
     C                   CALLB     'FFDLTOVR'
 
     C                   PARM      *BLANKS       ReturnCode
 
      ** Blank the main details screen
 
     C                   EVAL      NewTranScn = *BLANK
     C                   EVAL      NewCuStScn = *BLANK
     C                   EVAL      NPREM      = *BLANK
     C                   EVAL      FFSTS      = *BLANK
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** Else, return to main details screen
 
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
 
     C     ENDP          BEGSR
 
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
 
      ** Broker/Custom Chrg/com. Patterns (1A)
      ** Market (2A)
      ** Instrument (3A)
      ** Number of Contracts (5.0P)
      ** Action Code used  (1A)
      ** Broker
     C                   PARM                    ITBCPT
     C                   PARM      *BLANKS       PMRKT
     C                   PARM      *BLANKS       PISTC
     C                   PARM                    VNUCO
     C                   PARM                    NACTN
     C                   PARM                    VBOCO
 
      ** Futures and Options Enhancement for Private Banking
 
     C                   PARM                    CFF007
 
      ** Private Banking Customer Inidcator
 
     C                   PARM                    PPBFLG
 
      ** Record any failure
 
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      CustCCErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
 
     C                   EXSR      AppendArrs
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBASE  =  001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBASE  =  002
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDGELRPD'
     C                   EVAL      DBASE  =  003
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing Data Details
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDDEALPD'
     C                   EVAL      DBASE  =  004
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Trading Details
 
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDTRADPD'
     C                   EVAL      DBASE  =  005
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get the portfolio ICD
 
     C                   IF        BGPFMG = 'Y'
 
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST'      @Optn
     C     SDPORT        PARM      SDPORT        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDPORTPD'
     C                   EVAL      DBASE  =  006
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Get the retail ICD
 
     C                   IF        BGRTBN = 'Y' or BGIOAC = 'Y'
 
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDRETL        PARM      SDRETL        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDRETLPD'
     C                   EVAL      DBASE  =  007
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Futures and Options ICD
 
     C                   CALL      'AOFODAR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDFODA        PARM      SDFODA        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDFODAPD'
     C                   EVAL      DBASE  =  008
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR Details to determine whether Enhanced OTCs is present
 
     C                   EVAL      CFF001 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFF001'      @SARD
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CFF001 = 'Y'
     C                   ENDIF
 
      ** Access SAR Details to determine if CFF007 is installed
 
     C                   EVAL      CFF007 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFF007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CFF007 = 'Y'
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
     C                   Eval      DBASE = 010                                                CSC022
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
     C                   EVAL      DBASE  = 3                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
 
      ** Set the transaction type field used by the database updater
 
     C                   EVAL      TransType = 'OTCO'
 
      ** Start on Main Details Screen
 
     C                   EVAL      WScrn = 'M'
 
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
 
      ** Hook to enable non-core initial processing to be included
 
      /COPY WNCPYSRC,FFOTCOS010
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
