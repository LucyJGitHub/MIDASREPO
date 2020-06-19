000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas MM Deal range auth. by front office ID')         *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Money Market Dealing Module                          *
000900200529      *                                                               *
001000200529      *  MMPBDLRAT - MM DEAL RANGE AUTHORIZATION                      *
001100200529      *              By Front Office ID                               *
001200200529      *                                                               *
001300200529      *  Function:  This input function allows range authorization    *
001400200529      *             of all MM transactions by Front Office ID         *
001500200529      *                                                               *
001600200529      *  (c) Finastra International Limited 2001                      *
001700200529      *                                                               *
001800200604      *  Last Amend No. 260173             Date 22May20               *
001900200529      *  Prev Amend No. CER050             Date 16Jun19               *
002000200529      *                 MD046248           Date 27Oct17               *
002100200529      *                 AR701789           Date 26Sep16               *
002200200529      *                 CGL165             Date 17Feb15               *
002300200529      *                 CDL096             Date 22Sep14               *
002400200529      *                 CDL094             Date 11Jun14               *
002500200529      *                 CRE073             Date 06Dec10               *
002600200529      *                 CER059             Date 19Jul10               *
002700200529      *                 CER020             Date 19May08               *
002800200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002900200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
003000200529      * Midas Plus 1.4 Base ------------------------------------------*
003100200529      * Midas Plus 1.3 ----------- Base ------------------------------*
003200200529      *                 CDL049             Date 11Jul06               *
003300200529      *                 CSD027             Date 09Dec05               *
003400200529      *                 CDL038             Date 10May05               *
003500200529      *                 CDL033             Date 10Feb05               *
003600200529      *                 CMM105             Date 22Jun04               *
003700200529      *                 BUG2804            Date 20May04               *
003800200529      *                 CGL014             Date 20Oct03               *
003900200529      *                 CDL022             Date 03Feb04               *
004000200529      *                 CDL020             Date 03Feb04               *
004100200529      *                 CDL019             Date 03Feb04               *
004200200529      *                 CDL018             Date 03Feb04               *
004300200529      *                 CDL017             Date 03Feb04               *
004400200529      *                 CDL016             Date 03Feb04               *
004500200529      *                 CGL029             Date 01Sep03               *
004600200529      *                 222727             Date 05Nov03               *
004700200529      *                 CAS005             Date 16Dec02               *
004800200529      *                 CAS004             Date 26Jun02               *
004900200529      * Midas Release 4.01.02 ----------------------------------------*
005000200529      *                 196380             Date 15May02               *
005100200529      * Midas Release 4.01 -------------------------------------------*
005200200529      *                 CAP067             Date 24Sep01               *
005300200529      * Midas Release 4 --------------- Base -------------------------*
005400200529      * Midas DBA 3.02 -----------------------------------------------*
005500200529      *                 CAP052  *CREATE    Date 25Nov99               *
005600200529      *                                                               *
005700200529      *---------------------------------------------------------------*
005800200529      *                                                               *
005900200529      *  260173 - Synchronize parameter in MMDEAMRTV to avoid         *
006000200529      *           parameter mismatch. Apply fix 258724.               *
006100200529      *  CER050 - Annualised Percentage Rate (Recompile)              *
006200200529      *  MD046248 - Finastra Rebranding                               *
006300200529      *  AR701789 - Unable to reject a deal amendment. Add a new      *
006400200529      *             parameter to indicate reject transaction.         *
006500200529      *             Applied for MD041482                              *
006600200529      *  CGL165 - Dual Withholding Tax (Recompile)                    *
006700200529      *  CDL096 - Business Day Conventions on MM Deals                *
006800200529      *           (Recompile)                                         *
006900200529      *  CDL094 - Enhance  Receive Settlement Instructions            *
007000200529      *           (Recompiled)                                        *
007100200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
007200200529      *  CER059 - German Feature Upgrade to Delhi                     *
007300200529      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
007400200529      *           Midas Plus (Recompile)                              *
007500200529      *  CDL049 - Addition of a Reference Rate field (recompile)      *
007600200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
007700200529      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
007800200529      *  CDL033 - Floating Rate CDs Issued                            *
007900200529      *         - Incomplete parameter list passed to MMLDNIUPM.      *
008000200529      *  CMM105 - Core changes for GBO005                             *
008100200529      *         - Fixed Deposits Held Under Lien                      *
008200200529      *         - Upgrade to Midasplus                                *
008300200529      *           Core hooks amended:MMPBDLGD02,MMPBDLGC02,           *
008400200529      *           Core hooks added:MMPBDLGC10                         *
008500200529      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
008600200529      *  CGL014 - Collaterals Processing (Recompile)                  *
008700200529      *  CDL022 - Deal Amendment Changes (Recompile)                  *
008800200529      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
008900200529      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
009000200529      *           (Recompile)                                         *
009100200529      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
009200200529      *           (Recompile)                                         *
009300200529      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
009400200529      *           (Recompile)                                         *
009500200529      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
009600200529      *           (Recompile)                                         *
009700200529      *  CGL029 - Increase Account Code to 10 digits                  *
009800200529      *  222727 - Release 5.0 errors  (Recompile)                     *
009900200529      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
010000200529      *           (Recompile)                                         *
010100200529      *  CAS004 - Hedge Accounting Phase A                            *
010200200529      *  196380 - Added parameter to MMLDNIRTV call.                  *
010300200529      *  CAP067 - Repurchase Agreements API.                          *
010400200529      *  CAP052 - Deal Range Authorisation (By Front Office ID)       *
010500200529      *                                                               *
010600200529      *****************************************************************
010700200529
010800200529     FMMPBDLRDF CF   E             WORKSTN INFSR(*PSSR)
010900200529     F/COPY WNCPYSRC,MMPBDLGF01
011000200529
011100200529      *****************************************************************
011200200529      ** +--------------------------------------+
011300200529      ** ¦ Automatically included D-specs       ¦
011400200529      ** ¦ ==============================       ¦
011500200529      ** +--------------------------------------+
011600200529      **
011700200529      ** Standard D-specs
011800200529      ** ================
011900200529      **
012000200529      ** The following /COPY line includes the LDA layout,
012100200529      ** the copyright array definition,
012200200529      ** and the following named constants:
012300200529      **    True       logical = *on (for indcator processing)
012400200529      **    False      logical = *off (for indcator processing)
012500200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
012600200529      **                                    handler)
012700200529      ** and the following variables:
012800200529      **    RunBefore  1A (for the PSSR)
012900200529
013000200529     D/COPY ZACPYSRC,STD_D_SPEC
013100200529
013200200529      ** Include the MM standard declares
013300200529     D/COPY ZACPYSRC,STDDECLARE
013400200529
013500200529      ** Program Status Data Structure
013600200529      ** =============================
013700200529      ** The following /COPY line includes all the defined fields in the
013800200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
013900200529
014000200529     D/COPY ZACPYSRC,PSDS
014100200529
014200200529      ** +--------------------------------------+
014300200529      ** ¦ End of automatically included D-specs¦
014400200529      ** ¦ =====================================¦
014500200529      ** +--------------------------------------+
014600200529
014700200529      *****************************************************************
014800200529      /EJECT
014900200529      *****************************************************************
015000200529
015100200529      ** +--------------------------------------+
015200200529      ** ¦ Manually included D-specs            ¦
015300200529      ** ¦ =========================            ¦
015400200529      ** +--------------------------------------+
015500200529
015600200529      ** +--------------------------------------+
015700200529      ** ¦ Named constants                      ¦
015800200529      ** ¦ ===============                      ¦
015900200529      ** +--------------------------------------+
016000200529
016100200529      ** The maximum size of the error arrays
016200200529     D ArrayMax        C                   CONST(75)
016300200529                                                                                              CAS004
016400200529      ** Array for Warning messages                                                           CAS004
016500200529     D WFldNamArr      S             10A   DIM(ArrayMax)                                      CAS004
016600200529     D WMsgIDArr       S                   DIM(ArrayMax) LIKE(#MsgID)                         CAS004
016700200529     D WMsgDtaArr      S                   DIM(ArrayMax) LIKE(#MsgData)                       CAS004
016800200529
016900200529      ** +--------------------------------------+
017000200529      ** ¦ Arrays and Data Structures           ¦
017100200529      ** ¦ ==========================           ¦
017200200529      ** +--------------------------------------+
017300200529
017400200529      ** data structure for data to output 'authorized' message
017500200529     D @ADAT           DS            46
017600200529     D  @ADAT1                 1      6
017700200529     D  @ADAT2                 7     26
017800200529     D  @ADAT3                27     45
017900200529
018000200529      ** data structure for data to output 'failed' message
018100200529     D @FDTA           DS            45
018200200529     D  @FDT1                  1      6
018300200529     D  @FDT2                  7     26
018400200529     D  @FDT3                 27     45
018500200529
018600200529
018700200529      ** Array of Fields in error.
018800200529     D FldNameArr      S             10A   DIM(ArrayMax)
018900200529
019000200529      ** Array of error message IDs
019100200529     D MsgIDArr        S                   DIM(ArrayMax) LIKE(#MsgID)
019200200529
019300200529      ** Array of error message data.
019400200529     D MsgDtaArr       S                   DIM(ArrayMax) LIKE(#MsgData)
019500200529
019600200529
019700200529     D DELDFilFmt    E DS                  EXTNAME(MMDELDPP)
019800200529     D DSFRCD                        47    OVERLAY(DELDFilFmt:1850)                           CDL033
019900200529      ** DS for FRCD Issued Extension details                                                 CDL033
020000200529     D DENBFilFmt    E DS                  EXTNAME(MMDENBPP)
020100200529     D DENSFilFmt    E DS                  EXTNAME(MMDENSPP)
020200200529     D DORIQQ1       E                     EXTFLD(DORIQQ)                                     CGL029
020300200529     D MORIQQ1       E                     EXTFLD(MORIQQ)                                     CGL029
020400200529     D RONSQQ1       E                     EXTFLD(RONSQQ)                                     CGL029
020500200529     D PONSQQ1       E                     EXTFLD(PONSQQ)                                     CGL029
020600200529     D DEAMFilFmt    E DS                  EXTNAME(MMDEAMPP)
020700200529     D DORIQQ2       E                     EXTFLD(QQDORI)                                     CGL029
020800200529     D MORIQQ2       E                     EXTFLD(QQMORI)                                     CGL029
020900200529     D DOPIQQ2       E                     EXTFLD(QQDOPI)                                     CGL029
021000200529     D MOPIQQ2       E                     EXTFLD(QQMOPI)                                     CGL029
021100200529     D RONSQQ2       E                     EXTFLD(QQRONS)                                     CGL029
021200200529     D PONSQQ2       E                     EXTFLD(QQPONS)                                     CGL029
021300200529
021400200529
021500200529     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
021600200529      ** EXTERNAL DS FOR DEALING DETAILS
021700200529     D DSFDY         E DS                  EXTNAME(DSFDY)
021800200529      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
021900200529                                                                                              CDL033
022000200529     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                  CDL033
022100200529      ** File - Payment Further Settlement Instructions                                       CDL033
022200200529                                                                                              CDL033
022300200529     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                  CDL033
022400200529      ** File - Receive Further Settlement Instructions                                       CDL033
022500200529                                                                                              CDL033
022600200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL033
022700200529      ** External data structure for SAR details                                              CDL033
022800200529                                                                                              CDL033
022900200529     D PBFRCD          S            100A                                                      CDL033
023000200529     D PAFRCD          S            100A                                                      CDL033
023100200529     D PRTCD           S              7A                                                      CDL033
023200200529     D POPTN           S              7A                                                      CDL033
023300200529     D PSARD           S              6A                                                      CDL033
023400200529                                                                                              CDL033
023500200529     D/COPY WNCPYSRC,MMPBDLGD01
023600200529
023700200529      ** +--------------------------------------+
023800200529      ** ¦ Declared variables                   ¦
023900200529      ** ¦ ==================                   ¦
024000200529      ** +--------------------------------------+
024100200529
024200200529      ** Response Mode, passed as a constant parameter to the VAL module
024300200529      ** This is always 'S' for Synchronous
024400200529     D RespMode        S              1A   INZ('S')
024500200529     D/COPY WNCPYSRC,MMPBDLGD02
024600200529
024700200529      ** Index for arrays of of warning message ids etc                                       CAS004
024800200529     D WIdx            S              3P 0                                                    CAS004
024900200529      *                                                                                       CGL029
025000200529     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
025100200529      *                                                                                       CGL029
025200200529                                                                                              CAS004
025300200529      ** +--------------------------------------+
025400200529      ** ¦ End of D-specs                       ¦
025500200529      ** ¦ ==============                       ¦
025600200529      ** +--------------------------------------+
025700200529      *****************************************************************
025800200529      /EJECT
025900200529      *****************************************************************
026000200529     C
026100200529      ** +--- Start of Main processing -----------------------------------+
026200200529      ** ¦                                                                ¦
026300200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
026400200529      ** ¦ executed at program activation.                                ¦
026500200529      ** ¦                                                                ¦
026600200529      ** +----------------------------------------------------------------+
026700200529
026800200529      ** If authorizations are not required
026900200529
027000200529     C     BNMMAU        IFEQ      'N'
027100200529     C                   EXSR      NOINPUT
027200200529     C                   ENDIF
027300200529
027400200529      **  Main processing
027500200529      **  Loop until CK/3 taken
027600200529
027700200529     C     *INKC         DOWEQ     False
027800200529     C                   EXSR      MAIN
027900200529     C                   ENDDO
028000200529      *
028100200529      * TERMINATE PROGRAM
028200200529      *
028300200529     C                   MOVE      True          *INLR
028400200529
028500200529      *****************************************************************
028600200529      /EJECT
028700200529      *****************************************************************
028800200529      * MAIN - MAIN PROCESSING
028900200529      *****************************************************************
029000200529     C     MAIN          BEGSR
029100200529
029200200529      ** Selection screen
029300200529
029400200529     C                   TIME                    DDTIME
029500200529     C                   WRITE     MMPBDLS0
029600200529     C                   WRITE     MMPBDLD1
029700200529     C                   WRITE     MMPBDLF1
029800200529     C                   READ      MMPBDLD1                               99
029900200529
030000200529      ** If CK/3 taken, bypass
030100200529
030200200529     C     *INKC         CABEQ     True          EMAIN
030300200529
030400200529      ** Validate screen input
030500200529
030600200529     C                   EXSR      VALSIN
030700200529
030800200529      ** If validation not OK, bypass
030900200529
031000200529     C     *IN50         CABEQ     True          EMAIN
031100200529
031200200529      ** Initialize count of authorizattions and failed authorizations
031300200529
031400200529     C                   Z-ADD     0             @CNTAU            6 0
031500200529     C                   Z-ADD     0             @CNTFL            6 0
031600200529
031700200529      ** Authorize all unauthorized loans and deposits
031800200529
031900200529     C                   EXSR      AUTHLDNI
032000200529
032100200529      ** Authorize all unauthorized NAs purchased
032200200529
032300200529     C                   EXSR      AUTHNASP
032400200529
032500200529      ** Authorize all unauthorized NAs sold
032600200529
032700200529     C                   EXSR      AUTHNASS
032800200529
032900200529      ** Authorize all unauthorized deal amendments
033000200529
033100200529     C                   EXSR      AUTHDEAM
033200200529
033300200529      ** Output authorized count message
033400200529
033500200529     C                   MOVEL     'MMM0266'     @MSGID
033600200529     C                   MOVE      @CNTAU        @ADAT1
033700200529     C                   MOVEL     DDFDLN        @ADAT2
033800200529     C                   MOVEL     DDLDLN        @ADAT3
033900200529     C                   CALL      'ZA0440'
034000200529     C                   PARM                    @MSGID
034100200529     C                   PARM                    @ADAT
034200200529
034300200529      ** Output failure count message
034400200529
034500200529     C     @CNTFL        IFNE      0
034600200529     C                   MOVEL     'MMM1048'     @MSGID
034700200529     C                   MOVE      @CNTFL        @FDT1
034800200529     C                   MOVEL     DDFDLN        @FDT2
034900200529     C                   MOVEL     DDLDLN        @FDT3
035000200529     C                   CALL      'ZA0440'
035100200529     C                   PARM                    @MSGID
035200200529     C                   PARM                    @FDTA
035300200529     C                   ENDIF
035400200529      *
035500200529     C     EMAIN         ENDSR
035600200529      *****************************************************************
035700200529      /EJECT
035800200529      *****************************************************************
035900200529      * AUTHLDNI - Authorize all unauthorized loans and deposits
036000200529      *****************************************************************
036100200529     C     AUTHLDNI      BEGSR
036200200529
036300200529      * Read Loans and Deposits
036400200529
036500200529     C                   MOVEL     NXTLDNIID     DDFRTN
036600200529     C                   MOVE      'Y'           @RDFWD
036700200529     C                   MOVE      *BLANKS       @RDBCK
036800200529     C                   EXSR      READLDNI
036900200529
037000200529      ** Do while not EOF
037100200529
037200200529     C     @ERRMS        DOWEQ     *BLANK
037300200529
037400200529      ** If deal is not deleted
037500200529
037600200529     C     HKDDLT        IFNE      'D'
037700200529
037800200529      ** Error in retrieve
037900200529
038000200529     C     Idx           IFNE      *ZERO
038100200529     C                   ADD       1             @CNTFL
038200200529     C                   MOVEL     @FTRED        DDFRTN
038300200529     C                   ELSE
038400200529
038500200529      ** Update Loan/Deposit
038600200529
038700200529     C                   EXSR      UPDTLDNI
038800200529     C                   ENDIF
038900200529     C                   ENDIF
039000200529
039100200529      * Read Loans and Deposits
039200200529
039300200529     C                   EXSR      READLDNI
039400200529     C                   ENDDO
039500200529      *
039600200529     C                   ENDSR
039700200529      *****************************************************************
039800200529      /EJECT
039900200529      *****************************************************************
040000200529      * AUTHNASP - Authorize all unauthorized NAs Purchased
040100200529      *****************************************************************
040200200529     C     AUTHNASP      BEGSR
040300200529
040400200529      * Read NAs Purchased
040500200529
040600200529     C                   MOVEL     NXTNASPID     DDFRTN
040700200529     C                   MOVE      'Y'           @RDFWD
040800200529     C                   MOVE      *BLANKS       @RDBCK
040900200529     C                   EXSR      READNASP
041000200529
041100200529      ** Do while not EOF
041200200529
041300200529     C     @ERRMS        DOWEQ     *BLANK
041400200529
041500200529      ** If deal is not deleted
041600200529
041700200529     C     HLDDLT        IFNE      'D'
041800200529
041900200529      ** Error in retrieve
042000200529
042100200529     C     Idx           IFNE      *ZERO
042200200529     C                   ADD       1             @CNTFL
042300200529     C                   MOVEL     @FTRED        DDFRTN
042400200529     C                   ELSE
042500200529
042600200529      ** Update NA Purchased
042700200529
042800200529     C                   EXSR      UPDTNASP
042900200529     C                   ENDIF
043000200529     C                   ENDIF
043100200529
043200200529      * Read NAs Purchased
043300200529
043400200529     C                   EXSR      READNASP
043500200529     C                   ENDDO
043600200529      *
043700200529     C                   ENDSR
043800200529      *****************************************************************
043900200529      /EJECT
044000200529      *****************************************************************
044100200529      * AUTHNASS - Authorize all unauthorized NAs Sold
044200200529      *****************************************************************
044300200529     C     AUTHNASS      BEGSR
044400200529
044500200529      * Read NAs Sold
044600200529
044700200529     C                   MOVEL     NXTNASSID     DDFRTN
044800200529     C                   MOVE      'Y'           @RDFWD
044900200529     C                   MOVE      *BLANKS       @RDBCK
045000200529     C                   EXSR      READNASS
045100200529
045200200529      ** Do while not EOF
045300200529
045400200529     C     @ERRMS        DOWEQ     *BLANK
045500200529
045600200529      ** If deal is not deleted
045700200529
045800200529     C     HMDDLT        IFNE      'D'
045900200529
046000200529      ** Error in retrieve
046100200529
046200200529     C     Idx           IFNE      *ZERO
046300200529     C                   ADD       1             @CNTFL
046400200529     C                   MOVEL     @FTRED        DDFRTN
046500200529     C                   ELSE
046600200529
046700200529      ** Update NA Sold
046800200529
046900200529     C                   EXSR      UPDTNASS
047000200529     C                   ENDIF
047100200529     C                   ENDIF
047200200529
047300200529      * Read NAs Sold
047400200529
047500200529     C                   EXSR      READNASS
047600200529     C                   ENDDO
047700200529      *
047800200529     C                   ENDSR
047900200529      *****************************************************************
048000200529      /EJECT
048100200529      *****************************************************************
048200200529      * AUTHDEAM - Authorize all unauthorized Deal Amendments
048300200529      *****************************************************************
048400200529     C     AUTHDEAM      BEGSR
048500200529
048600200529      * Read Deal amendments
048700200529
048800200529     C                   MOVEL     NXTDEAMID     DDFRTN
048900200529     C                   MOVE      'Y'           @RDFWD
049000200529     C                   MOVE      *BLANKS       @RDBCK
049100200529     C                   EXSR      READDEAM
049200200529
049300200529      ** Do while not EOF
049400200529
049500200529     C     @ERRMS        DOWEQ     *BLANK
049600200529
049700200529      ** If deal amendment is not deleted
049800200529
049900200529     C     HNDDLT        IFNE      'D'
050000200529
050100200529      ** Error in retrieve
050200200529
050300200529     C     Idx           IFNE      *ZERO
050400200529     C                   ADD       1             @CNTFL
050500200529     C                   MOVEL     @FTRED        DDFRTN
050600200529     C                   ELSE
050700200529
050800200529      ** Update Deal amendment
050900200529
051000200529     C                   EXSR      UPDTDEAM
051100200529     C                   ENDIF
051200200529     C                   ENDIF
051300200529
051400200529      * Read Deal amendments
051500200529
051600200529     C                   EXSR      READDEAM
051700200529     C                   ENDDO
051800200529      *
051900200529     C                   ENDSR
052000200529      *****************************************************************
052100200529      /EJECT
052200200529      *****************************************************************
052300200529      * UPDTLDNI - UPDATE LOAN/DEPOSIT DEAL
052400200529      *****************************************************************
052500200529     C     UPDTLDNI      BEGSR
052600200529     C/COPY WNCPYSRC,MMPBDLGC01
052700200529                                                                                              CDL033
052800200529     C                   EVAL      PBFRCD = *BLANKS                                           CDL033
052900200529     C                   EVAL      PAFRCD = *BLANKS                                           CDL033
053000200529                                                                                              CDL033
053100200529     C     CDL033        IFEQ      'Y'                                                        CDL033
053200200529     C     HKMTYP        IFEQ      'CF'                                                       CDL033
053300200529     C     HKMTYP        OREQ      'CI'                                                       CDL033
053400200529     C     HKMTYP        OREQ      'TI'                                                       CDL033
053500200529     C     HKMTYP        OREQ      'TD'                                                       CDL033
053600200529     C     HKMTYP        OREQ      'IP'                                                       CDL033
053700200529     C     HKMTYP        OREQ      'IT'                                                       CDL033
053800200529     C                   EVAL      PBFRCD = DSFRCD                                            CDL033
053900200529     C                   EVAL      PAFRCD = DSFRCD                                            CDL033
054000200529     C                   ENDIF                                                                CDL033
054100200529     C                   ENDIF                                                                CDL033
054200200529      *
054300200529      * UPDATE VALID DEAL: LAST ACTION CODE
054400200529      *
054500200529     C                   MOVEL     DDACTN        HKLACT
054600200529      *
054700200529      * MONEY MARKET UPDATES
054800200529      *
054900200529     C                   CALLB     'MMLDNIUPM'
055000200529     C                   PARM      *BLANK        @RTCD             7
055100200529     C                   PARM                    DELDFilFmt
055200200529     C                   PARM                    #FPAYF                                       CDL033
055300200529     C                   PARM                    #FRECF                                       CDL033
055400200529      ** FRCD Issued Extension details before update                                          CDL033
055500200529     C                   PARM                    PBFRCD                                       CDL033
055600200529      ** FRCD Issued Extension details after update                                           CDL033
055700200529     C                   PARM                    PAFRCD                                       CDL033
055800200529     C/COPY WNCPYSRC,MMPBDLGC02
055900200529      *
056000200529      * DEALS UPDATES
056100200529      *
056200200529     C     @RTCD         IFEQ      *BLANK
056300200529     C                   CALLB     'MMLDNIUPD'
056400200529     C                   PARM                    @RTCD
056500200529     C                   PARM                    DELDFilFmt
056600200529     C                   ENDIF
056700200529      *
056800200529      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
056900200529      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
057000200529      *
057100200529     C     @RTCD         IFNE      *BLANK
057200200529     C                   ROLBK
057300200529     C                   EXSR      *PSSR
057400200529     C                   ELSE
057500200529     C                   COMMIT
057600200529     C/COPY WNCPYSRC,MMPBDLGC09
057700200529     C                   ADD       1             @CNTAU
057800200529     C                   ENDIF
057900200529      *
058000200529     C                   ENDSR
058100200529      *****************************************************************
058200200529      /EJECT
058300200529      *****************************************************************
058400200529      * UPDTNASP - UPDATE NAS PURCHASED
058500200529      *****************************************************************
058600200529     C     UPDTNASP      BEGSR
058700200529      *
058800200529      * UPDATE VALID DEAL: LAST ACTION CODE
058900200529      *
059000200529     C                   MOVEL     DDACTN        HLLACT
059100200529      *
059200200529      * MONEY MARKET UPDATES
059300200529      *
059400200529     C                   CALLB     'MMNASPUPM'
059500200529     C                   PARM      *BLANK        @RTCD             7
059600200529     C                   PARM                    DENBFilFmt
059700200529      *
059800200529      * DEALS UPDATES
059900200529      *
060000200529     C     @RTCD         IFEQ      *BLANK
060100200529     C                   CALLB     'MMNASPUPD'
060200200529     C                   PARM                    @RTCD
060300200529     C                   PARM                    DENBFilFmt
060400200529     C                   ENDIF
060500200529      *
060600200529      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
060700200529      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
060800200529      *
060900200529     C     @RTCD         IFNE      *BLANK
061000200529     C                   ROLBK
061100200529     C                   EXSR      *PSSR
061200200529     C                   ELSE
061300200529     C                   COMMIT
061400200529     C                   ADD       1             @CNTAU
061500200529     C                   ENDIF
061600200529      *
061700200529     C                   ENDSR
061800200529      *****************************************************************
061900200529      /EJECT
062000200529      *****************************************************************
062100200529      * UPDTNASS - UPDATE NAS SOLD
062200200529      *****************************************************************
062300200529     C     UPDTNASS      BEGSR
062400200529      *
062500200529      * UPDATE VALID DEAL: LAST ACTION CODE
062600200529      *
062700200529     C                   MOVEL     DDACTN        HMLACT
062800200529      *
062900200529      * MONEY MARKET UPDATES
063000200529      *
063100200529     C                   CALLB     'MMNASSUPM'
063200200529     C                   PARM      *BLANK        @RTCD             7
063300200529     C                   PARM                    DENSFilFmt
063400200529      *
063500200529      * DEALS UPDATES
063600200529      *
063700200529     C     @RTCD         IFEQ      *BLANK
063800200529     C                   CALLB     'MMNASSUPD'
063900200529     C                   PARM                    @RTCD
064000200529     C                   PARM                    DENSFilFmt
064100200529     C                   ENDIF
064200200529      *
064300200529      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
064400200529      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
064500200529      *
064600200529     C     @RTCD         IFNE      *BLANK
064700200529     C                   ROLBK
064800200529     C                   EXSR      *PSSR
064900200529     C                   ELSE
065000200529     C                   COMMIT
065100200529     C                   ADD       1             @CNTAU
065200200529     C                   ENDIF
065300200529      *
065400200529     C                   ENDSR
065500200529      *****************************************************************
065600200529      /EJECT
065700200529      *****************************************************************
065800200529      * UPDTDEAM - UPDATE DEAL AMENDMENTS
065900200529      *****************************************************************
066000200529     C     UPDTDEAM      BEGSR
066100200529      *
066200200529      * UPDATE VALID DEAL AMENDMENT: LAST ACTION CODE
066300200529      *
066400200529     C                   MOVEL     DDACTN        HNLACT
066500200529      *
066600200529      * MONEY MARKET UPDATES
066700200529      *
066800200529     C                   CALLB     'MMDEAMUPM'
066900200529     C                   PARM      *BLANK        @RTCD             7
067000200529     C                   PARM                    DEAMFilFmt
067100200529      *
067200200529      * DEALS UPDATES
067300200529      *
067400200529     C     @RTCD         IFEQ      *BLANK
067500200529     C                   CALLB     'MMDEAMUPD'
067600200529     C                   PARM                    @RTCD
067700200529     C                   PARM                    DEAMFilFmt
067800200529     C                   ENDIF
067900200529      *
068000200529      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
068100200529      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
068200200529      *
068300200529     C     @RTCD         IFNE      *BLANK
068400200529     C                   ROLBK
068500200529     C                   EXSR      *PSSR
068600200529     C                   ELSE
068700200529     C                   COMMIT
068800200529     C                   ADD       1             @CNTAU
068900200529     C                   ENDIF
069000200529      *
069100200529     C                   ENDSR
069200200529      *****************************************************************
069300200529      /EJECT
069400200529      *****************************************************************
069500200529      * READLDNI - READ THROUGH LOANS & DEPOSITS
069600200529      *****************************************************************
069700200529     C     READLDNI      BEGSR
069800200529      *
069900200529     C/COPY WNCPYSRC,MMPBDLGC04
070000200529     C                   CALLB     'MMLDNIRED'
070100200529      *
070200200529      * INPUT PARAMETERS
070300200529      *
070400200529      * RETURN CODE
070500200529     C                   PARM      *BLANK        RetCodeOut
070600200529      *
070700200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
070800200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
070900200529      *
071000200529     C                   PARM      '*FRONT'      @@MODE            6
071100200529      *
071200200529      * ACTION CODE
071300200529     C                   PARM      'X'           DDACTN            1
071400200529      *
071500200529      * DEAL NUMBER POINTER
071600200529     C                   PARM                    DDDLNO            6
071700200529      *
071800200529      * DEAL Front Office Pointer
071900200529     C                   PARM                    DDFRTN           20
072000200529      *
072100200529      * READ FORWARDS
072200200529     C                   PARM                    @RDFWD            1
072300200529      *
072400200529      * READ BACKWARDS
072500200529     C                   PARM                    @RDBCK            1
072600200529      *
072700200529      * OUTPUT PARAMETERS
072800200529      *
072900200529      * ERROR MESSAGE
073000200529     C                   PARM      *BLANK        @ERRMS            7
073100200529      *
073200200529      * DEAL NUMBER READ
073300200529     C                   PARM      *BLANK        @DLRED            6
073400200529      *
073500200529      * Front Office ID READ
073600200529     C                   PARM      *BLANK        @FTRED           20
073700200529      *
073800200529      * If no deal read, treat like EOF
073900200529      *
074000200529     C     @FTRED        IFEQ      *BLANK
074100200529     C                   MOVEL     '*EOF'        @ERRMS
074200200529     C                   ENDIF
074300200529      *
074400200529      * If error message returned from read, then it is EOF
074500200529      *
074600200529     C     @ERRMS        CABNE     *BLANK        EREADLDNI
074700200529      *
074800200529      * Check whether past last deal number
074900200529      *
075000200529     C     @FTRED        IFGT      DDLDLN
075100200529     C                   MOVEL     '*EOF'        @ERRMS
075200200529      *
075300200529      * Retrieve deal details
075400200529      *
075500200529     C                   ELSE
075600200529     C                   MOVEL     @FTRED        FOTRID
075700200529     C                   EXSR      RTVLDNI
075800200529     C                   ENDIF
075900200529     C/COPY WNCPYSRC,MMPBDLGC05
076000200529      *
076100200529     C     EREADLDNI     ENDSR
076200200529      *****************************************************************
076300200529      /EJECT
076400200529      *****************************************************************
076500200529      * READNASP - READ THROUGH NAS PURCHASED
076600200529      *****************************************************************
076700200529     C     READNASP      BEGSR
076800200529      *
076900200529     C                   CALLB     'MMNASPRED'
077000200529      *
077100200529      * INPUT PARAMETERS
077200200529      *
077300200529      * RETURN CODE
077400200529     C                   PARM      *BLANK        RetCodeOut
077500200529      *
077600200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
077700200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
077800200529      *
077900200529     C                   PARM      '*FRONT'      @@MODE            6
078000200529      *
078100200529      * ACTION CODE
078200200529     C                   PARM      'X'           DDACTN            1
078300200529      *
078400200529      * DEAL NUMBER POINTER
078500200529     C                   PARM                    DDDLNO            6
078600200529      *
078700200529      * DEAL Front Office Pointer
078800200529     C                   PARM                    DDFRTN           20
078900200529      *
079000200529      * READ FORWARDS
079100200529     C                   PARM                    @RDFWD            1
079200200529      *
079300200529      * READ BACKWARDS
079400200529     C                   PARM                    @RDBCK            1
079500200529      *
079600200529      * OUTPUT PARAMETERS
079700200529      *
079800200529      * ERROR MESSAGE
079900200529     C                   PARM      *BLANK        @ERRMS            7
080000200529      *
080100200529      * DEAL NUMBER READ
080200200529     C                   PARM      *BLANK        @DLRED            6
080300200529      *
080400200529      * Front Office ID READ
080500200529     C                   PARM      *BLANK        @FTRED           20
080600200529      *
080700200529      * If no deal read, treat like EOF
080800200529      *
080900200529     C     @FTRED        IFEQ      *BLANK
081000200529     C                   MOVEL     '*EOF'        @ERRMS
081100200529     C                   ENDIF
081200200529      *
081300200529      * If error message returned from read, then it is EOF
081400200529      *
081500200529     C     @ERRMS        CABNE     *BLANK        EREADNASP
081600200529      *
081700200529      * Check whether past last deal number
081800200529      *
081900200529     C     @FTRED        IFGT      DDLDLN
082000200529     C                   MOVEL     '*EOF'        @ERRMS
082100200529      *
082200200529      * Retrieve deal details
082300200529      *
082400200529     C                   ELSE
082500200529     C                   MOVEL     @FTRED        FOTRID
082600200529     C                   EXSR      RTVNASP
082700200529     C                   ENDIF
082800200529      *
082900200529     C     EREADNASP     ENDSR
083000200529      *****************************************************************
083100200529      /EJECT
083200200529      *****************************************************************
083300200529      * READNASS - READ THROUGH NAS SOLD
083400200529      *****************************************************************
083500200529     C     READNASS      BEGSR
083600200529      *
083700200529     C                   CALLB     'MMNASSRED'
083800200529      *
083900200529      * INPUT PARAMETERS
084000200529      *
084100200529      * RETURN CODE
084200200529     C                   PARM      *BLANK        RetCodeOut
084300200529      *
084400200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
084500200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
084600200529      *
084700200529     C                   PARM      '*FRONT'      @@MODE            6
084800200529      *
084900200529      * ACTION CODE
085000200529     C                   PARM      'X'           DDACTN            1
085100200529      *
085200200529      * DEAL NUMBER POINTER
085300200529     C                   PARM                    DDDLNO            6
085400200529      *
085500200529      * DEAL Front Office Pointer
085600200529     C                   PARM                    DDFRTN           20
085700200529      *
085800200529      * READ FORWARDS
085900200529     C                   PARM                    @RDFWD            1
086000200529      *
086100200529      * READ BACKWARDS
086200200529     C                   PARM                    @RDBCK            1
086300200529      *
086400200529      * OUTPUT PARAMETERS
086500200529      *
086600200529      * ERROR MESSAGE
086700200529     C                   PARM      *BLANK        @ERRMS            7
086800200529      *
086900200529      * DEAL NUMBER READ
087000200529     C                   PARM      *BLANK        @DLRED            6
087100200529      *
087200200529      * Front Office ID READ
087300200529     C                   PARM      *BLANK        @FTRED           20
087400200529      *
087500200529      * If no deal read, treat like EOF
087600200529      *
087700200529     C     @FTRED        IFEQ      *BLANK
087800200529     C                   MOVEL     '*EOF'        @ERRMS
087900200529     C                   ENDIF
088000200529      *
088100200529      * If error message returned from read, then it is EOF
088200200529      *
088300200529     C     @ERRMS        CABNE     *BLANK        EREADNASS
088400200529      *
088500200529      * Check whether past last deal number
088600200529      *
088700200529     C     @FTRED        IFGT      DDLDLN
088800200529     C                   MOVEL     '*EOF'        @ERRMS
088900200529      *
089000200529      * Retrieve deal details
089100200529      *
089200200529     C                   ELSE
089300200529     C                   MOVEL     @FTRED        FOTRID
089400200529     C                   EXSR      RTVNASS
089500200529     C                   ENDIF
089600200529      *
089700200529     C     EREADNASS     ENDSR
089800200529      *****************************************************************
089900200529      /EJECT
090000200529      *****************************************************************
090100200529      * READDEAM - READ THROUGH DEAL AMENDMENTS
090200200529      *****************************************************************
090300200529     C     READDEAM      BEGSR
090400200529      *
090500200529     C/COPY WNCPYSRC,MMPBDLGC06
090600200529     C                   CALLB     'MMDEAMRED'
090700200529      *
090800200529      * INPUT PARAMETERS
090900200529      *
091000200529      * RETURN CODE
091100200529     C                   PARM      *BLANK        RetCodeOut
091200200529      *
091300200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
091400200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
091500200529      *
091600200529     C                   PARM      '*FRONT'      @@MODE            6
091700200529      *
091800200529      * ACTION CODE
091900200529     C                   PARM      'X'           DDACTN            1
092000200529      *
092100200529      * DEAL NUMBER POINTER
092200200529     C                   PARM                    DDDLNO            6
092300200529      *
092400200529      * DEAL Front Office Pointer
092500200529     C                   PARM                    DDFRTN           20
092600200529     C                   PARM                    DDVDAT            6
092700200529     C                   PARM                    DDDS38            3
092800200529      *
092900200529      * READ FORWARDS
093000200529     C                   PARM                    @RDFWD            1
093100200529      *
093200200529      * READ BACKWARDS
093300200529     C                   PARM                    @RDBCK            1
093400200529      *
093500200529      * OUTPUT PARAMETERS
093600200529      *
093700200529      * ERROR MESSAGE
093800200529     C                   PARM      *BLANK        @ERRMS            7
093900200529      *
094000200529      * DEAL NUMBER READ
094100200529     C                   PARM      *BLANK        @DLRED            6
094200200529      *
094300200529      * Front Office ID READ
094400200529     C                   PARM      *BLANK        @FTRED           20
094500200529      *
094600200529      * Front Office Associated ID READ
094700200529     C                   PARM      *BLANK        @FARED           20
094800200529      *
094900200529      * VALUE DATE READ
095000200529     C                   PARM      *BLANK        @VDRED            6
095100200529      *
095200200529      * SEQUENCE NUMBER READ
095300200529     C                   PARM      *BLANK        @SQRED            3
095400200529      *
095500200529      * If no deal amendment read, treat like EOF
095600200529      *
095700200529     C     @FTRED        IFEQ      *BLANK
095800200529     C                   MOVEL     '*EOF'        @ERRMS
095900200529     C                   ENDIF
096000200529      *
096100200529      * If error message returned from read, then it is EOF
096200200529      *
096300200529     C     @ERRMS        CABNE     *BLANK        EREADDEAM
096400200529      *
096500200529      * Check whether past last deal number
096600200529      *
096700200529     C     @FTRED        IFGT      DDLDLN
096800200529     C                   MOVEL     '*EOF'        @ERRMS
096900200529      *
097000200529      * Retrieve deal amendment details
097100200529      *
097200200529     C                   ELSE
097300200529     C                   MOVEL     @FTRED        FOTRID
097400200529     C                   MOVEL     @FARED        FOASID
097500200529     C                   MOVEL     @VDRED        DDVDAT
097600200529     C                   MOVEL     @SQRED        DDDS38
097700200529     C                   EXSR      RTVDEAM
097800200529     C                   ENDIF
097900200529     C/COPY WNCPYSRC,MMPBDLGC07
098000200529      *
098100200529     C     EREADDEAM     ENDSR
098200200529      *****************************************************************
098300200529      /EJECT
098400200529      *****************************************************************
098500200529      * RTVLDNI - RETRIEVE LOAN & DEPOSIT DEAL
098600200529      *****************************************************************
098700200529     C     RTVLDNI       BEGSR
098800200529      *
098900200529      * RETRIEVE DEAL
099000200529      *
099100200529     C                   CALLB     'MMLDNIRTV'
099200200529      *
099300200529      * INPUTS
099400200529      *
099500200529      * Return code
099600200529     C                   PARM      *BLANK        RetCodeOut
099700200529      *
099800200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
099900200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
100000200529      *
100100200529     C                   PARM      '*FRONT'      @@MODE            6
100200200529      *
100300200529      * Response mode
100400200529     C                   PARM      'S'           @@RSMD            1
100500200529      *
100600200529      * Action Code
100700200529     C                   PARM                    DDACTN
100800200529      *
100900200529      * Front Office Transaction ID
101000200529     C                   PARM                    FOTRID           20
101100200529      *
101200200529      * Front Office Associated Transaction Id
101300200529     C                   PARM                    FOASID           20
101400200529      *
101500200529      * (Midas) Deal Number
101600200529     C                   PARM                    DDDLNO            6
101700200529      *                                                                                       196380
101800200529      * (Midas) Depot Movement Reference                                                      196380
101900200529     C                   PARM                    DDDDMR            6                          196380
102000200529      *
102100200529      * (Midas) Associated Deal Number
102200200529     C                   PARM                    DDDADN            6
102300200529      *
102400200529      * Booking branch
102500200529     C                   PARM                    DDBRCA            3
102600200529      *                                                                                       CAP067
102700200529      * REPO Flag                                                                             CAP067
102800200529     C                   PARM      'N'           RepoFlag          1                          CAP067
102900200529      *
103000200529      * OUTPUTS
103100200529      *
103200200529      * Deal in file format
103300200529     C                   PARM                    DELDFilFmt
103400200529      *                                                                                     AR701789
103500200529     C                   PARM                    ACTRJ             1                        AR701789
103600200529      *
103700200529      * OK - Action code
103800200529     C                   PARM      *BLANK        OKACTN            1
103900200529      *
104000200529      * OK - Deal Number
104100200529     C                   PARM      *BLANK        OKDLNO            1
104200200529      *
104300200529      * OK - Booking branch
104400200529     C                   PARM      *BLANK        OKBRCA            1
104500200529      ** Blocked/Unblock Action                                                              BUG2804
104600200529     C                   PARM                    BUACT             1                         BUG2804
104700200529      *
104800200529      * Error fields/message IDs/message data (arrays) from/to caller
104900200529     C                   PARM                    FldNameArr
105000200529     C                   PARM                    MsgIdArr
105100200529     C                   PARM                    MsgDtaArr
105200200529      *
105300200529      * Array index (3P0) from/to caller
105400200529     C                   PARM      *ZERO         Idx               3 0
105500200529                                                                                              CAS004
105600200529      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
105700200529                                                                                              CAS004
105800200529     C                   PARM                    WFldNamArr                                   CAS004
105900200529     C                   PARM                    WMsgIdArr                                    CAS004
106000200529     C                   PARM                    WMsgDtaArr                                   CAS004
106100200529                                                                                              CAS004
106200200529      ** Array index (3P0) from/to caller                                                     CAS004
106300200529                                                                                              CAS004
106400200529     C                   PARM                    WIdx                                         CAS004
106500200529     C/COPY WNCPYSRC,MMPBDLGC10
106600200529      *
106700200529     C                   ENDSR
106800200529      *****************************************************************
106900200529      /EJECT
107000200529      *****************************************************************
107100200529      * RTVNASP - RETRIEVE NAS PURCHASED DEAL
107200200529      *****************************************************************
107300200529     C     RTVNASP       BEGSR
107400200529      *
107500200529      * RETRIEVE DEAL
107600200529      *
107700200529     C                   CALLB     'MMNASPRTV'
107800200529      *
107900200529      * INPUTS
108000200529      *
108100200529      * Return code
108200200529     C                   PARM      *BLANK        RetCodeOut
108300200529      *
108400200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
108500200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
108600200529      *
108700200529     C                   PARM      '*FRONT'      @@MODE            6
108800200529      *
108900200529      * Response mode
109000200529     C                   PARM      'S'           @@RSMD            1
109100200529      *
109200200529      * Action Code
109300200529     C                   PARM                    DDACTN
109400200529      *
109500200529      * Front Office Transaction ID
109600200529     C                   PARM                    FOTRID           20
109700200529      *
109800200529      * (Midas) Deal Number
109900200529     C                   PARM                    DDDLNO
110000200529      *
110100200529      * Booking branch
110200200529     C                   PARM                    DDBRCA
110300200529      *
110400200529      * OUTPUTS
110500200529      *
110600200529      * Deal in file format
110700200529     C                   PARM                    DENBFilFmt
110800200529      *
110900200529      * OK - Action code
111000200529     C                   PARM      *BLANK        OKACTN
111100200529      *
111200200529      * OK - Deal Number
111300200529     C                   PARM      *BLANK        OKDLNO
111400200529      *
111500200529      * OK - Booking branch
111600200529     C                   PARM      *BLANK        OKBRCA
111700200529      *
111800200529      * Error fields/message IDs/message data (arrays) from/to caller
111900200529     C                   PARM                    FldNameArr
112000200529     C                   PARM                    MsgIdArr
112100200529     C                   PARM                    MsgDtaArr
112200200529      *
112300200529      * Array index (3P0) from/to caller
112400200529     C                   PARM      *ZERO         Idx
112500200529                                                                                              CAS004
112600200529      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
112700200529                                                                                              CAS004
112800200529     C                   PARM                    WFldNamArr                                   CAS004
112900200529     C                   PARM                    WMsgIdArr                                    CAS004
113000200529     C                   PARM                    WMsgDtaArr                                   CAS004
113100200529                                                                                              CAS004
113200200529      ** Array index (3P0) from/to caller                                                     CAS004
113300200529                                                                                              CAS004
113400200529     C                   PARM                    WIdx                                         CAS004
113500200529      *
113600200529     C                   ENDSR
113700200529      *****************************************************************
113800200529      /EJECT
113900200529      *****************************************************************
114000200529      * RTVNASS - RETRIEVE NAS SOLD DEAL
114100200529      *****************************************************************
114200200529     C     RTVNASS       BEGSR
114300200529      *
114400200529      * RETRIEVE DEAL
114500200529      *
114600200529     C                   CALLB     'MMNASSRTV'
114700200529      *
114800200529      * INPUTS
114900200529      *
115000200529      * Return code
115100200529     C                   PARM      *BLANK        RetCodeOut
115200200529      *
115300200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
115400200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
115500200529      *
115600200529     C                   PARM      '*FRONT'      @@MODE            6
115700200529      *
115800200529      * Response mode
115900200529     C                   PARM      'S'           @@RSMD            1
116000200529      *
116100200529      * Action Code
116200200529     C                   PARM                    DDACTN
116300200529      *
116400200529      * Front Office Transaction ID
116500200529     C                   PARM                    FOTRID           20
116600200529      *
116700200529      * Front Office Associated Transaction Id
116800200529     C                   PARM                    FOASID           20
116900200529      *
117000200529      * (Midas) Deal Number
117100200529     C                   PARM                    DDDLNO
117200200529      *
117300200529      * (Midas) Associated Deal Number
117400200529     C                   PARM                    DDDADN
117500200529      *
117600200529      * OUTPUTS
117700200529      *
117800200529      * Deal in file format
117900200529     C                   PARM                    DENSFilFmt
118000200529      *
118100200529      * OK - Action code
118200200529     C                   PARM      *BLANK        OKACTN
118300200529      *
118400200529      * OK - Deal Number
118500200529     C                   PARM      *BLANK        OKDLNO
118600200529      *
118700200529      * Error fields/message IDs/message data (arrays) from/to caller
118800200529     C                   PARM                    FldNameArr
118900200529     C                   PARM                    MsgIdArr
119000200529     C                   PARM                    MsgDtaArr
119100200529      *
119200200529      * Array index (3P0) from/to caller
119300200529     C                   PARM      *ZERO         Idx
119400200529      *
119500200529     C                   ENDSR
119600200529      *****************************************************************
119700200529      /EJECT
119800200529      *****************************************************************
119900200529      * RTVDEAM - RETRIEVE DEAL AMENDMENT
120000200529      *****************************************************************
120100200529     C     RTVDEAM       BEGSR
120200200529      *
120300200529      * RETRIEVE DEAL AMENDMENT
120400200529      *
120500200529     C                   CALLB     'MMDEAMRTV'
120600200529      *
120700200529      * INPUTS
120800200529      *
120900200529      * Return code
121000200529     C                   PARM      *BLANK        RetCodeOut
121100200529      *
121200200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
121300200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
121400200529      *
121500200529     C                   PARM      '*FRONT'      @@MODE            6
121600200529      *
121700200529      * Response mode
121800200529     C                   PARM      'S'           @@RSMD            1
121900200529      *
122000200529      * Action Code
122100200529     C                   PARM                    DDACTN
122200200529      *
122300200529      * Front Office Transaction ID
122400200529     C                   PARM                    FOTRID           20
122500200529      *
122600200529      * Front Office Associated Transaction Id
122700200529     C                   PARM                    FOASID           20
122800200529      *
122900200529      * (Midas) Deal Number
123000200529     C                   PARM                    DDDLNO
123100200529      *
123200200529      * Value Date
123300200529     C                   PARM                    DDVDAT            6
123400200529      *
123500200529      * Sequence Number
123600200529     C                   PARM                    DDDS38            3
123700200529      *
123800200529      * Deal Amendment Amount
123900200529     C                   PARM                    DDAMNP           15
124000200529      *
124100200529      * Deal Amendment Type
124200200529     C                   PARM                    DDMTYP            2
124300200529      * Action Code (Reversal transaction)                                                    260173
124400200529     C                   PARM      *BLANK        @ACTRV            1                          260173
124500200529      *
124600200529      * OUTPUTS
124700200529      *
124800200529      * Deal amendment in file format
124900200529     C                   PARM                    DEAMFilFmt
125000200529      *
125100200529      * OK - Action code
125200200529     C                   PARM      *BLANK        OKACTN
125300200529      *
125400200529      * OK - Deal Number
125500200529     C                   PARM      *BLANK        OKDLNO
125600200529      *
125700200529      * OK - Value Date
125800200529     C                   PARM      *BLANK        OKVDAT            1
125900200529      *
126000200529      * OK - Sequence Number
126100200529     C                   PARM      *BLANK        OKDS38            1
126200200529      *
126300200529      * Error fields/message IDs/message data (arrays) from/to caller
126400200529     C                   PARM                    FldNameArr
126500200529     C                   PARM                    MsgIdArr
126600200529     C                   PARM                    MsgDtaArr
126700200529      *
126800200529      * Array index (3P0) from/to caller
126900200529     C                   PARM      *ZERO         Idx
127000200529      *
127100200529     C                   ENDSR
127200200529      *****************************************************************
127300200529      /EJECT
127400200529      *****************************************************************
127500200529      * VALSIN   - VALIDATE SCREEN INPUT
127600200529      *****************************************************************
127700200529     C     VALSIN        BEGSR
127800200529      *
127900200529      ** Clear the message queue & init error indicators
128000200529      *
128100200529     C                   CALL      'ZA0250'
128200200529     C                   MOVE      '0'           *IN50
128300200529     C                   MOVE      '0'           *IN10
128400200529     C                   MOVE      '0'           *IN11
128500200529      *
128600200529      ** First Front Office Id must be entered
128700200529      *
128800200529     C     DDFDLN        IFEQ      *BLANKS
128900200529     C                   MOVE      True          *IN50
129000200529     C                   MOVE      True          *IN10
129100200529     C                   ENDIF
129200200529      *
129300200529      ** Second Front Office Id must be enterd
129400200529      *
129500200529     C     DDLDLN        IFEQ      *BLANKS
129600200529     C                   MOVE      True          *IN50
129700200529     C                   MOVE      True          *IN11
129800200529     C                   ENDIF
129900200529      *
130000200529     C     DDFDLN        IFEQ      *BLANKS
130100200529     C     DDLDLN        OREQ      *BLANKS
130200200529     C                   MOVEL     'FXM0500'     @MSGID
130300200529     C                   CALL      'ZA0240'
130400200529     C                   PARM                    @MSGID
130500200529     C                   GOTO      EVALSI
130600200529     C                   ENDIF
130700200529      *
130800200529      ** Second Id must be less than first Front Office Id
130900200529      *
131000200529     C     DDLDLN        IFLT      DDFDLN
131100200529     C                   MOVEL     'FXM0501'     @MSGID
131200200529     C                   CALL      'ZA0240'
131300200529     C                   PARM                    @MSGID
131400200529     C                   MOVE      True          *IN50
131500200529     C                   MOVE      True          *IN11
131600200529     C                   GOTO      EVALSI
131700200529     C                   ENDIF
131800200529      *
131900200529      ** Look for at least one deal
132000200529      *
132100200529     C                   MOVEL     DDFDLN        DDFRTN
132200200529     C                   MOVE      *BLANKS       @RDFWD
132300200529     C                   MOVE      'Y'           @RDBCK
132400200529     C                   EXSR      READLDNI
132500200529      *
132600200529     C                   MOVEL     @FTRED        NXTLDNIID        20
132700200529     C                   MOVEL     NXTLDNIID     DDFRTN
132800200529     C                   MOVE      'Y'           @RDFWD
132900200529     C                   MOVE      *BLANKS       @RDBCK
133000200529     C                   EXSR      READLDNI
133100200529      *
133200200529     C     @ERRMS        IFNE      *BLANK
133300200529     C                   MOVEL     DDFDLN        DDFRTN
133400200529     C                   MOVE      *BLANKS       @RDFWD
133500200529     C                   MOVE      'Y'           @RDBCK
133600200529     C                   EXSR      READNASP
133700200529      *
133800200529     C                   MOVEL     @FTRED        NXTNASPID        20
133900200529     C                   MOVEL     NXTNASPID     DDFRTN
134000200529     C                   MOVE      'Y'           @RDFWD
134100200529     C                   MOVE      *BLANKS       @RDBCK
134200200529     C                   EXSR      READNASP
134300200529      *
134400200529     C     @ERRMS        IFNE      *BLANK
134500200529     C                   MOVEL     DDFDLN        DDFRTN
134600200529     C                   MOVE      *BLANKS       @RDFWD
134700200529     C                   MOVE      'Y'           @RDBCK
134800200529     C                   EXSR      READNASS
134900200529      *
135000200529     C                   MOVEL     @FTRED        NXTNASSID        20
135100200529     C                   MOVEL     NXTNASSID     DDFRTN
135200200529     C                   MOVE      'Y'           @RDFWD
135300200529     C                   MOVE      *BLANKS       @RDBCK
135400200529     C                   EXSR      READNASS
135500200529      *
135600200529     C     @ERRMS        IFNE      *BLANK
135700200529     C                   MOVEL     DDFDLN        DDFRTN
135800200529     C                   MOVE      *BLANKS       @RDFWD
135900200529     C                   MOVE      'Y'           @RDBCK
136000200529     C                   EXSR      READDEAM
136100200529      *
136200200529     C                   MOVEL     @FTRED        NXTDEAMID        20
136300200529     C                   MOVEL     NXTDEAMID     DDFRTN
136400200529     C                   MOVE      'Y'           @RDFWD
136500200529     C                   MOVE      *BLANKS       @RDBCK
136600200529     C                   EXSR      READDEAM
136700200529     C                   ENDIF
136800200529     C                   ENDIF
136900200529     C                   ENDIF
137000200529      *
137100200529      ** Error if not at least one record to authorize
137200200529      *
137300200529     C     @ERRMS        IFNE      *BLANK
137400200529     C                   MOVEL     'MMM1029'     @MSGID
137500200529     C                   CALL      'ZA0240'
137600200529     C                   PARM                    @MSGID
137700200529     C                   MOVE      True          *IN50
137800200529     C                   MOVE      True          *IN10
137900200529     C                   ENDIF
138000200529      *
138100200529     C     EVALSI        ENDSR
138200200529      *****************************************************************
138300200529      /EJECT
138400200529      *****************************************************************
138500200529      * NOINPUT - NO INPUT SCREEN
138600200529      *****************************************************************
138700200529     C     NOINPUT       BEGSR
138800200529      *
138900200529      ** Write message, present screen and end program
139000200529      *
139100200529     C                   MOVEL     'MMM0159'     @MSGID           10
139200200529     C                   CALL      'ZA0240'
139300200529     C                   PARM                    @MSGID
139400200529
139500200529     C                   MOVE      '1'           *IN13
139600200529     C                   TIME                    DDTIME
139700200529     C                   WRITE     MMPBDLS0
139800200529     C                   WRITE     MMPBDLD1
139900200529     C                   WRITE     MMPBDLF1
140000200529     C                   READ      MMPBDLD1                               99
140100200529
140200200529     C                   SETON                                        LR
140300200529     C                   RETURN
140400200529
140500200529     C                   ENDSR
140600200529      *****************************************************************
140700200529      /EJECT
140800200529      *****************************************************************
140900200529      * *INZSR - INITIAL PROCESSING
141000200529      *****************************************************************
141100200529     C     *INZSR        BEGSR
141200200529      *
141300200529      ** Initialize program name
141400200529      *
141500200529     C                   MOVEL     'MMPBDLRAT'   DBPGM
141600200529      *
141700200529      ** Set up subfile message queue information
141800200529      *
141900200529     C                   MOVEL     '*'           DDPGMQ
142000200529     C                   MOVE      True          *IN40
142100200529      *
142200200529      ** Move workstation ID to screen field.
142300200529      *
142400200529     C                   MOVEL     PsJobName     DDWID
142500200529      *
142600200529      ** Get DEALING ICD
142700200529      *
142800200529     C**********         CALLB     'AODEALR0'                                                 CGL029
142900200529     C                   CALLB     'AODEALR1'                                                 CGL029
143000200529     C                   PARM      '*DBERR '     @RTCD             7
143100200529     C                   PARM      '*FIRST '     @OPTN             7
143200200529     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
143300200529     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
143400200529      *
143500200529      * DATABASE ERROR
143600200529      *
143700200529     C     @RTCD         IFNE      *BLANKS
143800200529     C                   MOVEL     'SDDEALPD'    DBFILE                         ************
143900200529     C                   MOVEL     '900'         DBASE                          * DBERR 900*
144000200529     C                   MOVEL     @OPTN         DBKEY                          ************
144100200529     C                   EXSR      *PSSR
144200200529     C                   ENDIF
144300200529      *                                                                                       CDL033
144400200529      ** Access SAR details file to determine if CDL033                                       CDL033
144500200529      ** (Floating Rate CD Issued) is on.                                                     CDL033
144600200529      *                                                                                       CDL033
144700200529     C                   CALLB     'AOSARDR0'                                                 CDL033
144800200529     C                   PARM      *BLANKS       PRTCD                                        CDL033
144900200529     C                   PARM      '*VERIFY'     POPTN                                        CDL033
145000200529     C                   PARM      'CDL033'      PSARD                                        CDL033
145100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
145200200529      *                                                                                       CDL033
145300200529     C                   MOVE      'N'           CDL033            1                          CDL033
145400200529     C                   IF        PRTCD  = *BLANKS                                           CDL033
145500200529     C                   EVAL      CDL033 = 'Y'                                               CDL033
145600200529     C                   ELSE                                                                 CDL033
145700200529     C                   IF        PRTCD  <> '*NRF   '                                        CDL033
145800200529     C     *LOCK         IN        LDA                                                        CDL033
145900200529     C                   MOVE      '901'         DBASE                                        CDL033
146000200529     C                   MOVEL     'CDL033'      DBKEY                                        CDL033
146100200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
146200200529     C                   OUT       LDA                                                        CDL033
146300200529     C                   EXSR      *PSSR                                                      CDL033
146400200529     C                   ENDIF                                                                CDL033
146500200529     C                   ENDIF                                                                CDL033
146600200529      *                                                                                       CDL033
146700200529     C/COPY WNCPYSRC,MMPBDLGC03
146800200529
146900200529     C                   ENDSR
147000200529      *****************************************************************
147100200529      /EJECT
147200200529     C/COPY WNCPYSRC,MMPBDLGC08
147300200529      *****************************************************************
147400200529      ** Program, module and procedure names for database error processing.
147500200529      ** =================================================================
147600200529      ** The following /COPY sets these values, and also defines LDA as
147700200529      ** an external data area
147800200529      ********************************************************************
147900200529     C/COPY ZACPYSRC,PSSR_ILE
148000200529      ********************************************************************
148100200529**  CCPY@
148200200529(c) Finastra International Limited 2001
