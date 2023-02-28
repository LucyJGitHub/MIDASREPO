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
      *  Last Amend No. MD060441           Date 01Feb23               *
      *  Prev Amend No. MD060959           Date 26Jan23               *
      *                 MD060883           Date 22Jan23               *
      *                 MD060823           Date 12Dec22               *
      *                 MD058517           Date 17Oct22               *
      *                 MD060008           Date 11May21               *
      *                 MD060033           Date 25Sep22               *
      *                 249385             Date 01Aug22               *
      *                 MD059424           Date 29Mar22               *
      *                 MD059375           Date 20Dec21               *
      *                 MD059270           Date 16Dec21               *
      *                 MD059253           Date 19Nov21               *
      *                 CIR020             Date 02Aug21               *
      *                 MD059190           Date 08Nov21               *
      *                 MD059137           Date 29Oct21               *
      *                 MD059128           Date 28Oct21               *
      *                 MD058708           Date 31Aug21               *
      *                 CDL102             Date 01Jun21               *
      *                 MD058182           Date 25May21               *
      *                 MD058040A          Date 25May21               *
      *                 MD058138           Date 18May21               *
      *                 MD058106           Date 18May21               *
      *                 MD058040           Date 11May21               *
      *                 MD057946           Date 27Apr21               *
      *                 CLE172             Date 01Oct20               *
      *                 CSD103  *CREATE    Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060441 - CLE172 CC9 - Back-valued Rollover to a            *
      *             backward looking rate                             *
      *  MD060959 -  Loans whose repayment falls on a holiday is      *
      *              reported as Rates Known 'Y' in SDRTKNTD.         *
      *              Amend subroutine SRChk2ndCall to include         *
      *              records whose payment date is greater than       *
      *              previous run date and less than current rundate. *
      *  MD060883 -  Matured loans are still processed/reported by    *
      *              the ARR calculator.                              *
      *              Do not process the loan record if the interest   *
      *              period start date is equal to maturiy date of    *
      *              the loan.                                        *
      *  MD060823 -  Rolled over loan using SARR calculation method   *
      *              was not processed by calculator and reported     *
      *              as an exception.                                 *
      *              Amended SQL statement in second ARR calculator   *
      *              call so that risk free rate is also retrieved    *
      *              on rollover                                      *
      *  MD058517 - CLE172 LIBOR Lending- Change Control CC3.1        *
      *             Interest Projection Using Known Rates             *
      *             CC10 CLE172 Spool File Correspondence (MD059817)  *
      *  MD060008 - Deliverable Data Split for Standing Data 2        *
      *  MD060033 - Rates Known flag set a day late.  Add 1 day to    *
      *             SumLBLO.  Introduce new system value              *
      *             ARRUseSysOrMidasDate.                             *
      *  249385 - Ensure input fields ZDAYNO keeps original value     *
      *            (Recompiled due to changes in ZBKDT_ILE)           *
      *  MD059424 - Calculator returned rates for previous period of  *
      *             deal defined with forward rate prior to amending  *
      *             the rate into backward-looking. Pass the new      *
      *             interest period start and end date for amended    *
      *             backward-looking deal with rate change and last   *
      *             change date equal to rundate.                     *
      *  MD059375 - Rate change date should mark the start of the new *
      *             interest period and not the Interest Payment Date.*
      *             If UIACD/TIACD <> URCHG/TRCHG, use URCHG/TRCHG    *
      *             field as the start of interest period.            *
      *  MD059270 - Interest period end date of last period for 2nd   *
      *             call of ARR calculator is set to maturity date.   *
      *             Amend fix MD-59253 to set it to maturity date - 1.*
      *  MD059253 - DLC0606B failed due to missing record in DAMBRDI. *
      *             Do a second call of ARR calculator for existing   *
      *             backward looking IRS deals and next rate change   *
      *             date is less than the next working date.          *
      *  CIR020 - LIBOR Deregulation - FRA/IRS                        *
      *  MD059190 - Do a second call of ARR calculator for existing   *
      *             backward looking rate loans and next interest due *
      *             date is equal to rundate. Use ARR rollover details*
      *             if valued on the the same date and authorised.    *
      *  MD059137 - Determine new interest period start and end date  *
      *             of migrated loans with rollover date and interest *
      *             due date equal to rundate.                        *
      *  MD059128 - Also select backward looking loan with future     *
      *             rollover date.                                    *
      *  MD058708 - SD001110P2 does not reflect BC specific changes   *
      *             (base rate code and ARR parameters). Add Base     *
      *             Rate Code field in extract file.                  *
      *  CDL102 - LIBOR Deregulation - Dealing                        *
      *  MD058182 - Missing BR event on LOAC despite calculator       *
      *             returned complete rates. Pass a Control Date to   *
      *             ZAGETCALRT (used in writing records on SDHSDRTD). *
      *  MD058040A - Duplicate records still found in HISTSHQ. Remove *
      *              deletion of records on SDHSDRTD so that for NCCR *
      *              and SARR, program will only extract the new rate *
      *              not yet applied on Midas.                        *
      *  MD058138 - Interest accrual and settlement is less one day   *
      *             for loan with ADDI = L-Last. Set IntPerSDATE      *
      *             equal to transaction start date/last int pay date *
      *             and IntPerEDATE to next int pay date-1 for ADDI=L.*
      *  MD058106 - Rates Known Flag not updated. If within the rates *
      *             known period, pass calcTillDate = int. end date   *
      *             when calc method is SARR. Also, use the actual    *
      *             int. payment date to determine rates known date.  *
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
      * SRCrtBLRT     - Insert to extract file all Midas Transactions *                       CDL102
      *                 using a Backward Looking Rate                 *                       CDL102
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
     F*SDLIBRTD* IF   E           K DISK    INFSR(*PSSR)                                    MD060008

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

      ** Data Sructure for switchable feature details                                         CDL102
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL102
                                                                                              CDL102
      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data Structure for Backward-Looking Rate Loans
     D TransBLRT     E DS                  EXTNAME(SDBJEXPD)                                  CDL102
     D***LoanBLRT        DS                                                                   CDL102
     D**TrMODI**                      2A                                                      CDL102
     D**TrTRAN**                      6A                                                      CDL102
     D**TrCCY***                      3A                                                      CDL102
     D**TrVDAT**                      5S 0                                                    CDL102
     D**TrMDAT**                      5S 0                                                    CDL102
     D**TrNIDT**                      5S 0                                                    CDL102
     D**TrNRPD**                      5S 0                                                    CDL102
     D**TrREPT**                      1S 0                                                    CDL102
     D**TrADDI**                      1A                                                      CDL102
     D**TrBLRT**                      1A                                                      CDL102
     D**TrRFRR**                     10A                                                      CDL102
     D**TrCALM**                      4A                                                      CDL102
     D**TrBADJ**                     11S 7                                                    CDL102
     D**TrFLOR**                     11S 7                                                    CDL102
     D**TrLBDY**                      2S 0                                                    CDL102
     D**TrLODY**                      2S 0                                                    CDL102
     D**TrOPSH**                      1A                                                      CDL102
     D**TrRRDP**                      2S 0                                                    CDL102
     D**TrDBAV**                      1S 0                                                    CDL102

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
     D RTKNOWDS      e ds                  extname(SDRTKNTD)                                MD058517
     D RateKnownDS     ds                  likeds(RTKNOWDS)                                 MD058517
      ** Data area to read previous run date                                                MD060959
     D JNSTAT          DS           200                                                     MD060959
     D  PRUN                 103    105P 0                                                  MD060959

      ** Constants declaration
     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)
     D EC              c                   const('  0 .       ')                            MD057946
     D AMP             c                   const('&')                                       MD058517
     D INSERT          c                   const(0)                                         MD058517
     D QUE             c                   const('?')                                       MD058517
     D QUO             c                   const('''')                                      MD058517
     D UPDATE          c                   const(1)                                         MD058517
     D isARRParamChg   S              1N                                                    MD060441

      ** Reference Rates Array
     D ArraySize       C                   CONST(10)
     D ArrRFR          S             10A   DIM(ArraySize)
     D ArrPubLag       S              2S 0 DIM(ArraySize)
     D ArrPubTim       S              5A   DIM(ArraySize)

      ** Parameters for calling access programs
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A                                                      CDL102

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
     D CLE172          S              1A                                                      CDL102
     D CDL102          S              1A                                                      CDL102
     D CIR020          S              1A                                                      CIR020
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
     D ControlDate     S              5A                                                    MD058182
     D wEvntCtrlDate   S              5A                                                    MD058517
     D WrkMigrate      S              1A                                                    MD059137
     D Wrk2ndCall      S              1A   INZ('N')                                         MD059190
     D WrkEndDate      S              5P 0                                                  MD059190
     D WrkBasDate      S              5P 0                                                  MD059190
     D PMode           S              1A                                                    MD059190
     D PDealRef        S              6A                                                    MD059253
     D PLeg            S              1A                                                    MD059253
     D ISODate         S               D   DATFMT(*ISO)
     D IntPerSDATE     S                   LIKE(TrNIDT)
     D IntPerEDATE     S                   LIKE(TrNIDT)
     D RTKNDate        S                   LIKE(TrNIDT)
     D WrkDATE         S                   LIKE(TrNIDT)
     D IntPayDate      S                   LIKE(TrNIDT)                                     MD058106
     D KRFRR           S                   LIKE(SCRFLD)
     D RPubLag         S                   LIKE(PUBLAG)
     D RPubTim         S                   LIKE(PUBTIM)
     D wSqlStr         S           2000A   INZ(*BLANKS)                                     MD058517
     D action          s              1s 0                                                  MD058517
     D SysDate         S               D   DATFMT(*ISO)                                     MD060033
     D SysOrMidas      S              1A                                                    MD060033
     D SDLIBR        E DS                  EXTNAME(SDLIBJW0)                                MD060008
     D  isRework       S              1N   INZ(*OFF)                                        MD060441
                                                                                            MD060441
      ** Data structure for ARR Calculator (Before Image)                                   MD060441
     D befARRDetails   DS                                                                   MD060441
     D    B_RFRR                     10A                                                    MD060441
     D    B_CALM                      4A                                                    MD060441
     D    B_BADJ                     11P 7                                                  MD060441
     D    B_FLOR                     11P 7                                                  MD060441
     D    B_LBDY                      2  0                                                  MD060441
     D    B_LODY                      2  0                                                  MD060441
     D    B_OPSH                      1                                                     MD060441
     D    B_RRDP                      2  0                                                  MD060441
     D    B_DBAV                      1  0                                                  MD060441
     D    B_BLRT                      1                                                     MD060441
     D    B_NBLRT                     1                                                     MD060441

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

      ** Insert to extract file all Midas Transactions using a                             CDL102
      ** backward looking rate                                                             CDL102
     C                   EXSR      SRCrtBLRT                                               CDL102
                                                                                           CDL102
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
                                                                                            MD060883
     C                   IF        TRMODI = 'LE' AND IntPerSDATE = TRMDAT                   MD060883
     C                   EVAL      Wrk2ndCall = 'N'                                         MD060883
     C                   EXSR      SRReadNEXT                                               MD060883
     C                   ITER                                                               MD060883
     C                   ENDIF                                                              MD060883
                                                                                            MD060441
     C                   EXSR      srChkIfRework                                            MD060441

      ***If*the*backward-looking*rate*parameters*are*changed*via******              CLE172 MD058040A
      ***Rollover,*this*will*be*applied*to*the*whole*interest*period.*              CLE172 MD058040A
      ***Thus,*existing*daily*rates*records*should*be*deleted.********              CLE172 MD058040A
     C***/exec SQL                                                                  CLE172 MD058040A
     C***+ select count(*) into :NoOfRecs                                           CLE172 MD058040A
     C***+ from LEROBLPD                                                            CLE172 MD058040A
     C***+ where ROLNRF = :TrTRAN                                                   CLE172 MD058040A
     C***/end-exec                                                                  CLE172 MD058040A
      ****************************************************************              CLE172 MD058040A
     C**********         IF        NoOfRecs <> 0                                    CLE172 MD058040A
      ****************************************************************              CLE172 MD058040A
     C***/exec SQL                                                                  CLE172 MD058040A
     C***+ delete from SDHSDRTD                                                     CLE172 MD058040A
     C***+ where CMODID = :TrMODI                                                   CLE172 MD058040A
     C***+   and CTRNID = :TrTRAN                                                   CLE172 MD058040A
     C***+   and CINPSD = :IntPerSDATE                                              CLE172 MD058040A
     C***+   and CINPED = :IntPerEDATE                                              CLE172 MD058040A
     C***/end-exec                                                                  CLE172 MD058040A
     C**********         IF        SQLCODE <> NO_ERROR and                          CLE172 MD058040A
     C**********                   SQLCODE <> NO_RECORD                             CLE172 MD058040A
     C**********         EVAL      DBFILE = 'SQLERROR'                              CLE172 MD058040A
     C**********         EVAL      DBKEY  = 'SQL ERROR'                             CLE172 MD058040A
     C**********         EVAL      DBASE  = 004                                     CLE172 MD058040A
     C**********         EXSR      *PSSR                                            CLE172 MD058040A
     C**********         ENDIF                                                      CLE172 MD058040A
      ****************************************************************              CLE172 MD058040A
     C**********         ENDIF                                                      CLE172 MD058040A
                                                                                    CLE172 MD058040A
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
                                                                                            MD058106
      ** CalcTillDate is required for SARR calc method, set it                              MD058106
      ** equal to Interest Period End Date                                                  MD058106
     C                   IF        CalcMethod = 'SARR'                                      MD058106
     C                   EVAL      CalcTillDate = IntPrdEndDt                               MD058106
     C                   ENDIF                                                              MD058106
                                                                                            MD058106
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
                                                                                            MD059190
     C                   IF        Wrk2ndCall = 'Y'                                         MD059190
     C                   EVAL      Wrk2ndCall = 'N'                                         MD059190
     C                   EXSR      SRReadNEXT                                               MD059190
     C                   ITER                                                               MD059190
     C                   ENDIF                                                              MD059190
     C                   IF        TrMODI = 'LE'                                            MD059190
     C                   EXSR      SRChk2ndCall                                             MD059190
     C                   ENDIF                                                              MD059190
      ** For IRS deal, issue 2nd call to ARR Calculator if                                  MD059253
      ** Rate Change Date is less than next working date.                                   MD059253
     C                   IF        TrMODI = 'RU' or                                         MD059253
     C                             TrMODI = 'RT'                                            MD059253
     C                   EVAL      Wrk2ndCall = 'N'                                         MD059253
     C                   IF        TrNIDT >= BJRDNB and                                     MD059253
     C                             TrNIDT <= EventCtrlDate                                  MD059253
     C                   EVAL      Wrk2ndCall = 'Y'                                         MD059253
     C                   ENDIF                                                              MD059253
     C                   ENDIF                                                              MD059253
                                                                                            MD059253
     C                   IF        Wrk2ndCall = 'Y'                                         MD059190
     C                   ITER                                                               MD059190
     C                   ENDIF                                                              MD059190

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
      **SRSelTRAN*-*Select*backward-looking*rate*transactions**********                       CDL102
      * SRCrtBLRT - Insert to an extract file all Midas Transactions  *                       CDL102
      *             using a Backward Looking Rate                     *                       CDL102
      *                                                               *
      *****************************************************************
     C*****SRSelTRAN     BEGSR                                                                CDL102
     C     SRCrtBLRT     BEGSR                                                                CDL102

      ** Select loan transactions which uses a backward looking-rate
     C                   IF        CLE172 = 'Y'                                               CDL102
     C/exec SQL
     C***declare TransBLRTCursor insensitive scroll cursor for                                CDL102
     C+ insert into SDBJEXPD                                                                  CDL102
     C+ select 'LE', LNRF, CCY,  VDAT, MDAT,
     C*********NIDT, NRPD, REPT, ADDI, BLRT,                                                  CDL102
     C+        NIDT, NRPD, REPT, SLID, ADDI, BLRT,                                            CDL102
     C+        RFRR, CALM, BADJ, FLOR, LBDY,
     C*********LODY, OPSH, RRDP, DBAV                                                       MD058708
     C+        LODY, OPSH, RRDP, DBAV, BRTT                                                 MD058708
     C+ from CLOANCL
     C+ where RECI = 'D' and VDAT < :BJDNWD
     C+   and BLRT = 'Y' and CALM <> 'MANL'
     C+   and PTYP in ( 61, 62, 64, 66, 68, 69, 70, 71, 72 )
     C****and RLDT = 0                                                                      MD059128
     C+   and (RLDT = 0 or RLDT >= :BJDNWD)                                                 MD059128
     C+ union all                                                                             CLE172
     C+ select 'LE',   LNRF,   CCY,    VDAT,   MDAT,                                          CLE172
     C*********NIDT,   NRPD,   REPT,   ADDI,   ROBLRT,                                 CLE172 CDL102
     C+        NIDT,   NRPD,   REPT,   SLID,   ADDI,   ROBLRT,                                CDL102
     C+        RORFRR, ROCALM, ROBADJ, ROFLOR, ROLBDY,                                        CLE172
     C*********ROLODY, ROOPSH, RORRDP, RODBAV                                        CLE172 MD058708
     C+        ROLODY, ROOPSH, RORRDP, RODBAV, BRTT                                         MD058708
     C+ from LEROBLPD                                                                         CLE172
     C+ left join CLOANCL                                                                     CLE172
     C+ on ROLNRF = LNRF                                                                      CLE172
     C+ where ROLNRF is not null and ROCALM <> 'MANL'                                         CLE172
     C+ with nc                                                                               CDL102
     C/end-exec
     C                   ENDIF                                                                CDL102
                                                                                              CDL102
      ** Select deal transactions which uses a backward looking-rate                          CDL102
     C                   IF        CDL102 = 'Y'                                               CDL102
                                                                                              CDL102
      ** Extract the latest authorised BC Deal amendment                                      CDL102
     C/exec SQL                                                                               CDL102
     C+ insert into DLBCAMPD                                                                  CDL102
     C+ select digits(a.HNDA38), a.HNDVSD,                                                    CDL102
     C+        a.HNBLRT, a.HNRFRR, a.HNCALM, a.HNBADJ, a.HNFLOR,                              CDL102
     C+        a.HNLBDY, a.HNLODY, a.HNOPSH, a.HNRRDP, a.HNDBAV                               CDL102
     C+      , a.HNBSRT                                                                     MD058708
     C+ from MMDEAMPP a                                                                       CDL102
     C+ where a.HNDS38 in                                                                     CDL102
     C+       (select max(b.HNDS38)                                                           CDL102
     C+          from MMDEAMPP b                                                              CDL102
     C+         where b.HNMTYP = 'BC' and b.HNDSTS = 'A'                                      CDL102
     C+           and b.HNCHTP <> 'R' and b.HNDVSD < :BJDNWD                                  CDL102
     C+           and a.HNDA38 = b.HNDA38)                                                    CDL102
     C+ with nc                                                                               CDL102
     C/end-exec                                                                               CDL102
                                                                                              CDL102
      ** Authorised BC deal amendment using backward looking rate                             CDL102
     C/exec SQL                                                                               CDL102
     C+ insert into SDBJEXPD                                                                  CDL102
     C+ select 'DL', digits(DLNO),                                                            CDL102
     C+        CCY,  VDAT, MDAT,                                                              CDL102
     C+        NIDT, 0, 0, SLID, JFLID,                                                       CDL102
     C+        DLBLRT, DLRFRR, DLCALM, DLBADJ, DLFLOR,                                        CDL102
     C*********DLLBDY, DLLODY, DLOPSH, DLRRDP, DLDBAV                                CDL102 MD058708
     C+        DLLBDY, DLLODY, DLOPSH, DLRRDP, DLDBAV, DLBRTT                               MD058708
     C+ from DLBCAMPD                                                                         CDL102
     C+ inner join DEALSDC                                                                    CDL102
     C+ on DLDLNO = DLNO                                                                      CDL102
     C+ where DLBLRT = 'Y' and DLCALM <> 'MANL'                                               CDL102
     C+ with nc                                                                               CDL102
     C/end-exec                                                                               CDL102
                                                                                              CDL102
      ** Other deal transactions using backward looking rate                                  CDL102
     C/exec SQL                                                                               CDL102
     C+ insert into SDBJEXPD                                                                  CDL102
     C+ select 'DL', digits(DLNO),                                                            CDL102
     C+        CCY,  VDAT, MDAT,                                                              CDL102
     C+        NIDT, 0, 0, SLID, JFLID,                                                       CDL102
     C+        BLRT, RFRR, CALM, BADJ, FLOR,                                                  CDL102
     C*********LBDY, LODY, OPSH, RRDP, DBAV                                          CDL102 MD058708
     C+        LBDY, LODY, OPSH, RRDP, DBAV, BRTT                                           MD058708
     C+ from DEALSDC                                                                          CDL102
     C+ where RECI = 'D' and VDAT < :BJDNWD                                                   CDL102
     C+   and BLRT = 'Y' and CALM <> 'MANL'                                                   CDL102
     C+   and DTYP in ('CD','CI','CL','DL','IP',                                              CDL102
     C+                'IT','TD','TI','IL','ID')                                              CDL102
     C+   and digits(DLNO) not in (select DLDLNO from DLBCAMPD)                               CDL102
     C+ with nc                                                                               CDL102
     C/end-exec                                                                               CDL102
     C                   ENDIF                                                                CDL102
                                                                                              CDL102
     C                   IF        CIR020 = 'Y'                                               CIR020
                                                                                              CIR020
      ** Select the IRS deal if OURS interest detail                                          CIR020
      ** is using a backward looking-rate                                                     CIR020
     C/exec SQL                                                                               CIR020
     C+ insert into SDBJEXPD                                                                  CIR020
     C+ select 'RU', digits(DLNO),                                                            CIR020
     C+        UCUCY, VDAT, MDAT,                                                             CIR020
     C*********UNICD, 0, 0, UIACD, ' ',                                              CIR020 MD059375
     C+        UNICD, 0, 0,                                                                 MD059375
     C+        case when UIACD <> URCHG and URCHG <> 0                                      MD059375
     C+         then URCHG                                                                  MD059375
     C+         else UIACD end, ' ',                                                        MD059375
     C+        UBLRT, URFRR, UCALM, UBADJ, UFLOR,                                             CIR020
     C+        ULBDY, ULODY, UOPSH, URRDP, UDBAV, UBRTT                                       CIR020
     C+ from DEALSDG                                                                          CIR020
     C+ where RECI = 'D' and VDAT < :BJDNWD                                                   CIR020
     C+   and UBLRT = 'Y' and UCALM <> 'MANL'                                                 CIR020
     C+   and UICFR <> 'O'                                                                    CIR020
     C+   and DTYP in ('RS','RX','RP','RR','RF')                                              CIR020
     C+ with nc                                                                               CIR020
     C/end-exec                                                                               CIR020
                                                                                              CIR020
      ** Select the IRS deal if THEIRS interest detail                                        CIR020
      ** is using a backward looking-rate                                                     CIR020
     C/exec SQL                                                                               CIR020
     C+ insert into SDBJEXPD                                                                  CIR020
     C+ select 'RT', digits(DLNO),                                                            CIR020
     C+        TCUCY, VDAT, MDAT,                                                             CIR020
     C*********TNICD, 0, 0, TIACD, ' ',                                              CIR020 MD059375
     C+        TNICD, 0, 0,                                                                 MD059375
     C+        case when TIACD <> TRCHG and TRCHG <> 0                                      MD059375
     C+         then TRCHG                                                                  MD059375
     C+         else TIACD end, ' ',                                                        MD059375
     C+        TBLRT, TRFRR, TCALM, TBADJ, TFLOR,                                             CIR020
     C+        TLBDY, TLODY, TOPSH, TRRDP, TDBAV, TBRTT                                       CIR020
     C+ from DEALSDG                                                                          CIR020
     C+ where RECI = 'D' and VDAT < :BJDNWD                                                   CIR020
     C+   and TBLRT = 'Y' and TCALM <> 'MANL'                                                 CIR020
     C+   and TICFR <> 'O'                                                                    CIR020
     C+   and DTYP in ('RS','RX','RP','RR','RF')                                              CIR020
     C+ with nc                                                                               CIR020
     C/end-exec                                                                               CIR020
     C                   ENDIF                                                                CIR020
                                                                                              CIR020
     C                   IF        SQLCODE <> NO_ERROR and                                    CDL102
     C                             SQLCODE <> NO_RECORD                                       CDL102
     C                   EVAL      DBFILE = 'SQLERROR'                                        CDL102
     C                   EVAL      DBKEY  = 'SQL ERROR'                                       CDL102
     C                   EVAL      DBASE  = 007                                               CDL102
     C                   EXSR      *PSSR                                                      CDL102
     C                   ENDIF                                                                CDL102
                                                                                              CDL102
     C                   ENDSR                                                                CDL102
      *****************************************************************                       CDL102
      /EJECT                                                                                  CDL102
      *****************************************************************                       CDL102
      *                                                               *                       CDL102
      * SRSelTRAN - Select backward-looking rate transactions         *                       CDL102
      *                                                               *                       CDL102
      *****************************************************************                       CDL102
     C     SRSelTRAN     BEGSR                                                                CDL102
                                                                                              CDL102
     C/exec SQL                                                                               CDL102
     C+ declare TransBLRTCursor insensitive scroll cursor for                                 CDL102
     C+ select * from SDBJEXPD                                                                CDL102
     C/end-exec                                                                               CDL102

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
     C***fetch next from TransBLRTCursor into :LoanBLRT                                       CDL102
     C+ fetch next from TransBLRTCursor into :TransBLRT                                       CDL102
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

     C                   SELECT                                                               CDL102
     C                   WHEN      TrMODI = 'LE'                                              CDL102
     C/exec SQL
     C+ update CLOANCL
     C+ set RTKN = :RatesKnown
     C+ where LNRF = :TransREF
     C/end-exec

     C                   WHEN      TrMODI = 'DL'                                              CDL102
     C/exec SQL                                                                               CDL102
     C+ update DEALSDC                                                                        CDL102
     C+ set RTKN = :RatesKnown                                                                CDL102
     C+ where DLNO = :TransREF                                                                CDL102
     C/end-exec                                                                               CDL102
                                                                                              CDL102
     C/exec SQL                                                                               CDL102
     C+ update MMDELDPP                                                                       CDL102
     C+ set HKRTKN = :RatesKnown                                                              CDL102
     C+ where HKDN38 = :TransREF                                                              CDL102
     C/end-exec                                                                               CDL102
                                                                                              CIR020
     C                   WHEN      TrMODI = 'RU'                                              CIR020
     C/exec SQL                                                                               CIR020
     C+ update DEALSDG                                                                        CIR020
     C+ set URTKN = :RatesKnown                                                               CIR020
     C+ where DLNO = :TransREF                                                                CIR020
     C/end-exec                                                                               CIR020
                                                                                              CIR020
     C                   WHEN      TrMODI = 'RT'                                              CIR020
     C/exec SQL                                                                               CIR020
     C+ update DEALSDG                                                                        CIR020
     C+ set TRTKN = :RatesKnown                                                               CIR020
     C+ where DLNO = :TransREF                                                                CIR020
     C/end-exec                                                                               CIR020
                                                                                              CDL102
     C                   ENDSL                                                                CDL102

     C                   IF        SQLCODE <> NO_ERROR and
     C                             SQLCODE <> NO_RECORD
     C                   EVAL      DBFILE = 'SQLERROR'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C**********         EVAL      DBASE  = 006                                               CIR020
     C                   EVAL      DBASE  = 008                                               CIR020
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            MD058517
     C                   IF        CLE172 = 'Y'                                             MD058517
     C                   EXSR      SRupdRTKN                                                MD058517
     C                   ENDIF                                                              MD058517

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
     C                   IF        TrMODI = 'LE'                                              CDL102
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
     C                   ENDIF                                                                CDL102
     C                                                                                        CDL102
     C                   IF        TrMODI = 'DL'                                              CDL102
     C                             or TrMODI = 'RU'                                           CIR020
     C                             or TrMODI = 'RT'                                           CIR020
     C                   EVAL      WrkDATE = TrSLID                                           CDL102
     C                   ENDIF                                                                CDL102

      ** If work date is zero, set to transaction start date
     C                   IF        WrkDATE = 0
     C                   EVAL      WrkDATE = TrVDAT
     C                   ENDIF

     C                   ENDIF
      *                                                                                     MD059137
      ** If start date is within loan value date then check                                 MD059137
      ** further if new interest period is started on rollover date                         MD059137
      ** i.e. loan is being migrated to backward looking on rundate                         MD059137
      *                                                                                     MD059137
     C                   EVAL      WrkMigrate = 'N'                                         MD059137
     C                   IF        WrkDate >= TrVDAT                                        MD059137
     C                             AND TrMODI = 'LE'                                        MD059137
     C/exec SQL                                                                             MD059137
     C+ select count(*) into :NoOfRecs                                                      MD059137
     C+ from CLOANCL                                                                        MD059137
     C+ where LNRF = :TrTRAN                                                                MD059137
     C+   and (NIDT = :BJRDNB or (NRPD = :BJRDNB and REPT <> 2))                            MD059137
     C+   and RLDT = :BJRDNB                                                                MD059137
     C+   and BLRT = 'N'                                                                    MD059137
     C+   and NBLRT = 'Y'                                                                   MD059137
     C/end-exec                                                                             MD059137
     C                   IF        NoOfRecs <> 0                                            MD059137
     C                   EVAL      WrkMigrate = 'Y'                                         MD059137
     C                   ENDIF                                                              MD059137
     C                   ENDIF                                                              MD059137
     C                   EVAL      NoOfRecs = 0                                             MD059137
                                                                                            MD059424
      ** If IRS deal and start date is within value date then check if                      MD059424
      ** deal is being migrated to backward looking on rundate                              MD059424
      ** which is also the deal's rate change date                                          MD059424
                                                                                            MD059424
     C                   IF        WrkDate >= TrVDAT                                        MD059424
     C                             and TrMODI = 'RU'                                        MD059424
     C                   EVAL      WrkMigrate = 'N'                                         MD059424
     C/exec SQL                                                                             MD059424
     C+ select count(*) into :NoOfRecs                                                      MD059424
     C+ from DEALSDG                                                                        MD059424
     C+ where DLNO = :TrTRAN and UNICD = :BJRDNB                                            MD059424
     C+   and LCD = :BJRDNB  and UBLRT = 'Y'                                                MD059424
     C/end-exec                                                                             MD059424
     C                   IF        NoOfRecs <> 0                                            MD059424
     C                   EVAL      WrkMigrate = 'Y'                                         MD059424
     C                   ENDIF                                                              MD059424
     C                   ENDIF                                                              MD059424
                                                                                            MD059424
     C                   IF        WrkDate >= TrVDAT                                        MD059424
     C                             and TrMODI = 'RT'                                        MD059424
     C                   EVAL      WrkMigrate = 'N'                                         MD059424
     C/exec SQL                                                                             MD059424
     C+ select count(*) into :NoOfRecs                                                      MD059424
     C+ from DEALSDG                                                                        MD059424
     C+ where DLNO = :TrTRAN and TNICD = :BJRDNB                                            MD059424
     C+   and LCD = :BJRDNB  and TBLRT = 'Y'                                                MD059424
     C/end-exec                                                                             MD059424
     C                   IF        NoOfRecs <> 0                                            MD059424
     C                   EVAL      WrkMigrate = 'Y'                                         MD059424
     C                   ENDIF                                                              MD059424
     C                   ENDIF                                                              MD059424
                                                                                            MD059424
     C                   EVAL      NoOfRecs = 0                                             MD059424
                                                                                            MD059424

      ** Determine Interest Period Start Date
     C                   EVAL      IntPerSDATE = 0
     C**********         IF        TrADDI = 'L'                                             MD058138
     C**********         EVAL      IntPerSDATE = WrkDATE + 1                                MD058138
     C**********         ELSE                                                               MD058138
     C                   EVAL      IntPerSDATE = WrkDATE
     C**********         ENDIF                                                              MD058138

      ** Get the Next Interest Payment Date
     C                   EVAL      WrkDATE = 0
     C                   IF        TrMODI = 'LE'                                              CDL102
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
      *                                                                                     MD059137
      ** Override Interest period Start Date and End date                                   MD059137
      *                                                                                     MD059137
     C                   IF        WrkMigrate = 'Y'                                         MD059137
     C                             and WrkDATE <> TrMDAT                                    MD059137
     C                             or Wrk2ndCall = 'Y'                                      MD059190
     C                   EVAL      IntPerSDATE = WrkDATE                                    MD059137
     C                   ENDIF                                                              MD059137
     C                   ENDIF                                                                CDL102
     C                                                                                        CDL102
     C                   IF        TrMODI = 'DL'                                              CDL102
     C                             or TrMODI = 'RU'                                           CIR020
     C                             or TrMODI = 'RT'                                           CIR020
     C                   IF        TrNIDT <> 0                                                CDL102
     C                   EVAL      WrkDATE = TrNIDT                                           CDL102
     C                   ELSE                                                                 CDL102
     C                   EVAL      WrkDATE = TrMDAT                                           CDL102
     C                   ENDIF                                                                CDL102
     C                   ENDIF                                                                CDL102

      ** If IRS deal and 2nd call to ARR Calculator is needed,                              MD059253
      ** OR deal is being migrated into backward-looking,                                   MD059424
      ** determine next Interest Period Start Date                                          MD059253
     C                   IF        (TrMODI = 'RU' or TrMODI = 'RT')                         MD059253
     C**********                   and Wrk2ndCall = 'Y'                            MD059253 MD059424
     C                   IF        WrkMigrate = 'Y' and WrkDATE <> TrMDAT                   MD059424
     C                             or Wrk2ndCall = 'Y'                                      MD059424
     C                   EVAL      IntPerSDATE = WrkDATE                                    MD059253
     C                   ENDIF                                                              MD059253
                                                                                            MD059253
     C                   ENDIF                                                              MD059424
                                                                                            MD059424
      ** Save the actual interest payment date to a work variable                           MD058106
     C                   EVAL      IntPayDate = WrkDATE                                     MD058106
                                                                                            MD058106
      ** Determine Interest Period End Date
     C                   EVAL      IntPerEDATE = 0
     C**********         IF        TrADDI = 'L'                                             MD058138
     C**********         EVAL      IntPerEDATE = WrkDATE                                    MD058138
     C**********         ELSE                                                               MD058138
     C                   EVAL      IntPerEDATE = WrkDATE - 1
     C**********         ENDIF                                                              MD058138

     C                   IF        TrMODI = 'LE'                                              CDL102
                                                                                              CDL102
      ** If the Additional Day Indicator is B-Both, the last interest                         CLE172
      ** period will be extended by 1 day to include the maturity date                        CLE172
     C                   IF        TrADDI = 'B' and                                           CLE172
     C                             WrkDATE = TrMDAT                                           CLE172
     C                   EVAL      IntPerEDATE = WrkDATE                                      CLE172
     C                   ENDIF                                                                CLE172
                                                                                              CLE172
     C                   ENDIF                                                                CDL102
     C                                                                                        CDL102
     C                   IF        TrMODI = 'DL'                                              CDL102
     C                   IF        TrADDI = 'Y' and                                           CDL102
     C                             WrkDATE = TrMDAT                                           CDL102
     C                   EVAL      IntPerEDATE = WrkDATE                                      CDL102
     C                   ENDIF                                                                CDL102
     C                   ENDIF                                                                CDL102
                                                                                            MD059253
      ** If IRS deal and 2nd call to ARR Calculator is needed,                              MD059253
      ** OR deal is being migrated into backward-looking,                                   MD059424
      ** determine next Interest Period End Date                                            MD059253
     C                   IF        (TrMODI = 'RU' or TrMODI = 'RT')                         MD059253
    C**********                   and Wrk2ndCall = 'Y'                            MD059253 MD059424
     C                   IF        WrkMigrate = 'Y'                                         MD059424
     C                             or Wrk2ndCall = 'Y'                                      MD059424
     C                   EXSR      SRIRSNxtEDATE                                            MD059253
     C**********         EVAL      IntPerEDATE = WrkEndDate                        MD059253 MD059270
     C                   EVAL      IntPerEDATE = WrkEndDate - 1                             MD059270
     C                   EVAL      WZeroMDATFlag = 'Y'                                      MD059253
     C                   ENDIF                                                              MD059253
     C                   ENDIF                                                              MD059424

     C                   IF        IntPerEDATE <= 0
     C                   EVAL      WZeroMDATFlag = 'Y'
     C                   EVAL      IntPerEDATE = BJDNWD - 1
     C                   ENDIF
                                                                                            MD059137
     C                   IF        TrMODI = 'LE'                                            MD059137
     C                   IF        WrkMigrate = 'Y'                                         MD059137
     C                             or Wrk2ndCall = 'Y'                                      MD059190
     C                   EXSR      SRDetEndDate                                             MD059190
     C                   EVAL      IntPerEDATE = WrkEndDate                                 MD059190
     C                   EVAL      WZeroMDATFlag = 'Y'                                      MD059137
     C                   ENDIF                                                              MD059137
     C                   ENDIF                                                              MD059137

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
     C**********         EVAL      SumLBLO = TrLBDY + TrLODY                                MD060033
     C                   EVAL      SumLBLO = TrLBDY + TrLODY + 1                            MD060033

     C                   MOVEL     TrCCY         ZCCY              3
     C                   MOVEL     *BLANKS       ZLOC              3
     C**********         Z-ADD     IntPerEDATE   ZDAYNO            5 0                      MD058106
     C                   Z-ADD     IntPayDate    ZDAYNO            5 0                      MD058106
     C                   Z-ADD     SumLBLO       ZNRDYS            2 0
     C                   Z-ADD     *ZEROS        ZDYNBR            5 0
     C                   EXSR      ZBKDT

     C                   EVAL      RTKNDate = ZDYNBR

     C                   Z-ADD     RTKNDate      ZDAYNO
     C                   Z-ADD     RPubLag       ZNRDYS
     C                   Z-ADD     *ZEROS        ZDYNBR
     C                   EXSR      ZFWDT

     C                   EVAL      RTKNDate = ZDYNBR
      *                                                                                     MD060033
      ** Default MidasDay to Midas run date.                                                MD060033
      ** If ARRUseSysOrMidasDate = S, set it to machine date.                               MD060033
      *                                                                                     MD060033
     C                   EVAL      MidasDay = BJRDNB                                        MD060033
     C                   IF        SysOrMidas = 'S'                                         MD060033
      ** Retrieve current system date and time                                              MD060033
     C                   EVAL      SysDate = %date()                                        MD060033
     C                   EVAL      CurrDate = %dec(SysDate:*MDY)                            MD060033
      ** Convert to Midas Day                                                               MD060033
     C                   CALL      'ZDATE1'                                                 MD060033
     C                   PARM                    ReturnCde         7                        MD060033
     C                   PARM                    CurrDate          6 0                      MD060033
     C                   PARM      'M'           DatFmt            1                        MD060033
     C                   PARM      *ZEROS        MidasDay          5 0                      MD060033
     C                   ENDIF                                                              MD060033
      *                                                                                     MD060033
      ** Get current time.                                                                  MD060033
      *                                                                                     MD060033
     C                   EVAL      CurrTime = %char(%time():*HMS)                           MD060033
      *                                                                                     MD060033
      ***Set*the*Rates*Known*flag*if*the*computed*Rates*Known*Date*has**                    MD060033
      ***passed*the*system*date*and*the*reference*rate*publication*time*                    MD060033
     C**********         IF        RTKNDate <= BJRDNB and                                   MD058040
     C**********         IF        RTKNDate <= EventCtrlDate and                   MD058040 MD060033
     C**********                   RTKNDate <> 0                                            MD060033
     C**********         EVAL      RatesKnown = 'Y'                                         MD060033
     C**********         EVAL      CurrTime = %char(%time():*HMS)                           MD060033
     C**********         IF        RTKNDate = BJRDNB and                                    MD060033
     C**********                   PublTime > CurrTime                                      MD060033
     C**********         EVAL      RatesKnown = 'N'                                         MD060033
     C**********         ENDIF                                                              MD060033
     C**********         ENDIF                                                              MD060033
      *                                                                                     MD060033
      ** Set the Rates Known flag if the computed Rates Known Date has                      MD060033
      ** passed MidasDay and the reference rate publication time.                           MD060033
      *                                                                                     MD060033
     C                   EVAL      RatesKnown = 'N'                                         MD060033
     C                   IF        RTKNDate < MidasDay or                                   MD060033
     C                             (RTKNDate = MidasDay and PublTime < CurrTime)            MD060033
     C                   EVAL      RatesKnown = 'Y'                                         MD060033
     C                   ENDIF                                                              MD060033

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
      *****************************************************************                     MD060441
      /EJECT                                                                                MD060441
      *****************************************************************                     MD060441
      *                                                               *                     MD060441
      * srChkIfRework - Subroutine to check if a particular           *                     MD060441
      *                 transaction needs rework due to rollover      *                     MD060441
      *                 event with change of ARR details              *                     MD060441
      *                                                               *                     MD060441
      *****************************************************************                     MD060441
     C     srChkIfRework BEGSR                                                              MD060441
                                                                                            MD060441
     C                   CLEAR                   isARRParamChg                              MD060441
     C                   EVAL                    isRework = *OFF                            MD060441
                                                                                            MD060441
     C                   IF        (CLE172 = 'N') OR (Wrk2ndCall = 'Y')                     MD060441
     C                   LEAVESR                                                            MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   EXSR      srChkARRChange                                           MD060441
                                                                                            MD060441
     C                   IF        isRework = *ON                                           MD060441
     C/exec SQL                                                                             MD060441
     C+ select NCALM, NBADJ, NFLOR, NLBDY,                                                  MD060441
     C+        NLODY, NOPSH, NRRDP, NDBAV, NRFRR                                            MD060441
     C+ into :TrCALM, :TrBADJ, :TrFLOR, :TrLBDY,                                            MD060441
     C+      :TrLODY, :TrOPSH, :TrRRDP, :TrDBAV, :TrRFRR                                    MD060441
     C+ from CLOANCL                                                                        MD060441
     C+ where LNRF = :TrTRAN                                                                MD060441
     C/end-exec                                                                             MD060441
     C                   ENDIF                                                              MD060441
     C                   ENDSR                                                              MD060441
      *****************************************************************                     MD060441
      /EJECT                                                                                MD060441
      *****************************************************************                     MD060441
      *                                                               *                     MD060441
      * srChkARRChange - Subroutine to check if ARR parameters        *                     MD060441
      *                  has changed                                  *                     MD060441
      *                                                               *                     MD060441
      *****************************************************************                     MD060441
     C     srChkARRChangeBEGSR                                                              MD060441
                                                                                            MD060441
      ** Get current ARR details from CLOANCL                                               MD060441
     C/exec SQL                                                                             MD060441
                                                                                            MD060441
     C+ select RFRR, CALM, BADJ, FLOR, LBDY,                                                MD060441
     C+        LODY, OPSH, RRDP, DBAV, BLRT, NBLRT                                          MD060441
     C+ into :befARRDetails                                                                 MD060441
     C+ from CLOANCL                                                                        MD060441
     C+ where LNRF = :TrTRAN                                                                MD060441
                                                                                            MD060441
     C/end-exec                                                                             MD060441
                                                                                            MD060441
     C                   IF        ( SQLCOD <> NO_RECORD ) AND                              MD060441
     C                             ( B_BLRT = 'Y' AND                                       MD060441
     C                               B_NBLRT = 'Y' )                                        MD060441
                                                                                            MD060441
     C                   EVAL      isARRParamChg = *Off                                     MD060441
                                                                                            MD060441
     C                   IF        B_RFRR <> TRRFRR                                         MD060441
     C                   EVAL      isARRParamChg = *On                                      MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   IF        B_CALM <> TRCALM                                         MD060441
     C                   EVAL      isARRParamChg = *On                                      MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   IF        B_BADJ <> TRBADJ                                         MD060441
     C                   EVAL      isARRParamChg = *On                                      MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   IF        B_FLOR <> TRFLOR                                         MD060441
     C                   EVAL      isARRParamChg = *On                                      MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   IF        B_LBDY <> TRLBDY                                         MD060441
     C                   EVAL      isARRParamChg = *On                                      MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   IF        B_LODY <> TRLODY                                         MD060441
     C                   EVAL      isARRParamChg = *On                                      MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   IF        B_OPSH <> TROPSH                                         MD060441
     C                   EVAL      isARRParamChg = *On                                      MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   IF        B_RRDP <> TRRRDP                                         MD060441
     C                   EVAL      isARRParamChg = *On                                      MD060441
     C                   ENDIF                                                              MD060441
     C                   IF        B_DBAV <> TRDBAV                                         MD060441
     C                   EVAL      isARRParamChg = *On                                      MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   IF        ( isARRParamChg )                                        MD060441
     C                   EVAL      isRework = *On                                           MD060441
     C                   ENDIF                                                              MD060441
                                                                                            MD060441
     C                   ENDIF                                                              MD060441
     C                                                                                      MD060441
     C                   ENDSR                                                              MD060441
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
     C                   PARM                    ControlDate                                MD058182
     C                   PARM                    wEvntCtrlDate                              MD058517
     C                   PARM                    isRework                                   MD060441
     C                   PARM      *BLANKS       ReturnCode

      ** End program if there's a connection error
     C                   IF        ReturnCode = 'CONNECTION_ERROR'
     C                   EVAL      DBFILE = 'ZAGETCALRT'
     C                   EVAL      DBKEY = TransREF
     C                   EVAL      DBASE  = 006
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            MD060441
     C                   EVAL      isRework = *OFF                                          MD060441

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
      *****************************************************************                     MD059253
      /EJECT                                                                                MD059253
      *****************************************************************                     MD059253
      *                                                               *                     MD059253
      * SRIRSNxtEDATE - Calculate next Interest Period End Date       *                     MD059253
      *                 based on IRS deal details                     *                     MD059253
      *                                                               *                     MD059253
      *****************************************************************                     MD059253
     C     SRIRSNxtEDATE BEGSR                                                              MD059253
                                                                                            MD059253
     C                   EVAL      PDealRef = TrTRAN                                        MD059253
     C                   IF        TrMODI = 'RU'                                            MD059253
     C                   EVAL      PLeg = 'U'                                               MD059253
     C                   ELSE                                                               MD059253
     C                   EVAL      PLeg = 'T'                                               MD059253
     C                   ENDIF                                                              MD059253
                                                                                            MD059253
     C                   CALL      'IR001113'                                               MD059253
     C                   PARM      'L'           PMode                                      MD059253
     C                   PARM                    PDealRef                                   MD059253
     C                   PARM                    PLeg                                       MD059253
     C                   PARM      *ZEROS        WrkEndDate                                 MD059253
     C                   PARM      *ZEROS        WrkBasDate                                 MD059253
                                                                                            MD059253
     C                   ENDSR                                                              MD059253
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
     C                   MOVE      EventCtrlDate wEvntCtrlDate                              MD058517
                                                                                            MD058040
     C                   IF        BKANWD = '0' or BKANWD = '1'                             MD058182
     C                   EVAL      EventCtrlDate = BJDNWD - 1                               MD058182
     C                   ENDIF                                                              MD058182
     C                                                                                      MD058182
     C                   MOVEL     EventCtrlDate ControlDate                                MD058182
                                                                                            MD058182
      ** Determine if CLE172 is installed                                                     CDL102
     C                   MOVE      'N'           CLE172                                       CDL102
     C                   CALL      'AOSARDR0'                                                 CDL102
     C                   PARM      *BLANK        PRtCd                                        CDL102
     C                   PARM      '*VERIFY'     POptn                                        CDL102
     C                   PARM      'CLE172'      PSard                                        CDL102
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL102
                                                                                              CDL102
     C     PRtCd         IFEQ      *BLANK                                                     CDL102
     C                   MOVE      'Y'           CLE172                                       CDL102
     C                   ENDIF                                                                CDL102
                                                                                              CDL102
      ** Determine if CDL102 is installed                                                     CDL102
     C                   MOVE      'N'           CDL102                                       CDL102
     C                   CALL      'AOSARDR0'                                                 CDL102
     C                   PARM      *BLANK        PRtCd                                        CDL102
     C                   PARM      '*VERIFY'     POptn                                        CDL102
     C                   PARM      'CDL102'      PSard                                        CDL102
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL102
                                                                                              CDL102
     C     PRtCd         IFEQ      *BLANK                                                     CDL102
     C                   MOVE      'Y'           CDL102                                       CDL102
     C                   ENDIF                                                                CDL102
                                                                                              CIR020
      ** Determine if CIR020 is installed                                                     CIR020
     C                   MOVE      'N'           CIR020                                       CIR020
     C                   CALL      'AOSARDR0'                                                 CIR020
     C                   PARM      *BLANK        PRtCd                                        CIR020
     C                   PARM      '*VERIFY'     POptn                                        CIR020
     C                   PARM      'CIR020'      PSard                                        CIR020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR020
                                                                                              CIR020
     C     PRtCd         IFEQ      *BLANK                                                     CIR020
     C                   MOVE      'Y'           CIR020                                       CIR020
     C                   ENDIF                                                                CIR020

      ** Get setting of system value ARR Calculation Frequency
     C                   EVAL      ARRCalcFreq = *BLANKS
     C                   EVAL      PSysVal01 = 'ARRCalculationFreq'
      *                                                                                     MD060033
      ** Get also the value of ARRUseSysOrMidasDate.                                        MD060033
      *                                                                                     MD060033
     C                   EVAL      SysOrMidas = *BLANKS                                     MD060033
     C                   EVAL      PSysVal02 = 'ARRUseSysOrMidasDate'                       MD060033

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM                    PSysVal01
     C                   PARM      *BLANKS       PCurSet01
     C**********         PARM      *BLANKS       PSysVal02                                  MD060033
     C                   PARM                    PSysVal02                                  MD060033
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
     C                   IF        PCurSet01 = '*NRF'                                       MD060033
     C                   EVAL      DBKEY = PSysVal01
     C                   ELSE                                                               MD060033
     C                   EVAL      DBKEY = PSysVal02                                        MD060033
     C                   ENDIF                                                              MD060033
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     PCurSet01     ARRCalcFreq
     C                   MOVEL     PCurSet02     SysOrMidas                                 MD060033
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
     C*****KRFRR         SETLL     SDLIBRTD                                                 MD060008
     C*****KRFRR         READE     SDLIBRTD                                                 MD600008
     C/EXEC SQL                                                                             MD060008
     C+ declare ACursor insensitive scroll cursor for                                       MD060008
     C+ select * from SDLIBJW0                                                              MD060008
     C+ where SCRFLD = 'RFR'                                                                MD060008
     C+ order by INTVAL                                                                     MD060008
     C/END-EXEC                                                                             MD060008
                                                                                            MD060008
     C/EXEC SQL                                                                             MD060008
     C+ open ACursor                                                                        MD060008
     C/END-EXEC                                                                             MD060008
                                                                                            MD060008
     C/EXEC SQL                                                                             MD060008
     C+ fetch next from ACursor into :SDLIBR                                                MD060008
     C/END-EXEC                                                                             MD060008
                                                                                            MD060008
     C***********        DOW       NOT %EOF(SDLIBRTD)                                       MD060008
     C                   DOW       SQLCODE = 0                                              MD060008
     C                   EVAL      ArrRFR(Idx) = INTVAL
     C                   EVAL      ArrPubLag(Idx) = PUBLAG
     C                   EVAL      ArrPubTim(Idx) = PUBTIM
     C                   EVAL      Idx = Idx + 1
     C*****KRFRR         READE     SDLIBRTD                                                 MD600008
     C/EXEC SQL                                                                             MD060008
     C+ fetch next from ACursor into :SDLIBR                                                MD060008
     C/END-EXEC                                                                             MD060008
     C                   ENDDO
      *                                                                                     MD060959
      ** Get PRUN from data area JNSTAT                                                     MD060959
      *                                                                                     MD060959
     C     *DTAARA       DEFINE                  JNSTAT                                     MD060959
     C                   IN        JNSTAT                                                   MD060959

     C/EXEC SQL                                                                             MD060008
     C+ close ACursor                                                                       MD060008
     C/END-EXEC                                                                             MD060008
                                                                                            MD060008
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     MD059190
      *                                                               *                     MD059190
      * SRChk2ndCall - Check if loan needs a 2nd ARR calculator call  *                     MD059190
      *                                                               *                     MD059190
      *****************************************************************                     MD059190
     C     SRChk2ndCall  BEGSR                                                              MD059190
                                                                                            MD059190
     C                   EVAL      Wrk2ndCall = 'N'                                         MD059190
     C/exec SQL                                                                             MD059190
     C+ select count(*) into :NoOfRecs                                                      MD059190
     C+ from CLOANCL                                                                        MD059190
     C+ where LNRF = :TrTRAN                                                                MD059190
     C+   and (NIDT = :BJRDNB or (NRPD = :BJRDNB and REPT <> 2))                            MD059190
     C+   and (RLDT = :BJRDNB or RLDT = 0)                                                  MD059190
     C+   and BLRT = 'Y'                                                                    MD059190
     C+   and NBLRT <> 'N'                                                                  MD059190
     C/end-exec                                                                             MD059190
      **                                                                                    MD060959
     C                   IF        NoOfRecs = 0                                             MD060959
     C/exec SQL                                                                             MD060959
     C+ select count(*) into :NoOfRecs                                                      MD060959
     C+ from CLOANCL                                                                        MD060959
     C+ where LNRF = :TrTRAN                                                                MD060959
     C+   and ((NIDT > :PRUN and NIDT < :BJRDNB)                                            MD060959
     C+   or  (NRPD > :PRUN and NRPD <:BJRDNB and REPT <> 2))                               MD060959
     C+   and (RLDT > :PRUN and RLDT < :BJRDNB or RLDT = 0)                                 MD060959
     C+   and BLRT = 'Y'                                                                    MD060959
     C+   and NBLRT <> 'N'                                                                  MD060959
     C/end-exec                                                                             MD060959
     C                   ENDIF                                                              MD060959
      **                                                                                    MD060959
     C                   IF        NoOfRecs <> 0                                            MD059190
     C/exec SQL                                                                             MD059190
     C+ select NCALM, NBADJ, NFLOR, NLBDY,                                                  MD059190
     C***+        NLODY, NOPSH, NRRDP, NDBAV                                       MD059190 MD060823
     C+           NLODY, NOPSH, NRRDP, NDBAV, NRFRR                                         MD060823
     C+ into :TrCALM, :TrBADJ, :TrFLOR, :TrLBDY,                                            MD059190
     C***+      :TrLODY, :TrOPSH, :TrRRDP, :TrDBAV                                 MD059190 MD060823
     C+      :TrLODY, :TrOPSH, :TrRRDP, :TrDBAV, :TrRFRR                                    MD060823
     C+ from CLOANCL                                                                        MD059190
     C+ where LNRF = :TrTRAN                                                                MD059190
     C+   and NBLRT = 'Y'                                                                   MD059190
     C+   and :TrTRAN not in (select * from LEWIPROLL)                                      MD059190
     C/end-exec                                                                             MD059190
     C                   EVAL      Wrk2ndCall = 'Y'                                         MD059190
     C                   ENDIF                                                              MD059190
     C                   EVAL      NoOfRecs = 0                                             MD059190
     C                   EVAL      SQLCOD = 0                                               MD059190
                                                                                            MD059190
     C                   ENDSR                                                              MD059190
      *****************************************************************                     MD059190
      /EJECT                                                                                MD059190
      *****************************************************************                     MD059190
      *                                                               *                     MD059190
      * SRDetEndDate - Calculate end date based on loan details       *                     MD059190
      *                                                               *                     MD059190
      *****************************************************************                     MD059190
     C     SRDetEndDate  BEGSR                                                              MD059190
                                                                                            MD059190
     C                   CALL      'LE001113'                                               MD059190
     C                   PARM      'L'           PMode                                      MD059190
     C                   PARM                    TrTRAN                                     MD059190
     C                   PARM      *ZEROS        WrkEndDate                                 MD059190
     C                   PARM      *ZEROS        WrkBasDate                                 MD059190
                                                                                            MD059190
     C                   ENDSR                                                              MD059190
      // Start of change MD058517
      /free
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // SrupdRTKN  - Update Rates Known File                       *
       // ==========                                                 *
       //                                                            *
       // Called by: SrUpdFile                                       *
       //                                                            *
       // Calls: checkExist                                          *
       //                                                            *
       //*************************************************************

       begsr SrupdRTKN;

                   exsr checkExist;

                   if action = INSERT;

                      exsr insertRecord;

                   elseif action = UPDATE;

                      exsr updateRecord;

                   endif;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // insertRecord                                               *
       // ============                                               *
       //                                                            *
       // Called by: SRupdRTKN                                       *
       //                                                            *
       // Calls: none                                                *
       //                                                            *
       //*************************************************************

       begsr insertRecord;

                   clear RateKnownDS;
                   RateKnownDS.KMODID = TrModi;
                   RateKnownDS.KTRNID = TrTran;
                   RateKnownDS.KRTKNI = RatesKnown;
                   RateKnownDS.KINTPE = 0;
                   RateKnownDS.KCINTA = 0;
                   RateKnownDS.KPINTA = 0;
                   RateKnownDS.KCORMP = 'N';
                   RateKnownDS.KSPLFP = 'N';
                   exec sql insert into SDRTKNTD
                   values (:RateKnownDS);

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dbFile = 'SDRTKNTD';
                      dbkey = *blanks;
                      dbase = 005;
                      exsr *pssr;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // updateRecord                                               *
       // ============                                               *
       //                                                            *
       // Called by: SRupdRTKN                                       *
       //                                                            *
       // Calls: none                                                *
       //                                                            *
       //*************************************************************

       begsr updateRecord;

                   clear RateKnownDS;
                   RateKnownDS.KMODID = trModi;
                   RateKnownDS.KTRNID = trTran;
                   RateKnownDS.KRTKNI = RatesKnown;
                   if RatesKnown = 'N';
                      RateKnownDS.KINTPE = 0;
                      RateKnownDS.KCINTA = 0;
                      RateKnownDS.KPINTA = 0;
                      RateKnownDS.KCORMP = 'N';
                      RateKnownDS.KSPLFP = 'N';
                      wSqlStr = 'update SDRTKNTD A SET '  +
                              'A.KRTKNI = ' + QUO + %trim(RateKnownDS.KRTKNI) +
                               QUO + ' , ' +
                              'A.KINTPE = ' + %char(RateKnownDS.KINTPE) +
                               ' , ' +
                              'A.KCINTA = ' + %char(RateKnownDS.KCINTA) +
                               ' , ' +
                              'A.KPINTA = ' + %char(RateKnownDS.KPINTA) +
                               ' , ' +
                              'A.KCORMP = ' + QUO + RateKnownDS.KCORMP  + QUO +
                              ' , ' +
                              'A.KSPLFP = ' + QUO + RateKnownDS.KSPLFP  + QUO +
                              ' where KMODID = '  + QUO + TrMODI   + QUO +
                              '  and KTRNID = ' + QUO + TrTRAN      + QUO;
                   else;
                      wSqlStr = 'update SDRTKNTD A SET '  +
                              'A.KRTKNI = ' + QUO + %trim(RateKnownDS.KRTKNI) +
                               QUO +
                               ' where KMODID = '  + QUO + TrMODI   + QUO +
                               '  and KTRNID = ' + QUO + TrTRAN      + QUO;
                   endif;

                   exec sql
                   execute immediate :wSqlStr;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dbFile = 'SDRTKNTD';
                      dbkey = *blanks;
                      dbase = 006;
                      exsr *pssr;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // checkExist - Check if a record exist on a given file       *
       // ==========                                                 *
       //                                                            *
       // Called by: Output File                                     *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr checkExist;

                   wSQLStr = 'select * from SDRTKNTD ' +
                             'where KMODID = '  + QUO + TrMODI   + QUO +
                             ' and KTRNID = ' + QUO + TrTRAN      + QUO;

                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;

                   exec sql fetch next From P1 into :RateKnownDS;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      dbFile = 'SDRTKNTD';
                      dbkey = *blanks;
                      dbase = 004;
                      exsr *pssr;
                   endif;

                   if sqlCod = NO_RECORD;
                      action = INSERT;
                   else;
                      action = UPDATE;
                   endif;

                   exec sql close P1;

       endsr;
      /end-free
      // End of change MD058517

      *****************************************************************                     MD059190
      /EJECT                                                                                MD059190
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
