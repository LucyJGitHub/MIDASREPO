     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities screen 2 defaulting')              *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS2DT - Securities Screen 2 Defaulting                   *
      *                                                               *
      *  Function: This module defaults Security fields from          *
      *            second screen.                                     *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 248756             Date 27Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11507           Date 16Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 209476             Date 16Sep02               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 14Nov01               *
      *                 CSE032             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE029             Date 20Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248756 - Default Fixing Days and Auto Fix only if fields are *
      *           left blanks.                                        *
      *  BUG11507 - A serious midasplus error has occurred            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  209476 - Default maturity indicator to 'F' for processing    *
      *           type 9.                                             *
      *  CSE037 - Countervalue rounding                               *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSE032 - Default Yield basis according to CSE032 feature.    *
      *           Only default on insert action.                      *
      *  CSE029 - ISO15022 Message Generation (recompile)             *
      *  CSD006 - Market Data Feed (recompile)                        *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security Market Centres.
     FSEMKC     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F2)
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities screen 1 details retrieved from file - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities screen 2 details retrieved from file - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Investment type details
     D PINVTPD       E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(F1)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *                                                                                       CSE031
      ** Externally described DS for bank details                                             CSE031
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CSE031
      *                                                                                       CSE031
      ** DS for access programs - short data structure                                        CSE031
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSE031
      *
      ** DS for Access Objects - Very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** Passed other information
     D POthInf         DS
     D  WSRPN                  1     20
     D  WSFN1                 21     50
     D  WSFN2                 51     80
     D  WT2RF                 81     92
     D  WISNO                 93    104
     D  WCSPN                105    113
     D  WSREF                114    120
     D  WSRE1                121    132
     D  WSRE2                133    144
     D  WSRE3                145    156
      *
      ** DS of fields for output only
     D POutFlds        DS
     D  WCSNM1                       10A
     D  WCSNM2                       10A
     D  WCSNM3                       10A
     D  WMKTN                        20A
     D  WSTBS                         1A
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter list for AOCUSTR1
     D PKeyC           S             10A
     D PKySt           S              7A
     D PRtCd           S              7A
     D POptn           S              7A
     D BGRKMG          S              1A
      *                                                                                       CSE031
      ** Switchable Features                                                                  CSE031
     D CSE031          S              1A                                                      CSE031
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
      *                                                                                       CSE032
      **  Determine if feature CSE032 is installed.                                           CSE032
      *                                                                                       CSE032
     C                   MOVE      'N'           CSE032            1                          CSE032
                                                                                              CSE032
     C                   CALLB     'AOSARDR0'                                                 CSE032
     C                   PARM      *BLANKS       @RTCD                                        CSE032
     C                   PARM      '*VERIFY'     @OPTN                                        CSE032
     C                   PARM      'CSE032'      @SARD                                        CSE032
      *                                                                                       CSE032
      ** Database error                                                                       CSE032
      *                                                                                       CSE032
     C     @RTCD         IFNE      *BLANKS                                                    CSE032
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE032
     C                   MOVEL     'CSE032'      DBKEY                                        CSE032
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************  CSE032
     C                   MOVEL     '901'         DBASE                          * DBERR 901*  CSE032
     C                   EXSR      *PSSR                                        ************  CSE032
     C                   ELSE                                                                 CSE032
     C     @RTCD         IFEQ      *BLANKS                                                    CSE032
     C                   MOVE      'Y'           CSE032                                       CSE032
     C                   END                                                                  CSE032
     C                   END                                                                  CSE032
      *
      ** Default second screen fields.
      *
     C                   EXSR      SRDefault
      *
      ** Return.
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault - Default second screen fields                     *
      *                                                               *
      *****************************************************************
 
     C     SRDefault     BEGSR
 
      *
      ** SAR CSE031 switched ON and processing type is 3 or 8.                                CSE031
     C                   IF        CSE031 = 'Y' AND DDACTN = 'I'                              CSE031
     C                   IF        F1PROT = '3' OR F1PROT = '8'                               CSE031
      *                                                                                       CSE031
      ** Fixing Days.                                                                         CSE031
      *                                                                                       CSE031
      ** Default the Fixing Days to 2 if the Value Currency is not                            CSE031
      ** equal to the Local Currency.                                                         CSE031
      *                                                                                       CSE031
     C                   IF        DDFIXD = *Blank                                            248756
     C                   IF        DDVLCY = BJLCCY                                            CSE031
     C                   EVAL      DDFIXD = '0'                                               CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      DDFIXD = '2'                                               CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                248756
      *                                                                                       CSE031
      ** Auto Fix.                                                                            CSE031
      *                                                                                       CSE031
      ** Default the Auto Fix to 'Y' if the Investment Type has a                             CSE031
      ** Processing Type of '3' or '8'.                                                       CSE031
      *                                                                                       CSE031
     C                   IF        DDAUFX = *Blank                                            248756
     C                   EVAL      DDAUFX = 'Y'                                               CSE031
     C                   ENDIF                                                                248756
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                CSE031
      *
      ** Depot security reference 1.
      *
     C                   IF        DDDASR = *BLANKS
     C                   SELECT
     C                   WHEN      DDACTN = 'I' AND WSRE1 <> *BLANKS
     C                   EVAL      DDDASR = WSRE1
     C                   WHEN      F1STC1 = 'S'
     C                   EVAL      DDDASR = DDSREF
     C                   WHEN      F1STC1 = 'T'
     C                   EVAL      DDDASR = DDT2RF
     C                   WHEN      F1STC1 = 'C'
     C                   EVAL      DDDASR = DDCSPN
     C                   ENDSL
     C                   ENDIF
      *
      ** Depot security reference 2.
      *
     C                   IF        DDDCSR = *BLANKS
     C                   SELECT
     C                   WHEN      DDACTN = 'I' AND WSRE2 <> *BLANKS
     C                   EVAL      DDDCSR = WSRE2
     C                   WHEN      F1STC2 = 'S'
     C                   EVAL      DDDCSR = DDSREF
     C                   WHEN      F1STC2 = 'T'
     C                   EVAL      DDDCSR = DDT2RF
     C                   WHEN      F1STC2 = 'C'
     C                   EVAL      DDDCSR = DDCSPN
     C                   ENDSL
     C                   ENDIF
      *
      ** Depot security reference 3.
      *
     C                   IF        DDDDSR = *BLANKS
     C                   SELECT
     C                   WHEN      DDACTN = 'I' AND WSRE3 <> *BLANKS
     C                   EVAL      DDDDSR = WSRE3
     C                   WHEN      F1STC3 = 'S'
     C                   EVAL      DDDDSR = DDSREF
     C                   WHEN      F1STC3 = 'T'
     C                   EVAL      DDDDSR = DDT2RF
     C                   WHEN      F1STC3 = 'C'
     C                   EVAL      DDDDSR = DDCSPN
     C                   ENDSL
     C                   ENDIF
      *
      ** Market centre, default from Investment type.
      *
     C                   IF        DDSMCC = *BLANKS
     C                   EVAL      DDSMCC = F1DMKT
     C                   ENDIF
      *
      ** Convertible indicator, default from Investment type.
      *
     C                   IF        DDSCVI = *BLANKS
     C                   EVAL      DDSCVI = F1CNVI
     C                   ENDIF
      *
      ** Price basis, default from Investment type.
      *
     C                   IF        DDSPBS = *BLANKS
     C                   EVAL      DDSPBS = F1PRBS
     C                   ENDIF
      *
      ** Trade Basis, default from Investment type if not overriden.
      *
     C                   IF        DDTBOR <> *BLANKS
     C                   EVAL      WSTBS = DDTBOR
     C                   ELSE
     C                   IF        STBS <> *BLANKS AND
     C                             DDACTN <> 'I'
     C                   EVAL      WSTBS = STBS
     C                   ELSE
     C                   EVAL      WSTBS = F1TRBS
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      S1STBS = WSTBS
      *
      ** Yield Basis, default from Investment type.
      *
     C                   IF        DDACTN = 'I'                                               CSE032
     C                   IF        DDSYBS =  *BLANKS AND WSTBS = 'Y'
     C                   EVAL      DDSYBS = F1YDBS
     C                   ENDIF
      *                                                                                       CSE032
      ** Price basis not available, but blank should be defaulted if Price Basis not 'P'.     CSE032
      *                                                                                       CSE032
     C                   IF        CSE032 = 'Y'                                               CSE032
     C                   IF        DDSYBS =  *BLANKS AND WSTBS = 'P'                          CSE032
     C                   EVAL      DDSYBS = F1YDBS                                            CSE032
     C                   ENDIF                                                                CSE032
     C                   ENDIF                                                                CSE032
     C                   ENDIF                                                                CSE032
 
      *
      ** Set up defaults for Australian yield basis.
      *
     C                   IF        DDSYBS = 'AU'
      *
      ** Compounding frequency, default from Investment type.
     C                   IF        DDCMFQ = *BLANKS
     C                   MOVEL     F1DCMF        DDCMFQ
     C                   ENDIF
      *
      ** Discount basis, default from Investment type.
     C                   IF        DDDSCB =  *BLANKS
     C                   EVAL      DDDSCB = F1DDSB
     C                   ENDIF
      *
      ** Discount last coupon, default from Investment type.
     C                   IF        DDDSLC =  *BLANKS
     C                   EVAL      DDDSLC = F1DDLS
     C                   ENDIF
 
     C                   ENDIF
 
      *
      ** Set up defaults for Discount security entries.
      *
     C                   IF        WSTBS = 'D' OR
     C                             (WSTBS = 'Y' AND F1PROT = '9')
      *
      ** Maturity date indicator.
     C                   IF        F1PROT = '9' AND DDMDTI1 = *BLANKS
     C**********         EVAL      DDMDTI1 = 'A'                                              209476
     C                   EVAL      DDMDTI1 = 'F'                                              209476
     C                   ENDIF
      *
      ** Day basis.
     C                   IF        DDDYBS1 = *BLANKS
     C                   EVAL      DDDYBS1 = F1DDYB
     C                   ENDIF
      *
      ** Divisor basis.
     C                   IF        DDDVBS1 = *BLANKS
     C                   EVAL      DDDVBS1 = F1DDVB
     C                   ENDIF
      *
      ** Contingent liability indicator.
     C                   IF        DDCNLI1 = *BLANKS
     C                   EVAL      DDCNLI1 = F1DCNL
     C                   ENDIF
      *
      ** Risk customer.
     C                   IF        F1PROT = '9' AND DDRSKC = *BLANKS
     C                   EVAL      DDRSKC = DDISSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Set up defaults for Interest security entries.
      *
     C                   IF        (WSTBS = 'P' AND F1PROT <> '2' AND
     C                             F1PROT <> '4' AND F1PROT <> '7') OR
     C                             (WSTBS = 'Y' AND F1PROT <> '2' AND
     C                             F1PROT <> '4' AND F1PROT <> '7' AND
     C                             F1PROT <> '9')
      *
      ** Maturity date indicator.
     C                   IF        F1PROT = '9' AND DDMDTI2 = *BLANKS
     C                   EVAL      DDMDTI2 = 'A'
     C                   ENDIF
      *
      ** Day basis.
     C                   IF        DDDYBS2 = *BLANKS
     C                   EVAL      DDDYBS2 = F1DDYB
     C                   ENDIF
      *
      ** Divisor basis.
     C                   IF        DDDVBS2 = *BLANKS
     C                   EVAL      DDDVBS2 = F1DDVB
     C                   ENDIF
      *
      ** Contingent liability indicator.
     C                   IF        DDCNLI2 = *BLANKS
     C                   EVAL      DDCNLI2 = F1DCNL
     C                   ENDIF
      *
      ** Risk customer.
     C                   IF        F1PROT = '9' AND DDRSKC = *BLANKS
     C                   EVAL      DDRSKC = DDISSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Roll forward dividend indicator.
      *
     C                   IF        BGRKMG = 'Y' AND
     C                             DDRFDI = *BLANK
     C                   EVAL      DDRFDI = 'N'
     C                   ENDIF
      *
      ** Settlement Depot Customers
     C**********         IF        F1SDC1 <> *ZEROS                                           CSD027
     C                   IF        F1SDC1 <> *BLANKS                                          CSD027
     C                               AND  F1SDC1 <> '000000'                                BUG11507
     C                   MOVEL     F1SDC1        PKeyC
     C                   EXSR      SRAOCUST
     C                   EVAL      WCSNM1 = BBCSSN
     C                   ELSE
     C                   EVAL      WCSNM1 = *BLANKS
     C                   ENDIF
 
     C**********         IF        F1SDC2 <> *ZEROS                                           CSD027
     C                   IF        F1SDC2 <> *BLANKS                                          CSD027
     C                                AND F1SDC2 <> '000000'                                BUG11507
     C                   MOVEL     F1SDC2        PKeyC
     C                   EXSR      SRAOCUST
     C                   EVAL      WCSNM2 = BBCSSN
     C                   ELSE
     C                   EVAL      WCSNM2 = *BLANKS
     C                   ENDIF
 
     C**********         IF        F1SDC3 <> *ZEROS                                           CSD027
     C                   IF        F1SDC3 <> *BLANKS                                          CSD027
     C                                AND F1SDC3 <> '000000'                                BUG11507
     C                   MOVEL     F1SDC3        PKeyC
     C                   EXSR      SRAOCUST
     C                   EVAL      WCSNM3 = BBCSSN
     C                   ELSE
     C                   EVAL      WCSNM3 = *BLANKS
     C                   ENDIF
      *
      ** Market name.
     C                   MOVE      *BLANKS       WMKTN
     C                   IF        DDSMCC <> *BLANK
     C     DDSMCC        CHAIN     SEMKCDF                            01
     C                   IF        *IN01 = *OFF
     C                   MOVE      F2MKTN        WMKTN
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSE037
      ** for Countervalue rounding (process regardless of switch)                             CSE037
      *                                                                                       CSE037
     C                   IF        DDACTN = 'I'                                               CSE037
      ** on insert default from the Investment Type                                           CSE037
     C                   MOVEL     F1NDEC        DDNDEC                                       CSE037
     C                   ELSE                                                                 CSE037
      ** use existing value                                                                   CSE037
     C                   MOVEL     NDEC          DDNDEC                                       CSE037
     C                   ENDIF                                                                CSE037
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOCust - Access customer details                           *
      *                                                               *
      *****************************************************************
     C     SRAOCust      BEGSR
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKeyC
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PKeyC
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Securities screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Passed other information coming from link program
     C                   PARM                    POthInf
      *
      ** Investment type details
     C                   PARM                    PINVTPD
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Risk Management
     C                   PARM                    BGRKMG
      *                                                                                       CSE031
      ** SWITCHABLE FEATURES                                                                  CSE031
      ** ===================                                                                  CSE031
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *
      ** OUTPUT
      ** ======
      *
      ** Securities screen 2 details retrieved from file - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Fields for display only
     C                   PARM                    POutFlds
                                                                                              CSE031
      *                                                                                       CSE031
      ** Access bank details.                                                                 CSE031
      *                                                                                       CSE031
     C                   CALLB     'AOBANKR0'                                                 CSE031
     C                   PARM      *BLANKS       PRtcd                                        CSE031
     C                   PARM      '*FIRST '     POptn                                        CSE031
     C     SDBANK        PARM      SDBANK        DSFDY                                        CSE031
      *                                                                                       CSE031
      ** Database error                                                                       CSE031
      *                                                                                       CSE031
     C                   IF        PRtcd <> *BLANKS                                           CSE031
     C                   EVAL      DBKey = POptn                                              CSE031
     C                   EVAL      DBFile = 'SDBANKPD'                                        CSE031
     C                   Z-ADD     2             DBase                                        CSE031
     C                   EXSR      *PSSR                                                      CSE031
     C                   ENDIF                                                                CSE031
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
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
      *
**  CPY@
(c) Finastra International Limited 2001
