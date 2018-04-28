     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade display - secondary screen')            *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADSDSP - SECURITIES TRADES DISPLAY - Secondary Screen    *
      *                                                               *
      *  Function:  This module displays the secondary details screen *
      *             of the Securites input function.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 209771             Date 02Oct02               *
      *                 211116             Date 01Nov02               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE037             Date 29Apr02               *
      *                 CSE035             Date 22Apr02               *
      *                 CSE039             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 194229             Date 14Jun01               *
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 167260             Date 12Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033             Date 26Apr99               *
      *                 CSE006             Date 07Jun99               *
      *                 CPB001             Date 30Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP050             Date 27Jul98               *
      *                 CAP003  *CREATE    Date 16Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  209771 - If F12 pressed on secondary screen reset Trade Ref. *
      *           if automatic generation used.                       *
      *  211116 - Protect amendment of 'Trade Sub-type' field for     *
      *           Private Banking customer transactions.              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE037 - Bond Pricing - 3 Decimal Places in Trades Input     *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *  CSE039 - Auto-settlement of trades                           *
      *  CAP067 - Repurchase Agreements API.                          *
      *  194229 - If Buy Sell on 1st leg is one book make sure 2nd    *
      *           leg has same book. Field protect book on 2nd leg.   *
      *  CSE016 - Extended Security Descriptions                      *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  167260 - Current Factor is not displayed correctly.          *
      *           Also corrected HELP tags in DSPF.                   *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Recompiled over changes to /COPY       *
      *           MSGHNDDCL.                                          *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *  CPB001 - 'Private Banking' Module                            *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP050 - Midas/ToF Interface                                 *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSETRADSDF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
                                                                                              CSE039
     FSEMVTSL2  IF   E           K DISK    INFSR(*PSSR)                                       CSE039
 
     FZATNRGL1  IF   E           K DISK    INFSR(*PSSR)                         209771
      *****************************************************************
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       60  Counterparty not a portfolio customer               *
      *       61  Trade Basis NOT D/Y => Non-display Price Field      *
      *       62  Processing type <> 1,3,5,6,8 & Trade basis <> P,Y   *
      *       63  Processing type <> '8' => Non-diplay "Curr Factor"  *
      *       64  Processing type <> '4','7' => Non-diplay "Ex Div"   *
      *       65  Disable input fields for incomplete trades          *
      *       66  Disable input fields that are non amendable         *
      *       67  Position cursor on customer (if no errors)          *
      *       68  Position cursor on nominal (if no errors)           *
      *       69  Position cursor on clearance type (if no errors)    *
      *       70  Protect deal detail fields                          *
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       74  Enable CF14                                         *
      *       75  Enable CF15                                         *
      *       76  Enable CF19                                         *
      *       77  Enable CF22                                         *                       CSE039
      *       78  Protect 'Trade Sub-type' field for PB Customer      *                       211116
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Bulk input option not used                          *
      *       82  Profit centre accounting not used                   *
      *       83  Display/Non Display Private Banking Order no.       *                CAP050 CPB001
      *       84  Protect Link Reference field if book is buy-sell    *                       CSE006
      *       85  Order Number displayed as input capable if ON       *                       CSE039
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      ********************************************************************
      /EJECT
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
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @NAR            S             40    DIM(2) CTDATA PERRCD(1)
 
     D @EIX            DS
     D  @EI                    1     60
     D                                     DIM(60)
 
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *                                                                         CSE006
      ** Book details                                                           CSE006
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                    CSE006
 
     D SDSCOD        E DS                  EXTNAME(SDSCODPD)                                  CSE039
      ** EXTERNAL DS FOR MESSAGE STATUS CODE DETAILS                                          CSE039
                                                                                              CSE039
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP050
      ** EXTERNAL DS FOR SAR DETAILS                                            CAP050
                                                                                              211116
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  211116
      ** Customer Details                                                                     211116
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     211116
 
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
     D TrSeco        E DS                  EXTNAME(SETRSEPD)
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CSE037
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_NDEC      E                     EXTFLD(NDEC)                                       CSE037
 
      *                                                                         CSE006
     D Indicators      DS                  Based(IndicatorP)                    CSE006
     D PrtLnkRef              84     84                                         CSE006
     D IndicatorP      S               *   Inz(%Addr(*IN))                      CSE006
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CGL031
     D CGL031          S              1                                                       CGL031
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Main processing
      *
     C                   EXSR      MAIN
      *
      **  Reset Trade Reference if F12 and automatic generation                 209771
     C     @INKL         IFEQ      '1'                                          209771
     C     DDACTN        ANDEQ     'I'                                          209771
     C                   EVAL      MODUK = 'SE'                                 209771
     C                   EVAL      TRTYK = 'T'                                  209771
      *                                                                         209771
     C     RefnoKey      CHAIN     ZATNRGL1                           99        209771
      *                                                                         209771
     C                   MOVEL     DDTDRF        DDTDRFN           6 0          209771
     C     *IN99         IFEQ      '0'                                          209771
     C     DDTDRFN       ANDLT     FNOR                                         209771
     C                   MOVEL     *BLANKS       DDTDRF                         209771
     C                   END                                                    209771
     C                   END                                                    209771
      *                                                                         209771
      * Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C* MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   EVAL      @EIX = (OKTrPrim + OKTrSeco)
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
 
 
      ** Set up the transaction reference to be used by the message handler
     C                   EVAL      TranRef = DDTDRF
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
 
      * Counterparty not a portfolio customer
      *
     C                   MOVE      *OFF          *IN60
     C     CustClass     IFNE      'S'
     C     CustClass     ANDNE     'D'
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *
      * Trade Basis NOT D/Y => Non-display Price Field
      *
     C                   MOVE      *OFF          *IN61
     C     STBS          IFNE      'D'
     C     STBS          ANDNE     'Y'
     C                   MOVE      *ON           *IN61
     C                   ENDIF
      *
      * Processing type <> 1,3,5,6,8 & Trade basis <> P or Y
      * => Non-display Accrued Int fields
      *
     C                   MOVE      *OFF          *IN62
     C     PROT          IFNE      '1'
     C     PROT          ANDNE     '3'
     C     PROT          ANDNE     '5'
     C     PROT          ANDNE     '6'
     C     PROT          ANDNE     '8'
     C     PROT          ANDNE     '9'                                                         S0117
     C     STBS          OREQ      'D'
     C                   MOVE      *ON           *IN62
     C                   ENDIF
      *
      * Processing type <> '8' => Non-diplay "Current Factor"
      *
     C                   MOVE      *OFF          *IN63
     C     PROT          IFNE      '8'
     C                   MOVE      *ON           *IN63
     C                   ENDIF
      *
      * Processing type <> '4' or '7' => Non-diplay "Ex Dividend"
      *
     C                   MOVE      *OFF          *IN64
     C     PROT          IFNE      '4'
     C     PROT          ANDNE     '7'
     C                   MOVE      *ON           *IN64
     C                   ENDIF
      *                                                                                       CGL031
      * Enable Fiscal Price when CGL031 is on.                                                CGL031
      *                                                                                       CGL031
     C     CGL031        IFEQ      'Y'                                                        CGL031
     C                   MOVE      *ON           *IN77                                        CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVE      *OFF          *IN77                                        CGL031
     C                   ENDIF                                                                CGL031
      *
      * Disable input fields for incomplete trades
      *
     C                   MOVE      *OFF          *IN65
     C     CurTINC       IFNE      'I'
     C                   MOVE      *ON           *IN65
     C                   END
      *
      *                                                                         CPB001
      *  Reset Order Trade if this one is zero                                  CPB001
      *                                                                         CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C     DDORDE        ANDEQ     '000000'                                     CPB001
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     DDORDE        ANDEQ     '999999'                                     CPB001
     C                   MOVE      *BLANKS       DDORDE                         CPB001
     C                   ENDIF                                                  CPB001
      *
     C                   MOVE      *OFF          *IN66
     C                   MOVE      *OFF          *IN70
                                                                                              CSE035
     C                   MOVE      *OFF          *IN75                                        CSE035
                                                                                              CSE035
     C     CSE035        IFEQ      'Y'                                                        CSE035
                                                                                              CSE035
     C     PROT          IFEQ      '1'                                                        CSE035
     C     TRBS          ANDEQ     'Y'                                                        CSE035
     C                   MOVE      *ON           *IN75                                        CSE035
     C                   END                                                                  CSE035
                                                                                              CSE035
     C                   END                                                                  CSE035
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C     DDACTN        WHENEQ    'C'
     C     DDACTN        WHENEQ    'A'
      *
      * Disable input fields that are non amendable, if trade is complete
     C     CurTINC       IFNE      'I'
     C                   MOVE      *ON           *IN66
     C                   END
     C                   OTHER
     C                   MOVE      *ON           *IN70
     C                   ENDSL
      *                                                                                       211116
     C                   MOVE      DDCNUM        KEY10                                        211116
      *                                                                                       211116
     C                   CALLB     'AOCUSTR1'                                                 211116
     C                   PARM      '*MSG    '    @RTCD                                        211116
     C                   PARM      '*KEY    '    @OPTN                                        211116
     C                   PARM                    KEY10            10                          211116
     C                   PARM                    KEY7              7                          211116
     C     SDCUST        PARM      SDCUST        DSLDY                                        211116
      *                                                                                       211116
      ** Customer is a Private Banking Customer: get default value if blank                   211116
      *                                                                                       211116
     C     @RTCD         IFEQ      *BLANKS                                                    211116
     C     BBPRBA        ANDEQ     'Y'                                                        211116
     C                   MOVEL     'Y'           PBCusInd          1                          211116
     C                   ELSE                                                                 211116
     C                   MOVEL     'N'           PBCusInd                                     211116
     C                   ENDIF                                                                211116
      *                                                                                       211116
      * If Private Banking Customer, protect amendment of Trade Subtype                       211116
      *                                                                                       211116
     C     BGN4ST        IFEQ      'Y'                                                        211116
     C     PBCusInd      ANDEQ     'Y'                                                        211116
      *                                                                                       211116
     C     DDACTN        Ifeq      'A'                                                        211116
     C     CurTINC       Andeq     'C'                                                        211116
     C     DDACTN        Oreq      'C'                                                        211116
     C     CurTINC       Andeq     'C'                                                        211116
     C                   Move      True          *IN78                                        211116
     C                   Endif                                                                211116
      *                                                                                       211116
     C                   Endif                                                                211116
      *
      ** If this is the second leg of the buy/sell trade field protect                        194229
      ** the book code to ensure that both legs are the same.                                 194229
      *                                                                                       194229
     C                   IF        IN50 = 'Y'                                                 194229
     C                   EVAL      *IN50 = '1'                                                194229
     C                   END                                                                  194229
      *                                                                                       194229
      * Position cursor if no errors
      * (On customer, nominal or clearance type)
      *
     C                   MOVE      '0'           *IN67
     C                   MOVE      '0'           *IN68
     C                   MOVE      '0'           *IN69
     C     *IN70         IFEQ      '0'
     C                   Z-ADD     1             C                 2 0
     C     'N'           LOOKUP    @EI(C)                                 99    *
     C  N99'W'           LOOKUP    @EI(C)                                 99    *
     C     *IN99         IFEQ      '0'
     C     *IN66         IFEQ      '1'
     C                   MOVE      '1'           *IN69
     C                   ELSE
     C     *IN65         IFEQ      '1'
     C                   MOVE      '1'           *IN68
     C                   ELSE
     C                   MOVE      '1'           *IN67
     C                   END
     C                   END
     C                   END
     C                   END
      *
      *                                                                         CSE006
      *** If the book is not a buy-sell book then no new processing is          CSE006
      *** required, otherwise protect the link reference.                       CSE006
      *                                                                         CSE006
     C                   EVAL      PrtLnkRef = *OFF                             CSE006
      *                                                                         CSE006
     C                   IF        CSE006 = 'Y'                                 CSE006
      *                                                                         CSE006
     C                   CALL      'AOBOOKR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD             7            CSE006
     C                   PARM      '*KEY   '     @OPTN             7            CSE006
     C                   PARM      DDBPBK        @BOOK             2            CSE006
     C     SDBOOK        PARM      SDBOOK        DSFDY                          CSE006
      *                                                                         CSE006
     C                   IF        BDBYSL = 'Y'                                 CSE006
     C                   EVAL      PrtLnkRef = *ON                              CSE006
     C                   ELSE                                                   CSE006
     C                   EVAL      PrtLnkRef = *OFF                             CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKP        COMP      'Y'                                    74
      *
      * TEXT = CONFIRM DELETE
      *
     C     @EINKJ        IFEQ      'Y'
     C                   MOVEL     @NAR(2)       DDFOTX
     C                   ELSE
     C                   MOVEL     *BLANK        DDFOTX
     C                   END
      *
      ** If the second leg of a buy sell trade move 1st leg book into 2nd                     194229
      ** leg of trade.                                                                        194229
      *                                                                                       194229
     C     IN50          IFEQ      'Y'                                                        194229
     C                   EVAL      DDBPBK = TRDBK1                                            194229
     C                   END                                                                  194229
      *                                                                                       194229
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
      * If CSE039 is ON then access movements file for movement status                        CSE039
      * and display                                                                           CSE039
     C                   MOVE      *BLANKS       DDSWSC                                       CSE039
     C                   MOVE      *BLANKS       DDCDNR                                       CSE039
                                                                                              CSE039
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C     DDACTN        ANDNE     'I'                                                        CSE039
     C                   MOVE      DDTDRF        KTDRF                                        CSE039
     C                   MOVE      'T'           KTRTY                                        CSE039
                                                                                              CSE039
     C     KMVTS         SETLL     SEMVTSD0                                                   CSE039
     C     KMVTS         READE     SEMVTSD0                               86                  CSE039
      *                                                                                       CSE039
      * Obtain Status description                                                             CSE039
     C     *IN86         IFEQ      *OFF                                                       CSE039
     C                   CALLB     'AOSCODR0'                                                 CSE039
     C                   PARM      *Blanks       @RTCD                                        CSE039
     C                   PARM      '*KEY'        @OPTN                                        CSE039
     C                   PARM      TMSWSC        @CCODE            4                          CSE039
     C                   PARM      'S'           @CDTP             1                          CSE039
     C                   PARM      *Blanks       @CDDP             4                          CSE039
     C     SDSCOD        PARM      SDSCOD        DSFDY                                        CSE039
                                                                                              CSE039
      * Move Status and Status description to screen fields.                                  CSE039
     C                   MOVEL     TMSWSC        DDSWSC                                       CSE039
     C                   MOVEL     SRCDNR        DDCDNR                                       CSE039
                                                                                              CSE039
     C                   ENDIF                                                                CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   WRITE     SETRADSS0
     C                   WRITE     SETRADSD1
     C                   WRITE     SETRADSF1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      SETRADSD1                              99    *
     C                   ENDIF
      *
      * Clear message subfile
      *
     C**** martin        CALL      'ZA0250'
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKP         @INKP
     C                   MOVE      *INKW         @INKW                                        CSE039
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Trade (IN SCREEN FORMAT - Primary / Secondary)
     C                   PARM                    TrPrim
     C                   PARM                    TrSeco
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      * Security report name
      * Customer report name
     C**********         PARM                    DDSRPN           20                          CSE016
     C                   PARM                    DDSRNME          41                          CSE016
     C                   PARM                    DDCRNM           20
      * Current Factor
      * Coupon Rate
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDCPNR           13
      *
      * Current trade incomplete ind
     C                   PARM                    CurTINC           1
      *
      * Fields in error
     C                   PARM                    OKTrPrim
     C                   PARM                    OKTrSeco
      *
      ** Customer classification
     C                   PARM                    CustClass         1
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
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
      * Protect book on second leg                                                            194229
     C                   PARM                    IN50              1                          194229
     C                   PARM                    TRDBK1            2                          194229
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       194229
      ** Buy-sell back                                                                        CAP067
     C                   PARM                    PBYSL             1                          CAP067
      *                                                                                       CAP067
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKE             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKW             1                          CSE039
     C                   PARM                    @INKWDisp         1                          CSE039
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADSDSP'  DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS SECURITIES TRADING DETAILS
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 907*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *
      ** Check if CSE039 is installed                                                         CSE039
     C                   CALL      'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD             7                          CSE039
     C                   PARM      '*VERIFY'     @OPTN             7                          CSE039
     C                   PARM      'CSE039'      @SARD             6                          CSE039
      *                                                                                       CSE039
     C     @RTCD         IFEQ      *BLANKS                                                    CSE039
     C                   MOVE      'Y'           CSE039            1                          CSE039
     C                   ELSE                                                                 CSE039
     C                   MOVE      'N'           CSE039                                       CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE039
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      * SET SCREEN PROTECT/NON-DISPLY INDICATORS
      *
      *
      * Single-branching (protect booking branch)
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN80
     C                   END
      *
      * Bulk Input Option not used
      *
     C     BVBIOP        IFNE      'Y'
     C                   MOVE      '1'           *IN81
     C                   END
      *
      * OR Profit Centre Accounting not used => Non-display Profit centre
      *
     C     BGN0ST        IFNE      'Y'
     C                   MOVE      '1'           *IN82
     C                   END
      *
      ***Check*if*Midas/ToF Interface feature is present                 CAP050 CPB001
     C****************** CALLB     'AOSARDR0'                            CAP050 CPB001
     C****************** PARM      *BLANKS       @RTCD                   CAP050 CPB001
     C****************** PARM      '*VERIFY'     @OPTN                   CAP050 CPB001
     C****************** PARM      'CAP050'      @SARD                   CAP050 CPB001
     C*****SCSARD******* PARM      SCSARD        DSFDY                   CAP050 CPB001
     C*****@RTCD******** IFEQ      *BLANKS                               CAP050 CPB001
     C****************** MOVE      'Y'           CAP050            1     CAP050 CPB001
     C****************** ELSE                                            CAP050 CPB001
     C****************** MOVE      'N'           CAP050                  CAP050 CPB001
     C****************** MOVE      *ON           *IN83                   CAP050 CPB001
     C****************** ENDIF                                           CAP050 CPB001
      *                                                                         CPB001
      *  Private Banking Module not used => Non-display Order Number            CPB001
      *                                                                         CPB001
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVE      '1'           *IN83                          CPB001
     C                   ENDIF                                                  CPB001
      *                                                                         CSE006
      *  If CSE039 is on then Order Number is displayed and input               CSE039
      *  capable.                                                               CSE039
     C     CSE039        IFEQ      'Y'                                          CSE039
     C                   MOVE      '0'           *IN83                          CSE039
     C                   MOVE      '1'           *IN85                          CSE039
                                                                                CSE039
      * Ensure F22 key is displayed (if called from SIN module)                 CSE039
     C     DDACTN        IFEQ      'E'                                          CSE039
     C     DDACTN        OREQ      'C'                                          CSE039
     C     DDACTN        OREQ      'A'                                          CSE039
     C     @INKWDisp     IFEQ      'Y'                                          CSE039
     C                   MOVE      '1'           *IN77                          CSE039
     C                   ENDIF                                                  CSE039
     C                   ENDIF                                                  CSE039
      *                                                                         CSE039
     C                   ENDIF                                                  CSE039
                                                                                CSE039
      *** Check if switchable feature CSE006 is on.                             CSE006
      *                                                                         CSE006
     C                   CALL      'AOSARDR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM      '*VERIFY'     @OPTN                          CSE006
     C                   PARM      'CSE006'      @SARD                          CSE006
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE006
      *                                                                         CSE006
      *** Check for Database error                                              CSE006
      *                                                                         CSE006
     C     @RTCD         IFNE      *BLANKS                                      CSE006
     C     @RTCD         ANDNE     '*NRF   '                                    CSE006
     C                   MOVEL     'CSE006'      DBKEY                          CSE006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
     C                   MOVEL     '905'         DBASE                          CSE006
     C                   EXSR      *PSSR                                        CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C     @RTCD         IFEQ      *BLANK                                       CSE006
     C                   MOVE      'Y'           CSE006            1            CSE006
     C                   ELSE                                                   CSE006
     C                   MOVE      'N'           CSE006                         CSE006
     C                   ENDIF                                                  CSE006
 
      ** Check if switchable feature CSE035 is on                                             CSE035
                                                                                              CSE035
     C                   CALL      'AOSARDR0'                                                 CSE035
     C                   PARM      *BLANKS       @RTCD                                        CSE035
     C                   PARM      '*VERIFY'     @OPTN                                        CSE035
     C                   PARM      'CSE035'      @SARD                                        CSE035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE035
                                                                                              CSE035
      ** Check for Database error                                                             CSE035
                                                                                              CSE035
     C     @RTCD         IFNE      *BLANKS                                                    CSE035
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE035
     C                   MOVEL     'CSE035'      DBKEY                                        CSE035
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE035
     C                   MOVEL     '906'         DBASE                                        CSE035
     C                   EXSR      *PSSR                                                      CSE035
     C                   ENDIF                                                                CSE035
                                                                                              CSE035
     C     @RTCD         IFEQ      *BLANK                                                     CSE035
     C                   MOVE      'Y'           CSE035            1                          CSE035
     C                   ELSE                                                                 CSE035
     C                   MOVE      'N'           CSE035                                       CSE035
     C                   ENDIF                                                                CSE035
      *
     C     Refnokey      KLIST                                                                209771
     C                   KFLD                    MODUK             2                          209771
     C                   KFLD                    TRTYK             1                          209771
      *                                                                                       209771
      ** If Buy-sell back processing, write appropriate screen header                         CAP067
     C                   IF        PBYSL = 'Y'                                                CAP067
     C                   EVAL      *IN86 = *ON                                                CAP067
     C                   ELSE                                                                 CAP067
     C                   EVAL      *IN86 = *OFF                                               CAP067
     C                   ENDIF                                                                CAP067
 
     C     KMVTS         KLIST                                                                CSE039
     C                   KFLD                    KTDRF             6                          CSE039
     C                   KFLD                    KTRTY             1                          CSE039
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SECPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Trade No.999999 successfully inserted.
F10=CONFIRM DELETE
