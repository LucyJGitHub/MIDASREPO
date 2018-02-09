     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade conversion file to screen format')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADCVT - Trades Conversion: File to Screen Format         *
      *                                                               *
      *  Function:  This module converts the fields of a trade        *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 AR698195B          Date 20Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13267           Date 09Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 232543             Date 15Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 229192             Date 27Aug04               *
      *                 211800             Date 12Nov02               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 10Jul03               *
      *                 CSE039             Date 04Apr03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 200614             Date 19Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 196903             Date 22Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      *                 CSE022             Date 29Mar01               *
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 188447             Date 09Jan00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      *                 175216             Date 12Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 17Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAC005             Date 23Nov98               *
      *                 CAP003  *CREATE    Date 22Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  BUG13267-DDSTAT and DDAUTH are often blank for transactions  *
      *         - that shows status of 'Authorised' on listview       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  229192 - Use the nominal currency dec. place to edit the     *
      *           N-T-R Int Amt field.                                *
      *  211800 - If customer is flagged as 'Closed' Customer is not  *
      *           filled up.                                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Renamed the field SEZONE in SDSECS data structure  *
      *            to avoid compilation error.                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Synchronous calling of APIs                         *
      *           Some field is not being converted due to add        *
      *           condition. Therefore remove condition.              *
      *  CSE039 - Auto-settlement of trades                           *
      *         - Recompiled due to change in SETRSEPD                *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  200614 - Blank DDGMES, DDTRTT, DDGMEC and DDCCID when trade  *
      *           comes from City Dealer. Default these values during *
      *           amendment.                                          *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  196903 - Manage the status of the trade                      *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CSE016 - Extended Security Descriptions                      *
      *  CSD006 - Market Data Feed (Recompiled)                       *
      *  188447 - Impossible to delete a trade using new API          *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  175216 - Add additional field for "Standing Instructions     *
      *           Override" missed at SWIFT 98 change.                *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *           Recompiled due to database changes                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAC005 - Profit Centre Accounting - SE Enhancement           *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK
     FINVTP     IF   E           K DISK
 
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
 
      * Trade - File Formats
     D TradFilFmt    E DS                  EXTNAME(TRADSD)
     D TRD_REPI      E                     EXTFLD(REPI)                         CPB001
     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(A_)
     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(B_)
 
      * Trade - Screen Formats
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
     D TrSeco        E DS                  EXTNAME(SETRSEPD)
     D TrThir        E DS                  EXTNAME(SETRTHPD)                                  CAS006
     D TrExch        E DS                  EXTNAME(SETREXPD)
     D TrSett        E DS                  EXTNAME(SETRSTPD)
     D XX_DDCLTY     E                     EXTFLD(DDCLTY)
     D TrChCm        E DS                  EXTNAME(SETRCCPD)
     D TrSwft_A      E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A_)
     D TrSwft_B      E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B_)
 
 
      ** Security Details
     D SECTYDts      E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)                         CPB001
     D SEC_FRNT      E                     EXTFLD(FRNT)                                       CAP137
     D SEC_REPA      E                     EXTFLD(REPA)                                       CAP137
     D SEC_TMST      E                     EXTFLD(TMST)                                       CAP137
 
      ** Investment Type Details
     D INVTPDts      E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
 
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
 
      ** Array used to move right Swift Id.
     D ROU             S              1    DIM(12)
 
      ** Array used to left-align countervalue.
     D                 DS                                                       E20653
     D  CTR                    1     21                                         E20653
     D                                     DIM(21)                              COUNTERVALUE     E20
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D BFZONE        E                     EXTFLD(SEZONE)
      ** EXTERNAL DS FOR SECURITIES CUSTOMER DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                211800
     D DSLDY         E DS                  EXTNAME(DSLDY)                       211800
      ** FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                      211800
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CSE016
      ** Parameter declaration of ZSDESC                                                      CSE016
                                                                                              CSE016
     D PSRPN           S             20A                                                      CSE016
     D PSFN1           S             30A                                                      CSE016
     D PSFN2           S             30A                                                      CSE016
     D PRSFD           S              1A                                                      CSE016
     D PRNME           S             41A                                                      CSE016
     D PFNM1           S             30A                                                      CSE016
     D PFNM2           S             50A                                                      CSE016
     D PFNM3           S             50A                                                      CSE016
                                                                                              CAS006
     D CAS006          S              1                                                       CAS006
     D DDPRICN         S             17                                                       CAS006
                                                                                              CGL031
      ** CGL031 flag                                                                          CGL031
     D CGL031          S              1A                                                      CGL031
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *  Rename common field names in SECTY & INVTP
      *
     ISECTYDF
     I              RECI                        SEC_RECI
     I              CHTP                        SEC_CHTP
     I              LCD                         SEC_LCD
     I              TNLU                        SEC_TNLU
     I              TMST                        SEC_TMST                        188447
     I              REPI                        SEC_REPI                        188447
     I              FRNT                        SEC_FRNT                        188447
     I              REPA                        SEC_REPA                        188447
      *
     IINVTPDF
     I              RECI                        INV_RECI
     I              CHTP                        INV_CHTP
     I              LCD                         INV_LCD
     I              TNLU                        INV_TNLU
 
      **************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      ** SET PRIMARY SCREEN FIELDS
      *
     C                   EXSR      SCN_PRIM
      *
      ** SET SECONDARY SCREEN FIELDS
      *
     C                   EXSR      SCN_SECO
                                                                                              CAS006
      ** Set Third screen fields                                                              CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SCN_THIR                                                   CAS006
     C                   ENDIF                                                                CAS006
      *
      ** SET EXCHANGE RATE SCREEN FIELDS
      *
     C                   EXSR      SCN_EXCH
      *
      ** SET SETTLEMENTS SCREEN FIELDS
      *
     C                   EXSR      SCN_SETI
      *
      ** SET CHARGES & COMMISSION FIELDS
      *
     C                   EXSR      SCN_CHCM
      *
      ** SET SWIFT SCREEN FIELDS - Screen A
      *
     C                   EXSR      SCN_SWFTA
      *
      ** SET SWIFT SCREEN FIELDS - Screen B
      *
     C                   EXSR      SCN_SWFTB
      *
      ** TRADE STATUS
      *
     C                   EXSR      TRADSTAT
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_PRIM - SET PRIMARY SCREEN FIELDS
      *****************************************************************
     C     SCN_PRIM      BEGSR
 
      *  Trade Reference
     C                   MOVE      TDRF          DDTDRF
 
      *  Bulk Reference
     C                   MOVE      BLKR          DDBLKR
 
      *  Security Shortname
     C                   MOVEL     TDSS          DDSESN
     C                   EXSR      ACSINST
 
      *  Customer number/name
 
     C*****TCNR*         IFNE      *ZEROS                                                     CSD027
     C     TCNR          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     TCNR          DDCNUM
     C                   EXSR      ACSCUST
     C                   MOVEL     BBCRNM        DDCRNM
     C/COPY WNCPYSRC,SETRADNC03
     C                   END
      *
      *  Incomplete indicator
     C                   MOVE      TINC          DDINCS
      *
      *  Trade type
     C                   MOVE      TDTP          DDTDTP
      *
      *  Nominal
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NOML          ZFIELD
     C                   Z-ADD     TNMD          ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNOML
      *
      *  Price/Discount/Yield
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      TPDY          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDTPDY
      *
      *  Value date
     C                   Z-ADD     TDVD          ZDAYNO
     C                   EXSR      ZDATE2
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'D'
     C                   MOVE      ZADATE        DDTDVD
     C                   ELSE
     C                   MOVEL     ZDATE         DDTDVD
     C                   END
      *
      *  Branch code
     C                   MOVEL     TDBA          DDBRCD
      *
      *  Book
     C                   MOVEL     TDBK          DDBPBK
      *                                                                         CAC005
      ** Recover user book from book on trade                                   CAC005
      *                                                                         CAC005
     C     CAC005        IFEQ      'Y'                                          CAC005
     C                   CALL      'AOBKPCR0'                                   CAC005
     C                   PARM      *BLANKS       P@RTCD            7            CAC005
     C                   PARM      '*USER  '     P@OPTN            7            CAC005
     C                   PARM                    P@BKCD            2            CAC005
     C                   PARM                    P@PRFC            4            CAC005
     C                   PARM      TDBK          P@PSBK            2            CAC005
     C     P@RTCD        IFEQ      *BLANKS                                      CAC005
     C                   MOVEL     P@BKCD        DDBPBK                         CAC005
     C                   ENDIF                                                  CAC005
     C                   ENDIF                                                  CAC005
      *
      *  Clearance type
     C                   MOVEL     CLTY          DDCLTY
     C                   MOVEL     CLTY          XX_DDCLTY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_SECO - SET SECONDARY SCREEN FIELDS
      *****************************************************************
     C     SCN_SECO      BEGSR
      *
     C                   EVAL      DDFRNT = FRNT                                           AR698195B
                                                                                           AR698195B
      *  Settlement currency
     C                   MOVEL     SETC          DDSETC
 
      *  Get settlement currency details
 
     C     DDSETC        IFNE      NMCY
 
     C                   MOVE      DDSETC        @AJCD
     C                   EXSR      ACSCURR
 
     C                   MOVEL     A6SPRT        SetCcySPRT
     C                   Z-ADD     A6NBDP        SetCcyDec
     C                   MOVEL     A6MDIN        SetCcyMDIN
     C                   MOVEL     A6NQDP        SetCcyNQDP
     C                   MOVEL     A6SWCY        SetCcySWCY
     C                   MOVEL     A6CDFN        SetCcyCDFN
     C                   MOVEL     A6ECDN        SetCcyECDN
 
     C                   ELSE
 
     C                   MOVEL     NomCcyDts     SetCcyDts
 
     C                   END
      *
      *  Reallowance
     C     RALL          IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      RALL          ZFLD15
     C                   Z-ADD     5             ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDRALL
     C                   END
      *
      *  Market centre
     C                   MOVEL     TMKC          DDMRKT
      *
      *  Capacity
     C                   MOVEL     TCAP          DDCPCY
      *
      *  Price
     C     STBS          IFEQ      'D'
     C     STBS          OREQ      'Y'
     C     PRIC          IFNE      *ZEROS
     C                   MOVE(P)   *BLANKS       ZFIELD
     C                   MOVE(P)   PRIC          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDPRIC
     C                   END
     C                   END
      *
      *  Ex dividend
     C     PROT          IFEQ      '4'
     C     PROT          OREQ      '7'
     C                   MOVE      EXDV          DDEXDV
     C                   END
      *                                                                                       CGL031
      ** CGL031 Feature is ON                                                                 CGL031
     C     CGL031        IFEQ      'Y'                                                        CGL031
      *                                                                                       CGL031
      ** Fiscal Price                                                                         CGL031
      *                                                                                       CGL031
     C                   MOVE      *BLANKS       DDFSPR                                       CGL031
     C     FSPR          IFNE      *ZEROS                                                     CGL031
     C                   MOVE(P)   *BLANKS       ZFIELD                                       CGL031
     C                   MOVE(P)   FSPR          ZFIELD                                       CGL031
     C                   Z-ADD     8             ZADEC                                        CGL031
     C                   EXSR      ZEDIT                                                      CGL031
     C                   MOVE      ZFIELD        DDFSPR                                       CGL031
     C                   END                                                                  CGL031
      *                                                                                       CGL031
      ** EU Tax                                                                               CGL031
      *                                                                                       CGL031
     C                   MOVE      *BLANKS       DDEUTX                                       CGL031
     C     TDTP          IFEQ      'TP'                                                       CGL031
     C     EUTX          ANDNE     *ZEROS                                                     CGL031
     C                   MOVE(P)   *BLANKS       ZFIELD                                       CGL031
     C                   MOVE(P)   EUTX          ZFIELD                                       CGL031
     C**********         Z-ADD     TNMD          ZADEC                                 CGL031 232543
     C                   MOVE      NMCY          @AJCD                                        232543
     C                   EXSR      ACSCURR                                                    232543
     C                   Z-ADD     A6NBDP        ZADEC                                        232543
     C                   EXSR      ZEDIT                                                      CGL031
     C                   MOVE      ZFIELD        DDEUTX                                       CGL031
     C                   END                                                                  CGL031
     C                   END                                                                  CGL031
      *
      ** If Analytical Accounting Module is present, setup Booking
      ** and Transaction Profit Centre
      *
     C     BGN0ST        IFEQ      'Y'
     C                   MOVE      BPRC          DDBPRC
     C*****CustClass     IFEQ      'S'                                                        CAP084
     C*****CustClass     OREQ      'D'                                                        CAP084
     C                   MOVE      TPRC          DDTPRC
     C*****              END                                                                  CAP084
     C                   END
      *
      *  Trader I.D.
     C                   MOVEL     TDID          DDTDID
      *
      *  Trade date
     C     TDDT          IFNE      *ZEROS
     C                   Z-ADD     TDDT          ZDAYNO
     C                   EXSR      ZDATE2
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'D'
     C                   MOVE      ZADATE        DDTDDT
     C                   ELSE
     C                   MOVEL     ZDATE         DDTDDT
     C                   END
     C                   END
      *
      *  Trade sub-type
     C                   MOVEL     TSUB          DDTSUB
      *
      *  Link reference
     C                   MOVEL     LKRF          DDLKRF
      *
      *  Market indicator
     C                   MOVEL     TDMI          DDTDMI
      *
      *  ISMA/IPMA
     C                   MOVEL     AIIP          DDAIIP
      *
      *  Narrative
     C                   MOVEL     TDNR          DDTDNR
      *  Private Banking Order Number                                           CPB001
     C                   MOVEL     ORDE          DDORDE                         CPB001
      *
      *  Current factor
     C     PROT          IFEQ      '8'
     C     TCFC          IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      TCFC          ZFLD15
     C                   Z-ADD     TCFC          CFCT
     C                   Z-ADD     9             ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDCFCT
     C                   END
     C                   END
      *
      *  If interest bearing ...
      *
     C     PROT          IFEQ      '1'
     C     PROT          OREQ      '3'
     C     PROT          OREQ      '5'
     C     PROT          OREQ      '6'
     C     PROT          OREQ      '8'
     C     PROT          OREQ      '9'
     C     STBS          IFEQ      'Y'
     C     STBS          OREQ      'P'
      *
      *  Accrued Indicator
     C                   MOVE      ACIN          DDACIN
      *
      *  Days adjustment
     C     DADJ          IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      DADJ          ZFLD15
     C                   Z-ADD     0             ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDDADJ
     C                   END
      *
      *  Actual Difference indicator
     C                   MOVE      ADIN          DDACTD
      *
      *  Interest amount
     C     ITRA          IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      ITRA          ZFLD15
     C                   ELSE
     C                   MOVE      *ZERO         ZFLD15
     C                   END
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDITRA
      *
      *  Coupon rate
     C     TDCR          IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      TDCR          ZFLD15
     C                   Z-ADD     7             ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDCPNR
     C                   END
 
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      ** SCN_THIR - SET THIRD SCREEN FIELDS                                                   CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SCN_THIR      BEGSR                                                                CAS006
                                                                                              CAS006
      ** Credit Risk Spread                                                                   CAS006
                                                                                              CAS006
     C                   IF        CRSK <> 0                                                  CAS006
     C                   MOVE      *BLANKS       ZFLD15                                       CAS006
     C                   MOVE      CRSK          ZFLD15                                       CAS006
     C                   Z-ADD     8             ZDECS                                        CAS006
     C                   MOVE      *BLANK        ZECODE                                       CAS006
     C                   EXSR      ZSEDIT                                                     CAS006
     C                   MOVE      ZOUT21        DDCRSK                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Liquidity Premium                                                                    CAS006
                                                                                              CAS006
     C                   IF        LQPR <> 0                                                  CAS006
     C                   MOVE      *BLANKS       ZFLD15                                       CAS006
     C                   MOVE      LQPR          ZFLD15                                       CAS006
     C                   Z-ADD     8             ZDECS                                        CAS006
     C                   MOVE      *BLANK        ZECODE                                       CAS006
     C                   EXSR      ZSEDIT                                                     CAS006
     C                   MOVE      ZOUT21        DDLQPR                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Net Treasury Price                                                                   CAS006
                                                                                              CAS006
     C                   IF        PRICN <> 0                                                 CAS006
     C                   MOVE      *BLANKS       ZFLD15                                       CAS006
     C                   MOVE      PRICN         ZFLD15                                       CAS006
     C                   Z-ADD     8             ZDECS                                        CAS006
     C                   MOVE      *BLANK        ZECODE                                       CAS006
     C                   EXSR      ZSEDIT                                                     CAS006
     C                   MOVE      ZOUT21        DDPRICN                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Format DDITRN only if security is interest bearing                                   CAS006
                                                                                              CAS006
     C     PROT          IFEQ      '1'                                                        CAS006
     C     PROT          OREQ      '3'                                                        CAS006
     C     PROT          OREQ      '5'                                                        CAS006
     C     PROT          OREQ      '6'                                                        CAS006
     C     PROT          OREQ      '8'                                                        CAS006
     C     PROT          OREQ      '9'                                                        CAS006
                                                                                              CAS006
     C     STBS          IFEQ      'Y'                                                        CAS006
     C     STBS          OREQ      'P'                                                        CAS006
                                                                                              CAS006
      ** Int. Amount Using Net Treasury Rate                                                  CAS006
                                                                                              CAS006
     C                   IF        ITRN <> 0                                                  CAS006
     C                   MOVE      *BLANKS       ZFLD15                                       CAS006
     C                   MOVE      ITRN          ZFLD15                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      ZFLD15 = 0                                                 CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C**********         Z-ADD     SetCcyDec     ZDECS                                 CAS006 229192
     C                   Z-ADD     NomCcyDec     ZDECS                                        229192
     C                   MOVE      *BLANK        ZECODE                                       CAS006
     C                   EXSR      ZSEDIT                                                     CAS006
     C                   MOVE      ZOUT21        DDITRN                                       CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      ** SCN_EXCH - SET EXCHANGE RATE SCREEN FIELDS
      *****************************************************************
     C     SCN_EXCH      BEGSR
 
      *  Exchange Rate
 
     C     TDER          IFNE      *ZEROS
 
     C                   MOVE      *BLANKS       ZFLD15
 
     C     BGN0ST        IFNE      'Y'
     C     DDSETC        OREQ      NMCY
     C                   MOVE      TDER          ZFLD15
     C                   ELSE
     C     TDTP          IFEQ      'TP'
     C     TMDI          ANDEQ     'M'
     C     TDTP          OREQ      'TS'
     C     TMDI          ANDEQ     'D'
     C     TDER          ADD       FXMR          W_TDER           13 8
     C                   ELSE
     C     TDER          SUB       FXMR          W_TDER
     C                   END
     C                   MOVE      W_TDER        ZFLD15
     C                   END
      *
     C                   Z-ADD     8             ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTDER
     C                   END
 
      *  M/D indicator
     C                   MOVE      TMDI          DDSMDI
 
      *  Base currency rate
     C     TBCR          IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      TBCR          ZFLD15
     C                   Z-ADD     8             ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDBRTE
     C                   END
      *
      ** Margin points and amount.
      ** (only if profit centre accounting is present, and
      **  settlement currency is different from nominal currency)
      *
     C     BGN0ST        IFEQ      'Y'
     C     DDSETC        ANDNE     NMCY
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FXMP          ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDFXMP
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MAMT          ZFLD15
     C                   Z-ADD     SetCcyDec     ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDMAMT
      *
     C                   END
      *
      *  Originating Branch
      *
     C                   MOVE      ORBR          DDORBR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_SETI - SET SETTLEMENTS SCREEN FIELDS
      *****************************************************************
     C     SCN_SETI      BEGSR
      *
      *  Settlement method
     C                   MOVEL     SMTH          DDSMTH
     C/COPY WNCPYSRC,SETRADNC01
      *
      *  Pay from
     C                   MOVEL     PYFM          DDPYFM
      *
      *  Pay from branch
     C                   MOVEL     PYFA          DDPYFB
      *
      *  Pay to
     C                   MOVEL     PAYT          DDPAYT
      *
      *  Pay to branch
     C                   MOVEL     PYTA          DDPYTB
      *
      *  For a/c of
     C                   MOVEL     TDFA          DDTDFA
      *
      *  A/c sequence
     C     ASNM          IFNE      *ZEROS
     C                   MOVEL     ASNM          DDASNM
     C                   END
      *
      *  Deliver from
     C*****DELF*         IFNE      *ZEROS                                                     CSD027
     C     DELF          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     DELF          DDDELF
     C/COPY WNCPYSRC,SETRADNC04
     C                   END
      *
      *  Deliver to
     C*****DELT*         IFNE      *ZEROS                                                     CSD027
     C     DELT          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     DELT          DDDELT
     C/COPY WNCPYSRC,SETRADNC05
     C                   END
 
      *  For a/c of (FROM)
     C                   MOVEL     DFFA          DDDFFA
     C/COPY WNCPYSRC,SETRADNC06
 
      *  For a/c of (TO)
     C                   MOVEL     DTFA          DDDTFA
     C/COPY WNCPYSRC,SETRADNC07
      *
      *  Special instructions
     C                   MOVEL     TDSI          DDTDSI
      *
      *  Profit Centre
      *
     C     BGN0ST        IFNE      'Y'
     C                   MOVE      PRFC          DDPRFC
     C                   END
      *
      *  'In' Currency in field 72
      *
     C                   MOVE      ICCY          DDICCY
      *
      *  Priority code
     C                   MOVEL     PRYC          DDPRYC
      *
      *  Pay code
     C                   MOVEL     PCOD          DDPCOD
 
      *  Auto-Settle indicator
     C                   MOVEL     AUTS          DDAUTS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_CHCM - SET CHARGES & COMMISSIONS SCREEN FIELDS
      *****************************************************************
     C     SCN_CHCM      BEGSR
      *
      *  For Charges/Commissions reverse signs for display if necessary.
      *
     C     CustClass     IFEQ      'M'
     C     TDTP          ANDEQ     'TS'
     C     CustClass     OREQ      'S'
     C     TDTP          ANDEQ     'TP'
     C     CustClass     OREQ      'D'
     C     TDTP          ANDEQ     'TP'
     C                   Z-SUB     TBCA          WTBCA            13 0
     C                   Z-SUB     TCCA          WTCCA            13 0
     C                   Z-SUB     TCA1          WTCA1            13 0
     C                   Z-SUB     TCA2          WTCA2            13 0
     C                   Z-SUB     TCA3          WTCA3            13 0
     C                   Z-SUB     TCA4          WTCA4            13 0
     C                   Z-SUB     TCA5          WTCA5            13 0
     C                   Z-SUB     TCA6          WTCA6            13 0
     C                   Z-SUB     TCA7          WTCA7            13 0
     C                   Z-SUB     TAXA          WTAXA            13 0
     C                   Z-SUB     BCMR          WBCMR            13 0
     C                   Z-SUB     CCMR          WCCMR            13 0
     C                   Z-SUB     TXRB          WTXRB            13 0
     C                   ELSE
     C                   Z-ADD     TBCA          WTBCA
     C                   Z-ADD     TCCA          WTCCA
     C                   Z-ADD     TCA1          WTCA1
     C                   Z-ADD     TCA2          WTCA2
     C                   Z-ADD     TCA3          WTCA3
     C                   Z-ADD     TCA4          WTCA4
     C                   Z-ADD     TCA5          WTCA5
     C                   Z-ADD     TCA6          WTCA6
     C                   Z-ADD     TCA7          WTCA7
     C                   Z-ADD     TAXA          WTAXA
     C                   Z-ADD     BCMR          WBCMR
     C                   Z-ADD     CCMR          WCCMR
     C                   Z-ADD     TXRB          WTXRB
     C                   END
      *
      *  Broker commission code
     C                   MOVEL     TBCC          DDTBCC
      *
      *  Broker commission amount
     C     WTBCA         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTBCA         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTBCA
     C                   END
      *
      *  Customer commission code
     C                   MOVEL     TCCC          DDTCCC
      *
      *  Customer commission amount
     C     WTCCA         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTCCA         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTCCA
     C                   END
      *
      *  Charges 1 code
     C                   MOVEL     TCC1          DDTCC1
      *
      *  Charges 1 amount
     C     WTCA1         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTCA1         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTCA1
     C                   END
      *
      *  Charges 2 code
     C                   MOVEL     TCC2          DDTCC2
      *
     C*  Charges 2 amount
     C     WTCA2         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTCA2         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTCA2
     C                   END
      *
      *  Charges 3 code
     C                   MOVEL     TCC3          DDTCC3
      *
      *  Charges 3 amount
     C     WTCA3         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTCA3         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTCA3
     C                   END
      *
      *  Charges 4 code
     C                   MOVEL     TCC4          DDTCC4
      *
      *  Charges 4 amount
     C     WTCA4         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTCA4         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTCA4
     C                   END
      *
      *  Charges 5 code
     C                   MOVEL     TCC5          DDTCC5
      *
      *  Charges 5 amount
     C     WTCA5         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTCA5         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTCA5
     C                   END
      *
      *  Charges 6 code
     C                   MOVEL     TCC6          DDTCC6
      *
      *  Charges 6 amount
     C     WTCA6         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTCA6         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTCA6
     C                   END
      *
      *  Charges 7 code
     C                   MOVEL     TCC7          DDTCC7
      *
      *  Charges 7 amount
     C     WTCA7         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTCA7         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTCA7
     C                   END
      *
      *  Tax amount
     C     WTAXA         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTAXA         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTAXA
     C                   END
      *
      *  Broker Commission Rebate
     C     WBCMR         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WBCMR         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDBCMR
     C                   END
      *
      *  Customer Commission Rebate
     C     WCCMR         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WCCMR         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDCCMR
     C                   END
      *
      *  Tax rebate
     C     WTXRB         IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTXRB         ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDTXRB
     C                   END
      *
      *  Countervalue
      *
     C     TCTR          IFNE      *ZEROS
      *
      *   Convert to settlement currency for screen display only.
      *
     C                   Z-ADD     TCTR          ZAMTCI
     C                   Z-ADD     TDER          ZEXCH
     C                   MOVE      TMDI          ZMD
     C                   MOVE      NMCY          ZCCYI
     C                   MOVE      DDSETC        ZCCYO
     C                   MOVE      NomCcyDec     ZCDPI
     C                   MOVE      SetCcyDec     ZCDPO
     C                   EXSR      ZCONV
     C                   Z-ADD     ZAMTCO        WTCTR            15 0
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTCTR         ZFLD15
     C                   Z-ADD     SetCcyDec     ZDECS
     C                   MOVE      'J'           ZECODE
     C                   MOVE      '*'           ZECHAR
     C                   EXSR      ZSEDITF
     C                   MOVE      ZOUT21        DDTCTR
     C                   EXSR      CNTL
     C                   END
      *                                                                         CSE023
      ** If treaty withholding tax is installed format amount.                  CSE023
      *                                                                         CSE023
     C                   IF        CSE023 = 'Y' AND WHTX <> *ZEROS              CSE023
     C                   MOVE      *BLANKS       ZFLD15                         CSE023
     C                   MOVE      WHTX          ZFLD15                         CSE023
     C                   Z-ADD     SetCcyDec     ZDECS                          CSE023
     C                   MOVE      'J'           ZECODE                         CSE023
     C                   MOVE      *BLANK        ZECHAR                         CSE023
     C                   EXSR      ZSEDITF                                      CSE023
     C                   MOVE      ZOUT21        DDWTAX                         CSE023
     C                   ELSE                                                   CSE023
     C                   MOVE      *BLANKS       DDWTAX                         CSE023
     C                   ENDIF                                                  CSE023
      *
      ** If portfolio management is present
      ** Or private banking module is present                                   CPB001
      *
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'                                          CPB001
 
      * Portfolio ref.
     C     PTFR          IFEQ      '9997'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      FCR997        DDPTFR
     C                   ELSE
     C                   MOVE      PTFR          DDPTFR
     C                   END
      *
      * FX rate
     C     BGPFMG        IFEQ      'Y'                                          CPB001
     C     SPXR          IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      SPXR          ZFLD15
     C                   Z-ADD     8             ZDECS
     C                   MOVE      *BLANK        ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDSPXR
     C                   END
     C                   ENDIF                                                  CPB001
      *
      * multiply/divide indicator
     C                   MOVE      SPMD          DDSPMD
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_SWFTA - SET SWIFT SCREEN FIELDS - SCREEN A
      *****************************************************************
     C     SCN_SWFTA     BEGSR
      *
      ** Determine Settlements Network routing and addresses
      *
     C     TDTP          IFEQ      'TP'
     C                   MOVE      DELT          WSNDR
     C                   MOVE      DELT          WDEST
     C                   ELSE
     C                   MOVE      DELF          WSNDR
     C                   MOVE      DELF          WDEST
     C                   END
     C                   MOVE      SMTH          WSETP
      *
     C                   EXSR      SR1100
 
      ** Destination of Settlement
 
     C                   MOVE      WWROU         A_DDROUS
     C                   MOVE      WWROT         A_DDROTS
 
      * Settlement Message Request
 
     C     A_T1GMES      IFEQ      *BLANK                                                     200614
     C                   MOVE      'N'           A_T1GMES                                     200614
     C                   ENDIF                                                                200614
                                                                                              200614
     C                   MOVE      A_T1GMES      A_DDGMES
 
      * Time of Trade
     C     A_T1TRTT      IFEQ      *BLANK                                                     200614
     C                   TIME                    WWTIME            6 0                        200614
     C                   MOVEL     WWTIME        A_T1TRTT                                     200614
     C                   ENDIF                                                                200614
     C                   MOVE      A_T1TRTT      A_DDTRTT
 
      * Instructions Type
     C                   MOVE      A_T1INST      A_DDINST
 
      * Instructions Sub-Type
     C                   MOVE      A_T1INSS      A_DDINSS
 
      * Counterparty Euroclear/Cedel Code
     C                   MOVE      A_T1EUCL      A_DDEUCL
 
      * Safekeeping A/C
     C                   MOVE      A_T1SAFA      A_DDSAFA
 
      * Requested Priority
     C                   MOVE      A_T1RPTY      A_DDRPTY
 
      * Guaranteed Delivery
     C                   MOVE      A_T1GDEL      A_DDGDEL
 
      * Sender's Role
     C                   MOVE      A_T1SROL      A_DDSROL
 
      * Fungibility Code
     C                   MOVE      A_T1FCOD      A_DDFCOD
 
      * Fungible Trade Ind
     C                   MOVE      A_T1FTID      A_DDFTID
      *
      ** Determine Confirmation Network routing and addresses
      *
     C                   MOVE      TCNR          WSNDR
     C                   MOVE      TCNR          WDEST
     C                   MOVE      SMTH          WSETP
      *
     C                   EXSR      SR1100
 
      ** Destination of Confirmation
 
     C                   MOVE      WWROU         A_DDROUC
     C                   MOVE      WWROT         A_DDROTC
 
      * Confirmation Message Request
                                                                                              200614
     C     A_T1GMEC      IFEQ      *BLANK                                                     200614
     C                   MOVE      'N'           A_T1GMEC                                     200614
     C                   ENDIF                                                                200614
                                                                                              200614
     C                   MOVE      A_T1GMEC      A_DDGMEC
 
      * Customer/Counterparty Indicator                                      . -
     C     A_T1CCID      IFEQ      *BLANK                                                     200614
     C     BFCLAS        IFEQ      'M'                                                        200614
     C                   MOVE      'P'           A_T1CCID                                     200614
     C                   ELSE                                                                 200614
     C                   MOVE      'C'           A_T1CCID                                     200614
     C                   ENDIF                                                                200614
     C                   ENDIF                                                                200614
     C                   MOVE      A_T1CCID      A_DDCCID
 
      * Further Identification (MT510)                                       . -
     C                   SELECT
     C     A_T1FID1      WHENEQ    ' FORWARD'
     C                   MOVE      'FORWARD '    A_DDFID1
     C     A_T1FID1      WHENEQ    '  OPTION'
     C                   MOVE      'OPTION  '    A_DDFID1
     C     A_T1FID1      WHENEQ    ' REGULAR'
     C                   MOVE      'REGULAR '    A_DDFID1
     C     A_T1FID1      WHENEQ    '    SPOT'
     C                   MOVE      'SPOT    '    A_DDFID1
     C                   OTHER
     C                   MOVE      A_T1FID1      A_DDFID1
      **Standing*Instruction*Override.*********************************                175216 CSE028
     C**********         MOVE      A_T1SIOR      A_DDIORA                              175216 CSE028
      **********                                                                       175216 CSE028
     C                   ENDSL
                                                                                              CSE028
      ** Standing Instruction Override                                                        CSE028
                                                                                              CSE028
     C                   EVAL      A_DDIORA = A_T1SIOR                                        CSE028
                                                                                              CSE028
      ** ISO15022 Messages Indicator                                                          CSE028
                                                                                              CSE028
     C                   EVAL      A_DDSNEW = A_T1NEW                                         CSE028
                                                                                              CSE028
      ** Stamp Status                                                                         CSE028
                                                                                              CSE028
     C                   EVAL      A_DDSTMP = A_T1STMP                                        CSE028
                                                                                              CSE028
      ** Charity Identifier                                                                   CSE028
                                                                                              CSE028
     C                   EVAL      A_DDCHID = A_T1CHID                                        CSE028
                                                                                              CSE028
      ** Transaction Report Marker                                                            CSE028
                                                                                              CSE028
     C                   EVAL      A_DDTRRM = A_T1TRRM                                        CSE028
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_SWFTB - SET SWIFT SCREEN FIELDS - SCREEN B
      *****************************************************************
     C     SCN_SWFTB     BEGSR
      *
      ** Determine Settlements Network routing and addresses
      *
     C     TDTP          IFEQ      'TP'
     C                   MOVE      DELF          WSNDR
     C                   MOVE      DELF          WDEST
     C                   ELSE
     C                   MOVE      DELT          WSNDR
     C                   MOVE      DELT          WDEST
     C                   END
     C                   MOVE      SMTH          WSETP
      *
     C                   EXSR      SR1100
 
      ** Destination of Settlement
 
     C                   MOVE      WWROU         B_DDROUS
     C                   MOVE      WWROT         B_DDROTS
 
      * Settlement Message Request
 
     C                   MOVE      B_T1GMES      B_DDGMES
 
      * Time of Trade
     C                   MOVE      B_T1TRTT      B_DDTRTT
 
      * Instructions Type
     C                   MOVE      B_T1INST      B_DDINST
 
      * Instructions Sub-Type
     C                   MOVE      B_T1INSS      B_DDINSS
 
      * Counterparty Euroclear/Cedel Code
     C                   MOVE      B_T1EUCL      B_DDEUCL
 
      * Safekeeping A/C
     C                   MOVE      B_T1SAFA      B_DDSAFA
 
      * Requested Priority
     C                   MOVE      B_T1RPTY      B_DDRPTY
 
      * Guaranteed Delivery
     C                   MOVE      B_T1GDEL      B_DDGDEL
 
      * Sender's Role
     C                   MOVE      B_T1SROL      B_DDSROL
 
      * Fungibility Code
     C                   MOVE      B_T1FCOD      B_DDFCOD
 
      * Fungible Trade Ind
     C                   MOVE      B_T1FTID      B_DDFTID
      *
      ** Determine Confirmation Network routing and addresses
      *
     C                   MOVE      TCNR          WSNDR
     C                   MOVE      TCNR          WDEST
     C                   MOVE      SMTH          WSETP
      *
     C                   EXSR      SR1100
 
      ** Destination of Confirmation
 
     C                   MOVE      WWROU         B_DDROUC
     C                   MOVE      WWROT         B_DDROTC
 
      * Confirmation Message Request
     C                   MOVE      B_T1GMEC      B_DDGMEC
 
      * Customer/Counterparty Indicator                                      . -
     C                   MOVE      B_T1CCID      B_DDCCID
 
      * Further Identification (MT510)                                       . -
     C                   SELECT
     C     B_T1FID1      WHENEQ    ' FORWARD'
     C                   MOVE      'FORWARD '    B_DDFID1
     C     B_T1FID1      WHENEQ    '  OPTION'
     C                   MOVE      'OPTION  '    B_DDFID1
     C     B_T1FID1      WHENEQ    ' REGULAR'
     C                   MOVE      'REGULAR '    B_DDFID1
     C     B_T1FID1      WHENEQ    '    SPOT'
     C                   MOVE      'SPOT    '    B_DDFID1
     C                   OTHER
     C                   MOVE      B_T1FID1      B_DDFID1
      **Standing*Instruction*Override.*********************************                175216 CSE028
     C**********         MOVE      B_T1SIOR      B_DDIORA                              175216 CSE028
      **********                                                                       175216 CSE028
     C                   ENDSL
                                                                                              CSE028
      ** Standing Instruction Override.                                                       CSE028
                                                                                              CSE028
     C                   EVAL      B_DDIORA = B_T1SIOR                                        CSE028
                                                                                              CSE028
      ** ISO15022 Messages Indicator                                                          CSE028
                                                                                              CSE028
     C                   EVAL      B_DDSNEW = B_T1NEW                                         CSE028
                                                                                              CSE028
      ** Stamp Status                                                                         CSE028
                                                                                              CSE028
     C                   EVAL      B_DDSTMP = B_T1STMP                                        CSE028
                                                                                              CSE028
      ** Charity Identifier                                                                   CSE028
                                                                                              CSE028
     C                   EVAL      B_DDCHID = B_T1CHID                                        CSE028
                                                                                              CSE028
      ** Transaction Report Marker                                                            CSE028
                                                                                              CSE028
     C                   EVAL      B_DDTRRM = B_T1TRRM                                        CSE028
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR1100 - Determine Network and Addresses.                    *
      *                                                               *
      *****************************************************************
     C     SR1100        BEGSR
      *
     C                   CALL      'ZM1100'                             99
     C                   PARM                    WSNDR             6
     C                   PARM                    WSCSD            12
     C                   PARM                    WDEST             6
     C                   PARM                    WSETP             2
     C                   PARM      *BLANKS       WNWSN            20
     C                   PARM      *BLANKS       WNWDS            22
     C                   PARM      *BLANKS       WNWRK             6
     C                   PARM      *BLANKS       WERRC             1
     C                   PARM      *BLANKS       WSRNM            20
     C                   PARM      *BLANKS       WSRTN            10
     C                   PARM      *BLANKS       WDRNM            20
     C                   PARM      *BLANKS       WDRTN            10
      *
     C     WSNDR         IFNE      *BLANKS
     C     WDEST         ANDNE     *BLANKS
      *
     C     *IN99         IFEQ      '1'
     C     WERRC         OREQ      'S'
     C     WERRC         OREQ      'D'
     C     WNWRK         OREQ      'UNROUT'
      *
     C                   MOVEL     *BLANKS       WWROU             6
     C                   MOVEL     '  UNRO'      WWROT            12
     C                   MOVE      'UTABLE'      WWROT
     C                   ELSE
      *
     C                   MOVEL     WNWRK         WWROU
     C                   MOVEA     WNWDS         ROU
     C                   Z-ADD     1             J                 2 0
     C     ' '           LOOKUP    ROU(J)                                 99
     C     *IN99         IFEQ      '0'
     C                   MOVEL     WNWDS         WWROT
     C                   ELSE
     C     14            SUB       J             K                 2 0
     C                   MOVEA     *ALL' '       ROU
     C                   MOVEA     WNWDS         ROU(K)
     C                   MOVEA     ROU           WWROT
     C                   END
     C                   END
 
     C                   ELSE
 
     C                   MOVEL     *BLANKS       WWROU
     C                   MOVEL     *BLANKS       WWROT
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CNTL - Left Align Screen Countervalue.
      *****************************************************************
     C     CNTL          BEGSR
      *                                                               *
     C                   Z-ADD     0             W_E               2 0
     C                   Z-ADD     1             W_F               2 0
     C                   Z-ADD     1             W_R               2 0
     C                   MOVE      '*'           SPLAT             1
     C                   MOVEA     DDTCTR        CTR
     C     SPLAT         LOOKUP    CTR(W_F)                               99
     C     21            SUB       W_F           W_E
     C                   MOVE      ' '           CTR(W_F)
     C                   ADD       1             W_F
     C                   DO        W_E
     C                   MOVE      CTR(W_F)      CTR(W_R)
     C                   ADD       1             W_F
     C                   ADD       1             W_R
     C                   END
     C                   ADD       1             W_E
     C                   MOVEA     *ALL' '       CTR(W_E)
     C                   MOVEA     CTR           DDTCTR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * TRADSTAT - TRADE STATUS
      *****************************************************************
     C     TRADSTAT      BEGSR
 
      ** Trade status : cancelled or settled
 
     C     RECI          IFEQ      'C'
     C     RECI          OREQ      '*'
     C     RECI          OREQ      'R'
     C     RECI          OREQ      'L'
     C     CHTP          ANDEQ     'D'
     C     RECI          OREQ      'P'
     C     CHTP          ANDEQ     'D'
     C                   MOVEL     'CANCELLED'   DDSTAT
     C                   ELSE                                                                 196903
                                                                                              196903
      ** Trade status : incomplete                                                            196903
                                                                                              196903
     C     TINC          IFEQ      'I'                                                        196903
     C                   MOVEL     'INCOMPL. '   DDSTAT                                       196903
     C                   ELSE
     C     RECI          IFEQ      'S'
     C     TDFS          OREQ      BJRDNB
     C     RECI          OREQ      'D'
     C     AUTS          ANDEQ     'Y'
     C     TDVD          ANDLE     BJRDNB
     C     RECI          OREQ      'A'
     C     AUTS          ANDEQ     'Y'
     C     TDVD          ANDLE     BJRDNB
     C                   MOVEL     'SETTLED'     DDSTAT
     C                   END
     C                   END                                                                  196903
     C                   END
                                                                                            BUG13267
      * If DDSTAT is blank then set to UNSETTLED                                            BUG13267
     C     DDSTAT        IFEQ      *BLANKS                                                  BUG13267
     C                   MOVEL     'UNSETTLED'   DDSTAT                                     BUG13267
     C                   ENDIF                                                              BUG13267
 
      ** Trade authorized/not authorized
      ** if complete                                                                          196903
 
     C     TINC          IFNE      'I'                                                        196903
     C     RECI          IFEQ      'L'
     C     RECI          OREQ      'P'
     C     RECI          OREQ      'R'
     C                   MOVEL     'NOT AU'      DDAUTH
     C                   MOVE      'THORISED'    DDAUTH
     C                   ELSE
     C*****BVAUTH        IFNE      '00'                                                     BUG13267
     C                   MOVEL     'AUTHORIS'    DDAUTH
     C                   MOVE      'ED    '      DDAUTH
     C**********         END                                                                BUG13267
     C                   END
     C                   END                                                                  196903
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
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
      *****************************************************************
     C     ZSEDIT        BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21           21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZSEDITF - Edit a signed field                                 *
      *                                                               *
      *****************************************************************
     C     ZSEDITF       BEGSR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZECHAR            1
     C                   PARM                    ZOUT21           21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
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
      * ZCONV - Convert an amount from one currency to another        *
      *                                                               *
      *****************************************************************
     C     ZCONV         BEGSR
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN TRADE FORMATS)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        TrPrim
     C                   MOVEL     *BLANK        TrSeco
     C                   MOVEL     *BLANK        TrThir                                       CAS006
     C                   MOVEL     *BLANK        TrExch
     C                   MOVEL     *BLANK        TrSett
     C                   MOVEL     *BLANK        TrChCm
     C                   MOVEL     *BLANK        TrSwft_A
     C                   MOVEL     *BLANK        TrSwft_B
     C                   MOVEL     ##ACTN        DDACTN
 
     C                   MOVEL     *BLANK        DDSTAT
     C                   MOVEL     *BLANK        DDAUTH                                        S0126
 
     C**********         MOVEL     *BLANK        DDSRPN                                       CSE016
     C                   MOVEL     *BLANK        DDSRNME                                      CSE016
     C                   MOVEL     *BLANK        DDCRNM
 
     C                   MOVEL     *BLANK        DDCPNR
     C                   MOVEL     *BLANK        DDCFCT
     C                   MOVEL     *BLANK        DDMAMT
     C                   MOVEL     *BLANK        DDSPXR
     C                   MOVEL     *BLANK        DDSPMD
     C                   MOVEL     *BLANK        DDTCTR
 
     C                   MOVEL     *BLANK        A_DDROUS
     C                   MOVEL     *BLANK        A_DDROTS
     C                   MOVEL     *BLANK        A_DDROUC
     C                   MOVEL     *BLANK        A_DDROTC
 
     C                   MOVEL     *BLANK        B_DDROUS
     C                   MOVEL     *BLANK        B_DDROTS
     C                   MOVEL     *BLANK        B_DDROUC
     C                   MOVEL     *BLANK        B_DDROTC
     C/COPY WNCPYSRC,SETRADNC02
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSINST - ACCESS INSTRUMENT DETAILS                           *
      *****************************************************************
     C     ACSINST       BEGSR
 
      * Access Security details
 
     C     TDSS          CHAIN     SECTYDF                            99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     TDSS          DBKEY
     C                   MOVEL     'SECTYD'      DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      * Security report name
 
     C**********         MOVEL     SRPN          DDSRPN                                       CSE016
      *                                                                                       CSE016
      ** Format security report description                                                   CSE016
      *                                                                                       CSE016
     C     SRPN          IFNE      *BLANKS                                                    CSE016
      *                                                                                       CSE016
     C                   CALLB     'ZSDESC'                                                   CSE016
     C                   PARM      SRPN          PSRPN                                        CSE016
     C                   PARM                    PSFN1                                        CSE016
     C                   PARM                    PSFN2                                        CSE016
     C                   PARM                    CPNR                                         CSE016
     C                   PARM                    MATY                                         CSE016
     C                   PARM                    SCPP                                         CSE016
     C                   PARM                    SCPD                                         CSE016
     C                   PARM      BVRIDF        PRSFD                                        CSE016
     C                   PARM                    SCPI                                         CSE016
     C                   PARM                    PRNME                                        CSE016
     C                   PARM                    PFNM1                                        CSE016
     C                   PARM                    PFNM2                                        CSE016
     C                   PARM                    PFNM3                                        CSE016
      *                                                                                       CSE016
     C                   EVAL      DDSRNME = PRNME                                            CSE016
     C                   ENDIF                                                                CSE016
 
      * Access Investment Type details
 
     C     KLINVT        CHAIN     INVTPDF                            99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     NMCY          DBKEY
     C                   MOVE      SITP          DBKEY
     C                   MOVEL     'INVTPD'      DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      * Get nominal currency details
 
     C                   MOVE      NMCY          @AJCD
     C                   EXSR      ACSCURR
 
     C                   MOVEL     A6SPRT        NomCcySPRT
     C                   Z-ADD     A6NBDP        NomCcyDec
     C                   MOVEL     A6MDIN        NomCcyMDIN
     C                   MOVEL     A6NQDP        NomCcyNQDP
     C                   MOVEL     A6SWCY        NomCcySWCY
     C                   MOVEL     A6CDFN        NomCcyCDFN
     C                   MOVEL     A6ECDN        NomCcyECDN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSCURR - ACCESS CURRENCY DETAILS                             *
      *****************************************************************
     C     ACSCURR       BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7                           S0111
     C                   PARM      '*KEY   '     @OPTN             7                           S0111
     C                   PARM                    @AJCD             3                           S0111
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0111
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSCUST - ACCESS CUSTOMER DETAILS                             *
      *****************************************************************
     C     ACSCUST       BEGSR
 
     C                   MOVEL     *BLANK        @KEY1
     C                   MOVEL     TCNR          @KEY1
 
     C*******************CALL      'AOCUSTR0'                                                 211800
     C                   CALL      'AOCUSTR1'                                                 211800
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM                    @KYST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                                        211800
     C     SDCUST        PARM      SDCUST        DSLDY                                        211800
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C     BBCLST        ANDNE     'Y'                                                        211800
     C                   MOVEL     TCNR          DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   CALL      'AOSECSR0'                                                  S0111
     C*******************PARM                    @RTCD             7                    S0111 211800
     C                   PARM      *BLANKS       @RTCD             7                          211800
     C                   PARM      '*KEY   '     @OPTN             7                           S0111
     C                   PARM      BBCUST        @SCKY             6                           S0111
     C     SDSECS        PARM      SDSECS        DSSDY                                         S0111
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     TCNR          DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   MOVE      BFCUST        CustNum
     C                   MOVE      BFACCD        CustAccd                                      S0111
     C                   MOVE      BFCYCD        CustCurr                                      S0111
     C                   MOVE      BFACSN        CustAcsq                                      S0111
     C                   MOVE      BFCLAS        CustClass                                     S0111
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVE      BFDRF1        CustDpRef1                                    S0111
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVE      BFDRF2        CustDpRef2                                    S0111
     C                   MOVE      BFPNP1        CustPNP1                                      S0111
     C                   MOVE      BFPNP2        CustPNP2                                      S0111
     C                   MOVE      BFTCD         CustTAXC                                      S0111
     C                   MOVE      BFASIN        CustAUTS                               E17228 S0111
     C                   MOVE      BFTDCG        CustTDCG                                      07845
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
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
      * Trade - file formats
     C                   PARM                    TradFilFmt
     C                   PARM                    TX1AFilFmt
     C                   PARM                    TX1BFilFmt
                                                                                              CAS006
      ** Switchable features                                                                  CAS006
                                                                                              CAS006
     C                   PARM                    CAS006                                       CAS006
      *                                                                                       CGL031
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * Output parameters
      *
      * Trade - screen formats
     C                   PARM                    TrPrim
     C                   PARM                    TrSeco
     C                   PARM                    TrThir                                       CAS006
     C                   PARM                    TrExch
     C                   PARM                    TrSett
     C                   PARM                    TrChCm
     C                   PARM                    TrSwft_A
     C                   PARM                    TrSwft_B
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTYDts
     C                   PARM                    INVTPDts
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
 
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14                           S0126
      * Security report name
      * Customer report name
     C**********         PARM                    DDSRPN           20                          CSE016
     C                   PARM                    DDSRNME          41                          CSE016
     C                   PARM                    DDCRNM           20
 
      * Coupon Rate
      * Current Factor
      * Margin Amount
      * Portfolio Exchange Rate
      * Portfolio M/D Ind
      * Trade Countervalue
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX           15            CSE023
     C                   PARM                    DDPRICN                                      CAS006
 
      * SCREEN A
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
 
      * SCREEN B
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
     C                   PARM                    DDFRNT                                    AR698195B
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
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
      *                                                                         CAC005
      ** Access Switchable features file for Profit Centre Accounting           CAC005
      ** SE Enhancement                                                         CAC005
      *                                                                         CAC005
     C                   CALL      'AOSARDR0'                                   CAC005
     C                   PARM      *BLANKS       @RTCD                          CAC005
     C                   PARM      '*VERIFY'     @OPTN                          CAC005
     C                   PARM      'CAC005'      @SARD             6            CAC005
      *                                                                         CAC005
      ** DATABASE ERROR                                                         CAC005
      *                                                                         CAC005
     C     @RTCD         IFNE      *BLANKS                                      CAC005
     C     @RTCD         ANDNE     '*NRF   '                                    CAC005
     C                   MOVEL     'CAC005'      DBKEY                          CAC005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CAC005
     C                   MOVEL     '904'         DBASE                          CAC005
     C                   EXSR      *PSSR                                        CAC005
     C                   END                                                    CAC005
     C     @RTCD         IFEQ      *BLANKS                                      CAC005
     C                   MOVE      'Y'           CAC005            1            CAC005
     C                   ELSE                                                   CAC005
     C                   MOVE      'N'           CAC005                         CAC005
     C                   ENDIF                                                  CAC005
      *                                                                         CSE023
      ** Check if enhancement 'Treaty withholding tax' is on.                   CSE023
      *                                                                         CSE023
     C                   CALLB     'AOSARDR0'                                   CSE023
     C                   PARM      *BLANKS       @RTCD                          CSE023
     C                   PARM      '*VERIFY'     @OPTN                          CSE023
     C                   PARM      'CSE023'      @SARD                          CSE023
      *                                                                         CSE023
      ** Check for Database error                                               CSE023
      *                                                                         CSE023
     C     @RTCD         IFNE      *BLANKS                                      CSE023
     C     @RTCD         ANDNE     '*NRF   '                                    CSE023
     C                   MOVEL     'CSE023'      DBKEY                          CSE023
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE023
     C                   MOVEL     '905'         DBASE                          CSE023
     C                   EXSR      *PSSR                                        CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         CSE023
     C     @RTCD         IFEQ      *BLANK                                       CSE023
     C                   MOVE      'Y'           CSE023            1            CSE023
     C                   ELSE                                                   CSE023
     C                   MOVE      'N'           CSE023                         CSE023
     C                   ENDIF                                                  CSE023
     C*
     C* Define key list for file INVTP
     C*
     C     KLINVT        KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
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
(c) Finastra International Limited 2001
