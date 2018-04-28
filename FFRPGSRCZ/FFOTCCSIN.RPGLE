     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC input function')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCCSIN - Futures and options screen input                 *
      *             (Over-the-Counter)                                *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Futures and Options currency OTC options.     *
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
      *                 208635             Date 16Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166             Date 15Oct01               *
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191171             Date 26Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 166907             Date 04Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 05Oct99               *
      *                 165402             DATE 04Aug99               *
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 22Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jul98               *
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
      *  208635 - Allow broker if S01457 is installed.                *
      *  CAP166 - API for Non-Currency OTC                            *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  191171 - Window does not appear if action is D               *
      *  166907 - @SIDN is not updated correctly causing message :    *
      *           'Tran No. 999999 successfully inserted' not to be   *
      *           displayed.                                          *
      *  CPB001 - 'Private Banking' Module                            *
      *  165402 - Fields on deals are being corrupted on amendment.   *
      *  170520 - Recompile over changed TRANSD file.                 *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to modular API structure *
      *                                                               *
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
      ** The following /COPY includes the FF standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
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
      ** The following /COPY line includes all the named constants
      ** used specifically in FF.
     D/COPY FFCPYSRC,NAMEDCONST
      **--------------------------------------------------------------------------------------------
 
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
 
      * Transaction Details - File Format
      * ~~~~~~~~~~~ ~~~~~~~   ~~~~ ~~~~~~
 
     D CurTranFil    E DS                  EXTNAME(TRANSD)
      * Current transaction in file format
 
     D NewTranFil    E DS                  EXTNAME(FFVTRANPD)
      * Valid transaction in file format
     D                                     PREFIX(V)
 
      * Transaction Details - Screen Format
      * ~~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
 
     D CurTranScn    E DS                  EXTNAME(FFOTCCPD)
      * Current transaction in screen format
     D                                     PREFIX(@)
 
     D NewTranScn    E DS                  EXTNAME(FFOTCCPD)
     D  NewPBScn             219    244                                                       CFF007
      * New transaction in screen format
 
      ** Dummy incoming Transaction in screen format                                          CAP166
     D DummyTIn      E DS                  EXTNAME(FFOTCOPD)                                  CAP166
                                                                                              CAP166
      * Transaction Details - OK Flags
      * ~~~~~~~~~~~ ~~~~~~~   ~~~~~~~~
 
     D OKTransDet    E DS                  EXTNAME(FFEOTCCPD)
     D  OKPBFlag              37     45                                                       CFF007
      ** External data structure for transaction details OK flags
 
      ** The OK flags for the OTCO transaction details                                        CAP166
     D OKDummyDS     E DS                  EXTNAME(FFEOTCOPD)                                 CAP166
     D                                     PREFIX(A)                                          CAP166
                                                                                              CAP166
      * Customer and Broker Settlement Details - File Format
      * ~~~~~~~~ ~~~ ~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~ ~~~~~~
 
     D CurTrstFil    E DS                  EXTNAME(TRSETD)
      * Settlements in file format
     D                                     PREFIX(ST)
 
     D NewTrstFil    E DS                  EXTNAME(FFVSETLPD) PREFIX(VS)
      ** Valid settlement instructions; prefixed with VS for valid
      ** settlemnts.
 
      * Customer Settlement Details - Screen Format
      * ~~~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
 
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** New Customer Settlement details in screen format
 
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD) PREFIX(@)
      ** Current Customer Settlement Details in Screen Format
 
 
      * Broker Settlement Details - Screen Format
      * ~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
 
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** New broker settlement details in screen format
 
     D CurBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** Current broker settlement details in screen format
     D                                     PREFIX(@)
 
 
      * Settlement Details - OK Flags
      * ~~~~~~~~~~ ~~~~~~~   ~~ ~~~~~
 
     D OKBrokSet     E DS                  EXTNAME(FFEBSETPD)
      ** External data structure for broker settlement flags
 
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
      ** External data structure for customer settlement flags
 
 
     D MarketDet     E DS                  EXTNAME(MARKT) PREFIX(MK)
      ** Market details DS (MK=MarKet)
 
     D InstType      E DS                  EXTNAME(INTYP)  PREFIX(IT)
      ** Instrument types
 
     D ExtData       E DS                  EXTNAME(FFOTEXPD)                    CAP004
      * FF Extension data (OTCs) - File (D/B) format                            CAP004
 
      * Screen Control Indicators
      * ~~~~~~ ~~~~~~~ ~~~~~~~~~~
 
     D @CCI@M          DS
      ** Current Control Indicators for main details screen
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKP                 7      7
 
     D @PCI@M          DS             7
      ** Previous Control Indicators for main detail screen
 
      ** Standing Data files
      ** ~~~~~~~~ ~~~~ ~~~~~
      ** passed as data structures to lower level modules.
      **
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Modules details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)                      CPM003
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
     ** Trading details
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    CPM003
      ** Portfolio Management ICD
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
     ** Retail ICD
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  QQACC3       E                     EXTFLD(QQACCD)                                     CGL029
      ** Dealing ICD
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  QQACC4       E                     EXTFLD(QQACCD)                                     CGL029
      ** Futures and Options ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFF007
     D  SLCD         E                     EXTFLD(LCD)                                        CFF007
      ** Switchable Features Details                                                          CFF007
                                                                                              CFF007
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
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
     D RespMode        S              1A   INZ('S')
 
      ** The current trading date
     D CTDATE          S                   LIKE(BJRDNB)
 
      ** Enhanced OTCs feature flag
     D CFF001          S              1A
 
      ** --- Parameters for ZATRNRTV ---------------------------------------------------------------
      ** Module ID
     D Module          S              2A   INZ('FF')
 
      ** Transaction type (dummy field as it is not needed for FF)
     D DummyTRTY       S              1A
      ** --- End of parameters for ZATRNRTV --------------------------------------------------------
 
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
 
      ** (imported from module FFVOTCCTYP)
     D NewInst         S              1A   IMPORT
                                                                                              CFF007
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - broker                                                       CFF007
     D PPBBFLG         S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - customer                                                     CFF007
     D PPBFLG          S              1A                                                      CFF007
                                                                                              CFF007
      ** Switchable feature                                                                   CFF007
     D PSARD           S              6A                                                      CFF007
                                                                                              CFF007
     D WReDisplay      S              1A                                                      CFF007
     D WMRKT           S              2A                                                      CFF007
     D WISTC           S              3A                                                      CFF007
     D PRActn          S              1A                                                      CFF007
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D PRTCD           S              7                                                       CGL014
     D POPTN           S              7                                                       CGL014
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFOTCCS001
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FFOTCCS002
 
      * Read next browse subfile record
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCCS003
 
      * Do while screen: main details
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
 
      /COPY WNCPYSRC,FFOTCCS004
 
      * Settlement details processing
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   ENDDO
 
      /COPY WNCPYSRC,FFOTCCS005
                                                                                              CFF007
      ** Private Banking Details                                                              CFF007
                                                                                              CFF007
     C     @SCRN         DOWEQ     'P'                                                        CFF007
     C     CFF007        ANDEQ     'Y'                                                        CFF007
     C                   EXSR      SCRN@P                                                     CFF007
     C                   ENDDO                                                                CFF007
 
      * Screen: window
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCCS006
 
      * Screen: confirmation of input
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCCS007
 
      * Do file updates
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
 
      /COPY WNCPYSRC,FFOTCCS008
 
      * Terminate program
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFOTCCS009
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
 
     C     SCRN@M        BEGSR
 
      * Issue rollback to clear any possible updates in window function
      * Only required if transaction number or action code has been changed
      * (this check will also cater for F12 taken from main screen)
     C     BGWDPR        IFEQ      'Y'
     C     STNBR         IFNE      @PTRNO
     C     SACTN         ORNE      @PACTN                                       165402
     C     @CCI@M        ORNE      @PCI@M
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
 
      * Reset the transaction-number-automatically-generated flag
     C                   RESET                   AutoTran
 
      * Update 'previous' transaction number & screen control indicator
     C                   MOVEL     STNBR         @PTRNO            6
     C                   MOVEL     SACTN         @PACTN            1            165402
     C                   MOVEL     @CCI@M        @PCI@M
 
      * WRITE/READ DISPLAY SCREEN
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCDSP'
     C                   PARM      *BLANK        ReturnCode
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
      *
      * PREMIUM
     C                   PARM                    SPREM
      * TRANSACTION STATUS
     C                   PARM                    FFSTS            24
 
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      * FIELDS IN ERROR
     C                   PARM                    OKCustSet
     C                   PARM                    OKTransDet
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      * ENABLED KEY & DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      *
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      ** CFF001 Enhancement                                                                   CFF007
     C                   PARM                    CFF001                                       CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - ROLL BACKWARDS
      *
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - ROLL FORWARDS
      *
     C     @INKH         CASEQ     '1'           ROLL
      *
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@M
      *
      * CK/15 - BUILD BROWSE
      *
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
      *
     C                   CAS                     VAL@M
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@M  - VALIDATE INPUT TO MAIN DETAILS SCREEN
      *****************************************************************
 
     C     VAL@M         BEGSR
 
      * Retrieve Transaction details
     C                   EXSR      RTVTRN
 
      * If action code or transaction number are NOT OK
      * Re-output screen with error messages on it
     C     OKACTN        IFEQ      'N'
     C     OKTNBR        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      * Set field and function key status on main details screen
      * (according to action code)
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * If action code is delete, or enquire;
      * or action code is amend and transaction number
      * number has changed
      *   Put the transaction on the main details screen
      *
     C     SACTN         IFEQ      'D'
     C     SACTN         OREQ      'E'
     C/COPY WNCPYSRC,FFOTCCSC01
     C     SACTN         OREQ      'A'
     C     STNBR         ANDNE     @PTRNO
     C     SACTN         OREQ      'A'                                          165402
     C     SACTN         ANDNE     @PACTN                                       165402
     C                   EXSR      PUTD@M
     C                   ENDIF
      *
      * If transaction number or screen control
      * indicators have changed
      *   Re-output screen
      *
     C     STNBR         IFNE      @PTRNO
     C     SACTN         ANDNE     'I'
     C     SACTN         ORNE      @PACTN                                       165402
     C     @CCI@M        ORNE      @PCI@M
                                                                                              CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     SACTN         ANDEQ     'I'                                                        CFF007
     C     @PACTN        ANDNE     'I'                                                        CFF007
     C                   MOVE      *BLANKS       NewPBScn                                     CFF007
     C                   ENDIF                                                                CFF007
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     SACTN         IFEQ      'D'
 
      * Update transaction in File Format
     C                   MOVEL     CurTranFil    NewTranFil
 
      * Update transaction settlement details in File Format
     C                   MOVEL     CurTrstFil    NewTrstFil
 
      * IF CK/10 TAKEN, GO ONTO UPDATES
     C     @INKJ         IFEQ      '1'
     C     BGWDPR        IFEQ      'Y'                                                        191171
     C                   MOVEL     'W'           @SCRN                                        191171
     C                   ELSE                                                                 191171
     C                   MOVEL     'U'           @SCRN
     C                   END                                                                  191171
     C                   ENDIF
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     SACTN         IFEQ      'E'
      *
      * Update Transaction in File Format
     C                   MOVEL     CurTranFil    NewTranFil
 
      * Update transaction settlement details in File Format
     C                   MOVEL     CurTrstFil    NewTrstFil
      *
      * If windows processing on, call window routine
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      *
     C     BGWDPR        IFEQ      'Y'
                                                                                              CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     BGN4ST        ANDEQ     'Y'                                                        CFF007
     C                   MOVEL     'P'           @SCRN                                        CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVEL     'W'           @SCRN
     C                   ENDIF                                                                CFF007
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ENDIF
     C                   ENDIF
      *
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
     C/COPY WNCPYSRC,FFOTCCSC02
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACTN         IFEQ      'I'
     C     SACTN         OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Transaction in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   CLEAR                   NewTranFil
     C                   CLEAR                   NewTrstFil
      *
      * IF AMEND
      *
     C     SACTN         IFEQ      'A'
      *
      * Update Transaction in File Format
     C                   MOVEL     CurTranFil    NewTranFil
 
      * Update transaction settlement details in File Format
     C                   MOVEL     CurTrstFil    NewTrstFil
      *
      * Validate whether non-amendable fields have been changed
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCAMD'
      * Outputs
      * ~~~~~~~
      * Return Code
     C                   PARM                    ReturnCode
      * Transaction Details OK flags(DS) from/to caller
     C                   PARM                    OKTransDet
      * Customer Settlement OK flags(DS) from/to caller
     C                   PARM                    OKCustSet
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Amendments OK
     C                   PARM                    @@AMOK            1
      *
      * Inputs
      * ------
      * New transaction in Screen Format
     C                   PARM                    NewTranScn
      * New Customer Settlement deatils in screen format
     C                   PARM                    NewCuStScn
      * Current transaction in Screen Format
     C                   PARM                    CurTranScn
      * Current Customer Settlement Details in Screen Format
     C                   PARM                    CurCuStScn
      * Current transaction in file format
     C                   PARM                    CurTranFil
      * Standing Data ICD
     C                   PARM                    SDBANK
      * Midas modules
     C                   PARM                    SDMMOD
      * General Ledger ICD
     C                   PARM                    SDGELR
      ** O.T.C. instrument switchable field
     C                   PARM                    CFF001
      ** Portfolio Management Details                                           CPB001
     C                   PARM                    SDPORT                         CPB001
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
     C                   ENDIF
 
      * If errors returned by the amend function, do not do validation
      * processing.
     C                   IF        Idx = 0
      *
      * Validate Transaction details
      *
     C                   CALLB     'FFOTCCVAL'
      *
      * Outputs
      * ~~~~~~~
     C                   PARM      *BLANKS       ReturnCode
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
     C                   PARM                    SDBRCH
     C                   PARM                    CTDATE
     C                   PARM                    InstType
     C                   PARM                    SPREM
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBFLG                                       CFF007
      *
      * Inputs
      * ~~~~~~
     C                   PARM                    RespMode
     C                   PARM                    NewTranScn
      ** Extension file data                                                    CAP004
     C                   PARM                    ExtData                        CAP004
      ** ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
     C                   PARM                    SDFODA
     C                   PARM                    SDDEAL
     C                   PARM                    SDPORT                                        CPM00
      ** O.T.C. instrument switchable field
     C                   PARM                    CFF001
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
     C                   PARM                    S01457                                       208635
 
     C                   ENDIF
      *                  (End of "If no errors returned by amend")
 
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      * Continue to settlements screen
     C                   MOVEL     'S'           @SCRN
 
     C                   ENDIF
                                                                                              CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     NewInst       ANDEQ     'Y'                                                        CFF007
     C     SACTN         ANDEQ     'I'                                                        CFF007
     C                   MOVE      *ALL'Y'       OKPBFlag                                     CFF007
     C                   MOVE      *BLANKS       NewPBScn                                     CFF007
     C                   ENDIF                                                                CFF007
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT                                                                                  CFF007
      *****************************************************************                       CFF007
      * VAL@P  - Validate input for Private Banking Details                                   CFF007
      *****************************************************************                       CFF007
                                                                                              CFF007
     C     VAL@P         BEGSR                                                                CFF007
                                                                                              CFF007
      ** If Enquire                                                                           CFF007
                                                                                              CFF007
     C     SACTN         IFEQ      'E'                                                        CFF007
                                                                                              CFF007
      ** If windows processing on, call window routine                                        CFF007
      ** If browse outstanding, read next browse subfile record                               CFF007
                                                                                              CFF007
     C     BGWDPR        IFEQ      'Y'                                                        CFF007
     C                   MOVEL     'W'           @SCRN                                        CFF007
                                                                                              CFF007
     C                   ELSE                                                                 CFF007
     C     @RDNB         IFEQ      'Y'                                                        CFF007
     C                   MOVEL     'R'           @SCRN                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   GOTO      EVAL@P                                                     CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      **---------------------------------------------------------------                       CFF007
      ** If Insert or Amend                                                                   CFF007
     C     SACTN         IFEQ      'I'                                                        CFF007
     C     SACTN         OREQ      'A'                                                        CFF007
                                                                                              CFF007
     C                   Z-ADD     *ZERO         Idx                                          CFF007
     C                   Z-ADD     *ZERO         WIdx                                         CFF007
                                                                                              CFF007
      ** If errors returned by the amend function, do not do validation                       CFF007
      ** processing.                                                                          CFF007
                                                                                              CFF007
     C                   IF        Idx = 0                                                    CFF007
     C                   EVAL      WReDisplay = 'N'                                           CFF007
                                                                                              CFF007
     C     SCOVE         IFEQ      *Blanks                                                    CFF007
     C     SHETR         OREQ      *Blanks                                                    CFF007
     C     SBLUP         OREQ      *Blanks                                                    CFF007
     C                   EVAL      WReDisplay = 'Y'                                           CFF007
     C                   ENDIF                                                                CFF007
     c                                                                                        CFF007
     C     NewInst       IFEQ      'Y'                                                        CFF007
     C     BGSECS        ANDEQ     'Y'                                                        CFF007
     C     STECO         IFEQ      *Blanks                                                    CFF007
     C     STNAT         OREQ      *Blanks                                                    CFF007
     C     SCRIK         OREQ      *Blanks                                                    CFF007
     C     SCCYR         OREQ      *Blanks                                                    CFF007
     C     STWEI         OREQ      *Blanks                                                    CFF007
     C                   EVAL      WReDisplay = 'Y'                                           CFF007
     C                   ENDIF                                                                CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** Validate Transaction details                                                         CFF007
                                                                                              CFF007
     C                   CALLB     'FFOTCC2VL'                                                CFF007
      ** Outputs                                                                              CFF007
      ** ~~~~~~~                                                                              CFF007
     C                   PARM      *BLANKS       ReturnCode                                   CFF007
     C                   PARM                    OKTransDet                                   CFF007
     C                   PARM                    OKDummyDS                                    CAP166
     C                   PARM                    Idx                                          CFF007
     C                   PARM                    FldNameArr                                   CFF007
     C                   PARM                    MsgIDArr                                     CFF007
     C                   PARM                    MsgDtaArr                                    CFF007
     C                   PARM                    WIdx                                         CFF007
     C                   PARM                    WFldNamArr                                   CFF007
     C                   PARM                    WMsgIDArr                                    CFF007
     C                   PARM                    WMsgDtaArr                                   CFF007
     C                   PARM                    NewTranFil                                   CFF007
     C                   PARM                    InstType                                     CFF007
      *                                                                                       CFF007
      * Inputs                                                                                CFF007
      * ~~~~~~                                                                                CFF007
     C                   PARM                    NewTranScn                                   CFF007
     C                   PARM                    DummyTIn                                     CAP166
     C                   PARM                    NewInst                                      CFF007
      ** ICD                                                                                  CFF007
     C                   PARM                    SDBANK                                       CFF007
     C                   PARM                    SDMMOD                                       CFF007
     C                   PARM                    SDGELR                                       CFF007
     C                   PARM                    SDFODA                                       CFF007
     C                   PARM      'OTCC'        TransType                                    CAP166
                                                                                              CFF007
     C     WReDisplay    IFEQ      'Y'                                                        CFF007
     C                   GOTO      EVAL@P                                                     CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      * If errors returned                                                                    CFF007
     C     Idx           IFNE      0                                                          CFF007
     C                   GOTO      EVAL@P                                                     CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      **---------------------------------------------------------------                       CFF007
      ** Continue to windows screen                                                           CFF007
     C     BGWDPR        IFEQ      'Y'                                                        CFF007
     C                   MOVEL     'W'           @SCRN                                        CFF007
     C                   ELSE                                                                 CFF007
                                                                                              CFF007
      ** Otherwise continue to the confirmation screen                                        CFF007
     C                   MOVEL     'C'           @SCRN                                        CFF007
                                                                                              CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** Clear any warning messages                                                           CFF007
                                                                                              CFF007
     C                   MOVEL     *BLANK        WFldNamArr                                   CFF007
     C                   MOVEL     *BLANK        WMsgIdArr                                    CFF007
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CFF007
                                                                                              CFF007
     C     EVAL@P        ENDSR                                                                CFF007
                                                                                              CFF007
      *****************************************************************                       CFF007
      /EJECT                                                                                  CFF007
      *****************************************************************                       CFF007
      * SCRN@P - Process Screen: Private Banking Details                                      CFF007
      *****************************************************************                       CFF007
                                                                                              CFF007
     C     SCRN@P        BEGSR                                                                CFF007
                                                                                              CFF007
      ** Write/read display screen                                                            CFF007
                                                                                              CFF007
     C                   RESET                   ReturnCode                                   CFF007
     C                   CALLB     'FFOTCC2DP'                                                CFF007
      ** Return Code                                                                          CFF007
     C                   PARM                    ReturnCode                                   CFF007
      ** Transaction (in screen format)                                                       CFF007
     C                   PARM                    NewTranScn                                   CFF007
      ** Premium                                                                              CFF007
     C                   PARM                    SPREM                                        CFF007
     C                   PARM                    NewInst                                      CFF007
     C                   PARM                    SDBANK                                       CFF007
     C                   PARM                    SDMMOD                                       CFF007
     C                   PARM                    SDGELR                                       CFF007
      ** Fields in error                                                                      CFF007
     C                   PARM                    OKTransDet                                   CFF007
      ** Errors                                                                               CFF007
     C                   PARM                    FldNameArr                                   CFF007
     C                   PARM                    MsgIdArr                                     CFF007
     C                   PARM                    MsgDtaArr                                    CFF007
      ** Warnings                                                                             CFF007
     C                   PARM                    WFldNamArr                                   CFF007
     C                   PARM                    WMsgIdArr                                    CFF007
     C                   PARM                    WMsgDtaArr                                   CFF007
     C                   PARM                    PRActn                                       CFF007
                                                                                              CFF007
      ** Output                                                                               CFF007
      ** Function keys                                                                        CFF007
     C                   PARM                    @INKC                                        CFF007
     C                   PARM                    @INKL                                        CFF007
                                                                                              CFF007
     C                   MOVEL     *BLANK        FldNameArr                                   CFF007
     C                   MOVEL     *BLANK        MsgIdArr                                     CFF007
     C                   MOVEL     *BLANK        MsgDtaArr                                    CFF007
     C                   MOVEL     *BLANK        WFldNamArr                                   CFF007
     C                   MOVEL     *BLANK        WMsgIdArr                                    CFF007
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CFF007
                                                                                              CFF007
     C                   SELECT                                                               CFF007
                                                                                              CFF007
      ** CK/3 - End Program                                                                   CFF007
     C     @INKC         WHENEQ    '1'                                                        CFF007
     C                   EXSR      ENDP                                                       CFF007
                                                                                              CFF007
      ** CK/12 - Cancel on Private Banking Screen                                             CFF007
     C     @INKL         WHENEQ    '1'                                                        CFF007
     C                   MOVEL     'M'           @SCRN                                        CFF007
                                                                                              CFF007
      ** Validate input to private banking detail screen                                      CFF007
     C                   OTHER                                                                CFF007
     C                   EXSR      VAL@P                                                      CFF007
     C                   ENDSL                                                                CFF007
                                                                                              CFF007
     C                   ENDSR                                                                CFF007
      *****************************************************************                       CFF007
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
      ** ~~~~~~~
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
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      * Write out screen to remove error messages
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCDSP'
     C                   PARM                    ReturnCode
      *
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
      *
      * PREMIUM
     C                   PARM                    SPREM
      *
      * TRANSACTION STATUS
     C                   PARM                    FFSTS            24
      *
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      *
      *
      * FIELDS IN ERROR
     C                   PARM                    OKCustSet
     C                   PARM                    OKTransDet
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      *
      * Write screen with no read indicator
     C                   PARM      'Y'           WriteOnly
      ** CFF001 Enhancement                                                                   CFF007
     C                   PARM                    CFF001                                       CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
      * If transaction number not defined (on insert),
      * get next available transaction number.
     C                   IF        STNBR = *blank
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZATRNRTV'
     C                   PARM                    ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY
     C                   PARM                    STNBR
     C                   PARM                    VTNBR
 
      * End in error if generator returned an error
     C                   IF        ReturnCode <> *blank
     C                   MOVEL     'ZATRNRTV'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     STNBR         DBKEY                         ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set a flag to indicate that the transaction number was generated
      * rather than entered.
     C                   EVAL      AutoTran = 'Y'
 
     C                   ENDIF
 
     C/COPY WNCPYSRC,FFTRANSMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'FFOTCCSIN'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      SACTN         ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, or in enquiry, return to main details screen;
      *  otherwise, go to settlements screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     SACTN         OREQ      'E'
     C     @RDNB         IFEQ      'Y'
 
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     BGN4ST        ANDEQ     'Y'                                                        CFF007
     C     SACTN         ANDEQ     'E'                                                        CFF007
     C     #RTRN         ANDNE     'USR0790'                                                  CFF007
     C                   MOVEL     'P'           @SCRN                                        CFF007
     C                   ENDIF                                                                CFF007
 
     C                   ENDIF
 
     C                   ELSE
 
     C     SACTN         IFEQ      'D'                                                        191171
     C                   EVAL      @SCRN = 'U'                                                191171
     C                   ELSE                                                                 191171
     C                   EVAL      @SCRN = 'C'
     C                   END                                                                  191171
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     WIND          ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH TRANSACTION FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * Default action code to enquiry if not valid
      *
     C     SACTN         IFNE      'A'
     C     SACTN         ANDNE     'D'
     C/COPY WNCPYSRC,FFOTCCSC03
     C                   MOVE      'E'           SACTN
     C                   ENDIF
      *
      * READ NEXT OR PREVIOUS RECORD ON TRANSACTION FILE
      * ACCORDING TO COMMAND KEY TAKEN (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   ENDIF
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCRED'
     C                   PARM                    ReturnCode
      * Inputs
      * ------
      * Transaction number
     C                   PARM                    STNBR             6
      * Read forwards
     C                   PARM                    @RDFWD            1
      * Read backwards
     C                   PARM                    @RDBCK            1
     C                   PARM                    SDBANK
      * Outputs
      * ~~~~~~~
      * Error message
     C                   PARM                    @ERRMS            7
      * Transaction number read
     C                   PARM                    @TRRED            6
     C/COPY WNCPYSRC,FFOTCCSC04
 
 
      * If error message returned from read, send it to detail screen
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EROLL
     C                   ENDIF
      *
      * If transaction read
      *
     C     @TRRED        IFNE      *BLANK
      *
      * Retrieve transaction details
      *
     C                   MOVEL     @TRRED        STNBR
     C                   EXSR      RTVTRN
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the transaction on the main details screen
      *
     C                   EXSR      PUTD@M
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTRANBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        ReturnCode
      *
      * TRANSACTION NUMBER POINTER
     C                   PARM                    STNBR             6
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
     C                   PARM                    SDBANK
      * Transaction type
     C                   PARM                    TransType
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANKS       @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * TRANSACTION NUMBER SELECTED
     C                   PARM      *BLANK        @TRSEL            6
      *
      * MEMBER SELECTED
     C                   PARM      *BLANK        @MBSEL            2
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C/COPY WNCPYSRC,FFOTCCSC05
      *
      * If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      '1'
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
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   ENDIF
      *
      * If CK/12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EBLDBR
     C                   ENDIF
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTRANBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        ReturnCode
      *
      * TRANSACTION NUMBER POINTER
     C                   PARM                    STNBR             6
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
     C                   PARM                    SDBANK
      * Transaction type
     C                   PARM                    TransType
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * TRANSACTION NUMBER SELECTED
     C                   PARM      *BLANK        @TRSEL            6
      *
      * MEMBER SELECTED
     C                   PARM      *BLANK        @MBSEL            2
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C/COPY WNCPYSRC,FFOTCCSC06
      *
      * IF TRANSACTION READ FROM SUBFILE
      *
     C     @TRSEL        IFNE      *BLANK
      *
      * Retrieve transaction details
      *
     C                   MOVEL     @OPSEL        SACTN
     C                   MOVEL     @TRSEL        STNBR
     C                   EXSR      RTVTRN
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
      *
      * Put the transaction on the main details screen
      *
     C                   EXSR      PUTD@M
      *
      * ELSE, RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   ENDIF
      *
      * GO TO MAIN DETAILS SCREEN
      *
     C                   MOVE      'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRN - RETRIEVE TRANSACTION
      *****************************************************************
 
     C     RTVTRN        BEGSR
 
     C                   CALLB     'FFOTCCRTV'
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * Inputs
      * ------
      * Mode = '*FRONT' (front office transaction interface)
      * Mode = '      ' (not front office transaction interface) (6A)
     C                   PARM      '      '      @@MODE            6
      * Response mode (1A)
     C                   PARM      'S'           @@RSMD            1
      * Action Code (1A)
     C                   PARM                    SACTN
      * Front Office Transaction ID (20A)
     C                   PARM                    FOTRID           20
      * (Midas) Transaction Number (6A)
     C                   PARM                    STNBR
      ** Module being called as linked enquiry (1A)
     C                   PARM                    LinkEnq
      * Bank details ICD
     C                   PARM                    SDBANK
      * General Ledger ICD
     C                   PARM                    SDGELR
      * Multibranching indicator
     C                   PARM                    BGMBIN
                                                                                              CAP166
      ** Transaction type                                                                     CAP166
                                                                                              CAP166
     C                   PARM      'OTCC'        TransType                                    CAP166
                                                                                              CAP166
      * Outputs
      * ~~~~~~~
      ** (Current) transaction in file format
     C                   PARM                    CurTranFil
      ** (Current) Settlements in file format
     C                   PARM                    CurTrstFil
      ** Instrument Types
     C                   PARM                    InstType
      * OK - Action code (1A)
     C                   PARM      *BLANK        OKACTN
      * OK - Transaction Number (1A)
     C                   PARM      *BLANK        OKTNBR
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@M - PUT A TRANSACTION ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     PUTD@M        BEGSR
      *
      * Call program to fill screen fields with data from TRANSD
      *
     C                   CALLB     'FFOTCCCVT'
      *
      * Inputs
      * ~~~~~~
     C                   PARM      *BLANKS       ReturnCode
      * Transaction in file format
     C                   PARM                    CurTranFil
      * Instrument types
     C                   PARM                    InstType
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      *
      * Outputs
      * ~~~~~~~
      * Transaction in screen format
     C                   PARM                    NewTranScn
      * Premium
     C                   PARM                    SPREM            15
      * Transaction Status
     C                   PARM                    FFSTS            24
      ** CFF001 Enhancement                                                                   CFF007
     C                   PARM                    CFF001                                       CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
 
     C                   EVAL      CustBrokFl = 'C'
 
     C                   CALLB     'FFSETLCVT'
      *
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM      *BLANKS       ReturnCode
      ** Customer settlement instructions, screen format
     C                   PARM                    NewCuStScn
      ** Broker settlement instructions, screen format
     C                   PARM                    NewBrStScn
      *
      * Inputs
      * ~~~~~~
      * Settlements in file format
     C                   PARM                    CurTrstFil
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Midas Transaction Number
     C                   PARM                    STNBR
      ** Instrument currency
     C                   PARM                    ISCY
 
      * Update 'Current' Deal with Deal in Screen Format
      *
     C                   MOVEL     NewTranScn    CurTranScn
     C                   MOVEL     NewCuStScn    CurCuStScn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@M - SET FIELD STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFDS@M        BEGSR
      *
      * Enable/disable key & detail fields on main details screen
      * (key fields = action code & transaction number.
      *  detail fields = rest)
      * (Action code can only be 'I', 'A', 'E' or 'D')
      *
     C     SACTN         IFEQ      'I'
     C     SACTN         OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@M - SET FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *          ACCORDING TO ACTION CODE
      *****************************************************************
     C     SFKS@M        BEGSR
      *
      * Enable/disable function keys on main details screen
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     SACTN         IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   ENDIF
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@M - INITIALIZE FIELD STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFDS@M        BEGSR
      *
      * ENABLE KEY & DETAILS FIELDS ON MAIN DETAILS SCREEN
      *
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@M - INITIALIZE FUNCTION KEY STATUS ON MAIN DETAILS SCREEN
      *****************************************************************
     C     IFKS@M        BEGSR
      *
      * ENABLE/DISABLE FUNCTION KEYS ON MAIN DETAILS SCREEN
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'Y'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@M - CANCEL ON MAIN DETAILS SCREEN
      *****************************************************************
     C     CANC@M        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * If input fields are enabled
      * Blank the main details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NewTranScn
     C                   MOVEL     *BLANK        NewCuStScn
     C                   MOVEL     *BLANK        SPREM
     C                   MOVEL     *BLANK        FFSTS
     C                   EVAL      DummyTIn = *BLANKS                                         CAP166
     C                   ENDIF
      *
      * Initialize field and function key status on main details screen
      *
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - SEND A MESSAGE TO MAIN DETAILS SCREEN
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           OKACTN
     C                   ENDIF
      *
      ** Transaction number on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'APM0112'
     C                   MOVE      'N'           OKTNBR
     C                   ENDIF
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SCRN@S    -  Not exactly a separate screen but the bottom     *
      *              half of the main details input screen.           *
      *              This validates the charges and commission        *
      *              details and applies default settlement           *
      *              instructions if none have been applied;          *
      *              otherwise settlement details are converted and   *
      *              validated.                                       *
      *****************************************************************
 
     C     SCRN@S        BEGSR
 
      * This routine is called if none of the settlement fields have been
      * entered.
     C                   IF            (NewCuStScn = *blank)
 
      ** Default customer instructions
 
     C                   EVAL      CustBrokFl = 'C'
     C**********         MOVE      *ZERO         CustBrokNo                                   CSD027
     C                   EVAL      CustBrokNo = *BLANKS                                       CSD027
     C                   MOVEL     SCUSC         CustBrokNo
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLDFT'
      *  Outputs
      *  ~~~~~~~
      *                      Return code
     C                   PARM                    ReturnCode
      *                      Broker settlement instructions
     C                   PARM                    NewBrStScn
      *                      Customer settlement instructions
     C                   PARM                    NewCuStScn
      *  Inputs
      *  ~~~~~~
      *  Customer/broker flag
     C                   PARM                    CustBrokFl
      *  Customer or broker number
     C                   PARM                    CustBrokNo
      *  Market centre
     C                   PARM                    DummyMark
      *  Instrument code
     C                   PARM                    DummyInst
      ** Transaction type (purchase or sale) (1A)
     C                   PARM                    STRTY
      *  Enhanced OTCs feature flag
     C                   PARM                    CFF001
 
     C                   ENDIF
      *                  (End of "If no settlement instructions entered")
 
      * Validate the customer charge and commission details
 
     C                   EXSR      ValChgCom
 
      ** Validate customer settlement instructions
 
     C                   RESET                   CustSetErr
     C                   EVAL      CustBrokFl = 'C'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLVAL'
      ** Outputs
      ** ~~~~~~~
      **
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    NewTrstFil
      ** Inputs
      ** ~~~~~~
      ** Data structure containing broker settlement details
     C                   PARM                    NewBrStScn
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Data structure containing broker settlement OK flags
     C                   PARM                    OKBrokSet
      ** Data structure containing customer settlement OK flags
     C                   PARM                    OKCustSet
      ** Customer/ Broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Branch code (3A, from transaction)
     C                   PARM                    SBRCD
      ** Portfolio reference (4A)
     C                   PARM                    SPTFR
      ** Instrument currency (3A)
     C                   PARM                    VISCY
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    VTRSD
      ** Broker Code (6S,0 from FFVTRANPD)
     C                   PARM                    VBOCO
      ** Customer Code (6S,0 from FFVTRANPD)
     C                   PARM                    VCUSC
      ** Branch internal customer number (from SDBRCHPD)
     C                   PARM                    A8BICN
      ** Current trading date
     C                   PARM                    CTDATE
      ** Bank Details ICD
     C                   PARM                    SDBANK
      ** General Ledger ICD
     C                   PARM                    SDGELR
      ** Midas Modules ICD
     C                   PARM                    SDMMOD
      ** Trading ICD
     C                   PARM                    SDTRAD
      ** Portfolio Management ICD
     C                   PARM                    SDPORT
      ** Retail ICD
     C                   PARM                    SDRETL
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator - Broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - Customer                                                     CFF007
     C                   PARM                    PPBFLG                                       CFF007
      ** Collaterals Processing enhancement                                                   CGL014
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
 
      * If settlement or charge and commission details invalid,
      * return to main details screen.
     C                   IF        CustSetErr = 'Y' OR CustCCErr = 'Y'
 
     C                   MOVEL     'M'           @SCRN
 
     C                   ELSE
 
      * Otherwise, if windows on, show windows screen
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
 
      * Otherwise continue to the confirmation screen
     C                   MOVEL     'C'           @SCRN
 
     C                   ENDIF
                                                                                              CFF007
      ** Continue to Private Banking Screen                                                   CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     BGN4ST        ANDEQ     'Y'                                                        CFF007
     C                   MOVEL     'P'           @SCRN                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** Clear message warnings                                                               CFF007
     C                   MOVE      *ALL'Y'       OKBrokSet                                    CFF007
     C                   MOVE      *ALL'Y'       OKCustSet                                    CFF007
     C                   MOVE      *ALL'Y'       OKTransDet                                   CFF007
     C                   MOVEL     *BLANKS       WFldNamArr                                   CFF007
     C                   MOVEL     *BLANKS       WMsgIdArr                                    CFF007
     C                   MOVEL     *BLANKS       WMsgDtaArr                                   CFF007
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
 
     C     SCRN@C        BEGSR
 
      * If transaction is valid output message 'Press enter to accept'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0121'     MsgIdArr(1)
 
      * WRITE/READ DISPLAY SCREEN
     C                   RESET                   ReturnCode
     C                   CALLB     'FFOTCCDSP'
     C                   PARM                    ReturnCode
      *
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
      *
      * PREMIUM
     C                   PARM                    SPREM            15
      *
      * TRANSACTION STATUS
     C                   PARM                    FFSTS            24
      *
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      *
      * FIELDS IN ERROR
     C                   PARM                    OKCustSet
     C                   PARM                    OKTransDet
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKP            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SIDN             6
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      *
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      ** CFF001 Enhancement                                                                   CFF007
     C                   PARM                    CFF001                                       CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
 
     C     CANC@C        BEGSR
 
      * RETURN TO MAIN DETAILS SCREEN
     C                   MOVEL     'M'           @SCRN
 
      * If F12 was pressed on the confirm screen, and the transaction number
      * was automatically generated, blank it out and do a rollback to
      * release the generated transaction number.
     C                   IF        AutoTran = 'Y'
     C                   CLEAR                   STNBR
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
 
      * Initialize field status on main details screen
     C                   EXSR      IFDS@M
 
      * Set function key status on main details screen
      * (according to action code)
     C                   EXSR      SFKS@M
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@M
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFKS@M
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
 
     C     Updats        BEGSR
 
      * If transaction number not defined (on insert),
      * get next available transaction number.
     C                   IF        STNBR = *blank
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZATRNRTV'
     C                   PARM                    ReturnCode
     C                   PARM                    Module
     C                   PARM                    DummyTRTY
     C                   PARM                    STNBR
     C                   PARM                    VTNBR
 
      * End in error if generator returned an error
     C                   IF        ReturnCode <> *blank
     C                   MOVEL     'ZATRNRTV'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 001*
     C                   MOVEL     STNBR         DBKEY                         ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set a flag to indicate that the transaction number was generated
      * rather than entered.
     C                   EVAL      AutoTran = 'Y'
 
     C**********         EVAL      @SIDN = STNBR                                166907
 
     C                   ENDIF
      *                                                                         166907
      ** Succesfully Inserted Deal Number                                       166907
      *                                                                         166907
     C                   EVAL      @SIDN = STNBR                                166907
 
      ** Settlements file version of transaction number
     C                   EVAL      VSTNBR = VTNBR
 
      * Set the change type equal to the action code
     C                   EVAL      VCHTP  = SACTN
 
      ** Update the main transaction details
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTRANUPD'
      ** Returned parameters
      ** -------------------
     C                   PARM                    ReturnCode
      ** Sent parameters
      ** ---------------
      ** The format containing the valid transaction
     C                   PARM                    NewTranFil
      ** The instrument details (data structure)
     C                   PARM                    InstType
      ** The settlement details (data structure)
     C                   PARM                    NewTrstFil
      ** A code to indicate whether the trade is an OTC or an exchange-
      ** traded one.
     C                   PARM                    TransType
      ** New OTC instrument Y/N
     C                   PARM                    NewInst
      ** Whether switchable feature CFF001 (Enhanced OTCs) is on
     C                   PARM                    CFF001
      ** General Ledger ICD (SDGELRPD data structure
     C                   PARM                    SDGELR
      ** Midas modules (DS, from SDMMODPD)
     C                   PARM                    SDMMOD
      ** Trade and book positions reconcilable flag (from SDFODAPD)
     C                   PARM                    BXTBRC
 
 
      ** If no errors, update settlement instructions.
     C**********         IF        ReturnCode <> 'Error'                        CAP006
     C                   IF        ReturnCode <> 'Error' and
     C                             ReturnCode <> '*RECUPD'                      CAP006
 
      * Update the settlement instructions.
     C                   CALLB     'FFSETLUPD'
      * Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      *
      *  Inputs
      *  ~~~~~~
      ** The format containing the valid settlements (data structure)
     C                   PARM                    NewTrstFil
      ** The format containing the valid transaction (data structure)
     C                   PARM                    NewTranFil
      ** The instrument details (data structure)
     C                   PARM                    InstType
      ** Multibranching indicator
     C                   PARM                    BGMBIN
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator (Broker)                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator (Customer)                                                     CFF007
     C                   PARM                    PPBFLG                                       CFF007
 
     C                   ENDIF
      **                 (End of "If return code <> 'Error'")
 
      * If there were any errors in the update functions, rollbacm any
      * updates and end this module. Otherwise commit the updates.
     C                   IF        ReturnCode <> '*RECUPD'                      CAP006
     C                   IF        ReturnCode <> *blanks
 
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpCom = 'N'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Endif                                                                CSC022
     C                   Endif                                                                CSC022
     C                   EXSR      *pssr
 
     C                   ELSE
 
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpCom = 'N')                        CSC022
     C                   COMMIT
     C                   Endif                                                                CSC022
     C/COPY WNCPYSRC,FFOTCCSC07
 
     C                   ENDIF                                                  CAP006
      *
     C                   ELSE
     C** If update not done due to record being updated by another              CAP006
     C** workstation send message to screen.                                    CAP006
     C                                                                          CAP006
     C                   MOVEL     '*ANY'        FldNameArr(1)                  CAP006
     C                   MOVEL     'MMM1067'     MsgIdArr(1)                    CAP006
     C                                                                          CAP006
     C                   END                                                    CAP006
     C                                                                          CAP006
      ** Remove the multimembered file overrides for this transaction
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
     C**********         ENDIF                                                  CAP006
      *
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NewTranScn
     C                   MOVEL     *BLANK        NewCuStScn
     C                   MOVEL     *BLANK        SPREM
     C                   MOVEL     *BLANK        FFSTS
 
      * Initialize field and function key status on main details screen
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
 
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
 
      * ELSE, RETURN TO MAIN DETAILS SCREEN
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - END PROGRAM
      *****************************************************************
 
     C     ENDP          BEGSR
 
      * Issue rollback to clear any possible updates in window function
 
     C     BGWDPR        IFEQ      'Y'
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
 
     C                   MOVEL     'T'           @SCRN
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
     C                   RESET                   ReturnCode
     C                   CALLB     'FFVCHGCOM'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return Code
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Broker settlement OK flags.
     C                   PARM                    OKBrokSet
      ** Customer settlement OK flags
     C                   PARM                    OKCustSet
      ** The valid settlements file format (data structure, from FFVSETLPD)
     C                   PARM                    NewTrstFil
 
      ** Inputs to called procedure
      ** --------------------------
      ** Data structure containing customer settlement details
     C                   PARM                    NewCuStScn
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
     C                   PARM                    BrokerFlag
      ** Instrument currency (3A)
     C                   PARM                    VISCY
      ** Broker/Custom Chrg/com. Patterns (1A)
     C                   PARM                    ITBCPT                                       CFF007
      ** Market (2A)                                                                          CFF007
     C                   PARM      *BLANKS       WMRKT                                        CFF007
      ** Instrument (3A)                                                                      CFF007
     C                   PARM      *BLANKS       WISTC                                        CFF007
      ** Number of Contracts (5.0P)                                                           CFF007
     C                   PARM                    VNUCO                                        CFF007
      ** Action Code used  (1A)                                                               CFF007
     C                   PARM                    SACTN                                        CFF007
      ** Broker                                                                               CFF007
     C                   PARM                    VBOCO                                        CFF007
      ** Futures and Options Enhancement for Private Banking                                  CFF007
     C                   PARM                    CFF007                                       CFF007
      ** Private Banking Customer Inidcator                                                   CFF007
     C                   PARM                    PPBFLG                                       CFF007
 
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
 
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Get the module flags
     C                   CALLB     'AOMMODR0'                                                  CPM00
     C                   PARM      *BLANKS       @RTCD                                         CPM00
     C                   PARM      '*FIRST '     @OPTN                                         CPM00
     C     SDMMOD        PARM      SDMMOD        DSFDY                                         CPM00
 
      ** Get the General Ledger ICD
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Get the trading details
     C                   CALLB     'AOTRADR0'                                                  S0119
     C                   PARM      '*DBERR '     @RTCD             7                           S0119
     C                   PARM      '*FIRST '     @OPTN             7                           S0119
     C     SDTRAD        PARM      SDTRAD        DSFDY                                         S0119
 
      ** Access Dealing ICD
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
 
      ** Get the portfolio ICD
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
 
      ** Get the retail ICD
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
 
      ** Futures and Options ICD
     C                   CALL      'AOFODAR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDFODA        PARM      SDFODA        DSFDY
 
      ** Access SAR Details to determine whether Enhanced OTCs is present
     C                   EVAL      CFF001 = 'N'                                               CFF007
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFF001'      @SARD             6
 
     C                   IF        @RTCD = *blank
     C                   EVAL      CFF001 = 'Y'
     C                   ENDIF
                                                                                              CFF007
      ** Determine if CFF007 is installed                                                     CFF007
                                                                                              CFF007
     C                   CALLB     'AOSARDR0'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*VERIFY'     @OPTN                                        CFF007
     C                   PARM      'CFF007'      PSARD                                        CFF007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFF007
                                                                                              CFF007
     C     @RTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVE      'Y'           CFF007                                       CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      'N'           CFF007                                       CFF007
     C                   ENDIF                                                                CFF007
                                                                                              208635
      ** Determine if S01457 is installed                                                     208635
                                                                                              208635
     C                   CALLB     'AOSARDR0'                                                 208635
     C                   PARM      *BLANKS       @RTCD                                        208635
     C                   PARM      '*VERIFY'     @OPTN                                        208635
     C                   PARM      'S01457'      PSARD                                        208635
     C     SCSARD        PARM      SCSARD        DSFDY                                        208635
                                                                                              208635
     C     @RTCD         IFEQ      *BLANKS                                                    208635
     C                   MOVE      'Y'           S01457            1                          208635
     C                   ELSE                                                                 208635
     C                   MOVE      'N'           S01457                                       208635
     C                   ENDIF                                                                208635
 
      ** Set the transaction type field used by the database updater
     C                   EVAL      TransType = 'OTCC'
 
      ** Start on Main Details Screen
     C                   MOVEL     'M'           @SCRN             1
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
     C                   Eval      DBASE = 003                                                CSC022
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Initialize field and function key status on main details screen
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFOTCCS010
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
