     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast Totals by Nostro Code')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000801 - Midas OF Forecast Totals by Nostro Code           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD032099           Date 27Jan15               *
      *  Prev Amend No. MD031997           Date 22Jan15               *
      *                 CGL153   *CREATE   Date 05Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD032099 - Auto-authorise forecasts with negative amount     *
      *             not included in Forecast Balance Calculation.     *
      *  MD031997 - Amended Forecast not correctly reflected in the   *
      *             BPR Forecast screen. 'ForecastIncUnmatched'       *
      *             system value when set to 'N' should not include   *
      *             backdated forecasts for recalculation.            *
      *  CGL153 - Bank Position Report                                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Forecast Totals for Nostro Codes
     D TNOST         E DS                  EXTNAME(GLTNOSTD)
 
      ** Local Data Area for database error details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
     D                 DS
     D  WDATE0                 1      5  0
     D  WDATE1                 6     10  0
     D  WDATE2                11     15  0
     D  WDATE3                16     20  0
     D  WDATE4                21     25  0
     D  WDATE5                26     30  0
     D  WDATE6                31     35  0
     D  WDATE7                36     40  0
     D  WDATE8                41     45  0
     D  WDATE9                46     50  0
     D  WDATE                  1     50  0
     D                                     DIM(10)
 
     D                 DS
     D  WAMTA0                 1     15  0
     D  WAMTA1                16     30  0
     D  WAMTA2                31     45  0
     D  WAMTA3                46     60  0
     D  WAMTA4                61     75  0
     D  WAMTA5                76     90  0
     D  WAMTA6                91    105  0
     D  WAMTA7               106    120  0
     D  WAMTA8               121    135  0
     D  WAMTA9               136    150  0
     D  WAMTA                  1    150  0
     D                                     DIM(10)
     D
     D Param           DS
     D  PActCode               1      1
     D  PStatus                2     11
     D  PBranch               12     14
     D  PCust                 15     20
     D  PCurr                 21     23
     D  PACOD                 24     33
     D  PACSQ                 34     35
     D  PFCurr                36     38
     D  PFDate                39     43
     D  PFAmt                 44     58
     D  PAAmt                 59     73
     D  PAAZero               74     74
     D  PAProjRet             75     75
     D  POFAmt                76     90
     D  POAAmt                91    105
     D  POAZero              106    106
     D  POProjRet            107    107
     D  PNosCode             108    109
     D  PAProjNos            110    110
     D  POProjNos            111    111
     D**Filler**             112    500                                              CGL153 MD032099
     D  PAutoAuth            112    112                                                     MD032099
     D  Filler               113    500                                                     MD032099
                                                                                            MD031997
      ** Processing mode                                                                    MD031997
     D ProcMode        S            190                                                     MD031997
                                                                                            MD031997
      ** Forecast Include Unmatched in Projected Balance                                    MD031997
     D WFIUPB          S              1A                                                    MD031997
                                                                                            MD031997
      ** Parameter variables for AOSVALR0 string                                            MD031997
     DRTNCDE           S              7                                                     MD031997
     DSVAL1            S            200                                                     MD031997
     DSVALK2           S             20                                                     MD031997
     DSVAL2            S            200                                                     MD031997
     DSVALK3           S             20                                                     MD031997
     DSVAL3            S            200                                                     MD031997
     DSVALK4           S             20                                                     MD031997
     DSVAL4            S            200                                                     MD031997
     DSVALK5           S             20                                                     MD031997
     DSVAL5            S            200                                                     MD031997
     DSVALK6           S             20                                                     MD031997
     DSVAL6            S            200                                                     MD031997
     DSVALK7           S             20                                                     MD031997
     DSVAL7            S            200                                                     MD031997
     DSVALK8           S             20                                                     MD031997
     DSVAL8            S            200                                                     MD031997
     DSVALK9           S             20                                                     MD031997
     DSVAL9            S            200                                                     MD031997
     DSVALK0           S             20                                                     MD031997
     DSVAL10           S            200                                                     MD031997
                                                                                            MD031997
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7
 
      ** Other fields used
     D X               S              2  0
     D WRun            S              1A   Inz
     D wBJRDNB         S              5S 0
     D WFAmt           S             15  0
     D WAAmt           S             15  0
     D WFDate          S              5  0
     D WOFAmt          S             15  0
     D WOAAmt          S             15  0
     D WCTR            S              2S 0
     D WTNOST          S              1A
     D WACOD           S             10S 0
     D wA7CYCD         S              3A
     D wA7NONB         S              2A
     D wA7CUST         S              6A
     D wA7BRCD         S              3A
     D wA7ACCD         S             10A
     D wA7ACSN         S              2S 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Access record Forecast Total by Nostro Code
 
     C/exec SQL
     C+ select * into :TNOST from GLTNOSTD
     C+ where NCCYCD = :PFCurr and
     C+ NCNONB = :PNosCode
     C/end-exec
 
 
     C                   IF        SQLCOD = 0
     C                   EXSR      SRLoadFore
     C                   ELSE
     C                   EXSR      SRPopulate
     C                   ENDIF
 
      ** Compute for Forecast Total
 
     C                   EXSR      SRForeBal
 
      ** Update or write to file
 
     C                   EXSR      SRUpdateTNOS
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPopulate - Populate Nostro details and forecast dates      *
      *                                                               *
      *****************************************************************
     C     SRPopulate    BEGSR
 
     C                   EVAL      WTNOST = 'N'
 
      ** Retrieve details for Nostro Code
 
     C/exec sql
     C+ select A7BRCD, A7CUST, A7CYCD, A7ACSN, A7ACCD, A7NONB
     C+ into: wA7BRCD, :wA7CUST, :wA7CYCD, :wA7ACSN, :wA7ACCD, :wA7NONB
     C+ from SDNOSTPD
     C+ where A7CYCD = :PFCurr and
     C+ A7NONB = :PNosCode
     C/end-exec
 
     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PFCurr + PNosCode
     C                   EVAL      DBFile = 'SDNOSTPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      NCCYCD = wA7CYCD
     C                   EVAL      NCNONB = wA7NONB
     C                   EVAL      NCBRCA = wA7BRCD
     C                   EVAL      NCCNUM = wA7CUST
     C                   EVAL      NCACOD = wA7ACCD
     C                   MOVE      wA7ACSN       NCACSQ
     C                   MOVE      wA7ACCD       WACOD
     C                   ENDIF
 
      ** Set Forecast Dates
 
     C                   EVAL      WDATE(1) = wBJRDNB
     C                   EVAL      X = 2
     C                   DOW       X <= 10
     C                   EVAL      WDATE(X) = WDATE(X-1) + 1
     C                   EVAL      X = X + 1
     C                   ENDDO
 
      ** Set Forecast Amounts
 
     C                   EVAL      WAMTA = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadFore - Load Forecast dates and totals                  *
      *                                                               *
      *****************************************************************
     C     SRLoadFore    BEGSR
     C                   EVAL      WTNOST = 'Y'
     C                   EVAL      WCTR = 1
     C                   EVAL      WAMTA = 0
     C                   EVAL      WDATE = 0
 
     C                   DOW       WCTR <= 10
 
     C                   SELECT
 
     C                   WHEN      WCTR = 1
     C                   EVAL      WDATE(WCTR) = NCDAT0
     C                   EVAL      WAMTA(WCTR) = NCAMT0
 
     C                   WHEN      WCTR = 2
     C                   EVAL      WDATE(WCTR) = NCDAT1
     C                   EVAL      WAMTA(WCTR) = NCAMT1
 
     C                   WHEN      WCTR = 3
     C                   EVAL      WDATE(WCTR) = NCDAT2
     C                   EVAL      WAMTA(WCTR) = NCAMT2
 
     C                   WHEN      WCTR = 4
     C                   EVAL      WDATE(WCTR) = NCDAT3
     C                   EVAL      WAMTA(WCTR) = NCAMT3
 
     C                   WHEN      WCTR = 5
     C                   EVAL      WDATE(WCTR) = NCDAT4
     C                   EVAL      WAMTA(WCTR) = NCAMT4
 
     C                   WHEN      WCTR = 6
     C                   EVAL      WDATE(WCTR) = NCDAT5
     C                   EVAL      WAMTA(WCTR) = NCAMT5
 
     C                   WHEN      WCTR = 7
     C                   EVAL      WDATE(WCTR) = NCDAT6
     C                   EVAL      WAMTA(WCTR) = NCAMT6
 
     C                   WHEN      WCTR = 8
     C                   EVAL      WDATE(WCTR) = NCDAT7
     C                   EVAL      WAMTA(WCTR) = NCAMT7
 
     C                   WHEN      WCTR = 9
     C                   EVAL      WDATE(WCTR) = NCDAT8
     C                   EVAL      WAMTA(WCTR) = NCAMT8
 
     C                   WHEN      WCTR = 10
     C                   EVAL      WDATE(WCTR) = NCDAT9
     C                   EVAL      WAMTA(WCTR) = NCAMT9
 
     C                   ENDSL
 
     C                   EVAL      WCTR += 1
 
     C                   ENDDO
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRForeBal - Calculate the Forecast Total Balance             *
      *                                                               *
      *****************************************************************
     C     SRForeBal     BEGSR
 
      ** Update balances for forecast dates greater than or equal to
      ** the individual forecast date.
 
     C                   EVAL      X = 1
 
     C                   DOW       X <= 10
 
     C                   IF        PAProjNos = 'Y'
     C                             AND WDATE(X) >= WFDate
     C                             OR  PAProjNos = 'N'
     C                             AND POProjNos = 'Y'
     C                             AND WDATE(X) >= WFDate
 
     C                   SELECT
 
      ** On Insert: add up the forecast amount.
 
     C                   WHEN      PActCode = 'I'
     C                   IF        WAAmt = *Zero AND
     C                             PAAZero <> 'Y'
     C                   EVAL      WAMTA(X)  = WAMTA(X)  + WFAmt
     C                   ENDIF
 
      ** On Amend:
      ** If forecast amount was changed, subtract the original forecast
      **    amount, then add the new forcast amount.
      ** If actual amount was changed or project in nostro flag was changed
      **    from 'Y' to 'N', reduce the original forecast amount.
      ** If project in nostro flag was changed from 'N' to 'Y', add
      **    forecast amount.
 
     C                   WHEN      PActCode = 'A'
     C                   IF        WFIUPB = 'N' And WFDate < wBJRDNB                        MD031997
     C                   GOTO      NoUpdate                                                 MD031997
     C                   ENDIF                                                              MD031997
     C                   IF        WAAmt = *ZERO and WOAAmt = *ZERO
     C                             AND PAProjNos = 'Y'
     C                             AND PAAZero <> 'Y'
     C                   EVAL      WAMTA(X)  = WAMTA(X)  + WFAmt
     C                   ENDIF
     C                   IF        WOAAmt = *ZERO AND POProjNos = 'Y'
     C                   EVAL      WAMTA(X)  = WAMTA(X) - WOFAmt
     C                   ENDIF
     C     NoUpdate      TAG                                                                MD031997
 
      ** On delete: reduce the forecast amount
 
     C                   WHEN      PActCode = 'D'
     C                   IF        WFIUPB = 'N' And WFDate < wBJRDNB                        MD031997
     C                   GOTO      NoDelete                                                 MD031997
     C                   ENDIF                                                              MD031997
     C                   IF        WAAmt = *Zero
     C                   EVAL      WAMTA(X)  = WAMTA(X)  - WFAmt
     C                   ENDIF
     C     NoDelete      TAG                                                                MD031997
 
     C                   ENDSL
     C                   ENDIF
 
     C                   ADD       1             X
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdateTNOS - Insert/Update record in GLTNOSTD              *
      *                                                               *
      *****************************************************************
     C     SRUpdateTNOS  BEGSR
 
     C                   IF        WFIUPB = 'N' And WFDate < wBJRDNB                        MD031997
     C                   GOTO      NoAction                                                 MD031997
     C                   ENDIF                                                              MD031997
     C                   IF        WTNOST = 'Y'
 
      ** Update Forecast Available Amount
 
     C/exec SQL
     C+ update GLTNOSTD set NCDAT0 = :WDATE0
     C+ , NCDAT1 = :WDATE1
     C+ , NCDAT2 = :WDATE2
     C+ , NCDAT3 = :WDATE3
     C+ , NCDAT4 = :WDATE4
     C+ , NCDAT5 = :WDATE5
     C+ , NCDAT6 = :WDATE6
     C+ , NCDAT7 = :WDATE7
     C+ , NCDAT8 = :WDATE8
     C+ , NCDAT9 = :WDATE9
     C+ , NCAMT0 = :WAMTA0
     C+ , NCAMT1 = :WAMTA1
     C+ , NCAMT2 = :WAMTA2
     C+ , NCAMT3 = :WAMTA3
     C+ , NCAMT4 = :WAMTA4
     C+ , NCAMT5 = :WAMTA5
     C+ , NCAMT6 = :WAMTA6
     C+ , NCAMT7 = :WAMTA7
     C+ , NCAMT8 = :WAMTA8
     C+ , NCAMT9 = :WAMTA9
     C+ where NCCYCD = :PFCurr and
     C+ NCNONB = :PNosCode
     C/end-exec
 
     C                   ELSE
 
      ** Write Forecast Totals for Nostro Codes
 
     C/exec SQL
     C+ insert into GLTNOSTD
     C+ (
     C+   NCCYCD
     C+ , NCNONB
     C+ , NCBRCA
     C+ , NCCNUM
     C+ , NCACOD
     C+ , NCACSQ
     C+ , NCDAT0
     C+ , NCDAT1
     C+ , NCDAT2
     C+ , NCDAT3
     C+ , NCDAT4
     C+ , NCDAT5
     C+ , NCDAT6
     C+ , NCDAT7
     C+ , NCDAT8
     C+ , NCDAT9
     C+ , NCAMT0
     C+ , NCAMT1
     C+ , NCAMT2
     C+ , NCAMT3
     C+ , NCAMT4
     C+ , NCAMT5
     C+ , NCAMT6
     C+ , NCAMT7
     C+ , NCAMT8
     C+ , NCAMT9
     C+ )
     C+ Values
     C+ (
     C+   :PFCurr
     C+ , :PNosCode
     C+ , :wA7BRCD
     C+ , :wA7CUST
     C+ , :WACOD
     C+ , :wA7ACSN
     C+ , :WDATE0
     C+ , :WDATE1
     C+ , :WDATE2
     C+ , :WDATE3
     C+ , :WDATE4
     C+ , :WDATE5
     C+ , :WDATE6
     C+ , :WDATE7
     C+ , :WDATE8
     C+ , :WDATE9
     C+ , :WAMTA0
     C+ , :WAMTA1
     C+ , :WAMTA2
     C+ , :WAMTA3
     C+ , :WAMTA4
     C+ , :WAMTA5
     C+ , :WAMTA6
     C+ , :WAMTA7
     C+ , :WAMTA8
     C+ , :WAMTA9
     C+ )
     C/end-exec
 
     C     NoAction      TAG                                                                MD031997
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Input Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    Param
 
      ** Set off program indicators
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Access Bank details
 
     C/exec sql
     C+ select BJRDNB into :wBJRDNB
     C+ from SDBANKPD
     C/end-exec
 
     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialize date and amount fields if non-blanks
 
     C                   IF        PFAmt <> *Blanks
     C                   EVAL      WFAmt   = %DEC(%TRIM(PFAmt):15:0)
     C                   ENDIF
     C                   IF        PAAmt <> *Blanks
     C                   EVAL      WAAmt   = %DEC(%TRIM(PAAmt):15:0)
     C                   ENDIF
     C                   IF        POFAmt <> *Blanks
     C                   EVAL      WOFAmt  = %DEC(%TRIM(POFAmt):15:0)
     C                   ENDIF
     C                   IF        POAAmt <> *Blanks
     C                   EVAL      WOAAmt  = %DEC(%TRIM(POAAmt):15:0)
     C                   ENDIF
     C                   IF        PFDate <> *Blanks
     C                   EVAL      WFDate  = %DEC(%TRIM(PFDate):5:0)
     C                   ENDIF
                                                                                            MD031997
      * Retrieve the system value                                                           MD031997
                                                                                            MD031997
     C                   EVAL      ProcMode = 'ForecastIncUnmatched'                        MD031997
     C                   CALL      'AOSVALR0'                                               MD031997
     C                   PARM                    RTNCDE                                     MD031997
     C                   PARM                    ProcMode                                   MD031997
     C                   PARM                    SVAL1                                      MD031997
     C                   PARM                    SVALK2                                     MD031997
     C                   PARM                    SVAL2                                      MD031997
     C                   PARM                    SVALK3                                     MD031997
     C                   PARM                    SVAL3                                      MD031997
     C                   PARM                    SVALK4                                     MD031997
     C                   PARM                    SVAL4                                      MD031997
     C                   PARM                    SVALK5                                     MD031997
     C                   PARM                    SVAL5                                      MD031997
     C                   PARM                    SVALK6                                     MD031997
     C                   PARM                    SVAL6                                      MD031997
     C                   PARM                    SVALK7                                     MD031997
     C                   PARM                    SVAL7                                      MD031997
     C                   PARM                    SVALK8                                     MD031997
     C                   PARM                    SVAL8                                      MD031997
     C                   PARM                    SVALK9                                     MD031997
     C                   PARM                    SVAL9                                      MD031997
     C                   PARM                    SVALK0                                     MD031997
     C                   PARM                    SVAL10                                     MD031997
                                                                                            MD031997
      * If the system value is not found then issue a database error                        MD031997
                                                                                            MD031997
     C     RTNCDE        IFNE      '       '                                                MD031997
     C     *LOCK         IN        LDA                                                      MD031997
     C                   EVAL      DBKey = '*FIRST'                                         MD031997
     C                   EVAL      DBFile = 'SDSVALPD'                                      MD031997
     C                   EVAL      DBase = 5                                                MD031997
     C                   OUT       LDA                                                      MD031997
     C                   EXSR      *PSSR                                                    MD031997
     C                   ENDIF                                                              MD031997
                                                                                            MD031997
      * Get the Forecast Include Unmatched in Projected Balance                             MD031997
                                                                                            MD031997
     C                   EVAL      WFIUPB = SVAL1                                           MD031997
                                                                                            MD031997
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
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      PRTCD = '*ERROR'
 
     C                   RETURN
 
     C                   ENDSR
