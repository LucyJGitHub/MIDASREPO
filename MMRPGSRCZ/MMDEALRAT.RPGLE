000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas MM Deal range authorization')                    *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Money Market Dealing Module                          *
000900200528      *                                                               *
001000200528      *  MMDEALRAT - MM DEAL RANGE AUTHORIZATION                      *
001100200528      *                                                               *
001200200528      *  Function:  This input function allows range authorization    *
001300200528      *             of all MM transactions.                           *
001400200528      *                                                               *
001500200528      *  (c) Finastra International Limited 2001                      *
001600200528      *                                                               *
001700200604      *  Last Amend No. 260173             Date 22May20               *
001800200528      *  Prev Amend No. CER050             Date 16Jun19               *
001900200528      *                 MD046248           Date 27Oct17               *
002000200528      *                 AR701789           Date 26Sep16               *
002100200528      *                 CGL165             Date 17Feb15               *
002200200528      *                 CDL096             Date 22Sep14               *
002300200528      *                 CDL094             Date 11Jun14               *
002400200528      *                 CLE134             Date 01Aug12               *
002500200528      *                 CRE073             Date 06Dec10               *
002600200528      *                 CER059             Date 19Jul10               *
002700200528      *                 CER020             Date 19May08               *
002800200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
002900200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
003000200528      * Midas Plus 1.4 Base ------------------------------------------*
003100200528      * Midas Plus 1.3 ----------- Base ------------------------------*
003200200528      *                 CDL049             Date 11Jul06               *
003300200528      *                 CSD027             Date 09Dec05               *
003400200528      *                 CDL038             Date 10May05               *
003500200528      *                 CDL033             Date 10Feb05               *
003600200528      *                 BUG7222            Date 10Feb05               *
003700200528      *                 CMM105             Date 22Jun04               *
003800200528      *                 CGL014             Date 20Oct03               *
003900200528      *                 BUG2804            Date 20May04               *
004000200528      *                 CDL022             Date 03Feb04               *
004100200528      *                 CDL020             Date 03Feb04               *
004200200528      *                 CDL019             Date 03Feb04               *
004300200528      *                 CDL018             Date 03Feb04               *
004400200528      *                 CDL017             Date 03Feb04               *
004500200528      *                 CDL016             Date 03Feb04               *
004600200528      *                 BUG2132            Date 07May04               *
004700200528      *                 CGL029             Date 01Sep03               *
004800200528      *                 222727             Date 05Nov03               *
004900200528      *                 CAS005             Date 16Dec02               *
005000200528      *                 CAS004             Date 26Jun02               *
005100200528      * Midas Release 4.01.02 ----------------------------------------*
005200200528      *                 196380             Date 15May02               *
005300200528      * Midas Release 4.01 -------------------------------------------*
005400200528      *                 CAS001             Date 23Nov01               *
005500200528      *                 CAP067             Date 24Sep01               *
005600200528      * Midas Release 4 --------------- Base -------------------------*
005700200528      * Midas DBA 3.02 -----------------------------------------------*
005800200528      *                 CAP052             Date 25Nov99               *
005900200528      *                 CAP051             Date 12Nov99               *
006000200528      *                 CDL007             Date 12Oct99               *
006100200528      *                 CPB001             Date 01Jun99               *
006200200528      * Midas DBA 3.01 -----------------------------------------------*
006300200528      *                 CDL006             Date 26Apr99               *
006400200528      * Midas DBA 3.00 ---------------- Base -------------------------*
006500200528      *                 CAP003             Date 05May98               *
006600200528      *                 CAP002  *CREATE    Date 01May98               *
006700200528      *                                                               *
006800200528      *---------------------------------------------------------------*
006900200528      *                                                               *
007000200528      *  260173 - Synchronize parameter in MMDEAMRTV to avoid         *
007100200528      *           parameter mismatch. Apply fix 258724.               *
007200200528      *  CER050 - Annualised Percentage Rate (Recompile)              *
007300200528      *  MD046248 - Finastra Rebranding                               *
007400200528      *  AR701789 - Unable to reject a deal amendment. Add a new      *
007500200528      *             parameter to indicate reject transaction.         *
007600200528      *             Applied for MD041482                              *
007700200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
007800200528      *  CDL096 - Business Day Conventions on MM Deals                *
007900200528      *           (Recompile)                                         *
008000200528      *  CDL094 - Enhance  Receive Settlement Instructions            *
008100200528      *           (Recompiled)                                        *
008200200528      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
008300200528      *  CRE073 - Interest Rate Rounding (Recompile)                  *
008400200528      *  CER059 - German Feature Upgrade to Delhi                     *
008500200528      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
008600200528      *           Midas Plus (Recompile)                              *
008700200528      *  CDL049 - Addition of a Reference Rate field (recompile)      *
008800200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
008900200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
009000200528      *  CDL033 - Floating Rate CDs Issued                            *
009100200528      *  BUG7222- Incomplete parameter list passed to MMLDNIUPM.      *
009200200528      *  CMM105 - Core changes for GBO005                             *
009300200528      *         - Fixed Deposits Held Under Lien                      *
009400200528      *         - Upgrade to Midasplus                                *
009500200528      *           Core hooks amended:MMDEALGD02,MMDEALGC07,MMDEALGC03 *
009600200528      *  CGL014 - Collaterals Processing (Recompile)                  *
009700200528      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
009800200528      *  CDL022 - Deal Amendment Changes (Recompile)                  *
009900200528      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
010000200528      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
010100200528      *           (Recompile)                                         *
010200200528      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
010300200528      *           (Recompile)                                         *
010400200528      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
010500200528      *           (Recompile)                                         *
010600200528      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
010700200528      *           (Recompile)                                         *
010800200528      *  BUG2132- Midasplus webfacing  changes. Recompile due to      *
010900200528      *           changes in MMDEALRDF.                               *
011000200528      *  CGL029 - Increase Account Code to 10 digits                  *
011100200528      *  222727 - Release 5.0 errors  (Recompile)                     *
011200200528      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
011300200528      *           (Recompile)                                         *
011400200528      *  CAS004 - Hedge Accounting Phase A                            *
011500200528      *  196380 - Added parameter to MMLDNIRTV call.                  *
011600200528      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
011700200528      *  CAP067 - Repurchase Agreements API.                          *
011800200528      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
011900200528      *  CAP051 - Automatic Authorisation (MM Part)                   *
012000200528      *           Recompiled due to changes in MMDELDPP               *
012100200528      *  CDL007 - Deposit Breakdown Penalty                           *
012200200528      *           Recompiled due to changes in MMDELDPP               *
012300200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
012400200528      *           Recompiled due to changes in MMDELDPP               *
012500200528      *  CDL006 - Dealing Fiduciary.                                  *
012600200528      *  CAP003 - Conversion of SE inputs into modular structure to   *
012700200528      *           use as APIs. (RECOMPILED)                           *
012800200528      *  CAP002 - Conversion of MM inputs into modular structure to   *
012900200528      *           use as APIs.                                        *
013000200528      *                                                               *
013100200528      *****************************************************************
013200200528
013300200528     FMMDEALRDF CF   E             WORKSTN INFSR(*PSSR)
013400200528     F/COPY WNCPYSRC,MMDEALGF01
013500200528
013600200528      *****************************************************************
013700200528      ** +--------------------------------------+
013800200528      ** ¦ Automatically included D-specs       ¦
013900200528      ** ¦ ==============================       ¦
014000200528      ** +--------------------------------------+
014100200528      **
014200200528      ** Standard D-specs
014300200528      ** ================
014400200528      **
014500200528      ** The following /COPY line includes the LDA layout,
014600200528      ** the copyright array definition,
014700200528      ** and the following named constants:
014800200528      **    True       logical = *on (for indcator processing)
014900200528      **    False      logical = *off (for indcator processing)
015000200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
015100200528      **                                    handler)
015200200528      ** and the following variables:
015300200528      **    RunBefore  1A (for the PSSR)
015400200528
015500200528     D/COPY ZACPYSRC,STD_D_SPEC
015600200528
015700200528      ** Include the MM standard declares
015800200528     D/COPY ZACPYSRC,STDDECLARE
015900200528
016000200528      ** Program Status Data Structure
016100200528      ** =============================
016200200528      ** The following /COPY line includes all the defined fields in the
016300200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
016400200528
016500200528     D/COPY ZACPYSRC,PSDS
016600200528
016700200528      ** +--------------------------------------+
016800200528      ** ¦ End of automatically included D-specs¦
016900200528      ** ¦ =====================================¦
017000200528      ** +--------------------------------------+
017100200528
017200200528      *****************************************************************
017300200528      /EJECT
017400200528      *****************************************************************
017500200528
017600200528      ** +--------------------------------------+
017700200528      ** ¦ Manually included D-specs            ¦
017800200528      ** ¦ =========================            ¦
017900200528      ** +--------------------------------------+
018000200528
018100200528      ** +--------------------------------------+
018200200528      ** ¦ Named constants                      ¦
018300200528      ** ¦ ===============                      ¦
018400200528      ** +--------------------------------------+
018500200528
018600200528      ** The maximum size of the error arrays
018700200528     D ArrayMax        C                   CONST(75)
018800200528
018900200528      ** +--------------------------------------+
019000200528      ** ¦ Arrays and Data Structures           ¦
019100200528      ** ¦ ==========================           ¦
019200200528      ** +--------------------------------------+
019300200528
019400200528      ** data structure for data to output 'authorized' message
019500200528     D @ADAT           DS            45
019600200528     D  @ADAT1                 1      6
019700200528     D  @ADAT2                 7     12
019800200528     D  @ADAT3                13     18
019900200528
020000200528      ** data structure for data to output 'failed' message
020100200528     D @FDTA           DS            45
020200200528     D  @FDT1                  1      6
020300200528     D  @FDT2                  7     12
020400200528     D  @FDT3                 13     18
020500200528     D  @FDT4                 19     24
020600200528
020700200528
020800200528      ** Array of Fields in error.
020900200528     D FldNameArr      S             10A   DIM(ArrayMax)
021000200528
021100200528      ** Array of error message IDs
021200200528     D MsgIDArr        S                   DIM(ArrayMax) LIKE(#MsgID)
021300200528
021400200528      ** Array of error message data.
021500200528     D MsgDtaArr       S                   DIM(ArrayMax) LIKE(#MsgData)
021600200528
021700200528      ** Array for Warning messages                                                           CAS004
021800200528     D WFldNamArr      S             10A   DIM(ArrayMax)                                      CAS004
021900200528     D WMsgIDArr       S                   DIM(ArrayMax) LIKE(#MsgID)                         CAS004
022000200528     D WMsgDtaArr      S                   DIM(ArrayMax) LIKE(#MsgData)                       CAS004
022100200528
022200200528     D DELDFilFmt    E DS                  EXTNAME(MMDELDPP)
022300200528     D DSFRCD                       100    OVERLAY(DELDFilFmt:1850)                           CDL033
022400200528     D DENBFilFmt    E DS                  EXTNAME(MMDENBPP)
022500200528     D DENSFilFmt    E DS                  EXTNAME(MMDENSPP)
022600200528     D DORIQQ1       E                     EXTFLD(DORIQQ)                                     CGL029
022700200528     D MORIQQ1       E                     EXTFLD(MORIQQ)                                     CGL029
022800200528     D RONSQQ1       E                     EXTFLD(RONSQQ)                                     CGL029
022900200528     D PONSQQ1       E                     EXTFLD(PONSQQ)                                     CGL029
023000200528     D DEAMFilFmt    E DS                  EXTNAME(MMDEAMPP)
023100200528     D DORIQQ2       E                     EXTFLD(QQDORI)                                     CGL029
023200200528     D MORIQQ2       E                     EXTFLD(QQMORI)                                     CGL029
023300200528     D DOPIQQ2       E                     EXTFLD(QQDOPI)                                     CGL029
023400200528     D MOPIQQ2       E                     EXTFLD(QQMOPI)                                     CGL029
023500200528     D RONSQQ2       E                     EXTFLD(QQRONS)                                     CGL029
023600200528     D PONSQQ2       E                     EXTFLD(QQPONS)                                     CGL029
023700200528
023800200528
023900200528     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
024000200528      ** EXTERNAL DS FOR DEALING DETAILS
024100200528                                                                                              CDL006
024200200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL006
024300200528      ** External data structure for SAR details                                              CDL006
024400200528                                                                                              CDL006
024500200528     D DSFDY         E DS                  EXTNAME(DSFDY)
024600200528      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
024700200528                                                                                             BUG7222
024800200528     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                 BUG7222
024900200528      ** File - Payment Further Settlement Instructions                                      BUG7222
025000200528                                                                                             BUG7222
025100200528     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                 BUG7222
025200200528      ** File - Receive Further Settlement Instructions                                      BUG7222
025300200528                                                                                             BUG7222
025400200528     D/COPY WNCPYSRC,MMDEALGD01
025500200528
025600200528      ** +--------------------------------------+
025700200528      ** ¦ Declared variables                   ¦
025800200528      ** ¦ ==================                   ¦
025900200528      ** +--------------------------------------+
026000200528
026100200528      ** Response Mode, passed as a constant parameter to the VAL module
026200200528      ** This is always 'S' for Synchronous
026300200528     D RespMode        S              1A   INZ('S')
026400200528     D/COPY WNCPYSRC,MMDEALGD02
026500200528
026600200528      ** Index for arrays of of warning message ids etc                                       CAS004
026700200528     D WIdx            S              3P 0                                                    CAS004
026800200528      *                                                                                       CGL029
026900200528     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
027000200528      *                                                                                       CGL029
027100200528                                                                                              CAS004
027200200528      ** +--------------------------------------+
027300200528      ** ¦ End of D-specs                       ¦
027400200528      ** ¦ ==============                       ¦
027500200528      ** +--------------------------------------+
027600200528      *****************************************************************
027700200528      /EJECT
027800200528      *****************************************************************
027900200528     C
028000200528      ** +--- Start of Main processing -----------------------------------+
028100200528      ** ¦                                                                ¦
028200200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
028300200528      ** ¦ executed at program activation.                                ¦
028400200528      ** ¦                                                                ¦
028500200528      ** +----------------------------------------------------------------+
028600200528
028700200528      ** If authorizations are not required
028800200528
028900200528     C     BNMMAU        IFEQ      'N'
029000200528     C                   EXSR      NOINPUT
029100200528     C                   END
029200200528     C/COPY WNCPYSRC,MMDEALGC14
029300200528
029400200528      **  Main processing
029500200528      **  Loop until CK/3 taken
029600200528
029700200528     C     *INKC         DOWEQ     '0'
029800200528     C                   EXSR      MAIN
029900200528     C                   END
030000200528      *
030100200528      * TERMINATE PROGRAM
030200200528      *
030300200528     C                   MOVE      '1'           *INLR
030400200528
030500200528      *****************************************************************
030600200528      /EJECT
030700200528      *****************************************************************
030800200528      * MAIN - MAIN PROCESSING
030900200528      *****************************************************************
031000200528     C     MAIN          BEGSR
031100200528
031200200528      ** Selection screen
031300200528
031400200528     C                   TIME                    DDTIME
031500200528     C                   WRITE     MMDEALS0
031600200528     C                   WRITE     MMDEALD1
031700200528     C                   WRITE     MMDEALF1
031800200528     C                   READ      MMDEALD1                               99
031900200528
032000200528      ** If CK/3 taken, bypass
032100200528
032200200528     C     *INKC         CABEQ     '1'           EMAIN
032300200528
032400200528      ** Validate screen input
032500200528
032600200528     C                   EXSR      VALSIN
032700200528
032800200528      ** If validation not OK, bypass
032900200528
033000200528     C     *IN50         CABEQ     '1'           EMAIN
033100200528
033200200528      ** Initialize count of authorizattions and failed authorizations
033300200528
033400200528     C                   Z-ADD     0             @CNTAU            6 0
033500200528     C                   Z-ADD     0             @CNTFL            6 0
033600200528
033700200528      ** Authorize all unauthorized loans and deposits
033800200528
033900200528     C                   EXSR      AUTHLDNI
034000200528
034100200528      ** Authorize all unauthorized NAs purchased
034200200528
034300200528     C                   EXSR      AUTHNASP
034400200528
034500200528      ** Authorize all unauthorized NAs sold
034600200528
034700200528     C                   EXSR      AUTHNASS
034800200528
034900200528      ** Authorize all unauthorized deal amendments
035000200528
035100200528     C                   EXSR      AUTHDEAM
035200200528
035300200528      ** Output authorized count message
035400200528
035500200528     C                   MOVEL     'MMM0265'     @MSGID
035600200528     C                   MOVE      @CNTAU        @ADAT1
035700200528     C                   MOVE      @FSTDLNO      @ADAT2
035800200528     C                   MOVE      @LSTDLNO      @ADAT3
035900200528     C                   CALL      'ZA0440'
036000200528     C                   PARM                    @MSGID
036100200528     C                   PARM                    @ADAT
036200200528
036300200528      ** Output failure count message
036400200528
036500200528     C     @CNTFL        IFNE      0
036600200528     C                   MOVEL     'MMM1047'     @MSGID
036700200528     C                   MOVE      @CNTFL        @FDT1
036800200528     C                   MOVE      @FSTDLNO      @FDT2
036900200528     C                   MOVE      @LSTDLNO      @FDT3
037000200528     C                   CALL      'ZA0440'
037100200528     C                   PARM                    @MSGID
037200200528     C                   PARM                    @FDTA
037300200528     C                   END
037400200528      *
037500200528     C     EMAIN         ENDSR
037600200528      *****************************************************************
037700200528      /EJECT
037800200528      *****************************************************************
037900200528      * AUTHLDNI - Authorize all unauthorized loans and deposits
038000200528      *****************************************************************
038100200528     C     AUTHLDNI      BEGSR
038200200528
038300200528      * Read Loans and Deposits
038400200528
038500200528     C                   MOVEL     @F_1DLNO      DDDLNO
038600200528     C                   EXSR      READLDNI
038700200528
038800200528      ** Do while not EOF
038900200528
039000200528     C     @ERRMS        DOWEQ     *BLANK
039100200528
039200200528      ** If deal is not deleted
039300200528
039400200528     C     HKDDLT        IFNE      'D'
039500200528
039600200528      ** Error in retrieve
039700200528
039800200528     C     Idx           IFNE      *ZERO
039900200528     C                   ADD       1             @CNTFL
040000200528     C                   ELSE
040100200528
040200200528      ** Update Loan/Deposit
040300200528
040400200528     C/COPY WNCPYSRC,MMDEALGC15
040500200528     C                   EXSR      UPDTLDNI
040600200528     C/COPY WNCPYSRC,MMDEALGC16
040700200528     C                   END
040800200528     C                   END
040900200528
041000200528      * Read Loans and Deposits
041100200528
041200200528     C                   EXSR      READLDNI
041300200528     C                   END
041400200528      *
041500200528     C                   ENDSR
041600200528      *****************************************************************
041700200528      /EJECT
041800200528      *****************************************************************
041900200528      * AUTHNASP - Authorize all unauthorized NAs Purchased
042000200528      *****************************************************************
042100200528     C     AUTHNASP      BEGSR
042200200528
042300200528      * Read NAs Purchased
042400200528
042500200528     C                   MOVEL     @F_1DLNO      DDDLNO
042600200528     C                   EXSR      READNASP
042700200528
042800200528      ** Do while not EOF
042900200528
043000200528     C     @ERRMS        DOWEQ     *BLANK
043100200528
043200200528      ** If deal is not deleted
043300200528
043400200528     C     HLDDLT        IFNE      'D'
043500200528
043600200528      ** Error in retrieve
043700200528
043800200528     C     Idx           IFNE      *ZERO
043900200528     C                   ADD       1             @CNTFL
044000200528     C                   ELSE
044100200528
044200200528      ** Update NA Purchased
044300200528
044400200528     C                   EXSR      UPDTNASP
044500200528     C                   END
044600200528     C                   END
044700200528
044800200528      * Read NAs Purchased
044900200528
045000200528     C                   EXSR      READNASP
045100200528     C                   END
045200200528      *
045300200528     C                   ENDSR
045400200528      *****************************************************************
045500200528      /EJECT
045600200528      *****************************************************************
045700200528      * AUTHNASS - Authorize all unauthorized NAs Sold
045800200528      *****************************************************************
045900200528     C     AUTHNASS      BEGSR
046000200528
046100200528      * Read NAs Sold
046200200528
046300200528     C                   MOVEL     @F_1DLNO      DDDLNO
046400200528     C                   EXSR      READNASS
046500200528
046600200528      ** Do while not EOF
046700200528
046800200528     C     @ERRMS        DOWEQ     *BLANK
046900200528
047000200528      ** If deal is not deleted
047100200528
047200200528     C     HMDDLT        IFNE      'D'
047300200528
047400200528      ** Error in retrieve
047500200528
047600200528     C     Idx           IFNE      *ZERO
047700200528     C                   ADD       1             @CNTFL
047800200528     C                   ELSE
047900200528
048000200528      ** Update NA Sold
048100200528
048200200528     C                   EXSR      UPDTNASS
048300200528     C                   END
048400200528     C                   END
048500200528
048600200528      * Read NAs Sold
048700200528
048800200528     C                   EXSR      READNASS
048900200528     C                   END
049000200528      *
049100200528     C                   ENDSR
049200200528      *****************************************************************
049300200528      /EJECT
049400200528      *****************************************************************
049500200528      * AUTHDEAM - Authorize all unauthorized Deal Amendments
049600200528      *****************************************************************
049700200528     C     AUTHDEAM      BEGSR
049800200528
049900200528      * Read Deal amendments
050000200528
050100200528     C                   MOVEL     @F_1DLNO      DDDLNO
050200200528     C                   EXSR      READDEAM
050300200528
050400200528      ** Do while not EOF
050500200528
050600200528     C     @ERRMS        DOWEQ     *BLANK
050700200528
050800200528      ** If deal amendment is not deleted
050900200528
051000200528     C     HNDDLT        IFNE      'D'
051100200528
051200200528      ** Error in retrieve
051300200528
051400200528     C     Idx           IFNE      *ZERO
051500200528     C                   ADD       1             @CNTFL
051600200528     C                   ELSE
051700200528
051800200528      ** Update Deal amendment
051900200528
052000200528     C                   EXSR      UPDTDEAM
052100200528     C                   END
052200200528     C                   END
052300200528
052400200528      * Read Deal amendments
052500200528
052600200528     C                   EXSR      READDEAM
052700200528     C                   END
052800200528      *
052900200528     C                   ENDSR
053000200528      *****************************************************************
053100200528      /EJECT
053200200528      *****************************************************************
053300200528      * UPDTLDNI - UPDATE LOAN/DEPOSIT DEAL
053400200528      *****************************************************************
053500200528     C     UPDTLDNI      BEGSR
053600200528     C/COPY WNCPYSRC,MMDEALGC06
053700200528                                                                                              CDL033
053800200528     C                   MOVEL     *BLANKS       PBFRCD                                       CDL033
053900200528     C                   MOVEL     *BLANKS       PAFRCD                                       CDL033
054000200528                                                                                              CDL033
054100200528     C     CDL033        IFEQ      'Y'                                                        CDL033
054200200528     C     HKMTYP        IFEQ      'CF'                                                       CDL033
054300200528     C     HKMTYP        OREQ      'CI'                                                       CDL033
054400200528     C     HKMTYP        OREQ      'TI'                                                       CDL033
054500200528     C     HKMTYP        OREQ      'TD'                                                       CDL033
054600200528     C     HKMTYP        OREQ      'IP'                                                       CDL033
054700200528     C     HKMTYP        OREQ      'IT'                                                       CDL033
054800200528     C                   MOVEL     DSFRCD        PBFRCD                                       CDL033
054900200528     C                   MOVEL     DSFRCD        PAFRCD                                       CDL033
055000200528     C                   ENDIF                                                                CDL033
055100200528     C                   ENDIF                                                                CDL033
055200200528                                                                                              CDL033
055300200528      *
055400200528      * UPDATE VALID DEAL: LAST ACTION CODE
055500200528      *
055600200528     C                   MOVEL     DDACTN        HKLACT
055700200528      *
055800200528      * MONEY MARKET UPDATES
055900200528      *
056000200528     C                   CALLB     'MMLDNIUPM'
056100200528     C                   PARM      *BLANK        @RTCD             7
056200200528     C                   PARM                    DELDFilFmt
056300200528     C                   PARM                    #FPAYF                                      BUG7222
056400200528     C                   PARM                    #FRECF                                      BUG7222
056500200528      ** FRCD Issued Extension details before update                                          CDL033
056600200528     C                   PARM                    PBFRCD          100                          CDL033
056700200528      ** FRCD Issued Extension details after update                                           CDL033
056800200528     C                   PARM                    PAFRCD          100                          CDL033
056900200528     C/COPY WNCPYSRC,MMDEALGC07
057000200528      *
057100200528      * DEALS UPDATES
057200200528      *
057300200528     C     @RTCD         IFEQ      *BLANK
057400200528     C                   CALLB     'MMLDNIUPD'
057500200528     C                   PARM                    @RTCD
057600200528     C                   PARM                    DELDFilFmt
057700200528     C                   END
057800200528     C/COPY WNCPYSRC,MMDEALGC01
057900200528      *
058000200528      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
058100200528      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
058200200528      *
058300200528     C     @RTCD         IFNE      *BLANK
058400200528     C                   ROLBK
058500200528     C                   EXSR      *PSSR
058600200528     C                   ELSE
058700200528     C                   COMMIT
058800200528     C/COPY WNCPYSRC,MMDEALGC13
058900200528     C                   ADD       1             @CNTAU
059000200528     C                   END
059100200528      *
059200200528     C                   ENDSR
059300200528      *****************************************************************
059400200528      /EJECT
059500200528      *****************************************************************
059600200528      * UPDTNASP - UPDATE NAS PURCHASED
059700200528      *****************************************************************
059800200528     C     UPDTNASP      BEGSR
059900200528      *
060000200528      * UPDATE VALID DEAL: LAST ACTION CODE
060100200528      *
060200200528     C                   MOVEL     DDACTN        HLLACT
060300200528      *
060400200528      * MONEY MARKET UPDATES
060500200528      *
060600200528     C                   CALLB     'MMNASPUPM'
060700200528     C                   PARM      *BLANK        @RTCD             7
060800200528     C                   PARM                    DENBFilFmt
060900200528      *
061000200528      * DEALS UPDATES
061100200528      *
061200200528     C     @RTCD         IFEQ      *BLANK
061300200528     C                   CALLB     'MMNASPUPD'
061400200528     C                   PARM                    @RTCD
061500200528     C                   PARM                    DENBFilFmt
061600200528     C                   END
061700200528      *
061800200528      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
061900200528      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
062000200528      *
062100200528     C     @RTCD         IFNE      *BLANK
062200200528     C                   ROLBK
062300200528     C                   EXSR      *PSSR
062400200528     C                   ELSE
062500200528     C                   COMMIT
062600200528     C                   ADD       1             @CNTAU
062700200528     C                   END
062800200528      *
062900200528     C                   ENDSR
063000200528      *****************************************************************
063100200528      /EJECT
063200200528      *****************************************************************
063300200528      * UPDTNASS - UPDATE NAS SOLD
063400200528      *****************************************************************
063500200528     C     UPDTNASS      BEGSR
063600200528      *
063700200528      * UPDATE VALID DEAL: LAST ACTION CODE
063800200528      *
063900200528     C                   MOVEL     DDACTN        HMLACT
064000200528      *
064100200528      * MONEY MARKET UPDATES
064200200528      *
064300200528     C                   CALLB     'MMNASSUPM'
064400200528     C                   PARM      *BLANK        @RTCD             7
064500200528     C                   PARM                    DENSFilFmt
064600200528      *
064700200528      * DEALS UPDATES
064800200528      *
064900200528     C     @RTCD         IFEQ      *BLANK
065000200528     C                   CALLB     'MMNASSUPD'
065100200528     C                   PARM                    @RTCD
065200200528     C                   PARM                    DENSFilFmt
065300200528     C                   END
065400200528      *
065500200528      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
065600200528      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
065700200528      *
065800200528     C     @RTCD         IFNE      *BLANK
065900200528     C                   ROLBK
066000200528     C                   EXSR      *PSSR
066100200528     C                   ELSE
066200200528     C                   COMMIT
066300200528     C                   ADD       1             @CNTAU
066400200528     C                   END
066500200528      *
066600200528     C                   ENDSR
066700200528      *****************************************************************
066800200528      /EJECT
066900200528      *****************************************************************
067000200528      * UPDTDEAM - UPDATE DEAL AMENDMENTS
067100200528      *****************************************************************
067200200528     C     UPDTDEAM      BEGSR
067300200528      *
067400200528      * UPDATE VALID DEAL AMENDMENT: LAST ACTION CODE
067500200528      *
067600200528     C                   MOVEL     DDACTN        HNLACT
067700200528      *
067800200528      * MONEY MARKET UPDATES
067900200528      *
068000200528     C                   CALLB     'MMDEAMUPM'
068100200528     C                   PARM      *BLANK        @RTCD             7
068200200528     C                   PARM                    DEAMFilFmt
068300200528      *
068400200528      * DEALS UPDATES
068500200528      *
068600200528     C     @RTCD         IFEQ      *BLANK
068700200528     C                   CALLB     'MMDEAMUPD'
068800200528     C                   PARM                    @RTCD
068900200528     C                   PARM                    DEAMFilFmt
069000200528     C                   END
069100200528     C/COPY WNCPYSRC,MMDEALGC02
069200200528      *
069300200528      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
069400200528      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
069500200528      *
069600200528     C     @RTCD         IFNE      *BLANK
069700200528     C                   ROLBK
069800200528     C                   EXSR      *PSSR
069900200528     C                   ELSE
070000200528     C                   COMMIT
070100200528     C                   ADD       1             @CNTAU
070200200528     C                   END
070300200528      *
070400200528     C                   ENDSR
070500200528      *****************************************************************
070600200528      /EJECT
070700200528      *****************************************************************
070800200528      * READLDNI - READ THROUGH LOANS & DEPOSITS
070900200528      *****************************************************************
071000200528     C     READLDNI      BEGSR
071100200528      *
071200200528     C/COPY WNCPYSRC,MMDEALGC08
071300200528     C                   CALLB     'MMLDNIRED'
071400200528      *
071500200528      * INPUT PARAMETERS
071600200528      *
071700200528      * RETURN CODE
071800200528     C                   PARM      *BLANK        RetCodeOut
071900200528      *                                                                         CAP052
072000200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
072100200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
072200200528      *                                                                         CAP052
072300200528     C                   PARM      '      '      @@MODE            6            CAP052
072400200528      *
072500200528      * ACTION CODE
072600200528     C                   PARM      'X'           DDACTN            1
072700200528      *
072800200528      * DEAL NUMBER POINTER
072900200528     C                   PARM                    DDDLNO            6
073000200528      *                                                                         CAP052
073100200528      * Front Office ID                                                         CAP052
073200200528     C                   PARM                    DDFRTN           20            CAP052
073300200528      *
073400200528      * READ FORWARDS
073500200528     C                   PARM      'Y'           @RDFWD            1
073600200528      *
073700200528      * READ BACKWARDS
073800200528     C                   PARM      *BLANK        @RDBCK            1
073900200528      *
074000200528      * OUTPUT PARAMETERS
074100200528      *
074200200528      * ERROR MESSAGE
074300200528     C                   PARM      *BLANK        @ERRMS            7
074400200528      *
074500200528      * DEAL NUMBER READ
074600200528     C                   PARM      *BLANK        @DLRED            6
074700200528      *                                                                         CAP052
074800200528      * Front Office ID READ                                                    CAP052
074900200528     C                   PARM      *BLANK        @FTRED           20            CAP052
075000200528      *
075100200528      * If no deal read, treat like EOF
075200200528      *
075300200528     C     @DLRED        IFEQ      *BLANK
075400200528     C                   MOVEL     '*EOF'        @ERRMS
075500200528     C                   END
075600200528      *
075700200528      * If error message returned from read, then it is EOF
075800200528      *
075900200528     C     @ERRMS        CABNE     *BLANK        EREADLDNI
076000200528      *
076100200528      * Check whether past last deal number
076200200528      *
076300200528     C                   MOVEL     @DLRED        @CURDLNO          6 0
076400200528     C     @CURDLNO      IFGT      @LSTDLNO
076500200528     C                   MOVEL     '*EOF'        @ERRMS
076600200528      *
076700200528      * Retrieve deal details
076800200528      *
076900200528     C                   ELSE
077000200528     C                   MOVEL     @DLRED        DDDLNO
077100200528     C                   EXSR      RTVLDNI
077200200528     C                   END
077300200528     C/COPY WNCPYSRC,MMDEALGC09
077400200528      *
077500200528     C     EREADLDNI     ENDSR
077600200528      *****************************************************************
077700200528      /EJECT
077800200528      *****************************************************************
077900200528      * READNASP - READ THROUGH NAS PURCHASED
078000200528      *****************************************************************
078100200528     C     READNASP      BEGSR
078200200528      *
078300200528     C                   CALLB     'MMNASPRED'
078400200528      *
078500200528      * INPUT PARAMETERS
078600200528      *
078700200528      * RETURN CODE
078800200528     C                   PARM      *BLANK        RetCodeOut
078900200528      *                                                                         CAP052
079000200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
079100200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
079200200528      *                                                                         CAP052
079300200528     C                   PARM      '      '      @@MODE            6            CAP052
079400200528      *
079500200528      * ACTION CODE
079600200528     C                   PARM      'X'           DDACTN            1
079700200528      *
079800200528      * DEAL NUMBER POINTER
079900200528     C                   PARM                    DDDLNO            6
080000200528      *                                                                         CAP052
080100200528      * Front Office ID                                                         CAP052
080200200528     C                   PARM                    DDFRTN           20            CAP052
080300200528      *
080400200528      * READ FORWARDS
080500200528     C                   PARM      'Y'           @RDFWD            1
080600200528      *
080700200528      * READ BACKWARDS
080800200528     C                   PARM      *BLANK        @RDBCK            1
080900200528      *
081000200528      * OUTPUT PARAMETERS
081100200528      *
081200200528      * ERROR MESSAGE
081300200528     C                   PARM      *BLANK        @ERRMS            7
081400200528      *
081500200528      * DEAL NUMBER READ
081600200528     C                   PARM      *BLANK        @DLRED            6
081700200528      *                                                                         CAP052
081800200528      * Front Office ID READ                                                    CAP052
081900200528     C                   PARM      *BLANK        @FTRED           20            CAP052
082000200528      *
082100200528      * If no deal read, treat like EOF
082200200528      *
082300200528     C     @DLRED        IFEQ      *BLANK
082400200528     C                   MOVEL     '*EOF'        @ERRMS
082500200528     C                   END
082600200528      *
082700200528      * If error message returned from read, then it is EOF
082800200528      *
082900200528     C     @ERRMS        CABNE     *BLANK        EREADNASP
083000200528      *
083100200528      * Check whether past last deal number
083200200528      *
083300200528     C                   MOVEL     @DLRED        @CURDLNO          6 0
083400200528     C     @CURDLNO      IFGT      @LSTDLNO
083500200528     C                   MOVEL     '*EOF'        @ERRMS
083600200528      *
083700200528      * Retrieve deal details
083800200528      *
083900200528     C                   ELSE
084000200528     C                   MOVEL     @DLRED        DDDLNO
084100200528     C                   EXSR      RTVNASP
084200200528     C                   END
084300200528      *
084400200528     C     EREADNASP     ENDSR
084500200528      *****************************************************************
084600200528      /EJECT
084700200528      *****************************************************************
084800200528      * READNASS - READ THROUGH NAS SOLD
084900200528      *****************************************************************
085000200528     C     READNASS      BEGSR
085100200528      *
085200200528     C                   CALLB     'MMNASSRED'
085300200528      *
085400200528      * INPUT PARAMETERS
085500200528      *
085600200528      * RETURN CODE
085700200528     C                   PARM      *BLANK        RetCodeOut
085800200528      *                                                                         CAP052
085900200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
086000200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
086100200528      *                                                                         CAP052
086200200528     C                   PARM      '      '      @@MODE            6            CAP052
086300200528      *
086400200528      * ACTION CODE
086500200528     C                   PARM      'X'           DDACTN            1
086600200528      *
086700200528      * DEAL NUMBER POINTER
086800200528     C                   PARM                    DDDLNO            6
086900200528      *                                                                         CAP052
087000200528      * Front Office ID                                                         CAP052
087100200528     C                   PARM                    DDFRTN           20            CAP052
087200200528      *
087300200528      * READ FORWARDS
087400200528     C                   PARM      'Y'           @RDFWD            1
087500200528      *
087600200528      * READ BACKWARDS
087700200528     C                   PARM      *BLANK        @RDBCK            1
087800200528      *
087900200528      * OUTPUT PARAMETERS
088000200528      *
088100200528      * ERROR MESSAGE
088200200528     C                   PARM      *BLANK        @ERRMS            7
088300200528      *
088400200528      * DEAL NUMBER READ
088500200528     C                   PARM      *BLANK        @DLRED            6
088600200528      *                                                                         CAP052
088700200528      * Front Office ID READ                                                    CAP052
088800200528     C                   PARM      *BLANK        @FTRED           20            CAP052
088900200528      *
089000200528      * If no deal read, treat like EOF
089100200528      *
089200200528     C     @DLRED        IFEQ      *BLANK
089300200528     C                   MOVEL     '*EOF'        @ERRMS
089400200528     C                   END
089500200528      *
089600200528      * If error message returned from read, then it is EOF
089700200528      *
089800200528     C     @ERRMS        CABNE     *BLANK        EREADNASS
089900200528      *
090000200528      * Check whether past last deal number
090100200528      *
090200200528     C                   MOVEL     @DLRED        @CURDLNO          6 0
090300200528     C     @CURDLNO      IFGT      @LSTDLNO
090400200528     C                   MOVEL     '*EOF'        @ERRMS
090500200528      *
090600200528      * Retrieve deal details
090700200528      *
090800200528     C                   ELSE
090900200528     C                   MOVEL     @DLRED        DDDLNO
091000200528     C                   EXSR      RTVNASS
091100200528     C                   END
091200200528      *
091300200528     C     EREADNASS     ENDSR
091400200528      *****************************************************************
091500200528      /EJECT
091600200528      *****************************************************************
091700200528      * READDEAM - READ THROUGH DEAL AMENDMENTS
091800200528      *****************************************************************
091900200528     C     READDEAM      BEGSR
092000200528      *
092100200528     C/COPY WNCPYSRC,MMDEALGC10
092200200528     C                   CALLB     'MMDEAMRED'
092300200528      *
092400200528      * INPUT PARAMETERS
092500200528      *
092600200528      * RETURN CODE
092700200528     C                   PARM      *BLANK        RetCodeOut
092800200528      *                                                                         CAP052
092900200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
093000200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
093100200528      *                                                                         CAP052
093200200528     C                   PARM      '      '      @@MODE            6            CAP052
093300200528      *
093400200528      * ACTION CODE
093500200528     C                   PARM      'X'           DDACTN            1
093600200528      *
093700200528      * DEAL NUMBER POINTER
093800200528     C                   PARM                    DDDLNO            6
093900200528      *                                                                         CAP052
094000200528      * Front Office ID                                                         CAP052
094100200528     C                   PARM                    DDFRTN           20            CAP052
094200200528     C                   PARM                    DDVDAT            6
094300200528     C                   PARM                    DDDS38            3
094400200528      *
094500200528      * READ FORWARDS
094600200528     C                   PARM      'Y'           @RDFWD            1
094700200528      *
094800200528      * READ BACKWARDS
094900200528     C                   PARM      *BLANK        @RDBCK            1
095000200528      *
095100200528      * OUTPUT PARAMETERS
095200200528      *
095300200528      * ERROR MESSAGE
095400200528     C                   PARM      *BLANK        @ERRMS            7
095500200528      *
095600200528      * DEAL NUMBER READ
095700200528     C                   PARM      *BLANK        @DLRED            6
095800200528      *                                                                         CAP052
095900200528      * Front Office ID READ                                                    CAP052
096000200528     C                   PARM      *BLANK        @FTRED           20            CAP052
096100200528      *                                                                         CAP052
096200200528      * Front Office Associated ID READ                                         CAP052
096300200528     C                   PARM      *BLANK        @FARED           20            CAP052
096400200528      *
096500200528      * VALUE DATE READ
096600200528     C                   PARM      *BLANK        @VDRED            6
096700200528      *
096800200528      * SEQUENCE NUMBER READ
096900200528     C                   PARM      *BLANK        @SQRED            3
097000200528      *
097100200528      * If no deal amendment read, treat like EOF
097200200528      *
097300200528     C     @DLRED        IFEQ      *BLANK
097400200528     C     @VDRED        OREQ      *BLANK
097500200528     C     @SQRED        OREQ      *BLANK
097600200528     C                   MOVEL     '*EOF'        @ERRMS
097700200528     C                   END
097800200528      *
097900200528      * If error message returned from read, then it is EOF
098000200528      *
098100200528     C     @ERRMS        CABNE     *BLANK        EREADDEAM
098200200528      *
098300200528      * Check whether past last deal number
098400200528      *
098500200528     C                   MOVEL     @DLRED        @CURDLNO          6 0
098600200528     C     @CURDLNO      IFGT      @LSTDLNO
098700200528     C                   MOVEL     '*EOF'        @ERRMS
098800200528      *
098900200528      * Retrieve deal amendment details
099000200528      *
099100200528     C                   ELSE
099200200528     C                   MOVEL     @DLRED        DDDLNO
099300200528     C                   MOVEL     @VDRED        DDVDAT
099400200528     C                   MOVEL     @SQRED        DDDS38
099500200528     C                   EXSR      RTVDEAM
099600200528     C                   END
099700200528     C/COPY WNCPYSRC,MMDEALGC11
099800200528      *
099900200528     C     EREADDEAM     ENDSR
100000200528      *****************************************************************
100100200528      /EJECT
100200200528      *****************************************************************
100300200528      * RTVLDNI - RETRIEVE LOAN & DEPOSIT DEAL
100400200528      *****************************************************************
100500200528     C     RTVLDNI       BEGSR
100600200528      *
100700200528      * RETRIEVE DEAL
100800200528      *
100900200528     C                   CALLB     'MMLDNIRTV'
101000200528      *
101100200528      * INPUTS
101200200528      *
101300200528      * Return code
101400200528     C                   PARM      *BLANK        RetCodeOut
101500200528      *
101600200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
101700200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
101800200528      *
101900200528     C                   PARM      '      '      @@MODE            6
102000200528      *
102100200528      * Response mode
102200200528     C                   PARM      'S'           @@RSMD            1
102300200528      *
102400200528      * Action Code
102500200528     C                   PARM                    DDACTN
102600200528      *
102700200528      * Front Office Transaction ID
102800200528     C                   PARM                    FOTRID           20
102900200528      *
103000200528      * Front Office Associated Transaction Id
103100200528     C                   PARM                    FOASID           20
103200200528      *
103300200528      * (Midas) Deal Number
103400200528     C                   PARM                    DDDLNO            6
103500200528      *                                                                                       196380
103600200528      * (Midas) Depot Movement Reference                                                      196380
103700200528     C                   PARM                    DDDDMR            6                          196380
103800200528      *
103900200528      * (Midas) Associated Deal Number
104000200528     C                   PARM                    DDDADN            6
104100200528      *
104200200528      * Booking branch
104300200528     C                   PARM                    DDBRCA            3
104400200528      * REPO Flag                                                                             CAP067
104500200528     C                   PARM      'N'           RepoFlag          1                          CAP067
104600200528      *
104700200528      * OUTPUTS
104800200528      *
104900200528      * Deal in file format
105000200528     C                   PARM                    DELDFilFmt
105100200528     C/COPY WNCPYSRC,MMDEALGC17
105200200528      *
105300200528     C                   PARM                    ACTRJ             1                        AR701789
105400200528      * OK - Action code
105500200528     C                   PARM      *BLANK        OKACTN            1
105600200528      *
105700200528      * OK - Deal Number
105800200528     C                   PARM      *BLANK        OKDLNO            1
105900200528      *
106000200528      * OK - Booking branch
106100200528     C                   PARM      *BLANK        OKBRCA            1
106200200528      ** Blocked/Unblock Action                                                              BUG2804
106300200528     C                   PARM                    BUACT             1                         BUG2804
106400200528      *
106500200528      * Error fields/message IDs/message data (arrays) from/to caller
106600200528     C                   PARM                    FldNameArr
106700200528     C                   PARM                    MsgIdArr
106800200528     C                   PARM                    MsgDtaArr
106900200528      *
107000200528      * Array index (3P0) from/to caller
107100200528     C                   PARM      *ZERO         Idx               3 0
107200200528                                                                                              CAS004
107300200528      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
107400200528                                                                                              CAS004
107500200528     C                   PARM                    WFldNamArr                                   CAS004
107600200528     C                   PARM                    WMsgIdArr                                    CAS004
107700200528     C                   PARM                    WMsgDtaArr                                   CAS004
107800200528                                                                                              CAS004
107900200528      ** Array index (3P0) from/to caller                                                     CAS004
108000200528                                                                                              CAS004
108100200528     C                   PARM                    WIdx                                         CAS004
108200200528     C/COPY WNCPYSRC,MMDEALGC03
108300200528      *
108400200528     C                   ENDSR
108500200528      *****************************************************************
108600200528      /EJECT
108700200528      *****************************************************************
108800200528      * RTVNASP - RETRIEVE NAS PURCHASED DEAL
108900200528      *****************************************************************
109000200528     C     RTVNASP       BEGSR
109100200528      *
109200200528      * RETRIEVE DEAL
109300200528      *
109400200528     C                   CALLB     'MMNASPRTV'
109500200528      *
109600200528      * INPUTS
109700200528      *
109800200528      * Return code
109900200528     C                   PARM      *BLANK        RetCodeOut
110000200528      *
110100200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
110200200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
110300200528      *
110400200528     C                   PARM      '      '      @@MODE            6
110500200528      *
110600200528      * Response mode
110700200528     C                   PARM      'S'           @@RSMD            1
110800200528      *
110900200528      * Action Code
111000200528     C                   PARM                    DDACTN
111100200528      *
111200200528      * Front Office Transaction ID
111300200528     C                   PARM                    FOTRID           20
111400200528      *
111500200528      * (Midas) Deal Number
111600200528     C                   PARM                    DDDLNO
111700200528      *
111800200528      * Booking branch
111900200528     C                   PARM                    DDBRCA
112000200528      *
112100200528      * OUTPUTS
112200200528      *
112300200528      * Deal in file format
112400200528     C                   PARM                    DENBFilFmt
112500200528      *
112600200528      * OK - Action code
112700200528     C                   PARM      *BLANK        OKACTN
112800200528      *
112900200528      * OK - Deal Number
113000200528     C                   PARM      *BLANK        OKDLNO
113100200528      *
113200200528      * OK - Booking branch
113300200528     C                   PARM      *BLANK        OKBRCA
113400200528      *
113500200528      * Error fields/message IDs/message data (arrays) from/to caller
113600200528     C                   PARM                    FldNameArr
113700200528     C                   PARM                    MsgIdArr
113800200528     C                   PARM                    MsgDtaArr
113900200528      *
114000200528      * Array index (3P0) from/to caller
114100200528     C                   PARM      *ZERO         Idx
114200200528                                                                                              CAS004
114300200528      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
114400200528                                                                                              CAS004
114500200528     C                   PARM                    WFldNamArr                                   CAS004
114600200528     C                   PARM                    WMsgIdArr                                    CAS004
114700200528     C                   PARM                    WMsgDtaArr                                   CAS004
114800200528                                                                                              CAS004
114900200528      ** Array index (3P0) from/to caller                                                     CAS004
115000200528                                                                                              CAS004
115100200528     C                   PARM                    WIdx                                         CAS004
115200200528      *
115300200528     C                   ENDSR
115400200528      *****************************************************************
115500200528      /EJECT
115600200528      *****************************************************************
115700200528      * RTVNASS - RETRIEVE NAS SOLD DEAL
115800200528      *****************************************************************
115900200528     C     RTVNASS       BEGSR
116000200528      *
116100200528      * RETRIEVE DEAL
116200200528      *
116300200528     C                   CALLB     'MMNASSRTV'
116400200528      *
116500200528      * INPUTS
116600200528      *
116700200528      * Return code
116800200528     C                   PARM      *BLANK        RetCodeOut
116900200528      *
117000200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
117100200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
117200200528      *
117300200528     C                   PARM      '      '      @@MODE            6
117400200528      *
117500200528      * Response mode
117600200528     C                   PARM      'S'           @@RSMD            1
117700200528      *
117800200528      * Action Code
117900200528     C                   PARM                    DDACTN
118000200528      *
118100200528      * Front Office Transaction ID
118200200528     C                   PARM                    FOTRID           20
118300200528      *
118400200528      * Front Office Associated Transaction Id
118500200528     C                   PARM                    FOASID           20
118600200528      *
118700200528      * (Midas) Deal Number
118800200528     C                   PARM                    DDDLNO
118900200528      *
119000200528      * (Midas) Associated Deal Number
119100200528     C                   PARM                    DDDADN
119200200528      *
119300200528      * OUTPUTS
119400200528      *
119500200528      * Deal in file format
119600200528     C                   PARM                    DENSFilFmt
119700200528      *
119800200528      * OK - Action code
119900200528     C                   PARM      *BLANK        OKACTN
120000200528      *
120100200528      * OK - Deal Number
120200200528     C                   PARM      *BLANK        OKDLNO
120300200528      *
120400200528      * Error fields/message IDs/message data (arrays) from/to caller
120500200528     C                   PARM                    FldNameArr
120600200528     C                   PARM                    MsgIdArr
120700200528     C                   PARM                    MsgDtaArr
120800200528      *
120900200528      * Array index (3P0) from/to caller
121000200528     C                   PARM      *ZERO         Idx
121100200528      *
121200200528     C                   ENDSR
121300200528      *****************************************************************
121400200528      /EJECT
121500200528      *****************************************************************
121600200528      * RTVDEAM - RETRIEVE DEAL AMENDMENT
121700200528      *****************************************************************
121800200528     C     RTVDEAM       BEGSR
121900200528      *
122000200528      * RETRIEVE DEAL AMENDMENT
122100200528      *
122200200528     C                   CALLB     'MMDEAMRTV'
122300200528      *
122400200528      * INPUTS
122500200528      *
122600200528      * Return code
122700200528     C                   PARM      *BLANK        RetCodeOut
122800200528      *
122900200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
123000200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
123100200528      *
123200200528     C                   PARM      '      '      @@MODE            6
123300200528      *
123400200528      * Response mode
123500200528     C                   PARM      'S'           @@RSMD            1
123600200528      *
123700200528      * Action Code
123800200528     C                   PARM                    DDACTN
123900200528      *
124000200528      * Front Office Transaction ID
124100200528     C                   PARM                    FOTRID           20
124200200528      *
124300200528      * Front Office Associated Transaction Id
124400200528     C                   PARM                    FOASID           20
124500200528      *
124600200528      * (Midas) Deal Number
124700200528     C                   PARM                    DDDLNO
124800200528      *
124900200528      * Value Date
125000200528     C                   PARM                    DDVDAT            6
125100200528      *
125200200528      * Sequence Number
125300200528     C                   PARM                    DDDS38            3
125400200528      *
125500200528      * Deal Amendment Amount
125600200528     C                   PARM                    DDAMNP           15
125700200528      *
125800200528      * Deal Amendment Type
125900200528     C                   PARM                    DDMTYP            2
126000200528      * Action Code (Reversal transaction)                                                    260173
126100200528     C                   PARM      *BLANK        @ACTRV            1                          260173
126200200528      *
126300200528      * OUTPUTS
126400200528      *
126500200528      * Deal amendment in file format
126600200528     C                   PARM                    DEAMFilFmt
126700200528      *
126800200528      * OK - Action code
126900200528     C                   PARM      *BLANK        OKACTN
127000200528      *
127100200528      * OK - Deal Number
127200200528     C                   PARM      *BLANK        OKDLNO
127300200528      *
127400200528      * OK - Value Date
127500200528     C                   PARM      *BLANK        OKVDAT            1
127600200528      *
127700200528      * OK - Sequence Number
127800200528     C                   PARM      *BLANK        OKDS38            1
127900200528      *
128000200528      * Error fields/message IDs/message data (arrays) from/to caller
128100200528     C                   PARM                    FldNameArr
128200200528     C                   PARM                    MsgIdArr
128300200528     C                   PARM                    MsgDtaArr
128400200528      *
128500200528      * Array index (3P0) from/to caller
128600200528     C                   PARM      *ZERO         Idx
128700200528     C/COPY WNCPYSRC,MMDEALGC04
128800200528      *
128900200528     C                   ENDSR
129000200528      *****************************************************************
129100200528      /EJECT
129200200528      *****************************************************************
129300200528      * VALSIN   - VALIDATE SCREEN INPUT
129400200528      *****************************************************************
129500200528     C     VALSIN        BEGSR
129600200528      *
129700200528      ** Clear the message queue & init error indicators
129800200528      *
129900200528     C                   CALL      'ZA0250'
130000200528     C                   MOVE      '0'           *IN50
130100200528     C                   MOVE      '0'           *IN10
130200200528     C                   MOVE      '0'           *IN11
130300200528      *
130400200528      ** First deal number must be numeric
130500200528      *
130600200528     C                   TESTN                   DDFDLN               9697
130700200528     C     DDFDLN        IFEQ      *BLANKS
130800200528     C     *IN96         ORNE      '1'
130900200528     C     *IN97         ANDNE     '1'
131000200528     C                   MOVEL     'MMM0262'     @MSGID
131100200528     C                   CALL      'ZA0240'
131200200528     C                   PARM                    @MSGID
131300200528     C                   MOVE      '1'           *IN50
131400200528     C                   MOVE      '1'           *IN10
131500200528     C                   END
131600200528      *
131700200528      ** Second deal number must be numeric
131800200528      *
131900200528     C                   TESTN                   DDLDLN               9697
132000200528     C     DDLDLN        IFEQ      *BLANKS
132100200528     C     *IN96         ORNE      '1'
132200200528     C     *IN97         ANDNE     '1'
132300200528     C                   MOVEL     'MMM0262'     @MSGID
132400200528     C                   CALL      'ZA0240'
132500200528     C                   PARM                    @MSGID
132600200528     C                   MOVE      '1'           *IN50
132700200528     C                   MOVE      '1'           *IN11
132800200528     C                   END
132900200528      *
133000200528      ** Numeric errors, no more checking
133100200528      *
133200200528     C     *IN50         CABEQ     '1'           EVALSI
133300200528      *
133400200528      ** Second number not less than first number
133500200528      *
133600200528     C                   MOVE      DDLDLN        @LSTDLNO          6 0
133700200528     C                   MOVE      DDFDLN        @FSTDLNO          6 0
133800200528     C     @LSTDLNO      IFLT      @FSTDLNO
133900200528     C                   MOVEL     'MMM0263'     @MSGID
134000200528     C                   CALL      'ZA0240'
134100200528     C                   PARM                    @MSGID
134200200528     C                   MOVE      '1'           *IN50
134300200528     C                   MOVE      '1'           *IN11
134400200528     C                   GOTO      EVALSI
134500200528     C                   END
134600200528      *
134700200528      ** Look for at least one deal
134800200528      *
134900200528     C     @FSTDLNO      SUB       1             @F_1DLNO          6 0
135000200528     C                   MOVEL     @F_1DLNO      DDDLNO
135100200528     C                   EXSR      READLDNI
135200200528     C     @ERRMS        IFNE      *BLANK
135300200528     C                   EXSR      READNASP
135400200528     C     @ERRMS        IFNE      *BLANK
135500200528     C                   EXSR      READNASS
135600200528     C     @ERRMS        IFNE      *BLANK
135700200528     C                   EXSR      READDEAM
135800200528     C                   END
135900200528     C                   END
136000200528     C                   END
136100200528      *
136200200528      ** Error if not at least one record to authorize
136300200528      *
136400200528     C     @ERRMS        IFNE      *BLANK
136500200528     C                   MOVEL     'MMM1029'     @MSGID
136600200528     C                   CALL      'ZA0240'
136700200528     C                   PARM                    @MSGID
136800200528     C                   MOVE      '1'           *IN50
136900200528     C                   MOVE      '1'           *IN10
137000200528     C                   END
137100200528      *
137200200528     C     EVALSI        ENDSR
137300200528      *****************************************************************
137400200528      /EJECT
137500200528      *****************************************************************
137600200528      * NOINPUT - NO INPUT SCREEN
137700200528      *****************************************************************
137800200528     C     NOINPUT       BEGSR
137900200528      *
138000200528      ** Write message, present screen and end program
138100200528      *
138200200528     C                   MOVEL     'MMM0159'     @MSGID           10
138300200528     C                   CALL      'ZA0240'
138400200528     C                   PARM                    @MSGID
138500200528
138600200528     C                   MOVE      '1'           *IN13
138700200528     C                   TIME                    DDTIME
138800200528     C                   WRITE     MMDEALS0
138900200528     C                   WRITE     MMDEALD1
139000200528     C                   WRITE     MMDEALF1
139100200528     C                   READ      MMDEALD1                               99
139200200528
139300200528     C                   SETON                                        LR
139400200528     C                   RETURN
139500200528
139600200528     C                   ENDSR
139700200528      *****************************************************************
139800200528      /EJECT
139900200528      *****************************************************************
140000200528      * *INZSR - INITIAL PROCESSING
140100200528      *****************************************************************
140200200528     C     *INZSR        BEGSR
140300200528      *
140400200528      ** Initialize program name
140500200528      *
140600200528     C                   MOVEL     'MMDEALRAT'   DBPGM
140700200528      *
140800200528      ** Set up subfile message queue information
140900200528      *
141000200528     C                   MOVEL     '*'           DDPGMQ
141100200528     C                   MOVE      '1'           *IN40
141200200528      *
141300200528      ** Move workstation ID to screen field.
141400200528      *
141500200528     C                   MOVEL     PsJobName     DDWID
141600200528      *
141700200528      ** Get DEALING ICD
141800200528      *
141900200528     C**********         CALLB     'AODEALR0'                                                 CGL029
142000200528     C                   CALLB     'AODEALR1'                                                 CGL029
142100200528     C                   PARM      '*DBERR '     @RTCD             7
142200200528     C                   PARM      '*FIRST '     @OPTN             7
142300200528     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
142400200528     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
142500200528      *
142600200528      * DATABASE ERROR
142700200528      *
142800200528     C     @RTCD         IFNE      *BLANKS
142900200528     C                   MOVEL     'SDDEALPD'    DBFILE                         ************
143000200528     C                   MOVEL     '900'         DBASE                          * DBERR 901*
143100200528     C                   MOVEL     @OPTN         DBKEY                          ************
143200200528     C                   EXSR      *PSSR
143300200528     C                   END
143400200528                                                                                              CDL006
143500200528      ** Check if Dealing Fiduciary is switched ON                                            CDL006
143600200528                                                                                              CDL006
143700200528     C                   CALLB     'MMFIDINIT'                                                CDL006
143800200528     C                   PARM      *BLANKS       WRTCD             7                          CDL006
143900200528     C/COPY WNCPYSRC,MMDEALGC05
144000200528      *                                                                                       CDL033
144100200528      ** Determine if Floating Rate CD Issued feature is                                      CDL033
144200200528      ** switched on.                                                                         CDL033
144300200528      *                                                                                       CDL033
144400200528     C                   MOVE      'N'           CDL033            1                          CDL033
144500200528     C                   CALL      'AOSARDR0'                                                 CDL033
144600200528     C                   PARM      *BLANKS       @RTCD                                        CDL033
144700200528     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
144800200528     C                   PARM      'CDL033'      @SARD                                        CDL033
144900200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
145000200528      *                                                                                       CDL033
145100200528     C     @RTCD         IFEQ      *BLANKS                                                    CDL033
145200200528     C                   MOVE      'Y'           CDL033                                       CDL033
145300200528     C                   ELSE                                                                 CDL033
145400200528     C     @RTCD         IFNE      '*NRF   '                                                  CDL033
145500200528     C                   MOVE      '901'         DBASE                                        CDL033
145600200528     C                   MOVEL     'CDL033'      DBKEY                                        CDL033
145700200528     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
145800200528     C                   EXSR      *PSSR                                                      CDL033
145900200528     C                   ENDIF                                                                CDL033
146000200528     C                   ENDIF                                                                CDL033
146100200528
146200200528     C                   ENDSR
146300200528      *****************************************************************
146400200528      /EJECT
146500200528     C/COPY WNCPYSRC,MMDEALGC12
146600200528      *****************************************************************
146700200528      ** Program, module and procedure names for database error processing.
146800200528      ** =================================================================
146900200528      ** The following /COPY sets these values, and also defines LDA as
147000200528      ** an external data area
147100200528      ********************************************************************
147200200528     C/COPY ZACPYSRC,PSSR_ILE
147300200528      ********************************************************************
147400200528**  CPY@
147500200528(c) Finastra International Limited 2001
