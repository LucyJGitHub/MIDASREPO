     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD ARR Calculator Batch Job')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000114 - Alternative Reference Rates Calculator Batch Job  *
      *                                                               *
      *  Function:  This program will select all transactions which   *
      *             uses a backward-looking rate. Then, it will call  *
      *             a program to invoke the FFDC ARR Calculator. The  *
      *             ARR Calculator will return published rates that   *
      *             will be applied to the deal/loan transactions.    *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD058040           Date 11May21               *
      *  Prev Amend No. MD057946           Date 27Apr21               *
      *                 CLE172             Date 01Oct20               *
      *                 CSD103  *CREATE    Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058040 - Rates Known Flag not set to Y. Condition update   *
      *             based on event control date instead of rundate.   *
      *  MD057946 - Floor rate passed as 10000000 instead of          *
      *            1.0000000 causing an exception error in ARR Calc   *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *  CSD103 - Libor Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS                                            *
      *                                                               *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SUBROUTINE INDEX                                             *
      *                                                               *
      * SRDltLOGS     - Delete logs for failed transactions on re-run *
      * SRSelTRAN     - Select backward-looking rate transactions     *
      * SRReadNEXT    - Read next record                              *
      * SRCloseCURSOR - Close cursor                                  *
      * SRUpdFILE     - Update Rates Known Field                      *
      * SRDetINTDATE  - Determine Interest Period Dates               *
      * SRDetRTKN     - Determine if transaction has reached the      *
      * SRPrepPARM    - Prepare parameters for calling ARR Calculator *
      * SRCallARRC    - Call program to invoke the ARR Calculator     *
      * SRZDATE       - Convert Midas Day into YYMMDD Date Format     *
      * *INZSR        - Program Initialisation routine                *
      * *PSSR         - Error processing                              *
      *                                                               *
      *****************************************************************

      ** ARR Calculator Parameter Details File
     FSDLIBRTD  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** Holiday File Standard Subroutine Variables
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE

      ** Data Sructure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Sructure for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data Structure for Backward-Looking Rate Loans
     D LoanBLRT        DS
     D  TrMODI                        2A
     D  TrTRAN                        6A
     D  TrCCY                         3A
     D  TrVDAT                        5S 0
     D  TrMDAT                        5S 0
     D  TrNIDT                        5S 0
     D  TrNRPD                        5S 0
     D  TrREPT                        1S 0
     D  TrADDI                        1A
     D  TrBLRT                        1A
     D  TrRFRR                       10A
     D  TrCALM                        4A
     D  TrBADJ                       11S 7
     D  TrFLOR                       11S 7
     D  TrLBDY                        2S 0
     D  TrLODY                        2S 0
     D  TrOPSH                        1A
     D  TrRRDP                        2S 0
     D  TrDBAV                        1S 0

      ** Data Structure for ARR Calculator API Parameters
     D ARRCalcParm     DS
     D  ModuleID                      2A
     D  TransREF                      6A
     D  CalcMethod                    4A
     D  IntPrdStartDt                10A
     D  IntPrdStrMDay                 5A
     D  IntPrdEndDt                  10A
     D  IntPrdEndMDay                 5A
     D  RiskFreeRate                  5A
     D  RiskFreeRatFl                20A
     D  LookBackDays                  2A
     D  ObservPrdShft                 5A
     D  RateRndDecPts                 3A
     D  DayCntConvent                 7A
     D  LockOutDays                   2A
     D  ShowDailyDtls                 5A
     D  CalcTillDate                 10A
     D  BenchMarkAdj                 20A
     D  RatesKnownInd                 1A
     D  ReturnCode                   20A

      ** Constants declaration
     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)
     D EC              c                   const('  0 .       ')                            MD057946

      ** Reference Rates Array
     D ArraySize       C                   CONST(10)
     D ArrRFR          S             10A   DIM(ArraySize)
     D ArrPubLag       S              2S 0 DIM(ArraySize)
     D ArrPubTim       S              5A   DIM(ArraySize)

      ** Parameters for calling access programs
     D PRtCd           S              7A
     D POptn           S              7A

      ** Parameters for calling AOSVALR0
     D RtnCode         S              7A
     D PSysVal01       S             20A
     D PCurSet01       S            200A
     D PSysVal02       S             20A
     D PCurSet02       S            200A
     D PSysVal03       S             20A
     D PCurSet03       S            200A
     D PSysVal04       S             20A
     D PCurSet04       S            200A
     D PSysVal05       S             20A
     D PCurSet05       S            200A
     D PSysVal06       S             20A
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A

      ** Parameters for calling SD2000
     D EOM             S              1A
     D EOY             S              1A
     D Error           S              1A

      ** Program Variables
     D WRUN            S              1A
     D ARRCalcFreq     S              1A
     D CallARR         S              1A
     D RatesKnown      S              1A
     D*** WRateFloor      S             13A                                                 MD057946
     D WCalcTillDate   S             10A
     D SumLBLO         S              3S 0
     D Idx             S              2S 0
     D NoOfRecs        S              3S 0
     D WZeroMDATFlag   S              1A
     D CurrTime        S              8A
     D PublTime        S              8A
     D EventCtrlDate   S              5S 0                                                  MD058040
     D ISODate         S               D   DATFMT(*ISO)
     D IntPerSDATE     S                   LIKE(TrNIDT)
     D IntPerEDATE     S                   LIKE(TrNIDT)
     D RTKNDate        S                   LIKE(TrNIDT)
     D WrkDATE         S                   LIKE(TrNIDT)
     D KRFRR           S                   LIKE(SCRFLD)
     D RPubLag         S                   LIKE(PUBLAG)
     D RPubTim         S                   LIKE(PUBTIM)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING

      ** Start commitment control
     C/exec SQL
     C+ set option COMMIT = *CHG
     C/end-exec

      ** Delete logs for failed transactions on re-run
     C                   EXSR      SRDltLOGS

      ** Select the backward looking rate transactions
     C                   EXSR      SRSelTRAN

      ** Read next record
     C                   EXSR      SRReadNEXT
     C                   DOW       SQLCOD <> NO_RECORD

     C                   IF        SQLCODE <> NO_ERROR and
     C                             SQLCODE <> NO_RECORD
     C                   EVAL      DBFILE = 'SQLERROR'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 004
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      CallARR = 'Y'

      ** Determine Interest Period Dates
     C                   EVAL      WZeroMDATFlag = 'N'
     C                   EXSR      SRDetINTDATE

      ** If the backward-looking rate parameters are changed via                              CLE172
      ** Rollover, this will be applied to the whole interest period.                         CLE172
      ** Thus, existing daily rates records should be deleted.                                CLE172
     C/exec SQL                                                                               CLE172
     C+ select count(*) into :NoOfRecs                                                        CLE172
     C+ from LEROBLPD                                                                         CLE172
     C+ where ROLNRF = :TrTRAN                                                                CLE172
     C/end-exec                                                                               CLE172
                                                                                              CLE172
     C                   IF        NoOfRecs <> 0                                              CLE172
                                                                                              CLE172
     C/exec SQL                                                                               CLE172
     C+ delete from SDHSDRTD                                                                  CLE172
     C+ where CMODID = :TrMODI                                                                CLE172
     C+   and CTRNID = :TrTRAN                                                                CLE172
     C+   and CINPSD = :IntPerSDATE                                                           CLE172
     C+   and CINPED = :IntPerEDATE                                                           CLE172
     C/end-exec                                                                               CLE172
     C                   IF        SQLCODE <> NO_ERROR and                                    CLE172
     C                             SQLCODE <> NO_RECORD                                       CLE172
     C                   EVAL      DBFILE = 'SQLERROR'                                        CLE172
     C                   EVAL      DBKEY  = 'SQL ERROR'                                       CLE172
     C                   EVAL      DBASE  = 004                                               CLE172
     C                   EXSR      *PSSR                                                      CLE172
     C                   ENDIF                                                                CLE172
                                                                                              CLE172
     C                   ENDIF                                                                CLE172
                                                                                              CLE172
      ** Check if transaction has reached the Rates Known window
     C                   EVAL      RatesKnown = 'N'
     C                   IF        WZeroMDATFlag = 'N'
     C                   EXSR      SRDetRTKN
     C                   ENDIF

      ** If ARRCalcFrequency is M-Monthly and it is not End of Month,
      ** skip call to ARR Calculator unless it satisfies below conditions
     C                   IF        ARRCalcFreq = 'M' and
     C                             EOM <> 'Y'

     C                   EVAL      CallARR = 'N'

      ** Calculation Method is either NCCR or Simple ARR
     C                   IF        TrCALM = 'NCCR' or
     C                             TrCALM = 'SARR'
     C                   EVAL      CallARR = 'Y'
     C                   ENDIF

      ** Transaction has reached the Rates Known Window
     C                   IF        RatesKnown = 'Y'
     C                   EVAL      CallARR = 'Y'
     C                   ENDIF

      ** Transaction has a new interest period (i.e. the new interest
      ** start and end date has no reords yet in Daily Rates File)
     C/exec SQL
     C+ select count(*) into :NoOfRecs
     C+ from SDHSDRTD
     C+ where CMODID = :TrMODI
     C+   and CTRNID = :TrTRAN
     C+   and CINPSD = :IntPerSDATE
     C+   and CINPED = :IntPerEDATE
     C/end-exec
     C                   IF        NoOfRecs = 0
     C                   EVAL      CallARR = 'Y'
     C                   ENDIF

     C                   ENDIF

      ** Call the ARR Calculator
     C                   IF        CallARR = 'Y'

     C                   EXSR      SRPrepPARM

      ** If transaction has reached the Rates Known Window, call
      ** the ARR Calculator first with blank Calculate 'Till Date
      ** If an exception error is returned, set Rates Known to 'N'
      ** and call the calculator again w/ nonblank Calculate'TillDate
     C                   IF        RatesKnown = 'Y'
     C
     C                   EVAL      CalcTillDate = *BLANKS
     C                   EVAL      RatesKnownInd = 'Y'
     C                   EXSR      SRCallARRC

     C                   IF        ReturnCode = 'EXCEPTION_ERROR'
     C                   EVAL      RatesKnown = 'N'
     C                   ENDIF
     C
     C                   ENDIF

     C                   IF        RatesKnown = 'N'
     C                   EVAL      CalcTillDate = WCalcTillDate
     C                   EVAL      RatesKnownInd = 'N'
     C                   EXSR      SRCallARRC
     C                   ENDIF

      ** Update the Transaction File and set the Rates Known Flag
     C                   EXSR      SRUpdFILE

     C                   ENDIF

      ** Read next record
     C                   EXSR      SRReadNEXT
     C                   ENDDO

     C                   EXSR      SRCloseCURSOR

      ** Commit Changes
     C                   COMMIT

      ** End program
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSelTRAN - Select backward-looking rate transactions         *
      *                                                               *
      *****************************************************************
     C     SRSelTRAN     BEGSR

      ** Select loan transactions which uses a backward looking-rate
     C/exec SQL
     C+ declare TransBLRTCursor insensitive scroll cursor for
     C+ select 'LE', LNRF, CCY,  VDAT, MDAT,
     C+        NIDT, NRPD, REPT, ADDI, BLRT,
     C+        RFRR, CALM, BADJ, FLOR, LBDY,
     C+        LODY, OPSH, RRDP, DBAV
     C+ from CLOANCL
     C+ where RECI = 'D' and VDAT < :BJDNWD
     C+   and BLRT = 'Y' and CALM <> 'MANL'
     C+   and PTYP in ( 61, 62, 64, 66, 68, 69, 70, 71, 72 )
     C+   and RLDT = 0
     C+ union all                                                                             CLE172
     C+ select 'LE',   LNRF,   CCY,    VDAT,   MDAT,                                          CLE172
     C+        NIDT,   NRPD,   REPT,   ADDI,   ROBLRT,                                        CLE172
     C+        RORFRR, ROCALM, ROBADJ, ROFLOR, ROLBDY,                                        CLE172
     C+        ROLODY, ROOPSH, RORRDP, RODBAV                                                 CLE172
     C+ from LEROBLPD                                                                         CLE172
     C+ left join CLOANCL                                                                     CLE172
     C+ on ROLNRF = LNRF                                                                      CLE172
     C+ where ROLNRF is not null and ROCALM <> 'MANL'                                         CLE172
     C/end-exec

     C/exec SQL
     C+ open TransBLRTCursor
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReadNEXT - Read next record                                 *
      *                                                               *
      *****************************************************************
     C     SRReadNEXT    BEGSR

     C/exec SQL
     C+ fetch next from TransBLRTCursor into :LoanBLRT
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCloseCURSOR - Close cursor                                  *
      *                                                               *
      *****************************************************************
     C     SRCloseCURSOR BEGSR

     C/exec SQL
     C+ close TransBLRTCursor
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDltLOGS - Delete logs for failed transactions on re-run     *
      *                                                               *
      *****************************************************************
     C     SRDltLOGS     BEGSR

     C/exec SQL
     C+ delete from SDARRLOGTD
     C+ where SJSTAT = 'F' and SJMDAY = :BJRDNB
     C/end-exec

     C                   IF        SQLCODE <> NO_ERROR and
     C                             SQLCODE <> NO_RECORD
     C                   EVAL      DBFILE = 'SQLERROR'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 005
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdFILE - Update Rates Known Field                          *
      *                                                               *
      *****************************************************************
     C     SRUpdFILE     BEGSR

     C/exec SQL
     C+ update CLOANCL
     C+ set RTKN = :RatesKnown
     C+ where LNRF = :TransREF
     C/end-exec

     C                   IF        SQLCODE <> NO_ERROR and
     C                             SQLCODE <> NO_RECORD
     C                   EVAL      DBFILE = 'SQLERROR'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 006
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetINTDATE - Determine Interest Period Dates                *
      *                                                               *
      *****************************************************************
     C     SRDetINTDATE  BEGSR

      ** Get the Start Date
     C                   EVAL      WrkDATE = 0
     C                   IF        TrVDAT >= BJRDNB and
     C                             TrVDAT <  BJDNWD
     C                   EVAL      WrkDATE = TrVDAT
     C                   ELSE

      ** or Last Interest Payment Date
     C                   SELECT

     C                   WHEN      TrREPT = 1 or TrREPT = 3
     C/exec SQL
     C+ select max(VDAT) into :WrkDATE
     C+ from HISTSHP
     C+ where LNRF = :TrTRAN and AMTP = 'RE'
     C/end-exec

     C                   WHEN      TrREPT = 2
     C/exec SQL
     C+ select max(VDAT) into :WrkDATE
     C+ from HISTSHP
     C+ where LNRF = :TrTRAN and AMTP = 'IN'
     C/end-exec

     C                   ENDSL

      ** If work date is zero, set to transaction start date
     C                   IF        WrkDATE = 0
     C                   EVAL      WrkDATE = TrVDAT
     C                   ENDIF

     C                   ENDIF

      ** Determine Interest Period Start Date
     C                   EVAL      IntPerSDATE = 0
     C                   IF        TrADDI = 'L'
     C                   EVAL      IntPerSDATE = WrkDATE + 1
     C                   ELSE
     C                   EVAL      IntPerSDATE = WrkDATE
     C                   ENDIF

      ** Get the Next Interest Payment Date
     C                   EVAL      WrkDATE = 0
     C                   SELECT
     C
     C                   WHEN      (TrREPT = 1 or TrREPT = 3) and
     C                             TrNRPD <> 0
     C                   EVAL      WrkDATE = TrNRPD
     C
     C                   WHEN      TrREPT = 2 and
     C                             TrNIDT <> 0
     C                   EVAL      WrkDATE = TrNIDT
     C
     C                   OTHER
     C                   EVAL      WrkDATE = TrMDAT

     C                   ENDSL

      ** Determine Interest Period End Date
     C                   EVAL      IntPerEDATE = 0
     C                   IF        TrADDI = 'L'
     C                   EVAL      IntPerEDATE = WrkDATE
     C                   ELSE
     C                   EVAL      IntPerEDATE = WrkDATE - 1
     C                   ENDIF

      ** If the Additional Day Indicator is B-Both, the last interest                         CLE172
      ** period will be extended by 1 day to include the maturity date                        CLE172
     C                   IF        TrADDI = 'B' and                                           CLE172
     C                             WrkDATE = TrMDAT                                           CLE172
     C                   EVAL      IntPerEDATE = WrkDATE                                      CLE172
     C                   ENDIF                                                                CLE172
                                                                                              CLE172
     C                   IF        IntPerEDATE <= 0
     C                   EVAL      WZeroMDATFlag = 'Y'
     C                   EVAL      IntPerEDATE = BJDNWD - 1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetRTKN - Determine if transaction has reached the          *
      *             Rates Known Window                                *
      *                                                               *
      *****************************************************************
     C     SRDetRTKN     BEGSR

      ** Get the Reference Rates Pub. Lag Days and Publication Time
     C                   EVAL      Idx = 0
     C                   EVAL      Idx = %LOOKUP( TrRFRR : ArrRFR )
     C                   IF        Idx <> 0
     C                   EVAL      RPubLag = ArrPubLag(Idx)
     C                   EVAL      RPubTim = %trim(ArrPubTim(Idx))
     C                   EVAL      PublTime = %trim(RPubTim) + ':00'
     C                   ENDIF

      ** Get the starting date of the Rates Known Window
      ** Rates Known Date = Interest Period End Date minus
      ** (Lookback + Lockout) plus Publication Lag Days
     C                   EVAL      RTKNDate = 0
     C                   EVAL      SumLBLO = TrLBDY + TrLODY

     C                   MOVEL     TrCCY         ZCCY              3
     C                   MOVEL     *BLANKS       ZLOC              3
     C                   Z-ADD     IntPerEDATE   ZDAYNO            5 0
     C                   Z-ADD     SumLBLO       ZNRDYS            2 0
     C                   Z-ADD     *ZEROS        ZDYNBR            5 0
     C                   EXSR      ZBKDT

     C                   EVAL      RTKNDate = ZDYNBR

     C                   Z-ADD     RTKNDate      ZDAYNO
     C                   Z-ADD     RPubLag       ZNRDYS
     C                   Z-ADD     *ZEROS        ZDYNBR
     C                   EXSR      ZFWDT

     C                   EVAL      RTKNDate = ZDYNBR

      ** Set the Rates Known flag if the computed Rates Known Date has
      ** passed the system date and the reference rate publication time
     C**********         IF        RTKNDate <= BJRDNB and                                   MD058040
     C                   IF        RTKNDate <= EventCtrlDate and
     C                             RTKNDate <> 0
     C                   EVAL      RatesKnown = 'Y'
     C                   EVAL      CurrTime = %char(%time():*HMS)
     C                   IF        RTKNDate = BJRDNB and
     C                             PublTime > CurrTime
     C                   EVAL      RatesKnown = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrepPARM - Prepare parameters for calling ARR Calculator    *
      *                                                               *
      *****************************************************************
     C     SRPrepPARM    BEGSR

     C                   CLEAR                   ARRCalcParm

     C                   EVAL      ModuleID   = TrMODI

     C                   EVAL      TransREF   = TrTRAN

     C                   EVAL      CalcMethod = TrCALM

      ** Convert Interest Period Start Date into *ISO Date Format
     C                   EVAL      ZDAYNO = IntPerSDATE
     C                   EXSR      SRZDATE
     C                   EVAL      IntPrdStartDt = %char(ISODate)

     C                   MOVEL     IntPerSDATE   IntPrdStrMDay

      ** Convert Interest Period End Date into *ISO Date Format
     C                   EVAL      ZDAYNO = IntPerEDATE
     C                   EXSR      SRZDATE
     C                   EVAL      IntPrdEndDt = %char(ISODate)

     C                   MOVEL     IntPerEDATE   IntPrdEndMDay

     C                   EVAL      RiskFreeRate = TrRFRR

     C**********         MOVE      TrFLOR        WRateFloor                                 MD057946
     C**********         EVAL      RiskFreeRatFl = %trim(WRateFloor)                        MD057946
     C                   IF        trFLOR < 0                                               MD057946
     C                   EVAL      RiskFreeRatFl ='-' + %TRIM(%EDITW(trFLOR:EC))            MD057946
     C                   ELSE                                                               MD057946
     C                   EVAL      RiskFreeRatFl = %TRIM(%EDITW(trFLOR:EC))                 MD057946
     C                   ENDIF                                                              MD057946

     C                   MOVE      TrLBDY        LookBackDays

     C                   IF        TrOPSH = 'Y'
     C                   EVAL      ObservPrdShft = 'true'
     C                   ELSE
     C                   EVAL      ObservPrdShft = 'false'
     C                   ENDIF

     C                   MOVE      TrRRDP        RateRndDecPts

     C                   SELECT
     C                   WHEN      TrDBAV = 1
     C                   EVAL      DayCntConvent = 'ACT/365'
     C                   WHEN      TrDBAV = 2
     C                   EVAL      DayCntConvent = 'ACT/360'
     C                   WHEN      TrDBAV = 6
     C                   EVAL      DayCntConvent = 'ACT/ACT'
     C                   ENDSL

     C                   MOVE      TrLODY        LockOutDays

     C                   EVAL      ShowDailyDtls = 'true'

      ** Compute for Calculate Till Date and convert to *ISO Date Format
     C                   EVAL      WCalcTillDate = *BLANKS
     C                   EVAL      WrkDATE = BJDNWD - 1

      ** Interest Start Date cannot be greater than calculateTillDate
     C                   IF        IntPerSDATE > WrkDATE
     C                   EVAL      WrkDATE = IntPerSDATE
     C                   ENDIF

      ** calculateTillDate cannot be greater than Interest End Date
     C                   IF        WrkDATE > IntPerEDATE
     C                   EVAL      WrkDATE = IntPerEDATE
     C                   ENDIF

     C                   EVAL      ZDAYNO = WrkDATE
     C                   EXSR      SRZDATE
     C                   EVAL      WCalcTillDate = %char(ISODate)

     C********           EVAL      BenchMarkAdj = %char(TrBADJ)                             MD057946
     C                   IF        TrBADJ < 0                                               MD057946
     C                   EVAL      BenchMarkAdj = '-' + %TRIM(%EDITW(TrBADJ:EC))            MD057946
     C                   ELSE                                                               MD057946
     C                   EVAL      BenchMarkAdj = %TRIM(%EDITW(TrBADJ:EC))                  MD057946
     C                   ENDIF                                                              MD057946

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallARRC - Call program to invoke the ARR Calculator        *
      *                                                               *
      *****************************************************************
     C     SRCallARRC    BEGSR

     C                   CALL      'ZAGETCALRT'
     C                   PARM                    ModuleID
     C                   PARM                    TransREF
     C                   PARM                    CalcMethod
     C                   PARM                    IntPrdStartDt
     C                   PARM                    IntPrdStrMDay
     C                   PARM                    IntPrdEndDt
     C                   PARM                    IntPrdEndMDay
     C                   PARM                    RiskFreeRate
     C                   PARM                    RiskFreeRatFl
     C                   PARM                    LookBackDays
     C                   PARM                    ObservPrdShft
     C                   PARM                    RateRndDecPts
     C                   PARM                    DayCntConvent
     C                   PARM                    LockOutDays
     C                   PARM                    ShowDailyDtls
     C                   PARM                    CalcTillDate
     C                   PARM                    BenchMarkAdj
     C                   PARM                    RatesKnownInd
     C                   PARM      *BLANKS       ReturnCode

      ** End program if there's a connection error
     C                   IF        ReturnCode = 'CONNECTION_ERROR'
     C                   EVAL      DBFILE = 'ZAGETCALRT'
     C                   EVAL      DBKEY = TransREF
     C                   EVAL      DBASE  = 006
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDATE - Convert Midas Day into YYMMDD Date Format           *
      *                                                               *
      *****************************************************************
     C     SRZDATE       BEGSR

      ** Convert Midas Day into *ISO Date Format
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      'M'           ZDATFM            1
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7

     C                   EVAL      ISODate = %date( ZDATE : *MDY )

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Initialize Work fields
     C                   EVAL      DBPGM = 'SD000114'

      ** Get the Bank details via access program
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access General Ledger details
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Determine the Event Control Date                                                   MD058040
     C                   EVAL      EventCtrlDate = BJDNWD - 1                               MD058040
     C                   IF        BKAPDT < EventCtrlDate                                   MD058040
     C                   EVAL      EventCtrlDate = BKAPDT                                   MD058040
     C                   ENDIF                                                              MD058040
                                                                                            MD058040
      ** Get setting of system value ARR Calculation Frequency
     C                   EVAL      ARRCalcFreq = *BLANKS
     C                   EVAL      PSysVal01 = 'ARRCalculationFreq'

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM                    PSysVal01
     C                   PARM      *BLANKS       PCurSet01
     C                   PARM      *BLANKS       PSysVal02
     C                   PARM      *BLANKS       PCurSet02
     C                   PARM      *BLANKS       PSysVal03
     C                   PARM      *BLANKS       PCurSet03
     C                   PARM      *BLANKS       PSysVal04
     C                   PARM      *BLANKS       PCurSet04
     C                   PARM      *BLANKS       PSysVal05
     C                   PARM      *BLANKS       PCurSet05
     C                   PARM      *BLANKS       PSysVal06
     C                   PARM      *BLANKS       PCurSet06
     C                   PARM      *BLANKS       PSysVal07
     C                   PARM      *BLANKS       PCurSet07
     C                   PARM      *BLANKS       PSysVal08
     C                   PARM      *BLANKS       PCurSet08
     C                   PARM      *BLANKS       PSysVal09
     C                   PARM      *BLANKS       PCurSet09
     C                   PARM      *BLANKS       PSysVal10
     C                   PARM      *BLANKS       PCurSet10
     C
     C                   IF        RtnCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDSVLCTD'
     C                   EVAL      DBKEY = PSysVal01
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     PCurSet01     ARRCalcFreq
     C                   ENDIF

      ** If ARRCalcFreq is M-Monthly, determine if End of month
     C                   IF        ARRCalcFreq = 'M'
     C                   CALL      'SD2000'
     C                   PARM      *BLANKS       EOM
     C                   PARM      *BLANKS       EOY
     C                   PARM      *BLANKS       Error
     C                   ENDIF

      ** Store Reference Rate Publication Lag Days and
      ** Publication Time in an array
     C                   EVAL      Idx = 1
     C                   EVAL      KRFRR = 'RFR'
     C     KRFRR         SETLL     SDLIBRTD
     C     KRFRR         READE     SDLIBRTD
     C                   DOW       NOT %EOF(SDLIBRTD)
     C                   EVAL      ArrRFR(Idx) = INTVAL
     C                   EVAL      ArrPubLag(Idx) = PUBLAG
     C                   EVAL      ArrPubTim(Idx) = PUBTIM
     C                   EVAL      Idx = Idx + 1
     C     KRFRR         READE     SDLIBRTD
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZBKDT_ILE
     C/COPY ZSRSRC,ZFWDT_ILE
     C/COPY ZSRSRC,ZACCHLE
