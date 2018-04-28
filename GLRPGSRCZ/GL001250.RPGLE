     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Exposure & Offset Update for Int. Cap'n')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001250 - Credit Lines Exposure and Offset Update for       *
      *             Interest Capitalisation                           *
      *                                                               *
      *  Function: This program performs a process that will include  *
      *            the intrest being capitalised for accounts linked  *
      *  (CoB)     to facilities in the revalued exposures and        *
      *            offsets today.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. AR1095876          Date 30Sep13               *
      *  Prev Amend No. CLE147             Date 30Sep11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241629A            Date 27Sep06               *
      *                 CLE042             Date 06Sep05               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE041             Date 11Oct04               *
      *                 CLE040  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  CLE147 - Aggregate Facility (Recompile)                      *
      *  241629A - Avoid duplicate weighting code (Recompile)         *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE041 - Collateralised Lending Phase 2B (Recompile)         *
      *  CLE040 - Collateralised Lending Phase 2                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas LE Facilities detail A record by facility
     FFCLTYL3   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FM)
 
      ** Midas LE Facilities detail B record
     FFCLTYFN   UF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(FB)
 
      ** Midas LE Facilities detail B record by facility
     FFCLTYL5   UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFNF:FCLTYFN5)
     F                                     PREFIX(FB)
 
      ** Midas LE Facilities Extension File arranged by branch and facility
     FLEFCLTLG  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FX)
 
      ** Midas GL Account details arranged by facility
     FACCNTLA   IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Account details extension file by account number
     FGLACNTL4  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Account details arranged by facility and value date
     FGLGEICL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IC)
 
      ** Midas GP Weighting Codes
     FGPWEIGL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Data structure for General Ledger ICD
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)
 
      ** Data structure for General Ledger ICD
     D SDPLIN        E DS                  EXTNAME(SDPLINPD)
 
      ** Data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** First DS for Access Programs, Short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Variables
     D PRetCode        S              7
     D POption         S              7
     D WRun            S              1
     D PAcCd           S             10
     D PInsCd          S              3
     D WkCtrDt         S              5  0
     D WkWPrc          S              3  0
     D WkCAFlag        S              1
     D KFBrcA          S              3
     D WkOffA          S             13  0
 
     D WkAmtIn         S             15  0
     D WkAmtOut        S             15  0
     D WkTrnACBL       S             15  0
     D WkTrnCLBL       S             15  0
     D WkCcy1          S              3
     D WkCcy2          S              3
     D WkRate          S             13  8
     D WkSpRt1         S             13  8
     D WkSpRt2         S             13  8
     D PaSpRt1         S             13  8
     D PaSpRt2         S             13  8
     D WkNbDP1         S              1  0
     D WkNbDP2         S              1  0
     D WkMDIn          S              1
     D WkMDIn1         S              1
     D WkMDIn2         S              1
     D PaMDIn1         S              1
     D PaMDIn2         S              1
 
     D KFacility       DS
     D**KFcCu***               1      6  0                                                    CSD027
     D  KFcCu                  1      6                                                       CSD027
     D  KFacT                  7      9  0
     D  KFcNo                 10     11  0
 
     D KFacilityA      DS
     D  KFcCuA                 1      6
     D  KFacTA                 7      9
     D  KFcNoA                10     11
 
     D KAccount        DS
     D**CNUM****               1      6  0                                                    CSD027
     D  CNUM                   1      6                                                       CSD027
     D  CCY                    7      9
     D  ACOD                  10     19  0
     D  ACSQ                  20     21  0
     D  BRCA                  22     24
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Main Procedure
     C     1             SETLL     FCLTYFNF
     C                   READ      FCLTYFNF                               10
 
     C                   DOW       *IN10 = *OFF
 
     C                   EVAL      KFcCu = FBCNUM
     C                   EVAL      KFacT = FBFACT
     C                   EVAL      KFcNo = FBFCNO
 
      ** Access Facility Details Record A File
     C                   EXSR      SRGetFcltA
 
     C                   MOVE      KFcCu         KFcCuA
     C                   MOVE      KFacT         KFacTA
     C                   MOVE      KFcNo         KFcNoA
 
      ** Access Facility Extension File
     C                   EXSR      SRGetFcltX
 
      ** Process only non-credit agreement facilities
     C                   IF        FMTRCA <> 'CA'
 
     C     KLAcctA       SETLL     ACCNTLA
     C     KLAcctA       READE     ACCNTLA                                11
 
     C                   DOW       *IN11 = *OFF
 
      ** Access Accounts Extension File
     C                   EXSR      SRGetAcctX
 
      ** Default Weighting Percentage to 100% so that, if Retrieval is not
      ** successful, it will simply retain this value
     C                   Z-ADD     100           WkWPrc
 
      ** Execute subroutine that retrieves the weighting percentage
     C                   EXSR      SRRtvWPerc
 
      ** Set account balance to cleared balance
     C                   EVAL      F1ACBL = CLBL
 
      ** Determine whether Balance is to be updated on Day 1
     C                   EXSR      SRDetBalD1
 
     C                   IF        F1ACBL <> CLBL
 
      ** If Account balance is not equal to Cleared balance, perform exposure
      ** and offset updates
     C                   EVAL      WkCAFlag = 'N'
     C                   EXSR      SRUpdate
 
      ** If facility is a tranche, update its Credit Agreement facility as well
     C                   IF        FMTRCA = 'TR'
 
     C                   EVAL      KFcCu = FMCANM
     C                   EVAL      KFacT = FMCAFT
     C                   EVAL      KFcNo = FMCAFN
 
      ** Access Facility Details Record B File
     C                   EXSR      SRGetFcltB
 
     C                   MOVE      KFcCu         KFcCuA
     C                   MOVE      KFacT         KFacTA
     C                   MOVE      KFcNo         KFcNoA
 
      ** Access Facility Extension File
     C                   EXSR      SRGetFcltX
 
     C                   EVAL      WkCAFlag = 'Y'
     C                   EXSR      SRUpdate
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record that matches the facility read from FCLTYFN
     C                   READE     ACCNTLA                                11
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Read next record from FCLTYFN
     C                   READ      FCLTYFNF                               10
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvert - Convert Currency                                  *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR
 
      ** From currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    WkCcy1
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = WkCcy1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Save necessary details
     C                   EVAL      WkSpRt1 = A6SPRT
     C                   EVAL      WkMDIn1 = A6MDIN
     C                   EVAL      WkNbDP1 = A6NBDP
 
      ** To currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    WkCcy2
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = WkCcy2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Save necessary details
     C                   EVAL      WkSpRt2 = A6SPRT
     C                   EVAL      WkMDIn2 = A6MDIN
     C                   EVAL      WkNbDP2 = A6NBDP
 
     C                   IF        WkCAFlag = 'N'
 
      ** Get exchange rate
     C                   EVAL      PaMDIn1 = WkMDIn1
     C                   EVAL      PaMDIn2 = WkMDIn2
     C                   EVAL      PaSpRt1 = WkSpRt1
     C                   EVAL      PaSpRt2 = WkSpRt2
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    PaSpRt1
     C                   PARM                    PaMDIn1
     C                   PARM                    PaSpRt2
     C                   PARM                    PaMDIn2
      ** Output
     C                   PARM                    WkRate
     C                   PARM                    WkMDIn
 
     C                   ENDIF
 
      ** Convert amount
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    WkAmtIn
     C                   PARM                    WkRate
     C                   PARM                    WkMDIn
     C                   PARM                    WkCcy1
     C                   PARM                    WkCcy2
     C                   PARM                    WkNbDP1
     C                   PARM                    WkNbDP2
      ** Output
     C                   PARM                    WkAmtOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAcctX - Subroutine that Accesses Accounts Extension     *
      *               Record                                          *
      *                                                               *
      *****************************************************************
     C     SRGetAcctX    BEGSR
 
     C     KLAcctX       CHAIN     GLACNTL4                           13
 
     C                   IF        *IN13 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GLACNTQD'
     C                   EVAL      DBKEY  = KAccount
     C                   EVAL      DBASE  = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetFcltB - Subroutine that Accesses Facility Detail B      *
      *               Record                                          *
      *                                                               *
      *****************************************************************
     C     SRGetFcltB    BEGSR
 
     C     KLLeFclt      CHAIN     FCLTYL5                            13
 
     C                   IF        *IN13 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FCLTYFN'
     C                   EVAL      DBKEY  = KFacility
     C                   EVAL      DBASE  = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetFcltA - Subroutine that Accesses Facility Detail A      *
      *               Record                                          *
      *                                                               *
      *****************************************************************
     C     SRGetFcltA    BEGSR
 
     C     KLLeFclt      CHAIN     FCLTYL3                            13
 
     C                   IF        *IN13 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FCLTYFM'
     C                   EVAL      DBKEY  = KFacility
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      KFBrcA = FMBRCA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetFcltX - Subroutine that Accesses the Facility Extension *
      *               Record                                          *
      *                                                               *
      *****************************************************************
     C     SRGetFcltX    BEGSR
 
     C     KLLeFcltX     CHAIN     LEFCLTLG                           13
 
     C                   IF        *IN13 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEFCLTQD'
     C                   EVAL      DBKEY  = KFacilityA
     C                   EVAL      DBASE  = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvWPerc - Subroutine that Gets the Weighting Percentage   *
      *                                                               *
      *****************************************************************
     C     SRRtvWPerc    BEGSR
 
      ** Get Instrument Code via Account code
     C                   MOVEL     ACOD          PAcCd
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PAcCd
     C     SDACOD        PARM      *BLANKS       DSSDY
     C
     C                   IF        PRetCode = *BLANKS AND A5INNR <> *BLANKS
 
      ** Get Weighting Code via Instrument Code
     C                   EVAL      PInsCd = A5INNR
     C                   CALL      'AOPLINR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PInsCd
     C     SDPLIN        PARM      *BLANKS       DSFDY
     C
     C                   IF        PRetCode = *BLANKS
     C     PDWEIG        CHAIN     GPWEIGL0                           13
     C                   IF        *IN13 = *OFF
     C                   Z-ADD     PDPERC        WkWPrc
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetBalD1 - Subroutine that determines whether Balance is   *
      *               to be updated on Day 1                          *
      *                                                               *
      *****************************************************************
     C     SRDetBalD1    BEGSR
 
      ** Get Instrument Code via Account code
     C     KLGeICL0      SETLL     GLGEICL0
     C     KLGeICL0      READE     GLGEICL0                               12
 
     C                   DOW       *IN12 = *OFF AND ICVALD <= WkCtrDt
     C                   IF        ICDRCR = 0
     C                   SUB       ICPSTA        F1ACBL
     C                   ELSE
     C                   ADD       ICPSTA        F1ACBL
     C                   ENDIF
 
     C     KLGeICL0      READE     GLGEICL0                               12
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update the exposure and offset amounts on FCLTYFN *
      *             and LEFCLTQD                                      *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** Convert Account Balance to Facility Currency
 
     C                   IF        WkCAFlag = 'N'
     C                   EVAL      WkCcy1 = CCY
     C                   EVAL      WkCcy2 = FMFCCY
     C                   EVAL      WkAmtIn = F1ACBL
     C                   EXSR      SRConvert
     C                   EVAL      WkTrnACBL = WkAmtOut
     C                   ELSE
      ** Convert Account Balance(in facility ccy) to Credit Agreement Facility Currency
     C                   EVAL      WkCcy1 = FMFCCY
     C                   EVAL      WkCcy2 = FMCACY
     C                   EVAL      WkRate = FMCAXR
     C                   EVAL      WkMDIn = FMCMDI
     C                   EVAL      WkAmtIn = WkTrnACBL
     C                   EXSR      SRConvert
     C                   ENDIF
 
     C                   IF        WkAmtOut > 0
     C                   SUB       WkAmtOut      FBCEXP
     C                   SUB       WkAmtOut      FBCAMD
     C                   SUB       WkAmtout      FBOAM1
     C                   ELSE
     C                   EVAL      WkOffA = (WkAmtOut * WkWPrc)/100
     C                   Z-SUB     WkOffA        WkOffA
     C                   ADD       WkOffA        FXFCXCOF
     C                   ADD       WkOffA        FXFCXOF1
     C                   ENDIF
 
      ** Convert Cleared Balance to Facility Currency
     C                   IF        WkCAFlag = 'N'
     C                   EVAL      WkCcy1 = CCY
     C                   EVAL      WkCcy2 = FMFCCY
     C                   EVAL      WkAmtIn = CLBL
     C                   EXSR      SRConvert
     C                   EVAL      WkTrnCLBL = WkAmtOut
     C                   ELSE
      ** Convert Cleared Balance(in facility ccy) to Credit Agreement Facility Currency
     C                   EVAL      WkCcy1 = FMFCCY
     C                   EVAL      WkCcy2 = FMCACY
     C                   EVAL      WkRate = FMCAXR
     C                   EVAL      WkMDIn = FMCMDI
     C                   EVAL      WkAmtIn = WkTrnCLBL
     C                   EXSR      SRConvert
     C                   ENDIF
 
     C                   IF        WkAmtOut > 0
     C                   ADD       WkAmtOut      FBCEXP
     C                   ADD       WkAmtOut      FBCAMD
     C                   ADD       WkAmtOut      FBOAM1
     C                   ELSE
     C                   EVAL      WkOffA = (WkAmtOut * WkWPrc)/100
     C                   Z-SUB     WkOffA        WkOffA
     C                   SUB       WkOffA        FXFCXCOF
     C                   SUB       WkOffA        FXFCXOF1
     C                   ENDIF
 
      ** Update Facility file
     C                   IF        WkCAFlag = 'N'
     C                   UPDATE    FCLTYFNF
     C                   ELSE
     C                   UPDATE    FCLTYFN5
     C                   ENDIF
 
      ** Update Facility extension file
     C                   UPDATE    LEFCLTD0
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger ICD
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set event control date to the less of the Accrual Profit Date and Date
      ** of the Next Working Day minus 1
     C                   EVAL      WkCtrDt = BJDNWD - 1
 
     C                   IF        WkCtrDt > BKAPDT
     C                   EVAL      WkCtrDt = BKAPDT
     C                   ENDIF
 
     C     KLAcctA       KLIST
     C                   KFLD                    KFcCu
     C                   KFLD                    KFacT
     C                   KFLD                    KFcNo
 
     C     KLAcctX       KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
 
     C     KLLeFclt      KLIST
     C                   KFLD                    KFcCu
     C                   KFLD                    KFacT
     C                   KFLD                    KFcNo
 
     C     KLLeFcltX     KLIST
     C                   KFLD                    KFBrcA
     C                   KFLD                    KFcCuA
     C                   KFLD                    KFacTA
     C                   KFLD                    KFcNoA
 
     C     KLGeICL0      KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
 
