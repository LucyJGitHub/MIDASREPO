     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments lvl 2 scrn 2 defaulting')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY3DT - Incoming Payments Level 2 Screen 2 Defaulting    *
      *                                                               *
      *  Function: This module defaults VAT Flags and Amounts, and    *
      *            Charges for the Charges and Commission screen.     *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR1088819          Date 27Apr20               *
      *  Prev Amend No. MD055030           Date 27Apr20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD034828           Date 01Jul15               *
      *                 CFT157             Date 29Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260709             Date 10Jun09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247277             Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 219150             Date 27Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 216958             Date 06Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG4329            Date 23Sep04               *
      *                 BUG4141            Date 07Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001             Date 09Dec03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Aug03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209726             Date 15Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196562             Date 20Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 01Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1088819  - Issue on job names during SSL enabling of JDBC  *
      *              calls (Child: AR1088820)                         *
      *            - Applied for MD055645.                            *
      *            - Added NoDft in QZDASSINIT. Applied for MD055645  *
      *  MD055030 - Added NoDft in QZDASSINIT                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034828 - Commission & Charges details are lost after       *
      *             confirm complete                                  *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  260709 - FT APISERVER Fees and Charges not defaulted         *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  219150 - Charges disappear during amend mode.  Apply fix     *
      *           216958.                                             *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  216958 - In amend mode, the charge amounts are not redis -   *
      *           played.  As a result, if the user didn't re-entered *
      *           the charges during amend, the amounts are lost and  *
      *           set to zero.  Reversed core fix 196562.             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4329- Do not overwrite charges entered with defaults      *
      *           during amendement                                   *
      *  BUG4141- Do not overwrite charges entered with defaults      *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Also perform defaulting of charges if module        *
      *           is called from Midas Plus interface.                *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value                                        *
      *  209726 - If beneficiary is SWIFT, pass the second line which *
      *           might contain the BIC address.                      *
      *  196562 - Transfer Commission Charge should recalculate after *
      *           settlement amount is amended.                       *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*trans.***         CFT014
      ***-*screen*format***********************************************         CFT014
     D*NwIP4ScnFmt***E*DS***               EXTNAME(FTIPY4PD)                    CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming trans.            CFT014
      ** - screen format                                                        CFT014
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                         CFT014
      ** Incoming Payments (additional info) for file update                    CFT014
      ** - file format                                                          CFT014
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
      *
      ** Incoming Payments retrieved from file - file format
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
      *
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                              219241
      ** External DS for Midas Message Management ICD                                         219241
     D SDMGME        E DS                  EXTNAME(SDMGMEPD )                                 219241
                                                                                              219241
     D/COPY WNCPYSRC,FTIPA3DTD1
      *
      ** DS for Acess Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for calculation of default Charges (FT0320)
      *                                                                         CFT014
      ** DS for account details                                                 CFT014
     D WACCDS        E DS                  EXTNAME(ACCNTAB) PREFIX(AB)          CFT014
      *                                                                         CFT014
      ** DS for full GL account number                                          CFT014
     D***WGLACC          DS            18                                              CFT014 CGL029
     D WGLACC          DS            24                                                       CGL029
     D**WGLCNUM*               1      6  0                                             CFT014 CSD027
     D  WGLCNUM                1      6                                                       CSD027
     D  WGLCCY                 7      9                                         CFT014
     D***WGLACOD               10     13  0                                            CFT014 CGL029
     D***WGLACSQ               14     15  0                                            CFT014 CGL029
     D***WGLBRCA               16     18                                               CFT014 CGL029
     D  WGLACOD               10     19  0                                                    CGL029
     D  WGLACSQ               20     21  0                                                    CGL029
     D  WGLBRCA               22     24                                                       CGL029
      *
     D P7DATA          DS           321
      *
      ** Payment Type and Payment Subtype
     D  W7PYTP                 1      2
     D  W7PYST                 3      4
      *
      ** Input Currency and Charge Currency
     D  W7ICCY                 5      7
     D  W7CCCY                 8     10
      *
      ** Settlement Method
     D  W7STMT                11     12
      *
      ** Defaults Required
     D  W7DFRQ                13     13
      *
      ** Charges Branch
     D  W7BRCA                14     16
      *
      ** Charge Currency Amount
     D  W7CAMT                17     29  0
      *
      ** Transfer Commission Type
     D  W7TRCT                30     30
      *
      ** SWIFT Priority Code
     D  W7SWPC                31     31
      *
      ** Transfer Commission Amount
     D  W7TRCD                32     42  0
     D  W7TRCH                43     53  0
      *
      ** Telex Charge
     D  W7TXCD                54     64  0
     D  W7TXCH                65     75  0
      *
      ** Cheque Charge
     D  W7CQCD                76     86  0
     D  W7CQCH                87     97  0
      *
      ** Costs Abroad
     D  W7CSTD                98    108  0
     D  W7CSTA               109    119  0
      *
      ** SWIFT Priority Charge
     D  W7SPCD               120    130  0
     D  W7SPCH               131    141  0
      *
      ** Miscellaneous Charge
     D  W7MSCD               142    152  0
     D  W7MSCH               153    163  0
      *
      ** Advice Charge
     D  W7ADCD               164    174  0
     D  W7ADCH               175    185  0
      *
      ** Telephone Charge
     D  W7TLCD               186    196  0
     D  W7TLCH               197    207  0
      *
      ** Collection Charge
     D  W7COLD               208    218  0
     D  W7COLL               219    229  0
      *
      ** Payment Amount Currency
     D  W7PCCY               230    232
      *
      ** Other Currency
     D  W7OCCY               233    235
      *
      ** FX/Change Commission (Input Ccy)
     D  W7CHCD               236    246  0
      *
      ** FX/Change Commission (Charge Ccy)
     D  W7CHCM               247    257  0
      *
      ** Our Deductions (Input Ccy)
     D  W7DEDD               258    268  0
      *
      ** Our Deductions (Charge Ccy)
     D  W7DEDS               269    279  0
      *
      ** Correspondent Charge (Input Ccy)
     D  W7COCD               280    290  0
      *
      ** Correspondent Charge (Charge Ccy)
     D  W7COCH               291    301  0
      *
      ** Default Type (HDR or DET or " ")
     D  W7DFTT               302    304
      *
      ** Customer to be Debited the Charge
     D  W7CUST               305    310
      *
      ** Settle Date
     D  W7SLDT               311    315  0
      *
      ** Pay Date
     D  W7PVDT               316    320  0
      *
      ** Add/Deduct Charges
     D  W7ADDC               321    321
      *
      ** Calling parameter DS for FT0035
     D P0DTA           DS           256
     D  WIPT1                  1      1
     D  WIPTY1                 2     36
     D  WIPT2                 37     37
     D  WIPTY2                38     72
     D  WICCY                 73     75
     D  WOCUST                76     81
      *
      ** DS for Default Charge Amounts
     D*PCharges*       DS           108                                         CFT009
     D**DDTRCM**               1     12                                         CFT009
     D**DDTXCH**              13     24                                         CFT009
     D**DDCQCH**              25     36                                         CFT009
     D**DDADCH**              37     48                                         CFT009
     D**DDTLCH**              49     60                                         CFT009
     D**DDMSCH**              61     72                                         CFT009
     D**DDCHCM**              73     84                                         CFT009
     D**DDVATT**              85     96                                         CFT009
     D**DDVATD**              97    108                                         CFT009
     D PCharges        DS           196                                         CFT009
     D  DDTRCM                 1     14                                         CFT009
     D  DDTXCH                15     28                                         CFT009
     D  DDCQCH                29     42                                         CFT009
     D  DDADCH                43     56                                         CFT009
     D  DDTLCH                57     70                                         CFT009
     D  DDMSCH                71     84                                         CFT009
     D  DDCHCM                85     98                                         CFT009
     D  DDVATT                99    112                                         CFT009
     D  DDVATD               113    126                                         CFT009
     D  M1CH                 127    140                                         CFT009
     D  M2CH                 141    154                                         CFT009
     D  M3CH                 155    168                                         CFT009
     D  M4CH                 169    182                                         CFT009
     D  M5CH                 183    196                                         CFT009
      *
      ** DS for Default Charge Currencies
     D PChgCcy         DS            48
     D  DDCCY1                 1      3
     D  DDCCY2                 4      6
     D  DDCCY3                 7      9
     D  DDCCY4                10     12
     D  DDCCY5                13     15
     D  DDCCY6                16     18
     D  DDCCY7                19     21
     D  DDCCY8                22     24
     D  DDRCY1                25     27
     D  DDRCY2                28     30
     D  DDRCY3                31     33
     D  DDRCY4                34     36
     D  DDRCY5                37     39
     D  DDRCY6                40     42
     D  DDRCY7                43     45
     D  DDRCY8                46     48
                                                                                              CGL029
     D  PPrvCDRO       S             18A                                                      CGL029
     D  NoDft          S              1A                                                     BUG4141
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
     D PPrvCDRC        S              3A                                                      CFT120
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Determine Charge Currencies and "Charges to the Debit of"
      ** Customer.
      *
     C                   EXSR      SRDftCyCu
      *
      ** Initialise Recalculation of VAT Amounts flag.
      *
     C                   MOVE      *BLANK        WRCAL             1
      *
      ** If Commission Type or "Charges to the Debit of" Customer
      ** has changed, recalculate Charges.
      *
     C     DDACTN        IFEQ      'I'
     C     PReCalc       ANDNE     'Y'                                                        187056
     C     IPTRCT        ORNE      TRCT
     C     PReCalc       ANDNE     'Y'                                                        187056
     C*****IPCDRO        ORNE      *ZERO                                                      CSD027
     C     IPCDRO        ORNE      *BLANKS                                                    CSD027
     C*****CDRO          ANDEQ     *ZERO                                                      CSD027
     C     CDRO          ANDEQ     *BLANKS                                                    CSD027
     C     PReCalc       ANDNE     'Y'                                                        187056
     C*****IPCDRO        OREQ      *ZERO                                                      CSD027
     C     IPCDRO        OREQ      *BLANKS                                                    CSD027
     C*****CDRO          ANDNE     *ZERO                                                      CSD027
     C     CDRO          ANDNE     *BLANKS                                                    CSD027
     C     PReCalc       ANDNE     'Y'                                                        187056
     C     DDCDRO        ORNE      PPrvCDRO                                                   187056
     C     CFT120        ANDEQ     'N'                                                        CFT120
     C     DDCDRO        ORNE      PPrvCDRO                                                   CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     PReCalc       ANDNE     'Y'                                                        CFT120
     C     DDCDBR        ORNE      PPrvCDBR                                                   187056
     C     CFT120        ANDEQ     'N'                                                        CFT120
     C     DDCDBR        ORNE      PPrvCDBR                                                   CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     PReCalc       ANDNE     'Y'                                                        CFT120
     C     DDCDRC        ORNE      PPrvCDRC                                                   CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     PReCalc       ANDNE     'Y'                                                        CFT120
     C     W0FCUS        ORNE      W0SCUS                                                     187056
     C     PReCalc       ANDNE     'Y'                                                        CFT120
     C*****DDACTN        OREQ      'A'                                                 196562 216958
     C*****PReCalc       ANDNE     'Y'                                                 196562 216958
     C*****DDACTN        OREQ      'A'                                                        187056
     C*****W0FCUS        ANDNE     W0SCUS                                                     187056
     C                   EXSR      SRDftChrg2
     C                   IF        PReCalc <> 'Y'                                             187056
     C                   EVAL      PPrvCDRO = DDCDRO                                          187056
     C                   EVAL      PPRVCDBR = DDCDBR                                          187056
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      PPRVCDRC = DDCDRC                                          CFT120
     C                   ENDIF                                                                CFT120
     C                   EVAL      PPrvCDRT = CDRT                                            187056
     C                   ENDIF                                                                187056
     C                   ENDIF
      *
      ** Default output fields.
      *
     C                   EXSR      SRDftOFlds
      *
      ** Default VAT Flags and VAT Amounts if BLI VAT Processing
      ** feature is on.
      *
     C     S01499        IFEQ      'Y'
     C                   EXSR      SRDftVat
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialise output fields                            *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
     C                   CLEAR                   PICCY
     C                   CLEAR                   PIINCY
     C                   Z-ADD     *ZERO         PINBDP
     C                   Z-ADD     *ZERO         PITPSD
      *
     C                   CLEAR                   POCCY
     C                   CLEAR                   POINCY
     C                   Z-ADD     *ZERO         PONBDP
      *
     C                   CLEAR                   PCharges
     C                   CLEAR                   PChgCcy
                                                                                              219241
      ** Get Message Management Details if CFT014 is installed                                219241
                                                                                              219241
     C                   IF        CFT014 = 'Y'                                               219241
                                                                                              219241
     C                   CALL      'AOMGMER1'                                                 219241
     C                   PARM      *BLANKS       PRTCD                                        219241
     C                   PARM      '*FIRST'      POPTN                                        219241
     C     SDMGME        PARM      SDMGME        DSSDY                                        219241
                                                                                              219241
     C                   IF        PRTCD <> *BLANKS                                           219241
     C                   EVAL      DBFILE = 'SDMGMEPD'                                        219241
     C                   EVAL      DBASE = 8                                                  219241
     C                   EVAL      DBKEY = POPTN                                              219241
     C                   EXSR      *PSSR                                                      219241
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   ENDIF                                                                219241
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDftCyCu - Determine default Charge Currencies and "Charge  *
      *              to the DR of" Customer                           *
      *                                                               *
      *****************************************************************
      *
     C     SRDftCyCu     BEGSR
      *
      ** Get Input Charge Currency.
      *
     C                   SELECT
      *
     C     BTCHCY        WHENEQ    'B'
     C*****IPCDRO        ORNE      *ZERO                                                      187056
     C     DDCDRO        ORNE      *BLANKS                                                    187056
     C     CFT120        ANDEQ     'N'                                                        CFT120
     C     BTCHCY        OREQ      'B'                                                        CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C                   MOVEL     BJCYCD        PICCY
      *
     C     BTCHCY        WHENEQ    'L'
     C                   MOVEL     BJLCCY        PICCY
      *
     C     BTCHCY        WHENEQ    'C'
     C     IPADDC        ANDEQ     'A'
     C                   MOVEL     IPSMCY        PICCY
      *
     C                   OTHER
     C                   MOVEL     IPPCCY        PICCY
      *
     C                   ENDSL
      *
      ** Get Output Charge Currency.
      *
     C                   SELECT
      *
     C*****IPCDRO        WHENNE    *ZERO                                                      187056
     C     DDCDRO        WHENNE    *BLANKS                                                    187056
      *                                                                                       CFT120
     C                   IF        DDCDRC = *BLANKS AND CFT120 = 'Y' OR                       CFT120
     C                             CFT120 = 'N'                                               CFT120
     C                   MOVEL     BJCYCD        POCCY
     C                   ELSE                                                                 CFT120
     C                   EVAL      POCCY = DDCDRC                                             CFT120
     C                   ENDIF                                                                CFT120
      *
     C     IPADDC        WHENEQ    'A'
     C                   MOVEL     IPSMCY        POCCY
     C     IPSND1        IFEQ      'CASHIER'
     C     IPPCCY        ANDEQ     BJCYCD
     C                   MOVEL     IPPCCY        POCCY
     C                   ENDIF
      *
     C                   OTHER
     C                   MOVEL     IPPCCY        POCCY
      *
     C                   ENDSL
      *
     C                   MOVE      *BLANKS       W0FCUS            6
     C                   MOVE      *BLANKS       W0SCUS            6
      *
      ** Perform the following only if core feature S01508
      ** (BLI Extended Payment Charges) is installed and core
      ** feature S01506 (BLI Payment Charges Enhancements)
      ** is NOT installed.  Get "Charges to the Debit of"
      ** Customer using FT0035 based on Level 2 details.
      *
     C     S01508        IFEQ      'Y'
     C     S01506        ANDNE     'Y'
      *
      ** Get original "Charges to the Debit of" Customer.
      *
     C                   CLEAR                   P0DTA
      *
     C*****CDRT*         IFNE      *BLANKS                                                    187056
     C**********         MOVE      CDRT          WIPT1                                        187056
     C**********         MOVEL     CDRO          W0FLD            12                          187056
     C*****W0FLD         CAT(P)    CDBR          WIPTY1                                       187056
     C     PPrvCDRT      IFNE      *BLANKS                                                    187056
     C                   MOVE      PPrvCDRT      WIPT1                                        187056
     C     PPrvCDRO      CAT(P)    PPrvCDBR      WIPTY1                                       187056
      *                                                                                       CFT120
     C                   IF        PPrvCDRC = *BLANKS AND CFT120 = 'Y' OR                     CFT120
     C                             CFT120 = 'N'                                               CFT120
     C                   MOVE      BJCYCD        WICCY
     C                   ELSE                                                                 CFT120
     C                   EVAL      WICCY = PPrvCDRC                                           CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   CALL      'FT0035'                             9090
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    P0DTA
     C                   PARM                    P0MSG           256
      *
     C     *IN90         IFEQ      *ON
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0035'      DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      WOCUST        W0FCUS
      *
     C                   ENDIF
      *
      ** Get new "Charges to the Debit of" Customer.
      *
     C                   CLEAR                   P0DTA
      *
     C     IPCDRT        IFNE      *BLANKS
     C                   MOVE      IPCDRT        WIPT1
     C**********         MOVEL     IPCDRO        W0FLD                                        187056
     C*****W0FLD         CAT(P)    IPCDBR        WIPTY1                                       187056
     C     DDCDRO        CAT(P)    DDCDBR        WIPTY1                                       187056
      *                                                                                       CFT120
     C                   IF        DDCDRC = *BLANKS AND CFT120 = 'Y' OR                       CFT120
     C                             CFT120 = 'N'                                               CFT120
     C                   MOVE      BJCYCD        WICCY
     C                   ELSE                                                                 CFT120
     C                   EVAL      WICCY = DDCDRC                                             CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   CALL      'FT0035'                             9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    P0DTA
     C                   PARM                    P0MSG
      *
     C     *IN90         IFEQ      *ON
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0035'      DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      WOCUST        W0SCUS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDftChrg2 - Determine default Charges                       *
      *                                                               *
      *****************************************************************
      *
     C     SRDftChrg2    BEGSR
      *
     C                   CLEAR                   P7DATA
     C                   MOVEL     *BLANKS       P7ACT             8
     C                   MOVEL     'IN'          P7ACT
      *
      ** Payment Type and Subtype.
      *
     C                   MOVEL     PPYTP         W7PYTP
     C                   MOVEL     IPPYST        W7PYST
      *
      ** Input Currency and Charge Currency.
      *
     C                   MOVEL     PICCY         W7ICCY
     C                   MOVEL     POCCY         W7CCCY
      *
      ** Settlement Method.
      *
     C                   MOVEL     *BLANKS       W7STMT
      *
      ** Defaults Required.
      *
     C                   MOVEL     'Y'           W7DFRQ
      *
      ** Charges Branch.
      *
     C                   MOVEL     PPYBR         W7BRCA
      *
      ** Charge Currency Amount.
      *
     C                   SELECT
      *
     C     IPADDC        WHENEQ    'A'
     C                   Z-ADD     IPSMAM        W7CAMT
     C                   MOVEL     IPSMCY        W7PCCY
      *
     C                   OTHER
     C                   Z-ADD     IPPYAM        W7CAMT
     C                   MOVEL     IPPCCY        W7PCCY
      *
     C                   ENDSL
      *
      ** Transfer Commission Type.
      *
     C                   MOVEL     IPTRCT        W7TRCT
      *
      ** SWIFT Priority Code.
      *
     C     IPSWPC        IFEQ      1
     C                   MOVEL     'U'           W7SWPC
     C                   ELSE
     C                   MOVEL     'N'           W7SWPC
     C                   ENDIF
      *
      ** Transfer Commission Amount.
      *
     C                   Z-ADD     IPDUMA1       W7TRCD
     C                   Z-ADD     IPTRCM        W7TRCH
      *
      ** Telex Charge.
      *
     C                   Z-ADD     IPDUMA2       W7TXCD
     C                   Z-ADD     IPTXCH        W7TXCH
      *
      ** Cheque Charge.
      *
     C                   Z-ADD     IPDUMA3       W7CQCD
     C                   Z-ADD     IPCQCH        W7CQCH
      *
      ** Costs Abroad.
      *
     C                   Z-ADD     *ZERO         W7CSTD
     C                   Z-ADD     *ZERO         W7CSTA
      *
      ** SWIFT Priority Charge.
      *
     C                   Z-ADD     *ZERO         W7SPCD
     C                   Z-ADD     *ZERO         W7SPCH
      *
      ** Miscellaneous Charge.
      *
     C                   Z-ADD     IPDUMA6       W7MSCD
     C                   Z-ADD     IPMSCH        W7MSCH
      *
      ** FX/Change Commission.
      *
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     IPINDUM7      W7CHCD
     C                   Z-ADD     IPINCHCM      W7CHCM
     C                   ENDIF
      *
      ** Advice Charge.
      *
     C                   Z-ADD     IPDUMA4       W7ADCD
     C                   Z-ADD     IPADCH        W7ADCH
      *
      ** Telephone Charge.
      *
     C                   Z-ADD     IPDUMA5       W7TLCD
     C                   Z-ADD     IPTLCH        W7TLCH
      *
      ** Collection Charge.
      *
     C                   Z-ADD     *ZERO         W7COLD
     C                   Z-ADD     *ZERO         W7COLL
      *
      ** Other Currency.
      *
     C                   SELECT
      *
     C*****IPCDRO        WHENNE    *ZEROS                                                     187056
     C     DDCDRO        WHENNE    *BLANKS                                                    187056
     C     IPSMCY        ANDNE     IPPCCY
     C                   MOVE      '***'         W7OCCY
      *
     C*****IPCDRO        WHENNE    *ZEROS                                                     187056
     C     DDCDRO        WHENNE    *BLANKS                                                    187056
     C     IPSMCY        ANDEQ     IPPCCY
     C                   MOVE      W7PCCY        W7OCCY
      *
     C     IPADDC        WHENEQ    'D'
     C                   MOVE      IPSMCY        W7OCCY
      *
     C     IPADDC        WHENEQ    'A'
     C                   MOVE      IPPCCY        W7OCCY
      *
     C                   ENDSL
      *
      ** If core feature S01508 is installed, set up parameters for
      ** FT0035 to get the "Charges to the Debit of" Customer.
      *
     C                   MOVE      *BLANKS       W7CUST
      *
     C     S01508        IFEQ      'Y'
      *
     C                   CLEAR                   P0DTA
      *
     C                   SELECT
      *
     C     S01506        WHENEQ    'Y'
     C                   MOVE      IPBNCT        WIPT1
     C                   MOVE      IPBNC1        WIPTY1
      *                                                                                       209726
     C     IPBNCT        IFEQ      'S'                                                        209726
     C                   MOVE      IPBNCT        WIPT2                                        209726
     C                   MOVE      IPBNC2        WIPTY2                                       209726
     C                   ENDIF                                                                209726
      *                                                                                       209726
     C                   MOVE      IPPCCY        WICCY
      *
     C*****IPCDRT        WHENNE    *BLANKS                                                    187056
     C**********         MOVE      IPCDRT        WIPT1                                        187056
     C**********         MOVEL     IPCDRO        W0FLD                                        187056
     C*****W0FLD         CAT(P)    IPCDBR        WIPTY1                                       187056
     C     CDRT          WHENNE    *BLANKS                                                    187056
     C                   MOVE      CDRT          WIPT1                                        187056
     C     DDCDRO        CAT(P)    DDCDBR        WIPTY1                                       187056
      *                                                                                       CFT120
     C                   IF        DDCDRC = *BLANKS AND CFT120 = 'Y' OR                       CFT120
     C                             CFT120 = 'N'                                               CFT120
     C                   MOVE      BJCYCD        WICCY
     C                   ELSE                                                                 CFT120
     C                   EVAL      WICCY = DDCDRC                                             CFT120
     C                   ENDIF                                                                CFT120
      *
     C     IPADDC        WHENEQ    'A'
      *                                                                         CFT014
     C                   SELECT                                                 CFT014
      *                                                                         CFT014
      ** Third Reimbursement takes precedence over Receiver's C. and Sender     CFT014
     C     I2INTRIT      WHENEQ    'I'                                          CFT014
     C     CFT014        ANDEQ     'Y'                                          CFT014
     C     CFT004        ANDEQ     'Y'                                          CFT014
     C                   EVAL      PIBAN = I2INTRIB                             CFT014
     C                   EXSR      SRIBAN                                       CFT014
     C                   EVAL      WGLCNUM = ABCNUM                             CFT014
     C                   EVAL      WGLCCY  = ABCCY                              CFT014
     C                   EVAL      WGLACOD = ABACOD                             CFT014
     C                   EVAL      WGLACSQ = ABACSQ                             CFT014
     C                   EVAL      WGLBRCA = ABBRCA                             CFT014
     C                   EVAL      WICCY = IPSMCY                               CFT014
     C                   EVAL      WIPT2  = 'G'                                 CFT014
     C                   EVAL      WIPTY2 = WGLACC                              CFT014
      *                                                                         CFT014
     C     I2INTRIT      WHENNE    *BLANKS                                      CFT014
     C     CFT014        ANDEQ     'Y'                                          CFT014
     C                   EVAL      WICCY = SMCY                                 CFT014
     C                   EVAL      WIPT2  = I2INTRIT                            CFT014
     C                   EVAL      WIPTY2 = I2INTRIB                            CFT014
      *                                                                         CFT014
     C     IPINRCRT      WHENEQ    'I'                                          CFT014
     C     CFT004        ANDEQ     'Y'                                          CFT014
     C                   EVAL      PIBAN = IPINRCO1                             CFT014
     C                   EXSR      SRIBAN                                       CFT014
     C                   EVAL      WGLCNUM = ABCNUM                             CFT014
     C                   EVAL      WGLCCY  = ABCCY                              CFT014
     C                   EVAL      WGLACOD = ABACOD                             CFT014
     C                   EVAL      WGLACSQ = ABACSQ                             CFT014
     C                   EVAL      WGLBRCA = ABBRCA                             CFT014
     C                   EVAL      WICCY = IPSMCY                               CFT014
     C                   EVAL      WIPT2  = 'G'                                 CFT014
     C                   EVAL      WIPTY2 = WGLACC                              CFT014
      *                                                                         CFT014
     C                   OTHER                                                  CFT014
      *                                                                         CFT014
     C                   MOVE      IPSNTP        WIPT1
     C                   MOVE      IPSND1        WIPTY1
     C                   MOVE      IPSMCY        WICCY
     C*****              MOVE      IPRCRT        WIPT2                          CFT014
     C*****IPRCCO        IFNE      *ZERO                                        CFT014
     C*****              MOVEL     IPRCCO        WIPTY2                         CFT014
     C                   MOVE      IPINRCRT      WIPT2                          CFT014
     C     IPINRCO1      IFNE      *ZERO                                        CFT014
     C                   MOVEL     IPINRCO1      WIPTY2                         CFT014
     C                   ENDIF
      *                                                                         CFT014
     C                   ENDSL                                                  CFT014
      *
     C     IPADDC        WHENEQ    'D'
     C                   MOVE      IPBNCT        WIPT1
     C                   MOVE      IPBNC1        WIPTY1
     C                   MOVE      IPPCCY        WICCY
     C                   MOVE      IPACBT        WIPT2
     C     IPACBK        CAT(P)    IPACBB        WIPTY2
      *
     C                   ENDSL
      *
      ** Call FT0035 to get customer number to be debited the charges.
      *
     C                   CALL      'FT0035'                             9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    P0DTA
     C                   PARM                    P0MSG
      *
     C     *IN90         IFEQ      *ON
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0035'      DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      WOCUST        W7CUST
      *
     C                   ENDIF
      *
      ** Set up EMU fields for default calculations.
      *
      ** Settle Value Date.
      *
     C                   Z-ADD     IPSLDT        W7SLDT
      *
      ** Pay Value Date.
      *
     C                   Z-ADD     IPPVDT        W7PVDT
      *
      ** Add/Deduct Indicator.
      *
     C                   MOVEL     IPADDC        W7ADDC
      *
      ** Call defaults program FT0320.
      *
     C                   CALL      'FT0320'                             9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    P7ACT
     C                   PARM                    P7DATA
      *
     C     *IN90         IFEQ      *ON
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0320'      DBFILE
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Transfer Commission Amount.
      *
     C                   Z-ADD     W7TRCD        IPDUMA1
     C                   Z-ADD     W7TRCH        IPTRCM
      *
      ** Telex Charge.
      *
     C                   Z-ADD     W7TXCD        IPDUMA2
     C                   Z-ADD     W7TXCH        IPTXCH
      *
      ** Cheque Charge.
      *
     C                   Z-ADD     W7CQCD        IPDUMA3
     C                   Z-ADD     W7CQCH        IPCQCH
      *
      ** Advice Charge.
      *
     C                   Z-ADD     W7ADCD        IPDUMA4
     C                   Z-ADD     W7ADCH        IPADCH
      *
      ** Telephone Charge.
      *
     C                   Z-ADD     W7TLCD        IPDUMA5
     C                   Z-ADD     W7TLCH        IPTLCH
      *
      ** Miscellaneous Charge
      *
     C                   Z-ADD     W7MSCD        IPDUMA6
     C                   Z-ADD     W7MSCH        IPMSCH
      *
      ** Set up FX/Change Commission if BLI Funds Transfer
      ** Enhancement feature is on.
      *
     C     S01494        IFEQ      'Y'
     C                   Z-ADD     W7CHCD        IPINDUM7
     C                   Z-ADD     W7CHCM        IPINCHCM
     C                   ENDIF
      *
      ** Set Recalculation of VAT Amounts flag.
      *
     C                   MOVE      'Y'           WRCAL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDftOFlds - Default output fields                           *
      *                                                               *
      *****************************************************************
      *
     C     SRDftOFlds    BEGSR
      *
      ** If details of Charges is blank, default to 'BEN'.
      *
     C     DDDTCH        IFEQ      *BLANKS
     C     PMode         ANDEQ     '*SIN  '
     C     DDDTCH        OREQ      *BLANKS                                                    CAP084
     C     PSJobName     ANDEQ     'QZDASOINIT'                                               CAP084
     C     DDDTCH        OREQ      *BLANKS                                                    247277
     C     PSJobName     ANDEQ     'QSQSRVR'                                                  247277
     C     DDDTCH        OREQ      *BLANKS                                                 AR1088819
     C     PSJobName     ANDEQ     'QZDASSINIT'                                            AR1088819
     C     DDDTCH        OREQ      *BLANKS                                                    260709
     C     PSJobName     ANDEQ     'APISERVER '                                               260709
      *                                                                                       247277
      ** If CFT014 is installed, retrieve the default value from the                          219241
      ** Message Management ICD                                                               219241
                                                                                              219241
     C                   IF        CFT014 = 'Y'                                               219241
     C                   EVAL      DDDTCH = ENDCHG                                            219241
     C                   ELSE                                                                 219241
     C                   MOVEL     'BEN'         DDDTCH
     C                   ENDIF                                                                219241
                                                                                              219241
     C/COPY WNCPYSRC,FTIPA3DTC1
     C                   ENDIF
      *
      ***Default*Outward*Payment*Indicator*if*Action*is*Insert.********         CFT014
      *****************************************************************         CFT014
     C*****DDACTN        IFEQ      'I'                                          CFT014
     C*****PMode         ANDEQ     '*SIN  '                                     CFT014
     C*****DDACTN        OREQ      'A'                                          CFT014
     C*****INLVL2        ANDNE     'Y'                                          CFT014
     C*****PMode         ANDEQ     '*SIN  '                                     CFT014
     C*****              EVAL      DDOPIN = 'N'                                 CFT014
     C*****              ENDIF                                                  CFT014
      *
      ** Set up default Charge Currencies.
      *
     C                   MOVEL     PICCY         DDCCY1
     C                   MOVEL     PICCY         DDCCY2
     C                   MOVEL     PICCY         DDCCY3
     C                   MOVEL     PICCY         DDCCY4
     C                   MOVEL     PICCY         DDCCY5
     C                   MOVEL     PICCY         DDCCY6
      *
     C                   MOVEL     POCCY         DDRCY1
     C                   MOVEL     POCCY         DDRCY2
     C                   MOVEL     POCCY         DDRCY3
     C                   MOVEL     POCCY         DDRCY4
     C                   MOVEL     POCCY         DDRCY5
     C                   MOVEL     POCCY         DDRCY6
      *
      ** Default FX/Commission Charge Currencies if BLI Funds
      ** Funds Enhancement feature is on.
      *
     C     S01494        IFEQ      'Y'
     C                   MOVEL     PICCY         DDCCY7
     C                   MOVEL     POCCY         DDRCY7
     C                   ENDIF
      *
      ** Default VAT Charge Currencies if BLI VAT Processing
      ** feature is on.
      *
     C     S01499        IFEQ      'Y'
     C                   MOVEL     PICCY         DDCCY8
     C                   MOVEL     POCCY         DDRCY8
     C                   ENDIF
      *
      ** Get Input Currency decimal places.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      PICCY         PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     PICCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     A6NBDP        PINBDP
     C                   MOVEL     A6INCY        PIINCY
     C                   Z-ADD     A6TPSD        PITPSD
      *                                                                                      BUG4141
      ** For Midasplus to avoid user entered charges being overwritten by default            BUG4141
      ** charges, we must only default the first time the user goes into charges 2 tab       BUG4141
      ** We cannot get around this because we cannot keep previous screen values to          BUG4141
      ** compare against unlike in green screen midas                                        BUG4141
      *                                                                                      BUG4141
     C                   Eval      NoDft = 'N'                                               BUG4141
     C     DDACTN        IFEQ      'I'                                                       BUG4141
     C     PSJobName     ANDEQ     'QZDASOINIT'                                              BUG4141
     C     DDACTN        OREQ      'I'                                                        247277
     C     PSJobName     ANDEQ     'QSQSRVR'                                                  247277
     C     DDACTN        OREQ      'I'                                                     AR1088819
     C     PSJobName     ANDEQ     'QZDASSINIT'                                            AR1088819
     C     DDACTN        OREQ      'I'                                                        260709
     C     PSJobName     ANDEQ     'APISERVER '                                               260709
     C     DDACTN        OREQ      'A'                                                       BUG4329
      *                                                                                      BUG4141
     C     DDTRCD        IFNE      *BLANKS                                                   BUG4141
     C     DDCHCD        ORNE      *BLANKS                                                   BUG4141
     C     DDTXCD        ORNE      *BLANKS                                                   BUG4141
     C     DDCQCD        ORNE      *BLANKS                                                   BUG4141
     C     DDADCD        ORNE      *BLANKS                                                   BUG4141
     C     DDTLCD        ORNE      *BLANKS                                                   BUG4141
     C     DDMSCD        ORNE      *BLANKS                                                   BUG4141
     C     DDACTN        OREQ      'A'                                                       BUG4329
     C                   Eval      NoDft = 'Y'                                               BUG4141
     C                   ENDIF                                                               BUG4141
     C                   ENDIF                                                               BUG4141
      *                                                                                      BUG4141
      *
      ** Do defaulting of Charges and Commission input
      ** fields if module was called from *SIN.
      ** Or called from Midas Plus Interface                                                  CAP084
      *
     C     PMode         IFEQ      '*SIN  '
     C     PSJobName     OREQ      'QZDASOINIT'                                               CAP084
     C     NoDft         ANDNE     'Y'                                                      MD034828
     C     PSJobName     OREQ      'QZDASSINIT'                                            AR1088819
     C     NoDft         ANDNE     'Y'                                                      MD055030
     C     PSJobName     OREQ      'QSQSRVR'                                                  247277
     C     NoDft         ANDNE     'Y'                                                       BUG4141
     C     PSJobName     OREQ      'APISERVER '                                               260709
     C     NoDft         ANDNE     'Y'                                                        260709
      *
      ** Transfer Commission.
      *
     C     DDTRCD        IFEQ      *BLANKS                                                    CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     PRecalc       ORNE      'Y'                                                        CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     CFT120        OREQ      'N'                                                        CFT120
     C     IPDUMA1       IFNE      *ZERO
     C                   Z-ADD     IPDUMA1       PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDTRCD
     C                   ELSE
     C                   MOVE      *BLANKS       DDTRCD
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVE      *ZEROS        DUMA1                                        CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF
     C                   ENDIF                                                                CFT120
      *
      ** Telex Charge.
      *
     C     DDTXCD        IFEQ      *BLANKS                                                    CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     PRecalc       ORNE      'Y'                                                        CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     CFT120        OREQ      'N'                                                        CFT120
     C     IPDUMA2       IFNE      *ZERO
     C                   Z-ADD     IPDUMA2       PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDTXCD
     C                   ELSE
     C                   MOVE      *BLANKS       DDTXCD
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVE      *ZEROS        DUMA2                                        CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF
     C                   ENDIF                                                                CFT120
      *
      ** Cheque Charge.
      *
     C     DDCQCD        IFEQ      *BLANKS                                                    CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     PRecalc       ORNE      'Y'                                                        CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     CFT120        OREQ      'N'                                                        CFT120
     C     IPDUMA3       IFNE      *ZERO
     C                   Z-ADD     IPDUMA3       PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDCQCD
     C                   ELSE
     C                   MOVE      *BLANKS       DDCQCD
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVE      *ZEROS        DUMA3                                        CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF
     C                   ENDIF                                                                CFT120
      *
      ** Advice Charge.
      *
     C     DDADCD        IFEQ      *BLANKS                                                    CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     PRecalc       ORNE      'Y'                                                        CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     CFT120        OREQ      'N'                                                        CFT120
     C     IPDUMA4       IFNE      *ZERO
     C                   Z-ADD     IPDUMA4       PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDADCD
     C                   ELSE
     C                   MOVE      *BLANKS       DDADCD
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVE      *ZEROS        DUMA4                                        CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF
     C                   ENDIF                                                                CFT120
      *
      ** Telephone Charge.
      *
     C     DDTLCD        IFEQ      *BLANKS                                                    CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     PRecalc       ORNE      'Y'                                                        CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     CFT120        OREQ      'N'                                                        CFT120
     C     IPDUMA5       IFNE      *ZERO
     C                   Z-ADD     IPDUMA5       PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDTLCD
     C                   ELSE
     C                   MOVE      *BLANKS       DDTLCD
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVE      *ZEROS        DUMA5                                        CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF
     C                   ENDIF                                                                CFT120
      *
      ** Miscellaneous Charge.
      *
     C     DDMSCD        IFEQ      *BLANKS                                                    CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     PRecalc       ORNE      'Y'                                                        CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     CFT120        OREQ      'N'                                                        CFT120
     C     IPDUMA6       IFNE      *ZERO
     C                   Z-ADD     IPDUMA6       PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDMSCD
     C                   ELSE
     C                   MOVE      *BLANKS       DDMSCD
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVE      *ZEROS        DUMA6                                        CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF
     C                   ENDIF                                                                CFT120
      *
      ** FX/Change Commission.
      *
     C     S01494        IFEQ      'Y'
     C     IPINDUM7      IFNE      *ZERO
     C                   Z-ADD     IPINDUM7      PFMTIN
     C                   Z-ADD     A6NBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDCHCD
     C                   ELSE
     C                   MOVE      *BLANKS       DDCHCD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Get Output Currency decimal places.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      POCCY         PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     A6NBDP        PONBDP
     C                   MOVEL     A6INCY        POINCY
      *
      ** Transfer Commission Amount (Charges Currency).
      *
     C     IPTRCM        IFNE      *ZERO
     C                   Z-ADD     IPTRCM        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDTRCM
     C                   ELSE
     C                   MOVE      *BLANKS       DDTRCM
     C                   ENDIF
      *
      ** Telex Charge (Charges Currency).
      *
     C     IPTXCH        IFNE      *ZERO
     C                   Z-ADD     IPTXCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDTXCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDTXCH
     C                   ENDIF
      *
      ** Cheque Charge (Charges Currency).
      *
     C     IPCQCH        IFNE      *ZERO
     C                   Z-ADD     IPCQCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDCQCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDCQCH
     C                   ENDIF
      *
      ** Advice Charge (Charges Currency).
      *
     C     IPADCH        IFNE      *ZERO
     C                   Z-ADD     IPADCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDADCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDADCH
     C                   ENDIF
      *
      ** Telephone Charge (Charges Currency).
      *
     C     IPTLCH        IFNE      *ZERO
     C                   Z-ADD     IPTLCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDTLCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDTLCH
     C                   ENDIF
      *
      ** Miscellaneous Charge (Charges Currency).
      *
     C     IPMSCH        IFNE      *ZERO
     C                   Z-ADD     IPMSCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDMSCH
     C                   ELSE
     C                   MOVE      *BLANKS       DDMSCH
     C                   ENDIF
      *
      ** Set up FX/Change Commission if BLI Funds Transfer
      ** Enhancement feature is on.
      *
     C     S01494        IFEQ      'Y'
     C     IPINCHCM      IFNE      *ZERO
     C                   Z-ADD     IPINCHCM      PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDCHCM
     C                   ELSE
     C                   MOVE      *BLANKS       DDCHCM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDftVat - Default VAT Flags and VAT Amounts                 *
      *                                                               *
      *****************************************************************
      *
     C     SRDftVat      BEGSR
      *
     C     DDACTN        IFNE      'E'
     C     PMode         ANDEQ     '*SIN  '
     C     DDACTN        ORNE      'E'                                                        CAP084
     C     PSJobName     ANDEQ     'QZDASOINIT'                                               CAP084
     C     DDACTN        ORNE      'E'                                                        247277
     C     PSJobName     ANDEQ     'QSQSRVR'                                                  247277
     C     DDACTN        ORNE      'E'                                                     AR1088819
     C     PSJobName     ANDEQ     'QZDASSINIT'                                            AR1088819
     C     DDACTN        ORNE      'E'                                                        260709
     C     PSJobName     ANDEQ     'APISERVER '                                               260709
      *
      ** Transfer Commission VAT flag.
      *
     C     DDVAT1        IFEQ      *BLANK
     C                   EVAL      DDVAT1 = PVATT
     C                   ENDIF
      *
      ** Telex VAT flag.
      *
     C     DDVAT2        IFEQ      *BLANK
     C                   EVAL      DDVAT2 = PVATT
     C                   ENDIF
      *
      ** Cheque VAT flag.
      *
     C     DDVAT3        IFEQ      *BLANK
     C                   EVAL      DDVAT3 = PVATT
     C                   ENDIF
      *
      ** Advice VAT flag.
      *
     C     DDVAT4        IFEQ      *BLANK
     C                   EVAL      DDVAT4 = PVATT
     C                   ENDIF
      *
      ** Telephone VAT flag.
      *
     C     DDVAT5        IFEQ      *BLANK
     C                   EVAL      DDVAT5 = PVATT
     C                   ENDIF
      *
      ** Miscellaneous VAT flag.
      *
     C     DDVAT6        IFEQ      *BLANK
     C                   EVAL      DDVAT6 = PVATT
     C                   ENDIF
      *
      ** Default FX/Change Commission VAT flag if BLI Funds
      ** Transfer Enhancement feature is on.
      *
     C     S01494        IFEQ      'Y'
     C     DDVAT7        ANDEQ     *BLANK
     C                   EVAL      DDVAT7 = PVATT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WRCAL         IFEQ      'Y'
      *
     C                   Z-ADD     *ZERO         IPINDUM8
     C                   Z-ADD     *ZERO         IPINVATT
      *
      ** If apply VAT flag is 'Y', calculate VAT Charge.
      *
      ** Transfer Commission.
      *
     C     INVAT1        IFEQ      'Y'
     C     IPDUMA1       MULT(H)   PVATR         WVATD            13 0
     C     IPTRCM        MULT(H)   PVATR         WVATT            13 0
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Telex Charge.
      *
     C     INVAT2        IFEQ      'Y'
     C     IPDUMA2       MULT(H)   PVATR         WVATD
     C     IPTXCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Cheque Charge.
      *
     C     INVAT3        IFEQ      'Y'
     C     IPDUMA3       MULT(H)   PVATR         WVATD
     C     IPCQCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Advice Charge.
      *
     C     INVAT4        IFEQ      'Y'
     C     IPDUMA4       MULT(H)   PVATR         WVATD
     C     IPADCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Telephone Charge.
      *
     C     INVAT5        IFEQ      'Y'
     C     IPDUMA5       MULT(H)   PVATR         WVATD
     C     IPTLCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** Miscellaneous Charge.
      *
     C     INVAT6        IFEQ      'Y'
     C     IPDUMA6       MULT(H)   PVATR         WVATD
     C     IPMSCH        MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
      ** FX/Change Commission.
      *
     C     S01494        IFEQ      'Y'
     C     INVAT7        IFEQ      'Y'
     C     IPINDUM7      MULT(H)   PVATR         WVATD
     C     IPINCHCM      MULT(H)   PVATR         WVATT
     C                   ADD       WVATD         IPINDUM8
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Format Total VAT Amount (Input Currency).
      *
     C     IPINDUM8      IFNE      *ZERO
     C                   Z-ADD     IPINDUM8      PFMTIN
     C                   Z-ADD     PINBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDVATD
     C                   ELSE
     C                   MOVE      *BLANKS       DDVATD
     C                   ENDIF
      *
      ** Format Total VAT Amount (Charges Currency).
      *
     C     IPINVATT      IFNE      *ZERO
     C                   Z-ADD     IPINVATT      PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C                   MOVE      PFMTOUT       DDVATT
     C                   ELSE
     C                   MOVE      *BLANKS       DDVATT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format Amount For Display                         *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtAmt      BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        PRETC            10
     C                   PARM                    PFMTIN           13 0
     C                   PARM                    PFMDEC            1 0
     C                   PARM      '.'           PCCYSEP           1
     C                   PARM      *BLANK        PFMTOUT          14
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRIBAN   - Retrieves the full account number of an IBAN acc. *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
     C     SRIBAN        BEGSR                                                  CFT014
      *                                                                         CFT014
     C                   CALL      'AOIBANR4'                                   CFT014
     C                   PARM      *BLANKS       @RTCD                          CFT014
     C                   PARM      '*KEY   '     @OPTN                          CFT014
     C                   PARM                    PIBAN            34            CFT014
     C     WACCDS        PARM      *BLANKS       DSSDY                          CFT014
     C     @RTCD         IFNE      *BLANKS                                      CFT014
     C                   MOVEL     '*CALL   '    DBKEY                          CFT014
     C                   MOVEL     'AOIBANR4'    DBFILE                         CFT014
     C                   Z-ADD     7             DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP5ScnFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments (additional info) for file update                    CFT014
      ** - file format                                                          CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *
      ** Payment Type
     C                   PARM                    PPYTP             2
      *
      ** Charges Branch
     C                   PARM                    PPYBR             3
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *                                                                                       187056
      ** Previous values of 'Charges to the Debit of a/c'                                     187056
      *                                                                                       187056
     C                   PARM                    PPrvCDRT          1                          187056
     C**********         PARM                    PPrvCDRO         12                   187056 CGL029
     C                   PARM                    PPrvCDRO                                     CGL029
     C                   PARM                    PPrvCDBR          3                          187056
     C                   PARM                    PPrvCDRC                                     CFT120
      *                                                                                       187056
      ** Recalcution flag.                                                                    187056
      *                                                                                       187056
     C                   PARM                    PReCalc           1                          187056
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY            3
      *
      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY            1
      *
      ** VAT Default Flag
     C                   PARM                    PVATT             1
      *
      ** VAT Rate
     C                   PARM                    PVATR             5 4
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *
      ** BLI Payment Charges Enhancements
     C                   PARM                    S01506            1
      *
      ** BLI Extended Payment Charges
     C                   PARM                    S01508            1
      *                                                                         CFT014
      ** FT Batch Authorization and Credit Advices                              CFT014
     C                   PARM                    CFT004            1            CFT014
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014            1            CFT014
      *                                                                                       CFT120
      ** FT IN/OP - Charges on DR of Account Ccy                                              CFT120
      *                                                                                       CFT120
     C                   PARM                    CFT120                                       CFT120
      *
      ** OUTPUT
      ** ======
      *
      ** Input Charge Currency
     C                   PARM                    PICCY             3
      *
      ** Input Charge Currency In Currency Flag
     C                   PARM                    PIINCY            1
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP            1 0
      *
      ** Input Charge Currency EMU Transmission Period Start Date
     C                   PARM                    PITPSD            5 0
      *
      ** Output Charge Currency
     C                   PARM                    POCCY             3
      *
      ** Output Charge Currency In Currency Flag
     C                   PARM                    POINCY            1
      *
      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP            1 0
      *
      ** DS for Default Charge Amounts
     C                   PARM                    PCharges
      *
      ** DS for Default Charge Currencies
     C                   PARM                    PChgCcy
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
