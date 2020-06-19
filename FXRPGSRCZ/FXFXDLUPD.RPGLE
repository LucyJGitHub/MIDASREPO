000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas FX Deals DL database update')                    *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - FX Dealer Module                                     *
000900200528      *                                                               *
001000200528      *  FXFXDLUPD - FX DEALS DL DATABASE UPDATE                      *
001100200528      *                                                               *
001200200528      *  (c) Finastra International Limited 2001                      *
001300200528      *                                                               *
001400200604      *  Last Amend No. 251029             Date 22May20               *
001500200528      *  Prev Amend No. MD046248           Date 27Oct17               *
001600200528      *                 CDL099             Date 06Oct17               *
001700200528      *                 247151A            Date 29Jun17               *
001800200528      *                 MD030956           Date 09Oct14               *
001900200528      *                 CDL094             Date 01Sep14               *
002000200528      *                 MD025244           Date 09May14               *
002100200528      *                 AR990243           Date 14Jun12               *
002200200528      *                 CSW212             Date 03May12               *
002300200528      *                 AR787620           Date 10Jun11               *
002400200528      *                 CER059             Date 19Jul10               *
002500200528      *                 CER043             Date 19May08               *
002600200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
002700200528      *                 260363             Date 25May09               *
002800200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
002900200528      *                 256564             Date 17Sep08               *
003000200528      *                 255340             Date 29Jul08               *
003100200528      *                 247104             Date 20Jun07               *
003200200528      *                 246801             Date 14May07               *
003300200528      *                 246387             Date 21Mar07               *
003400200528      * Midas Plus 1.4 Base ------------------------------------------*
003500200528      *                 243830             Date 17Nov06               *
003600200528      * Midas Plus 1.3 ----------- Base ------------------------------*
003700200528      *                 242477             Date 27Sep06               *
003800200528      *                 240603             Date 04Sep06               *
003900200528      *                 CSD031             Date 10Apr06               *
004000200528      *                 240480             Date 30Jun06               *
004100200528      *                 CDL049             Date 07Jul06               *
004200200528      *                 CSD027             Date 09Dec05               *
004300200528      *                 CDL038             Date 10May05               *
004400200528      *                 BUG6479            Date 20Apr05               *
004500200528      *                 BUG6191            Date 09Mar05               *
004600200528      *                 220783             Date 14Sep03               *
004700200528      *                 LSC025             Date 25Jun04               *
004800200528      *                 CTI004             Date 12Apr04               *
004900200528      *                 CRE020             Date 20Jan04               *
005000200528      *                 CGL029             Date 01Sep03               *
005100200528      *                 CAS004             Date 26Jun02               *
005200200528      * Midas Release 4.01.03 ----------------------------------------*
005300200528      *                 209895             Date 14Jan03               *
005400200528      * Midas Release 4.01.02 ----------------------------------------*
005500200528      *                 209009             Date 03Sep02               *
005600200528      *                 207072             Date 17Jul02               *
005700200528      * Midas Release 4.01 -------------------------------------------*
005800200528      *                 CAS001             Date 23Nov01               *
005900200528      * Midas Release 4 --------------- Base -------------------------*
006000200528      * Midas DBA 3.05 -----------------------------------------------*
006100200528      * Midas DBA 3.04 -----------------------------------------------*
006200200528      *                 155792             Date 03Oct00               *
006300200528      *                 CDL008             Date 02May00               *
006400200528      * Midas DBA 3.03 -----------------------------------------------*
006500200528      * Midas DBA 3.02 -----------------------------------------------*
006600200528      *                 CAP051             Date 11Nov99               *
006700200528      *                 CPB001             Date 01Jun99               *
006800200528      * Midas DBA 3.00 ---------------- Base -------------------------*
006900200528      *                 CAP002  *CREATE    Date 01Nov97               *
007000200528      *                                                               *
007100200528      *---------------------------------------------------------------*
007200200528      *                                                               *
007300200528      *  251029 - Applied fix 231306.                                 *
007400200528      *  231306 - Handle file locking properly.                       *
007500200528      *  MD046248 - Finastra Rebranding                               *
007600200528      *  CDL099 - Split Value Date                                    *
007700200528      *  247151A- Initialise flag introduced for RecSd and PaySd      *
007800200528      *         - Applied for MD045858                                *
007900200528      *  MD030956 - Additional changes to BFM-TI enhancement          *
008000200528      *  CDL094 - Enhance  Receive Settlement Instructions            *
008100200528      *  MD025244 - Added parameter in calling ZADLTRLRUD.            *
008200200528      *  AR990243 - Additional deliveries for CSW212                  *
008300200528      *  CSW212 - SWIFT 2012 Changes                                  *
008400200528      *  AR787620 - Hooks Incorporation                               *
008500200528      *             WNCPYSRC,FXH00003                                 *
008600200528      *             WNCPYSRC,FXH00001                                 *
008700200528      *             WNCPYSRC,FXH00002                                 *
008800200528      *             WNCPYSRC,FXH00004                                 *
008900200528      *  CER059 - German Feature Upgrade to Delhi                     *
009000200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
009100200528      *  260363 - SWIFT messages generation error.                    *
009200200528      *  256564 - Recompile due to PF changes done by fix 256330      *
009300200528      *  255340 - Move reference rate to its field in DEALSDB when    *
009400200528      *           CDL049 is on.                                       *
009500200528      *  247104 - Only one of either Settlement Payment or            *
009600200528      *           Settlement Receipt is amended but both Pay/Rec      *
009700200528      *           messages are cancelled and regenerated. This is     *
009800200528      *           because pay/rec indicators (PRI1 and PRI3) are set  *
009900200528      *           without checking which side was amended.            *
010000200528      *           Applied fix 247151                                  *
010100200528      *  247151 - Check settlement side                               *
010200200528      *  246801 - When CSW050 is switched on always produce a         *
010300200528      *           confirmation/Pay_Receives as Bank may need to break *
010400200528      *           a multiple mesasage. i.e. If an MT203/MT210 multiple*
010500200528      *           has been generated previously a null amendment may  *
010600200528      *           be required to break this deal out of the multiple. *
010700200528      *           NOTE: Recommend this should be determined by a      *
010800200528      *           system value for core.                              *
010900200528      *           MT292 not produced with new MT202 after deal front  *
011000200528      *           office id amended. PRI1 & PRI3 were set on but      *
011100200528      *           CNRQ was not so DLC0210A never got to produce the   *
011200200528      *           MT292. Fix is not to set on PRI indicators if no    *
011300200528      *           conf is required.                                   *
011400200528      *  246387 - Amended 240603 so that CNRQ is set to 'Y' if Buy /  *
011500200528      *           Sell Net indicator is amended. 240603 only sets     *
011600200528      *           CNRQ to 'Y' when indicators are set to 'Y'          *
011700200528      *  243830 - Don't access AOTIINR0 if TI not installed           *
011800200528      *         - annotated as 240480                                 *
011900200528      *  242477 - Applied fix 200709.  Incorrect deals update due to  *
012000200528      *           authorisation of 2nd leg of swap before authorising *
012100200528      *           the 1st leg.  Prevent authorisation of the 2nd leg  *
012200200528      *           if 1st leg is not yet authorised.                   *
012300200528      *  240603 - Set CNRQ to 'Y' if Buy / Sell Net indicator is      *
012400200528      *           amended                                             *
012500200528      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
012600200528      *  240480 - Don't access AOTIINR0 if TI not installed           *
012700200528      *  CDL049 - Addition of a Reference Rate field                  *
012800200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
012900200528      *  CDL038 - Extended Deal Sub Type                              *
013000200528      *  BUG6479- when option takedown is enter, not cancel and       *
013100200528      *           amendement messages are produce for the option      *
013200200528      *           for MMM.                                            *
013300200528      *  BUG6191- Validate CVMR correctly for changed status.         *
013400200528      *  220783 - SWIFT Confos always being generated on Amend of     *
013500200528      *           Deal even if nothing was changed - this was because *
013600200528      *           CVMR was ' ' on MMDELDPP but 'N' on DEALSDC & was   *
013700200528      *           being compared in Program. Set CVMR on DEALSDC equal*
013800200528      *           to F3CVMR on MMDELDPP.                              *
013900200528      *                                                               *
014000200528      *  LSC025 - Back-Dated SWIFT Messages                           *
014100200528      *           Use Core Hook FXFXDLDC10, FXFXDLDC11, FXFXDLDC12    *
014200200528      *                         FXFXDLDC13                            *
014300200528      *  CTI004 - MidasPlus-TI Integration Enhancements               *
014400200528      *           FX Deals Integration                                *
014500200528      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
014600200528      *  CGL029 - Increase Account Code to 10 digits                  *
014700200528      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
014800200528      *  209895 - No confirmation generated during amend if BLL2II    *
014900200528      *           is "Y" and settlement instructions are blanks. Make *
015000200528      *           sure that CNRQ is "Y" after settlement instructions *
015100200528      *           have been changed to certain values.                *
015200200528      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
015300200528      *           FXCPYSRC.                                           *
015400200528      *  207072 - Ensure correct message generation for linked FX     *
015500200528      *           deals.                                              *
015600200528      *  CAS001 - Net Present Value (NPV) Accounting                  *
015700200528      *  155792 - Check other amended fields relevant for generation  *
015800200528      *           of an amended confirmation.  And default workfield  *
015900200528      *           @@CNRQ to 'N' to prevent a blank CNRQ in DTRIXDD.   *
016000200528      *  CDL008 - Continuous Linked Settlement                        *
016100200528      *  CAP051 - Automatic Authorisation (FX Part)                   *
016200200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
016300200528      *           Recompiled due to changes in FXVFXDLPD              *
016400200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
016500200528      *                                                               *
016600200528      *****************************************************************
016700200528     FFXMIDBLL  UF A E           K DISK
016800200528     F                                     COMMIT
016900200528     F                                     INCLUDE(DEALSDBF)
017000200528     F                                     INCLUDE(DEALSDFF)
017100200528     FSDTIX     UF A E           K DISK
017200200528     F                                     COMMIT
017300200528     F                                     PREFIX(DX)
017400200528                                                                                              CRE020
017500200528     FREADVCL1  UF   E           K DISK    COMMIT                                             CRE020
017600200528     F                                     USROPN                                             CRE020
017700200528      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
017800200528                                                                                              CRE020
017900200528     F/COPY WNCPYSRC,FXFXDLDF01
018000200528
018100200528      *****************************************************************
018200200528      ** +--------------------------------------+
018300200528      ** ¦ Automatically included D-specs       ¦
018400200528      ** ¦ ==============================       ¦
018500200528      ** +--------------------------------------+
018600200528      **
018700200528      ** Standard D-specs
018800200528      ** ================
018900200528      **
019000200528      ** The following /COPY line includes the LDA layout,
019100200528      ** the copyright array definition,
019200200528      ** and the following named constants:
019300200528      **    True       logical = *on (for indcator processing)
019400200528      **    False      logical = *off (for indcator processing)
019500200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
019600200528      **                                    handler)
019700200528      ** and the following variables:
019800200528      **    RunBefore  1A (for the PSSR)
019900200528
020000200528     D/COPY ZACPYSRC,STD_D_SPEC
020100200528
020200200528      ** Include the FX standard declares
020300200528     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
020400200528     D/COPY ZACPYSRC,STDDECLARE                                                               209009
020500200528
020600200528      ** Program Status Data Structure
020700200528      ** =============================
020800200528      ** The following /COPY line includes all the defined fields in the
020900200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
021000200528
021100200528     D/COPY ZACPYSRC,PSDS
021200200528
021300200528      ** +--------------------------------------+
021400200528      ** ¦ End of automatically included D-specs¦
021500200528      ** ¦ =====================================¦
021600200528      ** +--------------------------------------+
021700200528
021800200528      *****************************************************************
021900200528
022000200528      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID FX DEAL
022100200528     D FXVFXD        E DS                  EXTNAME(FXVFXDLPD)
022200200528     D  @FXREC               400    468
022300200528     D  @FXPAY               469   1027
022400200528     D  @FXISDA             1394   2043                                                       CSW212
022500200528     D/COPY WNCPYSRC,FXFXDLDD02
022600200528
022700200528      **  DEALS FILE - FX DEALS
022800200528     D DEALS         E DS                  EXTNAME(DEALSDB)
022900200528     D  @DLREC               409    477
023000200528     D  @DLPAY               478   1036
023100200528     D  @DLISDA             1376   2025                                                       CSW212
023200200528     D/COPY WNCPYSRC,FXFXDLDD03
023300200528
023400200528      **  Time data structure for DTRIX.
023500200528     D                 DS
023600200528     D  @XTIME                 1      6  0
023700200528     D  DXTIM                  1      4  0
023800200528     D                 DS                                                                     CDL099
023900200528      **  Data structure for date in, to change format.                                       CDL099
024000200528     D  DateIn                 1      8  0                                                    CDL099
024100200528     D  @@YY                   1      4  0                                                    CDL099
024200200528     D  @@MM                   5      6  0                                                    CDL099
024300200528     D  @@DD                   7      8  0                                                    CDL099
024400200528      *                                                                                       CDL099
024500200528     D/COPY WNCPYSRC,FXFXDLDD01
024600200528                                                                                              CRE020
024700200528      ** CRE020 Variables                                                                     CRE020
024800200528     D CRE020          S              1A                                                      CRE020
024900200528     D KRefNo          S             30A                                                      CRE020
025000200528     D KPrgMn          S             10A   INZ('FXFXDLUPD ')                                  CRE020
025100200528     D PSysVal01       S             20A   INZ('ForeignExchangeDeals')                        CRE020
025200200528     D PCurSet01       S            200A                                                      CRE020
025300200528     D PSysVal02       S             20A                                                      CRE020
025400200528     D PCurSet02       S            200A                                                      CRE020
025500200528     D PSysVal03       S             20A                                                      CRE020
025600200528     D PCurSet03       S            200A                                                      CRE020
025700200528     D PSysVal04       S             20A                                                      CRE020
025800200528     D PCurSet04       S            200A                                                      CRE020
025900200528     D PSysVal05       S             20A                                                      CRE020
026000200528     D PCurSet05       S            200A                                                      CRE020
026100200528     D PSysVal06       S             20A                                                      CRE020
026200200528     D PCurSet06       S            200A                                                      CRE020
026300200528     D PSysVal07       S             20A                                                      CRE020
026400200528     D PCurSet07       S            200A                                                      CRE020
026500200528     D PSysVal08       S             20A                                                      CRE020
026600200528     D PCurSet08       S            200A                                                      CRE020
026700200528     D PSysVal09       S             20A                                                      CRE020
026800200528     D PCurSet09       S            200A                                                      CRE020
026900200528     D PSysVal10       S             20A                                                      CRE020
027000200528     D PCurSet10       S            200A                                                      CRE020
027100200528     D WSysVal01       S              1A                                                      CRE020
027200200528     D WEvent          S              8A                                                      CRE020
027300200528     D WNew            S              1A                                                      CRE020
027400200528
027500200528      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
027600200528
027700200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
027800200528      * DATA STRUCTURE FOR BANK DETAILS
027900200528
028000200528     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
028100200528      ** External DS for TRADE Details
028200200528
028300200528     D SDCURR        E DS                  EXTNAME(SDCURRPD)
028400200528      ** External DS for CURRENCY Details
028500200528                                                                                CDL008
028600200528      ** Externally described DS for switchable feature                         CDL008
028700200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL008
028800200528     D  SLCD         E                     EXTFLD(LCD)                          CDL008
028900200528
029000200528     D DSFDY         E DS                  EXTNAME(DSFDY)
029100200528      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
029200200528
029300200528     D DSSDY         E DS                  EXTNAME(DSSDY)
029400200528      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
029500200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CTI004
029600200528      ** External DS for Module Details                                                       CTI004
029700200528                                                                                              CTI004
029800200528     D SDTIIN        E DS                  EXTNAME(SDTIINPD)                                  CTI004
029900200528      **  TI ICD FIle                                                                         CTI004
030000200528                                                                                              CAS001
030100200528      ** Define fields used in CAS001                                                         CAS001
030200200528                                                                                              CAS001
030300200528     D CAS001          S              1A                                                      CAS001
030400200528     D CTI004          S              1A                                                      CTI004
030500200528     D PRTCD           S              7A                                                      CAS001
030600200528     D POPTN           S              7A                                                      CAS001
030700200528     D PSARD           S              6A                                                      CAS001
030800200528
030900200528     D CSW025          S              1A                                                     BUG6479
031000200528     D CSW050          S              1A                                                      246801
031100200528     D CER043          S              1A                                                      CER043
031200200528     D CTI006          S              1A                                                    MD030956
031300200528     D CDL099          S              1A                                                      CDL099
031400200528      /EJECT
031500200528     C*****************************************************************
031600200528     C*                                                               *
031700200528     C* MAIN - MAIN BODY                                              *
031800200528     C*                                                               *
031900200528     C*****************************************************************
032000200528
032100200528     C/COPY WNCPYSRC,FXFXDLDC03
032200200528      * EXIT IF NOT INSERTION, AMENDMENT OR REVERSAL
032300200528
032400200528     C     F3CHTP        IFNE      'I'
032500200528     C     F3CHTP        ANDNE     'A'
032600200528     C     F3CHTP        ANDNE     'R'
032700200528     C                   RETURN
032800200528     C                   END
032900200528
033000200528      * INITIALIZE: DEAL MISSING INDICATOR
033100200528      *             SWAP OTHER LEG VALUE DATE
033200200528
033300200528     C                   MOVEL     *BLANK        ##DEAL_MIS
033400200528     C                   Z-ADD     *ZERO         ##SOL_VDAT
033500200528     C                   MOVE      ' '           RecSd                                       247151A
033600200528     C                   MOVE      ' '           PaySd                                       247151A
033700200528
033800200528      * INSERT, AMEND, OR REVERSE THE DEAL
033900200528
034000200528     C     F3CHTP        CASEQ     'I'           FXINS
034100200528     C     F3CHTP        CASEQ     'A'           FXAMD
034200200528     C     F3CHTP        CASEQ     'R'           FXDEL
034300200528     C                   END
034400200528
034500200528     C/COPY WNCPYSRC,FXFXDLDC04
034600200528      * IF DEAL NOT MISSING (THIS MAY HAPPEN ON REVERSAL OF SWAPS)
034700200528
034800200528     C     ##DEAL_MIS    IFNE      'Y'
034900200528     C     @@CNRQ        IFEQ      'Y'                                                        246801
035000200528
035100200528      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX
035200200528
035300200528     C                   EXSR      PYRCIN
035400200528     C                   ELSE                                                                 246801
035500200528     C                   Z-ADD     *ZERO         @@PRI1                                       246801
035600200528     C                   Z-ADD     *ZERO         @@PRI2                                       246801
035700200528     C                   Z-ADD     *ZERO         @@PRI3                                       246801
035800200528     C                   ENDIF                                                                246801
035900200528
036000200528      * WRITE A DTRIX RECORD
036100200528
036200200528     C                   EXSR      WRTDTX
036300200528
036400200528     C                   END
036500200528
036600200528      * IF SWAP OTHER LEG REVERSAL HAS BEEN DONE
036700200528
036800200528     C     ##SOL_VDAT    IFNE      *ZERO
036900200528
037000200528      * WITH SWAP OTHER LEG DETAILS
037100200528      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX
037200200528      * AND WRITE A DTRIX RECORD
037300200528
037400200528     C                   EXSR      SOL_PYRCIN
037500200528     C                   EXSR      SOL_WRTDTX
037600200528
037700200528     C                   END
037800200528
037900200528      * UPDATE THE DTRIX HEADER RECORD
038000200528
038100200528     C                   EXSR      UPDDTH
038200200528
038300200528     C/COPY WNCPYSRC,FXFXDLDC05
038400200528      * UPDATE THE DEALS FILE TRAILER
038500200528      * ON INSERTS AND REVERSALS (THE LATTER IF THE DEAL IS NOT MISSING)
038600200528
038700200528     C     F3CHTP        IFEQ      'I'
038800200528     C     F3CHTP        OREQ      'R'
038900200528     C     ##DEAL_MIS    ANDNE     'Y'
039000200528      *
039100200528      ** The value of the update is the deal purchase currency amount,
039200200528      ** except for option takedowns which produce no net change in value
039300200528      *
039400200528     C     F3TYPE        IFNE      'OT'
039500200528     C                   Z-ADD     F3DAM1        @@AMNP
039600200528     C                   ELSE
039700200528     C                   Z-ADD     *ZERO         @@AMNP
039800200528     C                   END
039900200528
040000200528     C                   EXSR      UPDTRL
040100200528     C                   END
040200200528
040300200528      * IF SWAP OTHER LEG REVERSAL HAS BEEN DONE
040400200528      * UPDATE THE DEALS FILE TRAILER FOR THIS UPDATE
040500200528
040600200528     C     ##SOL_VDAT    IFNE      *ZERO
040700200528      *
040800200528      ** The value of the update is the other leg purchase currency amount
040900200528      *
041000200528     C                   Z-ADD     ##SOL_PUAM    @@AMNP
041100200528     C                   EXSR      UPDTRL
041200200528     C                   END
041300200528     C/COPY WNCPYSRC,FXH00003
041400200528      *
041500200528      * EXIT FROM PROGRAM
041600200528      *
041700200528     C                   RETURN
041800200528     C****************************************************************
041900200528      /EJECT
042000200528     C****************************************************************
042100200528     C*                                                              *
042200200528     C* FXINS  - INSERT AN FX DEAL                                   *
042300200528     C*                                                              *
042400200528     C****************************************************************
042500200528     C     FXINS         BEGSR
042600200528      *
042700200528      ** ACCESS THE ASSOCIATED DEAL
042800200528      *
042900200528     C     F3TYPE        IFEQ      'SW'
043000200528     C     F3TYPE        OREQ      'OT'
043100200528     C     F3BROK        OREQ      'SWAP'
043200200528     C     F3DTYP        OREQ      'S'                                                        242477
043300200528      *
043400200528     C                   MOVE      F3DADN        DLNO
043500200528     C*****DLNO*         CHAIN     DEALSDBF                           99                      231306
043600200528     C     DLNO          CHAIN     DEALSDBF                           9998                    231306
043700200528      *                                                                                       231306
043800200528     C     *IN98         IFEQ      *ON                                                        231306
043900200528     C                   EXSR      SRERR                                                      231306
044000200528     C                   ENDIF                                                                231306
044100200528      *
044200200528      ** IF THE ASSOCIATED DEAL IS FOUND
044300200528      *
044400200528     C                   MOVEL     'N'           ##ASOC
044500200528     C     *IN99         IFEQ      '0'
044600200528      *
044700200528      ** STORE VALUES FROM DEAL, FOR LATER USE
044800200528      *
044900200528     C                   MOVEL     'Y'           ##ASOC            1
045000200528     C                   Z-ADD     VDAT          ##VDAT            5 0
045100200528     C                   MOVE      BRKC          ##BRKC            4
045200200528     C                   Z-ADD     BAGE          ##BAGE           13 0
045300200528     C                   Z-ADD     PUAM          ##PUAM           13 0
045400200528     C                   Z-ADD     SLAM          ##SLAM           13 0
045500200528     C                   MOVE      DSTI          ##DSTI            1
045600200528     C                   IF        CDL099 = 'Y'                                               CDL099
045700200528     C                   Z-ADD     BSDT2         ##SOL_SDT2        5 0                        CDL099
045800200528     C                   ENDIF                                                                CDL099
045900200528      *
046000200528      ** DO SWAP, OPTION OR BROKER SWAP UPDATES ON INSERTION
046100200528      *
046200200528     C     F3TYPE        CASEQ     'SW'          SWAPUPINS
046300200528     C     F3TYPE        CASEQ     'OT'          OPTNUPINS
046400200528     C     F3BROK        CASEQ     'SWAP'        BSWPUPINS
046500200528     C                   END
046600200528      *
046700200528      ** UPDATE THE ASSOCIATED DEAL
046800200528      *
046900200528     C                   MOVE      'A'           CHTP
047000200528     C                   Z-ADD     BJRDNB        LCD
047100200528     C                   UPDATE    DEALSDBF
047200200528      *                                                                                      BUG6479
047300200528      ** If MMM is used, then generate DTRIXX record for the option deal                     BUG6479
047400200528      ** so that cancellation messages can be generated.                                     BUG6479
047500200528      *                                                                                      BUG6479
047600200528     C                   IF        F3TYPE = 'OT' AND CSW025 = 'Y'                            BUG6479
047700200528     C                   EXSR      OP_WRTDTX                                                 BUG6479
047800200528     C                   MOVE      ##DEAL_MIS    @TEMP_MIS         1                         BUG6479
047900200528     C                   Z-ADD     ##SOL_VDAT    @TEMP_VDAT        5 0                       BUG6479
048000200528     C                   MOVE      'N'           ##DEAL_MIS                                  BUG6479
048100200528     C                   Z-ADD     0             ##SOL_VDAT                                  BUG6479
048200200528     C                   EXSR      UPDDTH                                                    BUG6479
048300200528     C                   MOVE      @TEMP_MIS     ##DEAL_MIS                                  BUG6479
048400200528     C                   Z-ADD     @TEMP_VDAT    ##SOL_VDAT                                  BUG6479
048500200528     C                   ENDIF                                                               BUG6479
048600200528                                                                                             BUG6479
048700200528     C                   END
048800200528      *
048900200528     C                   END
049000200528
049100200528      * SET CONFIRMATION REQUIRED INDICATOR
049200200528      * TO BE WRITTEN TO DTRIX
049300200528
049400200528     C                   EXSR      CNFINS
049500200528
049600200528      * INITIALIZE DEAL
049700200528
049800200528     C                   CLEAR                   DEALS
049900200528      *
050000200528      **  Record I.D./Deal Number/Record Type
050100200528      *
050200200528     C                   MOVE      'D'           RECI
050300200528     C                   MOVE      F3DN38        DLNO
050400200528     C                   MOVE      'B'           RCDT
050500200528      *
050600200528      **  Record Code
050700200528      *
050800200528     C     F3TYPE        IFEQ      'OP'
050900200528     C                   MOVE      '12'          RCDC
051000200528     C                   ELSE
051100200528     C     F3TYPE        IFEQ      'OT'
051200200528     C                   MOVE      '13'          RCDC
051300200528     C                   ELSE
051400200528     C     F3TYPE        IFEQ      'SW'
051500200528     C                   MOVE      '14'          RCDC
051600200528     C                   ELSE
051700200528     C                   MOVE      '11'          RCDC
051800200528     C                   END
051900200528     C                   END
052000200528     C                   END
052100200528      *
052200200528      **  Customer Number
052300200528      *
052400200528     C                   MOVE      F3DCNO        CNUM
052500200528      *
052600200528      **  Branch
052700200528      *
052800200528     C                   MOVE      F3MBCA        BRCA
052900200528      *
053000200528      **  Deal Type and Sub-type
053100200528      *
053200200528     C                   MOVE      F3TYPE        DTYP
053300200528     C                   MOVE      F3STYP        DLST
053400200528      *
053500200528      **  Deal date and value date
053600200528      *
053700200528     C                   MOVE      F3DDDN        DDAT
053800200528     C                   MOVE      F3VDDN        VDAT
053900200528      *
054000200528      ** Option to date
054100200528      ** (If swap, set to value date of associated deal - if present)
054200200528      *
054300200528     C     F3TYPE        IFEQ      'SW'
054400200528     C     F3BROK        OREQ      'SWAP'
054500200528     C     F3DTYP        OREQ      'S'                                                        242477
054600200528     C     ##ASOC        IFEQ      'Y'
054700200528     C                   MOVE      ##VDAT        OTDT
054800200528     C                   END
054900200528     C                   ELSE
055000200528     C                   MOVE      F3OTDN        OTDT
055100200528     C                   END
055200200528      *
055300200528      **    Account sequence number
055400200528     C                   MOVE      '01'          ZZ002
055500200528      *
055600200528      **  Broker Code and Brokerage Amount
055700200528      **  (If brokerage swap, set to values on associated deal - if present)
055800200528      *
055900200528     C     F3BROK        IFEQ      'SWAP'
056000200528     C     ##ASOC        ANDEQ     'Y'
056100200528     C                   MOVE      ##BRKC        BRKC
056200200528     C                   MOVE      ##BAGE        BAGE
056300200528     C                   ELSE
056400200528     C                   MOVE      F3BROK        BRKC
056500200528     C     F3BRKG        IFEQ      *ALL'9'
056600200528     C                   Z-ADD     0             BAGE
056700200528     C                   ELSE
056800200528     C                   MOVE      F3BRKG        BAGE
056900200528     C                   END
057000200528     C                   END
057100200528      *
057200200528      **  Purchase/Sale Currency and amounts, and exchange rate
057300200528      *
057400200528     C                   MOVE      F3CCY1        PUCY
057500200528     C                   Z-ADD     F3DAM1        PUAM
057600200528     C                   MOVE      F3DXRT        EXRT
057700200528     C                   MOVE      F3CCY2        SLCY
057800200528     C                   Z-SUB     F3DAM2        SLAM
057900200528      *
058000200528      **  Base Equivalent Amounts, and Original Purchase/Sale Amts.
058100200528      *
058200200528     C                   Z-ADD     F3BCAE        BCEQ
058300200528      *
058400200528     C     F3TYPE        IFEQ      'OP'
058500200528     C                   Z-ADD     F3BCAE        OBCE
058600200528     C                   Z-ADD     PUAM          ORPA
058700200528     C                   Z-ADD     SLAM          ORSA
058800200528     C                   ELSE
058900200528     C                   Z-ADD     *ZERO         OBCE
059000200528     C                   Z-ADD     *ZERO         ORPA
059100200528     C                   Z-ADD     *ZERO         ORSA
059200200528     C                   END
059300200528      *
059400200528      ** ACCESS PURCHASE CURRENCY DETAILS
059500200528      *
059600200528     C                   EXSR      ACSPCY
059700200528      *
059800200528      **  Limit Currency Exchange Rate
059900200528      *
060000200528     C                   Z-ADD     A6ERLC        LCXR
060100200528      *
060200200528      **  Our Pay/Receive Method & Instructions
060300200528      **  and Customer Pay/Receive Instructions
060400200528      *
060500200528     C                   MOVE      F3ORCM        PCST
060600200528     C                   MOVE      F3MORI        OPCA
060700200528     C                   MOVE      F3MCPI        TSCN
060800200528     C                   MOVE      F3MOPM        SCST
060900200528     C                   MOVE      F3MOPI        OSCA
061000200528     C                   MOVE      F3MCRI        TPCN
061100200528      *
061200200528      **  Swap Leg Indicator
061300200528      **  (Set according to value date on associated deal - if present)
061400200528      *
061500200528     C     F3TYPE        IFEQ      'SW'
061600200528     C     F3BROK        OREQ      'SWAP'
061700200528     C     F3DTYP        OREQ      'S'                                                        242477
061800200528     C     ##ASOC        IFEQ      'Y'
061900200528     C     F3VDDN        IFLT      ##VDAT
062000200528     C                   Z-ADD     1             FSLI
062100200528     C                   ELSE
062200200528     C                   Z-ADD     2             FSLI
062300200528     C                   END
062400200528     C                   END
062500200528     C                   END
062600200528      *
062700200528      **  Calculate Swap Profit/Loss and Currency
062800200528      **  (if associated deal is present)
062900200528      *
063000200528     C     F3TYPE        IFEQ      'SW'
063100200528     C     ##ASOC        ANDEQ     'Y'
063200200528     C                   EXSR      CALSPL
063300200528     C                   END
063400200528      *
063500200528      **  Swap/option deal number
063600200528      *
063700200528     C     F3TYPE        IFEQ      'SW'
063800200528     C     F3TYPE        OREQ      'OT'
063900200528     C     F3BROK        OREQ      'SWAP'
064000200528     C     F3DTYP        OREQ      'S'                                                        242477
064100200528     C                   MOVE      F3DADN        SODN
064200200528     C                   END
064300200528      *
064400200528      **  Deal For Account of/ Special Instructions
064500200528      *
064600200528     C                   MOVEL     F3MFAO        FACO
064700200528     C                   MOVEL     F3SPEC        SPI
064800200528      *
064900200528      **  INITIALIZE Indicators
065000200528      *
065100200528     C                   BITOFF    '01234567'    DNSI
065200200528     C                   BITOFF    '01234567'    DSTI
065300200528     C                   BITOFF    '01234567'    CNFI
065400200528     C                   BITOFF    '01234567'    ACEI
065500200528     C                   BITOFF    '01234567'    TLXI
065600200528      *
065700200528      * Brokerage
065800200528      *
065900200528     C     F3BROK        IFNE      'SWAP'
066000200528     C     F3BROK        ANDNE     'TELX'
066100200528     C     F3BROK        ANDNE     'PHON'
066200200528     C     F3BROK        ANDNE     'MAIL'
066300200528     C     F3BROK        ANDNE     *BLANK
066400200528     C     F3BRKG        IFEQ      *ALL'9'
066500200528     C                   BITON     '0'           DSTI
066600200528     C                   END
066700200528     C                   END
066800200528      *
066900200528      * Swap
067000200528      *
067100200528     C     F3BROK        IFEQ      'SWAP'
067200200528     C     F3TYPE        ANDEQ     'SW'
067300200528     C     ##ASOC        ANDEQ     'Y'
067400200528     C                   TESTB     '0'           ##DSTI                   99
067500200528     C     *IN99         IFEQ      '1'
067600200528     C                   BITON     '0'           DSTI
067700200528     C                   END
067800200528     C                   END
067900200528      *
068000200528     C     F3BROK        IFEQ      'SWAP'
068100200528     C                   BITON     '1'           DSTI
068200200528     C                   END
068300200528      *
068400200528      **  Federal Funds
068500200528      *
068600200528     C     F3FEDF        IFEQ      'Y'
068700200528     C     F3CCY1        ANDEQ     BLUSCY
068800200528     C                   BITON     '2'           DSTI
068900200528     C                   ELSE
069000200528     C                   BITOFF    '2'           DSTI
069100200528     C                   END
069200200528     C     F3FEDF        IFEQ      'Y'
069300200528     C     F3CCY2        ANDEQ     BLUSCY
069400200528     C                   BITON     '3'           DSTI
069500200528     C                   ELSE
069600200528     C                   BITOFF    '3'           DSTI
069700200528     C                   END
069800200528      *
069900200528      **  Last Change Fields
070000200528      *
070100200528     C                   Z-ADD     BJRDNB        ORED
070200200528     C                   Z-ADD     BJRDNB        LCD
070300200528     C                   MOVEL     'I'           CHTP
070400200528      *
070500200528      ** Book Code
070600200528     C                   MOVE      F3BOKC        BOKC
070700200528      *
070800200528      ** Linked Ref NO
070900200528     C                   MOVE      F3LNKN        LNKDN
071000200528      *
071100200528      * RECEIVE SETTLEMENT INSTRUCTIONS
071200200528      *
071300200528     C                   MOVEL     @FXREC        @DLREC
071400200528     C                   MOVEL     F3RONS        RONS                                         CGL029
071500200528      *                                                                                       CDL094
071600200528      * Enhanced Receive Settlement Instructions                                              CDL094
071700200528     C                   MOVEL     F3RBB1        RBTB1                                        CDL094
071800200528     C                   MOVEL     F3RBB2        RBTB2                                        CDL094
071900200528     C                   MOVEL     F3RBB3        RBTB3                                        CDL094
072000200528     C                   MOVEL     F3RBB4        RBTB4                                        CDL094
072100200528     C                   MOVEL     F3RBB5        RBTB5                                        CDL094
072200200528     C                   MOVEL     F3RBB6        RBTB6                                        CDL094
072300200528     C/COPY WNCPYSRC,FXFXDLDC06
072400200528      *
072500200528      * PAYMENT SETTLEMENT INSTRUCTIONS
072600200528      *
072700200528     C                   MOVEL     @FXPAY        @DLPAY
072800200528     C                   MOVEL     F3PONS        PONS                                         CGL029
072900200528     C/COPY WNCPYSRC,FXFXDLDC07
073000200528      *
073100200528      **  Originating Branch
073200200528      *
073300200528     C                   MOVEL     F3ORBR        ORBR
073400200528      *
073500200528      **  FX Profit Centre
073600200528      *
073700200528     C                   MOVEL     F3PRFC        PRFC
073800200528      *
073900200528      **  Our Receive Branch
074000200528      **  Our Pay Branch
074100200528      *
074200200528     C                   MOVEL     F3ROBR        ROBR
074300200528     C                   MOVEL     F3POBR        POBR
074400200528      *
074500200528      **  Cover Message Required
074600200528      *
074700200528     C*****F3CVMR        IFNE      'Y'                                                        220783
074800200528     C*****              MOVE      'N'           CVMR                                         220783
074900200528     C*****              ELSE                                                                 220783
075000200528     C*****              MOVE      'Y'           CVMR                                         220783
075100200528     C*****              END                                                                  220783
075200200528     C                   MOVE      F3CVMR        CVMR                                         220783
075300200528      *
075400200528      **  Margin points, amount, currency, buy/sell indicator
075500200528      *
075600200528     C                   MOVE      F3MGPT        MGPT
075700200528     C                   MOVE      F3MGAM        MGAM
075800200528     C                   MOVE      F3MGCY        MGCY
075900200528     C                   MOVE      F3MGBS        MGBS
076000200528      *
076100200528      **  Original spot rate
076200200528     C                   MOVE      F3OSRT        OSRT
076300200528      *
076400200528      * Forward Points
076500200528     C                   MOVE      F3FWPP        FWPT
076600200528      *
076700200528      ** Buy forward Points amount
076800200528      ** Sell forward Points amount
076900200528      ** Input DL base spot rate
077000200528      ** Other DL base spot rate
077100200528      ** Other DL base spot equiv
077200200528      ** Buy DL base fwd points
077300200528      ** Sell DL base fwd points
077400200528      ** Buy DL base fwd amount
077500200528      ** Sell DL base fwd amount
077600200528      *
077700200528     C                   MOVE      F3BFPA        BFPA
077800200528     C                   MOVE      F3SFPA        SFPA
077900200528     C                   MOVE      F3BDBS        BDBS
078000200528     C                   MOVE      F3SDBS        SDBS
078100200528     C                   MOVE      F3SDBE        SDBE
078200200528     C                   MOVE      F3BDBF        BDBF
078300200528     C                   MOVE      F3SDBF        SDBF
078400200528     C                   MOVE      F3BDFA        BDFA
078500200528     C                   MOVE      F3SDFA        SDFA
078600200528      *
078700200528      **  Portfolio Reference
078800200528      *
078900200528     C                   MOVE      F3PTFR        PTFR
079000200528      *
079100200528      **  FX Netting fields
079200200528      *
079300200528     C                   MOVE      F3NBUY        NETBY
079400200528     C                   MOVE      F3NBRF        NETBR
079500200528     C                   MOVE      F3NSEL        NETSL
079600200528     C                   MOVE      F3NSRF        NETSR
079700200528     C                   MOVE      F3MTCH        MATCH
079800200528      *
079900200528      ** EMU Settlement fields
080000200528      *
080100200528     C                   MOVEL     F3RSCY        RSCY
080200200528     C                   MOVEL     F3PSCY        PSCY
080300200528     C                   MOVEL     F3IC72        IC72
080400200528      *                                                                         CAP051
080500200528      ** Automatic Authorisation flag                                           CAP051
080600200528      *                                                                         CAP051
080700200528     C                   MOVEL     F3AUTH        AUTH                           CAP051
080800200528      *                                                                         CDL008
080900200528      ** CLS settlement.                                                        CDL008
081000200528     C                   IF        CDL008 = 'Y'                                 CDL008
081100200528     C                   EVAL      CLSS = F3CLSS                                CDL008
081200200528     C                   ENDIF                                                  CDL008
081300200528                                                                                              CAS001
081400200528      ** Yield Curves                                                                         CAS001
081500200528                                                                                              CAS001
081600200528     C                   IF        CAS001 = 'Y'                                               CAS001
081700200528     C/COPY WNCPYSRC,FXH00236
081800200528     C                   EVAL      FSOYLC = F3OYLC                                            CAS001
081900200528     C                   EVAL      FSTYLC = F3TYLC                                            CAS001
082000200528     C                   ENDIF                                                                CAS001
082100200528      *                                                                                       CDL038
082200200528      **  Class                                                                               CDL038
082300200528      *                                                                                       CDL038
082400200528     C                   MOVE      F3CLAS        CLAS                                         CDL038
082500200528     C                   MOVE      F3RRAT        FSRRAT                                       255340
082600200528      *                                                                                       CER043
082700200528      **  Reciprocal rate indicator                                                           CER043
082800200528      *                                                                                       CER043
082900200528     C                   IF        CER043 = 'Y'                                               CER043
083000200528     C                   EVAL      FGREIN = F3REIN                                            CER043
083100200528     C                   ENDIF                                                                CER043
083200200528      *                                                                                       CSW212
083300200528      ** ISDA                                                                                 CSW212
083400200528     C                   IF        CSW212 = 'Y'                                               CSW212
083500200528     C                   MOVEL     @FXISDA       @DLISDA                                      CSW212
083600200528     C                   ENDIF                                                                CSW212
083700200528      *                                                                                       CDL099
083800200528     C                   IF        CDL099 = 'Y'                                               CDL099
083900200528      *                                                                                       CDL099
084000200528     C                   Z-ADD     F3VS2Y        @@YY                                         CDL099
084100200528     C                   Z-ADD     F3VS2M        @@MM                                         CDL099
084200200528     C                   Z-ADD     F3VS2D        @@DD                                         CDL099
084300200528      *                                                                                       CDL099
084400200528     C                   CALLB     'ZDATE10'                                                  CDL099
084500200528     C                   PARM                    DateIn                                       CDL099
084600200528     C                   PARM                    ZZMDNO            5 0                        CDL099
084700200528     C                   Z-ADD     ZZMDNO        BSDT2                                        CDL099
084800200528      *                                                                                       CDL099
084900200528     C                   EVAL      BSDT1 = 0                                                  CDL099
085000200528     C                   EVAL      BRSD2 = 0                                                  CDL099
085100200528     C                   ENDIF                                                                CDL099
085200200528      *
085300200528      *  WRITE DEAL
085400200528      *
085500200528     C                   WRITE     DEALSDBF
085600200528                                                                                              CRE020
085700200528      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
085800200528                                                                                              CRE020
085900200528     C                   IF        CRE020 = 'Y' AND                                           CRE020
086000200528     C                             WSysVal01 = 'Y'                                            CRE020
086100200528     C                   EXSR      SRIdxTrn                                                   CRE020
086200200528     C                   ENDIF                                                                CRE020
086300200528                                                                                              CRE020
086400200528     C/COPY WNCPYSRC,FXFXDLDC01
086500200528      *
086600200528     C                   ENDSR
086700200528     C****************************************************************
086800200528      /EJECT
086900200528     C****************************************************************
087000200528     C*                                                              *
087100200528     C* SWAPUPINS - ASSOCIATED SWAP LEG UPDATE ON INSERT             *
087200200528     C*                                                              *
087300200528     C****************************************************************
087400200528     C     SWAPUPINS     BEGSR
087500200528      *
087600200528      **  Update Record Code, Deal Type, Option End Date
087700200528      *
087800200528     C                   Z-ADD     14            RCDC
087900200528     C                   MOVE      'SW'          DTYP
088000200528     C                   Z-ADD     F3VDDN        OTDT
088100200528      *
088200200528      **  Update Swap Leg indicator
088300200528      *
088400200528     C     F3VDDN        IFLT      ##VDAT
088500200528     C                   Z-ADD     2             FSLI
088600200528     C                   ELSE
088700200528     C                   Z-ADD     1             FSLI
088800200528     C                   END
088900200528      *
089000200528      **  Update other deal number
089100200528      *
089200200528     C                   Z-ADD     F3DN38        SODN
089300200528      *
089400200528      **  Calculate swap profit/loss
089500200528      *
089600200528     C                   EXSR      CALSPL
089700200528      *
089800200528      **  Flag as Brokerage swap
089900200528      *
090000200528     C     F3BROK        IFEQ      'SWAP'
090100200528     C                   BITON     '1'           DSTI
090200200528     C                   END
090300200528      *
090400200528     C                   ENDSR
090500200528     C****************************************************************
090600200528      /EJECT
090700200528     C****************************************************************
090800200528     C*                                                              *
090900200528     C* OPTNUPINS - ASSOCIATED OPTION UPDATE ON INSERT               *
091000200528     C*                                                              *
091100200528     C****************************************************************
091200200528     C     OPTNUPINS     BEGSR
091300200528      *
091400200528      *    Subtract option-taken-down purchased amount from purchased
091500200528      *               amount in the original deal.
091600200528      *
091700200528     C                   SUB       F3DAM1        PUAM
091800200528      *
091900200528      *    Subtract option-taken-down sell amount from sell amount
092000200528      *               in the original deal.
092100200528      *    (sell amount is signed negative)
092200200528      *
092300200528     C                   ADD       F3DAM2        SLAM
092400200528      *
092500200528      **  Reduce the margin amount of the related 'OP' deal
092600200528      *
092700200528     C                   SUB       F3MGAM        MGAM
092800200528      *
092900200528      **  Reduce the base currency equivalent of the related 'OP' deal
093000200528      *
093100200528     C                   SUB       F3BCAE        BCEQ
093200200528      *
093300200528     C                   BITON     '2'           DNSI
093400200528      *
093500200528     C                   ENDSR
093600200528     C****************************************************************
093700200528      /EJECT
093800200528     C****************************************************************
093900200528     C*                                                              *
094000200528     C* BSWPUPINS - ASSOCIATED BROKER SWAP UPDATE ON INSERT          *
094100200528     C*                                                              *
094200200528     C****************************************************************
094300200528     C     BSWPUPINS     BEGSR
094400200528      *
094500200528      **  Update option to date
094600200528      *
094700200528     C                   Z-ADD     F3VDDN        OTDT
094800200528      *
094900200528      **  Update the swap leg indicator
095000200528      *
095100200528     C     F3VDDN        IFLT      ##VDAT
095200200528     C                   Z-ADD     2             FSLI
095300200528     C                   ELSE
095400200528     C                   Z-ADD     1             FSLI
095500200528     C                   END
095600200528      *
095700200528      **  Update the other deal number
095800200528      *
095900200528     C                   Z-ADD     F3DN38        SODN
096000200528      *
096100200528     C                   BITON     '1'           DSTI
096200200528      *
096300200528     C                   ENDSR
096400200528     C****************************************************************
096500200528      /EJECT
096600200528     C****************************************************************
096700200528     C*                                                              *
096800200528     C* FXAMD  - AMEND AN FX DEAL                                    *
096900200528     C*                                                              *
097000200528     C****************************************************************
097100200528     C     FXAMD         BEGSR
097200200528      *
097300200528      * ACCESS DEAL
097400200528      *
097500200528     C*****F3DN38        CHAIN     DEALSDBF                           99                      231306
097600200528     C     F3DN38        CHAIN     DEALSDBF                           9998                    231306
097700200528      *                                                                                       231306
097800200528     C     *IN98         IFEQ      *ON                                                        231306
097900200528     C                   EXSR      SRERR                                                      231306
098000200528     C                   ENDIF                                                                231306
098100200528      *                                                                                       231306
098200200528      *
098300200528      ** DATABASE ERROR
098400200528      *
098500200528     C     *IN99         IFEQ      '1'
098600200528     C                   MOVEL     F3DN38        DBKEY
098700200528     C                   MOVEL     'DEALSDB '    DBFILE
098800200528     C                   MOVEL     '001'         DBASE
098900200528     C                   EXSR      SRERR
099000200528     C                   END
099100200528     C*                                                                                       247151
099200200528     C**********         MOVE      ' '           RecSd             1                   247151 260363
099300200528     C**********         MOVE      ' '           PaySd             1                   247151 260363
099400200528     C     @FXREC        IFNE      @DLREC                                                     247151
099500200528     C     F3RONS        ORNE      RONS                                                       247151
099600200528     C                   MOVE      'Y'           RecSd             1                          247151
099700200528     C                   Endif                                                                247151
099800200528     C     @FXPAY        IFNE      @DLPAY                                                     247151
099900200528     C     F3PONS        ORNE      PONS                                                       247151
100000200528     C                   MOVE      'Y'           PaySd             1                          247151
100100200528     C                   Endif                                                                247151
100200200528     C/COPY WNCPYSRC,FXH00246
100300200528      *
100400200528      * SET CONFIRMATION BIT ON DEAL
100500200528      * AND CONFIRMATION REQUIRED INDICATOR
100600200528      * TO BE WRITTEN TO DTRIX
100700200528      *
100800200528     C                   EXSR      CNFAMD
100900200528      *
101000200528      **  Customer Number
101100200528      *
101200200528     C                   MOVE      F3DCNO        CNUM
101300200528      *
101400200528      **  Branch
101500200528      *
101600200528     C                   MOVE      F3MBCA        BRCA
101700200528      *
101800200528      **  Deal Sub-type
101900200528      *
102000200528     C                   MOVE      F3STYP        DLST
102100200528      *
102200200528      **  Deal date
102300200528      *
102400200528     C                   MOVE      F3DDDN        DDAT
102500200528      *
102600200528      **  Broker Code and Brokerage Amount
102700200528      *
102800200528     C                   MOVE      F3BROK        BRKC
102900200528     C     F3BRKG        IFEQ      *ALL'9'
103000200528     C                   Z-ADD     0             BAGE
103100200528     C                   ELSE
103200200528     C                   MOVE      F3BRKG        BAGE
103300200528     C                   END
103400200528      *
103500200528      **  Our Pay/Receive Method & Instructions
103600200528      **  and Customer Pay/Receive Instructions
103700200528      *
103800200528     C                   MOVE      F3ORCM        PCST
103900200528     C                   MOVE      F3MORI        OPCA
104000200528     C                   MOVE      F3MCPI        TSCN
104100200528     C                   MOVE      F3MOPM        SCST
104200200528     C                   MOVE      F3MOPI        OSCA
104300200528     C                   MOVE      F3MCRI        TPCN
104400200528      *
104500200528      **  Deal For Account of/ Special Instructions
104600200528      *
104700200528     C                   MOVE      F3MFAO        FACO
104800200528     C                   MOVE      F3SPEC        SPI
104900200528      *
105000200528      ** Federal funds
105100200528      *
105200200528     C     F3FEDF        IFEQ      'Y'
105300200528     C     F3CCY1        ANDEQ     BLUSCY
105400200528     C                   BITON     '2'           DSTI
105500200528     C                   ELSE
105600200528     C                   BITOFF    '2'           DSTI
105700200528     C                   END
105800200528     C     F3FEDF        IFEQ      'Y'
105900200528     C     F3CCY2        ANDEQ     BLUSCY
106000200528     C                   BITON     '3'           DSTI
106100200528     C                   ELSE
106200200528     C                   BITOFF    '3'           DSTI
106300200528     C                   END
106400200528      *
106500200528      **  Last Change Fields
106600200528      *
106700200528     C                   Z-ADD     BJRDNB        LCD
106800200528     C                   MOVE      'A'           CHTP
106900200528      *
107000200528      ** Book Code
107100200528     C                   MOVE      F3BOKC        BOKC
107200200528      *
107300200528      ** Linked Ref NO
107400200528     C                   Z-ADD     F3LNKN        LNKDN
107500200528      *
107600200528      * RECEIVE SETTLEMENT INSTRUCTIONS
107700200528      *
107800200528     C                   MOVEL     @FXREC        @DLREC
107900200528     C                   MOVEL     F3RONS        RONS                                         CGL029
108000200528      *                                                                                       CDL094
108100200528      * Enhanced Receive Settlement Instructions                                              CDL094
108200200528     C                   MOVEL     F3RBB1        RBTB1                                        CDL094
108300200528     C                   MOVEL     F3RBB2        RBTB2                                        CDL094
108400200528     C                   MOVEL     F3RBB3        RBTB3                                        CDL094
108500200528     C                   MOVEL     F3RBB4        RBTB4                                        CDL094
108600200528     C                   MOVEL     F3RBB5        RBTB5                                        CDL094
108700200528     C                   MOVEL     F3RBB6        RBTB6                                        CDL094
108800200528     C/COPY WNCPYSRC,FXFXDLDC08
108900200528      *
109000200528      * PAYMENT SETTLEMENT INSTRUCTIONS
109100200528      *
109200200528     C/COPY WNCPYSRC,FXFXDLDC09
109300200528     C                   MOVEL     @FXPAY        @DLPAY
109400200528     C                   MOVEL     F3PONS        PONS                                         CGL029
109500200528      *
109600200528      **  Originating Branch
109700200528      *
109800200528     C                   MOVEL     F3ORBR        ORBR
109900200528      *
110000200528      **  FX Profit Centre
110100200528      *
110200200528     C                   MOVE      F3PRFC        PRFC
110300200528      *
110400200528      **  Our Receive Branch
110500200528      **  Our Pay Branch
110600200528      *
110700200528     C                   MOVEL     F3ROBR        ROBR
110800200528     C                   MOVEL     F3POBR        POBR
110900200528      *
111000200528      **  Cover Message Required
111100200528      *
111200200528     C*****F3CVMR        IFNE      'Y'                                                        220783
111300200528     C*****              MOVE      'N'           CVMR                                         220783
111400200528     C*****              ELSE                                                                 220783
111500200528     C*****              MOVE      'Y'           CVMR                                         220783
111600200528     C*****              END                                                                  220783
111700200528     C                   MOVE      F3CVMR        CVMR                                         220783
111800200528      *
111900200528      ** Buy forward Points amount
112000200528      ** Sell forward Points amount
112100200528      ** Input DL base spot rate
112200200528      ** Other DL base spot rate
112300200528      ** Other DL base spot equiv
112400200528      ** Buy DL base fwd points
112500200528      ** Sell DL base fwd points
112600200528      ** Buy DL base fwd amount
112700200528      ** Sell DL base fwd amount
112800200528      *
112900200528     C                   MOVE      F3BFPA        BFPA
113000200528     C                   MOVE      F3SFPA        SFPA
113100200528     C                   MOVE      F3BDBS        BDBS
113200200528     C                   MOVE      F3SDBS        SDBS
113300200528     C                   MOVE      F3SDBE        SDBE
113400200528     C                   MOVE      F3BDBF        BDBF
113500200528     C                   MOVE      F3SDBF        SDBF
113600200528     C                   MOVE      F3BDFA        BDFA
113700200528     C                   MOVE      F3SDFA        SDFA
113800200528      *
113900200528      ** Portfolio Reference
114000200528      *
114100200528     C                   MOVE      F3PTFR        PTFR
114200200528      *
114300200528      **  FX Netting fields
114400200528      *
114500200528     C                   MOVE      F3NBUY        NETBY
114600200528     C                   MOVE      F3NBRF        NETBR
114700200528     C                   MOVE      F3NSEL        NETSL
114800200528     C                   MOVE      F3NSRF        NETSR
114900200528     C                   MOVE      F3MTCH        MATCH
115000200528      *
115100200528      ** EMU Settlement fields
115200200528      *
115300200528     C                   MOVEL     F3RSCY        RSCY
115400200528     C                   MOVEL     F3PSCY        PSCY
115500200528     C                   MOVEL     F3IC72        IC72
115600200528      *                                                                         CAP051
115700200528      ** Automatic Authorisation flag                                           CAP051
115800200528      *                                                                         CAP051
115900200528     C                   MOVEL     F3AUTH        AUTH                           CAP051
116000200528      *                                                                         CDL008
116100200528      ** CLS settlement.                                                        CDL008
116200200528     C                   IF        CDL008 = 'Y'                                 CDL008
116300200528     C                   EVAL      CLSS = F3CLSS                                CDL008
116400200528     C                   ENDIF                                                  CDL008
116500200528                                                                                              CAS001
116600200528      ** Yield Curves                                                                         CAS001
116700200528                                                                                              CAS001
116800200528     C                   IF        CAS001 = 'Y'                                               CAS001
116900200528     C/COPY WNCPYSRC,FXH00237
117000200528     C                   EVAL      FSOYLC = F3OYLC                                            CAS001
117100200528     C                   EVAL      FSTYLC = F3TYLC                                            CAS001
117200200528     C                   ENDIF                                                                CAS001
117300200528      *                                                                                       CDL038
117400200528      **  Class                                                                               CDL038
117500200528      *                                                                                       CDL038
117600200528     C                   MOVE      F3CLAS        CLAS                                         CDL038
117700200528     C                   MOVE      F3RRAT        FSRRAT                                       255340
117800200528      *                                                                                       CER043
117900200528      **  Reciprocal rate indicator                                                           CER043
118000200528      *                                                                                       CER043
118100200528     C                   IF        CER043 = 'Y'                                               CER043
118200200528     C                   EVAL      FGREIN = F3REIN                                            CER043
118300200528     C                   ENDIF                                                                CER043
118400200528      *                                                                                       CSW212
118500200528      ** ISDA                                                                                 CSW212
118600200528     C                   IF        CSW212 = 'Y'                                               CSW212
118700200528     C                   MOVEL     @FXISDA       @DLISDA                                      CSW212
118800200528     C                   ENDIF                                                                CSW212
118900200528      *
119000200528      * UPDATE DEAL
119100200528      *
119200200528     C                   UPDATE    DEALSDBF
119300200528                                                                                              CRE020
119400200528      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
119500200528                                                                                              CRE020
119600200528     C                   IF        CRE020 = 'Y' AND                                           CRE020
119700200528     C                             WSysVal01 = 'Y'                                            CRE020
119800200528     C                   EXSR      SRIdxTrn                                                   CRE020
119900200528     C                   ENDIF                                                                CRE020
120000200528                                                                                              CRE020
120100200528     C/COPY WNCPYSRC,FXFXDLDC14
120200200528      *
120300200528     C                   ENDSR
120400200528     C****************************************************************
120500200528      /EJECT
120600200528     C****************************************************************
120700200528     C*                                                              *
120800200528     C* FXDEL  - DELETE AN FX DEAL                                   *
120900200528     C*                                                              *
121000200528     C****************************************************************
121100200528     C     FXDEL         BEGSR
121200200528      *
121300200528      ** ACCESS THE ASSOCIATED DEAL
121400200528      *
121500200528     C     F3TYPE        IFEQ      'SW'
121600200528     C     F3TYPE        OREQ      'OT'
121700200528     C     F3BROK        OREQ      'SWAP'
121800200528      *
121900200528     C                   MOVE      F3DADN        DLNO
122000200528     C*****DLNO          CHAIN     DEALSDBF                           99                      231306
122100200528     C     DLNO          CHAIN     DEALSDBF                           9998                    231306
122200200528      *                                                                                       231306
122300200528     C     *IN98         IFEQ      *ON                                                        231306
122400200528     C                   EXSR      SRERR                                                      231306
122500200528     C                   ENDIF                                                                231306
122600200528      *
122700200528      ** IF THE ASSOCIATED DEAL IS FOUND
122800200528      *
122900200528     C     *IN99         IFEQ      '0'
123000200528      *
123100200528      ** DO SWAP, OPTION OR BROKER SWAP UPDATES ON DELETION
123200200528      *
123300200528     C     F3TYPE        CASEQ     'SW'          SWAPUPDEL
123400200528     C     F3TYPE        CASEQ     'OT'          OPTNUPDEL
123500200528     C     F3BROK        CASEQ     'SWAP'        BSWPUPDEL
123600200528     C                   END
123700200528      *
123800200528      ** UPDATE THE ASSOCIATED DEAL
123900200528      *
124000200528     C                   Z-ADD     BJRDNB        LCD
124100200528     C                   UPDATE    DEALSDBF
124200200528      *                                                                                      BUG6479
124300200528      ** If MMM is used, then generate DTRIXX record for the option deal                     BUG6479
124400200528      ** so that cancellation messages can be generated.                                     BUG6479
124500200528      *                                                                                      BUG6479
124600200528     C                   IF        F3TYPE = 'OT' AND CSW025 = 'Y'                            BUG6479
124700200528     C                   EXSR      OP_WRTDTX                                                 BUG6479
124800200528     C                   MOVE      ##DEAL_MIS    @TEMP_MIS         1                         BUG6479
124900200528     C                   Z-ADD     ##SOL_VDAT    @TEMP_VDAT        5 0                       BUG6479
125000200528     C                   MOVE      'N'           ##DEAL_MIS                                  BUG6479
125100200528     C                   Z-ADD     0             ##SOL_VDAT                                  BUG6479
125200200528     C                   EXSR      UPDDTH                                                    BUG6479
125300200528     C                   MOVE      @TEMP_MIS     ##DEAL_MIS                                  BUG6479
125400200528     C                   Z-ADD     @TEMP_VDAT    ##SOL_VDAT                                  BUG6479
125500200528     C                   ENDIF                                                               BUG6479
125600200528                                                                                             BUG6479
125700200528     C                   END
125800200528     C                   END
125900200528      *
126000200528      * ACCESS DEAL
126100200528      *
126200200528     C*****F3DN38        CHAIN     DEALSDBF                           99                      231306
126300200528     C     F3DN38        CHAIN     DEALSDBF                           9998                    231306
126400200528      *                                                                                       231306
126500200528     C     *IN98         IFEQ      *ON                                                        231306
126600200528     C                   EXSR      SRERR                                                      231306
126700200528     C                   ENDIF                                                                231306
126800200528      *
126900200528      ** DATABASE ERROR IF DEAL IS NOT A SWAP
127000200528      *
127100200528     C     *IN99         IFEQ      '1'
127200200528     C     F3TYPE        IFEQ      'SW'
127300200528     C                   MOVEL     'Y'           ##DEAL_MIS        1
127400200528     C                   GOTO      EFXDEL
127500200528     C                   ELSE
127600200528     C                   MOVEL     F3DN38        DBKEY
127700200528     C                   MOVEL     'DEALSDB '    DBFILE
127800200528     C                   MOVEL     '002'         DBASE
127900200528     C                   EXSR      SRERR
128000200528     C                   END
128100200528     C                   END
128200200528      *
128300200528      * SET CONFIRMATION BIT ON DEAL
128400200528      * AND CONFIRMATION REQUIRED INDICATOR
128500200528      * TO BE WRITTEN TO DTRIX
128600200528      *
128700200528     C                   EXSR      CNFDEL
128800200528      *
128900200528      * SET RECORD ID TO 'REVERSED'
129000200528      *
129100200528     C                   MOVE      'R'           RECI
129200200528      *
129300200528      ** LAST CHANGE DATE & TYPE
129400200528      *
129500200528     C                   Z-ADD     BJRDNB        LCD
129600200528     C                   MOVE      'R'           CHTP
129700200528      *
129800200528     C                   UPDATE    DEALSDBF
129900200528                                                                                              CRE020
130000200528      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
130100200528                                                                                              CRE020
130200200528     C                   IF        CRE020 = 'Y' AND                                           CRE020
130300200528     C                             WSysVal01 = 'Y'                                            CRE020
130400200528     C                   EXSR      SRIdxTrn                                                   CRE020
130500200528     C                   ENDIF                                                                CRE020
130600200528                                                                                              CRE020
130700200528     C/COPY WNCPYSRC,FXFXDLDC15
130800200528      *
130900200528     C     EFXDEL        ENDSR
131000200528     C****************************************************************
131100200528      /EJECT
131200200528     C****************************************************************
131300200528     C*                                                              *
131400200528     C* SWAPUPDEL - ASSOCIATED SWAP LEG UPDATE ON DELETION           *
131500200528     C*                                                              *
131600200528     C****************************************************************
131700200528     C     SWAPUPDEL     BEGSR
131800200528      *
131900200528      ** Reverse other deal/leg
132000200528      *
132100200528     C                   MOVE      'R'           RECI
132200200528      *
132300200528      ** If confirmation previously produced, produce another one
132400200528      *
132500200528     C                   TESTB     '7'           CNFI                     99
132600200528     C     *IN99         IFEQ      '1'
132700200528     C                   BITOFF    '0'           CNFI
132800200528     C                   END
132900200528      *
133000200528      ** Change Type is reversal
133100200528      *
133200200528     C                   MOVE      'R'           CHTP
133300200528      *
133400200528      ** Store from swap other leg reversed:
133500200528      ** . value date
133600200528      ** . purchase amount
133700200528      ** . purchase currency, receive settle method & receive our nostro
133800200528      ** . sell currency, payment settle method & payment our nostro
133900200528      *
134000200528     C                   Z-ADD     VDAT          ##SOL_VDAT        5 0
134100200528     C                   Z-ADD     PUAM          ##SOL_PUAM       13 0
134200200528     C                   MOVE      PUCY          ##SOL_PUCY        3
134300200528     C                   MOVE      RSCY          ##SOL_RSCY        3
134400200528     C                   Z-ADD     RSTM          ##SOL_RSTM        2 0
134500200528     C**********         MOVE      RONS          ##SOL_RONS       12                          CGL029
134600200528     C                   MOVE      RONS          ##SOL_RONS       18                          CGL029
134700200528     C                   MOVE      SLCY          ##SOL_SLCY        3
134800200528     C                   MOVE      PSCY          ##SOL_PSCY        3
134900200528     C                   Z-ADD     PSTM          ##SOL_PSTM        2 0
135000200528     C**********         MOVE      PONS          ##SOL_PONS       12                          CGL029
135100200528     C                   MOVE      PONS          ##SOL_PONS       18                          CGL029
135200200528      *
135300200528     C                   ENDSR
135400200528     C****************************************************************
135500200528      /EJECT
135600200528     C****************************************************************
135700200528     C*                                                              *
135800200528     C* OPTNUPDEL - ASSOCIATED OPTION UPDATE ON DELETION             *
135900200528     C*                                                              *
136000200528     C****************************************************************
136100200528     C     OPTNUPDEL     BEGSR
136200200528      *
136300200528      *    Add option-taken-down purchased amount to purchased
136400200528      *               amount in the original deal.
136500200528      *
136600200528     C                   ADD       F3DAM1        PUAM
136700200528      *
136800200528      *    Add option-taken-down sell amount to sell amount
136900200528      *               in the original deal.
137000200528      *    (sell amount is signed negative)
137100200528      *
137200200528     C                   SUB       F3DAM2        SLAM
137300200528      *
137400200528      **  Increase the margin amount of the related 'OP' deal
137500200528      *
137600200528     C                   ADD       F3MGAM        MGAM
137700200528      *
137800200528      **  Increase the base currency equivalent of the related 'OP' deal
137900200528      *
138000200528     C                   ADD       F3BCAE        BCEQ
138100200528      *
138200200528     C                   BITON     '2'           DNSI
138300200528      *
138400200528      ** Change Type is amend
138500200528      *
138600200528     C                   MOVE      'A'           CHTP
138700200528      *
138800200528     C                   ENDSR
138900200528     C****************************************************************
139000200528      /EJECT
139100200528     C****************************************************************
139200200528     C*                                                              *
139300200528     C* BSWPUPDEL - ASSOCIATED BROKER SWAP UPDATE ON DELETION        *
139400200528     C*                                                              *
139500200528     C****************************************************************
139600200528     C     BSWPUPDEL     BEGSR
139700200528      *
139800200528      **   Reverse related brokerage swaps
139900200528      **   Zeroise Swap Other Leg Value Date, Swap Leg Indicator,
140000200528      **    and related deal number, and set deal static indicator.
140100200528      *
140200200528     C                   Z-ADD     *ZERO         OTDT
140300200528     C                   Z-ADD     *ZERO         FSLI
140400200528     C                   Z-ADD     *ZERO         SODN
140500200528     C                   BITOFF    '1'           DSTI
140600200528     C     CHTP          IFNE      'R'                                                        207072
140700200528     C                   MOVE      'A'           CHTP
140800200528     C                   ENDIF                                                                207072
140900200528      *
141000200528     C                   ENDSR
141100200528     C****************************************************************
141200200528      /EJECT
141300200528     C****************************************************************
141400200528     C*                                                              *
141500200528     C* CALSPL - CALCULATE SWAP ROFIT/LOSS AND CURRENCY              *
141600200528     C*                                                              *
141700200528     C****************************************************************
141800200528     C     CALSPL        BEGSR
141900200528      *
142000200528      * Swap profit/loss is in purchase currency
142100200528      * of primary deal being updated
142200200528      *
142300200528     C     F3DAM1        IFNE      ##SLAM
142400200528     C     F3DAM1        SUB       ##SLAM        SPLA
142500200528     C                   MOVE      F3CCY1        SPLC
142600200528     C                   ELSE
142700200528      *
142800200528      * Swap profit/loss is in sale currency
142900200528      * of primary deal being updated
143000200528      * (note that sell amount is signed negative)
143100200528      *
143200200528     C     ##PUAM        ADD       F3DAM2        SPLA
143300200528     C                   MOVE      F3CCY2        SPLC
143400200528     C                   END
143500200528      *
143600200528     C                   ENDSR
143700200528     C****************************************************************
143800200528      /EJECT
143900200528     C****************************************************************
144000200528     C*                                                              *
144100200528     C* PYRCIN - DETERMINE PAY/RECEIVE INDICATORS                    *
144200200528     C*                                                              *
144300200528     C****************************************************************
144400200528     C     PYRCIN        BEGSR
144500200528      *
144600200528     C                   Z-ADD     *ZERO         @@PRI1            1 0
144700200528     C                   Z-ADD     *ZERO         @@PRI2            1 0
144800200528     C                   Z-ADD     *ZERO         @@PRI3            1 0
144900200528     C*                                                                                       247151
145000200528     C     RecSd         Ifeq      ' '                                                        247151
145100200528     C     PaySd         Andeq     ' '                                                        247151
145200200528      *
145300200528      *  Deal event date
145400200528      *
145500200528     C     F3TYPE        IFEQ      'OP'
145600200528     C                   Z-ADD     F3OTDN        @@EDAT            5 0
145700200528     C                   ELSE
145800200528     C                   Z-ADD     F3VDDN        @@EDAT
145900200528     C                   END
146000200528      *
146100200528      * PAY/RECEIVE INDICATOR 1 = PURCHASE CURRENCY
146200200528      * -------------------------------------------
146300200528      *
146400200528      ** Determine if local or purchase currency to be used
146500200528      ** in holiday checking
146600200528      *
146700200528     C     F3RSCY        IFNE      *BLANK
146800200528     C                   MOVE      F3RSCY        @CCY
146900200528     C                   ELSE
147000200528     C                   MOVE      F3CCY1        @CCY
147100200528     C                   END
147200200528      *
147300200528     C                   MOVEL     'L'           @DLOLC
147400200528     C                   MOVEL     *BLANK        @NOSTR
147500200528      *
147600200528     C     F3RSTM        IFEQ      01
147700200528     C     F3RSTM        OREQ      07
147800200528     C     F3RSTM        OREQ      08
147900200528     C                   MOVE      'D'           @DLOLC
148000200528     C                   MOVEL     F3RONS        @NOSTR
148100200528     C                   END
148200200528      *
148300200528      ** DETERMINE TELEX DUE DATE
148400200528      *
148500200528     C                   EXSR      TLXDUE
148600200528      *
148700200528      * Set PRI1 if event date is within telex notice period
148800200528      *
148900200528     C     @@EDAT        IFGE      BJRDNB
149000200528     C     @@EDAT        ANDLE     @TLXDU
149100200528     C/COPY WNCPYSRC,FXFXDLDC10
149200200528     C                   Z-ADD     1             @@PRI1
149300200528     C                   END
149400200528      *
149500200528      ** PAY/RECEIVE INDICATOR 3 = SELL CURRENCY
149600200528      *  ---------------------------------------
149700200528      *
149800200528      ** Determine if local or sell currency to be used
149900200528      ** in holiday checking
150000200528      *
150100200528     C     F3PSCY        IFNE      *BLANK
150200200528     C                   MOVE      F3PSCY        @CCY
150300200528     C                   ELSE
150400200528     C                   MOVE      F3CCY2        @CCY
150500200528     C                   END
150600200528      *
150700200528     C                   MOVEL     'L'           @DLOLC
150800200528     C                   MOVEL     *BLANK        @NOSTR
150900200528      *
151000200528     C     F3PSTM        IFEQ      01
151100200528     C     F3PSTM        OREQ      07
151200200528     C     F3PSTM        OREQ      08
151300200528     C                   MOVE      'D'           @DLOLC
151400200528     C                   MOVEL     F3PONS        @NOSTR
151500200528     C                   END
151600200528      *
151700200528      ** DETERMINE TELEX DUE DATE
151800200528      *
151900200528     C                   EXSR      TLXDUE
152000200528      *
152100200528      * Set PRI3 if event date is within telex notice period
152200200528      *
152300200528     C     @@EDAT        IFGE      BJRDNB
152400200528     C     @@EDAT        ANDLE     @TLXDU
152500200528     C/COPY WNCPYSRC,FXFXDLDC11
152600200528     C                   Z-ADD     1             @@PRI3
152700200528     C                   END
152800200528     C*                                                                                       247151
152900200528     C                   Else                                                                 247151
153000200528      *                                                                                       260363
153100200528      *  Deal event date                                                                      260363
153200200528      *                                                                                       260363
153300200528     C     F3TYPE        IFEQ      'OP'                                                       260363
153400200528     C                   Z-ADD     F3OTDN        @@EDAT            5 0                        260363
153500200528     C                   ELSE                                                                 260363
153600200528     C                   Z-ADD     F3VDDN        @@EDAT                                       260363
153700200528     C                   ENDIF                                                                260363
153800200528      *                                                                                       260363
153900200528     C     RecSd         Ifeq      'Y'                                                        247151
154000200528     C**********         Z-ADD     1             @@PRI1                                247151 260363
154100200528      *                                                                                       260363
154200200528      * PAY/RECEIVE INDICATOR 1 = PURCHASE CURRENCY                                           260363
154300200528      * -------------------------------------------                                           260363
154400200528      *                                                                                       260363
154500200528      ** Determine if local or purchase currency to be used                                   260363
154600200528      ** in holiday checking                                                                  260363
154700200528      *                                                                                       260363
154800200528     C     F3RSCY        IFNE      *BLANK                                                     260363
154900200528     C                   MOVE      F3RSCY        @CCY                                         260363
155000200528     C                   ELSE                                                                 260363
155100200528     C                   MOVE      F3CCY1        @CCY                                         260363
155200200528     C                   ENDIF                                                                260363
155300200528      *                                                                                       260363
155400200528     C                   MOVEL     'L'           @DLOLC                                       260363
155500200528     C                   MOVEL     *BLANK        @NOSTR                                       260363
155600200528      *                                                                                       260363
155700200528     C     F3RSTM        IFEQ      01                                                         260363
155800200528     C     F3RSTM        OREQ      07                                                         260363
155900200528     C     F3RSTM        OREQ      08                                                         260363
156000200528     C                   MOVE      'D'           @DLOLC                                       260363
156100200528     C                   MOVEL     F3RONS        @NOSTR                                       260363
156200200528     C                   ENDIF                                                                260363
156300200528      *                                                                                       260363
156400200528      ** DETERMINE TELEX DUE DATE                                                             260363
156500200528      *                                                                                       260363
156600200528     C                   EXSR      TLXDUE                                                     260363
156700200528      *                                                                                       260363
156800200528      * Set PRI1 if event date is within telex notice period                                  260363
156900200528      *                                                                                       260363
157000200528     C     @@EDAT        IFGE      BJRDNB                                                     260363
157100200528     C     @@EDAT        ANDLE     @TLXDU                                                     260363
157200200528     C                   Z-ADD     1             @@PRI1                                       260363
157300200528     C                   ENDIF                                                                260363
157400200528      *                                                                                       260363
157500200528     C                   Endif                                                                247151
157600200528     C     PaySd         Ifeq      'Y'                                                        247151
157700200528     C**********         Z-ADD     1             @@PRI3                                247151 260363
157800200528      *                                                                                       260363
157900200528      ** PAY/RECEIVE INDICATOR 3 = SELL CURRENCY                                              260363
158000200528      *  ---------------------------------------                                              260363
158100200528      *                                                                                       260363
158200200528      ** Determine if local or sell currency to be used                                       260363
158300200528      ** in holiday checking                                                                  260363
158400200528      *                                                                                       260363
158500200528     C     F3PSCY        IFNE      *BLANK                                                     260363
158600200528     C                   MOVE      F3PSCY        @CCY                                         260363
158700200528     C                   ELSE                                                                 260363
158800200528     C                   MOVE      F3CCY2        @CCY                                         260363
158900200528     C                   ENDIF                                                                260363
159000200528      *                                                                                       260363
159100200528     C                   MOVEL     'L'           @DLOLC                                       260363
159200200528     C                   MOVEL     *BLANK        @NOSTR                                       260363
159300200528      *                                                                                       260363
159400200528     C     F3PSTM        IFEQ      01                                                         260363
159500200528     C     F3PSTM        OREQ      07                                                         260363
159600200528     C     F3PSTM        OREQ      08                                                         260363
159700200528     C                   MOVE      'D'           @DLOLC                                       260363
159800200528     C                   MOVEL     F3PONS        @NOSTR                                       260363
159900200528     C                   ENDIF                                                                260363
160000200528      *                                                                                       260363
160100200528      ** DETERMINE TELEX DUE DATE                                                             260363
160200200528      *                                                                                       260363
160300200528     C                   EXSR      TLXDUE                                                     260363
160400200528      *                                                                                       260363
160500200528      * Set PRI3 if event date is within telex notice period                                  260363
160600200528      *                                                                                       260363
160700200528     C     @@EDAT        IFGE      BJRDNB                                                     260363
160800200528     C     @@EDAT        ANDLE     @TLXDU                                                     260363
160900200528     C                   Z-ADD     1             @@PRI3                                       260363
161000200528     C                   ENDIF                                                                260363
161100200528      *                                                                                       260363
161200200528     C                   Endif                                                                247151
161300200528     C                   Endif                                                                247151
161400200528      *
161500200528     C                   ENDSR
161600200528     C****************************************************************
161700200528      /EJECT
161800200528     C****************************************************************
161900200528     C*                                                              *
162000200528     C* SOL_PYRCIN - DETERMINE SWAP OTHER LEG PAY/RECEIVE INDICATORS *
162100200528     C*                                                              *
162200200528     C****************************************************************
162300200528     C     SOL_PYRCIN    BEGSR
162400200528      *
162500200528     C                   Z-ADD     *ZERO         @@PRI1            1 0
162600200528     C                   Z-ADD     *ZERO         @@PRI2            1 0
162700200528     C                   Z-ADD     *ZERO         @@PRI3            1 0
162800200528      *
162900200528      * PAY/RECEIVE INDICATOR 1 = PURCHASE CURRENCY
163000200528      * -------------------------------------------
163100200528      *
163200200528      ** Determine if local or purchase currency to be used
163300200528      ** in holiday checking
163400200528      *
163500200528     C     ##SOL_RSCY    IFNE      *BLANK
163600200528     C                   MOVE      ##SOL_RSCY    @CCY
163700200528     C                   ELSE
163800200528     C                   MOVE      ##SOL_PUCY    @CCY
163900200528     C                   END
164000200528      *
164100200528     C                   MOVEL     'L'           @DLOLC
164200200528     C                   MOVEL     *BLANK        @NOSTR
164300200528      *
164400200528     C     ##SOL_RSTM    IFEQ      01
164500200528     C     ##SOL_RSTM    OREQ      07
164600200528     C     ##SOL_RSTM    OREQ      08
164700200528     C                   MOVE      'D'           @DLOLC
164800200528     C                   MOVEL     ##SOL_RONS    @NOSTR
164900200528     C                   END
165000200528      *
165100200528      ** DETERMINE TELEX DUE DATE
165200200528      *
165300200528     C                   EXSR      TLXDUE
165400200528      *
165500200528      * Set PRI1 if value date is within telex notice period
165600200528      *
165700200528     C     ##SOL_VDAT    IFGE      BJRDNB
165800200528     C     ##SOL_VDAT    ANDLE     @TLXDU
165900200528     C/COPY WNCPYSRC,FXFXDLDC12
166000200528     C                   Z-ADD     1             @@PRI1
166100200528     C                   END
166200200528      *
166300200528      ** PAY/RECEIVE INDICATOR 3 = SELL CURRENCY
166400200528      *  ---------------------------------------
166500200528      *
166600200528      ** Determine if local or sell currency to be used
166700200528      ** in holiday checking
166800200528      *
166900200528     C     ##SOL_PSCY    IFNE      *BLANK
167000200528     C                   MOVE      ##SOL_PSCY    @CCY
167100200528     C                   ELSE
167200200528     C                   MOVE      ##SOL_SLCY    @CCY
167300200528     C                   END
167400200528      *
167500200528     C                   MOVEL     'L'           @DLOLC
167600200528     C                   MOVEL     *BLANK        @NOSTR
167700200528      *
167800200528     C     ##SOL_PSTM    IFEQ      01
167900200528     C     ##SOL_PSTM    OREQ      07
168000200528     C     ##SOL_PSTM    OREQ      08
168100200528     C                   MOVE      'D'           @DLOLC
168200200528     C                   MOVEL     ##SOL_PONS    @NOSTR
168300200528     C                   END
168400200528      *
168500200528      ** DETERMINE TELEX DUE DATE
168600200528      *
168700200528     C                   EXSR      TLXDUE
168800200528      *
168900200528      * Set PRI3 if value date is within telex notice period
169000200528      *
169100200528     C     ##SOL_VDAT    IFGE      BJRDNB
169200200528     C     ##SOL_VDAT    ANDLE     @TLXDU
169300200528     C     ##SOL_SDT2    ANDEQ     0                                                          CDL099
169400200528     C     ##SOL_SDT2    ORGT      0                                                          CDL099
169500200528     C     ##SOL_SDT2    ANDGE     BJRDNB                                                     CDL099
169600200528     C     ##SOL_SDT2    ANDLE     @TLXDU                                                     CDL099
169700200528     C     CDL099        ANDEQ     'Y'                                                        CDL099
169800200528      *                                                                                       CDL099
169900200528     C/COPY WNCPYSRC,FXFXDLDC13
170000200528     C                   Z-ADD     1             @@PRI3
170100200528     C                   END
170200200528      *
170300200528     C                   ENDSR
170400200528     C****************************************************************
170500200528      /EJECT
170600200528     C****************************************************************
170700200528     C*                                                              *
170800200528     C* CNFINS - SET CONFIRMATION INDICATOR ON INSERTION             *
170900200528     C*                                                              *
171000200528     C****************************************************************
171100200528     C     CNFINS        BEGSR
171200200528      *
171300200528     C                   MOVE      'N'           @@CNRQ            1
171400200528      *
171500200528      *
171600200528      * CONFIRMATION REQUIRED IF SETTLEMENT INSTRUCTIONS PRESENT
171700200528      * OR IF 2 LEVEL INPUT NOT PRESENT
171800200528      *
171900200528     C     F3RSTM        IFNE      *ZERO
172000200528     C     F3PSTM        ORNE      *ZERO
172100200528     C     BLL2II        OREQ      'N'
172200200528     C                   MOVE      'Y'           @@CNRQ
172300200528     C                   END
172400200528      *
172500200528      ** Confirmation Required indicator is 'N' for transactions                              CTI004
172600200528      ** coming from TI.                                                                      CTI004
172700200528      *                                                                                       CTI004
172800200528     C     CTI004        IFEQ      'Y'                                                        CTI004
172900200528     C     BGN3ST        ANDEQ     'Y'                                                        CTI004
173000200528     C     CTI006        OREQ      'Y'                                                      MD030956
173100200528     C     F3STYP        IFEQ      TIDLST                                                     CTI004
173200200528     C                   MOVE      'N'           @@CNRQ                                       CTI004
173300200528     C                   ENDIF                                                                CTI004
173400200528     C                   ENDIF                                                                CTI004
173500200528      *                                                                                       CTI004
173600200528     C                   ENDSR
173700200528     C****************************************************************
173800200528      /EJECT
173900200528     C****************************************************************
174000200528     C*                                                              *
174100200528     C* CNFAMD - SET CONFIRMATION INDICATOR ON AMENDMENT             *
174200200528     C*                                                              *
174300200528     C****************************************************************
174400200528     C     CNFAMD        BEGSR
174500200528     C                   MOVE      'N'           @@CNRQ                                       155792
174600200528      *
174700200528      * IF SETTLEMENT INSTRUCTIONS WERE PREVIOUSLY PRESENT
174800200528      * OR IF 2 LEVEL INPUT NOT PRESENT
174900200528      *
175000200528     C     RSTM          IFNE      *ZERO
175100200528     C     PSTM          ORNE      *ZERO
175200200528     C     F3RSTM        ORNE      *ZERO                                                      209895
175300200528     C     F3PSTM        ORNE      *ZERO                                                      209895
175400200528     C     BLL2II        OREQ      'N'
175500200528      *
175600200528      ** If settlement instruction fields have changed
175700200528      *
175800200528     C     RSTM          IFNE      F3RSTM
175900200528     C     RONS          ORNE      F3RONS
176000200528     C     RIBN          ORNE      F3RIBN
176100200528     C     RIBA          ORNE      F3RIBA                                                     155792
176200200528     C     ROBN          ORNE      F3ROBN                                                     155792
176300200528     C     ROCN          ORNE      F3ROCN                                                     155792
176400200528     C     PSTM          ORNE      F3PSTM
176500200528     C     PONS          ORNE      F3PONS
176600200528     C     PIBN          ORNE      F3PIBN                                                     155792
176700200528     C     PIBA          ORNE      F3PIBA                                                     155792
176800200528     C     POBN          ORNE      F3POBN                                                     155792
176900200528     C     POCN          ORNE      F3POCN                                                     155792
177000200528     C     RCRN          ORNE      F3RCRN                                                     155792
177100200528     C     RCRA          ORNE      F3RCRA                                                     155792
177200200528     C     RVNO          ORNE      F3RVNO                                                     155792
177300200528     C     AWBN          ORNE      F3AWBN
177400200528     C     AWBA          ORNE      F3AWBA                                                     155792
177500200528     C     BENN          ORNE      F3BENN
177600200528     C     BENA          ORNE      F3BENA                                                     155792
177700200528     C     DTP1          ORNE      F3DTP1                                                     155792
177800200528     C     DTP2          ORNE      F3DTP2                                                     155792
177900200528     C     DTP3          ORNE      F3DTP3                                                     155792
178000200528     C     DTP4          ORNE      F3DTP4                                                     155792
178100200528     C     DCHG          ORNE      F3DCHG                                                     155792
178200200528     C     BTB1          ORNE      F3BTB1
178300200528     C     BTB2          ORNE      F3BTB2                                                     155792
178400200528     C     BTB3          ORNE      F3BTB3                                                     155792
178500200528     C     BTB4          ORNE      F3BTB4                                                     155792
178600200528     C     BTB5          ORNE      F3BTB5                                                     155792
178700200528     C     BTB6          ORNE      F3BTB6                                                     155792
178800200528     C     RBTB1         ORNE      F3RBB1                                                     CDL094
178900200528     C     RBTB2         ORNE      F3RBB2                                                     CDL094
179000200528     C     RBTB3         ORNE      F3RBB3                                                     CDL094
179100200528     C     RBTB4         ORNE      F3RBB4                                                     CDL094
179200200528     C     RBTB5         ORNE      F3RBB5                                                     CDL094
179300200528     C     RBTB6         ORNE      F3RBB6                                                     CDL094
179400200528     C*****CVMR*         ORNE      F3CVMR                                             155792 BUG6191
179500200528     C     CVMR          OREQ      'Y'                                                       BUG6191
179600200528     C     F3CVMR        ANDNE     'Y'                                                       BUG6191
179700200528     C     CVMR          OREQ      'N'                                                       BUG6191
179800200528     C     F3CVMR        ANDNE     'N'                                                       BUG6191
179900200528     C     F3CVMR        ANDNE     ' '                                                       BUG6191
180000200528     C     RSCY          ORNE      F3RSCY                                                     155792
180100200528     C     PSCY          ORNE      F3PSCY                                                     155792
180200200528     C     IC72          ORNE      F3IC72                                                     155792
180300200528     C     CLSS          ORNE      F3CLSS                                       CDL008
180400200528     C     CDL008        ANDEQ     'Y'                                          CDL008
180500200528     C     FSOYLC        ORNE      F3OYLC                                                     CAS001
180600200528     C     CAS001        ANDEQ     'Y'                                                        CAS001
180700200528     C     FSTYLC        ORNE      F3TYLC                                                     CAS001
180800200528     C     CAS001        ANDEQ     'Y'                                                        CAS001
180900200528      ** If Buy/Sell Indicators have changed                                                  240603
181000200528      *                                                                                       240603
181100200528     C*****F3NBUY        OREQ      'Y'                                                 240603 246387
181200200528     C*****NETBY         ANDNE     'Y'                                                 240603 246387
181300200528     C*****F3NSEL        OREQ      'Y'                                                 240603 246387
181400200528     C*****NETSL         ANDNE     'Y'                                                 240603 246387
181500200528     C     CSW050        OREQ      'Y'                                                        246801
181600200528     C     F3NBUY        ORNE      NETBY                                                      246387
181700200528     C     F3NSEL        ORNE      NETSL                                                      246387
181800200528     C     SSR1          ORNE      F3SSR1                                                   AR990243
181900200528     C     SSR2          ORNE      F3SSR2                                                   AR990243
182000200528     C     SSR3          ORNE      F3SSR3                                                   AR990243
182100200528     C     SSR4          ORNE      F3SSR4                                                   AR990243
182200200528     C     SSR5          ORNE      F3SSR5                                                   AR990243
182300200528     C     SSR6          ORNE      F3SSR6                                                   AR990243
182400200528     C     CND1          ORNE      F3CND1                                                   AR990243
182500200528     C     CND2          ORNE      F3CND2                                                   AR990243
182600200528     C     CND3          ORNE      F3CND3                                                   AR990243
182700200528     C     CND4          ORNE      F3CND4                                                   AR990243
182800200528     C     CND5          ORNE      F3CND5                                                   AR990243
182900200528     C     CND6          ORNE      F3CND6                                                   AR990243
183000200528     C     ISDA          ORNE      F3ISDA                                                   AR990243
183100200528     C     AGTY          ORNE      F3AGTY                                                   AR990243
183200200528     C     AGDT          ORNE      F3AGDT                                                   AR990243
183300200528     C     AGVV          ORNE      F3AGVV                                                   AR990243
183400200528     C     AGVC          ORNE      F3AGVC                                                   AR990243
183500200528     C/COPY WNCPYSRC,FXH00247
183600200528      *
183700200528      ** Produce a confirmation now
183800200528      *
183900200528     C                   BITOFF    '0'           CNFI
184000200528     C                   MOVE      'Y'           @@CNRQ
184100200528      *
184200200528     C                   END
184300200528     C                   END
184400200528      *
184500200528      ** Confirmation Required indicator is 'N' for transactions                              CTI004
184600200528      ** coming from TI.                                                                      CTI004
184700200528      *                                                                                       CTI004
184800200528     C     CTI004        IFEQ      'Y'                                                        CTI004
184900200528     C     BGN3ST        ANDEQ     'Y'                                                        CTI004
185000200528     C     CTI006        OREQ      'Y'                                                      MD030956
185100200528     C     F3STYP        IFEQ      TIDLST                                                     CTI004
185200200528     C                   MOVE      'N'           @@CNRQ                                       CTI004
185300200528     C                   ENDIF                                                                CTI004
185400200528     C                   ENDIF                                                                CTI004
185500200528      *                                                                                       CTI004
185600200528     C                   ENDSR
185700200528     C****************************************************************
185800200528      /EJECT
185900200528     C****************************************************************
186000200528     C*                                                              *
186100200528     C* CNFDEL - SET CONFIRMATION INDICATOR ON DELETION              *
186200200528     C*                                                              *
186300200528     C****************************************************************
186400200528     C     CNFDEL        BEGSR
186500200528     C                   MOVE      'N'           @@CNRQ                                       155792
186600200528      *
186700200528      * CONFIRMATION REQUIRED IF ONE PRODUCED PREVIOUSLY
186800200528      *
186900200528     C                   TESTB     '7'           CNFI                     99
187000200528     C     *IN99         IFEQ      '1'
187100200528     C                   BITOFF    '0'           CNFI
187200200528     C                   MOVE      'Y'           @@CNRQ
187300200528     C                   END
187400200528      *
187500200528      ** Confirmation Required indicator is 'N' for transactions                              CTI004
187600200528      ** coming from TI.                                                                      CTI004
187700200528      *                                                                                       CTI004
187800200528     C     CTI004        IFEQ      'Y'                                                        CTI004
187900200528     C     BGN3ST        ANDEQ     'Y'                                                        CTI004
188000200528     C     CTI006        OREQ      'Y'                                                      MD030956
188100200528     C     F3STYP        IFEQ      TIDLST                                                     CTI004
188200200528     C                   MOVE      'N'           @@CNRQ                                       CTI004
188300200528     C                   ENDIF                                                                CTI004
188400200528     C                   ENDIF                                                                CTI004
188500200528      *                                                                                       CTI004
188600200528     C                   ENDSR
188700200528     C****************************************************************
188800200528      /EJECT
188900200528     C****************************************************************
189000200528     C*                                                              *
189100200528     C* WRTDTX - WRITE A DTRIX RECORD                                *
189200200528     C*                                                              *
189300200528     C****************************************************************
189400200528     C     WRTDTX        BEGSR
189500200528      *
189600200528      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
189700200528      *
189800200528     C                   MOVE      'D'           DXRECI
189900200528     C                   MOVE      'D'           DXRCDT
190000200528     C                   Z-ADD     F3DN38        DXDLNO
190100200528     C                   Z-ADD     *ZERO         DXVDAT
190200200528     C                   Z-ADD     *ZERO         DXDASN
190300200528     C                   MOVE      F3CHTP        DXCHTP
190400200528     C                   MOVE      @@CNRQ        DXCNRQ
190500200528     C                   MOVE      'N'           DXCNPR
190600200528     C                   MOVE      ' '           DXREPR
190700200528     C                   TIME                    @XTIME
190800200528     C                   MOVE      @@PRI1        DXPRI1
190900200528     C                   MOVE      @@PRI2        DXPRI2
191000200528     C                   MOVE      @@PRI3        DXPRI3
191100200528     C                   Z-ADD     0             DXICIN
191200200528     C                   MOVEL     F3DBRC        DXBRCA
191300200528     C                   Z-ADD     *ZERO         DXTNLU
191400200528     C*
191500200528     C                   WRITE     DTRIXDF
191600200528      *
191700200528     C                   ENDSR
191800200528     C****************************************************************
191900200528      /EJECT                                                                                 BUG6479
192000200528     C****************************************************************                       BUG6479
192100200528     C*                                                              *                       BUG6479
192200200528     C* OP_WRTDTX - Write a DTRIX Record for OP Deals                *                       BUG6479
192300200528     C*                                                              *                       BUG6479
192400200528     C****************************************************************                       BUG6479
192500200528     C     OP_WRTDTX     BEGSR                                                               BUG6479
192600200528      *                                                                                      BUG6479
192700200528      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD                                      BUG6479
192800200528      *                                                                                      BUG6479
192900200528     C                   MOVE      'D'           DXRECI                                      BUG6479
193000200528     C                   MOVE      'D'           DXRCDT                                      BUG6479
193100200528     C                   Z-ADD     DLNO          DXDLNO                                      BUG6479
193200200528     C                   Z-ADD     *ZERO         DXVDAT                                      BUG6479
193300200528     C                   Z-ADD     *ZERO         DXDASN                                      BUG6479
193400200528     C                   MOVE      'A'           DXCHTP                                      BUG6479
193500200528     C                   MOVE      'N'           DXCNRQ                                      BUG6479
193600200528     C                   MOVE      'N'           DXCNPR                                      BUG6479
193700200528     C                   MOVE      ' '           DXREPR                                      BUG6479
193800200528     C                   TIME                    @XTIME                                      BUG6479
193900200528     C                   MOVE      '0'           DXPRI1                                      BUG6479
194000200528     C                   MOVE      '0'           DXPRI2                                      BUG6479
194100200528     C                   MOVE      '0'           DXPRI3                                      BUG6479
194200200528     C                   TESTB     '0'           TLXI                     99                 BUG6479
194300200528     C                   IF        *IN99 = '1'                                               BUG6479
194400200528     C                   MOVE      '1'           DXPRI1                                      BUG6479
194500200528     C                   ENDIF                                                               BUG6479
194600200528     C                   TESTB     '1'           TLXI                     99                 BUG6479
194700200528     C                   IF        *IN99 = '1'                                               BUG6479
194800200528     C                   MOVE      '1'           DXPRI3                                      BUG6479
194900200528     C                   ENDIF                                                               BUG6479
195000200528     C                   Z-ADD     0             DXICIN                                      BUG6479
195100200528     C                   MOVEL     F3DBRC        DXBRCA                                      BUG6479
195200200528     C                   Z-ADD     *ZERO         DXTNLU                                      BUG6479
195300200528     C*                                                                                      BUG6479
195400200528     C                   WRITE     DTRIXDF                                                   BUG6479
195500200528      *                                                                                      BUG6479
195600200528     C                   ENDSR                                                               BUG6479
195700200528     C****************************************************************                       BUG6479
195800200528      /EJECT
195900200528     C****************************************************************
196000200528     C*                                                              *
196100200528     C* SOL_WRTDTX - WRITE A DTRIX RECORD FOR SWAP OTHER LEG REVERSED*
196200200528     C*                                                              *
196300200528     C****************************************************************
196400200528     C     SOL_WRTDTX    BEGSR
196500200528      *
196600200528      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
196700200528      *
196800200528     C                   MOVE      'D'           DXRECI
196900200528     C                   MOVE      'D'           DXRCDT
197000200528     C                   MOVE      F3DADN        DXDLNO
197100200528     C                   Z-ADD     *ZERO         DXVDAT
197200200528     C                   Z-ADD     *ZERO         DXDASN
197300200528     C                   MOVE      F3CHTP        DXCHTP
197400200528     C                   MOVE      'Y'           DXCNRQ
197500200528     C     CTI004        IFEQ      'Y'                                                        CTI004
197600200528     C     BGN3ST        ANDEQ     'Y'                                                        CTI004
197700200528     C     CTI006        OREQ      'Y'                                                      MD030956
197800200528     C     F3STYP        IFEQ      TIDLST                                                     CTI004
197900200528     C                   MOVE      'N'           DXCNRQ                                       CTI004
198000200528     C                   ENDIF                                                                CTI004
198100200528     C                   ENDIF                                                                CTI004
198200200528     C                   MOVE      'N'           DXCNPR
198300200528     C                   MOVE      ' '           DXREPR
198400200528     C                   TIME                    @XTIME
198500200528     C                   MOVE      @@PRI1        DXPRI1
198600200528     C                   MOVE      @@PRI2        DXPRI2
198700200528     C                   MOVE      @@PRI3        DXPRI3
198800200528     C                   Z-ADD     0             DXICIN
198900200528     C                   MOVEL     F3DBRC        DXBRCA
199000200528     C                   Z-ADD     *ZERO         DXTNLU
199100200528     C*
199200200528     C                   WRITE     DTRIXDF
199300200528      *
199400200528     C                   ENDSR
199500200528     C****************************************************************
199600200528      /EJECT
199700200528     C****************************************************************
199800200528     C*                                                              *
199900200528     C* UPDDTH - UPDATE THE DTRIX HEADER RECORD                      *
200000200528     C*                                                              *
200100200528     C****************************************************************
200200200528     C     UPDDTH        BEGSR
200300200528      *
200400200528      ** Access the header record
200500200528      *
200600200528     C                   Z-ADD     *ZERO         DXDLNO
200700200528     C*****DXDLNO        CHAIN     DTRIXHF                            99                      231306
200800200528     C     DXDLNO        CHAIN     DTRIXHF                            9998                    231306
200900200528      *                                                                                       231306
201000200528     C     *IN98         IFEQ      *ON                                                        231306
201100200528     C                   EXSR      SRERR                                                      231306
201200200528     C                   ENDIF                                                                231306
201300200528      *
201400200528      ** DATABASE ERROR
201500200528      *
201600200528     C     *IN99         IFEQ      '1'
201700200528     C                   MOVEL     DXDLNO        DBKEY
201800200528     C                   MOVEL     'DTRIXHF '    DBFILE
201900200528     C                   MOVEL     '003'         DBASE
202000200528     C                   EXSR      SRERR
202100200528     C                   END
202200200528      *
202300200528      * Add 1 to number of deal records (on DTRIXDD)
202400200528      *
202500200528     C     ##DEAL_MIS    IFNE      'Y'
202600200528     C                   ADD       1             DXNDLR
202700200528     C                   END
202800200528     C     ##SOL_VDAT    IFNE      *ZERO
202900200528     C                   ADD       1             DXNDLR
203000200528     C                   END
203100200528      *
203200200528     C                   UPDATE    DTRIXHF
203300200528     C*
203400200528     C                   ENDSR
203500200528     C****************************************************************
203600200528      /EJECT
203700200528     C****************************************************************
203800200528     C*                                                              *
203900200528     C* UPDTRL- UPDATE THE DEALS FILE TRAILER                        *
204000200528     C*                                                              *
204100200528     C****************************************************************
204200200528     C     UPDTRL        BEGSR
204300200528      *
204400200528     C                   MOVE      *BLANKS       EAPIC            10                        MD025244
204500200528      *                                                                                     MD025244
204600200528     C                   CALLB     'ZADLTRLRUD'
204700200528      *
204800200528      ** Return Code
204900200528     C                   PARM      *BLANKS       @@RTCD            7
205000200528      *
205100200528      ** Change Type
205200200528     C                   PARM      F3CHTP        @@CHTP            1
205300200528      *
205400200528      ** Amount
205500200528     C                   PARM                    @@AMNP           15 0
205600200528      *
205700200528      ** Run Date
205800200528     C                   PARM                    BJRDNB            5 0
205900200528     C                   PARM                    EAPIC                                      MD025244
206000200528      *
206100200528      ** DATABASE ERROR
206200200528      *
206300200528     C     @@RTCD        IFEQ      '*ERROR '
206400200528     C                   MOVEL     '999999'      DBKEY
206500200528     C                   MOVEL     'DEALSDF '    DBFILE
206600200528     C                   MOVEL     '004'         DBASE
206700200528     C                   EXSR      SRERR
206800200528     C                   END
206900200528      *
207000200528     C                   ENDSR
207100200528     C****************************************************************
207200200528      /EJECT
207300200528     C****************************************************************
207400200528     C*                                                              *
207500200528     C* TLXDUE - DETERMINE TELEX DUE DATE                            *
207600200528     C*                                                              *
207700200528     C****************************************************************
207800200528     C     TLXDUE        BEGSR
207900200528      *
208000200528     C/COPY WNCPYSRC,FXH00001
208100200528     C                   CALLB     'ZATLXDUEDT'
208200200528      *
208300200528      ** Deal or local Currency
208400200528     C                   PARM                    @DLOLC            1
208500200528      *
208600200528      ** Currency
208700200528     C                   PARM                    @CCY              3
208800200528      *
208900200528      ** Nostro
209000200528     C                   PARM                    @NOSTR            2
209100200528      *
209200200528      ** Date of Next Working Day
209300200528     C                   PARM                    BJDNWD            5 0
209400200528      *
209500200528      ** Local Currency
209600200528     C                   PARM                    BJLCCY            3
209700200528      *
209800200528      ** System Location
209900200528     C                   PARM                    BJSLCD            3
210000200528      *
210100200528      ** Telex Due Date
210200200528     C                   PARM      *ZERO         @TLXDU            5 0
210300200528     C/COPY WNCPYSRC,FXH00002
210400200528     C                   ENDSR
210500200528     C****************************************************************
210600200528      /EJECT
210700200528     C****************************************************************
210800200528     C*                                                              *
210900200528     C* ACSPCY - ACCESS PURCHASE CURRENCY DETAILS                    *
211000200528     C*                                                              *
211100200528     C****************************************************************
211200200528     C     ACSPCY        BEGSR
211300200528      *
211400200528      ** Access currency details using deal currency.
211500200528      *
211600200528     C                   CALLB     'AOCURRR0'
211700200528     C                   PARM      '*MSG   '     @RTCD             7
211800200528     C                   PARM      '*KEY   '     @OPTN             7
211900200528     C                   PARM      F3CCY1        @AJCD             3
212000200528     C     SDCURR        PARM      SDCURR        DSSDY
212100200528      *
212200200528      ** DATABASE ERROR
212300200528      *
212400200528     C     @RTCD         IFNE      *BLANK
212500200528     C                   MOVEL     @AJCD         DBKEY
212600200528     C                   MOVEL     'SDCURRPD'    DBFILE
212700200528     C                   MOVEL     '005'         DBASE
212800200528     C                   EXSR      SRERR
212900200528     C                   END
213000200528     C                   ENDSR
213100200528      *****************************************************************                       CRE020
213200200528      /EJECT                                                                                  CRE020
213300200528      *****************************************************************                       CRE020
213400200528      *                                                               *                       CRE020
213500200528      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
213600200528      *             current transaction.                              *                       CRE020
213700200528      *                                                               *                       CRE020
213800200528      *****************************************************************                       CRE020
213900200528     C     SRIdxTrn      BEGSR                                                                CRE020
214000200528                                                                                              CRE020
214100200528      ** Initialise key values.                                                               CRE020
214200200528                                                                                              CRE020
214300200528     C                   MOVE      *BLANKS       KRefNo                                       CRE020
214400200528     C                   MOVEL     DLNO          KRefNo                                       CRE020
214500200528                                                                                              CRE020
214600200528      ** Begin advice index processing.                                                       CRE020
214700200528                                                                                              CRE020
214800200528     C                   MOVE      *BLANK        WNew                                         CRE020
214900200528                                                                                              CRE020
215000200528     C                   OPEN      READVCL1                                                   CRE020
215100200528                                                                                              CRE020
215200200528     C     KADVC         SETLL     READVCL1                                                   CRE020
215300200528     C     KADVC         READE     READVCL1                                                   CRE020
215400200528                                                                                              CRE020
215500200528     C                   DOW       NOT %EOF                                                   CRE020
215600200528                                                                                              CRE020
215700200528      ** Check first if this is a new advice index.                                           CRE020
215800200528                                                                                              CRE020
215900200528     C                   IF        WNew = *BLANK                                              CRE020
216000200528     C                   IF        RCHTYP = 'I' AND                                           CRE020
216100200528     C                             RSAPIN = 'N'                                               CRE020
216200200528     C                   MOVE      'Y'           WNew                                         CRE020
216300200528     C                   ELSE                                                                 CRE020
216400200528     C                   MOVE      'N'           WNew                                         CRE020
216500200528     C                   ENDIF                                                                CRE020
216600200528     C                   ENDIF                                                                CRE020
216700200528                                                                                              CRE020
216800200528      ** Set default values if the advice indicator is equal to blank.                        CRE020
216900200528                                                                                              CRE020
217000200528     C                   IF        RSAPIN = ' '                                               CRE020
217100200528                                                                                              CRE020
217200200528      ** Change type is always 'I' for newly inserted records.                                CRE020
217300200528                                                                                              CRE020
217400200528     C                   MOVE      'I'           RCHTYP                                       CRE020
217500200528     C                   MOVE      'N'           RSAPIN                                       CRE020
217600200528     C                   MOVE      'Y'           RAUTHI                                       CRE020
217700200528                                                                                              CRE020
217800200528     C                   ELSE                                                                 CRE020
217900200528                                                                                              CRE020
218000200528      ** Execute reversal processing if necessary.                                            CRE020
218100200528                                                                                              CRE020
218200200528     C                   IF        CHTP = 'R'                                                 CRE020
218300200528                                                                                              CRE020
218400200528      ** Delete the advice index if the current record is a new FX                            CRE020
218500200528      ** deal. Reverse it otherwise.                                                          CRE020
218600200528                                                                                              CRE020
218700200528     C                   MOVE      'R'           RCHTYP                                       CRE020
218800200528                                                                                              CRE020
218900200528     C                   IF        RAUTHI = 'N'                                               CRE020
219000200528     C                   MOVE      'Y'           RAUTHI                                       CRE020
219100200528                                                                                              CRE020
219200200528     C                   IF        WNew = 'Y'                                                 CRE020
219300200528     C                   MOVE      'Y'           RSAPIN                                       CRE020
219400200528     C                   ELSE                                                                 CRE020
219500200528     C                   MOVE      'N'           RSAPIN                                       CRE020
219600200528     C                   ENDIF                                                                CRE020
219700200528     C                   ENDIF                                                                CRE020
219800200528                                                                                              CRE020
219900200528     C                   ELSE                                                                 CRE020
220000200528                                                                                              CRE020
220100200528      ** Execute amend processing.                                                            CRE020
220200200528                                                                                              CRE020
220300200528     C                   IF        WNew = 'Y'                                                 CRE020
220400200528     C                   MOVE      'I'           RCHTYP                                       CRE020
220500200528                                                                                              CRE020
220600200528      ** Change field values only if the authorise indicator is equal to 'N'.                 CRE020
220700200528                                                                                              CRE020
220800200528     C                   IF        RAUTHI = 'N'                                               CRE020
220900200528     C                   EVAL      RAUTHI = 'Y'                                               CRE020
221000200528     C                   EVAL      RSAPIN = 'N'                                               CRE020
221100200528     C                   ENDIF                                                                CRE020
221200200528                                                                                              CRE020
221300200528     C                   ELSE                                                                 CRE020
221400200528                                                                                              CRE020
221500200528     C                   IF        RAUTHI = 'N'                                               CRE020
221600200528     C                   MOVE      CHTP          RCHTYP                                       CRE020
221700200528     C                   MOVE      'Y'           RAUTHI                                       CRE020
221800200528     C                   MOVE      'N'           RSAPIN                                       CRE020
221900200528     C                   ENDIF                                                                CRE020
222000200528                                                                                              CRE020
222100200528     C                   ENDIF                                                                CRE020
222200200528                                                                                              CRE020
222300200528     C                   ENDIF                                                                CRE020
222400200528                                                                                              CRE020
222500200528     C                   ENDIF                                                                CRE020
222600200528                                                                                              CRE020
222700200528     C                   UPDATE    READVCD0                                                   CRE020
222800200528                                                                                              CRE020
222900200528     C     KADVC         READE     READVCL1                                                   CRE020
223000200528     C                   ENDDO                                                                CRE020
223100200528                                                                                              CRE020
223200200528     C                   CLOSE     READVCL1                                                   CRE020
223300200528                                                                                              CRE020
223400200528     C                   ENDSR                                                                CRE020
223500200528     C****************************************************************
223600200528      /EJECT
223700200528      *****************************************************************
223800200528      *                                                               *
223900200528      * *INZSR - Program Initialisation routine                       *
224000200528      *                                                               *
224100200528      * Called by: Main processing                                    *
224200200528      *                                                               *
224300200528      * Calls: None                                                   *
224400200528      *                                                               *
224500200528      *****************************************************************
224600200528     C     *INZSR        BEGSR
224700200528      *
224800200528      **  PROGRAM PARAMETERS
224900200528      *
225000200528     C     *ENTRY        PLIST
225100200528     C                   PARM                    @@RTCD            7
225200200528     C                   PARM                    FXVFXD
225300200528     C/COPY WNCPYSRC,FXH00248
225400200528      *
225500200528      ** ACCESS BANK DETAILS
225600200528      *
225700200528     C                   CALLB     'AOBANKR0'
225800200528     C                   PARM      '*MSG    '    @RTCD             7
225900200528     C                   PARM      '*FIRST  '    @OPTN             7
226000200528     C     SDBANK        PARM      SDBANK        DSFDY
226100200528      *
226200200528      * DATABASE ERROR
226300200528      *
226400200528     C     @RTCD         IFNE      *BLANK
226500200528     C                   MOVEL     @OPTN         DBKEY
226600200528     C                   MOVEL     'SDBANKPD'    DBFILE
226700200528     C                   MOVEL     '900'         DBASE
226800200528     C                   EXSR      SRERR
226900200528     C                   END
227000200528      *
227100200528      ** ACCESS TRADING DETAILS
227200200528      *
227300200528     C                   CALLB     'AOTRADR0'
227400200528     C                   PARM      '*MSG   '     @RTCD             7
227500200528     C                   PARM      '*FIRST '     @OPTN             7
227600200528     C     SDTRAD        PARM      SDTRAD        DSFDY
227700200528      *
227800200528      * DATABASE ERROR
227900200528      *
228000200528     C     @RTCD         IFNE      *BLANK
228100200528     C                   MOVEL     @OPTN         DBKEY
228200200528     C                   MOVEL     'SDTRADPD'    DBFILE
228300200528     C                   MOVEL     '901'         DBASE
228400200528     C                   EXSR      SRERR
228500200528     C                   END
228600200528      *                                                                                       CTI004
228700200528      ** Access External Modules Details                                                      CTI004
228800200528      *                                                                                       CTI004
228900200528     C                   CALL      'AOMMODR0'                                                 CTI004
229000200528     C                   PARM      *BLANKS       @RTCD                                        CTI004
229100200528     C                   PARM      '*FIRST '     @OPTN                                        CTI004
229200200528     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CTI004
229300200528      *                                                                                       CTI004
229400200528      ** Access TI ICD Details via access program                                             CTI004
229500200528      *                                                                                       CTI004
229600200528     C                   IF        BGN3ST = 'Y'                                               240480
229700200528     C                             OR CTI006 = 'Y'                                          MD030956
229800200528     C                   CALL      'AOTIINR0'                                                 CTI004
229900200528     C                   PARM      '*DBERR'      @RTCD                                        CTI004
230000200528     C                   PARM      '*FIRST'      @OPTN                                        CTI004
230100200528     C     SDTIIN        PARM      SDTIIN        DSFDY                                        CTI004
230200200528     C                   ENDIF                                                                240480
230300200528                                                                                              CTI004
230400200528      *                                                                         CDL008
230500200528      ** Access SAR details file to determine if CDL008 is on.                  CDL008
230600200528      ** (Continuous Linked Settlement)                                         CDL008
230700200528      *                                                                         CDL008
230800200528     C                   CALLB     'AOSARDR0'                                   CDL008
230900200528     C                   PARM      *BLANKS       @RTCD                          CDL008
231000200528     C                   PARM      '*VERIFY'     @OPTN                          CDL008
231100200528     C                   PARM      'CDL008'      @SARD                          CDL008
231200200528     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
231300200528     C     @RTCD         IFNE      *BLANKS                                      CDL008
231400200528     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
231500200528     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
231600200528     C                   MOVEL     '902'         DBASE                          CDL008
231700200528     C                   MOVEL     'CDL008'      DBKEY                          CDL008
231800200528     C                   EXSR      SRERR                                        CDL008
231900200528     C                   ENDIF                                                  CDL008
232000200528     C     @RTCD         IFEQ      *BLANKS                                      CDL008
232100200528     C                   MOVEL     'Y'           CDL008            1            CDL008
232200200528     C                   ELSE                                                   CDL008
232300200528     C                   MOVEL     'N'           CDL008                         CDL008
232400200528     C                   ENDIF                                                  CDL008
232500200528     C/COPY WNCPYSRC,FXH00004
232600200528                                                                                              CAS001
232700200528      ** Access SAR details file to determine if CAS001 is on.                                CAS001
232800200528      ** (Net Present Value Accounting)                                                       CAS001
232900200528                                                                                              CAS001
233000200528     C                   CALLB     'AOSARDR0'                                                 CAS001
233100200528     C                   PARM      *BLANKS       PRTCD                                        CAS001
233200200528     C                   PARM      '*VERIFY'     POPTN                                        CAS001
233300200528     C                   PARM      'CAS001'      PSARD                                        CAS001
233400200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
233500200528     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
233600200528     C                             PRTCD <> '*NRF   '                                         CAS001
233700200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
233800200528     C                   EVAL      DBASE = 903                                                CAS001
233900200528     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
234000200528     C                   EXSR      SRERR                                                      CAS001
234100200528     C                   ENDIF                                                                CAS001
234200200528     C                   IF        PRTCD = *BLANKS                                            CAS001
234300200528     C                   EVAL      CAS001 = 'Y'                                               CAS001
234400200528     C                   ELSE                                                                 CAS001
234500200528     C                   EVAL      CAS001 = 'N'                                               CAS001
234600200528     C                   ENDIF                                                                CAS001
234700200528                                                                                              CAS001
234800200528      ** Check if SWIFT 2012  is on                                                           CSW212
234900200528      *                                                                                       CSW212
235000200528     C                   CALL      'SWIF2012'                                                 CSW212
235100200528     C                   PARM      *BLANKS       PRTCD                                        CSW212
235200200528      *                                                                                       CSW212
235300200528     C     PRTCD         IFEQ      'CSW2012'                                                  CSW212
235400200528     C                   MOVEL     'Y'           CSW212            1                          CSW212
235500200528     C                   ELSE                                                                 CSW212
235600200528     C                   MOVEL     'N'           CSW212                                       CSW212
235700200528      *                                                                                       CSW212
235800200528     C                   ENDIF                                                                CSW212
235900200528     C/COPY WNCPYSRC,FXFXDLDC02
236000200528      *                                                                                       CTI004
236100200528      ** Access SAR details file to determine if CTI004 is on.                                CTI004
236200200528      ** MidasPlus-TI Integration Enhancements                                                CTI004
236300200528      *                                                                                       CTI004
236400200528     C                   CALLB     'AOSARDR0'                                                 CTI004
236500200528     C                   PARM      *BLANKS       PRTCD                                        CTI004
236600200528     C                   PARM      '*VERIFY'     POPTN                                        CTI004
236700200528     C                   PARM      'CTI004'      PSARD                                        CTI004
236800200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CTI004
236900200528      *                                                                                       CTI004
237000200528     C                   IF        PRTCD <> *BLANKS AND                                       CTI004
237100200528     C                             PRTCD <> '*NRF   '                                         CTI004
237200200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CTI004
237300200528     C                   EVAL      DBASE = 906                                                CTI004
237400200528     C                   EVAL      DBKEY = 'CTI004'                                           CTI004
237500200528     C                   EXSR      SRERR                                                      CTI004
237600200528     C                   ENDIF                                                                CTI004
237700200528     C                   IF        PRTCD = *BLANKS                                            CTI004
237800200528     C                   EVAL      CTI004 = 'Y'                                               CTI004
237900200528     C                   ELSE                                                                 CTI004
238000200528     C                   EVAL      CTI004 = 'N'                                               CTI004
238100200528     C                   ENDIF                                                                CTI004
238200200528                                                                                              CTI004
238300200528      ** Access SAR details file to determine if CSW025 is on.                               BUG6479
238400200528      ** (MMM is installed)                                                                  BUG6479
238500200528                                                                                             BUG6479
238600200528     C                   CALLB     'AOSARDR0'                                                BUG6479
238700200528     C                   PARM      *BLANKS       PRTCD                                       BUG6479
238800200528     C                   PARM      '*VERIFY'     POPTN                                       BUG6479
238900200528     C                   PARM      'CSW025'      PSARD                                       BUG6479
239000200528     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG6479
239100200528     C                   IF        PRTCD <> *BLANKS AND                                      BUG6479
239200200528     C                             PRTCD <> '*NRF   '                                        BUG6479
239300200528     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG6479
239400200528     C                   EVAL      DBASE = 907                                               BUG6479
239500200528     C                   EVAL      DBKEY = 'CSW025'                                          BUG6479
239600200528     C                   EXSR      SRERR                                                     BUG6479
239700200528     C                   ENDIF                                                               BUG6479
239800200528     C                   IF        PRTCD = *BLANKS                                           BUG6479
239900200528     C                   EVAL      CSW025 = 'Y'                                              BUG6479
240000200528     C                   ELSE                                                                BUG6479
240100200528     C                   EVAL      CSW025 = 'N'                                              BUG6479
240200200528     C                   ENDIF                                                               BUG6479
240300200528                                                                                             BUG6479
240400200528                                                                                              246801
240500200528      ** Access SAR details file to determine if CSW050 is on.                                246801
240600200528      ** (Multiple Payments mesasages)                                                        246801
240700200528                                                                                              246801
240800200528     C                   CALLB     'AOSARDR0'                                                 246801
240900200528     C                   PARM      *BLANKS       PRTCD                                        246801
241000200528     C                   PARM      '*VERIFY'     POPTN                                        246801
241100200528     C                   PARM      'CSW050'      PSARD                                        246801
241200200528     C     SCSARD        PARM      SCSARD        DSFDY                                        246801
241300200528     C                   IF        PRTCD <> *BLANKS AND                                       246801
241400200528     C                             PRTCD <> '*NRF   '                                         246801
241500200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        246801
241600200528     C                   EVAL      DBASE = 909                                                246801
241700200528     C                   EVAL      DBKEY = 'CSW050'                                           246801
241800200528     C                   EXSR      SRERR                                                      246801
241900200528     C                   ENDIF                                                                246801
242000200528     C                   IF        PRTCD = *BLANKS                                            246801
242100200528     C                   EVAL      CSW050 = 'Y'                                               246801
242200200528     C                   ELSE                                                                 246801
242300200528     C                   EVAL      CSW050 = 'N'                                               246801
242400200528     C                   ENDIF                                                                246801
242500200528                                                                                              246801
242600200528     C*
242700200528      ** Check if CRE020 is enabled.                                                          CRE020
242800200528      *                                                                                       CRE020
242900200528     C                   CALLB     'AOSARDR0'                                                 CRE020
243000200528     C                   PARM      *BLANKS       PRtCd                                        CRE020
243100200528     C                   PARM      '*VERIFY'     POptn                                        CRE020
243200200528     C                   PARM      'CRE020'      PSARD                                        CRE020
243300200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
243400200528                                                                                              CRE020
243500200528     C                   EVAL      CRE020 = 'N'                                               CRE020
243600200528                                                                                              CRE020
243700200528     C                   IF        PRtCd = *BLANKS                                            CRE020
243800200528     C                   EVAL      CRE020 = 'Y'                                               CRE020
243900200528     C                   ELSE                                                                 CRE020
244000200528                                                                                              CRE020
244100200528     C                   IF        PRtCd <> '*NRF'                                            CRE020
244200200528     C     *LOCK         IN        LDA                                                        CRE020
244300200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
244400200528     C                   EVAL      DBase = 904                                                CRE020
244500200528     C                   EVAL      DBKey = 'CRE020'                                           CRE020
244600200528     C                   OUT       LDA                                                        CRE020
244700200528     C                   EXSR      SRErr                                                      CRE020
244800200528     C                   ENDIF                                                                CRE020
244900200528                                                                                              CRE020
245000200528     C                   ENDIF                                                                CRE020
245100200528                                                                                              CRE020
245200200528      ** Check if a System Value exists for this maintenance.                                 CRE020
245300200528                                                                                              CRE020
245400200528     C                   IF        CRE020 = 'Y'                                               CRE020
245500200528                                                                                              CRE020
245600200528     C                   CALLB     'AOSVALR0'                                                 CRE020
245700200528     C                   PARM      *BLANKS       PRtCd                                        CRE020
245800200528     C                   PARM                    PSysVal01                                    CRE020
245900200528     C                   PARM                    PCurSet01                                    CRE020
246000200528     C                   PARM                    PSysVal02                                    CRE020
246100200528     C                   PARM                    PCurSet02                                    CRE020
246200200528     C                   PARM                    PSysVal03                                    CRE020
246300200528     C                   PARM                    PCurSet03                                    CRE020
246400200528     C                   PARM                    PSysVal04                                    CRE020
246500200528     C                   PARM                    PCurSet04                                    CRE020
246600200528     C                   PARM                    PSysVal05                                    CRE020
246700200528     C                   PARM                    PCurSet05                                    CRE020
246800200528     C                   PARM                    PSysVal06                                    CRE020
246900200528     C                   PARM                    PCurSet06                                    CRE020
247000200528     C                   PARM                    PSysVal07                                    CRE020
247100200528     C                   PARM                    PCurSet07                                    CRE020
247200200528     C                   PARM                    PSysVal08                                    CRE020
247300200528     C                   PARM                    PCurSet08                                    CRE020
247400200528     C                   PARM                    PSysVal09                                    CRE020
247500200528     C                   PARM                    PCurSet09                                    CRE020
247600200528     C                   PARM                    PSysVal10                                    CRE020
247700200528     C                   PARM                    PCurSet10                                    CRE020
247800200528                                                                                              CRE020
247900200528     C                   EVAL      WSysVal01 = 'N'                                            CRE020
248000200528                                                                                              CRE020
248100200528     C                   IF        PRtCd = *BLANKS                                            CRE020
248200200528     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
248300200528     C                   ELSE                                                                 CRE020
248400200528                                                                                              CRE020
248500200528     C                   IF        PRtCd <> '*NRF'                                            CRE020
248600200528     C     *LOCK         IN        LDA                                                        CRE020
248700200528     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
248800200528     C                   EVAL      DBase = 905                                                CRE020
248900200528     C                   EVAL      DBKey = PSysVal01                                          CRE020
249000200528     C                   OUT       LDA                                                        CRE020
249100200528     C                   EXSR      SRErr                                                      CRE020
249200200528     C                   ENDIF                                                                CRE020
249300200528                                                                                              CRE020
249400200528     C                   ENDIF                                                                CRE020
249500200528                                                                                              CRE020
249600200528     C                   ENDIF                                                                CRE020
249700200528                                                                                              CRE020
249800200528      ** Midas RE Settled Transaction Index File Key List                                     CRE020
249900200528                                                                                              CRE020
250000200528     C     KADVC         KLIST                                                                CRE020
250100200528     C                   KFLD                    KRefNo                                       CRE020
250200200528     C                   KFLD                    KPrgMn                                       CRE020
250300200528      *                                                                                       CER043
250400200528      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
250500200528      *                                                                                       CER043
250600200528     C                   EVAL      CER043 = 'N'                                               CER043
250700200528     C                   CALLB     'AOSARDR0'                                                 CER043
250800200528     C                   PARM      *BLANKS       PRTCD                                        CER043
250900200528     C                   PARM      '*VERIFY'     POPTN                                        CER043
251000200528     C                   PARM      'CER043'      PSARD                                        CER043
251100200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
251200200528                                                                                              CER043
251300200528     C                   IF        PRTCD <> *BLANKS AND                                       CER043
251400200528     C                             PRTCD <> '*NRF   '                                         CER043
251500200528     C     *LOCK         IN        LDA                                                        CER043
251600200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
251700200528     C                   EVAL      DBASE = 910                                                CER043
251800200528     C                   EVAL      DBKEY = 'CER043'                                           CER043
251900200528     C                   OUT       LDA                                                        CER043
252000200528     C                   EXSR      SRERR                                                      CER043
252100200528     C                   ENDIF                                                                CER043
252200200528                                                                                              CER043
252300200528     C                   IF        PRTCD = *BLANKS                                            CER043
252400200528     C                   EVAL      CER043 = 'Y'                                               CER043
252500200528     C                   ENDIF                                                                CER043
252600200528                                                                                              CRE020
252700200528      ** Check if CTI006 is enabled.                                                        MD030956
252800200528      *                                                                                     MD030956
252900200528     C                   CALLB     'AOSARDR0'                                               MD030956
253000200528     C                   PARM      *BLANKS       PRtCd                                      MD030956
253100200528     C                   PARM      '*VERIFY'     POptn                                      MD030956
253200200528     C                   PARM      'CTI006'      PSARD                                      MD030956
253300200528     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030956
253400200528                                                                                            MD030956
253500200528     C                   EVAL      CTI006 = 'N'                                             MD030956
253600200528                                                                                            MD030956
253700200528     C                   IF        PRtCd = *BLANKS                                          MD030956
253800200528     C                   EVAL      CTI006 = 'Y'                                             MD030956
253900200528     C                   ELSE                                                               MD030956
254000200528                                                                                            MD030956
254100200528     C                   IF        PRtCd <> '*NRF'                                          MD030956
254200200528     C     *LOCK         IN        LDA                                                      MD030956
254300200528     C                   EVAL      DBFile = 'SCSARDPD'                                      MD030956
254400200528     C                   EVAL      DBase = 911                                              MD030956
254500200528     C                   EVAL      DBKey = 'CTI006'                                         MD030956
254600200528     C                   OUT       LDA                                                      MD030956
254700200528     C                   EXSR      SRErr                                                    MD030956
254800200528     C                   ENDIF                                                              MD030956
254900200528     C                   ENDIF                                                              MD030956
255000200528      *                                                                                       CDL099
255100200528      ** Check if CDL099 is enabled.                                                          CDL099
255200200528      *                                                                                       CDL099
255300200528     C                   CALLB     'AOSARDR0'                                                 CDL099
255400200528     C                   PARM      *BLANKS       PRtCd                                        CDL099
255500200528     C                   PARM      '*VERIFY'     POptn                                        CDL099
255600200528     C                   PARM      'CDL099'      PSARD                                        CDL099
255700200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL099
255800200528                                                                                              CDL099
255900200528     C                   EVAL      CDL099 = 'N'                                               CDL099
256000200528                                                                                              CDL099
256100200528     C                   IF        PRtCd = *BLANKS                                            CDL099
256200200528     C                   EVAL      CDL099 = 'Y'                                               CDL099
256300200528     C                   ELSE                                                                 CDL099
256400200528                                                                                              CDL099
256500200528     C                   IF        PRtCd <> '*NRF'                                            CDL099
256600200528     C     *LOCK         IN        LDA                                                        CDL099
256700200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CDL099
256800200528     C                   EVAL      DBase = 912                                                CDL099
256900200528     C                   EVAL      DBKey = 'CDL099'                                           CDL099
257000200528     C                   OUT       LDA                                                        CDL099
257100200528     C                   EXSR      SRErr                                                      CDL099
257200200528     C                   ENDIF                                                                CDL099
257300200528     C                   ENDIF                                                                CDL099
257400200528                                                                                              CDL099
257500200528     C                   ENDSR
257600200528     C****************************************************************
257700200528      /EJECT
257800200528     C****************************************************************
257900200528     C*                                                              *
258000200528     C* SRERR - EXCEPTION ERRORS                                     *
258100200528     C*                                                              *
258200200528     C****************************************************************
258300200528     C     SRERR         BEGSR
258400200528     C*
258500200528     C     *IN98         IFEQ      *ON                                                        231306
258600200528     C                   MOVEL     '*RECLCK'     @@RTCD                                       231306
258700200528     C                   SETON                                        LR                      231306
258800200528     C                   ELSE                                                                 231306
258900200528     C                   MOVEL     '*ERROR '     @@RTCD
259000200528     C                   MOVEL     'FXFXDLUPD'   DBPGM
259100200528     C                   MOVE      '1'           *INU7
259200200528     C                   MOVE      '1'           *INU8
259300200528     C                   MOVE      '1'           *INLR
259400200528     C                   DUMP
259500200528     C                   ENDIF                                                                231306
259600200528     C*
259700200528     C**  TERMINATE THE PROGRAM
259800200528     C*
259900200528     C                   RETURN
260000200528     C*
260100200528     C                   ENDSR
260200200528     C****************************************************************
260300200528**  CPY@
260400200528(c) Finastra International Limited 2001
