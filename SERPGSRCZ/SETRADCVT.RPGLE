000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Trade conversion file to screen format')      *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SETRADCVT - Trades Conversion: File to Screen Format         *
001100200529      *                                                               *
001200200529      *  Function:  This module converts the fields of a trade        *
001300200529      *             from their format as on file to a screen format.  *
001400200529      *                                                               *
001500200529      *  (c) Finastra International Limited 2001                      *
001600200529      *                                                               *
001700200604      *  Last Amend No. 249587             Date 22May20               *
001800200529      *  Prev Amend No. MD046248           Date 27Oct17               *
001900200529      *                 CSF011A            Date 28Nov11               *
002000200529      *                 CRE073             Date 06Dec10               *
002100200529      *                 AR698195B          Date 20Jan11               *
002200200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002300200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002400200529      *                 BUG13267           Date 09Feb07               *
002500200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002600200529      *                 CSD031             Date 10Apr06               *
002700200529      *                 CSD027             Date 09Dec05               *
002800200529      *                 CSE075             Date 17Nov05               *
002900200529      *                 232543             Date 15Mar05               *
003000200529      *                 CGL031             Date 05Jul04               *
003100200529      *                 CSE065             Date 08Nov04               *
003200200529      *                 CSE071             Date 19Jul05               *
003300200529      *                 229192             Date 27Aug04               *
003400200529      *                 211800             Date 12Nov02               *
003500200529      *                 CSW037A            Date 02May05               *
003600200529      *                 CSD025             Date 11Jan05               *
003700200529      *                 CSW037             Date 15Dec04               *
003800200529      *                 CSW036             Date 15Dec04               *
003900200529      *                 BUG3122            Date 17Jul04               *
004000200529      *                 CLE025             Date 20Oct03               *
004100200529      *                 CAP084             Date 10Jul03               *
004200200529      *                 CSE039             Date 04Apr03               *
004300200529      *                 CAS006             Date 21Jan03               *
004400200529      * Midas Release 4.01.02 ----------------------------------------*
004500200529      *                 200614             Date 19Apr02               *
004600200529      * Midas Release 4.01 -------------------------------------------*
004700200529      *                 CSE031             Date 13Dec01               *
004800200529      *                 196903             Date 22Aug01               *
004900200529      * Midas Release 4 --------------- Base -------------------------*
005000200529      *                 CSE028             Date 06Jun01               *
005100200529      *                 CSE022             Date 29Mar01               *
005200200529      *                 CSE016             Date 10Jan01               *
005300200529      * Midas DBA 3.05 -----------------------------------------------*
005400200529      *                 CSD006             Date 15May01               *
005500200529      *                 188447             Date 09Jan00               *
005600200529      * Midas DBA 3.04 -----------------------------------------------*
005700200529      *                 CSE023             Date 12Jul00               *
005800200529      *                 175216             Date 12Sep00               *
005900200529      * Midas DBA 3.03 -----------------------------------------------*
006000200529      *                 CAP137             Date 07Feb00               *
006100200529      * Midas DBA 3.02 -----------------------------------------------*
006200200529      *                 CAP051             Date 16Nov99               *
006300200529      *                 CPB001             Date 17Aug99               *
006400200529      * Midas DBA 3.00 ---------------- Base -------------------------*
006500200529      *                 CPL002             Date 08Mar99               *
006600200529      *                 CAC005             Date 23Nov98               *
006700200529      *                 CAP003  *CREATE    Date 22Apr98               *
006800200529      *                                                               *
006900200529      *---------------------------------------------------------------*
007000200529      *                                                               *
007100200529      *  249587 - Commission code amount should be zero and not       *
007200200529      *           blanks if Commission code is also entered.          *
007300200529      *  MD046248 - Finastra Rebranding                               *
007400200529      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
007500200529      *            (Recompile)                                        *
007600200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
007700200529      *  AR698195B - Added Front Office field on the buffer for TRADS *
007800200529      *             (Child: AR698196)                                 *
007900200529      *  BUG13267-DDSTAT and DDAUTH are often blank for transactions  *
008000200529      *         - that shows status of 'Authorised' on listview       *
008100200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
008200200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
008300200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
008400200529      *           (Recompile)                                         *
008500200529      *  232543 - Fix to CGL031                                       *
008600200529      *  CGL031 - Taxation of Savings Income                          *
008700200529      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
008800200529      *           (Recompile)                                         *
008900200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
009000200529      *  229192 - Use the nominal currency dec. place to edit the     *
009100200529      *           N-T-R Int Amt field.                                *
009200200529      *  211800 - If customer is flagged as 'Closed' Customer is not  *
009300200529      *           filled up.                                          *
009400200529      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
009500200529      *  CSD025 - Customer De-Activation                              *
009600200529      *  CSW037 - Additional Field Data on MT300/MT320                *
009700200529      *  CSW036 - Dual SWIFT BIC held on Client Details               *
009800200529      *  BUG3122 - Renamed the field SEZONE in SDSECS data structure  *
009900200529      *            to avoid compilation error.                        *
010000200529      *  CLE025 - Credit Lines (Recompile)                            *
010100200529      *  CAP084 - Synchronous calling of APIs                         *
010200200529      *           Some field is not being converted due to add        *
010300200529      *           condition. Therefore remove condition.              *
010400200529      *  CSE039 - Auto-settlement of trades                           *
010500200529      *         - Recompiled due to change in SETRSEPD                *
010600200529      *  CAS006 - Hedge Accounting Phase B                            *
010700200529      *  200614 - Blank DDGMES, DDTRTT, DDGMEC and DDCCID when trade  *
010800200529      *           comes from City Dealer. Default these values during *
010900200529      *           amendment.                                          *
011000200529      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
011100200529      *           Recompiled due to changes in SECTYD.                *
011200200529      *  196903 - Manage the status of the trade                      *
011300200529      *  CSE028 - Standing Settlement Instructions Enhancement.       *
011400200529      *  CSE022 - Depository Definition Enhancement                   *
011500200529      *  CSE016 - Extended Security Descriptions                      *
011600200529      *  CSD006 - Market Data Feed (Recompiled)                       *
011700200529      *  188447 - Impossible to delete a trade using new API          *
011800200529      *  CSE023 - Treaty Withholding Tax.                             *
011900200529      *  175216 - Add additional field for "Standing Instructions     *
012000200529      *           Override" missed at SWIFT 98 change.                *
012100200529      *  CAP137 - Conversion of SE Security inputs into modular       *
012200200529      *           structure to use as APIs (SECTYD)                   *
012300200529      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
012400200529      *           Recompiled due to database changes                  *
012500200529      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
012600200529      *           Recompiled due to database changes                  *
012700200529      *         - 'Private Banking' Module                            *
012800200529      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
012900200529      *  CAC005 - Profit Centre Accounting - SE Enhancement           *
013000200529      *  CAP003 - Conversion of MM inputs into modular structure to   *
013100200529      *           use as APIs.                                        *
013200200529      *                                                               *
013300200529      *****************************************************************
013400200529
013500200529     FSECTY     IF   E           K DISK
013600200529     FINVTP     IF   E           K DISK
013700200529
013800200529      *****************************************************************
013900200529      ** +--------------------------------------+
014000200529      ** ¦ Automatically included D-specs       ¦
014100200529      ** ¦ ==============================       ¦
014200200529      ** +--------------------------------------+
014300200529      **
014400200529      **--------------------------------------------------------------------------------------------
014500200529      ** The following /COPY line includes (among others) the LDA layout
014600200529      ** and the copyright array definition:
014700200529     D/COPY ZACPYSRC,STD_D_SPEC
014800200529      **--------------------------------------------------------------------------------------------
014900200529
015000200529      **--------------------------------------------------------------------------------------------
015100200529      ** The following /COPY includes the MM standard declares:
015200200529     D/COPY ZACPYSRC,STDDECLARE
015300200529      **--------------------------------------------------------------------------------------------
015400200529
015500200529      **--------------------------------------------------------------------------------------------
015600200529      ** The following /COPY line includes all the defined fields in the
015700200529      ** Program Status Data Structures.  They have meaningful
015800200529      ** names, prefixed by 'PS'.
015900200529     D/COPY ZACPYSRC,PSDS
016000200529      **--------------------------------------------------------------------------------------------
016100200529
016200200529      ** +--------------------------------------+
016300200529      ** ¦ End of automatically included D-specs¦
016400200529      ** ¦ =====================================¦
016500200529      ** +--------------------------------------+
016600200529
016700200529      *****************************************************************
016800200529      /EJECT
016900200529      *****************************************************************
017000200529
017100200529      ** +--------------------------------------+
017200200529      ** ¦ Manually included D-specs            ¦
017300200529      ** ¦ =========================            ¦
017400200529      ** +--------------------------------------+
017500200529
017600200529      ** +--------------------------------------+
017700200529      ** ¦ Named constants                      ¦
017800200529      ** ¦ ===============                      ¦
017900200529      ** +--------------------------------------+
018000200529
018100200529      ** +--------------------------------------+
018200200529      ** ¦ Arrays and Data Structures           ¦
018300200529      ** ¦ ==========================           ¦
018400200529      ** +--------------------------------------+
018500200529
018600200529      * Trade - File Formats
018700200529     D TradFilFmt    E DS                  EXTNAME(TRADSD)
018800200529     D TRD_REPI      E                     EXTFLD(REPI)                         CPB001
018900200529     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
019000200529     D                                     PREFIX(A_)
019100200529     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
019200200529     D                                     PREFIX(B_)
019300200529
019400200529      * Trade - Screen Formats
019500200529     D TrPrim        E DS                  EXTNAME(SETRPRPD)
019600200529     D TrSeco        E DS                  EXTNAME(SETRSEPD)
019700200529     D TrThir        E DS                  EXTNAME(SETRTHPD)                                  CAS006
019800200529     D TrExch        E DS                  EXTNAME(SETREXPD)
019900200529     D TrSett        E DS                  EXTNAME(SETRSTPD)
020000200529     D XX_DDCLTY     E                     EXTFLD(DDCLTY)
020100200529     D TrChCm        E DS                  EXTNAME(SETRCCPD)
020200200529     D TrSwft_A      E DS                  EXTNAME(SETRSWPD)
020300200529     D                                     PREFIX(A_)
020400200529     D TrSwft_B      E DS                  EXTNAME(SETRSWPD)
020500200529     D                                     PREFIX(B_)
020600200529
020700200529
020800200529      ** Security Details
020900200529     D SECTYDts      E DS                  EXTNAME(SECTYD)
021000200529     D SEC_RECI      E                     EXTFLD(RECI)
021100200529     D SEC_ZZ005     E                     EXTFLD(ZZ005)
021200200529     D SEC_LCD       E                     EXTFLD(LCD)
021300200529     D SEC_CHTP      E                     EXTFLD(CHTP)
021400200529     D SEC_TNLU      E                     EXTFLD(TNLU)
021500200529     D SEC_REPI      E                     EXTFLD(REPI)                         CPB001
021600200529     D SEC_FRNT      E                     EXTFLD(FRNT)                                       CAP137
021700200529     D SEC_REPA      E                     EXTFLD(REPA)                                       CAP137
021800200529     D SEC_TMST      E                     EXTFLD(TMST)                                       CAP137
021900200529
022000200529      ** Investment Type Details
022100200529     D INVTPDts      E DS                  EXTNAME(INVTPD)
022200200529     D INV_RECI      E                     EXTFLD(RECI)
022300200529     D INV_LCD       E                     EXTFLD(LCD)
022400200529     D INV_CHTP      E                     EXTFLD(CHTP)
022500200529     D INV_TNLU      E                     EXTFLD(TNLU)
022600200529     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
022700200529
022800200529
022900200529      ** The following /COPY includes the customer details data structure
023000200529     D/COPY SECPYSRC,SE_CUSTDT
023100200529      ** The following /COPY includes the currency details data structures
023200200529     D/COPY SECPYSRC,SE_CCYDT
023300200529
023400200529
023500200529      ** Array used to move right Swift Id.
023600200529     D ROU             S              1    DIM(12)
023700200529
023800200529      ** Array used to left-align countervalue.
023900200529     D                 DS                                                       E20653
024000200529     D  CTR                    1     21                                         E20653
024100200529     D                                     DIM(21)                              COUNTERVALUE     E20
024200200529
024300200529
024400200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
024500200529      ** EXTERNAL DS FOR BANK DETAILS
024600200529
024700200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
024800200529      ** EXTERNAL DS FOR BANK DETAILS
024900200529
025000200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
025100200529      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
025200200529
025300200529     D SDPORT        E DS                  EXTNAME(SDPORTPD)
025400200529      ** EXTERNAL DS FOR Portfolio Management DETAILS
025500200529
025600200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
025700200529      ** EXTERNAL DS FOR CUSTOMER DETAILS
025800200529
025900200529     D SDSECS        E DS                  EXTNAME(SDSECSPD)
026000200529     D BFZONE        E                     EXTFLD(SEZONE)
026100200529      ** EXTERNAL DS FOR SECURITIES CUSTOMER DETAILS
026200200529
026300200529     D SDCURR        E DS                  EXTNAME(SDCURRPD)
026400200529      ** EXTERNAL DS FOR CURRENCY DETAILS
026500200529
026600200529     D DSFDY         E DS                  EXTNAME(DSFDY)
026700200529      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
026800200529
026900200529     D DSSDY         E DS                  EXTNAME(DSSDY)
027000200529      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
027100200529                                                                                211800
027200200529     D DSLDY         E DS                  EXTNAME(DSLDY)                       211800
027300200529      ** FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                      211800
027400200529
027500200529      ** +--------------------------------------+
027600200529      ** ¦ Declared variables                   ¦
027700200529      ** ¦ ==================                   ¦
027800200529      ** +--------------------------------------+
027900200529                                                                                              CSE016
028000200529      ** Parameter declaration of ZSDESC                                                      CSE016
028100200529                                                                                              CSE016
028200200529     D PSRPN           S             20A                                                      CSE016
028300200529     D PSFN1           S             30A                                                      CSE016
028400200529     D PSFN2           S             30A                                                      CSE016
028500200529     D PRSFD           S              1A                                                      CSE016
028600200529     D PRNME           S             41A                                                      CSE016
028700200529     D PFNM1           S             30A                                                      CSE016
028800200529     D PFNM2           S             50A                                                      CSE016
028900200529     D PFNM3           S             50A                                                      CSE016
029000200529                                                                                              CAS006
029100200529     D CAS006          S              1                                                       CAS006
029200200529     D DDPRICN         S             17                                                       CAS006
029300200529                                                                                              CGL031
029400200529      ** CGL031 flag                                                                          CGL031
029500200529     D CGL031          S              1A                                                      CGL031
029600200529      ** Front office id variable.                                                         AR698195B
029700200529     D DDFRNT          S             20A                                                   AR698195B
029800200529
029900200529      ** +--------------------------------------+
030000200529      ** ¦ End of D-specs                       ¦
030100200529      ** ¦ ==============                       ¦
030200200529      ** +--------------------------------------+
030300200529      *****************************************************************
030400200529
030500200529      *  Rename common field names in SECTY & INVTP
030600200529      *
030700200529     ISECTYDF
030800200529     I              RECI                        SEC_RECI
030900200529     I              CHTP                        SEC_CHTP
031000200529     I              LCD                         SEC_LCD
031100200529     I              TNLU                        SEC_TNLU
031200200529     I              TMST                        SEC_TMST                        188447
031300200529     I              REPI                        SEC_REPI                        188447
031400200529     I              FRNT                        SEC_FRNT                        188447
031500200529     I              REPA                        SEC_REPA                        188447
031600200529      *
031700200529     IINVTPDF
031800200529     I              RECI                        INV_RECI
031900200529     I              CHTP                        INV_CHTP
032000200529     I              LCD                         INV_LCD
032100200529     I              TNLU                        INV_TNLU
032200200529
032300200529      **************************************************************
032400200529      /EJECT
032500200529     C**************************************************************
032600200529      *
032700200529      * INITIALIZATION
032800200529      *
032900200529     C                   EXSR      INIT
033000200529      *
033100200529      ** SET PRIMARY SCREEN FIELDS
033200200529      *
033300200529     C                   EXSR      SCN_PRIM
033400200529      *
033500200529      ** SET SECONDARY SCREEN FIELDS
033600200529      *
033700200529     C                   EXSR      SCN_SECO
033800200529                                                                                              CAS006
033900200529      ** Set Third screen fields                                                              CAS006
034000200529                                                                                              CAS006
034100200529     C                   IF        CAS006 = 'Y'                                               CAS006
034200200529     C                   EXSR      SCN_THIR                                                   CAS006
034300200529     C                   ENDIF                                                                CAS006
034400200529      *
034500200529      ** SET EXCHANGE RATE SCREEN FIELDS
034600200529      *
034700200529     C                   EXSR      SCN_EXCH
034800200529      *
034900200529      ** SET SETTLEMENTS SCREEN FIELDS
035000200529      *
035100200529     C                   EXSR      SCN_SETI
035200200529      *
035300200529      ** SET CHARGES & COMMISSION FIELDS
035400200529      *
035500200529     C                   EXSR      SCN_CHCM
035600200529      *
035700200529      ** SET SWIFT SCREEN FIELDS - Screen A
035800200529      *
035900200529     C                   EXSR      SCN_SWFTA
036000200529      *
036100200529      ** SET SWIFT SCREEN FIELDS - Screen B
036200200529      *
036300200529     C                   EXSR      SCN_SWFTB
036400200529      *
036500200529      ** TRADE STATUS
036600200529      *
036700200529     C                   EXSR      TRADSTAT
036800200529      *
036900200529      * Return
037000200529      *
037100200529     C                   RETURN
037200200529      *
037300200529      *****************************************************************
037400200529      /EJECT
037500200529      *****************************************************************
037600200529      ** SCN_PRIM - SET PRIMARY SCREEN FIELDS
037700200529      *****************************************************************
037800200529     C     SCN_PRIM      BEGSR
037900200529
038000200529      *  Trade Reference
038100200529     C                   MOVE      TDRF          DDTDRF
038200200529
038300200529      *  Bulk Reference
038400200529     C                   MOVE      BLKR          DDBLKR
038500200529
038600200529      *  Security Shortname
038700200529     C                   MOVEL     TDSS          DDSESN
038800200529     C                   EXSR      ACSINST
038900200529
039000200529      *  Customer number/name
039100200529
039200200529     C*****TCNR*         IFNE      *ZEROS                                                     CSD027
039300200529     C     TCNR          IFNE      *BLANKS                                                    CSD027
039400200529     C                   MOVEL     TCNR          DDCNUM
039500200529     C                   EXSR      ACSCUST
039600200529     C                   MOVEL     BBCRNM        DDCRNM
039700200529     C/COPY WNCPYSRC,SETRADNC03
039800200529     C                   END
039900200529      *
040000200529      *  Incomplete indicator
040100200529     C                   MOVE      TINC          DDINCS
040200200529      *
040300200529      *  Trade type
040400200529     C                   MOVE      TDTP          DDTDTP
040500200529      *
040600200529      *  Nominal
040700200529     C                   MOVE      *BLANKS       ZFIELD
040800200529     C                   MOVE      NOML          ZFIELD
040900200529     C                   Z-ADD     TNMD          ZADEC
041000200529     C                   EXSR      ZEDIT
041100200529     C                   MOVE      ZFIELD        DDNOML
041200200529      *
041300200529      *  Price/Discount/Yield
041400200529     C                   MOVE      *BLANKS       ZFIELD
041500200529     C                   MOVE      TPDY          ZFIELD
041600200529     C                   Z-ADD     8             ZADEC
041700200529     C                   EXSR      ZEDIT
041800200529     C                   MOVE      ZFIELD        DDTPDY
041900200529      *
042000200529      *  Value date
042100200529     C                   Z-ADD     TDVD          ZDAYNO
042200200529     C                   EXSR      ZDATE2
042300200529     C     DDACTN        IFEQ      'E'
042400200529     C     DDACTN        OREQ      'D'
042500200529     C                   MOVE      ZADATE        DDTDVD
042600200529     C                   ELSE
042700200529     C                   MOVEL     ZDATE         DDTDVD
042800200529     C                   END
042900200529      *
043000200529      *  Branch code
043100200529     C                   MOVEL     TDBA          DDBRCD
043200200529      *
043300200529      *  Book
043400200529     C                   MOVEL     TDBK          DDBPBK
043500200529      *                                                                         CAC005
043600200529      ** Recover user book from book on trade                                   CAC005
043700200529      *                                                                         CAC005
043800200529     C     CAC005        IFEQ      'Y'                                          CAC005
043900200529     C                   CALL      'AOBKPCR0'                                   CAC005
044000200529     C                   PARM      *BLANKS       P@RTCD            7            CAC005
044100200529     C                   PARM      '*USER  '     P@OPTN            7            CAC005
044200200529     C                   PARM                    P@BKCD            2            CAC005
044300200529     C                   PARM                    P@PRFC            4            CAC005
044400200529     C                   PARM      TDBK          P@PSBK            2            CAC005
044500200529     C     P@RTCD        IFEQ      *BLANKS                                      CAC005
044600200529     C                   MOVEL     P@BKCD        DDBPBK                         CAC005
044700200529     C                   ENDIF                                                  CAC005
044800200529     C                   ENDIF                                                  CAC005
044900200529      *
045000200529      *  Clearance type
045100200529     C                   MOVEL     CLTY          DDCLTY
045200200529     C                   MOVEL     CLTY          XX_DDCLTY
045300200529
045400200529     C                   ENDSR
045500200529      *****************************************************************
045600200529      /EJECT
045700200529      *****************************************************************
045800200529      ** SCN_SECO - SET SECONDARY SCREEN FIELDS
045900200529      *****************************************************************
046000200529     C     SCN_SECO      BEGSR
046100200529      *
046200200529     C                   EVAL      DDFRNT = FRNT                                           AR698195B
046300200529                                                                                           AR698195B
046400200529      *  Settlement currency
046500200529     C                   MOVEL     SETC          DDSETC
046600200529
046700200529      *  Get settlement currency details
046800200529
046900200529     C     DDSETC        IFNE      NMCY
047000200529
047100200529     C                   MOVE      DDSETC        @AJCD
047200200529     C                   EXSR      ACSCURR
047300200529
047400200529     C                   MOVEL     A6SPRT        SetCcySPRT
047500200529     C                   Z-ADD     A6NBDP        SetCcyDec
047600200529     C                   MOVEL     A6MDIN        SetCcyMDIN
047700200529     C                   MOVEL     A6NQDP        SetCcyNQDP
047800200529     C                   MOVEL     A6SWCY        SetCcySWCY
047900200529     C                   MOVEL     A6CDFN        SetCcyCDFN
048000200529     C                   MOVEL     A6ECDN        SetCcyECDN
048100200529
048200200529     C                   ELSE
048300200529
048400200529     C                   MOVEL     NomCcyDts     SetCcyDts
048500200529
048600200529     C                   END
048700200529      *
048800200529      *  Reallowance
048900200529     C     RALL          IFNE      *ZEROS
049000200529     C                   MOVE      *BLANKS       ZFLD15
049100200529     C                   MOVE      RALL          ZFLD15
049200200529     C                   Z-ADD     5             ZDECS
049300200529     C                   MOVE      *BLANK        ZECODE
049400200529     C                   EXSR      ZSEDIT
049500200529     C                   MOVE      ZOUT21        DDRALL
049600200529     C                   END
049700200529      *
049800200529      *  Market centre
049900200529     C                   MOVEL     TMKC          DDMRKT
050000200529      *
050100200529      *  Capacity
050200200529     C                   MOVEL     TCAP          DDCPCY
050300200529      *
050400200529      *  Price
050500200529     C     STBS          IFEQ      'D'
050600200529     C     STBS          OREQ      'Y'
050700200529     C     PRIC          IFNE      *ZEROS
050800200529     C                   MOVE(P)   *BLANKS       ZFIELD
050900200529     C                   MOVE(P)   PRIC          ZFIELD
051000200529     C                   Z-ADD     8             ZADEC
051100200529     C                   EXSR      ZEDIT
051200200529     C                   MOVE      ZFIELD        DDPRIC
051300200529     C                   END
051400200529     C                   END
051500200529      *
051600200529      *  Ex dividend
051700200529     C     PROT          IFEQ      '4'
051800200529     C     PROT          OREQ      '7'
051900200529     C                   MOVE      EXDV          DDEXDV
052000200529     C                   END
052100200529      *                                                                                       CGL031
052200200529      ** CGL031 Feature is ON                                                                 CGL031
052300200529     C     CGL031        IFEQ      'Y'                                                        CGL031
052400200529      *                                                                                       CGL031
052500200529      ** Fiscal Price                                                                         CGL031
052600200529      *                                                                                       CGL031
052700200529     C                   MOVE      *BLANKS       DDFSPR                                       CGL031
052800200529     C     FSPR          IFNE      *ZEROS                                                     CGL031
052900200529     C                   MOVE(P)   *BLANKS       ZFIELD                                       CGL031
053000200529     C                   MOVE(P)   FSPR          ZFIELD                                       CGL031
053100200529     C                   Z-ADD     8             ZADEC                                        CGL031
053200200529     C                   EXSR      ZEDIT                                                      CGL031
053300200529     C                   MOVE      ZFIELD        DDFSPR                                       CGL031
053400200529     C                   END                                                                  CGL031
053500200529      *                                                                                       CGL031
053600200529      ** EU Tax                                                                               CGL031
053700200529      *                                                                                       CGL031
053800200529     C                   MOVE      *BLANKS       DDEUTX                                       CGL031
053900200529     C     TDTP          IFEQ      'TP'                                                       CGL031
054000200529     C     EUTX          ANDNE     *ZEROS                                                     CGL031
054100200529     C                   MOVE(P)   *BLANKS       ZFIELD                                       CGL031
054200200529     C                   MOVE(P)   EUTX          ZFIELD                                       CGL031
054300200529     C**********         Z-ADD     TNMD          ZADEC                                 CGL031 232543
054400200529     C                   MOVE      NMCY          @AJCD                                        232543
054500200529     C                   EXSR      ACSCURR                                                    232543
054600200529     C                   Z-ADD     A6NBDP        ZADEC                                        232543
054700200529     C                   EXSR      ZEDIT                                                      CGL031
054800200529     C                   MOVE      ZFIELD        DDEUTX                                       CGL031
054900200529     C                   END                                                                  CGL031
055000200529     C                   END                                                                  CGL031
055100200529      *
055200200529      ** If Analytical Accounting Module is present, setup Booking
055300200529      ** and Transaction Profit Centre
055400200529      *
055500200529     C     BGN0ST        IFEQ      'Y'
055600200529     C                   MOVE      BPRC          DDBPRC
055700200529     C*****CustClass     IFEQ      'S'                                                        CAP084
055800200529     C*****CustClass     OREQ      'D'                                                        CAP084
055900200529     C                   MOVE      TPRC          DDTPRC
056000200529     C*****              END                                                                  CAP084
056100200529     C                   END
056200200529      *
056300200529      *  Trader I.D.
056400200529     C                   MOVEL     TDID          DDTDID
056500200529      *
056600200529      *  Trade date
056700200529     C     TDDT          IFNE      *ZEROS
056800200529     C                   Z-ADD     TDDT          ZDAYNO
056900200529     C                   EXSR      ZDATE2
057000200529     C     DDACTN        IFEQ      'E'
057100200529     C     DDACTN        OREQ      'D'
057200200529     C                   MOVE      ZADATE        DDTDDT
057300200529     C                   ELSE
057400200529     C                   MOVEL     ZDATE         DDTDDT
057500200529     C                   END
057600200529     C                   END
057700200529      *
057800200529      *  Trade sub-type
057900200529     C                   MOVEL     TSUB          DDTSUB
058000200529      *
058100200529      *  Link reference
058200200529     C                   MOVEL     LKRF          DDLKRF
058300200529      *
058400200529      *  Market indicator
058500200529     C                   MOVEL     TDMI          DDTDMI
058600200529      *
058700200529      *  ISMA/IPMA
058800200529     C                   MOVEL     AIIP          DDAIIP
058900200529      *
059000200529      *  Narrative
059100200529     C                   MOVEL     TDNR          DDTDNR
059200200529      *  Private Banking Order Number                                           CPB001
059300200529     C                   MOVEL     ORDE          DDORDE                         CPB001
059400200529      *
059500200529      *  Current factor
059600200529     C     PROT          IFEQ      '8'
059700200529     C     TCFC          IFNE      *ZEROS
059800200529     C                   MOVE      *BLANKS       ZFLD15
059900200529     C                   MOVE      TCFC          ZFLD15
060000200529     C                   Z-ADD     TCFC          CFCT
060100200529     C                   Z-ADD     9             ZDECS
060200200529     C                   MOVE      *BLANK        ZECODE
060300200529     C                   EXSR      ZSEDIT
060400200529     C                   MOVE      ZOUT21        DDCFCT
060500200529     C                   END
060600200529     C                   END
060700200529      *
060800200529      *  If interest bearing ...
060900200529      *
061000200529     C     PROT          IFEQ      '1'
061100200529     C     PROT          OREQ      '3'
061200200529     C     PROT          OREQ      '5'
061300200529     C     PROT          OREQ      '6'
061400200529     C     PROT          OREQ      '8'
061500200529     C     PROT          OREQ      '9'
061600200529     C     STBS          IFEQ      'Y'
061700200529     C     STBS          OREQ      'P'
061800200529      *
061900200529      *  Accrued Indicator
062000200529     C                   MOVE      ACIN          DDACIN
062100200529      *
062200200529      *  Days adjustment
062300200529     C     DADJ          IFNE      *ZEROS
062400200529     C                   MOVE      *BLANKS       ZFLD15
062500200529     C                   MOVE      DADJ          ZFLD15
062600200529     C                   Z-ADD     0             ZDECS
062700200529     C                   MOVE      *BLANK        ZECODE
062800200529     C                   EXSR      ZSEDIT
062900200529     C                   MOVE      ZOUT21        DDDADJ
063000200529     C                   END
063100200529      *
063200200529      *  Actual Difference indicator
063300200529     C                   MOVE      ADIN          DDACTD
063400200529      *
063500200529      *  Interest amount
063600200529     C     ITRA          IFNE      *ZEROS
063700200529     C                   MOVE      *BLANKS       ZFLD15
063800200529     C                   MOVE      ITRA          ZFLD15
063900200529     C                   ELSE
064000200529     C                   MOVE      *ZERO         ZFLD15
064100200529     C                   END
064200200529     C                   Z-ADD     NomCcyDec     ZDECS
064300200529     C                   MOVE      *BLANK        ZECODE
064400200529     C                   EXSR      ZSEDIT
064500200529     C                   MOVE      ZOUT21        DDITRA
064600200529      *
064700200529      *  Coupon rate
064800200529     C     TDCR          IFNE      *ZEROS
064900200529     C                   MOVE      *BLANKS       ZFLD15
065000200529     C                   MOVE      TDCR          ZFLD15
065100200529     C                   Z-ADD     7             ZDECS
065200200529     C                   MOVE      *BLANK        ZECODE
065300200529     C                   EXSR      ZSEDIT
065400200529     C                   MOVE      ZOUT21        DDCPNR
065500200529     C                   END
065600200529
065700200529     C                   END
065800200529     C                   END
065900200529
066000200529     C                   ENDSR
066100200529      *****************************************************************
066200200529      /EJECT
066300200529      *****************************************************************                       CAS006
066400200529      ** SCN_THIR - SET THIRD SCREEN FIELDS                                                   CAS006
066500200529      *****************************************************************                       CAS006
066600200529                                                                                              CAS006
066700200529     C     SCN_THIR      BEGSR                                                                CAS006
066800200529                                                                                              CAS006
066900200529      ** Credit Risk Spread                                                                   CAS006
067000200529                                                                                              CAS006
067100200529     C                   IF        CRSK <> 0                                                  CAS006
067200200529     C                   MOVE      *BLANKS       ZFLD15                                       CAS006
067300200529     C                   MOVE      CRSK          ZFLD15                                       CAS006
067400200529     C                   Z-ADD     8             ZDECS                                        CAS006
067500200529     C                   MOVE      *BLANK        ZECODE                                       CAS006
067600200529     C                   EXSR      ZSEDIT                                                     CAS006
067700200529     C                   MOVE      ZOUT21        DDCRSK                                       CAS006
067800200529     C                   ENDIF                                                                CAS006
067900200529                                                                                              CAS006
068000200529      ** Liquidity Premium                                                                    CAS006
068100200529                                                                                              CAS006
068200200529     C                   IF        LQPR <> 0                                                  CAS006
068300200529     C                   MOVE      *BLANKS       ZFLD15                                       CAS006
068400200529     C                   MOVE      LQPR          ZFLD15                                       CAS006
068500200529     C                   Z-ADD     8             ZDECS                                        CAS006
068600200529     C                   MOVE      *BLANK        ZECODE                                       CAS006
068700200529     C                   EXSR      ZSEDIT                                                     CAS006
068800200529     C                   MOVE      ZOUT21        DDLQPR                                       CAS006
068900200529     C                   ENDIF                                                                CAS006
069000200529                                                                                              CAS006
069100200529      ** Net Treasury Price                                                                   CAS006
069200200529                                                                                              CAS006
069300200529     C                   IF        PRICN <> 0                                                 CAS006
069400200529     C                   MOVE      *BLANKS       ZFLD15                                       CAS006
069500200529     C                   MOVE      PRICN         ZFLD15                                       CAS006
069600200529     C                   Z-ADD     8             ZDECS                                        CAS006
069700200529     C                   MOVE      *BLANK        ZECODE                                       CAS006
069800200529     C                   EXSR      ZSEDIT                                                     CAS006
069900200529     C                   MOVE      ZOUT21        DDPRICN                                      CAS006
070000200529     C                   ENDIF                                                                CAS006
070100200529                                                                                              CAS006
070200200529      ** Format DDITRN only if security is interest bearing                                   CAS006
070300200529                                                                                              CAS006
070400200529     C     PROT          IFEQ      '1'                                                        CAS006
070500200529     C     PROT          OREQ      '3'                                                        CAS006
070600200529     C     PROT          OREQ      '5'                                                        CAS006
070700200529     C     PROT          OREQ      '6'                                                        CAS006
070800200529     C     PROT          OREQ      '8'                                                        CAS006
070900200529     C     PROT          OREQ      '9'                                                        CAS006
071000200529                                                                                              CAS006
071100200529     C     STBS          IFEQ      'Y'                                                        CAS006
071200200529     C     STBS          OREQ      'P'                                                        CAS006
071300200529                                                                                              CAS006
071400200529      ** Int. Amount Using Net Treasury Rate                                                  CAS006
071500200529                                                                                              CAS006
071600200529     C                   IF        ITRN <> 0                                                  CAS006
071700200529     C                   MOVE      *BLANKS       ZFLD15                                       CAS006
071800200529     C                   MOVE      ITRN          ZFLD15                                       CAS006
071900200529     C                   ELSE                                                                 CAS006
072000200529     C                   EVAL      ZFLD15 = 0                                                 CAS006
072100200529     C                   ENDIF                                                                CAS006
072200200529                                                                                              CAS006
072300200529     C**********         Z-ADD     SetCcyDec     ZDECS                                 CAS006 229192
072400200529     C                   Z-ADD     NomCcyDec     ZDECS                                        229192
072500200529     C                   MOVE      *BLANK        ZECODE                                       CAS006
072600200529     C                   EXSR      ZSEDIT                                                     CAS006
072700200529     C                   MOVE      ZOUT21        DDITRN                                       CAS006
072800200529     C                   ENDIF                                                                CAS006
072900200529     C                   ENDIF                                                                CAS006
073000200529                                                                                              CAS006
073100200529     C                   ENDSR                                                                CAS006
073200200529                                                                                              CAS006
073300200529      *****************************************************************                       CAS006
073400200529      /EJECT                                                                                  CAS006
073500200529      *****************************************************************
073600200529      ** SCN_EXCH - SET EXCHANGE RATE SCREEN FIELDS
073700200529      *****************************************************************
073800200529     C     SCN_EXCH      BEGSR
073900200529
074000200529      *  Exchange Rate
074100200529
074200200529     C     TDER          IFNE      *ZEROS
074300200529
074400200529     C                   MOVE      *BLANKS       ZFLD15
074500200529
074600200529     C     BGN0ST        IFNE      'Y'
074700200529     C     DDSETC        OREQ      NMCY
074800200529     C                   MOVE      TDER          ZFLD15
074900200529     C                   ELSE
075000200529     C     TDTP          IFEQ      'TP'
075100200529     C     TMDI          ANDEQ     'M'
075200200529     C     TDTP          OREQ      'TS'
075300200529     C     TMDI          ANDEQ     'D'
075400200529     C     TDER          ADD       FXMR          W_TDER           13 8
075500200529     C                   ELSE
075600200529     C     TDER          SUB       FXMR          W_TDER
075700200529     C                   END
075800200529     C                   MOVE      W_TDER        ZFLD15
075900200529     C                   END
076000200529      *
076100200529     C                   Z-ADD     8             ZDECS
076200200529     C                   MOVE      *BLANK        ZECODE
076300200529     C                   EXSR      ZSEDIT
076400200529     C                   MOVE      ZOUT21        DDTDER
076500200529     C                   END
076600200529
076700200529      *  M/D indicator
076800200529     C                   MOVE      TMDI          DDSMDI
076900200529
077000200529      *  Base currency rate
077100200529     C     TBCR          IFNE      *ZEROS
077200200529     C                   MOVE      *BLANKS       ZFLD15
077300200529     C                   MOVE      TBCR          ZFLD15
077400200529     C                   Z-ADD     8             ZDECS
077500200529     C                   MOVE      *BLANK        ZECODE
077600200529     C                   EXSR      ZSEDIT
077700200529     C                   MOVE      ZOUT21        DDBRTE
077800200529     C                   END
077900200529      *
078000200529      ** Margin points and amount.
078100200529      ** (only if profit centre accounting is present, and
078200200529      **  settlement currency is different from nominal currency)
078300200529      *
078400200529     C     BGN0ST        IFEQ      'Y'
078500200529     C     DDSETC        ANDNE     NMCY
078600200529      *
078700200529     C                   MOVE      *BLANKS       ZFIELD
078800200529     C                   MOVE      FXMP          ZFIELD
078900200529     C                   Z-ADD     2             ZADEC
079000200529     C                   EXSR      ZEDIT
079100200529     C                   MOVE      ZFIELD        DDFXMP
079200200529      *
079300200529     C                   MOVE      *BLANKS       ZFLD15
079400200529     C                   MOVE      MAMT          ZFLD15
079500200529     C                   Z-ADD     SetCcyDec     ZDECS
079600200529     C                   MOVE      'J'           ZECODE
079700200529     C                   EXSR      ZSEDIT
079800200529     C                   MOVE      ZOUT21        DDMAMT
079900200529      *
080000200529     C                   END
080100200529      *
080200200529      *  Originating Branch
080300200529      *
080400200529     C                   MOVE      ORBR          DDORBR
080500200529
080600200529     C                   ENDSR
080700200529      *****************************************************************
080800200529      /EJECT
080900200529      *****************************************************************
081000200529      ** SCN_SETI - SET SETTLEMENTS SCREEN FIELDS
081100200529      *****************************************************************
081200200529     C     SCN_SETI      BEGSR
081300200529      *
081400200529      *  Settlement method
081500200529     C                   MOVEL     SMTH          DDSMTH
081600200529     C/COPY WNCPYSRC,SETRADNC01
081700200529      *
081800200529      *  Pay from
081900200529     C                   MOVEL     PYFM          DDPYFM
082000200529      *
082100200529      *  Pay from branch
082200200529     C                   MOVEL     PYFA          DDPYFB
082300200529      *
082400200529      *  Pay to
082500200529     C                   MOVEL     PAYT          DDPAYT
082600200529      *
082700200529      *  Pay to branch
082800200529     C                   MOVEL     PYTA          DDPYTB
082900200529      *
083000200529      *  For a/c of
083100200529     C                   MOVEL     TDFA          DDTDFA
083200200529      *
083300200529      *  A/c sequence
083400200529     C     ASNM          IFNE      *ZEROS
083500200529     C                   MOVEL     ASNM          DDASNM
083600200529     C                   END
083700200529      *
083800200529      *  Deliver from
083900200529     C*****DELF*         IFNE      *ZEROS                                                     CSD027
084000200529     C     DELF          IFNE      *BLANKS                                                    CSD027
084100200529     C                   MOVEL     DELF          DDDELF
084200200529     C/COPY WNCPYSRC,SETRADNC04
084300200529     C                   END
084400200529      *
084500200529      *  Deliver to
084600200529     C*****DELT*         IFNE      *ZEROS                                                     CSD027
084700200529     C     DELT          IFNE      *BLANKS                                                    CSD027
084800200529     C                   MOVEL     DELT          DDDELT
084900200529     C/COPY WNCPYSRC,SETRADNC05
085000200529     C                   END
085100200529
085200200529      *  For a/c of (FROM)
085300200529     C                   MOVEL     DFFA          DDDFFA
085400200529     C/COPY WNCPYSRC,SETRADNC06
085500200529
085600200529      *  For a/c of (TO)
085700200529     C                   MOVEL     DTFA          DDDTFA
085800200529     C/COPY WNCPYSRC,SETRADNC07
085900200529      *
086000200529      *  Special instructions
086100200529     C                   MOVEL     TDSI          DDTDSI
086200200529      *
086300200529      *  Profit Centre
086400200529      *
086500200529     C     BGN0ST        IFNE      'Y'
086600200529     C                   MOVE      PRFC          DDPRFC
086700200529     C                   END
086800200529      *
086900200529      *  'In' Currency in field 72
087000200529      *
087100200529     C                   MOVE      ICCY          DDICCY
087200200529      *
087300200529      *  Priority code
087400200529     C                   MOVEL     PRYC          DDPRYC
087500200529      *
087600200529      *  Pay code
087700200529     C                   MOVEL     PCOD          DDPCOD
087800200529
087900200529      *  Auto-Settle indicator
088000200529     C                   MOVEL     AUTS          DDAUTS
088100200529
088200200529     C                   ENDSR
088300200529      *****************************************************************
088400200529      /EJECT
088500200529      *****************************************************************
088600200529      ** SCN_CHCM - SET CHARGES & COMMISSIONS SCREEN FIELDS
088700200529      *****************************************************************
088800200529     C     SCN_CHCM      BEGSR
088900200529      *
089000200529      *  For Charges/Commissions reverse signs for display if necessary.
089100200529      *
089200200529     C     CustClass     IFEQ      'M'
089300200529     C     TDTP          ANDEQ     'TS'
089400200529     C     CustClass     OREQ      'S'
089500200529     C     TDTP          ANDEQ     'TP'
089600200529     C     CustClass     OREQ      'D'
089700200529     C     TDTP          ANDEQ     'TP'
089800200529     C                   Z-SUB     TBCA          WTBCA            13 0
089900200529     C                   Z-SUB     TCCA          WTCCA            13 0
090000200529     C                   Z-SUB     TCA1          WTCA1            13 0
090100200529     C                   Z-SUB     TCA2          WTCA2            13 0
090200200529     C                   Z-SUB     TCA3          WTCA3            13 0
090300200529     C                   Z-SUB     TCA4          WTCA4            13 0
090400200529     C                   Z-SUB     TCA5          WTCA5            13 0
090500200529     C                   Z-SUB     TCA6          WTCA6            13 0
090600200529     C                   Z-SUB     TCA7          WTCA7            13 0
090700200529     C                   Z-SUB     TAXA          WTAXA            13 0
090800200529     C                   Z-SUB     BCMR          WBCMR            13 0
090900200529     C                   Z-SUB     CCMR          WCCMR            13 0
091000200529     C                   Z-SUB     TXRB          WTXRB            13 0
091100200529     C                   ELSE
091200200529     C                   Z-ADD     TBCA          WTBCA
091300200529     C                   Z-ADD     TCCA          WTCCA
091400200529     C                   Z-ADD     TCA1          WTCA1
091500200529     C                   Z-ADD     TCA2          WTCA2
091600200529     C                   Z-ADD     TCA3          WTCA3
091700200529     C                   Z-ADD     TCA4          WTCA4
091800200529     C                   Z-ADD     TCA5          WTCA5
091900200529     C                   Z-ADD     TCA6          WTCA6
092000200529     C                   Z-ADD     TCA7          WTCA7
092100200529     C                   Z-ADD     TAXA          WTAXA
092200200529     C                   Z-ADD     BCMR          WBCMR
092300200529     C                   Z-ADD     CCMR          WCCMR
092400200529     C                   Z-ADD     TXRB          WTXRB
092500200529     C                   END
092600200529      *
092700200529      *  Broker commission code
092800200529     C                   MOVEL     TBCC          DDTBCC
092900200529      *
093000200529      *  Broker commission amount
093100200529     C     WTBCA         IFNE      *ZEROS
093200200529     C     DDTBCC        ORNE      *BLANKS                                                    249587
093300200529     C                   MOVE      *BLANKS       ZFLD15
093400200529     C                   MOVE      WTBCA         ZFLD15
093500200529     C                   Z-ADD     NomCcyDec     ZDECS
093600200529     C                   MOVE      *BLANK        ZECODE
093700200529     C                   EXSR      ZSEDIT
093800200529     C                   MOVE      ZOUT21        DDTBCA
093900200529     C                   END
094000200529      *
094100200529      *  Customer commission code
094200200529     C                   MOVEL     TCCC          DDTCCC
094300200529      *
094400200529      *  Customer commission amount
094500200529     C     WTCCA         IFNE      *ZEROS
094600200529     C     DDTCCC        ORNE      *BLANKS                                                    249587
094700200529     C                   MOVE      *BLANKS       ZFLD15
094800200529     C                   MOVE      WTCCA         ZFLD15
094900200529     C                   Z-ADD     NomCcyDec     ZDECS
095000200529     C                   MOVE      *BLANK        ZECODE
095100200529     C                   EXSR      ZSEDIT
095200200529     C                   MOVE      ZOUT21        DDTCCA
095300200529     C                   END
095400200529      *
095500200529      *  Charges 1 code
095600200529     C                   MOVEL     TCC1          DDTCC1
095700200529      *
095800200529      *  Charges 1 amount
095900200529     C     WTCA1         IFNE      *ZEROS
096000200529     C     DDTCC1        ORNE      *BLANKS                                                    249587
096100200529     C                   MOVE      *BLANKS       ZFLD15
096200200529     C                   MOVE      WTCA1         ZFLD15
096300200529     C                   Z-ADD     NomCcyDec     ZDECS
096400200529     C                   MOVE      *BLANK        ZECODE
096500200529     C                   EXSR      ZSEDIT
096600200529     C                   MOVE      ZOUT21        DDTCA1
096700200529     C                   END
096800200529      *
096900200529      *  Charges 2 code
097000200529     C                   MOVEL     TCC2          DDTCC2
097100200529      *
097200200529     C*  Charges 2 amount
097300200529     C     WTCA2         IFNE      *ZEROS
097400200529     C     DDTCC2        ORNE      *BLANKS                                                    249587
097500200529     C                   MOVE      *BLANKS       ZFLD15
097600200529     C                   MOVE      WTCA2         ZFLD15
097700200529     C                   Z-ADD     NomCcyDec     ZDECS
097800200529     C                   MOVE      *BLANK        ZECODE
097900200529     C                   EXSR      ZSEDIT
098000200529     C                   MOVE      ZOUT21        DDTCA2
098100200529     C                   END
098200200529      *
098300200529      *  Charges 3 code
098400200529     C                   MOVEL     TCC3          DDTCC3
098500200529      *
098600200529      *  Charges 3 amount
098700200529     C     WTCA3         IFNE      *ZEROS
098800200529     C     DDTCC3        ORNE      *BLANKS                                                    249587
098900200529     C                   MOVE      *BLANKS       ZFLD15
099000200529     C                   MOVE      WTCA3         ZFLD15
099100200529     C                   Z-ADD     NomCcyDec     ZDECS
099200200529     C                   MOVE      *BLANK        ZECODE
099300200529     C                   EXSR      ZSEDIT
099400200529     C                   MOVE      ZOUT21        DDTCA3
099500200529     C                   END
099600200529      *
099700200529      *  Charges 4 code
099800200529     C                   MOVEL     TCC4          DDTCC4
099900200529      *
100000200529      *  Charges 4 amount
100100200529     C     WTCA4         IFNE      *ZEROS
100200200529     C     DDTCC4        ORNE      *BLANKS                                                    249587
100300200529     C                   MOVE      *BLANKS       ZFLD15
100400200529     C                   MOVE      WTCA4         ZFLD15
100500200529     C                   Z-ADD     NomCcyDec     ZDECS
100600200529     C                   MOVE      *BLANK        ZECODE
100700200529     C                   EXSR      ZSEDIT
100800200529     C                   MOVE      ZOUT21        DDTCA4
100900200529     C                   END
101000200529      *
101100200529      *  Charges 5 code
101200200529     C                   MOVEL     TCC5          DDTCC5
101300200529      *
101400200529      *  Charges 5 amount
101500200529     C     WTCA5         IFNE      *ZEROS
101600200529     C     DDTCC5        ORNE      *BLANKS                                                    249587
101700200529     C                   MOVE      *BLANKS       ZFLD15
101800200529     C                   MOVE      WTCA5         ZFLD15
101900200529     C                   Z-ADD     NomCcyDec     ZDECS
102000200529     C                   MOVE      *BLANK        ZECODE
102100200529     C                   EXSR      ZSEDIT
102200200529     C                   MOVE      ZOUT21        DDTCA5
102300200529     C                   END
102400200529      *
102500200529      *  Charges 6 code
102600200529     C                   MOVEL     TCC6          DDTCC6
102700200529      *
102800200529      *  Charges 6 amount
102900200529     C     WTCA6         IFNE      *ZEROS
103000200529     C     DDTCC6        ORNE      *BLANKS                                                    249587
103100200529     C                   MOVE      *BLANKS       ZFLD15
103200200529     C                   MOVE      WTCA6         ZFLD15
103300200529     C                   Z-ADD     NomCcyDec     ZDECS
103400200529     C                   MOVE      *BLANK        ZECODE
103500200529     C                   EXSR      ZSEDIT
103600200529     C                   MOVE      ZOUT21        DDTCA6
103700200529     C                   END
103800200529      *
103900200529      *  Charges 7 code
104000200529     C                   MOVEL     TCC7          DDTCC7
104100200529      *
104200200529      *  Charges 7 amount
104300200529     C     WTCA7         IFNE      *ZEROS
104400200529     C     DDTCC7        ORNE      *BLANKS                                                    249587
104500200529     C                   MOVE      *BLANKS       ZFLD15
104600200529     C                   MOVE      WTCA7         ZFLD15
104700200529     C                   Z-ADD     NomCcyDec     ZDECS
104800200529     C                   MOVE      *BLANK        ZECODE
104900200529     C                   EXSR      ZSEDIT
105000200529     C                   MOVE      ZOUT21        DDTCA7
105100200529     C                   END
105200200529      *
105300200529      *  Tax amount
105400200529     C     WTAXA         IFNE      *ZEROS
105500200529     C                   MOVE      *BLANKS       ZFLD15
105600200529     C                   MOVE      WTAXA         ZFLD15
105700200529     C                   Z-ADD     NomCcyDec     ZDECS
105800200529     C                   MOVE      *BLANK        ZECODE
105900200529     C                   EXSR      ZSEDIT
106000200529     C                   MOVE      ZOUT21        DDTAXA
106100200529     C                   END
106200200529      *
106300200529      *  Broker Commission Rebate
106400200529     C     WBCMR         IFNE      *ZEROS
106500200529     C                   MOVE      *BLANKS       ZFLD15
106600200529     C                   MOVE      WBCMR         ZFLD15
106700200529     C                   Z-ADD     NomCcyDec     ZDECS
106800200529     C                   MOVE      *BLANK        ZECODE
106900200529     C                   EXSR      ZSEDIT
107000200529     C                   MOVE      ZOUT21        DDBCMR
107100200529     C                   END
107200200529      *
107300200529      *  Customer Commission Rebate
107400200529     C     WCCMR         IFNE      *ZEROS
107500200529     C                   MOVE      *BLANKS       ZFLD15
107600200529     C                   MOVE      WCCMR         ZFLD15
107700200529     C                   Z-ADD     NomCcyDec     ZDECS
107800200529     C                   MOVE      *BLANK        ZECODE
107900200529     C                   EXSR      ZSEDIT
108000200529     C                   MOVE      ZOUT21        DDCCMR
108100200529     C                   END
108200200529      *
108300200529      *  Tax rebate
108400200529     C     WTXRB         IFNE      *ZEROS
108500200529     C                   MOVE      *BLANKS       ZFLD15
108600200529     C                   MOVE      WTXRB         ZFLD15
108700200529     C                   Z-ADD     NomCcyDec     ZDECS
108800200529     C                   MOVE      *BLANK        ZECODE
108900200529     C                   EXSR      ZSEDIT
109000200529     C                   MOVE      ZOUT21        DDTXRB
109100200529     C                   END
109200200529      *
109300200529      *  Countervalue
109400200529      *
109500200529     C     TCTR          IFNE      *ZEROS
109600200529      *
109700200529      *   Convert to settlement currency for screen display only.
109800200529      *
109900200529     C                   Z-ADD     TCTR          ZAMTCI
110000200529     C                   Z-ADD     TDER          ZEXCH
110100200529     C                   MOVE      TMDI          ZMD
110200200529     C                   MOVE      NMCY          ZCCYI
110300200529     C                   MOVE      DDSETC        ZCCYO
110400200529     C                   MOVE      NomCcyDec     ZCDPI
110500200529     C                   MOVE      SetCcyDec     ZCDPO
110600200529     C                   EXSR      ZCONV
110700200529     C                   Z-ADD     ZAMTCO        WTCTR            15 0
110800200529     C                   MOVE      *BLANKS       ZFLD15
110900200529     C                   MOVE      WTCTR         ZFLD15
111000200529     C                   Z-ADD     SetCcyDec     ZDECS
111100200529     C                   MOVE      'J'           ZECODE
111200200529     C                   MOVE      '*'           ZECHAR
111300200529     C                   EXSR      ZSEDITF
111400200529     C                   MOVE      ZOUT21        DDTCTR
111500200529     C                   EXSR      CNTL
111600200529     C                   END
111700200529      *                                                                         CSE023
111800200529      ** If treaty withholding tax is installed format amount.                  CSE023
111900200529      *                                                                         CSE023
112000200529     C                   IF        CSE023 = 'Y' AND WHTX <> *ZEROS              CSE023
112100200529     C                   MOVE      *BLANKS       ZFLD15                         CSE023
112200200529     C                   MOVE      WHTX          ZFLD15                         CSE023
112300200529     C                   Z-ADD     SetCcyDec     ZDECS                          CSE023
112400200529     C                   MOVE      'J'           ZECODE                         CSE023
112500200529     C                   MOVE      *BLANK        ZECHAR                         CSE023
112600200529     C                   EXSR      ZSEDITF                                      CSE023
112700200529     C                   MOVE      ZOUT21        DDWTAX                         CSE023
112800200529     C                   ELSE                                                   CSE023
112900200529     C                   MOVE      *BLANKS       DDWTAX                         CSE023
113000200529     C                   ENDIF                                                  CSE023
113100200529      *
113200200529      ** If portfolio management is present
113300200529      ** Or private banking module is present                                   CPB001
113400200529      *
113500200529     C     BGPFMG        IFEQ      'Y'
113600200529     C     BGN4ST        OREQ      'Y'                                          CPB001
113700200529
113800200529      * Portfolio ref.
113900200529     C     PTFR          IFEQ      '9997'
114000200529     C     BGN4ST        ANDNE     'Y'                                          CPB001
114100200529     C                   MOVE      FCR997        DDPTFR
114200200529     C                   ELSE
114300200529     C                   MOVE      PTFR          DDPTFR
114400200529     C                   END
114500200529      *
114600200529      * FX rate
114700200529     C     BGPFMG        IFEQ      'Y'                                          CPB001
114800200529     C     SPXR          IFNE      *ZEROS
114900200529     C                   MOVE      *BLANKS       ZFLD15
115000200529     C                   MOVE      SPXR          ZFLD15
115100200529     C                   Z-ADD     8             ZDECS
115200200529     C                   MOVE      *BLANK        ZECODE
115300200529     C                   EXSR      ZSEDIT
115400200529     C                   MOVE      ZOUT21        DDSPXR
115500200529     C                   END
115600200529     C                   ENDIF                                                  CPB001
115700200529      *
115800200529      * multiply/divide indicator
115900200529     C                   MOVE      SPMD          DDSPMD
116000200529     C                   END
116100200529
116200200529     C                   ENDSR
116300200529      *****************************************************************
116400200529      /EJECT
116500200529      *****************************************************************
116600200529      ** SCN_SWFTA - SET SWIFT SCREEN FIELDS - SCREEN A
116700200529      *****************************************************************
116800200529     C     SCN_SWFTA     BEGSR
116900200529      *
117000200529      ** Determine Settlements Network routing and addresses
117100200529      *
117200200529     C     TDTP          IFEQ      'TP'
117300200529     C                   MOVE      DELT          WSNDR
117400200529     C                   MOVE      DELT          WDEST
117500200529     C                   ELSE
117600200529     C                   MOVE      DELF          WSNDR
117700200529     C                   MOVE      DELF          WDEST
117800200529     C                   END
117900200529     C                   MOVE      SMTH          WSETP
118000200529      *
118100200529     C                   EXSR      SR1100
118200200529
118300200529      ** Destination of Settlement
118400200529
118500200529     C                   MOVE      WWROU         A_DDROUS
118600200529     C                   MOVE      WWROT         A_DDROTS
118700200529
118800200529      * Settlement Message Request
118900200529
119000200529     C     A_T1GMES      IFEQ      *BLANK                                                     200614
119100200529     C                   MOVE      'N'           A_T1GMES                                     200614
119200200529     C                   ENDIF                                                                200614
119300200529                                                                                              200614
119400200529     C                   MOVE      A_T1GMES      A_DDGMES
119500200529
119600200529      * Time of Trade
119700200529     C     A_T1TRTT      IFEQ      *BLANK                                                     200614
119800200529     C                   TIME                    WWTIME            6 0                        200614
119900200529     C                   MOVEL     WWTIME        A_T1TRTT                                     200614
120000200529     C                   ENDIF                                                                200614
120100200529     C                   MOVE      A_T1TRTT      A_DDTRTT
120200200529
120300200529      * Instructions Type
120400200529     C                   MOVE      A_T1INST      A_DDINST
120500200529
120600200529      * Instructions Sub-Type
120700200529     C                   MOVE      A_T1INSS      A_DDINSS
120800200529
120900200529      * Counterparty Euroclear/Cedel Code
121000200529     C                   MOVE      A_T1EUCL      A_DDEUCL
121100200529
121200200529      * Safekeeping A/C
121300200529     C                   MOVE      A_T1SAFA      A_DDSAFA
121400200529
121500200529      * Requested Priority
121600200529     C                   MOVE      A_T1RPTY      A_DDRPTY
121700200529
121800200529      * Guaranteed Delivery
121900200529     C                   MOVE      A_T1GDEL      A_DDGDEL
122000200529
122100200529      * Sender's Role
122200200529     C                   MOVE      A_T1SROL      A_DDSROL
122300200529
122400200529      * Fungibility Code
122500200529     C                   MOVE      A_T1FCOD      A_DDFCOD
122600200529
122700200529      * Fungible Trade Ind
122800200529     C                   MOVE      A_T1FTID      A_DDFTID
122900200529      *
123000200529      ** Determine Confirmation Network routing and addresses
123100200529      *
123200200529     C                   MOVE      TCNR          WSNDR
123300200529     C                   MOVE      TCNR          WDEST
123400200529     C                   MOVE      SMTH          WSETP
123500200529      *
123600200529     C                   EXSR      SR1100
123700200529
123800200529      ** Destination of Confirmation
123900200529
124000200529     C                   MOVE      WWROU         A_DDROUC
124100200529     C                   MOVE      WWROT         A_DDROTC
124200200529
124300200529      * Confirmation Message Request
124400200529                                                                                              200614
124500200529     C     A_T1GMEC      IFEQ      *BLANK                                                     200614
124600200529     C                   MOVE      'N'           A_T1GMEC                                     200614
124700200529     C                   ENDIF                                                                200614
124800200529                                                                                              200614
124900200529     C                   MOVE      A_T1GMEC      A_DDGMEC
125000200529
125100200529      * Customer/Counterparty Indicator                                      . -
125200200529     C     A_T1CCID      IFEQ      *BLANK                                                     200614
125300200529     C     BFCLAS        IFEQ      'M'                                                        200614
125400200529     C                   MOVE      'P'           A_T1CCID                                     200614
125500200529     C                   ELSE                                                                 200614
125600200529     C                   MOVE      'C'           A_T1CCID                                     200614
125700200529     C                   ENDIF                                                                200614
125800200529     C                   ENDIF                                                                200614
125900200529     C                   MOVE      A_T1CCID      A_DDCCID
126000200529
126100200529      * Further Identification (MT510)                                       . -
126200200529     C                   SELECT
126300200529     C     A_T1FID1      WHENEQ    ' FORWARD'
126400200529     C                   MOVE      'FORWARD '    A_DDFID1
126500200529     C     A_T1FID1      WHENEQ    '  OPTION'
126600200529     C                   MOVE      'OPTION  '    A_DDFID1
126700200529     C     A_T1FID1      WHENEQ    ' REGULAR'
126800200529     C                   MOVE      'REGULAR '    A_DDFID1
126900200529     C     A_T1FID1      WHENEQ    '    SPOT'
127000200529     C                   MOVE      'SPOT    '    A_DDFID1
127100200529     C                   OTHER
127200200529     C                   MOVE      A_T1FID1      A_DDFID1
127300200529      **Standing*Instruction*Override.*********************************                175216 CSE028
127400200529     C**********         MOVE      A_T1SIOR      A_DDIORA                              175216 CSE028
127500200529      **********                                                                       175216 CSE028
127600200529     C                   ENDSL
127700200529                                                                                              CSE028
127800200529      ** Standing Instruction Override                                                        CSE028
127900200529                                                                                              CSE028
128000200529     C                   EVAL      A_DDIORA = A_T1SIOR                                        CSE028
128100200529                                                                                              CSE028
128200200529      ** ISO15022 Messages Indicator                                                          CSE028
128300200529                                                                                              CSE028
128400200529     C                   EVAL      A_DDSNEW = A_T1NEW                                         CSE028
128500200529                                                                                              CSE028
128600200529      ** Stamp Status                                                                         CSE028
128700200529                                                                                              CSE028
128800200529     C                   EVAL      A_DDSTMP = A_T1STMP                                        CSE028
128900200529                                                                                              CSE028
129000200529      ** Charity Identifier                                                                   CSE028
129100200529                                                                                              CSE028
129200200529     C                   EVAL      A_DDCHID = A_T1CHID                                        CSE028
129300200529                                                                                              CSE028
129400200529      ** Transaction Report Marker                                                            CSE028
129500200529                                                                                              CSE028
129600200529     C                   EVAL      A_DDTRRM = A_T1TRRM                                        CSE028
129700200529
129800200529     C                   ENDSR
129900200529      *****************************************************************
130000200529      /EJECT
130100200529      *****************************************************************
130200200529      ** SCN_SWFTB - SET SWIFT SCREEN FIELDS - SCREEN B
130300200529      *****************************************************************
130400200529     C     SCN_SWFTB     BEGSR
130500200529      *
130600200529      ** Determine Settlements Network routing and addresses
130700200529      *
130800200529     C     TDTP          IFEQ      'TP'
130900200529     C                   MOVE      DELF          WSNDR
131000200529     C                   MOVE      DELF          WDEST
131100200529     C                   ELSE
131200200529     C                   MOVE      DELT          WSNDR
131300200529     C                   MOVE      DELT          WDEST
131400200529     C                   END
131500200529     C                   MOVE      SMTH          WSETP
131600200529      *
131700200529     C                   EXSR      SR1100
131800200529
131900200529      ** Destination of Settlement
132000200529
132100200529     C                   MOVE      WWROU         B_DDROUS
132200200529     C                   MOVE      WWROT         B_DDROTS
132300200529
132400200529      * Settlement Message Request
132500200529
132600200529     C                   MOVE      B_T1GMES      B_DDGMES
132700200529
132800200529      * Time of Trade
132900200529     C                   MOVE      B_T1TRTT      B_DDTRTT
133000200529
133100200529      * Instructions Type
133200200529     C                   MOVE      B_T1INST      B_DDINST
133300200529
133400200529      * Instructions Sub-Type
133500200529     C                   MOVE      B_T1INSS      B_DDINSS
133600200529
133700200529      * Counterparty Euroclear/Cedel Code
133800200529     C                   MOVE      B_T1EUCL      B_DDEUCL
133900200529
134000200529      * Safekeeping A/C
134100200529     C                   MOVE      B_T1SAFA      B_DDSAFA
134200200529
134300200529      * Requested Priority
134400200529     C                   MOVE      B_T1RPTY      B_DDRPTY
134500200529
134600200529      * Guaranteed Delivery
134700200529     C                   MOVE      B_T1GDEL      B_DDGDEL
134800200529
134900200529      * Sender's Role
135000200529     C                   MOVE      B_T1SROL      B_DDSROL
135100200529
135200200529      * Fungibility Code
135300200529     C                   MOVE      B_T1FCOD      B_DDFCOD
135400200529
135500200529      * Fungible Trade Ind
135600200529     C                   MOVE      B_T1FTID      B_DDFTID
135700200529      *
135800200529      ** Determine Confirmation Network routing and addresses
135900200529      *
136000200529     C                   MOVE      TCNR          WSNDR
136100200529     C                   MOVE      TCNR          WDEST
136200200529     C                   MOVE      SMTH          WSETP
136300200529      *
136400200529     C                   EXSR      SR1100
136500200529
136600200529      ** Destination of Confirmation
136700200529
136800200529     C                   MOVE      WWROU         B_DDROUC
136900200529     C                   MOVE      WWROT         B_DDROTC
137000200529
137100200529      * Confirmation Message Request
137200200529     C                   MOVE      B_T1GMEC      B_DDGMEC
137300200529
137400200529      * Customer/Counterparty Indicator                                      . -
137500200529     C                   MOVE      B_T1CCID      B_DDCCID
137600200529
137700200529      * Further Identification (MT510)                                       . -
137800200529     C                   SELECT
137900200529     C     B_T1FID1      WHENEQ    ' FORWARD'
138000200529     C                   MOVE      'FORWARD '    B_DDFID1
138100200529     C     B_T1FID1      WHENEQ    '  OPTION'
138200200529     C                   MOVE      'OPTION  '    B_DDFID1
138300200529     C     B_T1FID1      WHENEQ    ' REGULAR'
138400200529     C                   MOVE      'REGULAR '    B_DDFID1
138500200529     C     B_T1FID1      WHENEQ    '    SPOT'
138600200529     C                   MOVE      'SPOT    '    B_DDFID1
138700200529     C                   OTHER
138800200529     C                   MOVE      B_T1FID1      B_DDFID1
138900200529      **Standing*Instruction*Override.*********************************                175216 CSE028
139000200529     C**********         MOVE      B_T1SIOR      B_DDIORA                              175216 CSE028
139100200529      **********                                                                       175216 CSE028
139200200529     C                   ENDSL
139300200529                                                                                              CSE028
139400200529      ** Standing Instruction Override.                                                       CSE028
139500200529                                                                                              CSE028
139600200529     C                   EVAL      B_DDIORA = B_T1SIOR                                        CSE028
139700200529                                                                                              CSE028
139800200529      ** ISO15022 Messages Indicator                                                          CSE028
139900200529                                                                                              CSE028
140000200529     C                   EVAL      B_DDSNEW = B_T1NEW                                         CSE028
140100200529                                                                                              CSE028
140200200529      ** Stamp Status                                                                         CSE028
140300200529                                                                                              CSE028
140400200529     C                   EVAL      B_DDSTMP = B_T1STMP                                        CSE028
140500200529                                                                                              CSE028
140600200529      ** Charity Identifier                                                                   CSE028
140700200529                                                                                              CSE028
140800200529     C                   EVAL      B_DDCHID = B_T1CHID                                        CSE028
140900200529                                                                                              CSE028
141000200529      ** Transaction Report Marker                                                            CSE028
141100200529                                                                                              CSE028
141200200529     C                   EVAL      B_DDTRRM = B_T1TRRM                                        CSE028
141300200529
141400200529     C                   ENDSR
141500200529      *****************************************************************
141600200529      /EJECT
141700200529      *****************************************************************
141800200529      *                                                               *
141900200529      *  SR1100 - Determine Network and Addresses.                    *
142000200529      *                                                               *
142100200529      *****************************************************************
142200200529     C     SR1100        BEGSR
142300200529      *
142400200529     C                   CALL      'ZM1100'                             99
142500200529     C                   PARM                    WSNDR             6
142600200529     C                   PARM                    WSCSD            12
142700200529     C                   PARM                    WDEST             6
142800200529     C                   PARM                    WSETP             2
142900200529     C                   PARM      *BLANKS       WNWSN            20
143000200529     C                   PARM      *BLANKS       WNWDS            22
143100200529     C                   PARM      *BLANKS       WNWRK             6
143200200529     C                   PARM      *BLANKS       WERRC             1
143300200529     C                   PARM      *BLANKS       WSRNM            20
143400200529     C                   PARM      *BLANKS       WSRTN            10
143500200529     C                   PARM      *BLANKS       WDRNM            20
143600200529     C                   PARM      *BLANKS       WDRTN            10
143700200529      *
143800200529     C     WSNDR         IFNE      *BLANKS
143900200529     C     WDEST         ANDNE     *BLANKS
144000200529      *
144100200529     C     *IN99         IFEQ      '1'
144200200529     C     WERRC         OREQ      'S'
144300200529     C     WERRC         OREQ      'D'
144400200529     C     WNWRK         OREQ      'UNROUT'
144500200529      *
144600200529     C                   MOVEL     *BLANKS       WWROU             6
144700200529     C                   MOVEL     '  UNRO'      WWROT            12
144800200529     C                   MOVE      'UTABLE'      WWROT
144900200529     C                   ELSE
145000200529      *
145100200529     C                   MOVEL     WNWRK         WWROU
145200200529     C                   MOVEA     WNWDS         ROU
145300200529     C                   Z-ADD     1             J                 2 0
145400200529     C     ' '           LOOKUP    ROU(J)                                 99
145500200529     C     *IN99         IFEQ      '0'
145600200529     C                   MOVEL     WNWDS         WWROT
145700200529     C                   ELSE
145800200529     C     14            SUB       J             K                 2 0
145900200529     C                   MOVEA     *ALL' '       ROU
146000200529     C                   MOVEA     WNWDS         ROU(K)
146100200529     C                   MOVEA     ROU           WWROT
146200200529     C                   END
146300200529     C                   END
146400200529
146500200529     C                   ELSE
146600200529
146700200529     C                   MOVEL     *BLANKS       WWROU
146800200529     C                   MOVEL     *BLANKS       WWROT
146900200529      *
147000200529     C                   END
147100200529      *
147200200529     C                   ENDSR
147300200529      *****************************************************************
147400200529      /EJECT
147500200529      *****************************************************************
147600200529      * CNTL - Left Align Screen Countervalue.
147700200529      *****************************************************************
147800200529     C     CNTL          BEGSR
147900200529      *                                                               *
148000200529     C                   Z-ADD     0             W_E               2 0
148100200529     C                   Z-ADD     1             W_F               2 0
148200200529     C                   Z-ADD     1             W_R               2 0
148300200529     C                   MOVE      '*'           SPLAT             1
148400200529     C                   MOVEA     DDTCTR        CTR
148500200529     C     SPLAT         LOOKUP    CTR(W_F)                               99
148600200529     C     21            SUB       W_F           W_E
148700200529     C                   MOVE      ' '           CTR(W_F)
148800200529     C                   ADD       1             W_F
148900200529     C                   DO        W_E
149000200529     C                   MOVE      CTR(W_F)      CTR(W_R)
149100200529     C                   ADD       1             W_F
149200200529     C                   ADD       1             W_R
149300200529     C                   END
149400200529     C                   ADD       1             W_E
149500200529     C                   MOVEA     *ALL' '       CTR(W_E)
149600200529     C                   MOVEA     CTR           DDTCTR
149700200529      *
149800200529     C                   ENDSR
149900200529      *****************************************************************
150000200529      /EJECT
150100200529      *****************************************************************
150200200529      * TRADSTAT - TRADE STATUS
150300200529      *****************************************************************
150400200529     C     TRADSTAT      BEGSR
150500200529
150600200529      ** Trade status : cancelled or settled
150700200529
150800200529     C     RECI          IFEQ      'C'
150900200529     C     RECI          OREQ      '*'
151000200529     C     RECI          OREQ      'R'
151100200529     C     RECI          OREQ      'L'
151200200529     C     CHTP          ANDEQ     'D'
151300200529     C     RECI          OREQ      'P'
151400200529     C     CHTP          ANDEQ     'D'
151500200529     C                   MOVEL     'CANCELLED'   DDSTAT
151600200529     C                   ELSE                                                                 196903
151700200529                                                                                              196903
151800200529      ** Trade status : incomplete                                                            196903
151900200529                                                                                              196903
152000200529     C     TINC          IFEQ      'I'                                                        196903
152100200529     C                   MOVEL     'INCOMPL. '   DDSTAT                                       196903
152200200529     C                   ELSE
152300200529     C     RECI          IFEQ      'S'
152400200529     C     TDFS          OREQ      BJRDNB
152500200529     C     RECI          OREQ      'D'
152600200529     C     AUTS          ANDEQ     'Y'
152700200529     C     TDVD          ANDLE     BJRDNB
152800200529     C     RECI          OREQ      'A'
152900200529     C     AUTS          ANDEQ     'Y'
153000200529     C     TDVD          ANDLE     BJRDNB
153100200529     C                   MOVEL     'SETTLED'     DDSTAT
153200200529     C                   END
153300200529     C                   END                                                                  196903
153400200529     C                   END
153500200529                                                                                            BUG13267
153600200529      * If DDSTAT is blank then set to UNSETTLED                                            BUG13267
153700200529     C     DDSTAT        IFEQ      *BLANKS                                                  BUG13267
153800200529     C                   MOVEL     'UNSETTLED'   DDSTAT                                     BUG13267
153900200529     C                   ENDIF                                                              BUG13267
154000200529
154100200529      ** Trade authorized/not authorized
154200200529      ** if complete                                                                          196903
154300200529
154400200529     C     TINC          IFNE      'I'                                                        196903
154500200529     C     RECI          IFEQ      'L'
154600200529     C     RECI          OREQ      'P'
154700200529     C     RECI          OREQ      'R'
154800200529     C                   MOVEL     'NOT AU'      DDAUTH
154900200529     C                   MOVE      'THORISED'    DDAUTH
155000200529     C                   ELSE
155100200529     C*****BVAUTH        IFNE      '00'                                                     BUG13267
155200200529     C                   MOVEL     'AUTHORIS'    DDAUTH
155300200529     C                   MOVE      'ED    '      DDAUTH
155400200529     C**********         END                                                                BUG13267
155500200529     C                   END
155600200529     C                   END                                                                  196903
155700200529      *
155800200529     C                   ENDSR
155900200529      *****************************************************************
156000200529      /EJECT
156100200529      *****************************************************************
156200200529      *                                                               *
156300200529      * ZEDIT - Edit an unsigned field                                *
156400200529      *                                                               *
156500200529      *****************************************************************
156600200529     C     ZEDIT         BEGSR
156700200529
156800200529     C                   CALLB     'ZEDIT'
156900200529     C                   PARM                    ZFIELD           16
157000200529     C                   PARM                    ZADEC             1 0
157100200529
157200200529     C                   ENDSR
157300200529      *****************************************************************
157400200529      /EJECT
157500200529      *****************************************************************
157600200529      *                                                               *
157700200529      * ZSEDIT - Edit a signed field                                  *
157800200529      *                                                               *
157900200529      *****************************************************************
158000200529     C     ZSEDIT        BEGSR
158100200529
158200200529     C                   CALLB     'ZSEDIT'
158300200529     C                   PARM                    ZFLD15           15 0
158400200529     C                   PARM                    ZDECS             1 0
158500200529     C                   PARM                    ZECODE            1
158600200529     C                   PARM                    ZOUT21           21
158700200529
158800200529     C                   ENDSR
158900200529      *****************************************************************
159000200529      /EJECT
159100200529      *****************************************************************
159200200529      *                                                               *
159300200529      * ZSEDITF - Edit a signed field                                 *
159400200529      *                                                               *
159500200529      *****************************************************************
159600200529     C     ZSEDITF       BEGSR
159700200529
159800200529     C                   CALLB     'ZSEDITF'
159900200529     C                   PARM                    ZFLD15           15 0
160000200529     C                   PARM                    ZDECS             1 0
160100200529     C                   PARM                    ZECODE            1
160200200529     C                   PARM                    ZECHAR            1
160300200529     C                   PARM                    ZOUT21           21
160400200529
160500200529     C                   ENDSR
160600200529      *****************************************************************
160700200529      /EJECT
160800200529      *****************************************************************
160900200529      *                                                               *
161000200529      * ZDATE2 - Format a date for output                             *
161100200529      *                                                               *
161200200529      *****************************************************************
161300200529     C     ZDATE2        BEGSR
161400200529
161500200529     C                   CALLB     'ZDATE2'
161600200529     C                   PARM                    ZDAYNO            5 0
161700200529     C                   PARM                    BJDFIN
161800200529     C                   PARM                    ZDATE             6 0
161900200529     C                   PARM                    ZADATE            7
162000200529
162100200529     C                   ENDSR
162200200529      *****************************************************************
162300200529      /EJECT
162400200529      *****************************************************************
162500200529      *                                                               *
162600200529      * ZCONV - Convert an amount from one currency to another        *
162700200529      *                                                               *
162800200529      *****************************************************************
162900200529     C     ZCONV         BEGSR
163000200529
163100200529     C                   CALLB     'ZCONV'
163200200529     C                   PARM                    ZAMTCI           15 0
163300200529     C                   PARM                    ZEXCH            13 8
163400200529     C                   PARM                    ZMD               1
163500200529     C                   PARM                    ZCCYI             3
163600200529     C                   PARM                    ZCCYO             3
163700200529     C                   PARM                    ZCDPI             1 0
163800200529     C                   PARM                    ZCDPO             1 0
163900200529     C                   PARM                    ZAMTCO           15 0
164000200529
164100200529     C                   ENDSR
164200200529      *****************************************************************
164300200529      /EJECT
164400200529      *****************************************************************
164500200529      * INIT - INITIALIZATION
164600200529      *****************************************************************
164700200529     C     INIT          BEGSR
164800200529      *
164900200529      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN TRADE FORMATS)
165000200529      *
165100200529     C                   MOVEL     DDACTN        ##ACTN            1
165200200529     C                   MOVEL     *BLANK        TrPrim
165300200529     C                   MOVEL     *BLANK        TrSeco
165400200529     C                   MOVEL     *BLANK        TrThir                                       CAS006
165500200529     C                   MOVEL     *BLANK        TrExch
165600200529     C                   MOVEL     *BLANK        TrSett
165700200529     C                   MOVEL     *BLANK        TrChCm
165800200529     C                   MOVEL     *BLANK        TrSwft_A
165900200529     C                   MOVEL     *BLANK        TrSwft_B
166000200529     C                   MOVEL     ##ACTN        DDACTN
166100200529
166200200529     C                   MOVEL     *BLANK        DDSTAT
166300200529     C                   MOVEL     *BLANK        DDAUTH                                        S0126
166400200529
166500200529     C**********         MOVEL     *BLANK        DDSRPN                                       CSE016
166600200529     C                   MOVEL     *BLANK        DDSRNME                                      CSE016
166700200529     C                   MOVEL     *BLANK        DDCRNM
166800200529
166900200529     C                   MOVEL     *BLANK        DDCPNR
167000200529     C                   MOVEL     *BLANK        DDCFCT
167100200529     C                   MOVEL     *BLANK        DDMAMT
167200200529     C                   MOVEL     *BLANK        DDSPXR
167300200529     C                   MOVEL     *BLANK        DDSPMD
167400200529     C                   MOVEL     *BLANK        DDTCTR
167500200529
167600200529     C                   MOVEL     *BLANK        A_DDROUS
167700200529     C                   MOVEL     *BLANK        A_DDROTS
167800200529     C                   MOVEL     *BLANK        A_DDROUC
167900200529     C                   MOVEL     *BLANK        A_DDROTC
168000200529
168100200529     C                   MOVEL     *BLANK        B_DDROUS
168200200529     C                   MOVEL     *BLANK        B_DDROTS
168300200529     C                   MOVEL     *BLANK        B_DDROUC
168400200529     C                   MOVEL     *BLANK        B_DDROTC
168500200529     C/COPY WNCPYSRC,SETRADNC02
168600200529      *
168700200529     C                   ENDSR
168800200529      *****************************************************************
168900200529      /EJECT
169000200529      *****************************************************************
169100200529      * ACSINST - ACCESS INSTRUMENT DETAILS                           *
169200200529      *****************************************************************
169300200529     C     ACSINST       BEGSR
169400200529
169500200529      * Access Security details
169600200529
169700200529     C     TDSS          CHAIN     SECTYDF                            99
169800200529      *
169900200529      * DATABASE ERROR
170000200529      *
170100200529     C     *IN99         IFEQ      '1'
170200200529     C                   MOVEL     TDSS          DBKEY
170300200529     C                   MOVEL     'SECTYD'      DBFILE
170400200529     C                   MOVEL     '001'         DBASE
170500200529     C                   EXSR      *PSSR
170600200529     C                   END
170700200529
170800200529      * Security report name
170900200529
171000200529     C**********         MOVEL     SRPN          DDSRPN                                       CSE016
171100200529      *                                                                                       CSE016
171200200529      ** Format security report description                                                   CSE016
171300200529      *                                                                                       CSE016
171400200529     C     SRPN          IFNE      *BLANKS                                                    CSE016
171500200529      *                                                                                       CSE016
171600200529     C                   CALLB     'ZSDESC'                                                   CSE016
171700200529     C                   PARM      SRPN          PSRPN                                        CSE016
171800200529     C                   PARM                    PSFN1                                        CSE016
171900200529     C                   PARM                    PSFN2                                        CSE016
172000200529     C                   PARM                    CPNR                                         CSE016
172100200529     C                   PARM                    MATY                                         CSE016
172200200529     C                   PARM                    SCPP                                         CSE016
172300200529     C                   PARM                    SCPD                                         CSE016
172400200529     C                   PARM      BVRIDF        PRSFD                                        CSE016
172500200529     C                   PARM                    SCPI                                         CSE016
172600200529     C                   PARM                    PRNME                                        CSE016
172700200529     C                   PARM                    PFNM1                                        CSE016
172800200529     C                   PARM                    PFNM2                                        CSE016
172900200529     C                   PARM                    PFNM3                                        CSE016
173000200529      *                                                                                       CSE016
173100200529     C                   EVAL      DDSRNME = PRNME                                            CSE016
173200200529     C                   ENDIF                                                                CSE016
173300200529
173400200529      * Access Investment Type details
173500200529
173600200529     C     KLINVT        CHAIN     INVTPDF                            99
173700200529      *
173800200529      * DATABASE ERROR
173900200529      *
174000200529     C     *IN99         IFEQ      '1'
174100200529     C                   MOVEL     NMCY          DBKEY
174200200529     C                   MOVE      SITP          DBKEY
174300200529     C                   MOVEL     'INVTPD'      DBFILE
174400200529     C                   MOVEL     '002'         DBASE
174500200529     C                   EXSR      *PSSR
174600200529     C                   END
174700200529
174800200529      * Get nominal currency details
174900200529
175000200529     C                   MOVE      NMCY          @AJCD
175100200529     C                   EXSR      ACSCURR
175200200529
175300200529     C                   MOVEL     A6SPRT        NomCcySPRT
175400200529     C                   Z-ADD     A6NBDP        NomCcyDec
175500200529     C                   MOVEL     A6MDIN        NomCcyMDIN
175600200529     C                   MOVEL     A6NQDP        NomCcyNQDP
175700200529     C                   MOVEL     A6SWCY        NomCcySWCY
175800200529     C                   MOVEL     A6CDFN        NomCcyCDFN
175900200529     C                   MOVEL     A6ECDN        NomCcyECDN
176000200529
176100200529     C                   ENDSR
176200200529      *****************************************************************
176300200529      /EJECT
176400200529      *****************************************************************
176500200529      * ACSCURR - ACCESS CURRENCY DETAILS                             *
176600200529      *****************************************************************
176700200529     C     ACSCURR       BEGSR
176800200529
176900200529     C                   CALL      'AOCURRR0'
177000200529     C                   PARM      *BLANKS       @RTCD             7                           S0111
177100200529     C                   PARM      '*KEY   '     @OPTN             7                           S0111
177200200529     C                   PARM                    @AJCD             3                           S0111
177300200529     C     SDCURR        PARM      SDCURR        DSSDY                                         S0111
177400200529      *
177500200529      * DATABASE ERROR
177600200529      *
177700200529     C     @RTCD         IFNE      *BLANK
177800200529     C                   MOVEL     @AJCD         DBKEY
177900200529     C                   MOVEL     'SDCURRPD'    DBFILE
178000200529     C                   MOVEL     '003'         DBASE
178100200529     C                   EXSR      *PSSR
178200200529     C                   END
178300200529
178400200529     C                   ENDSR
178500200529      *****************************************************************
178600200529      /EJECT
178700200529      *****************************************************************
178800200529      * ACSCUST - ACCESS CUSTOMER DETAILS                             *
178900200529      *****************************************************************
179000200529     C     ACSCUST       BEGSR
179100200529
179200200529     C                   MOVEL     *BLANK        @KEY1
179300200529     C                   MOVEL     TCNR          @KEY1
179400200529
179500200529     C*******************CALL      'AOCUSTR0'                                                 211800
179600200529     C                   CALL      'AOCUSTR1'                                                 211800
179700200529     C                   PARM      *BLANK        @RTCD             7
179800200529     C                   PARM      '*KEY   '     @OPTN             7
179900200529     C                   PARM                    @KEY1            10
180000200529     C                   PARM                    @KYST             7
180100200529     C*****SDCUST        PARM      SDCUST        DSSDY                                        211800
180200200529     C     SDCUST        PARM      SDCUST        DSLDY                                        211800
180300200529      *
180400200529      * DATABASE ERROR
180500200529      *
180600200529     C     @RTCD         IFNE      *BLANK
180700200529     C     BBCLST        ANDNE     'Y'                                                        211800
180800200529     C                   MOVEL     TCNR          DBKEY
180900200529     C                   MOVEL     'SDCUSTPD'    DBFILE
181000200529     C                   MOVEL     '004'         DBASE
181100200529     C                   EXSR      *PSSR
181200200529     C                   END
181300200529
181400200529     C                   CALL      'AOSECSR0'                                                  S0111
181500200529     C*******************PARM                    @RTCD             7                    S0111 211800
181600200529     C                   PARM      *BLANKS       @RTCD             7                          211800
181700200529     C                   PARM      '*KEY   '     @OPTN             7                           S0111
181800200529     C                   PARM      BBCUST        @SCKY             6                           S0111
181900200529     C     SDSECS        PARM      SDSECS        DSSDY                                         S0111
182000200529      *
182100200529      * DATABASE ERROR
182200200529      *
182300200529     C     @RTCD         IFNE      *BLANK
182400200529     C                   MOVEL     TCNR          DBKEY
182500200529     C                   MOVEL     'SDSECSPD'    DBFILE
182600200529     C                   MOVEL     '005'         DBASE
182700200529     C                   EXSR      *PSSR
182800200529     C                   END
182900200529
183000200529     C                   MOVE      BFCUST        CustNum
183100200529     C                   MOVE      BFACCD        CustAccd                                      S0111
183200200529     C                   MOVE      BFCYCD        CustCurr                                      S0111
183300200529     C                   MOVE      BFACSN        CustAcsq                                      S0111
183400200529     C                   MOVE      BFCLAS        CustClass                                     S0111
183500200529     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
183600200529     C                   MOVE      BFDRF1        CustDpRef1                                    S0111
183700200529     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
183800200529     C                   MOVE      BFDRF2        CustDpRef2                                    S0111
183900200529     C                   MOVE      BFPNP1        CustPNP1                                      S0111
184000200529     C                   MOVE      BFPNP2        CustPNP2                                      S0111
184100200529     C                   MOVE      BFTCD         CustTAXC                                      S0111
184200200529     C                   MOVE      BFASIN        CustAUTS                               E17228 S0111
184300200529     C                   MOVE      BFTDCG        CustTDCG                                      07845
184400200529
184500200529     C                   ENDSR
184600200529      *****************************************************************
184700200529      /EJECT
184800200529      *****************************************************************
184900200529      * *INZSR - INITIAL PROCESSING                                   *
185000200529      *****************************************************************
185100200529     C     *INZSR        BEGSR
185200200529      *
185300200529      **  PROGRAM PARAMETERS
185400200529      *
185500200529     C     *ENTRY        PLIST
185600200529      *
185700200529      * INPUTS
185800200529      *
185900200529      * Return Code
186000200529     C                   PARM                    RetCodeIn
186100200529      *
186200200529      * Trade - file formats
186300200529     C                   PARM                    TradFilFmt
186400200529     C                   PARM                    TX1AFilFmt
186500200529     C                   PARM                    TX1BFilFmt
186600200529                                                                                              CAS006
186700200529      ** Switchable features                                                                  CAS006
186800200529                                                                                              CAS006
186900200529     C                   PARM                    CAS006                                       CAS006
187000200529      *                                                                                       CGL031
187100200529      ** CGL031 Switchable Feature                                                            CGL031
187200200529     C                   PARM                    CGL031                                       CGL031
187300200529      *
187400200529      * Output parameters
187500200529      *
187600200529      * Trade - screen formats
187700200529     C                   PARM                    TrPrim
187800200529     C                   PARM                    TrSeco
187900200529     C                   PARM                    TrThir                                       CAS006
188000200529     C                   PARM                    TrExch
188100200529     C                   PARM                    TrSett
188200200529     C                   PARM                    TrChCm
188300200529     C                   PARM                    TrSwft_A
188400200529     C                   PARM                    TrSwft_B
188500200529
188600200529      ** Security Details
188700200529      ** Investment Type Details
188800200529     C                   PARM                    SECTYDts
188900200529     C                   PARM                    INVTPDts
189000200529
189100200529      ** Nominal Currency Details
189200200529     C                   PARM                    NomCcyDts
189300200529
189400200529      ** Settlement Currency Details
189500200529     C                   PARM                    SetCcyDts
189600200529      *
189700200529      ** Customer (Counterparty) Details
189800200529     C                   PARM                    CustDts
189900200529      *
190000200529      * Trade Status
190100200529      * Trade Authorized/Not Authorized
190200200529     C                   PARM                    DDSTAT            9
190300200529     C                   PARM                    DDAUTH           14                           S0126
190400200529      * Security report name
190500200529      * Customer report name
190600200529     C**********         PARM                    DDSRPN           20                          CSE016
190700200529     C                   PARM                    DDSRNME          41                          CSE016
190800200529     C                   PARM                    DDCRNM           20
190900200529
191000200529      * Coupon Rate
191100200529      * Current Factor
191200200529      * Margin Amount
191300200529      * Portfolio Exchange Rate
191400200529      * Portfolio M/D Ind
191500200529      * Trade Countervalue
191600200529     C                   PARM                    DDCPNR           13
191700200529     C                   PARM                    DDCFCT           12
191800200529     C                   PARM                    DDMAMT           18
191900200529     C                   PARM                    DDSPXR           14
192000200529     C                   PARM                    DDSPMD            1
192100200529     C                   PARM                    DDTCTR           21
192200200529     C                   PARM                    DDWTAX           15            CSE023
192300200529     C                   PARM                    DDPRICN                                      CAS006
192400200529
192500200529      * SCREEN A
192600200529      * Destination of Settlement
192700200529      * Destination of Confirmation
192800200529     C                   PARM                    A_DDROUS          6
192900200529     C                   PARM                    A_DDROTS         12
193000200529     C                   PARM                    A_DDROUC          6
193100200529     C                   PARM                    A_DDROTC         12
193200200529
193300200529      * SCREEN B
193400200529      * Destination of Settlement
193500200529      * Destination of Confirmation
193600200529     C                   PARM                    B_DDROUS          6
193700200529     C                   PARM                    B_DDROTS         12
193800200529     C                   PARM                    B_DDROUC          6
193900200529     C                   PARM                    B_DDROTC         12
194000200529     C                   PARM                    DDFRNT                                    AR698195B
194100200529      *
194200200529      ** Initialize program name
194300200529      *
194400200529     C                   MOVEL     'SETRADCVT'   DBPGM
194500200529      *
194600200529      ** ACCESS BANK DETAILS
194700200529      *
194800200529     C                   CALL      'AOBANKR0'
194900200529     C                   PARM      *BLANKS       @RTCD             7
195000200529     C                   PARM      '*FIRST  '    @OPTN             7
195100200529     C     SDBANK        PARM      SDBANK        DSFDY
195200200529      *
195300200529      * DATABASE ERROR
195400200529      *
195500200529     C     @RTCD         IFNE      *BLANK
195600200529     C                   MOVEL     @OPTN         DBKEY
195700200529     C                   MOVEL     'SDBANKPD'    DBFILE
195800200529     C                   MOVEL     '900'         DBASE
195900200529     C                   EXSR      *PSSR
196000200529     C                   END
196100200529      *
196200200529      ** ACCESS SECURITIES TRADING DETAILS
196300200529      *
196400200529     C                   CALL      'AOSTRDR0'
196500200529     C                   PARM      *BLANKS       @RTCD             7
196600200529     C                   PARM      '*FIRST  '    @OPTN             7
196700200529     C     SDSTRD        PARM      SDSTRD        DSSDY
196800200529      *
196900200529      * DATABASE ERROR
197000200529      *
197100200529     C     @RTCD         IFNE      *BLANK
197200200529     C                   MOVEL     @OPTN         DBKEY
197300200529     C                   MOVEL     'SDSTRDPD'    DBFILE
197400200529     C                   MOVEL     '901'         DBASE
197500200529     C                   EXSR      *PSSR
197600200529     C                   END
197700200529      *
197800200529      ** ACCESS MIDAS MODULES
197900200529      *
198000200529     C                   CALL      'AOMMODR0'
198100200529     C                   PARM      *BLANKS       @RTCD             7
198200200529     C                   PARM      '*FIRST '     @OPTN             7
198300200529     C     SDMMOD        PARM      SDMMOD        DSFDY
198400200529      *
198500200529      * DATABASE ERROR
198600200529      *
198700200529     C     @RTCD         IFNE      *BLANK
198800200529     C                   MOVEL     @OPTN         DBKEY
198900200529     C                   MOVEL     'SDMMODPD'    DBFILE
199000200529     C                   MOVEL     '902'         DBASE
199100200529     C                   EXSR      *PSSR
199200200529     C                   END
199300200529      *
199400200529      ** ACCESS PORTFOLIO MANAGEMNT DETAILS
199500200529      *
199600200529     C     BGPFMG        IFEQ      'Y'
199700200529     C                   CALL      'AOPORTR0'
199800200529     C                   PARM      *BLANKS       @RTCD             7
199900200529     C                   PARM      '*FIRST'      @OPTN             7
200000200529     C     SDPORT        PARM      SDPORT        DSFDY
200100200529      *
200200200529      * DATABASE ERROR
200300200529      *
200400200529     C     @RTCD         IFNE      *BLANK
200500200529     C                   MOVEL     @OPTN         DBKEY
200600200529     C                   MOVEL     'SDPORTPD'    DBFILE
200700200529     C                   MOVEL     '903'         DBASE
200800200529     C                   EXSR      *PSSR
200900200529     C                   END
201000200529     C                   END
201100200529      *                                                                         CAC005
201200200529      ** Access Switchable features file for Profit Centre Accounting           CAC005
201300200529      ** SE Enhancement                                                         CAC005
201400200529      *                                                                         CAC005
201500200529     C                   CALL      'AOSARDR0'                                   CAC005
201600200529     C                   PARM      *BLANKS       @RTCD                          CAC005
201700200529     C                   PARM      '*VERIFY'     @OPTN                          CAC005
201800200529     C                   PARM      'CAC005'      @SARD             6            CAC005
201900200529      *                                                                         CAC005
202000200529      ** DATABASE ERROR                                                         CAC005
202100200529      *                                                                         CAC005
202200200529     C     @RTCD         IFNE      *BLANKS                                      CAC005
202300200529     C     @RTCD         ANDNE     '*NRF   '                                    CAC005
202400200529     C                   MOVEL     'CAC005'      DBKEY                          CAC005
202500200529     C                   MOVEL     'SCSARDPD'    DBFILE                         CAC005
202600200529     C                   MOVEL     '904'         DBASE                          CAC005
202700200529     C                   EXSR      *PSSR                                        CAC005
202800200529     C                   END                                                    CAC005
202900200529     C     @RTCD         IFEQ      *BLANKS                                      CAC005
203000200529     C                   MOVE      'Y'           CAC005            1            CAC005
203100200529     C                   ELSE                                                   CAC005
203200200529     C                   MOVE      'N'           CAC005                         CAC005
203300200529     C                   ENDIF                                                  CAC005
203400200529      *                                                                         CSE023
203500200529      ** Check if enhancement 'Treaty withholding tax' is on.                   CSE023
203600200529      *                                                                         CSE023
203700200529     C                   CALLB     'AOSARDR0'                                   CSE023
203800200529     C                   PARM      *BLANKS       @RTCD                          CSE023
203900200529     C                   PARM      '*VERIFY'     @OPTN                          CSE023
204000200529     C                   PARM      'CSE023'      @SARD                          CSE023
204100200529      *                                                                         CSE023
204200200529      ** Check for Database error                                               CSE023
204300200529      *                                                                         CSE023
204400200529     C     @RTCD         IFNE      *BLANKS                                      CSE023
204500200529     C     @RTCD         ANDNE     '*NRF   '                                    CSE023
204600200529     C                   MOVEL     'CSE023'      DBKEY                          CSE023
204700200529     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE023
204800200529     C                   MOVEL     '905'         DBASE                          CSE023
204900200529     C                   EXSR      *PSSR                                        CSE023
205000200529     C                   ENDIF                                                  CSE023
205100200529      *                                                                         CSE023
205200200529     C     @RTCD         IFEQ      *BLANK                                       CSE023
205300200529     C                   MOVE      'Y'           CSE023            1            CSE023
205400200529     C                   ELSE                                                   CSE023
205500200529     C                   MOVE      'N'           CSE023                         CSE023
205600200529     C                   ENDIF                                                  CSE023
205700200529     C*
205800200529     C* Define key list for file INVTP
205900200529     C*
206000200529     C     KLINVT        KLIST
206100200529     C                   KFLD                    NMCY
206200200529     C                   KFLD                    SITP
206300200529      *
206400200529     C                   ENDSR
206500200529      *****************************************************************
206600200529      /EJECT
206700200529      ********************************************************************
206800200529      ** Program, module and procedure names for database error processing.
206900200529      ** =================================================================
207000200529      ** The following /COPY sets these values, and also defines LDA as
207100200529      ** an external data area
207200200529      ********************************************************************
207300200529      /COPY ZACPYSRC,PSSR_ILE
207400200529      ********************************************************************
207500200529**  CPY@
207600200529(c) Finastra International Limited 2001
