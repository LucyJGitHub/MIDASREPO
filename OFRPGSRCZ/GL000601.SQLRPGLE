     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast Total Avail Bal Calculation-I/C')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000601 - Midas OF Forecast Total Available Balance         *
      *             Calculation                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD032099           Date 27Jan15               *
      *  Prev Amend No. MD031997           Date 22Jan15               *
      *                 CGL153             Date 05Feb14               *
      *                 MD024157           Date 19Dec13               *
      *                 MD024013           Date 12Dec13               *
      *                 MD023548           Date 20Nov13               *
      *                 CGL145B  *CREATE   Date 10Jul13               *
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
      *  MD024157 - Available Balance column in ABC PDC box displays  *
      *             an erroneous amount                               *
      *  MD024013 - Conversion rate not correct                       *
      *  MD023548 - WDAYF too small to hold the result                *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FGLACNTL3  IF   E           K DISK
      ** Midas GL Account Extension File
 
     FGLFTABI0  UF A E           K DISK
      ** Midas OF Forecast Total Available Balance
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Local Data Area for database error details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Account
     D KAccnt          DS
     D  KBRCA                  1      3
     D  KCNUM                  4      9
     D  KCCY                  10     12
     D  KACOD                 13     22  0
     D  KACSQ                 23     24  0
 
     D                 DS
     D  F1DAT0                 1      3P 0
     D  F1DAT1                 4      6P 0
     D  F1DAT2                 7      9P 0
     D  F1DAT3                10     12P 0
     D  F1DAT4                13     15P 0
     D  F1DAT5                16     18P 0
     D  F1DAT6                19     21P 0
     D  F1DAT7                22     24P 0
     D  F1DAT8                25     27P 0
     D  F1DAT9                28     30P 0
     D  F1DATS                 1     30P 0
     D                                     DIM(10) ASCEND
 
     D                 DS
     D  FBDAT0                 1      5  0
     D  FBDAT1                 6     10  0
     D  FBDAT2                11     15  0
     D  FBDAT3                16     20  0
     D  FBDAT4                21     25  0
     D  FBDAT5                26     30  0
     D  FBDAT6                31     35  0
     D  FBDAT7                36     40  0
     D  FBDAT8                41     45  0
     D  FBDAT9                46     50  0
     D  FBDATS                 1     50  0
     D                                     DIM(10) ASCEND
 
     DForeBal          DS
     D  FBFTB0                 1     15  0
     D  FBFTB1                16     30  0
     D  FBFTB2                31     45  0
     D  FBFTB3                46     60  0
     D  FBFTB4                61     75  0
     D  FBFTB5                76     90  0
     D  FBFTB6                91    105  0
     D  FBFTB7               106    120  0
     D  FBFTB8               121    135  0
     D  FBFTB9               136    150  0
     D  FBFTBS                 1    150  0
     D                                     DIM(10) ASCEND
 
     D Param           DS
     D  PActCode               1      1
     D  PStatus                2     11
     D  PBranch               12     14
     D  PCust                 15     20
     D  PCurr                 21     23
     D  PACOD                 24     33  0
     D  PACSQ                 34     35  0
     D  PFCurr                36     38
     D  PFDate                39     43  0
     D  PFAmt                 44     58
     D  PAAmt                 59     73
     D  PAAZero               74     74
     D  PAProjRet             75     75
     D  POFAmt                76     90
     D  POAAmt                91    105
     D  POAZero              106    106
     D  POProjRet            107    107
     D  PNostroCode          108    109                                                       CGL153
     D  PAProjNos            110    110                                                       CGL153
     D  POProjNos            111    111                                                       CGL153
     D**Filler**             108    500                                                       CGL153
     D**Filler**             112    500                                              CGL153 MD032099
     D  PAutoAuth            112    112                                                     MD032099
     D  Filler               113    500                                                     MD032099
     D  PAccnt                12     35
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PCcy            S              3
                                                                                            MD024013
      ** Paramaters for ZXRATE                                                              MD024013
     D  ZRATE1         S             13P 8                                                  MD024013
     D  ZMDI1          S              1A                                                    MD024013
     D  ZRATE2         S             13P 8                                                  MD024013
     D  ZMDI2          S              1A                                                    MD024013
     D  ZRATEX         S             13P 8                                                  MD024013
     D  ZMDIX          S              1A                                                    MD024013
 
      ** Parameters for ZCONVZ1
     D ZEXCH           S             13  8                                                  MD024013
     D ZMD             S              1                                                     MD024013
     D PAmnt           S             15  0
     D PFrXRate        S             13  8
     D PFrMDIn         S              1
     D PFrCCY          S              3
     D PToCCY          S              3
     D PFrDecPlace     S              1  0
     D PToDecPlace     S              1  0
     D POutAmt         S             15  0
 
      ** Other fields used
     D X               S              2  0
     D WRun            S              1A   Inz
     D ABCCR           S              1A
     D ABCDR           S              1A
     D WkProcType      S              1A
     D***WDayF**         S              1  0                                                MD023548
     D WDayF           S              2  0                                                  MD023548
     D WConvFAmt       S             15  0
     D WConvOFAmt      S             15  0
     D WFrXrate        S                   LIKE(A6SPRT)
     D WFrMDIn         S                   LIKE(A6MDIN)
     D WFrDecPlace     S                   LIKE(A6NBDP)
     D WToXrate        S                   LIKE(A6SPRT)                                     MD024013
     D WToMDIn         S                   LIKE(A6MDIN)                                     MD024013
     D WToDecPlace     S                   LIKE(A6NBDP)
     D WFAmt           S             15  0
     D WAAmt           S             15  0
     D WOFAmt          S             15  0
     D WOAAmt          S             15  0
     D PSysVal         S             20    DIM(10)
     D PCurSet         S            200    DIM(10)
                                                                                            MD031997
      ** Forecast Include Unmatched in Projected Balance                                    MD031997
     D WFIUPB          S              1A                                                    MD031997
 
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
 
     C                   EVAL      KAccnt = PAccnt
 
      ** Access record from the account extenstion file
 
     C     KAccnt2       CHAIN     GLACNTL3
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = KAccnt
     C                   EVAL      DBFile = 'GLACNTQD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      FBBRCA = KBRCA
     C                   EVAL      FBCNUM = KCNUM
     C                   EVAL      FBCCY  = KCCY
     C                   EVAL      FBACOD = KACOD
     C                   EVAL      FBACSQ = KACSQ
     C                   ENDIF
 
      ** Access record Forecast Total Available Balance
 
     C     KAccnt1       CHAIN     GLFTABI0
 
     C                   IF        NOT%FOUND
     C                   EVAL      FBFTBS = *ZEROS
     C                   ENDIF
 
      ** Set Forecast Dates from Available balance dates
 
     C                   EVAL      X = 1
     C                   DOW       X <= 10
     C                   EVAL      FBDATS(X) = F1DATS(X)
     C                   EVAL      X = X + 1
     C                   ENDDO
 
      ** Convert Forecast Amount to Account Currency
 
     C                   IF        KCCY <> PFCurr
     C                   EXSR      SRConvert
     C                   ELSE
     C                   EVAL      WConvFAmt  = WFAmt
     C                   EVAL      WConvOFAmt = WOFAmt
     C                   ENDIF
 
      ** Compute for Forecast Total Available Balance
 
     C                   EXSR      SRForeBal
 
      ** Update file
 
     C                   IF        %FOUND
     C                   IF        PActCode = 'A' or  PActCode = 'D'                        MD031997
     C                   IF        WFIUPB = 'N' And PFDATE < BJRDNB                         MD031997
     C                   GOTO      NoUpdate                                                 MD031997
     C                   ENDIF                                                              MD031997
     C                   ENDIF                                                              MD031997
     C                   UPDATE    GLFTABD0
     C                   ELSE
     C                   WRITE     GLFTABD0
     C                   ENDIF
     C     NoUpdate      TAG                                                                MD031997
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvert - Convert Forecast Amount to Account Currency      *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR
 
      ** Retrieve currency details for FROM currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      PFCurr        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PFCurr
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WFrXrate = A6SPRT
     C                   EVAL      WFrMDIn  = A6MDIN
     C                   EVAL      WFrDecPlace = A6NBDP
     C                   ENDIF
 
      ** Retrieve currency details for TO   currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      KCCY          PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = KCCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WToXrate = A6SPRT                                        MD024013
     C                   EVAL      WToMDIn  = A6MDIN                                        MD024013
     C                   EVAL      WToDecPlace = A6NBDP
     C                   ENDIF
 
     C                   Z-ADD     WFrXrate      ZRATE1                                     MD024013
     C                   MOVE      WFrMDIn       ZMDI1                                      MD024013
     C                   Z-ADD     WToXrate      ZRATE2                                     MD024013
     C                   MOVE      WToMDIn       ZMDI2                                      MD024013
     C                   CALL      'ZXRATE'                                                 MD024013
     C                   PARM                    ZRATE1                                     MD024013
     C                   PARM                    ZMDI1                                      MD024013
     C                   PARM                    ZRATE2                                     MD024013
     C                   PARM                    ZMDI2                                      MD024013
     C                   PARM                    ZRATEX                                     MD024013
     C                   PARM                    ZMDIX                                      MD024013
                                                                                            MD024013
     C                   Z-ADD     ZRATEX        ZEXCH                                      MD024013
     C                   MOVE      ZMDIX         ZMD                                        MD024013
      *                                                                                     MD024013
      ** Convert Forecast Amount
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      WFAmt         PAmnt
     C**********         PARM      WFrXRate      PFrXRate                                   MD024013
     C**********         PARM      WFrMDIn       PFrMDIn                                    MD024013
     C                   PARM                    Zexch                                      MD024013
     C                   PARM                    Zmd                                        MD024013
     C                   PARM      PFCurr        PFrCCY
     C                   PARM      KCCY          PToCCY
     C                   PARM      WFrDecPlace   PFrDecPlace
     C                   PARM      WToDecPlace   PToDecPlace
     C                   PARM                    POutAmt
 
     C                   EVAL      WConvFAmt = POutAmt
 
      ** Convert Original Forecast Amount
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      WOFAmt        PAmnt
     C**********         PARM      WFrXRate      PFrXRate                                   MD024013
     C**********         PARM      WFrMDIn       PFrMDIn                                    MD024013
     C                   PARM                    Zexch                                      MD024013
     C                   PARM                    Zmd                                        MD024013
     C                   PARM      PFCurr        PFrCCY
     C                   PARM      KCCY          PToCCY
     C                   PARM      WFrDecPlace   PFrDecPlace
     C                   PARM      WToDecPlace   PToDecPlace
     C                   PARM                    POutAmt
 
     C                   EVAL      WConvOFAmt = POutAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRForeBal - Calculate the Forecast Total Balance             *
      *                                                               *
      *****************************************************************
     C     SRForeBal     BEGSR
 
      ** Set Processing type
 
     C                   IF        WFAmt < 0
     C                   EVAL      WkProcType = ABCDR
     C                   ELSE
     C                   EVAL      WkProcType = ABCCR
     C                   ENDIF
 
      ** Update Balances
 
     C                   EVAL      X = 1
 
     C                   DOW       X <= WDayF
 
     C                   IF        PAProjRet = 'Y'
     C                             OR  PAProjRet = 'N'
     C                             AND POProjRet = 'Y'
 
     C                   SELECT
 
     C                   WHEN      WKProcType = '1'
     C                   EXSR      SRCalFBal
 
     C                   WHEN      WKProcType = '2'
     C                   IF        PFDate <= FBDATS(X)
     C                   EXSR      SRCalFBal
     C                   ENDIF
 
     C                   WHEN      WKProcType = '3'
     C                   IF        PFDate <= BJRDNB
     C                   EXSR      SRCalFBal
     C                   ENDIF
 
     C                   WHEN      WKProcType = '4'
     C                   ENDSL
     C                   ENDIF
 
     C                   ADD       1             X
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalFBal - Subroutine to Calculate Forecast Balance         *
      *                                                               *
      *****************************************************************
     C     SRCalFBal     BEGSR
 
      ** Update Forecast Balance for Debit Transaction on WIP or
      ** Credit Transaction on Authorise or
      ** Rejected Debit Transactions
 
     C                   IF        PStatus = 'COMPLETE' AND WFAmt < 0
     C                             OR PStatus = 'AUTHORISE' AND WFAmt > 0
 
     C                   SELECT
 
      ** On Insert: add up the forecast amount
 
     C                   WHEN      PActCode = 'I'
     C                   IF        WAAmt = *Zero
     C                             AND PAAZero <> 'Y'                                       MD024157
     C                   EVAL      FBFTBS(X)  = FBFTBS(X)  + WConvFAmt
     C                   ENDIF
 
      ** On Amend:
      ** If forecast amount was changed remove the original forecast amount
      **    and add the new forcast amount
      ** If Actual Amount is changed OR Project on Retail flag is changed
      **    from 'Y' to 'N', reduce the original forecast amount
      ** If Project on Retail flag is changed from 'N' to 'Y', add forecast
      **    amount
 
     C                   WHEN      PActCode = 'A'
     C                   IF        WFIUPB = 'N' And PFDate < BJRDNB                         MD031997
     C                   LEAVESR                                                            MD031997
     C                   ENDIF                                                              MD031997
     C                   IF        WAAmt = *ZERO and WOAAmt = *ZERO
     C                             AND PAProjRet = 'Y'                                      MD024157
     C                             AND PAAZero <> 'Y'                                       MD024157
     C                   EVAL      FBFTBS(X)  = FBFTBS(X)  + WConvFAmt
     C**********         EVAL      FBFTBS(X)  = FBFTBS(X) - WConvOFAmt                      MD024157
     C                   ENDIF
     C**********         IF        WAAmt <> *ZERO and WOAAmt = *ZERO                        MD024157
     C**********                   OR PAProjRet = 'N' AND POProjRet = 'Y'                   MD024157
     C                   IF        WOAAmt = *ZERO AND POProjRet = 'Y'                       MD024157
     C                   EVAL      FBFTBS(X)  = FBFTBS(X) - WConvOFAmt
     C                   ENDIF
     C**********         IF        PAProjRet = 'Y' AND POProjRet = 'N'                      MD024157
     C**********         EVAL      FBFTBS(X)  = FBFTBS(X)  + WConvFAmt                      MD024157
     C**********         ENDIF                                                              MD024157
 
      ** On delete: reduce the forecast amount
 
     C                   WHEN      PActCode = 'D'
     C                   IF        WFIUPB = 'N' And PFDate < BJRDNB                         MD031997
     C                   LEAVESR                                                            MD031997
     C                   ENDIF                                                              MD031997
     C                   IF        WAAmt = *Zero
     C                   EVAL      FBFTBS(X)  = FBFTBS(X)  - WConvFAmt
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** Update Forecast Balance when transaction if rejected
 
     C                   IF        PStatus = 'REJECT' AND WFAmt < 0
     C                   IF        PActCode = 'I' OR PActCode = 'A'
     C                   EVAL      FBFTBS(X)  = FBFTBS(X)  - WConvFAmt
     C                   ELSE
     C                   EVAL      FBFTBS(X)  = FBFTBS(X)  + WConvFAmt
     C                   ENDIF
     C                   IF        PActCode = 'A'
     C                   EVAL      FBFTBS(X)  = FBFTBS(X)  + WConvOFAmt
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
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PSysVal(1) = 'ABCForecastDR'
     C                   EVAL      PSysVal(2) = 'ABCForecastCR'
     C                   EVAL      PSysVal(3) = 'ABCNoDaysForward'
     C                   EVAL      PSysVal(4) = 'ForecastIncUnmatched'                      MD031997
 
      ** Retrieve System Values
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PSysVal(1)
     C                   PARM                    PCurSet(1)
     C                   PARM                    PSysVal(2)
     C                   PARM                    PCurSet(2)
     C                   PARM                    PSysVal(3)
     C                   PARM                    PCurSet(3)
     C                   PARM                    PSysVal(4)
     C                   PARM                    PCurSet(4)
     C                   PARM                    PSysVal(5)
     C                   PARM                    PCurSet(5)
     C                   PARM                    PSysVal(6)
     C                   PARM                    PCurSet(6)
     C                   PARM                    PSysVal(7)
     C                   PARM                    PCurSet(7)
     C                   PARM                    PSysVal(8)
     C                   PARM                    PCurSet(8)
     C                   PARM                    PSysVal(9)
     C                   PARM                    PCurSet(9)
     C                   PARM                    PSysVal(10)
     C                   PARM                    PCurSet(10)
 
      ** Check if database error occured
 
     C                   FOR       X = 1 TO 10
 
     C                   IF        PCurSet(X) = '*NRF'
     C                                      OR
     C                             PRTCD <> *BLANKS
     C                               AND PRTCD <> '*NRF'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY   = PSysVal(X)
     C                   EVAL      DBFILE  = 'SDSVALPD'
     C                   EVAL      DBASE   = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   EVAL      ABCDR = PCurSet(1)
     C                   EVAL      ABCCR = PCurSet(2)
     C                   EVAL      WDayF = %INT(%TRIM(PCurSet(3))) + 1
     C                   EVAL      WFIUPB = PCurSet(4)                                      MD031997
 
      ** Initialize amount fields if blanks
 
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
 
     C     KAccnt1       KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
 
     C     KAccnt2       KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
 
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
