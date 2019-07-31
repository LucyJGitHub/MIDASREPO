     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast Total for Nostro Code - COB')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000802 - Midas OF Forecast Total for Nostro Code Balance   *
      *             Rebuild - COB                                     *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD031636           Date 11Dec14               *
      *                 MD027171           Date 28May14               *
      *                 CGL153   *CREATE   Date 05Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD031636 - Forecast Balance show backdated amounts even if   *
      *             system value 'ForecastIncUnmatched' is set to 'N' *
      *  MD027171 - Forecast Balance should show backdated amounts    *
      *  CGL153 - Estimated Exchange Rate                             *
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
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     **   Midas OF Individual Forecast Table
     D FORIT         E DS                  EXTNAME(GLFORITD)

      ** External DS for Forecast Totals for Nostro Codes
     D TNOST         E DS                  EXTNAME(GLTNOSTD)

     D                 DS
     D  WDATEA0                1      5  0
     D  WDATEA1                6     10  0
     D  WDATEA2               11     15  0
     D  WDATEA3               16     20  0
     D  WDATEA4               21     25  0
     D  WDATEA5               26     30  0
     D  WDATEA6               31     35  0
     D  WDATEA7               36     40  0
     D  WDATEA8               41     45  0
     D  WDATEA9               46     50  0
     D  WDATEA                 1     50  0
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

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRTCD           S              7A

      ** Other fields used
     D WRun            S              1A   Inz
     D wBJRDNB         S              5S 0
     D WDATE           S              5S 0
     D WCTR            S              2S 0
     D WCTR2           S              2S 0
     D WFIRST          S              1A
     D WCCY            S              3A
     D WNOSC           S              2A
     D WTNOST          S              1A
     D WACOD           S             10S 0
     D wA7CYCD         S              3A
     D wA7NONB         S              2A
     D wA7CUST         S              6A
     D wA7BRCD         S              3A
     D wA7ACCD         S             10A
     D wA7ACSN         S              2S 0
                                                                                            MD031636
      ** Processing mode                                                                    MD031636
     D ProcMode        S            190                                                     MD031636
                                                                                            MD031636
      ** Forecast Include Unmatched in Projected Balance                                    MD031636
     D WFIUPB          S              1A                                                    MD031636
                                                                                            MD031636
      ** Parameter variables for AOSVALR0 string                                            MD031636
     DRTNCDE           S              7                                                     MD031636
     DSVAL1            S            200                                                     MD031636
     DSVALK2           S             20                                                     MD031636
     DSVAL2            S            200                                                     MD031636
     DSVALK3           S             20                                                     MD031636
     DSVAL3            S            200                                                     MD031636
     DSVALK4           S             20                                                     MD031636
     DSVAL4            S            200                                                     MD031636
     DSVALK5           S             20                                                     MD031636
     DSVAL5            S            200                                                     MD031636
     DSVALK6           S             20                                                     MD031636
     DSVAL6            S            200                                                     MD031636
     DSVALK7           S             20                                                     MD031636
     DSVAL7            S            200                                                     MD031636
     DSVALK8           S             20                                                     MD031636
     DSVAL8            S            200                                                     MD031636
     DSVALK9           S             20                                                     MD031636
     DSVAL9            S            200                                                     MD031636
     DSVALK0           S             20                                                     MD031636
     DSVAL10           S            200                                                     MD031636
                                                                                            MD031636
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

      ** Main Subroutine

     C                   EXSR      SRMain

      ** End Program

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *                                                               *
      *  SRMain - Main Subroutine                                     *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR

      ** Set file pointer to first record of Individual Forecast Table
      ** and do an initial read

     C/exec SQL
     C+ declare LIST1 cursor for
     C+ select * from GLFORITD
     C+ where IFRECI = 'D' and
     C+       IFACTL = 0 and
     C+       IFACZR = 'N' and
     C+       IFPRON = 'Y' and
     C+       IFNOSC <> ' '
     C+ order by
     C+       IFCCY, IFNOSC, IFDATE ASC
     C/end-exec

     C/exec SQL
     C+ open LIST1
     C/end-exec

      ** Handle SQL Error (if not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from LIST1
     C+ into: FORIT
     C/end-exec

      ** Read Individual Forecast Table until end of file

     C                   MOVE      0             COUNT             1 0
     C                   EVAL      WFIRST = 'N'

     C                   DOW       SQLCode <> 100
     C                   IF        WFIUPB = 'N' And IFDATE < wBJRDNB                        MD031636
     C                   GOTO      ReadNext                                                 MD031636
     C                   ENDIF                                                              MD031636
                                                                                            MD031636
     C                   IF        WCCY   <> IFCCY OR
     C                             WNOSC  <>  IFNOSC

     C                   IF        WFIRST = 'N'
     C                   EVAL      WFIRST = 'Y'
     C                   ELSE
     C                   EXSR      SRUpdateTNOS
     C                   ENDIF

     C                   EVAL      WCCY   = IFCCY
     C                   EVAL      WNOSC  = IFNOSC

     C                   EXSR      SRGetNostroDtl

     C                   ENDIF

      ** Accumulate the forecast amount
     C                   EXSR      SRAccumFore

     C     ReadNext      TAG

     C/exec SQL
     C+ fetch next from LIST1
     C+ into :FORIT
     C/end-exec

     C                   ENDDO

     C                   IF        WFIRST = 'Y'
     C                   EXSR      SRUpdateTNOS
     C                   ENDIF

     C/exec SQL
     C+ close LIST1
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdateTNOS - Insert/Update record in GLTNOSTD              *
      *                                                               *
      *****************************************************************
     C     SRUpdateTNOS  BEGSR

     C                   IF        WTNOST = 'Y'

      ** Update Forecast Available Amount

     C/exec SQL
     C+ update GLTNOSTD set NCDAT0 = :WDATEA0
     C+ , NCDAT1 = :WDATEA1
     C+ , NCDAT2 = :WDATEA2
     C+ , NCDAT3 = :WDATEA3
     C+ , NCDAT4 = :WDATEA4
     C+ , NCDAT5 = :WDATEA5
     C+ , NCDAT6 = :WDATEA6
     C+ , NCDAT7 = :WDATEA7
     C+ , NCDAT8 = :WDATEA8
     C+ , NCDAT9 = :WDATEA9
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
     C+ where NCBRCA = :wA7BRCD and
     C+ NCCNUM = :wA7CUST and
     C+ NCCYCD = :wA7CYCD and
     C+ NCACOD = :WACOD  and
     C+ NCACSQ = :wA7ACSN
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
     C+   :wA7CYCD
     C+ , :WNOSC
     C+ , :wA7BRCD
     C+ , :wA7CUST
     C+ , :WACOD
     C+ , :wA7ACSN
     C+ , :WDATEA0
     C+ , :WDATEA1
     C+ , :WDATEA2
     C+ , :WDATEA3
     C+ , :WDATEA4
     C+ , :WDATEA5
     C+ , :WDATEA6
     C+ , :WDATEA7
     C+ , :WDATEA8
     C+ , :WDATEA9
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

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetNostroDtl - Get Nostro Details                          *
      *                                                               *
      *****************************************************************
     C     SRGetNostroDtlBEGSR

     C/exec sql
     C+ select A7BRCD, A7CUST, A7CYCD, A7ACSN, A7ACCD
     C+ into: wA7BRCD, :wA7CUST, :wA7CYCD, :wA7ACSN, :wA7ACCD
     C+ from SDNOSTPD
     C+ where A7CYCD = :WCCY and
     C+ A7NONB = :WNOSC
     C/end-exec
     C                   IF        SQLCOD = 0
     C                   MOVE      wA7ACCD       WACOD
     C                   EXSR      SRCheckTNOST
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WCCY + WNOSC
     C                   EVAL      DBFile = 'SDNOSTPD'
     C                   EVAL      DBase = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCheckTNOST - Check in GLTNOSTD                             *
      *                                                               *
      *****************************************************************
     C     SRCheckTNOST  BEGSR
     C/exec SQL
     C+ select * into :TNOST from GLTNOSTD
     C+ where NCBRCA = :wA7BRCD and
     C+ NCCNUM = :wA7CUST and
     C+ NCCYCD = :wA7CYCD and
     C+ NCACOD = :WACOD  and
     C+ NCACSQ = :wA7ACSN
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

      ** If record found in GLTNOSTD, then update

     C                   IF        SQLCOD = 0
     C                   EXSR      SRLoadNostAmt
     C                   ENDIF

      ** If record not found in GLTNOSTD, then write

     C                   IF        SQLCOD = 100
     C                   EXSR      SRInitArr
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitArr - Initialize array                                 *
      *                                                               *
      *****************************************************************
     C     SRInitArr     BEGSR

     C                   EVAL      WDATEA = 0
     C                   EVAL      WDATE  = wBJRDNB

     C                   EVAL      WAMTA  = 0

     C                   EVAL      WTNOST = 'N'

     C                   EVAL      WCTR   = 1

     C                   DOW       WCTR <= 10

     C                   EVAL      WDATEA(WCTR) = WDATE

     C                   EVAL      WDATE +=1
     C                   EVAL      WCTR  += 1

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoaNostAmt - Move the nostro total amounts in array        *
      *                                                               *
      *****************************************************************
     C     SRLoadNostAmt BEGSR

     C                   EVAL      WTNOST = 'Y'
     C                   EVAL      WCTR = 1
     C                   EVAL      WDATEA = 0
     C                   EVAL      WAMTA = 0

     C                   DOW       WCTR <= 10

     C                   SELECT

     C                   WHEN      WCTR = 1
     C                   EVAL      WDATEA(WCTR) = NCDAT0
     C                   EVAL      WAMTA(WCTR) = NCAMT0

     C                   WHEN      WCTR = 2
     C                   EVAL      WDATEA(WCTR) = NCDAT1
     C                   EVAL      WAMTA(WCTR) = NCAMT1

     C                   WHEN      WCTR = 3
     C                   EVAL      WDATEA(WCTR) = NCDAT2
     C                   EVAL      WAMTA(WCTR) = NCAMT2

     C                   WHEN      WCTR = 4
     C                   EVAL      WDATEA(WCTR) = NCDAT3
     C                   EVAL      WAMTA(WCTR) = NCAMT3

     C                   WHEN      WCTR = 5
     C                   EVAL      WDATEA(WCTR) = NCDAT4
     C                   EVAL      WAMTA(WCTR) = NCAMT4

     C                   WHEN      WCTR = 6
     C                   EVAL      WDATEA(WCTR) = NCDAT5
     C                   EVAL      WAMTA(WCTR) = NCAMT5

     C                   WHEN      WCTR = 7
     C                   EVAL      WDATEA(WCTR) = NCDAT6
     C                   EVAL      WAMTA(WCTR) = NCAMT6

     C                   WHEN      WCTR = 8
     C                   EVAL      WDATEA(WCTR) = NCDAT7
     C                   EVAL      WAMTA(WCTR) = NCAMT7

     C                   WHEN      WCTR = 9
     C                   EVAL      WDATEA(WCTR) = NCDAT8
     C                   EVAL      WAMTA(WCTR) = NCAMT8

     C                   WHEN      WCTR = 10
     C                   EVAL      WDATEA(WCTR) = NCDAT9
     C                   EVAL      WAMTA(WCTR) = NCAMT9

     C                   ENDSL

     C                   EVAL      WCTR += 1

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccumFore - Accumulate Forecast amount                     *
      *                                                               *
      *****************************************************************
     C     SRAccumFore   BEGSR

      ***Update*balances*for*forecast*dates*greater*than*or*equal*to***                     MD027171
      ** Update balances for forecast dates less than or equal to                           MD027171
      ** run date

     C**********         IF        IFDATE >= wBJRDNB                                        MD027171
     C                   IF        IFDATE <= wBJRDNB                                        MD027171

     C                   EVAL      WCTR2 = 1
     C**********         EVAL      WCTR2 = %LOOKUP(IFDATE:WDATEA:WCTR2)                     MD027171

     C**********         IF        WCTR2 > 0                                                MD027171

     C                   DOW       WCTR2 <= 10

     C                   EVAL      WAMTA(WCTR2) += IFAMNT
     C                   EVAL      WCTR2 += 1

     C                   ENDDO

     C**********         ENDIF                                                              MD027171

     C                   ELSE

      ** Place to first array or rundate for forward forecast date
     C                   EVAL      WCTR2 = 1
     C**********         EVAL      WCTR2 = %LOOKUP(wBJRDNB:WDATEA:WCTR2)                    MD027171
     C                   EVAL      WCTR2 = %LOOKUP(IFDATE:WDATEA:WCTR2)                     MD027171

     C                   IF        WCTR2 > 0
     C                   DOW       WCTR2 <= 10                                              MD027171
     C                   EVAL      WAMTA(WCTR2) += IFAMNT
     C                   EVAL      WCTR2 += 1                                               MD027171
     C                   ENDDO                                                              MD027171
     C                   ENDIF

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

      ** Set off program indicators

     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      ** Access Bank details
      **   Retrieve Run day number

     C/exec sql
     C+ select BJRDNB into :wBJRDNB
     C+ from SDBANKPD
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      * Retrieve the system value                                                           MD031636
                                                                                            MD031636
     C                   EVAL      ProcMode = 'ForecastIncUnmatched'                        MD031636
     C                   CALL      'AOSVALR0'                                               MD031636
     C                   PARM                    RTNCDE                                     MD031636
     C                   PARM                    ProcMode                                   MD031636
     C                   PARM                    SVAL1                                      MD031636
     C                   PARM                    SVALK2                                     MD031636
     C                   PARM                    SVAL2                                      MD031636
     C                   PARM                    SVALK3                                     MD031636
     C                   PARM                    SVAL3                                      MD031636
     C                   PARM                    SVALK4                                     MD031636
     C                   PARM                    SVAL4                                      MD031636
     C                   PARM                    SVALK5                                     MD031636
     C                   PARM                    SVAL5                                      MD031636
     C                   PARM                    SVALK6                                     MD031636
     C                   PARM                    SVAL6                                      MD031636
     C                   PARM                    SVALK7                                     MD031636
     C                   PARM                    SVAL7                                      MD031636
     C                   PARM                    SVALK8                                     MD031636
     C                   PARM                    SVAL8                                      MD031636
     C                   PARM                    SVALK9                                     MD031636
     C                   PARM                    SVAL9                                      MD031636
     C                   PARM                    SVALK0                                     MD031636
     C                   PARM                    SVAL10                                     MD031636
                                                                                            MD031636
      * If the system value is not found then issue a database error                        MD031636
                                                                                            MD031636
     C     RTNCDE        IFNE      '       '                                                MD031636
     C     *LOCK         IN        LDA                                                      MD031636
     C                   EVAL      DBKey = '*FIRST'                                         MD031636
     C                   EVAL      DBFile = 'SDSVALPD'                                      MD031636
     C                   EVAL      DBase = 5                                                MD031636
     C                   OUT       LDA                                                      MD031636
     C                   EXSR      *PSSR                                                    MD031636
     C                   ENDIF                                                              MD031636
                                                                                            MD031636
      * Get the Forecast Include Unmatched in Projected Balance                             MD031636
                                                                                            MD031636
     C                   EVAL      WFIUPB = SVAL1                                           MD031636
                                                                                            MD031636
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

