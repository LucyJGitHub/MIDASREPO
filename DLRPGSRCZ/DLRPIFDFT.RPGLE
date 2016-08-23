     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Defaulting')            *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRPIFDFT - Midas DL Reporting Information Defaulting        *
      *                                                               *
      *  Function: This module defaults the Reporting Information     *
      *            Maintenance screen fields if a record has been     *
      *            setup up by the user in the Standard Default       *
      *            Reporting Information file.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW214             Date 25Nov14               *
      *  Prev Amend No. MD023734           Date 30Nov13               *
      *                 MD023731           Date 26Nov13               *
      *                 MD022981           Date 12Nov13               *
      *                 MD021933           Date 05Sep13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD023734 - Clearing Threshold Indicator not defaulted.       *
      *  MD023731 - UTC Time and Sign not defaulted.                  *
      *  MD022981 - Seq 15E without succeeding field tags generated   *
      *  MD021933 - Link Swap ID, UTI Namespace, and Transaction ID   *
      *             of the 2nd leg swap deal not defaulted from       *
      *             first leg swap deal.                              *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD Standard Reporting Information
     FSDRPIFL0  IF   E           K DISK
 
      ** DL Reporting Information                                                           MD021933
     FDLRPIFL0  IF   E           K DISK                                                     MD021933
                                                                                            MD021933
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
 
      ** Include the FX standard declares
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
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second data structure for Access Programs, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Currencies File Format
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Customer Details Format
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Customer Extension SWIFT Details
     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)
 
      ** Branch Codes
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D BQQDFAC       E                     EXTFLD(QQDFAC)
 
      ** Report Information Format
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for bank details
     D SDRPIFDetail  E DS                  EXTNAME(SDRPIFPD)
 
      ** DL Transaction Reporting Information Link file
     D DLRILKPDIn    E DS                  EXTNAME(DLRILKPD)
 
      ** Deal in Screen Format 1
     D DLRIS1Detail  E DS                  EXTNAME(DLRIS1PD)
 
      ** Deal in Screen Format 2
     D DLRIS2Detail  E DS                  EXTNAME(DLRIS2PD)
 
      ** Deal in Screen Format 3
     D DLRIS3Detail  E DS                  EXTNAME(DLRIS3PD)
                                                                                              CSW214
      ** Deal in Screen Format 4                                                              CSW214
     D DLRIS4Detail  E DS                  EXTNAME(DLRIS4PD)                                  CSW214
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCode        S              7A
     D Timestamp       S               Z
     D WRecFound       S              1A
     D WMatchRec       S              1A
     D WCustN          S              6A
     D WBrCd           S              3A
     D WStr            S              5S 0
     D WLen            S              5S 0
     D WTime           S              6  0
     D X               S              2  0
     D PFRTM           S              6S 0
     D PFRDT           S              5P 0
     D PMKTM           S              6S 0
     D PMKDT           S              5P 0
     D PMKTOF          S              4S 0
     D PLCTM           S              6S 0
     D PLCDT           S              5P 0
     D PLCTOF          S              4S 0
     D PSYTM           S              6S 0
     D PSYDT           S              5P 0
     D PSYTOF          S              4S 0
 
     D FRTZ            S              1A
     D PMODL           S              2A
     D PBRCA           S              3A
     D PMRKT           S              2A
     D PSESN           S             10A
     D PMICC           S              4A
     D PMKTOS          S              1A
     D PLCTOS          S              1A
     D PSYTOS          S              1A
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PCurr           S              3A
     D PCusn           S             10A
     D PKySt           S              6A
     D PBrCd           S              3A
 
     D WSWAP           S              1A                                                    MD021933
     D WAPID           S              4A                                                    MD021933
     D WTRRF           S              6A                                                    MD021933
     D WTmstamp        S             26A                                                    MD021933
     D WTMST           S             15A                                                    MD021933
     D FXOnly          S              1A                                                    MD022981
     D BuyPMI          S              1A                                                    MD022981
                                                                                            MD023731
     D CurHour         S              3  0                                                  MD023731
     D CurMin          S              3  0                                                  MD023731
                                                                                            MD023734
     D WAmount1        S             13  0                                                  MD023734
     D WAmount2        S             13  0                                                  MD023734
     D SellRate        S             13  8                                                  MD023734
                                                                                              CSW214
     D CSW214          S              1A                                                      CSW214
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
     C                   EXSR      SrInit
      *
      ** If no matched record, retrieve Report Information details
      *
     C                   IF        WMatchRec = 'N'
     C                   EXSR      SRRtvRepInfo
     C                   ELSE
     C                   EXSR      SRMovRepInfo
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvRepInfo - Retrieve details from SD Information File     *
      *                                                               *
      *  Called by: MAIN                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRtvRepInfo  BEGSR
 
     C                   EVAL      WRecFound = 'N'
     C                   EVAL      X = 0
     C                   EVAL      RPBRCH = *BLANKS
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   DOU       WRecFound = 'Y' OR
     C                             X = 30
 
     C                   EVAL      X = X + 1
 
     C                   EXSR      SRMovKeyVal
 
     C     RPIFKey       SETLL     SDRPIFL0
     C                   IF        %EQUAL
     C     RPIFKey       CHAIN     SDRPIFL0                           99
     C                   IF        *IN99 = *OFF AND
     C                             RPRECI = 'D'
     C                   EVAL      WRecFound = 'Y'
     C                   EXSR      SRMovRepInfo
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WRecFound = 'N' AND
     C                             X = 30
     C                   EVAL      PRetCode = '*NRF'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMovKeyVal - Move Key Field Values                          *
      *  Called by: MAIN                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRMovKeyVal   BEGSR
 
     C                   SELECT
     C                   WHEN      X = 1
     C                   EXSR      SRCombo1
     C                   WHEN      X = 2
     C                   EXSR      SRCombo2
     C                   WHEN      X = 3
     C                   EXSR      SRCombo3
     C                   WHEN      X = 4
     C                   EXSR      SRCombo4
     C                   WHEN      X = 5
     C                   EXSR      SRCombo5
     C                   WHEN      X = 6
     C                   EXSR      SRCombo6
     C                   WHEN      X = 7
     C                   EXSR      SRCombo7
     C                   WHEN      X = 8
     C                   EXSR      SRCombo8
     C                   WHEN      X = 9
     C                   EXSR      SRCombo9
     C                   WHEN      X = 10
     C                   EXSR      SRCombo10
     C                   WHEN      X = 11
     C                   EXSR      SRCombo11
     C                   WHEN      X = 12
     C                   EXSR      SRCombo12
     C                   WHEN      X = 13
     C                   EXSR      SRCombo13
     C                   WHEN      X = 14
     C                   EXSR      SRCombo14
     C                   WHEN      X = 15
     C                   EXSR      SRCombo15
     C                   WHEN      X = 16
     C                   EXSR      SRCombo16
     C                   WHEN      X = 17
     C                   EXSR      SRCombo17
     C                   WHEN      X = 18
     C                   EXSR      SRCombo18
     C                   WHEN      X = 19
     C                   EXSR      SRCombo19
     C                   WHEN      X = 20
     C                   EXSR      SRCombo20
     C                   WHEN      X = 21
     C                   EXSR      SRCombo21
     C                   WHEN      X = 22
     C                   EXSR      SRCombo22
     C                   WHEN      X = 23
     C                   EXSR      SRCombo23
     C                   WHEN      X = 24
     C                   EXSR      SRCombo24
     C                   WHEN      X = 25
     C                   EXSR      SRCombo25
     C                   WHEN      X = 26
     C                   EXSR      SRCombo26
     C                   WHEN      X = 27
     C                   EXSR      SRCombo27
     C                   WHEN      X = 28
     C                   EXSR      SRCombo28
     C                   WHEN      X = 29
     C                   EXSR      SRCombo29
     C                   WHEN      X = 30
     C                   EXSR      SRCombo30
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo1 - Key Combination 1                                 *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo1      BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo2 - Key Combination 2                                 *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo2      BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo3 - Key Combination 3                                 *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo3      BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo4 - Key Combination 4                                 *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo4      BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo5 - Key Combination 5                                 *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo5      BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo6 - Key Combination 6                                 *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo6      BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo7 - Key Combination 7                                 *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo7      BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo8 - Key Combination 8                                 *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo8      BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo9 - Key Combination 9                                 *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo9      BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo10 - Key Combination 10                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo10     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo11 - Key Combination 11                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo11     BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo12 - Key Combination 12                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo12     BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo13 - Key Combination 13                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo13     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo14 - Key Combination 14                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo14     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo15 - Key Combination 15                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo15     BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo16 - Key Combination 16                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo16     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo17 - Key Combination 17                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo17     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo18 - Key Combination 18                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo18     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo19 - Key Combination 19                                *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo19     BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo20 - Key Combination 20                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo20     BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo21 - Key Combination 21                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo21     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo22 - Key Combination 22                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo22     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo23 - Key Combination 23                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo23     BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo24 - Key Combination 24                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo24     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo25 - Key Combination 25                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo25     BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo26 - Key Combination 26                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo26     BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo27 - Key Combination 27                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo27     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo28 - Key Combination 28                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo28     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = A6PMRT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo29 - Key Combination 29                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo29     BEGSR
 
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCombo30 - Key Combination 30                               *
      *  Called by: SRMovKeyVal                                       *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCombo30     BEGSR
 
     C                   EVAL      RPBRCH = 'ALL'
     C                   EVAL      RPTYPE = *BLANKS
     C                   EVAL      RPSTPE = *BLANKS
     C                   EVAL      RPCUSN = *BLANKS
     C                   EVAL      RPCURR = *BLANKS
     C                   EVAL      RPPMLI = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMovRepInfo - Move retrieved details to Output Parms        *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRMovRepInfo  BEGSR
 
     C                   EXSR      SRDetail1
     C                   EXSR      SRDetail2
     C                   EXSR      SRDetail3
     C                   EXSR      SRDetail4                                                  CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail1 - Details of Screen File 1                         *
      *                                                               *
      *  Called by: SRMovRepInfo                                      *
      *                                                               *
      *  Calls: SRGetCust                                             *
      *                                                               *
      *****************************************************************
     C     SRDetail1     BEGSR
 
     C                   IF        RPTRID <> *BLANKS
     C                   EVAL      R1TRID = RPTRID
     C                   EVAL      WCustN = RPTRID
     C                   ENDIF
 
     C                   EXSR      SRGetCust
     C                   EVAL      R1TRNM = BBCRNM
     C                   EVAL      R1TRTN = BBCRTN
     C                   EVAL      R1TRIS = BBCSID
 
     C                   IF        FXOnly = 'Y'                                             MD022981
                                                                                            MD022981
     C                   EVAL      R1CCPA = RPCCPA
     C                   IF        RPCCPN <> *BLANKS
     C                   EVAL      R1CCPI = RPCCPN
     C                   EVAL      WCustN = RPCCPN
     C                   EXSR      SRGetCust
     C                   EVAL      R1CCPN = BBCRNM
     C                   EVAL      R1CCPC = BBCRTN
     C                   EVAL      R1CCPS = BBCSID
     C                   EVAL      R1CCPL = CSLEIC
     C                   ENDIF
                                                                                            MD022981
     C                   ENDIF                                                              MD022981
 
     C                   EVAL      R1CEPA = RPCRPA
     C                   IF        RPCCPP <> *BLANKS
     C                   EVAL      R1CEPI = RPCCPP
     C                   EVAL      WCustN = RPCCPP
     C                   EXSR      SRGetCust
     C                   EVAL      R1CEPN = BBCRNM
     C                   EVAL      R1CEPC = BBCRTN
     C                   EVAL      R1CEPS = BBCSID
     C                   EVAL      R1CEPL = CSLEIC
     C                   ENDIF
 
     C                   EVAL      R1CBIC = RPCBCL
     C                   EVAL      R1CBIH = RPCCPL
                                                                                              CSW214
      ** If SWIFT 2014 is installed                                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   IF        FXOnly = 'Y'                                               CSW214
     C                   EVAL      R1CBRA = RPCBRA                                            CSW214
                                                                                              CSW214
     C                   IF        RPCBRI <> *BLANKS                                          CSW214
     C                   EVAL      R1CBRI = RPCBRI                                            CSW214
     C                   EVAL      WCustN = RPCBRI                                            CSW214
     C                   EXSR      SRGetCust                                                  CSW214
     C                   EVAL      R1CBNM = BBCRNM                                            CSW214
     C                   EVAL      R1CBTN = BBCRTN                                            CSW214
     C                   EVAL      R1CBSW = BBCSID                                            CSW214
     C                   EVAL      R1CBLC = CSLEIC                                            CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   EVAL      R1CPID = RPCPID
     C                   EVAL      R1EXVE = RPEXVE
     C                   EVAL      R1UPID = RPUPID
 
     C                   EVAL      WSWAP = 'N'                                              MD021933
     C                   IF        RLDTYP = 'SW' AND RLLTRF <> *BLANKS                      MD021933
     C                             AND FXOnly = 'Y'                                         MD022981
     C     RPIFKey2      CHAIN     DLRPIFL0                                                 MD021933
     C                   IF        %FOUND                                                   MD021933
     C                   EVAL      R1LSID = RILSID                                          MD021933
     C                   EVAL      WSWAP = 'Y'                                              MD021933
     C                   ENDIF                                                              MD021933
     C                   ENDIF                                                              MD021933
                                                                                            MD021933
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail2 - Details of Screen File 2                         *
      *                                                               *
      *  Called by: SRMovRepInfo                                      *
      *                                                               *
      *  Calls: SRGetCust                                             *
      *                                                               *
      *****************************************************************
     C     SRDetail2     BEGSR
 
     C                   EVAL      R2RPJ1 = RPRPJN
     C                   EVAL      R2RPP1 = RPRPPY
     C                   EVAL      R2RPA1 = RPRPAC
 
     C                   IF        WSWAP = 'Y'                                              MD021933
                                                                                            MD021933
     C                   EVAL      R2UTI1 = RIUT01                                          MD021933
     C                   EVAL      R2TRI1 = RITNI1                                          MD021933
                                                                                            MD021933
     C                   ELSE                                                               MD021933
                                                                                            MD021933
     C                   IF        RPGTID = 'Y'
 
     C                   IF        RPRPPY = *BLANKS
 
     C                   IF        RLBRCA  <> *BLANKS
 
     C                   EVAL      WBrCd = RLBRCA
     C                   EXSR      SRGetBranch
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WCustn = A8BICN
     C                   EXSR      SRGetCust
     C                   EVAL      R2UTI1 = CSIBEI
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WBrCd = RPBRCH
     C                   EXSR      SRGetBranch
     C                   IF        PRtCd = *BLANKS
     C                   IF        A8BICN = RPRPPY
     C                   EVAL      WCustn = A8BICN
     C                   EXSR      SRGetCust
     C                   EVAL      R2UTI1 = CSIBEI
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
                                                                                            MD021933
     C                   IF        R2UTI1 <> *BLANKS                                        MD021933
                                                                                            MD021933
     C                   IF        RLAPID = 'FRA'                                           MD021933
     C                   EVAL      WAPID = 'FRAD'                                           MD021933
     C                   ELSE                                                               MD021933
     C                   EVAL      WAPID = RLAPID                                           MD021933
     C                   ENDIF                                                              MD021933
     C                   IF        RLTRRF = *BLANKS                                         MD021933
     C                   EVAL      WTRRF = '999999'                                         MD021933
     C                   ELSE                                                               MD021933
     C                   EVAL      WTRRF = RLTRRF                                           MD021933
     C                   ENDIF                                                              MD021933
     C                   CALLB     'ZAGENTMSTM'                                             MD021933
     C                   PARM                    RITMST                                     MD021933
     C                   MOVEL     RITMST        WTmstamp                                   MD021933
     C                   EVAL      WTMST = %SUBST(WTmstamp:3:2) +                           MD021933
     C                              %SUBST(WTmstamp:6:2) +                                  MD021933
     C                              %SUBST(WTmstamp:9:2) +                                  MD021933
     C                              %SUBST(WTmstamp:12:2) +                                 MD021933
     C                              %SUBST(WTmstamp:15:2) +                                 MD021933
     C                              %SUBST(WTmstamp:18:2) +                                 MD021933
     C                              %SUBST(WTmstamp:21:3)                                   MD021933
     C                   EVAL      R2TRI1 = RLBRCA + WAPID +WTRRF +                         MD021933
     C                              WTMST + '001'                                           MD021933
                                                                                            MD021933
     C                   ENDIF                                                              MD021933
                                                                                            MD021933
     C                   ENDIF
                                                                                            MD021933
     C                   ENDIF                                                              MD021933
                                                                                            MD021933
     C                   IF        R2UTI1 <> *BLANKS AND                                    MD021933
     C                             R2TRI1 <> *BLANKS                                        MD021933
     C                   EVAL      R2TTY1 = '0'                                             MD021933
     C                   EVAL      R2EVT1 = '0'                                             MD021933
     C                   ENDIF                                                              MD021933
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetail3 - Details of Screen File 3                         *
      *                                                               *
      *  Called by: SRMovRepInfo                                      *
      *                                                               *
      *  Calls: SRGetCust                                             *
      *                                                               *
      *****************************************************************
     C     SRDetail3     BEGSR
 
     C                   EVAL      PFRTM = 0
     C                   IF        RPEXDE = 'Y'
 
     C                   EVAL      R3TSDT = RLVALD
     C                   IF        RLVALD <> *BLANKS
     C                   TIME                    WTime
     C
     C                   MOVEL     WTime         R3TSTM
     C**********         MOVEL     WTime         PFRTM                                      MD023731
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        RPEXTC = 'Y'
 
     C**********         CALL      'ZADTMCVT'                                               MD023731
     C**********         PARM      *BLANKS       PRtCd                                      MD023731
     C**********         PARM      'S'           FRTZ                                       MD023731
     C**********         PARM                    PFRTM                                      MD023731
     C**********         PARM                    PFRDT                                      MD023731
     C**********         PARM      'DL'          PMODL                                      MD023731
     C**********         PARM      RLBRCA        PBRCA                                      MD023731
     C**********         PARM      *BLANKS       PMRKT                                      MD023731
     C**********         PARM      *BLANKS       PSESN                                      MD023731
     C**********         PARM      *BLANKS       PMICC                                      MD023731
     C**********         PARM      *ZERO         PMKTM                                      MD023731
     C**********         PARM      *ZERO         PMKDT                                      MD023731
     C**********         PARM      *ZERO         PMKTOF                                     MD023731
     C**********         PARM      *BLANK        PMKTOS                                     MD023731
     C**********         PARM      *ZERO         PLCTM                                      MD023731
     C**********         PARM      *ZERO         PLCDT                                      MD023731
     C**********         PARM      *ZERO         PLCTOF                                     MD023731
     C**********         PARM      *BLANK        PLCTOS                                     MD023731
     C**********         PARM      *ZERO         PSYTM                                      MD023731
     C**********         PARM      *ZERO         PSYDT                                      MD023731
     C**********         PARM      *ZERO         PSYTOF                                     MD023731
     C**********         PARM      *BLANK        PSYTOS                                     MD023731
      **********                                                                            MD023731
     C**********         IF        PRtCd = *BLANKS                                          MD023731
     C**********         IF        PSYTOS = '+'                                             MD023731
     C**********         EVAL      R3UTSS = ' '                                             MD023731
     C**********         ELSE                                                               MD023731
     C**********         EVAL      R3UTSS = 'N'                                             MD023731
     C**********         ENDIF                                                              MD023731
     C**********         MOVE      PSYTOF        R3UTST                                     MD023731
     C**********         ENDIF                                                              MD023731
      *                                                                                     MD023731
     C                   EVAL      WBrCd = RLBRCA                                           MD023731
     C                   EXSR      SRGetBranch                                              MD023731
     C                   IF        PRtCd = *BLANKS                                          MD023731
      *                                                                                     MD023731
     C                   MOVEL     WTime         CurHHMM           4 0                      MD023731
     C                   MOVEL     CurHHMM       CurHH             2 0                      MD023731
     C                   MOVE      CurHHMM       CurMM             2 0                      MD023731
     C                   MOVEL     A8STOF        SysHH             2 0                      MD023731
     C                   MOVE      A8STOF        SysMM             2 0                      MD023731
     C                   MOVEL     A8TMOF        BrcHH             2 0                      MD023731
     C                   MOVE      A8TMOF        BrcMM             2 0                      MD023731
     C                   MOVE      A8TMOF        R3UTST                                     MD023731
      *                                                                                     MD023731
     C                   IF        A8SSIN = '-'                                             MD023731
     C                   EVAL      SysHH = -1 * SysHH                                       MD023731
     C                   EVAL      SysMM = -1 * SysMM                                       MD023731
     C                   ENDIF                                                              MD023731
      *                                                                                     MD023731
     C                   IF        A8SIGN = '-'                                             MD023731
     C                   EVAL      BrcHH = -1 * BrcHH                                       MD023731
     C                   EVAL      BrcMM = -1 * BrcMM                                       MD023731
     C                   EVAL      R3UTSS = 'N'                                             MD023731
     C                   ENDIF                                                              MD023731
      *                                                                                     MD023731
     C                   EVAL      CurHour = CurHH - SysHH + BrcHH                          MD023731
     C                   EVAL      CurMin = CurMM - SysMM + BrcMM                           MD023731
      *                                                                                     MD023731
     C                   IF        CurMin >= 60                                             MD023731
     C     CurMin        DIV       60            CurHH                                      MD023731
     C                   MVR                     CurMin                                     MD023731
     C                   EVAL      CurHour = CurHour + CurHH                                MD023731
     C                   ENDIF                                                              MD023731
      *                                                                                     MD023731
     C                   IF        CurHour >= 24                                            MD023731
     C     CurHour       DIV       24            CurHH                                      MD023731
     C                   MVR                     CurHour                                    MD023731
     C                   ENDIF                                                              MD023731
      *                                                                                     MD023731
     C                   MOVE      CurMin        WR3hhmm           4                        MD023731
     C                   MOVE      CurHour       WR3Hour           2                        MD023731
     C                   MOVEL     WR3Hour       WR3hhmm                                    MD023731
     C                   MOVEL     WR3hhmm       R3TSTM                                     MD023731
      *                                                                                     MD023731
     C                   ENDIF                                                              MD023731
      *                                                                                     MD023731
     C                   ENDIF
 
     C                   IF        RPCTAM <> 0 AND                                          MD023734
     C                              RPCTCY <> *BLANKS AND                                   MD023734
     C                              PayAmount <> 0 AND                                      MD023734
     C                              RLSCCY <> *BLANKS                                       MD023734
     C                                                                                      MD023734
     C                   EVAL      WAmount1 = PayAmount                                     MD023734
     C                   EVAL      WAmount2 = RPCTAM * 0.01                                 MD023734
     C                   IF        RPCTCY <> RLSCCY                                         MD023734
     C                   CALL      'AOCURRR0'                                               MD023734
     C                   PARM      *BLANKS       PRtCd                                      MD023734
     C                   PARM      '*KEY'        POptn                                      MD023734
     C                   PARM      RPCTCY        PCurr                                      MD023734
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD023734
     C                   IF        PRtCd = *BLANKS                                          MD023734
     C                   EVAL      WAmount1 = WAmount1 * SellRate                           MD023734
     C                   EVAL      WAmount2 = WAmount2 * A6SPRT                             MD023734
     C                   ENDIF                                                              MD023734
     C                   ENDIF                                                              MD023734
                                                                                            MD023734
     C                   IF        WAmount1 < WAmount2                                      MD023734
     C                   EVAL      R3CTIN = 'N'                                             MD023734
     C                   ENDIF                                                              MD023734
     C                   IF        WAmount1 > WAmount2                                      MD023734
     C                   EVAL      R3CTIN = 'Y'                                             MD023734
     C                   ENDIF                                                              MD023734
                                                                                            MD023734
     C                   ENDIF                                                              MD023734
                                                                                            MD023734
     C                   EVAL      R3ALIN = RPALIN
     C                   EVAL      R3COIN = RPCLIN
     C                   EVAL      R3NSFG = RPNSFL
                                                                                              CSW214
      ** If SWIFT 2014 is installed                                                           CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      R3FNCI = RPFNCI                                            CSW214
     C                   EVAL      R3COPI = RPCOPI                                            CSW214
     C                   EVAL      R3COPC = RPCOPC                                            CSW214
     C                   EVAL      R3POCI = RPPOCI                                            CSW214
     C                   EVAL      R3COSI = RPCOSI                                            CSW214
     C                   EVAL      R3TNEI = RPTNEI                                            CSW214
     C                   EVAL      R3IGTI = RPIGTI                                            CSW214
     C                   EVAL      R3CTFI = RPCTFI                                            CSW214
     C                   ENDIF                                                                CSW214
     C**********         EVAL      R3AR01 = RPAD01                                            CSW214
     C**********         EVAL      R3AR02 = RPAD02                                            CSW214
     C**********         EVAL      R3AR03 = RPAD03                                            CSW214
     C**********         EVAL      R3AR04 = RPAD04                                            CSW214
     C**********         EVAL      R3AR05 = RPAD05                                            CSW214
     C**********         EVAL      R3AR06 = RPAD06                                            CSW214
     C**********         EVAL      R3AR07 = RPAD07                                            CSW214
     C**********         EVAL      R3AR08 = RPAD08                                            CSW214
     C**********         EVAL      R3AR09 = RPAD09                                            CSW214
     C**********         EVAL      R3AR10 = RPAD10                                            CSW214
     C**********         EVAL      R3AR11 = RPAD11                                            CSW214
     C**********         EVAL      R3AR12 = RPAD12                                            CSW214
     C**********         EVAL      R3AR13 = RPAD13                                            CSW214
     C**********         EVAL      R3AR14 = RPAD14                                            CSW214
     C**********         EVAL      R3AR15 = RPAD15                                            CSW214
     C**********         EVAL      R3AR16 = RPAD16                                            CSW214
     C**********         EVAL      R3AR17 = RPAD17                                            CSW214
     C**********         EVAL      R3AR18 = RPAD18                                            CSW214
     C**********         EVAL      R3AR19 = RPAD19                                            CSW214
     C**********         EVAL      R3AR20 = RPAD20                                            CSW214
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CSW214
      *****************************************************************                       CSW214
      *                                                               *                       CSW214
      *  SRDetail4 - Details of Screen File 4                         *                       CSW214
      *                                                               *                       CSW214
      *  Called by: SRMovRepInfo                                      *                       CSW214
      *                                                               *                       CSW214
      *****************************************************************                       CSW214
     C     SRDetail4     BEGSR                                                                CSW214
                                                                                              CSW214
     C                   EVAL      R4AR01 = RPAD01                                            CSW214
     C                   EVAL      R4AR02 = RPAD02                                            CSW214
     C                   EVAL      R4AR03 = RPAD03                                            CSW214
     C                   EVAL      R4AR04 = RPAD04                                            CSW214
     C                   EVAL      R4AR05 = RPAD05                                            CSW214
     C                   EVAL      R4AR06 = RPAD06                                            CSW214
     C                   EVAL      R4AR07 = RPAD07                                            CSW214
     C                   EVAL      R4AR08 = RPAD08                                            CSW214
     C                   EVAL      R4AR09 = RPAD09                                            CSW214
     C                   EVAL      R4AR10 = RPAD10                                            CSW214
     C                   EVAL      R4AR11 = RPAD11                                            CSW214
     C                   EVAL      R4AR12 = RPAD12                                            CSW214
     C                   EVAL      R4AR13 = RPAD13                                            CSW214
     C                   EVAL      R4AR14 = RPAD14                                            CSW214
     C                   EVAL      R4AR15 = RPAD15                                            CSW214
     C                   EVAL      R4AR16 = RPAD16                                            CSW214
     C                   EVAL      R4AR17 = RPAD17                                            CSW214
     C                   EVAL      R4AR18 = RPAD18                                            CSW214
     C                   EVAL      R4AR19 = RPAD19                                            CSW214
     C                   EVAL      R4AR20 = RPAD20                                            CSW214
                                                                                              CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CSW214
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initilization                                       *
      *                                                               *
      *  Called by: MAIN                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
     C                   CALL      'AOCURRR0'                                               MD022981
     C                   PARM      *BLANKS       PRtCd                                      MD022981
     C                   PARM      '*KEY'        POptn                                      MD022981
     C                   PARM      RLBCCY        PCurr                                      MD022981
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD022981
     C                   IF        PRtCd = *BLANKS                                          MD022981
     C                   EVAL      BuyPMI = A6PMRT                                          MD022981
     C                   ENDIF                                                              MD022981
      *                                                                                     MD022981
     C                   EVAL      DLRIS1Detail = *BLANKS
     C                   EVAL      DLRIS2Detail = *BLANKS
     C                   EVAL      DLRIS3Detail = *BLANKS
     C                   EVAL      DLRIS4Detail = *BLANKS                                     CSW214
     C                   EVAL      WMatchRec = 'N'
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      RLSCCY        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      RPBRCH = RLBRCA
     C                   EVAL      RPTYPE = RLDTYP
     C                   EVAL      RPSTPE = RLDLST
     C                   EVAL      RPCUSN = RLCNUM
     C                   EVAL      RPCURR = RLSCCY
     C                   EVAL      RPPMLI = A6PMRT
     C                   EVAL      SellRate = A6SPRT                                        MD023734
      *
     C                   IF        RPPMLI <> 'Y' AND                                        MD022981
     C                             BuyPMI <> 'Y' AND                                        MD022981
     C                             RLAPID = 'FXDL'                                          MD022981
     C                   EVAL      FXOnly = 'Y'                                             MD022981
     C                   ELSE                                                               MD022981
     C                   EVAL      FXOnly = 'N'                                             MD022981
     C                   ENDIF                                                              MD022981
      *                                                                                     MD022981
     C     RPIFKey       CHAIN     SDRPIFL0                           99
     C                   IF        *IN99 = *OFF
     C                   EVAL      WMatchRec = 'Y'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      PRetCode = '*DBERR'
     C                   ENDIF
      *                                                                                     MD023734
     C                   IF        PPayAmount <> *BLANKS                                    MD023734
     C                   CALLB     'ZALIGN2'                                                MD023734
     C                   PARM      'Y'           PZAlignOk         1                        MD023734
     C                   PARM      PPayAmount    PZField          16                        MD023734
     C                   PARM      3             PZDec             2 0                      MD023734
     C                   PARM      12            PZDig             2 0                      MD023734
     C                   IF        PZAlignOk = 'Y'                                          MD023734
     C                   MOVEL     PZField       PayAmount        13 0                      MD023734
     C                   ENDIF                                                              MD023734
     C                   ENDIF                                                              MD023734
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCust - Get Customer Details                             *
      *                                                               *
      *  Called by: MAIN                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRGetCust     BEGSR
 
     C                   CLEAR                   DSLDY
 
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      WCustn        PCusn
     C                   PARM                    PKySt
     C                   PARM                    DSLDY
 
     C                   IF        PRtCd  = *BLANKS
     C                   EVAL      WStr = %LEN(SDCUST) + 1
     C                   EVAL      WLen = %LEN(SDCSSW)
     C                   EVAL      SDCUST = DSLDY
     C                   EVAL      SDCSSW = %SUBST(DSLDY:WStr:WLen)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetBranch - Get Branch Details                             *
      *                                                               *
      *  Called by: MAIN                                              *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRGetBranch   BEGSR
 
     C                   CLEAR                   SDBRCH
 
     C**********         CALL      'AOBRCHR0'                                               MD023731
     C                   CALL      'AOBRCHR1'                                               MD023731
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WBrCd         PBrCd
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program parameters
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
     C                   PARM                    PRetCode
     C                   PARM                    DLRILKPDIn
      *
      ** Output parameters
      *
      ** Transaction Reporting screen 1
     C                   PARM                    DLRIS1Detail
      *
      ** Transaction Reporting screen 2
     C                   PARM                    DLRIS2Detail
      *
      ** Transaction Reporting screen 3
     C                   PARM                    DLRIS3Detail
                                                                                              CSW214
      ** Transaction Reporting screen 4                                                       CSW214
                                                                                              CSW214
     C                   PARM                    DLRIS4Detail                                 CSW214
      *                                                                                     MD023734
      ** Pay Amount                                                                         MD023734
     C                   PARM                    PPayAmount       14                        MD023734
      *
      ** Key fields for SDRPIF
      *
     C     RPIFKey       KLIST
     C                   KFLD                    RPBRCH
     C                   KFLD                    RPTYPE
     C                   KFLD                    RPSTPE
     C                   KFLD                    RPCUSN
     C                   KFLD                    RPCURR
     C                   KFLD                    RPPMLI
      *                                                                                     MD021933
     C     RPIFKey2      KLIST                                                              MD021933
     C                   KFLD                    RLAPID                                     MD021933
     C                   KFLD                    RLLTRF                                     MD021933
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRtCd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      PFRDT = BJRDNB
     C                   ELSE
     C                   EVAL      PFRDT = 0
     C                   ENDIF
                                                                                              CSW214
      ** Check if SWIFT 2014 feature is installed                                             CSW214
                                                                                              CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PrtCd                                        CSW214
                                                                                              CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   IF        PrtCd   = 'CSW2014'                                        CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   ENDIF                                                                CSW214
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
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
