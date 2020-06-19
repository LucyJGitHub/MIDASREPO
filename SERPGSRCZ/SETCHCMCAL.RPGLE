000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Trade Charges & Commissions Calculation')     *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *    Midas SE - Midas Security Trading validation module.       *
000900200529      *                                                               *
001000200529      *  SETCHCMCAL - Trade Charges & Commissions Calculation         *
001100200529      *                                                               *
001200200529      *  (c) Finastra International Limited 2001                      *
001300200529      *                                                               *
001400200604      *  Last Amend No. 258901             Date 22May20               *
001500200529      *  Prev Amend No. MD046248           Date 27Oct17               *
001600200529      *                 CRE073             Date 06Dec10               *
001700200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
001800200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
001900200529      * Midas Plus 1.4 Base ------------------------------------------*
002000200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002100200529      *                 CSD031             Date 10Apr06               *
002200200529      *                 CSD027             Date 09Dec05               *
002300200529      *                 CGL031             Date 05Jul04               *
002400200529      *                 CSE075             Date 17Nov05               *
002500200529      *                 BUG7703            Date 09Sep05               *
002600200529      *                 CSE071             Date 19Jul05               *
002700200529      *                 CAS006             Date 21Jan03               *
002800200529      * Midas Release 4.01 -------------------------------------------*
002900200529      *                 CSE031             Date 13Dec01               *
003000200529      * Midas Release 4 --------------- Base -------------------------*
003100200529      * Midas DBA 3.05 -----------------------------------------------*
003200200529      *                 CSD006             Date 11Oct00               *
003300200529      * Midas DBA 3.03 -----------------------------------------------*
003400200529      *                 CAP137             Date 07Feb00               *
003500200529      * Midas DBA 3.02 -----------------------------------------------*
003600200529      *                 CAP051             Date 16Nov99               *
003700200529      *                 CPB001             Date 01Jun99               *
003800200529      * Midas DBA 3.00 ---------------- Base -------------------------*
003900200529      *                 CPL002             Date 08Mar99               *
004000200529      *                 CAP003  *CREATE    Date 28Jan98               *
004100200529      *                                                               *
004200200529      *---------------------------------------------------------------*
004300200529      *  258901 - Error in tax amount for charges and commissions.    *
004400200529      *  MD046248 - Finastra Rebranding                               *
004500200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
004600200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
004700200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
004800200529      *  CGL031 - Taxation of Savings Income (Recompiled)             *
004900200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
005000200529      *           (Recompile)                                         *
005100200529      *  BUG7703 - Serious Midas Error encountered during INSERT      *
005200200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
005300200529      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
005400200529      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
005500200529      *           Recompiled due to changes in SECTYD.                *
005600200529      *  CSD006 - Recompiled over changed SECTYD.                     *
005700200529      *  CAP137 - Conversion of SE Security inputs into modular       *
005800200529      *           structure to use as APIs (SECTYD)                   *
005900200529      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
006000200529      *           Recompiled due to database changes                  *
006100200529      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
006200200529      *           Recompiled due to database changes                  *
006300200529      *         - 'Private Banking' Module                            *
006400200529      *           /COPY SE_CUSTDT changed                             *
006500200529      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
006600200529      *  CAP003 - Conversion of SE inputs into modular structure to   *
006700200529      *           use as APIs.                                        *
006800200529      *                                                               *
006900200529      *****************************************************************
007000200529
007100200529     FSECGT     IF   E           K DISK
007200200529     FTRADSDL2  IF   E           K DISK
007300200529     F                                     RENAME(TRADSDF:TRADSDF2)
007400200529     F                                     PREFIX(F2)
007500200529
007600200529      *****************************************************************
007700200529      ** +--------------------------------------+
007800200529      ** ¦ Automatically included D-specs       ¦
007900200529      ** ¦ ==============================       ¦
008000200529      ** +--------------------------------------+
008100200529      **
008200200529      **--------------------------------------------------------------------------------------------
008300200529      ** The following /COPY line includes (among others) the LDA layout
008400200529      ** and the copyright array definition:
008500200529     D/COPY ZACPYSRC,STD_D_SPEC
008600200529      **--------------------------------------------------------------------------------------------
008700200529
008800200529      **--------------------------------------------------------------------------------------------
008900200529      ** The following /COPY includes the MM standard declares:
009000200529     D/COPY ZACPYSRC,STDDECLARE
009100200529      **--------------------------------------------------------------------------------------------
009200200529
009300200529      **--------------------------------------------------------------------------------------------
009400200529      ** The following /COPY line includes all the defined fields in the
009500200529      ** Program Status Data Structures.  They have meaningful
009600200529      ** names, prefixed by 'PS'.
009700200529     D/COPY ZACPYSRC,PSDS
009800200529      **--------------------------------------------------------------------------------------------
009900200529
010000200529      ** +--------------------------------------+
010100200529      ** ¦ End of automatically included D-specs¦
010200200529      ** ¦ =====================================¦
010300200529      ** +--------------------------------------+
010400200529
010500200529      *****************************************************************
010600200529      /EJECT
010700200529      *****************************************************************
010800200529
010900200529      ** +--------------------------------------+
011000200529      ** ¦ Manually included D-specs            ¦
011100200529      ** ¦ =========================            ¦
011200200529      ** +--------------------------------------+
011300200529
011400200529      ** +--------------------------------------+
011500200529      ** ¦ Named constants                      ¦
011600200529      ** ¦ ===============                      ¦
011700200529      ** +--------------------------------------+
011800200529
011900200529      ** +--------------------------------------+
012000200529      ** ¦ Arrays and Data Structures           ¦
012100200529      ** ¦ ==========================           ¦
012200200529      ** +--------------------------------------+
012300200529
012400200529     D ZRA             S             15  0 DIM(15)                              RANGE LIMITS
012500200529     D ZPC             S              7  4 DIM(15)                              PERCENTAGES
012600200529     D ZCG             S             15  0 DIM(15)                              FLAT CHARGES
012700200529
012800200529
012900200529      ** Trade charges & commissions in screen format
013000200529     D TrChCm        E DS                  EXTNAME(SETRCCPD)
013100200529
013200200529      ** Trade charges & commissions Ok indicators
013300200529     D OKTrChCm      E DS                  EXTNAME(SEETRCCPD)
013400200529
013500200529      ** Previous Trade charges & commissions in screen format
013600200529     D @P_TRCC       E DS                  EXTNAME(SETRCCPD)
013700200529     D                                     PREFIX(@P_)
013800200529
013900200529
014000200529      ** Security Details
014100200529     D SECTY         E DS                  EXTNAME(SECTYD)
014200200529
014300200529
014400200529      ** The following /COPY includes the customer details data structure
014500200529     D/COPY SECPYSRC,SE_CUSTDT
014600200529      ** The following /COPY includes the currency details data structures
014700200529     D/COPY SECPYSRC,SE_CCYDT
014800200529
014900200529
015000200529      ** External data structure for currency details.
015100200529     D SDCURR        E DS                  EXTNAME(SDCURRPD)
015200200529
015300200529      **Second DS for access programs, long data structure.
015400200529     D DSSDY         E DS                  EXTNAME(DSSDY)
015500200529
015600200529      ** +--------------------------------------+
015700200529      ** ¦ Declared variables                   ¦
015800200529      ** ¦ ==================                   ¦
015900200529      ** +--------------------------------------+
016000200529
016100200529     D*TCNR*****       S              6S 0                                                    CSD027
016200200529     D TCNR            S              6A                                                      CSD027
016300200529
016400200529      ** +--------------------------------------+
016500200529      ** ¦ End of D-specs                       ¦
016600200529      ** ¦ ==============                       ¦
016700200529      ** +--------------------------------------+
016800200529
016900200529      *****************************************************************
017000200529      /EJECT
017100200529      *****************************************************************
017200200529
017300200529     C
017400200529      ** +--- Start of Main processing -----------------------------------+
017500200529      ** ¦                                                                ¦
017600200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
017700200529      ** ¦ executed at program activation.                                ¦
017800200529      ** ¦                                                                ¦
017900200529      ** +----------------------------------------------------------------+
018000200529
018100200529      ** Clear calculated amounts
018200200529
018300200529     C                   Z-ADD     0             Cal_TBCA         13 0
018400200529     C                   Z-ADD     0             Cal_TCCA         13 0
018500200529     C                   Z-ADD     0             Cal_TCA1         13 0
018600200529     C                   Z-ADD     0             Cal_TCA2         13 0
018700200529     C                   Z-ADD     0             Cal_TCA3         13 0
018800200529     C                   Z-ADD     0             Cal_TCA4         13 0
018900200529     C                   Z-ADD     0             Cal_TCA5         13 0
019000200529     C                   Z-ADD     0             Cal_TCA6         13 0
019100200529     C                   Z-ADD     0             Cal_TCA7         13 0
019200200529     C                   Z-ADD     0             Cal_TAXA         13 0
019300200529     C                   Z-ADD     0             Cal_BCMR         13 0
019400200529     C                   Z-ADD     0             Cal_CCMR         13 0
019500200529     C                   Z-ADD     0             Cal_TXRB         13 0
019600200529      *
019700200529      * Exit if AUTOCHARGE option not present
019800200529      *
019900200529     C     BVACOP        IFNE      'Y'
020000200529     C                   RETURN
020100200529     C                   END
020200200529      *
020300200529      * Calculate Charge Currency Cross Rate (Nominal -> Charge)
020400200529      *
020500200529     C     S01446        IFEQ      'Y'                                                         S0144
020600200529     C     BVCHRC        ANDNE     *BLANK                                                      S0144
020700200529     C                   EXSR      C_CHGXR
020800200529     C                   END
020900200529      *
021000200529      * Determine whether sign of charges/commissions should be reversed
021100200529      * (Dependent upon type of client and trade)
021200200529      *
021300200529     C     CustClass     IFEQ      'M'
021400200529     C     DDTDTP        ANDEQ     'TS'
021500200529     C     CustClass     OREQ      'S'
021600200529     C     DDTDTP        ANDEQ     'TP'
021700200529     C     CustClass     OREQ      'D'
021800200529     C     DDTDTP        ANDEQ     'TP'
021900200529     C                   MOVEL     'Y'           REV_SIGN          1
022000200529     C                   ELSE
022100200529     C                   MOVEL     'N'           REV_SIGN
022200200529     C                   END
022300200529      *
022400200529      * Reset notification of change indicators
022500200529      *
022600200529     C                   MOVEL     'N'           TBCA_Chgd         1
022700200529     C                   MOVEL     'N'           TCCA_Chgd         1
022800200529     C                   MOVEL     'N'           TCCx_Chgd         1
022900200529      *
023000200529      * All charge codes are in nominal currency
023100200529      *
023200200529     C                   MOVEL     NMCY          @C_CCY
023300200529      *
023400200529      * Initialize tax calculation ind
023500200529      *
023600200529     C                   MOVE      'N'           TAX_CALC          1
023700200529      *
023800200529      ** Determine Counterparty Tax Details
023900200529      *
024000200529     C     CustTAXC      IFNE      *BLANKS
024100200529     C                   EXSR      TXDETS
024200200529     C                   END
024300200529      *
024400200529      * Calculate Broker Commission Amount
024500200529      *
024600200529     C     DDTBCC        IFNE      *BLANKS
024700200529     C     ddTBCCok      ANDNE     'N'
024800200529     C                   EXSR      C_BROKCM
024900200529     C                   END
025000200529      *
025100200529      * Calculate Customer Commission Amount
025200200529      *
025300200529     C     DDTCCC        IFNE      *BLANKS
025400200529     C     ddTCCCok      ANDNE     'N'
025500200529     C                   EXSR      C_CUSTCM
025600200529     C                   END
025700200529      *
025800200529      * Calculate Charge Amount 1
025900200529      *
026000200529     C     DDTCC1        IFNE      *BLANKS
026100200529     C     ddTCC1ok      ANDNE     'N'
026200200529     C                   EXSR      C_CHRG1
026300200529     C                   END
026400200529      *
026500200529      * Calculate Charge Amount 2
026600200529      *
026700200529     C     DDTCC2        IFNE      *BLANKS
026800200529     C     ddTCC2ok      ANDNE     'N'
026900200529     C                   EXSR      C_CHRG2
027000200529     C                   END
027100200529      *
027200200529      * Calculate Charge Amount 3
027300200529      *
027400200529     C     DDTCC3        IFNE      *BLANKS
027500200529     C     ddTCC3ok      ANDNE     'N'
027600200529     C                   EXSR      C_CHRG3
027700200529     C                   END
027800200529      *
027900200529      * Calculate Charge Amount 4
028000200529      *
028100200529     C     DDTCC4        IFNE      *BLANKS
028200200529     C     ddTCC4ok      ANDNE     'N'
028300200529     C                   EXSR      C_CHRG4
028400200529     C                   END
028500200529      *
028600200529      * Calculate Charge Amount 5
028700200529      *
028800200529     C     DDTCC5        IFNE      *BLANKS
028900200529     C     ddTCC5ok      ANDNE     'N'
029000200529     C                   EXSR      C_CHRG5
029100200529     C                   END
029200200529      *
029300200529      * Calculate Charge Amount 6
029400200529      *
029500200529     C     DDTCC6        IFNE      *BLANKS
029600200529     C     ddTCC6ok      ANDNE     'N'
029700200529     C                   EXSR      C_CHRG6
029800200529     C                   END
029900200529      *
030000200529      * Calculate Charge Amount 7
030100200529      *
030200200529     C     DDTCC7        IFNE      *BLANKS
030300200529     C     ddTCC7ok      ANDNE     'N'
030400200529     C                   EXSR      C_CHRG7
030500200529     C                   END
030600200529      *
030700200529      * Calculate Tax Amount
030800200529      *
030900200529     C     TAX_CALC      IFEQ      'Y'
031000200529     C                   EXSR      C_TAXA
031100200529     C                   END
031200200529      *
031300200529      * Calculate Broker Commission Rebate
031400200529      *
031500200529     C     REBA_TBCA     IFEQ      'Y'
031600200529     C     TBCA          ANDNE     *ZEROS
031700200529     C     CMRP          ANDNE     *ZEROS
031800200529     C                   EXSR      C_BROKCMR
031900200529     C                   END
032000200529      *
032100200529      * Calculate Customer Commission Rebate
032200200529      *
032300200529     C     REBA_TCCA     IFEQ      'Y'
032400200529     C     TCCA          ANDNE     *ZEROS
032500200529     C     CMRP          ANDNE     *ZEROS
032600200529     C                   EXSR      C_CUSTCMR
032700200529     C                   END
032800200529      *
032900200529      * Calculate Tax Rebate
033000200529      *
033100200529     C     TAX_CALC      IFEQ      'Y'
033200200529     C                   EXSR      C_TAXREB
033300200529     C                   END
033400200529      *
033500200529      ** Return
033600200529      *
033700200529     C                   RETURN
033800200529
033900200529      /EJECT
034000200529      *****************************************************************
034100200529      *                                                               *
034200200529      * C_CHGXR Calculate Charge Currency Cross Rate                  *
034300200529      *                                                               *
034400200529      *****************************************************************
034500200529     C     C_CHGXR       BEGSR
034600200529      *
034700200529      ** Get spot rate, multiply/divide indicator and number of
034800200529      ** decimal places of charging currency
034900200529      *
035000200529     C                   CALLB     'AOCURRR0'
035100200529     C                   PARM      '*DBERR'      @RTCD             7
035200200529     C                   PARM      '*KEY   '     @OPTN             7
035300200529     C                   PARM      BVCHRC        @AJCD             3
035400200529     C     SDCURR        PARM      SDCURR        DSSDY
035500200529
035600200529     C                   Z-ADD     A6SPRT        ZRATE1
035700200529     C                   MOVE      A6MDIN        ZMDI1
035800200529     C                   Z-ADD     NomCcySPRT    ZRATE2
035900200529     C                   MOVE      NomCcyMDIN    ZMDI2
036000200529     C                   CALLB     'ZXRATE'
036100200529     C                   PARM                    ZRATE1           13 8
036200200529     C                   PARM                    ZMDI1             1
036300200529     C                   PARM                    ZRATE2           13 8
036400200529     C                   PARM                    ZMDI2             1
036500200529     C                   PARM      *ZERO         ZRATEX           13 8
036600200529     C                   PARM      *BLANK        ZMDIX             1
036700200529      *
036800200529      ** Set up exchange rate & mult/div indicator of charging currency
036900200529      *
037000200529     C                   Z-ADD     ZRATEX        ChgCcyEXRT       13 8
037100200529     C                   MOVE      ZMDIX         ChgCCyMDIN        1
037200200529     C                   MOVE      A6NBDP        ChgCcyDec         1 0
037300200529      *
037400200529     C                   ENDSR
037500200529      *****************************************************************
037600200529      /EJECT
037700200529      *****************************************************************
037800200529      *                                                               *
037900200529      * C_BROKCM Calculate Broker Commission Amount                   *
038000200529      *                                                               *
038100200529      *****************************************************************
038200200529     C     C_BROKCM      BEGSR
038300200529      *
038400200529      * Calculate Broker Commission
038500200529      *
038600200529     C                   MOVEL     DDTBCC        @C_CCOM
038700200529      *
038800200529     C                   EXSR      C_CHCM
038900200529      *
039000200529      * Store tax and rebate indicator for broker commission
039100200529      *
039200200529     C                   MOVE      TXAP          TXAP_TBCA         1
039300200529     C                   MOVE      REBA          REBA_TBCA         1
039400200529      *
039500200529      *  Edit Broker Commission calculated
039600200529      *
039700200529     C                   Z-ADD     ZCHGA         Cal_TBCA
039800200529
039900200529     C                   MOVE      *BLANKS       ZFLD15
040000200529     C                   MOVE      Cal_TBCA      ZFLD15
040100200529     C                   EXSR      EDIT_AMT
040200200529     C                   MOVE      ZOUT21        Cal_DDTBCA       14
040300200529      *
040400200529      *  Override Broker commission if
040500200529      *  i.  the amount is blank, or
040600200529      *  ii. the code has changed and the amount hasn't
040700200529      *
040800200529     C     DDTBCA        IFEQ      *BLANK
040900200529     C     DDTBCC        ORNE      @P_DDTBCC
041000200529     C     DDTBCA        ANDEQ     @P_DDTBCA
041100200529     C     REV_SIGN      IFEQ      'Y'
041200200529     C                   Z-SUB     Cal_TBCA      TBCA
041300200529     C                   ELSE
041400200529     C                   Z-ADD     Cal_TBCA      TBCA
041500200529     C                   END
041600200529     C                   MOVE      Cal_DDTBCA    DDTBCA
041700200529     C                   MOVEL     'Y'           TBCA_Chgd
041800200529     C                   END
041900200529
042000200529     C                   ENDSR
042100200529      *****************************************************************
042200200529      /EJECT
042300200529      *****************************************************************
042400200529      *                                                               *
042500200529      * C_CUSTCM Calculate Customer Commission Amount                 *
042600200529      *                                                               *
042700200529      *****************************************************************
042800200529     C     C_CUSTCM      BEGSR
042900200529      *
043000200529      * Calculate Customer Commission
043100200529      *
043200200529     C                   MOVEL     DDTCCC        @C_CCOM
043300200529      *
043400200529     C                   MOVE      'Y'           CalCstCom         1
043500200529     C                   EXSR      C_CHCM
043600200529     C                   MOVE      'N'           CalCstCom
043700200529      *
043800200529      * Store tax and rebate indicator for customer commission
043900200529      *
044000200529     C                   MOVE      TXAP          TXAP_TCCA         1
044100200529     C                   MOVE      REBA          REBA_TCCA         1
044200200529      *
044300200529      *  Edit Customer Commission calculated
044400200529      *
044500200529     C                   Z-ADD     ZCHGA         Cal_TCCA
044600200529
044700200529     C                   MOVE      *BLANKS       ZFLD15
044800200529     C                   MOVE      Cal_TCCA      ZFLD15
044900200529     C                   EXSR      EDIT_AMT
045000200529     C                   MOVE      ZOUT21        Cal_DDTCCA       14
045100200529      *
045200200529      *  Override Customer commission if
045300200529      *  i.  the amount is blank, or
045400200529      *  ii. the code has changed and the amount hasn't
045500200529      *
045600200529     C     DDTCCA        IFEQ      *BLANK
045700200529     C     DDTCCC        ORNE      @P_DDTCCC
045800200529     C     DDTCCA        ANDEQ     @P_DDTCCA
045900200529     C     REV_SIGN      IFEQ      'Y'
046000200529     C                   Z-SUB     Cal_TCCA      TCCA
046100200529     C                   ELSE
046200200529     C                   Z-ADD     Cal_TCCA      TCCA
046300200529     C                   END
046400200529     C                   MOVE      Cal_DDTCCA    DDTCCA
046500200529     C                   MOVEL     'Y'           TCCA_Chgd
046600200529     C                   END
046700200529
046800200529     C                   ENDSR
046900200529      *****************************************************************
047000200529      /EJECT
047100200529      *****************************************************************
047200200529      *                                                               *
047300200529      * C_CHRG1 Calculate Charge Amount 1                             *
047400200529      *                                                               *
047500200529      *****************************************************************
047600200529     C     C_CHRG1       BEGSR
047700200529      *
047800200529      * Calculate Charge Amount 1
047900200529      *
048000200529     C                   MOVEL     DDTCC1        @C_CCOM
048100200529      *
048200200529     C                   EXSR      C_CHCM
048300200529      *
048400200529      * Store tax indicator for charge 1
048500200529      *
048600200529     C                   MOVE      TXAP          TXAP_TCA1         1
048700200529      *
048800200529      *  Edit Charge Amount 1 calculated
048900200529      *
049000200529     C                   Z-ADD     ZCHGA         Cal_TCA1
049100200529
049200200529     C                   MOVE      *BLANKS       ZFLD15
049300200529     C                   MOVE      Cal_TCA1      ZFLD15
049400200529     C                   EXSR      EDIT_AMT
049500200529     C                   MOVE      ZOUT21        Cal_DDTCA1       14
049600200529      *
049700200529      *  Override Charge Amount 1 if
049800200529      *  i.  the amount is blank, or
049900200529      *  ii. the code has changed and the amount hasn't
050000200529      *
050100200529     C     DDTCA1        IFEQ      *BLANK
050200200529     C     DDTCC1        ORNE      @P_DDTCC1
050300200529     C     DDTCA1        ANDEQ     @P_DDTCA1
050400200529     C     REV_SIGN      IFEQ      'Y'
050500200529     C                   Z-SUB     Cal_TCA1      TCA1
050600200529     C                   ELSE
050700200529     C                   Z-ADD     Cal_TCA1      TCA1
050800200529     C                   END
050900200529     C                   MOVE      Cal_DDTCA1    DDTCA1
051000200529     C                   MOVEL     'Y'           TCCx_Chgd
051100200529     C                   END
051200200529
051300200529     C                   ENDSR
051400200529      *****************************************************************
051500200529      /EJECT
051600200529      *****************************************************************
051700200529      *                                                               *
051800200529      * C_CHRG2 Calculate Charge Amount 2                             *
051900200529      *                                                               *
052000200529      *****************************************************************
052100200529     C     C_CHRG2       BEGSR
052200200529      *
052300200529      * Calculate Charge Amount 2
052400200529      *
052500200529     C                   MOVEL     DDTCC2        @C_CCOM
052600200529      *
052700200529     C                   EXSR      C_CHCM
052800200529      *
052900200529      * Store tax indicator for charge 2
053000200529      *
053100200529     C                   MOVE      TXAP          TXAP_TCA2         1
053200200529      *
053300200529      *  Edit Charge Amount 2 calculated
053400200529      *
053500200529     C                   Z-ADD     ZCHGA         Cal_TCA2
053600200529
053700200529     C                   MOVE      *BLANKS       ZFLD15
053800200529     C                   MOVE      Cal_TCA2      ZFLD15
053900200529     C                   EXSR      EDIT_AMT
054000200529     C                   MOVE      ZOUT21        Cal_DDTCA2       14
054100200529      *
054200200529      *  Override Charge Amount 2 if
054300200529      *  i.  the amount is blank, or
054400200529      *  ii. the code has changed and the amount hasn't
054500200529      *
054600200529     C     DDTCA2        IFEQ      *BLANK
054700200529     C     DDTCC2        ORNE      @P_DDTCC2
054800200529     C     DDTCA2        ANDEQ     @P_DDTCA2
054900200529     C     REV_SIGN      IFEQ      'Y'
055000200529     C                   Z-SUB     Cal_TCA2      TCA2
055100200529     C                   ELSE
055200200529     C                   Z-ADD     Cal_TCA2      TCA2
055300200529     C                   END
055400200529     C                   MOVE      Cal_DDTCA2    DDTCA2
055500200529     C                   MOVEL     'Y'           TCCx_Chgd
055600200529     C                   END
055700200529
055800200529     C                   ENDSR
055900200529      *****************************************************************
056000200529      /EJECT
056100200529      *****************************************************************
056200200529      *                                                               *
056300200529      * C_CHRG3 Calculate Charge Amount 3                             *
056400200529      *                                                               *
056500200529      *****************************************************************
056600200529     C     C_CHRG3       BEGSR
056700200529      *
056800200529      * Calculate Charge Amount 3
056900200529      *
057000200529     C                   MOVEL     DDTCC3        @C_CCOM
057100200529      *
057200200529     C                   EXSR      C_CHCM
057300200529      *
057400200529      * Store tax indicator for charge 3
057500200529      *
057600200529     C                   MOVE      TXAP          TXAP_TCA3         1
057700200529      *
057800200529      *  Edit Charge Amount 3 calculated
057900200529      *
058000200529     C                   Z-ADD     ZCHGA         Cal_TCA3
058100200529
058200200529     C                   MOVE      *BLANKS       ZFLD15
058300200529     C                   MOVE      Cal_TCA3      ZFLD15
058400200529     C                   EXSR      EDIT_AMT
058500200529     C                   MOVE      ZOUT21        Cal_DDTCA3       14
058600200529      *
058700200529      *  Override Charge Amount 3 if
058800200529      *  i.  the amount is blank, or
058900200529      *  ii. the code has changed and the amount hasn't
059000200529      *
059100200529     C     DDTCA3        IFEQ      *BLANK
059200200529     C     DDTCC3        ORNE      @P_DDTCC3
059300200529     C     DDTCA3        ANDEQ     @P_DDTCA3
059400200529     C     REV_SIGN      IFEQ      'Y'
059500200529     C                   Z-SUB     Cal_TCA3      TCA3
059600200529     C                   ELSE
059700200529     C                   Z-ADD     Cal_TCA3      TCA3
059800200529     C                   END
059900200529     C                   MOVE      Cal_DDTCA3    DDTCA3
060000200529     C                   MOVEL     'Y'           TCCx_Chgd
060100200529     C                   END
060200200529
060300200529     C                   ENDSR
060400200529      *****************************************************************
060500200529      /EJECT
060600200529      *****************************************************************
060700200529      *                                                               *
060800200529      * C_CHRG4 Calculate Charge Amount 4                             *
060900200529      *                                                               *
061000200529      *****************************************************************
061100200529     C     C_CHRG4       BEGSR
061200200529      *
061300200529      * Calculate Charge Amount 4
061400200529      *
061500200529     C                   MOVEL     DDTCC4        @C_CCOM
061600200529      *
061700200529     C                   EXSR      C_CHCM
061800200529      *
061900200529      * Store tax indicator for charge 4
062000200529      *
062100200529     C                   MOVE      TXAP          TXAP_TCA4         1
062200200529      *
062300200529      *  Edit Charge Amount 4 calculated
062400200529      *
062500200529     C                   Z-ADD     ZCHGA         Cal_TCA4
062600200529
062700200529     C                   MOVE      *BLANKS       ZFLD15
062800200529     C                   MOVE      Cal_TCA4      ZFLD15
062900200529     C                   EXSR      EDIT_AMT
063000200529     C                   MOVE      ZOUT21        Cal_DDTCA4       14
063100200529      *
063200200529      *  Override Charge Amount 4 if
063300200529      *  i.  the amount is blank, or
063400200529      *  ii. the code has changed and the amount hasn't
063500200529      *
063600200529     C     DDTCA4        IFEQ      *BLANK
063700200529     C     DDTCC4        ORNE      @P_DDTCC4
063800200529     C     DDTCA4        ANDEQ     @P_DDTCA4
063900200529     C     REV_SIGN      IFEQ      'Y'
064000200529     C                   Z-SUB     Cal_TCA4      TCA4
064100200529     C                   ELSE
064200200529     C                   Z-ADD     Cal_TCA4      TCA4
064300200529     C                   END
064400200529     C                   MOVE      Cal_DDTCA4    DDTCA4
064500200529     C                   MOVEL     'Y'           TCCx_Chgd
064600200529     C                   END
064700200529
064800200529     C                   ENDSR
064900200529      *****************************************************************
065000200529      /EJECT
065100200529      *****************************************************************
065200200529      *                                                               *
065300200529      * C_CHRG5 Calculate Charge Amount 5                             *
065400200529      *                                                               *
065500200529      *****************************************************************
065600200529     C     C_CHRG5       BEGSR
065700200529      *
065800200529      * Calculate Charge Amount 5
065900200529      *
066000200529     C                   MOVEL     DDTCC5        @C_CCOM
066100200529      *
066200200529     C                   EXSR      C_CHCM
066300200529      *
066400200529      * Store tax indicator for charge 5
066500200529      *
066600200529     C                   MOVE      TXAP          TXAP_TCA5         1
066700200529      *
066800200529      *  Edit Charge Amount 5 calculated
066900200529      *
067000200529     C                   Z-ADD     ZCHGA         Cal_TCA5
067100200529
067200200529     C                   MOVE      *BLANKS       ZFLD15
067300200529     C                   MOVE      Cal_TCA5      ZFLD15
067400200529     C                   EXSR      EDIT_AMT
067500200529     C                   MOVE      ZOUT21        Cal_DDTCA5       14
067600200529      *
067700200529      *  Override Charge Amount 5 if
067800200529      *  i.  the amount is blank, or
067900200529      *  ii. the code has changed and the amount hasn't
068000200529      *
068100200529     C     DDTCA5        IFEQ      *BLANK
068200200529     C     DDTCC5        ORNE      @P_DDTCC5
068300200529     C     DDTCA5        ANDEQ     @P_DDTCA5
068400200529     C     REV_SIGN      IFEQ      'Y'
068500200529     C                   Z-SUB     Cal_TCA5      TCA5
068600200529     C                   ELSE
068700200529     C                   Z-ADD     Cal_TCA5      TCA5
068800200529     C                   END
068900200529     C                   MOVE      Cal_DDTCA5    DDTCA5
069000200529     C                   MOVEL     'Y'           TCCx_Chgd
069100200529     C                   END
069200200529
069300200529     C                   ENDSR
069400200529      *****************************************************************
069500200529      /EJECT
069600200529      *****************************************************************
069700200529      *                                                               *
069800200529      * C_CHRG6 Calculate Charge Amount 6                             *
069900200529      *                                                               *
070000200529      *****************************************************************
070100200529     C     C_CHRG6       BEGSR
070200200529      *
070300200529      * Calculate Charge Amount 6
070400200529      *
070500200529     C                   MOVEL     DDTCC6        @C_CCOM
070600200529      *
070700200529     C                   EXSR      C_CHCM
070800200529      *
070900200529      * Store tax indicator for charge 6
071000200529      *
071100200529     C                   MOVE      TXAP          TXAP_TCA6         1
071200200529      *
071300200529      *  Edit Charge Amount 6 calculated
071400200529      *
071500200529     C                   Z-ADD     ZCHGA         Cal_TCA6
071600200529
071700200529     C                   MOVE      *BLANKS       ZFLD15
071800200529     C                   MOVE      Cal_TCA6      ZFLD15
071900200529     C                   EXSR      EDIT_AMT
072000200529     C                   MOVE      ZOUT21        Cal_DDTCA6       14
072100200529      *
072200200529      *  Override Charge Amount 6 if
072300200529      *  i.  the amount is blank, or
072400200529      *  ii. the code has changed and the amount hasn't
072500200529      *
072600200529     C     DDTCA6        IFEQ      *BLANK
072700200529     C     DDTCC6        ORNE      @P_DDTCC6
072800200529     C     DDTCA6        ANDEQ     @P_DDTCA6
072900200529     C     REV_SIGN      IFEQ      'Y'
073000200529     C                   Z-SUB     Cal_TCA6      TCA6
073100200529     C                   ELSE
073200200529     C                   Z-ADD     Cal_TCA6      TCA6
073300200529     C                   END
073400200529     C                   MOVE      Cal_DDTCA6    DDTCA6
073500200529     C                   MOVEL     'Y'           TCCx_Chgd
073600200529     C                   END
073700200529
073800200529     C                   ENDSR
073900200529      *****************************************************************
074000200529      /EJECT
074100200529      *****************************************************************
074200200529      *                                                               *
074300200529      * C_CHRG7 Calculate Charge Amount 7                             *
074400200529      *                                                               *
074500200529      *****************************************************************
074600200529     C     C_CHRG7       BEGSR
074700200529      *
074800200529      * Calculate Charge Amount 7
074900200529      *
075000200529     C                   MOVEL     DDTCC7        @C_CCOM
075100200529      *
075200200529     C                   EXSR      C_CHCM
075300200529      *
075400200529      * Store tax indicator for charge 7
075500200529      *
075600200529     C                   MOVE      TXAP          TXAP_TCA7         1
075700200529      *
075800200529      *  Edit Charge Amount 7 calculated
075900200529      *
076000200529     C                   Z-ADD     ZCHGA         Cal_TCA7
076100200529
076200200529     C                   MOVE      *BLANKS       ZFLD15
076300200529     C                   MOVE      Cal_TCA7      ZFLD15
076400200529     C                   EXSR      EDIT_AMT
076500200529     C                   MOVE      ZOUT21        Cal_DDTCA7       14
076600200529      *
076700200529      *  Override Charge Amount 7 if
076800200529      *  i.  the amount is blank, or
076900200529      *  ii. the code has changed and the amount hasn't
077000200529      *
077100200529     C     DDTCA7        IFEQ      *BLANK
077200200529     C     DDTCC7        ORNE      @P_DDTCC7
077300200529     C     DDTCA7        ANDEQ     @P_DDTCA7
077400200529     C     REV_SIGN      IFEQ      'Y'
077500200529     C                   Z-SUB     Cal_TCA7      TCA7
077600200529     C                   ELSE
077700200529     C                   Z-ADD     Cal_TCA7      TCA7
077800200529     C                   END
077900200529     C                   MOVE      Cal_DDTCA7    DDTCA7
078000200529     C                   MOVEL     'Y'           TCCx_Chgd
078100200529     C                   END
078200200529
078300200529     C                   ENDSR
078400200529      *****************************************************************
078500200529      /EJECT
078600200529      *****************************************************************
078700200529      *                                                               *
078800200529      * C_TAXA Calculate Tax Amount                                   *
078900200529      *                                                               *
079000200529      *****************************************************************
079100200529     C     C_TAXA        BEGSR
079200200529      *
079300200529      * Initialize total tax
079400200529      *
079500200529     C                   Z-ADD     *ZEROS        Cal_TAXA
079600200529      *
079700200529      *  Get tax due on broker commission
079800200529      *
079900200529     C     TXAP_TBCA     IFEQ      'Y'
080000200529     C     TBCA          ANDNE     *ZERO
080100200529     C                   Z-ADD     TBCA          ZCHGA
080200200529     C                   EXSR      C_TAX
080300200529     C                   ADD       ZTAXA         Cal_TAXA
080400200529     C                   END
080500200529      *
080600200529      *  Get tax due on customer commission
080700200529      *
080800200529     C     TXAP_TCCA     IFEQ      'Y'
080900200529     C     TCCA          ANDNE     *ZERO
081000200529     C                   Z-ADD     TCCA          ZCHGA
081100200529     C                   EXSR      C_TAX
081200200529     C                   ADD       ZTAXA         Cal_TAXA
081300200529     C                   END
081400200529      *
081500200529      *  Get tax due on Charge Code 1
081600200529      *
081700200529     C     TXAP_TCA1     IFEQ      'Y'
081800200529     C     TCA1          ANDNE     *ZERO
081900200529     C                   Z-ADD     TCA1          ZCHGA
082000200529     C                   EXSR      C_TAX
082100200529     C                   ADD       ZTAXA         Cal_TAXA
082200200529     C                   END
082300200529      *
082400200529      *  Get tax due on Charge Code 2
082500200529      *
082600200529     C     TXAP_TCA2     IFEQ      'Y'
082700200529     C     TCA2          ANDNE     *ZERO
082800200529     C                   Z-ADD     TCA2          ZCHGA
082900200529     C                   EXSR      C_TAX
083000200529     C                   ADD       ZTAXA         Cal_TAXA
083100200529     C                   END
083200200529      *
083300200529      *  Get tax due on Charge Code 3
083400200529      *
083500200529     C     TXAP_TCA3     IFEQ      'Y'
083600200529     C     TCA3          ANDNE     *ZERO
083700200529     C                   Z-ADD     TCA3          ZCHGA
083800200529     C                   EXSR      C_TAX
083900200529     C                   ADD       ZTAXA         Cal_TAXA
084000200529     C                   END
084100200529      *
084200200529      *  Get tax due on Charge Code 4
084300200529      *
084400200529     C     TXAP_TCA4     IFEQ      'Y'
084500200529     C     TCA4          ANDNE     *ZERO
084600200529     C                   Z-ADD     TCA4          ZCHGA
084700200529     C                   EXSR      C_TAX
084800200529     C                   ADD       ZTAXA         Cal_TAXA
084900200529     C                   END
085000200529      *
085100200529      *  Get tax due on Charge Code 5
085200200529      *
085300200529     C     TXAP_TCA5     IFEQ      'Y'
085400200529     C     TCA5          ANDNE     *ZERO
085500200529     C                   Z-ADD     TCA5          ZCHGA
085600200529     C                   EXSR      C_TAX
085700200529     C                   ADD       ZTAXA         Cal_TAXA
085800200529     C                   END
085900200529      *
086000200529      *  Get tax due on Charge Code 6
086100200529      *
086200200529     C     TXAP_TCA6     IFEQ      'Y'
086300200529     C     TCA6          ANDNE     *ZERO
086400200529     C                   Z-ADD     TCA6          ZCHGA
086500200529     C                   EXSR      C_TAX
086600200529     C                   ADD       ZTAXA         Cal_TAXA
086700200529     C                   END
086800200529      *
086900200529      *  Get tax due on Charge Code 7
087000200529      *
087100200529     C     TXAP_TCA7     IFEQ      'Y'
087200200529     C     TCA7          ANDNE     *ZERO
087300200529     C                   Z-ADD     TCA7          ZCHGA
087400200529     C                   EXSR      C_TAX
087500200529     C                   ADD       ZTAXA         Cal_TAXA
087600200529     C                   END
087700200529      *
087800200529      * Tax amount is tax total
087900200529      *
088000200529     C                   MOVE      *BLANKS       ZFLD15
088100200529     C     REV_SIGN      IFEQ      'Y'
088200200529     C                   Z-SUB     Cal_TAXA      ZFLD15
088300200529     C                   ELSE
088400200529     C                   Z-ADD     Cal_TAXA      ZFLD15
088500200529     C                   END
088600200529     C     Cal_TAXA      IFNE      *ZEROS                                                    BUG7703
088700200529     C                   EXSR      EDIT_AMT
088800200529     C                   MOVE      ZOUT21        Cal_DDTAXA       14
088900200529     C                   ELSE                                                                 258901
089000200529     C                   MOVE      *BLANKS       Cal_DDTAXA                                   258901
089100200529     C                   ENDIF                                                               BUG7703
089200200529      *
089300200529      *  Override Tax Amount if
089400200529      *  i.  the amount is blank, or
089500200529      *  ii. broker commission, customer commission or a charge amount
089600200529      *      has changed but the the tax amount hasn't been changed
089700200529      *
089800200529     C     DDTAXA        IFEQ      *BLANK
089900200529     C     TBCA_Chgd     OREQ      'Y'
090000200529     C     DDTAXA        ANDEQ     @P_DDTAXA
090100200529     C     TCCA_Chgd     OREQ      'Y'
090200200529     C     DDTAXA        ANDEQ     @P_DDTAXA
090300200529     C     TCCx_Chgd     OREQ      'Y'
090400200529     C     DDTAXA        ANDEQ     @P_DDTAXA
090500200529     C                   Z-ADD     Cal_TAXA      TAXA
090600200529     C                   MOVE      Cal_DDTAXA    DDTAXA
090700200529     C                   END
090800200529
090900200529     C                   ENDSR
091000200529      *****************************************************************
091100200529      /EJECT
091200200529      *****************************************************************
091300200529      *                                                               *
091400200529      * C_BROKCMR Calculate Broker Commission Rebate                  *
091500200529      *                                                               *
091600200529      *****************************************************************
091700200529     C     C_BROKCMR     BEGSR
091800200529      *
091900200529      *  Calculate Broker Commission Rebate
092000200529      *
092100200529     C                   Z-ADD     TBCA          ZCHGA
092200200529     C                   EXSR      REBATE
092300200529     C                   Z-ADD     #REB0         Cal_BCMR
092400200529      *
092500200529      *  Edit Broker Commission Rebate
092600200529      *
092700200529     C     Cal_BCMR      IFNE      *ZEROS
092800200529     C                   MOVE      *BLANKS       ZFLD15
092900200529     C     REV_SIGN      IFEQ      'Y'
093000200529     C                   Z-SUB     Cal_BCMR      ZFLD15
093100200529     C                   ELSE
093200200529     C                   Z-ADD     Cal_BCMR      ZFLD15
093300200529     C                   END
093400200529     C                   EXSR      EDIT_AMT
093500200529     C                   MOVE      ZOUT21        Cal_DDBCMR       14
093600200529     C                   END
093700200529      *
093800200529      *  Override Broker Commission Rebate
093900200529      *  i.  the amount is blank, or
094000200529      *  ii. the broker commission has been changed
094100200529      *      but the broker commission rebate hasn't been changed
094200200529      *
094300200529     C     DDBCMR        IFEQ      *BLANK
094400200529     C     TBCA_Chgd     OREQ      'Y'
094500200529     C     DDBCMR        ANDEQ     @P_DDBCMR
094600200529     C                   Z-ADD     Cal_BCMR      BCMR
094700200529     C                   MOVE      Cal_DDBCMR    DDBCMR
094800200529     C                   END
094900200529
095000200529     C                   ENDSR
095100200529      *****************************************************************
095200200529      /EJECT
095300200529      *****************************************************************
095400200529      *                                                               *
095500200529      * C_CUSTCMR Calculate Customer Commission Rebate                *
095600200529      *                                                               *
095700200529      *****************************************************************
095800200529     C     C_CUSTCMR     BEGSR
095900200529      *
096000200529      *  Calculate Customer Commission Rebate
096100200529      *
096200200529     C                   Z-ADD     TCCA          ZCHGA
096300200529     C                   EXSR      REBATE
096400200529     C                   Z-ADD     #REB0         Cal_CCMR
096500200529      *
096600200529      *  Edit Customer Commission Rebate
096700200529      *
096800200529     C     Cal_CCMR      IFNE      *ZEROS
096900200529     C                   MOVE      *BLANKS       ZFLD15
097000200529     C     REV_SIGN      IFEQ      'Y'
097100200529     C                   Z-SUB     Cal_CCMR      ZFLD15
097200200529     C                   ELSE
097300200529     C                   Z-ADD     Cal_CCMR      ZFLD15
097400200529     C                   END
097500200529     C                   EXSR      EDIT_AMT
097600200529     C                   MOVE      ZOUT21        Cal_DDCCMR       14
097700200529     C                   END
097800200529      *
097900200529      *  Override Customer Commission Rebate
098000200529      *  i.  the amount is blank, or
098100200529      *  ii. the customer commission has been changed
098200200529      *      but the customer commission rebate hasn't been changed
098300200529      *
098400200529     C     DDCCMR        IFEQ      *BLANK
098500200529     C     TCCA_Chgd     OREQ      'Y'
098600200529     C     DDCCMR        ANDEQ     @P_DDCCMR
098700200529     C                   Z-ADD     Cal_CCMR      CCMR
098800200529     C                   MOVE      Cal_DDCCMR    DDCCMR
098900200529     C                   END
099000200529
099100200529     C                   ENDSR
099200200529      *****************************************************************
099300200529      /EJECT
099400200529      *****************************************************************
099500200529      *                                                               *
099600200529      * C_TAXREB Calculate Tax Rebate                                 *
099700200529      *                                                               *
099800200529      *****************************************************************
099900200529     C     C_TAXREB      BEGSR
100000200529      *
100100200529      * Initialize total rebate tax
100200200529      *
100300200529     C                   Z-ADD     *ZEROS        Cal_TXRB
100400200529      *
100500200529      *  Get tax due on broker commission rebate
100600200529      *
100700200529     C     BCMR          IFNE      *ZERO
100800200529     C                   Z-ADD     BCMR          ZCHGA
100900200529     C                   EXSR      C_TAX
101000200529     C                   ADD       ZTAXA         Cal_TXRB
101100200529     C                   END
101200200529      *
101300200529      *  Get tax due on customer commission rebate
101400200529      *
101500200529     C     CCMR          IFNE      *ZERO
101600200529     C                   Z-ADD     CCMR          ZCHGA
101700200529     C                   EXSR      C_TAX
101800200529     C                   ADD       ZTAXA         Cal_TXRB
101900200529     C                   END
102000200529      *
102100200529      * Default rebate tax amount is rebate tax total
102200200529      *
102300200529     C     Cal_TXRB      IFNE      *ZEROS
102400200529     C                   MOVE      *BLANKS       ZFLD15
102500200529     C     REV_SIGN      IFEQ      'Y'
102600200529     C                   Z-SUB     Cal_TXRB      ZFLD15
102700200529     C                   ELSE
102800200529     C                   Z-ADD     Cal_TXRB      ZFLD15
102900200529     C                   END
103000200529     C                   EXSR      EDIT_AMT
103100200529     C                   MOVE      ZOUT21        Cal_DDTXRB       14
103200200529     C                   END
103300200529      *
103400200529      *  Override Tax Rebate
103500200529      *  i.  the amount is blank, or
103600200529      *  ii. the customer or broker commission rebate have changed
103700200529      *
103800200529     C     DDTXRB        IFEQ      *BLANK
103900200529     C     TBCA_Chgd     OREQ      'Y'
104000200529     C     TCCA_Chgd     OREQ      'Y'
104100200529     C                   Z-ADD     Cal_TXRB      TXRB
104200200529     C                   MOVE      Cal_DDTXRB    DDTXRB
104300200529     C                   END
104400200529
104500200529     C                   ENDSR
104600200529      *****************************************************************
104700200529      /EJECT
104800200529      *****************************************************************
104900200529      *                                                               *
105000200529      *  C_CHCM - CALCULATE CHARGE OR COMMISSION AMOUNT               *
105100200529      *                                                               *
105200200529      *****************************************************************
105300200529     C     C_CHCM        BEGSR
105400200529      *
105500200529      ** GET CHARGE/COMMISSION CODE DETAILS
105600200529      *
105700200529     C     KLSECGT       CHAIN     SECGT                              21
105800200529      *
105900200529      * IF NO LIVE RECORD FOUND,
106000200529      *    CHARGE OR COMMISSION AMOUNT IS ZERO
106100200529      *    TAX INDICATOR IS NULL
106200200529      *
106300200529     C     *IN21         IFEQ      '1'
106400200529     C     RECI          ORNE      'D'
106500200529     C                   Z-ADD     *ZEROS        ZCHGA
106600200529     C                   MOVEL     *BLANK        TXAP
106700200529     C                   END
106800200529      *
106900200529     C     *IN21         IFEQ      '0'
107000200529     C     RECI          ANDEQ     'D'
107100200529      *
107200200529      *  IF TRADE TYPE IS PURCHASE AND LEVY ON SALE
107300200529      *  OR TRADE TYPE IS SALE AND LEVY ON PURCHASE
107400200529      *    CHARGE OR COMMISSION AMOUNT IS ZERO
107500200529      *  OTHERWISE CALCULATE IT
107600200529      *
107700200529     C     DDTDTP        IFEQ      'TP'
107800200529     C     LPSI          ANDEQ     'S'
107900200529     C     DDTDTP        OREQ      'TS'
108000200529     C     LPSI          ANDEQ     'P'
108100200529     C                   Z-ADD     *ZEROS        ZCHGA
108200200529     C                   ELSE
108300200529     C                   EXSR      C_CHCM2
108400200529     C                   END
108500200529      *
108600200529     C                   END
108700200529      *
108800200529     C                   ENDSR
108900200529      *****************************************************************
109000200529      /EJECT
109100200529      *****************************************************************
109200200529      *                                                               *
109300200529      *  C_CHCM2 - CALCULATE CHARGE OR COMMISSION AMOUNT              *
109400200529      *                                                               *
109500200529      *****************************************************************
109600200529     C     C_CHCM2       BEGSR
109700200529      *
109800200529      *  CHARGE DETAILS
109900200529      *
110000200529     C                   MOVE      CHGB          ZCHGB
110100200529     C                   MOVE      THRI          ZTHRI
110200200529     C                   Z-ADD     MNCH          ZMNCH
110300200529     C                   Z-ADD     MXCH          ZMXCH
110400200529      *
110500200529      *  SET UP ARRAY FOR UPPER RANGE LIMITS
110600200529      *
110700200529     C                   Z-ADD     STU1          ZRA(1)
110800200529     C                   Z-ADD     STU2          ZRA(2)
110900200529     C                   Z-ADD     STU3          ZRA(3)
111000200529     C                   Z-ADD     STU4          ZRA(4)
111100200529     C                   Z-ADD     STU5          ZRA(5)
111200200529     C                   Z-ADD     STU6          ZRA(6)
111300200529     C                   Z-ADD     STU7          ZRA(7)
111400200529     C                   Z-ADD     STU8          ZRA(8)
111500200529     C                   Z-ADD     STU9          ZRA(9)
111600200529     C                   Z-ADD     ST10          ZRA(10)
111700200529     C                   Z-ADD     ST11          ZRA(11)
111800200529     C                   Z-ADD     ST12          ZRA(12)
111900200529     C                   Z-ADD     ST13          ZRA(13)
112000200529     C                   Z-ADD     ST14          ZRA(14)
112100200529      *
112200200529      *  SET UP ARRAY FOR PERCENTAGE LEVELS
112300200529      *
112400200529     C                   Z-ADD     PL01          ZPC(1)
112500200529     C                   Z-ADD     PL02          ZPC(2)
112600200529     C                   Z-ADD     PL03          ZPC(3)
112700200529     C                   Z-ADD     PL04          ZPC(4)
112800200529     C                   Z-ADD     PL05          ZPC(5)
112900200529     C                   Z-ADD     PL06          ZPC(6)
113000200529     C                   Z-ADD     PL07          ZPC(7)
113100200529     C                   Z-ADD     PL08          ZPC(8)
113200200529     C                   Z-ADD     PL09          ZPC(9)
113300200529     C                   Z-ADD     PL10          ZPC(10)
113400200529     C                   Z-ADD     PL11          ZPC(11)
113500200529     C                   Z-ADD     PL12          ZPC(12)
113600200529     C                   Z-ADD     PL13          ZPC(13)
113700200529     C                   Z-ADD     PL14          ZPC(14)
113800200529     C                   Z-ADD     PL15          ZPC(15)
113900200529      *
114000200529      *  SET UP ARRAY FOR FLAT CHARGES
114100200529      *
114200200529     C                   Z-ADD     FC01          ZCG(1)
114300200529     C                   Z-ADD     FC02          ZCG(2)
114400200529     C                   Z-ADD     FC03          ZCG(3)
114500200529     C                   Z-ADD     FC04          ZCG(4)
114600200529     C                   Z-ADD     FC05          ZCG(5)
114700200529     C                   Z-ADD     FC06          ZCG(6)
114800200529     C                   Z-ADD     FC07          ZCG(7)
114900200529     C                   Z-ADD     FC08          ZCG(8)
115000200529     C                   Z-ADD     FC09          ZCG(9)
115100200529     C                   Z-ADD     FC10          ZCG(10)
115200200529     C                   Z-ADD     FC11          ZCG(11)
115300200529     C                   Z-ADD     FC12          ZCG(12)
115400200529     C                   Z-ADD     FC13          ZCG(13)
115500200529     C                   Z-ADD     FC14          ZCG(14)
115600200529     C                   Z-ADD     FC15          ZCG(15)
115700200529      *
115800200529      *  TRADE NOMINAL
115900200529      *
116000200529     C                   MOVE      NOML          ZNOML
116100200529      *
116200200529      *  TRADE % PRICE
116300200529      *
116400200529     C                   MOVE      PRIC          ZPRICE
116500200529      *
116600200529      *  NOMINAL CURRENCY DECIMAL PLACES
116700200529      *
116800200529     C                   Z-ADD     NomCcyDec     ZDECS
116900200529      *
117000200529      *  NOMINAL DECIMAL PLACES
117100200529      *
117200200529     C                   Z-ADD     NMDP          ZNMDP
117300200529      *
117400200529      *  PROCESSING TYPE
117500200529      *
117600200529     C                   MOVE      PROT          ZPROT
117700200529      *
117800200529      *  SECURITY DETAILS
117900200529      *
118000200529     C                   Z-ADD     TCFC          ZTCFC
118100200529     C                   MOVE      SPBS          ZSPBS
118200200529      *
118300200529      ** Initialise conversion fields
118400200529      *
118500200529     C                   Z-ADD     *ZERO         ZEXCH
118600200529     C                   MOVE      *BLANK        ZMD
118700200529     C                   MOVE      *BLANK        ZCCYI
118800200529     C                   MOVE      *BLANK        ZCCYO
118900200529     C                   Z-ADD     *ZERO         ZCDPI
119000200529     C                   Z-ADD     *ZERO         ZCDPO
119100200529      *
119200200529      ** Initialise total fields
119300200529      *
119400200529     C                   Z-ADD     *ZERO         ZTCON
119500200529     C                   Z-ADD     *ZERO         ZTNOM
119600200529     C                   Z-ADD     *ZERO         ZTPI
119700200529     C                   Z-ADD     *ZERO         TOT_TCCA         15 0
119800200529      *
119900200529      ** Processing conditioned on Customer Commission switchable
120000200529      ** feature (S01446).
120100200529      *
120200200529     C     S01446        IFEQ      'Y'
120300200529      *
120400200529      ** If Adjust Commission for Same Day Trades is on, accumulate
120500200529      ** commission for same day trades. Also this should only be done
120600200529      ** if the subroutine has been called to calculate customer
120700200529      ** commission.
120800200529      *
120900200529     C     BVACSD        IFEQ      'Y'
121000200529     C     CalCstCom     ANDEQ     'Y'
121100200529     C                   EXSR      #ACCM
121200200529     C                   END
121300200529      *
121400200529      ** Add this trades purchased interest to the total
121500200529      *
121600200529     C                   ADD       ITRA          ZTPI
121700200529      *
121800200529      ** Set up fields required for the new call to ZCONV which has
121900200529      ** been added to ZCCAL1. Set to zero if the SE ICD Charge
122000200529      ** Currency is blank.
122100200529      *
122200200529     C     BVCHRC        IFNE      *BLANK
122300200529     C                   MOVE      ChgCcyEXRT    ZEXCH
122400200529     C                   MOVE      ChgCcyMDIN    ZMD
122500200529     C                   MOVE      BVCHRC        ZCCYI
122600200529     C                   MOVE      NMCY          ZCCYO
122700200529     C                   MOVE      ChgCcyDec     ZCDPI
122800200529     C                   MOVE      NomCcyDec     ZCDPO
122900200529     C                   END
123000200529      *
123100200529     C                   END
123200200529      *
123300200529     C                   EXSR      ZCCAL1
123400200529      *
123500200529      ** Processing conditioned on Customer Commission switchable
123600200529      ** feature (S01446). Also this should only be done if this
123700200529      ** subroutine has been called to calculate customer commission
123800200529      *
123900200529     C     S01446        IFEQ      'Y'
124000200529     C     CalCstCom     ANDEQ     'Y'
124100200529      *
124200200529      ** If Adjust Commission for Same Day Trades is on, then set
124300200529      ** the commission on this trade to the commission calculated
124400200529      ** above minus the commission already charged on todays trades
124500200529      ** of a similar type (from SR/#ACCM)
124600200529      *
124700200529     C     BVACSD        IFEQ      'Y'
124800200529     C                   SUB       TOT_TCCA      ZCHGA
124900200529     C                   END
125000200529     C                   END
125100200529      *
125200200529     C                   ENDSR
125300200529      *****************************************************************
125400200529      /EJECT
125500200529      *****************************************************************
125600200529      *                                                               *
125700200529      *  #ACCM   SUB ROUTINE TO ACCUMULATE AMOUNTS FOR SAME DAY       *
125800200529      *          TRADES                                               *
125900200529      *                                                               *
126000200529      *****************************************************************
126100200529     C     #ACCM         BEGSR
126200200529      *
126300200529      *  Access trades file with key of customer, security, trade type
126400200529      *  and trade date. These values are set to that of the trade
126500200529      *  being processed
126600200529      *
126700200529     C     KLTRADS       KLIST
126800200529     C                   KFLD                    F2TCNR
126900200529     C                   KFLD                    F2TDSS
127000200529     C                   KFLD                    F2TDTP
127100200529     C                   KFLD                    F2TDDT
127200200529      *
127300200529     C                   MOVE      TCNR          F2TCNR
127400200529     C                   MOVE      DDSESN        F2TDSS
127500200529     C                   MOVE      DDTDTP        F2TDTP
127600200529     C                   Z-ADD     TDDT          F2TDDT
127700200529      *
127800200529     C     KLTRADS       SETLL     TRADSDL2
127900200529     C     KLTRADS       READE     TRADSDL2                               44
128000200529      *
128100200529     C     *IN44         DOWEQ     '0'
128200200529      *
128300200529      *  Do not consider the trade being processed
128400200529      *
128500200529     C     F2TDRF        IFNE      DDTDRF
128600200529      *
128700200529      *  Accumulate total nominal, total purchased interest and total
128800200529      *  consideration
128900200529      *
129000200529     C                   ADD       F2NOML        ZTNOM
129100200529     C     F2ITRA        IFGT      *ZERO
129200200529     C                   ADD       F2ITRA        ZTPI
129300200529     C                   ELSE
129400200529     C                   SUB       F2ITRA        ZTPI
129500200529     C                   END
129600200529     C                   ADD       F2TCSR        ZTCON
129700200529      *
129800200529      *  Accumulate total Customer Commission amount. Add if the
129900200529      *  counterparty is a market client and the trade type is purchase
130000200529      *  or the counterparty is a portfolio client and the trade type
130100200529      *  is sale. Otherwise subtract.
130200200529      *
130300200529     C     CustClass     IFEQ      'M'
130400200529     C     F2TDTP        ANDEQ     'TP'
130500200529     C     CustClass     OREQ      'S'
130600200529     C     F2TDTP        ANDEQ     'TS'
130700200529     C     CustClass     OREQ      'D'
130800200529     C     F2TDTP        ANDEQ     'TS'
130900200529     C                   ADD       F2TCCA        TOT_TCCA
131000200529     C                   ELSE
131100200529     C                   SUB       F2TCCA        TOT_TCCA
131200200529     C                   END
131300200529     C*
131400200529     C                   END
131500200529      *
131600200529     C     KLTRADS       READE     TRADSDL2                               44
131700200529      *
131800200529     C                   END
131900200529      *
132000200529     C                   ENDSR
132100200529      *****************************************************************
132200200529      /EJECT
132300200529      *****************************************************************
132400200529      *                                                               *
132500200529      *  C_TAX - CALCULATE TAX ON CHARGE OR COMMISSION AMOUNT         *
132600200529      *                                                               *
132700200529      *****************************************************************
132800200529     C     C_TAX         BEGSR
132900200529      *
133000200529      *  IF TRADE TYPE IS PURCHASE AND LEVY ON SALE
133100200529      *  OR TRADE TYPE IS SALE AND LEVY ON PURCHASE
133200200529      *    TAX AMOUNT IS ZERO
133300200529      *  OTHERWISE CALCULATE IT
133400200529      *
133500200529     C     DDTDTP        IFEQ      'TP'
133600200529     C     TXC_LPSI      ANDEQ     'S'
133700200529     C     DDTDTP        OREQ      'TS'
133800200529     C     TXC_LPSI      ANDEQ     'P'
133900200529     C                   Z-ADD     *ZEROS        ZTAXA
134000200529     C                   ELSE
134100200529     C                   EXSR      C_TAX2
134200200529     C                   END
134300200529     C*
134400200529     C                   ENDSR
134500200529      *****************************************************************
134600200529      /EJECT
134700200529      *****************************************************************
134800200529      *                                                               *
134900200529      *  C_TAX2 - CALCULATE TAX ON CHARGE OR COMMISSION AMOUNT        *
135000200529      *                                                               *
135100200529      *****************************************************************
135200200529     C     C_TAX2        BEGSR
135300200529      *
135400200529      *  TAX CHARGE DETAILS
135500200529      *
135600200529     C                   MOVE      TXC_CHGB      ZCHGB
135700200529     C                   MOVE      TXC_THRI      ZTHRI
135800200529     C                   Z-ADD     TXC_MNCH      ZMNCH
135900200529     C                   Z-ADD     TXC_MXCH      ZMXCH
136000200529      *
136100200529      *  SET UP ARRAY FOR UPPER RANGE LIMITS
136200200529      *
136300200529     C                   Z-ADD     TXC_STU1      ZRA(1)
136400200529     C                   Z-ADD     TXC_STU2      ZRA(2)
136500200529     C                   Z-ADD     TXC_STU3      ZRA(3)
136600200529     C                   Z-ADD     TXC_STU4      ZRA(4)
136700200529     C                   Z-ADD     TXC_STU5      ZRA(5)
136800200529     C                   Z-ADD     TXC_STU6      ZRA(6)
136900200529     C                   Z-ADD     TXC_STU7      ZRA(7)
137000200529     C                   Z-ADD     TXC_STU8      ZRA(8)
137100200529     C                   Z-ADD     TXC_STU9      ZRA(9)
137200200529     C                   Z-ADD     TXC_ST10      ZRA(10)
137300200529     C                   Z-ADD     TXC_ST11      ZRA(11)
137400200529     C                   Z-ADD     TXC_ST12      ZRA(12)
137500200529     C                   Z-ADD     TXC_ST13      ZRA(13)
137600200529     C                   Z-ADD     TXC_ST14      ZRA(14)
137700200529      *
137800200529      *  SET UP ARRAY FOR PERCENTAGE LEVELS
137900200529      *
138000200529     C                   Z-ADD     TXC_PL01      ZPC(1)
138100200529     C                   Z-ADD     TXC_PL02      ZPC(2)
138200200529     C                   Z-ADD     TXC_PL03      ZPC(3)
138300200529     C                   Z-ADD     TXC_PL04      ZPC(4)
138400200529     C                   Z-ADD     TXC_PL05      ZPC(5)
138500200529     C                   Z-ADD     TXC_PL06      ZPC(6)
138600200529     C                   Z-ADD     TXC_PL07      ZPC(7)
138700200529     C                   Z-ADD     TXC_PL08      ZPC(8)
138800200529     C                   Z-ADD     TXC_PL09      ZPC(9)
138900200529     C                   Z-ADD     TXC_PL10      ZPC(10)
139000200529     C                   Z-ADD     TXC_PL11      ZPC(11)
139100200529     C                   Z-ADD     TXC_PL12      ZPC(12)
139200200529     C                   Z-ADD     TXC_PL13      ZPC(13)
139300200529     C                   Z-ADD     TXC_PL14      ZPC(14)
139400200529     C                   Z-ADD     TXC_PL15      ZPC(15)
139500200529      *
139600200529      *  SET UP ARRAY FOR FLAT CHARGES
139700200529      *
139800200529     C                   Z-ADD     TXC_FC01      ZCG(1)
139900200529     C                   Z-ADD     TXC_FC02      ZCG(2)
140000200529     C                   Z-ADD     TXC_FC03      ZCG(3)
140100200529     C                   Z-ADD     TXC_FC04      ZCG(4)
140200200529     C                   Z-ADD     TXC_FC05      ZCG(5)
140300200529     C                   Z-ADD     TXC_FC06      ZCG(6)
140400200529     C                   Z-ADD     TXC_FC07      ZCG(7)
140500200529     C                   Z-ADD     TXC_FC08      ZCG(8)
140600200529     C                   Z-ADD     TXC_FC09      ZCG(9)
140700200529     C                   Z-ADD     TXC_FC10      ZCG(10)
140800200529     C                   Z-ADD     TXC_FC11      ZCG(11)
140900200529     C                   Z-ADD     TXC_FC12      ZCG(12)
141000200529     C                   Z-ADD     TXC_FC13      ZCG(13)
141100200529     C                   Z-ADD     TXC_FC14      ZCG(14)
141200200529     C                   Z-ADD     TXC_FC15      ZCG(15)
141300200529      *
141400200529      ** Initialise conversion fields
141500200529      *
141600200529     C                   Z-ADD     *ZERO         ZEXCH
141700200529     C                   MOVE      *BLANK        ZMD
141800200529     C                   MOVE      *BLANK        ZCCYI
141900200529     C                   MOVE      *BLANK        ZCCYO
142000200529     C                   Z-ADD     *ZERO         ZCDPI
142100200529     C                   Z-ADD     *ZERO         ZCDPO
142200200529      *
142300200529      *  IF AMOUNT IS NEGATIVE MAKE IT POSITIVE WHILE CALCULATING
142400200529      *
142500200529     C     ZCHGA         IFLT      0
142600200529     C     ZCHGA         MULT      -1            ZCHGA
142700200529     C                   MOVE      'Y'           NEGCHG            1
142800200529     C                   END
142900200529      *
143000200529      *  CALCULATE TAX
143100200529      *
143200200529      ** Set up fields required for the call to ZCONV in ZTCAL1
143300200529      ** Set to zero if the SE ICD Charge Currency is blank.
143400200529      *
143500200529     C     BVCHRC        IFNE      *BLANK
143600200529     C                   MOVE      ChgCcyEXRT    ZEXCH
143700200529     C                   MOVE      ChgCcyMDIN    ZMD
143800200529     C                   MOVE      BVCHRC        ZCCYI
143900200529     C                   MOVE      NMCY          ZCCYO
144000200529     C                   MOVE      ChgCcyDec     ZCDPI
144100200529     C                   MOVE      NomCcyDec     ZCDPO
144200200529     C                   END
144300200529
144400200529     C                   EXSR      ZTCAL1
144500200529      *
144600200529      *    Reset sign
144700200529      *
144800200529     C     NEGCHG        IFEQ      'Y'
144900200529     C     ZTAXA         MULT      -1            ZTAXA
145000200529     C     ZCHGA         MULT      -1            ZCHGA
145100200529     C                   MOVE      ' '           NEGCHG            1
145200200529     C                   END
145300200529      *
145400200529     C                   ENDSR
145500200529      *****************************************************************
145600200529      /EJECT
145700200529      *****************************************************************
145800200529      *                                                               *
145900200529      *  ZCCAL1 - Calculate Charges/Commissions                       *
146000200529      *                                                               *
146100200529      *****************************************************************
146200200529     C     ZCCAL1        BEGSR
146300200529
146400200529     C                   CALLB     'ZCCAL'
146500200529
146600200529      * INPUTS
146700200529
146800200529      *
146900200529      * FROM THE CHARGE TYPES FILE
147000200529      *
147100200529     C                   PARM                    ZCHGB             1
147200200529     C                   PARM                    ZTHRI             1
147300200529     C                   PARM                    ZRA
147400200529     C                   PARM                    ZPC
147500200529     C                   PARM                    ZCG
147600200529     C                   PARM                    ZMNCH            15 0
147700200529     C                   PARM                    ZMXCH            15 0
147800200529      *
147900200529      * FROM THE TRADE/SECURITY
148000200529      *
148100200529     C                   PARM                    ZNOML            15 0
148200200529     C                   PARM                    ZPRICE           15 8
148300200529     C                   PARM                    ZDECS             1 0
148400200529     C                   PARM                    ZNMDP             1 0
148500200529     C                   PARM                    ZPROT             1
148600200529     C                   PARM                    ZTCFC            10 9
148700200529     C                   PARM                    ZSPBS             1
148800200529      *
148900200529      * EXCHANGE RATE, M/D IND, CURRENCIES & CURRENCY DECIMAL PLACES
149000200529      * FOR CHARGE CURRENCY TO NOMINAL CURRENCY CONVERSION
149100200529      *
149200200529     C                   PARM                    ZEXCH
149300200529     C                   PARM                    ZMD
149400200529     C                   PARM                    ZCCYI
149500200529     C                   PARM                    ZCCYO
149600200529     C                   PARM                    ZCDPI
149700200529     C                   PARM                    ZCDPO
149800200529      *
149900200529      *  New parameters for S01446
150000200529      *
150100200529     C                   PARM                    ZTCON            15 0
150200200529     C                   PARM                    ZTNOM            15 0
150300200529     C                   PARM                    ZTPI             15 0
150400200529     C                   PARM                    S01446            1
150500200529     C                   PARM                    BVACOP            1
150600200529
150700200529      * OUTPUTS
150800200529
150900200529      * CHARGE/COMMISSION AMOUNT CALCULATED
151000200529     C                   PARM      *ZERO         ZCHGA            15 0
151100200529
151200200529     C                   ENDSR
151300200529      *****************************************************************
151400200529      /EJECT
151500200529      *****************************************************************
151600200529      *                                                               *
151700200529      *  ZTCAL1 - Calculate Tax on Charges/Commissions                *
151800200529      *                                                               *
151900200529      *****************************************************************
152000200529     C     ZTCAL1        BEGSR
152100200529
152200200529     C                   CALLB     'ZTCAL'
152300200529
152400200529      * INPUTS
152500200529
152600200529      *
152700200529      * FROM THE CHARGE TYPES FILE
152800200529      *
152900200529     C                   PARM                    ZCHGB
153000200529     C                   PARM                    ZTHRI
153100200529     C                   PARM                    ZRA
153200200529     C                   PARM                    ZPC
153300200529     C                   PARM                    ZCG
153400200529     C                   PARM                    ZMNCH
153500200529     C                   PARM                    ZMXCH
153600200529      *
153700200529      * THE CHARGE/COMMISSION AMOUNT ON WHICH THE TAX IS TO BE LEVIED
153800200529      * (ZCHGA) PLUS THE CHARGE CURRENCY NUMBER OF DECIMAL PLACES
153900200529      *
154000200529     C                   PARM                    ZCHGA
154100200529     C                   PARM                    ZDECS
154200200529      *
154300200529      * EXCHANGE RATE, M/D IND, CURRENCIES & CURRENCY DECIMAL PLACES
154400200529      * FOR CHARGE CURRENCY TO NOMINAL CURRENCY CONVERSION
154500200529      *
154600200529     C                   PARM                    ZEXCH            13 8
154700200529     C                   PARM                    ZMD               1
154800200529     C                   PARM                    ZCCYI             3
154900200529     C                   PARM                    ZCCYO             3
155000200529     C                   PARM                    ZCDPI             1 0
155100200529     C                   PARM                    ZCDPO             1 0
155200200529      *
155300200529      *  New parameters for S01446
155400200529      *
155500200529     C                   PARM                    S01446
155600200529
155700200529      * OUTPUTS
155800200529
155900200529      * THE TAX CALCULATED (ZTAXA)
156000200529     C                   PARM      *ZERO         ZTAXA            15 0
156100200529
156200200529     C                   ENDSR
156300200529      *****************************************************************
156400200529      /EJECT
156500200529      *****************************************************************
156600200529      *                                                               *
156700200529      *  REBATE Sub routine to calculate rebate on customer and broker*
156800200529      *  commissions                                                  *
156900200529      *                                                               *
157000200529      *****************************************************************
157100200529     C     REBATE        BEGSR
157200200529      *
157300200529      * Initialise and fetch correct work field for result
157400200529      *
157500200529     C     NomCcyDec     IFEQ      0
157600200529     C                   Z-ADD     ZCHGA         #REB0            15 0
157700200529     C     #REB0         MULT      CMRP          #REB0
157800200529     C     #REB0         DIV       100           #REB0
157900200529     C     #REB0         MULT      -1            #REB0
158000200529     C                   END
158100200529     C     NomCcyDec     IFEQ      1
158200200529     C                   MOVE      ZCHGA         #REB1            15 1
158300200529     C     #REB1         MULT      CMRP          #REB1
158400200529     C     #REB1         DIV       100           #REB1
158500200529     C     #REB1         MULT      -1            #REB1
158600200529     C                   MOVE      #REB1         #REB0
158700200529     C                   END
158800200529     C     NomCcyDec     IFEQ      2
158900200529     C                   MOVE      ZCHGA         #REB2            15 2
159000200529     C     #REB2         MULT      CMRP          #REB2
159100200529     C     #REB2         DIV       100           #REB2
159200200529     C     #REB2         MULT      -1            #REB2
159300200529     C                   MOVE      #REB2         #REB0
159400200529     C                   END
159500200529     C     NomCcyDec     IFEQ      3
159600200529     C                   MOVE      ZCHGA         #REB3            15 3
159700200529     C     #REB3         MULT      CMRP          #REB3
159800200529     C     #REB3         DIV       100           #REB3
159900200529     C     #REB3         MULT      -1            #REB3
160000200529     C                   MOVE      #REB3         #REB0
160100200529     C                   END
160200200529      *
160300200529     C                   ENDSR
160400200529      *****************************************************************
160500200529      /EJECT
160600200529      *****************************************************************
160700200529      *                                                               *
160800200529      *  TXDETS Determine Counterparty Tax Details                    *
160900200529      *                                                               *
161000200529      *****************************************************************
161100200529     C     TXDETS        BEGSR
161200200529      *
161300200529      *  Access charges codes file using counterparty's tax code
161400200529      *  for tax details
161500200529      *
161600200529     C     KLSECGT       KLIST
161700200529     C                   KFLD                    @C_CCY            3
161800200529     C                   KFLD                    @C_CCOM           2
161900200529
162000200529     C                   MOVE      CustTAXC      @C_CCOM
162100200529
162200200529     C     KLSECGT       CHAIN     SECGT                              44
162300200529
162400200529      * If found and taxable, set up charge details
162500200529
162600200529     C     *IN44         IFEQ      '0'
162700200529     C     RECI          ANDEQ     'D'
162800200529     C                   MOVE      'Y'           TAX_CALC
162900200529     C                   MOVE      CHGB          TXC_CHGB
163000200529     C                   MOVE      THRI          TXC_THRI
163100200529     C                   MOVE      STU1          TXC_STU1
163200200529     C                   MOVE      STU2          TXC_STU2
163300200529     C                   MOVE      STU3          TXC_STU3
163400200529     C                   MOVE      STU4          TXC_STU4
163500200529     C                   MOVE      STU5          TXC_STU5
163600200529     C                   MOVE      STU6          TXC_STU6
163700200529     C                   MOVE      STU7          TXC_STU7
163800200529     C                   MOVE      STU8          TXC_STU8
163900200529     C                   MOVE      STU9          TXC_STU9
164000200529     C                   MOVE      ST10          TXC_ST10
164100200529     C                   MOVE      ST11          TXC_ST11
164200200529     C                   MOVE      ST12          TXC_ST12
164300200529     C                   MOVE      ST13          TXC_ST13
164400200529     C                   MOVE      ST14          TXC_ST14
164500200529     C                   MOVE      PL01          TXC_PL01
164600200529     C                   MOVE      PL02          TXC_PL02
164700200529     C                   MOVE      PL03          TXC_PL03
164800200529     C                   MOVE      PL04          TXC_PL04
164900200529     C                   MOVE      PL05          TXC_PL05
165000200529     C                   MOVE      PL06          TXC_PL06
165100200529     C                   MOVE      PL07          TXC_PL07
165200200529     C                   MOVE      PL08          TXC_PL08
165300200529     C                   MOVE      PL09          TXC_PL09
165400200529     C                   MOVE      PL10          TXC_PL10
165500200529     C                   MOVE      PL11          TXC_PL11
165600200529     C                   MOVE      PL12          TXC_PL12
165700200529     C                   MOVE      PL13          TXC_PL13
165800200529     C                   MOVE      PL14          TXC_PL14
165900200529     C                   MOVE      PL15          TXC_PL15
166000200529     C                   MOVE      FC01          TXC_FC01
166100200529     C                   MOVE      FC02          TXC_FC02
166200200529     C                   MOVE      FC03          TXC_FC03
166300200529     C                   MOVE      FC04          TXC_FC04
166400200529     C                   MOVE      FC05          TXC_FC05
166500200529     C                   MOVE      FC06          TXC_FC06
166600200529     C                   MOVE      FC07          TXC_FC07
166700200529     C                   MOVE      FC08          TXC_FC08
166800200529     C                   MOVE      FC09          TXC_FC09
166900200529     C                   MOVE      FC10          TXC_FC10
167000200529     C                   MOVE      FC11          TXC_FC11
167100200529     C                   MOVE      FC12          TXC_FC12
167200200529     C                   MOVE      FC13          TXC_FC13
167300200529     C                   MOVE      FC14          TXC_FC14
167400200529     C                   MOVE      FC15          TXC_FC15
167500200529     C                   MOVE      LPSI          TXC_LPSI
167600200529     C                   MOVE      MNCH          TXC_MNCH
167700200529     C                   MOVE      MXCH          TXC_MXCH
167800200529     C                   END
167900200529
168000200529     C                   ENDSR
168100200529      *****************************************************************
168200200529      /EJECT
168300200529      *****************************************************************
168400200529      *                                                               *
168500200529      * EDIT_AMT Edit an amount for display                           *
168600200529      *                                                               *
168700200529      *****************************************************************
168800200529     C     EDIT_AMT      BEGSR
168900200529
169000200529     C                   CALLB     'ZSEDIT'
169100200529     C                   PARM                    ZFLD15           15 0
169200200529     C                   PARM      NomCcyDec     ZDECS             1 0
169300200529     C                   PARM      *BLANK        ZECODE            1
169400200529     C                   PARM      *BLANK        ZOUT21           21
169500200529
169600200529     C                   ENDSR
169700200529      *****************************************************************
169800200529      /EJECT
169900200529      *****************************************************************
170000200529      *                                                               *
170100200529      * *INZSR - Program Initialisation routine                       *
170200200529      *                                                               *
170300200529      *****************************************************************
170400200529     C     *INZSR        BEGSR
170500200529
170600200529     C     *ENTRY        PLIST
170700200529
170800200529      * INPUTS
170900200529
171000200529      ** Trade reference
171100200529      ** Security
171200200529      ** Trade Type
171300200529     C                   PARM                    DDTDRF            6
171400200529     C                   PARM                    DDSESN           10
171500200529     C                   PARM                    DDTDTP            2
171600200529      *
171700200529      ** Trade Counterparty
171800200529      ** Trade Nominal
171900200529      ** Trade % price
172000200529      ** Trade Date
172100200529      ** Trade Purchased Interest
172200200529      ** Trade Current Factor
172300200529     C                   PARM                    TCNR
172400200529     C                   PARM                    NOML             11 0
172500200529     C                   PARM                    PRIC             15 8
172600200529     C                   PARM                    TDDT              5 0
172700200529     C                   PARM                    ITRA             13 0
172800200529     C                   PARM                    TCFC             10 9
172900200529      *
173000200529      ** Security & Investment Type details
173100200529     C                   PARM                    SECTY
173200200529     C                   PARM                    PROT              1
173300200529      *
173400200529      ** Nominal Currency Details
173500200529     C                   PARM                    NomCcyDts
173600200529      *
173700200529      ** Customer (Counterparty) Details
173800200529     C                   PARM                    CustDts
173900200529      *
174000200529      ** Commission Rebate %
174100200529     C                   PARM                    CMRP              5 3
174200200529      *
174300200529      ** Previous Trade Charges & Commissions
174400200529     C                   PARM                    @P_TRCC
174500200529      *
174600200529      ** Trade Charges & Commissions OK inds
174700200529     C                   PARM                    OKTrChCm
174800200529      *
174900200529      ** ICD
175000200529      ** Autocharge Option
175100200529      ** Securities Charges Currency
175200200529      ** Adjust Commission Same Day T
175300200529     C                   PARM                    BVACOP            1
175400200529     C                   PARM                    BVCHRC            3
175500200529     C                   PARM                    BVACSD            1
175600200529     C                   PARM                    S01446            1
175700200529
175800200529      * INPUTS & OUTPUTS
175900200529
176000200529      ** Trade Charges & commissions screen fields
176100200529
176200200529     C                   PARM                    TrChCm
176300200529
176400200529      ** Trade details
176500200529     C                   PARM                    TBCA             13 0
176600200529     C                   PARM                    TCCA             13 0
176700200529     C                   PARM                    TCA1             13 0
176800200529     C                   PARM                    TCA2             13 0
176900200529     C                   PARM                    TCA3             13 0                         S0117
177000200529     C                   PARM                    TCA4             13 0                         S0117
177100200529     C                   PARM                    TCA5             13 0                         S0117
177200200529     C                   PARM                    TCA6             13 0                         S0117
177300200529     C                   PARM                    TCA7             13 0                         S0117
177400200529     C                   PARM                    TAXA             13 0
177500200529     C                   PARM                    BCMR             13 0                         S0117
177600200529     C                   PARM                    CCMR             13 0                         S0117
177700200529     C                   PARM                    TXRB             13 0                         S0117
177800200529
177900200529
178000200529     C     *LIKE         DEFINE    CHGB          TXC_CHGB
178100200529     C     *LIKE         DEFINE    THRI          TXC_THRI
178200200529     C     *LIKE         DEFINE    MNCH          TXC_MNCH
178300200529     C     *LIKE         DEFINE    MXCH          TXC_MXCH
178400200529     C     *LIKE         DEFINE    STU1          TXC_STU1
178500200529     C     *LIKE         DEFINE    STU2          TXC_STU2
178600200529     C     *LIKE         DEFINE    STU3          TXC_STU3
178700200529     C     *LIKE         DEFINE    STU4          TXC_STU4
178800200529     C     *LIKE         DEFINE    STU5          TXC_STU5
178900200529     C     *LIKE         DEFINE    STU6          TXC_STU6
179000200529     C     *LIKE         DEFINE    STU7          TXC_STU7
179100200529     C     *LIKE         DEFINE    STU8          TXC_STU8
179200200529     C     *LIKE         DEFINE    STU9          TXC_STU9
179300200529     C     *LIKE         DEFINE    ST10          TXC_ST10
179400200529     C     *LIKE         DEFINE    ST11          TXC_ST11
179500200529     C     *LIKE         DEFINE    ST12          TXC_ST12
179600200529     C     *LIKE         DEFINE    ST13          TXC_ST13
179700200529     C     *LIKE         DEFINE    ST14          TXC_ST14
179800200529     C     *LIKE         DEFINE    PL01          TXC_PL01
179900200529     C     *LIKE         DEFINE    PL02          TXC_PL02
180000200529     C     *LIKE         DEFINE    PL03          TXC_PL03
180100200529     C     *LIKE         DEFINE    PL04          TXC_PL04
180200200529     C     *LIKE         DEFINE    PL05          TXC_PL05
180300200529     C     *LIKE         DEFINE    PL06          TXC_PL06
180400200529     C     *LIKE         DEFINE    PL07          TXC_PL07
180500200529     C     *LIKE         DEFINE    PL08          TXC_PL08
180600200529     C     *LIKE         DEFINE    PL09          TXC_PL09
180700200529     C     *LIKE         DEFINE    PL10          TXC_PL10
180800200529     C     *LIKE         DEFINE    PL11          TXC_PL11
180900200529     C     *LIKE         DEFINE    PL12          TXC_PL12
181000200529     C     *LIKE         DEFINE    PL13          TXC_PL13
181100200529     C     *LIKE         DEFINE    PL14          TXC_PL14
181200200529     C     *LIKE         DEFINE    PL15          TXC_PL15
181300200529     C     *LIKE         DEFINE    FC01          TXC_FC01
181400200529     C     *LIKE         DEFINE    FC02          TXC_FC02
181500200529     C     *LIKE         DEFINE    FC03          TXC_FC03
181600200529     C     *LIKE         DEFINE    FC04          TXC_FC04
181700200529     C     *LIKE         DEFINE    FC05          TXC_FC05
181800200529     C     *LIKE         DEFINE    FC06          TXC_FC06
181900200529     C     *LIKE         DEFINE    FC07          TXC_FC07
182000200529     C     *LIKE         DEFINE    FC08          TXC_FC08
182100200529     C     *LIKE         DEFINE    FC09          TXC_FC09
182200200529     C     *LIKE         DEFINE    FC10          TXC_FC10
182300200529     C     *LIKE         DEFINE    FC11          TXC_FC11
182400200529     C     *LIKE         DEFINE    FC12          TXC_FC12
182500200529     C     *LIKE         DEFINE    FC13          TXC_FC13
182600200529     C     *LIKE         DEFINE    FC14          TXC_FC14
182700200529     C     *LIKE         DEFINE    FC15          TXC_FC15
182800200529     C     *LIKE         DEFINE    LPSI          TXC_LPSI
182900200529
183000200529
183100200529
183200200529      ** Program, module and procedure names for database error processing.
183300200529      ** =================================================================
183400200529      ** The following /COPY sets these values
183500200529
183600200529     C/COPY ZACPYSRC,DBFIELDS
183700200529
183800200529     C                   ENDSR
183900200529      *****************************************************************
184000200529      /EJECT
184100200529      *****************************************************************
184200200529     C/COPY ZACPYSRC,PSSR_ILE
184300200529      ********************************************************************
184400200529**  CPY@
184500200529(c) Finastra International Limited 2001
