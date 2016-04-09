     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV conversion file to screen format')       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDPMVCVT - DPMV Conversion: File to Screen Format           *
      *                                                               *
      *  Function:  This module converts the fields of a Depot        *
      *             Movement Transaction from thier format as on file *
      *             to a screen format.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG1046            Date 15Mar06               *
      *                 CAP087             Date 05Sep05               *
      *                 232543             Date 29Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 222727             Date 05Nov03               *
      *                 207006             Date 18Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187544             Date 11Dec00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      *                 CPB001             Date 23Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP003  *CREATE    Date 06May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10469 - Fees functionality missing from Bond Lending /    *
      *             Bond Borrowing input.                             *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  207006 - Add Counterparty & Market Centre to SSI             *
      *  187544 - Depot Mvts - WI & WO: Review display of some        *
      *           PM/PB fields                                        *
      *  CSE015 - Forward Valued Depot Movements                      *
      *  CSE017 - Cum/Ex Indicator on Depot Movements                 *
      *  CSE012 - SE Depot Movements Narratives                       *
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SEC_)
     FINVTP     IF   E           K DISK    INFSR(*PSSR)                         CPB001
     F                                     PREFIX(INV_)                         CPB001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      * Transaction - File Format
     D DPMVFilFmt    E DS                  EXTNAME(DPTMVD)
 
      * Trade - Screen Formats
     D DPMVScnFmt    E DS                  EXTNAME(SEDMWIPD)
     D DDDepot       E                     EXTFLD(DDDPID)
     D DDDate        E                     EXTFLD(DDDPMD)
 
 
      ** External DS for Bank Details
      ** External DS for Bank Details
      ** External DS for Midas Modules Details
      ** External DS for Portfolio Management Details
      ** External DS for Currency Details
      ** External DS for Switchable Feature Details
      ** Portfolio Customer Details Via Access Program
      ** Customer Details Via Access Program                                    CPB001
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D LCD_SAR       E                     EXTFLD(LCD)
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CPB001
 
     ** Scratch Pad DS
      ** Short Data Structure
      ** Long Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB001
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      ** Initialization
      *
     C                   EXSR      SRInit
      *
      ** Set Screen fields
      *
     C     DPMV          IFEQ      'WI'
     C     DPMV          OREQ      'WO'
     C     DPMV          OREQ      'RP'                                                       CAP087
     C     DPMV          OREQ      'RR'                                                       CAP087
     C     DPMV          OREQ      'BB'                                                       CAP087
     C     DPMV          OREQ      'BL'                                                       CAP087
     C     DPMV          OREQ      'PL'                                                       CAP087
     C     DPMV          OREQ      'PD'                                                       CAP087
     C     DPMV          OREQ      'DT'                                                       CAP087
     C                   EXSR      SRScreen1
     C                   END
      *
      ** Set up Transaction Status
      *
     C                   EXSR      SRTranSts
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScreen1 - Set Screen Fields for Walk-in/Walk Out Depot      *
      *             Movement Transaction.                             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRSecSts                                               *
      *        ZDate2                                                 *
      *        ZEdit                                                  *
      *        ZSEdit                                                 *
      *        SRCurrDet                                              *
      *                                                               *
      *****************************************************************
     C     SRScreen1     BEGSR
      *
      ** Security Shortname
      *
     C                   MOVEL     DPSS          DDDPSS
     C                   EXSR      SRSecSts
      *
      ** Transaction Reference
      *
     C                   MOVE      DPRN          DDDPRN
 
     C     DPMV          IFEQ      'WI'
      *
      ** In Depot
      *
     C                   MOVEL     DPID          DDDEPOT
      *
      ** In Date
      *
     C                   MOVE      *BLANKS       DDDATE
 
      * Compare should be 99999 (5 digits) instead of 999999 (6 digits)                       CAP087
     C*****DPMD          IFNE      999999                                                     CAP087
     C     DPMD          IFNE      99999                                                      CAP087
     C                   Z-ADD     DPMD          ZDAYNO
     C                   EXSR      ZDate2
     C                   MOVE      ZDATE         DDDATE
     C                   ELSE
     C                   MOVE      '999999'      DDDATE
     C                   END
 
     C                   END
 
     C     DPMV          IFEQ      'WO'
      *
      ** Out Depot
      *
     C                   MOVEL     DPOD          DDDEPOT
     C/COPY WNCPYSRC,SEDPMVNC01
      *
      ** Out Date
      *
     C                   MOVE      *BLANKS       DDDATE
 
      * Compare should be 99999 (5 digits) instead of 999999 (6 digits)                       CAP087
     C*****DPDO          IFNE      999999                                                     CAP087
     C     DPMD          IFNE      99999                                                      CAP087
     C                   Z-ADD     DPDO          ZDAYNO
     C                   EXSR      ZDate2
     C                   MOVE      ZDATE         DDDATE
     C                   ELSE
     C                   MOVE      '999999'      DDDATE
     C                   END
 
     C                   END
      *                                                                                       CAP087
      ** Repo and Depot Transfer                                                              CAP087
      *                                                                                       CAP087
     C     DPMV          IFEQ      'RP'                                                       CAP087
     C     DPMV          OREQ      'RR'                                                       CAP087
     C     DPMV          OREQ      'BB'                                                       CAP087
     C     DPMV          OREQ      'BL'                                                       CAP087
     C     DPMV          OREQ      'PL'                                                       CAP087
     C     DPMV          OREQ      'PD'                                                       CAP087
     C     DPMV          OREQ      'DT'                                                       CAP087
      *                                                                                       CAP087
      ** In Depot                                                                             CAP087
      *                                                                                       CAP087
     C                   MOVE      *BLANKS       DDDepot                                      CAP087
     C                   MOVEL     DPID          DDDepot                                      CAP087
      *                                                                                       CAP087
      ** In Date                                                                              CAP087
      *                                                                                       CAP087
     C                   MOVE      *BLANKS       DDDate                                       CAP087
      *                                                                                       CAP087
     C     DPMD          IFNE      99999                                                      CAP087
     C                   Z-ADD     DPMD          ZDAYNO                                       CAP087
     C                   EXSR      ZDate2                                                     CAP087
     C                   MOVE      ZDATE         DDDate                                       CAP087
     C                   ELSE                                                                 CAP087
     C                   MOVEL     '999999'      DDDate                                       CAP087
     C                   END                                                                  CAP087
      *                                                                                       CAP087
      ** Out Depot                                                                            CAP087
      *                                                                                       CAP087
     C                   MOVEL     DPOD          DDDPOD                                       CAP087
      *                                                                                       CAP087
      ** Out Date - should be blank for Depot Transfer type 'DT'                              CAP087
      *                                                                                       CAP087
     C                   MOVE      *BLANKS       DDDPDO                                       CAP087
     C     DPMV          IFNE      'DT'                                                       CAP087
     C     DPDO          IFNE      99999                                                      CAP087
     C                   Z-ADD     DPDO          ZDAYNO                                       CAP087
     C                   EXSR      ZDate2                                                     CAP087
     C                   MOVE      ZDATE         DDDPDO                                       CAP087
     C                   ELSE                                                                 CAP087
     C                   MOVEL     '999999'      DDDPDO                                       CAP087
     C                   ENDIF                                                                CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
      ** Associated Deal Number                                                               CAP087
      *                                                                                       CAP087
     C     DPAD          IFEQ      0                                                          CAP087
     C                   MOVEL     *BLANKS       DDDPAD                                       CAP087
     C                   ELSE                                                                 CAP087
     C                   MOVEL     DPAD          DDDPAD                                       CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CAP087
      ** Repo / Pledge Indicator                                                              CAP087
      *                                                                                       CAP087
     C                   MOVEL     RPIN          DDRPIN                                       CAP087
      *                                                                                       CAP087
      ** Switch Reference                                                                     CAP087
      *                                                                                       CAP087
     C                   MOVEL     SWRF          DDSWRF                                       CAP087
      *                                                                                       CAP087
      ** Switch In/Out Indicator                                                              CAP087
      *                                                                                       CAP087
     C                   MOVEL     SIOI          DDSIOI                                       CAP087
      *                                                                                       CAP087
     C                   ENDIF                                                                CAP087
      *
     C/COPY WNCPYSRC,SEDPMVNC03
      ** Booking Branch
      *
     C                   MOVEL     DPBA          DDDPBA
      *
      ** Originating Branch
      *
     C                   MOVEL     ORBR          DDORBR
      *
      ** Book
      *
     C                   MOVEL     DPBK          DDDPBK
                                                                                              CGL031
      ** Original Purchase Date                                                               CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   IF        OPDT <> 0                                                  CGL031
     C                   Z-ADD     *ZEROS        ZDAYNO                                       CGL031
     C                   Z-ADD     OPDT          ZDAYNO                                       CGL031
     C                   EXSR      ZDate2                                                     CGL031
     C                   MOVEL     ZDATE         DDOPDT                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVE      *BLANKS       DDOPDT                                       CGL031
     C                   ENDIF                                                                CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Beneficiary Customer
      *
     C                   MOVEL     DPBN          DDDPBN
 
     C                   CALLB     'AOPLCSR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    DDDPBN
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
      ** Customer is a Portfolio Customer: get default value if blank
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           PortCusInd        1
     C                   ELSE
     C                   MOVEL     'N'           PortCusInd
     C                   END
      *                                                                         CPB001
     C                   MOVE      DDDPBN        KEY10                          CPB001
      *                                                                         CPB001
     C                   CALLB     'AOCUSTR1'                                   CPB001
     C                   PARM      '*MSG    '    @RTCD                          CPB001
     C                   PARM      '*KEY    '    @OPTN                          CPB001
     C                   PARM                    KEY10            10            CPB001
     C                   PARM                    KEY7              7            CPB001
     C     SDCUST        PARM      SDCUST        DSLDY                          CPB001
     C/COPY WNCPYSRC,SEDPMVNC02
      *                                                                         CPB001
      ** Customer is a Private Banking Customer: get default value if blank     CPB001
      *                                                                         CPB001
     C     @RTCD         IFEQ      *BLANKS                                      CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
     C                   MOVEL     'Y'           PBCusInd                       CPB001
     C                   ELSE                                                   CPB001
     C                   MOVEL     'N'           PBCusInd                       CPB001
     C                   ENDIF                                                  CPB001
      *
      ** Nominal Amount
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DPNA          ZFIELD
     C                   Z-ADD     SEC_NMDP      ZADEC
     C                   EXSR      ZEdit
     C                   MOVE      ZFIELD        DDDPNA
      *
      ** Narrative
      *
     C                   MOVE      *BLANKS       DDDPNR
     C                   MOVEL     DPNR          DDDPNR
      *
      ** Price
      *
     C                   MOVE (P)  *BLANKS       ZFIELD
     C                   MOVE (P)  MKTP          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEdit
     C                   MOVE      ZFIELD        DDMKTP
                                                                                              CGL031
      ** Fiscal Price                                                                         CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   IF        FSPR <> 0                                                  CGL031
     C                   MOVE      *BLANKS       ZFLD15                                       CGL031
     C                   MOVE      FSPR          ZFLD15                                       CGL031
     C                   Z-ADD     8             ZDECS                                        CGL031
     C                   EXSR      ZSEdit                                                     CGL031
     C                   MOVE      ZOUT21        DDFSPR                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVE      *BLANKS       DDFSPR                                       CGL031
     C                   ENDIF                                                                CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Profit Centre
      *
     C                   MOVEL     DPPC          DDDPPC
      *
      ** Customer Delivery /Withdrawal
      *
     C                   MOVE      CWDI          DDCWDI
                                                                                              232543
      ** Original Purchased Interest                                                          232543
                                                                                              232543
     C                   IF        CGL031 = 'Y'                                               232543
     C                   IF        OPIN <> 0                                                  232543
     C                   MOVE      SEC_NMCY      @AJCD                                        232543
     C                   EXSR      SrCurrDet                                                  232543
     C                   MOVE      *BLANKS       ZFIELD                                       232543
     C                   MOVE      OPIN          ZFIELD                                       232543
     C                   Z-ADD     A6NBDP        ZADEC                                        232543
     C                   EXSR      ZEdit                                                      232543
     C                   MOVE      ZFIELD        DDOPIN                                       232543
     C                   ELSE                                                                 232543
     C                   MOVE      *BLANKS       DDOPIN                                       232543
     C                   ENDIF                                                                232543
     C                   ENDIF                                                                232543
      *
      ** If Portfolio Management is present
      ** and the Ben. Customer is a Portfolio Customer.
      ** Or Private Banking Module and Customer is Private Banking Customer     CPB001
      *
     C     BGPFMG        IFEQ      'Y'
     C     PortCusInd    ANDEQ     'Y'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     PBCusInd      ANDEQ     'Y'                                          CPB001
      *
      ** Portfolio Reference
      *
     C     PTFR          IFEQ      '9997'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      FCR997        DDPTFR
     C                   ELSE
     C                   MOVE      PTFR          DDPTFR
     C                   END
                                                                                              CGL031
      ***Original*Purchased*Interest***********************************                CGL031 232543
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                        CGL031 232543
     C                   IF        OPIN <> 0                                           CGL031 232543
     C                   MOVE      SEC_NMCY      @AJCD                                 CGL031 232543
     C                   EXSR      SrCurrDet                                           CGL031 232543
     C                   MOVE      *BLANKS       ZFIELD                                CGL031 232543
     C                   MOVE      OPIN          ZFIELD                                CGL031 232543
     C                   Z-ADD     A6NBDP        ZADEC                                 CGL031 232543
     C                   EXSR      ZEdit                                               CGL031 232543
     C                   MOVE      ZFIELD        DDOPIN                                CGL031 232543
     C                   ELSE                                                          CGL031 232543
     C                   MOVE      *BLANKS       DDOPIN                                CGL031 232543
     C                   ENDIF                                                         CGL031 232543
     C                   ENDIF                                                         CGL031 232543
      *
      ** Average Yield
      *
     C     CYLD          IFEQ      0
     C                   MOVE      *BLANKS       DDCYLD
     C                   ELSE
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      CYLD          ZFLD15
     C                   Z-ADD     7             ZDECS
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDCYLD
     C                   END
      *
      ** FX rate
      *
     C     SPXR          IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      SPXR          ZFLD15
     C                   Z-ADD     8             ZDECS
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDSPXR
     C                   END
      *
      ** Multiply/Divide indicator
      *
     C                   MOVE      SPMD          DDSPMD
     C                   END
      *
      ** Charge Details
      *
     C     S01445        IFEQ      'Y'
     C     BVACOP        ANDEQ     'Y'
      *                                                                                     BUG10469
      * Process and convert  Charges for Bond Borrowing and Bond Lending                    BUG10469
     C     DPMV          OREQ      'BB'                                                     BUG10469
     C     DPMV          OREQ      'BL'                                                     BUG10469
      *
      ** Charge Code
      *
     C                   MOVEL     DCHC          DDDCHC
      *
      ** Charge Currency
      *
     C                   MOVEL     DCCE          DDDCCE
 
     C                   MOVE      DDDCCE        @AJCD
 
     C     DDDCCE        IFNE      *BLANKS
     C                   EXSR      SRCurrDet
      *
      ** Charge Charge Amount
      *
     C                   MOVE (P)  *BLANKS       ZFIELD
     C                   MOVE (P)  DCHA          ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEdit
     C                   MOVE      ZFIELD        DDDCHA
     C                   ELSE
     C                   MOVE      *BLANKS       DDDCHA
     C                   END
      *
      ** Settlement Method
      *
     C     DCSE          IFEQ      *ZERO
 
     C     DCHA          IFNE      *ZERO
     C                   MOVE      '00'          DDDCSE
     C                   ELSE
     C                   MOVE      *BLANKS       DDDCSE
     C                   END
 
     C                   ELSE
     C                   MOVE      DCSE          DDDCSE
     C                   END
      *
      ** Settlement Account
      *
     C                   MOVEL     DCAT          DDDCAT
      *
      ** Settlement Branch
      *
     C     DCSE          IFEQ      4
     C     DCSE          OREQ      14
     C                   MOVE      *BLANKS       DDDCAB
     C                   ELSE
     C                   MOVE      DCAB          DDDCAB
     C                   END
     C                   END
      *                                                                                       CSE012
      ** Narrative Fields 2 to 4                                                              CSE012
      *                                                                                       CSE012
     C     CSE012        IFEQ      'Y'                                                        CSE012
     C                   Move      *Blanks       DDDPNR2                                      CSE012
     C                   Move      *Blanks       DDDPNR3                                      CSE012
     C                   Move      *Blanks       DDDPNR4                                      CSE012
     C                   Move      *Blanks       DDDPNR5                                      CSE012
     C                   MoveL     DPNR2         DDDPNR2                                      CSE012
     C                   MoveL     DPNR3         DDDPNR3                                      CSE012
     C                   MoveL     DPNR4         DDDPNR4                                      CSE012
     C                   MoveL     DPNR5         DDDPNR5                                      CSE012
     C                   ENDIF                                                                CSE012
      *                                                                                       CPB001
      ** Purchased Interest                                                                   CPB001
      *                                                                                       CPB001
     C                   MOVE      'N'           PBFieldInd                                   CPB001
     C                   MOVE      *BLANKS       DDPINT                                       CPB001
     C                   MOVE      *BLANKS       DDACIN                                       CPB001
     C************       MOVE      *BLANKS       DDMSTP                                 CPB001187544
     C                   MOVE      MSTP          DDMSTP                                       187544
     C     BGN4ST        IFEQ      'Y'                                                        CPB001
     C     INV_PROT      IFEQ      '1'                                                        CPB001
     C     INV_PROT      OREQ      '3'                                                        CPB001
     C     INV_PROT      OREQ      '5'                                                        CPB001
     C     INV_PROT      OREQ      '6'                                                        CPB001
     C     INV_PROT      OREQ      '8'                                                        CPB001
     C     INV_PROT      OREQ      '9'                                                        CPB001
      *                                                                                       CPB001
     C     SEC_STBS      IFEQ      'Y'                                                        CPB001
     C     SEC_STBS      OREQ      'P'                                                        CPB001
     C                   MOVE      'Y'           PBFieldInd                                   CPB001
     C     PINT          IFNE      0                                                          CPB001
     C                   MOVE      SEC_NMCY      @AJCD                                        CPB001
     C                   EXSR      SRCurrDet                                                  CPB001
     C                   MOVE      *BLANKS       ZFLD15                                       CPB001
     C                   MOVE      PINT          ZFLD15                                       CPB001
     C                   Z-ADD     A6NBDP        ZDECS                                        CPB001
     C                   EXSR      ZSEdit                                                     CPB001
     C                   MOVE      ZOUT21        DDPINT                                       CPB001
     C                   ELSE                                                                 CPB001
     C                   MOVE      *BLANKS       DDPINT                                       CPB001
     C                   ENDIF                                                                CPB001
      *                                                                                       CPB001
      ** Accued Indicator                                                                     CPB001
      *                                                                                       CPB001
     C                   MOVE      ACIN          DDACIN                                       CPB001
      ************                                                                      CPB001187544
      ***Movement Subtype                                                               CPB001187544
      ************                                                                      CPB001187544
     C************       MOVE      MSTP          DDMSTP                                 CPB001187544
     C                   ENDIF                                                                CPB001
     C                   ENDIF                                                                CPB001
     C                   ENDIF                                                                CPB001
      *                                                                                       CSE017
      ** Cum/Ex and Print Advice Indicator                                                    CSE017
      *                                                                                       CSE017
     C     CSE017        IFEQ      'Y'                                                        CSE017
     C                   Move      DPIN          DDDPIN                                       CSE017
     C                   Move      DPAP          DDDPAP                                       CSE017
     C                   ENDIF                                                                CSE017
      *                                                                                       CSE015
      ** Trade Date                                                                           CSE015
      *                                                                                       CSE015
     C     CSE015        IFEQ      'Y'                                                        CSE015
     C                   Z-ADD     *ZEROS        ZDAYNO                                       CSE015
     C                   MOVE      DMTD          ZDAYNO                                       CSE015
     C                   EXSR      ZDATE2                                                     CSE015
     C                   MOVE      ZDATE         DDDMTD                                       CSE015
     C                   ENDIF                                                                CSE015
                                                                                              207006
      ** Counterparty and Market Centre                                                       207006
                                                                                              207006
     C     CSE029        IFEQ      'Y'                                                        207006
                                                                                              207006
     C*****CPTY*         IFNE      *ZEROS                                              207006 CSD027
     C     CPTY          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      CPTY          DDCPTY                                       207006
     C                   ELSE                                                                 207006
     C                   MOVE      *BLANKS       DDCPTY                                       207006
     C                   ENDIF                                                                207006
                                                                                              207006
     C                   MOVE      MRKT          DDMRKT                                       207006
     C                   ENDIF                                                                207006
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTranSts - Process Transaction status                        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRTranSts     BEGSR
      *
      ** Trade status : cancelled
      *
     C     RECI          IFEQ      '*'
     C     RECI          OREQ      'R'
     C                   MOVEL     'DELETED'     DDTranSts
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZSEDIT - Edit a signed field                                  *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ZSEDIT        BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECHAR            1
     C                   PARM                    ZOUT21           21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Clear Output fields                                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
      ** Blank Outputs (Except for Action Code)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        DPMVScnFmt
     C                   MOVEL     ##ACTN        DDACTN
 
     C                   MOVEL     *BLANK        DDSecSts
     C                   MOVEL     *BLANK        DDTranSts
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSecSts - Access Security Details                            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRSecSts      BEGSR
 
      * Access Security details
 
     C     DPSS          CHAIN     SECTYDF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DPSS          DBKEY
     C                   MOVEL     'SECTYD'      DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C     SEC_RECI      IFEQ      'M'
     C                   MOVE      'MATURED'     DDSecSts
     C                   END
                                                                                CPB001
      * Get investment type details                                             CPB001
                                                                                CPB001
     C     KLINVT        KLIST                                                  CPB001
     C                   KFLD                    SEC_NMCY                       CPB001
     C                   KFLD                    SEC_SITP                       CPB001
     C     KLINVT        CHAIN     INVTPDF                            99        CPB001
 
     C
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurrDet - Access Currency Details                           *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
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
 
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Transaction - file format
     C                   PARM                    DPMVFilFmt
      *
      ** Output parameters
      ** -----------------
 
      ** Transaction  screen format
      ** Fx Rate
      ** Mul/Div Indicator
     C                   PARM                    DPMVScnFmt
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      *
      ** Security Status
      ** Transaction status
     C                   PARM                    DDSecSts          7
     C                   PARM                    DDTranSts         7
     C                   PARM                    PBCusInd          1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
     C                   PARM                    CGL031                                       CGL031
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEDPMVCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS SECURITIES TRADING DETAILS
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MIDAS MODULES
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS PORTFOLIO MANAGEMNT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Access SAR details file to determine if S01445
      ** (Depot Movement Charge Enhancement) is on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01445'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     'S01445'      DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01445            1
     C                   ELSE
     C                   MOVEL     'N'           S01445
     C                   END
      *                                                                                       CSE012
      ** Access SAR details file to determine if CSE012                                       CSE012
      ** (SE Transactions Enhancement) is on.                                                 CSE012
      *                                                                                       CSE012
     C                   CALL      'AOSARDR0'                                                 CSE012
     C                   PARM      *BLANKS       @RTCD                                        CSE012
     C                   PARM      '*VERIFY'     @OPTN                                        CSE012
     C                   PARM      'CSE012'      @SARD                                        CSE012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE012
      *                                                                                       CSE012
     C     @RTCD         IFNE      *BLANKS                                                    CSE012
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE012
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE012
     C                   MOVEL     '905'         DBASE                                        CSE012
     C                   MOVEL     'CSE012'      DBKEY                                        CSE012
     C                   EXSR      *PSSR                                                      CSE012
     C                   END                                                                  CSE012
      *                                                                                       CSE012
     C     @RTCD         IFEQ      *BLANK                                                     CSE012
     C                   MOVEL     'Y'           CSE012            1                          CSE012
     C                   ELSE                                                                 CSE012
     C                   MOVEL     'N'           CSE012                                       CSE012
     C                   END                                                                  CSE012
      *                                                                                       CSE017
      ** Access SAR details file to determine if CSE017                                       CSE017
      ** (Cum/Ex Indicator on Depot Movement) is on.                                          CSE017
      *                                                                                       CSE017
     C                   CALL      'AOSARDR0'                                                 CSE017
     C                   PARM      *BLANKS       @RTCD                                        CSE017
     C                   PARM      '*VERIFY'     @OPTN                                        CSE017
     C                   PARM      'CSE017'      @SARD                                        CSE017
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE017
      *                                                                                       CSE017
     C     @RTCD         IFNE      *BLANKS                                                    CSE017
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE017
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE017
     C                   MOVEL     '906'         DBASE                                        CSE017
     C                   MOVEL     'CSE017'      DBKEY                                        CSE017
     C                   EXSR      *PSSR                                                      CSE017
     C                   END                                                                  CSE017
      *                                                                                       CSE017
     C     @RTCD         IFEQ      *BLANK                                                     CSE017
     C                   MOVEL     'Y'           CSE017            1                          CSE017
     C                   ELSE                                                                 CSE017
     C                   MOVEL     'N'           CSE017                                       CSE017
     C                   END                                                                  CSE017
      *                                                                                       CSE015
      ** Access SAR details file to determine if CSE015                                       CSE015
      ** (Forward Valued Depot Movements) is on.                                              CSE015
      *                                                                                       CSE015
     C                   CALL      'AOSARDR0'                                                 CSE015
     C                   PARM      *BLANKS       @RTCD                                        CSE015
     C                   PARM      '*VERIFY'     @OPTN                                        CSE015
     C                   PARM      'CSE015'      @SARD                                        CSE015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE015
      *                                                                                       CSE015
     C     @RTCD         IFNE      *BLANKS                                                    CSE015
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE015
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE015
     C                   MOVEL     '907'         DBASE                                        CSE015
     C                   MOVEL     'CSE015'      DBKEY                                        CSE015
     C                   EXSR      *PSSR                                                      CSE015
     C                   END                                                                  CSE015
      *                                                                                       CSE015
     C     @RTCD         IFEQ      *BLANK                                                     CSE015
     C                   MOVEL     'Y'           CSE015            1                          CSE015
     C                   ELSE                                                                 CSE015
     C                   MOVEL     'N'           CSE015                                       CSE015
     C                   END                                                                  CSE015
      *                                                                                       207006
      ** Access SAR details file to determine if CSE029                                       207006
      ** (ISO15022 Message Generation) is on.                                                 207006
      *                                                                                       207006
     C                   CALL      'AOSARDR0'                                                 207006
     C                   PARM      *BLANKS       @RTCD                                        207006
     C                   PARM      '*VERIFY'     @OPTN                                        207006
     C                   PARM      'CSE029'      @SARD                                        207006
     C     SCSARD        PARM      SCSARD        DSFDY                                        207006
      *                                                                                       207006
     C     @RTCD         IFNE      *BLANKS                                                    207006
     C     @RTCD         ANDNE     '*NRF   '                                                  207006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       207006
     C                   MOVEL     '908'         DBASE                                        207006
     C                   MOVEL     'CSE029'      DBKEY                                        207006
     C                   EXSR      *PSSR                                                      207006
     C                   ENDIF                                                                207006
      *                                                                                       207006
     C     @RTCD         IFEQ      *BLANK                                                     207006
     C                   MOVEL     'Y'           CSE029            1                          207006
     C                   ELSE                                                                 207006
     C                   MOVEL     'N'           CSE029                                       207006
     C                   ENDIF                                                                207006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
