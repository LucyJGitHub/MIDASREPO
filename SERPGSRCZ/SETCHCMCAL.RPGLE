     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade Charges & Commissions Calculation')     *
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SETCHCMCAL - Trade Charges & Commissions Calculation         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. 258901             Date 22May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG7703            Date 09Sep05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP003  *CREATE    Date 28Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *  258901 - Error in tax amount for charges and commissions.    *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompiled)             *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  BUG7703 - Serious Midas Error encountered during INSERT      *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *           Recompiled due to database changes                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *           /COPY SE_CUSTDT changed                             *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

     FSECGT     IF   E           K DISK
     FTRADSDL2  IF   E           K DISK
     F                                     RENAME(TRADSDF:TRADSDF2)
     F                                     PREFIX(F2)

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

     D ZRA             S             15  0 DIM(15)                              RANGE LIMITS
     D ZPC             S              7  4 DIM(15)                              PERCENTAGES
     D ZCG             S             15  0 DIM(15)                              FLAT CHARGES


      ** Trade charges & commissions in screen format
     D TrChCm        E DS                  EXTNAME(SETRCCPD)

      ** Trade charges & commissions Ok indicators
     D OKTrChCm      E DS                  EXTNAME(SEETRCCPD)

      ** Previous Trade charges & commissions in screen format
     D @P_TRCC       E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(@P_)


      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)


      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT


      ** External data structure for currency details.
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      **Second DS for access programs, long data structure.
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D*TCNR*****       S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Clear calculated amounts

     C                   Z-ADD     0             Cal_TBCA         13 0
     C                   Z-ADD     0             Cal_TCCA         13 0
     C                   Z-ADD     0             Cal_TCA1         13 0
     C                   Z-ADD     0             Cal_TCA2         13 0
     C                   Z-ADD     0             Cal_TCA3         13 0
     C                   Z-ADD     0             Cal_TCA4         13 0
     C                   Z-ADD     0             Cal_TCA5         13 0
     C                   Z-ADD     0             Cal_TCA6         13 0
     C                   Z-ADD     0             Cal_TCA7         13 0
     C                   Z-ADD     0             Cal_TAXA         13 0
     C                   Z-ADD     0             Cal_BCMR         13 0
     C                   Z-ADD     0             Cal_CCMR         13 0
     C                   Z-ADD     0             Cal_TXRB         13 0
      *
      * Exit if AUTOCHARGE option not present
      *
     C     BVACOP        IFNE      'Y'
     C                   RETURN
     C                   END
      *
      * Calculate Charge Currency Cross Rate (Nominal -> Charge)
      *
     C     S01446        IFEQ      'Y'                                                         S0144
     C     BVCHRC        ANDNE     *BLANK                                                      S0144
     C                   EXSR      C_CHGXR
     C                   END
      *
      * Determine whether sign of charges/commissions should be reversed
      * (Dependent upon type of client and trade)
      *
     C     CustClass     IFEQ      'M'
     C     DDTDTP        ANDEQ     'TS'
     C     CustClass     OREQ      'S'
     C     DDTDTP        ANDEQ     'TP'
     C     CustClass     OREQ      'D'
     C     DDTDTP        ANDEQ     'TP'
     C                   MOVEL     'Y'           REV_SIGN          1
     C                   ELSE
     C                   MOVEL     'N'           REV_SIGN
     C                   END
      *
      * Reset notification of change indicators
      *
     C                   MOVEL     'N'           TBCA_Chgd         1
     C                   MOVEL     'N'           TCCA_Chgd         1
     C                   MOVEL     'N'           TCCx_Chgd         1
      *
      * All charge codes are in nominal currency
      *
     C                   MOVEL     NMCY          @C_CCY
      *
      * Initialize tax calculation ind
      *
     C                   MOVE      'N'           TAX_CALC          1
      *
      ** Determine Counterparty Tax Details
      *
     C     CustTAXC      IFNE      *BLANKS
     C                   EXSR      TXDETS
     C                   END
      *
      * Calculate Broker Commission Amount
      *
     C     DDTBCC        IFNE      *BLANKS
     C     ddTBCCok      ANDNE     'N'
     C                   EXSR      C_BROKCM
     C                   END
      *
      * Calculate Customer Commission Amount
      *
     C     DDTCCC        IFNE      *BLANKS
     C     ddTCCCok      ANDNE     'N'
     C                   EXSR      C_CUSTCM
     C                   END
      *
      * Calculate Charge Amount 1
      *
     C     DDTCC1        IFNE      *BLANKS
     C     ddTCC1ok      ANDNE     'N'
     C                   EXSR      C_CHRG1
     C                   END
      *
      * Calculate Charge Amount 2
      *
     C     DDTCC2        IFNE      *BLANKS
     C     ddTCC2ok      ANDNE     'N'
     C                   EXSR      C_CHRG2
     C                   END
      *
      * Calculate Charge Amount 3
      *
     C     DDTCC3        IFNE      *BLANKS
     C     ddTCC3ok      ANDNE     'N'
     C                   EXSR      C_CHRG3
     C                   END
      *
      * Calculate Charge Amount 4
      *
     C     DDTCC4        IFNE      *BLANKS
     C     ddTCC4ok      ANDNE     'N'
     C                   EXSR      C_CHRG4
     C                   END
      *
      * Calculate Charge Amount 5
      *
     C     DDTCC5        IFNE      *BLANKS
     C     ddTCC5ok      ANDNE     'N'
     C                   EXSR      C_CHRG5
     C                   END
      *
      * Calculate Charge Amount 6
      *
     C     DDTCC6        IFNE      *BLANKS
     C     ddTCC6ok      ANDNE     'N'
     C                   EXSR      C_CHRG6
     C                   END
      *
      * Calculate Charge Amount 7
      *
     C     DDTCC7        IFNE      *BLANKS
     C     ddTCC7ok      ANDNE     'N'
     C                   EXSR      C_CHRG7
     C                   END
      *
      * Calculate Tax Amount
      *
     C     TAX_CALC      IFEQ      'Y'
     C                   EXSR      C_TAXA
     C                   END
      *
      * Calculate Broker Commission Rebate
      *
     C     REBA_TBCA     IFEQ      'Y'
     C     TBCA          ANDNE     *ZEROS
     C     CMRP          ANDNE     *ZEROS
     C                   EXSR      C_BROKCMR
     C                   END
      *
      * Calculate Customer Commission Rebate
      *
     C     REBA_TCCA     IFEQ      'Y'
     C     TCCA          ANDNE     *ZEROS
     C     CMRP          ANDNE     *ZEROS
     C                   EXSR      C_CUSTCMR
     C                   END
      *
      * Calculate Tax Rebate
      *
     C     TAX_CALC      IFEQ      'Y'
     C                   EXSR      C_TAXREB
     C                   END
      *
      ** Return
      *
     C                   RETURN

      /EJECT
      *****************************************************************
      *                                                               *
      * C_CHGXR Calculate Charge Currency Cross Rate                  *
      *                                                               *
      *****************************************************************
     C     C_CHGXR       BEGSR
      *
      ** Get spot rate, multiply/divide indicator and number of
      ** decimal places of charging currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BVCHRC        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   Z-ADD     A6SPRT        ZRATE1
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     NomCcySPRT    ZRATE2
     C                   MOVE      NomCcyMDIN    ZMDI2
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM      *ZERO         ZRATEX           13 8
     C                   PARM      *BLANK        ZMDIX             1
      *
      ** Set up exchange rate & mult/div indicator of charging currency
      *
     C                   Z-ADD     ZRATEX        ChgCcyEXRT       13 8
     C                   MOVE      ZMDIX         ChgCCyMDIN        1
     C                   MOVE      A6NBDP        ChgCcyDec         1 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_BROKCM Calculate Broker Commission Amount                   *
      *                                                               *
      *****************************************************************
     C     C_BROKCM      BEGSR
      *
      * Calculate Broker Commission
      *
     C                   MOVEL     DDTBCC        @C_CCOM
      *
     C                   EXSR      C_CHCM
      *
      * Store tax and rebate indicator for broker commission
      *
     C                   MOVE      TXAP          TXAP_TBCA         1
     C                   MOVE      REBA          REBA_TBCA         1
      *
      *  Edit Broker Commission calculated
      *
     C                   Z-ADD     ZCHGA         Cal_TBCA

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      Cal_TBCA      ZFLD15
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTBCA       14
      *
      *  Override Broker commission if
      *  i.  the amount is blank, or
      *  ii. the code has changed and the amount hasn't
      *
     C     DDTBCA        IFEQ      *BLANK
     C     DDTBCC        ORNE      @P_DDTBCC
     C     DDTBCA        ANDEQ     @P_DDTBCA
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TBCA      TBCA
     C                   ELSE
     C                   Z-ADD     Cal_TBCA      TBCA
     C                   END
     C                   MOVE      Cal_DDTBCA    DDTBCA
     C                   MOVEL     'Y'           TBCA_Chgd
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_CUSTCM Calculate Customer Commission Amount                 *
      *                                                               *
      *****************************************************************
     C     C_CUSTCM      BEGSR
      *
      * Calculate Customer Commission
      *
     C                   MOVEL     DDTCCC        @C_CCOM
      *
     C                   MOVE      'Y'           CalCstCom         1
     C                   EXSR      C_CHCM
     C                   MOVE      'N'           CalCstCom
      *
      * Store tax and rebate indicator for customer commission
      *
     C                   MOVE      TXAP          TXAP_TCCA         1
     C                   MOVE      REBA          REBA_TCCA         1
      *
      *  Edit Customer Commission calculated
      *
     C                   Z-ADD     ZCHGA         Cal_TCCA

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      Cal_TCCA      ZFLD15
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTCCA       14
      *
      *  Override Customer commission if
      *  i.  the amount is blank, or
      *  ii. the code has changed and the amount hasn't
      *
     C     DDTCCA        IFEQ      *BLANK
     C     DDTCCC        ORNE      @P_DDTCCC
     C     DDTCCA        ANDEQ     @P_DDTCCA
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TCCA      TCCA
     C                   ELSE
     C                   Z-ADD     Cal_TCCA      TCCA
     C                   END
     C                   MOVE      Cal_DDTCCA    DDTCCA
     C                   MOVEL     'Y'           TCCA_Chgd
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_CHRG1 Calculate Charge Amount 1                             *
      *                                                               *
      *****************************************************************
     C     C_CHRG1       BEGSR
      *
      * Calculate Charge Amount 1
      *
     C                   MOVEL     DDTCC1        @C_CCOM
      *
     C                   EXSR      C_CHCM
      *
      * Store tax indicator for charge 1
      *
     C                   MOVE      TXAP          TXAP_TCA1         1
      *
      *  Edit Charge Amount 1 calculated
      *
     C                   Z-ADD     ZCHGA         Cal_TCA1

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      Cal_TCA1      ZFLD15
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTCA1       14
      *
      *  Override Charge Amount 1 if
      *  i.  the amount is blank, or
      *  ii. the code has changed and the amount hasn't
      *
     C     DDTCA1        IFEQ      *BLANK
     C     DDTCC1        ORNE      @P_DDTCC1
     C     DDTCA1        ANDEQ     @P_DDTCA1
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TCA1      TCA1
     C                   ELSE
     C                   Z-ADD     Cal_TCA1      TCA1
     C                   END
     C                   MOVE      Cal_DDTCA1    DDTCA1
     C                   MOVEL     'Y'           TCCx_Chgd
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_CHRG2 Calculate Charge Amount 2                             *
      *                                                               *
      *****************************************************************
     C     C_CHRG2       BEGSR
      *
      * Calculate Charge Amount 2
      *
     C                   MOVEL     DDTCC2        @C_CCOM
      *
     C                   EXSR      C_CHCM
      *
      * Store tax indicator for charge 2
      *
     C                   MOVE      TXAP          TXAP_TCA2         1
      *
      *  Edit Charge Amount 2 calculated
      *
     C                   Z-ADD     ZCHGA         Cal_TCA2

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      Cal_TCA2      ZFLD15
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTCA2       14
      *
      *  Override Charge Amount 2 if
      *  i.  the amount is blank, or
      *  ii. the code has changed and the amount hasn't
      *
     C     DDTCA2        IFEQ      *BLANK
     C     DDTCC2        ORNE      @P_DDTCC2
     C     DDTCA2        ANDEQ     @P_DDTCA2
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TCA2      TCA2
     C                   ELSE
     C                   Z-ADD     Cal_TCA2      TCA2
     C                   END
     C                   MOVE      Cal_DDTCA2    DDTCA2
     C                   MOVEL     'Y'           TCCx_Chgd
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_CHRG3 Calculate Charge Amount 3                             *
      *                                                               *
      *****************************************************************
     C     C_CHRG3       BEGSR
      *
      * Calculate Charge Amount 3
      *
     C                   MOVEL     DDTCC3        @C_CCOM
      *
     C                   EXSR      C_CHCM
      *
      * Store tax indicator for charge 3
      *
     C                   MOVE      TXAP          TXAP_TCA3         1
      *
      *  Edit Charge Amount 3 calculated
      *
     C                   Z-ADD     ZCHGA         Cal_TCA3

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      Cal_TCA3      ZFLD15
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTCA3       14
      *
      *  Override Charge Amount 3 if
      *  i.  the amount is blank, or
      *  ii. the code has changed and the amount hasn't
      *
     C     DDTCA3        IFEQ      *BLANK
     C     DDTCC3        ORNE      @P_DDTCC3
     C     DDTCA3        ANDEQ     @P_DDTCA3
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TCA3      TCA3
     C                   ELSE
     C                   Z-ADD     Cal_TCA3      TCA3
     C                   END
     C                   MOVE      Cal_DDTCA3    DDTCA3
     C                   MOVEL     'Y'           TCCx_Chgd
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_CHRG4 Calculate Charge Amount 4                             *
      *                                                               *
      *****************************************************************
     C     C_CHRG4       BEGSR
      *
      * Calculate Charge Amount 4
      *
     C                   MOVEL     DDTCC4        @C_CCOM
      *
     C                   EXSR      C_CHCM
      *
      * Store tax indicator for charge 4
      *
     C                   MOVE      TXAP          TXAP_TCA4         1
      *
      *  Edit Charge Amount 4 calculated
      *
     C                   Z-ADD     ZCHGA         Cal_TCA4

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      Cal_TCA4      ZFLD15
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTCA4       14
      *
      *  Override Charge Amount 4 if
      *  i.  the amount is blank, or
      *  ii. the code has changed and the amount hasn't
      *
     C     DDTCA4        IFEQ      *BLANK
     C     DDTCC4        ORNE      @P_DDTCC4
     C     DDTCA4        ANDEQ     @P_DDTCA4
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TCA4      TCA4
     C                   ELSE
     C                   Z-ADD     Cal_TCA4      TCA4
     C                   END
     C                   MOVE      Cal_DDTCA4    DDTCA4
     C                   MOVEL     'Y'           TCCx_Chgd
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_CHRG5 Calculate Charge Amount 5                             *
      *                                                               *
      *****************************************************************
     C     C_CHRG5       BEGSR
      *
      * Calculate Charge Amount 5
      *
     C                   MOVEL     DDTCC5        @C_CCOM
      *
     C                   EXSR      C_CHCM
      *
      * Store tax indicator for charge 5
      *
     C                   MOVE      TXAP          TXAP_TCA5         1
      *
      *  Edit Charge Amount 5 calculated
      *
     C                   Z-ADD     ZCHGA         Cal_TCA5

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      Cal_TCA5      ZFLD15
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTCA5       14
      *
      *  Override Charge Amount 5 if
      *  i.  the amount is blank, or
      *  ii. the code has changed and the amount hasn't
      *
     C     DDTCA5        IFEQ      *BLANK
     C     DDTCC5        ORNE      @P_DDTCC5
     C     DDTCA5        ANDEQ     @P_DDTCA5
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TCA5      TCA5
     C                   ELSE
     C                   Z-ADD     Cal_TCA5      TCA5
     C                   END
     C                   MOVE      Cal_DDTCA5    DDTCA5
     C                   MOVEL     'Y'           TCCx_Chgd
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_CHRG6 Calculate Charge Amount 6                             *
      *                                                               *
      *****************************************************************
     C     C_CHRG6       BEGSR
      *
      * Calculate Charge Amount 6
      *
     C                   MOVEL     DDTCC6        @C_CCOM
      *
     C                   EXSR      C_CHCM
      *
      * Store tax indicator for charge 6
      *
     C                   MOVE      TXAP          TXAP_TCA6         1
      *
      *  Edit Charge Amount 6 calculated
      *
     C                   Z-ADD     ZCHGA         Cal_TCA6

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      Cal_TCA6      ZFLD15
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTCA6       14
      *
      *  Override Charge Amount 6 if
      *  i.  the amount is blank, or
      *  ii. the code has changed and the amount hasn't
      *
     C     DDTCA6        IFEQ      *BLANK
     C     DDTCC6        ORNE      @P_DDTCC6
     C     DDTCA6        ANDEQ     @P_DDTCA6
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TCA6      TCA6
     C                   ELSE
     C                   Z-ADD     Cal_TCA6      TCA6
     C                   END
     C                   MOVE      Cal_DDTCA6    DDTCA6
     C                   MOVEL     'Y'           TCCx_Chgd
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_CHRG7 Calculate Charge Amount 7                             *
      *                                                               *
      *****************************************************************
     C     C_CHRG7       BEGSR
      *
      * Calculate Charge Amount 7
      *
     C                   MOVEL     DDTCC7        @C_CCOM
      *
     C                   EXSR      C_CHCM
      *
      * Store tax indicator for charge 7
      *
     C                   MOVE      TXAP          TXAP_TCA7         1
      *
      *  Edit Charge Amount 7 calculated
      *
     C                   Z-ADD     ZCHGA         Cal_TCA7

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      Cal_TCA7      ZFLD15
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTCA7       14
      *
      *  Override Charge Amount 7 if
      *  i.  the amount is blank, or
      *  ii. the code has changed and the amount hasn't
      *
     C     DDTCA7        IFEQ      *BLANK
     C     DDTCC7        ORNE      @P_DDTCC7
     C     DDTCA7        ANDEQ     @P_DDTCA7
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TCA7      TCA7
     C                   ELSE
     C                   Z-ADD     Cal_TCA7      TCA7
     C                   END
     C                   MOVE      Cal_DDTCA7    DDTCA7
     C                   MOVEL     'Y'           TCCx_Chgd
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_TAXA Calculate Tax Amount                                   *
      *                                                               *
      *****************************************************************
     C     C_TAXA        BEGSR
      *
      * Initialize total tax
      *
     C                   Z-ADD     *ZEROS        Cal_TAXA
      *
      *  Get tax due on broker commission
      *
     C     TXAP_TBCA     IFEQ      'Y'
     C     TBCA          ANDNE     *ZERO
     C                   Z-ADD     TBCA          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TAXA
     C                   END
      *
      *  Get tax due on customer commission
      *
     C     TXAP_TCCA     IFEQ      'Y'
     C     TCCA          ANDNE     *ZERO
     C                   Z-ADD     TCCA          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TAXA
     C                   END
      *
      *  Get tax due on Charge Code 1
      *
     C     TXAP_TCA1     IFEQ      'Y'
     C     TCA1          ANDNE     *ZERO
     C                   Z-ADD     TCA1          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TAXA
     C                   END
      *
      *  Get tax due on Charge Code 2
      *
     C     TXAP_TCA2     IFEQ      'Y'
     C     TCA2          ANDNE     *ZERO
     C                   Z-ADD     TCA2          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TAXA
     C                   END
      *
      *  Get tax due on Charge Code 3
      *
     C     TXAP_TCA3     IFEQ      'Y'
     C     TCA3          ANDNE     *ZERO
     C                   Z-ADD     TCA3          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TAXA
     C                   END
      *
      *  Get tax due on Charge Code 4
      *
     C     TXAP_TCA4     IFEQ      'Y'
     C     TCA4          ANDNE     *ZERO
     C                   Z-ADD     TCA4          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TAXA
     C                   END
      *
      *  Get tax due on Charge Code 5
      *
     C     TXAP_TCA5     IFEQ      'Y'
     C     TCA5          ANDNE     *ZERO
     C                   Z-ADD     TCA5          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TAXA
     C                   END
      *
      *  Get tax due on Charge Code 6
      *
     C     TXAP_TCA6     IFEQ      'Y'
     C     TCA6          ANDNE     *ZERO
     C                   Z-ADD     TCA6          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TAXA
     C                   END
      *
      *  Get tax due on Charge Code 7
      *
     C     TXAP_TCA7     IFEQ      'Y'
     C     TCA7          ANDNE     *ZERO
     C                   Z-ADD     TCA7          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TAXA
     C                   END
      *
      * Tax amount is tax total
      *
     C                   MOVE      *BLANKS       ZFLD15
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TAXA      ZFLD15
     C                   ELSE
     C                   Z-ADD     Cal_TAXA      ZFLD15
     C                   END
     C     Cal_TAXA      IFNE      *ZEROS                                                    BUG7703
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTAXA       14
     C                   ELSE                                                                 258901
     C                   MOVE      *BLANKS       Cal_DDTAXA                                   258901
     C                   ENDIF                                                               BUG7703
      *
      *  Override Tax Amount if
      *  i.  the amount is blank, or
      *  ii. broker commission, customer commission or a charge amount
      *      has changed but the the tax amount hasn't been changed
      *
     C     DDTAXA        IFEQ      *BLANK
     C     TBCA_Chgd     OREQ      'Y'
     C     DDTAXA        ANDEQ     @P_DDTAXA
     C     TCCA_Chgd     OREQ      'Y'
     C     DDTAXA        ANDEQ     @P_DDTAXA
     C     TCCx_Chgd     OREQ      'Y'
     C     DDTAXA        ANDEQ     @P_DDTAXA
     C                   Z-ADD     Cal_TAXA      TAXA
     C                   MOVE      Cal_DDTAXA    DDTAXA
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_BROKCMR Calculate Broker Commission Rebate                  *
      *                                                               *
      *****************************************************************
     C     C_BROKCMR     BEGSR
      *
      *  Calculate Broker Commission Rebate
      *
     C                   Z-ADD     TBCA          ZCHGA
     C                   EXSR      REBATE
     C                   Z-ADD     #REB0         Cal_BCMR
      *
      *  Edit Broker Commission Rebate
      *
     C     Cal_BCMR      IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_BCMR      ZFLD15
     C                   ELSE
     C                   Z-ADD     Cal_BCMR      ZFLD15
     C                   END
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDBCMR       14
     C                   END
      *
      *  Override Broker Commission Rebate
      *  i.  the amount is blank, or
      *  ii. the broker commission has been changed
      *      but the broker commission rebate hasn't been changed
      *
     C     DDBCMR        IFEQ      *BLANK
     C     TBCA_Chgd     OREQ      'Y'
     C     DDBCMR        ANDEQ     @P_DDBCMR
     C                   Z-ADD     Cal_BCMR      BCMR
     C                   MOVE      Cal_DDBCMR    DDBCMR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_CUSTCMR Calculate Customer Commission Rebate                *
      *                                                               *
      *****************************************************************
     C     C_CUSTCMR     BEGSR
      *
      *  Calculate Customer Commission Rebate
      *
     C                   Z-ADD     TCCA          ZCHGA
     C                   EXSR      REBATE
     C                   Z-ADD     #REB0         Cal_CCMR
      *
      *  Edit Customer Commission Rebate
      *
     C     Cal_CCMR      IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_CCMR      ZFLD15
     C                   ELSE
     C                   Z-ADD     Cal_CCMR      ZFLD15
     C                   END
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDCCMR       14
     C                   END
      *
      *  Override Customer Commission Rebate
      *  i.  the amount is blank, or
      *  ii. the customer commission has been changed
      *      but the customer commission rebate hasn't been changed
      *
     C     DDCCMR        IFEQ      *BLANK
     C     TCCA_Chgd     OREQ      'Y'
     C     DDCCMR        ANDEQ     @P_DDCCMR
     C                   Z-ADD     Cal_CCMR      CCMR
     C                   MOVE      Cal_DDCCMR    DDCCMR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_TAXREB Calculate Tax Rebate                                 *
      *                                                               *
      *****************************************************************
     C     C_TAXREB      BEGSR
      *
      * Initialize total rebate tax
      *
     C                   Z-ADD     *ZEROS        Cal_TXRB
      *
      *  Get tax due on broker commission rebate
      *
     C     BCMR          IFNE      *ZERO
     C                   Z-ADD     BCMR          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TXRB
     C                   END
      *
      *  Get tax due on customer commission rebate
      *
     C     CCMR          IFNE      *ZERO
     C                   Z-ADD     CCMR          ZCHGA
     C                   EXSR      C_TAX
     C                   ADD       ZTAXA         Cal_TXRB
     C                   END
      *
      * Default rebate tax amount is rebate tax total
      *
     C     Cal_TXRB      IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C     REV_SIGN      IFEQ      'Y'
     C                   Z-SUB     Cal_TXRB      ZFLD15
     C                   ELSE
     C                   Z-ADD     Cal_TXRB      ZFLD15
     C                   END
     C                   EXSR      EDIT_AMT
     C                   MOVE      ZOUT21        Cal_DDTXRB       14
     C                   END
      *
      *  Override Tax Rebate
      *  i.  the amount is blank, or
      *  ii. the customer or broker commission rebate have changed
      *
     C     DDTXRB        IFEQ      *BLANK
     C     TBCA_Chgd     OREQ      'Y'
     C     TCCA_Chgd     OREQ      'Y'
     C                   Z-ADD     Cal_TXRB      TXRB
     C                   MOVE      Cal_DDTXRB    DDTXRB
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  C_CHCM - CALCULATE CHARGE OR COMMISSION AMOUNT               *
      *                                                               *
      *****************************************************************
     C     C_CHCM        BEGSR
      *
      ** GET CHARGE/COMMISSION CODE DETAILS
      *
     C     KLSECGT       CHAIN     SECGT                              21
      *
      * IF NO LIVE RECORD FOUND,
      *    CHARGE OR COMMISSION AMOUNT IS ZERO
      *    TAX INDICATOR IS NULL
      *
     C     *IN21         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   Z-ADD     *ZEROS        ZCHGA
     C                   MOVEL     *BLANK        TXAP
     C                   END
      *
     C     *IN21         IFEQ      '0'
     C     RECI          ANDEQ     'D'
      *
      *  IF TRADE TYPE IS PURCHASE AND LEVY ON SALE
      *  OR TRADE TYPE IS SALE AND LEVY ON PURCHASE
      *    CHARGE OR COMMISSION AMOUNT IS ZERO
      *  OTHERWISE CALCULATE IT
      *
     C     DDTDTP        IFEQ      'TP'
     C     LPSI          ANDEQ     'S'
     C     DDTDTP        OREQ      'TS'
     C     LPSI          ANDEQ     'P'
     C                   Z-ADD     *ZEROS        ZCHGA
     C                   ELSE
     C                   EXSR      C_CHCM2
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  C_CHCM2 - CALCULATE CHARGE OR COMMISSION AMOUNT              *
      *                                                               *
      *****************************************************************
     C     C_CHCM2       BEGSR
      *
      *  CHARGE DETAILS
      *
     C                   MOVE      CHGB          ZCHGB
     C                   MOVE      THRI          ZTHRI
     C                   Z-ADD     MNCH          ZMNCH
     C                   Z-ADD     MXCH          ZMXCH
      *
      *  SET UP ARRAY FOR UPPER RANGE LIMITS
      *
     C                   Z-ADD     STU1          ZRA(1)
     C                   Z-ADD     STU2          ZRA(2)
     C                   Z-ADD     STU3          ZRA(3)
     C                   Z-ADD     STU4          ZRA(4)
     C                   Z-ADD     STU5          ZRA(5)
     C                   Z-ADD     STU6          ZRA(6)
     C                   Z-ADD     STU7          ZRA(7)
     C                   Z-ADD     STU8          ZRA(8)
     C                   Z-ADD     STU9          ZRA(9)
     C                   Z-ADD     ST10          ZRA(10)
     C                   Z-ADD     ST11          ZRA(11)
     C                   Z-ADD     ST12          ZRA(12)
     C                   Z-ADD     ST13          ZRA(13)
     C                   Z-ADD     ST14          ZRA(14)
      *
      *  SET UP ARRAY FOR PERCENTAGE LEVELS
      *
     C                   Z-ADD     PL01          ZPC(1)
     C                   Z-ADD     PL02          ZPC(2)
     C                   Z-ADD     PL03          ZPC(3)
     C                   Z-ADD     PL04          ZPC(4)
     C                   Z-ADD     PL05          ZPC(5)
     C                   Z-ADD     PL06          ZPC(6)
     C                   Z-ADD     PL07          ZPC(7)
     C                   Z-ADD     PL08          ZPC(8)
     C                   Z-ADD     PL09          ZPC(9)
     C                   Z-ADD     PL10          ZPC(10)
     C                   Z-ADD     PL11          ZPC(11)
     C                   Z-ADD     PL12          ZPC(12)
     C                   Z-ADD     PL13          ZPC(13)
     C                   Z-ADD     PL14          ZPC(14)
     C                   Z-ADD     PL15          ZPC(15)
      *
      *  SET UP ARRAY FOR FLAT CHARGES
      *
     C                   Z-ADD     FC01          ZCG(1)
     C                   Z-ADD     FC02          ZCG(2)
     C                   Z-ADD     FC03          ZCG(3)
     C                   Z-ADD     FC04          ZCG(4)
     C                   Z-ADD     FC05          ZCG(5)
     C                   Z-ADD     FC06          ZCG(6)
     C                   Z-ADD     FC07          ZCG(7)
     C                   Z-ADD     FC08          ZCG(8)
     C                   Z-ADD     FC09          ZCG(9)
     C                   Z-ADD     FC10          ZCG(10)
     C                   Z-ADD     FC11          ZCG(11)
     C                   Z-ADD     FC12          ZCG(12)
     C                   Z-ADD     FC13          ZCG(13)
     C                   Z-ADD     FC14          ZCG(14)
     C                   Z-ADD     FC15          ZCG(15)
      *
      *  TRADE NOMINAL
      *
     C                   MOVE      NOML          ZNOML
      *
      *  TRADE % PRICE
      *
     C                   MOVE      PRIC          ZPRICE
      *
      *  NOMINAL CURRENCY DECIMAL PLACES
      *
     C                   Z-ADD     NomCcyDec     ZDECS
      *
      *  NOMINAL DECIMAL PLACES
      *
     C                   Z-ADD     NMDP          ZNMDP
      *
      *  PROCESSING TYPE
      *
     C                   MOVE      PROT          ZPROT
      *
      *  SECURITY DETAILS
      *
     C                   Z-ADD     TCFC          ZTCFC
     C                   MOVE      SPBS          ZSPBS
      *
      ** Initialise conversion fields
      *
     C                   Z-ADD     *ZERO         ZEXCH
     C                   MOVE      *BLANK        ZMD
     C                   MOVE      *BLANK        ZCCYI
     C                   MOVE      *BLANK        ZCCYO
     C                   Z-ADD     *ZERO         ZCDPI
     C                   Z-ADD     *ZERO         ZCDPO
      *
      ** Initialise total fields
      *
     C                   Z-ADD     *ZERO         ZTCON
     C                   Z-ADD     *ZERO         ZTNOM
     C                   Z-ADD     *ZERO         ZTPI
     C                   Z-ADD     *ZERO         TOT_TCCA         15 0
      *
      ** Processing conditioned on Customer Commission switchable
      ** feature (S01446).
      *
     C     S01446        IFEQ      'Y'
      *
      ** If Adjust Commission for Same Day Trades is on, accumulate
      ** commission for same day trades. Also this should only be done
      ** if the subroutine has been called to calculate customer
      ** commission.
      *
     C     BVACSD        IFEQ      'Y'
     C     CalCstCom     ANDEQ     'Y'
     C                   EXSR      #ACCM
     C                   END
      *
      ** Add this trades purchased interest to the total
      *
     C                   ADD       ITRA          ZTPI
      *
      ** Set up fields required for the new call to ZCONV which has
      ** been added to ZCCAL1. Set to zero if the SE ICD Charge
      ** Currency is blank.
      *
     C     BVCHRC        IFNE      *BLANK
     C                   MOVE      ChgCcyEXRT    ZEXCH
     C                   MOVE      ChgCcyMDIN    ZMD
     C                   MOVE      BVCHRC        ZCCYI
     C                   MOVE      NMCY          ZCCYO
     C                   MOVE      ChgCcyDec     ZCDPI
     C                   MOVE      NomCcyDec     ZCDPO
     C                   END
      *
     C                   END
      *
     C                   EXSR      ZCCAL1
      *
      ** Processing conditioned on Customer Commission switchable
      ** feature (S01446). Also this should only be done if this
      ** subroutine has been called to calculate customer commission
      *
     C     S01446        IFEQ      'Y'
     C     CalCstCom     ANDEQ     'Y'
      *
      ** If Adjust Commission for Same Day Trades is on, then set
      ** the commission on this trade to the commission calculated
      ** above minus the commission already charged on todays trades
      ** of a similar type (from SR/#ACCM)
      *
     C     BVACSD        IFEQ      'Y'
     C                   SUB       TOT_TCCA      ZCHGA
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  #ACCM   SUB ROUTINE TO ACCUMULATE AMOUNTS FOR SAME DAY       *
      *          TRADES                                               *
      *                                                               *
      *****************************************************************
     C     #ACCM         BEGSR
      *
      *  Access trades file with key of customer, security, trade type
      *  and trade date. These values are set to that of the trade
      *  being processed
      *
     C     KLTRADS       KLIST
     C                   KFLD                    F2TCNR
     C                   KFLD                    F2TDSS
     C                   KFLD                    F2TDTP
     C                   KFLD                    F2TDDT
      *
     C                   MOVE      TCNR          F2TCNR
     C                   MOVE      DDSESN        F2TDSS
     C                   MOVE      DDTDTP        F2TDTP
     C                   Z-ADD     TDDT          F2TDDT
      *
     C     KLTRADS       SETLL     TRADSDL2
     C     KLTRADS       READE     TRADSDL2                               44
      *
     C     *IN44         DOWEQ     '0'
      *
      *  Do not consider the trade being processed
      *
     C     F2TDRF        IFNE      DDTDRF
      *
      *  Accumulate total nominal, total purchased interest and total
      *  consideration
      *
     C                   ADD       F2NOML        ZTNOM
     C     F2ITRA        IFGT      *ZERO
     C                   ADD       F2ITRA        ZTPI
     C                   ELSE
     C                   SUB       F2ITRA        ZTPI
     C                   END
     C                   ADD       F2TCSR        ZTCON
      *
      *  Accumulate total Customer Commission amount. Add if the
      *  counterparty is a market client and the trade type is purchase
      *  or the counterparty is a portfolio client and the trade type
      *  is sale. Otherwise subtract.
      *
     C     CustClass     IFEQ      'M'
     C     F2TDTP        ANDEQ     'TP'
     C     CustClass     OREQ      'S'
     C     F2TDTP        ANDEQ     'TS'
     C     CustClass     OREQ      'D'
     C     F2TDTP        ANDEQ     'TS'
     C                   ADD       F2TCCA        TOT_TCCA
     C                   ELSE
     C                   SUB       F2TCCA        TOT_TCCA
     C                   END
     C*
     C                   END
      *
     C     KLTRADS       READE     TRADSDL2                               44
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  C_TAX - CALCULATE TAX ON CHARGE OR COMMISSION AMOUNT         *
      *                                                               *
      *****************************************************************
     C     C_TAX         BEGSR
      *
      *  IF TRADE TYPE IS PURCHASE AND LEVY ON SALE
      *  OR TRADE TYPE IS SALE AND LEVY ON PURCHASE
      *    TAX AMOUNT IS ZERO
      *  OTHERWISE CALCULATE IT
      *
     C     DDTDTP        IFEQ      'TP'
     C     TXC_LPSI      ANDEQ     'S'
     C     DDTDTP        OREQ      'TS'
     C     TXC_LPSI      ANDEQ     'P'
     C                   Z-ADD     *ZEROS        ZTAXA
     C                   ELSE
     C                   EXSR      C_TAX2
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  C_TAX2 - CALCULATE TAX ON CHARGE OR COMMISSION AMOUNT        *
      *                                                               *
      *****************************************************************
     C     C_TAX2        BEGSR
      *
      *  TAX CHARGE DETAILS
      *
     C                   MOVE      TXC_CHGB      ZCHGB
     C                   MOVE      TXC_THRI      ZTHRI
     C                   Z-ADD     TXC_MNCH      ZMNCH
     C                   Z-ADD     TXC_MXCH      ZMXCH
      *
      *  SET UP ARRAY FOR UPPER RANGE LIMITS
      *
     C                   Z-ADD     TXC_STU1      ZRA(1)
     C                   Z-ADD     TXC_STU2      ZRA(2)
     C                   Z-ADD     TXC_STU3      ZRA(3)
     C                   Z-ADD     TXC_STU4      ZRA(4)
     C                   Z-ADD     TXC_STU5      ZRA(5)
     C                   Z-ADD     TXC_STU6      ZRA(6)
     C                   Z-ADD     TXC_STU7      ZRA(7)
     C                   Z-ADD     TXC_STU8      ZRA(8)
     C                   Z-ADD     TXC_STU9      ZRA(9)
     C                   Z-ADD     TXC_ST10      ZRA(10)
     C                   Z-ADD     TXC_ST11      ZRA(11)
     C                   Z-ADD     TXC_ST12      ZRA(12)
     C                   Z-ADD     TXC_ST13      ZRA(13)
     C                   Z-ADD     TXC_ST14      ZRA(14)
      *
      *  SET UP ARRAY FOR PERCENTAGE LEVELS
      *
     C                   Z-ADD     TXC_PL01      ZPC(1)
     C                   Z-ADD     TXC_PL02      ZPC(2)
     C                   Z-ADD     TXC_PL03      ZPC(3)
     C                   Z-ADD     TXC_PL04      ZPC(4)
     C                   Z-ADD     TXC_PL05      ZPC(5)
     C                   Z-ADD     TXC_PL06      ZPC(6)
     C                   Z-ADD     TXC_PL07      ZPC(7)
     C                   Z-ADD     TXC_PL08      ZPC(8)
     C                   Z-ADD     TXC_PL09      ZPC(9)
     C                   Z-ADD     TXC_PL10      ZPC(10)
     C                   Z-ADD     TXC_PL11      ZPC(11)
     C                   Z-ADD     TXC_PL12      ZPC(12)
     C                   Z-ADD     TXC_PL13      ZPC(13)
     C                   Z-ADD     TXC_PL14      ZPC(14)
     C                   Z-ADD     TXC_PL15      ZPC(15)
      *
      *  SET UP ARRAY FOR FLAT CHARGES
      *
     C                   Z-ADD     TXC_FC01      ZCG(1)
     C                   Z-ADD     TXC_FC02      ZCG(2)
     C                   Z-ADD     TXC_FC03      ZCG(3)
     C                   Z-ADD     TXC_FC04      ZCG(4)
     C                   Z-ADD     TXC_FC05      ZCG(5)
     C                   Z-ADD     TXC_FC06      ZCG(6)
     C                   Z-ADD     TXC_FC07      ZCG(7)
     C                   Z-ADD     TXC_FC08      ZCG(8)
     C                   Z-ADD     TXC_FC09      ZCG(9)
     C                   Z-ADD     TXC_FC10      ZCG(10)
     C                   Z-ADD     TXC_FC11      ZCG(11)
     C                   Z-ADD     TXC_FC12      ZCG(12)
     C                   Z-ADD     TXC_FC13      ZCG(13)
     C                   Z-ADD     TXC_FC14      ZCG(14)
     C                   Z-ADD     TXC_FC15      ZCG(15)
      *
      ** Initialise conversion fields
      *
     C                   Z-ADD     *ZERO         ZEXCH
     C                   MOVE      *BLANK        ZMD
     C                   MOVE      *BLANK        ZCCYI
     C                   MOVE      *BLANK        ZCCYO
     C                   Z-ADD     *ZERO         ZCDPI
     C                   Z-ADD     *ZERO         ZCDPO
      *
      *  IF AMOUNT IS NEGATIVE MAKE IT POSITIVE WHILE CALCULATING
      *
     C     ZCHGA         IFLT      0
     C     ZCHGA         MULT      -1            ZCHGA
     C                   MOVE      'Y'           NEGCHG            1
     C                   END
      *
      *  CALCULATE TAX
      *
      ** Set up fields required for the call to ZCONV in ZTCAL1
      ** Set to zero if the SE ICD Charge Currency is blank.
      *
     C     BVCHRC        IFNE      *BLANK
     C                   MOVE      ChgCcyEXRT    ZEXCH
     C                   MOVE      ChgCcyMDIN    ZMD
     C                   MOVE      BVCHRC        ZCCYI
     C                   MOVE      NMCY          ZCCYO
     C                   MOVE      ChgCcyDec     ZCDPI
     C                   MOVE      NomCcyDec     ZCDPO
     C                   END

     C                   EXSR      ZTCAL1
      *
      *    Reset sign
      *
     C     NEGCHG        IFEQ      'Y'
     C     ZTAXA         MULT      -1            ZTAXA
     C     ZCHGA         MULT      -1            ZCHGA
     C                   MOVE      ' '           NEGCHG            1
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZCCAL1 - Calculate Charges/Commissions                       *
      *                                                               *
      *****************************************************************
     C     ZCCAL1        BEGSR

     C                   CALLB     'ZCCAL'

      * INPUTS

      *
      * FROM THE CHARGE TYPES FILE
      *
     C                   PARM                    ZCHGB             1
     C                   PARM                    ZTHRI             1
     C                   PARM                    ZRA
     C                   PARM                    ZPC
     C                   PARM                    ZCG
     C                   PARM                    ZMNCH            15 0
     C                   PARM                    ZMXCH            15 0
      *
      * FROM THE TRADE/SECURITY
      *
     C                   PARM                    ZNOML            15 0
     C                   PARM                    ZPRICE           15 8
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZNMDP             1 0
     C                   PARM                    ZPROT             1
     C                   PARM                    ZTCFC            10 9
     C                   PARM                    ZSPBS             1
      *
      * EXCHANGE RATE, M/D IND, CURRENCIES & CURRENCY DECIMAL PLACES
      * FOR CHARGE CURRENCY TO NOMINAL CURRENCY CONVERSION
      *
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
      *
      *  New parameters for S01446
      *
     C                   PARM                    ZTCON            15 0
     C                   PARM                    ZTNOM            15 0
     C                   PARM                    ZTPI             15 0
     C                   PARM                    S01446            1
     C                   PARM                    BVACOP            1

      * OUTPUTS

      * CHARGE/COMMISSION AMOUNT CALCULATED
     C                   PARM      *ZERO         ZCHGA            15 0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZTCAL1 - Calculate Tax on Charges/Commissions                *
      *                                                               *
      *****************************************************************
     C     ZTCAL1        BEGSR

     C                   CALLB     'ZTCAL'

      * INPUTS

      *
      * FROM THE CHARGE TYPES FILE
      *
     C                   PARM                    ZCHGB
     C                   PARM                    ZTHRI
     C                   PARM                    ZRA
     C                   PARM                    ZPC
     C                   PARM                    ZCG
     C                   PARM                    ZMNCH
     C                   PARM                    ZMXCH
      *
      * THE CHARGE/COMMISSION AMOUNT ON WHICH THE TAX IS TO BE LEVIED
      * (ZCHGA) PLUS THE CHARGE CURRENCY NUMBER OF DECIMAL PLACES
      *
     C                   PARM                    ZCHGA
     C                   PARM                    ZDECS
      *
      * EXCHANGE RATE, M/D IND, CURRENCIES & CURRENCY DECIMAL PLACES
      * FOR CHARGE CURRENCY TO NOMINAL CURRENCY CONVERSION
      *
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
      *
      *  New parameters for S01446
      *
     C                   PARM                    S01446

      * OUTPUTS

      * THE TAX CALCULATED (ZTAXA)
     C                   PARM      *ZERO         ZTAXA            15 0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  REBATE Sub routine to calculate rebate on customer and broker*
      *  commissions                                                  *
      *                                                               *
      *****************************************************************
     C     REBATE        BEGSR
      *
      * Initialise and fetch correct work field for result
      *
     C     NomCcyDec     IFEQ      0
     C                   Z-ADD     ZCHGA         #REB0            15 0
     C     #REB0         MULT      CMRP          #REB0
     C     #REB0         DIV       100           #REB0
     C     #REB0         MULT      -1            #REB0
     C                   END
     C     NomCcyDec     IFEQ      1
     C                   MOVE      ZCHGA         #REB1            15 1
     C     #REB1         MULT      CMRP          #REB1
     C     #REB1         DIV       100           #REB1
     C     #REB1         MULT      -1            #REB1
     C                   MOVE      #REB1         #REB0
     C                   END
     C     NomCcyDec     IFEQ      2
     C                   MOVE      ZCHGA         #REB2            15 2
     C     #REB2         MULT      CMRP          #REB2
     C     #REB2         DIV       100           #REB2
     C     #REB2         MULT      -1            #REB2
     C                   MOVE      #REB2         #REB0
     C                   END
     C     NomCcyDec     IFEQ      3
     C                   MOVE      ZCHGA         #REB3            15 3
     C     #REB3         MULT      CMRP          #REB3
     C     #REB3         DIV       100           #REB3
     C     #REB3         MULT      -1            #REB3
     C                   MOVE      #REB3         #REB0
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  TXDETS Determine Counterparty Tax Details                    *
      *                                                               *
      *****************************************************************
     C     TXDETS        BEGSR
      *
      *  Access charges codes file using counterparty's tax code
      *  for tax details
      *
     C     KLSECGT       KLIST
     C                   KFLD                    @C_CCY            3
     C                   KFLD                    @C_CCOM           2

     C                   MOVE      CustTAXC      @C_CCOM

     C     KLSECGT       CHAIN     SECGT                              44

      * If found and taxable, set up charge details

     C     *IN44         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C                   MOVE      'Y'           TAX_CALC
     C                   MOVE      CHGB          TXC_CHGB
     C                   MOVE      THRI          TXC_THRI
     C                   MOVE      STU1          TXC_STU1
     C                   MOVE      STU2          TXC_STU2
     C                   MOVE      STU3          TXC_STU3
     C                   MOVE      STU4          TXC_STU4
     C                   MOVE      STU5          TXC_STU5
     C                   MOVE      STU6          TXC_STU6
     C                   MOVE      STU7          TXC_STU7
     C                   MOVE      STU8          TXC_STU8
     C                   MOVE      STU9          TXC_STU9
     C                   MOVE      ST10          TXC_ST10
     C                   MOVE      ST11          TXC_ST11
     C                   MOVE      ST12          TXC_ST12
     C                   MOVE      ST13          TXC_ST13
     C                   MOVE      ST14          TXC_ST14
     C                   MOVE      PL01          TXC_PL01
     C                   MOVE      PL02          TXC_PL02
     C                   MOVE      PL03          TXC_PL03
     C                   MOVE      PL04          TXC_PL04
     C                   MOVE      PL05          TXC_PL05
     C                   MOVE      PL06          TXC_PL06
     C                   MOVE      PL07          TXC_PL07
     C                   MOVE      PL08          TXC_PL08
     C                   MOVE      PL09          TXC_PL09
     C                   MOVE      PL10          TXC_PL10
     C                   MOVE      PL11          TXC_PL11
     C                   MOVE      PL12          TXC_PL12
     C                   MOVE      PL13          TXC_PL13
     C                   MOVE      PL14          TXC_PL14
     C                   MOVE      PL15          TXC_PL15
     C                   MOVE      FC01          TXC_FC01
     C                   MOVE      FC02          TXC_FC02
     C                   MOVE      FC03          TXC_FC03
     C                   MOVE      FC04          TXC_FC04
     C                   MOVE      FC05          TXC_FC05
     C                   MOVE      FC06          TXC_FC06
     C                   MOVE      FC07          TXC_FC07
     C                   MOVE      FC08          TXC_FC08
     C                   MOVE      FC09          TXC_FC09
     C                   MOVE      FC10          TXC_FC10
     C                   MOVE      FC11          TXC_FC11
     C                   MOVE      FC12          TXC_FC12
     C                   MOVE      FC13          TXC_FC13
     C                   MOVE      FC14          TXC_FC14
     C                   MOVE      FC15          TXC_FC15
     C                   MOVE      LPSI          TXC_LPSI
     C                   MOVE      MNCH          TXC_MNCH
     C                   MOVE      MXCH          TXC_MXCH
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * EDIT_AMT Edit an amount for display                           *
      *                                                               *
      *****************************************************************
     C     EDIT_AMT      BEGSR

     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      NomCcyDec     ZDECS             1 0
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM      *BLANK        ZOUT21           21

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      * INPUTS

      ** Trade reference
      ** Security
      ** Trade Type
     C                   PARM                    DDTDRF            6
     C                   PARM                    DDSESN           10
     C                   PARM                    DDTDTP            2
      *
      ** Trade Counterparty
      ** Trade Nominal
      ** Trade % price
      ** Trade Date
      ** Trade Purchased Interest
      ** Trade Current Factor
     C                   PARM                    TCNR
     C                   PARM                    NOML             11 0
     C                   PARM                    PRIC             15 8
     C                   PARM                    TDDT              5 0
     C                   PARM                    ITRA             13 0
     C                   PARM                    TCFC             10 9
      *
      ** Security & Investment Type details
     C                   PARM                    SECTY
     C                   PARM                    PROT              1
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Commission Rebate %
     C                   PARM                    CMRP              5 3
      *
      ** Previous Trade Charges & Commissions
     C                   PARM                    @P_TRCC
      *
      ** Trade Charges & Commissions OK inds
     C                   PARM                    OKTrChCm
      *
      ** ICD
      ** Autocharge Option
      ** Securities Charges Currency
      ** Adjust Commission Same Day T
     C                   PARM                    BVACOP            1
     C                   PARM                    BVCHRC            3
     C                   PARM                    BVACSD            1
     C                   PARM                    S01446            1

      * INPUTS & OUTPUTS

      ** Trade Charges & commissions screen fields

     C                   PARM                    TrChCm

      ** Trade details
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCA1             13 0
     C                   PARM                    TCA2             13 0
     C                   PARM                    TCA3             13 0                         S0117
     C                   PARM                    TCA4             13 0                         S0117
     C                   PARM                    TCA5             13 0                         S0117
     C                   PARM                    TCA6             13 0                         S0117
     C                   PARM                    TCA7             13 0                         S0117
     C                   PARM                    TAXA             13 0
     C                   PARM                    BCMR             13 0                         S0117
     C                   PARM                    CCMR             13 0                         S0117
     C                   PARM                    TXRB             13 0                         S0117


     C     *LIKE         DEFINE    CHGB          TXC_CHGB
     C     *LIKE         DEFINE    THRI          TXC_THRI
     C     *LIKE         DEFINE    MNCH          TXC_MNCH
     C     *LIKE         DEFINE    MXCH          TXC_MXCH
     C     *LIKE         DEFINE    STU1          TXC_STU1
     C     *LIKE         DEFINE    STU2          TXC_STU2
     C     *LIKE         DEFINE    STU3          TXC_STU3
     C     *LIKE         DEFINE    STU4          TXC_STU4
     C     *LIKE         DEFINE    STU5          TXC_STU5
     C     *LIKE         DEFINE    STU6          TXC_STU6
     C     *LIKE         DEFINE    STU7          TXC_STU7
     C     *LIKE         DEFINE    STU8          TXC_STU8
     C     *LIKE         DEFINE    STU9          TXC_STU9
     C     *LIKE         DEFINE    ST10          TXC_ST10
     C     *LIKE         DEFINE    ST11          TXC_ST11
     C     *LIKE         DEFINE    ST12          TXC_ST12
     C     *LIKE         DEFINE    ST13          TXC_ST13
     C     *LIKE         DEFINE    ST14          TXC_ST14
     C     *LIKE         DEFINE    PL01          TXC_PL01
     C     *LIKE         DEFINE    PL02          TXC_PL02
     C     *LIKE         DEFINE    PL03          TXC_PL03
     C     *LIKE         DEFINE    PL04          TXC_PL04
     C     *LIKE         DEFINE    PL05          TXC_PL05
     C     *LIKE         DEFINE    PL06          TXC_PL06
     C     *LIKE         DEFINE    PL07          TXC_PL07
     C     *LIKE         DEFINE    PL08          TXC_PL08
     C     *LIKE         DEFINE    PL09          TXC_PL09
     C     *LIKE         DEFINE    PL10          TXC_PL10
     C     *LIKE         DEFINE    PL11          TXC_PL11
     C     *LIKE         DEFINE    PL12          TXC_PL12
     C     *LIKE         DEFINE    PL13          TXC_PL13
     C     *LIKE         DEFINE    PL14          TXC_PL14
     C     *LIKE         DEFINE    PL15          TXC_PL15
     C     *LIKE         DEFINE    FC01          TXC_FC01
     C     *LIKE         DEFINE    FC02          TXC_FC02
     C     *LIKE         DEFINE    FC03          TXC_FC03
     C     *LIKE         DEFINE    FC04          TXC_FC04
     C     *LIKE         DEFINE    FC05          TXC_FC05
     C     *LIKE         DEFINE    FC06          TXC_FC06
     C     *LIKE         DEFINE    FC07          TXC_FC07
     C     *LIKE         DEFINE    FC08          TXC_FC08
     C     *LIKE         DEFINE    FC09          TXC_FC09
     C     *LIKE         DEFINE    FC10          TXC_FC10
     C     *LIKE         DEFINE    FC11          TXC_FC11
     C     *LIKE         DEFINE    FC12          TXC_FC12
     C     *LIKE         DEFINE    FC13          TXC_FC13
     C     *LIKE         DEFINE    FC14          TXC_FC14
     C     *LIKE         DEFINE    FC15          TXC_FC15
     C     *LIKE         DEFINE    LPSI          TXC_LPSI



      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
