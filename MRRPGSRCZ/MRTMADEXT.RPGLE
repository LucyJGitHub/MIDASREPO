     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Transaction Manual Adjustments Extract')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MRTMADEXT - Transaction Manual Adjustments Extract     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6789            Date 21Apr05               *
      *                 CMR001  *CREATE    Date 16Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG6789- Manual adjustments must appear in correct BS section*
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRTRAPLA  IP   E           K DISK    PREFIX(I_) INFSR(*PSSR)
     F                                     RENAME(MRTRAPD0:MRTRAPDA)
     FMRRPRMPD  IF   E             DISK    INFSR(*PSSR)
     FMRTRAPPD  O    E             DISK    INFSR(*PSSR)
 
 
      /COPY ZACPYSRC,STD_D_SPEC
 
 
     D WkRun           S              1
 
     D WkTAmt          S             15  0
     D WkAmtInB        S             15  0
     D WkAmtIn1        S             15  0
     D WkAmtIn2        S             15  0
     D WkCYCDB         S              3
     D WkNBDPB         S              1  0
     D WkSPRTB         S             13P 8
     D WkMDINB         S              1
     D WkCYCD1         S              3
     D WkNBDP1         S              1  0
     D WkSPRT1         S             13P 8
     D WkMDIN1         S              1
     D WkCYCD2         S              3
     D WkNBDP2         S              1  0
     D WkSPRT2         S             13P 8
     D WkMDIN2         S              1
     D PRetCode        S              7
     D POption         S              7
     D PCust           S             10
     D PStKey          S              7
     D PCcy            S              3
     D WkECDat         S              5  0
     D I#ERMS          S             30
 
      ** Parameters for MRDATBID - Date Bucket Identification Module
     D PaDtSch         S              1  0
     D PaRepDt         S              5  0
     D PaSchDt         S              5  0
     D PaBuckCode      S              8
 
      ** Parameters for ZXRATE module
     D ZRATE1          S             13P 8
     D ZMDI1           S              1
     D ZRATE2          S             13P 8
     D ZMDI2           S              1
     D ZRATEX          S             13P 8
     D ZMDIX           S              1
 
      ** Parameters for ZCONVZ1 module
     D ZAMTCI          S             15  0
     D ZEXCH           S             13P 8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0
 
     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** General Ledger Details Data Structure
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Branch Details Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)
 
      ** Account Code Details Data Structure
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D  QQACC1       E                     EXTFLD(QQACCD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     IMRTRAPDA
     I                                          I_EXBRCH      L1
     I                                          I_EXCYCD      L1
     I                                          I_EXPACC      L1
 
 
      * Sign the principal amount to be reconciled
 
     C     I_EXPAMT      MULT      I_EXPSGN      SignedPAMT       18 3
 
      * Process sub-ledger accounts
     C
     C     I_EXSUB       IFEQ      'ACCT'
     C     I_EXSTAT      ANDEQ     'S'
     C                   SETON                                        10
     C                   ADD       SignedPAMT    Net_PAMT         18 3
     C                   ENDIF
 
      * Process transactions
     C
     C     I_EXSUB       IFNE      'ACCT'
     C     I_EXPACC      ANDNE     '    '
     C                   SETON                                        10
     C                   SUB       SignedPAMT    Net_PAMT
     C                   ENDIF
 
     CL1 10              EXSR      RECONCIL
     CL1 10              SETOFF                                       10
     CL1                 Z-ADD     *zero         Net_PAMT
      /SPACE 5
     C**********************************************************************************
     C     RECONCIL      BEGSR
 
     C     Net_PAMT      CABEQ     0             E_RECONCIL
     C                   CLEAR                   MRTRAPD0
 
      ** Set Extract Date
     C                   EVAL      EXTDAT = BJRDNB
 
      ** Set Event Control Date
     C                   EVAL      EXVCD = WkECDat
 
      ** Set Calendar/Financial
     C                   EVAL      EXCAFI = 'C'
 
      ** Set Period Type
     C                   EVAL      EXPERT = 'M'
 
      ** Set Calendar Year/Month
     C                   EVAL      EXCY = CalendarYear
     C                   EVAL      EXCM = CalendarMonth
 
      ** Set Module
     C                   EVAL      EXMOD = 'MA'
 
      ** Set Sub-Module
     C                   EVAL      EXSUB = 'TMAD'
 
      ** Set Transaction Id
     C                   EVAL      EXTRID = *BLANKS
 
      ** Set Sequence Number
     C                   EVAL      EXSEQ = 0
 
      ** Set Transaction Status
     C                   EVAL      EXSTAT = *BLANKS
 
      ** Set On/Off Balance Sheet
     C                   MOVE      *BLANKS       I#LFD1
     C                   MOVEL     I_EXPACC      I#LFD1
     C                   EXSR      SRGetAcCdD
     C                   IF        A5ACSC = 'AS' OR A5ACSC = 'LI' OR
     C                             A5ACSC = 'IN' OR A5ACSC = 'EX' OR
     C                             A5ACSC = 'TR'
     C                   EVAL      EXBALS = '1'
     C                   ELSE
     C                   EVAL      EXBALS = '0'
     C                   ENDIF
 
      ** Set Principal Account Code and Section
     C                   EVAL      EXPACC = I_EXPACC
     C                   EVAL      EXPACS = A5ACSC
     C                   EVAL      EXPREF = *BLANKS
 
      ** Set Branch Details
     C                   EVAL      I#LFD1 = I_EXBRCH
     C                   EXSR      SRSetBrcDet
     C                   EVAL      SDBRCH = InData
     C                   EVAL      EXBRCH = A8BRCD
     C                   EVAL      EXBICN = A8BICN
 
      ** Set Customer Details
     C                   MOVEL     A8BICN        PCust
     C                   EXSR      SRSetCusDet
     C                   MOVEL     A8BICN        EXCUSN
     C                   EVAL      EXCCIT = BBCNCZ
     C                   EVAL      EXCLOC = BBCOLC
     C                   EVAL      EXCIND = BBLICD
     C                   EVAL      EXCINT = BBLINC
     C                   EVAL      EXCBNK = BBBNBI
     C                   EVAL      EXCSWF = BBSWFI
 
      ** Set Parent Details
     C     BBPCNB        IFNE      *BLANK
     C                   MOVEL     BBPCNB        PCust
     C                   EXSR      SRSetCusDet
     C                   MOVEL     BBCUST        EXPARN
     C                   EVAL      EXPCIT = BBCNCZ
     C                   EVAL      EXPLOC = BBCOLC
     C                   EVAL      EXPIND = BBLICD
     C                   EVAL      EXPINT = BBLINC
     C                   EVAL      EXPBNK = BBBNBI
     C                   EVAL      EXPSWF = BBSWFI
     C                   ENDIF
 
      ** Set Currency Details (EXCYCD, EXEBRT, EXMDIB, EXERP1, EXMDI1, EXERP2,
      **                       EXMDI2)
     C                   EVAL      I#LFD1 = I_EXCYCD
     C                   EXSR      SRSetCurDet
 
      ** Set Principal Asset/Liability indicator, sign and DR/CR ind
     C                   IF        Net_PAMT>= 0
     C*******************EVAL      EXPALI = 'A'                                              BUG6789
     C                   Z-ADD     1             EXPSGN
     C*******************Z-ADD     0             EXPDCI                                      BUG6789
     C                   ELSE
     C*******************EVAL      EXPALI = 'L'                                              BUG6789
     C                   Z-SUB     1             EXPSGN
     C*******************Z-ADD     1             EXPDCI                                      BUG6789
     C                   ENDIF
                                                                                             BUG6789
     C                   IF        EXPACS = 'AS'                                             BUG6789
     C                   EVAL      EXPALI = 'A'                                              BUG6789
     C                   Z-ADD     0             EXPDCI                                      BUG6789
     C                   ELSE                                                                BUG6789
     C                   EVAL      EXPALI = 'L'                                              BUG6789
     C                   Z-ADD     1             EXPDCI                                      BUG6789
     C                   ENDIF                                                               BUG6789
 
      ** Set Principal Amounts
     C                   EVAL      Net_PAMT =  Net_PAMT  * (10**A6NBDP)
     C                   IF        Net_PAMT < 0
     C                   Z-SUB     Net_PAMT      WkTAmt
     C                   ELSE
     C                   Z-ADD     Net_PAMT      WkTAmt
     C                   ENDIF
 
     C                   EXSR      SRCvtAmounts
     C                   EVAL(H)   EXPAMT = WkTAmt/(10**A6NBDP)
     C                   EVAL(H)   EXPMTB = WkAmtInB/(10**WkNBDPB)
     C                   EVAL(H)   EXPMT1 = WkAmtIn1/(10**WkNBDP1)
     C                   EVAL(H)   EXPMT2 = WkAmtIn2/(10**WkNBDP2)
 
      ** Set Account Sequence, Account Type, Sub-Type, Profit Centre, Deal
      ** Date, Value Date, and Maturity Date
     C                   MOVE      '01'          EXACSQ
     C                   MOVE      '01'          EXACS1
     C                   EVAL      EXTRTY = 'MAN'
     C                   EVAL      EXTRST = 'ADJ'
     C                   EVAL      EXCLAS = *BLANK                                            CDL038
     C                   EVAL      EXPRFC = *BLANK
     C                   EVAL      EXDDAT = BJRDNB
     C                   EVAL      EXVDAT = BJRDNB
     C                   EVAL      EXMDAT = BJRDNB
 
      ** Set Maturity Date Schedules
     C                   EXSR      SRSetMatSch
 
      ** Write record to Extract File
 
     C                   WRITE     MRTRAPD0
 
     C     E_RECONCIL    ENDSR
     C**********************************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetAcCdD - Subroutine that Gets Account Code Details       *
      *                                                               *
      *****************************************************************
     C     SRGetAcCdD    BEGSR
 
     C                   CALLB     'MXACSACOD'
      /COPY MXCPYSRC,MXACSPRME
 
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'Invalid Account Code: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDACOD = InData
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *
      *                                                               *
      *****************************************************************
     C     SRGetCurrD    BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCcy
     C     SDCURR        PARM      *BLANKS       DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCcy
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetRepPrm - Subroutine that Accesses Report Parameters     *
      *                                                               *
      *****************************************************************
     C     SRGetRepPrm   BEGSR
 
     C     1             SETLL     MRRPRMPD
     C                   READ      MRRPRMPD
 
     C                   IF        %EOF(MRRPRMPD)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'MRRPRMPD'
     C                   EVAL      DBKEY = '*READ '
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetBrcDet - Subroutine that Sets Branch Details            *
      *                                                               *
      *****************************************************************
     C     SRSetBrcDet   BEGSR
 
     C                   CALLB     'MXACSBRCH'
      /COPY MXCPYSRC,MXACSPRME
 
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'Invalid Branch: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetCurDet - Subroutine that Sets Currency Details          *
      *                                                               *
      *****************************************************************
     C     SRSetCurDet   BEGSR
 
     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME
 
     C                   IF        ACS_RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'Invalid Currency: ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDCURR = InData
 
     C                   EVAL      EXCYCD = A6CYCD
     C                   EVAL      EXEBRT = A6SPRT
     C                   EVAL      EXMDIB = A6MDIN
 
      ** Retrieve Cross Rate between Transaction Currency and Reporting Ccy 1
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZRATE2 = WkSPRT1
     C                   EVAL      ZMDI2 = WkMDIN1
     C                   EXSR      SRGetXRate
     C                   EVAL      EXERP1 = ZRATEX
     C                   EVAL      EXMDI1 = ZMDIX
 
      ** Retrieve Cross Rate between Transaction Currency and Reporting Ccy 2
     C                   EVAL      ZRATE2  = WkSPRT2
     C                   EVAL      ZMDI2 = WkMDIN2
     C                   EXSR      SRGetXRate
     C                   EVAL      EXERP2 = ZRATEX
     C                   EVAL      EXMDI2 = ZMDIX
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetCusDet - Subroutine that Sets Customer Details          *
      *                                                               *
      *****************************************************************
     C     SRSetCusDet   BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      *BLANKS       DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCust
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetMatSch - Subroutine that Sets Maturity Date - Date      *
      *                Schedules                                      *
      *                                                               *
      *****************************************************************
     C     SRSetMatSch   BEGSR
 
     C                   EVAL      PaRepDt = WkECDat
     C                   EVAL      PaSchDt = EXMDAT
 
      ** Set Maturity Date - Date schedule 0
     C                   EVAL      PaDtSch = 0
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT0 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 1
     C                   EVAL      PaDtSch = 1
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT1 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 2
     C                   EVAL      PaDtSch = 2
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT2 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 3
     C                   EVAL      PaDtSch = 3
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT3 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 4
     C                   EVAL      PaDtSch = 4
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT4 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 5
     C                   EVAL      PaDtSch = 5
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT5 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 6
     C                   EVAL      PaDtSch = 6
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT6 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 7
     C                   EVAL      PaDtSch = 7
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT7 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 8
     C                   EVAL      PaDtSch = 8
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT8 = PaBuckCode
 
      ** Set Maturity Date - Date schedule 9
     C                   EVAL      PaDtSch = 9
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXMDT9 = PaBuckCode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetBuckCd - Subroutine that Gets Bucket Code               *
      *                                                               *
      *****************************************************************
     C     SRGetBuckCd   BEGSR
 
     C                   CALLB     'MRDATBID'
     C                   PARM                    PaDtSch
     C                   PARM                    PaRepDt
     C                   PARM                    PaSchDt
      ** Output
     C                   PARM                    PaBuckCode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmounts - Subroutine that Converts the Amount in Tran-  *
      *                 saction Ccy to be in Base Ccy, Reporting Ccy  *
      *                 1 and Reporting Ccy 2                         *
      *                                                               *
      *****************************************************************
     C     SRCvtAmounts  BEGSR
 
      ** Get Amount in Base Currency
     C                   Z-ADD     WkTAmt        ZAMTCI
     C                   EVAL      ZEXCH = A6SPRT
     C                   EVAL      ZMD = A6MDIN
     C                   EVAL      ZCCYI = EXCYCD
     C                   EVAL      ZCCYO = WkCYCDB
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZCDPO = WkNBDPB
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtInB
 
      ** Get Amount in Reporting Currency 1
     C                   EVAL      ZEXCH = EXERP1
     C                   EVAL      ZMD = EXMDI1
     C                   EVAL      ZCCYO = WkCYCD1
     C                   EVAL      ZCDPO = WkNBDP1
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtIn1
 
      ** Get Amount in Reporting Currency 2
     C                   EVAL      ZEXCH = EXERP2
     C                   EVAL      ZMD = EXMDI2
     C                   EVAL      ZCCYO = WkCYCD2
     C                   EVAL      ZCDPO = WkNBDP2
     C                   EXSR      SRGetCvtAmt
     C                   Z-ADD     ZAMTCO        WkAmtIn2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCvtAmt - Subroutine that Gets Converted Amount via      *
      *                ZCONVZ1                                        *
      *                                                               *
      *****************************************************************
     C     SRGetCvtAmt   BEGSR
 
     C                   CALLB     'ZCONVZ1'
      ** Inputs
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
      ** Output
     C                   PARM      *ZEROS        ZAMTCO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WkRun = *BLANK
     C                   EVAL      WkRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetXRate - Subroutine that Retrieves Cross Currency Rate   *
      *                                                               *
      *****************************************************************
     C     SRGetXRate    BEGSR
 
     C                   CALLB     'ZXRATE'
      ** Inputs
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
      ** Outputs
     C                   PARM      *ZEROS        ZRATEX
     C                   PARM      *BLANKS       ZMDIX
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C*****************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
 
      ** Initialise LDA field.
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'MRACCTEXT'
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
 
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set event control date to whichever is the lesser of the next
      ** working day and accrual profit date
     C                   EVAL      WkECDat = BJDNWD - 1
     C                   IF        BKAPDT < WkECDat
     C                   EVAL      WkECDat = BKAPDT
     C                   ENDIF
 
      ** Access Report Parameters
     C                   EXSR      SRGetRepPrm
 
      ** Get Details of Base Currency
     C                   EVAL      PCcy = BJCYCD
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCDB = A6CYCD
     C                   EVAL      WkNBDPB = A6NBDP
     C                   EVAL      WkSPRTB = A6SPRT
     C                   EVAL      WkMDINB = A6MDIN
 
      ** Get Details of Reporting Currency 1
     C                   EVAL      PCcy = RPCCY1
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCD1 = A6CYCD
     C                   EVAL      WkNBDP1 = A6NBDP
     C                   EVAL      WkSPRT1 = A6SPRT
     C                   EVAL      WkMDIN1 = A6MDIN
 
      ** Get Details of Reporting Currency 2
     C                   EVAL      PCcy = RPCCY2
     C                   EXSR      SRGetCurrD
     C                   EVAL      WkCYCD2 = A6CYCD
     C                   EVAL      WkNBDP2 = A6NBDP
     C                   EVAL      WkSPRT2 = A6SPRT
     C                   EVAL      WkMDIN2 = A6MDIN
 
      * Convert run date to DD/MM/YY
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear
 
      * Calendar Year/Month
 
     C                   Z-ADD     Year          CalendarYear      2 0
     C                   Z-ADD     Month         CalendarMonth     2 0
 
     C                   ENDSR
     C**********************************************************************************
