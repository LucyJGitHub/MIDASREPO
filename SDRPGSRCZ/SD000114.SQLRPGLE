     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
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
      *  Last Amend No. CSD103  *CREATE    Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      * SRUpdSTAT - Update ARR Calculator Status File                 *
      * SRUpdFILE - Update Rates Known Field                          *
      * SRDetINTDATE - Determine Interest Period Dates                *
      * SRDetRTKN - Determine if transaction has reached the          *
      * SRPrepPARM - Prepare parameters for calling ARR Calculator    *
      * SRCallARRC - Call program that will invoke the ARR Calculator *
      * SRZDATE - Convert Midas Day into YYMMDD Date Format           *
      * *INZSR - Program Initialisation routine                       *
      * *PSSR - Error processing                                      *
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

      ** Data Sructure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Sructure for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data Structure for System Prefix
     D SDSTAT        E DS           256    EXTNAME(SDSTAT) DTAARA(SDSTAT)
     D  SYSID                  6      7

      ** Data Structure for Backward-Looking Rate Transaction
     D TransBLRT       DS
     D  TrMODI                        2A
     D  TrTRAN                        6A
     D  TrCCY                         3A
     D  TrVDAT                        5S 0
     D  TrMDAT                        5S 0
     D  TrNIDT                        5S 0
     D  TrSLID                        5S 0
     D  TrADDI                        1A
     D  TrREPT                        1S 0
     D  TrNRPD                        5S 0
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
     D  IntPrdEndDt                  10A
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

     D CurrTime        DS
     D  WHrs                   1      2
     D  WColon1                3      3
     D  WMin                   4      5
     D  WColon2                6      6
     D  WSec                   7      8

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
     D WRateFloor      S             13A
     D WCalcTillDate   S             10A
     D SumLBLO         S              3S 0
     D Idx             S              2S 0
     D WStatus         S              1A
     D NoOfRecs        S              2S 0
     D WStrDate        S              5S 0
     D WStrTime        S              6S 0
     D WEndDate        S              5S 0
     D WEndTime        S              6S 0
     D WStrDateSV      S              5S 0
     D WStrTimeSV      S              6S 0
     D WTime           S              6A
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
      ** Set Status File to R-Running
     C                   EVAL      WStatus = 'R'
     C                   EXSR      SRUpdSTAT

      ** Delete logs for failed transactions on re-run
     C                   EXSR      SRDltLOGS

      ** Select all transactions which uses a backward looking-rate
     C/exec SQL
     C+ declare TransBLRTCursor insensitive scroll cursor for
     C+ select 'LE', LNRF, CCY,  VDAT, MDAT,
     C+        NIDT, SLID, ADDI, REPT, NRPD,
     C+        BLRT, RFRR, CALM, BADJ, FLOR,
     C+        LBDY, LODY, OPSH, RRDP, DBAV
     C+ from CLOANCL
     C+ where RECI = 'D' and VDAT <= :BJRDNB and
     C+       BLRT = 'Y' and CALM <> 'MANL' and
     C+       PTYP in ( 61, 62, 64, 66, 68, 69, 70, 71, 72 )
     C/end-exec

     C/exec SQL
     C+ open TransBLRTCursor
     C/end-exec

     C/exec SQL
     C+ fetch next from TransBLRTCursor into :TransBLRT
     C/end-exec

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EVAL      DBFILE = 'CLOANCL'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 004
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      CallARR = 'Y'

      ** Determine Interest Period Dates
     C                   EXSR      SRDetINTDATE

      ** Check if transaction has reached the Rates Known window
     C                   EVAL      RatesKnown = 'N'
     C                   EXSR      SRDetRTKN

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

      ** Transaction has a new interest period
     C                   IF        (TrNIDT   = BJRDNB and TrADDI = 'F') or
     C                             (TrNIDT+1 = BJRDNB and TrADDI = 'L') or
     C                             (TrVDAT >= BJRDNB and TrVDAT < BJDNWD)
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

     C/exec SQL
     C+ fetch next from TransBLRTCursor INTO :TransBLRT
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close TransBLRTCursor
     C/end-exec

      ** Set Status File to C-Completed
     C                   EVAL      WStatus = 'C'
     C                   EXSR      SRUpdSTAT

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdSTAT - Update ARR Calculator Status File                 *
      *                                                               *
      *****************************************************************
     C     SRUpdSTAT     BEGSR

     C                   EVAL      CurrTime = %char(%time():*HMS)
     C                   EVAL      WTime = WHrs + WMin + WSec

     C                   IF        WStatus = 'R'
     C                   EVAL      WStrDate = BJRDNB
     C                   MOVEL     WTime         WStrTime
     C                   EVAL      WEndDate = *ZEROS
     C                   EVAL      WEndTime = *ZEROS
     C                   EVAL      WStrDateSV = WStrDate
     C                   EVAL      WStrTimeSV = WStrTime
     C                   ELSE
     C                   EVAL      WStrDate = WStrDateSV
     C                   EVAL      WStrTime = WStrTimeSV
     C                   EVAL      WEndDate = BJRDNB
     C                   MOVEL     WTime         WEndTime
     C                   ENDIF

      ** Check if record exists on file already.
     C/exec SQL
     C+ select count(*) into :NoOfRecs
     C+ from SDCSTSTD
     C+ where SDZONE = :SYSID
     C/end-exec

      ** If there is no record, then write one
     C                   IF        NoOfRecs = 0
     C/exec SQL
     C+ insert into SDCSTSTD
     C+ (
     C+   SDZONE, SDSTAT, SDSTDT, SDSTTM, SDENDT, SDENTM,
     C+   SDJOBN, SDJOBU, SDJNBR
     C+ )
     C+ values
     C+ (
     C+   :SYSID, :WStatus,
     C+   :WStrDate,  :WStrTime,
     C+   :WEndDate,  :WEndTime,
     C+   :PSJobName, :PSUser, :PSJobNo
     C+ )
     C/end-exec

      ** Else, update the file
     C                   ELSE
     C/exec SQL
     C+ update SDCSTSTD
     C+ set SDSTAT = :WStatus,
     C+     SDSTDT = :WStrDate,  SDSTTM = :WStrTime,
     C+     SDENDT = :WEndDate,  SDENTM = :WEndTime,
     C+     SDJOBN = :PSJobName, SDJOBU = :PSUser, SDJNBR = :PSJobNo
     C+ where SDZONE = :SYSID
     C/end-exec
     C                   ENDIF

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

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetINTDATE - Determine Interest Period Dates                *
      *                                                               *
      *****************************************************************
     C     SRDetINTDATE  BEGSR

      ** Determine Interest Period Start Date
     C                   EVAL      IntPerSDATE = 0
     C                   IF        TrADDI = 'L'
     C                   EVAL      IntPerSDATE = TrSLID + 1
     C                   ELSE
     C                   EVAL      IntPerSDATE = TrSLID
     C                   ENDIF

      ** Determine Interest Period End Date
     C                   EVAL      WrkDATE = 0
     C                   EVAL      IntPerEDATE = 0
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

     C                   IF        WrkDATE = 0
     C                   EVAL      WrkDATE = BJDNWD - 1
     C                   ENDIF

     C                   IF        TrADDI = 'F'
     C                   EVAL      IntPerEDATE = WrkDATE - 1
     C                   ELSE
     C                   EVAL      IntPerEDATE = WrkDATE
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
     C                   ENDIF

      ** Get the starting date of the Rates Known Window
      ** Rates Known Date = Interest Period End Date minus
      ** (Lookback + Lockout) plus Publication Lag Days
     C                   EVAL      RTKNDate = 0
     C                   EVAL      SumLBLO = TrLBDY + TrLODY

     C                   CALL      'ZBKDT'
     C                   PARM      IntPerEDATE   ZDAYNO            5 0
     C                   PARM      TrCCY         ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
     C                   PARM      SumLBLO       ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0

     C                   EVAL      RTKNDate = ZDYNBR

     C                   CALL      'ZFWDT'
     C                   PARM      RTKNDate      ZDAYNO
     C                   PARM      RPubLag       ZNRDYS
     C                   PARM                    ZDYNBR
     C                   PARM      TrCCY         ZCCY
     C                   PARM      *BLANKS       ZLOC

     C                   EVAL      RTKNDate = ZDYNBR

      ** Set the Rates Known flag if the computed Rates Known Date has
      ** passed the system date and the reference rate publication time
     C                   IF        RTKNDate <= BJRDNB and
     C                             RTKNDate <> 0
     C                   EVAL      CurrTime = %char(%time():*HMS)
     C                   IF        CurrTime >= RPubTim
     C                   EVAL      RatesKnown = 'Y'
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

      ** Convert Interest Period End Date into *ISO Date Format
     C                   EVAL      ZDAYNO = IntPerEDATE
     C                   EXSR      SRZDATE
     C                   EVAL      IntPrdEndDt = %char(ISODate)

     C                   EVAL      RiskFreeRate = TrRFRR

     C                   MOVE      TrFLOR        WRateFloor
     C                   EVAL      RiskFreeRatFl = %trim(WRateFloor)

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
     C                   IF        WrkDATE > IntPerEDATE
     C                   EVAL      WrkDATE = IntPerEDATE
     C                   ENDIF
     C                   EVAL      ZDAYNO = WrkDATE
     C                   EXSR      SRZDATE
     C                   EVAL      WCalcTillDate = %char(ISODate)

     C                   MOVE      TrBADJ        BenchMarkAdj

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallARRC - Call program that will invoke the ARR Calculator *
      *                                                               *
      *****************************************************************
     C     SRCallARRC    BEGSR

     C                   CALL      'ZAGETCALRT'
     C                   PARM                    ModuleID
     C                   PARM                    TransREF
     C                   PARM                    CalcMethod
     C                   PARM                    IntPrdStartDt
     C                   PARM                    IntPrdEndDt
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
     C                   EVAL      DBASE  = 005
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

      ** Retrieve System ID
     C     *LOCK         IN        SDSTAT
     C                   OUT       SDSTAT

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

     C                   EVAL      WStatus = 'F'
     C                   EXSR      SRUpdSTAT

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
