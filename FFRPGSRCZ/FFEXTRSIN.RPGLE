     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Exchange-traded input')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFEXTRSIN - FUTURES AND OPTIONS SCREEN INPUT                 *
      *             (Exchange-Traded)                                 *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Futures and Options.                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26918           Date 19Jan09               *
      *                 CAP191             Date 26Nov09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240193             Date 12Jul06               *
      *                 239740             Date 29May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG1028            Date 02Feb06               *
      *                 CER001             Date 25Apr05               *
      *                 BG9185             Date 08Nov05               *
      *                 BUG6495            Date 08Apr05               *
      *                 BUG2982            Date 04Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 208635             Date 16Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 205649             Date 29May02               *
      *                 204224             Date 15May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198102             Date 14Feb02               *
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191171             Date 26Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 173665             Date 27Apr00               *
      *                 166907             Date 04Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 165402             DATE 04Aug99               *
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 19Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  BUG26918 - Extra projects found in Drop 1 sources            *
      *           - Physically delete codes of CAP201 and CSC022      *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs (Recompile)       *
      *  240193 - Apply fix 239740.                                   *
      *  239740 - Recompiled over changed FFSETLVAL module.           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10289 - Database Error during Amend/Delete                *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  BUG6495 - BUG2982 is causing screen being re-display when    *
      *            there are nothing changed in the second srceen.    *
      *  BUG2982 - Amend module FFEXTRSIN to correctly default FF     *
      *            settlement details.  Apply part of fix 220467.     *
      *            Also, reverse part of 205649 such that settlement  *
      *            details input by the user are not overridden by    *
      *            default settlement details.                        *
      *  CGL014 - Collaterals Processing                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208635 - Allow broker if S01457 is installed.                *
      *  205649 - Settlement type not being defaulted when F12 is     *
      *           pressed to change Broker/Customer number. Fix is to *
      *           default Settlement Type when F12 is pressed and     *
      *           Broker/Customer number has been changed.            *
      *  204224 - Incorrect message appears when deleting/amending    *
      *           a transaction.  Change program to check for value   *
      *           of SACTN (Action Code field) before displaying msg. *
      *  198102 - Warning messages (if any) are not processed if no   *
      *           error messages encountered.                         *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  191171 - Window does not appear if action is D               *
      *  173665 - Call VAL@M in RDNBRW to validate returned fields    *
      *  166907 - @SIDN is not updated correctly causing message :    *
      *           'Tran No. 999999 successfully inserted' not to be   *
      *           displayed.                                          *
      *  165402 - Fields on deals are being corrupted on amendment    *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
                                                                                              CER001
     F***FFTRX2L0  IF   E           K DISK                                           CER001 BUG10289
     FFFTRX2L0  IF   E           K DISK    USROPN                                           BUG10289
     F                                     RENAME(TRANSDD6:RTVIDX)                            CER001
     F                                     INFSR(*PSSR)                                       CER001
                                                                                              CER001
      *****************************************************************                       CER001
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
 
     D/COPY QWINDSRC,FFTRANSDTA
 
     D DATALUX         DS          1024                                                       CER001
     D  #1LFLD1                1      6  0                                                    CER001
      *                                                                                       CER001
     D  #1ISTT                 1      5                                                       CER001
     D  #1TNBR                 6     11                                                       CER001
     D  #1MRKT                12     13                                                       CER001
     D  #1FOTR                14     33                                                       CER001
     D  #1TMST                34     59Z                                                      CER001
 
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
 
     D CurTranScn    E DS                  EXTNAME(FFEXTRPD)
      * Current transaction in screen format
     D                                     PREFIX(@)
 
     D NewTranScn    E DS                  EXTNAME(FFEXTRPD)
      * New transaction in screen format
 
      * Transaction Details - OK Flags
      * ~~~~~~~~~~~ ~~~~~~~   ~~~~~~~~
 
     D OKTransDet    E DS                  EXTNAME(FFEEXTRPD)
      ** External data structure for transaction details OK flags
 
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
 
     D BefCuStScn    E DS                  EXTNAME(FFCSETPD) PREFIX(B_)                      BUG6495
      ** Before Customer Settlement details in screen format                                 BUG6495
                                                                                             BUG6495
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD) PREFIX(@)
      ** Current Customer Settlement Details in Screen Format
 
 
      * Broker Settlement Details - Screen Format
      * ~~~~~~ ~~~~~~~~~~ ~~~~~~~   ~~~~~~ ~~~~~~
 
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** New broker settlement details in screen format
 
     D BefBrStScn    E DS                  EXTNAME(FFBSETPD) PREFIX(B_)                      BUG6495
      ** Before broker settlement details in screen format                                   BUG6495
                                                                                             BUG6495
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
 
     D InstType      E DS                  EXTNAME(INTYPD)  PREFIX(IT)
      ** Instrument types
 
     D ExtData       E DS                  EXTNAME(FFETEXPD)
      * FF Extension data (Exchange Traded) - File (D/B) format
 
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
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFF007
     D  SLCD         E                     EXTFLD(LCD)                                        CFF007
      ** Switchable Features Details                                                          CFF007
                                                                                              CFF007
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)                      CPM003
     D  #ACCD1       E                     EXTFLD(QQACCD)                                     CGL029
     ** Trading details
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    CPM003
      ** Portfolio Management ICD
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  #ACCD2       E                     EXTFLD(QQACCD)                                     CGL029
     ** Retail ICD
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  #ACCD3       E                     EXTFLD(QQACCD)                                     CGL029
      ** Dealing ICD
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  #ACCD4       E                     EXTFLD(QQACCD)                                     CGL029
      ** Futures and Options ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
 
     D WTmpFldNamArr   S             10A   DIM(ArrayMax)                                      198102
      ** Temporary Field arrays                                                               198102
                                                                                              198102
     D WTmpMsgIDArr    S                   DIM(ArrayMax) LIKE(#MsgID)                         198102
      ** Temporary message ID arrays                                                          198102
                                                                                              198102
     D WTmpMsgDtaArr   S                   DIM(ArrayMax) LIKE(#MsgData)                       198102
      ** Temporary message Data arrays                                                        198102
                                                                                              198102
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** The current trading date
     D CTDATE          S                   LIKE(BJRDNB)
 
      ** Enhanced OTCs feature flag (not used, but passed as a blank PARM)
     D CFF001          S              1A
 
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - broker                                                       CFF007
     D PPBBFLG         S              1A                                                      CFF007
                                                                                              CFF007
      ** PB customer indicator - customer                                                     CFF007
     D PPBCFLG         S              1A                                                      CFF007
                                                                                              CFF007
      ** Switchable feature                                                                   CFF007
     D PSARD           S              6A                                                      CFF007
                                                                                              CFF007
      ** --- Parameters for ZATRNRTV ---------------------------------------------------------------
      ** Module ID
     D Module          S              2A   INZ('FF')
 
      ** Transaction type (dummy field as it is not needed for FF)
     D DummyTRTY       S              1A
      ** --- End of parameters for ZATRNRTV --------------------------------------------------------
 
      ** Customer/Broker Flag (B = Broker, C = Customer)
     D CustBrokFl      S              1A
 
      ** Customer or broker number
     D*CustBrokNo***** S              6S 0                                                    CSD027
     D CustBrokNo      S              6                                                       CSD027
 
     D*WNPrevNum       S              6A                                              205649 BUG2982
      **********                                                                      205649 BUG2982
     D MNSCRN          S              1A                                                     BUG2982
                                                                                             BUG2982
      ** Flags to indicate that the broker and/or customer settlements
      ** are in error.
     D BrokSetErr      S              1A   INZ('N')
     D CustSetErr      S              1A   INZ('N')
 
      ** Flags to indicate that the broker and/or customer charges and
      ** commission fields are in error.
     D BrokCCErr       S              1A   INZ('N')
     D CustCCErr       S              1A   INZ('N')
 
      ** Flag to indicate that the FFEXTRRTV is not being called
      ** as a linked enquiry.
     D LinkEnq         S              1A   INZ('N')
 
      ** Customer/Broker Flag (Y = Broker, N = Customer)
     D BrokerFlag      S              1A
 
      ** Flag to indicate that the transaction number was automatically
      ** generated
     D AutoTran        S              1A   INZ('N')
 
      ** General index variables                                                              198102
     D WIx             S              3P 0                                                    198102
     D WIy             S              3P 0                                                    198102
                                                                                              198102
      ** Variables to save previous values of fields                                          198102
     D WPrvSCOPR       S                   LIKE(SCOPR)                                        198102
     D WPrvSPTFR       S                   LIKE(SPTFR)                                        198102
 
      ***Flag*to*indicate*if*F12*has*been*pressed*from*confirmation*screen*********   205649 BUG2982
     D*WNCanc***       S              1A                                              205649 BUG2982
     D CGL014          S              1                                                       CGL014
     D PRTCD           S              7                                                       CGL014
     D POPTN           S              7                                                       CGL014
                                                                                              CGL014
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** Valid extended Futures and Options Details                                           CER001
      *                                                                                       CER001
     D NwDlFilFmt    E DS                  EXTNAME(FFVTNLX1PD)                                CER001
      *                                                                                       CER001
      ** Extended Futures and Options File                                                    CER001
      *                                                                                       CER001
     D CrDlFilFmt    E DS                  EXTNAME(FFTRX2L0)                                  CER001
                                                                                              205649
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFEXTRS001
     D SETMESTMP       S             26Z                                                      CER001
     D SEFOTRANID      S             20                                                       CER001
                                                                                              CER001
     D SOTMESTMP       S             26Z                                                      CER001
     D SOFOTRANID      S             20                                                       CER001
     D SISPT           S              1                                                       CER001
     D SISTT           S              5                                                       CER001
                                                                                              CER001
     D WFIND           S              1                                                       CER001
     D #RTRN           S              7                                                       CER001
     D w_TransNo       S              6  0                                                    CER001
     D ULX604          S              1                                                       CER001
                                                                                              CER001
     D c_Lux           C                   Const('L')                                         CER001
     D c_Delete        C                   Const('D')                                         CER001
     D c_Enquire       C                   Const('E')                                         CER001
     D c_Insert        C                   Const('I')                                         CER001
     D c_Amend         C                   Const('A')                                         CER001
     D c_F3            C                   Const('Y2U9999')                                   CER001
     D c_F12           C                   Const('USR0790')                                   CER001
 
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
 
      /COPY WNCPYSRC,FFEXTRS002
 
      * Read next browse subfile record
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRS003
 
      * Do while screen: main details
     C     @SCRN         DOWEQ     'M'
     C                   EXSR      SCRN@M
     C                   ENDDO
 
      /COPY WNCPYSRC,FFEXTRS004
 
      * Settlement details processing
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   ENDDO
      *                                                                                       CER001
      ** Process Lux Screen                                                                   CER001
      *                                                                                       CER001
     C                   IF        @SCRN = c_Lux                                              CER001
     C                   EXSR      Sr_LuxScreen                                               CER001
     C                   ENDIF                                                                CER001
 
      /COPY WNCPYSRC,FFEXTRS005
 
      * Screen: window
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRS006
 
      * Screen: confirmation of input
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRS007
 
      * Do file updates
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
 
      /COPY WNCPYSRC,FFEXTRS008
 
      * Terminate program
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   ENDIF
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFEXTRS009
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@M - PROCESS SCREEN: MAIN DETAILS
      *****************************************************************
 
     C     SCRN@M        BEGSR
 
      * Issue rollback to clear any possible updates in window function
      * Only required if transaction number, market or action has changed
      * (this check will also cater for F12 taken from main screen)
     C     BGWDPR        IFEQ      'Y'
     C     STNBR         IFNE      @PTNBR
     C     SACTN         ORNE      @PACTN                                                     165402
     C     SMRKT         ORNE      @PMRKT
     C     @CCI@M        ORNE      @PCI@M
     C                   ROLBK
     C                   ENDIF
     C                   ENDIF
 
      * Reset the transaction-number-automatically-generated flag
     C                   RESET                   AutoTran
 
      * Update 'previous' transaction number, market
      * & screen control indicator
     C                   MOVEL     STNBR         @PTNBR            6
     C                   MOVEL     SACTN         @PACTN            1                          165402
     C                   MOVEL     SMRKT         @PMRKT            2
     C                   MOVEL     @CCI@M        @PCI@M
 
      * Write/read display screen
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRDSP'
     C                   PARM                    ReturnCode
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
      * TRANSACTION STATUS
     C                   PARM                    FFSTS            24
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      * FIELDS IN ERROR
     C                   PARM                    OKBrokSet
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
 
      * OUTPUT PARAMETERS
      * -----------------
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
 
      * RESET ERRORS
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      * CK/3 - END PROGRAM
     C     @INKC         CASEQ     '1'           ENDP
 
      * F7 - ROLL BACKWARDS
     C     @INKG         CASEQ     '1'           ROLL
 
      * F8 - ROLL FORWARDS
     C     @INKH         CASEQ     '1'           ROLL
 
      * CK/12 - CANCEL ON MAIN DETAILS SCREEN
     C     @INKL         CASEQ     '1'           CANC@M
 
      * CK/15 - BUILD BROWSE
     C     @INKP         CASEQ     '1'           BLDBRW
 
      * VALIDATE INPUT TO MAIN DETAILS SCREEN
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
     C     OKMRKT        OREQ      'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      * Set field and function key status on main details screen
      * (according to action code)
     C                   EXSR      SFDS@M
     C                   EXSR      SFKS@M
 
      * If action code is delete, or enquire;
      * or action code is amend and transaction number
      * number or market centre has changed
      *   Put the transaction on the main details screen
     C     SACTN         IFEQ      'D'
     C     SACTN         OREQ      'E'
     C     SACTN         OREQ      'A'
     C/COPY WNCPYSRC,FFEXTRSC01
     C     STNBR         ANDNE     @PTNBR
     C     SACTN         OREQ      'A'
     C     SMRKT         ANDNE     @PMRKT
     C     SACTN         OREQ      'A'                                                        165402
     C     SACTN         ANDNE     @PACTN                                                     165402
     C                   EXSR      PUTD@M
     C                   ENDIF
 
      * If transaction number or market centre
      * or screen control indicators have changed
      *   Re-output screen
     C     STNBR         IFNE      @PTNBR
     C     SACTN         ANDNE     'I'
     C     SMRKT         ORNE      @PMRKT
     C     SACTN         ANDNE     'I'                                                       BUG2982
     C     SACTN         ORNE      @PACTN                                                     165402
     C     SACTN         ANDNE     'I'
     C     @CCI@M        ORNE      @PCI@M
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      *----------------------------------------------------------------
 
      * IF DELETE
     C     SACTN         IFEQ      'D'
      *                                                                                       CER001
      ** If Transaction APIs - FF Exch. Trades Input is installed,                            CER001
      ** process Lux Screen.                                                                  CER001
      *                                                                                       CER001
     C                   IF        ULX604 = 'Y'                                               CER001
     C                   EVAL      @SCRN = c_Lux                                              CER001
     C                   LEAVESR                                                              CER001
     C                   ELSE                                                                 CER001
 
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
     C                   ENDIF                                                                CER001
     C                   ENDIF
 
      *----------------------------------------------------------------
      * IF ENQUIRE
     C     SACTN         IFEQ      'E'
      *                                                                                       CER001
      ** If Transaction APIs - FF Exch. Trades Input is installed,                            CER001
      ** process Lux Screen.                                                                  CER001
      *                                                                                       CER001
     C                   IF        ULX604 = 'Y'                                               CER001
     C                   EVAL      @SCRN = c_Lux                                              CER001
     C                   LEAVESR                                                              CER001
     C                   ELSE                                                                 CER001
      *
      * Update transaction in File Format
     C                   MOVEL     CurTranFil    NewTranFil
 
      * Update transaction settlement details in File Format
     C                   MOVEL     CurTrstFil    NewTrstFil
 
      * If windows processing on, call window routine
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ENDIF
     C                   ENDIF
 
     C                   GOTO      EVAL@M
     C                   ENDIF                                                                CER001
     C                   ENDIF
 
     C/COPY WNCPYSRC,FFEXTRSC02
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
     C     SACTN         IFEQ      'I'
     C     SACTN         OREQ      'A'
 
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Transaction in File Format
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   CLEAR                   NewTranFil
     C                   CLEAR                   NewTrstFil
 
      * IF AMEND
     C     SACTN         IFEQ      'A'
 
      * Update transaction in File Format
     C                   MOVEL     CurTranFil    NewTranFil
 
      * Update transaction settlement details in File Format
     C                   MOVEL     CurTrstFil    NewTrstFil
 
      * Validate whether non-amendable fields have been changed
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRAMD'
      * Outputs
      * ~~~~~~~
      * Return Code
     C                   PARM                    ReturnCode
      * Transaction Details OK flags(DS) from/to caller
     C                   PARM                    OKTransDet
      * Broker Settlement OK flags(DS) from/to caller
     C                   PARM                    OKBrokSet
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
 
      * Inputs
      * ------
      * New transaction in Screen Format
     C                   PARM                    NewTranScn
      * New Broker Settlement details in Screen Format
     C                   PARM                    NewBrStScn
      * New Customer Settlement deatils in screen format
     C                   PARM                    NewCuStScn
      * Current transaction in Screen Format
     C                   PARM                    CurTranScn
      * Current Broker Settlement Details in Screen Format
     C                   PARM                    CurBrStScn
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
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
     C                   ENDIF
 
      * If errors returned by the amend function, do not do validation
      * processing.
     C                   IF        Idx = 0
 
      * Validate Transaction details
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRVAL'
      * Outputs
      * ~~~~~~~
     C                   PARM                    ReturnCode
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
      ** PB customer indicator - broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
 
      * Inputs
      * ~~~~~~
     C                   PARM                    RespMode
     C                   PARM                    NewTranScn
      ** Extension file data
     C                   PARM                    ExtData
      ** ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
     C                   PARM                    SDFODA
     C                   PARM                    SDDEAL
     C                   PARM                    SDPORT                                        CPM00
      ** CFF007 enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
     C                   PARM                    S01457                                       208635
 
     C                   ENDIF
      *                  (End of "If no errors returned by amend")
 
      ** If no errors but at least one warning message exists, then                           198102
      ** repeat processing.                                                                   198102
                                                                                              198102
     C     Idx           IFEQ      0                                                          198102
                                                                                              198102
     C                   MOVEL     *BLANKS       WTmpFldNamArr                                198102
     C                   MOVEL     *BLANKS       WTmpMsgIDArr                                 198102
     C                   MOVEL     *BLANKS       WTmpMsgDtaArr                                198102
     C                   Z-ADD     1             WIx                                          198102
     C                   Z-ADD     0             WIy                                          198102
                                                                                              198102
     C     WMsgIDArr(WIx)DOWNE     *BLANKS                                                    198102
                                                                                              198102
     C                   SELECT                                                               198102
                                                                                              198102
      ** Contract Price                                                                       198102
     C     WMsgIDArr(WIx)WHENEQ    'MMA0340'                                                  198102
     C     WMsgIDArr(WIx)OREQ      'MMA0341'                                                  198102
     C     SCOPR         IFNE      WPrvSCOPR                                                  198102
     C                   ADD       1             WIy                                          198102
     C                   EVAL      WTmpFldNamArr(WIy) = WFldNamArr(WIx)                       198102
     C                   EVAL      WTmpMsgIDArr(WIy) = WMsgIDArr(WIx)                         198102
     C                   EVAL      WTmpMsgDtaArr(WIy) = WMsgDtaArr(WIx)                       198102
     C                   MOVEL     SCOPR         WPrvSCOPR                                    198102
     C                   ENDIF                                                                198102
                                                                                              198102
      ** Portfolio Reference                                                                  198102
     C     WMsgIDArr(WIx)WHENEQ    'MMA0335'                                                  198102
     C     SPTFR         IFNE      WPrvSPTFR                                                  198102
     C                   ADD       1             WIy                                          198102
     C                   EVAL      WTmpFldNamArr(WIy) = WFldNamArr(WIx)                       198102
     C                   EVAL      WTmpMsgIDArr(WIy) = WMsgIDArr(WIx)                         198102
     C                   EVAL      WTmpMsgDtaArr(WIy) = WMsgDtaArr(WIx)                       198102
     C                   MOVEL     SPTFR         WPrvSPTFR                                    198102
     C                   ENDIF                                                                198102
                                                                                              198102
      ** By default, move warning message to WTmpMsgIDArr                                     198102
     C                   OTHER                                                                198102
     C                   ADD       1             WIy                                          198102
     C                   EVAL      WTmpFldNamArr(WIy) = WFldNamArr(WIx)                       198102
     C                   EVAL      WTmpMsgIDArr(WIy) = WMsgIDArr(WIx)                         198102
     C                   EVAL      WTmpMsgDtaArr(WIy) = WMsgDtaArr(WIx)                       198102
                                                                                              198102
     C                   ENDSL                                                                198102
                                                                                              198102
     C                   ADD       1             WIx                                          198102
                                                                                              198102
     C                   ENDDO                                                                198102
                                                                                              198102
     C                   MOVEL     *BLANKS       WFldNamArr                                   198102
     C                   MOVEL     *BLANKS       WMsgIDArr                                    198102
     C                   MOVEL     *BLANKS       WMsgDtaArr                                   198102
     C                   MOVEA     WTmpFldNamArr WFldNamArr                                   198102
     C                   MOVEA     WTmpMsgIDArr  WMsgIDArr                                    198102
     C                   MOVEA     WTmpMsgDtaArr WMsgDtaArr                                   198102
     C                   Z-ADD     WIy           WIdx                                         198102
                                                                                              198102
     C     WIdx          IFGT      0                                                          198102
     C                   GOTO      EVAL@M                                                     198102
     C                   ENDIF                                                                198102
                                                                                              198102
     C                   ENDIF                                                                198102
                                                                                              198102
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      * Continue to settlements screen
     C                   MOVEL     'S'           @SCRN
 
     C                   ENDIF
 
      *----------------------------------------------------------------
 
     C     EVAL@M        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AppendArrs - Append one field's error and warning details to  *
      *              the general error and warning arrays.            *
      *                                                               *
      *****************************************************************
 
     C     AppendArrs    BEGSR
 
     C                   RESET                   ReturnCode
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
 
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * Sr_LuxScreen - Display LUX Screen Regional Details            *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
                                                                                              CER001
     C     Sr_LuxScreen  BEGSR                                                                CER001
      *                                                                                       CER001
     C                   MOVEL     STNBR         #1TNBR                                       CER001
     C                   MOVE      STNBR         w_TransNo                                    CER001
     C                   MOVEL     ISTT          #1ISTT                                       CER001
     C                   MOVEL     SMRKT         #1MRKT                                       CER001
     C                   MOVE      SEFOTRANID    #1FOTR                                       CER001
     C                   MOVE      SETMESTMP     #1TMST                                       CER001
     C                   CLEAR                   CrDlFilFmt                                   CER001
     C                   CLEAR                   NwDlFilFmt                                   CER001
      *                                                                                       CER001
      ** Retrieve current record detail if action is E, D and A                               CER001
      *                                                                                       CER001
     C                   IF        SACTN = c_Enquire or                                       CER001
     C                             SACTN = c_Delete  or                                       CER001
     C                             SACTN = c_Amend                                            CER001
     C                   OPEN      FFTRX2L0                                                 BUG10289
     C     w_TransNo     CHAIN     RTVIDX                                                     CER001
     C                   CLOSE     FFTRX2L0                                                 BUG10289
     C                   IF        Not %Found(FFTRX2L0)                                       CER001
     C                   EVAL      DBFILE = 'FFTRX2L0'                                        CER001
     C                   EVAL      DBASE  = 5                                                 CER001
     C                   EVAL      DBKEY  = STNBR                                             CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Call LUX Regional Detail Screen                                                      CER001
      *                                                                                       CER001
     C                   CALL      'FFEXTR2SN'                                                CER001
     C                   PARM                    SACTN                                        CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    #RTRN                                        CER001
     C                   PARM                    CrDlFilFmt                                   CER001
     C                   PARM                    NwDlFilFmt                                   CER001
      *                                                                                       CER001
      ** Process returned command keys                                                        CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
      *  F3 is pressed, leave program                                                         CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN = c_F3                                               CER001
     C                   EXSR      ENDP                                                       CER001
      *                                                                                       CER001
      *  F12 is pressed, return to main details screen                                        CER001
      *  otherwise, go to confirmation screen                                                 CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN = c_F12                                              CER001
     C                   IF        @RDNB = 'Y'                                                CER001
     C                   EVAL      @SCRN = 'R'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN = 'M'                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   OTHER                                                                CER001
      *                                                                                       CER001
      ** If program returns from LUX screen w/o pressing F3 & F12 and                         CER001
      ** action code is "D"elete;                                                             CER001
      *                                                                                       CER001
     C                   IF        SACTN = c_Delete                                           CER001
      *                                                                                       CER001
      ** Update transaction in File Format                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     CurTranFil    NewTranFil                                   CER001
      *                                                                                       CER001
      ** Update transaction settlement details in File Format                                 CER001
      *                                                                                       CER001
     C                   MOVEL     CurTrstFil    NewTrstFil                                   CER001
                                                                                              CER001
      * If CK/10 taken, go onto updates                                                       CER001
     C                   IF        @INKJ = '1'                                                CER001
     C                   IF        BGWDPR = 'Y'                                               CER001
     C                   EVAL      @SCRN = 'W'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN = 'U'                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If program returns from LUX screen w/o pressing F3 & F12 and                         CER001
      ** action code is "E"nquire;                                                            CER001
      *                                                                                       CER001
     C                   IF        SACTN = c_Enquire                                          CER001
      *                                                                                       CER001
      ** Update transaction in File Format                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     CurTranFil    NewTranFil                                   CER001
      *                                                                                       CER001
      ** Update transaction settlement details in File Format                                 CER001
      *                                                                                       CER001
     C                   MOVEL     CurTrstFil    NewTrstFil                                   CER001
      *                                                                                       CER001
      ** If windows processing on, call window routine                                        CER001
      ** If browse outstanding, read next browse subfile record                               CER001
      *                                                                                       CER001
     C                   IF        BGWDPR = 'Y'                                               CER001
     C                   EVAL      @SCRN = 'W'                                                CER001
     C                   ELSE                                                                 CER001
     C                   IF        @RDNB = 'Y'                                                CER001
     C                   EVAL      @SCRN = 'R'                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If program returns from LUX screen w/o pressing F3 & F12 and                         CER001
      ** action code is "I"nsert or "A"mend;                                                  CER001
      *                                                                                       CER001
     C                   IF        SACTN = c_Insert or                                        CER001
     C                             SACTN = c_Amend                                            CER001
     C                   IF        BGWDPR = 'Y'                                               CER001
     C                   EVAL      @SCRN = 'W'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN = 'C'                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
 
     C     WINDOW        BEGSR
 
      * Reset erros
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
     C                   CALLB     'FFEXTRDSP'
     C                   PARM                    ReturnCode
      *
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
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
     C                   PARM                    OKBrokSet
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
 
     C                   CALL      'WN0010'
     C                   PARM      'FFEXTRSIN'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      SACTN         ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
 
      * Process returned command keys
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
 
      *  If Cmd12 pressed, or in enquiry, return to main details screen;
      *  otherwise, go to confirmation screen
     C     #RTRN         IFEQ      'USR0790'
     C     SACTN         OREQ      'E'
     C     @RDNB         IFEQ      'Y'
 
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
 
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
     C/COPY WNCPYSRC,FFEXTRSC03
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
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRRED'
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
      * Market centre of transaction read
     C                   PARM                    SMRKT
     C/COPY WNCPYSRC,FFEXTRSC04
 
 
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
 
      * Build browse subfile
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTRANBRW'
      * Return code
     C                   PARM                    ReturnCode
      * Inputs
      * ------
      * Transaction number pointer
     C                   PARM                    STNBR             6
      * Build subfile
     C                   PARM      'Y'           @BDSFL            1
      * Read subfile record
     C                   PARM      *BLANK        @RDSFL            1
     C                   PARM                    SDBANK
      * Transaction type
     C                   PARM                    TransType
      * Outputs
      * -------
      * Error message
     C                   PARM      *BLANKS       @ERRMS            7
      * Option selected
     C                   PARM      *BLANK        @OPSEL            1
      * Transaction number selected
     C                   PARM      *BLANK        @TRSEL            6
      * Member selected
     C                   PARM      *BLANK        @MBSEL            2
      * Function keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C/COPY WNCPYSRC,FFEXTRSC05
 
      * If F3 taken in browse, end program.
     C     @INKC         IFEQ      '1'
     C                   ROLBK
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   ENDIF
 
      * If error message returned from browse, send it to detail screen
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   ENDIF
 
      * If F12 not taken in browse
      * Read next browse subfile record
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EBLDBR
     C                   ENDIF
 
     C     EBLDBR        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
     C                   RESET                   ReturnCode
     C                   CALLB     'FFTRANBRW'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    ReturnCode
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
     C/COPY WNCPYSRC,FFEXTRSC06
      *
      * IF TRANSACTION READ FROM SUBFILE
      *
     C     @TRSEL        IFNE      *BLANK
      *
      * Retrieve transaction details
      *
     C                   MOVEL     @OPSEL        SACTN
     C                   MOVEL     @TRSEL        STNBR
     C                   MOVEL     @MBSEL        SMRKT
     C**********         EXSR      RTVTRN                                                     173665
     C                   EXSR      VAL@M                                                      173665
      *
      * Set field and function key status on main details screen
      * (according to action code)
      *
     C**********         EXSR      SFDS@M                                                     173665
     C**********         EXSR      SFKS@M                                                     173665
      *
      * Put the transaction on the main details screen
      *
     C**********         EXSR      PUTD@M                                                     173665
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
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRRTV'
      * Return code
     C                   PARM                    ReturnCode
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
      * (Midas) Market (1A)
     C                   PARM                    SMRKT
      ** Module being called as linked enquiry (1A)
     C                   PARM                    LinkEnq
      * Bank details ICD
     C                   PARM                    SDBANK
      * General Ledger ICD
     C                   PARM                    SDGELR
      * Multibranching indicator
     C                   PARM                    BGMBIN
      * Outputs
      * ~~~~~~~
      ** Current transaction in file format
     C                   PARM                    CurTranFil
      ** Current settlements in file format
     C                   PARM                    CurTrstFil
      ** Instrument types
     C                   PARM                    InstType
      * OK - Action code (1A)
     C                   PARM      *BLANK        OKACTN
      * OK - Transaction Number (1A)
     C                   PARM      *BLANK        OKTNBR
      * OK - Market (1A)
     C                   PARM                    OKMRKT            1
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
 
      * Call program to fill screen fields with data from TRANSD
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRCVT'
      * Inputs
      * ~~~~~~
     C                   PARM                    ReturnCode
      * Transaction in file format
     C                   PARM                    CurTranFil
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      * Outputs
      * ~~~~~~~
      * Transaction in screen format
     C                   PARM                    NewTranScn
      * Transaction Status
     C                   PARM                    FFSTS            24
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
     C                   EVAL      CustBrokFl = 'B'
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
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
 
 
     C                   EVAL      CustBrokFl = 'C'
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
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
     C                   MOVEL     NewBrStScn    CurBrStScn
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
 
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
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
     C                   MOVEL     *BLANK        NewBrStScn
     C                   MOVEL     *BLANK        FFSTS
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
 
     C                   MOVEL     ' '           MNSCRN                                      BUG2982
                                                                                             BUG2982
      **If*F12*has*been*pressed*and*there*has*been*a*change*in*Broker/*************   205649 BUG2982
      **Customer*number,*then*Settlement*details*must*be*reset*to******************   205649 BUG2982
      **blank*to*default*correctly.*Otherwise,*use*as*what*is*entered**************   205649 BUG2982
      **by*user.*******************************************************************   205649 BUG2982
      **********                                                                      205649 BUG2982
     C*****WNCanc        IFEQ      'Y'                                                205649 BUG2982
     C*****SBOCO         IFNE      WNPrevNum                                          205649 BUG2982
     C*****SBOCO         ANDNE     *BLANKS                                            205649 BUG2982
     C**********         CLEAR                   NewBrStScn                           205649 BUG2982
     C**********         ENDIF                                                        205649 BUG2982
     C*****SCUSC         IFNE      WNPrevNum                                          205649 BUG2982
     C*****SCUSC         ANDNE     *BLANKS                                            205649 BUG2982
     C**********         CLEAR                   NewCuStScn                           205649 BUG2982
     C**********         ENDIF                                                        205649 BUG2982
     C**********         ENDIF                                                        205649 BUG2982
      **********                                                                      205649 BUG2982
      * Clear broker settlement details screen if broker not defined
 
     C                   IF        SBOCO = *blanks
     C                             OR %subst(SBOCO : 1 : 1) = '*'
     C                   CLEAR                   NewBrStScn
     C                   ENDIF
 
      * Clear customer settlement details screen if customer not defined
 
     C                   IF        SCUSC = *blanks
     C                   CLEAR                   NewCuStScn
     C                   ENDIF
 
      * Save the existing screen before defaulting being done                                BUG6495
                                                                                             BUG6495
     C                   EVAL      BefCuStScn = NewCuStScn                                   BUG6495
     C                   EVAL      BefBrStScn = NewBrStScn                                   BUG6495
                                                                                             BUG6495
      * This routine is called if none of the settlement fields have been
      * entered.
     C**********         IF            (NewCuStScn = *blank)                                  205649
     C**********                   AND (NewBrStScn = *blank)                                  205649
     C                   IF            (NewCuStScn = *blank)                                 BUG2982
     C                             OR  (NewBrStScn = *blank)                                 BUG2982
 
      * First default broker instructions if broker has been entered,
      * and has not been entered as '*'.
     C                   IF        SBOCO <> *blanks
     C                             AND %subst(SBOCO : 1 : 1) <> '*'
     C                             AND (NewBrStScn = *blank)                                  205649
 
     C                   EVAL      CustBrokFl = 'B'
     C**********         MOVE      *zero         CustBrokNo                                   CSD027
     C                   EVAL      CustBrokNo = *BLANKS                                       CSD027
     C                   MOVEL     SBOCO         CustBrokNo
     C**********         MOVEL     SBOCO         WNPrevNum                            205649 BUG2982
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLDFT'
      *                      Return code
      *  Outputs
      *  ~~~~~~~
     C                   PARM                    ReturnCode
      **                     Broker settlement instructions
     C                   PARM                    NewBrStScn
      **                     Customer settlement instructions
     C                   PARM                    NewCuStScn
      *                      Return code
      *  Inputs
      *  ~~~~~~
      ** Customer/broker flag
     C                   PARM                    CustBrokFl
      ** Customer or broker number
     C                   PARM                    CustBrokNo
      ** Market centre
     C                   PARM                    SMRKT
      ** Instrument code
     C                   PARM                    SISTC
      ** Transaction type (purchase or sale)
     C                   PARM                    STRTY
      ** Enhanced OTCs feature flag
     C                   PARM                    CFF001
 
     C                   ENDIF
      *                  (End of "If broker and not '*'")
 
 
      ** Next default customer instructions, but
      ** only if the customer was entered.
     C                   IF        SCUSC <> *blanks
     C                             AND (NewCuStScn = *blank)                                  205649
 
     C                   EVAL      CustBrokFl = 'C'
     C**********         MOVE      *ZERO         CustBrokNo                                   CSD027
     C                   EVAL      CustBrokNo = *BLANKS                                       CSD027
     C                   MOVEL     SCUSC         CustBrokNo
     C**********         MOVEL     SCUSC         WNPrevNum                            205649 BUG2982
 
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
     C                   PARM                    SMRKT
      *  Instrument code
     C                   PARM                    SISTC
      ** Transaction type (purchase or sale) (1A)
     C                   PARM                    STRTY
      *  Enhanced OTCs feature flag
     C                   PARM                    CFF001
 
     C                   ENDIF
      *                  (End of "If Customer")
 
      * Redisplay screen in any case if settlement instructions have been defaulted          BUG2982
      * (Only if any changes done)                                                           BUG6495
                                                                                             BUG2982
     C************       IF            (NewCuStScn <> *blank)                        BUG2982 BUG6495
     C************                 OR  (NewBrStScn <> *blank)                        BUG2982 BUG6495
     C                   IF            (NewCuStScn <> BefCuStScn)                            BUG6495
     C                             OR  (NewBrStScn <> BefBrStScn)                            BUG6495
     C                   MOVEL     'Y'           MNSCRN                                      BUG2982
     C                   ENDIF                                                               BUG2982
                                                                                             BUG2982
     C**********         ENDIF                                                                205649
     C                   ENDIF                                                               BUG2982
      *                  (End of "If no settlement instructions entered")
 
      * Validate the broker and customer charge and commission details
 
     C                   EXSR      ValChgCom
 
      ** Validate broker and customer settlement instructions
 
     C                   RESET                   BrokSetErr
     C                   RESET                   CustSetErr
 
      ** 1. Broker (if broker defined)
      ** ---------
     C                   IF        SBOCO <> *blanks
     C                             AND %subst(SBOCO : 1 : 1) <> '*'
 
     C                   EVAL      CustBrokFl = 'B'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLVAL'
      ** Outputs
      ** ~~~~~~~
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
      ** PB customer indicator - broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
      ** Collaterals Processing enhancement                                                   CGL014
     C                   PARM                    CGL014                                       CGL014
 
      ** Record any failure or warning
     C                   IF        ReturnCode <> *blanks
 
     C                   IF        ReturnCode = 'Error'
     C                   EVAL      BrokSetErr = 'Y'
     C                   ENDIF
 
     C                   IF        ReturnCode = 'ErrAndWarn'
     C                   EVAL      BrokSetErr = 'Y'
     C                   ENDIF
 
     C                   IF        ReturnCode = 'Warning'
     C                   EVAL      BrokSetErr = 'W'
     C                   ENDIF
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
     C                   ENDIF
 
      ** 2. Customer (if customer defined)
      ** -----------
     C                   IF        SCUSC <> *blanks
 
     C                   EVAL      CustBrokFl = 'C'
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLVAL'
      ** Outputs
      ** -------
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
      ** PB customer indicator - broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
      ** Collateral Processing enhancement                                                    CGL014
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
     C                   ENDIF
      *
      * If settlement or charges and commission details invalid, return to
      * main details screen.
     C                   IF           BrokSetErr = 'Y' OR CustSetErr = 'Y'
     C                             OR BrokCCErr = 'Y' OR CustCCErr = 'Y'
     C                             OR MNSCRN = 'Y'                                           BUG2982
 
     C                   MOVEL     'M'           @SCRN
 
     C                   ELSE
      *                                                                                       CER001
      ** If Transaction APIs - FF Exch. Trades Input is installed,                            CER001
      ** process Lux Screen.                                                                  CER001
      *                                                                                       CER001
     C                   IF        ULX604 = 'Y'                                               CER001
     C                   EVAL      @SCRN = c_Lux                                              CER001
     C                   ELSE                                                                 CER001
 
      * Otherwise, if windows on, show windows screen
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
 
      * Otherwise continue to the confirmation screen
     C                   MOVEL     'C'           @SCRN
 
     C                   ENDIF
     C                   ENDIF                                                                CER001
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, AMENDS & AUTHORIZATIONS
      *****************************************************************
 
     C     SCRN@C        BEGSR
 
     C**********         MOVEL     'N'           WNCanc                               205649 BUG2982
      **********                                                                      205649 BUG2982
      * If transaction is valid output message 'Press enter to accept'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'APM0121'     MsgIdArr(1)
 
      * Write/read display screen
     C                   RESET                   ReturnCode
     C                   CALLB     'FFEXTRDSP'
     C                   PARM                    ReturnCode
 
      * TRANSACTION (IN SCREEN FORMAT)
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
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
     C                   PARM                    OKBrokSet
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
 
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
      * RESET ERRORS
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      * CK/3 - END PROGRAM
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
 
      * EXIT CONFIRMATION SCREEN
     C                   CAS                     EXIT@C
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
 
     C     CANC@C        BEGSR
 
      ***Set*F12*flag*on***********************************************************   205649 BUG2982
     C**********         MOVE      'Y'           WNCanc                               205649 BUG2982
      **********                                                                      205649 BUG2982
      * RETURN TO MAIN DETAILS SCREEN
     C                   MOVEL     'M'           @SCRN
 
      * If F12 was pressed on the confirm screen, and the transaction number
      * was automatically generated, blank it out and do a rollback to
      * release the generated transaction number.
     C                   IF        AutoTran = 'Y'
     C                   CLEAR                   STNBR
     C                   ROLBK
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
      ** Check if action code is insert                                                       204224
      *                                                                                       204224
     C     SACTN         IFEQ      'I'                                                        204224
      *                                                                                       204224
      ** Succesfully Inserted Deal Number                                       166907
      *                                                                         166907
     C                   EVAL      @SIDN = STNBR                                166907
      *                                                                                       CER001
     C                   IF        ULX604 = 'Y'                                               CER001
     C                   MOVE      STNBR         #6LXFFTNBR                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       204224
     C                   ENDIF                                                                204224
 
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
     C                   PARM      'N'           NewOTCInst        1
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
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator - broker                                                       CFF007
     C                   PARM                    PPBBFLG                                      CFF007
      ** PB customer indicator - customer                                                     CFF007
     C                   PARM                    PPBCFLG                                      CFF007
 
     C                   ENDIF
      **                 (End of "If return code <> 'Error'")
      *                                                                                       CER001
     C                   IF        ReturnCode <> 'Error' and                                  CER001
     C                             ReturnCode <> '*RECUPD' and                                CER001
     C                             ULX604 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   CALLB     'FFTRAN2UP'                                                CER001
     C                   PARM                    SACTN                                        CER001
     C                   PARM      *BLANK        ReturnCode                                   CER001
     C                   PARM      'Y'           WFIND                                        CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   PARM                    CrDlFilFmt                                   CER001
     C                   ENDIF                                                                CER001
 
      * If there were any errors in the update functions, rollbacm any
      * updates and end this module. Otherwise commit the updates.
     C                   IF        ReturnCode <> '*RECUPD'                      CAP006
     C                   IF        ReturnCode <> *blanks
 
     C                   ROLBK
     C                   EXSR      *pssr
 
     C                   ELSE
 
     C                   COMMIT
     C/COPY WNCPYSRC,FFEXTRSC07
 
     C                   ENDIF                                                  CAP006
      *
     C**********         ENDIF                                                  CAP006
     C                   ELSE                                                   CAP006
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
 
      * BLANK THE MAIN DETAILS SCREEN
      *
     C                   MOVEL     *BLANK        NewTranScn
     C                   MOVEL     *BLANK        NewCuStScn
     C                   MOVEL     *BLANK        NewBrStScn
     C                   MOVEL     *BLANK        FFSTS
 
      * Initialize field and function key status on main details screen
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
 
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
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
     C                   ROLBK
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
 
      ** FFVCHGCOM is called twice, once for broker charges and commissions
      ** and once for customer charges and commissions.
 
     C                   RESET                   BrokCCErr
     C                   RESET                   CustCCErr
 
      ** 1. Broker
      ** ---------
     C                   EVAL      BrokerFlag = 'Y'
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
     C                   PARM                    NewBrStScn
      ** Customer/ Broker flag (1A, Y = Broker, N = Customer)
     C                   PARM                    BrokerFlag
      ** Instrument currency (3A)
     C                   PARM                    VISCY
      ** Broker Chrg./Comm. Pattern                                                           CFF007
     C                   PARM                    ITBCPT                                       CFF007
      ** Market                                                                               CFF007
     C                   PARM                    SMRKT                                        CFF007
      ** Instrument                                                                           CFF007
     C                   PARM                    SISTC                                        CFF007
      ** No. of contracts                                                                     CFF007
     C                   PARM                    VNUCO                                        CFF007
      ** Action code                                                                          CFF007
     C                   PARM                    SACTN                                        CFF007
      ** Broker                                                                               CFF007
     C                   PARM                    SBOCO                                        CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBBFLG                                      CFF007
 
      ** Record any failure
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      BrokCCErr = 'Y'
 
      ** Append the array details from the above call onto the general
      ** error arrays
     C                   EXSR      AppendArrs
     C                   ENDIF
 
 
      ** 2. Customer
      ** -----------
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
      ** Broker Chrg./Comm. Pattern                                                           CFF007
     C                   PARM                    ITCCPT                                       CFF007
      ** Market                                                                               CFF007
     C                   PARM                    SMRKT                                        CFF007
      ** Instrument                                                                           CFF007
     C                   PARM                    SISTC                                        CFF007
      ** No. of contracts                                                                     CFF007
     C                   PARM                    VNUCO                                        CFF007
      ** Action code                                                                          CFF007
     C                   PARM                    SACTN                                        CFF007
      ** Broker                                                                               CFF007
     C                   PARM                    SBOCO                                        CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      ** PB customer indicator                                                                CFF007
     C                   PARM                    PPBCFLG                                      CFF007
 
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
 
      ** Determine if CFF001 is installed                                                     CFF007
                                                                                              CFF007
     C                   CALLB     'AOSARDR0'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*VERIFY'     @OPTN                                        CFF007
     C                   PARM      'CFF001'      PSARD                                        CFF007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFF007
                                                                                              CFF007
     C     @RTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVE      'Y'           CFF001                                       CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      'N'           CFF001                                       CFF007
     C                   ENDIF                                                                CFF007
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
                                                                                              CFF007
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
                                                                                              208635
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
      *                                                                                       CER001
      ** ULX604 - API Luxembourg - Function FFEXTR                                            CER001
      *                                                                                       CER001
     C                   EVAL      ULX604 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX604'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX604'                                          CER001
     C                   EVAL      DBASE  = 4                                                 CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   EVAL      ULX604 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return                                 CER001
      ** indicator is not set to 'Y'                                                          CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX604 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX604 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
                                                                                              CGL014
      ** Set the transaction typed field used by the database updater
     C                   EVAL      TransType = 'EXTR'
 
      ** Start on Main Details Screen
     C                   MOVEL     'M'           @SCRN             1
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Initialise field and function key status on main details screen
     C                   EXSR      IFDS@M
     C                   EXSR      IFKS@M
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFEXTRS010
 
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
(c) Finastra International Limited 2001
